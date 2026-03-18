## Issue
Recent changes introduced new behavior in two controllers that lacked focused regression coverage: notification safety in settings updates and lifecycle/dispose guards in study-harmony progress loading/updating. Without explicit tests, these paths can regress silently (double notifications or state mutation after disposal).

## User Impact
If notification safety regresses, listeners can be notified more than once per operation, causing duplicate UI work and inconsistent reactive behavior. If dispose guards regress, async loads or post-dispose mutations can update dead controller state and trigger side effects after the owning widget is gone.

## Root Cause
The changed branches were narrow lifecycle/notification guards, but existing tests primarily covered persistence and recommendation logic, not disposal timing and notification count invariants.

## Fix
Added tightly scoped regression tests in changed areas:
- `test/settings_controller_test.dart`
  - `load and update notify listeners once per call`
  - Verifies one listener callback for `load()` and one for `update()`.
- `test/study_harmony_progress_controller_test.dart`
  - `load becomes a no-op after dispose while waiting for store`
  - `markLessonStarted after dispose does not mutate or save`
  - Added `_DelayedLoadProgressStore` test double to deterministically cover the async dispose race.

This keeps scope limited to the recent controller changes and avoids broader refactors.

## Validation
Attempted targeted validation in this environment:
- `flutter test test/settings_controller_test.dart test/study_harmony_progress_controller_test.dart` (timed out)
- `dart format test/settings_controller_test.dart test/study_harmony_progress_controller_test.dart` (timed out)

Given sandbox limits, tests could not be executed to completion here.
