import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

  test(
    'mixture pivot modulation can use a borrowed pivot into parallel minor',
    () {
      SmartStepPlan? selectedPlan;
      for (var seed = 0; seed < 1024; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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
          random: FixedRandom(0),
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
          random: FixedRandom(seed),
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
        random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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

  test('dominant chain away from home opens a return-home debt on arrival', () {
    seedInitialHomeTrace(tonicName: 'C', mode: KeyMode.major);

    SmartStepPlan? currentPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: FixedRandom(seed),
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
        random: FixedRandom(0),
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
          random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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
        random: FixedRandom(seed),
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
        random: FixedRandom(0),
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'Eb'],
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
        'Eb',
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
              item.keyCenter.tonicName == 'Eb' &&
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'Eb'],
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
        random: FixedRandom(0),
        request: buildRequest(
          stepIndex: 23,
          activeKeys: const ['C', 'Eb'],
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
      expect(cadenceHead.finalKeyCenter.tonicName, 'Eb');
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'Eb'],
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'Eb'],
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
          random: FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'Eb'],
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
      expect(cadenceArrival!.finalKeyCenter.tonicName, 'Eb');
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'Eb'],
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'Ab'],
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
          random: FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'Ab'],
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
        'Ab:iiMin7',
        'Ab:vDom7',
        'Ab:iMaj69',
        'Ab:viMin7',
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'Ab'],
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
          random: FixedRandom(0),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'Ab'],
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
            currentPlan.finalKeyCenter.tonicName == 'Ab') {
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: currentPlan.debug.stepIndex + 1,
            activeKeys: const ['C', 'E', 'Ab'],
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
          random: FixedRandom(seed),
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
          random: FixedRandom(seed),
          request: buildRequest(
            stepIndex: 22,
            activeKeys: const ['C', 'E', 'Ab'],
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
}
