import 'dart:math';

import 'application/study_harmony_session_controller.dart';
import 'content/legacy_adapter.dart';
import 'domain/study_harmony_session_models.dart';
import 'study_harmony_models.dart';

class StudyHarmonyLevelEngine {
  StudyHarmonyLevelEngine({
    required this.level,
    Random? random,
    StudyHarmonyLegacyLessonAdapter? legacyAdapter,
  }) : _controller = StudyHarmonySessionController(
         lesson: (legacyAdapter ?? const StudyHarmonyLegacyLessonAdapter())
             .adaptLevel(level),
         random: random,
       );

  final StudyHarmonyLevelDefinition level;
  final StudyHarmonySessionController _controller;

  StudyHarmonySessionController get sessionController => _controller;

  StudyHarmonyPromptDefinition get currentPrompt =>
      _legacyPromptFromTask(_controller.state.currentTask!);

  StudyHarmonySubmissionFeedback get lastFeedback =>
      _legacyFeedbackFromEvaluation(_controller.state.lastEvaluation);

  int get correctAnswers => _controller.state.correctAnswers;
  int get attempts => _controller.state.attempts;
  int get livesRemaining => _controller.state.livesRemaining;
  Duration get elapsed => _controller.state.elapsed;
  Set<String> get selectedAnswerIds => _controller.state.selectedAnswerIds;
  bool get isCompleted => _controller.state.isCompleted;
  bool get isGameOver => _controller.state.isGameOver;
  bool get isFinished => _controller.state.isFinished;
  double get accuracy => _controller.state.accuracy;

  void restart() {
    _controller.restart();
  }

  void toggleAnswer(String answerId) {
    _controller.toggleAnswer(answerId);
  }

  StudyHarmonySubmissionFeedback submit() {
    final evaluation = _controller.submit();
    return _legacyFeedbackFromEvaluation(evaluation);
  }

  StudyHarmonyPromptDefinition _legacyPromptFromTask(
    StudyHarmonyTaskInstance task,
  ) {
    final acceptedAnswerSets =
        task.evaluator is StudyHarmonyAcceptedAnswerSetProvider
        ? [
            for (final acceptedSet
                in (task.evaluator as StudyHarmonyAcceptedAnswerSetProvider)
                    .acceptedAnswerSets)
              Set<String>.unmodifiable(acceptedSet),
          ]
        : const <Set<String>>[];

    return StudyHarmonyPromptDefinition(
      id: task.prompt.id,
      promptLabel: task.prompt.primaryLabel,
      answerSummaryLabel: task.answerSummaryLabel,
      acceptedAnswerSets: acceptedAnswerSets,
      promptHighlightedAnswerIds: task.prompt.highlightedAnswerIds,
      promptHint: task.prompt.hint,
    );
  }

  StudyHarmonySubmissionFeedback _legacyFeedbackFromEvaluation(
    StudyHarmonyEvaluationResult evaluation,
  ) {
    return StudyHarmonySubmissionFeedback(
      type: switch (evaluation.status) {
        StudyHarmonyEvaluationStatus.idle =>
          StudyHarmonySubmissionFeedbackType.idle,
        StudyHarmonyEvaluationStatus.needsSelection ||
        StudyHarmonyEvaluationStatus.invalidSelection =>
          StudyHarmonySubmissionFeedbackType.needsSelection,
        StudyHarmonyEvaluationStatus.correct =>
          StudyHarmonySubmissionFeedbackType.correct,
        StudyHarmonyEvaluationStatus.incorrect =>
          StudyHarmonySubmissionFeedbackType.incorrect,
      },
      promptLabel: evaluation.promptLabel,
      answerLabel: evaluation.answerLabel,
    );
  }
}
