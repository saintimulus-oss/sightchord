import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../audio/harmony_audio_service.dart';
import '../audio/harmony_audio_models.dart';
import '../audio/sampled_instrument_engine.dart';
import '../audio/sightchord_audio_scope.dart';
import '../l10n/app_localizations.dart';
import 'application/study_harmony_progress_controller.dart';
import 'application/study_harmony_session_controller.dart';
import 'domain/study_harmony_progress_models.dart';
import 'domain/study_harmony_session_models.dart';
import 'meta/study_harmony_arcade_catalog.dart';
import 'meta/study_harmony_arcade_runtime.dart';
import 'meta/study_harmony_difficulty_design.dart';
import 'meta/study_harmony_personalization.dart';
import 'meta/study_harmony_rewards_catalog.dart';
import 'study_harmony_keyboard.dart';
import 'study_harmony_models.dart';
import 'ui/study_harmony_progression_strip.dart';

typedef StudyHarmonySessionControllerFactory =
    StudyHarmonySessionController Function(StudyHarmonyLessonDefinition lesson);

class _SubmitOrAdvanceIntent extends Intent {
  const _SubmitOrAdvanceIntent();
}

class _RestartSessionIntent extends Intent {
  const _RestartSessionIntent();
}

class _SelectChoiceByIndexIntent extends Intent {
  const _SelectChoiceByIndexIntent(this.index);

  final int index;
}

class StudyHarmonySessionPage extends StatefulWidget {
  const StudyHarmonySessionPage({
    super.key,
    required this.lesson,
    required this.trackId,
    required this.progressController,
    this.courseToSync,
    this.controllerFactory,
  });

  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonyTrackId trackId;
  final StudyHarmonyProgressController progressController;
  final StudyHarmonyCourseDefinition? courseToSync;
  final StudyHarmonySessionControllerFactory? controllerFactory;

  @override
  State<StudyHarmonySessionPage> createState() =>
      _StudyHarmonySessionPageState();
}

class _StudyHarmonySessionPageState extends State<StudyHarmonySessionPage> {
  late StudyHarmonySessionController _controller;
  late final FocusNode _pageFocusNode;
  bool _hasPersistedCurrentRun = false;
  StudyHarmonySessionProgressEffect? _lastProgressEffect;
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;
  final Map<String, ActiveInstrumentNote> _activePreviewNotes =
      <String, ActiveInstrumentNote>{};

  @override
  void initState() {
    super.initState();
    _pageFocusNode = FocusNode(debugLabel: 'studyHarmonySessionPage');
    _syncCourseIfNeeded();
    _controller = _buildController();
    _controller.addListener(_handleSessionChanged);
    _markLessonStarted();
    _requestPageFocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requestedHarmonyAudioWarmUp) {
      return;
    }
    final harmonyAudio = SightChordAudioScope.maybeOf(context);
    _harmonyAudio = harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    _requestedHarmonyAudioWarmUp = true;
    unawaited(harmonyAudio.warmUp());
  }

  @override
  void didUpdateWidget(covariant StudyHarmonySessionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.id != widget.lesson.id) {
      final previousController = _controller;
      previousController.removeListener(_handleSessionChanged);
      _controller = _buildController();
      _controller.addListener(_handleSessionChanged);
      _hasPersistedCurrentRun = false;
      _lastProgressEffect = null;
      _markLessonStarted();
      _requestPageFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        previousController.dispose();
      });
    }

    if (oldWidget.progressController != widget.progressController ||
        oldWidget.courseToSync?.id != widget.courseToSync?.id) {
      _syncCourseIfNeeded();
    }

    if (oldWidget.progressController != widget.progressController ||
        oldWidget.trackId != widget.trackId ||
        oldWidget.lesson.id != widget.lesson.id) {
      _markLessonStarted();
    }
  }

  @override
  void dispose() {
    unawaited(_stopPreviewNotes());
    _controller.removeListener(_handleSessionChanged);
    _controller.dispose();
    _pageFocusNode.dispose();
    super.dispose();
  }

  StudyHarmonySessionController _buildController() {
    final lesson = _buildRuntimeLesson(widget.lesson);
    return widget.controllerFactory?.call(lesson) ??
        StudyHarmonySessionController(lesson: lesson);
  }

  void _syncCourseIfNeeded() {
    final course = widget.courseToSync;
    if (course == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(widget.progressController.syncCourse(course));
    });
  }

  StudyHarmonyLessonDefinition _buildRuntimeLesson(
    StudyHarmonyLessonDefinition lesson,
  ) {
    final localeTag = WidgetsBinding.instance.platformDispatcher.locale
        .toLanguageTag();
    final snapshot = widget.progressController.snapshot;
    final recentPerformance =
        StudyHarmonyRecentPerformance.fromProgressSnapshot(snapshot);
    final adaptiveProfile = _sessionAdaptiveProfile(
      snapshot: snapshot,
      localeTag: localeTag,
      recentPerformance: recentPerformance,
    );
    final difficultyPlan = StudyHarmonyDifficultyDesign.design(
      mode: lesson.sessionMode,
      input: _difficultyInputForSession(
        recentPerformance: recentPerformance,
        adaptiveProfile: adaptiveProfile,
        progressController: widget.progressController,
        liveComboPeak: 0,
      ),
    );
    final runtimeTuning = StudyHarmonyRuntimeTuningRules.tuneFromPlan(
      plan: difficultyPlan,
      baseStartingLives: lesson.startingLives,
      baseGoalCorrectAnswers: lesson.goalCorrectAnswers,
      taskCount: lesson.tasks.length,
    );

    var startingLives = runtimeTuning.recommendedStartingLives;
    var goalCorrectAnswers = runtimeTuning.recommendedGoalCorrectAnswers;
    var metadata = lesson.sessionMetadata;

    final shouldRewardCombo = runtimeTuning.bonusAggressiveness >= 0.7;
    final shouldShuffleChoices = runtimeTuning.remixIntensity >= 0.78;
    final shouldRepeatMisses =
        runtimeTuning.forgivenessTier.index >=
            StudyHarmonyForgivenessTier.kind.index ||
        difficultyPlan.difficultyLane == StudyHarmonyDifficultyLane.recovery;
    final comboProgressThreshold = shouldRewardCombo
        ? max(2, min(5, runtimeTuning.comboTarget))
        : metadata.comboProgressThreshold;
    final comboProgressBonus = shouldRewardCombo
        ? max(1, metadata.comboProgressBonus)
        : metadata.comboProgressBonus;
    final comboLifeThreshold = runtimeTuning.isForgiving
        ? max(4, min(8, runtimeTuning.comboTarget + 1))
        : metadata.comboLifeThreshold;
    final comboLifeBonus = runtimeTuning.isForgiving
        ? max(1, metadata.comboLifeBonus)
        : metadata.comboLifeBonus;
    metadata = metadata.copyWith(
      missProgressPenalty: runtimeTuning.isPressureHeavy
          ? max(metadata.missProgressPenalty, 1)
          : metadata.missProgressPenalty,
      comboProgressThreshold: comboProgressThreshold,
      comboProgressBonus: comboProgressBonus,
      comboLifeThreshold: comboLifeThreshold,
      comboLifeBonus: comboLifeBonus,
      shuffleChoiceOptions:
          metadata.shuffleChoiceOptions || shouldShuffleChoices,
      repeatMissedTask: metadata.repeatMissedTask || shouldRepeatMisses,
    );

    final arcadeModeId = metadata.arcadeModeId;
    if (arcadeModeId != null) {
      final arcadeRuntime =
          buildStudyHarmonyArcadeRuntimePlanFromLessonSummaries(
            snapshot.lessonResults.values,
            modeId: arcadeModeId,
            baseStartingLives: startingLives,
            baseGoalCorrectAnswers: goalCorrectAnswers,
            totalLessons: max(
              snapshot.unlockedLessonIds.length,
              snapshot.lessonResults.length,
            ),
            reviewQueueSize: snapshot.reviewQueuePlaceholders.length,
            chapterClears: snapshot.unlockedChapterIds.length,
            bossClears: _modeCountFromSnapshot(
              snapshot.modeClearCounts,
              StudyHarmonySessionMode.bossRush,
            ),
            currentStreak: snapshot.bestDailyChallengeStreak,
          );
      final arcadeComboLifeThreshold =
          arcadeRuntime.comboBonusAmount >= 2 || runtimeTuning.isForgiving
          ? max(4, min(7, arcadeRuntime.comboBonusEvery + 2))
          : metadata.comboLifeThreshold;
      final arcadeComboLifeBonus = arcadeRuntime.comboBonusAmount >= 3
          ? 1
          : metadata.comboLifeBonus;
      startingLives = arcadeRuntime.startingLives;
      goalCorrectAnswers = arcadeRuntime.goalCorrectAnswers;
      metadata = metadata.copyWith(
        missLifePenalty: max(
          metadata.missLifePenalty,
          arcadeRuntime.missPenaltyLives,
        ),
        missProgressPenalty:
            arcadeRuntime.usesGhostPressure ||
                arcadeRuntime.modeId == 'boss-rush' ||
                arcadeRuntime.modeId == 'crown-loop' ||
                arcadeRuntime.modeId == 'duel-stage'
            ? max(metadata.missProgressPenalty, 1)
            : metadata.missProgressPenalty,
        comboProgressThreshold: arcadeRuntime.comboBonusAmount > 0
            ? arcadeRuntime.comboBonusEvery
            : metadata.comboProgressThreshold,
        comboProgressBonus: arcadeRuntime.comboBonusAmount > 0
            ? max(
                metadata.comboProgressBonus,
                min(2, arcadeRuntime.comboBonusAmount),
              )
            : metadata.comboProgressBonus,
        comboLifeThreshold: arcadeComboLifeThreshold,
        comboLifeBonus: max(metadata.comboLifeBonus, arcadeComboLifeBonus),
        comboDropOnMiss: arcadeRuntime.comboResetsOnMiss
            ? 0
            : max(1, arcadeRuntime.comboDropOnMiss),
        comboResetsOnMiss: arcadeRuntime.comboResetsOnMiss,
        shuffleChoiceOptions:
            metadata.shuffleChoiceOptions || arcadeRuntime.usesModifierStorm,
        repeatMissedTask:
            metadata.repeatMissedTask ||
            arcadeRuntime.usesGhostPressure ||
            runtimeTuning.isForgiving,
        uniqueTaskCycle:
            metadata.uniqueTaskCycle ||
            arcadeRuntime.modifierPool.isNotEmpty ||
            arcadeRuntime.mechanics.isNotEmpty,
      );
    }

    final tunedLives = startingLives.clamp(1, 6).toInt();
    final minimumGoal = lesson.sessionMode == StudyHarmonySessionMode.lesson
        ? (lesson.tasks.length == 1
              ? lesson.goalCorrectAnswers
              : min(lesson.goalCorrectAnswers, 2))
        : 1;
    final tunedGoal = goalCorrectAnswers
        .clamp(
          minimumGoal,
          max(max(lesson.goalCorrectAnswers + 4, lesson.tasks.length), 3),
        )
        .toInt();
    if (tunedLives == lesson.startingLives &&
        tunedGoal == lesson.goalCorrectAnswers &&
        metadata == lesson.sessionMetadata) {
      return lesson;
    }
    return StudyHarmonyLessonDefinition(
      id: lesson.id,
      chapterId: lesson.chapterId,
      title: lesson.title,
      description: lesson.description,
      objectiveLabel: lesson.objectiveLabel,
      goalCorrectAnswers: tunedGoal,
      startingLives: tunedLives,
      sessionMode: lesson.sessionMode,
      tasks: lesson.tasks,
      skillTags: lesson.skillTags,
      sessionMetadata: metadata,
    );
  }

  void _toggleAnswer(StudyHarmonyAnswerOptionId answerId) {
    _controller.toggleAnswer(answerId);
  }

  Future<void> _playPromptPreview({
    required HarmonyPlaybackPattern pattern,
  }) async {
    final task = _controller.state.currentTask;
    final harmonyAudio = _harmonyAudio;
    if (task == null || harmonyAudio == null) {
      return;
    }
    await harmonyAudio.playStudyPrompt(task, pattern: pattern);
  }

  Future<void> _previewKeyDown(StudyHarmonyAnswerOptionId answerId) async {
    if (_activePreviewNotes.containsKey(answerId)) {
      return;
    }
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    final clip = harmonyAudio.noteClipForStudyAnswerId(answerId);
    if (clip.notes.isEmpty) {
      return;
    }
    final previewNote = clip.notes.first;
    final active = await harmonyAudio.noteOn(
      midiNote: previewNote.midiNote,
      velocity: previewNote.velocity,
      gain: previewNote.gain,
    );
    if (active == null) {
      return;
    }
    if (!mounted) {
      await harmonyAudio.noteOff(active);
      return;
    }
    _activePreviewNotes[answerId] = active;
  }

  Future<void> _previewKeyUp(StudyHarmonyAnswerOptionId answerId) async {
    final active = _activePreviewNotes.remove(answerId);
    final harmonyAudio = _harmonyAudio;
    if (active == null || harmonyAudio == null) {
      return;
    }
    await harmonyAudio.noteOff(active);
  }

  Future<void> _stopPreviewNotes() async {
    final activeNotes = _activePreviewNotes.values.toList(growable: false);
    _activePreviewNotes.clear();
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    for (final note in activeNotes) {
      await harmonyAudio.noteOff(note);
    }
  }

  void _submit() {
    _controller.submit();
  }

  void _handlePrimaryAction() {
    final state = _controller.state;
    if (state.isFinished) {
      return;
    }
    if (state.phase == StudyHarmonySessionPhase.submittedCorrect ||
        state.phase == StudyHarmonySessionPhase.submittedIncorrect) {
      _controller.advanceAfterFeedback();
      return;
    }
    _submit();
  }

  void _restart() {
    _hasPersistedCurrentRun = false;
    setState(() {
      _lastProgressEffect = null;
    });
    _controller.restart();
    _requestPageFocus();
  }

  void _selectChoiceByIndex(int index) {
    final state = _controller.state;
    if (state.phase == StudyHarmonySessionPhase.submittedCorrect ||
        state.phase == StudyHarmonySessionPhase.submittedIncorrect) {
      return;
    }

    final task = state.currentTask;
    if (task == null ||
        task.answerSurface != StudyHarmonyAnswerSurfaceKind.choiceChips ||
        index < 0 ||
        index >= task.choiceOptions.length) {
      return;
    }
    _toggleAnswer(task.choiceOptions[index].id);
  }

  void _requestPageFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _pageFocusNode.requestFocus();
    });
  }

  void _markLessonStarted() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        widget.progressController.markSessionStarted(
          trackId: widget.trackId,
          lesson: widget.lesson,
        ),
      );
    });
  }

  void _handleSessionChanged() {
    final state = _controller.state;
    if (!state.isFinished) {
      _hasPersistedCurrentRun = false;
      return;
    }
    if (_hasPersistedCurrentRun) {
      return;
    }

    _hasPersistedCurrentRun = true;
    unawaited(_persistFinishedSession(state));
  }

  Future<void> _persistFinishedSession(StudyHarmonySessionState state) async {
    final effect = await widget.progressController.recordSessionResult(
      trackId: widget.trackId,
      chapterId: state.lesson.chapterId,
      lesson: state.lesson,
      cleared: state.isCompleted,
      attempts: state.attempts,
      accuracy: state.accuracy,
      elapsed: state.elapsed,
      bestCombo: state.bestCombo,
      correctAnswers: state.correctAnswers,
      livesRemaining: state.livesRemaining,
      performance: state.performance,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _lastProgressEffect = effect;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final lesson = state.lesson;
        final task = state.currentTask;
        final showFeedback =
            state.lastEvaluation.status != StudyHarmonyEvaluationStatus.idle;
        final sessionStars =
            _lastProgressEffect?.sessionStars ??
            _sessionStarsForResult(
              cleared: state.isCompleted,
              accuracy: state.accuracy,
            );
        final sessionRank =
            _lastProgressEffect?.sessionRank ??
            _sessionRankForResult(
              cleared: state.isCompleted,
              accuracy: state.accuracy,
            );
        final primaryActionLabel =
            state.phase == StudyHarmonySessionPhase.submittedCorrect ||
                state.phase == StudyHarmonySessionPhase.submittedIncorrect
            ? l10n.studyHarmonyNextPrompt
            : l10n.studyHarmonySubmit;
        final bonusGoals = _sessionBonusGoals(
          l10n: l10n,
          lesson: lesson,
          state: state,
        );
        final localeTag = Localizations.localeOf(context).toLanguageTag();
        final recentPerformance =
            StudyHarmonyRecentPerformance.fromProgressSnapshot(
              widget.progressController.snapshot,
            );
        final adaptiveProfile = _sessionAdaptiveProfile(
          snapshot: widget.progressController.snapshot,
          localeTag: localeTag,
          recentPerformance: recentPerformance,
        );
        final adaptivePlan = personalizeStudyHarmony(
          profile: adaptiveProfile,
          recentPerformance: recentPerformance,
        );
        final difficultyPlan = StudyHarmonyDifficultyDesign.design(
          mode: lesson.sessionMode,
          input: _difficultyInputForSession(
            recentPerformance: recentPerformance,
            adaptiveProfile: adaptiveProfile,
            progressController: widget.progressController,
            liveComboPeak: state.bestCombo,
          ),
        );
        final arcadeMode = lesson.sessionMetadata.arcadeModeId == null
            ? null
            : studyHarmonyArcadeModeById(lesson.sessionMetadata.arcadeModeId!);
        final completedBonusGoalLabels = [
          for (final goal in bonusGoals)
            if (goal.completed) goal.label,
        ];
        final unlockedMilestoneLabels = [
          for (final milestoneId
              in (_lastProgressEffect?.newlyUnlockedMilestoneIds ??
                  const <String>[]))
            _milestoneUnlockedLabel(l10n, milestoneId),
        ].whereType<String>().toList(growable: false);
        final bonusSweep =
            bonusGoals.isNotEmpty &&
            completedBonusGoalLabels.length == bonusGoals.length;

        return Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): _SubmitOrAdvanceIntent(),
            SingleActivator(LogicalKeyboardKey.numpadEnter):
                _SubmitOrAdvanceIntent(),
            SingleActivator(LogicalKeyboardKey.keyR): _RestartSessionIntent(),
            SingleActivator(LogicalKeyboardKey.digit1):
                _SelectChoiceByIndexIntent(0),
            SingleActivator(LogicalKeyboardKey.digit2):
                _SelectChoiceByIndexIntent(1),
            SingleActivator(LogicalKeyboardKey.digit3):
                _SelectChoiceByIndexIntent(2),
            SingleActivator(LogicalKeyboardKey.digit4):
                _SelectChoiceByIndexIntent(3),
            SingleActivator(LogicalKeyboardKey.digit5):
                _SelectChoiceByIndexIntent(4),
            SingleActivator(LogicalKeyboardKey.digit6):
                _SelectChoiceByIndexIntent(5),
            SingleActivator(LogicalKeyboardKey.digit7):
                _SelectChoiceByIndexIntent(6),
            SingleActivator(LogicalKeyboardKey.digit8):
                _SelectChoiceByIndexIntent(7),
            SingleActivator(LogicalKeyboardKey.digit9):
                _SelectChoiceByIndexIntent(8),
          },
          child: Actions(
            actions: <Type, Action<Intent>>{
              _SubmitOrAdvanceIntent: CallbackAction<_SubmitOrAdvanceIntent>(
                onInvoke: (_) {
                  _handlePrimaryAction();
                  return null;
                },
              ),
              _RestartSessionIntent: CallbackAction<_RestartSessionIntent>(
                onInvoke: (_) {
                  _restart();
                  return null;
                },
              ),
              _SelectChoiceByIndexIntent:
                  CallbackAction<_SelectChoiceByIndexIntent>(
                    onInvoke: (intent) {
                      _selectChoiceByIndex(intent.index);
                      return null;
                    },
                  ),
            },
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Focus(
                autofocus: true,
                focusNode: _pageFocusNode,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(lesson.title),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Semantics(
                          label: l10n.studyHarmonyLivesRemaining(
                            state.livesRemaining,
                            lesson.startingLives,
                          ),
                          child: ExcludeSemantics(
                            child: Row(
                              key: const ValueKey('study-harmony-lives'),
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(lesson.startingLives, (
                                index,
                              ) {
                                final isAlive = index < state.livesRemaining;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    isAlive
                                        ? Icons.favorite_rounded
                                        : Icons.heart_broken_rounded,
                                    key: ValueKey(
                                      'study-harmony-life-${index + 1}',
                                    ),
                                    color: isAlive
                                        ? const Color(0xFFE44B68)
                                        : colorScheme.outline,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colorScheme.primaryContainer.withValues(
                                alpha: 0.32,
                              ),
                              theme.scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: task == null
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 1040,
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final isWide =
                                              constraints.maxWidth >= 880;
                                          final answerCard = Card(
                                            elevation: 0,
                                            color: colorScheme.surface
                                                .withValues(alpha: 0.94),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: _buildAnswerSurface(
                                                task,
                                                state,
                                              ),
                                            ),
                                          );
                                          final feedbackBanner = showFeedback
                                              ? _FeedbackBanner(
                                                  evaluation:
                                                      state.lastEvaluation,
                                                  correctLabel: l10n
                                                      .studyHarmonyCorrectLabel,
                                                  incorrectLabel: l10n
                                                      .studyHarmonyIncorrectLabel,
                                                  selectionLabel: l10n
                                                      .studyHarmonyNeedSelection,
                                                  correctMessage: (answer) => l10n
                                                      .studyHarmonyCorrectFeedback(
                                                        answer,
                                                      ),
                                                  incorrectMessage: (answer) =>
                                                      l10n.studyHarmonyIncorrectFeedback(
                                                        answer,
                                                      ),
                                                )
                                              : null;
                                          final selectionPanel = _SelectionPanel(
                                            selectedLabels: task
                                                .displayLabelsForAnswerIds(
                                                  state.selectedAnswerIds,
                                                ),
                                            emptyLabel:
                                                l10n.studyHarmonySelectionEmpty,
                                            selectionLabel: l10n
                                                .studyHarmonySelectedAnswers,
                                            submitLabel: primaryActionLabel,
                                            shortcutHint:
                                                l10n.studyHarmonyShortcutHint,
                                            enabled: !state.isFinished,
                                            onSubmit: _handlePrimaryAction,
                                          );

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              _SessionBriefingCard(
                                                arcadeMode: arcadeMode,
                                                adaptivePlan: adaptivePlan,
                                                difficultyPlan: difficultyPlan,
                                                modeLabel: _sessionModeLabel(
                                                  l10n,
                                                  lesson.sessionMode,
                                                ),
                                                runtimeRuleLabels:
                                                    _runtimeRuleLabels(
                                                      localeTag,
                                                      lesson.sessionMetadata,
                                                    ),
                                              ),
                                              const SizedBox(height: 14),
                                              _SessionOverviewCard(
                                                lesson: lesson,
                                                modeLabel: _sessionModeLabel(
                                                  l10n,
                                                  lesson.sessionMode,
                                                ),
                                                progressLabel: l10n
                                                    .studyHarmonyClearProgress(
                                                      state.progressPoints,
                                                      lesson.goalCorrectAnswers,
                                                    ),
                                                attemptsLabel:
                                                    '${l10n.studyHarmonyAttempts} ${state.attempts}',
                                                accuracyLabel:
                                                    '${l10n.studyHarmonyAccuracy} ${_formatAccuracy(state.accuracy)}',
                                                elapsedLabel:
                                                    '${l10n.studyHarmonyElapsedTime} ${_formatDuration(state.elapsed)}',
                                                comboLabel: l10n
                                                    .studyHarmonyComboLabel(
                                                      state.currentCombo,
                                                    ),
                                                bestComboLabel: l10n
                                                    .studyHarmonyBestComboLabel(
                                                      state.bestCombo,
                                                    ),
                                                objectiveLabel:
                                                    l10n.studyHarmonyObjective,
                                                bonusTitle: l10n
                                                    .studyHarmonyBonusGoalsTitle,
                                                bonusGoals: bonusGoals,
                                              ),
                                              const SizedBox(height: 20),
                                              if (isWide)
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          _PromptCard(
                                                            task: task,
                                                            instructionLabel: l10n
                                                                .studyHarmonyPromptInstruction,
                                                            playLabel: l10n
                                                                .audioPlayPrompt,
                                                            arpeggioLabel: l10n
                                                                .audioPlayArpeggio,
                                                            onPlayPreview:
                                                                task
                                                                        .prompt
                                                                        .showsPianoPreview ||
                                                                    task
                                                                        .prompt
                                                                        .showsProgressionPreview
                                                                ? () => _playPromptPreview(
                                                                    pattern:
                                                                        HarmonyPlaybackPattern
                                                                            .block,
                                                                  )
                                                                : null,
                                                            onPlayArpeggio:
                                                                task
                                                                        .prompt
                                                                        .showsPianoPreview ||
                                                                    task
                                                                        .prompt
                                                                        .showsProgressionPreview
                                                                ? () => _playPromptPreview(
                                                                    pattern:
                                                                        HarmonyPlaybackPattern
                                                                            .arpeggio,
                                                                  )
                                                                : null,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          if (feedbackBanner !=
                                                              null) ...[
                                                            feedbackBanner,
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                          ],
                                                          answerCard,
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          selectionPanel,
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              else ...[
                                                _PromptCard(
                                                  task: task,
                                                  instructionLabel: l10n
                                                      .studyHarmonyPromptInstruction,
                                                  playLabel:
                                                      l10n.audioPlayPrompt,
                                                  arpeggioLabel:
                                                      l10n.audioPlayArpeggio,
                                                  onPlayPreview:
                                                      task
                                                              .prompt
                                                              .showsPianoPreview ||
                                                          task
                                                              .prompt
                                                              .showsProgressionPreview
                                                      ? () => _playPromptPreview(
                                                          pattern:
                                                              HarmonyPlaybackPattern
                                                                  .block,
                                                        )
                                                      : null,
                                                  onPlayArpeggio:
                                                      task
                                                              .prompt
                                                              .showsPianoPreview ||
                                                          task
                                                              .prompt
                                                              .showsProgressionPreview
                                                      ? () => _playPromptPreview(
                                                          pattern:
                                                              HarmonyPlaybackPattern
                                                                  .arpeggio,
                                                        )
                                                      : null,
                                                ),
                                                const SizedBox(height: 16),
                                                if (feedbackBanner != null) ...[
                                                  feedbackBanner,
                                                  const SizedBox(height: 16),
                                                ],
                                                answerCard,
                                                const SizedBox(height: 16),
                                                selectionPanel,
                                              ],
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      if (state.isFinished)
                        Positioned.fill(
                          child: ColoredBox(
                            color: Colors.black.withValues(alpha: 0.28),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 420,
                                  ),
                                  child: _ResultOverlay(
                                    title: state.isCompleted
                                        ? l10n.studyHarmonyLevelCompleteTitle
                                        : l10n.studyHarmonyGameOverTitle,
                                    body: state.isCompleted
                                        ? l10n.studyHarmonyLevelCompleteBody
                                        : l10n.studyHarmonyGameOverBody,
                                    progressLabel: l10n
                                        .studyHarmonyClearProgress(
                                          state.progressPoints,
                                          lesson.goalCorrectAnswers,
                                        ),
                                    accuracyLabel:
                                        '${l10n.studyHarmonyAccuracy} ${_formatAccuracy(state.accuracy)}',
                                    elapsedLabel:
                                        '${l10n.studyHarmonyElapsedTime} ${_formatDuration(state.elapsed)}',
                                    attemptsLabel:
                                        '${l10n.studyHarmonyAttempts} ${state.attempts}',
                                    modeLabel: _sessionModeLabel(
                                      l10n,
                                      lesson.sessionMode,
                                    ),
                                    reviewReasonLabel: _reviewReasonLabel(
                                      l10n,
                                      _lastProgressEffect?.reviewReason,
                                    ),
                                    dailyDateLabel:
                                        _lastProgressEffect?.dailyDateKey ==
                                            null
                                        ? null
                                        : l10n.studyHarmonyDailyDateBadge(
                                            _lastProgressEffect!.dailyDateKey!,
                                          ),
                                    skillGainTitle:
                                        l10n.studyHarmonyResultSkillGainTitle,
                                    reviewFocusTitle:
                                        l10n.studyHarmonyResultReviewFocusTitle,
                                    rewardTitle:
                                        l10n.studyHarmonyResultRewardTitle,
                                    arcadeTitle: _sessionArcadeTitle(localeTag),
                                    directorTitle: _sessionDirectorTitle(
                                      localeTag,
                                    ),
                                    milestoneTitle:
                                        l10n.studyHarmonyResultMilestonesTitle,
                                    bonusTitle:
                                        l10n.studyHarmonyBonusGoalsTitle,
                                    rewardHighlightLabel:
                                        _lastProgressEffect
                                                ?.personalBestImproved ==
                                            true
                                        ? l10n.studyHarmonyResultNewBestTag
                                        : null,
                                    rewardLabels: [
                                      l10n.studyHarmonyResultRankLine(
                                        sessionRank,
                                      ),
                                      l10n.studyHarmonyResultStarsLine(
                                        sessionStars,
                                      ),
                                      if (_lastProgressEffect
                                                  ?.countsTowardLessonProgress ==
                                              true &&
                                          _lastProgressEffect?.bestRank !=
                                              null &&
                                          _lastProgressEffect?.bestStars !=
                                              null)
                                        l10n.studyHarmonyResultBestLine(
                                          _lastProgressEffect!.bestRank!,
                                          _lastProgressEffect!.bestStars!,
                                        ),
                                      if (_lastProgressEffect
                                                  ?.dailyChallengeCompleted ==
                                              true &&
                                          _lastProgressEffect
                                                  ?.dailyStreakCount !=
                                              null)
                                        l10n.studyHarmonyResultDailyStreakLine(
                                          _lastProgressEffect!
                                              .dailyStreakCount!,
                                        ),
                                      if (_lastProgressEffect
                                              ?.streakSaverUsed ==
                                          true)
                                        l10n.studyHarmonyResultStreakSaverUsedLine,
                                      if (_lastProgressEffect
                                              ?.weeklyRewardUnlocked ==
                                          true)
                                        l10n.studyHarmonyResultStreakSaverEarnedLine(
                                          _lastProgressEffect!.streakSaverCount,
                                        ),
                                      if (_lastProgressEffect
                                              ?.dailyQuestChestOpened ==
                                          true)
                                        l10n.studyHarmonyResultQuestChestLine,
                                      if ((_lastProgressEffect
                                                  ?.questChestLeagueXpBonus ??
                                              0) >
                                          0)
                                        l10n.studyHarmonyResultQuestChestXpLine(
                                          _lastProgressEffect!
                                              .questChestLeagueXpBonus,
                                        ),
                                      if (_lastProgressEffect
                                              ?.monthlyTourRewardUnlocked ==
                                          true)
                                        l10n.studyHarmonyResultTourCompleteLine,
                                      if ((_lastProgressEffect
                                                  ?.monthlyTourLeagueXpBonus ??
                                              0) >
                                          0)
                                        l10n.studyHarmonyResultTourXpLine(
                                          _lastProgressEffect!
                                              .monthlyTourLeagueXpBonus,
                                        ),
                                      if (_lastProgressEffect
                                              ?.monthlyTourRewardUnlocked ==
                                          true)
                                        l10n.studyHarmonyResultTourStreakSaverLine(
                                          _lastProgressEffect!
                                              .monthlyTourStreakSaverCount,
                                        ),
                                      if ((_lastProgressEffect
                                                  ?.duetPactCurrentStreak ??
                                              0) >
                                          0)
                                        l10n.studyHarmonyResultDuetLine(
                                          _lastProgressEffect!
                                              .duetPactCurrentStreak,
                                        ),
                                      if (_lastProgressEffect
                                              ?.duetPactRewardUnlocked ==
                                          true)
                                        l10n.studyHarmonyResultDuetRewardLine(
                                          _lastProgressEffect!
                                              .duetPactLeagueXpBonus,
                                        ),
                                      if (_lastProgressEffect
                                              ?.leagueXpBoostUnlocked ==
                                          true)
                                        l10n.studyHarmonyResultLeagueBoostReadyLine(
                                          _lastProgressEffect!
                                              .leagueXpBoostChargeCount,
                                        ),
                                      if ((_lastProgressEffect
                                                  ?.leagueXpBoostAppliedBonus ??
                                              0) >
                                          0)
                                        l10n.studyHarmonyResultLeagueBoostAppliedLine(
                                          _lastProgressEffect!
                                              .leagueXpBoostAppliedBonus,
                                        ),
                                      if ((_lastProgressEffect
                                                      ?.leagueXpBoostAppliedBonus ??
                                                  0) >
                                              0 &&
                                          (_lastProgressEffect
                                                      ?.leagueXpBoostChargeCount ??
                                                  0) >
                                              0)
                                        l10n.studyHarmonyResultLeagueBoostRemainingLine(
                                          _lastProgressEffect!
                                              .leagueXpBoostChargeCount,
                                        ),
                                      if (_lastProgressEffect
                                              ?.focusSprintCompleted ==
                                          true)
                                        l10n.studyHarmonyResultFocusSprintLine,
                                      if (_lastProgressEffect
                                              ?.weeklyLeagueScoreDelta !=
                                          0)
                                        l10n.studyHarmonyResultLeagueXpLine(
                                          _lastProgressEffect!
                                              .weeklyLeagueScoreDelta,
                                        ),
                                      if (_lastProgressEffect
                                              ?.promotedLeagueTier
                                          case final promotedTier?)
                                        l10n.studyHarmonyResultLeaguePromotionLine(
                                          _leagueTierLabel(l10n, promotedTier),
                                        ),
                                      if (lesson.sessionMode ==
                                              StudyHarmonySessionMode.relay &&
                                          state.isCompleted &&
                                          (_lastProgressEffect?.relayWinCount ??
                                                  0) >
                                              0)
                                        l10n.studyHarmonyResultRelayLine(
                                          _lastProgressEffect!.relayWinCount!,
                                        ),
                                      if (lesson.sessionMode ==
                                              StudyHarmonySessionMode.legend &&
                                          state.isCompleted)
                                        _legendRewardLine(
                                          l10n,
                                          widget.courseToSync,
                                          lesson,
                                        ),
                                      if (lesson.sessionMode ==
                                              StudyHarmonySessionMode
                                                  .bossRush &&
                                          state.isCompleted)
                                        l10n.studyHarmonyResultBossRushLine,
                                      for (final bundle
                                          in (_lastProgressEffect
                                                  ?.rewardBundles ??
                                              const <
                                                StudyHarmonyRewardBundleDefinition
                                              >[]))
                                        _rewardBundleLabel(bundle),
                                      for (final grant
                                          in (_lastProgressEffect
                                                  ?.currencyGrants ??
                                              const <
                                                StudyHarmonyRewardGrant
                                              >[]))
                                        _currencyGrantLabel(grant),
                                      for (final reward
                                          in (_lastProgressEffect
                                                  ?.newlyUnlockedRewards ??
                                              const <
                                                StudyHarmonyRewardCandidate
                                              >[]))
                                        _rewardUnlockLabel(localeTag, reward),
                                      for (final entry
                                          in (_lastProgressEffect
                                                      ?.currencyBalances
                                                      .entries
                                                      .toList(
                                                        growable: false,
                                                      ) ??
                                                  const <
                                                    MapEntry<
                                                      StudyHarmonyCurrencyId,
                                                      int
                                                    >
                                                  >[])
                                              .take(3))
                                        _currencyBalanceLabel(
                                          entry.key,
                                          entry.value,
                                        ),
                                    ],
                                    arcadeLabels: [
                                      if (arcadeMode != null) arcadeMode.title,
                                      if (arcadeMode != null)
                                        _arcadeRiskLabel(
                                          localeTag,
                                          arcadeMode.riskStyle,
                                        ),
                                      if (arcadeMode != null)
                                        _arcadeRewardStyleLabel(
                                          localeTag,
                                          arcadeMode.rewardStyle,
                                        ),
                                      if (arcadeMode != null)
                                        arcadeMode.shortLoop,
                                      ..._runtimeRuleLabels(
                                        localeTag,
                                        lesson.sessionMetadata,
                                      ),
                                    ],
                                    directorLabels: [
                                      _difficultyLaneLabel(
                                        localeTag,
                                        difficultyPlan.difficultyLane,
                                      ),
                                      _pressureTierLabel(
                                        localeTag,
                                        difficultyPlan.pressureTier,
                                      ),
                                      _forgivenessTierLabel(
                                        localeTag,
                                        difficultyPlan.forgivenessTier,
                                      ),
                                      _sessionLengthLabel(
                                        localeTag,
                                        difficultyPlan
                                            .sessionLengthSuggestion
                                            .inMinutes,
                                      ),
                                      _comboGoalLabel(
                                        localeTag,
                                        difficultyPlan.comboTarget,
                                      ),
                                      _pacingPlanLabel(
                                        localeTag,
                                        difficultyPlan,
                                      ),
                                      _coachLabel(
                                        localeTag,
                                        adaptivePlan.coachStyle,
                                      ),
                                    ],
                                    milestoneLabels: unlockedMilestoneLabels,
                                    bonusHighlightLabel: bonusSweep
                                        ? l10n.studyHarmonyBonusSweepTag
                                        : null,
                                    bonusLabels: completedBonusGoalLabels,
                                    skillGainLabels: [
                                      for (final gain
                                          in (_lastProgressEffect?.skillGains ??
                                              const <
                                                StudyHarmonySkillGainSummary
                                              >[]))
                                        l10n.studyHarmonyResultSkillGainLine(
                                          _skillLabel(l10n, gain.skillId),
                                          _formatSignedPercent(gain.delta),
                                        ),
                                    ],
                                    focusSkillLabels: [
                                      for (final skillId
                                          in (_lastProgressEffect
                                                  ?.focusSkillTags ??
                                              const <StudyHarmonySkillTag>{}))
                                        _skillLabel(l10n, skillId),
                                    ],
                                    retryLabel: l10n.studyHarmonyRetry,
                                    backLabel: l10n.studyHarmonyBackToHub,
                                    onRetry: _restart,
                                    onBack: () =>
                                        Navigator.of(context).maybePop(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerSurface(
    StudyHarmonyTaskInstance task,
    StudyHarmonySessionState state,
  ) {
    final awaitingAdvance =
        state.phase == StudyHarmonySessionPhase.submittedCorrect ||
        state.phase == StudyHarmonySessionPhase.submittedIncorrect;

    return switch (task.answerSurface) {
      StudyHarmonyAnswerSurfaceKind.pianoKeyboard => StudyHarmonyPianoKeyboard(
        keys: _keyboardKeysForTask(task),
        selectedAnswerIds: state.selectedAnswerIds,
        onToggleKey: _toggleAnswer,
        onPreviewKeyDown: state.isFinished || awaitingAdvance
            ? null
            : _previewKeyDown,
        onPreviewKeyUp: state.isFinished || awaitingAdvance
            ? null
            : _previewKeyUp,
        readOnly: state.isFinished || awaitingAdvance,
      ),
      StudyHarmonyAnswerSurfaceKind.choiceChips => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var index = 0; index < task.choiceOptions.length; index += 1)
            Semantics(
              button: !state.isFinished && !awaitingAdvance,
              enabled: !state.isFinished && !awaitingAdvance,
              selected: state.selectedAnswerIds.contains(
                task.choiceOptions[index].id,
              ),
              label: '${index + 1}. ${task.choiceOptions[index].label}',
              child: FilterChip(
                key: ValueKey(
                  'study-harmony-choice-${task.choiceOptions[index].id}',
                ),
                label: Text(task.choiceOptions[index].label),
                selected: state.selectedAnswerIds.contains(
                  task.choiceOptions[index].id,
                ),
                onSelected: state.isFinished || awaitingAdvance
                    ? null
                    : (_) => _toggleAnswer(task.choiceOptions[index].id),
              ),
            ),
        ],
      ),
    };
  }
}

class _SessionBriefingCard extends StatelessWidget {
  const _SessionBriefingCard({
    required this.adaptivePlan,
    required this.difficultyPlan,
    required this.modeLabel,
    required this.runtimeRuleLabels,
    this.arcadeMode,
  });

  final StudyHarmonyArcadeModeDefinition? arcadeMode;
  final StudyHarmonyAdaptivePlan adaptivePlan;
  final StudyHarmonyDifficultyPlan difficultyPlan;
  final String modeLabel;
  final List<String> runtimeRuleLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    return DecoratedBox(
      key: const ValueKey('study-harmony-session-briefing'),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              arcadeMode?.title ?? modeLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              arcadeMode?.fantasy ?? _coachLine(localeTag, adaptivePlan),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    _difficultyLaneLabel(
                      localeTag,
                      difficultyPlan.difficultyLane,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    _pressureTierLabel(localeTag, difficultyPlan.pressureTier),
                  ),
                ),
                Chip(
                  label: Text(
                    _forgivenessTierLabel(
                      localeTag,
                      difficultyPlan.forgivenessTier,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    _comboGoalLabel(localeTag, difficultyPlan.comboTarget),
                  ),
                ),
                Chip(
                  label: Text(
                    _sessionLengthLabel(
                      localeTag,
                      difficultyPlan.sessionLengthSuggestion.inMinutes,
                    ),
                  ),
                ),
                Chip(
                  label: Text(_coachLabel(localeTag, adaptivePlan.coachStyle)),
                ),
                for (final label in runtimeRuleLabels.take(3))
                  Chip(label: Text(label)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionOverviewCard extends StatelessWidget {
  const _SessionOverviewCard({
    required this.lesson,
    required this.modeLabel,
    required this.progressLabel,
    required this.attemptsLabel,
    required this.accuracyLabel,
    required this.elapsedLabel,
    required this.comboLabel,
    required this.bestComboLabel,
    required this.objectiveLabel,
    required this.bonusTitle,
    this.bonusGoals = const <_SessionBonusGoal>[],
  });

  final StudyHarmonyLessonDefinition lesson;
  final String modeLabel;
  final String progressLabel;
  final String attemptsLabel;
  final String accuracyLabel;
  final String elapsedLabel;
  final String comboLabel;
  final String bestComboLabel;
  final String objectiveLabel;
  final String bonusTitle;
  final List<_SessionBonusGoal> bonusGoals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      child: Card(
        elevation: 0,
        color: colorScheme.surface.withValues(alpha: 0.94),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    key: const ValueKey('study-harmony-progress-chip'),
                    avatar: const Icon(Icons.flag_rounded, size: 18),
                    label: Text(progressLabel),
                  ),
                  Chip(
                    avatar: const Icon(Icons.favorite_rounded, size: 18),
                    label: Text(lesson.objectiveLabel),
                  ),
                  Chip(
                    avatar: const Icon(Icons.layers_rounded, size: 18),
                    label: Text(modeLabel),
                  ),
                  Chip(
                    avatar: const Icon(
                      Icons.local_fire_department_rounded,
                      size: 18,
                    ),
                    label: Text(comboLabel),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                lesson.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatChip(label: attemptsLabel),
                  _StatChip(label: accuracyLabel),
                  _StatChip(label: elapsedLabel),
                  _StatChip(label: bestComboLabel),
                  _StatChip(
                    label: '$objectiveLabel ${lesson.goalCorrectAnswers}',
                  ),
                ],
              ),
              if (bonusGoals.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  bonusTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final goal in bonusGoals)
                      Chip(
                        key: ValueKey('study-harmony-bonus-goal-${goal.id}'),
                        avatar: Icon(
                          goal.completed
                              ? Icons.check_circle_rounded
                              : Icons.flag_rounded,
                          size: 18,
                        ),
                        label: Text(goal.label),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({
    required this.task,
    required this.instructionLabel,
    required this.playLabel,
    required this.arpeggioLabel,
    this.onPlayPreview,
    this.onPlayArpeggio,
  });

  final StudyHarmonyTaskInstance task;
  final String instructionLabel;
  final String playLabel;
  final String arpeggioLabel;
  final VoidCallback? onPlayPreview;
  final VoidCallback? onPlayArpeggio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      child: Card(
        key: const ValueKey('study-harmony-prompt-card'),
        elevation: 0,
        color: colorScheme.surface.withValues(alpha: 0.94),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                instructionLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 0.2,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onPlayPreview != null || onPlayArpeggio != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (onPlayPreview != null)
                      OutlinedButton.icon(
                        key: const ValueKey('study-harmony-play-prompt-button'),
                        onPressed: onPlayPreview,
                        icon: const Icon(Icons.music_note_rounded),
                        label: Text(playLabel),
                      ),
                    if (onPlayArpeggio != null)
                      OutlinedButton.icon(
                        key: const ValueKey(
                          'study-harmony-play-prompt-arpeggio-button',
                        ),
                        onPressed: onPlayArpeggio,
                        icon: const Icon(Icons.multitrack_audio_rounded),
                        label: Text(arpeggioLabel),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              if (task.prompt.showsPianoPreview) ...[
                StudyHarmonyPianoKeyboard(
                  keys: _keyboardKeysForTask(task),
                  selectedAnswerIds: task.prompt.highlightedAnswerIds,
                  readOnly: true,
                ),
                const SizedBox(height: 12),
              ],
              if (task.prompt.progressionDisplay case final progression?) ...[
                StudyHarmonyProgressionStrip(progression: progression),
                const SizedBox(height: 16),
              ],
              Text(
                task.prompt.primaryLabel,
                key: const ValueKey('study-harmony-current-prompt'),
                style:
                    (task.prompt.showsPianoPreview ||
                                task.prompt.showsProgressionPreview
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.displaySmall)
                        ?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (task.prompt.hint case final hint?) ...[
                const SizedBox(height: 10),
                Text(
                  hint,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionPanel extends StatelessWidget {
  const _SelectionPanel({
    required this.selectedLabels,
    required this.emptyLabel,
    required this.selectionLabel,
    required this.submitLabel,
    required this.shortcutHint,
    required this.enabled,
    required this.onSubmit,
  });

  final List<String> selectedLabels;
  final String emptyLabel;
  final String selectionLabel;
  final String submitLabel;
  final String shortcutHint;
  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      child: Card(
        elevation: 0,
        color: colorScheme.surface.withValues(alpha: 0.94),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectionLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              if (selectedLabels.isEmpty)
                Text(
                  emptyLabel,
                  key: const ValueKey('study-harmony-selection-empty'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedLabels
                      .map(
                        (label) => Chip(
                          key: ValueKey('study-harmony-selected-$label'),
                          label: Text(label),
                        ),
                      )
                      .toList(growable: false),
                ),
              const SizedBox(height: 14),
              Text(
                shortcutHint,
                key: const ValueKey('study-harmony-shortcut-hint'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Tooltip(
                  message: shortcutHint,
                  child: FilledButton.icon(
                    key: const ValueKey('study-harmony-submit-button'),
                    onPressed: enabled ? onSubmit : null,
                    icon: const Icon(Icons.task_alt_rounded),
                    label: Text(submitLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionBonusGoal {
  const _SessionBonusGoal({
    required this.id,
    required this.label,
    required this.completed,
  });

  final String id;
  final String label;
  final bool completed;
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({
    required this.evaluation,
    required this.correctLabel,
    required this.incorrectLabel,
    required this.selectionLabel,
    required this.correctMessage,
    required this.incorrectMessage,
  });

  final StudyHarmonyEvaluationResult evaluation;
  final String correctLabel;
  final String incorrectLabel;
  final String selectionLabel;
  final String Function(String answer) correctMessage;
  final String Function(String answer) incorrectMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final correctAnswer =
        evaluation.correctAnswerSummary ?? evaluation.answerLabel ?? '';
    final explanationDetail = _explanationDetail(evaluation, correctAnswer);

    final (
      title,
      body,
      icon,
      backgroundColor,
      foregroundColor,
    ) = switch (evaluation.status) {
      StudyHarmonyEvaluationStatus.needsSelection ||
      StudyHarmonyEvaluationStatus.invalidSelection => (
        selectionLabel,
        selectionLabel,
        Icons.touch_app_rounded,
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      StudyHarmonyEvaluationStatus.correct => (
        correctLabel,
        correctMessage(correctAnswer),
        Icons.check_circle_rounded,
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      StudyHarmonyEvaluationStatus.incorrect => (
        incorrectLabel,
        incorrectMessage(correctAnswer),
        Icons.cancel_rounded,
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
      StudyHarmonyEvaluationStatus.idle => (
        '',
        '',
        Icons.info_rounded,
        colorScheme.surface,
        colorScheme.onSurface,
      ),
    };

    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        key: const ValueKey('study-harmony-feedback-banner'),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: foregroundColor.withValues(alpha: 0.16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: foregroundColor,
                        height: 1.35,
                      ),
                    ),
                    if (explanationDetail != null &&
                        explanationDetail.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          explanationDetail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: foregroundColor.withValues(alpha: 0.9),
                            height: 1.35,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _explanationDetail(
    StudyHarmonyEvaluationResult evaluation,
    String correctAnswer,
  ) {
    final explanationBody = evaluation.explanationBody;
    if (explanationBody != null &&
        explanationBody.isNotEmpty &&
        explanationBody != correctAnswer) {
      return explanationBody;
    }

    final selectedAnswer = evaluation.selectedAnswerSummary;
    if (selectedAnswer != null &&
        selectedAnswer.isNotEmpty &&
        selectedAnswer != correctAnswer) {
      return selectedAnswer;
    }
    return null;
  }
}

class _ResultOverlay extends StatelessWidget {
  const _ResultOverlay({
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.accuracyLabel,
    required this.elapsedLabel,
    required this.attemptsLabel,
    required this.modeLabel,
    required this.skillGainTitle,
    required this.reviewFocusTitle,
    required this.rewardTitle,
    required this.arcadeTitle,
    required this.directorTitle,
    required this.milestoneTitle,
    required this.bonusTitle,
    required this.retryLabel,
    required this.backLabel,
    required this.onRetry,
    required this.onBack,
    this.reviewReasonLabel,
    this.dailyDateLabel,
    this.rewardHighlightLabel,
    this.bonusHighlightLabel,
    this.rewardLabels = const <String>[],
    this.arcadeLabels = const <String>[],
    this.directorLabels = const <String>[],
    this.milestoneLabels = const <String>[],
    this.bonusLabels = const <String>[],
    this.skillGainLabels = const <String>[],
    this.focusSkillLabels = const <String>[],
  });

  final String title;
  final String body;
  final String progressLabel;
  final String accuracyLabel;
  final String elapsedLabel;
  final String attemptsLabel;
  final String modeLabel;
  final String skillGainTitle;
  final String reviewFocusTitle;
  final String rewardTitle;
  final String arcadeTitle;
  final String directorTitle;
  final String milestoneTitle;
  final String bonusTitle;
  final String retryLabel;
  final String backLabel;
  final String? reviewReasonLabel;
  final String? dailyDateLabel;
  final String? rewardHighlightLabel;
  final String? bonusHighlightLabel;
  final List<String> rewardLabels;
  final List<String> arcadeLabels;
  final List<String> directorLabels;
  final List<String> milestoneLabels;
  final List<String> bonusLabels;
  final List<String> skillGainLabels;
  final List<String> focusSkillLabels;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      liveRegion: true,
      explicitChildNodes: true,
      child: Card(
        key: const ValueKey('study-harmony-result-overlay'),
        elevation: 6,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                _StatChip(label: progressLabel),
                const SizedBox(height: 8),
                _StatChip(label: accuracyLabel),
                const SizedBox(height: 8),
                _StatChip(label: elapsedLabel),
                const SizedBox(height: 8),
                _StatChip(label: attemptsLabel),
                const SizedBox(height: 8),
                _StatChip(label: modeLabel),
                if (dailyDateLabel case final String dailyLabel?) ...[
                  const SizedBox(height: 8),
                  _StatChip(label: dailyLabel),
                ],
                if (reviewReasonLabel case final String reviewReason?) ...[
                  const SizedBox(height: 8),
                  _StatChip(label: reviewReason),
                ],
                if (rewardLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    rewardTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (rewardHighlightLabel
                      case final String rewardHighlight?) ...[
                    const SizedBox(height: 10),
                    Chip(label: Text(rewardHighlight)),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in rewardLabels)
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (arcadeLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    arcadeTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in arcadeLabels.take(4))
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (directorLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    directorTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in directorLabels.take(4))
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (milestoneLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    milestoneTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in milestoneLabels)
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (bonusLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    bonusTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (bonusHighlightLabel case final String highlight?) ...[
                    const SizedBox(height: 10),
                    Chip(label: Text(highlight)),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in bonusLabels) Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (skillGainLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    skillGainTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in skillGainLabels.take(3))
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                if (focusSkillLabels.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    reviewFocusTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in focusSkillLabels.take(3))
                        Chip(label: Text(label)),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  key: const ValueKey('study-harmony-retry-button'),
                  onPressed: onRetry,
                  child: Text(retryLabel),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const ValueKey('study-harmony-back-button'),
                  onPressed: onBack,
                  child: Text(backLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Text(label),
      ),
    );
  }
}

List<StudyHarmonyPianoKeyDefinition> _keyboardKeysForTask(
  StudyHarmonyTaskInstance task,
) {
  return [
    for (final option in task.pianoOptions)
      StudyHarmonyPianoKeyDefinition(
        id: option.id,
        westernLabel: option.westernLabel,
        solfegeLabel: option.solfegeLabel,
        isBlack: option.isBlack,
        whiteIndex: option.whiteIndex,
        blackGapAfterWhiteIndex: option.blackGapAfterWhiteIndex,
      ),
  ];
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String _formatAccuracy(double accuracy) {
  if (accuracy.isNaN) {
    return '0%';
  }
  return '${(accuracy * 100).round()}%';
}

String _formatSignedPercent(double value) {
  final rounded = (value * 100).round();
  if (rounded > 0) {
    return '+$rounded%';
  }
  return '$rounded%';
}

List<_SessionBonusGoal> _sessionBonusGoals({
  required AppLocalizations l10n,
  required StudyHarmonyLessonDefinition lesson,
  required StudyHarmonySessionState state,
}) {
  final comboTarget = _comboTargetForLesson(lesson);
  final accuracyTarget = _accuracyBonusTarget(lesson);
  return <_SessionBonusGoal>[
    _SessionBonusGoal(
      id: 'full-hearts',
      label: l10n.studyHarmonyBonusFullHearts,
      completed:
          state.attempts > 0 && state.livesRemaining == lesson.startingLives,
    ),
    _SessionBonusGoal(
      id: 'accuracy',
      label: l10n.studyHarmonyBonusAccuracyTarget(
        (accuracyTarget * 100).round(),
      ),
      completed: state.attempts > 0 && state.accuracy >= accuracyTarget,
    ),
    _SessionBonusGoal(
      id: 'combo',
      label: l10n.studyHarmonyBonusComboTarget(comboTarget),
      completed: state.bestCombo >= comboTarget,
    ),
  ];
}

int _comboTargetForLesson(StudyHarmonyLessonDefinition lesson) {
  if (lesson.goalCorrectAnswers <= 2) {
    return lesson.goalCorrectAnswers;
  }
  if (lesson.goalCorrectAnswers >= 9) {
    return 4;
  }
  return 3;
}

double _accuracyBonusTarget(StudyHarmonyLessonDefinition lesson) {
  return switch (lesson.sessionMode) {
    StudyHarmonySessionMode.daily => 0.9,
    StudyHarmonySessionMode.review => 0.85,
    StudyHarmonySessionMode.focus => 0.92,
    StudyHarmonySessionMode.relay => 0.94,
    StudyHarmonySessionMode.bossRush => 0.93,
    StudyHarmonySessionMode.legend => 0.95,
    _ => lesson.goalCorrectAnswers >= 9 ? 0.9 : 0.85,
  };
}

String? _milestoneUnlockedLabel(AppLocalizations l10n, String milestoneId) {
  final parts = milestoneId.split('-');
  if (parts.length != 2) {
    return null;
  }
  final tier = int.tryParse(parts[1]) ?? 1;
  final title = switch (parts[0]) {
    'lessonPath' => l10n.studyHarmonyMilestoneLessonsTitle,
    'starCollector' => l10n.studyHarmonyMilestoneStarsTitle,
    'streakLegend' => l10n.studyHarmonyMilestoneStreakTitle,
    'masteryScholar' => l10n.studyHarmonyMilestoneMasteryTitle,
    'relayRunner' => l10n.studyHarmonyMilestoneRelayTitle,
    _ => null,
  };
  if (title == null) {
    return null;
  }
  return l10n.studyHarmonyMilestoneUnlockedLabel(
    title,
    _milestoneTierLabel(l10n, tier),
  );
}

String _milestoneTierLabel(AppLocalizations l10n, int tier) {
  return switch (tier) {
    1 => l10n.studyHarmonyMilestoneTierBronze,
    2 => l10n.studyHarmonyMilestoneTierSilver,
    3 => l10n.studyHarmonyMilestoneTierGold,
    _ => l10n.studyHarmonyMilestoneTierPlatinum,
  };
}

int _sessionStarsForResult({required bool cleared, required double accuracy}) {
  if (!cleared) {
    return 0;
  }
  if (accuracy >= 0.95) {
    return 3;
  }
  if (accuracy >= 0.8) {
    return 2;
  }
  return 1;
}

String _sessionRankForResult({
  required bool cleared,
  required double accuracy,
}) {
  if (!cleared) {
    return 'C';
  }
  if (accuracy >= 0.95) {
    return 'S';
  }
  if (accuracy >= 0.85) {
    return 'A';
  }
  if (accuracy >= 0.7) {
    return 'B';
  }
  return 'C';
}

String _sessionModeLabel(AppLocalizations l10n, StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.lesson => l10n.studyHarmonyModeLesson,
    StudyHarmonySessionMode.review => l10n.studyHarmonyModeReview,
    StudyHarmonySessionMode.daily => l10n.studyHarmonyModeDaily,
    StudyHarmonySessionMode.focus => l10n.studyHarmonyModeFocus,
    StudyHarmonySessionMode.relay => l10n.studyHarmonyModeRelay,
    StudyHarmonySessionMode.bossRush => l10n.studyHarmonyModeBossRush,
    StudyHarmonySessionMode.legend => l10n.studyHarmonyModeLegend,
    StudyHarmonySessionMode.legacyLevel => l10n.studyHarmonyModeLegacy,
  };
}

String _leagueTierLabel(AppLocalizations l10n, StudyHarmonyLeagueTier tier) {
  return switch (tier) {
    StudyHarmonyLeagueTier.rookie => l10n.studyHarmonyLeagueTierRookie,
    StudyHarmonyLeagueTier.bronze => l10n.studyHarmonyLeagueTierBronze,
    StudyHarmonyLeagueTier.silver => l10n.studyHarmonyLeagueTierSilver,
    StudyHarmonyLeagueTier.gold => l10n.studyHarmonyLeagueTierGold,
    StudyHarmonyLeagueTier.diamond => l10n.studyHarmonyLeagueTierDiamond,
  };
}

String _legendRewardLine(
  AppLocalizations l10n,
  StudyHarmonyCourseDefinition? course,
  StudyHarmonyLessonDefinition lesson,
) {
  var chapterTitle = lesson.chapterId;
  if (course != null) {
    for (final chapter in course.chapters) {
      if (chapter.id == lesson.chapterId) {
        chapterTitle = chapter.title;
        break;
      }
    }
  }
  return l10n.studyHarmonyResultLegendLine(chapterTitle);
}

String? _reviewReasonLabel(AppLocalizations l10n, String? reason) {
  return switch (reason) {
    'retry-needed' => l10n.studyHarmonyReviewReasonRetryNeeded,
    'accuracy-refresh' => l10n.studyHarmonyReviewReasonAccuracyRefresh,
    'low-mastery' => l10n.studyHarmonyReviewReasonLowMastery,
    'stale-skill' => l10n.studyHarmonyReviewReasonStaleSkill,
    'weak-spot' => l10n.studyHarmonyReviewReasonWeakSpot,
    'frontier-refresh' => l10n.studyHarmonyReviewReasonFrontierRefresh,
    _ => null,
  };
}

StudyHarmonyPersonalizationProfile _sessionAdaptiveProfile({
  required StudyHarmonyProgressSnapshot snapshot,
  required String localeTag,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  final modeClearCounts = snapshot.modeClearCounts;
  final competitorWeight =
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.relay) +
      _modeCountFromSnapshot(
        modeClearCounts,
        StudyHarmonySessionMode.bossRush,
      ) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.legend) +
      snapshot.relayWinCount +
      snapshot.legendaryChapterIds.length;
  final collectorWeight =
      snapshot.questChestCount +
      snapshot.shopPurchaseCount +
      ((snapshot.rewardCurrencyBalances['currency.starShard'] ?? 0) ~/ 2);
  final explorerWeight =
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.daily) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.focus) +
      snapshot.completedFrontierQuestDateKeys.length;
  final stabilizerWeight =
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.review) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.lesson) +
      snapshot.reviewQueuePlaceholders.length;

  final playStyle = _dominantPlayStyle(
    competitorWeight: competitorWeight.toDouble(),
    collectorWeight: collectorWeight.toDouble(),
    explorerWeight: explorerWeight.toDouble(),
    stabilizerWeight: stabilizerWeight.toDouble(),
  );
  final shortWeight =
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.lesson) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.review) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.daily);
  final longWeight =
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.focus) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.relay) +
      _modeCountFromSnapshot(
        modeClearCounts,
        StudyHarmonySessionMode.bossRush,
      ) +
      _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.legend);

  return StudyHarmonyPersonalizationProfile(
    ageBand: StudyHarmonyAgeBand.adult,
    skillBand: inferStudyHarmonySkillBand(recentPerformance),
    playStyle: playStyle,
    sessionLengthPreference: shortWeight >= longWeight
        ? StudyHarmonySessionLengthPreference.short
        : StudyHarmonySessionLengthPreference.long,
    regionFlavor: studyHarmonyRegionFlavorFromCountryCode(
      _countryCodeFromLocaleTag(localeTag),
    ),
    gameplayAffinity: StudyHarmonyGameplayAffinity(
      competition: _scaledWeight(competitorWeight.toDouble()),
      collection: _scaledWeight(collectorWeight.toDouble()),
      exploration: _scaledWeight(explorerWeight.toDouble()),
      stability: _scaledWeight(stabilizerWeight.toDouble()),
    ),
    countryCode: _countryCodeFromLocaleTag(localeTag),
    localeTag: localeTag,
  );
}

StudyHarmonyDifficultyInput _difficultyInputForSession({
  required StudyHarmonyRecentPerformance recentPerformance,
  required StudyHarmonyPersonalizationProfile adaptiveProfile,
  required StudyHarmonyProgressController progressController,
  required int liveComboPeak,
}) {
  final comboPeak = max(
    progressController.snapshot.bestSessionCombo,
    liveComboPeak,
  );
  return StudyHarmonyDifficultyInput(
    skillRating: recentPerformance.masteryMomentum,
    recentAccuracy: recentPerformance.averageAccuracy,
    recentStability: recentPerformance.confidence,
    recentMomentum:
        (recentPerformance.masteryMomentum - recentPerformance.recoveryNeed)
            .clamp(-1.0, 1.0)
            .toDouble(),
    recentStruggleRate: recentPerformance.recoveryNeed,
    recentComboPeak: (comboPeak.clamp(0, 20) / 20).toDouble(),
    preferredSessionMinutes: switch (adaptiveProfile.sessionLengthPreference) {
      StudyHarmonySessionLengthPreference.micro => 4,
      StudyHarmonySessionLengthPreference.short => 7,
      StudyHarmonySessionLengthPreference.medium => 10,
      StudyHarmonySessionLengthPreference.long => 13,
      StudyHarmonySessionLengthPreference.marathon => 16,
    },
  );
}

int _modeCountFromSnapshot(
  Map<String, int> counts,
  StudyHarmonySessionMode mode,
) {
  return counts[mode.name] ?? 0;
}

StudyHarmonyPlayStyle _dominantPlayStyle({
  required double competitorWeight,
  required double collectorWeight,
  required double explorerWeight,
  required double stabilizerWeight,
}) {
  final entries = <MapEntry<StudyHarmonyPlayStyle, double>>[
    MapEntry(StudyHarmonyPlayStyle.competitor, competitorWeight),
    MapEntry(StudyHarmonyPlayStyle.collector, collectorWeight),
    MapEntry(StudyHarmonyPlayStyle.explorer, explorerWeight),
    MapEntry(StudyHarmonyPlayStyle.stabilizer, stabilizerWeight),
    const MapEntry(StudyHarmonyPlayStyle.balanced, 0.8),
  ]..sort((left, right) => right.value.compareTo(left.value));
  return entries.first.key;
}

double _scaledWeight(double value) {
  return (value / 8).clamp(0.2, 1.0).toDouble();
}

String? _countryCodeFromLocaleTag(String localeTag) {
  final normalized = localeTag.replaceAll('_', '-');
  final parts = normalized.split('-');
  if (parts.length < 2) {
    return null;
  }
  final candidate = parts[1].trim();
  if (candidate.length != 2) {
    return null;
  }
  return candidate.toUpperCase();
}

bool _isKoreanLocale(String localeTag) {
  return localeTag.toLowerCase().startsWith('ko');
}

String _sessionArcadeTitle(String localeTag) {
  return _isKoreanLocale(localeTag) ? '아케이드 룰' : 'Arcade Rules';
}

String _sessionDirectorTitle(String localeTag) {
  return _isKoreanLocale(localeTag) ? '런 디렉터' : 'Run Director';
}

String _difficultyLaneLabel(String localeTag, StudyHarmonyDifficultyLane lane) {
  final ko = _isKoreanLocale(localeTag);
  return switch (lane) {
    StudyHarmonyDifficultyLane.recovery => ko ? '회복 레인' : 'Recovery Lane',
    StudyHarmonyDifficultyLane.groove => ko ? '그루브 레인' : 'Groove Lane',
    StudyHarmonyDifficultyLane.push => ko ? '푸시 레인' : 'Push Lane',
    StudyHarmonyDifficultyLane.clutch => ko ? '클러치 레인' : 'Clutch Lane',
    StudyHarmonyDifficultyLane.legend => ko ? '레전드 레인' : 'Legend Lane',
  };
}

String _pressureTierLabel(String localeTag, StudyHarmonyPressureTier tier) {
  final ko = _isKoreanLocale(localeTag);
  return switch (tier) {
    StudyHarmonyPressureTier.calm => ko ? '압박 낮음' : 'Calm Pressure',
    StudyHarmonyPressureTier.steady => ko ? '압박 보통' : 'Steady Pressure',
    StudyHarmonyPressureTier.hot => ko ? '압박 상승' : 'Hot Pressure',
    StudyHarmonyPressureTier.charged => ko ? '압박 높음' : 'Charged Pressure',
    StudyHarmonyPressureTier.overdrive => ko ? '압박 극대화' : 'Overdrive',
  };
}

String _forgivenessTierLabel(
  String localeTag,
  StudyHarmonyForgivenessTier tier,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (tier) {
    StudyHarmonyForgivenessTier.strict => ko ? '실수 허용 적음' : 'Strict Windows',
    StudyHarmonyForgivenessTier.tight => ko ? '실수 허용 타이트' : 'Tight Windows',
    StudyHarmonyForgivenessTier.balanced =>
      ko ? '실수 허용 균형' : 'Balanced Windows',
    StudyHarmonyForgivenessTier.kind => ko ? '실수 허용 넓음' : 'Kind Windows',
    StudyHarmonyForgivenessTier.generous =>
      ko ? '실수 허용 매우 넓음' : 'Generous Windows',
  };
}

String _sessionLengthLabel(String localeTag, int minutes) {
  return _isKoreanLocale(localeTag) ? '$minutes분 세션' : '$minutes min run';
}

String _comboGoalLabel(String localeTag, int comboTarget) {
  return _isKoreanLocale(localeTag)
      ? '콤보 목표 $comboTarget'
      : 'Combo Goal $comboTarget';
}

String _coachLabel(String localeTag, StudyHarmonyCoachStyle coachStyle) {
  final ko = _isKoreanLocale(localeTag);
  return switch (coachStyle) {
    StudyHarmonyCoachStyle.supportive => ko ? '응원형 코치' : 'Supportive Coach',
    StudyHarmonyCoachStyle.structured => ko ? '구조형 코치' : 'Structured Coach',
    StudyHarmonyCoachStyle.challengeForward =>
      ko ? '도전형 코치' : 'Challenge Coach',
    StudyHarmonyCoachStyle.analytical => ko ? '분석형 코치' : 'Analytical Coach',
    StudyHarmonyCoachStyle.restorative => ko ? '회복형 코치' : 'Restorative Coach',
  };
}

String _coachLine(String localeTag, StudyHarmonyAdaptivePlan plan) {
  final ko = _isKoreanLocale(localeTag);
  return switch (plan.coachStyle) {
    StudyHarmonyCoachStyle.supportive =>
      ko
          ? '실수보다 흐름을 지키는 데 집중해요.'
          : 'Protect flow first and let confidence compound.',
    StudyHarmonyCoachStyle.structured =>
      ko
          ? '순서를 지키면 실력이 가장 빠르게 붙어요.'
          : 'Follow the structure and the gains will stick.',
    StudyHarmonyCoachStyle.challengeForward =>
      ko
          ? '이번 런은 압박을 즐기며 한 단계 올려봅니다.'
          : 'Lean into the pressure and push for a sharper run.',
    StudyHarmonyCoachStyle.analytical =>
      ko
          ? '어디서 흔들리는지 읽으면서 정밀하게 갑니다.'
          : 'Read the weak point and refine it with precision.',
    StudyHarmonyCoachStyle.restorative =>
      ko
          ? '무너지지 않게 템포를 되찾는 런입니다.'
          : 'This run is about rebuilding rhythm without tilt.',
  };
}

String _pacingPlanLabel(
  String localeTag,
  StudyHarmonyDifficultyPlan difficultyPlan,
) {
  final ko = _isKoreanLocale(localeTag);
  final segments = difficultyPlan.pacingPlan.segments
      .where((segment) => segment.minutes > 0)
      .take(2)
      .map((segment) {
        final label = switch (segment.kind) {
          StudyHarmonyRhythmBeatKind.warmup => ko ? '워밍업' : 'Warmup',
          StudyHarmonyRhythmBeatKind.tension => ko ? '긴장' : 'Tension',
          StudyHarmonyRhythmBeatKind.release => ko ? '완화' : 'Release',
          StudyHarmonyRhythmBeatKind.reward => ko ? '보상' : 'Reward',
        };
        return '$label ${segment.minutes}m';
      })
      .join(' · ');
  return ko ? '페이싱 $segments' : 'Pacing $segments';
}

String _arcadeRiskLabel(
  String localeTag,
  StudyHarmonyArcadeRiskStyle riskStyle,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (riskStyle) {
    StudyHarmonyArcadeRiskStyle.forgiving => ko ? '리스크 낮음' : 'Low Risk',
    StudyHarmonyArcadeRiskStyle.balanced => ko ? '리스크 균형' : 'Balanced Risk',
    StudyHarmonyArcadeRiskStyle.tense => ko ? '리스크 높음' : 'High Tension',
    StudyHarmonyArcadeRiskStyle.punishing => ko ? '리스크 극한' : 'Punishing Risk',
  };
}

String _arcadeRewardStyleLabel(
  String localeTag,
  StudyHarmonyArcadeRewardStyle rewardStyle,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (rewardStyle) {
    StudyHarmonyArcadeRewardStyle.currency => ko ? '코인 중심' : 'Currency Loop',
    StudyHarmonyArcadeRewardStyle.cosmetic => ko ? '코스메틱 중심' : 'Cosmetic Hunt',
    StudyHarmonyArcadeRewardStyle.title => ko ? '칭호 중심' : 'Title Hunt',
    StudyHarmonyArcadeRewardStyle.trophy => ko ? '트로피 중심' : 'Trophy Run',
    StudyHarmonyArcadeRewardStyle.bundle => ko ? '묶음 보상' : 'Bundle Rewards',
    StudyHarmonyArcadeRewardStyle.prestige => ko ? '명예 보상' : 'Prestige Rewards',
  };
}

String _currencyTitle(StudyHarmonyCurrencyId currencyId) {
  return studyHarmonyCurrenciesById[currencyId]?.title ?? currencyId;
}

String _rewardBundleLabel(StudyHarmonyRewardBundleDefinition bundle) {
  final summary = bundle.grants
      .take(2)
      .map((grant) => '${_currencyTitle(grant.currencyId)} +${grant.amount}')
      .join(' · ');
  return '${bundle.title}: $summary';
}

String _currencyGrantLabel(StudyHarmonyRewardGrant grant) {
  return '${_currencyTitle(grant.currencyId)} +${grant.amount}';
}

String _currencyBalanceLabel(StudyHarmonyCurrencyId currencyId, int balance) {
  return '${_currencyTitle(currencyId)} $balance';
}

String _rewardUnlockLabel(
  String localeTag,
  StudyHarmonyRewardCandidate reward,
) {
  final ko = _isKoreanLocale(localeTag);
  final kind = switch (reward.kind) {
    StudyHarmonyRewardKind.achievement => ko ? '업적' : 'Achievement',
    StudyHarmonyRewardKind.title => ko ? '칭호' : 'Title',
    StudyHarmonyRewardKind.cosmetic => ko ? '코스메틱' : 'Cosmetic',
    StudyHarmonyRewardKind.shopItem => ko ? '상점 해금' : 'Shop Unlock',
  };
  return '$kind: ${reward.title}';
}

List<String> _runtimeRuleLabels(
  String localeTag,
  StudyHarmonySessionMetadata metadata,
) {
  final ko = _isKoreanLocale(localeTag);
  final labels = <String>[];
  if (metadata.missLifePenalty > 1) {
    labels.add(
      ko
          ? '실수 시 하트 -${metadata.missLifePenalty}'
          : 'Misses cost ${metadata.missLifePenalty} hearts',
    );
  }
  if (metadata.missProgressPenalty > 0) {
    labels.add(
      ko
          ? '실수 시 진행 -${metadata.missProgressPenalty}'
          : 'Misses push progress back',
    );
  }
  if (metadata.comboProgressThreshold > 0 && metadata.comboProgressBonus > 0) {
    labels.add(
      ko
          ? '콤보 ${metadata.comboProgressThreshold}마다 진행 +${metadata.comboProgressBonus}'
          : 'Combo ${metadata.comboProgressThreshold} => +${metadata.comboProgressBonus} progress',
    );
  }
  if (metadata.comboLifeThreshold > 0 && metadata.comboLifeBonus > 0) {
    labels.add(
      ko
          ? '콤보 ${metadata.comboLifeThreshold}마다 하트 +${metadata.comboLifeBonus}'
          : 'Combo ${metadata.comboLifeThreshold} => +${metadata.comboLifeBonus} heart',
    );
  }
  if (metadata.comboResetsOnMiss) {
    labels.add(ko ? '실수 시 콤보 초기화' : 'Misses reset combo');
  } else if (metadata.comboDropOnMiss > 0) {
    labels.add(
      ko
          ? '실수 시 콤보 -${metadata.comboDropOnMiss}'
          : 'Misses cut combo by ${metadata.comboDropOnMiss}',
    );
  }
  if (metadata.shuffleChoiceOptions) {
    labels.add(ko ? '선택지가 계속 섞임' : 'Choices reshuffle');
  }
  if (metadata.repeatMissedTask) {
    labels.add(ko ? '틀린 문제 즉시 재도전' : 'Missed prompts replay');
  }
  if (metadata.uniqueTaskCycle) {
    labels.add(ko ? '중복 문제 최소화' : 'No prompt repeats');
  }
  return labels;
}

String _skillLabel(AppLocalizations l10n, StudyHarmonySkillTag skillId) {
  return switch (skillId) {
    'note.read' => l10n.studyHarmonySkillNoteRead,
    'note.findKeyboard' => l10n.studyHarmonySkillNoteFindKeyboard,
    'note.accidentals' => l10n.studyHarmonySkillNoteAccidentals,
    'chord.symbolToKeys' => l10n.studyHarmonySkillChordSymbolToKeys,
    'chord.nameFromTones' => l10n.studyHarmonySkillChordNameFromTones,
    'scale.build' => l10n.studyHarmonySkillScaleBuild,
    'roman.realize' => l10n.studyHarmonySkillRomanRealize,
    'roman.identify' => l10n.studyHarmonySkillRomanIdentify,
    'harmony.diatonicity' => l10n.studyHarmonySkillHarmonyDiatonicity,
    'harmony.function' => l10n.studyHarmonySkillHarmonyFunction,
    'progression.keyCenter' => l10n.studyHarmonySkillProgressionKeyCenter,
    'progression.function' => l10n.studyHarmonySkillProgressionFunction,
    'progression.nonDiatonic' => l10n.studyHarmonySkillProgressionNonDiatonic,
    'progression.fillBlank' => l10n.studyHarmonySkillProgressionFillBlank,
    _ => skillId,
  };
}
