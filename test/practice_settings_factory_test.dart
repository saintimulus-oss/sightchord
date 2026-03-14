import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/practice_setup_models.dart';
import 'package:chordest/settings/practice_setup_preview.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profileFromSettings infers guided beginner answers from safe preset', () {
    final settings = PracticeSettingsFactory.beginnerSafePreset();

    final profile = PracticeSettingsFactory.profileFromSettings(settings);

    expect(profile.harmonyLiteracy, HarmonyLiteracy.absoluteBeginner);
    expect(profile.handComfort, HandComfort.threeNotes);
    expect(profile.chordSymbolStyle, ChordSymbolStyle.majText);
    expect(
      profile.startingKeyCenter,
      const KeyCenter(tonicName: 'C', mode: KeyMode.major),
    );
  });

  test('nudgeTowardEasier steps preview settings toward safer defaults', () {
    final current = PracticeSettings(
      settingsComplexityMode: SettingsComplexityMode.standard,
      chordLanguageLevel: ChordLanguageLevel.safeExtensions,
      romanPoolPreset: RomanPoolPreset.functionalJazz,
      allowTensions: true,
      selectedTensionOptions: const {'9', '11', '13'},
      secondaryDominantEnabled: true,
      modalInterchangeEnabled: true,
      allowRootlessVoicings: true,
      maxVoicingNotes: 4,
      voicingComplexity: VoicingComplexity.standard,
      modulationIntensity: ModulationIntensity.low,
    );

    final adjusted = PracticeSettingsFactory.nudgeTowardEasier(current);

    expect(adjusted.settingsComplexityMode, SettingsComplexityMode.guided);
    expect(adjusted.chordLanguageLevel, ChordLanguageLevel.seventhChords);
    expect(adjusted.romanPoolPreset, RomanPoolPreset.fullDiatonic);
    expect(adjusted.allowTensions, isFalse);
    expect(adjusted.allowRootlessVoicings, isFalse);
    expect(adjusted.maxVoicingNotes, 3);
    expect(adjusted.modulationIntensity, ModulationIntensity.off);
    expect(adjusted.modalInterchangeEnabled, isFalse);
  });

  test('nudgeTowardJazzier adds safe color without enabling rootless', () {
    final current = PracticeSettingsFactory.fromGeneratorProfile(
      const GeneratorProfile(
        harmonyLiteracy: HarmonyLiteracy.basicChordReader,
      ),
      baseSettings: PracticeSettings(),
    );

    final adjusted = PracticeSettingsFactory.nudgeTowardJazzier(current);

    expect(adjusted.chordLanguageLevel, ChordLanguageLevel.safeExtensions);
    expect(adjusted.romanPoolPreset, RomanPoolPreset.fullDiatonic);
    expect(adjusted.allowTensions, isTrue);
    expect(adjusted.selectedTensionOptions, const {'9', '11', '13'});
    expect(adjusted.allowRootlessVoicings, isFalse);
    expect(adjusted.maxVoicingNotes, 4);
  });

  test('preview builder produces a stable four-chord sample', () {
    const profile = GeneratorProfile(
      harmonyLiteracy: HarmonyLiteracy.absoluteBeginner,
      chordSymbolStyle: ChordSymbolStyle.majText,
      startingKeyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
    );

    final first = PracticeSetupPreviewBuilder.build(
      profile: profile,
      baseSettings: PracticeSettings(),
    );
    final second = PracticeSetupPreviewBuilder.build(
      profile: profile,
      baseSettings: PracticeSettings(),
    );

    expect(first.chords, hasLength(4));
    expect(first.chordSymbols(), second.chordSymbols());
    expect(
      first.chordSymbols(),
      everyElement(isNot(isEmpty)),
    );
  });
}
