import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/practice_setup_models.dart';
import 'package:chordest/settings/practice_setup_preview.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'profileFromSettings infers guided beginner answers from safe preset',
    () {
      final settings = PracticeSettingsFactory.beginnerSafePreset();

      final profile = PracticeSettingsFactory.profileFromSettings(settings);

      expect(profile.harmonyLiteracy, HarmonyLiteracy.absoluteBeginner);
      expect(profile.handComfort, HandComfort.threeNotes);
      expect(profile.chordSymbolStyle, ChordSymbolStyle.majText);
      expect(
        profile.startingKeyCenter,
        const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      );
    },
  );

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
      const GeneratorProfile(harmonyLiteracy: HarmonyLiteracy.basicChordReader),
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
    expect(first.chordSymbols(), everyElement(isNot(isEmpty)));
  });

  test('complexity melody presets diverge in bias values', () {
    final guided = PracticeSettingsFactory.applyComplexityModeMelodyPreset(
      PracticeSettings(),
      SettingsComplexityMode.guided,
    );
    final standard = PracticeSettingsFactory.applyComplexityModeMelodyPreset(
      PracticeSettings(),
      SettingsComplexityMode.standard,
    );
    final advanced = PracticeSettingsFactory.applyComplexityModeMelodyPreset(
      PracticeSettings(),
      SettingsComplexityMode.advanced,
    );

    expect(guided.melodyStyle, MelodyStyle.safe);
    expect(standard.melodyStyle, isNot(guided.melodyStyle));
    expect(advanced.melodyStyle, MelodyStyle.colorful);
    expect(guided.syncopationBias, lessThan(standard.syncopationBias));
    expect(standard.syncopationBias, lessThan(advanced.syncopationBias));
    expect(
      guided.colorRealizationBias,
      lessThan(standard.colorRealizationBias),
    );
    expect(
      standard.colorRealizationBias,
      lessThan(advanced.colorRealizationBias),
    );
    expect(guided.noveltyTarget, lessThan(standard.noveltyTarget));
    expect(standard.noveltyTarget, lessThan(advanced.noveltyTarget));
    expect(guided.motifVariationBias, lessThan(advanced.motifVariationBias));
  });

  test('quick melody presets map to distinct user-facing line profiles', () {
    final guideLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      PracticeSettings(),
      MelodyQuickPreset.guideLine,
    );
    final songLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      PracticeSettings(),
      MelodyQuickPreset.songLine,
    );
    final colorLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      PracticeSettings(),
      MelodyQuickPreset.colorLine,
    );

    expect(guideLine.melodyGenerationEnabled, isTrue);
    expect(guideLine.autoPlayMelodyWithChords, isTrue);
    expect(guideLine.allowChromaticApproaches, isFalse);
    expect(songLine.allowChromaticApproaches, isTrue);
    expect(colorLine.melodyDensity, MelodyDensity.active);
    expect(guideLine.syncopationBias, lessThan(songLine.syncopationBias));
    expect(songLine.syncopationBias, lessThan(colorLine.syncopationBias));
    expect(
      guideLine.colorRealizationBias,
      lessThan(songLine.colorRealizationBias),
    );
    expect(
      songLine.colorRealizationBias,
      lessThan(colorLine.colorRealizationBias),
    );
    expect(guideLine.noveltyTarget, lessThan(songLine.noveltyTarget));
    expect(songLine.noveltyTarget, lessThan(colorLine.noveltyTarget));
    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(guideLine),
      MelodyQuickPreset.guideLine,
    );
    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(songLine),
      MelodyQuickPreset.songLine,
    );
    expect(
      PracticeSettingsFactory.quickMelodyPresetForSettings(colorLine),
      MelodyQuickPreset.colorLine,
    );
  });

  test('effective melody mode follows quick preset biases', () {
    final guidedBase = PracticeSettings(
      settingsComplexityMode: SettingsComplexityMode.guided,
    );
    final guideLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      guidedBase,
      MelodyQuickPreset.guideLine,
    );
    final songLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      guidedBase,
      MelodyQuickPreset.songLine,
    );
    final colorLine = PracticeSettingsFactory.applyQuickMelodyPreset(
      guidedBase,
      MelodyQuickPreset.colorLine,
    );

    expect(
      PracticeSettingsFactory.effectiveMelodyModeForSettings(guideLine),
      SettingsComplexityMode.guided,
    );
    expect(
      PracticeSettingsFactory.effectiveMelodyModeForSettings(songLine),
      SettingsComplexityMode.standard,
    );
    expect(
      PracticeSettingsFactory.effectiveMelodyModeForSettings(colorLine),
      SettingsComplexityMode.advanced,
    );
  });
}
