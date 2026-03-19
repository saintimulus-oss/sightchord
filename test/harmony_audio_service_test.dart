import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/audio/harmony_audio_service.dart';
import 'package:chordest/audio/instrument_library_registry.dart';
import 'package:flutter_test/flutter_test.dart';

class _ConfigCaptureHarmonyAudioService extends HarmonyAudioService {
  _ConfigCaptureHarmonyAudioService() : super();

  HarmonyAudioConfig? lastAppliedConfig;

  @override
  Future<void> warmUp() async {}

  @override
  Future<void> applyConfig(HarmonyAudioConfig config) async {
    lastAppliedConfig = config;
  }
}

void main() {
  test(
    'applying a runtime profile without a new base config does not compound shaping',
    () async {
      final service = _ConfigCaptureHarmonyAudioService();
      const profile = HarmonyAudioRuntimeProfile(
        profileId: 'test-profile',
        instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
        preferredPattern: HarmonyPlaybackPattern.arpeggio,
        tuning: HarmonyAudioProfileTuning(
          masterVolumeScale: 0.9,
          previewHoldFactorScale: 1.15,
          arpeggioStepSpeedScale: 1.2,
        ),
      );
      const baseConfig = HarmonyAudioConfig(
        masterVolume: 0.8,
        previewHoldFactor: 1.0,
        arpeggioStepSpeed: 0.75,
      );

      await service.applyRuntimeProfile(profile, baseConfig: baseConfig);
      final firstApplied = service.lastAppliedConfig!;

      await service.applyRuntimeProfile(profile);
      final secondApplied = service.lastAppliedConfig!;

      expect(secondApplied.masterVolume, firstApplied.masterVolume);
      expect(secondApplied.previewHoldFactor, firstApplied.previewHoldFactor);
      expect(secondApplied.arpeggioStepSpeed, firstApplied.arpeggioStepSpeed);
    },
  );

  test('setMasterVolume preserves the active runtime profile shaping', () async {
    final service = _ConfigCaptureHarmonyAudioService();
    const profile = HarmonyAudioRuntimeProfile(
      profileId: 'test-profile',
      instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
      preferredPattern: HarmonyPlaybackPattern.block,
      tuning: HarmonyAudioProfileTuning(masterVolumeScale: 0.85),
    );

    await service.applyRuntimeProfile(
      profile,
      baseConfig: const HarmonyAudioConfig(masterVolume: 0.5),
    );
    await service.setMasterVolume(0.9);

    expect(service.lastAppliedConfig, isNotNull);
    expect(service.lastAppliedConfig!.masterVolume, closeTo(0.765, 0.0001));
  });
}
