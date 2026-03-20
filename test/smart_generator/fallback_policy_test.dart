import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

  test('excluded fallback leaves a trace blocked reason', () {
    final plan = SmartGeneratorHelper.planInitialStep(
      random: SequenceRandom(const [0, 0, 0, 0]),
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
}
