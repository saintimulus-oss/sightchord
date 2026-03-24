# Chord Analyzer Semantics

## Confidence

- `primaryKey` / `primaryKeyDisplay` represent the user-facing home or anchor key.
- `globalAggregateKey` represents the strongest whole-progression aggregate scorer, which may differ when the music truly modulates.
- `keyConfidence` measures confidence in the displayed home key selection only.
- `analysisReliability` measures trust in the full analysis after penalties for parse issues, unresolved harmony, placeholders, sparse context, and segment inconsistency.
- Backward-compatible `confidence` now follows `analysisReliability`.

## Diagnostic Status

- `clean`: no genuine parse failure, no placeholders, no unresolved chords, and analysis reliability is comfortably high.
- `ambiguous_harmony`: harmony is functionally analyzable, but there is meaningful key uncertainty or a musically relevant competing reading.
- `unresolved_harmony`: at least one chord or local function could not be resolved reliably.
- `partial_parse`: genuine parse failure occurred. Layout markers, section markers, no-chord markers, and ignored modifiers do not trigger this by themselves.
- `placeholder_inference`: one or more placeholders were inferred. This takes top-level precedence even if ambiguity also exists.

## Output Consistency

- `tagNames` and boolean flags are normalized together in one postprocess step.
- `hasRealModulation` is only true when modulation evidence is structurally and harmonically strong enough.
- `competingInterpretations` contain only materially different alternatives, never the same reading with score noise.
- `suggestedFills` for placeholders are ranked suggestions with confidence and rationale, not a single hard-coded fill.
