import '../settings/practice_settings.dart';
import '../smart_generator.dart';
import 'anchor_loop_layout.dart';
import 'chord_anchor_loop.dart';
import 'chord_timing_models.dart';

class HarmonicRhythmPlanner {
  const HarmonicRhythmPlanner._();

  static ChordTimingSpec initialTiming({
    required PracticeSettings settings,
    ChordAnchorLoop? anchorLoop,
  }) {
    final changeBeats = changeBeatsForBar(
      settings: settings,
      barIndex: 0,
      anchorLoop: anchorLoop,
    );
    return _timingForSlot(
      changeBeats: changeBeats,
      slotIndex: 0,
      barIndex: 0,
      beatsPerBar: settings.beatsPerBar,
    );
  }

  static ChordTimingSpec nextTiming({
    required PracticeSettings settings,
    required GeneratedChordEvent? currentEvent,
    ChordAnchorLoop? anchorLoop,
  }) {
    if (currentEvent == null) {
      return initialTiming(settings: settings, anchorLoop: anchorLoop);
    }
    final currentTiming = currentEvent.timing;
    final nextEventIndex = currentTiming.eventIndexInBar + 1;
    if (nextEventIndex < currentTiming.eventsInBar) {
      final nextChangeBeat =
          currentTiming.changeBeat + currentTiming.durationBeats;
      return ChordTimingSpec(
        barIndex: currentTiming.barIndex,
        changeBeat: nextChangeBeat,
        durationBeats: settings.beatsPerBar - nextChangeBeat,
        beatsPerBar: settings.beatsPerBar,
        eventIndexInBar: nextEventIndex,
        eventsInBar: currentTiming.eventsInBar,
      );
    }

    final nextBarIndex = currentTiming.barIndex + 1;
    final changeBeats = changeBeatsForBar(
      settings: settings,
      barIndex: nextBarIndex,
      anchorLoop: anchorLoop,
    );
    return _timingForSlot(
      changeBeats: changeBeats,
      slotIndex: 0,
      barIndex: nextBarIndex,
      beatsPerBar: settings.beatsPerBar,
    );
  }

  static List<int> changeBeatsForBar({
    required PracticeSettings settings,
    required int barIndex,
    ChordAnchorLoop? anchorLoop,
  }) {
    final defaultTemplate = _templateForBar(
      settings: settings,
      barIndex: barIndex,
    );
    final sanitizedLoop = anchorLoop == null
        ? null
        : AnchorLoopLayout.sanitizeLoop(
            loop: anchorLoop,
            timeSignature: settings.timeSignature,
            harmonicRhythmPreset: settings.harmonicRhythmPreset,
          );
    if (sanitizedLoop == null || !sanitizedLoop.hasEnabledSlots) {
      return defaultTemplate.changeBeats;
    }
    final validChangeBeats = AnchorLoopLayout.validChangeBeats(
      timeSignature: settings.timeSignature,
      harmonicRhythmPreset: settings.harmonicRhythmPreset,
    );
    final forcedChangeBeats = <int>[];
    for (
      var slotIndex = 0;
      slotIndex < validChangeBeats.length;
      slotIndex += 1
    ) {
      final slot = sanitizedLoop.slotForPosition(
        barOffset: barIndex % sanitizedLoop.clampedCycleLengthBars,
        slotIndexWithinBar: slotIndex,
      );
      if (!(slot?.isActive ?? false)) {
        continue;
      }
      forcedChangeBeats.add(validChangeBeats[slotIndex]);
    }
    if (forcedChangeBeats.isEmpty) {
      return defaultTemplate.changeBeats;
    }
    final merged = <int>{
      ...defaultTemplate.changeBeats,
      ...forcedChangeBeats,
    }.toList(growable: false)..sort();
    return merged;
  }

  static ChordTimingSpec _timingForSlot({
    required List<int> changeBeats,
    required int slotIndex,
    required int barIndex,
    required int beatsPerBar,
  }) {
    final changeBeat = changeBeats[slotIndex];
    final nextChangeBeat = slotIndex + 1 < changeBeats.length
        ? changeBeats[slotIndex + 1]
        : beatsPerBar;
    return ChordTimingSpec(
      barIndex: barIndex,
      changeBeat: changeBeat,
      durationBeats: nextChangeBeat - changeBeat,
      beatsPerBar: beatsPerBar,
      eventIndexInBar: slotIndex,
      eventsInBar: changeBeats.length,
    );
  }

  static _BarRhythmTemplate _templateForBar({
    required PracticeSettings settings,
    required int barIndex,
  }) {
    final beatsPerBar = settings.beatsPerBar;
    final phraseContext = SmartPhraseContext.rollingForm(
      barIndex,
      timeSignature: settings.timeSignature,
      harmonicRhythmPreset: settings.harmonicRhythmPreset,
      barIndex: barIndex,
      changeBeat: 0,
      durationBeats: beatsPerBar,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );
    final cadenceWindow =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final turnaroundWindow =
        phraseContext.sectionRole == SectionRole.turnaroundTail ||
        phraseContext.sectionRole == SectionRole.tag;
    final bridgeFlow =
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        phraseContext.phraseRole == PhraseRole.continuation;

    return switch (settings.harmonicRhythmPreset) {
      HarmonicRhythmPreset.onePerBar => const _BarRhythmTemplate([0]),
      HarmonicRhythmPreset.twoPerBar => _twoPerBarTemplate(
        timeSignature: settings.timeSignature,
        cadenceWindow: cadenceWindow,
        turnaroundWindow: turnaroundWindow,
      ),
      HarmonicRhythmPreset.phraseAwareJazz => _phraseAwareTemplate(
        timeSignature: settings.timeSignature,
        cadenceWindow: cadenceWindow,
        turnaroundWindow: turnaroundWindow,
        bridgeFlow: bridgeFlow,
      ),
      HarmonicRhythmPreset.cadenceCompression => _cadenceCompressionTemplate(
        timeSignature: settings.timeSignature,
        cadenceWindow: cadenceWindow,
        turnaroundWindow: turnaroundWindow,
        bridgeFlow: bridgeFlow,
      ),
    };
  }

  static _BarRhythmTemplate _twoPerBarTemplate({
    required PracticeTimeSignature timeSignature,
    required bool cadenceWindow,
    required bool turnaroundWindow,
  }) {
    return switch (timeSignature) {
      PracticeTimeSignature.fourFour => const _BarRhythmTemplate([0, 2]),
      PracticeTimeSignature.threeFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 2])
            : const _BarRhythmTemplate([0]),
      PracticeTimeSignature.twoFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 1])
            : const _BarRhythmTemplate([0]),
    };
  }

  static _BarRhythmTemplate _phraseAwareTemplate({
    required PracticeTimeSignature timeSignature,
    required bool cadenceWindow,
    required bool turnaroundWindow,
    required bool bridgeFlow,
  }) {
    return switch (timeSignature) {
      PracticeTimeSignature.fourFour =>
        cadenceWindow || turnaroundWindow || bridgeFlow
            ? const _BarRhythmTemplate([0, 2])
            : const _BarRhythmTemplate([0]),
      PracticeTimeSignature.threeFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 2])
            : const _BarRhythmTemplate([0]),
      PracticeTimeSignature.twoFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 1])
            : const _BarRhythmTemplate([0]),
    };
  }

  static _BarRhythmTemplate _cadenceCompressionTemplate({
    required PracticeTimeSignature timeSignature,
    required bool cadenceWindow,
    required bool turnaroundWindow,
    required bool bridgeFlow,
  }) {
    return switch (timeSignature) {
      PracticeTimeSignature.fourFour =>
        turnaroundWindow || cadenceWindow
            ? const _BarRhythmTemplate([0, 3])
            : bridgeFlow
            ? const _BarRhythmTemplate([0, 2])
            : const _BarRhythmTemplate([0]),
      PracticeTimeSignature.threeFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 2])
            : const _BarRhythmTemplate([0]),
      PracticeTimeSignature.twoFour =>
        cadenceWindow || turnaroundWindow
            ? const _BarRhythmTemplate([0, 1])
            : const _BarRhythmTemplate([0]),
    };
  }
}

class _BarRhythmTemplate {
  const _BarRhythmTemplate(this.changeBeats);

  final List<int> changeBeats;
}
