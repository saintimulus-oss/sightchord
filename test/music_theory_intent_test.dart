import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';

void main() {
  group('dominant intent/context mapping', () {
    test('maps dominant headed scope intent to a dominant context', () {
      expect(
        MusicTheory.dominantContextForIntent(
          DominantIntent.dominantHeadedScope,
        ),
        DominantContext.secondaryToMajor,
      );
    });

    test(
      'round-trips known dominant context values through intent mapping',
      () {
        expect(
          MusicTheory.dominantContextForIntent(
            MusicTheory.dominantIntentForContext(DominantContext.backdoor),
          ),
          DominantContext.backdoor,
        );
      },
    );
  });
}

