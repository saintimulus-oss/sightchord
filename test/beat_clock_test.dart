import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/audio/beat_clock.dart';

void main() {
  group('BeatClock', () {
    test('fires the first beat immediately when configured to do so', () {
      final clock = BeatClock(
        interval: const Duration(milliseconds: 200),
        immediateFirstBeat: true,
      );

      expect(clock.consumeDueSequences(Duration.zero).toList(), [0]);
      expect(
        clock.delayUntilNext(const Duration(milliseconds: 35)),
        const Duration(milliseconds: 165),
      );
    });

    test('waits one full interval when immediate first beat is disabled', () {
      final clock = BeatClock(
        interval: const Duration(milliseconds: 250),
        immediateFirstBeat: false,
      );

      expect(clock.consumeDueSequences(Duration.zero), isEmpty);
      expect(
        clock.delayUntilNext(const Duration(milliseconds: 40)),
        const Duration(milliseconds: 210),
      );
      expect(
        clock.consumeDueSequences(const Duration(milliseconds: 250)).toList(),
        [1],
      );
    });

    test('catches up multiple missed beats without drifting phase', () {
      final clock = BeatClock(
        interval: const Duration(milliseconds: 100),
        immediateFirstBeat: true,
      );

      expect(clock.consumeDueSequences(Duration.zero).toList(), [0]);
      expect(
        clock.consumeDueSequences(const Duration(milliseconds: 340)).toList(),
        [1, 2, 3],
      );
      expect(
        clock.delayUntilNext(const Duration(milliseconds: 340)),
        const Duration(milliseconds: 60),
      );
    });

    test('clamps non-positive interval and zeroes overdue delay', () {
      final clock = BeatClock(
        interval: Duration.zero,
        immediateFirstBeat: false,
      );

      expect(
        clock.consumeDueSequences(const Duration(microseconds: 3)).toList(),
        [1, 2, 3],
      );
      expect(
        clock.delayUntilNext(const Duration(microseconds: 10)),
        Duration.zero,
      );
    });
  });
}
