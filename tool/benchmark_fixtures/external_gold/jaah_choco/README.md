This directory stores a small reproducible ChoCo JAAH slice for jazz external-gold evaluation.

- Source repository: `https://github.com/smashub/choco`
- Source partition: `partitions/jaah/choco/jams`
- License: `CC BY-NC-SA 4.0` according to ChoCo's top-level license note for JAAH-derived data
- Checked-in data policy: this repository checks in a very small public JAMS slice to keep a jazz external benchmark reproducible without requiring a full ChoCo checkout

Benchmark notes:

- These records come from the audio-aligned JAAH partition and provide `chord` plus `key_mode` annotations.
- The adapter preserves the original Harte surface symbol in `chordRaw` / `chordNormHarte`, and converts supported symbols into analyzer-facing lead-sheet strings for `expectedResolvedSymbol`.
- This slice is intended to measure jazz chord parsing and global key estimation. It does not provide gold Roman numerals, so Roman/function metrics are `n/a` for these cases by design.
