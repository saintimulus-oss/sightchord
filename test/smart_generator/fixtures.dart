import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/inversion_settings.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/smart_generator.dart';

export 'dart:math' show Random;
export 'package:flutter_test/flutter_test.dart';
export 'package:chordest/music/chord_theory.dart';
export 'package:chordest/settings/inversion_settings.dart';
export 'package:chordest/settings/practice_settings.dart';
export 'package:chordest/smart_generator.dart';

class FixedRandom implements Random {
  FixedRandom(this.value);

  final int value;

  @override
  bool nextBool() => value.isEven;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => value % max;
}

class SequenceRandom implements Random {
  SequenceRandom(this.values);

  final List<int> values;
  int _index = 0;

  @override
  bool nextBool() => nextInt(2) == 0;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) {
    final value = values[_index % values.length];
    _index += 1;
    return value % max;
  }
}

SmartStartRequest buildStartRequest({
  List<String> activeKeys = const ['C', 'G', 'A'],
  List<KeyCenter>? selectedKeyCenters,
  bool secondaryDominantEnabled = true,
  bool substituteDominantEnabled = true,
  bool modalInterchangeEnabled = true,
  ModulationIntensity modulationIntensity = ModulationIntensity.medium,
  JazzPreset jazzPreset = JazzPreset.standardsCore,
  SourceProfile sourceProfile = SourceProfile.fakebookStandard,
  bool allowV7sus4 = true,
  bool allowTensions = true,
  ChordLanguageLevel chordLanguageLevel = ChordLanguageLevel.fullExtensions,
  RomanPoolPreset romanPoolPreset = RomanPoolPreset.expandedColor,
  Set<String>? selectedTensionOptions,
  InversionSettings inversionSettings = const InversionSettings(),
  PracticeTimeSignature timeSignature = PracticeTimeSignature.fourFour,
  HarmonicRhythmPreset harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
  bool smartDiagnosticsEnabled = true,
}) {
  return SmartStartRequest(
    activeKeys: activeKeys,
    selectedKeyCenters:
        selectedKeyCenters ??
        activeKeys.map((key) => MusicTheory.keyCenterFor(key)).toList(),
    secondaryDominantEnabled: secondaryDominantEnabled,
    substituteDominantEnabled: substituteDominantEnabled,
    modalInterchangeEnabled: modalInterchangeEnabled,
    modulationIntensity: modulationIntensity,
    jazzPreset: jazzPreset,
    sourceProfile: sourceProfile,
    allowV7sus4: allowV7sus4,
    allowTensions: allowTensions,
    chordLanguageLevel: chordLanguageLevel,
    romanPoolPreset: romanPoolPreset,
    selectedTensionOptions: selectedTensionOptions,
    inversionSettings: inversionSettings,
    timeSignature: timeSignature,
    harmonicRhythmPreset: harmonicRhythmPreset,
    smartDiagnosticsEnabled: smartDiagnosticsEnabled,
  );
}

SmartStepRequest buildRequest({
  int stepIndex = 3,
  List<String> activeKeys = const ['C', 'G', 'A'],
  List<KeyCenter>? selectedKeyCenters,
  KeyCenter? currentKeyCenter,
  RomanNumeralId currentRomanNumeralId = RomanNumeralId.iMaj69,
  RomanNumeralId? currentResolutionRomanNumeralId,
  HarmonicFunction currentHarmonicFunction = HarmonicFunction.tonic,
  bool secondaryDominantEnabled = true,
  bool substituteDominantEnabled = true,
  bool modalInterchangeEnabled = true,
  ModulationIntensity modulationIntensity = ModulationIntensity.medium,
  JazzPreset jazzPreset = JazzPreset.modulationStudy,
  SourceProfile sourceProfile = SourceProfile.fakebookStandard,
  bool smartDiagnosticsEnabled = true,
  RomanNumeralId? previousRomanNumeralId,
  HarmonicFunction? previousHarmonicFunction,
  bool previousWasAppliedDominant = false,
  String? currentPatternTag,
  List<QueuedSmartChord> plannedQueue = const [],
  bool currentRenderedNonDiatonic = false,
  SmartDecisionTrace? currentTrace,
  SmartPhraseContext? phraseContext,
}) {
  return SmartStepRequest(
    stepIndex: stepIndex,
    activeKeys: activeKeys,
    selectedKeyCenters:
        selectedKeyCenters ??
        activeKeys.map((key) => MusicTheory.keyCenterFor(key)).toList(),
    currentKeyCenter:
        currentKeyCenter ??
        const KeyCenter(tonicName: 'C', mode: KeyMode.major),
    currentRomanNumeralId: currentRomanNumeralId,
    currentResolutionRomanNumeralId: currentResolutionRomanNumeralId,
    currentHarmonicFunction: currentHarmonicFunction,
    secondaryDominantEnabled: secondaryDominantEnabled,
    substituteDominantEnabled: substituteDominantEnabled,
    modalInterchangeEnabled: modalInterchangeEnabled,
    modulationIntensity: modulationIntensity,
    jazzPreset: jazzPreset,
    sourceProfile: sourceProfile,
    smartDiagnosticsEnabled: smartDiagnosticsEnabled,
    previousRomanNumeralId: previousRomanNumeralId,
    previousHarmonicFunction: previousHarmonicFunction,
    previousWasAppliedDominant: previousWasAppliedDominant,
    currentPatternTag: currentPatternTag,
    plannedQueue: plannedQueue,
    currentRenderedNonDiatonic: currentRenderedNonDiatonic,
    currentTrace: currentTrace,
    phraseContext: phraseContext,
  );
}

void seedInitialHomeTrace({
  String tonicName = 'C',
  KeyMode mode = KeyMode.major,
}) {
  final center = KeyCenter(tonicName: tonicName, mode: mode);
  SmartDiagnosticsStore.record(
    SmartDecisionTrace(
      stepIndex: 0,
      currentKeyCenter: center.displayName,
      currentRomanNumeralId: mode == KeyMode.major
          ? RomanNumeralId.iMaj69
          : RomanNumeralId.iMin6,
      currentHarmonicFunction: HarmonicFunction.tonic,
      phraseContext: const SmartPhraseContext(
        phraseRole: PhraseRole.opener,
        sectionRole: SectionRole.aLike,
        harmonicDensity: HarmonicDensity.oneChordPerBar,
        barInPhrase: 0,
        barsToBoundary: 7,
        phraseLength: 8,
      ),
      finalKeyCenter: center.displayName,
      finalKeyMode: mode,
      finalKeyRelation: KeyRelation.same,
      decision: 'seeded-initial-tonic',
      finalRomanNumeralId: mode == KeyMode.major
          ? RomanNumeralId.iMaj69
          : RomanNumeralId.iMin6,
    ),
  );
}

const SmartPhraseContext testPhraseContext = SmartPhraseContext(
  phraseRole: PhraseRole.continuation,
  sectionRole: SectionRole.aLike,
  harmonicDensity: HarmonicDensity.oneChordPerBar,
  barInPhrase: 1,
  barsToBoundary: 6,
  phraseLength: 8,
);

SmartDecisionTrace buildTrace({
  RomanNumeralId currentRomanNumeralId = RomanNumeralId.iMaj69,
  HarmonicFunction currentHarmonicFunction = HarmonicFunction.tonic,
}) {
  return SmartDecisionTrace(
    stepIndex: 1,
    currentKeyCenter: 'C major',
    currentRomanNumeralId: currentRomanNumeralId,
    currentHarmonicFunction: currentHarmonicFunction,
    phraseContext: testPhraseContext,
  );
}

SmartSimulationSummary aggregateSimulationSummaries(
  List<SmartSimulationSummary> summaries,
) {
  assert(summaries.isNotEmpty);
  final first = summaries.first;

  int sumInt(int Function(SmartSimulationSummary summary) selector) =>
      summaries.fold<int>(0, (sum, summary) => sum + selector(summary));

  double weightedAverage(
    double Function(SmartSimulationSummary summary) selector,
  ) {
    final totalSteps = sumInt((summary) => summary.steps);
    if (totalSteps == 0) {
      return 0;
    }
    return summaries.fold<double>(
          0,
          (sum, summary) => sum + selector(summary) * summary.steps,
        ) /
        totalSteps;
  }

  Map<K, int> mergeHistogram<K>(
    Map<K, int> Function(SmartSimulationSummary summary) selector,
  ) {
    final merged = <K, int>{};
    for (final summary in summaries) {
      for (final entry in selector(summary).entries) {
        merged.update(
          entry.key,
          (value) => value + entry.value,
          ifAbsent: () => entry.value,
        );
      }
    }
    return merged;
  }

  return SmartSimulationSummary(
    jazzPreset: first.jazzPreset,
    sourceProfile: first.sourceProfile,
    modulationIntensity: first.modulationIntensity,
    steps: sumInt((summary) => summary.steps),
    modulationAttemptCount: sumInt((summary) => summary.modulationAttemptCount),
    modulationSuccessCount: sumInt((summary) => summary.modulationSuccessCount),
    blockedReasonHistogram: mergeHistogram(
      (summary) => summary.blockedReasonHistogram,
    ),
    modalBranchCount: sumInt((summary) => summary.modalBranchCount),
    appliedDominantInsertionCount: sumInt(
      (summary) => summary.appliedDominantInsertionCount,
    ),
    fallbackCount: sumInt((summary) => summary.fallbackCount),
    familyHistogram: mergeHistogram((summary) => summary.familyHistogram),
    familyLengthHistogram: mergeHistogram(
      (summary) => summary.familyLengthHistogram,
    ),
    cadenceHistogram: mergeHistogram((summary) => summary.cadenceHistogram),
    tonicizationCount: sumInt((summary) => summary.tonicizationCount),
    realModulationCount: sumInt((summary) => summary.realModulationCount),
    modulationRelationHistogram: mergeHistogram(
      (summary) => summary.modulationRelationHistogram,
    ),
    phraseRoleModulationHistogram: mergeHistogram(
      (summary) => summary.phraseRoleModulationHistogram,
    ),
    relatedIiAppliedCount: sumInt((summary) => summary.relatedIiAppliedCount),
    nakedAppliedCount: sumInt((summary) => summary.nakedAppliedCount),
    dominantIntentHistogram: mergeHistogram(
      (summary) => summary.dominantIntentHistogram,
    ),
    susReleaseCount: sumInt((summary) => summary.susReleaseCount),
    susResolutionOpportunities: sumInt(
      (summary) => summary.susResolutionOpportunities,
    ),
    bridgeIvSectionHistogram: mergeHistogram(
      (summary) => summary.bridgeIvSectionHistogram,
    ),
    bridgeIvStabilizationSuccessCount: sumInt(
      (summary) => summary.bridgeIvStabilizationSuccessCount,
    ),
    bridgeIvFallbackCount: sumInt((summary) => summary.bridgeIvFallbackCount),
    bridgeReturnSectionHistogram: mergeHistogram(
      (summary) => summary.bridgeReturnSectionHistogram,
    ),
    chromaticMediantStartCount: sumInt(
      (summary) => summary.chromaticMediantStartCount,
    ),
    chromaticMediantDensity: weightedAverage(
      (summary) => summary.chromaticMediantDensity,
    ),
    chromaticMediantPayoffCount: sumInt(
      (summary) => summary.chromaticMediantPayoffCount,
    ),
    chromaticMediantFailedPayoffCount: sumInt(
      (summary) => summary.chromaticMediantFailedPayoffCount,
    ),
    returnHomeDebtOpenCount: sumInt(
      (summary) => summary.returnHomeDebtOpenCount,
    ),
    returnHomeDebtPayoffCount: sumInt(
      (summary) => summary.returnHomeDebtPayoffCount,
    ),
    returnHomeOpportunityCount: sumInt(
      (summary) => summary.returnHomeOpportunityCount,
    ),
    returnHomeSelectionCount: sumInt(
      (summary) => summary.returnHomeSelectionCount,
    ),
    v7SurfaceHistogram: mergeHistogram((summary) => summary.v7SurfaceHistogram),
    returnHomeMissedOpportunityReasons: mergeHistogram(
      (summary) => summary.returnHomeMissedOpportunityReasons,
    ),
    returnHomeMissedOpportunityFamilies: mergeHistogram(
      (summary) => summary.returnHomeMissedOpportunityFamilies,
    ),
    minorCenterOccupancy: weightedAverage(
      (summary) => summary.minorCenterOccupancy,
    ),
    directAppliedToNewTonicViolations: sumInt(
      (summary) => summary.directAppliedToNewTonicViolations,
    ),
    rareColorUsage: mergeHistogram((summary) => summary.rareColorUsage),
    rareColorDebtOpenCount: sumInt((summary) => summary.rareColorDebtOpenCount),
    rareColorPayoffCount: sumInt((summary) => summary.rareColorPayoffCount),
    qaChecks: const <SmartQaCheck>[],
    traces: const <SmartDecisionTrace>[],
  );
}

SmartCandidateComparison compareVoiceLeading({
  required List<SmartRenderCandidate> candidates,
  GeneratedChord? previousChord,
  int seed = 0,
  bool allowV7sus4 = true,
}) {
  return SmartGeneratorHelper.compareVoiceLeadingCandidates(
    random: FixedRandom(seed),
    previousChord: previousChord,
    allowV7sus4: allowV7sus4,
    allowTensions: false,
    candidates: candidates,
  );
}

GeneratedChord realizeVoiceLed({
  required SmartRenderCandidate candidate,
  GeneratedChord? previousChord,
  int seed = 0,
}) {
  return compareVoiceLeading(
    candidates: [candidate],
    previousChord: previousChord,
    seed: seed,
  ).selected.chord;
}

SmartDecisionTrace? findRealModulationTrace({
  required String currentKeyCenter,
  required String finalKeyCenter,
  required List<String> activeKeys,
  JazzPreset jazzPreset = JazzPreset.standardsCore,
  int maxSeeds = 24,
  int steps = 640,
}) {
  for (var seed = 0; seed < maxSeeds; seed += 1) {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(seed),
      steps: steps,
      request: buildStartRequest(
        activeKeys: activeKeys,
        jazzPreset: jazzPreset,
        modulationIntensity: ModulationIntensity.high,
      ),
    );
    for (final trace in summary.traces) {
      if (trace.modulationKind == ModulationKind.real &&
          trace.currentKeyCenter == currentKeyCenter &&
          trace.finalKeyCenter == finalKeyCenter) {
        return trace;
      }
    }
  }
  return null;
}

SmartSimulationSummary? findChromaticMediantSummary({
  required JazzPreset jazzPreset,
  int maxSeeds = 40,
}) {
  for (var seed = 0; seed < maxSeeds; seed += 1) {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(seed),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'D#/Eb', 'G'],
        jazzPreset: jazzPreset,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.high,
      ),
    );
    if ((summary.familyHistogram['chromatic_mediant_common_tone_modulation'] ??
            0) >
        0) {
      return summary;
    }
  }
  return null;
}

void smartGeneratorTestSetUp() {
  setUp(() {
    SmartDiagnosticsStore.clear();
  });
}
