import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/main.dart';
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

void main() {
  test('tension selection is disabled when Allow Tensions is off', () {
    final tensions = ChordRenderingHelper.selectTensions(
      random: _FixedRandom(0),
      romanNumeral: 'V7',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      allowTensions: false,
      selectedTensionOptions: {'9', 'b9'},
      suppressTensions: false,
    );

    expect(tensions, isEmpty);
  });

  test('selected chips filter roman tension candidates directly', () {
    final tensions = ChordRenderingHelper.selectTensions(
      random: _FixedRandom(0),
      romanNumeral: 'V7',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      allowTensions: true,
      selectedTensionOptions: {'9'},
      suppressTensions: false,
    );

    expect(tensions, ['9']);
  });

  test('V7-family altered tensions are removed when chips are disabled', () {
    final tensions = ChordRenderingHelper.selectTensions(
      random: _FixedRandom(0),
      romanNumeral: 'V7',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      allowTensions: true,
      selectedTensionOptions: {'9'},
      suppressTensions: false,
    );

    expect(tensions, isNot(contains('b9')));
    expect(tensions, isNot(contains('#9')));
    expect(tensions, isNot(contains('#11')));
    expect(tensions, isNot(contains('b13')));
  });

  test(
    'safe dominant tension pairs are available when both chips are enabled',
    () {
      final tensions = ChordRenderingHelper.selectTensions(
        random: _FixedRandom(0),
        romanNumeral: 'V7',
        plannedChordKind: PlannedChordKind.resolvedRoman,
        allowTensions: true,
        selectedTensionOptions: {'9', '#11'},
        suppressTensions: false,
      );

      expect(tensions, ['9', '#11']);
    },
  );

  test('line cliche planned chords suppress tensions', () {
    final tensions = ChordRenderingHelper.selectTensions(
      random: _FixedRandom(0),
      romanNumeral: 'IM7',
      plannedChordKind: PlannedChordKind.tonicDominant7,
      allowTensions: true,
      selectedTensionOptions: {...ChordRenderingHelper.supportedTensionOptions},
      suppressTensions: true,
    );

    expect(tensions, isEmpty);
  });

  test(
    'repeat guard keys are metadata-based and ignore surface decoration',
    () {
      final dominantKey = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        harmonicFunction: 'dominant',
        plannedChordKind: PlannedChordKind.resolvedRoman,
        baseChord: 'G7',
      );
      final decoratedDominantKey = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        harmonicFunction: 'dominant',
        plannedChordKind: PlannedChordKind.resolvedRoman,
        baseChord: 'G7',
      );
      final tonicDominant7Key = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        harmonicFunction: 'tonic',
        plannedChordKind: PlannedChordKind.tonicDominant7,
        baseChord: 'C7',
        patternTag: 'major-tonic-cliche',
      );
      final tonicSixKey = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        harmonicFunction: 'tonic',
        plannedChordKind: PlannedChordKind.tonicSix,
        baseChord: 'C6',
        patternTag: 'major-tonic-cliche',
      );

      expect(dominantKey, decoratedDominantKey);
      expect(tonicDominant7Key, isNot(tonicSixKey));
    },
  );

  test('harmonic comparison key distinguishes tonic cliche identities', () {
    final ordinaryTonic = ChordRenderingHelper.buildHarmonicComparisonKey(
      keyName: 'C',
      romanNumeral: 'IM7',
      harmonicFunction: 'tonic',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      baseChord: 'CM7',
    );
    final tonicDominant7 = ChordRenderingHelper.buildHarmonicComparisonKey(
      keyName: 'C',
      romanNumeral: 'IM7',
      harmonicFunction: 'tonic',
      plannedChordKind: PlannedChordKind.tonicDominant7,
      baseChord: 'C7',
      patternTag: 'major-tonic-cliche',
    );

    expect(ordinaryTonic, isNot(tonicDominant7));
  });

  test('renderChordSymbol formats V7sus4 and tensions consistently', () {
    final rendered = ChordRenderingHelper.renderChordSymbol(
      baseChord: 'G7',
      surfaceVariant: SurfaceVariant.dominantSus4,
      tensions: const ['b9'],
    );

    expect(rendered, 'G7sus4(b9)');
  });
}

