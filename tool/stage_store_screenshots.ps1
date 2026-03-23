$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root "output\\playwright"
$sourceCaptures = Join-Path $root "store\\assets\\source-captures"
$playPhone = Join-Path $root "store\\assets\\google-play\\phone-screenshots"
$iphone = Join-Path $root "store\\assets\\app-store\\iphone-screenshots"

foreach ($dir in @($sourceCaptures, $playPhone, $iphone)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

$files = @(
    "main-menu.png",
    "generator.png",
    "analyzer.png",
    "setup-assistant.png"
)

foreach ($file in $files) {
    $from = Join-Path $source $file
    if (Test-Path $from) {
        Copy-Item $from (Join-Path $sourceCaptures $file) -Force
        Copy-Item $from (Join-Path $playPhone $file) -Force
        Copy-Item $from (Join-Path $iphone $file) -Force
    }
}

Write-Host "Draft screenshots staged from output/playwright into store/assets."
