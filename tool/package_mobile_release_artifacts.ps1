$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$packageRoot = Join-Path $root "output\\release_package"

if (Test-Path $packageRoot) {
    Remove-Item $packageRoot -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $packageRoot | Out-Null

$copyTargets = @(
    "docs\\mobile-launch-runbook.md",
    "docs\\store-submission-checklist.md",
    "docs\\device-qa-matrix.md",
    "docs\\store-localization-matrix.md",
    "store",
    "web\\privacy-policy.html",
    "web\\support.html",
    "web\\terms.html",
    "output\\mobile_launch_audit"
)

foreach ($relative in $copyTargets) {
    $source = Join-Path $root $relative
    if (Test-Path $source) {
        $destination = Join-Path $packageRoot $relative
        $destinationParent = Split-Path -Parent $destination
        if ($destinationParent) {
            New-Item -ItemType Directory -Force -Path $destinationParent | Out-Null
        }
        Copy-Item $source $destination -Recurse -Force
    }
}

$aab = Join-Path $root "build\\app\\outputs\\bundle\\release\\app-release.aab"
if (Test-Path $aab) {
    New-Item -ItemType Directory -Force -Path (Join-Path $packageRoot "artifacts") | Out-Null
    Copy-Item $aab (Join-Path $packageRoot "artifacts\\app-release.aab") -Force
}

$readme = @"
# Release Package

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")

Contents:
- Launch runbook
- Store submission checklist
- Device QA matrix
- Store localization matrix
- Store metadata and policy drafts
- Hosted policy pages
- Launch audit reports
- Android app bundle if already built locally

This folder is intended as a handoff bundle for final store submission work.
"@

$readme | Set-Content -Path (Join-Path $packageRoot "README.md") -Encoding UTF8

Write-Host "Release package created at $packageRoot"
