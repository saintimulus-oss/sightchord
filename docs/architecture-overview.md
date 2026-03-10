# SightChord Architecture Overview

## Current Status

SightChord is a cross-platform Flutter chord practice app for improvisation,
reading, and harmonic vocabulary work.

The current codebase has moved well beyond a simple random chord generator:

- free mode works across all 12 roots
- key mode supports diatonic Roman numerals
- smart generator mode now includes weighted harmony planning
- applied dominants, tritone substitutions, modal interchange, and modulation
  families are implemented
- chord rendering supports multiple symbol styles, tensions, `V7sus4`, and
  inversions
- settings are persisted through `shared_preferences`
- localization is wired for English, Spanish, Simplified Chinese, Japanese,
  and Korean

Recent work is concentrated in the smart generator. The largest active area is
voice-leading aware rendering and fallback behavior, backed by expanded tests
and simulation QA utilities.

## Source Layout

```text
lib/
  main.dart                         # bootstrap entry point
  app.dart                          # app shell, practice screen, queue, audio/UI
  music/chord_theory.dart           # theory tables, enums, key/chord resolution
  music/chord_formatting.dart       # rendering, tensions, inversions, guard keys
  settings/practice_settings.dart   # immutable settings model
  settings/settings_controller.dart # persistence and change notifications
  smart_generator.dart              # progression planning, diagnostics, QA

test/
  chord_rendering_test.dart
  settings_controller_test.dart
  smart_generator_test.dart
  widget_test.dart

docs/
  architecture-overview.md

.github/workflows/
  deploy-pages.yml
```

## Runtime Flow

1. `lib/main.dart` calls `bootstrapApp()`.
2. `bootstrapApp()` loads persisted settings through
   `AppSettingsController.load()`.
3. `MyApp` rebuilds from the controller and configures localization and theme.
4. `MyHomePage` owns the live practice state:
   previous chord, current chord, next chord, autoplay timer, BPM, and drawer
   settings.
5. Chord generation chooses one of three paths:
   free mode, random key-aware mode, or smart generator mode.

### Smart Generator Path

The smart path is now the center of the project.

- `SmartGeneratorHelper.planInitialStep()` seeds the first harmonic event
- `SmartGeneratorHelper.planNextStep()` advances the progression
- `compareVoiceLeadingCandidates()` ranks rendered chord candidates before the
  UI shows one
- exclusion guards prevent immediate symbol or harmonic repeats
- family-aware fallbacks keep rejected smart plans musically related instead of
  dropping straight to an unrelated random chord
- diagnostics traces are recorded for debug and simulation summaries

## Main Modules

### `lib/app.dart`

Owns the application shell and practice experience:

- app bootstrap wiring after settings load
- previous/current/next queue management
- free mode, key mode, and smart mode dispatch
- metronome playback, autoplay timing, BPM editing, and keyboard shortcuts
- settings drawer and top-level UI

### `lib/music/chord_theory.dart`

Defines the musical domain model:

- Roman numeral identifiers and chord qualities
- key centers, modulation metadata, and dominant intent enums
- chord resolution helpers and spelling rules
- rendering-quality selection inputs used by the smart generator

### `lib/music/chord_formatting.dart`

Handles the surface form of the chord:

- symbol style formatting
- tension profile selection
- inversion rendering
- non-diatonic rendering flags
- repeat-guard and harmonic-comparison keys

### `lib/settings/*`

Settings are now properly modeled and persisted:

- `PracticeSettings` is an immutable snapshot of the full app configuration
- `AppSettingsController` loads and saves state with `shared_preferences`
- rapid consecutive writes are serialized through an internal save queue

### `lib/smart_generator.dart`

This file contains the advanced planning engine:

- weighted diatonic transitions
- applied dominant and substitute dominant routing
- modulation planning with center tracking
- local scope and resolution debt bookkeeping
- phrase-aware cadence logic
- voice-leading scoring
- simulation summaries and preset-vs-preset QA comparisons

## Testing and Verification

The repository currently has automated coverage across four layers:

- chord rendering rules
- settings persistence and enum fallback behavior
- widget flows for the practice screen
- smart generator planning, modulation families, diagnostics, and QA summaries

Verification commands:

```bash
flutter analyze
flutter test
flutter build web --release --base-href /sightchord/
```

## Observed Tradeoffs

- `lib/app.dart` is still a large stateful screen and remains the best next
  candidate for UI/controller extraction.
- `lib/smart_generator.dart` has strong test coverage, but its size means
  maintenance risk is concentrated in one file.
- Generated web artifacts exist at the repository root as well as in `build/`;
  that is workable, but it is worth deciding whether they are source-of-truth
  assets or just checked-in deploy output.
