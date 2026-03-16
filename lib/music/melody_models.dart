import 'chord_theory.dart';
import 'chord_timing_models.dart';
import '../settings/practice_settings.dart';
import 'melody_seed_util.dart';
import 'phrase_planner.dart';

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
    this.sourceCategoryKey,
    this.strongSlot = false,
  }) : assert(durationBeats > 0);

  final int midiNote;
  final double startBeatOffset;
  final double durationBeats;
  final MelodyNoteRole role;
  final int velocity;
  final double gain;
  final String? toneLabel;
  final bool structural;
  final String? sourceCategoryKey;
  final bool strongSlot;

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
    String? sourceCategoryKey,
    bool? strongSlot,
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
      sourceCategoryKey: sourceCategoryKey ?? this.sourceCategoryKey,
      strongSlot: strongSlot ?? this.strongSlot,
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
    this.phraseRole,
    this.phraseCenterMidi,
    this.phraseApexMidi,
    this.phraseApexPos01,
    this.phraseEventStartPos01,
    this.phraseEventEndPos01,
    this.phraseEndingDegreePriority,
    this.phraseCadenceHoldMultiplier,
    this.phraseTargetNovelty01,
    this.phraseTargetColorExposure01,
  });

  final GeneratedChordEvent chordEvent;
  final List<GeneratedMelodyNote> notes;
  final String motifSignature;
  final List<int> contourSignature;
  final int? anchorMidiNote;
  final int? arrivalMidiNote;
  final PhraseRole? phraseRole;
  final int? phraseCenterMidi;
  final int? phraseApexMidi;
  final double? phraseApexPos01;
  final double? phraseEventStartPos01;
  final double? phraseEventEndPos01;
  final int? phraseEndingDegreePriority;
  final double? phraseCadenceHoldMultiplier;
  final double? phraseTargetNovelty01;
  final double? phraseTargetColorExposure01;

  bool get isEmpty => notes.isEmpty;
  GeneratedMelodyNote? get firstNote => notes.isEmpty ? null : notes.first;
  GeneratedMelodyNote? get lastNote => notes.isEmpty ? null : notes.last;
  int? get lastMidiNote => lastNote?.midiNote;
  String get eventSignatureKey => notes
      .map(
        (note) =>
            '${note.midiNote}@${note.startBeatOffset.toStringAsFixed(2)}:${note.durationBeats.toStringAsFixed(2)}:${note.toneLabel ?? ''}',
      )
      .join('|');
  List<int> get intervalVector => contourSignature.isNotEmpty
      ? contourSignature
      : <int>[
          for (var index = 1; index < notes.length; index += 1)
            notes[index].midiNote - notes[index - 1].midiNote,
        ];
  String get intervalSignatureKey => intervalVector.join(',');
  String get rhythmSignatureKey =>
      notes.map((note) => note.durationBeats.toStringAsFixed(2)).join(',');
  int get signatureHash => MelodySeedUtil.stableHashAll(<Object?>[
    motifSignature,
    contourSignature,
    eventSignatureKey,
  ]);
  int? get lastMidiNoteBucket =>
      lastMidiNote == null ? null : lastMidiNote! ~/ 3;

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
    PhraseRole? phraseRole,
    int? phraseCenterMidi,
    int? phraseApexMidi,
    double? phraseApexPos01,
    double? phraseEventStartPos01,
    double? phraseEventEndPos01,
    int? phraseEndingDegreePriority,
    double? phraseCadenceHoldMultiplier,
    double? phraseTargetNovelty01,
    double? phraseTargetColorExposure01,
  }) {
    return GeneratedMelodyEvent(
      chordEvent: chordEvent ?? this.chordEvent,
      notes: notes ?? this.notes,
      motifSignature: motifSignature ?? this.motifSignature,
      contourSignature: contourSignature ?? this.contourSignature,
      anchorMidiNote: anchorMidiNote ?? this.anchorMidiNote,
      arrivalMidiNote: arrivalMidiNote ?? this.arrivalMidiNote,
      phraseRole: phraseRole ?? this.phraseRole,
      phraseCenterMidi: phraseCenterMidi ?? this.phraseCenterMidi,
      phraseApexMidi: phraseApexMidi ?? this.phraseApexMidi,
      phraseApexPos01: phraseApexPos01 ?? this.phraseApexPos01,
      phraseEventStartPos01:
          phraseEventStartPos01 ?? this.phraseEventStartPos01,
      phraseEventEndPos01: phraseEventEndPos01 ?? this.phraseEventEndPos01,
      phraseEndingDegreePriority:
          phraseEndingDegreePriority ?? this.phraseEndingDegreePriority,
      phraseCadenceHoldMultiplier:
          phraseCadenceHoldMultiplier ?? this.phraseCadenceHoldMultiplier,
      phraseTargetNovelty01:
          phraseTargetNovelty01 ?? this.phraseTargetNovelty01,
      phraseTargetColorExposure01:
          phraseTargetColorExposure01 ?? this.phraseTargetColorExposure01,
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
    this.lookAheadChordEvent,
    this.previousMelodyEvent,
    this.recentMelodyEvents = const <GeneratedMelodyEvent>[],
    this.phraseChordWindow = const <GeneratedChordEvent>[],
    this.phraseWindowIndex,
  });

  final GeneratedChordEvent chordEvent;
  final GeneratedChordEvent? previousChordEvent;
  final GeneratedChordEvent? nextChordEvent;
  final GeneratedChordEvent? lookAheadChordEvent;
  final GeneratedMelodyEvent? previousMelodyEvent;
  final List<GeneratedMelodyEvent> recentMelodyEvents;
  final List<GeneratedChordEvent> phraseChordWindow;
  final int? phraseWindowIndex;
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
