import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/app.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        controller: AppSettingsController(
          initialSettings: PracticeSettings(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders practice UI and rendering controls', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('SightChord'), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('allow-v7sus4-chip')), findsOneWidget);
    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(find.byKey(const ValueKey('tension-chip-9')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('modal-interchange-chip')),
      findsOneWidget,
    );
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final initialText = tester
        .widget<Text>(find.byKey(const ValueKey('current-chord-text')))
        .data;

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    final nextText = tester
        .widget<Text>(find.byKey(const ValueKey('current-chord-text')))
        .data;

    expect(nextText, isNotNull);
    expect(nextText, isNot(initialText));
    expect(nextText, isNotEmpty);
  });

  testWidgets('language switch updates localized UI copy', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('한국어').last);
    await tester.pumpAndSettle();

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('메트로놈'), findsWidgets);
  });
}
