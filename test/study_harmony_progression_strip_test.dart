import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';
import 'package:sightchord/study_harmony/ui/study_harmony_progression_strip.dart';

void main() {
  testWidgets('progression strip renders highlighted and hidden slots', (
    WidgetTester tester,
  ) async {
    const progression = StudyHarmonyProgressionDisplaySpec(
      summaryLabel: 'Progression',
      slots: [
        StudyHarmonyProgressionSlotSpec(
          id: 'slot-1',
          label: 'Cmaj7',
          measureLabel: '1',
        ),
        StudyHarmonyProgressionSlotSpec(
          id: 'slot-2',
          label: 'Dm7',
          measureLabel: '2',
          isHighlighted: true,
        ),
        StudyHarmonyProgressionSlotSpec(
          id: 'slot-3',
          label: 'G7',
          measureLabel: '3',
          isHidden: true,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: StudyHarmonyProgressionStrip(progression: progression),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('study-harmony-progression-strip')),
      findsOneWidget,
    );
    expect(find.text('Cmaj7'), findsOneWidget);
    expect(find.text('Dm7'), findsOneWidget);
    expect(find.text('____'), findsOneWidget);
  });
}
