import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

import 'metronome_audio_models.dart';
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

  static const double _accentGainMultiplier = 1.28;
  static const int _fallbackPoolPlayers = 4;

  final ScheduledMetronome _scheduledMetronome;
  final MetronomeWarningLogger _logWarning;

  _MetronomeClipPool? _primaryPool;
  _MetronomeClipPool? _accentPool;
  _MetronomeRuntimeSource _primarySource = _MetronomeRuntimeSource.builtIn(
    MetronomeSound.tick,
  );
  _MetronomeRuntimeSource _accentSource = _MetronomeRuntimeSource.builtIn(
    MetronomeSound.tickF,
  );
  Future<MetronomeSoundLoadResult>? _loadFuture;
  bool _audioReady = false;
  bool _useAccentSource = false;

  bool get supportsPreciseScheduling =>
      _scheduledMetronome.supportsPreciseScheduling;

  bool get isReady => _audioReady;

  double? get currentTimeSeconds => _scheduledMetronome.currentTimeSeconds;

  Future<void> initialize(MetronomeSound sound) async {
    await queueSoundLoad(sound);
  }

  Future<MetronomeSoundLoadResult> queueSoundLoad(MetronomeSound sound) {
    return queueSourceLoad(
      primarySource: MetronomeSourceSpec.builtIn(sound: sound),
      accentSource: const MetronomeSourceSpec.builtIn(
        sound: MetronomeSound.tickF,
      ),
      useAccentSource: false,
    );
  }

  Future<MetronomeSoundLoadResult> queueSourceLoad({
    required MetronomeSourceSpec primarySource,
    required MetronomeSourceSpec accentSource,
    required bool useAccentSource,
  }) {
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
      return _loadSources(
        primarySource: primarySource,
        accentSource: accentSource,
        useAccentSource: useAccentSource,
      );
    }();
    _loadFuture = loadFuture;
    return loadFuture;
  }

  Future<MetronomeSoundLoadResult> _loadSources({
    required MetronomeSourceSpec primarySource,
    required MetronomeSourceSpec accentSource,
    required bool useAccentSource,
  }) async {
    _primarySource = _MetronomeRuntimeSource.fromSpec(
      primarySource,
      preciseScheduling: supportsPreciseScheduling,
    );
    _accentSource = _MetronomeRuntimeSource.fromSpec(
      accentSource,
      preciseScheduling: supportsPreciseScheduling,
    );
    _useAccentSource = useAccentSource;

    if (supportsPreciseScheduling) {
      return _loadPreciseSources();
    }
    return _loadFallbackPools();
  }

  Future<MetronomeSoundLoadResult> _loadPreciseSources() async {
    final previousPrimaryPool = _primaryPool;
    final previousAccentPool = _accentPool;
    try {
      await _scheduledMetronome.loadAsset(
        _primarySource.assetPath,
        soundId: _MetronomeClipRole.primary.soundId,
      );
      if (_useAccentSource) {
        await _scheduledMetronome.loadAsset(
          _accentSource.assetPath,
          soundId: _MetronomeClipRole.accent.soundId,
        );
      }
      _primaryPool = null;
      _accentPool = null;
      _audioReady = _scheduledMetronome.isLoaded;
      await _disposePool(previousPrimaryPool);
      await _disposePool(previousAccentPool);
      return const MetronomeSoundLoadResult(preciseAssetReloaded: true);
    } catch (error, stackTrace) {
      _logWarning(
        'Precise metronome asset loading failed; restoring the previous audio path.',
        error: error,
        stackTrace: stackTrace,
      );
      _primaryPool = previousPrimaryPool;
      _accentPool = previousAccentPool;
      _audioReady = _scheduledMetronome.isLoaded || _primaryPool != null;
      return const MetronomeSoundLoadResult();
    }
  }

  Future<MetronomeSoundLoadResult> _loadFallbackPools() async {
    final previousPrimaryPool = _primaryPool;
    final previousAccentPool = _accentPool;
    try {
      final nextPrimaryPool = await _MetronomeClipPool.create(
        _primarySource,
        playerCount: _fallbackPoolPlayers,
      );
      _MetronomeClipPool? nextAccentPool;
      if (_useAccentSource) {
        nextAccentPool = await _MetronomeClipPool.create(
          _accentSource,
          playerCount: _fallbackPoolPlayers,
        );
      }
      _primaryPool = nextPrimaryPool;
      _accentPool = nextAccentPool;
      _audioReady = true;
      await _disposePool(previousPrimaryPool);
      await _disposePool(previousAccentPool);
    } catch (error, stackTrace) {
      _logWarning(
        'Fallback metronome loading failed; restoring the previous audio path.',
        error: error,
        stackTrace: stackTrace,
      );
      _primaryPool = previousPrimaryPool;
      _accentPool = previousAccentPool;
      _audioReady = _primaryPool != null;
    }
    return const MetronomeSoundLoadResult();
  }

  Future<void> playNow({required double volume}) async {
    await playBeat(MetronomeBeatState.normal, volume: volume);
  }

  Future<void> playBeat(
    MetronomeBeatState state, {
    required double volume,
  }) async {
    if (!_audioReady || state == MetronomeBeatState.mute) {
      return;
    }
    final role = _roleForState(state);
    final resolvedVolume = _volumeForState(state, volume);
    if (supportsPreciseScheduling) {
      try {
        await _scheduledMetronome.playNow(
          volume: resolvedVolume,
          soundId: role.soundId,
        );
      } catch (error, stackTrace) {
        _logWarning(
          'Scheduled metronome playback failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
      return;
    }
    await _playFromPool(role, resolvedVolume);
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
    scheduleBeatAt(
      MetronomeBeatState.normal,
      whenSeconds: whenSeconds,
      volume: volume,
    );
  }

  void scheduleBeatAt(
    MetronomeBeatState state, {
    required double whenSeconds,
    required double volume,
  }) {
    if (state == MetronomeBeatState.mute || !_audioReady) {
      return;
    }
    _scheduledMetronome.scheduleAt(
      whenSeconds: whenSeconds,
      volume: _volumeForState(state, volume),
      soundId: _roleForState(state).soundId,
    );
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

    final primaryPool = _primaryPool;
    final accentPool = _accentPool;
    _primaryPool = null;
    _accentPool = null;
    _audioReady = false;
    await _disposePool(primaryPool);
    await _disposePool(accentPool);
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

  _MetronomeClipRole _roleForState(MetronomeBeatState state) {
    if (state == MetronomeBeatState.accent && _useAccentSource) {
      return _MetronomeClipRole.accent;
    }
    return _MetronomeClipRole.primary;
  }

  double _volumeForState(MetronomeBeatState state, double baseVolume) {
    final volume = state == MetronomeBeatState.accent && !_useAccentSource
        ? baseVolume * _accentGainMultiplier
        : baseVolume;
    return volume.clamp(0.0, 1.0).toDouble();
  }

  Future<void> _playFromPool(_MetronomeClipRole role, double volume) async {
    final pool = role == _MetronomeClipRole.accent ? _accentPool : _primaryPool;
    if (pool == null) {
      return;
    }
    try {
      await pool.play(volume: volume);
    } catch (error, stackTrace) {
      if (!pool.source.usesLocalFile) {
        _logWarning(
          'Metronome pool playback failed.',
          error: error,
          stackTrace: stackTrace,
        );
        return;
      }
      await _fallbackLocalFilePool(role, volume, error, stackTrace);
    }
  }

  Future<void> _fallbackLocalFilePool(
    _MetronomeClipRole role,
    double volume,
    Object error,
    StackTrace stackTrace,
  ) async {
    final fallbackSource =
        (role == _MetronomeClipRole.accent ? _accentSource : _primarySource)
            .builtInFallback();
    _logWarning(
      'Local-file metronome playback failed; falling back to the built-in sound.',
      error: error,
      stackTrace: stackTrace,
    );
    final replacement = await _MetronomeClipPool.create(
      fallbackSource,
      playerCount: _fallbackPoolPlayers,
    );
    if (role == _MetronomeClipRole.accent) {
      final previous = _accentPool;
      _accentPool = replacement;
      _accentSource = fallbackSource;
      await _disposePool(previous);
      await replacement.play(volume: volume);
      return;
    }
    final previous = _primaryPool;
    _primaryPool = replacement;
    _primarySource = fallbackSource;
    await _disposePool(previous);
    await replacement.play(volume: volume);
  }

  Future<void> _disposePool(_MetronomeClipPool? pool) async {
    if (pool == null) {
      return;
    }
    try {
      await pool.dispose();
    } catch (error, stackTrace) {
      _logWarning(
        'Disposing the metronome pool failed.',
        error: error,
        stackTrace: stackTrace,
      );
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

enum _MetronomeClipRole {
  primary('primary'),
  accent('accent');

  const _MetronomeClipRole(this.soundId);

  final String soundId;
}

class _MetronomeRuntimeSource {
  const _MetronomeRuntimeSource._({
    required this.kind,
    required this.builtInSound,
    this.localFilePath,
  });

  const _MetronomeRuntimeSource.builtIn(MetronomeSound sound)
    : this._(kind: MetronomeSourceKind.builtInAsset, builtInSound: sound);

  factory _MetronomeRuntimeSource.fromSpec(
    MetronomeSourceSpec spec, {
    required bool preciseScheduling,
  }) {
    if (preciseScheduling ||
        spec.kind == MetronomeSourceKind.builtInAsset ||
        !spec.hasLocalFilePath) {
      return _MetronomeRuntimeSource.builtIn(spec.builtInSound);
    }
    return _MetronomeRuntimeSource._(
      kind: MetronomeSourceKind.localFile,
      builtInSound: spec.builtInSound,
      localFilePath: spec.trimmedLocalFilePath,
    );
  }

  final MetronomeSourceKind kind;
  final MetronomeSound builtInSound;
  final String? localFilePath;

  bool get usesLocalFile =>
      kind == MetronomeSourceKind.localFile &&
      (localFilePath?.isNotEmpty ?? false);

  String get assetPath => 'assets/${builtInSound.assetFileName}';

  Source toAudioSource() {
    if (usesLocalFile && localFilePath != null) {
      return DeviceFileSource(localFilePath!);
    }
    return AssetSource(builtInSound.assetFileName);
  }

  _MetronomeRuntimeSource builtInFallback() {
    return _MetronomeRuntimeSource.builtIn(builtInSound);
  }
}

class _MetronomeClipPool {
  _MetronomeClipPool({required this.source, required List<AudioPlayer> players})
    : _players = players;

  final _MetronomeRuntimeSource source;
  final List<AudioPlayer> _players;
  int _nextPlayerIndex = 0;

  static Future<_MetronomeClipPool> create(
    _MetronomeRuntimeSource source, {
    required int playerCount,
  }) async {
    final players = <AudioPlayer>[];
    for (var index = 0; index < playerCount; index += 1) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      players.add(player);
    }
    return _MetronomeClipPool(source: source, players: players);
  }

  Future<void> play({required double volume}) async {
    if (_players.isEmpty) {
      return;
    }
    final player = _players[_nextPlayerIndex];
    _nextPlayerIndex = (_nextPlayerIndex + 1) % _players.length;
    await player.play(source.toAudioSource(), volume: volume);
  }

  Future<void> dispose() async {
    for (final player in _players) {
      await player.dispose();
    }
  }
}
