# SightChord Refactor Baseline Plan (2026-03)

## Scope

This document captures the pre-refactor baseline for the current practice flow. The goal of the next phases is structural extraction only. Public behavior must stay unchanged unless a later phase explicitly widens scope.

## Current Structure Summary

### App bootstrap / app shell / main menu / practice page

- `lib/main.dart` is a thin entry point that delegates to `bootstrapApp()`.
- `lib/app.dart` is the public barrel for bootstrap, shell, main menu, and practice page exports.
- `lib/app_bootstrap.dart` owns startup sequencing. It initializes Flutter bindings, loads persisted practice settings and study-harmony progress, then calls `runApp`.
- `lib/app_shell.dart` owns `MyApp`, dependency ownership/disposal, theme construction, localization delegates, and top-level `MaterialApp` wiring.
- `lib/main_menu_page.dart` is the launcher shell. It exposes the generator, analyzer, and study-harmony entry points and hosts the lightweight app-level language/theme sheet.
- `lib/practice_home_page.dart` is the main orchestration file for the generator experience. It currently mixes:
  - session bootstrap
  - queue seeding/promotion/history
  - melody queue rebuilds
  - voicing recomputation and selection
  - transport, autoplay, metronome scheduling, and preview playback
  - settings application and persistence handoff
  - screen-level commands used by the UI parts
- `lib/practice_home_page_ui.dart` contains the bulk of screen composition and user interaction wiring, but it still depends heavily on `_MyHomePageState`.
- `lib/practice_home_page_labels.dart` holds localized generator labels and key-center formatting helpers.

### Session state / queue state / voicing state

- Session state is split between `PracticeSettings` in `AppSettingsController` and live in-memory fields on `_MyHomePageState`.
- `lib/music/practice_chord_queue_state.dart` is the immutable chord queue snapshot:
  - `previousEvent`
  - `currentEvent`
  - `nextEvent`
  - `lookAheadEvent`
  - queued smart-family residue via `plannedSmartChordQueue`
- `lib/music/melody_models.dart` includes `PracticeMelodyQueueState`, which mirrors the chord queue for generated melody events.
- `lib/music/voicing_session_state.dart` is the immutable voicing-selection snapshot:
  - latest recommendation set
  - selected voicing
  - locked voicing
  - continuity reference for the next chord
  - last logged diagnostic key
- The practice page is currently responsible for coordinating all three state snapshots together when settings change, chords advance, undo runs, or autoplay ticks.

### Metronome / audio / timer

- Transport timing is driven in `lib/practice_home_page.dart`.
- `audio/beat_clock.dart` provides due-sequence timing math for autoplay.
- `audio/metronome_audio_service.dart` provides metronome source loading, beat playback, and precise scheduling support.
- `audio/harmony_audio_service.dart` and `audio/harmony_preview_resolver.dart` provide chord/melody preview playback and prefetch support.
- Practice page responsibilities currently include:
  - BPM parsing/clamping
  - autoplay start/stop/reschedule
  - beat advancement
  - manual vs auto chord promotion
  - scheduled metronome look-ahead window filling
  - harmony preview warm-up and prefetch invalidation

### Smart generator planning / ranking / fallback / diagnostics

- `lib/smart_generator.dart` is the public barrel.
- `lib/smart_generator_core.dart` currently contains four distinct responsibilities:
  - planning: `planInitialStep`, `planNextStep`, `_buildFamilyPlans`, family builders, queue release logic
  - ranking/rendering: `compareVoiceLeadingCandidates`, rendering option expansion, voice-leading scoring
  - fallback: `_planFallbackContinuation`, `prioritizedFallbackRomans`, excluded-candidate fallback hierarchy in simulation
  - diagnostics/QA: simulation summary generation and helper accessors
- `lib/smart_generator_diagnostics.dart` defines `SmartDecisionTrace`, `SmartDiagnosticsStore`, simulation summaries, QA checks, and serialization helpers.
- `lib/music/smart_generator_models.dart` carries the request/response/domain models shared by planning and diagnostics.
- Generated priors and lookup tables under `lib/music/priors/` are data dependencies, not orchestration boundaries.

### Settings persistence

- `lib/settings/practice_settings.dart` is the immutable application/practice configuration model and normalization boundary.
- `lib/settings/settings_controller.dart` is the live `ChangeNotifier` facade used by the app shell and pages.
- `lib/settings/practice_settings_store.dart` owns SharedPreferences load/save behavior, storage-key compatibility, clamping, and fallback behavior.
- `lib/settings/practice_settings_effects.dart` classifies which settings changes affect queue regeneration, voicing look-ahead, metronome audio, and harmony audio.
- `lib/settings/practice_settings_dispatcher.dart` is a tiny UI helper for applying settings transforms.
- `lib/settings/practice_settings_factory.dart` and setup-assistant files create presets and onboarding-derived settings; they should stay downstream of the core persistence model.

## Stepwise Extraction Plan

### Phase 1: Practice orchestration boundary

- Extract a practice-session coordinator from `lib/practice_home_page.dart`.
- Move queue/melody/voicing coordination methods into a non-widget collaborator first.
- Keep `MyHomePage`, existing widget keys, and existing page routes unchanged.

### Phase 2: Transport boundary

- Extract autoplay, beat-clock integration, and metronome scheduling from `lib/practice_home_page.dart`.
- Keep the current helper semantics for `computeNextPracticeAutoBeat`, immediate-first-beat handling, and manual-reset behavior.
- Keep `MetronomeAudioService` and `HarmonyAudioService` APIs unchanged in this phase.

### Phase 3: Smart generator boundary split

- Split `lib/smart_generator_core.dart` into planner-oriented and ranking-oriented internals behind the same public barrel.
- Keep `SmartGeneratorHelper` as the public facade during the extraction.
- Move diagnostics helpers only after planner/ranking extraction is stable so simulation regression tests can stay anchored.

### Phase 4: Settings boundary cleanup

- Separate persistence serialization concerns from policy/effect classification.
- Keep `PracticeSettings`, `PracticeSettingsStore`, and `AppSettingsController` behavior stable while extracting private helpers.
- Do not introduce a new state-management framework.

### Phase 5: Practice UI decomposition

- After logic extraction, reduce `_MyHomePageState` surface area by turning UI sections into narrower widgets fed by already-extracted coordinators/view models.
- Keep current visible copy, widget keys, button semantics, and routing unchanged.

## Public Behavior Invariants To Preserve

### App and navigation

- `bootstrapApp()` must finish loading practice settings and study-harmony progress before `runApp`.
- `MyApp` must keep `MainMenuPage` as the `home` screen.
- `MyApp` locale/theme must continue to come from `AppSettingsController.settings`.
- Main menu must keep working entry points for generator, analyzer, study harmony, and app-level language/theme settings.

### Practice page and session flow

- Practice startup must still seed a usable current chord and next chord before interaction.
- Guided-first-run flow must still land on a ready practice state using the existing preset/fallback path.
- Manual chord advance must still record history, promote the queue, recompute voicings, and optionally trigger preview audio.
- Undo must still restore queue state, melody state, voicing state, current beat, and melody seed together.

### Queue / voicing semantics

- `PracticeChordQueueState.promote()` semantics must stay:
  - previous <- current
  - current <- next
  - next <- queued replacement
  - look-ahead cleared
- Look-ahead generation must remain conditional on voicing suggestions being enabled and `lookAheadDepth >= 2`.
- `VoicingSessionState.promoteChordQueue()` must keep continuity-reference behavior and clear recommendation/selection/lock state for the new chord.
- Locked or previously selected voicings must continue to be re-matched by signature after recommendation refreshes.

### Transport / audio

- `shouldStartPracticeAutoplayImmediately(null)` must remain `true`, and non-null beat states must remain resumptive rather than restarting from scratch.
- `computeNextPracticeAutoBeat()` must keep current wrap and `nextChangeBeat` advance semantics.
- Manual navigation must still reset beat progress the same way current UI tests expect.
- Metronome mute beats must stay silent.
- Precise metronome scheduling must remain opt-in based on service readiness plus current autoplay/settings state.

### Smart generator

- `SmartGeneratorHelper` public entry points must remain stable for callers and tests.
- Family-queue continuation must still run before fresh family selection when queued chords remain and release conditions are not met.
- When no family plan applies, fallback continuation must still resolve via weighted diatonic transition selection plus applied-approach insertion rules.
- Candidate ranking must still sort primarily by voice-leading score, then default option preference, then deterministic source/option order.
- Diagnostics collection and simulation QA output must remain available through `SmartDiagnosticsStore` and `simulateSteps()`.

### Settings persistence

- `PracticeSettingsStore.load()` must continue to preserve fallback values for missing/invalid storage entries.
- Stored enum/string keys must remain backward compatible with current SharedPreferences keys.
- Ordered collections such as active key centers, enabled chord qualities, and selected tensions must remain deterministic on save.
- Anchor loop persistence must continue to round-trip through sanitize/normalize behavior tied to time signature and harmonic rhythm.

## Test Strategy

- Keep the current suite as the behavior baseline:
  - `test/widget_test.dart` for app shell, menu flow, practice page, transport, setup, and major UI invariants
  - `test/practice_chord_queue_state_test.dart` and `test/voicing_session_state_test.dart` for immutable state semantics
  - `test/beat_clock_test.dart`, `test/metronome_audio_service_test.dart`, and transport widget tests for timing/audio guardrails
  - `test/smart_generator_test.dart`, `test/smart_generator_simulation_regression_test.dart`, and related QA tests for planning/ranking/fallback/diagnostics
  - `test/settings_controller_test.dart`, `test/practice_settings_store_test.dart`, and `test/settings_voicing_load_test.dart` for persistence and compatibility
- Add only thin smoke coverage at new public seams introduced by refactor steps.
- After each extraction step:
  - run focused tests for the touched area first
  - run full `flutter analyze`
  - run full `flutter test`
- Do not replace existing regression tests with broader but weaker snapshots.

## Rollback Points

- Rollback point 0: current baseline after this document and smoke-test update.
- Rollback point 1: after practice-session coordinator extraction, before transport extraction.
- Rollback point 2: after transport extraction, before smart-generator internal split.
- Rollback point 3: after smart-generator split, before settings persistence cleanup.
- Rollback point 4: after settings cleanup, before practice UI decomposition.

Each rollback point should leave:

- `flutter analyze` passing
- `flutter test` passing
- `lib/app.dart` public exports unchanged
- `lib/smart_generator.dart` public export unchanged
- no route/key/localization regressions in `test/widget_test.dart`
