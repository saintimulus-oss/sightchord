// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/smart_generator.dart';

const _defaultSeeds = <int>[101, 211, 307, 401, 509];
const _defaultSteps = 2400;
const _targetFamilies = <String>[
  'chromatic_mediant_common_tone_modulation',
  'coltrane_burst',
  'backdoor_recursive_prep',
  'common_chord_modulation',
];

void main(List<String> args) {
  final parsed = _Args.parse(args);
  final scenarios = _buildScenarios(
    includeIntensitySweep: parsed.includeIntensitySweep,
  );
  final reports = <_ScenarioReport>[
    for (final scenario in scenarios)
      _runScenario(scenario, steps: parsed.steps, seeds: parsed.seeds),
  ];

  _printOverview(reports);
  for (final report in reports) {
    _printDetailedReport(report);
  }

  if (parsed.jsonOut != null) {
    final file = File(parsed.jsonOut!);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'stepsPerSeed': parsed.steps,
        'seeds': parsed.seeds,
        'reports': [for (final report in reports) report.toJson()],
      }),
    );
    print('');
    print('Wrote JSON report to ${file.path}');
  }
}

class _Args {
  const _Args({
    required this.steps,
    required this.seeds,
    required this.includeIntensitySweep,
    required this.jsonOut,
  });

  final int steps;
  final List<int> seeds;
  final bool includeIntensitySweep;
  final String? jsonOut;

  static _Args parse(List<String> args) {
    var steps = _defaultSteps;
    var seeds = _defaultSeeds;
    var includeIntensitySweep = true;
    String? jsonOut;

    for (var index = 0; index < args.length; index += 1) {
      final arg = args[index];
      switch (arg) {
        case '--steps':
          steps = int.parse(args[++index]);
        case '--seeds':
          seeds = args[++index]
              .split(',')
              .where((token) => token.trim().isNotEmpty)
              .map((token) => int.parse(token.trim()))
              .toList(growable: false);
        case '--json-out':
          jsonOut = args[++index];
        case '--skip-intensity-sweep':
          includeIntensitySweep = false;
        default:
          throw ArgumentError('Unknown argument: $arg');
      }
    }

    return _Args(
      steps: steps,
      seeds: seeds,
      includeIntensitySweep: includeIntensitySweep,
      jsonOut: jsonOut,
    );
  }
}

class _Scenario {
  const _Scenario({
    required this.id,
    required this.keysLabel,
    required this.activeKeys,
    required this.selectedKeyCenters,
    required this.jazzPreset,
    required this.sourceProfile,
    required this.modulationIntensity,
  });

  final String id;
  final String keysLabel;
  final List<String> activeKeys;
  final List<KeyCenter> selectedKeyCenters;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final ModulationIntensity modulationIntensity;

  String get label =>
      '${jazzPreset.name}/${sourceProfile.name}/$keysLabel/${modulationIntensity.name}';
}

class _RunResult {
  const _RunResult({
    required this.seed,
    required this.summary,
    required this.metrics,
  });

  final int seed;
  final SmartSimulationSummary summary;
  final _RunMetrics metrics;
}

class _RunMetrics {
  const _RunMetrics({
    required this.familyStepHistogram,
    required this.romanTokenHistogram,
    required this.nonDiatonicPrimaryBreakdown,
    required this.nonDiatonicCount,
    required this.diatonicCount,
    required this.cadenceCount,
    required this.queuedFamilyStepCount,
    required this.stepRepeatedPatternCount,
    required this.stepTransitionCount,
    required this.startRepeatedPatternCount,
    required this.startTransitionCount,
    required this.targetFamilies,
  });

  final Map<String, int> familyStepHistogram;
  final Map<String, int> romanTokenHistogram;
  final Map<String, int> nonDiatonicPrimaryBreakdown;
  final int nonDiatonicCount;
  final int diatonicCount;
  final int cadenceCount;
  final int queuedFamilyStepCount;
  final int stepRepeatedPatternCount;
  final int stepTransitionCount;
  final int startRepeatedPatternCount;
  final int startTransitionCount;
  final Map<String, _TargetFamilyRunStat> targetFamilies;
}

class _TargetFamilyRunStat {
  const _TargetFamilyRunStat({
    required this.startCount,
    required this.stepCount,
    required this.sectionHistogram,
  });

  final int startCount;
  final int stepCount;
  final Map<String, int> sectionHistogram;
}

class _TargetFamilyAggregate {
  const _TargetFamilyAggregate({
    required this.startCount,
    required this.stepCount,
    required this.seedsWithStart,
    required this.seedsWithStep,
    required this.sectionHistogram,
  });

  final int startCount;
  final int stepCount;
  final int seedsWithStart;
  final int seedsWithStep;
  final Map<String, int> sectionHistogram;

  Map<String, Object?> toJson() {
    return {
      'startCount': startCount,
      'stepCount': stepCount,
      'seedsWithStart': seedsWithStart,
      'seedsWithStep': seedsWithStep,
      'sectionHistogram': sectionHistogram,
    };
  }
}

class _QaRollup {
  const _QaRollup({
    required this.passCount,
    required this.warnCount,
    required this.failCount,
  });

  final int passCount;
  final int warnCount;
  final int failCount;

  Map<String, Object?> toJson() {
    return {
      'passCount': passCount,
      'warnCount': warnCount,
      'failCount': failCount,
    };
  }
}

class _ScenarioReport {
  const _ScenarioReport({
    required this.scenario,
    required this.seeds,
    required this.stepsPerSeed,
    required this.totalSteps,
    required this.diatonicCount,
    required this.nonDiatonicCount,
    required this.nonDiatonicPrimaryBreakdown,
    required this.tonicizationCount,
    required this.realModulationCount,
    required this.modulationRelationHistogram,
    required this.cadenceCount,
    required this.cadenceHistogram,
    required this.familyStartHistogram,
    required this.familyStepHistogram,
    required this.familyLengthHistogram,
    required this.stepRepeatedPatternCount,
    required this.stepTransitionCount,
    required this.startRepeatedPatternCount,
    required this.startTransitionCount,
    required this.queuedFamilyStepCount,
    required this.romanTokenHistogram,
    required this.blockedReasonHistogram,
    required this.fallbackCount,
    required this.qaChecks,
    required this.chromaticMediantPayoffCount,
    required this.chromaticMediantFailedPayoffCount,
    required this.returnHomeDebtOpenCount,
    required this.returnHomeDebtPayoffCount,
    required this.returnHomeOpportunityCount,
    required this.returnHomeSelectionCount,
    required this.v7SurfaceHistogram,
    required this.returnHomeMissedOpportunityReasons,
    required this.returnHomeMissedOpportunityFamilies,
    required this.directAppliedToNewTonicViolations,
    required this.targetFamilies,
  });

  final _Scenario scenario;
  final List<int> seeds;
  final int stepsPerSeed;
  final int totalSteps;
  final int diatonicCount;
  final int nonDiatonicCount;
  final Map<String, int> nonDiatonicPrimaryBreakdown;
  final int tonicizationCount;
  final int realModulationCount;
  final Map<String, int> modulationRelationHistogram;
  final int cadenceCount;
  final Map<String, int> cadenceHistogram;
  final Map<String, int> familyStartHistogram;
  final Map<String, int> familyStepHistogram;
  final Map<int, int> familyLengthHistogram;
  final int stepRepeatedPatternCount;
  final int stepTransitionCount;
  final int startRepeatedPatternCount;
  final int startTransitionCount;
  final int queuedFamilyStepCount;
  final Map<String, int> romanTokenHistogram;
  final Map<String, int> blockedReasonHistogram;
  final int fallbackCount;
  final Map<String, _QaRollup> qaChecks;
  final int chromaticMediantPayoffCount;
  final int chromaticMediantFailedPayoffCount;
  final int returnHomeDebtOpenCount;
  final int returnHomeDebtPayoffCount;
  final int returnHomeOpportunityCount;
  final int returnHomeSelectionCount;
  final Map<String, int> v7SurfaceHistogram;
  final Map<String, int> returnHomeMissedOpportunityReasons;
  final Map<String, int> returnHomeMissedOpportunityFamilies;
  final int directAppliedToNewTonicViolations;
  final Map<String, _TargetFamilyAggregate> targetFamilies;

  double get diatonicRatio => diatonicCount / max(1, totalSteps);
  double get nonDiatonicRatio => nonDiatonicCount / max(1, totalSteps);
  double get cadenceRatio => cadenceCount / max(1, totalSteps);
  double get queuedFamilyStepRatio =>
      queuedFamilyStepCount / max(1, totalSteps);
  double get stepRepeatedPatternRatio =>
      stepRepeatedPatternCount / max(1, stepTransitionCount);
  double get startRepeatedPatternRatio =>
      startRepeatedPatternCount / max(1, startTransitionCount);
  double get tonicizationRatio => tonicizationCount / max(1, totalSteps);
  double get realModulationRatio => realModulationCount / max(1, totalSteps);
  double get fallbackRatio => fallbackCount / max(1, totalSteps);

  Map<String, Object?> toJson() {
    return {
      'scenario': {
        'id': scenario.id,
        'label': scenario.label,
        'jazzPreset': scenario.jazzPreset.name,
        'sourceProfile': scenario.sourceProfile.name,
        'keysLabel': scenario.keysLabel,
        'modulationIntensity': scenario.modulationIntensity.name,
        'activeKeys': scenario.activeKeys,
      },
      'seeds': seeds,
      'stepsPerSeed': stepsPerSeed,
      'totalSteps': totalSteps,
      'diatonicCount': diatonicCount,
      'nonDiatonicCount': nonDiatonicCount,
      'diatonicRatio': diatonicRatio,
      'nonDiatonicRatio': nonDiatonicRatio,
      'nonDiatonicPrimaryBreakdown': nonDiatonicPrimaryBreakdown,
      'tonicizationCount': tonicizationCount,
      'tonicizationRatio': tonicizationRatio,
      'realModulationCount': realModulationCount,
      'realModulationRatio': realModulationRatio,
      'modulationRelationHistogram': modulationRelationHistogram,
      'cadenceCount': cadenceCount,
      'cadenceRatio': cadenceRatio,
      'cadenceHistogram': cadenceHistogram,
      'familyStartHistogram': familyStartHistogram,
      'familyStepHistogram': familyStepHistogram,
      'familyLengthHistogram': {
        for (final entry in familyLengthHistogram.entries)
          entry.key.toString(): entry.value,
      },
      'stepRepeatedPatternCount': stepRepeatedPatternCount,
      'stepTransitionCount': stepTransitionCount,
      'stepRepeatedPatternRatio': stepRepeatedPatternRatio,
      'startRepeatedPatternCount': startRepeatedPatternCount,
      'startTransitionCount': startTransitionCount,
      'startRepeatedPatternRatio': startRepeatedPatternRatio,
      'queuedFamilyStepCount': queuedFamilyStepCount,
      'queuedFamilyStepRatio': queuedFamilyStepRatio,
      'romanTokenHistogram': romanTokenHistogram,
      'blockedReasonHistogram': blockedReasonHistogram,
      'fallbackCount': fallbackCount,
      'fallbackRatio': fallbackRatio,
      'qaChecks': {
        for (final entry in qaChecks.entries) entry.key: entry.value.toJson(),
      },
      'chromaticMediantPayoffCount': chromaticMediantPayoffCount,
      'chromaticMediantFailedPayoffCount': chromaticMediantFailedPayoffCount,
      'returnHomeDebtOpenCount': returnHomeDebtOpenCount,
      'returnHomeDebtPayoffCount': returnHomeDebtPayoffCount,
      'returnHomeOpportunityCount': returnHomeOpportunityCount,
      'returnHomeSelectionCount': returnHomeSelectionCount,
      'v7SurfaceHistogram': v7SurfaceHistogram,
      'returnHomeMissedOpportunityReasons': returnHomeMissedOpportunityReasons,
      'returnHomeMissedOpportunityFamilies':
          returnHomeMissedOpportunityFamilies,
      'directAppliedToNewTonicViolations': directAppliedToNewTonicViolations,
      'targetFamilies': {
        for (final entry in targetFamilies.entries)
          entry.key: entry.value.toJson(),
      },
    };
  }
}

List<_Scenario> _buildScenarios({required bool includeIntensitySweep}) {
  final allKeys = MusicTheory.keyOptions;
  final allKeyCenters = [
    for (final key in allKeys) MusicTheory.keyCenterFor(key),
  ];
  final singleCKeys = const ['C'];
  final singleCKeyCenters = const [
    KeyCenter(tonicName: 'C', mode: KeyMode.major),
  ];

  final scenarios = <_Scenario>[
    for (final sourceProfile in SourceProfile.values) ...[
      _Scenario(
        id: 'advanced_all_keys_${sourceProfile.name}',
        keysLabel: 'allKeys',
        activeKeys: allKeys,
        selectedKeyCenters: allKeyCenters,
        jazzPreset: JazzPreset.advanced,
        sourceProfile: sourceProfile,
        modulationIntensity: ModulationIntensity.medium,
      ),
      _Scenario(
        id: 'advanced_single_c_${sourceProfile.name}',
        keysLabel: 'singleKeyC',
        activeKeys: singleCKeys,
        selectedKeyCenters: singleCKeyCenters,
        jazzPreset: JazzPreset.advanced,
        sourceProfile: sourceProfile,
        modulationIntensity: ModulationIntensity.medium,
      ),
      _Scenario(
        id: 'modulation_study_all_keys_${sourceProfile.name}',
        keysLabel: 'allKeys',
        activeKeys: allKeys,
        selectedKeyCenters: allKeyCenters,
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: sourceProfile,
        modulationIntensity: ModulationIntensity.medium,
      ),
    ],
  ];

  if (includeIntensitySweep) {
    for (final intensity in ModulationIntensity.values) {
      scenarios.add(
        _Scenario(
          id: 'advanced_all_keys_fakebook_${intensity.name}',
          keysLabel: 'allKeys',
          activeKeys: allKeys,
          selectedKeyCenters: allKeyCenters,
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.fakebookStandard,
          modulationIntensity: intensity,
        ),
      );
    }
  }

  return scenarios;
}

_ScenarioReport _runScenario(
  _Scenario scenario, {
  required int steps,
  required List<int> seeds,
}) {
  final runs = <_RunResult>[
    for (final seed in seeds)
      (() {
        final summary = SmartGeneratorHelper.simulateSteps(
          random: Random(seed),
          steps: steps,
          request: SmartStartRequest(
            activeKeys: scenario.activeKeys,
            selectedKeyCenters: scenario.selectedKeyCenters,
            secondaryDominantEnabled: true,
            substituteDominantEnabled: true,
            modalInterchangeEnabled: true,
            modulationIntensity: scenario.modulationIntensity,
            jazzPreset: scenario.jazzPreset,
            sourceProfile: scenario.sourceProfile,
            smartDiagnosticsEnabled: true,
          ),
        );
        return _RunResult(
          seed: seed,
          summary: summary,
          metrics: _metricsForSummary(summary),
        );
      })(),
  ];

  final familyStartHistogram = <String, int>{};
  final familyStepHistogram = <String, int>{};
  final familyLengthHistogram = <int, int>{};
  final modulationRelationHistogram = <String, int>{};
  final cadenceHistogram = <String, int>{};
  final romanTokenHistogram = <String, int>{};
  final blockedReasonHistogram = <String, int>{};
  final nonDiatonicPrimaryBreakdown = <String, int>{};
  final qaChecks = <String, _QaRollup>{};
  final targetFamilies = <String, _TargetFamilyAggregate>{};
  final v7SurfaceHistogram = <String, int>{};
  final returnHomeMissedOpportunityReasons = <String, int>{};
  final returnHomeMissedOpportunityFamilies = <String, int>{};

  var totalSteps = 0;
  var diatonicCount = 0;
  var nonDiatonicCount = 0;
  var tonicizationCount = 0;
  var realModulationCount = 0;
  var cadenceCount = 0;
  var stepRepeatedPatternCount = 0;
  var stepTransitionCount = 0;
  var startRepeatedPatternCount = 0;
  var startTransitionCount = 0;
  var queuedFamilyStepCount = 0;
  var fallbackCount = 0;
  var chromaticMediantPayoffCount = 0;
  var chromaticMediantFailedPayoffCount = 0;
  var returnHomeDebtOpenCount = 0;
  var returnHomeDebtPayoffCount = 0;
  var returnHomeOpportunityCount = 0;
  var returnHomeSelectionCount = 0;
  var directAppliedToNewTonicViolations = 0;

  for (final run in runs) {
    final summary = run.summary;
    final metrics = run.metrics;
    totalSteps += summary.steps;
    diatonicCount += metrics.diatonicCount;
    nonDiatonicCount += metrics.nonDiatonicCount;
    tonicizationCount += summary.tonicizationCount;
    realModulationCount += summary.realModulationCount;
    cadenceCount += metrics.cadenceCount;
    stepRepeatedPatternCount += metrics.stepRepeatedPatternCount;
    stepTransitionCount += metrics.stepTransitionCount;
    startRepeatedPatternCount += metrics.startRepeatedPatternCount;
    startTransitionCount += metrics.startTransitionCount;
    queuedFamilyStepCount += metrics.queuedFamilyStepCount;
    fallbackCount += summary.fallbackCount;
    chromaticMediantPayoffCount += summary.chromaticMediantPayoffCount;
    chromaticMediantFailedPayoffCount +=
        summary.chromaticMediantFailedPayoffCount;
    returnHomeDebtOpenCount += summary.returnHomeDebtOpenCount;
    returnHomeDebtPayoffCount += summary.returnHomeDebtPayoffCount;
    returnHomeOpportunityCount += summary.returnHomeOpportunityCount;
    returnHomeSelectionCount += summary.returnHomeSelectionCount;
    directAppliedToNewTonicViolations +=
        summary.directAppliedToNewTonicViolations;
    _mergeHistogram(v7SurfaceHistogram, summary.v7SurfaceHistogram);
    _mergeHistogram(
      returnHomeMissedOpportunityReasons,
      summary.returnHomeMissedOpportunityReasons,
    );
    _mergeHistogram(
      returnHomeMissedOpportunityFamilies,
      summary.returnHomeMissedOpportunityFamilies,
    );

    _mergeHistogram(familyStartHistogram, summary.familyHistogram);
    _mergeHistogram(familyStepHistogram, metrics.familyStepHistogram);
    _mergeHistogram(familyLengthHistogram, summary.familyLengthHistogram);
    _mergeHistogram(
      modulationRelationHistogram,
      summary.modulationRelationHistogram,
    );
    _mergeHistogram(cadenceHistogram, summary.cadenceHistogram);
    _mergeHistogram(romanTokenHistogram, metrics.romanTokenHistogram);
    _mergeHistogram(
      nonDiatonicPrimaryBreakdown,
      metrics.nonDiatonicPrimaryBreakdown,
    );
    _mergeHistogram(blockedReasonHistogram, {
      for (final entry in summary.blockedReasonHistogram.entries)
        entry.key.name: entry.value,
    });
    _mergeQaRollups(qaChecks, summary.qaChecks);
    _mergeTargetFamilies(
      targetFamilies,
      metrics.targetFamilies,
      seed: run.seed,
    );
  }

  return _ScenarioReport(
    scenario: scenario,
    seeds: seeds,
    stepsPerSeed: steps,
    totalSteps: totalSteps,
    diatonicCount: diatonicCount,
    nonDiatonicCount: nonDiatonicCount,
    nonDiatonicPrimaryBreakdown: _sortedStringHistogram(
      nonDiatonicPrimaryBreakdown,
    ),
    tonicizationCount: tonicizationCount,
    realModulationCount: realModulationCount,
    modulationRelationHistogram: _sortedStringHistogram(
      modulationRelationHistogram,
    ),
    cadenceCount: cadenceCount,
    cadenceHistogram: _sortedStringHistogram(cadenceHistogram),
    familyStartHistogram: _sortedStringHistogram(familyStartHistogram),
    familyStepHistogram: _sortedStringHistogram(familyStepHistogram),
    familyLengthHistogram: _sortedIntHistogram(familyLengthHistogram),
    stepRepeatedPatternCount: stepRepeatedPatternCount,
    stepTransitionCount: stepTransitionCount,
    startRepeatedPatternCount: startRepeatedPatternCount,
    startTransitionCount: startTransitionCount,
    queuedFamilyStepCount: queuedFamilyStepCount,
    romanTokenHistogram: _sortedStringHistogram(romanTokenHistogram),
    blockedReasonHistogram: _sortedStringHistogram(blockedReasonHistogram),
    fallbackCount: fallbackCount,
    qaChecks: qaChecks,
    chromaticMediantPayoffCount: chromaticMediantPayoffCount,
    chromaticMediantFailedPayoffCount: chromaticMediantFailedPayoffCount,
    returnHomeDebtOpenCount: returnHomeDebtOpenCount,
    returnHomeDebtPayoffCount: returnHomeDebtPayoffCount,
    returnHomeOpportunityCount: returnHomeOpportunityCount,
    returnHomeSelectionCount: returnHomeSelectionCount,
    v7SurfaceHistogram: _sortedStringHistogram(v7SurfaceHistogram),
    returnHomeMissedOpportunityReasons: _sortedStringHistogram(
      returnHomeMissedOpportunityReasons,
    ),
    returnHomeMissedOpportunityFamilies: _sortedStringHistogram(
      returnHomeMissedOpportunityFamilies,
    ),
    directAppliedToNewTonicViolations: directAppliedToNewTonicViolations,
    targetFamilies: targetFamilies,
  );
}

_RunMetrics _metricsForSummary(SmartSimulationSummary summary) {
  final familyStepHistogram = <String, int>{};
  final romanTokenHistogram = <String, int>{};
  final nonDiatonicPrimaryBreakdown = <String, int>{};
  final targetFamilySections = <String, Map<String, int>>{
    for (final family in _targetFamilies) family: <String, int>{},
  };
  final targetFamilyStartCounts = <String, int>{
    for (final family in _targetFamilies) family: 0,
  };
  final targetFamilyStepCounts = <String, int>{
    for (final family in _targetFamilies) family: 0,
  };

  var nonDiatonicCount = 0;
  var diatonicCount = 0;
  var cadenceCount = 0;
  var queuedFamilyStepCount = 0;
  var stepRepeatedPatternCount = 0;
  var stepTransitionCount = 0;
  var startRepeatedPatternCount = 0;
  var startTransitionCount = 0;
  String? previousPatternTag;
  String? previousStartTag;

  for (var index = 0; index < summary.traces.length; index += 1) {
    final trace = summary.traces[index];
    final token = MusicTheory.romanTokenOf(
      trace.finalRomanNumeralId ?? trace.currentRomanNumeralId,
    );
    romanTokenHistogram.update(token, (value) => value + 1, ifAbsent: () => 1);

    final patternTag = trace.activePatternTag;
    if (patternTag != null) {
      familyStepHistogram.update(
        patternTag,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      if (_targetFamilies.contains(patternTag)) {
        targetFamilyStepCounts.update(patternTag, (value) => value + 1);
      }
    }

    if (trace.cadentialArrival) {
      cadenceCount += 1;
    }
    if (trace.decision == 'queued-family-step') {
      queuedFamilyStepCount += 1;
    }

    final nonDiatonicReason = _primaryNonDiatonicReason(trace);
    if (nonDiatonicReason == null) {
      diatonicCount += 1;
    } else {
      nonDiatonicCount += 1;
      nonDiatonicPrimaryBreakdown.update(
        nonDiatonicReason,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    if (index > 0) {
      stepTransitionCount += 1;
      if (patternTag != null && patternTag == previousPatternTag) {
        stepRepeatedPatternCount += 1;
      }
    }
    previousPatternTag = patternTag;

    if (_isFamilyStart(trace)) {
      if (previousStartTag != null) {
        startTransitionCount += 1;
        if (patternTag != null && patternTag == previousStartTag) {
          startRepeatedPatternCount += 1;
        }
      }
      previousStartTag = patternTag;
      if (patternTag != null && _targetFamilies.contains(patternTag)) {
        targetFamilyStartCounts.update(patternTag, (value) => value + 1);
        targetFamilySections[patternTag]!.update(
          trace.phraseContext.sectionRole.name,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
  }

  return _RunMetrics(
    familyStepHistogram: familyStepHistogram,
    romanTokenHistogram: romanTokenHistogram,
    nonDiatonicPrimaryBreakdown: nonDiatonicPrimaryBreakdown,
    nonDiatonicCount: nonDiatonicCount,
    diatonicCount: diatonicCount,
    cadenceCount: cadenceCount,
    queuedFamilyStepCount: queuedFamilyStepCount,
    stepRepeatedPatternCount: stepRepeatedPatternCount,
    stepTransitionCount: stepTransitionCount,
    startRepeatedPatternCount: startRepeatedPatternCount,
    startTransitionCount: startTransitionCount,
    targetFamilies: {
      for (final family in _targetFamilies)
        family: _TargetFamilyRunStat(
          startCount: targetFamilyStartCounts[family] ?? 0,
          stepCount: targetFamilyStepCounts[family] ?? 0,
          sectionHistogram: targetFamilySections[family] ?? const {},
        ),
    },
  );
}

bool _isFamilyStart(SmartDecisionTrace trace) {
  return trace.decision?.startsWith('seeded-family:') == true ||
      trace.decision?.startsWith('seeded-initial-family:') == true ||
      trace.decision == 'resolved-applied-via-real-modulation';
}

String? _primaryNonDiatonicReason(SmartDecisionTrace trace) {
  if (!trace.finalRenderedNonDiatonic) {
    return null;
  }
  if (trace.modulationKind == ModulationKind.real) {
    return 'realModulation';
  }
  if (trace.modulationKind == ModulationKind.tonicization) {
    return 'tonicization';
  }
  if (trace.finalSourceKind != ChordSourceKind.diatonic) {
    return 'borrowedOrAppliedSource';
  }
  if (trace.finalRenderQuality == ChordQuality.dominant7Alt ||
      trace.finalRenderQuality == ChordQuality.dominant7Sharp11) {
    return 'alteredDominantColor';
  }
  return 'otherRenderedNonDiatonic';
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

void _mergeQaRollups(Map<String, _QaRollup> target, List<SmartQaCheck> source) {
  final staged = <String, List<SmartQaStatus>>{};
  for (final check in source) {
    staged.putIfAbsent(check.id, () => <SmartQaStatus>[]).add(check.status);
  }
  for (final entry in staged.entries) {
    final existing = target[entry.key];
    var passCount = existing?.passCount ?? 0;
    var warnCount = existing?.warnCount ?? 0;
    var failCount = existing?.failCount ?? 0;
    for (final status in entry.value) {
      switch (status) {
        case SmartQaStatus.pass:
          passCount += 1;
        case SmartQaStatus.warn:
          warnCount += 1;
        case SmartQaStatus.fail:
          failCount += 1;
      }
    }
    target[entry.key] = _QaRollup(
      passCount: passCount,
      warnCount: warnCount,
      failCount: failCount,
    );
  }
}

void _mergeTargetFamilies(
  Map<String, _TargetFamilyAggregate> target,
  Map<String, _TargetFamilyRunStat> source, {
  required int seed,
}) {
  for (final entry in source.entries) {
    final existing = target[entry.key];
    final stat = entry.value;
    final mergedSections = <String, int>{
      ...(existing?.sectionHistogram ?? const <String, int>{}),
    };
    _mergeHistogram(mergedSections, stat.sectionHistogram);
    target[entry.key] = _TargetFamilyAggregate(
      startCount: (existing?.startCount ?? 0) + stat.startCount,
      stepCount: (existing?.stepCount ?? 0) + stat.stepCount,
      seedsWithStart:
          (existing?.seedsWithStart ?? 0) + (stat.startCount > 0 ? 1 : 0),
      seedsWithStep:
          (existing?.seedsWithStep ?? 0) + (stat.stepCount > 0 ? 1 : 0),
      sectionHistogram: _sortedStringHistogram(mergedSections),
    );
  }
}

Map<String, int> _sortedStringHistogram(Map<String, int> histogram) {
  final entries = histogram.entries.toList()
    ..sort((left, right) {
      final countCompare = right.value.compareTo(left.value);
      if (countCompare != 0) {
        return countCompare;
      }
      return left.key.compareTo(right.key);
    });
  return {for (final entry in entries) entry.key: entry.value};
}

Map<int, int> _sortedIntHistogram(Map<int, int> histogram) {
  final entries = histogram.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return {for (final entry in entries) entry.key: entry.value};
}

List<MapEntry<String, int>> _topEntries(Map<String, int> histogram, int limit) {
  return histogram.entries.take(limit).toList(growable: false);
}

String _formatPercent(num value) => '${(value * 100).toStringAsFixed(2)}%';

void _printOverview(List<_ScenarioReport> reports) {
  print('Calibration audit overview');
  print(_rule());
  print(
    '| Scenario | NonDiatonic | Tonicization | RealMod | StepRepeat | StartRepeat | Queue | Cadence | Fallback | V7 |',
  );
  print(
    '| -------- | ----------- | ------------ | ------- | ---------- | ----------- | ----- | ------- | -------- | -- |',
  );
  for (final report in reports) {
    final v7Share =
        (report.romanTokenHistogram['V7'] ?? 0) / max(1, report.totalSteps);
    print(
      '| ${report.scenario.label} '
      '| ${_formatPercent(report.nonDiatonicRatio)} '
      '| ${_formatPercent(report.tonicizationRatio)} '
      '| ${_formatPercent(report.realModulationRatio)} '
      '| ${_formatPercent(report.stepRepeatedPatternRatio)} '
      '| ${_formatPercent(report.startRepeatedPatternRatio)} '
      '| ${_formatPercent(report.queuedFamilyStepRatio)} '
      '| ${_formatPercent(report.cadenceRatio)} '
      '| ${_formatPercent(report.fallbackRatio)} '
      '| ${_formatPercent(v7Share)} |',
    );
  }
}

void _printDetailedReport(_ScenarioReport report) {
  print('');
  print(report.scenario.label);
  print(_rule());
  print(
    'Steps=${report.totalSteps} '
    'diatonic=${_formatPercent(report.diatonicRatio)} '
    'nonDiatonic=${_formatPercent(report.nonDiatonicRatio)} '
    'tonicization=${report.tonicizationCount} '
    'realMod=${report.realModulationCount} '
    'queue=${_formatPercent(report.queuedFamilyStepRatio)} '
    'stepRepeat=${_formatPercent(report.stepRepeatedPatternRatio)} '
    'startRepeat=${_formatPercent(report.startRepeatedPatternRatio)} '
    'cadence=${_formatPercent(report.cadenceRatio)} '
    'fallback=${report.fallbackCount}',
  );
  print(
    'Non-diatonic breakdown: ${jsonEncode(report.nonDiatonicPrimaryBreakdown)}',
  );
  print(
    'Modulation relations: ${jsonEncode(report.modulationRelationHistogram)}',
  );
  print(
    'Top family starts: ${jsonEncode(_entriesToJson(_topEntries(report.familyStartHistogram, 8)))}',
  );
  print(
    'Top family steps: ${jsonEncode(_entriesToJson(_topEntries(report.familyStepHistogram, 8)))}',
  );
  print(
    'Family lengths: '
    '${jsonEncode({for (final entry in report.familyLengthHistogram.entries) entry.key.toString(): entry.value})}',
  );
  print(
    'Top Roman tokens: ${jsonEncode(_entriesToJson(_topEntries(report.romanTokenHistogram, 10)))}',
  );
  print('Cadence histogram: ${jsonEncode(report.cadenceHistogram)}');
  print('Blocked reasons: ${jsonEncode(report.blockedReasonHistogram)}');
  print(
    'Return-home: open=${report.returnHomeDebtOpenCount} '
    'payoff=${report.returnHomeDebtPayoffCount} '
    'opportunity=${report.returnHomeOpportunityCount} '
    'selection=${report.returnHomeSelectionCount}',
  );
  print('V7 surface: ${jsonEncode(report.v7SurfaceHistogram)}');
  print(
    'Return-home missed opportunities: '
    '${jsonEncode(report.returnHomeMissedOpportunityReasons)}',
  );
  print(
    'Return-home missed families: '
    '${jsonEncode(report.returnHomeMissedOpportunityFamilies)}',
  );
  print(
    'Chromatic mediant payoff: payoff=${report.chromaticMediantPayoffCount} '
    'failed=${report.chromaticMediantFailedPayoffCount}',
  );
  print(
    'Direct-applied-to-new-tonic violations: '
    '${report.directAppliedToNewTonicViolations}',
  );
  print(
    'QA: ${jsonEncode({for (final entry in report.qaChecks.entries) entry.key: entry.value.toJson()})}',
  );
  print(
    'Target families: '
    '${jsonEncode({for (final entry in report.targetFamilies.entries) entry.key: entry.value.toJson()})}',
  );
}

String _rule() => '=' * 72;

List<Map<String, Object?>> _entriesToJson(List<MapEntry<String, int>> entries) {
  return [
    for (final entry in entries) {'key': entry.key, 'count': entry.value},
  ];
}

