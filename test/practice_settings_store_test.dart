import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/practice_settings_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('store saves ordered key-center and tension collections', () async {
    const store = PracticeSettingsStore();
    final settings = PracticeSettings(
      activeKeyCenters: {
        const KeyCenter(tonicName: 'G', mode: KeyMode.minor),
        const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        const KeyCenter(tonicName: 'A', mode: KeyMode.major),
        const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
      },
      selectedTensionOptions: {'b13', '9', '#11'},
    );

    await store.save(settings);

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
    expect(loaded.metronomeEnabled, isFalse);
    expect(loaded.metronomeSound, MetronomeSound.tickF);
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
}
