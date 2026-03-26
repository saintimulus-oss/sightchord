import 'package:chordest/practice/widgets/practice_chord_swipe_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSurface(
    GlobalKey<PracticeChordSwipeSurfaceState> surfaceKey, {
    PracticeChordInsight? currentInsight,
    PracticeChordInsight? nextInsight,
  }) {
    return MaterialApp(
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
              currentInsight:
                  currentInsight ??
                  const PracticeChordInsight(
                    sectionLabel: 'Current',
                    keyLabel: 'C major',
                    functionLabel: 'V',
                  ),
              nextInsight:
                  nextInsight ??
                  const PracticeChordInsight(
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
    );
  }

  testWidgets(
    'look-ahead chord moves in while previous and current shift left',
    (tester) async {
      final surfaceKey = GlobalKey<PracticeChordSwipeSurfaceState>();

      await tester.pumpWidget(buildSurface(surfaceKey));

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

  testWidgets(
    'highlight handoff reaches the incoming chord early in an advance',
    (tester) async {
      final surfaceKey = GlobalKey<PracticeChordSwipeSurfaceState>();

      await tester.pumpWidget(buildSurface(surfaceKey));

      DecoratedBox highlightedBox(String key) {
        return tester.widget<DecoratedBox>(find.byKey(ValueKey(key)));
      }

      int surfaceAlpha(String key) {
        final decoration = highlightedBox(key).decoration as BoxDecoration;
        final alpha = decoration.color?.a ?? 0;
        return (alpha * 255).round().clamp(0, 255);
      }

      expect(
        surfaceAlpha('current-chord-highlight'),
        greaterThan(surfaceAlpha('next-chord-highlight')),
      );

      surfaceKey.currentState!.animateAdvance(onCompleted: () {});
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));

      expect(
        surfaceAlpha('next-chord-highlight'),
        greaterThan(surfaceAlpha('current-chord-highlight')),
      );
    },
  );

  testWidgets(
    'relation line keeps the pill layout when current and next summaries match',
    (tester) async {
      final surfaceKey = GlobalKey<PracticeChordSwipeSurfaceState>();

      await tester.pumpWidget(
        buildSurface(
          surfaceKey,
          currentInsight: const PracticeChordInsight(
            sectionLabel: 'Current',
            keyLabel: 'C major',
            functionLabel: 'V',
            description: 'Dominant',
          ),
          nextInsight: const PracticeChordInsight(
            sectionLabel: 'Next',
            keyLabel: 'C major',
            functionLabel: 'V',
            description: 'Still dominant',
          ),
        ),
      );

      final summaryFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data != null &&
            widget.data!.contains('C major') &&
            widget.data!.contains('V'),
      );

      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
      expect(summaryFinder, findsNWidgets(2));
      expect(find.text('Dominant'), findsNothing);
      expect(find.text('Still dominant'), findsNothing);
    },
  );
}
