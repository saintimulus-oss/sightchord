import 'dart:convert';
import 'dart:io';

import 'benchmark/adapters/abc_external_gold_adapter.dart';
import 'benchmark/adapters/isophonics_choco_external_gold_adapter.dart';
import 'benchmark/adapters/jaah_choco_external_gold_adapter.dart';
import 'benchmark/adapters/when_in_rome_external_gold_adapter.dart';
import 'benchmark/chord_analyzer_external_gold_schema.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

const String _defaultOutputDir = 'output/chord_analyzer_benchmark';
const int _defaultRounds = 400;
const int _defaultWarmupRounds = 40;
const int _defaultLongRuns = 180;
const int _defaultLongChordTarget = 512;
const String _defaultAbcExternalGoldFixtureDir =
    'tool/benchmark_fixtures/external_gold/abc';
const String _defaultAbcExternalGoldSelectionManifestPath =
    'tool/benchmark_fixtures/external_gold/abc/selection_manifest.tsv';
const String _defaultAbcExternalGoldSourceRoot = '.codex_tmp/ABC';
const String _defaultWhenInRomeExternalGoldFixtureDir =
    'tool/benchmark_fixtures/external_gold/when_in_rome';
const String _defaultWhenInRomeExternalGoldSelectionManifestPath =
    'tool/benchmark_fixtures/external_gold/when_in_rome/selection_manifest.tsv';
const String _defaultWhenInRomeExternalGoldSourceRoot =
    '.codex_tmp/When-in-Rome';
const String _defaultIsophonicsChocoExternalGoldFixtureDir =
    'tool/benchmark_fixtures/external_gold/isophonics_choco';
const String _defaultJaahChocoExternalGoldFixtureDir =
    'tool/benchmark_fixtures/external_gold/jaah_choco';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('runs the chord analyzer benchmark', () {
    final parsed = _Args.parseEnvironment(Platform.environment);
    final analyzer = ProgressionAnalyzer();
    final outputDirectory = Directory(parsed.outputDir)
      ..createSync(recursive: true);
    final benchmarkCases = _buildBenchmarkCases();
    final curatedGoldLoad = _loadCuratedGoldCases(
      manifestPath: parsed.curatedGoldManifestPath,
      outputDir: outputDirectory.path,
      abcSourceRootPath: parsed.abcSourceRootPath,
      whenInRomeSourceRootPath: parsed.whenInRomeSourceRootPath,
    );
    benchmarkCases.addAll(curatedGoldLoad.cases);

    stdout.writeln(
      'Chord Analyzer benchmark: ${benchmarkCases.length} total benchmark cases',
    );

    final accuracyResults = [
      for (final benchmarkCase in benchmarkCases)
        _evaluateCase(analyzer, benchmarkCase),
    ];
    final proxyResults = [
      for (final result in accuracyResults)
        if (result.benchmarkCase.benchmarkClass != _BenchmarkClass.curatedGold)
          result,
    ];
    final externalGoldResults = [
      for (final result in accuracyResults)
        if (result.benchmarkCase.benchmarkClass == _BenchmarkClass.curatedGold)
          result,
    ];
    final mixedCorpusPerformance = _measureMixedCorpusPerformance(
      analyzer: analyzer,
      benchmarkCases: benchmarkCases,
      rounds: parsed.rounds,
      warmupRounds: parsed.warmupRounds,
    );
    final longSequence = _buildLongSequenceInput(
      benchmarkCases: benchmarkCases,
      chordTarget: parsed.longChordTarget,
    );
    final longSequencePerformance = _measureLongSequencePerformance(
      analyzer: analyzer,
      input: longSequence,
      runs: parsed.longRuns,
      warmupRounds: parsed.warmupRounds,
    );

    final report = _BenchmarkReport(
      generatedAtUtc: DateTime.now().toUtc(),
      workbookSourcePath: parsed.sourceWorkbookPath,
      benchmarkCaseCount: benchmarkCases.length,
      workbookTracks: _workbookTracks,
      overall: _aggregateResults(accuracyResults),
      proxyOverall: _aggregateResults(proxyResults),
      externalGoldOverall: _aggregateResults(externalGoldResults),
      byClass: _aggregateBy(
        accuracyResults,
        (result) => result.benchmarkCase.benchmarkClass.label,
      ),
      byTrack: _aggregateBy(
        accuracyResults,
        (result) => result.benchmarkCase.track.label,
      ),
      byGenre: _aggregateBy(
        accuracyResults,
        (result) => result.benchmarkCase.genre.label,
      ),
      byDifficulty: _aggregateBy(
        accuracyResults,
        (result) => result.benchmarkCase.difficulty.label,
      ),
      externalGoldByCorpus: _aggregateBy(
        externalGoldResults,
        (result) => result.benchmarkCase.corpusId ?? 'unknown_corpus',
      ),
      externalGoldBySourceId: _aggregateBy(
        externalGoldResults,
        (result) => result.benchmarkCase.sourceId,
      ),
      externalGoldByAnnotationLevel: _aggregateBy(
        externalGoldResults,
        (result) =>
            result.benchmarkCase.annotationLevel ?? 'unknown_annotation_level',
      ),
      externalGoldByKeyScope: _aggregateBy(
        externalGoldResults,
        (result) => result.benchmarkCase.keyScope ?? 'unknown',
      ),
      externalGoldBySegmentationScope: _aggregateBy(
        externalGoldResults,
        (result) => result.benchmarkCase.segmentationScope ?? 'unknown',
      ),
      failures: accuracyResults.where((result) => !result.exactPass).toList(),
      externalGoldFailures: externalGoldResults
          .where((result) => !result.exactPass)
          .toList(),
      curatedGoldLoad: curatedGoldLoad.status,
      mixedCorpusPerformance: mixedCorpusPerformance,
      longSequencePerformance: longSequencePerformance,
    );
    final jsonFile = File(
      '${outputDirectory.path}${Platform.pathSeparator}benchmark_report.json',
    );
    final markdownFile = File(
      '${outputDirectory.path}${Platform.pathSeparator}benchmark_report.md',
    );
    jsonFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(report.toJson())}\n',
    );
    markdownFile.writeAsStringSync('${report.toMarkdown()}\n');

    stdout.writeln('');
    stdout.writeln(
      'Exact progression pass rate: '
      '${_formatPercent(report.overall.exactProgressionPassRate)} '
      '(${report.overall.exactProgressionPasses}/${report.overall.caseCount})',
    );
    stdout.writeln(
      'Key accuracy: ${_formatPercent(report.overall.keyAccuracy)}  '
      'Roman token accuracy: ${_formatPercent(report.overall.romanTokenAccuracy)}',
    );
    stdout.writeln(
      'Mixed corpus throughput: '
      '${report.mixedCorpusPerformance.analysesPerSecond.toStringAsFixed(1)} '
      'analyses/s, p95 '
      '${report.mixedCorpusPerformance.p95Milliseconds.toStringAsFixed(3)} ms',
    );
    stdout.writeln(
      'Long sequence latency: '
      '${report.longSequencePerformance.meanMilliseconds.toStringAsFixed(3)} ms '
      'mean for ${longSequence.chordCount} chords',
    );
    stdout.writeln('');
    stdout.writeln('JSON report: ${jsonFile.path}');
    stdout.writeln('Markdown report: ${markdownFile.path}');

    expect(report.overall.caseCount, benchmarkCases.length);
  });
}

enum _BenchmarkTrack { goldCore, ambiguityValidation }

enum _BenchmarkGenre { jazz, pop, classical, mixed }

enum _DifficultyBucket { easy, medium, hard, ambiguous }

enum _BenchmarkClass { workbookProxy, dirtyInput, curatedGold }

enum _FailureTaxonomy {
  modulationVsTonicization,
  ambiguousKeyCenter,
  endingBias,
  borrowedChordConfusion,
  modalMixtureConfusion,
  slashChordInterpretation,
  enharmonicEquivalence,
  secondaryDominantNotationGap,
}

extension on _BenchmarkTrack {
  String get label {
    return switch (this) {
      _BenchmarkTrack.goldCore => 'S-tier Gold core',
      _BenchmarkTrack.ambiguityValidation => 'Ambiguity validation',
    };
  }
}

extension on _BenchmarkGenre {
  String get label {
    return switch (this) {
      _BenchmarkGenre.jazz => 'jazz',
      _BenchmarkGenre.pop => 'pop',
      _BenchmarkGenre.classical => 'classical',
      _BenchmarkGenre.mixed => 'mixed',
    };
  }
}

extension on _DifficultyBucket {
  String get label {
    return switch (this) {
      _DifficultyBucket.easy => 'Easy',
      _DifficultyBucket.medium => 'Medium',
      _DifficultyBucket.hard => 'Hard',
      _DifficultyBucket.ambiguous => 'Ambiguous',
    };
  }
}

extension on _BenchmarkClass {
  String get label {
    return switch (this) {
      _BenchmarkClass.workbookProxy => 'Workbook proxy',
      _BenchmarkClass.dirtyInput => 'Dirty input',
      _BenchmarkClass.curatedGold => 'Curated gold',
    };
  }
}

extension on _FailureTaxonomy {
  String get label {
    return switch (this) {
      _FailureTaxonomy.modulationVsTonicization => 'modulation_vs_tonicization',
      _FailureTaxonomy.ambiguousKeyCenter => 'ambiguous_key_center',
      _FailureTaxonomy.endingBias => 'ending_bias',
      _FailureTaxonomy.borrowedChordConfusion => 'borrowed_chord_confusion',
      _FailureTaxonomy.modalMixtureConfusion => 'modal_mixture_confusion',
      _FailureTaxonomy.slashChordInterpretation => 'slash_chord_interpretation',
      _FailureTaxonomy.enharmonicEquivalence => 'enharmonic_equivalence',
      _FailureTaxonomy.secondaryDominantNotationGap =>
        'secondary_dominant_notation_gap',
    };
  }

  String get rootCause {
    return switch (this) {
      _FailureTaxonomy.modulationVsTonicization =>
        'The analyzer is detecting local key motion, but its global summary boundary between tonicization and true modulation is still too soft.',
      _FailureTaxonomy.ambiguousKeyCenter =>
        'Multiple key centers remain plausible after scoring, so the winner is sensitive to small cadence and weighting changes.',
      _FailureTaxonomy.endingBias =>
        'Late cadential material appears to outweigh earlier home-key evidence in the primary key summary.',
      _FailureTaxonomy.borrowedChordConfusion =>
        'Borrowed-color or backdoor material is competing with the home key instead of being summarized as a local color event.',
      _FailureTaxonomy.modalMixtureConfusion =>
        'Modal mixture is detected locally, but the progression-level reading overcommits to an alternate mode or key.',
      _FailureTaxonomy.slashChordInterpretation =>
        'Bass-note detail is either underweighted or overinterpreted when selecting the harmonic reading.',
      _FailureTaxonomy.enharmonicEquivalence =>
        'Pitch-class-equivalent spellings are diverging at the notation layer even when the harmonic intent is close.',
      _FailureTaxonomy.secondaryDominantNotationGap =>
        'Applied-dominant function is present, but the displayed Roman token diverges from the annotation style expected by the benchmark.',
    };
  }

  String get recommendedFix {
    return switch (this) {
      _FailureTaxonomy.modulationVsTonicization =>
        'Separate local-cadence evidence from progression-level home-key scoring and expose both in the report.',
      _FailureTaxonomy.ambiguousKeyCenter =>
        'Increase report emphasis on alternative key candidates and compare top-2 score gaps in failures.',
      _FailureTaxonomy.endingBias =>
        'Reduce final-cadence overweight or add earlier tonic-anchor persistence to the global-key scorer.',
      _FailureTaxonomy.borrowedChordConfusion =>
        'Improve borrowed-color handling so it contributes less to home-key replacement and more to local remarks.',
      _FailureTaxonomy.modalMixtureConfusion =>
        'Add mixture-aware relaxed comparison and richer reporting for mode-mixture events.',
      _FailureTaxonomy.slashChordInterpretation =>
        'Distinguish inversion evidence from true harmonic reclassification in relaxed comparison and scoring.',
      _FailureTaxonomy.enharmonicEquivalence =>
        'Add enharmonic-tolerant key and Roman comparison hooks before counting notation-only misses as failures.',
      _FailureTaxonomy.secondaryDominantNotationGap =>
        'Normalize applied-dominant Roman display variants before exact comparison, while still preserving strict metrics separately.',
    };
  }
}

class _ComparisonProfile {
  const _ComparisonProfile({
    this.allowEnharmonicKeyMatch = false,
    this.allowSlashBassTolerance = false,
    this.allowRomanFunctionRelaxation = true,
  });

  final bool allowEnharmonicKeyMatch;
  final bool allowSlashBassTolerance;
  final bool allowRomanFunctionRelaxation;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'allowEnharmonicKeyMatch': allowEnharmonicKeyMatch,
      'allowSlashBassTolerance': allowSlashBassTolerance,
      'allowRomanFunctionRelaxation': allowRomanFunctionRelaxation,
    };
  }
}

class _SegmentExpectation {
  const _SegmentExpectation({
    required this.index,
    int? analysisIndex,
    this.expectedSurfaceRoman,
    this.expectedCanonicalRoman,
    this.expectedFunction,
    this.expectedResolvedSymbol,
    this.note,
    this.comparisonProfile = const _ComparisonProfile(),
  }) : analysisIndex = analysisIndex ?? index;

  final int index;
  final int analysisIndex;
  final String? expectedSurfaceRoman;
  final String? expectedCanonicalRoman;
  final String? expectedFunction;
  final String? expectedResolvedSymbol;
  final String? note;
  final _ComparisonProfile comparisonProfile;

  String? get expectedRoman => expectedCanonicalRoman;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'index': index,
      'analysisIndex': analysisIndex,
      'expectedSurfaceRoman': expectedSurfaceRoman,
      'expectedCanonicalRoman': expectedCanonicalRoman,
      'expectedRoman': expectedCanonicalRoman,
      'expectedFunction': expectedFunction,
      'expectedResolvedSymbol': expectedResolvedSymbol,
      'note': note,
      'comparisonProfile': comparisonProfile.toJson(),
    };
  }
}

class _SegmentComparison {
  const _SegmentComparison({
    required this.index,
    required this.analysisIndex,
    required this.expectedSurfaceRoman,
    required this.expectedCanonicalRoman,
    required this.actualRoman,
    required this.expectedFunction,
    required this.actualFunction,
    required this.expectedResolvedSymbol,
    required this.actualResolvedSymbol,
    required this.surfaceRomanExactMatch,
    required this.canonicalRomanExactMatch,
    required this.relaxedRomanMatch,
    required this.functionMatch,
    required this.resolvedSymbolMatch,
    required this.mismatchReasons,
  });

  final int index;
  final int analysisIndex;
  final String? expectedSurfaceRoman;
  final String? expectedCanonicalRoman;
  final String? actualRoman;
  final String? expectedFunction;
  final String? actualFunction;
  final String? expectedResolvedSymbol;
  final String? actualResolvedSymbol;
  final bool surfaceRomanExactMatch;
  final bool canonicalRomanExactMatch;
  final bool relaxedRomanMatch;
  final bool functionMatch;
  final bool resolvedSymbolMatch;
  final List<String> mismatchReasons;

  String? get expectedRoman => expectedCanonicalRoman;

  bool get exactRomanMatch => canonicalRomanExactMatch;

  bool get hasMismatch => mismatchReasons.isNotEmpty;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'index': index,
      'analysisIndex': analysisIndex,
      'expectedSurfaceRoman': expectedSurfaceRoman,
      'expectedCanonicalRoman': expectedCanonicalRoman,
      'expectedRoman': expectedCanonicalRoman,
      'actualRoman': actualRoman,
      'expectedFunction': expectedFunction,
      'actualFunction': actualFunction,
      'expectedResolvedSymbol': expectedResolvedSymbol,
      'actualResolvedSymbol': actualResolvedSymbol,
      'surfaceRomanExactMatch': surfaceRomanExactMatch,
      'canonicalRomanExactMatch': canonicalRomanExactMatch,
      'exactRomanMatch': canonicalRomanExactMatch,
      'relaxedRomanMatch': relaxedRomanMatch,
      'functionMatch': functionMatch,
      'resolvedSymbolMatch': resolvedSymbolMatch,
      'mismatchReasons': mismatchReasons,
    };
  }
}

class _ModulationDiagnostics {
  const _ModulationDiagnostics({
    required this.evaluated,
    required this.expectedTags,
    required this.actualTags,
    required this.primaryKey,
    required this.alternativeKey,
    required this.confidence,
    required this.ambiguity,
    required this.matched,
  });

  final bool evaluated;
  final List<String> expectedTags;
  final List<String> actualTags;
  final String primaryKey;
  final String? alternativeKey;
  final double confidence;
  final double ambiguity;
  final bool matched;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'evaluated': evaluated,
      'expectedTags': expectedTags,
      'actualTags': actualTags,
      'primaryKey': primaryKey,
      'alternativeKey': alternativeKey,
      'confidence': confidence,
      'ambiguity': ambiguity,
      'matched': matched,
    };
  }
}

class _KeyCandidateDiagnostic {
  const _KeyCandidateDiagnostic({
    required this.key,
    required this.mode,
    required this.score,
    required this.confidence,
  });

  final String key;
  final String mode;
  final double score;
  final double confidence;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'key': key,
      'mode': mode,
      'score': score,
      'confidence': confidence,
    };
  }
}

class _KeyDiagnostics {
  const _KeyDiagnostics({
    required this.topCandidates,
    required this.topTwoScoreGap,
    required this.expectedKeyRank,
    required this.expectedKeyGapFromTop,
    required this.selectedKeyIsDominantOfExpected,
    required this.overallDominantRatio,
    required this.endingDominantRatio,
    required this.dominantBiasOverhang,
    required this.endingDominantCount,
    required this.endingPredominantCount,
    required this.endingTonicCount,
    required this.endingCadentialResolutions,
    required this.endingWindowSize,
    required this.appliedDominantChordCount,
    required this.appliedDominantRemarkCount,
    required this.tonicizationRemarkCount,
    required this.realModulationRemarkCount,
    required this.summary,
  });

  final List<_KeyCandidateDiagnostic> topCandidates;
  final double? topTwoScoreGap;
  final int? expectedKeyRank;
  final double? expectedKeyGapFromTop;
  final bool selectedKeyIsDominantOfExpected;
  final double overallDominantRatio;
  final double endingDominantRatio;
  final double dominantBiasOverhang;
  final int endingDominantCount;
  final int endingPredominantCount;
  final int endingTonicCount;
  final int endingCadentialResolutions;
  final int endingWindowSize;
  final int appliedDominantChordCount;
  final int appliedDominantRemarkCount;
  final int tonicizationRemarkCount;
  final int realModulationRemarkCount;
  final String summary;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'topCandidates': [
        for (final candidate in topCandidates) candidate.toJson(),
      ],
      'topTwoScoreGap': topTwoScoreGap,
      'expectedKeyRank': expectedKeyRank,
      'expectedKeyGapFromTop': expectedKeyGapFromTop,
      'selectedKeyIsDominantOfExpected': selectedKeyIsDominantOfExpected,
      'overallDominantRatio': overallDominantRatio,
      'endingDominantRatio': endingDominantRatio,
      'dominantBiasOverhang': dominantBiasOverhang,
      'endingDominantCount': endingDominantCount,
      'endingPredominantCount': endingPredominantCount,
      'endingTonicCount': endingTonicCount,
      'endingCadentialResolutions': endingCadentialResolutions,
      'endingWindowSize': endingWindowSize,
      'appliedDominantChordCount': appliedDominantChordCount,
      'appliedDominantRemarkCount': appliedDominantRemarkCount,
      'tonicizationRemarkCount': tonicizationRemarkCount,
      'realModulationRemarkCount': realModulationRemarkCount,
      'summary': summary,
    };
  }
}

class _CoverageBreakdown {
  const _CoverageBreakdown({
    required this.rawRecordCount,
    required this.loadedRecordCount,
    required this.skippedRecordCount,
    required this.rawSegmentCount,
    required this.keptSegmentCount,
    required this.skippedSegmentCount,
    required this.rawHarmonicSegmentCount,
    required this.keptHarmonicSegmentCount,
    required this.rawNonHarmonicSegmentCount,
    required this.keptNonHarmonicSegmentCount,
  });

  final int rawRecordCount;
  final int loadedRecordCount;
  final int skippedRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final int skippedSegmentCount;
  final int rawHarmonicSegmentCount;
  final int keptHarmonicSegmentCount;
  final int rawNonHarmonicSegmentCount;
  final int keptNonHarmonicSegmentCount;

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedRecordCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  double? get harmonicCoverageRatio => rawHarmonicSegmentCount == 0
      ? null
      : keptHarmonicSegmentCount / rawHarmonicSegmentCount;

  double? get nonHarmonicRetentionRatio => rawNonHarmonicSegmentCount == 0
      ? null
      : keptNonHarmonicSegmentCount / rawNonHarmonicSegmentCount;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'rawRecordCount': rawRecordCount,
      'loadedRecordCount': loadedRecordCount,
      'skippedRecordCount': skippedRecordCount,
      'rawSegmentCount': rawSegmentCount,
      'keptSegmentCount': keptSegmentCount,
      'skippedSegmentCount': skippedSegmentCount,
      'rawHarmonicSegmentCount': rawHarmonicSegmentCount,
      'keptHarmonicSegmentCount': keptHarmonicSegmentCount,
      'rawNonHarmonicSegmentCount': rawNonHarmonicSegmentCount,
      'keptNonHarmonicSegmentCount': keptNonHarmonicSegmentCount,
      'recordCoverageRatio': recordCoverageRatio,
      'segmentCoverageRatio': segmentCoverageRatio,
      'harmonicCoverageRatio': harmonicCoverageRatio,
      'nonHarmonicRetentionRatio': nonHarmonicRetentionRatio,
    };
  }
}

class _CuratedGoldCorpusLoad {
  const _CuratedGoldCorpusLoad({
    required this.corpusId,
    required this.corpusName,
    required this.loadedCaseCount,
    required this.manifestPath,
    this.licenseNote,
    this.adapterId,
    this.fixtureDirectory,
    this.selectionManifestPath,
    this.sourceCorpusRootPath,
    this.importMode,
    this.skippedRecordCount = 0,
    this.skippedSegmentCount = 0,
    this.rawRecordCount = 0,
    this.rawSegmentCount = 0,
    this.keptSegmentCount = 0,
    this.rawHarmonicSegmentCount = 0,
    this.keptHarmonicSegmentCount = 0,
    this.rawNonHarmonicSegmentCount = 0,
    this.keptNonHarmonicSegmentCount = 0,
    this.skipReasonCounts = const <String, int>{},
    this.recordDropReasonCounts = const <String, int>{},
    this.coverageBySourceId = const <String, _CoverageBreakdown>{},
  });

  final String corpusId;
  final String corpusName;
  final int loadedCaseCount;
  final String? manifestPath;
  final String? licenseNote;
  final String? adapterId;
  final String? fixtureDirectory;
  final String? selectionManifestPath;
  final String? sourceCorpusRootPath;
  final String? importMode;
  final int skippedRecordCount;
  final int skippedSegmentCount;
  final int rawRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final int rawHarmonicSegmentCount;
  final int keptHarmonicSegmentCount;
  final int rawNonHarmonicSegmentCount;
  final int keptNonHarmonicSegmentCount;
  final Map<String, int> skipReasonCounts;
  final Map<String, int> recordDropReasonCounts;
  final Map<String, _CoverageBreakdown> coverageBySourceId;

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedCaseCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  double? get harmonicCoverageRatio => rawHarmonicSegmentCount == 0
      ? null
      : keptHarmonicSegmentCount / rawHarmonicSegmentCount;

  double? get nonHarmonicRetentionRatio => rawNonHarmonicSegmentCount == 0
      ? null
      : keptNonHarmonicSegmentCount / rawNonHarmonicSegmentCount;

  _CoverageBreakdown get coverageBreakdown => _CoverageBreakdown(
    rawRecordCount: rawRecordCount,
    loadedRecordCount: loadedCaseCount,
    skippedRecordCount: skippedRecordCount,
    rawSegmentCount: rawSegmentCount,
    keptSegmentCount: keptSegmentCount,
    skippedSegmentCount: skippedSegmentCount,
    rawHarmonicSegmentCount: rawHarmonicSegmentCount,
    keptHarmonicSegmentCount: keptHarmonicSegmentCount,
    rawNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
    keptNonHarmonicSegmentCount: keptNonHarmonicSegmentCount,
  );

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'corpusId': corpusId,
      'corpusName': corpusName,
      'manifestPath': manifestPath,
      'loadedCaseCount': loadedCaseCount,
      'licenseNote': licenseNote,
      'adapterId': adapterId,
      'fixtureDirectory': fixtureDirectory,
      'selectionManifestPath': selectionManifestPath,
      'sourceCorpusRootPath': sourceCorpusRootPath,
      'importMode': importMode,
      'skippedRecordCount': skippedRecordCount,
      'skippedSegmentCount': skippedSegmentCount,
      'rawRecordCount': rawRecordCount,
      'rawSegmentCount': rawSegmentCount,
      'keptSegmentCount': keptSegmentCount,
      'rawHarmonicSegmentCount': rawHarmonicSegmentCount,
      'keptHarmonicSegmentCount': keptHarmonicSegmentCount,
      'rawNonHarmonicSegmentCount': rawNonHarmonicSegmentCount,
      'keptNonHarmonicSegmentCount': keptNonHarmonicSegmentCount,
      'recordCoverageRatio': recordCoverageRatio,
      'segmentCoverageRatio': segmentCoverageRatio,
      'harmonicCoverageRatio': harmonicCoverageRatio,
      'nonHarmonicRetentionRatio': nonHarmonicRetentionRatio,
      'skipReasonCounts': skipReasonCounts,
      'recordDropReasonCounts': recordDropReasonCounts,
      'coverageBySourceId': {
        for (final entry in coverageBySourceId.entries)
          entry.key: entry.value.toJson(),
      },
    };
  }
}

class _CuratedGoldLoadResult {
  const _CuratedGoldLoadResult({
    required this.manifestPath,
    required this.loadedCaseCount,
    required this.status,
    this.corpusId,
    this.corpusName,
    this.licenseNote,
    this.adapterId,
    this.fixtureDirectory,
    this.selectionManifestPath,
    this.sourceCorpusRootPath,
    this.importMode,
    this.skippedRecordCount = 0,
    this.skippedSegmentCount = 0,
    this.rawRecordCount = 0,
    this.rawSegmentCount = 0,
    this.keptSegmentCount = 0,
    this.rawHarmonicSegmentCount = 0,
    this.keptHarmonicSegmentCount = 0,
    this.rawNonHarmonicSegmentCount = 0,
    this.keptNonHarmonicSegmentCount = 0,
    this.skipReasonCounts = const <String, int>{},
    this.recordDropReasonCounts = const <String, int>{},
    this.coverageBySourceId = const <String, _CoverageBreakdown>{},
    this.corpusLoads = const <_CuratedGoldCorpusLoad>[],
  });

  final String? manifestPath;
  final int loadedCaseCount;
  final String status;
  final String? corpusId;
  final String? corpusName;
  final String? licenseNote;
  final String? adapterId;
  final String? fixtureDirectory;
  final String? selectionManifestPath;
  final String? sourceCorpusRootPath;
  final String? importMode;
  final int skippedRecordCount;
  final int skippedSegmentCount;
  final int rawRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final int rawHarmonicSegmentCount;
  final int keptHarmonicSegmentCount;
  final int rawNonHarmonicSegmentCount;
  final int keptNonHarmonicSegmentCount;
  final Map<String, int> skipReasonCounts;
  final Map<String, int> recordDropReasonCounts;
  final Map<String, _CoverageBreakdown> coverageBySourceId;
  final List<_CuratedGoldCorpusLoad> corpusLoads;

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedCaseCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  double? get harmonicCoverageRatio => rawHarmonicSegmentCount == 0
      ? null
      : keptHarmonicSegmentCount / rawHarmonicSegmentCount;

  double? get nonHarmonicRetentionRatio => rawNonHarmonicSegmentCount == 0
      ? null
      : keptNonHarmonicSegmentCount / rawNonHarmonicSegmentCount;

  List<_CuratedGoldCorpusLoad> get effectiveCorpusLoads {
    if (corpusLoads.isNotEmpty) {
      return corpusLoads;
    }
    if ((corpusId ?? '').isEmpty || (corpusName ?? '').isEmpty) {
      return const <_CuratedGoldCorpusLoad>[];
    }
    return <_CuratedGoldCorpusLoad>[
      _CuratedGoldCorpusLoad(
        corpusId: corpusId!,
        corpusName: corpusName!,
        loadedCaseCount: loadedCaseCount,
        manifestPath: manifestPath,
        licenseNote: licenseNote,
        adapterId: adapterId,
        fixtureDirectory: fixtureDirectory,
        selectionManifestPath: selectionManifestPath,
        sourceCorpusRootPath: sourceCorpusRootPath,
        importMode: importMode,
        skippedRecordCount: skippedRecordCount,
        skippedSegmentCount: skippedSegmentCount,
        rawRecordCount: rawRecordCount,
        rawSegmentCount: rawSegmentCount,
        keptSegmentCount: keptSegmentCount,
        rawHarmonicSegmentCount: rawHarmonicSegmentCount,
        keptHarmonicSegmentCount: keptHarmonicSegmentCount,
        rawNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
        keptNonHarmonicSegmentCount: keptNonHarmonicSegmentCount,
        skipReasonCounts: skipReasonCounts,
        recordDropReasonCounts: recordDropReasonCounts,
        coverageBySourceId: coverageBySourceId,
      ),
    ];
  }

  List<String> get manifestPaths => [
    for (final load in effectiveCorpusLoads)
      if (load.manifestPath != null && load.manifestPath!.isNotEmpty)
        load.manifestPath!,
  ];

  Map<String, _CoverageBreakdown> get coverageByCorpus => {
    for (final load in effectiveCorpusLoads)
      load.corpusId: load.coverageBreakdown,
  };

  factory _CuratedGoldLoadResult.notLoaded({String? manifestPath}) {
    return _CuratedGoldLoadResult(
      manifestPath: manifestPath,
      loadedCaseCount: 0,
      status: 'not_loaded',
    );
  }

  factory _CuratedGoldLoadResult.combine(
    List<_CuratedGoldCorpusLoad> corpusLoads,
  ) {
    if (corpusLoads.isEmpty) {
      return _CuratedGoldLoadResult.notLoaded();
    }
    if (corpusLoads.length == 1) {
      final load = corpusLoads.single;
      return _CuratedGoldLoadResult(
        manifestPath: load.manifestPath,
        loadedCaseCount: load.loadedCaseCount,
        status: 'loaded',
        corpusId: load.corpusId,
        corpusName: load.corpusName,
        licenseNote: load.licenseNote,
        adapterId: load.adapterId,
        fixtureDirectory: load.fixtureDirectory,
        selectionManifestPath: load.selectionManifestPath,
        sourceCorpusRootPath: load.sourceCorpusRootPath,
        importMode: load.importMode,
        skippedRecordCount: load.skippedRecordCount,
        skippedSegmentCount: load.skippedSegmentCount,
        rawRecordCount: load.rawRecordCount,
        rawSegmentCount: load.rawSegmentCount,
        keptSegmentCount: load.keptSegmentCount,
        rawHarmonicSegmentCount: load.rawHarmonicSegmentCount,
        keptHarmonicSegmentCount: load.keptHarmonicSegmentCount,
        rawNonHarmonicSegmentCount: load.rawNonHarmonicSegmentCount,
        keptNonHarmonicSegmentCount: load.keptNonHarmonicSegmentCount,
        skipReasonCounts: load.skipReasonCounts,
        recordDropReasonCounts: load.recordDropReasonCounts,
        coverageBySourceId: load.coverageBySourceId,
        corpusLoads: corpusLoads,
      );
    }

    return _CuratedGoldLoadResult(
      manifestPath: null,
      loadedCaseCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.loadedCaseCount,
      ),
      status: 'loaded',
      corpusName: '${corpusLoads.length} corpora',
      rawRecordCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.rawRecordCount,
      ),
      skippedRecordCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.skippedRecordCount,
      ),
      rawSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.rawSegmentCount,
      ),
      keptSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.keptSegmentCount,
      ),
      rawHarmonicSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.rawHarmonicSegmentCount,
      ),
      keptHarmonicSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.keptHarmonicSegmentCount,
      ),
      rawNonHarmonicSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.rawNonHarmonicSegmentCount,
      ),
      keptNonHarmonicSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.keptNonHarmonicSegmentCount,
      ),
      skippedSegmentCount: corpusLoads.fold<int>(
        0,
        (sum, load) => sum + load.skippedSegmentCount,
      ),
      skipReasonCounts: _mergeReasonCounts(
        corpusLoads.map((load) => load.skipReasonCounts),
      ),
      recordDropReasonCounts: _mergeReasonCounts(
        corpusLoads.map((load) => load.recordDropReasonCounts),
      ),
      coverageBySourceId: _mergeCoverageBySourceId(corpusLoads),
      corpusLoads: corpusLoads,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'manifestPath': manifestPath,
      'manifestPaths': manifestPaths,
      'loadedCaseCount': loadedCaseCount,
      'status': status,
      'corpusId': corpusId,
      'corpusName': corpusName,
      'licenseNote': licenseNote,
      'adapterId': adapterId,
      'fixtureDirectory': fixtureDirectory,
      'selectionManifestPath': selectionManifestPath,
      'sourceCorpusRootPath': sourceCorpusRootPath,
      'importMode': importMode,
      'skippedRecordCount': skippedRecordCount,
      'skippedSegmentCount': skippedSegmentCount,
      'rawRecordCount': rawRecordCount,
      'rawSegmentCount': rawSegmentCount,
      'keptSegmentCount': keptSegmentCount,
      'rawHarmonicSegmentCount': rawHarmonicSegmentCount,
      'keptHarmonicSegmentCount': keptHarmonicSegmentCount,
      'rawNonHarmonicSegmentCount': rawNonHarmonicSegmentCount,
      'keptNonHarmonicSegmentCount': keptNonHarmonicSegmentCount,
      'recordCoverageRatio': recordCoverageRatio,
      'segmentCoverageRatio': segmentCoverageRatio,
      'harmonicCoverageRatio': harmonicCoverageRatio,
      'nonHarmonicRetentionRatio': nonHarmonicRetentionRatio,
      'skipReasonCounts': skipReasonCounts,
      'recordDropReasonCounts': recordDropReasonCounts,
      'coverageByCorpus': {
        for (final entry in coverageByCorpus.entries)
          entry.key: entry.value.toJson(),
      },
      'coverageBySourceId': {
        for (final entry in coverageBySourceId.entries)
          entry.key: entry.value.toJson(),
      },
      'corpusLoads': [for (final load in effectiveCorpusLoads) load.toJson()],
    };
  }
}

Map<String, int> _mergeReasonCounts(Iterable<Map<String, int>> maps) {
  final merged = <String, int>{};
  for (final counts in maps) {
    for (final entry in counts.entries) {
      merged.update(
        entry.key,
        (value) => value + entry.value,
        ifAbsent: () => entry.value,
      );
    }
  }
  return Map<String, int>.fromEntries(
    merged.entries.toList()..sort((left, right) {
      final byCount = right.value.compareTo(left.value);
      if (byCount != 0) {
        return byCount;
      }
      return left.key.compareTo(right.key);
    }),
  );
}

Map<String, _CoverageBreakdown> _mergeCoverageBySourceId(
  List<_CuratedGoldCorpusLoad> corpusLoads,
) {
  final merged = <String, _CoverageBreakdown>{};
  final seenKeys = <String, int>{};
  for (final load in corpusLoads) {
    for (final entry in load.coverageBySourceId.entries) {
      final count = seenKeys.update(
        entry.key,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final mergedKey = count == 1
          ? entry.key
          : '${load.corpusId}::${entry.key}';
      merged[mergedKey] = entry.value;
    }
  }
  return Map<String, _CoverageBreakdown>.fromEntries(
    merged.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key)),
  );
}

class _LoadedCuratedGoldCases {
  const _LoadedCuratedGoldCases({required this.cases, required this.status});

  final List<_BenchmarkCase> cases;
  final _CuratedGoldLoadResult status;
}

class _WorkbookTrack {
  const _WorkbookTrack({
    required this.sheetLabel,
    required this.goal,
    required this.recommendedSources,
    required this.note,
  });

  final String sheetLabel;
  final String goal;
  final List<String> recommendedSources;
  final String note;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sheetLabel': sheetLabel,
      'goal': goal,
      'recommendedSources': recommendedSources,
      'note': note,
    };
  }
}

const List<_WorkbookTrack> _workbookTracks = [
  _WorkbookTrack(
    sheetLabel: 'S-tier Gold core',
    goal: 'Measure accuracy with balanced, high-confidence reference material',
    recommendedSources: [
      'McGill Billboard',
      'Isophonics',
      'JAAH',
      'JHT',
      'ABC',
      'BPS-FH',
      'Mozart',
      'Romantic Piano Corpus',
      'TAVERN',
      'Winterreise',
      'DLC',
    ],
    note:
        'The repository does not bundle those external corpora yet, so this run uses an internal proxy corpus aligned to that track.',
  ),
  _WorkbookTrack(
    sheetLabel: 'Ambiguity validation',
    goal:
        'Measure ambiguous readings, partial parses, and placeholder inference separately',
    recommendedSources: ['CASD', 'community charts comparison'],
    note:
        'Exact-pass status is paired with detailed failure reasons because these cases can support multiple plausible readings.',
  ),
  _WorkbookTrack(
    sheetLabel: 'Stress / robustness',
    goal:
        'Measure throughput, long-sequence latency, and symbol normalization robustness',
    recommendedSources: ['Chordonomicon', 'PARC', 'ChoCo', 'TheoryTab'],
    note:
        'This run includes both mixed-corpus throughput and long-sequence latency.',
  ),
];

class _BenchmarkCase {
  const _BenchmarkCase({
    required this.id,
    required this.description,
    required this.progression,
    required this.track,
    required this.genre,
    required this.difficulty,
    required this.expectedKey,
    required this.expectedMode,
    this.expectedRomans = const [],
    this.segmentExpectations = const [],
    this.requiredTags = const [],
    this.requiredRemarks = const [],
    this.requiredEvidence = const [],
    this.expectedPartialFailure = false,
    this.expectedNoChordEventCount = 0,
    this.benchmarkClass = _BenchmarkClass.workbookProxy,
    this.sourceId = 'internal_proxy',
    this.sourceLabel = 'internal_proxy',
    this.corpusId,
    this.corpusName,
    this.annotationLevel,
    this.keyScope,
    this.segmentationScope,
    this.comparisonProfile = const _ComparisonProfile(),
    this.failureHints = const [],
    this.notes = const [],
  });

  final String id;
  final String description;
  final String progression;
  final _BenchmarkTrack track;
  final _BenchmarkGenre genre;
  final _DifficultyBucket difficulty;
  final String expectedKey;
  final KeyMode expectedMode;
  final List<String> expectedRomans;
  final List<_SegmentExpectation> segmentExpectations;
  final List<ProgressionTagId> requiredTags;
  final List<(int, ProgressionRemarkKind)> requiredRemarks;
  final List<(int, ProgressionEvidenceKind)> requiredEvidence;
  final bool expectedPartialFailure;
  final int expectedNoChordEventCount;
  final _BenchmarkClass benchmarkClass;
  final String sourceId;
  final String sourceLabel;
  final String? corpusId;
  final String? corpusName;
  final String? annotationLevel;
  final String? keyScope;
  final String? segmentationScope;
  final _ComparisonProfile comparisonProfile;
  final List<_FailureTaxonomy> failureHints;
  final List<String> notes;
}

class _CaseResult {
  const _CaseResult({
    required this.benchmarkCase,
    required this.elapsedMicroseconds,
    required this.keyMatch,
    required this.relaxedKeyMatch,
    required this.modeMatch,
    required this.partialFailureMatch,
    required this.noChordEventMatch,
    required this.noChordSensitiveCase,
    required this.exactPass,
    required this.matchedNoChordEvents,
    required this.totalNoChordEvents,
    required this.actualNoChordEventCount,
    required this.matchedSurfaceRomanTokens,
    required this.totalSurfaceRomanTokens,
    required this.matchedCanonicalRomanTokens,
    required this.totalCanonicalRomanTokens,
    required this.matchedRelaxedRomanTokens,
    required this.totalRelaxedRomanTokens,
    required this.matchedFunctionTokens,
    required this.totalFunctionTokens,
    required this.matchedTags,
    required this.totalTags,
    required this.matchedRemarks,
    required this.totalRemarks,
    required this.matchedEvidence,
    required this.totalEvidence,
    required this.modulationDiagnosticMatch,
    required this.modulationSensitiveCase,
    required this.actualKey,
    required this.actualMode,
    required this.actualRomans,
    required this.actualTags,
    required this.actualPartialFailure,
    required this.segmentComparisons,
    required this.modulationDiagnostics,
    required this.keyDiagnostics,
    required this.failureCategories,
    required this.likelyRootCauses,
    required this.failures,
  });

  final _BenchmarkCase benchmarkCase;
  final int elapsedMicroseconds;
  final bool keyMatch;
  final bool relaxedKeyMatch;
  final bool modeMatch;
  final bool partialFailureMatch;
  final bool noChordEventMatch;
  final bool noChordSensitiveCase;
  final bool exactPass;
  final int matchedNoChordEvents;
  final int totalNoChordEvents;
  final int actualNoChordEventCount;
  final int matchedSurfaceRomanTokens;
  final int totalSurfaceRomanTokens;
  final int matchedCanonicalRomanTokens;
  final int totalCanonicalRomanTokens;
  final int matchedRelaxedRomanTokens;
  final int totalRelaxedRomanTokens;
  final int matchedFunctionTokens;
  final int totalFunctionTokens;
  final int matchedTags;
  final int totalTags;
  final int matchedRemarks;
  final int totalRemarks;
  final int matchedEvidence;
  final int totalEvidence;
  final bool modulationDiagnosticMatch;
  final bool modulationSensitiveCase;
  final String actualKey;
  final String actualMode;
  final List<String> actualRomans;
  final List<String> actualTags;
  final bool actualPartialFailure;
  final List<_SegmentComparison> segmentComparisons;
  final _ModulationDiagnostics modulationDiagnostics;
  final _KeyDiagnostics keyDiagnostics;
  final List<_FailureTaxonomy> failureCategories;
  final List<String> likelyRootCauses;
  final List<String> failures;

  bool get notationOnlyKeyMiss => !keyMatch && relaxedKeyMatch;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': benchmarkCase.id,
      'description': benchmarkCase.description,
      'progression': benchmarkCase.progression,
      'benchmarkClass': benchmarkCase.benchmarkClass.label,
      'track': benchmarkCase.track.label,
      'genre': benchmarkCase.genre.label,
      'difficulty': benchmarkCase.difficulty.label,
      'sourceId': benchmarkCase.sourceId,
      'sourceLabel': benchmarkCase.sourceLabel,
      'corpusId': benchmarkCase.corpusId,
      'corpusName': benchmarkCase.corpusName,
      'annotationLevel': benchmarkCase.annotationLevel,
      'keyScope': benchmarkCase.keyScope,
      'segmentationScope': benchmarkCase.segmentationScope,
      'expected': {
        'key': benchmarkCase.expectedKey,
        'mode': benchmarkCase.expectedMode.name,
        'romans': benchmarkCase.expectedRomans,
        'segments': [
          for (final segment in benchmarkCase.segmentExpectations)
            segment.toJson(),
        ],
        'tags': benchmarkCase.requiredTags.map((tag) => tag.name).toList(),
        'remarks': [
          for (final requirement in benchmarkCase.requiredRemarks)
            {'index': requirement.$1, 'kind': requirement.$2.name},
        ],
        'evidence': [
          for (final requirement in benchmarkCase.requiredEvidence)
            {'index': requirement.$1, 'kind': requirement.$2.name},
        ],
        'partialFailure': benchmarkCase.expectedPartialFailure,
        'noChordEventCount': benchmarkCase.expectedNoChordEventCount,
        'comparisonProfile': benchmarkCase.comparisonProfile.toJson(),
        'failureHints': [
          for (final category in benchmarkCase.failureHints) category.label,
        ],
        'notes': benchmarkCase.notes,
      },
      'actual': {
        'key': actualKey,
        'mode': actualMode,
        'romans': actualRomans,
        'tags': actualTags,
        'partialFailure': actualPartialFailure,
        'noChordEventCount': actualNoChordEventCount,
      },
      'elapsedMicroseconds': elapsedMicroseconds,
      'checks': {
        'keyMatch': keyMatch,
        'relaxedKeyMatch': relaxedKeyMatch,
        'notationOnlyKeyMiss': notationOnlyKeyMiss,
        'modeMatch': modeMatch,
        'partialFailureMatch': partialFailureMatch,
        'noChordEventMatch': noChordEventMatch,
        'noChordSensitiveCase': noChordSensitiveCase,
        'noChordEvents': {
          'matched': matchedNoChordEvents,
          'total': totalNoChordEvents,
          'actual': actualNoChordEventCount,
        },
        'romanSurfaceExact': {
          'matched': matchedSurfaceRomanTokens,
          'total': totalSurfaceRomanTokens,
        },
        'romanTokenMatch': {
          'matched': matchedCanonicalRomanTokens,
          'total': totalCanonicalRomanTokens,
        },
        'romanCanonicalExact': {
          'matched': matchedCanonicalRomanTokens,
          'total': totalCanonicalRomanTokens,
        },
        'relaxedRomanTokenMatch': {
          'matched': matchedRelaxedRomanTokens,
          'total': totalRelaxedRomanTokens,
        },
        'functionTokenMatch': {
          'matched': matchedFunctionTokens,
          'total': totalFunctionTokens,
        },
        'tagMatch': {'matched': matchedTags, 'total': totalTags},
        'remarkMatch': {'matched': matchedRemarks, 'total': totalRemarks},
        'evidenceMatch': {'matched': matchedEvidence, 'total': totalEvidence},
        'modulationDiagnosticMatch': modulationDiagnosticMatch,
        'modulationSensitiveCase': modulationSensitiveCase,
        'exactPass': exactPass,
      },
      'segmentComparisons': [
        for (final comparison in segmentComparisons) comparison.toJson(),
      ],
      'modulationDiagnostics': modulationDiagnostics.toJson(),
      'keyDiagnostics': keyDiagnostics.toJson(),
      'failureCategories': [
        for (final category in failureCategories) category.label,
      ],
      'likelyRootCauses': likelyRootCauses,
      'failures': failures,
    };
  }
}

class _AggregateMetrics {
  const _AggregateMetrics({
    required this.caseCount,
    required this.exactProgressionPasses,
    required this.keyMatches,
    required this.relaxedKeyMatches,
    required this.modeMatches,
    required this.partialFailureMatches,
    required this.noChordEventMatches,
    required this.totalNoChordSensitiveCases,
    required this.matchedNoChordEvents,
    required this.totalNoChordEvents,
    required this.matchedSurfaceRomanTokens,
    required this.totalSurfaceRomanTokens,
    required this.matchedCanonicalRomanTokens,
    required this.totalCanonicalRomanTokens,
    required this.matchedRelaxedRomanTokens,
    required this.totalRelaxedRomanTokens,
    required this.matchedFunctionTokens,
    required this.totalFunctionTokens,
    required this.matchedTags,
    required this.totalTags,
    required this.matchedRemarks,
    required this.totalRemarks,
    required this.matchedEvidence,
    required this.totalEvidence,
    required this.modulationDiagnosticMatches,
    required this.totalModulationSensitiveCases,
    required this.meanLatencyMilliseconds,
  });

  final int caseCount;
  final int exactProgressionPasses;
  final int keyMatches;
  final int relaxedKeyMatches;
  final int modeMatches;
  final int partialFailureMatches;
  final int noChordEventMatches;
  final int totalNoChordSensitiveCases;
  final int matchedNoChordEvents;
  final int totalNoChordEvents;
  final int matchedSurfaceRomanTokens;
  final int totalSurfaceRomanTokens;
  final int matchedCanonicalRomanTokens;
  final int totalCanonicalRomanTokens;
  final int matchedRelaxedRomanTokens;
  final int totalRelaxedRomanTokens;
  final int matchedFunctionTokens;
  final int totalFunctionTokens;
  final int matchedTags;
  final int totalTags;
  final int matchedRemarks;
  final int totalRemarks;
  final int matchedEvidence;
  final int totalEvidence;
  final int modulationDiagnosticMatches;
  final int totalModulationSensitiveCases;
  final double meanLatencyMilliseconds;

  double get exactProgressionPassRate =>
      _safeDivide(exactProgressionPasses, caseCount);

  double get keyAccuracy => _safeDivide(keyMatches, caseCount);

  double get relaxedKeyAccuracy => _safeDivide(relaxedKeyMatches, caseCount);

  double get modeAccuracy => _safeDivide(modeMatches, caseCount);

  double get partialFailureExpectationAccuracy =>
      _safeDivide(partialFailureMatches, caseCount);

  double get noChordCaseAccuracy =>
      _safeDivide(noChordEventMatches, totalNoChordSensitiveCases);

  double get noChordEventAccuracy =>
      _safeDivide(matchedNoChordEvents, totalNoChordEvents);

  double get romanSurfaceExactAccuracy =>
      _safeDivide(matchedSurfaceRomanTokens, totalSurfaceRomanTokens);

  double get romanCanonicalExactAccuracy =>
      _safeDivide(matchedCanonicalRomanTokens, totalCanonicalRomanTokens);

  double get romanTokenAccuracy => romanCanonicalExactAccuracy;

  double get relaxedRomanTokenAccuracy =>
      _safeDivide(matchedRelaxedRomanTokens, totalRelaxedRomanTokens);

  double get functionTokenAccuracy =>
      _safeDivide(matchedFunctionTokens, totalFunctionTokens);

  double get tagRecall => _safeDivide(matchedTags, totalTags);

  double get remarkRecall => _safeDivide(matchedRemarks, totalRemarks);

  double get evidenceRecall => _safeDivide(matchedEvidence, totalEvidence);

  double get modulationDiagnosticAccuracy =>
      _safeDivide(modulationDiagnosticMatches, totalModulationSensitiveCases);

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'caseCount': caseCount,
      'exactProgressionPasses': exactProgressionPasses,
      'exactProgressionPassRate': exactProgressionPassRate,
      'keyAccuracy': keyAccuracy,
      'relaxedKeyAccuracy': relaxedKeyAccuracy,
      'modeAccuracy': modeAccuracy,
      'partialFailureExpectationAccuracy': partialFailureExpectationAccuracy,
      'noChordCaseAccuracy': _nullableDivide(
        noChordEventMatches,
        totalNoChordSensitiveCases,
      ),
      'noChordEventAccuracy': _nullableDivide(
        matchedNoChordEvents,
        totalNoChordEvents,
      ),
      'romanSurfaceExactAccuracy': _nullableDivide(
        matchedSurfaceRomanTokens,
        totalSurfaceRomanTokens,
      ),
      'romanCanonicalExactAccuracy': _nullableDivide(
        matchedCanonicalRomanTokens,
        totalCanonicalRomanTokens,
      ),
      'romanTokenAccuracy': _nullableDivide(
        matchedCanonicalRomanTokens,
        totalCanonicalRomanTokens,
      ),
      'relaxedRomanTokenAccuracy': _nullableDivide(
        matchedRelaxedRomanTokens,
        totalRelaxedRomanTokens,
      ),
      'functionTokenAccuracy': _nullableDivide(
        matchedFunctionTokens,
        totalFunctionTokens,
      ),
      'tagRecall': _nullableDivide(matchedTags, totalTags),
      'remarkRecall': _nullableDivide(matchedRemarks, totalRemarks),
      'evidenceRecall': _nullableDivide(matchedEvidence, totalEvidence),
      'modulationDiagnosticAccuracy': _nullableDivide(
        modulationDiagnosticMatches,
        totalModulationSensitiveCases,
      ),
      'meanLatencyMilliseconds': meanLatencyMilliseconds,
      'totals': {
        'surfaceRomanTokens': totalSurfaceRomanTokens,
        'canonicalRomanTokens': totalCanonicalRomanTokens,
        'romanTokens': totalCanonicalRomanTokens,
        'relaxedRomanTokens': totalRelaxedRomanTokens,
        'functionTokens': totalFunctionTokens,
        'noChordSensitiveCases': totalNoChordSensitiveCases,
        'noChordEvents': totalNoChordEvents,
        'tags': totalTags,
        'remarks': totalRemarks,
        'evidence': totalEvidence,
        'modulationSensitiveCases': totalModulationSensitiveCases,
      },
    };
  }
}

class _PerformanceMetrics {
  const _PerformanceMetrics({
    required this.label,
    required this.runs,
    required this.warmupRuns,
    required this.analysisCount,
    required this.chordCount,
    required this.totalElapsedMicroseconds,
    required this.minMicroseconds,
    required this.maxMicroseconds,
    required this.meanMicroseconds,
    required this.p50Microseconds,
    required this.p95Microseconds,
    required this.p99Microseconds,
    required this.analysesPerSecond,
    required this.chordsPerSecond,
    this.inputChordCount,
    this.inputLengthCharacters,
  });

  final String label;
  final int runs;
  final int warmupRuns;
  final int analysisCount;
  final int chordCount;
  final int totalElapsedMicroseconds;
  final int minMicroseconds;
  final int maxMicroseconds;
  final double meanMicroseconds;
  final double p50Microseconds;
  final double p95Microseconds;
  final double p99Microseconds;
  final double analysesPerSecond;
  final double chordsPerSecond;
  final int? inputChordCount;
  final int? inputLengthCharacters;

  double get meanMilliseconds => meanMicroseconds / 1000.0;

  double get p50Milliseconds => p50Microseconds / 1000.0;

  double get p95Milliseconds => p95Microseconds / 1000.0;

  double get p99Milliseconds => p99Microseconds / 1000.0;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'label': label,
      'runs': runs,
      'warmupRuns': warmupRuns,
      'analysisCount': analysisCount,
      'chordCount': chordCount,
      'totalElapsedMicroseconds': totalElapsedMicroseconds,
      'minMicroseconds': minMicroseconds,
      'maxMicroseconds': maxMicroseconds,
      'meanMicroseconds': meanMicroseconds,
      'p50Microseconds': p50Microseconds,
      'p95Microseconds': p95Microseconds,
      'p99Microseconds': p99Microseconds,
      'analysesPerSecond': analysesPerSecond,
      'chordsPerSecond': chordsPerSecond,
      'inputChordCount': inputChordCount,
      'inputLengthCharacters': inputLengthCharacters,
    };
  }
}

class _LongSequenceInput {
  const _LongSequenceInput({
    required this.progression,
    required this.chordCount,
    required this.sourceCaseCount,
  });

  final String progression;
  final int chordCount;
  final int sourceCaseCount;
}

class _BenchmarkReport {
  const _BenchmarkReport({
    required this.generatedAtUtc,
    required this.workbookSourcePath,
    required this.benchmarkCaseCount,
    required this.workbookTracks,
    required this.overall,
    required this.proxyOverall,
    required this.externalGoldOverall,
    required this.byClass,
    required this.byTrack,
    required this.byGenre,
    required this.byDifficulty,
    required this.externalGoldByCorpus,
    required this.externalGoldBySourceId,
    required this.externalGoldByAnnotationLevel,
    required this.externalGoldByKeyScope,
    required this.externalGoldBySegmentationScope,
    required this.failures,
    required this.externalGoldFailures,
    required this.curatedGoldLoad,
    required this.mixedCorpusPerformance,
    required this.longSequencePerformance,
  });

  final DateTime generatedAtUtc;
  final String? workbookSourcePath;
  final int benchmarkCaseCount;
  final List<_WorkbookTrack> workbookTracks;
  final _AggregateMetrics overall;
  final _AggregateMetrics proxyOverall;
  final _AggregateMetrics externalGoldOverall;
  final Map<String, _AggregateMetrics> byClass;
  final Map<String, _AggregateMetrics> byTrack;
  final Map<String, _AggregateMetrics> byGenre;
  final Map<String, _AggregateMetrics> byDifficulty;
  final Map<String, _AggregateMetrics> externalGoldByCorpus;
  final Map<String, _AggregateMetrics> externalGoldBySourceId;
  final Map<String, _AggregateMetrics> externalGoldByAnnotationLevel;
  final Map<String, _AggregateMetrics> externalGoldByKeyScope;
  final Map<String, _AggregateMetrics> externalGoldBySegmentationScope;
  final List<_CaseResult> failures;
  final List<_CaseResult> externalGoldFailures;
  final _CuratedGoldLoadResult curatedGoldLoad;
  final _PerformanceMetrics mixedCorpusPerformance;
  final _PerformanceMetrics longSequencePerformance;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'generatedAtUtc': generatedAtUtc.toIso8601String(),
      'workbookSourcePath': workbookSourcePath,
      'benchmarkCaseCount': benchmarkCaseCount,
      'workbookTracks': [for (final track in workbookTracks) track.toJson()],
      'curatedGoldLoad': curatedGoldLoad.toJson(),
      'accuracy': {
        'overall': overall.toJson(),
        'proxyVsExternal': {
          'internalProxy': proxyOverall.toJson(),
          'externalGold': externalGoldOverall.toJson(),
        },
        'byClass': {
          for (final entry in byClass.entries) entry.key: entry.value.toJson(),
        },
        'byTrack': {
          for (final entry in byTrack.entries) entry.key: entry.value.toJson(),
        },
        'byGenre': {
          for (final entry in byGenre.entries) entry.key: entry.value.toJson(),
        },
        'byDifficulty': {
          for (final entry in byDifficulty.entries)
            entry.key: entry.value.toJson(),
        },
        'failureTaxonomyCounts': {
          for (final entry in _failureCategoryCounts(failures).entries)
            entry.key.label: entry.value,
        },
        'externalGold': {
          'overall': externalGoldOverall.toJson(),
          'byCorpus': {
            for (final entry in externalGoldByCorpus.entries)
              entry.key: entry.value.toJson(),
          },
          'bySourceId': {
            for (final entry in externalGoldBySourceId.entries)
              entry.key: entry.value.toJson(),
          },
          'byAnnotationLevel': {
            for (final entry in externalGoldByAnnotationLevel.entries)
              entry.key: entry.value.toJson(),
          },
          'byKeyScope': {
            for (final entry in externalGoldByKeyScope.entries)
              entry.key: entry.value.toJson(),
          },
          'bySegmentationScope': {
            for (final entry in externalGoldBySegmentationScope.entries)
              entry.key: entry.value.toJson(),
          },
          'majorFailureClusters': _majorFailureClusters(
            failures: externalGoldFailures,
            bySource: externalGoldBySourceId,
          ),
          'surfaceNotationGapCases': [
            for (final entry in _surfaceNotationGapEntries(
              externalGoldBySourceId,
            ))
              {
                'bucket': entry.key,
                'matchedSurfaceRomanTokens':
                    entry.value.matchedSurfaceRomanTokens,
                'totalSurfaceRomanTokens': entry.value.totalSurfaceRomanTokens,
                'matchedCanonicalRomanTokens':
                    entry.value.matchedCanonicalRomanTokens,
                'totalCanonicalRomanTokens':
                    entry.value.totalCanonicalRomanTokens,
                'surfaceRomanExactAccuracy':
                    entry.value.romanSurfaceExactAccuracy,
                'canonicalRomanExactAccuracy':
                    entry.value.romanCanonicalExactAccuracy,
                'accuracyGap':
                    entry.value.romanCanonicalExactAccuracy -
                    entry.value.romanSurfaceExactAccuracy,
              },
          ],
          'failures': [
            for (final failure in externalGoldFailures) failure.toJson(),
          ],
        },
        'failures': [for (final failure in failures) failure.toJson()],
      },
      'performance': {
        'mixedCorpus': mixedCorpusPerformance.toJson(),
        'longSequence': longSequencePerformance.toJson(),
      },
    };
  }

  String toMarkdown() {
    final buffer = StringBuffer();
    buffer.writeln('# Chord Analyzer Benchmark Report');
    buffer.writeln('');
    buffer.writeln('## Summary');
    buffer.writeln('');
    buffer.writeln('- Generated (UTC): ${generatedAtUtc.toIso8601String()}');
    if (workbookSourcePath != null && workbookSourcePath!.isNotEmpty) {
      buffer.writeln('- Source workbook: `$workbookSourcePath`');
    }
    buffer.writeln(
      '- Benchmark corpus: $benchmarkCaseCount cases across proxy, dirty-input, and curated-gold layers',
    );
    if (curatedGoldLoad.loadedCaseCount > 0) {
      buffer.writeln(
        '- Important note: the workbook is still a source inventory and test-plan document, not a bundled labeled corpus. '
        'This run therefore combines the in-repo proxy benchmark with a separately loaded external-gold slice.',
      );
      buffer.writeln(
        '- External gold headline: '
        '${_formatPercent(externalGoldOverall.exactProgressionPassRate)} exact pass, '
        '${_formatPercent(externalGoldOverall.keyAccuracy)} key accuracy, '
        '${_formatConditionalPercent(externalGoldOverall.matchedCanonicalRomanTokens, externalGoldOverall.totalCanonicalRomanTokens)} Roman canonical exact.',
      );
      if (externalGoldOverall.relaxedKeyAccuracy >
          externalGoldOverall.keyAccuracy) {
        buffer.writeln(
          '- Relaxed key accuracy is ${_formatPercent(externalGoldOverall.relaxedKeyAccuracy)}, which separates notation-only key spelling gaps from true key-center misses.',
        );
      }
      if (curatedGoldLoad.rawNonHarmonicSegmentCount > 0) {
        buffer.writeln(
          '- External no-chord handling: '
          '${curatedGoldLoad.keptNonHarmonicSegmentCount}/${curatedGoldLoad.rawNonHarmonicSegmentCount} non-harmonic segments retained '
          '(${_formatOptionalPercent(curatedGoldLoad.nonHarmonicRetentionRatio)}), with harmonic coverage at '
          '${_formatOptionalPercent(curatedGoldLoad.harmonicCoverageRatio)}.',
        );
      }
    } else {
      buffer.writeln(
        '- Important note: the workbook is a source inventory and test-plan document, not a bundled labeled corpus. '
        'This run therefore measures an in-repo proxy benchmark aligned to the workbook taxonomy.',
      );
    }
    buffer.writeln('');
    buffer.writeln(
      '- External gold status: ${curatedGoldLoad.status} '
      '(${curatedGoldLoad.loadedCaseCount} cases loaded)',
    );
    if (curatedGoldLoad.effectiveCorpusLoads.length == 1 &&
        curatedGoldLoad.corpusName != null &&
        curatedGoldLoad.corpusName!.isNotEmpty) {
      buffer.writeln('- External gold corpus: ${curatedGoldLoad.corpusName}');
    } else if (curatedGoldLoad.effectiveCorpusLoads.length > 1) {
      buffer.writeln(
        '- External gold corpora: ${curatedGoldLoad.effectiveCorpusLoads.map((load) => load.corpusName).join('; ')}',
      );
    }
    if (curatedGoldLoad.rawRecordCount > 0 ||
        curatedGoldLoad.rawSegmentCount > 0) {
      buffer.writeln(
        '- External gold coverage: '
        '${curatedGoldLoad.loadedCaseCount}/${curatedGoldLoad.rawRecordCount} records kept '
        '(${_formatOptionalPercent(curatedGoldLoad.recordCoverageRatio)}), '
        '${curatedGoldLoad.keptSegmentCount}/${curatedGoldLoad.rawSegmentCount} segments kept '
        '(${_formatOptionalPercent(curatedGoldLoad.segmentCoverageRatio)})',
      );
      if (curatedGoldLoad.rawNonHarmonicSegmentCount > 0) {
        buffer.writeln(
          '- External harmonic/non-harmonic split: '
          '${curatedGoldLoad.keptHarmonicSegmentCount}/${curatedGoldLoad.rawHarmonicSegmentCount} harmonic segments kept '
          '(${_formatOptionalPercent(curatedGoldLoad.harmonicCoverageRatio)}), '
          '${curatedGoldLoad.keptNonHarmonicSegmentCount}/${curatedGoldLoad.rawNonHarmonicSegmentCount} non-harmonic segments retained '
          '(${_formatOptionalPercent(curatedGoldLoad.nonHarmonicRetentionRatio)}).',
        );
      }
    }
    if (curatedGoldLoad.skippedRecordCount > 0 ||
        curatedGoldLoad.skippedSegmentCount > 0) {
      buffer.writeln(
        '- External gold skips: ${curatedGoldLoad.skippedRecordCount} records, '
        '${curatedGoldLoad.skippedSegmentCount} segments',
      );
    }
    buffer.writeln('');
    buffer.writeln('## Scope And Validity');
    buffer.writeln('');
    buffer.writeln(
      '- The workbook proxy benchmark measures internal consistency, regression stability, and coverage of known harmonic situations.',
    );
    buffer.writeln(
      '- Even with these external slices, this run still does not by itself prove generalization across full McGill Billboard, JAAH, WJazzD, or full-scale Isophonics/When in Rome/DCML coverage.',
    );
    buffer.writeln(
      '- Exact progression pass is intentionally preserved, but it is now paired with relaxed Roman/function comparison, modulation diagnostics, and segment-level mismatch reporting.',
    );
    if (curatedGoldLoad.loadedCaseCount > 0) {
      buffer.writeln(
        '- The current external layer mixes local-excerpt symbolic classical gold with global-movement audio-aligned pop gold, so metrics must be read with annotation scope in mind.',
      );
    }
    buffer.writeln(
      '- The `gold-classical-c-real-modulation` miss matters because it suggests ending bias and a soft boundary between local tonicization evidence and true modulation when the global key summary is chosen.',
    );
    buffer.writeln('');
    buffer.writeln('## Workbook Alignment');
    buffer.writeln('');
    for (final track in workbookTracks) {
      buffer.writeln('- `${track.sheetLabel}`: ${track.goal}');
      buffer.writeln('  Sources: ${track.recommendedSources.join(', ')}');
      buffer.writeln('  Note: ${track.note}');
    }
    buffer.writeln('');
    buffer.writeln('## External Gold Coverage');
    buffer.writeln('');
    if (curatedGoldLoad.loadedCaseCount == 0) {
      buffer.writeln('- No external gold cases were loaded in this run.');
    } else {
      if (curatedGoldLoad.manifestPaths.isNotEmpty) {
        buffer.writeln(
          '- Manifest paths: ${curatedGoldLoad.manifestPaths.map((path) => '`$path`').join(', ')}',
        );
      }
      if (curatedGoldLoad.effectiveCorpusLoads.isNotEmpty) {
        buffer.writeln(
          '- Corpora loaded: ${curatedGoldLoad.effectiveCorpusLoads.map((load) => '`${load.corpusId}` (${load.corpusName})').join(', ')}',
        );
      }
      buffer.writeln(
        '- Raw records: ${curatedGoldLoad.rawRecordCount}; loaded records: '
        '${curatedGoldLoad.loadedCaseCount}; skipped records: '
        '${curatedGoldLoad.skippedRecordCount}',
      );
      buffer.writeln(
        '- Raw segments: ${curatedGoldLoad.rawSegmentCount}; kept segments: '
        '${curatedGoldLoad.keptSegmentCount}; skipped segments: '
        '${curatedGoldLoad.skippedSegmentCount}',
      );
      if (curatedGoldLoad.rawNonHarmonicSegmentCount > 0) {
        buffer.writeln(
          '- Harmonic/non-harmonic segments: '
          '${curatedGoldLoad.rawHarmonicSegmentCount} harmonic raw, '
          '${curatedGoldLoad.keptHarmonicSegmentCount} harmonic kept; '
          '${curatedGoldLoad.rawNonHarmonicSegmentCount} non-harmonic raw, '
          '${curatedGoldLoad.keptNonHarmonicSegmentCount} non-harmonic kept',
        );
      }
      buffer.writeln(
        '- Coverage ratio: records ${_formatOptionalPercent(curatedGoldLoad.recordCoverageRatio)}, '
        'segments ${_formatOptionalPercent(curatedGoldLoad.segmentCoverageRatio)}'
        '${curatedGoldLoad.rawNonHarmonicSegmentCount > 0 ? ', harmonic ${_formatOptionalPercent(curatedGoldLoad.harmonicCoverageRatio)}, non-harmonic ${_formatOptionalPercent(curatedGoldLoad.nonHarmonicRetentionRatio)}' : ''}',
      );
      if (curatedGoldLoad.effectiveCorpusLoads.isNotEmpty) {
        for (final load in curatedGoldLoad.effectiveCorpusLoads) {
          buffer.writeln(
            '- `${load.corpusId}`: ${load.loadedCaseCount}/${load.rawRecordCount} records '
            '(${_formatOptionalPercent(load.recordCoverageRatio)}), '
            '${load.keptSegmentCount}/${load.rawSegmentCount} segments '
            '(${_formatOptionalPercent(load.segmentCoverageRatio)})'
            '${load.rawNonHarmonicSegmentCount > 0 ? '; harmonic ${load.keptHarmonicSegmentCount}/${load.rawHarmonicSegmentCount} (${_formatOptionalPercent(load.harmonicCoverageRatio)}), non-harmonic ${load.keptNonHarmonicSegmentCount}/${load.rawNonHarmonicSegmentCount} (${_formatOptionalPercent(load.nonHarmonicRetentionRatio)})' : ''}',
          );
          if (load.adapterId != null && load.adapterId!.isNotEmpty) {
            buffer.writeln('  Adapter: `${load.adapterId}`');
          }
          if (load.importMode != null && load.importMode!.isNotEmpty) {
            buffer.writeln('  Import mode: `${load.importMode}`');
          }
          if (load.manifestPath != null && load.manifestPath!.isNotEmpty) {
            buffer.writeln('  Manifest: `${load.manifestPath}`');
          }
          if (load.selectionManifestPath != null &&
              load.selectionManifestPath!.isNotEmpty) {
            buffer.writeln(
              '  Selection manifest: `${load.selectionManifestPath}`',
            );
          }
          if (load.sourceCorpusRootPath != null &&
              load.sourceCorpusRootPath!.isNotEmpty) {
            buffer.writeln(
              '  Source corpus root: `${load.sourceCorpusRootPath}`',
            );
          }
          if (load.fixtureDirectory != null &&
              load.fixtureDirectory!.isNotEmpty) {
            buffer.writeln(
              '  Fixture/import directory: `${load.fixtureDirectory}`',
            );
          }
          if (load.licenseNote != null && load.licenseNote!.isNotEmpty) {
            buffer.writeln('  License note: ${load.licenseNote}');
          }
        }
      } else if (curatedGoldLoad.licenseNote != null &&
          curatedGoldLoad.licenseNote!.isNotEmpty) {
        buffer.writeln('- License note: ${curatedGoldLoad.licenseNote}');
      }
      if (externalGoldBySourceId.isNotEmpty) {
        buffer.writeln(
          '- Source ids: ${externalGoldBySourceId.keys.join(', ')}',
        );
      }
      if (externalGoldByAnnotationLevel.isNotEmpty) {
        buffer.writeln(
          '- Annotation levels: ${externalGoldByAnnotationLevel.keys.join(', ')}',
        );
      }
      if (externalGoldByAnnotationLevel.containsKey('surface')) {
        buffer.writeln(
          '- Surface-only corpora contribute to key/mode/resolved-symbol evaluation, but Roman/function metrics remain `n/a` when the source annotation does not include those labels.',
        );
      }
      if (externalGoldByKeyScope.isNotEmpty) {
        buffer.writeln(
          '- Key scopes: ${externalGoldByKeyScope.keys.join(', ')}',
        );
      }
      if (curatedGoldLoad.recordDropReasonCounts.isNotEmpty) {
        buffer.writeln(
          '- Record drop reasons: ${_reasonSummary(curatedGoldLoad.recordDropReasonCounts)}',
        );
      }
      if (curatedGoldLoad.skipReasonCounts.isNotEmpty) {
        buffer.writeln(
          '- Segment skip reasons: ${_reasonSummary(curatedGoldLoad.skipReasonCounts)}',
        );
      }
      if (curatedGoldLoad.rawRecordCount > 0) {
        buffer.writeln('');
        if (curatedGoldLoad.coverageByCorpus.isNotEmpty) {
          buffer.writeln(
            _coverageTable(
              'Coverage By Corpus',
              curatedGoldLoad.coverageByCorpus,
            ),
          );
          buffer.writeln('');
        }
        buffer.writeln(
          _coverageTable(
            'Coverage By Source Id',
            curatedGoldLoad.coverageBySourceId,
          ),
        );
      }
    }
    buffer.writeln('');
    buffer.writeln('## Accuracy');
    buffer.writeln('');
    buffer.writeln(_aggregateTable('Accuracy By Benchmark Class', byClass));
    buffer.writeln('');
    buffer.writeln(_aggregateTable('Overall', {'Overall': overall}));
    buffer.writeln('');
    buffer.writeln(_aggregateTable('By Track', byTrack));
    buffer.writeln('');
    buffer.writeln(_aggregateTable('By Genre', byGenre));
    buffer.writeln('');
    buffer.writeln(_aggregateTable('By Difficulty', byDifficulty));
    buffer.writeln('');
    buffer.writeln('## Proxy Vs External Gold');
    buffer.writeln('');
    buffer.writeln(
      _aggregateTable('Proxy Vs External', {
        'Internal proxy': proxyOverall,
        'External gold': externalGoldOverall,
      }),
    );
    buffer.writeln('');
    buffer.writeln('## External Gold Accuracy');
    buffer.writeln('');
    if (externalGoldOverall.caseCount == 0) {
      buffer.writeln('No external gold cases were evaluated in this run.');
      buffer.writeln('');
    } else {
      buffer.writeln(
        _aggregateTable('External Gold Overall', {
          'External gold': externalGoldOverall,
        }),
      );
      buffer.writeln('');
      buffer.writeln(
        _aggregateTable('External Gold By Corpus', externalGoldByCorpus),
      );
      buffer.writeln('');
      buffer.writeln(
        _aggregateTable('External Gold By Source Id', externalGoldBySourceId),
      );
      buffer.writeln('');
      buffer.writeln(
        _aggregateTable(
          'External Gold By Annotation Level',
          externalGoldByAnnotationLevel,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _aggregateTable('External Gold By Key Scope', externalGoldByKeyScope),
      );
      buffer.writeln('');
      buffer.writeln(
        _aggregateTable(
          'External Gold By Segmentation Scope',
          externalGoldBySegmentationScope,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable('External Gold Key/Mode/Function', {
          'External gold': externalGoldOverall,
        }),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable(
          'External Gold By Corpus Raw/Canonical',
          externalGoldByCorpus,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable(
          'External Gold By Source Id Raw/Canonical',
          externalGoldBySourceId,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable(
          'External Gold By Annotation Level Raw/Canonical',
          externalGoldByAnnotationLevel,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable(
          'External Gold By Key Scope Raw/Canonical',
          externalGoldByKeyScope,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _breakdownTable(
          'External Gold By Segmentation Scope Raw/Canonical',
          externalGoldBySegmentationScope,
        ),
      );
      buffer.writeln('');
      buffer.writeln(
        _surfaceNotationGapTable(
          'External Gold Surface-vs-Canonical Gaps',
          externalGoldBySourceId,
        ),
      );
      buffer.writeln('');
    }
    buffer.writeln('## Key/Mode/Function Breakdown');
    buffer.writeln('');
    buffer.writeln(_breakdownTable('Overall', {'Overall': overall}));
    buffer.writeln('');
    buffer.writeln(_breakdownTable('By Benchmark Class', byClass));
    buffer.writeln('');
    buffer.writeln('## Major Failure Clusters');
    buffer.writeln('');
    final externalMajorFailureClusters = _majorFailureClusters(
      failures: externalGoldFailures,
      bySource: externalGoldBySourceId,
    );
    if (externalMajorFailureClusters.isEmpty) {
      buffer.writeln(
        '- No external-gold failure clusters were large enough to summarize in this run.',
      );
    } else {
      for (final entry in externalMajorFailureClusters.entries) {
        buffer.writeln('- `${entry.key}`: ${entry.value} external cases');
      }
    }
    buffer.writeln('');
    if (failures.isEmpty) {
      buffer.writeln('## Failure Cases');
      buffer.writeln('');
      buffer.writeln('No exact-pass failures were observed in this run.');
    } else {
      buffer.writeln('## Failure Cases');
      buffer.writeln('');
      for (final failure in failures) {
        buffer.writeln(
          '- `${failure.benchmarkCase.id}` ${failure.benchmarkCase.description}',
        );
        buffer.writeln('  Progression: `${failure.benchmarkCase.progression}`');
        buffer.writeln('  Issues: ${failure.failures.join('; ')}');
        buffer.writeln(
          '  Key verdict: strict=${failure.keyMatch ? 'match' : 'mismatch'}, '
          'relaxed=${failure.relaxedKeyMatch ? 'match' : 'mismatch'}',
        );
        buffer.writeln(
          '  Failure taxonomy: ${_taxonomySummary(failure.failureCategories)}',
        );
        buffer.writeln('  Key diagnostics: ${failure.keyDiagnostics.summary}');
        if (failure.noChordSensitiveCase) {
          buffer.writeln(
            '  No-chord events: expected ${failure.totalNoChordEvents}, got ${failure.actualNoChordEventCount}',
          );
        }
        if (failure.segmentComparisons.any(
          (comparison) => comparison.hasMismatch,
        )) {
          for (final comparison in failure.segmentComparisons.where(
            (comparison) => comparison.hasMismatch,
          )) {
            buffer.writeln(
              '  Segment ${comparison.index}: expected '
              '${comparison.expectedCanonicalRoman ?? comparison.expectedResolvedSymbol ?? '<unspecified>'} '
              'but got ${comparison.actualRoman ?? comparison.actualResolvedSymbol ?? '<missing>'} '
              '(${comparison.mismatchReasons.join(', ')})',
            );
          }
        }
      }
    }
    buffer.writeln('');
    buffer.writeln('## External Gold Failures');
    buffer.writeln('');
    if (externalGoldFailures.isEmpty) {
      if (externalGoldOverall.caseCount == 0) {
        buffer.writeln(
          'No external gold cases were loaded, so no external gold failures were evaluated.',
        );
      } else {
        buffer.writeln(
          'No external gold exact-pass failures were observed in this run.',
        );
      }
    } else {
      for (final failure in externalGoldFailures) {
        buffer.writeln(
          '- `${failure.benchmarkCase.id}` ${failure.benchmarkCase.description}',
        );
        buffer.writeln('  Source id: `${failure.benchmarkCase.sourceId}`');
        buffer.writeln('  Progression: `${failure.benchmarkCase.progression}`');
        buffer.writeln('  Issues: ${failure.failures.join('; ')}');
        buffer.writeln(
          '  Key verdict: strict=${failure.keyMatch ? 'match' : 'mismatch'}, '
          'relaxed=${failure.relaxedKeyMatch ? 'match' : 'mismatch'}',
        );
        buffer.writeln(
          '  Failure taxonomy: ${_taxonomySummary(failure.failureCategories)}',
        );
        buffer.writeln('  Key diagnostics: ${failure.keyDiagnostics.summary}');
        if (failure.noChordSensitiveCase) {
          buffer.writeln(
            '  No-chord events: expected ${failure.totalNoChordEvents}, got ${failure.actualNoChordEventCount}',
          );
        }
        if (failure.segmentComparisons.any(
          (comparison) => comparison.hasMismatch,
        )) {
          for (final comparison in failure.segmentComparisons.where(
            (comparison) => comparison.hasMismatch,
          )) {
            buffer.writeln(
              '  Segment ${comparison.index}: surface='
              '${comparison.expectedSurfaceRoman ?? '<n/a>'}, canonical='
              '${comparison.expectedCanonicalRoman ?? '<n/a>'}, analyzer='
              '${comparison.actualRoman ?? '<missing>'} '
              '(${comparison.mismatchReasons.join(', ')})',
            );
          }
        }
      }
    }
    buffer.writeln('');
    buffer.writeln('## Likely Root Causes');
    buffer.writeln('');
    for (final entry in _failureCategoryCounts(failures).entries) {
      buffer.writeln(
        '- `${entry.key.label}` (${entry.value}): ${entry.key.rootCause}',
      );
    }
    if (failures.isEmpty) {
      buffer.writeln('- No failure categories were triggered in this run.');
    }
    buffer.writeln('');
    buffer.writeln('## Recommended Next Fixes');
    buffer.writeln('');
    for (final fix in _recommendedFixes(failures)) {
      buffer.writeln('- $fix');
    }
    if (failures.isEmpty) {
      buffer.writeln(
        '- Attach a curated external gold manifest to move beyond proxy-only validation.',
      );
    }
    buffer.writeln('');
    buffer.writeln('## Performance');
    buffer.writeln('');
    buffer.writeln(_performanceSummary(mixedCorpusPerformance));
    buffer.writeln('');
    buffer.writeln(_performanceSummary(longSequencePerformance));
    return buffer.toString().trimRight();
  }
}

class _Args {
  const _Args({
    required this.outputDir,
    required this.rounds,
    required this.warmupRounds,
    required this.longRuns,
    required this.longChordTarget,
    required this.curatedGoldManifestPath,
    this.abcSourceRootPath,
    this.whenInRomeSourceRootPath,
    this.sourceWorkbookPath,
  });

  final String outputDir;
  final int rounds;
  final int warmupRounds;
  final int longRuns;
  final int longChordTarget;
  final String? curatedGoldManifestPath;
  final String? abcSourceRootPath;
  final String? whenInRomeSourceRootPath;
  final String? sourceWorkbookPath;

  static _Args parseEnvironment(Map<String, String> environment) {
    return _Args(
      outputDir:
          environment['CHORD_ANALYZER_BENCHMARK_OUT_DIR'] ?? _defaultOutputDir,
      rounds:
          int.tryParse(environment['CHORD_ANALYZER_BENCHMARK_ROUNDS'] ?? '') ??
          _defaultRounds,
      warmupRounds:
          int.tryParse(
            environment['CHORD_ANALYZER_BENCHMARK_WARMUP_ROUNDS'] ?? '',
          ) ??
          _defaultWarmupRounds,
      longRuns:
          int.tryParse(
            environment['CHORD_ANALYZER_BENCHMARK_LONG_RUNS'] ?? '',
          ) ??
          _defaultLongRuns,
      longChordTarget:
          int.tryParse(
            environment['CHORD_ANALYZER_BENCHMARK_LONG_CHORD_TARGET'] ?? '',
          ) ??
          _defaultLongChordTarget,
      curatedGoldManifestPath:
          environment['CHORD_ANALYZER_BENCHMARK_CURATED_GOLD_MANIFEST'],
      abcSourceRootPath:
          environment['CHORD_ANALYZER_BENCHMARK_ABC_SOURCE_ROOT'],
      whenInRomeSourceRootPath:
          environment['CHORD_ANALYZER_BENCHMARK_WIR_SOURCE_ROOT'],
      sourceWorkbookPath: environment['CHORD_ANALYZER_BENCHMARK_SOURCE_XLSX'],
    );
  }
}

_CaseResult _evaluateCase(
  ProgressionAnalyzer analyzer,
  _BenchmarkCase benchmarkCase,
) {
  final stopwatch = Stopwatch()..start();
  final analysis = analyzer.analyze(benchmarkCase.progression);
  stopwatch.stop();

  final actualRomans = [
    for (final chord in analysis.chordAnalyses) chord.romanNumeral,
  ];
  final actualTags = [for (final tag in analysis.tags) tag.name];
  final failures = <String>[];

  final keyMatch =
      analysis.primaryKey.keyCenter.tonicName == benchmarkCase.expectedKey;
  final relaxedKeyMatch =
      keyMatch ||
      (benchmarkCase.comparisonProfile.allowEnharmonicKeyMatch &&
          _keysAreEnharmonicallyEquivalent(
            benchmarkCase.expectedKey,
            analysis.primaryKey.keyCenter.tonicName,
          ));
  if (!keyMatch) {
    failures.add(
      'expected key ${benchmarkCase.expectedKey}, got '
      '${analysis.primaryKey.keyCenter.tonicName}',
    );
  }

  final modeMatch =
      analysis.primaryKey.keyCenter.mode == benchmarkCase.expectedMode;
  if (!modeMatch) {
    failures.add(
      'expected mode ${benchmarkCase.expectedMode.name}, got '
      '${analysis.primaryKey.keyCenter.mode.name}',
    );
  }

  final segmentExpectations = _effectiveSegmentExpectations(benchmarkCase);
  final segmentComparisons = [
    for (final expectation in segmentExpectations)
      _compareSegment(
        expectation: expectation,
        analysis: analysis,
        fallbackProfile: benchmarkCase.comparisonProfile,
      ),
  ];
  final matchedSurfaceRomanTokens = segmentComparisons
      .where(
        (comparison) =>
            comparison.expectedSurfaceRoman != null &&
            comparison.surfaceRomanExactMatch,
      )
      .length;
  final totalSurfaceRomanTokens = segmentComparisons
      .where((comparison) => comparison.expectedSurfaceRoman != null)
      .length;
  final matchedCanonicalRomanTokens = segmentComparisons
      .where(
        (comparison) =>
            comparison.expectedRoman != null && comparison.exactRomanMatch,
      )
      .length;
  final totalCanonicalRomanTokens = segmentComparisons
      .where((comparison) => comparison.expectedRoman != null)
      .length;
  final matchedRelaxedRomanTokens = segmentComparisons
      .where(
        (comparison) =>
            comparison.expectedRoman != null && comparison.relaxedRomanMatch,
      )
      .length;
  final totalRelaxedRomanTokens = totalCanonicalRomanTokens;
  final matchedFunctionTokens = segmentComparisons
      .where(
        (comparison) =>
            comparison.expectedFunction != null && comparison.functionMatch,
      )
      .length;
  final totalFunctionTokens = segmentComparisons
      .where((comparison) => comparison.expectedFunction != null)
      .length;

  for (final comparison in segmentComparisons.where(
    (comparison) =>
        comparison.expectedRoman != null && !comparison.exactRomanMatch,
  )) {
    failures.add(
      'segment[${comparison.index}] expected ${comparison.expectedRoman}, got '
      '${comparison.actualRoman ?? '<missing>'}',
    );
  }

  var matchedTags = 0;
  for (final requiredTag in benchmarkCase.requiredTags) {
    if (analysis.tags.contains(requiredTag)) {
      matchedTags += 1;
      continue;
    }
    failures.add('missing tag ${requiredTag.name}');
  }

  var matchedRemarks = 0;
  for (final requirement in benchmarkCase.requiredRemarks) {
    final index = requirement.$1;
    final kind = requirement.$2;
    final satisfied =
        index < analysis.chordAnalyses.length &&
        analysis.chordAnalyses[index].remarks.any(
          (remark) => remark.kind == kind,
        );
    if (satisfied) {
      matchedRemarks += 1;
      continue;
    }
    failures.add('missing remark ${kind.name} at chord[$index]');
  }

  var matchedEvidence = 0;
  for (final requirement in benchmarkCase.requiredEvidence) {
    final index = requirement.$1;
    final kind = requirement.$2;
    final satisfied =
        index < analysis.chordAnalyses.length &&
        analysis.chordAnalyses[index].evidence.any(
          (evidence) => evidence.kind == kind,
        );
    if (satisfied) {
      matchedEvidence += 1;
      continue;
    }
    failures.add('missing evidence ${kind.name} at chord[$index]');
  }

  final partialFailureMatch =
      analysis.parseResult.hasPartialFailure ==
      benchmarkCase.expectedPartialFailure;
  if (!partialFailureMatch) {
    failures.add(
      'expected partialFailure=${benchmarkCase.expectedPartialFailure}, got '
      '${analysis.parseResult.hasPartialFailure}',
    );
  }
  final actualNoChordEventCount = _countNoChordParseIssues(analysis);
  final noChordSensitiveCase = benchmarkCase.expectedNoChordEventCount > 0;
  final noChordEventMatch =
      actualNoChordEventCount == benchmarkCase.expectedNoChordEventCount;
  final matchedNoChordEvents =
      actualNoChordEventCount < benchmarkCase.expectedNoChordEventCount
      ? actualNoChordEventCount
      : benchmarkCase.expectedNoChordEventCount;
  if (noChordSensitiveCase && !noChordEventMatch) {
    failures.add(
      'expected noChordEvents=${benchmarkCase.expectedNoChordEventCount}, got '
      '$actualNoChordEventCount',
    );
  }

  final modulationDiagnostics = _buildModulationDiagnostics(
    benchmarkCase: benchmarkCase,
    analysis: analysis,
  );
  if (modulationDiagnostics.expectedTags.isNotEmpty &&
      !modulationDiagnostics.matched) {
    failures.add(
      'expected modulation diagnostics ${modulationDiagnostics.expectedTags.join(', ')}, '
      'got ${modulationDiagnostics.actualTags.join(', ')}',
    );
  }

  final failureCategories = failures.isEmpty
      ? const <_FailureTaxonomy>[]
      : _classifyFailureCategories(
          benchmarkCase: benchmarkCase,
          failures: failures,
          segmentComparisons: segmentComparisons,
          modulationDiagnostics: modulationDiagnostics,
          analysis: analysis,
          keyMatch: keyMatch,
          relaxedKeyMatch: relaxedKeyMatch,
        );
  final likelyRootCauses = [
    for (final category in failureCategories) category.rootCause,
  ];
  final keyDiagnostics = _buildKeyDiagnostics(
    benchmarkCase: benchmarkCase,
    analysis: analysis,
  );

  return _CaseResult(
    benchmarkCase: benchmarkCase,
    elapsedMicroseconds: stopwatch.elapsedMicroseconds,
    keyMatch: keyMatch,
    relaxedKeyMatch: relaxedKeyMatch,
    modeMatch: modeMatch,
    partialFailureMatch: partialFailureMatch,
    noChordEventMatch: noChordEventMatch,
    noChordSensitiveCase: noChordSensitiveCase,
    exactPass: failures.isEmpty,
    matchedNoChordEvents: matchedNoChordEvents,
    totalNoChordEvents: benchmarkCase.expectedNoChordEventCount,
    actualNoChordEventCount: actualNoChordEventCount,
    matchedSurfaceRomanTokens: matchedSurfaceRomanTokens,
    totalSurfaceRomanTokens: totalSurfaceRomanTokens,
    matchedCanonicalRomanTokens: matchedCanonicalRomanTokens,
    totalCanonicalRomanTokens: totalCanonicalRomanTokens,
    matchedRelaxedRomanTokens: matchedRelaxedRomanTokens,
    totalRelaxedRomanTokens: totalRelaxedRomanTokens,
    matchedFunctionTokens: matchedFunctionTokens,
    totalFunctionTokens: totalFunctionTokens,
    matchedTags: matchedTags,
    totalTags: benchmarkCase.requiredTags.length,
    matchedRemarks: matchedRemarks,
    totalRemarks: benchmarkCase.requiredRemarks.length,
    matchedEvidence: matchedEvidence,
    totalEvidence: benchmarkCase.requiredEvidence.length,
    modulationDiagnosticMatch: modulationDiagnostics.matched,
    modulationSensitiveCase: modulationDiagnostics.evaluated,
    actualKey: analysis.primaryKey.keyCenter.tonicName,
    actualMode: analysis.primaryKey.keyCenter.mode.name,
    actualRomans: actualRomans,
    actualTags: actualTags,
    actualPartialFailure: analysis.parseResult.hasPartialFailure,
    segmentComparisons: segmentComparisons,
    modulationDiagnostics: modulationDiagnostics,
    keyDiagnostics: keyDiagnostics,
    failureCategories: failureCategories,
    likelyRootCauses: likelyRootCauses,
    failures: failures,
  );
}

_AggregateMetrics _aggregateResults(Iterable<_CaseResult> results) {
  final items = results.toList(growable: false);
  final totalLatencyMicroseconds = items.fold<int>(
    0,
    (sum, result) => sum + result.elapsedMicroseconds,
  );
  return _AggregateMetrics(
    caseCount: items.length,
    exactProgressionPasses: items.where((result) => result.exactPass).length,
    keyMatches: items.where((result) => result.keyMatch).length,
    relaxedKeyMatches: items.where((result) => result.relaxedKeyMatch).length,
    modeMatches: items.where((result) => result.modeMatch).length,
    partialFailureMatches: items
        .where((result) => result.partialFailureMatch)
        .length,
    noChordEventMatches: items
        .where(
          (result) => result.noChordSensitiveCase && result.noChordEventMatch,
        )
        .length,
    totalNoChordSensitiveCases: items
        .where((result) => result.noChordSensitiveCase)
        .length,
    matchedNoChordEvents: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedNoChordEvents,
    ),
    totalNoChordEvents: items.fold<int>(
      0,
      (sum, result) => sum + result.totalNoChordEvents,
    ),
    matchedSurfaceRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedSurfaceRomanTokens,
    ),
    totalSurfaceRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.totalSurfaceRomanTokens,
    ),
    matchedCanonicalRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedCanonicalRomanTokens,
    ),
    totalCanonicalRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.totalCanonicalRomanTokens,
    ),
    matchedRelaxedRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedRelaxedRomanTokens,
    ),
    totalRelaxedRomanTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.totalRelaxedRomanTokens,
    ),
    matchedFunctionTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedFunctionTokens,
    ),
    totalFunctionTokens: items.fold<int>(
      0,
      (sum, result) => sum + result.totalFunctionTokens,
    ),
    matchedTags: items.fold<int>(0, (sum, result) => sum + result.matchedTags),
    totalTags: items.fold<int>(0, (sum, result) => sum + result.totalTags),
    matchedRemarks: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedRemarks,
    ),
    totalRemarks: items.fold<int>(
      0,
      (sum, result) => sum + result.totalRemarks,
    ),
    matchedEvidence: items.fold<int>(
      0,
      (sum, result) => sum + result.matchedEvidence,
    ),
    totalEvidence: items.fold<int>(
      0,
      (sum, result) => sum + result.totalEvidence,
    ),
    modulationDiagnosticMatches: items
        .where(
          (result) =>
              result.modulationSensitiveCase &&
              result.modulationDiagnosticMatch,
        )
        .length,
    totalModulationSensitiveCases: items
        .where((result) => result.modulationSensitiveCase)
        .length,
    meanLatencyMilliseconds: items.isEmpty
        ? 0
        : totalLatencyMicroseconds / items.length / 1000.0,
  );
}

Map<String, _AggregateMetrics> _aggregateBy(
  List<_CaseResult> results,
  String Function(_CaseResult result) keySelector,
) {
  final grouped = <String, List<_CaseResult>>{};
  for (final result in results) {
    grouped.putIfAbsent(keySelector(result), () => <_CaseResult>[]).add(result);
  }
  final orderedKeys = grouped.keys.toList()..sort();
  return {for (final key in orderedKeys) key: _aggregateResults(grouped[key]!)};
}

_PerformanceMetrics _measureMixedCorpusPerformance({
  required ProgressionAnalyzer analyzer,
  required List<_BenchmarkCase> benchmarkCases,
  required int rounds,
  required int warmupRounds,
}) {
  for (var round = 0; round < warmupRounds; round += 1) {
    for (final benchmarkCase in benchmarkCases) {
      analyzer.analyze(benchmarkCase.progression);
    }
  }

  final samples = <int>[];
  var chordCount = 0;
  final total = Stopwatch()..start();
  for (var round = 0; round < rounds; round += 1) {
    for (final benchmarkCase in benchmarkCases) {
      final stopwatch = Stopwatch()..start();
      final analysis = analyzer.analyze(benchmarkCase.progression);
      stopwatch.stop();
      samples.add(stopwatch.elapsedMicroseconds);
      chordCount += analysis.chordAnalyses.length;
    }
  }
  total.stop();

  return _buildPerformanceMetrics(
    label: 'mixed-corpus',
    samples: samples,
    runs: rounds,
    warmupRuns: warmupRounds,
    analysisCount: samples.length,
    chordCount: chordCount,
    totalElapsedMicroseconds: total.elapsedMicroseconds,
  );
}

_LongSequenceInput _buildLongSequenceInput({
  required List<_BenchmarkCase> benchmarkCases,
  required int chordTarget,
}) {
  final eligible = benchmarkCases
      .where((benchmarkCase) => !benchmarkCase.expectedPartialFailure)
      .toList(growable: false);
  final progressionParts = <String>[];
  var sourceCaseCount = 0;
  var chordCount = 0;
  var index = 0;
  while (chordCount < chordTarget) {
    final benchmarkCase = eligible[index % eligible.length];
    progressionParts.add(benchmarkCase.progression);
    chordCount += _estimateChordCount(benchmarkCase.progression);
    sourceCaseCount += 1;
    index += 1;
  }

  return _LongSequenceInput(
    progression: progressionParts.join(' | '),
    chordCount: chordCount,
    sourceCaseCount: sourceCaseCount,
  );
}

_PerformanceMetrics _measureLongSequencePerformance({
  required ProgressionAnalyzer analyzer,
  required _LongSequenceInput input,
  required int runs,
  required int warmupRounds,
}) {
  for (var warmup = 0; warmup < warmupRounds; warmup += 1) {
    analyzer.analyze(input.progression);
  }

  final samples = <int>[];
  var chordCount = 0;
  final total = Stopwatch()..start();
  for (var run = 0; run < runs; run += 1) {
    final stopwatch = Stopwatch()..start();
    final analysis = analyzer.analyze(input.progression);
    stopwatch.stop();
    samples.add(stopwatch.elapsedMicroseconds);
    chordCount += analysis.chordAnalyses.length;
  }
  total.stop();

  return _buildPerformanceMetrics(
    label: 'long-sequence',
    samples: samples,
    runs: runs,
    warmupRuns: warmupRounds,
    analysisCount: samples.length,
    chordCount: chordCount,
    totalElapsedMicroseconds: total.elapsedMicroseconds,
    inputChordCount: input.chordCount,
    inputLengthCharacters: input.progression.length,
  );
}

_PerformanceMetrics _buildPerformanceMetrics({
  required String label,
  required List<int> samples,
  required int runs,
  required int warmupRuns,
  required int analysisCount,
  required int chordCount,
  required int totalElapsedMicroseconds,
  int? inputChordCount,
  int? inputLengthCharacters,
}) {
  final sorted = [...samples]..sort();
  final minMicroseconds = sorted.isEmpty ? 0 : sorted.first;
  final maxMicroseconds = sorted.isEmpty ? 0 : sorted.last;
  final meanMicroseconds = sorted.isEmpty
      ? 0.0
      : sorted.reduce((left, right) => left + right) / sorted.length;
  final analysesPerSecond = totalElapsedMicroseconds == 0
      ? 0.0
      : analysisCount * 1000000 / totalElapsedMicroseconds;
  final chordsPerSecond = totalElapsedMicroseconds == 0
      ? 0.0
      : chordCount * 1000000 / totalElapsedMicroseconds;

  return _PerformanceMetrics(
    label: label,
    runs: runs,
    warmupRuns: warmupRuns,
    analysisCount: analysisCount,
    chordCount: chordCount,
    totalElapsedMicroseconds: totalElapsedMicroseconds,
    minMicroseconds: minMicroseconds,
    maxMicroseconds: maxMicroseconds,
    meanMicroseconds: meanMicroseconds,
    p50Microseconds: _percentile(sorted, 0.50),
    p95Microseconds: _percentile(sorted, 0.95),
    p99Microseconds: _percentile(sorted, 0.99),
    analysesPerSecond: analysesPerSecond,
    chordsPerSecond: chordsPerSecond,
    inputChordCount: inputChordCount,
    inputLengthCharacters: inputLengthCharacters,
  );
}

List<_BenchmarkCase> _buildBenchmarkCases() {
  final majorCenters = [
    for (final tonic in const [
      'C',
      'G',
      'D',
      'F',
      'A#/Bb',
      'D#/Eb',
      'A',
      'C#/Db',
    ])
      KeyCenter(tonicName: tonic, mode: KeyMode.major),
  ];
  final minorCenters = [
    for (final tonic in const [
      'A',
      'E',
      'D',
      'G',
      'C',
      'F#/Gb',
      'A#/Bb',
      'C#/Db',
    ])
      KeyCenter(tonicName: tonic, mode: KeyMode.minor),
  ];

  String defaultSuffixForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.majorTriad => '',
      ChordQuality.minorTriad => 'm',
      ChordQuality.dominant7 => '7',
      ChordQuality.major7 => 'maj7',
      ChordQuality.minor7 => 'm7',
      ChordQuality.minorMajor7 => 'mMaj7',
      ChordQuality.halfDiminished7 => 'm7b5',
      ChordQuality.diminishedTriad => 'dim',
      ChordQuality.diminished7 => 'dim7',
      ChordQuality.augmentedTriad => 'aug',
      ChordQuality.six => '6',
      ChordQuality.minor6 => 'm6',
      ChordQuality.major69 => '6/9',
      ChordQuality.dominant7Alt => '7alt',
      ChordQuality.dominant7Sharp11 => '7(#11)',
      ChordQuality.dominant13sus4 => '13sus4',
      ChordQuality.dominant7sus4 => '7sus4',
    };
  }

  String chordSymbolForRoman(
    KeyCenter center,
    RomanNumeralId roman, {
    String? suffixOverride,
    String? bass,
  }) {
    final root = MusicTheory.resolveChordRootForCenter(center, roman);
    final spec = MusicTheory.specFor(roman);
    final suffix = suffixOverride ?? defaultSuffixForQuality(spec.quality);
    return '$root$suffix${bass == null ? '' : '/$bass'}';
  }

  String firstInversionBass(KeyCenter center, RomanNumeralId roman) {
    final root = MusicTheory.resolveChordRootForCenter(center, roman);
    final rootSemitone = MusicTheory.noteToSemitone[root]!;
    final quality = MusicTheory.specFor(roman).quality;
    final thirdOffset = switch (quality) {
      ChordQuality.minorTriad ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.minor6 ||
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 => 3,
      _ => 4,
    };
    return MusicTheory.spellPitch(
      rootSemitone + thirdOffset,
      preferFlat: center.prefersFlatSpelling || root.contains('b'),
    );
  }

  String genericTritoneToTonic(KeyCenter center) {
    final tonic = center.tonicSemitone!;
    final root = MusicTheory.spellPitch(tonic + 1, preferFlat: true);
    return '${root}7(#11)';
  }

  final benchmarkCases = <_BenchmarkCase>[
    for (final center in majorCenters)
      _BenchmarkCase(
        id: 'gold-jazz-${_slug(center.tonicName)}-ii-v-i',
        description: '${center.tonicName} major ii-V-I',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '13',
          ),
          chordSymbolForRoman(
            center,
            RomanNumeralId.iMaj7,
            suffixOverride: 'maj9',
          ),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.jazz,
        difficulty: _DifficultyBucket.easy,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        expectedRomans: const ['IIm7', 'V13', 'Imaj9'],
        requiredTags: const [ProgressionTagId.iiVI],
        requiredEvidence: const [(1, ProgressionEvidenceKind.extensionColor)],
      ),
    for (final center in majorCenters)
      _BenchmarkCase(
        id: 'gold-jazz-${_slug(center.tonicName)}-turnaround',
        description: '${center.tonicName} turnaround with V7/II',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
          chordSymbolForRoman(
            center,
            RomanNumeralId.secondaryOfII,
            suffixOverride: '7(b9)',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
        ].join(' | '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.jazz,
        difficulty: _DifficultyBucket.medium,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.turnaround],
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'gold-jazz-${_slug(center.tonicName)}-tritone',
        description: '${center.tonicName} tritone substitute into tonic',
        progression: [
          genericTritoneToTonic(center),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.jazz,
        difficulty: _DifficultyBucket.hard,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (0, ProgressionRemarkKind.possibleTritoneSubstitute),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.resolution)],
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'gold-pop-${_slug(center.tonicName)}-borrowed-plagal',
        description: '${center.tonicName} borrowed plagal color',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.borrowedIvMin7),
          chordSymbolForRoman(center, RomanNumeralId.borrowedFlatVII7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.pop,
        difficulty: _DifficultyBucket.medium,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.plagalColor],
        requiredRemarks: const [
          (0, ProgressionRemarkKind.possibleModalInterchange),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.borrowedColor)],
      ),
    for (final center in minorCenters)
      _BenchmarkCase(
        id: 'gold-jazz-${_slug(center.tonicName)}-minor-ii-v-i',
        description: '${center.tonicName} minor ii-V-i',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iiHalfDiminishedMinor),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '7alt',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iMin6),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.jazz,
        difficulty: _DifficultyBucket.medium,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.minor,
        requiredTags: const [ProgressionTagId.iiVI],
        requiredEvidence: const [
          (1, ProgressionEvidenceKind.alteredDominantColor),
        ],
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'gold-pop-${_slug(center.tonicName)}-slash-turnaround',
        description: '${center.tonicName} slash-bass turnaround',
        progression: [
          chordSymbolForRoman(
            center,
            RomanNumeralId.iMaj7,
            bass: firstInversionBass(center, RomanNumeralId.iMaj7),
          ),
          chordSymbolForRoman(center, RomanNumeralId.secondaryOfII),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.pop,
        difficulty: _DifficultyBucket.hard,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.slashBass)],
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'gold-jazz-${_slug(center.tonicName)}-v-of-v',
        description: '${center.tonicName} V of V cadence',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
          chordSymbolForRoman(center, RomanNumeralId.secondaryOfV),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '13',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        track: _BenchmarkTrack.goldCore,
        genre: _BenchmarkGenre.jazz,
        difficulty: _DifficultyBucket.medium,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
        requiredTags: const [ProgressionTagId.dominantResolution],
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'ambiguous-mixed-${_slug(center.tonicName)}-partial-parse',
        description: '${center.tonicName} partial parse stays conservative',
        progression:
            '${chordSymbolForRoman(center, RomanNumeralId.iMaj7)} H7 '
            '${chordSymbolForRoman(center, RomanNumeralId.vDom7)} '
            '${chordSymbolForRoman(center, RomanNumeralId.iMaj7)}',
        track: _BenchmarkTrack.ambiguityValidation,
        genre: _BenchmarkGenre.mixed,
        difficulty: _DifficultyBucket.ambiguous,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        expectedPartialFailure: true,
      ),
    for (final center in majorCenters.take(6))
      _BenchmarkCase(
        id: 'ambiguous-pop-${_slug(center.tonicName)}-opening-on-iv',
        description:
            '${center.tonicName} opening on IV still surfaces ambiguity',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.ivMaj7),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        track: _BenchmarkTrack.ambiguityValidation,
        genre: _BenchmarkGenre.pop,
        difficulty: _DifficultyBucket.ambiguous,
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.iiVI],
      ),
  ];

  benchmarkCases.addAll(_specialBenchmarkCases());
  return benchmarkCases;
}

List<_BenchmarkCase> _specialBenchmarkCases() {
  return const [
    _BenchmarkCase(
      id: 'gold-jazz-c-major-backdoor',
      description: 'backdoor and subdominant minor color',
      progression: 'Fm7 Bb7 Cmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.jazz,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      requiredTags: [ProgressionTagId.backdoorChain],
      failureHints: [
        _FailureTaxonomy.borrowedChordConfusion,
        _FailureTaxonomy.modalMixtureConfusion,
      ],
      requiredRemarks: [
        (0, ProgressionRemarkKind.subdominantMinor),
        (1, ProgressionRemarkKind.backdoorDominant),
      ],
    ),
    _BenchmarkCase(
      id: 'gold-classical-c-common-tone-dim',
      description: 'common-tone diminished color',
      progression: 'C#dim7 Cmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.classical,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      failureHints: [_FailureTaxonomy.ambiguousKeyCenter],
      requiredTags: [ProgressionTagId.commonToneMotion],
      requiredRemarks: [(0, ProgressionRemarkKind.commonToneDiminished)],
    ),
    _BenchmarkCase(
      id: 'gold-classical-c-deceptive',
      description: 'deceptive cadence stays in home key',
      progression: 'Cmaj7 G7 Am7 | Dm7 G7 Cmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.classical,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      failureHints: [_FailureTaxonomy.modulationVsTonicization],
      requiredTags: [ProgressionTagId.deceptiveCadence],
      requiredRemarks: [(2, ProgressionRemarkKind.deceptiveCadence)],
    ),
    _BenchmarkCase(
      id: 'gold-pop-c-triads',
      description:
          'plain major triads keep tonic-subdominant-dominant functions',
      progression: 'C F G C',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.pop,
      difficulty: _DifficultyBucket.easy,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      expectedRomans: ['I', 'IV', 'V', 'I'],
    ),
    _BenchmarkCase(
      id: 'gold-classical-a-minor-triads',
      description: 'plain minor triads stay conservative in minor',
      progression: 'Am Dm E Am',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.classical,
      difficulty: _DifficultyBucket.easy,
      expectedKey: 'A',
      expectedMode: KeyMode.minor,
      expectedRomans: ['Im', 'IVm', 'V', 'Im'],
    ),
    _BenchmarkCase(
      id: 'gold-jazz-d-minor-secondary',
      description: 'mode-aware secondary dominant target in minor',
      progression: 'B7 Em7b5 A7 Dm',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.jazz,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'D',
      expectedMode: KeyMode.minor,
      failureHints: [_FailureTaxonomy.secondaryDominantNotationGap],
      expectedRomans: ['V7/II'],
      requiredRemarks: [(0, ProgressionRemarkKind.possibleSecondaryDominant)],
    ),
    _BenchmarkCase(
      id: 'gold-pop-lowercase-slash-tokenization',
      description: 'lowercase roots and slash-aware tokenization',
      progression: 'cmaj7 am7 d7 gmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.pop,
      difficulty: _DifficultyBucket.medium,
      expectedKey: 'G',
      expectedMode: KeyMode.major,
    ),
    _BenchmarkCase(
      id: 'gold-jazz-altered-dominant',
      description: 'altered tensions stay attached to a dominant reading',
      progression: 'C7(b9, #11) Fmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.jazz,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'F',
      expectedMode: KeyMode.major,
      expectedRomans: ['V7(b9,#11)'],
      requiredEvidence: [(0, ProgressionEvidenceKind.alteredDominantColor)],
    ),
    _BenchmarkCase(
      id: 'gold-jazz-c-minor-ii-v-i',
      description: 'minor ii-V-i with tonic minor-major seventh display',
      progression: 'Dm7b5 G7 CmMaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.jazz,
      difficulty: _DifficultyBucket.medium,
      expectedKey: 'C',
      expectedMode: KeyMode.minor,
      expectedRomans: ['IIm7b5', 'V7', 'ImMaj7'],
    ),
    _BenchmarkCase(
      id: 'ambiguous-jazz-db7-tritone',
      description: 'possible tritone substitute reading remains ambiguous',
      progression: 'Db7 Cmaj7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.jazz,
      difficulty: _DifficultyBucket.ambiguous,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      failureHints: [
        _FailureTaxonomy.ambiguousKeyCenter,
        _FailureTaxonomy.enharmonicEquivalence,
      ],
      expectedRomans: ['subV7/I'],
      requiredRemarks: [(0, ProgressionRemarkKind.possibleTritoneSubstitute)],
    ),
    _BenchmarkCase(
      id: 'ambiguous-c-partial-parse',
      description: 'partial parses remain conservative and keep ambiguity',
      progression: 'Cmaj7 H7 G7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.ambiguous,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      expectedPartialFailure: true,
    ),
    _BenchmarkCase(
      id: 'ambiguous-a-minor-placeholder',
      description: 'placeholder chords infer a contextual fill',
      progression: 'Dm7 - G7 - ? - Am7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.ambiguous,
      expectedKey: 'A',
      expectedMode: KeyMode.minor,
      expectedPartialFailure: false,
    ),
    _BenchmarkCase(
      id: 'gold-classical-c-real-modulation',
      description: 'real modulation stays distinct from tonicization',
      progression:
          'Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7',
      track: _BenchmarkTrack.goldCore,
      genre: _BenchmarkGenre.classical,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      failureHints: [
        _FailureTaxonomy.modulationVsTonicization,
        _FailureTaxonomy.ambiguousKeyCenter,
        _FailureTaxonomy.endingBias,
      ],
      requiredTags: [ProgressionTagId.realModulation],
    ),
    _BenchmarkCase(
      id: 'dirty-delta-mixed-g-major',
      description: 'dirty input with delta notation remains analyzable',
      progression: 'C△7 D7 Gmaj9',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.medium,
      expectedKey: 'G',
      expectedMode: KeyMode.major,
      benchmarkClass: _BenchmarkClass.dirtyInput,
      sourceId: 'dirty_input_regression',
      sourceLabel: 'dirty_input_regression',
      expectedRomans: ['IVmaj7', 'V7', 'Imaj9'],
      notes: ['delta notation', 'lead-sheet shorthand'],
    ),
    _BenchmarkCase(
      id: 'dirty-minus-flat-ii-v-i',
      description: 'dirty input with minus notation in flat-key ii-V-I',
      progression: 'Bb-7 Eb7 Abmaj7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.medium,
      expectedKey: 'G#/Ab',
      expectedMode: KeyMode.major,
      benchmarkClass: _BenchmarkClass.dirtyInput,
      sourceId: 'dirty_input_regression',
      sourceLabel: 'dirty_input_regression',
      expectedRomans: ['IIm7', 'V7', 'Imaj7'],
      notes: ['minus notation', 'flat-key lead-sheet spelling'],
    ),
    _BenchmarkCase(
      id: 'dirty-nc-partial-parse',
      description: 'dirty input with N.C. keeps contextual harmonic reading',
      progression: 'N.C. Dm7 G7 Cmaj7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.ambiguous,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      benchmarkClass: _BenchmarkClass.dirtyInput,
      sourceId: 'dirty_input_regression',
      sourceLabel: 'dirty_input_regression',
      expectedPartialFailure: true,
      expectedRomans: ['IIm7', 'V7', 'Imaj7'],
      notes: ['N.C. noise token', 'partial parse expected'],
    ),
    _BenchmarkCase(
      id: 'dirty-repeat-marker-partial-parse',
      description:
          'dirty input with section and repeat markers keeps key reading',
      progression: '[A] Cmaj7 |: Dm7 G7 :| Cmaj7',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.ambiguous,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      benchmarkClass: _BenchmarkClass.dirtyInput,
      sourceId: 'dirty_input_regression',
      sourceLabel: 'dirty_input_regression',
      expectedPartialFailure: true,
      expectedRomans: ['Imaj7', 'IIm7', 'V7', 'Imaj7'],
      notes: ['section marker', 'repeat marker', 'partial parse expected'],
    ),
    _BenchmarkCase(
      id: 'dirty-slash-heavy-real-book',
      description:
          'dirty real-book style slash-heavy input preserves slash evidence',
      progression: 'C/E A7(b9) Dm7 G7/B',
      track: _BenchmarkTrack.ambiguityValidation,
      genre: _BenchmarkGenre.mixed,
      difficulty: _DifficultyBucket.hard,
      expectedKey: 'C',
      expectedMode: KeyMode.major,
      benchmarkClass: _BenchmarkClass.dirtyInput,
      sourceId: 'dirty_input_regression',
      sourceLabel: 'dirty_input_regression',
      comparisonProfile: _ComparisonProfile(allowSlashBassTolerance: true),
      segmentExpectations: [
        _SegmentExpectation(
          index: 0,
          expectedResolvedSymbol: 'C/E',
          expectedFunction: 'tonic',
          comparisonProfile: _ComparisonProfile(allowSlashBassTolerance: true),
        ),
        _SegmentExpectation(
          index: 3,
          expectedResolvedSymbol: 'G7/B',
          expectedFunction: 'dominant',
          comparisonProfile: _ComparisonProfile(allowSlashBassTolerance: true),
        ),
      ],
      requiredEvidence: [
        (0, ProgressionEvidenceKind.slashBass),
        (3, ProgressionEvidenceKind.slashBass),
      ],
      notes: ['slash-heavy input', 'real-book style'],
    ),
  ];
}

String _aggregateTable(String title, Map<String, _AggregateMetrics> rows) {
  final buffer = StringBuffer();
  buffer.writeln('### $title');
  buffer.writeln('');
  buffer.writeln(
    '| Bucket | Cases | Exact Pass | Key | Mode | Roman Canonical | Tags | Remarks | Evidence | Parse Expectation | N.C. Cases | Mean Latency |',
  );
  buffer.writeln(
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
  );
  for (final entry in rows.entries) {
    final metrics = entry.value;
    buffer.writeln(
      '| ${entry.key} | ${metrics.caseCount} | ${_formatPercent(metrics.exactProgressionPassRate)} | '
      '${_formatPercent(metrics.keyAccuracy)} | ${_formatPercent(metrics.modeAccuracy)} | '
      '${_formatConditionalPercent(metrics.matchedCanonicalRomanTokens, metrics.totalCanonicalRomanTokens)} | '
      '${_formatConditionalPercent(metrics.matchedTags, metrics.totalTags)} | '
      '${_formatConditionalPercent(metrics.matchedRemarks, metrics.totalRemarks)} | '
      '${_formatConditionalPercent(metrics.matchedEvidence, metrics.totalEvidence)} | '
      '${_formatPercent(metrics.partialFailureExpectationAccuracy)} | '
      '${_formatConditionalPercent(metrics.noChordEventMatches, metrics.totalNoChordSensitiveCases)} | '
      '${metrics.meanLatencyMilliseconds.toStringAsFixed(3)} ms |',
    );
  }
  return buffer.toString().trimRight();
}

String _coverageTable(String title, Map<String, _CoverageBreakdown> rows) {
  final buffer = StringBuffer();
  buffer.writeln('### $title');
  buffer.writeln('');
  buffer.writeln(
    '| Bucket | Raw Records | Loaded | Raw Segments | Kept | Raw Harmonic | Kept Harmonic | Raw Non-Harmonic | Kept Non-Harmonic | Record Coverage | Segment Coverage | Harmonic Coverage |',
  );
  buffer.writeln(
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
  );
  for (final entry in rows.entries) {
    final coverage = entry.value;
    buffer.writeln(
      '| ${entry.key} | ${coverage.rawRecordCount} | ${coverage.loadedRecordCount} | '
      '${coverage.rawSegmentCount} | ${coverage.keptSegmentCount} | '
      '${coverage.rawHarmonicSegmentCount} | ${coverage.keptHarmonicSegmentCount} | '
      '${coverage.rawNonHarmonicSegmentCount} | ${coverage.keptNonHarmonicSegmentCount} | '
      '${_formatOptionalPercent(coverage.recordCoverageRatio)} | '
      '${_formatOptionalPercent(coverage.segmentCoverageRatio)} | '
      '${_formatOptionalPercent(coverage.harmonicCoverageRatio)} |',
    );
  }
  return buffer.toString().trimRight();
}

String _reasonSummary(Map<String, int> counts) {
  if (counts.isEmpty) {
    return 'none';
  }
  return counts.entries
      .map((entry) => '${entry.key}=${entry.value}')
      .join(', ');
}

String _performanceSummary(_PerformanceMetrics metrics) {
  final buffer = StringBuffer();
  buffer.writeln('### ${metrics.label}');
  buffer.writeln('');
  buffer.writeln('- Analyses: ${metrics.analysisCount}');
  buffer.writeln('- Chords processed: ${metrics.chordCount}');
  buffer.writeln(
    '- Throughput: ${metrics.analysesPerSecond.toStringAsFixed(1)} analyses/s, '
    '${metrics.chordsPerSecond.toStringAsFixed(1)} chords/s',
  );
  buffer.writeln(
    '- Latency: mean ${metrics.meanMilliseconds.toStringAsFixed(3)} ms, '
    'p50 ${metrics.p50Milliseconds.toStringAsFixed(3)} ms, '
    'p95 ${metrics.p95Milliseconds.toStringAsFixed(3)} ms, '
    'p99 ${metrics.p99Milliseconds.toStringAsFixed(3)} ms',
  );
  buffer.writeln(
    '- Range: ${(metrics.minMicroseconds / 1000.0).toStringAsFixed(3)} ms to '
    '${(metrics.maxMicroseconds / 1000.0).toStringAsFixed(3)} ms',
  );
  if (metrics.inputChordCount != null) {
    buffer.writeln('- Input size: ${metrics.inputChordCount} chords');
  }
  if (metrics.inputLengthCharacters != null) {
    buffer.writeln(
      '- Input length: ${metrics.inputLengthCharacters} characters',
    );
  }
  return buffer.toString().trimRight();
}

String _slug(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

String _formatPercent(double value) => '${(value * 100).toStringAsFixed(1)}%';

String _formatOptionalPercent(double? value) {
  if (value == null) {
    return 'n/a';
  }
  return _formatPercent(value);
}

String _formatConditionalPercent(int numerator, int denominator) {
  if (denominator == 0) {
    return 'n/a';
  }
  return _formatPercent(_safeDivide(numerator, denominator));
}

int _countNoChordParseIssues(ProgressionAnalysis analysis) {
  return analysis.parseResult.issues
      .where((issue) => _isNoChordToken(issue.rawText))
      .length;
}

bool _isNoChordToken(String value) {
  final normalized = value
      .trim()
      .toUpperCase()
      .replaceAll('.', '')
      .replaceAll(RegExp(r'\s+'), '');
  return normalized == 'NC' || normalized == 'N';
}

double _safeDivide(num numerator, num denominator) {
  if (denominator == 0) {
    return 0.0;
  }
  return numerator / denominator;
}

double? _nullableDivide(num numerator, num denominator) {
  if (denominator == 0) {
    return null;
  }
  return numerator / denominator;
}

double _percentile(List<int> sorted, double percentile) {
  if (sorted.isEmpty) {
    return 0.0;
  }
  final index = (sorted.length - 1) * percentile;
  final lower = index.floor();
  final upper = index.ceil();
  if (lower == upper) {
    return sorted[lower].toDouble();
  }
  final fraction = index - lower;
  return sorted[lower] * (1 - fraction) + sorted[upper] * fraction;
}

int _estimateChordCount(String progression) {
  final parts = progression
      .replaceAll('|', ' ')
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty && part != '-')
      .toList(growable: false);
  return parts.length;
}

List<_SegmentExpectation> _effectiveSegmentExpectations(
  _BenchmarkCase benchmarkCase,
) {
  if (benchmarkCase.segmentExpectations.isNotEmpty) {
    return benchmarkCase.segmentExpectations;
  }
  return [
    for (var index = 0; index < benchmarkCase.expectedRomans.length; index += 1)
      _SegmentExpectation(
        index: index,
        expectedCanonicalRoman: benchmarkCase.expectedRomans[index],
        expectedFunction: _expectedFunctionForRoman(
          benchmarkCase.expectedRomans[index],
        ),
        comparisonProfile: benchmarkCase.comparisonProfile,
      ),
  ];
}

_SegmentComparison _compareSegment({
  required _SegmentExpectation expectation,
  required ProgressionAnalysis analysis,
  required _ComparisonProfile fallbackProfile,
}) {
  final profile = expectation.comparisonProfile;
  final actualChord = expectation.analysisIndex < analysis.chordAnalyses.length
      ? analysis.chordAnalyses[expectation.analysisIndex]
      : null;
  final actualRoman = actualChord?.romanNumeral;
  final actualFunction = actualChord == null
      ? null
      : _harmonicFunctionLabel(actualChord.harmonicFunction);
  final actualResolvedSymbol = actualChord?.resolvedSymbol;
  final surfaceRomanExactMatch =
      expectation.expectedSurfaceRoman == null ||
      expectation.expectedSurfaceRoman == actualRoman;
  final canonicalRomanExactMatch =
      expectation.expectedCanonicalRoman == null ||
      expectation.expectedCanonicalRoman == actualRoman;
  final relaxedRomanMatch =
      expectation.expectedCanonicalRoman == null ||
      _matchesRelaxedRoman(
        expectedRoman: expectation.expectedCanonicalRoman!,
        actualRoman: actualRoman,
        expectedFunction: expectation.expectedFunction,
        actualFunction: actualFunction,
        profile: profile,
      );
  final functionMatch =
      expectation.expectedFunction == null ||
      expectation.expectedFunction == actualFunction;
  final resolvedSymbolMatch =
      expectation.expectedResolvedSymbol == null ||
      _resolvedSymbolsMatch(
        expected: expectation.expectedResolvedSymbol!,
        actual: actualResolvedSymbol,
        profile: profile,
        fallbackProfile: fallbackProfile,
      );

  final mismatchReasons = <String>[];
  if (!surfaceRomanExactMatch && expectation.expectedSurfaceRoman != null) {
    mismatchReasons.add('roman_surface_mismatch');
  }
  if (!canonicalRomanExactMatch && expectation.expectedCanonicalRoman != null) {
    mismatchReasons.add('roman_canonical_mismatch');
  }
  if (!relaxedRomanMatch && expectation.expectedCanonicalRoman != null) {
    mismatchReasons.add('roman_relaxed_mismatch');
  }
  if (!functionMatch && expectation.expectedFunction != null) {
    mismatchReasons.add('function_mismatch');
  }
  if (!resolvedSymbolMatch && expectation.expectedResolvedSymbol != null) {
    mismatchReasons.add('resolved_symbol_mismatch');
  }

  return _SegmentComparison(
    index: expectation.index,
    analysisIndex: expectation.analysisIndex,
    expectedSurfaceRoman: expectation.expectedSurfaceRoman,
    expectedCanonicalRoman: expectation.expectedCanonicalRoman,
    actualRoman: actualRoman,
    expectedFunction: expectation.expectedFunction,
    actualFunction: actualFunction,
    expectedResolvedSymbol: expectation.expectedResolvedSymbol,
    actualResolvedSymbol: actualResolvedSymbol,
    surfaceRomanExactMatch: surfaceRomanExactMatch,
    canonicalRomanExactMatch: canonicalRomanExactMatch,
    relaxedRomanMatch: relaxedRomanMatch,
    functionMatch: functionMatch,
    resolvedSymbolMatch: resolvedSymbolMatch,
    mismatchReasons: mismatchReasons,
  );
}

String _expectedFunctionForRoman(String roman) {
  final normalized = _normalizeRomanForRelaxedComparison(roman);
  if (normalized.startsWith('subV') ||
      normalized.startsWith('V') ||
      normalized.startsWith('VII')) {
    return 'dominant';
  }
  if (normalized.startsWith('II') ||
      normalized.startsWith('IV') ||
      normalized.startsWith('bII')) {
    return 'predominant';
  }
  if (normalized.startsWith('I') ||
      normalized.startsWith('III') ||
      normalized.startsWith('VI') ||
      normalized.startsWith('bIII') ||
      normalized.startsWith('bVI')) {
    return 'tonic';
  }
  return 'other';
}

String _harmonicFunctionLabel(ProgressionHarmonicFunction function) {
  return switch (function) {
    ProgressionHarmonicFunction.tonic => 'tonic',
    ProgressionHarmonicFunction.predominant => 'predominant',
    ProgressionHarmonicFunction.dominant => 'dominant',
    ProgressionHarmonicFunction.other => 'other',
  };
}

String _normalizeRomanForRelaxedComparison(String roman) {
  final slashMatch = RegExp(
    r'^(subV|[b#]?[IVX]+)(?:[^/]*)?(?:/(.+))?$',
  ).firstMatch(roman);
  if (slashMatch == null) {
    return roman
        .replaceAll(
          RegExp(r'(maj|min|dim|aug|sus|alt|m|M|[0-9]|[#b(),/+])+'),
          '',
        )
        .toUpperCase();
  }
  final head = slashMatch.group(1)!;
  final applied = slashMatch.group(2);
  return applied == null ? head : '$head/$applied';
}

bool _matchesRelaxedRoman({
  required String expectedRoman,
  required String? actualRoman,
  required String? expectedFunction,
  required String? actualFunction,
  required _ComparisonProfile profile,
}) {
  if (actualRoman == null) {
    return false;
  }
  if (_normalizeRomanForRelaxedComparison(expectedRoman) ==
      _normalizeRomanForRelaxedComparison(actualRoman)) {
    return true;
  }
  if (!profile.allowRomanFunctionRelaxation) {
    return false;
  }
  return expectedFunction != null &&
      actualFunction != null &&
      expectedFunction == actualFunction;
}

bool _resolvedSymbolsMatch({
  required String expected,
  required String? actual,
  required _ComparisonProfile profile,
  required _ComparisonProfile fallbackProfile,
}) {
  if (actual == null) {
    return false;
  }
  if (expected == actual) {
    return true;
  }
  final effectiveProfile = _ComparisonProfile(
    allowEnharmonicKeyMatch:
        profile.allowEnharmonicKeyMatch ||
        fallbackProfile.allowEnharmonicKeyMatch,
    allowSlashBassTolerance:
        profile.allowSlashBassTolerance ||
        fallbackProfile.allowSlashBassTolerance,
    allowRomanFunctionRelaxation:
        profile.allowRomanFunctionRelaxation ||
        fallbackProfile.allowRomanFunctionRelaxation,
  );
  final expectedParts = expected.split('/');
  final actualParts = actual.split('/');
  final expectedRoot = expectedParts.first;
  final actualRoot = actualParts.first;
  final rootMatches =
      expectedRoot == actualRoot ||
      (effectiveProfile.allowEnharmonicKeyMatch &&
          _keysAreEnharmonicallyEquivalent(expectedRoot, actualRoot));
  if (!rootMatches) {
    return false;
  }
  if (!effectiveProfile.allowSlashBassTolerance) {
    return false;
  }
  return true;
}

bool _keysAreEnharmonicallyEquivalent(String expected, String actual) {
  final expectedSemitone = _keySemitoneForComparison(expected);
  final actualSemitone = _keySemitoneForComparison(actual);
  return expectedSemitone != null &&
      actualSemitone != null &&
      expectedSemitone == actualSemitone;
}

int? _keySemitoneForComparison(String value) {
  final directKey = MusicTheory.keyTonicSemitone(value);
  if (directKey != null) {
    return directKey;
  }
  final directNote = MusicTheory.noteToSemitone[value];
  if (directNote != null) {
    return directNote;
  }
  if (!value.contains('/')) {
    return null;
  }
  final candidates = value
      .split('/')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .map(
        (item) =>
            MusicTheory.keyTonicSemitone(item) ??
            MusicTheory.noteToSemitone[item],
      )
      .whereType<int>()
      .toSet();
  if (candidates.isEmpty) {
    return null;
  }
  if (candidates.length == 1) {
    return candidates.first;
  }
  return null;
}

_ModulationDiagnostics _buildModulationDiagnostics({
  required _BenchmarkCase benchmarkCase,
  required ProgressionAnalysis analysis,
}) {
  final expectedTags = [
    for (final tag in benchmarkCase.requiredTags)
      if (tag == ProgressionTagId.realModulation ||
          tag == ProgressionTagId.tonicization)
        tag.name,
  ];
  final actualTags = [
    for (final tag in analysis.tags)
      if (tag == ProgressionTagId.realModulation ||
          tag == ProgressionTagId.tonicization)
        tag.name,
  ];
  final evaluated = expectedTags.isNotEmpty;
  final matched = evaluated && expectedTags.every(actualTags.contains);
  return _ModulationDiagnostics(
    evaluated: evaluated,
    expectedTags: expectedTags,
    actualTags: actualTags,
    primaryKey: analysis.primaryKey.keyCenter.tonicName,
    alternativeKey: analysis.alternativeKey?.keyCenter.tonicName,
    confidence: analysis.confidence,
    ambiguity: analysis.ambiguity,
    matched: matched,
  );
}

_KeyDiagnostics _buildKeyDiagnostics({
  required _BenchmarkCase benchmarkCase,
  required ProgressionAnalysis analysis,
}) {
  final topCandidates = analysis.keyCandidates.take(2).toList(growable: false);
  final expectedIndex = analysis.keyCandidates.indexWhere(
    (candidate) =>
        candidate.keyCenter.tonicName == benchmarkCase.expectedKey &&
        candidate.keyCenter.mode == benchmarkCase.expectedMode,
  );
  final expectedCandidate = expectedIndex == -1
      ? null
      : analysis.keyCandidates[expectedIndex];
  final topCandidate = topCandidates.isEmpty ? null : topCandidates.first;

  final dominantChordCount = analysis.chordAnalyses
      .where(
        (chord) =>
            chord.harmonicFunction == ProgressionHarmonicFunction.dominant,
      )
      .length;
  final overallDominantRatio = analysis.chordAnalyses.isEmpty
      ? 0.0
      : dominantChordCount / analysis.chordAnalyses.length;

  final endingWindow = analysis.chordAnalyses.length <= 4
      ? analysis.chordAnalyses
      : analysis.chordAnalyses.sublist(analysis.chordAnalyses.length - 4);
  final endingDominantCount = endingWindow
      .where(
        (chord) =>
            chord.harmonicFunction == ProgressionHarmonicFunction.dominant,
      )
      .length;
  final endingPredominantCount = endingWindow
      .where(
        (chord) =>
            chord.harmonicFunction == ProgressionHarmonicFunction.predominant,
      )
      .length;
  final endingTonicCount = endingWindow
      .where(
        (chord) => chord.harmonicFunction == ProgressionHarmonicFunction.tonic,
      )
      .length;
  final endingDominantRatio = endingWindow.isEmpty
      ? 0.0
      : endingDominantCount / endingWindow.length;
  var endingCadentialResolutions = 0;
  for (var index = 1; index < endingWindow.length; index += 1) {
    if (endingWindow[index - 1].harmonicFunction ==
            ProgressionHarmonicFunction.dominant &&
        endingWindow[index].harmonicFunction ==
            ProgressionHarmonicFunction.tonic) {
      endingCadentialResolutions += 1;
    }
  }

  final appliedDominantChordCount = analysis.chordAnalyses
      .where(
        (chord) =>
            chord.sourceKind == ChordSourceKind.secondaryDominant ||
            chord.hasRemark(ProgressionRemarkKind.possibleSecondaryDominant),
      )
      .length;
  final appliedDominantRemarkCount = analysis.chordAnalyses.fold<int>(
    0,
    (sum, chord) =>
        sum +
        chord.remarks
            .where(
              (remark) =>
                  remark.kind ==
                  ProgressionRemarkKind.possibleSecondaryDominant,
            )
            .length,
  );
  final tonicizationRemarkCount = analysis.chordAnalyses.fold<int>(
    0,
    (sum, chord) =>
        sum +
        chord.remarks
            .where(
              (remark) => remark.kind == ProgressionRemarkKind.tonicization,
            )
            .length,
  );
  final realModulationRemarkCount = analysis.chordAnalyses.fold<int>(
    0,
    (sum, chord) =>
        sum +
        chord.remarks
            .where(
              (remark) => remark.kind == ProgressionRemarkKind.realModulation,
            )
            .length,
  );
  final topTwoScoreGap = topCandidates.length < 2
      ? null
      : topCandidates[0].score - topCandidates[1].score;
  final expectedKeyGapFromTop =
      topCandidate == null || expectedCandidate == null
      ? null
      : topCandidate.score - expectedCandidate.score;
  final dominantBiasOverhang = endingDominantRatio - overallDominantRatio;
  final selectedKeyIsDominantOfExpected = _isDominantOfExpected(
    expectedKey: benchmarkCase.expectedKey,
    actualKey: analysis.primaryKey.keyCenter.tonicName,
  );
  final summaryParts = <String>[
    if (topCandidates.isNotEmpty)
      'top-2 ${topCandidates.map((candidate) => '${candidate.keyCenter.tonicName} ${candidate.keyCenter.mode.name} ${candidate.score.toStringAsFixed(2)}').join(' vs ')}',
    if (topTwoScoreGap != null) 'gap ${topTwoScoreGap.toStringAsFixed(2)}',
    'ending dominant $endingDominantCount/${endingWindow.length}',
    'dominant overhang ${dominantBiasOverhang.toStringAsFixed(2)}',
    'applied dominants $appliedDominantChordCount',
    'tonicization remarks $tonicizationRemarkCount',
    'real modulation remarks $realModulationRemarkCount',
    if (expectedIndex >= 0) 'expected-rank ${expectedIndex + 1}',
    if (selectedKeyIsDominantOfExpected) 'selected key is dominant-of-expected',
  ];

  return _KeyDiagnostics(
    topCandidates: [
      for (final candidate in topCandidates)
        _KeyCandidateDiagnostic(
          key: candidate.keyCenter.tonicName,
          mode: candidate.keyCenter.mode.name,
          score: candidate.score,
          confidence: candidate.confidence,
        ),
    ],
    topTwoScoreGap: topTwoScoreGap,
    expectedKeyRank: expectedIndex >= 0 ? expectedIndex + 1 : null,
    expectedKeyGapFromTop: expectedKeyGapFromTop,
    selectedKeyIsDominantOfExpected: selectedKeyIsDominantOfExpected,
    overallDominantRatio: overallDominantRatio,
    endingDominantRatio: endingDominantRatio,
    dominantBiasOverhang: dominantBiasOverhang,
    endingDominantCount: endingDominantCount,
    endingPredominantCount: endingPredominantCount,
    endingTonicCount: endingTonicCount,
    endingCadentialResolutions: endingCadentialResolutions,
    endingWindowSize: endingWindow.length,
    appliedDominantChordCount: appliedDominantChordCount,
    appliedDominantRemarkCount: appliedDominantRemarkCount,
    tonicizationRemarkCount: tonicizationRemarkCount,
    realModulationRemarkCount: realModulationRemarkCount,
    summary: summaryParts.join('; '),
  );
}

bool _isDominantOfExpected({
  required String expectedKey,
  required String actualKey,
}) {
  final expectedSemitone = MusicTheory.noteToSemitone[expectedKey];
  final actualSemitone = MusicTheory.noteToSemitone[actualKey];
  if (expectedSemitone == null || actualSemitone == null) {
    return false;
  }
  return (expectedSemitone + 7) % 12 == actualSemitone % 12;
}

List<_FailureTaxonomy> _classifyFailureCategories({
  required _BenchmarkCase benchmarkCase,
  required List<String> failures,
  required List<_SegmentComparison> segmentComparisons,
  required _ModulationDiagnostics modulationDiagnostics,
  required ProgressionAnalysis analysis,
  required bool keyMatch,
  required bool relaxedKeyMatch,
}) {
  final categories = <_FailureTaxonomy>{...benchmarkCase.failureHints};
  final hasKeyFailure = failures.any(
    (failure) => failure.contains('expected key'),
  );
  if (hasKeyFailure && relaxedKeyMatch && !keyMatch) {
    categories.add(_FailureTaxonomy.enharmonicEquivalence);
  }
  if (hasKeyFailure && !relaxedKeyMatch) {
    categories.add(_FailureTaxonomy.ambiguousKeyCenter);
  }
  if (benchmarkCase.requiredTags.contains(ProgressionTagId.realModulation) &&
      hasKeyFailure &&
      !relaxedKeyMatch) {
    categories.add(_FailureTaxonomy.modulationVsTonicization);
    categories.add(_FailureTaxonomy.endingBias);
  }
  if (segmentComparisons.any(
    (comparison) =>
        comparison.expectedResolvedSymbol?.contains('/') == true &&
        !comparison.resolvedSymbolMatch,
  )) {
    categories.add(_FailureTaxonomy.slashChordInterpretation);
  }
  if (segmentComparisons.any(
    (comparison) => !comparison.exactRomanMatch && comparison.relaxedRomanMatch,
  )) {
    categories.add(_FailureTaxonomy.secondaryDominantNotationGap);
  }
  if (benchmarkCase.requiredRemarks.any(
    (requirement) =>
        requirement.$2 == ProgressionRemarkKind.possibleModalInterchange,
  )) {
    categories.add(_FailureTaxonomy.modalMixtureConfusion);
    categories.add(_FailureTaxonomy.borrowedChordConfusion);
  }
  if (!modulationDiagnostics.matched &&
      modulationDiagnostics.expectedTags.isNotEmpty) {
    categories.add(_FailureTaxonomy.modulationVsTonicization);
  }
  if (!relaxedKeyMatch &&
      analysis.alternativeKey != null &&
      analysis.ambiguity > 0.15) {
    categories.add(_FailureTaxonomy.ambiguousKeyCenter);
  }
  return categories.toList(growable: false);
}

Map<_FailureTaxonomy, int> _failureCategoryCounts(List<_CaseResult> failures) {
  final counts = <_FailureTaxonomy, int>{};
  for (final failure in failures) {
    for (final category in failure.failureCategories) {
      counts.update(category, (count) => count + 1, ifAbsent: () => 1);
    }
  }
  return Map<_FailureTaxonomy, int>.fromEntries(
    counts.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value)),
  );
}

List<String> _recommendedFixes(List<_CaseResult> failures) {
  final fixes = <String>{};
  for (final failure in failures) {
    for (final category in failure.failureCategories) {
      fixes.add(category.recommendedFix);
    }
  }
  return fixes.toList(growable: false);
}

String _taxonomySummary(List<_FailureTaxonomy> categories) {
  if (categories.isEmpty) {
    return 'none';
  }
  return categories.map((item) => item.label).join(', ');
}

Map<String, int> _majorFailureClusters({
  required List<_CaseResult> failures,
  required Map<String, _AggregateMetrics> bySource,
}) {
  final counts = <String, int>{
    'notation_only_key_miss': failures
        .where((failure) => failure.notationOnlyKeyMiss)
        .length,
    'dominant_of_expected_key_miss': failures
        .where(
          (failure) =>
              !failure.relaxedKeyMatch &&
              failure.keyDiagnostics.selectedKeyIsDominantOfExpected,
        )
        .length,
    'key_center_miss': failures
        .where((failure) => !failure.relaxedKeyMatch)
        .length,
    'mode_miss': failures.where((failure) => !failure.modeMatch).length,
    'no_chord_event_miss_case': failures
        .where(
          (failure) =>
              failure.noChordSensitiveCase && !failure.noChordEventMatch,
        )
        .length,
    'canonical_roman_miss_case': failures
        .where(
          (failure) =>
              failure.matchedCanonicalRomanTokens <
              failure.totalCanonicalRomanTokens,
        )
        .length,
    'relaxed_function_still_miss_case': failures
        .where(
          (failure) =>
              failure.matchedRelaxedRomanTokens <
                  failure.totalRelaxedRomanTokens ||
              failure.matchedFunctionTokens < failure.totalFunctionTokens,
        )
        .length,
    'large_surface_notation_gap_source': _surfaceNotationGapEntries(
      bySource,
    ).length,
  };
  final filtered = counts.entries.where((entry) => entry.value > 0).toList()
    ..sort((left, right) {
      final byCount = right.value.compareTo(left.value);
      if (byCount != 0) {
        return byCount;
      }
      return left.key.compareTo(right.key);
    });
  return <String, int>{for (final entry in filtered) entry.key: entry.value};
}

List<MapEntry<String, _AggregateMetrics>> _surfaceNotationGapEntries(
  Map<String, _AggregateMetrics> rows, {
  double minGap = 0.25,
  double minCanonicalAccuracy = 0.60,
  int minSurfaceTokens = 4,
}) {
  final candidates =
      rows.entries.where((entry) {
        final metrics = entry.value;
        if (metrics.totalSurfaceRomanTokens < minSurfaceTokens ||
            metrics.totalCanonicalRomanTokens < minSurfaceTokens) {
          return false;
        }
        final gap =
            metrics.romanCanonicalExactAccuracy -
            metrics.romanSurfaceExactAccuracy;
        return gap >= minGap &&
            metrics.romanCanonicalExactAccuracy >= minCanonicalAccuracy;
      }).toList()..sort((left, right) {
        final gapCompare =
            (right.value.romanCanonicalExactAccuracy -
                    right.value.romanSurfaceExactAccuracy)
                .compareTo(
                  left.value.romanCanonicalExactAccuracy -
                      left.value.romanSurfaceExactAccuracy,
                );
        if (gapCompare != 0) {
          return gapCompare;
        }
        return left.key.compareTo(right.key);
      });
  return candidates;
}

String _breakdownTable(String title, Map<String, _AggregateMetrics> rows) {
  final buffer = StringBuffer();
  buffer.writeln('### $title');
  buffer.writeln('');
  buffer.writeln(
    '| Bucket | Key | Relaxed Key | Mode | Roman Surface Exact | Roman Canonical Exact | Roman Relaxed | Function Relaxed | No-Chord Events | Modulation Diagnostics |',
  );
  buffer.writeln(
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
  );
  for (final entry in rows.entries) {
    final metrics = entry.value;
    buffer.writeln(
      '| ${entry.key} | ${_formatPercent(metrics.keyAccuracy)} | '
      '${_formatPercent(metrics.relaxedKeyAccuracy)} | '
      '${_formatPercent(metrics.modeAccuracy)} | '
      '${_formatConditionalPercent(metrics.matchedSurfaceRomanTokens, metrics.totalSurfaceRomanTokens)} | '
      '${_formatConditionalPercent(metrics.matchedCanonicalRomanTokens, metrics.totalCanonicalRomanTokens)} | '
      '${_formatConditionalPercent(metrics.matchedRelaxedRomanTokens, metrics.totalRelaxedRomanTokens)} | '
      '${_formatConditionalPercent(metrics.matchedFunctionTokens, metrics.totalFunctionTokens)} | '
      '${_formatConditionalPercent(metrics.matchedNoChordEvents, metrics.totalNoChordEvents)} | '
      '${_formatConditionalPercent(metrics.modulationDiagnosticMatches, metrics.totalModulationSensitiveCases)} |',
    );
  }
  return buffer.toString().trimRight();
}

String _surfaceNotationGapTable(
  String title,
  Map<String, _AggregateMetrics> rows,
) {
  final entries = _surfaceNotationGapEntries(rows);
  final buffer = StringBuffer();
  buffer.writeln('### $title');
  buffer.writeln('');
  if (entries.isEmpty) {
    buffer.writeln(
      'No large surface-vs-canonical notation gaps crossed the reporting threshold in this run.',
    );
    return buffer.toString().trimRight();
  }
  buffer.writeln(
    '| Bucket | Roman Surface Exact | Roman Canonical Exact | Gap |',
  );
  buffer.writeln('| --- | ---: | ---: | ---: |');
  for (final entry in entries) {
    final metrics = entry.value;
    final gap =
        metrics.romanCanonicalExactAccuracy - metrics.romanSurfaceExactAccuracy;
    buffer.writeln(
      '| ${entry.key} | ${_formatPercent(metrics.romanSurfaceExactAccuracy)} | '
      '${_formatPercent(metrics.romanCanonicalExactAccuracy)} | '
      '${_formatPercent(gap)} |',
    );
  }
  return buffer.toString().trimRight();
}

_LoadedCuratedGoldCases _loadCuratedGoldCases({
  required String? manifestPath,
  required String outputDir,
  String? abcSourceRootPath,
  String? whenInRomeSourceRootPath,
}) {
  if (manifestPath != null && manifestPath.isNotEmpty) {
    final file = File(manifestPath);
    if (!file.existsSync()) {
      return _LoadedCuratedGoldCases(
        cases: const <_BenchmarkCase>[],
        status: _CuratedGoldLoadResult.notLoaded(manifestPath: manifestPath),
      );
    }
    final manifest = const ExternalGoldLoader().loadManifest(manifestPath);
    final rawRecordCount = manifest.records.length;
    final rawSegmentCount = manifest.records.fold<int>(
      0,
      (sum, record) => sum + record.segments.length,
    );
    final rawHarmonicSegmentCount = manifest.records.fold<int>(
      0,
      (sum, record) =>
          sum + record.segments.where((segment) => segment.isHarmonic).length,
    );
    final rawNonHarmonicSegmentCount = manifest.records.fold<int>(
      0,
      (sum, record) =>
          sum + record.segments.where((segment) => segment.isNoChord).length,
    );
    return _LoadedCuratedGoldCases(
      cases: _benchmarkCasesFromExternalManifest(manifest),
      status: _CuratedGoldLoadResult.combine(<_CuratedGoldCorpusLoad>[
        _CuratedGoldCorpusLoad(
          corpusId: manifest.corpusId,
          corpusName: manifest.corpusName,
          manifestPath: manifestPath,
          loadedCaseCount: manifest.records.length,
          licenseNote: manifest.licenseNote,
          rawRecordCount: rawRecordCount,
          rawSegmentCount: rawSegmentCount,
          keptSegmentCount: rawSegmentCount,
          rawHarmonicSegmentCount: rawHarmonicSegmentCount,
          keptHarmonicSegmentCount: rawHarmonicSegmentCount,
          rawNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
          keptNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
        ),
      ]),
    );
  }

  final corpusLoads = <_CuratedGoldCorpusLoad>[];
  final cases = <_BenchmarkCase>[];

  final abcFixtureDirectory = Directory(_defaultAbcExternalGoldFixtureDir);
  if (abcFixtureDirectory.existsSync()) {
    final selectionManifest = File(
      _defaultAbcExternalGoldSelectionManifestPath,
    );
    final discoveredSourceRoot =
        abcSourceRootPath ??
        Platform.environment['CHORD_ANALYZER_BENCHMARK_ABC_SOURCE_ROOT'] ??
        _defaultAbcExternalGoldSourceRoot;
    final sourceCorpusRoot = Directory(discoveredSourceRoot);
    final generatedManifestPath =
        '$outputDir${Platform.pathSeparator}curated_gold${Platform.pathSeparator}abc_external_gold_manifest.json';
    final importResult =
        selectionManifest.existsSync() && sourceCorpusRoot.existsSync()
        ? const AbcExternalGoldAdapter().importSelectionManifest(
            sourceCorpusRoot: sourceCorpusRoot.path,
            selectionManifestPath: selectionManifest.path,
            manifestOutputPath: generatedManifestPath,
          )
        : const AbcExternalGoldAdapter().importExcerptDirectory(
            abcFixtureDirectory.path,
            manifestOutputPath: generatedManifestPath,
          );
    corpusLoads.add(
      _curatedGoldCorpusLoadFromAbcImport(
        importResult,
        manifestPath: generatedManifestPath,
        fixtureDirectory: abcFixtureDirectory.path,
      ),
    );
    cases.addAll(_benchmarkCasesFromExternalManifest(importResult.manifest));
  }

  final whenInRomeFixtureDirectory = Directory(
    _defaultWhenInRomeExternalGoldFixtureDir,
  );
  final whenInRomeSelectionManifest = File(
    _defaultWhenInRomeExternalGoldSelectionManifestPath,
  );
  final discoveredWhenInRomeSourceRoot =
      whenInRomeSourceRootPath ??
      Platform.environment['CHORD_ANALYZER_BENCHMARK_WIR_SOURCE_ROOT'] ??
      _defaultWhenInRomeExternalGoldSourceRoot;
  final whenInRomeSourceRoot = Directory(discoveredWhenInRomeSourceRoot);
  if (whenInRomeFixtureDirectory.existsSync() &&
      whenInRomeSelectionManifest.existsSync() &&
      whenInRomeSourceRoot.existsSync()) {
    final generatedManifestPath =
        '$outputDir${Platform.pathSeparator}curated_gold${Platform.pathSeparator}when_in_rome_external_gold_manifest.json';
    final importResult = const WhenInRomeExternalGoldAdapter()
        .importSelectionManifest(
          sourceCorpusRoot: whenInRomeSourceRoot.path,
          selectionManifestPath: whenInRomeSelectionManifest.path,
          manifestOutputPath: generatedManifestPath,
        );
    corpusLoads.add(
      _curatedGoldCorpusLoadFromWhenInRomeImport(
        importResult,
        manifestPath: generatedManifestPath,
        fixtureDirectory: whenInRomeFixtureDirectory.path,
      ),
    );
    cases.addAll(_benchmarkCasesFromExternalManifest(importResult.manifest));
  }

  final isophonicsChocoFixtureDirectory = Directory(
    _defaultIsophonicsChocoExternalGoldFixtureDir,
  );
  if (isophonicsChocoFixtureDirectory.existsSync()) {
    final generatedManifestPath =
        '$outputDir${Platform.pathSeparator}curated_gold${Platform.pathSeparator}isophonics_choco_external_gold_manifest.json';
    final importResult = const IsophonicsChocoExternalGoldAdapter()
        .importExcerptDirectory(
          isophonicsChocoFixtureDirectory.path,
          manifestOutputPath: generatedManifestPath,
        );
    corpusLoads.add(
      _curatedGoldCorpusLoadFromChocoSurfaceImport(
        importResult,
        manifestPath: generatedManifestPath,
        fixtureDirectory: isophonicsChocoFixtureDirectory.path,
        adapterId: 'isophonics_choco_external_gold_adapter',
      ),
    );
    cases.addAll(_benchmarkCasesFromExternalManifest(importResult.manifest));
  }

  final jaahChocoFixtureDirectory = Directory(
    _defaultJaahChocoExternalGoldFixtureDir,
  );
  if (jaahChocoFixtureDirectory.existsSync()) {
    final generatedManifestPath =
        '$outputDir${Platform.pathSeparator}curated_gold${Platform.pathSeparator}jaah_choco_external_gold_manifest.json';
    final importResult = const JaahChocoExternalGoldAdapter()
        .importExcerptDirectory(
          jaahChocoFixtureDirectory.path,
          manifestOutputPath: generatedManifestPath,
        );
    corpusLoads.add(
      _curatedGoldCorpusLoadFromChocoSurfaceImport(
        importResult,
        manifestPath: generatedManifestPath,
        fixtureDirectory: jaahChocoFixtureDirectory.path,
        adapterId: 'jaah_choco_external_gold_adapter',
      ),
    );
    cases.addAll(_benchmarkCasesFromExternalManifest(importResult.manifest));
  }

  if (corpusLoads.isEmpty) {
    return _LoadedCuratedGoldCases(
      cases: const <_BenchmarkCase>[],
      status: _CuratedGoldLoadResult.notLoaded(),
    );
  }

  return _LoadedCuratedGoldCases(
    cases: cases,
    status: _CuratedGoldLoadResult.combine(corpusLoads),
  );
}

List<_BenchmarkCase> _benchmarkCasesFromExternalManifest(
  ExternalGoldCorpusManifest manifest,
) {
  return <_BenchmarkCase>[
    for (final record in manifest.records)
      _benchmarkCaseFromExternalRecord(
        record,
        corpusId: manifest.corpusId,
        corpusName: manifest.corpusName,
      ),
  ];
}

_CuratedGoldCorpusLoad _curatedGoldCorpusLoadFromAbcImport(
  AbcExternalGoldImportResult importResult, {
  required String manifestPath,
  required String fixtureDirectory,
}) {
  return _CuratedGoldCorpusLoad(
    corpusId: importResult.manifest.corpusId,
    corpusName: importResult.manifest.corpusName,
    manifestPath: manifestPath,
    loadedCaseCount: importResult.manifest.records.length,
    licenseNote: importResult.manifest.licenseNote,
    adapterId: 'abc_external_gold_adapter',
    fixtureDirectory: fixtureDirectory,
    selectionManifestPath: importResult.selectionManifestPath,
    sourceCorpusRootPath: importResult.sourceCorpusRootPath,
    importMode: importResult.importMode,
    skippedRecordCount: importResult.skippedRecordCount,
    skippedSegmentCount: importResult.skippedSegmentCount,
    rawRecordCount: importResult.rawRecordCount,
    rawSegmentCount: importResult.rawSegmentCount,
    keptSegmentCount: importResult.keptSegmentCount,
    rawHarmonicSegmentCount: importResult.rawSegmentCount,
    keptHarmonicSegmentCount: importResult.keptSegmentCount,
    rawNonHarmonicSegmentCount: 0,
    keptNonHarmonicSegmentCount: 0,
    skipReasonCounts: importResult.skipReasonCounts,
    recordDropReasonCounts: importResult.recordDropReasonCounts,
    coverageBySourceId: {
      for (final entry in importResult.coverageBySourceId.entries)
        entry.key: _CoverageBreakdown(
          rawRecordCount: entry.value.rawRecordCount,
          loadedRecordCount: entry.value.loadedRecordCount,
          skippedRecordCount: entry.value.skippedRecordCount,
          rawSegmentCount: entry.value.rawSegmentCount,
          keptSegmentCount: entry.value.keptSegmentCount,
          skippedSegmentCount: entry.value.skippedSegmentCount,
          rawHarmonicSegmentCount: entry.value.rawSegmentCount,
          keptHarmonicSegmentCount: entry.value.keptSegmentCount,
          rawNonHarmonicSegmentCount: 0,
          keptNonHarmonicSegmentCount: 0,
        ),
    },
  );
}

_CuratedGoldCorpusLoad _curatedGoldCorpusLoadFromWhenInRomeImport(
  WhenInRomeExternalGoldImportResult importResult, {
  required String manifestPath,
  required String fixtureDirectory,
}) {
  return _CuratedGoldCorpusLoad(
    corpusId: importResult.manifest.corpusId,
    corpusName: importResult.manifest.corpusName,
    manifestPath: manifestPath,
    loadedCaseCount: importResult.manifest.records.length,
    licenseNote: importResult.manifest.licenseNote,
    adapterId: 'when_in_rome_external_gold_adapter',
    fixtureDirectory: fixtureDirectory,
    selectionManifestPath: importResult.selectionManifestPath,
    sourceCorpusRootPath: importResult.sourceCorpusRootPath,
    importMode: importResult.importMode,
    skippedRecordCount: importResult.skippedRecordCount,
    skippedSegmentCount: importResult.skippedSegmentCount,
    rawRecordCount: importResult.rawRecordCount,
    rawSegmentCount: importResult.rawSegmentCount,
    keptSegmentCount: importResult.keptSegmentCount,
    rawHarmonicSegmentCount: importResult.rawSegmentCount,
    keptHarmonicSegmentCount: importResult.keptSegmentCount,
    rawNonHarmonicSegmentCount: 0,
    keptNonHarmonicSegmentCount: 0,
    skipReasonCounts: importResult.skipReasonCounts,
    recordDropReasonCounts: importResult.recordDropReasonCounts,
    coverageBySourceId: {
      for (final entry in importResult.coverageBySourceId.entries)
        entry.key: _CoverageBreakdown(
          rawRecordCount: entry.value.rawRecordCount,
          loadedRecordCount: entry.value.loadedRecordCount,
          skippedRecordCount: entry.value.skippedRecordCount,
          rawSegmentCount: entry.value.rawSegmentCount,
          keptSegmentCount: entry.value.keptSegmentCount,
          skippedSegmentCount: entry.value.skippedSegmentCount,
          rawHarmonicSegmentCount: entry.value.rawSegmentCount,
          keptHarmonicSegmentCount: entry.value.keptSegmentCount,
          rawNonHarmonicSegmentCount: 0,
          keptNonHarmonicSegmentCount: 0,
        ),
    },
  );
}

_CuratedGoldCorpusLoad _curatedGoldCorpusLoadFromChocoSurfaceImport(
  IsophonicsChocoExternalGoldImportResult importResult, {
  required String manifestPath,
  required String fixtureDirectory,
  required String adapterId,
}) {
  return _CuratedGoldCorpusLoad(
    corpusId: importResult.manifest.corpusId,
    corpusName: importResult.manifest.corpusName,
    manifestPath: manifestPath,
    loadedCaseCount: importResult.manifest.records.length,
    licenseNote: importResult.manifest.licenseNote,
    adapterId: adapterId,
    fixtureDirectory: fixtureDirectory,
    importMode: importResult.importMode,
    skippedRecordCount: importResult.skippedRecordCount,
    skippedSegmentCount: importResult.skippedSegmentCount,
    rawRecordCount: importResult.rawRecordCount,
    rawSegmentCount: importResult.rawSegmentCount,
    keptSegmentCount: importResult.keptSegmentCount,
    rawHarmonicSegmentCount: importResult.rawHarmonicSegmentCount,
    keptHarmonicSegmentCount: importResult.keptHarmonicSegmentCount,
    rawNonHarmonicSegmentCount: importResult.rawNonHarmonicSegmentCount,
    keptNonHarmonicSegmentCount: importResult.keptNonHarmonicSegmentCount,
    skipReasonCounts: importResult.skipReasonCounts,
    recordDropReasonCounts: importResult.recordDropReasonCounts,
    coverageBySourceId: {
      for (final entry in importResult.coverageBySourceId.entries)
        entry.key: _CoverageBreakdown(
          rawRecordCount: entry.value.rawRecordCount,
          loadedRecordCount: entry.value.loadedRecordCount,
          skippedRecordCount: entry.value.skippedRecordCount,
          rawSegmentCount: entry.value.rawSegmentCount,
          keptSegmentCount: entry.value.keptSegmentCount,
          skippedSegmentCount: entry.value.skippedSegmentCount,
          rawHarmonicSegmentCount: entry.value.rawHarmonicSegmentCount,
          keptHarmonicSegmentCount: entry.value.keptHarmonicSegmentCount,
          rawNonHarmonicSegmentCount: entry.value.rawNonHarmonicSegmentCount,
          keptNonHarmonicSegmentCount: entry.value.keptNonHarmonicSegmentCount,
        ),
    },
  );
}

_BenchmarkCase _benchmarkCaseFromExternalRecord(
  ExternalGoldRecord record, {
  required String corpusId,
  required String corpusName,
}) {
  final genre = switch (record.genreFamily) {
    'jazz' => _BenchmarkGenre.jazz,
    'pop' || 'rock' => _BenchmarkGenre.pop,
    'classical' => _BenchmarkGenre.classical,
    _ => _BenchmarkGenre.mixed,
  };
  final harmonicSegments = [
    for (final segment in record.segments)
      if (segment.isHarmonic) segment,
  ];
  final noChordSegments = [
    for (final segment in record.segments)
      if (segment.isNoChord) segment,
  ];
  return _BenchmarkCase(
    id: 'curated-${record.recordId}',
    description: record.title,
    progression: record.progressionInput,
    track: _BenchmarkTrack.goldCore,
    genre: genre,
    difficulty: _DifficultyBucket.hard,
    expectedKey: record.primaryKey,
    expectedMode: record.primaryMode,
    benchmarkClass: _BenchmarkClass.curatedGold,
    sourceId: record.sourceId,
    sourceLabel: record.title,
    corpusId: corpusId,
    corpusName: corpusName,
    annotationLevel: record.annotationLevel.name,
    keyScope: record.keyScope.jsonValue,
    segmentationScope: record.segmentationScope.jsonValue,
    segmentExpectations: [
      for (
        var analysisIndex = 0;
        analysisIndex < harmonicSegments.length;
        analysisIndex += 1
      )
        _SegmentExpectation(
          index: harmonicSegments[analysisIndex].index,
          analysisIndex: analysisIndex,
          expectedSurfaceRoman:
              harmonicSegments[analysisIndex].surfaceRomanLabel,
          expectedCanonicalRoman:
              harmonicSegments[analysisIndex].canonicalRomanLabel,
          expectedFunction: harmonicSegments[analysisIndex].expectedFunction,
          expectedResolvedSymbol:
              harmonicSegments[analysisIndex].expectedResolvedSymbol,
          note: harmonicSegments[analysisIndex].note,
          comparisonProfile: const _ComparisonProfile(
            allowEnharmonicKeyMatch: true,
            allowSlashBassTolerance: true,
          ),
        ),
    ],
    expectedPartialFailure: noChordSegments.isNotEmpty,
    expectedNoChordEventCount: noChordSegments.length,
    notes: [
      'annotationLevel=${record.annotationLevel.name}',
      'alignmentType=${record.alignmentType.name}',
      'keyScope=${record.keyScope.jsonValue}',
      'segmentationScope=${record.segmentationScope.jsonValue}',
      'splitTag=${record.splitTag}',
      'licenseNotes=${record.licenseNotes}',
      'harmonicSegments=${harmonicSegments.length}',
      if (noChordSegments.isNotEmpty)
        'noChordSegments=${noChordSegments.length}',
      if (record.globalKey != null) 'globalKey=${record.globalKey}',
      if (record.localKey != null) 'localKey=${record.localKey}',
    ],
    comparisonProfile: const _ComparisonProfile(
      allowEnharmonicKeyMatch: true,
      allowSlashBassTolerance: true,
    ),
  );
}
