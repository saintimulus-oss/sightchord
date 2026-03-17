# Chord Analyzer Benchmark Report

## Summary

- Generated (UTC): 2026-03-17T11:28:02.055868Z
- Benchmark corpus: 128 cases across proxy, dirty-input, and curated-gold layers
- Important note: the workbook is still a source inventory and test-plan document, not a bundled labeled corpus. This run therefore combines the in-repo proxy benchmark with a separately loaded external-gold slice.
- External gold headline: 38.0% exact pass, 58.0% key accuracy, 68.3% Roman canonical exact.
- Relaxed key accuracy is 70.0%, which separates notation-only key spelling gaps from true key-center misses.
- External no-chord handling: 206/206 non-harmonic segments retained (100.0%), with harmonic coverage at 100.0%.

- External gold status: loaded (50 cases loaded)
- External gold corpora: DCML Annotated Beethoven Corpus Excerpts; When in Rome RomanText Excerpts; ChoCo Isophonics Beatles Slice; ChoCo JAAH Jazz Slice
- External gold coverage: 50/50 records kept (100.0%), 3908/3908 segments kept (100.0%)
- External harmonic/non-harmonic split: 3702/3702 harmonic segments kept (100.0%), 206/206 non-harmonic segments retained (100.0%).

## Scope And Validity

- The workbook proxy benchmark measures internal consistency, regression stability, and coverage of known harmonic situations.
- Even with these external slices, this run still does not by itself prove generalization across full McGill Billboard, JAAH, WJazzD, or full-scale Isophonics/When in Rome/DCML coverage.
- Exact progression pass is intentionally preserved, but it is now paired with relaxed Roman/function comparison, modulation diagnostics, and segment-level mismatch reporting.
- The current external layer mixes local-excerpt symbolic classical gold with global-movement audio-aligned pop gold, so metrics must be read with annotation scope in mind.
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

- Manifest paths: `output/chord_analyzer_benchmark\curated_gold\abc_external_gold_manifest.json`, `output/chord_analyzer_benchmark\curated_gold\when_in_rome_external_gold_manifest.json`, `output/chord_analyzer_benchmark\curated_gold\isophonics_choco_external_gold_manifest.json`, `output/chord_analyzer_benchmark\curated_gold\jaah_choco_external_gold_manifest.json`
- Corpora loaded: `dcml_abc_excerpt` (DCML Annotated Beethoven Corpus Excerpts), `when_in_rome_rntxt_excerpt` (When in Rome RomanText Excerpts), `isophonics_choco_slice` (ChoCo Isophonics Beatles Slice), `jaah_choco_slice` (ChoCo JAAH Jazz Slice)
- Raw records: 50; loaded records: 50; skipped records: 0
- Raw segments: 3908; kept segments: 3908; skipped segments: 0
- Harmonic/non-harmonic segments: 3702 harmonic raw, 3702 harmonic kept; 206 non-harmonic raw, 206 non-harmonic kept
- Coverage ratio: records 100.0%, segments 100.0%, harmonic 100.0%, non-harmonic 100.0%
- `dcml_abc_excerpt`: 24/24 records (100.0%), 352/352 segments (100.0%)
  Adapter: `abc_external_gold_adapter`
  Import mode: `selection_manifest`
  Manifest: `output/chord_analyzer_benchmark\curated_gold\abc_external_gold_manifest.json`
  Selection manifest: `tool/benchmark_fixtures/external_gold/abc/selection_manifest.tsv`
  Source corpus root: `.codex_tmp/ABC`
  Fixture/import directory: `tool/benchmark_fixtures/external_gold/abc`
  License note: Source excerpts from DCMLab ABC (CC BY-NC-SA 4.0). Fixture provenance is documented in tool/benchmark_fixtures/external_gold/abc/README.md.
- `when_in_rome_rntxt_excerpt`: 10/10 records (100.0%), 260/260 segments (100.0%)
  Adapter: `when_in_rome_external_gold_adapter`
  Import mode: `selection_manifest`
  Manifest: `output/chord_analyzer_benchmark\curated_gold\when_in_rome_external_gold_manifest.json`
  Selection manifest: `tool/benchmark_fixtures/external_gold/when_in_rome/selection_manifest.tsv`
  Source corpus root: `.codex_tmp/When-in-Rome`
  Fixture/import directory: `tool/benchmark_fixtures/external_gold/when_in_rome`
  License note: Source analyses from When in Rome (CC BY-SA 4.0). Selection provenance is documented in tool/benchmark_fixtures/external_gold/when_in_rome/README.md.
- `isophonics_choco_slice`: 6/6 records (100.0%), 399/399 segments (100.0%); harmonic 386/386 (100.0%), non-harmonic 13/13 (100.0%)
  Adapter: `isophonics_choco_external_gold_adapter`
  Import mode: `excerpt_directory`
  Manifest: `output/chord_analyzer_benchmark\curated_gold\isophonics_choco_external_gold_manifest.json`
  Fixture/import directory: `tool/benchmark_fixtures/external_gold/isophonics_choco`
  License note: Source JAMS files from ChoCo Isophonics (CC BY 4.0). Fixture provenance is documented in tool/benchmark_fixtures/external_gold/isophonics_choco/README.md.
- `jaah_choco_slice`: 10/10 records (100.0%), 2897/2897 segments (100.0%); harmonic 2704/2704 (100.0%), non-harmonic 193/193 (100.0%)
  Adapter: `jaah_choco_external_gold_adapter`
  Import mode: `excerpt_directory`
  Manifest: `output/chord_analyzer_benchmark\curated_gold\jaah_choco_external_gold_manifest.json`
  Fixture/import directory: `tool/benchmark_fixtures/external_gold/jaah_choco`
  License note: Source JAMS files from ChoCo JAAH (CC BY-NC-SA 4.0). Fixture provenance is documented in tool/benchmark_fixtures/external_gold/jaah_choco/README.md.
- Source ids: beatles_all_my_loving, beatles_devil_in_her_heart, beatles_eleanor_rigby, beatles_for_no_one, beatles_it_wont_be_long, beatles_taxman, jazz_big_butter_and_egg_man, jazz_blue_7, jazz_blues_in_the_closet, jazz_cotton_tail, jazz_doggin_around, jazz_for_dancers_only, jazz_four_brothers, jazz_grandpas_spells, jazz_the_preacher, jazz_weather_bird, mozart_k279_1, mozart_k279_2, mozart_k279_3, mozart_k280_1, n01op18-1_01, n01op18-1_02, n01op18-1_03, n01op18-1_04, n02op18-2_01, n02op18-2_02, n02op18-2_03, n02op18-2_04, n03op18-3_01, n03op18-3_02, n03op18-3_03, n03op18-3_04, n04op18-4_01, n04op18-4_02, n04op18-4_03, n04op18-4_04, n05op18-5_01, n05op18-5_02, n05op18-5_03, n05op18-5_04, n13op130_04
- Annotation levels: functional, roman, surface
- Surface-only corpora contribute to key/mode/resolved-symbol evaluation, but Roman/function metrics remain `n/a` when the source annotation does not include those labels.
- Key scopes: global_movement, local_excerpt

### Coverage By Corpus

| Bucket | Raw Records | Loaded | Raw Segments | Kept | Raw Harmonic | Kept Harmonic | Raw Non-Harmonic | Kept Non-Harmonic | Record Coverage | Segment Coverage | Harmonic Coverage |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| dcml_abc_excerpt | 24 | 24 | 352 | 352 | 352 | 352 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| when_in_rome_rntxt_excerpt | 10 | 10 | 260 | 260 | 260 | 260 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| isophonics_choco_slice | 6 | 6 | 399 | 399 | 386 | 386 | 13 | 13 | 100.0% | 100.0% | 100.0% |
| jaah_choco_slice | 10 | 10 | 2897 | 2897 | 2704 | 2704 | 193 | 193 | 100.0% | 100.0% | 100.0% |

### Coverage By Source Id

| Bucket | Raw Records | Loaded | Raw Segments | Kept | Raw Harmonic | Kept Harmonic | Raw Non-Harmonic | Kept Non-Harmonic | Record Coverage | Segment Coverage | Harmonic Coverage |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| beatles_all_my_loving | 1 | 1 | 71 | 71 | 69 | 69 | 2 | 2 | 100.0% | 100.0% | 100.0% |
| beatles_devil_in_her_heart | 1 | 1 | 92 | 92 | 89 | 89 | 3 | 3 | 100.0% | 100.0% | 100.0% |
| beatles_eleanor_rigby | 1 | 1 | 55 | 55 | 53 | 53 | 2 | 2 | 100.0% | 100.0% | 100.0% |
| beatles_for_no_one | 1 | 1 | 68 | 68 | 66 | 66 | 2 | 2 | 100.0% | 100.0% | 100.0% |
| beatles_it_wont_be_long | 1 | 1 | 70 | 70 | 68 | 68 | 2 | 2 | 100.0% | 100.0% | 100.0% |
| beatles_taxman | 1 | 1 | 43 | 43 | 41 | 41 | 2 | 2 | 100.0% | 100.0% | 100.0% |
| jazz_big_butter_and_egg_man | 1 | 1 | 160 | 160 | 159 | 159 | 1 | 1 | 100.0% | 100.0% | 100.0% |
| jazz_blue_7 | 1 | 1 | 377 | 377 | 284 | 284 | 93 | 93 | 100.0% | 100.0% | 100.0% |
| jazz_blues_in_the_closet | 1 | 1 | 563 | 563 | 562 | 562 | 1 | 1 | 100.0% | 100.0% | 100.0% |
| jazz_cotton_tail | 1 | 1 | 452 | 452 | 442 | 442 | 10 | 10 | 100.0% | 100.0% | 100.0% |
| jazz_doggin_around | 1 | 1 | 200 | 200 | 183 | 183 | 17 | 17 | 100.0% | 100.0% | 100.0% |
| jazz_for_dancers_only | 1 | 1 | 225 | 225 | 224 | 224 | 1 | 1 | 100.0% | 100.0% | 100.0% |
| jazz_four_brothers | 1 | 1 | 264 | 264 | 250 | 250 | 14 | 14 | 100.0% | 100.0% | 100.0% |
| jazz_grandpas_spells | 1 | 1 | 199 | 199 | 175 | 175 | 24 | 24 | 100.0% | 100.0% | 100.0% |
| jazz_the_preacher | 1 | 1 | 241 | 241 | 240 | 240 | 1 | 1 | 100.0% | 100.0% | 100.0% |
| jazz_weather_bird | 1 | 1 | 216 | 216 | 185 | 185 | 31 | 31 | 100.0% | 100.0% | 100.0% |
| mozart_k279_1 | 5 | 5 | 135 | 135 | 135 | 135 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| mozart_k279_2 | 2 | 2 | 46 | 46 | 46 | 46 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| mozart_k279_3 | 1 | 1 | 25 | 25 | 25 | 25 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| mozart_k280_1 | 2 | 2 | 54 | 54 | 54 | 54 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n01op18-1_01 | 3 | 3 | 34 | 34 | 34 | 34 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n01op18-1_02 | 1 | 1 | 24 | 24 | 24 | 24 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n01op18-1_03 | 1 | 1 | 16 | 16 | 16 | 16 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n01op18-1_04 | 1 | 1 | 22 | 22 | 22 | 22 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n02op18-2_01 | 1 | 1 | 13 | 13 | 13 | 13 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n02op18-2_02 | 1 | 1 | 16 | 16 | 16 | 16 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n02op18-2_03 | 1 | 1 | 10 | 10 | 10 | 10 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n02op18-2_04 | 1 | 1 | 17 | 17 | 17 | 17 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n03op18-3_01 | 1 | 1 | 10 | 10 | 10 | 10 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n03op18-3_02 | 1 | 1 | 22 | 22 | 22 | 22 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n03op18-3_03 | 1 | 1 | 19 | 19 | 19 | 19 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n03op18-3_04 | 1 | 1 | 15 | 15 | 15 | 15 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n04op18-4_01 | 1 | 1 | 24 | 24 | 24 | 24 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n04op18-4_02 | 1 | 1 | 8 | 8 | 8 | 8 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n04op18-4_03 | 1 | 1 | 16 | 16 | 16 | 16 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n04op18-4_04 | 1 | 1 | 16 | 16 | 16 | 16 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n05op18-5_01 | 1 | 1 | 9 | 9 | 9 | 9 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n05op18-5_02 | 2 | 2 | 25 | 25 | 25 | 25 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n05op18-5_03 | 1 | 1 | 12 | 12 | 12 | 12 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n05op18-5_04 | 1 | 1 | 16 | 16 | 16 | 16 | 0 | 0 | 100.0% | 100.0% | 100.0% |
| n13op130_04 | 1 | 1 | 8 | 8 | 8 | 8 | 0 | 0 | 100.0% | 100.0% | 100.0% |

## Accuracy

### Accuracy By Benchmark Class

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Curated gold | 50 | 38.0% | 58.0% | 92.0% | 68.3% | n/a | n/a | n/a | 100.0% | 100.0% | 6.842 ms |
| Dirty input | 5 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | 100.0% | 100.0% | n/a | 1.082 ms |
| Workbook proxy | 73 | 98.6% | 98.6% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 1.356 ms |

### Overall

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Overall | 128 | 75.0% | 82.8% | 96.9% | 70.7% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 3.488 ms |

### By Track

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ambiguity validation | 20 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 0.918 ms |
| S-tier Gold core | 108 | 70.4% | 79.6% | 96.3% | 70.1% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 3.964 ms |

### By Genre

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| classical | 38 | 39.5% | 65.8% | 89.5% | 68.5% | 100.0% | 100.0% | n/a | 100.0% | n/a | 2.210 ms |
| jazz | 51 | 84.3% | 84.3% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 5.926 ms |
| mixed | 13 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | 100.0% | 100.0% | n/a | 1.096 ms |
| pop | 26 | 96.2% | 96.2% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 1.771 ms |

### By Difficulty

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ambiguous | 17 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 100.0% | n/a | 0.866 ms |
| Easy | 10 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 100.0% | 100.0% | n/a | 3.374 ms |
| Hard | 69 | 53.6% | 68.1% | 94.2% | 68.4% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 5.309 ms |
| Medium | 32 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 0.992 ms |

## Proxy Vs External Gold

### Proxy Vs External

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Internal proxy | 78 | 98.7% | 98.7% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% | n/a | 1.339 ms |
| External gold | 50 | 38.0% | 58.0% | 92.0% | 68.3% | n/a | n/a | n/a | 100.0% | 100.0% | 6.842 ms |

## External Gold Accuracy

### External Gold Overall

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| External gold | 50 | 38.0% | 58.0% | 92.0% | 68.3% | n/a | n/a | n/a | 100.0% | 100.0% | 6.842 ms |

### External Gold By Corpus

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| dcml_abc_excerpt | 24 | 33.3% | 58.3% | 83.3% | 61.6% | n/a | n/a | n/a | 100.0% | n/a | 2.135 ms |
| isophonics_choco_slice | 6 | 83.3% | 83.3% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 4.291 ms |
| jaah_choco_slice | 10 | 20.0% | 20.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 23.835 ms |
| when_in_rome_rntxt_excerpt | 10 | 40.0% | 80.0% | 100.0% | 77.3% | n/a | n/a | n/a | 100.0% | n/a | 2.677 ms |

### External Gold By Source Id

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| beatles_all_my_loving | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 4.262 ms |
| beatles_devil_in_her_heart | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 4.941 ms |
| beatles_eleanor_rigby | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 3.988 ms |
| beatles_for_no_one | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 4.703 ms |
| beatles_it_wont_be_long | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 4.389 ms |
| beatles_taxman | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 3.463 ms |
| jazz_big_butter_and_egg_man | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.247 ms |
| jazz_blue_7 | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 22.253 ms |
| jazz_blues_in_the_closet | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 45.474 ms |
| jazz_cotton_tail | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 39.985 ms |
| jazz_doggin_around | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.289 ms |
| jazz_for_dancers_only | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 19.819 ms |
| jazz_four_brothers | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 23.883 ms |
| jazz_grandpas_spells | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.906 ms |
| jazz_the_preacher | 1 | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 22.593 ms |
| jazz_weather_bird | 1 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 14.901 ms |
| mozart_k279_1 | 5 | 40.0% | 80.0% | 100.0% | 77.0% | n/a | n/a | n/a | 100.0% | n/a | 2.998 ms |
| mozart_k279_2 | 2 | 0.0% | 100.0% | 100.0% | 93.5% | n/a | n/a | n/a | 100.0% | n/a | 2.384 ms |
| mozart_k279_3 | 1 | 0.0% | 0.0% | 100.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 2.167 ms |
| mozart_k280_1 | 2 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 2.423 ms |
| n01op18-1_01 | 3 | 66.7% | 66.7% | 100.0% | 85.3% | n/a | n/a | n/a | 100.0% | n/a | 1.757 ms |
| n01op18-1_02 | 1 | 0.0% | 100.0% | 100.0% | 75.0% | n/a | n/a | n/a | 100.0% | n/a | 3.561 ms |
| n01op18-1_03 | 1 | 0.0% | 0.0% | 0.0% | 31.3% | n/a | n/a | n/a | 100.0% | n/a | 1.603 ms |
| n01op18-1_04 | 1 | 0.0% | 0.0% | 100.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 4.012 ms |
| n02op18-2_01 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 1.593 ms |
| n02op18-2_02 | 1 | 0.0% | 100.0% | 100.0% | 93.8% | n/a | n/a | n/a | 100.0% | n/a | 1.888 ms |
| n02op18-2_03 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 2.876 ms |
| n02op18-2_04 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 2.055 ms |
| n03op18-3_01 | 1 | 0.0% | 0.0% | 100.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 1.263 ms |
| n03op18-3_02 | 1 | 0.0% | 0.0% | 100.0% | 86.4% | n/a | n/a | n/a | 100.0% | n/a | 2.602 ms |
| n03op18-3_03 | 1 | 0.0% | 100.0% | 100.0% | 73.7% | n/a | n/a | n/a | 100.0% | n/a | 2.403 ms |
| n03op18-3_04 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 1.680 ms |
| n04op18-4_01 | 1 | 0.0% | 0.0% | 0.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 3.309 ms |
| n04op18-4_02 | 1 | 0.0% | 0.0% | 100.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 1.600 ms |
| n04op18-4_03 | 1 | 0.0% | 0.0% | 0.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 2.940 ms |
| n04op18-4_04 | 1 | 0.0% | 100.0% | 100.0% | 87.5% | n/a | n/a | n/a | 100.0% | n/a | 2.160 ms |
| n05op18-5_01 | 1 | 0.0% | 100.0% | 100.0% | 88.9% | n/a | n/a | n/a | 100.0% | n/a | 1.328 ms |
| n05op18-5_02 | 2 | 50.0% | 50.0% | 100.0% | 96.0% | n/a | n/a | n/a | 100.0% | n/a | 2.068 ms |
| n05op18-5_03 | 1 | 0.0% | 100.0% | 100.0% | 66.7% | n/a | n/a | n/a | 100.0% | n/a | 1.317 ms |
| n05op18-5_04 | 1 | 0.0% | 0.0% | 0.0% | 0.0% | n/a | n/a | n/a | 100.0% | n/a | 2.242 ms |
| n13op130_04 | 1 | 100.0% | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | 100.0% | n/a | 1.393 ms |

### External Gold By Annotation Level

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| functional | 24 | 33.3% | 58.3% | 83.3% | 61.6% | n/a | n/a | n/a | 100.0% | n/a | 2.135 ms |
| roman | 10 | 40.0% | 80.0% | 100.0% | 77.3% | n/a | n/a | n/a | 100.0% | n/a | 2.677 ms |
| surface | 16 | 43.8% | 43.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.506 ms |

### External Gold By Key Scope

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| global_movement | 16 | 43.8% | 43.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.506 ms |
| local_excerpt | 34 | 35.3% | 64.7% | 88.2% | 68.3% | n/a | n/a | n/a | 100.0% | n/a | 2.294 ms |

### External Gold By Segmentation Scope

| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| full_movement | 16 | 43.8% | 43.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | 100.0% | 16.506 ms |
| measure_window | 34 | 35.3% | 64.7% | 88.2% | 68.3% | n/a | n/a | n/a | 100.0% | n/a | 2.294 ms |

### External Gold Key/Mode/Function

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| External gold | 58.0% | 70.0% | 92.0% | 30.2% | 68.3% | 81.5% | 78.9% | 100.0% | n/a |

### External Gold By Corpus Raw/Canonical

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| dcml_abc_excerpt | 58.3% | 66.7% | 83.3% | 27.6% | 61.6% | 79.0% | 77.3% | n/a | n/a |
| isophonics_choco_slice | 83.3% | 83.3% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jaah_choco_slice | 20.0% | 60.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| when_in_rome_rntxt_excerpt | 80.0% | 80.0% | 100.0% | 33.8% | 77.3% | 85.0% | 81.2% | n/a | n/a |

### External Gold By Source Id Raw/Canonical

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| beatles_all_my_loving | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| beatles_devil_in_her_heart | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| beatles_eleanor_rigby | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| beatles_for_no_one | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| beatles_it_wont_be_long | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| beatles_taxman | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_big_butter_and_egg_man | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_blue_7 | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_blues_in_the_closet | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_cotton_tail | 0.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_doggin_around | 0.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_for_dancers_only | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_four_brothers | 0.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_grandpas_spells | 0.0% | 0.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_the_preacher | 100.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| jazz_weather_bird | 0.0% | 100.0% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| mozart_k279_1 | 80.0% | 80.0% | 100.0% | 34.1% | 77.0% | 85.9% | 83.0% | n/a | n/a |
| mozart_k279_2 | 100.0% | 100.0% | 100.0% | 39.1% | 93.5% | 93.5% | 89.1% | n/a | n/a |
| mozart_k279_3 | 0.0% | 0.0% | 100.0% | 0.0% | 0.0% | 32.0% | 32.0% | n/a | n/a |
| mozart_k280_1 | 100.0% | 100.0% | 100.0% | 44.4% | 100.0% | 100.0% | 92.6% | n/a | n/a |
| n01op18-1_01 | 66.7% | 66.7% | 100.0% | 38.2% | 85.3% | 91.2% | 82.4% | n/a | n/a |
| n01op18-1_02 | 100.0% | 100.0% | 100.0% | 16.7% | 75.0% | 91.7% | 91.7% | n/a | n/a |
| n01op18-1_03 | 0.0% | 0.0% | 0.0% | 6.3% | 31.3% | 56.3% | 56.3% | n/a | n/a |
| n01op18-1_04 | 0.0% | 0.0% | 100.0% | 0.0% | 0.0% | 45.5% | 45.5% | n/a | n/a |
| n02op18-2_01 | 100.0% | 100.0% | 100.0% | 61.5% | 100.0% | 100.0% | 100.0% | n/a | n/a |
| n02op18-2_02 | 100.0% | 100.0% | 100.0% | 43.8% | 93.8% | 93.8% | 93.8% | n/a | n/a |
| n02op18-2_03 | 100.0% | 100.0% | 100.0% | 60.0% | 100.0% | 100.0% | 100.0% | n/a | n/a |
| n02op18-2_04 | 100.0% | 100.0% | 100.0% | 41.2% | 100.0% | 100.0% | 94.1% | n/a | n/a |
| n03op18-3_01 | 0.0% | 0.0% | 100.0% | 0.0% | 0.0% | 30.0% | 30.0% | n/a | n/a |
| n03op18-3_02 | 0.0% | 100.0% | 100.0% | 63.6% | 86.4% | 86.4% | 86.4% | n/a | n/a |
| n03op18-3_03 | 100.0% | 100.0% | 100.0% | 15.8% | 73.7% | 78.9% | 78.9% | n/a | n/a |
| n03op18-3_04 | 100.0% | 100.0% | 100.0% | 46.7% | 100.0% | 100.0% | 100.0% | n/a | n/a |
| n04op18-4_01 | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% | 66.7% | 66.7% | n/a | n/a |
| n04op18-4_02 | 0.0% | 0.0% | 100.0% | 0.0% | 0.0% | 37.5% | 37.5% | n/a | n/a |
| n04op18-4_03 | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% | 43.8% | 43.8% | n/a | n/a |
| n04op18-4_04 | 100.0% | 100.0% | 100.0% | 25.0% | 87.5% | 87.5% | 81.3% | n/a | n/a |
| n05op18-5_01 | 100.0% | 100.0% | 100.0% | 33.3% | 88.9% | 88.9% | 77.8% | n/a | n/a |
| n05op18-5_02 | 50.0% | 100.0% | 100.0% | 40.0% | 96.0% | 100.0% | 100.0% | n/a | n/a |
| n05op18-5_03 | 100.0% | 100.0% | 100.0% | 50.0% | 66.7% | 75.0% | 75.0% | n/a | n/a |
| n05op18-5_04 | 0.0% | 0.0% | 0.0% | 0.0% | 0.0% | 56.3% | 56.3% | n/a | n/a |
| n13op130_04 | 100.0% | 100.0% | 100.0% | 50.0% | 100.0% | 100.0% | 100.0% | n/a | n/a |

### External Gold By Annotation Level Raw/Canonical

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| functional | 58.3% | 66.7% | 83.3% | 27.6% | 61.6% | 79.0% | 77.3% | n/a | n/a |
| roman | 80.0% | 80.0% | 100.0% | 33.8% | 77.3% | 85.0% | 81.2% | n/a | n/a |
| surface | 43.8% | 68.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |

### External Gold By Key Scope Raw/Canonical

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| global_movement | 43.8% | 68.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| local_excerpt | 64.7% | 70.6% | 88.2% | 30.2% | 68.3% | 81.5% | 78.9% | n/a | n/a |

### External Gold By Segmentation Scope Raw/Canonical

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| full_movement | 43.8% | 68.8% | 100.0% | n/a | n/a | n/a | n/a | 100.0% | n/a |
| measure_window | 64.7% | 70.6% | 88.2% | 30.2% | 68.3% | 81.5% | 78.9% | n/a | n/a |

### External Gold Surface-vs-Canonical Gaps

| Bucket | Roman Surface Exact | Roman Canonical Exact | Gap |
| --- | ---: | ---: | ---: |
| n04op18-4_04 | 25.0% | 87.5% | 62.5% |
| n02op18-2_04 | 41.2% | 100.0% | 58.8% |
| n01op18-1_02 | 16.7% | 75.0% | 58.3% |
| n03op18-3_03 | 15.8% | 73.7% | 57.9% |
| n05op18-5_02 | 40.0% | 96.0% | 56.0% |
| mozart_k280_1 | 44.4% | 100.0% | 55.6% |
| n05op18-5_01 | 33.3% | 88.9% | 55.6% |
| mozart_k279_2 | 39.1% | 93.5% | 54.3% |
| n03op18-3_04 | 46.7% | 100.0% | 53.3% |
| n02op18-2_02 | 43.8% | 93.8% | 50.0% |
| n13op130_04 | 50.0% | 100.0% | 50.0% |
| n01op18-1_01 | 38.2% | 85.3% | 47.1% |
| mozart_k279_1 | 34.1% | 77.0% | 43.0% |
| n02op18-2_03 | 60.0% | 100.0% | 40.0% |
| n02op18-2_01 | 61.5% | 100.0% | 38.5% |

## Key/Mode/Function Breakdown

### Overall

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Overall | 82.8% | 87.5% | 96.9% | 30.2% | 70.7% | 83.0% | 80.6% | 100.0% | 100.0% |

### By Benchmark Class

| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Curated gold | 58.0% | 70.0% | 92.0% | 30.2% | 68.3% | 81.5% | 78.9% | 100.0% | n/a |
| Dirty input | 100.0% | 100.0% | 100.0% | n/a | 100.0% | 100.0% | 100.0% | n/a | n/a |
| Workbook proxy | 98.6% | 98.6% | 100.0% | n/a | 100.0% | 100.0% | 100.0% | n/a | 100.0% |

## Major Failure Clusters

- `canonical_roman_miss_case`: 22 external cases
- `relaxed_function_still_miss_case`: 21 external cases
- `key_center_miss`: 15 external cases
- `large_surface_notation_gap_source`: 15 external cases
- `notation_only_key_miss`: 6 external cases
- `dominant_of_expected_key_miss`: 4 external cases
- `mode_miss`: 4 external cases

## Failure Cases

- `gold-classical-c-real-modulation` real modulation stays distinct from tonicization
  Progression: `Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7`
  Issues: expected key C, got G
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: modulation_vs_tonicization, ambiguous_key_center, ending_bias
  Key diagnostics: top-2 G major 171.96 vs C major 151.33; gap 20.63; ending dominant 3/4; dominant overhang 0.25; applied dominants 4; tonicization remarks 4; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
- `curated-abc-n01op18-1_01-mc195-202` Op. 18 no. 1 mvmnt 1 (mc 195-202)
  Progression: `Bbm Gb Ebm | Db/F | Db7 | Gb | Gb | Db7/Ab | Gb/Bb Gb/Bb`
  Issues: expected key Db, got F#/Gb; segment[0] expected VIm, got IIIm; segment[1] expected IV, got I; segment[2] expected IIm, got VIm; segment[3] expected I, got V; segment[4] expected V7/IV, got V7
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F#/Gb major 153.75 vs A#/Bb minor 147.23; gap 6.52; ending dominant 1/4; dominant overhang -0.05; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: expected VIm but got IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: expected IV but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: expected IIm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected V7/IV but got V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected V7 but got V7 (roman_surface_mismatch)
  Segment 8: expected I but got I (roman_surface_mismatch)
  Segment 9: expected I but got I (roman_surface_mismatch)
- `curated-abc-n01op18-1_02-mc3-10` op18_no1_mvmnt2_all (mc 3-10)
  Progression: `Dm Dm/F A | Dm Bb/D | C#dim7/E C#dim7/E | Dm/F Dm/F C#dim/E Dm | Em7b5/G Em7b5/G E7/G# | A A7/C# Dm Edim/G G#dim | A A Dm Edim/G G#dim`
  Issues: segment[4] expected VI, got bVI; segment[5] expected #VIIdim7, got VIIdim7; segment[6] expected #VIIdim7, got VIIdim7; segment[9] expected #VIIdim, got VIIdim; segment[18] expected VIIdim/V, got bVdim; segment[23] expected VIIdim/V, got bVdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 D minor 259.85 vs F major 178.04; gap 81.81; ending dominant 1/4; dominant overhang -0.13; applied dominants 1; tonicization remarks 1; real modulation remarks 0; expected-rank 1
  Segment 0: expected Im but got Im (roman_surface_mismatch)
  Segment 1: expected Im but got Im (roman_surface_mismatch)
  Segment 3: expected Im but got Im (roman_surface_mismatch)
  Segment 4: expected VI but got bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: expected #VIIdim7 but got VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected #VIIdim7 but got VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected Im but got Im (roman_surface_mismatch)
  Segment 8: expected Im but got Im (roman_surface_mismatch)
  Segment 9: expected #VIIdim but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 10: expected Im but got Im (roman_surface_mismatch)
  Segment 11: expected IIm7b5 but got IIm7b5 (roman_surface_mismatch)
  Segment 12: expected IIm7b5 but got IIm7b5 (roman_surface_mismatch)
  Segment 13: expected V7/V but got V7/V (roman_surface_mismatch)
  Segment 15: expected V7 but got V7 (roman_surface_mismatch)
  Segment 16: expected Im but got Im (roman_surface_mismatch)
  Segment 17: expected IIdim but got IIdim (roman_surface_mismatch)
  Segment 18: expected VIIdim/V but got bVdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: expected Im but got Im (roman_surface_mismatch)
  Segment 22: expected IIdim but got IIdim (roman_surface_mismatch)
  Segment 23: expected VIIdim/V but got bVdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n01op18-1_03-mc17-24` op.18 no.1 mvmnt.3 (mc 17-24)
  Progression: `Db | Ab Ab Ddim/F | Ebm | Bb Bb Edim/G | Fm | C C Fm/Ab | Edim | Fm Db Bdim7`
  Issues: expected key Db, got F; expected mode major, got minor; segment[0] expected I, got bVI; segment[1] expected V, got bIII; segment[2] expected V, got bIII; segment[3] expected #VIIdim/II, got VIdim; segment[4] expected IIm, got bVIIm; segment[5] expected V/II, got IV; segment[6] expected V/II, got IV; segment[7] expected #VIIdim/III, got VIIdim; segment[12] expected #VIIdim, got VIIdim; segment[14] expected VI, got bVI; segment[15] expected VIIdim7/V, got bVdim7
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F minor 122.50 vs D#/Eb major 117.78; gap 4.72; ending dominant 1/4; dominant overhang 0.00; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: expected I but got bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: expected V but got bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: expected V but got bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected #VIIdim/II but got VIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected IIm but got bVIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected V/II but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected V/II but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected #VIIdim/III but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: expected Im but got Im (roman_surface_mismatch)
  Segment 9: expected V but got V (roman_surface_mismatch)
  Segment 11: expected Im but got Im (roman_surface_mismatch)
  Segment 12: expected #VIIdim but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: expected Im but got Im (roman_surface_mismatch)
  Segment 14: expected VI but got bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected VIIdim7/V but got bVdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n01op18-1_04-mc68-75` Op.18 no1:4 (mc 68-75)
  Progression: `F A7/C# | Dm | G7 G G7 | C G7/D G7/F | C/E C G7/D G7/F | C/E C F | G G7 | Cm Cm G7/D G`
  Issues: expected key C, got G; segment[0] expected IV, got bVII; segment[1] expected V7/II, got V7/V; segment[2] expected IIm, got II/IVm; segment[3] expected V7, got V7/IV; segment[4] expected V, got I; segment[5] expected V7, got V7/IV; segment[6] expected I, got IV; segment[7] expected V7, got V7/IV; segment[8] expected V7, got V7/IV; segment[9] expected I, got IV; segment[10] expected I, got IV; segment[11] expected V7, got V7/IV; segment[12] expected V7, got V7/IV; segment[13] expected I, got IV; segment[14] expected I, got IV; segment[15] expected IV, got bVII; segment[16] expected V, got I; segment[17] expected V7, got V7/IV; segment[18] expected Im, got IVm; segment[19] expected Im, got IVm; segment[20] expected V7, got V7/IV; segment[21] expected V, got I
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 G major 298.87 vs C major 283.85; gap 15.02; ending dominant 1/4; dominant overhang -0.25; applied dominants 9; tonicization remarks 4; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: expected IV but got bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected V7/II but got V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected IIm but got II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 9: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 15: expected IV but got bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: expected Im but got IVm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 19: expected Im but got IVm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 20: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n02op18-2_02-mc1-08` n02op18-2_02 (mc 1-8)
  Progression: `C | G7/D G7/D C | G G | G7 G#dim7 Am | Dm/F Dm G7 G7 | C C | C`
  Issues: segment[7] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 220.33 vs A minor 211.78; gap 8.55; ending dominant 1/4; dominant overhang -0.19; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: expected V7 but got V7 (roman_surface_mismatch)
  Segment 2: expected V7 but got V7 (roman_surface_mismatch)
  Segment 4: expected V but got V (roman_surface_mismatch)
  Segment 7: expected #VIIdim7/VI but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected VIm but got VIm (roman_surface_mismatch)
  Segment 9: expected IIm but got IIm (roman_surface_mismatch)
  Segment 10: expected IIm but got IIm (roman_surface_mismatch)
  Segment 11: expected V7 but got V7 (roman_surface_mismatch)
  Segment 13: expected I but got I (roman_surface_mismatch)
- `curated-abc-n03op18-3_01-mc1-08` String Quartet Op18 No3 (mc 1-8)
  Progression: `D | A7 | D D | A7/E | D/F# | G | A | A A7`
  Issues: expected key D, got A; segment[0] expected I, got IV; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected I, got IV; segment[4] expected V7, got V7/IV; segment[5] expected I, got IV; segment[6] expected IV, got bVII; segment[7] expected V, got I; segment[8] expected V, got I; segment[9] expected V7, got V7/IV
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 A major 149.75 vs D major 146.79; gap 2.96; ending dominant 2/4; dominant overhang 0.10; applied dominants 3; tonicization remarks 1; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected IV but got bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n03op18-3_02-mc1-08` String Quartet Op18 No3 (mc 1-8)
  Progression: `Bb F7/A Bb | F7 G#dim7/B F7 | Bb/F C#dim7 Bb/D | C7 F7 | Bb F7/C Bb | F F7 G#dim7/F F7 | Bb/F | C7 F F7`
  Issues: expected key Bb, got A#/Bb; segment[4] expected #VIdim7, got bVIIdim7; segment[7] expected #IIdim7, got bIIIdim7; segment[16] expected #VIdim7, got bVIIdim7
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 280.92 vs F major 271.03; gap 9.89; ending dominant 3/4; dominant overhang 0.20; applied dominants 2; tonicization remarks 1; real modulation remarks 0
  Segment 1: expected V7 but got V7 (roman_surface_mismatch)
  Segment 4: expected #VIdim7 but got bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected I but got I (roman_surface_mismatch)
  Segment 7: expected #IIdim7 but got bIIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected I but got I (roman_surface_mismatch)
  Segment 12: expected V7 but got V7 (roman_surface_mismatch)
  Segment 16: expected #VIdim7 but got bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: expected I but got I (roman_surface_mismatch)
- `curated-abc-n03op18-3_03-mc15-22` String Quartet Op18 No3 (mc 15-22)
  Progression: `G Gaug | C Am/C | D7/C D7/C G/B | D D Daug/F# | G A7/E | D/F# D/F# A7/C# | D D Em7 | E#dim7`
  Issues: segment[14] expected V7, got V7/V; segment[15] expected I, got V; segment[16] expected I, got V; segment[17] expected IIm7, got VIm7; segment[18] expected #VIIdim7/III, got bVIIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 G major 227.16 vs D major 223.36; gap 3.80; ending dominant 2/4; dominant overhang -0.08; applied dominants 2; tonicization remarks 1; real modulation remarks 2; expected-rank 1
  Segment 1: expected Iaug but got Iaug (roman_surface_mismatch)
  Segment 3: expected IIm but got IIm (roman_surface_mismatch)
  Segment 4: expected V7 but got V7 (roman_surface_mismatch)
  Segment 5: expected V7 but got V7 (roman_surface_mismatch)
  Segment 6: expected I but got I (roman_surface_mismatch)
  Segment 7: expected V but got V (roman_surface_mismatch)
  Segment 9: expected Vaug but got Vaug (roman_surface_mismatch)
  Segment 10: expected I but got I (roman_surface_mismatch)
  Segment 11: expected V7/V but got V7/V (roman_surface_mismatch)
  Segment 12: expected V but got V (roman_surface_mismatch)
  Segment 13: expected V but got V (roman_surface_mismatch)
  Segment 14: expected V7 but got V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected IIm7 but got VIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: expected #VIIdim7/III but got bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n04op18-4_01-mc5-12` String Quartet Op18 No4 (mc 5-12)
  Progression: `Edim7/Db Fm/Ab | Ddim/F Cm/G | Bdim/F Bdim7 Cm | Dm/F Dm/F Ab7 Bdim7 G7 | Cm/Eb G7/B Cm | G7 Bdim7/F Cm/Eb | G7/B Cm | Dm7b5/F Dm7b5/F Dm7b5/Ab Dm7b5/F`
  Issues: expected key C, got D#/Eb; expected mode minor, got major; segment[0] expected #IIIdim7, got #Idim7; segment[1] expected IVm, got IIm; segment[2] expected IIdim, got VIIdim; segment[3] expected Im, got VIm; segment[4] expected #VIIdim, got bVIdim; segment[5] expected #VIIdim7, got bVIdim7; segment[6] expected Im, got VIm; segment[7] expected IIm, got VIIm; segment[8] expected IIm, got VIIm; segment[9] expected VI7, got subV7/III; segment[10] expected #VIIdim7, got bVIdim7; segment[11] expected V7, got V7/VI; segment[12] expected Im, got VIm; segment[13] expected V7, got V7/VI; segment[14] expected Im, got VIm; segment[15] expected V7, got V7/VI; segment[16] expected #VIIdim7, got bVIdim7; segment[17] expected Im, got VIm; segment[18] expected V7, got V7/VI; segment[19] expected Im, got VIm; segment[20] expected IIm7b5, got VIIm7b5; segment[21] expected IIm7b5, got VIIm7b5; segment[22] expected IIm7b5, got VIIm7b5; segment[23] expected IIm7b5, got VIIm7b5
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D#/Eb major 233.78 vs C minor 230.85; gap 2.93; ending dominant 0/4; dominant overhang -0.29; applied dominants 4; tonicization remarks 3; real modulation remarks 2; expected-rank 2
  Segment 0: expected #IIIdim7 but got #Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected IVm but got IIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected IIdim but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: expected #VIIdim but got bVIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected #VIIdim7 but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected IIm but got VIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected IIm but got VIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected VI7 but got subV7/III (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: expected #VIIdim7 but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: expected V7 but got V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: expected V7 but got V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected V7 but got V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 16: expected #VIIdim7 but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: expected V7 but got V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: expected Im but got VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 20: expected IIm7b5 but got VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: expected IIm7b5 but got VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 22: expected IIm7b5 but got VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 23: expected IIm7b5 but got VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n04op18-4_02-mc6-09` String Quartet Op18 No4 (mc 6-9)
  Progression: `D D7 | G | C/E C Am | D7/F# D`
  Issues: expected key G, got D; segment[0] expected V, got I; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected IV, got bVII; segment[4] expected IV, got bVII; segment[5] expected IIm, got II/IVm; segment[6] expected V7, got V7/IV; segment[7] expected V, got I
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 123.25 vs G major 112.37; gap 10.88; ending dominant 2/4; dominant overhang 0.00; applied dominants 2; tonicization remarks 1; real modulation remarks 0; expected-rank 2; selected key is dominant-of-expected
  Segment 0: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected IV but got bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected IV but got bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected IIm but got II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n04op18-4_03-mc1-08` String Quartet Op18 No4 (mc 1-8)
  Progression: `Cm | Cm B | E A/C# | E/G# A#dim7/C# | A#dim7 B Fm | Edim/G | Fm/Ab Dm7b5/F | G G G7`
  Issues: expected key C, got G#/Ab; expected mode minor, got major; segment[0] expected Im, got IIIm; segment[1] expected Im, got IIIm; segment[2] expected V, got bIII; segment[3] expected I, got bVI; segment[4] expected IV, got bII; segment[5] expected I, got bVI; segment[6] expected VIIdim7/V, got IIdim7; segment[7] expected VIIdim7/V, got IIdim7; segment[8] expected V, got bIII; segment[9] expected IVm, got VIm; segment[10] expected #VIIdim/IV, got bVIdim; segment[11] expected IVm, got VIm; segment[12] expected IIm7b5, got II/IIIm7b5; segment[13] expected V, got VII; segment[14] expected V, got VII; segment[15] expected V7, got V7/III
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 G#/Ab major 118.91 vs D#/Eb major 106.76; gap 12.16; ending dominant 3/4; dominant overhang 0.56; applied dominants 1; tonicization remarks 0; real modulation remarks 0; expected-rank 4
  Segment 0: expected Im but got IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: expected Im but got IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected V but got bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected I but got bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected IV but got bII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: expected I but got bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected VIIdim7/V but got IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected VIIdim7/V but got IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected V but got bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected IVm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: expected #VIIdim/IV but got bVIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: expected IVm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 12: expected IIm7b5 but got II/IIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: expected V but got VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: expected V but got VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected V7 but got V7/III (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n04op18-4_04-mc20-27` String Quartet Op18 No4 (mc 20-27)
  Progression: `A | E7/B | A/C# D#dim/F# | E E7 | A#dim7/E Bm/D | G#dim7/D A/C# | Bm/E Bm/D E E7 | A A`
  Issues: segment[3] expected VIIdim/V, got II/IIIdim; segment[6] expected #VIIdim7/II, got #Idim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 A major 218.65 vs F#/Gb minor 186.48; gap 32.17; ending dominant 2/4; dominant overhang 0.19; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: expected V7 but got V7 (roman_surface_mismatch)
  Segment 2: expected I but got I (roman_surface_mismatch)
  Segment 3: expected VIIdim/V but got II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected V but got V (roman_surface_mismatch)
  Segment 6: expected #VIIdim7/II but got #Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected IIm but got IIm (roman_surface_mismatch)
  Segment 8: expected VIIdim7 but got VIIdim7 (roman_surface_mismatch, function_mismatch)
  Segment 9: expected I but got I (roman_surface_mismatch)
  Segment 10: expected IIm but got IIm (roman_surface_mismatch)
  Segment 11: expected IIm but got IIm (roman_surface_mismatch)
  Segment 12: expected V but got V (roman_surface_mismatch)
  Segment 14: expected I but got I (roman_surface_mismatch)
- `curated-abc-n05op18-5_01-mc5-12` String Quartet Op.18 No.5 (mc 5-12)
  Progression: `D | E7/D | A/C# | C#dim/E | D | E7/D G#dim/B | A/C# | E7`
  Issues: segment[3] expected VIIdim/IV, got IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 A major 118.34 vs D major 113.22; gap 5.12; ending dominant 2/4; dominant overhang 0.17; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: expected V7 but got V7 (roman_surface_mismatch)
  Segment 2: expected I but got I (roman_surface_mismatch)
  Segment 3: expected VIIdim/IV but got IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected V7 but got V7 (roman_surface_mismatch)
  Segment 6: expected VIIdim but got VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 7: expected I but got I (roman_surface_mismatch)
- `curated-abc-n05op18-5_02-mc38-45` String Quartet Op.18 No.5 (mc 38-45)
  Progression: `G# | G# | C#m/E | C#m/G# | B#dim7/A G# | G#7/F# | C#m/E | C#m/E C#m`
  Issues: expected key C#, got C#/Db; segment[4] expected #VIIdim7, got VIIdim7
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence, secondary_dominant_notation_gap
  Key diagnostics: top-2 C#/Db minor 136.66 vs G#/Ab major 95.22; gap 41.44; ending dominant 1/4; dominant overhang -0.25; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: expected V but got V (roman_surface_mismatch)
  Segment 2: expected Im but got Im (roman_surface_mismatch)
  Segment 3: expected Im but got Im (roman_surface_mismatch)
  Segment 4: expected #VIIdim7 but got VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected V7 but got V7 (roman_surface_mismatch)
  Segment 7: expected Im but got Im (roman_surface_mismatch)
  Segment 8: expected Im but got Im (roman_surface_mismatch)
  Segment 9: expected Im but got Im (roman_surface_mismatch)
- `curated-abc-n05op18-5_03-mc7-14` String Quartet Op.18 No.5 (mc 7-14)
  Progression: `A | E E7 | A/B A | D G | D | D7/C | G/B G D`
  Issues: segment[1] expected V, got II; segment[2] expected V7, got V7/V; segment[3] expected I, got V; segment[4] expected I, got V
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 165.22 vs A major 146.44; gap 18.78; ending dominant 1/4; dominant overhang -0.17; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: expected V but got II (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: expected V7 but got V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected V7/IV but got V7/IV (roman_surface_mismatch)
  Segment 9: expected IV but got IV (roman_surface_mismatch)
- `curated-abc-n05op18-5_04-mc195-202` String Quartet Op.18 No.5 (mc 195-202)
  Progression: `D Bm/D | A/C# A/C# | G#dim/B G#dim/B | A D/A | G#dim7 E/G# | F#m7 D#dim/F# | E E7 | A Am/C`
  Issues: expected key A, got F#/Gb; expected mode major, got minor; segment[0] expected IV, got bVI; segment[1] expected IIm, got IVm; segment[2] expected I, got bIII; segment[3] expected I, got bIII; segment[4] expected VIIdim, got IIdim; segment[5] expected VIIdim, got IIdim; segment[6] expected I, got bIII; segment[7] expected IV, got bVI; segment[8] expected VIIdim7, got IIdim7; segment[9] expected V, got bVII; segment[10] expected VIm7, got Im7; segment[11] expected VIIdim/V, got VIdim; segment[12] expected V, got bVII; segment[13] expected V7, got V7/bIII; segment[14] expected I, got bIII; segment[15] expected Im, got bIIIm
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F#/Gb minor 188.37 vs A major 185.61; gap 2.76; ending dominant 2/4; dominant overhang 0.31; applied dominants 1; tonicization remarks 0; real modulation remarks 2; expected-rank 2
  Segment 0: expected IV but got bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected IIm but got IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected I but got bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: expected I but got bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: expected VIIdim but got IIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected VIIdim but got IIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected I but got bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected IV but got bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: expected VIIdim7 but got IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected V but got bVII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 10: expected VIm7 but got Im7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 11: expected VIIdim/V but got VIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 12: expected V but got bVII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: expected V7 but got V7/bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: expected I but got bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected Im but got bIIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_1-mm9-16` K279-1 (mm 9-16)
  Progression: `C/E F | C/G G7 G#dim7 Am | C/E F | C/G G7 C C7 | F Bdim/D C C7 | F Bdim/D C/E G7 | C G7 C/E Dm/F | C/G G`
  Issues: segment[4] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 351.32 vs A minor 345.12; gap 6.20; ending dominant 1/4; dominant overhang -0.02; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 0: expected I but got I (roman_surface_mismatch)
  Segment 2: expected I but got I (roman_surface_mismatch)
  Segment 4: expected #VIIdim7/VI but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected VIm but got VIm (roman_surface_mismatch, function_mismatch)
  Segment 6: expected I but got I (roman_surface_mismatch)
  Segment 8: expected I but got I (roman_surface_mismatch)
  Segment 13: expected VIIdim but got VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 17: expected VIIdim but got VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 18: expected I but got I (roman_surface_mismatch)
  Segment 22: expected I but got I (roman_surface_mismatch)
  Segment 23: expected IIm but got IIm (roman_surface_mismatch)
  Segment 24: expected I but got I (roman_surface_mismatch)
- `curated-mozart_k279_1-mm39-49` K279-1 (mm 39-49)
  Progression: `Gm | A7/G | Dm/F | G7/F | C/E | Bb/D | E E7/G# Am Am7/G F#dim Cm/D# | D D7/F# Gm Gm7/F Edim A#/D | C C7/E F | C/E | G7/D C C`
  Issues: expected key C, got F; segment[0] expected Vm, got IIm; segment[1] expected V7/II, got V7/VI; segment[2] expected IIm, got VIm; segment[3] expected V7, got V7/V; segment[4] expected I, got V; segment[5] expected bII/VI, got IV; segment[6] expected V/VI, got VII; segment[7] expected V7/VI, got V7/III; segment[8] expected VIm, got IIIm; segment[9] expected VIm7, got IIIm7; segment[10] expected #VIIdim/V, got #Idim; segment[11] expected IVm/V, got II/IVm; segment[12] expected V/V, got VI; segment[13] expected V7/V, got V7/II; segment[14] expected Vm, got IIm; segment[15] expected Vm7, got IIm7; segment[16] expected VIIdim/IV, got VIIdim; segment[17] expected IV/IV, got IV; segment[18] expected V/IV, got V; segment[19] expected V7/IV, got V7; segment[20] expected I/IV, got I; segment[21] expected I, got V; segment[22] expected V7, got V7/V; segment[23] expected I, got V; segment[24] expected I, got V
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F major 309.18 vs C major 282.01; gap 27.17; ending dominant 4/4; dominant overhang 0.52; applied dominants 5; tonicization remarks 2; real modulation remarks 6; expected-rank 2
  Segment 0: expected Vm but got IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: expected V7/II but got V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected IIm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected V7 but got V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: expected bII/VI but got IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected V/VI but got VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: expected V7/VI but got V7/III (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: expected VIm but got IIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected VIm7 but got IIIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: expected #VIIdim/V but got #Idim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: expected IVm/V but got II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: expected V/V but got VI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 13: expected V7/V but got V7/II (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: expected Vm but got IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 15: expected Vm7 but got IIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: expected VIIdim/IV but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected IV/IV but got IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: expected V/IV but got V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: expected V7/IV but got V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 20: expected I/IV but got I (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 22: expected V7 but got V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 23: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 24: expected I but got V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_1-mm62-69` K279-1 (mm 62-69)
  Progression: `C C7/A# C7/A# | F/A F/A | C#dim7/G | C#dim/G Bdim7/F | C/E Cm/D# D7 D7 G7/B | C C F#dim7 G G7 | C F#dim/A G G7 | C F#dim/A G`
  Issues: segment[5] expected #VIIdim7/II, got #Idim7; segment[6] expected #VIIdim/II, got #Idim; segment[15] expected VIIdim7/V, got II/IIIdim7; segment[19] expected VIIdim/V, got II/IIIdim; segment[23] expected VIIdim/V, got II/IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 305.97 vs G major 284.62; gap 21.35; ending dominant 2/4; dominant overhang 0.10; applied dominants 4; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: expected V7/IV but got V7/IV (roman_surface_mismatch)
  Segment 2: expected V7/IV but got V7/IV (roman_surface_mismatch)
  Segment 3: expected IV but got IV (roman_surface_mismatch)
  Segment 4: expected IV but got IV (roman_surface_mismatch)
  Segment 5: expected #VIIdim7/II but got #Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: expected #VIIdim/II but got #Idim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected VIIdim7 but got VIIdim7 (roman_surface_mismatch, function_mismatch)
  Segment 8: expected I but got I (roman_surface_mismatch)
  Segment 9: expected Im but got Im (roman_surface_mismatch)
  Segment 10: expected V7/V but got V7/V (roman_surface_mismatch)
  Segment 12: expected V7 but got V7 (roman_surface_mismatch)
  Segment 13: expected I but got I (roman_surface_mismatch)
  Segment 15: expected VIIdim7/V but got II/IIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 19: expected VIIdim/V but got II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 23: expected VIIdim/V but got II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_2-mm0-10` K279-2 (mm 0-10)
  Progression: `F | C7/G F | C7/E C7 F | Gm/Bb F/C C7 | Bb/D C7/E F | Gm/Bb F/C C7 | F | F/C C | F F7/Eb Adim | Bb Bb G7/B | C`
  Issues: segment[20] expected VIIdim/IV, got IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 F major 355.78 vs D minor 318.50; gap 37.28; ending dominant 2/4; dominant overhang 0.10; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: expected V7 but got V7 (roman_surface_mismatch)
  Segment 3: expected V7 but got V7 (roman_surface_mismatch)
  Segment 6: expected IIm but got IIm (roman_surface_mismatch)
  Segment 7: expected I but got I (roman_surface_mismatch)
  Segment 9: expected IV but got IV (roman_surface_mismatch)
  Segment 10: expected V7 but got V7 (roman_surface_mismatch)
  Segment 12: expected IIm but got IIm (roman_surface_mismatch)
  Segment 13: expected I but got I (roman_surface_mismatch)
  Segment 16: expected I but got I (roman_surface_mismatch)
  Segment 18: expected I but got I (roman_surface_mismatch)
  Segment 19: expected V7/IV but got V7/IV (roman_surface_mismatch)
  Segment 20: expected VIIdim/IV but got IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: expected IV but got IV (roman_surface_mismatch)
  Segment 23: expected V7/V but got V7/V (roman_surface_mismatch)
- `curated-mozart_k279_2-mm11-20` K279-2 (mm 11-20)
  Progression: `G7/D | C/E | G7/B | C | D7/F# G G7/F | C/E F C/G G7 | C/E | F#dim7 G Bm7b5 | C G#dim7 Am | Dm/F C/G G7`
  Issues: segment[12] expected VIIdim7/V, got II/IIIdim7; segment[16] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 283.23 vs G major 270.13; gap 13.10; ending dominant 1/4; dominant overhang -0.13; applied dominants 1; tonicization remarks 1; real modulation remarks 0; expected-rank 1
  Segment 0: expected V7 but got V7 (roman_surface_mismatch)
  Segment 1: expected I but got I (roman_surface_mismatch)
  Segment 2: expected V7 but got V7 (roman_surface_mismatch)
  Segment 4: expected V7/V but got V7/V (roman_surface_mismatch)
  Segment 6: expected V7 but got V7 (roman_surface_mismatch)
  Segment 7: expected I but got I (roman_surface_mismatch)
  Segment 9: expected I but got I (roman_surface_mismatch)
  Segment 11: expected I but got I (roman_surface_mismatch)
  Segment 12: expected VIIdim7/V but got II/IIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: expected VIIm7b5 but got VIIm7b5 (roman_surface_mismatch, function_mismatch)
  Segment 16: expected #VIIdim7/VI but got bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected VIm but got VIm (roman_surface_mismatch, function_mismatch)
  Segment 18: expected IIm but got IIm (roman_surface_mismatch)
  Segment 19: expected I but got I (roman_surface_mismatch)
- `curated-mozart_k279_3-mm14-25` K279-3 (mm 14-25)
  Progression: `D7/A | D7 | Em Bm/D | Am/C A7/C# | D D7/C G/B | D/A G D7/F# G | D D7/C G/B | D/A G D7/F# G | D | Em C#dim/E D | Bm/D`
  Issues: expected key G, got D; segment[0] expected V7, got V7/IV; segment[1] expected V7, got V7/IV; segment[2] expected VIm, got IIm; segment[3] expected IIIm, got VIm; segment[4] expected IIm, got II/IVm; segment[5] expected V7/V, got V7; segment[6] expected V, got I; segment[7] expected V7, got V7/IV; segment[8] expected I, got IV; segment[9] expected V, got I; segment[10] expected I, got IV; segment[11] expected V7, got V7/IV; segment[12] expected I, got IV; segment[13] expected V, got I; segment[14] expected V7, got V7/IV; segment[15] expected I, got IV; segment[16] expected V, got I; segment[17] expected I, got IV; segment[18] expected V7, got V7/IV; segment[19] expected I, got IV; segment[20] expected V, got I; segment[21] expected VIm, got IIm; segment[22] expected VIIdim/V, got VIIdim; segment[23] expected V, got I; segment[24] expected IIIm, got VIm
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 351.49 vs G major 345.92; gap 5.57; ending dominant 0/4; dominant overhang -0.28; applied dominants 6; tonicization remarks 3; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: expected VIm but got IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: expected IIIm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: expected IIm but got II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: expected V7/V but got V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 13: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: expected V7 but got V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: expected I but got IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 20: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: expected VIm but got IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 22: expected VIIdim/V but got VIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 23: expected V but got I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 24: expected IIIm but got VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-isophonics-isophonics_109` Taxman (Revolver)
  Progression: `N.C. D7 D7#9 D7 D7#9 D7 C G7 D7 D7#9 D7 D7#9 D7 C G7 D7 C9 D7 C9 D7 C G7 D7 D7#9 D7 D7#9 D7 C G7 D7 D7 D7#9 D7 D7#9 D7 C G7 D7 F7 D7 D7#9 D7 N.C.`
  Issues: expected key D, got G
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G major 541.68 vs E minor 531.68; gap 10.00; ending dominant 4/4; dominant overhang 0.12; applied dominants 5; tonicization remarks 0; real modulation remarks 0
  No-chord events: expected 2, got 2
- `curated-jaah-jaah_12` Doggin' Around
  Progression: `N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Eb7 Eb7 C7 F7 Bb Bb N.C.`
  Issues: expected key Bb, got A#/Bb
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 2457.98 vs F major 2279.46; gap 178.52; ending dominant 2/4; dominant overhang -0.04; applied dominants 36; tonicization remarks 10; real modulation remarks 0
  No-chord events: expected 17, got 17
- `curated-jaah-jaah_13` Weather Bird
  Progression: `Db Dbm Ab6 F7 Bb7 Eb7 Ab Ab Db6 Ddim7 Ab Ab Eb7 Edim7 Fm7 Fm7 Fm7 F7 G7 Cm Eb7 Ab Db6 Ddim7 Ab F7 Bbm7 Ddim7 Ab F7 Bb7 Eb7 Ab Eb7 Eb7 Ab6 Eb7 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Edim7 Fm7 Ab7 Db Dbm Ab6 F7 Bb7 Eb7 Ab Eb7 Eb7 Ab6 Eb7 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Edim7 Fm7 Ab7 Db Dbm Ab6 F7 Bb7 Eb7 Ab Ab Db6 Ddim7 Ab Ab Eb7 Edim7 Fm G7 Cm Eb7 Ab Db6 Ddim7 Ab F7 Bbm7 Ddim7 Ab F7 Bb7 Eb7 Ab Ab Abaug Ab6 Ab6 Dbdim7 Eb7 Eb7 Ab Ab Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab Ab Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. N.C. N.C. Abdim7 Abdim7 Abdim7 N.C. N.C. Db Ddim7 Ab N.C. Ab N.C. Ab7 Dbm7 Dbm6 Dbm6 N.C. N.C. N.C. N.C. Ab Ab Ab N.C.`
  Issues: expected key Ab, got G#/Ab
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 G#/Ab major 2312.06 vs D#/Eb major 2208.14; gap 103.92; ending dominant 0/4; dominant overhang -0.37; applied dominants 30; tonicization remarks 9; real modulation remarks 0
  No-chord events: expected 31, got 31
- `curated-jaah-jaah_2` Grandpa's Spells
  Progression: `N.C. N.C. G7 Bbdim7 G7 C C D7 D7 G7 G7 C Ebdim7 G7 C C D7 D7 G7 G7 C G7 C C N.C. N.C. N.C. N.C. D7 N.C. N.C. N.C. N.C. G7 G7 C Ebdim7 G7 C N.C. N.C. N.C. N.C. D7 N.C. N.C. N.C. N.C. G7 G7 C G7 C D7 G7 C Ebdim7 G7 G7 C C D7 G7 C A7 Dm7 E7 Am D7 G7 C D7 D7 C Ebdim7 G7 G7 C N.C. N.C. N.C. N.C. D7 G7 C A7 Dm7 E7 Am D7 G7 C C C D7 D7 G7 G7 C Ebdim7 G7 C C D7 D7 G7 G7 C G7 C F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F N.C. F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F C7 F N.C.`
  Issues: expected key C, got F
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 F major 2105.86 vs C major 2052.88; gap 52.98; ending dominant 1/4; dominant overhang -0.52; applied dominants 66; tonicization remarks 26; real modulation remarks 23; expected-rank 2
  No-chord events: expected 24, got 24
- `curated-jaah-jaah_31` Blue 7
  Progression: `Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 N.C. Bb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. F7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. Eb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7`
  Issues: expected key Bb, got G#/Ab
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G#/Ab major 3874.90 vs G#/Ab minor 3874.90; gap 0.00; ending dominant 4/4; dominant overhang 0.00; applied dominants 189; tonicization remarks 0; real modulation remarks 0
  No-chord events: expected 93, got 93
- `curated-jaah-jaah_34` Cotton Tail
  Progression: `Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb Bb Bb Bb Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 Bb N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Bb Bb Bb Bb Bb N.C.`
  Issues: expected key Bb, got A#/Bb
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 5954.89 vs D#/Eb major 5312.90; gap 641.99; ending dominant 0/4; dominant overhang -0.42; applied dominants 94; tonicization remarks 30; real modulation remarks 32
  No-chord events: expected 10, got 10
- `curated-jaah-jaah_6` For Dancers Only
  Progression: `Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab N.C.`
  Issues: expected key Eb, got G#/Ab
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G#/Ab major 2947.36 vs D#/Eb major 2821.75; gap 125.61; ending dominant 1/4; dominant overhang -0.20; applied dominants 38; tonicization remarks 13; real modulation remarks 24
  No-chord events: expected 1, got 1
- `curated-jaah-jaah_92` Blues in the Closet
  Progression: `Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Bb7 Bb7 N.C.`
  Issues: expected key Bb, got D#/Eb
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 D#/Eb major 7027.30 vs G#/Ab major 6881.70; gap 145.60; ending dominant 4/4; dominant overhang 0.08; applied dominants 258; tonicization remarks 43; real modulation remarks 0
  No-chord events: expected 1, got 1
- `curated-jaah-jaah_98` Four Brothers
  Progression: `Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Ab6 Ab6 Ab6 Ab6 Ab6 N.C. N.C.`
  Issues: expected key Ab, got G#/Ab
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 G#/Ab major 3003.22 vs D#/Eb major 2544.64; gap 458.58; ending dominant 0/4; dominant overhang -0.42; applied dominants 70; tonicization remarks 30; real modulation remarks 30
  No-chord events: expected 14, got 14

## External Gold Failures

- `curated-abc-n01op18-1_01-mc195-202` Op. 18 no. 1 mvmnt 1 (mc 195-202)
  Source id: `n01op18-1_01`
  Progression: `Bbm Gb Ebm | Db/F | Db7 | Gb | Gb | Db7/Ab | Gb/Bb Gb/Bb`
  Issues: expected key Db, got F#/Gb; segment[0] expected VIm, got IIIm; segment[1] expected IV, got I; segment[2] expected IIm, got VIm; segment[3] expected I, got V; segment[4] expected V7/IV, got V7
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F#/Gb major 153.75 vs A#/Bb minor 147.23; gap 6.52; ending dominant 1/4; dominant overhang -0.05; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: surface=vi, canonical=VIm, analyzer=IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: surface=IV, canonical=IV, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: surface=ii, canonical=IIm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=I6, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=V7/IV, canonical=V7/IV, analyzer=V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 8: surface=I6(6), canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 9: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-abc-n01op18-1_02-mc3-10` op18_no1_mvmnt2_all (mc 3-10)
  Source id: `n01op18-1_02`
  Progression: `Dm Dm/F A | Dm Bb/D | C#dim7/E C#dim7/E | Dm/F Dm/F C#dim/E Dm | Em7b5/G Em7b5/G E7/G# | A A7/C# Dm Edim/G G#dim | A A Dm Edim/G G#dim`
  Issues: segment[4] expected VI, got bVI; segment[5] expected #VIIdim7, got VIIdim7; segment[6] expected #VIIdim7, got VIIdim7; segment[9] expected #VIIdim, got VIIdim; segment[18] expected VIIdim/V, got bVdim; segment[23] expected VIIdim/V, got bVdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 D minor 259.85 vs F major 178.04; gap 81.81; ending dominant 1/4; dominant overhang -0.13; applied dominants 1; tonicization remarks 1; real modulation remarks 0; expected-rank 1
  Segment 0: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 1: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 3: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 4: surface=VI6, canonical=VI, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: surface=#viio65(2), canonical=#VIIdim7, analyzer=VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=#viio65, canonical=#VIIdim7, analyzer=VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=i6(2), canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 8: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 9: surface=#viio6, canonical=#VIIdim, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 10: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 11: surface=ii%65(2), canonical=IIm7b5, analyzer=IIm7b5 (roman_surface_mismatch)
  Segment 12: surface=ii%65, canonical=IIm7b5, analyzer=IIm7b5 (roman_surface_mismatch)
  Segment 13: surface=V65/V, canonical=V7/V, analyzer=V7/V (roman_surface_mismatch)
  Segment 15: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 16: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 17: surface=iio6, canonical=IIdim, analyzer=IIdim (roman_surface_mismatch)
  Segment 18: surface=viio/V, canonical=VIIdim/V, analyzer=bVdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 22: surface=iio6, canonical=IIdim, analyzer=IIdim (roman_surface_mismatch)
  Segment 23: surface=viio/V, canonical=VIIdim/V, analyzer=bVdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n01op18-1_03-mc17-24` op.18 no.1 mvmnt.3 (mc 17-24)
  Source id: `n01op18-1_03`
  Progression: `Db | Ab Ab Ddim/F | Ebm | Bb Bb Edim/G | Fm | C C Fm/Ab | Edim | Fm Db Bdim7`
  Issues: expected key Db, got F; expected mode major, got minor; segment[0] expected I, got bVI; segment[1] expected V, got bIII; segment[2] expected V, got bIII; segment[3] expected #VIIdim/II, got VIdim; segment[4] expected IIm, got bVIIm; segment[5] expected V/II, got IV; segment[6] expected V/II, got IV; segment[7] expected #VIIdim/III, got VIIdim; segment[12] expected #VIIdim, got VIIdim; segment[14] expected VI, got bVI; segment[15] expected VIIdim7/V, got bVdim7
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F minor 122.50 vs D#/Eb major 117.78; gap 4.72; ending dominant 1/4; dominant overhang 0.00; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: surface=I, canonical=I, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: surface=V(64), canonical=V, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: surface=V, canonical=V, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=#viio6/ii, canonical=#VIIdim/II, analyzer=VIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=ii, canonical=IIm, analyzer=bVIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=V(64)/ii, canonical=V/II, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=V/ii, canonical=V/II, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=#viio6/iii, canonical=#VIIdim/III, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 9: surface=V(64), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 11: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 12: surface=#viio, canonical=#VIIdim, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: surface=i(4+2), canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 14: surface=VI, canonical=VI, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=viio7/V, canonical=VIIdim7/V, analyzer=bVdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n01op18-1_04-mc68-75` Op.18 no1:4 (mc 68-75)
  Source id: `n01op18-1_04`
  Progression: `F A7/C# | Dm | G7 G G7 | C G7/D G7/F | C/E C G7/D G7/F | C/E C F | G G7 | Cm Cm G7/D G`
  Issues: expected key C, got G; segment[0] expected IV, got bVII; segment[1] expected V7/II, got V7/V; segment[2] expected IIm, got II/IVm; segment[3] expected V7, got V7/IV; segment[4] expected V, got I; segment[5] expected V7, got V7/IV; segment[6] expected I, got IV; segment[7] expected V7, got V7/IV; segment[8] expected V7, got V7/IV; segment[9] expected I, got IV; segment[10] expected I, got IV; segment[11] expected V7, got V7/IV; segment[12] expected V7, got V7/IV; segment[13] expected I, got IV; segment[14] expected I, got IV; segment[15] expected IV, got bVII; segment[16] expected V, got I; segment[17] expected V7, got V7/IV; segment[18] expected Im, got IVm; segment[19] expected Im, got IVm; segment[20] expected V7, got V7/IV; segment[21] expected V, got I
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 G major 298.87 vs C major 283.85; gap 15.02; ending dominant 1/4; dominant overhang -0.25; applied dominants 9; tonicization remarks 4; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: surface=IV, canonical=IV, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=V65/ii, canonical=V7/II, analyzer=V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=ii, canonical=IIm, analyzer=II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: surface=V7(+2), canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: surface=V(64), canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=V43, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: surface=V2, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 9: surface=I6, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: surface=V43, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: surface=V2, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: surface=I6, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 15: surface=IV, canonical=IV, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: surface=V(64), canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: surface=i, canonical=Im, analyzer=IVm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 19: surface=i, canonical=Im, analyzer=IVm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 20: surface=V43, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n02op18-2_02-mc1-08` n02op18-2_02 (mc 1-8)
  Source id: `n02op18-2_02`
  Progression: `C | G7/D G7/D C | G G | G7 G#dim7 Am | Dm/F Dm G7 G7 | C C | C`
  Issues: segment[7] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 220.33 vs A minor 211.78; gap 8.55; ending dominant 1/4; dominant overhang -0.19; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V43(4), canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 2: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 4: surface=V(64), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 7: surface=#viio7/vi, canonical=#VIIdim7/VI, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=vi, canonical=VIm, analyzer=VIm (roman_surface_mismatch)
  Segment 9: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 10: surface=ii, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 11: surface=V7(9), canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 13: surface=I(4+2), canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-abc-n03op18-3_01-mc1-08` String Quartet Op18 No3 (mc 1-8)
  Source id: `n03op18-3_01`
  Progression: `D | A7 | D D | A7/E | D/F# | G | A | A A7`
  Issues: expected key D, got A; segment[0] expected I, got IV; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected I, got IV; segment[4] expected V7, got V7/IV; segment[5] expected I, got IV; segment[6] expected IV, got bVII; segment[7] expected V, got I; segment[8] expected V, got I; segment[9] expected V7, got V7/IV
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 A major 149.75 vs D major 146.79; gap 2.96; ending dominant 2/4; dominant overhang 0.10; applied dominants 3; tonicization remarks 1; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=I(4), canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=V43, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: surface=I6, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=IV, canonical=IV, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=V(64), canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n03op18-3_02-mc1-08` String Quartet Op18 No3 (mc 1-8)
  Source id: `n03op18-3_02`
  Progression: `Bb F7/A Bb | F7 G#dim7/B F7 | Bb/F C#dim7 Bb/D | C7 F7 | Bb F7/C Bb | F F7 G#dim7/F F7 | Bb/F | C7 F F7`
  Issues: expected key Bb, got A#/Bb; segment[4] expected #VIdim7, got bVIIdim7; segment[7] expected #IIdim7, got bIIIdim7; segment[16] expected #VIdim7, got bVIIdim7
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 280.92 vs F major 271.03; gap 9.89; ending dominant 3/4; dominant overhang 0.20; applied dominants 2; tonicization remarks 1; real modulation remarks 0
  Segment 1: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 4: surface=#vio65, canonical=#VIdim7, analyzer=bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=I64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 7: surface=#iio7, canonical=#IIdim7, analyzer=bIIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 12: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 16: surface=#vio2, canonical=#VIdim7, analyzer=bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: surface=I64, canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-abc-n03op18-3_03-mc15-22` String Quartet Op18 No3 (mc 15-22)
  Source id: `n03op18-3_03`
  Progression: `G Gaug | C Am/C | D7/C D7/C G/B | D D Daug/F# | G A7/E | D/F# D/F# A7/C# | D D Em7 | E#dim7`
  Issues: segment[14] expected V7, got V7/V; segment[15] expected I, got V; segment[16] expected I, got V; segment[17] expected IIm7, got VIm7; segment[18] expected #VIIdim7/III, got bVIIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 G major 227.16 vs D major 223.36; gap 3.80; ending dominant 2/4; dominant overhang -0.08; applied dominants 2; tonicization remarks 1; real modulation remarks 2; expected-rank 1
  Segment 1: surface=I+, canonical=Iaug, analyzer=Iaug (roman_surface_mismatch)
  Segment 3: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 4: surface=V2(4), canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 5: surface=V2, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 6: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 7: surface=V(64), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 9: surface=V+6, canonical=Vaug, analyzer=Vaug (roman_surface_mismatch)
  Segment 10: surface=I(4), canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 11: surface=V43/V, canonical=V7/V, analyzer=V7/V (roman_surface_mismatch)
  Segment 12: surface=V6(2), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 13: surface=V6, canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 14: surface=V65, canonical=V7, analyzer=V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=I(4), canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: surface=I, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=ii7, canonical=IIm7, analyzer=VIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: surface=#viio7/iii, canonical=#VIIdim7/III, analyzer=bVIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n04op18-4_01-mc5-12` String Quartet Op18 No4 (mc 5-12)
  Source id: `n04op18-4_01`
  Progression: `Edim7/Db Fm/Ab | Ddim/F Cm/G | Bdim/F Bdim7 Cm | Dm/F Dm/F Ab7 Bdim7 G7 | Cm/Eb G7/B Cm | G7 Bdim7/F Cm/Eb | G7/B Cm | Dm7b5/F Dm7b5/F Dm7b5/Ab Dm7b5/F`
  Issues: expected key C, got D#/Eb; expected mode minor, got major; segment[0] expected #IIIdim7, got #Idim7; segment[1] expected IVm, got IIm; segment[2] expected IIdim, got VIIdim; segment[3] expected Im, got VIm; segment[4] expected #VIIdim, got bVIdim; segment[5] expected #VIIdim7, got bVIdim7; segment[6] expected Im, got VIm; segment[7] expected IIm, got VIIm; segment[8] expected IIm, got VIIm; segment[9] expected VI7, got subV7/III; segment[10] expected #VIIdim7, got bVIdim7; segment[11] expected V7, got V7/VI; segment[12] expected Im, got VIm; segment[13] expected V7, got V7/VI; segment[14] expected Im, got VIm; segment[15] expected V7, got V7/VI; segment[16] expected #VIIdim7, got bVIdim7; segment[17] expected Im, got VIm; segment[18] expected V7, got V7/VI; segment[19] expected Im, got VIm; segment[20] expected IIm7b5, got VIIm7b5; segment[21] expected IIm7b5, got VIIm7b5; segment[22] expected IIm7b5, got VIIm7b5; segment[23] expected IIm7b5, got VIIm7b5
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D#/Eb major 233.78 vs C minor 230.85; gap 2.93; ending dominant 0/4; dominant overhang -0.29; applied dominants 4; tonicization remarks 3; real modulation remarks 2; expected-rank 2
  Segment 0: surface=#iiio2, canonical=#IIIdim7, analyzer=#Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=iv6, canonical=IVm, analyzer=IIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=iio6, canonical=IIdim, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: surface=i64, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: surface=#viio64, canonical=#VIIdim, analyzer=bVIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=#viio7, canonical=#VIIdim7, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=i, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=ii6(2), canonical=IIm, analyzer=VIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=ii6, canonical=IIm, analyzer=VIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=VI7, canonical=VI7, analyzer=subV7/III (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: surface=#viio7, canonical=#VIIdim7, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: surface=V7, canonical=V7, analyzer=V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: surface=i6, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: surface=V65, canonical=V7, analyzer=V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: surface=i, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=V7, canonical=V7, analyzer=V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 16: surface=#viio43, canonical=#VIIdim7, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=i6, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: surface=V65, canonical=V7, analyzer=V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: surface=i, canonical=Im, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 20: surface=ii%65(2), canonical=IIm7b5, analyzer=VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: surface=ii%65, canonical=IIm7b5, analyzer=VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 22: surface=ii%43, canonical=IIm7b5, analyzer=VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 23: surface=ii%65, canonical=IIm7b5, analyzer=VIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n04op18-4_02-mc6-09` String Quartet Op18 No4 (mc 6-9)
  Source id: `n04op18-4_02`
  Progression: `D D7 | G | C/E C Am | D7/F# D`
  Issues: expected key G, got D; segment[0] expected V, got I; segment[1] expected V7, got V7/IV; segment[2] expected I, got IV; segment[3] expected IV, got bVII; segment[4] expected IV, got bVII; segment[5] expected IIm, got II/IVm; segment[6] expected V7, got V7/IV; segment[7] expected V, got I
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 123.25 vs G major 112.37; gap 10.88; ending dominant 2/4; dominant overhang 0.00; applied dominants 2; tonicization remarks 1; real modulation remarks 0; expected-rank 2; selected key is dominant-of-expected
  Segment 0: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=IV6, canonical=IV, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=IV, canonical=IV, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=ii, canonical=IIm, analyzer=II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=V65, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-abc-n04op18-4_03-mc1-08` String Quartet Op18 No4 (mc 1-8)
  Source id: `n04op18-4_03`
  Progression: `Cm | Cm B | E A/C# | E/G# A#dim7/C# | A#dim7 B Fm | Edim/G | Fm/Ab Dm7b5/F | G G G7`
  Issues: expected key C, got G#/Ab; expected mode minor, got major; segment[0] expected Im, got IIIm; segment[1] expected Im, got IIIm; segment[2] expected V, got bIII; segment[3] expected I, got bVI; segment[4] expected IV, got bII; segment[5] expected I, got bVI; segment[6] expected VIIdim7/V, got IIdim7; segment[7] expected VIIdim7/V, got IIdim7; segment[8] expected V, got bIII; segment[9] expected IVm, got VIm; segment[10] expected #VIIdim/IV, got bVIdim; segment[11] expected IVm, got VIm; segment[12] expected IIm7b5, got II/IIIm7b5; segment[13] expected V, got VII; segment[14] expected V, got VII; segment[15] expected V7, got V7/III
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 G#/Ab major 118.91 vs D#/Eb major 106.76; gap 12.16; ending dominant 3/4; dominant overhang 0.56; applied dominants 1; tonicization remarks 0; real modulation remarks 0; expected-rank 4
  Segment 0: surface=i, canonical=Im, analyzer=IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: surface=i, canonical=Im, analyzer=IIIm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=V, canonical=V, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=I, canonical=I, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=IV6, canonical=IV, analyzer=bII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: surface=I6, canonical=I, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=viio65/V, canonical=VIIdim7/V, analyzer=IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=viio7/V, canonical=VIIdim7/V, analyzer=IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=V, canonical=V, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=iv, canonical=IVm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: surface=#viio6/iv, canonical=#VIIdim/IV, analyzer=bVIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: surface=iv6, canonical=IVm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 12: surface=ii%65, canonical=IIm7b5, analyzer=II/IIIm7b5 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: surface=V(964), canonical=V, analyzer=VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: surface=V(64), canonical=V, analyzer=VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=V7, canonical=V7, analyzer=V7/III (roman_surface_mismatch, roman_canonical_mismatch)
- `curated-abc-n04op18-4_04-mc20-27` String Quartet Op18 No4 (mc 20-27)
  Source id: `n04op18-4_04`
  Progression: `A | E7/B | A/C# D#dim/F# | E E7 | A#dim7/E Bm/D | G#dim7/D A/C# | Bm/E Bm/D E E7 | A A`
  Issues: segment[3] expected VIIdim/V, got II/IIIdim; segment[6] expected #VIIdim7/II, got #Idim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 A major 218.65 vs F#/Gb minor 186.48; gap 32.17; ending dominant 2/4; dominant overhang 0.19; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 2: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 3: surface=viio6/V, canonical=VIIdim/V, analyzer=II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=V(4), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 6: surface=#viio43/ii, canonical=#VIIdim7/II, analyzer=#Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 8: surface=viio43, canonical=VIIdim7, analyzer=VIIdim7 (roman_surface_mismatch, function_mismatch)
  Segment 9: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 10: surface=ii6(94), canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 11: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 12: surface=V(64), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 14: surface=I(974), canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-abc-n05op18-5_01-mc5-12` String Quartet Op.18 No.5 (mc 5-12)
  Source id: `n05op18-5_01`
  Progression: `D | E7/D | A/C# | C#dim/E | D | E7/D G#dim/B | A/C# | E7`
  Issues: segment[3] expected VIIdim/IV, got IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 A major 118.34 vs D major 113.22; gap 5.12; ending dominant 2/4; dominant overhang 0.17; applied dominants 0; tonicization remarks 0; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V2, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 2: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 3: surface=viio6/IV, canonical=VIIdim/IV, analyzer=IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=V2, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 6: surface=viio6, canonical=VIIdim, analyzer=VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 7: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-abc-n05op18-5_02-mc38-45` String Quartet Op.18 No.5 (mc 38-45)
  Source id: `n05op18-5_02`
  Progression: `G# | G# | C#m/E | C#m/G# | B#dim7/A G# | G#7/F# | C#m/E | C#m/E C#m`
  Issues: expected key C#, got C#/Db; segment[4] expected #VIIdim7, got VIIdim7
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence, secondary_dominant_notation_gap
  Key diagnostics: top-2 C#/Db minor 136.66 vs G#/Ab major 95.22; gap 41.44; ending dominant 1/4; dominant overhang -0.25; applied dominants 0; tonicization remarks 0; real modulation remarks 0
  Segment 0: surface=V(64), canonical=V, analyzer=V (roman_surface_mismatch)
  Segment 2: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 3: surface=i64, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 4: surface=#viio2, canonical=#VIIdim7, analyzer=VIIdim7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=V2, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 7: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 8: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 9: surface=i, canonical=Im, analyzer=Im (roman_surface_mismatch)
- `curated-abc-n05op18-5_03-mc7-14` String Quartet Op.18 No.5 (mc 7-14)
  Source id: `n05op18-5_03`
  Progression: `A | E E7 | A/B A | D G | D | D7/C | G/B G D`
  Issues: segment[1] expected V, got II; segment[2] expected V7, got V7/V; segment[3] expected I, got V; segment[4] expected I, got V
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 165.22 vs A major 146.44; gap 18.78; ending dominant 1/4; dominant overhang -0.17; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V(64), canonical=V, analyzer=II (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 2: surface=V7, canonical=V7, analyzer=V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: surface=I(742), canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=I, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=V2/IV, canonical=V7/IV, analyzer=V7/IV (roman_surface_mismatch)
  Segment 9: surface=IV6, canonical=IV, analyzer=IV (roman_surface_mismatch)
- `curated-abc-n05op18-5_04-mc195-202` String Quartet Op.18 No.5 (mc 195-202)
  Source id: `n05op18-5_04`
  Progression: `D Bm/D | A/C# A/C# | G#dim/B G#dim/B | A D/A | G#dim7 E/G# | F#m7 D#dim/F# | E E7 | A Am/C`
  Issues: expected key A, got F#/Gb; expected mode major, got minor; segment[0] expected IV, got bVI; segment[1] expected IIm, got IVm; segment[2] expected I, got bIII; segment[3] expected I, got bIII; segment[4] expected VIIdim, got IIdim; segment[5] expected VIIdim, got IIdim; segment[6] expected I, got bIII; segment[7] expected IV, got bVI; segment[8] expected VIIdim7, got IIdim7; segment[9] expected V, got bVII; segment[10] expected VIm7, got Im7; segment[11] expected VIIdim/V, got VIdim; segment[12] expected V, got bVII; segment[13] expected V7, got V7/bIII; segment[14] expected I, got bIII; segment[15] expected Im, got bIIIm
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F#/Gb minor 188.37 vs A major 185.61; gap 2.76; ending dominant 2/4; dominant overhang 0.31; applied dominants 1; tonicization remarks 0; real modulation remarks 2; expected-rank 2
  Segment 0: surface=IV, canonical=IV, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=ii6, canonical=IIm, analyzer=IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=I6(2), canonical=I, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 3: surface=I6, canonical=I, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: surface=viio6(2), canonical=VIIdim, analyzer=IIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=viio6, canonical=VIIdim, analyzer=IIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=I(7), canonical=I, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=IV64, canonical=IV, analyzer=bVI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 8: surface=viio7(4), canonical=VIIdim7, analyzer=IIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=V6, canonical=V, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 10: surface=vi7, canonical=VIm7, analyzer=Im7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 11: surface=viio6/V, canonical=VIIdim/V, analyzer=VIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 12: surface=V, canonical=V, analyzer=bVII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 13: surface=V7, canonical=V7, analyzer=V7/bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: surface=I(+2), canonical=I, analyzer=bIII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=i6, canonical=Im, analyzer=bIIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_1-mm9-16` K279-1 (mm 9-16)
  Source id: `mozart_k279_1`
  Progression: `C/E F | C/G G7 G#dim7 Am | C/E F | C/G G7 C C7 | F Bdim/D C C7 | F Bdim/D C/E G7 | C G7 C/E Dm/F | C/G G`
  Issues: segment[4] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 351.32 vs A minor 345.12; gap 6.20; ending dominant 1/4; dominant overhang -0.02; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 0: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 2: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 4: surface=#viio7/vi, canonical=#VIIdim7/VI, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=vi, canonical=VIm, analyzer=VIm (roman_surface_mismatch, function_mismatch)
  Segment 6: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 8: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 13: surface=viio6, canonical=VIIdim, analyzer=VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 17: surface=viio6, canonical=VIIdim, analyzer=VIIdim (roman_surface_mismatch, function_mismatch)
  Segment 18: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 22: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 23: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 24: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-mozart_k279_1-mm39-49` K279-1 (mm 39-49)
  Source id: `mozart_k279_1`
  Progression: `Gm | A7/G | Dm/F | G7/F | C/E | Bb/D | E E7/G# Am Am7/G F#dim Cm/D# | D D7/F# Gm Gm7/F Edim A#/D | C C7/E F | C/E | G7/D C C`
  Issues: expected key C, got F; segment[0] expected Vm, got IIm; segment[1] expected V7/II, got V7/VI; segment[2] expected IIm, got VIm; segment[3] expected V7, got V7/V; segment[4] expected I, got V; segment[5] expected bII/VI, got IV; segment[6] expected V/VI, got VII; segment[7] expected V7/VI, got V7/III; segment[8] expected VIm, got IIIm; segment[9] expected VIm7, got IIIm7; segment[10] expected #VIIdim/V, got #Idim; segment[11] expected IVm/V, got II/IVm; segment[12] expected V/V, got VI; segment[13] expected V7/V, got V7/II; segment[14] expected Vm, got IIm; segment[15] expected Vm7, got IIm7; segment[16] expected VIIdim/IV, got VIIdim; segment[17] expected IV/IV, got IV; segment[18] expected V/IV, got V; segment[19] expected V7/IV, got V7; segment[20] expected I/IV, got I; segment[21] expected I, got V; segment[22] expected V7, got V7/V; segment[23] expected I, got V; segment[24] expected I, got V
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 F major 309.18 vs C major 282.01; gap 27.17; ending dominant 4/4; dominant overhang 0.52; applied dominants 5; tonicization remarks 2; real modulation remarks 6; expected-rank 2
  Segment 0: surface=v, canonical=Vm, analyzer=IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 1: surface=V2/ii, canonical=V7/II, analyzer=V7/VI (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=ii6, canonical=IIm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=V2, canonical=V7, analyzer=V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 4: surface=I6, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 5: surface=bII6/vi, canonical=bII/VI, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=V/vi, canonical=V/VI, analyzer=VII (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 7: surface=V65/vi, canonical=V7/VI, analyzer=V7/III (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: surface=vi, canonical=VIm, analyzer=IIIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=vi2, canonical=VIm7, analyzer=IIIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: surface=#viio/v, canonical=#VIIdim/V, analyzer=#Idim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: surface=iv6/v, canonical=IVm/V, analyzer=II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: surface=V/v, canonical=V/V, analyzer=VI (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 13: surface=V65/v, canonical=V7/V, analyzer=V7/II (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 14: surface=v, canonical=Vm, analyzer=IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 15: surface=v2, canonical=Vm7, analyzer=IIm7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: surface=viio/IV, canonical=VIIdim/IV, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=IV6/IV, canonical=IV/IV, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 18: surface=V/IV, canonical=V/IV, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: surface=V65/IV, canonical=V7/IV, analyzer=V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 20: surface=I/IV, canonical=I/IV, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 21: surface=I6, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 22: surface=V43, canonical=V7, analyzer=V7/V (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 23: surface=I[no3][add#2], canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 24: surface=I, canonical=I, analyzer=V (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_1-mm62-69` K279-1 (mm 62-69)
  Source id: `mozart_k279_1`
  Progression: `C C7/A# C7/A# | F/A F/A | C#dim7/G | C#dim/G Bdim7/F | C/E Cm/D# D7 D7 G7/B | C C F#dim7 G G7 | C F#dim/A G G7 | C F#dim/A G`
  Issues: segment[5] expected #VIIdim7/II, got #Idim7; segment[6] expected #VIIdim/II, got #Idim; segment[15] expected VIIdim7/V, got II/IIIdim7; segment[19] expected VIIdim/V, got II/IIIdim; segment[23] expected VIIdim/V, got II/IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 305.97 vs G major 284.62; gap 21.35; ending dominant 2/4; dominant overhang 0.10; applied dominants 4; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V2[no3][add4]/IV, canonical=V7/IV, analyzer=V7/IV (roman_surface_mismatch)
  Segment 2: surface=V2/IV, canonical=V7/IV, analyzer=V7/IV (roman_surface_mismatch)
  Segment 3: surface=IV6[no8][no1][add7][add2], canonical=IV, analyzer=IV (roman_surface_mismatch)
  Segment 4: surface=IV6, canonical=IV, analyzer=IV (roman_surface_mismatch)
  Segment 5: surface=#viio43/ii, canonical=#VIIdim7/II, analyzer=#Idim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 6: surface=#viio64/ii, canonical=#VIIdim/II, analyzer=#Idim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=viio43, canonical=VIIdim7, analyzer=VIIdim7 (roman_surface_mismatch, function_mismatch)
  Segment 8: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 9: surface=i6, canonical=Im, analyzer=Im (roman_surface_mismatch)
  Segment 10: surface=V7[no3][add4]/V, canonical=V7/V, analyzer=V7/V (roman_surface_mismatch)
  Segment 12: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 13: surface=I[no3][add4], canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 15: surface=viio7/V, canonical=VIIdim7/V, analyzer=II/IIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 19: surface=viio6/V, canonical=VIIdim/V, analyzer=II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 23: surface=viio6/V, canonical=VIIdim/V, analyzer=II/IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-mozart_k279_2-mm0-10` K279-2 (mm 0-10)
  Source id: `mozart_k279_2`
  Progression: `F | C7/G F | C7/E C7 F | Gm/Bb F/C C7 | Bb/D C7/E F | Gm/Bb F/C C7 | F | F/C C | F F7/Eb Adim | Bb Bb G7/B | C`
  Issues: segment[20] expected VIIdim/IV, got IIIdim
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 F major 355.78 vs D minor 318.50; gap 37.28; ending dominant 2/4; dominant overhang 0.10; applied dominants 2; tonicization remarks 2; real modulation remarks 0; expected-rank 1
  Segment 1: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 3: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 6: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 7: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 9: surface=IV6, canonical=IV, analyzer=IV (roman_surface_mismatch)
  Segment 10: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 12: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 13: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 16: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 18: surface=I[no3][add9][add4], canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 19: surface=V2/IV, canonical=V7/IV, analyzer=V7/IV (roman_surface_mismatch)
  Segment 20: surface=viio/IV, canonical=VIIdim/IV, analyzer=IIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: surface=IV[add9], canonical=IV, analyzer=IV (roman_surface_mismatch)
  Segment 23: surface=V65/V, canonical=V7/V, analyzer=V7/V (roman_surface_mismatch)
- `curated-mozart_k279_2-mm11-20` K279-2 (mm 11-20)
  Source id: `mozart_k279_2`
  Progression: `G7/D | C/E | G7/B | C | D7/F# G G7/F | C/E F C/G G7 | C/E | F#dim7 G Bm7b5 | C G#dim7 Am | Dm/F C/G G7`
  Issues: segment[12] expected VIIdim7/V, got II/IIIdim7; segment[16] expected #VIIdim7/VI, got bVIdim7
  Key verdict: strict=match, relaxed=match
  Failure taxonomy: none
  Key diagnostics: top-2 C major 283.23 vs G major 270.13; gap 13.10; ending dominant 1/4; dominant overhang -0.13; applied dominants 1; tonicization remarks 1; real modulation remarks 0; expected-rank 1
  Segment 0: surface=V43, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 1: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 2: surface=V65, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 4: surface=V65/V, canonical=V7/V, analyzer=V7/V (roman_surface_mismatch)
  Segment 6: surface=V2, canonical=V7, analyzer=V7 (roman_surface_mismatch)
  Segment 7: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 9: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 11: surface=I6, canonical=I, analyzer=I (roman_surface_mismatch)
  Segment 12: surface=viio7/V, canonical=VIIdim7/V, analyzer=II/IIIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: surface=viiø7, canonical=VIIm7b5, analyzer=VIIm7b5 (roman_surface_mismatch, function_mismatch)
  Segment 16: surface=#viio7/vi, canonical=#VIIdim7/VI, analyzer=bVIdim7 (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=vi, canonical=VIm, analyzer=VIm (roman_surface_mismatch, function_mismatch)
  Segment 18: surface=ii6, canonical=IIm, analyzer=IIm (roman_surface_mismatch)
  Segment 19: surface=Cad64, canonical=I, analyzer=I (roman_surface_mismatch)
- `curated-mozart_k279_3-mm14-25` K279-3 (mm 14-25)
  Source id: `mozart_k279_3`
  Progression: `D7/A | D7 | Em Bm/D | Am/C A7/C# | D D7/C G/B | D/A G D7/F# G | D D7/C G/B | D/A G D7/F# G | D | Em C#dim/E D | Bm/D`
  Issues: expected key G, got D; segment[0] expected V7, got V7/IV; segment[1] expected V7, got V7/IV; segment[2] expected VIm, got IIm; segment[3] expected IIIm, got VIm; segment[4] expected IIm, got II/IVm; segment[5] expected V7/V, got V7; segment[6] expected V, got I; segment[7] expected V7, got V7/IV; segment[8] expected I, got IV; segment[9] expected V, got I; segment[10] expected I, got IV; segment[11] expected V7, got V7/IV; segment[12] expected I, got IV; segment[13] expected V, got I; segment[14] expected V7, got V7/IV; segment[15] expected I, got IV; segment[16] expected V, got I; segment[17] expected I, got IV; segment[18] expected V7, got V7/IV; segment[19] expected I, got IV; segment[20] expected V, got I; segment[21] expected VIm, got IIm; segment[22] expected VIIdim/V, got VIIdim; segment[23] expected V, got I; segment[24] expected IIIm, got VIm
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center, secondary_dominant_notation_gap
  Key diagnostics: top-2 D major 351.49 vs G major 345.92; gap 5.57; ending dominant 0/4; dominant overhang -0.28; applied dominants 6; tonicization remarks 3; real modulation remarks 2; expected-rank 2; selected key is dominant-of-expected
  Segment 0: surface=V43, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 1: surface=V7, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 2: surface=vi, canonical=VIm, analyzer=IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 3: surface=iii6, canonical=IIIm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 4: surface=ii6, canonical=IIm, analyzer=II/IVm (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 5: surface=V65/V, canonical=V7/V, analyzer=V7 (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 6: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 7: surface=V2, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 8: surface=I6, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 9: surface=V64, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 10: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 11: surface=V65, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 12: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 13: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 14: surface=V2, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 15: surface=I6, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 16: surface=V64, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 17: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 18: surface=V65, canonical=V7, analyzer=V7/IV (roman_surface_mismatch, roman_canonical_mismatch)
  Segment 19: surface=I, canonical=I, analyzer=IV (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 20: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 21: surface=vi, canonical=VIm, analyzer=IIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 22: surface=viio6/V, canonical=VIIdim/V, analyzer=VIIdim (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 23: surface=V, canonical=V, analyzer=I (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
  Segment 24: surface=iii6, canonical=IIIm, analyzer=VIm (roman_surface_mismatch, roman_canonical_mismatch, roman_relaxed_mismatch, function_mismatch)
- `curated-isophonics-isophonics_109` Taxman (Revolver)
  Source id: `beatles_taxman`
  Progression: `N.C. D7 D7#9 D7 D7#9 D7 C G7 D7 D7#9 D7 D7#9 D7 C G7 D7 C9 D7 C9 D7 C G7 D7 D7#9 D7 D7#9 D7 C G7 D7 D7 D7#9 D7 D7#9 D7 C G7 D7 F7 D7 D7#9 D7 N.C.`
  Issues: expected key D, got G
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G major 541.68 vs E minor 531.68; gap 10.00; ending dominant 4/4; dominant overhang 0.12; applied dominants 5; tonicization remarks 0; real modulation remarks 0
  No-chord events: expected 2, got 2
- `curated-jaah-jaah_12` Doggin' Around
  Source id: `jazz_doggin_around`
  Progression: `N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb Bb F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb Bb7 Bb7 Eb Eb C7 C7 F7 F7 Bb Bb Eb7 Eb7 C7 F7 Bb Bb N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Eb7 Eb7 C7 F7 Bb Bb N.C.`
  Issues: expected key Bb, got A#/Bb
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 2457.98 vs F major 2279.46; gap 178.52; ending dominant 2/4; dominant overhang -0.04; applied dominants 36; tonicization remarks 10; real modulation remarks 0
  No-chord events: expected 17, got 17
- `curated-jaah-jaah_13` Weather Bird
  Source id: `jazz_weather_bird`
  Progression: `Db Dbm Ab6 F7 Bb7 Eb7 Ab Ab Db6 Ddim7 Ab Ab Eb7 Edim7 Fm7 Fm7 Fm7 F7 G7 Cm Eb7 Ab Db6 Ddim7 Ab F7 Bbm7 Ddim7 Ab F7 Bb7 Eb7 Ab Eb7 Eb7 Ab6 Eb7 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Edim7 Fm7 Ab7 Db Dbm Ab6 F7 Bb7 Eb7 Ab Eb7 Eb7 Ab6 Eb7 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Eb7 Ab6 Ab6 Eb7 Edim7 Fm7 Ab7 Db Dbm Ab6 F7 Bb7 Eb7 Ab Ab Db6 Ddim7 Ab Ab Eb7 Edim7 Fm G7 Cm Eb7 Ab Db6 Ddim7 Ab F7 Bbm7 Ddim7 Ab F7 Bb7 Eb7 Ab Ab Abaug Ab6 Ab6 Dbdim7 Eb7 Eb7 Ab Ab Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab Ab Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab Eb7 Eb7 Ab Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. Ab Ab7 Db Ddim7 Abmaj7 F7 Bb7 Eb7 Ab Ab N.C. N.C. N.C. N.C. N.C. N.C. Abdim7 Abdim7 Abdim7 N.C. N.C. Db Ddim7 Ab N.C. Ab N.C. Ab7 Dbm7 Dbm6 Dbm6 N.C. N.C. N.C. N.C. Ab Ab Ab N.C.`
  Issues: expected key Ab, got G#/Ab
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 G#/Ab major 2312.06 vs D#/Eb major 2208.14; gap 103.92; ending dominant 0/4; dominant overhang -0.37; applied dominants 30; tonicization remarks 9; real modulation remarks 0
  No-chord events: expected 31, got 31
- `curated-jaah-jaah_2` Grandpa's Spells
  Source id: `jazz_grandpas_spells`
  Progression: `N.C. N.C. G7 Bbdim7 G7 C C D7 D7 G7 G7 C Ebdim7 G7 C C D7 D7 G7 G7 C G7 C C N.C. N.C. N.C. N.C. D7 N.C. N.C. N.C. N.C. G7 G7 C Ebdim7 G7 C N.C. N.C. N.C. N.C. D7 N.C. N.C. N.C. N.C. G7 G7 C G7 C D7 G7 C Ebdim7 G7 G7 C C D7 G7 C A7 Dm7 E7 Am D7 G7 C D7 D7 C Ebdim7 G7 G7 C N.C. N.C. N.C. N.C. D7 G7 C A7 Dm7 E7 Am D7 G7 C C C D7 D7 G7 G7 C Ebdim7 G7 C C D7 D7 G7 G7 C G7 C F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F N.C. F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F Cdim7 C7 F Cdim7 C7 F7 Bb G7 C7 F F C7 F N.C.`
  Issues: expected key C, got F
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 F major 2105.86 vs C major 2052.88; gap 52.98; ending dominant 1/4; dominant overhang -0.52; applied dominants 66; tonicization remarks 26; real modulation remarks 23; expected-rank 2
  No-chord events: expected 24, got 24
- `curated-jaah-jaah_31` Blue 7
  Source id: `jazz_blue_7`
  Progression: `Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 N.C. Bb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. F7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. Eb7 Eb7 Bb7 Bb7 N.C. N.C. N.C. N.C. Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Bb7 F7 Eb7 Bb7 Bb7`
  Issues: expected key Bb, got G#/Ab
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G#/Ab major 3874.90 vs G#/Ab minor 3874.90; gap 0.00; ending dominant 4/4; dominant overhang 0.00; applied dominants 189; tonicization remarks 0; real modulation remarks 0
  No-chord events: expected 93, got 93
- `curated-jaah-jaah_34` Cotton Tail
  Source id: `jazz_cotton_tail`
  Progression: `Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb Bb Bb Bb Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 F7 Bb6 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 Cm7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F Gm7 F7 Bb6 D7 D7 G7 G7 C7 C7 F7 F7 Bb6 G7 Cm7 F7 Dm7 Gm7 Cm7 F7 Bb7 Bb6/D Eb6 Edim7 Bb6/F F7 Bb N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Bb Bb Bb Bb Bb Bb Bb N.C.`
  Issues: expected key Bb, got A#/Bb
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 A#/Bb major 5954.89 vs D#/Eb major 5312.90; gap 641.99; ending dominant 0/4; dominant overhang -0.42; applied dominants 94; tonicization remarks 30; real modulation remarks 32
  No-chord events: expected 10, got 10
- `curated-jaah-jaah_6` For Dancers Only
  Source id: `jazz_for_dancers_only`
  Progression: `Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Eb Eb7 Ab Adim7 Eb Cm7 F7 Bb7 Eb Eb7 Ab Adim7 Eb Cm7 Fm7 Bb7 Eb Eb Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab Ab Ab7 Db Ddim7 Ab Fm7 Bb7 Eb7 Ab Ab7 Db Ddim7 Ab Fm7 Bbm7 Eb7 Ab Ab N.C.`
  Issues: expected key Eb, got G#/Ab
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 G#/Ab major 2947.36 vs D#/Eb major 2821.75; gap 125.61; ending dominant 1/4; dominant overhang -0.20; applied dominants 38; tonicization remarks 13; real modulation remarks 24
  No-chord events: expected 1, got 1
- `curated-jaah-jaah_92` Blues in the Closet
  Source id: `jazz_blues_in_the_closet`
  Progression: `Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Eb7 Bb7 Bb7 Eb7 Eb7 Bb7 Dm7 G7 Cm7 F7 Bb7 F7 Bb7 Bb7 Bb7 N.C.`
  Issues: expected key Bb, got D#/Eb
  Key verdict: strict=mismatch, relaxed=mismatch
  Failure taxonomy: ambiguous_key_center
  Key diagnostics: top-2 D#/Eb major 7027.30 vs G#/Ab major 6881.70; gap 145.60; ending dominant 4/4; dominant overhang 0.08; applied dominants 258; tonicization remarks 43; real modulation remarks 0
  No-chord events: expected 1, got 1
- `curated-jaah-jaah_98` Four Brothers
  Source id: `jazz_four_brothers`
  Progression: `Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab6 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Abmaj7 F7 C#m7 F#7 Bmaj7 Em7 A7 Dmaj7 Dm7 G7 Cmaj7 C#dim7 Dm7 G7 Cm7 F7 Bb7 Bbm7 Eb7 Abmaj7 F7 Bbm7 Cm7 F7 Bbm7 Eb7 Ab N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. N.C. Ab6 Ab6 Ab6 Ab6 Ab6 N.C. N.C.`
  Issues: expected key Ab, got G#/Ab
  Key verdict: strict=mismatch, relaxed=match
  Failure taxonomy: enharmonic_equivalence
  Key diagnostics: top-2 G#/Ab major 3003.22 vs D#/Eb major 2544.64; gap 458.58; ending dominant 0/4; dominant overhang -0.42; applied dominants 70; tonicization remarks 30; real modulation remarks 30
  No-chord events: expected 14, got 14

## Likely Root Causes

- `ambiguous_key_center` (16): Multiple key centers remain plausible after scoring, so the winner is sensitive to small cadence and weighting changes.
- `secondary_dominant_notation_gap` (14): Applied-dominant function is present, but the displayed Roman token diverges from the annotation style expected by the benchmark.
- `enharmonic_equivalence` (6): Pitch-class-equivalent spellings are diverging at the notation layer even when the harmonic intent is close.
- `modulation_vs_tonicization` (1): The analyzer is detecting local key motion, but its global summary boundary between tonicization and true modulation is still too soft.
- `ending_bias` (1): Late cadential material appears to outweigh earlier home-key evidence in the primary key summary.

## Recommended Next Fixes

- Separate local-cadence evidence from progression-level home-key scoring and expose both in the report.
- Increase report emphasis on alternative key candidates and compare top-2 score gaps in failures.
- Reduce final-cadence overweight or add earlier tonic-anchor persistence to the global-key scorer.
- Normalize applied-dominant Roman display variants before exact comparison, while still preserving strict metrics separately.
- Add enharmonic-tolerant key and Roman comparison hooks before counting notation-only misses as failures.

## Performance

### mixed-corpus

- Analyses: 51200
- Chords processed: 1590800
- Throughput: 338.6 analyses/s, 10520.4 chords/s
- Latency: mean 2.952 ms, p50 0.414 ms, p95 18.860 ms, p99 44.596 ms
- Range: 0.098 ms to 74.508 ms

### long-sequence

- Analyses: 180
- Chords processed: 92520
- Throughput: 18.3 analyses/s, 9429.9 chords/s
- Latency: mean 54.503 ms, p50 54.100 ms, p95 61.054 ms, p99 63.024 ms
- Range: 47.519 ms to 63.817 ms
- Input size: 515 chords
- Input length: 2758 characters
