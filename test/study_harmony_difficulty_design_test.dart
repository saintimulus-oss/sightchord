import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/meta/study_harmony_difficulty_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StudyHarmonyDifficultyDesign.profileForMode', () {
    test('returns distinct baseline profiles for every session mode', () {
      final profiles =
          <StudyHarmonySessionMode, StudyHarmonyModeDifficultyProfile>{
            for (final mode in StudyHarmonySessionMode.values)
              mode: StudyHarmonyDifficultyDesign.profileForMode(mode),
          };

      expect(profiles, hasLength(StudyHarmonySessionMode.values.length));
      expect(
        profiles[StudyHarmonySessionMode.legacyLevel]!.lane,
        StudyHarmonyDifficultyLane.recovery,
      );
      expect(
        profiles[StudyHarmonySessionMode.lesson]!.pressureTier,
        StudyHarmonyPressureTier.steady,
      );
      expect(
        profiles[StudyHarmonySessionMode.review]!.forgivenessTier,
        StudyHarmonyForgivenessTier.kind,
      );
      expect(
        profiles[StudyHarmonySessionMode.daily]!.lane,
        StudyHarmonyDifficultyLane.push,
      );
      expect(
        profiles[StudyHarmonySessionMode.focus]!.comboTarget,
        greaterThan(profiles[StudyHarmonySessionMode.lesson]!.comboTarget),
      );
      expect(
        profiles[StudyHarmonySessionMode.relay]!.lane,
        StudyHarmonyDifficultyLane.clutch,
      );
      expect(
        profiles[StudyHarmonySessionMode.bossRush]!.pressureTier,
        StudyHarmonyPressureTier.overdrive,
      );
      expect(
        profiles[StudyHarmonySessionMode.legend]!.comboTarget,
        greaterThan(profiles[StudyHarmonySessionMode.bossRush]!.comboTarget),
      );

      for (final profile in profiles.values) {
        expect(
          profile.warmupShare +
              profile.tensionShare +
              profile.releaseShare +
              profile.rewardShare,
          closeTo(1.0, 0.0001),
        );
        expect(
          profile.sessionLength.inMinutes,
          inInclusiveRange(
            profile.minSessionLength.inMinutes,
            profile.maxSessionLength.inMinutes,
          ),
        );
      }
    });
  });

  group('StudyHarmonyDifficultyDesign.design', () {
    test('keeps a struggling lesson player in a gentler lane', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.lesson,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.12,
          recentAccuracy: 0.18,
          recentStability: 0.22,
          recentMomentum: -0.4,
          recentStruggleRate: 0.82,
          recentComboPeak: 0.1,
        ),
      );

      expect(
        plan.difficultyLane.index,
        lessThanOrEqualTo(StudyHarmonyDifficultyLane.groove.index),
      );
      expect(
        plan.pressureTier.index,
        lessThanOrEqualTo(StudyHarmonyPressureTier.steady.index),
      );
      expect(
        plan.forgivenessTier.index,
        greaterThanOrEqualTo(StudyHarmonyForgivenessTier.kind.index),
      );
      expect(
        plan.sessionLengthSuggestion.inMinutes,
        lessThanOrEqualTo(plan.modeProfile.sessionLength.inMinutes),
      );
      expect(plan.heartBudget, greaterThan(plan.modeProfile.heartBudget));
      expect(plan.comboTarget, lessThan(plan.modeProfile.comboTarget));
      expect(plan.rationale.join(' '), contains('gentle'));
    });

    test('raises tension for a strong daily player', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.daily,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.94,
          recentAccuracy: 0.96,
          recentStability: 0.9,
          recentMomentum: 0.35,
          recentStruggleRate: 0.05,
          recentComboPeak: 0.92,
          preferredSessionMinutes: 12,
        ),
      );

      expect(
        plan.difficultyLane.index,
        greaterThanOrEqualTo(StudyHarmonyDifficultyLane.push.index),
      );
      expect(
        plan.pressureTier.index,
        greaterThanOrEqualTo(StudyHarmonyPressureTier.hot.index),
      );
      expect(plan.comboTarget, greaterThan(plan.modeProfile.comboTarget));
      expect(
        plan.bonusAggressiveness,
        greaterThan(plan.modeProfile.bonusAggressiveness),
      );
      expect(plan.remixIntensity, greaterThan(plan.modeProfile.remixIntensity));
      expect(
        plan.sessionLengthSuggestion.inMinutes,
        greaterThanOrEqualTo(plan.modeProfile.sessionLength.inMinutes),
      );
      expect(plan.rationale, isNotEmpty);
    });

    test('builds a pacing plan that sums to the full session length', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.bossRush,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.76,
          recentAccuracy: 0.8,
          recentStability: 0.72,
          recentMomentum: 0.12,
          recentStruggleRate: 0.24,
          recentComboPeak: 0.68,
        ),
      );

      expect(plan.pacingPlan.segments, hasLength(4));
      expect(
        plan.pacingPlan.segments.first.kind,
        StudyHarmonyRhythmBeatKind.warmup,
      );
      expect(
        plan.pacingPlan.segments.last.kind,
        StudyHarmonyRhythmBeatKind.reward,
      );
      expect(
        plan.pacingPlan.minuteTotal,
        plan.sessionLengthSuggestion.inMinutes,
      );
      expect(plan.pacingPlan.shareTotal, closeTo(1.0, 0.0001));
      expect(
        plan.pacingPlan.segments.every((segment) => segment.minutes >= 0),
        isTrue,
      );
    });

    test('clamps extreme input values safely', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.legend,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 5,
          recentAccuracy: -2,
          recentStability: 3,
          recentMomentum: 9,
          recentStruggleRate: -1,
          recentComboPeak: 4,
          preferredSessionMinutes: 999,
        ),
      );

      expect(plan.skillScore, inInclusiveRange(0, 1));
      expect(plan.frustrationScore, inInclusiveRange(0, 1));
      expect(
        plan.sessionLengthSuggestion.inMinutes,
        inInclusiveRange(
          plan.modeProfile.minSessionLength.inMinutes,
          plan.modeProfile.maxSessionLength.inMinutes,
        ),
      );
      expect(plan.heartBudget, inInclusiveRange(1, 7));
      expect(plan.comboTarget, inInclusiveRange(2, 20));
    });
  });

  group('StudyHarmonyRuntimeTuningRules', () {
    test('softens a struggling lesson run into a safer runtime tuning', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.lesson,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.14,
          recentAccuracy: 0.2,
          recentStability: 0.18,
          recentMomentum: -0.35,
          recentStruggleRate: 0.84,
          recentComboPeak: 0.12,
        ),
      );

      final tuning = StudyHarmonyRuntimeTuningRules.tuneFromPlan(
        plan: plan,
        baseStartingLives: 2,
        baseGoalCorrectAnswers: 4,
      );

      expect(tuning.mode, StudyHarmonySessionMode.lesson);
      expect(tuning.recommendedStartingLives, greaterThan(2));
      expect(tuning.startingLivesDelta, greaterThanOrEqualTo(0));
      expect(tuning.recommendedGoalCorrectAnswers, lessThanOrEqualTo(4));
      expect(tuning.goalCorrectAnswersDelta, lessThanOrEqualTo(0));
      expect(tuning.allowedMistakes, greaterThan(0));
      expect(tuning.pressureBudget, lessThanOrEqualTo(3));
      expect(tuning.forgivenessBuffer, greaterThanOrEqualTo(2));
      expect(tuning.isForgiving, isTrue);
      expect(tuning.rationale, isNotEmpty);
    });

    test('sharpens a strong boss rush run without breaking limits', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.bossRush,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.93,
          recentAccuracy: 0.95,
          recentStability: 0.9,
          recentMomentum: 0.22,
          recentStruggleRate: 0.08,
          recentComboPeak: 0.9,
        ),
      );

      final tuning = StudyHarmonyRuntimeTuningRules.tuneFromPlan(
        plan: plan,
        baseStartingLives: 2,
        baseGoalCorrectAnswers: 5,
        taskCount: 7,
      );

      expect(tuning.mode, StudyHarmonySessionMode.bossRush);
      expect(tuning.recommendedStartingLives, inInclusiveRange(1, 4));
      expect(tuning.recommendedGoalCorrectAnswers, inInclusiveRange(5, 7));
      expect(tuning.goalCorrectAnswersDelta, greaterThanOrEqualTo(0));
      expect(tuning.pressureBudget, greaterThanOrEqualTo(5));
      expect(tuning.pressureMultiplier, greaterThan(1.1));
      expect(tuning.forgivenessMultiplier, inInclusiveRange(0.8, 1.15));
      expect(tuning.comboTarget, plan.comboTarget);
    });

    test('clamps recommended goals to the task count when provided', () {
      final plan = StudyHarmonyDifficultyDesign.design(
        mode: StudyHarmonySessionMode.legend,
        input: const StudyHarmonyDifficultyInput(
          skillRating: 0.98,
          recentAccuracy: 0.99,
          recentStability: 0.97,
          recentMomentum: 0.42,
          recentStruggleRate: 0.02,
          recentComboPeak: 0.96,
        ),
      );

      final tuning = StudyHarmonyRuntimeTuningRules.tuneFromPlan(
        plan: plan,
        baseStartingLives: 3,
        baseGoalCorrectAnswers: 6,
        taskCount: 6,
      );

      expect(tuning.recommendedGoalCorrectAnswers, lessThanOrEqualTo(6));
      expect(
        tuning.recommendedGoalCorrectAnswers,
        greaterThanOrEqualTo(1),
      );
      expect(
        StudyHarmonyRuntimeTuningRules.recommendedGoalCorrectAnswersFor(
          plan: plan,
          baseGoalCorrectAnswers: 6,
          taskCount: 6,
        ),
        tuning.recommendedGoalCorrectAnswers,
      );
      expect(
        StudyHarmonyRuntimeTuningRules.recommendedStartingLivesFor(
          plan: plan,
          baseStartingLives: 3,
        ),
        tuning.recommendedStartingLives,
      );
      expect(
        StudyHarmonyRuntimeTuningRules.allowedMistakesFor(
          plan: plan,
          recommendedStartingLives: tuning.recommendedStartingLives,
        ),
        tuning.allowedMistakes,
      );
    });
  });
}
