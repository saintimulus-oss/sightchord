import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';

void main() {
  group('relationBetweenCenters', () {
    const cMajor = KeyCenter(tonicName: 'C', mode: KeyMode.major);

    test('preserves directed dominant and subdominant relationships', () {
      expect(
        MusicTheory.relationBetweenCenters(
          cMajor,
          const KeyCenter(tonicName: 'G', mode: KeyMode.major),
        ),
        KeyRelation.dominant,
      );
      expect(
        MusicTheory.relationBetweenCenters(
          cMajor,
          const KeyCenter(tonicName: 'F', mode: KeyMode.major),
        ),
        KeyRelation.subdominant,
      );
    });

    test('keeps relative and parallel classification intact', () {
      expect(
        MusicTheory.relationBetweenCenters(
          cMajor,
          const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
        ),
        KeyRelation.relative,
      );
      expect(
        MusicTheory.relationBetweenCenters(
          cMajor,
          const KeyCenter(tonicName: 'C', mode: KeyMode.minor),
        ),
        KeyRelation.parallel,
      );
    });

    test(
      'keeps chromatic mediant classification intact in both directions',
      () {
        expect(
          MusicTheory.relationBetweenCenters(
            cMajor,
            const KeyCenter(tonicName: 'E', mode: KeyMode.major),
          ),
          KeyRelation.mediant,
        );
        expect(
          MusicTheory.relationBetweenCenters(
            cMajor,
            const KeyCenter(tonicName: 'Ab', mode: KeyMode.major),
          ),
          KeyRelation.mediant,
        );
      },
    );
  });
}
