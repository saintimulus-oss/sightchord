import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/widgets/mini_keyboard.dart';

void main() {
  testWidgets('mini keyboard shows octave markers for C keys in range', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: MiniKeyboard(notes: [60, 64, 67], minMidi: 48, maxMidi: 72),
          ),
        ),
      ),
    );

    expect(find.text('C4'), findsOneWidget);
    expect(find.text('C5'), findsOneWidget);
  });

  testWidgets('mini keyboard renders highlighted notes without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 260,
            child: MiniKeyboard(notes: [54, 58, 61, 65]),
          ),
        ),
      ),
    );

    expect(find.byType(MiniKeyboard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
