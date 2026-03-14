import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'sampled_instrument_manifest.dart';

typedef InstrumentWarningLogger =
    void Function(String message, {Object? error, StackTrace? stackTrace});

String normalizeAssetPathForAudioPlayer(String assetPath) {
  const assetsPrefix = 'assets/';
  return assetPath.startsWith(assetsPrefix)
      ? assetPath.substring(assetsPrefix.length)
      : assetPath;
}

class SampledInstrumentAssetBundle {
  const SampledInstrumentAssetBundle({
    required this.id,
    required this.manifestAssetPath,
    required this.assetRootPath,
  });

  final String id;
  final String manifestAssetPath;
  final String assetRootPath;
}

class ActiveInstrumentNote {
  const ActiveInstrumentNote({
    required this.id,
    required this.midiNote,
    required this.velocity,
  });

  final int id;
  final int midiNote;
  final int velocity;
}

class InstrumentNoteRequest {
  const InstrumentNoteRequest({
    required this.midiNote,
    this.velocity = 88,
    this.gain = 1.0,
    this.toneLabel,
  });

  final int midiNote;
  final int velocity;
  final double gain;
  final String? toneLabel;
}

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

class AudioPlayerVoiceFactory implements SamplePlayerVoiceFactory {
  const AudioPlayerVoiceFactory();

  @override
  Future<SamplePlayerVoice> createVoice() async {
    final voice = _AudioPlayerVoice();
    await voice.configure();
    return voice;
  }
}

class SampledInstrumentEngine {
  SampledInstrumentEngine({
    required this.bundle,
    SamplePlayerVoiceFactory? voiceFactory,
    InstrumentWarningLogger? logWarning,
  }) : _voiceFactory = voiceFactory ?? const AudioPlayerVoiceFactory(),
       _logWarning = logWarning ?? _defaultLogWarning;

  final SampledInstrumentAssetBundle bundle;
  final SamplePlayerVoiceFactory _voiceFactory;
  final InstrumentWarningLogger _logWarning;

  SampledInstrumentManifest? _manifest;
  bool _prepared = false;
  double _masterVolume = 1.0;
  int _nextNoteId = 1;
  final List<_VoiceSlot> _voicePool = <_VoiceSlot>[];
  final Queue<_VoiceSlot> _idleVoices = Queue<_VoiceSlot>();
  final Map<int, _ActiveVoiceLease> _activeNotes = <int, _ActiveVoiceLease>{};
  Future<void>? _prepareFuture;

  SampledInstrumentManifest? get manifest => _manifest;
  bool get isPrepared => _prepared;
  double get masterVolume => _masterVolume;

  Future<void> prepare() {
    final existing = _prepareFuture;
    if (existing != null) {
      return existing;
    }
    final future = _prepareInternal();
    _prepareFuture = future;
    return future;
  }

  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
  }

  Future<ActiveInstrumentNote?> noteOn({
    required int midiNote,
    int velocity = 88,
    double gain = 1.0,
  }) async {
    await prepare();
    final manifest = _manifest;
    if (manifest == null) {
      return null;
    }
    final resolved = manifest.resolveRegion(
      midiNote: midiNote,
      velocity: velocity,
    );
    if (resolved == null) {
      return null;
    }

    final slot = await _acquireVoiceSlot();
    final noteId = _nextNoteId++;
    final effectiveVolume =
        (manifest.defaults.baseVolume *
                _masterVolume *
                gain *
                _velocityGain(velocity, manifest.defaults.velocityCurvePower))
            .clamp(0.0, 1.0);

    final assetPath =
        '${bundle.assetRootPath}/${resolved.region.sampleAssetPath}'.replaceAll(
          '//',
          '/',
        );

    try {
      await slot.voice.prepare(
        assetPath: assetPath,
        playbackRate: resolved.playbackRate,
      );
      await slot.voice.start(volume: effectiveVolume);
      slot
        ..lastStartedAt = DateTime.now()
        ..activeNoteId = noteId;

      final note = ActiveInstrumentNote(
        id: noteId,
        midiNote: resolved.resolvedMidi,
        velocity: resolved.velocity,
      );
      _activeNotes[noteId] = _ActiveVoiceLease(note: note, slot: slot);
      return note;
    } catch (error, stackTrace) {
      _logWarning(
        'Instrument note-on failed for ${bundle.id}.',
        error: error,
        stackTrace: stackTrace,
      );
      await _releaseSlot(slot);
      return null;
    }
  }

  Future<void> noteOff(ActiveInstrumentNote note, {Duration? fadeOut}) async {
    final lease = _activeNotes.remove(note.id);
    if (lease == null) {
      return;
    }

    final manifest = _manifest;
    final fadeDuration =
        fadeOut ??
        Duration(milliseconds: manifest?.defaults.releaseFadeOutMs ?? 90);
    await _fadeOutAndRelease(lease.slot, fadeDuration);
  }

  Future<void> playChord(
    Iterable<InstrumentNoteRequest> notes, {
    Duration? hold,
  }) async {
    await prepare();
    final manifest = _manifest;
    if (manifest == null) {
      return;
    }
    final activeNotes = <ActiveInstrumentNote>[];
    for (final note in notes) {
      final active = await noteOn(
        midiNote: note.midiNote,
        velocity: note.velocity,
        gain: note.gain,
      );
      if (active != null) {
        activeNotes.add(active);
      }
    }
    await Future<void>.delayed(
      hold ?? Duration(milliseconds: manifest.defaults.defaultChordHoldMs),
    );
    for (final active in activeNotes) {
      await noteOff(active);
    }
  }

  Future<void> playArpeggio(
    Iterable<InstrumentNoteRequest> notes, {
    Duration? step,
    Duration? hold,
  }) async {
    await prepare();
    final manifest = _manifest;
    if (manifest == null) {
      return;
    }
    final activeNotes = <ActiveInstrumentNote>[];
    final effectiveStep =
        step ?? Duration(milliseconds: manifest.defaults.defaultArpeggioStepMs);
    final effectiveHold =
        hold ?? Duration(milliseconds: manifest.defaults.defaultArpeggioHoldMs);

    for (final note in notes) {
      final active = await noteOn(
        midiNote: note.midiNote,
        velocity: note.velocity,
        gain: note.gain,
      );
      if (active != null) {
        activeNotes.add(active);
      }
      await Future<void>.delayed(effectiveStep);
    }

    await Future<void>.delayed(effectiveHold);
    for (final active in activeNotes) {
      await noteOff(active);
    }
  }

  Future<void> stopAll() async {
    final leases = _activeNotes.values.toList(growable: false);
    _activeNotes.clear();
    for (final lease in leases) {
      try {
        await lease.slot.voice.stop();
      } catch (error, stackTrace) {
        _logWarning(
          'Stopping an active instrument voice failed.',
          error: error,
          stackTrace: stackTrace,
        );
      } finally {
        lease.slot.activeNoteId = null;
        if (!_idleVoices.contains(lease.slot)) {
          _idleVoices.add(lease.slot);
        }
      }
    }
  }

  Future<void> dispose() async {
    final pendingPrepare = _prepareFuture;
    if (pendingPrepare != null) {
      try {
        await pendingPrepare;
      } catch (_) {
        // Keep shutdown resilient.
      }
    }
    await stopAll();
    for (final slot in _voicePool) {
      try {
        await slot.voice.dispose();
      } catch (error, stackTrace) {
        _logWarning(
          'Disposing an instrument voice failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    _voicePool.clear();
    _idleVoices.clear();
    _prepared = false;
    _prepareFuture = null;
  }

  Future<void> _prepareInternal() async {
    try {
      final manifestSource = await rootBundle.loadString(
        bundle.manifestAssetPath,
      );
      _manifest = SampledInstrumentManifest.fromJsonString(manifestSource);
      final prewarmCount = _manifest!.defaults.noteOnPrerollVoices;
      for (var index = 0; index < prewarmCount; index += 1) {
        final slot = await _createVoiceSlot();
        _voicePool.add(slot);
        _idleVoices.add(slot);
      }
      _prepared = true;
    } catch (error, stackTrace) {
      _prepared = false;
      _prepareFuture = null;
      _logWarning(
        'Preparing sampled instrument ${bundle.id} failed.',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<_VoiceSlot> _createVoiceSlot() async {
    return _VoiceSlot(voice: await _voiceFactory.createVoice());
  }

  Future<_VoiceSlot> _acquireVoiceSlot() async {
    final manifest = _manifest;
    if (manifest == null) {
      throw StateError('The sampled instrument manifest has not been loaded.');
    }
    if (_idleVoices.isNotEmpty) {
      return _idleVoices.removeFirst();
    }
    if (_voicePool.length < manifest.defaults.polyphony) {
      final slot = await _createVoiceSlot();
      _voicePool.add(slot);
      return slot;
    }

    _voicePool.sort(
      (left, right) => left.lastStartedAt.compareTo(right.lastStartedAt),
    );
    final stolen = _voicePool.first;
    final activeNoteId = stolen.activeNoteId;
    if (activeNoteId != null) {
      _activeNotes.remove(activeNoteId);
    }
    await stolen.voice.stop();
    stolen.activeNoteId = null;
    return stolen;
  }

  Future<void> _fadeOutAndRelease(
    _VoiceSlot slot,
    Duration fadeDuration,
  ) async {
    try {
      if (fadeDuration > Duration.zero) {
        const steps = 4;
        final stepDelay = Duration(
          milliseconds: (fadeDuration.inMilliseconds / steps).round(),
        );
        for (var step = steps - 1; step >= 0; step -= 1) {
          await slot.voice.setVolume(step / steps);
          await Future<void>.delayed(stepDelay);
        }
      }
      await slot.voice.stop();
    } catch (error, stackTrace) {
      _logWarning(
        'Fading out an instrument voice failed.',
        error: error,
        stackTrace: stackTrace,
      );
      try {
        await slot.voice.stop();
      } catch (_) {}
    } finally {
      await _releaseSlot(slot);
    }
  }

  Future<void> _releaseSlot(_VoiceSlot slot) async {
    slot.activeNoteId = null;
    try {
      await slot.voice.setVolume(1.0);
    } catch (_) {}
    if (!_idleVoices.contains(slot)) {
      _idleVoices.add(slot);
    }
  }

  static double _velocityGain(int velocity, double power) {
    final normalized = (velocity.clamp(1, 127) - 1) / 126.0;
    return normalized <= 0
        ? 0.2
        : math.pow(normalized.clamp(0.0, 1.0).toDouble(), power) as double;
  }

  static void _defaultLogWarning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'sightchord.audio',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class _AudioPlayerVoice implements SamplePlayerVoice {
  _AudioPlayerVoice() : _player = AudioPlayer();

  final AudioPlayer _player;
  String? _currentAssetPath;
  double _currentPlaybackRate = 1.0;

  @override
  Future<void> configure() async {
    await _player.setPlayerMode(PlayerMode.mediaPlayer);
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
    }
    if ((_currentPlaybackRate - playbackRate).abs() > 0.0001) {
      await _player.setPlaybackRate(playbackRate);
      _currentPlaybackRate = playbackRate;
    }
  }

  @override
  Future<void> start({required double volume}) async {
    await _player.setVolume(volume);
    await _player.resume();
  }

  @override
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> dispose() => _player.dispose();
}

class _VoiceSlot {
  _VoiceSlot({required this.voice});

  final SamplePlayerVoice voice;
  int? activeNoteId;
  DateTime lastStartedAt = DateTime.fromMillisecondsSinceEpoch(0);
}

class _ActiveVoiceLease {
  const _ActiveVoiceLease({required this.note, required this.slot});

  final ActiveInstrumentNote note;
  final _VoiceSlot slot;
}
