import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

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
      random: FixedRandom(0),
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
          random: FixedRandom(seed),
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
        random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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
        random: FixedRandom(seed),
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
    'local ii-V-I stabilizes the IV area without declaring real modulation',
    () {
      SmartStepPlan? startPlan;
      for (var seed = 0; seed < 320; seed += 1) {
        final plan = SmartGeneratorHelper.planNextStep(
          random: FixedRandom(seed),
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
          random: FixedRandom(0),
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
        random: FixedRandom(seed),
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
          random: FixedRandom(seed),
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

  test('classical predominant color opens and pays rare-color debt', () {
    SmartStepPlan? selectedPlan;
    for (var seed = 0; seed < 1024; seed += 1) {
      final plan = SmartGeneratorHelper.planNextStep(
        random: FixedRandom(seed),
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
}
