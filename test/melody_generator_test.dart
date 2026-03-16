import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/melody_generator.dart';
import 'package:chordest/music/melody_models.dart';
import 'package:chordest/music/phrase_planner.dart';
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
    expect({'1', '3', '5', '7', '9', '13'}.contains(first.toneLabel), isTrue);
  });

  test('motif repetition reuses material through a transform plan', () {
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
        phraseChordWindow: <GeneratedChordEvent>[iiEvent, vEvent],
        phraseWindowIndex: 0,
        settings: settings,
        seed: 29,
      ),
    );
    final second = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: vEvent,
        previousChordEvent: iiEvent,
        previousMelodyEvent: first,
        phraseChordWindow: <GeneratedChordEvent>[iiEvent, vEvent],
        phraseWindowIndex: 1,
        settings: settings,
        seed: 29,
      ),
    );

    expect(second.motifSignature.split(':').first, isNot('fresh'));
    expect(second.contourSignature, isNotEmpty);
    expect(second.contourSignature, isNot(first.contourSignature));
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
        phraseChordWindow: <GeneratedChordEvent>[dominantEvent, tonicEvent],
        phraseWindowIndex: 0,
        settings: settings,
        seed: 41,
      ),
    );
    final tonicMelody = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: tonicEvent,
        previousChordEvent: dominantEvent,
        previousMelodyEvent: dominantMelody,
        phraseChordWindow: <GeneratedChordEvent>[dominantEvent, tonicEvent],
        phraseWindowIndex: 1,
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

  test(
    'cadence event carries phrase metadata and lands on a long resolution',
    () {
      final settings = PracticeSettings(
        melodyGenerationEnabled: true,
        melodyDensity: MelodyDensity.balanced,
        melodyStyle: MelodyStyle.lyrical,
        melodyRangeLow: 58,
        melodyRangeHigh: 81,
        settingsComplexityMode: SettingsComplexityMode.standard,
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
      final iEvent = _buildEvent(
        chord: _buildChord(
          root: 'C',
          quality: ChordQuality.major7,
          repeatKey: 'Cmaj7',
          romanNumeralId: RomanNumeralId.iMaj7,
          keyCenter: cMajor,
          harmonicFunction: HarmonicFunction.tonic,
        ),
        barIndex: 2,
        changeBeat: 0,
        durationBeats: 4,
        eventIndexInBar: 0,
        eventsInBar: 1,
      );

      final dominantMelody = MelodyGenerator.generateEvent(
        request: MelodyGenerationRequest(
          chordEvent: vEvent,
          previousChordEvent: iiEvent,
          nextChordEvent: iEvent,
          lookAheadChordEvent: iEvent,
          phraseChordWindow: <GeneratedChordEvent>[iiEvent, vEvent, iEvent],
          phraseWindowIndex: 1,
          settings: settings,
          seed: 84,
        ),
      );
      final cadenceMelody = MelodyGenerator.generateEvent(
        request: MelodyGenerationRequest(
          chordEvent: iEvent,
          previousChordEvent: vEvent,
          previousMelodyEvent: dominantMelody,
          phraseChordWindow: <GeneratedChordEvent>[iiEvent, vEvent, iEvent],
          phraseWindowIndex: 2,
          settings: settings,
          seed: 84,
        ),
      );

      final localMeanDuration = cadenceMelody.notes.length <= 1
          ? cadenceMelody.notes.first.durationBeats
          : cadenceMelody.notes
                    .take(cadenceMelody.notes.length - 1)
                    .fold<double>(0, (sum, note) => sum + note.durationBeats) /
                (cadenceMelody.notes.length - 1);
      expect(cadenceMelody.phraseRole, PhraseRole.cadence);
      expect(cadenceMelody.phraseCenterMidi, isNotNull);
      expect(cadenceMelody.phraseApexMidi, isNotNull);
      expect(cadenceMelody.phraseApexPos01, inInclusiveRange(0.40, 0.70));
      expect(cadenceMelody.phraseEndingDegreePriority, isNotNull);
      expect(cadenceMelody.lastNote, isNotNull);
      expect(cadenceMelody.arrivalMidiNote, isNotNull);
      expect(
        cadenceMelody.lastNote!.durationBeats,
        greaterThanOrEqualTo(localMeanDuration * 1.8),
      );
      expect(
        (cadenceMelody.lastNote!.midiNote - cadenceMelody.arrivalMidiNote!)
            .abs(),
        lessThanOrEqualTo(3),
      );
    },
  );

  test('same seed reproduces the same melody material', () {
    final settings = PracticeSettings(
      melodyGenerationEnabled: true,
      melodyDensity: MelodyDensity.active,
      melodyStyle: MelodyStyle.colorful,
      melodyRangeLow: 55,
      melodyRangeHigh: 82,
      settingsComplexityMode: SettingsComplexityMode.advanced,
      allowChromaticApproaches: true,
    );
    final event = _buildEvent(
      chord: _buildChord(
        root: 'Db',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'Db7#11',
        romanNumeralId: RomanNumeralId.substituteOfII,
        keyCenter: cMajor,
        harmonicFunction: HarmonicFunction.dominant,
      ),
      barIndex: 3,
      changeBeat: 0,
      durationBeats: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    );

    final first = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: event,
        settings: settings,
        seed: 314159,
      ),
    );
    final second = MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: event,
        settings: settings,
        seed: 314159,
      ),
    );

    expect(second.signatureHash, first.signatureHash);
    expect(
      second.notes
          .map(
            (note) =>
                '${note.midiNote}@${note.startBeatOffset}:${note.durationBeats}:${note.toneLabel}',
          )
          .join('|'),
      first.notes
          .map(
            (note) =>
                '${note.midiNote}@${note.startBeatOffset}:${note.durationBeats}:${note.toneLabel}',
          )
          .join('|'),
    );
  });

  test(
    'recent 4-event window suppresses exact and interval-vector repeats',
    () {
      final settings = PracticeSettings(
        melodyGenerationEnabled: true,
        melodyDensity: MelodyDensity.balanced,
        melodyStyle: MelodyStyle.lyrical,
        motifRepetitionStrength: 1.0,
        motifVariationBias: 1.0,
        noveltyTarget: 1.0,
        exactRepeatTarget: 0.02,
        melodyRangeLow: 58,
        melodyRangeHigh: 80,
        settingsComplexityMode: SettingsComplexityMode.standard,
        allowChromaticApproaches: true,
      );
      final events = List<GeneratedChordEvent>.generate(
        6,
        (index) => _buildEvent(
          chord: _buildChord(
            root: index.isOdd ? 'G' : 'C',
            quality: index.isOdd ? ChordQuality.dominant7 : ChordQuality.major7,
            repeatKey: index.isOdd ? 'G7' : 'Cmaj7',
            romanNumeralId: index.isOdd
                ? RomanNumeralId.vDom7
                : RomanNumeralId.iMaj7,
            keyCenter: cMajor,
            harmonicFunction: index.isOdd
                ? HarmonicFunction.dominant
                : HarmonicFunction.tonic,
          ),
          barIndex: index,
          changeBeat: 0,
          durationBeats: 4,
          eventIndexInBar: 0,
          eventsInBar: 1,
        ),
        growable: false,
      );
      final generated = <GeneratedMelodyEvent>[];
      var exactRecentRepeats = 0;
      var intervalRecentRepeats = 0;
      for (var index = 0; index < events.length; index += 1) {
        final melody = MelodyGenerator.generateEvent(
          request: MelodyGenerationRequest(
            chordEvent: events[index],
            previousChordEvent: index > 0 ? events[index - 1] : null,
            nextChordEvent: index + 1 < events.length
                ? events[index + 1]
                : null,
            lookAheadChordEvent: index + 2 < events.length
                ? events[index + 2]
                : null,
            previousMelodyEvent: generated.isEmpty ? null : generated.last,
            recentMelodyEvents: generated.length <= 4
                ? List<GeneratedMelodyEvent>.from(generated, growable: false)
                : generated.sublist(generated.length - 4),
            phraseChordWindow: events.sublist(
              index == 0 ? 0 : index - 1,
              index + 3 < events.length ? index + 3 : events.length,
            ),
            phraseWindowIndex: index == 0 ? 0 : 1,
            settings: settings,
            seed: 1776,
          ),
        );
        final recent = generated.length <= 4
            ? generated
            : generated.sublist(generated.length - 4);
        if (recent.any(
          (candidate) =>
              candidate.eventSignatureKey == melody.eventSignatureKey,
        )) {
          exactRecentRepeats += 1;
        }
        if (melody.intervalSignatureKey.isNotEmpty &&
            recent.any(
              (candidate) =>
                  candidate.intervalSignatureKey == melody.intervalSignatureKey,
            )) {
          intervalRecentRepeats += 1;
        }
        generated.add(melody);
      }

      expect(exactRecentRepeats, 0);
      expect(intervalRecentRepeats, lessThanOrEqualTo(1));
    },
  );
}
