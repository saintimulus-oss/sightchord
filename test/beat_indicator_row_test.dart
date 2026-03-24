import 'package:chordest/audio/metronome_audio_models.dart';
import 'package:chordest/widgets/beat_indicator_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildHarness(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('accent beats render an internal accent mark', (tester) async {
    await tester.pumpWidget(
      buildHarness(
        const BeatIndicatorRow(
          beatCount: 4,
          activeBeat: 2,
          animationDuration: Duration.zero,
          beatStates: <MetronomeBeatState>[
            MetronomeBeatState.accent,
            MetronomeBeatState.normal,
            MetronomeBeatState.accent,
            MetronomeBeatState.mute,
          ],
        ),
      ),
    );

    expect(find.byKey(const ValueKey('beat-accent-mark-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('beat-accent-mark-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('beat-accent-mark-1')), findsNothing);
    expect(find.byKey(const ValueKey('beat-mute-mark-3')), findsOneWidget);
  });

  testWidgets('expanded editing state keeps accent mark visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildHarness(
        const BeatIndicatorRow(
          beatCount: 3,
          activeBeat: 0,
          animationDuration: Duration.zero,
          expanded: true,
          beatStates: <MetronomeBeatState>[
            MetronomeBeatState.accent,
            MetronomeBeatState.normal,
            MetronomeBeatState.normal,
          ],
        ),
      ),
    );

    expect(find.byKey(const ValueKey('beat-accent-mark-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('beat-circle-0')), findsOneWidget);
  });
}
