import 'metronome_custom_sound_service_types.dart';
import '../audio/metronome_audio_models.dart';

MetronomeCustomSoundService createMetronomeCustomSoundService() {
  return const _UnsupportedMetronomeCustomSoundService();
}

class _UnsupportedMetronomeCustomSoundService
    implements MetronomeCustomSoundService {
  const _UnsupportedMetronomeCustomSoundService();

  @override
  bool get isSupported => false;

  @override
  Future<void> clearSlot({required MetronomeCustomSoundSlot slot}) async {}

  @override
  Future<MetronomeCustomSoundSelection?> pickAndStore({
    required MetronomeCustomSoundSlot slot,
    required MetronomeSound fallbackSound,
  }) async {
    return null;
  }
}
