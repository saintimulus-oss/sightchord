import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/app.dart';
import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/audio/harmony_audio_service.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/music/chord_anchor_loop.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/voicing_models.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_advanced_settings_page.dart';
import 'package:chordest/settings/practice_settings_factory.dart';
import 'package:chordest/settings/settings_controller.dart';
import 'package:chordest/widgets/beat_indicator_row.dart';
import 'package:chordest/widgets/mini_keyboard.dart';
import 'package:chordest/widgets/voicing_suggestions_section.dart';

GeneratedChord buildTestChord({
  required String root,
  required ChordQuality quality,
  required String repeatKey,
  RomanNumeralId? romanNumeralId,
  KeyCenter? keyCenter,
  HarmonicFunction harmonicFunction = HarmonicFunction.free,
  DominantContext? dominantContext,
  DominantIntent? dominantIntent,
  List<String> tensions = const [],
  String? bass,
}) {
  return GeneratedChord(
    symbolData: ChordSymbolData(
      root: root,
      harmonicQuality: quality,
      renderQuality: quality,
      tensions: tensions,
      bass: bass,
    ),
    repeatGuardKey: repeatKey,
    harmonicComparisonKey: repeatKey,
    keyName: keyCenter?.tonicName,
    keyCenter: keyCenter,
    romanNumeralId: romanNumeralId,
    harmonicFunction: harmonicFunction,
    dominantContext: dominantContext,
    dominantIntent: dominantIntent,
  );
}

ConcreteVoicing buildTestVoicing({
  required VoicingFamily family,
  required List<int> midiNotes,
  required List<String> noteNames,
  required List<String> toneLabels,
  Set<String> tensions = const {},
  bool containsRoot = false,
  bool containsThird = false,
  bool containsSeventh = false,
}) {
  return ConcreteVoicing(
    midiNotes: midiNotes,
    noteNames: noteNames,
    toneLabels: toneLabels,
    tensions: tensions,
    family: family,
    topNote: midiNotes.last,
    bassNote: midiNotes.first,
    containsRoot: containsRoot,
    containsThird: containsThird,
    containsSeventh: containsSeventh,
    signature: '${family.name}:${midiNotes.join('-')}:${toneLabels.join(',')}',
  );
}

VoicingSuggestion buildTestSuggestion({
  required VoicingSuggestionKind kind,
  required ConcreteVoicing voicing,
  required List<VoicingReasonTag> reasonTags,
  List<VoicingSuggestionKind> kinds = const [],
  List<String> shortReasons = const [],
  bool locked = false,
}) {
  return VoicingSuggestion(
    kind: kind,
    label: kind.name,
    shortReasons: shortReasons,
    score: 1,
    voicing: voicing,
    breakdown: const VoicingBreakdown(
      total: 1,
      essentialCoveredCount: 2,
      essentialRequiredCount: 2,
      bassAnchorMatched: true,
    ),
    kinds: kinds,
    reasonTags: reasonTags,
    locked: locked,
  );
}

Future<void> pumpVoicingSection(
  WidgetTester tester, {
  required VoicingRecommendationSet recommendations,
  VoicingDisplayMode displayMode = VoicingDisplayMode.standard,
  String? selectedSignature,
  bool showReasons = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 320,
              child: VoicingSuggestionsSection(
                recommendations: recommendations,
                displayMode: displayMode,
                selectedSignature: selectedSignature,
                showReasons: showReasons,
                onSelectSuggestion: (_) {},
                onToggleLock: (_) {},
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _SpyHarmonyAudioService extends HarmonyAudioService {
  _SpyHarmonyAudioService() : super();

  final List<(HarmonyPlaybackPattern, String?)> playedLabels =
      <(HarmonyPlaybackPattern, String?)>[];
  final List<HarmonyCompositeClip> playedCompositeClips =
      <HarmonyCompositeClip>[];
  HarmonyAudioConfig? lastConfig;

  @override
  Future<void> warmUp() async {}

  @override
  Future<void> applyConfig(HarmonyAudioConfig config) async {
    lastConfig = config;
  }

  @override
  Future<void> playClip(
    HarmonyChordClip clip, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration? hold,
    HarmonyPlaybackOverrides? overrides,
  }) async {
    playedLabels.add((pattern, clip.label));
  }

  @override
  Future<void> playCompositeClip(
    HarmonyCompositeClip clip, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration? hold,
    HarmonyPlaybackOverrides? overrides,
  }) async {
    playedCompositeClips.add(clip);
    playedLabels.add((
      pattern,
      clip.label ?? clip.chordClip?.label ?? clip.melodyClip?.label,
    ));
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpMainMenuWithSettings(
    WidgetTester tester,
    PracticeSettings settings, {
    bool completeGuidedSetup = true,
  }) async {
    final resolvedSettings = completeGuidedSetup
        ? settings.copyWith(
            guidedSetupCompleted: true,
            settingsComplexityMode: SettingsComplexityMode.standard,
          )
        : settings;
    await tester.pumpWidget(
      MyApp(
        controller: AppSettingsController(initialSettings: resolvedSettings),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<AppSettingsController> pumpMainMenuWithController(
    WidgetTester tester,
    PracticeSettings settings, {
    bool completeGuidedSetup = true,
  }) async {
    final resolvedSettings = completeGuidedSetup
        ? settings.copyWith(
            guidedSetupCompleted: true,
            settingsComplexityMode: SettingsComplexityMode.standard,
          )
        : settings;
    final controller = AppSettingsController(initialSettings: resolvedSettings);
    await tester.pumpWidget(MyApp(controller: controller));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<AppSettingsController> pumpMainMenuWithAudioService(
    WidgetTester tester,
    PracticeSettings settings, {
    required HarmonyAudioService harmonyAudioService,
    bool completeGuidedSetup = true,
  }) async {
    final resolvedSettings = completeGuidedSetup
        ? settings.copyWith(
            guidedSetupCompleted: true,
            settingsComplexityMode: SettingsComplexityMode.standard,
          )
        : settings;
    final controller = AppSettingsController(initialSettings: resolvedSettings);
    await tester.pumpWidget(
      MyApp(controller: controller, harmonyAudioService: harmonyAudioService),
    );
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> openChordGenerator(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('main-open-generator-button')));
    await tester.pumpAndSettle();
  }

  Future<void> openChordAnalyzer(WidgetTester tester) async {
    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-analyzer-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-analyzer-button')));
    await tester.pumpAndSettle();
  }

  Future<void> openGeneratorSettings(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
  }

  Future<void> openChordQualitySettings(WidgetTester tester) async {
    await tester.ensureVisible(
      find.byKey(const ValueKey('practice-chord-quality-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('practice-chord-quality-button')),
    );
    await tester.pumpAndSettle();
  }

  Future<void> selectAdvancedSettingsCategory(
    WidgetTester tester,
    String category,
  ) async {
    final tab = find.byKey(ValueKey('advanced-settings-tab-$category'));
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();
  }

  Future<void> openAdvancedGeneratorSettings(
    WidgetTester tester, {
    String? category,
  }) async {
    await openGeneratorSettings(tester);
    await tester.ensureVisible(
      find.byKey(const ValueKey('open-advanced-settings-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('open-advanced-settings-button')),
    );
    await tester.pumpAndSettle();
    if (category != null) {
      await selectAdvancedSettingsCategory(tester, category);
    }
  }

  Future<void> openMainMenuSettings(WidgetTester tester) async {
    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-settings-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-settings-button')));
    await tester.pumpAndSettle();
  }

  Future<void> pumpAppWithSettings(
    WidgetTester tester,
    PracticeSettings settings, {
    bool completeGuidedSetup = true,
  }) async {
    await pumpMainMenuWithSettings(
      tester,
      settings,
      completeGuidedSetup: completeGuidedSetup,
    );
    await openChordGenerator(tester);
  }

  Future<AppSettingsController> pumpAppWithController(
    WidgetTester tester,
    PracticeSettings settings, {
    bool completeGuidedSetup = true,
  }) async {
    final controller = await pumpMainMenuWithController(
      tester,
      settings,
      completeGuidedSetup: completeGuidedSetup,
    );
    await openChordGenerator(tester);
    return controller;
  }

  Future<AppSettingsController> pumpAppWithExactSettings(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    final controller = AppSettingsController(initialSettings: settings);
    await tester.pumpWidget(MyApp(controller: controller));
    await tester.pumpAndSettle();
    await openChordGenerator(tester);
    return controller;
  }

  Future<AppSettingsController> pumpAppWithAudioService(
    WidgetTester tester,
    PracticeSettings settings, {
    required HarmonyAudioService harmonyAudioService,
    bool completeGuidedSetup = true,
  }) async {
    final controller = await pumpMainMenuWithAudioService(
      tester,
      settings,
      harmonyAudioService: harmonyAudioService,
      completeGuidedSetup: completeGuidedSetup,
    );
    await openChordGenerator(tester);
    return controller;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await pumpAppWithSettings(tester, PracticeSettings());
  }

  Finder nextChordTapTarget() {
    final hitZone = find.byKey(const ValueKey('next-chord-hit-zone'));
    if (hitZone.evaluate().isNotEmpty) {
      return hitZone;
    }
    return find.byKey(const ValueKey('next-chord-text'));
  }

  Finder previousChordTapTarget() {
    final hitZone = find.byKey(const ValueKey('previous-chord-hit-zone'));
    if (hitZone.evaluate().isNotEmpty) {
      return hitZone;
    }
    return find.byKey(const ValueKey('previous-chord-text'));
  }

  Future<void> tapNextChordRegion(WidgetTester tester) async {
    await tester.ensureVisible(nextChordTapTarget());
    await tester.tap(nextChordTapTarget().hitTestable());
    await tester.pumpAndSettle();
  }

  Future<void> tapPreviousChordRegion(WidgetTester tester) async {
    await tester.ensureVisible(previousChordTapTarget());
    await tester.tap(previousChordTapTarget().hitTestable());
    await tester.pumpAndSettle();
  }

  String? currentChordText(WidgetTester tester) {
    return tester
        .widget<Text>(find.byKey(const ValueKey('current-chord-text')))
        .data;
  }

  String? sideChordText(WidgetTester tester, String key) {
    final textFinder = find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.byType(Text),
    );
    if (textFinder.evaluate().isEmpty) {
      return null;
    }
    return tester.widget<Text>(textFinder.first).data;
  }

  String? previousChordText(WidgetTester tester) {
    return sideChordText(tester, 'previous-chord-text');
  }

  String? nextChordText(WidgetTester tester) {
    return sideChordText(tester, 'next-chord-text');
  }

  int? activeBeatIndex(WidgetTester tester) {
    return tester
        .widget<BeatIndicatorRow>(find.byType(BeatIndicatorRow))
        .activeBeat;
  }

  int beatCount(WidgetTester tester) {
    return tester
        .widget<BeatIndicatorRow>(find.byType(BeatIndicatorRow))
        .beatCount;
  }

  IconData iconForButton(WidgetTester tester, String key) {
    return tester
        .widget<Icon>(
          find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(Icon),
          ),
        )
        .icon!;
  }

  Future<void> advanceChord(WidgetTester tester) async {
    await tester.drag(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
  }

  Future<void> expandVoicingCard(WidgetTester tester, String kind) async {
    final card = find.byKey(ValueKey('voicing-suggestion-card-$kind'));
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
  }

  List<String> renderedVoicingCardKeys(WidgetTester tester) {
    final keys = <String>{};
    const prefix = 'voicing-suggestion-card-';
    for (final widget in tester.allWidgets) {
      final key = widget.key;
      if (key is ValueKey<String> && key.value.startsWith(prefix)) {
        keys.add(key.value.substring(prefix.length));
      }
    }
    return keys.toList(growable: false);
  }

  String voicingNotesFor(WidgetTester tester, String kind) {
    final textWidgets = tester
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(ValueKey('voicing-notes-$kind')),
            matching: find.byType(Text),
          ),
        )
        .toList();
    return textWidgets
        .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
        .where((value) => value.isNotEmpty)
        .join(' ');
  }

  String voicingToneLabelsFor(WidgetTester tester, String kind) {
    final textWidgets = tester
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(ValueKey('voicing-tones-$kind')),
            matching: find.byType(Text),
          ),
        )
        .toList();
    return textWidgets
        .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '')
        .where((value) => value.isNotEmpty)
        .join(' ');
  }

  String? voicingBadgeKind(WidgetTester tester, String badge) {
    final prefix = 'voicing-$badge-badge-';
    for (final widget in tester.allWidgets) {
      final key = widget.key;
      if (key is ValueKey<String> && key.value.startsWith(prefix)) {
        return key.value.substring(prefix.length);
      }
    }
    return null;
  }

  testWidgets('shows the main menu before entering the chord generator', (
    WidgetTester tester,
  ) async {
    await pumpMainMenuWithSettings(tester, PracticeSettings());

    expect(
      find.byKey(const ValueKey('main-open-generator-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-open-settings-button')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('current-chord-text')), findsNothing);

    await openChordGenerator(tester);

    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);
    expect(currentChordText(tester), isNotEmpty);
    expect(
      find.byKey(const ValueKey('practice-play-chord-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('practice-play-arpeggio-button')),
      findsOneWidget,
    );
  });

  testWidgets('new users land on a ready chord with beginner-safe defaults', (
    WidgetTester tester,
  ) async {
    final controller = await pumpMainMenuWithController(
      tester,
      PracticeSettings(),
      completeGuidedSetup: false,
    );

    await openChordGenerator(tester);

    expect(find.byKey(const ValueKey('setup-assistant-sheet')), findsNothing);
    expect(
      find.byKey(const ValueKey('practice-first-run-welcome-card')),
      findsOneWidget,
    );
    expect(currentChordText(tester), isNotEmpty);
    expect(controller.settings.guidedSetupCompleted, isTrue);
    expect(
      controller.settings.activeKeyCenters,
      contains(const KeyCenter(tonicName: 'C', mode: KeyMode.major)),
    );
    expect(controller.settings.chordSymbolStyle, ChordSymbolStyle.majText);
    expect(controller.settings.allowRootlessVoicings, isFalse);
    expect(
      controller.settings.settingsComplexityMode,
      SettingsComplexityMode.guided,
    );
  });

  testWidgets('setup assistant symbol examples keep the delta glyph intact', (
    WidgetTester tester,
  ) async {
    await pumpMainMenuWithSettings(
      tester,
      PracticeSettings(language: AppLanguage.en),
      completeGuidedSetup: false,
    );

    await openChordGenerator(tester);
    await tester.tap(
      find.byKey(const ValueKey('practice-first-run-setup-button')),
    );
    await tester.pumpAndSettle();

    for (
      var index = 0;
      index < 6 &&
          find.text('C\u03947').evaluate().isEmpty &&
          find.text('C?7').evaluate().isEmpty;
      index += 1
    ) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.byKey(const ValueKey('setup-assistant-sheet')), findsOneWidget);
    expect(find.text('C\u03947'), findsOneWidget);
    expect(find.text('C?7'), findsNothing);
  });

  testWidgets('welcome card can open the setup assistant on demand', (
    WidgetTester tester,
  ) async {
    await pumpAppWithController(
      tester,
      PracticeSettings(),
      completeGuidedSetup: false,
    );

    expect(
      find.byKey(const ValueKey('practice-first-run-welcome-card')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey('practice-first-run-setup-button')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('setup-assistant-sheet')), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('setup-assistant-sheet')), findsNothing);
    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('practice-first-run-welcome-card')),
      findsNothing,
    );
  });

  testWidgets('settings drawer can reopen the setup assistant', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(tester, PracticeSettings());

    await openGeneratorSettings(tester);

    expect(
      find.byKey(const ValueKey('rerun-setup-assistant-button')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('rerun-setup-assistant-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('rerun-setup-assistant-button')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('setup-assistant-sheet')), findsOneWidget);
  });

  testWidgets('analyzer from the main menu shows results inline', (
    WidgetTester tester,
  ) async {
    await pumpMainMenuWithSettings(tester, PracticeSettings());

    await openChordAnalyzer(tester);

    await tester.tap(
      find.byKey(const ValueKey('analyzer-example-Dm7, G7 | ? Am')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('analyzer-results-card')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('analyzer-result-input-card')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('analyzer-result-dialog')), findsNothing);
  });

  testWidgets('settings drawer lets users switch guided mode off directly', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithExactSettings(
      tester,
      PracticeSettings(
        guidedSetupCompleted: true,
        settingsComplexityMode: SettingsComplexityMode.guided,
      ),
    );

    await openGeneratorSettings(tester);

    expect(
      find.byKey(const ValueKey('settings-complexity-mode-guided')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('open-advanced-settings-button')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(const ValueKey('settings-complexity-mode-standard')),
    );
    await tester.pumpAndSettle();

    expect(
      controller.settings.settingsComplexityMode,
      SettingsComplexityMode.standard,
    );
    expect(controller.settings.guidedSetupCompleted, isTrue);
    expect(
      find.byKey(const ValueKey('open-advanced-settings-button')),
      findsOneWidget,
    );
  });

  testWidgets('main menu settings allow changing language and theme', (
    WidgetTester tester,
  ) async {
    final controller = await pumpMainMenuWithController(
      tester,
      PracticeSettings(language: AppLanguage.en, metronomeEnabled: false),
    );

    await openMainMenuSettings(tester);

    expect(
      find.byKey(const ValueKey('main-language-selector')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-theme-mode-selector')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('metronome-sound-selector')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('main-theme-mode-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    expect(controller.settings.appThemeMode, AppThemeMode.dark);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.byKey(const ValueKey('main-language-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\uD55C\uAD6D\uC5B4').last);
    await tester.pumpAndSettle();

    expect(controller.settings.language, AppLanguage.ko);
    expect(controller.settings.metronomeEnabled, isFalse);
  });

  testWidgets('hides Roman-numeral tension controls in free mode', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Chordest'), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);

    expect(
      find.byKey(const ValueKey('practice-chord-quality-button')),
      findsOneWidget,
    );
    await openChordQualitySettings(tester);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const ValueKey('chord-quality-chip-dominant7sus4')),
          )
          .onSelected,
      isNull,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const ValueKey('allow-tensions-toggle')),
          )
          .onSelected,
      isNull,
    );
    expect(find.byKey(const ValueKey('modal-interchange-chip')), findsNothing);
  });

  testWidgets('shows chord type controls when key mode is active', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(activeKeys: const {'C'}),
    );

    expect(
      find.byKey(const ValueKey('practice-chord-quality-button')),
      findsOneWidget,
    );
    await openChordQualitySettings(tester);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const ValueKey('chord-quality-chip-dominant7sus4')),
          )
          .onSelected,
      isNotNull,
    );
    await tester.tap(find.byKey(const ValueKey('chord-quality-chip-major7')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const ValueKey('allow-tensions-toggle')),
          )
          .onSelected,
      isNotNull,
    );
  });

  testWidgets('chord type sheet updates practice settings state', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(activeKeys: const {'C'}),
    );

    await openChordQualitySettings(tester);
    await tester.tap(find.byKey(const ValueKey('chord-quality-chip-major7')));
    await tester.pumpAndSettle();

    expect(
      controller.settings.enabledChordQualities,
      isNot(contains(ChordQuality.major7)),
    );
  });

  testWidgets('shows tension controls when key mode is active', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(activeKeys: const {'C'}),
    );

    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(
            find.byKey(const ValueKey('allow-tensions-toggle')),
          )
          .onSelected,
      isNotNull,
    );

    await openAdvancedGeneratorSettings(tester, category: 'harmony');
    expect(find.byKey(const ValueKey('tension-chip-9')), findsOneWidget);
  });

  testWidgets('quick key picker updates active keys from generator screen', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    await tester.ensureVisible(
      find.byKey(const ValueKey('practice-key-selector-button')),
    );
    await tester.tap(
      find.byKey(const ValueKey('practice-key-selector-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('practice-key-center-C-major')));
    await tester.pumpAndSettle();

    expect(
      controller.settings.activeKeyCenters,
      contains(const KeyCenter(tonicName: 'C', mode: KeyMode.major)),
    );
  });

  testWidgets('minor-only key selection produces a minor analysis label', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
        },
      ),
    );

    await advanceChord(tester);

    final status = tester
        .widget<Text>(find.byKey(const ValueKey('current-status-label')))
        .data!;
    expect(status, contains('A minor:'));
  });

  testWidgets('initial generator surface shows a ready first status label', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(tester, PracticeSettings());

    expect(find.byKey(const ValueKey('current-status-label')), findsOneWidget);
    expect(currentChordText(tester), isNotEmpty);
  });

  testWidgets('classical key label style uses lowercase tonic for minor', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
        },
        keyCenterLabelStyle: KeyCenterLabelStyle.classicalCase,
      ),
    );

    await advanceChord(tester);

    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey('current-status-label')))
          .data!,
      contains('a:'),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('key-center-label-style-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('key-center-label-style-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('C major: / C minor:').last);
    await tester.pumpAndSettle();

    expect(
      controller.settings.keyCenterLabelStyle,
      KeyCenterLabelStyle.modeText,
    );
  });

  testWidgets(
    'advanced smart-generator controls stay hidden until smart key mode is enabled',
    (WidgetTester tester) async {
      await pumpAppWithSettings(
        tester,
        PracticeSettings(activeKeys: const {'C'}),
      );

      await openAdvancedGeneratorSettings(tester);

      expect(find.text('Advanced Smart Generator'), findsNothing);
      expect(
        find.byKey(const ValueKey('modulation-intensity-dropdown')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'advanced smart-generator controls sync back into settings state',
    (WidgetTester tester) async {
      final controller = await pumpAppWithController(
        tester,
        PracticeSettings(activeKeys: const {'C'}, smartGeneratorMode: true),
      );

      await openAdvancedGeneratorSettings(tester, category: 'harmony');

      expect(find.text('Advanced Smart Generator'), findsWidgets);
      expect(
        find.byKey(const ValueKey('modulation-intensity-dropdown')),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey('modulation-intensity-dropdown')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('modulation-intensity-dropdown')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('High').last);
      await tester.pumpAndSettle();

      expect(controller.settings.modulationIntensity, ModulationIntensity.high);
      expect(
        find.byKey(const ValueKey('smart-diagnostics-toggle')),
        findsNothing,
      );
    },
  );

  testWidgets('voicing complexity dropdown updates to modern mode', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
      ),
    );

    await openAdvancedGeneratorSettings(tester, category: 'voicing');
    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-complexity-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('voicing-complexity-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modern').last);
    await tester.pumpAndSettle();

    expect(controller.settings.voicingComplexity, VoicingComplexity.modern);
  });

  testWidgets('voicing top-note dropdown updates explicit preference', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(voicingSuggestionsEnabled: true),
    );

    await openAdvancedGeneratorSettings(tester, category: 'voicing');
    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-top-note-dropdown')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('voicing-top-note-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('E').last);
    await tester.pumpAndSettle();

    expect(
      controller.settings.voicingTopNotePreference,
      VoicingTopNotePreference.e,
    );
  });

  testWidgets('voicing suggestion cards share keyboard range and note slots', (
    WidgetTester tester,
  ) async {
    final chord = buildTestChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7SharedAxis',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );
    final interpretation = ChordVoicingInterpretation(
      root: 'G',
      rootSemitone: 7,
      preferFlatSpelling: false,
      essentialTones: const [
        VoicingTone(label: '3', semitone: 4),
        VoicingTone(label: 'b7', semitone: 10),
      ],
      optionalTones: const [
        VoicingTone(label: '9', semitone: 2),
        VoicingTone(label: '13', semitone: 9),
      ],
      avoidTones: const [],
      styleTags: const {'dominant'},
      isDominantFamily: true,
    );
    final naturalVoicing = buildTestVoicing(
      family: VoicingFamily.rootlessA,
      midiNotes: const [43, 50, 57, 62],
      noteNames: const ['G', 'D', 'A', 'D'],
      toneLabels: const ['1', '5', '9', '5'],
      tensions: const {'9'},
      containsRoot: true,
    );
    final colorfulVoicing = buildTestVoicing(
      family: VoicingFamily.upperStructure,
      midiNotes: const [47, 54, 59, 64, 67],
      noteNames: const ['B', 'F#', 'B', 'E', 'G'],
      toneLabels: const ['3', '7', '3', '13', '#9'],
      tensions: const {'13', '#9'},
      containsThird: true,
      containsSeventh: true,
    );
    final easyVoicing = buildTestVoicing(
      family: VoicingFamily.shell,
      midiNotes: const [40, 47, 52],
      noteNames: const ['E', 'B', 'E'],
      toneLabels: const ['13', '3', '13'],
      tensions: const {'13'},
      containsThird: true,
    );
    final recommendations = VoicingRecommendationSet(
      currentChord: chord,
      interpretation: interpretation,
      rankedCandidates: const [],
      suggestions: [
        buildTestSuggestion(
          kind: VoicingSuggestionKind.natural,
          voicing: naturalVoicing,
          reasonTags: const [VoicingReasonTag.gentleMotion],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.colorful,
          voicing: colorfulVoicing,
          reasonTags: const [VoicingReasonTag.upperStructureColor],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.easy,
          voicing: easyVoicing,
          reasonTags: const [VoicingReasonTag.compactReach],
        ),
      ],
    );

    await pumpVoicingSection(tester, recommendations: recommendations);

    final keyboards = tester.widgetList<MiniKeyboard>(
      find.byType(MiniKeyboard),
    );

    expect(keyboards, hasLength(3));
    expect(
      keyboards
          .map((keyboard) => '${keyboard.minMidi}:${keyboard.maxMidi}')
          .toSet(),
      {'37:70'},
    );
    expect(
      find.byKey(const ValueKey('voicing-note-slot-natural-4')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-note-slot-colorful-4')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-note-slot-easy-4')),
      findsOneWidget,
    );
    expect(voicingNotesFor(tester, 'easy'), 'E B E');
    expect(voicingNotesFor(tester, 'colorful'), 'B F# B E G');

    await expandVoicingCard(tester, 'colorful');

    expect(
      find.byKey(const ValueKey('voicing-tone-slot-colorful-4')),
      findsOneWidget,
    );
    expect(voicingToneLabelsFor(tester, 'colorful'), '3 7 3 13 #9');

    await expandVoicingCard(tester, 'easy');

    expect(voicingToneLabelsFor(tester, 'easy'), '13 3 13');
  });

  testWidgets('voicing suggestion cards expose individual play buttons', (
    WidgetTester tester,
  ) async {
    final chord = buildTestChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7-play-buttons',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );
    final interpretation = const ChordVoicingInterpretation(
      root: 'G',
      rootSemitone: 7,
      preferFlatSpelling: false,
      essentialTones: <VoicingTone>[
        VoicingTone(label: '3', semitone: 4),
        VoicingTone(label: 'b7', semitone: 10),
      ],
      optionalTones: <VoicingTone>[VoicingTone(label: '9', semitone: 2)],
      avoidTones: <VoicingTone>[],
      styleTags: <String>{},
      isDominantFamily: true,
    );
    final naturalVoicing = buildTestVoicing(
      family: VoicingFamily.shell,
      midiNotes: const [43, 53, 59, 62],
      noteNames: const ['G', 'F', 'B', 'D'],
      toneLabels: const ['1', 'b7', '3', '9'],
      tensions: const {'9'},
      containsRoot: true,
      containsThird: true,
      containsSeventh: true,
    );
    final colorfulVoicing = buildTestVoicing(
      family: VoicingFamily.upperStructure,
      midiNotes: const [47, 53, 61, 66],
      noteNames: const ['B', 'F', 'C#', 'F#'],
      toneLabels: const ['3', 'b7', '#11', '13'],
      tensions: const {'#11', '13'},
      containsThird: true,
      containsSeventh: true,
    );
    final easyVoicing = buildTestVoicing(
      family: VoicingFamily.spread,
      midiNotes: const [43, 50, 59],
      noteNames: const ['G', 'D', 'B'],
      toneLabels: const ['1', '5', '3'],
      containsRoot: true,
      containsThird: true,
      containsSeventh: false,
    );
    final recommendations = VoicingRecommendationSet(
      currentChord: chord,
      interpretation: interpretation,
      rankedCandidates: const [],
      suggestions: [
        buildTestSuggestion(
          kind: VoicingSuggestionKind.natural,
          voicing: naturalVoicing,
          reasonTags: const [VoicingReasonTag.essentialCore],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.colorful,
          voicing: colorfulVoicing,
          reasonTags: const [VoicingReasonTag.upperStructureColor],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.easy,
          voicing: easyVoicing,
          reasonTags: const [VoicingReasonTag.compactReach],
        ),
      ],
    );

    await pumpVoicingSection(tester, recommendations: recommendations);

    expect(find.byKey(const ValueKey('voicing-play-natural')), findsOneWidget);
    expect(find.byKey(const ValueKey('voicing-play-colorful')), findsOneWidget);
    expect(find.byKey(const ValueKey('voicing-play-easy')), findsOneWidget);
  });

  testWidgets(
    'performance mode shows a representative voicing with next preview markers',
    (WidgetTester tester) async {
      final chord = buildTestChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'g7Performance',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
      );
      final currentVoicing = buildTestVoicing(
        family: VoicingFamily.rootlessA,
        midiNotes: const [50, 53, 59, 64],
        noteNames: const ['D', 'F', 'B', 'E'],
        toneLabels: const ['5', 'b7', '3', '13'],
        tensions: const {'13'},
        containsThird: true,
        containsSeventh: true,
      );
      final nextVoicing = buildTestVoicing(
        family: VoicingFamily.rootlessB,
        midiNotes: const [50, 55, 60, 65],
        noteNames: const ['D', 'G', 'C', 'F'],
        toneLabels: const ['9', '5', '1', '11'],
        tensions: const {'9', '11'},
        containsRoot: true,
        containsThird: true,
        containsSeventh: true,
      );
      final representative = buildTestSuggestion(
        kind: VoicingSuggestionKind.natural,
        voicing: currentVoicing,
        reasonTags: const [
          VoicingReasonTag.guideToneAnchor,
          VoicingReasonTag.nextChordReady,
        ],
      );
      final colorful = buildTestSuggestion(
        kind: VoicingSuggestionKind.colorful,
        voicing: buildTestVoicing(
          family: VoicingFamily.altered,
          midiNotes: const [49, 53, 58, 64],
          noteNames: const ['Db', 'F', 'Bb', 'E'],
          toneLabels: const ['b5', 'b7', '#9', '13'],
          tensions: const {'#9', '13'},
          containsThird: true,
          containsSeventh: true,
        ),
        reasonTags: const [VoicingReasonTag.alteredColor],
      );
      final easy = buildTestSuggestion(
        kind: VoicingSuggestionKind.easy,
        voicing: buildTestVoicing(
          family: VoicingFamily.shell,
          midiNotes: const [43, 53, 59],
          noteNames: const ['G', 'F', 'B'],
          toneLabels: const ['1', 'b7', '3'],
          containsRoot: true,
          containsThird: true,
          containsSeventh: true,
        ),
        reasonTags: const [VoicingReasonTag.guideToneAnchor],
      );
      final nextSuggestion = buildTestSuggestion(
        kind: VoicingSuggestionKind.easy,
        voicing: nextVoicing,
        reasonTags: const [VoicingReasonTag.commonToneRetention],
      );
      final recommendations = VoicingRecommendationSet(
        currentChord: chord,
        interpretation: const ChordVoicingInterpretation(
          root: 'G',
          rootSemitone: 7,
          preferFlatSpelling: false,
          essentialTones: [],
          optionalTones: [],
          avoidTones: [],
          styleTags: {},
        ),
        rankedCandidates: [
          RankedVoicingCandidate(
            voicing: currentVoicing,
            breakdown: const VoicingBreakdown(
              total: 2.6,
              nextChordLookAheadBonus: 0.8,
            ),
            naturalScore: 2.6,
            colorfulScore: 2.0,
            easyScore: 2.1,
            reasonTags: representative.reasonTags,
          ),
          RankedVoicingCandidate(
            voicing: colorful.voicing,
            breakdown: const VoicingBreakdown(total: 2.0, colorBonus: 1.1),
            naturalScore: 1.9,
            colorfulScore: 2.4,
            easyScore: 1.5,
            reasonTags: colorful.reasonTags,
          ),
          RankedVoicingCandidate(
            voicing: easy.voicing,
            breakdown: const VoicingBreakdown(total: 1.8, simplicityBonus: 0.9),
            naturalScore: 1.7,
            colorfulScore: 1.2,
            easyScore: 2.3,
            reasonTags: easy.reasonTags,
          ),
        ],
        suggestions: [representative, colorful, easy],
        performancePreview: PerformanceVoicingPreview(
          representativeSuggestion: representative,
          nextSuggestion: nextSuggestion,
          sharedMidiNotes: const {50},
          currentOnlyMidiNotes: const {53, 59, 64},
          nextOnlyMidiNotes: const {55, 60, 65},
        ),
      );

      await pumpVoicingSection(
        tester,
        recommendations: recommendations,
        displayMode: VoicingDisplayMode.performance,
        selectedSignature: currentVoicing.signature,
      );

      expect(
        find.byKey(const ValueKey('voicing-performance-panel')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voicing-performance-current-notes')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voicing-performance-next-notes')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voicing-performance-keyboard')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('mini-key-shared-50')), findsOneWidget);
      expect(find.byKey(const ValueKey('mini-key-current-53')), findsOneWidget);
      expect(find.byKey(const ValueKey('mini-key-next-55')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('voicing-performance-topline-path')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voicing-performance-selected-badge')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'modern upper-structure card shows subtitle, chip, and badges without overflow',
    (WidgetTester tester) async {
      final chord = buildTestChord(
        root: 'G',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'g7Sharp11',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        dominantContext: DominantContext.dominantIILydian,
        dominantIntent: DominantIntent.lydianDominant,
      );
      final interpretation = ChordVoicingInterpretation(
        root: 'G',
        rootSemitone: 7,
        preferFlatSpelling: false,
        essentialTones: const [
          VoicingTone(label: '3', semitone: 4),
          VoicingTone(label: 'b7', semitone: 10),
        ],
        optionalTones: const [
          VoicingTone(label: '#11', semitone: 6),
          VoicingTone(label: '13', semitone: 9),
        ],
        avoidTones: const [],
        styleTags: const {'dominant', 'modern'},
        isDominantFamily: true,
      );
      final naturalVoicing = buildTestVoicing(
        family: VoicingFamily.rootlessA,
        midiNotes: const [47, 53, 57, 62],
        noteNames: const ['B', 'F', 'A', 'D'],
        toneLabels: const ['3', 'b7', '9', '5'],
        tensions: const {'9'},
        containsThird: true,
        containsSeventh: true,
      );
      final colorfulVoicing = buildTestVoicing(
        family: VoicingFamily.upperStructure,
        midiNotes: const [47, 53, 61, 64],
        noteNames: const ['B', 'F', 'C#', 'E'],
        toneLabels: const ['3', 'b7', '#11', '13'],
        tensions: const {'#11', '13'},
        containsThird: true,
        containsSeventh: true,
      );
      final easyVoicing = buildTestVoicing(
        family: VoicingFamily.shell,
        midiNotes: const [43, 53, 59],
        noteNames: const ['G', 'F', 'B'],
        toneLabels: const ['1', 'b7', '3'],
        containsRoot: true,
        containsThird: true,
        containsSeventh: true,
      );
      final recommendations = VoicingRecommendationSet(
        currentChord: chord,
        interpretation: interpretation,
        rankedCandidates: const [],
        effectiveTopNotePitchClass: 4,
        topNoteSource: VoicingTopNoteSource.explicitPreference,
        suggestions: [
          buildTestSuggestion(
            kind: VoicingSuggestionKind.natural,
            voicing: naturalVoicing,
            reasonTags: const [
              VoicingReasonTag.guideToneAnchor,
              VoicingReasonTag.gentleMotion,
            ],
          ),
          buildTestSuggestion(
            kind: VoicingSuggestionKind.colorful,
            voicing: colorfulVoicing,
            reasonTags: const [
              VoicingReasonTag.tritoneSubFlavor,
              VoicingReasonTag.upperStructureColor,
              VoicingReasonTag.guideToneAnchor,
            ],
            locked: true,
          ),
          buildTestSuggestion(
            kind: VoicingSuggestionKind.easy,
            voicing: easyVoicing,
            reasonTags: const [
              VoicingReasonTag.essentialCore,
              VoicingReasonTag.compactReach,
            ],
          ),
        ],
      );

      await pumpVoicingSection(
        tester,
        recommendations: recommendations,
        selectedSignature: colorfulVoicing.signature,
      );

      await expandVoicingCard(tester, 'colorful');

      expect(find.text('Top line target: E'), findsOneWidget);
      expect(
        find.text('Tritone-sub edge with bright guide tones'),
        findsOneWidget,
      );
      expect(find.text('Upper-structure color'), findsOneWidget);
      expect(find.text('Tritone-sub flavor'), findsOneWidget);
      expect(find.text('Top E'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('voicing-selected-badge-colorful')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('voicing-locked-badge-colorful')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'top-line fallback subtitle appears when exact target is unavailable',
    (WidgetTester tester) async {
      final chord = buildTestChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cmaj7FallbackTop',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
      );
      final interpretation = ChordVoicingInterpretation(
        root: 'C',
        rootSemitone: 0,
        preferFlatSpelling: false,
        essentialTones: const [
          VoicingTone(label: '3', semitone: 4),
          VoicingTone(label: '7', semitone: 11),
        ],
        optionalTones: const [VoicingTone(label: '9', semitone: 2)],
        avoidTones: const [],
        styleTags: const {'major'},
        isMajorFamily: true,
      );
      final naturalVoicing = buildTestVoicing(
        family: VoicingFamily.shell,
        midiNotes: const [36, 47, 52],
        noteNames: const ['C', 'B', 'E'],
        toneLabels: const ['1', '7', '3'],
        containsRoot: true,
        containsThird: true,
        containsSeventh: true,
      );
      final colorfulVoicing = buildTestVoicing(
        family: VoicingFamily.rootlessA,
        midiNotes: const [40, 47, 50],
        noteNames: const ['E', 'B', 'D'],
        toneLabels: const ['3', '7', '9'],
        tensions: const {'9'},
        containsThird: true,
        containsSeventh: true,
      );
      final easyVoicing = buildTestVoicing(
        family: VoicingFamily.spread,
        midiNotes: const [43, 47, 52],
        noteNames: const ['G', 'B', 'E'],
        toneLabels: const ['5', '7', '3'],
        containsThird: true,
        containsSeventh: true,
      );
      final recommendations = VoicingRecommendationSet(
        currentChord: chord,
        interpretation: interpretation,
        rankedCandidates: const [],
        effectiveTopNotePitchClass: 1,
        topNoteSource: VoicingTopNoteSource.explicitPreference,
        topNoteMatch: VoicingTopNoteMatch.unavailable,
        suggestions: [
          buildTestSuggestion(
            kind: VoicingSuggestionKind.natural,
            voicing: naturalVoicing,
            reasonTags: const [VoicingReasonTag.essentialCore],
          ),
          buildTestSuggestion(
            kind: VoicingSuggestionKind.colorful,
            voicing: colorfulVoicing,
            reasonTags: const [
              VoicingReasonTag.upperStructureColor,
              VoicingReasonTag.topLineTarget,
            ],
          ),
          buildTestSuggestion(
            kind: VoicingSuggestionKind.easy,
            voicing: easyVoicing,
            reasonTags: const [VoicingReasonTag.compactReach],
          ),
        ],
      );

      await pumpVoicingSection(tester, recommendations: recommendations);

      await expandVoicingCard(tester, 'natural');

      expect(find.text('No exact top line for Db'), findsOneWidget);
      expect(find.text('Top E'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('modern quartal card shows quartal reason copy', (
    WidgetTester tester,
  ) async {
    final chord = buildTestChord(
      root: 'D',
      quality: ChordQuality.minor7,
      repeatKey: 'dm7',
      romanNumeralId: RomanNumeralId.iiMin7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.predominant,
    );
    final interpretation = ChordVoicingInterpretation(
      root: 'D',
      rootSemitone: 2,
      preferFlatSpelling: false,
      essentialTones: const [
        VoicingTone(label: 'b3', semitone: 3),
        VoicingTone(label: 'b7', semitone: 10),
      ],
      optionalTones: const [
        VoicingTone(label: '11', semitone: 5),
        VoicingTone(label: '9', semitone: 2),
      ],
      avoidTones: const [],
      styleTags: const {'minor', 'modern'},
      isMinorFamily: true,
    );
    final naturalVoicing = buildTestVoicing(
      family: VoicingFamily.shell,
      midiNotes: const [38, 48, 53],
      noteNames: const ['D', 'C', 'F'],
      toneLabels: const ['1', 'b7', 'b3'],
      containsRoot: true,
      containsThird: true,
      containsSeventh: true,
    );
    final colorfulVoicing = buildTestVoicing(
      family: VoicingFamily.quartal,
      midiNotes: const [43, 48, 53],
      noteNames: const ['G', 'C', 'F'],
      toneLabels: const ['11', 'b7', 'b3'],
      tensions: const {'11'},
      containsThird: true,
      containsSeventh: true,
    );
    final easyVoicing = buildTestVoicing(
      family: VoicingFamily.rootlessA,
      midiNotes: const [41, 48, 55],
      noteNames: const ['F', 'C', 'G'],
      toneLabels: const ['b3', 'b7', '11'],
      tensions: const {'11'},
      containsThird: true,
      containsSeventh: true,
    );
    final recommendations = VoicingRecommendationSet(
      currentChord: chord,
      interpretation: interpretation,
      rankedCandidates: const [],
      suggestions: [
        buildTestSuggestion(
          kind: VoicingSuggestionKind.natural,
          voicing: naturalVoicing,
          reasonTags: const [
            VoicingReasonTag.essentialCore,
            VoicingReasonTag.gentleMotion,
          ],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.colorful,
          voicing: colorfulVoicing,
          reasonTags: const [
            VoicingReasonTag.quartalColor,
            VoicingReasonTag.guideToneAnchor,
          ],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.easy,
          voicing: easyVoicing,
          reasonTags: const [
            VoicingReasonTag.compactReach,
            VoicingReasonTag.lowMudAvoided,
          ],
        ),
      ],
    );

    await pumpVoicingSection(tester, recommendations: recommendations);

    await expandVoicingCard(tester, 'colorful');

    expect(find.text('Modern quartal color'), findsOneWidget);
    expect(find.text('Quartal color'), findsOneWidget);
    final exception = tester.takeException();
    if (exception != null) {
      // ignore: avoid_print
      print(exception.toStringDeep());
      if (exception is FlutterError) {
        for (final diagnostic in exception.diagnostics) {
          // ignore: avoid_print
          print('DIAG: ${diagnostic.toStringDeep()}');
        }
      }
    }
    expect(exception, isNull);
  });

  testWidgets('merged voicing cards show combined labels without duplicates', (
    WidgetTester tester,
  ) async {
    final chord = buildTestChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cmaj7',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
    );
    final interpretation = ChordVoicingInterpretation(
      root: 'C',
      rootSemitone: 0,
      preferFlatSpelling: false,
      essentialTones: const [
        VoicingTone(label: '3', semitone: 4),
        VoicingTone(label: '7', semitone: 11),
      ],
      optionalTones: const [VoicingTone(label: '9', semitone: 2)],
      avoidTones: const [],
      styleTags: const {'major'},
      isMajorFamily: true,
    );
    final naturalVoicing = buildTestVoicing(
      family: VoicingFamily.shell,
      midiNotes: const [36, 47, 52],
      noteNames: const ['C', 'B', 'E'],
      toneLabels: const ['1', '7', '3'],
      containsRoot: true,
      containsThird: true,
      containsSeventh: true,
    );
    final colorfulVoicing = buildTestVoicing(
      family: VoicingFamily.rootlessA,
      midiNotes: const [40, 47, 50],
      noteNames: const ['E', 'B', 'D'],
      toneLabels: const ['3', '7', '9'],
      tensions: const {'9'},
      containsThird: true,
      containsSeventh: true,
    );
    final recommendations = VoicingRecommendationSet(
      currentChord: chord,
      interpretation: interpretation,
      rankedCandidates: const [],
      suggestions: [
        buildTestSuggestion(
          kind: VoicingSuggestionKind.natural,
          kinds: const [
            VoicingSuggestionKind.natural,
            VoicingSuggestionKind.easy,
          ],
          voicing: naturalVoicing,
          reasonTags: const [
            VoicingReasonTag.stableRepeat,
            VoicingReasonTag.gentleMotion,
            VoicingReasonTag.compactReach,
          ],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.colorful,
          voicing: colorfulVoicing,
          reasonTags: const [VoicingReasonTag.upperStructureColor],
        ),
      ],
    );

    await pumpVoicingSection(tester, recommendations: recommendations);

    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-natural')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
      findsNothing,
    );
    expect(find.text('Most Natural & Easiest'), findsOneWidget);

    await expandVoicingCard(tester, 'natural');

    expect(find.text('Same shape, steady comping'), findsOneWidget);
    expect(find.text('Stable repeat'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final initialText = currentChordText(tester);
    final initialNextText = nextChordText(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    final advancedText = currentChordText(tester);

    expect(initialText, isNotNull);
    expect(initialNextText, isNotNull);
    expect(advancedText, initialNextText);
    expect(previousChordText(tester), initialText);
    expect(advancedText, isNotEmpty);
  });

  testWidgets(
    'tapping previous and next chord regions uses animated navigation',
    (WidgetTester tester) async {
      await pumpApp(tester);
      final initialText = currentChordText(tester);
      final initialNextText = nextChordText(tester);

      await tester.tap(nextChordTapTarget().hitTestable());
      await tester.pump(const Duration(milliseconds: 40));

      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpAndSettle();

      final firstAdvancedText = currentChordText(tester);
      expect(firstAdvancedText, initialNextText);
      expect(previousChordText(tester), initialText);
      expect(firstAdvancedText, isNotNull);
      expect(firstAdvancedText, isNot(''));

      final secondPreviewText = nextChordText(tester);
      await tapNextChordRegion(tester);
      final secondAdvancedText = currentChordText(tester);

      expect(secondAdvancedText, secondPreviewText);
      expect(previousChordText(tester), firstAdvancedText);

      await tapPreviousChordRegion(tester);

      expect(currentChordText(tester), firstAdvancedText);
    },
  );

  testWidgets('hard fling glides through multiple chords in one gesture', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final initialText = currentChordText(tester);

    await tester.fling(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(-360, 0),
      3600,
    );
    await tester.pumpAndSettle();

    final flingText = currentChordText(tester);
    final flingPreviousText = previousChordText(tester);

    expect(flingText, isNotNull);
    expect(flingText, isNotEmpty);
    expect(flingPreviousText, isNotNull);
    expect(flingPreviousText, isNotEmpty);

    await tapPreviousChordRegion(tester);

    final afterOneBack = currentChordText(tester);
    expect(afterOneBack, flingPreviousText);

    await tester.fling(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(360, 0),
      3600,
    );
    await tester.pumpAndSettle();

    expect(currentChordText(tester), initialText);
  });

  testWidgets('manual chord navigation resets metronome progress', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(bpm: 240, metronomeEnabled: false),
    );

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();

    expect(activeBeatIndex(tester), 0);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pumpAndSettle();

    expect(activeBeatIndex(tester), 0);

    await tapNextChordRegion(tester);
    expect(activeBeatIndex(tester), isNull);

    await tester.drag(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(220, 0),
    );
    await tester.pumpAndSettle();
    expect(activeBeatIndex(tester), isNull);
  });

  testWidgets('autoplay resumes from the stopped beat without jumping chords', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(bpm: 240, metronomeEnabled: false),
    );

    final initialText = currentChordText(tester);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();

    expect(currentChordText(tester), initialText);
    expect(activeBeatIndex(tester), 0);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pumpAndSettle();

    expect(activeBeatIndex(tester), 0);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();

    expect(activeBeatIndex(tester), 0);
    expect(currentChordText(tester), initialText);
  });

  testWidgets(
    'reset button restores a fresh starting state without changing settings',
    (WidgetTester tester) async {
      await pumpAppWithSettings(
        tester,
        PracticeSettings(
          timeSignature: PracticeTimeSignature.threeFour,
          melodyGenerationEnabled: true,
          metronomeEnabled: false,
        ),
      );

      final initialText = currentChordText(tester);
      final initialNextText = nextChordText(tester);

      await tapNextChordRegion(tester);
      expect(currentChordText(tester), initialNextText);
      expect(previousChordText(tester), initialText);
      expect(currentChordText(tester), isNotEmpty);

      await tester.ensureVisible(
        find.byKey(const ValueKey('practice-autoplay-button')),
      );
      await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
      await tester.pump();
      expect(activeBeatIndex(tester), 0);

      await tester.ensureVisible(
        find.byKey(const ValueKey('practice-reset-generated-chords-button')),
      );
      await tester.tap(
        find.byKey(const ValueKey('practice-reset-generated-chords-button')),
      );
      await tester.pumpAndSettle();

      expect(currentChordText(tester), isNotEmpty);
      expect(activeBeatIndex(tester), isNull);
      expect(beatCount(tester), 3);
      expect(
        find.byKey(const ValueKey('practice-regenerate-melody-button')),
        findsOneWidget,
      );
      expect(
        iconForButton(tester, 'practice-autoplay-button'),
        Icons.play_arrow_rounded,
      );
    },
  );

  test(
    'practice auto tick advances chords only at the scheduled change beat',
    () {
      final firstTick = computeNextPracticeAutoBeat(currentBeat: null);
      expect(firstTick.nextBeat, 0);
      expect(firstTick.shouldAdvanceChord, isFalse);

      final wrapTick = computeNextPracticeAutoBeat(
        currentBeat: 3,
        nextChangeBeat: 0,
      );
      expect(wrapTick.nextBeat, 0);
      expect(wrapTick.shouldAdvanceChord, isTrue);

      final splitTick = computeNextPracticeAutoBeat(
        currentBeat: 1,
        beatCount: 4,
        nextChangeBeat: 2,
      );
      expect(splitTick.nextBeat, 2);
      expect(splitTick.shouldAdvanceChord, isTrue);
    },
  );

  test(
    'practice autoplay starts immediately only from a cleared beat state',
    () {
      expect(shouldStartPracticeAutoplayImmediately(null), isTrue);
      expect(shouldStartPracticeAutoplayImmediately(0), isFalse);
      expect(shouldStartPracticeAutoplayImmediately(2), isFalse);
    },
  );

  testWidgets('queued momentum fling keeps sliding instead of pausing', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    final centeredX = tester
        .getCenter(find.byKey(const ValueKey('current-chord-text')))
        .dx;

    await tester.fling(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(-360, 0),
      3600,
    );
    await tester.pump(const Duration(milliseconds: 220));

    expect(tester.hasRunningAnimations, isTrue);
    expect(
      tester.getCenter(find.byKey(const ValueKey('current-chord-text'))).dx,
      lessThan(centeredX - 6),
    );

    await tester.pumpAndSettle();
  });

  testWidgets('3/4 settings show a three-beat indicator', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        timeSignature: PracticeTimeSignature.threeFour,
        bpm: 240,
      ),
    );

    expect(beatCount(tester), 3);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();
    expect(activeBeatIndex(tester), 0);
  });

  testWidgets('2/4 settings show a two-beat indicator', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(timeSignature: PracticeTimeSignature.twoFour, bpm: 240),
    );

    expect(beatCount(tester), 2);

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();
    expect(activeBeatIndex(tester), 0);
  });

  testWidgets('advanced settings update time signature and harmonic rhythm', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    await openAdvancedGeneratorSettings(tester, category: 'rhythm');

    await tester.tap(
      find.byKey(const ValueKey('practice-time-signature-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('3/4').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('practice-harmonic-rhythm-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Phrase-aware jazz').last);
    await tester.pumpAndSettle();

    expect(controller.settings.timeSignature, PracticeTimeSignature.threeFour);
    expect(
      controller.settings.harmonicRhythmPreset,
      HarmonicRhythmPreset.phraseAwareJazz,
    );
  });

  testWidgets('advanced settings update transport audio controls', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    await openAdvancedGeneratorSettings(tester, category: 'rhythm');

    await tester.tap(
      find.byKey(const ValueKey('auto-play-chord-changes-toggle')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('auto-play-pattern-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arpeggio').last);
    await tester.pumpAndSettle();

    await selectAdvancedSettingsCategory(tester, 'metronome');
    await tester.ensureVisible(
      find.byKey(const ValueKey('metronome-pattern-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('metronome-pattern-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Meter accent').last);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('metronome-accent-sound-toggle')),
    );
    await tester.pumpAndSettle();

    expect(controller.settings.autoPlayChordChanges, isTrue);
    expect(
      controller.settings.autoPlayPattern,
      HarmonyPlaybackPattern.arpeggio,
    );
    expect(
      controller.settings.metronomePattern.preset,
      MetronomePatternPreset.meterAccent,
    );
    expect(controller.settings.metronomeUseAccentSound, isTrue);
  });

  testWidgets('advanced settings update melody generation controls', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    await openAdvancedGeneratorSettings(tester, category: 'melody');

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-generation-enabled-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('melody-generation-enabled-toggle')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-density-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('melody-density-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Active').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-style-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('melody-style-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bebop').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('allow-chromatic-approaches-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('allow-chromatic-approaches-toggle')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-playback-mode-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('melody-playback-mode-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Melody only').last);
    await tester.pumpAndSettle();

    expect(controller.settings.melodyGenerationEnabled, isTrue);
    expect(controller.settings.melodyDensity, MelodyDensity.active);
    expect(controller.settings.melodyStyle, MelodyStyle.bebop);
    expect(controller.settings.allowChromaticApproaches, isTrue);
    expect(
      controller.settings.melodyPlaybackMode,
      MelodyPlaybackMode.melodyOnly,
    );
  });

  testWidgets('advanced settings anchor editor saves enabled anchor slots', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final controller = await pumpAppWithController(tester, PracticeSettings());

    await openAdvancedGeneratorSettings(tester, category: 'anchors');
    await tester.ensureVisible(find.byKey(const ValueKey('anchor-slot-0-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('anchor-slot-0-0')));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('analyzer-key-f')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('analyzer-key-minor')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('analyzer-key-dom7')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('analyzer-key-dom7')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();

    final slot = controller.settings.anchorLoop.slotForPosition(
      barOffset: 0,
      slotIndexWithinBar: 0,
    );

    expect(slot, isNotNull);
    expect(slot?.trimmedChordSymbol, 'Fm7');
    expect(slot?.enabled, isTrue);
    expect(find.text('Fm7'), findsOneWidget);
  });

  testWidgets('exact anchor symbols recur across repeated cycle slots', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        },
        anchorLoop: const ChordAnchorLoop(
          cycleLengthBars: 4,
          slots: [
            ChordAnchorSlot(
              barOffset: 0,
              slotIndexWithinBar: 0,
              chordSymbol: 'Fm7',
              enabled: true,
            ),
          ],
        ),
      ),
    );

    final observed = <String?>[currentChordText(tester)];
    for (var index = 0; index < 8; index += 1) {
      await advanceChord(tester);
      observed.add(currentChordText(tester));
    }

    final anchorIndices = <int>[
      for (var index = 0; index < observed.length; index += 1)
        if (observed[index] == 'Fm7') index,
    ];

    expect(anchorIndices.length, greaterThanOrEqualTo(2));
    for (var index = 1; index < anchorIndices.length; index += 1) {
      expect(anchorIndices[index] - anchorIndices[index - 1], 4);
    }
  });

  testWidgets('melody quick toggle reveals regenerate and playback controls', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    expect(
      find.byKey(const ValueKey('practice-regenerate-melody-button')),
      findsNothing,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-generation-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('melody-generation-toggle')));
    await tester.pumpAndSettle();

    expect(controller.settings.melodyGenerationEnabled, isTrue);
    expect(
      find.byKey(const ValueKey('practice-regenerate-melody-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('melody-playback-mode-both')),
      findsOneWidget,
    );
  });

  testWidgets('melody quick preset chips apply distinct line settings', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(tester, PracticeSettings());

    await tester.ensureVisible(
      find.byKey(const ValueKey('melody-preset-guideLine')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('melody-preset-guideLine')));
    await tester.pumpAndSettle();

    expect(controller.settings.melodyGenerationEnabled, isTrue);
    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(controller.settings),
      MelodyQuickPreset.guideLine,
    );
    expect(controller.settings.syncopationBias, lessThan(0.2));
    expect(controller.settings.colorRealizationBias, lessThan(0.2));
    expect(find.textContaining('steady guide notes'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('melody-preset-songLine')));
    await tester.pumpAndSettle();

    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(controller.settings),
      MelodyQuickPreset.songLine,
    );
    expect(controller.settings.allowChromaticApproaches, isTrue);
    expect(controller.settings.syncopationBias, greaterThan(0.3));
    expect(controller.settings.noveltyTarget, greaterThan(0.5));
    expect(find.textContaining('singable contour'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('melody-preset-colorLine')));
    await tester.pumpAndSettle();

    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(controller.settings),
      MelodyQuickPreset.colorLine,
    );
    expect(controller.settings.melodyDensity, MelodyDensity.active);
    expect(controller.settings.colorRealizationBias, greaterThan(0.8));
    expect(controller.settings.motifVariationBias, greaterThan(0.85));
    expect(find.textContaining('color-forward line'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('melody-preset-off')));
    await tester.pumpAndSettle();

    expect(controller.settings.melodyGenerationEnabled, isFalse);
  });

  testWidgets('transport uses separate play, pause, speaker, and reset icons', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(
      iconForButton(tester, 'practice-play-chord-button'),
      Icons.volume_up_rounded,
    );
    expect(
      iconForButton(tester, 'practice-autoplay-button'),
      Icons.play_arrow_rounded,
    );
    expect(
      iconForButton(tester, 'practice-reset-generated-chords-button'),
      Icons.stop_rounded,
    );

    await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
    await tester.pump();

    expect(
      iconForButton(tester, 'practice-autoplay-button'),
      Icons.pause_rounded,
    );
  });

  testWidgets('manual advance auto-plays chord changes when enabled', (
    WidgetTester tester,
  ) async {
    final audio = _SpyHarmonyAudioService();
    await pumpAppWithAudioService(
      tester,
      PracticeSettings(autoPlayChordChanges: true, metronomeEnabled: false),
      harmonyAudioService: audio,
    );

    await tapNextChordRegion(tester);

    expect(audio.playedLabels, isNotEmpty);
    expect(audio.playedLabels.last.$1, HarmonyPlaybackPattern.block);
  });

  testWidgets('tap back also auto-plays the restored chord when enabled', (
    WidgetTester tester,
  ) async {
    final audio = _SpyHarmonyAudioService();
    await pumpAppWithAudioService(
      tester,
      PracticeSettings(autoPlayChordChanges: true, metronomeEnabled: false),
      harmonyAudioService: audio,
    );

    await tapNextChordRegion(tester);
    await tapNextChordRegion(tester);
    final afterNextTapCount = audio.playedLabels.length;

    await tapPreviousChordRegion(tester);
    await tester.pump();

    expect(afterNextTapCount, greaterThan(0));
    expect(audio.playedLabels.length, afterNextTapCount + 1);
    expect(audio.playedLabels.last.$1, HarmonyPlaybackPattern.block);
  });

  testWidgets('drag navigation stays silent even when auto-play is enabled', (
    WidgetTester tester,
  ) async {
    final audio = _SpyHarmonyAudioService();
    await pumpAppWithAudioService(
      tester,
      PracticeSettings(autoPlayChordChanges: true, metronomeEnabled: false),
      harmonyAudioService: audio,
    );

    await advanceChord(tester);
    expect(audio.playedLabels, isEmpty);

    await tester.drag(
      find.byKey(const ValueKey('chord-swipe-surface')),
      const Offset(220, 0),
    );
    await tester.pumpAndSettle();

    expect(audio.playedLabels, isEmpty);
  });

  testWidgets('melody playback mode routes preview audio correctly', (
    WidgetTester tester,
  ) async {
    final audio = _SpyHarmonyAudioService();
    await pumpAppWithAudioService(
      tester,
      PracticeSettings(
        melodyGenerationEnabled: true,
        melodyPlaybackMode: MelodyPlaybackMode.melodyOnly,
        metronomeEnabled: false,
      ),
      harmonyAudioService: audio,
    );

    await advanceChord(tester);
    await tester.tap(find.byKey(const ValueKey('practice-play-chord-button')));
    await tester.pumpAndSettle();

    expect(audio.playedCompositeClips, isNotEmpty);
    expect(audio.playedCompositeClips.last.chordClip, isNull);
    expect(audio.playedCompositeClips.last.melodyClip, isNotNull);

    await tester.tap(find.byKey(const ValueKey('melody-playback-mode-both')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('practice-play-chord-button')));
    await tester.pumpAndSettle();

    expect(audio.playedCompositeClips.last.chordClip, isNotNull);
    expect(audio.playedCompositeClips.last.melodyClip, isNotNull);
  });

  testWidgets('bpm input accepts three digits and hides the range helper', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(language: AppLanguage.ko, bpm: 100),
    );

    await tester.enterText(find.byKey(const ValueKey('bpm-input')), '180');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(controller.settings.bpm, 180);
    expect(find.text('\uD5C8\uC6A9 \uBC94\uC704: 20-300'), findsNothing);
  });

  testWidgets('vertical drag on bpm field adjusts the bpm', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(bpm: 120),
    );

    await tester.ensureVisible(find.byKey(const ValueKey('bpm-drag-surface')));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('bpm-drag-surface')),
      const Offset(0, -56),
    );
    await tester.pumpAndSettle();

    expect(controller.settings.bpm, greaterThan(120));
  });

  testWidgets('holding the bpm increase button keeps increasing bpm', (
    WidgetTester tester,
  ) async {
    final controller = await pumpAppWithController(
      tester,
      PracticeSettings(bpm: 120),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('bpm-increase-button')),
    );
    await tester.pumpAndSettle();
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('bpm-increase-button'))),
    );
    await tester.pump(const Duration(milliseconds: 520));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(controller.settings.bpm, greaterThan(125));
  });

  testWidgets('voicing suggestions section can be hidden from settings', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(voicingSuggestionsEnabled: false),
    );

    await advanceChord(tester);

    expect(
      find.byKey(const ValueKey('voicing-suggestions-section')),
      findsNothing,
    );
  });

  testWidgets('voicing suggestion cards render after advancing to a chord', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
        allowTensions: true,
      ),
    );

    await advanceChord(tester);

    expect(
      find.byKey(const ValueKey('voicing-suggestions-section')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-natural')),
      findsOneWidget,
    );
    expect(renderedVoicingCardKeys(tester), isNotEmpty);
  });

  testWidgets('locking a voicing suggestion updates the card affordance', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
        allowTensions: true,
      ),
    );

    await advanceChord(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-lock-natural')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('voicing-lock-natural')));
    await tester.pumpAndSettle();

    await expandVoicingCard(tester, 'natural');

    expect(find.byIcon(Icons.lock), findsWidgets);
    expect(
      find.byKey(const ValueKey('voicing-locked-badge-natural')),
      findsOneWidget,
    );
  });

  testWidgets('locked voicing keeps selected and locked state aligned', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
        allowTensions: true,
        lookAheadDepth: 2,
      ),
    );

    await advanceChord(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-lock-natural')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('voicing-lock-natural')));
    await tester.pumpAndSettle();

    final selectedKind = voicingBadgeKind(tester, 'selected');
    final lockedKind = voicingBadgeKind(tester, 'locked');

    expect(selectedKind, isNotNull);
    expect(lockedKind, isNotNull);
    expect(selectedKind, lockedKind);
  });

  testWidgets('selection and display-only settings keep voicing notes stable', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
        allowTensions: true,
        lookAheadDepth: 2,
      ),
    );

    await advanceChord(tester);

    final beforeToggle = voicingNotesFor(tester, 'natural');
    final selectableCardKey = renderedVoicingCardKeys(tester).contains('easy')
        ? 'easy'
        : renderedVoicingCardKeys(
            tester,
          ).firstWhere((kind) => kind != 'natural', orElse: () => 'natural');

    await tester.ensureVisible(
      find.byKey(ValueKey('voicing-suggestion-card-$selectableCardKey')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ValueKey('voicing-suggestion-card-$selectableCardKey')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(ValueKey('voicing-selected-badge-$selectableCardKey')),
      findsOneWidget,
    );

    await openAdvancedGeneratorSettings(tester, category: 'voicing');
    await tester.ensureVisible(
      find.byKey(const ValueKey('show-voicing-reasons-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('show-voicing-reasons-toggle')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(voicingNotesFor(tester, 'natural'), beforeToggle);
  });

  testWidgets('voicing suggestions avoid overflow on narrow width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 860));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpAppWithSettings(
      tester,
      PracticeSettings(
        activeKeys: const {'C'},
        voicingSuggestionsEnabled: true,
        allowTensions: true,
      ),
    );

    await advanceChord(tester);

    expect(
      find.byKey(const ValueKey('voicing-suggestions-section')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('advanced melody settings expose line personality sliders', (
    WidgetTester tester,
  ) async {
    var latest = PracticeSettings(melodyGenerationEnabled: true);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PracticeAdvancedSettingsPage(
          settings: latest,
          onApplySettings: (nextSettings, {bool reseed = false}) {
            latest = nextSettings;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('advanced-settings-tab-melody')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('syncopation-bias-slider')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('color-realization-bias-slider')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('novelty-target-slider')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('motif-variation-bias-slider')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('syncopation-bias-slider')),
    );
    await tester.pumpAndSettle();

    final syncSlider = find.descendant(
      of: find.byKey(const ValueKey('syncopation-bias-slider')),
      matching: find.byType(Slider),
    );
    await tester.drag(syncSlider, const Offset(160, 0));
    await tester.pumpAndSettle();

    expect(latest.syncopationBias, greaterThan(0.42));
  });

  testWidgets('korean localization renders metronome sound copy', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(language: AppLanguage.ko),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('\uC124\uC815'), findsWidgets);
    expect(find.text('\uBA54\uD2B8\uB85C\uB188'), findsWidgets);
    expect(find.text('\uBA54\uD2B8\uB85C\uB188 \uC18C\uB9AC'), findsOneWidget);
    expect(find.text('\uC870\uC131 \uD45C\uAE30 \uBC29\uC2DD'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('metronome-sound-selector')),
    );
    await tester.tap(find.byKey(const ValueKey('metronome-sound-selector')));
    await tester.pumpAndSettle();

    expect(find.text('\uD074\uB798\uC2DD'), findsWidgets);
    expect(find.text('\uD074\uB9AD B'), findsWidgets);
    await tester.tap(find.text('\uD074\uB798\uC2DD').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('chord-symbol-style-dropdown')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('chord-symbol-style-dropdown')));
    await tester.pumpAndSettle();

    expect(find.textContaining('\uAC04\uACB0\uD615'), findsWidgets);
    expect(find.textContaining('Maj \uD45C\uAE30'), findsWidgets);
    expect(find.textContaining('\uB378\uD0C0 \uC7AC\uC988'), findsWidgets);
  });

  testWidgets('korean localization covers main menu and analyzer entry flow', (
    WidgetTester tester,
  ) async {
    await pumpMainMenuWithSettings(
      tester,
      PracticeSettings(language: AppLanguage.ko),
    );

    expect(find.text('\uCF54\uB4DC \uC0DD\uC131\uAE30'), findsOneWidget);
    expect(find.text('\uCF54\uB4DC \uBD84\uC11D\uAE30'), findsOneWidget);
    expect(find.text('\uD654\uC131 \uD559\uC2B5'), findsOneWidget);
    expect(find.text('\uC0DD\uC131\uAE30 \uC5F4\uAE30'), findsNothing);
    expect(find.text('\uBD84\uC11D\uAE30 \uC5F4\uAE30'), findsNothing);
    expect(find.text('Open Generator'), findsNothing);
    expect(find.text('Open Analyzer'), findsNothing);

    await openChordAnalyzer(tester);
    await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
    await tester.pumpAndSettle();

    expect(find.text('\uCF54\uB4DC \uC9C4\uD589'), findsOneWidget);
    expect(find.text('\uBD84\uC11D\uD558\uAE30'), findsWidgets);
    expect(find.text('\uCF54\uB4DC \uD328\uB4DC'), findsOneWidget);
    expect(find.text('\uC608\uC2DC'), findsOneWidget);
  });

  testWidgets('system language follows the platform locale', (
    WidgetTester tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('ko');
    tester.binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale('ko'),
    ];
    addTearDown(() {
      tester.binding.platformDispatcher.clearLocaleTestValue();
      tester.binding.platformDispatcher.clearLocalesTestValue();
    });

    await pumpAppWithSettings(
      tester,
      PracticeSettings(language: AppLanguage.system),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('\uC124\uC815'), findsWidgets);
    expect(find.text('\uBA54\uD2B8\uB85C\uB188'), findsWidgets);
  });

  testWidgets('traditional Chinese localization is selectable', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(language: AppLanguage.zh),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('\u8A2D\u5B9A'), findsWidgets);
    expect(find.text('\u7BC0\u62CD\u5668'), findsWidgets);
    expect(find.text('\u7BC0\u62CD\u5668\u97F3\u8272'), findsOneWidget);
  });
}
