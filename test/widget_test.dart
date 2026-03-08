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
    expect(find.text('?ㅼ쓬 肄붾뱶'), findsOneWidget);
    expect(find.text('?먮룞 吏꾪뻾 ?쒖옉'), findsOneWidget);
    expect(find.text('?쒕뜡 紐⑤뱶'), findsWidgets);
    expect(find.text('All Keys'), findsOneWidget);
    expect(find.text('60'), findsOneWidget);
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.text('?ㅼ쓬 肄붾뱶'));
    await tester.pump();

    expect(find.text('?먮룞 吏꾪뻾 ?쒖옉'), findsOneWidget);
    expect(find.text('?낅젰 踰붿쐞: 20-300'), findsOneWidget);
  });

  testWidgets('manual BPM entry updates the autoplay timer speed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final bpmInputFinder = find.byKey(const ValueKey('bpm-input'));

    await tester.tap(find.text('?먮룞 吏꾪뻾 ?쒖옉'));
    await tester.pump();

    expect(find.byKey(const ValueKey('beat-circle-0-active')), findsOneWidget);

    await tester.enterText(bpmInputFinder, '120');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.byKey(const ValueKey('beat-circle-1-active')), findsOneWidget);
  });
}
