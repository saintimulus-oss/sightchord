import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/audio/harmony_preview_resolver.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_task_evaluators.dart';

void main() {
  test('maps study keyboard ids to midi notes', () {
    final clip = HarmonyPreviewResolver.noteClipForStudyAnswerId('cSharp4');

    expect(clip.notes, hasLength(1));
    expect(clip.notes.first.midiNote, 61);
  });

  test('builds a slash-bass chord preview with guide tones and tensions', () {
    final clip = HarmonyPreviewResolver.fromParsedChord(
      const ParsedChord(
        sourceSymbol: 'Cmaj9/E',
        root: 'C',
        rootSemitone: 0,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        measureIndex: 0,
        positionInMeasure: 0,
        tensions: <String>['9'],
        bass: 'E',
        bassSemitone: 4,
      ),
    );

    expect(clip.notes, isNotEmpty);
    expect(clip.notes.first.toneLabel, 'bass');
    expect(clip.notes.first.midiNote, 40);
    expect(
      clip.notes.map((note) => note.toneLabel),
      containsAll(<String>['3', '7', '9']),
    );
  });

  test('keeps added tones when rendering parsed chord previews', () {
    final clip = HarmonyPreviewResolver.fromParsedChord(
      const ParsedChord(
        sourceSymbol: 'Cadd9',
        root: 'C',
        rootSemitone: 0,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        measureIndex: 0,
        positionInMeasure: 0,
        addedTones: <String>['9'],
      ),
    );

    expect(clip.notes.map((note) => note.toneLabel), contains('9'));
  });

  test('applies suspensions and omissions to parsed chord previews', () {
    final suspended = HarmonyPreviewResolver.fromParsedChord(
      const ParsedChord(
        sourceSymbol: 'Csus4',
        root: 'C',
        rootSemitone: 0,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        measureIndex: 0,
        positionInMeasure: 0,
        suspensions: <String>['4'],
      ),
    );
    final omitted = HarmonyPreviewResolver.fromParsedChord(
      const ParsedChord(
        sourceSymbol: 'Cmaj7omit5',
        root: 'C',
        rootSemitone: 0,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        measureIndex: 0,
        positionInMeasure: 0,
        omittedTones: <String>['5'],
      ),
    );

    expect(suspended.notes.map((note) => note.toneLabel), contains('4'));
    expect(suspended.notes.map((note) => note.toneLabel), isNot(contains('3')));
    expect(omitted.notes.map((note) => note.toneLabel), isNot(contains('5')));
  });

  test(
    'preserves explicit altered extensions in rich parsed chord previews',
    () {
      final clip = HarmonyPreviewResolver.fromParsedChord(
        const ParsedChord(
          sourceSymbol: 'G7(b9,#11,b13)',
          root: 'G',
          rootSemitone: 7,
          displayQuality: ChordQuality.dominant7Sharp11,
          analysisFamily: ChordFamily.dominant,
          measureIndex: 0,
          positionInMeasure: 0,
          tensions: <String>['b9', '#11', 'b13'],
          alterations: <String>['b9', '#11', 'b13'],
        ),
      );

      expect(
        clip.notes.map((note) => note.toneLabel),
        containsAll(<String>['b9', '#11', 'b13']),
      );
    },
  );

  test('gives alt chords representative altered colors in previews', () {
    final clip = HarmonyPreviewResolver.fromParsedChord(
      const ParsedChord(
        sourceSymbol: 'G7alt',
        root: 'G',
        rootSemitone: 7,
        displayQuality: ChordQuality.dominant7Alt,
        analysisFamily: ChordFamily.dominant,
        measureIndex: 0,
        positionInMeasure: 0,
        alterations: <String>['alt'],
      ),
    );

    expect(
      clip.notes.map((note) => note.toneLabel),
      containsAll(<String>['b9', '#5']),
    );
  });

  test('builds prompt clips from highlighted study keyboard notes', () {
    final clips = HarmonyPreviewResolver.promptClipsForStudyTask(
      StudyHarmonyTaskInstance(
        blueprintId: 'test-blueprint',
        lessonId: 'test-lesson',
        taskKind: StudyHarmonyTaskKind.noteOnKeyboard,
        prompt: const StudyHarmonyPromptSpec(
          id: 'prompt-1',
          surface: StudyHarmonyPromptSurfaceKind.pianoPreview,
          primaryLabel: 'Play the highlighted chord',
          highlightedAnswerIds: <StudyHarmonyAnswerOptionId>{'c4', 'e4'},
        ),
        answerOptions: const <StudyHarmonyAnswerOption>[
          StudyHarmonyPianoAnswerOption(
            id: 'c4',
            westernLabel: 'C',
            solfegeLabel: 'Do',
            isBlack: false,
            whiteIndex: 0,
          ),
          StudyHarmonyPianoAnswerOption(
            id: 'e4',
            westernLabel: 'E',
            solfegeLabel: 'Mi',
            isBlack: false,
            whiteIndex: 2,
          ),
        ],
        answerSummaryLabel: 'C and E',
        answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
        evaluator: MultiChoiceEvaluator(
          acceptedAnswerSets: const <Set<StudyHarmonyAnswerOptionId>>[
            <StudyHarmonyAnswerOptionId>{'c4', 'e4'},
          ],
        ),
        sequenceNumber: 0,
      ),
    );

    expect(clips, hasLength(1));
    expect(clips.single.notes.map((note) => note.midiNote).toList(), <int>[
      60,
      64,
    ]);
  });
}
