# SightChord

SightChord is a cross-platform Flutter app for improvisation and harmony practice. It generates random chords, supports key-based diatonic practice, and can advance automatically with a metronome-driven pulse.

## Current Features

- Random chord generation with cleaner enharmonic spelling
- Key-based generation using diatonic Roman numerals
- Optional `Secondary Dominant` and `Substitute Dominant` pools
- Previous / current / next chord preview
- Auto-advance mode with BPM control and metronome volume
- Keyboard shortcuts for desktop and web

## Keyboard Shortcuts

- `Space`: next chord
- `Enter`: start or stop auto-advance
- `Up / Down`: raise or lower BPM by 5

## Run

```bash
flutter pub get
flutter run
```

## Deploy to GitHub Pages

This repository includes a GitHub Actions workflow at `.github/workflows/deploy-pages.yml`.

To publish the Flutter web app to `https://saintimulus-oss.github.io/sightchord/`:

```bash
flutter build web --release --base-href /sightchord/
```

Then push to `main`. The workflow will rebuild the app and deploy `build/web` to GitHub Pages.

In the GitHub repository settings, make sure Pages is configured to use `GitHub Actions` as the source.

## Notes

- The metronome uses `assets/tick.mp3` through `audioplayers`.
- Widget tests now target the actual practice UI instead of the default Flutter counter template.
