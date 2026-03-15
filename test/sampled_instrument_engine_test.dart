import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/audio/sampled_instrument_engine.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  group('normalizeAssetPathForAudioPlayer', () {
    test('strips the flutter assets prefix for audioplayers asset loading', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'assets/piano/salamander_essential/samples/C4v10.flac',
        ),
        'piano/salamander_essential/samples/C4v10.flac',
      );
    });

    test('leaves already relative asset paths unchanged', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'piano/salamander_essential/samples/C4v10.flac',
        ),
        'piano/salamander_essential/samples/C4v10.flac',
      );
    });

    test('does not alter package asset paths', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'packages/chordest/audio/piano/C4v10.flac',
        ),
        'packages/chordest/audio/piano/C4v10.flac',
      );
    });
  });

  group('AudioPlayerVoiceFactory', () {
    test('applies playback rate only after playback has started', () async {
      final backend = _FakeAudioPlayerBackend();
      final voice = await AudioPlayerVoiceFactory(
        backendFactory: () => backend,
      ).createVoice();

      await voice.prepare(
        assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
        playbackRate: 0.5,
      );

      expect(backend.calls, <String>[
        'setPlayerMode:PlayerMode.mediaPlayer',
        'setReleaseMode:ReleaseMode.stop',
        'setSourceAsset:piano/salamander_essential/samples/C4v10.flac',
      ]);

      await voice.start(volume: 0.72);

      expect(backend.calls, <String>[
        'setPlayerMode:PlayerMode.mediaPlayer',
        'setReleaseMode:ReleaseMode.stop',
        'setSourceAsset:piano/salamander_essential/samples/C4v10.flac',
        'setVolume:0.0',
        'resume',
        'setPlaybackRate:0.5',
        'setVolume:0.72',
      ]);
    });

    test('reuses the current playback rate when nothing changed', () async {
      final backend = _FakeAudioPlayerBackend();
      final voice = await AudioPlayerVoiceFactory(
        backendFactory: () => backend,
      ).createVoice();

      await voice.prepare(
        assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
        playbackRate: 0.5,
      );
      await voice.start(volume: 0.72);

      backend.calls.clear();

      await voice.prepare(
        assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
        playbackRate: 0.5,
      );
      await voice.start(volume: 0.64);

      expect(backend.calls, <String>['setVolume:0.64', 'resume']);
    });
  });
}

class _FakeAudioPlayerBackend implements AudioPlayerBackend {
  final List<String> calls = <String>[];

  @override
  Future<void> dispose() async {
    calls.add('dispose');
  }

  @override
  Future<void> resume() async {
    calls.add('resume');
  }

  @override
  Future<void> setPlaybackRate(double playbackRate) async {
    calls.add('setPlaybackRate:$playbackRate');
  }

  @override
  Future<void> setPlayerMode(PlayerMode mode) async {
    calls.add('setPlayerMode:$mode');
  }

  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {
    calls.add('setReleaseMode:$mode');
  }

  @override
  Future<void> setSourceAsset(String path) async {
    calls.add('setSourceAsset:$path');
  }

  @override
  Future<void> setVolume(double volume) async {
    calls.add('setVolume:$volume');
  }

  @override
  Future<void> stop() async {
    calls.add('stop');
  }
}
