import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
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

SmartStepRequest buildRequest({
  String currentKey = 'C',
  RomanNumeralId currentRomanNumeralId = RomanNumeralId.iMaj7,
  RomanNumeralId? currentResolutionRomanNumeralId,
  HarmonicFunction currentHarmonicFunction = HarmonicFunction.tonic,
  bool secondaryDominantEnabled = false,
  bool substituteDominantEnabled = false,
  bool modalInterchangeEnabled = false,
  List<String> modulationCandidateKeys = const [],
  RomanNumeralId? previousRomanNumeralId,
  HarmonicFunction? previousHarmonicFunction,
  bool previousWasAppliedDominant = false,
  String? currentPatternTag,
  List<QueuedSmartChord> plannedQueue = const [],
  bool currentRenderedNonDiatonic = false,
}) {
  return SmartStepRequest(
    currentKey: currentKey,
    currentRomanNumeralId: currentRomanNumeralId,
    currentResolutionRomanNumeralId: currentResolutionRomanNumeralId,
    currentHarmonicFunction: currentHarmonicFunction,
    allowedDiatonicRomanNumerals: MusicTheory.diatonicRomans,
    secondaryDominantEnabled: secondaryDominantEnabled,
    substituteDominantEnabled: substituteDominantEnabled,
    modalInterchangeEnabled: modalInterchangeEnabled,
    modulationCandidateKeys: modulationCandidateKeys,
    previousRomanNumeralId: previousRomanNumeralId,
    previousHarmonicFunction: previousHarmonicFunction,
    previousWasAppliedDominant: previousWasAppliedDominant,
    currentPatternTag: currentPatternTag,
    plannedQueue: plannedQueue,
    currentRenderedNonDiatonic: currentRenderedNonDiatonic,
  );
}

void main() {
  test('weighted selection follows configured Roman numeral bands', () {
    final tonicStart = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(0),
      currentRomanNumeralId: RomanNumeralId.iMaj7,
      allowedRomanNumerals: MusicTheory.diatonicRomans,
    );
    final tonicMiddle = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(62),
      currentRomanNumeralId: RomanNumeralId.iMaj7,
      allowedRomanNumerals: MusicTheory.diatonicRomans,
    );
    final tonicEnd = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(97),
      currentRomanNumeralId: RomanNumeralId.iMaj7,
      allowedRomanNumerals: MusicTheory.diatonicRomans,
    );

    expect(tonicStart.selectedRomanNumeralId, RomanNumeralId.viMin7);
    expect(tonicMiddle.selectedRomanNumeralId, RomanNumeralId.iiMin7);
    expect(tonicEnd.selectedRomanNumeralId, RomanNumeralId.vDom7);
  });

  test('non-diatonic off keeps diatonic smart flow intact', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50]),
      request: buildRequest(),
    );

    expect(plan.finalKey, 'C');
    expect(plan.finalRomanNumeralId, RomanNumeralId.iiMin7);
    expect(plan.debug.selectedDiatonicDestination, RomanNumeralId.iiMin7);
    expect(plan.debug.insertedAppliedApproach, isNull);
    expect(plan.appliedType, isNull);
  });

  test('secondary dominant inserts a destination-oriented applied chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 80]),
      request: buildRequest(secondaryDominantEnabled: true),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, RomanNumeralId.iiMin7);
    expect(plan.debug.insertedAppliedApproach, RomanNumeralId.secondaryOfII);
    expect(
      plan.debug.appliedTargetRomanNumeralId,
      RomanNumeralId.iiMin7,
    );
    expect(plan.appliedType, AppliedType.secondary);
    expect(plan.finalRomanNumeralId, RomanNumeralId.secondaryOfII);
  });

  test('substitute dominant inserts a tritone substitute approach chord', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([50, 95]),
      request: buildRequest(substituteDominantEnabled: true),
    );

    expect(plan.finalKey, 'C');
    expect(plan.debug.selectedDiatonicDestination, RomanNumeralId.iiMin7);
    expect(plan.debug.insertedAppliedApproach, RomanNumeralId.substituteOfII);
    expect(
      plan.debug.appliedTargetRomanNumeralId,
      RomanNumeralId.iiMin7,
    );
    expect(plan.appliedType, AppliedType.substitute);
    expect(plan.finalRomanNumeralId, RomanNumeralId.substituteOfII);
  });

  test('applied resolution can modulate into another active key', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 0]),
      request: buildRequest(
        currentRomanNumeralId: RomanNumeralId.secondaryOfV,
        currentResolutionRomanNumeralId: RomanNumeralId.vDom7,
        currentHarmonicFunction: HarmonicFunction.dominant,
        secondaryDominantEnabled: true,
        modulationCandidateKeys: const ['G'],
        currentRenderedNonDiatonic: true,
      ),
    );

    expect(plan.finalKey, 'G');
    expect(plan.finalRomanNumeralId, RomanNumeralId.iMaj7);
    expect(
      plan.debug.appliedTargetRomanNumeralId,
      RomanNumeralId.vDom7,
    );
    expect(plan.debug.modulationCandidateKeys, ['G']);
    expect(plan.resolutionTargetRomanId, RomanNumeralId.vDom7);
  });

  test('major tonic line cliche queues on tonic resting context', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0]),
      request: buildRequest(
        previousRomanNumeralId: RomanNumeralId.iMaj7,
        previousHarmonicFunction: HarmonicFunction.tonic,
      ),
    );

    expect(plan.finalRomanNumeralId, RomanNumeralId.iMaj7);
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

  test('modal interchange can queue a backdoor cadence', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 0, 0]),
      request: buildRequest(
        modalInterchangeEnabled: true,
        currentHarmonicFunction: HarmonicFunction.tonic,
      ),
    );

    expect(plan.finalRomanNumeralId, RomanNumeralId.borrowedIvMin7);
    expect(plan.patternTag, 'backdoor-cadence');
    expect(
      plan.remainingQueuedChords.map((chord) => chord.finalRomanNumeralId),
      [RomanNumeralId.borrowedFlatVII7, RomanNumeralId.iMaj7],
    );
  });

  test('modal interchange can queue borrowed minor ii-V-I', () {
    final plan = SmartGeneratorHelper.planNextStep(
      random: _SequenceRandom([0, 0, 40, 0]),
      request: buildRequest(
        currentRomanNumeralId: RomanNumeralId.iiMin7,
        currentHarmonicFunction: HarmonicFunction.predominant,
        modalInterchangeEnabled: true,
      ),
    );

    expect(
      plan.finalRomanNumeralId,
      RomanNumeralId.borrowedIiHalfDiminished7,
    );
    expect(plan.patternTag, 'borrowed-minor-ii-v-i');
    expect(
      plan.remainingQueuedChords.map((chord) => chord.finalRomanNumeralId),
      [RomanNumeralId.vDom7, RomanNumeralId.iMaj7],
    );
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
