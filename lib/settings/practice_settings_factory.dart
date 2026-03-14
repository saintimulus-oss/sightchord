import '../music/chord_theory.dart';
import 'inversion_settings.dart';
import 'practice_setup_models.dart';
import 'practice_settings.dart';

class PracticeSettingsFactory {
  const PracticeSettingsFactory._();

  static const KeyCenter _defaultBeginnerCenter = KeyCenter(
    tonicName: 'C',
    mode: KeyMode.major,
  );

  static const Set<String> _safeTensions = {'9', '11', '13'};
  static const Set<String> _expandedTensions = {
    '9',
    '11',
    '13',
    '#11',
    'b9',
    '#9',
    'b13',
  };

  static const Set<ChordQuality> _beginnerChordQualities = {
    ChordQuality.majorTriad,
    ChordQuality.minorTriad,
    ChordQuality.dominant7,
    ChordQuality.major7,
    ChordQuality.minor7,
  };

  static const Set<ChordQuality> _basicChordQualities = {
    ChordQuality.majorTriad,
    ChordQuality.minorTriad,
    ChordQuality.dominant7,
    ChordQuality.major7,
    ChordQuality.minor7,
    ChordQuality.halfDiminished7,
    ChordQuality.six,
    ChordQuality.minor6,
  };

  static const Set<ChordQuality> _functionalChordQualities = {
    ChordQuality.majorTriad,
    ChordQuality.minorTriad,
    ChordQuality.dominant7,
    ChordQuality.major7,
    ChordQuality.minor7,
    ChordQuality.halfDiminished7,
    ChordQuality.six,
    ChordQuality.minor6,
    ChordQuality.major69,
  };

  static PracticeSettings beginnerSafePreset({PracticeSettings? baseSettings}) {
    final base = baseSettings ?? PracticeSettings();
    return base.copyWith(
      guidedSetupCompleted: true,
      settingsComplexityMode: SettingsComplexityMode.guided,
      preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      chordLanguageLevel: ChordLanguageLevel.triadsOnly,
      romanPoolPreset: RomanPoolPreset.corePrimary,
      metronomeEnabled: true,
      metronomeVolume: 0.4,
      metronomeSound: MetronomeSound.tick,
      bpm: 60,
      activeKeyCenters: {_defaultBeginnerCenter},
      smartGeneratorMode: true,
      secondaryDominantEnabled: false,
      substituteDominantEnabled: false,
      modalInterchangeEnabled: false,
      modulationIntensity: ModulationIntensity.off,
      jazzPreset: JazzPreset.standardsCore,
      sourceProfile: SourceProfile.fakebookStandard,
      smartDiagnosticsEnabled: false,
      chordSymbolStyle: ChordSymbolStyle.majText,
      allowV7sus4: false,
      allowTensions: false,
      enabledChordQualities: _beginnerChordQualities,
      selectedTensionOptions: _safeTensions,
      inversionSettings: const InversionSettings(
        enabled: false,
        firstInversionEnabled: false,
        secondInversionEnabled: false,
        thirdInversionEnabled: false,
      ),
      voicingSuggestionsEnabled: true,
      voicingComplexity: VoicingComplexity.basic,
      voicingTopNotePreference: VoicingTopNotePreference.auto,
      allowRootlessVoicings: false,
      maxVoicingNotes: 3,
      lookAheadDepth: 1,
      showVoicingReasons: true,
      keyCenterLabelStyle: KeyCenterLabelStyle.modeText,
    );
  }

  static PracticeSettings fromGeneratorProfile(
    GeneratorProfile profile, {
    PracticeSettings? baseSettings,
  }) {
    var settings = beginnerSafePreset(baseSettings: baseSettings).copyWith(
      chordSymbolStyle: profile.chordSymbolStyle,
      activeKeyCenters: {profile.startingKeyCenter},
    );

    settings = _applyLiteracy(settings, profile);
    settings = _applyHandComfort(settings, profile);
    settings = _applyExploration(settings, profile);
    settings = _applyGoal(settings, profile);

    return settings.copyWith(
      guidedSetupCompleted: true,
      chordSymbolStyle: profile.chordSymbolStyle,
      activeKeyCenters: {profile.startingKeyCenter},
      keyCenterLabelStyle: KeyCenterLabelStyle.modeText,
      smartDiagnosticsEnabled: false,
      showVoicingReasons: true,
    );
  }

  static GeneratorProfile profileFromSettings(PracticeSettings settings) {
    final startingKeyCenter = _firstSupportedStartingCenter(settings);
    final harmonyLiteracy = _inferHarmonyLiteracy(settings);
    return GeneratorProfile(
      goal: _inferGoal(settings),
      harmonyLiteracy: harmonyLiteracy,
      handComfort: _inferHandComfort(settings),
      explorationPreference: harmonyLiteracy ==
              HarmonyLiteracy.absoluteBeginner
          ? ExplorationPreference.safe
          : _inferExplorationPreference(settings),
      chordSymbolStyle: settings.chordSymbolStyle,
      startingKeyCenter: startingKeyCenter,
    );
  }

  static PracticeSettings nudgeTowardEasier(PracticeSettings settings) {
    final nextLanguageLevel = _stepDownChordLanguageLevel(
      settings.chordLanguageLevel,
    );
    final nextRomanPool = _stepDownRomanPoolPreset(settings.romanPoolPreset);
    final maxVoicingNotes = settings.maxVoicingNotes <= 3
        ? 3
        : settings.maxVoicingNotes - 1;

    return _applyLanguagePreset(
      settings.copyWith(
        settingsComplexityMode: SettingsComplexityMode.guided,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
        chordLanguageLevel: nextLanguageLevel,
        romanPoolPreset: nextRomanPool,
        allowRootlessVoicings: false,
        maxVoicingNotes: maxVoicingNotes,
        lookAheadDepth: 1,
        voicingComplexity: VoicingComplexity.basic,
        secondaryDominantEnabled: nextRomanPool == RomanPoolPreset.functionalJazz
            ? settings.secondaryDominantEnabled
            : false,
        substituteDominantEnabled: false,
        modalInterchangeEnabled: false,
        modulationIntensity: ModulationIntensity.off,
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
      ),
      nextLanguageLevel,
    );
  }

  static PracticeSettings nudgeTowardJazzier(PracticeSettings settings) {
    final nextLanguageLevel = _stepUpChordLanguageLevel(
      settings.chordLanguageLevel,
    );
    final nextRomanPool = _stepUpRomanPoolPreset(settings.romanPoolPreset);
    final nextSettings = _applyLanguagePreset(
      settings.copyWith(
        settingsComplexityMode:
            nextLanguageLevel.index >= ChordLanguageLevel.safeExtensions.index ||
                nextRomanPool.index >= RomanPoolPreset.functionalJazz.index
            ? SettingsComplexityMode.standard
            : SettingsComplexityMode.guided,
        preferredSuggestionKind:
            nextLanguageLevel == ChordLanguageLevel.triadsOnly
            ? DefaultVoicingSuggestionKind.easy
            : DefaultVoicingSuggestionKind.natural,
        chordLanguageLevel: nextLanguageLevel,
        romanPoolPreset: nextRomanPool,
        allowRootlessVoicings: false,
        maxVoicingNotes: settings.maxVoicingNotes < 4
            ? 4
            : settings.maxVoicingNotes,
        lookAheadDepth: settings.lookAheadDepth < 2 ? 2 : settings.lookAheadDepth,
        voicingComplexity:
            settings.voicingComplexity == VoicingComplexity.basic
            ? VoicingComplexity.standard
            : settings.voicingComplexity,
        secondaryDominantEnabled:
            nextRomanPool.index >= RomanPoolPreset.functionalJazz.index,
        substituteDominantEnabled: false,
        modalInterchangeEnabled: false,
        modulationIntensity:
            nextRomanPool.index >= RomanPoolPreset.functionalJazz.index
            ? ModulationIntensity.low
            : ModulationIntensity.off,
        jazzPreset: nextRomanPool.index >= RomanPoolPreset.functionalJazz.index
            ? JazzPreset.modulationStudy
            : JazzPreset.standardsCore,
        sourceProfile: settings.sourceProfile == SourceProfile.recordingInspired &&
                settings.settingsComplexityMode ==
                    SettingsComplexityMode.advanced
            ? SourceProfile.recordingInspired
            : SourceProfile.fakebookStandard,
      ),
      nextLanguageLevel,
    );

    return nextLanguageLevel.index >= ChordLanguageLevel.safeExtensions.index
        ? nextSettings.copyWith(
            allowTensions: true,
            selectedTensionOptions: _safeTensions,
          )
        : nextSettings;
  }

  static PracticeSettings _applyLiteracy(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    switch (profile.harmonyLiteracy) {
      case HarmonyLiteracy.absoluteBeginner:
        return settings.copyWith(
          settingsComplexityMode: SettingsComplexityMode.guided,
          preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
          chordLanguageLevel: ChordLanguageLevel.triadsOnly,
          romanPoolPreset: RomanPoolPreset.corePrimary,
          voicingComplexity: VoicingComplexity.basic,
          allowRootlessVoicings: false,
          maxVoicingNotes: 3,
          lookAheadDepth: 1,
          allowTensions: false,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _beginnerChordQualities,
          secondaryDominantEnabled: false,
          substituteDominantEnabled: false,
          modalInterchangeEnabled: false,
          modulationIntensity: ModulationIntensity.off,
          jazzPreset: JazzPreset.standardsCore,
          sourceProfile: SourceProfile.fakebookStandard,
          allowV7sus4: false,
        );
      case HarmonyLiteracy.basicChordReader:
        return settings.copyWith(
          settingsComplexityMode: SettingsComplexityMode.guided,
          preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
          chordLanguageLevel: ChordLanguageLevel.seventhChords,
          romanPoolPreset: RomanPoolPreset.coreDiatonic,
          voicingComplexity: VoicingComplexity.basic,
          allowRootlessVoicings: false,
          maxVoicingNotes: 4,
          lookAheadDepth: 1,
          allowTensions: false,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _basicChordQualities,
          secondaryDominantEnabled: false,
          substituteDominantEnabled: false,
          modalInterchangeEnabled: false,
          modulationIntensity: ModulationIntensity.off,
          jazzPreset: JazzPreset.standardsCore,
          sourceProfile: SourceProfile.fakebookStandard,
          allowV7sus4: false,
        );
      case HarmonyLiteracy.functionalHarmony:
        return settings.copyWith(
          settingsComplexityMode: SettingsComplexityMode.standard,
          preferredSuggestionKind: DefaultVoicingSuggestionKind.natural,
          chordLanguageLevel: ChordLanguageLevel.seventhChords,
          romanPoolPreset: RomanPoolPreset.functionalJazz,
          voicingComplexity: VoicingComplexity.standard,
          allowRootlessVoicings: false,
          maxVoicingNotes: 4,
          lookAheadDepth: 1,
          allowTensions: false,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _functionalChordQualities,
          secondaryDominantEnabled: false,
          substituteDominantEnabled: false,
          modalInterchangeEnabled: false,
          modulationIntensity: ModulationIntensity.off,
          jazzPreset: JazzPreset.standardsCore,
          sourceProfile: SourceProfile.fakebookStandard,
          allowV7sus4: false,
        );
      case HarmonyLiteracy.reharmReady:
        return settings.copyWith(
          settingsComplexityMode: SettingsComplexityMode.advanced,
          preferredSuggestionKind: DefaultVoicingSuggestionKind.natural,
          chordLanguageLevel: ChordLanguageLevel.fullExtensions,
          romanPoolPreset: RomanPoolPreset.expandedColor,
          voicingComplexity: VoicingComplexity.standard,
          allowRootlessVoicings: false,
          maxVoicingNotes: 4,
          lookAheadDepth: 2,
          allowTensions: true,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: MusicTheory.defaultGeneratorChordQualities(
            allowV7sus4: false,
          ),
          secondaryDominantEnabled: true,
          substituteDominantEnabled: false,
          modalInterchangeEnabled: false,
          modulationIntensity: ModulationIntensity.low,
          jazzPreset: JazzPreset.modulationStudy,
          sourceProfile: SourceProfile.fakebookStandard,
          allowV7sus4: false,
        );
    }
  }

  static PracticeSettings _applyHandComfort(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    if (!profile.asksHandComfort) {
      return settings;
    }

    return switch (profile.handComfort) {
      HandComfort.threeNotes => settings.copyWith(
        allowRootlessVoicings: false,
        maxVoicingNotes: 3,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      ),
      HandComfort.fourNotes => settings.copyWith(
        allowRootlessVoicings: false,
        maxVoicingNotes: 4,
      ),
      HandComfort.jazzShapes => settings.copyWith(
        allowRootlessVoicings:
            profile.harmonyLiteracy == HarmonyLiteracy.reharmReady,
        maxVoicingNotes: profile.harmonyLiteracy == HarmonyLiteracy.reharmReady
            ? 5
            : 4,
      ),
    };
  }

  static PracticeSettings _applyExploration(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    if (!profile.asksExplorationPreference) {
      return settings;
    }

    return switch (profile.explorationPreference) {
      ExplorationPreference.safe => settings.copyWith(
        preferredSuggestionKind:
            settings.preferredSuggestionKind ==
                DefaultVoicingSuggestionKind.colorful
            ? DefaultVoicingSuggestionKind.natural
            : settings.preferredSuggestionKind,
        sourceProfile: SourceProfile.fakebookStandard,
        chordLanguageLevel:
            settings.chordLanguageLevel == ChordLanguageLevel.fullExtensions
            ? ChordLanguageLevel.safeExtensions
            : settings.chordLanguageLevel,
      ),
      ExplorationPreference.jazzy => _applyJazzyExploration(settings, profile),
      ExplorationPreference.colorful => _applyColorfulExploration(
        settings,
        profile,
      ),
    };
  }

  static PracticeSettings _applyJazzyExploration(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    if (profile.harmonyLiteracy == HarmonyLiteracy.functionalHarmony) {
      return settings.copyWith(
        allowTensions: true,
        selectedTensionOptions: _safeTensions,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        secondaryDominantEnabled: true,
        voicingComplexity: VoicingComplexity.standard,
        jazzPreset: profile.goal == OnboardingGoal.harmonyStudy
            ? JazzPreset.modulationStudy
            : JazzPreset.standardsCore,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.natural,
      );
    }

    if (profile.harmonyLiteracy == HarmonyLiteracy.reharmReady) {
      return settings.copyWith(
        allowTensions: true,
        selectedTensionOptions: _expandedTensions,
        chordLanguageLevel: ChordLanguageLevel.fullExtensions,
        romanPoolPreset: RomanPoolPreset.expandedColor,
        secondaryDominantEnabled: true,
        substituteDominantEnabled: true,
        modalInterchangeEnabled: false,
        modulationIntensity: ModulationIntensity.low,
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.recordingInspired,
        allowV7sus4: true,
        enabledChordQualities: MusicTheory.defaultGeneratorChordQualities(
          allowV7sus4: true,
        ),
        preferredSuggestionKind: DefaultVoicingSuggestionKind.colorful,
      );
    }

    return settings;
  }

  static PracticeSettings _applyColorfulExploration(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    if (profile.harmonyLiteracy == HarmonyLiteracy.functionalHarmony) {
      return settings.copyWith(
        allowTensions: true,
        selectedTensionOptions: _safeTensions,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        secondaryDominantEnabled: true,
        voicingComplexity: VoicingComplexity.standard,
        jazzPreset: JazzPreset.modulationStudy,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.natural,
      );
    }

    if (profile.harmonyLiteracy == HarmonyLiteracy.reharmReady) {
      return settings.copyWith(
        allowTensions: true,
        selectedTensionOptions: _expandedTensions,
        chordLanguageLevel: ChordLanguageLevel.fullExtensions,
        romanPoolPreset: RomanPoolPreset.expandedColor,
        secondaryDominantEnabled: true,
        substituteDominantEnabled: true,
        modalInterchangeEnabled: true,
        modulationIntensity: ModulationIntensity.medium,
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
        voicingComplexity: VoicingComplexity.modern,
        allowV7sus4: true,
        enabledChordQualities: MusicTheory.defaultGeneratorChordQualities(
          allowV7sus4: true,
        ),
        preferredSuggestionKind: DefaultVoicingSuggestionKind.colorful,
      );
    }

    return settings;
  }

  static PracticeSettings _applyGoal(
    PracticeSettings settings,
    GeneratorProfile profile,
  ) {
    return switch (profile.goal) {
      OnboardingGoal.earTraining => settings.copyWith(
        preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      ),
      OnboardingGoal.keyboardPractice => settings.copyWith(
        preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      ),
      OnboardingGoal.songIdeas => settings.copyWith(
        settingsComplexityMode:
            settings.settingsComplexityMode == SettingsComplexityMode.guided &&
                profile.harmonyLiteracy != HarmonyLiteracy.absoluteBeginner
            ? SettingsComplexityMode.standard
            : settings.settingsComplexityMode,
        preferredSuggestionKind:
            settings.preferredSuggestionKind ==
                    DefaultVoicingSuggestionKind.easy &&
                profile.harmonyLiteracy != HarmonyLiteracy.absoluteBeginner
            ? DefaultVoicingSuggestionKind.natural
            : settings.preferredSuggestionKind,
        sourceProfile:
            profile.harmonyLiteracy == HarmonyLiteracy.reharmReady &&
                profile.explorationPreference != ExplorationPreference.safe
            ? SourceProfile.recordingInspired
            : settings.sourceProfile,
      ),
      OnboardingGoal.harmonyStudy => settings.copyWith(
        settingsComplexityMode:
            settings.settingsComplexityMode == SettingsComplexityMode.guided &&
                profile.harmonyLiteracy != HarmonyLiteracy.absoluteBeginner
            ? SettingsComplexityMode.standard
            : settings.settingsComplexityMode,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.natural,
        jazzPreset:
            profile.harmonyLiteracy.index >=
                HarmonyLiteracy.functionalHarmony.index
            ? JazzPreset.modulationStudy
            : settings.jazzPreset,
      ),
    };
  }

  static KeyCenter _firstSupportedStartingCenter(PracticeSettings settings) {
    final supported = settings.activeKeyCenters
        .where(GeneratorProfile.supportedStartingKeyCenters.contains)
        .toList(growable: false);
    if (supported.isNotEmpty) {
      supported.sort(_compareKeyCenters);
      return supported.first;
    }
    return GeneratorProfile.defaultStartingKeyCenter;
  }

  static int _compareKeyCenters(KeyCenter a, KeyCenter b) {
    final modeCompare = a.mode.index.compareTo(b.mode.index);
    if (modeCompare != 0) {
      return modeCompare;
    }
    return a.tonicName.compareTo(b.tonicName);
  }

  static OnboardingGoal _inferGoal(PracticeSettings settings) {
    if (settings.sourceProfile == SourceProfile.recordingInspired) {
      return OnboardingGoal.songIdeas;
    }
    if (settings.romanPoolPreset.index >= RomanPoolPreset.functionalJazz.index &&
        settings.settingsComplexityMode != SettingsComplexityMode.guided) {
      return OnboardingGoal.harmonyStudy;
    }
    if (settings.maxVoicingNotes <= 3 ||
        settings.preferredSuggestionKind ==
            DefaultVoicingSuggestionKind.easy) {
      return OnboardingGoal.keyboardPractice;
    }
    return OnboardingGoal.earTraining;
  }

  static HarmonyLiteracy _inferHarmonyLiteracy(PracticeSettings settings) {
    if (settings.chordLanguageLevel == ChordLanguageLevel.fullExtensions ||
        settings.romanPoolPreset == RomanPoolPreset.expandedColor ||
        settings.settingsComplexityMode == SettingsComplexityMode.advanced) {
      return HarmonyLiteracy.reharmReady;
    }
    if (settings.chordLanguageLevel == ChordLanguageLevel.safeExtensions ||
        settings.romanPoolPreset == RomanPoolPreset.functionalJazz ||
        settings.secondaryDominantEnabled) {
      return HarmonyLiteracy.functionalHarmony;
    }
    if (settings.chordLanguageLevel == ChordLanguageLevel.seventhChords ||
        settings.maxVoicingNotes >= 4) {
      return HarmonyLiteracy.basicChordReader;
    }
    return HarmonyLiteracy.absoluteBeginner;
  }

  static HandComfort _inferHandComfort(PracticeSettings settings) {
    if (settings.allowRootlessVoicings || settings.maxVoicingNotes >= 5) {
      return HandComfort.jazzShapes;
    }
    if (settings.maxVoicingNotes >= 4) {
      return HandComfort.fourNotes;
    }
    return HandComfort.threeNotes;
  }

  static ExplorationPreference _inferExplorationPreference(
    PracticeSettings settings,
  ) {
    if (settings.chordLanguageLevel == ChordLanguageLevel.fullExtensions ||
        settings.romanPoolPreset == RomanPoolPreset.expandedColor ||
        settings.modalInterchangeEnabled ||
        settings.substituteDominantEnabled) {
      return ExplorationPreference.colorful;
    }
    if (settings.allowTensions ||
        settings.chordLanguageLevel == ChordLanguageLevel.safeExtensions ||
        settings.romanPoolPreset == RomanPoolPreset.functionalJazz ||
        settings.secondaryDominantEnabled) {
      return ExplorationPreference.jazzy;
    }
    return ExplorationPreference.safe;
  }

  static ChordLanguageLevel _stepDownChordLanguageLevel(
    ChordLanguageLevel level,
  ) {
    if (level == ChordLanguageLevel.triadsOnly) {
      return level;
    }
    return ChordLanguageLevel.values[level.index - 1];
  }

  static ChordLanguageLevel _stepUpChordLanguageLevel(
    ChordLanguageLevel level,
  ) {
    if (level.index >= ChordLanguageLevel.safeExtensions.index) {
      return level;
    }
    return ChordLanguageLevel.values[level.index + 1];
  }

  static RomanPoolPreset _stepDownRomanPoolPreset(RomanPoolPreset preset) {
    if (preset == RomanPoolPreset.corePrimary) {
      return preset;
    }
    return RomanPoolPreset.values[preset.index - 1];
  }

  static RomanPoolPreset _stepUpRomanPoolPreset(RomanPoolPreset preset) {
    if (preset == RomanPoolPreset.expandedColor) {
      return preset;
    }
    if (preset == RomanPoolPreset.functionalJazz) {
      return preset;
    }
    return RomanPoolPreset.values[preset.index + 1];
  }

  static PracticeSettings _applyLanguagePreset(
    PracticeSettings settings,
    ChordLanguageLevel level,
  ) {
    switch (level) {
      case ChordLanguageLevel.triadsOnly:
        return settings.copyWith(
          allowTensions: false,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _beginnerChordQualities,
          allowV7sus4: false,
        );
      case ChordLanguageLevel.seventhChords:
        return settings.copyWith(
          allowTensions: false,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _basicChordQualities,
          allowV7sus4: false,
        );
      case ChordLanguageLevel.safeExtensions:
        return settings.copyWith(
          allowTensions: true,
          selectedTensionOptions: _safeTensions,
          enabledChordQualities: _functionalChordQualities,
          allowV7sus4: false,
        );
      case ChordLanguageLevel.fullExtensions:
        return settings.copyWith(
          allowTensions: true,
          selectedTensionOptions: settings.selectedTensionOptions.isEmpty
              ? _expandedTensions
              : settings.selectedTensionOptions,
          enabledChordQualities: settings.enabledChordQualities.isEmpty
              ? MusicTheory.defaultGeneratorChordQualities(
                  allowV7sus4: settings.allowV7sus4,
                )
              : settings.enabledChordQualities,
        );
    }
  }
}
