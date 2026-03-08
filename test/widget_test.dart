import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sightchord/main.dart';

void main() {
  testWidgets('renders practice controls and initial chord state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('SightChord'), findsOneWidget);
    expect(find.text('다음 코드'), findsOneWidget);
    expect(find.text('자동 진행 시작'), findsOneWidget);
    expect(find.text('랜덤 모드'), findsWidgets);
    expect(find.text('All Keys'), findsOneWidget);
    expect(find.text('60'), findsOneWidget);
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.text('다음 코드'));
    await tester.pump();

    expect(find.text('자동 진행 시작'), findsOneWidget);
    expect(find.text('입력 범위: 20-300'), findsOneWidget);
  });

  testWidgets('manual BPM entry updates the autoplay timer speed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final currentChordFinder = find.byKey(
      const ValueKey('current-chord-text'),
    );
    final bpmInputFinder = find.byKey(const ValueKey('bpm-input'));

    await tester.tap(find.text('자동 진행 시작'));
    await tester.pump();

    final chordBeforeSpeedChange =
        tester.widget<Text>(currentChordFinder).data;

    await tester.enterText(bpmInputFinder, '120');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2100));

    final chordAfterSpeedChange =
        tester.widget<Text>(currentChordFinder).data;

    expect(chordAfterSpeedChange, isNot(equals(chordBeforeSpeedChange)));
  });
}
