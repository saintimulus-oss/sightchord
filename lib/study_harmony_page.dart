import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'study_harmony/application/study_harmony_session_controller.dart';
import 'study_harmony/content/core_curriculum_catalog.dart';
import 'study_harmony/domain/study_harmony_session_models.dart';
import 'study_harmony/study_harmony_session_page.dart';

enum _StudyHarmonyHubTrack { core, pop, jazz, classical }

class StudyHarmonyPage extends StatefulWidget {
  const StudyHarmonyPage({super.key, required this.progressController});

  final StudyHarmonyProgressController progressController;

  @override
  State<StudyHarmonyPage> createState() => _StudyHarmonyPageState();
}

class _StudyHarmonyPageState extends State<StudyHarmonyPage> {
  StudyHarmonyCourseDefinition? _coreCourse;
  String? _localeTag;
  _StudyHarmonyHubTrack _selectedTrack = _StudyHarmonyHubTrack.core;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLocalizedCourse();
  }

  @override
  void didUpdateWidget(covariant StudyHarmonyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressController != widget.progressController &&
        _coreCourse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _coreCourse == null) {
          return;
        }
        unawaited(widget.progressController.syncCourse(_coreCourse!));
      });
    }
  }

  void _syncLocalizedCourse() {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    if (_coreCourse != null && _localeTag == localeTag) {
      return;
    }

    final course = buildStudyHarmonyCoreCourse(AppLocalizations.of(context)!);
    _coreCourse = course;
    _localeTag = localeTag;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(widget.progressController.syncCourse(course));
    });
  }

  void _openLesson(
    BuildContext context,
    StudyHarmonyLessonDefinition lesson,
    StudyHarmonyCourseDefinition course,
    StudyHarmonySessionControllerFactory? controllerFactory,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StudyHarmonySessionPage(
          lesson: lesson,
          trackId: course.trackId,
          progressController: widget.progressController,
          courseToSync: course,
          controllerFactory: controllerFactory,
        ),
      ),
    );
  }

  void _openRecommendation(
    BuildContext context,
    AppLocalizations l10n,
    StudyHarmonyLessonRecommendation recommendation,
    StudyHarmonyCourseDefinition course,
  ) {
    final sessionLesson = _buildSessionLesson(
      l10n: l10n,
      recommendation: recommendation,
    );
    final controllerFactory = recommendation.seedValue == null
        ? null
        : (StudyHarmonyLessonDefinition lesson) =>
              StudyHarmonySessionController(
                lesson: lesson,
                random: Random(recommendation.seedValue!),
              );
    _openLesson(context, sessionLesson, course, controllerFactory);
  }

  Future<void> _openChapterSheet(
    BuildContext context,
    StudyHarmonyChapterProgressSummaryView summary,
    StudyHarmonyCourseDefinition course,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              key: ValueKey(
                'study-harmony-chapter-sheet-${summary.chapter.id}',
              ),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.studyHarmonyChapterViewTitle(summary.chapter.title),
                  style: Theme.of(sheetContext).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  summary.chapter.description,
                  style: Theme.of(sheetContext).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(sheetContext).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sheetContext).size.height * 0.55,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: summary.chapter.lessons.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lesson = summary.chapter.lessons[index];
                      final unlocked = widget.progressController
                          .isLessonUnlocked(lesson.id);
                      final cleared = widget.progressController.isLessonCleared(
                        lesson.id,
                      );
                      return _ChapterLessonTile(
                        lesson: lesson,
                        unlocked: unlocked,
                        cleared: cleared,
                        onOpen: unlocked
                            ? () {
                                Navigator.of(sheetContext).pop();
                                _openLesson(context, lesson, course, null);
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final course = _coreCourse ?? buildStudyHarmonyCoreCourse(l10n);

    return AnimatedBuilder(
      animation: widget.progressController,
      builder: (context, _) {
        final chapterSummaries = [
          for (final chapter in course.chapters)
            widget.progressController.chapterProgressFor(chapter),
        ];
        final continueRecommendation = widget.progressController
            .continueRecommendationForCourse(course);
        final reviewRecommendation = widget.progressController
            .reviewRecommendationForCourse(course);
        final dailyRecommendation = widget.progressController
            .dailyChallengeRecommendationForCourse(course);
        final clearedLessons = chapterSummaries.fold<int>(
          0,
          (sum, summary) => sum + summary.clearedLessonCount,
        );
        final totalLessons = chapterSummaries.fold<int>(
          0,
          (sum, summary) => sum + summary.lessonCount,
        );
        final clearedChapters = chapterSummaries
            .where((summary) => summary.isCompleted)
            .length;
        final selectedTrack = _trackView(
          l10n: l10n,
          course: course,
          track: _selectedTrack,
        );

        return Scaffold(
          appBar: AppBar(title: Text(l10n.studyHarmonyTitle)),
          body: DecoratedBox(
            key: const ValueKey('study-harmony-page'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.tertiaryContainer.withValues(alpha: 0.38),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final contentWidth = constraints.maxWidth;
                        final actionColumns = _columnsFor(
                          contentWidth,
                          compact: 1,
                          medium: 2,
                          large: 3,
                        );
                        final chapterColumns = _columnsFor(
                          contentWidth,
                          compact: 1,
                          medium: 1,
                          large: 2,
                        );
                        final actionWidth = _cardWidthFor(
                          contentWidth,
                          actionColumns,
                        );
                        final chapterWidth = _cardWidthFor(
                          contentWidth,
                          chapterColumns,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _HubHeroCard(
                              title: l10n.studyHarmonyTitle,
                              eyebrow: l10n.studyHarmonyHubHeroEyebrow,
                              subtitle: l10n.studyHarmonySubtitle,
                              body: selectedTrack.description,
                              lessonsProgressLabel: l10n
                                  .studyHarmonyHubLessonsProgress(
                                    clearedLessons,
                                    totalLessons,
                                  ),
                              chapterProgressLabel: l10n
                                  .studyHarmonyHubChaptersProgress(
                                    clearedChapters,
                                    course.chapters.length,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              l10n.studyHarmonyTrackFilterLabel,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SegmentedButton<_StudyHarmonyHubTrack>(
                              key: const ValueKey('study-harmony-track-filter'),
                              showSelectedIcon: false,
                              segments: [
                                ButtonSegment(
                                  value: _StudyHarmonyHubTrack.core,
                                  icon: const Icon(Icons.menu_book_rounded),
                                  label: Text(
                                    l10n.studyHarmonyTrackCoreFilterLabel,
                                  ),
                                ),
                                ButtonSegment(
                                  value: _StudyHarmonyHubTrack.pop,
                                  icon: const Icon(Icons.lock_outline_rounded),
                                  label: Text(
                                    l10n.studyHarmonyTrackPopFilterLabel,
                                  ),
                                ),
                                ButtonSegment(
                                  value: _StudyHarmonyHubTrack.jazz,
                                  icon: const Icon(Icons.lock_outline_rounded),
                                  label: Text(
                                    l10n.studyHarmonyTrackJazzFilterLabel,
                                  ),
                                ),
                                ButtonSegment(
                                  value: _StudyHarmonyHubTrack.classical,
                                  icon: const Icon(Icons.lock_outline_rounded),
                                  label: Text(
                                    l10n.studyHarmonyTrackClassicalFilterLabel,
                                  ),
                                ),
                              ],
                              selected: {_selectedTrack},
                              onSelectionChanged: (selection) {
                                setState(() {
                                  _selectedTrack = selection.first;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            if (_selectedTrack ==
                                _StudyHarmonyHubTrack.core) ...[
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-continue-card',
                                      ),
                                      icon: Icons.play_circle_fill_rounded,
                                      title: l10n.studyHarmonyContinueCardTitle,
                                      headline:
                                          continueRecommendation
                                              ?.lesson
                                              .title ??
                                          l10n.studyHarmonyContinueCardTitle,
                                      supportingLabel:
                                          continueRecommendation
                                              ?.chapter
                                              .title ??
                                          course.title,
                                      body: _continueHint(
                                        l10n,
                                        continueRecommendation,
                                      ),
                                      footerLabel:
                                          continueRecommendation == null
                                          ? null
                                          : l10n.studyHarmonyChapterNextUp(
                                              continueRecommendation
                                                  .lesson
                                                  .title,
                                            ),
                                      actionLabel:
                                          l10n.studyHarmonyContinueAction,
                                      onPressed: continueRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              continueRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-review-card',
                                      ),
                                      icon: Icons.refresh_rounded,
                                      title: l10n.studyHarmonyReviewCardTitle,
                                      headline:
                                          reviewRecommendation?.lesson.title ??
                                          l10n.studyHarmonyReviewCardTitle,
                                      supportingLabel:
                                          reviewRecommendation?.chapter.title ??
                                          course.title,
                                      body: _reviewHint(
                                        l10n,
                                        reviewRecommendation,
                                      ),
                                      footerLabel: _reviewFooter(
                                        l10n,
                                        reviewRecommendation,
                                      ),
                                      actionLabel:
                                          l10n.studyHarmonyReviewAction,
                                      onPressed: reviewRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              reviewRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-daily-card',
                                      ),
                                      icon: Icons.wb_sunny_rounded,
                                      title: l10n.studyHarmonyDailyCardTitle,
                                      headline:
                                          dailyRecommendation?.lesson.title ??
                                          l10n.studyHarmonyDailyCardTitle,
                                      supportingLabel:
                                          dailyRecommendation?.chapter.title ??
                                          course.title,
                                      body: l10n.studyHarmonyDailyCardHint,
                                      footerLabel:
                                          dailyRecommendation?.dailyDateKey ==
                                              null
                                          ? null
                                          : l10n.studyHarmonyDailyDateBadge(
                                              dailyRecommendation!
                                                  .dailyDateKey!,
                                            ),
                                      actionLabel: l10n.studyHarmonyDailyAction,
                                      onPressed: dailyRecommendation == null
                                          ? null
                                          : () async {
                                              final prepared = await widget
                                                  .progressController
                                                  .prepareDailyChallengeRecommendationForCourse(
                                                    course,
                                                  );
                                              if (!context.mounted ||
                                                  prepared == null) {
                                                return;
                                              }
                                              _openRecommendation(
                                                context,
                                                l10n,
                                                prepared,
                                                course,
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Text(
                                l10n.studyHarmonyHubChapterSectionTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  for (final summary in chapterSummaries)
                                    SizedBox(
                                      width: chapterWidth,
                                      child: _HubChapterCard(
                                        summary: summary,
                                        progressLabel: l10n
                                            .studyHarmonyChapterProgressText(
                                              summary.clearedLessonCount,
                                              summary.lessonCount,
                                            ),
                                        lessonCountLabel: l10n
                                            .studyHarmonyLessonsCount(
                                              summary.lessonCount,
                                            ),
                                        completedCountLabel: l10n
                                            .studyHarmonyCompletedLessonsCount(
                                              summary.clearedLessonCount,
                                            ),
                                        nextLessonLabel:
                                            summary.nextLesson == null
                                            ? null
                                            : l10n.studyHarmonyChapterNextUp(
                                                summary.nextLesson!.title,
                                              ),
                                        lockedLabel:
                                            l10n.studyHarmonyLockedChapterTag,
                                        actionLabel: summary.unlocked
                                            ? l10n.studyHarmonyOpenChapterAction
                                            : l10n.studyHarmonyLockedLessonAction,
                                        onOpen: summary.unlocked
                                            ? () => _openChapterSheet(
                                                context,
                                                summary,
                                                course,
                                              )
                                            : null,
                                      ),
                                    ),
                                ],
                              ),
                            ] else
                              _LockedTrackPlaceholderCard(
                                trackTitle: selectedTrack.title,
                                trackDescription: selectedTrack.description,
                                body: l10n.studyHarmonyTrackPlaceholderBody(
                                  course.title,
                                ),
                                badgeLabel: l10n.studyHarmonyComingSoonTag,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

StudyHarmonyLessonDefinition _buildSessionLesson({
  required AppLocalizations l10n,
  required StudyHarmonyLessonRecommendation recommendation,
}) {
  if (recommendation.sessionMode == StudyHarmonySessionMode.lesson &&
      recommendation.resolvedSourceLessons.length <= 1) {
    return recommendation.lesson;
  }

  final sourceLessons = recommendation.resolvedSourceLessons;
  final skillTags = recommendation.focusSkillTags.isEmpty
      ? {for (final lesson in sourceLessons) ...lesson.skillTags}
      : recommendation.focusSkillTags;
  final sessionId = [
    recommendation.sessionMode.name,
    recommendation.lesson.id,
    for (final lesson in sourceLessons) lesson.id,
  ].join('__');

  return StudyHarmonyLessonDefinition(
    id: 'synthetic-$sessionId',
    chapterId: recommendation.chapter.id,
    title: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => l10n.studyHarmonyReviewSessionTitle,
      StudyHarmonySessionMode.daily => l10n.studyHarmonyDailySessionTitle,
      StudyHarmonySessionMode.lesson => recommendation.lesson.title,
      StudyHarmonySessionMode.legacyLevel => recommendation.lesson.title,
    },
    description: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review =>
        l10n.studyHarmonyReviewSessionDescription(recommendation.chapter.title),
      StudyHarmonySessionMode.daily => l10n.studyHarmonyDailySessionDescription(
        recommendation.chapter.title,
      ),
      StudyHarmonySessionMode.lesson => recommendation.lesson.description,
      StudyHarmonySessionMode.legacyLevel => recommendation.lesson.description,
    },
    objectiveLabel: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => l10n.studyHarmonyModeReview,
      StudyHarmonySessionMode.daily => l10n.studyHarmonyModeDaily,
      StudyHarmonySessionMode.lesson => recommendation.lesson.objectiveLabel,
      StudyHarmonySessionMode.legacyLevel =>
        recommendation.lesson.objectiveLabel,
    },
    goalCorrectAnswers: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => max(
        5,
        min(7, sourceLessons.length * 2),
      ),
      StudyHarmonySessionMode.daily => max(6, min(8, sourceLessons.length * 2)),
      StudyHarmonySessionMode.lesson =>
        recommendation.lesson.goalCorrectAnswers,
      StudyHarmonySessionMode.legacyLevel =>
        recommendation.lesson.goalCorrectAnswers,
    },
    startingLives: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => 3,
      StudyHarmonySessionMode.daily => 4,
      StudyHarmonySessionMode.lesson => recommendation.lesson.startingLives,
      StudyHarmonySessionMode.legacyLevel =>
        recommendation.lesson.startingLives,
    },
    sessionMode: recommendation.sessionMode,
    tasks: [for (final lesson in sourceLessons) ...lesson.tasks],
    skillTags: skillTags,
    sessionMetadata: StudyHarmonySessionMetadata(
      anchorLessonId: recommendation.lesson.id,
      sourceLessonIds: {for (final lesson in sourceLessons) lesson.id},
      focusSkillTags: skillTags,
      countsTowardLessonProgress: false,
      reviewReason: recommendation.reviewReason,
      dailyDateKey: recommendation.dailyDateKey,
      dailySeedValue: recommendation.seedValue,
    ),
  );
}

class _HubHeroCard extends StatelessWidget {
  const _HubHeroCard({
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    required this.body,
    required this.lessonsProgressLabel,
    required this.chapterProgressLabel,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final String body;
  final String lessonsProgressLabel;
  final String chapterProgressLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: const ValueKey('study-harmony-hero-card'),
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(
                  avatar: const Icon(Icons.flag_rounded, size: 18),
                  label: Text(lessonsProgressLabel),
                ),
                Chip(
                  avatar: const Icon(Icons.auto_stories_rounded, size: 18),
                  label: Text(chapterProgressLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HubActionCard extends StatelessWidget {
  const _HubActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.headline,
    required this.supportingLabel,
    required this.body,
    required this.actionLabel,
    required this.onPressed,
    this.footerLabel,
  });

  final IconData icon;
  final String title;
  final String headline;
  final String supportingLabel;
  final String body;
  final String actionLabel;
  final VoidCallback? onPressed;
  final String? footerLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(height: 14),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              headline,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              supportingLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (footerLabel case final footer?) ...[
              const SizedBox(height: 12),
              Chip(label: Text(footer)),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubChapterCard extends StatelessWidget {
  const _HubChapterCard({
    required this.summary,
    required this.progressLabel,
    required this.lessonCountLabel,
    required this.completedCountLabel,
    required this.lockedLabel,
    required this.actionLabel,
    required this.onOpen,
    this.nextLessonLabel,
  });

  final StudyHarmonyChapterProgressSummaryView summary;
  final String progressLabel;
  final String lessonCountLabel;
  final String completedCountLabel;
  final String lockedLabel;
  final String actionLabel;
  final String? nextLessonLabel;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      key: ValueKey('study-harmony-chapter-card-${summary.chapter.id}'),
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!summary.unlocked)
                  Chip(
                    key: ValueKey(
                      'study-harmony-chapter-lock-${summary.chapter.id}',
                    ),
                    avatar: const Icon(Icons.lock_outline_rounded, size: 18),
                    label: Text(lockedLabel),
                  ),
                if (summary.isCompleted)
                  Chip(
                    avatar: const Icon(Icons.check_circle_rounded, size: 18),
                    label: Text(l10n.studyHarmonyClearedTag),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              summary.chapter.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              summary.chapter.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                key: ValueKey(
                  'study-harmony-chapter-progress-${summary.chapter.id}',
                ),
                value: summary.progressFraction,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              progressLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(lessonCountLabel)),
                Chip(label: Text(completedCountLabel)),
              ],
            ),
            if (nextLessonLabel case final nextLesson?) ...[
              const SizedBox(height: 12),
              Text(
                nextLesson,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: ValueKey(
                  'study-harmony-open-chapter-${summary.chapter.id}',
                ),
                onPressed: onOpen,
                icon: Icon(
                  summary.unlocked
                      ? Icons.auto_stories_rounded
                      : Icons.lock_outline_rounded,
                ),
                label: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterLessonTile extends StatelessWidget {
  const _ChapterLessonTile({
    required this.lesson,
    required this.unlocked,
    required this.cleared,
    required this.onOpen,
  });

  final StudyHarmonyLessonDefinition lesson;
  final bool unlocked;
  final bool cleared;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(lesson.objectiveLabel)),
                if (cleared) Chip(label: Text(l10n.studyHarmonyClearedTag)),
                if (!unlocked)
                  Chip(label: Text(l10n.studyHarmonyLockedLessonAction)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              lesson.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              lesson.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: ValueKey('study-harmony-open-lesson-${lesson.id}'),
                onPressed: onOpen,
                icon: Icon(
                  unlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                ),
                label: Text(
                  unlocked
                      ? l10n.studyHarmonyOpenLessonAction
                      : l10n.studyHarmonyLockedLessonAction,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedTrackPlaceholderCard extends StatelessWidget {
  const _LockedTrackPlaceholderCard({
    required this.trackTitle,
    required this.trackDescription,
    required this.body,
    required this.badgeLabel,
  });

  final String trackTitle;
  final String trackDescription;
  final String body;
  final String badgeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: const ValueKey('study-harmony-track-placeholder'),
      elevation: 0,
      color: colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: const Icon(Icons.lock_outline_rounded, size: 18),
              label: Text(badgeLabel),
            ),
            const SizedBox(height: 14),
            Text(
              trackTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trackDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackViewData {
  const _TrackViewData({required this.title, required this.description});

  final String title;
  final String description;
}

_TrackViewData _trackView({
  required AppLocalizations l10n,
  required StudyHarmonyCourseDefinition course,
  required _StudyHarmonyHubTrack track,
}) {
  return switch (track) {
    _StudyHarmonyHubTrack.core => _TrackViewData(
      title: course.title,
      description: l10n.studyHarmonyHubHeroBody,
    ),
    _StudyHarmonyHubTrack.pop => _TrackViewData(
      title: l10n.studyHarmonyPopTrackTitle,
      description: l10n.studyHarmonyPopTrackDescription,
    ),
    _StudyHarmonyHubTrack.jazz => _TrackViewData(
      title: l10n.studyHarmonyJazzTrackTitle,
      description: l10n.studyHarmonyJazzTrackDescription,
    ),
    _StudyHarmonyHubTrack.classical => _TrackViewData(
      title: l10n.studyHarmonyClassicalTrackTitle,
      description: l10n.studyHarmonyClassicalTrackDescription,
    ),
  };
}

int _columnsFor(
  double width, {
  required int compact,
  required int medium,
  required int large,
}) {
  if (width >= 960) {
    return large;
  }
  if (width >= 680) {
    return medium;
  }
  return compact;
}

double _cardWidthFor(double width, int columns) {
  if (columns <= 1) {
    return width;
  }
  return (width - ((columns - 1) * 16)) / columns;
}

String _continueHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyContinueFrontierHint;
  }
  return switch (recommendation.source) {
    StudyHarmonyRecommendationSource.lastPlayed =>
      l10n.studyHarmonyContinueResumeHint,
    StudyHarmonyRecommendationSource.frontier =>
      l10n.studyHarmonyContinueFrontierHint,
    _ => l10n.studyHarmonyContinueFrontierHint,
  };
}

String _reviewHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyReviewFallbackHint;
  }
  return switch (recommendation.source) {
    StudyHarmonyRecommendationSource.reviewQueue =>
      recommendation.reviewEntry?.reason == 'retry-needed'
          ? l10n.studyHarmonyReviewRetryNeededHint
          : l10n.studyHarmonyReviewAccuracyRefreshHint,
    StudyHarmonyRecommendationSource.weakSpot =>
      l10n.studyHarmonyReviewWeakHint,
    _ => l10n.studyHarmonyReviewFallbackHint,
  };
}

String? _reviewFooter(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return null;
  }
  if (recommendation.source == StudyHarmonyRecommendationSource.reviewQueue) {
    return l10n.studyHarmonyReviewQueueHint;
  }
  return recommendation.source == StudyHarmonyRecommendationSource.weakSpot
      ? l10n.studyHarmonyReviewWeakHint
      : null;
}
