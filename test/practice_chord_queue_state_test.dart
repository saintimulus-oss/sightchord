import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/practice_chord_queue_state.dart';
import 'package:chordest/smart_generator.dart';

void main() {
  test('ensureNextEvent seeds the queue only once', () {
    final seeded = _buildEvent('first');
    final existing = _buildEvent('existing');
    final initial = const PracticeChordQueueState();
    final withSeed = initial.ensureNextEvent(seeded);
    final preserved = withSeed
        .copyWith(nextEvent: existing)
        .ensureNextEvent(seeded);

    expect(withSeed.nextChord?.repeatGuardKey, 'first');
    expect(preserved.nextChord?.repeatGuardKey, 'existing');
  });

  test('promote carries current to previous and clears look-ahead', () {
    final previous = _buildChord('previous');
    final current = _buildChord('current');
    final next = _buildChord('next');
    final lookAhead = _buildChord('lookAhead');
    final promoted =
        PracticeChordQueueState(
          previousEvent: _buildEvent('previous', chord: previous),
          currentEvent: _buildEvent('current', chord: current),
          nextEvent: _buildEvent('next', chord: next),
          lookAheadEvent: _buildEvent('lookAhead', chord: lookAhead),
          plannedSmartChordQueue: const <QueuedSmartChord>[],
        ).promote(
          nextCurrentEvent: _buildEvent('next', chord: next),
          nextQueuedEvent: _buildEvent('lookAhead', chord: lookAhead),
        );

    expect(promoted.previousChord?.repeatGuardKey, 'current');
    expect(promoted.currentChord?.repeatGuardKey, 'next');
    expect(promoted.nextChord?.repeatGuardKey, 'lookAhead');
    expect(promoted.lookAheadChord, isNull);
  });

  test('withLookAheadEvent(null) clears an existing look-ahead event', () {
    final stateWithLookAhead = PracticeChordQueueState(
      lookAheadEvent: _buildEvent('lookAhead'),
    );

    final cleared = stateWithLookAhead.withLookAheadEvent(null);

    expect(cleared.lookAheadChord, isNull);
  });
  test('planned smart queue updates stay immutable', () {
    const queued = QueuedSmartChord(
      keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
      finalRomanNumeralId: RomanNumeralId.iMaj7,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: 'tag',
    );
    final state = const PracticeChordQueueState().withPlannedSmartChordQueue(
      <QueuedSmartChord>[queued],
    );

    expect(state.plannedSmartChordQueue, hasLength(1));
    expect(
      () => state.plannedSmartChordQueue.add(queued),
      throwsUnsupportedError,
    );
  });
}

GeneratedChord _buildChord(String key) {
  return GeneratedChord(
    symbolData: const ChordSymbolData(
      root: 'C',
      harmonicQuality: ChordQuality.major7,
      renderQuality: ChordQuality.major7,
    ),
    repeatGuardKey: key,
    harmonicComparisonKey: key,
  );
}

GeneratedChordEvent _buildEvent(String key, {GeneratedChord? chord}) {
  return GeneratedChordEvent(
    chord: chord ?? _buildChord(key),
    timing: const ChordTimingSpec(
      barIndex: 0,
      changeBeat: 0,
      durationBeats: 4,
      beatsPerBar: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    ),
  );
}

