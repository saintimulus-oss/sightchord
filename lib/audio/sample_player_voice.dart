import 'package:audioplayers/audioplayers.dart';

abstract class SamplePlayerVoiceFactory {
  Future<SamplePlayerVoice> createVoice();
}

abstract class SamplePlayerVoice {
  Future<void> configure();

  Future<void> prepare({
    required String assetPath,
    required double playbackRate,
  });

  Future<void> start({required double volume});

  Future<void> setVolume(double volume);

  Future<void> stop();

  Future<void> dispose();
}

typedef AudioPlayerBackendFactory = AudioPlayerBackend Function();

abstract class AudioPlayerBackend {
  Future<void> setPlayerMode(PlayerMode mode);

  Future<void> setReleaseMode(ReleaseMode mode);

  Future<void> setSourceAsset(String path);

  Future<void> seek(Duration position);

  Future<void> setPlaybackRate(double playbackRate);

  Future<void> setVolume(double volume);

  Future<void> resume();

  Future<void> stop();

  Future<void> dispose();
}
