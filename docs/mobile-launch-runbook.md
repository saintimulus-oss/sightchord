# Chordest Mobile Launch Runbook

This runbook captures the repository work completed for Android and iOS launch preparation, plus the remaining manual steps that must be finished in Play Console, App Store Connect, and a macOS/Xcode environment.

## Hosted Launch URLs

- Privacy policy: `https://saintimulus-oss.github.io/privacy-policy.html`
- Support: `https://saintimulus-oss.github.io/support.html`
- Terms of use: `https://saintimulus-oss.github.io/terms.html`

These pages are source-controlled under `web/` and deploy with the existing GitHub Pages workflow.

## Submission Assets In Repo

- Submission checklist: `docs/store-submission-checklist.md`
- Google Play metadata: `store/google-play/en-US/`
- App Store metadata: `store/app-store/en-US/`
- Korean metadata drafts: `store/google-play/ko-KR/` and `store/app-store/ko/`
- Policy questionnaire drafts: `store/google-play/*.md` and `store/app-store/*.md`
- Manual mobile validation workflow: `.github/workflows/mobile-release-validate.yml`
- Local validation script: `tool/validate_mobile_release.ps1`
- Metadata length validator: `tool/validate_store_metadata.py`
- Screenshot staging script: `tool/stage_store_screenshots.ps1`
- Draft store asset folders: `store/assets/`
- Launch audit generator: `tool/mobile_launch_audit.py`
- Store locale coverage checker: `tool/validate_store_locale_coverage.py`
- Release package builder: `tool/package_mobile_release_artifacts.ps1`
- Locale planning matrix: `docs/store-localization-matrix.md`

## Repository Changes Included In This Pass

- Android release builds now require a real upload keystore instead of silently using the debug keystore.
- Added `android/key.properties.example` to document the expected signing keys.
- Added Android adaptive launcher icon XML resources.
- Restored a standard Flutter `ios/Podfile` for CocoaPods-based iOS dependency installation.
- Added hosted launch-policy pages for privacy, support, and terms.
- Added an iOS privacy manifest for the current local-preferences storage pattern.
- Added issue templates and store-asset staging folders so support and store-prep flows start from the repository.

## Android Release Steps

1. Create the permanent upload keystore.
2. Copy `android/key.properties.example` to `android/key.properties`.
3. Replace the placeholder values with the real keystore path, passwords, and alias.
4. Run:

```bash
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

5. In Play Console:
   - Create the app if it does not already exist.
   - Enroll in Play App Signing.
   - Upload the `.aab`.
   - Fill in Data safety, App content, age/content rating, and store listing metadata.
   - Set the support URL and privacy policy URL to the hosted pages above.

## iOS Release Steps

These steps still require macOS and Xcode and cannot be fully executed from this Windows environment.

1. On macOS, run:

```bash
flutter pub get
cd ios
pod install
open Runner.xcworkspace
```

2. In Xcode:
   - Select the `Runner` target.
   - Set the Apple Developer `Team`.
   - Confirm `Bundle Identifier` is final.
   - Confirm version and build numbers are final.
   - Confirm the bundled `PrivacyInfo.xcprivacy` still matches the generated archive and any updated plugins.
   - Archive the app.
   - Validate and upload to App Store Connect.

3. In App Store Connect:
   - Create the app record.
   - Add privacy details, age rating, support URL, and privacy policy URL.
   - Upload screenshots and app description text.
   - Run TestFlight before final review submission.

## Suggested Store Listing Copy

### App Name

`Chordest`

### Android Short Description

`Practice chords, harmony, and improvisation with smart progression tools.`

### Full Description

`Chordest is a local-first harmony practice app for improvisation, reading, and harmonic vocabulary work. Practice across all 12 roots, switch between free and key-aware generation, explore weighted harmonic motion with Smart Generator, and inspect progressions with the built-in Chord Analyzer. Chordest includes metronome and autoplay tools, multiple chord symbol styles, inversions, tensions, and localized UI for English, Spanish, Simplified Chinese, Japanese, and Korean.`

### App Store Subtitle

`Harmony and chord practice`

### App Store Promotional Notes

`Local-first chord practice for improvisation, reading, and harmonic vocabulary study.`

## Screenshot Plan

- Main menu
- Practice generator with chord preview
- Smart Generator progression view
- Chord Analyzer result view
- Study Harmony hub or lesson surface
- Settings drawer with notation/playback controls

Capture one clean portrait set first, then add tablet/landscape variants only if the final store strategy needs them.

## Remaining Manual Items

- Permanent Android upload keystore ownership and secret storage
- Real-device Android smoke test on at least one phone and one tablet
- macOS/Xcode signing, archive, and TestFlight validation
- Final support email and any region-specific compliance text required by the store accounts
- Final verification of App Store privacy manifest requirements from the generated iOS archive
