import 'settings/practice_settings.dart';

const bool kEnableStudyHarmonyEntryPoints = bool.fromEnvironment(
  'ENABLE_STUDY_HARMONY_ENTRY_POINTS',
  defaultValue: false,
);

const bool kEnableAdvancedAnalyzerActions = bool.fromEnvironment(
  'ENABLE_ADVANCED_ANALYZER_ACTIONS',
  defaultValue: false,
);

const bool kEnableMelodyGenerationEntryPoints = bool.fromEnvironment(
  'ENABLE_MELODY_GENERATION_ENTRY_POINTS',
  defaultValue: false,
);

PracticeSettings sanitizePracticeSettingsForFeatureFlags(
  PracticeSettings settings,
) {
  if (kEnableMelodyGenerationEntryPoints) {
    return settings;
  }
  if (!settings.melodyGenerationEnabled &&
      !settings.autoPlayMelodyWithChords &&
      settings.melodyPlaybackMode == MelodyPlaybackMode.chordsOnly) {
    return settings;
  }
  return settings.copyWith(
    melodyGenerationEnabled: false,
    autoPlayMelodyWithChords: false,
    melodyPlaybackMode: MelodyPlaybackMode.chordsOnly,
  );
}
