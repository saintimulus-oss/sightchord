import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../domain/study_harmony_progress_models.dart';
import '../domain/study_harmony_session_models.dart';

enum StudyHarmonyAgeBand { child, teen, youngAdult, adult, mature }

enum StudyHarmonySkillBand {
  newcomer,
  beginner,
  developing,
  strong,
  advanced,
  expert,
}

enum StudyHarmonyPlayStyle {
  competitor,
  collector,
  explorer,
  stabilizer,
  balanced,
}

enum StudyHarmonySessionLengthPreference {
  micro,
  short,
  medium,
  long,
  marathon,
}

enum StudyHarmonyRegionFlavor {
  global,
  eastAsia,
  southeastAsia,
  southAsia,
  europe,
  northAmerica,
  latinAmerica,
  middleEast,
  africa,
  oceania,
}

enum StudyHarmonyGameplayAxis {
  competition,
  collection,
  exploration,
  stability,
}

enum StudyHarmonyToneStyle { warm, playful, calm, focused, celebratory }

enum StudyHarmonyCoachStyle {
  supportive,
  structured,
  challengeForward,
  analytical,
  restorative,
}

enum StudyHarmonyOnboardingIntensity { minimal, light, guided, immersive }

enum StudyHarmonyRemediationStyle {
  gentleNudge,
  scaffolded,
  targetedDrill,
  resetAndRetry,
  confidenceRebuild,
}

enum StudyHarmonyRewardFocus {
  mastery,
  achievements,
  cosmetics,
  currency,
  collection,
}

@immutable
class StudyHarmonyGameplayAffinity {
  const StudyHarmonyGameplayAffinity({
    required this.competition,
    required this.collection,
    required this.exploration,
    required this.stability,
  });

  factory StudyHarmonyGameplayAffinity.balanced() {
    return const StudyHarmonyGameplayAffinity(
      competition: 0.5,
      collection: 0.5,
      exploration: 0.5,
      stability: 0.5,
    );
  }

  final double competition;
  final double collection;
  final double exploration;
  final double stability;

  StudyHarmonyGameplayAxis get dominantAxis {
    final entries = <MapEntry<StudyHarmonyGameplayAxis, double>>[
      MapEntry(StudyHarmonyGameplayAxis.competition, competition),
      MapEntry(StudyHarmonyGameplayAxis.collection, collection),
      MapEntry(StudyHarmonyGameplayAxis.exploration, exploration),
      MapEntry(StudyHarmonyGameplayAxis.stability, stability),
    ];
    entries.sort((left, right) => right.value.compareTo(left.value));
    return entries.first.key;
  }

  StudyHarmonyGameplayAffinity copyWith({
    double? competition,
    double? collection,
    double? exploration,
    double? stability,
  }) {
    return StudyHarmonyGameplayAffinity(
      competition: competition ?? this.competition,
      collection: collection ?? this.collection,
      exploration: exploration ?? this.exploration,
      stability: stability ?? this.stability,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyGameplayAffinity &&
        other.competition == competition &&
        other.collection == collection &&
        other.exploration == exploration &&
        other.stability == stability;
  }

  @override
  int get hashCode =>
      Object.hash(competition, collection, exploration, stability);
}

@immutable
class StudyHarmonyPersonalizationProfile {
  const StudyHarmonyPersonalizationProfile({
    required this.ageBand,
    required this.skillBand,
    required this.playStyle,
    required this.sessionLengthPreference,
    required this.regionFlavor,
    this.gameplayAffinity = const StudyHarmonyGameplayAffinity(
      competition: 0.5,
      collection: 0.5,
      exploration: 0.5,
      stability: 0.5,
    ),
    this.countryCode,
    this.localeTag,
    this.selfDescribedGenderLabel,
  });

  final StudyHarmonyAgeBand ageBand;
  final StudyHarmonySkillBand skillBand;
  final StudyHarmonyPlayStyle playStyle;
  final StudyHarmonySessionLengthPreference sessionLengthPreference;
  final StudyHarmonyRegionFlavor regionFlavor;
  final StudyHarmonyGameplayAffinity gameplayAffinity;
  final String? countryCode;
  final String? localeTag;
  final String? selfDescribedGenderLabel;

  StudyHarmonyPersonalizationProfile copyWith({
    StudyHarmonyAgeBand? ageBand,
    StudyHarmonySkillBand? skillBand,
    StudyHarmonyPlayStyle? playStyle,
    StudyHarmonySessionLengthPreference? sessionLengthPreference,
    StudyHarmonyRegionFlavor? regionFlavor,
    StudyHarmonyGameplayAffinity? gameplayAffinity,
    String? countryCode,
    String? localeTag,
    String? selfDescribedGenderLabel,
    bool clearCountryCode = false,
    bool clearLocaleTag = false,
    bool clearSelfDescribedGenderLabel = false,
  }) {
    return StudyHarmonyPersonalizationProfile(
      ageBand: ageBand ?? this.ageBand,
      skillBand: skillBand ?? this.skillBand,
      playStyle: playStyle ?? this.playStyle,
      sessionLengthPreference:
          sessionLengthPreference ?? this.sessionLengthPreference,
      regionFlavor: regionFlavor ?? this.regionFlavor,
      gameplayAffinity: gameplayAffinity ?? this.gameplayAffinity,
      countryCode: clearCountryCode ? null : countryCode ?? this.countryCode,
      localeTag: clearLocaleTag ? null : localeTag ?? this.localeTag,
      selfDescribedGenderLabel: clearSelfDescribedGenderLabel
          ? null
          : selfDescribedGenderLabel ?? this.selfDescribedGenderLabel,
    );
  }

  StudyHarmonyRegionFlavor effectiveRegionFlavor() {
    if (regionFlavor != StudyHarmonyRegionFlavor.global) {
      return regionFlavor;
    }
    return studyHarmonyRegionFlavorFromCountryCode(countryCode);
  }

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyPersonalizationProfile &&
        other.ageBand == ageBand &&
        other.skillBand == skillBand &&
        other.playStyle == playStyle &&
        other.sessionLengthPreference == sessionLengthPreference &&
        other.regionFlavor == regionFlavor &&
        other.gameplayAffinity == gameplayAffinity &&
        other.countryCode == countryCode &&
        other.localeTag == localeTag &&
        other.selfDescribedGenderLabel == selfDescribedGenderLabel;
  }

  @override
  int get hashCode => Object.hash(
    ageBand,
    skillBand,
    playStyle,
    sessionLengthPreference,
    regionFlavor,
    gameplayAffinity,
    countryCode,
    localeTag,
    selfDescribedGenderLabel,
  );
}

@immutable
class StudyHarmonyRecentPerformance {
  const StudyHarmonyRecentPerformance({
    required this.averageAccuracy,
    required this.clearRate,
    required this.masteryMomentum,
    required this.confidence,
    required this.recoveryNeed,
    required this.lessonResultCount,
    required this.activeDayCount,
    required this.reviewQueueCount,
    required this.weakSpotCount,
    required this.bestStreakCount,
  });

  factory StudyHarmonyRecentPerformance.fromProgressSnapshot(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    final lessonResults = snapshot.lessonResults.values.toList(growable: false);
    final accuracies = <double>[];
    final clearCount = lessonResults.where((result) => result.isCleared).length;
    for (final result in lessonResults) {
      final weight = math.max(1, result.playCount).toDouble();
      for (var i = 0; i < weight; i += 1) {
        accuracies.add(result.bestAccuracy);
      }
    }

    final masteryValues = snapshot.skillMasteryPlaceholders.values.toList(
      growable: false,
    );
    final masteryMomentum = _mean([
      if (masteryValues.isNotEmpty)
        _mean([
          for (final mastery in masteryValues)
            _clamp01((mastery.masteryScore + mastery.recentAccuracy) / 2),
        ]),
      if (lessonResults.isNotEmpty)
        _mean([
          for (final result in lessonResults)
            _clamp01((result.bestAccuracy + (result.bestStars / 3)) / 2),
        ]),
    ]);

    final confidence = _mean([
      if (lessonResults.isNotEmpty)
        _mean([
          for (final result in lessonResults)
            _clamp01((result.bestStars / 3) * 0.7 + result.bestAccuracy * 0.3),
        ]),
      if (masteryValues.isNotEmpty)
        _mean([
          for (final mastery in masteryValues)
            _clamp01(
              (mastery.confidenceStreak / 6) * 0.5 +
                  mastery.recentAccuracy * 0.5,
            ),
        ]),
    ]);

    final averageAccuracy = accuracies.isEmpty ? 0.0 : _mean(accuracies);
    final clearRate = lessonResults.isEmpty
        ? 0.0
        : clearCount / lessonResults.length;
    final weakSpotCount =
        snapshot.reviewQueuePlaceholders.length +
        lessonResults.where((result) => result.bestAccuracy < 0.75).length;
    final bestStreakCount = math.max(
      snapshot.bestDailyChallengeStreak,
      snapshot.bestDuetPactStreak,
    );
    final activeDayCount = snapshot.activityDateKeys.length;
    final recoveryNeed = _clamp01(
      (1 - averageAccuracy) * 0.5 +
          (1 - clearRate) * 0.3 +
          (weakSpotCount / math.max(1, lessonResults.length + 1)) * 0.2,
    );

    return StudyHarmonyRecentPerformance(
      averageAccuracy: averageAccuracy,
      clearRate: clearRate,
      masteryMomentum: masteryMomentum,
      confidence: confidence,
      recoveryNeed: recoveryNeed,
      lessonResultCount: lessonResults.length,
      activeDayCount: activeDayCount,
      reviewQueueCount: snapshot.reviewQueuePlaceholders.length,
      weakSpotCount: weakSpotCount,
      bestStreakCount: bestStreakCount,
    );
  }

  final double averageAccuracy;
  final double clearRate;
  final double masteryMomentum;
  final double confidence;
  final double recoveryNeed;
  final int lessonResultCount;
  final int activeDayCount;
  final int reviewQueueCount;
  final int weakSpotCount;
  final int bestStreakCount;

  bool get hasMeaningfulData =>
      lessonResultCount > 0 || reviewQueueCount > 0 || activeDayCount > 0;

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyRecentPerformance &&
        other.averageAccuracy == averageAccuracy &&
        other.clearRate == clearRate &&
        other.masteryMomentum == masteryMomentum &&
        other.confidence == confidence &&
        other.recoveryNeed == recoveryNeed &&
        other.lessonResultCount == lessonResultCount &&
        other.activeDayCount == activeDayCount &&
        other.reviewQueueCount == reviewQueueCount &&
        other.weakSpotCount == weakSpotCount &&
        other.bestStreakCount == bestStreakCount;
  }

  @override
  int get hashCode => Object.hash(
    averageAccuracy,
    clearRate,
    masteryMomentum,
    confidence,
    recoveryNeed,
    lessonResultCount,
    activeDayCount,
    reviewQueueCount,
    weakSpotCount,
    bestStreakCount,
  );
}

@immutable
class StudyHarmonyRewardEmphasis {
  const StudyHarmonyRewardEmphasis({
    required this.mastery,
    required this.achievements,
    required this.cosmetics,
    required this.currency,
    required this.collection,
  });

  final double mastery;
  final double achievements;
  final double cosmetics;
  final double currency;
  final double collection;

  StudyHarmonyRewardFocus get primaryFocus {
    final ranked = <MapEntry<StudyHarmonyRewardFocus, double>>[
      MapEntry(StudyHarmonyRewardFocus.mastery, mastery),
      MapEntry(StudyHarmonyRewardFocus.achievements, achievements),
      MapEntry(StudyHarmonyRewardFocus.cosmetics, cosmetics),
      MapEntry(StudyHarmonyRewardFocus.currency, currency),
      MapEntry(StudyHarmonyRewardFocus.collection, collection),
    ]..sort((left, right) => right.value.compareTo(left.value));
    return ranked.first.key;
  }

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyRewardEmphasis &&
        other.mastery == mastery &&
        other.achievements == achievements &&
        other.cosmetics == cosmetics &&
        other.currency == currency &&
        other.collection == collection;
  }

  @override
  int get hashCode =>
      Object.hash(mastery, achievements, cosmetics, currency, collection);
}

@immutable
class StudyHarmonyModePreference {
  const StudyHarmonyModePreference({required this.mode, required this.weight});

  final StudyHarmonySessionMode mode;
  final double weight;

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyModePreference &&
        other.mode == mode &&
        other.weight == weight;
  }

  @override
  int get hashCode => Object.hash(mode, weight);
}

@immutable
class StudyHarmonyAdaptivePlan {
  const StudyHarmonyAdaptivePlan({
    required this.effectiveSkillBand,
    required this.tone,
    required this.coachStyle,
    required this.rewardEmphasis,
    required this.modeEmphasis,
    required this.preferredEventRotation,
    required this.onboardingIntensity,
    required this.remediationStyle,
    required this.explanationDepth,
    required this.challengeAggression,
    required this.noveltyBias,
    required this.rationale,
  });

  final StudyHarmonySkillBand effectiveSkillBand;
  final StudyHarmonyToneStyle tone;
  final StudyHarmonyCoachStyle coachStyle;
  final StudyHarmonyRewardEmphasis rewardEmphasis;
  final List<StudyHarmonyModePreference> modeEmphasis;
  final List<StudyHarmonySessionMode> preferredEventRotation;
  final StudyHarmonyOnboardingIntensity onboardingIntensity;
  final StudyHarmonyRemediationStyle remediationStyle;
  final double explanationDepth;
  final double challengeAggression;
  final double noveltyBias;
  final List<String> rationale;

  @override
  bool operator ==(Object other) {
    return other is StudyHarmonyAdaptivePlan &&
        other.effectiveSkillBand == effectiveSkillBand &&
        other.tone == tone &&
        other.coachStyle == coachStyle &&
        other.rewardEmphasis == rewardEmphasis &&
        listEquals(other.modeEmphasis, modeEmphasis) &&
        listEquals(other.preferredEventRotation, preferredEventRotation) &&
        other.onboardingIntensity == onboardingIntensity &&
        other.remediationStyle == remediationStyle &&
        other.explanationDepth == explanationDepth &&
        other.challengeAggression == challengeAggression &&
        other.noveltyBias == noveltyBias &&
        listEquals(other.rationale, rationale);
  }

  @override
  int get hashCode => Object.hash(
    effectiveSkillBand,
    tone,
    coachStyle,
    rewardEmphasis,
    Object.hashAll(modeEmphasis),
    Object.hashAll(preferredEventRotation),
    onboardingIntensity,
    remediationStyle,
    explanationDepth,
    challengeAggression,
    noveltyBias,
    Object.hashAll(rationale),
  );
}

StudyHarmonySkillBand _effectiveSkillBand(
  StudyHarmonySkillBand declaredBand,
  StudyHarmonyRecentPerformance recentPerformance,
) {
  if (!recentPerformance.hasMeaningfulData) {
    return declaredBand;
  }
  final observedBand = inferStudyHarmonySkillBand(recentPerformance);
  final responsiveness = _skillBandResponsiveness(recentPerformance);
  final blendedIndex =
      (declaredBand.index * (1 - responsiveness) +
              observedBand.index * responsiveness)
          .round();
  final clampedIndex = blendedIndex
      .clamp(0, StudyHarmonySkillBand.values.length - 1)
      .toInt();
  return StudyHarmonySkillBand.values[clampedIndex];
}

StudyHarmonyAdaptivePlan personalizeStudyHarmony({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  final effectiveSkillBand = _effectiveSkillBand(
    profile.skillBand,
    recentPerformance,
  );
  final regionFlavor = profile.effectiveRegionFlavor();
  final tone = _toneFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
    regionFlavor: regionFlavor,
  );
  final coachStyle = _coachStyleFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final rewardEmphasis = _rewardEmphasisFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final modeEmphasis = _modeEmphasisFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final onboardingIntensity = _onboardingIntensityFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final remediationStyle = _remediationStyleFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final challengeAggression = _challengeAggressionFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final noveltyBias = _noveltyBiasFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
  );
  final explanationDepth = _explanationDepthFor(
    profile: profile,
    skillBand: effectiveSkillBand,
    recentPerformance: recentPerformance,
    onboardingIntensity: onboardingIntensity,
  );
  final preferredEventRotation = <StudyHarmonySessionMode>[
    for (final entry in modeEmphasis) entry.mode,
  ];

  final rationale = <String>[
    'effective skill band = ${effectiveSkillBand.name}',
    'play style = ${profile.playStyle.name}, session length = ${profile.sessionLengthPreference.name}',
    if (recentPerformance.hasMeaningfulData)
      'recent accuracy=${recentPerformance.averageAccuracy.toStringAsFixed(2)}, clearRate=${recentPerformance.clearRate.toStringAsFixed(2)}',
    if (profile.countryCode != null || profile.localeTag != null)
      'locale and country hints only adjust presentation copy and tone',
  ];

  return StudyHarmonyAdaptivePlan(
    effectiveSkillBand: effectiveSkillBand,
    tone: tone,
    coachStyle: coachStyle,
    rewardEmphasis: rewardEmphasis,
    modeEmphasis: modeEmphasis,
    preferredEventRotation: preferredEventRotation,
    onboardingIntensity: onboardingIntensity,
    remediationStyle: remediationStyle,
    explanationDepth: explanationDepth,
    challengeAggression: challengeAggression,
    noveltyBias: noveltyBias,
    rationale: rationale,
  );
}

StudyHarmonyAdaptivePlan personalizeStudyHarmonyFromSnapshot({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonyProgressSnapshot snapshot,
}) {
  return personalizeStudyHarmony(
    profile: profile,
    recentPerformance: StudyHarmonyRecentPerformance.fromProgressSnapshot(
      snapshot,
    ),
  );
}

StudyHarmonyAgeBand ageBandFromAge(int age) {
  if (age < 13) {
    return StudyHarmonyAgeBand.child;
  }
  if (age < 18) {
    return StudyHarmonyAgeBand.teen;
  }
  if (age < 30) {
    return StudyHarmonyAgeBand.youngAdult;
  }
  if (age < 50) {
    return StudyHarmonyAgeBand.adult;
  }
  return StudyHarmonyAgeBand.mature;
}

StudyHarmonySkillBand inferStudyHarmonySkillBand(
  StudyHarmonyRecentPerformance recentPerformance,
) {
  final score = _clamp01(
    recentPerformance.averageAccuracy * 0.45 +
        recentPerformance.clearRate * 0.2 +
        recentPerformance.masteryMomentum * 0.25 +
        recentPerformance.confidence * 0.1 -
        recentPerformance.recoveryNeed * 0.15,
  );
  if (score < 0.25) {
    return StudyHarmonySkillBand.newcomer;
  }
  if (score < 0.42) {
    return StudyHarmonySkillBand.beginner;
  }
  if (score < 0.6) {
    return StudyHarmonySkillBand.developing;
  }
  if (score < 0.75) {
    return StudyHarmonySkillBand.strong;
  }
  if (score < 0.88) {
    return StudyHarmonySkillBand.advanced;
  }
  return StudyHarmonySkillBand.expert;
}

StudyHarmonyRegionFlavor studyHarmonyRegionFlavorFromCountryCode(
  String? countryCode,
) {
  final normalized = countryCode?.trim().toUpperCase();
  if (normalized == null || normalized.isEmpty) {
    return StudyHarmonyRegionFlavor.global;
  }
  const eastAsia = {'CN', 'HK', 'JP', 'KR', 'MO', 'TW'};
  const southeastAsia = {'BN', 'ID', 'KH', 'LA', 'MY', 'PH', 'SG', 'TH', 'VN'};
  const southAsia = {'BD', 'IN', 'LK', 'NP', 'PK'};
  const europe = {
    'AD',
    'AT',
    'BE',
    'BG',
    'CH',
    'CZ',
    'DE',
    'DK',
    'EE',
    'ES',
    'FI',
    'FR',
    'GB',
    'GR',
    'HR',
    'HU',
    'IE',
    'IS',
    'IT',
    'LT',
    'LU',
    'LV',
    'NL',
    'NO',
    'PL',
    'PT',
    'RO',
    'SE',
    'SI',
    'SK',
  };
  const northAmerica = {'CA', 'MX', 'US'};
  const latinAmerica = {
    'AR',
    'BR',
    'CL',
    'CO',
    'CR',
    'DO',
    'EC',
    'GT',
    'HN',
    'NI',
    'PA',
    'PE',
    'PR',
    'PY',
    'SV',
    'UY',
    'VE',
  };
  const middleEast = {
    'AE',
    'BH',
    'EG',
    'IL',
    'JO',
    'KW',
    'LB',
    'OM',
    'QA',
    'SA',
    'TR',
  };
  const africa = {'DZ', 'GH', 'KE', 'MA', 'NG', 'TN', 'ZA'};
  const oceania = {'AU', 'FJ', 'NZ'};

  if (eastAsia.contains(normalized)) {
    return StudyHarmonyRegionFlavor.eastAsia;
  }
  if (southeastAsia.contains(normalized)) {
    return StudyHarmonyRegionFlavor.southeastAsia;
  }
  if (southAsia.contains(normalized)) {
    return StudyHarmonyRegionFlavor.southAsia;
  }
  if (europe.contains(normalized)) {
    return StudyHarmonyRegionFlavor.europe;
  }
  if (northAmerica.contains(normalized)) {
    return StudyHarmonyRegionFlavor.northAmerica;
  }
  if (latinAmerica.contains(normalized)) {
    return StudyHarmonyRegionFlavor.latinAmerica;
  }
  if (middleEast.contains(normalized)) {
    return StudyHarmonyRegionFlavor.middleEast;
  }
  if (africa.contains(normalized)) {
    return StudyHarmonyRegionFlavor.africa;
  }
  if (oceania.contains(normalized)) {
    return StudyHarmonyRegionFlavor.oceania;
  }
  return StudyHarmonyRegionFlavor.global;
}

extension StudyHarmonyRegionFlavorParsing on StudyHarmonyRegionFlavor {
  static StudyHarmonyRegionFlavor fromCountryCode(String? countryCode) {
    return studyHarmonyRegionFlavorFromCountryCode(countryCode);
  }
}

StudyHarmonyToneStyle _toneFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
  required StudyHarmonyRegionFlavor regionFlavor,
}) {
  var warm = 0.35;
  var playful = 0.25;
  var calm = 0.25;
  var focused = 0.3;
  var celebratory = 0.2;

  switch (profile.ageBand) {
    case StudyHarmonyAgeBand.child:
    case StudyHarmonyAgeBand.teen:
      playful += 0.2;
      warm += 0.15;
      focused -= 0.05;
      break;
    case StudyHarmonyAgeBand.youngAdult:
      focused += 0.1;
      celebratory += 0.05;
      break;
    case StudyHarmonyAgeBand.adult:
      calm += 0.1;
      focused += 0.1;
      break;
    case StudyHarmonyAgeBand.mature:
      calm += 0.2;
      warm += 0.05;
      focused += 0.05;
      break;
  }

  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      focused += 0.15;
      celebratory += 0.15;
      warm -= 0.05;
      break;
    case StudyHarmonyPlayStyle.collector:
      warm += 0.15;
      playful += 0.1;
      break;
    case StudyHarmonyPlayStyle.explorer:
      playful += 0.1;
      calm += 0.05;
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      calm += 0.2;
      warm += 0.05;
      break;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }

  if (skillBand == StudyHarmonySkillBand.newcomer ||
      skillBand == StudyHarmonySkillBand.beginner) {
    warm += 0.2;
    calm += 0.15;
    playful += 0.05;
    focused -= 0.05;
  } else if (skillBand.index >= StudyHarmonySkillBand.advanced.index) {
    focused += 0.15;
    celebratory += 0.1;
  }

  if (recentPerformance.recoveryNeed > 0.55) {
    calm += 0.15;
    warm += 0.1;
    celebratory -= 0.05;
  } else if (recentPerformance.averageAccuracy > 0.86 &&
      recentPerformance.clearRate > 0.7) {
    celebratory += 0.2;
    focused += 0.05;
  }

  switch (regionFlavor) {
    case StudyHarmonyRegionFlavor.global:
      break;
    case StudyHarmonyRegionFlavor.eastAsia:
    case StudyHarmonyRegionFlavor.southAsia:
      focused += 0.03;
      calm += 0.03;
      break;
    case StudyHarmonyRegionFlavor.southeastAsia:
    case StudyHarmonyRegionFlavor.africa:
      warm += 0.03;
      playful += 0.03;
      break;
    case StudyHarmonyRegionFlavor.europe:
      calm += 0.04;
      focused += 0.04;
      break;
    case StudyHarmonyRegionFlavor.northAmerica:
    case StudyHarmonyRegionFlavor.latinAmerica:
      celebratory += 0.04;
      playful += 0.03;
      break;
    case StudyHarmonyRegionFlavor.middleEast:
      calm += 0.05;
      warm += 0.02;
      break;
    case StudyHarmonyRegionFlavor.oceania:
      calm += 0.03;
      playful += 0.03;
      break;
  }

  final scores = <StudyHarmonyToneStyle, double>{
    StudyHarmonyToneStyle.warm: warm,
    StudyHarmonyToneStyle.playful: playful,
    StudyHarmonyToneStyle.calm: calm,
    StudyHarmonyToneStyle.focused: focused,
    StudyHarmonyToneStyle.celebratory: celebratory,
  };
  return _highestScore(scores);
}

StudyHarmonyCoachStyle _coachStyleFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  var supportive = 0.35;
  var structured = 0.3;
  var challengeForward = 0.25;
  var analytical = 0.25;
  var restorative = 0.25;

  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      challengeForward += 0.2;
      analytical += 0.05;
      break;
    case StudyHarmonyPlayStyle.collector:
      supportive += 0.15;
      restorative += 0.05;
      break;
    case StudyHarmonyPlayStyle.explorer:
      supportive += 0.05;
      analytical += 0.1;
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      restorative += 0.2;
      supportive += 0.05;
      break;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }

  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
    case StudyHarmonySkillBand.beginner:
      supportive += 0.15;
      structured += 0.15;
      restorative += 0.15;
      challengeForward -= 0.05;
      break;
    case StudyHarmonySkillBand.developing:
      structured += 0.1;
      analytical += 0.05;
      break;
    case StudyHarmonySkillBand.strong:
      structured += 0.05;
      challengeForward += 0.05;
      break;
    case StudyHarmonySkillBand.advanced:
    case StudyHarmonySkillBand.expert:
      challengeForward += 0.15;
      analytical += 0.1;
      break;
  }

  if (recentPerformance.recoveryNeed > 0.55) {
    restorative += 0.2;
    supportive += 0.1;
    challengeForward -= 0.05;
  } else if (recentPerformance.averageAccuracy > 0.84 &&
      recentPerformance.clearRate > 0.68) {
    challengeForward += 0.1;
    analytical += 0.05;
  }

  if (profile.ageBand == StudyHarmonyAgeBand.child ||
      profile.ageBand == StudyHarmonyAgeBand.teen) {
    supportive += 0.15;
    structured += 0.05;
  }

  final scores = <StudyHarmonyCoachStyle, double>{
    StudyHarmonyCoachStyle.supportive: supportive,
    StudyHarmonyCoachStyle.structured: structured,
    StudyHarmonyCoachStyle.challengeForward: challengeForward,
    StudyHarmonyCoachStyle.analytical: analytical,
    StudyHarmonyCoachStyle.restorative: restorative,
  };
  return _highestScore(scores);
}

StudyHarmonyRewardEmphasis _rewardEmphasisFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  var mastery = 0.35;
  var achievements = 0.25;
  var cosmetics = 0.2;
  var currency = 0.2;
  var collection = 0.2;

  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      achievements += 0.25;
      currency += 0.1;
      mastery += 0.05;
      break;
    case StudyHarmonyPlayStyle.collector:
      cosmetics += 0.2;
      collection += 0.25;
      mastery += 0.05;
      break;
    case StudyHarmonyPlayStyle.explorer:
      collection += 0.1;
      achievements += 0.1;
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      mastery += 0.2;
      currency += 0.05;
      break;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }

  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
    case StudyHarmonySkillBand.beginner:
      mastery += 0.2;
      collection += 0.05;
      break;
    case StudyHarmonySkillBand.developing:
      mastery += 0.1;
      achievements += 0.05;
      break;
    case StudyHarmonySkillBand.strong:
      achievements += 0.1;
      currency += 0.05;
      break;
    case StudyHarmonySkillBand.advanced:
    case StudyHarmonySkillBand.expert:
      achievements += 0.15;
      cosmetics += 0.1;
      break;
  }

  if (recentPerformance.weakSpotCount > recentPerformance.lessonResultCount) {
    mastery += 0.1;
    currency += 0.05;
  }
  if (recentPerformance.averageAccuracy > 0.85) {
    achievements += 0.08;
    cosmetics += 0.05;
  }

  return _normalizeRewards(
    StudyHarmonyRewardEmphasis(
      mastery: mastery,
      achievements: achievements,
      cosmetics: cosmetics,
      currency: currency,
      collection: collection,
    ),
  );
}

StudyHarmonyRewardEmphasis _normalizeRewards(
  StudyHarmonyRewardEmphasis emphasis,
) {
  final total =
      emphasis.mastery +
      emphasis.achievements +
      emphasis.cosmetics +
      emphasis.currency +
      emphasis.collection;
  if (total <= 0) {
    return emphasis;
  }
  return StudyHarmonyRewardEmphasis(
    mastery: emphasis.mastery / total,
    achievements: emphasis.achievements / total,
    cosmetics: emphasis.cosmetics / total,
    currency: emphasis.currency / total,
    collection: emphasis.collection / total,
  );
}

List<StudyHarmonyModePreference> _modeEmphasisFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  final weights = <StudyHarmonySessionMode, double>{
    StudyHarmonySessionMode.lesson: 1.0,
    StudyHarmonySessionMode.review: 1.0,
    StudyHarmonySessionMode.daily: 1.0,
    StudyHarmonySessionMode.focus: 1.0,
    StudyHarmonySessionMode.relay: 0.8,
    StudyHarmonySessionMode.bossRush: 0.7,
    StudyHarmonySessionMode.legend: 0.6,
  };

  void add(StudyHarmonySessionMode mode, double delta) {
    weights[mode] = (weights[mode] ?? 0) + delta;
  }

  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      add(StudyHarmonySessionMode.daily, 0.2);
      add(StudyHarmonySessionMode.relay, 0.4);
      add(StudyHarmonySessionMode.bossRush, 0.45);
      add(StudyHarmonySessionMode.legend, 0.15);
      add(StudyHarmonySessionMode.review, -0.1);
      break;
    case StudyHarmonyPlayStyle.collector:
      add(StudyHarmonySessionMode.lesson, 0.25);
      add(StudyHarmonySessionMode.review, 0.25);
      add(StudyHarmonySessionMode.daily, 0.1);
      add(StudyHarmonySessionMode.focus, -0.1);
      break;
    case StudyHarmonyPlayStyle.explorer:
      add(StudyHarmonySessionMode.daily, 0.25);
      add(StudyHarmonySessionMode.focus, 0.2);
      add(StudyHarmonySessionMode.legend, 0.2);
      add(StudyHarmonySessionMode.relay, 0.1);
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      add(StudyHarmonySessionMode.review, 0.35);
      add(StudyHarmonySessionMode.lesson, 0.2);
      add(StudyHarmonySessionMode.focus, 0.15);
      add(StudyHarmonySessionMode.bossRush, -0.2);
      break;
    case StudyHarmonyPlayStyle.balanced:
      add(StudyHarmonySessionMode.lesson, 0.05);
      add(StudyHarmonySessionMode.daily, 0.05);
      break;
  }

  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
    case StudyHarmonySkillBand.beginner:
      add(StudyHarmonySessionMode.lesson, 0.4);
      add(StudyHarmonySessionMode.review, 0.4);
      add(StudyHarmonySessionMode.daily, 0.15);
      add(StudyHarmonySessionMode.focus, 0.05);
      add(StudyHarmonySessionMode.relay, -0.35);
      add(StudyHarmonySessionMode.bossRush, -0.45);
      add(StudyHarmonySessionMode.legend, -0.35);
      break;
    case StudyHarmonySkillBand.developing:
      add(StudyHarmonySessionMode.lesson, 0.2);
      add(StudyHarmonySessionMode.review, 0.15);
      add(StudyHarmonySessionMode.daily, 0.1);
      break;
    case StudyHarmonySkillBand.strong:
      add(StudyHarmonySessionMode.focus, 0.1);
      add(StudyHarmonySessionMode.relay, 0.1);
      break;
    case StudyHarmonySkillBand.advanced:
      add(StudyHarmonySessionMode.relay, 0.2);
      add(StudyHarmonySessionMode.bossRush, 0.15);
      add(StudyHarmonySessionMode.legend, 0.15);
      break;
    case StudyHarmonySkillBand.expert:
      add(StudyHarmonySessionMode.relay, 0.3);
      add(StudyHarmonySessionMode.bossRush, 0.3);
      add(StudyHarmonySessionMode.legend, 0.25);
      add(StudyHarmonySessionMode.focus, 0.05);
      break;
  }

  switch (profile.sessionLengthPreference) {
    case StudyHarmonySessionLengthPreference.micro:
      add(StudyHarmonySessionMode.lesson, 0.2);
      add(StudyHarmonySessionMode.review, 0.25);
      add(StudyHarmonySessionMode.daily, 0.1);
      add(StudyHarmonySessionMode.relay, -0.35);
      add(StudyHarmonySessionMode.bossRush, -0.45);
      add(StudyHarmonySessionMode.legend, -0.3);
      break;
    case StudyHarmonySessionLengthPreference.short:
      add(StudyHarmonySessionMode.lesson, 0.15);
      add(StudyHarmonySessionMode.review, 0.15);
      add(StudyHarmonySessionMode.daily, 0.1);
      break;
    case StudyHarmonySessionLengthPreference.medium:
      break;
    case StudyHarmonySessionLengthPreference.long:
      add(StudyHarmonySessionMode.focus, 0.2);
      add(StudyHarmonySessionMode.relay, 0.15);
      add(StudyHarmonySessionMode.bossRush, 0.15);
      break;
    case StudyHarmonySessionLengthPreference.marathon:
      add(StudyHarmonySessionMode.focus, 0.2);
      add(StudyHarmonySessionMode.relay, 0.35);
      add(StudyHarmonySessionMode.bossRush, 0.35);
      add(StudyHarmonySessionMode.legend, 0.25);
      break;
  }

  if (recentPerformance.recoveryNeed > 0.55) {
    add(StudyHarmonySessionMode.review, 0.25);
    add(StudyHarmonySessionMode.lesson, 0.2);
    add(StudyHarmonySessionMode.focus, 0.1);
    add(StudyHarmonySessionMode.bossRush, -0.3);
    add(StudyHarmonySessionMode.legend, -0.15);
  } else if (recentPerformance.averageAccuracy > 0.82 &&
      recentPerformance.clearRate > 0.7) {
    add(StudyHarmonySessionMode.daily, 0.1);
    add(StudyHarmonySessionMode.relay, 0.15);
    add(StudyHarmonySessionMode.bossRush, 0.2);
    add(StudyHarmonySessionMode.legend, 0.15);
  }

  if (profile.gameplayAffinity.competition > 0.65) {
    add(StudyHarmonySessionMode.relay, 0.15);
    add(StudyHarmonySessionMode.bossRush, 0.2);
  }
  if (profile.gameplayAffinity.collection > 0.65) {
    add(StudyHarmonySessionMode.lesson, 0.1);
    add(StudyHarmonySessionMode.review, 0.1);
  }
  if (profile.gameplayAffinity.exploration > 0.65) {
    add(StudyHarmonySessionMode.daily, 0.12);
    add(StudyHarmonySessionMode.legend, 0.12);
  }
  if (profile.gameplayAffinity.stability > 0.65) {
    add(StudyHarmonySessionMode.review, 0.12);
    add(StudyHarmonySessionMode.lesson, 0.08);
  }

  final entries = weights.entries.toList(growable: false)
    ..sort((left, right) => right.value.compareTo(left.value));
  final topWeight = entries.first.value <= 0 ? 1.0 : entries.first.value;
  return [
    for (final entry in entries)
      StudyHarmonyModePreference(
        mode: entry.key,
        weight: _clamp01(entry.value / topWeight),
      ),
  ];
}

StudyHarmonyOnboardingIntensity _onboardingIntensityFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  var score = 0.5;
  switch (profile.ageBand) {
    case StudyHarmonyAgeBand.child:
      score += 0.25;
      break;
    case StudyHarmonyAgeBand.teen:
      score += 0.15;
      break;
    case StudyHarmonyAgeBand.youngAdult:
      score += 0.05;
      break;
    case StudyHarmonyAgeBand.adult:
      break;
    case StudyHarmonyAgeBand.mature:
      score -= 0.05;
      break;
  }

  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
      score += 0.35;
      break;
    case StudyHarmonySkillBand.beginner:
      score += 0.2;
      break;
    case StudyHarmonySkillBand.developing:
      score += 0.1;
      break;
    case StudyHarmonySkillBand.strong:
      score -= 0.05;
      break;
    case StudyHarmonySkillBand.advanced:
      score -= 0.15;
      break;
    case StudyHarmonySkillBand.expert:
      score -= 0.25;
      break;
  }

  switch (profile.sessionLengthPreference) {
    case StudyHarmonySessionLengthPreference.micro:
      score -= 0.1;
      break;
    case StudyHarmonySessionLengthPreference.short:
      score -= 0.05;
      break;
    case StudyHarmonySessionLengthPreference.medium:
      break;
    case StudyHarmonySessionLengthPreference.long:
      score += 0.05;
      break;
    case StudyHarmonySessionLengthPreference.marathon:
      score += 0.1;
      break;
  }

  if (recentPerformance.recoveryNeed > 0.55) {
    score += 0.15;
  }
  if (recentPerformance.averageAccuracy > 0.85 &&
      recentPerformance.clearRate > 0.75) {
    score -= 0.1;
  }

  final rounded = _clamp01(score);
  if (rounded < 0.2) {
    return StudyHarmonyOnboardingIntensity.minimal;
  }
  if (rounded < 0.45) {
    return StudyHarmonyOnboardingIntensity.light;
  }
  if (rounded < 0.72) {
    return StudyHarmonyOnboardingIntensity.guided;
  }
  return StudyHarmonyOnboardingIntensity.immersive;
}

double _skillBandResponsiveness(
  StudyHarmonyRecentPerformance recentPerformance,
) {
  var responsiveness = 0.48;
  responsiveness += math.min(
    0.18,
    recentPerformance.lessonResultCount / 20 * 0.18,
  );
  responsiveness += math.min(
    0.12,
    recentPerformance.activeDayCount / 14 * 0.12,
  );
  responsiveness += math.min(
    0.08,
    recentPerformance.reviewQueueCount / 10 * 0.08,
  );
  responsiveness += recentPerformance.recoveryNeed * 0.12;
  responsiveness += (1 - recentPerformance.confidence) * 0.08;
  return _clamp01(responsiveness);
}

StudyHarmonyRemediationStyle _remediationStyleFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  if (recentPerformance.recoveryNeed > 0.7) {
    return StudyHarmonyRemediationStyle.confidenceRebuild;
  }
  if (recentPerformance.weakSpotCount > recentPerformance.lessonResultCount) {
    return StudyHarmonyRemediationStyle.targetedDrill;
  }
  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      return skillBand.index >= StudyHarmonySkillBand.advanced.index
          ? StudyHarmonyRemediationStyle.targetedDrill
          : StudyHarmonyRemediationStyle.resetAndRetry;
    case StudyHarmonyPlayStyle.collector:
      return StudyHarmonyRemediationStyle.scaffolded;
    case StudyHarmonyPlayStyle.explorer:
      return StudyHarmonyRemediationStyle.gentleNudge;
    case StudyHarmonyPlayStyle.stabilizer:
      return StudyHarmonyRemediationStyle.confidenceRebuild;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }
  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
    case StudyHarmonySkillBand.beginner:
      return StudyHarmonyRemediationStyle.scaffolded;
    case StudyHarmonySkillBand.developing:
      return StudyHarmonyRemediationStyle.gentleNudge;
    case StudyHarmonySkillBand.strong:
      return StudyHarmonyRemediationStyle.targetedDrill;
    case StudyHarmonySkillBand.advanced:
    case StudyHarmonySkillBand.expert:
      return StudyHarmonyRemediationStyle.resetAndRetry;
  }
}

double _challengeAggressionFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  var score = 0.45;
  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      score += 0.25;
      break;
    case StudyHarmonyPlayStyle.collector:
      score -= 0.05;
      break;
    case StudyHarmonyPlayStyle.explorer:
      score += 0.05;
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      score -= 0.12;
      break;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }
  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
    case StudyHarmonySkillBand.beginner:
      score -= 0.2;
      break;
    case StudyHarmonySkillBand.developing:
      score -= 0.05;
      break;
    case StudyHarmonySkillBand.strong:
      score += 0.05;
      break;
    case StudyHarmonySkillBand.advanced:
      score += 0.12;
      break;
    case StudyHarmonySkillBand.expert:
      score += 0.18;
      break;
  }
  if (recentPerformance.recoveryNeed > 0.55) {
    score -= 0.15;
  }
  if (recentPerformance.averageAccuracy > 0.84) {
    score += 0.05;
  }
  return _clamp01(score);
}

double _noveltyBiasFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
}) {
  var score = 0.35;
  switch (profile.playStyle) {
    case StudyHarmonyPlayStyle.competitor:
      score -= 0.05;
      break;
    case StudyHarmonyPlayStyle.collector:
      score += 0.08;
      break;
    case StudyHarmonyPlayStyle.explorer:
      score += 0.2;
      break;
    case StudyHarmonyPlayStyle.stabilizer:
      score -= 0.12;
      break;
    case StudyHarmonyPlayStyle.balanced:
      break;
  }
  switch (profile.sessionLengthPreference) {
    case StudyHarmonySessionLengthPreference.micro:
      score -= 0.1;
      break;
    case StudyHarmonySessionLengthPreference.short:
      score -= 0.03;
      break;
    case StudyHarmonySessionLengthPreference.medium:
      break;
    case StudyHarmonySessionLengthPreference.long:
      score += 0.05;
      break;
    case StudyHarmonySessionLengthPreference.marathon:
      score += 0.1;
      break;
  }
  if (skillBand.index >= StudyHarmonySkillBand.advanced.index) {
    score += 0.08;
  }
  if (recentPerformance.recoveryNeed > 0.6) {
    score -= 0.1;
  }
  return _clamp01(score);
}

double _explanationDepthFor({
  required StudyHarmonyPersonalizationProfile profile,
  required StudyHarmonySkillBand skillBand,
  required StudyHarmonyRecentPerformance recentPerformance,
  required StudyHarmonyOnboardingIntensity onboardingIntensity,
}) {
  var score = 0.55;
  switch (profile.ageBand) {
    case StudyHarmonyAgeBand.child:
      score += 0.15;
      break;
    case StudyHarmonyAgeBand.teen:
      score += 0.1;
      break;
    case StudyHarmonyAgeBand.youngAdult:
      score += 0.05;
      break;
    case StudyHarmonyAgeBand.adult:
      break;
    case StudyHarmonyAgeBand.mature:
      score -= 0.05;
      break;
  }
  switch (skillBand) {
    case StudyHarmonySkillBand.newcomer:
      score += 0.18;
      break;
    case StudyHarmonySkillBand.beginner:
      score += 0.1;
      break;
    case StudyHarmonySkillBand.developing:
      score += 0.05;
      break;
    case StudyHarmonySkillBand.strong:
      break;
    case StudyHarmonySkillBand.advanced:
      score -= 0.06;
      break;
    case StudyHarmonySkillBand.expert:
      score -= 0.12;
      break;
  }
  switch (onboardingIntensity) {
    case StudyHarmonyOnboardingIntensity.minimal:
      score -= 0.15;
      break;
    case StudyHarmonyOnboardingIntensity.light:
      score -= 0.05;
      break;
    case StudyHarmonyOnboardingIntensity.guided:
      break;
    case StudyHarmonyOnboardingIntensity.immersive:
      score += 0.1;
      break;
  }
  if (recentPerformance.recoveryNeed > 0.55) {
    score += 0.08;
  }
  return _clamp01(score);
}

T _highestScore<T>(Map<T, double> scores) {
  return scores.entries
      .reduce((left, right) => right.value > left.value ? right : left)
      .key;
}

double _mean(Iterable<double> values) {
  var sum = 0.0;
  var count = 0;
  for (final value in values) {
    sum += value;
    count += 1;
  }
  return count == 0 ? 0.0 : sum / count;
}

double _clamp01(num value) {
  return value.clamp(0.0, 1.0).toDouble();
}
