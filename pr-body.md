## Summary
This changeset closes a focused test gap in recently introduced melody generation internals by adding deterministic coverage for the new stable hashing utility used by phrase/rhythm/motif seeding.

## User impact
Without direct tests around seed hashing behavior, regressions in hashing logic could silently alter generated melody output patterns, making generated phrases less repeatable for the same musical input and seed.

## Root cause
`MelodySeedUtil` was newly introduced and immediately used in generation pipelines, but there was no dedicated test suite validating type handling (null, bool, numeric, enum, iterables), deterministic output, and order sensitivity.

## Fix
- Added `test/melody_seed_util_test.dart` with focused unit coverage for:
  - deterministic hashing for primitive and enum values
  - branch differentiation for bool/double/enum variants
  - deterministic and order-sensitive behavior of `stableHashAll`
  - output range contract (`0..0x3fffffff`) for aggregated hashes

## Validation
Attempted to run targeted local checks in this sandbox:
- `dart format test/melody_seed_util_test.dart` (timed out)
- `flutter test test/melody_seed_util_test.dart` (timed out)

The new test is intentionally isolated and does not broaden scope beyond changed melody seeding logic.