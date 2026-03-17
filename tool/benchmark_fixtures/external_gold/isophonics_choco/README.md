This directory stores a small reproducible ChoCo Isophonics slice for pop external-gold evaluation.

- Source repository: `https://github.com/smashub/choco`
- Source partition: `partitions/isophonics/choco/jams`
- License: `CC BY 4.0` according to ChoCo's top-level license note
- Checked-in data policy: this repository checks in a very small public JAMS slice to keep the pop benchmark reproducible on Windows without requiring a full ChoCo checkout

Benchmark notes:

- These records come from the audio-aligned Isophonics partition and provide `chord` plus `key_mode` annotations.
- The adapter preserves the original Harte surface symbol in `chordRaw` / `chordNormHarte`, and converts supported symbols into analyzer-facing lead-sheet strings for `expectedResolvedSymbol`.
- This slice is intended to measure pop chord parsing and global key estimation. It does not provide gold Roman numerals, so Roman/function metrics are `n/a` for these cases by design.
