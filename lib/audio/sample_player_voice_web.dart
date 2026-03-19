import 'dart:developer' as developer;
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import 'sample_player_voice.dart';

class WebAudioSamplePlayerVoiceFactory implements SamplePlayerVoiceFactory {
  const WebAudioSamplePlayerVoiceFactory();

  @override
  Future<SamplePlayerVoice> createVoice() async {
    final voice = _WebAudioSamplePlayerVoice();
    await voice.configure();
    return voice;
  }
}

class _WebAudioSamplePlayerVoice implements SamplePlayerVoice {
  static web.AudioContext? _sharedAudioContext;
  static int _liveVoiceCount = 0;
  static final Map<String, Future<web.AudioBuffer>> _decodedBuffers =
      <String, Future<web.AudioBuffer>>{};

  String? _currentAssetPath;
  web.AudioBuffer? _buffer;
  double _currentPlaybackRate = 1.0;
  _ActiveWebSamplePlayback? _activePlayback;

  @override
  Future<void> configure() async {
    _liveVoiceCount += 1;
    _sharedAudioContext ??= web.AudioContext();
  }

  @override
  Future<void> prepare({
    required String assetPath,
    required double playbackRate,
  }) async {
    _currentPlaybackRate = playbackRate;
    if (_currentAssetPath == assetPath && _buffer != null) {
      return;
    }
    _currentAssetPath = assetPath;
    _buffer = await _decodedBuffers.putIfAbsent(
      assetPath,
      () => _decodeAsset(assetPath),
    );
  }

  @override
  Future<void> start({required double volume}) async {
    final context = _sharedAudioContext;
    final buffer = _buffer;
    if (context == null || buffer == null) {
      throw StateError('The web sample voice must be prepared before start().');
    }
    await activateWebAudio();

    await stop();

    final source = context.createBufferSource();
    final gain = context.createGain();
    gain.gain.value = volume.clamp(0.0, 1.0).toDouble();
    source.buffer = buffer;
    source.playbackRate.value = _currentPlaybackRate;
    source.connect(gain);
    gain.connect(context.destination);
    source.start(0);

    _activePlayback = _ActiveWebSamplePlayback(source: source, gain: gain);
  }

  @override
  Future<void> setVolume(double volume) async {
    _activePlayback?.gain.gain.value = volume.clamp(0.0, 1.0).toDouble();
  }

  @override
  Future<void> stop() async {
    final activePlayback = _activePlayback;
    if (activePlayback == null) {
      return;
    }
    _activePlayback = null;
    activePlayback.stop();
    activePlayback.dispose();
  }

  @override
  Future<void> dispose() async {
    await stop();
    _liveVoiceCount -= 1;
    if (_liveVoiceCount > 0) {
      return;
    }

    final context = _sharedAudioContext;
    _sharedAudioContext = null;
    _decodedBuffers.clear();
    if (context != null) {
      await context.close().toDart;
    }
  }

  static Future<web.AudioBuffer> _decodeAsset(String assetPath) async {
    final context = _sharedAudioContext ??= web.AudioContext();
    final assetData = await rootBundle.load(assetPath);
    final tightBytes = Uint8List.fromList(
      assetData.buffer.asUint8List(
        assetData.offsetInBytes,
        assetData.lengthInBytes,
      ),
    );
    try {
      return await context.decodeAudioData(tightBytes.buffer.toJS).toDart;
    } catch (_) {
      _decodedBuffers.remove(assetPath);
      rethrow;
    }
  }
}

Future<void> activateWebAudio() async {
  var context = _WebAudioSamplePlayerVoice._sharedAudioContext;
  if (context == null || context.state == 'closed') {
    context = web.AudioContext();
    _WebAudioSamplePlayerVoice._sharedAudioContext = context;
  }
  if (context.state != 'running') {
    await context.resume().toDart;
  }
  if (context.state == 'running') {
    _playSilentUnlockPulse(context);
  }
}

void _playSilentUnlockPulse(web.AudioContext context) {
  try {
    final source = context.createBufferSource();
    final gain = context.createGain();
    final buffer = context.createBuffer(1, 1, context.sampleRate);
    gain.gain.value = 0;
    source.buffer = buffer;
    source.connect(gain);
    gain.connect(context.destination);
    source.start(0);
    source.addEventListener(
      'ended',
      ((web.Event _) {
        try {
          source.disconnect();
        } catch (_) {}
        try {
          gain.disconnect();
        } catch (_) {}
      }).toJS,
    );
  } catch (_) {
    // Best effort only. Some browsers do not need an explicit silent pulse.
  }
}

class _ActiveWebSamplePlayback {
  _ActiveWebSamplePlayback({required this.source, required this.gain});

  final web.AudioBufferSourceNode source;
  final web.GainNode gain;

  void stop() {
    try {
      source.stop();
    } catch (error, stackTrace) {
      developer.log(
        'Stopping a web harmony sample voice failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    try {
      source.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony sample source failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      gain.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony sample gain node failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
