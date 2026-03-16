import '../settings/practice_settings.dart';

class MelodyGenerationConfig {
  const MelodyGenerationConfig._();

  static const List<double> metricStrength4_4_8 = <double>[
    1.00,
    0.26,
    0.58,
    0.52,
    0.86,
    0.28,
    0.54,
    0.66,
  ];

  static const Map<SettingsComplexityMode, MelodyModeProfile> modeProfiles = {
    SettingsComplexityMode.guided: MelodyModeProfile(
      defaultDensity: MelodyDensity.balanced,
      defaultStyle: MelodyStyle.safe,
      densityWeights: {
        MelodyDensity.sparse: 0.30,
        MelodyDensity.balanced: 0.70,
      },
      styleWeights: {MelodyStyle.safe: 0.70, MelodyStyle.lyrical: 0.30},
      motifRepetitionStrength: 0.38,
      approachToneDensity: 0.18,
      allowChromaticApproaches: false,
      syncopationBias: 0.20,
      colorRealizationBias: 0.18,
      noveltyTarget: 0.30,
      motifVariationBias: 0.48,
      anticipationProbability: 0.08,
      softColorExposureTarget: 0.10,
      hardColorExposureTarget: 0.10,
      exactRepeatTarget: 0.08,
    ),
    SettingsComplexityMode.standard: MelodyModeProfile(
      defaultDensity: MelodyDensity.balanced,
      defaultStyle: MelodyStyle.lyrical,
      densityWeights: {
        MelodyDensity.balanced: 0.65,
        MelodyDensity.active: 0.35,
      },
      styleWeights: {
        MelodyStyle.lyrical: 0.45,
        MelodyStyle.bebop: 0.35,
        MelodyStyle.safe: 0.20,
      },
      motifRepetitionStrength: 0.28,
      approachToneDensity: 0.30,
      allowChromaticApproaches: true,
      syncopationBias: 0.48,
      colorRealizationBias: 0.46,
      noveltyTarget: 0.56,
      motifVariationBias: 0.72,
      anticipationProbability: 0.18,
      softColorExposureTarget: 0.22,
      hardColorExposureTarget: 0.30,
      exactRepeatTarget: 0.04,
    ),
    SettingsComplexityMode.advanced: MelodyModeProfile(
      defaultDensity: MelodyDensity.active,
      defaultStyle: MelodyStyle.colorful,
      densityWeights: {
        MelodyDensity.active: 0.75,
        MelodyDensity.balanced: 0.25,
      },
      styleWeights: {
        MelodyStyle.colorful: 0.50,
        MelodyStyle.bebop: 0.35,
        MelodyStyle.lyrical: 0.15,
      },
      motifRepetitionStrength: 0.20,
      approachToneDensity: 0.42,
      allowChromaticApproaches: true,
      syncopationBias: 0.70,
      colorRealizationBias: 0.82,
      noveltyTarget: 0.80,
      motifVariationBias: 0.84,
      anticipationProbability: 0.28,
      softColorExposureTarget: 0.35,
      hardColorExposureTarget: 0.45,
      exactRepeatTarget: 0.02,
    ),
  };

  static const Map<MelodyQuickPreset, MelodyQuickPresetProfile>
  quickPresetProfiles = {
    MelodyQuickPreset.guideLine: MelodyQuickPresetProfile(
      density: MelodyDensity.balanced,
      style: MelodyStyle.safe,
      motifRepetitionStrength: 0.38,
      approachToneDensity: 0.14,
      allowChromaticApproaches: false,
      syncopationBias: 0.12,
      colorRealizationBias: 0.12,
      noveltyTarget: 0.24,
      motifVariationBias: 0.38,
      anticipationProbability: 0.06,
      colorToneTarget: 0.09,
      exactRepeatTarget: 0.08,
    ),
    MelodyQuickPreset.songLine: MelodyQuickPresetProfile(
      density: MelodyDensity.balanced,
      style: MelodyStyle.lyrical,
      motifRepetitionStrength: 0.26,
      approachToneDensity: 0.28,
      allowChromaticApproaches: true,
      syncopationBias: 0.40,
      colorRealizationBias: 0.34,
      noveltyTarget: 0.56,
      motifVariationBias: 0.68,
      anticipationProbability: 0.16,
      colorToneTarget: 0.22,
      exactRepeatTarget: 0.04,
    ),
    MelodyQuickPreset.colorLine: MelodyQuickPresetProfile(
      density: MelodyDensity.active,
      style: MelodyStyle.colorful,
      motifRepetitionStrength: 0.18,
      approachToneDensity: 0.44,
      allowChromaticApproaches: true,
      syncopationBias: 0.78,
      colorRealizationBias: 0.88,
      noveltyTarget: 0.86,
      motifVariationBias: 0.92,
      anticipationProbability: 0.30,
      colorToneTarget: 0.42,
      exactRepeatTarget: 0.02,
    ),
  };

  static const Map<SettingsComplexityMode, ModePitchRange> modePitchRanges = {
    SettingsComplexityMode.guided: ModePitchRange(
      centerMin: 69,
      centerMax: 72,
      apexMinDelta: 4,
      apexMaxDelta: 6,
    ),
    SettingsComplexityMode.standard: ModePitchRange(
      centerMin: 67,
      centerMax: 74,
      apexMinDelta: 5,
      apexMaxDelta: 8,
    ),
    SettingsComplexityMode.advanced: ModePitchRange(
      centerMin: 65,
      centerMax: 76,
      apexMinDelta: 6,
      apexMaxDelta: 10,
    ),
  };

  static const Map<SettingsComplexityMode, Map<String, double>>
  strongSlotCategoryProb = {
    SettingsComplexityMode.guided: {
      'chord': 0.82,
      'tension': 0.15,
      'nonChord': 0.03,
    },
    SettingsComplexityMode.standard: {
      'chord': 0.65,
      'tension': 0.25,
      'nonChord': 0.10,
    },
    SettingsComplexityMode.advanced: {
      'chord': 0.50,
      'tension': 0.32,
      'nonChord': 0.18,
    },
  };

  static const Map<SettingsComplexityMode, Map<String, double>>
  weakSlotCategoryProb = {
    SettingsComplexityMode.guided: {
      'chord': 0.55,
      'diatonic': 0.30,
      'chromatic': 0.15,
    },
    SettingsComplexityMode.standard: {
      'chord': 0.40,
      'diatonic': 0.38,
      'chromatic': 0.22,
    },
    SettingsComplexityMode.advanced: {
      'chord': 0.32,
      'diatonic': 0.38,
      'chromatic': 0.30,
    },
  };

  static const Map<SettingsComplexityMode, Map<String, double>>
  motifTransformProb = {
    SettingsComplexityMode.guided: {
      'exact': 0.08,
      'transpose': 0.18,
      'tailChange': 0.28,
      'rhythmVar': 0.20,
      'truncateExtend': 0.12,
      'sequence': 0.12,
      'inversionLite': 0.05,
    },
    SettingsComplexityMode.standard: {
      'exact': 0.05,
      'transpose': 0.18,
      'tailChange': 0.21,
      'rhythmVar': 0.24,
      'truncateExtend': 0.12,
      'sequence': 0.10,
      'inversionLite': 0.10,
    },
    SettingsComplexityMode.advanced: {
      'exact': 0.02,
      'transpose': 0.14,
      'tailChange': 0.20,
      'rhythmVar': 0.26,
      'truncateExtend': 0.12,
      'sequence': 0.12,
      'inversionLite': 0.14,
    },
  };

  static const Map<String, List<String>> featuredDegrees = {
    'maj7': <String>['3', '7', '9', '13', '1', '5'],
    'maj7#11': <String>['3', '7', '#11', '9', '13', '1'],
    'dominant7': <String>['3', 'b7', '9', '13', '1', '5'],
    'lydianDom': <String>['3', 'b7', '#11', '9', '13', '1'],
    'dom7alt': <String>['3', 'b7', 'b9', '#9', '#11', 'b13'],
    'minor7': <String>['b3', 'b7', '9', '11', '1', '5'],
    'minor11': <String>['b3', 'b7', '11', '9', '1', '5'],
    'minor13': <String>['b3', 'b7', '9', '11', '13', '1'],
    'halfDim': <String>['b3', 'b5', 'b7', '11', '1'],
    'borrowedIv': <String>['b3', 'b7', '9', '11', '1', '5'],
  };

  static const Map<String, List<String>> colorIdentityDegrees = {
    'maj7#11': <String>['#11', '9', '7'],
    'lydianDom': <String>['#11', '9', '13', '3', 'b7'],
    'dom7alt': <String>['b9', '#9', '#11', 'b13', '3', 'b7'],
    'minor11': <String>['11', '9', 'b3', 'b7'],
    'minor13': <String>['13', '11', '9', 'b3', 'b7'],
    'halfDim': <String>['b5', '11', 'b3'],
    'borrowedIv': <String>['b3', '11', '9', 'b7'],
  };

  static const Map<SettingsComplexityMode, int> beamWidth = {
    SettingsComplexityMode.guided: 12,
    SettingsComplexityMode.standard: 16,
    SettingsComplexityMode.advanced: 24,
  };

  static const Map<SettingsComplexityMode, int> candidateLimit = {
    SettingsComplexityMode.guided: 10,
    SettingsComplexityMode.standard: 12,
    SettingsComplexityMode.advanced: 16,
  };

  static const Map<int, double> intervalBase = {
    0: 0.20,
    1: 1.05,
    2: 1.25,
    3: 0.65,
    4: 0.30,
    5: -0.10,
    6: -0.65,
    7: -1.05,
    8: -1.60,
    9: -2.00,
  };

  static const MelodyScoringWeights scoringWeights = MelodyScoringWeights(
    chordFit: 2.6,
    intervalFit: 1.8,
    directionFit: 1.1,
    metricFit: 1.2,
    phraseFit: 1.3,
    cadenceFit: 1.4,
    motifFit: 1.1,
    colorFit: 1.3,
    noveltyFit: 0.9,
    rangeFit: 0.6,
  );

  static MelodyModeProfile profileFor(SettingsComplexityMode mode) {
    return modeProfiles[mode] ?? modeProfiles[SettingsComplexityMode.guided]!;
  }

  static SettingsComplexityMode effectiveModeForSettings(
    PracticeSettings settings,
  ) {
    if (settings.melodyStyle == MelodyStyle.colorful ||
        settings.melodyDensity == MelodyDensity.active ||
        settings.syncopationBias >= 0.66 ||
        settings.colorRealizationBias >= 0.72 ||
        settings.colorToneTarget >= 0.34 ||
        settings.noveltyTarget >= 0.72 ||
        settings.motifVariationBias >= 0.82 ||
        settings.approachToneDensity >= 0.38 ||
        settings.exactRepeatTarget <= 0.03) {
      return SettingsComplexityMode.advanced;
    }
    if (settings.melodyStyle == MelodyStyle.lyrical ||
        settings.melodyStyle == MelodyStyle.bebop ||
        settings.allowChromaticApproaches ||
        settings.syncopationBias >= 0.34 ||
        settings.colorRealizationBias >= 0.30 ||
        settings.colorToneTarget >= 0.18 ||
        settings.noveltyTarget >= 0.46 ||
        settings.motifVariationBias >= 0.60 ||
        settings.approachToneDensity >= 0.22 ||
        settings.anticipationProbability >= 0.12 ||
        settings.exactRepeatTarget <= 0.05) {
      return SettingsComplexityMode.standard;
    }
    return SettingsComplexityMode.guided;
  }

  static MelodyQuickPresetProfile quickPresetFor(MelodyQuickPreset preset) {
    return quickPresetProfiles[preset] ??
        quickPresetProfiles[MelodyQuickPreset.guideLine]!;
  }

  static double colorExposureTargetFor(
    SettingsComplexityMode mode, {
    required bool hardColor,
  }) {
    final profile = profileFor(mode);
    return hardColor
        ? profile.hardColorExposureTarget
        : profile.softColorExposureTarget;
  }
}

class MelodyModeProfile {
  const MelodyModeProfile({
    required this.defaultDensity,
    required this.defaultStyle,
    required this.densityWeights,
    required this.styleWeights,
    required this.motifRepetitionStrength,
    required this.approachToneDensity,
    required this.allowChromaticApproaches,
    required this.syncopationBias,
    required this.colorRealizationBias,
    required this.noveltyTarget,
    required this.motifVariationBias,
    required this.anticipationProbability,
    required this.softColorExposureTarget,
    required this.hardColorExposureTarget,
    required this.exactRepeatTarget,
  });

  final MelodyDensity defaultDensity;
  final MelodyStyle defaultStyle;
  final Map<MelodyDensity, double> densityWeights;
  final Map<MelodyStyle, double> styleWeights;
  final double motifRepetitionStrength;
  final double approachToneDensity;
  final bool allowChromaticApproaches;
  final double syncopationBias;
  final double colorRealizationBias;
  final double noveltyTarget;
  final double motifVariationBias;
  final double anticipationProbability;
  final double softColorExposureTarget;
  final double hardColorExposureTarget;
  final double exactRepeatTarget;
}

class MelodyQuickPresetProfile {
  const MelodyQuickPresetProfile({
    required this.density,
    required this.style,
    required this.motifRepetitionStrength,
    required this.approachToneDensity,
    required this.allowChromaticApproaches,
    required this.syncopationBias,
    required this.colorRealizationBias,
    required this.noveltyTarget,
    required this.motifVariationBias,
    required this.anticipationProbability,
    required this.colorToneTarget,
    required this.exactRepeatTarget,
  });

  final MelodyDensity density;
  final MelodyStyle style;
  final double motifRepetitionStrength;
  final double approachToneDensity;
  final bool allowChromaticApproaches;
  final double syncopationBias;
  final double colorRealizationBias;
  final double noveltyTarget;
  final double motifVariationBias;
  final double anticipationProbability;
  final double colorToneTarget;
  final double exactRepeatTarget;
}

class ModePitchRange {
  const ModePitchRange({
    required this.centerMin,
    required this.centerMax,
    required this.apexMinDelta,
    required this.apexMaxDelta,
  });

  final int centerMin;
  final int centerMax;
  final int apexMinDelta;
  final int apexMaxDelta;
}

class MelodyScoringWeights {
  const MelodyScoringWeights({
    required this.chordFit,
    required this.intervalFit,
    required this.directionFit,
    required this.metricFit,
    required this.phraseFit,
    required this.cadenceFit,
    required this.motifFit,
    required this.colorFit,
    required this.noveltyFit,
    required this.rangeFit,
  });

  final double chordFit;
  final double intervalFit;
  final double directionFit;
  final double metricFit;
  final double phraseFit;
  final double cadenceFit;
  final double motifFit;
  final double colorFit;
  final double noveltyFit;
  final double rangeFit;
}
