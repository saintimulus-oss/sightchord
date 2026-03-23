# Codex Maintenance Plan

## Current Risks

- Generated Flutter web output is tracked at the repository root, which makes release artifacts look like source code and risks drift from the GitHub Pages CI build.
- Machine-local and tool-generated files are present or tracked, including `.appdata/`, `.dart_tool/`, build outputs, logs, scratch files, and `android/local.properties`.
- Several core Dart files are oversized and mix domain logic, state, and UI concerns, which raises regression risk for future maintenance.
- Android release builds still fall back to the debug signing config, so store-ready packaging requires owner keystore provisioning.

## Milestones

1. Repository hygiene and packaging
   - Expand `.gitignore` for generated artifacts, caches, logs, scratch files, browser/profile data, and machine-local files.
   - Remove tracked generated/local files from version control where appropriate.
   - Keep GitHub Pages deployment rooted in CI-generated `build/web` output.
   - Validate with `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, and `flutter build web --release --base-href /chordest/`.

2. Smart generation and voicing refactor
   - Split `lib/smart_generator.dart` by responsibility so planning, scoring, diagnostics, and helpers are easier to navigate.
   - Split `lib/music/voicing_engine.dart` into engine, context resolution, templates, and scoring helpers.
   - Add or adjust focused tests if the extraction reveals gaps.
   - Re-run formatting, analysis, tests, and web build.

3. App and settings UI refactor
   - Split `lib/app.dart` into app shell, main menu, and practice-screen responsibilities.
   - Split `lib/settings/practice_settings_drawer.dart` into smaller settings sections/widgets.
   - Split `lib/chord_analyzer_page.dart` into page state, analysis rendering, and reusable section widgets.
   - Re-run formatting, analysis, tests, and web build.

4. Documentation and release readiness
   - Update `README.md` and `docs/architecture-overview.md` to match the final structure and validation flow.
   - Add concise developer notes on local validation, generated-vs-source-controlled files, and owner-only release follow-ups.
   - Finish with a final validation pass and a short follow-up list.
