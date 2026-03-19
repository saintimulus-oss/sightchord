# Track Redesign Plan

## Goals

### Pop
- Teach loop gravity, borrowed-color lift, and bass motion that feels useful in modern songs.
- Keep harmony practical: add9, sus, slash-bass, and singable melodic contour before dense reharm language.
- De-emphasize advanced jazz substitutions in early material.

### Jazz
- Teach guide-tone hearing first, then shell voicing, then rootless color.
- Make ii-V-I, minor iiø-V-i, turnaround logic, and dominant color audible before heavy abstraction.
- Present reharm ideas as context-dependent options, not absolute truths.

### Classical
- Teach tonic / predominant / dominant function, inversion literacy, cadence types, and voice-leading discipline.
- Keep tension language controlled and functional.
- Frame secondary dominants and modulation as structural events inside phrase design.

## First-Release Slice

### Pop Slice
- `Signature Pop Loops` chapter
- Lessons: `Hook Gravity`, `Borrowed Lift`, `Bass Motion`, `Pre-Chorus Lift Checkpoint`

### Jazz Slice
- `Guide-Tone Lab` chapter
- Lessons: `Guide-Tone Hearing`, `Minor Cadence`, `Dominant Color`, `Turnaround Checkpoint`

### Classical Slice
- `Cadence Lab` chapter
- Lessons: `Cadence Function`, `Inversion Control`, `Functional Secondary Dominants`, `Arrival Checkpoint`

## Architecture Changes

- Add `TrackPedagogyProfile` for expectation-setting copy and learning emphasis.
- Add `TrackGenerationProfile` for progression/voicing/melody bias per track exercise.
- Add `TrackExerciseFlavor` to connect lesson intent with generation presets and explanations.
- Add `TrackRecommendationProfile` and `TrackSoundProfile` so each track feels distinct in UX and future audio expansion.
- Keep a shared core course, but inject track-specific chapters through a factory/override layer instead of cloning the whole curriculum.

## Explanation Layer

- Use `ExplanationBundle` as the shared explanation payload.
- Surface `ReasonCode`, listening hints, performance hints, alternative interpretations, and confidence badges.
- Reuse progression analysis as the canonical explanation source, then enrich it with voicing and melody cues where available.

## Expansion Points

- Add more track-specific lesson factories without duplicating the whole course tree.
- Swap `TrackSoundProfile` placeholders to real assets when the audio library grows.
- Expand jazz intermediate content with backdoor and reharm comparisons.
- Expand classical content with sequence and non-chord-tone drills.
- Expand pop content with pre-chorus lift and hook melody repair drills.
