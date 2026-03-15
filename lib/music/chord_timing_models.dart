import 'chord_theory.dart';

class ChordTimingSpec {
  const ChordTimingSpec({
    required this.barIndex,
    required this.changeBeat,
    required this.durationBeats,
    required this.beatsPerBar,
    required this.eventIndexInBar,
    required this.eventsInBar,
  }) : assert(barIndex >= 0),
       assert(changeBeat >= 0),
       assert(durationBeats > 0),
       assert(beatsPerBar > 0),
       assert(eventIndexInBar >= 0),
       assert(eventsInBar > 0);

  final int barIndex;
  final int changeBeat;
  final int durationBeats;
  final int beatsPerBar;
  final int eventIndexInBar;
  final int eventsInBar;

  int get endBeatExclusive => changeBeat + durationBeats;
  bool get isBarStart => changeBeat == 0;
  bool get isWeakBeatChange => changeBeat > 0;
  bool get isAnticipationBeat => changeBeat == beatsPerBar - 1;
  int get displayedBeatNumber => changeBeat + 1;

  ChordTimingSpec copyWith({
    int? barIndex,
    int? changeBeat,
    int? durationBeats,
    int? beatsPerBar,
    int? eventIndexInBar,
    int? eventsInBar,
  }) {
    return ChordTimingSpec(
      barIndex: barIndex ?? this.barIndex,
      changeBeat: changeBeat ?? this.changeBeat,
      durationBeats: durationBeats ?? this.durationBeats,
      beatsPerBar: beatsPerBar ?? this.beatsPerBar,
      eventIndexInBar: eventIndexInBar ?? this.eventIndexInBar,
      eventsInBar: eventsInBar ?? this.eventsInBar,
    );
  }
}

class GeneratedChordEvent {
  const GeneratedChordEvent({
    required this.chord,
    required this.timing,
    this.displaySymbolOverride,
  });

  final GeneratedChord chord;
  final ChordTimingSpec timing;
  final String? displaySymbolOverride;

  GeneratedChordEvent copyWith({
    GeneratedChord? chord,
    ChordTimingSpec? timing,
    String? displaySymbolOverride,
    bool clearDisplaySymbolOverride = false,
  }) {
    return GeneratedChordEvent(
      chord: chord ?? this.chord,
      timing: timing ?? this.timing,
      displaySymbolOverride: clearDisplaySymbolOverride
          ? null
          : displaySymbolOverride ?? this.displaySymbolOverride,
    );
  }
}
