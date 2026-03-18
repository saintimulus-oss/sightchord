import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/study_harmony_progress_models.dart';
import '../domain/study_harmony_session_models.dart';

typedef StudyHarmonyRewardId = String;
typedef StudyHarmonyRewardTag = String;
typedef StudyHarmonyCurrencyId = String;

enum StudyHarmonyRewardRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,
}

enum StudyHarmonyRewardKind { achievement, title, cosmetic, shopItem }

enum StudyHarmonyRewardSourceKind {
  session,
  achievement,
  progress,
  shop,
  milestone,
}

enum StudyHarmonyRewardRequirementKind {
  lessonClears,
  reviewClears,
  dailyClears,
  focusClears,
  relayWins,
  bossClears,
  legendClears,
  questChests,
  monthlyTourRewards,
  activeDays,
  totalStars,
  bestCombo,
  bestSessionAccuracy,
  averageLessonAccuracy,
  bestDailyStreak,
  bestDuetStreak,
  shopPurchases,
  currencySpent,
  modeSessions,
  modeClears,
}

enum StudyHarmonyCosmeticKind {
  profileFrame,
  theme,
  trail,
  badge,
  keyboardSkin,
  banner,
}

enum StudyHarmonyShopItemKind { consumable, cosmetic, title, bundle, booster }

@immutable
class StudyHarmonyCurrencyDefinition {
  const StudyHarmonyCurrencyDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    this.tags = const <StudyHarmonyRewardTag>{},
    this.isPremium = false,
  });

  final StudyHarmonyCurrencyId id;
  final String title;
  final String description;
  final StudyHarmonyRewardRarity rarity;
  final Set<StudyHarmonyRewardTag> tags;
  final bool isPremium;
}

@immutable
class StudyHarmonyAchievementCategoryDefinition {
  const StudyHarmonyAchievementCategoryDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.tags = const <StudyHarmonyRewardTag>{},
  });

  final String id;
  final String title;
  final String description;
  final int order;
  final Set<StudyHarmonyRewardTag> tags;
}

@immutable
class StudyHarmonyRewardGrant {
  const StudyHarmonyRewardGrant({
    required this.currencyId,
    required this.amount,
    this.label,
  });

  final StudyHarmonyCurrencyId currencyId;
  final int amount;
  final String? label;
}

@immutable
class StudyHarmonyRewardRequirement {
  const StudyHarmonyRewardRequirement({
    required this.kind,
    required this.target,
    this.mode,
    this.note,
  });

  final StudyHarmonyRewardRequirementKind kind;
  final double target;
  final StudyHarmonySessionMode? mode;
  final String? note;

  double progressFraction(StudyHarmonyRewardProgressMetrics metrics) {
    final current = metrics.valueForRequirement(this);
    if (target <= 0) {
      return 1;
    }
    return (current / target).clamp(0, 1).toDouble();
  }

  bool isMet(StudyHarmonyRewardProgressMetrics metrics) {
    return progressFraction(metrics) >= 1;
  }

  String describe() {
    return note ?? _describeRequirement(this);
  }
}

@immutable
class StudyHarmonyRewardBundleDefinition {
  const StudyHarmonyRewardBundleDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    this.tags = const <StudyHarmonyRewardTag>{},
    this.grants = const <StudyHarmonyRewardGrant>[],
    this.unlockIds = const <String>{},
    this.sourceKind,
    this.sourceLabel,
  });

  final String id;
  final String title;
  final String description;
  final StudyHarmonyRewardRarity rarity;
  final Set<StudyHarmonyRewardTag> tags;
  final List<StudyHarmonyRewardGrant> grants;
  final Set<String> unlockIds;
  final StudyHarmonyRewardSourceKind? sourceKind;
  final String? sourceLabel;
}

@immutable
class StudyHarmonyAchievementDefinition {
  const StudyHarmonyAchievementDefinition({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.rarity,
    required this.requirements,
    required this.rewardBundleIds,
    this.tags = const <StudyHarmonyRewardTag>{},
  });

  final String id;
  final String categoryId;
  final String title;
  final String description;
  final StudyHarmonyRewardRarity rarity;
  final List<StudyHarmonyRewardRequirement> requirements;
  final List<String> rewardBundleIds;
  final Set<StudyHarmonyRewardTag> tags;
}

@immutable
class StudyHarmonyTitleDefinition {
  const StudyHarmonyTitleDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    required this.requirements,
    this.tags = const <StudyHarmonyRewardTag>{},
    this.accentTags = const <StudyHarmonyRewardTag>{},
  });

  final String id;
  final String title;
  final String description;
  final StudyHarmonyRewardRarity rarity;
  final List<StudyHarmonyRewardRequirement> requirements;
  final Set<StudyHarmonyRewardTag> tags;
  final Set<StudyHarmonyRewardTag> accentTags;
}

@immutable
class StudyHarmonyCosmeticDefinition {
  const StudyHarmonyCosmeticDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.rarity,
    required this.requirements,
    this.tags = const <StudyHarmonyRewardTag>{},
    this.accentTags = const <StudyHarmonyRewardTag>{},
  });

  final String id;
  final String title;
  final String description;
  final StudyHarmonyCosmeticKind kind;
  final StudyHarmonyRewardRarity rarity;
  final List<StudyHarmonyRewardRequirement> requirements;
  final Set<StudyHarmonyRewardTag> tags;
  final Set<StudyHarmonyRewardTag> accentTags;
}

@immutable
class StudyHarmonyShopItemDefinition {
  const StudyHarmonyShopItemDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.priceCurrencyId,
    required this.priceAmount,
    required this.rarity,
    required this.requirements,
    this.grants = const <StudyHarmonyRewardGrant>[],
    this.unlockIds = const <String>{},
    this.tags = const <StudyHarmonyRewardTag>{},
  });

  final String id;
  final String title;
  final String description;
  final StudyHarmonyShopItemKind kind;
  final StudyHarmonyCurrencyId priceCurrencyId;
  final int priceAmount;
  final StudyHarmonyRewardRarity rarity;
  final List<StudyHarmonyRewardRequirement> requirements;
  final List<StudyHarmonyRewardGrant> grants;
  final Set<String> unlockIds;
  final Set<StudyHarmonyRewardTag> tags;
}

@immutable
class StudyHarmonyRewardProgressMetrics {
  const StudyHarmonyRewardProgressMetrics({
    required this.lessonClears,
    required this.reviewClears,
    required this.dailyClears,
    required this.focusClears,
    required this.relayWins,
    required this.bossClears,
    required this.legendClears,
    required this.questChests,
    required this.monthlyTourRewards,
    required this.activeDays,
    required this.totalStars,
    required this.bestCombo,
    required this.bestSessionAccuracy,
    required this.averageLessonAccuracy,
    required this.bestDailyStreak,
    required this.bestDuetStreak,
    required this.shopPurchases,
    required this.currencySpent,
    this.modeSessionCounts = const <StudyHarmonySessionMode, int>{},
    this.modeClearCounts = const <StudyHarmonySessionMode, int>{},
  });

  final int lessonClears;
  final int reviewClears;
  final int dailyClears;
  final int focusClears;
  final int relayWins;
  final int bossClears;
  final int legendClears;
  final int questChests;
  final int monthlyTourRewards;
  final int activeDays;
  final int totalStars;
  final int bestCombo;
  final double bestSessionAccuracy;
  final double averageLessonAccuracy;
  final int bestDailyStreak;
  final int bestDuetStreak;
  final int shopPurchases;
  final int currencySpent;
  final Map<StudyHarmonySessionMode, int> modeSessionCounts;
  final Map<StudyHarmonySessionMode, int> modeClearCounts;

  factory StudyHarmonyRewardProgressMetrics.fromSnapshot(
    StudyHarmonyProgressSnapshot snapshot, {
    int reviewClears = 0,
    int bossClears = 0,
    int legendClears = 0,
    int bestCombo = 0,
    int totalStarsOverride = 0,
    double? bestSessionAccuracyOverride,
    double? averageLessonAccuracyOverride,
    int shopPurchases = 0,
    int currencySpent = 0,
    Map<StudyHarmonySessionMode, int> modeSessionCounts =
        const <StudyHarmonySessionMode, int>{},
    Map<StudyHarmonySessionMode, int> modeClearCounts =
        const <StudyHarmonySessionMode, int>{},
  }) {
    final lessonResults = snapshot.lessonResults.values.toList(growable: false);
    final lessonClears = lessonResults
        .where((result) => result.isCleared)
        .length;
    final totalStars = totalStarsOverride > 0
        ? totalStarsOverride
        : lessonResults.fold<int>(0, (sum, result) => sum + result.bestStars);
    final bestSessionAccuracy =
        bestSessionAccuracyOverride ??
        lessonResults.fold<double>(
          0,
          (best, result) => max(best, result.bestAccuracy),
        );
    final averageLessonAccuracy =
        averageLessonAccuracyOverride ??
        (lessonResults.isEmpty
            ? 0
            : lessonResults.fold<double>(
                    0,
                    (sum, result) => sum + result.bestAccuracy,
                  ) /
                  lessonResults.length);

    return StudyHarmonyRewardProgressMetrics(
      lessonClears: lessonClears,
      reviewClears: reviewClears,
      dailyClears: snapshot.completedDailyChallengeDateKeys.length,
      focusClears: snapshot.completedFocusChallengeDateKeys.length,
      relayWins: snapshot.relayWinCount,
      bossClears: bossClears,
      legendClears: legendClears > 0
          ? legendClears
          : snapshot.legendaryChapterIds.length,
      questChests: snapshot.questChestCount,
      monthlyTourRewards: snapshot.awardedMonthlyTourMonthKeys.length,
      activeDays: snapshot.activityDateKeys.length,
      totalStars: totalStars,
      bestCombo: bestCombo,
      bestSessionAccuracy: bestSessionAccuracy,
      averageLessonAccuracy: averageLessonAccuracy,
      bestDailyStreak: snapshot.bestDailyChallengeStreak,
      bestDuetStreak: snapshot.bestDuetPactStreak,
      shopPurchases: shopPurchases,
      currencySpent: currencySpent,
      modeSessionCounts: modeSessionCounts,
      modeClearCounts: modeClearCounts,
    );
  }

  StudyHarmonyRewardProgressMetrics copyWith({
    int? lessonClears,
    int? reviewClears,
    int? dailyClears,
    int? focusClears,
    int? relayWins,
    int? bossClears,
    int? legendClears,
    int? questChests,
    int? monthlyTourRewards,
    int? activeDays,
    int? totalStars,
    int? bestCombo,
    double? bestSessionAccuracy,
    double? averageLessonAccuracy,
    int? bestDailyStreak,
    int? bestDuetStreak,
    int? shopPurchases,
    int? currencySpent,
    Map<StudyHarmonySessionMode, int>? modeSessionCounts,
    Map<StudyHarmonySessionMode, int>? modeClearCounts,
  }) {
    return StudyHarmonyRewardProgressMetrics(
      lessonClears: lessonClears ?? this.lessonClears,
      reviewClears: reviewClears ?? this.reviewClears,
      dailyClears: dailyClears ?? this.dailyClears,
      focusClears: focusClears ?? this.focusClears,
      relayWins: relayWins ?? this.relayWins,
      bossClears: bossClears ?? this.bossClears,
      legendClears: legendClears ?? this.legendClears,
      questChests: questChests ?? this.questChests,
      monthlyTourRewards: monthlyTourRewards ?? this.monthlyTourRewards,
      activeDays: activeDays ?? this.activeDays,
      totalStars: totalStars ?? this.totalStars,
      bestCombo: bestCombo ?? this.bestCombo,
      bestSessionAccuracy: bestSessionAccuracy ?? this.bestSessionAccuracy,
      averageLessonAccuracy:
          averageLessonAccuracy ?? this.averageLessonAccuracy,
      bestDailyStreak: bestDailyStreak ?? this.bestDailyStreak,
      bestDuetStreak: bestDuetStreak ?? this.bestDuetStreak,
      shopPurchases: shopPurchases ?? this.shopPurchases,
      currencySpent: currencySpent ?? this.currencySpent,
      modeSessionCounts: modeSessionCounts ?? this.modeSessionCounts,
      modeClearCounts: modeClearCounts ?? this.modeClearCounts,
    );
  }

  StudyHarmonyRewardProgressMetrics mergeSession(
    StudyHarmonySessionRewardInput session,
  ) {
    final mergedModeSessions = Map<StudyHarmonySessionMode, int>.from(
      modeSessionCounts,
    );
    final mergedModeClears = Map<StudyHarmonySessionMode, int>.from(
      modeClearCounts,
    );

    _incrementCount(mergedModeSessions, session.mode);
    if (session.isCompleted) {
      _incrementCount(mergedModeClears, session.mode);
    }

    return copyWith(
      lessonClears:
          lessonClears +
          (session.isCompleted && session.countsTowardLessonProgress ? 1 : 0),
      reviewClears:
          reviewClears +
          (session.isCompleted && session.mode == StudyHarmonySessionMode.review
              ? 1
              : 0),
      dailyClears:
          dailyClears +
          (session.isCompleted && session.mode == StudyHarmonySessionMode.daily
              ? 1
              : 0),
      focusClears:
          focusClears +
          (session.isCompleted && session.mode == StudyHarmonySessionMode.focus
              ? 1
              : 0),
      relayWins:
          relayWins +
          (session.isCompleted && session.mode == StudyHarmonySessionMode.relay
              ? 1
              : 0),
      bossClears:
          bossClears +
          (session.isCompleted &&
                  session.mode == StudyHarmonySessionMode.bossRush
              ? 1
              : 0),
      legendClears:
          legendClears +
          (session.isCompleted && session.mode == StudyHarmonySessionMode.legend
              ? 1
              : 0),
      questChests: questChests,
      monthlyTourRewards: monthlyTourRewards,
      activeDays: activeDays,
      totalStars: totalStars + session.stars,
      bestCombo: max(bestCombo, session.bestCombo),
      bestSessionAccuracy: max(bestSessionAccuracy, session.accuracy),
      averageLessonAccuracy: averageLessonAccuracy,
      bestDailyStreak: max(bestDailyStreak, session.streak),
      bestDuetStreak: bestDuetStreak,
      shopPurchases: shopPurchases,
      currencySpent: currencySpent,
      modeSessionCounts: mergedModeSessions,
      modeClearCounts: mergedModeClears,
    );
  }

  double valueForRequirement(StudyHarmonyRewardRequirement requirement) {
    final mode = requirement.mode;
    return switch (requirement.kind) {
      StudyHarmonyRewardRequirementKind.lessonClears => lessonClears.toDouble(),
      StudyHarmonyRewardRequirementKind.reviewClears => reviewClears.toDouble(),
      StudyHarmonyRewardRequirementKind.dailyClears => dailyClears.toDouble(),
      StudyHarmonyRewardRequirementKind.focusClears => focusClears.toDouble(),
      StudyHarmonyRewardRequirementKind.relayWins => relayWins.toDouble(),
      StudyHarmonyRewardRequirementKind.bossClears => bossClears.toDouble(),
      StudyHarmonyRewardRequirementKind.legendClears => legendClears.toDouble(),
      StudyHarmonyRewardRequirementKind.questChests => questChests.toDouble(),
      StudyHarmonyRewardRequirementKind.monthlyTourRewards =>
        monthlyTourRewards.toDouble(),
      StudyHarmonyRewardRequirementKind.activeDays => activeDays.toDouble(),
      StudyHarmonyRewardRequirementKind.totalStars => totalStars.toDouble(),
      StudyHarmonyRewardRequirementKind.bestCombo => bestCombo.toDouble(),
      StudyHarmonyRewardRequirementKind.bestSessionAccuracy =>
        bestSessionAccuracy,
      StudyHarmonyRewardRequirementKind.averageLessonAccuracy =>
        averageLessonAccuracy,
      StudyHarmonyRewardRequirementKind.bestDailyStreak =>
        bestDailyStreak.toDouble(),
      StudyHarmonyRewardRequirementKind.bestDuetStreak =>
        bestDuetStreak.toDouble(),
      StudyHarmonyRewardRequirementKind.shopPurchases =>
        shopPurchases.toDouble(),
      StudyHarmonyRewardRequirementKind.currencySpent =>
        currencySpent.toDouble(),
      StudyHarmonyRewardRequirementKind.modeSessions => _modeCount(
        modeSessionCounts,
        mode,
      ).toDouble(),
      StudyHarmonyRewardRequirementKind.modeClears => _modeCount(
        modeClearCounts,
        mode,
      ).toDouble(),
    };
  }
}

@immutable
class StudyHarmonySessionRewardInput {
  const StudyHarmonySessionRewardInput({
    required this.mode,
    required this.lessonId,
    required this.lessonTitle,
    required this.accuracy,
    required this.stars,
    required this.streak,
    required this.bestCombo,
    required this.attempts,
    required this.correctAnswers,
    required this.livesRemaining,
    required this.rank,
    required this.isCompleted,
    required this.isFinished,
    required this.countsTowardLessonProgress,
  });

  factory StudyHarmonySessionRewardInput.fromState(
    StudyHarmonySessionState state, {
    int? starsOverride,
    int? streakOverride,
    String? rankOverride,
  }) {
    final accuracy = state.accuracy;
    final stars = starsOverride ?? _estimateStarsFromSession(state);
    final streak = streakOverride ?? state.bestCombo;
    final rank = rankOverride ?? _estimateRankFromSession(state, stars: stars);
    return StudyHarmonySessionRewardInput(
      mode: state.mode,
      lessonId: state.lesson.id,
      lessonTitle: state.lesson.title,
      accuracy: accuracy,
      stars: stars,
      streak: streak,
      bestCombo: state.bestCombo,
      attempts: state.attempts,
      correctAnswers: state.correctAnswers,
      livesRemaining: state.livesRemaining,
      rank: rank,
      isCompleted: state.isCompleted,
      isFinished: state.isFinished,
      countsTowardLessonProgress:
          state.lesson.sessionMetadata.countsTowardLessonProgress,
    );
  }

  final StudyHarmonySessionMode mode;
  final StudyHarmonyLessonId lessonId;
  final String lessonTitle;
  final double accuracy;
  final int stars;
  final int streak;
  final int bestCombo;
  final int attempts;
  final int correctAnswers;
  final int livesRemaining;
  final String rank;
  final bool isCompleted;
  final bool isFinished;
  final bool countsTowardLessonProgress;

  bool get isPerfectClear => isCompleted && accuracy >= 0.98;
}

@immutable
class StudyHarmonyRewardCandidate {
  const StudyHarmonyRewardCandidate({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.rarity,
    required this.tags,
    required this.unlocked,
    required this.progressFraction,
    required this.requirementLabels,
    required this.unmetRequirementLabels,
    this.categoryId,
    this.rewardBundleIds = const <String>[],
    this.grants = const <StudyHarmonyRewardGrant>[],
    this.unlockIds = const <String>{},
    this.priceCurrencyId,
    this.priceAmount,
    this.shopKind,
    this.sourceKind,
  });

  final String id;
  final StudyHarmonyRewardKind kind;
  final String title;
  final String description;
  final StudyHarmonyRewardRarity rarity;
  final Set<StudyHarmonyRewardTag> tags;
  final bool unlocked;
  final double progressFraction;
  final List<String> requirementLabels;
  final List<String> unmetRequirementLabels;
  final String? categoryId;
  final List<String> rewardBundleIds;
  final List<StudyHarmonyRewardGrant> grants;
  final Set<String> unlockIds;
  final StudyHarmonyCurrencyId? priceCurrencyId;
  final int? priceAmount;
  final StudyHarmonyShopItemKind? shopKind;
  final StudyHarmonyRewardSourceKind? sourceKind;
}

const List<StudyHarmonyCurrencyDefinition> studyHarmonyCurrencies = [
  StudyHarmonyCurrencyDefinition(
    id: 'currency.studyCoin',
    title: 'Study Coin',
    description: 'The everyday currency earned from clears, streaks, and wins.',
    rarity: StudyHarmonyRewardRarity.common,
    tags: {'economy', 'core'},
  ),
  StudyHarmonyCurrencyDefinition(
    id: 'currency.starShard',
    title: 'Star Shard',
    description:
        'A rarer currency reserved for standout play and premium unlocks.',
    rarity: StudyHarmonyRewardRarity.rare,
    tags: {'economy', 'premium', 'challenge'},
    isPremium: true,
  ),
  StudyHarmonyCurrencyDefinition(
    id: 'currency.focusToken',
    title: 'Focus Token',
    description:
        'Earned from concentration streaks and used for tactical boosts.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    tags: {'economy', 'focus', 'boost'},
  ),
  StudyHarmonyCurrencyDefinition(
    id: 'currency.rerollToken',
    title: 'Reroll Token',
    description: 'Used to refresh a challenge, shop row, or daily offer.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    tags: {'economy', 'daily', 'utility'},
  ),
  StudyHarmonyCurrencyDefinition(
    id: 'currency.streakShield',
    title: 'Streak Shield',
    description: 'Protects long streaks and powers comeback systems.',
    rarity: StudyHarmonyRewardRarity.rare,
    tags: {'economy', 'streak', 'defense'},
  ),
];

const List<StudyHarmonyAchievementCategoryDefinition>
studyHarmonyAchievementCategories = [
  StudyHarmonyAchievementCategoryDefinition(
    id: 'mastery',
    title: 'Mastery',
    description: 'Learn, refine, and repeat until the material sticks.',
    order: 0,
    tags: {'lesson', 'review', 'mastery'},
  ),
  StudyHarmonyAchievementCategoryDefinition(
    id: 'streak',
    title: 'Streak',
    description: 'Build habits that reward consistency over time.',
    order: 1,
    tags: {'daily', 'streak', 'habit'},
  ),
  StudyHarmonyAchievementCategoryDefinition(
    id: 'challenge',
    title: 'Challenge',
    description: 'Show precision, speed, and composure under pressure.',
    order: 2,
    tags: {'combo', 'accuracy', 'mode'},
  ),
  StudyHarmonyAchievementCategoryDefinition(
    id: 'collection',
    title: 'Collection',
    description: 'Complete sets, unlock milestones, and collect trophy items.',
    order: 3,
    tags: {'chest', 'tour', 'collection'},
  ),
  StudyHarmonyAchievementCategoryDefinition(
    id: 'economy',
    title: 'Economy',
    description: 'Earn, spend, and invest in the reward loop itself.',
    order: 4,
    tags: {'shop', 'currency', 'meta'},
  ),
];

const List<StudyHarmonyRewardBundleDefinition> studyHarmonyRewardBundles = [
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.session.base',
    title: 'Clear Bonus',
    description: 'The baseline reward for finishing a session.',
    rarity: StudyHarmonyRewardRarity.common,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    tags: {'session', 'baseline'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 40),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.session.precision',
    title: 'Precision Bonus',
    description: 'Reward for playing cleanly and keeping the miss count low.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    tags: {'session', 'accuracy'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 30),
      StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 1),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.session.combo',
    title: 'Combo Bonus',
    description: 'Bonus for sustaining a long streak inside a single session.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    tags: {'session', 'combo'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.focusToken', amount: 1),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.session.mode',
    title: 'Mode Bonus',
    description:
        'A mode-specific reward that makes each playlist feel distinct.',
    rarity: StudyHarmonyRewardRarity.rare,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    tags: {'session', 'mode'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 60),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.session.mastery',
    title: 'Mastery Bonus',
    description: 'A celebration bundle for sharp, clean, completed runs.',
    rarity: StudyHarmonyRewardRarity.rare,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    tags: {'session', 'mastery'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 55),
      StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 2),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.achievement.first_step',
    title: 'First Step Bundle',
    description: 'A starter bundle for the first clear.',
    rarity: StudyHarmonyRewardRarity.common,
    sourceKind: StudyHarmonyRewardSourceKind.achievement,
    tags: {'achievement', 'starter'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 75),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.achievement.daily_anchor',
    title: 'Daily Anchor Bundle',
    description: 'A streak reward that helps the habit loop feel sticky.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    sourceKind: StudyHarmonyRewardSourceKind.achievement,
    tags: {'achievement', 'streak'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 110),
      StudyHarmonyRewardGrant(currencyId: 'currency.streakShield', amount: 1),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.achievement.legend_writer',
    title: 'Legend Writer Bundle',
    description: 'A high-tier trophy bundle for the biggest clears.',
    rarity: StudyHarmonyRewardRarity.legendary,
    sourceKind: StudyHarmonyRewardSourceKind.achievement,
    tags: {'achievement', 'legend'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 180),
      StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 3),
    ],
    unlockIds: {'title.legend_writer'},
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.shop.welcome',
    title: 'Welcome Shelf',
    description: 'A small shop bundle that encourages the first purchase.',
    rarity: StudyHarmonyRewardRarity.common,
    sourceKind: StudyHarmonyRewardSourceKind.shop,
    tags: {'shop', 'welcome'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.focusToken', amount: 1),
      StudyHarmonyRewardGrant(currencyId: 'currency.rerollToken', amount: 1),
    ],
  ),
  StudyHarmonyRewardBundleDefinition(
    id: 'bundle.shop.premium',
    title: 'Premium Shelf',
    description:
        'A premium shop bundle with sharper utility and rarer currency.',
    rarity: StudyHarmonyRewardRarity.rare,
    sourceKind: StudyHarmonyRewardSourceKind.shop,
    tags: {'shop', 'premium'},
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 2),
      StudyHarmonyRewardGrant(currencyId: 'currency.focusToken', amount: 2),
    ],
  ),
];

const List<StudyHarmonyAchievementDefinition> studyHarmonyAchievements = [
  StudyHarmonyAchievementDefinition(
    id: 'achievement.first_step',
    categoryId: 'mastery',
    title: 'First Downbeat',
    description: 'Clear your first lesson and make the rhythm loop start.',
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 1,
      ),
    ],
    rewardBundleIds: ['bundle.achievement.first_step'],
    tags: {'starter', 'lesson'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.lesson_runner',
    categoryId: 'mastery',
    title: 'Lesson Runner',
    description: 'Keep going until lesson clears start piling up.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 10,
      ),
    ],
    rewardBundleIds: ['bundle.session.base'],
    tags: {'lesson', 'volume'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.lesson_marathon',
    categoryId: 'mastery',
    title: 'Lesson Marathon',
    description: 'Clear a large number of lessons with steady momentum.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 25,
      ),
    ],
    rewardBundleIds: ['bundle.session.mastery'],
    tags: {'lesson', 'endurance'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.review_scholar',
    categoryId: 'mastery',
    title: 'Review Scholar',
    description: 'Turn review sessions into a reliable strength.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.reviewClears,
        target: 5,
      ),
    ],
    rewardBundleIds: ['bundle.session.precision'],
    tags: {'review', 'study'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.daily_anchor',
    categoryId: 'streak',
    title: 'Daily Anchor',
    description: 'Protect a short daily streak and make practice feel sticky.',
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 3,
      ),
    ],
    rewardBundleIds: ['bundle.achievement.daily_anchor'],
    tags: {'daily', 'streak'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.daily_lantern',
    categoryId: 'streak',
    title: 'Daily Lantern',
    description: 'Keep the daily streak glowing for a full week.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 7,
      ),
    ],
    rewardBundleIds: ['bundle.achievement.daily_anchor'],
    tags: {'daily', 'streak'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.streak_legend',
    categoryId: 'streak',
    title: 'Streak Legend',
    description: 'Hold on long enough that the streak becomes the story.',
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 14,
      ),
    ],
    rewardBundleIds: ['bundle.achievement.daily_anchor'],
    tags: {'daily', 'legend'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.combo_starter',
    categoryId: 'challenge',
    title: 'Combo Starter',
    description: 'Build a modest combo and feel the run start to sing.',
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestCombo,
        target: 8,
      ),
    ],
    rewardBundleIds: ['bundle.session.combo'],
    tags: {'combo', 'timing'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.combo_master',
    categoryId: 'challenge',
    title: 'Combo Master',
    description: 'Sustain a long run without losing the thread.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestCombo,
        target: 15,
      ),
    ],
    rewardBundleIds: ['bundle.session.combo'],
    tags: {'combo', 'precision'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.accuracy_owl',
    categoryId: 'challenge',
    title: 'Accuracy Owl',
    description: 'Keep a session clean enough to earn the owl badge.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestSessionAccuracy,
        target: 0.93,
      ),
    ],
    rewardBundleIds: ['bundle.session.precision'],
    tags: {'accuracy', 'clean'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.relay_runner',
    categoryId: 'challenge',
    title: 'Relay Runner',
    description: 'Win relay mode often enough to become the anchor player.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.relayWins,
        target: 5,
      ),
    ],
    rewardBundleIds: ['bundle.session.mode'],
    tags: {'relay', 'mode'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.boss_breaker',
    categoryId: 'challenge',
    title: 'Boss Breaker',
    description: 'Clear boss encounters without losing composure.',
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bossClears,
        target: 3,
      ),
    ],
    rewardBundleIds: ['bundle.session.mastery'],
    tags: {'boss', 'pressure'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.legend_writer',
    categoryId: 'challenge',
    title: 'Legend Writer',
    description: 'Turn legend mode into a signature performance.',
    rarity: StudyHarmonyRewardRarity.legendary,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.legendClears,
        target: 1,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.totalStars,
        target: 100,
      ),
    ],
    rewardBundleIds: ['bundle.achievement.legend_writer'],
    tags: {'legend', 'trophy'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.quest_collector',
    categoryId: 'collection',
    title: 'Quest Collector',
    description: 'Open quest chests often enough to make the meta loop matter.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.questChests,
        target: 5,
      ),
    ],
    rewardBundleIds: ['bundle.session.base'],
    tags: {'quest', 'collection'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.tour_headliner',
    categoryId: 'collection',
    title: 'Tour Headliner',
    description: 'Finish monthly tour rewards and keep the collection moving.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.monthlyTourRewards,
        target: 3,
      ),
    ],
    rewardBundleIds: ['bundle.session.mode'],
    tags: {'tour', 'monthly'},
  ),
  StudyHarmonyAchievementDefinition(
    id: 'achievement.economy_supporter',
    categoryId: 'economy',
    title: 'Economy Supporter',
    description: 'Visit the shop and spend enough to unlock the economy loop.',
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.shopPurchases,
        target: 3,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.currencySpent,
        target: 300,
      ),
    ],
    rewardBundleIds: ['bundle.shop.welcome'],
    tags: {'shop', 'economy'},
  ),
];

const List<StudyHarmonyTitleDefinition> studyHarmonyTitles = [
  StudyHarmonyTitleDefinition(
    id: 'title.spark',
    title: 'Spark',
    description: 'A quick, confident start for new learners.',
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 1,
      ),
    ],
    tags: {'starter', 'lesson'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.riff_runner',
    title: 'Riff Runner',
    description: 'For learners who keep momentum without slowing down.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 10,
      ),
    ],
    tags: {'lesson', 'volume'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.cadence_keeper',
    title: 'Cadence Keeper',
    description: 'A title for steady review practice and habit building.',
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.reviewClears,
        target: 5,
      ),
    ],
    tags: {'review', 'habit'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.accuracy_owl',
    title: 'Accuracy Owl',
    description: 'Reserved for clean, quiet, highly accurate sessions.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestSessionAccuracy,
        target: 0.93,
      ),
    ],
    tags: {'accuracy', 'clean'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.streak_sage',
    title: 'Streak Sage',
    description: 'A title that celebrates reliable daily practice.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 7,
      ),
    ],
    tags: {'daily', 'streak'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.combo_captain',
    title: 'Combo Captain',
    description: 'For long runs that never lose the beat.',
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestCombo,
        target: 12,
      ),
    ],
    tags: {'combo', 'timing'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.relay_maestro',
    title: 'Relay Maestro',
    description: 'A commanding title for relay specialists.',
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.relayWins,
        target: 5,
      ),
    ],
    tags: {'relay', 'mode'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.savvy_buyer',
    title: 'Savvy Buyer',
    description:
        'For players who make smart purchases and shape their loadout.',
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.shopPurchases,
        target: 3,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.currencySpent,
        target: 300,
      ),
    ],
    tags: {'shop', 'economy'},
  ),
  StudyHarmonyTitleDefinition(
    id: 'title.legend_writer',
    title: 'Legend Writer',
    description: 'A mythic title for the biggest landmark clears.',
    rarity: StudyHarmonyRewardRarity.mythic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.legendClears,
        target: 1,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.totalStars,
        target: 100,
      ),
    ],
    tags: {'legend', 'trophy'},
  ),
];

const List<StudyHarmonyCosmeticDefinition> studyHarmonyCosmetics = [
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.frame.neon',
    title: 'Neon Frame',
    description: 'A bright frame that makes lesson clears feel punchier.',
    kind: StudyHarmonyCosmeticKind.profileFrame,
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 8,
      ),
    ],
    tags: {'lesson', 'frame'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.frame.aurora',
    title: 'Aurora Frame',
    description: 'A soft, flowing frame for players with a steady streak.',
    kind: StudyHarmonyCosmeticKind.profileFrame,
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 7,
      ),
    ],
    tags: {'daily', 'frame'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.theme.midnight',
    title: 'Midnight Theme',
    description: 'A darker skin that highlights clean play and high accuracy.',
    kind: StudyHarmonyCosmeticKind.theme,
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestSessionAccuracy,
        target: 0.9,
      ),
    ],
    tags: {'accuracy', 'theme'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.theme.sunset',
    title: 'Sunset Theme',
    description: 'A warm theme that feels earned after monthly progress.',
    kind: StudyHarmonyCosmeticKind.theme,
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.monthlyTourRewards,
        target: 2,
      ),
    ],
    tags: {'tour', 'theme'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.trail.confetti',
    title: 'Confetti Trail',
    description: 'A celebratory trail for review sessions and quick wins.',
    kind: StudyHarmonyCosmeticKind.trail,
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.reviewClears,
        target: 5,
      ),
    ],
    tags: {'review', 'trail'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.trail.stardust',
    title: 'Stardust Trail',
    description: 'A premium trail that follows long combo streaks.',
    kind: StudyHarmonyCosmeticKind.trail,
    rarity: StudyHarmonyRewardRarity.legendary,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestCombo,
        target: 15,
      ),
    ],
    tags: {'combo', 'trail'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.badge.gold',
    title: 'Gold Badge',
    description:
        'A polished badge for relay specialists and challenge players.',
    kind: StudyHarmonyCosmeticKind.badge,
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.relayWins,
        target: 5,
      ),
    ],
    tags: {'relay', 'badge'},
  ),
  StudyHarmonyCosmeticDefinition(
    id: 'cosmetic.badge.holo',
    title: 'Holo Badge',
    description: 'A premium badge that can be earned through the shop loop.',
    kind: StudyHarmonyCosmeticKind.badge,
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.shopPurchases,
        target: 1,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.currencySpent,
        target: 200,
      ),
    ],
    tags: {'shop', 'badge'},
  ),
];

const List<StudyHarmonyShopItemDefinition> studyHarmonyShopItems = [
  StudyHarmonyShopItemDefinition(
    id: 'shop.focus_token_pack',
    title: 'Focus Token Pack',
    description: 'Buy a small stack of focus tokens for tactical sessions.',
    kind: StudyHarmonyShopItemKind.consumable,
    priceCurrencyId: 'currency.studyCoin',
    priceAmount: 120,
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [],
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.focusToken', amount: 2),
    ],
    tags: {'focus', 'utility'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.lesson_reroll_pack',
    title: 'Lesson Reroll Pack',
    description: 'Refresh the next challenge row with a reroll token.',
    kind: StudyHarmonyShopItemKind.consumable,
    priceCurrencyId: 'currency.studyCoin',
    priceAmount: 100,
    rarity: StudyHarmonyRewardRarity.common,
    requirements: [],
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.rerollToken', amount: 2),
    ],
    tags: {'daily', 'utility'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.streak_shield',
    title: 'Streak Shield',
    description: 'Protect your streak with a one-time shield purchase.',
    kind: StudyHarmonyShopItemKind.booster,
    priceCurrencyId: 'currency.studyCoin',
    priceAmount: 180,
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 3,
      ),
    ],
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.streakShield', amount: 1),
    ],
    tags: {'streak', 'defense'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.spark_chest',
    title: 'Spark Chest',
    description: 'A value chest with coins and shard upside.',
    kind: StudyHarmonyShopItemKind.bundle,
    priceCurrencyId: 'currency.studyCoin',
    priceAmount: 300,
    rarity: StudyHarmonyRewardRarity.uncommon,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.lessonClears,
        target: 5,
      ),
    ],
    grants: [
      StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 150),
      StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 2),
    ],
    tags: {'bundle', 'value'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.aurora_frame_unlock',
    title: 'Aurora Frame Unlock',
    description: 'Unlock the Aurora Frame cosmetic through the shop.',
    kind: StudyHarmonyShopItemKind.cosmetic,
    priceCurrencyId: 'currency.starShard',
    priceAmount: 4,
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestDailyStreak,
        target: 7,
      ),
    ],
    unlockIds: {'cosmetic.frame.aurora'},
    tags: {'cosmetic', 'frame'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.midnight_theme_unlock',
    title: 'Midnight Theme Unlock',
    description: 'Unlock the Midnight Theme after accuracy starts to pop.',
    kind: StudyHarmonyShopItemKind.cosmetic,
    priceCurrencyId: 'currency.starShard',
    priceAmount: 5,
    rarity: StudyHarmonyRewardRarity.rare,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestSessionAccuracy,
        target: 0.9,
      ),
    ],
    unlockIds: {'cosmetic.theme.midnight'},
    tags: {'cosmetic', 'theme'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.stardust_trail_unlock',
    title: 'Stardust Trail Unlock',
    description: 'Unlock the Stardust Trail for long combo specialists.',
    kind: StudyHarmonyShopItemKind.cosmetic,
    priceCurrencyId: 'currency.starShard',
    priceAmount: 6,
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.bestCombo,
        target: 15,
      ),
    ],
    unlockIds: {'cosmetic.trail.stardust'},
    tags: {'cosmetic', 'trail'},
  ),
  StudyHarmonyShopItemDefinition(
    id: 'shop.holo_badge_unlock',
    title: 'Holo Badge Unlock',
    description: 'Unlock the premium Holo Badge from the shop shelf.',
    kind: StudyHarmonyShopItemKind.title,
    priceCurrencyId: 'currency.starShard',
    priceAmount: 7,
    rarity: StudyHarmonyRewardRarity.epic,
    requirements: [
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.shopPurchases,
        target: 1,
      ),
      StudyHarmonyRewardRequirement(
        kind: StudyHarmonyRewardRequirementKind.currencySpent,
        target: 200,
      ),
    ],
    unlockIds: {'cosmetic.badge.holo'},
    tags: {'shop', 'badge'},
  ),
];

final Map<StudyHarmonyCurrencyId, StudyHarmonyCurrencyDefinition>
studyHarmonyCurrenciesById = _indexById(
  studyHarmonyCurrencies,
  (definition) => definition.id,
);

final Map<String, StudyHarmonyAchievementCategoryDefinition>
studyHarmonyAchievementCategoriesById = _indexById(
  studyHarmonyAchievementCategories,
  (definition) => definition.id,
);

final Map<String, StudyHarmonyRewardBundleDefinition>
studyHarmonyRewardBundlesById = _indexById(
  studyHarmonyRewardBundles,
  (definition) => definition.id,
);

final Map<String, StudyHarmonyAchievementDefinition>
studyHarmonyAchievementsById = _indexById(
  studyHarmonyAchievements,
  (definition) => definition.id,
);

final Map<String, StudyHarmonyTitleDefinition> studyHarmonyTitlesById =
    _indexById(studyHarmonyTitles, (definition) => definition.id);

final Map<String, StudyHarmonyCosmeticDefinition> studyHarmonyCosmeticsById =
    _indexById(studyHarmonyCosmetics, (definition) => definition.id);

final Map<String, StudyHarmonyShopItemDefinition> studyHarmonyShopItemsById =
    _indexById(studyHarmonyShopItems, (definition) => definition.id);

StudyHarmonyRewardProgressMetrics studyHarmonyRewardMetricsFromSnapshot(
  StudyHarmonyProgressSnapshot snapshot, {
  int reviewClears = 0,
  int bossClears = 0,
  int legendClears = 0,
  int bestCombo = 0,
  int totalStarsOverride = 0,
  double? bestSessionAccuracyOverride,
  double? averageLessonAccuracyOverride,
  int shopPurchases = 0,
  int currencySpent = 0,
  Map<StudyHarmonySessionMode, int> modeSessionCounts =
      const <StudyHarmonySessionMode, int>{},
  Map<StudyHarmonySessionMode, int> modeClearCounts =
      const <StudyHarmonySessionMode, int>{},
}) {
  return StudyHarmonyRewardProgressMetrics.fromSnapshot(
    snapshot,
    reviewClears: reviewClears,
    bossClears: bossClears,
    legendClears: legendClears,
    bestCombo: bestCombo,
    totalStarsOverride: totalStarsOverride,
    bestSessionAccuracyOverride: bestSessionAccuracyOverride,
    averageLessonAccuracyOverride: averageLessonAccuracyOverride,
    shopPurchases: shopPurchases,
    currencySpent: currencySpent,
    modeSessionCounts: modeSessionCounts,
    modeClearCounts: modeClearCounts,
  );
}

StudyHarmonySessionRewardInput studyHarmonySessionRewardInputFromState(
  StudyHarmonySessionState state, {
  int? starsOverride,
  int? streakOverride,
  String? rankOverride,
}) {
  return StudyHarmonySessionRewardInput.fromState(
    state,
    starsOverride: starsOverride,
    streakOverride: streakOverride,
    rankOverride: rankOverride,
  );
}

StudyHarmonyRewardProgressMetrics studyHarmonyMergedRewardMetrics({
  required StudyHarmonyRewardProgressMetrics progress,
  required StudyHarmonySessionRewardInput session,
}) {
  return progress.mergeSession(session);
}

List<StudyHarmonyRewardBundleDefinition>
studyHarmonySessionRewardBundlesForState(
  StudyHarmonySessionState state, {
  int? starsOverride,
  int? streakOverride,
  String? rankOverride,
}) {
  final input = StudyHarmonySessionRewardInput.fromState(
    state,
    starsOverride: starsOverride,
    streakOverride: streakOverride,
    rankOverride: rankOverride,
  );
  return studyHarmonySessionRewardBundles(input);
}

List<StudyHarmonyRewardCandidate> studyHarmonyRewardCandidatesForSessionState({
  required StudyHarmonySessionState state,
  required StudyHarmonyRewardProgressMetrics progress,
  int? starsOverride,
  int? streakOverride,
  String? rankOverride,
}) {
  final input = StudyHarmonySessionRewardInput.fromState(
    state,
    starsOverride: starsOverride,
    streakOverride: streakOverride,
    rankOverride: rankOverride,
  );
  return studyHarmonyRewardCandidatesForSession(
    session: input,
    progress: progress,
  );
}

List<StudyHarmonyRewardBundleDefinition> studyHarmonySessionRewardBundles(
  StudyHarmonySessionRewardInput input,
) {
  final bundles = <StudyHarmonyRewardBundleDefinition>[];
  final modeMultiplier = _modeMultiplierFor(input.mode);
  final completionFactor = input.isCompleted ? 1.0 : 0.4;

  final baseCoins = max(
    20,
    ((18 + input.correctAnswers * 5 + input.attempts * 2 + input.streak) *
            completionFactor *
            modeMultiplier)
        .round(),
  );
  bundles.add(
    _runtimeBundle(
      id: 'bundle.session.base',
      title: 'Clear Bonus',
      description: '${input.lessonTitle} clear reward',
      rarity: StudyHarmonyRewardRarity.common,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: [
        StudyHarmonyRewardGrant(
          currencyId: 'currency.studyCoin',
          amount: baseCoins,
        ),
      ],
      tags: {'session', 'baseline', _modeTag(input.mode)},
    ),
  );

  final precisionCoins = max(
    0,
    (input.accuracy * 60).round() + input.stars * 8,
  );
  final precisionShards = max(
    0,
    input.stars + (input.accuracy >= 0.98 ? 1 : 0) - 1,
  );
  if (precisionCoins > 0 || precisionShards > 0) {
    bundles.add(
      _runtimeBundle(
        id: 'bundle.session.precision',
        title: 'Precision Bonus',
        description: 'Reward for clean accuracy and strong execution.',
        rarity: StudyHarmonyRewardRarity.uncommon,
        sourceLabel: _modeDisplayLabel(input.mode),
        grants: [
          if (precisionCoins > 0)
            StudyHarmonyRewardGrant(
              currencyId: 'currency.studyCoin',
              amount: precisionCoins,
            ),
          if (precisionShards > 0)
            StudyHarmonyRewardGrant(
              currencyId: 'currency.starShard',
              amount: precisionShards,
            ),
        ],
        tags: {'session', 'accuracy', _modeTag(input.mode)},
      ),
    );
  }

  final comboTokens = input.streak >= 4 ? 1 + (input.streak >= 12 ? 1 : 0) : 0;
  final comboShields = input.streak >= 16 ? 1 : 0;
  if (comboTokens > 0 || comboShields > 0) {
    bundles.add(
      _runtimeBundle(
        id: 'bundle.session.combo',
        title: 'Combo Bonus',
        description: 'Reward for keeping a strong streak alive.',
        rarity: StudyHarmonyRewardRarity.uncommon,
        sourceLabel: _modeDisplayLabel(input.mode),
        grants: [
          if (comboTokens > 0)
            StudyHarmonyRewardGrant(
              currencyId: 'currency.focusToken',
              amount: comboTokens,
            ),
          if (comboShields > 0)
            StudyHarmonyRewardGrant(
              currencyId: 'currency.streakShield',
              amount: comboShields,
            ),
        ],
        tags: {'session', 'combo', _modeTag(input.mode)},
      ),
    );
  }

  final modeBundle = switch (input.mode) {
    StudyHarmonySessionMode.lesson => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'A light reward for a regular lesson clear.',
      rarity: StudyHarmonyRewardRarity.common,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 18),
      ],
      tags: const {'session', 'mode', 'lesson'},
    ),
    StudyHarmonySessionMode.review => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Review sessions feed the memory loop.',
      rarity: StudyHarmonyRewardRarity.uncommon,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 28),
        StudyHarmonyRewardGrant(currencyId: 'currency.rerollToken', amount: 1),
      ],
      tags: const {'session', 'mode', 'review'},
    ),
    StudyHarmonySessionMode.daily => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Daily clears keep the streak loop moving.',
      rarity: StudyHarmonyRewardRarity.rare,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 30),
        StudyHarmonyRewardGrant(currencyId: 'currency.rerollToken', amount: 1),
      ],
      tags: const {'session', 'mode', 'daily'},
    ),
    StudyHarmonySessionMode.focus => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Focus runs pay off with utility currency.',
      rarity: StudyHarmonyRewardRarity.rare,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 35),
        StudyHarmonyRewardGrant(currencyId: 'currency.focusToken', amount: 1),
      ],
      tags: const {'session', 'mode', 'focus'},
    ),
    StudyHarmonySessionMode.relay => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Relay victories deserve sharper rewards.',
      rarity: StudyHarmonyRewardRarity.epic,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 45),
        StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 1),
      ],
      tags: const {'session', 'mode', 'relay'},
    ),
    StudyHarmonySessionMode.bossRush => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Boss clears should feel like a proper payoff.',
      rarity: StudyHarmonyRewardRarity.legendary,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 55),
        StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 2),
        StudyHarmonyRewardGrant(currencyId: 'currency.streakShield', amount: 1),
      ],
      tags: const {'session', 'mode', 'boss'},
    ),
    StudyHarmonySessionMode.legend => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Legend clears get the biggest fanfare.',
      rarity: StudyHarmonyRewardRarity.mythic,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 70),
        StudyHarmonyRewardGrant(currencyId: 'currency.starShard', amount: 3),
        StudyHarmonyRewardGrant(currencyId: 'currency.streakShield', amount: 1),
      ],
      tags: const {'session', 'mode', 'legend'},
    ),
    StudyHarmonySessionMode.legacyLevel => _runtimeBundle(
      id: 'bundle.session.mode',
      title: 'Mode Bonus',
      description: 'Legacy levels still deserve a small bonus.',
      rarity: StudyHarmonyRewardRarity.common,
      sourceLabel: _modeDisplayLabel(input.mode),
      grants: const [
        StudyHarmonyRewardGrant(currencyId: 'currency.studyCoin', amount: 15),
      ],
      tags: const {'session', 'mode', 'legacy'},
    ),
  };
  bundles.add(modeBundle);

  if (input.isCompleted && (input.stars >= 2 || input.accuracy >= 0.9)) {
    bundles.add(
      _runtimeBundle(
        id: 'bundle.session.mastery',
        title: 'Mastery Bonus',
        description: 'A premium bonus for clean, completed performance.',
        rarity: StudyHarmonyRewardRarity.rare,
        sourceLabel: _modeDisplayLabel(input.mode),
        grants: [
          StudyHarmonyRewardGrant(
            currencyId: 'currency.studyCoin',
            amount: 25 + (input.stars * 10),
          ),
          StudyHarmonyRewardGrant(
            currencyId: 'currency.starShard',
            amount: input.stars >= 3 ? 2 : 1,
          ),
        ],
        tags: {'session', 'mastery', _modeTag(input.mode)},
      ),
    );
  }

  return bundles;
}

List<StudyHarmonyRewardCandidate> studyHarmonyRewardCandidatesForProgress(
  StudyHarmonyRewardProgressMetrics metrics,
) {
  final candidates = <StudyHarmonyRewardCandidate>[
    ..._achievementCandidates(metrics),
    ..._titleCandidates(metrics),
    ..._cosmeticCandidates(metrics),
    ..._shopItemCandidates(metrics),
  ];

  candidates.sort(_candidateComparator);
  return candidates;
}

List<StudyHarmonyRewardCandidate> studyHarmonyRewardCandidatesForSession({
  required StudyHarmonySessionRewardInput session,
  required StudyHarmonyRewardProgressMetrics progress,
}) {
  final merged = progress.mergeSession(session);
  return studyHarmonyRewardCandidatesForProgress(merged);
}

List<StudyHarmonyRewardCandidate> _achievementCandidates(
  StudyHarmonyRewardProgressMetrics metrics,
) {
  return [
    for (final achievement in studyHarmonyAchievements)
      _candidateFromDefinition(
        id: achievement.id,
        kind: StudyHarmonyRewardKind.achievement,
        categoryId: achievement.categoryId,
        title: achievement.title,
        description: achievement.description,
        rarity: achievement.rarity,
        tags: achievement.tags,
        requirements: achievement.requirements,
        rewardBundleIds: achievement.rewardBundleIds,
        metrics: metrics,
        sourceKind: StudyHarmonyRewardSourceKind.progress,
      ),
  ];
}

List<StudyHarmonyRewardCandidate> _titleCandidates(
  StudyHarmonyRewardProgressMetrics metrics,
) {
  return [
    for (final title in studyHarmonyTitles)
      _candidateFromDefinition(
        id: title.id,
        kind: StudyHarmonyRewardKind.title,
        title: title.title,
        description: title.description,
        rarity: title.rarity,
        tags: {...title.tags, ...title.accentTags},
        requirements: title.requirements,
        metrics: metrics,
        sourceKind: StudyHarmonyRewardSourceKind.progress,
      ),
  ];
}

List<StudyHarmonyRewardCandidate> _cosmeticCandidates(
  StudyHarmonyRewardProgressMetrics metrics,
) {
  return [
    for (final cosmetic in studyHarmonyCosmetics)
      _candidateFromDefinition(
        id: cosmetic.id,
        kind: StudyHarmonyRewardKind.cosmetic,
        title: cosmetic.title,
        description: cosmetic.description,
        rarity: cosmetic.rarity,
        tags: {...cosmetic.tags, ...cosmetic.accentTags},
        requirements: cosmetic.requirements,
        metrics: metrics,
        sourceKind: StudyHarmonyRewardSourceKind.progress,
      ),
  ];
}

List<StudyHarmonyRewardCandidate> _shopItemCandidates(
  StudyHarmonyRewardProgressMetrics metrics,
) {
  return [
    for (final item in studyHarmonyShopItems)
      _candidateFromDefinition(
        id: item.id,
        kind: StudyHarmonyRewardKind.shopItem,
        title: item.title,
        description: item.description,
        rarity: item.rarity,
        tags: item.tags,
        requirements: item.requirements,
        grants: item.grants,
        unlockIds: item.unlockIds,
        priceCurrencyId: item.priceCurrencyId,
        priceAmount: item.priceAmount,
        shopKind: item.kind,
        metrics: metrics,
        sourceKind: StudyHarmonyRewardSourceKind.shop,
      ),
  ];
}

StudyHarmonyRewardCandidate _candidateFromDefinition({
  required String id,
  required StudyHarmonyRewardKind kind,
  required String title,
  required String description,
  required StudyHarmonyRewardRarity rarity,
  required Set<StudyHarmonyRewardTag> tags,
  required List<StudyHarmonyRewardRequirement> requirements,
  required StudyHarmonyRewardProgressMetrics metrics,
  required StudyHarmonyRewardSourceKind sourceKind,
  String? categoryId,
  List<String> rewardBundleIds = const <String>[],
  List<StudyHarmonyRewardGrant> grants = const <StudyHarmonyRewardGrant>[],
  Set<String> unlockIds = const <String>{},
  StudyHarmonyCurrencyId? priceCurrencyId,
  int? priceAmount,
  StudyHarmonyShopItemKind? shopKind,
}) {
  final requirementLabels = [
    for (final requirement in requirements) requirement.describe(),
  ];
  final requirementFractions = [
    for (final requirement in requirements)
      requirement.progressFraction(metrics),
  ];
  final double progressFraction = requirementFractions.isEmpty
      ? 1.0
      : requirementFractions.reduce(min).toDouble();
  final unmetRequirementLabels = [
    for (var index = 0; index < requirements.length; index++)
      if (requirementFractions[index] < 1) requirementLabels[index],
  ];

  return StudyHarmonyRewardCandidate(
    id: id,
    kind: kind,
    title: title,
    description: description,
    rarity: rarity,
    tags: tags,
    unlocked: unmetRequirementLabels.isEmpty,
    progressFraction: progressFraction,
    requirementLabels: requirementLabels,
    unmetRequirementLabels: unmetRequirementLabels,
    categoryId: categoryId,
    rewardBundleIds: rewardBundleIds,
    grants: grants,
    unlockIds: unlockIds,
    priceCurrencyId: priceCurrencyId,
    priceAmount: priceAmount,
    shopKind: shopKind,
    sourceKind: sourceKind,
  );
}

StudyHarmonyRewardBundleDefinition _runtimeBundle({
  required String id,
  required String title,
  required String description,
  required StudyHarmonyRewardRarity rarity,
  required List<StudyHarmonyRewardGrant> grants,
  required String sourceLabel,
  required Set<StudyHarmonyRewardTag> tags,
  Set<String> unlockIds = const <String>{},
}) {
  return StudyHarmonyRewardBundleDefinition(
    id: id,
    title: title,
    description: description,
    rarity: rarity,
    grants: grants,
    unlockIds: unlockIds,
    sourceKind: StudyHarmonyRewardSourceKind.session,
    sourceLabel: sourceLabel,
    tags: tags,
  );
}

int _modeCount(
  Map<StudyHarmonySessionMode, int> counts,
  StudyHarmonySessionMode? mode,
) {
  if (mode == null) {
    return counts.values.fold<int>(0, (sum, value) => sum + value);
  }
  return counts[mode] ?? 0;
}

void _incrementCount(
  Map<StudyHarmonySessionMode, int> counts,
  StudyHarmonySessionMode mode,
) {
  counts[mode] = (counts[mode] ?? 0) + 1;
}

double _modeMultiplierFor(StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.lesson => 1.0,
    StudyHarmonySessionMode.review => 1.05,
    StudyHarmonySessionMode.daily => 1.15,
    StudyHarmonySessionMode.focus => 1.2,
    StudyHarmonySessionMode.relay => 1.3,
    StudyHarmonySessionMode.bossRush => 1.45,
    StudyHarmonySessionMode.legend => 1.7,
    StudyHarmonySessionMode.legacyLevel => 0.95,
  };
}

String _modeDisplayLabel(StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.lesson => 'Lesson',
    StudyHarmonySessionMode.review => 'Review',
    StudyHarmonySessionMode.daily => 'Daily',
    StudyHarmonySessionMode.focus => 'Focus',
    StudyHarmonySessionMode.relay => 'Relay',
    StudyHarmonySessionMode.bossRush => 'Boss Rush',
    StudyHarmonySessionMode.legend => 'Legend',
    StudyHarmonySessionMode.legacyLevel => 'Legacy',
  };
}

String _modeTag(StudyHarmonySessionMode mode) {
  return switch (mode) {
    StudyHarmonySessionMode.lesson => 'lesson',
    StudyHarmonySessionMode.review => 'review',
    StudyHarmonySessionMode.daily => 'daily',
    StudyHarmonySessionMode.focus => 'focus',
    StudyHarmonySessionMode.relay => 'relay',
    StudyHarmonySessionMode.bossRush => 'boss',
    StudyHarmonySessionMode.legend => 'legend',
    StudyHarmonySessionMode.legacyLevel => 'legacy',
  };
}

int _estimateStarsFromSession(StudyHarmonySessionState state) {
  if (!state.isCompleted) {
    return 0;
  }
  final accuracy = state.accuracy;
  if (accuracy >= 0.95) {
    return 3;
  }
  if (accuracy >= 0.8) {
    return 2;
  }
  if (accuracy >= 0.65) {
    return 1;
  }
  return 0;
}

String _estimateRankFromSession(
  StudyHarmonySessionState state, {
  required int stars,
}) {
  if (!state.isCompleted) {
    return 'D';
  }
  return switch (stars) {
    3 => 'S',
    2 => 'A',
    1 => 'B',
    _ => state.accuracy >= 0.5 ? 'C' : 'D',
  };
}

String _describeRequirement(StudyHarmonyRewardRequirement requirement) {
  final target = requirement.target;
  final targetText = target % 1 == 0
      ? target.toInt().toString()
      : target.toStringAsFixed(2);
  final modeText = requirement.mode == null
      ? ''
      : ' ${_modeDisplayLabel(requirement.mode!)}';
  return switch (requirement.kind) {
    StudyHarmonyRewardRequirementKind.lessonClears =>
      '$targetText lesson clears',
    StudyHarmonyRewardRequirementKind.reviewClears =>
      '$targetText review clears',
    StudyHarmonyRewardRequirementKind.dailyClears => '$targetText daily clears',
    StudyHarmonyRewardRequirementKind.focusClears => '$targetText focus clears',
    StudyHarmonyRewardRequirementKind.relayWins => '$targetText relay wins',
    StudyHarmonyRewardRequirementKind.bossClears => '$targetText boss clears',
    StudyHarmonyRewardRequirementKind.legendClears =>
      '$targetText legend clears',
    StudyHarmonyRewardRequirementKind.questChests => '$targetText quest chests',
    StudyHarmonyRewardRequirementKind.monthlyTourRewards =>
      '$targetText monthly tour rewards',
    StudyHarmonyRewardRequirementKind.activeDays => '$targetText active days',
    StudyHarmonyRewardRequirementKind.totalStars => '$targetText total stars',
    StudyHarmonyRewardRequirementKind.bestCombo => '$targetText best combo',
    StudyHarmonyRewardRequirementKind.bestSessionAccuracy =>
      '${(target * 100).round()}% session accuracy',
    StudyHarmonyRewardRequirementKind.averageLessonAccuracy =>
      '${(target * 100).round()}% average lesson accuracy',
    StudyHarmonyRewardRequirementKind.bestDailyStreak =>
      '$targetText best daily streak',
    StudyHarmonyRewardRequirementKind.bestDuetStreak =>
      '$targetText best duet streak',
    StudyHarmonyRewardRequirementKind.shopPurchases =>
      '$targetText shop purchases',
    StudyHarmonyRewardRequirementKind.currencySpent =>
      '$targetText currency spent',
    StudyHarmonyRewardRequirementKind.modeSessions =>
      '$targetText$modeText sessions',
    StudyHarmonyRewardRequirementKind.modeClears =>
      '$targetText$modeText clears',
  };
}

int _rewardKindOrder(StudyHarmonyRewardKind kind) {
  return switch (kind) {
    StudyHarmonyRewardKind.achievement => 0,
    StudyHarmonyRewardKind.title => 1,
    StudyHarmonyRewardKind.cosmetic => 2,
    StudyHarmonyRewardKind.shopItem => 3,
  };
}

int _rarityOrder(StudyHarmonyRewardRarity rarity) {
  return rarity.index;
}

int _categoryOrder(String? categoryId) {
  if (categoryId == null) {
    return 999;
  }
  return studyHarmonyAchievementCategoriesById[categoryId]?.order ?? 999;
}

int _candidateComparator(
  StudyHarmonyRewardCandidate a,
  StudyHarmonyRewardCandidate b,
) {
  final unlockedCompare = (b.unlocked ? 1 : 0).compareTo(a.unlocked ? 1 : 0);
  if (unlockedCompare != 0) {
    return unlockedCompare;
  }
  final kindCompare = _rewardKindOrder(
    a.kind,
  ).compareTo(_rewardKindOrder(b.kind));
  if (kindCompare != 0) {
    return kindCompare;
  }
  final categoryCompare = _categoryOrder(
    a.categoryId,
  ).compareTo(_categoryOrder(b.categoryId));
  if (categoryCompare != 0) {
    return categoryCompare;
  }
  final progressCompare = b.progressFraction.compareTo(a.progressFraction);
  if (progressCompare != 0) {
    return progressCompare;
  }
  final rarityCompare = _rarityOrder(
    b.rarity,
  ).compareTo(_rarityOrder(a.rarity));
  if (rarityCompare != 0) {
    return rarityCompare;
  }
  return a.id.compareTo(b.id);
}

Map<String, T> _indexById<T>(
  Iterable<T> values,
  String Function(T value) selector,
) {
  return <String, T>{for (final value in values) selector(value): value};
}
