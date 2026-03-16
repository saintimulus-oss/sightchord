import 'chord_theory.dart';
import 'chord_timing_models.dart';
import '../smart_generator.dart';

class PracticeChordQueueState {
  const PracticeChordQueueState({
    this.previousEvent,
    this.currentEvent,
    this.nextEvent,
    this.lookAheadEvent,
    this.plannedSmartChordQueue = const <QueuedSmartChord>[],
  });

  final GeneratedChordEvent? previousEvent;
  final GeneratedChordEvent? currentEvent;
  final GeneratedChordEvent? nextEvent;
  final GeneratedChordEvent? lookAheadEvent;
  final List<QueuedSmartChord> plannedSmartChordQueue;

  GeneratedChord? get previousChord => previousEvent?.chord;
  GeneratedChord? get currentChord => currentEvent?.chord;
  GeneratedChord? get nextChord => nextEvent?.chord;
  GeneratedChord? get lookAheadChord => lookAheadEvent?.chord;

  PracticeChordQueueState reset() => const PracticeChordQueueState();

  PracticeChordQueueState ensureNextEvent(GeneratedChordEvent seededNextEvent) {
    if (nextEvent != null) {
      return this;
    }
    return copyWith(nextEvent: seededNextEvent);
  }

  PracticeChordQueueState withLookAheadEvent(GeneratedChordEvent? event) {
    return copyWith(lookAheadEvent: event ?? _clearField);
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
    required GeneratedChordEvent nextCurrentEvent,
    required GeneratedChordEvent nextQueuedEvent,
  }) {
    return copyWith(
      previousEvent: currentEvent,
      currentEvent: nextCurrentEvent,
      nextEvent: nextQueuedEvent,
      lookAheadEvent: _clearField,
    );
  }

  PracticeChordQueueState copyWith({
    Object? previousEvent = _retainField,
    Object? currentEvent = _retainField,
    Object? nextEvent = _retainField,
    Object? lookAheadEvent = _retainField,
    Object? plannedSmartChordQueue = _retainField,
  }) {
    return PracticeChordQueueState(
      previousEvent: switch (previousEvent) {
        _Sentinel() => this.previousEvent,
        _ClearField() => null,
        GeneratedChordEvent value => value,
        _ => this.previousEvent,
      },
      currentEvent: switch (currentEvent) {
        _Sentinel() => this.currentEvent,
        _ClearField() => null,
        GeneratedChordEvent value => value,
        _ => this.currentEvent,
      },
      nextEvent: switch (nextEvent) {
        _Sentinel() => this.nextEvent,
        _ClearField() => null,
        GeneratedChordEvent value => value,
        _ => this.nextEvent,
      },
      lookAheadEvent: switch (lookAheadEvent) {
        _Sentinel() => this.lookAheadEvent,
        _ClearField() => null,
        GeneratedChordEvent value => value,
        _ => this.lookAheadEvent,
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

