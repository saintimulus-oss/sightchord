import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'study_harmony/application/study_harmony_session_controller.dart';
import 'study_harmony/content/core_curriculum_catalog.dart';
import 'study_harmony/content/track_generation_profiles.dart';
import 'study_harmony/content/track_pedagogy_profiles.dart';
import 'study_harmony/content/study_harmony_track_catalog.dart';
import 'study_harmony/domain/study_harmony_progress_models.dart';
import 'study_harmony/domain/study_harmony_session_models.dart';
import 'study_harmony/meta/study_harmony_arcade_catalog.dart';
import 'study_harmony/meta/study_harmony_arcade_runtime.dart';
import 'study_harmony/meta/study_harmony_difficulty_design.dart';
import 'study_harmony/meta/study_harmony_personalization.dart';
import 'study_harmony/meta/study_harmony_rewards_catalog.dart';
import 'study_harmony/study_harmony_display_copy.dart';
import 'study_harmony/study_harmony_session_page.dart';
import 'study_harmony/ui/study_harmony_track_expectation_card.dart';

part 'study_harmony/ui/study_harmony_hub_data.dart';
part 'study_harmony/ui/study_harmony_hub_filter_widgets.dart';
part 'study_harmony/ui/study_harmony_hub_featured_cards.dart';
part 'study_harmony/ui/study_harmony_hub_progress_cards.dart';
part 'study_harmony/ui/study_harmony_hub_chapter_cards.dart';

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

ChipThemeData _hubChipTheme(ThemeData theme) {
  final colorScheme = theme.colorScheme;
  return theme.chipTheme.copyWith(
    backgroundColor: colorScheme.surfaceContainerHighest,
    disabledColor: colorScheme.surfaceContainer,
    selectedColor: colorScheme.primaryContainer,
    secondarySelectedColor: colorScheme.primaryContainer,
    side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.28)),
    labelStyle: theme.textTheme.labelMedium?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w700,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
  );
}

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
  const StudyHarmonyPage({
    super.key,
    required this.progressController,
    this.settingsController,
  });

  final StudyHarmonyProgressController progressController;
  final AppSettingsController? settingsController;

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
          settingsController: widget.settingsController,
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
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final success = await widget.progressController.purchaseShopItem(item);
    final equippedUnlockId = success
        ? await _autoEquipPurchasedUnlock(item)
        : null;
    final itemTitle = studyHarmonyShopItemTitleForLocale(localeTag, item);
    if (!mounted) {
      return;
    }
    final snackBar = SnackBar(
      content: Text(
        success
            ? (equippedUnlockId == null
                  ? l10n.studyHarmonyPurchaseSuccess(itemTitle)
                  : l10n.studyHarmonyPurchaseAndEquipSuccess(itemTitle))
            : l10n.studyHarmonyPurchaseFailure(itemTitle),
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
    final l10n = AppLocalizations.of(context)!;
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
    final rewardTitle = studyHarmonyRewardTitleForLocale(
      localeTag,
      rewardId: unlockId,
      fallbackTitle:
          studyHarmonyTitlesById[unlockId]?.title ??
          studyHarmonyCosmeticsById[unlockId]?.title ??
          unlockId,
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.studyHarmonyRewardEquipped(rewardTitle))),
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
    final coursesByTrackId =
        _coursesByTrackId ?? buildStudyHarmonyTrackCourses(l10n);
    final selectedTrackId = _trackIdForHubTrack(_selectedTrack);
    final course =
        coursesByTrackId[selectedTrackId] ??
        coursesByTrackId[studyHarmonyCoreTrackId]!;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final pedagogyProfile = trackPedagogyProfileForTrack(l10n, course.trackId);
    final trackRecommendationProfile = trackRecommendationProfileForTrack(
      l10n,
      course.trackId,
    );
    final soundProfile = trackSoundProfileForTrack(l10n, course.trackId);
    final trackFilterOptions = <_TrackFilterChipData>[
      _TrackFilterChipData(
        track: _StudyHarmonyHubTrack.core,
        label: l10n.studyHarmonyTrackCoreFilterLabel,
        icon: Icons.school_rounded,
      ),
      _TrackFilterChipData(
        track: _StudyHarmonyHubTrack.pop,
        label: l10n.studyHarmonyTrackPopFilterLabel,
        icon: Icons.graphic_eq_rounded,
      ),
      _TrackFilterChipData(
        track: _StudyHarmonyHubTrack.jazz,
        label: l10n.studyHarmonyTrackJazzFilterLabel,
        icon: Icons.music_note_rounded,
      ),
      _TrackFilterChipData(
        track: _StudyHarmonyHubTrack.classical,
        label: l10n.studyHarmonyTrackClassicalFilterLabel,
        icon: Icons.library_music_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.studyHarmonyTitle)),
      body: AnimatedBuilder(
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
          final leagueXpBoost = widget.progressController
              .currentLeagueXpBoost();
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
          final quickRoutineRecommendation =
              (questChestStatus.ready ? dailyRecommendation : null) ??
              reviewRecommendation ??
              dailyRecommendation ??
              focusRecommendation ??
              continueRecommendation;
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
          final dailyCompletedToday = widget.progressController
              .isDailyChallengeCompletedToday();
          final streakSavers = widget.progressController
              .currentStreakSaverCount();
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
            if (legendaryChapters > 0)
              _HubMetricChipData(
                icon: Icons.workspace_premium_rounded,
                label: l10n.studyHarmonyProgressLegendCrowns(legendaryChapters),
              ),
          ].take(6).toList(growable: false);
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
          final rewardMetrics = widget.progressController
              .currentRewardMetrics();
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
                rewardMetrics.modeClearCounts[StudyHarmonySessionMode
                    .bossRush] ??
                legendaryChapters,
            currentStreak: dailyStreak,
          );
          final isEarlyJourney =
              clearedLessons < 6 &&
              dueReviews <= 2 &&
              widget.progressController.shopPurchaseCount() == 0;
          final showMetaSystems = !isEarlyJourney;
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
          final ownedTitles = <StudyHarmonyTitleDefinition>[
            for (final titleId in ownedTitleIds)
              if (studyHarmonyTitlesById[titleId] != null)
                studyHarmonyTitlesById[titleId]!,
          ]..sort((left, right) => left.title.compareTo(right.title));
          final ownedCosmetics = <StudyHarmonyCosmeticDefinition>[
            for (final cosmeticId in ownedCosmeticIds)
              if (studyHarmonyCosmeticsById[cosmeticId] != null)
                studyHarmonyCosmeticsById[cosmeticId]!,
          ]..sort((left, right) => left.title.compareTo(right.title));
          final whyItMattersRecommendation =
              primaryRecommendation ??
              continueRecommendation ??
              quickRoutineRecommendation ??
              reviewRecommendation ??
              dailyRecommendation;

          return LayoutBuilder(
            builder: (context, constraints) {
              const sectionCardSpacing = 14.0;
              const pagePadding = EdgeInsets.fromLTRB(24, 24, 24, 36);
              final horizontalContentPadding =
                  pagePadding.left + pagePadding.right;
              final contentWidth = min(constraints.maxWidth, 1240.0);
              final availableContentWidth = max(
                0.0,
                contentWidth - horizontalContentPadding,
              );
              final actionColumns = _columnsFor(
                availableContentWidth,
                compact: 1,
                medium: 2,
                large: 3,
              );
              final chapterColumns = _columnsFor(
                availableContentWidth,
                compact: 1,
                medium: 2,
                large: 2,
              );
              final actionWidth = _cardWidthFor(
                availableContentWidth,
                actionColumns,
                spacing: sectionCardSpacing,
              );
              final chapterWidth = _cardWidthFor(
                availableContentWidth,
                chapterColumns,
                spacing: sectionCardSpacing,
              );
              final heroWidth = availableContentWidth;
              final chipTheme = _hubChipTheme(theme);

              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: contentWidth,
                  child: ChipTheme(
                    data: chipTheme,
                    child: SingleChildScrollView(
                      key: const ValueKey('study-harmony-page'),
                      padding: pagePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: heroWidth,
                            child: _HubHeroCard(
                              eyebrow: l10n.studyHarmonyHubHeroEyebrow,
                              title: course.title,
                              subtitle:
                                  _selectedTrack == _StudyHarmonyHubTrack.core
                                  ? l10n.studyHarmonyHubHeroBody
                                  : trackRecommendationProfile.heroHeadline,
                              body: selectedTrackDescription,
                              metrics: heroMetrics,
                              recommendationCopy: null,
                              recommendationOnPressed: null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.studyHarmonyTrackFilterLabel,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _TrackFilterBar(
                            selectedTrack: _selectedTrack,
                            options: trackFilterOptions,
                            onChanged: (track) {
                              setState(() {
                                _selectedTrack = track;
                              });
                            },
                          ),
                          if (_selectedTrack != _StudyHarmonyHubTrack.core) ...[
                            const SizedBox(height: 16),
                            StudyHarmonyTrackExpectationCard(
                              key: ValueKey(
                                'study-harmony-track-expectation-$selectedTrackId',
                              ),
                              pedagogyProfile: pedagogyProfile,
                              recommendationProfile: trackRecommendationProfile,
                              soundProfile: soundProfile,
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            l10n.studyHarmonyHubStartHereTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: sectionCardSpacing,
                            runSpacing: sectionCardSpacing,
                            children: [
                              SizedBox(
                                width: actionWidth,
                                child: _HubActionCard(
                                  key: const ValueKey(
                                    'study-harmony-quickstart-primary-card',
                                  ),
                                  icon: Icons.play_circle_fill_rounded,
                                  title: l10n.studyHarmonyHubNextLessonTitle,
                                  headline:
                                      primaryRecommendation?.lesson.title ??
                                      l10n.studyHarmonyContinueCardTitle,
                                  supportingLabel:
                                      primaryRecommendation?.chapter.title ??
                                      course.title,
                                  body: primaryRecommendation == null
                                      ? trackRecommendationProfile
                                            .quickPracticeCue
                                      : _recommendationBody(
                                          l10n,
                                          primaryRecommendation,
                                        ),
                                  footerLabels: [
                                    _runtimeTuningSummary(l10n, runtimeTuning),
                                    if (primaryRecommendation != null)
                                      _sessionModeLabel(
                                        l10n,
                                        primaryRecommendation.sessionMode,
                                      ),
                                  ],
                                  actionLabel: primaryRecommendation == null
                                      ? null
                                      : l10n.studyHarmonyHubPlayNowAction,
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
                                    'study-harmony-quickstart-why-card',
                                  ),
                                  icon: Icons.lightbulb_outline_rounded,
                                  title: l10n.studyHarmonyHubWhyItMattersTitle,
                                  headline:
                                      whyItMattersRecommendation
                                          ?.lesson
                                          .title ??
                                      trackRecommendationProfile.heroHeadline,
                                  supportingLabel:
                                      whyItMattersRecommendation
                                          ?.lesson
                                          .objectiveLabel ??
                                      course.title,
                                  body:
                                      whyItMattersRecommendation
                                          ?.lesson
                                          .description ??
                                      trackRecommendationProfile.heroBody,
                                  footerLabels: [
                                    for (final focus
                                        in pedagogyProfile.focusPoints.take(2))
                                      focus,
                                  ],
                                  onPressed: null,
                                  showAction: false,
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
                                  title: l10n.studyHarmonyHubQuickPracticeTitle,
                                  headline:
                                      quickRoutineRecommendation
                                          ?.lesson
                                          .title ??
                                      course.title,
                                  supportingLabel:
                                      quickRoutineRecommendation
                                          ?.chapter
                                          .title ??
                                      course.title,
                                  body: dueReviews > 0
                                      ? _reviewHint(l10n, reviewRecommendation)
                                      : (dailyCompletedToday
                                            ? l10n.studyHarmonyDailyCardHintCompleted
                                            : l10n.studyHarmonyDailyCardHint),
                                  footerLabels: [
                                    if (dueReviews > 0)
                                      l10n.studyHarmonyProgressReviewsReady(
                                        dueReviews,
                                      )
                                    else if (dailyStreak > 0)
                                      l10n.studyHarmonyProgressStreak(
                                        dailyStreak,
                                      ),
                                    _coachLabel(l10n, adaptivePlan.coachStyle),
                                  ],
                                  actionLabel:
                                      quickRoutineRecommendation == null
                                      ? null
                                      : l10n.studyHarmonyHubKeepMomentumAction,
                                  onPressed: quickRoutineRecommendation == null
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
                          const SizedBox(height: 24),
                          Text(
                            l10n.studyHarmonyHubChapterSectionTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (_selectedTrack != _StudyHarmonyHubTrack.core) ...[
                            const SizedBox(height: 8),
                            Text(
                              trackRecommendationProfile.quickPracticeCue,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: sectionCardSpacing,
                            runSpacing: sectionCardSpacing,
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
                                    nextLessonLabel: summary.nextLesson == null
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
                          if (!showMetaSystems) ...[
                            const SizedBox(height: 24),
                            SizedBox(
                              width: min(
                                availableContentWidth,
                                actionWidth * (actionColumns > 1 ? 2 : 1) +
                                    (actionColumns > 1
                                        ? sectionCardSpacing
                                        : 0),
                              ),
                              child: _HubActionCard(
                                key: const ValueKey(
                                  'study-harmony-meta-preview',
                                ),
                                icon: Icons.lock_clock_rounded,
                                title: l10n.studyHarmonyHubMetaPreviewTitle,
                                headline:
                                    l10n.studyHarmonyHubMetaPreviewHeadline,
                                supportingLabel: course.title,
                                body: l10n.studyHarmonyHubMetaPreviewBody,
                                footerLabels: [
                                  l10n.studyHarmonyHubNextLessonTitle,
                                  l10n.studyHarmonyHubQuickPracticeTitle,
                                ],
                                onPressed: null,
                                showAction: false,
                              ),
                            ),
                          ] else ...[
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
                                        l10n.studyHarmonyClearTitleAction,
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
                                      label: Text(
                                        studyHarmonyRewardTitleForLocale(
                                          localeTag,
                                          rewardId: title.id,
                                          fallbackTitle: title.title,
                                        ),
                                      ),
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
                                      label: Text(
                                        studyHarmonyRewardTitleForLocale(
                                          localeTag,
                                          rewardId: cosmetic.id,
                                          fallbackTitle: cosmetic.title,
                                        ),
                                      ),
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
                              l10n.studyHarmonyPlayerDeckTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
                              children: [
                                SizedBox(
                                  width: actionWidth,
                                  child: _HubActionCard(
                                    key: const ValueKey(
                                      'study-harmony-player-card',
                                    ),
                                    icon: Icons.person_rounded,
                                    title: l10n.studyHarmonyPlayerDeckCardTitle,
                                    headline:
                                        (equippedTitle == null
                                            ? null
                                            : studyHarmonyRewardTitleForLocale(
                                                localeTag,
                                                rewardId: equippedTitle.id,
                                                fallbackTitle:
                                                    equippedTitle.title,
                                              )) ??
                                        (leadTitle == null
                                            ? null
                                            : studyHarmonyRewardTitleForLocale(
                                                localeTag,
                                                rewardId: leadTitle.id,
                                                fallbackTitle: leadTitle.title,
                                              )) ??
                                        _playStyleLabel(
                                          l10n,
                                          adaptiveProfile.playStyle,
                                        ),
                                    supportingLabel:
                                        equippedCosmetics.isNotEmpty
                                        ? studyHarmonyRewardTitleForLocale(
                                            localeTag,
                                            rewardId:
                                                equippedCosmetics.first.id,
                                            fallbackTitle:
                                                equippedCosmetics.first.title,
                                          )
                                        : _coachLabel(
                                            l10n,
                                            adaptivePlan.coachStyle,
                                          ),
                                    body:
                                        (equippedTitle == null
                                            ? null
                                            : studyHarmonyRewardDescriptionForLocale(
                                                localeTag,
                                                rewardId: equippedTitle.id,
                                                fallbackDescription:
                                                    equippedTitle.description,
                                              )) ??
                                        _coachLine(l10n, adaptivePlan),
                                    footerLabels: [
                                      _rewardFocusLabel(
                                        l10n,
                                        adaptivePlan
                                            .rewardEmphasis
                                            .primaryFocus,
                                      ),
                                      for (final cosmetic
                                          in equippedCosmetics.take(2))
                                        studyHarmonyRewardTitleForLocale(
                                          localeTag,
                                          rewardId: cosmetic.id,
                                          fallbackTitle: cosmetic.title,
                                        ),
                                      if (equippedCosmetics.isEmpty &&
                                          leadCosmetic != null)
                                        studyHarmonyRewardTitleForLocale(
                                          localeTag,
                                          rewardId: leadCosmetic.id,
                                          fallbackTitle: leadCosmetic.title,
                                        ),
                                      if (upcomingRewards.isNotEmpty)
                                        _nextUnlockShortLabel(
                                          l10n,
                                          localeTag,
                                          upcomingRewards.first,
                                        ),
                                    ],
                                    actionLabel: l10n
                                        .studyHarmonyPlayerDeckOverviewAction,
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
                                    title: l10n.studyHarmonyRunDirectorTitle,
                                    headline: _difficultyLaneLabel(
                                      l10n,
                                      difficultyPlan.difficultyLane,
                                    ),
                                    supportingLabel: _runtimeTuningSummary(
                                      l10n,
                                      runtimeTuning,
                                    ),
                                    body: runtimeTuning.rationale.first,
                                    footerLabels: [
                                      _pressureTierLabel(
                                        l10n,
                                        difficultyPlan.pressureTier,
                                      ),
                                      _forgivenessTierLabel(
                                        l10n,
                                        difficultyPlan.forgivenessTier,
                                      ),
                                      _comboGoalLabel(
                                        l10n,
                                        difficultyPlan.comboTarget,
                                      ),
                                      _pacingPlanLabel(l10n, difficultyPlan),
                                    ],
                                    actionLabel: primaryRecommendation == null
                                        ? null
                                        : l10n.studyHarmonyRunDirectorAction,
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
                                    title: l10n.studyHarmonyGameEconomyTitle,
                                    headline: _currencyBalanceLabel(
                                      localeTag,
                                      'currency.studyCoin',
                                      rewardBalances['currency.studyCoin'] ?? 0,
                                    ),
                                    supportingLabel: _currencyBalanceLabel(
                                      localeTag,
                                      'currency.starShard',
                                      rewardBalances['currency.starShard'] ?? 0,
                                    ),
                                    body: l10n.studyHarmonyGameEconomyBody,
                                    footerLabels: [
                                      _currencyBalanceLabel(
                                        localeTag,
                                        'currency.focusToken',
                                        rewardBalances['currency.focusToken'] ??
                                            0,
                                      ),
                                      _currencyBalanceLabel(
                                        localeTag,
                                        'currency.rerollToken',
                                        rewardBalances['currency.rerollToken'] ??
                                            0,
                                      ),
                                      _currencyBalanceLabel(
                                        localeTag,
                                        'currency.streakShield',
                                        rewardBalances['currency.streakShield'] ??
                                            0,
                                      ),
                                      l10n.studyHarmonyGameEconomyTitlesOwned(
                                        ownedTitles.length,
                                      ),
                                      l10n.studyHarmonyGameEconomyCosmeticsOwned(
                                        ownedCosmetics.length,
                                      ),
                                      l10n.studyHarmonyGameEconomyShopPurchases(
                                        widget.progressController
                                            .shopPurchaseCount(),
                                      ),
                                    ],
                                    actionLabel: l10n
                                        .studyHarmonyGameEconomyWalletAction,
                                    onPressed: null,
                                    showAction: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.studyHarmonyArcadeSpotlightTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
                              children: [
                                for (final featured in featuredArcadeModes)
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: ValueKey(
                                        'study-harmony-arcade-card-${featured.mode.id}',
                                      ),
                                      icon: _arcadeModeIcon(featured.mode),
                                      title:
                                          studyHarmonyArcadeModeTitleForLocale(
                                            localeTag,
                                            featured.mode,
                                          ),
                                      headline:
                                          studyHarmonyArcadeModeHeadlineForLocale(
                                            localeTag,
                                            featured.mode,
                                          ),
                                      supportingLabel: _arcadeRewardStyleLabel(
                                        l10n,
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
                                      body: studyHarmonyArcadeModeLoopForLocale(
                                        localeTag,
                                        featured.mode,
                                      ),
                                      footerLabels: [
                                        _arcadeRiskLabel(
                                          l10n,
                                          featured.mode.riskStyle,
                                        ),
                                        ..._arcadeRuntimeLabels(
                                          l10n,
                                          buildStudyHarmonyArcadeRuntimePlan(
                                            modeId: featured.mode.id,
                                            baseStartingLives: runtimeTuning
                                                .recommendedStartingLives,
                                            baseGoalCorrectAnswers: runtimeTuning
                                                .recommendedGoalCorrectAnswers,
                                            progress: arcadeProgress,
                                          ),
                                        ).take(1),
                                        ...featured.mode.unlockRules
                                            .map(
                                              (rule) =>
                                                  studyHarmonyArcadeUnlockLabelForLocale(
                                                    localeTag,
                                                    rule,
                                                  ),
                                            )
                                            .take(1),
                                      ],
                                      actionLabel:
                                          l10n.studyHarmonyArcadePlayAction,
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
                                      title:
                                          studyHarmonyArcadePlaylistTitleForLocale(
                                            localeTag,
                                            playlist.playlist,
                                          ),
                                      headline:
                                          studyHarmonyArcadePlaylistSubtitleForLocale(
                                            localeTag,
                                            playlist.playlist,
                                          ),
                                      supportingLabel:
                                          studyHarmonyArcadePlaylistCueForLocale(
                                            localeTag,
                                            playlist.playlist,
                                          ),
                                      body:
                                          studyHarmonyArcadePlaylistBodyForLocale(
                                            localeTag,
                                            playlist.playlist,
                                          ),
                                      footerLabels: [
                                        l10n.studyHarmonyArcadeModeCount(
                                          playlist.playlist.modeIds.length,
                                        ),
                                      ],
                                      actionLabel:
                                          l10n.studyHarmonyArcadePlaylistAction,
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
                              l10n.studyHarmonyNightMarketTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
                              children: [
                                for (final item in featuredShopItems)
                                  SizedBox(
                                    width: actionWidth,
                                    child: _HubActionCard(
                                      key: ValueKey(
                                        'study-harmony-shop-card-${item.id}',
                                      ),
                                      icon: Icons.storefront_rounded,
                                      title: studyHarmonyShopItemTitleForLocale(
                                        localeTag,
                                        item,
                                      ),
                                      headline:
                                          '${item.priceAmount} ${studyHarmonyCurrencyTitleForLocale(localeTag, item.priceCurrencyId)}',
                                      supportingLabel: _shopStateLabel(
                                        l10n,
                                        item: item,
                                        progressController:
                                            widget.progressController,
                                      ),
                                      body:
                                          studyHarmonyShopItemDescriptionForLocale(
                                            localeTag,
                                            item,
                                          ),
                                      footerLabels: [
                                        for (final grant in item.grants)
                                          _currencyGrantLabel(localeTag, grant),
                                        if (item.unlockIds.isNotEmpty)
                                          studyHarmonyRewardTitleForLocale(
                                            localeTag,
                                            rewardId: item.unlockIds.first,
                                            fallbackTitle: item.unlockIds.first,
                                          ),
                                      ],
                                      actionLabel: _shopActionLabel(
                                        l10n,
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
                            Wrap(
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
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
                                    actionLabel: l10n.studyHarmonyLeagueAction,
                                    onPressed: leagueBoostRecommendation == null
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
                                        continueRecommendation?.lesson.title ??
                                        l10n.studyHarmonyContinueCardTitle,
                                    supportingLabel:
                                        continueRecommendation?.chapter.title ??
                                        course.title,
                                    body: _continueHint(
                                      l10n,
                                      continueRecommendation,
                                    ),
                                    footerLabels:
                                        continueRecommendation != null &&
                                            continueRecommendation.source ==
                                                StudyHarmonyRecommendationSource
                                                    .frontier
                                        ? <String>[
                                            l10n.studyHarmonyChapterNextUp(
                                              continueRecommendation
                                                  .lesson
                                                  .title,
                                            ),
                                          ]
                                        : const <String>[],
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
                                        monthlyTourActionRecommendation == null
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
                                    supportingLabel: relayRecommendation == null
                                        ? course.title
                                        : l10n.studyHarmonyRelayChapterSpreadLabel(
                                            {
                                              for (final lesson
                                                  in relayRecommendation
                                                      .resolvedSourceLessons)
                                                lesson.chapterId,
                                            }.length,
                                          ),
                                    body: _relayHint(l10n, relayRecommendation),
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
                                    actionLabel: l10n.studyHarmonyLegendAction,
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
                                        bossRushRecommendation?.lesson.title ??
                                        l10n.studyHarmonyBossRushCardTitle,
                                    supportingLabel:
                                        bossRushRecommendation?.chapter.title ??
                                        course.title,
                                    body: _bossRushHint(
                                      l10n,
                                      bossRushRecommendation,
                                    ),
                                    footerLabels: bossRushRecommendation == null
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
                                    body: _focusHint(l10n, focusRecommendation),
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
                                    actionLabel: l10n.studyHarmonyReviewAction,
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
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
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
                                    headline: _duetPactHeadline(l10n, duetPact),
                                    supportingLabel: l10n
                                        .studyHarmonyDuetRewardLabel(
                                          duetPact.rewardLeagueXp,
                                        ),
                                    body: _duetPactBody(
                                      l10n,
                                      duetPact,
                                      dailyCompletedToday: dailyCompletedToday,
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
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
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
                              spacing: sectionCardSpacing,
                              runSpacing: sectionCardSpacing,
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
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
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

double _cardWidthFor(double width, int columns, {double spacing = 14}) {
  if (columns <= 1) {
    return width;
  }
  return (width - ((columns - 1) * spacing)) / columns;
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

String _playStyleLabel(AppLocalizations l10n, StudyHarmonyPlayStyle playStyle) {
  return l10n.studyHarmonyPlayStyleLabel(playStyle.name);
}

String _rewardFocusLabel(AppLocalizations l10n, StudyHarmonyRewardFocus focus) {
  return l10n.studyHarmonyRewardFocusLabel(focus.name);
}

String _nextUnlockShortLabel(
  AppLocalizations l10n,
  String localeTag,
  StudyHarmonyRewardCandidate reward,
) {
  final progress = (reward.progressFraction * 100).round();
  final rewardTitle = studyHarmonyRewardTitleForLocale(
    localeTag,
    rewardId: reward.id,
    fallbackTitle: reward.title,
  );
  return l10n.studyHarmonyNextUnlockProgressLabel(rewardTitle, progress);
}

String _currencyBalanceLabel(
  String localeTag,
  StudyHarmonyCurrencyId currencyId,
  int balance,
) {
  return '${studyHarmonyCurrencyTitleForLocale(localeTag, currencyId)} $balance';
}

String _currencyGrantLabel(String localeTag, StudyHarmonyRewardGrant grant) {
  return '${studyHarmonyCurrencyTitleForLocale(localeTag, grant.currencyId)} +${grant.amount}';
}

String _difficultyLaneLabel(
  AppLocalizations l10n,
  StudyHarmonyDifficultyLane lane,
) {
  return l10n.studyHarmonyDifficultyLaneLabel(lane.name);
}

String _pressureTierLabel(
  AppLocalizations l10n,
  StudyHarmonyPressureTier tier,
) {
  return l10n.studyHarmonyPressureTierLabel(tier.name);
}

String _forgivenessTierLabel(
  AppLocalizations l10n,
  StudyHarmonyForgivenessTier tier,
) {
  return l10n.studyHarmonyForgivenessTierLabel(tier.name);
}

String _comboGoalLabel(AppLocalizations l10n, int comboTarget) {
  return l10n.studyHarmonyComboGoalLabel(comboTarget);
}

String _runtimeTuningSummary(
  AppLocalizations l10n,
  StudyHarmonyRuntimeTuning tuning,
) {
  return l10n.studyHarmonyRuntimeTuningSummary(
    tuning.recommendedStartingLives,
    tuning.recommendedGoalCorrectAnswers,
  );
}

String _coachLabel(AppLocalizations l10n, StudyHarmonyCoachStyle coachStyle) {
  return l10n.studyHarmonyCoachLabel(coachStyle.name);
}

String _coachLine(AppLocalizations l10n, StudyHarmonyAdaptivePlan plan) {
  return l10n.studyHarmonyCoachLine(plan.coachStyle.name);
}

String _pacingPlanLabel(
  AppLocalizations l10n,
  StudyHarmonyDifficultyPlan difficultyPlan,
) {
  final segments = difficultyPlan.pacingPlan.segments
      .where((segment) => segment.minutes > 0)
      .take(2)
      .map(
        (segment) => l10n.studyHarmonyPacingSegmentLabel(
          segment.kind.name,
          segment.minutes,
        ),
      )
      .join(', ');
  return l10n.studyHarmonyPacingSummaryLabel(segments);
}

String _arcadeRiskLabel(
  AppLocalizations l10n,
  StudyHarmonyArcadeRiskStyle riskStyle,
) {
  return l10n.studyHarmonyArcadeRiskLabel(riskStyle.name);
}

String _arcadeRewardStyleLabel(
  AppLocalizations l10n,
  StudyHarmonyArcadeRewardStyle rewardStyle,
) {
  return l10n.studyHarmonyArcadeRewardStyleLabel(rewardStyle.name);
}

List<String> _arcadeRuntimeLabels(
  AppLocalizations l10n,
  StudyHarmonyArcadeRuntimePlan plan,
) {
  final labels = <String>[];
  if (plan.comboBonusAmount > 0) {
    labels.add(
      l10n.studyHarmonyArcadeRuntimeComboBonusLabel(plan.comboBonusEvery),
    );
  }
  if (plan.missPenaltyLives > 1) {
    labels.add(
      l10n.studyHarmonyArcadeRuntimeMissCostLabel(plan.missPenaltyLives),
    );
  }
  if (plan.usesModifierStorm) {
    labels.add(l10n.studyHarmonyArcadeRuntimeModifierPulses);
  }
  if (plan.usesGhostPressure) {
    labels.add(l10n.studyHarmonyArcadeRuntimeGhostPressure);
  }
  if (plan.usesShopBias) {
    labels.add(l10n.studyHarmonyArcadeRuntimeShopBiasedLoot);
  }
  if (labels.isEmpty) {
    labels.add(l10n.studyHarmonyArcadeRuntimeSteadyRuleset);
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
  AppLocalizations l10n, {
  required StudyHarmonyShopItemDefinition item,
  required StudyHarmonyProgressController progressController,
}) {
  final canPurchase = progressController.canPurchaseShopItem(item);
  final purchased =
      !(_isRepeatableShopItem(item)) &&
      progressController.hasPurchasedUniqueShopItem(item.id);
  if (purchased) {
    return l10n.studyHarmonyShopStateLabel('alreadyPurchased');
  }
  if (canPurchase) {
    return l10n.studyHarmonyShopStateLabel('readyToBuy');
  }
  return l10n.studyHarmonyShopStateLabel('progressLocked');
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
  AppLocalizations l10n, {
  required StudyHarmonyShopItemDefinition item,
  required StudyHarmonyProgressController progressController,
}) {
  if (progressController.canPurchaseShopItem(item)) {
    return l10n.studyHarmonyShopActionLabel('buy');
  }
  final unlockId = _shopLoadoutUnlockId(item, progressController);
  if (unlockId == null) {
    return null;
  }
  return _isRewardUnlockEquipped(unlockId, progressController)
      ? l10n.studyHarmonyShopActionLabel('equipped')
      : l10n.studyHarmonyShopActionLabel('equip');
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
  if (monthlyTour.goals.isEmpty) {
    return l10n.studyHarmonyTourEmptyBody;
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
  if (monthlyTour.goals.isNotEmpty) {
    final pendingGoal = monthlyTour.goals.firstWhere(
      (goal) => !goal.completed,
      orElse: () => monthlyTour.goals.first,
    );
    labels.add(_monthlyTourGoalLabel(l10n, pendingGoal));
  }
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
