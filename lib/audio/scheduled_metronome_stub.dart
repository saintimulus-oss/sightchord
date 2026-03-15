import 'scheduled_metronome_interface.dart';

ScheduledMetronome createScheduledMetronome() =>
    const _UnsupportedScheduledMetronome();

class _UnsupportedScheduledMetronome implements ScheduledMetronome {
  const _UnsupportedScheduledMetronome();

  @override
  double? get currentTimeSeconds => null;

  @override
  bool get isLoaded => false;

  @override
  bool get supportsPreciseScheduling => false;

  @override
  void cancelScheduled() {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> ensureReady() async {}

  @override
  Future<void> loadAsset(
    String assetPath, {
    String soundId = 'primary',
  }) async {}

  @override
  Future<void> playNow({
    required double volume,
    String soundId = 'primary',
  }) async {}

  @override
  void scheduleAt({
    required double whenSeconds,
    required double volume,
    String soundId = 'primary',
  }) {}
}
