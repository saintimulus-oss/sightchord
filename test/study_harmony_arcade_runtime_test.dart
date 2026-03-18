import 'package:flutter_test/flutter_test.dart';

import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:chordest/study_harmony/meta/study_harmony_arcade_catalog.dart';
import 'package:chordest/study_harmony/meta/study_harmony_arcade_runtime.dart';

void main() {
  group('StudyHarmony arcade runtime', () {
    test('each arcade mode maps to a distinct runtime profile', () {
      for (final mode in studyHarmonyArcadeModeCatalog) {
        expect(
          studyHarmonyArcadeRuntimeProfileForModeId(mode.id),
          isNotNull,
          reason: 'missing runtime profile for ${mode.id}',
        );
      }

      final neon = studyHarmonyArcadeRuntimeProfileForModeId('neon-sprint')!;
      final boss = studyHarmonyArcadeRuntimeProfileForModeId('boss-rush')!;
      final remix = studyHarmonyArcadeRuntimeProfileForModeId('remix-fever')!;
      final night = studyHarmonyArcadeRuntimeProfileForModeId('night-market')!;

      expect(neon.startingLivesDelta, greaterThan(0));
      expect(boss.startingLivesDelta, lessThan(0));
      expect(boss.comboResetsOnMiss, isTrue);
      expect(remix.modifierPool, isNotEmpty);
      expect(remix.modifierPulseEvery, equals(3));
      expect(
        night.mechanics,
        contains(StudyHarmonyArcadeRuntimeMechanicFlag.shopBias),
      );
      expect(
        night.rewardBias[StudyHarmonyArcadeRewardStyle.currency]!,
        greaterThan(0.4),
      );
    });

    test('runtime plans resolve from lesson summaries without a snapshot', () {
      final lessons = <StudyHarmonyLessonProgressSummary>[
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-a',
          isCleared: true,
          bestAccuracy: 0.98,
          bestAttemptCount: 1,
          bestStars: 3,
          bestRank: 'S',
          bestElapsedMillis: 76000,
          playCount: 4,
        ),
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-b',
          isCleared: true,
          bestAccuracy: 0.95,
          bestAttemptCount: 1,
          bestStars: 3,
          bestRank: 'S',
          bestElapsedMillis: 81000,
          playCount: 3,
        ),
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-c',
          isCleared: true,
          bestAccuracy: 0.91,
          bestAttemptCount: 1,
          bestStars: 3,
          bestRank: 'A',
          bestElapsedMillis: 84000,
          playCount: 2,
        ),
      ];

      final progress = summarizeStudyHarmonyArcadeProgress(
        lessons,
        totalLessons: 6,
        reviewQueueSize: 1,
        chapterClears: 2,
        bossClears: 1,
        currentStreak: 4,
      );

      final neonPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'neon-sprint',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: progress,
      );
      final bossPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'boss-rush',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: progress,
      );

      expect(neonPlan.startingLives, greaterThan(3));
      expect(neonPlan.goalCorrectAnswers, lessThanOrEqualTo(6));
      expect(neonPlan.comboBonusFor(6), greaterThan(0));
      expect(neonPlan.pulsesModifierOnTask(1), isFalse);
      expect(bossPlan.startingLives, lessThan(neonPlan.startingLives));
      expect(
        bossPlan.missPenaltyLives,
        greaterThanOrEqualTo(neonPlan.missPenaltyLives),
      );
      expect(bossPlan.comboResetsOnMiss, isTrue);
      expect(
        bossPlan.primaryRewardStyle(),
        StudyHarmonyArcadeRewardStyle.prestige,
      );
    });

    test('mode families make different runtime tradeoffs', () {
      final lowStrainHighSkillProgress = summarizeStudyHarmonyArcadeProgress(
        const [
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-a',
            isCleared: true,
            bestAccuracy: 0.99,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 71000,
            playCount: 5,
          ),
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-b',
            isCleared: true,
            bestAccuracy: 0.97,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 72000,
            playCount: 5,
          ),
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-c',
            isCleared: true,
            bestAccuracy: 0.93,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'A',
            bestElapsedMillis: 75000,
            playCount: 4,
          ),
        ],
        totalLessons: 8,
        reviewQueueSize: 0,
        chapterClears: 2,
        bossClears: 1,
        currentStreak: 5,
      );

      final remixPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'remix-fever',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: lowStrainHighSkillProgress,
      );
      final duelPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'duel-stage',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: lowStrainHighSkillProgress,
      );
      final vaultPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'vault-break',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: lowStrainHighSkillProgress,
      );
      final nightPlan = buildStudyHarmonyArcadeRuntimePlan(
        modeId: 'night-market',
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        progress: lowStrainHighSkillProgress,
      );

      expect(remixPlan.usesModifierStorm, isTrue);
      expect(remixPlan.modifierPulseEvery, equals(3));
      expect(remixPlan.pulsesModifierOnTask(2), isTrue);
      expect(duelPlan.usesGhostPressure, isTrue);
      expect(vaultPlan.comboResetsOnMiss, isTrue);
      expect(
        vaultPlan.missPenaltyLives,
        greaterThan(remixPlan.missPenaltyLives),
      );
      expect(nightPlan.usesShopBias, isTrue);
      expect(
        nightPlan.autoAdvanceMultiplier,
        lessThan(remixPlan.autoAdvanceMultiplier),
      );
    });
  });
}
