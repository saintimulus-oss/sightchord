# Store Asset Staging

This directory holds draft and final assets used for Google Play and App Store submissions.

## Structure

- `source-captures/`: raw captures copied from local automation or manual device capture sessions
- `google-play/`: Android-specific marketing assets
- `app-store/`: iOS-specific screenshots and supporting assets

## Workflow

1. Capture clean screenshots from the latest release candidate build.
2. Place the untouched source files in `source-captures/`.
3. Export or resize final store-ready assets into the platform-specific folders.
4. Keep file names descriptive and stable so store submissions can be repeated quickly.

## Notes

- The screenshots currently staged here are drafts copied from `output/playwright/`.
- Replace them with real device captures before the final production launch.
