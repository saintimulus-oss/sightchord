import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/audio/metronome_audio_service.dart';
import 'package:sightchord/audio/scheduled_metronome_interface.dart';
import 'package:sightchord/settings/practice_settings.dart';

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
  final List<String> loadedAssets = <String>[];
  final List<double> playNowVolumes = <double>[];
  final List<(double, double)> scheduledClicks = <(double, double)>[];
  int cancelCount = 0;
  int disposeCount = 0;
  Completer<void>? nextLoadCompleter;

  @override
  Future<void> loadAsset(String assetPath) async {
    loadedAssets.add(assetPath);
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
  Future<void> playNow({required double volume}) async {
    playNowVolumes.add(volume);
  }

  @override
  void scheduleAt({required double whenSeconds, required double volume}) {
    scheduledClicks.add((whenSeconds, volume));
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
    expect(scheduled.loadedAssets.last, 'assets/tickF.mp3');

    await service.playNow(volume: 0.7);

    expect(scheduled.playNowVolumes, [0.7]);
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
      expect(scheduled.loadedAssets, ['assets/tick.mp3']);

      firstLoadCompleter.complete();
      final firstResult = await firstLoad;
      final secondResult = await secondLoad;

      expect(firstResult.preciseAssetReloaded, isTrue);
      expect(secondResult.preciseAssetReloaded, isTrue);
      expect(scheduled.loadedAssets, ['assets/tick.mp3', 'assets/tickE.mp3']);
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
}
