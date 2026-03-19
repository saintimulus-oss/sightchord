part of 'study_harmony_progress_controller.dart';

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

  bool get completed =>
      goals.isNotEmpty && completedGoalCount >= totalGoalCount;

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
