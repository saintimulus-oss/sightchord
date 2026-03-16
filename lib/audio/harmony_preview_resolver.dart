import '../music/chord_theory.dart';
import '../music/progression_analysis_models.dart';
import '../music/progression_parser.dart';
import '../music/voicing_models.dart';
import '../study_harmony/domain/study_harmony_session_models.dart';
import 'harmony_audio_models.dart';

class HarmonyPreviewResolver {
  const HarmonyPreviewResolver._();

  static const Map<String, int> _toneSemitones = <String, int>{
    '1': 0,
    '2': 2,
    'b9': 1,
    '9': 2,
    '#9': 3,
    'b3': 3,
    '3': 4,
    '4': 5,
    '11': 5,
    '#11': 6,
    'b5': 6,
    '5': 7,
    '#5': 8,
    'b13': 8,
    '6': 9,
    '13': 9,
    'b7': 10,
    '7': 11,
  };

  static HarmonyChordClip fromVoicing(
    ConcreteVoicing voicing, {
    String? label,
  }) {
    final pairedCount = voicing.midiNotes.length < voicing.toneLabels.length
        ? voicing.midiNotes.length
        : voicing.toneLabels.length;
    final notes = <HarmonyPreviewNote>[
      for (var index = 0; index < pairedCount; index += 1)
        HarmonyPreviewNote(
          midiNote: voicing.midiNotes[index],
          gain: _gainForToneLabel(voicing.toneLabels[index]),
          toneLabel: voicing.toneLabels[index],
        ),
    ];
    return HarmonyChordClip(notes: notes, label: label);
  }

  static HarmonyChordClip fromGeneratedChord(
    GeneratedChord chord, {
    ConcreteVoicing? voicing,
    String? label,
  }) {
    final preferredVoicing = voicing;
    if (preferredVoicing != null) {
      return fromVoicing(
        preferredVoicing,
        label: label ?? chord.symbolData.root,
      );
    }
    return fromChordSymbolData(
      chord.symbolData,
      label: label ?? chord.analysisLabel,
    );
  }

  static HarmonyChordClip auditionClipForGeneratedChord(
    GeneratedChord chord, {
    ConcreteVoicing? preferredVoicing,
    String? label,
  }) {
    final resolvedLabel = label ?? chord.analysisLabel;
    final baseClip = fromChordSymbolData(
      chord.symbolData,
      label: resolvedLabel,
    );
    if (preferredVoicing == null) {
      return baseClip;
    }
    final allowedToneLabels = _orderedToneLabelsForSymbolData(
      chord.symbolData,
    ).toSet();
    final pairedCount =
        preferredVoicing.midiNotes.length < preferredVoicing.toneLabels.length
        ? preferredVoicing.midiNotes.length
        : preferredVoicing.toneLabels.length;

    final mergedNotes = <HarmonyPreviewNote>[
      for (final note in baseClip.notes)
        if (note.toneLabel == 'bass') note,
      for (var index = 0; index < pairedCount; index += 1)
        if (allowedToneLabels.contains(preferredVoicing.toneLabels[index]))
          HarmonyPreviewNote(
            midiNote: preferredVoicing.midiNotes[index],
            gain: _gainForToneLabel(preferredVoicing.toneLabels[index]),
            toneLabel: preferredVoicing.toneLabels[index],
          ),
    ];
    final mergedToneLabels = {for (final note in mergedNotes) ?note.toneLabel};
    for (final note in baseClip.notes) {
      final toneLabel = note.toneLabel;
      if (toneLabel == 'bass') {
        continue;
      }
      if (toneLabel != null && mergedToneLabels.contains(toneLabel)) {
        continue;
      }
      mergedNotes.add(note);
      if (toneLabel != null) {
        mergedToneLabels.add(toneLabel);
      }
    }
    return HarmonyChordClip(
      notes: _sortAndDeduplicateNotes(mergedNotes),
      label: resolvedLabel,
    );
  }

  static HarmonyChordClip fromParsedChord(
    ParsedChord chord, {
    String? label,
    int? previousBassMidi,
  }) {
    final rootSemitone = MusicTheory.noteToSemitone[chord.root];
    if (rootSemitone == null) {
      return const HarmonyChordClip(notes: <HarmonyPreviewNote>[]);
    }
    return _buildClip(
      rootSemitone: rootSemitone,
      bass: chord.bass,
      toneLabels: _orderedToneLabelsForParsedChord(chord),
      label: label ?? chord.sourceSymbol,
      previousBassMidi: previousBassMidi,
    );
  }

  static HarmonyChordClip fromChordSymbolData(
    ChordSymbolData symbolData, {
    String? label,
    int? previousBassMidi,
  }) {
    final rootSemitone = MusicTheory.noteToSemitone[symbolData.root];
    if (rootSemitone == null) {
      return const HarmonyChordClip(notes: <HarmonyPreviewNote>[]);
    }
    return _buildClip(
      rootSemitone: rootSemitone,
      bass: symbolData.bass,
      toneLabels: _orderedToneLabelsForSymbolData(symbolData),
      label: label,
      previousBassMidi: previousBassMidi,
    );
  }

  static List<HarmonyChordClip> progressionFromAnalysis(
    ProgressionAnalysis analysis,
  ) {
    final clips = <HarmonyChordClip>[];
    int? previousBassMidi;
    for (final chordAnalysis in analysis.chordAnalyses) {
      final clip = fromParsedChord(
        chordAnalysis.chord,
        label: chordAnalysis.resolvedSymbol,
        previousBassMidi: previousBassMidi,
      );
      clips.add(clip);
      previousBassMidi = _bassMidiOf(clip) ?? previousBassMidi;
    }
    return clips;
  }

  static List<HarmonyChordClip> progressionFromChordLabels(
    Iterable<String> chordLabels,
  ) {
    final visibleLabels = [
      for (final label in chordLabels)
        if (label.trim().isNotEmpty) label.trim(),
    ];
    if (visibleLabels.isEmpty) {
      return const <HarmonyChordClip>[];
    }
    final parseResult = const ProgressionParser().parse(
      visibleLabels.join(' '),
    );
    final clips = <HarmonyChordClip>[];
    int? previousBassMidi;
    for (final chord in parseResult.validChords) {
      final clip = fromParsedChord(chord, previousBassMidi: previousBassMidi);
      clips.add(clip);
      previousBassMidi = _bassMidiOf(clip) ?? previousBassMidi;
    }
    return clips;
  }

  static List<HarmonyChordClip> promptClipsForStudyTask(
    StudyHarmonyTaskInstance task,
  ) {
    if (task.prompt.showsPianoPreview &&
        task.prompt.highlightedAnswerIds.isNotEmpty) {
      final notes = <HarmonyPreviewNote>[
        for (final answerId in task.prompt.highlightedAnswerIds)
          if (_midiForStudyAnswerId(answerId) case final midi?)
            HarmonyPreviewNote(midiNote: midi, gain: 1.0),
      ];
      if (notes.isNotEmpty) {
        return <HarmonyChordClip>[HarmonyChordClip(notes: notes)];
      }
    }

    final progressionDisplay = task.prompt.progressionDisplay;
    if (progressionDisplay != null) {
      return progressionFromChordLabels(
        progressionDisplay.slots
            .where((slot) => !slot.isHidden)
            .map((slot) => slot.label),
      );
    }

    return const <HarmonyChordClip>[];
  }

  static HarmonyChordClip noteClipForStudyAnswerId(String answerId) {
    final midi = _midiForStudyAnswerId(answerId);
    if (midi == null) {
      return const HarmonyChordClip(notes: <HarmonyPreviewNote>[]);
    }
    return HarmonyChordClip(
      notes: <HarmonyPreviewNote>[HarmonyPreviewNote(midiNote: midi)],
    );
  }

  static HarmonyChordClip _buildClip({
    required int rootSemitone,
    required List<String> toneLabels,
    String? bass,
    String? label,
    int? previousBassMidi,
  }) {
    final notes = <HarmonyPreviewNote>[];
    final bassSemitone = bass == null
        ? rootSemitone
        : MusicTheory.noteToSemitone[bass];
    final bassMidi = bassSemitone == null
        ? null
        : _resolveBassMidi(
            pitchClass: bassSemitone,
            targetMidi: 41,
            minPitch: 36,
            maxPitch: 52,
            previousBassMidi: previousBassMidi,
          );
    if (bassMidi != null) {
      notes.add(
        HarmonyPreviewNote(midiNote: bassMidi, gain: 0.98, toneLabel: 'bass'),
      );
    }

    notes.addAll(
      _realizeUpperVoicing(
        rootSemitone: rootSemitone,
        toneLabels: toneLabels,
        minPitch: bassMidi == null ? 43 : bassMidi + 5,
        bassCarriesRoot: bassSemitone == rootSemitone,
      ),
    );
    return HarmonyChordClip(
      notes: _sortAndDeduplicateNotes(notes),
      label: label,
    );
  }

  static List<HarmonyPreviewNote> _sortAndDeduplicateNotes(
    Iterable<HarmonyPreviewNote> notes,
  ) {
    final byMidi = <int, HarmonyPreviewNote>{};
    for (final note in notes) {
      final existing = byMidi[note.midiNote];
      if (existing == null || _shouldPreferNote(note, existing)) {
        byMidi[note.midiNote] = note;
      }
    }
    final ordered = byMidi.values.toList(growable: false);
    ordered.sort((left, right) => left.midiNote.compareTo(right.midiNote));
    return ordered;
  }

  static bool _shouldPreferNote(
    HarmonyPreviewNote candidate,
    HarmonyPreviewNote existing,
  ) {
    if (candidate.toneLabel == 'bass' && existing.toneLabel != 'bass') {
      return true;
    }
    if (existing.toneLabel == 'bass' && candidate.toneLabel != 'bass') {
      return false;
    }
    return candidate.gain >= existing.gain;
  }

  static List<String> _orderedToneLabelsForSymbolData(
    ChordSymbolData symbolData,
  ) {
    final labels = <String>[
      ...?_baseToneLabelsByQuality[symbolData.renderQuality],
    ];
    for (final tension in symbolData.tensions) {
      _appendToneLabel(labels, tension);
    }
    return _limitToneLabels(labels, maxToneCount: 6);
  }

  static List<String> _orderedToneLabelsForParsedChord(ParsedChord chord) {
    final labels = <String>[...?_baseToneLabelsByQuality[chord.displayQuality]];

    _applySuspensions(labels, chord.suspensions);
    for (final addedTone in chord.addedTones) {
      _appendToneLabel(labels, addedTone);
    }
    for (final tension in chord.tensions) {
      _appendToneLabel(labels, tension);
    }
    for (final alteration in chord.alterations) {
      if (alteration == 'alt') {
        for (final defaultTone in _defaultAltToneLabels) {
          _appendToneLabel(labels, defaultTone);
        }
        continue;
      }
      _appendToneLabel(labels, alteration);
    }
    _applyOmissions(labels, chord.omittedTones);
    return _limitToneLabels(labels, maxToneCount: 7, dropFifthFirst: false);
  }

  static void _applySuspensions(List<String> labels, List<String> suspensions) {
    if (suspensions.isEmpty) {
      return;
    }
    labels.removeWhere((label) => label == '3' || label == 'b3');
    for (final suspension in suspensions) {
      final normalized = switch (suspension.trim()) {
        '2' => '2',
        '4' => '4',
        _ => null,
      };
      if (normalized != null && !labels.contains(normalized)) {
        labels.add(normalized);
      }
    }
  }

  static void _applyOmissions(List<String> labels, List<String> omittedTones) {
    for (final omission in omittedTones) {
      switch (omission.trim()) {
        case '1':
          labels.removeWhere((label) => label == '1');
        case '3':
          labels.removeWhere((label) => label == '3' || label == 'b3');
        case '5':
          labels.removeWhere(
            (label) => label == '5' || label == 'b5' || label == '#5',
          );
        case '7':
          labels.removeWhere(
            (label) => label == '7' || label == 'b7' || label == '6',
          );
        case '9':
          labels.removeWhere(
            (label) =>
                label == '2' || label == '9' || label == 'b9' || label == '#9',
          );
        case '11':
          labels.removeWhere((label) => label == '11' || label == '#11');
        case '13':
          labels.removeWhere(
            (label) => label == '6' || label == '13' || label == 'b13',
          );
      }
    }
  }

  static void _appendToneLabel(List<String> labels, String rawToneLabel) {
    final toneLabel = _normalizeToneLabel(rawToneLabel);
    if (toneLabel == null) {
      return;
    }
    final conflicts = _toneConflicts[toneLabel];
    if (conflicts != null) {
      labels.removeWhere(
        (existingLabel) =>
            existingLabel != toneLabel && conflicts.contains(existingLabel),
      );
    }
    if (!labels.contains(toneLabel)) {
      labels.add(toneLabel);
    }
  }

  static String? _normalizeToneLabel(String rawToneLabel) {
    final trimmed = rawToneLabel.trim();
    if (trimmed.isEmpty || trimmed == 'alt') {
      return null;
    }
    return switch (trimmed) {
      'b2' => 'b9',
      '2' => '2',
      '#2' => '#9',
      '#4' => '#11',
      _ when _toneSemitones.containsKey(trimmed) => trimmed,
      _ => null,
    };
  }

  static List<String> _limitToneLabels(
    List<String> labels, {
    required int maxToneCount,
    bool dropFifthFirst = true,
  }) {
    final limited = labels.toList(growable: true);
    if (dropFifthFirst && limited.length > maxToneCount) {
      limited.removeWhere(
        (label) => label == '5' || label == 'b5' || label == '#5',
      );
    }
    if (limited.length <= maxToneCount) {
      return limited;
    }
    return limited.take(maxToneCount).toList(growable: false);
  }

  static List<HarmonyPreviewNote> _realizeUpperVoicing({
    required int rootSemitone,
    required List<String> toneLabels,
    required int minPitch,
    required bool bassCarriesRoot,
  }) {
    const targets = <int>[48, 52, 55, 60, 64, 67, 71, 74];
    final notes = <HarmonyPreviewNote>[];
    var workingMinPitch = minPitch;
    var targetIndex = 0;

    void addLabel(String label) {
      final semitone = _toneSemitones[label];
      if (semitone == null) {
        return;
      }
      final pitchClass = (rootSemitone + semitone) % 12;
      final targetMidi =
          targets[targetIndex < targets.length
              ? targetIndex
              : targets.length - 1];
      final midi = _nearestMidiForPitchClass(
        pitchClass: pitchClass,
        targetMidi: targetMidi,
        minPitch: workingMinPitch,
        maxPitch: 84,
      );
      if (midi == null) {
        return;
      }
      notes.add(
        HarmonyPreviewNote(
          midiNote: midi,
          gain: _gainForToneLabel(label),
          toneLabel: label,
        ),
      );
      workingMinPitch = midi + _minimumGap(label);
      targetIndex += 1;
    }

    if (toneLabels.length <= 4) {
      for (final label in toneLabels) {
        addLabel(label);
      }
      return notes;
    }

    final remainingLabels = toneLabels.toList(growable: true);
    if (bassCarriesRoot && remainingLabels.length > 4) {
      remainingLabels.remove('1');
    }

    final densePriorityOrder = bassCarriesRoot
        ? const <String>['3', 'b3', '7', 'b7', '4', '5', 'b5', '#5', '6']
        : const <String>['1', '3', 'b3', '7', 'b7', '4', '5', 'b5', '#5', '6'];
    for (final label in densePriorityOrder) {
      if (!remainingLabels.remove(label)) {
        continue;
      }
      addLabel(label);
    }

    while (remainingLabels.isNotEmpty) {
      final nextLabel = _nextDenseToneLabel(
        rootSemitone: rootSemitone,
        toneLabels: remainingLabels,
        minPitch: workingMinPitch,
      );
      if (nextLabel == null) {
        break;
      }
      remainingLabels.remove(nextLabel);
      addLabel(nextLabel);
    }
    return notes;
  }

  static int _minimumGap(String toneLabel) {
    if (toneLabel == '1') {
      return 4;
    }
    if (_tensionLabels.contains(toneLabel)) {
      return 2;
    }
    return 3;
  }

  static double _gainForToneLabel(String? toneLabel) {
    return switch (toneLabel) {
      '3' || 'b3' || '7' || 'b7' || '6' => 1.06,
      '5' || 'b5' || '#5' => 0.84,
      '9' || 'b9' || '#9' || '11' || '#11' || '13' || 'b13' => 0.95,
      'bass' => 0.98,
      _ => 1.0,
    };
  }

  static int? _nearestMidiForPitchClass({
    required int pitchClass,
    required int targetMidi,
    required int minPitch,
    required int maxPitch,
  }) {
    int? bestMidi;
    var bestDistance = 999;
    for (var octave = 1; octave <= 8; octave += 1) {
      final candidate = pitchClass + (octave * 12);
      if (candidate < minPitch || candidate > maxPitch) {
        continue;
      }
      final distance = (candidate - targetMidi).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMidi = candidate;
      }
    }
    return bestMidi;
  }

  static String? _nextDenseToneLabel({
    required int rootSemitone,
    required List<String> toneLabels,
    required int minPitch,
  }) {
    String? bestLabel;
    var bestMidi = 999;
    for (final label in toneLabels) {
      final semitone = _toneSemitones[label];
      if (semitone == null) {
        continue;
      }
      final pitchClass = (rootSemitone + semitone) % 12;
      final midi = _lowestMidiForPitchClassAtOrAbove(
        pitchClass: pitchClass,
        minPitch: minPitch,
        maxPitch: 84,
      );
      if (midi == null) {
        continue;
      }
      if (midi < bestMidi) {
        bestMidi = midi;
        bestLabel = label;
      }
    }
    return bestLabel;
  }

  static int? _lowestMidiForPitchClassAtOrAbove({
    required int pitchClass,
    required int minPitch,
    required int maxPitch,
  }) {
    for (var octave = 1; octave <= 8; octave += 1) {
      final candidate = pitchClass + (octave * 12);
      if (candidate < minPitch) {
        continue;
      }
      if (candidate > maxPitch) {
        return null;
      }
      return candidate;
    }
    return null;
  }

  static int? _resolveBassMidi({
    required int pitchClass,
    required int targetMidi,
    required int minPitch,
    required int maxPitch,
    required int? previousBassMidi,
  }) {
    final continuityTarget = previousBassMidi ?? targetMidi;
    int? bestMidi;
    var bestPrimaryDistance = 999;
    var bestSecondaryDistance = 999;
    for (var octave = 1; octave <= 5; octave += 1) {
      final candidate = pitchClass + (octave * 12);
      if (candidate < minPitch || candidate > maxPitch) {
        continue;
      }
      final primaryDistance = (candidate - continuityTarget).abs();
      final secondaryDistance = (candidate - targetMidi).abs();
      if (primaryDistance < bestPrimaryDistance ||
          (primaryDistance == bestPrimaryDistance &&
              secondaryDistance < bestSecondaryDistance)) {
        bestPrimaryDistance = primaryDistance;
        bestSecondaryDistance = secondaryDistance;
        bestMidi = candidate;
      }
    }
    return bestMidi;
  }

  static int? _bassMidiOf(HarmonyChordClip clip) {
    for (final note in clip.notes) {
      if (note.toneLabel == 'bass') {
        return note.midiNote;
      }
    }
    return null;
  }

  static int? _midiForStudyAnswerId(String answerId) {
    final match = RegExp(r'^([a-g])(Sharp)?(\d+)$').firstMatch(answerId);
    if (match == null) {
      return null;
    }
    final letter = match.group(1)!.toUpperCase();
    final accidental = match.group(2) == null ? '' : '#';
    final octave = int.tryParse(match.group(3)!);
    final semitone = MusicTheory.noteToSemitone['$letter$accidental'];
    if (octave == null || semitone == null) {
      return null;
    }
    return ((octave + 1) * 12) + semitone;
  }

  static const Set<String> _tensionLabels = <String>{
    '2',
    'b9',
    '9',
    '#9',
    '11',
    '#11',
    '13',
    'b13',
  };

  static const Map<ChordQuality, List<String>> _baseToneLabelsByQuality =
      <ChordQuality, List<String>>{
        ChordQuality.majorTriad: <String>['1', '3', '5'],
        ChordQuality.minorTriad: <String>['1', 'b3', '5'],
        ChordQuality.dominant7: <String>['1', '3', 'b7', '5'],
        ChordQuality.major7: <String>['1', '3', '7', '5'],
        ChordQuality.minor7: <String>['1', 'b3', 'b7', '5'],
        ChordQuality.minorMajor7: <String>['1', 'b3', '7', '5'],
        ChordQuality.halfDiminished7: <String>['1', 'b3', 'b5', 'b7'],
        ChordQuality.diminishedTriad: <String>['1', 'b3', 'b5'],
        ChordQuality.diminished7: <String>['1', 'b3', 'b5', '6'],
        ChordQuality.augmentedTriad: <String>['1', '3', '#5'],
        ChordQuality.six: <String>['1', '3', '6', '5'],
        ChordQuality.minor6: <String>['1', 'b3', '6', '5'],
        ChordQuality.major69: <String>['1', '3', '6', '9'],
        ChordQuality.dominant7Alt: <String>['1', '3', 'b7'],
        ChordQuality.dominant7Sharp11: <String>['1', '3', 'b7', '#11'],
        ChordQuality.dominant13sus4: <String>['1', '4', 'b7', '13'],
        ChordQuality.dominant7sus4: <String>['1', '4', 'b7', '5'],
      };

  static const Map<String, Set<String>> _toneConflicts = <String, Set<String>>{
    '2': <String>{'2', '9', 'b9', '#9'},
    'b9': <String>{'2', '9', 'b9', '#9'},
    '9': <String>{'2', '9', 'b9', '#9'},
    '#9': <String>{'2', '9', 'b9', '#9'},
    '11': <String>{'11', '#11'},
    '#11': <String>{'11', '#11'},
    '5': <String>{'5', 'b5', '#5'},
    'b5': <String>{'5', 'b5', '#5'},
    '#5': <String>{'5', 'b5', '#5'},
    '6': <String>{'6', '13', 'b13'},
    '13': <String>{'6', '13', 'b13'},
    'b13': <String>{'6', '13', 'b13'},
  };

  static const List<String> _defaultAltToneLabels = <String>['b9', '#5'];
}
