import 'dart:convert';
import 'dart:math';

import '../settings/practice_settings.dart';
import '../settings/practice_settings_factory.dart';
import 'chord_theory.dart';
import 'chord_timing_models.dart';
import 'melody_candidate_builder.dart';
import 'melody_generator.dart';
import 'melody_models.dart';
import 'phrase_planner.dart';

class MelodyAnalysisModeMetrics {
  const MelodyAnalysisModeMetrics({
    required this.eventCount,
    required this.noteCount,
    required this.intervalCount,
    required this.adjacentSamePitchRatio,
    required this.singleEventMonotoneRatio,
    required this.exactPreviousEventRepeatRatio,
    required this.sameIntervalVectorRepeatInWindow4Ratio,
    required this.colorToneUptakeOnColorChords,
    required this.offbeatOnsetRatio,
    required this.resolutionWithin2SemitonesRatio,
    required this.intervalsAbove7SemitonesRatio,
    required this.phraseFinalLongNoteRatio,
    required this.cadenceLongFinalRatio,
    required this.cadenceResolutionQuality,
    required this.apexAlignmentRatio,
    required this.phraseMetadataCoverage,
    required this.centerMidiSpan,
    required this.apexMidiSpan,
    required this.apexPosBucketCount,
    required this.exactSameEventStreakLength,
    required this.entropy,
    required this.colorToneUsageByChordClass,
    required this.phraseRoleDistribution,
    required this.motifTransformDistribution,
    required this.syncopationByPosition,
    required this.intervalDistribution,
    required this.strongSlotCategoryUsage,
    required this.weakSlotCategoryUsage,
  });

  final int eventCount;
  final int noteCount;
  final int intervalCount;
  final double adjacentSamePitchRatio;
  final double singleEventMonotoneRatio;
  final double exactPreviousEventRepeatRatio;
  final double sameIntervalVectorRepeatInWindow4Ratio;
  final double colorToneUptakeOnColorChords;
  final double offbeatOnsetRatio;
  final double resolutionWithin2SemitonesRatio;
  final double intervalsAbove7SemitonesRatio;
  final double phraseFinalLongNoteRatio;
  final double cadenceLongFinalRatio;
  final double cadenceResolutionQuality;
  final double apexAlignmentRatio;
  final double phraseMetadataCoverage;
  final int centerMidiSpan;
  final int apexMidiSpan;
  final int apexPosBucketCount;
  final int exactSameEventStreakLength;
  final double entropy;
  final Map<String, double> colorToneUsageByChordClass;
  final Map<String, double> phraseRoleDistribution;
  final Map<String, double> motifTransformDistribution;
  final Map<String, double> syncopationByPosition;
  final Map<String, double> intervalDistribution;
  final Map<String, double> strongSlotCategoryUsage;
  final Map<String, double> weakSlotCategoryUsage;

  double get largeLeapRatio => intervalsAbove7SemitonesRatio;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'eventCount': eventCount,
      'noteCount': noteCount,
      'intervalCount': intervalCount,
      'adjacentSamePitchRatio': _roundDouble(adjacentSamePitchRatio),
      'singleEventMonotoneRatio': _roundDouble(singleEventMonotoneRatio),
      'exactPreviousEventRepeat': _roundDouble(exactPreviousEventRepeatRatio),
      'sameIntervalVectorRepeatInWindow4': _roundDouble(
        sameIntervalVectorRepeatInWindow4Ratio,
      ),
      'colorToneUptakeOnColorChords': _roundDouble(
        colorToneUptakeOnColorChords,
      ),
      'offbeatOnsetRatio': _roundDouble(offbeatOnsetRatio),
      'resolutionWithin2Semitones': _roundDouble(
        resolutionWithin2SemitonesRatio,
      ),
      'intervalsAbove7SemitonesRatio': _roundDouble(
        intervalsAbove7SemitonesRatio,
      ),
      'phraseFinalLongNoteRatio': _roundDouble(phraseFinalLongNoteRatio),
      'cadenceLongFinalRatio': _roundDouble(cadenceLongFinalRatio),
      'cadenceResolutionQuality': _roundDouble(cadenceResolutionQuality),
      'apexAlignmentRatio': _roundDouble(apexAlignmentRatio),
      'phraseMetadataCoverage': _roundDouble(phraseMetadataCoverage),
      'centerMidiSpan': centerMidiSpan,
      'apexMidiSpan': apexMidiSpan,
      'apexPosBucketCount': apexPosBucketCount,
      'exactSameEventStreakLength': exactSameEventStreakLength,
      'entropy': _roundDouble(entropy),
      'colorToneUsageByChordClass': _roundMap(colorToneUsageByChordClass),
      'phraseRoleDistribution': _roundMap(phraseRoleDistribution),
      'motifTransformDistribution': _roundMap(motifTransformDistribution),
      'syncopationByPosition': _roundMap(syncopationByPosition),
      'intervalDistribution': _roundMap(intervalDistribution),
      'strongSlotCategoryUsage': _roundMap(strongSlotCategoryUsage),
      'weakSlotCategoryUsage': _roundMap(weakSlotCategoryUsage),
    };
  }

  String summaryLine(String modeName) {
    return '$modeName: '
        'adjSame=${adjacentSamePitchRatio.toStringAsFixed(3)} '
        'monotone=${singleEventMonotoneRatio.toStringAsFixed(3)} '
        'exactRepeat=${exactPreviousEventRepeatRatio.toStringAsFixed(3)} '
        'intervalRepeat4=${sameIntervalVectorRepeatInWindow4Ratio.toStringAsFixed(3)} '
        'color=${colorToneUptakeOnColorChords.toStringAsFixed(3)} '
        'offbeat=${offbeatOnsetRatio.toStringAsFixed(3)} '
        'resolve2=${resolutionWithin2SemitonesRatio.toStringAsFixed(3)} '
        'largeLeap=${intervalsAbove7SemitonesRatio.toStringAsFixed(3)} '
        'phraseLong=${phraseFinalLongNoteRatio.toStringAsFixed(3)} '
        'repeatStreak=$exactSameEventStreakLength '
        'entropy=${entropy.toStringAsFixed(3)}';
  }
}

class MelodyAnalysisReport {
  const MelodyAnalysisReport({
    required this.seed,
    required this.sequenceLengths,
    required this.metricsByMode,
  });

  static const int reportVersion = 2;

  final int seed;
  final Map<SettingsComplexityMode, int> sequenceLengths;
  final Map<SettingsComplexityMode, MelodyAnalysisModeMetrics> metricsByMode;

  static const List<String> trackedMetrics = <String>[
    'adjacentSamePitchRatio',
    'singleEventMonotoneRatio',
    'exactPreviousEventRepeat',
    'sameIntervalVectorRepeatInWindow4',
    'colorToneUptakeOnColorChords',
    'offbeatOnsetRatio',
    'resolutionWithin2Semitones',
    'intervalsAbove7SemitonesRatio',
    'phraseFinalLongNoteRatio',
    'motifTransformDistribution',
    'syncopationByPosition',
    'intervalDistributionByMode',
    'exactSameEventStreakLength',
    'colorToneUsageByChordClass',
  ];

  Map<String, dynamic> toJson({bool includeGeneratedAtUtc = true}) {
    final payload = <String, dynamic>{
      'reportVersion': reportVersion,
      'seed': seed,
      'trackedMetrics': trackedMetrics,
      'sequenceLengths': <String, int>{
        for (final mode in SettingsComplexityMode.values)
          mode.name: sequenceLengths[mode] ?? 0,
      },
      'metricsByMode': <String, dynamic>{
        for (final mode in SettingsComplexityMode.values)
          mode.name: metricsByMode[mode]!.toJson(),
      },
      'intervalDistributionByMode': <String, dynamic>{
        for (final mode in SettingsComplexityMode.values)
          mode.name: metricsByMode[mode]!.toJson()['intervalDistribution'],
      },
      'syncopationByMode': <String, dynamic>{
        for (final mode in SettingsComplexityMode.values)
          mode.name: metricsByMode[mode]!.toJson()['syncopationByPosition'],
      },
      'motifTransformDistributionByMode': <String, dynamic>{
        for (final mode in SettingsComplexityMode.values)
          mode.name: metricsByMode[mode]!
              .toJson()['motifTransformDistribution'],
      },
    };
    if (includeGeneratedAtUtc) {
      payload['generatedAtUtc'] = DateTime.now().toUtc().toIso8601String();
    }
    return payload;
  }

  Map<String, dynamic> toComparableJson() {
    return toJson(includeGeneratedAtUtc: false);
  }

  String toPrettyJson({bool includeGeneratedAtUtc = true}) {
    return const JsonEncoder.withIndent(
      '  ',
    ).convert(toJson(includeGeneratedAtUtc: includeGeneratedAtUtc));
  }

  String toSummaryText() {
    final buffer = StringBuffer();
    buffer.writeln('Melody analysis report v$reportVersion seed=$seed');
    for (final mode in SettingsComplexityMode.values) {
      final metrics = metricsByMode[mode]!;
      buffer.writeln(metrics.summaryLine(mode.name));
      buffer.writeln(
        '  colorToneUsageByChordClass=${_roundMap(metrics.colorToneUsageByChordClass)}',
      );
      buffer.writeln(
        '  motifTransformDistribution=${_roundMap(metrics.motifTransformDistribution)}',
      );
      buffer.writeln(
        '  syncopationByPosition=${_roundMap(metrics.syncopationByPosition)}',
      );
      buffer.writeln(
        '  intervalDistribution=${_roundMap(metrics.intervalDistribution)}',
      );
    }
    return buffer.toString().trimRight();
  }
}

class MelodyQuickPresetAnalysisReport {
  const MelodyQuickPresetAnalysisReport({
    required this.seed,
    required this.sequenceLength,
    required this.metricsByPreset,
  });

  final int seed;
  final int sequenceLength;
  final Map<MelodyQuickPreset, MelodyAnalysisModeMetrics> metricsByPreset;

  Map<String, dynamic> toComparableJson() {
    return <String, dynamic>{
      'seed': seed,
      'sequenceLength': sequenceLength,
      'metricsByPreset': <String, dynamic>{
        for (final preset in MelodyQuickPreset.values)
          preset.name: metricsByPreset[preset]!.toJson(),
      },
    };
  }

  String toSummaryText() {
    final buffer = StringBuffer();
    buffer.writeln('Melody quick preset analysis seed=$seed');
    for (final preset in MelodyQuickPreset.values) {
      buffer.writeln(metricsByPreset[preset]!.summaryLine(preset.name));
    }
    return buffer.toString().trimRight();
  }
}

class MelodyAnalysisRunner {
  const MelodyAnalysisRunner._();

  static const int defaultSeed = 90210;

  static MelodyAnalysisReport analyzeDefaultModes({int seed = defaultSeed}) {
    final sequences = MelodyAnalysisScenarioLibrary.defaultSequences();
    final metricsByMode = <SettingsComplexityMode, MelodyAnalysisModeMetrics>{};
    final lengths = <SettingsComplexityMode, int>{};

    for (final mode in SettingsComplexityMode.values) {
      final settings = PracticeSettingsFactory.applyComplexityModeMelodyPreset(
        PracticeSettings(
          melodyGenerationEnabled: true,
          melodyRangeLow: 57,
          melodyRangeHigh: 82,
        ),
        mode,
      ).copyWith(melodyGenerationEnabled: true, settingsComplexityMode: mode);
      final sequence = sequences[mode]!;
      final events = _generateSequence(sequence, settings, seed);
      lengths[mode] = sequence.length;
      metricsByMode[mode] = _analyze(events, settings);
    }

    return MelodyAnalysisReport(
      seed: seed,
      sequenceLengths: lengths,
      metricsByMode: metricsByMode,
    );
  }

  static MelodyQuickPresetAnalysisReport analyzeQuickPresets({
    int seed = defaultSeed,
  }) {
    final sequence = MelodyAnalysisScenarioLibrary.quickPresetSequence();
    final metricsByPreset = <MelodyQuickPreset, MelodyAnalysisModeMetrics>{};
    final baseSettings = PracticeSettings(
      melodyGenerationEnabled: true,
      settingsComplexityMode: SettingsComplexityMode.guided,
      melodyRangeLow: 57,
      melodyRangeHigh: 82,
    );

    for (final preset in MelodyQuickPreset.values) {
      final settings = PracticeSettingsFactory.applyQuickMelodyPreset(
        baseSettings,
        preset,
      );
      final events = _generateSequence(sequence, settings, seed);
      metricsByPreset[preset] = _analyze(events, settings);
    }

    return MelodyQuickPresetAnalysisReport(
      seed: seed,
      sequenceLength: sequence.length,
      metricsByPreset: metricsByPreset,
    );
  }
}

class MelodyAnalysisScenarioLibrary {
  const MelodyAnalysisScenarioLibrary._();

  static Map<SettingsComplexityMode, List<GeneratedChordEvent>>
  defaultSequences() {
    return <SettingsComplexityMode, List<GeneratedChordEvent>>{
      SettingsComplexityMode.guided: _guidedSequence,
      SettingsComplexityMode.standard: _standardSequence,
      SettingsComplexityMode.advanced: _advancedSequence,
    };
  }

  static List<GeneratedChordEvent> quickPresetSequence() => _advancedSequence;

  static GeneratedChord _chord({
    required String root,
    required ChordQuality quality,
    required String key,
    required RomanNumeralId roman,
    required HarmonicFunction function,
    List<String> tensions = const <String>[],
    AppliedType? appliedType,
    DominantIntent? dominantIntent,
    ChordSourceKind sourceKind = ChordSourceKind.free,
    bool isRenderedNonDiatonic = false,
  }) {
    final comparisonKey =
        '$root:${quality.name}:${tensions.join(".")}:${roman.name}:${dominantIntent?.name ?? ''}:${appliedType?.name ?? ''}';
    return GeneratedChord(
      symbolData: ChordSymbolData(
        root: root,
        harmonicQuality: quality,
        renderQuality: quality,
        tensions: tensions,
      ),
      repeatGuardKey: comparisonKey,
      harmonicComparisonKey: comparisonKey,
      keyName: key,
      keyCenter: KeyCenter(tonicName: key, mode: KeyMode.major),
      romanNumeralId: roman,
      harmonicFunction: function,
      appliedType: appliedType,
      dominantIntent: dominantIntent,
      sourceKind: sourceKind,
      isRenderedNonDiatonic: isRenderedNonDiatonic,
    );
  }

  static GeneratedChordEvent _event({
    required GeneratedChord chord,
    required int barIndex,
  }) {
    return GeneratedChordEvent(
      chord: chord,
      timing: ChordTimingSpec(
        barIndex: barIndex,
        changeBeat: 0,
        durationBeats: 4,
        beatsPerBar: 4,
        eventIndexInBar: 0,
        eventsInBar: 1,
      ),
    );
  }

  static final List<GeneratedChordEvent> _standardSequence =
      <GeneratedChordEvent>[
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 0,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 1,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.iiMin7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['11', '13'],
          ),
          barIndex: 2,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['9', '13'],
          ),
          barIndex: 3,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['#11'],
          ),
          barIndex: 4,
        ),
        _event(
          chord: _chord(
            root: 'F',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.borrowedIvMin7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['9', '11'],
            sourceKind: ChordSourceKind.modalInterchange,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 5,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.halfDiminished7,
            key: 'C',
            roman: RomanNumeralId.borrowedIiHalfDiminished7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['11'],
            sourceKind: ChordSourceKind.modalInterchange,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 6,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7Alt,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['b9', '#9', 'b13'],
            dominantIntent: DominantIntent.secondaryToMajor,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 7,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 8,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 9,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 10,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['9', '13'],
          ),
          barIndex: 11,
        ),
      ];

  static final List<GeneratedChordEvent> _guidedSequence =
      <GeneratedChordEvent>[
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 0,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 1,
        ),
        _event(
          chord: _chord(
            root: 'A',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.viMin7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 2,
        ),
        _event(
          chord: _chord(
            root: 'A',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.viMin7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 3,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.iiMin7,
            function: HarmonicFunction.predominant,
          ),
          barIndex: 4,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
          ),
          barIndex: 5,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['#11'],
          ),
          barIndex: 6,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 7,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.iiMin7,
            function: HarmonicFunction.predominant,
          ),
          barIndex: 8,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
          ),
          barIndex: 9,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
          ),
          barIndex: 10,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
          ),
          barIndex: 11,
        ),
      ];

  static final List<GeneratedChordEvent> _advancedSequence =
      <GeneratedChordEvent>[
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['#11'],
          ),
          barIndex: 0,
        ),
        _event(
          chord: _chord(
            root: 'Db',
            quality: ChordQuality.dominant7Sharp11,
            key: 'C',
            roman: RomanNumeralId.substituteOfII,
            function: HarmonicFunction.dominant,
            tensions: const <String>['#11', '9', '13'],
            appliedType: AppliedType.substitute,
            dominantIntent: DominantIntent.lydianDominant,
            sourceKind: ChordSourceKind.substituteDominant,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 1,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.iiMin7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['11', '13'],
          ),
          barIndex: 2,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7Alt,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['b9', '#9', 'b13'],
            dominantIntent: DominantIntent.secondaryToMajor,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 3,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['#11'],
          ),
          barIndex: 4,
        ),
        _event(
          chord: _chord(
            root: 'F',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.borrowedIvMin7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['9', '11'],
            sourceKind: ChordSourceKind.modalInterchange,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 5,
        ),
        _event(
          chord: _chord(
            root: 'D',
            quality: ChordQuality.halfDiminished7,
            key: 'C',
            roman: RomanNumeralId.borrowedIiHalfDiminished7,
            function: HarmonicFunction.predominant,
            tensions: const <String>['11'],
            sourceKind: ChordSourceKind.modalInterchange,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 6,
        ),
        _event(
          chord: _chord(
            root: 'G',
            quality: ChordQuality.dominant7Alt,
            key: 'C',
            roman: RomanNumeralId.vDom7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['b9', '#9', 'b13'],
            dominantIntent: DominantIntent.secondaryToMajor,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 7,
        ),
        _event(
          chord: _chord(
            root: 'Eb',
            quality: ChordQuality.dominant7Sharp11,
            key: 'C',
            roman: RomanNumeralId.borrowedFlatVII7,
            function: HarmonicFunction.dominant,
            tensions: const <String>['#11', '9', '13'],
            dominantIntent: DominantIntent.backdoor,
            sourceKind: ChordSourceKind.modalInterchange,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 8,
        ),
        _event(
          chord: _chord(
            root: 'C',
            quality: ChordQuality.major7,
            key: 'C',
            roman: RomanNumeralId.iMaj7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['#11'],
          ),
          barIndex: 9,
        ),
        _event(
          chord: _chord(
            root: 'A',
            quality: ChordQuality.minor7,
            key: 'C',
            roman: RomanNumeralId.viMin7,
            function: HarmonicFunction.tonic,
            tensions: const <String>['11', '13'],
          ),
          barIndex: 10,
        ),
        _event(
          chord: _chord(
            root: 'Db',
            quality: ChordQuality.dominant7Sharp11,
            key: 'C',
            roman: RomanNumeralId.substituteOfII,
            function: HarmonicFunction.dominant,
            tensions: const <String>['#11', '9', '13'],
            appliedType: AppliedType.substitute,
            dominantIntent: DominantIntent.lydianDominant,
            sourceKind: ChordSourceKind.substituteDominant,
            isRenderedNonDiatonic: true,
          ),
          barIndex: 11,
        ),
      ];
}

List<GeneratedMelodyEvent> _generateSequence(
  List<GeneratedChordEvent> sequence,
  PracticeSettings settings,
  int seed,
) {
  final events = <GeneratedMelodyEvent>[];
  for (var index = 0; index < sequence.length; index += 1) {
    final phraseWindow = _phraseWindow(sequence, index);
    final event = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: sequence[index],
        previousChordEvent: index > 0 ? sequence[index - 1] : null,
        nextChordEvent: index + 1 < sequence.length
            ? sequence[index + 1]
            : null,
        lookAheadChordEvent: index + 2 < sequence.length
            ? sequence[index + 2]
            : null,
        previousMelodyEvent: events.isEmpty ? null : events.last,
        recentMelodyEvents: events.length <= 4
            ? List<GeneratedMelodyEvent>.from(events, growable: false)
            : events.sublist(events.length - 4),
        phraseChordWindow: phraseWindow.events,
        phraseWindowIndex: phraseWindow.currentIndex,
        settings: settings,
        seed: seed,
      ),
    );
    events.add(event);
  }
  return events;
}

({List<GeneratedChordEvent> events, int currentIndex}) _phraseWindow(
  List<GeneratedChordEvent> sequence,
  int index,
) {
  final start = max(0, index - 1);
  final end = min(sequence.length, index + 4);
  final window = sequence.sublist(start, end);
  return (events: window, currentIndex: index - start);
}

MelodyAnalysisModeMetrics _analyze(
  List<GeneratedMelodyEvent> events,
  PracticeSettings settings,
) {
  var adjacentSame = 0;
  var adjacentTotal = 0;
  var monotoneEvents = 0;
  var contourEligibleEvents = 0;
  var exactRepeats = 0;
  var recentWindowIntervalRepeats = 0;
  var colorNotes = 0;
  var colorHits = 0;
  var offbeat = 0;
  var noteCount = 0;
  var resolveWithin2 = 0;
  var resolveTotal = 0;
  var largeLeaps = 0;
  var intervalCount = 0;
  var finalLongNotes = 0;
  var cadenceLongFinals = 0;
  var cadenceEvents = 0;
  var cadenceResolutionScoreTotal = 0.0;
  var maxRepeatStreak = 1;
  var currentRepeatStreak = 1;
  var phraseMetadataEvents = 0;
  var apexCarrierEvents = 0;
  var apexAlignedEvents = 0;
  final colorUsageCounts = <String, List<int>>{};
  final motifDistribution = <String, int>{};
  final syncopationCounts = <String, int>{'&1': 0, '&2': 0, '&3': 0, '&4': 0};
  final intervalDistribution = <String, int>{};
  final strongCategoryCounts = <String, int>{};
  final weakCategoryCounts = <String, int>{};
  final pitchHistogram = <int, int>{};
  final phraseRoleCounts = <String, int>{};
  final centerMidis = <int>[];
  final apexMidis = <int>[];
  final apexPosBuckets = <int>{};
  GeneratedMelodyNote? previousGlobalNote;

  for (var eventIndex = 0; eventIndex < events.length; eventIndex += 1) {
    final event = events[eventIndex];
    final previous = eventIndex > 0 ? events[eventIndex - 1] : null;
    final signature = event.notes
        .map(
          (note) =>
              '${note.midiNote}@${note.startBeatOffset.toStringAsFixed(2)}:${note.durationBeats.toStringAsFixed(2)}',
        )
        .join('|');
    if (previous != null) {
      final previousSignature = previous.notes
          .map(
            (note) =>
                '${note.midiNote}@${note.startBeatOffset.toStringAsFixed(2)}:${note.durationBeats.toStringAsFixed(2)}',
          )
          .join('|');
      if (signature == previousSignature) {
        exactRepeats += 1;
        currentRepeatStreak += 1;
        maxRepeatStreak = max(maxRepeatStreak, currentRepeatStreak);
      } else {
        currentRepeatStreak = 1;
      }
      if (previous.lastMidiNote != null && event.firstNote != null) {
        resolveTotal += 1;
        if ((previous.lastMidiNote! - event.firstNote!.midiNote).abs() <= 2) {
          resolveWithin2 += 1;
        }
      }
    }
    final recentWindowStart = max(0, eventIndex - 4);
    final recentWindow = events.sublist(recentWindowStart, eventIndex);
    if (event.intervalSignatureKey.isNotEmpty &&
        recentWindow.any(
          (candidate) =>
              candidate.intervalSignatureKey == event.intervalSignatureKey,
        )) {
      recentWindowIntervalRepeats += 1;
    }

    final contour = <int>[];
    for (var noteIndex = 0; noteIndex < event.notes.length; noteIndex += 1) {
      final note = event.notes[noteIndex];
      noteCount += 1;
      pitchHistogram.update(
        note.pitchClass,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      if (previousGlobalNote != null) {
        adjacentTotal += 1;
        if (previousGlobalNote.midiNote == note.midiNote) {
          adjacentSame += 1;
        }
      }
      previousGlobalNote = note;
      if (note.startBeatOffset % 1 != 0) {
        offbeat += 1;
      }
      final key = switch (((note.startBeatOffset * 2).round()) % 8) {
        1 => '&1',
        3 => '&2',
        5 => '&3',
        7 => '&4',
        _ => '',
      };
      if (key.isNotEmpty) {
        syncopationCounts.update(key, (value) => value + 1);
      }
      final categoryKey = note.sourceCategoryKey;
      if (categoryKey != null) {
        final bucket = note.strongSlot
            ? strongCategoryCounts
            : weakCategoryCounts;
        bucket.update(categoryKey, (value) => value + 1, ifAbsent: () => 1);
      }
      if (noteIndex > 0) {
        final interval = note.midiNote - event.notes[noteIndex - 1].midiNote;
        contour.add(interval);
        if (interval.abs() > 7) {
          largeLeaps += 1;
        }
        intervalCount += 1;
        final bucket = interval.abs().clamp(0, 12).toString();
        intervalDistribution.update(
          bucket,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    if (contour.length >= 3) {
      contourEligibleEvents += 1;
      final nonZeroSigns = contour
          .where((interval) => interval != 0)
          .map((interval) => interval.sign)
          .toSet();
      if (nonZeroSigns.length <= 1) {
        monotoneEvents += 1;
      }
    }

    final localMeanDuration = event.notes.length <= 1
        ? (event.notes.isEmpty ? 0.0 : event.notes.first.durationBeats)
        : event.notes
                  .take(event.notes.length - 1)
                  .fold<double>(0, (sum, note) => sum + note.durationBeats) /
              (event.notes.length - 1);
    if (event.notes.isNotEmpty &&
        event.notes.last.durationBeats >= localMeanDuration * 1.8) {
      finalLongNotes += 1;
    }
    if (event.phraseRole != null) {
      phraseMetadataEvents += 1;
      phraseRoleCounts.update(
        event.phraseRole!.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    if (event.phraseCenterMidi != null) {
      centerMidis.add(event.phraseCenterMidi!);
    }
    if (event.phraseApexMidi != null) {
      apexMidis.add(event.phraseApexMidi!);
    }
    if (event.phraseApexPos01 != null) {
      apexPosBuckets.add((event.phraseApexPos01! * 10).floor());
    }
    if (event.phraseRole == PhraseRole.cadence) {
      cadenceEvents += 1;
      if (event.notes.isNotEmpty &&
          event.notes.last.durationBeats >= localMeanDuration * 1.8) {
        cadenceLongFinals += 1;
      }
      cadenceResolutionScoreTotal += _cadenceResolutionScore(event);
    }
    if (_eventCarriesApex(event)) {
      apexCarrierEvents += 1;
      if (_isApexAligned(event)) {
        apexAlignedEvents += 1;
      }
    }

    final palette = MelodyHarmonyPalette.fromChord(
      chord: event.chordEvent.chord,
      settings: settings,
    );
    if (palette.isColorChord) {
      final usage = colorUsageCounts.putIfAbsent(
        palette.chordClassKey,
        () => <int>[0, 0],
      );
      for (final note in event.notes) {
        colorNotes += 1;
        usage[0] += 1;
        if (palette.colorLabels.contains(note.toneLabel)) {
          colorHits += 1;
          usage[1] += 1;
        }
      }
    }

    final transform = event.motifSignature.split(':').first;
    motifDistribution.update(
      transform,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  final colorByChordClass = <String, double>{
    for (final entry in colorUsageCounts.entries)
      entry.key: entry.value[0] == 0 ? 0.0 : entry.value[1] / entry.value[0],
  };
  final motifTotal = max(
    1,
    motifDistribution.values.fold<int>(0, (sum, value) => sum + value),
  );
  final syncTotal = max(
    1,
    syncopationCounts.values.fold<int>(0, (sum, value) => sum + value),
  );
  final intervalTotal = max(
    1,
    intervalDistribution.values.fold<int>(0, (sum, value) => sum + value),
  );
  final roleTotal = max(
    1,
    phraseRoleCounts.values.fold<int>(0, (sum, value) => sum + value),
  );
  final centerMidiSpan = centerMidis.isEmpty
      ? 0
      : centerMidis.reduce(max) - centerMidis.reduce(min);
  final apexMidiSpan = apexMidis.isEmpty
      ? 0
      : apexMidis.reduce(max) - apexMidis.reduce(min);
  final strongCategoryTotal = max(
    1,
    strongCategoryCounts.values.fold<int>(0, (sum, value) => sum + value),
  );
  final weakCategoryTotal = max(
    1,
    weakCategoryCounts.values.fold<int>(0, (sum, value) => sum + value),
  );

  return MelodyAnalysisModeMetrics(
    eventCount: events.length,
    noteCount: noteCount,
    intervalCount: intervalCount,
    adjacentSamePitchRatio: adjacentTotal == 0
        ? 0.0
        : adjacentSame / adjacentTotal,
    singleEventMonotoneRatio: monotoneEvents / max(1, contourEligibleEvents),
    exactPreviousEventRepeatRatio: exactRepeats / max(1, events.length - 1),
    sameIntervalVectorRepeatInWindow4Ratio:
        recentWindowIntervalRepeats / max(1, events.length - 1),
    colorToneUptakeOnColorChords: colorNotes == 0
        ? 0.0
        : colorHits / colorNotes,
    offbeatOnsetRatio: noteCount == 0 ? 0.0 : offbeat / noteCount,
    resolutionWithin2SemitonesRatio: resolveTotal == 0
        ? 0.0
        : resolveWithin2 / resolveTotal,
    intervalsAbove7SemitonesRatio: intervalCount == 0
        ? 0.0
        : largeLeaps / intervalCount,
    phraseFinalLongNoteRatio: finalLongNotes / max(1, events.length),
    cadenceLongFinalRatio: cadenceLongFinals / max(1, cadenceEvents),
    cadenceResolutionQuality:
        cadenceResolutionScoreTotal / max(1, cadenceEvents),
    apexAlignmentRatio: apexAlignedEvents / max(1, apexCarrierEvents),
    phraseMetadataCoverage: phraseMetadataEvents / max(1, events.length),
    centerMidiSpan: centerMidiSpan,
    apexMidiSpan: apexMidiSpan,
    apexPosBucketCount: apexPosBuckets.length,
    exactSameEventStreakLength: maxRepeatStreak,
    entropy: _entropy(pitchHistogram),
    colorToneUsageByChordClass: colorByChordClass,
    phraseRoleDistribution: <String, double>{
      for (final entry in phraseRoleCounts.entries)
        entry.key: entry.value / roleTotal,
    },
    motifTransformDistribution: <String, double>{
      for (final entry in motifDistribution.entries)
        entry.key: entry.value / motifTotal,
    },
    syncopationByPosition: <String, double>{
      for (final entry in syncopationCounts.entries)
        entry.key: entry.value / syncTotal,
    },
    intervalDistribution: <String, double>{
      for (final entry in intervalDistribution.entries)
        entry.key: entry.value / intervalTotal,
    },
    strongSlotCategoryUsage: <String, double>{
      for (final entry in strongCategoryCounts.entries)
        entry.key: entry.value / strongCategoryTotal,
    },
    weakSlotCategoryUsage: <String, double>{
      for (final entry in weakCategoryCounts.entries)
        entry.key: entry.value / weakCategoryTotal,
    },
  );
}

bool _eventCarriesApex(GeneratedMelodyEvent event) {
  if (event.notes.isEmpty ||
      event.phraseApexPos01 == null ||
      event.phraseEventStartPos01 == null ||
      event.phraseEventEndPos01 == null) {
    return false;
  }
  return event.phraseApexPos01! >= event.phraseEventStartPos01! - 0.02 &&
      event.phraseApexPos01! <= event.phraseEventEndPos01! + 0.02;
}

bool _isApexAligned(GeneratedMelodyEvent event) {
  if (!_eventCarriesApex(event) ||
      event.notes.isEmpty ||
      event.phraseApexMidi == null ||
      event.phraseApexPos01 == null ||
      event.phraseEventStartPos01 == null ||
      event.phraseEventEndPos01 == null) {
    return false;
  }
  final highest = event.notes.reduce(
    (left, right) => left.midiNote >= right.midiNote ? left : right,
  );
  final span01 = max(
    0.0001,
    event.phraseEventEndPos01! - event.phraseEventStartPos01!,
  );
  final localPos01 =
      highest.startBeatOffset /
      max(0.0001, event.chordEvent.timing.durationBeats.toDouble());
  final actualPos01 =
      event.phraseEventStartPos01! + (localPos01.clamp(0.0, 1.0) * span01);
  return (highest.midiNote - event.phraseApexMidi!).abs() <= 3 &&
      (actualPos01 - event.phraseApexPos01!).abs() <= 0.18;
}

double _cadenceResolutionScore(GeneratedMelodyEvent event) {
  if (event.notes.isEmpty || event.arrivalMidiNote == null) {
    return 0.0;
  }
  var score = 0.0;
  final last = event.notes.last;
  final localMeanDuration = event.notes.length <= 1
      ? event.notes.first.durationBeats
      : event.notes
                .take(event.notes.length - 1)
                .fold<double>(0, (sum, note) => sum + note.durationBeats) /
            (event.notes.length - 1);
  final endDistance = (last.midiNote - event.arrivalMidiNote!).abs();
  score += max(0.0, 0.45 - (endDistance * 0.08));
  if (last.durationBeats >= localMeanDuration * 1.8) {
    score += 0.28;
  }
  if (event.notes.length >= 2) {
    final penultimate = event.notes[event.notes.length - 2];
    final arrivalInterval = (last.midiNote - penultimate.midiNote).abs();
    score += arrivalInterval <= 2
        ? 0.22
        : arrivalInterval <= 4
        ? 0.10
        : 0.0;
  }
  final endingPriority = event.phraseEndingDegreePriority;
  if (endingPriority != null) {
    final matches = switch (endingPriority) {
      1 => last.toneLabel == '1' || last.toneLabel == '3',
      3 => last.toneLabel == '3' || last.toneLabel == 'b3',
      5 => last.toneLabel == '5',
      7 => last.toneLabel == '7' || last.toneLabel == 'b7',
      _ => false,
    };
    if (matches) {
      score += 0.15;
    }
  }
  return score.clamp(0.0, 1.0).toDouble();
}

double _entropy(Map<int, int> histogram) {
  final total = histogram.values.fold<int>(0, (sum, value) => sum + value);
  if (total == 0) {
    return 0.0;
  }
  var entropy = 0.0;
  for (final count in histogram.values) {
    final probability = count / total;
    entropy -= probability * (log(probability) / log(2));
  }
  return entropy;
}

Map<String, double> _roundMap(Map<String, double> values) {
  final entries = values.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return <String, double>{
    for (final entry in entries) entry.key: _roundDouble(entry.value),
  };
}

double _roundDouble(double value) {
  return (value * 1000000).round() / 1000000;
}
