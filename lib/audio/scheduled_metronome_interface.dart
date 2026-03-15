abstract class ScheduledMetronome {
  bool get supportsPreciseScheduling;
  bool get isLoaded;
  double? get currentTimeSeconds;

  Future<void> loadAsset(String assetPath, {String soundId = 'primary'});
  Future<void> ensureReady();
  Future<void> playNow({required double volume, String soundId = 'primary'});
  void scheduleAt({
    required double whenSeconds,
    required double volume,
    String soundId = 'primary',
  });
  void cancelScheduled();
  Future<void> dispose();
}
