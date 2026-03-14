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
    final notes = <HarmonyPreviewNote>[
      for (var index = 0; index < voicing.midiNotes.length; index += 1)
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

  static HarmonyChordClip fromParsedChord(ParsedChord chord, {String? label}) {
    return fromChordSymbolData(
      ChordSymbolData(
        root: chord.root,
        harmonicQuality: chord.displayQuality,
        renderQuality: chord.displayQuality,
        tensions: chord.tensions,
        bass: chord.bass,
      ),
      label: label ?? chord.sourceSymbol,
    );
  }

  static HarmonyChordClip fromChordSymbolData(
    ChordSymbolData symbolData, {
    String? label,
  }) {
    final rootSemitone = MusicTheory.noteToSemitone[symbolData.root];
    if (rootSemitone == null) {
      return const HarmonyChordClip(notes: <HarmonyPreviewNote>[]);
    }

    final toneLabels = _orderedToneLabels(symbolData);
    final notes = <HarmonyPreviewNote>[];

    final bass = symbolData.bass;
    if (bass case final bassName?) {
      final bassSemitone = MusicTheory.noteToSemitone[bassName];
      if (bassSemitone != null) {
        final bassMidi = _nearestMidiForPitchClass(
          pitchClass: bassSemitone,
          targetMidi: 41,
          minPitch: 36,
          maxPitch: 52,
        );
        if (bassMidi != null) {
          notes.add(
            HarmonyPreviewNote(
              midiNote: bassMidi,
              gain: 0.98,
              toneLabel: 'bass',
            ),
          );
        }
      }
    }

    final realizedUpperNotes = _realizeUpperVoicing(
      rootSemitone: rootSemitone,
      toneLabels: toneLabels,
    );
    notes.addAll(realizedUpperNotes);

    return HarmonyChordClip(notes: notes, label: label);
  }

  static List<HarmonyChordClip> progressionFromAnalysis(
    ProgressionAnalysis analysis,
  ) {
    return [
      for (final chord in analysis.parseResult.validChords)
        fromParsedChord(chord),
    ];
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
    return [
      for (final chord in parseResult.validChords) fromParsedChord(chord),
    ];
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

  static List<String> _orderedToneLabels(ChordSymbolData symbolData) {
    final labels = <String>[
      ...?_baseToneLabelsByQuality[symbolData.renderQuality],
    ];
    for (final tension in symbolData.tensions) {
      if (_toneSemitones.containsKey(tension) && !labels.contains(tension)) {
        labels.add(tension);
      }
    }

    if (labels.length > 4) {
      labels.removeWhere(
        (label) => label == '5' || label == 'b5' || label == '#5',
      );
    }
    if (labels.length > 5) {
      return labels.take(5).toList(growable: false);
    }
    return labels;
  }

  static List<HarmonyPreviewNote> _realizeUpperVoicing({
    required int rootSemitone,
    required List<String> toneLabels,
  }) {
    const targets = <int>[48, 55, 60, 65, 70];
    final notes = <HarmonyPreviewNote>[];
    var minPitch = 43;
    for (var index = 0; index < toneLabels.length; index += 1) {
      final label = toneLabels[index];
      final semitone = _toneSemitones[label];
      if (semitone == null) {
        continue;
      }
      final pitchClass = (rootSemitone + semitone) % 12;
      final targetMidi =
          targets[index < targets.length ? index : targets.length - 1];
      final midi = _nearestMidiForPitchClass(
        pitchClass: pitchClass,
        targetMidi: targetMidi,
        minPitch: minPitch,
        maxPitch: 84,
      );
      if (midi == null) {
        continue;
      }
      notes.add(
        HarmonyPreviewNote(
          midiNote: midi,
          gain: _gainForToneLabel(label),
          toneLabel: label,
        ),
      );
      minPitch = midi + _minimumGap(label);
    }
    return notes;
  }

  static int _minimumGap(String toneLabel) {
    if (toneLabel == '1') {
      return 5;
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
}
