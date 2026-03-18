import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'study_harmony/application/study_harmony_session_controller.dart';
import 'study_harmony/content/core_curriculum_catalog.dart';
import 'study_harmony/content/study_harmony_track_catalog.dart';
import 'study_harmony/domain/study_harmony_progress_models.dart';
import 'study_harmony/domain/study_harmony_session_models.dart';
import 'study_harmony/study_harmony_session_page.dart';

enum _StudyHarmonyHubTrack { core, pop, jazz, classical }

StudyHarmonyTrackId _trackIdForHubTrack(_StudyHarmonyHubTrack track) {
  return switch (track) {
    _StudyHarmonyHubTrack.core => studyHarmonyCoreTrackId,
    _StudyHarmonyHubTrack.pop => studyHarmonyPopTrackId,
    _StudyHarmonyHubTrack.jazz => studyHarmonyJazzTrackId,
    _StudyHarmonyHubTrack.classical => studyHarmonyClassicalTrackId,
  };
}

_StudyHarmonyHubTrack _hubTrackFromTrackId(StudyHarmonyTrackId? trackId) {
  return switch (normalizeStudyHarmonyTrackId(trackId)) {
    studyHarmonyPopTrackId => _StudyHarmonyHubTrack.pop,
    studyHarmonyJazzTrackId => _StudyHarmonyHubTrack.jazz,
    studyHarmonyClassicalTrackId => _StudyHarmonyHubTrack.classical,
    _ => _StudyHarmonyHubTrack.core,
  };
}

Color _hubCardColor(ColorScheme colorScheme) => colorScheme.surfaceContainerLow;

RoundedRectangleBorder _hubCardShape(
  ColorScheme colorScheme, {
  double radius = 28,
}) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: BorderSide(color: colorScheme.outlineVariant),
  );
}

BoxDecoration _hubPanelDecoration(
  ColorScheme colorScheme, {
  bool accent = false,
  double radius = 24,
}) {
  return BoxDecoration(
    color: accent
        ? colorScheme.primaryContainer.withValues(alpha: 0.34)
        : colorScheme.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: accent
          ? colorScheme.primary.withValues(alpha: 0.18)
          : colorScheme.outlineVariant,
    ),
  );
}

class StudyHarmonyPage extends StatefulWidget {
  const StudyHarmonyPage({super.key, required this.progressController});

  final StudyHarmonyProgressController progressController;

  @override
  State<StudyHarmonyPage> createState() => _StudyHarmonyPageState();
}

class _StudyHarmonyPageState extends State<StudyHarmonyPage> {
  Map<StudyHarmonyTrackId, StudyHarmonyCourseDefinition>? _coursesByTrackId;
  String? _localeTag;
  _StudyHarmonyHubTrack _selectedTrack = _StudyHarmonyHubTrack.core;

  @override
  void initState() {
    super.initState();
    _selectedTrack = _hubTrackFromTrackId(
      widget.progressController.lastPlayedTrackId,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncLocalizedCourses();
  }

  @override
  void didUpdateWidget(covariant StudyHarmonyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progressController != widget.progressController &&
        _coursesByTrackId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final coursesByTrackId = _coursesByTrackId;
        if (!mounted || coursesByTrackId == null) {
          return;
        }
        unawaited(
          Future.wait<void>([
            for (final course in coursesByTrackId.values)
              widget.progressController.syncCourse(course),
          ]),
        );
      });
    }
  }

  void _syncLocalizedCourses() {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    if (_coursesByTrackId != null && _localeTag == localeTag) {
      return;
    }

    final coursesByTrackId = buildStudyHarmonyTrackCourses(
      AppLocalizations.of(context)!,
    );
    _coursesByTrackId = coursesByTrackId;
    _localeTag = localeTag;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        Future.wait<void>([
          for (final course in coursesByTrackId.values)
            widget.progressController.syncCourse(course),
        ]),
      );
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
                      final lessonResult = widget.progressController
                          .lessonResultFor(lesson.id);
                      return _ChapterLessonTile(
                        lesson: lesson,
                        lessonResult: lessonResult,
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
    final coursesByTrackId =
        _coursesByTrackId ?? buildStudyHarmonyTrackCourses(l10n);
    final course =
        coursesByTrackId[_trackIdForHubTrack(_selectedTrack)] ??
        coursesByTrackId[studyHarmonyCoreTrackId]!;

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
        final focusRecommendation = widget.progressController
            .focusSprintRecommendationForCourse(course);
        final relayRecommendation = widget.progressController
            .relayRecommendationForCourse(course);
        final legendRecommendation = widget.progressController
            .legendTrialRecommendationForCourse(course);
        final bossRushRecommendation = widget.progressController
            .bossRushRecommendationForCourse(course);
        final dailyRecommendation = widget.progressController
            .dailyChallengeRecommendationForCourse(course);
        final questChestStatus = widget.progressController
            .questChestStatusForCourse(course);
        final questChestRecommendation = widget.progressController
            .questChestRecommendationForCourse(course);
        final weeklyGoals = widget.progressController.weeklyPlanForCourse(
          course,
        );
        final monthlyTour = widget.progressController
            .monthlyTourProgressForCourse(course);
        final duetPact = widget.progressController.duetPactProgress();
        final leagueProgress = widget.progressController
            .currentLeagueProgress();
        final leagueXpBoost = widget.progressController.currentLeagueXpBoost();
        final leagueBoostRecommendation = widget.progressController
            .leagueBoostRecommendationForCourse(course);
        final monthlyTourRecommendation = widget.progressController
            .monthlyTourRecommendationForCourse(course);
        final monthlyTourActionRecommendation =
            monthlyTourRecommendation ??
            leagueBoostRecommendation ??
            continueRecommendation ??
            reviewRecommendation ??
            focusRecommendation ??
            dailyRecommendation;
        final duetPactRecommendation = widget.progressController
            .duetPactRecommendationForCourse(course);
        final questChestActionRecommendation = questChestStatus.openedToday
            ? leagueBoostRecommendation ??
                  continueRecommendation ??
                  reviewRecommendation ??
                  focusRecommendation ??
                  dailyRecommendation
            : questChestRecommendation;
        final reviewFooter = _reviewFooter(l10n, reviewRecommendation);
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
        final totalStars = widget.progressController.starsEarnedForCourse(
          course,
        );
        final legendaryChapters = widget.progressController
            .legendaryChapterCountForCourse(course);
        final relayWins = widget.progressController.relayWinCount();
        final masteredSkills = widget.progressController
            .masteredSkillCountForCourse(course);
        final dueReviews = widget.progressController.dueReviewCountForCourse(
          course,
        );
        final dailyStreak = widget.progressController
            .currentDailyChallengeStreak();
        final streakSavers = widget.progressController
            .currentStreakSaverCount();
        final dailyCompletedToday = widget.progressController
            .isDailyChallengeCompletedToday();
        final questCards = [
          for (final quest in widget.progressController.questBoardForCourse(
            course,
          ))
            _questCardData(l10n: l10n, quest: quest),
        ];
        final milestoneCards = [
          for (final milestone
              in widget.progressController.milestoneBoardForCourse(course))
            _milestoneCardData(l10n: l10n, milestone: milestone),
        ];
        final selectedTrackDescription = _trackDescription(
          l10n: l10n,
          course: course,
          track: _selectedTrack,
        );
        final heroMetrics = <_HubMetricChipData>[
          _HubMetricChipData(
            icon: Icons.flag_rounded,
            label: l10n.studyHarmonyHubLessonsProgress(
              clearedLessons,
              totalLessons,
            ),
          ),
          _HubMetricChipData(
            icon: Icons.auto_stories_rounded,
            label: l10n.studyHarmonyHubChaptersProgress(
              clearedChapters,
              course.chapters.length,
            ),
          ),
          _HubMetricChipData(
            icon: Icons.stars_rounded,
            label: l10n.studyHarmonyProgressStars(totalStars),
          ),
          if (legendaryChapters > 0)
            _HubMetricChipData(
              icon: Icons.workspace_premium_rounded,
              label: l10n.studyHarmonyProgressLegendCrowns(legendaryChapters),
            ),
          if (leagueProgress.score > 0)
            _HubMetricChipData(
              icon: Icons.emoji_events_rounded,
              label: l10n.studyHarmonyProgressLeague(
                _leagueTierLabel(l10n, leagueProgress.tier),
              ),
            ),
          if (leagueXpBoost.active)
            _HubMetricChipData(
              icon: Icons.flash_on_rounded,
              label: l10n.studyHarmonyProgressLeagueBoost(
                leagueXpBoost.chargeCount,
              ),
            ),
          if (duetPact.bestStreak > 0)
            _HubMetricChipData(
              icon: Icons.people_alt_rounded,
              label: l10n.studyHarmonyProgressDuetPact(duetPact.bestStreak),
            ),
          _HubMetricChipData(
            icon: Icons.map_rounded,
            label: monthlyTour.rewardClaimed
                ? l10n.studyHarmonyProgressTourClaimed
                : l10n.studyHarmonyProgressTour(
                    monthlyTour.completedGoalCount,
                    monthlyTour.totalGoalCount,
                  ),
          ),
          if (relayWins > 0)
            _HubMetricChipData(
              icon: Icons.alt_route_rounded,
              label: l10n.studyHarmonyProgressRelayWins(relayWins),
            ),
          if (questChestStatus.openedCount > 0)
            _HubMetricChipData(
              icon: Icons.inventory_2_rounded,
              label: l10n.studyHarmonyProgressQuestChests(
                questChestStatus.openedCount,
              ),
            ),
          if (dailyStreak > 0)
            _HubMetricChipData(
              icon: Icons.local_fire_department_rounded,
              label: l10n.studyHarmonyProgressStreak(dailyStreak),
            ),
          _HubMetricChipData(
            icon: Icons.school_rounded,
            label: l10n.studyHarmonyProgressSkillsMastered(
              masteredSkills,
              course.skillTags.length,
            ),
          ),
          _HubMetricChipData(
            icon: Icons.refresh_rounded,
            label: l10n.studyHarmonyProgressReviewsReady(dueReviews),
          ),
          if (streakSavers > 0)
            _HubMetricChipData(
              icon: Icons.shield_rounded,
              label: l10n.studyHarmonyProgressStreakSaver(streakSavers),
            ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.studyHarmonyTitle),
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
          body: DecoratedBox(
            key: const ValueKey('study-harmony-page'),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.06),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
                stops: const [0, 0.28, 1],
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
                              body: selectedTrackDescription,
                              metrics: heroMetrics,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              l10n.studyHarmonyTrackFilterLabel,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _TrackFilterBar(
                              key: const ValueKey('study-harmony-track-filter'),
                              selectedTrack: _selectedTrack,
                              options: [
                                _TrackFilterChipData(
                                  track: _StudyHarmonyHubTrack.core,
                                  label: l10n.studyHarmonyTrackCoreFilterLabel,
                                  icon: Icons.menu_book_rounded,
                                ),
                                _TrackFilterChipData(
                                  track: _StudyHarmonyHubTrack.pop,
                                  label: l10n.studyHarmonyTrackPopFilterLabel,
                                  icon: Icons.graphic_eq_rounded,
                                ),
                                _TrackFilterChipData(
                                  track: _StudyHarmonyHubTrack.jazz,
                                  label: l10n.studyHarmonyTrackJazzFilterLabel,
                                  icon: Icons.queue_music_rounded,
                                ),
                                _TrackFilterChipData(
                                  track: _StudyHarmonyHubTrack.classical,
                                  label: l10n
                                      .studyHarmonyTrackClassicalFilterLabel,
                                  icon: Icons.music_note_rounded,
                                ),
                              ],
                              onChanged: (track) {
                                setState(() {
                                  _selectedTrack = track;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            ...[
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-league-card',
                                      ),
                                      icon: Icons.emoji_events_rounded,
                                      title: l10n.studyHarmonyLeagueCardTitle,
                                      headline: _leagueTierLabel(
                                        l10n,
                                        leagueProgress.tier,
                                      ),
                                      supportingLabel: leagueProgress.maxTier
                                          ? l10n.studyHarmonyLeagueScoreLabel(
                                              leagueProgress.score,
                                            )
                                          : l10n.studyHarmonyLeagueProgressLabel(
                                              leagueProgress.score,
                                              leagueProgress.nextTarget!,
                                            ),
                                      body: _leagueHint(
                                        l10n,
                                        progress: leagueProgress,
                                        leagueXpBoost: leagueXpBoost,
                                        boostRecommendation:
                                            leagueBoostRecommendation,
                                      ),
                                      footerLabels: [
                                        if (leagueXpBoost.active)
                                          l10n.studyHarmonyLeagueBoostReadyLabel(
                                            leagueXpBoost.chargeCount,
                                          ),
                                        if (!leagueProgress.maxTier)
                                          l10n.studyHarmonyLeagueNextTierLabel(
                                            _leagueTierLabel(
                                              l10n,
                                              leagueProgress.nextTier!,
                                            ),
                                          ),
                                        if (leagueBoostRecommendation != null)
                                          l10n.studyHarmonyLeagueBoostLabel(
                                            _sessionModeLabel(
                                              l10n,
                                              leagueBoostRecommendation
                                                  .sessionMode,
                                            ),
                                          ),
                                      ],
                                      actionLabel:
                                          l10n.studyHarmonyLeagueAction,
                                      onPressed:
                                          leagueBoostRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              leagueBoostRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
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
                                      footerLabels:
                                          switch (continueRecommendation
                                              ?.source) {
                                            StudyHarmonyRecommendationSource
                                                .frontier =>
                                              <String>[
                                                l10n.studyHarmonyChapterNextUp(
                                                  continueRecommendation!
                                                      .lesson
                                                      .title,
                                                ),
                                              ],
                                            _ => const <String>[],
                                          },
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
                                        'study-harmony-tour-card',
                                      ),
                                      icon: Icons.map_rounded,
                                      title: l10n.studyHarmonyTourTitle,
                                      headline: _monthlyTourHeadline(
                                        l10n,
                                        monthlyTour,
                                      ),
                                      supportingLabel: l10n
                                          .studyHarmonyTourRewardLabel(
                                            monthlyTour.rewardLeagueXp,
                                            monthlyTour.rewardStreakSavers,
                                          ),
                                      body: _monthlyTourBody(l10n, monthlyTour),
                                      footerLabels: _monthlyTourFooterLabels(
                                        l10n,
                                        monthlyTour,
                                      ),
                                      actionLabel: l10n.studyHarmonyTourAction,
                                      onPressed:
                                          monthlyTourActionRecommendation ==
                                              null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              monthlyTourActionRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-relay-card',
                                      ),
                                      icon: Icons.alt_route_rounded,
                                      title: l10n.studyHarmonyRelayCardTitle,
                                      headline: relayRecommendation == null
                                          ? l10n.studyHarmonyRelayCardTitle
                                          : l10n.studyHarmonyRelayMixLabel(
                                              relayRecommendation
                                                  .resolvedSourceLessons
                                                  .length,
                                            ),
                                      supportingLabel:
                                          relayRecommendation == null
                                          ? course.title
                                          : l10n.studyHarmonyRelayChapterSpreadLabel(
                                              {
                                                for (final lesson
                                                    in relayRecommendation
                                                        .resolvedSourceLessons)
                                                  lesson.chapterId,
                                              }.length,
                                            ),
                                      body: _relayHint(
                                        l10n,
                                        relayRecommendation,
                                      ),
                                      footerLabels: relayRecommendation == null
                                          ? const <String>[]
                                          : <String>[
                                              relayRecommendation.chapter.title,
                                              l10n.studyHarmonyRelayChainLabel,
                                            ],
                                      actionLabel: l10n.studyHarmonyRelayAction,
                                      onPressed: relayRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              relayRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-legend-card',
                                      ),
                                      icon: Icons.workspace_premium_rounded,
                                      title: l10n.studyHarmonyLegendCardTitle,
                                      headline:
                                          legendRecommendation?.chapter.title ??
                                          l10n.studyHarmonyLegendCardTitle,
                                      supportingLabel:
                                          legendRecommendation?.lesson.title ??
                                          course.title,
                                      body: _legendHint(
                                        l10n,
                                        legendRecommendation,
                                      ),
                                      footerLabels: legendRecommendation == null
                                          ? const <String>[]
                                          : <String>[
                                              l10n.studyHarmonyLegendMixLabel(
                                                legendRecommendation
                                                    .resolvedSourceLessons
                                                    .length,
                                              ),
                                              l10n.studyHarmonyLegendRiskLabel,
                                            ],
                                      actionLabel:
                                          l10n.studyHarmonyLegendAction,
                                      onPressed: legendRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              legendRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-boss-rush-card',
                                      ),
                                      icon: Icons.whatshot_rounded,
                                      title: l10n.studyHarmonyBossRushCardTitle,
                                      headline:
                                          bossRushRecommendation
                                              ?.lesson
                                              .title ??
                                          l10n.studyHarmonyBossRushCardTitle,
                                      supportingLabel:
                                          bossRushRecommendation
                                              ?.chapter
                                              .title ??
                                          course.title,
                                      body: _bossRushHint(
                                        l10n,
                                        bossRushRecommendation,
                                      ),
                                      footerLabels:
                                          bossRushRecommendation == null
                                          ? const <String>[]
                                          : <String>[
                                              l10n.studyHarmonyBossRushMixLabel(
                                                bossRushRecommendation
                                                    .resolvedSourceLessons
                                                    .length,
                                              ),
                                              l10n.studyHarmonyBossRushHighRiskLabel,
                                            ],
                                      actionLabel:
                                          l10n.studyHarmonyBossRushAction,
                                      onPressed: bossRushRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              bossRushRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-focus-card',
                                      ),
                                      icon: Icons.bolt_rounded,
                                      title: l10n.studyHarmonyFocusCardTitle,
                                      headline:
                                          focusRecommendation?.lesson.title ??
                                          l10n.studyHarmonyFocusCardTitle,
                                      supportingLabel:
                                          focusRecommendation?.chapter.title ??
                                          course.title,
                                      body: _focusHint(
                                        l10n,
                                        focusRecommendation,
                                      ),
                                      footerLabels: focusRecommendation == null
                                          ? const <String>[]
                                          : <String>[
                                              l10n.studyHarmonyFocusMixLabel(
                                                focusRecommendation
                                                    .resolvedSourceLessons
                                                    .length,
                                              ),
                                              if (streakSavers < 2)
                                                l10n.studyHarmonyFocusRewardLabel,
                                            ],
                                      actionLabel: l10n.studyHarmonyFocusAction,
                                      onPressed: focusRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              focusRecommendation,
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
                                      footerLabels: reviewFooter == null
                                          ? const <String>[]
                                          : <String>[reviewFooter],
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
                                      body: dailyCompletedToday
                                          ? l10n.studyHarmonyDailyCardHintCompleted
                                          : l10n.studyHarmonyDailyCardHint,
                                      footerLabels: [
                                        if (dailyRecommendation?.dailyDateKey
                                            case final dailyDateKey?)
                                          l10n.studyHarmonyDailyDateBadge(
                                            dailyDateKey,
                                          ),
                                        if (dailyStreak > 0)
                                          l10n.studyHarmonyProgressStreak(
                                            dailyStreak,
                                          ),
                                        if (dailyCompletedToday)
                                          l10n.studyHarmonyDailyClearedTodayTag,
                                      ],
                                      actionLabel: dailyCompletedToday
                                          ? l10n.studyHarmonyDailyReplayAction
                                          : l10n.studyHarmonyDailyAction,
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
                                l10n.studyHarmonyQuestBoardTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  for (final questCard in questCards)
                                    SizedBox(
                                      width: actionWidth,
                                      child: _HubQuestCard(data: questCard),
                                    ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-duet-card',
                                      ),
                                      icon: Icons.people_alt_rounded,
                                      title: l10n.studyHarmonyDuetTitle,
                                      headline: _duetPactHeadline(
                                        l10n,
                                        duetPact,
                                      ),
                                      supportingLabel: l10n
                                          .studyHarmonyDuetRewardLabel(
                                            duetPact.rewardLeagueXp,
                                          ),
                                      body: _duetPactBody(
                                        l10n,
                                        duetPact,
                                        dailyCompletedToday:
                                            dailyCompletedToday,
                                      ),
                                      footerLabels: [
                                        dailyCompletedToday
                                            ? l10n.studyHarmonyDuetDailyDone
                                            : l10n.studyHarmonyDuetDailyMissing,
                                        duetPact.activeToday
                                            ? l10n.studyHarmonyDuetSpotlightDone
                                            : l10n.studyHarmonyDuetSpotlightMissing,
                                        l10n.studyHarmonyDuetTargetLabel(
                                          duetPact.currentStreak,
                                          duetPact.nextTarget,
                                        ),
                                      ],
                                      actionLabel: l10n.studyHarmonyDuetAction,
                                      onPressed: duetPactRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              duetPactRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: const ValueKey(
                                        'study-harmony-quest-chest-card',
                                      ),
                                      icon: Icons.inventory_2_rounded,
                                      title: l10n.studyHarmonyQuestChestTitle,
                                      headline: _questChestHeadline(
                                        l10n,
                                        questChestStatus,
                                        leagueXpBoost,
                                      ),
                                      supportingLabel: l10n
                                          .studyHarmonyQuestChestRewardLabel(
                                            questChestStatus.rewardLeagueXp,
                                          ),
                                      body: _questChestBody(
                                        l10n,
                                        questChestStatus,
                                        leagueXpBoost,
                                      ),
                                      footerLabels: [
                                        l10n.studyHarmonyQuestChestProgressLabel(
                                          questChestStatus.openedToday
                                              ? questChestStatus.totalQuestCount
                                              : questChestStatus
                                                    .completedQuestCount,
                                          questChestStatus.totalQuestCount,
                                        ),
                                        if (leagueXpBoost.active)
                                          l10n.studyHarmonyQuestChestBoostReadyLabel(
                                            leagueXpBoost.chargeCount,
                                          ),
                                        if (!questChestStatus.openedToday &&
                                            questChestActionRecommendation !=
                                                null)
                                          l10n.studyHarmonyQuestChestBoostLabel(
                                            _sessionModeLabel(
                                              l10n,
                                              questChestActionRecommendation
                                                  .sessionMode,
                                            ),
                                          ),
                                      ],
                                      actionLabel:
                                          questChestStatus.openedToday ||
                                              questChestStatus.ready
                                          ? l10n.studyHarmonyContinueAction
                                          : l10n.studyHarmonyQuestChestAction,
                                      onPressed:
                                          questChestActionRecommendation == null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              questChestActionRecommendation,
                                              course,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Text(
                                l10n.studyHarmonyWeeklyPlanTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  for (final weeklyGoal in weeklyGoals)
                                    SizedBox(
                                      width: actionWidth,
                                      child: _HubWeeklyGoalCard(
                                        data: _weeklyGoalCardData(
                                          l10n: l10n,
                                          weeklyGoal: weeklyGoal,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Text(
                                l10n.studyHarmonyMilestoneCabinetTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  for (final milestoneCard in milestoneCards)
                                    SizedBox(
                                      width: actionWidth,
                                      child: _HubMilestoneCard(
                                        data: milestoneCard,
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
                                        rewardLabel: summary.starCount > 0
                                            ? l10n.studyHarmonyProgressStars(
                                                summary.starCount,
                                              )
                                            : null,
                                        masteryTier: summary.masteryTier,
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
      StudyHarmonySessionMode.focus => l10n.studyHarmonyFocusSessionTitle,
      StudyHarmonySessionMode.relay => l10n.studyHarmonyRelaySessionTitle,
      StudyHarmonySessionMode.bossRush => l10n.studyHarmonyBossRushSessionTitle,
      StudyHarmonySessionMode.legend => l10n.studyHarmonyLegendSessionTitle,
      StudyHarmonySessionMode.lesson => recommendation.lesson.title,
      StudyHarmonySessionMode.legacyLevel => recommendation.lesson.title,
    },
    description: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review =>
        l10n.studyHarmonyReviewSessionDescription(recommendation.chapter.title),
      StudyHarmonySessionMode.daily => l10n.studyHarmonyDailySessionDescription(
        recommendation.chapter.title,
      ),
      StudyHarmonySessionMode.focus => l10n.studyHarmonyFocusSessionDescription(
        recommendation.chapter.title,
      ),
      StudyHarmonySessionMode.relay => l10n.studyHarmonyRelaySessionDescription(
        recommendation.chapter.title,
      ),
      StudyHarmonySessionMode.bossRush =>
        l10n.studyHarmonyBossRushSessionDescription(
          recommendation.chapter.title,
        ),
      StudyHarmonySessionMode.legend =>
        l10n.studyHarmonyLegendSessionDescription(recommendation.chapter.title),
      StudyHarmonySessionMode.lesson => recommendation.lesson.description,
      StudyHarmonySessionMode.legacyLevel => recommendation.lesson.description,
    },
    objectiveLabel: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => l10n.studyHarmonyModeReview,
      StudyHarmonySessionMode.daily => l10n.studyHarmonyModeDaily,
      StudyHarmonySessionMode.focus => l10n.studyHarmonyModeFocus,
      StudyHarmonySessionMode.relay => l10n.studyHarmonyModeRelay,
      StudyHarmonySessionMode.bossRush => l10n.studyHarmonyModeBossRush,
      StudyHarmonySessionMode.legend => l10n.studyHarmonyModeLegend,
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
      StudyHarmonySessionMode.focus => max(
        7,
        min(10, max(3, sourceLessons.length) * 2),
      ),
      StudyHarmonySessionMode.relay => max(
        8,
        min(11, max(3, sourceLessons.length) * 2),
      ),
      StudyHarmonySessionMode.bossRush => max(
        8,
        min(11, max(3, sourceLessons.length) * 3),
      ),
      StudyHarmonySessionMode.legend => max(
        9,
        min(12, max(3, sourceLessons.length) * 2),
      ),
      StudyHarmonySessionMode.lesson =>
        recommendation.lesson.goalCorrectAnswers,
      StudyHarmonySessionMode.legacyLevel =>
        recommendation.lesson.goalCorrectAnswers,
    },
    startingLives: switch (recommendation.sessionMode) {
      StudyHarmonySessionMode.review => 3,
      StudyHarmonySessionMode.daily => 4,
      StudyHarmonySessionMode.focus => 2,
      StudyHarmonySessionMode.relay => 3,
      StudyHarmonySessionMode.bossRush => 2,
      StudyHarmonySessionMode.legend => 2,
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

class _HubMetricChipData {
  const _HubMetricChipData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _HubQuestCardData {
  const _HubQuestCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _HubMilestoneCardData {
  const _HubMilestoneCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _HubWeeklyGoalCardData {
  const _HubWeeklyGoalCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _TrackFilterChipData {
  const _TrackFilterChipData({
    required this.track,
    required this.label,
    required this.icon,
  });

  final _StudyHarmonyHubTrack track;
  final String label;
  final IconData icon;
}

class _HubIconBadge extends StatelessWidget {
  const _HubIconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox.square(
        dimension: 44,
        child: Icon(icon, color: colorScheme.primary),
      ),
    );
  }
}

class _TrackFilterBar extends StatelessWidget {
  const _TrackFilterBar({
    super.key,
    required this.selectedTrack,
    required this.options,
    required this.onChanged,
  });

  final _StudyHarmonyHubTrack selectedTrack;
  final List<_TrackFilterChipData> options;
  final ValueChanged<_StudyHarmonyHubTrack> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: _hubPanelDecoration(colorScheme),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final option in options)
              Builder(
                builder: (context) {
                  final isSelected = option.track == selectedTrack;
                  return ChoiceChip(
                    key: ValueKey(
                      'study-harmony-track-filter-${option.track.name}',
                    ),
                    selected: isSelected,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    selectedColor: colorScheme.primaryContainer,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.18)
                          : colorScheme.outlineVariant,
                    ),
                    avatar: Icon(
                      option.icon,
                      size: 18,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    label: Text(option.label),
                    onSelected: (_) => onChanged(option.track),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _HubHeroCard extends StatelessWidget {
  const _HubHeroCard({
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    required this.body,
    required this.metrics,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final String body;
  final List<_HubMetricChipData> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      child: Card(
        key: const ValueKey('study-harmony-hero-card'),
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
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
              DecoratedBox(
                decoration: _hubPanelDecoration(colorScheme, accent: true),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    body,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final metric in metrics)
                    Chip(
                      avatar: Icon(metric.icon, size: 18),
                      label: Text(metric.label),
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
    this.footerLabels = const <String>[],
  });

  final IconData icon;
  final String title;
  final String headline;
  final String supportingLabel;
  final String body;
  final String actionLabel;
  final VoidCallback? onPressed;
  final List<String> footerLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MergeSemantics(
      child: Card(
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HubIconBadge(icon: icon),
              const SizedBox(height: 14),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
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
                  color: colorScheme.onSurfaceVariant,
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
              if (footerLabels.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final footer in footerLabels)
                      Chip(label: Text(footer)),
                  ],
                ),
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
      ),
    );
  }
}

class _HubQuestCard extends StatelessWidget {
  const _HubQuestCard({required this.data});

  final _HubQuestCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-quest-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 14),
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: data.progressFraction,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(label: Text(badge)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HubMilestoneCard extends StatelessWidget {
  const _HubMilestoneCard({required this.data});

  final _HubMilestoneCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-milestone-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 14),
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(label: Text(badge)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HubWeeklyGoalCard extends StatelessWidget {
  const _HubWeeklyGoalCard({required this.data});

  final _HubWeeklyGoalCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-weekly-goal-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 14),
            Text(
              data.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(label: Text(badge)),
                ],
              ),
            ],
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
    required this.masteryTier,
    required this.lockedLabel,
    required this.actionLabel,
    required this.onOpen,
    this.rewardLabel,
    this.nextLessonLabel,
  });

  final StudyHarmonyChapterProgressSummaryView summary;
  final String progressLabel;
  final String lessonCountLabel;
  final String completedCountLabel;
  final StudyHarmonyChapterMasteryTier masteryTier;
  final String lockedLabel;
  final String actionLabel;
  final String? rewardLabel;
  final String? nextLessonLabel;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return MergeSemantics(
      child: Card(
        key: ValueKey('study-harmony-chapter-card-${summary.chapter.id}'),
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
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
                  if (masteryTier != StudyHarmonyChapterMasteryTier.none)
                    Chip(
                      avatar: Icon(_chapterMasteryIcon(masteryTier), size: 18),
                      label: Text(_chapterMasteryLabel(l10n, masteryTier)),
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
              Semantics(
                label: progressLabel,
                child: ExcludeSemantics(
                  child: ClipRRect(
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
                  if (rewardLabel case final reward?) Chip(label: Text(reward)),
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
                child: FilledButton.icon(
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
      ),
    );
  }
}

class _ChapterLessonTile extends StatelessWidget {
  const _ChapterLessonTile({
    required this.lesson,
    required this.lessonResult,
    required this.unlocked,
    required this.cleared,
    required this.onOpen,
  });

  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonyLessonProgressSummary? lessonResult;
  final bool unlocked;
  final bool cleared;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: _hubPanelDecoration(colorScheme, radius: 20),
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
                  if (_isBossLesson(lesson))
                    Chip(label: Text(l10n.studyHarmonyBossTag)),
                  if (cleared) Chip(label: Text(l10n.studyHarmonyClearedTag)),
                  if (!unlocked)
                    Chip(label: Text(l10n.studyHarmonyLockedLessonAction)),
                  if (lessonResult case final result?)
                    if (result.bestStars > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressStars(result.bestStars),
                        ),
                      ),
                  if (lessonResult case final result?)
                    if (result.playCount > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressRuns(result.playCount),
                        ),
                      ),
                  if (lessonResult case final result?)
                    if (result.playCount > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressBestRank(result.bestRank),
                        ),
                      ),
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
      ),
    );
  }
}

String _trackDescription({
  required AppLocalizations l10n,
  required StudyHarmonyCourseDefinition course,
  required _StudyHarmonyHubTrack track,
}) {
  if (track == _StudyHarmonyHubTrack.core) {
    return l10n.studyHarmonyHubHeroBody;
  }
  return course.description;
}

_HubQuestCardData _questCardData({
  required AppLocalizations l10n,
  required StudyHarmonyQuestProgressView quest,
}) {
  return switch (quest.kind) {
    StudyHarmonyQuestKind.dailyStreak => _HubQuestCardData(
      id: quest.kind.name,
      icon: Icons.local_fire_department_rounded,
      title: l10n.studyHarmonyQuestDailyTitle,
      body: quest.completedToday
          ? l10n.studyHarmonyQuestDailyBodyCompleted
          : l10n.studyHarmonyQuestDailyBody,
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        quest.current,
        quest.target,
      ),
      progressFraction: quest.progressFraction,
      badgeLabels: [
        if (quest.current > 0) l10n.studyHarmonyProgressStreak(quest.current),
        if (quest.completedToday) l10n.studyHarmonyQuestTodayTag,
      ],
    ),
    StudyHarmonyQuestKind.frontierLesson => _HubQuestCardData(
      id: quest.kind.name,
      icon: Icons.rocket_launch_rounded,
      title: l10n.studyHarmonyQuestFrontierTitle,
      body: quest.completedToday
          ? l10n.studyHarmonyQuestFrontierBodyCompleted
          : quest.lesson == null
          ? l10n.studyHarmonyQuestFrontierBodyCompleted
          : l10n.studyHarmonyQuestFrontierBody(quest.lesson!.title),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        quest.current,
        quest.target,
      ),
      progressFraction: quest.progressFraction,
      badgeLabels: [
        if (quest.chapter case final chapter?) chapter.title,
        if (quest.completedToday) l10n.studyHarmonyQuestTodayTag,
      ],
    ),
    StudyHarmonyQuestKind.chapterStars => _HubQuestCardData(
      id: quest.kind.name,
      icon: Icons.stars_rounded,
      title: l10n.studyHarmonyQuestStarsTitle,
      body: quest.chapter == null
          ? l10n.studyHarmonyQuestStarsBodyFallback
          : l10n.studyHarmonyQuestStarsBody(quest.chapter!.title),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        quest.current,
        quest.target,
      ),
      progressFraction: quest.progressFraction,
      badgeLabels: [
        if (quest.chapter case final chapter?) chapter.title,
        if (quest.completed) l10n.studyHarmonyQuestCompletedTag,
      ],
    ),
  };
}

_HubMilestoneCardData _milestoneCardData({
  required AppLocalizations l10n,
  required StudyHarmonyMilestoneProgressView milestone,
}) {
  final nextTier = milestone.completedAll
      ? milestone.totalTiers
      : milestone.earnedCount + 1;

  return switch (milestone.kind) {
    StudyHarmonyMilestoneKind.lessonPath => _HubMilestoneCardData(
      id: milestone.id,
      icon: Icons.route_rounded,
      title: l10n.studyHarmonyMilestoneLessonsTitle,
      body: l10n.studyHarmonyMilestoneLessonsBody(milestone.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        milestone.current,
        milestone.target,
      ),
      progressFraction: milestone.progressFraction,
      badgeLabels: [
        _milestoneTierLabel(l10n, nextTier),
        l10n.studyHarmonyMilestoneEarnedLabel(
          milestone.earnedCount,
          milestone.totalTiers,
        ),
        if (milestone.completedAll) l10n.studyHarmonyMilestoneCompletedTag,
      ],
    ),
    StudyHarmonyMilestoneKind.starCollector => _HubMilestoneCardData(
      id: milestone.id,
      icon: Icons.workspace_premium_rounded,
      title: l10n.studyHarmonyMilestoneStarsTitle,
      body: l10n.studyHarmonyMilestoneStarsBody(milestone.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        milestone.current,
        milestone.target,
      ),
      progressFraction: milestone.progressFraction,
      badgeLabels: [
        _milestoneTierLabel(l10n, nextTier),
        l10n.studyHarmonyMilestoneEarnedLabel(
          milestone.earnedCount,
          milestone.totalTiers,
        ),
        if (milestone.completedAll) l10n.studyHarmonyMilestoneCompletedTag,
      ],
    ),
    StudyHarmonyMilestoneKind.streakLegend => _HubMilestoneCardData(
      id: milestone.id,
      icon: Icons.local_fire_department_rounded,
      title: l10n.studyHarmonyMilestoneStreakTitle,
      body: l10n.studyHarmonyMilestoneStreakBody(milestone.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        milestone.current,
        milestone.target,
      ),
      progressFraction: milestone.progressFraction,
      badgeLabels: [
        _milestoneTierLabel(l10n, nextTier),
        l10n.studyHarmonyMilestoneEarnedLabel(
          milestone.earnedCount,
          milestone.totalTiers,
        ),
        if (milestone.completedAll) l10n.studyHarmonyMilestoneCompletedTag,
      ],
    ),
    StudyHarmonyMilestoneKind.masteryScholar => _HubMilestoneCardData(
      id: milestone.id,
      icon: Icons.school_rounded,
      title: l10n.studyHarmonyMilestoneMasteryTitle,
      body: l10n.studyHarmonyMilestoneMasteryBody(milestone.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        milestone.current,
        milestone.target,
      ),
      progressFraction: milestone.progressFraction,
      badgeLabels: [
        _milestoneTierLabel(l10n, nextTier),
        l10n.studyHarmonyMilestoneEarnedLabel(
          milestone.earnedCount,
          milestone.totalTiers,
        ),
        if (milestone.completedAll) l10n.studyHarmonyMilestoneCompletedTag,
      ],
    ),
    StudyHarmonyMilestoneKind.relayRunner => _HubMilestoneCardData(
      id: milestone.id,
      icon: Icons.alt_route_rounded,
      title: l10n.studyHarmonyMilestoneRelayTitle,
      body: l10n.studyHarmonyMilestoneRelayBody(milestone.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        milestone.current,
        milestone.target,
      ),
      progressFraction: milestone.progressFraction,
      badgeLabels: [
        _milestoneTierLabel(l10n, nextTier),
        l10n.studyHarmonyMilestoneEarnedLabel(
          milestone.earnedCount,
          milestone.totalTiers,
        ),
        if (milestone.completedAll) l10n.studyHarmonyMilestoneCompletedTag,
      ],
    ),
  };
}

_HubWeeklyGoalCardData _weeklyGoalCardData({
  required AppLocalizations l10n,
  required StudyHarmonyWeeklyGoalProgressView weeklyGoal,
}) {
  final badgeLabels = <String>[
    if (weeklyGoal.rewardReady) l10n.studyHarmonyWeeklyRewardReadyTag,
    if (weeklyGoal.rewardClaimed) l10n.studyHarmonyWeeklyRewardClaimedTag,
    l10n.studyHarmonyWeeklyRewardLabel,
  ];

  return switch (weeklyGoal.kind) {
    StudyHarmonyWeeklyGoalKind.activeDays => _HubWeeklyGoalCardData(
      id: weeklyGoal.kind.name,
      icon: Icons.event_available_rounded,
      title: l10n.studyHarmonyWeeklyGoalActiveDaysTitle,
      body: l10n.studyHarmonyWeeklyGoalActiveDaysBody(weeklyGoal.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        weeklyGoal.current,
        weeklyGoal.target,
      ),
      progressFraction: weeklyGoal.progressFraction,
      badgeLabels: badgeLabels,
    ),
    StudyHarmonyWeeklyGoalKind.dailyClears => _HubWeeklyGoalCardData(
      id: weeklyGoal.kind.name,
      icon: Icons.wb_sunny_rounded,
      title: l10n.studyHarmonyWeeklyGoalDailyTitle,
      body: l10n.studyHarmonyWeeklyGoalDailyBody(weeklyGoal.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        weeklyGoal.current,
        weeklyGoal.target,
      ),
      progressFraction: weeklyGoal.progressFraction,
      badgeLabels: badgeLabels,
    ),
    StudyHarmonyWeeklyGoalKind.focusSprint => _HubWeeklyGoalCardData(
      id: weeklyGoal.kind.name,
      icon: Icons.bolt_rounded,
      title: l10n.studyHarmonyWeeklyGoalFocusTitle,
      body: l10n.studyHarmonyWeeklyGoalFocusBody(weeklyGoal.target),
      progressLabel: l10n.studyHarmonyQuestProgressLabel(
        weeklyGoal.current,
        weeklyGoal.target,
      ),
      progressFraction: weeklyGoal.progressFraction,
      badgeLabels: badgeLabels,
    ),
  };
}

String _milestoneTierLabel(AppLocalizations l10n, int tier) {
  return switch (tier) {
    1 => l10n.studyHarmonyMilestoneTierBronze,
    2 => l10n.studyHarmonyMilestoneTierSilver,
    3 => l10n.studyHarmonyMilestoneTierGold,
    _ => l10n.studyHarmonyMilestoneTierPlatinum,
  };
}

bool _isBossLesson(StudyHarmonyLessonDefinition lesson) {
  return lesson.goalCorrectAnswers >= 9 || lesson.startingLives >= 4;
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

String _focusHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyFocusCardHint;
  }
  if (recommendation.focusSkillTags.isNotEmpty) {
    return l10n.studyHarmonyFocusCardHint;
  }
  return l10n.studyHarmonyFocusFallbackHint;
}

String _duetPactHeadline(
  AppLocalizations l10n,
  StudyHarmonyDuetPactProgressView duetPact,
) {
  if (duetPact.activeToday) {
    return l10n.studyHarmonyDuetReadyHeadline(duetPact.currentStreak);
  }
  if (duetPact.currentStreak > 0) {
    return l10n.studyHarmonyDuetInProgressHeadline(duetPact.currentStreak);
  }
  return l10n.studyHarmonyDuetStartHeadline;
}

String _duetPactBody(
  AppLocalizations l10n,
  StudyHarmonyDuetPactProgressView duetPact, {
  required bool dailyCompletedToday,
}) {
  if (duetPact.activeToday) {
    return l10n.studyHarmonyDuetActiveBody(duetPact.currentStreak);
  }
  if (!dailyCompletedToday) {
    return l10n.studyHarmonyDuetNeedDailyBody;
  }
  return l10n.studyHarmonyDuetNeedSpotlightBody;
}

String _monthlyTourHeadline(
  AppLocalizations l10n,
  StudyHarmonyMonthlyTourProgressView monthlyTour,
) {
  if (monthlyTour.rewardReady) {
    return l10n.studyHarmonyTourReadyHeadline;
  }
  if (monthlyTour.rewardClaimed) {
    return l10n.studyHarmonyTourClaimedHeadline;
  }
  return l10n.studyHarmonyTourProgressHeadline(
    monthlyTour.completedGoalCount,
    monthlyTour.totalGoalCount,
  );
}

String _monthlyTourBody(
  AppLocalizations l10n,
  StudyHarmonyMonthlyTourProgressView monthlyTour,
) {
  if (monthlyTour.rewardReady) {
    return l10n.studyHarmonyTourReadyBody;
  }
  if (monthlyTour.rewardClaimed) {
    return l10n.studyHarmonyTourClaimedBody;
  }
  final nextGoal = monthlyTour.goals.firstWhere(
    (goal) => !goal.completed,
    orElse: () => monthlyTour.goals.first,
  );
  return switch (nextGoal.kind) {
    StudyHarmonyMonthlyGoalKind.activeDays =>
      l10n.studyHarmonyTourActiveDaysBody(nextGoal.target),
    StudyHarmonyMonthlyGoalKind.questChests =>
      l10n.studyHarmonyTourQuestChestBody(nextGoal.target),
    StudyHarmonyMonthlyGoalKind.spotlightClears =>
      l10n.studyHarmonyTourSpotlightBody(nextGoal.target),
  };
}

String _monthlyTourGoalLabel(
  AppLocalizations l10n,
  StudyHarmonyMonthlyGoalProgressView goal,
) {
  return switch (goal.kind) {
    StudyHarmonyMonthlyGoalKind.activeDays =>
      l10n.studyHarmonyTourActiveDaysLabel(goal.current, goal.target),
    StudyHarmonyMonthlyGoalKind.questChests =>
      l10n.studyHarmonyTourQuestChestsLabel(goal.current, goal.target),
    StudyHarmonyMonthlyGoalKind.spotlightClears =>
      l10n.studyHarmonyTourSpotlightLabel(goal.current, goal.target),
  };
}

List<String> _monthlyTourFooterLabels(
  AppLocalizations l10n,
  StudyHarmonyMonthlyTourProgressView monthlyTour,
) {
  if (monthlyTour.rewardClaimed) {
    return <String>[l10n.studyHarmonyProgressTourClaimed];
  }
  final labels = <String>[
    l10n.studyHarmonyTourRewardLabel(
      monthlyTour.rewardLeagueXp,
      monthlyTour.rewardStreakSavers,
    ),
  ];
  final pendingGoal = monthlyTour.goals.firstWhere(
    (goal) => !goal.completed,
    orElse: () => monthlyTour.goals.first,
  );
  labels.add(_monthlyTourGoalLabel(l10n, pendingGoal));
  if (monthlyTour.rewardReady) {
    labels.add(l10n.studyHarmonyTourReadyHeadline);
  }
  return labels;
}

String _questChestHeadline(
  AppLocalizations l10n,
  StudyHarmonyQuestChestProgressView questChestStatus,
  StudyHarmonyLeagueXpBoostProgressView leagueXpBoost,
) {
  if (questChestStatus.openedToday) {
    if (leagueXpBoost.active) {
      return l10n.studyHarmonyQuestChestBoostHeadline;
    }
    return l10n.studyHarmonyQuestChestOpenedHeadline;
  }
  if (questChestStatus.ready) {
    return l10n.studyHarmonyQuestChestReadyHeadline;
  }
  return l10n.studyHarmonyQuestChestLockedHeadline(
    questChestStatus.remainingQuestCount,
  );
}

String _questChestBody(
  AppLocalizations l10n,
  StudyHarmonyQuestChestProgressView questChestStatus,
  StudyHarmonyLeagueXpBoostProgressView leagueXpBoost,
) {
  if (questChestStatus.openedToday) {
    if (leagueXpBoost.active) {
      return l10n.studyHarmonyQuestChestOpenedBoostBody(
        leagueXpBoost.chargeCount,
      );
    }
    return l10n.studyHarmonyQuestChestOpenedBody;
  }
  if (questChestStatus.ready) {
    return l10n.studyHarmonyQuestChestReadyBody;
  }
  return l10n.studyHarmonyQuestChestLockedBody;
}

String _leagueHint(
  AppLocalizations l10n, {
  required StudyHarmonyLeagueProgressView progress,
  required StudyHarmonyLeagueXpBoostProgressView leagueXpBoost,
  required StudyHarmonyLessonRecommendation? boostRecommendation,
}) {
  if (leagueXpBoost.active && boostRecommendation != null) {
    return l10n.studyHarmonyLeagueCardHintBoosted(
      leagueXpBoost.chargeCount,
      _sessionModeLabel(l10n, boostRecommendation.sessionMode),
    );
  }
  if (progress.maxTier) {
    return l10n.studyHarmonyLeagueCardHintMax;
  }
  if (boostRecommendation == null) {
    return l10n.studyHarmonyLeagueFallbackHint;
  }
  return l10n.studyHarmonyLeagueCardHint(
    _leagueTierLabel(l10n, progress.nextTier!),
    _sessionModeLabel(l10n, boostRecommendation.sessionMode),
  );
}

String _relayHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyRelayFallbackHint;
  }
  return l10n.studyHarmonyRelayCardHint;
}

String _legendHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyLegendFallbackHint;
  }
  return l10n.studyHarmonyLegendCardHint;
}

String _bossRushHint(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation? recommendation,
) {
  if (recommendation == null) {
    return l10n.studyHarmonyBossRushFallbackHint;
  }
  return l10n.studyHarmonyBossRushCardHint;
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

String _sessionModeLabel(AppLocalizations l10n, StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.review => l10n.studyHarmonyModeReview,
    StudyHarmonySessionMode.daily => l10n.studyHarmonyModeDaily,
    StudyHarmonySessionMode.focus => l10n.studyHarmonyModeFocus,
    StudyHarmonySessionMode.relay => l10n.studyHarmonyModeRelay,
    StudyHarmonySessionMode.bossRush => l10n.studyHarmonyModeBossRush,
    StudyHarmonySessionMode.legend => l10n.studyHarmonyModeLegend,
    StudyHarmonySessionMode.lesson => l10n.studyHarmonyOpenLessonAction,
    StudyHarmonySessionMode.legacyLevel => l10n.studyHarmonyOpenLessonAction,
  };
}

String _chapterMasteryLabel(
  AppLocalizations l10n,
  StudyHarmonyChapterMasteryTier tier,
) {
  return switch (tier) {
    StudyHarmonyChapterMasteryTier.none => '',
    StudyHarmonyChapterMasteryTier.bronze =>
      l10n.studyHarmonyChapterMasteryBronze,
    StudyHarmonyChapterMasteryTier.silver =>
      l10n.studyHarmonyChapterMasterySilver,
    StudyHarmonyChapterMasteryTier.gold => l10n.studyHarmonyChapterMasteryGold,
    StudyHarmonyChapterMasteryTier.legendary =>
      l10n.studyHarmonyChapterMasteryLegendary,
  };
}

IconData _chapterMasteryIcon(StudyHarmonyChapterMasteryTier tier) {
  return switch (tier) {
    StudyHarmonyChapterMasteryTier.none => Icons.radio_button_unchecked_rounded,
    StudyHarmonyChapterMasteryTier.bronze => Icons.verified_rounded,
    StudyHarmonyChapterMasteryTier.silver => Icons.military_tech_rounded,
    StudyHarmonyChapterMasteryTier.gold => Icons.workspace_premium_rounded,
    StudyHarmonyChapterMasteryTier.legendary => Icons.auto_awesome_rounded,
  };
}
