import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/audio/metronome_audio_service.dart';
import 'package:chordest/audio/metronome_audio_models.dart';
import 'package:chordest/audio/scheduled_metronome_interface.dart';

class _FakeScheduledMetronome implements ScheduledMetronome {
  _FakeScheduledMetronome({
    this.supportsPreciseScheduling = true,
    this.ensureReadyError,
  });

  @override
  final bool supportsPreciseScheduling;

  @override
  bool isLoaded = false;

  @override
  double? currentTimeSeconds = 16.0;

  final Object? ensureReadyError;
  final List<(String, String)> loadedAssets = <(String, String)>[];
  final List<(String, double)> playNowVolumes = <(String, double)>[];
  final List<(String, double, double)> scheduledClicks =
      <(String, double, double)>[];
  int cancelCount = 0;
  int disposeCount = 0;
  Completer<void>? nextLoadCompleter;

  @override
  Future<void> loadAsset(String assetPath, {String soundId = 'primary'}) async {
    loadedAssets.add((soundId, assetPath));
    final pendingLoad = nextLoadCompleter;
    if (pendingLoad != null) {
      nextLoadCompleter = null;
      await pendingLoad.future;
    }
    isLoaded = true;
  }

  @override
  Future<void> ensureReady() async {
    if (ensureReadyError != null) {
      throw ensureReadyError!;
    }
  }

  @override
  Future<void> playNow({
    required double volume,
    String soundId = 'primary',
  }) async {
    playNowVolumes.add((soundId, volume));
  }

  @override
  void scheduleAt({
    required double whenSeconds,
    required double volume,
    String soundId = 'primary',
  }) {
    scheduledClicks.add((soundId, whenSeconds, volume));
  }

  @override
  void cancelScheduled() {
    cancelCount += 1;
  }

  @override
  Future<void> dispose() async {
    disposeCount += 1;
  }
}

void main() {
  test('precise metronome loads assets and plays immediately', () async {
    final scheduled = _FakeScheduledMetronome();
    final warnings = <String>[];
    final service = MetronomeAudioService(
      scheduledMetronome: scheduled,
      logWarning: (message, {error, stackTrace}) => warnings.add(message),
    );
    addTearDown(service.dispose);

    final result = await service.queueSoundLoad(MetronomeSound.tickF);

    expect(result.preciseAssetReloaded, isTrue);
    expect(service.isReady, isTrue);
    expect(scheduled.loadedAssets.last, ('primary', 'assets/tickF.mp3'));

    await service.playNow(volume: 0.7);

    expect(scheduled.playNowVolumes, [('primary', 0.7)]);
    expect(warnings, isEmpty);
  });

  test(
    'serializes queued loads so a later sound waits for the current one',
    () async {
      final scheduled = _FakeScheduledMetronome();
      final service = MetronomeAudioService(scheduledMetronome: scheduled);
      addTearDown(service.dispose);

      final firstLoadCompleter = Completer<void>();
      scheduled.nextLoadCompleter = firstLoadCompleter;

      final firstLoad = service.queueSoundLoad(MetronomeSound.tick);
      final secondLoad = service.queueSoundLoad(MetronomeSound.tickE);

      await Future<void>.delayed(Duration.zero);
      expect(scheduled.loadedAssets, [('primary', 'assets/tick.mp3')]);

      firstLoadCompleter.complete();
      final firstResult = await firstLoad;
      final secondResult = await secondLoad;

      expect(firstResult.preciseAssetReloaded, isTrue);
      expect(secondResult.preciseAssetReloaded, isTrue);
      expect(scheduled.loadedAssets, [
        ('primary', 'assets/tick.mp3'),
        ('primary', 'assets/tickE.mp3'),
      ]);
    },
  );

  test(
    'reports precise readiness failures without throwing back to the caller',
    () async {
      final warnings = <String>[];
      final service = MetronomeAudioService(
        scheduledMetronome: _FakeScheduledMetronome(
          ensureReadyError: StateError('backend unavailable'),
        ),
        logWarning: (message, {error, stackTrace}) => warnings.add(message),
      );
      addTearDown(service.dispose);

      final prepared = await service.ensurePreciseReady();

      expect(prepared, isFalse);
      expect(
        warnings,
        contains(
          'Scheduled metronome could not prepare in time for look-ahead playback.',
        ),
      );
    },
  );

  test('non-precise backends skip precise preparation requests', () async {
    final service = MetronomeAudioService(
      scheduledMetronome: _FakeScheduledMetronome(
        supportsPreciseScheduling: false,
      ),
    );
    addTearDown(service.dispose);

    final prepared = await service.ensurePreciseReady();

    expect(prepared, isFalse);
  });

  test('accent beats can route to a separate sound id', () async {
    final scheduled = _FakeScheduledMetronome();
    final service = MetronomeAudioService(scheduledMetronome: scheduled);
    addTearDown(service.dispose);

    await service.queueSourceLoad(
      primarySource: const MetronomeSourceSpec.builtIn(
        sound: MetronomeSound.tick,
      ),
      accentSource: const MetronomeSourceSpec.builtIn(
        sound: MetronomeSound.tickF,
      ),
      useAccentSource: true,
    );

    await service.playBeat(MetronomeBeatState.accent, volume: 0.6);
    service.scheduleBeatAt(
      MetronomeBeatState.accent,
      whenSeconds: 12.5,
      volume: 0.4,
    );

    expect(scheduled.loadedAssets, [
      ('primary', 'assets/tick.mp3'),
      ('accent', 'assets/tickF.mp3'),
    ]);
    expect(scheduled.playNowVolumes, [('accent', 0.6)]);
    expect(scheduled.scheduledClicks, [('accent', 12.5, 0.4)]);
  });

  test('muted beats do not schedule or play', () async {
    final scheduled = _FakeScheduledMetronome();
    final service = MetronomeAudioService(scheduledMetronome: scheduled);
    addTearDown(service.dispose);

    await service.queueSoundLoad(MetronomeSound.tick);
    await service.playBeat(MetronomeBeatState.mute, volume: 0.8);
    service.scheduleBeatAt(
      MetronomeBeatState.mute,
      whenSeconds: 3.2,
      volume: 0.8,
    );

    expect(scheduled.playNowVolumes, isEmpty);
    expect(scheduled.scheduledClicks, isEmpty);
  });
}
