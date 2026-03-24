import 'package:chordest/practice/widgets/practice_chord_swipe_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'look-ahead chord moves in while previous and current shift left',
    (tester) async {
      final surfaceKey = GlobalKey<PracticeChordSwipeSurfaceState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 640,
                height: 320,
                child: PracticeChordSwipeSurface(
                  key: surfaceKey,
                  previousLabel: 'Dm7',
                  currentLabel: 'G7',
                  nextLabel: 'Cmaj7',
                  lookAheadLabel: 'Fmaj7',
                  compact: false,
                  performanceMode: false,
                  statusLabel: 'Autoplay',
                  currentInsight: const PracticeChordInsight(
                    sectionLabel: 'Current',
                    keyLabel: 'C major',
                    functionLabel: 'V',
                  ),
                  nextInsight: const PracticeChordInsight(
                    sectionLabel: 'Next',
                    keyLabel: 'C major',
                    functionLabel: 'I',
                  ),
                  playing: true,
                  beatsPerBar: 4,
                  currentBeat: 1,
                  prioritizeControls: false,
                  availableBackSteps: 1,
                  onTapAdvance: () {},
                  onTapGoBack: () {},
                  onSwipeAdvance: () {},
                  onSwipeGoBack: () {},
                  controls: const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      );

      final nextFinder = find.byKey(const ValueKey('next-chord-position'));
      final lookAheadFinder = find.byKey(
        const ValueKey('lookahead-chord-position'),
      );

      final restNextX = tester.getCenter(nextFinder).dx;
      final restLookAheadX = tester.getCenter(lookAheadFinder).dx;

      surfaceKey.currentState!.animateAdvance(onCompleted: () {});
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 130));

      final midNextX = tester.getCenter(nextFinder).dx;
      final midLookAheadX = tester.getCenter(lookAheadFinder).dx;

      expect(midNextX, lessThan(restNextX));
      expect(midLookAheadX, lessThan(restLookAheadX));
      expect(midLookAheadX, greaterThan(midNextX));
    },
  );
}
