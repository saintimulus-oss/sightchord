import 'dart:math';

import 'package:flutter/foundation.dart';

import '../domain/study_harmony_session_models.dart';

double _clampDouble(double value, double min, double max) {
  if (value.isNaN) {
    return min;
  }
  return value < min ? min : (value > max ? max : value);
}

int _clampInt(int value, int min, int max) {
  return value < min ? min : (value > max ? max : value);
}

double _normalizeScore(double value) {
  if (value.isNaN || value.isInfinite) {
    return 0;
  }
  return _clampDouble(value, 0, 1);
}

double _weightedAverage(List<double> values, List<double> weights) {
  if (values.isEmpty || values.length != weights.length) {
    return 0;
  }

  var totalWeight = 0.0;
  var total = 0.0;
  for (var index = 0; index < values.length; index++) {
    final weight = weights[index];
    totalWeight += weight;
    total += values[index] * weight;
  }

  if (totalWeight <= 0) {
    return 0;
  }

  return total / totalWeight;
}

enum StudyHarmonyDifficultyLane { recovery, groove, push, clutch, legend }

enum StudyHarmonyPressureTier { calm, steady, hot, charged, overdrive }

enum StudyHarmonyForgivenessTier { strict, tight, balanced, kind, generous }

enum StudyHarmonyRhythmBeatKind { warmup, tension, release, reward }

@immutable
class StudyHarmonyDifficultyInput {
  const StudyHarmonyDifficultyInput({
    this.skillRating = 0.5,
    this.recentAccuracy = 0.5,
    this.recentStability = 0.5,
    this.recentMomentum = 0,
    this.recentStruggleRate = 0.5,
    this.recentComboPeak = 0.5,
    this.preferredSessionMinutes,
  });

  final double skillRating;
  final double recentAccuracy;
  final double recentStability;
  final double recentMomentum;
  final double recentStruggleRate;
  final double recentComboPeak;
  final int? preferredSessionMinutes;

  double get normalizedSkillRating => _normalizeScore(skillRating);

  double get normalizedRecentAccuracy => _normalizeScore(recentAccuracy);

  double get normalizedRecentStability => _normalizeScore(recentStability);

  double get normalizedRecentMomentum => _clampDouble(recentMomentum, -1, 1);

  double get normalizedRecentStruggleRate =>
      _normalizeScore(recentStruggleRate);

  double get normalizedRecentComboPeak => _normalizeScore(recentComboPeak);
}

@immutable
class StudyHarmonyModeDifficultyProfile {
  const StudyHarmonyModeDifficultyProfile({
    required this.mode,
    required this.lane,
    required this.pressureTier,
    required this.forgivenessTier,
    required this.sessionLength,
    required this.minSessionLength,
    required this.maxSessionLength,
    required this.heartBudget,
    required this.comboTarget,
    required this.bonusAggressiveness,
    required this.remixIntensity,
    required this.warmupShare,
    required this.tensionShare,
    required this.releaseShare,
    required this.rewardShare,
    required this.description,
  });

  final StudyHarmonySessionMode mode;
  final StudyHarmonyDifficultyLane lane;
  final StudyHarmonyPressureTier pressureTier;
  final StudyHarmonyForgivenessTier forgivenessTier;
  final Duration sessionLength;
  final Duration minSessionLength;
  final Duration maxSessionLength;
  final int heartBudget;
  final int comboTarget;
  final double bonusAggressiveness;
  final double remixIntensity;
  final double warmupShare;
  final double tensionShare;
  final double releaseShare;
  final double rewardShare;
  final String description;
}

@immutable
class StudyHarmonyPacingSegment {
  const StudyHarmonyPacingSegment({
    required this.kind,
    required this.share,
    required this.minutes,
    required this.label,
  });

  final StudyHarmonyRhythmBeatKind kind;
  final double share;
  final int minutes;
  final String label;
}

@immutable
class StudyHarmonyPacingPlan {
  const StudyHarmonyPacingPlan({
    required this.totalDuration,
    required this.segments,
  });

  final Duration totalDuration;
  final List<StudyHarmonyPacingSegment> segments;

  int get totalMinutes => totalDuration.inMinutes;

  double get shareTotal =>
      segments.fold<double>(0, (total, segment) => total + segment.share);

  int get minuteTotal =>
      segments.fold<int>(0, (total, segment) => total + segment.minutes);

  static StudyHarmonyPacingPlan fromShares({
    required Duration totalDuration,
    required double warmupShare,
    required double tensionShare,
    required double releaseShare,
    required double rewardShare,
  }) {
    final totalMinutes = max(0, totalDuration.inMinutes);
    final rawShares = <StudyHarmonyRhythmBeatKind, double>{
      StudyHarmonyRhythmBeatKind.warmup: warmupShare,
      StudyHarmonyRhythmBeatKind.tension: tensionShare,
      StudyHarmonyRhythmBeatKind.release: releaseShare,
      StudyHarmonyRhythmBeatKind.reward: rewardShare,
    };

    final normalizedEntries = rawShares.entries
        .map((entry) => MapEntry(entry.key, _clampDouble(entry.value, 0, 1)))
        .toList(growable: false);

    final normalizedTotal = normalizedEntries.fold<double>(
      0,
      (total, entry) => total + entry.value,
    );

    final safeTotal = normalizedTotal <= 0 ? 1.0 : normalizedTotal;
    final orderedSegments = <_PendingSegment>[];

    for (final entry in normalizedEntries) {
      final share = entry.value / safeTotal;
      final exactMinutes = totalMinutes * share;
      final baseMinutes = exactMinutes.floor();
      orderedSegments.add(
        _PendingSegment(
          kind: entry.key,
          share: share,
          exactMinutes: exactMinutes,
          minutes: baseMinutes,
        ),
      );
    }

    var allocatedMinutes = orderedSegments.fold<int>(
      0,
      (total, segment) => total + segment.minutes,
    );
    var remainingMinutes = totalMinutes - allocatedMinutes;

    orderedSegments.sort((left, right) {
      final leftFraction = left.exactMinutes - left.minutes;
      final rightFraction = right.exactMinutes - right.minutes;
      return rightFraction.compareTo(leftFraction);
    });

    var index = 0;
    while (remainingMinutes > 0 && orderedSegments.isNotEmpty) {
      orderedSegments[index % orderedSegments.length].minutes++;
      remainingMinutes--;
      index++;
    }

    orderedSegments.sort((left, right) {
      return _beatKindOrder(left.kind).compareTo(_beatKindOrder(right.kind));
    });

    final segments = orderedSegments
        .map(
          (segment) => StudyHarmonyPacingSegment(
            kind: segment.kind,
            share: segment.share,
            minutes: segment.minutes,
            label: _beatLabel(segment.kind),
          ),
        )
        .toList(growable: false);

    return StudyHarmonyPacingPlan(
      totalDuration: Duration(minutes: totalMinutes),
      segments: segments,
    );
  }
}

@immutable
class StudyHarmonyDifficultyPlan {
  const StudyHarmonyDifficultyPlan({
    required this.mode,
    required this.modeProfile,
    required this.skillScore,
    required this.frustrationScore,
    required this.difficultyLane,
    required this.pressureTier,
    required this.forgivenessTier,
    required this.sessionLengthSuggestion,
    required this.heartBudget,
    required this.comboTarget,
    required this.bonusAggressiveness,
    required this.remixIntensity,
    required this.pacingPlan,
    required this.rationale,
  });

  final StudyHarmonySessionMode mode;
  final StudyHarmonyModeDifficultyProfile modeProfile;
  final double skillScore;
  final double frustrationScore;
  final StudyHarmonyDifficultyLane difficultyLane;
  final StudyHarmonyPressureTier pressureTier;
  final StudyHarmonyForgivenessTier forgivenessTier;
  final Duration sessionLengthSuggestion;
  final int heartBudget;
  final int comboTarget;
  final double bonusAggressiveness;
  final double remixIntensity;
  final StudyHarmonyPacingPlan pacingPlan;
  final List<String> rationale;
}

@immutable
class StudyHarmonyRuntimeTuning {
  const StudyHarmonyRuntimeTuning({
    required this.plan,
    required this.baseStartingLives,
    required this.baseGoalCorrectAnswers,
    required this.recommendedStartingLives,
    required this.startingLivesDelta,
    required this.recommendedGoalCorrectAnswers,
    required this.goalCorrectAnswersDelta,
    required this.allowedMistakes,
    required this.pressureBudget,
    required this.forgivenessBuffer,
    required this.pressureMultiplier,
    required this.forgivenessMultiplier,
    required this.comboTarget,
    required this.bonusAggressiveness,
    required this.remixIntensity,
    required this.rationale,
  });

  final StudyHarmonyDifficultyPlan plan;
  final int baseStartingLives;
  final int baseGoalCorrectAnswers;
  final int recommendedStartingLives;
  final int startingLivesDelta;
  final int recommendedGoalCorrectAnswers;
  final int goalCorrectAnswersDelta;
  final int allowedMistakes;
  final int pressureBudget;
  final int forgivenessBuffer;
  final double pressureMultiplier;
  final double forgivenessMultiplier;
  final int comboTarget;
  final double bonusAggressiveness;
  final double remixIntensity;
  final List<String> rationale;

  StudyHarmonySessionMode get mode => plan.mode;

  StudyHarmonyDifficultyLane get difficultyLane => plan.difficultyLane;

  StudyHarmonyPressureTier get pressureTier => plan.pressureTier;

  StudyHarmonyForgivenessTier get forgivenessTier => plan.forgivenessTier;

  Duration get sessionLengthSuggestion => plan.sessionLengthSuggestion;

  bool get isPressureHeavy => pressureBudget >= 5;

  bool get isForgiving => forgivenessMultiplier >= 1.15;
}

class StudyHarmonyRuntimeTuningRules {
  const StudyHarmonyRuntimeTuningRules._();

  static StudyHarmonyRuntimeTuning tuneFromPlan({
    required StudyHarmonyDifficultyPlan plan,
    required int baseStartingLives,
    required int baseGoalCorrectAnswers,
    int? taskCount,
  }) {
    final startingLivesDelta = _startingLivesDelta(plan);
    final recommendedStartingLives = _clampInt(
      baseStartingLives + startingLivesDelta,
      1,
      9,
    );

    final goalCorrectAnswersDelta = _goalCorrectAnswersDelta(plan);
    var recommendedGoalCorrectAnswers =
        baseGoalCorrectAnswers + goalCorrectAnswersDelta;
    if (taskCount != null) {
      recommendedGoalCorrectAnswers = _clampInt(
        recommendedGoalCorrectAnswers,
        1,
        max(1, taskCount),
      );
    } else {
      recommendedGoalCorrectAnswers = max(1, recommendedGoalCorrectAnswers);
    }

    final pressureBudget = _pressureBudget(plan);
    final forgivenessBuffer = _forgivenessBuffer(plan);
    final allowedMistakes = _allowedMistakes(
      recommendedStartingLives: recommendedStartingLives,
      pressureBudget: pressureBudget,
      forgivenessBuffer: forgivenessBuffer,
    );

    return StudyHarmonyRuntimeTuning(
      plan: plan,
      baseStartingLives: baseStartingLives,
      baseGoalCorrectAnswers: baseGoalCorrectAnswers,
      recommendedStartingLives: recommendedStartingLives,
      startingLivesDelta: startingLivesDelta,
      recommendedGoalCorrectAnswers: recommendedGoalCorrectAnswers,
      goalCorrectAnswersDelta: recommendedGoalCorrectAnswers -
          baseGoalCorrectAnswers,
      allowedMistakes: allowedMistakes,
      pressureBudget: pressureBudget,
      forgivenessBuffer: forgivenessBuffer,
      pressureMultiplier: _pressureMultiplier(plan, pressureBudget),
      forgivenessMultiplier:
          _forgivenessMultiplier(plan, forgivenessBuffer, allowedMistakes),
      comboTarget: plan.comboTarget,
      bonusAggressiveness: plan.bonusAggressiveness,
      remixIntensity: plan.remixIntensity,
      rationale: _buildRuntimeRationale(
        plan: plan,
        recommendedStartingLives: recommendedStartingLives,
        recommendedGoalCorrectAnswers: recommendedGoalCorrectAnswers,
        allowedMistakes: allowedMistakes,
        pressureBudget: pressureBudget,
        forgivenessBuffer: forgivenessBuffer,
      ),
    );
  }

  static int recommendedStartingLivesFor({
    required StudyHarmonyDifficultyPlan plan,
    required int baseStartingLives,
  }) {
    return _clampInt(baseStartingLives + _startingLivesDelta(plan), 1, 9);
  }

  static int goalCorrectAnswersDeltaFor({
    required StudyHarmonyDifficultyPlan plan,
  }) {
    return _goalCorrectAnswersDelta(plan);
  }

  static int recommendedGoalCorrectAnswersFor({
    required StudyHarmonyDifficultyPlan plan,
    required int baseGoalCorrectAnswers,
    int? taskCount,
  }) {
    final recommended =
        baseGoalCorrectAnswers + _goalCorrectAnswersDelta(plan);
    if (taskCount != null) {
      return _clampInt(recommended, 1, max(1, taskCount));
    }
    return max(1, recommended);
  }

  static int allowedMistakesFor({
    required StudyHarmonyDifficultyPlan plan,
    required int recommendedStartingLives,
  }) {
    return _allowedMistakes(
      recommendedStartingLives: recommendedStartingLives,
      pressureBudget: _pressureBudget(plan),
      forgivenessBuffer: _forgivenessBuffer(plan),
    );
  }

  static int pressureBudgetFor(StudyHarmonyDifficultyPlan plan) {
    return _pressureBudget(plan);
  }

  static int forgivenessBufferFor(StudyHarmonyDifficultyPlan plan) {
    return _forgivenessBuffer(plan);
  }

  static double pressureMultiplierFor(StudyHarmonyDifficultyPlan plan) {
    final pressureBudget = _pressureBudget(plan);
    return _pressureMultiplier(plan, pressureBudget);
  }

  static double forgivenessMultiplierFor(
    StudyHarmonyDifficultyPlan plan, {
    required int recommendedStartingLives,
  }) {
    final pressureBudget = _pressureBudget(plan);
    final forgivenessBuffer = _forgivenessBuffer(plan);
    final allowedMistakes = _allowedMistakes(
      recommendedStartingLives: recommendedStartingLives,
      pressureBudget: pressureBudget,
      forgivenessBuffer: forgivenessBuffer,
    );
    return _forgivenessMultiplier(plan, forgivenessBuffer, allowedMistakes);
  }

  static int _startingLivesDelta(StudyHarmonyDifficultyPlan plan) {
    final laneDelta = switch (plan.difficultyLane) {
      StudyHarmonyDifficultyLane.recovery => 1,
      StudyHarmonyDifficultyLane.groove => 1,
      StudyHarmonyDifficultyLane.push => 0,
      StudyHarmonyDifficultyLane.clutch => -1,
      StudyHarmonyDifficultyLane.legend => -1,
    };
    final pressureDelta = switch (plan.pressureTier) {
      StudyHarmonyPressureTier.calm => 1,
      StudyHarmonyPressureTier.steady => 0,
      StudyHarmonyPressureTier.hot => 0,
      StudyHarmonyPressureTier.charged => -1,
      StudyHarmonyPressureTier.overdrive => -1,
    };
    final forgivenessDelta = switch (plan.forgivenessTier) {
      StudyHarmonyForgivenessTier.strict => -1,
      StudyHarmonyForgivenessTier.tight => 0,
      StudyHarmonyForgivenessTier.balanced => 0,
      StudyHarmonyForgivenessTier.kind => 1,
      StudyHarmonyForgivenessTier.generous => 2,
    };
    final momentumDelta = plan.frustrationScore > 0.6 ? 1 : 0;

    return _clampInt(
      laneDelta + pressureDelta + forgivenessDelta + momentumDelta,
      -2,
      3,
    );
  }

  static int _goalCorrectAnswersDelta(StudyHarmonyDifficultyPlan plan) {
    final laneDelta = switch (plan.difficultyLane) {
      StudyHarmonyDifficultyLane.recovery => -1,
      StudyHarmonyDifficultyLane.groove => 0,
      StudyHarmonyDifficultyLane.push => 1,
      StudyHarmonyDifficultyLane.clutch => 2,
      StudyHarmonyDifficultyLane.legend => 3,
    };
    final pressureDelta = switch (plan.pressureTier) {
      StudyHarmonyPressureTier.calm => -1,
      StudyHarmonyPressureTier.steady => 0,
      StudyHarmonyPressureTier.hot => 1,
      StudyHarmonyPressureTier.charged => 1,
      StudyHarmonyPressureTier.overdrive => 2,
    };
    final forgivenessDelta = switch (plan.forgivenessTier) {
      StudyHarmonyForgivenessTier.strict => -1,
      StudyHarmonyForgivenessTier.tight => 0,
      StudyHarmonyForgivenessTier.balanced => 0,
      StudyHarmonyForgivenessTier.kind => 1,
      StudyHarmonyForgivenessTier.generous => 1,
    };
    final skillDelta = ((plan.skillScore - 0.5) * 2).round();
    final frustrationDelta = plan.frustrationScore > 0.65 ? -1 : 0;

    return _clampInt(
      laneDelta + pressureDelta + forgivenessDelta + skillDelta + frustrationDelta,
      -2,
      4,
    );
  }

  static int _pressureBudget(StudyHarmonyDifficultyPlan plan) {
    final laneBudget = plan.difficultyLane.index ~/ 2;
    final remixBoost = plan.remixIntensity >= 0.7 ? 1 : 0;
    return _clampInt(1 + plan.pressureTier.index + laneBudget + remixBoost, 1, 8);
  }

  static int _forgivenessBuffer(StudyHarmonyDifficultyPlan plan) {
    final tierBoost = switch (plan.forgivenessTier) {
      StudyHarmonyForgivenessTier.strict => 0,
      StudyHarmonyForgivenessTier.tight => 0,
      StudyHarmonyForgivenessTier.balanced => 1,
      StudyHarmonyForgivenessTier.kind => 2,
      StudyHarmonyForgivenessTier.generous => 3,
    };
    final pressurePenalty = plan.pressureTier.index ~/ 2;
    final frustrationBoost = plan.frustrationScore > 0.6 ? 1 : 0;
    return _clampInt(tierBoost - pressurePenalty + frustrationBoost, 0, 6);
  }

  static int _allowedMistakes({
    required int recommendedStartingLives,
    required int pressureBudget,
    required int forgivenessBuffer,
  }) {
    return _clampInt(
      (recommendedStartingLives - 1) + forgivenessBuffer - (pressureBudget ~/ 2),
      0,
      8,
    );
  }

  static double _pressureMultiplier(
    StudyHarmonyDifficultyPlan plan,
    int pressureBudget,
  ) {
    return _clampDouble(
      0.9 +
          (pressureBudget * 0.09) +
          (plan.bonusAggressiveness * 0.08) +
          (plan.difficultyLane.index * 0.02),
      0.75,
      1.8,
    );
  }

  static double _forgivenessMultiplier(
    StudyHarmonyDifficultyPlan plan,
    int forgivenessBuffer,
    int allowedMistakes,
  ) {
    return _clampDouble(
      0.95 +
          (forgivenessBuffer * 0.11) +
          (allowedMistakes * 0.05) -
          (plan.pressureTier.index * 0.03),
      0.8,
      1.9,
    );
  }

  static List<String> _buildRuntimeRationale({
    required StudyHarmonyDifficultyPlan plan,
    required int recommendedStartingLives,
    required int recommendedGoalCorrectAnswers,
    required int allowedMistakes,
    required int pressureBudget,
    required int forgivenessBuffer,
  }) {
    final notes = <String>[
      'Base lives $recommendedStartingLives and goal $recommendedGoalCorrectAnswers were derived from the difficulty lane.',
    ];

    notes.add('Pressure budget settled at $pressureBudget for the current pace.');
    notes.add('Forgiveness buffer settled at $forgivenessBuffer to keep recovery readable.');
    notes.add('Allowed mistakes resolved to $allowedMistakes from the live budget and pressure.');

    if (plan.frustrationScore > 0.6) {
      notes.add('Recent struggle kept the runtime tuning softer than the lane alone would suggest.');
    }
    if (plan.skillScore > 0.7) {
      notes.add('Recent consistency allowed the target to climb without extra life inflation.');
    }

    return notes.length > 6 ? notes.sublist(0, 6) : notes;
  }
}

class StudyHarmonyDifficultyDesign {
  const StudyHarmonyDifficultyDesign._();

  static StudyHarmonyModeDifficultyProfile profileForMode(
    StudyHarmonySessionMode mode,
  ) {
    return switch (mode) {
      StudyHarmonySessionMode.legacyLevel =>
        const StudyHarmonyModeDifficultyProfile(
          mode: StudyHarmonySessionMode.legacyLevel,
          lane: StudyHarmonyDifficultyLane.recovery,
          pressureTier: StudyHarmonyPressureTier.calm,
          forgivenessTier: StudyHarmonyForgivenessTier.generous,
          sessionLength: Duration(minutes: 7),
          minSessionLength: Duration(minutes: 4),
          maxSessionLength: Duration(minutes: 10),
          heartBudget: 4,
          comboTarget: 3,
          bonusAggressiveness: 0.3,
          remixIntensity: 0.1,
          warmupShare: 0.36,
          tensionShare: 0.24,
          releaseShare: 0.2,
          rewardShare: 0.2,
          description:
              'Compatibility fallback with gentle pacing for older legacy levels.',
        ),
      StudyHarmonySessionMode.lesson => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.lesson,
        lane: StudyHarmonyDifficultyLane.groove,
        pressureTier: StudyHarmonyPressureTier.steady,
        forgivenessTier: StudyHarmonyForgivenessTier.generous,
        sessionLength: Duration(minutes: 8),
        minSessionLength: Duration(minutes: 5),
        maxSessionLength: Duration(minutes: 12),
        heartBudget: 4,
        comboTarget: 4,
        bonusAggressiveness: 0.45,
        remixIntensity: 0.2,
        warmupShare: 0.32,
        tensionShare: 0.28,
        releaseShare: 0.15,
        rewardShare: 0.25,
        description:
            'Warm onboarding with short wins, gentle ramping, and a clean exit.',
      ),
      StudyHarmonySessionMode.review => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.review,
        lane: StudyHarmonyDifficultyLane.recovery,
        pressureTier: StudyHarmonyPressureTier.calm,
        forgivenessTier: StudyHarmonyForgivenessTier.kind,
        sessionLength: Duration(minutes: 6),
        minSessionLength: Duration(minutes: 4),
        maxSessionLength: Duration(minutes: 10),
        heartBudget: 5,
        comboTarget: 3,
        bonusAggressiveness: 0.38,
        remixIntensity: 0.12,
        warmupShare: 0.4,
        tensionShare: 0.22,
        releaseShare: 0.18,
        rewardShare: 0.2,
        description:
            'Low-friction recovery runs that rebuild confidence and clear weak spots.',
      ),
      StudyHarmonySessionMode.daily => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.daily,
        lane: StudyHarmonyDifficultyLane.push,
        pressureTier: StudyHarmonyPressureTier.hot,
        forgivenessTier: StudyHarmonyForgivenessTier.balanced,
        sessionLength: Duration(minutes: 10),
        minSessionLength: Duration(minutes: 7),
        maxSessionLength: Duration(minutes: 14),
        heartBudget: 3,
        comboTarget: 6,
        bonusAggressiveness: 0.6,
        remixIntensity: 0.35,
        warmupShare: 0.22,
        tensionShare: 0.35,
        releaseShare: 0.13,
        rewardShare: 0.3,
        description:
            'Balanced daily spike with enough tension to feel like a proper match.',
      ),
      StudyHarmonySessionMode.focus => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.focus,
        lane: StudyHarmonyDifficultyLane.push,
        pressureTier: StudyHarmonyPressureTier.hot,
        forgivenessTier: StudyHarmonyForgivenessTier.kind,
        sessionLength: Duration(minutes: 12),
        minSessionLength: Duration(minutes: 8),
        maxSessionLength: Duration(minutes: 16),
        heartBudget: 3,
        comboTarget: 7,
        bonusAggressiveness: 0.55,
        remixIntensity: 0.25,
        warmupShare: 0.24,
        tensionShare: 0.4,
        releaseShare: 0.1,
        rewardShare: 0.26,
        description:
            'Longer concentration runs that hold attention on one skill at a time.',
      ),
      StudyHarmonySessionMode.relay => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.relay,
        lane: StudyHarmonyDifficultyLane.clutch,
        pressureTier: StudyHarmonyPressureTier.charged,
        forgivenessTier: StudyHarmonyForgivenessTier.tight,
        sessionLength: Duration(minutes: 5),
        minSessionLength: Duration(minutes: 3),
        maxSessionLength: Duration(minutes: 8),
        heartBudget: 2,
        comboTarget: 9,
        bonusAggressiveness: 0.8,
        remixIntensity: 0.65,
        warmupShare: 0.14,
        tensionShare: 0.56,
        releaseShare: 0.05,
        rewardShare: 0.25,
        description:
            'Fast score-chasing bursts with compact risk and energetic remixing.',
      ),
      StudyHarmonySessionMode.bossRush => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.bossRush,
        lane: StudyHarmonyDifficultyLane.legend,
        pressureTier: StudyHarmonyPressureTier.overdrive,
        forgivenessTier: StudyHarmonyForgivenessTier.strict,
        sessionLength: Duration(minutes: 14),
        minSessionLength: Duration(minutes: 8),
        maxSessionLength: Duration(minutes: 18),
        heartBudget: 2,
        comboTarget: 11,
        bonusAggressiveness: 0.95,
        remixIntensity: 0.8,
        warmupShare: 0.1,
        tensionShare: 0.68,
        releaseShare: 0.05,
        rewardShare: 0.17,
        description:
            'High-pressure gauntlet that makes every clear feel like a boss kill.',
      ),
      StudyHarmonySessionMode.legend => const StudyHarmonyModeDifficultyProfile(
        mode: StudyHarmonySessionMode.legend,
        lane: StudyHarmonyDifficultyLane.legend,
        pressureTier: StudyHarmonyPressureTier.overdrive,
        forgivenessTier: StudyHarmonyForgivenessTier.tight,
        sessionLength: Duration(minutes: 16),
        minSessionLength: Duration(minutes: 10),
        maxSessionLength: Duration(minutes: 22),
        heartBudget: 3,
        comboTarget: 12,
        bonusAggressiveness: 1.0,
        remixIntensity: 0.9,
        warmupShare: 0.08,
        tensionShare: 0.7,
        releaseShare: 0.02,
        rewardShare: 0.2,
        description:
            'Finale-tier marathon play with theatrical peaks and big payoff windows.',
      ),
    };
  }

  static StudyHarmonyDifficultyPlan design({
    required StudyHarmonySessionMode mode,
    required StudyHarmonyDifficultyInput input,
  }) {
    final profile = profileForMode(mode);
    final skillScore = _clampDouble(
      _weightedAverage(
        [
          input.normalizedSkillRating,
          input.normalizedRecentAccuracy,
          input.normalizedRecentStability,
          input.normalizedRecentComboPeak,
          max(0.0, input.normalizedRecentMomentum),
        ],
        const [0.28, 0.28, 0.2, 0.14, 0.1],
      ),
      0,
      1,
    );
    final frustrationScore = _clampDouble(
      _weightedAverage(
        [
          input.normalizedRecentStruggleRate,
          1 - input.normalizedRecentAccuracy,
          1 - input.normalizedRecentStability,
          max(0.0, -input.normalizedRecentMomentum),
        ],
        const [0.35, 0.25, 0.2, 0.2],
      ),
      0,
      1,
    );

    final difficultyLane = _laneForScore(
      profile.lane.index + (skillScore * 1.15) - (frustrationScore * 1.75),
    );
    final pressureTier = _pressureForScore(
      profile.pressureTier.index +
          (skillScore * 0.75) -
          (frustrationScore * 1.15) +
          _modePressureBias(mode),
    );
    final forgivenessTier = _forgivenessForScore(
      profile.forgivenessTier.index +
          (frustrationScore * 1.7) -
          (skillScore * 0.6) +
          _modeForgivenessBias(mode),
    );

    final sessionLengthSuggestion = _sessionLengthSuggestion(
      profile: profile,
      skillScore: skillScore,
      frustrationScore: frustrationScore,
      preferredSessionMinutes: input.preferredSessionMinutes,
    );
    final heartBudget = _heartBudget(
      profile: profile,
      pressureTier: pressureTier,
      forgivenessTier: forgivenessTier,
      frustrationScore: frustrationScore,
    );
    final comboTarget = _comboTarget(
      profile: profile,
      difficultyLane: difficultyLane,
      skillScore: skillScore,
      frustrationScore: frustrationScore,
    );
    final bonusAggressiveness = _clampDouble(
      profile.bonusAggressiveness +
          (skillScore * 0.16) -
          (frustrationScore * 0.2) +
          (_pressureIndex(pressureTier) * 0.03),
      0,
      1,
    );
    final remixIntensity = _clampDouble(
      profile.remixIntensity +
          (skillScore * 0.12) -
          (frustrationScore * 0.22) +
          _modeRemixBias(mode),
      0,
      1,
    );
    final pacingPlan = _buildPacingPlan(
      profile: profile,
      totalDuration: sessionLengthSuggestion,
      skillScore: skillScore,
      frustrationScore: frustrationScore,
      pressureTier: pressureTier,
      forgivenessTier: forgivenessTier,
    );

    return StudyHarmonyDifficultyPlan(
      mode: mode,
      modeProfile: profile,
      skillScore: skillScore,
      frustrationScore: frustrationScore,
      difficultyLane: difficultyLane,
      pressureTier: pressureTier,
      forgivenessTier: forgivenessTier,
      sessionLengthSuggestion: sessionLengthSuggestion,
      heartBudget: heartBudget,
      comboTarget: comboTarget,
      bonusAggressiveness: bonusAggressiveness,
      remixIntensity: remixIntensity,
      pacingPlan: pacingPlan,
      rationale: _buildRationale(
        mode: mode,
        profile: profile,
        skillScore: skillScore,
        frustrationScore: frustrationScore,
        difficultyLane: difficultyLane,
        pressureTier: pressureTier,
        forgivenessTier: forgivenessTier,
        sessionLengthSuggestion: sessionLengthSuggestion,
        heartBudget: heartBudget,
        comboTarget: comboTarget,
        preferredSessionMinutes: input.preferredSessionMinutes,
      ),
    );
  }

  static StudyHarmonyDifficultyLane _laneForScore(double score) {
    if (score < 0.7) {
      return StudyHarmonyDifficultyLane.recovery;
    }
    if (score < 1.5) {
      return StudyHarmonyDifficultyLane.groove;
    }
    if (score < 2.5) {
      return StudyHarmonyDifficultyLane.push;
    }
    if (score < 3.5) {
      return StudyHarmonyDifficultyLane.clutch;
    }
    return StudyHarmonyDifficultyLane.legend;
  }

  static StudyHarmonyPressureTier _pressureForScore(double score) {
    if (score < 0.7) {
      return StudyHarmonyPressureTier.calm;
    }
    if (score < 1.5) {
      return StudyHarmonyPressureTier.steady;
    }
    if (score < 2.5) {
      return StudyHarmonyPressureTier.hot;
    }
    if (score < 3.5) {
      return StudyHarmonyPressureTier.charged;
    }
    return StudyHarmonyPressureTier.overdrive;
  }

  static StudyHarmonyForgivenessTier _forgivenessForScore(double score) {
    if (score < 0.7) {
      return StudyHarmonyForgivenessTier.strict;
    }
    if (score < 1.5) {
      return StudyHarmonyForgivenessTier.tight;
    }
    if (score < 2.5) {
      return StudyHarmonyForgivenessTier.balanced;
    }
    if (score < 3.5) {
      return StudyHarmonyForgivenessTier.kind;
    }
    return StudyHarmonyForgivenessTier.generous;
  }

  static Duration _sessionLengthSuggestion({
    required StudyHarmonyModeDifficultyProfile profile,
    required double skillScore,
    required double frustrationScore,
    required int? preferredSessionMinutes,
  }) {
    final baseMinutes = profile.sessionLength.inMinutes;
    final skillShift = ((skillScore - 0.5) * 4).round();
    final frustrationShift = (frustrationScore * 5).round();
    var suggestedMinutes = baseMinutes + skillShift - frustrationShift;
    suggestedMinutes = _clampInt(
      suggestedMinutes,
      profile.minSessionLength.inMinutes,
      profile.maxSessionLength.inMinutes,
    );

    if (preferredSessionMinutes != null) {
      final blendedMinutes =
          (suggestedMinutes * 0.7) +
          (_clampInt(
                preferredSessionMinutes,
                profile.minSessionLength.inMinutes,
                profile.maxSessionLength.inMinutes,
              ) *
              0.3);
      suggestedMinutes = _clampInt(
        blendedMinutes.round(),
        profile.minSessionLength.inMinutes,
        profile.maxSessionLength.inMinutes,
      );
    }

    return Duration(minutes: suggestedMinutes);
  }

  static int _heartBudget({
    required StudyHarmonyModeDifficultyProfile profile,
    required StudyHarmonyPressureTier pressureTier,
    required StudyHarmonyForgivenessTier forgivenessTier,
    required double frustrationScore,
  }) {
    final forgivenessDelta =
        forgivenessTier.index - profile.forgivenessTier.index;
    final pressureDelta = pressureTier.index - profile.pressureTier.index;
    final frustrationBonus = frustrationScore > 0.6 ? 1 : 0;

    return _clampInt(
      profile.heartBudget +
          forgivenessDelta -
          max(0, pressureDelta).toInt() +
          frustrationBonus,
      1,
      7,
    );
  }

  static int _comboTarget({
    required StudyHarmonyModeDifficultyProfile profile,
    required StudyHarmonyDifficultyLane difficultyLane,
    required double skillScore,
    required double frustrationScore,
  }) {
    final laneDelta = difficultyLane.index - profile.lane.index;
    final skillBonus = (skillScore * 5).round();
    final frustrationPenalty = (frustrationScore * 4).round();

    return _clampInt(
      profile.comboTarget + laneDelta + skillBonus - frustrationPenalty,
      2,
      20,
    );
  }

  static StudyHarmonyPacingPlan _buildPacingPlan({
    required StudyHarmonyModeDifficultyProfile profile,
    required Duration totalDuration,
    required double skillScore,
    required double frustrationScore,
    required StudyHarmonyPressureTier pressureTier,
    required StudyHarmonyForgivenessTier forgivenessTier,
  }) {
    final warmupShare = _clampDouble(
      profile.warmupShare +
          ((1 - skillScore) * 0.08) +
          (frustrationScore * 0.1),
      0.05,
      0.5,
    );
    final tensionShare = _clampDouble(
      profile.tensionShare +
          (skillScore * 0.05) +
          (_pressureIndex(pressureTier) >= 2 ? 0.04 : 0) -
          (frustrationScore * 0.03),
      0.1,
      0.7,
    );
    final releaseShare = _clampDouble(
      profile.releaseShare +
          ((1 - skillScore) * 0.03) +
          (frustrationScore * 0.08),
      0.02,
      0.35,
    );
    final rewardShare = _clampDouble(
      profile.rewardShare +
          (skillScore * 0.05) +
          (_forgivenessIndex(forgivenessTier) >= 3 ? 0.03 : 0),
      0.1,
      0.4,
    );

    return StudyHarmonyPacingPlan.fromShares(
      totalDuration: totalDuration,
      warmupShare: warmupShare,
      tensionShare: tensionShare,
      releaseShare: releaseShare,
      rewardShare: rewardShare,
    );
  }

  static List<String> _buildRationale({
    required StudyHarmonySessionMode mode,
    required StudyHarmonyModeDifficultyProfile profile,
    required double skillScore,
    required double frustrationScore,
    required StudyHarmonyDifficultyLane difficultyLane,
    required StudyHarmonyPressureTier pressureTier,
    required StudyHarmonyForgivenessTier forgivenessTier,
    required Duration sessionLengthSuggestion,
    required int heartBudget,
    required int comboTarget,
    required int? preferredSessionMinutes,
  }) {
    final notes = <String>[profile.description];

    if (skillScore >= 0.7) {
      notes.add('Recent play looks stable, so the lane stepped up.');
    } else if (skillScore <= 0.35) {
      notes.add('The lane stayed gentle to protect flow and confidence.');
    }

    if (frustrationScore >= 0.6) {
      notes.add('Recent struggle raised forgiveness and recovery windows.');
    } else if (frustrationScore <= 0.25) {
      notes.add('Low frustration let the pressure stay sharper.');
    }

    if (difficultyLane.index > profile.lane.index) {
      notes.add('The difficulty lane climbed above the mode baseline.');
    } else if (difficultyLane.index < profile.lane.index) {
      notes.add('The difficulty lane dropped below the mode baseline.');
    }

    if (pressureTier.index >= StudyHarmonyPressureTier.charged.index) {
      notes.add('The pacing keeps the challenge window front-loaded.');
    }
    if (heartBudget > profile.heartBudget) {
      notes.add('A wider heart budget protects the run from early tilt.');
    }
    if (comboTarget > profile.comboTarget) {
      notes.add('The combo target was expanded to keep mastery rewarding.');
    }
    if (sessionLengthSuggestion.inMinutes < profile.sessionLength.inMinutes) {
      notes.add('The session was shortened so the run can end on a high note.');
    } else if (sessionLengthSuggestion.inMinutes >
        profile.sessionLength.inMinutes) {
      notes.add('The session was extended to let the score chase breathe.');
    }
    if (preferredSessionMinutes != null) {
      notes.add('Player playtime preference was blended into the suggestion.');
    }

    if (mode == StudyHarmonySessionMode.review ||
        mode == StudyHarmonySessionMode.lesson) {
      notes.add(
        'The rhythm favors a bigger recovery beat than the high-pressure modes.',
      );
    }

    if (notes.length > 6) {
      return notes.sublist(0, 6);
    }
    return notes;
  }

  static int _pressureIndex(StudyHarmonyPressureTier tier) => tier.index;

  static int _forgivenessIndex(StudyHarmonyForgivenessTier tier) => tier.index;

  static double _modePressureBias(StudyHarmonySessionMode mode) {
    return switch (mode) {
      StudyHarmonySessionMode.legacyLevel => 0.0,
      StudyHarmonySessionMode.lesson => -0.05,
      StudyHarmonySessionMode.review => -0.1,
      StudyHarmonySessionMode.daily => 0.05,
      StudyHarmonySessionMode.focus => 0.1,
      StudyHarmonySessionMode.relay => 0.18,
      StudyHarmonySessionMode.bossRush => 0.28,
      StudyHarmonySessionMode.legend => 0.24,
    };
  }

  static double _modeForgivenessBias(StudyHarmonySessionMode mode) {
    return switch (mode) {
      StudyHarmonySessionMode.legacyLevel => 0.1,
      StudyHarmonySessionMode.lesson => 0.15,
      StudyHarmonySessionMode.review => 0.2,
      StudyHarmonySessionMode.daily => 0.05,
      StudyHarmonySessionMode.focus => 0.02,
      StudyHarmonySessionMode.relay => -0.05,
      StudyHarmonySessionMode.bossRush => -0.15,
      StudyHarmonySessionMode.legend => -0.1,
    };
  }

  static double _modeRemixBias(StudyHarmonySessionMode mode) {
    return switch (mode) {
      StudyHarmonySessionMode.legacyLevel => -0.05,
      StudyHarmonySessionMode.lesson => 0.0,
      StudyHarmonySessionMode.review => -0.03,
      StudyHarmonySessionMode.daily => 0.02,
      StudyHarmonySessionMode.focus => 0.0,
      StudyHarmonySessionMode.relay => 0.07,
      StudyHarmonySessionMode.bossRush => 0.09,
      StudyHarmonySessionMode.legend => 0.11,
    };
  }
}

class _PendingSegment {
  _PendingSegment({
    required this.kind,
    required this.share,
    required this.exactMinutes,
    required this.minutes,
  });

  final StudyHarmonyRhythmBeatKind kind;
  final double share;
  final double exactMinutes;
  int minutes;
}

String _beatLabel(StudyHarmonyRhythmBeatKind kind) {
  return switch (kind) {
    StudyHarmonyRhythmBeatKind.warmup => 'Warmup',
    StudyHarmonyRhythmBeatKind.tension => 'Tension',
    StudyHarmonyRhythmBeatKind.release => 'Release',
    StudyHarmonyRhythmBeatKind.reward => 'Reward',
  };
}

int _beatKindOrder(StudyHarmonyRhythmBeatKind kind) {
  return switch (kind) {
    StudyHarmonyRhythmBeatKind.warmup => 0,
    StudyHarmonyRhythmBeatKind.tension => 1,
    StudyHarmonyRhythmBeatKind.release => 2,
    StudyHarmonyRhythmBeatKind.reward => 3,
  };
}
