## Issue
Recent metronome scheduling and smart-generator/settings updates introduced new decision paths that were not directly exercised by tests.

## Cause and user impact
Untested edge branches can regress silently: beat timing guards, legacy settings migrations, and diagnostics serialization can break without immediate signal.

## Root cause
Recent code changes added branching behavior but only a subset of those paths had focused tests.

## Fix
Added tight tests in changed areas:
- `test/beat_clock_test.dart`: verifies non-positive interval clamping and overdue-delay zeroing.
- `test/practice_settings_store_test.dart`: verifies legacy `activeKeys` migration path when `activeKeyCenters` is absent.
- `test/smart_generator_test.dart`: verifies `finalRenderedNonDiatonic` is exported in diagnostics JSON and description output.

## Validation
- Attempted: `dart format test/beat_clock_test.dart test/practice_settings_store_test.dart test/smart_generator_test.dart` (timed out in sandbox).
- Attempted: `flutter test test/beat_clock_test.dart test/practice_settings_store_test.dart test/smart_generator_test.dart` (timed out in sandbox).
