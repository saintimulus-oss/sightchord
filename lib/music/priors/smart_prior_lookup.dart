part of '../../smart_generator.dart';

class SmartPriorLookup {
  const SmartPriorLookup._();

  static const bool _defaultGeneratedPriorsEnabled = true;
  static const Symbol _generatedPriorsZoneKey = #generatedPriorsEnabled;

  static bool get generatedPriorsEnabled =>
      Zone.current[_generatedPriorsZoneKey] as bool? ??
      _defaultGeneratedPriorsEnabled;

  static T runWithGeneratedPriorsEnabled<T>(bool enabled, T Function() body) {
    return runZoned(
      body,
      zoneValues: {_generatedPriorsZoneKey: enabled},
    );
  }

  static int familyBaseWeight({
    required JazzPreset jazzPreset,
    required SmartProgressionFamily family,
  }) {
    if (!generatedPriorsEnabled) {
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
    if (!generatedPriorsEnabled) {
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
    if (!generatedPriorsEnabled) {
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
    if (!generatedPriorsEnabled) {
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
    if (!generatedPriorsEnabled) {
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
