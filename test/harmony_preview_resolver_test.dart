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

