class BeatClock {
  BeatClock({required Duration interval, required bool immediateFirstBeat})
    : _intervalMicroseconds = interval.inMicroseconds <= 0
          ? 1
          : interval.inMicroseconds,
      _lastSequence = immediateFirstBeat ? -1 : 0;

  final int _intervalMicroseconds;
  int _lastSequence;

  int get lastSequence => _lastSequence;

  Iterable<int> consumeDueSequences(Duration elapsed) sync* {
    final dueSequence = elapsed.inMicroseconds ~/ _intervalMicroseconds;
    while (_lastSequence < dueSequence) {
      _lastSequence += 1;
      yield _lastSequence;
    }
  }

  Duration delayUntilNext(Duration elapsed) {
    final nextTargetMicroseconds = (_lastSequence + 1) * _intervalMicroseconds;
    final remainingMicroseconds =
        nextTargetMicroseconds - elapsed.inMicroseconds;
    return Duration(
      microseconds: remainingMicroseconds <= 0 ? 0 : remainingMicroseconds,
    );
  }
}
