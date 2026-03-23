import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/notation_presentation.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/settings/inversion_settings.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_store.dart';
import 'package:chordest/settings/settings_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('load and update notify listeners once per call', () async {
    final controller = AppSettingsController();
    var notifications = 0;
    controller.addListener(() {
      notifications += 1;
    });

    await controller.load();
    expect(notifications, 1);

    await controller.update(
      controller.settings.copyWith(appThemeMode: AppThemeMode.dark),
    );
    expect(notifications, 2);
  });

  test('in-flight load does not overwrite a newer update', () async {
    final loadCompleter = Completer<PracticeSettings>();
    final store = _DelayedPracticeSettingsStore(loadCompleter);
    final controller = AppSettingsController(
      initialSettings: PracticeSettings(appThemeMode: AppThemeMode.light),
      store: store,
    );

    final loadFuture = controller.load();
    await controller.update(
      controller.settings.copyWith(appThemeMode: AppThemeMode.dark),
    );
    loadCompleter.complete(PracticeSettings(appThemeMode: AppThemeMode.system));
    await loadFuture;

    expect(controller.settings.appThemeMode, AppThemeMode.dark);
  });

  test('no-op update skips listeners and persistence', () async {
    final fixture = const _PracticeSettingsFixture().value;
    final store = _CountingPracticeSettingsStore(loadedSettings: fixture);
    final controller = AppSettingsController(
      initialSettings: fixture,
      store: store,
    );
    var notifications = 0;
    controller.addListener(() {
      notifications += 1;
    });

    await controller.update(fixture);

    expect(notifications, 0);
    expect(store.saveCount, 0);
  });

  test('serializes rapid saves using the update snapshot', () async {
    final controller = AppSettingsController(
      initialSettings: PracticeSettings(activeKeys: const {'C'}),
    );

    final firstUpdate = controller.update(
      controller.settings.copyWith(
        activeKeys: const {'C', 'G'},
        allowTensions: true,
        modulationIntensity: ModulationIntensity.medium,
        jazzPreset: JazzPreset.modulationStudy,
      ),
    );
    final secondUpdate = controller.update(
      controller.settings.copyWith(
        activeKeys: const {'D'},
        appThemeMode: AppThemeMode.dark,
        guidedSetupCompleted: true,
        settingsComplexityMode: SettingsComplexityMode.advanced,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        musicNotationLocale: MusicNotationLocale.english,
        noteNamingStyle: NoteNamingStyle.latin,
        showRomanNumeralAssist: true,
        showChordTextAssist: true,
        allowTensions: false,
        sourceProfile: SourceProfile.recordingInspired,
        smartDiagnosticsEnabled: true,
        voicingSuggestionsEnabled: true,
        voicingComplexity: VoicingComplexity.modern,
        voicingTopNotePreference: VoicingTopNotePreference.e,
        allowRootlessVoicings: false,
        maxVoicingNotes: 5,
        lookAheadDepth: 2,
        showVoicingReasons: false,
      ),
    );

    await Future.wait([firstUpdate, secondUpdate]);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('activeKeys'), ['D']);
    expect(preferences.getString('appThemeMode'), 'dark');
    expect(preferences.getBool('guidedSetupCompleted'), isTrue);
    expect(preferences.getString('settingsComplexityMode'), 'advanced');
    expect(preferences.getString('preferredSuggestionKind'), 'easy');
    expect(preferences.getString('chordLanguageLevel'), 'safeExtensions');
    expect(preferences.getString('romanPoolPreset'), 'functionalJazz');
    expect(preferences.getString('musicNotationLocale'), 'english');
    expect(preferences.getString('noteNamingStyle'), 'latin');
    expect(preferences.getBool('showRomanNumeralAssist'), isTrue);
    expect(preferences.getBool('showChordTextAssist'), isTrue);
    expect(preferences.getBool('allowTensions'), isFalse);
    expect(preferences.getString('modulationIntensity'), 'medium');
    expect(preferences.getString('jazzPreset'), 'modulationStudy');
    expect(preferences.getString('sourceProfile'), 'recordingInspired');
    expect(preferences.getBool('smartDiagnosticsEnabled'), isTrue);
    expect(preferences.getBool('voicingSuggestionsEnabled'), isTrue);
    expect(preferences.getString('voicingComplexity'), 'modern');
    expect(preferences.getString('voicingTopNotePreference'), 'e');
    expect(preferences.getBool('allowRootlessVoicings'), isFalse);
    expect(preferences.getInt('maxVoicingNotes'), 5);
    expect(preferences.getInt('lookAheadDepth'), 2);
    expect(preferences.getBool('showVoicingReasons'), isFalse);
  });

  test('persists ordered settings collections deterministically', () async {
    final controller = AppSettingsController();

    await controller.update(
      controller.settings.copyWith(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'G', mode: KeyMode.minor),
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
          const KeyCenter(tonicName: 'A', mode: KeyMode.major),
          const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
        },
        selectedTensionOptions: {'b13', '9', '#11'},
      ),
    );

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('activeKeys'), ['C', 'D', 'G', 'A']);
    expect(preferences.getStringList('activeKeyCenters'), [
      'C|major',
      'A|major',
      'D|minor',
      'G|minor',
    ]);
    expect(preferences.getStringList('selectedTensions'), ['9', '#11', 'b13']);
  });

  test('loads new smart generation settings from storage', () async {
    SharedPreferences.setMockInitialValues({
      'language': 'zh',
      'appThemeMode': 'light',
      'guidedSetupCompleted': true,
      'settingsComplexityMode': 'standard',
      'preferredSuggestionKind': 'colorful',
      'chordLanguageLevel': 'seventhChords',
      'romanPoolPreset': 'coreDiatonic',
      'musicNotationLocale': 'english',
      'noteNamingStyle': 'latin',
      'showRomanNumeralAssist': true,
      'showChordTextAssist': true,
      'activeKeyCenters': ['A|minor', 'C|major'],
      'modulationIntensity': 'high',
      'jazzPreset': 'advanced',
      'sourceProfile': 'recordingInspired',
      'smartDiagnosticsEnabled': true,
      'voicingSuggestionsEnabled': false,
      'voicingComplexity': 'basic',
      'voicingTopNotePreference': 'bb',
      'allowRootlessVoicings': false,
      'maxVoicingNotes': 3,
      'lookAheadDepth': 2,
      'showVoicingReasons': false,
      'melodyGenerationEnabled': true,
      'melodyDensity': 'active',
      'motifRepetitionStrength': 0.7,
      'approachToneDensity': 0.6,
      'melodyRangeLow': 58,
      'melodyRangeHigh': 82,
      'melodyStyle': 'colorful',
      'allowChromaticApproaches': true,
      'melodyPlaybackMode': 'both',
      'keyCenterLabelStyle': 'classicalCase',
    });
    final controller = AppSettingsController();

    await controller.load();

    expect(controller.settings.language, AppLanguage.zh);
    expect(controller.settings.appThemeMode, AppThemeMode.light);
    expect(controller.settings.guidedSetupCompleted, isTrue);
    expect(
      controller.settings.settingsComplexityMode,
      SettingsComplexityMode.standard,
    );
    expect(
      controller.settings.preferredSuggestionKind,
      DefaultVoicingSuggestionKind.colorful,
    );
    expect(
      controller.settings.chordLanguageLevel,
      ChordLanguageLevel.seventhChords,
    );
    expect(controller.settings.romanPoolPreset, RomanPoolPreset.coreDiatonic);
    expect(
      controller.settings.musicNotationLocale,
      MusicNotationLocale.english,
    );
    expect(controller.settings.noteNamingStyle, NoteNamingStyle.latin);
    expect(controller.settings.showRomanNumeralAssist, isTrue);
    expect(controller.settings.showChordTextAssist, isTrue);
    expect(
      controller.settings.activeKeyCenters,
      contains(const KeyCenter(tonicName: 'A', mode: KeyMode.minor)),
    );
    expect(
      controller.settings.activeKeyCenters,
      contains(const KeyCenter(tonicName: 'C', mode: KeyMode.major)),
    );
    expect(controller.settings.modulationIntensity, ModulationIntensity.high);
    expect(controller.settings.jazzPreset, JazzPreset.advanced);
    expect(controller.settings.sourceProfile, SourceProfile.recordingInspired);
    expect(controller.settings.smartDiagnosticsEnabled, isTrue);
    expect(controller.settings.voicingSuggestionsEnabled, isFalse);
    expect(controller.settings.voicingComplexity, VoicingComplexity.basic);
    expect(
      controller.settings.voicingTopNotePreference,
      VoicingTopNotePreference.bb,
    );
    expect(controller.settings.allowRootlessVoicings, isFalse);
    expect(controller.settings.maxVoicingNotes, 3);
    expect(controller.settings.lookAheadDepth, 2);
    expect(controller.settings.showVoicingReasons, isFalse);
    expect(controller.settings.melodyGenerationEnabled, isTrue);
    expect(controller.settings.melodyDensity, MelodyDensity.active);
    expect(controller.settings.motifRepetitionStrength, 0.7);
    expect(controller.settings.approachToneDensity, 0.6);
    expect(controller.settings.melodyRangeLow, 58);
    expect(controller.settings.melodyRangeHigh, 82);
    expect(controller.settings.melodyStyle, MelodyStyle.colorful);
    expect(controller.settings.allowChromaticApproaches, isTrue);
    expect(controller.settings.melodyPlaybackMode, MelodyPlaybackMode.both);
    expect(
      controller.settings.keyCenterLabelStyle,
      KeyCenterLabelStyle.classicalCase,
    );
  });

  test(
    'falls back to current settings when enum storage values are invalid',
    () async {
      SharedPreferences.setMockInitialValues({
        'language': 'invalid',
        'appThemeMode': 'invalid',
        'modulationIntensity': 'invalid',
        'jazzPreset': 'broken',
        'sourceProfile': 'unknown',
        'musicNotationLocale': 'invalid',
        'noteNamingStyle': 'invalid',
        'selectedTensions': ['bogus'],
      });
      final controller = AppSettingsController(
        initialSettings: PracticeSettings(
          modulationIntensity: ModulationIntensity.medium,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
          musicNotationLocale: MusicNotationLocale.english,
          noteNamingStyle: NoteNamingStyle.latin,
          selectedTensionOptions: {'9', '13'},
        ),
      );

      await controller.load();

      expect(controller.settings.language, AppLanguage.system);
      expect(controller.settings.appThemeMode, AppThemeMode.system);
      expect(
        controller.settings.modulationIntensity,
        ModulationIntensity.medium,
      );
      expect(controller.settings.jazzPreset, JazzPreset.modulationStudy);
      expect(
        controller.settings.sourceProfile,
        SourceProfile.recordingInspired,
      );
      expect(
        controller.settings.musicNotationLocale,
        MusicNotationLocale.english,
      );
      expect(controller.settings.noteNamingStyle, NoteNamingStyle.latin);
      expect(controller.settings.selectedTensionOptions, {'9', '13'});
    },
  );
}

class _DelayedPracticeSettingsStore extends PracticeSettingsStore {
  _DelayedPracticeSettingsStore(this._loadCompleter);

  final Completer<PracticeSettings> _loadCompleter;

  @override
  Future<PracticeSettings> load({required PracticeSettings fallbackSettings}) {
    return _loadCompleter.future;
  }

  @override
  Future<void> save(PracticeSettings settings) async {}
}

class _CountingPracticeSettingsStore extends PracticeSettingsStore {
  _CountingPracticeSettingsStore({required this.loadedSettings});

  final PracticeSettings loadedSettings;
  int loadCount = 0;
  int saveCount = 0;

  @override
  Future<PracticeSettings> load({
    required PracticeSettings fallbackSettings,
  }) async {
    loadCount += 1;
    return loadedSettings;
  }

  @override
  Future<void> save(PracticeSettings settings) async {
    saveCount += 1;
  }
}

class _PracticeSettingsFixture {
  const _PracticeSettingsFixture();

  PracticeSettings get value => PracticeSettings(
    language: AppLanguage.ko,
    appThemeMode: AppThemeMode.dark,
    guidedSetupCompleted: true,
    settingsComplexityMode: SettingsComplexityMode.advanced,
    preferredSuggestionKind: DefaultVoicingSuggestionKind.colorful,
    chordLanguageLevel: ChordLanguageLevel.safeExtensions,
    romanPoolPreset: RomanPoolPreset.functionalJazz,
    musicNotationLocale: MusicNotationLocale.english,
    noteNamingStyle: NoteNamingStyle.latin,
    showRomanNumeralAssist: true,
    showChordTextAssist: true,
    activeKeyCenters: {
      const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
    },
    allowTensions: true,
    selectedTensionOptions: {'9', '#11'},
    enabledChordQualities: {ChordQuality.majorTriad, ChordQuality.minor7},
    inversionSettings: const InversionSettings(
      enabled: true,
      firstInversionEnabled: true,
      secondInversionEnabled: false,
      thirdInversionEnabled: false,
    ),
    progressionHighlightTheme: ProgressionHighlightTheme(
      preset: ProgressionHighlightThemePreset.custom,
      colorValues: {ProgressionHighlightCategory.modulation: 0xFF112233},
    ),
  );
}
