import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/study_harmony_progress_store.dart';
import '../domain/study_harmony_progress_models.dart';
import '../domain/study_harmony_session_models.dart';
import '../meta/study_harmony_rewards_catalog.dart';

typedef StudyHarmonyNowProvider = DateTime Function();

enum StudyHarmonyRecommendationSource {
  lastPlayed,
  frontier,
  reviewQueue,
  weakSpot,
  dailySeed,
}

enum StudyHarmonyQuestKind { dailyStreak, frontierLesson, chapterStars }

enum StudyHarmonyMilestoneKind {
  lessonPath,
  starCollector,
  streakLegend,
  masteryScholar,
  relayRunner,
}

enum StudyHarmonyWeeklyGoalKind { activeDays, dailyClears, focusSprint }

enum StudyHarmonyMonthlyGoalKind { activeDays, questChests, spotlightClears }

enum StudyHarmonyLeagueTier { rookie, bronze, silver, gold, diamond }

@immutable
class StudyHarmonySkillGainSummary {
  const StudyHarmonySkillGainSummary({
    required this.skillId,
    required this.beforeScore,
    required this.afterScore,
    required this.delta,
    required this.recentAccuracy,
  });

  final StudyHarmonySkillTag skillId;
  final double beforeScore;
  final double afterScore;
  final double delta;
  final double recentAccuracy;
}

@immutable
class StudyHarmonySessionProgressEffect {
  const StudyHarmonySessionProgressEffect({
    required this.mode,
    required this.sessionStars,
    required this.sessionRank,
    this.skillGains = const <StudyHarmonySkillGainSummary>[],
    this.focusSkillTags = const <StudyHarmonySkillTag>{},
    this.reviewReason,
    this.dailyDateKey,
    this.bestStars,
    this.bestRank,
    this.personalBestImproved = false,
    this.countsTowardLessonProgress = false,
    this.rewardBundles = const <StudyHarmonyRewardBundleDefinition>[],
    this.currencyGrants = const <StudyHarmonyRewardGrant>[],
    this.currencyBalances = const <StudyHarmonyCurrencyId, int>{},
    this.newlyUnlockedRewards = const <StudyHarmonyRewardCandidate>[],
    this.featuredRewardChases = const <StudyHarmonyRewardCandidate>[],
    this.dailyChallengeCompleted = false,
    this.focusSprintCompleted = false,
    this.dailyStreakCount,
    this.bestDailyStreakCount,
    this.newlyUnlockedMilestoneIds = const <String>[],
    this.weeklyRewardUnlocked = false,
    this.streakSaverUsed = false,
    this.streakSaverCount = 0,
    this.relayWinCount,
    this.weeklyLeagueScore = 0,
    this.weeklyLeagueScoreDelta = 0,
    this.weeklyLeagueTier = StudyHarmonyLeagueTier.rookie,
    this.promotedLeagueTier,
    this.dailyQuestChestOpened = false,
    this.questChestCount = 0,
    this.questChestLeagueXpBonus = 0,
    this.leagueXpBoostUnlocked = false,
    this.leagueXpBoostChargeCount = 0,
    this.leagueXpBoostAppliedBonus = 0,
    this.monthlyTourRewardUnlocked = false,
    this.monthlyTourLeagueXpBonus = 0,
    this.monthlyTourStreakSaverCount = 0,
    this.duetPactActiveToday = false,
    this.duetPactCurrentStreak = 0,
    this.duetPactBestStreak = 0,
    this.duetPactRewardUnlocked = false,
    this.duetPactLeagueXpBonus = 0,
  });

  final StudyHarmonySessionMode mode;
  final int sessionStars;
  final String sessionRank;
  final List<StudyHarmonySkillGainSummary> skillGains;
  final Set<StudyHarmonySkillTag> focusSkillTags;
  final String? reviewReason;
  final String? dailyDateKey;
  final int? bestStars;
  final String? bestRank;
  final bool personalBestImproved;
  final bool countsTowardLessonProgress;
  final List<StudyHarmonyRewardBundleDefinition> rewardBundles;
  final List<StudyHarmonyRewardGrant> currencyGrants;
  final Map<StudyHarmonyCurrencyId, int> currencyBalances;
  final List<StudyHarmonyRewardCandidate> newlyUnlockedRewards;
  final List<StudyHarmonyRewardCandidate> featuredRewardChases;
  final bool dailyChallengeCompleted;
  final bool focusSprintCompleted;
  final int? dailyStreakCount;
  final int? bestDailyStreakCount;
  final List<String> newlyUnlockedMilestoneIds;
  final bool weeklyRewardUnlocked;
  final bool streakSaverUsed;
  final int streakSaverCount;
  final int? relayWinCount;
  final int weeklyLeagueScore;
  final int weeklyLeagueScoreDelta;
  final StudyHarmonyLeagueTier weeklyLeagueTier;
  final StudyHarmonyLeagueTier? promotedLeagueTier;
  final bool dailyQuestChestOpened;
  final int questChestCount;
  final int questChestLeagueXpBonus;
  final bool leagueXpBoostUnlocked;
  final int leagueXpBoostChargeCount;
  final int leagueXpBoostAppliedBonus;
  final bool monthlyTourRewardUnlocked;
  final int monthlyTourLeagueXpBonus;
  final int monthlyTourStreakSaverCount;
  final bool duetPactActiveToday;
  final int duetPactCurrentStreak;
  final int duetPactBestStreak;
  final bool duetPactRewardUnlocked;
  final int duetPactLeagueXpBonus;
}

@immutable
class StudyHarmonyLessonRecommendation {
  const StudyHarmonyLessonRecommendation({
    required this.lesson,
    required this.chapter,
    required this.source,
    this.sessionMode = StudyHarmonySessionMode.lesson,
    this.sourceLessons = const <StudyHarmonyLessonDefinition>[],
    this.focusSkillTags = const <StudyHarmonySkillTag>{},
    this.reviewEntry,
    this.reviewReason,
    this.dailyDateKey,
    this.seedValue,
  });

  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonyChapterDefinition chapter;
  final StudyHarmonyRecommendationSource source;
  final StudyHarmonySessionMode sessionMode;
  final List<StudyHarmonyLessonDefinition> sourceLessons;
  final Set<StudyHarmonySkillTag> focusSkillTags;
  final StudyHarmonyReviewQueuePlaceholderEntry? reviewEntry;
  final String? reviewReason;
  final String? dailyDateKey;
  final int? seedValue;

  List<StudyHarmonyLessonDefinition> get resolvedSourceLessons =>
      sourceLessons.isEmpty
      ? <StudyHarmonyLessonDefinition>[lesson]
      : sourceLessons;
}

@immutable
class StudyHarmonyChapterProgressSummaryView {
  const StudyHarmonyChapterProgressSummaryView({
    required this.chapter,
    required this.lessonCount,
    required this.clearedLessonCount,
    required this.starCount,
    required this.masteryTier,
    required this.unlocked,
    this.nextLesson,
  });

  final StudyHarmonyChapterDefinition chapter;
  final int lessonCount;
  final int clearedLessonCount;
  final int starCount;
  final StudyHarmonyChapterMasteryTier masteryTier;
  final bool unlocked;
  final StudyHarmonyLessonDefinition? nextLesson;

  bool get isCompleted => lessonCount > 0 && clearedLessonCount >= lessonCount;

  double get progressFraction =>
      lessonCount == 0 ? 0 : clearedLessonCount / lessonCount;
}

@immutable
class StudyHarmonyQuestProgressView {
  const StudyHarmonyQuestProgressView({
    required this.kind,
    required this.current,
    required this.target,
    this.lesson,
    this.chapter,
    this.completedToday = false,
    this.countsTowardChest = false,
  });

  final StudyHarmonyQuestKind kind;
  final int current;
  final int target;
  final StudyHarmonyLessonDefinition? lesson;
  final StudyHarmonyChapterDefinition? chapter;
  final bool completedToday;
  final bool countsTowardChest;

  bool get completed => current >= target;

  double get progressFraction =>
      target <= 0 ? 0 : (current.clamp(0, target) / target).toDouble();
}

@immutable
class StudyHarmonyMilestoneProgressView {
  const StudyHarmonyMilestoneProgressView({
    required this.id,
    required this.kind,
    required this.current,
    required this.target,
    required this.earnedCount,
    required this.totalTiers,
  });

  final String id;
  final StudyHarmonyMilestoneKind kind;
  final int current;
  final int target;
  final int earnedCount;
  final int totalTiers;

  bool get completedAll => earnedCount >= totalTiers;

  double get progressFraction {
    if (completedAll) {
      return 1;
    }
    return target <= 0 ? 0 : (current.clamp(0, target) / target).toDouble();
  }
}

@immutable
class StudyHarmonyQuestChestProgressView {
  const StudyHarmonyQuestChestProgressView({
    required this.dateKey,
    required this.completedQuestCount,
    required this.totalQuestCount,
    required this.rewardLeagueXp,
    required this.openedCount,
    this.openedToday = false,
  });

  final String dateKey;
  final int completedQuestCount;
  final int totalQuestCount;
  final int rewardLeagueXp;
  final int openedCount;
  final bool openedToday;

  bool get ready => !openedToday && completedQuestCount >= totalQuestCount;

  int get remainingQuestCount => max(0, totalQuestCount - completedQuestCount);

  double get progressFraction {
    if (totalQuestCount <= 0) {
      return 0;
    }
    return (completedQuestCount.clamp(0, totalQuestCount) / totalQuestCount)
        .toDouble();
  }
}

@immutable
class StudyHarmonyLeagueXpBoostProgressView {
  const StudyHarmonyLeagueXpBoostProgressView({
    required this.chargeCount,
    required this.multiplier,
    this.dateKey,
  });

  final int chargeCount;
  final int multiplier;
  final String? dateKey;

  bool get active => chargeCount > 0;

  int bonusForBase(int baseXp) {
    if (baseXp <= 0 || multiplier <= 1) {
      return 0;
    }
    return baseXp * (multiplier - 1);
  }
}

@immutable
class StudyHarmonyWeeklyGoalProgressView {
  const StudyHarmonyWeeklyGoalProgressView({
    required this.kind,
    required this.current,
    required this.target,
    required this.weekKey,
    this.rewardClaimed = false,
  });

  final StudyHarmonyWeeklyGoalKind kind;
  final int current;
  final int target;
  final String weekKey;
  final bool rewardClaimed;

  bool get completed => current >= target;
  bool get rewardReady => completed && !rewardClaimed;

  double get progressFraction =>
      target <= 0 ? 0 : (current.clamp(0, target) / target).toDouble();
}

@immutable
class StudyHarmonyMonthlyGoalProgressView {
  const StudyHarmonyMonthlyGoalProgressView({
    required this.kind,
    required this.current,
    required this.target,
    required this.monthKey,
  });

  final StudyHarmonyMonthlyGoalKind kind;
  final int current;
  final int target;
  final String monthKey;

  bool get completed => current >= target;

  double get progressFraction =>
      target <= 0 ? 0 : (current.clamp(0, target) / target).toDouble();
}

@immutable
class StudyHarmonyMonthlyTourProgressView {
  const StudyHarmonyMonthlyTourProgressView({
    required this.monthKey,
    required this.goals,
    required this.rewardClaimed,
    required this.rewardLeagueXp,
    required this.rewardStreakSavers,
  });

  final String monthKey;
  final List<StudyHarmonyMonthlyGoalProgressView> goals;
  final bool rewardClaimed;
  final int rewardLeagueXp;
  final int rewardStreakSavers;

  int get completedGoalCount => goals.where((goal) => goal.completed).length;

  int get totalGoalCount => goals.length;

  bool get completed => completedGoalCount >= totalGoalCount;

  bool get rewardReady => completed && !rewardClaimed;

  double get progressFraction {
    if (goals.isEmpty) {
      return 0;
    }
    return completedGoalCount / goals.length;
  }
}

@immutable
class StudyHarmonyDuetPactProgressView {
  const StudyHarmonyDuetPactProgressView({
    required this.currentStreak,
    required this.bestStreak,
    required this.activeToday,
    required this.nextTarget,
    required this.rewardLeagueXp,
  });

  final int currentStreak;
  final int bestStreak;
  final bool activeToday;
  final int nextTarget;
  final int rewardLeagueXp;

  double get progressFraction =>
      nextTarget <= 0 ? 1 : (currentStreak.clamp(0, nextTarget) / nextTarget);
}

@immutable
class StudyHarmonyLeagueProgressView {
  const StudyHarmonyLeagueProgressView({
    required this.weekKey,
    required this.score,
    required this.tier,
    required this.currentTierFloor,
    this.nextTier,
    this.nextTarget,
  });

  final String weekKey;
  final int score;
  final StudyHarmonyLeagueTier tier;
  final int currentTierFloor;
  final StudyHarmonyLeagueTier? nextTier;
  final int? nextTarget;

  bool get maxTier => nextTier == null || nextTarget == null;

  double get progressFraction {
    if (maxTier) {
      return 1;
    }
    final span = nextTarget! - currentTierFloor;
    if (span <= 0) {
      return 1;
    }
    return ((score - currentTierFloor).clamp(0, span) / span).toDouble();
  }
}

class StudyHarmonyProgressController extends ChangeNotifier {
  StudyHarmonyProgressController({
    StudyHarmonyProgressStore? store,
    StudyHarmonyProgressSnapshot? initialSnapshot,
    StudyHarmonyNowProvider? nowProvider,
  }) : _store = store ?? const SharedPrefsStudyHarmonyProgressStore(),
       _snapshot = initialSnapshot ?? StudyHarmonyProgressSnapshot.initial(),
       _nowProvider = nowProvider ?? _defaultNowProvider;

  final StudyHarmonyProgressStore _store;
  final StudyHarmonyNowProvider _nowProvider;

  final Map<StudyHarmonyCourseId, StudyHarmonyCourseDefinition> _coursesById =
      <StudyHarmonyCourseId, StudyHarmonyCourseDefinition>{};

  StudyHarmonyProgressSnapshot _snapshot;
  Future<void> _saveQueue = Future<void>.value();
  StudyHarmonyProgressSnapshot? _pendingSaveSnapshot;
  bool _isDisposed = false;

  StudyHarmonyProgressSnapshot get snapshot => _snapshot;
  StudyHarmonyLessonId? get lastPlayedLessonId => _snapshot.lastPlayedLessonId;
  StudyHarmonyChapterId? get lastPlayedChapterId =>
      _snapshot.lastPlayedChapterId;
  StudyHarmonyTrackId? get lastPlayedTrackId => _snapshot.lastPlayedTrackId;

  Future<void> load() async {
    final loaded = await _store.load(fallbackSnapshot: _snapshot);
    if (_isDisposed) {
      return;
    }
    _snapshot = _normalizedSnapshot(loaded);
    notifyListeners();
    if (loaded.encode() != _snapshot.encode()) {
      await _store.save(_snapshot);
    }
  }

  Future<void> syncCourse(StudyHarmonyCourseDefinition course) async {
    _coursesById[course.id] = course;
    final normalized = _normalizedSnapshot(
      _applyUnlockRules(_snapshot, course),
    );
    await _updateSnapshotIfChanged(normalized);
  }

  Future<void> markLessonStarted({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonId lessonId,
  }) async {
    final next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: chapterId,
      lastPlayedLessonId: lessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, lessonId},
    );
    await _updateSnapshotIfChanged(_applyUnlockRulesToRegisteredCourses(next));
  }

  Future<void> markSessionStarted({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyLessonDefinition lesson,
  }) async {
    final effectiveLessonId = _effectiveAnchorLessonId(lesson);
    final next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: lesson.chapterId,
      lastPlayedLessonId: effectiveLessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, lesson.chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, effectiveLessonId},
      dailyChallengeSeedMetadata: _mergeDailyMetadataFromLesson(
        lesson,
        trackId: trackId,
      ),
    );
    await _updateSnapshotIfChanged(_applyUnlockRulesToRegisteredCourses(next));
  }

  Future<StudyHarmonySessionProgressEffect> recordLessonResult({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
    int? bestCombo,
    int? correctAnswers,
    int? livesRemaining,
  }) {
    return recordSessionResult(
      trackId: trackId,
      chapterId: chapterId,
      lesson: lesson,
      cleared: cleared,
      attempts: attempts,
      accuracy: accuracy,
      elapsed: elapsed,
      bestCombo: bestCombo,
      correctAnswers: correctAnswers,
      livesRemaining: livesRemaining,
      performance: _defaultSessionPerformance(
        lesson: lesson,
        attempts: attempts,
        accuracy: accuracy,
      ),
    );
  }

  Future<StudyHarmonySessionProgressEffect> recordSessionResult({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
    int? bestCombo,
    int? correctAnswers,
    int? livesRemaining,
    required StudyHarmonySessionPerformance performance,
  }) async {
    final nowLocal = _nowProvider();
    final now = nowLocal.toUtc();
    final activityDateKey = _dailyDateKey(nowLocal);
    final course = _courseForTrack(trackId);
    final unlockedMilestonesBefore = course == null
        ? const <String>{}
        : _earnedMilestoneIdsForCourse(course, snapshot: _snapshot);
    final chapterStarsSatisfiedBefore = course == null
        ? false
        : _questBoardForCourse(
            course,
            snapshot: _snapshot,
            referenceDate: nowLocal,
          ).any(
            (quest) =>
                quest.kind == StudyHarmonyQuestKind.chapterStars &&
                quest.countsTowardChest,
          );
    final effectiveLessonId = _effectiveAnchorLessonId(lesson);
    final frontierLessonBefore = course == null
        ? null
        : _frontierLessonForCourse(course);
    final previousLessonResult = _snapshot.lessonResults[effectiveLessonId];
    final effectivePerformance = performance.isEmpty
        ? _defaultSessionPerformance(
            lesson: lesson,
            attempts: attempts,
            accuracy: accuracy,
          )
        : performance;
    final lessonSummaries = _normalizedLessonSummaries(
      lesson: lesson,
      performance: effectivePerformance,
      attempts: attempts,
      accuracy: accuracy,
    );
    final skillSummaries = _normalizedSkillSummaries(
      lesson: lesson,
      performance: effectivePerformance,
      attempts: attempts,
      accuracy: accuracy,
    );

    final beforeSkillScores = <StudyHarmonySkillTag, double>{
      for (final skillId in skillSummaries.keys)
        skillId:
            _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore ?? 0.45,
    };
    final activeLeagueXpBoostBefore = _leagueXpBoostForSnapshot(
      _snapshot,
      referenceDate: nowLocal,
    );
    final weekKey = _weekKey(nowLocal);
    final monthKey = _monthKey(nowLocal);
    final sessionStars = _starsForResult(cleared: cleared, accuracy: accuracy);
    final sessionRank = _rankForResult(cleared: cleared, accuracy: accuracy);
    final effectiveCorrectAnswers =
        correctAnswers ?? _correctCountForAccuracy(attempts, accuracy);
    final effectiveBestCombo =
        bestCombo ?? min(effectiveCorrectAnswers, attempts);
    final effectiveLivesRemaining =
        livesRemaining ??
        max(
          0,
          lesson.startingLives - max(0, attempts - effectiveCorrectAnswers),
        );
    final rewardMetricsBefore = _rewardMetricsForSnapshot(_snapshot);
    final unlockedRewardIdsBefore = {
      for (final candidate in studyHarmonyRewardCandidatesForProgress(
        rewardMetricsBefore,
      ))
        if (candidate.unlocked) candidate.id,
    };
    final sessionRewardInput = StudyHarmonySessionRewardInput(
      mode: lesson.sessionMode,
      lessonId: effectiveLessonId,
      lessonTitle: lesson.title,
      accuracy: accuracy,
      stars: sessionStars,
      streak: effectiveBestCombo,
      bestCombo: effectiveBestCombo,
      attempts: attempts,
      correctAnswers: effectiveCorrectAnswers,
      livesRemaining: effectiveLivesRemaining,
      rank: sessionRank,
      isCompleted: cleared,
      isFinished: true,
      countsTowardLessonProgress:
          lesson.sessionMetadata.countsTowardLessonProgress,
    );
    final rewardBundles = studyHarmonySessionRewardBundles(sessionRewardInput);
    final currencyGrants = _mergeRewardGrants([
      for (final bundle in rewardBundles) ...bundle.grants,
    ]);
    final previousWeeklyLeagueScore =
        _snapshot.weeklyLeagueScores[weekKey] ?? 0;
    final previousWeeklyLeagueTier = _leagueTierForScore(
      previousWeeklyLeagueScore,
    );
    final weeklyLeagueScoreDelta = _leagueScoreDelta(
      sessionMode: lesson.sessionMode,
      cleared: cleared,
      sessionStars: sessionStars,
      accuracy: accuracy,
    );
    var nextWeeklyLeagueScores = Map<String, int>.from(
      _snapshot.weeklyLeagueScores,
    );
    var nextMonthlySpotlightClearCounts = Map<String, int>.from(
      _snapshot.monthlySpotlightClearCounts,
    );
    final nextModeSessionCounts = Map<String, int>.from(
      _snapshot.modeSessionCounts,
    );
    final nextModeClearCounts = Map<String, int>.from(
      _snapshot.modeClearCounts,
    );
    _incrementEncodedModeCount(nextModeSessionCounts, lesson.sessionMode);
    if (cleared) {
      _incrementEncodedModeCount(nextModeClearCounts, lesson.sessionMode);
    }
    var nextActiveLeagueXpBoostCharges = activeLeagueXpBoostBefore.chargeCount;
    var nextActiveLeagueXpBoostDateKey = activeLeagueXpBoostBefore.active
        ? activeLeagueXpBoostBefore.dateKey
        : null;
    var leagueXpBoostUnlocked = false;
    var leagueXpBoostAppliedBonus = 0;
    if (weeklyLeagueScoreDelta > 0) {
      var totalLeagueXpDelta = weeklyLeagueScoreDelta;
      if (cleared && nextActiveLeagueXpBoostCharges > 0) {
        leagueXpBoostAppliedBonus = activeLeagueXpBoostBefore.bonusForBase(
          weeklyLeagueScoreDelta,
        );
        totalLeagueXpDelta += leagueXpBoostAppliedBonus;
        nextActiveLeagueXpBoostCharges -= 1;
        if (nextActiveLeagueXpBoostCharges <= 0) {
          nextActiveLeagueXpBoostDateKey = null;
        }
      }
      nextWeeklyLeagueScores[weekKey] =
          previousWeeklyLeagueScore + totalLeagueXpDelta;
    }
    if (cleared && _countsTowardMonthlySpotlight(lesson)) {
      nextMonthlySpotlightClearCounts[monthKey] =
          (nextMonthlySpotlightClearCounts[monthKey] ?? 0) + 1;
    }

    final nextLessonResults =
        Map<StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>.from(
          _snapshot.lessonResults,
        );
    if (lesson.sessionMetadata.countsTowardLessonProgress) {
      nextLessonResults[effectiveLessonId] = _mergeLessonResult(
        existing: _snapshot.lessonResults[effectiveLessonId],
        lesson: lesson,
        cleared: cleared,
        attempts: attempts,
        accuracy: accuracy,
        elapsed: elapsed,
        playedAt: now,
      );
    }

    final nextSkillMastery = _mergeSkillMasteryPlaceholders(
      skillSummaries: skillSummaries,
      updatedAt: now,
    );
    final nextReviewQueue = _mergeReviewQueuePlaceholders(
      lessonSummaries: lessonSummaries,
      sessionLesson: lesson,
      updatedAt: now,
    );
    var nextCompletedDailyKeys = _snapshot.completedDailyChallengeDateKeys;
    var nextProtectedDailyKeys = _snapshot.protectedDailyChallengeDateKeys;
    var nextActivityDateKeys = _mergedCompletedDailyChallengeDateKeys(
      existing: _snapshot.activityDateKeys,
      dateKey: activityDateKey,
    );
    var nextCompletedFocusKeys = _snapshot.completedFocusChallengeDateKeys;
    var nextCompletedSpotlightKeys =
        _snapshot.completedSpotlightChallengeDateKeys;
    var nextCompletedFrontierQuestKeys =
        _snapshot.completedFrontierQuestDateKeys;
    var nextAwardedWeeklyPlanWeekKeys = _snapshot.awardedWeeklyPlanWeekKeys;
    var nextAwardedDailyQuestChestKeys =
        _snapshot.awardedDailyQuestChestDateKeys;
    var nextLegendaryChapterIds = _snapshot.legendaryChapterIds;
    var nextRelayWinCount = _snapshot.relayWinCount;
    var nextBestDailyStreak = _snapshot.bestDailyChallengeStreak;
    var nextBestDuetPactStreak = _snapshot.bestDuetPactStreak;
    var nextStreakSaverCount = _snapshot.streakSaverCount;
    var nextQuestChestCount = _snapshot.questChestCount;
    var dailyChallengeCompleted = false;
    var focusSprintCompleted = false;
    var weeklyRewardUnlocked = false;
    var streakSaverUsed = false;
    var dailyQuestChestOpened = false;
    var questChestLeagueXpBonus = 0;
    var monthlyTourRewardUnlocked = false;
    var monthlyTourLeagueXpBonus = 0;
    var duetPactRewardUnlocked = false;
    var duetPactLeagueXpBonus = 0;
    int? dailyStreakCount;
    final dailyDateKey = lesson.sessionMetadata.dailyDateKey;
    if (lesson.sessionMode == StudyHarmonySessionMode.daily &&
        cleared &&
        dailyDateKey != null) {
      dailyChallengeCompleted = true;
      final streakDateKeysBefore = _allStreakDateKeys(
        completedDailyDateKeys: nextCompletedDailyKeys,
        protectedDailyDateKeys: nextProtectedDailyKeys,
      );
      if (!streakDateKeysBefore.contains(dailyDateKey)) {
        final saverResult = _tryUseStreakSaverForDateKey(
          completedDailyDateKeys: nextCompletedDailyKeys,
          protectedDailyDateKeys: nextProtectedDailyKeys,
          dateKey: dailyDateKey,
          streakSaverCount: nextStreakSaverCount,
        );
        nextProtectedDailyKeys = saverResult.protectedDailyDateKeys;
        nextStreakSaverCount = saverResult.remainingStreakSavers;
        streakSaverUsed = saverResult.used;
      }
      nextCompletedDailyKeys = _mergedCompletedDailyChallengeDateKeys(
        existing: nextCompletedDailyKeys,
        dateKey: dailyDateKey,
      );
      dailyStreakCount = _streakEndingAt(
        _allStreakDateKeys(
          completedDailyDateKeys: nextCompletedDailyKeys,
          protectedDailyDateKeys: nextProtectedDailyKeys,
        ),
        dailyDateKey,
      );
      nextBestDailyStreak = max(nextBestDailyStreak, dailyStreakCount);
    }
    if (lesson.sessionMode == StudyHarmonySessionMode.focus && cleared) {
      focusSprintCompleted = true;
      nextCompletedFocusKeys = _mergedCompletedDailyChallengeDateKeys(
        existing: nextCompletedFocusKeys,
        dateKey: activityDateKey,
      );
    }
    if (cleared && _countsTowardMonthlySpotlight(lesson)) {
      nextCompletedSpotlightKeys = _mergedCompletedDailyChallengeDateKeys(
        existing: nextCompletedSpotlightKeys,
        dateKey: activityDateKey,
      );
    }
    nextBestDuetPactStreak = max(
      nextBestDuetPactStreak,
      _longestDailyStreakForDateKeys(
        nextCompletedDailyKeys.intersection(nextCompletedSpotlightKeys),
      ),
    );
    if (lesson.sessionMetadata.countsTowardLessonProgress &&
        cleared &&
        frontierLessonBefore?.id == effectiveLessonId) {
      nextCompletedFrontierQuestKeys = _mergedCompletedDailyChallengeDateKeys(
        existing: nextCompletedFrontierQuestKeys,
        dateKey: activityDateKey,
      );
    }
    if (lesson.sessionMode == StudyHarmonySessionMode.relay && cleared) {
      nextRelayWinCount += 1;
    }
    if (lesson.sessionMode == StudyHarmonySessionMode.legend && cleared) {
      nextLegendaryChapterIds = {...nextLegendaryChapterIds, chapterId};
    }
    final nextRewardCurrencyBalances = _applyRewardGrants(
      existing: _snapshot.rewardCurrencyBalances,
      grants: currencyGrants,
    );

    var next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: chapterId,
      lastPlayedLessonId: effectiveLessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, effectiveLessonId},
      lessonResults: nextLessonResults,
      skillMasteryPlaceholders: nextSkillMastery,
      reviewQueuePlaceholders: nextReviewQueue,
      dailyChallengeSeedMetadata: _mergeDailyMetadataFromLesson(
        lesson,
        trackId: trackId,
      ),
      completedDailyChallengeDateKeys: nextCompletedDailyKeys,
      protectedDailyChallengeDateKeys: nextProtectedDailyKeys,
      activityDateKeys: nextActivityDateKeys,
      completedFocusChallengeDateKeys: nextCompletedFocusKeys,
      completedSpotlightChallengeDateKeys: nextCompletedSpotlightKeys,
      completedFrontierQuestDateKeys: nextCompletedFrontierQuestKeys,
      awardedWeeklyPlanWeekKeys: nextAwardedWeeklyPlanWeekKeys,
      awardedDailyQuestChestDateKeys: nextAwardedDailyQuestChestKeys,
      weeklyLeagueScores: nextWeeklyLeagueScores,
      monthlySpotlightClearCounts: nextMonthlySpotlightClearCounts,
      modeSessionCounts: nextModeSessionCounts,
      modeClearCounts: nextModeClearCounts,
      rewardCurrencyBalances: nextRewardCurrencyBalances,
      bestSessionCombo: max(_snapshot.bestSessionCombo, effectiveBestCombo),
      legendaryChapterIds: nextLegendaryChapterIds,
      relayWinCount: nextRelayWinCount,
      bestDailyChallengeStreak: nextBestDailyStreak,
      bestDuetPactStreak: nextBestDuetPactStreak,
      streakSaverCount: nextStreakSaverCount,
      questChestCount: nextQuestChestCount,
      activeLeagueXpBoostDateKey: nextActiveLeagueXpBoostDateKey,
      activeLeagueXpBoostCharges: nextActiveLeagueXpBoostCharges,
      clearActiveLeagueXpBoostDateKey: nextActiveLeagueXpBoostDateKey == null,
    );
    if (course != null) {
      final rewardResult = _applyWeeklyPlanReward(
        course,
        snapshot: next,
        referenceDate: nowLocal,
      );
      next = rewardResult.snapshot;
      weeklyRewardUnlocked = rewardResult.rewardUnlocked;
      final questChestResult = _applyDailyQuestChestReward(
        course,
        snapshot: next,
        referenceDate: nowLocal,
        chapterStarsSatisfiedBefore: chapterStarsSatisfiedBefore,
      );
      next = questChestResult.snapshot;
      dailyQuestChestOpened = questChestResult.chestOpened;
      questChestLeagueXpBonus = questChestResult.leagueXpBonus;
      leagueXpBoostUnlocked = questChestResult.leagueXpBoostUnlocked;
      final monthlyTourResult = _applyMonthlyTourReward(
        course,
        snapshot: next,
        referenceDate: nowLocal,
      );
      next = monthlyTourResult.snapshot;
      monthlyTourRewardUnlocked = monthlyTourResult.rewardUnlocked;
      monthlyTourLeagueXpBonus = monthlyTourResult.leagueXpBonus;
      final duetPactResult = _applyDuetPactReward(
        snapshot: next,
        referenceDate: nowLocal,
      );
      next = duetPactResult.snapshot;
      duetPactRewardUnlocked = duetPactResult.rewardUnlocked;
      duetPactLeagueXpBonus = duetPactResult.leagueXpBonus;
    }
    next = _normalizedSnapshot(_applyUnlockRulesToRegisteredCourses(next));
    await _updateSnapshotIfChanged(next);
    final unlockedMilestonesAfter = course == null
        ? const <String>{}
        : _earnedMilestoneIdsForCourse(course, snapshot: next);
    final nextWeeklyLeagueScore = next.weeklyLeagueScores[weekKey] ?? 0;
    final nextWeeklyLeagueTier = _leagueTierForScore(nextWeeklyLeagueScore);
    final rewardMetricsAfter = _rewardMetricsForSnapshot(next);
    final rewardCandidatesAfter = studyHarmonyRewardCandidatesForProgress(
      rewardMetricsAfter,
    );
    final newlyUnlockedRewards = rewardCandidatesAfter
        .where((candidate) => candidate.unlocked)
        .where((candidate) => !unlockedRewardIdsBefore.contains(candidate.id))
        .take(5)
        .toList(growable: false);
    final featuredRewardChases = rewardCandidatesAfter
        .where((candidate) => !candidate.unlocked)
        .take(3)
        .toList(growable: false);
    final activeLeagueXpBoostAfter = _leagueXpBoostForSnapshot(
      next,
      referenceDate: nowLocal,
    );
    final duetPactAfter = _duetPactProgressForSnapshot(
      next,
      referenceDate: nowLocal,
    );
    final promotedLeagueTier =
        nextWeeklyLeagueTier.index > previousWeeklyLeagueTier.index
        ? nextWeeklyLeagueTier
        : null;
    final countsTowardLessonProgress =
        lesson.sessionMetadata.countsTowardLessonProgress;
    final nextLessonResult = countsTowardLessonProgress
        ? next.lessonResults[effectiveLessonId]
        : null;
    final previousBestStars = previousLessonResult?.bestStars ?? 0;
    final previousBestRank = previousLessonResult?.bestRank ?? 'C';
    final nextBestStars = nextLessonResult?.bestStars;
    final nextBestRank = nextLessonResult?.bestRank;
    final personalBestImproved =
        countsTowardLessonProgress &&
        ((nextBestStars ?? 0) > previousBestStars ||
            (nextBestRank != null &&
                _betterRank(previousBestRank, nextBestRank) !=
                    previousBestRank));

    final skillGains =
        skillSummaries.keys
            .map((skillId) {
              final after = next.skillMasteryPlaceholders[skillId];
              if (after == null) {
                return null;
              }
              final beforeScore = beforeSkillScores[skillId] ?? 0;
              return StudyHarmonySkillGainSummary(
                skillId: skillId,
                beforeScore: beforeScore,
                afterScore: after.masteryScore,
                delta: after.masteryScore - beforeScore,
                recentAccuracy: after.recentAccuracy,
              );
            })
            .whereType<StudyHarmonySkillGainSummary>()
            .toList(growable: false)
          ..sort((left, right) => right.delta.compareTo(left.delta));

    return StudyHarmonySessionProgressEffect(
      mode: lesson.sessionMode,
      sessionStars: sessionStars,
      sessionRank: sessionRank,
      skillGains: skillGains,
      focusSkillTags: lesson.sessionMetadata.focusSkillTags.isEmpty
          ? skillSummaries.keys.toSet()
          : lesson.sessionMetadata.focusSkillTags,
      reviewReason: lesson.sessionMetadata.reviewReason,
      dailyDateKey: lesson.sessionMetadata.dailyDateKey,
      bestStars: nextBestStars,
      bestRank: nextBestRank,
      personalBestImproved: personalBestImproved,
      countsTowardLessonProgress: countsTowardLessonProgress,
      rewardBundles: rewardBundles,
      currencyGrants: currencyGrants,
      currencyBalances: next.rewardCurrencyBalances,
      newlyUnlockedRewards: newlyUnlockedRewards,
      featuredRewardChases: featuredRewardChases,
      dailyChallengeCompleted: dailyChallengeCompleted,
      focusSprintCompleted: focusSprintCompleted,
      dailyStreakCount: dailyStreakCount,
      bestDailyStreakCount: dailyChallengeCompleted
          ? nextBestDailyStreak
          : null,
      newlyUnlockedMilestoneIds:
          unlockedMilestonesAfter
              .difference(unlockedMilestonesBefore)
              .toList(growable: false)
            ..sort(),
      weeklyRewardUnlocked: weeklyRewardUnlocked,
      streakSaverUsed: streakSaverUsed,
      streakSaverCount: next.streakSaverCount,
      relayWinCount:
          lesson.sessionMode == StudyHarmonySessionMode.relay && cleared
          ? next.relayWinCount
          : null,
      weeklyLeagueScore: nextWeeklyLeagueScore,
      weeklyLeagueScoreDelta: weeklyLeagueScoreDelta,
      weeklyLeagueTier: nextWeeklyLeagueTier,
      promotedLeagueTier: promotedLeagueTier,
      dailyQuestChestOpened: dailyQuestChestOpened,
      questChestCount: next.questChestCount,
      questChestLeagueXpBonus: questChestLeagueXpBonus,
      leagueXpBoostUnlocked: leagueXpBoostUnlocked,
      leagueXpBoostChargeCount: activeLeagueXpBoostAfter.chargeCount,
      leagueXpBoostAppliedBonus: leagueXpBoostAppliedBonus,
      monthlyTourRewardUnlocked: monthlyTourRewardUnlocked,
      monthlyTourLeagueXpBonus: monthlyTourLeagueXpBonus,
      monthlyTourStreakSaverCount: next.streakSaverCount,
      duetPactActiveToday: duetPactAfter.activeToday,
      duetPactCurrentStreak: duetPactAfter.currentStreak,
      duetPactBestStreak: duetPactAfter.bestStreak,
      duetPactRewardUnlocked: duetPactRewardUnlocked,
      duetPactLeagueXpBonus: duetPactLeagueXpBonus,
    );
  }

  bool isLessonUnlocked(StudyHarmonyLessonId lessonId) {
    return _isLessonUnlocked(_snapshot, lessonId);
  }

  bool isChapterUnlocked(StudyHarmonyChapterId chapterId) {
    return _isChapterUnlocked(_snapshot, chapterId);
  }

  bool isLessonCleared(StudyHarmonyLessonId lessonId) {
    return _isLessonCleared(_snapshot, lessonId);
  }

  StudyHarmonyLessonProgressSummary? lessonResultFor(
    StudyHarmonyLessonId lessonId,
  ) {
    return _snapshot.lessonResults[lessonId];
  }

  StudyHarmonySkillMasteryPlaceholder? skillMasteryFor(
    StudyHarmonySkillTag skillId,
  ) {
    return _snapshot.skillMasteryPlaceholders[skillId];
  }

  Map<StudyHarmonyCurrencyId, int> currentRewardCurrencyBalances() {
    return Map<StudyHarmonyCurrencyId, int>.unmodifiable(
      _snapshot.rewardCurrencyBalances,
    );
  }

  int rewardCurrencyBalanceOf(StudyHarmonyCurrencyId currencyId) {
    return _snapshot.rewardCurrencyBalances[currencyId] ?? 0;
  }

  int shopPurchaseCount() {
    return _snapshot.shopPurchaseCount;
  }

  bool hasPurchasedUniqueShopItem(String itemId) {
    return _snapshot.purchasedUniqueShopItemIds.contains(itemId);
  }

  StudyHarmonyRewardProgressMetrics currentRewardMetrics() {
    final modeSessionCounts = _decodeModeCounts(_snapshot.modeSessionCounts);
    final modeClearCounts = _decodeModeCounts(_snapshot.modeClearCounts);
    return studyHarmonyRewardMetricsFromSnapshot(
      _snapshot,
      reviewClears: modeClearCounts[StudyHarmonySessionMode.review] ?? 0,
      bossClears: modeClearCounts[StudyHarmonySessionMode.bossRush] ?? 0,
      legendClears: max(
        modeClearCounts[StudyHarmonySessionMode.legend] ?? 0,
        _snapshot.legendaryChapterIds.length,
      ),
      bestCombo: _snapshot.bestSessionCombo,
      shopPurchases: _snapshot.shopPurchaseCount,
      currencySpent: _snapshot.rewardCurrencySpent,
      modeSessionCounts: modeSessionCounts,
      modeClearCounts: modeClearCounts,
    );
  }

  List<StudyHarmonyRewardCandidate> currentRewardCandidates() {
    return studyHarmonyRewardCandidatesForProgress(currentRewardMetrics());
  }

  Set<String> ownedTitleIds() {
    final metrics = _rewardMetricsForSnapshot(_snapshot);
    return Set<String>.unmodifiable(
      _ownedTitleIdsForSnapshot(_snapshot, metrics),
    );
  }

  Set<String> ownedCosmeticIds() {
    final metrics = _rewardMetricsForSnapshot(_snapshot);
    return Set<String>.unmodifiable(
      _ownedCosmeticIdsForSnapshot(_snapshot, metrics),
    );
  }

  String? equippedTitleId() {
    return _normalizedRewardTitleId(
      _snapshot.equippedTitleId,
      ownedTitleIds: ownedTitleIds(),
    );
  }

  List<String> equippedCosmeticIds() {
    return List<String>.unmodifiable(
      _normalizedRewardCosmeticLoadout(
        _snapshot.equippedCosmeticIds,
        ownedCosmeticIds: ownedCosmeticIds(),
      ),
    );
  }

  bool isTitleOwned(String titleId) {
    return ownedTitleIds().contains(titleId);
  }

  bool isCosmeticOwned(String cosmeticId) {
    return ownedCosmeticIds().contains(cosmeticId);
  }

  Future<bool> equipTitle(String titleId) async {
    if (!studyHarmonyTitlesById.containsKey(titleId) ||
        !isTitleOwned(titleId)) {
      return false;
    }
    if (_snapshot.equippedTitleId == titleId) {
      return true;
    }
    final next = _normalizedSnapshot(
      _snapshot.copyWith(equippedTitleId: titleId),
    );
    await _updateSnapshotIfChanged(next);
    return true;
  }

  Future<bool> unequipTitle() async {
    if (_snapshot.equippedTitleId == null) {
      return true;
    }
    final next = _normalizedSnapshot(
      _snapshot.copyWith(clearEquippedTitleId: true),
    );
    await _updateSnapshotIfChanged(next);
    return true;
  }

  Future<bool> equipCosmetic(String cosmeticId) async {
    if (!studyHarmonyCosmeticsById.containsKey(cosmeticId) ||
        !isCosmeticOwned(cosmeticId)) {
      return false;
    }
    final nextLoadout = _normalizedRewardCosmeticLoadout([
      for (final equipped in _snapshot.equippedCosmeticIds)
        if (equipped != cosmeticId) equipped,
      cosmeticId,
    ], ownedCosmeticIds: ownedCosmeticIds());
    if (listEquals(nextLoadout, _snapshot.equippedCosmeticIds)) {
      return true;
    }
    final next = _normalizedSnapshot(
      _snapshot.copyWith(equippedCosmeticIds: nextLoadout),
    );
    await _updateSnapshotIfChanged(next);
    return true;
  }

  Future<bool> unequipCosmetic(String cosmeticId) async {
    final nextLoadout = _normalizedRewardCosmeticLoadout([
      for (final equipped in _snapshot.equippedCosmeticIds)
        if (equipped != cosmeticId) equipped,
    ], ownedCosmeticIds: ownedCosmeticIds());
    if (listEquals(nextLoadout, _snapshot.equippedCosmeticIds)) {
      return true;
    }
    final next = _normalizedSnapshot(
      _snapshot.copyWith(equippedCosmeticIds: nextLoadout),
    );
    await _updateSnapshotIfChanged(next);
    return true;
  }

  bool canPurchaseShopItem(StudyHarmonyShopItemDefinition item) {
    final isRepeatable = _isRepeatableShopItem(item);
    if (!isRepeatable && hasPurchasedUniqueShopItem(item.id)) {
      return false;
    }
    final metrics = currentRewardMetrics();
    if (!item.requirements.every((requirement) => requirement.isMet(metrics))) {
      return false;
    }
    return rewardCurrencyBalanceOf(item.priceCurrencyId) >= item.priceAmount;
  }

  Future<bool> purchaseShopItem(StudyHarmonyShopItemDefinition item) async {
    if (!canPurchaseShopItem(item)) {
      return false;
    }

    final nextBalances = Map<StudyHarmonyCurrencyId, int>.from(
      _snapshot.rewardCurrencyBalances,
    );
    nextBalances[item.priceCurrencyId] = max(
      0,
      (nextBalances[item.priceCurrencyId] ?? 0) - item.priceAmount,
    );
    for (final grant in item.grants) {
      nextBalances[grant.currencyId] =
          (nextBalances[grant.currencyId] ?? 0) + grant.amount;
    }

    final nextPurchasedUniqueIds = _isRepeatableShopItem(item)
        ? _snapshot.purchasedUniqueShopItemIds
        : {..._snapshot.purchasedUniqueShopItemIds, item.id};
    final currentMetrics = _rewardMetricsForSnapshot(_snapshot);
    final nextOwnedTitleIds = _ownedTitleIdsForSnapshot(
      _snapshot,
      currentMetrics,
    );
    final nextOwnedCosmeticIds = _ownedCosmeticIdsForSnapshot(
      _snapshot,
      currentMetrics,
    );
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyTitlesById.containsKey(unlockId)) {
        nextOwnedTitleIds.add(unlockId);
      }
      if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
        nextOwnedCosmeticIds.add(unlockId);
      }
    }
    final next = _normalizedSnapshot(
      _snapshot.copyWith(
        rewardCurrencyBalances: nextBalances,
        rewardCurrencySpent: _snapshot.rewardCurrencySpent + item.priceAmount,
        shopPurchaseCount: _snapshot.shopPurchaseCount + 1,
        purchasedUniqueShopItemIds: nextPurchasedUniqueIds,
        ownedTitleIds: nextOwnedTitleIds,
        ownedCosmeticIds: nextOwnedCosmeticIds,
      ),
    );
    await _updateSnapshotIfChanged(next);
    return true;
  }

  bool _isLessonUnlocked(
    StudyHarmonyProgressSnapshot snapshot,
    StudyHarmonyLessonId lessonId,
  ) {
    return snapshot.unlockedLessonIds.contains(lessonId);
  }

  bool _isChapterUnlocked(
    StudyHarmonyProgressSnapshot snapshot,
    StudyHarmonyChapterId chapterId,
  ) {
    return snapshot.unlockedChapterIds.contains(chapterId);
  }

  bool _isLessonCleared(
    StudyHarmonyProgressSnapshot snapshot,
    StudyHarmonyLessonId lessonId,
  ) {
    return snapshot.lessonResults[lessonId]?.isCleared ?? false;
  }

  StudyHarmonyChapterProgressSummaryView chapterProgressFor(
    StudyHarmonyChapterDefinition chapter,
  ) {
    return _chapterProgressFor(chapter, snapshot: _snapshot);
  }

  StudyHarmonyChapterProgressSummaryView _chapterProgressFor(
    StudyHarmonyChapterDefinition chapter, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    final clearedLessonCount = chapter.lessons
        .where((lesson) => _isLessonCleared(snapshot, lesson.id))
        .length;
    final lessonCount = chapter.lessons.length;
    final starCount = _starsEarnedForChapter(chapter, snapshot: snapshot);
    final unlocked =
        _isChapterUnlocked(snapshot, chapter.id) ||
        chapter.lessons.any((lesson) => _isLessonUnlocked(snapshot, lesson.id));
    final isCompleted = lessonCount > 0 && clearedLessonCount >= lessonCount;
    final nextLesson = !unlocked || isCompleted
        ? null
        : chapter.lessons.firstWhere(
            (lesson) =>
                _isLessonUnlocked(snapshot, lesson.id) &&
                !_isLessonCleared(snapshot, lesson.id),
            orElse: () => chapter.lessons.firstWhere(
              (lesson) => _isLessonUnlocked(snapshot, lesson.id),
              orElse: () => chapter.lessons.first,
            ),
          );

    return StudyHarmonyChapterProgressSummaryView(
      chapter: chapter,
      lessonCount: lessonCount,
      clearedLessonCount: clearedLessonCount,
      starCount: starCount,
      masteryTier: _chapterMasteryTierFor(chapter, snapshot: snapshot),
      unlocked: unlocked,
      nextLesson: nextLesson,
    );
  }

  int starsEarnedForCourse(StudyHarmonyCourseDefinition course) {
    return _starsEarnedForCourse(course, snapshot: _snapshot);
  }

  int starsEarnedForChapter(StudyHarmonyChapterDefinition chapter) {
    return _starsEarnedForChapter(chapter, snapshot: _snapshot);
  }

  bool isChapterLegendary(StudyHarmonyChapterId chapterId) {
    return _snapshot.legendaryChapterIds.contains(chapterId);
  }

  StudyHarmonyChapterMasteryTier chapterMasteryTierFor(
    StudyHarmonyChapterDefinition chapter,
  ) {
    return _chapterMasteryTierFor(chapter, snapshot: _snapshot);
  }

  int legendaryChapterCountForCourse(StudyHarmonyCourseDefinition course) {
    return course.chapters
        .where((chapter) => _snapshot.legendaryChapterIds.contains(chapter.id))
        .length;
  }

  int relayWinCount() {
    return _snapshot.relayWinCount;
  }

  int questChestCount() {
    return _snapshot.questChestCount;
  }

  StudyHarmonyLeagueXpBoostProgressView currentLeagueXpBoost() {
    return _leagueXpBoostForSnapshot(_snapshot, referenceDate: _nowProvider());
  }

  StudyHarmonyLeagueProgressView currentLeagueProgress() {
    final weekKey = _weekKey(_nowProvider());
    final score = _snapshot.weeklyLeagueScores[weekKey] ?? 0;
    return _leagueProgressForScore(weekKey: weekKey, score: score);
  }

  bool isQuestChestOpenedToday() {
    return _snapshot.awardedDailyQuestChestDateKeys.contains(
      _dailyDateKey(_nowProvider()),
    );
  }

  int masteredSkillCountForCourse(
    StudyHarmonyCourseDefinition course, {
    double masteryThreshold = 0.75,
  }) {
    return _masteredSkillCountForCourse(
      course,
      snapshot: _snapshot,
      masteryThreshold: masteryThreshold,
    );
  }

  int dueReviewCountForCourse(StudyHarmonyCourseDefinition course) {
    final lessonIds = {for (final lesson in _orderedLessons(course)) lesson.id};
    final now = _nowProvider();
    return _snapshot.reviewQueuePlaceholders.where((entry) {
      return lessonIds.contains(entry.lessonId) && _isEntryDue(entry, now);
    }).length;
  }

  int currentDailyChallengeStreak() {
    return _currentDailyStreakForDateKeys(
      _allStreakDateKeys(
        completedDailyDateKeys: _snapshot.completedDailyChallengeDateKeys,
        protectedDailyDateKeys: _snapshot.protectedDailyChallengeDateKeys,
      ),
      _nowProvider(),
    );
  }

  int bestDailyChallengeStreak() {
    return _bestDailyChallengeStreakForSnapshot(_snapshot);
  }

  int currentStreakSaverCount() {
    return _snapshot.streakSaverCount;
  }

  bool isDailyChallengeCompletedToday() {
    return _snapshot.completedDailyChallengeDateKeys.contains(
      _dailyDateKey(_nowProvider()),
    );
  }

  List<StudyHarmonyWeeklyGoalProgressView> weeklyPlanForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    return _weeklyPlanForCourse(
      course,
      snapshot: _snapshot,
      referenceDate: _nowProvider(),
    );
  }

  StudyHarmonyMonthlyTourProgressView monthlyTourProgressForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    return _monthlyTourForCourse(
      course,
      snapshot: _snapshot,
      referenceDate: _nowProvider(),
    );
  }

  StudyHarmonyDuetPactProgressView duetPactProgress() {
    return _duetPactProgressForSnapshot(
      _snapshot,
      referenceDate: _nowProvider(),
    );
  }

  List<StudyHarmonyQuestProgressView> questBoardForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    return _questBoardForCourse(
      course,
      snapshot: _snapshot,
      referenceDate: _nowProvider(),
    );
  }

  StudyHarmonyQuestChestProgressView questChestStatusForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    return _questChestStatusForCourse(
      course,
      snapshot: _snapshot,
      referenceDate: _nowProvider(),
    );
  }

  StudyHarmonyLessonRecommendation? questChestRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final questBoard = questBoardForCourse(course);
    final chestStatus = questChestStatusForCourse(course);
    if (chestStatus.openedToday) {
      return continueRecommendationForCourse(course);
    }

    final dailyQuest = questBoard.firstWhere(
      (quest) => quest.kind == StudyHarmonyQuestKind.dailyStreak,
    );
    if (!dailyQuest.countsTowardChest) {
      return dailyChallengeRecommendationForCourse(course);
    }

    final frontierQuest = questBoard.firstWhere(
      (quest) => quest.kind == StudyHarmonyQuestKind.frontierLesson,
    );
    if (!frontierQuest.countsTowardChest) {
      return continueRecommendationForCourse(course);
    }

    final starsQuest = questBoard.firstWhere(
      (quest) => quest.kind == StudyHarmonyQuestKind.chapterStars,
    );
    if (!starsQuest.countsTowardChest) {
      final chapterLesson = _chapterStarQuestRecommendation(course, starsQuest);
      return chapterLesson ?? continueRecommendationForCourse(course);
    }

    return continueRecommendationForCourse(course);
  }

  StudyHarmonyLessonRecommendation? leagueBoostRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final chestStatus = questChestStatusForCourse(course);
    final activeLeagueXpBoost = currentLeagueXpBoost();
    final questFinishRecommendation = questChestRecommendationForCourse(course);
    final continueRecommendation = continueRecommendationForCourse(course);
    final dailyRecommendation = dailyChallengeRecommendationForCourse(course);
    final reviewRecommendation = reviewRecommendationForCourse(course);
    final focusRecommendation = focusSprintRecommendationForCourse(course);
    final relayRecommendation = relayRecommendationForCourse(course);
    final bossRushRecommendation = bossRushRecommendationForCourse(course);
    final legendRecommendation = legendTrialRecommendationForCourse(course);
    final progress = currentLeagueProgress();
    final gapToNextTier = progress.nextTarget == null
        ? 0
        : progress.nextTarget! - progress.score;

    if (activeLeagueXpBoost.active) {
      return legendRecommendation ??
          bossRushRecommendation ??
          relayRecommendation ??
          focusRecommendation ??
          reviewRecommendation ??
          dailyRecommendation ??
          continueRecommendation;
    }
    if (!chestStatus.openedToday && questFinishRecommendation != null) {
      return questFinishRecommendation;
    }
    if (progress.score == 0) {
      return dailyRecommendation ??
          continueRecommendation ??
          reviewRecommendation ??
          focusRecommendation ??
          relayRecommendation ??
          bossRushRecommendation ??
          legendRecommendation;
    }
    if (gapToNextTier > 0 && gapToNextTier <= 28) {
      return legendRecommendation ??
          bossRushRecommendation ??
          relayRecommendation ??
          focusRecommendation ??
          reviewRecommendation ??
          dailyRecommendation ??
          continueRecommendation;
    }
    if (progress.tier.index <= StudyHarmonyLeagueTier.bronze.index) {
      return continueRecommendation ??
          dailyRecommendation ??
          focusRecommendation ??
          reviewRecommendation ??
          relayRecommendation ??
          bossRushRecommendation ??
          legendRecommendation;
    }
    return focusRecommendation ??
        relayRecommendation ??
        bossRushRecommendation ??
        legendRecommendation ??
        reviewRecommendation ??
        dailyRecommendation ??
        continueRecommendation;
  }

  StudyHarmonyLessonRecommendation? monthlyTourRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final monthlyTour = monthlyTourProgressForCourse(course);
    if (monthlyTour.rewardReady) {
      return leagueBoostRecommendationForCourse(course) ??
          bossRushRecommendationForCourse(course) ??
          legendTrialRecommendationForCourse(course) ??
          continueRecommendationForCourse(course);
    }
    if (monthlyTour.rewardClaimed) {
      return leagueBoostRecommendationForCourse(course) ??
          continueRecommendationForCourse(course) ??
          reviewRecommendationForCourse(course);
    }

    final spotlightGoal = monthlyTour.goals.firstWhere(
      (goal) => goal.kind == StudyHarmonyMonthlyGoalKind.spotlightClears,
    );
    if (!spotlightGoal.completed) {
      return bossRushRecommendationForCourse(course) ??
          legendTrialRecommendationForCourse(course) ??
          relayRecommendationForCourse(course) ??
          focusSprintRecommendationForCourse(course) ??
          continueRecommendationForCourse(course);
    }

    final questChestGoal = monthlyTour.goals.firstWhere(
      (goal) => goal.kind == StudyHarmonyMonthlyGoalKind.questChests,
    );
    if (!questChestGoal.completed) {
      return questChestRecommendationForCourse(course) ??
          dailyChallengeRecommendationForCourse(course) ??
          continueRecommendationForCourse(course);
    }

    return dailyChallengeRecommendationForCourse(course) ??
        continueRecommendationForCourse(course) ??
        reviewRecommendationForCourse(course);
  }

  StudyHarmonyLessonRecommendation? duetPactRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final duetPact = duetPactProgress();
    if (!isDailyChallengeCompletedToday()) {
      return dailyChallengeRecommendationForCourse(course) ??
          continueRecommendationForCourse(course);
    }
    if (!duetPact.activeToday) {
      return bossRushRecommendationForCourse(course) ??
          relayRecommendationForCourse(course) ??
          focusSprintRecommendationForCourse(course) ??
          legendTrialRecommendationForCourse(course) ??
          reviewRecommendationForCourse(course) ??
          continueRecommendationForCourse(course);
    }
    return leagueBoostRecommendationForCourse(course) ??
        continueRecommendationForCourse(course) ??
        reviewRecommendationForCourse(course);
  }

  List<StudyHarmonyMilestoneProgressView> milestoneBoardForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    return _milestoneBoardForCourse(course, snapshot: _snapshot);
  }

  StudyHarmonyLessonRecommendation? continueRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final lastPlayedLesson = lastPlayedTrackId == course.trackId
        ? _lessonForId(course, lastPlayedLessonId)
        : null;
    final frontierLesson = _frontierLessonForCourse(course);
    final shouldResumeLastPlayed =
        lastPlayedLesson != null &&
        _isLessonAccessible(course, lastPlayedLesson) &&
        (!isLessonCleared(lastPlayedLesson.id) ||
            frontierLesson == null ||
            frontierLesson.id == lastPlayedLesson.id);
    if (shouldResumeLastPlayed) {
      return _recommendationForLesson(
        course: course,
        lesson: lastPlayedLesson,
        source: StudyHarmonyRecommendationSource.lastPlayed,
        focusSkillTags: lastPlayedLesson.skillTags,
      );
    }

    final frontierLessonToOpen = frontierLesson ?? _fallbackLesson(course);
    return _recommendationForLesson(
      course: course,
      lesson: frontierLessonToOpen,
      source: StudyHarmonyRecommendationSource.frontier,
      focusSkillTags: frontierLessonToOpen.skillTags,
    );
  }

  StudyHarmonyLessonRecommendation? reviewRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final rankedCandidates = _rankReviewCandidates(course);
    if (rankedCandidates.isEmpty) {
      final fallback = continueRecommendationForCourse(course);
      if (fallback == null) {
        return null;
      }
      return StudyHarmonyLessonRecommendation(
        lesson: fallback.lesson,
        chapter: fallback.chapter,
        source: fallback.source,
        sessionMode: StudyHarmonySessionMode.review,
        sourceLessons: <StudyHarmonyLessonDefinition>[fallback.lesson],
        focusSkillTags: fallback.focusSkillTags,
        reviewReason: 'frontier-refresh',
      );
    }

    final strongest = rankedCandidates.first;
    final sourceLessons = <StudyHarmonyLessonDefinition>[];
    final threshold = strongest.score * 0.6;
    for (final candidate in rankedCandidates) {
      if (candidate.score < threshold && sourceLessons.length >= 2) {
        break;
      }
      if (sourceLessons.any((lesson) => lesson.id == candidate.lesson.id)) {
        continue;
      }
      sourceLessons.add(candidate.lesson);
      if (sourceLessons.length >= 3) {
        break;
      }
    }

    return _recommendationForLesson(
      course: course,
      lesson: strongest.lesson,
      source: strongest.entry != null
          ? StudyHarmonyRecommendationSource.reviewQueue
          : StudyHarmonyRecommendationSource.weakSpot,
      sessionMode: StudyHarmonySessionMode.review,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      reviewEntry: strongest.entry,
      reviewReason: strongest.reason,
    );
  }

  StudyHarmonyLessonRecommendation? focusSprintRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final rankedCandidates = _rankReviewCandidates(course);
    final frontierLesson =
        _frontierLessonForCourse(course) ??
        continueRecommendationForCourse(course)?.lesson;
    final sourceLessons = <StudyHarmonyLessonDefinition>[];
    void addLesson(StudyHarmonyLessonDefinition? lesson) {
      if (lesson == null || !_isLessonAccessible(course, lesson)) {
        return;
      }
      if (sourceLessons.any((candidate) => candidate.id == lesson.id)) {
        return;
      }
      sourceLessons.add(lesson);
    }

    addLesson(frontierLesson);
    for (final candidate in rankedCandidates) {
      addLesson(candidate.lesson);
      if (sourceLessons.length >= 4) {
        break;
      }
    }

    if (sourceLessons.length < 3 && frontierLesson != null) {
      final sameChapterLessons = _orderedLessons(course)
          .where(
            (lesson) =>
                lesson.chapterId == frontierLesson.chapterId &&
                lesson.id != frontierLesson.id,
          )
          .toList(growable: false);
      for (final lesson in sameChapterLessons) {
        addLesson(lesson);
        if (sourceLessons.length >= 3) {
          break;
        }
      }
    }

    if (sourceLessons.isEmpty) {
      addLesson(_fallbackLesson(course));
    }
    if (sourceLessons.isEmpty) {
      return null;
    }

    final anchorLesson = rankedCandidates.isNotEmpty
        ? rankedCandidates.first.lesson
        : sourceLessons.first;

    return _recommendationForLesson(
      course: course,
      lesson: anchorLesson,
      source: rankedCandidates.isNotEmpty
          ? StudyHarmonyRecommendationSource.weakSpot
          : StudyHarmonyRecommendationSource.frontier,
      sessionMode: StudyHarmonySessionMode.focus,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      reviewReason: rankedCandidates.isNotEmpty
          ? rankedCandidates.first.reason
          : 'focus-sprint',
    );
  }

  StudyHarmonyLessonRecommendation? relayRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final accessibleLessons = _orderedLessons(course)
        .where((lesson) => _isLessonAccessible(course, lesson))
        .toList(growable: false);
    final accessibleChapterIds = {
      for (final lesson in accessibleLessons) lesson.chapterId,
    };
    if (accessibleLessons.length < 3 || accessibleChapterIds.length < 2) {
      return null;
    }

    final frontierLesson =
        _frontierLessonForCourse(course) ?? accessibleLessons.first;
    final rankedCandidates = _rankReviewCandidates(course);
    final accessibleBossLessons = accessibleLessons
        .where(_isBossLessonDefinition)
        .toList(growable: false);
    final selected = <StudyHarmonyLessonDefinition>[];

    void addLesson(StudyHarmonyLessonDefinition? lesson) {
      if (lesson == null || !_isLessonAccessible(course, lesson)) {
        return;
      }
      if (selected.any((candidate) => candidate.id == lesson.id)) {
        return;
      }
      selected.add(lesson);
    }

    addLesson(frontierLesson);

    for (final candidate in rankedCandidates) {
      if (candidate.lesson.chapterId != frontierLesson.chapterId) {
        addLesson(candidate.lesson);
        break;
      }
    }
    if (selected.length < 2 && rankedCandidates.isNotEmpty) {
      addLesson(rankedCandidates.first.lesson);
    }

    for (final lesson in accessibleBossLessons) {
      if (selected.every(
        (candidate) => candidate.chapterId != lesson.chapterId,
      )) {
        addLesson(lesson);
        if (selected.length >= 3) {
          break;
        }
      }
    }

    final representedChapters = <StudyHarmonyChapterId>{
      for (final lesson in selected) lesson.chapterId,
    };
    if (representedChapters.length < 3) {
      for (final lesson in accessibleLessons.reversed) {
        if (representedChapters.contains(lesson.chapterId)) {
          continue;
        }
        addLesson(lesson);
        representedChapters.add(lesson.chapterId);
        if (selected.length >= 4 || representedChapters.length >= 3) {
          break;
        }
      }
    }

    if (selected.length < 4) {
      for (final candidate in rankedCandidates) {
        addLesson(candidate.lesson);
        if (selected.length >= 4) {
          break;
        }
      }
    }

    if (selected.length < 4) {
      for (final lesson in accessibleLessons) {
        addLesson(lesson);
        if (selected.length >= 4) {
          break;
        }
      }
    }

    final chapterSpread = {for (final lesson in selected) lesson.chapterId};
    if (selected.length < 3 || chapterSpread.length < 2) {
      return null;
    }

    final anchorLesson = selected.firstWhere(
      (lesson) => lesson.chapterId == frontierLesson.chapterId,
      orElse: () => frontierLesson,
    );
    return _recommendationForLesson(
      course: course,
      lesson: anchorLesson,
      source: rankedCandidates.isNotEmpty
          ? StudyHarmonyRecommendationSource.weakSpot
          : StudyHarmonyRecommendationSource.frontier,
      sessionMode: StudyHarmonySessionMode.relay,
      sourceLessons: selected,
      focusSkillTags: _focusSkillTagsForLessons(selected),
      reviewReason: 'arena-relay',
    );
  }

  StudyHarmonyLessonRecommendation? legendTrialRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    StudyHarmonyChapterDefinition? candidateChapter;
    for (final chapter in course.chapters) {
      if (_chapterMasteryTierFor(chapter, snapshot: _snapshot).index <
          StudyHarmonyChapterMasteryTier.silver.index) {
        continue;
      }
      if (_snapshot.legendaryChapterIds.contains(chapter.id)) {
        continue;
      }
      candidateChapter = chapter;
      break;
    }
    if (candidateChapter == null) {
      return null;
    }

    final sourceLessons = candidateChapter.lessons;
    final anchorLesson = sourceLessons.lastWhere(
      _isBossLessonDefinition,
      orElse: () => sourceLessons.last,
    );
    return _recommendationForLesson(
      course: course,
      lesson: anchorLesson,
      source: StudyHarmonyRecommendationSource.frontier,
      sessionMode: StudyHarmonySessionMode.legend,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      reviewReason: 'legend-trial',
    );
  }

  StudyHarmonyLessonRecommendation? bossRushRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final accessibleBossLessons = _orderedLessons(course)
        .where(
          (lesson) =>
              _isLessonAccessible(course, lesson) &&
              _isBossLessonDefinition(lesson),
        )
        .toList(growable: false);
    if (accessibleBossLessons.length < 2) {
      return null;
    }

    final rankedCandidates = _rankReviewCandidates(course);
    final prioritizedBossLessons = <StudyHarmonyLessonDefinition>[
      for (final candidate in rankedCandidates)
        if (_isBossLessonDefinition(candidate.lesson) &&
            accessibleBossLessons.any(
              (lesson) => lesson.id == candidate.lesson.id,
            ))
          candidate.lesson,
      for (final lesson in accessibleBossLessons)
        if (!rankedCandidates.any(
          (candidate) => candidate.lesson.id == lesson.id,
        ))
          lesson,
    ];

    final sourceLessons = <StudyHarmonyLessonDefinition>[];
    for (final lesson in prioritizedBossLessons) {
      if (sourceLessons.any((candidate) => candidate.id == lesson.id)) {
        continue;
      }
      sourceLessons.add(lesson);
      if (sourceLessons.length >= 3) {
        break;
      }
    }

    final anchorLesson = sourceLessons.isEmpty
        ? accessibleBossLessons.first
        : sourceLessons.first;
    return _recommendationForLesson(
      course: course,
      lesson: anchorLesson,
      source: StudyHarmonyRecommendationSource.weakSpot,
      sessionMode: StudyHarmonySessionMode.bossRush,
      sourceLessons: sourceLessons.isEmpty
          ? <StudyHarmonyLessonDefinition>[anchorLesson]
          : sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(
        sourceLessons.isEmpty
            ? <StudyHarmonyLessonDefinition>[anchorLesson]
            : sourceLessons,
      ),
      reviewReason: 'boss-rush',
    );
  }

  StudyHarmonyLessonRecommendation? dailyChallengeRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final unlockedLessons = _orderedLessons(course)
        .where((lesson) => _isLessonAccessible(course, lesson))
        .toList(growable: false);
    if (unlockedLessons.isEmpty) {
      return null;
    }

    final dateKey = _dailyDateKey(_nowProvider());
    final metadata = _snapshot.dailyChallengeSeedMetadata;
    if (metadata != null &&
        metadata.dateKey == dateKey &&
        metadata.trackId == course.trackId) {
      final storedLesson = _lessonForId(course, metadata.lessonId);
      final storedSourceLessons = metadata.sourceLessonIds
          .map((lessonId) => _lessonForId(course, lessonId))
          .whereType<StudyHarmonyLessonDefinition>()
          .where((lesson) => _isLessonAccessible(course, lesson))
          .toList(growable: false);
      if (storedLesson != null && _isLessonAccessible(course, storedLesson)) {
        final sourceLessons = storedSourceLessons.isEmpty
            ? <StudyHarmonyLessonDefinition>[storedLesson]
            : storedSourceLessons;
        return _recommendationForLesson(
          course: course,
          lesson: storedLesson,
          source: StudyHarmonyRecommendationSource.dailySeed,
          sessionMode: StudyHarmonySessionMode.daily,
          sourceLessons: sourceLessons,
          focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
          dailyDateKey: dateKey,
          seedValue: metadata.seedValue,
        );
      }
    }

    final seedValue = _dailySeedValue(course, dateKey);
    final sourceLessons = _buildDailySourceLessons(course, seedValue);
    if (sourceLessons.isEmpty) {
      return null;
    }
    return _recommendationForLesson(
      course: course,
      lesson: sourceLessons.first,
      source: StudyHarmonyRecommendationSource.dailySeed,
      sessionMode: StudyHarmonySessionMode.daily,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      dailyDateKey: dateKey,
      seedValue: seedValue,
    );
  }

  Future<StudyHarmonyLessonRecommendation?>
  prepareDailyChallengeRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) async {
    final recommendation = dailyChallengeRecommendationForCourse(course);
    if (recommendation == null || recommendation.dailyDateKey == null) {
      return recommendation;
    }

    final metadata = StudyHarmonyDailyChallengeSeedMetadata(
      version: 1,
      dateKey: recommendation.dailyDateKey!,
      seedValue:
          recommendation.seedValue ??
          _dailySeedValue(course, recommendation.dailyDateKey!),
      trackId: course.trackId,
      chapterId: recommendation.chapter.id,
      lessonId: recommendation.lesson.id,
      sourceLessonIds: [
        for (final lesson in recommendation.resolvedSourceLessons) lesson.id,
      ],
    );
    await _updateSnapshotIfChanged(
      _snapshot.copyWith(dailyChallengeSeedMetadata: metadata),
    );
    return recommendation;
  }

  Future<void> _updateSnapshotIfChanged(
    StudyHarmonyProgressSnapshot nextSnapshot,
  ) async {
    if (_isDisposed) {
      return;
    }
    nextSnapshot = _normalizedSnapshot(nextSnapshot);
    if (_snapshot.encode() == nextSnapshot.encode()) {
      return;
    }

    _snapshot = nextSnapshot;
    notifyListeners();

    _pendingSaveSnapshot = nextSnapshot;
    _saveQueue = _saveQueue.catchError((_) {}).then((_) async {
      final snapshotToSave = _pendingSaveSnapshot;
      if (snapshotToSave == null) {
        return;
      }
      _pendingSaveSnapshot = null;
      await _store.save(snapshotToSave);
    });
    await _saveQueue;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  StudyHarmonyProgressSnapshot _applyUnlockRulesToRegisteredCourses(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    var normalized = snapshot;
    for (final course in _coursesById.values) {
      normalized = _applyUnlockRules(normalized, course);
    }
    return normalized;
  }

  StudyHarmonyProgressSnapshot _applyUnlockRules(
    StudyHarmonyProgressSnapshot snapshot,
    StudyHarmonyCourseDefinition course,
  ) {
    final unlockedChapterIds = Set<StudyHarmonyChapterId>.from(
      snapshot.unlockedChapterIds,
    );
    final unlockedLessonIds = Set<StudyHarmonyLessonId>.from(
      snapshot.unlockedLessonIds,
    );

    if (course.chapters.isNotEmpty) {
      final firstChapter = course.chapters.first;
      unlockedChapterIds.add(firstChapter.id);
      if (firstChapter.lessons.isNotEmpty) {
        unlockedLessonIds.add(firstChapter.lessons.first.id);
      }
    }

    for (
      var chapterIndex = 0;
      chapterIndex < course.chapters.length;
      chapterIndex += 1
    ) {
      final chapter = course.chapters[chapterIndex];
      for (
        var lessonIndex = 0;
        lessonIndex < chapter.lessons.length;
        lessonIndex += 1
      ) {
        final lesson = chapter.lessons[lessonIndex];
        final lessonResult = snapshot.lessonResults[lesson.id];
        if (lessonResult?.isCleared != true) {
          continue;
        }

        if (lessonIndex + 1 < chapter.lessons.length) {
          unlockedLessonIds.add(chapter.lessons[lessonIndex + 1].id);
          continue;
        }

        if (chapterIndex + 1 < course.chapters.length) {
          final nextChapter = course.chapters[chapterIndex + 1];
          unlockedChapterIds.add(nextChapter.id);
          if (nextChapter.lessons.isNotEmpty) {
            unlockedLessonIds.add(nextChapter.lessons.first.id);
          }
        }
      }
    }

    return snapshot.copyWith(
      unlockedChapterIds: unlockedChapterIds,
      unlockedLessonIds: unlockedLessonIds,
    );
  }

  StudyHarmonyLessonProgressSummary _mergeLessonResult({
    required StudyHarmonyLessonProgressSummary? existing,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
    required DateTime playedAt,
  }) {
    final stars = _starsForResult(cleared: cleared, accuracy: accuracy);
    final rank = _rankForResult(cleared: cleared, accuracy: accuracy);
    final elapsedMillis = elapsed.inMilliseconds;

    if (existing == null) {
      return StudyHarmonyLessonProgressSummary(
        lessonId: _effectiveAnchorLessonId(lesson),
        isCleared: cleared,
        bestAccuracy: accuracy,
        bestAttemptCount: attempts,
        bestStars: stars,
        bestRank: rank,
        bestElapsedMillis: elapsedMillis,
        playCount: 1,
        lastPlayedAtIso8601: playedAt.toIso8601String(),
      );
    }

    return existing.copyWith(
      isCleared: existing.isCleared || cleared,
      bestAccuracy: accuracy > existing.bestAccuracy
          ? accuracy
          : existing.bestAccuracy,
      bestAttemptCount:
          existing.bestAttemptCount == 0 || attempts < existing.bestAttemptCount
          ? attempts
          : existing.bestAttemptCount,
      bestStars: stars > existing.bestStars ? stars : existing.bestStars,
      bestRank: _betterRank(existing.bestRank, rank),
      bestElapsedMillis:
          existing.bestElapsedMillis == 0 ||
              (elapsedMillis > 0 && elapsedMillis < existing.bestElapsedMillis)
          ? elapsedMillis
          : existing.bestElapsedMillis,
      playCount: existing.playCount + 1,
      lastPlayedAtIso8601: playedAt.toIso8601String(),
    );
  }

  Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>
  _mergeSkillMasteryPlaceholders({
    required Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>
    skillSummaries,
    required DateTime updatedAt,
  }) {
    final nextMastery =
        Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>.from(
          _snapshot.skillMasteryPlaceholders,
        );

    for (final entry in skillSummaries.entries) {
      final skillId = entry.key;
      if (skillId == 'legacy' || skillId.startsWith('legacy:')) {
        continue;
      }

      final summary = entry.value;
      final existing = nextMastery[skillId];
      final previousStreak = existing?.confidenceStreak ?? 0;
      final nextStreak = summary.accuracy >= 0.85
          ? previousStreak + 1
          : summary.accuracy < 0.65
          ? 0
          : previousStreak;
      final nextRecentScores = [
        ...(existing?.recentAttemptScores ?? const <double>[]),
        summary.accuracy,
      ];
      if (nextRecentScores.length > 5) {
        nextRecentScores.removeRange(0, nextRecentScores.length - 5);
      }

      final previousScore = existing?.masteryScore ?? 0.45;
      final nextScore = _clampUnitDouble(
        previousScore +
            _masteryDelta(
              accuracy: summary.accuracy,
              attemptCount: summary.attemptCount,
              previousStreak: previousStreak,
            ),
      );

      nextMastery[skillId] = StudyHarmonySkillMasteryPlaceholder(
        skillId: skillId,
        masteryScore: nextScore,
        exposureCount: (existing?.exposureCount ?? 0) + summary.attemptCount,
        correctSessionCount:
            (existing?.correctSessionCount ?? 0) +
            (summary.accuracy >= 0.85 ? 1 : 0),
        recentAttemptScores: nextRecentScores,
        recentAccuracy: _averageDoubles(nextRecentScores),
        confidenceStreak: nextStreak,
        lastSeenAtIso8601: updatedAt.toIso8601String(),
      );
    }

    return nextMastery;
  }

  List<StudyHarmonyReviewQueuePlaceholderEntry> _mergeReviewQueuePlaceholders({
    required Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>
    lessonSummaries,
    required StudyHarmonyLessonDefinition sessionLesson,
    required DateTime updatedAt,
  }) {
    final updatedLessonIds = lessonSummaries.keys.toSet();
    final nextQueue = _snapshot.reviewQueuePlaceholders
        .where((entry) => !updatedLessonIds.contains(entry.lessonId))
        .toList(growable: true);

    for (final summary in lessonSummaries.values) {
      final lessonDefinition = _registeredLessonById(summary.lessonId);
      final skillTags = lessonDefinition?.skillTags.isNotEmpty == true
          ? lessonDefinition!.skillTags
          : sessionLesson.sessionMetadata.focusSkillTags;

      if (summary.accuracy < 0.7) {
        nextQueue.add(
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:${summary.lessonId}',
            lessonId: summary.lessonId,
            reason: 'retry-needed',
            dueAtIso8601: updatedAt
                .add(const Duration(hours: 12))
                .toIso8601String(),
            priority: 3,
            skillTags: skillTags,
          ),
        );
        continue;
      }

      if (summary.accuracy < 0.9 || _averageMasteryForSkills(skillTags) < 0.6) {
        nextQueue.add(
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:${summary.lessonId}',
            lessonId: summary.lessonId,
            reason: summary.accuracy < 0.9 ? 'accuracy-refresh' : 'low-mastery',
            dueAtIso8601: updatedAt
                .add(const Duration(days: 1))
                .toIso8601String(),
            priority: summary.accuracy < 0.8 ? 2 : 1,
            skillTags: skillTags,
          ),
        );
      }
    }

    nextQueue.sort((left, right) {
      final priorityCompare = right.priority.compareTo(left.priority);
      if (priorityCompare != 0) {
        return priorityCompare;
      }
      return left.dueAtIso8601.compareTo(right.dueAtIso8601);
    });
    return nextQueue;
  }

  static DateTime _defaultNowProvider() => DateTime.now();

  int _starsForResult({required bool cleared, required double accuracy}) {
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

  String _rankForResult({required bool cleared, required double accuracy}) {
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

  String _betterRank(String left, String right) {
    const rankOrder = <String, int>{'S': 4, 'A': 3, 'B': 2, 'C': 1};
    final leftScore = rankOrder[left] ?? 0;
    final rightScore = rankOrder[right] ?? 0;
    return rightScore > leftScore ? right : left;
  }

  StudyHarmonyLessonRecommendation? _recommendationForLesson({
    required StudyHarmonyCourseDefinition course,
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonyRecommendationSource source,
    StudyHarmonySessionMode sessionMode = StudyHarmonySessionMode.lesson,
    List<StudyHarmonyLessonDefinition> sourceLessons =
        const <StudyHarmonyLessonDefinition>[],
    Set<StudyHarmonySkillTag> focusSkillTags = const <StudyHarmonySkillTag>{},
    StudyHarmonyReviewQueuePlaceholderEntry? reviewEntry,
    String? reviewReason,
    String? dailyDateKey,
    int? seedValue,
  }) {
    final chapter = _chapterForLesson(course, lesson);
    if (chapter == null) {
      return null;
    }
    return StudyHarmonyLessonRecommendation(
      lesson: lesson,
      chapter: chapter,
      source: source,
      sessionMode: sessionMode,
      sourceLessons: sourceLessons,
      focusSkillTags: focusSkillTags,
      reviewEntry: reviewEntry,
      reviewReason: reviewReason,
      dailyDateKey: dailyDateKey,
      seedValue: seedValue,
    );
  }

  StudyHarmonyLessonDefinition? _frontierLessonForCourse(
    StudyHarmonyCourseDefinition course, {
    StudyHarmonyProgressSnapshot? snapshot,
  }) {
    final effectiveSnapshot = snapshot ?? _snapshot;
    for (final lesson in _orderedLessons(course)) {
      if (_isLessonAccessible(course, lesson, snapshot: effectiveSnapshot) &&
          !_isLessonCleared(effectiveSnapshot, lesson.id)) {
        return lesson;
      }
    }
    return null;
  }

  StudyHarmonyCourseDefinition? _courseForTrack(StudyHarmonyTrackId trackId) {
    for (final course in _coursesById.values) {
      if (course.trackId == trackId) {
        return course;
      }
    }
    return null;
  }

  StudyHarmonyChapterDefinition _starQuestChapterForCourse(
    StudyHarmonyCourseDefinition course, {
    StudyHarmonyProgressSnapshot? snapshot,
  }) {
    final effectiveSnapshot = snapshot ?? _snapshot;
    for (final chapter in course.chapters) {
      final summary = _chapterProgressFor(chapter, snapshot: effectiveSnapshot);
      if (summary.unlocked && !summary.isCompleted) {
        return chapter;
      }
    }
    for (final chapter in course.chapters.reversed) {
      if (_chapterProgressFor(chapter, snapshot: effectiveSnapshot).unlocked) {
        return chapter;
      }
    }
    return course.chapters.first;
  }

  List<StudyHarmonyQuestProgressView> _questBoardForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final dateKey = _dailyDateKey(referenceDate);
    final currentStreak = _currentDailyStreakForDateKeys(
      _allStreakDateKeys(
        completedDailyDateKeys: snapshot.completedDailyChallengeDateKeys,
        protectedDailyDateKeys: snapshot.protectedDailyChallengeDateKeys,
      ),
      referenceDate,
    );
    final dailyCompletedToday = snapshot.completedDailyChallengeDateKeys
        .contains(dateKey);
    final frontierCompletedToday = snapshot.completedFrontierQuestDateKeys
        .contains(dateKey);
    final starQuestChapter = _starQuestChapterForCourse(
      course,
      snapshot: snapshot,
    );
    final starQuestTarget = _starQuestTargetForChapter(starQuestChapter);
    final starQuestCurrent = _starsEarnedForChapter(
      starQuestChapter,
      snapshot: snapshot,
    );
    final frontierLesson = _frontierLessonForCourse(course, snapshot: snapshot);
    final frontierChapter = frontierLesson == null
        ? null
        : _chapterForLesson(course, frontierLesson);

    return <StudyHarmonyQuestProgressView>[
      StudyHarmonyQuestProgressView(
        kind: StudyHarmonyQuestKind.dailyStreak,
        current: currentStreak,
        target: _dailyStreakTarget(currentStreak),
        completedToday: dailyCompletedToday,
        countsTowardChest: dailyCompletedToday,
      ),
      StudyHarmonyQuestProgressView(
        kind: StudyHarmonyQuestKind.frontierLesson,
        current: frontierCompletedToday ? 1 : 0,
        target: 1,
        lesson: frontierLesson,
        chapter: frontierChapter,
        completedToday: frontierCompletedToday,
        countsTowardChest: frontierCompletedToday,
      ),
      StudyHarmonyQuestProgressView(
        kind: StudyHarmonyQuestKind.chapterStars,
        current: starQuestCurrent,
        target: starQuestTarget,
        chapter: starQuestChapter,
        countsTowardChest: starQuestCurrent >= starQuestTarget,
      ),
    ];
  }

  StudyHarmonyQuestChestProgressView _questChestStatusForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final quests = _questBoardForCourse(
      course,
      snapshot: snapshot,
      referenceDate: referenceDate,
    );
    final dateKey = _dailyDateKey(referenceDate);
    return StudyHarmonyQuestChestProgressView(
      dateKey: dateKey,
      completedQuestCount: quests
          .where((quest) => quest.countsTowardChest)
          .length,
      totalQuestCount: quests.length,
      rewardLeagueXp: _dailyQuestChestLeagueXpReward,
      openedCount: snapshot.questChestCount,
      openedToday: snapshot.awardedDailyQuestChestDateKeys.contains(dateKey),
    );
  }

  StudyHarmonyLeagueXpBoostProgressView _leagueXpBoostForSnapshot(
    StudyHarmonyProgressSnapshot snapshot, {
    required DateTime referenceDate,
  }) {
    final active = max(0, snapshot.activeLeagueXpBoostCharges);
    return StudyHarmonyLeagueXpBoostProgressView(
      chargeCount: active,
      multiplier: _leagueXpBoostMultiplier,
      dateKey: active > 0
          ? snapshot.activeLeagueXpBoostDateKey ?? _dailyDateKey(referenceDate)
          : null,
    );
  }

  bool _countsTowardMonthlySpotlight(StudyHarmonyLessonDefinition lesson) {
    if (_isBossLessonDefinition(lesson)) {
      return true;
    }
    return switch (lesson.sessionMode) {
      StudyHarmonySessionMode.focus ||
      StudyHarmonySessionMode.relay ||
      StudyHarmonySessionMode.bossRush ||
      StudyHarmonySessionMode.legend => true,
      _ => false,
    };
  }

  StudyHarmonyLessonRecommendation? _chapterStarQuestRecommendation(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyQuestProgressView quest,
  ) {
    final targetChapter = quest.chapter;
    if (targetChapter == null) {
      return null;
    }
    for (final lesson in targetChapter.lessons) {
      if (!_isLessonAccessible(course, lesson)) {
        continue;
      }
      final result = lessonResultFor(lesson.id);
      if (!(result?.isCleared ?? false) || (result?.bestStars ?? 0) < 2) {
        return _recommendationForLesson(
          course: course,
          lesson: lesson,
          source: StudyHarmonyRecommendationSource.frontier,
          focusSkillTags: lesson.skillTags,
        );
      }
    }
    return null;
  }

  int _starQuestTargetForChapter(StudyHarmonyChapterDefinition chapter) {
    return max(4, chapter.lessons.length * 2);
  }

  int _silverStarTargetForChapter(StudyHarmonyChapterDefinition chapter) {
    return chapter.lessons.length * 2;
  }

  int _goldStarTargetForChapter(StudyHarmonyChapterDefinition chapter) {
    return chapter.lessons.length * 3;
  }

  static const int _dailyQuestChestLeagueXpReward = 12;
  static const int _leagueXpBoostMultiplier = 2;
  static const int _questChestLeagueXpBoostChargeCount = 2;
  static const int _monthlyTourLeagueXpReward = 18;
  static const int _monthlyTourStreakSaverReward = 1;
  static const int _monthlyTourStreakSaverCap = 3;
  static const int _duetPactLeagueXpReward = 10;
  static const List<int> _duetPactRewardThresholds = <int>[3, 7, 14];

  int _dailyStreakTarget(int currentStreak) {
    if (currentStreak >= 7) {
      return currentStreak + 1;
    }
    if (currentStreak >= 3) {
      return 7;
    }
    return 3;
  }

  int _leagueScoreDelta({
    required StudyHarmonySessionMode sessionMode,
    required bool cleared,
    required int sessionStars,
    required double accuracy,
  }) {
    final base = switch (sessionMode) {
      StudyHarmonySessionMode.lesson => 10,
      StudyHarmonySessionMode.review => 8,
      StudyHarmonySessionMode.daily => 14,
      StudyHarmonySessionMode.focus => 16,
      StudyHarmonySessionMode.relay => 18,
      StudyHarmonySessionMode.bossRush => 20,
      StudyHarmonySessionMode.legend => 24,
      StudyHarmonySessionMode.legacyLevel => 6,
    };
    final starBonus = sessionStars * 3;
    final accuracyBonus = accuracy >= 0.95
        ? 4
        : accuracy >= 0.85
        ? 2
        : 0;
    if (cleared) {
      return base + starBonus + accuracyBonus;
    }
    return max(4, (base / 3).round());
  }

  StudyHarmonyLeagueProgressView _leagueProgressForScore({
    required String weekKey,
    required int score,
  }) {
    final tier = _leagueTierForScore(score);
    final nextTier = _nextLeagueTier(tier);
    return StudyHarmonyLeagueProgressView(
      weekKey: weekKey,
      score: score,
      tier: tier,
      currentTierFloor: _leagueFloorForTier(tier),
      nextTier: nextTier,
      nextTarget: nextTier == null ? null : _leagueFloorForTier(nextTier),
    );
  }

  StudyHarmonyLeagueTier _leagueTierForScore(int score) {
    if (score >= _leagueFloorForTier(StudyHarmonyLeagueTier.diamond)) {
      return StudyHarmonyLeagueTier.diamond;
    }
    if (score >= _leagueFloorForTier(StudyHarmonyLeagueTier.gold)) {
      return StudyHarmonyLeagueTier.gold;
    }
    if (score >= _leagueFloorForTier(StudyHarmonyLeagueTier.silver)) {
      return StudyHarmonyLeagueTier.silver;
    }
    if (score >= _leagueFloorForTier(StudyHarmonyLeagueTier.bronze)) {
      return StudyHarmonyLeagueTier.bronze;
    }
    return StudyHarmonyLeagueTier.rookie;
  }

  int _leagueFloorForTier(StudyHarmonyLeagueTier tier) {
    return switch (tier) {
      StudyHarmonyLeagueTier.rookie => 0,
      StudyHarmonyLeagueTier.bronze => 40,
      StudyHarmonyLeagueTier.silver => 100,
      StudyHarmonyLeagueTier.gold => 180,
      StudyHarmonyLeagueTier.diamond => 300,
    };
  }

  StudyHarmonyLeagueTier? _nextLeagueTier(StudyHarmonyLeagueTier tier) {
    return switch (tier) {
      StudyHarmonyLeagueTier.rookie => StudyHarmonyLeagueTier.bronze,
      StudyHarmonyLeagueTier.bronze => StudyHarmonyLeagueTier.silver,
      StudyHarmonyLeagueTier.silver => StudyHarmonyLeagueTier.gold,
      StudyHarmonyLeagueTier.gold => StudyHarmonyLeagueTier.diamond,
      StudyHarmonyLeagueTier.diamond => null,
    };
  }

  int _starsEarnedForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    return _orderedLessons(course).fold<int>(
      0,
      (sum, lesson) =>
          sum + (snapshot.lessonResults[lesson.id]?.bestStars ?? 0),
    );
  }

  int _starsEarnedForChapter(
    StudyHarmonyChapterDefinition chapter, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    return chapter.lessons.fold<int>(
      0,
      (sum, lesson) =>
          sum + (snapshot.lessonResults[lesson.id]?.bestStars ?? 0),
    );
  }

  int _masteredSkillCountForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required double masteryThreshold,
  }) {
    return course.skillTags.where((skillId) {
      final mastery = snapshot.skillMasteryPlaceholders[skillId];
      return mastery != null && mastery.masteryScore >= masteryThreshold;
    }).length;
  }

  int _clearedLessonCountForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    return _orderedLessons(course)
        .where(
          (lesson) => snapshot.lessonResults[lesson.id]?.isCleared ?? false,
        )
        .length;
  }

  StudyHarmonyChapterMasteryTier _chapterMasteryTierFor(
    StudyHarmonyChapterDefinition chapter, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    final clearedLessonCount = chapter.lessons
        .where(
          (lesson) => snapshot.lessonResults[lesson.id]?.isCleared ?? false,
        )
        .length;
    final lessonCount = chapter.lessons.length;
    if (lessonCount == 0 || clearedLessonCount < lessonCount) {
      return StudyHarmonyChapterMasteryTier.none;
    }
    if (snapshot.legendaryChapterIds.contains(chapter.id)) {
      return StudyHarmonyChapterMasteryTier.legendary;
    }

    final stars = _starsEarnedForChapter(chapter, snapshot: snapshot);
    if (stars >= _goldStarTargetForChapter(chapter)) {
      return StudyHarmonyChapterMasteryTier.gold;
    }
    if (stars >= _silverStarTargetForChapter(chapter)) {
      return StudyHarmonyChapterMasteryTier.silver;
    }
    return StudyHarmonyChapterMasteryTier.bronze;
  }

  List<StudyHarmonyMilestoneProgressView> _milestoneBoardForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    final lessonTargets = <int>[5, 10, 20, _orderedLessons(course).length];
    final starTargets = <int>[
      12,
      24,
      48,
      max(60, _orderedLessons(course).length * 2),
    ];
    final streakTargets = <int>[3, 5, 7, 14];
    final masteryTargets = <int>[
      3,
      6,
      9,
      max(12, min(15, course.skillTags.length)),
    ];
    final relayTargets = <int>[1, 3, 5, 8];

    return <StudyHarmonyMilestoneProgressView>[
      _milestoneProgress(
        kind: StudyHarmonyMilestoneKind.lessonPath,
        current: _clearedLessonCountForCourse(course, snapshot: snapshot),
        targets: lessonTargets,
      ),
      _milestoneProgress(
        kind: StudyHarmonyMilestoneKind.starCollector,
        current: _starsEarnedForCourse(course, snapshot: snapshot),
        targets: starTargets,
      ),
      _milestoneProgress(
        kind: StudyHarmonyMilestoneKind.streakLegend,
        current: _bestDailyChallengeStreakForSnapshot(snapshot),
        targets: streakTargets,
      ),
      _milestoneProgress(
        kind: StudyHarmonyMilestoneKind.masteryScholar,
        current: _masteredSkillCountForCourse(
          course,
          snapshot: snapshot,
          masteryThreshold: 0.75,
        ),
        targets: masteryTargets,
      ),
      _milestoneProgress(
        kind: StudyHarmonyMilestoneKind.relayRunner,
        current: snapshot.relayWinCount,
        targets: relayTargets,
      ),
    ];
  }

  List<StudyHarmonyWeeklyGoalProgressView> _weeklyPlanForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final weekKey = _weekKey(referenceDate);
    const activeDayTarget = 3;
    const dailyTarget = 2;

    return <StudyHarmonyWeeklyGoalProgressView>[
      StudyHarmonyWeeklyGoalProgressView(
        kind: StudyHarmonyWeeklyGoalKind.activeDays,
        current: _dateKeyCountForWeek(
          snapshot.activityDateKeys,
          referenceDate: referenceDate,
        ),
        target: activeDayTarget,
        weekKey: weekKey,
        rewardClaimed: snapshot.awardedWeeklyPlanWeekKeys.contains(weekKey),
      ),
      StudyHarmonyWeeklyGoalProgressView(
        kind: StudyHarmonyWeeklyGoalKind.dailyClears,
        current: _dateKeyCountForWeek(
          snapshot.completedDailyChallengeDateKeys,
          referenceDate: referenceDate,
        ),
        target: dailyTarget,
        weekKey: weekKey,
        rewardClaimed: snapshot.awardedWeeklyPlanWeekKeys.contains(weekKey),
      ),
      StudyHarmonyWeeklyGoalProgressView(
        kind: StudyHarmonyWeeklyGoalKind.focusSprint,
        current: _dateKeyCountForWeek(
          snapshot.completedFocusChallengeDateKeys,
          referenceDate: referenceDate,
        ),
        target: 1,
        weekKey: weekKey,
        rewardClaimed: snapshot.awardedWeeklyPlanWeekKeys.contains(weekKey),
      ),
    ];
  }

  _WeeklyPlanRewardResult _applyWeeklyPlanReward(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final weekKey = _weekKey(referenceDate);
    if (snapshot.awardedWeeklyPlanWeekKeys.contains(weekKey)) {
      return _WeeklyPlanRewardResult(snapshot: snapshot, rewardUnlocked: false);
    }

    final weeklyPlan = _weeklyPlanForCourse(
      course,
      snapshot: snapshot,
      referenceDate: referenceDate,
    );
    final completed = weeklyPlan.every((goal) => goal.completed);
    if (!completed) {
      return _WeeklyPlanRewardResult(snapshot: snapshot, rewardUnlocked: false);
    }

    final rewardUnlocked = snapshot.streakSaverCount < 2;

    return _WeeklyPlanRewardResult(
      snapshot: snapshot.copyWith(
        awardedWeeklyPlanWeekKeys: {
          ...snapshot.awardedWeeklyPlanWeekKeys,
          weekKey,
        },
        streakSaverCount: min(snapshot.streakSaverCount + 1, 2),
      ),
      rewardUnlocked: rewardUnlocked,
    );
  }

  StudyHarmonyMonthlyTourProgressView _monthlyTourForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final _ = course;
    final monthKey = _monthKey(referenceDate);
    const activeDayTarget = 8;
    const questChestTarget = 4;
    const spotlightTarget = 4;

    final goals = <StudyHarmonyMonthlyGoalProgressView>[
      StudyHarmonyMonthlyGoalProgressView(
        kind: StudyHarmonyMonthlyGoalKind.activeDays,
        current: _dateKeyCountForMonth(
          snapshot.activityDateKeys,
          referenceDate: referenceDate,
        ),
        target: activeDayTarget,
        monthKey: monthKey,
      ),
      StudyHarmonyMonthlyGoalProgressView(
        kind: StudyHarmonyMonthlyGoalKind.questChests,
        current: _dateKeyCountForMonth(
          snapshot.awardedDailyQuestChestDateKeys,
          referenceDate: referenceDate,
        ),
        target: questChestTarget,
        monthKey: monthKey,
      ),
      StudyHarmonyMonthlyGoalProgressView(
        kind: StudyHarmonyMonthlyGoalKind.spotlightClears,
        current: max(0, snapshot.monthlySpotlightClearCounts[monthKey] ?? 0),
        target: spotlightTarget,
        monthKey: monthKey,
      ),
    ];

    return StudyHarmonyMonthlyTourProgressView(
      monthKey: monthKey,
      goals: goals,
      rewardClaimed: snapshot.awardedMonthlyTourMonthKeys.contains(monthKey),
      rewardLeagueXp: _monthlyTourLeagueXpReward,
      rewardStreakSavers: _monthlyTourStreakSaverReward,
    );
  }

  _MonthlyTourRewardResult _applyMonthlyTourReward(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final monthKey = _monthKey(referenceDate);
    if (snapshot.awardedMonthlyTourMonthKeys.contains(monthKey)) {
      return _MonthlyTourRewardResult(
        rewardUnlocked: false,
        leagueXpBonus: 0,
        snapshot: snapshot,
      );
    }

    final monthlyTour = _monthlyTourForCourse(
      course,
      snapshot: snapshot,
      referenceDate: referenceDate,
    );
    if (!monthlyTour.completed) {
      return _MonthlyTourRewardResult(
        rewardUnlocked: false,
        leagueXpBonus: 0,
        snapshot: snapshot,
      );
    }

    final weekKey = _weekKey(referenceDate);
    final nextWeeklyLeagueScores = Map<String, int>.from(
      snapshot.weeklyLeagueScores,
    );
    nextWeeklyLeagueScores[weekKey] =
        (nextWeeklyLeagueScores[weekKey] ?? 0) + _monthlyTourLeagueXpReward;

    final nextSnapshot = snapshot.copyWith(
      awardedMonthlyTourMonthKeys: {
        ...snapshot.awardedMonthlyTourMonthKeys,
        monthKey,
      },
      weeklyLeagueScores: nextWeeklyLeagueScores,
      streakSaverCount: min(
        snapshot.streakSaverCount + _monthlyTourStreakSaverReward,
        _monthlyTourStreakSaverCap,
      ),
    );
    return _MonthlyTourRewardResult(
      snapshot: nextSnapshot,
      rewardUnlocked: true,
      leagueXpBonus: _monthlyTourLeagueXpReward,
    );
  }

  StudyHarmonyDuetPactProgressView _duetPactProgressForSnapshot(
    StudyHarmonyProgressSnapshot snapshot, {
    required DateTime referenceDate,
  }) {
    final duetDateKeys = _duetPactDateKeys(snapshot);
    final currentStreak = _currentDailyStreakForDateKeys(
      duetDateKeys,
      referenceDate,
    );
    final bestStreak = max(
      snapshot.bestDuetPactStreak,
      _longestDailyStreakForDateKeys(duetDateKeys),
    );
    final todayKey = _dailyDateKey(referenceDate);
    final nextTarget = _duetPactRewardThresholds.firstWhere(
      (target) => bestStreak < target,
      orElse: () => _duetPactRewardThresholds.last,
    );
    return StudyHarmonyDuetPactProgressView(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      activeToday: duetDateKeys.contains(todayKey),
      nextTarget: nextTarget,
      rewardLeagueXp: _duetPactLeagueXpReward,
    );
  }

  _DuetPactRewardResult _applyDuetPactReward({
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
  }) {
    final beforeBest = _bestDuetPactStreakForSnapshot(_snapshot);
    final afterBest = _bestDuetPactStreakForSnapshot(snapshot);
    final unlockedThreshold = _duetPactRewardThresholds.firstWhere(
      (target) => beforeBest < target && afterBest >= target,
      orElse: () => 0,
    );
    if (unlockedThreshold <= 0) {
      return _DuetPactRewardResult(
        snapshot: snapshot,
        rewardUnlocked: false,
        leagueXpBonus: 0,
      );
    }

    final weekKey = _weekKey(referenceDate);
    final nextWeeklyLeagueScores = Map<String, int>.from(
      snapshot.weeklyLeagueScores,
    );
    nextWeeklyLeagueScores[weekKey] =
        (nextWeeklyLeagueScores[weekKey] ?? 0) + _duetPactLeagueXpReward;
    return _DuetPactRewardResult(
      snapshot: snapshot.copyWith(weeklyLeagueScores: nextWeeklyLeagueScores),
      rewardUnlocked: true,
      leagueXpBonus: _duetPactLeagueXpReward,
    );
  }

  _DailyQuestChestRewardResult _applyDailyQuestChestReward(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
    required DateTime referenceDate,
    required bool chapterStarsSatisfiedBefore,
  }) {
    final questBoard = _questBoardForCourse(
      course,
      snapshot: snapshot,
      referenceDate: referenceDate,
    );
    final completedQuestCount = questBoard.where((quest) {
      if (quest.kind == StudyHarmonyQuestKind.chapterStars) {
        return quest.countsTowardChest || chapterStarsSatisfiedBefore;
      }
      return quest.countsTowardChest;
    }).length;
    final dateKey = _dailyDateKey(referenceDate);
    final alreadyOpened = snapshot.awardedDailyQuestChestDateKeys.contains(
      dateKey,
    );
    if (alreadyOpened || completedQuestCount < questBoard.length) {
      return _DailyQuestChestRewardResult(
        snapshot: snapshot,
        chestOpened: false,
        leagueXpBonus: 0,
        leagueXpBoostUnlocked: false,
      );
    }

    final weekKey = _weekKey(referenceDate);
    final nextWeeklyLeagueScores = Map<String, int>.from(
      snapshot.weeklyLeagueScores,
    );
    nextWeeklyLeagueScores[weekKey] =
        (nextWeeklyLeagueScores[weekKey] ?? 0) + _dailyQuestChestLeagueXpReward;
    final activeLeagueXpBoost = _leagueXpBoostForSnapshot(
      snapshot,
      referenceDate: referenceDate,
    );
    final nextLeagueXpBoostCharges = max(
      activeLeagueXpBoost.chargeCount,
      _questChestLeagueXpBoostChargeCount,
    );

    return _DailyQuestChestRewardResult(
      snapshot: snapshot.copyWith(
        awardedDailyQuestChestDateKeys: {
          ...snapshot.awardedDailyQuestChestDateKeys,
          dateKey,
        },
        weeklyLeagueScores: nextWeeklyLeagueScores,
        questChestCount: snapshot.questChestCount + 1,
        activeLeagueXpBoostDateKey: dateKey,
        activeLeagueXpBoostCharges: nextLeagueXpBoostCharges,
      ),
      chestOpened: true,
      leagueXpBonus: _dailyQuestChestLeagueXpReward,
      leagueXpBoostUnlocked: true,
    );
  }

  Set<String> _earnedMilestoneIdsForCourse(
    StudyHarmonyCourseDefinition course, {
    required StudyHarmonyProgressSnapshot snapshot,
  }) {
    return {
      for (final milestone in _milestoneBoardForCourse(
        course,
        snapshot: snapshot,
      ))
        ..._earnedMilestoneIdsForProgress(milestone),
    };
  }

  Set<String> _earnedMilestoneIdsForProgress(
    StudyHarmonyMilestoneProgressView milestone,
  ) {
    return {
      for (var tier = 1; tier <= milestone.earnedCount; tier += 1)
        '${milestone.kind.name}-$tier',
    };
  }

  StudyHarmonyMilestoneProgressView _milestoneProgress({
    required StudyHarmonyMilestoneKind kind,
    required int current,
    required List<int> targets,
  }) {
    final normalizedTargets = {...targets}.toList(growable: false)..sort();
    final earnedCount = normalizedTargets
        .where((target) => current >= target)
        .length;
    final nextTarget = normalizedTargets.firstWhere(
      (target) => current < target,
      orElse: () => normalizedTargets.last,
    );
    return StudyHarmonyMilestoneProgressView(
      id: kind.name,
      kind: kind,
      current: current,
      target: nextTarget,
      earnedCount: earnedCount,
      totalTiers: normalizedTargets.length,
    );
  }

  List<StudyHarmonyLessonDefinition> _orderedLessons(
    StudyHarmonyCourseDefinition course,
  ) => [for (final chapter in course.chapters) ...chapter.lessons];

  bool _isBossLessonDefinition(StudyHarmonyLessonDefinition lesson) {
    return lesson.goalCorrectAnswers >= 9 || lesson.startingLives >= 4;
  }

  StudyHarmonyLessonDefinition _fallbackLesson(
    StudyHarmonyCourseDefinition course,
  ) {
    return course.chapters.first.lessons.first;
  }

  StudyHarmonyLessonDefinition? _lessonForId(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonId? lessonId,
  ) {
    if (lessonId == null) {
      return null;
    }
    for (final chapter in course.chapters) {
      for (final lesson in chapter.lessons) {
        if (lesson.id == lessonId) {
          return lesson;
        }
      }
    }
    return null;
  }

  StudyHarmonyLessonDefinition? _registeredLessonById(
    StudyHarmonyLessonId lessonId,
  ) {
    for (final course in _coursesById.values) {
      final lesson = _lessonForId(course, lessonId);
      if (lesson != null) {
        return lesson;
      }
    }
    return null;
  }

  StudyHarmonyChapterDefinition? _chapterForLesson(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonDefinition lesson,
  ) {
    for (final chapter in course.chapters) {
      if (chapter.lessons.any((candidate) => candidate.id == lesson.id)) {
        return chapter;
      }
    }
    return null;
  }

  bool _isLessonAccessible(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonDefinition lesson, {
    StudyHarmonyProgressSnapshot? snapshot,
  }) {
    final effectiveSnapshot = snapshot ?? _snapshot;
    final firstLessonId =
        course.chapters.isNotEmpty && course.chapters.first.lessons.isNotEmpty
        ? course.chapters.first.lessons.first.id
        : null;
    return _isLessonUnlocked(effectiveSnapshot, lesson.id) ||
        lesson.id == firstLessonId;
  }

  List<_ReviewCandidate> _rankReviewCandidates(
    StudyHarmonyCourseDefinition course,
  ) {
    final now = _nowProvider();
    final frontierLesson = _frontierLessonForCourse(course);
    final frontierSkills =
        frontierLesson?.skillTags ?? const <StudyHarmonySkillTag>{};
    final candidates = <_ReviewCandidate>[];

    for (final lesson in _orderedLessons(course)) {
      if (!_isLessonAccessible(course, lesson)) {
        continue;
      }

      final queueEntry = _bestReviewEntryForLesson(lesson.id);
      final result = _snapshot.lessonResults[lesson.id];
      final hasMasterySignal = lesson.skillTags.any(
        _snapshot.skillMasteryPlaceholders.containsKey,
      );
      if (queueEntry == null && result == null && !hasMasterySignal) {
        continue;
      }

      final masteryDebt = _masteryDebtForLesson(lesson);
      final recentMissFactor = _recentMissFactorForLesson(lesson);
      final staleDays = _stalenessDaysForLesson(lesson, now);
      final frontierOverlap = frontierSkills.isEmpty
          ? 0
          : lesson.skillTags.intersection(frontierSkills).length /
                frontierSkills.length;
      final dueBoost = queueEntry == null
          ? 0
          : 2.4 +
                (queueEntry.priority * 0.6) +
                (_isEntryDue(queueEntry, now) ? 0.4 : 0);
      final accuracyDebt = result == null
          ? 0.15
          : max(0, 0.85 - result.bestAccuracy);
      final unclearedBoost = result != null && !result.isCleared ? 0.75 : 0.0;
      final score =
          dueBoost +
          (masteryDebt * 2.1) +
          (recentMissFactor * 1.4) +
          (min(staleDays / 7, 2.0) * 0.7) +
          (frontierOverlap * 0.6) +
          (accuracyDebt * 1.8) +
          unclearedBoost;

      if (score <= 0.2) {
        continue;
      }

      candidates.add(
        _ReviewCandidate(
          lesson: lesson,
          score: score,
          reason:
              queueEntry?.reason ??
              (masteryDebt > 0.45
                  ? 'low-mastery'
                  : staleDays > 10
                  ? 'stale-skill'
                  : 'weak-spot'),
          entry: queueEntry,
        ),
      );
    }

    candidates.sort((left, right) {
      final scoreCompare = right.score.compareTo(left.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      final leftDue = left.entry == null
          ? 0
          : (_isEntryDue(left.entry!, now) ? 1 : 0);
      final rightDue = right.entry == null
          ? 0
          : (_isEntryDue(right.entry!, now) ? 1 : 0);
      return rightDue.compareTo(leftDue);
    });
    return candidates;
  }

  StudyHarmonyReviewQueuePlaceholderEntry? _bestReviewEntryForLesson(
    StudyHarmonyLessonId lessonId,
  ) {
    final matches = _snapshot.reviewQueuePlaceholders
        .where((entry) => entry.lessonId == lessonId)
        .toList(growable: false);
    if (matches.isEmpty) {
      return null;
    }
    final sorted = [...matches]
      ..sort((left, right) {
        final priorityCompare = right.priority.compareTo(left.priority);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return left.dueAtIso8601.compareTo(right.dueAtIso8601);
      });
    return sorted.first;
  }

  double _masteryDebtForLesson(StudyHarmonyLessonDefinition lesson) {
    final scores = [
      for (final skillId in lesson.skillTags)
        _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore,
    ].whereType<double>().toList(growable: false);
    if (scores.isNotEmpty) {
      return 1 - _averageDoubles(scores);
    }
    final result = _snapshot.lessonResults[lesson.id];
    if (result != null) {
      return 1 - result.bestAccuracy;
    }
    return 0.55;
  }

  double _recentMissFactorForLesson(StudyHarmonyLessonDefinition lesson) {
    final values = [
      for (final skillId in lesson.skillTags)
        if (_snapshot.skillMasteryPlaceholders[skillId] case final mastery?)
          mastery.recentAttemptCount == 0
              ? 0.0
              : mastery.recentIncorrectCount / mastery.recentAttemptCount,
    ];
    if (values.isNotEmpty) {
      return _averageDoubles(values);
    }
    final result = _snapshot.lessonResults[lesson.id];
    if (result == null) {
      return 0;
    }
    return max(0, 1 - result.bestAccuracy);
  }

  double _stalenessDaysForLesson(
    StudyHarmonyLessonDefinition lesson,
    DateTime now,
  ) {
    final timestamps = <DateTime>[
      if (_snapshot.lessonResults[lesson.id]?.lastPlayedAtIso8601
          case final value?)
        ?_parseIsoDate(value),
      for (final skillId in lesson.skillTags)
        if (_snapshot.skillMasteryPlaceholders[skillId]?.lastSeenAtIso8601
            case final value?)
          ?_parseIsoDate(value),
    ];
    if (timestamps.isEmpty) {
      return 0;
    }
    timestamps.sort((left, right) => right.compareTo(left));
    return now.toUtc().difference(timestamps.first).inHours / 24;
  }

  Set<StudyHarmonySkillTag> _focusSkillTagsForLessons(
    List<StudyHarmonyLessonDefinition> lessons,
  ) {
    final skillIds = {
      for (final lesson in lessons) ...lesson.skillTags,
    }.toList(growable: false);
    skillIds.sort((left, right) {
      final leftScore =
          _snapshot.skillMasteryPlaceholders[left]?.masteryScore ?? 0.45;
      final rightScore =
          _snapshot.skillMasteryPlaceholders[right]?.masteryScore ?? 0.45;
      final scoreCompare = leftScore.compareTo(rightScore);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return left.compareTo(right);
    });
    return skillIds.take(3).toSet();
  }

  List<StudyHarmonyLessonDefinition> _buildDailySourceLessons(
    StudyHarmonyCourseDefinition course,
    int seedValue,
  ) {
    final accessibleLessons = _orderedLessons(course)
        .where((lesson) => _isLessonAccessible(course, lesson))
        .toList(growable: false);
    if (accessibleLessons.isEmpty) {
      return const <StudyHarmonyLessonDefinition>[];
    }

    final now = _nowProvider();
    final frontierLesson =
        _frontierLessonForCourse(course) ?? accessibleLessons.first;
    final rankedReviewCandidates = _rankReviewCandidates(course);
    final dueReviewLessons = rankedReviewCandidates
        .where(
          (candidate) =>
              candidate.entry != null && _isEntryDue(candidate.entry!, now),
        )
        .map((candidate) => candidate.lesson)
        .toList(growable: false);
    final sameChapterLessons = accessibleLessons
        .where(
          (lesson) =>
              lesson.chapterId == frontierLesson.chapterId &&
              lesson.id != frontierLesson.id,
        )
        .toList(growable: false);
    final lastPlayedLesson = _lessonForId(course, lastPlayedLessonId);

    final selected = <StudyHarmonyLessonDefinition>[];
    void addLesson(StudyHarmonyLessonDefinition? lesson) {
      if (lesson == null || !_isLessonAccessible(course, lesson)) {
        return;
      }
      if (selected.any((candidate) => candidate.id == lesson.id)) {
        return;
      }
      selected.add(lesson);
    }

    addLesson(frontierLesson);
    if (dueReviewLessons.isNotEmpty) {
      addLesson(dueReviewLessons[seedValue % dueReviewLessons.length]);
      if (dueReviewLessons.length > 1) {
        addLesson(
          dueReviewLessons[(seedValue ~/ 7).abs() % dueReviewLessons.length],
        );
      }
    } else if (rankedReviewCandidates.isNotEmpty) {
      addLesson(rankedReviewCandidates.first.lesson);
    }
    if (sameChapterLessons.isNotEmpty) {
      addLesson(
        sameChapterLessons[(seedValue ~/ 11).abs() % sameChapterLessons.length],
      );
    }
    addLesson(lastPlayedLesson);

    if (selected.length < 3) {
      final rankedAccessible = [...accessibleLessons]
        ..sort(
          (left, right) => _seededOrder(
            seedValue,
            left.id,
          ).compareTo(_seededOrder(seedValue, right.id)),
        );
      for (final lesson in rankedAccessible) {
        addLesson(lesson);
        if (selected.length >= 3) {
          break;
        }
      }
    }

    return selected;
  }

  Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>
  _normalizedLessonSummaries({
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonySessionPerformance performance,
    required int attempts,
    required double accuracy,
  }) {
    if (performance.lessonSummaries.isNotEmpty) {
      return Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>.from(
        performance.lessonSummaries,
      );
    }

    final lessonId = _effectiveAnchorLessonId(lesson);
    return <StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>{
      lessonId: StudyHarmonyLessonSessionSummary(
        lessonId: lessonId,
        attemptCount: attempts,
        correctCount: _correctCountForAccuracy(attempts, accuracy),
      ),
    };
  }

  Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>
  _normalizedSkillSummaries({
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonySessionPerformance performance,
    required int attempts,
    required double accuracy,
  }) {
    if (performance.skillSummaries.isNotEmpty) {
      return Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>.from(
        performance.skillSummaries,
      );
    }

    final skillTags = lesson.sessionMetadata.focusSkillTags.isNotEmpty
        ? lesson.sessionMetadata.focusSkillTags
        : lesson.skillTags;
    if (skillTags.isEmpty) {
      return const <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{};
    }

    final correctCount = _correctCountForAccuracy(attempts, accuracy);
    return <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{
      for (final skillId in skillTags)
        skillId: StudyHarmonySkillSessionSummary(
          skillId: skillId,
          attemptCount: attempts,
          correctCount: correctCount,
        ),
    };
  }

  StudyHarmonySessionPerformance _defaultSessionPerformance({
    required StudyHarmonyLessonDefinition lesson,
    required int attempts,
    required double accuracy,
  }) {
    return StudyHarmonySessionPerformance(
      skillSummaries: _normalizedSkillSummaries(
        lesson: lesson,
        performance: const StudyHarmonySessionPerformance(),
        attempts: attempts,
        accuracy: accuracy,
      ),
      lessonSummaries: _normalizedLessonSummaries(
        lesson: lesson,
        performance: const StudyHarmonySessionPerformance(),
        attempts: attempts,
        accuracy: accuracy,
      ),
    );
  }

  int _correctCountForAccuracy(int attempts, double accuracy) {
    if (attempts <= 0) {
      return 0;
    }
    return (_clampUnitDouble(accuracy) * attempts).round().clamp(0, attempts);
  }

  StudyHarmonyLessonId _effectiveAnchorLessonId(
    StudyHarmonyLessonDefinition lesson,
  ) {
    return lesson.sessionMetadata.anchorLessonId ??
        (lesson.sessionMetadata.sourceLessonIds.isNotEmpty
            ? lesson.sessionMetadata.sourceLessonIds.first
            : lesson.id);
  }

  StudyHarmonyDailyChallengeSeedMetadata? _mergeDailyMetadataFromLesson(
    StudyHarmonyLessonDefinition lesson, {
    required StudyHarmonyTrackId trackId,
  }) {
    if (lesson.sessionMode != StudyHarmonySessionMode.daily) {
      return _snapshot.dailyChallengeSeedMetadata;
    }

    final dateKey = lesson.sessionMetadata.dailyDateKey;
    final seedValue = lesson.sessionMetadata.dailySeedValue;
    if (dateKey == null || seedValue == null) {
      return _snapshot.dailyChallengeSeedMetadata;
    }

    final existing = _snapshot.dailyChallengeSeedMetadata;
    final sourceLessonIds = lesson.sessionMetadata.sourceLessonIds.isEmpty
        ? <StudyHarmonyLessonId>[_effectiveAnchorLessonId(lesson)]
        : lesson.sessionMetadata.sourceLessonIds.toList(growable: false);
    return StudyHarmonyDailyChallengeSeedMetadata(
      version: existing?.version ?? 1,
      dateKey: dateKey,
      seedValue: seedValue,
      trackId: trackId,
      chapterId: lesson.chapterId,
      lessonId: _effectiveAnchorLessonId(lesson),
      sourceLessonIds: sourceLessonIds,
    );
  }

  Set<String> _mergedCompletedDailyChallengeDateKeys({
    required Set<String> existing,
    required String dateKey,
  }) {
    final ordered = [...existing, dateKey]..sort();
    return ordered.toSet();
  }

  Set<String> _allStreakDateKeys({
    required Set<String> completedDailyDateKeys,
    required Set<String> protectedDailyDateKeys,
  }) {
    return {...completedDailyDateKeys, ...protectedDailyDateKeys};
  }

  StudyHarmonyProgressSnapshot _normalizedSnapshot(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    var normalized =
        snapshot.serializationVersion ==
            StudyHarmonyProgressSnapshot.currentSerializationVersion
        ? snapshot
        : snapshot.copyWith(
            serializationVersion:
                StudyHarmonyProgressSnapshot.currentSerializationVersion,
          );
    final normalizedBestStreak = _bestDailyChallengeStreakForSnapshot(snapshot);
    final normalizedRelayWinCount = max(0, normalized.relayWinCount);
    final normalizedQuestChestCount = max(0, normalized.questChestCount);
    final normalizedActiveLeagueXpBoostCharges = max(
      0,
      normalized.activeLeagueXpBoostCharges,
    );
    final normalizedActiveLeagueXpBoostDateKey =
        normalizedActiveLeagueXpBoostCharges > 0
        ? normalized.activeLeagueXpBoostDateKey ?? _dailyDateKey(_nowProvider())
        : null;
    final normalizedCompletedFrontierQuestKeys = _trimDateKeys(
      normalized.completedFrontierQuestDateKeys,
      referenceDate: _nowProvider(),
    );
    final normalizedCompletedSpotlightKeys = _trimDateKeys(
      normalized.completedSpotlightChallengeDateKeys,
      referenceDate: _nowProvider(),
    );
    final normalizedBestDuetPactStreak = max(
      normalized.bestDuetPactStreak,
      _longestDailyStreakForDateKeys(
        normalized.completedDailyChallengeDateKeys.intersection(
          normalizedCompletedSpotlightKeys,
        ),
      ),
    );
    final normalizedAwardedDailyQuestChestKeys = _trimDateKeys(
      normalized.awardedDailyQuestChestDateKeys,
      referenceDate: _nowProvider(),
    );
    final normalizedAwardedMonthlyTourMonthKeys = _trimMonthKeys(
      normalized.awardedMonthlyTourMonthKeys,
      referenceDate: _nowProvider(),
    );
    final normalizedWeeklyLeagueScores = _trimWeeklyLeagueScores(
      normalized.weeklyLeagueScores,
      referenceDate: _nowProvider(),
    );
    final normalizedMonthlySpotlightClearCounts = _trimMonthlyCounts(
      normalized.monthlySpotlightClearCounts,
      referenceDate: _nowProvider(),
    );
    final normalizedModeSessionCounts = _normalizedCountMap(
      normalized.modeSessionCounts,
    );
    final normalizedModeClearCounts = _normalizedCountMap(
      normalized.modeClearCounts,
    );
    final normalizedRewardCurrencyBalances = _normalizedCountMap(
      normalized.rewardCurrencyBalances,
    );
    final normalizedRewardCurrencySpent = max(
      0,
      normalized.rewardCurrencySpent,
    );
    final normalizedShopPurchaseCount = max(0, normalized.shopPurchaseCount);
    final normalizedBestSessionCombo = max(0, normalized.bestSessionCombo);
    final normalizedRewardMetrics = _rewardMetricsForSnapshot(normalized);
    final normalizedOwnedTitleIds = _ownedTitleIdsForSnapshot(
      normalized,
      normalizedRewardMetrics,
    );
    final normalizedOwnedCosmeticIds = _ownedCosmeticIdsForSnapshot(
      normalized,
      normalizedRewardMetrics,
    );
    final normalizedEquippedTitleId = _normalizedRewardTitleId(
      normalized.equippedTitleId,
      ownedTitleIds: normalizedOwnedTitleIds,
    );
    final normalizedEquippedCosmeticIds = _normalizedRewardCosmeticLoadout(
      normalized.equippedCosmeticIds,
      ownedCosmeticIds: normalizedOwnedCosmeticIds,
    );
    if (normalizedBestStreak == normalized.bestDailyChallengeStreak &&
        normalizedBestDuetPactStreak == normalized.bestDuetPactStreak &&
        normalizedRelayWinCount == normalized.relayWinCount &&
        normalizedQuestChestCount == normalized.questChestCount &&
        normalizedRewardCurrencySpent == normalized.rewardCurrencySpent &&
        normalizedShopPurchaseCount == normalized.shopPurchaseCount &&
        normalizedBestSessionCombo == normalized.bestSessionCombo &&
        setEquals(normalizedOwnedTitleIds, normalized.ownedTitleIds) &&
        setEquals(normalizedOwnedCosmeticIds, normalized.ownedCosmeticIds) &&
        normalizedEquippedTitleId == normalized.equippedTitleId &&
        listEquals(
          normalizedEquippedCosmeticIds,
          normalized.equippedCosmeticIds,
        ) &&
        normalizedActiveLeagueXpBoostCharges ==
            normalized.activeLeagueXpBoostCharges &&
        normalizedActiveLeagueXpBoostDateKey ==
            normalized.activeLeagueXpBoostDateKey &&
        setEquals(
          normalizedCompletedFrontierQuestKeys,
          normalized.completedFrontierQuestDateKeys,
        ) &&
        setEquals(
          normalizedCompletedSpotlightKeys,
          normalized.completedSpotlightChallengeDateKeys,
        ) &&
        setEquals(
          normalizedAwardedDailyQuestChestKeys,
          normalized.awardedDailyQuestChestDateKeys,
        ) &&
        setEquals(
          normalizedAwardedMonthlyTourMonthKeys,
          normalized.awardedMonthlyTourMonthKeys,
        ) &&
        mapEquals(
          normalizedWeeklyLeagueScores,
          normalized.weeklyLeagueScores,
        ) &&
        mapEquals(
          normalizedMonthlySpotlightClearCounts,
          normalized.monthlySpotlightClearCounts,
        ) &&
        mapEquals(normalizedModeSessionCounts, normalized.modeSessionCounts) &&
        mapEquals(normalizedModeClearCounts, normalized.modeClearCounts) &&
        mapEquals(
          normalizedRewardCurrencyBalances,
          normalized.rewardCurrencyBalances,
        )) {
      return normalized;
    }
    return normalized.copyWith(
      bestDailyChallengeStreak: normalizedBestStreak,
      bestDuetPactStreak: normalizedBestDuetPactStreak,
      relayWinCount: normalizedRelayWinCount,
      completedFrontierQuestDateKeys: normalizedCompletedFrontierQuestKeys,
      completedSpotlightChallengeDateKeys: normalizedCompletedSpotlightKeys,
      awardedDailyQuestChestDateKeys: normalizedAwardedDailyQuestChestKeys,
      awardedMonthlyTourMonthKeys: normalizedAwardedMonthlyTourMonthKeys,
      weeklyLeagueScores: normalizedWeeklyLeagueScores,
      monthlySpotlightClearCounts: normalizedMonthlySpotlightClearCounts,
      modeSessionCounts: normalizedModeSessionCounts,
      modeClearCounts: normalizedModeClearCounts,
      rewardCurrencyBalances: normalizedRewardCurrencyBalances,
      rewardCurrencySpent: normalizedRewardCurrencySpent,
      shopPurchaseCount: normalizedShopPurchaseCount,
      ownedTitleIds: normalizedOwnedTitleIds,
      ownedCosmeticIds: normalizedOwnedCosmeticIds,
      equippedTitleId: normalizedEquippedTitleId,
      equippedCosmeticIds: normalizedEquippedCosmeticIds,
      bestSessionCombo: normalizedBestSessionCombo,
      questChestCount: normalizedQuestChestCount,
      activeLeagueXpBoostDateKey: normalizedActiveLeagueXpBoostDateKey,
      activeLeagueXpBoostCharges: normalizedActiveLeagueXpBoostCharges,
      clearActiveLeagueXpBoostDateKey:
          normalizedActiveLeagueXpBoostDateKey == null,
    );
  }

  Set<String> _trimDateKeys(
    Set<String> dateKeys, {
    required DateTime referenceDate,
  }) {
    if (dateKeys.isEmpty) {
      return dateKeys;
    }
    final oldestDateToKeep = _dateOnly(
      referenceDate,
    ).subtract(const Duration(days: 90));
    return {
      for (final dateKey in dateKeys)
        if (_dateFromKey(dateKey) case final date?
            when !date.isBefore(oldestDateToKeep))
          dateKey,
    };
  }

  Map<String, int> _trimWeeklyLeagueScores(
    Map<String, int> weeklyLeagueScores, {
    required DateTime referenceDate,
  }) {
    if (weeklyLeagueScores.isEmpty) {
      return weeklyLeagueScores;
    }
    final oldestWeekToKeep = _startOfWeek(
      referenceDate,
    ).subtract(const Duration(days: 77));
    final trimmed = <String, int>{};
    for (final entry in weeklyLeagueScores.entries) {
      final weekDate = _dateFromKey(entry.key);
      if (weekDate == null ||
          weekDate.isBefore(oldestWeekToKeep) ||
          entry.value <= 0) {
        continue;
      }
      trimmed[entry.key] = entry.value;
    }
    return trimmed;
  }

  Set<String> _trimMonthKeys(
    Set<String> monthKeys, {
    required DateTime referenceDate,
  }) {
    if (monthKeys.isEmpty) {
      return monthKeys;
    }
    final oldestMonthToKeep = DateTime(
      referenceDate.year,
      referenceDate.month - 5,
    );
    return {
      for (final monthKey in monthKeys)
        if (_monthDateFromKey(monthKey) case final monthDate?
            when !monthDate.isBefore(oldestMonthToKeep))
          monthKey,
    };
  }

  Map<String, int> _trimMonthlyCounts(
    Map<String, int> monthlyCounts, {
    required DateTime referenceDate,
  }) {
    if (monthlyCounts.isEmpty) {
      return monthlyCounts;
    }
    final oldestMonthToKeep = DateTime(
      referenceDate.year,
      referenceDate.month - 5,
    );
    final trimmed = <String, int>{};
    for (final entry in monthlyCounts.entries) {
      final monthDate = _monthDateFromKey(entry.key);
      if (monthDate == null ||
          monthDate.isBefore(oldestMonthToKeep) ||
          entry.value <= 0) {
        continue;
      }
      trimmed[entry.key] = entry.value;
    }
    return trimmed;
  }

  Set<String> _duetPactDateKeys(StudyHarmonyProgressSnapshot snapshot) {
    return snapshot.completedDailyChallengeDateKeys.intersection(
      snapshot.completedSpotlightChallengeDateKeys,
    );
  }

  int _bestDuetPactStreakForSnapshot(StudyHarmonyProgressSnapshot snapshot) {
    return max(
      snapshot.bestDuetPactStreak,
      _longestDailyStreakForDateKeys(_duetPactDateKeys(snapshot)),
    );
  }

  int _currentDailyStreakForDateKeys(Set<String> dateKeys, DateTime now) {
    if (dateKeys.isEmpty) {
      return 0;
    }
    var anchor = _dateOnly(now);
    if (!dateKeys.contains(_dateKeyFromDate(anchor))) {
      anchor = anchor.subtract(const Duration(days: 1));
      if (!dateKeys.contains(_dateKeyFromDate(anchor))) {
        return 0;
      }
    }
    return _streakEndingAt(dateKeys, _dateKeyFromDate(anchor));
  }

  int _bestDailyChallengeStreakForSnapshot(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    return max(
      snapshot.bestDailyChallengeStreak,
      _longestDailyStreakForDateKeys(
        _allStreakDateKeys(
          completedDailyDateKeys: snapshot.completedDailyChallengeDateKeys,
          protectedDailyDateKeys: snapshot.protectedDailyChallengeDateKeys,
        ),
      ),
    );
  }

  int _longestDailyStreakForDateKeys(Set<String> dateKeys) {
    if (dateKeys.isEmpty) {
      return 0;
    }
    final orderedDates =
        dateKeys
            .map(_dateFromKey)
            .whereType<DateTime>()
            .map(_dateOnly)
            .toList(growable: false)
          ..sort();
    if (orderedDates.isEmpty) {
      return 0;
    }

    var longest = 1;
    var current = 1;
    for (var index = 1; index < orderedDates.length; index += 1) {
      final difference = orderedDates[index]
          .difference(orderedDates[index - 1])
          .inDays;
      if (difference == 0) {
        continue;
      }
      if (difference == 1) {
        current += 1;
      } else {
        current = 1;
      }
      if (current > longest) {
        longest = current;
      }
    }
    return longest;
  }

  int _streakEndingAt(Set<String> dateKeys, String dateKey) {
    final anchor = _dateFromKey(dateKey);
    if (anchor == null) {
      return 0;
    }
    var streak = 0;
    var cursor = anchor;
    while (dateKeys.contains(_dateKeyFromDate(cursor))) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  _StreakSaverUseResult _tryUseStreakSaverForDateKey({
    required Set<String> completedDailyDateKeys,
    required Set<String> protectedDailyDateKeys,
    required String dateKey,
    required int streakSaverCount,
  }) {
    if (streakSaverCount <= 0) {
      return _StreakSaverUseResult(
        protectedDailyDateKeys: protectedDailyDateKeys,
        remainingStreakSavers: streakSaverCount,
        used: false,
      );
    }

    final anchorDate = _dateFromKey(dateKey);
    if (anchorDate == null) {
      return _StreakSaverUseResult(
        protectedDailyDateKeys: protectedDailyDateKeys,
        remainingStreakSavers: streakSaverCount,
        used: false,
      );
    }

    final missingDay = anchorDate.subtract(const Duration(days: 1));
    final missingDayKey = _dateKeyFromDate(missingDay);
    final streakDateKeys = _allStreakDateKeys(
      completedDailyDateKeys: completedDailyDateKeys,
      protectedDailyDateKeys: protectedDailyDateKeys,
    );
    if (streakDateKeys.contains(missingDayKey)) {
      return _StreakSaverUseResult(
        protectedDailyDateKeys: protectedDailyDateKeys,
        remainingStreakSavers: streakSaverCount,
        used: false,
      );
    }

    final preGapDay = missingDay.subtract(const Duration(days: 1));
    final preGapDayKey = _dateKeyFromDate(preGapDay);
    if (!streakDateKeys.contains(preGapDayKey)) {
      return _StreakSaverUseResult(
        protectedDailyDateKeys: protectedDailyDateKeys,
        remainingStreakSavers: streakSaverCount,
        used: false,
      );
    }

    return _StreakSaverUseResult(
      protectedDailyDateKeys: _mergedCompletedDailyChallengeDateKeys(
        existing: protectedDailyDateKeys,
        dateKey: missingDayKey,
      ),
      remainingStreakSavers: max(0, streakSaverCount - 1),
      used: true,
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime _startOfWeek(DateTime value) {
    final date = _dateOnly(value);
    final weekdayOffset = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: weekdayOffset));
  }

  DateTime? _dateFromKey(String dateKey) {
    final parts = dateKey.split('-');
    if (parts.length != 3) {
      return null;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  String _dateKeyFromDate(DateTime value) {
    final date = _dateOnly(value);
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _weekKey(DateTime value) {
    return _dateKeyFromDate(_startOfWeek(value));
  }

  String _monthKey(DateTime value) {
    final date = _dateOnly(value);
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  DateTime? _monthDateFromKey(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) {
      return null;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null) {
      return null;
    }
    return DateTime(year, month);
  }

  int _dateKeyCountForWeek(
    Set<String> dateKeys, {
    required DateTime referenceDate,
  }) {
    final weekStart = _startOfWeek(referenceDate);
    final weekEnd = weekStart.add(const Duration(days: 6));
    return dateKeys
        .map(_dateFromKey)
        .whereType<DateTime>()
        .map(_dateOnly)
        .where((date) => !date.isBefore(weekStart) && !date.isAfter(weekEnd))
        .toSet()
        .length;
  }

  int _dateKeyCountForMonth(
    Set<String> dateKeys, {
    required DateTime referenceDate,
  }) {
    final referenceMonth = DateTime(referenceDate.year, referenceDate.month);
    return dateKeys
        .map(_dateFromKey)
        .whereType<DateTime>()
        .map((date) => DateTime(date.year, date.month, date.day))
        .where(
          (date) =>
              date.year == referenceMonth.year &&
              date.month == referenceMonth.month,
        )
        .toSet()
        .length;
  }

  double _masteryDelta({
    required double accuracy,
    required int attemptCount,
    required int previousStreak,
  }) {
    final clampedAccuracy = _clampUnitDouble(accuracy);
    final volumeWeight = 0.6 + (min(attemptCount, 8) * 0.05);
    var delta = (clampedAccuracy - 0.65) * 0.22 * volumeWeight;
    if (clampedAccuracy >= 0.85) {
      delta += min(previousStreak, 3) * 0.012;
    } else if (clampedAccuracy < 0.55) {
      delta -= 0.025;
    }
    return delta;
  }

  double _averageMasteryForSkills(Set<StudyHarmonySkillTag> skillTags) {
    final scores = [
      for (final skillId in skillTags)
        _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore,
    ].whereType<double>().toList(growable: false);
    return scores.isEmpty ? 0.45 : _averageDoubles(scores);
  }

  bool _isEntryDue(
    StudyHarmonyReviewQueuePlaceholderEntry entry,
    DateTime now,
  ) {
    final dueAt = _parseIsoDate(entry.dueAtIso8601);
    if (dueAt == null) {
      return true;
    }
    return !dueAt.isAfter(now.toUtc());
  }

  DateTime? _parseIsoDate(String value) {
    return DateTime.tryParse(value)?.toUtc();
  }

  int _dailySeedValue(StudyHarmonyCourseDefinition course, String dateKey) {
    return _stableHash('${course.trackId}|${course.id}|$dateKey');
  }

  int _seededOrder(int seedValue, String id) {
    return _stableHash('$seedValue|$id');
  }

  String _dailyDateKey(DateTime now) {
    return _dateKeyFromDate(now);
  }

  StudyHarmonyRewardProgressMetrics _rewardMetricsForSnapshot(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    final modeSessionCounts = _decodeModeCounts(snapshot.modeSessionCounts);
    final modeClearCounts = _decodeModeCounts(snapshot.modeClearCounts);
    return studyHarmonyRewardMetricsFromSnapshot(
      snapshot,
      reviewClears: modeClearCounts[StudyHarmonySessionMode.review] ?? 0,
      bossClears: modeClearCounts[StudyHarmonySessionMode.bossRush] ?? 0,
      legendClears: max(
        modeClearCounts[StudyHarmonySessionMode.legend] ?? 0,
        snapshot.legendaryChapterIds.length,
      ),
      bestCombo: snapshot.bestSessionCombo,
      shopPurchases: snapshot.shopPurchaseCount,
      currencySpent: snapshot.rewardCurrencySpent,
      modeSessionCounts: modeSessionCounts,
      modeClearCounts: modeClearCounts,
    );
  }
}

Map<String, int> _normalizedCountMap(Map<String, int> values) {
  if (values.isEmpty) {
    return values;
  }
  final normalized = <String, int>{};
  for (final entry in values.entries) {
    final clampedValue = max(0, entry.value);
    if (clampedValue <= 0) {
      continue;
    }
    normalized[entry.key] = clampedValue;
  }
  return normalized;
}

Map<StudyHarmonySessionMode, int> _decodeModeCounts(Map<String, int> values) {
  if (values.isEmpty) {
    return const <StudyHarmonySessionMode, int>{};
  }
  final decoded = <StudyHarmonySessionMode, int>{};
  for (final entry in values.entries) {
    final mode = _sessionModeFromEncodedName(entry.key);
    if (mode == null || entry.value <= 0) {
      continue;
    }
    decoded[mode] = entry.value;
  }
  return decoded;
}

StudyHarmonySessionMode? _sessionModeFromEncodedName(String value) {
  for (final mode in StudyHarmonySessionMode.values) {
    if (mode.name == value) {
      return mode;
    }
  }
  return null;
}

void _incrementEncodedModeCount(
  Map<String, int> values,
  StudyHarmonySessionMode mode,
) {
  values[mode.name] = (values[mode.name] ?? 0) + 1;
}

Map<StudyHarmonyCurrencyId, int> _applyRewardGrants({
  required Map<StudyHarmonyCurrencyId, int> existing,
  required Iterable<StudyHarmonyRewardGrant> grants,
}) {
  final balances = Map<StudyHarmonyCurrencyId, int>.from(existing);
  for (final grant in grants) {
    balances[grant.currencyId] =
        (balances[grant.currencyId] ?? 0) + grant.amount;
  }
  return balances;
}

List<StudyHarmonyRewardGrant> _mergeRewardGrants(
  Iterable<StudyHarmonyRewardGrant> grants,
) {
  final totals = <StudyHarmonyCurrencyId, int>{};
  final labels = <StudyHarmonyCurrencyId, String?>{};
  for (final grant in grants) {
    totals[grant.currencyId] = (totals[grant.currencyId] ?? 0) + grant.amount;
    labels[grant.currencyId] ??= grant.label;
  }
  final merged =
      [
        for (final entry in totals.entries)
          StudyHarmonyRewardGrant(
            currencyId: entry.key,
            amount: entry.value,
            label: labels[entry.key],
          ),
      ]..sort((left, right) {
        final byAmount = right.amount.compareTo(left.amount);
        if (byAmount != 0) {
          return byAmount;
        }
        return left.currencyId.compareTo(right.currencyId);
      });
  return merged;
}

bool _isRepeatableShopItem(StudyHarmonyShopItemDefinition item) {
  return item.kind == StudyHarmonyShopItemKind.consumable ||
      item.kind == StudyHarmonyShopItemKind.booster;
}

Set<String> _ownedTitleIdsForSnapshot(
  StudyHarmonyProgressSnapshot snapshot,
  StudyHarmonyRewardProgressMetrics metrics,
) {
  final owned = <String>{};
  for (final titleId in snapshot.ownedTitleIds) {
    if (studyHarmonyTitlesById.containsKey(titleId)) {
      owned.add(titleId);
    }
  }
  for (final candidate in studyHarmonyRewardCandidatesForProgress(metrics)) {
    if (candidate.kind == StudyHarmonyRewardKind.title && candidate.unlocked) {
      owned.add(candidate.id);
    }
  }
  for (final shopItemId in snapshot.purchasedUniqueShopItemIds) {
    final item = _studyHarmonyShopItemById(shopItemId);
    if (item == null) {
      continue;
    }
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyTitlesById.containsKey(unlockId)) {
        owned.add(unlockId);
      }
    }
  }
  return owned;
}

Set<String> _ownedCosmeticIdsForSnapshot(
  StudyHarmonyProgressSnapshot snapshot,
  StudyHarmonyRewardProgressMetrics metrics,
) {
  final owned = <String>{};
  for (final cosmeticId in snapshot.ownedCosmeticIds) {
    if (studyHarmonyCosmeticsById.containsKey(cosmeticId)) {
      owned.add(cosmeticId);
    }
  }
  for (final candidate in studyHarmonyRewardCandidatesForProgress(metrics)) {
    if (candidate.kind == StudyHarmonyRewardKind.cosmetic &&
        candidate.unlocked) {
      owned.add(candidate.id);
    }
  }
  for (final shopItemId in snapshot.purchasedUniqueShopItemIds) {
    final item = _studyHarmonyShopItemById(shopItemId);
    if (item == null) {
      continue;
    }
    for (final unlockId in item.unlockIds) {
      if (studyHarmonyCosmeticsById.containsKey(unlockId)) {
        owned.add(unlockId);
      }
    }
  }
  return owned;
}

String? _normalizedRewardTitleId(
  String? titleId, {
  required Set<String> ownedTitleIds,
}) {
  if (titleId == null || !studyHarmonyTitlesById.containsKey(titleId)) {
    return null;
  }
  return ownedTitleIds.contains(titleId) ? titleId : null;
}

List<String> _normalizedRewardCosmeticLoadout(
  Iterable<String> cosmeticIds, {
  required Set<String> ownedCosmeticIds,
}) {
  final normalized = <String>[];
  for (final cosmeticId in cosmeticIds) {
    if (!studyHarmonyCosmeticsById.containsKey(cosmeticId)) {
      continue;
    }
    if (!ownedCosmeticIds.contains(cosmeticId)) {
      continue;
    }
    if (normalized.contains(cosmeticId)) {
      continue;
    }
    normalized.add(cosmeticId);
  }
  if (normalized.length <= 2) {
    return normalized;
  }
  return normalized.sublist(normalized.length - 2);
}

StudyHarmonyShopItemDefinition? _studyHarmonyShopItemById(String itemId) {
  for (final item in studyHarmonyShopItems) {
    if (item.id == itemId) {
      return item;
    }
  }
  return null;
}

@immutable
class _ReviewCandidate {
  const _ReviewCandidate({
    required this.lesson,
    required this.score,
    required this.reason,
    this.entry,
  });

  final StudyHarmonyLessonDefinition lesson;
  final double score;
  final String reason;
  final StudyHarmonyReviewQueuePlaceholderEntry? entry;
}

@immutable
class _StreakSaverUseResult {
  const _StreakSaverUseResult({
    required this.protectedDailyDateKeys,
    required this.remainingStreakSavers,
    required this.used,
  });

  final Set<String> protectedDailyDateKeys;
  final int remainingStreakSavers;
  final bool used;
}

@immutable
class _WeeklyPlanRewardResult {
  const _WeeklyPlanRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
}

@immutable
class _MonthlyTourRewardResult {
  const _MonthlyTourRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
    required this.leagueXpBonus,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
  final int leagueXpBonus;
}

@immutable
class _DuetPactRewardResult {
  const _DuetPactRewardResult({
    required this.snapshot,
    required this.rewardUnlocked,
    required this.leagueXpBonus,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool rewardUnlocked;
  final int leagueXpBonus;
}

@immutable
class _DailyQuestChestRewardResult {
  const _DailyQuestChestRewardResult({
    required this.snapshot,
    required this.chestOpened,
    required this.leagueXpBonus,
    required this.leagueXpBoostUnlocked,
  });

  final StudyHarmonyProgressSnapshot snapshot;
  final bool chestOpened;
  final int leagueXpBonus;
  final bool leagueXpBoostUnlocked;
}

double _averageDoubles(Iterable<double> values) {
  var count = 0;
  var sum = 0.0;
  for (final value in values) {
    sum += value;
    count += 1;
  }
  return count == 0 ? 0 : sum / count;
}

double _clampUnitDouble(double value) {
  if (value.isNaN) {
    return 0;
  }
  return value.clamp(0.0, 1.0).toDouble();
}

int _stableHash(String value) {
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = ((hash * 31) + unit) & 0x7fffffff;
  }
  return hash;
}
