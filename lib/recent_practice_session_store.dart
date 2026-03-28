import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'music/chord_theory.dart';
import 'music/chord_timing_models.dart';
import 'music/melody_models.dart';
import 'music/phrase_planner.dart';
import 'music/practice_chord_queue_state.dart';
import 'practice/practice_session_state.dart';

typedef RecentPracticeSessionPreferencesLoader =
    Future<SharedPreferences> Function();

class RecentPracticeSessionSnapshot {
  const RecentPracticeSessionSnapshot({
    required this.queueState,
    required this.melodyState,
    required this.currentBeat,
    required this.melodyGenerationSeed,
    required this.savedAt,
  });

  factory RecentPracticeSessionSnapshot.fromJson(Map<String, Object?> json) {
    return RecentPracticeSessionSnapshot(
      queueState: PracticeChordQueueState(
        previousEvent: _generatedChordEventFromJson(
          json['previousChordEvent'] as Map?,
        ),
        currentEvent: _generatedChordEventFromJson(
          json['currentChordEvent'] as Map?,
        ),
        nextEvent: _generatedChordEventFromJson(json['nextChordEvent'] as Map?),
        lookAheadEvent: _generatedChordEventFromJson(
          json['lookAheadChordEvent'] as Map?,
        ),
      ),
      melodyState: PracticeMelodyQueueState(
        previousEvent: _generatedMelodyEventFromJson(
          json['previousMelodyEvent'] as Map?,
        ),
        currentEvent: _generatedMelodyEventFromJson(
          json['currentMelodyEvent'] as Map?,
        ),
        nextEvent: _generatedMelodyEventFromJson(
          json['nextMelodyEvent'] as Map?,
        ),
        lookAheadEvent: _generatedMelodyEventFromJson(
          json['lookAheadMelodyEvent'] as Map?,
        ),
      ),
      currentBeat: json['currentBeat'] as int?,
      melodyGenerationSeed: json['melodyGenerationSeed'] as int? ?? 0,
      savedAt: DateTime.fromMillisecondsSinceEpoch(
        json['savedAtEpochMs'] as int? ?? 0,
      ),
    );
  }

  final PracticeChordQueueState queueState;
  final PracticeMelodyQueueState melodyState;
  final int? currentBeat;
  final int melodyGenerationSeed;
  final DateTime savedAt;

  bool get hasVisibleLoop =>
      queueState.currentEvent != null ||
      queueState.nextEvent != null ||
      queueState.lookAheadEvent != null;

  PracticeSessionState toSessionState() {
    return PracticeSessionState(initialized: true, queueState: queueState);
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'previousChordEvent': _generatedChordEventToJson(
        queueState.previousEvent,
      ),
      'currentChordEvent': _generatedChordEventToJson(queueState.currentEvent),
      'nextChordEvent': _generatedChordEventToJson(queueState.nextEvent),
      'lookAheadChordEvent': _generatedChordEventToJson(
        queueState.lookAheadEvent,
      ),
      'previousMelodyEvent': _generatedMelodyEventToJson(
        melodyState.previousEvent,
      ),
      'currentMelodyEvent': _generatedMelodyEventToJson(
        melodyState.currentEvent,
      ),
      'nextMelodyEvent': _generatedMelodyEventToJson(melodyState.nextEvent),
      'lookAheadMelodyEvent': _generatedMelodyEventToJson(
        melodyState.lookAheadEvent,
      ),
      'currentBeat': currentBeat,
      'melodyGenerationSeed': melodyGenerationSeed,
      'savedAtEpochMs': savedAt.millisecondsSinceEpoch,
    };
  }

  String toStorageString() => jsonEncode(toJson());

  static RecentPracticeSessionSnapshot? fromStorageString(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }
      final snapshot = RecentPracticeSessionSnapshot.fromJson(
        Map<String, Object?>.from(decoded),
      );
      return snapshot.hasVisibleLoop ? snapshot : null;
    } catch (_) {
      return null;
    }
  }

  static Map<String, Object?>? _generatedChordEventToJson(
    GeneratedChordEvent? event,
  ) {
    if (event == null) {
      return null;
    }
    return <String, Object?>{
      'chord': _generatedChordToJson(event.chord),
      'timing': _chordTimingSpecToJson(event.timing),
      'displaySymbolOverride': event.displaySymbolOverride,
    };
  }

  static GeneratedChordEvent? _generatedChordEventFromJson(Map? json) {
    if (json == null) {
      return null;
    }
    final map = Map<String, Object?>.from(json);
    final chord = _generatedChordFromJson(map['chord'] as Map?);
    final timing = _chordTimingSpecFromJson(map['timing'] as Map?);
    if (chord == null || timing == null) {
      return null;
    }
    return GeneratedChordEvent(
      chord: chord,
      timing: timing,
      displaySymbolOverride: map['displaySymbolOverride'] as String?,
    );
  }

  static Map<String, Object?> _generatedChordToJson(GeneratedChord chord) {
    return <String, Object?>{
      'symbolData': _chordSymbolDataToJson(chord.symbolData),
      'repeatGuardKey': chord.repeatGuardKey,
      'harmonicComparisonKey': chord.harmonicComparisonKey,
      'keyName': chord.keyName,
      'keyCenter': chord.keyCenter?.serialize(),
      'romanNumeralId': chord.romanNumeralId?.name,
      'resolutionRomanNumeralId': chord.resolutionRomanNumeralId?.name,
      'harmonicFunction': chord.harmonicFunction.name,
      'patternTag': chord.patternTag,
      'plannedChordKind': chord.plannedChordKind.name,
      'sourceKind': chord.sourceKind.name,
      'appliedType': chord.appliedType?.name,
      'resolutionTargetRomanId': chord.resolutionTargetRomanId?.name,
      'dominantContext': chord.dominantContext?.name,
      'dominantIntent': chord.dominantIntent?.name,
      'modulationKind': chord.modulationKind.name,
      'wasExcludedFallback': chord.wasExcludedFallback,
      'isRenderedNonDiatonic': chord.isRenderedNonDiatonic,
    };
  }

  static GeneratedChord? _generatedChordFromJson(Map? json) {
    if (json == null) {
      return null;
    }
    final map = Map<String, Object?>.from(json);
    final symbolData = _chordSymbolDataFromJson(map['symbolData'] as Map?);
    if (symbolData == null) {
      return null;
    }
    return GeneratedChord(
      symbolData: symbolData,
      repeatGuardKey: map['repeatGuardKey'] as String? ?? '',
      harmonicComparisonKey: map['harmonicComparisonKey'] as String? ?? '',
      keyName: map['keyName'] as String?,
      keyCenter: _parseKeyCenter(map['keyCenter'] as String?),
      romanNumeralId: _parseRomanNumeralId(map['romanNumeralId'] as String?),
      resolutionRomanNumeralId: _parseRomanNumeralId(
        map['resolutionRomanNumeralId'] as String?,
      ),
      harmonicFunction: HarmonicFunction.values.firstWhere(
        (value) => value.name == map['harmonicFunction'],
        orElse: () => HarmonicFunction.free,
      ),
      patternTag: map['patternTag'] as String?,
      plannedChordKind: PlannedChordKind.values.firstWhere(
        (value) => value.name == map['plannedChordKind'],
        orElse: () => PlannedChordKind.resolvedRoman,
      ),
      sourceKind: ChordSourceKind.values.firstWhere(
        (value) => value.name == map['sourceKind'],
        orElse: () => ChordSourceKind.free,
      ),
      appliedType: _firstWhereOrNull(
        AppliedType.values,
        (value) => value.name == map['appliedType'],
      ),
      resolutionTargetRomanId: _parseRomanNumeralId(
        map['resolutionTargetRomanId'] as String?,
      ),
      dominantContext: _firstWhereOrNull(
        DominantContext.values,
        (value) => value.name == map['dominantContext'],
      ),
      dominantIntent: _firstWhereOrNull(
        DominantIntent.values,
        (value) => value.name == map['dominantIntent'],
      ),
      modulationKind: ModulationKind.values.firstWhere(
        (value) => value.name == map['modulationKind'],
        orElse: () => ModulationKind.none,
      ),
      wasExcludedFallback: map['wasExcludedFallback'] as bool? ?? false,
      isRenderedNonDiatonic: map['isRenderedNonDiatonic'] as bool? ?? false,
    );
  }

  static Map<String, Object?> _chordSymbolDataToJson(
    ChordSymbolData symbolData,
  ) {
    return <String, Object?>{
      'root': symbolData.root,
      'harmonicQuality': symbolData.harmonicQuality.name,
      'renderQuality': symbolData.renderQuality.name,
      'tensions': symbolData.tensions,
      'bass': symbolData.bass,
    };
  }

  static ChordSymbolData? _chordSymbolDataFromJson(Map? json) {
    if (json == null) {
      return null;
    }
    final map = Map<String, Object?>.from(json);
    return ChordSymbolData(
      root: map['root'] as String? ?? 'C',
      harmonicQuality: ChordQuality.values.firstWhere(
        (value) => value.name == map['harmonicQuality'],
        orElse: () => ChordQuality.majorTriad,
      ),
      renderQuality: ChordQuality.values.firstWhere(
        (value) => value.name == map['renderQuality'],
        orElse: () => ChordQuality.majorTriad,
      ),
      tensions: (map['tensions'] as List<Object?>? ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
      bass: map['bass'] as String?,
    );
  }

  static Map<String, Object?> _chordTimingSpecToJson(ChordTimingSpec timing) {
    return <String, Object?>{
      'barIndex': timing.barIndex,
      'changeBeat': timing.changeBeat,
      'durationBeats': timing.durationBeats,
      'beatsPerBar': timing.beatsPerBar,
      'eventIndexInBar': timing.eventIndexInBar,
      'eventsInBar': timing.eventsInBar,
    };
  }

  static ChordTimingSpec? _chordTimingSpecFromJson(Map? json) {
    if (json == null) {
      return null;
    }
    final map = Map<String, Object?>.from(json);
    return ChordTimingSpec(
      barIndex: map['barIndex'] as int? ?? 0,
      changeBeat: map['changeBeat'] as int? ?? 0,
      durationBeats: map['durationBeats'] as int? ?? 4,
      beatsPerBar: map['beatsPerBar'] as int? ?? 4,
      eventIndexInBar: map['eventIndexInBar'] as int? ?? 0,
      eventsInBar: map['eventsInBar'] as int? ?? 1,
    );
  }

  static Map<String, Object?>? _generatedMelodyEventToJson(
    GeneratedMelodyEvent? event,
  ) {
    if (event == null) {
      return null;
    }
    return <String, Object?>{
      'chordEvent': _generatedChordEventToJson(event.chordEvent),
      'notes': [
        for (final note in event.notes) _generatedMelodyNoteToJson(note),
      ],
      'motifSignature': event.motifSignature,
      'contourSignature': event.contourSignature,
      'anchorMidiNote': event.anchorMidiNote,
      'arrivalMidiNote': event.arrivalMidiNote,
      'phraseRole': event.phraseRole?.name,
      'phraseCenterMidi': event.phraseCenterMidi,
      'phraseApexMidi': event.phraseApexMidi,
      'phraseApexPos01': event.phraseApexPos01,
      'phraseEventStartPos01': event.phraseEventStartPos01,
      'phraseEventEndPos01': event.phraseEventEndPos01,
      'phraseEndingDegreePriority': event.phraseEndingDegreePriority,
      'phraseCadenceHoldMultiplier': event.phraseCadenceHoldMultiplier,
      'phraseTargetNovelty01': event.phraseTargetNovelty01,
      'phraseTargetColorExposure01': event.phraseTargetColorExposure01,
      'sectionArcIndex': event.sectionArcIndex,
      'sectionArcSpan': event.sectionArcSpan,
      'sectionCenterLiftSemitones': event.sectionCenterLiftSemitones,
      'sectionApexLiftSemitones': event.sectionApexLiftSemitones,
    };
  }

  static GeneratedMelodyEvent? _generatedMelodyEventFromJson(Map? json) {
    if (json == null) {
      return null;
    }
    final map = Map<String, Object?>.from(json);
    final chordEvent = _generatedChordEventFromJson(map['chordEvent'] as Map?);
    if (chordEvent == null) {
      return null;
    }
    return GeneratedMelodyEvent(
      chordEvent: chordEvent,
      notes: (map['notes'] as List<Object?>? ?? const <Object?>[])
          .whereType<Map>()
          .map((note) => _generatedMelodyNoteFromJson(note))
          .toList(growable: false),
      motifSignature: map['motifSignature'] as String? ?? '',
      contourSignature:
          (map['contourSignature'] as List<Object?>? ?? const <Object?>[])
              .whereType<int>()
              .toList(growable: false),
      anchorMidiNote: map['anchorMidiNote'] as int?,
      arrivalMidiNote: map['arrivalMidiNote'] as int?,
      phraseRole: _firstWhereOrNull(
        PhraseRole.values,
        (value) => value.name == map['phraseRole'],
      ),
      phraseCenterMidi: map['phraseCenterMidi'] as int?,
      phraseApexMidi: map['phraseApexMidi'] as int?,
      phraseApexPos01: map['phraseApexPos01'] as double?,
      phraseEventStartPos01: map['phraseEventStartPos01'] as double?,
      phraseEventEndPos01: map['phraseEventEndPos01'] as double?,
      phraseEndingDegreePriority: map['phraseEndingDegreePriority'] as int?,
      phraseCadenceHoldMultiplier:
          map['phraseCadenceHoldMultiplier'] as double?,
      phraseTargetNovelty01: map['phraseTargetNovelty01'] as double?,
      phraseTargetColorExposure01:
          map['phraseTargetColorExposure01'] as double?,
      sectionArcIndex: map['sectionArcIndex'] as int?,
      sectionArcSpan: map['sectionArcSpan'] as int?,
      sectionCenterLiftSemitones: map['sectionCenterLiftSemitones'] as int?,
      sectionApexLiftSemitones: map['sectionApexLiftSemitones'] as int?,
    );
  }

  static Map<String, Object?> _generatedMelodyNoteToJson(
    GeneratedMelodyNote note,
  ) {
    return <String, Object?>{
      'midiNote': note.midiNote,
      'startBeatOffset': note.startBeatOffset,
      'durationBeats': note.durationBeats,
      'role': note.role.name,
      'velocity': note.velocity,
      'gain': note.gain,
      'toneLabel': note.toneLabel,
      'structural': note.structural,
      'sourceCategoryKey': note.sourceCategoryKey,
      'strongSlot': note.strongSlot,
    };
  }

  static GeneratedMelodyNote _generatedMelodyNoteFromJson(Map json) {
    final map = Map<String, Object?>.from(json);
    return GeneratedMelodyNote(
      midiNote: map['midiNote'] as int? ?? 60,
      startBeatOffset: (map['startBeatOffset'] as num? ?? 0).toDouble(),
      durationBeats: (map['durationBeats'] as num? ?? 1).toDouble(),
      role: MelodyNoteRole.values.firstWhere(
        (value) => value.name == map['role'],
        orElse: () => MelodyNoteRole.chordTone,
      ),
      velocity: map['velocity'] as int? ?? 92,
      gain: (map['gain'] as num? ?? 1).toDouble(),
      toneLabel: map['toneLabel'] as String?,
      structural: map['structural'] as bool? ?? false,
      sourceCategoryKey: map['sourceCategoryKey'] as String?,
      strongSlot: map['strongSlot'] as bool? ?? false,
    );
  }

  static KeyCenter? _parseKeyCenter(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return KeyCenter.fromSerialized(value);
  }

  static RomanNumeralId? _parseRomanNumeralId(String? value) {
    return _firstWhereOrNull(
      RomanNumeralId.values,
      (candidate) => candidate.name == value,
    );
  }

  static T? _firstWhereOrNull<T>(
    Iterable<T> values,
    bool Function(T value) predicate,
  ) {
    for (final value in values) {
      if (predicate(value)) {
        return value;
      }
    }
    return null;
  }
}

class RecentPracticeSessionStore {
  const RecentPracticeSessionStore({
    RecentPracticeSessionPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String snapshotKey = 'recent_practice_session_snapshot_v1';

  final RecentPracticeSessionPreferencesLoader _preferencesLoader;

  Future<RecentPracticeSessionSnapshot?> load() async {
    final preferences = await _preferencesLoader();
    return RecentPracticeSessionSnapshot.fromStorageString(
      preferences.getString(snapshotKey),
    );
  }

  Future<RecentPracticeSessionSnapshot?> save(
    RecentPracticeSessionSnapshot snapshot,
  ) async {
    final preferences = await _preferencesLoader();
    await preferences.setString(snapshotKey, snapshot.toStorageString());
    return load();
  }

  Future<void> clear() async {
    final preferences = await _preferencesLoader();
    await preferences.remove(snapshotKey);
  }
}
