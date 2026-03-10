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

  Future<void> pumpAppWithSettings(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    await tester.pumpWidget(
      MyApp(controller: AppSettingsController(initialSettings: settings)),
    );
    await tester.pumpAndSettle();
  }

  Future<AppSettingsController> pumpAppWithController(
    WidgetTester tester,
    PracticeSettings settings,
  ) async {
    final controller = AppSettingsController(initialSettings: settings);
    await tester.pumpWidget(MyApp(controller: controller));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await pumpAppWithSettings(tester, PracticeSettings());
  }

  String voicingNotesFor(WidgetTester tester, String kind) {
    return tester
        .widget<Text>(find.byKey(ValueKey('voicing-notes-$kind')))
        .data!;
  }

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

      expect(find.text('Target top note: E'), findsOneWidget);
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

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('메트로놈'), findsWidgets);
    expect(find.text('메트로놈 사운드'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('metronome-sound-selector')));
    await tester.pumpAndSettle();

    expect(find.text('클래식'), findsWidgets);
    expect(find.text('클릭 B'), findsWidgets);
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

    expect(find.text('설정'), findsOneWidget);
    expect(find.text('메트로놈'), findsWidgets);
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

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('節拍器'), findsWidgets);
    expect(find.text('節拍器音色'), findsOneWidget);
  });
}
