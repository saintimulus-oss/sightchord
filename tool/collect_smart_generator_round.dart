// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/inversion_settings.dart';
import 'package:chordest/smart_generator.dart';

const int _defaultRound = 1;
const int _defaultStepsPerCell = 64;
const String _defaultOutputRoot = 'build/smart_stats';
const int _defaultProgressEvery = 256;
const int _topLimit = 25;

void main(List<String> args) {
  final parsed = _Args.parse(args);
  final keyBanks = _buildKeyBanks();
  final advancedProfiles = _buildAdvancedProfiles();
  final inversionProfiles = _buildInversionProfiles();
  final totalCells =
      keyBanks.length * advancedProfiles.length * 2 * inversionProfiles.length;
  final roundDir = Directory(
    '${parsed.outputRoot}${Platform.pathSeparator}round_${parsed.round.toString().padLeft(2, '0')}',
  );
  roundDir.createSync(recursive: true);

  final manifestPath = '${roundDir.path}${Platform.pathSeparator}manifest.json';
  final cellsPath = '${roundDir.path}${Platform.pathSeparator}cells.jsonl';
  final summaryPath = '${roundDir.path}${Platform.pathSeparator}summary.json';

  final effectiveCellTarget = parsed.maxCells == null
      ? totalCells
      : min(parsed.maxCells!, totalCells);

  print('Collecting Smart Generator round ${parsed.round}');
  print('Output directory: ${roundDir.path}');
  print(
    'Cells: $effectiveCellTarget/$totalCells  '
    'steps per cell: ${parsed.stepsPerCell}  '
    'total planned steps: ${effectiveCellTarget * parsed.stepsPerCell}',
  );

  final manifest = <String, Object?>{
    'round': parsed.round,
    'stepsPerCell': parsed.stepsPerCell,
    'requestedMaxCells': parsed.maxCells,
    'progressEvery': parsed.progressEvery,
    'generatedAtUtc': DateTime.now().toUtc().toIso8601String(),
    'coverageModel': {
      'smartGeneratorMode': 'fixed_on',
      'voicingSuggestions': 'excluded_from_collection',
      'keyActivation': {
        'mode': 'relation_bank_sampling',
        'note':
            'Round collection uses 8 representative key banks instead of the '
            'raw 24 independent mode chips.',
      },
      'nonDiatonicAxis': {
        'secondaryDominant': true,
        'substituteDominant': true,
        'modalInterchange': true,
        'modulationIntensity': ModulationIntensity.values
            .map((value) => value.name)
            .toList(growable: false),
        'jazzPreset': JazzPreset.values
            .map((value) => value.name)
            .toList(growable: false),
        'sourceProfile': SourceProfile.values
            .map((value) => value.name)
            .toList(growable: false),
      },
      'allowV7sus4States': const [false, true],
      'allowTensions': {
        'mode': 'fixed',
        'value': false,
        'note':
            'Tensions are intentionally held constant so the eight-round plan '
            'covers the requested axes first.',
      },
      'inversions': {
        'mode': 'effective_output_classes',
        'rawUiStateCount': 16,
        'effectiveStateCount': inversionProfiles.length,
        'note':
            'disabled and enabled-with-no-selected-inversions are output-equivalent',
      },
    },
    'keyBanks': [for (final bank in keyBanks) bank.toJson()],
    'advancedProfileCount': advancedProfiles.length,
    'inversionProfiles': [
      for (final profile in inversionProfiles) profile.toJson(),
    ],
    'totalEffectiveCells': totalCells,
    'plannedEffectiveCellsThisRun': effectiveCellTarget,
  };
  File(
    manifestPath,
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(manifest));

  final aggregator = _RoundAggregator(
    round: parsed.round,
    stepsPerCell: parsed.stepsPerCell,
    totalPlannedCells: effectiveCellTarget,
    totalEffectiveCells: totalCells,
    keyBanks: keyBanks,
    advancedProfiles: advancedProfiles,
    inversionProfiles: inversionProfiles,
  );

  final stopwatch = Stopwatch()..start();
  var cellIndex = 0;
  final sink = File(cellsPath).openWrite();
  try {
    outer:
    for (final keyBank in keyBanks) {
      for (final advanced in advancedProfiles) {
        for (final allowV7sus4 in const [false, true]) {
          for (final inversion in inversionProfiles) {
            if (parsed.maxCells != null && cellIndex >= parsed.maxCells!) {
              break outer;
            }

            final cellNumber = cellIndex + 1;
            final seed = _seedForCell(
              round: parsed.round,
              cellIndex: cellIndex,
            );
            final summary = SmartGeneratorHelper.simulateSteps(
              random: Random(seed),
              steps: parsed.stepsPerCell,
              request: SmartStartRequest(
                activeKeys: keyBank.activeKeys,
                selectedKeyCenters: keyBank.selectedKeyCenters,
                secondaryDominantEnabled: advanced.secondaryDominantEnabled,
                substituteDominantEnabled: advanced.substituteDominantEnabled,
                modalInterchangeEnabled: advanced.modalInterchangeEnabled,
                modulationIntensity: advanced.modulationIntensity,
                jazzPreset: advanced.jazzPreset,
                sourceProfile: advanced.sourceProfile,
                allowV7sus4: allowV7sus4,
                allowTensions: false,
                inversionSettings: inversion.settings,
                smartDiagnosticsEnabled: true,
              ),
            );
            final derived = _DerivedCellStats.fromSummary(summary);
            final cellId = 'cell_${cellNumber.toString().padLeft(5, '0')}';
            final row = _buildCellRow(
              cellId: cellId,
              round: parsed.round,
              seed: seed,
              stepsPerCell: parsed.stepsPerCell,
              keyBank: keyBank,
              advanced: advanced,
              allowV7sus4: allowV7sus4,
              inversion: inversion,
              summary: summary,
              derived: derived,
            );
            sink.writeln(jsonEncode(row));

            aggregator.record(
              keyBank: keyBank,
              advanced: advanced,
              allowV7sus4: allowV7sus4,
              inversion: inversion,
              summary: summary,
              derived: derived,
            );

            cellIndex += 1;
            if (cellIndex % parsed.progressEvery == 0 ||
                cellIndex == effectiveCellTarget) {
              final elapsedSeconds = max(1, stopwatch.elapsed.inSeconds);
              final cellsPerSecond = cellIndex / elapsedSeconds;
              final remainingCells = effectiveCellTarget - cellIndex;
              final etaSeconds = remainingCells / max(0.001, cellsPerSecond);
              print(
                '[${cellIndex.toString().padLeft(5)}/$effectiveCellTarget] '
                '${cellsPerSecond.toStringAsFixed(1)} cells/s  '
                'ETA ${Duration(seconds: etaSeconds.round()).toString().split('.').first}',
              );
            }
          }
        }
      }
    }
  } finally {
    sink.close();
  }

  stopwatch.stop();
  final summaryPayload = aggregator.toJson(
    generatedAtUtc: DateTime.now().toUtc().toIso8601String(),
    durationSeconds: stopwatch.elapsed.inMilliseconds / 1000,
  );
  File(summaryPath).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(summaryPayload),
  );

  print('');
  print('Round collection complete');
  print('Manifest: $manifestPath');
  print('Cells:    $cellsPath');
  print('Summary:  $summaryPath');
  print(
    'Collected ${aggregator.cellCount} cells / '
    '${aggregator.cellCount * parsed.stepsPerCell} steps in '
    '${stopwatch.elapsed.toString().split('.').first}',
  );
}

class _Args {
  const _Args({
    required this.round,
    required this.stepsPerCell,
    required this.outputRoot,
    required this.maxCells,
    required this.progressEvery,
  });

  final int round;
  final int stepsPerCell;
  final String outputRoot;
  final int? maxCells;
  final int progressEvery;

  static _Args parse(List<String> args) {
    var round = _defaultRound;
    var stepsPerCell = _defaultStepsPerCell;
    var outputRoot = _defaultOutputRoot;
    int? maxCells;
    var progressEvery = _defaultProgressEvery;

    for (var index = 0; index < args.length; index += 1) {
      switch (args[index]) {
        case '--round':
          round = int.parse(args[++index]);
        case '--steps-per-cell':
          stepsPerCell = int.parse(args[++index]);
        case '--output-root':
          outputRoot = args[++index];
        case '--max-cells':
          maxCells = int.parse(args[++index]);
        case '--progress-every':
          progressEvery = int.parse(args[++index]);
        default:
          throw ArgumentError('Unknown argument: ${args[index]}');
      }
    }

    if (round <= 0) {
      throw ArgumentError('--round must be positive');
    }
    if (stepsPerCell <= 0) {
      throw ArgumentError('--steps-per-cell must be positive');
    }
    if (progressEvery <= 0) {
      throw ArgumentError('--progress-every must be positive');
    }

    return _Args(
      round: round,
      stepsPerCell: stepsPerCell,
      outputRoot: outputRoot,
      maxCells: maxCells,
      progressEvery: progressEvery,
    );
  }
}

class _KeyBank {
  const _KeyBank({
    required this.id,
    required this.label,
    required this.description,
    required this.selectedKeyCenters,
  });

  final String id;
  final String label;
  final String description;
  final List<KeyCenter> selectedKeyCenters;

  List<String> get activeKeys {
    final ordered = <String>[];
    final seen = <String>{};
    for (final center in selectedKeyCenters) {
      if (seen.add(center.tonicName)) {
        ordered.add(center.tonicName);
      }
    }
    return ordered;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'selectedKeyCenters': [
        for (final center in selectedKeyCenters)
          {'tonic': center.tonicName, 'mode': center.mode.name},
      ],
      'activeKeys': activeKeys,
    };
  }
}

class _AdvancedProfile {
  const _AdvancedProfile({
    required this.id,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationIntensity,
    required this.jazzPreset,
    required this.sourceProfile,
  });

  final String id;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;

  String get nonDiatonicSignature =>
      'sd${secondaryDominantEnabled ? 1 : 0}'
      '_sub${substituteDominantEnabled ? 1 : 0}'
      '_mi${modalInterchangeEnabled ? 1 : 0}';

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'secondaryDominantEnabled': secondaryDominantEnabled,
      'substituteDominantEnabled': substituteDominantEnabled,
      'modalInterchangeEnabled': modalInterchangeEnabled,
      'modulationIntensity': modulationIntensity.name,
      'jazzPreset': jazzPreset.name,
      'sourceProfile': sourceProfile.name,
      'nonDiatonicSignature': nonDiatonicSignature,
    };
  }
}

class _InversionProfile {
  const _InversionProfile({
    required this.id,
    required this.label,
    required this.settings,
  });

  final String id;
  final String label;
  final InversionSettings settings;

  List<int> get enabledInversions =>
      settings.enabled ? settings.enabledInversions : const [];

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'enabled': settings.enabled,
      'enabledInversions': enabledInversions,
    };
  }
}

class _DerivedCellStats {
  _DerivedCellStats({
    required this.chords,
    required this.keyCenters,
    required this.patternTags,
    required this.sourceKinds,
    required this.modulationKinds,
    required this.nonDiatonicFlags,
    required this.voiceLeadingScores,
    required this.chordHistogram,
    required this.bigramHistogram,
    required this.trigramHistogram,
    required this.patternStepHistogram,
    required this.sourceHistogram,
    required this.modulationKindHistogram,
    required this.nonDiatonicReasonHistogram,
    required this.nonDiatonicStepCount,
    required this.cadentialArrivalCount,
    required this.uniqueChordCount,
    required this.uniqueBigramCount,
    required this.averageVoiceLeadingScore,
  });

  final List<String> chords;
  final List<String?> keyCenters;
  final List<String?> patternTags;
  final List<String> sourceKinds;
  final List<String> modulationKinds;
  final List<bool> nonDiatonicFlags;
  final List<double?> voiceLeadingScores;
  final Map<String, int> chordHistogram;
  final Map<String, int> bigramHistogram;
  final Map<String, int> trigramHistogram;
  final Map<String, int> patternStepHistogram;
  final Map<String, int> sourceHistogram;
  final Map<String, int> modulationKindHistogram;
  final Map<String, int> nonDiatonicReasonHistogram;
  final int nonDiatonicStepCount;
  final int cadentialArrivalCount;
  final int uniqueChordCount;
  final int uniqueBigramCount;
  final double averageVoiceLeadingScore;

  static _DerivedCellStats fromSummary(SmartSimulationSummary summary) {
    final chords = <String>[];
    final keyCenters = <String?>[];
    final patternTags = <String?>[];
    final sourceKinds = <String>[];
    final modulationKinds = <String>[];
    final nonDiatonicFlags = <bool>[];
    final voiceLeadingScores = <double?>[];

    final chordHistogram = <String, int>{};
    final bigramHistogram = <String, int>{};
    final trigramHistogram = <String, int>{};
    final patternStepHistogram = <String, int>{};
    final sourceHistogram = <String, int>{};
    final modulationKindHistogram = <String, int>{};
    final nonDiatonicReasonHistogram = <String, int>{};

    var nonDiatonicStepCount = 0;
    var cadentialArrivalCount = 0;
    var voiceLeadingScoreSum = 0.0;
    var voiceLeadingScoreCount = 0;

    String? previousChord;
    String? twoBackChord;
    for (final trace in summary.traces) {
      final chord =
          trace.finalChord ??
          MusicTheory.romanTokenOf(
            trace.finalRomanNumeralId ?? trace.currentRomanNumeralId,
          );
      chords.add(chord);
      keyCenters.add(trace.finalKeyCenter);
      patternTags.add(trace.activePatternTag);
      sourceKinds.add(trace.finalSourceKind.name);
      modulationKinds.add(trace.modulationKind.name);
      nonDiatonicFlags.add(trace.finalRenderedNonDiatonic);
      voiceLeadingScores.add(trace.voiceLeadingScore);

      chordHistogram.update(chord, (value) => value + 1, ifAbsent: () => 1);
      if (previousChord != null) {
        final bigram = '$previousChord -> $chord';
        bigramHistogram.update(bigram, (value) => value + 1, ifAbsent: () => 1);
      }
      if (twoBackChord != null && previousChord != null) {
        final trigram = '$twoBackChord -> $previousChord -> $chord';
        trigramHistogram.update(
          trigram,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      twoBackChord = previousChord;
      previousChord = chord;

      final pattern = trace.activePatternTag ?? 'no_pattern';
      patternStepHistogram.update(
        pattern,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      sourceHistogram.update(
        trace.finalSourceKind.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      modulationKindHistogram.update(
        trace.modulationKind.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      if (trace.finalRenderedNonDiatonic) {
        nonDiatonicStepCount += 1;
        final reason = _primaryNonDiatonicReason(trace);
        if (reason != null) {
          nonDiatonicReasonHistogram.update(
            reason,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }
      if (trace.cadentialArrival) {
        cadentialArrivalCount += 1;
      }
      if (trace.voiceLeadingScore != null) {
        voiceLeadingScoreSum += trace.voiceLeadingScore!;
        voiceLeadingScoreCount += 1;
      }
    }

    return _DerivedCellStats(
      chords: chords,
      keyCenters: keyCenters,
      patternTags: patternTags,
      sourceKinds: sourceKinds,
      modulationKinds: modulationKinds,
      nonDiatonicFlags: nonDiatonicFlags,
      voiceLeadingScores: voiceLeadingScores,
      chordHistogram: chordHistogram,
      bigramHistogram: bigramHistogram,
      trigramHistogram: trigramHistogram,
      patternStepHistogram: patternStepHistogram,
      sourceHistogram: sourceHistogram,
      modulationKindHistogram: modulationKindHistogram,
      nonDiatonicReasonHistogram: nonDiatonicReasonHistogram,
      nonDiatonicStepCount: nonDiatonicStepCount,
      cadentialArrivalCount: cadentialArrivalCount,
      uniqueChordCount: chordHistogram.length,
      uniqueBigramCount: bigramHistogram.length,
      averageVoiceLeadingScore: voiceLeadingScoreCount == 0
          ? 0
          : voiceLeadingScoreSum / voiceLeadingScoreCount,
    );
  }
}

class _AggregateBucket {
  _AggregateBucket();

  int cellCount = 0;
  int totalSteps = 0;
  int modulationAttemptCount = 0;
  int modulationSuccessCount = 0;
  int fallbackCount = 0;
  int nonDiatonicStepCount = 0;
  int cadentialArrivalCount = 0;
  int directAppliedToNewTonicViolations = 0;
  double minorCenterOccupancySum = 0;
  double averageVoiceLeadingScoreSum = 0;
  int uniqueChordCountSum = 0;
  int uniqueBigramCountSum = 0;

  final Map<String, int> chordHistogram = <String, int>{};
  final Map<String, int> bigramHistogram = <String, int>{};
  final Map<String, int> patternHistogram = <String, int>{};
  final Map<String, int> nonDiatonicReasonHistogram = <String, int>{};

  void add({
    required SmartSimulationSummary summary,
    required _DerivedCellStats derived,
  }) {
    cellCount += 1;
    totalSteps += summary.steps;
    modulationAttemptCount += summary.modulationAttemptCount;
    modulationSuccessCount += summary.modulationSuccessCount;
    fallbackCount += summary.fallbackCount;
    nonDiatonicStepCount += derived.nonDiatonicStepCount;
    cadentialArrivalCount += derived.cadentialArrivalCount;
    directAppliedToNewTonicViolations +=
        summary.directAppliedToNewTonicViolations;
    minorCenterOccupancySum += summary.minorCenterOccupancy;
    averageVoiceLeadingScoreSum += derived.averageVoiceLeadingScore;
    uniqueChordCountSum += derived.uniqueChordCount;
    uniqueBigramCountSum += derived.uniqueBigramCount;

    _mergeHistogram(chordHistogram, derived.chordHistogram);
    _mergeHistogram(bigramHistogram, derived.bigramHistogram);
    _mergeHistogram(patternHistogram, derived.patternStepHistogram);
    _mergeHistogram(
      nonDiatonicReasonHistogram,
      derived.nonDiatonicReasonHistogram,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cellCount': cellCount,
      'totalSteps': totalSteps,
      'modulationAttemptRate': _safeRatio(
        modulationAttemptCount,
        totalSteps,
      ).toStringAsFixed(6),
      'modulationSuccessRate': _safeRatio(
        modulationSuccessCount,
        totalSteps,
      ).toStringAsFixed(6),
      'fallbackRate': _safeRatio(fallbackCount, totalSteps).toStringAsFixed(6),
      'nonDiatonicStepRate': _safeRatio(
        nonDiatonicStepCount,
        totalSteps,
      ).toStringAsFixed(6),
      'cadentialArrivalRate': _safeRatio(
        cadentialArrivalCount,
        totalSteps,
      ).toStringAsFixed(6),
      'directAppliedToNewTonicViolations': directAppliedToNewTonicViolations,
      'averageMinorCenterOccupancy': cellCount == 0
          ? '0.000000'
          : (minorCenterOccupancySum / cellCount).toStringAsFixed(6),
      'averageVoiceLeadingScore': cellCount == 0
          ? '0.000000'
          : (averageVoiceLeadingScoreSum / cellCount).toStringAsFixed(6),
      'averageUniqueChordCount': cellCount == 0
          ? '0.000000'
          : (uniqueChordCountSum / cellCount).toStringAsFixed(6),
      'averageUniqueBigramCount': cellCount == 0
          ? '0.000000'
          : (uniqueBigramCountSum / cellCount).toStringAsFixed(6),
      'topChords': _topEntriesJson(chordHistogram, _topLimit),
      'topBigrams': _topEntriesJson(bigramHistogram, _topLimit),
      'topPatterns': _topEntriesJson(patternHistogram, _topLimit),
      'nonDiatonicReasons': _sortedStringHistogram(nonDiatonicReasonHistogram),
    };
  }
}

class _RoundAggregator {
  _RoundAggregator({
    required this.round,
    required this.stepsPerCell,
    required this.totalPlannedCells,
    required this.totalEffectiveCells,
    required this.keyBanks,
    required this.advancedProfiles,
    required this.inversionProfiles,
  });

  final int round;
  final int stepsPerCell;
  final int totalPlannedCells;
  final int totalEffectiveCells;
  final List<_KeyBank> keyBanks;
  final List<_AdvancedProfile> advancedProfiles;
  final List<_InversionProfile> inversionProfiles;

  int cellCount = 0;
  int totalSteps = 0;
  int modulationAttemptCount = 0;
  int modulationSuccessCount = 0;
  int fallbackCount = 0;
  int nonDiatonicStepCount = 0;
  int cadentialArrivalCount = 0;
  int directAppliedToNewTonicViolations = 0;
  double averageVoiceLeadingScoreSum = 0;
  double minorCenterOccupancySum = 0;
  int uniqueChordCountSum = 0;
  int uniqueBigramCountSum = 0;

  final Map<String, int> chordHistogram = <String, int>{};
  final Map<String, int> bigramHistogram = <String, int>{};
  final Map<String, int> trigramHistogram = <String, int>{};
  final Map<String, int> patternHistogram = <String, int>{};
  final Map<String, int> sourceHistogram = <String, int>{};
  final Map<String, int> modulationKindHistogram = <String, int>{};
  final Map<String, int> nonDiatonicReasonHistogram = <String, int>{};
  final Map<String, int> qaPassHistogram = <String, int>{};
  final Map<String, int> qaWarnHistogram = <String, int>{};
  final Map<String, int> qaFailHistogram = <String, int>{};

  final Map<String, _AggregateBucket> byKeyBank = <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> byJazzPreset =
      <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> bySourceProfile =
      <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> byModulationIntensity =
      <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> byAllowV7sus4 =
      <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> byInversionProfile =
      <String, _AggregateBucket>{};
  final Map<String, _AggregateBucket> byNonDiatonicSignature =
      <String, _AggregateBucket>{};

  void record({
    required _KeyBank keyBank,
    required _AdvancedProfile advanced,
    required bool allowV7sus4,
    required _InversionProfile inversion,
    required SmartSimulationSummary summary,
    required _DerivedCellStats derived,
  }) {
    cellCount += 1;
    totalSteps += summary.steps;
    modulationAttemptCount += summary.modulationAttemptCount;
    modulationSuccessCount += summary.modulationSuccessCount;
    fallbackCount += summary.fallbackCount;
    nonDiatonicStepCount += derived.nonDiatonicStepCount;
    cadentialArrivalCount += derived.cadentialArrivalCount;
    directAppliedToNewTonicViolations +=
        summary.directAppliedToNewTonicViolations;
    averageVoiceLeadingScoreSum += derived.averageVoiceLeadingScore;
    minorCenterOccupancySum += summary.minorCenterOccupancy;
    uniqueChordCountSum += derived.uniqueChordCount;
    uniqueBigramCountSum += derived.uniqueBigramCount;

    _mergeHistogram(chordHistogram, derived.chordHistogram);
    _mergeHistogram(bigramHistogram, derived.bigramHistogram);
    _mergeHistogram(trigramHistogram, derived.trigramHistogram);
    _mergeHistogram(patternHistogram, derived.patternStepHistogram);
    _mergeHistogram(sourceHistogram, derived.sourceHistogram);
    _mergeHistogram(modulationKindHistogram, derived.modulationKindHistogram);
    _mergeHistogram(
      nonDiatonicReasonHistogram,
      derived.nonDiatonicReasonHistogram,
    );

    for (final check in summary.qaChecks) {
      switch (check.status) {
        case SmartQaStatus.pass:
          qaPassHistogram.update(
            check.id,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        case SmartQaStatus.warn:
          qaWarnHistogram.update(
            check.id,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        case SmartQaStatus.fail:
          qaFailHistogram.update(
            check.id,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
      }
    }

    _bucket(byKeyBank, keyBank.id).add(summary: summary, derived: derived);
    _bucket(
      byJazzPreset,
      advanced.jazzPreset.name,
    ).add(summary: summary, derived: derived);
    _bucket(
      bySourceProfile,
      advanced.sourceProfile.name,
    ).add(summary: summary, derived: derived);
    _bucket(
      byModulationIntensity,
      advanced.modulationIntensity.name,
    ).add(summary: summary, derived: derived);
    _bucket(
      byAllowV7sus4,
      allowV7sus4.toString(),
    ).add(summary: summary, derived: derived);
    _bucket(
      byInversionProfile,
      inversion.id,
    ).add(summary: summary, derived: derived);
    _bucket(
      byNonDiatonicSignature,
      advanced.nonDiatonicSignature,
    ).add(summary: summary, derived: derived);
  }

  Map<String, Object?> toJson({
    required String generatedAtUtc,
    required double durationSeconds,
  }) {
    return {
      'round': round,
      'generatedAtUtc': generatedAtUtc,
      'durationSeconds': durationSeconds.toStringAsFixed(3),
      'stepsPerCell': stepsPerCell,
      'cellCount': cellCount,
      'totalPlannedCells': totalPlannedCells,
      'totalEffectiveCells': totalEffectiveCells,
      'totalSteps': totalSteps,
      'modulationAttemptRate': _safeRatio(
        modulationAttemptCount,
        totalSteps,
      ).toStringAsFixed(6),
      'modulationSuccessRate': _safeRatio(
        modulationSuccessCount,
        totalSteps,
      ).toStringAsFixed(6),
      'fallbackRate': _safeRatio(fallbackCount, totalSteps).toStringAsFixed(6),
      'nonDiatonicStepRate': _safeRatio(
        nonDiatonicStepCount,
        totalSteps,
      ).toStringAsFixed(6),
      'cadentialArrivalRate': _safeRatio(
        cadentialArrivalCount,
        totalSteps,
      ).toStringAsFixed(6),
      'directAppliedToNewTonicViolations': directAppliedToNewTonicViolations,
      'averageMinorCenterOccupancy': cellCount == 0
          ? '0.000000'
          : (minorCenterOccupancySum / cellCount).toStringAsFixed(6),
      'averageVoiceLeadingScore': cellCount == 0
          ? '0.000000'
          : (averageVoiceLeadingScoreSum / cellCount).toStringAsFixed(6),
      'averageUniqueChordCount': cellCount == 0
          ? '0.000000'
          : (uniqueChordCountSum / cellCount).toStringAsFixed(6),
      'averageUniqueBigramCount': cellCount == 0
          ? '0.000000'
          : (uniqueBigramCountSum / cellCount).toStringAsFixed(6),
      'topChords': _topEntriesJson(chordHistogram, _topLimit),
      'topBigrams': _topEntriesJson(bigramHistogram, _topLimit),
      'topTrigrams': _topEntriesJson(trigramHistogram, _topLimit),
      'topPatterns': _topEntriesJson(patternHistogram, _topLimit),
      'sourceHistogram': _sortedStringHistogram(sourceHistogram),
      'modulationKindHistogram': _sortedStringHistogram(
        modulationKindHistogram,
      ),
      'nonDiatonicReasonHistogram': _sortedStringHistogram(
        nonDiatonicReasonHistogram,
      ),
      'qaStatusHistogram': {
        'pass': _sortedStringHistogram(qaPassHistogram),
        'warn': _sortedStringHistogram(qaWarnHistogram),
        'fail': _sortedStringHistogram(qaFailHistogram),
      },
      'axisSummaries': {
        'keyBank': _bucketsToJson(byKeyBank),
        'jazzPreset': _bucketsToJson(byJazzPreset),
        'sourceProfile': _bucketsToJson(bySourceProfile),
        'modulationIntensity': _bucketsToJson(byModulationIntensity),
        'allowV7sus4': _bucketsToJson(byAllowV7sus4),
        'inversionProfile': _bucketsToJson(byInversionProfile),
        'nonDiatonicSignature': _bucketsToJson(byNonDiatonicSignature),
      },
    };
  }

  _AggregateBucket _bucket(Map<String, _AggregateBucket> target, String key) {
    return target.putIfAbsent(key, _AggregateBucket.new);
  }
}

Map<String, Object?> _buildCellRow({
  required String cellId,
  required int round,
  required int seed,
  required int stepsPerCell,
  required _KeyBank keyBank,
  required _AdvancedProfile advanced,
  required bool allowV7sus4,
  required _InversionProfile inversion,
  required SmartSimulationSummary summary,
  required _DerivedCellStats derived,
}) {
  return {
    'cellId': cellId,
    'round': round,
    'seed': seed,
    'steps': stepsPerCell,
    'settingKey':
        '${keyBank.id}|${advanced.id}|sus${allowV7sus4 ? 1 : 0}|${inversion.id}',
    'setting': {
      'keyBank': keyBank.toJson(),
      'advanced': advanced.toJson(),
      'allowV7sus4': allowV7sus4,
      'inversion': inversion.toJson(),
    },
    'metrics': {
      'traceCount': summary.traces.length,
      'modulationAttemptCount': summary.modulationAttemptCount,
      'modulationSuccessCount': summary.modulationSuccessCount,
      'modalBranchCount': summary.modalBranchCount,
      'appliedDominantInsertionCount': summary.appliedDominantInsertionCount,
      'fallbackCount': summary.fallbackCount,
      'tonicizationCount': summary.tonicizationCount,
      'realModulationCount': summary.realModulationCount,
      'nonDiatonicStepCount': derived.nonDiatonicStepCount,
      'cadentialArrivalCount': derived.cadentialArrivalCount,
      'minorCenterOccupancy': summary.minorCenterOccupancy.toStringAsFixed(6),
      'directAppliedToNewTonicViolations':
          summary.directAppliedToNewTonicViolations,
      'uniqueChordCount': derived.uniqueChordCount,
      'uniqueBigramCount': derived.uniqueBigramCount,
      'averageVoiceLeadingScore': derived.averageVoiceLeadingScore
          .toStringAsFixed(6),
    },
    'histograms': {
      'familyStartHistogram': _sortedStringHistogram(summary.familyHistogram),
      'familyLengthHistogram': _sortedIntHistogram(
        summary.familyLengthHistogram,
      ),
      'cadenceHistogram': _sortedStringHistogram(summary.cadenceHistogram),
      'blockedReasonHistogram': {
        for (final entry in summary.blockedReasonHistogram.entries)
          entry.key.name: entry.value,
      },
      'modulationRelationHistogram': _sortedStringHistogram(
        summary.modulationRelationHistogram,
      ),
      'phraseRoleModulationHistogram': _sortedStringHistogram(
        summary.phraseRoleModulationHistogram,
      ),
      'dominantIntentHistogram': _sortedStringHistogram(
        summary.dominantIntentHistogram,
      ),
      'v7SurfaceHistogram': _sortedStringHistogram(summary.v7SurfaceHistogram),
      'rareColorUsage': _sortedStringHistogram(summary.rareColorUsage),
      'patternStepHistogram': _sortedStringHistogram(
        derived.patternStepHistogram,
      ),
      'sourceHistogram': _sortedStringHistogram(derived.sourceHistogram),
      'modulationKindHistogram': _sortedStringHistogram(
        derived.modulationKindHistogram,
      ),
      'nonDiatonicReasonHistogram': _sortedStringHistogram(
        derived.nonDiatonicReasonHistogram,
      ),
    },
    'qaChecks': [for (final check in summary.qaChecks) check.toJson()],
    'sequence': {
      'chords': derived.chords,
      'keyCenters': derived.keyCenters,
      'patternTags': derived.patternTags,
      'sourceKinds': derived.sourceKinds,
      'modulationKinds': derived.modulationKinds,
      'nonDiatonicFlags': derived.nonDiatonicFlags,
      'voiceLeadingScores': derived.voiceLeadingScores,
    },
  };
}

List<_KeyBank> _buildKeyBanks() {
  return const [
    _KeyBank(
      id: 'c_major_only',
      label: 'C major only',
      description: 'Single major tonic bank',
      selectedKeyCenters: [KeyCenter(tonicName: 'C', mode: KeyMode.major)],
    ),
    _KeyBank(
      id: 'c_minor_only',
      label: 'C minor only',
      description: 'Single minor tonic bank',
      selectedKeyCenters: [KeyCenter(tonicName: 'C', mode: KeyMode.minor)],
    ),
    _KeyBank(
      id: 'c_major_a_minor',
      label: 'C major + A minor',
      description: 'Relative major/minor bank',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      ],
    ),
    _KeyBank(
      id: 'c_major_g_major',
      label: 'C major + G major',
      description: 'Dominant-side bank',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'G', mode: KeyMode.major),
      ],
    ),
    _KeyBank(
      id: 'c_major_eb_major',
      label: 'C major + Eb major',
      description: 'Chromatic mediant bank',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'D#/Eb', mode: KeyMode.major),
      ],
    ),
    _KeyBank(
      id: 'c_major_gb_major',
      label: 'C major + Gb major',
      description: 'Distant tritone bank',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'F#/Gb', mode: KeyMode.major),
      ],
    ),
    _KeyBank(
      id: 'c_e_ab_cycle',
      label: 'C major + E major + Ab major',
      description: 'Coltrane-cycle bank',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'E', mode: KeyMode.major),
        KeyCenter(tonicName: 'G#/Ab', mode: KeyMode.major),
      ],
    ),
    _KeyBank(
      id: 'mixed_relations',
      label: 'C major + A minor + G major + Eb major + Gb major',
      description:
          'Mixed bank covering relative, dominant, mediant, and distant',
      selectedKeyCenters: [
        KeyCenter(tonicName: 'C', mode: KeyMode.major),
        KeyCenter(tonicName: 'A', mode: KeyMode.minor),
        KeyCenter(tonicName: 'G', mode: KeyMode.major),
        KeyCenter(tonicName: 'D#/Eb', mode: KeyMode.major),
        KeyCenter(tonicName: 'F#/Gb', mode: KeyMode.major),
      ],
    ),
  ];
}

List<_AdvancedProfile> _buildAdvancedProfiles() {
  final profiles = <_AdvancedProfile>[];
  for (final secondaryDominantEnabled in const [false, true]) {
    for (final substituteDominantEnabled in const [false, true]) {
      for (final modalInterchangeEnabled in const [false, true]) {
        for (final modulationIntensity in ModulationIntensity.values) {
          for (final jazzPreset in JazzPreset.values) {
            for (final sourceProfile in SourceProfile.values) {
              final id =
                  'sd${secondaryDominantEnabled ? 1 : 0}'
                  '_sub${substituteDominantEnabled ? 1 : 0}'
                  '_mi${modalInterchangeEnabled ? 1 : 0}'
                  '__mod_${modulationIntensity.name}'
                  '__preset_${jazzPreset.name}'
                  '__source_${sourceProfile.name}';
              profiles.add(
                _AdvancedProfile(
                  id: id,
                  secondaryDominantEnabled: secondaryDominantEnabled,
                  substituteDominantEnabled: substituteDominantEnabled,
                  modalInterchangeEnabled: modalInterchangeEnabled,
                  modulationIntensity: modulationIntensity,
                  jazzPreset: jazzPreset,
                  sourceProfile: sourceProfile,
                ),
              );
            }
          }
        }
      }
    }
  }
  return profiles;
}

List<_InversionProfile> _buildInversionProfiles() {
  const enabledSets = <List<int>>[
    [],
    [1],
    [2],
    [3],
    [1, 2],
    [1, 3],
    [2, 3],
    [1, 2, 3],
  ];
  return [
    for (final enabled in enabledSets)
      _InversionProfile(
        id: enabled.isEmpty ? 'disabled' : 'inv_${enabled.join()}',
        label: enabled.isEmpty ? 'Disabled' : 'Enabled ${enabled.join(",")}',
        settings: InversionSettings(
          enabled: enabled.isNotEmpty,
          firstInversionEnabled: enabled.contains(1),
          secondInversionEnabled: enabled.contains(2),
          thirdInversionEnabled: enabled.contains(3),
        ),
      ),
  ];
}

int _seedForCell({required int round, required int cellIndex}) {
  return round * 1000003 + cellIndex * 7919 + 17;
}

String? _primaryNonDiatonicReason(SmartDecisionTrace trace) {
  if (!trace.finalRenderedNonDiatonic) {
    return null;
  }
  if (trace.modulationKind == ModulationKind.real) {
    return 'real_modulation';
  }
  if (trace.modulationKind == ModulationKind.tonicization) {
    return 'tonicization';
  }
  if (trace.finalSourceKind != ChordSourceKind.diatonic) {
    return 'borrowed_or_applied_source';
  }
  if (trace.finalRenderQuality == ChordQuality.dominant7Alt ||
      trace.finalRenderQuality == ChordQuality.dominant7Sharp11) {
    return 'altered_dominant_color';
  }
  return 'other_rendered_non_diatonic';
}

double _safeRatio(int numerator, int denominator) {
  if (denominator == 0) {
    return 0;
  }
  return numerator / denominator;
}

void _mergeHistogram<K>(Map<K, int> target, Map<K, int> source) {
  for (final entry in source.entries) {
    target.update(
      entry.key,
      (value) => value + entry.value,
      ifAbsent: () => entry.value,
    );
  }
}

Map<String, int> _sortedStringHistogram(Map<String, int> histogram) {
  final entries = histogram.entries.toList()
    ..sort((left, right) {
      final byValue = right.value.compareTo(left.value);
      if (byValue != 0) {
        return byValue;
      }
      return left.key.compareTo(right.key);
    });
  return {for (final entry in entries) entry.key: entry.value};
}

Map<String, int> _sortedIntHistogram(Map<int, int> histogram) {
  final entries = histogram.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return {for (final entry in entries) entry.key.toString(): entry.value};
}

List<Map<String, Object?>> _topEntriesJson(
  Map<String, int> histogram,
  int limit,
) {
  final entries = histogram.entries.toList()
    ..sort((left, right) {
      final byValue = right.value.compareTo(left.value);
      if (byValue != 0) {
        return byValue;
      }
      return left.key.compareTo(right.key);
    });
  return [
    for (final entry in entries.take(limit))
      {'label': entry.key, 'count': entry.value},
  ];
}

Map<String, Object?> _bucketsToJson(Map<String, _AggregateBucket> buckets) {
  final keys = buckets.keys.toList()..sort();
  return {for (final key in keys) key: buckets[key]!.toJson()};
}

