import 'fixtures.dart';

double _realModulationDensity(SmartSimulationSummary summary) {
  return summary.realModulationCount / summary.steps;
}

double _fallbackRatio(SmartSimulationSummary summary) {
  return summary.fallbackCount / summary.steps;
}

double _coreFamilyRatio(SmartSimulationSummary summary) {
  final totalStarts = summary.familyHistogram.values.fold<int>(
    0,
    (sum, count) => sum + count,
  );
  if (totalStarts == 0) {
    return 0;
  }
  final coreStarts =
      (summary.familyHistogram['core_ii_v_i_major'] ?? 0) +
      (summary.familyHistogram['turnaround_i_vi_ii_v'] ?? 0) +
      (summary.familyHistogram['minor_ii_halfdim_v_alt_i'] ?? 0);
  return coreStarts / totalStarts;
}

void main() {
  smartGeneratorTestSetUp();

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

  test(
    'settings combinations keep smart generation alive across common setups',
    () {
      final summaries = <String, SmartSimulationSummary>{
        'beginner_core': SmartGeneratorHelper.simulateSteps(
          random: Random(31),
          steps: 72,
          request: buildStartRequest(
            activeKeys: const ['C'],
            secondaryDominantEnabled: false,
            substituteDominantEnabled: false,
            modalInterchangeEnabled: false,
            modulationIntensity: ModulationIntensity.off,
            jazzPreset: JazzPreset.standardsCore,
            chordLanguageLevel: ChordLanguageLevel.triadsOnly,
            romanPoolPreset: RomanPoolPreset.corePrimary,
            allowTensions: false,
            allowV7sus4: false,
          ),
        ),
        'phrase_aware_modulation': SmartGeneratorHelper.simulateSteps(
          random: Random(32),
          steps: 96,
          request: buildStartRequest(
            activeKeys: const ['C', 'G', 'A'],
            jazzPreset: JazzPreset.modulationStudy,
            modulationIntensity: ModulationIntensity.high,
            harmonicRhythmPreset: HarmonicRhythmPreset.phraseAwareJazz,
            timeSignature: PracticeTimeSignature.fourFour,
          ),
        ),
        'advanced_recording': SmartGeneratorHelper.simulateSteps(
          random: Random(33),
          steps: 120,
          request: buildStartRequest(
            activeKeys: const ['C', 'D#/Eb', 'G'],
            jazzPreset: JazzPreset.advanced,
            sourceProfile: SourceProfile.recordingInspired,
            modulationIntensity: ModulationIntensity.high,
            modalInterchangeEnabled: true,
          ),
        ),
      };

      for (final entry in summaries.entries) {
        expect(
          entry.value.traces,
          hasLength(entry.value.steps),
          reason: entry.key,
        );
        expect(entry.value.qaChecks, isNotEmpty, reason: entry.key);
        expect(
          entry.value.traces.every(
            (trace) => trace.finalRomanNumeralId != null,
          ),
          isTrue,
          reason: entry.key,
        );
        expect(
          entry.value.traces.any((trace) => trace.finalChord != null),
          isTrue,
          reason: entry.key,
        );
      }
    },
  );

  test('preset summary harness keeps core and modulation baselines intact', () {
    const seeds = <int>[40, 41, 42];

    SmartSimulationSummary aggregateFor(
      JazzPreset preset, {
      required List<String> activeKeys,
      SourceProfile sourceProfile = SourceProfile.fakebookStandard,
      ModulationIntensity modulationIntensity = ModulationIntensity.high,
    }) {
      return aggregateSimulationSummaries([
        for (final seed in seeds)
          SmartGeneratorHelper.simulateSteps(
            random: Random(seed),
            steps: 600,
            request: buildStartRequest(
              activeKeys: activeKeys,
              jazzPreset: preset,
              sourceProfile: sourceProfile,
              modulationIntensity: modulationIntensity,
            ),
          ),
      ]);
    }

    final standardsCore = aggregateFor(
      JazzPreset.standardsCore,
      activeKeys: const ['C', 'G', 'A'],
    );
    final modulationStudy = aggregateFor(
      JazzPreset.modulationStudy,
      activeKeys: const ['C', 'G', 'A'],
    );
    final advanced = aggregateFor(
      JazzPreset.advanced,
      activeKeys: const ['C', 'D#/Eb', 'G'],
      sourceProfile: SourceProfile.recordingInspired,
    );

    expect(_coreFamilyRatio(standardsCore), greaterThan(0.2));
    expect(_fallbackRatio(standardsCore), lessThan(0.25));
    expect(
      _realModulationDensity(modulationStudy),
      greaterThan(_realModulationDensity(standardsCore)),
    );
    expect(_realModulationDensity(modulationStudy), greaterThan(0.008));
    expect(_fallbackRatio(modulationStudy), lessThan(0.3));
    expect(advanced.directAppliedToNewTonicViolations, 0);
    expect(advanced.susResolutionOpportunities, greaterThan(0));
    expect(advanced.fallbackCount, lessThan(advanced.steps ~/ 3));
  });
}
