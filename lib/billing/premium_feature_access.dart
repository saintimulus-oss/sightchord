import '../music/chord_theory.dart';
import '../release_feature_flags.dart';
import '../settings/practice_settings.dart';

enum PremiumFeature { smartGenerator, advancedHarmony }

Set<PremiumFeature> requestedPremiumFeatures(PracticeSettings settings) {
  final requested = <PremiumFeature>{};
  if (settings.smartGeneratorMode ||
      settings.smartDiagnosticsEnabled ||
      settings.modulationIntensity != ModulationIntensity.low ||
      settings.jazzPreset != JazzPreset.standardsCore ||
      settings.sourceProfile != SourceProfile.fakebookStandard) {
    requested.add(PremiumFeature.smartGenerator);
  }
  if (settings.secondaryDominantEnabled ||
      settings.substituteDominantEnabled ||
      settings.modalInterchangeEnabled ||
      settings.allowTensions) {
    requested.add(PremiumFeature.advancedHarmony);
  }
  return requested;
}

PracticeSettings sanitizePracticeSettingsForEntitlement(
  PracticeSettings settings, {
  required bool premiumUnlocked,
}) {
  if (premiumUnlocked) {
    return settings;
  }
  if (!settings.smartGeneratorMode &&
      !settings.secondaryDominantEnabled &&
      !settings.substituteDominantEnabled &&
      !settings.modalInterchangeEnabled &&
      settings.modulationIntensity == ModulationIntensity.low &&
      settings.jazzPreset == JazzPreset.standardsCore &&
      settings.sourceProfile == SourceProfile.fakebookStandard &&
      !settings.smartDiagnosticsEnabled &&
      !settings.allowTensions &&
      settings.selectedTensionOptions.isEmpty) {
    return settings;
  }
  return settings.copyWith(
    smartGeneratorMode: false,
    secondaryDominantEnabled: false,
    substituteDominantEnabled: false,
    modalInterchangeEnabled: false,
    modulationIntensity: ModulationIntensity.low,
    jazzPreset: JazzPreset.standardsCore,
    sourceProfile: SourceProfile.fakebookStandard,
    smartDiagnosticsEnabled: false,
    allowTensions: false,
    selectedTensionOptions: const <String>{},
  );
}

PracticeSettings sanitizePracticeSettingsForAvailability(
  PracticeSettings settings, {
  required bool premiumUnlocked,
}) {
  return sanitizePracticeSettingsForFeatureFlags(
    sanitizePracticeSettingsForEntitlement(
      settings,
      premiumUnlocked: premiumUnlocked,
    ),
  );
}
