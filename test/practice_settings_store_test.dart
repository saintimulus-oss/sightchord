import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'store saves ordered key-center, chord-quality, and tension collections',
    () async {
      const store = PracticeSettingsStore();
      final settings = PracticeSettings(
        appThemeMode: AppThemeMode.dark,
        guidedSetupCompleted: true,
        settingsComplexityMode: SettingsComplexityMode.standard,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.colorful,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        activeKeyCenters: {
          const KeyCenter(tonicName: 'G', mode: KeyMode.minor),
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
          const KeyCenter(tonicName: 'A', mode: KeyMode.major),
          const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
        },
        enabledChordQualities: {
          ChordQuality.dominant7sus4,
          ChordQuality.major7,
          ChordQuality.minorTriad,
          ChordQuality.dominant13sus4,
        },
        selectedTensionOptions: {'b13', '9', '#11'},
      );

      await store.save(settings);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('appThemeMode'), 'dark');
      expect(preferences.getBool('guidedSetupCompleted'), isTrue);
      expect(preferences.getString('settingsComplexityMode'), 'standard');
      expect(preferences.getString('preferredSuggestionKind'), 'colorful');
      expect(preferences.getString('chordLanguageLevel'), 'safeExtensions');
      expect(preferences.getString('romanPoolPreset'), 'functionalJazz');
      expect(preferences.getStringList('activeKeys'), ['C', 'D', 'G', 'A']);
      expect(preferences.getStringList('activeKeyCenters'), [
        'C|major',
        'A|major',
        'D|minor',
        'G|minor',
      ]);
      expect(preferences.getStringList('enabledChordQualities'), [
        'minorTriad',
        'major7',
        'dominant13sus4',
        'dominant7sus4',
      ]);
      expect(preferences.getStringList('selectedTensions'), [
        '9',
        '#11',
        'b13',
      ]);
    },
  );

  test(
    'store falls back to current supported tensions on invalid storage',
    () async {
      SharedPreferences.setMockInitialValues({
        'selectedTensions': ['bogus'],
      });
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(
        selectedTensionOptions: {'9', '13'},
      );

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.selectedTensionOptions, {'9', '13'});
    },
  );

  test('store keeps fallback settings when storage keys are missing', () async {
    SharedPreferences.setMockInitialValues({'metronomeEnabled': false});
    const store = PracticeSettingsStore();
    final fallbackSettings = PracticeSettings(
      language: AppLanguage.ko,
      appThemeMode: AppThemeMode.light,
      guidedSetupCompleted: true,
      settingsComplexityMode: SettingsComplexityMode.advanced,
      preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      chordLanguageLevel: ChordLanguageLevel.triadsOnly,
      romanPoolPreset: RomanPoolPreset.corePrimary,
      metronomeSound: MetronomeSound.tickF,
      activeKeyCenters: {
        const KeyCenter(tonicName: 'F', mode: KeyMode.major),
        const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
      },
      selectedTensionOptions: {'9', '#11'},
      voicingTopNotePreference: VoicingTopNotePreference.bb,
    );

    final loaded = await store.load(fallbackSettings: fallbackSettings);

    expect(loaded.language, AppLanguage.ko);
    expect(loaded.appThemeMode, AppThemeMode.light);
    expect(loaded.metronomeEnabled, isFalse);
    expect(loaded.metronomeSound, MetronomeSound.tickF);
    expect(loaded.guidedSetupCompleted, isTrue);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.advanced);
    expect(loaded.preferredSuggestionKind, DefaultVoicingSuggestionKind.easy);
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.triadsOnly);
    expect(loaded.romanPoolPreset, RomanPoolPreset.corePrimary);
    expect(loaded.activeKeyCenters, fallbackSettings.activeKeyCenters);
    expect(loaded.selectedTensionOptions, {'9', '#11'});
    expect(loaded.voicingTopNotePreference, VoicingTopNotePreference.bb);
  });

  test(
    'store maps legacy activeKeys when activeKeyCenters are absent',
    () async {
      SharedPreferences.setMockInitialValues({
        'activeKeys': ['G', 'A', 'invalid-key'],
      });
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        },
      );

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.activeKeyCenters, {
        const KeyCenter(tonicName: 'G', mode: KeyMode.major),
        const KeyCenter(tonicName: 'A', mode: KeyMode.major),
      });
    },
  );

  test(
    'store derives sus chord filters from legacy allowV7sus4 when chord types are missing',
    () async {
      SharedPreferences.setMockInitialValues({'allowV7sus4': false});
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(allowV7sus4: true);

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.allowV7sus4, isFalse);
      expect(
        loaded.enabledChordQualities.any(
          MusicTheory.susDominantQualities.contains,
        ),
        isFalse,
      );
    },
  );

  test('store treats legacy saved settings as existing users', () async {
    SharedPreferences.setMockInitialValues({'metronomeEnabled': false});
    const store = PracticeSettingsStore();

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(loaded.guidedSetupCompleted, isTrue);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.standard);
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.fullExtensions);
    expect(loaded.romanPoolPreset, RomanPoolPreset.expandedColor);
  });

  test('store keeps onboarding incomplete on a clean install', () async {
    const store = PracticeSettingsStore();

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(loaded.guidedSetupCompleted, isFalse);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.guided);
    expect(
      loaded.preferredSuggestionKind,
      DefaultVoicingSuggestionKind.natural,
    );
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.fullExtensions);
    expect(loaded.romanPoolPreset, RomanPoolPreset.expandedColor);
  });
}
