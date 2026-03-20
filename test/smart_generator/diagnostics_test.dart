import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

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
      phraseContext: testPhraseContext,
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
      phraseContext: testPhraseContext,
      finalRenderedNonDiatonic: true,
    );

    final json = trace.toJson();
    expect(json['finalRenderedNonDiatonic'], isTrue);
    expect(trace.describe(), contains('finalRenderedNonDiatonic=true'));
  });

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

  test('preset comparison QA reports modulation lift over standardsCore', () {
    const seeds = <int>[20, 21, 22, 23];
    final standardsCore = aggregateSimulationSummaries([
      for (final seed in seeds)
        SmartGeneratorHelper.simulateSteps(
          random: Random(seed),
          steps: 1600,
          request: buildStartRequest(
            activeKeys: const ['C', 'G', 'A'],
            jazzPreset: JazzPreset.standardsCore,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
          ),
        ),
    ]);
    final modulationStudy = aggregateSimulationSummaries([
      for (final seed in seeds)
        SmartGeneratorHelper.simulateSteps(
          random: Random(seed),
          steps: 1600,
          request: buildStartRequest(
            activeKeys: const ['C', 'G', 'A'],
            jazzPreset: JazzPreset.modulationStudy,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
          ),
        ),
    ]);

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
}
