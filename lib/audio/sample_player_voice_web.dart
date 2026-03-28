import 'dart:developer' as developer;
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'sample_player_voice.dart';
import 'web_synth_pitch.dart';

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

  String? _currentAssetPath;
  double? _currentFrequencyHz;
  _ActiveWebSynthPlayback? _activePlayback;

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
    if (_currentAssetPath == assetPath && _currentFrequencyHz != null) {
      return;
    }
    _currentAssetPath = assetPath;
    _currentFrequencyHz = resolveWebSynthFrequency(
      assetPath: assetPath,
      playbackRate: playbackRate,
    );
    if (_currentFrequencyHz == null) {
      throw StateError(
        'The web synth backend could not resolve a pitch for $assetPath.',
      );
    }
  }

  @override
  Future<void> start({required double volume}) async {
    final context = _sharedAudioContext;
    final frequencyHz = _currentFrequencyHz;
    if (context == null || frequencyHz == null) {
      throw StateError('The web sample voice must be prepared before start().');
    }
    await activateWebAudio();

    await stop();

    final clampedVolume = volume.clamp(0.0, 1.0).toDouble();
    final fundamentalGain = context.createGain();
    final overtoneGain = context.createGain();
    final fundamental = context.createOscillator();
    final overtone = context.createOscillator();

    fundamental.frequency.value = frequencyHz;
    overtone.frequency.value = frequencyHz * 2;
    fundamentalGain.gain.value = clampedVolume;
    overtoneGain.gain.value = clampedVolume * 0.32;

    fundamental.connect(fundamentalGain);
    overtone.connect(overtoneGain);
    overtoneGain.connect(fundamentalGain);
    fundamentalGain.connect(context.destination);

    fundamental.start(0);
    overtone.start(0);

    _activePlayback = _ActiveWebSynthPlayback(
      fundamental: fundamental,
      overtone: overtone,
      masterGain: fundamentalGain,
      overtoneGain: overtoneGain,
    );
  }

  @override
  Future<void> setVolume(double volume) async {
    final activePlayback = _activePlayback;
    if (activePlayback == null) {
      return;
    }
    final clampedVolume = volume.clamp(0.0, 1.0).toDouble();
    activePlayback.masterGain.gain.value = clampedVolume;
    activePlayback.overtoneGain.gain.value = clampedVolume * 0.32;
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
    if (context != null) {
      await context.close().toDart;
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

class _ActiveWebSynthPlayback {
  _ActiveWebSynthPlayback({
    required this.fundamental,
    required this.overtone,
    required this.masterGain,
    required this.overtoneGain,
  });

  final web.OscillatorNode fundamental;
  final web.OscillatorNode overtone;
  final web.GainNode masterGain;
  final web.GainNode overtoneGain;

  void stop() {
    try {
      fundamental.stop();
    } catch (error, stackTrace) {
      developer.log(
        'Stopping a web harmony synth voice failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      overtone.stop();
    } catch (error, stackTrace) {
      developer.log(
        'Stopping a web harmony synth overtone failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    try {
      fundamental.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony synth oscillator failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      overtone.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony synth overtone failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      masterGain.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony sample gain node failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      overtoneGain.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a web harmony synth overtone gain failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
