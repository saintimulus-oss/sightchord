import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/meta/study_harmony_rewards_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reward catalog exposes stable id-based content', () {
    expect(studyHarmonyCurrencies.length, 5);
    expect(studyHarmonyAchievementCategories.length, 5);
    expect(studyHarmonyRewardBundles.length, greaterThanOrEqualTo(8));
    expect(studyHarmonyAchievements.length, greaterThanOrEqualTo(10));
    expect(studyHarmonyTitles.length, greaterThanOrEqualTo(8));
    expect(studyHarmonyCosmetics.length, greaterThanOrEqualTo(8));
    expect(studyHarmonyShopItems.length, greaterThanOrEqualTo(6));

    expect(
      studyHarmonyAchievements.map((item) => item.id).toSet().length,
      studyHarmonyAchievements.length,
    );
    expect(
      studyHarmonyTitles.map((item) => item.id).toSet().length,
      studyHarmonyTitles.length,
    );
    expect(
      studyHarmonyCosmetics.map((item) => item.id).toSet().length,
      studyHarmonyCosmetics.length,
    );
    expect(
      studyHarmonyShopItems.map((item) => item.id).toSet().length,
      studyHarmonyShopItems.length,
    );

    expect(studyHarmonyCurrenciesById['currency.starShard']?.isPremium, isTrue);
    expect(studyHarmonyAchievementCategoriesById['economy']?.order, 4);
    expect(
      studyHarmonyRewardBundlesById['bundle.achievement.legend_writer']
          ?.unlockIds,
      contains('title.legend_writer'),
    );
    expect(
      studyHarmonyShopItemsById['shop.aurora_frame_unlock']?.unlockIds,
      contains('cosmetic.frame.aurora'),
    );
  });

  test('progress metrics unlock titles, cosmetics, and achievements', () {
    final snapshot = _buildProgressSnapshot();
    final metrics = studyHarmonyRewardMetricsFromSnapshot(
      snapshot,
      reviewClears: 5,
      bossClears: 3,
      legendClears: 1,
      bestCombo: 15,
      totalStarsOverride: 120,
      bestSessionAccuracyOverride: 0.97,
      shopPurchases: 3,
      currencySpent: 500,
      modeSessionCounts: const {
        StudyHarmonySessionMode.review: 5,
        StudyHarmonySessionMode.daily: 4,
      },
      modeClearCounts: const {
        StudyHarmonySessionMode.review: 4,
        StudyHarmonySessionMode.daily: 4,
      },
    );

    expect(metrics.lessonClears, 2);
    expect(metrics.reviewClears, 5);
    expect(metrics.dailyClears, 4);
    expect(metrics.bestDailyStreak, 7);
    expect(metrics.totalStars, 120);
    expect(metrics.bestCombo, 15);
    expect(metrics.bestSessionAccuracy, 0.97);
    expect(metrics.shopPurchases, 3);
    expect(metrics.currencySpent, 500);

    final candidates = studyHarmonyRewardCandidatesForProgress(metrics);

    final firstStep = candidates.singleWhere(
      (candidate) => candidate.id == 'achievement.first_step',
    );
    expect(firstStep.unlocked, isTrue);

    final economySupporter = candidates.singleWhere(
      (candidate) => candidate.id == 'achievement.economy_supporter',
    );
    expect(economySupporter.unlocked, isTrue);

    final streakSage = candidates.singleWhere(
      (candidate) => candidate.id == 'title.streak_sage',
    );
    expect(streakSage.unlocked, isTrue);

    final savvyBuyer = candidates.singleWhere(
      (candidate) => candidate.id == 'title.savvy_buyer',
    );
    expect(savvyBuyer.unlocked, isTrue);

    final holoBadge = candidates.singleWhere(
      (candidate) => candidate.id == 'cosmetic.badge.holo',
    );
    expect(holoBadge.unlocked, isTrue);

    final stardustTrail = candidates.singleWhere(
      (candidate) => candidate.id == 'cosmetic.trail.stardust',
    );
    expect(stardustTrail.unlocked, isTrue);

    final legendWriter = candidates.singleWhere(
      (candidate) => candidate.id == 'achievement.legend_writer',
    );
    expect(legendWriter.unlocked, isTrue);

    final lessonMarathon = candidates.singleWhere(
      (candidate) => candidate.id == 'achievement.lesson_marathon',
    );
    expect(lessonMarathon.unlocked, isFalse);
    expect(lessonMarathon.progressFraction, lessThan(1));
  });

  test('session rewards scale with mode, accuracy, and combo', () {
    final lessonState = _buildSessionState(StudyHarmonySessionMode.lesson);
    final bossState = _buildSessionState(StudyHarmonySessionMode.bossRush);

    final lessonInput = studyHarmonySessionRewardInputFromState(
      lessonState,
      starsOverride: 3,
      streakOverride: 14,
      rankOverride: 'S',
    );
    final bossInput = studyHarmonySessionRewardInputFromState(
      bossState,
      starsOverride: 3,
      streakOverride: 14,
      rankOverride: 'S',
    );

    expect(lessonInput.isPerfectClear, isFalse);
    expect(bossInput.rank, 'S');

    final lessonBundles = studyHarmonySessionRewardBundles(lessonInput);
    final bossBundles = studyHarmonySessionRewardBundles(bossInput);

    expect(
      lessonBundles.map((bundle) => bundle.id),
      containsAll(<String>[
        'bundle.session.base',
        'bundle.session.precision',
        'bundle.session.combo',
        'bundle.session.mode',
        'bundle.session.mastery',
      ]),
    );
    expect(
      bossBundles.map((bundle) => bundle.id),
      containsAll(<String>[
        'bundle.session.base',
        'bundle.session.precision',
        'bundle.session.combo',
        'bundle.session.mode',
        'bundle.session.mastery',
      ]),
    );

    final lessonBase = _bundleById(lessonBundles, 'bundle.session.base');
    final bossBase = _bundleById(bossBundles, 'bundle.session.base');
    final lessonMode = _bundleById(lessonBundles, 'bundle.session.mode');
    final bossMode = _bundleById(bossBundles, 'bundle.session.mode');
    final lessonPrecision = _bundleById(
      lessonBundles,
      'bundle.session.precision',
    );
    final bossCombo = _bundleById(bossBundles, 'bundle.session.combo');

    expect(
      _currencyAmount(lessonBase, 'currency.studyCoin'),
      lessThan(_currencyAmount(bossBase, 'currency.studyCoin')),
    );
    expect(
      _currencyAmount(lessonMode, 'currency.studyCoin'),
      lessThan(_currencyAmount(bossMode, 'currency.studyCoin')),
    );
    expect(_currencyAmount(lessonPrecision, 'currency.starShard'), 2);
    expect(_currencyAmount(bossCombo, 'currency.focusToken'), 2);
  });

  test('merged session metrics feed back into progress candidates', () {
    final snapshot = _buildProgressSnapshot();
    final progress = studyHarmonyRewardMetricsFromSnapshot(
      snapshot,
      reviewClears: 2,
      bestCombo: 8,
      totalStarsOverride: 45,
    );
    final session = studyHarmonySessionRewardInputFromState(
      _buildSessionState(StudyHarmonySessionMode.review),
      starsOverride: 2,
      streakOverride: 11,
      rankOverride: 'A',
    );

    final merged = studyHarmonyMergedRewardMetrics(
      progress: progress,
      session: session,
    );

    expect(merged.reviewClears, 3);
    expect(merged.totalStars, 47);
    expect(merged.bestCombo, 14);
    expect(merged.modeSessionCounts[StudyHarmonySessionMode.review], 1);
    expect(merged.modeClearCounts[StudyHarmonySessionMode.review], 1);

    final candidates = studyHarmonyRewardCandidatesForSession(
      session: session,
      progress: progress,
    );
    final reviewScholar = candidates.singleWhere(
      (candidate) => candidate.id == 'achievement.review_scholar',
    );
    expect(reviewScholar.unlocked, isFalse);
    expect(reviewScholar.progressFraction, lessThan(1));
  });
}

StudyHarmonyProgressSnapshot _buildProgressSnapshot() {
  return StudyHarmonyProgressSnapshot(
    serializationVersion:
        StudyHarmonyProgressSnapshot.currentSerializationVersion,
    lessonResults: const {
      'lesson-1': StudyHarmonyLessonProgressSummary(
        lessonId: 'lesson-1',
        isCleared: true,
        bestAccuracy: 0.91,
        bestAttemptCount: 2,
        bestStars: 2,
        bestRank: 'A',
        bestElapsedMillis: 40000,
        playCount: 3,
        lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
      ),
      'lesson-2': StudyHarmonyLessonProgressSummary(
        lessonId: 'lesson-2',
        isCleared: true,
        bestAccuracy: 0.84,
        bestAttemptCount: 3,
        bestStars: 1,
        bestRank: 'B',
        bestElapsedMillis: 52000,
        playCount: 2,
        lastPlayedAtIso8601: '2026-03-13T00:00:00.000Z',
      ),
      'lesson-3': StudyHarmonyLessonProgressSummary(
        lessonId: 'lesson-3',
        isCleared: false,
        bestAccuracy: 0.4,
        bestAttemptCount: 4,
        bestStars: 0,
        bestRank: 'C',
        bestElapsedMillis: 62000,
        playCount: 1,
        lastPlayedAtIso8601: '2026-03-14T00:00:00.000Z',
      ),
    },
    completedDailyChallengeDateKeys: const {
      '2026-03-07',
      '2026-03-08',
      '2026-03-09',
      '2026-03-10',
    },
    completedFocusChallengeDateKeys: const {'2026-03-10'},
    completedSpotlightChallengeDateKeys: const {'2026-03-11'},
    completedFrontierQuestDateKeys: const {'2026-03-12'},
    awardedWeeklyPlanWeekKeys: const {'2026-03-10'},
    awardedDailyQuestChestDateKeys: const {'2026-03-13'},
    awardedMonthlyTourMonthKeys: const {'2026-03'},
    activityDateKeys: const {
      '2026-03-07',
      '2026-03-08',
      '2026-03-09',
      '2026-03-10',
      '2026-03-11',
    },
    legendaryChapterIds: const {'legendary-chapter-1'},
    relayWinCount: 5,
    bestDailyChallengeStreak: 7,
    bestDuetPactStreak: 4,
    streakSaverCount: 2,
    questChestCount: 3,
    activeLeagueXpBoostDateKey: '2026-03-13',
    activeLeagueXpBoostCharges: 1,
  );
}

StudyHarmonySessionState _buildSessionState(StudyHarmonySessionMode mode) {
  final lesson = StudyHarmonyLessonDefinition(
    id: 'lesson-${mode.name}',
    chapterId: 'chapter-1',
    title: 'Mode ${mode.name}',
    description: 'Test lesson',
    objectiveLabel: 'Objective',
    goalCorrectAnswers: 10,
    startingLives: 3,
    sessionMode: mode,
    tasks: const <StudyHarmonyTaskBlueprint>[],
  );

  return StudyHarmonySessionState(
    mode: mode,
    lesson: lesson,
    phase: StudyHarmonySessionPhase.completed,
    livesRemaining: 2,
    correctAnswers: 9,
    attempts: 10,
    currentCombo: 14,
    bestCombo: 14,
    elapsed: const Duration(seconds: 42),
  );
}

StudyHarmonyRewardBundleDefinition _bundleById(
  List<StudyHarmonyRewardBundleDefinition> bundles,
  String id,
) {
  return bundles.singleWhere((bundle) => bundle.id == id);
}

int _currencyAmount(
  StudyHarmonyRewardBundleDefinition bundle,
  String currencyId,
) {
  return bundle.grants
      .where((grant) => grant.currencyId == currencyId)
      .fold<int>(0, (sum, grant) => sum + grant.amount);
}
