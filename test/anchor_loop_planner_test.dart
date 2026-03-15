import 'package:chordest/music/anchor_loop_planner.dart';
import 'package:chordest/music/chord_anchor_loop.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const planner = AnchorLoopPlanner();
  const cMajor = KeyCenter(tonicName: 'C', mode: KeyMode.major);

  PracticeSettings buildSettings({
    PracticeTimeSignature timeSignature = PracticeTimeSignature.fourFour,
    HarmonicRhythmPreset harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
  }) {
    return PracticeSettings(
      timeSignature: timeSignature,
      harmonicRhythmPreset: harmonicRhythmPreset,
      activeKeyCenters: {cMajor},
    );
  }

  ChordTimingSpec buildTiming({
    required int barIndex,
    required int changeBeat,
    required int durationBeats,
    required int beatsPerBar,
    required int eventIndexInBar,
    required int eventsInBar,
  }) {
    return ChordTimingSpec(
      barIndex: barIndex,
      changeBeat: changeBeat,
      durationBeats: durationBeats,
      beatsPerBar: beatsPerBar,
      eventIndexInBar: eventIndexInBar,
      eventsInBar: eventsInBar,
    );
  }

  test('4-bar anchor loops recur on the same cycle slot', () {
    final plan = planner.buildCyclePlan(
      settings: buildSettings(),
      loop: const ChordAnchorLoop(
        cycleLengthBars: 4,
        slots: [
          ChordAnchorSlot(
            barOffset: 0,
            slotIndexWithinBar: 0,
            chordSymbol: 'Fm7',
            enabled: true,
          ),
        ],
      ),
      seedKeyCenter: cMajor,
    );

    expect(plan, isNotNull);

    final anchorSlot = plan!.slots.singleWhere((slot) => slot.isAnchor);
    expect(anchorSlot.parsedAnchorChord?.sourceSymbol, 'Fm7');

    for (final barIndex in const [0, 4, 8]) {
      final resolved = plan.planForTiming(
        buildTiming(
          barIndex: barIndex,
          changeBeat: 0,
          durationBeats: 4,
          beatsPerBar: 4,
          eventIndexInBar: 0,
          eventsInBar: 1,
        ),
      );
      expect(resolved?.isAnchor, isTrue);
      expect(resolved?.parsedAnchorChord?.sourceSymbol, 'Fm7');
    }

    final filler = plan.planForTiming(
      buildTiming(
        barIndex: 1,
        changeBeat: 0,
        durationBeats: 4,
        beatsPerBar: 4,
        eventIndexInBar: 0,
        eventsInBar: 1,
      ),
    );
    expect(filler, isNotNull);
    expect(filler?.isAnchor, isFalse);
    expect(filler?.hasAnalysis, isTrue);
  });

  test('5-bar anchor loops wrap correctly', () {
    final plan = planner.buildCyclePlan(
      settings: buildSettings(),
      loop: const ChordAnchorLoop(
        cycleLengthBars: 5,
        slots: [
          ChordAnchorSlot(
            barOffset: 4,
            slotIndexWithinBar: 0,
            chordSymbol: 'G7',
            enabled: true,
          ),
        ],
      ),
      seedKeyCenter: cMajor,
    );

    expect(plan, isNotNull);

    for (final barIndex in const [4, 9, 14]) {
      final resolved = plan!.planForTiming(
        buildTiming(
          barIndex: barIndex,
          changeBeat: 0,
          durationBeats: 4,
          beatsPerBar: 4,
          eventIndexInBar: 0,
          eventsInBar: 1,
        ),
      );
      expect(resolved?.isAnchor, isTrue);
      expect(resolved?.parsedAnchorChord?.sourceSymbol, 'G7');
    }
  });

  test('borrowed iv anchors are analyzed as modal interchange in C major', () {
    final plan = planner.buildCyclePlan(
      settings: buildSettings(),
      loop: const ChordAnchorLoop(
        cycleLengthBars: 4,
        slots: [
          ChordAnchorSlot(
            barOffset: 0,
            slotIndexWithinBar: 0,
            chordSymbol: 'Fm7',
            enabled: true,
          ),
        ],
      ),
      seedKeyCenter: cMajor,
    );

    expect(plan, isNotNull);

    final anchor = plan!.slots.singleWhere((slot) => slot.isAnchor);
    expect(anchor.primaryAnalysis, isNotNull);
    expect(
      anchor.primaryAnalysis!.sourceKind,
      ChordSourceKind.modalInterchange,
    );
    expect(
      anchor.primaryAnalysis!.romanNumeralId,
      RomanNumeralId.borrowedIvMin7,
    );
  });
}
