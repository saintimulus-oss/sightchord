import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';

void main() {
  test(
    'falls back and clamps new voicing settings from invalid storage',
    () async {
      SharedPreferences.setMockInitialValues({
        'voicingComplexity': 'invalid',
        'voicingTopNotePreference': 'invalid',
        'maxVoicingNotes': 9,
        'lookAheadDepth': -4,
      });

      final controller = AppSettingsController(
        initialSettings: PracticeSettings(
          voicingComplexity: VoicingComplexity.modern,
          voicingTopNotePreference: VoicingTopNotePreference.g,
        ),
      );

      await controller.load();

      expect(controller.settings.voicingComplexity, VoicingComplexity.modern);
      expect(
        controller.settings.voicingTopNotePreference,
        VoicingTopNotePreference.auto,
      );
      expect(controller.settings.maxVoicingNotes, 5);
      expect(controller.settings.lookAheadDepth, 0);
    },
  );

  test('clamps metronome volume and bpm from invalid storage', () async {
    SharedPreferences.setMockInitialValues({
      'metronomeVolume': 1.8,
      'bpm': -15,
    });

    final controller = AppSettingsController();

    await controller.load();

    expect(
      controller.settings.metronomeVolume,
      PracticeSettings.maxMetronomeVolume,
    );
    expect(controller.settings.bpm, PracticeSettings.minBpm);
  });
}
