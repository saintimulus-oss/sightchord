# SightChord

SightChord is a Flutter chord practice app for improvisation, reading, and harmonic vocabulary work.

Live demo: https://saintimulus-oss.github.io/sightchord/

## Current Features

- Free mode across all 12 roots
- Key mode with diatonic Roman numerals
- Smart Generator mode with weighted harmonic motion
- Chord Analyzer with key-center, Roman numeral, harmonic-function, and summary output
- Secondary dominants, substitute dominants, and modal interchange
- Chord symbol styles: `Compact`, `MajText`, `DeltaJazz`
- Tensions, `V7sus4`, and slash-bass inversions
- Previous / current / next chord preview
- Metronome, autoplay, BPM control, and keyboard shortcuts
- Official Flutter localization for English, Espanol, Simplified Chinese, Japanese, and Korean

## Run

```bash
flutter pub get
flutter run
```

## Verify

```bash
flutter analyze
flutter test
flutter build web --release --base-href /sightchord/
```

For GitHub Pages project sites, the workflow auto-detects the repository name and sets the correct `base-href`. If the repository is a user/org Pages repository such as `owner.github.io`, it will build with `/`.

## GitHub Pages

This repository includes `.github/workflows/deploy-pages.yml` using the official Pages custom workflow flow:

1. Checkout
2. Configure Pages
3. Set up Flutter
4. `flutter pub get`
5. `flutter analyze`
6. `flutter test`
7. `flutter build web --release`
8. Upload the Pages artifact
9. Deploy with `actions/deploy-pages`

Live GitHub Pages URL for this repository:

- `https://saintimulus-oss.github.io/sightchord/`

To publish:

1. In GitHub repository settings, set Pages source to `GitHub Actions`.
2. Push the default branch or run the workflow manually from Actions.

## Notes

- Chord symbols, note names, Roman numeral tokens, tensions, and key names are not localized.
- Chord Generator and Chord Analyzer are exposed as separate entry points from the main menu.
- Settings are persisted with `shared_preferences`.
- The metronome uses `assets/tick.mp3` through `audioplayers`.
