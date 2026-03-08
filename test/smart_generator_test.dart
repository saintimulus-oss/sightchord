import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
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

void main() {
  const diatonicRomans = [
    'IM7',
    'IIm7',
    'IIIm7',
    'IVM7',
    'V7',
    'VIm7',
    'VIIm7b5',
  ];

  test('weighted selection follows configured Roman numeral bands', () {
    final tonicStart = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(0),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: diatonicRomans,
    );
    final tonicMiddle = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(62),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: diatonicRomans,
    );
    final tonicEnd = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(97),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: diatonicRomans,
    );

    expect(tonicStart.selectedRomanNumeral, 'VIm7');
    expect(tonicMiddle.selectedRomanNumeral, 'IIm7');
    expect(tonicEnd.selectedRomanNumeral, 'V7');
  });

  test('non-diatonic off keeps diatonic smart flow intact', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50]),
      request: const SmartStepRequest(
        currentKey: 'C',
        currentRomanNumeral: 'IM7',
        currentResolutionRomanNumeral: null,
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: false,
        substituteDominantEnabled: false,
        modulationCandidateKeys: [],
      ),
    );

    expect(plan.finalKey, 'C');
    expect(plan.finalRomanNumeral, 'IIm7');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, isNull);
  });

  test('secondary dominant inserts a destination-oriented applied chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 80]),
      request: const SmartStepRequest(
        currentKey: 'C',
        currentRomanNumeral: 'IM7',
        currentResolutionRomanNumeral: null,
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: true,
        substituteDominantEnabled: false,
        modulationCandidateKeys: [],
      ),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, 'V7/II');
    expect(plan.debug.appliedTargetRomanNumeral, 'IIm7');
    expect(plan.finalRomanNumeral, 'V7/II');
  });

  test('substitute dominant inserts a tritone substitute approach chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 95]),
      request: const SmartStepRequest(
        currentKey: 'C',
        currentRomanNumeral: 'IM7',
        currentResolutionRomanNumeral: null,
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: false,
        substituteDominantEnabled: true,
        modulationCandidateKeys: [],
      ),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, 'subV7/II');
    expect(plan.debug.appliedTargetRomanNumeral, 'IIm7');
    expect(plan.finalRomanNumeral, 'subV7/II');
  });

  test('applied resolution can modulate into another active key', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 0]),
      request: const SmartStepRequest(
        currentKey: 'C',
        currentRomanNumeral: 'V7/V',
        currentResolutionRomanNumeral: 'V7',
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: true,
        substituteDominantEnabled: false,
        modulationCandidateKeys: ['G'],
      ),
    );

    expect(plan.finalKey, 'G');
    expect(plan.finalRomanNumeral, 'IM7');
    expect(plan.debug.appliedTargetRomanNumeral, 'V7');
    expect(plan.debug.modulationCandidateKeys, ['G']);
  });

  test('modulation keeps the new key context for the following smart step', () {
    final modulationPlan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 0]),
      request: const SmartStepRequest(
        currentKey: 'C',
        currentRomanNumeral: 'V7/V',
        currentResolutionRomanNumeral: 'V7',
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: true,
        substituteDominantEnabled: false,
        modulationCandidateKeys: ['G'],
      ),
    );

    final nextPlan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50]),
      request: SmartStepRequest(
        currentKey: modulationPlan.finalKey,
        currentRomanNumeral: modulationPlan.finalRomanNumeral,
        currentResolutionRomanNumeral: null,
        allowedDiatonicRomanNumerals: diatonicRomans,
        secondaryDominantEnabled: false,
        substituteDominantEnabled: false,
        modulationCandidateKeys: const [],
      ),
    );

    expect(modulationPlan.finalKey, 'G');
    expect(nextPlan.finalKey, 'G');
    expect(nextPlan.finalRomanNumeral, 'IIm7');
    expect(nextPlan.debug.currentKey, 'G');
  });

  test('compatible modulation keys are matched by tonic semitone', () {
    const tonicSemitones = {
      'C': 0,
      'C#/Db': 1,
      'D': 2,
      'G': 7,
    };

    final candidates = SmartGeneratorHelper.findCompatibleModulationKeys(
      activeKeys: tonicSemitones.keys,
      currentKey: 'C',
      targetSemitone: 1,
      keyTonicSemitoneResolver: (key) => tonicSemitones[key],
    );

    expect(candidates, ['C#/Db']);
  });
}
