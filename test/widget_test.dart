import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sightchord/main.dart';

void main() {
  testWidgets('renders practice UI and rendering controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('SightChord'), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('allow-v7sus4-chip')), findsOneWidget);
    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(find.byKey(const ValueKey('tension-chip-9')), findsOneWidget);
    expect(find.byKey(const ValueKey('tension-chip-b9')), findsOneWidget);
  });

  testWidgets('tension chip state persists across reseed and manual advance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'C'));
    await tester.pumpAndSettle();

    final tensionToggleFinder = find.byKey(
      const ValueKey('allow-tensions-toggle'),
    );
    await tester.ensureVisible(tensionToggleFinder);
    await tester.tap(tensionToggleFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    final b9Finder = find.byKey(const ValueKey('tension-chip-b9'));
    await tester.ensureVisible(b9Finder);
    expect(tester.widget<FilterChip>(b9Finder).selected, isTrue);

    await tester.tap(b9Finder, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(tester.widget<FilterChip>(b9Finder).selected, isFalse);

    final v7sus4Finder = find.byKey(const ValueKey('allow-v7sus4-chip'));
    await tester.ensureVisible(v7sus4Finder);
    await tester.tap(v7sus4Finder, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(tester.widget<FilterChip>(b9Finder).selected, isFalse);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(tester.widget<FilterChip>(b9Finder).selected, isFalse);
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final initialText = tester
        .widget<Text>(find.byKey(const ValueKey('current-chord-text')))
        .data;

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);
    final nextText = tester
        .widget<Text>(find.byKey(const ValueKey('current-chord-text')))
        .data;
    expect(nextText, isNotNull);
    expect(initialText == nextText, isFalse);
  });
}
