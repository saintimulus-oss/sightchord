import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

import 'audio_asset_path_utils.dart';
import 'sample_player_voice.dart';

class AudioplayersAudioPlayerBackend implements AudioPlayerBackend {
  AudioplayersAudioPlayerBackend() : _player = AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<void> setPlayerMode(PlayerMode mode) => _player.setPlayerMode(mode);

  @override
  Future<void> setReleaseMode(ReleaseMode mode) => _player.setReleaseMode(mode);

  @override
  Future<void> setSourceAsset(String path) => _player.setSourceAsset(path);

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setPlaybackRate(double playbackRate) =>
      _player.setPlaybackRate(playbackRate);

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> resume() => _player.resume();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();
}

AudioPlayerBackend _defaultAudioPlayerBackendFactory() =>
    AudioplayersAudioPlayerBackend();

class AudioPlayerVoiceFactory implements SamplePlayerVoiceFactory {
  const AudioPlayerVoiceFactory({AudioPlayerBackendFactory? backendFactory})
    : _backendFactory = backendFactory ?? _defaultAudioPlayerBackendFactory;

  final AudioPlayerBackendFactory _backendFactory;

  @override
  Future<SamplePlayerVoice> createVoice() async {
    final voice = _AudioPlayerVoice(player: _backendFactory());
    await voice.configure();
    return voice;
  }
}

class _AudioPlayerVoice implements SamplePlayerVoice {
  _AudioPlayerVoice({AudioPlayerBackend? player})
    : _player = player ?? AudioplayersAudioPlayerBackend();

  final AudioPlayerBackend _player;
  String? _currentAssetPath;
  double _currentPlaybackRate = 1.0;
  bool _playbackRateNeedsPriming = false;

  @override
  Future<void> configure() async {
    await _player.setPlayerMode(_preferredPlayerMode);
    await _player.setReleaseMode(ReleaseMode.stop);
  }

  @override
  Future<void> prepare({
    required String assetPath,
    required double playbackRate,
  }) async {
    if (_currentAssetPath != assetPath) {
      await _player.setSourceAsset(normalizeAssetPathForAudioPlayer(assetPath));
      _currentAssetPath = assetPath;
      _playbackRateNeedsPriming = playbackRate != 1.0;
    }
    if ((_currentPlaybackRate - playbackRate).abs() > 0.0001) {
      _currentPlaybackRate = playbackRate;
      _playbackRateNeedsPriming = true;
    }
    if (_playbackRateNeedsPriming) {
      // Apply rate changes before the audible start so piano attacks are not
      // muted while the backend catches up.
      await _rewindForReplay();
      await _player.setVolume(0.0);
      await _player.resume();
      await _player.setPlaybackRate(_currentPlaybackRate);
      await _player.stop();
      _playbackRateNeedsPriming = false;
    }
  }

  @override
  Future<void> start({required double volume}) async {
    await _rewindForReplay();
    await _player.setVolume(volume);
    await _player.resume();
  }

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();

  Future<void> _rewindForReplay() => _player.seek(Duration.zero);

  PlayerMode get _preferredPlayerMode {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android lowLatency mode does not reliably replay preloaded asset
      // sources with our persistent-player + ReleaseMode.stop setup, which
      // makes manual chord/arpeggio preview buttons go silent after reuse.
      return PlayerMode.mediaPlayer;
    }
    return PlayerMode.mediaPlayer;
  }
}
