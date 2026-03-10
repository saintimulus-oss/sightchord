import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
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

  test('loads new smart generation settings from storage', () async {
    SharedPreferences.setMockInitialValues({
      'language': 'zh',
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
    });
    final controller = AppSettingsController();

    await controller.load();

    expect(controller.settings.language, AppLanguage.zh);
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
  });

  test(
    'falls back to current settings when enum storage values are invalid',
    () async {
      SharedPreferences.setMockInitialValues({
        'language': 'invalid',
        'modulationIntensity': 'invalid',
        'jazzPreset': 'broken',
        'sourceProfile': 'unknown',
      });
      final controller = AppSettingsController(
        initialSettings: PracticeSettings(
          modulationIntensity: ModulationIntensity.medium,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.recordingInspired,
        ),
      );

      await controller.load();

      expect(controller.settings.language, AppLanguage.system);
      expect(
        controller.settings.modulationIntensity,
        ModulationIntensity.medium,
      );
      expect(controller.settings.jazzPreset, JazzPreset.modulationStudy);
      expect(
        controller.settings.sourceProfile,
        SourceProfile.recordingInspired,
      );
    },
  );
}
