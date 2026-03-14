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

  testWidgets('active and inactive keys use distinct visual treatments', (
    tester,
  ) async {
    final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal);

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: SizedBox(
            width: 180,
            child: MiniKeyboard(notes: [60, 61], minMidi: 58, maxMidi: 62),
          ),
        ),
      ),
    );

    DecoratedBox keyDecoration(String key) {
      return tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byKey(ValueKey(key)),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
    }

    final activeWhite = keyDecoration('mini-key-white-60');
    final inactiveWhite = keyDecoration('mini-key-white-59');
    final activeBlack = keyDecoration('mini-key-black-61');
    final inactiveBlack = keyDecoration('mini-key-black-58');

    final activeWhiteDecoration = activeWhite.decoration as BoxDecoration;
    final inactiveWhiteDecoration = inactiveWhite.decoration as BoxDecoration;
    final activeBlackDecoration = activeBlack.decoration as BoxDecoration;
    final inactiveBlackDecoration = inactiveBlack.decoration as BoxDecoration;

    expect(activeWhiteDecoration.boxShadow, isNotNull);
    expect(inactiveWhiteDecoration.boxShadow, isNull);
    expect((activeWhiteDecoration.border! as Border).top.width, greaterThan(0));
    expect((inactiveWhiteDecoration.border! as Border).top.width, 0);
    expect(
      (activeWhiteDecoration.gradient! as LinearGradient).colors.first,
      isNot(
        equals(
          (inactiveWhiteDecoration.gradient! as LinearGradient).colors.first,
        ),
      ),
    );

    expect((activeBlackDecoration.border! as Border).top.width, 1);
    expect((inactiveBlackDecoration.border! as Border).top.width, 0.7);
    expect(
      (activeBlackDecoration.gradient! as LinearGradient).colors.first,
      isNot(
        equals(
          (inactiveBlackDecoration.gradient! as LinearGradient).colors.first,
        ),
      ),
    );
  });

  testWidgets('active note markers use white/black key specific pill sizes', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: MiniKeyboard(notes: [60, 61], minMidi: 58, maxMidi: 62),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 14 && widget.height == 5,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 10 && widget.height == 4,
      ),
      findsOneWidget,
    );
  });
}

