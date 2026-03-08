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

  SmartStepRequest buildRequest({
    String currentKey = 'C',
    String currentRomanNumeral = 'IM7',
    String? currentResolutionRomanNumeral,
    String currentHarmonicFunction = 'tonic',
    bool secondaryDominantEnabled = false,
    bool substituteDominantEnabled = false,
    List<String> modulationCandidateKeys = const [],
    String? previousRomanNumeral,
    String? previousHarmonicFunction,
    bool previousWasAppliedDominant = false,
    String? currentPatternTag,
    List<QueuedSmartChord> plannedQueue = const [],
  }) {
    return SmartStepRequest(
      currentKey: currentKey,
      currentRomanNumeral: currentRomanNumeral,
      currentResolutionRomanNumeral: currentResolutionRomanNumeral,
      currentHarmonicFunction: currentHarmonicFunction,
      allowedDiatonicRomanNumerals: diatonicRomans,
      secondaryDominantEnabled: secondaryDominantEnabled,
      substituteDominantEnabled: substituteDominantEnabled,
      modulationCandidateKeys: modulationCandidateKeys,
      previousRomanNumeral: previousRomanNumeral,
      previousHarmonicFunction: previousHarmonicFunction,
      previousWasAppliedDominant: previousWasAppliedDominant,
      currentPatternTag: currentPatternTag,
      plannedQueue: plannedQueue,
    );
  }

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
      request: buildRequest(),
    );

    expect(plan.finalKey, 'C');
    expect(plan.finalRomanNumeral, 'IIm7');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, isNull);
    expect(plan.appliedType, isNull);
  });

  test('secondary dominant inserts a destination-oriented applied chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 80]),
      request: buildRequest(secondaryDominantEnabled: true),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, 'V7/II');
    expect(plan.debug.appliedTargetRomanNumeral, 'IIm7');
    expect(plan.appliedType, AppliedType.secondary);
    expect(plan.finalRomanNumeral, 'V7/II');
  });

  test('substitute dominant inserts a tritone substitute approach chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 95]),
      request: buildRequest(substituteDominantEnabled: true),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, 'IIm7');
    expect(plan.debug.insertedAppliedApproach, 'subV7/II');
    expect(plan.debug.appliedTargetRomanNumeral, 'IIm7');
    expect(plan.appliedType, AppliedType.substitute);
    expect(plan.finalRomanNumeral, 'subV7/II');
  });

  test('applied resolution can modulate into another active key', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 0]),
      request: buildRequest(
        currentRomanNumeral: 'V7/V',
        currentResolutionRomanNumeral: 'V7',
        currentHarmonicFunction: 'appliedDominant',
        secondaryDominantEnabled: true,
        modulationCandidateKeys: const ['G'],
      ),
    );

    expect(plan.finalKey, 'G');
    expect(plan.finalRomanNumeral, 'IM7');
    expect(plan.debug.appliedTargetRomanNumeral, 'V7');
    expect(plan.debug.modulationCandidateKeys, ['G']);
    expect(plan.resolutionTargetRoman, 'V7');
  });

  test('major tonic line cliche queues on tonic resting context', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0]),
      request: buildRequest(
        previousRomanNumeral: 'IM7',
        previousHarmonicFunction: 'tonic',
      ),
    );

    expect(plan.finalRomanNumeral, 'IM7');
    expect(plan.plannedChordKind, PlannedChordKind.tonicDominant7);
    expect(plan.patternTag, 'major-tonic-cliche');
    expect(plan.remainingQueuedChords, hasLength(1));
    expect(
      plan.remainingQueuedChords.first.plannedChordKind,
      PlannedChordKind.tonicSix,
    );
    expect(plan.renderingPlan.suppressTensions, isTrue);
    expect(plan.returnedToNormalFlow, isFalse);
  });

  test('major tonic line cliche can start after dominant arrival', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0]),
      request: buildRequest(
        previousRomanNumeral: 'V7',
        previousHarmonicFunction: 'dominant',
      ),
    );

    expect(plan.plannedChordKind, PlannedChordKind.tonicDominant7);
    expect(plan.patternTag, 'major-tonic-cliche');
  });

  test('queued line cliche chord returns to normal flow on last step', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([99]),
      request: buildRequest(
        currentPatternTag: 'major-tonic-cliche',
        plannedQueue: const [
          QueuedSmartChord(
            finalRomanNumeral: 'IM7',
            plannedChordKind: PlannedChordKind.tonicSix,
            patternTag: 'major-tonic-cliche',
            suppressTensions: true,
          ),
        ],
      ),
    );

    expect(plan.finalRomanNumeral, 'IM7');
    expect(plan.plannedChordKind, PlannedChordKind.tonicSix);
    expect(plan.returnedToNormalFlow, isTrue);
    expect(plan.remainingQueuedChords, isEmpty);
    expect(plan.debug.returnedToNormalFlow, isTrue);
  });

  test('compatible modulation keys are matched by tonic semitone', () {
    const tonicSemitones = {'C': 0, 'C#/Db': 1, 'D': 2, 'G': 7};

    final candidates = SmartGeneratorHelper.findCompatibleModulationKeys(
      activeKeys: tonicSemitones.keys,
      currentKey: 'C',
      targetSemitone: 1,
      keyTonicSemitoneResolver: (key) => tonicSemitones[key],
    );

    expect(candidates, ['C#/Db']);
  });
}
