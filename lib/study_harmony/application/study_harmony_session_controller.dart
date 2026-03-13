import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/study_harmony_session_models.dart';

class StudyHarmonySessionController extends ChangeNotifier {
  StudyHarmonySessionController({
    required StudyHarmonyLessonDefinition lesson,
    Random? random,
    Stopwatch? stopwatch,
  }) : _lesson = lesson,
       _random = random ?? Random(),
       _stopwatch = stopwatch ?? Stopwatch() {
    _state = StudyHarmonySessionState.loading(
      mode: _lesson.sessionMode,
      lesson: _lesson,
    );
    _initializeSession();
  }

  final StudyHarmonyLessonDefinition _lesson;
  final Random _random;
  final Stopwatch _stopwatch;
  final Map<StudyHarmonySkillTag, int> _skillAttemptCounts =
      <StudyHarmonySkillTag, int>{};
  final Map<StudyHarmonySkillTag, int> _skillCorrectCounts =
      <StudyHarmonySkillTag, int>{};
  final Map<StudyHarmonyLessonId, int> _lessonAttemptCounts =
      <StudyHarmonyLessonId, int>{};
  final Map<StudyHarmonyLessonId, int> _lessonCorrectCounts =
      <StudyHarmonyLessonId, int>{};

  late StudyHarmonySessionState _state;
  int _nextTaskSequenceNumber = 0;

  StudyHarmonyLessonDefinition get lesson => _lesson;
  StudyHarmonySessionState get state => _state;

  void restart() {
    _state = StudyHarmonySessionState.loading(
      mode: _lesson.sessionMode,
      lesson: _lesson,
    );
    _initializeSession(notify: true);
  }

  void advanceAfterFeedback() {
    if (_state.isFinished ||
        (_state.phase != StudyHarmonySessionPhase.submittedCorrect &&
            _state.phase != StudyHarmonySessionPhase.submittedIncorrect)) {
      return;
    }

    _advanceToNextTask();
    notifyListeners();
  }

  void toggleAnswer(StudyHarmonyAnswerOptionId answerId) {
    if (_state.isFinished || _state.phase == StudyHarmonySessionPhase.loading) {
      return;
    }

    if (_state.phase == StudyHarmonySessionPhase.submittedCorrect ||
        _state.phase == StudyHarmonySessionPhase.submittedIncorrect) {
      _advanceToNextTask();
    }

    final task = _state.currentTask;
    if (task == null || !task.containsAnswerId(answerId)) {
      return;
    }

    final nextSelection = Set<StudyHarmonyAnswerOptionId>.from(
      _state.selectedAnswerIds,
    );
    if (task.selectionMode == StudyHarmonySelectionModeKind.single) {
      final alreadySelected = nextSelection.contains(answerId);
      nextSelection.clear();
      if (!alreadySelected) {
        nextSelection.add(answerId);
      }
    } else if (!nextSelection.add(answerId)) {
      nextSelection.remove(answerId);
    }

    _state = _state.copyWith(
      selectedAnswerIds: Set<StudyHarmonyAnswerOptionId>.unmodifiable(
        nextSelection,
      ),
      lastEvaluation: const StudyHarmonyEvaluationResult.idle(),
      phase: nextSelection.isEmpty
          ? StudyHarmonySessionPhase.ready
          : StudyHarmonySessionPhase.answering,
      elapsed: _stopwatch.elapsed,
    );
    notifyListeners();
  }

  StudyHarmonyEvaluationResult submit() {
    if (_state.isFinished ||
        _state.phase == StudyHarmonySessionPhase.loading ||
        _state.phase == StudyHarmonySessionPhase.submittedCorrect ||
        _state.phase == StudyHarmonySessionPhase.submittedIncorrect) {
      return _state.lastEvaluation;
    }

    final task = _state.currentTask;
    if (task == null) {
      return const StudyHarmonyEvaluationResult.idle();
    }

    final submittedAnswerIds = Set<StudyHarmonyAnswerOptionId>.from(
      _state.selectedAnswerIds,
    );
    final evaluation = task.evaluator.evaluate(
      task: task,
      submittedAnswerIds: submittedAnswerIds,
    );

    switch (evaluation.status) {
      case StudyHarmonyEvaluationStatus.idle:
        return evaluation;
      case StudyHarmonyEvaluationStatus.needsSelection:
      case StudyHarmonyEvaluationStatus.invalidSelection:
        _state = _state.copyWith(
          lastEvaluation: evaluation,
          phase: submittedAnswerIds.isEmpty
              ? StudyHarmonySessionPhase.ready
              : StudyHarmonySessionPhase.answering,
          elapsed: _stopwatch.elapsed,
        );
        notifyListeners();
        return evaluation;
      case StudyHarmonyEvaluationStatus.correct:
      case StudyHarmonyEvaluationStatus.incorrect:
        _recordTaskOutcome(task: task, wasCorrect: evaluation.isCorrect);
        final nextCorrectAnswers =
            _state.correctAnswers + (evaluation.isCorrect ? 1 : 0);
        final nextLivesRemaining = evaluation.isCorrect
            ? _state.livesRemaining
            : max(0, _state.livesRemaining - 1);
        final nextPhase = _phaseAfterSubmission(
          isCorrect: evaluation.isCorrect,
          correctAnswers: nextCorrectAnswers,
          livesRemaining: nextLivesRemaining,
        );

        _state = _state.copyWith(
          selectedAnswerIds: const <StudyHarmonyAnswerOptionId>{},
          lastEvaluation: evaluation,
          correctAnswers: nextCorrectAnswers,
          attempts: _state.attempts + 1,
          livesRemaining: nextLivesRemaining,
          phase: nextPhase,
          elapsed: _stopwatch.elapsed,
          performance: _buildPerformance(),
        );

        if (_state.isFinished) {
          _stopwatch.stop();
          _state = _state.copyWith(elapsed: _stopwatch.elapsed);
        }

        notifyListeners();
        return evaluation;
    }
  }

  void _initializeSession({bool notify = false}) {
    if (_lesson.tasks.isEmpty) {
      throw StateError('Study harmony lesson "${_lesson.id}" has no tasks.');
    }

    _nextTaskSequenceNumber = 0;
    _skillAttemptCounts.clear();
    _skillCorrectCounts.clear();
    _lessonAttemptCounts.clear();
    _lessonCorrectCounts.clear();
    _stopwatch
      ..reset()
      ..start();

    _state = StudyHarmonySessionState(
      mode: _lesson.sessionMode,
      lesson: _lesson,
      phase: StudyHarmonySessionPhase.ready,
      currentTask: _pickNextTask(),
      correctAnswers: 0,
      attempts: 0,
      livesRemaining: _lesson.startingLives,
      elapsed: Duration.zero,
      performance: const StudyHarmonySessionPerformance(),
    );

    if (notify) {
      notifyListeners();
    }
  }

  void _advanceToNextTask() {
    final currentTask = _state.currentTask;
    if (currentTask == null || _state.isFinished) {
      return;
    }

    _state = _state.copyWith(
      currentTask: _pickNextTask(previousBlueprintId: currentTask.blueprintId),
      selectedAnswerIds: const <StudyHarmonyAnswerOptionId>{},
      lastEvaluation: const StudyHarmonyEvaluationResult.idle(),
      phase: StudyHarmonySessionPhase.ready,
      elapsed: _stopwatch.elapsed,
    );
  }

  void _recordTaskOutcome({
    required StudyHarmonyTaskInstance task,
    required bool wasCorrect,
  }) {
    final skillTags = task.skillTags.isNotEmpty
        ? task.skillTags
        : _lesson.skillTags;
    for (final skillId in skillTags) {
      _skillAttemptCounts.update(
        skillId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      if (wasCorrect) {
        _skillCorrectCounts.update(
          skillId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    _lessonAttemptCounts.update(
      task.lessonId,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
    if (wasCorrect) {
      _lessonCorrectCounts.update(
        task.lessonId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
  }

  StudyHarmonySessionPerformance _buildPerformance() {
    final skillSummaries =
        <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{
          for (final entry in _skillAttemptCounts.entries)
            entry.key: StudyHarmonySkillSessionSummary(
              skillId: entry.key,
              attemptCount: entry.value,
              correctCount: _skillCorrectCounts[entry.key] ?? 0,
            ),
        };
    final lessonSummaries =
        <StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>{
          for (final entry in _lessonAttemptCounts.entries)
            entry.key: StudyHarmonyLessonSessionSummary(
              lessonId: entry.key,
              attemptCount: entry.value,
              correctCount: _lessonCorrectCounts[entry.key] ?? 0,
            ),
        };
    return StudyHarmonySessionPerformance(
      skillSummaries: skillSummaries,
      lessonSummaries: lessonSummaries,
    );
  }

  StudyHarmonySessionPhase _phaseAfterSubmission({
    required bool isCorrect,
    required int correctAnswers,
    required int livesRemaining,
  }) {
    if (correctAnswers >= _lesson.goalCorrectAnswers) {
      return StudyHarmonySessionPhase.completed;
    }
    if (livesRemaining <= 0) {
      return StudyHarmonySessionPhase.gameOver;
    }
    return isCorrect
        ? StudyHarmonySessionPhase.submittedCorrect
        : StudyHarmonySessionPhase.submittedIncorrect;
  }

  StudyHarmonyTaskInstance _pickNextTask({
    StudyHarmonyTaskBlueprintId? previousBlueprintId,
  }) {
    final tasks = _lesson.tasks;
    if (tasks.length == 1) {
      return tasks.single.createInstance(
        sequenceNumber: _nextTaskSequenceNumber++,
        random: _random,
      );
    }

    var candidate = tasks[_random.nextInt(tasks.length)];
    if (candidate.id != previousBlueprintId) {
      return candidate.createInstance(
        sequenceNumber: _nextTaskSequenceNumber++,
        random: _random,
      );
    }

    final alternatives = tasks
        .where((task) => task.id != previousBlueprintId)
        .toList(growable: false);
    final nextTask = alternatives[_random.nextInt(alternatives.length)];
    return nextTask.createInstance(
      sequenceNumber: _nextTaskSequenceNumber++,
      random: _random,
    );
  }
}
