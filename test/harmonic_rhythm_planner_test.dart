import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/harmonic_rhythm_planner.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default settings keep one chord per 4/4 bar', () {
    final timing = HarmonicRhythmPlanner.initialTiming(
      settings: PracticeSettings(),
    );

    expect(timing.beatsPerBar, 4);
    expect(timing.changeBeat, 0);
    expect(timing.durationBeats, 4);
    expect(timing.eventsInBar, 1);
  });

  test('two-per-bar splits 4/4 on beats one and three', () {
    final settings = PracticeSettings(
      harmonicRhythmPreset: HarmonicRhythmPreset.twoPerBar,
    );
    final firstTiming = HarmonicRhythmPlanner.initialTiming(settings: settings);
    final secondTiming = HarmonicRhythmPlanner.nextTiming(
      settings: settings,
      currentEvent: GeneratedChordEvent(
        chord: _buildChord('first'),
        timing: firstTiming,
      ),
    );

    expect(firstTiming.changeBeat, 0);
    expect(firstTiming.durationBeats, 2);
    expect(secondTiming.barIndex, 0);
    expect(secondTiming.changeBeat, 2);
    expect(secondTiming.durationBeats, 2);
  });

  test(
    'cadence compression allows a beat-three pickup in 3/4 near cadence',
    () {
      final settings = PracticeSettings(
        timeSignature: PracticeTimeSignature.threeFour,
        harmonicRhythmPreset: HarmonicRhythmPreset.cadenceCompression,
      );
      final previousBarEvent = GeneratedChordEvent(
        chord: _buildChord('previous'),
        timing: const ChordTimingSpec(
          barIndex: 6,
          changeBeat: 0,
          durationBeats: 3,
          beatsPerBar: 3,
          eventIndexInBar: 0,
          eventsInBar: 1,
        ),
      );

      final nextTiming = HarmonicRhythmPlanner.nextTiming(
        settings: settings,
        currentEvent: previousBarEvent,
      );

      expect(nextTiming.barIndex, 7);
      expect(nextTiming.changeBeat, 0);
      expect(nextTiming.durationBeats, 2);
      expect(nextTiming.eventsInBar, 2);
    },
  );

  test('cadence compression allows a beat-two pickup in 2/4 near cadence', () {
    final settings = PracticeSettings(
      timeSignature: PracticeTimeSignature.twoFour,
      harmonicRhythmPreset: HarmonicRhythmPreset.cadenceCompression,
    );
    final previousBarEvent = GeneratedChordEvent(
      chord: _buildChord('previous'),
      timing: const ChordTimingSpec(
        barIndex: 6,
        changeBeat: 0,
        durationBeats: 2,
        beatsPerBar: 2,
        eventIndexInBar: 0,
        eventsInBar: 1,
      ),
    );

    final nextTiming = HarmonicRhythmPlanner.nextTiming(
      settings: settings,
      currentEvent: previousBarEvent,
    );

    expect(nextTiming.barIndex, 7);
    expect(nextTiming.changeBeat, 0);
    expect(nextTiming.durationBeats, 1);
    expect(nextTiming.eventsInBar, 2);
  });
}

GeneratedChord _buildChord(String repeatKey) {
  return GeneratedChord(
    symbolData: const ChordSymbolData(
      root: 'C',
      harmonicQuality: ChordQuality.major7,
      renderQuality: ChordQuality.major7,
    ),
    repeatGuardKey: repeatKey,
    harmonicComparisonKey: repeatKey,
  );
}
