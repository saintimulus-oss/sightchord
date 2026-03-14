import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

import '../settings/practice_settings.dart';
import 'scheduled_metronome.dart';

typedef MetronomeWarningLogger =
    void Function(String message, {Object? error, StackTrace? stackTrace});

class MetronomeSoundLoadResult {
  const MetronomeSoundLoadResult({this.preciseAssetReloaded = false});

  final bool preciseAssetReloaded;
}

class MetronomeAudioService {
  MetronomeAudioService({
    ScheduledMetronome? scheduledMetronome,
    MetronomeWarningLogger? logWarning,
  }) : _scheduledMetronome = scheduledMetronome ?? createScheduledMetronome(),
       _logWarning = logWarning ?? _defaultLogWarning;

  static const int _metronomePoolMinPlayers = 2;
  static const int _metronomePoolMaxPlayers = 4;

  final ScheduledMetronome _scheduledMetronome;
  final MetronomeWarningLogger _logWarning;

  AudioPool? _metronomePool;
  Future<MetronomeSoundLoadResult>? _loadFuture;
  bool _audioReady = false;

  bool get supportsPreciseScheduling =>
      _scheduledMetronome.supportsPreciseScheduling;

  bool get isReady => _audioReady;

  double? get currentTimeSeconds => _scheduledMetronome.currentTimeSeconds;

  Future<void> initialize(MetronomeSound sound) async {
    await queueSoundLoad(sound);
  }

  Future<MetronomeSoundLoadResult> queueSoundLoad(MetronomeSound sound) {
    final previousLoad = _loadFuture;
    final loadFuture = () async {
      if (previousLoad != null) {
        try {
          await previousLoad;
        } catch (error, stackTrace) {
          _logWarning(
            'Previous metronome initialization failed before the next load.',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
      return _loadSound(sound);
    }();
    _loadFuture = loadFuture;
    return loadFuture;
  }

  Future<MetronomeSoundLoadResult> _loadSound(MetronomeSound sound) async {
    final previousPool = _metronomePool;
    if (supportsPreciseScheduling) {
      try {
        await _scheduledMetronome.loadAsset('assets/${sound.assetFileName}');
        _metronomePool = null;
        _audioReady = _scheduledMetronome.isLoaded;
        await _disposePool(
          previousPool,
          failureMessage:
              'Disposing the previous metronome pool after switching to precise audio failed.',
        );
        return const MetronomeSoundLoadResult(preciseAssetReloaded: true);
      } catch (error, stackTrace) {
        _logWarning(
          'Precise metronome asset loading failed; restoring the previous audio path.',
          error: error,
          stackTrace: stackTrace,
        );
        _metronomePool = previousPool;
        _audioReady = _scheduledMetronome.isLoaded || _metronomePool != null;
        return const MetronomeSoundLoadResult();
      }
    }

    AudioPool? nextPool;
    try {
      // Use a small player pool for metronome clicks so rapid beats do not
      // contend with a single stop/resume cycle.
      nextPool = await AudioPool.createFromAsset(
        path: sound.assetFileName,
        minPlayers: _metronomePoolMinPlayers,
        maxPlayers: _metronomePoolMaxPlayers,
      );
      _metronomePool = nextPool;
      _audioReady = true;
      await _disposePool(
        previousPool,
        failureMessage:
            'Disposing the previous metronome pool after replacement failed.',
      );
    } catch (error, stackTrace) {
      _logWarning(
        'AudioPool metronome loading failed; restoring the previous pool.',
        error: error,
        stackTrace: stackTrace,
      );
      if (nextPool != null && !identical(nextPool, previousPool)) {
        await _disposePool(
          nextPool,
          failureMessage: 'Disposing a failed metronome pool also failed.',
        );
      }
      _metronomePool = previousPool;
      _audioReady = _metronomePool != null;
    }
    return const MetronomeSoundLoadResult();
  }

  Future<void> playNow({required double volume}) async {
    if (!_audioReady) {
      return;
    }
    if (supportsPreciseScheduling) {
      try {
        await _scheduledMetronome.playNow(volume: volume);
      } catch (error, stackTrace) {
        _logWarning(
          'Scheduled metronome playback failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return;
    }

    final pool = _metronomePool;
    if (pool == null) {
      return;
    }
    try {
      await pool.start(volume: volume);
    } catch (error, stackTrace) {
      _logWarning(
        'AudioPool metronome playback failed.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<bool> ensurePreciseReady() async {
    if (!supportsPreciseScheduling) {
      return false;
    }
    try {
      await _scheduledMetronome.ensureReady();
      return true;
    } catch (error, stackTrace) {
      _logWarning(
        'Scheduled metronome could not prepare in time for look-ahead playback.',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  void scheduleAt({required double whenSeconds, required double volume}) {
    _scheduledMetronome.scheduleAt(whenSeconds: whenSeconds, volume: volume);
  }

  void cancelScheduled() {
    _scheduledMetronome.cancelScheduled();
  }

  Future<void> dispose() async {
    final pendingLoad = _loadFuture;
    if (pendingLoad != null) {
      try {
        await pendingLoad;
      } catch (error, stackTrace) {
        _logWarning(
          'Metronome initialization was still pending during shutdown.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    final metronomePool = _metronomePool;
    _metronomePool = null;
    _audioReady = false;
    await _disposePool(
      metronomePool,
      failureMessage: 'Disposing the metronome pool during shutdown failed.',
    );
    try {
      await _scheduledMetronome.dispose();
    } catch (error, stackTrace) {
      _logWarning(
        'Disposing the scheduled metronome backend failed.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _disposePool(
    AudioPool? pool, {
    required String failureMessage,
  }) async {
    if (pool == null) {
      return;
    }
    try {
      await pool.dispose();
    } catch (error, stackTrace) {
      _logWarning(failureMessage, error: error, stackTrace: stackTrace);
    }
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
