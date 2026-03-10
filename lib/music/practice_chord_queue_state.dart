import 'chord_theory.dart';
import '../smart_generator.dart';

class PracticeChordQueueState {
  const PracticeChordQueueState({
    this.previousChord,
    this.currentChord,
    this.nextChord,
    this.lookAheadChord,
    this.plannedSmartChordQueue = const <QueuedSmartChord>[],
  });

  final GeneratedChord? previousChord;
  final GeneratedChord? currentChord;
  final GeneratedChord? nextChord;
  final GeneratedChord? lookAheadChord;
  final List<QueuedSmartChord> plannedSmartChordQueue;

  PracticeChordQueueState reset() => const PracticeChordQueueState();

  PracticeChordQueueState ensureNextChord(GeneratedChord seededNextChord) {
    if (nextChord != null) {
      return this;
    }
    return copyWith(nextChord: seededNextChord);
  }

  PracticeChordQueueState withLookAheadChord(GeneratedChord? chord) {
    return copyWith(lookAheadChord: chord);
  }

  PracticeChordQueueState withPlannedSmartChordQueue(
    List<QueuedSmartChord> queue,
  ) {
    return copyWith(
      plannedSmartChordQueue: List<QueuedSmartChord>.unmodifiable(queue),
    );
  }

  PracticeChordQueueState clearPlannedSmartChordQueue() {
    return copyWith(
      plannedSmartChordQueue: List<QueuedSmartChord>.unmodifiable(
        const <QueuedSmartChord>[],
      ),
    );
  }

  PracticeChordQueueState promote({
    required GeneratedChord nextCurrentChord,
    required GeneratedChord nextQueuedChord,
  }) {
    return copyWith(
      previousChord: currentChord,
      currentChord: nextCurrentChord,
      nextChord: nextQueuedChord,
      lookAheadChord: _clearField,
    );
  }

  PracticeChordQueueState copyWith({
    Object? previousChord = _retainField,
    Object? currentChord = _retainField,
    Object? nextChord = _retainField,
    Object? lookAheadChord = _retainField,
    Object? plannedSmartChordQueue = _retainField,
  }) {
    return PracticeChordQueueState(
      previousChord: switch (previousChord) {
        _Sentinel() => this.previousChord,
        _ClearField() => null,
        GeneratedChord value => value,
        _ => this.previousChord,
      },
      currentChord: switch (currentChord) {
        _Sentinel() => this.currentChord,
        _ClearField() => null,
        GeneratedChord value => value,
        _ => this.currentChord,
      },
      nextChord: switch (nextChord) {
        _Sentinel() => this.nextChord,
        _ClearField() => null,
        GeneratedChord value => value,
        _ => this.nextChord,
      },
      lookAheadChord: switch (lookAheadChord) {
        _Sentinel() => this.lookAheadChord,
        _ClearField() => null,
        GeneratedChord value => value,
        _ => this.lookAheadChord,
      },
      plannedSmartChordQueue: switch (plannedSmartChordQueue) {
        _Sentinel() => this.plannedSmartChordQueue,
        List<QueuedSmartChord> value => value,
        _ => this.plannedSmartChordQueue,
      },
    );
  }

  static const _Sentinel _retainField = _Sentinel();
  static const _ClearField _clearField = _ClearField();
}

class _Sentinel {
  const _Sentinel();
}

class _ClearField {
  const _ClearField();
}
