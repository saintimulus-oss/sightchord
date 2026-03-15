import '../settings/practice_settings.dart';
import 'anchor_loop_layout.dart';
import 'chord_anchor_loop.dart';
import 'chord_theory.dart';
import 'chord_timing_models.dart';
import 'harmonic_rhythm_planner.dart';
import 'progression_analysis_models.dart';
import 'progression_analyzer.dart';
import 'progression_parser.dart';

class AnchorLoopSlotTiming {
  const AnchorLoopSlotTiming({
    required this.barOffset,
    required this.slotIndexWithinBar,
    required this.changeBeat,
    required this.durationBeats,
    required this.eventsInBar,
  });

  final int barOffset;
  final int slotIndexWithinBar;
  final int changeBeat;
  final int durationBeats;
  final int eventsInBar;

  String get storageKey => '$barOffset:$slotIndexWithinBar';
}

class AnchorLoopSlotPlan {
  const AnchorLoopSlotPlan({
    required this.timing,
    this.anchorSlot,
    this.primaryAnalysis,
    this.parsedAnchorChord,
  });

  final AnchorLoopSlotTiming timing;
  final ChordAnchorSlot? anchorSlot;
  final AnalyzedChord? primaryAnalysis;
  final ParsedChord? parsedAnchorChord;

  bool get isAnchor => anchorSlot?.isActive ?? false;
  bool get hasAnalysis => primaryAnalysis != null;

  List<ChordInterpretationCandidate> get compatibleAlternatives {
    final analysis = primaryAnalysis;
    if (analysis == null) {
      return const <ChordInterpretationCandidate>[];
    }
    return [
      for (final candidate in analysis.competingInterpretations)
        if (candidate.harmonicFunction == analysis.harmonicFunction &&
            candidate.romanNumeralId != null)
          candidate,
    ];
  }
}

class AnchorCyclePlan {
  const AnchorCyclePlan({
    required this.loop,
    required this.seedKeyCenter,
    required this.analysisKeyCenter,
    required this.slots,
  });

  final ChordAnchorLoop loop;
  final KeyCenter? seedKeyCenter;
  final KeyCenter? analysisKeyCenter;
  final List<AnchorLoopSlotPlan> slots;

  AnchorLoopSlotPlan? planForTiming(ChordTimingSpec timing) {
    final barOffset = timing.barIndex % loop.clampedCycleLengthBars;
    for (final slot in slots) {
      if (slot.timing.barOffset == barOffset &&
          slot.timing.slotIndexWithinBar == timing.eventIndexInBar) {
        return slot;
      }
    }
    return null;
  }

  List<int> changeBeatsForBar(int barOffset) {
    final beats = <int>[
      for (final slot in slots)
        if (slot.timing.barOffset == barOffset) slot.timing.changeBeat,
    ]..sort();
    return beats;
  }
}

class AnchorLoopPlanner {
  const AnchorLoopPlanner({
    this.parser = const ProgressionParser(),
    this.analyzer = const ProgressionAnalyzer(),
  });

  final ProgressionParser parser;
  final ProgressionAnalyzer analyzer;

  ParsedChord? tryParseChordSymbol(String symbol) {
    final parsed = parser.parse(symbol);
    if (parsed.tokens.length != 1 || parsed.validChords.length != 1) {
      return null;
    }
    if (parsed.issues.isNotEmpty || parsed.placeholders.isNotEmpty) {
      return null;
    }
    return parsed.validChords.single;
  }

  AnchorCyclePlan? buildCyclePlan({
    required PracticeSettings settings,
    required ChordAnchorLoop loop,
    KeyCenter? seedKeyCenter,
  }) {
    final sanitized = AnchorLoopLayout.sanitizeLoop(
      loop: loop,
      timeSignature: settings.timeSignature,
      harmonicRhythmPreset: settings.harmonicRhythmPreset,
    );
    if (!sanitized.hasEnabledSlots) {
      return null;
    }

    final singleCycleSlots = <AnchorLoopSlotPlan>[];
    final measures = <List<String>>[];
    final slotMeasureIndices = <String, (int measureIndex, int position)>{};

    for (
      var barOffset = 0;
      barOffset < sanitized.clampedCycleLengthBars;
      barOffset += 1
    ) {
      final changeBeats = HarmonicRhythmPlanner.changeBeatsForBar(
        settings: settings,
        barIndex: barOffset,
        anchorLoop: sanitized,
      );
      final barTimings = [
        for (var slotIndex = 0; slotIndex < changeBeats.length; slotIndex += 1)
          AnchorLoopSlotTiming(
            barOffset: barOffset,
            slotIndexWithinBar: slotIndex,
            changeBeat: changeBeats[slotIndex],
            durationBeats:
                (slotIndex + 1 < changeBeats.length
                    ? changeBeats[slotIndex + 1]
                    : settings.beatsPerBar) -
                changeBeats[slotIndex],
            eventsInBar: changeBeats.length,
          ),
      ];
      final tokens = <String>[];
      for (final timing in barTimings) {
        final slot = sanitized.slotForPosition(
          barOffset: barOffset,
          slotIndexWithinBar: timing.slotIndexWithinBar,
        );
        final parsedAnchor = slot == null || !slot.isActive
            ? null
            : tryParseChordSymbol(slot.trimmedChordSymbol);
        tokens.add(parsedAnchor?.sourceSymbol ?? '?');
        slotMeasureIndices[timing.storageKey] = (barOffset, tokens.length - 1);
        singleCycleSlots.add(
          AnchorLoopSlotPlan(
            timing: timing,
            anchorSlot: slot,
            parsedAnchorChord: parsedAnchor,
          ),
        );
      }
      measures.add(tokens);
    }
    if (!singleCycleSlots.any((slot) => slot.parsedAnchorChord != null)) {
      return null;
    }

    final repeatedMeasures = <List<String>>[];
    final seedSymbol = seedKeyCenter == null
        ? null
        : _tonicSeedSymbolForKeyCenter(seedKeyCenter);
    if (seedSymbol != null) {
      repeatedMeasures.add(<String>[seedSymbol]);
    }
    for (var cycleIndex = 0; cycleIndex < 3; cycleIndex += 1) {
      for (final measure in measures) {
        repeatedMeasures.add(List<String>.from(measure));
      }
    }
    if (seedSymbol != null) {
      repeatedMeasures.add(<String>[seedSymbol]);
    }

    final input = repeatedMeasures
        .map((measure) => measure.join(' '))
        .join(' | ');
    final analysis = analyzer.analyze(input);
    final analysisByMeasurePosition = <String, AnalyzedChord>{};
    for (final analyzedChord in analysis.chordAnalyses) {
      analysisByMeasurePosition['${analyzedChord.chord.measureIndex}:${analyzedChord.chord.positionInMeasure}'] =
          analyzedChord;
    }

    final middleCycleIndex = 1;
    final middleCycleMeasureOffset =
        (seedSymbol == null ? 0 : 1) +
        (middleCycleIndex * sanitized.clampedCycleLengthBars);
    final resolvedPlans = <AnchorLoopSlotPlan>[];

    for (final slot in singleCycleSlots) {
      final location = slotMeasureIndices[slot.timing.storageKey];
      if (location == null) {
        resolvedPlans.add(slot);
        continue;
      }
      final analysisKey =
          '${middleCycleMeasureOffset + location.$1}:${location.$2}';
      resolvedPlans.add(
        AnchorLoopSlotPlan(
          timing: slot.timing,
          anchorSlot: slot.anchorSlot,
          parsedAnchorChord: slot.parsedAnchorChord,
          primaryAnalysis: analysisByMeasurePosition[analysisKey],
        ),
      );
    }

    return AnchorCyclePlan(
      loop: sanitized,
      seedKeyCenter: seedKeyCenter,
      analysisKeyCenter: analysis.primaryKey.keyCenter,
      slots: resolvedPlans,
    );
  }

  String? _tonicSeedSymbolForKeyCenter(KeyCenter keyCenter) {
    final tonicRoman = keyCenter.mode == KeyMode.major
        ? RomanNumeralId.iMaj7
        : RomanNumeralId.iMin6;
    final root = MusicTheory.resolveChordRootForCenter(keyCenter, tonicRoman);
    return keyCenter.mode == KeyMode.major ? '${root}maj7' : '${root}m6';
  }
}
