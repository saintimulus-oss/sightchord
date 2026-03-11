abstract class ScheduledMetronome {
  bool get supportsPreciseScheduling;
  bool get isLoaded;
  double? get currentTimeSeconds;

  Future<void> loadAsset(String assetPath);
  Future<void> ensureReady();
  Future<void> playNow({required double volume});
  void scheduleAt({required double whenSeconds, required double volume});
  void cancelScheduled();
  Future<void> dispose();
}
