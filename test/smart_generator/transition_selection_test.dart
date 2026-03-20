import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

  test(
    'phrase-aware presets allow consecutive repeats at phrase boundaries',
    () {
      const cadenceContext = SmartPhraseContext(
        phraseRole: PhraseRole.cadence,
        sectionRole: SectionRole.turnaroundTail,
        harmonicDensity: HarmonicDensity.oneChordPerBar,
        barInPhrase: 2,
        barsToBoundary: 1,
        phraseLength: 4,
        eventIndexInBar: 0,
        eventsInBar: 1,
      );

      expect(
        SmartGeneratorHelper.allowsConsecutiveRepeat(
          harmonicRhythmPreset: HarmonicRhythmPreset.phraseAwareJazz,
          phraseContext: cadenceContext,
        ),
        isTrue,
      );
      expect(
        SmartGeneratorHelper.allowsConsecutiveRepeat(
          harmonicRhythmPreset: HarmonicRhythmPreset.cadenceCompression,
          phraseContext: cadenceContext,
        ),
        isTrue,
      );
    },
  );

  test('regular fixed-grid presets keep consecutive-repeat guardrails', () {
    const continuationContext = SmartPhraseContext(
      phraseRole: PhraseRole.continuation,
      sectionRole: SectionRole.aLike,
      harmonicDensity: HarmonicDensity.twoChordsPerBar,
      barInPhrase: 1,
      barsToBoundary: 6,
      phraseLength: 8,
      eventIndexInBar: 0,
      eventsInBar: 2,
    );

    expect(
      SmartGeneratorHelper.allowsConsecutiveRepeat(
        harmonicRhythmPreset: HarmonicRhythmPreset.onePerBar,
        phraseContext: continuationContext,
      ),
      isFalse,
    );
    expect(
      SmartGeneratorHelper.allowsConsecutiveRepeat(
        harmonicRhythmPreset: HarmonicRhythmPreset.twoPerBar,
        phraseContext: continuationContext,
      ),
      isFalse,
    );
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
}
