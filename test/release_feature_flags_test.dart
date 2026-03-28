import 'package:flutter_test/flutter_test.dart';

import 'package:chordest/billing/premium_feature_access.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/release_feature_flags.dart';
import 'package:chordest/settings/practice_settings.dart';

void main() {
  test(
    'sanitizePracticeSettingsForFeatureFlags disables melody entry settings by default',
    () {
      final sanitized = sanitizePracticeSettingsForFeatureFlags(
        PracticeSettings(
          melodyGenerationEnabled: true,
          autoPlayMelodyWithChords: true,
          melodyPlaybackMode: MelodyPlaybackMode.both,
        ),
      );

      expect(sanitized.melodyGenerationEnabled, isFalse);
      expect(sanitized.autoPlayMelodyWithChords, isFalse);
      expect(sanitized.melodyPlaybackMode, MelodyPlaybackMode.chordsOnly);
    },
  );

  test(
    'sanitizePracticeSettingsForFeatureFlags reuses already sanitized settings',
    () {
      final settings = PracticeSettings(
        melodyGenerationEnabled: false,
        autoPlayMelodyWithChords: false,
        melodyPlaybackMode: MelodyPlaybackMode.chordsOnly,
      );

      final sanitized = sanitizePracticeSettingsForFeatureFlags(settings);

      expect(identical(sanitized, settings), isTrue);
    },
  );

  test(
    'sanitizePracticeSettingsForEntitlement reuses already sanitized settings',
    () {
      final settings = PracticeSettings(
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

      final sanitized = sanitizePracticeSettingsForEntitlement(
        settings,
        premiumUnlocked: false,
      );

      expect(identical(sanitized, settings), isTrue);
    },
  );

  test(
    'sanitizePracticeSettingsForAvailability applies entitlement and feature gates together',
    () {
      final sanitized = sanitizePracticeSettingsForAvailability(
        PracticeSettings(
          smartGeneratorMode: true,
          secondaryDominantEnabled: true,
          allowTensions: true,
          selectedTensionOptions: const {'9', '13'},
          melodyGenerationEnabled: true,
          autoPlayMelodyWithChords: true,
          melodyPlaybackMode: MelodyPlaybackMode.both,
        ),
        premiumUnlocked: false,
      );

      expect(sanitized.smartGeneratorMode, isFalse);
      expect(sanitized.secondaryDominantEnabled, isFalse);
      expect(sanitized.allowTensions, isFalse);
      expect(sanitized.selectedTensionOptions, isEmpty);
      expect(sanitized.melodyGenerationEnabled, isFalse);
      expect(sanitized.autoPlayMelodyWithChords, isFalse);
      expect(sanitized.melodyPlaybackMode, MelodyPlaybackMode.chordsOnly);
    },
  );
}
