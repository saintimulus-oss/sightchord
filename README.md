# Chordest

Chordest is a Flutter chord-practice app for improvisation, reading, and harmonic vocabulary work.

Live demo: [saintimulus-oss.github.io](https://saintimulus-oss.github.io/)

Launch policy pages:

- Privacy policy: [saintimulus-oss.github.io/privacy-policy.html](https://saintimulus-oss.github.io/privacy-policy.html)
- Support: [saintimulus-oss.github.io/support.html](https://saintimulus-oss.github.io/support.html)
- Terms of use: [saintimulus-oss.github.io/terms.html](https://saintimulus-oss.github.io/terms.html)

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
flutter build web --release --base-href /
```

## Mobile Release

Android release signing now expects a real upload keystore via `android/key.properties` or environment variables. Start from [android/key.properties.example](android/key.properties.example) and keep the real keystore outside version control.

For the full launch checklist, store copy, and the remaining macOS/Xcode-only iOS steps, see [docs/mobile-launch-runbook.md](docs/mobile-launch-runbook.md).

The repository also includes store submission text templates in [store/google-play/en-US](store/google-play/en-US) and [store/app-store/en-US](store/app-store/en-US), plus a manual mobile validation workflow at [.github/workflows/mobile-release-validate.yml](.github/workflows/mobile-release-validate.yml).

For local release validation on Windows, run [tool/validate_mobile_release.ps1](tool/validate_mobile_release.ps1). Store metadata length checks also run independently via [tool/validate_store_metadata.py](tool/validate_store_metadata.py).

Draft store screenshots can be staged from the current Playwright captures with [tool/stage_store_screenshots.ps1](tool/stage_store_screenshots.ps1), and issue intake is standardized through the templates under [.github/ISSUE_TEMPLATE](.github/ISSUE_TEMPLATE).

Store locale coverage can be checked with [tool/validate_store_locale_coverage.py](tool/validate_store_locale_coverage.py), and a submission handoff bundle can be assembled with [tool/package_mobile_release_artifacts.ps1](tool/package_mobile_release_artifacts.ps1).

For GitHub Pages project sites, the workflow auto-detects the repository name and sets the correct `base-href`. If the repository is a user or org Pages repository such as `owner.github.io`, it builds with `/`.

For local parity with the current project-site deployment, you can also run:

```bash
flutter build web --release --base-href /chordest/
```

## Repository Hygiene

- Source-controlled: `lib/`, `web/`, `assets/` source assets, `test/`, `docs/`, `tool/`, and workflow files.
- Source of truth for web shell assets: `web/`.
- Source of truth for Pages deploy output: CI-built `build/web` uploaded as the GitHub Pages artifact.
- Not source of truth: reproducible Flutter web output copied into the repository root such as root `index.html`, `manifest.json`, `flutter*.js`, `main.dart.js*`, `version.json`, `canvaskit/`, `icons/`, and generated root `assets/` manifests.
- Generated or machine-local: `build/`, `.dart_tool/`, `.appdata/`, logs, scratch files, browser/profile data, `android/local.properties`, and any reproducible deploy output outside `web/`.
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

web/
  index.html                            # source web entry shell
  manifest.json                         # source PWA manifest
  icons/*                               # source web icons

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

The workflow deploys only `build/web`. Root-level generated Flutter web files are intentionally ignored and are not part of the deployment contract.

To publish:

1. Set GitHub Pages source to `GitHub Actions`.
2. Push the default branch or run the workflow manually from Actions.

## Notes

- Default chord symbol semantics stay unchanged, but note naming, key labels, and optional Roman numeral / chord-text assists can now be switched independently from the app UI locale.
- Chord Generator and Chord Analyzer remain separate entry points from the main menu.
- Settings are persisted with `shared_preferences`.
- The metronome uses `assets/tick.mp3` through `audioplayers`.
- Architecture details and owner follow-ups live in [docs/architecture-overview.md](docs/architecture-overview.md) and [docs/developer-notes.md](docs/developer-notes.md).
