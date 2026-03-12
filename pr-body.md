## Summary
This change closes remaining test gaps in the recent progression parser/analyzer refactor, focused on changed logic only.

## Issue
Recent updates changed chord-family modeling, mode-aware secondary dominant resolution, grouped measure handling, and parser token diagnostics. Those areas were mostly covered, but two changed behaviors were still untested:
- non-dominant chords being incorrectly eligible for secondary-dominant remarks
- grouped measure parse issue propagation including token-level error details

Without explicit tests, regressions in those branches could silently alter analysis labels and hide useful parser diagnostics in UI flows that render measure-level warnings.

## Root Cause
The refactor introduced new branches (`isDominantLike` gating and `AnalyzedMeasure.parseIssues` / token `errorDetail`) but test assertions were concentrated on broader fixture outcomes and roman rendering, not these precise branch outcomes.

## Fix
Added focused analyzer tests in `test/progression_analyzer_test.dart`:
- `does not label non-dominant chords as secondary dominants`
  - verifies `D G C` keeps `II` and does not emit `possibleSecondaryDominant`
- `surfaces grouped measure parse issues with detailed token errors`
  - verifies invalid bass input (`C/H | G7`) surfaces in `groupedMeasures.first.parseIssues` with `error=invalid-bass` and `errorDetail=H`

## Validation
Attempted targeted validation:
- `dart format test/progression_analyzer_test.dart` (timed out in sandbox)
- `flutter test test/progression_analyzer_test.dart` (timed out in sandbox)

Given the environment timeouts, runtime verification should be completed in CI or a local environment with working Flutter tooling.
