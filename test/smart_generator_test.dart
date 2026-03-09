import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/smart_generator.dart';

class _FixedRandom implements Random {
  _FixedRandom(this.value);

  final int value;

  @override
  bool nextBool() => value.isEven;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => value % max;
}

class _SequenceRandom implements Random {
  _SequenceRandom(this.values);

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
  bool secondaryDominantEnabled = true,
  bool substituteDominantEnabled = true,
  bool modalInterchangeEnabled = true,
  ModulationIntensity modulationIntensity = ModulationIntensity.medium,
  JazzPreset jazzPreset = JazzPreset.standardsCore,
  SourceProfile sourceProfile = SourceProfile.fakebookStandard,
  bool smartDiagnosticsEnabled = true,
}) {
  return SmartStartRequest(
    activeKeys: activeKeys,
    secondaryDominantEnabled: secondaryDominantEnabled,
    substituteDominantEnabled: substituteDominantEnabled,
    modalInterchangeEnabled: modalInterchangeEnabled,
    modulationIntensity: modulationIntensity,
    jazzPreset: jazzPreset,
    sourceProfile: sourceProfile,
    smartDiagnosticsEnabled: smartDiagnosticsEnabled,
  );
}

SmartStepRequest buildRequest({
  int stepIndex = 3,
  List<String> activeKeys = const ['C', 'G', 'A'],
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
}) {
  return SmartStepRequest(
    stepIndex: stepIndex,
    activeKeys: activeKeys,
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
  );
}

void main() {
  test('one-key mode does not produce real modulation', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(1),
      steps: 400,
      request: buildStartRequest(
        activeKeys: const ['C'],
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    expect(summary.modulationSuccessCount, 0);
    expect(
      summary.blockedReasonHistogram[SmartBlockedReason.singleActiveKey] ?? 0,
      greaterThan(0),
    );
  });

  test('multi-key mode can produce cadence-based real modulation', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(2),
      steps: 500,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    expect(summary.modulationSuccessCount, greaterThan(0));
    expect(
      summary.familyHistogram['cadence_based_real_modulation'] ?? 0,
      greaterThan(0),
    );
  });

  test(
    'modulation uses a cadence path instead of direct applied-to-I jump',
    () {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          activeKeys: const ['C', 'G'],
          currentRomanNumeralId: RomanNumeralId.secondaryOfV,
          currentResolutionRomanNumeralId: RomanNumeralId.vDom7,
          currentHarmonicFunction: HarmonicFunction.dominant,
          modulationIntensity: ModulationIntensity.high,
        ),
      );

      expect(plan.patternTag, 'cadence_based_real_modulation');
      expect(plan.finalKeyCenter.tonicName, 'G');
      expect(plan.finalRomanNumeralId, RomanNumeralId.iiMin7);
      expect(
        plan.remainingQueuedChords.map((item) => item.finalRomanNumeralId),
        [RomanNumeralId.vDom7, RomanNumeralId.iMaj69],
      );
    },
  );

  test('modal interchange does not fully choke modulation paths', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(3),
      steps: 700,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.high,
        modalInterchangeEnabled: true,
      ),
    );

    expect(summary.modulationSuccessCount, greaterThan(0));
    expect(summary.modalBranchCount, greaterThan(0));
  });

  test('excluded fallback leaves a trace blocked reason', () {
    final plan = SmartGeneratorHelper.planInitialStep(
      random: _SequenceRandom(const [0, 0, 0, 0]),
      request: buildStartRequest(
        activeKeys: const ['C', 'G'],
        jazzPreset: JazzPreset.standardsCore,
      ),
    );
    final trace = plan.debug.withDecision(
      'excluded-fallback',
      nextBlockedReason: SmartBlockedReason.excludedFallback,
      nextFallbackOccurred: true,
    );

    expect(trace.blockedReason, SmartBlockedReason.excludedFallback);
    expect(trace.fallbackOccurred, isTrue);
  });

  test('minor key centers render as minor rather than major-ish tonic', () {
    final root = MusicTheory.resolveChordRootForCenter(
      const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      RomanNumeralId.iMin6,
    );

    expect(root, 'A');
    expect(MusicTheory.romanTokenOf(RomanNumeralId.iMin6), 'Im6');
  });

  test('applied dominant to minor target uses altered dominant rendering', () {
    final quality = MusicTheory.resolveRenderQuality(
      romanNumeralId: RomanNumeralId.secondaryOfVI,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      allowV7sus4: true,
      randomRoll: 0,
      dominantContext: DominantContext.secondaryToMinor,
    );

    expect(quality, ChordQuality.dominant7Alt);
  });

  test('common-chord modulation can use a non-dominant pivot', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(4),
      steps: 900,
      request: buildStartRequest(
        activeKeys: const ['C', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    final pivotTrace = summary.traces.firstWhere(
      (trace) => trace.activePatternTag == 'common_chord_modulation',
    );

    expect(
      MusicTheory.specFor(pivotTrace.finalRomanNumeralId!).harmonicFunction,
      isNot(HarmonicFunction.dominant),
    );
  });

  test(
    'standardsCore frequently emits ii-V-I, turnaround, and minor cadence families',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(5),
        steps: 1000,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'A'],
          jazzPreset: JazzPreset.standardsCore,
          modulationIntensity: ModulationIntensity.low,
        ),
      );

      expect(
        summary.familyHistogram['core_ii_v_i_major'] ?? 0,
        greaterThan(10),
      );
      expect(
        summary.familyHistogram['turnaround_i_vi_ii_v'] ?? 0,
        greaterThan(5),
      );
      expect(
        summary.familyHistogram['minor_ii_halfdim_v_alt_i'] ?? 0,
        greaterThan(5),
      );
    },
  );

  test(
    'modulationStudy produces higher modulation density than standardsCore',
    () {
      final standardsCore = SmartGeneratorHelper.simulateSteps(
        random: Random(6),
        steps: 900,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'A'],
          jazzPreset: JazzPreset.standardsCore,
          modulationIntensity: ModulationIntensity.low,
        ),
      );
      final modulationStudy = SmartGeneratorHelper.simulateSteps(
        random: Random(6),
        steps: 900,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'A'],
          jazzPreset: JazzPreset.modulationStudy,
          modulationIntensity: ModulationIntensity.high,
        ),
      );

      expect(
        modulationStudy.modulationSuccessCount,
        greaterThan(standardsCore.modulationSuccessCount),
      );
    },
  );
}
