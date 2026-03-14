import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/smart_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'major-family candidates can simplify to triads when only triads are enabled',
    () {
      final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
        random: Random(7),
        allowV7sus4: false,
        allowedRenderQualities: {ChordQuality.majorTriad},
        candidates: const [
          SmartRenderCandidate(
            keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
            romanNumeralId: RomanNumeralId.iMaj7,
          ),
        ],
      );

      expect(comparison.rankedCandidates, isNotEmpty);
      expect(
        comparison.selected.chord.symbolData.renderQuality,
        ChordQuality.majorTriad,
      );
    },
  );

  test(
    'dominant-family candidates can expose augmented triads when enabled',
    () {
      final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
        random: Random(11),
        allowV7sus4: true,
        allowedRenderQualities: {ChordQuality.augmentedTriad},
        candidates: const [
          SmartRenderCandidate(
            keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
            romanNumeralId: RomanNumeralId.vDom7,
          ),
        ],
      );

      expect(comparison.rankedCandidates, isNotEmpty);
      expect(
        comparison.selected.chord.symbolData.renderQuality,
        ChordQuality.augmentedTriad,
      );
    },
  );
}
