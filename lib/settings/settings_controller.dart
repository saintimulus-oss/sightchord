import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../music/chord_theory.dart';
import 'practice_settings.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({PracticeSettings? initialSettings})
    : _settings = initialSettings ?? PracticeSettings();

  static const String _languageKey = 'language';
  static const String _metronomeEnabledKey = 'metronomeEnabled';
  static const String _metronomeVolumeKey = 'metronomeVolume';
  static const String _activeKeysKey = 'activeKeys';
  static const String _smartGeneratorModeKey = 'smartGeneratorMode';
  static const String _secondaryDominantEnabledKey =
      'secondaryDominantEnabled';
  static const String _substituteDominantEnabledKey =
      'substituteDominantEnabled';
  static const String _modalInterchangeEnabledKey = 'modalInterchangeEnabled';
  static const String _chordSymbolStyleKey = 'chordSymbolStyle';
  static const String _allowV7sus4Key = 'allowV7sus4';
  static const String _allowTensionsKey = 'allowTensions';
  static const String _selectedTensionsKey = 'selectedTensions';
  static const String _bpmKey = 'bpm';
  static const String _inversionsEnabledKey = 'inversionsEnabled';
  static const String _firstInversionEnabledKey = 'firstInversionEnabled';
  static const String _secondInversionEnabledKey = 'secondInversionEnabled';
  static const String _thirdInversionEnabledKey = 'thirdInversionEnabled';

  PracticeSettings _settings;

  PracticeSettings get settings => _settings;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
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
      activeKeys: preferences.getStringList(_activeKeysKey)?.toSet(),
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
      chordSymbolStyle: ChordSymbolStyle.values.firstWhere(
        (style) => style.name == preferences.getString(_chordSymbolStyleKey),
        orElse: () => _settings.chordSymbolStyle,
      ),
      allowV7sus4:
          preferences.getBool(_allowV7sus4Key) ?? _settings.allowV7sus4,
      allowTensions:
          preferences.getBool(_allowTensionsKey) ?? _settings.allowTensions,
      selectedTensionOptions:
          preferences.getStringList(_selectedTensionsKey)?.toSet(),
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
    await _save();
  }

  Future<void> mutate(
    PracticeSettings Function(PracticeSettings current) updater,
  ) async {
    await update(updater(_settings));
  }

  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, _settings.language.storageKey);
    await preferences.setBool(
      _metronomeEnabledKey,
      _settings.metronomeEnabled,
    );
    await preferences.setDouble(_metronomeVolumeKey, _settings.metronomeVolume);
    await preferences.setStringList(_activeKeysKey, _settings.activeKeys.toList());
    await preferences.setBool(
      _smartGeneratorModeKey,
      _settings.smartGeneratorMode,
    );
    await preferences.setBool(
      _secondaryDominantEnabledKey,
      _settings.secondaryDominantEnabled,
    );
    await preferences.setBool(
      _substituteDominantEnabledKey,
      _settings.substituteDominantEnabled,
    );
    await preferences.setBool(
      _modalInterchangeEnabledKey,
      _settings.modalInterchangeEnabled,
    );
    await preferences.setString(
      _chordSymbolStyleKey,
      _settings.chordSymbolStyle.name,
    );
    await preferences.setBool(_allowV7sus4Key, _settings.allowV7sus4);
    await preferences.setBool(_allowTensionsKey, _settings.allowTensions);
    await preferences.setStringList(
      _selectedTensionsKey,
      _settings.selectedTensionOptions.toList(),
    );
    await preferences.setInt(_bpmKey, _settings.bpm);
    await preferences.setBool(
      _inversionsEnabledKey,
      _settings.inversionSettings.enabled,
    );
    await preferences.setBool(
      _firstInversionEnabledKey,
      _settings.inversionSettings.firstInversionEnabled,
    );
    await preferences.setBool(
      _secondInversionEnabledKey,
      _settings.inversionSettings.secondInversionEnabled,
    );
    await preferences.setBool(
      _thirdInversionEnabledKey,
      _settings.inversionSettings.thirdInversionEnabled,
    );
  }
}
