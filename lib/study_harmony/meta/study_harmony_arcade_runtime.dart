import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/study_harmony_progress_models.dart';
import 'study_harmony_arcade_catalog.dart';

enum StudyHarmonyArcadeRuntimeMechanicFlag {
  comboRamp,
  tempoBurst,
  ghostPressure,
  modifierStorm,
  vaultLock,
  bossSpike,
  crownCarry,
  ladderPressure,
  shopBias,
  prestigeSpike,
}

@immutable
class StudyHarmonyArcadeRuntimeProfile {
  const StudyHarmonyArcadeRuntimeProfile({
    required this.modeId,
    required this.startingLivesDelta,
    required this.goalCorrectAnswersDelta,
    required this.missPenaltyLives,
    required this.comboBonusEvery,
    required this.comboBonusAmount,
    required this.comboDropOnMiss,
    required this.comboResetsOnMiss,
    required this.tempoMultiplier,
    required this.autoAdvanceMultiplier,
    required this.modifierPulseEvery,
    required this.modifierPool,
    required this.rewardBias,
    required this.mechanics,
  });

  final StudyHarmonyArcadeModeId modeId;
  final int startingLivesDelta;
  final int goalCorrectAnswersDelta;
  final int missPenaltyLives;
  final int comboBonusEvery;
  final int comboBonusAmount;
  final int comboDropOnMiss;
  final bool comboResetsOnMiss;
  final double tempoMultiplier;
  final double autoAdvanceMultiplier;
  final int modifierPulseEvery;
  final List<String> modifierPool;
  final Map<StudyHarmonyArcadeRewardStyle, double> rewardBias;
  final Set<StudyHarmonyArcadeRuntimeMechanicFlag> mechanics;

  StudyHarmonyArcadeRuntimePlan resolve({
    required int baseStartingLives,
    required int baseGoalCorrectAnswers,
    required StudyHarmonyArcadeProgressSummary progress,
  }) {
    final skill = _progressSkill(progress);
    final strain = _progressStrain(progress);

    final startingLives = max(
      1,
      baseStartingLives +
          startingLivesDelta +
          _startingLifeAdjustment(skill, strain),
    );
    final goalCorrectAnswers = max(
      1,
      baseGoalCorrectAnswers +
          goalCorrectAnswersDelta +
          _goalAdjustment(skill, strain),
    );
    final missPenalty = max(
      0,
      missPenaltyLives + _missPenaltyAdjustment(skill, strain),
    );
    final comboBonusEveryResolved = max(
      1,
      comboBonusEvery + _comboFrequencyAdjustment(skill, strain),
    );
    final comboBonusAmountResolved = max(
      0,
      comboBonusAmount + _comboAmountAdjustment(skill, strain),
    );
    final tempoMultiplierResolved = _clampDouble(
      tempoMultiplier * (1 + (skill * 0.14) - (strain * 0.08)),
      0.7,
      1.6,
    );
    final autoAdvanceMultiplierResolved = _clampDouble(
      autoAdvanceMultiplier * (1 + (skill * 0.1) - (strain * 0.06)),
      0.65,
      1.5,
    );
    final modifierPulseEveryResolved = modifierPool.isEmpty
        ? 0
        : max(
            1,
            modifierPulseEvery + _modifierCadenceAdjustment(skill, strain),
          );

    return StudyHarmonyArcadeRuntimePlan(
      modeId: modeId,
      startingLives: startingLives,
      goalCorrectAnswers: goalCorrectAnswers,
      missPenaltyLives: missPenalty,
      comboBonusEvery: comboBonusEveryResolved,
      comboBonusAmount: comboBonusAmountResolved,
      comboDropOnMiss: comboResetsOnMiss
          ? 999
          : max(0, comboDropOnMiss + _comboDropAdjustment(skill, strain)),
      comboResetsOnMiss: comboResetsOnMiss,
      tempoMultiplier: tempoMultiplierResolved,
      autoAdvanceMultiplier: autoAdvanceMultiplierResolved,
      modifierPulseEvery: modifierPulseEveryResolved,
      modifierPool: modifierPool,
      rewardBias: _tunedRewardBias(
        skill: skill,
        strain: strain,
        baseBias: rewardBias,
      ),
      mechanics: mechanics,
    );
  }
}

@immutable
class StudyHarmonyArcadeRuntimePlan {
  const StudyHarmonyArcadeRuntimePlan({
    required this.modeId,
    required this.startingLives,
    required this.goalCorrectAnswers,
    required this.missPenaltyLives,
    required this.comboBonusEvery,
    required this.comboBonusAmount,
    required this.comboDropOnMiss,
    required this.comboResetsOnMiss,
    required this.tempoMultiplier,
    required this.autoAdvanceMultiplier,
    required this.modifierPulseEvery,
    required this.modifierPool,
    required this.rewardBias,
    required this.mechanics,
  });

  final StudyHarmonyArcadeModeId modeId;
  final int startingLives;
  final int goalCorrectAnswers;
  final int missPenaltyLives;
  final int comboBonusEvery;
  final int comboBonusAmount;
  final int comboDropOnMiss;
  final bool comboResetsOnMiss;
  final double tempoMultiplier;
  final double autoAdvanceMultiplier;
  final int modifierPulseEvery;
  final List<String> modifierPool;
  final Map<StudyHarmonyArcadeRewardStyle, double> rewardBias;
  final Set<StudyHarmonyArcadeRuntimeMechanicFlag> mechanics;

  bool get usesModifierStorm =>
      mechanics.contains(StudyHarmonyArcadeRuntimeMechanicFlag.modifierStorm);

  bool get usesGhostPressure =>
      mechanics.contains(StudyHarmonyArcadeRuntimeMechanicFlag.ghostPressure);

  bool get usesShopBias =>
      mechanics.contains(StudyHarmonyArcadeRuntimeMechanicFlag.shopBias);

  bool get usesPrestigeBias =>
      mechanics.contains(StudyHarmonyArcadeRuntimeMechanicFlag.prestigeSpike);

  int comboBonusFor(int combo) {
    if (comboBonusEvery <= 0 || combo <= 0) {
      return 0;
    }
    return (combo ~/ comboBonusEvery) * comboBonusAmount;
  }

  int applyMissPenaltyToCombo(int currentCombo) {
    if (currentCombo <= 0) {
      return 0;
    }
    if (comboResetsOnMiss) {
      return 0;
    }
    return max(0, currentCombo - comboDropOnMiss);
  }

  int applyMissPenaltyToLives(int currentLives, int missCount) {
    return max(0, currentLives - (missCount * missPenaltyLives));
  }

  bool pulsesModifierOnTask(int taskIndex) {
    if (modifierPulseEvery <= 0) {
      return false;
    }
    return (taskIndex + 1) % modifierPulseEvery == 0;
  }

  StudyHarmonyArcadeRewardStyle? primaryRewardStyle() {
    if (rewardBias.isEmpty) {
      return null;
    }
    return rewardBias.entries
        .reduce((left, right) => left.value >= right.value ? left : right)
        .key;
  }
}

const List<StudyHarmonyArcadeRuntimeProfile> studyHarmonyArcadeRuntimeProfiles =
    [
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'neon-sprint',
        startingLivesDelta: 1,
        goalCorrectAnswersDelta: -1,
        missPenaltyLives: 1,
        comboBonusEvery: 2,
        comboBonusAmount: 1,
        comboDropOnMiss: 1,
        comboResetsOnMiss: false,
        tempoMultiplier: 1.08,
        autoAdvanceMultiplier: 1.15,
        modifierPulseEvery: 0,
        modifierPool: <String>[],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.currency: 0.58,
          StudyHarmonyArcadeRewardStyle.bundle: 0.22,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.08,
          StudyHarmonyArcadeRewardStyle.title: 0.07,
          StudyHarmonyArcadeRewardStyle.trophy: 0.03,
          StudyHarmonyArcadeRewardStyle.prestige: 0.02,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
          StudyHarmonyArcadeRuntimeMechanicFlag.tempoBurst,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'ghost-relay',
        startingLivesDelta: 0,
        goalCorrectAnswersDelta: 0,
        missPenaltyLives: 1,
        comboBonusEvery: 3,
        comboBonusAmount: 2,
        comboDropOnMiss: 2,
        comboResetsOnMiss: false,
        tempoMultiplier: 1.1,
        autoAdvanceMultiplier: 1.0,
        modifierPulseEvery: 0,
        modifierPool: <String>[],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.title: 0.45,
          StudyHarmonyArcadeRewardStyle.trophy: 0.2,
          StudyHarmonyArcadeRewardStyle.bundle: 0.15,
          StudyHarmonyArcadeRewardStyle.currency: 0.1,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.07,
          StudyHarmonyArcadeRewardStyle.prestige: 0.03,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.ghostPressure,
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'vault-break',
        startingLivesDelta: 0,
        goalCorrectAnswersDelta: 1,
        missPenaltyLives: 2,
        comboBonusEvery: 3,
        comboBonusAmount: 3,
        comboDropOnMiss: 999,
        comboResetsOnMiss: true,
        tempoMultiplier: 0.96,
        autoAdvanceMultiplier: 0.92,
        modifierPulseEvery: 4,
        modifierPool: <String>[
          'lock-surge',
          'fog-of-war',
          'greedy-chest',
          'safe-room',
        ],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.35,
          StudyHarmonyArcadeRewardStyle.bundle: 0.25,
          StudyHarmonyArcadeRewardStyle.currency: 0.15,
          StudyHarmonyArcadeRewardStyle.title: 0.1,
          StudyHarmonyArcadeRewardStyle.trophy: 0.08,
          StudyHarmonyArcadeRewardStyle.prestige: 0.07,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.vaultLock,
          StudyHarmonyArcadeRuntimeMechanicFlag.modifierStorm,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'remix-fever',
        startingLivesDelta: 0,
        goalCorrectAnswersDelta: 0,
        missPenaltyLives: 1,
        comboBonusEvery: 2,
        comboBonusAmount: 2,
        comboDropOnMiss: 1,
        comboResetsOnMiss: false,
        tempoMultiplier: 1.0,
        autoAdvanceMultiplier: 1.0,
        modifierPulseEvery: 3,
        modifierPool: <String>[
          'tempo-swap',
          'hint-fracture',
          'answer-echo',
          'score-mirror',
        ],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.bundle: 0.38,
          StudyHarmonyArcadeRewardStyle.currency: 0.22,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.14,
          StudyHarmonyArcadeRewardStyle.title: 0.1,
          StudyHarmonyArcadeRewardStyle.trophy: 0.08,
          StudyHarmonyArcadeRewardStyle.prestige: 0.08,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.modifierStorm,
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'boss-rush',
        startingLivesDelta: -1,
        goalCorrectAnswersDelta: 2,
        missPenaltyLives: 2,
        comboBonusEvery: 2,
        comboBonusAmount: 4,
        comboDropOnMiss: 999,
        comboResetsOnMiss: true,
        tempoMultiplier: 1.15,
        autoAdvanceMultiplier: 1.12,
        modifierPulseEvery: 2,
        modifierPool: <String>[
          'boss-shield',
          'heart-tax',
          'tempo-spike',
          'phase-cut',
        ],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.prestige: 0.52,
          StudyHarmonyArcadeRewardStyle.trophy: 0.22,
          StudyHarmonyArcadeRewardStyle.title: 0.12,
          StudyHarmonyArcadeRewardStyle.bundle: 0.08,
          StudyHarmonyArcadeRewardStyle.currency: 0.04,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.02,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.bossSpike,
          StudyHarmonyArcadeRuntimeMechanicFlag.prestigeSpike,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'crown-loop',
        startingLivesDelta: 0,
        goalCorrectAnswersDelta: 3,
        missPenaltyLives: 1,
        comboBonusEvery: 4,
        comboBonusAmount: 4,
        comboDropOnMiss: 2,
        comboResetsOnMiss: false,
        tempoMultiplier: 1.0,
        autoAdvanceMultiplier: 0.98,
        modifierPulseEvery: 5,
        modifierPool: <String>['crown-saver', 'echo-lane', 'marathon-boost'],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.trophy: 0.48,
          StudyHarmonyArcadeRewardStyle.prestige: 0.28,
          StudyHarmonyArcadeRewardStyle.title: 0.12,
          StudyHarmonyArcadeRewardStyle.bundle: 0.07,
          StudyHarmonyArcadeRewardStyle.currency: 0.03,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.02,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.crownCarry,
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'duel-stage',
        startingLivesDelta: 0,
        goalCorrectAnswersDelta: 0,
        missPenaltyLives: 1,
        comboBonusEvery: 2,
        comboBonusAmount: 3,
        comboDropOnMiss: 2,
        comboResetsOnMiss: false,
        tempoMultiplier: 1.06,
        autoAdvanceMultiplier: 1.07,
        modifierPulseEvery: 4,
        modifierPool: <String>['ghost-echo', 'ladder-surge', 'mirror-tilt'],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.currency: 0.36,
          StudyHarmonyArcadeRewardStyle.title: 0.24,
          StudyHarmonyArcadeRewardStyle.trophy: 0.12,
          StudyHarmonyArcadeRewardStyle.bundle: 0.12,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.08,
          StudyHarmonyArcadeRewardStyle.prestige: 0.08,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.ghostPressure,
          StudyHarmonyArcadeRuntimeMechanicFlag.ladderPressure,
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
        },
      ),
      StudyHarmonyArcadeRuntimeProfile(
        modeId: 'night-market',
        startingLivesDelta: 1,
        goalCorrectAnswersDelta: -1,
        missPenaltyLives: 0,
        comboBonusEvery: 4,
        comboBonusAmount: 1,
        comboDropOnMiss: 1,
        comboResetsOnMiss: false,
        tempoMultiplier: 0.92,
        autoAdvanceMultiplier: 0.88,
        modifierPulseEvery: 5,
        modifierPool: <String>[
          'vendor-choice',
          'stock-flip',
          'discount-window',
          'reissue',
        ],
        rewardBias: <StudyHarmonyArcadeRewardStyle, double>{
          StudyHarmonyArcadeRewardStyle.currency: 0.48,
          StudyHarmonyArcadeRewardStyle.cosmetic: 0.24,
          StudyHarmonyArcadeRewardStyle.bundle: 0.18,
          StudyHarmonyArcadeRewardStyle.title: 0.04,
          StudyHarmonyArcadeRewardStyle.trophy: 0.03,
          StudyHarmonyArcadeRewardStyle.prestige: 0.03,
        },
        mechanics: {
          StudyHarmonyArcadeRuntimeMechanicFlag.shopBias,
          StudyHarmonyArcadeRuntimeMechanicFlag.comboRamp,
        },
      ),
    ];

final Map<StudyHarmonyArcadeModeId, StudyHarmonyArcadeRuntimeProfile>
studyHarmonyArcadeRuntimeProfilesByModeId = {
  for (final profile in studyHarmonyArcadeRuntimeProfiles)
    profile.modeId: profile,
};

StudyHarmonyArcadeRuntimeProfile? studyHarmonyArcadeRuntimeProfileForModeId(
  StudyHarmonyArcadeModeId modeId,
) {
  return studyHarmonyArcadeRuntimeProfilesByModeId[modeId];
}

StudyHarmonyArcadeRuntimePlan buildStudyHarmonyArcadeRuntimePlan({
  required StudyHarmonyArcadeModeId modeId,
  required int baseStartingLives,
  required int baseGoalCorrectAnswers,
  required StudyHarmonyArcadeProgressSummary progress,
}) {
  final profile = studyHarmonyArcadeRuntimeProfileForModeId(modeId);
  if (profile == null) {
    return StudyHarmonyArcadeRuntimePlan(
      modeId: modeId,
      startingLives: max(1, baseStartingLives),
      goalCorrectAnswers: max(1, baseGoalCorrectAnswers),
      missPenaltyLives: 1,
      comboBonusEvery: 3,
      comboBonusAmount: 1,
      comboDropOnMiss: 1,
      comboResetsOnMiss: false,
      tempoMultiplier: 1.0,
      autoAdvanceMultiplier: 1.0,
      modifierPulseEvery: 0,
      modifierPool: const <String>[],
      rewardBias: const <StudyHarmonyArcadeRewardStyle, double>{
        StudyHarmonyArcadeRewardStyle.currency: 1,
      },
      mechanics: const <StudyHarmonyArcadeRuntimeMechanicFlag>{},
    );
  }

  return profile.resolve(
    baseStartingLives: baseStartingLives,
    baseGoalCorrectAnswers: baseGoalCorrectAnswers,
    progress: progress,
  );
}

StudyHarmonyArcadeRuntimePlan
buildStudyHarmonyArcadeRuntimePlanFromLessonSummaries(
  Iterable<StudyHarmonyLessonProgressSummary> lessons, {
  required StudyHarmonyArcadeModeId modeId,
  required int baseStartingLives,
  required int baseGoalCorrectAnswers,
  int totalLessons = 0,
  int reviewQueueSize = 0,
  int chapterClears = 0,
  int bossClears = 0,
  int currentStreak = 0,
}) {
  final progress = summarizeStudyHarmonyArcadeProgress(
    lessons,
    totalLessons: totalLessons,
    reviewQueueSize: reviewQueueSize,
    chapterClears: chapterClears,
    bossClears: bossClears,
    currentStreak: currentStreak,
  );
  return buildStudyHarmonyArcadeRuntimePlan(
    modeId: modeId,
    baseStartingLives: baseStartingLives,
    baseGoalCorrectAnswers: baseGoalCorrectAnswers,
    progress: progress,
  );
}

double _progressSkill(StudyHarmonyArcadeProgressSummary progress) {
  final accuracy = _clampDouble(progress.averageAccuracy, 0, 1);
  final bestAccuracy = _clampDouble(progress.bestAccuracy, 0, 1);
  final completion = _clampDouble(progress.completionRate, 0, 1);
  final streak = _clampDouble(progress.currentStreak / 8, 0, 1);
  final mastery = _clampDouble(progress.sRanks / 5, 0, 1);
  return (accuracy * 0.38) +
      (bestAccuracy * 0.22) +
      (completion * 0.16) +
      (streak * 0.12) +
      (mastery * 0.12);
}

double _progressStrain(StudyHarmonyArcadeProgressSummary progress) {
  final reviewPressure = _clampDouble(progress.reviewQueueSize / 6, 0, 1);
  final bossPressure = _clampDouble(progress.bossClears / 4, 0, 1);
  final weakSpotPressure = _clampDouble(1 - progress.averageAccuracy, 0, 1);
  return (reviewPressure * 0.45) +
      (bossPressure * 0.15) +
      (weakSpotPressure * 0.4);
}

int _startingLifeAdjustment(double skill, double strain) {
  return ((1 - skill) * 2).round() - (strain > 0.65 ? 1 : 0);
}

int _goalAdjustment(double skill, double strain) {
  final skillBonus = skill >= 0.72 ? 1 : 0;
  final strainPenalty = strain >= 0.6 ? -1 : 0;
  return skillBonus + strainPenalty;
}

int _missPenaltyAdjustment(double skill, double strain) {
  if (skill >= 0.82) {
    return 1;
  }
  if (strain >= 0.55) {
    return -1;
  }
  return 0;
}

int _comboFrequencyAdjustment(double skill, double strain) {
  if (skill >= 0.88) {
    return -1;
  }
  if (strain >= 0.55) {
    return 1;
  }
  return 0;
}

int _comboAmountAdjustment(double skill, double strain) {
  final skillBonus = skill >= 0.8 ? 1 : 0;
  final strainPenalty = strain >= 0.7 ? -1 : 0;
  return skillBonus + strainPenalty;
}

int _comboDropAdjustment(double skill, double strain) {
  if (skill >= 0.85) {
    return 1;
  }
  if (strain >= 0.7) {
    return -1;
  }
  return 0;
}

int _modifierCadenceAdjustment(double skill, double strain) {
  if (skill >= 0.9) {
    return -1;
  }
  if (strain >= 0.6) {
    return 1;
  }
  return 0;
}

Map<StudyHarmonyArcadeRewardStyle, double> _tunedRewardBias({
  required double skill,
  required double strain,
  required Map<StudyHarmonyArcadeRewardStyle, double> baseBias,
}) {
  final weights = <StudyHarmonyArcadeRewardStyle, double>{
    for (final entry in baseBias.entries) entry.key: entry.value,
  };

  void shift(
    StudyHarmonyArcadeRewardStyle from,
    StudyHarmonyArcadeRewardStyle to,
    double amount,
  ) {
    final fromValue = weights[from] ?? 0;
    final delta = fromValue < amount ? fromValue : amount;
    if (delta <= 0) {
      return;
    }
    weights[from] = fromValue - delta;
    weights[to] = (weights[to] ?? 0) + delta;
  }

  if (skill >= 0.8) {
    shift(
      StudyHarmonyArcadeRewardStyle.currency,
      StudyHarmonyArcadeRewardStyle.prestige,
      0.08,
    );
    shift(
      StudyHarmonyArcadeRewardStyle.bundle,
      StudyHarmonyArcadeRewardStyle.trophy,
      0.04,
    );
  }

  if (strain >= 0.55) {
    shift(
      StudyHarmonyArcadeRewardStyle.prestige,
      StudyHarmonyArcadeRewardStyle.bundle,
      0.05,
    );
    shift(
      StudyHarmonyArcadeRewardStyle.title,
      StudyHarmonyArcadeRewardStyle.currency,
      0.03,
    );
  }

  final total = weights.values.fold<double>(0, (sum, value) => sum + value);
  if (total <= 0) {
    return const <StudyHarmonyArcadeRewardStyle, double>{
      StudyHarmonyArcadeRewardStyle.currency: 1,
    };
  }

  return <StudyHarmonyArcadeRewardStyle, double>{
    for (final entry in weights.entries) entry.key: entry.value / total,
  };
}

double _clampDouble(double value, double min, double max) {
  if (value.isNaN) {
    return min;
  }
  return value < min ? min : (value > max ? max : value);
}
