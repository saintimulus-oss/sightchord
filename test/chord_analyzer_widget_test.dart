import 'package:flutter/foundation.dart';
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
          initialSettings: PracticeSettings(language: AppLanguage.en),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('main menu shows a chord analyzer entry point', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byKey(const ValueKey('main-open-generator-button')), findsOneWidget);
    expect(find.byKey(const ValueKey('main-open-analyzer-button')), findsOneWidget);
  });

  testWidgets('navigates to the analyzer page from the main menu', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-analyzer-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-analyzer-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-input-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsNothing);
  });

  testWidgets('renders analyzer result sections after submitting a progression', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);
    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-analyzer-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-analyzer-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);
    expect(find.text('Detected Keys'), findsOneWidget);
    expect(find.text('Chord-by-chord analysis'), findsOneWidget);
    expect(find.text('Progression summary'), findsOneWidget);
  });
}
