# Chord Analyzer Benchmark Report

## Summary

- Generated (UTC): 2026-03-17T04:49:15.807969Z
- Benchmark corpus: 81 cases across proxy, dirty-input, and curated-gold layers
- Important note: the workbook is still a source inventory and test-plan document, not a bundled labeled corpus. This run therefore combines the in-repo proxy benchmark with a separately loaded external-gold slice.
- External gold headline: 66.7% exact pass, 66.7% key accuracy, 70.4% Roman exact.

- External gold status: loaded (3 cases loaded)
- External gold corpus: DCML Annotated Beethoven Corpus Excerpts

## Scope And Validity

- The workbook proxy benchmark measures internal consistency, regression stability, and coverage of known harmonic situations.
- It does not by itself prove external generalization across McGill Billboard, Isophonics, JAAH, When in Rome, or DCML-style annotations.
- Exact progression pass is intentionally preserved, but it is now paired with relaxed Roman/function comparison, modulation diagnostics, and segment-level mismatch reporting.
- The `gold-classical-c-real-modulation` miss matters because it suggests ending bias and a soft boundary between local tonicization evidence and true modulation when the global key summary is chosen.

## Workbook Alignment

- `S-tier Gold core`: Measure accuracy with balanced, high-confidence reference material
  Sources: McGill Billboard, Isophonics, JAAH, JHT, ABC, BPS-FH, Mozart, Romantic Piano Corpus, TAVERN, Winterreise, DLC
  Note: The repository does not bundle those external corpora yet, so this run uses an internal proxy corpus aligned to that track.
- `Ambiguity validation`: Measure ambiguous readings, partial parses, and placeholder inference separately
  Sources: CASD, community charts comparison
  Note: Exact-pass status is paired with detailed failure reasons because these cases can support multiple plausible readings.
- `Stress / robustness`: Measure throughput, long-sequence latency, and symbol normalization robustness
  Sources: Chordonomicon, PARC, ChoCo, TheoryTab
  Note: This run includes both mixed-corpus throughput and long-sequence latency.

## External Gold Coverage

- Manifest path: `output/chord_analyzer_benchmark\curated_gold\abc_external_gold_manifest.json`
- Corpus id: `dcml_abc_excerpt`
- Corpus name: DCML Annotated Beethoven Corpus Excerpts
- Fixture/import directory: `tool/benchmark_fixtures/external_gold/abc`
- Adapter: `abc_external_gold_adapter`
- Loaded cases: 3; skipped records: 0; skipped segments: 0
- License note: Source excerpts from DCMLab ABC (CC BY-NC-SA 4.0). Fixture provenance is documented in tool/benchmark_fixtures/external_gold/abc/README.md.
- Source ids: n01op18-1_01, n04op18-4_02, n13op130_04
- Annotation levels: functional

## Accuracy

### Accuracy By Benchmark Class

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Curated gold | 3 | 66.7% | 66.7% | 100.0% | 70.4% | n/a | n/a | n/a | 100.0% | 1.743 ms |
| Dirty input | 5 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | 100.0% | 100.0% | 1.079 ms |
| Workbook proxy | 73 | 98.6% | 98.6% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.400 ms |

### Overall

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Overall | 81 | 97.5% | 97.5% | 100.0% | 89.7% | 100.0% | 100.0% | 100.0% | 100.0% | 1.393 ms |

### By Track

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ambiguity validation | 20 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.031 ms |
| S-tier Gold core | 61 | 96.7% | 96.7% | 100.0% | 87.5% | 100.0% | 100.0% | 100.0% | 100.0% | 1.512 ms |

### By Genre

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classical | 7 | 71.4% | 71.4% | 100.0% | 74.2% | 100.0% | 100.0% | n/a | 100.0% | 1.591 ms |
| jazz | 41 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.612 ms |
| mixed | 13 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | 100.0% | 100.0% | 1.080 ms |
| pop | 20 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.077 ms |

### By Difficulty

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ambiguous | 17 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 100.0% | 0.989 ms |
| Easy | 10 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 100.0% | 100.0% | 3.249 ms |
| Hard | 22 | 90.9% | 90.9% | 100.0% | 72.4% | 100.0% | 100.0% | 100.0% | 100.0% | 1.311 ms |
| Medium | 32 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.084 ms |

## Proxy Vs External Gold

### Proxy Vs External

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Internal proxy | 78 | 98.7% | 98.7% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.380 ms |
| External gold | 3 | 66.7% | 66.7% | 100.0% | 70.4% | n/a | n/a | n/a | 100.0% | 1.743 ms |

## External Gold Accuracy

### External Gold Overall

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| External gold | 3 | 66.7% | 66.7% | 100.0% | 70.4% | n/a | n/a | n/a | 100.0% | 1.743 ms |

### External Gold By Corpus

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| dcml_abc_excerpt | 3 | 66.7% | 66.7% | 100.0% | 70.4% | n/a | n/a | n/a | 100.0% | 1.743 ms |

### External Gold By Source Id

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| n01op18-1_01 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | 1.997 ms |
| n04op18-4_02 | 1 | 0.0% | 0.0% | 100.0% | 0.0% | n/a | n/a | n/a | 100.0% | 1.284 ms |
| n13op130_04 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | 1.948 ms |

### External Gold By Annotation Level

| Bucket | Cases | Exact Pass | Key | Mode | Roman | Tags | Remarks | Evidence | Parse Expectation | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| functional | 3 | 66.7% | 66.7% | 100.0% | 70.4% | n/a | n/a | n/a | 100.0% | 1.743 ms |

### External Gold Key/Mode/Function

| Bucket | Key | Relaxed Key | Mode | Roman Exact | Roman Relaxed | Function Relaxed | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| External gold | 66.7% | 66.7% | 100.0% | 70.4% | 81.5% | 81.5% | n/a |

## Key/Mode/Function Breakdown

### Overall

| Bucket | Key | Relaxed Key | Mode | Roman Exact | Roman Relaxed | Function Relaxed | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Overall | 97.5% | 97.5% | 100.0% | 89.7% | 93.6% | 93.8% | 100.0% |

### By Benchmark Class

| Bucket | Key | Relaxed Key | Mode | Roman Exact | Roman Relaxed | Function Relaxed | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Curated gold | 66.7% | 66.7% | 100.0% | 70.4% | 81.5% | 81.5% | n/a |
| Dirty input | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a |
| Workbook proxy | 98.6% | 98.6% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% |

## Failure Cases

- `gold-classical-c-real-modulation` real modulation stays distinct from tonicization
  Progression: `Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7`
  Issues: expected key C, got G
  Failure taxonomy: modulation_vs_tonicization, ambiguous_key_center, ending_bias
- `curated-abc-n04op18-4_02-mc6-09` String Quartet Op18 No4 (mc 6-9)
  Progression: `D D7 | G | C/E C Am | D7/F# D`
  Issues: expected key G, got D; segment[0] expected V, got I; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected IV, got bVII; segment[4] expected IV, got bVII; segment[5] expected IIm, got II/IVm; segment[6] expected V7, got V7/IV; segment[7] expected V, got I
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Segment 0: expected V but got I (roman_exact_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected V7 but got V7/IV (roman_exact_mismatch)
  Segment 2: expected I but got IV (roman_exact_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected IV but got bVII (roman_exact_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected IV but got bVII (roman_exact_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected IIm but got II/IVm (roman_exact_mismatch)
  Segment 6: expected V7 but got V7/IV (roman_exact_mismatch)
  Segment 7: expected V but got I (roman_exact_mismatch, roman_relaxed_mismatch, function_mismatch)

## External Gold Failures

- `curated-abc-n04op18-4_02-mc6-09` String Quartet Op18 No4 (mc 6-9)
  Source id: `n04op18-4_02`
  Progression: `D D7 | G | C/E C Am | D7/F# D`
  Issues: expected key G, got D; segment[0] expected V, got I; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected IV, got bVII; segment[4] expected IV, got bVII; segment[5] expected IIm, got II/IVm; segment[6] expected V7, got V7/IV; segment[7] expected V, got I
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap

## Likely Root Causes

- `ambiguous_key_center` (2): Multiple key centers remain plausible after scoring, so the winner is sensitive to small cadence and weighting changes.
- `modulation_vs_tonicization` (1): The analyzer is detecting local key motion, but its global summary boundary between tonicization and true modulation is still too soft.
- `ending_bias` (1): Late cadential material appears to outweigh earlier home-key evidence in the primary key summary.
- `secondary_dominant_notation_gap` (1): Applied-dominant function is present, but the displayed Roman token diverges from the annotation style expected by the benchmark.

## Recommended Next Fixes

- Separate local-cadence evidence from progression-level home-key scoring and expose both in the report.
- Increase report emphasis on alternative key candidates and compare top-2 score gaps in failures.
- Reduce final-cadence overweight or add earlier tonic-anchor persistence to the global-key scorer.
- Normalize applied-dominant Roman display variants before exact comparison, while still preserving strict metrics separately.

## Performance

### mixed-corpus

- Analyses: 32400
- Chords processed: 120800
- Throughput: 3693.7 analyses/s, 13771.7 chords/s
- Latency: mean 0.270 ms, p50 0.235 ms, p95 0.535 ms, p99 0.837 ms
- Range: 0.097 ms to 2.214 ms

### long-sequence

- Analyses: 180
- Chords processed: 92340
- Throughput: 21.1 analyses/s, 10807.6 chords/s
- Latency: mean 47.462 ms, p50 46.892 ms, p95 54.789 ms, p99 60.465 ms
- Range: 40.375 ms to 65.786 ms
- Input size: 515 chords
- Input length: 2979 characters
