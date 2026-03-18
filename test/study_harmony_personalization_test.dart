import 'package:chordest/study_harmony/meta/study_harmony_personalization.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'competitive expert profiles lean into high-stakes modes and rewards',
    () {
      final profile = StudyHarmonyPersonalizationProfile(
        ageBand: StudyHarmonyAgeBand.youngAdult,
        skillBand: StudyHarmonySkillBand.expert,
        playStyle: StudyHarmonyPlayStyle.competitor,
        sessionLengthPreference: StudyHarmonySessionLengthPreference.marathon,
        regionFlavor: StudyHarmonyRegionFlavor.northAmerica,
        gameplayAffinity: const StudyHarmonyGameplayAffinity(
          competition: 0.95,
          collection: 0.25,
          exploration: 0.3,
          stability: 0.2,
        ),
      );
      final recentPerformance = const StudyHarmonyRecentPerformance(
        averageAccuracy: 0.94,
        clearRate: 0.9,
        masteryMomentum: 0.92,
        confidence: 0.91,
        recoveryNeed: 0.1,
        lessonResultCount: 18,
        activeDayCount: 12,
        reviewQueueCount: 1,
        weakSpotCount: 1,
        bestStreakCount: 8,
      );

      final plan = personalizeStudyHarmony(
        profile: profile,
        recentPerformance: recentPerformance,
      );

      expect(plan.effectiveSkillBand, StudyHarmonySkillBand.expert);
      expect(plan.coachStyle, StudyHarmonyCoachStyle.challengeForward);
      expect(
        plan.rewardEmphasis.primaryFocus,
        StudyHarmonyRewardFocus.achievements,
      );
      expect(
        plan.preferredEventRotation.first,
        StudyHarmonySessionMode.bossRush,
      );
      expect(plan.challengeAggression, greaterThan(0.8));
      expect(plan.tone, StudyHarmonyToneStyle.focused);
    },
  );

  test(
    'low-confidence users get guided onboarding and recovery-first routing',
    () {
      final profile = StudyHarmonyPersonalizationProfile(
        ageBand: StudyHarmonyAgeBand.teen,
        skillBand: StudyHarmonySkillBand.newcomer,
        playStyle: StudyHarmonyPlayStyle.stabilizer,
        sessionLengthPreference: StudyHarmonySessionLengthPreference.micro,
        regionFlavor: StudyHarmonyRegionFlavor.global,
        gameplayAffinity: const StudyHarmonyGameplayAffinity(
          competition: 0.2,
          collection: 0.3,
          exploration: 0.25,
          stability: 0.95,
        ),
      );
      final recentPerformance = const StudyHarmonyRecentPerformance(
        averageAccuracy: 0.22,
        clearRate: 0.12,
        masteryMomentum: 0.18,
        confidence: 0.16,
        recoveryNeed: 0.9,
        lessonResultCount: 5,
        activeDayCount: 2,
        reviewQueueCount: 4,
        weakSpotCount: 6,
        bestStreakCount: 1,
      );

      final plan = personalizeStudyHarmony(
        profile: profile,
        recentPerformance: recentPerformance,
      );

      expect(
        plan.onboardingIntensity,
        StudyHarmonyOnboardingIntensity.immersive,
      );
      expect(
        plan.remediationStyle,
        StudyHarmonyRemediationStyle.confidenceRebuild,
      );
      expect(plan.coachStyle, StudyHarmonyCoachStyle.restorative);
      expect(plan.preferredEventRotation.first, StudyHarmonySessionMode.review);
      expect(
        plan.tone,
        anyOf(StudyHarmonyToneStyle.warm, StudyHarmonyToneStyle.calm),
      );
    },
  );

  test('country and gender hints stay out of the challenge axis', () {
    final base = StudyHarmonyPersonalizationProfile(
      ageBand: StudyHarmonyAgeBand.adult,
      skillBand: StudyHarmonySkillBand.advanced,
      playStyle: StudyHarmonyPlayStyle.balanced,
      sessionLengthPreference: StudyHarmonySessionLengthPreference.long,
      regionFlavor: StudyHarmonyRegionFlavor.global,
      gameplayAffinity: const StudyHarmonyGameplayAffinity(
        competition: 0.5,
        collection: 0.5,
        exploration: 0.5,
        stability: 0.5,
      ),
    );
    final sensitive = base.copyWith(
      countryCode: 'KR',
      selfDescribedGenderLabel: 'female',
    );
    final recentPerformance = const StudyHarmonyRecentPerformance(
      averageAccuracy: 0.88,
      clearRate: 0.81,
      masteryMomentum: 0.84,
      confidence: 0.82,
      recoveryNeed: 0.18,
      lessonResultCount: 10,
      activeDayCount: 8,
      reviewQueueCount: 2,
      weakSpotCount: 2,
      bestStreakCount: 5,
    );

    final basePlan = personalizeStudyHarmony(
      profile: base,
      recentPerformance: recentPerformance,
    );
    final sensitivePlan = personalizeStudyHarmony(
      profile: sensitive,
      recentPerformance: recentPerformance,
    );

    expect(basePlan.coachStyle, sensitivePlan.coachStyle);
    expect(basePlan.rewardEmphasis, sensitivePlan.rewardEmphasis);
    expect(basePlan.modeEmphasis, sensitivePlan.modeEmphasis);
    expect(basePlan.challengeAggression, sensitivePlan.challengeAggression);
    expect(basePlan.remediationStyle, sensitivePlan.remediationStyle);
    expect(
      basePlan.preferredEventRotation.map((mode) => mode.name).toList(),
      equals(
        sensitivePlan.preferredEventRotation.map((mode) => mode.name).toList(),
      ),
    );
    expect(basePlan.onboardingIntensity, sensitivePlan.onboardingIntensity);
  });

  test('recent underperformance can pull the effective skill band down', () {
    final profile = StudyHarmonyPersonalizationProfile(
      ageBand: StudyHarmonyAgeBand.adult,
      skillBand: StudyHarmonySkillBand.expert,
      playStyle: StudyHarmonyPlayStyle.balanced,
      sessionLengthPreference: StudyHarmonySessionLengthPreference.medium,
      regionFlavor: StudyHarmonyRegionFlavor.global,
    );
    final recentPerformance = const StudyHarmonyRecentPerformance(
      averageAccuracy: 0.28,
      clearRate: 0.18,
      masteryMomentum: 0.22,
      confidence: 0.2,
      recoveryNeed: 0.85,
      lessonResultCount: 4,
      activeDayCount: 2,
      reviewQueueCount: 5,
      weakSpotCount: 7,
      bestStreakCount: 1,
    );

    final plan = personalizeStudyHarmony(
      profile: profile,
      recentPerformance: recentPerformance,
    );

    expect(plan.effectiveSkillBand.index, lessThan(profile.skillBand.index));
    expect(plan.onboardingIntensity, StudyHarmonyOnboardingIntensity.immersive);
    expect(
      plan.remediationStyle,
      StudyHarmonyRemediationStyle.confidenceRebuild,
    );
  });

  test('snapshot-derived performance feeds the adaptive planner', () {
    final snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion:
          StudyHarmonyProgressSnapshot.currentSerializationVersion,
      lessonResults: const {
        'lesson-1': StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-1',
          isCleared: true,
          bestAccuracy: 0.97,
          bestAttemptCount: 1,
          bestStars: 3,
          bestRank: 'S',
          bestElapsedMillis: 12000,
          playCount: 4,
          lastPlayedAtIso8601: '2026-03-18T00:00:00.000Z',
        ),
        'lesson-2': StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-2',
          isCleared: true,
          bestAccuracy: 0.89,
          bestAttemptCount: 2,
          bestStars: 3,
          bestRank: 'A',
          bestElapsedMillis: 16000,
          playCount: 2,
          lastPlayedAtIso8601: '2026-03-17T00:00:00.000Z',
        ),
      },
      skillMasteryPlaceholders: const {
        'chord.symbolToKeys': StudyHarmonySkillMasteryPlaceholder(
          skillId: 'chord.symbolToKeys',
          masteryScore: 0.91,
          exposureCount: 8,
          correctSessionCount: 7,
          recentAttemptScores: [0.9, 1.0, 0.95],
          recentAccuracy: 0.95,
          confidenceStreak: 5,
          lastSeenAtIso8601: '2026-03-17T00:00:00.000Z',
        ),
      },
      reviewQueuePlaceholders: const [
        StudyHarmonyReviewQueuePlaceholderEntry(
          itemId: 'lesson:lesson-2',
          lessonId: 'lesson-2',
          reason: 'retry-needed',
          dueAtIso8601: '2026-03-19T00:00:00.000Z',
          priority: 1,
          skillTags: {'chord.symbolToKeys'},
        ),
      ],
      activityDateKeys: const {'2026-03-16', '2026-03-17', '2026-03-18'},
      bestDailyChallengeStreak: 6,
      bestDuetPactStreak: 3,
    );

    final recentPerformance =
        StudyHarmonyRecentPerformance.fromProgressSnapshot(snapshot);
    final profile = StudyHarmonyPersonalizationProfile(
      ageBand: StudyHarmonyAgeBand.adult,
      skillBand: StudyHarmonySkillBand.beginner,
      playStyle: StudyHarmonyPlayStyle.explorer,
      sessionLengthPreference: StudyHarmonySessionLengthPreference.medium,
      regionFlavor: StudyHarmonyRegionFlavor.europe,
    );
    final plan = personalizeStudyHarmonyFromSnapshot(
      profile: profile,
      snapshot: snapshot,
    );

    expect(recentPerformance.hasMeaningfulData, isTrue);
    expect(recentPerformance.lessonResultCount, 2);
    expect(recentPerformance.reviewQueueCount, 1);
    expect(recentPerformance.averageAccuracy, closeTo(0.94, 0.02));
    expect(plan.effectiveSkillBand.index, greaterThan(profile.skillBand.index));
    expect(plan.preferredEventRotation.first, StudyHarmonySessionMode.daily);
  });
}
