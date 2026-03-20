import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../audio/beat_clock.dart';
import '../audio/metronome_audio_backend.dart';
import '../audio/metronome_audio_service.dart';
import '../settings/practice_settings.dart';
import '../settings/practice_settings_effects.dart';
import 'practice_transport_state.dart';

typedef PracticeTransportAdvanceCallback = void Function();
typedef PracticeTransportTimerFactory =
    PracticeTransportTimerHandle Function(
      Duration delay,
      void Function() callback,
    );
typedef PracticeTransportPeriodicTimerFactory =
    PracticeTransportTimerHandle Function(
      Duration interval,
      void Function() callback,
    );
typedef PracticeTransportStopwatchFactory =
    PracticeTransportStopwatch Function();

@visibleForTesting
({int nextBeat, bool shouldAdvanceChord}) computeNextPracticeAutoBeat({
  required int? currentBeat,
  int beatCount = 4,
  int nextChangeBeat = 0,
}) {
  final nextBeat = ((currentBeat ?? -1) + 1) % beatCount;
  return (
    nextBeat: nextBeat,
    shouldAdvanceChord: currentBeat != null && nextBeat == nextChangeBeat,
  );
}

@visibleForTesting
bool shouldStartPracticeAutoplayImmediately(int? currentBeat) {
  return currentBeat == null;
}

class PracticeTransportController extends ChangeNotifier {
  PracticeTransportController({
    MetronomeAudioBackend? audioBackend,
    MetronomeWarningLogger? logWarning,
    PracticeTransportTimerFactory? timerFactory,
    PracticeTransportPeriodicTimerFactory? periodicTimerFactory,
    PracticeTransportStopwatchFactory? stopwatchFactory,
  }) : _audioBackend =
           audioBackend ?? MetronomeAudioService(logWarning: logWarning),
       _timerFactory = timerFactory ?? _defaultTimerFactory,
       _periodicTimerFactory =
           periodicTimerFactory ?? _defaultPeriodicTimerFactory,
       _stopwatchFactory = stopwatchFactory ?? _defaultStopwatchFactory;

  static const Duration _scheduledMetronomeLookAhead = Duration(
    milliseconds: 180,
  );
  static const Duration _scheduledMetronomePollInterval = Duration(
    milliseconds: 25,
  );

  final MetronomeAudioBackend _audioBackend;
  final PracticeTransportTimerFactory _timerFactory;
  final PracticeTransportPeriodicTimerFactory _periodicTimerFactory;
  final PracticeTransportStopwatchFactory _stopwatchFactory;

  PracticeTransportState _state = const PracticeTransportState();
  _PracticeTransportBindings? _bindings;
  PracticeTransportAdvanceCallback? _onAdvanceChord;
  PracticeTransportTimerHandle? _autoTimer;
  PracticeTransportTimerHandle? _scheduledMetronomeTimer;
  PracticeTransportStopwatch? _autoStopwatch;
  BeatClock? _autoBeatClock;
  double? _scheduledMetronomeBaseTimeSeconds;
  int _nextScheduledMetronomeSequence = 0;
  int _scheduledMetronomeBeatSeed = 0;
  int _loopGeneration = 0;
  int _loadGeneration = 0;
  bool _notifyScheduled = false;
  bool _disposed = false;
  Future<void>? _shutdownFuture;

  @visibleForTesting
  Duration? debugLastScheduledAutoDelay;

  PracticeTransportState get state => _state;

  void bind({
    required PracticeSettings settings,
    required int bpm,
    required int nextChangeBeat,
    required PracticeTransportAdvanceCallback onAdvanceChord,
  }) {
    _bindings = _PracticeTransportBindings(
      settings: settings,
      bpm: bpm,
      nextChangeBeat: nextChangeBeat,
    );
    _onAdvanceChord = onAdvanceChord;
  }

  Future<void> initializeAudio() async {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    await _queueMetronomeAudioLoad(bindings.settings);
  }

  Future<void> handleSettingsChanged({
    required PracticeSettings previousSettings,
  }) async {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    _setCurrentBeat(
      _normalizeBeatForSettings(bindings.settings, _state.currentBeat),
    );
    if (bindings.settings.metronomeSource != previousSettings.metronomeSource ||
        bindings.settings.metronomeAccentSource !=
            previousSettings.metronomeAccentSource ||
        bindings.settings.metronomeUseAccentSound !=
            previousSettings.metronomeUseAccentSound) {
      await _queueMetronomeAudioLoad(bindings.settings);
      if (_disposed) {
        return;
      }
    }
    if (!_state.autoRunning) {
      return;
    }
    if (bindings.bpm != previousSettings.bpm ||
        bindings.settings.timeSignature != previousSettings.timeSignature ||
        bindings.settings.harmonicRhythmPreset !=
            previousSettings.harmonicRhythmPreset) {
      _startAutoLoop(immediateFirstBeat: false);
      return;
    }
    if (PracticeSettingsEffects.metronomeAudioChanged(
      previousSettings,
      bindings.settings,
    )) {
      _restartMetronomeScheduling(immediateFirstBeat: false);
    }
  }

  void handleLiveBpmChanged(int bpm) {
    if (_disposed || !_state.autoRunning) {
      return;
    }
    _startAutoLoop(immediateFirstBeat: false);
  }

  void setCurrentBeat(int? currentBeat) {
    _setCurrentBeat(currentBeat);
  }

  void handleManualChordAdvance({required int? currentBeat}) {
    _setCurrentBeat(currentBeat);
    if (_state.autoRunning) {
      _startAutoLoop(immediateFirstBeat: false);
    }
  }

  void startAutoplay() {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    final immediateFirstBeat = shouldStartPracticeAutoplayImmediately(
      _state.currentBeat,
    );
    _setState(
      _state.copyWith(autoRunning: true, clearCurrentBeat: immediateFirstBeat),
    );
    _startAutoLoop(immediateFirstBeat: immediateFirstBeat);
  }

  void stopAutoplay({bool resetBeat = true}) {
    _cancelAutoplayRuntime();
    _setState(_state.copyWith(autoRunning: false, clearCurrentBeat: resetBeat));
  }

  void rescheduleAutoplay() {
    if (_disposed || !_state.autoRunning) {
      return;
    }
    _startAutoLoop(immediateFirstBeat: false);
  }

  Future<void> shutdown() {
    final pendingShutdown = _shutdownFuture;
    if (pendingShutdown != null) {
      return pendingShutdown;
    }
    _cancelAutoplayRuntime();
    _setState(
      _state.copyWith(
        autoRunning: false,
        clearCurrentBeat: true,
        metronomeReady: false,
      ),
    );
    _shutdownFuture = _audioBackend.dispose();
    return _shutdownFuture!;
  }

  Future<void> _queueMetronomeAudioLoad(PracticeSettings settings) async {
    final loadGeneration = ++_loadGeneration;
    final result = await _audioBackend.queueSourceLoad(
      primarySource: settings.metronomeSource,
      accentSource: settings.metronomeAccentSource,
      useAccentSource: settings.metronomeUseAccentSound,
    );
    if (_disposed || loadGeneration != _loadGeneration) {
      return;
    }
    _setState(_state.copyWith(metronomeReady: _audioBackend.isReady));
    if (result.preciseAssetReloaded && _state.autoRunning) {
      _restartMetronomeScheduling(immediateFirstBeat: false);
    }
  }

  void _handleAutoTick() {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    final autoTick = computeNextPracticeAutoBeat(
      currentBeat: _state.currentBeat,
      beatCount: bindings.settings.beatsPerBar,
      nextChangeBeat: bindings.nextChangeBeat,
    );
    _setCurrentBeat(autoTick.nextBeat);
    _playMetronomeIfNeeded(fromAutoTick: true);
    if (autoTick.shouldAdvanceChord) {
      _onAdvanceChord?.call();
    }
  }

  void _runDueAutoTicks(int generation) {
    if (_disposed || generation != _loopGeneration || !_state.autoRunning) {
      return;
    }
    final beatClock = _autoBeatClock;
    final autoStopwatch = _autoStopwatch;
    if (beatClock == null || autoStopwatch == null) {
      return;
    }
    for (final _ in beatClock.consumeDueSequences(autoStopwatch.elapsed)) {
      if (_disposed || generation != _loopGeneration || !_state.autoRunning) {
        return;
      }
      _handleAutoTick();
    }
    _scheduleAutoTimer(generation);
  }

  void _restartMetronomeScheduling({required bool immediateFirstBeat}) {
    final bindings = _bindings;
    _scheduledMetronomeTimer?.cancel();
    _scheduledMetronomeTimer = null;
    _scheduledMetronomeBaseTimeSeconds = null;
    _nextScheduledMetronomeSequence = 0;
    _audioBackend.cancelScheduled();
    if (_disposed || bindings == null) {
      return;
    }
    if (!_shouldScheduleMetronomeAhead(bindings.settings)) {
      return;
    }
    final generation = _loopGeneration;
    unawaited(
      _startMetronomeScheduling(
        immediateFirstBeat: immediateFirstBeat,
        generation: generation,
      ),
    );
  }

  Future<void> _startMetronomeScheduling({
    required bool immediateFirstBeat,
    required int generation,
  }) async {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    final prepared = await _audioBackend.ensurePreciseReady();
    if (!prepared ||
        _disposed ||
        generation != _loopGeneration ||
        !_shouldScheduleMetronomeAhead(bindings.settings)) {
      return;
    }
    final autoStopwatch = _autoStopwatch;
    final beatClock = _autoBeatClock;
    if (autoStopwatch == null || beatClock == null) {
      return;
    }
    if (immediateFirstBeat) {
      final beatState = bindings.settings.metronomeBeatStateForBeat(0);
      if (beatState != MetronomeBeatState.mute) {
        await _audioBackend.playBeat(
          beatState,
          volume: bindings.settings.metronomeVolume,
        );
      }
      if (_disposed ||
          generation != _loopGeneration ||
          !_shouldScheduleMetronomeAhead(bindings.settings)) {
        return;
      }
    }
    final currentTimeSeconds = _audioBackend.currentTimeSeconds;
    if (currentTimeSeconds == null) {
      return;
    }
    _scheduledMetronomeBaseTimeSeconds =
        currentTimeSeconds - _elapsedSeconds(autoStopwatch.elapsed);
    _nextScheduledMetronomeSequence = max(
      beatClock.lastSequence + 1,
      immediateFirstBeat ? 1 : 0,
    );
    _fillScheduledMetronomeWindow(generation);
    _scheduledMetronomeTimer?.cancel();
    _scheduledMetronomeTimer = _periodicTimerFactory(
      _scheduledMetronomePollInterval,
      () => _fillScheduledMetronomeWindow(generation),
    );
  }

  void _fillScheduledMetronomeWindow(int generation) {
    final bindings = _bindings;
    if (_disposed ||
        generation != _loopGeneration ||
        bindings == null ||
        !_shouldScheduleMetronomeAhead(bindings.settings)) {
      return;
    }
    final baseTimeSeconds = _scheduledMetronomeBaseTimeSeconds;
    final currentTimeSeconds = _audioBackend.currentTimeSeconds;
    if (baseTimeSeconds == null || currentTimeSeconds == null) {
      return;
    }
    final horizonSeconds =
        currentTimeSeconds + _elapsedSeconds(_scheduledMetronomeLookAhead);
    while (true) {
      final beatTimeSeconds =
          baseTimeSeconds +
          (_nextScheduledMetronomeSequence *
              _beatIntervalSeconds(bindings.bpm));
      if (beatTimeSeconds > horizonSeconds) {
        break;
      }
      final beatIndex = _beatIndexForScheduledSequence(
        _nextScheduledMetronomeSequence,
        bindings.settings.beatsPerBar,
      );
      final beatState = bindings.settings.metronomeBeatStateForBeat(beatIndex);
      _audioBackend.scheduleBeatAt(
        beatState,
        whenSeconds: beatTimeSeconds,
        volume: bindings.settings.metronomeVolume,
      );
      _nextScheduledMetronomeSequence += 1;
    }
  }

  void _startAutoLoop({required bool immediateFirstBeat}) {
    final bindings = _bindings;
    if (_disposed || bindings == null) {
      return;
    }
    _autoTimer?.cancel();
    _autoStopwatch = _stopwatchFactory()..start();
    _autoBeatClock = BeatClock(
      interval: _beatInterval(bindings.bpm),
      immediateFirstBeat: immediateFirstBeat,
    );
    _scheduledMetronomeBeatSeed = immediateFirstBeat
        ? 0
        : (_state.currentBeat ?? 0);
    final generation = ++_loopGeneration;
    _restartMetronomeScheduling(immediateFirstBeat: immediateFirstBeat);
    if (immediateFirstBeat) {
      _runDueAutoTicks(generation);
      return;
    }
    _scheduleAutoTimer(generation);
  }

  void _scheduleAutoTimer(int generation) {
    if (_disposed || generation != _loopGeneration || !_state.autoRunning) {
      return;
    }
    final beatClock = _autoBeatClock;
    final autoStopwatch = _autoStopwatch;
    if (beatClock == null || autoStopwatch == null) {
      return;
    }
    final delay = beatClock.delayUntilNext(autoStopwatch.elapsed);
    debugLastScheduledAutoDelay = delay;
    _autoTimer?.cancel();
    _autoTimer = _timerFactory(delay, () => _runDueAutoTicks(generation));
  }

  void _cancelAutoplayRuntime() {
    _loopGeneration += 1;
    debugLastScheduledAutoDelay = null;
    _autoTimer?.cancel();
    _autoTimer = null;
    _scheduledMetronomeTimer?.cancel();
    _scheduledMetronomeTimer = null;
    _audioBackend.cancelScheduled();
    _autoStopwatch = null;
    _autoBeatClock = null;
    _scheduledMetronomeBaseTimeSeconds = null;
    _nextScheduledMetronomeSequence = 0;
    _scheduledMetronomeBeatSeed = 0;
  }

  void _playMetronomeIfNeeded({bool fromAutoTick = false, int? beatIndex}) {
    final bindings = _bindings;
    if (_disposed || bindings == null || !bindings.settings.metronomeEnabled) {
      return;
    }
    if (fromAutoTick && _shouldScheduleMetronomeAhead(bindings.settings)) {
      return;
    }
    if (!_audioBackend.isReady) {
      return;
    }
    final resolvedBeatIndex = beatIndex ?? _state.currentBeat;
    if (resolvedBeatIndex == null) {
      return;
    }
    final beatState = bindings.settings.metronomeBeatStateForBeat(
      resolvedBeatIndex,
    );
    if (beatState == MetronomeBeatState.mute) {
      return;
    }
    unawaited(
      _audioBackend.playBeat(
        beatState,
        volume: bindings.settings.metronomeVolume,
      ),
    );
  }

  bool _shouldScheduleMetronomeAhead(PracticeSettings settings) {
    return _audioBackend.supportsPreciseScheduling &&
        _audioBackend.isReady &&
        _state.autoRunning &&
        settings.metronomeEnabled;
  }

  Duration _beatInterval(int bpm) {
    return Duration(microseconds: (60000000 / bpm).round());
  }

  double _beatIntervalSeconds(int bpm) {
    return _beatInterval(bpm).inMicroseconds / Duration.microsecondsPerSecond;
  }

  double _elapsedSeconds(Duration duration) {
    return duration.inMicroseconds / Duration.microsecondsPerSecond;
  }

  int _beatIndexForScheduledSequence(int sequence, int beatsPerBar) {
    return (_scheduledMetronomeBeatSeed + sequence) % beatsPerBar;
  }

  int? _normalizeBeatForSettings(PracticeSettings settings, int? currentBeat) {
    if (currentBeat == null) {
      return null;
    }
    return currentBeat.clamp(0, settings.beatsPerBar - 1).toInt();
  }

  void _setCurrentBeat(int? currentBeat) {
    final nextState = currentBeat == null
        ? _state.copyWith(clearCurrentBeat: true)
        : _state.copyWith(currentBeat: currentBeat);
    _setState(nextState);
  }

  void _setState(PracticeTransportState nextState) {
    if (_state.autoRunning == nextState.autoRunning &&
        _state.currentBeat == nextState.currentBeat &&
        _state.metronomeReady == nextState.metronomeReady) {
      return;
    }
    _state = nextState;
    _notifySafely();
  }

  void _notifySafely() {
    if (_disposed) {
      return;
    }
    SchedulerBinding binding;
    try {
      binding = SchedulerBinding.instance;
    } catch (_) {
      if (!_disposed) {
        notifyListeners();
      }
      return;
    }
    final phase = binding.schedulerPhase;
    final canNotifyImmediately =
        phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks;
    if (canNotifyImmediately) {
      if (!_disposed) {
        notifyListeners();
      }
      return;
    }
    if (_notifyScheduled) {
      return;
    }
    _notifyScheduled = true;
    binding.addPostFrameCallback((_) {
      _notifyScheduled = false;
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _cancelAutoplayRuntime();
    _shutdownFuture ??= _audioBackend.dispose();
    super.dispose();
  }

  static PracticeTransportTimerHandle _defaultTimerFactory(
    Duration delay,
    void Function() callback,
  ) {
    return _DartPracticeTransportTimerHandle(Timer(delay, callback));
  }

  static PracticeTransportTimerHandle _defaultPeriodicTimerFactory(
    Duration interval,
    void Function() callback,
  ) {
    return _DartPracticeTransportTimerHandle(
      Timer.periodic(interval, (_) => callback()),
    );
  }

  static PracticeTransportStopwatch _defaultStopwatchFactory() {
    return _SystemPracticeTransportStopwatch();
  }
}

class _PracticeTransportBindings {
  const _PracticeTransportBindings({
    required this.settings,
    required this.bpm,
    required this.nextChangeBeat,
  });

  final PracticeSettings settings;
  final int bpm;
  final int nextChangeBeat;
}

abstract class PracticeTransportStopwatch {
  void start();
  Duration get elapsed;
}

abstract class PracticeTransportTimerHandle {
  void cancel();
}

class _DartPracticeTransportTimerHandle
    implements PracticeTransportTimerHandle {
  _DartPracticeTransportTimerHandle(this._timer);

  final Timer _timer;

  @override
  void cancel() {
    _timer.cancel();
  }
}

class _SystemPracticeTransportStopwatch implements PracticeTransportStopwatch {
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void start() {
    _stopwatch.start();
  }

  @override
  Duration get elapsed => _stopwatch.elapsed;
}
