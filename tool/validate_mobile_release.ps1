$ErrorActionPreference = "Stop"

Write-Host "Running Flutter analyze..."
flutter analyze

Write-Host "Running Flutter tests..."
flutter test

Write-Host "Validating store metadata lengths..."
python tool/validate_store_metadata.py

Write-Host "Checking store locale coverage..."
python tool/validate_store_locale_coverage.py

Write-Host "Running mobile launch audit..."
python tool/mobile_launch_audit.py

if (
    $env:ANDROID_KEYSTORE_PATH -and
    $env:ANDROID_KEYSTORE_PASSWORD -and
    $env:ANDROID_KEY_ALIAS -and
    $env:ANDROID_KEY_PASSWORD
) {
    Write-Host "Building Android release app bundle..."
    flutter build appbundle --release
} else {
    Write-Host "Skipping Android release bundle build because signing env vars are not set."
}

Write-Host "Building release web bundle..."
flutter build web --release
