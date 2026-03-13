import 'package:flutter/foundation.dart';

enum StudyHarmonyPromptSurface { text, pianoPreview }

enum StudyHarmonyAnswerSurface { pianoKeyboard, choiceChips }

enum StudyHarmonySelectionMode { single, multiple }

enum StudyHarmonySubmissionFeedbackType {
  idle,
  needsSelection,
  correct,
  incorrect,
}

@immutable
class StudyHarmonyLevelDefinition {
  const StudyHarmonyLevelDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.goalCorrectAnswers,
    required this.startingLives,
    required this.promptSurface,
    required this.answerSurface,
    required this.selectionMode,
    required this.prompts,
    this.pianoKeys = const <StudyHarmonyPianoKeyDefinition>[],
    this.answerChoices = const <StudyHarmonyChoiceDefinition>[],
  });

  final String id;
  final String title;
  final String description;
  final String objective;
  final int goalCorrectAnswers;
  final int startingLives;
  final StudyHarmonyPromptSurface promptSurface;
  final StudyHarmonyAnswerSurface answerSurface;
  final StudyHarmonySelectionMode selectionMode;
  final List<StudyHarmonyPromptDefinition> prompts;
  final List<StudyHarmonyPianoKeyDefinition> pianoKeys;
  final List<StudyHarmonyChoiceDefinition> answerChoices;

  bool containsAnswerId(String answerId) {
    return switch (answerSurface) {
      StudyHarmonyAnswerSurface.pianoKeyboard => pianoKeys.any(
        (key) => key.id == answerId,
      ),
      StudyHarmonyAnswerSurface.choiceChips => answerChoices.any(
        (choice) => choice.id == answerId,
      ),
    };
  }

  List<String> displayLabelsForAnswerIds(Iterable<String> answerIds) {
    final ids = answerIds.toSet();
    return switch (answerSurface) {
      StudyHarmonyAnswerSurface.pianoKeyboard =>
        pianoKeys
            .where((key) => ids.contains(key.id))
            .map((key) => key.combinedLabel)
            .toList(growable: false),
      StudyHarmonyAnswerSurface.choiceChips =>
        answerChoices
            .where((choice) => ids.contains(choice.id))
            .map((choice) => choice.label)
            .toList(growable: false),
    };
  }
}

@immutable
class StudyHarmonyPromptDefinition {
  const StudyHarmonyPromptDefinition({
    required this.id,
    required this.promptLabel,
    required this.answerSummaryLabel,
    required this.acceptedAnswerSets,
    this.promptHighlightedAnswerIds = const <String>{},
    this.promptHint,
  });

  final String id;
  final String promptLabel;
  final String answerSummaryLabel;
  final List<Set<String>> acceptedAnswerSets;
  final Set<String> promptHighlightedAnswerIds;
  final String? promptHint;
}

@immutable
class StudyHarmonyPianoKeyDefinition {
  const StudyHarmonyPianoKeyDefinition({
    required this.id,
    required this.westernLabel,
    required this.solfegeLabel,
    required this.isBlack,
    this.whiteIndex,
    this.blackGapAfterWhiteIndex,
  });

  final String id;
  final String westernLabel;
  final String solfegeLabel;
  final bool isBlack;
  final int? whiteIndex;
  final int? blackGapAfterWhiteIndex;

  String get combinedLabel => '$solfegeLabel ($westernLabel)';
}

@immutable
class StudyHarmonyChoiceDefinition {
  const StudyHarmonyChoiceDefinition({required this.id, required this.label});

  final String id;
  final String label;
}

@immutable
class StudyHarmonySubmissionFeedback {
  const StudyHarmonySubmissionFeedback({
    required this.type,
    this.promptLabel,
    this.answerLabel,
  });

  const StudyHarmonySubmissionFeedback.idle()
    : type = StudyHarmonySubmissionFeedbackType.idle,
      promptLabel = null,
      answerLabel = null;

  final StudyHarmonySubmissionFeedbackType type;
  final String? promptLabel;
  final String? answerLabel;
}
