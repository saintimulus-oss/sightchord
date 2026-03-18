import 'package:flutter/foundation.dart';

import '../domain/study_harmony_progress_models.dart';

typedef StudyHarmonyArcadeModeId = String;
typedef StudyHarmonyArcadePlaylistId = String;

enum StudyHarmonyArcadeEntryType { mode, event }

enum StudyHarmonyArcadeRiskStyle { forgiving, balanced, tense, punishing }

enum StudyHarmonyArcadeRewardStyle {
  currency,
  cosmetic,
  title,
  trophy,
  bundle,
  prestige,
}

enum StudyHarmonyArcadeDifficultyTier {
  onboarding,
  warmup,
  standard,
  intense,
  expert,
}

enum StudyHarmonyArcadeUnlockKind {
  always,
  completedLessonsAtLeast,
  averageAccuracyAtLeast,
  bestAccuracyAtLeast,
  currentStreakAtLeast,
  sRanksAtLeast,
  perfectRunsAtLeast,
  reviewQueueAtLeast,
  bossClearsAtLeast,
  chapterClearsAtLeast,
  playCountAtLeast,
}

@immutable
class StudyHarmonyArcadeUnlockRule {
  const StudyHarmonyArcadeUnlockRule({
    required this.kind,
    required this.label,
    this.threshold = 0,
  });

  final StudyHarmonyArcadeUnlockKind kind;
  final String label;
  final int threshold;

  bool isMet(StudyHarmonyArcadeProgressSummary progress) {
    return switch (kind) {
      StudyHarmonyArcadeUnlockKind.always => true,
      StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast =>
        progress.completedLessons >= threshold,
      StudyHarmonyArcadeUnlockKind.averageAccuracyAtLeast =>
        progress.averageAccuracy >= (threshold / 100),
      StudyHarmonyArcadeUnlockKind.bestAccuracyAtLeast =>
        progress.bestAccuracy >= (threshold / 100),
      StudyHarmonyArcadeUnlockKind.currentStreakAtLeast =>
        progress.currentStreak >= threshold,
      StudyHarmonyArcadeUnlockKind.sRanksAtLeast =>
        progress.sRanks >= threshold,
      StudyHarmonyArcadeUnlockKind.perfectRunsAtLeast =>
        progress.perfectRuns >= threshold,
      StudyHarmonyArcadeUnlockKind.reviewQueueAtLeast =>
        progress.reviewQueueSize >= threshold,
      StudyHarmonyArcadeUnlockKind.bossClearsAtLeast =>
        progress.bossClears >= threshold,
      StudyHarmonyArcadeUnlockKind.chapterClearsAtLeast =>
        progress.chapterClears >= threshold,
      StudyHarmonyArcadeUnlockKind.playCountAtLeast =>
        progress.playCount >= threshold,
    };
  }
}

@immutable
class StudyHarmonyArcadeProgressSummary {
  const StudyHarmonyArcadeProgressSummary({
    required this.totalLessons,
    required this.completedLessons,
    required this.averageAccuracy,
    required this.bestAccuracy,
    required this.sRanks,
    required this.perfectRuns,
    required this.currentStreak,
    required this.reviewQueueSize,
    required this.chapterClears,
    required this.bossClears,
    required this.playCount,
  });

  final int totalLessons;
  final int completedLessons;
  final double averageAccuracy;
  final double bestAccuracy;
  final int sRanks;
  final int perfectRuns;
  final int currentStreak;
  final int reviewQueueSize;
  final int chapterClears;
  final int bossClears;
  final int playCount;

  double get completionRate =>
      totalLessons <= 0 ? 0 : completedLessons / totalLessons;

  bool get isWarmStart => completedLessons < 5;

  bool get isHighAccuracy => averageAccuracy >= 0.82;

  bool get isBossReady => bestAccuracy >= 0.9 || sRanks >= 2;

  bool get isStreaking => currentStreak >= 3;

  factory StudyHarmonyArcadeProgressSummary.fromLessonSummaries(
    Iterable<StudyHarmonyLessonProgressSummary> lessons, {
    int totalLessons = 0,
    int reviewQueueSize = 0,
    int chapterClears = 0,
    int bossClears = 0,
    int currentStreak = 0,
  }) {
    final lessonList = lessons.toList(growable: false);
    final completedLessons = lessonList
        .where((lesson) => lesson.isCleared)
        .length;
    final accuracySamples = [
      for (final lesson in lessonList)
        if (lesson.playCount > 0) lesson.bestAccuracy,
    ];
    final averageAccuracy = _average(accuracySamples);
    final bestAccuracy = lessonList.fold<double>(
      0,
      (current, lesson) =>
          lesson.bestAccuracy > current ? lesson.bestAccuracy : current,
    );
    final sRanks = lessonList
        .where((lesson) => lesson.bestRank.toUpperCase() == 'S')
        .length;
    final perfectRuns = lessonList
        .where((lesson) => lesson.bestStars >= 3)
        .length;
    final playCount = lessonList.fold<int>(
      0,
      (sum, lesson) => sum + lesson.playCount,
    );

    return StudyHarmonyArcadeProgressSummary(
      totalLessons: totalLessons == 0 ? lessonList.length : totalLessons,
      completedLessons: completedLessons,
      averageAccuracy: averageAccuracy,
      bestAccuracy: bestAccuracy,
      sRanks: sRanks,
      perfectRuns: perfectRuns,
      currentStreak: currentStreak,
      reviewQueueSize: reviewQueueSize,
      chapterClears: chapterClears,
      bossClears: bossClears,
      playCount: playCount,
    );
  }
}

StudyHarmonyArcadeProgressSummary summarizeStudyHarmonyArcadeProgress(
  Iterable<StudyHarmonyLessonProgressSummary> lessons, {
  int totalLessons = 0,
  int reviewQueueSize = 0,
  int chapterClears = 0,
  int bossClears = 0,
  int currentStreak = 0,
}) {
  return StudyHarmonyArcadeProgressSummary.fromLessonSummaries(
    lessons,
    totalLessons: totalLessons,
    reviewQueueSize: reviewQueueSize,
    chapterClears: chapterClears,
    bossClears: bossClears,
    currentStreak: currentStreak,
  );
}

@immutable
class StudyHarmonyArcadeModeDefinition {
  const StudyHarmonyArcadeModeDefinition({
    required this.id,
    required this.entryType,
    required this.title,
    required this.subtitle,
    required this.fantasy,
    required this.shortLoop,
    required this.riskStyle,
    required this.rewardStyle,
    required this.difficultyTier,
    required this.unlockRules,
    required this.recommendationReasons,
    required this.playlists,
    this.spotlight = false,
  });

  final StudyHarmonyArcadeModeId id;
  final StudyHarmonyArcadeEntryType entryType;
  final String title;
  final String subtitle;
  final String fantasy;
  final String shortLoop;
  final StudyHarmonyArcadeRiskStyle riskStyle;
  final StudyHarmonyArcadeRewardStyle rewardStyle;
  final StudyHarmonyArcadeDifficultyTier difficultyTier;
  final List<StudyHarmonyArcadeUnlockRule> unlockRules;
  final List<String> recommendationReasons;
  final List<StudyHarmonyArcadePlaylistId> playlists;
  final bool spotlight;

  List<String> get unlockConditionLabels =>
      unlockRules.map((rule) => rule.label).toList(growable: false);

  bool isUnlocked(StudyHarmonyArcadeProgressSummary progress) {
    return unlockRules.every((rule) => rule.isMet(progress));
  }

  String unlockSummary() {
    return unlockConditionLabels.join(' ');
  }

  int scoreFor(StudyHarmonyArcadeProgressSummary progress) {
    if (!isUnlocked(progress)) {
      return 0;
    }

    final completionBonus = (progress.completionRate * 20).round();

    return switch (id) {
      'neon-sprint' =>
        70 +
            _scoreFromRange(progress.averageAccuracy, 0.55, 0.85, 30) +
            _scoreFromInverse(progress.currentStreak.toDouble(), 0, 4, 12) +
            _scoreFromInverse(progress.reviewQueueSize.toDouble(), 0, 4, 8) +
            completionBonus,
      'ghost-relay' =>
        55 +
            _scoreFromRange(progress.averageAccuracy, 0.68, 0.95, 34) +
            (progress.perfectRuns * 6) +
            (progress.chapterClears * 2) +
            completionBonus,
      'vault-break' =>
        50 +
            (progress.reviewQueueSize * 6) +
            (progress.completedLessons * 2) +
            _scoreFromRange(progress.bestAccuracy, 0.6, 0.92, 14) +
            completionBonus,
      'remix-fever' =>
        58 +
            (progress.completedLessons * 2) +
            (progress.sRanks * 3) +
            _scoreFromRange(progress.averageAccuracy, 0.62, 0.9, 18) +
            completionBonus,
      'boss-rush' =>
        48 +
            (progress.sRanks * 10) +
            (progress.perfectRuns * 8) +
            _scoreFromRange(progress.bestAccuracy, 0.82, 0.97, 26) +
            (progress.currentStreak * 3),
      'crown-loop' =>
        44 +
            (progress.sRanks * 12) +
            (progress.perfectRuns * 12) +
            _scoreFromRange(progress.bestAccuracy, 0.88, 0.99, 20) +
            (progress.chapterClears * 3),
      'duel-stage' =>
        46 +
            (progress.playCount * 2) +
            _scoreFromRange(progress.averageAccuracy, 0.6, 0.88, 20) +
            (progress.currentStreak * 4) +
            completionBonus,
      'night-market' =>
        62 +
            (progress.reviewQueueSize * 7) +
            (progress.completedLessons * 2) +
            _scoreFromInverse(progress.bestAccuracy, 0.6, 0.92, 10) +
            completionBonus,
      _ => 40 + completionBonus,
    };
  }

  String recommendationCueFor(StudyHarmonyArcadeProgressSummary progress) {
    if (!isUnlocked(progress)) {
      return 'Unlocks once the gate conditions are met.';
    }

    return switch (id) {
      'neon-sprint' =>
        progress.isWarmStart
            ? 'Perfect if you want a fast, forgiving burst.'
            : 'Great for converting clean accuracy into a combo streak.',
      'ghost-relay' =>
        progress.isHighAccuracy
            ? 'Race your own best form through a clean echo run.'
            : 'Best after you have a few settled clears.',
      'vault-break' =>
        progress.reviewQueueSize > 0
            ? 'Turns weak spots into loot while the vault is open.'
            : 'A high-value hunt when you want hidden rewards.',
      'remix-fever' =>
        progress.currentStreak >= 2
            ? 'Keeps the pressure playful with random modifiers.'
            : 'Good when you want variety without losing momentum.',
      'boss-rush' =>
        progress.isBossReady
            ? 'Push here when you want a serious test of nerve.'
            : 'Earn the right to enter, then cash in on prestige.',
      'crown-loop' =>
        progress.sRanks >= 2
            ? 'Endurance mode for players chasing mastery crowns.'
            : 'A marathon that rewards precision and patience.',
      'duel-stage' =>
        progress.playCount >= 12
            ? 'Feels like a ladder match against your own ghosts.'
            : 'Best when you want a competitive pace without multiplayer.',
      'night-market' =>
        progress.reviewQueueSize >= 3
            ? 'The shop opens wider when you feed it weak spots.'
            : 'A flexible event for collecting currency and rare items.',
      _ => recommendationReasons.first,
    };
  }
}

@immutable
class StudyHarmonyArcadePlaylistDefinition {
  const StudyHarmonyArcadePlaylistDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fantasy,
    required this.modeIds,
    required this.recommendationCue,
    this.spotlight = false,
  });

  final StudyHarmonyArcadePlaylistId id;
  final String title;
  final String subtitle;
  final String fantasy;
  final List<StudyHarmonyArcadeModeId> modeIds;
  final String recommendationCue;
  final bool spotlight;
}

@immutable
class StudyHarmonyArcadeFeaturedMode {
  const StudyHarmonyArcadeFeaturedMode({
    required this.mode,
    required this.score,
    required this.cue,
  });

  final StudyHarmonyArcadeModeDefinition mode;
  final int score;
  final String cue;
}

@immutable
class StudyHarmonyArcadeFeaturedPlaylist {
  const StudyHarmonyArcadeFeaturedPlaylist({
    required this.playlist,
    required this.score,
    required this.cue,
  });

  final StudyHarmonyArcadePlaylistDefinition playlist;
  final int score;
  final String cue;
}

const List<StudyHarmonyArcadeModeDefinition> studyHarmonyArcadeModeCatalog = [
  StudyHarmonyArcadeModeDefinition(
    id: 'neon-sprint',
    entryType: StudyHarmonyArcadeEntryType.mode,
    title: 'Neon Sprint',
    subtitle: 'A 90-second combo lane where every hit keeps the reactor lit.',
    fantasy: 'Run the city lights and keep the rhythm engine glowing.',
    shortLoop: 'Clear tiny bursts, extend the combo, and bank quick rewards.',
    riskStyle: StudyHarmonyArcadeRiskStyle.forgiving,
    rewardStyle: StudyHarmonyArcadeRewardStyle.currency,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.onboarding,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.always,
        label: 'Always available.',
      ),
    ],
    recommendationReasons: [
      'Best for warm-up sessions and low-friction momentum.',
      'Strong fit for players who want a fast first win.',
    ],
    playlists: ['after-dark', 'street-league'],
    spotlight: true,
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'ghost-relay',
    entryType: StudyHarmonyArcadeEntryType.mode,
    title: 'Ghost Relay',
    subtitle: 'Race your last clean run through a chain of echo checkpoints.',
    fantasy: 'Chase the ghost of your own best performance.',
    shortLoop: 'Chain a sequence, tag the ghost, and beat your previous tempo.',
    riskStyle: StudyHarmonyArcadeRiskStyle.balanced,
    rewardStyle: StudyHarmonyArcadeRewardStyle.title,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.standard,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast,
        label: 'Clear at least 4 lessons.',
        threshold: 4,
      ),
    ],
    recommendationReasons: [
      'Ideal when accuracy is already steady and you want a pace challenge.',
      'Turns personal bests into the main opponent.',
    ],
    playlists: ['after-dark', 'street-league'],
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'vault-break',
    entryType: StudyHarmonyArcadeEntryType.event,
    title: 'Vault Break',
    subtitle: 'Crack hidden chord vaults by solving pressure rooms cleanly.',
    fantasy: 'Break into a sealed harmony archive and leave with rare loot.',
    shortLoop: 'Solve a room, crack the lock, reveal the next vault layer.',
    riskStyle: StudyHarmonyArcadeRiskStyle.tense,
    rewardStyle: StudyHarmonyArcadeRewardStyle.cosmetic,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.intense,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast,
        label: 'Clear at least 8 lessons.',
        threshold: 8,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.averageAccuracyAtLeast,
        label: 'Maintain 68% average accuracy.',
        threshold: 68,
      ),
    ],
    recommendationReasons: [
      'Great for players who want to turn weak spots into collectible rewards.',
      'Fits a pressure-first loop with visible payoff.',
    ],
    playlists: ['vault-run', 'night-market'],
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'remix-fever',
    entryType: StudyHarmonyArcadeEntryType.event,
    title: 'Remix Fever',
    subtitle: 'A modifier storm that reshuffles the rules every round.',
    fantasy:
        'The stage changes under your feet and the crowd wants improvisation.',
    shortLoop: 'Beat the current remix, then roll a stranger one.',
    riskStyle: StudyHarmonyArcadeRiskStyle.balanced,
    rewardStyle: StudyHarmonyArcadeRewardStyle.bundle,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.standard,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast,
        label: 'Clear at least 6 lessons.',
        threshold: 6,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.currentStreakAtLeast,
        label: 'Hold a 2-day streak.',
        threshold: 2,
      ),
    ],
    recommendationReasons: [
      'Best when you want variety without losing the session loop.',
      'Keeps the experience fresh for players who like surprise.',
    ],
    playlists: ['after-dark', 'vault-run'],
    spotlight: true,
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'boss-rush',
    entryType: StudyHarmonyArcadeEntryType.mode,
    title: 'Boss Rush',
    subtitle: 'Few hearts, high stakes, and a reward chest at the end.',
    fantasy: 'Take on a stacked gauntlet of final-form harmony bosses.',
    shortLoop:
        'Face a chain of bosses, spend lives carefully, and cash out prestige.',
    riskStyle: StudyHarmonyArcadeRiskStyle.punishing,
    rewardStyle: StudyHarmonyArcadeRewardStyle.prestige,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.expert,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.sRanksAtLeast,
        label: 'Earn at least 2 S ranks.',
        threshold: 2,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.perfectRunsAtLeast,
        label: 'Record at least 1 perfect run.',
        threshold: 1,
      ),
    ],
    recommendationReasons: [
      'For players who want the most serious test in the arcade.',
      'Biggest tension, biggest bragging rights.',
    ],
    playlists: ['boss-ladder'],
    spotlight: true,
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'crown-loop',
    entryType: StudyHarmonyArcadeEntryType.mode,
    title: 'Crown Loop',
    subtitle: 'A marathon lane that keeps stacking mastery crowns.',
    fantasy:
        'Circle through a ceremonial loop where only polished runs survive.',
    shortLoop: 'Loop the track, protect the crown, and keep the chain alive.',
    riskStyle: StudyHarmonyArcadeRiskStyle.tense,
    rewardStyle: StudyHarmonyArcadeRewardStyle.trophy,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.intense,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.sRanksAtLeast,
        label: 'Earn at least 5 S ranks.',
        threshold: 5,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.perfectRunsAtLeast,
        label: 'Record at least 2 perfect runs.',
        threshold: 2,
      ),
    ],
    recommendationReasons: [
      'Best for mastery chasers who want endurance instead of bursts.',
      'A strong fit when consistency is already the player superpower.',
    ],
    playlists: ['boss-ladder'],
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'duel-stage',
    entryType: StudyHarmonyArcadeEntryType.mode,
    title: 'Duel Stage',
    subtitle: 'A solo ladder match against your own ghost roster.',
    fantasy: 'Step into a spotlight duel where every answer feeds the crowd.',
    shortLoop: 'Beat one ghost, then climb into the next, harder mirror fight.',
    riskStyle: StudyHarmonyArcadeRiskStyle.balanced,
    rewardStyle: StudyHarmonyArcadeRewardStyle.currency,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.standard,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast,
        label: 'Clear at least 10 lessons.',
        threshold: 10,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.averageAccuracyAtLeast,
        label: 'Maintain 70% average accuracy.',
        threshold: 70,
      ),
    ],
    recommendationReasons: [
      'Feels like a ladder match without needing real multiplayer.',
      'Good for players who enjoy competition and visible ascent.',
    ],
    playlists: ['street-league', 'vault-run'],
  ),
  StudyHarmonyArcadeModeDefinition(
    id: 'night-market',
    entryType: StudyHarmonyArcadeEntryType.event,
    title: 'Night Market',
    subtitle: 'A rotating shop run where clears unlock rarer stock.',
    fantasy: 'Trade musical momentum for strange, stylish rewards.',
    shortLoop: 'Win runs, earn coins, and decide whether to buy or save.',
    riskStyle: StudyHarmonyArcadeRiskStyle.forgiving,
    rewardStyle: StudyHarmonyArcadeRewardStyle.bundle,
    difficultyTier: StudyHarmonyArcadeDifficultyTier.warmup,
    unlockRules: [
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast,
        label: 'Clear at least 3 lessons.',
        threshold: 3,
      ),
      StudyHarmonyArcadeUnlockRule(
        kind: StudyHarmonyArcadeUnlockKind.chapterClearsAtLeast,
        label: 'Clear at least 1 chapter.',
        threshold: 1,
      ),
    ],
    recommendationReasons: [
      'Excellent when you want rewards, not punishment.',
      'Pairs well with players who like collecting and customizing.',
    ],
    playlists: ['night-market', 'vault-run'],
    spotlight: true,
  ),
];

const List<StudyHarmonyArcadePlaylistDefinition>
studyHarmonyArcadePlaylistCatalog = [
  StudyHarmonyArcadePlaylistDefinition(
    id: 'after-dark',
    title: 'After Dark Set',
    subtitle: 'Short, flashy runs for players who want momentum first.',
    fantasy: 'A late-night neon block party of fast clears and wild remixes.',
    modeIds: ['neon-sprint', 'ghost-relay', 'remix-fever'],
    recommendationCue: 'Great for warm-ups, streak building, and fast retries.',
    spotlight: true,
  ),
  StudyHarmonyArcadePlaylistDefinition(
    id: 'vault-run',
    title: 'Vault Run',
    subtitle: 'Loot-heavy routes with hidden rewards and modifier pressure.',
    fantasy: 'Break open sealed rooms and leave with style items.',
    modeIds: ['vault-break', 'remix-fever', 'duel-stage', 'night-market'],
    recommendationCue: 'Best when you want rewards to feel earned.',
  ),
  StudyHarmonyArcadePlaylistDefinition(
    id: 'boss-ladder',
    title: 'Boss Ladder',
    subtitle: 'Precision climb for players ready to risk lives for prestige.',
    fantasy: 'Scale a tower of bosses and keep your crown intact.',
    modeIds: ['boss-rush', 'crown-loop'],
    recommendationCue:
        'Use this when accuracy is stable and tension sounds fun.',
    spotlight: true,
  ),
  StudyHarmonyArcadePlaylistDefinition(
    id: 'street-league',
    title: 'Street League',
    subtitle: 'Friendly competition lanes with ghost races and ladder climbs.',
    fantasy: 'A solo esports circuit where your best run is your opponent.',
    modeIds: ['duel-stage', 'ghost-relay', 'neon-sprint'],
    recommendationCue: 'Great for players who like progress to feel public.',
  ),
];

StudyHarmonyArcadeModeDefinition? studyHarmonyArcadeModeById(
  StudyHarmonyArcadeModeId id,
) {
  for (final mode in studyHarmonyArcadeModeCatalog) {
    if (mode.id == id) {
      return mode;
    }
  }
  return null;
}

StudyHarmonyArcadePlaylistDefinition? studyHarmonyArcadePlaylistById(
  StudyHarmonyArcadePlaylistId id,
) {
  for (final playlist in studyHarmonyArcadePlaylistCatalog) {
    if (playlist.id == id) {
      return playlist;
    }
  }
  return null;
}

List<StudyHarmonyArcadeFeaturedMode> buildStudyHarmonyFeaturedArcadeModeCards(
  StudyHarmonyArcadeProgressSummary progress, {
  int limit = 4,
}) {
  final featured = _buildFeaturedModeCards(progress);
  return featured.take(limit).toList(growable: false);
}

List<StudyHarmonyArcadeModeDefinition> buildStudyHarmonyFeaturedArcadeModes(
  StudyHarmonyArcadeProgressSummary progress, {
  int limit = 4,
}) {
  return buildStudyHarmonyFeaturedArcadeModeCards(
    progress,
    limit: limit,
  ).map((entry) => entry.mode).toList(growable: false);
}

List<StudyHarmonyArcadeFeaturedMode>
buildStudyHarmonyFeaturedArcadeModeCardsFromLessonSummaries(
  Iterable<StudyHarmonyLessonProgressSummary> lessons, {
  int totalLessons = 0,
  int reviewQueueSize = 0,
  int chapterClears = 0,
  int bossClears = 0,
  int currentStreak = 0,
  int limit = 4,
}) {
  final progress = summarizeStudyHarmonyArcadeProgress(
    lessons,
    totalLessons: totalLessons,
    reviewQueueSize: reviewQueueSize,
    chapterClears: chapterClears,
    bossClears: bossClears,
    currentStreak: currentStreak,
  );
  return buildStudyHarmonyFeaturedArcadeModeCards(progress, limit: limit);
}

List<StudyHarmonyArcadeModeDefinition>
buildStudyHarmonyFeaturedArcadeModesFromLessonSummaries(
  Iterable<StudyHarmonyLessonProgressSummary> lessons, {
  int totalLessons = 0,
  int reviewQueueSize = 0,
  int chapterClears = 0,
  int bossClears = 0,
  int currentStreak = 0,
  int limit = 4,
}) {
  return buildStudyHarmonyFeaturedArcadeModeCardsFromLessonSummaries(
    lessons,
    totalLessons: totalLessons,
    reviewQueueSize: reviewQueueSize,
    chapterClears: chapterClears,
    bossClears: bossClears,
    currentStreak: currentStreak,
    limit: limit,
  ).map((entry) => entry.mode).toList(growable: false);
}

List<StudyHarmonyArcadeFeaturedPlaylist>
buildStudyHarmonyFeaturedArcadePlaylists(
  StudyHarmonyArcadeProgressSummary progress, {
  int limit = 2,
}) {
  final featured =
      [
        for (final playlist in studyHarmonyArcadePlaylistCatalog)
          if (playlist.modeIds.any(
            (modeId) =>
                studyHarmonyArcadeModeById(modeId)?.isUnlocked(progress) ??
                false,
          ))
            StudyHarmonyArcadeFeaturedPlaylist(
              playlist: playlist,
              score: _playlistScore(playlist, progress),
              cue: playlist.recommendationCue,
            ),
      ]..sort((left, right) {
        final byScore = right.score.compareTo(left.score);
        if (byScore != 0) {
          return byScore;
        }
        final bySpotlight = (right.playlist.spotlight ? 1 : 0).compareTo(
          left.playlist.spotlight ? 1 : 0,
        );
        if (bySpotlight != 0) {
          return bySpotlight;
        }
        return left.playlist.title.compareTo(right.playlist.title);
      });

  return featured.take(limit).toList(growable: false);
}

List<StudyHarmonyArcadePlaylistDefinition>
buildStudyHarmonyFeaturedArcadePlaylistDefinitions(
  StudyHarmonyArcadeProgressSummary progress, {
  int limit = 2,
}) {
  return buildStudyHarmonyFeaturedArcadePlaylists(
    progress,
    limit: limit,
  ).map((entry) => entry.playlist).toList(growable: false);
}

List<StudyHarmonyArcadeFeaturedMode> _buildFeaturedModeCards(
  StudyHarmonyArcadeProgressSummary progress,
) {
  final featured =
      [
        for (final mode in studyHarmonyArcadeModeCatalog)
          if (mode.isUnlocked(progress))
            StudyHarmonyArcadeFeaturedMode(
              mode: mode,
              score: mode.scoreFor(progress),
              cue: mode.recommendationCueFor(progress),
            ),
      ]..sort((left, right) {
        final byScore = right.score.compareTo(left.score);
        if (byScore != 0) {
          return byScore;
        }
        final bySpotlight = (right.mode.spotlight ? 1 : 0).compareTo(
          left.mode.spotlight ? 1 : 0,
        );
        if (bySpotlight != 0) {
          return bySpotlight;
        }
        return left.mode.title.compareTo(right.mode.title);
      });

  return featured;
}

int _playlistScore(
  StudyHarmonyArcadePlaylistDefinition playlist,
  StudyHarmonyArcadeProgressSummary progress,
) {
  var score = 0;
  for (final modeId in playlist.modeIds) {
    final mode = studyHarmonyArcadeModeById(modeId);
    if (mode == null) {
      continue;
    }
    score += mode.scoreFor(progress);
  }
  return score;
}

int _scoreFromRange(double value, double lower, double upper, int maxScore) {
  if (value.isNaN) {
    return 0;
  }
  if (value <= lower) {
    return 0;
  }
  if (value >= upper) {
    return maxScore;
  }
  final span = upper - lower;
  if (span <= 0) {
    return maxScore;
  }
  return (((value - lower) / span) * maxScore).round();
}

int _scoreFromInverse(double value, double lower, double upper, int maxScore) {
  if (upper <= lower) {
    return 0;
  }
  if (value <= lower) {
    return maxScore;
  }
  if (value >= upper) {
    return 0;
  }
  final span = upper - lower;
  return ((1 - ((value - lower) / span)) * maxScore).round();
}

double _average(List<double> values) {
  if (values.isEmpty) {
    return 0;
  }
  var total = 0.0;
  for (final value in values) {
    total += value;
  }
  return total / values.length;
}
