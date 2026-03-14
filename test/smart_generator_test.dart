import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/smart_generator.dart';

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
  List<KeyCenter>? selectedKeyCenters,
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
    selectedKeyCenters:
        selectedKeyCenters ??
        activeKeys.map((key) => MusicTheory.keyCenterFor(key)).toList(),
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

const SmartPhraseContext _testPhraseContext = SmartPhraseContext(
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
    phraseContext: _testPhraseContext,
  );
}

SmartCandidateComparison compareVoiceLeading({
  required List<SmartRenderCandidate> candidates,
  GeneratedChord? previousChord,
  int seed = 0,
  bool allowV7sus4 = true,
}) {
  return SmartGeneratorHelper.compareVoiceLeadingCandidates(
    random: _FixedRandom(seed),
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

void main() {
  setUp(() {
    SmartDiagnosticsStore.clear();
  });

  test('runWithGeneratedPriorsEnabled keeps async scopes isolated', () async {
    final observed = <bool>[];

    await SmartPriorLookup.runWithGeneratedPriorsEnabled(false, () async {
      observed.add(SmartPriorLookup.generatedPriorsEnabled);
      await Future<void>.microtask(() {
        observed.add(SmartPriorLookup.generatedPriorsEnabled);
      });
    });

    expect(observed, [false, false]);
    expect(SmartPriorLookup.generatedPriorsEnabled, isTrue);
  });

  test(
    'generated family base priors cover every progression family for each preset',
    () {
      for (final jazzPreset in JazzPreset.values) {
        final generated = SmartPriors.familyBaseWeights[jazzPreset];
        expect(
          generated,
          isNotNull,
          reason: 'Missing generated family priors for ${jazzPreset.name}.',
        );
        for (final family in SmartProgressionFamily.values) {
          expect(
            generated!.containsKey(family),
            isTrue,
            reason:
                'Missing generated family prior for ${jazzPreset.name}/${family.name}.',
          );
        }
      }
    },
  );

  test(
    'generated transition priors cover every legacy diatonic transition root',
    () {
      final legacyByMode =
          <KeyMode, Map<RomanNumeralId, List<WeightedNextRoman>>>{
            KeyMode.major: SmartGeneratorHelper.majorDiatonicTransitions,
            KeyMode.minor: SmartGeneratorHelper.minorDiatonicTransitions,
          };

      for (final entry in legacyByMode.entries) {
        final generated = SmartPriors.transitionPriors[entry.key];
        expect(
          generated,
          isNotNull,
          reason: 'Missing generated transition priors for ${entry.key.name}.',
        );
        for (final romanNumeralId in entry.value.keys) {
          final generatedCandidates = generated![romanNumeralId];
          expect(
            generatedCandidates,
            isNotNull,
            reason:
                'Missing generated transition priors for '
                '${entry.key.name}/${romanNumeralId.name}.',
          );
          expect(
            generatedCandidates,
            isNotEmpty,
            reason:
                'Generated transition priors for '
                '${entry.key.name}/${romanNumeralId.name} were empty.',
          );
        }
      }
    },
  );

  test(
    'continuation resolution helper falls back to stored resolution roman',
    () {
      final chord = GeneratedChord(
        symbolData: const ChordSymbolData(
          root: 'D',
          harmonicQuality: ChordQuality.dominant7,
          renderQuality: ChordQuality.dominant7,
        ),
        repeatGuardKey: 'continuation-test',
        harmonicComparisonKey: 'continuation-test',
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        keyName: 'C',
        romanNumeralId: RomanNumeralId.secondaryOfV,
        resolutionRomanNumeralId: RomanNumeralId.vDom7,
        harmonicFunction: HarmonicFunction.dominant,
      );

      expect(
        SmartGeneratorHelper.continuationResolutionRomanNumeralId(chord),
        RomanNumeralId.vDom7,
      );
    },
  );

  test('simulateSteps preserves existing diagnostics history', () {
    final existing = buildTrace();
    SmartDiagnosticsStore.record(existing);

    SmartGeneratorHelper.simulateSteps(
      random: Random(1),
      steps: 12,
      request: buildStartRequest(
        activeKeys: const ['C', 'G'],
        jazzPreset: JazzPreset.standardsCore,
      ),
    );

    final recent = SmartDiagnosticsStore.recent();
    expect(recent, hasLength(1));
    expect(recent.first.describe(), existing.describe());
  });

  test('decision trace json exports queued flow fields', () {
    final trace = SmartDecisionTrace(
      stepIndex: 4,
      currentKeyCenter: 'C major',
      currentRomanNumeralId: RomanNumeralId.vDom7,
      currentHarmonicFunction: HarmonicFunction.dominant,
      phraseContext: _testPhraseContext,
      selectedAppliedApproach: RomanNumeralId.secondaryOfV,
      appliedType: AppliedType.secondary,
      appliedTargetRomanNumeralId: RomanNumeralId.vDom7,
      queuedPatternLength: 2,
      returnedToNormalFlow: true,
    );

    final json = trace.toJson();
    expect(json['queuedPatternLength'], 2);
    expect(json['returnedToNormalFlow'], isTrue);
    expect(
      json['selectedAppliedApproach'],
      MusicTheory.romanTokenOf(RomanNumeralId.secondaryOfV),
    );
    expect(json['appliedType'], AppliedType.secondary.name);
    expect(
      json['appliedTarget'],
      MusicTheory.romanTokenOf(RomanNumeralId.vDom7),
    );
  });

  test('decision trace json includes finalRenderedNonDiatonic', () {
    final trace = SmartDecisionTrace(
      stepIndex: 4,
      currentKeyCenter: 'C major',
      currentRomanNumeralId: RomanNumeralId.vDom7,
      currentHarmonicFunction: HarmonicFunction.dominant,
      phraseContext: _testPhraseContext,
      finalRenderedNonDiatonic: true,
    );

    final json = trace.toJson();
    expect(json['finalRenderedNonDiatonic'], isTrue);
    expect(trace.describe(), contains('finalRenderedNonDiatonic=true'));
  });
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
      SmartStepPlan? plan;
      for (var seed = 0; seed < 512; seed += 1) {
        final candidate = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 6,
            activeKeys: const ['C', 'G'],
            currentRomanNumeralId: RomanNumeralId.secondaryOfV,
            currentResolutionRomanNumeralId: RomanNumeralId.vDom7,
            currentHarmonicFunction: HarmonicFunction.dominant,
            modulationIntensity: ModulationIntensity.high,
          ),
        );
        if (candidate.patternTag == 'cadence_based_real_modulation') {
          plan = candidate;
          break;
        }
      }

      expect(plan, isNotNull);
      expect(plan!.patternTag, 'cadence_based_real_modulation');
      expect(plan.finalKeyCenter.tonicName, 'G');
      expect(plan.finalRomanNumeralId, RomanNumeralId.iiMin7);
      expect(
        plan.remainingQueuedChords.map((item) => item.finalRomanNumeralId),
        [RomanNumeralId.vDom7, RomanNumeralId.iMaj69, RomanNumeralId.viMin7],
      );
    },
  );

  test('real modulation queues a post-arrival confirmation chord', () {
    SmartStepPlan? plan;
    for (var seed = 0; seed < 512; seed += 1) {
      final candidate = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 6,
          activeKeys: const ['C', 'G'],
          currentRomanNumeralId: RomanNumeralId.secondaryOfV,
          currentResolutionRomanNumeralId: RomanNumeralId.vDom7,
          currentHarmonicFunction: HarmonicFunction.dominant,
          modulationIntensity: ModulationIntensity.high,
        ),
      );
      if (candidate.patternTag == 'cadence_based_real_modulation') {
        plan = candidate;
        break;
      }
    }

    expect(plan, isNotNull);

    expect(
      plan!.remainingQueuedChords.last.finalRomanNumeralId,
      RomanNumeralId.viMin7,
    );
    expect(
      plan.remainingQueuedChords.any(
        (queued) => queued.postModulationConfirmationsRemaining > 0,
      ),
      isTrue,
    );
  });

  test(
    'post-modulation confirmation window blocks fresh modulation attempts',
    () {
      final traceInConfirmationWindow = SmartDecisionTrace(
        stepIndex: 7,
        currentKeyCenter: 'G major',
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.continuation,
          sectionRole: SectionRole.aLike,
          harmonicDensity: HarmonicDensity.oneChordPerBar,
          barInPhrase: 1,
          barsToBoundary: 6,
          phraseLength: 8,
        ),
        postModulationConfirmationsRemaining: 1,
      );

      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          stepIndex: 8,
          activeKeys: const ['C', 'G', 'A'],
          currentKeyCenter: const KeyCenter(
            tonicName: 'G',
            mode: KeyMode.major,
          ),
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          modulationIntensity: ModulationIntensity.high,
          currentTrace: traceInConfirmationWindow,
        ),
      );

      expect(
        plan.debug.blockedReason,
        SmartBlockedReason.insufficientConfirmationWindow,
      );
      expect(plan.debug.modulationKind, isNot(ModulationKind.real));
    },
  );
  test('low-priority phrase position blocks fresh modulation attempts', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _FixedRandom(0),
      request: buildRequest(
        stepIndex: 2,
        activeKeys: const ['C', 'G', 'A'],
        currentKeyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        modulationIntensity: ModulationIntensity.medium,
        modalInterchangeEnabled: false,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.continuation,
          sectionRole: SectionRole.aLike,
          harmonicDensity: HarmonicDensity.oneChordPerBar,
          barInPhrase: 1,
          barsToBoundary: 6,
          phraseLength: 8,
        ),
      ),
    );

    expect(
      plan.debug.blockedReason,
      SmartBlockedReason.phrasePositionLowPriority,
    );
    expect(plan.debug.modulationKind, isNot(ModulationKind.real));
  });

  test('exhausted surprise budget blocks fresh modulation attempts', () {
    for (var step = 1; step <= 2; step += 1) {
      SmartDiagnosticsStore.record(
        SmartDecisionTrace(
          stepIndex: step,
          currentKeyCenter: 'C major',
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.preCadence,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 6,
            barsToBoundary: 2,
            phraseLength: 8,
          ),
          modulationKind: ModulationKind.real,
          finalKeyRelation: KeyRelation.distant,
        ),
      );
    }

    final plan = SmartGeneratorHelper.planNextStep(
      random: _FixedRandom(0),
      request: buildRequest(
        stepIndex: 12,
        activeKeys: const ['C', 'G', 'A'],
        currentKeyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.high,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.preCadence,
          sectionRole: SectionRole.bridgeLike,
          harmonicDensity: HarmonicDensity.twoChordsPerBar,
          barInPhrase: 6,
          barsToBoundary: 2,
          phraseLength: 8,
        ),
      ),
    );

    expect(
      plan.debug.blockedReason,
      SmartBlockedReason.surpriseBudgetExhausted,
    );
    expect(plan.debug.modulationKind, isNot(ModulationKind.real));
  });
  test(
    'recent distant modulation lockout surfaces specific blocked reason',
    () {
      SmartDiagnosticsStore.record(
        SmartDecisionTrace(
          stepIndex: 3,
          currentKeyCenter: 'C major',
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.preCadence,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 6,
            barsToBoundary: 2,
            phraseLength: 8,
          ),
          modulationKind: ModulationKind.real,
          finalKeyRelation: KeyRelation.distant,
        ),
      );

      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          stepIndex: 12,
          activeKeys: const ['C', 'F#/Gb'],
          currentKeyCenter: const KeyCenter(
            tonicName: 'C',
            mode: KeyMode.major,
          ),
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          modulationIntensity: ModulationIntensity.high,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.preCadence,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 6,
            barsToBoundary: 2,
            phraseLength: 8,
          ),
        ),
      );

      expect(
        plan.debug.blockedReason,
        SmartBlockedReason.recentDistantModulationLockout,
      );
      expect(plan.debug.modulationKind, isNot(ModulationKind.real));
    },
  );
  test('no compatible key surfaces explicit modulation blocked reason', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _FixedRandom(0),
      request: buildRequest(
        stepIndex: 12,
        activeKeys: const ['C', 'D'],
        currentKeyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        jazzPreset: JazzPreset.standardsCore,
        modulationIntensity: ModulationIntensity.high,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.preCadence,
          sectionRole: SectionRole.aLike,
          harmonicDensity: HarmonicDensity.oneChordPerBar,
          barInPhrase: 6,
          barsToBoundary: 2,
          phraseLength: 8,
        ),
      ),
    );

    expect(plan.debug.blockedReason, SmartBlockedReason.noCompatibleKey);
    expect(plan.debug.modulationKind, isNot(ModulationKind.real));
  });

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

  test('initial smart-generator home starts on the selected key as major', () {
    final plan = SmartGeneratorHelper.planInitialStep(
      random: _FixedRandom(0),
      request: buildStartRequest(
        activeKeys: const ['C'],
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
      ),
    );

    expect(plan.debug.currentKeyCenter, 'C major');
    expect(plan.finalKeyCenter.mode, KeyMode.major);
  });

  test('minor key centers render as minor rather than major-ish tonic', () {
    final root = MusicTheory.resolveChordRootForCenter(
      const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      RomanNumeralId.iMin6,
    );

    expect(root, 'A');
    expect(MusicTheory.romanTokenOf(RomanNumeralId.iMin6), 'Im6');
  });

  test('real modulation traces tag C major to G major as dominant', () {
    final trace = findRealModulationTrace(
      currentKeyCenter: 'C major',
      finalKeyCenter: 'G major',
      activeKeys: const ['C', 'G'],
    );

    expect(trace, isNotNull);
    expect(trace!.finalKeyRelation, KeyRelation.dominant);
  });

  test('real modulation traces tag C major to F major as subdominant', () {
    final trace = findRealModulationTrace(
      currentKeyCenter: 'C major',
      finalKeyCenter: 'F major',
      activeKeys: const ['C', 'F'],
    );

    expect(trace, isNotNull);
    expect(trace!.finalKeyRelation, KeyRelation.subdominant);
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

  test('relative minor reframe in minor queues a relative-major cadence', () {
    final phraseContext = const SmartPhraseContext(
      phraseRole: PhraseRole.release,
      sectionRole: SectionRole.tag,
      harmonicDensity: HarmonicDensity.turnaroundSplit,
      barInPhrase: 3,
      barsToBoundary: 0,
      phraseLength: 4,
    );
    final plan = SmartGeneratorHelper.planNextStep(
      random: _FixedRandom(0),
      request: buildRequest(
        activeKeys: const ['A'],
        currentKeyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
        currentRomanNumeralId: RomanNumeralId.iMin7,
        currentHarmonicFunction: HarmonicFunction.tonic,
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.recordingInspired,
        phraseContext: phraseContext,
      ),
    );

    expect(plan.patternTag, 'relative_minor_reframe');
    expect(plan.finalRomanNumeralId, RomanNumeralId.flatIIIMaj7Minor);
    expect(plan.remainingQueuedChords.map((item) => item.finalRomanNumeralId), [
      RomanNumeralId.ivMin7Minor,
      RomanNumeralId.flatVIIDom7Minor,
      RomanNumeralId.flatIIIMaj7Minor,
    ]);
    expect(
      plan.remainingQueuedChords.last.renderQualityOverride,
      ChordQuality.six,
    );
    expect(
      plan.debug.activeLocalScope?.center.relationToParent,
      KeyRelation.relative,
    );
  });

  test(
    'dominant-headed scope chain can be selected under matching scope pressure',
    () {
      SmartStepPlan? selectedPlan;
      final currentTrace = SmartDecisionTrace(
        stepIndex: 11,
        currentKeyCenter: 'C major',
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.continuation,
          sectionRole: SectionRole.bridgeLike,
          harmonicDensity: HarmonicDensity.twoChordsPerBar,
          barInPhrase: 3,
          barsToBoundary: 4,
          phraseLength: 8,
        ),
        activeLocalScope: const LocalScope(
          center: KeyCenter(
            tonicName: 'A',
            mode: KeyMode.minor,
            relationToParent: KeyRelation.relative,
          ),
          headType: ScopeHeadType.dominantHead,
          confidence: 0.66,
          expiresIn: 2,
        ),
        outstandingDebts: const [
          ResolutionDebt(
            debtType: ResolutionDebtType.dominantResolve,
            targetLabel: 'A local tonic',
            deadline: 1,
            severity: 2,
          ),
        ],
      );

      for (var seed = 0; seed < 96; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 12,
            activeKeys: const ['C', 'G', 'A'],
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            currentTrace: currentTrace,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.continuation,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 4,
              barsToBoundary: 3,
              phraseLength: 8,
            ),
          ),
        );
        if (plan.patternTag == 'dominant_headed_scope_chain') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(selectedPlan!.finalRomanNumeralId, RomanNumeralId.secondaryOfVI);
      expect(
        selectedPlan.renderingPlan.dominantIntent,
        DominantIntent.dominantHeadedScope,
      );
      expect(
        selectedPlan.remainingQueuedChords.map(
          (item) => item.finalRomanNumeralId,
        ),
        [
          RomanNumeralId.viiHalfDiminished7,
          RomanNumeralId.secondaryOfVI,
          RomanNumeralId.viMin7,
        ],
      );
      expect(
        selectedPlan.debug.activeLocalScope?.headType,
        ScopeHeadType.dominantHead,
      );
    },
  );

  test('closing plagal/authentic hybrid cadences major phrases', () {
    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 160; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 30,
          activeKeys: const ['C', 'G', 'A'],
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modalInterchangeEnabled: true,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.release,
            sectionRole: SectionRole.tag,
            harmonicDensity: HarmonicDensity.turnaroundSplit,
            barInPhrase: 3,
            barsToBoundary: 0,
            phraseLength: 4,
          ),
        ),
      );
      if (plan.patternTag == 'closing_plagal_authentic_hybrid') {
        selectedPlan = plan;
        break;
      }
    }

    expect(selectedPlan, isNotNull);
    expect(
      selectedPlan!.finalRomanNumeralId == RomanNumeralId.borrowedIvMin7 ||
          selectedPlan.finalRomanNumeralId == RomanNumeralId.ivMaj7,
      isTrue,
    );
    expect(
      selectedPlan.remainingQueuedChords.map(
        (item) => item.finalRomanNumeralId,
      ),
      [RomanNumeralId.vDom7, RomanNumeralId.vDom7, RomanNumeralId.iMaj7],
    );
    expect(
      selectedPlan.remainingQueuedChords.first.renderQualityOverride,
      ChordQuality.dominant13sus4,
    );
    expect(
      selectedPlan.remainingQueuedChords[1].dominantIntent,
      DominantIntent.primaryAuthenticMajor,
    );
    expect(
      selectedPlan.remainingQueuedChords.last.plannedChordKind,
      PlannedChordKind.tonicSix,
    );
    expect(selectedPlan.remainingQueuedChords.last.cadentialArrival, isTrue);
  });

  test(
    'closing plagal/authentic hybrid cadences minor phrases without majorizing',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 192; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['A', 'C'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'A',
              mode: KeyMode.minor,
            ),
            currentRomanNumeralId: RomanNumeralId.iMin7,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.turnaroundTail,
              harmonicDensity: HarmonicDensity.turnaroundSplit,
              barInPhrase: 2,
              barsToBoundary: 1,
              phraseLength: 4,
            ),
          ),
        );
        if (plan.patternTag == 'closing_plagal_authentic_hybrid') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(selectedPlan!.finalRomanNumeralId, RomanNumeralId.ivMin7Minor);
      expect(
        selectedPlan.remainingQueuedChords.map(
          (item) => item.finalRomanNumeralId,
        ),
        [RomanNumeralId.vDom7, RomanNumeralId.vDom7, RomanNumeralId.iMin6],
      );
      expect(
        selectedPlan.remainingQueuedChords.first.renderQualityOverride,
        ChordQuality.dominant13sus4,
      );
      expect(
        selectedPlan.remainingQueuedChords[1].renderQualityOverride,
        ChordQuality.dominant7Alt,
      );
      expect(
        selectedPlan.remainingQueuedChords.last.surfaceTags.contains(
          'tonicMinor6',
        ),
        isTrue,
      );
      expect(selectedPlan.remainingQueuedChords.last.cadentialArrival, isTrue);
    },
  );

  test('bridge-like phrase can generate a local IV stabilization family', () {
    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 320; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 19,
          activeKeys: const ['C', 'G', 'F'],
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.continuation,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 3,
            barsToBoundary: 4,
            phraseLength: 8,
          ),
        ),
      );
      if (plan.patternTag == 'bridge_iv_stabilized_by_local_ii_v_i') {
        selectedPlan = plan;
        break;
      }
    }

    expect(selectedPlan, isNotNull);
    expect(selectedPlan!.finalRomanNumeralId, RomanNumeralId.relatedIiOfIV);
    expect(
      selectedPlan.remainingQueuedChords.map(
        (item) => item.finalRomanNumeralId,
      ),
      [
        RomanNumeralId.secondaryOfIV,
        RomanNumeralId.secondaryOfIV,
        RomanNumeralId.ivMaj7,
      ],
    );
    expect(
      selectedPlan.remainingQueuedChords.first.renderQualityOverride,
      ChordQuality.dominant13sus4,
    );
    expect(selectedPlan.debug.activeLocalScope?.center.tonicName, 'F');
    expect(
      selectedPlan.debug.activeLocalScope?.center.relationToParent,
      KeyRelation.subdominant,
    );
    expect(selectedPlan.modulationKind, ModulationKind.tonicization);
  });

  test(
    'bridge IV fallback candidates stay in-family before generic substitutes',
    () {
      final fallbackRomans = SmartGeneratorHelper.prioritizedFallbackRomans(
        keyMode: KeyMode.major,
        finalRomanNumeralId: RomanNumeralId.relatedIiOfIV,
        harmonicFunction: HarmonicFunction.predominant,
        patternTag: 'bridge_iv_stabilized_by_local_ii_v_i',
      );

      expect(fallbackRomans.take(4), [
        RomanNumeralId.relatedIiOfIV,
        RomanNumeralId.secondaryOfIV,
        RomanNumeralId.substituteOfIV,
        RomanNumeralId.ivMaj7,
      ]);
    },
  );

  test(
    'local ii-V-I stabilizes the IV area without declaring real modulation',
    () {
      SmartStepPlan? startPlan;
      for (var seed = 0; seed < 320; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 19,
            activeKeys: const ['C', 'G', 'F'],
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.continuation,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 3,
              barsToBoundary: 4,
              phraseLength: 8,
            ),
          ),
        );
        if (plan.patternTag == 'bridge_iv_stabilized_by_local_ii_v_i') {
          startPlan = plan;
          break;
        }
      }

      expect(startPlan, isNotNull);

      var currentPlan = startPlan!;
      for (var stepIndex = 20; stepIndex <= 22; stepIndex += 1) {
        currentPlan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(0),
          request: buildRequest(
            stepIndex: stepIndex,
            activeKeys: const ['C', 'G', 'F'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentResolutionRomanNumeralId:
                currentPlan.resolutionTargetRomanId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            currentPatternTag: currentPlan.patternTag,
            plannedQueue: currentPlan.remainingQueuedChords,
            currentTrace: currentPlan.debug,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.continuation,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 4,
              barsToBoundary: 3,
              phraseLength: 8,
            ),
          ),
        );
      }

      expect(currentPlan.finalRomanNumeralId, RomanNumeralId.ivMaj7);
      expect(
        currentPlan.renderingPlan.renderQualityOverride,
        ChordQuality.major69,
      );
      expect(currentPlan.cadentialArrival, isTrue);
      expect(currentPlan.modulationKind, ModulationKind.tonicization);
      expect(currentPlan.finalKeyCenter.tonicName, 'C');
      expect(currentPlan.debug.activeLocalScope?.center.tonicName, 'F');
      expect(
        currentPlan.debug.activeLocalScope?.center.relationToParent,
        KeyRelation.subdominant,
      );
      expect(
        currentPlan.debug.activeLocalScope?.headType,
        ScopeHeadType.tonicHead,
      );
      expect(
        currentPlan.debug.surfaceTags.contains('localIVStabilized'),
        isTrue,
      );
    },
  );

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
        greaterThanOrEqualTo(4),
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

  test(
    'bridge IV stabilization stays bridge-biased rather than A-like-heavy',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(14),
        steps: 1800,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'F'],
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.medium,
        ),
      );

      expect(
        summary.familyHistogram['bridge_iv_stabilized_by_local_ii_v_i'] ?? 0,
        greaterThan(0),
      );
      expect(
        summary.bridgeIvSectionHistogram['bridgeLike'] ?? 0,
        greaterThan(summary.bridgeIvSectionHistogram['aLike'] ?? 0),
      );
    },
  );

  test('relative reframe family appears in practice simulations', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(11),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    expect(
      summary.familyHistogram['relative_minor_reframe'] ?? 0,
      greaterThan(0),
    );
    expect(
      (summary.cadenceHistogram['relative_minor_reframe'] ?? 0) +
          (summary.cadenceHistogram['relative_major_reframe'] ?? 0),
      greaterThan(0),
    );
    expect(
      summary.traces.any(
        (trace) =>
            trace.activePatternTag == 'relative_minor_reframe' &&
            trace.cadentialArrival &&
            (trace.finalRenderQuality == ChordQuality.minor6 ||
                trace.finalRenderQuality == ChordQuality.minorMajor7 ||
                trace.finalRenderQuality == ChordQuality.major69 ||
                trace.finalRenderQuality == ChordQuality.six),
      ),
      isTrue,
    );
  });

  test(
    'dominant-headed scope family appears and reaches a local tonic payoff',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(12),
        steps: 1600,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'A'],
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.medium,
        ),
      );

      expect(
        summary.familyHistogram['dominant_headed_scope_chain'] ?? 0,
        greaterThan(0),
      );
      expect(
        summary.cadenceHistogram['dominant_headed_scope_release'] ?? 0,
        greaterThan(0),
      );
      expect(
        summary.traces.any(
          (trace) =>
              trace.activePatternTag == 'dominant_headed_scope_chain' &&
              trace.dominantIntent == DominantIntent.dominantHeadedScope,
        ),
        isTrue,
      );
      expect(
        summary.traces.any(
          (trace) =>
              trace.activePatternTag == 'dominant_headed_scope_chain' &&
              trace.cadentialArrival &&
              (trace.finalRomanNumeralId == RomanNumeralId.viMin7 ||
                  trace.finalRomanNumeralId == RomanNumeralId.iiiMin7),
        ),
        isTrue,
      );
    },
  );

  test('closing plagal/authentic hybrid appears in simulations', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(13),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    expect(
      summary.familyHistogram['closing_plagal_authentic_hybrid'] ?? 0,
      greaterThan(0),
    );
    expect(
      (summary.cadenceHistogram['plagal_authentic_hybrid'] ?? 0) +
          (summary.cadenceHistogram['borrowed_plagal_authentic_hybrid'] ?? 0) +
          (summary.cadenceHistogram['minor_plagal_authentic_hybrid'] ?? 0),
      greaterThan(0),
    );
    expect(
      summary.traces.any(
        (trace) =>
            trace.activePatternTag == 'closing_plagal_authentic_hybrid' &&
            trace.dominantIntent == DominantIntent.susDelay,
      ),
      isTrue,
    );
  });

  test('advanced release contexts can generate recursive backdoor prep', () {
    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 512; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 30,
          activeKeys: const ['C', 'G', 'F'],
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modalInterchangeEnabled: true,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.release,
            sectionRole: SectionRole.tag,
            harmonicDensity: HarmonicDensity.turnaroundSplit,
            barInPhrase: 3,
            barsToBoundary: 0,
            phraseLength: 4,
          ),
        ),
      );
      if (plan.patternTag == 'backdoor_recursive_prep') {
        selectedPlan = plan;
        break;
      }
    }

    expect(selectedPlan, isNotNull);
    final romans = [
      selectedPlan!.finalRomanNumeralId,
      ...selectedPlan.remainingQueuedChords.map(
        (item) => item.finalRomanNumeralId,
      ),
    ];
    expect(
      selectedPlan.finalRomanNumeralId == RomanNumeralId.borrowedFlatVIMaj7 ||
          selectedPlan.finalRomanNumeralId ==
              RomanNumeralId.borrowedFlatIIIMaj7,
      isTrue,
    );
    expect(romans.contains(RomanNumeralId.borrowedIvMin7), isTrue);
    expect(romans.contains(RomanNumeralId.borrowedFlatVII7), isTrue);
    expect(
      romans.last == RomanNumeralId.iMaj69 ||
          romans.last == RomanNumeralId.iMaj7,
      isTrue,
    );
    expect(selectedPlan.modulationKind, ModulationKind.none);
  });

  test(
    'recursive backdoor fallback keeps borrowed-family substitutes first',
    () {
      final fallbackRomans = SmartGeneratorHelper.prioritizedFallbackRomans(
        keyMode: KeyMode.major,
        finalRomanNumeralId: RomanNumeralId.borrowedFlatVIMaj7,
        harmonicFunction: HarmonicFunction.predominant,
        patternTag: 'backdoor_recursive_prep',
      );

      expect(fallbackRomans.take(4), [
        RomanNumeralId.borrowedFlatVIMaj7,
        RomanNumeralId.borrowedFlatIIIMaj7,
        RomanNumeralId.borrowedIvMin7,
        RomanNumeralId.borrowedFlatVII7,
      ]);
    },
  );

  test(
    'bridge IV stabilization diagnostics record cadence and success metrics',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(15),
        steps: 1800,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'F'],
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.medium,
        ),
      );

      expect(
        summary.familyHistogram['bridge_iv_stabilized_by_local_ii_v_i'] ?? 0,
        greaterThan(0),
      );
      expect(
        summary.cadenceHistogram['bridge_local_iv_cadence'] ?? 0,
        greaterThan(0),
      );
      expect(summary.bridgeIvStabilizationSuccessCount, greaterThan(0));
      expect(summary.bridgeIvFallbackCount, greaterThanOrEqualTo(0));
    },
  );

  test(
    'recursive backdoor appears in advanced simulations but not standardsCore',
    () {
      final standardsCore = SmartGeneratorHelper.simulateSteps(
        random: Random(16),
        steps: 1600,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'F'],
          jazzPreset: JazzPreset.standardsCore,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.medium,
        ),
      );
      final advanced = SmartGeneratorHelper.simulateSteps(
        random: Random(16),
        steps: 1600,
        request: buildStartRequest(
          activeKeys: const ['C', 'G', 'F'],
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.medium,
        ),
      );

      expect(standardsCore.familyHistogram['backdoor_recursive_prep'] ?? 0, 0);
      expect(
        advanced.familyHistogram['backdoor_recursive_prep'] ?? 0,
        greaterThan(0),
      );
      expect(
        advanced.cadenceHistogram['recursive_backdoor'] ?? 0,
        greaterThan(0),
      );
      expect(
        advanced.traces.any(
          (trace) =>
              trace.activePatternTag == 'backdoor_recursive_prep' &&
              trace.dominantIntent == DominantIntent.backdoor,
        ),
        isTrue,
      );
    },
  );

  test(
    'advanced cadence contexts can generate classical predominant color',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 6,
            activeKeys: const ['C', 'G', 'F'],
            currentRomanNumeralId: RomanNumeralId.iiMin7,
            currentHarmonicFunction: HarmonicFunction.predominant,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modalInterchangeEnabled: true,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.turnaroundTail,
              harmonicDensity: HarmonicDensity.turnaroundSplit,
              barInPhrase: 2,
              barsToBoundary: 1,
              phraseLength: 4,
            ),
          ),
        );
        if (plan.patternTag == 'classical_predominant_color') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(
        selectedPlan!.finalRomanNumeralId,
        RomanNumeralId.borrowedFlatIIMaj7,
      );
      expect(
        selectedPlan.debug.surfaceTags.any(
          (tag) => tag == 'neapolitanPredominant' || tag == 'aug6Predominant',
        ),
        isTrue,
      );
      expect(
        selectedPlan.remainingQueuedChords.any(
          (item) => item.finalRomanNumeralId == RomanNumeralId.vDom7,
        ),
        isTrue,
      );
      expect(
        selectedPlan.remainingQueuedChords.last.finalRomanNumeralId ==
                RomanNumeralId.iMaj69 ||
            selectedPlan.remainingQueuedChords.last.finalRomanNumeralId ==
                RomanNumeralId.iMaj7,
        isTrue,
      );
    },
  );

  test(
    'classical predominant fallback keeps cadence-family substitutes first',
    () {
      final fallbackRomans = SmartGeneratorHelper.prioritizedFallbackRomans(
        keyMode: KeyMode.major,
        finalRomanNumeralId: RomanNumeralId.borrowedFlatIIMaj7,
        harmonicFunction: HarmonicFunction.predominant,
        patternTag: 'classical_predominant_color',
      );

      expect(fallbackRomans.take(4), [
        RomanNumeralId.borrowedFlatIIMaj7,
        RomanNumeralId.ivMaj7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj69,
      ]);
    },
  );

  test('classical predominant color opens and pays rare-color debt', () {
    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 22,
          activeKeys: const ['C', 'G', 'F'],
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modalInterchangeEnabled: true,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.preCadence,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 5,
            barsToBoundary: 2,
            phraseLength: 8,
          ),
        ),
      );
      if (plan.patternTag == 'classical_predominant_color') {
        selectedPlan = plan;
        break;
      }
    }

    expect(selectedPlan, isNotNull);
    expect(
      selectedPlan!.debug.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      ),
      isTrue,
    );
    expect(
      selectedPlan.remainingQueuedChords.any(
        (item) => item.satisfiedDebtTypes.contains(
          ResolutionDebtType.rareColorPayoff,
        ),
      ),
      isTrue,
    );
    expect(selectedPlan.modulationKind, ModulationKind.none);
  });

  test('classical predominant color appears in advanced simulations only', () {
    final standardsCore = SmartGeneratorHelper.simulateSteps(
      random: Random(17),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'F'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );
    final advanced = SmartGeneratorHelper.simulateSteps(
      random: Random(17),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'F'],
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    expect(
      standardsCore.familyHistogram['classical_predominant_color'] ?? 0,
      0,
    );
    expect(
      advanced.familyHistogram['classical_predominant_color'] ?? 0,
      greaterThan(0),
    );
    expect(
      (advanced.cadenceHistogram['neapolitan_predominant_authentic'] ?? 0) +
          (advanced.cadenceHistogram['aug6_predominant_authentic'] ?? 0),
      greaterThan(0),
    );
    expect(advanced.rareColorPayoffCount, greaterThan(0));
  });

  test(
    'mixture pivot modulation can use a borrowed pivot into parallel minor',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D'],
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modalInterchangeEnabled: true,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.preCadence,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 5,
              barsToBoundary: 2,
              phraseLength: 8,
            ),
          ),
        );
        if (plan.patternTag == 'mixture_pivot_modulation') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(
        MusicTheory.specFor(selectedPlan!.finalRomanNumeralId).harmonicFunction,
        isNot(HarmonicFunction.dominant),
      );
      expect(selectedPlan.modulationKind, ModulationKind.none);
      expect(
        selectedPlan.debug.surfaceTags.contains('mixturePivot') &&
            selectedPlan.debug.surfaceTags.contains('parallelPivot'),
        isTrue,
      );
      expect(
        selectedPlan.remainingQueuedChords.any(
          (item) =>
              item.modulationKind == ModulationKind.real &&
              item.keyCenter.tonicName == 'C' &&
              item.keyCenter.mode == KeyMode.minor,
        ),
        isTrue,
      );
    },
  );

  test(
    'mixture pivot modulation reaches a parallel-key cadence before confirmation',
    () {
      SmartStepPlan? currentPlan;
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D'],
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modalInterchangeEnabled: true,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.preCadence,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 5,
              barsToBoundary: 2,
              phraseLength: 8,
            ),
          ),
        );
        if (plan.patternTag == 'mixture_pivot_modulation') {
          currentPlan = plan;
          break;
        }
      }

      expect(currentPlan, isNotNull);
      final initialPlan = currentPlan;
      if (initialPlan == null) {
        fail('Expected a seeded modulation plan.');
      }
      var activePlan = initialPlan;
      final visitedRomans = <RomanNumeralId>[activePlan.finalRomanNumeralId];
      for (var stepIndex = 23; stepIndex <= 26; stepIndex += 1) {
        activePlan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(0),
          request: buildRequest(
            stepIndex: stepIndex,
            activeKeys: const ['C', 'D'],
            currentKeyCenter: activePlan.finalKeyCenter,
            currentRomanNumeralId: activePlan.finalRomanNumeralId,
            currentResolutionRomanNumeralId: activePlan.resolutionTargetRomanId,
            currentHarmonicFunction: MusicTheory.specFor(
              activePlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modalInterchangeEnabled: true,
            modulationIntensity: ModulationIntensity.high,
            currentPatternTag: activePlan.patternTag,
            plannedQueue: activePlan.remainingQueuedChords,
            currentTrace: activePlan.debug,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 6,
              barsToBoundary: 1,
              phraseLength: 8,
            ),
          ),
        );
        visitedRomans.add(activePlan.finalRomanNumeralId);
        if (activePlan.cadentialArrival) {
          break;
        }
      }

      expect(visitedRomans.contains(RomanNumeralId.vDom7), isTrue);
      expect(activePlan.cadentialArrival, isTrue);
      expect(activePlan.modulationKind, ModulationKind.real);
      expect(activePlan.finalKeyCenter.tonicName, 'C');
      expect(activePlan.finalKeyCenter.mode, KeyMode.minor);
      expect(
        activePlan.finalRomanNumeralId == RomanNumeralId.iMin6 ||
            activePlan.finalRomanNumeralId == RomanNumeralId.iMinMaj7,
        isTrue,
      );
    },
  );

  test(
    'mixture pivot modulation also supports minor to parallel major reframe',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 14,
            activeKeys: const ['C', 'D'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.minor,
            ),
            currentRomanNumeralId: RomanNumeralId.iMin6,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modalInterchangeEnabled: true,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.bridgeLike,
              harmonicDensity: HarmonicDensity.twoChordsPerBar,
              barInPhrase: 6,
              barsToBoundary: 1,
              phraseLength: 8,
            ),
          ),
        );
        if (plan.patternTag == 'mixture_pivot_modulation') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(
        selectedPlan!.remainingQueuedChords.any(
          (item) =>
              item.modulationKind == ModulationKind.real &&
              item.keyCenter.tonicName == 'C' &&
              item.keyCenter.mode == KeyMode.major,
        ),
        isTrue,
      );
    },
  );

  test(
    'mixture pivot modulation appears in modulationStudy simulations but not standardsCore',
    () {
      final standardsCore = SmartGeneratorHelper.simulateSteps(
        random: Random(18),
        steps: 1600,
        request: buildStartRequest(
          activeKeys: const ['C', 'D'],
          jazzPreset: JazzPreset.standardsCore,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
        ),
      );
      final modulationStudy = SmartGeneratorHelper.simulateSteps(
        random: Random(18),
        steps: 1600,
        request: buildStartRequest(
          activeKeys: const ['C', 'D'],
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
        ),
      );

      expect(standardsCore.familyHistogram['mixture_pivot_modulation'] ?? 0, 0);
      expect(
        modulationStudy.familyHistogram['mixture_pivot_modulation'] ?? 0,
        greaterThan(0),
      );
      expect(
        modulationStudy.cadenceHistogram['mixture_pivot_authentic'] ?? 0,
        greaterThan(0),
      );
      expect(
        modulationStudy.traces.any(
          (trace) =>
              trace.activePatternTag == 'mixture_pivot_modulation' &&
              trace.finalKeyRelation == KeyRelation.parallel,
        ),
        isTrue,
      );
    },
  );

  test('bridge return home cadence targets the inferred home center', () {
    seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 27,
          activeKeys: const ['C', 'G'],
          currentKeyCenter: const KeyCenter(
            tonicName: 'G',
            mode: KeyMode.major,
          ),
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.cadence,
            sectionRole: SectionRole.turnaroundTail,
            harmonicDensity: HarmonicDensity.turnaroundSplit,
            barInPhrase: 2,
            barsToBoundary: 1,
            phraseLength: 4,
          ),
        ),
      );
      if (plan.patternTag == 'bridge_return_home_cadence') {
        selectedPlan = plan;
        break;
      }
    }

    expect(selectedPlan, isNotNull);
    expect(selectedPlan!.finalKeyCenter.tonicName, 'C');
    expect(selectedPlan.finalKeyCenter.mode, KeyMode.major);
    expect(selectedPlan.finalRomanNumeralId, RomanNumeralId.iiMin7);
    expect(selectedPlan.modulationKind, ModulationKind.real);
    expect(selectedPlan.debug.surfaceTags.contains('bridgeReturn'), isTrue);
    expect(
      selectedPlan.remainingQueuedChords.any(
        (item) => item.finalRomanNumeralId == RomanNumeralId.vDom7,
      ),
      isTrue,
    );
    expect(
      selectedPlan.remainingQueuedChords.any(
        (item) =>
            item.cadentialArrival &&
            (item.finalRomanNumeralId == RomanNumeralId.iMaj69 ||
                item.finalRomanNumeralId == RomanNumeralId.iMaj7),
      ),
      isTrue,
    );
  });

  test(
    'bridge return home cadence is disabled without inferred home trace',
    () {
      for (var seed = 0; seed < 256; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 27,
            activeKeys: const ['C', 'G'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'G',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.turnaroundTail,
              harmonicDensity: HarmonicDensity.turnaroundSplit,
              barInPhrase: 2,
              barsToBoundary: 1,
              phraseLength: 4,
            ),
          ),
        );
        expect(plan.patternTag, isNot('bridge_return_home_cadence'));
      }
    },
  );

  test(
    'bridge return home cadence can use home center carried on the current trace',
    () {
      SmartStepPlan? selectedPlan;
      final currentTrace = SmartDecisionTrace(
        stepIndex: 26,
        currentKeyCenter: 'G major',
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        phraseContext: const SmartPhraseContext(
          phraseRole: PhraseRole.continuation,
          sectionRole: SectionRole.bridgeLike,
          harmonicDensity: HarmonicDensity.twoChordsPerBar,
          barInPhrase: 6,
          barsToBoundary: 1,
          phraseLength: 8,
        ),
        homeCenterLabel: 'C major',
        finalKeyCenter: 'G major',
        finalKeyMode: KeyMode.major,
        finalKeyRelation: KeyRelation.same,
        finalRomanNumeralId: RomanNumeralId.iMaj69,
        decision: 'queued-family-step',
      );

      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 27,
            activeKeys: const ['C', 'G'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'G',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentTrace: currentTrace,
            phraseContext: const SmartPhraseContext(
              phraseRole: PhraseRole.cadence,
              sectionRole: SectionRole.turnaroundTail,
              harmonicDensity: HarmonicDensity.turnaroundSplit,
              barInPhrase: 2,
              barsToBoundary: 1,
              phraseLength: 4,
            ),
          ),
        );
        if (plan.patternTag == 'bridge_return_home_cadence') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(selectedPlan!.finalKeyCenter.tonicName, 'C');
      expect(selectedPlan.debug.surfaceTags.contains('bridgeReturn'), isTrue);
    },
  );

  test(
    'simulation can return from bridge material to the initial home center',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(21),
        steps: 2200,
        request: buildStartRequest(
          activeKeys: const ['C', 'G'],
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
        ),
      );

      final initialTrace = summary.traces.firstWhere(
        (trace) => trace.decision == 'seeded-initial-tonic',
        orElse: () => summary.traces.first,
      );
      expect(
        summary.familyHistogram['bridge_return_home_cadence'] ?? 0,
        greaterThan(0),
      );
      expect(
        summary.cadenceHistogram['bridge_return_home'] ?? 0,
        greaterThan(0),
      );
      final returnZoneCount =
          (summary.bridgeReturnSectionHistogram['bridgeLike'] ?? 0) +
          (summary.bridgeReturnSectionHistogram['turnaroundTail'] ?? 0) +
          (summary.bridgeReturnSectionHistogram['tag'] ?? 0);
      expect(returnZoneCount, greaterThan(0));
      expect(
        summary.traces.any(
          (trace) =>
              trace.activePatternTag == 'bridge_return_home_cadence' &&
              trace.finalKeyCenter == initialTrace.currentKeyCenter,
        ),
        isTrue,
      );
    },
  );

  test('simulation summary exposes QA checks and export fields', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(19),
      steps: 1200,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    expect(summary.jazzPreset, JazzPreset.standardsCore);
    expect(
      summary.qaChecks.any((check) => check.id == 'core_family_balance'),
      isTrue,
    );
    expect(
      summary.qaChecks.any((check) => check.id == 'direct_applied_jump_guard'),
      isTrue,
    );
    expect(
      summary.qaChecks.any(
        (check) => check.id == 'bridge_return_followthrough',
      ),
      isTrue,
    );
    expect(summary.toJson()['qaChecks'], isA<List<Object?>>());
    expect(summary.toJson()['returnHomeDebtOpenCount'], isA<int>());
    expect(summary.toJson()['returnHomeOpportunityCount'], isA<int>());
    expect(summary.toJson()['returnHomeSelectionCount'], isA<int>());
    expect(summary.toCsv().contains('qa:core_family_balance'), isTrue);
    expect(summary.toCsv().contains('returnHomeDebtPayoffCount'), isTrue);
    expect(summary.toCsv().contains('returnHomeSelectionCount'), isTrue);
  });

  test('dominant chain away from home opens a return-home debt on arrival', () {
    seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

    SmartStepPlan? currentPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 19,
          activeKeys: const ['C', 'G', 'D', 'A'],
          currentKeyCenter: const KeyCenter(
            tonicName: 'G',
            mode: KeyMode.major,
          ),
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.continuation,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 4,
            barsToBoundary: 3,
            phraseLength: 8,
          ),
        ),
      );
      if (plan.patternTag == 'dominant_chain_bridge_style') {
        currentPlan = plan;
        break;
      }
    }

    expect(currentPlan, isNotNull);

    for (
      var stepIndex = 20;
      stepIndex <= 25 && !(currentPlan?.cadentialArrival ?? false);
      stepIndex += 1
    ) {
      currentPlan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          stepIndex: stepIndex,
          activeKeys: const ['C', 'G', 'D', 'A'],
          currentKeyCenter: currentPlan!.finalKeyCenter,
          currentRomanNumeralId: currentPlan.finalRomanNumeralId,
          currentResolutionRomanNumeralId: currentPlan.resolutionTargetRomanId,
          currentHarmonicFunction: MusicTheory.specFor(
            currentPlan.finalRomanNumeralId,
          ).harmonicFunction,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          currentPatternTag: currentPlan.patternTag,
          plannedQueue: currentPlan.remainingQueuedChords,
          currentTrace: currentPlan.debug,
          phraseContext: const SmartPhraseContext(
            phraseRole: PhraseRole.continuation,
            sectionRole: SectionRole.bridgeLike,
            harmonicDensity: HarmonicDensity.twoChordsPerBar,
            barInPhrase: 5,
            barsToBoundary: 2,
            phraseLength: 8,
          ),
        ),
      );
    }

    expect(currentPlan, isNotNull);
    expect(currentPlan!.cadentialArrival, isTrue);
    expect(currentPlan.finalRomanNumeralId, RomanNumeralId.iMaj69);
    expect(currentPlan.finalKeyCenter.tonicName, 'G');
    expect(currentPlan.debug.surfaceTags.contains('returnHomePending'), isTrue);
    expect(
      currentPlan.debug.outstandingDebts.any(
        (debt) =>
            debt.debtType == ResolutionDebtType.returnHomeCadence &&
            debt.targetLabel == 'C major',
      ),
      isTrue,
    );
  });

  test('return-home debt increases bridge return selection pressure', () {
    seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

    const phraseContext = SmartPhraseContext(
      phraseRole: PhraseRole.cadence,
      sectionRole: SectionRole.turnaroundTail,
      harmonicDensity: HarmonicDensity.turnaroundSplit,
      barInPhrase: 2,
      barsToBoundary: 1,
      phraseLength: 4,
    );

    final withoutDebtTrace = SmartDecisionTrace(
      stepIndex: 24,
      currentKeyCenter: 'G major',
      currentRomanNumeralId: RomanNumeralId.iMaj69,
      currentHarmonicFunction: HarmonicFunction.tonic,
      phraseContext: phraseContext,
      finalKeyCenter: 'G major',
      finalKeyMode: KeyMode.major,
      finalKeyRelation: KeyRelation.same,
      finalRomanNumeralId: RomanNumeralId.iMaj69,
      decision: 'seeded-family:dominant_chain_bridge_style',
      activePatternTag: 'dominant_chain_bridge_style',
      cadentialArrival: true,
      surfaceTags: const ['tonicMaj69'],
    );
    final withDebtTrace = SmartDecisionTrace(
      stepIndex: withoutDebtTrace.stepIndex,
      currentKeyCenter: withoutDebtTrace.currentKeyCenter,
      currentRomanNumeralId: withoutDebtTrace.currentRomanNumeralId,
      currentHarmonicFunction: withoutDebtTrace.currentHarmonicFunction,
      phraseContext: withoutDebtTrace.phraseContext,
      finalKeyCenter: withoutDebtTrace.finalKeyCenter,
      finalKeyMode: withoutDebtTrace.finalKeyMode,
      finalKeyRelation: withoutDebtTrace.finalKeyRelation,
      finalRomanNumeralId: withoutDebtTrace.finalRomanNumeralId,
      decision: withoutDebtTrace.decision,
      activePatternTag: withoutDebtTrace.activePatternTag,
      cadentialArrival: withoutDebtTrace.cadentialArrival,
      outstandingDebts: const [
        ResolutionDebt(
          debtType: ResolutionDebtType.returnHomeCadence,
          targetLabel: 'C major',
          deadline: 4,
          severity: 3,
        ),
      ],
      surfaceTags: const ['tonicMaj69', 'returnHomePending'],
    );

    int countBridgeReturns(SmartDecisionTrace trace) {
      var count = 0;
      for (var seed = 0; seed < 256; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 27,
            activeKeys: const ['C', 'G'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'G',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentTrace: trace,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'bridge_return_home_cadence') {
          count += 1;
        }
      }
      return count;
    }

    final withoutDebtCount = countBridgeReturns(withoutDebtTrace);
    final withDebtCount = countBridgeReturns(withDebtTrace);

    expect(withDebtCount, greaterThan(withoutDebtCount));
  });

  test(
    'return-home debt in cadence window prioritizes bridge return over competing cadences',
    () {
      seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.cadence,
        sectionRole: SectionRole.turnaroundTail,
        harmonicDensity: HarmonicDensity.turnaroundSplit,
        barInPhrase: 2,
        barsToBoundary: 1,
        phraseLength: 4,
      );
      final currentTrace = SmartDecisionTrace(
        stepIndex: 24,
        currentKeyCenter: 'G major',
        currentRomanNumeralId: RomanNumeralId.iMaj69,
        currentHarmonicFunction: HarmonicFunction.tonic,
        phraseContext: phraseContext,
        homeCenterLabel: 'C major',
        finalKeyCenter: 'G major',
        finalKeyMode: KeyMode.major,
        finalKeyRelation: KeyRelation.same,
        finalRomanNumeralId: RomanNumeralId.iMaj69,
        decision: 'seeded-family:dominant_chain_bridge_style',
        activePatternTag: 'dominant_chain_bridge_style',
        cadentialArrival: true,
        outstandingDebts: const [
          ResolutionDebt(
            debtType: ResolutionDebtType.returnHomeCadence,
            targetLabel: 'C major',
            deadline: 4,
            severity: 3,
          ),
        ],
        surfaceTags: const ['tonicMaj69', 'returnHomePending'],
      );

      final histogram = <String, int>{};
      for (var seed = 0; seed < 512; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 27,
            activeKeys: const ['C', 'G'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'G',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentTrace: currentTrace,
            phraseContext: phraseContext,
          ),
        );
        histogram.update(
          plan.patternTag ?? 'fallback',
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      final bridgeReturnCount = histogram['bridge_return_home_cadence'] ?? 0;
      final competingCadenceCount =
          (histogram['closing_plagal_authentic_hybrid'] ?? 0) +
          (histogram['core_ii_v_i_major'] ?? 0) +
          (histogram['cadence_based_real_modulation'] ?? 0) +
          (histogram['common_chord_modulation'] ?? 0);

      expect(bridgeReturnCount, greaterThan(competingCadenceCount));
    },
  );

  test('bridge return cadence clears a pending return-home debt', () {
    seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

    const phraseContext = SmartPhraseContext(
      phraseRole: PhraseRole.cadence,
      sectionRole: SectionRole.turnaroundTail,
      harmonicDensity: HarmonicDensity.turnaroundSplit,
      barInPhrase: 2,
      barsToBoundary: 1,
      phraseLength: 4,
    );
    final currentTrace = SmartDecisionTrace(
      stepIndex: 24,
      currentKeyCenter: 'G major',
      currentRomanNumeralId: RomanNumeralId.iMaj69,
      currentHarmonicFunction: HarmonicFunction.tonic,
      phraseContext: phraseContext,
      finalKeyCenter: 'G major',
      finalKeyMode: KeyMode.major,
      finalKeyRelation: KeyRelation.same,
      finalRomanNumeralId: RomanNumeralId.iMaj69,
      decision: 'seeded-family:dominant_chain_bridge_style',
      activePatternTag: 'dominant_chain_bridge_style',
      cadentialArrival: true,
      outstandingDebts: const [
        ResolutionDebt(
          debtType: ResolutionDebtType.returnHomeCadence,
          targetLabel: 'C major',
          deadline: 4,
          severity: 3,
        ),
      ],
      surfaceTags: const ['tonicMaj69', 'returnHomePending'],
    );

    SmartStepPlan? currentPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(seed),
        request: buildRequest(
          stepIndex: 27,
          activeKeys: const ['C', 'G'],
          currentKeyCenter: const KeyCenter(
            tonicName: 'G',
            mode: KeyMode.major,
          ),
          currentRomanNumeralId: RomanNumeralId.iMaj69,
          currentHarmonicFunction: HarmonicFunction.tonic,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          currentTrace: currentTrace,
          phraseContext: phraseContext,
        ),
      );
      if (plan.patternTag == 'bridge_return_home_cadence') {
        currentPlan = plan;
        break;
      }
    }

    expect(currentPlan, isNotNull);
    for (
      var stepIndex = 28;
      stepIndex <= 31 && !(currentPlan?.cadentialArrival ?? false);
      stepIndex += 1
    ) {
      currentPlan = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          stepIndex: stepIndex,
          activeKeys: const ['C', 'G'],
          currentKeyCenter: currentPlan!.finalKeyCenter,
          currentRomanNumeralId: currentPlan.finalRomanNumeralId,
          currentResolutionRomanNumeralId: currentPlan.resolutionTargetRomanId,
          currentHarmonicFunction: MusicTheory.specFor(
            currentPlan.finalRomanNumeralId,
          ).harmonicFunction,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          currentPatternTag: currentPlan.patternTag,
          plannedQueue: currentPlan.remainingQueuedChords,
          currentTrace: currentPlan.debug,
          phraseContext: phraseContext,
        ),
      );
    }

    expect(currentPlan, isNotNull);
    expect(currentPlan!.cadentialArrival, isTrue);
    expect(currentPlan.finalKeyCenter.tonicName, 'C');
    expect(
      currentPlan.debug.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
      ),
      isFalse,
    );
  });

  test(
    'advanced preset can seed chromatic mediant common-tone modulation with a borrowed pivot',
    () {
      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 2048; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'chromatic_mediant_common_tone_modulation') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(
        selectedPlan!.finalRomanNumeralId,
        RomanNumeralId.borrowedFlatIIIMaj7,
      );
      expect(selectedPlan.finalKeyCenter.tonicName, 'C');
      expect(selectedPlan.modulationAttempt, isTrue);
      expect(selectedPlan.modulationKind, ModulationKind.none);
      expect(
        selectedPlan.debug.surfaceTags.contains('chromaticMediant'),
        isTrue,
      );
      expect(selectedPlan.debug.surfaceTags.contains('rareColor'), isTrue);
      expect(
        selectedPlan.debug.outstandingDebts.any(
          (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
        ),
        isTrue,
      );
      expect(selectedPlan.remainingQueuedChords, isNotEmpty);
      expect(
        selectedPlan.remainingQueuedChords.first.finalRomanNumeralId,
        RomanNumeralId.iiMin7,
      );
      expect(
        selectedPlan.remainingQueuedChords.first.keyCenter.tonicName,
        'D#/Eb',
      );
      expect(
        selectedPlan.remainingQueuedChords.first.modulationKind,
        ModulationKind.real,
      );
      expect(
        selectedPlan.remainingQueuedChords.first.satisfiedDebtTypes,
        contains(ResolutionDebtType.rareColorPayoff),
      );
      expect(
        selectedPlan.remainingQueuedChords.any(
          (item) =>
              item.keyCenter.tonicName == 'D#/Eb' &&
              item.cadentialArrival &&
              item.finalRomanNumeralId == RomanNumeralId.iMaj69,
        ),
        isTrue,
      );
    },
  );

  test(
    'chromatic mediant common-tone modulation pays off rare-color debt on the target cadence head',
    () {
      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      SmartStepPlan? pivotPlan;
      for (var seed = 0; seed < 2048; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'chromatic_mediant_common_tone_modulation') {
          pivotPlan = plan;
          break;
        }
      }

      expect(pivotPlan, isNotNull);
      final cadenceHead = SmartGeneratorHelper.planNextStep(
        random: _FixedRandom(0),
        request: buildRequest(
          stepIndex: 23,
          activeKeys: const ['C', 'D#/Eb'],
          currentKeyCenter: pivotPlan!.finalKeyCenter,
          currentRomanNumeralId: pivotPlan.finalRomanNumeralId,
          currentHarmonicFunction: MusicTheory.specFor(
            pivotPlan.finalRomanNumeralId,
          ).harmonicFunction,
          jazzPreset: JazzPreset.advanced,
          sourceProfile: SourceProfile.recordingInspired,
          modulationIntensity: ModulationIntensity.high,
          currentPatternTag: pivotPlan.patternTag,
          plannedQueue: pivotPlan.remainingQueuedChords,
          currentTrace: pivotPlan.debug,
          phraseContext: phraseContext,
        ),
      );

      expect(
        cadenceHead.patternTag,
        'chromatic_mediant_common_tone_modulation',
      );
      expect(cadenceHead.finalKeyCenter.tonicName, 'D#/Eb');
      expect(cadenceHead.finalRomanNumeralId, RomanNumeralId.iiMin7);
      expect(cadenceHead.modulationKind, ModulationKind.real);
      expect(
        cadenceHead.debug.surfaceTags.contains('chromaticMediantResolve'),
        isTrue,
      );
      expect(
        cadenceHead.debug.outstandingDebts.any(
          (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
        ),
        isFalse,
      );
    },
  );

  test(
    'chromatic mediant fallback stays family-aware across pivot and cadence stages',
    () {
      final pivotFallbacks = SmartGeneratorHelper.prioritizedFallbackRomans(
        keyMode: KeyMode.major,
        finalRomanNumeralId: RomanNumeralId.borrowedFlatIIIMaj7,
        harmonicFunction: HarmonicFunction.tonic,
        patternTag: 'chromatic_mediant_common_tone_modulation',
      );
      final cadenceFallbacks = SmartGeneratorHelper.prioritizedFallbackRomans(
        keyMode: KeyMode.major,
        finalRomanNumeralId: RomanNumeralId.iiMin7,
        harmonicFunction: HarmonicFunction.predominant,
        patternTag: 'chromatic_mediant_common_tone_modulation',
      );

      expect(pivotFallbacks.take(4), [
        RomanNumeralId.borrowedFlatIIIMaj7,
        RomanNumeralId.borrowedFlatVIMaj7,
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
      ]);
      expect(cadenceFallbacks.take(4), [
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj69,
        RomanNumeralId.iMaj7,
      ]);
    },
  );

  test(
    'chromatic mediant common-tone modulation stays disabled below the advanced preset',
    () {
      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        expect(
          plan.patternTag,
          isNot('chromatic_mediant_common_tone_modulation'),
        );
      }
    },
  );

  test(
    'chromatic mediant common-tone modulation appears in advanced simulations only',
    () {
      final modulationStudy = findChromaticMediantSummary(
        jazzPreset: JazzPreset.modulationStudy,
      );
      final advanced = findChromaticMediantSummary(
        jazzPreset: JazzPreset.advanced,
      );

      expect(modulationStudy, isNull);
      expect(advanced, isNotNull);
      expect(
        advanced!.familyHistogram['chromatic_mediant_common_tone_modulation'] ??
            0,
        greaterThan(0),
      );
      expect(advanced.rareColorUsage['chromaticMediant'] ?? 0, greaterThan(0));
      expect(
        advanced.traces.any(
          (trace) =>
              trace.activePatternTag ==
                  'chromatic_mediant_common_tone_modulation' &&
              trace.modulationKind == ModulationKind.real &&
              trace.finalKeyRelation == KeyRelation.mediant,
        ),
        isTrue,
      );
    },
  );

  test(
    'advanced chromatic mediant simulation exposes density and followthrough diagnostics',
    () {
      final summary = findChromaticMediantSummary(
        jazzPreset: JazzPreset.advanced,
      );

      expect(summary, isNotNull);

      final qa = summary!.qaChecks.firstWhere(
        (check) => check.id == 'chromatic_mediant_followthrough',
      );
      expect(summary.chromaticMediantStartCount, greaterThan(0));
      expect(summary.chromaticMediantDensity, greaterThan(0));
      expect(summary.chromaticMediantPayoffCount, greaterThan(0));
      expect(
        summary.chromaticMediantFailedPayoffCount,
        greaterThanOrEqualTo(0),
      );
      expect(
        summary.cadenceHistogram['chromatic_mediant_authentic'] ?? 0,
        greaterThan(0),
      );
      expect(qa.status, isNot(SmartQaStatus.fail));
      expect(qa.detail.contains('failed='), isTrue);

      final json = summary.toJson();
      expect(
        json['chromaticMediantStartCount'],
        summary.chromaticMediantStartCount,
      );
      expect(json['chromaticMediantDensity'], summary.chromaticMediantDensity);
      expect(
        json['chromaticMediantPayoffCount'],
        summary.chromaticMediantPayoffCount,
      );
      expect(
        json['chromaticMediantFailedPayoffCount'],
        summary.chromaticMediantFailedPayoffCount,
      );

      final csv = summary.toCsv();
      expect(csv.contains('chromaticMediantStartCount'), isTrue);
      expect(csv.contains('chromaticMediantPayoffCount'), isTrue);
      expect(csv.contains('chromaticMediantFailedPayoffCount'), isTrue);
      expect(csv.contains('qa:chromatic_mediant_followthrough'), isTrue);
    },
  );

  test(
    'chromatic mediant away cadence can hand off to bridge return followthrough',
    () {
      seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      SmartStepPlan? currentPlan;
      for (var seed = 0; seed < 2048; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'chromatic_mediant_common_tone_modulation') {
          currentPlan = plan;
          break;
        }
      }

      expect(currentPlan, isNotNull);
      SmartStepPlan? cadenceArrival;
      while (currentPlan!.remainingQueuedChords.isNotEmpty) {
        currentPlan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentPatternTag: currentPlan.patternTag,
            plannedQueue: currentPlan.remainingQueuedChords,
            currentTrace: currentPlan.debug,
            phraseContext: phraseContext,
          ),
        );
        if (currentPlan.cadentialArrival) {
          cadenceArrival = currentPlan;
        }
      }

      expect(cadenceArrival, isNotNull);
      expect(cadenceArrival!.finalKeyCenter.tonicName, 'D#/Eb');
      expect(
        cadenceArrival.debug.surfaceTags.contains('returnHomePending'),
        isTrue,
      );
      expect(
        currentPlan.debug.outstandingDebts.any(
          (debt) =>
              debt.debtType == ResolutionDebtType.returnHomeCadence &&
              debt.targetLabel == 'C major',
        ),
        isTrue,
      );

      SmartStepPlan? returnPlan;
      const returnPhraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.cadence,
        sectionRole: SectionRole.turnaroundTail,
        harmonicDensity: HarmonicDensity.turnaroundSplit,
        barInPhrase: 2,
        barsToBoundary: 1,
        phraseLength: 4,
      );
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'D#/Eb'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentTrace: currentPlan.debug,
            phraseContext: returnPhraseContext,
          ),
        );
        if (plan.patternTag == 'bridge_return_home_cadence') {
          returnPlan = plan;
          break;
        }
      }

      expect(returnPlan, isNotNull);
      expect(returnPlan!.finalKeyCenter.tonicName, 'C');
      expect(returnPlan.patternTag, 'bridge_return_home_cadence');
    },
  );

  test(
    'advanced preset can seed a coltrane burst and reach a second symmetric target',
    () {
      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      SmartStepPlan? currentPlan;
      for (var seed = 0; seed < 4096; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'coltrane_burst') {
          currentPlan = plan;
          break;
        }
      }

      expect(currentPlan, isNotNull);
      final visited = <String>[
        '${currentPlan!.finalKeyCenter.tonicName}:${currentPlan.finalRomanNumeralId.name}',
      ];
      while (currentPlan!.remainingQueuedChords.isNotEmpty) {
        currentPlan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentPatternTag: currentPlan.patternTag,
            plannedQueue: currentPlan.remainingQueuedChords,
            currentTrace: currentPlan.debug,
            phraseContext: phraseContext,
          ),
        );
        visited.add(
          '${currentPlan.finalKeyCenter.tonicName}:${currentPlan.finalRomanNumeralId.name}',
        );
      }

      expect(visited, [
        'E:iiMin7',
        'E:vDom7',
        'E:iMaj69',
        'G#/Ab:iiMin7',
        'G#/Ab:vDom7',
        'G#/Ab:iMaj69',
        'G#/Ab:viMin7',
      ]);
      expect(
        currentPlan.debug.surfaceTags.contains('cycleConfirmation'),
        isTrue,
      );
      expect(
        currentPlan.debug.outstandingDebts.any(
          (debt) => debt.debtType == ResolutionDebtType.modulationConfirm,
        ),
        isFalse,
      );
    },
  );

  test(
    'coltrane burst away arrival opens return-home debt and can hand off to bridge return',
    () {
      seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      SmartStepPlan? currentPlan;
      for (var seed = 0; seed < 4096; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        if (plan.patternTag == 'coltrane_burst') {
          currentPlan = plan;
          break;
        }
      }

      expect(currentPlan, isNotNull);
      SmartStepPlan? secondArrival;
      while (currentPlan!.remainingQueuedChords.isNotEmpty) {
        currentPlan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentPatternTag: currentPlan.patternTag,
            plannedQueue: currentPlan.remainingQueuedChords,
            currentTrace: currentPlan.debug,
            phraseContext: phraseContext,
          ),
        );
        if (currentPlan.cadentialArrival &&
            currentPlan.finalKeyCenter.tonicName == 'G#/Ab') {
          secondArrival = currentPlan;
        }
      }

      expect(secondArrival, isNotNull);
      expect(
        secondArrival!.debug.surfaceTags.contains('returnHomePending'),
        isTrue,
      );
      expect(
        currentPlan.debug.outstandingDebts.any(
          (debt) =>
              debt.debtType == ResolutionDebtType.returnHomeCadence &&
              debt.targetLabel == 'C major',
        ),
        isTrue,
      );
      expect(currentPlan.finalRomanNumeralId, RomanNumeralId.viMin7);

      SmartStepPlan? returnPlan;
      const returnPhraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.cadence,
        sectionRole: SectionRole.turnaroundTail,
        harmonicDensity: HarmonicDensity.turnaroundSplit,
        barInPhrase: 2,
        barsToBoundary: 1,
        phraseLength: 4,
      );
      for (var seed = 0; seed < 2048; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: currentPlan.finalKeyCenter,
            currentRomanNumeralId: currentPlan.finalRomanNumeralId,
            currentHarmonicFunction: MusicTheory.specFor(
              currentPlan.finalRomanNumeralId,
            ).harmonicFunction,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            currentTrace: currentPlan.debug,
            phraseContext: returnPhraseContext,
          ),
        );
        if (plan.patternTag == 'bridge_return_home_cadence') {
          returnPlan = plan;
          break;
        }
      }

      expect(returnPlan, isNotNull);
      expect(returnPlan!.finalKeyCenter.tonicName, 'C');
      expect(returnPlan.debug.surfaceTags.contains('bridgeReturn'), isTrue);
    },
  );

  test(
    'coltrane burst stays disabled without a full cycle or below the advanced preset',
    () {
      const phraseContext = SmartPhraseContext(
        phraseRole: PhraseRole.preCadence,
        sectionRole: SectionRole.bridgeLike,
        harmonicDensity: HarmonicDensity.twoChordsPerBar,
        barInPhrase: 6,
        barsToBoundary: 2,
        phraseLength: 8,
      );

      for (var seed = 0; seed < 2048; seed += 1) {
        final missingCycle = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );
        final belowAdvanced = SmartGeneratorHelper.planNextStep(
          random: _FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'G#/Ab'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            phraseContext: phraseContext,
          ),
        );

        expect(missingCycle.patternTag, isNot('coltrane_burst'));
        expect(belowAdvanced.patternTag, isNot('coltrane_burst'));
      }
    },
  );

  test('preset comparison QA reports modulation lift over standardsCore', () {
    final standardsCore = SmartGeneratorHelper.simulateSteps(
      random: Random(20),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.high,
      ),
    );
    final modulationStudy = SmartGeneratorHelper.simulateSteps(
      random: Random(20),
      steps: 1600,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    final comparison = SmartGeneratorHelper.compareSimulationSummaries(
      baseline: standardsCore,
      candidate: modulationStudy,
    );
    final modulationLift = comparison.qaChecks.firstWhere(
      (check) => check.id == 'modulation_density_lift',
    );

    expect(comparison.baselinePreset, JazzPreset.standardsCore);
    expect(comparison.candidatePreset, JazzPreset.modulationStudy);
    expect(modulationLift.status, isNot(SmartQaStatus.fail));
    expect(comparison.toJson()['qaChecks'], isA<List<Object?>>());
    expect(comparison.toCsv().contains('modulation_density_lift'), isTrue);
  });

  test('recordingInspired emits meaningful sus release realizations', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(7),
      steps: 1200,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    expect(summary.susResolutionOpportunities, greaterThan(0));
    expect(summary.susReleaseCount, greaterThan(0));
  });

  test('dominant-headed local scopes appear in applied families', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(8),
      steps: 1000,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        modulationIntensity: ModulationIntensity.medium,
      ),
    );

    final scopedTrace = summary.traces.firstWhere(
      (trace) =>
          trace.activePatternTag == 'applied_dominant_with_related_ii' &&
          trace.activeLocalScope != null,
    );

    expect(scopedTrace.activeLocalScope!.headType, ScopeHeadType.dominantHead);
  });

  test('direct applied-to-new-tonic violations remain zero', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(9),
      steps: 1200,
      request: buildStartRequest(
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.advanced,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    expect(summary.directAppliedToNewTonicViolations, 0);
  });

  test('same-root sus release scoring prefers plain dominant payoff', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = realizeVoiceLed(
      candidate: SmartRenderCandidate(
        keyCenter: center,
        romanNumeralId: RomanNumeralId.vDom7,
        renderQualityOverride: ChordQuality.dominant13sus4,
      ),
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          smartDebug: buildTrace(
            currentRomanNumeralId: RomanNumeralId.vDom7,
            currentHarmonicFunction: HarmonicFunction.dominant,
          ),
        ),
      ],
    );
    final plainRelease = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality == ChordQuality.dominant7,
    );
    final susCarry = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality ==
              ChordQuality.dominant13sus4 ||
          candidate.chord.symbolData.renderQuality ==
              ChordQuality.dominant7sus4,
    );

    expect(
      comparison.selected.chord.symbolData.renderQuality,
      ChordQuality.dominant7,
    );
    expect(plainRelease.voiceLeading.sameRootSusPayoffBonus, greaterThan(0));
    expect(
      plainRelease.voiceLeading.total,
      greaterThan(susCarry.voiceLeading.total),
    );
    expect(
      (comparison.selected.chord.smartDebug as SmartDecisionTrace?)
          ?.voiceLeadingSummary,
      isNotNull,
    );
  });

  test(
    'sus override candidates downgrade to dominant7 when V7sus4 is disabled',
    () {
      const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
      final comparison = compareVoiceLeading(
        allowV7sus4: false,
        candidates: const [
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.vDom7,
            renderQualityOverride: ChordQuality.dominant13sus4,
            dominantContext: DominantContext.susDominant,
            dominantIntent: DominantIntent.susDelay,
          ),
        ],
      );

      expect(
        comparison.selected.chord.symbolData.renderQuality,
        ChordQuality.dominant7,
      );
      expect(
        comparison.rankedCandidates.any(
          (candidate) =>
              candidate.chord.symbolData.renderQuality ==
                  ChordQuality.dominant13sus4 ||
              candidate.chord.symbolData.renderQuality ==
                  ChordQuality.dominant7sus4,
        ),
        isFalse,
      );
    },
  );

  test('quality-implied color tones influence voice-leading ranking', () {
    final previousChord = GeneratedChord(
      symbolData: const ChordSymbolData(
        root: 'A',
        harmonicQuality: ChordQuality.dominant7,
        renderQuality: ChordQuality.dominant7,
      ),
      repeatGuardKey: 'a7',
      harmonicComparisonKey: 'a7',
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      keyName: 'C',
      romanNumeralId: RomanNumeralId.secondaryOfII,
      harmonicFunction: HarmonicFunction.dominant,
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.vDom7,
          renderQualityOverride: ChordQuality.dominant7,
        ),
        SmartRenderCandidate(
          keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.vDom7,
          renderQualityOverride: ChordQuality.dominant7Sharp11,
          dominantIntent: DominantIntent.lydianDominant,
        ),
      ],
    );
    final plain = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality == ChordQuality.dominant7,
    );
    final sharp11 = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality ==
          ChordQuality.dominant7Sharp11,
    );

    expect(
      comparison.selected.chord.symbolData.renderQuality,
      ChordQuality.dominant7Sharp11,
    );
    expect(
      sharp11.voiceLeading.commonToneRetentionBonus,
      greaterThan(plain.voiceLeading.commonToneRetentionBonus),
    );
  });

  test('major69 sixth participates in guide-tone resolution scoring', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = GeneratedChord(
      symbolData: const ChordSymbolData(
        root: 'C',
        harmonicQuality: ChordQuality.major69,
        renderQuality: ChordQuality.major69,
      ),
      repeatGuardKey: 'c69GuideTone',
      harmonicComparisonKey: 'c69GuideTone',
      keyCenter: center,
      keyName: 'C',
      romanNumeralId: RomanNumeralId.iMaj69,
      harmonicFunction: HarmonicFunction.tonic,
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.ivMaj7,
        ),
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        ),
      ],
    );
    final ivArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.ivMaj7,
    );
    final flatVIIArrival = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.romanNumeralId == RomanNumeralId.borrowedFlatVII7,
    );

    expect(
      flatVIIArrival.voiceLeading.guideToneSemitoneBonus,
      greaterThan(ivArrival.voiceLeading.guideToneSemitoneBonus),
    );
    expect(
      comparison.selected.chord.romanNumeralId,
      RomanNumeralId.borrowedFlatVII7,
    );
  });

  test('guide-tone semitone resolution outranks a weaker alternative path', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = realizeVoiceLed(
      candidate: const SmartRenderCandidate(
        keyCenter: center,
        romanNumeralId: RomanNumeralId.vDom7,
        renderQualityOverride: ChordQuality.dominant7,
      ),
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iiMin7,
        ),
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iMaj7,
        ),
      ],
    );
    final tonicArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.iMaj7,
    );
    final iiArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.iiMin7,
    );

    expect(comparison.selected.chord.romanNumeralId, RomanNumeralId.iMaj7);
    expect(
      tonicArrival.voiceLeading.guideToneSemitoneBonus,
      greaterThan(iiArrival.voiceLeading.guideToneSemitoneBonus),
    );
    expect(
      tonicArrival.voiceLeading.total,
      greaterThan(iiArrival.voiceLeading.total),
    );
  });

  test(
    'large root leap loses to a same-function fallback with smoother motion',
    () {
      const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
      final previousChord = realizeVoiceLed(
        candidate: const SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iiiMin7,
        ),
      );

      final comparison = compareVoiceLeading(
        previousChord: previousChord,
        candidates: const [
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.borrowedFlatVII7,
          ),
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.vDom7,
            renderQualityOverride: ChordQuality.dominant7,
          ),
        ],
      );
      final backdoorDominant = comparison.rankedCandidates.firstWhere(
        (candidate) =>
            candidate.chord.romanNumeralId == RomanNumeralId.borrowedFlatVII7,
      );
      final primaryDominant = comparison.rankedCandidates.firstWhere(
        (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.vDom7,
      );

      expect(comparison.selected.chord.romanNumeralId, RomanNumeralId.vDom7);
      expect(backdoorDominant.voiceLeading.rootLeapPenalty, lessThan(0));
      expect(primaryDominant.voiceLeading.rootLeapPenalty, 0);
      expect(
        primaryDominant.voiceLeading.total,
        greaterThan(backdoorDominant.voiceLeading.total),
      );
    },
  );
}

