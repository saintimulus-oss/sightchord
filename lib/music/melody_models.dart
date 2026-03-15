import 'chord_theory.dart';
import 'chord_timing_models.dart';
import '../settings/practice_settings.dart';

enum MelodyNoteRole {
  guideTone,
  chordTone,
  stableTension,
  passing,
  neighbor,
  approach,
  enclosure,
  anticipation,
}

class GeneratedMelodyNote {
  const GeneratedMelodyNote({
    required this.midiNote,
    required this.startBeatOffset,
    required this.durationBeats,
    required this.role,
    this.velocity = 92,
    this.gain = 1.0,
    this.toneLabel,
    this.structural = false,
  }) : assert(durationBeats > 0);

  final int midiNote;
  final double startBeatOffset;
  final double durationBeats;
  final MelodyNoteRole role;
  final int velocity;
  final double gain;
  final String? toneLabel;
  final bool structural;

  int get pitchClass => midiNote % 12;

  String displayLabel({required bool preferFlat}) {
    final pitch = MusicTheory.spellPitch(pitchClass, preferFlat: preferFlat);
    final octave = (midiNote ~/ 12) - 1;
    return '$pitch$octave';
  }

  GeneratedMelodyNote copyWith({
    int? midiNote,
    double? startBeatOffset,
    double? durationBeats,
    MelodyNoteRole? role,
    int? velocity,
    double? gain,
    String? toneLabel,
    bool? structural,
  }) {
    return GeneratedMelodyNote(
      midiNote: midiNote ?? this.midiNote,
      startBeatOffset: startBeatOffset ?? this.startBeatOffset,
      durationBeats: durationBeats ?? this.durationBeats,
      role: role ?? this.role,
      velocity: velocity ?? this.velocity,
      gain: gain ?? this.gain,
      toneLabel: toneLabel ?? this.toneLabel,
      structural: structural ?? this.structural,
    );
  }
}

class GeneratedMelodyEvent {
  const GeneratedMelodyEvent({
    required this.chordEvent,
    required this.notes,
    this.motifSignature = '',
    this.contourSignature = const <int>[],
    this.anchorMidiNote,
    this.arrivalMidiNote,
  });

  final GeneratedChordEvent chordEvent;
  final List<GeneratedMelodyNote> notes;
  final String motifSignature;
  final List<int> contourSignature;
  final int? anchorMidiNote;
  final int? arrivalMidiNote;

  bool get isEmpty => notes.isEmpty;
  GeneratedMelodyNote? get firstNote => notes.isEmpty ? null : notes.first;
  GeneratedMelodyNote? get lastNote => notes.isEmpty ? null : notes.last;
  int? get lastMidiNote => lastNote?.midiNote;

  String previewText({required bool preferFlat}) {
    return notes
        .map((note) => note.displayLabel(preferFlat: preferFlat))
        .join(' ');
  }

  GeneratedMelodyEvent copyWith({
    GeneratedChordEvent? chordEvent,
    List<GeneratedMelodyNote>? notes,
    String? motifSignature,
    List<int>? contourSignature,
    int? anchorMidiNote,
    int? arrivalMidiNote,
  }) {
    return GeneratedMelodyEvent(
      chordEvent: chordEvent ?? this.chordEvent,
      notes: notes ?? this.notes,
      motifSignature: motifSignature ?? this.motifSignature,
      contourSignature: contourSignature ?? this.contourSignature,
      anchorMidiNote: anchorMidiNote ?? this.anchorMidiNote,
      arrivalMidiNote: arrivalMidiNote ?? this.arrivalMidiNote,
    );
  }
}

class MelodyGenerationRequest {
  const MelodyGenerationRequest({
    required this.chordEvent,
    required this.settings,
    required this.seed,
    this.previousChordEvent,
    this.nextChordEvent,
    this.previousMelodyEvent,
  });

  final GeneratedChordEvent chordEvent;
  final GeneratedChordEvent? previousChordEvent;
  final GeneratedChordEvent? nextChordEvent;
  final GeneratedMelodyEvent? previousMelodyEvent;
  final PracticeSettings settings;
  final int seed;
}

class PracticeMelodyQueueState {
  const PracticeMelodyQueueState({
    this.previousEvent,
    this.currentEvent,
    this.nextEvent,
    this.lookAheadEvent,
  });

  final GeneratedMelodyEvent? previousEvent;
  final GeneratedMelodyEvent? currentEvent;
  final GeneratedMelodyEvent? nextEvent;
  final GeneratedMelodyEvent? lookAheadEvent;

  PracticeMelodyQueueState reset() => const PracticeMelodyQueueState();

  PracticeMelodyQueueState copyWith({
    Object? previousEvent = _retainField,
    Object? currentEvent = _retainField,
    Object? nextEvent = _retainField,
    Object? lookAheadEvent = _retainField,
  }) {
    return PracticeMelodyQueueState(
      previousEvent: switch (previousEvent) {
        _Sentinel() => this.previousEvent,
        _ClearField() => null,
        GeneratedMelodyEvent value => value,
        _ => this.previousEvent,
      },
      currentEvent: switch (currentEvent) {
        _Sentinel() => this.currentEvent,
        _ClearField() => null,
        GeneratedMelodyEvent value => value,
        _ => this.currentEvent,
      },
      nextEvent: switch (nextEvent) {
        _Sentinel() => this.nextEvent,
        _ClearField() => null,
        GeneratedMelodyEvent value => value,
        _ => this.nextEvent,
      },
      lookAheadEvent: switch (lookAheadEvent) {
        _Sentinel() => this.lookAheadEvent,
        _ClearField() => null,
        GeneratedMelodyEvent value => value,
        _ => this.lookAheadEvent,
      },
    );
  }
  static const _Sentinel _retainField = _Sentinel();
}

class _Sentinel {
  const _Sentinel();
}

class _ClearField {
  const _ClearField();
}
