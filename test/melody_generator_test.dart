import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/melody_generator.dart';
import 'package:chordest/music/melody_models.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

GeneratedChord _buildChord({
  required String root,
  required ChordQuality quality,
  required String repeatKey,
  required RomanNumeralId romanNumeralId,
  required KeyCenter keyCenter,
  required HarmonicFunction harmonicFunction,
}) {
  return GeneratedChord(
    symbolData: ChordSymbolData(
      root: root,
      harmonicQuality: quality,
      renderQuality: quality,
    ),
    repeatGuardKey: repeatKey,
    harmonicComparisonKey: repeatKey,
    keyName: keyCenter.tonicName,
    keyCenter: keyCenter,
    romanNumeralId: romanNumeralId,
    harmonicFunction: harmonicFunction,
  );
}

GeneratedChordEvent _buildEvent({
  required GeneratedChord chord,
  required int barIndex,
  required int changeBeat,
  required int durationBeats,
  required int eventIndexInBar,
  required int eventsInBar,
  int beatsPerBar = 4,
}) {
  return GeneratedChordEvent(
    chord: chord,
    timing: ChordTimingSpec(
      barIndex: barIndex,
      changeBeat: changeBeat,
      durationBeats: durationBeats,
      beatsPerBar: beatsPerBar,
      eventIndexInBar: eventIndexInBar,
      eventsInBar: eventsInBar,
    ),
  );
}

void main() {
  const cMajor = KeyCenter(tonicName: 'C', mode: KeyMode.major);

  test('safe melody starts on a stable strong-beat tone', () {
    final settings = PracticeSettings(
      melodyGenerationEnabled: true,
      melodyDensity: MelodyDensity.balanced,
      melodyStyle: MelodyStyle.safe,
      melodyRangeLow: 60,
      melodyRangeHigh: 79,
    );
    final event = _buildEvent(
      chord: _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'Cmaj7',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.tonic,
      ),
      barIndex: 0,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );

    final melody = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: event,
        settings: settings,
        seed: 11,
      ),
    );

    final first = melody.firstNote;
    expect(first, isNotNull);
    expect(first!.startBeatOffset, 0);
    expect(
      first.role,
      anyOf(
        MelodyNoteRole.guideTone,
        MelodyNoteRole.chordTone,
        MelodyNoteRole.stableTension,
      ),
    );
    expect(
      {'1', '3', '5', '7', '9', '13'}.contains(first.toneLabel),
      isTrue,
    );
  });

  test('motif repetition reuses contour identity across events', () {
    final settings = PracticeSettings(
      melodyGenerationEnabled: true,
      melodyDensity: MelodyDensity.active,
      motifRepetitionStrength: 1.0,
      melodyStyle: MelodyStyle.bebop,
      melodyRangeLow: 57,
      melodyRangeHigh: 81,
    );
    final iiEvent = _buildEvent(
      chord: _buildChord(
        root: 'D',
        quality: ChordQuality.minor7,
        repeatKey: 'Dm7',
        romanNumeralId: RomanNumeralId.iiMin7,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.predominant,
      ),
      barIndex: 0,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );
    final vEvent = _buildEvent(
      chord: _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'G7',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.dominant,
      ),
      barIndex: 1,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );

    final first = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: iiEvent,
        nextChordEvent: vEvent,
        settings: settings,
        seed: 29,
      ),
    );
    final second = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: vEvent,
        previousChordEvent: iiEvent,
        previousMelodyEvent: first,
        settings: settings,
        seed: 29,
      ),
    );

    expect(second.contourSignature, first.contourSignature);
  });

  test('dominant melody resolves close to the next tonic target', () {
    final settings = PracticeSettings(
      melodyGenerationEnabled: true,
      melodyDensity: MelodyDensity.active,
      motifRepetitionStrength: 0.6,
      approachToneDensity: 1.0,
      melodyStyle: MelodyStyle.bebop,
      allowChromaticApproaches: true,
      melodyRangeLow: 55,
      melodyRangeHigh: 79,
    );
    final dominantEvent = _buildEvent(
      chord: _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'G7',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.dominant,
      ),
      barIndex: 0,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );
    final tonicEvent = _buildEvent(
      chord: _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'Cmaj7',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.tonic,
      ),
      barIndex: 1,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );

    final dominantMelody = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: dominantEvent,
        nextChordEvent: tonicEvent,
        settings: settings,
        seed: 41,
      ),
    );
    final tonicMelody = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: tonicEvent,
        previousChordEvent: dominantEvent,
        previousMelodyEvent: dominantMelody,
        settings: settings,
        seed: 41,
      ),
    );

    expect(dominantMelody.lastMidiNote, isNotNull);
    expect(tonicMelody.firstNote, isNotNull);
    expect(
      (dominantMelody.lastMidiNote! - tonicMelody.firstNote!.midiNote).abs(),
      lessThanOrEqualTo(2),
    );
  });
}
