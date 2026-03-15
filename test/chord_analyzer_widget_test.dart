import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/app.dart';
import 'package:chordest/chord_analyzer_page.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/settings_controller.dart';

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

  VoidCallback? insertButtonAction(WidgetTester tester, String id) {
    return tester
        .widget<FilledButton>(find.byKey(ValueKey('analyzer-key-$id')))
        .onPressed;
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
      await tester.tap(find.byKey(const ValueKey('analyzer-key-minor')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
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
      await tester.tap(find.byKey(const ValueKey('analyzer-key-major')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('analyzer-results-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('analyzer-play-progression-button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('analyzer-play-progression-arpeggio-button')),
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
      await tester.tap(find.byKey(const ValueKey('analyzer-key-major')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
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

    await tester.tap(find.text('Db7(#11), Cmaj7'));
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Db7(#11), Cmaj7');
  });

  testWidgets('input help opens from the top-right help marker', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    expect(find.textContaining('spaces, |, or commas'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('analyzer-help-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-help-dialog')), findsOneWidget);
    expect(find.text('Input tips'), findsOneWidget);
    expect(find.textContaining('spaces, |, or commas'), findsOneWidget);
  });

  testWidgets('generated analyzer variations can be previewed and applied', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('analyzer-generate-variations-button')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('analyzer-generate-variations-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Natural variations'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('analyzer-variation-cadentialColor')),
      findsOneWidget,
    );
    expect(find.text('Dm7b5 Db7 Cmaj9'), findsOneWidget);
    expect(find.text('Fm7 Bb7 C6/9'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('analyzer-apply-variation-cadentialColor')),
    );
    await tester.tap(
      find.byKey(const ValueKey('analyzer-apply-variation-cadentialColor')),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Dm7b5 Db7 Cmaj9');
  });

  testWidgets(
    'chord pad uses composable quality tokens instead of redundant presets',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();

      expect(find.byKey(const ValueKey('analyzer-key-major')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('analyzer-key-suspension')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('analyzer-key-add')), findsOneWidget);
      expect(find.byKey(const ValueKey('analyzer-key-omit')), findsOneWidget);
      expect(find.byKey(const ValueKey('analyzer-key-five')), findsOneWidget);
      expect(find.byKey(const ValueKey('analyzer-key-major7')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-minor7')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-halfDim')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-add9')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-sus2')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-sus4')), findsNothing);
      expect(find.byKey(const ValueKey('analyzer-key-flat5')), findsNothing);

      await tester.tap(find.byKey(const ValueKey('analyzer-key-c')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-major')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-f')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-add')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom11')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-b')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-suspension')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-four')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-d')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-minor')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('analyzer-key-modifier-flat')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-five')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-e')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-five')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-space')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-g')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-omit')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-five')));
      await tester.pump();

      final field = tester.widget<TextField>(
        find.byKey(const ValueKey('analyzer-input-field')),
      );
      expect(field.controller!.text, 'Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5');
    },
  );

  testWidgets(
    'keyboard button activation updates immediately after chord-pad input',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();

      expect(insertButtonAction(tester, 'openParen'), isNull);
      expect(insertButtonAction(tester, 'closeParen'), isNull);

      await tester.tap(find.byKey(const ValueKey('analyzer-key-c')));
      await tester.pump();

      expect(insertButtonAction(tester, 'openParen'), isNotNull);

      await tester.tap(find.byKey(const ValueKey('analyzer-key-openParen')));
      await tester.pump();

      expect(insertButtonAction(tester, 'c'), isNull);
      expect(insertButtonAction(tester, 'sharp'), isNull);
      expect(insertButtonAction(tester, 'closeParen'), isNotNull);
    },
  );

  testWidgets(
    'comma insertion stays inside the same chord while editing tensions',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey('analyzer-key-c')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-openParen')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('analyzer-key-modifier-flat')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom9')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-comma')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('analyzer-key-modifier-sharp')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-key-dom11')));
      await tester.pump();

      final field = tester.widget<TextField>(
        find.byKey(const ValueKey('analyzer-input-field')),
      );
      expect(field.controller!.text, 'C7(b9, #11)');
    },
  );

  testWidgets(
    'placeholder chords surface inferred fills and clean variations',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'Dm7 G7 ? Am7',
      );
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Suggested fill: Cmaj7'), findsOneWidget);
      expect(
        find.text('This ? was inferred from the surrounding harmonic context.'),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('analyzer-generate-variations-button')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('analyzer-variation-colorLift')),
        findsOneWidget,
      );

      final variationText = tester.widget<SelectableText>(
        find.byKey(const ValueKey('analyzer-variation-colorLift')),
      );
      expect(variationText.data, isNot(contains('?')));
    },
  );

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

  testWidgets(
    'empty and failure-only measures stay visible in analysis output',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'C | | H7 | G',
      );
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Measure 2'), findsOneWidget);
      expect(
        find.text('This measure is empty and was preserved in the count.'),
        findsOneWidget,
      );
      expect(find.text('Measure 3'), findsOneWidget);
      expect(find.textContaining('H7:'), findsWidgets);
    },
  );
}
