import 'dart:async';

import 'package:chordest/audio/metronome_audio_backend.dart';
import 'package:chordest/practice/practice_transport_controller.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PracticeTransportController', () {
    test('rapid start and stop cancels stale timers safely', () {
      final backend = _FakeMetronomeAudioBackend(
        supportsPreciseScheduling: false,
      );
      final timers = _FakeTimerFactory();
      final controller = PracticeTransportController(
        audioBackend: backend,
        timerFactory: timers.oneShot,
        periodicTimerFactory: timers.periodic,
        stopwatchFactory: _FakeTransportStopwatch.new,
      );
      addTearDown(() async {
        await controller.shutdown();
        controller.dispose();
      });

      var advanceCount = 0;
      controller.bind(
        settings: PracticeSettings(metronomeEnabled: false),
        bpm: 120,
        nextChangeBeat: 0,
        onAdvanceChord: () {
          advanceCount += 1;
        },
      );
      controller.setCurrentBeat(0);

      controller.startAutoplay();
      controller.stopAutoplay(resetBeat: false);
      controller.startAutoplay();
      controller.stopAutoplay();

      for (final handle in timers.handles) {
        handle.fire();
      }

      expect(controller.state.autoRunning, isFalse);
      expect(controller.state.currentBeat, isNull);
      expect(advanceCount, 0);
      expect(timers.handles.every((handle) => handle.canceled), isTrue);
    });

    test(
      'sound reload completion does not restart scheduling after stop',
      () async {
        final backend = _FakeMetronomeAudioBackend();
        final timers = _FakeTimerFactory();
        final controller = PracticeTransportController(
          audioBackend: backend,
          timerFactory: timers.oneShot,
          periodicTimerFactory: timers.periodic,
          stopwatchFactory: _FakeTransportStopwatch.new,
        );
        addTearDown(() async {
          await controller.shutdown();
          controller.dispose();
        });

        final initialSettings = PracticeSettings(
          metronomeSource: const MetronomeSourceSpec.builtIn(
            sound: MetronomeSound.tick,
          ),
        );
        controller.bind(
          settings: initialSettings,
          bpm: 120,
          nextChangeBeat: 0,
          onAdvanceChord: () {},
        );
        controller.setCurrentBeat(0);
        controller.startAutoplay();

        final loadCompleter = Completer<MetronomeSoundLoadResult>();
        backend.nextLoadCompleter = loadCompleter;
        controller.bind(
          settings: initialSettings.copyWith(
            metronomeSource: const MetronomeSourceSpec.builtIn(
              sound: MetronomeSound.tickF,
            ),
          ),
          bpm: 120,
          nextChangeBeat: 0,
          onAdvanceChord: () {},
        );

        final reloadFuture = controller.handleSettingsChanged(
          previousSettings: initialSettings,
        );
        controller.stopAutoplay(resetBeat: false);
        loadCompleter.complete(
          const MetronomeSoundLoadResult(preciseAssetReloaded: true),
        );
        await reloadFuture;

        expect(controller.state.autoRunning, isFalse);
        expect(backend.ensurePreciseReadyCount, 1);
      },
    );

    test('shutdown is idempotent and disposes the backend once', () async {
      final backend = _FakeMetronomeAudioBackend();
      final controller = PracticeTransportController(audioBackend: backend);

      await controller.shutdown();
      await controller.shutdown();
      controller.dispose();

      expect(backend.disposeCount, 1);
    });

    test('dispose without shutdown still disposes the backend once', () {
      final backend = _FakeMetronomeAudioBackend();
      final controller = PracticeTransportController(audioBackend: backend);

      controller.dispose();
      controller.dispose();

      expect(backend.disposeCount, 1);
    });

    test('BPM updates reschedule autoplay with the new interval', () {
      final backend = _FakeMetronomeAudioBackend(
        supportsPreciseScheduling: false,
      );
      final timers = _FakeTimerFactory();
      final controller = PracticeTransportController(
        audioBackend: backend,
        timerFactory: timers.oneShot,
        periodicTimerFactory: timers.periodic,
        stopwatchFactory: _FakeTransportStopwatch.new,
      );
      addTearDown(() async {
        await controller.shutdown();
        controller.dispose();
      });

      final settings = PracticeSettings(metronomeEnabled: false);
      controller.bind(
        settings: settings,
        bpm: 120,
        nextChangeBeat: 0,
        onAdvanceChord: () {},
      );
      controller.setCurrentBeat(0);
      controller.startAutoplay();

      expect(
        controller.debugLastScheduledAutoDelay,
        const Duration(milliseconds: 500),
      );

      controller.bind(
        settings: settings,
        bpm: 240,
        nextChangeBeat: 0,
        onAdvanceChord: () {},
      );
      controller.handleLiveBpmChanged(240);

      expect(
        controller.debugLastScheduledAutoDelay,
        const Duration(milliseconds: 250),
      );
    });
  });
}

class _FakeMetronomeAudioBackend implements MetronomeAudioBackend {
  _FakeMetronomeAudioBackend({this.supportsPreciseScheduling = true});

  @override
  final bool supportsPreciseScheduling;

  @override
  bool isReady = true;

  @override
  double? currentTimeSeconds = 8.0;

  int ensurePreciseReadyCount = 0;
  int cancelScheduledCount = 0;
  int disposeCount = 0;
  int playBeatCount = 0;
  Completer<MetronomeSoundLoadResult>? nextLoadCompleter;

  @override
  Future<MetronomeSoundLoadResult> queueSoundLoad(MetronomeSound sound) {
    return queueSourceLoad(
      primarySource: MetronomeSourceSpec.builtIn(sound: sound),
      accentSource: const MetronomeSourceSpec.builtIn(
        sound: MetronomeSound.tickF,
      ),
      useAccentSource: false,
    );
  }

  @override
  Future<MetronomeSoundLoadResult> queueSourceLoad({
    required MetronomeSourceSpec primarySource,
    required MetronomeSourceSpec accentSource,
    required bool useAccentSource,
  }) async {
    final pending = nextLoadCompleter;
    if (pending != null) {
      nextLoadCompleter = null;
      return pending.future;
    }
    isReady = true;
    return const MetronomeSoundLoadResult();
  }

  @override
  Future<void> playNow({required double volume}) async {}

  @override
  Future<void> playBeat(
    MetronomeBeatState state, {
    required double volume,
  }) async {
    playBeatCount += 1;
  }

  @override
  Future<bool> ensurePreciseReady() async {
    ensurePreciseReadyCount += 1;
    return true;
  }

  @override
  void scheduleAt({required double whenSeconds, required double volume}) {}

  @override
  void scheduleBeatAt(
    MetronomeBeatState state, {
    required double whenSeconds,
    required double volume,
  }) {}

  @override
  void cancelScheduled() {
    cancelScheduledCount += 1;
  }

  @override
  Future<void> dispose() async {
    disposeCount += 1;
  }
}

class _FakeTimerFactory {
  final List<_FakeTimerHandle> handles = <_FakeTimerHandle>[];

  PracticeTransportTimerHandle oneShot(
    Duration delay,
    void Function() callback,
  ) {
    final handle = _FakeTimerHandle(delay: delay, callback: callback);
    handles.add(handle);
    return handle;
  }

  PracticeTransportTimerHandle periodic(
    Duration interval,
    void Function() callback,
  ) {
    final handle = _FakeTimerHandle(delay: interval, callback: callback);
    handles.add(handle);
    return handle;
  }
}

class _FakeTimerHandle implements PracticeTransportTimerHandle {
  _FakeTimerHandle({required this.delay, required this.callback});

  final Duration delay;
  final void Function() callback;
  bool canceled = false;

  void fire() {
    if (!canceled) {
      callback();
    }
  }

  @override
  void cancel() {
    canceled = true;
  }
}

class _FakeTransportStopwatch implements PracticeTransportStopwatch {
  @override
  void start() {}

  @override
  Duration get elapsed => Duration.zero;
}
