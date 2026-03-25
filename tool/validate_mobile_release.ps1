param(
    [switch]$UseTemporarySigningKey
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Label,
        [Parameter(Mandatory = $true)]
        [scriptblock]$Command
    )

    Write-Host $Label
    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Label failed with exit code $LASTEXITCODE."
    }
}

function Resolve-KeytoolPath {
    $candidates = @()

    if ($env:JAVA_HOME) {
        $candidates += (Join-Path $env:JAVA_HOME "bin\keytool.exe")
    }

    $candidates += @(
        "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
        "C:\Program Files\Android\openjdk\jdk-21.0.8\bin\keytool.exe"
    )

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path $candidate)) {
            return $candidate
        }
    }

    $command = Get-Command "keytool.exe" -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    throw "Unable to find keytool.exe. Set JAVA_HOME or install a JDK with keytool."
}

function Test-AndroidSigningConfigured {
    $hasSigningEnv =
        $env:ANDROID_KEYSTORE_PATH -and
        $env:ANDROID_KEYSTORE_PASSWORD -and
        $env:ANDROID_KEY_ALIAS -and
        $env:ANDROID_KEY_PASSWORD

    return $hasSigningEnv -or (Test-Path "android\key.properties")
}

function Initialize-TemporarySigningKey {
    $tempDir = Join-Path ".codex_tmp" "mobile-validation"
    $keystorePath = Join-Path $tempDir "chordest-upload.jks"
    $keytoolPath = Resolve-KeytoolPath

    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    if (Test-Path $keystorePath) {
        Remove-Item $keystorePath -Force
    }

    Invoke-Step "Generating temporary Android upload keystore for validation..." {
        & $keytoolPath -genkeypair -v `
            -storetype PKCS12 `
            -keystore $keystorePath `
            -alias upload `
            -keyalg RSA `
            -keysize 2048 `
            -validity 3650 `
            -storepass ci-build-pass `
            -keypass ci-build-pass `
            -dname "CN=Local Validation, OU=Automation, O=Saintimulus OSS, L=Seoul, S=Seoul, C=KR"
    }

    $resolvedKeystorePath = (Resolve-Path $keystorePath).Path
    $env:ANDROID_KEYSTORE_PATH = $resolvedKeystorePath
    $env:ANDROID_KEYSTORE_PASSWORD = "ci-build-pass"
    $env:ANDROID_KEY_ALIAS = "upload"
    $env:ANDROID_KEY_PASSWORD = "ci-build-pass"
}

if ($UseTemporarySigningKey -and -not (Test-AndroidSigningConfigured)) {
    Initialize-TemporarySigningKey
}

Invoke-Step "Running Flutter analyze..." { flutter analyze }
Invoke-Step "Running Flutter tests..." { flutter test }
Invoke-Step "Validating store metadata lengths..." { python tool/validate_store_metadata.py }
Invoke-Step "Checking store locale coverage..." { python tool/validate_store_locale_coverage.py }
Invoke-Step "Running mobile launch audit..." { python tool/mobile_launch_audit.py }

if (Test-AndroidSigningConfigured) {
    Invoke-Step "Building Android release app bundle..." {
        flutter build appbundle --release
    }
} else {
    Write-Host "Skipping Android release bundle build because signing env vars are not set."
}

Invoke-Step "Building release web bundle..." { flutter build web --release }
