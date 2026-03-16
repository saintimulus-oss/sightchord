import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/melody_models.dart';
import 'package:chordest/music/phrase_planner.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

GeneratedChord _chord({
  required String root,
  required ChordQuality quality,
  required RomanNumeralId roman,
  required HarmonicFunction function,
}) {
  final key = '$root:${quality.name}:${roman.name}:${function.name}';
  return GeneratedChord(
    symbolData: ChordSymbolData(
      root: root,
      harmonicQuality: quality,
      renderQuality: quality,
    ),
    repeatGuardKey: key,
    harmonicComparisonKey: key,
    keyName: 'C',
    keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
    romanNumeralId: roman,
    harmonicFunction: function,
  );
}

GeneratedChordEvent _event({
  required GeneratedChord chord,
  required int barIndex,
}) {
  return GeneratedChordEvent(
    chord: chord,
    timing: ChordTimingSpec(
      barIndex: barIndex,
      changeBeat: 0,
      durationBeats: 4,
      beatsPerBar: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    ),
  );
}

void main() {
  GeneratedMelodyEvent cadenceEvent(int barIndex, String label) {
    final chordEvent = _event(
      chord: _chord(
        root: 'C',
        quality: ChordQuality.major7,
        roman: RomanNumeralId.iMaj7,
        function: HarmonicFunction.tonic,
      ),
      barIndex: barIndex,
    );
    return GeneratedMelodyEvent(
      chordEvent: chordEvent,
      notes: <GeneratedMelodyNote>[
        GeneratedMelodyNote(
          midiNote: 72,
          startBeatOffset: 0,
          durationBeats: 4,
          role: MelodyNoteRole.chordTone,
          toneLabel: label,
        ),
      ],
      phraseRole: PhraseRole.cadence,
      phraseCenterMidi: 71,
      phraseApexMidi: 76,
      phraseApexPos01: 0.55,
    );
  }

  test('phrase planner uses multi-event window for continuation position', () {
    final window = <GeneratedChordEvent>[
      _event(
        chord: _chord(
          root: 'C',
          quality: ChordQuality.major7,
          roman: RomanNumeralId.iMaj7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 0,
      ),
      _event(
        chord: _chord(
          root: 'A',
          quality: ChordQuality.minor7,
          roman: RomanNumeralId.viMin7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 1,
      ),
      _event(
        chord: _chord(
          root: 'D',
          quality: ChordQuality.minor7,
          roman: RomanNumeralId.iiMin7,
          function: HarmonicFunction.predominant,
        ),
        barIndex: 2,
      ),
      _event(
        chord: _chord(
          root: 'G',
          quality: ChordQuality.dominant7,
          roman: RomanNumeralId.vDom7,
          function: HarmonicFunction.dominant,
        ),
        barIndex: 3,
      ),
      _event(
        chord: _chord(
          root: 'C',
          quality: ChordQuality.major7,
          roman: RomanNumeralId.iMaj7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 4,
      ),
    ];

    final request = MelodyGenerationRequest(
      chordEvent: window[2],
      previousChordEvent: window[1],
      nextChordEvent: window[3],
      lookAheadChordEvent: window[4],
      phraseChordWindow: window,
      phraseWindowIndex: 2,
      settings: PracticeSettings(
        melodyGenerationEnabled: true,
        settingsComplexityMode: SettingsComplexityMode.standard,
      ),
      seed: 77,
    );

    final plan = PhrasePlanner.plan(request: request, random: Random(77));

    expect(plan.role, PhraseRole.continuation);
    expect(plan.phraseLengthBars, inInclusiveRange(2, 4));
    expect(plan.eventsInPhrase, greaterThanOrEqualTo(3));
    expect(plan.eventIndexInPhrase, greaterThan(0));
    expect(plan.eventStartPos01, greaterThan(0));
    expect(plan.eventEndPos01, greaterThan(plan.eventStartPos01));
    expect(plan.apexPos01, inInclusiveRange(0.40, 0.70));
  });

  test('phrase planner closes phrase at cadence boundary', () {
    final window = <GeneratedChordEvent>[
      _event(
        chord: _chord(
          root: 'D',
          quality: ChordQuality.minor7,
          roman: RomanNumeralId.iiMin7,
          function: HarmonicFunction.predominant,
        ),
        barIndex: 0,
      ),
      _event(
        chord: _chord(
          root: 'G',
          quality: ChordQuality.dominant7,
          roman: RomanNumeralId.vDom7,
          function: HarmonicFunction.dominant,
        ),
        barIndex: 1,
      ),
      _event(
        chord: _chord(
          root: 'C',
          quality: ChordQuality.major7,
          roman: RomanNumeralId.iMaj7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 2,
      ),
      _event(
        chord: _chord(
          root: 'A',
          quality: ChordQuality.minor7,
          roman: RomanNumeralId.viMin7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 3,
      ),
    ];

    final request = MelodyGenerationRequest(
      chordEvent: window[1],
      previousChordEvent: window[0],
      nextChordEvent: window[2],
      lookAheadChordEvent: window[3],
      phraseChordWindow: window,
      phraseWindowIndex: 1,
      settings: PracticeSettings(
        melodyGenerationEnabled: true,
        settingsComplexityMode: SettingsComplexityMode.guided,
      ),
      seed: 91,
    );

    final plan = PhrasePlanner.plan(request: request, random: Random(91));

    expect(plan.role, PhraseRole.preCadence);
    expect(plan.eventsInPhrase, 3);
    expect(plan.eventIndexInPhrase, 1);
    expect(plan.eventEndPos01, closeTo(2 / 3, 0.15));
  });

  test('phrase planner derives a section arc from prior cadence history', () {
    final window = <GeneratedChordEvent>[
      _event(
        chord: _chord(
          root: 'C',
          quality: ChordQuality.major7,
          roman: RomanNumeralId.iMaj7,
          function: HarmonicFunction.tonic,
        ),
        barIndex: 8,
      ),
      _event(
        chord: _chord(
          root: 'D',
          quality: ChordQuality.minor7,
          roman: RomanNumeralId.iiMin7,
          function: HarmonicFunction.predominant,
        ),
        barIndex: 9,
      ),
      _event(
        chord: _chord(
          root: 'G',
          quality: ChordQuality.dominant7,
          roman: RomanNumeralId.vDom7,
          function: HarmonicFunction.dominant,
        ),
        barIndex: 10,
      ),
    ];

    final request = MelodyGenerationRequest(
      chordEvent: window[0],
      nextChordEvent: window[1],
      lookAheadChordEvent: window[2],
      phraseChordWindow: window,
      phraseWindowIndex: 0,
      recentMelodyEvents: <GeneratedMelodyEvent>[
        cadenceEvent(0, '1'),
        cadenceEvent(2, '3'),
        cadenceEvent(4, '5'),
      ],
      settings: PracticeSettings(
        melodyGenerationEnabled: true,
        settingsComplexityMode: SettingsComplexityMode.advanced,
      ),
      seed: 123,
    );

    final plan = PhrasePlanner.plan(request: request, random: Random(123));

    expect(plan.sectionArcIndex, 3);
    expect(plan.sectionArcSpan, 4);
    expect(plan.sectionCenterLiftSemitones, lessThanOrEqualTo(0));
  });
}
