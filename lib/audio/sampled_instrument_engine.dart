import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter/services.dart';

import 'sample_player_voice.dart';
import 'sample_player_voice_platform.dart';
import 'sampled_instrument_manifest.dart';

export 'audio_asset_path_utils.dart' show normalizeAssetPathForAudioPlayer;
export 'sample_player_voice.dart'
    show
        AudioPlayerBackend,
        AudioPlayerBackendFactory,
        SamplePlayerVoice,
        SamplePlayerVoiceFactory;
export 'sample_player_voice_native.dart'
    show AudioPlayerVoiceFactory, AudioplayersAudioPlayerBackend;

typedef InstrumentWarningLogger =
    void Function(String message, {Object? error, StackTrace? stackTrace});

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

class SampledInstrumentEngine {
  SampledInstrumentEngine({
    required this.bundle,
    SamplePlayerVoiceFactory? voiceFactory,
    InstrumentWarningLogger? logWarning,
  }) : _voiceFactory = voiceFactory ?? createDefaultSamplePlayerVoiceFactory(),
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
    final prepared = await _prepareNote(
      midiNote: midiNote,
      velocity: velocity,
      gain: gain,
    );
    if (prepared == null) {
      return null;
    }
    return _startPreparedNote(prepared);
  }

  Future<List<ActiveInstrumentNote>> noteOnBatch(
    Iterable<InstrumentNoteRequest> notes, {
    List<Duration>? startOffsets,
  }) async {
    final requestList = notes.toList(growable: false);
    if (requestList.isEmpty) {
      return const <ActiveInstrumentNote>[];
    }
    if (startOffsets != null && startOffsets.length != requestList.length) {
      throw ArgumentError.value(
        startOffsets,
        'startOffsets',
        'must match the number of requested notes',
      );
    }

    await prepare();
    if (_manifest == null) {
      return const <ActiveInstrumentNote>[];
    }

    final preparedNotes = <_PreparedInstrumentNoteWithOffset>[];
    for (var index = 0; index < requestList.length; index += 1) {
      final note = requestList[index];
      final prepared = await _prepareNote(
        midiNote: note.midiNote,
        velocity: note.velocity,
        gain: note.gain,
      );
      if (prepared != null) {
        preparedNotes.add(
          _PreparedInstrumentNoteWithOffset(
            prepared: prepared,
            startOffset: startOffsets?[index] ?? Duration.zero,
          ),
        );
      }
    }
    if (preparedNotes.isEmpty) {
      return const <ActiveInstrumentNote>[];
    }

    final startsAreSimultaneous = preparedNotes.every(
      (entry) => entry.startOffset <= Duration.zero,
    );
    final startedNotes = startsAreSimultaneous
        ? await Future.wait<ActiveInstrumentNote?>(
            preparedNotes.map((entry) => _startPreparedNote(entry.prepared)),
          )
        : await Future.wait<ActiveInstrumentNote?>(
            preparedNotes.map((entry) async {
              if (entry.startOffset > Duration.zero) {
                await Future<void>.delayed(entry.startOffset);
              }
              return _startPreparedNote(entry.prepared);
            }),
          );

    return startedNotes.whereType<ActiveInstrumentNote>().toList(
      growable: false,
    );
  }

  Future<_PreparedInstrumentNote?> _prepareNote({
    required int midiNote,
    required int velocity,
    required double gain,
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
      return _PreparedInstrumentNote(
        note: ActiveInstrumentNote(
          id: noteId,
          midiNote: resolved.resolvedMidi,
          velocity: resolved.velocity,
        ),
        slot: slot,
        volume: effectiveVolume,
      );
    } catch (error, stackTrace) {
      _logWarning(
        'Preparing instrument note-on failed for ${bundle.id}.',
        error: error,
        stackTrace: stackTrace,
      );
      await _releaseSlot(slot);
      return null;
    }
  }

  Future<ActiveInstrumentNote?> _startPreparedNote(
    _PreparedInstrumentNote prepared,
  ) async {
    try {
      await prepared.slot.voice.start(volume: prepared.volume);
      prepared.slot
        ..lastStartedAt = DateTime.now()
        ..activeNoteId = prepared.note.id;
      _activeNotes[prepared.note.id] = _ActiveVoiceLease(
        note: prepared.note,
        slot: prepared.slot,
      );
      return prepared.note;
    } catch (error, stackTrace) {
      _logWarning(
        'Starting instrument note-on failed for ${bundle.id}.',
        error: error,
        stackTrace: stackTrace,
      );
      await _releaseSlot(prepared.slot);
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
    final activeNotes = await noteOnBatch(notes);
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
    final preparedNotes = <_PreparedInstrumentNote>[];

    for (final note in notes) {
      final prepared = await _prepareNote(
        midiNote: note.midiNote,
        velocity: note.velocity,
        gain: note.gain,
      );
      if (prepared != null) {
        preparedNotes.add(prepared);
      }
    }

    for (final prepared in preparedNotes) {
      final active = await _startPreparedNote(prepared);
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
      name: 'chordest.audio',
      error: error,
      stackTrace: stackTrace,
    );
  }
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

class _PreparedInstrumentNote {
  const _PreparedInstrumentNote({
    required this.note,
    required this.slot,
    required this.volume,
  });

  final ActiveInstrumentNote note;
  final _VoiceSlot slot;
  final double volume;
}

class _PreparedInstrumentNoteWithOffset {
  const _PreparedInstrumentNoteWithOffset({
    required this.prepared,
    required this.startOffset,
  });

  final _PreparedInstrumentNote prepared;
  final Duration startOffset;
}
