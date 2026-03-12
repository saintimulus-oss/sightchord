# SightChord

SightChord is a Flutter chord-practice app for improvisation, reading, and harmonic vocabulary work.

Live demo: [saintimulus-oss.github.io/sightchord](https://saintimulus-oss.github.io/sightchord/)

## Features

- Free mode across all 12 roots
- Key mode with diatonic Roman numerals
- Smart Generator mode with weighted harmonic motion
- Chord Analyzer with key-center, Roman numeral, harmonic-function, and summary output
- Secondary dominants, substitute dominants, and modal interchange
- Chord symbol styles: `Compact`, `MajText`, `DeltaJazz`
- Tensions, `V7sus4`, and slash-bass inversions
- Previous / current / next chord preview
- Metronome, autoplay, BPM control, and keyboard shortcuts
- Localization for English, Spanish, Simplified Chinese, Japanese, and Korean

## Run

```bash
flutter pub get
flutter run
```

## Validate

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build web --release --base-href /sightchord/
```

For GitHub Pages project sites, the workflow auto-detects the repository name and sets the correct `base-href`. If the repository is a user or org Pages repository such as `owner.github.io`, it builds with `/`.

## Repository Hygiene

- Source-controlled: `lib/`, `web/`, `assets/` source assets, `test/`, `docs/`, `tool/`, and workflow files.
- Generated or machine-local: `build/`, `.dart_tool/`, `.appdata/`, logs, scratch files, browser/profile data, `android/local.properties`, and root-level Flutter web outputs such as `main.dart.js`, `flutter*.js`, `canvaskit/`, `icons/`, and generated `assets/` manifests.
- GitHub Pages deploys from CI-uploaded `build/web` artifacts, not from hand-maintained generated files at the repository root.

## Structure

```text
lib/
  app.dart                               # public barrel for app entry points
  app_bootstrap.dart                     # startup and settings load
  app_shell.dart                         # MaterialApp, theme, localization
  main_menu_page.dart                    # launcher and language sheet
  practice_home_page.dart                # practice state, generation, playback
  practice_home_page_labels.dart         # practice labels/formatting helpers
  practice_home_page_ui.dart             # practice screen composition
  chord_analyzer_page.dart               # public barrel
  chord_analyzer_page_view.dart          # analyzer page state and composition
  chord_analyzer_page_sections.dart      # analyzer result widgets
  smart_generator.dart                   # public barrel
  smart_generator_core.dart              # planning engine
  smart_generator_diagnostics.dart       # diagnostics and trace helpers
  music/voicing_engine.dart              # public barrel
  music/voicing_engine_core.dart         # voicing engine logic
  music/voicing_engine_support.dart      # voicing support models/helpers
  settings/practice_settings_drawer.dart # public barrel
  settings/practice_settings_drawer_view.dart

docs/
  architecture-overview.md
  codex-maintenance-plan.md
  developer-notes.md
```

## GitHub Pages

This repository uses `.github/workflows/deploy-pages.yml` with the standard Pages artifact flow:

1. Checkout
2. Configure Pages
3. Set up Flutter
4. `flutter pub get`
5. `flutter analyze`
6. `flutter test`
7. `flutter build web --release`
8. Upload the Pages artifact
9. Deploy with `actions/deploy-pages`

To publish:

1. Set GitHub Pages source to `GitHub Actions`.
2. Push the default branch or run the workflow manually from Actions.

## Notes

- Chord symbols, note names, Roman numeral tokens, tensions, and key names are not localized.
- Chord Generator and Chord Analyzer remain separate entry points from the main menu.
- Settings are persisted with `shared_preferences`.
- The metronome uses `assets/tick.mp3` through `audioplayers`.
- Architecture details and owner follow-ups live in [docs/architecture-overview.md](/Users/User/sightchord/docs/architecture-overview.md) and [docs/developer-notes.md](/Users/User/sightchord/docs/developer-notes.md).
