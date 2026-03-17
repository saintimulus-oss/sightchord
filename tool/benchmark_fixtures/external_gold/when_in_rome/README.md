This directory stores import metadata for a small When in Rome external-gold slice.

- Source repository: `https://github.com/MarkGotham/When-in-Rome`
- License: `CC BY-SA 4.0`
- Local source root expected by the benchmark: `.codex_tmp/When-in-Rome`
- Checked-in data policy: this repository does not check in When in Rome analysis content here; it only stores the selection manifest used to import a local checkout.

Selection manifest columns:

- `source_id`: stable benchmark source bucket id
- `relative_analysis_path`: path to the `analysis.txt` file inside the local When in Rome checkout
- `measure_start`, `measure_end`: inclusive measure window to import
- `selection_note`: short rationale for coverage and diagnostics

Important notes:

- The adapter derives chord-symbol benchmark input from RomanText harmonic annotations. This is a representation conversion, not a raw lead-sheet source.
- Surface Roman labels are preserved from the source analysis, while canonical Roman labels are normalized for analyzer-facing comparison.
- If the local checkout is absent, the benchmark will skip this corpus and continue with any other available curated-gold sources.
