import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

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
          random: FixedRandom(seed),
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
        random: FixedRandom(seed),
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
        random: FixedRandom(0),
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

  test('single active key blocks fresh modulation attempts', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: FixedRandom(0),
      request: buildRequest(
        stepIndex: 8,
        activeKeys: const ['C'],
        selectedKeyCenters: const [
          KeyCenter(tonicName: 'C', mode: KeyMode.major),
        ],
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

    expect(plan.debug.blockedReason, SmartBlockedReason.singleActiveKey);
    expect(plan.debug.modulationKind, isNot(ModulationKind.real));
  });

  test('low-priority phrase position blocks fresh modulation attempts', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: FixedRandom(0),
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
      random: FixedRandom(0),
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
        random: FixedRandom(0),
        request: buildRequest(
          stepIndex: 12,
          activeKeys: const ['C', 'Gb'],
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
      random: FixedRandom(0),
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

  test(
    'modal branch selection reports modalBranchChosen when modulation candidates exist',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 4096; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 10,
            activeKeys: const ['C', 'G', 'A'],
            currentKeyCenter: const KeyCenter(
              tonicName: 'C',
              mode: KeyMode.major,
            ),
            currentRomanNumeralId: RomanNumeralId.iMaj69,
            currentHarmonicFunction: HarmonicFunction.tonic,
            jazzPreset: JazzPreset.modulationStudy,
            modulationIntensity: ModulationIntensity.high,
            modalInterchangeEnabled: true,
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
        if (plan.patternTag == 'backdoor_ivm_bVII_I') {
          selectedPlan = plan;
          break;
        }
      }

      expect(selectedPlan, isNotNull);
      expect(
        selectedPlan!.debug.blockedReason,
        SmartBlockedReason.modalBranchChosen,
      );
    },
  );

  test('initial smart-generator home starts on the selected key as major', () {
    final plan = SmartGeneratorHelper.planInitialStep(
      random: FixedRandom(0),
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
}
