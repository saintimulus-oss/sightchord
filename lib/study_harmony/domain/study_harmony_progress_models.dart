import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'study_harmony_session_models.dart';

@immutable
class StudyHarmonyLessonProgressSummary {
  const StudyHarmonyLessonProgressSummary({
    required this.lessonId,
    required this.isCleared,
    required this.bestAccuracy,
    required this.bestAttemptCount,
    required this.bestStars,
    required this.bestRank,
    required this.bestElapsedMillis,
    required this.playCount,
    this.lastPlayedAtIso8601,
  });

  final StudyHarmonyLessonId lessonId;
  final bool isCleared;
  final double bestAccuracy;
  final int bestAttemptCount;
  final int bestStars;
  final String bestRank;
  final int bestElapsedMillis;
  final int playCount;
  final String? lastPlayedAtIso8601;

  StudyHarmonyLessonProgressSummary copyWith({
    StudyHarmonyLessonId? lessonId,
    bool? isCleared,
    double? bestAccuracy,
    int? bestAttemptCount,
    int? bestStars,
    String? bestRank,
    int? bestElapsedMillis,
    int? playCount,
    String? lastPlayedAtIso8601,
    bool clearLastPlayedAt = false,
  }) {
    return StudyHarmonyLessonProgressSummary(
      lessonId: lessonId ?? this.lessonId,
      isCleared: isCleared ?? this.isCleared,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      bestAttemptCount: bestAttemptCount ?? this.bestAttemptCount,
      bestStars: bestStars ?? this.bestStars,
      bestRank: bestRank ?? this.bestRank,
      bestElapsedMillis: bestElapsedMillis ?? this.bestElapsedMillis,
      playCount: playCount ?? this.playCount,
      lastPlayedAtIso8601: clearLastPlayedAt
          ? null
          : lastPlayedAtIso8601 ?? this.lastPlayedAtIso8601,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'lessonId': lessonId,
      'isCleared': isCleared,
      'bestAccuracy': bestAccuracy,
      'bestAttemptCount': bestAttemptCount,
      'bestStars': bestStars,
      'bestRank': bestRank,
      'bestElapsedMillis': bestElapsedMillis,
      'playCount': playCount,
      'lastPlayedAtIso8601': lastPlayedAtIso8601,
    };
  }

  static StudyHarmonyLessonProgressSummary fromJson(
    Map<String, Object?> json, {
    required String lessonIdFallback,
  }) {
    return StudyHarmonyLessonProgressSummary(
      lessonId: _stringOrNull(json['lessonId']) ?? lessonIdFallback,
      isCleared: _boolOrFalse(json['isCleared']),
      bestAccuracy: _doubleOrZero(json['bestAccuracy']),
      bestAttemptCount: _intOrZero(json['bestAttemptCount']),
      bestStars: _intOrZero(json['bestStars']),
      bestRank: _stringOrNull(json['bestRank']) ?? 'C',
      bestElapsedMillis: _intOrZero(json['bestElapsedMillis']),
      playCount: _intOrZero(json['playCount']),
      lastPlayedAtIso8601: _stringOrNull(json['lastPlayedAtIso8601']),
    );
  }
}

@immutable
class StudyHarmonySkillMasteryPlaceholder {
  const StudyHarmonySkillMasteryPlaceholder({
    required this.skillId,
    required this.masteryScore,
    required this.exposureCount,
    required this.correctSessionCount,
    required this.recentAttemptScores,
    required this.recentAccuracy,
    required this.confidenceStreak,
    this.lastSeenAtIso8601,
  });

  final StudyHarmonySkillTag skillId;
  final double masteryScore;
  final int exposureCount;
  final int correctSessionCount;
  final List<double> recentAttemptScores;
  final double recentAccuracy;
  final int confidenceStreak;
  final String? lastSeenAtIso8601;

  int get recentAttemptCount => recentAttemptScores.length;

  int get recentIncorrectCount =>
      recentAttemptScores.where((score) => score < 0.75).length;

  String? get lastUpdatedAtIso8601 => lastSeenAtIso8601;

  StudyHarmonySkillMasteryPlaceholder copyWith({
    StudyHarmonySkillTag? skillId,
    double? masteryScore,
    int? exposureCount,
    int? correctSessionCount,
    List<double>? recentAttemptScores,
    double? recentAccuracy,
    int? confidenceStreak,
    String? lastSeenAtIso8601,
    bool clearLastSeenAt = false,
  }) {
    return StudyHarmonySkillMasteryPlaceholder(
      skillId: skillId ?? this.skillId,
      masteryScore: masteryScore ?? this.masteryScore,
      exposureCount: exposureCount ?? this.exposureCount,
      correctSessionCount: correctSessionCount ?? this.correctSessionCount,
      recentAttemptScores: recentAttemptScores ?? this.recentAttemptScores,
      recentAccuracy: recentAccuracy ?? this.recentAccuracy,
      confidenceStreak: confidenceStreak ?? this.confidenceStreak,
      lastSeenAtIso8601: clearLastSeenAt
          ? null
          : lastSeenAtIso8601 ?? this.lastSeenAtIso8601,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'skillId': skillId,
      'masteryScore': masteryScore,
      'exposureCount': exposureCount,
      'correctSessionCount': correctSessionCount,
      'recentAttemptScores': recentAttemptScores,
      'recentAccuracy': recentAccuracy,
      'confidenceStreak': confidenceStreak,
      'lastSeenAtIso8601': lastSeenAtIso8601,
    };
  }

  static StudyHarmonySkillMasteryPlaceholder fromJson(
    Map<String, Object?> json, {
    required String skillIdFallback,
  }) {
    return StudyHarmonySkillMasteryPlaceholder(
      skillId: _stringOrNull(json['skillId']) ?? skillIdFallback,
      masteryScore: _doubleOrZero(json['masteryScore']),
      exposureCount: _intOrZero(json['exposureCount']),
      correctSessionCount: _intOrZero(json['correctSessionCount']),
      recentAttemptScores: _doubleListOrEmpty(json['recentAttemptScores']),
      recentAccuracy:
          _doubleOrNull(json['recentAccuracy']) ??
          _doubleOrZero(json['masteryScore']),
      confidenceStreak: _intOrZero(json['confidenceStreak']),
      lastSeenAtIso8601:
          _stringOrNull(json['lastSeenAtIso8601']) ??
          _stringOrNull(json['lastUpdatedAtIso8601']),
    );
  }
}

@immutable
class StudyHarmonyReviewQueuePlaceholderEntry {
  const StudyHarmonyReviewQueuePlaceholderEntry({
    required this.itemId,
    required this.lessonId,
    required this.reason,
    required this.dueAtIso8601,
    required this.priority,
    this.skillTags = const <StudyHarmonySkillTag>{},
  });

  final String itemId;
  final StudyHarmonyLessonId lessonId;
  final String reason;
  final String dueAtIso8601;
  final int priority;
  final Set<StudyHarmonySkillTag> skillTags;

  StudyHarmonyReviewQueuePlaceholderEntry copyWith({
    String? itemId,
    StudyHarmonyLessonId? lessonId,
    String? reason,
    String? dueAtIso8601,
    int? priority,
    Set<StudyHarmonySkillTag>? skillTags,
  }) {
    return StudyHarmonyReviewQueuePlaceholderEntry(
      itemId: itemId ?? this.itemId,
      lessonId: lessonId ?? this.lessonId,
      reason: reason ?? this.reason,
      dueAtIso8601: dueAtIso8601 ?? this.dueAtIso8601,
      priority: priority ?? this.priority,
      skillTags: skillTags ?? this.skillTags,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'itemId': itemId,
      'lessonId': lessonId,
      'reason': reason,
      'dueAtIso8601': dueAtIso8601,
      'priority': priority,
      'skillTags': skillTags.toList(growable: false)..sort(),
    };
  }

  static StudyHarmonyReviewQueuePlaceholderEntry fromJson(
    Map<String, Object?> json,
  ) {
    return StudyHarmonyReviewQueuePlaceholderEntry(
      itemId: _stringOrNull(json['itemId']) ?? '',
      lessonId: _stringOrNull(json['lessonId']) ?? '',
      reason: _stringOrNull(json['reason']) ?? 'placeholder',
      dueAtIso8601:
          _stringOrNull(json['dueAtIso8601']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toIso8601String(),
      priority: _intOrZero(json['priority']),
      skillTags: _stringSetFromValue(json['skillTags']),
    );
  }
}

@immutable
class StudyHarmonyDailyChallengeSeedMetadata {
  const StudyHarmonyDailyChallengeSeedMetadata({
    required this.version,
    required this.dateKey,
    required this.seedValue,
    this.trackId,
    this.chapterId,
    this.lessonId,
    this.sourceLessonIds = const <StudyHarmonyLessonId>[],
  });

  final int version;
  final String dateKey;
  final int seedValue;
  final StudyHarmonyTrackId? trackId;
  final StudyHarmonyChapterId? chapterId;
  final StudyHarmonyLessonId? lessonId;
  final List<StudyHarmonyLessonId> sourceLessonIds;

  StudyHarmonyDailyChallengeSeedMetadata copyWith({
    int? version,
    String? dateKey,
    int? seedValue,
    StudyHarmonyTrackId? trackId,
    StudyHarmonyChapterId? chapterId,
    StudyHarmonyLessonId? lessonId,
    List<StudyHarmonyLessonId>? sourceLessonIds,
    bool clearTrackId = false,
    bool clearChapterId = false,
    bool clearLessonId = false,
  }) {
    return StudyHarmonyDailyChallengeSeedMetadata(
      version: version ?? this.version,
      dateKey: dateKey ?? this.dateKey,
      seedValue: seedValue ?? this.seedValue,
      trackId: clearTrackId ? null : trackId ?? this.trackId,
      chapterId: clearChapterId ? null : chapterId ?? this.chapterId,
      lessonId: clearLessonId ? null : lessonId ?? this.lessonId,
      sourceLessonIds: sourceLessonIds ?? this.sourceLessonIds,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'version': version,
      'dateKey': dateKey,
      'seedValue': seedValue,
      'trackId': trackId,
      'chapterId': chapterId,
      'lessonId': lessonId,
      'sourceLessonIds': sourceLessonIds,
    };
  }

  String encode() => jsonEncode(toJson());

  static StudyHarmonyDailyChallengeSeedMetadata? fromJsonValue(Object? value) {
    final json = _mapOrNull(value);
    if (json == null) {
      return null;
    }
    return StudyHarmonyDailyChallengeSeedMetadata(
      version: _intOr(json['version'], fallback: 1),
      dateKey: _stringOrNull(json['dateKey']) ?? '',
      seedValue: _intOrZero(json['seedValue']),
      trackId: _stringOrNull(json['trackId']),
      chapterId: _stringOrNull(json['chapterId']),
      lessonId: _stringOrNull(json['lessonId']),
      sourceLessonIds: _listOrEmpty(
        json['sourceLessonIds'],
      ).whereType<String>().toList(growable: false),
    );
  }

  static StudyHarmonyDailyChallengeSeedMetadata? fromEncoded(String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      return null;
    }
    try {
      return fromJsonValue(jsonDecode(encoded));
    } on FormatException {
      return null;
    }
  }
}

@immutable
class StudyHarmonyProgressSnapshot {
  const StudyHarmonyProgressSnapshot({
    required this.serializationVersion,
    this.lastPlayedTrackId,
    this.lastPlayedChapterId,
    this.lastPlayedLessonId,
    this.unlockedChapterIds = const <StudyHarmonyChapterId>{},
    this.unlockedLessonIds = const <StudyHarmonyLessonId>{},
    this.lessonResults =
        const <StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>{},
    this.skillMasteryPlaceholders =
        const <StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>{},
    this.reviewQueuePlaceholders =
        const <StudyHarmonyReviewQueuePlaceholderEntry>[],
    this.dailyChallengeSeedMetadata,
    this.completedDailyChallengeDateKeys = const <String>{},
    this.protectedDailyChallengeDateKeys = const <String>{},
    this.activityDateKeys = const <String>{},
    this.completedFocusChallengeDateKeys = const <String>{},
    this.completedSpotlightChallengeDateKeys = const <String>{},
    this.completedFrontierQuestDateKeys = const <String>{},
    this.awardedWeeklyPlanWeekKeys = const <String>{},
    this.awardedDailyQuestChestDateKeys = const <String>{},
    this.awardedMonthlyTourMonthKeys = const <String>{},
    this.weeklyLeagueScores = const <String, int>{},
    this.monthlySpotlightClearCounts = const <String, int>{},
    this.modeSessionCounts = const <String, int>{},
    this.modeClearCounts = const <String, int>{},
    this.rewardCurrencyBalances = const <String, int>{},
    this.rewardCurrencySpent = 0,
    this.shopPurchaseCount = 0,
    this.purchasedUniqueShopItemIds = const <String>{},
    this.ownedTitleIds = const <String>{},
    this.ownedCosmeticIds = const <String>{},
    this.equippedTitleId,
    this.equippedCosmeticIds = const <String>[],
    this.bestSessionCombo = 0,
    this.legendaryChapterIds = const <StudyHarmonyChapterId>{},
    this.relayWinCount = 0,
    this.bestDailyChallengeStreak = 0,
    this.bestDuetPactStreak = 0,
    this.streakSaverCount = 0,
    this.questChestCount = 0,
    this.activeLeagueXpBoostDateKey,
    this.activeLeagueXpBoostCharges = 0,
  });

  static const int currentSerializationVersion = 14;

  final int serializationVersion;
  final StudyHarmonyTrackId? lastPlayedTrackId;
  final StudyHarmonyChapterId? lastPlayedChapterId;
  final StudyHarmonyLessonId? lastPlayedLessonId;
  final Set<StudyHarmonyChapterId> unlockedChapterIds;
  final Set<StudyHarmonyLessonId> unlockedLessonIds;
  final Map<StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>
  lessonResults;
  final Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>
  skillMasteryPlaceholders;
  final List<StudyHarmonyReviewQueuePlaceholderEntry> reviewQueuePlaceholders;
  final StudyHarmonyDailyChallengeSeedMetadata? dailyChallengeSeedMetadata;
  final Set<String> completedDailyChallengeDateKeys;
  final Set<String> protectedDailyChallengeDateKeys;
  final Set<String> activityDateKeys;
  final Set<String> completedFocusChallengeDateKeys;
  final Set<String> completedSpotlightChallengeDateKeys;
  final Set<String> completedFrontierQuestDateKeys;
  final Set<String> awardedWeeklyPlanWeekKeys;
  final Set<String> awardedDailyQuestChestDateKeys;
  final Set<String> awardedMonthlyTourMonthKeys;
  final Map<String, int> weeklyLeagueScores;
  final Map<String, int> monthlySpotlightClearCounts;
  final Map<String, int> modeSessionCounts;
  final Map<String, int> modeClearCounts;
  final Map<String, int> rewardCurrencyBalances;
  final int rewardCurrencySpent;
  final int shopPurchaseCount;
  final Set<String> purchasedUniqueShopItemIds;
  final Set<String> ownedTitleIds;
  final Set<String> ownedCosmeticIds;
  final String? equippedTitleId;
  final List<String> equippedCosmeticIds;
  final int bestSessionCombo;
  final Set<StudyHarmonyChapterId> legendaryChapterIds;
  final int relayWinCount;
  final int bestDailyChallengeStreak;
  final int bestDuetPactStreak;
  final int streakSaverCount;
  final int questChestCount;
  final String? activeLeagueXpBoostDateKey;
  final int activeLeagueXpBoostCharges;

  factory StudyHarmonyProgressSnapshot.initial() {
    return const StudyHarmonyProgressSnapshot(
      serializationVersion: currentSerializationVersion,
    );
  }

  StudyHarmonyProgressSnapshot copyWith({
    int? serializationVersion,
    StudyHarmonyTrackId? lastPlayedTrackId,
    StudyHarmonyChapterId? lastPlayedChapterId,
    StudyHarmonyLessonId? lastPlayedLessonId,
    Set<StudyHarmonyChapterId>? unlockedChapterIds,
    Set<StudyHarmonyLessonId>? unlockedLessonIds,
    Map<StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>? lessonResults,
    Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>?
    skillMasteryPlaceholders,
    List<StudyHarmonyReviewQueuePlaceholderEntry>? reviewQueuePlaceholders,
    StudyHarmonyDailyChallengeSeedMetadata? dailyChallengeSeedMetadata,
    Set<String>? completedDailyChallengeDateKeys,
    Set<String>? protectedDailyChallengeDateKeys,
    Set<String>? activityDateKeys,
    Set<String>? completedFocusChallengeDateKeys,
    Set<String>? completedSpotlightChallengeDateKeys,
    Set<String>? completedFrontierQuestDateKeys,
    Set<String>? awardedWeeklyPlanWeekKeys,
    Set<String>? awardedDailyQuestChestDateKeys,
    Set<String>? awardedMonthlyTourMonthKeys,
    Map<String, int>? weeklyLeagueScores,
    Map<String, int>? monthlySpotlightClearCounts,
    Map<String, int>? modeSessionCounts,
    Map<String, int>? modeClearCounts,
    Map<String, int>? rewardCurrencyBalances,
    int? rewardCurrencySpent,
    int? shopPurchaseCount,
    Set<String>? purchasedUniqueShopItemIds,
    Set<String>? ownedTitleIds,
    Set<String>? ownedCosmeticIds,
    String? equippedTitleId,
    List<String>? equippedCosmeticIds,
    bool clearEquippedTitleId = false,
    bool clearEquippedCosmeticIds = false,
    int? bestSessionCombo,
    Set<StudyHarmonyChapterId>? legendaryChapterIds,
    int? relayWinCount,
    int? bestDailyChallengeStreak,
    int? bestDuetPactStreak,
    int? streakSaverCount,
    int? questChestCount,
    String? activeLeagueXpBoostDateKey,
    int? activeLeagueXpBoostCharges,
    bool clearLastPlayedTrackId = false,
    bool clearLastPlayedChapterId = false,
    bool clearLastPlayedLessonId = false,
    bool clearDailyChallengeSeedMetadata = false,
    bool clearActiveLeagueXpBoostDateKey = false,
  }) {
    return StudyHarmonyProgressSnapshot(
      serializationVersion: serializationVersion ?? this.serializationVersion,
      lastPlayedTrackId: clearLastPlayedTrackId
          ? null
          : lastPlayedTrackId ?? this.lastPlayedTrackId,
      lastPlayedChapterId: clearLastPlayedChapterId
          ? null
          : lastPlayedChapterId ?? this.lastPlayedChapterId,
      lastPlayedLessonId: clearLastPlayedLessonId
          ? null
          : lastPlayedLessonId ?? this.lastPlayedLessonId,
      unlockedChapterIds: unlockedChapterIds ?? this.unlockedChapterIds,
      unlockedLessonIds: unlockedLessonIds ?? this.unlockedLessonIds,
      lessonResults: lessonResults ?? this.lessonResults,
      skillMasteryPlaceholders:
          skillMasteryPlaceholders ?? this.skillMasteryPlaceholders,
      reviewQueuePlaceholders:
          reviewQueuePlaceholders ?? this.reviewQueuePlaceholders,
      dailyChallengeSeedMetadata: clearDailyChallengeSeedMetadata
          ? null
          : dailyChallengeSeedMetadata ?? this.dailyChallengeSeedMetadata,
      completedDailyChallengeDateKeys:
          completedDailyChallengeDateKeys ??
          this.completedDailyChallengeDateKeys,
      protectedDailyChallengeDateKeys:
          protectedDailyChallengeDateKeys ??
          this.protectedDailyChallengeDateKeys,
      activityDateKeys: activityDateKeys ?? this.activityDateKeys,
      completedFocusChallengeDateKeys:
          completedFocusChallengeDateKeys ??
          this.completedFocusChallengeDateKeys,
      completedSpotlightChallengeDateKeys:
          completedSpotlightChallengeDateKeys ??
          this.completedSpotlightChallengeDateKeys,
      completedFrontierQuestDateKeys:
          completedFrontierQuestDateKeys ?? this.completedFrontierQuestDateKeys,
      awardedWeeklyPlanWeekKeys:
          awardedWeeklyPlanWeekKeys ?? this.awardedWeeklyPlanWeekKeys,
      awardedDailyQuestChestDateKeys:
          awardedDailyQuestChestDateKeys ?? this.awardedDailyQuestChestDateKeys,
      awardedMonthlyTourMonthKeys:
          awardedMonthlyTourMonthKeys ?? this.awardedMonthlyTourMonthKeys,
      weeklyLeagueScores: weeklyLeagueScores ?? this.weeklyLeagueScores,
      monthlySpotlightClearCounts:
          monthlySpotlightClearCounts ?? this.monthlySpotlightClearCounts,
      modeSessionCounts: modeSessionCounts ?? this.modeSessionCounts,
      modeClearCounts: modeClearCounts ?? this.modeClearCounts,
      rewardCurrencyBalances:
          rewardCurrencyBalances ?? this.rewardCurrencyBalances,
      rewardCurrencySpent: rewardCurrencySpent ?? this.rewardCurrencySpent,
      shopPurchaseCount: shopPurchaseCount ?? this.shopPurchaseCount,
      purchasedUniqueShopItemIds:
          purchasedUniqueShopItemIds ?? this.purchasedUniqueShopItemIds,
      ownedTitleIds: ownedTitleIds ?? this.ownedTitleIds,
      ownedCosmeticIds: ownedCosmeticIds ?? this.ownedCosmeticIds,
      equippedTitleId: clearEquippedTitleId
          ? null
          : equippedTitleId ?? this.equippedTitleId,
      equippedCosmeticIds: clearEquippedCosmeticIds
          ? const <String>[]
          : equippedCosmeticIds ?? this.equippedCosmeticIds,
      bestSessionCombo: bestSessionCombo ?? this.bestSessionCombo,
      legendaryChapterIds: legendaryChapterIds ?? this.legendaryChapterIds,
      relayWinCount: relayWinCount ?? this.relayWinCount,
      bestDailyChallengeStreak:
          bestDailyChallengeStreak ?? this.bestDailyChallengeStreak,
      bestDuetPactStreak: bestDuetPactStreak ?? this.bestDuetPactStreak,
      streakSaverCount: streakSaverCount ?? this.streakSaverCount,
      questChestCount: questChestCount ?? this.questChestCount,
      activeLeagueXpBoostDateKey: clearActiveLeagueXpBoostDateKey
          ? null
          : activeLeagueXpBoostDateKey ?? this.activeLeagueXpBoostDateKey,
      activeLeagueXpBoostCharges:
          activeLeagueXpBoostCharges ?? this.activeLeagueXpBoostCharges,
    );
  }

  Map<String, Object?> toJson() {
    final sortedLessonKeys = lessonResults.keys.toList(growable: false)..sort();
    final sortedSkillKeys = skillMasteryPlaceholders.keys.toList(
      growable: false,
    )..sort();
    final sortedUnlockedChapters = unlockedChapterIds.toList(growable: false)
      ..sort();
    final sortedUnlockedLessons = unlockedLessonIds.toList(growable: false)
      ..sort();
    final sortedCompletedDailyDates = completedDailyChallengeDateKeys.toList(
      growable: false,
    )..sort();
    final sortedProtectedDailyDates = protectedDailyChallengeDateKeys.toList(
      growable: false,
    )..sort();
    final sortedActivityDates = activityDateKeys.toList(growable: false)
      ..sort();
    final sortedCompletedFocusDates = completedFocusChallengeDateKeys.toList(
      growable: false,
    )..sort();
    final sortedCompletedSpotlightDates =
        completedSpotlightChallengeDateKeys.toList(growable: false)..sort();
    final sortedCompletedFrontierQuestDates =
        completedFrontierQuestDateKeys.toList(growable: false)..sort();
    final sortedAwardedWeeklyPlanWeekKeys = awardedWeeklyPlanWeekKeys.toList(
      growable: false,
    )..sort();
    final sortedAwardedDailyQuestChestDates =
        awardedDailyQuestChestDateKeys.toList(growable: false)..sort();
    final sortedAwardedMonthlyTourMonthKeys =
        awardedMonthlyTourMonthKeys.toList(growable: false)..sort();
    final sortedWeeklyLeagueScoreKeys = weeklyLeagueScores.keys.toList(
      growable: false,
    )..sort();
    final sortedMonthlySpotlightKeys = monthlySpotlightClearCounts.keys.toList(
      growable: false,
    )..sort();
    final sortedModeSessionKeys = modeSessionCounts.keys.toList(growable: false)
      ..sort();
    final sortedModeClearKeys = modeClearCounts.keys.toList(growable: false)
      ..sort();
    final sortedRewardCurrencyKeys = rewardCurrencyBalances.keys.toList(
      growable: false,
    )..sort();
    final sortedPurchasedUniqueShopItemIds = purchasedUniqueShopItemIds.toList(
      growable: false,
    )..sort();
    final sortedOwnedTitleIds = ownedTitleIds.toList(growable: false)..sort();
    final sortedOwnedCosmeticIds = ownedCosmeticIds.toList(growable: false)
      ..sort();
    final sortedLegendaryChapterIds = legendaryChapterIds.toList(
      growable: false,
    )..sort();
    final equippedCosmeticIds = this.equippedCosmeticIds.toList(
      growable: false,
    );

    return {
      'serializationVersion': serializationVersion,
      'lastPlayedTrackId': lastPlayedTrackId,
      'lastPlayedChapterId': lastPlayedChapterId,
      'lastPlayedLessonId': lastPlayedLessonId,
      'unlockedChapterIds': sortedUnlockedChapters,
      'unlockedLessonIds': sortedUnlockedLessons,
      'lessonResults': {
        for (final lessonId in sortedLessonKeys)
          lessonId: lessonResults[lessonId]!.toJson(),
      },
      'skillMastery': {
        for (final skillId in sortedSkillKeys)
          skillId: skillMasteryPlaceholders[skillId]!.toJson(),
      },
      'reviewQueueEntries': [
        for (final entry in reviewQueuePlaceholders) entry.toJson(),
      ],
      'dailyChallengeSeedMetadata': dailyChallengeSeedMetadata?.toJson(),
      'completedDailyChallengeDateKeys': sortedCompletedDailyDates,
      'protectedDailyChallengeDateKeys': sortedProtectedDailyDates,
      'activityDateKeys': sortedActivityDates,
      'completedFocusChallengeDateKeys': sortedCompletedFocusDates,
      'completedSpotlightChallengeDateKeys': sortedCompletedSpotlightDates,
      'completedFrontierQuestDateKeys': sortedCompletedFrontierQuestDates,
      'awardedWeeklyPlanWeekKeys': sortedAwardedWeeklyPlanWeekKeys,
      'awardedDailyQuestChestDateKeys': sortedAwardedDailyQuestChestDates,
      'awardedMonthlyTourMonthKeys': sortedAwardedMonthlyTourMonthKeys,
      'weeklyLeagueScores': {
        for (final weekKey in sortedWeeklyLeagueScoreKeys)
          weekKey: weeklyLeagueScores[weekKey],
      },
      'monthlySpotlightClearCounts': {
        for (final monthKey in sortedMonthlySpotlightKeys)
          monthKey: monthlySpotlightClearCounts[monthKey],
      },
      'modeSessionCounts': {
        for (final modeKey in sortedModeSessionKeys)
          modeKey: modeSessionCounts[modeKey],
      },
      'modeClearCounts': {
        for (final modeKey in sortedModeClearKeys)
          modeKey: modeClearCounts[modeKey],
      },
      'rewardCurrencyBalances': {
        for (final currencyId in sortedRewardCurrencyKeys)
          currencyId: rewardCurrencyBalances[currencyId],
      },
      'rewardCurrencySpent': rewardCurrencySpent,
      'shopPurchaseCount': shopPurchaseCount,
      'purchasedUniqueShopItemIds': sortedPurchasedUniqueShopItemIds,
      'ownedTitleIds': sortedOwnedTitleIds,
      'ownedCosmeticIds': sortedOwnedCosmeticIds,
      'equippedTitleId': equippedTitleId,
      'equippedCosmeticIds': equippedCosmeticIds,
      'bestSessionCombo': bestSessionCombo,
      'legendaryChapterIds': sortedLegendaryChapterIds,
      'relayWinCount': relayWinCount,
      'bestDailyChallengeStreak': bestDailyChallengeStreak,
      'bestDuetPactStreak': bestDuetPactStreak,
      'streakSaverCount': streakSaverCount,
      'questChestCount': questChestCount,
      'activeLeagueXpBoostDateKey': activeLeagueXpBoostDateKey,
      'activeLeagueXpBoostCharges': activeLeagueXpBoostCharges,
    };
  }

  String encode() => jsonEncode(toJson());

  static StudyHarmonyProgressSnapshot fromJsonValue(Object? value) {
    final json = _mapOrNull(value);
    if (json == null) {
      return StudyHarmonyProgressSnapshot.initial();
    }

    final lessonResults =
        <StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>{};
    final lessonResultJson = _mapOrNull(json['lessonResults']);
    if (lessonResultJson != null) {
      for (final entry in lessonResultJson.entries) {
        final nested = _mapOrNull(entry.value);
        if (nested != null) {
          lessonResults[entry.key] = StudyHarmonyLessonProgressSummary.fromJson(
            nested,
            lessonIdFallback: entry.key,
          );
        }
      }
    }

    final mastery =
        <StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>{};
    final masteryJson =
        _mapOrNull(json['skillMastery']) ??
        _mapOrNull(json['skillMasteryPlaceholders']);
    if (masteryJson != null) {
      for (final entry in masteryJson.entries) {
        final nested = _mapOrNull(entry.value);
        if (nested != null) {
          mastery[entry.key] = StudyHarmonySkillMasteryPlaceholder.fromJson(
            nested,
            skillIdFallback: entry.key,
          );
        }
      }
    }

    final reviewQueue = <StudyHarmonyReviewQueuePlaceholderEntry>[
      for (final entry in _listOrEmpty(
        json['reviewQueueEntries'] ?? json['reviewQueuePlaceholders'],
      ))
        if (_mapOrNull(entry) case final nested?)
          StudyHarmonyReviewQueuePlaceholderEntry.fromJson(nested),
    ];
    final weeklyLeagueScores = <String, int>{};
    final weeklyLeagueJson = _mapOrNull(json['weeklyLeagueScores']);
    if (weeklyLeagueJson != null) {
      for (final entry in weeklyLeagueJson.entries) {
        weeklyLeagueScores[entry.key] = _intOrZero(entry.value);
      }
    }
    final monthlySpotlightClearCounts = <String, int>{};
    final monthlySpotlightJson = _mapOrNull(
      json['monthlySpotlightClearCounts'],
    );
    if (monthlySpotlightJson != null) {
      for (final entry in monthlySpotlightJson.entries) {
        monthlySpotlightClearCounts[entry.key] = _intOrZero(entry.value);
      }
    }
    final modeSessionCounts = _stringIntMapFromValue(json['modeSessionCounts']);
    final modeClearCounts = _stringIntMapFromValue(json['modeClearCounts']);
    final rewardCurrencyBalances = _stringIntMapFromValue(
      json['rewardCurrencyBalances'],
    );
    final equippedCosmeticIds = _stringListFromValue(
      json['equippedCosmeticIds'],
    );

    return StudyHarmonyProgressSnapshot(
      serializationVersion: _intOr(
        json['serializationVersion'],
        fallback: currentSerializationVersion,
      ),
      lastPlayedTrackId: _stringOrNull(json['lastPlayedTrackId']),
      lastPlayedChapterId: _stringOrNull(json['lastPlayedChapterId']),
      lastPlayedLessonId: _stringOrNull(json['lastPlayedLessonId']),
      unlockedChapterIds: _stringSetFromValue(json['unlockedChapterIds']),
      unlockedLessonIds: _stringSetFromValue(json['unlockedLessonIds']),
      lessonResults: lessonResults,
      skillMasteryPlaceholders: mastery,
      reviewQueuePlaceholders: reviewQueue,
      dailyChallengeSeedMetadata:
          StudyHarmonyDailyChallengeSeedMetadata.fromJsonValue(
            json['dailyChallengeSeedMetadata'],
          ),
      completedDailyChallengeDateKeys: _stringSetFromValue(
        json['completedDailyChallengeDateKeys'],
      ),
      protectedDailyChallengeDateKeys: _stringSetFromValue(
        json['protectedDailyChallengeDateKeys'],
      ),
      activityDateKeys: _stringSetFromValue(json['activityDateKeys']),
      completedFocusChallengeDateKeys: _stringSetFromValue(
        json['completedFocusChallengeDateKeys'],
      ),
      completedSpotlightChallengeDateKeys: _stringSetFromValue(
        json['completedSpotlightChallengeDateKeys'],
      ),
      completedFrontierQuestDateKeys: _stringSetFromValue(
        json['completedFrontierQuestDateKeys'],
      ),
      awardedWeeklyPlanWeekKeys: _stringSetFromValue(
        json['awardedWeeklyPlanWeekKeys'],
      ),
      awardedDailyQuestChestDateKeys: _stringSetFromValue(
        json['awardedDailyQuestChestDateKeys'],
      ),
      awardedMonthlyTourMonthKeys: _stringSetFromValue(
        json['awardedMonthlyTourMonthKeys'],
      ),
      weeklyLeagueScores: weeklyLeagueScores,
      monthlySpotlightClearCounts: monthlySpotlightClearCounts,
      modeSessionCounts: modeSessionCounts,
      modeClearCounts: modeClearCounts,
      rewardCurrencyBalances: rewardCurrencyBalances,
      rewardCurrencySpent: _intOrZero(json['rewardCurrencySpent']),
      shopPurchaseCount: _intOrZero(json['shopPurchaseCount']),
      purchasedUniqueShopItemIds: _stringSetFromValue(
        json['purchasedUniqueShopItemIds'],
      ),
      ownedTitleIds: _stringSetFromValue(json['ownedTitleIds']),
      ownedCosmeticIds: _stringSetFromValue(json['ownedCosmeticIds']),
      equippedTitleId: _stringOrNull(json['equippedTitleId']),
      equippedCosmeticIds: equippedCosmeticIds,
      bestSessionCombo: _intOrZero(json['bestSessionCombo']),
      legendaryChapterIds: _stringSetFromValue(json['legendaryChapterIds']),
      relayWinCount: _intOrZero(json['relayWinCount']),
      bestDailyChallengeStreak: _intOrZero(json['bestDailyChallengeStreak']),
      bestDuetPactStreak: _intOrZero(json['bestDuetPactStreak']),
      streakSaverCount: _intOrZero(json['streakSaverCount']),
      questChestCount: _intOrZero(json['questChestCount']),
      activeLeagueXpBoostDateKey: _stringOrNull(
        json['activeLeagueXpBoostDateKey'],
      ),
      activeLeagueXpBoostCharges: _intOrZero(
        json['activeLeagueXpBoostCharges'],
      ),
    );
  }

  static StudyHarmonyProgressSnapshot fromEncoded(String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      return StudyHarmonyProgressSnapshot.initial();
    }
    try {
      return fromJsonValue(jsonDecode(encoded));
    } on FormatException {
      return StudyHarmonyProgressSnapshot.initial();
    }
  }
}

enum StudyHarmonyChapterMasteryTier { none, bronze, silver, gold, legendary }

Map<String, Object?>? _mapOrNull(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    return {
      for (final entry in value.entries)
        if (entry.key is String) entry.key as String: entry.value,
    };
  }
  return null;
}

List<Object?> _listOrEmpty(Object? value) {
  if (value is List<Object?>) {
    return value;
  }
  if (value is List) {
    return List<Object?>.from(value);
  }
  return const <Object?>[];
}

Set<String> _stringSetFromValue(Object? value) {
  final ids = <String>{};
  for (final entry in _listOrEmpty(value)) {
    final id = _stringOrNull(entry);
    if (id != null) {
      ids.add(id);
    }
  }
  return ids;
}

List<String> _stringListFromValue(Object? value) {
  if (value is List<String>) {
    return value;
  }
  if (value is List) {
    return [
      for (final entry in value)
        if (entry is String) entry,
    ];
  }
  return const <String>[];
}

Map<String, int> _stringIntMapFromValue(Object? value) {
  final map = _mapOrNull(value);
  if (map == null) {
    return const <String, int>{};
  }
  return {for (final entry in map.entries) entry.key: _intOrZero(entry.value)};
}

String? _stringOrNull(Object? value) {
  return value is String ? value : null;
}

bool _boolOrFalse(Object? value) {
  return value is bool ? value : false;
}

int _intOrZero(Object? value) {
  return _intOr(value, fallback: 0);
}

int _intOr(Object? value, {required int fallback}) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return fallback;
}

double _doubleOrZero(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return 0;
}

double? _doubleOrNull(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

List<double> _doubleListOrEmpty(Object? value) {
  return [for (final entry in _listOrEmpty(value)) ?_doubleOrNull(entry)];
}
