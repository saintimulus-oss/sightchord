import 'package:shared_preferences/shared_preferences.dart';

import '../audio/harmony_audio_models.dart';
import '../music/anchor_loop_layout.dart';
import '../music/chord_anchor_loop.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import 'practice_settings.dart';

typedef SharedPreferencesLoader = Future<SharedPreferences> Function();

class PracticeSettingsStore {
  const PracticeSettingsStore({
    SharedPreferencesLoader preferencesLoader = SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String languageKey = 'language';
  static const String appThemeModeKey = 'appThemeMode';
  static const String guidedSetupCompletedKey = 'guidedSetupCompleted';
  static const String settingsComplexityModeKey = 'settingsComplexityMode';
  static const String preferredSuggestionKindKey = 'preferredSuggestionKind';
  static const String chordLanguageLevelKey = 'chordLanguageLevel';
  static const String romanPoolPresetKey = 'romanPoolPreset';
  static const String metronomeEnabledKey = 'metronomeEnabled';
  static const String metronomeVolumeKey = 'metronomeVolume';
  static const String metronomeSoundKey = 'metronomeSound';
  static const String metronomeSourceKey = 'metronomeSource';
  static const String metronomePatternKey = 'metronomePattern';
  static const String metronomeUseAccentSoundKey = 'metronomeUseAccentSound';
  static const String metronomeAccentSourceKey = 'metronomeAccentSource';
  static const String timeSignatureKey = 'timeSignature';
  static const String harmonicRhythmPresetKey = 'harmonicRhythmPreset';
  static const String autoPlayChordChangesKey = 'autoPlayChordChanges';
  static const String autoPlayPatternKey = 'autoPlayPattern';
  static const String autoPlayHoldFactorKey = 'autoPlayHoldFactor';
  static const String autoPlayMelodyWithChordsKey = 'autoPlayMelodyWithChords';
  static const String melodyGenerationEnabledKey = 'melodyGenerationEnabled';
  static const String melodyDensityKey = 'melodyDensity';
  static const String motifRepetitionStrengthKey = 'motifRepetitionStrength';
  static const String approachToneDensityKey = 'approachToneDensity';
  static const String melodyRangeLowKey = 'melodyRangeLow';
  static const String melodyRangeHighKey = 'melodyRangeHigh';
  static const String melodyStyleKey = 'melodyStyle';
  static const String allowChromaticApproachesKey = 'allowChromaticApproaches';
  static const String syncopationBiasKey = 'syncopationBias';
  static const String colorRealizationBiasKey = 'colorRealizationBias';
  static const String noveltyTargetKey = 'noveltyTarget';
  static const String motifVariationBiasKey = 'motifVariationBias';
  static const String anticipationProbabilityKey = 'anticipationProbability';
  static const String colorToneTargetKey = 'colorToneTarget';
  static const String exactRepeatTargetKey = 'exactRepeatTarget';
  static const String melodyPlaybackModeKey = 'melodyPlaybackMode';
  static const String harmonyMasterVolumeKey = 'harmonyMasterVolume';
  static const String harmonyPreviewHoldFactorKey = 'harmonyPreviewHoldFactor';
  static const String harmonyArpeggioStepSpeedKey = 'harmonyArpeggioStepSpeed';
  static const String harmonyVelocityHumanizationKey =
      'harmonyVelocityHumanization';
  static const String harmonyGainRandomnessKey = 'harmonyGainRandomness';
  static const String harmonyTimingHumanizationKey =
      'harmonyTimingHumanization';
  static const String chordAnchorLoopKey = 'chordAnchorLoop';
  static const String activeKeysKey = 'activeKeys';
  static const String activeKeyCentersKey = 'activeKeyCenters';
  static const String smartGeneratorModeKey = 'smartGeneratorMode';
  static const String secondaryDominantEnabledKey = 'secondaryDominantEnabled';
  static const String substituteDominantEnabledKey =
      'substituteDominantEnabled';
  static const String modalInterchangeEnabledKey = 'modalInterchangeEnabled';
  static const String modulationIntensityKey = 'modulationIntensity';
  static const String jazzPresetKey = 'jazzPreset';
  static const String sourceProfileKey = 'sourceProfile';
  static const String smartDiagnosticsEnabledKey = 'smartDiagnosticsEnabled';
  static const String chordSymbolStyleKey = 'chordSymbolStyle';
  static const String allowV7sus4Key = 'allowV7sus4';
  static const String allowTensionsKey = 'allowTensions';
  static const String enabledChordQualitiesKey = 'enabledChordQualities';
  static const String selectedTensionsKey = 'selectedTensions';
  static const String voicingSuggestionsEnabledKey =
      'voicingSuggestionsEnabled';
  static const String voicingDisplayModeKey = 'voicingDisplayMode';
  static const String voicingComplexityKey = 'voicingComplexity';
  static const String voicingTopNotePreferenceKey = 'voicingTopNotePreference';
  static const String allowRootlessVoicingsKey = 'allowRootlessVoicings';
  static const String maxVoicingNotesKey = 'maxVoicingNotes';
  static const String lookAheadDepthKey = 'lookAheadDepth';
  static const String showVoicingReasonsKey = 'showVoicingReasons';
  static const String bpmKey = 'bpm';
  static const String keyCenterLabelStyleKey = 'keyCenterLabelStyle';
  static const String progressionExplanationDetailLevelKey =
      'progressionExplanationDetailLevel';
  static const String progressionHighlightThemeKey =
      'progressionHighlightTheme';
  static const String inversionsEnabledKey = 'inversionsEnabled';
  static const String firstInversionEnabledKey = 'firstInversionEnabled';
  static const String secondInversionEnabledKey = 'secondInversionEnabled';
  static const String thirdInversionEnabledKey = 'thirdInversionEnabled';

  static const List<String> _legacyStoredSettingsKeys = [
    languageKey,
    appThemeModeKey,
    metronomeEnabledKey,
    metronomeVolumeKey,
    metronomeSoundKey,
    metronomeSourceKey,
    metronomePatternKey,
    metronomeUseAccentSoundKey,
    metronomeAccentSourceKey,
    timeSignatureKey,
    harmonicRhythmPresetKey,
    autoPlayChordChangesKey,
    autoPlayPatternKey,
    autoPlayHoldFactorKey,
    autoPlayMelodyWithChordsKey,
    melodyGenerationEnabledKey,
    melodyDensityKey,
    motifRepetitionStrengthKey,
    approachToneDensityKey,
    melodyRangeLowKey,
    melodyRangeHighKey,
    melodyStyleKey,
    allowChromaticApproachesKey,
    syncopationBiasKey,
    colorRealizationBiasKey,
    noveltyTargetKey,
    motifVariationBiasKey,
    anticipationProbabilityKey,
    colorToneTargetKey,
    exactRepeatTargetKey,
    melodyPlaybackModeKey,
    harmonyMasterVolumeKey,
    harmonyPreviewHoldFactorKey,
    harmonyArpeggioStepSpeedKey,
    harmonyVelocityHumanizationKey,
    harmonyGainRandomnessKey,
    harmonyTimingHumanizationKey,
    chordAnchorLoopKey,
    activeKeysKey,
    activeKeyCentersKey,
    smartGeneratorModeKey,
    secondaryDominantEnabledKey,
    substituteDominantEnabledKey,
    modalInterchangeEnabledKey,
    modulationIntensityKey,
    jazzPresetKey,
    sourceProfileKey,
    smartDiagnosticsEnabledKey,
    chordSymbolStyleKey,
    allowV7sus4Key,
    allowTensionsKey,
    enabledChordQualitiesKey,
    selectedTensionsKey,
    voicingSuggestionsEnabledKey,
    voicingDisplayModeKey,
    voicingComplexityKey,
    voicingTopNotePreferenceKey,
    allowRootlessVoicingsKey,
    maxVoicingNotesKey,
    lookAheadDepthKey,
    showVoicingReasonsKey,
    bpmKey,
    keyCenterLabelStyleKey,
    progressionExplanationDetailLevelKey,
    progressionHighlightThemeKey,
    inversionsEnabledKey,
    firstInversionEnabledKey,
    secondInversionEnabledKey,
    thirdInversionEnabledKey,
  ];

  final SharedPreferencesLoader _preferencesLoader;

  Future<PracticeSettings> load({
    required PracticeSettings fallbackSettings,
  }) async {
    final preferences = await _preferencesLoader();
    final inferredExistingUser = _hasStoredLegacyPracticeSettings(preferences);
    final storedLanguage = preferences.getString(languageKey);
    final storedAppThemeMode = preferences.getString(appThemeModeKey);
    final storedGuidedSetupCompleted = preferences.getBool(
      guidedSetupCompletedKey,
    );
    final storedSettingsComplexityMode = preferences.getString(
      settingsComplexityModeKey,
    );
    final storedPreferredSuggestionKind = preferences.getString(
      preferredSuggestionKindKey,
    );
    final storedChordLanguageLevel = preferences.getString(
      chordLanguageLevelKey,
    );
    final storedRomanPoolPreset = preferences.getString(romanPoolPresetKey);
    final storedMetronomeSound = preferences.getString(metronomeSoundKey);
    final storedMetronomeSource = preferences.getString(metronomeSourceKey);
    final storedMetronomePattern = preferences.getString(metronomePatternKey);
    final storedMetronomeAccentSource = preferences.getString(
      metronomeAccentSourceKey,
    );
    final storedTimeSignature = preferences.getString(timeSignatureKey);
    final storedHarmonicRhythmPreset = preferences.getString(
      harmonicRhythmPresetKey,
    );
    final storedMelodyDensity = preferences.getString(melodyDensityKey);
    final storedMelodyStyle = preferences.getString(melodyStyleKey);
    final storedMelodyPlaybackMode = preferences.getString(
      melodyPlaybackModeKey,
    );
    final storedChordAnchorLoop = preferences.getString(chordAnchorLoopKey);
    final storedActiveKeyCenters = preferences.getStringList(
      activeKeyCentersKey,
    );
    final legacyActiveKeys = preferences
        .getStringList(activeKeysKey)
        ?.where(MusicTheory.keyOptions.contains)
        .toSet();
    final storedSelectedTensions = preferences.getStringList(
      selectedTensionsKey,
    );
    final storedEnabledChordQualities = preferences.getStringList(
      enabledChordQualitiesKey,
    );
    final storedTopNotePreference = preferences.getString(
      voicingTopNotePreferenceKey,
    );
    final storedVoicingDisplayMode = preferences.getString(
      voicingDisplayModeKey,
    );
    final resolvedAllowV7sus4 =
        preferences.getBool(allowV7sus4Key) ?? fallbackSettings.allowV7sus4;
    final resolvedGuidedSetupCompleted =
        storedGuidedSetupCompleted ??
        (inferredExistingUser || fallbackSettings.guidedSetupCompleted);
    final resolvedSettingsComplexityMode = storedSettingsComplexityMode == null
        ? inferredExistingUser && !fallbackSettings.guidedSetupCompleted
              ? SettingsComplexityMode.standard
              : fallbackSettings.settingsComplexityMode
        : SettingsComplexityModeX.fromStorageKey(storedSettingsComplexityMode);
    final resolvedPreferredSuggestionKind =
        storedPreferredSuggestionKind == null
        ? fallbackSettings.preferredSuggestionKind
        : DefaultVoicingSuggestionKindX.fromStorageKey(
            storedPreferredSuggestionKind,
          );
    final resolvedChordLanguageLevel = storedChordLanguageLevel == null
        ? fallbackSettings.chordLanguageLevel
        : ChordLanguageLevelX.fromStorageKey(storedChordLanguageLevel);
    final resolvedRomanPoolPreset = storedRomanPoolPreset == null
        ? fallbackSettings.romanPoolPreset
        : RomanPoolPresetX.fromStorageKey(storedRomanPoolPreset);
    final resolvedTimeSignature = storedTimeSignature == null
        ? fallbackSettings.timeSignature
        : PracticeTimeSignatureX.fromStorageKey(storedTimeSignature);
    final resolvedHarmonicRhythmPreset = storedHarmonicRhythmPreset == null
        ? fallbackSettings.harmonicRhythmPreset
        : HarmonicRhythmPresetX.fromStorageKey(storedHarmonicRhythmPreset);
    final resolvedPrimaryFallbackSound = storedMetronomeSound == null
        ? fallbackSettings.metronomeSound
        : MetronomeSoundX.fromStorageKey(storedMetronomeSound);
    final resolvedMetronomeSource = storedMetronomeSource == null
        ? fallbackSettings.metronomeSource.copyWith(
            builtInSound: resolvedPrimaryFallbackSound,
          )
        : MetronomeSourceSpec.fromStorageString(
            storedMetronomeSource,
          ).normalized(fallbackSound: resolvedPrimaryFallbackSound);
    final resolvedMetronomePattern = storedMetronomePattern == null
        ? fallbackSettings.metronomePattern.normalized(
            beatsPerBar: resolvedTimeSignature.beatsPerBar,
          )
        : MetronomePatternSettings.fromStorageString(
            storedMetronomePattern,
          ).normalized(beatsPerBar: resolvedTimeSignature.beatsPerBar);
    final resolvedMetronomeAccentSource = storedMetronomeAccentSource == null
        ? fallbackSettings.metronomeAccentSource
        : MetronomeSourceSpec.fromStorageString(
            storedMetronomeAccentSource,
          ).normalized(fallbackSound: fallbackSettings.metronomeAccentSound);
    final resolvedAnchorLoop = AnchorLoopLayout.sanitizeLoop(
      loop: storedChordAnchorLoop == null
          ? fallbackSettings.anchorLoop
          : ChordAnchorLoop.fromStorageString(storedChordAnchorLoop),
      timeSignature: resolvedTimeSignature,
      harmonicRhythmPreset: resolvedHarmonicRhythmPreset,
    );
    return PracticeSettings(
      language: storedLanguage == null
          ? fallbackSettings.language
          : AppLanguageX.fromStorageKey(storedLanguage),
      appThemeMode: storedAppThemeMode == null
          ? fallbackSettings.appThemeMode
          : AppThemeModeX.fromStorageKey(storedAppThemeMode),
      guidedSetupCompleted: resolvedGuidedSetupCompleted,
      settingsComplexityMode: resolvedSettingsComplexityMode,
      preferredSuggestionKind: resolvedPreferredSuggestionKind,
      chordLanguageLevel: resolvedChordLanguageLevel,
      romanPoolPreset: resolvedRomanPoolPreset,
      metronomeEnabled:
          preferences.getBool(metronomeEnabledKey) ??
          fallbackSettings.metronomeEnabled,
      metronomeVolume:
          preferences.getDouble(metronomeVolumeKey) ??
          fallbackSettings.metronomeVolume,
      metronomeSound: resolvedMetronomeSource.builtInSound,
      metronomeSource: resolvedMetronomeSource,
      metronomePattern: resolvedMetronomePattern,
      metronomeUseAccentSound:
          preferences.getBool(metronomeUseAccentSoundKey) ??
          fallbackSettings.metronomeUseAccentSound,
      metronomeAccentSource: resolvedMetronomeAccentSource,
      timeSignature: resolvedTimeSignature,
      harmonicRhythmPreset: resolvedHarmonicRhythmPreset,
      autoPlayChordChanges:
          preferences.getBool(autoPlayChordChangesKey) ??
          fallbackSettings.autoPlayChordChanges,
      autoPlayPattern: preferences.getString(autoPlayPatternKey) == null
          ? fallbackSettings.autoPlayPattern
          : HarmonyPlaybackPatternX.fromStorageKey(
              preferences.getString(autoPlayPatternKey),
            ),
      autoPlayHoldFactor:
          preferences.getDouble(autoPlayHoldFactorKey) ??
          fallbackSettings.autoPlayHoldFactor,
      autoPlayMelodyWithChords:
          preferences.getBool(autoPlayMelodyWithChordsKey) ??
          fallbackSettings.autoPlayMelodyWithChords,
      melodyGenerationEnabled:
          preferences.getBool(melodyGenerationEnabledKey) ??
          fallbackSettings.melodyGenerationEnabled,
      melodyDensity: storedMelodyDensity == null
          ? fallbackSettings.melodyDensity
          : MelodyDensityX.fromStorageKey(storedMelodyDensity),
      motifRepetitionStrength:
          preferences.getDouble(motifRepetitionStrengthKey) ??
          fallbackSettings.motifRepetitionStrength,
      approachToneDensity:
          preferences.getDouble(approachToneDensityKey) ??
          fallbackSettings.approachToneDensity,
      melodyRangeLow:
          preferences.getInt(melodyRangeLowKey) ??
          fallbackSettings.melodyRangeLow,
      melodyRangeHigh:
          preferences.getInt(melodyRangeHighKey) ??
          fallbackSettings.melodyRangeHigh,
      melodyStyle: storedMelodyStyle == null
          ? fallbackSettings.melodyStyle
          : MelodyStyleX.fromStorageKey(storedMelodyStyle),
      allowChromaticApproaches:
          preferences.getBool(allowChromaticApproachesKey) ??
          fallbackSettings.allowChromaticApproaches,
      syncopationBias:
          preferences.getDouble(syncopationBiasKey) ??
          fallbackSettings.syncopationBias,
      colorRealizationBias:
          preferences.getDouble(colorRealizationBiasKey) ??
          fallbackSettings.colorRealizationBias,
      noveltyTarget:
          preferences.getDouble(noveltyTargetKey) ??
          fallbackSettings.noveltyTarget,
      motifVariationBias:
          preferences.getDouble(motifVariationBiasKey) ??
          fallbackSettings.motifVariationBias,
      anticipationProbability:
          preferences.getDouble(anticipationProbabilityKey) ??
          fallbackSettings.anticipationProbability,
      colorToneTarget:
          preferences.getDouble(colorToneTargetKey) ??
          fallbackSettings.colorToneTarget,
      exactRepeatTarget:
          preferences.getDouble(exactRepeatTargetKey) ??
          fallbackSettings.exactRepeatTarget,
      melodyPlaybackMode: storedMelodyPlaybackMode == null
          ? fallbackSettings.melodyPlaybackMode
          : MelodyPlaybackModeX.fromStorageKey(storedMelodyPlaybackMode),
      harmonyMasterVolume:
          preferences.getDouble(harmonyMasterVolumeKey) ??
          fallbackSettings.harmonyMasterVolume,
      harmonyPreviewHoldFactor:
          preferences.getDouble(harmonyPreviewHoldFactorKey) ??
          fallbackSettings.harmonyPreviewHoldFactor,
      harmonyArpeggioStepSpeed:
          preferences.getDouble(harmonyArpeggioStepSpeedKey) ??
          fallbackSettings.harmonyArpeggioStepSpeed,
      harmonyVelocityHumanization:
          preferences.getDouble(harmonyVelocityHumanizationKey) ??
          fallbackSettings.harmonyVelocityHumanization,
      harmonyGainRandomness:
          preferences.getDouble(harmonyGainRandomnessKey) ??
          fallbackSettings.harmonyGainRandomness,
      harmonyTimingHumanization:
          preferences.getDouble(harmonyTimingHumanizationKey) ??
          fallbackSettings.harmonyTimingHumanization,
      anchorLoop: resolvedAnchorLoop,
      activeKeyCenters: storedActiveKeyCenters != null
          ? storedActiveKeyCenters
                .map(KeyCenter.fromSerialized)
                .where(
                  (center) => MusicTheory.keyOptions.contains(center.tonicName),
                )
                .toSet()
          : legacyActiveKeys != null
          ? legacyActiveKeys.map((key) => MusicTheory.keyCenterFor(key)).toSet()
          : fallbackSettings.activeKeyCenters,
      smartGeneratorMode:
          preferences.getBool(smartGeneratorModeKey) ??
          fallbackSettings.smartGeneratorMode,
      secondaryDominantEnabled:
          preferences.getBool(secondaryDominantEnabledKey) ??
          fallbackSettings.secondaryDominantEnabled,
      substituteDominantEnabled:
          preferences.getBool(substituteDominantEnabledKey) ??
          fallbackSettings.substituteDominantEnabled,
      modalInterchangeEnabled:
          preferences.getBool(modalInterchangeEnabledKey) ??
          fallbackSettings.modalInterchangeEnabled,
      modulationIntensity: ModulationIntensity.values.firstWhere(
        (value) => value.name == preferences.getString(modulationIntensityKey),
        orElse: () => fallbackSettings.modulationIntensity,
      ),
      jazzPreset: JazzPreset.values.firstWhere(
        (value) => value.name == preferences.getString(jazzPresetKey),
        orElse: () => fallbackSettings.jazzPreset,
      ),
      sourceProfile: SourceProfile.values.firstWhere(
        (value) => value.name == preferences.getString(sourceProfileKey),
        orElse: () => fallbackSettings.sourceProfile,
      ),
      smartDiagnosticsEnabled:
          preferences.getBool(smartDiagnosticsEnabledKey) ??
          fallbackSettings.smartDiagnosticsEnabled,
      chordSymbolStyle: ChordSymbolStyle.values.firstWhere(
        (style) => style.name == preferences.getString(chordSymbolStyleKey),
        orElse: () => fallbackSettings.chordSymbolStyle,
      ),
      allowV7sus4: resolvedAllowV7sus4,
      allowTensions:
          preferences.getBool(allowTensionsKey) ??
          fallbackSettings.allowTensions,
      enabledChordQualities:
          _sanitizeStoredChordQualities(
            storedEnabledChordQualities,
            allowV7sus4: resolvedAllowV7sus4,
          ) ??
          MusicTheory.defaultGeneratorChordQualities(
            allowV7sus4: resolvedAllowV7sus4,
          ),
      selectedTensionOptions:
          _sanitizeStoredTensionOptions(
            storedSelectedTensions,
            fallbackSettings: fallbackSettings,
          ) ??
          fallbackSettings.selectedTensionOptions,
      voicingSuggestionsEnabled:
          preferences.getBool(voicingSuggestionsEnabledKey) ??
          fallbackSettings.voicingSuggestionsEnabled,
      voicingDisplayMode: storedVoicingDisplayMode == null
          ? fallbackSettings.voicingDisplayMode
          : VoicingDisplayModeX.fromStorageKey(storedVoicingDisplayMode),
      voicingComplexity: VoicingComplexity.values.firstWhere(
        (value) => value.name == preferences.getString(voicingComplexityKey),
        orElse: () => fallbackSettings.voicingComplexity,
      ),
      voicingTopNotePreference: storedTopNotePreference == null
          ? fallbackSettings.voicingTopNotePreference
          : VoicingTopNotePreferenceX.fromStorageKey(storedTopNotePreference),
      allowRootlessVoicings:
          preferences.getBool(allowRootlessVoicingsKey) ??
          fallbackSettings.allowRootlessVoicings,
      maxVoicingNotes:
          preferences.getInt(maxVoicingNotesKey) ??
          fallbackSettings.maxVoicingNotes,
      lookAheadDepth:
          preferences.getInt(lookAheadDepthKey) ??
          fallbackSettings.lookAheadDepth,
      showVoicingReasons:
          preferences.getBool(showVoicingReasonsKey) ??
          fallbackSettings.showVoicingReasons,
      keyCenterLabelStyle: KeyCenterLabelStyle.values.firstWhere(
        (value) => value.name == preferences.getString(keyCenterLabelStyleKey),
        orElse: () => fallbackSettings.keyCenterLabelStyle,
      ),
      progressionExplanationDetailLevel:
          preferences.getString(progressionExplanationDetailLevelKey) == null
          ? fallbackSettings.progressionExplanationDetailLevel
          : ProgressionExplanationDetailLevelX.fromStorageKey(
              preferences.getString(progressionExplanationDetailLevelKey),
            ),
      progressionHighlightTheme:
          preferences.getString(progressionHighlightThemeKey) == null
          ? fallbackSettings.progressionHighlightTheme
          : ProgressionHighlightTheme.fromStorageString(
              preferences.getString(progressionHighlightThemeKey)!,
            ),
      bpm: preferences.getInt(bpmKey) ?? fallbackSettings.bpm,
      inversionSettings: fallbackSettings.inversionSettings.copyWith(
        enabled:
            preferences.getBool(inversionsEnabledKey) ??
            fallbackSettings.inversionSettings.enabled,
        firstInversionEnabled:
            preferences.getBool(firstInversionEnabledKey) ??
            fallbackSettings.inversionSettings.firstInversionEnabled,
        secondInversionEnabled:
            preferences.getBool(secondInversionEnabledKey) ??
            fallbackSettings.inversionSettings.secondInversionEnabled,
        thirdInversionEnabled:
            preferences.getBool(thirdInversionEnabledKey) ??
            fallbackSettings.inversionSettings.thirdInversionEnabled,
      ),
    );
  }

  Future<void> save(PracticeSettings settings) async {
    final preferences = await _preferencesLoader();
    await preferences.setString(languageKey, settings.language.storageKey);
    await preferences.setString(
      appThemeModeKey,
      settings.appThemeMode.storageKey,
    );
    await preferences.setBool(
      guidedSetupCompletedKey,
      settings.guidedSetupCompleted,
    );
    await preferences.setString(
      settingsComplexityModeKey,
      settings.settingsComplexityMode.storageKey,
    );
    await preferences.setString(
      preferredSuggestionKindKey,
      settings.preferredSuggestionKind.storageKey,
    );
    await preferences.setString(
      chordLanguageLevelKey,
      settings.chordLanguageLevel.storageKey,
    );
    await preferences.setString(
      romanPoolPresetKey,
      settings.romanPoolPreset.storageKey,
    );
    await preferences.setBool(metronomeEnabledKey, settings.metronomeEnabled);
    await preferences.setDouble(metronomeVolumeKey, settings.metronomeVolume);
    await preferences.setString(
      metronomeSoundKey,
      settings.metronomeSound.storageKey,
    );
    await preferences.setString(
      metronomeSourceKey,
      settings.metronomeSource.toStorageString(),
    );
    await preferences.setString(
      metronomePatternKey,
      settings.metronomePattern.toStorageString(),
    );
    await preferences.setBool(
      metronomeUseAccentSoundKey,
      settings.metronomeUseAccentSound,
    );
    await preferences.setString(
      metronomeAccentSourceKey,
      settings.metronomeAccentSource.toStorageString(),
    );
    await preferences.setString(
      timeSignatureKey,
      settings.timeSignature.storageKey,
    );
    await preferences.setString(
      harmonicRhythmPresetKey,
      settings.harmonicRhythmPreset.storageKey,
    );
    await preferences.setBool(
      autoPlayChordChangesKey,
      settings.autoPlayChordChanges,
    );
    await preferences.setString(
      autoPlayPatternKey,
      settings.autoPlayPattern.storageKey,
    );
    await preferences.setDouble(
      autoPlayHoldFactorKey,
      settings.autoPlayHoldFactor,
    );
    await preferences.setBool(
      autoPlayMelodyWithChordsKey,
      settings.autoPlayMelodyWithChords,
    );
    await preferences.setBool(
      melodyGenerationEnabledKey,
      settings.melodyGenerationEnabled,
    );
    await preferences.setString(
      melodyDensityKey,
      settings.melodyDensity.storageKey,
    );
    await preferences.setDouble(
      motifRepetitionStrengthKey,
      settings.motifRepetitionStrength,
    );
    await preferences.setDouble(
      approachToneDensityKey,
      settings.approachToneDensity,
    );
    await preferences.setInt(melodyRangeLowKey, settings.melodyRangeLow);
    await preferences.setInt(melodyRangeHighKey, settings.melodyRangeHigh);
    await preferences.setString(
      melodyStyleKey,
      settings.melodyStyle.storageKey,
    );
    await preferences.setBool(
      allowChromaticApproachesKey,
      settings.allowChromaticApproaches,
    );
    await preferences.setDouble(syncopationBiasKey, settings.syncopationBias);
    await preferences.setDouble(
      colorRealizationBiasKey,
      settings.colorRealizationBias,
    );
    await preferences.setDouble(noveltyTargetKey, settings.noveltyTarget);
    await preferences.setDouble(
      motifVariationBiasKey,
      settings.motifVariationBias,
    );
    await preferences.setDouble(
      anticipationProbabilityKey,
      settings.anticipationProbability,
    );
    await preferences.setDouble(colorToneTargetKey, settings.colorToneTarget);
    await preferences.setDouble(
      exactRepeatTargetKey,
      settings.exactRepeatTarget,
    );
    await preferences.setString(
      melodyPlaybackModeKey,
      settings.melodyPlaybackMode.storageKey,
    );
    await preferences.setDouble(
      harmonyMasterVolumeKey,
      settings.harmonyMasterVolume,
    );
    await preferences.setDouble(
      harmonyPreviewHoldFactorKey,
      settings.harmonyPreviewHoldFactor,
    );
    await preferences.setDouble(
      harmonyArpeggioStepSpeedKey,
      settings.harmonyArpeggioStepSpeed,
    );
    await preferences.setDouble(
      harmonyVelocityHumanizationKey,
      settings.harmonyVelocityHumanization,
    );
    await preferences.setDouble(
      harmonyGainRandomnessKey,
      settings.harmonyGainRandomness,
    );
    await preferences.setDouble(
      harmonyTimingHumanizationKey,
      settings.harmonyTimingHumanization,
    );
    await preferences.setString(
      chordAnchorLoopKey,
      AnchorLoopLayout.sanitizeLoop(
        loop: settings.anchorLoop,
        timeSignature: settings.timeSignature,
        harmonicRhythmPreset: settings.harmonicRhythmPreset,
      ).toStorageString(),
    );
    await preferences.setStringList(activeKeysKey, _sortedActiveKeys(settings));
    await preferences.setStringList(
      activeKeyCentersKey,
      _sortedActiveKeyCenters(settings.activeKeyCenters),
    );
    await preferences.setBool(
      smartGeneratorModeKey,
      settings.smartGeneratorMode,
    );
    await preferences.setBool(
      secondaryDominantEnabledKey,
      settings.secondaryDominantEnabled,
    );
    await preferences.setBool(
      substituteDominantEnabledKey,
      settings.substituteDominantEnabled,
    );
    await preferences.setBool(
      modalInterchangeEnabledKey,
      settings.modalInterchangeEnabled,
    );
    await preferences.setString(
      modulationIntensityKey,
      settings.modulationIntensity.name,
    );
    await preferences.setString(jazzPresetKey, settings.jazzPreset.name);
    await preferences.setString(sourceProfileKey, settings.sourceProfile.name);
    await preferences.setBool(
      smartDiagnosticsEnabledKey,
      settings.smartDiagnosticsEnabled,
    );
    await preferences.setString(
      chordSymbolStyleKey,
      settings.chordSymbolStyle.name,
    );
    await preferences.setBool(allowV7sus4Key, settings.allowV7sus4);
    await preferences.setBool(allowTensionsKey, settings.allowTensions);
    await preferences.setStringList(
      enabledChordQualitiesKey,
      _sortedChordQualities(settings.enabledChordQualities),
    );
    await preferences.setStringList(
      selectedTensionsKey,
      _sortedTensionOptions(settings.selectedTensionOptions),
    );
    await preferences.setBool(
      voicingSuggestionsEnabledKey,
      settings.voicingSuggestionsEnabled,
    );
    await preferences.setString(
      voicingDisplayModeKey,
      settings.voicingDisplayMode.storageKey,
    );
    await preferences.setString(
      voicingComplexityKey,
      settings.voicingComplexity.name,
    );
    await preferences.setString(
      voicingTopNotePreferenceKey,
      settings.voicingTopNotePreference.storageKey,
    );
    await preferences.setBool(
      allowRootlessVoicingsKey,
      settings.allowRootlessVoicings,
    );
    await preferences.setInt(maxVoicingNotesKey, settings.maxVoicingNotes);
    await preferences.setInt(lookAheadDepthKey, settings.lookAheadDepth);
    await preferences.setBool(
      showVoicingReasonsKey,
      settings.showVoicingReasons,
    );
    await preferences.setString(
      keyCenterLabelStyleKey,
      settings.keyCenterLabelStyle.name,
    );
    await preferences.setString(
      progressionExplanationDetailLevelKey,
      settings.progressionExplanationDetailLevel.storageKey,
    );
    await preferences.setString(
      progressionHighlightThemeKey,
      settings.progressionHighlightTheme.toStorageString(),
    );
    await preferences.setInt(bpmKey, settings.bpm);
    await preferences.setBool(
      inversionsEnabledKey,
      settings.inversionSettings.enabled,
    );
    await preferences.setBool(
      firstInversionEnabledKey,
      settings.inversionSettings.firstInversionEnabled,
    );
    await preferences.setBool(
      secondInversionEnabledKey,
      settings.inversionSettings.secondInversionEnabled,
    );
    await preferences.setBool(
      thirdInversionEnabledKey,
      settings.inversionSettings.thirdInversionEnabled,
    );
  }

  Set<String>? _sanitizeStoredTensionOptions(
    List<String>? storedOptions, {
    required PracticeSettings fallbackSettings,
  }) {
    if (storedOptions == null) {
      return null;
    }
    final ordered = _sortedTensionOptions(storedOptions.toSet());
    if (ordered.isNotEmpty || storedOptions.isEmpty) {
      return ordered.toSet();
    }
    return fallbackSettings.selectedTensionOptions;
  }

  Set<ChordQuality>? _sanitizeStoredChordQualities(
    List<String>? storedOptions, {
    required bool allowV7sus4,
  }) {
    if (storedOptions == null) {
      return null;
    }
    final mapped = storedOptions
        .map(
          (value) =>
              ChordQuality.values.where((quality) => quality.name == value),
        )
        .where((matches) => matches.isNotEmpty)
        .map((matches) => matches.first)
        .toSet();
    final ordered = _sortedChordQualities(mapped);
    if (ordered.isNotEmpty) {
      return ordered
          .map(
            (value) => ChordQuality.values.firstWhere(
              (quality) => quality.name == value,
            ),
          )
          .toSet();
    }
    return MusicTheory.defaultGeneratorChordQualities(allowV7sus4: allowV7sus4);
  }

  List<String> _sortedActiveKeys(PracticeSettings settings) {
    final ordered = settings.activeKeys.toList(growable: false);
    ordered.sort((left, right) => _keyOrder(left).compareTo(_keyOrder(right)));
    return ordered;
  }

  List<String> _sortedActiveKeyCenters(Set<KeyCenter> activeKeyCenters) {
    final ordered = activeKeyCenters.toList(growable: false);
    ordered.sort((left, right) {
      final modeCompare = left.mode.index.compareTo(right.mode.index);
      if (modeCompare != 0) {
        return modeCompare;
      }
      return _keyOrder(left.tonicName).compareTo(_keyOrder(right.tonicName));
    });
    return [for (final center in ordered) center.serialize()];
  }

  List<String> _sortedTensionOptions(Set<String> selectedTensions) {
    return [
      for (final tension in ChordRenderingHelper.supportedTensionOptions)
        if (selectedTensions.contains(tension)) tension,
    ];
  }

  List<String> _sortedChordQualities(Set<ChordQuality> selectedQualities) {
    return [
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (selectedQualities.contains(quality)) quality.name,
    ];
  }

  bool _hasStoredLegacyPracticeSettings(SharedPreferences preferences) {
    for (final key in _legacyStoredSettingsKeys) {
      if (preferences.containsKey(key)) {
        return true;
      }
    }
    return false;
  }

  int _keyOrder(String key) {
    final index = MusicTheory.keyOptions.indexOf(key);
    return index == -1 ? MusicTheory.keyOptions.length : index;
  }
}
