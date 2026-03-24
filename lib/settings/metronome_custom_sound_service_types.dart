import '../audio/metronome_audio_models.dart';

enum MetronomeCustomSoundSlot { primary, accent }

class MetronomeCustomSoundSelection {
  const MetronomeCustomSoundSelection({
    required this.source,
    required this.fileName,
  });

  final MetronomeSourceSpec source;
  final String fileName;
}

abstract class MetronomeCustomSoundService {
  bool get isSupported;

  Future<MetronomeCustomSoundSelection?> pickAndStore({
    required MetronomeCustomSoundSlot slot,
    required MetronomeSound fallbackSound,
  });

  Future<void> clearSlot({required MetronomeCustomSoundSlot slot});
}
