import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/study_harmony/application/study_harmony_session_controller.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_task_evaluators.dart';

void main() {
  test(
    'session controller moves through ready, answering, submitted, and completed states',
    () {
      final controller = StudyHarmonySessionController(
        lesson: _buildLesson(goalCorrectAnswers: 2, startingLives: 2),
        random: Random(0),
      );

      expect(controller.state.phase, StudyHarmonySessionPhase.ready);

      final noSelection = controller.submit();
      expect(noSelection.status, StudyHarmonyEvaluationStatus.needsSelection);
      expect(controller.state.phase, StudyHarmonySessionPhase.ready);
      expect(controller.state.attempts, 0);

      controller.toggleAnswer('c');
      final firstSequence = controller.state.currentTask!.sequenceNumber;
      expect(controller.state.phase, StudyHarmonySessionPhase.answering);

      final correct = controller.submit();
      expect(correct.status, StudyHarmonyEvaluationStatus.correct);
      expect(controller.state.phase, StudyHarmonySessionPhase.submittedCorrect);
      expect(controller.state.correctAnswers, 1);
      expect(controller.state.attempts, 1);
      expect(controller.state.selectedAnswerIds, isEmpty);

      final repeatedSubmit = controller.submit();
      expect(repeatedSubmit.status, StudyHarmonyEvaluationStatus.correct);
      expect(controller.state.phase, StudyHarmonySessionPhase.submittedCorrect);

      controller.toggleAnswer('c');
      expect(
        controller.state.currentTask!.sequenceNumber,
        greaterThan(firstSequence),
      );
      expect(controller.state.phase, StudyHarmonySessionPhase.answering);

      controller.submit();
      expect(controller.state.phase, StudyHarmonySessionPhase.completed);
      expect(controller.state.isCompleted, isTrue);
      expect(controller.state.isFinished, isTrue);

      controller.restart();

      expect(controller.state.phase, StudyHarmonySessionPhase.ready);
      expect(controller.state.correctAnswers, 0);
      expect(controller.state.attempts, 0);
      expect(controller.state.livesRemaining, 2);
      expect(
        controller.state.lastEvaluation.status,
        StudyHarmonyEvaluationStatus.idle,
      );
    },
  );

  test('session controller reaches submitted incorrect and then game over', () {
    final controller = StudyHarmonySessionController(
      lesson: _buildLesson(goalCorrectAnswers: 2, startingLives: 2),
      random: Random(0),
    );

    controller.toggleAnswer('d');
    final firstIncorrect = controller.submit();
    expect(firstIncorrect.status, StudyHarmonyEvaluationStatus.incorrect);
    expect(controller.state.phase, StudyHarmonySessionPhase.submittedIncorrect);
    expect(controller.state.livesRemaining, 1);

    controller.toggleAnswer('d');
    controller.submit();

    expect(controller.state.phase, StudyHarmonySessionPhase.gameOver);
    expect(controller.state.isGameOver, isTrue);
    expect(controller.state.isFinished, isTrue);
  });

  test('session controller keeps review mode and records performance', () {
    final lesson = _buildLesson(
      goalCorrectAnswers: 1,
      startingLives: 2,
    ).copyWithForTest(sessionMode: StudyHarmonySessionMode.review);
    final controller = StudyHarmonySessionController(
      lesson: lesson,
      random: Random(0),
    );

    controller.toggleAnswer('c');
    controller.submit();

    expect(controller.state.mode, StudyHarmonySessionMode.review);
    expect(
      controller
          .state
          .performance
          .skillSummaries['noteNameChoice']
          ?.attemptCount,
      1,
    );
    expect(
      controller
          .state
          .performance
          .skillSummaries['noteNameChoice']
          ?.correctCount,
      1,
    );
    expect(
      controller.state.performance.lessonSummaries['lesson-1']?.attemptCount,
      1,
    );
  });
}

StudyHarmonyLessonDefinition _buildLesson({
  required int goalCorrectAnswers,
  required int startingLives,
}) {
  return StudyHarmonyLessonDefinition(
    id: 'lesson-1',
    chapterId: 'chapter-1',
    title: 'Lesson',
    description: 'Session controller lesson',
    objectiveLabel: 'Get two correct answers',
    goalCorrectAnswers: goalCorrectAnswers,
    startingLives: startingLives,
    sessionMode: StudyHarmonySessionMode.lesson,
    tasks: [
      StudyHarmonyTaskBlueprint(
        id: 'task-1',
        lessonId: 'lesson-1',
        taskKind: StudyHarmonyTaskKind.noteNameChoice,
        promptSpec: StudyHarmonyPromptSpec(
          id: 'prompt-1',
          surface: StudyHarmonyPromptSurfaceKind.text,
          primaryLabel: 'Choose C',
        ),
        answerOptions: const [
          StudyHarmonyAnswerChoice(id: 'c', label: 'C'),
          StudyHarmonyAnswerChoice(id: 'd', label: 'D'),
        ],
        answerSummaryLabel: 'C',
        answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
        evaluator: SingleChoiceEvaluator(acceptedChoiceIds: ['c']),
        skillTags: const {'noteNameChoice'},
      ),
    ],
  );
}

extension on StudyHarmonyLessonDefinition {
  StudyHarmonyLessonDefinition copyWithForTest({
    StudyHarmonySessionMode? sessionMode,
  }) {
    return StudyHarmonyLessonDefinition(
      id: id,
      chapterId: chapterId,
      title: title,
      description: description,
      objectiveLabel: objectiveLabel,
      goalCorrectAnswers: goalCorrectAnswers,
      startingLives: startingLives,
      sessionMode: sessionMode ?? this.sessionMode,
      tasks: tasks,
      skillTags: skillTags,
      sessionMetadata: sessionMetadata,
    );
  }
}
