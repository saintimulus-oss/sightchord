import 'package:shared_preferences/shared_preferences.dart';

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
  static const String voicingComplexityKey = 'voicingComplexity';
  static const String voicingTopNotePreferenceKey = 'voicingTopNotePreference';
  static const String allowRootlessVoicingsKey = 'allowRootlessVoicings';
  static const String maxVoicingNotesKey = 'maxVoicingNotes';
  static const String lookAheadDepthKey = 'lookAheadDepth';
  static const String showVoicingReasonsKey = 'showVoicingReasons';
  static const String bpmKey = 'bpm';
  static const String keyCenterLabelStyleKey = 'keyCenterLabelStyle';
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
    voicingComplexityKey,
    voicingTopNotePreferenceKey,
    allowRootlessVoicingsKey,
    maxVoicingNotesKey,
    lookAheadDepthKey,
    showVoicingReasonsKey,
    bpmKey,
    keyCenterLabelStyleKey,
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
      metronomeSound: storedMetronomeSound == null
          ? fallbackSettings.metronomeSound
          : MetronomeSoundX.fromStorageKey(storedMetronomeSound),
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
