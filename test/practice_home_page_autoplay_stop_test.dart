import 'package:chordest/audio/chordest_audio_scope.dart';
import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/audio/harmony_audio_service.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/practice_home_page.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StopAwareHarmonyAudioService extends HarmonyAudioService {
  _StopAwareHarmonyAudioService() : super();

  int stopAllCallCount = 0;

  @override
  Future<void> warmUp() async {}

  @override
  Future<void> activate() async {}

  @override
  Future<void> applyConfig(HarmonyAudioConfig config) async {}

  @override
  Future<void> stopAll() async {
    stopAllCallCount += 1;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'stopping autoplay immediately stops active harmony preview playback',
    (WidgetTester tester) async {
      final audio = _StopAwareHarmonyAudioService();
      final controller = AppSettingsController(
        initialSettings: PracticeSettings(
          bpm: 240,
          autoPlayChordChanges: true,
          metronomeEnabled: false,
        ).copyWith(
          guidedSetupCompleted: true,
          settingsComplexityMode: SettingsComplexityMode.standard,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChordestAudioScope(
            harmonyAudio: audio,
            child: MyHomePage(
              title: 'Chordest',
              controller: controller,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
      await tester.pump();

      expect(audio.stopAllCallCount, 0);

      await tester.tap(find.byKey(const ValueKey('practice-autoplay-button')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(audio.stopAllCallCount, 1);
    },
  );
}
