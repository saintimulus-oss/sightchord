# SightChord Architecture Overview

## Current Status

SightChord is a cross-platform Flutter app focused on chord drilling, harmonic vocabulary, and progression analysis.

The repository now separates generated output from source code more clearly and exposes the main oversized features through narrower entry points:

- app bootstrap and shell are split from the practice screen
- the practice screen separates stateful logic from label/UI composition helpers
- the chord analyzer page separates state and result rendering
- the settings drawer is exposed through a stable barrel entry point
- the smart generator and voicing engine now expose public barrels backed by internal core/support files

## Source Layout

```text
lib/
  main.dart

  app.dart
  app_bootstrap.dart
  app_shell.dart
  main_menu_page.dart
  practice_home_page.dart
  practice_home_page_labels.dart
  practice_home_page_ui.dart

  chord_analyzer_page.dart
  chord_analyzer_page_view.dart
  chord_analyzer_page_sections.dart

  smart_generator.dart
  smart_generator_core.dart
  smart_generator_diagnostics.dart
  music/smart_generator_models.dart
  music/smart_generator_legacy_priors.dart
  music/priors/*

  music/voicing_engine.dart
  music/voicing_engine_core.dart
  music/voicing_engine_support.dart
  music/voicing_models.dart

  music/chord_theory.dart
  music/chord_formatting.dart
  music/progression_parser.dart
  music/progression_analyzer.dart
  music/progression_explainer.dart

  settings/practice_settings.dart
  settings/practice_settings_drawer.dart
  settings/practice_settings_drawer_view.dart
  settings/settings_controller.dart

test/
  progression_analyzer_test.dart
  smart_generator_test.dart
  settings_controller_test.dart
  settings_voicing_load_test.dart
  ...

docs/
  architecture-overview.md
  codex-maintenance-plan.md
  developer-notes.md
```

## Runtime Flow

1. `lib/main.dart` calls `bootstrapApp()`.
2. `bootstrapApp()` loads persisted settings through `AppSettingsController.load()`.
3. `MyApp` configures localization, theme, and the top-level routes/screens.
4. `MainMenuPage` lets the user launch either the practice flow or the analyzer flow.
5. `MyHomePage` owns live practice state: chord queue, smart planning handoff, metronome/autoplay timing, and voicing recommendations.
6. `ChordAnalyzerPage` parses a progression, analyzes key/function candidates, and renders summary plus measure-by-measure diagnostics.

## Main Modules

### App shell and practice flow

- `lib/app.dart` is the public entry barrel used by `main.dart`.
- `lib/app_bootstrap.dart` handles startup and persisted settings load.
- `lib/app_shell.dart` owns `MaterialApp`, theme, and localization.
- `lib/practice_home_page.dart` keeps practice-session state, queue promotion, smart-generation dispatch, metronome scheduling, and voicing recomputation.
- `lib/practice_home_page_labels.dart` contains user-facing practice labels and key-center formatting helpers.
- `lib/practice_home_page_ui.dart` contains the practice screen composition and BPM controls.

### Settings and persistence

- `lib/settings/practice_settings.dart` is the immutable configuration snapshot.
- `lib/settings/settings_controller.dart` loads and saves settings through `shared_preferences`.
- `lib/settings/practice_settings_drawer.dart` is the stable import surface for the settings UI.
- `lib/settings/practice_settings_drawer_view.dart` renders the drawer controls for language, metronome, harmony generation, voicing, and inversions.

### Progression analysis

- `lib/music/progression_parser.dart` tokenizes and validates progression input.
- `lib/music/progression_analyzer.dart` scores key-center and harmonic-function interpretations.
- `lib/music/progression_explainer.dart` turns analysis output into concise user-facing summaries.
- `lib/chord_analyzer_page_view.dart` owns analyzer-page state and orchestration.
- `lib/chord_analyzer_page_sections.dart` renders reusable analyzer cards, rows, and confidence displays.

### Smart generation

- `lib/smart_generator.dart` is the public import surface.
- `lib/smart_generator_core.dart` contains the main planning engine, fallback logic, family selection, and simulation entry points.
- `lib/smart_generator_diagnostics.dart` contains trace collection and diagnostics helpers.
- `lib/music/priors/*` and generated prior tables keep weighted transition/profile data out of the public entry file.

### Voicing engine

- `lib/music/voicing_engine.dart` is the public import surface.
- `lib/music/voicing_engine_core.dart` interprets chord symbols, generates candidate voicings, scores transitions, and ranks suggestions.
- `lib/music/voicing_engine_support.dart` contains progression context, templates, and transition-score support types.

## Validation

Preferred local validation commands:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build web --release --base-href /sightchord/
```

The GitHub Pages workflow follows the same source-of-truth model: CI builds `build/web`, uploads that artifact, and deploys it through Pages. Generated web output at the repository root is intentionally not treated as maintained source.

## Current Tradeoffs

- `lib/smart_generator_core.dart` still contains the densest musical-planning logic. Public entry points and diagnostics/priors are separated now, but deeper extraction inside the planner is still a future maintainability opportunity.
- `lib/music/voicing_engine_core.dart` remains the largest single theory/heuristics file because candidate realization, scoring, and spelling logic are still tightly coupled.
- `lib/settings/practice_settings_drawer_view.dart` still carries a broad set of controls, but it now sits behind a stable barrel and no longer shares a file with unrelated app bootstrap concerns.
