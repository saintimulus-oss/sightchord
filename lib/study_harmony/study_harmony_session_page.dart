import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import 'application/study_harmony_progress_controller.dart';
import 'application/study_harmony_session_controller.dart';
import 'domain/study_harmony_session_models.dart';
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
    _controller.removeListener(_handleSessionChanged);
    _controller.dispose();
    _pageFocusNode.dispose();
    super.dispose();
  }

  StudyHarmonySessionController _buildController() {
    return widget.controllerFactory?.call(widget.lesson) ??
        StudyHarmonySessionController(lesson: widget.lesson);
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

  void _toggleAnswer(StudyHarmonyAnswerOptionId answerId) {
    _controller.toggleAnswer(answerId);
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
        final primaryActionLabel =
            state.phase == StudyHarmonySessionPhase.submittedCorrect ||
                state.phase == StudyHarmonySessionPhase.submittedIncorrect
            ? l10n.studyHarmonyNextPrompt
            : l10n.studyHarmonySubmit;

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
                                              _SessionOverviewCard(
                                                lesson: lesson,
                                                modeLabel: _sessionModeLabel(
                                                  l10n,
                                                  lesson.sessionMode,
                                                ),
                                                progressLabel: l10n
                                                    .studyHarmonyClearProgress(
                                                      state.correctAnswers,
                                                      lesson.goalCorrectAnswers,
                                                    ),
                                                attemptsLabel:
                                                    '${l10n.studyHarmonyAttempts} ${state.attempts}',
                                                accuracyLabel:
                                                    '${l10n.studyHarmonyAccuracy} ${_formatAccuracy(state.accuracy)}',
                                                elapsedLabel:
                                                    '${l10n.studyHarmonyElapsedTime} ${_formatDuration(state.elapsed)}',
                                                objectiveLabel:
                                                    l10n.studyHarmonyObjective,
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
                                          state.correctAnswers,
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

class _SessionOverviewCard extends StatelessWidget {
  const _SessionOverviewCard({
    required this.lesson,
    required this.modeLabel,
    required this.progressLabel,
    required this.attemptsLabel,
    required this.accuracyLabel,
    required this.elapsedLabel,
    required this.objectiveLabel,
  });

  final StudyHarmonyLessonDefinition lesson;
  final String modeLabel;
  final String progressLabel;
  final String attemptsLabel;
  final String accuracyLabel;
  final String elapsedLabel;
  final String objectiveLabel;

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
                  _StatChip(
                    label: '$objectiveLabel ${lesson.goalCorrectAnswers}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.task, required this.instructionLabel});

  final StudyHarmonyTaskInstance task;
  final String instructionLabel;

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
    required this.retryLabel,
    required this.backLabel,
    required this.onRetry,
    required this.onBack,
    this.reviewReasonLabel,
    this.dailyDateLabel,
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
  final String retryLabel;
  final String backLabel;
  final String? reviewReasonLabel;
  final String? dailyDateLabel;
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
        child: Padding(
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

String _sessionModeLabel(AppLocalizations l10n, StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.lesson => l10n.studyHarmonyModeLesson,
    StudyHarmonySessionMode.review => l10n.studyHarmonyModeReview,
    StudyHarmonySessionMode.daily => l10n.studyHarmonyModeDaily,
    StudyHarmonySessionMode.legacyLevel => l10n.studyHarmonyModeLegacy,
  };
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
