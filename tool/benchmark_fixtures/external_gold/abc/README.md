Source corpus: DCMLab Annotated Beethoven Corpus (ABC)
Repository: https://github.com/DCMLab/ABC
License: CC BY-NC-SA 4.0

This fixture directory contains small measure-bounded excerpts copied from the
official ABC harmonies tables so the Chord Analyzer benchmark can run a real
external-gold evaluation without bundling the full corpus.

Included source pieces:
- `n01op18-1_01` measures 3-11
- `n04op18-4_02` measures 6-9
- `n13op130_04` measures 42-49

Selection-manifest mode:
- `selection_manifest.tsv` lists a larger 24-window evaluation slice sourced
  from the local ABC checkout.
- If `CHORD_ANALYZER_BENCHMARK_ABC_SOURCE_ROOT` is set, or `.codex_tmp/ABC`
  exists in the workspace, the benchmark imports those windows directly from a
  local ABC checkout and emits a generated canonical manifest.
- If no local ABC checkout is available, the benchmark falls back to the
  checked-in 3-slice excerpt directory above.

The excerpts remain corpus-derived data. Provenance, source ids, annotation
level, and license notes are preserved by the ABC adapter.
