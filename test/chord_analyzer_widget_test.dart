import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    AppSettingsController? controller,
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    configureLargeDisplay(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
        darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChordAnalyzerPage(
          inputPlatformOverride: platform,
          controller: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> closeResultDialogIfOpen(WidgetTester tester) async {
    final dialog = find.byKey(const ValueKey('analyzer-result-dialog'));
    if (dialog.evaluate().isEmpty) {
      return;
    }

    await tester.tap(find.descendant(of: dialog, matching: find.text('Close')));
    await tester.pumpAndSettle();
  }

  Future<void> openDesktopChordPad(WidgetTester tester) async {
    final toggle = find.byKey(
      const ValueKey('chord-editor-toggle-desktop-pad'),
    );
    if (toggle.evaluate().isEmpty) {
      return;
    }
    await tester.tap(toggle);
    await tester.pumpAndSettle();
  }

  VoidCallback? insertButtonAction(WidgetTester tester, String id) {
    return tester
        .widget<FilledButton>(find.byKey(ValueKey('analyzer-key-$id')))
        .onPressed;
  }

  List<Color> renderedTextColors(WidgetTester tester, String text) {
    return tester
        .widgetList<Text>(find.text(text))
        .map((widget) => widget.style?.color)
        .whereType<Color>()
        .toList(growable: false);
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
      await openDesktopChordPad(tester);
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
        find.byKey(const ValueKey('analyzer-result-input-card')),
        findsOneWidget,
      );
      expect(find.text('Chord progression'), findsWidgets);
      final dialogInput = tester.widget<SelectableText>(
        find.byKey(const ValueKey('analyzer-result-input')),
      );
      expect(dialogInput.data, 'Dm7 G7 Cmaj7');
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
      expect(
        find.byKey(const ValueKey('analyzer-explanation-panel')),
        findsOneWidget,
      );
      expect(find.text('Measure 1'), findsOneWidget);
    },
  );

  testWidgets(
    'ambiguous analyzer results surface alternative readings and ambiguity UI',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      final input = find.byKey(const ValueKey('analyzer-input-field'));
      await tester.enterText(input, 'Db7 Cmaj7');
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(input))!;

      expect(
        find.byKey(const ValueKey('analyzer-explanation-panel')),
        findsOneWidget,
      );
      expect(find.text(l10n.explanationAlternativeSection), findsOneWidget);
      expect(
        find.textContaining(l10n.chordAnalyzerAmbiguityLabel),
        findsWidgets,
      );
      expect(find.text(l10n.explanationListeningSection), findsOneWidget);
      expect(find.text(l10n.explanationPerformanceSection), findsOneWidget);
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
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('chord-editor-toggle-desktop-pad')),
        findsOneWidget,
      );
      await openDesktopChordPad(tester);
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

    final l10n = AppLocalizations.of(
      tester.element(find.byKey(const ValueKey('analyzer-input-field'))),
    )!;
    final beforeToggle = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(beforeToggle.readOnly, isTrue);
    expect(
      find.byKey(const ValueKey('analyzer-keyboard-panel')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('analyzer-key-paste')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('analyzer-keyboard-panel')),
        matching: find.byType(SegmentedButton<bool>),
      ),
      findsNothing,
    );
    expect(find.text(l10n.chordAnalyzerRawInput), findsNothing);
    expect(find.text(l10n.chordAnalyzerKeyboardTouchHint), findsNothing);
  });

  testWidgets('example chips populate the analyzer input field', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.tap(find.text('Db7(#11), Cmaj7'));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Db7(#11), Cmaj7');
  });

  testWidgets('example chips advertise tap-to-analyze behavior', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);
    final l10n = AppLocalizations.of(
      tester.element(find.byKey(const ValueKey('analyzer-input-field'))),
    )!;
    final exampleKey = const ValueKey('analyzer-example-Db7(#11), Cmaj7');

    final tooltip = tester.widget<Tooltip>(
      find.ancestor(of: find.byKey(exampleKey), matching: find.byType(Tooltip)),
    );

    expect(tooltip.message, '${l10n.chordAnalyzerAnalyze}: Db7(#11), Cmaj7');
    expect(
      find.descendant(
        of: find.byKey(exampleKey),
        matching: find.byIcon(Icons.insights_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('restores the last saved analyzer draft on reopen', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({
      'chord_analyzer_input_draft': 'Dm7 G7 Cmaj7',
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Dm7 G7 Cmaj7');
  });

  testWidgets('clearing the analyzer input removes the saved draft', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({
      'chord_analyzer_input_draft': 'Dm7 G7 Cmaj7',
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    final input = find.byKey(const ValueKey('analyzer-input-field'));
    await tester.enterText(input, '');
    await tester.pump(const Duration(milliseconds: 400));

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('chord_analyzer_input_draft'), isNull);
  });

  testWidgets('clear action resets analyzer input, results, and saved draft', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    final input = find.byKey(const ValueKey('analyzer-input-field'));
    await tester.enterText(input, 'Dm7 G7 Cmaj7');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('analyzer-clear-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final field = tester.widget<TextField>(input);
    expect(field.controller!.text, isEmpty);
    expect(field.focusNode!.hasFocus, isTrue);
    expect(find.byKey(const ValueKey('analyzer-results-card')), findsNothing);
    expect(
      find.byKey(const ValueKey('analyzer-result-input-card')),
      findsNothing,
    );

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('chord_analyzer_input_draft'), isNull);
  });

  testWidgets('editing input clears stale analyzer results immediately', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    final input = find.byKey(const ValueKey('analyzer-input-field'));
    await tester.enterText(input, 'Dm7 G7 Cmaj7');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);

    await tester.enterText(input, 'Dm7 G7 Cmaj7 Fmaj7');
    await tester.pump();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsNothing);
    expect(
      find.byKey(const ValueKey('analyzer-result-input-card')),
      findsNothing,
    );
  });

  testWidgets('analyze action enables only when trimmed input is present', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    FilledButton analyzeButton() => tester.widget<FilledButton>(
      find.byKey(const ValueKey('analyzer-analyze-button')),
    );

    expect(analyzeButton().onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      '   ',
    );
    await tester.pump();
    expect(analyzeButton().onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    expect(analyzeButton().onPressed, isNotNull);
  });

  testWidgets('copy action copies analyzed progression to clipboard', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('analyzer-copy-progression-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('analyzer-copy-default-icon')),
      findsOneWidget,
    );

    await Clipboard.setData(const ClipboardData(text: 'stale'));
    await tester.tap(
      find.byKey(const ValueKey('analyzer-copy-progression-button')),
    );
    await tester.pump();

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboard?.text, 'Dm7 G7 Cmaj7');
    expect(
      find.byKey(const ValueKey('analyzer-copy-success-icon')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 1500));
    expect(
      find.byKey(const ValueKey('analyzer-copy-default-icon')),
      findsOneWidget,
    );
  });

  testWidgets('re-analyzing immediately clears stale copy success feedback', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('analyzer-copy-progression-button')),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('analyzer-copy-success-icon')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('analyzer-copy-default-icon')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('analyzer-copy-success-icon')),
      findsNothing,
    );

    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('analyzer-copy-default-icon')),
      findsOneWidget,
    );
  });

  testWidgets('paste action replaces analyzer input from clipboard', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText = 'Fm7 Bb7 Cmaj7';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-paste-button')));
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Fm7 Bb7 Cmaj7');
  });

  testWidgets(
    'paste action trims surrounding whitespace and ignores blank clipboard text',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      SharedPreferences.setMockInitialValues({});
      String? clipboardText = '  \nFm7 Bb7 Cmaj7  \n';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            switch (call.method) {
              case 'Clipboard.getData':
                return <String, Object?>{'text': clipboardText};
              case 'Clipboard.setData':
                clipboardText =
                    (call.arguments as Map<Object?, Object?>)['text']
                        as String?;
                return null;
              default:
                return null;
            }
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-paste-button')));
      await tester.pump();

      TextField field = tester.widget<TextField>(
        find.byKey(const ValueKey('analyzer-input-field')),
      );
      expect(field.controller!.text, 'Fm7 Bb7 Cmaj7');

      clipboardText = '   \n  ';
      await tester.tap(find.byKey(const ValueKey('analyzer-paste-button')));
      await tester.pump();

      field = tester.widget<TextField>(
        find.byKey(const ValueKey('analyzer-input-field')),
      );
      expect(field.controller!.text, 'Fm7 Bb7 Cmaj7');
    },
  );

  testWidgets('paste shortcut replaces analyzer input from clipboard', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText = 'Fm7 Bb7 Cmaj7';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.text, 'Fm7 Bb7 Cmaj7');
  });

  testWidgets('focus shortcut selects the full analyzer input', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.controller!.selection.baseOffset, 0);
    expect(field.controller!.selection.extentOffset, 'Dm7 G7 Cmaj7'.length);
  });

  testWidgets('select-all shortcut also focuses and selects analyzer input', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('analyzer-input-field')),
    );
    expect(field.focusNode!.hasFocus, isTrue);
    expect(field.controller!.selection.baseOffset, 0);
    expect(field.controller!.selection.extentOffset, 'Dm7 G7 Cmaj7'.length);
  });

  testWidgets('analyze shortcut works after paste action', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText = 'Fm7 Bb7 Cmaj7';
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.tap(find.byKey(const ValueKey('analyzer-paste-button')));
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);
    final resultInput = tester.widget<SelectableText>(
      find.byKey(const ValueKey('analyzer-result-input')),
    );
    expect(resultInput.data, 'Fm7 Bb7 Cmaj7');
  });

  testWidgets('copy shortcut copies analyzed progression to clipboard', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});
    String? clipboardText;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.setData':
              clipboardText =
                  (call.arguments as Map<Object?, Object?>)['text'] as String?;
              return null;
            case 'Clipboard.getData':
              return <String, Object?>{'text': clipboardText};
            default:
              return null;
          }
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    expect(clipboard?.text, 'Dm7 G7 Cmaj7');
  });

  testWidgets('escape shortcut clears analyzer input and results', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    SharedPreferences.setMockInitialValues({});

    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    final input = find.byKey(const ValueKey('analyzer-input-field'));
    await tester.enterText(input, 'Dm7 G7 Cmaj7');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final field = tester.widget<TextField>(input);
    expect(field.controller!.text, isEmpty);
    expect(find.byKey(const ValueKey('analyzer-results-card')), findsNothing);
  });

  testWidgets('F1 shortcut opens analyzer input help', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    expect(find.byKey(const ValueKey('analyzer-help-dialog')), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.f1);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-help-dialog')), findsOneWidget);
    expect(find.text('Input tips'), findsOneWidget);
  });

  testWidgets('display settings shortcut opens analyzer display sheet', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    expect(find.text('Analysis display'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.comma);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();

    expect(find.text('Analysis display'), findsOneWidget);
  });

  testWidgets('analyzer action tooltips advertise keyboard shortcuts', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);
    final l10n = AppLocalizations.of(
      tester.element(find.byKey(const ValueKey('analyzer-input-field'))),
    )!;

    Tooltip tooltipFor(Key key) => tester.widget<Tooltip>(
      find.ancestor(of: find.byKey(key), matching: find.byType(Tooltip)).first,
    );

    expect(
      tooltipFor(const ValueKey('analyzer-help-button')).message,
      'Input tips (F1)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-display-settings-button')).message,
      'Analysis display (Ctrl/Cmd+,)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-input-field')).message,
      'Chord progression (Ctrl/Cmd+L, Ctrl/Cmd+A)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-analyze-button')).message,
      'Analyze (Ctrl/Cmd+Enter)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-paste-button')).message,
      'Paste (Ctrl/Cmd+V)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-clear-button')).message,
      'Clear text (Esc)',
    );

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(
      tooltipFor(const ValueKey('analyzer-copy-progression-button')).message,
      'Copy (Ctrl/Cmd+C)',
    );
    expect(
      tooltipFor(const ValueKey('analyzer-play-progression-button')).message,
      l10n.audioPlayProgression,
    );
    expect(
      tooltipFor(
        const ValueKey('analyzer-play-progression-arpeggio-button'),
      ).message,
      l10n.audioPlayArpeggio,
    );
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

  testWidgets('display settings update analyzer detail and theme settings', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    final controller = AppSettingsController(
      initialSettings: PracticeSettings(language: AppLanguage.en),
    );
    await pumpAnalyzerPage(
      tester,
      platform: TargetPlatform.windows,
      controller: controller,
    );

    await tester.tap(
      find.byKey(const ValueKey('analyzer-display-settings-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Analysis display'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('analyzer-detail-level-selector')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Advanced').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('analyzer-theme-preset-selector')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('High contrast').last);
    await tester.pumpAndSettle();

    expect(
      controller.settings.progressionExplanationDetailLevel,
      ProgressionExplanationDetailLevel.advanced,
    );
    expect(
      controller.settings.progressionHighlightTheme.preset,
      ProgressionHighlightThemePreset.highContrast,
    );
  });

  testWidgets('release analyzer keeps variation actions hidden', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));
    await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

    await tester.enterText(
      find.byKey(const ValueKey('analyzer-input-field')),
      'Dm7 G7 Cmaj7',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();
    await closeResultDialogIfOpen(tester);

    expect(
      find.byKey(const ValueKey('analyzer-generate-variations-button')),
      findsNothing,
    );
    expect(find.text('Natural variations'), findsNothing);
  });

  testWidgets(
    'chord pad uses composable quality tokens instead of redundant presets',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
      await tester.pump();
      await openDesktopChordPad(tester);

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
      await openDesktopChordPad(tester);

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
      await openDesktopChordPad(tester);

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
    'placeholder chords surface inferred fills and gate clean variations',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'Dm7 G7 | ? Am',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('analyzer-results-card')),
        findsOneWidget,
      );
      expect(find.text('Suggested fill: Cmaj7'), findsOneWidget);
      expect(find.text('Suggested fill: Cmaj7'), findsOneWidget);
      expect(
        find.text(
          'This ? was inferred from the surrounding harmonic context, so treat it as a suggested fill rather than a certainty.',
        ),
        findsWidgets,
      );

      expect(
        find.byKey(const ValueKey('analyzer-generate-variations-button')),
        findsNothing,
      );
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
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();
    await closeResultDialogIfOpen(tester);

    expect(find.text('Confidence'), findsWidgets);
    expect(find.text('Ambiguity'), findsOneWidget);
    expect(find.text('Why this reading'), findsWidgets);
    expect(find.textContaining('Slash bass E'), findsOneWidget);
    expect(find.textContaining('resolution toward II'), findsOneWidget);
  });

  testWidgets(
    'analysis summary surfaces highlight legend for non-diatonic categories',
    (WidgetTester tester) async {
      addTearDown(() => restoreDisplay(tester));
      await pumpAnalyzerPage(tester, platform: TargetPlatform.windows);

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'Fm7 Bb7 Cmaj7',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();
      await closeResultDialogIfOpen(tester);

      expect(find.text('Backdoor / subdominant minor'), findsWidgets);
      expect(find.text('Borrowed color'), findsWidgets);
    },
  );

  testWidgets('highlight legend text stays readable in light and dark themes', (
    WidgetTester tester,
  ) async {
    addTearDown(() => restoreDisplay(tester));

    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      await pumpAnalyzerPage(
        tester,
        platform: TargetPlatform.windows,
        themeMode: themeMode,
      );

      await tester.enterText(
        find.byKey(const ValueKey('analyzer-input-field')),
        'Fm7 Bb7 Cmaj7',
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();
      await closeResultDialogIfOpen(tester);

      final colors = renderedTextColors(tester, 'Backdoor / subdominant minor');
      expect(colors, isNotEmpty);

      final expectedBrightness = themeMode == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark;
      for (final color in colors) {
        expect(ThemeData.estimateBrightnessForColor(color), expectedBrightness);
      }
    }
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
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
    await tester.pump();
    await tester.pumpAndSettle();
    await closeResultDialogIfOpen(tester);

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
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('analyzer-analyze-button')));
      await tester.pump();
      await tester.pumpAndSettle();
      await closeResultDialogIfOpen(tester);

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
