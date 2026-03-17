# Chord Analyzer External Gold Benchmark Plan

## Why This Exists

The current Chord Analyzer benchmark is a workbook-aligned proxy benchmark. It is useful for regression safety, diagnostic coverage, and performance tracking, but it is not the same thing as measuring generalization on independently annotated external corpora.

Proxy/workbook benchmark:
- Built from in-repo fixtures and benchmark cases derived from the workbook taxonomy.
- Good for reproducibility, stress tests, dirty-input regressions, and failure diagnostics.
- High scores mainly prove internal consistency plus coverage of known cases.

External gold benchmark:
- Built from third-party corpora with independent annotations.
- Needed to estimate real-world generalization across repertoire, notation conventions, annotator style, and modulation practice.
- Must preserve provenance, license notes, and annotation granularity.

## Why Exact Match Alone Is Not Enough

Exact progression pass is useful, but insufficient on its own because:
- Multiple chord-symbol spellings can encode the same harmonic role.
- Roman numeral surface detail can differ while harmonic function remains correct.
- Local tonicization may be interpreted differently from full modulation.
- Slash-bass, enharmonic spelling, and borrowed-chord labels can vary across corpora.
- Ending cadences can overweight the final local center and hide earlier global-key evidence.

The current `gold-classical-c-real-modulation` miss is important because it shows a realistic ambiguity boundary: the analyzer correctly surfaces real modulation, but the winning primary key can still collapse toward a later cadence. That is exactly the kind of issue external gold evaluation should expose.

## Known Risk Axes To Track

- `ending_bias`: later cadences dominate global-key selection.
- `modulation_vs_tonicization`: transient tonicization is over-read or under-read as true modulation.
- `ambiguous_key_center`: multiple candidate centers remain plausible after normalization.
- `borrowed_chord_confusion`: borrowed or backdoor color is read as a competing home key.
- `modal_mixture_confusion`: mixture color is read correctly at the chord level but summarized poorly at the progression level.
- `slash_chord_interpretation`: inversion or bass-note information is dropped or over-interpreted.
- `enharmonic_equivalence`: correct pitch-class behavior is penalized by notation mismatch.
- `secondary_dominant_notation_gap`: applied dominant function is found, but the displayed Roman token diverges from annotation style.

## Target Corpora

### Pop / Rock

- McGill Billboard
- Isophonics
- CoCoPops

Primary goals:
- global key accuracy
- slash/inversion handling
- borrowed/mode-mixture behavior
- section-level mismatch reports

### Jazz

- WJazzD
- JAAH
- Jazz Harmony Treebank
- cleaned iRealPro-derived set

Primary goals:
- chord-symbol normalization breadth
- secondary dominant / tritone substitute handling
- local tonicization and turnaround interpretation
- dirty chart notation tolerance

### Classical

- When in Rome
- DCML / DLC family

Primary goals:
- Roman/function alignment
- cadence-aware segmentation
- modulation vs tonicization diagnostics
- phrase-sensitive global-key summaries

## Canonical Internal Schema

The first implementation should normalize all corpora into one record shape before evaluation.

Record-level fields:
- `record_id`
- `source_id`
- `source_url`
- `genre_family`
- `work_id`
- `title`
- `composer_or_artist`
- `movement_or_section`
- `progression_input`
- `primary_key`
- `primary_mode`
- `annotation_level`
- `alignment_type`
- `split_tag`
- `license_notes`
- `annotator_count`
- `confidence_or_agreement`
- `metadata`

Segment-level fields:
- `index`
- `chord_raw`
- `chord_norm_harte`
- `expected_key`
- `expected_mode`
- `expected_roman`
- `expected_function`
- `expected_resolved_symbol`
- `bass_or_inversion`
- `note`

The scaffold for this schema lives in:
- `tool/benchmark/chord_analyzer_external_gold_schema.dart`
- `tool/benchmark_fixtures/curated_gold_schema_example.json`

## Adapter Layer Design

Each external corpus should get a small adapter that does only three jobs:

1. Read corpus-native files.
2. Convert them into the canonical schema.
3. Emit a manifest JSON that the benchmark runner can load.

Recommended adapter contract:
- input: corpus-native path(s)
- output: canonical manifest JSON
- preserve original source ids, URLs, and license notes
- never rewrite or redistribute third-party corpus assets inside the repo unless license allows it

## Evaluation Layers

The benchmark architecture should support three layers:

### 1. Proxy / Workbook Benchmark

- Source: in-repo benchmark cases.
- Role: regression safety, dirty-input coverage, fast diagnosis.
- Comparator: exact + relaxed + diagnostic.

### 2. Curated Gold Benchmark

- Source: canonical-manifest JSON generated from external corpora.
- Role: real accuracy and generalization measurement.
- Comparator: exact + relaxed + modulation-aware segment comparison.

### 3. Stress / Performance Benchmark

- Source: repeated mixed corpus and long synthetic sequence.
- Role: throughput, latency, parser/analyzer scaling.

## Comparison Strategy

The benchmark runner should compute at least:
- key accuracy
- mode accuracy
- Roman exact accuracy
- Roman/function relaxed accuracy
- modulation-sensitive agreement
- segment-level mismatch reports
- failure taxonomy counts

Relaxed comparison hooks should allow:
- enharmonic key equivalence
- slash-bass tolerance
- notation-tolerant Roman comparison

## Recommended Integration Order

1. When in Rome or DCML-derived classical excerpt manifest
   Reason: immediately pressures modulation and Roman/function alignment.
2. Isophonics or McGill Billboard slice
   Reason: improves pop slash/mode-mixture realism.
3. JAAH or Jazz Harmony Treebank slice
   Reason: tests jazz notation breadth and tonicization ambiguity.

## License And Redistribution Notes

- Keep third-party corpus license notes inside each canonical manifest.
- Add `license_notes` at record level even when the source corpus already has a global license.
- Do not commit full corpus dumps into this repo unless the license explicitly allows redistribution.
- If a corpus is research-only or non-commercial, adapters may target a local path and emit only derived metrics or a local manifest outside version control.

## Immediate Next Steps

1. Build a small When in Rome adapter that emits a local canonical manifest for 10 to 20 excerpts.
2. Add a McGill or Isophonics slice for slash-chord and borrowed-color validation.
3. Extend the benchmark report with per-corpus and per-source-id breakdowns once curated gold data is loaded.
