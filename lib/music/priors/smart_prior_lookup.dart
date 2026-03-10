part of '../../smart_generator.dart';

class SmartPriorLookup {
  const SmartPriorLookup._();

  static bool _generatedPriorsEnabled = true;

  static bool get generatedPriorsEnabled => _generatedPriorsEnabled;

  static T runWithGeneratedPriorsEnabled<T>(bool enabled, T Function() body) {
    final previous = _generatedPriorsEnabled;
    _generatedPriorsEnabled = enabled;
    try {
      return body();
    } finally {
      _generatedPriorsEnabled = previous;
    }
  }

  static int familyBaseWeight({
    required JazzPreset jazzPreset,
    required SmartProgressionFamily family,
  }) {
    if (!_generatedPriorsEnabled) {
      return SmartGeneratorHelper._legacyFamilyBaseWeight(
        jazzPreset: jazzPreset,
        family: family,
      );
    }
    final generated = SmartPriors.familyBaseWeights[jazzPreset]?[family];
    if (generated != null) {
      return generated;
    }
    return SmartGeneratorHelper._legacyFamilyBaseWeight(
      jazzPreset: jazzPreset,
      family: family,
    );
  }

  static double phraseRoleMultiplier(
    SmartProgressionFamily family,
    SmartPhraseContext phraseContext,
  ) {
    if (!_generatedPriorsEnabled) {
      return SmartGeneratorHelper._phraseRoleMultiplier(family, phraseContext);
    }
    final generated =
        SmartPriors.phraseRoleOverlays[phraseContext.phraseRole]?[family];
    if (generated != null) {
      return generated;
    }
    return SmartGeneratorHelper._phraseRoleMultiplier(family, phraseContext);
  }

  static double sectionRoleMultiplier(
    SmartProgressionFamily family,
    SmartPhraseContext phraseContext,
  ) {
    if (!_generatedPriorsEnabled) {
      return SmartGeneratorHelper._sectionRoleMultiplier(family, phraseContext);
    }
    final generated =
        SmartPriors.sectionRoleOverlays[phraseContext.sectionRole]?[family];
    if (generated != null) {
      return generated;
    }
    return SmartGeneratorHelper._sectionRoleMultiplier(family, phraseContext);
  }

  static double sourceProfileMultiplier(
    SmartProgressionFamily family,
    SourceProfile sourceProfile,
  ) {
    if (!_generatedPriorsEnabled) {
      return SmartGeneratorHelper._sourceProfileMultiplier(
        family,
        sourceProfile,
      );
    }
    final profile = SmartPriors.profileForSourceProfile(sourceProfile);
    if (!profile.useRecordingSurfaceOverlay) {
      return 1;
    }
    final generated = SmartPriors.sourceProfileOverlays[sourceProfile]?[family];
    if (generated != null) {
      return generated;
    }
    return SmartGeneratorHelper._sourceProfileMultiplier(family, sourceProfile);
  }

  static List<WeightedNextRoman>? transitionCandidates({
    required KeyMode keyMode,
    required RomanNumeralId? currentRomanNumeralId,
  }) {
    if (currentRomanNumeralId == null) {
      return null;
    }
    if (!_generatedPriorsEnabled) {
      final legacyLookup = keyMode == KeyMode.major
          ? SmartGeneratorHelper.majorDiatonicTransitions
          : SmartGeneratorHelper.minorDiatonicTransitions;
      return legacyLookup[currentRomanNumeralId];
    }
    final generated =
        SmartPriors.transitionPriors[keyMode]?[currentRomanNumeralId];
    if (generated != null && generated.isNotEmpty) {
      return generated;
    }
    final legacyLookup = keyMode == KeyMode.major
        ? SmartGeneratorHelper.majorDiatonicTransitions
        : SmartGeneratorHelper.minorDiatonicTransitions;
    return legacyLookup[currentRomanNumeralId];
  }
}
