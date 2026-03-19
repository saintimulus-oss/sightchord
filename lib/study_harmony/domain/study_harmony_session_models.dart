import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../music/explanation_models.dart';

typedef StudyHarmonyTrackId = String;
typedef StudyHarmonyCourseId = String;
typedef StudyHarmonyChapterId = String;
typedef StudyHarmonyLessonId = String;
typedef StudyHarmonyTaskBlueprintId = String;
typedef StudyHarmonyPromptId = String;
typedef StudyHarmonyAnswerOptionId = String;
typedef StudyHarmonySkillTag = String;

enum StudyHarmonyTaskKind {
  legacyPrototype,
  noteOnKeyboard,
  noteNameChoice,
  chordOnKeyboard,
  chordNameChoice,
  scaleTonesChoice,
  romanToChordChoice,
  chordToRomanChoice,
  diatonicityChoice,
  functionChoice,
  progressionKeyCenterChoice,
  progressionFunctionChoice,
  progressionNonDiatonicChoice,
  progressionMissingChordChoice,
}

enum StudyHarmonyPromptSurfaceKind { text, pianoPreview }

enum StudyHarmonyAnswerSurfaceKind { pianoKeyboard, choiceChips }

enum StudyHarmonySelectionModeKind { single, multiple }

enum StudyHarmonySessionMode {
  legacyLevel,
  lesson,
  review,
  daily,
  focus,
  relay,
  bossRush,
  legend,
}

enum TrackExerciseFlavor {
  coreFunctional,
  popHookLoop,
  popBorrowedLift,
  popBassMotion,
  jazzGuideTone,
  jazzShellVoicing,
  jazzMinorCadence,
  jazzRootlessVoicing,
  jazzDominantColor,
  jazzBackdoorCadence,
  classicalCadence,
  classicalInversion,
  classicalSecondaryDominant,
}

enum StudyHarmonySessionPhase {
  loading,
  ready,
  answering,
  submittedCorrect,
  submittedIncorrect,
  completed,
  gameOver,
}

enum StudyHarmonyEvaluationStatus {
  idle,
  needsSelection,
  invalidSelection,
  correct,
  incorrect,
}

@immutable
class StudyHarmonyCourseDefinition {
  const StudyHarmonyCourseDefinition({
    required this.id,
    required this.trackId,
    required this.title,
    required this.description,
    this.chapters = const <StudyHarmonyChapterDefinition>[],
    this.skillTags = const <StudyHarmonySkillTag>{},
  });

  final StudyHarmonyCourseId id;
  final StudyHarmonyTrackId trackId;
  final String title;
  final String description;
  final List<StudyHarmonyChapterDefinition> chapters;
  final Set<StudyHarmonySkillTag> skillTags;
}

@immutable
class StudyHarmonyChapterDefinition {
  const StudyHarmonyChapterDefinition({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    this.lessons = const <StudyHarmonyLessonDefinition>[],
    this.skillTags = const <StudyHarmonySkillTag>{},
  });

  final StudyHarmonyChapterId id;
  final StudyHarmonyCourseId courseId;
  final String title;
  final String description;
  final List<StudyHarmonyLessonDefinition> lessons;
  final Set<StudyHarmonySkillTag> skillTags;
}

@immutable
class StudyHarmonyLessonDefinition {
  const StudyHarmonyLessonDefinition({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.objectiveLabel,
    required this.goalCorrectAnswers,
    required this.startingLives,
    required this.sessionMode,
    required this.tasks,
    this.skillTags = const <StudyHarmonySkillTag>{},
    this.sessionMetadata = const StudyHarmonySessionMetadata(),
  });

  final StudyHarmonyLessonId id;
  final StudyHarmonyChapterId chapterId;
  final String title;
  final String description;
  final String objectiveLabel;
  final int goalCorrectAnswers;
  final int startingLives;
  final StudyHarmonySessionMode sessionMode;
  final List<StudyHarmonyTaskBlueprint> tasks;
  final Set<StudyHarmonySkillTag> skillTags;
  final StudyHarmonySessionMetadata sessionMetadata;
}

@immutable
class StudyHarmonySessionMetadata {
  const StudyHarmonySessionMetadata({
    this.anchorLessonId,
    this.sourceLessonIds = const <StudyHarmonyLessonId>{},
    this.focusSkillTags = const <StudyHarmonySkillTag>{},
    this.countsTowardLessonProgress = true,
    this.arcadeModeId,
    this.reviewReason,
    this.dailyDateKey,
    this.dailySeedValue,
    this.missLifePenalty = 1,
    this.missProgressPenalty = 0,
    this.comboProgressThreshold = 0,
    this.comboProgressBonus = 0,
    this.comboLifeThreshold = 0,
    this.comboLifeBonus = 0,
    this.comboDropOnMiss = 0,
    this.comboResetsOnMiss = true,
    this.shuffleChoiceOptions = false,
    this.repeatMissedTask = false,
    this.uniqueTaskCycle = false,
  });

  final StudyHarmonyLessonId? anchorLessonId;
  final Set<StudyHarmonyLessonId> sourceLessonIds;
  final Set<StudyHarmonySkillTag> focusSkillTags;
  final bool countsTowardLessonProgress;
  final String? arcadeModeId;
  final String? reviewReason;
  final String? dailyDateKey;
  final int? dailySeedValue;
  final int missLifePenalty;
  final int missProgressPenalty;
  final int comboProgressThreshold;
  final int comboProgressBonus;
  final int comboLifeThreshold;
  final int comboLifeBonus;
  final int comboDropOnMiss;
  final bool comboResetsOnMiss;
  final bool shuffleChoiceOptions;
  final bool repeatMissedTask;
  final bool uniqueTaskCycle;

  StudyHarmonySessionMetadata copyWith({
    StudyHarmonyLessonId? anchorLessonId,
    Set<StudyHarmonyLessonId>? sourceLessonIds,
    Set<StudyHarmonySkillTag>? focusSkillTags,
    bool? countsTowardLessonProgress,
    String? arcadeModeId,
    String? reviewReason,
    String? dailyDateKey,
    int? dailySeedValue,
    int? missLifePenalty,
    int? missProgressPenalty,
    int? comboProgressThreshold,
    int? comboProgressBonus,
    int? comboLifeThreshold,
    int? comboLifeBonus,
    int? comboDropOnMiss,
    bool? comboResetsOnMiss,
    bool? shuffleChoiceOptions,
    bool? repeatMissedTask,
    bool? uniqueTaskCycle,
    bool clearAnchorLessonId = false,
    bool clearArcadeModeId = false,
    bool clearReviewReason = false,
    bool clearDailyDateKey = false,
    bool clearDailySeedValue = false,
  }) {
    return StudyHarmonySessionMetadata(
      anchorLessonId: clearAnchorLessonId
          ? null
          : anchorLessonId ?? this.anchorLessonId,
      sourceLessonIds: sourceLessonIds ?? this.sourceLessonIds,
      focusSkillTags: focusSkillTags ?? this.focusSkillTags,
      countsTowardLessonProgress:
          countsTowardLessonProgress ?? this.countsTowardLessonProgress,
      arcadeModeId: clearArcadeModeId
          ? null
          : arcadeModeId ?? this.arcadeModeId,
      reviewReason: clearReviewReason
          ? null
          : reviewReason ?? this.reviewReason,
      dailyDateKey: clearDailyDateKey
          ? null
          : dailyDateKey ?? this.dailyDateKey,
      dailySeedValue: clearDailySeedValue
          ? null
          : dailySeedValue ?? this.dailySeedValue,
      missLifePenalty: missLifePenalty ?? this.missLifePenalty,
      missProgressPenalty: missProgressPenalty ?? this.missProgressPenalty,
      comboProgressThreshold:
          comboProgressThreshold ?? this.comboProgressThreshold,
      comboProgressBonus: comboProgressBonus ?? this.comboProgressBonus,
      comboLifeThreshold: comboLifeThreshold ?? this.comboLifeThreshold,
      comboLifeBonus: comboLifeBonus ?? this.comboLifeBonus,
      comboDropOnMiss: comboDropOnMiss ?? this.comboDropOnMiss,
      comboResetsOnMiss: comboResetsOnMiss ?? this.comboResetsOnMiss,
      shuffleChoiceOptions: shuffleChoiceOptions ?? this.shuffleChoiceOptions,
      repeatMissedTask: repeatMissedTask ?? this.repeatMissedTask,
      uniqueTaskCycle: uniqueTaskCycle ?? this.uniqueTaskCycle,
    );
  }
}

@immutable
class StudyHarmonyPromptSpec {
  const StudyHarmonyPromptSpec({
    required this.id,
    required this.surface,
    required this.primaryLabel,
    this.highlightedAnswerIds = const <StudyHarmonyAnswerOptionId>{},
    this.hint,
    this.progressionDisplay,
  });

  final StudyHarmonyPromptId id;
  final StudyHarmonyPromptSurfaceKind surface;
  final String primaryLabel;
  final Set<StudyHarmonyAnswerOptionId> highlightedAnswerIds;
  final String? hint;
  final StudyHarmonyProgressionDisplaySpec? progressionDisplay;

  bool get showsPianoPreview =>
      surface == StudyHarmonyPromptSurfaceKind.pianoPreview;

  bool get showsProgressionPreview => progressionDisplay != null;
}

@immutable
class StudyHarmonyProgressionDisplaySpec {
  const StudyHarmonyProgressionDisplaySpec({
    required this.slots,
    this.summaryLabel,
  });

  final List<StudyHarmonyProgressionSlotSpec> slots;
  final String? summaryLabel;
}

@immutable
class StudyHarmonyProgressionSlotSpec {
  const StudyHarmonyProgressionSlotSpec({
    required this.id,
    required this.label,
    this.measureLabel,
    this.isHidden = false,
    this.isHighlighted = false,
  });

  final String id;
  final String label;
  final String? measureLabel;
  final bool isHidden;
  final bool isHighlighted;
}

@immutable
abstract class StudyHarmonyAnswerOption {
  const StudyHarmonyAnswerOption({required this.id});

  final StudyHarmonyAnswerOptionId id;

  String get displayLabel;
}

@immutable
class StudyHarmonyAnswerChoice extends StudyHarmonyAnswerOption {
  const StudyHarmonyAnswerChoice({required super.id, required this.label});

  final String label;

  @override
  String get displayLabel => label;
}

@immutable
class StudyHarmonyPianoAnswerOption extends StudyHarmonyAnswerOption {
  const StudyHarmonyPianoAnswerOption({
    required super.id,
    required this.westernLabel,
    required this.solfegeLabel,
    required this.isBlack,
    this.whiteIndex,
    this.blackGapAfterWhiteIndex,
  });

  final String westernLabel;
  final String solfegeLabel;
  final bool isBlack;
  final int? whiteIndex;
  final int? blackGapAfterWhiteIndex;

  String get combinedLabel => '$solfegeLabel ($westernLabel)';

  @override
  String get displayLabel => combinedLabel;
}

abstract class StudyHarmonyTaskEvaluator {
  const StudyHarmonyTaskEvaluator();

  String get id;

  StudyHarmonySelectionModeKind get selectionMode;

  Set<StudyHarmonyTaskKind> get supportedTaskKinds;

  bool get supportsPartialScore => false;

  StudyHarmonyEvaluationResult evaluate({
    required StudyHarmonyTaskInstance task,
    required Set<StudyHarmonyAnswerOptionId> submittedAnswerIds,
  });
}

abstract class StudyHarmonyAcceptedAnswerSetProvider {
  List<Set<StudyHarmonyAnswerOptionId>> get acceptedAnswerSets;
}

typedef StudyHarmonyTaskInstanceFactory =
    StudyHarmonyTaskInstance Function({
      required StudyHarmonyTaskBlueprint blueprint,
      required int sequenceNumber,
      required Random random,
    });

@immutable
class StudyHarmonyTaskBlueprint {
  const StudyHarmonyTaskBlueprint({
    required this.id,
    required this.lessonId,
    required this.taskKind,
    required this.promptSpec,
    required this.answerOptions,
    required this.answerSummaryLabel,
    required this.answerSurface,
    required this.evaluator,
    this.instanceFactory,
    this.skillTags = const <StudyHarmonySkillTag>{},
    this.explanationTitle,
    this.explanationBody,
    this.trackExerciseFlavor,
    this.explanationBundle,
  });

  final StudyHarmonyTaskBlueprintId id;
  final StudyHarmonyLessonId lessonId;
  final StudyHarmonyTaskKind taskKind;
  final StudyHarmonyPromptSpec promptSpec;
  final List<StudyHarmonyAnswerOption> answerOptions;
  final String answerSummaryLabel;
  final StudyHarmonyAnswerSurfaceKind answerSurface;
  final StudyHarmonyTaskEvaluator evaluator;
  final StudyHarmonyTaskInstanceFactory? instanceFactory;
  final Set<StudyHarmonySkillTag> skillTags;
  final String? explanationTitle;
  final String? explanationBody;
  final TrackExerciseFlavor? trackExerciseFlavor;
  final ExplanationBundle? explanationBundle;

  StudyHarmonySelectionModeKind get selectionMode => evaluator.selectionMode;

  List<StudyHarmonyPianoAnswerOption> get pianoOptions => answerOptions
      .whereType<StudyHarmonyPianoAnswerOption>()
      .toList(growable: false);

  List<StudyHarmonyAnswerChoice> get choiceOptions => answerOptions
      .whereType<StudyHarmonyAnswerChoice>()
      .toList(growable: false);

  StudyHarmonyTaskInstance createInstance({
    required int sequenceNumber,
    Random? random,
  }) {
    final builder = instanceFactory;
    if (builder != null) {
      return builder(
        blueprint: this,
        sequenceNumber: sequenceNumber,
        random: random ?? Random(),
      );
    }

    return StudyHarmonyTaskInstance(
      blueprintId: id,
      lessonId: lessonId,
      taskKind: taskKind,
      prompt: promptSpec,
      answerOptions: answerOptions,
      answerSummaryLabel: answerSummaryLabel,
      answerSurface: answerSurface,
      evaluator: evaluator,
      skillTags: skillTags,
      sequenceNumber: sequenceNumber,
      explanationTitle: explanationTitle,
      explanationBody: explanationBody,
      trackExerciseFlavor: trackExerciseFlavor,
      explanationBundle: explanationBundle,
    );
  }
}

@immutable
class StudyHarmonyTaskInstance {
  const StudyHarmonyTaskInstance({
    required this.blueprintId,
    required this.lessonId,
    required this.taskKind,
    required this.prompt,
    required this.answerOptions,
    required this.answerSummaryLabel,
    required this.answerSurface,
    required this.evaluator,
    required this.sequenceNumber,
    this.skillTags = const <StudyHarmonySkillTag>{},
    this.explanationTitle,
    this.explanationBody,
    this.trackExerciseFlavor,
    this.explanationBundle,
  });

  final StudyHarmonyTaskBlueprintId blueprintId;
  final StudyHarmonyLessonId lessonId;
  final StudyHarmonyTaskKind taskKind;
  final StudyHarmonyPromptSpec prompt;
  final List<StudyHarmonyAnswerOption> answerOptions;
  final String answerSummaryLabel;
  final StudyHarmonyAnswerSurfaceKind answerSurface;
  final StudyHarmonyTaskEvaluator evaluator;
  final Set<StudyHarmonySkillTag> skillTags;
  final int sequenceNumber;
  final String? explanationTitle;
  final String? explanationBody;
  final TrackExerciseFlavor? trackExerciseFlavor;
  final ExplanationBundle? explanationBundle;

  StudyHarmonySelectionModeKind get selectionMode => evaluator.selectionMode;

  List<StudyHarmonyPianoAnswerOption> get pianoOptions => answerOptions
      .whereType<StudyHarmonyPianoAnswerOption>()
      .toList(growable: false);

  List<StudyHarmonyAnswerChoice> get choiceOptions => answerOptions
      .whereType<StudyHarmonyAnswerChoice>()
      .toList(growable: false);

  bool containsAnswerId(StudyHarmonyAnswerOptionId answerId) {
    return answerOptions.any((option) => option.id == answerId);
  }

  String? displayLabelForAnswerId(StudyHarmonyAnswerOptionId answerId) {
    for (final option in answerOptions) {
      if (option.id == answerId) {
        return option.displayLabel;
      }
    }
    return null;
  }

  List<String> displayLabelsForAnswerIds(
    Iterable<StudyHarmonyAnswerOptionId> answerIds,
  ) {
    final ids = answerIds.toSet();
    return answerOptions
        .where((option) => ids.contains(option.id))
        .map((option) => option.displayLabel)
        .toList(growable: false);
  }
}

@immutable
class StudyHarmonyEvaluationResult {
  const StudyHarmonyEvaluationResult({
    required this.status,
    required this.correctness,
    required this.scoreFraction,
    required this.submittedAnswerIds,
    this.acceptedAnswerIds = const <StudyHarmonyAnswerOptionId>{},
    this.promptLabel,
    this.answerLabel,
    this.correctAnswerSummary,
    this.selectedAnswerSummary,
    this.explanationTitle,
    this.explanationBody,
    this.explanationBundle,
    this.evaluatorId,
    this.skillTags = const <StudyHarmonySkillTag>{},
  });

  const StudyHarmonyEvaluationResult.idle()
    : status = StudyHarmonyEvaluationStatus.idle,
      correctness = false,
      scoreFraction = 0,
      submittedAnswerIds = const <StudyHarmonyAnswerOptionId>{},
      acceptedAnswerIds = const <StudyHarmonyAnswerOptionId>{},
      promptLabel = null,
      answerLabel = null,
      correctAnswerSummary = null,
      selectedAnswerSummary = null,
      explanationTitle = null,
      explanationBody = null,
      explanationBundle = null,
      evaluatorId = null,
      skillTags = const <StudyHarmonySkillTag>{};

  final StudyHarmonyEvaluationStatus status;
  final bool correctness;
  final double scoreFraction;
  final Set<StudyHarmonyAnswerOptionId> submittedAnswerIds;
  final Set<StudyHarmonyAnswerOptionId> acceptedAnswerIds;
  final String? promptLabel;
  final String? answerLabel;
  final String? correctAnswerSummary;
  final String? selectedAnswerSummary;
  final String? explanationTitle;
  final String? explanationBody;
  final ExplanationBundle? explanationBundle;
  final String? evaluatorId;
  final Set<StudyHarmonySkillTag> skillTags;

  bool get isCorrect =>
      status == StudyHarmonyEvaluationStatus.correct && correctness;
}

@immutable
class StudyHarmonySkillSessionSummary {
  const StudyHarmonySkillSessionSummary({
    required this.skillId,
    required this.attemptCount,
    required this.correctCount,
  });

  final StudyHarmonySkillTag skillId;
  final int attemptCount;
  final int correctCount;

  double get accuracy => attemptCount == 0 ? 0 : correctCount / attemptCount;
}

@immutable
class StudyHarmonyLessonSessionSummary {
  const StudyHarmonyLessonSessionSummary({
    required this.lessonId,
    required this.attemptCount,
    required this.correctCount,
  });

  final StudyHarmonyLessonId lessonId;
  final int attemptCount;
  final int correctCount;

  double get accuracy => attemptCount == 0 ? 0 : correctCount / attemptCount;
}

@immutable
class StudyHarmonySessionPerformance {
  const StudyHarmonySessionPerformance({
    this.skillSummaries =
        const <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{},
    this.lessonSummaries =
        const <StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>{},
  });

  final Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>
  skillSummaries;
  final Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>
  lessonSummaries;

  Set<StudyHarmonySkillTag> get activeSkillTags => skillSummaries.keys.toSet();

  bool get isEmpty => skillSummaries.isEmpty && lessonSummaries.isEmpty;
}

@immutable
class StudyHarmonySessionState {
  const StudyHarmonySessionState({
    required this.mode,
    required this.lesson,
    required this.phase,
    required this.livesRemaining,
    this.currentTask,
    this.selectedAnswerIds = const <StudyHarmonyAnswerOptionId>{},
    this.lastEvaluation = const StudyHarmonyEvaluationResult.idle(),
    this.progressPoints = 0,
    this.correctAnswers = 0,
    this.attempts = 0,
    this.currentCombo = 0,
    this.bestCombo = 0,
    this.elapsed = Duration.zero,
    this.performance = const StudyHarmonySessionPerformance(),
  });

  factory StudyHarmonySessionState.loading({
    required StudyHarmonySessionMode mode,
    required StudyHarmonyLessonDefinition lesson,
  }) {
    return StudyHarmonySessionState(
      mode: mode,
      lesson: lesson,
      phase: StudyHarmonySessionPhase.loading,
      livesRemaining: lesson.startingLives,
    );
  }

  final StudyHarmonySessionMode mode;
  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonySessionPhase phase;
  final StudyHarmonyTaskInstance? currentTask;
  final Set<StudyHarmonyAnswerOptionId> selectedAnswerIds;
  final StudyHarmonyEvaluationResult lastEvaluation;
  final int progressPoints;
  final int correctAnswers;
  final int attempts;
  final int currentCombo;
  final int bestCombo;
  final int livesRemaining;
  final Duration elapsed;
  final StudyHarmonySessionPerformance performance;

  bool get isCompleted => phase == StudyHarmonySessionPhase.completed;

  bool get isGameOver => phase == StudyHarmonySessionPhase.gameOver;

  bool get isFinished => isCompleted || isGameOver;

  double get accuracy => attempts == 0 ? 0 : correctAnswers / attempts;

  StudyHarmonySessionState copyWith({
    StudyHarmonySessionMode? mode,
    StudyHarmonyLessonDefinition? lesson,
    StudyHarmonySessionPhase? phase,
    StudyHarmonyTaskInstance? currentTask,
    Set<StudyHarmonyAnswerOptionId>? selectedAnswerIds,
    StudyHarmonyEvaluationResult? lastEvaluation,
    int? progressPoints,
    int? correctAnswers,
    int? attempts,
    int? currentCombo,
    int? bestCombo,
    int? livesRemaining,
    Duration? elapsed,
    StudyHarmonySessionPerformance? performance,
    bool clearCurrentTask = false,
    bool clearLastEvaluation = false,
  }) {
    return StudyHarmonySessionState(
      mode: mode ?? this.mode,
      lesson: lesson ?? this.lesson,
      phase: phase ?? this.phase,
      currentTask: clearCurrentTask ? null : currentTask ?? this.currentTask,
      selectedAnswerIds: selectedAnswerIds ?? this.selectedAnswerIds,
      lastEvaluation: clearLastEvaluation
          ? const StudyHarmonyEvaluationResult.idle()
          : lastEvaluation ?? this.lastEvaluation,
      progressPoints: progressPoints ?? this.progressPoints,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      attempts: attempts ?? this.attempts,
      currentCombo: currentCombo ?? this.currentCombo,
      bestCombo: bestCombo ?? this.bestCombo,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      elapsed: elapsed ?? this.elapsed,
      performance: performance ?? this.performance,
    );
  }
}
