import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_task_evaluators.dart';

void main() {
  test(
    'exact set evaluator accepts exact matches and keeps partial score data',
    () {
      final evaluator = ExactSetEvaluator(
        acceptedAnswerSets: const [
          {'cKey', 'eKey'},
        ],
      );
      final task = _buildTask(
        taskKind: StudyHarmonyTaskKind.chordOnKeyboard,
        evaluator: evaluator,
        answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
        answerOptions: const [
          StudyHarmonyPianoAnswerOption(
            id: 'cKey',
            westernLabel: 'C',
            solfegeLabel: 'Do',
            isBlack: false,
            whiteIndex: 0,
          ),
          StudyHarmonyPianoAnswerOption(
            id: 'dKey',
            westernLabel: 'D',
            solfegeLabel: 'Re',
            isBlack: false,
            whiteIndex: 1,
          ),
          StudyHarmonyPianoAnswerOption(
            id: 'eKey',
            westernLabel: 'E',
            solfegeLabel: 'Mi',
            isBlack: false,
            whiteIndex: 2,
          ),
        ],
        answerSummaryLabel: 'C major shell',
      );

      final correct = evaluator.evaluate(
        task: task,
        submittedAnswerIds: const {'cKey', 'eKey'},
      );
      final incorrect = evaluator.evaluate(
        task: task,
        submittedAnswerIds: const {'cKey'},
      );

      expect(correct.status, StudyHarmonyEvaluationStatus.correct);
      expect(correct.correctness, isTrue);
      expect(correct.scoreFraction, 1);
      expect(incorrect.status, StudyHarmonyEvaluationStatus.incorrect);
      expect(incorrect.correctness, isFalse);
      expect(incorrect.scoreFraction, 0.5);
      expect(incorrect.correctAnswerSummary, 'Do (C), Mi (E)');
      expect(incorrect.selectedAnswerSummary, 'Do (C)');
    },
  );

  test('single choice evaluator enforces exactly one selected answer', () {
    final evaluator = SingleChoiceEvaluator(
      acceptedChoiceIds: const ['roman-i'],
    );
    final task = _buildTask(
      taskKind: StudyHarmonyTaskKind.chordToRomanChoice,
      evaluator: evaluator,
      answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
      answerOptions: const [
        StudyHarmonyAnswerChoice(id: 'roman-i', label: 'I'),
        StudyHarmonyAnswerChoice(id: 'roman-v', label: 'V'),
      ],
      answerSummaryLabel: 'I',
    );

    final correct = evaluator.evaluate(
      task: task,
      submittedAnswerIds: const {'roman-i'},
    );
    final invalid = evaluator.evaluate(
      task: task,
      submittedAnswerIds: const {'roman-i', 'roman-v'},
    );

    expect(correct.status, StudyHarmonyEvaluationStatus.correct);
    expect(invalid.status, StudyHarmonyEvaluationStatus.invalidSelection);
    expect(invalid.scoreFraction, 0);
  });

  test('multi choice evaluator handles scale tone selection tasks', () {
    final evaluator = MultiChoiceEvaluator(
      acceptedAnswerSets: const [
        {'c', 'd', 'e', 'f', 'g', 'a', 'b'},
      ],
      supportedTaskKinds: const {StudyHarmonyTaskKind.scaleTonesChoice},
    );
    final task = _buildTask(
      taskKind: StudyHarmonyTaskKind.scaleTonesChoice,
      evaluator: evaluator,
      answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
      answerOptions: const [
        StudyHarmonyAnswerChoice(id: 'c', label: 'C'),
        StudyHarmonyAnswerChoice(id: 'd', label: 'D'),
        StudyHarmonyAnswerChoice(id: 'e', label: 'E'),
        StudyHarmonyAnswerChoice(id: 'f', label: 'F'),
        StudyHarmonyAnswerChoice(id: 'g', label: 'G'),
        StudyHarmonyAnswerChoice(id: 'a', label: 'A'),
        StudyHarmonyAnswerChoice(id: 'b', label: 'B'),
      ],
      answerSummaryLabel: 'C D E F G A B',
    );

    final correct = evaluator.evaluate(
      task: task,
      submittedAnswerIds: const {'c', 'd', 'e', 'f', 'g', 'a', 'b'},
    );
    final incorrect = evaluator.evaluate(
      task: task,
      submittedAnswerIds: const {'c', 'd', 'e'},
    );

    expect(correct.status, StudyHarmonyEvaluationStatus.correct);
    expect(incorrect.status, StudyHarmonyEvaluationStatus.incorrect);
    expect(incorrect.scoreFraction, closeTo(3 / 7, 0.001));
  });

  test('planned task kinds are all coverable by current evaluators', () {
    final cases =
        <
          ({
            StudyHarmonyTaskKind taskKind,
            StudyHarmonyTaskEvaluator evaluator,
            StudyHarmonyAnswerSurfaceKind answerSurface,
            List<StudyHarmonyAnswerOption> answerOptions,
            Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
            String answerSummaryLabel,
          })
        >[
          (
            taskKind: StudyHarmonyTaskKind.noteOnKeyboard,
            evaluator: ExactSetEvaluator(
              acceptedAnswerSets: const [
                {'cKey'},
              ],
              supportedTaskKinds: const {StudyHarmonyTaskKind.noteOnKeyboard},
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
            answerOptions: const [
              StudyHarmonyPianoAnswerOption(
                id: 'cKey',
                westernLabel: 'C',
                solfegeLabel: 'Do',
                isBlack: false,
                whiteIndex: 0,
              ),
            ],
            submittedAnswerIds: const {'cKey'},
            answerSummaryLabel: 'Do (C)',
          ),
          (
            taskKind: StudyHarmonyTaskKind.noteNameChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['note-c'],
              supportedTaskKinds: const {StudyHarmonyTaskKind.noteNameChoice},
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'note-c', label: 'C'),
            ],
            submittedAnswerIds: const {'note-c'},
            answerSummaryLabel: 'C',
          ),
          (
            taskKind: StudyHarmonyTaskKind.chordOnKeyboard,
            evaluator: MultiChoiceEvaluator(
              acceptedAnswerSets: const [
                {'cKey', 'eKey', 'gKey'},
              ],
              supportedTaskKinds: const {StudyHarmonyTaskKind.chordOnKeyboard},
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
            answerOptions: const [
              StudyHarmonyPianoAnswerOption(
                id: 'cKey',
                westernLabel: 'C',
                solfegeLabel: 'Do',
                isBlack: false,
                whiteIndex: 0,
              ),
              StudyHarmonyPianoAnswerOption(
                id: 'eKey',
                westernLabel: 'E',
                solfegeLabel: 'Mi',
                isBlack: false,
                whiteIndex: 2,
              ),
              StudyHarmonyPianoAnswerOption(
                id: 'gKey',
                westernLabel: 'G',
                solfegeLabel: 'Sol',
                isBlack: false,
                whiteIndex: 4,
              ),
            ],
            submittedAnswerIds: const {'cKey', 'eKey', 'gKey'},
            answerSummaryLabel: 'C major',
          ),
          (
            taskKind: StudyHarmonyTaskKind.chordNameChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['cmaj'],
              supportedTaskKinds: const {StudyHarmonyTaskKind.chordNameChoice},
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'cmaj', label: 'C'),
            ],
            submittedAnswerIds: const {'cmaj'},
            answerSummaryLabel: 'C',
          ),
          (
            taskKind: StudyHarmonyTaskKind.scaleTonesChoice,
            evaluator: MultiChoiceEvaluator(
              acceptedAnswerSets: const [
                {'c', 'd', 'e'},
              ],
              supportedTaskKinds: const {StudyHarmonyTaskKind.scaleTonesChoice},
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'c', label: 'C'),
              StudyHarmonyAnswerChoice(id: 'd', label: 'D'),
              StudyHarmonyAnswerChoice(id: 'e', label: 'E'),
            ],
            submittedAnswerIds: const {'c', 'd', 'e'},
            answerSummaryLabel: 'C D E',
          ),
          (
            taskKind: StudyHarmonyTaskKind.romanToChordChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['gMajor'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.romanToChordChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'gMajor', label: 'G'),
            ],
            submittedAnswerIds: const {'gMajor'},
            answerSummaryLabel: 'G',
          ),
          (
            taskKind: StudyHarmonyTaskKind.chordToRomanChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['roman-v'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.chordToRomanChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'roman-v', label: 'V'),
            ],
            submittedAnswerIds: const {'roman-v'},
            answerSummaryLabel: 'V',
          ),
          (
            taskKind: StudyHarmonyTaskKind.diatonicityChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['diatonic'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.diatonicityChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'diatonic', label: 'Diatonic'),
            ],
            submittedAnswerIds: const {'diatonic'},
            answerSummaryLabel: 'Diatonic',
          ),
          (
            taskKind: StudyHarmonyTaskKind.progressionKeyCenterChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['c-major'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.progressionKeyCenterChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'c-major', label: 'C major'),
              StudyHarmonyAnswerChoice(id: 'g-major', label: 'G major'),
            ],
            submittedAnswerIds: const {'c-major'},
            answerSummaryLabel: 'C major',
          ),
          (
            taskKind: StudyHarmonyTaskKind.progressionFunctionChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['dominant'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.progressionFunctionChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'dominant', label: 'Dominant'),
              StudyHarmonyAnswerChoice(id: 'tonic', label: 'Tonic'),
            ],
            submittedAnswerIds: const {'dominant'},
            answerSummaryLabel: 'Dominant',
          ),
          (
            taskKind: StudyHarmonyTaskKind.progressionNonDiatonicChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['slot-2'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.progressionNonDiatonicChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'slot-1', label: '1. Cmaj7'),
              StudyHarmonyAnswerChoice(id: 'slot-2', label: '2. A7'),
            ],
            submittedAnswerIds: const {'slot-2'},
            answerSummaryLabel: 'A7',
          ),
          (
            taskKind: StudyHarmonyTaskKind.progressionMissingChordChoice,
            evaluator: SingleChoiceEvaluator(
              acceptedChoiceIds: const ['fill-v7'],
              supportedTaskKinds: const {
                StudyHarmonyTaskKind.progressionMissingChordChoice,
              },
            ),
            answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
            answerOptions: const [
              StudyHarmonyAnswerChoice(id: 'fill-v7', label: 'G7'),
              StudyHarmonyAnswerChoice(id: 'fill-ii', label: 'Dm7'),
            ],
            submittedAnswerIds: const {'fill-v7'},
            answerSummaryLabel: 'G7',
          ),
        ];

    for (final testCase in cases) {
      final task = _buildTask(
        taskKind: testCase.taskKind,
        evaluator: testCase.evaluator,
        answerSurface: testCase.answerSurface,
        answerOptions: testCase.answerOptions,
        answerSummaryLabel: testCase.answerSummaryLabel,
      );

      final result = testCase.evaluator.evaluate(
        task: task,
        submittedAnswerIds: testCase.submittedAnswerIds,
      );

      expect(
        testCase.evaluator.supportedTaskKinds,
        contains(testCase.taskKind),
        reason: testCase.taskKind.name,
      );
      expect(result.status, StudyHarmonyEvaluationStatus.correct);
    }
  });
}

StudyHarmonyTaskInstance _buildTask({
  required StudyHarmonyTaskKind taskKind,
  required StudyHarmonyTaskEvaluator evaluator,
  required StudyHarmonyAnswerSurfaceKind answerSurface,
  required List<StudyHarmonyAnswerOption> answerOptions,
  required String answerSummaryLabel,
}) {
  final blueprint = StudyHarmonyTaskBlueprint(
    id: 'task-${taskKind.name}',
    lessonId: 'lesson-1',
    taskKind: taskKind,
    promptSpec: StudyHarmonyPromptSpec(
      id: 'prompt-${taskKind.name}',
      surface: answerSurface == StudyHarmonyAnswerSurfaceKind.pianoKeyboard
          ? StudyHarmonyPromptSurfaceKind.pianoPreview
          : StudyHarmonyPromptSurfaceKind.text,
      primaryLabel: 'Prompt for ${taskKind.name}',
      highlightedAnswerIds:
          answerSurface == StudyHarmonyAnswerSurfaceKind.pianoKeyboard
          ? answerOptions.map((option) => option.id).take(1).toSet()
          : const <StudyHarmonyAnswerOptionId>{},
    ),
    answerOptions: answerOptions,
    answerSummaryLabel: answerSummaryLabel,
    answerSurface: answerSurface,
    evaluator: evaluator,
    skillTags: {taskKind.name},
  );
  return blueprint.createInstance(sequenceNumber: 0);
}
