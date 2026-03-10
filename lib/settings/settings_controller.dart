import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import 'inversion_settings.dart';
import 'practice_settings.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({PracticeSettings? initialSettings})
    : _settings = initialSettings ?? PracticeSettings();

  static const String _languageKey = 'language';
  static const String _metronomeEnabledKey = 'metronomeEnabled';
  static const String _metronomeVolumeKey = 'metronomeVolume';
  static const String _metronomeSoundKey = 'metronomeSound';
  static const String _activeKeysKey = 'activeKeys';
  static const String _activeKeyCentersKey = 'activeKeyCenters';
  static const String _smartGeneratorModeKey = 'smartGeneratorMode';
  static const String _secondaryDominantEnabledKey = 'secondaryDominantEnabled';
  static const String _substituteDominantEnabledKey =
      'substituteDominantEnabled';
  static const String _modalInterchangeEnabledKey = 'modalInterchangeEnabled';
  static const String _modulationIntensityKey = 'modulationIntensity';
  static const String _jazzPresetKey = 'jazzPreset';
  static const String _sourceProfileKey = 'sourceProfile';
  static const String _smartDiagnosticsEnabledKey = 'smartDiagnosticsEnabled';
  static const String _chordSymbolStyleKey = 'chordSymbolStyle';
  static const String _allowV7sus4Key = 'allowV7sus4';
  static const String _allowTensionsKey = 'allowTensions';
  static const String _selectedTensionsKey = 'selectedTensions';
  static const String _voicingSuggestionsEnabledKey =
      'voicingSuggestionsEnabled';
  static const String _voicingComplexityKey = 'voicingComplexity';
  static const String _voicingTopNotePreferenceKey = 'voicingTopNotePreference';
  static const String _allowRootlessVoicingsKey = 'allowRootlessVoicings';
  static const String _maxVoicingNotesKey = 'maxVoicingNotes';
  static const String _lookAheadDepthKey = 'lookAheadDepth';
  static const String _showVoicingReasonsKey = 'showVoicingReasons';
  static const String _bpmKey = 'bpm';
  static const String _keyCenterLabelStyleKey = 'keyCenterLabelStyle';
  static const String _inversionsEnabledKey = 'inversionsEnabled';
  static const String _firstInversionEnabledKey = 'firstInversionEnabled';
  static const String _secondInversionEnabledKey = 'secondInversionEnabled';
  static const String _thirdInversionEnabledKey = 'thirdInversionEnabled';

  PracticeSettings _settings;
  Future<void> _saveQueue = Future<void>.value();
  PracticeSettings? _pendingSaveSnapshot;

  PracticeSettings get settings => _settings;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final storedActiveKeyCenters = preferences.getStringList(
      _activeKeyCentersKey,
    );
    final legacyActiveKeys = preferences
        .getStringList(_activeKeysKey)
        ?.where(MusicTheory.keyOptions.contains)
        .toSet();
    _settings = PracticeSettings(
      language: AppLanguageX.fromStorageKey(
        preferences.getString(_languageKey),
      ),
      metronomeEnabled:
          preferences.getBool(_metronomeEnabledKey) ??
          _settings.metronomeEnabled,
      metronomeVolume:
          preferences.getDouble(_metronomeVolumeKey) ??
          _settings.metronomeVolume,
      metronomeSound: MetronomeSoundX.fromStorageKey(
        preferences.getString(_metronomeSoundKey),
      ),
      activeKeyCenters: storedActiveKeyCenters != null
          ? storedActiveKeyCenters
                .map(KeyCenter.fromSerialized)
                .where(
                  (center) => MusicTheory.keyOptions.contains(center.tonicName),
                )
                .toSet()
          : legacyActiveKeys
                ?.map((key) => MusicTheory.keyCenterFor(key))
                .toSet(),
      smartGeneratorMode:
          preferences.getBool(_smartGeneratorModeKey) ??
          _settings.smartGeneratorMode,
      secondaryDominantEnabled:
          preferences.getBool(_secondaryDominantEnabledKey) ??
          _settings.secondaryDominantEnabled,
      substituteDominantEnabled:
          preferences.getBool(_substituteDominantEnabledKey) ??
          _settings.substituteDominantEnabled,
      modalInterchangeEnabled:
          preferences.getBool(_modalInterchangeEnabledKey) ??
          _settings.modalInterchangeEnabled,
      modulationIntensity: ModulationIntensity.values.firstWhere(
        (value) => value.name == preferences.getString(_modulationIntensityKey),
        orElse: () => _settings.modulationIntensity,
      ),
      jazzPreset: JazzPreset.values.firstWhere(
        (value) => value.name == preferences.getString(_jazzPresetKey),
        orElse: () => _settings.jazzPreset,
      ),
      sourceProfile: SourceProfile.values.firstWhere(
        (value) => value.name == preferences.getString(_sourceProfileKey),
        orElse: () => _settings.sourceProfile,
      ),
      smartDiagnosticsEnabled:
          preferences.getBool(_smartDiagnosticsEnabledKey) ??
          _settings.smartDiagnosticsEnabled,
      chordSymbolStyle: ChordSymbolStyle.values.firstWhere(
        (style) => style.name == preferences.getString(_chordSymbolStyleKey),
        orElse: () => _settings.chordSymbolStyle,
      ),
      allowV7sus4:
          preferences.getBool(_allowV7sus4Key) ?? _settings.allowV7sus4,
      allowTensions:
          preferences.getBool(_allowTensionsKey) ?? _settings.allowTensions,
      selectedTensionOptions: _sanitizeStoredTensionOptions(
        preferences.getStringList(_selectedTensionsKey),
      ),
      voicingSuggestionsEnabled:
          preferences.getBool(_voicingSuggestionsEnabledKey) ??
          _settings.voicingSuggestionsEnabled,
      voicingComplexity: VoicingComplexity.values.firstWhere(
        (value) => value.name == preferences.getString(_voicingComplexityKey),
        orElse: () => _settings.voicingComplexity,
      ),
      voicingTopNotePreference: VoicingTopNotePreferenceX.fromStorageKey(
        preferences.getString(_voicingTopNotePreferenceKey),
      ),
      allowRootlessVoicings:
          preferences.getBool(_allowRootlessVoicingsKey) ??
          _settings.allowRootlessVoicings,
      maxVoicingNotes:
          preferences.getInt(_maxVoicingNotesKey) ?? _settings.maxVoicingNotes,
      lookAheadDepth:
          preferences.getInt(_lookAheadDepthKey) ?? _settings.lookAheadDepth,
      showVoicingReasons:
          preferences.getBool(_showVoicingReasonsKey) ??
          _settings.showVoicingReasons,
      keyCenterLabelStyle: KeyCenterLabelStyle.values.firstWhere(
        (value) => value.name == preferences.getString(_keyCenterLabelStyleKey),
        orElse: () => _settings.keyCenterLabelStyle,
      ),
      inversionSettings: InversionSettings(
        enabled:
            preferences.getBool(_inversionsEnabledKey) ??
            _settings.inversionSettings.enabled,
        firstInversionEnabled:
            preferences.getBool(_firstInversionEnabledKey) ??
            _settings.inversionSettings.firstInversionEnabled,
        secondInversionEnabled:
            preferences.getBool(_secondInversionEnabledKey) ??
            _settings.inversionSettings.secondInversionEnabled,
        thirdInversionEnabled:
            preferences.getBool(_thirdInversionEnabledKey) ??
            _settings.inversionSettings.thirdInversionEnabled,
      ),
      bpm: preferences.getInt(_bpmKey) ?? _settings.bpm,
    );
    notifyListeners();
  }

  Future<void> update(PracticeSettings nextSettings) async {
    _settings = nextSettings;
    notifyListeners();
    _pendingSaveSnapshot = nextSettings;
    _saveQueue = _saveQueue.catchError((_) {}).then((_) async {
      final snapshot = _pendingSaveSnapshot;
      if (snapshot == null) {
        return;
      }
      _pendingSaveSnapshot = null;
      await _save(snapshot);
    });
    await _saveQueue;
  }

  Future<void> mutate(
    PracticeSettings Function(PracticeSettings current) updater,
  ) async {
    await update(updater(_settings));
  }

  Future<void> _save(PracticeSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, settings.language.storageKey);
    await preferences.setBool(_metronomeEnabledKey, settings.metronomeEnabled);
    await preferences.setDouble(_metronomeVolumeKey, settings.metronomeVolume);
    await preferences.setString(
      _metronomeSoundKey,
      settings.metronomeSound.storageKey,
    );
    await preferences.setStringList(
      _activeKeysKey,
      _sortedActiveKeys(settings.activeKeys),
    );
    await preferences.setStringList(
      _activeKeyCentersKey,
      _sortedActiveKeyCenters(settings.activeKeyCenters),
    );
    await preferences.setBool(
      _smartGeneratorModeKey,
      settings.smartGeneratorMode,
    );
    await preferences.setBool(
      _secondaryDominantEnabledKey,
      settings.secondaryDominantEnabled,
    );
    await preferences.setBool(
      _substituteDominantEnabledKey,
      settings.substituteDominantEnabled,
    );
    await preferences.setBool(
      _modalInterchangeEnabledKey,
      settings.modalInterchangeEnabled,
    );
    await preferences.setString(
      _modulationIntensityKey,
      settings.modulationIntensity.name,
    );
    await preferences.setString(_jazzPresetKey, settings.jazzPreset.name);
    await preferences.setString(_sourceProfileKey, settings.sourceProfile.name);
    await preferences.setBool(
      _smartDiagnosticsEnabledKey,
      settings.smartDiagnosticsEnabled,
    );
    await preferences.setString(
      _chordSymbolStyleKey,
      settings.chordSymbolStyle.name,
    );
    await preferences.setBool(_allowV7sus4Key, settings.allowV7sus4);
    await preferences.setBool(_allowTensionsKey, settings.allowTensions);
    await preferences.setStringList(
      _selectedTensionsKey,
      _sortedTensionOptions(settings.selectedTensionOptions),
    );
    await preferences.setBool(
      _voicingSuggestionsEnabledKey,
      settings.voicingSuggestionsEnabled,
    );
    await preferences.setString(
      _voicingComplexityKey,
      settings.voicingComplexity.name,
    );
    await preferences.setString(
      _voicingTopNotePreferenceKey,
      settings.voicingTopNotePreference.storageKey,
    );
    await preferences.setBool(
      _allowRootlessVoicingsKey,
      settings.allowRootlessVoicings,
    );
    await preferences.setInt(_maxVoicingNotesKey, settings.maxVoicingNotes);
    await preferences.setInt(_lookAheadDepthKey, settings.lookAheadDepth);
    await preferences.setBool(
      _showVoicingReasonsKey,
      settings.showVoicingReasons,
    );
    await preferences.setString(
      _keyCenterLabelStyleKey,
      settings.keyCenterLabelStyle.name,
    );
    await preferences.setInt(_bpmKey, settings.bpm);
    await preferences.setBool(
      _inversionsEnabledKey,
      settings.inversionSettings.enabled,
    );
    await preferences.setBool(
      _firstInversionEnabledKey,
      settings.inversionSettings.firstInversionEnabled,
    );
    await preferences.setBool(
      _secondInversionEnabledKey,
      settings.inversionSettings.secondInversionEnabled,
    );
    await preferences.setBool(
      _thirdInversionEnabledKey,
      settings.inversionSettings.thirdInversionEnabled,
    );
  }

  Set<String>? _sanitizeStoredTensionOptions(List<String>? storedOptions) {
    if (storedOptions == null) {
      return null;
    }
    final ordered = _sortedTensionOptions(storedOptions.toSet());
    if (ordered.isNotEmpty || storedOptions.isEmpty) {
      return ordered.toSet();
    }
    return _settings.selectedTensionOptions;
  }

  List<String> _sortedActiveKeys(Set<String> activeKeys) {
    final ordered = activeKeys.toList(growable: false);
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
    return [
      for (final center in ordered) center.serialize(),
    ];
  }

  List<String> _sortedTensionOptions(Set<String> selectedTensions) {
    return [
      for (final tension in ChordRenderingHelper.supportedTensionOptions)
        if (selectedTensions.contains(tension)) tension,
    ];
  }

  int _keyOrder(String key) {
    final index = MusicTheory.keyOptions.indexOf(key);
    return index == -1 ? MusicTheory.keyOptions.length : index;
  }
}
