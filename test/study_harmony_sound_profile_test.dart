import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_track_profiles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test(
    'track-aware sound selection falls back to neutral in practice and follows active track in study sessions',
    () {
      final neutralProfile = trackSoundProfileForSelection(
        l10n,
        selection: HarmonySoundProfileSelection.trackAware,
      );
      final jazzProfile = trackSoundProfileForSelection(
        l10n,
        selection: HarmonySoundProfileSelection.trackAware,
        activeTrackId: studyHarmonyJazzTrackId,
      );

      expect(neutralProfile.profileId, 'core-balanced-piano');
      expect(
        neutralProfile.runtimeProfile.preferredPattern,
        HarmonyPlaybackPattern.block,
      );
      expect(jazzProfile.profileId, 'jazz-dry-warm');
      expect(
        jazzProfile.runtimeProfile.preferredPattern,
        HarmonyPlaybackPattern.arpeggio,
      );
    },
  );

  test('track sound profiles shape base playback config differently', () {
    final baseSettings = PracticeSettings(
      harmonyMasterVolume: 0.8,
      harmonyPreviewHoldFactor: 1.0,
      harmonyArpeggioStepSpeed: 1.0,
      harmonyVelocityHumanization: 0.0,
      harmonyGainRandomness: 0.0,
      harmonyTimingHumanization: 0.0,
    );
    final baseConfig = harmonyAudioBaseConfigForSettings(baseSettings);
    final popProfile = trackSoundProfileForTrack(l10n, studyHarmonyPopTrackId);
    final jazzProfile = trackSoundProfileForTrack(
      l10n,
      studyHarmonyJazzTrackId,
    );
    final classicalProfile = trackSoundProfileForTrack(
      l10n,
      studyHarmonyClassicalTrackId,
    );

    final popConfig = popProfile.runtimeProfile.resolveConfig(baseConfig);
    final jazzConfig = jazzProfile.runtimeProfile.resolveConfig(baseConfig);
    final classicalConfig = classicalProfile.runtimeProfile.resolveConfig(
      baseConfig,
    );

    expect(
      popConfig.previewHoldFactor,
      greaterThan(baseConfig.previewHoldFactor),
    );
    expect(
      jazzConfig.previewHoldFactor,
      lessThan(baseConfig.previewHoldFactor),
    );
    expect(
      jazzConfig.arpeggioStepSpeed,
      greaterThan(classicalConfig.arpeggioStepSpeed),
    );
    expect(popConfig.velocityHumanization, greaterThan(0));
    expect(jazzConfig.gainRandomness, greaterThan(popConfig.gainRandomness));
    expect(
      classicalConfig.timingHumanization,
      lessThan(jazzConfig.timingHumanization),
    );
  });
}
