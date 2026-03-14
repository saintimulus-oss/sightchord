import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/practice_chord_queue_state.dart';
import 'package:chordest/smart_generator.dart';

void main() {
  test('ensureNextChord seeds the queue only once', () {
    final seeded = _buildChord('first');
    final existing = _buildChord('existing');
    final initial = const PracticeChordQueueState();
    final withSeed = initial.ensureNextChord(seeded);
    final preserved = withSeed
        .copyWith(nextChord: existing)
        .ensureNextChord(seeded);

    expect(withSeed.nextChord?.repeatGuardKey, 'first');
    expect(preserved.nextChord?.repeatGuardKey, 'existing');
  });

  test('promote carries current to previous and clears look-ahead', () {
    final previous = _buildChord('previous');
    final current = _buildChord('current');
    final next = _buildChord('next');
    final lookAhead = _buildChord('lookAhead');
    final promoted = PracticeChordQueueState(
      previousChord: previous,
      currentChord: current,
      nextChord: next,
      lookAheadChord: lookAhead,
      plannedSmartChordQueue: const <QueuedSmartChord>[],
    ).promote(nextCurrentChord: next, nextQueuedChord: lookAhead);

    expect(promoted.previousChord?.repeatGuardKey, 'current');
    expect(promoted.currentChord?.repeatGuardKey, 'next');
    expect(promoted.nextChord?.repeatGuardKey, 'lookAhead');
    expect(promoted.lookAheadChord, isNull);
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

