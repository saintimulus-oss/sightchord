import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/app.dart';
import 'package:sightchord/l10n/app_localizations.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/voicing_models.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';
import 'package:sightchord/widgets/mini_keyboard.dart';
import 'package:sightchord/widgets/voicing_suggestions_section.dart';

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
    reasonTags: reasonTags,
    locked: locked,
  );
}

Future<void> pumpVoicingSection(
  WidgetTester tester, {
  required VoicingRecommendationSet recommendations,
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

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpMainMenuWithSettings(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    await tester.pumpWidget(
      MyApp(controller: AppSettingsController(initialSettings: settings)),
    );
    await tester.pumpAndSettle();
  }

  Future<AppSettingsController> pumpMainMenuWithController(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    final controller = AppSettingsController(initialSettings: settings);
    await tester.pumpWidget(MyApp(controller: controller));
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

  Future<void> openMainMenuSettings(WidgetTester tester) async {
    await tester.ensureVisible(
      find.byKey(const ValueKey('main-open-settings-button')),
    );
    await tester.tap(find.byKey(const ValueKey('main-open-settings-button')));
    await tester.pumpAndSettle();
  }

  Future<void> pumpAppWithSettings(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    await pumpMainMenuWithSettings(tester, settings);
    await openChordGenerator(tester);
  }

  Future<AppSettingsController> pumpAppWithController(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    final controller = await pumpMainMenuWithController(tester, settings);
    await openChordGenerator(tester);
    return controller;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await pumpAppWithSettings(tester, PracticeSettings());
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
    for (final kind in const ['natural', 'colorful', 'easy']) {
      if (find
          .byKey(ValueKey('voicing-$badge-badge-$kind'))
          .evaluate()
          .isNotEmpty) {
        return kind;
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
  });

  testWidgets('main menu settings only allow changing language', (
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
      find.byKey(const ValueKey('metronome-sound-selector')),
      findsNothing,
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

    expect(find.text('SightChord'), findsOneWidget);
    expect(find.byKey(const ValueKey('current-chord-text')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('allow-v7sus4-chip')), findsOneWidget);
    expect(
      tester
          .widget<FilterChip>(find.byKey(const ValueKey('allow-v7sus4-chip')))
          .onSelected,
      isNull,
    );
    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsNothing);
    expect(find.byKey(const ValueKey('tension-chip-9')), findsNothing);
    expect(
      find.byKey(const ValueKey('modal-interchange-chip')),
      findsOneWidget,
    );
  });

  testWidgets('shows tension controls when key mode is active', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(activeKeys: const {'C'}),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<FilterChip>(find.byKey(const ValueKey('allow-v7sus4-chip')))
          .onSelected,
      isNotNull,
    );
    expect(find.byKey(const ValueKey('allow-tensions-toggle')), findsOneWidget);
    expect(find.byKey(const ValueKey('tension-chip-9')), findsOneWidget);
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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    final status = tester
        .widget<Text>(find.byKey(const ValueKey('current-status-label')))
        .data!;
    expect(status, contains('A minor:'));
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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

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

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

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

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Advanced Smart Generator'), findsOneWidget);
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

      await tester.tap(find.byKey(const ValueKey('smart-diagnostics-toggle')));
      await tester.pumpAndSettle();

      expect(controller.settings.modulationIntensity, ModulationIntensity.high);
      expect(controller.settings.smartDiagnosticsEnabled, isTrue);
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

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
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

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
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
    expect(
      find.byKey(const ValueKey('voicing-tone-slot-colorful-4')),
      findsOneWidget,
    );
    expect(voicingNotesFor(tester, 'easy'), 'E B E');
    expect(voicingNotesFor(tester, 'colorful'), 'B F# B E G');
    expect(voicingToneLabelsFor(tester, 'easy'), '13 3 13');
    expect(voicingToneLabelsFor(tester, 'colorful'), '3 7 3 13 #9');
  });

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

    expect(find.text('Modern quartal color'), findsOneWidget);
    expect(find.text('Quartal color'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stable repeat copy appears on repeat-friendly cards', (
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
          voicing: naturalVoicing,
          reasonTags: const [
            VoicingReasonTag.stableRepeat,
            VoicingReasonTag.gentleMotion,
          ],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.colorful,
          voicing: colorfulVoicing,
          reasonTags: const [VoicingReasonTag.upperStructureColor],
        ),
        buildTestSuggestion(
          kind: VoicingSuggestionKind.easy,
          voicing: naturalVoicing,
          reasonTags: const [
            VoicingReasonTag.stableRepeat,
            VoicingReasonTag.compactReach,
          ],
        ),
      ],
    );

    await pumpVoicingSection(tester, recommendations: recommendations);

    expect(find.text('Same shape, steady comping'), findsOneWidget);
    expect(find.text('Repeat-friendly hand shape'), findsOneWidget);
    expect(find.text('Stable repeat'), findsWidgets);
    expect(tester.takeException(), isNull);
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

  testWidgets('voicing suggestions section can be hidden from settings', (
    WidgetTester tester,
  ) async {
    await pumpAppWithSettings(
      tester,
      PracticeSettings(voicingSuggestionsEnabled: false),
    );

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('voicing-suggestions-section')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-natural')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-colorful')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
      findsOneWidget,
    );
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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-lock-natural')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('voicing-lock-natural')));
    await tester.pumpAndSettle();

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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-lock-natural')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('voicing-lock-natural')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
    );
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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    final beforeToggle = voicingNotesFor(tester, 'natural');

    await tester.ensureVisible(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('voicing-suggestion-card-easy')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('voicing-selected-badge-easy')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('show-voicing-reasons-toggle')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('show-voicing-reasons-toggle')));
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

    await tester.tap(find.text('Next Chord'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('voicing-suggestions-section')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
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

    expect(find.text('\uC124\uC815'), findsOneWidget);
    expect(find.text('\uBA54\uD2B8\uB85C\uB188'), findsWidgets);
    expect(find.text('\uBA54\uD2B8\uB85C\uB188 \uC18C\uB9AC'), findsOneWidget);
    expect(find.text('\uC870\uC131 \uD45C\uAE30 \uBC29\uC2DD'), findsOneWidget);

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
    expect(find.text('\uC0DD\uC131\uAE30 \uC5F4\uAE30'), findsOneWidget);
    expect(find.text('\uCF54\uB4DC \uBD84\uC11D\uAE30'), findsOneWidget);
    expect(find.text('\uBD84\uC11D\uAE30 \uC5F4\uAE30'), findsOneWidget);
    expect(find.text('Open Generator'), findsNothing);
    expect(find.text('Open Analyzer'), findsNothing);

    await openChordAnalyzer(tester);
    await tester.tap(find.byKey(const ValueKey('analyzer-input-field')));
    await tester.pumpAndSettle();

    expect(find.text('\uCF54\uB4DC \uC9C4\uD589'), findsOneWidget);
    expect(find.text('\uBD84\uC11D'), findsWidgets);
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

    expect(find.text('\uC124\uC815'), findsOneWidget);
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

    expect(find.text('\u8A2D\u5B9A'), findsOneWidget);
    expect(find.text('\u7BC0\u62CD\u5668'), findsWidgets);
    expect(find.text('\u7BC0\u62CD\u5668\u97F3\u8272'), findsOneWidget);
  });
}
