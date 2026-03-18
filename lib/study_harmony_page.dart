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
import 'study_harmony/meta/study_harmony_arcade_catalog.dart';
import 'study_harmony/meta/study_harmony_arcade_runtime.dart';
import 'study_harmony/meta/study_harmony_difficulty_design.dart';
import 'study_harmony/meta/study_harmony_personalization.dart';
import 'study_harmony/meta/study_harmony_rewards_catalog.dart';
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

class _HubRecommendationCopy {
  const _HubRecommendationCopy({
    required this.icon,
    required this.title,
    required this.headline,
    required this.supportingLabel,
    required this.body,
    required this.actionLabel,
    required this.footerLabels,
  });

  final IconData icon;
  final String title;
  final String headline;
  final String supportingLabel;
  final String body;
  final String actionLabel;
  final List<String> footerLabels;
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

  void _openArcadeMode(
    BuildContext context,
    AppLocalizations l10n, {
    required StudyHarmonyArcadeModeDefinition mode,
    required StudyHarmonyLessonRecommendation recommendation,
    required StudyHarmonyCourseDefinition course,
  }) {
    final sessionLesson = _buildSessionLesson(
      l10n: l10n,
      recommendation: recommendation,
      arcadeModeId: mode.id,
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

  Future<void> _purchaseShopItem(
    BuildContext context,
    StudyHarmonyShopItemDefinition item,
  ) async {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final messenger = ScaffoldMessenger.of(context);
    final success = await widget.progressController.purchaseShopItem(item);
    final equippedUnlockId = success
        ? await _autoEquipPurchasedUnlock(item)
        : null;
    if (!mounted) {
      return;
    }
    final snackBar = SnackBar(
      content: Text(
        success
            ? (_isKoreanLocale(localeTag)
                  ? equippedUnlockId == null
                        ? '${item.title} 援щℓ ?꾨즺'
                        : '${item.title} 援щℓ + ?옣李? ?꾨즺'
                  : equippedUnlockId == null
                  ? 'Purchased ${item.title}'
                  : 'Purchased and equipped ${item.title}')
            : (_isKoreanLocale(localeTag)
                  ? '${item.title} 援щℓ 議곌굔??遺議깊빀?덈떎'
                  : 'Cannot purchase ${item.title} yet'),
      ),
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<String?> _autoEquipPurchasedUnlock(
    StudyHarmonyShopItemDefinition item,
  ) async {
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyTitlesById.containsKey(unlockId)) {
        final equipped = await widget.progressController.equipTitle(unlockId);
        if (equipped) {
          return unlockId;
        }
      }
      if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
        final equipped = await widget.progressController.equipCosmetic(
          unlockId,
        );
        if (equipped) {
          return unlockId;
        }
      }
    }
    return null;
  }

  Future<void> _equipOwnedReward(BuildContext context, String unlockId) async {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final messenger = ScaffoldMessenger.of(context);
    var equipped = false;
    if (studyHarmonyTitlesById.containsKey(unlockId)) {
      equipped = await widget.progressController.equipTitle(unlockId);
    } else if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
      equipped = await widget.progressController.equipCosmetic(unlockId);
    }
    if (!mounted || !equipped) {
      return;
    }
    final rewardTitle =
        studyHarmonyTitlesById[unlockId]?.title ??
        studyHarmonyCosmeticsById[unlockId]?.title ??
        unlockId;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isKoreanLocale(localeTag)
                ? '$rewardTitle ?옣李? ?꾨즺'
                : 'Equipped $rewardTitle',
          ),
        ),
      );
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
        final primaryRecommendation = _primaryStudyHarmonyRecommendation(
          continueRecommendation,
          reviewRecommendation,
          focusRecommendation,
          dailyRecommendation,
          monthlyTourActionRecommendation,
          questChestActionRecommendation,
          duetPactRecommendation,
          leagueBoostRecommendation,
          relayRecommendation,
          legendRecommendation,
          bossRushRecommendation,
        );
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
          if (dueReviews > 0)
            _HubMetricChipData(
              icon: Icons.refresh_rounded,
              label: l10n.studyHarmonyProgressReviewsReady(dueReviews),
            ),
          if (dailyStreak > 0)
            _HubMetricChipData(
              icon: Icons.local_fire_department_rounded,
              label: l10n.studyHarmonyProgressStreak(dailyStreak),
            ),
          if (leagueProgress.score > 0)
            _HubMetricChipData(
              icon: Icons.emoji_events_rounded,
              label: l10n.studyHarmonyProgressLeague(
                _leagueTierLabel(l10n, leagueProgress.tier),
              ),
            ),
          if (legendaryChapters > 0)
            _HubMetricChipData(
              icon: Icons.workspace_premium_rounded,
              label: l10n.studyHarmonyProgressLegendCrowns(legendaryChapters),
            ),
          if (questChestStatus.openedCount > 0)
            _HubMetricChipData(
              icon: Icons.inventory_2_rounded,
              label: l10n.studyHarmonyProgressQuestChests(
                questChestStatus.openedCount,
              ),
            ),
          if (leagueXpBoost.active)
            _HubMetricChipData(
              icon: Icons.flash_on_rounded,
              label: l10n.studyHarmonyProgressLeagueBoost(
                leagueXpBoost.chargeCount,
              ),
            ),
        ].take(6).toList(growable: false);
        final localeTag = Localizations.localeOf(context).toLanguageTag();
        final recentPerformance =
            StudyHarmonyRecentPerformance.fromProgressSnapshot(
              widget.progressController.snapshot,
            );
        final adaptiveProfile = _hubAdaptiveProfile(
          snapshot: widget.progressController.snapshot,
          localeTag: localeTag,
          recentPerformance: recentPerformance,
        );
        final adaptivePlan = personalizeStudyHarmony(
          profile: adaptiveProfile,
          recentPerformance: recentPerformance,
        );
        final rewardMetrics = widget.progressController.currentRewardMetrics();
        final rewardCandidates = widget.progressController
            .currentRewardCandidates();
        final rewardBalances = widget.progressController
            .currentRewardCurrencyBalances();
        final unlockedTitles = rewardCandidates
            .where(
              (candidate) =>
                  candidate.kind == StudyHarmonyRewardKind.title &&
                  candidate.unlocked,
            )
            .take(3)
            .toList(growable: false);
        final unlockedCosmetics = rewardCandidates
            .where(
              (candidate) =>
                  candidate.kind == StudyHarmonyRewardKind.cosmetic &&
                  candidate.unlocked,
            )
            .take(3)
            .toList(growable: false);
        final upcomingRewards = rewardCandidates
            .where((candidate) => !candidate.unlocked)
            .take(3)
            .toList(growable: false);
        final directorMode =
            primaryRecommendation?.sessionMode ??
            continueRecommendation?.sessionMode ??
            StudyHarmonySessionMode.lesson;
        final difficultyPlan = StudyHarmonyDifficultyDesign.design(
          mode: directorMode,
          input: _hubDifficultyInput(
            recentPerformance: recentPerformance,
            adaptiveProfile: adaptiveProfile,
            progressController: widget.progressController,
          ),
        );
        final runtimeTuning = StudyHarmonyRuntimeTuningRules.tuneFromPlan(
          plan: difficultyPlan,
          baseStartingLives: 3,
          baseGoalCorrectAnswers: 5,
        );
        final lessonResults = <StudyHarmonyLessonProgressSummary>[
          for (final chapter in course.chapters)
            ...chapter.lessons
                .map(
                  (lesson) =>
                      widget.progressController.lessonResultFor(lesson.id),
                )
                .whereType<StudyHarmonyLessonProgressSummary>(),
        ];
        final arcadeProgress = summarizeStudyHarmonyArcadeProgress(
          lessonResults,
          totalLessons: totalLessons,
          reviewQueueSize: dueReviews,
          chapterClears: clearedChapters,
          bossClears:
              rewardMetrics.modeClearCounts[StudyHarmonySessionMode.bossRush] ??
              legendaryChapters,
          currentStreak: dailyStreak,
        );
        final isEarlyJourney =
            clearedLessons < 6 &&
            dueReviews <= 2 &&
            widget.progressController.shopPurchaseCount() == 0;
        final featuredArcadeModes = buildStudyHarmonyFeaturedArcadeModeCards(
          arcadeProgress,
          limit: isEarlyJourney ? 2 : 4,
        );
        final featuredPlaylists = buildStudyHarmonyFeaturedArcadePlaylists(
          arcadeProgress,
          limit: isEarlyJourney ? 1 : 2,
        );
        final featuredShopItems = _featuredShopItemsForHub(
          metrics: rewardMetrics,
          progressController: widget.progressController,
          limit: isEarlyJourney ? 2 : 3,
        );
        final leadTitle = unlockedTitles.isEmpty
            ? null
            : _preferredRewardCandidate(
                unlockedTitles,
                adaptivePlan.rewardEmphasis.primaryFocus,
              );
        final leadCosmetic = unlockedCosmetics.isEmpty
            ? null
            : unlockedCosmetics.first;
        final ownedTitleIds = widget.progressController.ownedTitleIds();
        final ownedCosmeticIds = widget.progressController.ownedCosmeticIds();
        final equippedTitleId = widget.progressController.equippedTitleId();
        final equippedCosmeticIds = widget.progressController
            .equippedCosmeticIds();
        final equippedTitle = equippedTitleId == null
            ? null
            : studyHarmonyTitlesById[equippedTitleId];
        final equippedCosmetics = <StudyHarmonyCosmeticDefinition>[
          for (final cosmeticId in equippedCosmeticIds)
            if (studyHarmonyCosmeticsById[cosmeticId] != null)
              studyHarmonyCosmeticsById[cosmeticId]!,
        ];
        final ownedTitles =
            <StudyHarmonyTitleDefinition>[
              for (final titleId in ownedTitleIds)
                if (studyHarmonyTitlesById[titleId] != null)
                  studyHarmonyTitlesById[titleId]!,
            ]..sort((left, right) {
              final byRarity = right.rarity.index.compareTo(left.rarity.index);
              if (byRarity != 0) {
                return byRarity;
              }
              return left.title.compareTo(right.title);
            });
        final ownedCosmetics =
            <StudyHarmonyCosmeticDefinition>[
              for (final cosmeticId in ownedCosmeticIds)
                if (studyHarmonyCosmeticsById[cosmeticId] != null)
                  studyHarmonyCosmeticsById[cosmeticId]!,
            ]..sort((left, right) {
              final byRarity = right.rarity.index.compareTo(left.rarity.index);
              if (byRarity != 0) {
                return byRarity;
              }
              return left.title.compareTo(right.title);
            });

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
                          large: 2,
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
                        final primaryRecommendationCopy =
                            primaryRecommendation == null
                            ? null
                            : _recommendationCopy(l10n, primaryRecommendation);
                        final quickRoutineRecommendation = dueReviews > 0
                            ? (reviewRecommendation ??
                                  dailyRecommendation ??
                                  primaryRecommendation)
                            : (dailyRecommendation ??
                                  reviewRecommendation ??
                                  primaryRecommendation);
                        final quickRoutineCopy =
                            quickRoutineRecommendation == null
                            ? null
                            : _recommendationCopy(
                                l10n,
                                quickRoutineRecommendation,
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
                              recommendationCopy: primaryRecommendationCopy,
                              recommendationOnPressed:
                                  primaryRecommendation == null
                                  ? null
                                  : () => _openRecommendation(
                                      context,
                                      l10n,
                                      primaryRecommendation,
                                      course,
                                    ),
                            ),
                            const SizedBox(height: 18),
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
                            const SizedBox(height: 18),
                            Text(
                              _isKoreanLocale(localeTag)
                                  ? '吏湲??쒖옉'
                                  : 'Start Here',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-quickstart-primary-card',
                                    ),
                                    icon: Icons.play_circle_fill_rounded,
                                    title:
                                        primaryRecommendationCopy?.title ??
                                        l10n.studyHarmonyContinueCardTitle,
                                    headline:
                                        primaryRecommendationCopy?.headline ??
                                        continueRecommendation?.lesson.title ??
                                        l10n.studyHarmonyContinueCardTitle,
                                    supportingLabel:
                                        primaryRecommendationCopy
                                            ?.supportingLabel ??
                                        continueRecommendation?.chapter.title ??
                                        course.title,
                                    body:
                                        primaryRecommendationCopy?.body ??
                                        _continueHint(
                                          l10n,
                                          continueRecommendation,
                                        ),
                                    footerLabels: [
                                      _runtimeTuningSummary(
                                        localeTag,
                                        runtimeTuning,
                                      ),
                                      if (primaryRecommendation != null)
                                        _sessionModeLabel(
                                          l10n,
                                          primaryRecommendation.sessionMode,
                                        ),
                                    ],
                                    actionLabel: primaryRecommendation == null
                                        ? null
                                        : 'Play Now',
                                    onPressed: primaryRecommendation == null
                                        ? null
                                        : () => _openRecommendation(
                                            context,
                                            l10n,
                                            primaryRecommendation,
                                            course,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-quickstart-routine-card',
                                    ),
                                    icon: dueReviews > 0
                                        ? Icons.refresh_rounded
                                        : Icons.wb_sunny_rounded,
                                    title:
                                        quickRoutineCopy?.title ??
                                        (dueReviews > 0
                                            ? l10n.studyHarmonyReviewCardTitle
                                            : l10n.studyHarmonyDailyCardTitle),
                                    headline:
                                        quickRoutineCopy?.headline ??
                                        quickRoutineRecommendation
                                            ?.lesson
                                            .title ??
                                        course.title,
                                    supportingLabel:
                                        quickRoutineCopy?.supportingLabel ??
                                        quickRoutineRecommendation
                                            ?.chapter
                                            .title ??
                                        course.title,
                                    body:
                                        quickRoutineCopy?.body ??
                                        (dueReviews > 0
                                            ? _reviewHint(
                                                l10n,
                                                reviewRecommendation,
                                              )
                                            : (dailyCompletedToday
                                                  ? l10n.studyHarmonyDailyCardHintCompleted
                                                  : l10n.studyHarmonyDailyCardHint)),
                                    footerLabels: [
                                      if (dueReviews > 0)
                                        l10n.studyHarmonyProgressReviewsReady(
                                          dueReviews,
                                        )
                                      else if (dailyStreak > 0)
                                        l10n.studyHarmonyProgressStreak(
                                          dailyStreak,
                                        ),
                                      _coachLabel(
                                        localeTag,
                                        adaptivePlan.coachStyle,
                                      ),
                                    ],
                                    actionLabel:
                                        quickRoutineRecommendation == null
                                        ? null
                                        : (_isKoreanLocale(localeTag)
                                              ? '由щ벉 ?좎?'
                                              : 'Keep Momentum'),
                                    onPressed:
                                        quickRoutineRecommendation == null
                                        ? null
                                        : () async {
                                            if (quickRoutineRecommendation
                                                    .sessionMode ==
                                                StudyHarmonySessionMode.daily) {
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
                                              return;
                                            }
                                            _openRecommendation(
                                              context,
                                              l10n,
                                              quickRoutineRecommendation,
                                              course,
                                            );
                                          },
                                  ),
                                ),
                              ],
                            ),
                            if (ownedTitles.isNotEmpty ||
                                ownedCosmetics.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (equippedTitleId != null)
                                    FilterChip(
                                      label: Text(
                                        _isKoreanLocale(localeTag)
                                            ? '칭호 해제'
                                            : 'Clear title',
                                      ),
                                      selected: false,
                                      onSelected: (_) {
                                        unawaited(
                                          widget.progressController
                                              .unequipTitle(),
                                        );
                                      },
                                    ),
                                  for (final title in ownedTitles.take(
                                    isEarlyJourney ? 3 : 5,
                                  ))
                                    FilterChip(
                                      label: Text(title.title),
                                      selected: equippedTitleId == title.id,
                                      onSelected: (selected) {
                                        unawaited(
                                          selected
                                              ? widget.progressController
                                                    .equipTitle(title.id)
                                              : widget.progressController
                                                    .unequipTitle(),
                                        );
                                      },
                                    ),
                                  for (final cosmetic in ownedCosmetics.take(
                                    isEarlyJourney ? 4 : 6,
                                  ))
                                    FilterChip(
                                      label: Text(cosmetic.title),
                                      selected: equippedCosmeticIds.contains(
                                        cosmetic.id,
                                      ),
                                      onSelected: (selected) {
                                        unawaited(
                                          selected
                                              ? widget.progressController
                                                    .equipCosmetic(cosmetic.id)
                                              : widget.progressController
                                                    .unequipCosmetic(
                                                      cosmetic.id,
                                                    ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 24),
                            Text(
                              'Player Deck',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-player-card',
                                    ),
                                    icon: Icons.person_rounded,
                                    title: 'Playstyle',
                                    headline:
                                        equippedTitle?.title ??
                                        leadTitle?.title ??
                                        _playStyleLabel(
                                          localeTag,
                                          adaptiveProfile.playStyle,
                                        ),
                                    supportingLabel:
                                        equippedCosmetics.isNotEmpty
                                        ? equippedCosmetics.first.title
                                        : _coachLabel(
                                            localeTag,
                                            adaptivePlan.coachStyle,
                                          ),
                                    body:
                                        equippedTitle?.description ??
                                        _coachLine(localeTag, adaptivePlan),
                                    footerLabels: [
                                      _rewardFocusLabel(
                                        localeTag,
                                        adaptivePlan
                                            .rewardEmphasis
                                            .primaryFocus,
                                      ),
                                      for (final cosmetic
                                          in equippedCosmetics.take(2))
                                        cosmetic.title,
                                      if (equippedCosmetics.isEmpty &&
                                          leadCosmetic != null)
                                        leadCosmetic.title,
                                      if (upcomingRewards.isNotEmpty)
                                        _nextUnlockShortLabel(
                                          localeTag,
                                          upcomingRewards.first,
                                        ),
                                    ],
                                    actionLabel: _isKoreanLocale(localeTag)
                                        ? '?곹깭 ?뺤씤'
                                        : 'Overview',
                                    onPressed: null,
                                    showAction: false,
                                  ),
                                ),
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-director-card',
                                    ),
                                    icon: Icons.tune_rounded,
                                    title: 'Run Director',
                                    headline: _difficultyLaneLabel(
                                      localeTag,
                                      difficultyPlan.difficultyLane,
                                    ),
                                    supportingLabel: _runtimeTuningSummary(
                                      localeTag,
                                      runtimeTuning,
                                    ),
                                    body: runtimeTuning.rationale.first,
                                    footerLabels: [
                                      _pressureTierLabel(
                                        localeTag,
                                        difficultyPlan.pressureTier,
                                      ),
                                      _forgivenessTierLabel(
                                        localeTag,
                                        difficultyPlan.forgivenessTier,
                                      ),
                                      _comboGoalLabel(
                                        localeTag,
                                        difficultyPlan.comboTarget,
                                      ),
                                      _pacingPlanLabel(
                                        localeTag,
                                        difficultyPlan,
                                      ),
                                    ],
                                    actionLabel: primaryRecommendation == null
                                        ? null
                                        : (_isKoreanLocale(localeTag)
                                              ? '異붿쿇 ???쒖옉'
                                              : 'Play Recommended'),
                                    onPressed: primaryRecommendation == null
                                        ? null
                                        : () => _openRecommendation(
                                            context,
                                            l10n,
                                            primaryRecommendation,
                                            course,
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-economy-card',
                                    ),
                                    icon: Icons.wallet_giftcard_rounded,
                                    title: _isKoreanLocale(localeTag)
                                        ? '寃뚯엫 ?댁퐫?몃?'
                                        : 'Game Economy',
                                    headline: _currencyBalanceLabel(
                                      'currency.studyCoin',
                                      rewardBalances['currency.studyCoin'] ?? 0,
                                    ),
                                    supportingLabel: _currencyBalanceLabel(
                                      'currency.starShard',
                                      rewardBalances['currency.starShard'] ?? 0,
                                    ),
                                    body: _isKoreanLocale(localeTag)
                                        ? '?곸젏, ?좏겙, 蹂댁“ ?꾩씠?쒖씠 紐⑤몢 ?꾩옱 吏꾪뻾?꾩? ?곌껐?⑸땲??'
                                        : 'Shop stock, utility tokens, and meta items all react to your run history.',
                                    footerLabels: [
                                      _currencyBalanceLabel(
                                        'currency.focusToken',
                                        rewardBalances['currency.focusToken'] ??
                                            0,
                                      ),
                                      _currencyBalanceLabel(
                                        'currency.rerollToken',
                                        rewardBalances['currency.rerollToken'] ??
                                            0,
                                      ),
                                      _currencyBalanceLabel(
                                        'currency.streakShield',
                                        rewardBalances['currency.streakShield'] ??
                                            0,
                                      ),
                                      _isKoreanLocale(localeTag)
                                          ? '칭호 ${ownedTitles.length}개'
                                          : '${ownedTitles.length} titles owned',
                                      _isKoreanLocale(localeTag)
                                          ? '코스메틱 ${ownedCosmetics.length}개'
                                          : '${ownedCosmetics.length} cosmetics owned',
                                      _isKoreanLocale(localeTag)
                                          ? '상점 구매 ${widget.progressController.shopPurchaseCount()}회'
                                          : '${widget.progressController.shopPurchaseCount()} shop purchases',
                                    ],
                                    actionLabel: _isKoreanLocale(localeTag)
                                        ? '蹂닿???蹂닿린'
                                        : 'View Wallet',
                                    onPressed: null,
                                    showAction: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _isKoreanLocale(localeTag)
                                  ? '?꾩??대뱶 ?ㅽ룷?몃씪?댄듃'
                                  : 'Arcade Spotlight',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                for (final featured in featuredArcadeModes)
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: ValueKey(
                                        'study-harmony-arcade-card-${featured.mode.id}',
                                      ),
                                      icon: _arcadeModeIcon(featured.mode),
                                      title: featured.mode.title,
                                      headline: featured.mode.fantasy,
                                      supportingLabel: _arcadeRewardStyleLabel(
                                        localeTag,
                                        buildStudyHarmonyArcadeRuntimePlan(
                                              modeId: featured.mode.id,
                                              baseStartingLives: runtimeTuning
                                                  .recommendedStartingLives,
                                              baseGoalCorrectAnswers: runtimeTuning
                                                  .recommendedGoalCorrectAnswers,
                                              progress: arcadeProgress,
                                            ).primaryRewardStyle() ??
                                            featured.mode.rewardStyle,
                                      ),
                                      body: featured.cue,
                                      footerLabels: [
                                        _arcadeRiskLabel(
                                          localeTag,
                                          featured.mode.riskStyle,
                                        ),
                                        ..._arcadeRuntimeLabels(
                                          localeTag,
                                          buildStudyHarmonyArcadeRuntimePlan(
                                            modeId: featured.mode.id,
                                            baseStartingLives: runtimeTuning
                                                .recommendedStartingLives,
                                            baseGoalCorrectAnswers: runtimeTuning
                                                .recommendedGoalCorrectAnswers,
                                            progress: arcadeProgress,
                                          ),
                                        ).take(1),
                                        ...featured.mode.unlockConditionLabels
                                            .take(1),
                                      ],
                                      actionLabel: _isKoreanLocale(localeTag)
                                          ? '?꾩??대뱶 ?쒖옉'
                                          : 'Play Arcade',
                                      onPressed:
                                          _arcadeRecommendationForMode(
                                                featured.mode.id,
                                                continueRecommendation:
                                                    continueRecommendation,
                                                reviewRecommendation:
                                                    reviewRecommendation,
                                                focusRecommendation:
                                                    focusRecommendation,
                                                dailyRecommendation:
                                                    dailyRecommendation,
                                                relayRecommendation:
                                                    relayRecommendation,
                                                legendRecommendation:
                                                    legendRecommendation,
                                                bossRushRecommendation:
                                                    bossRushRecommendation,
                                              ) ==
                                              null
                                          ? null
                                          : () => _openArcadeMode(
                                              context,
                                              l10n,
                                              mode: featured.mode,
                                              recommendation:
                                                  _arcadeRecommendationForMode(
                                                    featured.mode.id,
                                                    continueRecommendation:
                                                        continueRecommendation,
                                                    reviewRecommendation:
                                                        reviewRecommendation,
                                                    focusRecommendation:
                                                        focusRecommendation,
                                                    dailyRecommendation:
                                                        dailyRecommendation,
                                                    relayRecommendation:
                                                        relayRecommendation,
                                                    legendRecommendation:
                                                        legendRecommendation,
                                                    bossRushRecommendation:
                                                        bossRushRecommendation,
                                                  )!,
                                              course: course,
                                            ),
                                    ),
                                  ),
                                for (final playlist in featuredPlaylists)
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: ValueKey(
                                        'study-harmony-playlist-card-${playlist.playlist.id}',
                                      ),
                                      icon: Icons.queue_music_rounded,
                                      title: playlist.playlist.title,
                                      headline: playlist.playlist.subtitle,
                                      supportingLabel: playlist.cue,
                                      body: playlist.playlist.fantasy,
                                      footerLabels: [
                                        '${playlist.playlist.modeIds.length} modes',
                                      ],
                                      actionLabel: _isKoreanLocale(localeTag)
                                          ? '?명듃 ?쒖옉'
                                          : 'Play Set',
                                      onPressed:
                                          _arcadePlaylistRecommendation(
                                                playlist.playlist,
                                                continueRecommendation:
                                                    continueRecommendation,
                                                reviewRecommendation:
                                                    reviewRecommendation,
                                                focusRecommendation:
                                                    focusRecommendation,
                                                dailyRecommendation:
                                                    dailyRecommendation,
                                                relayRecommendation:
                                                    relayRecommendation,
                                                legendRecommendation:
                                                    legendRecommendation,
                                                bossRushRecommendation:
                                                    bossRushRecommendation,
                                              ) ==
                                              null
                                          ? null
                                          : () => _openRecommendation(
                                              context,
                                              l10n,
                                              _arcadePlaylistRecommendation(
                                                playlist.playlist,
                                                continueRecommendation:
                                                    continueRecommendation,
                                                reviewRecommendation:
                                                    reviewRecommendation,
                                                focusRecommendation:
                                                    focusRecommendation,
                                                dailyRecommendation:
                                                    dailyRecommendation,
                                                relayRecommendation:
                                                    relayRecommendation,
                                                legendRecommendation:
                                                    legendRecommendation,
                                                bossRushRecommendation:
                                                    bossRushRecommendation,
                                              )!,
                                              course,
                                            ),
                                      showAction:
                                          _arcadePlaylistRecommendation(
                                            playlist.playlist,
                                            continueRecommendation:
                                                continueRecommendation,
                                            reviewRecommendation:
                                                reviewRecommendation,
                                            focusRecommendation:
                                                focusRecommendation,
                                            dailyRecommendation:
                                                dailyRecommendation,
                                            relayRecommendation:
                                                relayRecommendation,
                                            legendRecommendation:
                                                legendRecommendation,
                                            bossRushRecommendation:
                                                bossRushRecommendation,
                                          ) !=
                                          null,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _isKoreanLocale(localeTag)
                                  ? '?섏씠??留덉폆'
                                  : 'Night Market',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              children: [
                                for (final item in featuredShopItems)
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: ValueKey(
                                        'study-harmony-shop-card-${item.id}',
                                      ),
                                      icon: Icons.storefront_rounded,
                                      title: item.title,
                                      headline:
                                          '${item.priceAmount} ${studyHarmonyCurrenciesById[item.priceCurrencyId]?.title ?? item.priceCurrencyId}',
                                      supportingLabel: _shopStateLabel(
                                        localeTag,
                                        item: item,
                                        progressController:
                                            widget.progressController,
                                      ),
                                      body: item.description,
                                      footerLabels: [
                                        for (final grant in item.grants)
                                          _currencyGrantLabel(grant),
                                        if (item.unlockIds.isNotEmpty)
                                          item.unlockIds.first,
                                      ],
                                      actionLabel: _shopActionLabel(
                                        localeTag,
                                        item: item,
                                        progressController:
                                            widget.progressController,
                                      ),
                                      onPressed:
                                          widget.progressController
                                              .canPurchaseShopItem(item)
                                          ? () =>
                                                _purchaseShopItem(context, item)
                                          : (_shopLoadoutUnlockId(
                                                      item,
                                                      widget.progressController,
                                                    ) ==
                                                    null ||
                                                _isRewardUnlockEquipped(
                                                  _shopLoadoutUnlockId(
                                                    item,
                                                    widget.progressController,
                                                  )!,
                                                  widget.progressController,
                                                ))
                                          ? null
                                          : () => _equipOwnedReward(
                                              context,
                                              _shopLoadoutUnlockId(
                                                item,
                                                widget.progressController,
                                              )!,
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ...[
                              Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
                              const SizedBox(height: 24),
                              Text(
                                l10n.studyHarmonyQuestBoardTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
                              const SizedBox(height: 24),
                              Text(
                                l10n.studyHarmonyWeeklyPlanTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
                              const SizedBox(height: 24),
                              Text(
                                l10n.studyHarmonyMilestoneCabinetTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
                              const SizedBox(height: 24),
                              Text(
                                l10n.studyHarmonyHubChapterSectionTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
  String? arcadeModeId,
}) {
  if (recommendation.sessionMode == StudyHarmonySessionMode.lesson &&
      recommendation.resolvedSourceLessons.length <= 1) {
    if (arcadeModeId == null) {
      return recommendation.lesson;
    }
    return StudyHarmonyLessonDefinition(
      id: recommendation.lesson.id,
      chapterId: recommendation.lesson.chapterId,
      title: recommendation.lesson.title,
      description: recommendation.lesson.description,
      objectiveLabel: recommendation.lesson.objectiveLabel,
      goalCorrectAnswers: recommendation.lesson.goalCorrectAnswers,
      startingLives: recommendation.lesson.startingLives,
      sessionMode: recommendation.lesson.sessionMode,
      tasks: recommendation.lesson.tasks,
      skillTags: recommendation.lesson.skillTags,
      sessionMetadata: recommendation.lesson.sessionMetadata.copyWith(
        arcadeModeId: arcadeModeId,
      ),
    );
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
      arcadeModeId: arcadeModeId,
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
    required this.recommendationCopy,
    required this.recommendationOnPressed,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final String body;
  final List<_HubMetricChipData> metrics;
  final _HubRecommendationCopy? recommendationCopy;
  final VoidCallback? recommendationOnPressed;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 880;
              final copy = recommendationCopy;
              final heroCopy = Column(
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
                  const SizedBox(height: 14),
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
              );
              final featuredCard = copy == null
                  ? const SizedBox.shrink()
                  : _HubActionCard(
                      icon: copy.icon,
                      title: copy.title,
                      headline: copy.headline,
                      supportingLabel: copy.supportingLabel,
                      body: copy.body,
                      actionLabel: copy.actionLabel,
                      onPressed: recommendationOnPressed,
                      footerLabels: copy.footerLabels,
                      dense: false,
                    );

              if (copy == null) {
                return heroCopy;
              }

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: heroCopy),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: featuredCard,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heroCopy, const SizedBox(height: 16), featuredCard],
              );
            },
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
    this.actionLabel,
    required this.onPressed,
    this.footerLabels = const <String>[],
    this.dense = true,
    this.showAction = true,
  });

  final IconData icon;
  final String title;
  final String headline;
  final String supportingLabel;
  final String body;
  final String? actionLabel;
  final VoidCallback? onPressed;
  final List<String> footerLabels;
  final bool dense;
  final bool showAction;

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
          padding: EdgeInsets.all(dense ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HubIconBadge(icon: icon),
              SizedBox(height: dense ? 12 : 14),
              Text(
                title,
                style:
                    (dense
                            ? theme.textTheme.titleSmall
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
              ),
              const SizedBox(height: 8),
              Text(
                headline,
                maxLines: dense ? 2 : null,
                overflow: dense ? TextOverflow.ellipsis : TextOverflow.visible,
                style:
                    (dense
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.headlineSmall)
                        ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                supportingLabel,
                maxLines: dense ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                maxLines: dense ? 3 : null,
                overflow: dense ? TextOverflow.ellipsis : TextOverflow.visible,
                style:
                    (dense
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
              ),
              if (footerLabels.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final footer in footerLabels)
                      Chip(
                        label: Text(footer),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
              if (showAction)
                if (actionLabel case final label?) ...[
                  SizedBox(height: dense ? 14 : 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: dense
                          ? FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                            )
                          : null,
                      onPressed: onPressed,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(label),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: data.progressFraction,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 7,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 7,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
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
          padding: const EdgeInsets.all(16),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary.chapter.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
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
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                progressLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(lessonCountLabel),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    label: Text(completedCountLabel),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (rewardLabel case final reward?)
                    Chip(
                      label: Text(reward),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              if (nextLessonLabel case final nextLesson?) ...[
                const SizedBox(height: 12),
                Text(
                  nextLesson,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 14),
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

StudyHarmonyPersonalizationProfile _hubAdaptiveProfile({
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

  return StudyHarmonyPersonalizationProfile(
    ageBand: StudyHarmonyAgeBand.adult,
    skillBand: inferStudyHarmonySkillBand(recentPerformance),
    playStyle: playStyle,
    sessionLengthPreference:
        _modeCountFromSnapshot(modeClearCounts, StudyHarmonySessionMode.focus) +
                _modeCountFromSnapshot(
                  modeClearCounts,
                  StudyHarmonySessionMode.legend,
                ) >
            _modeCountFromSnapshot(
                  modeClearCounts,
                  StudyHarmonySessionMode.review,
                ) +
                _modeCountFromSnapshot(
                  modeClearCounts,
                  StudyHarmonySessionMode.lesson,
                )
        ? StudyHarmonySessionLengthPreference.long
        : StudyHarmonySessionLengthPreference.short,
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

StudyHarmonyDifficultyInput _hubDifficultyInput({
  required StudyHarmonyRecentPerformance recentPerformance,
  required StudyHarmonyPersonalizationProfile adaptiveProfile,
  required StudyHarmonyProgressController progressController,
}) {
  final comboPeak = progressController.snapshot.bestSessionCombo;
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

List<StudyHarmonyShopItemDefinition> _featuredShopItemsForHub({
  required StudyHarmonyRewardProgressMetrics metrics,
  required StudyHarmonyProgressController progressController,
  int limit = 3,
}) {
  final items = studyHarmonyShopItems.toList(growable: false)
    ..sort((left, right) {
      final leftPurchasable = progressController.canPurchaseShopItem(left)
          ? 1
          : 0;
      final rightPurchasable = progressController.canPurchaseShopItem(right)
          ? 1
          : 0;
      final byPurchasable = rightPurchasable.compareTo(leftPurchasable);
      if (byPurchasable != 0) {
        return byPurchasable;
      }
      final leftRequirementsMet =
          left.requirements.every((requirement) => requirement.isMet(metrics))
          ? 1
          : 0;
      final rightRequirementsMet =
          right.requirements.every((requirement) => requirement.isMet(metrics))
          ? 1
          : 0;
      final byUnlocked = rightRequirementsMet.compareTo(leftRequirementsMet);
      if (byUnlocked != 0) {
        return byUnlocked;
      }
      final byRarity = right.rarity.index.compareTo(left.rarity.index);
      if (byRarity != 0) {
        return byRarity;
      }
      return left.priceAmount.compareTo(right.priceAmount);
    });
  return items.take(limit).toList(growable: false);
}

StudyHarmonyRewardCandidate? _preferredRewardCandidate(
  List<StudyHarmonyRewardCandidate> candidates,
  StudyHarmonyRewardFocus focus,
) {
  if (candidates.isEmpty) {
    return null;
  }
  final sorted = candidates.toList(growable: false)
    ..sort((left, right) {
      final focusScore = _rewardCandidateFocusScore(
        right,
        focus,
      ).compareTo(_rewardCandidateFocusScore(left, focus));
      if (focusScore != 0) {
        return focusScore;
      }
      final byRarity = right.rarity.index.compareTo(left.rarity.index);
      if (byRarity != 0) {
        return byRarity;
      }
      return left.title.compareTo(right.title);
    });
  return sorted.first;
}

int _rewardCandidateFocusScore(
  StudyHarmonyRewardCandidate candidate,
  StudyHarmonyRewardFocus focus,
) {
  return switch (focus) {
    StudyHarmonyRewardFocus.mastery =>
      candidate.tags.contains('lesson') || candidate.tags.contains('review')
          ? 2
          : 0,
    StudyHarmonyRewardFocus.achievements =>
      candidate.kind == StudyHarmonyRewardKind.title ? 2 : 1,
    StudyHarmonyRewardFocus.cosmetics =>
      candidate.kind == StudyHarmonyRewardKind.cosmetic ? 2 : 0,
    StudyHarmonyRewardFocus.currency =>
      candidate.tags.contains('shop') || candidate.tags.contains('economy')
          ? 2
          : 0,
    StudyHarmonyRewardFocus.collection =>
      candidate.tags.contains('collection') || candidate.tags.contains('tour')
          ? 2
          : 0,
  };
}

StudyHarmonyLessonRecommendation? _arcadeRecommendationForMode(
  StudyHarmonyArcadeModeId modeId, {
  required StudyHarmonyLessonRecommendation? continueRecommendation,
  required StudyHarmonyLessonRecommendation? reviewRecommendation,
  required StudyHarmonyLessonRecommendation? focusRecommendation,
  required StudyHarmonyLessonRecommendation? dailyRecommendation,
  required StudyHarmonyLessonRecommendation? relayRecommendation,
  required StudyHarmonyLessonRecommendation? legendRecommendation,
  required StudyHarmonyLessonRecommendation? bossRushRecommendation,
}) {
  return switch (modeId) {
    'neon-sprint' => dailyRecommendation ?? continueRecommendation,
    'ghost-relay' => relayRecommendation ?? continueRecommendation,
    'vault-break' =>
      reviewRecommendation ?? focusRecommendation ?? continueRecommendation,
    'remix-fever' =>
      focusRecommendation ?? dailyRecommendation ?? continueRecommendation,
    'boss-rush' =>
      bossRushRecommendation ?? relayRecommendation ?? continueRecommendation,
    'crown-loop' =>
      legendRecommendation ?? bossRushRecommendation ?? continueRecommendation,
    'duel-stage' => relayRecommendation ?? reviewRecommendation,
    'night-market' =>
      dailyRecommendation ?? reviewRecommendation ?? continueRecommendation,
    _ => continueRecommendation,
  };
}

StudyHarmonyLessonRecommendation? _arcadePlaylistRecommendation(
  StudyHarmonyArcadePlaylistDefinition playlist, {
  required StudyHarmonyLessonRecommendation? continueRecommendation,
  required StudyHarmonyLessonRecommendation? reviewRecommendation,
  required StudyHarmonyLessonRecommendation? focusRecommendation,
  required StudyHarmonyLessonRecommendation? dailyRecommendation,
  required StudyHarmonyLessonRecommendation? relayRecommendation,
  required StudyHarmonyLessonRecommendation? legendRecommendation,
  required StudyHarmonyLessonRecommendation? bossRushRecommendation,
}) {
  for (final modeId in playlist.modeIds) {
    final recommendation = _arcadeRecommendationForMode(
      modeId,
      continueRecommendation: continueRecommendation,
      reviewRecommendation: reviewRecommendation,
      focusRecommendation: focusRecommendation,
      dailyRecommendation: dailyRecommendation,
      relayRecommendation: relayRecommendation,
      legendRecommendation: legendRecommendation,
      bossRushRecommendation: bossRushRecommendation,
    );
    if (recommendation != null) {
      return recommendation;
    }
  }
  return continueRecommendation;
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

String _playStyleLabel(String localeTag, StudyHarmonyPlayStyle playStyle) {
  return switch (playStyle) {
    StudyHarmonyPlayStyle.competitor => 'Competitor',
    StudyHarmonyPlayStyle.collector => 'Collector',
    StudyHarmonyPlayStyle.explorer => 'Explorer',
    StudyHarmonyPlayStyle.stabilizer => 'Stabilizer',
    StudyHarmonyPlayStyle.balanced => 'Balanced',
  };
}

String _rewardFocusLabel(String localeTag, StudyHarmonyRewardFocus focus) {
  return switch (focus) {
    StudyHarmonyRewardFocus.mastery => 'Focus: Mastery',
    StudyHarmonyRewardFocus.achievements => 'Focus: Achievements',
    StudyHarmonyRewardFocus.cosmetics => 'Focus: Cosmetics',
    StudyHarmonyRewardFocus.currency => 'Focus: Currency',
    StudyHarmonyRewardFocus.collection => 'Focus: Collection',
  };
}

String _nextUnlockShortLabel(
  String localeTag,
  StudyHarmonyRewardCandidate reward,
) {
  final ko = _isKoreanLocale(localeTag);
  final progress = (reward.progressFraction * 100).round();
  return ko
      ? '?ㅼ쓬 ?닿툑 ${reward.title} $progress%'
      : 'Next ${reward.title} $progress%';
}

String _currencyBalanceLabel(StudyHarmonyCurrencyId currencyId, int balance) {
  return '${studyHarmonyCurrenciesById[currencyId]?.title ?? currencyId} $balance';
}

String _currencyGrantLabel(StudyHarmonyRewardGrant grant) {
  return '${studyHarmonyCurrenciesById[grant.currencyId]?.title ?? grant.currencyId} +${grant.amount}';
}

String _difficultyLaneLabel(String localeTag, StudyHarmonyDifficultyLane lane) {
  final ko = _isKoreanLocale(localeTag);
  return switch (lane) {
    StudyHarmonyDifficultyLane.recovery => ko ? '?뚮났 ?덉씤' : 'Recovery Lane',
    StudyHarmonyDifficultyLane.groove => ko ? '洹몃（釉??덉씤' : 'Groove Lane',
    StudyHarmonyDifficultyLane.push => ko ? '?몄떆 ?덉씤' : 'Push Lane',
    StudyHarmonyDifficultyLane.clutch => ko ? '?대윭移??덉씤' : 'Clutch Lane',
    StudyHarmonyDifficultyLane.legend => ko ? '?덉쟾???덉씤' : 'Legend Lane',
  };
}

String _pressureTierLabel(String localeTag, StudyHarmonyPressureTier tier) {
  return switch (tier) {
    StudyHarmonyPressureTier.calm => 'Calm Pressure',
    StudyHarmonyPressureTier.steady => 'Steady Pressure',
    StudyHarmonyPressureTier.hot => 'Hot Pressure',
    StudyHarmonyPressureTier.charged => 'Charged Pressure',
    StudyHarmonyPressureTier.overdrive => 'Overdrive',
  };
}

String _forgivenessTierLabel(
  String localeTag,
  StudyHarmonyForgivenessTier tier,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (tier) {
    StudyHarmonyForgivenessTier.strict => ko ? '?ㅼ닔 ?덉슜 ?곸쓬' : 'Strict Windows',
    StudyHarmonyForgivenessTier.tight => ko ? '?ㅼ닔 ?덉슜 ??댄듃' : 'Tight Windows',
    StudyHarmonyForgivenessTier.balanced =>
      ko ? '?ㅼ닔 ?덉슜 洹좏삎' : 'Balanced Windows',
    StudyHarmonyForgivenessTier.kind => ko ? '?ㅼ닔 ?덉슜 ?볦쓬' : 'Kind Windows',
    StudyHarmonyForgivenessTier.generous =>
      ko ? '?ㅼ닔 ?덉슜 留ㅼ슦 ?볦쓬' : 'Generous Windows',
  };
}

String _comboGoalLabel(String localeTag, int comboTarget) {
  return _isKoreanLocale(localeTag)
      ? '肄ㅻ낫 紐⑺몴 $comboTarget'
      : 'Combo Goal $comboTarget';
}

String _runtimeTuningSummary(
  String localeTag,
  StudyHarmonyRuntimeTuning tuning,
) {
  return _isKoreanLocale(localeTag)
      ? '?섑듃 ${tuning.recommendedStartingLives} 쨌 紐⑺몴 ${tuning.recommendedGoalCorrectAnswers}'
      : 'Lives ${tuning.recommendedStartingLives} 쨌 Goal ${tuning.recommendedGoalCorrectAnswers}';
}

String _coachLabel(String localeTag, StudyHarmonyCoachStyle coachStyle) {
  final ko = _isKoreanLocale(localeTag);
  return switch (coachStyle) {
    StudyHarmonyCoachStyle.supportive => ko ? '?묒썝??肄붿튂' : 'Supportive Coach',
    StudyHarmonyCoachStyle.structured => ko ? '援ъ“??肄붿튂' : 'Structured Coach',
    StudyHarmonyCoachStyle.challengeForward =>
      ko ? '?꾩쟾??肄붿튂' : 'Challenge Coach',
    StudyHarmonyCoachStyle.analytical => ko ? '遺꾩꽍??肄붿튂' : 'Analytical Coach',
    StudyHarmonyCoachStyle.restorative => ko ? '?뚮났??肄붿튂' : 'Restorative Coach',
  };
}

String _coachLine(String localeTag, StudyHarmonyAdaptivePlan plan) {
  final ko = _isKoreanLocale(localeTag);
  return switch (plan.coachStyle) {
    StudyHarmonyCoachStyle.supportive =>
      ko
          ? '?ㅼ닔蹂대떎 ?먮쫫??吏?ㅻ뒗 ??吏묒쨷?댁슂.'
          : 'Protect flow first and let confidence compound.',
    StudyHarmonyCoachStyle.structured =>
      ko
          ? '?쒖꽌瑜?吏?ㅻ㈃ ?ㅻ젰??媛??鍮좊Ⅴ寃?遺숈뼱??'
          : 'Follow the structure and the gains will stick.',
    StudyHarmonyCoachStyle.challengeForward =>
      ko
          ? '?대쾲 ?곗? ?뺣컯??利먭린硫????④퀎 ?щ젮遊낅땲??'
          : 'Lean into the pressure and push for a sharper run.',
    StudyHarmonyCoachStyle.analytical =>
      ko
          ? '?대뵒???붾뱾由щ뒗吏 ?쎌쑝硫댁꽌 ?뺣??섍쾶 媛묐땲??'
          : 'Read the weak point and refine it with precision.',
    StudyHarmonyCoachStyle.restorative =>
      ko
          ? '臾대꼫吏吏 ?딄쾶 ?쒗룷瑜??섏갼???곗엯?덈떎.'
          : 'This run is about rebuilding rhythm without tilt.',
  };
}

String _pacingPlanLabel(
  String localeTag,
  StudyHarmonyDifficultyPlan difficultyPlan,
) {
  final segments = difficultyPlan.pacingPlan.segments
      .where((segment) => segment.minutes > 0)
      .take(2)
      .map((segment) {
        final label = switch (segment.kind) {
          StudyHarmonyRhythmBeatKind.warmup => 'Warmup',
          StudyHarmonyRhythmBeatKind.tension => 'Tension',
          StudyHarmonyRhythmBeatKind.release => 'Release',
          StudyHarmonyRhythmBeatKind.reward => 'Reward',
        };
        return '$label ${segment.minutes}m';
      })
      .join(' 쨌 ');
  return 'Pacing $segments';
}

String _arcadeRiskLabel(
  String localeTag,
  StudyHarmonyArcadeRiskStyle riskStyle,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (riskStyle) {
    StudyHarmonyArcadeRiskStyle.forgiving => ko ? '由ъ뒪????쓬' : 'Low Risk',
    StudyHarmonyArcadeRiskStyle.balanced => ko ? '由ъ뒪??洹좏삎' : 'Balanced Risk',
    StudyHarmonyArcadeRiskStyle.tense => ko ? '由ъ뒪???믪쓬' : 'High Tension',
    StudyHarmonyArcadeRiskStyle.punishing => ko ? '由ъ뒪??洹뱁븳' : 'Punishing Risk',
  };
}

String _arcadeRewardStyleLabel(
  String localeTag,
  StudyHarmonyArcadeRewardStyle rewardStyle,
) {
  final ko = _isKoreanLocale(localeTag);
  return switch (rewardStyle) {
    StudyHarmonyArcadeRewardStyle.currency => ko ? '肄붿씤 以묒떖' : 'Currency Loop',
    StudyHarmonyArcadeRewardStyle.cosmetic =>
      ko ? '肄붿뒪硫뷀떛 以묒떖' : 'Cosmetic Hunt',
    StudyHarmonyArcadeRewardStyle.title => ko ? '移?샇 以묒떖' : 'Title Hunt',
    StudyHarmonyArcadeRewardStyle.trophy => ko ? '?몃줈??以묒떖' : 'Trophy Run',
    StudyHarmonyArcadeRewardStyle.bundle => ko ? '臾띠쓬 蹂댁긽' : 'Bundle Rewards',
    StudyHarmonyArcadeRewardStyle.prestige =>
      ko ? '紐낆삁 蹂댁긽' : 'Prestige Rewards',
  };
}

List<String> _arcadeRuntimeLabels(
  String localeTag,
  StudyHarmonyArcadeRuntimePlan plan,
) {
  final labels = <String>[];
  if (plan.comboBonusAmount > 0) {
    labels.add('Combo bonus every ${plan.comboBonusEvery}');
  }
  if (plan.missPenaltyLives > 1) {
    labels.add('Miss costs ${plan.missPenaltyLives}');
  }
  if (plan.usesModifierStorm) {
    labels.add('Modifier pulses');
  }
  if (plan.usesGhostPressure) {
    labels.add('Ghost pressure');
  }
  if (plan.usesShopBias) {
    labels.add('Shop-biased loot');
  }
  if (labels.isEmpty) {
    labels.add('Steady ruleset');
  }
  return labels;
}

IconData _arcadeModeIcon(StudyHarmonyArcadeModeDefinition mode) {
  return switch (mode.rewardStyle) {
    StudyHarmonyArcadeRewardStyle.currency => Icons.toll_rounded,
    StudyHarmonyArcadeRewardStyle.cosmetic => Icons.palette_rounded,
    StudyHarmonyArcadeRewardStyle.title => Icons.verified_rounded,
    StudyHarmonyArcadeRewardStyle.trophy => Icons.workspace_premium_rounded,
    StudyHarmonyArcadeRewardStyle.bundle => Icons.inventory_2_rounded,
    StudyHarmonyArcadeRewardStyle.prestige =>
      Icons.local_fire_department_rounded,
  };
}

String _shopStateLabel(
  String localeTag, {
  required StudyHarmonyShopItemDefinition item,
  required StudyHarmonyProgressController progressController,
}) {
  final canPurchase = progressController.canPurchaseShopItem(item);
  final purchased =
      !(_isRepeatableShopItem(item)) &&
      progressController.hasPurchasedUniqueShopItem(item.id);
  if (purchased) {
    return 'Already purchased';
  }
  if (canPurchase) {
    return 'Ready to buy';
  }
  return 'Progress locked';
}

String? _shopLoadoutUnlockId(
  StudyHarmonyShopItemDefinition item,
  StudyHarmonyProgressController progressController,
) {
  for (final unlockId in item.unlockIds) {
    if (studyHarmonyTitlesById.containsKey(unlockId) &&
        progressController.isTitleOwned(unlockId)) {
      return unlockId;
    }
    if (studyHarmonyCosmeticsById.containsKey(unlockId) &&
        progressController.isCosmeticOwned(unlockId)) {
      return unlockId;
    }
  }
  return null;
}

bool _isRewardUnlockEquipped(
  String unlockId,
  StudyHarmonyProgressController progressController,
) {
  if (studyHarmonyTitlesById.containsKey(unlockId)) {
    return progressController.equippedTitleId() == unlockId;
  }
  if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
    return progressController.equippedCosmeticIds().contains(unlockId);
  }
  return false;
}

String? _shopActionLabel(
  String localeTag, {
  required StudyHarmonyShopItemDefinition item,
  required StudyHarmonyProgressController progressController,
}) {
  if (progressController.canPurchaseShopItem(item)) {
    return _isKoreanLocale(localeTag) ? '援щℓ' : 'Buy';
  }
  final unlockId = _shopLoadoutUnlockId(item, progressController);
  if (unlockId == null) {
    return null;
  }
  return _isRewardUnlockEquipped(unlockId, progressController)
      ? (_isKoreanLocale(localeTag) ? '?옣李??섏쓬' : 'Equipped')
      : (_isKoreanLocale(localeTag) ? '?옣李?' : 'Equip');
}

bool _isRepeatableShopItem(StudyHarmonyShopItemDefinition item) {
  return item.kind == StudyHarmonyShopItemKind.consumable ||
      item.kind == StudyHarmonyShopItemKind.booster;
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

StudyHarmonyLessonRecommendation? _primaryStudyHarmonyRecommendation(
  StudyHarmonyLessonRecommendation? continueRecommendation,
  StudyHarmonyLessonRecommendation? reviewRecommendation,
  StudyHarmonyLessonRecommendation? focusRecommendation,
  StudyHarmonyLessonRecommendation? dailyRecommendation,
  StudyHarmonyLessonRecommendation? monthlyTourActionRecommendation,
  StudyHarmonyLessonRecommendation? questChestActionRecommendation,
  StudyHarmonyLessonRecommendation? duetPactRecommendation,
  StudyHarmonyLessonRecommendation? leagueBoostRecommendation,
  StudyHarmonyLessonRecommendation? relayRecommendation,
  StudyHarmonyLessonRecommendation? legendRecommendation,
  StudyHarmonyLessonRecommendation? bossRushRecommendation,
) {
  return continueRecommendation ??
      reviewRecommendation ??
      focusRecommendation ??
      dailyRecommendation ??
      monthlyTourActionRecommendation ??
      questChestActionRecommendation ??
      duetPactRecommendation ??
      leagueBoostRecommendation ??
      relayRecommendation ??
      legendRecommendation ??
      bossRushRecommendation;
}

IconData _recommendationIcon(StudyHarmonyLessonRecommendation recommendation) {
  return switch (recommendation.sessionMode) {
    StudyHarmonySessionMode.review => Icons.refresh_rounded,
    StudyHarmonySessionMode.daily => Icons.wb_sunny_rounded,
    StudyHarmonySessionMode.focus => Icons.bolt_rounded,
    StudyHarmonySessionMode.relay => Icons.alt_route_rounded,
    StudyHarmonySessionMode.bossRush => Icons.local_fire_department_rounded,
    StudyHarmonySessionMode.legend => Icons.workspace_premium_rounded,
    StudyHarmonySessionMode.lesson ||
    StudyHarmonySessionMode.legacyLevel => Icons.play_circle_fill_rounded,
  };
}

String _recommendationTitle(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation recommendation,
) {
  return switch (recommendation.sessionMode) {
    StudyHarmonySessionMode.review => l10n.studyHarmonyReviewCardTitle,
    StudyHarmonySessionMode.daily => l10n.studyHarmonyDailyCardTitle,
    StudyHarmonySessionMode.focus => l10n.studyHarmonyFocusCardTitle,
    StudyHarmonySessionMode.relay => l10n.studyHarmonyRelayCardTitle,
    StudyHarmonySessionMode.bossRush => l10n.studyHarmonyBossRushCardTitle,
    StudyHarmonySessionMode.legend => l10n.studyHarmonyLegendCardTitle,
    StudyHarmonySessionMode.lesson ||
    StudyHarmonySessionMode.legacyLevel => l10n.studyHarmonyContinueCardTitle,
  };
}

String _recommendationActionLabel(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation recommendation,
) {
  return switch (recommendation.sessionMode) {
    StudyHarmonySessionMode.review => l10n.studyHarmonyReviewAction,
    StudyHarmonySessionMode.daily => l10n.studyHarmonyDailyAction,
    StudyHarmonySessionMode.focus => l10n.studyHarmonyFocusAction,
    StudyHarmonySessionMode.relay => l10n.studyHarmonyRelayAction,
    StudyHarmonySessionMode.bossRush => l10n.studyHarmonyBossRushAction,
    StudyHarmonySessionMode.legend => l10n.studyHarmonyLegendAction,
    StudyHarmonySessionMode.lesson ||
    StudyHarmonySessionMode.legacyLevel => l10n.studyHarmonyOpenLessonAction,
  };
}

String _recommendationBody(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation recommendation,
) {
  return switch (recommendation.sessionMode) {
    StudyHarmonySessionMode.review => _reviewHint(l10n, recommendation),
    StudyHarmonySessionMode.daily => recommendation.lesson.description,
    StudyHarmonySessionMode.focus => _focusHint(l10n, recommendation),
    StudyHarmonySessionMode.relay => _relayHint(l10n, recommendation),
    StudyHarmonySessionMode.bossRush => _bossRushHint(l10n, recommendation),
    StudyHarmonySessionMode.legend => _legendHint(l10n, recommendation),
    StudyHarmonySessionMode.lesson ||
    StudyHarmonySessionMode.legacyLevel => switch (recommendation.source) {
      StudyHarmonyRecommendationSource.lastPlayed =>
        l10n.studyHarmonyContinueResumeHint,
      StudyHarmonyRecommendationSource.frontier =>
        l10n.studyHarmonyContinueFrontierHint,
      _ => recommendation.lesson.description,
    },
  };
}

_HubRecommendationCopy _recommendationCopy(
  AppLocalizations l10n,
  StudyHarmonyLessonRecommendation recommendation,
) {
  return _HubRecommendationCopy(
    icon: _recommendationIcon(recommendation),
    title: _recommendationTitle(l10n, recommendation),
    headline: recommendation.lesson.title,
    supportingLabel: recommendation.chapter.title,
    body: _recommendationBody(l10n, recommendation),
    actionLabel: _recommendationActionLabel(l10n, recommendation),
    footerLabels: const <String>[],
  );
}
