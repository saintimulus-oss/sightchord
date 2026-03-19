import 'package:chordest/music/chord_timing_models.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/melody_candidate_builder.dart';
import 'package:chordest/music/melody_models.dart';
import 'package:chordest/music/melody_scoring.dart';
import 'package:chordest/music/motif_transformer.dart';
import 'package:chordest/music/phrase_planner.dart';
import 'package:chordest/music/rhythm_template_sampler.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

GeneratedChord _buildChord() {
  return GeneratedChord(
    symbolData: const ChordSymbolData(
      root: 'C',
      harmonicQuality: ChordQuality.majorTriad,
      renderQuality: ChordQuality.majorTriad,
    ),
    repeatGuardKey: 'Cmaj',
    harmonicComparisonKey: 'Cmaj',
    keyName: 'C',
    keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
    romanNumeralId: RomanNumeralId.iMaj7,
    harmonicFunction: HarmonicFunction.tonic,
  );
}

GeneratedChordEvent _buildEvent() {
  return GeneratedChordEvent(
    chord: _buildChord(),
    timing: const ChordTimingSpec(
      barIndex: 0,
      changeBeat: 0,
      durationBeats: 4,
      beatsPerBar: 4,
      eventIndexInBar: 0,
      eventsInBar: 1,
    ),
  );
}

List<BeamNote> _beamNotes(List<int> pitches) {
  return [
    for (var index = 0; index < pitches.length; index += 1)
      BeamNote(
        note: GeneratedMelodyNote(
          midiNote: pitches[index],
          startBeatOffset: index.toDouble(),
          durationBeats: 1,
          role: MelodyNoteRole.chordTone,
          toneLabel: '1',
          structural: index == 0,
          sourceCategoryKey: MelodyCandidateCategory.chord.name,
          strongSlot: index == 0,
        ),
        category: MelodyCandidateCategory.chord,
        metricStrength: 0.8,
        anticipatory: false,
      ),
  ];
}

MelodyDecodeContext _context() {
  final request = MelodyGenerationRequest(
    chordEvent: _buildEvent(),
    settings: PracticeSettings(
      melodyGenerationEnabled: true,
      settingsComplexityMode: SettingsComplexityMode.standard,
    ),
    seed: 19,
  );
  final phrasePlan = const PhrasePlan(
    role: PhraseRole.opening,
    centerMidi: 62,
    apexMidi: 65,
    apexPos01: 0.75,
    targetNovelty01: 0.25,
    targetColorExposure01: 0.0,
    endingDegreePriority: 1,
    phraseLengthBars: 2,
    eventsInPhrase: 4,
    eventIndexInPhrase: 0,
    eventStartPos01: 0.0,
    eventEndPos01: 1.0,
    phraseDurationBeats: 4.0,
    cadenceHoldMultiplier: 1.0,
    phraseVariantNonce: 0,
    sectionArcIndex: 0,
    sectionArcSpan: 0,
    sectionCenterLiftSemitones: 0,
    sectionApexLiftSemitones: 0,
  );
  final anchors = const PhraseAnchors(
    startMidi: 60,
    endMidi: 64,
    apexMidi: 65,
    startToneLabel: '1',
    endToneLabel: '3',
  );
  final rhythm = RhythmTemplateSample(
    templateId: 'test',
    slots: const <RhythmSlot>[
      RhythmSlot(
        index: 0,
        startBeatOffset: 0,
        durationBeats: 1,
        metricStrength: 0.9,
        phrasePos01: 0.0,
        isStrong: true,
        structural: true,
      ),
      RhythmSlot(
        index: 1,
        startBeatOffset: 1,
        durationBeats: 1,
        metricStrength: 0.8,
        phrasePos01: 0.33,
        isStrong: false,
        structural: false,
      ),
      RhythmSlot(
        index: 2,
        startBeatOffset: 2,
        durationBeats: 1,
        metricStrength: 0.8,
        phrasePos01: 0.66,
        isStrong: false,
        structural: false,
      ),
      RhythmSlot(
        index: 3,
        startBeatOffset: 3,
        durationBeats: 1,
        metricStrength: 0.9,
        phrasePos01: 1.0,
        isStrong: true,
        structural: true,
      ),
    ],
    meanDurationBeats: 1.0,
    usedAnticipation: false,
  );
  final motif = MotifTransformPlan(
    transformName: 'fresh',
    memory: const MotifMemory(
      intervalVector: <int>[],
      rhythmVector: <double>[],
      toneLabels: <String?>[],
      contourSigns: <int>[],
      eventSignature: '',
      intervalSignature: '',
      zeroIntervalCount: 0,
    ),
    usesPreviousMaterial: false,
    signature: 'fresh',
  );
  return MelodyDecodeContext(
    request: request,
    effectiveMode: SettingsComplexityMode.standard,
    palette: MelodyHarmonyPalette.fromChord(
      chord: request.chordEvent.chord,
      settings: request.settings,
    ),
    previousPalette: null,
    nextPalette: null,
    phrasePlan: phrasePlan,
    anchors: anchors,
    rhythmSample: rhythm,
    motifPlan: motif,
    effectiveDensity: MelodyDensity.balanced,
    effectiveStyle: MelodyStyle.safe,
    seed: 19,
  );
}

void main() {
  test('same-pitch overflow is penalized more than a varied contour', () {
    final context = _context();
    final repeated = MelodyScoring.finalRerankAdjustment(
      beamNotes: _beamNotes(<int>[60, 60, 60, 64]),
      context: context,
    );
    final varied = MelodyScoring.finalRerankAdjustment(
      beamNotes: _beamNotes(<int>[60, 61, 62, 64]),
      context: context,
    );

    expect(repeated, lessThan(varied));
  });
}
