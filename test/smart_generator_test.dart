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

void main() {
  test('weighted selection follows configured Roman numeral bands', () {
    final tonicStart = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(0),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: const ['VIm7', 'IIm7', 'IIIm7', 'IVM7', 'V7'],
    );
    final tonicMiddle = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(62),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: const ['VIm7', 'IIm7', 'IIIm7', 'IVM7', 'V7'],
    );
    final tonicEnd = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(97),
      currentRomanNumeral: 'IM7',
      allowedRomanNumerals: const ['VIm7', 'IIm7', 'IIIm7', 'IVM7', 'V7'],
    );

    expect(tonicStart.selectedRomanNumeral, 'VIm7');
    expect(tonicMiddle.selectedRomanNumeral, 'IIm7');
    expect(tonicEnd.selectedRomanNumeral, 'V7');
  });

  test('selection filters disallowed candidates before rolling', () {
    final selection = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(0),
      currentRomanNumeral: 'IIm7',
      allowedRomanNumerals: const ['IVM7'],
    );

    expect(selection.hasSelection, isTrue);
    expect(selection.selectedRomanNumeral, 'IVM7');
    expect(selection.debug.availableCandidates.single.romanNumeral, 'IVM7');
  });

  test('selection returns fallback debug when no candidates survive filtering', () {
    final selection = SmartGeneratorHelper.selectNextRoman(
      random: _FixedRandom(0),
      currentRomanNumeral: 'V7',
      allowedRomanNumerals: const <String>[],
    );

    expect(selection.hasSelection, isFalse);
    expect(selection.selectedRomanNumeral, isNull);
    expect(selection.debug.usedFallback, isTrue);
    expect(selection.debug.fallbackReason, isNotEmpty);
  });
}
