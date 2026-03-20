import 'metronome_audio_models.dart';

class MetronomeSoundLoadResult {
  const MetronomeSoundLoadResult({this.preciseAssetReloaded = false});

  final bool preciseAssetReloaded;
}

abstract class MetronomeAudioBackend {
  bool get supportsPreciseScheduling;
  bool get isReady;
  double? get currentTimeSeconds;

  Future<MetronomeSoundLoadResult> queueSoundLoad(MetronomeSound sound);

  Future<MetronomeSoundLoadResult> queueSourceLoad({
    required MetronomeSourceSpec primarySource,
    required MetronomeSourceSpec accentSource,
    required bool useAccentSource,
  });

  Future<void> playNow({required double volume});

  Future<void> playBeat(MetronomeBeatState state, {required double volume});

  Future<bool> ensurePreciseReady();

  void scheduleAt({required double whenSeconds, required double volume});

  void scheduleBeatAt(
    MetronomeBeatState state, {
    required double whenSeconds,
    required double volume,
  });

  void cancelScheduled();

  Future<void> dispose();
}
