import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'study_harmony_session_models.dart';

const Set<StudyHarmonyTaskKind> _exactSetTaskKinds = <StudyHarmonyTaskKind>{
  StudyHarmonyTaskKind.legacyPrototype,
  StudyHarmonyTaskKind.noteOnKeyboard,
  StudyHarmonyTaskKind.chordOnKeyboard,
  StudyHarmonyTaskKind.scaleTonesChoice,
};

const Set<StudyHarmonyTaskKind> _singleChoiceTaskKinds = <StudyHarmonyTaskKind>{
  StudyHarmonyTaskKind.legacyPrototype,
  StudyHarmonyTaskKind.noteNameChoice,
  StudyHarmonyTaskKind.chordNameChoice,
  StudyHarmonyTaskKind.romanToChordChoice,
  StudyHarmonyTaskKind.chordToRomanChoice,
  StudyHarmonyTaskKind.diatonicityChoice,
  StudyHarmonyTaskKind.functionChoice,
  StudyHarmonyTaskKind.progressionKeyCenterChoice,
  StudyHarmonyTaskKind.progressionFunctionChoice,
  StudyHarmonyTaskKind.progressionNonDiatonicChoice,
  StudyHarmonyTaskKind.progressionMissingChordChoice,
};

const Set<StudyHarmonyTaskKind> _multiChoiceTaskKinds = <StudyHarmonyTaskKind>{
  StudyHarmonyTaskKind.legacyPrototype,
  StudyHarmonyTaskKind.noteOnKeyboard,
  StudyHarmonyTaskKind.chordOnKeyboard,
  StudyHarmonyTaskKind.scaleTonesChoice,
};

class ExactSetEvaluator extends StudyHarmonyTaskEvaluator
    implements StudyHarmonyAcceptedAnswerSetProvider {
  ExactSetEvaluator({
    required Iterable<Set<StudyHarmonyAnswerOptionId>> acceptedAnswerSets,
    StudyHarmonySelectionModeKind selectionMode =
        StudyHarmonySelectionModeKind.multiple,
    Set<StudyHarmonyTaskKind> supportedTaskKinds = _exactSetTaskKinds,
  }) : acceptedAnswerSets = List.unmodifiable([
         for (final acceptedSet in acceptedAnswerSets)
           Set<StudyHarmonyAnswerOptionId>.unmodifiable(acceptedSet),
       ]),
       _selectionMode = selectionMode,
       _supportedTaskKinds = Set<StudyHarmonyTaskKind>.unmodifiable(
         supportedTaskKinds,
       );

  @override
  final List<Set<StudyHarmonyAnswerOptionId>> acceptedAnswerSets;

  final StudyHarmonySelectionModeKind _selectionMode;
  final Set<StudyHarmonyTaskKind> _supportedTaskKinds;

  @override
  String get id => 'exactSet';

  @override
  StudyHarmonySelectionModeKind get selectionMode => _selectionMode;

  @override
  Set<StudyHarmonyTaskKind> get supportedTaskKinds => _supportedTaskKinds;

  @override
  bool get supportsPartialScore => true;

  @override
  StudyHarmonyEvaluationResult evaluate({
    required StudyHarmonyTaskInstance task,
    required Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
  }) {
    if (submittedAnswerIds.isEmpty) {
      return _buildResult(
        task: task,
        status: StudyHarmonyEvaluationStatus.needsSelection,
        submittedAnswerIds: submittedAnswerIds,
        acceptedAnswerIds: const <StudyHarmonyAnswerOptionId>{},
        scoreFraction: 0,
      );
    }

    if (selectionMode == StudyHarmonySelectionModeKind.single &&
        submittedAnswerIds.length != 1) {
      final acceptedAnswerIds = _bestAcceptedAnswerIds(submittedAnswerIds);
      return _buildResult(
        task: task,
        status: StudyHarmonyEvaluationStatus.invalidSelection,
        submittedAnswerIds: submittedAnswerIds,
        acceptedAnswerIds: acceptedAnswerIds,
        scoreFraction: 0,
      );
    }

    final acceptedAnswerIds = _bestAcceptedAnswerIds(submittedAnswerIds);
    final isCorrect = setEquals(acceptedAnswerIds, submittedAnswerIds);
    return _buildResult(
      task: task,
      status: isCorrect
          ? StudyHarmonyEvaluationStatus.correct
          : StudyHarmonyEvaluationStatus.incorrect,
      submittedAnswerIds: submittedAnswerIds,
      acceptedAnswerIds: acceptedAnswerIds,
      scoreFraction: isCorrect
          ? 1
          : _scoreFraction(
              acceptedAnswerIds: acceptedAnswerIds,
              submittedAnswerIds: submittedAnswerIds,
            ),
    );
  }

  Set<StudyHarmonyAnswerOptionId> _bestAcceptedAnswerIds(
    Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
  ) {
    if (acceptedAnswerSets.isEmpty) {
      return const <StudyHarmonyAnswerOptionId>{};
    }

    var bestAcceptedSet = acceptedAnswerSets.first;
    var bestScore = _scoreFraction(
      acceptedAnswerIds: bestAcceptedSet,
      submittedAnswerIds: submittedAnswerIds,
    );
    for (final acceptedSet in acceptedAnswerSets.skip(1)) {
      final score = _scoreFraction(
        acceptedAnswerIds: acceptedSet,
        submittedAnswerIds: submittedAnswerIds,
      );
      if (score > bestScore ||
          (score == bestScore && acceptedSet.length < bestAcceptedSet.length)) {
        bestAcceptedSet = acceptedSet;
        bestScore = score;
      }
    }
    return bestAcceptedSet;
  }

  double _scoreFraction({
    required Set<StudyHarmonyAnswerOptionId> acceptedAnswerIds,
    required Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
  }) {
    if (acceptedAnswerIds.isEmpty || submittedAnswerIds.isEmpty) {
      return 0;
    }

    final sharedCount = acceptedAnswerIds
        .intersection(submittedAnswerIds)
        .length
        .toDouble();
    final denominator = math.max(
      acceptedAnswerIds.length,
      submittedAnswerIds.length,
    );
    if (denominator == 0) {
      return 0;
    }
    return sharedCount / denominator;
  }

  StudyHarmonyEvaluationResult _buildResult({
    required StudyHarmonyTaskInstance task,
    required StudyHarmonyEvaluationStatus status,
    required Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
    required Set<StudyHarmonyAnswerOptionId> acceptedAnswerIds,
    required double scoreFraction,
  }) {
    final correctAnswerSummary = _summaryForAnswerIds(
      task: task,
      answerIds: acceptedAnswerIds,
      fallback: task.answerSummaryLabel,
    );
    final selectedAnswerSummary = _summaryForAnswerIds(
      task: task,
      answerIds: submittedAnswerIds,
      fallback: '',
    );
    final explanationBody =
        task.explanationBody ??
        task.prompt.hint ??
        (correctAnswerSummary.isEmpty
            ? task.answerSummaryLabel
            : correctAnswerSummary);

    return StudyHarmonyEvaluationResult(
      status: status,
      correctness: status == StudyHarmonyEvaluationStatus.correct,
      scoreFraction: scoreFraction.clamp(0, 1).toDouble(),
      submittedAnswerIds: Set<StudyHarmonyAnswerOptionId>.unmodifiable(
        submittedAnswerIds,
      ),
      acceptedAnswerIds: Set<StudyHarmonyAnswerOptionId>.unmodifiable(
        acceptedAnswerIds,
      ),
      promptLabel: task.prompt.primaryLabel,
      answerLabel: task.answerSummaryLabel,
      correctAnswerSummary: correctAnswerSummary,
      selectedAnswerSummary: selectedAnswerSummary,
      explanationTitle: task.explanationTitle ?? task.prompt.primaryLabel,
      explanationBody: explanationBody,
      explanationBundle: task.explanationBundle,
      evaluatorId: id,
      skillTags: Set<StudyHarmonySkillTag>.unmodifiable(task.skillTags),
    );
  }
}

class SingleChoiceEvaluator extends ExactSetEvaluator {
  SingleChoiceEvaluator({
    required Iterable<StudyHarmonyAnswerOptionId> acceptedChoiceIds,
    super.supportedTaskKinds = _singleChoiceTaskKinds,
  }) : super(
         acceptedAnswerSets: [
           for (final acceptedChoiceId in acceptedChoiceIds) {acceptedChoiceId},
         ],
         selectionMode: StudyHarmonySelectionModeKind.single,
       );

  @override
  String get id => 'singleChoice';
}

class MultiChoiceEvaluator extends ExactSetEvaluator {
  MultiChoiceEvaluator({
    required super.acceptedAnswerSets,
    super.supportedTaskKinds = _multiChoiceTaskKinds,
  }) : super(selectionMode: StudyHarmonySelectionModeKind.multiple);

  @override
  String get id => 'multiChoice';
}

String _summaryForAnswerIds({
  required StudyHarmonyTaskInstance task,
  required Set<StudyHarmonyAnswerOptionId> answerIds,
  required String fallback,
}) {
  if (answerIds.isEmpty) {
    return fallback;
  }

  final labels = task.displayLabelsForAnswerIds(answerIds);
  if (labels.isEmpty) {
    return fallback;
  }
  return labels.join(', ');
}
