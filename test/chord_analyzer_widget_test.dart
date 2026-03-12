import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/app.dart';
import 'package:sightchord/chord_analyzer_page.dart';
import 'package:sightchord/l10n/app_localizations.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  void configureLargeDisplay(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1;
  }

  void restoreDisplay(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  Future<void> pumpApp(WidgetTester tester) async {
    configureLargeDisplay(tester);
    await tester.pumpWidget(
      MyApp(
        controller: AppSettingsController(
          initialSettings: PracticeSettings(language: AppLanguage.en),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpAnalyzerPage(
    WidgetTester tester, {
    required TargetPlatform platform,
  }) async {
    configureLargeDisplay(tester);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChordAnalyzerPage(inputPlatformOverride: platform),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('main menu shows a chord analyzer entry point', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpApp(tester);

    expect(
      find.byKey(const ValueKey('main-open-generator-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-open-analyzer-button')),
      findsOneWidget,
    );
  });

  testWidgets('navigates to the analyzer page from the main menu', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpApp(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-analyzer-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-analyzer-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-input-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsNothing);
  });

  testWidgets(
    'renders analyzer result sections after submitting a progression',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpApp(tester);
      await tester.ensureVisible(
        find.byKey(const ValueKey('main-open-analyzer-button')),
      );
      await tester.tap(find.byKey(const ValueKey('main-open-analyzer-button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-d')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-minor7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-g')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-c')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-major7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('analyzer-results-card')),
        findsOneWidget,
      );
      expect(find.text('Detected Keys'), findsOneWidget);
      expect(find.text('Chord-by-chord analysis'), findsOneWidget);
      expect(find.text('Progression summary'), findsOneWidget);
      expect(find.text('Measure 1'), findsOneWidget);
    },
  );

  testWidgets(
    'desktop helper pad keeps text entry and token insertion enabled',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('analyzer-keyboard-panel')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'Dm7 G7 ',
      );
      await tester.tap(find.byKey(const ValueKey('analyzer-key-c')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-major7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('analyzer-results-card')),
        findsOneWidget,
      );
    },
  );

  testWidgets('android editor opens the touch chord pad in read-only mode', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.android);

    await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
    await tester.pump();

    final beforeToggle = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(beforeToggle.readOnly, isTrue);
    expect(
      find.byKey(const ValueKey('analyzer-keyboard-panel')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('analyzer-key-paste')), findsOneWidget);
    expect(find.text('ABC'), findsOneWidget);
  });

  testWidgets('example chips populate the analyzer input field', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.tap(find.text('Db7(#11) Cmaj7'));
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Db7(#11) Cmaj7');
  });

  testWidgets('analysis results show confidence and evidence details', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Cmaj7/E A7(b9) Dm7 G7',
    );
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Confidence'), findsWidgets);
    expect(find.text('Ambiguity'), findsOneWidget);
    expect(find.text('Why this reading'), findsWidgets);
    expect(find.textContaining('Slash bass E'), findsOneWidget);
    expect(find.textContaining('resolution toward II'), findsOneWidget);
  });

  testWidgets('ignored parser modifiers are surfaced as warnings', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'C7(foo) Dm7 G7 Cmaj7',
    );
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.textContaining('Ignored modifiers'), findsOneWidget);
    expect(find.textContaining('C7(foo): foo'), findsOneWidget);
  });
}
