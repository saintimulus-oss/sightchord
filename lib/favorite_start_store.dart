import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'music/chord_theory.dart';
import 'settings/inversion_settings.dart';
import 'settings/practice_settings.dart';

typedef FavoriteStartPreferencesLoader = Future<SharedPreferences> Function();

class FavoriteStartPreset {
  const FavoriteStartPreset({
    this.customLabel,
    required this.settingsComplexityMode,
    required this.chordLanguageLevel,
    required this.romanPoolPreset,
    required this.activeKeyCenters,
    required this.melodyGenerationEnabled,
    required this.melodyDensity,
    required this.melodyStyle,
    required this.melodyPlaybackMode,
    required this.autoPlayMelodyWithChords,
    required this.autoPlayChordChanges,
    required this.chordSymbolStyle,
    required this.allowV7sus4,
    required this.allowTensions,
    required this.enabledChordQualities,
    required this.selectedTensionOptions,
    required this.smartGeneratorMode,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationIntensity,
    required this.jazzPreset,
    required this.sourceProfile,
    required this.voicingSuggestionsEnabled,
    required this.voicingDisplayMode,
    required this.voicingComplexity,
    required this.allowRootlessVoicings,
    required this.maxVoicingNotes,
    required this.lookAheadDepth,
    required this.bpm,
    required this.inversionSettings,
  });

  factory FavoriteStartPreset.fromSettings(
    PracticeSettings settings, {
    String? customLabel,
  }) {
    return FavoriteStartPreset(
      customLabel: _normalizedLabel(customLabel),
      settingsComplexityMode: settings.settingsComplexityMode,
      chordLanguageLevel: settings.chordLanguageLevel,
      romanPoolPreset: settings.romanPoolPreset,
      activeKeyCenters: Set<KeyCenter>.from(settings.activeKeyCenters),
      melodyGenerationEnabled: settings.melodyGenerationEnabled,
      melodyDensity: settings.melodyDensity,
      melodyStyle: settings.melodyStyle,
      melodyPlaybackMode: settings.melodyPlaybackMode,
      autoPlayMelodyWithChords: settings.autoPlayMelodyWithChords,
      autoPlayChordChanges: settings.autoPlayChordChanges,
      chordSymbolStyle: settings.chordSymbolStyle,
      allowV7sus4: settings.allowV7sus4,
      allowTensions: settings.allowTensions,
      enabledChordQualities: Set<ChordQuality>.from(
        settings.enabledChordQualities,
      ),
      selectedTensionOptions: Set<String>.from(settings.selectedTensionOptions),
      smartGeneratorMode: settings.smartGeneratorMode,
      secondaryDominantEnabled: settings.secondaryDominantEnabled,
      substituteDominantEnabled: settings.substituteDominantEnabled,
      modalInterchangeEnabled: settings.modalInterchangeEnabled,
      modulationIntensity: settings.modulationIntensity,
      jazzPreset: settings.jazzPreset,
      sourceProfile: settings.sourceProfile,
      voicingSuggestionsEnabled: settings.voicingSuggestionsEnabled,
      voicingDisplayMode: settings.voicingDisplayMode,
      voicingComplexity: settings.voicingComplexity,
      allowRootlessVoicings: settings.allowRootlessVoicings,
      maxVoicingNotes: settings.maxVoicingNotes,
      lookAheadDepth: settings.lookAheadDepth,
      bpm: settings.bpm,
      inversionSettings: settings.inversionSettings,
    );
  }

  factory FavoriteStartPreset.fromJson(Map<String, Object?> json) {
    final activeKeyValues =
        (json['activeKeyCenters'] as List<Object?>? ?? const <Object?>[])
            .whereType<String>()
            .toSet();
    final chordQualityValues =
        (json['enabledChordQualities'] as List<Object?>? ?? const <Object?>[])
            .whereType<String>()
            .toSet();
    final tensionValues =
        (json['selectedTensionOptions'] as List<Object?>? ?? const <Object?>[])
            .whereType<String>()
            .toSet();
    final inversionJson = Map<String, Object?>.from(
      json['inversionSettings'] as Map? ?? const <String, Object?>{},
    );

    return FavoriteStartPreset(
      customLabel: _normalizedLabel(json['customLabel'] as String?),
      settingsComplexityMode: SettingsComplexityMode.values.firstWhere(
        (value) => value.name == json['settingsComplexityMode'],
        orElse: () => SettingsComplexityMode.standard,
      ),
      chordLanguageLevel: ChordLanguageLevel.values.firstWhere(
        (value) => value.name == json['chordLanguageLevel'],
        orElse: () => ChordLanguageLevel.safeExtensions,
      ),
      romanPoolPreset: RomanPoolPreset.values.firstWhere(
        (value) => value.name == json['romanPoolPreset'],
        orElse: () => RomanPoolPreset.functionalJazz,
      ),
      activeKeyCenters: activeKeyValues
          .map(KeyCenter.fromSerialized)
          .where((center) => MusicTheory.keyOptions.contains(center.tonicName))
          .toSet(),
      melodyGenerationEnabled:
          json['melodyGenerationEnabled'] as bool? ?? false,
      melodyDensity: MelodyDensity.values.firstWhere(
        (value) => value.name == json['melodyDensity'],
        orElse: () => MelodyDensity.balanced,
      ),
      melodyStyle: MelodyStyle.values.firstWhere(
        (value) => value.name == json['melodyStyle'],
        orElse: () => MelodyStyle.safe,
      ),
      melodyPlaybackMode: MelodyPlaybackMode.values.firstWhere(
        (value) => value.name == json['melodyPlaybackMode'],
        orElse: () => MelodyPlaybackMode.chordsOnly,
      ),
      autoPlayMelodyWithChords:
          json['autoPlayMelodyWithChords'] as bool? ?? false,
      autoPlayChordChanges: json['autoPlayChordChanges'] as bool? ?? false,
      chordSymbolStyle: ChordSymbolStyle.values.firstWhere(
        (value) => value.name == json['chordSymbolStyle'],
        orElse: () => ChordSymbolStyle.compact,
      ),
      allowV7sus4: json['allowV7sus4'] as bool? ?? false,
      allowTensions: json['allowTensions'] as bool? ?? false,
      enabledChordQualities: chordQualityValues
          .map(
            (name) => ChordQuality.values.firstWhere(
              (value) => value.name == name,
              orElse: () => ChordQuality.majorTriad,
            ),
          )
          .toSet(),
      selectedTensionOptions: tensionValues,
      smartGeneratorMode: json['smartGeneratorMode'] as bool? ?? false,
      secondaryDominantEnabled:
          json['secondaryDominantEnabled'] as bool? ?? false,
      substituteDominantEnabled:
          json['substituteDominantEnabled'] as bool? ?? false,
      modalInterchangeEnabled:
          json['modalInterchangeEnabled'] as bool? ?? false,
      modulationIntensity: ModulationIntensity.values.firstWhere(
        (value) => value.name == json['modulationIntensity'],
        orElse: () => ModulationIntensity.low,
      ),
      jazzPreset: JazzPreset.values.firstWhere(
        (value) => value.name == json['jazzPreset'],
        orElse: () => JazzPreset.standardsCore,
      ),
      sourceProfile: SourceProfile.values.firstWhere(
        (value) => value.name == json['sourceProfile'],
        orElse: () => SourceProfile.fakebookStandard,
      ),
      voicingSuggestionsEnabled:
          json['voicingSuggestionsEnabled'] as bool? ?? true,
      voicingDisplayMode: VoicingDisplayMode.values.firstWhere(
        (value) => value.name == json['voicingDisplayMode'],
        orElse: () => VoicingDisplayMode.standard,
      ),
      voicingComplexity: VoicingComplexity.values.firstWhere(
        (value) => value.name == json['voicingComplexity'],
        orElse: () => VoicingComplexity.standard,
      ),
      allowRootlessVoicings: json['allowRootlessVoicings'] as bool? ?? false,
      maxVoicingNotes: json['maxVoicingNotes'] as int? ?? 4,
      lookAheadDepth: json['lookAheadDepth'] as int? ?? 2,
      bpm: json['bpm'] as int? ?? 84,
      inversionSettings: InversionSettings(
        enabled: inversionJson['enabled'] as bool? ?? false,
        firstInversionEnabled:
            inversionJson['firstInversionEnabled'] as bool? ?? true,
        secondInversionEnabled:
            inversionJson['secondInversionEnabled'] as bool? ?? true,
        thirdInversionEnabled:
            inversionJson['thirdInversionEnabled'] as bool? ?? false,
      ),
    );
  }

  final String? customLabel;
  final SettingsComplexityMode settingsComplexityMode;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final Set<KeyCenter> activeKeyCenters;
  final bool melodyGenerationEnabled;
  final MelodyDensity melodyDensity;
  final MelodyStyle melodyStyle;
  final MelodyPlaybackMode melodyPlaybackMode;
  final bool autoPlayMelodyWithChords;
  final bool autoPlayChordChanges;
  final ChordSymbolStyle chordSymbolStyle;
  final bool allowV7sus4;
  final bool allowTensions;
  final Set<ChordQuality> enabledChordQualities;
  final Set<String> selectedTensionOptions;
  final bool smartGeneratorMode;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final bool voicingSuggestionsEnabled;
  final VoicingDisplayMode voicingDisplayMode;
  final VoicingComplexity voicingComplexity;
  final bool allowRootlessVoicings;
  final int maxVoicingNotes;
  final int lookAheadDepth;
  final int bpm;
  final InversionSettings inversionSettings;

  bool get hasCustomLabel => customLabel != null;

  String get displayLabel => customLabel ?? suggestedLabel;

  String get suggestedLabel {
    final orderedKeyCenters = <KeyCenter>[
      for (final mode in KeyMode.values)
        for (final center in MusicTheory.orderedKeyCentersForMode(mode))
          if (activeKeyCenters.contains(center)) center,
    ];
    final keyLabel = switch (orderedKeyCenters.length) {
      0 => 'All keys',
      1 => _compactKeyLabel(orderedKeyCenters.first),
      _ =>
        '${_compactKeyLabel(orderedKeyCenters.first)} +'
            '${orderedKeyCenters.length - 1}',
    };
    final textureLabel = melodyGenerationEnabled ? 'Melody' : 'Chords';
    return '$keyLabel $textureLabel';
  }

  FavoriteStartPreset withCustomLabel(String? value) {
    return FavoriteStartPreset(
      customLabel: _normalizedLabel(value),
      settingsComplexityMode: settingsComplexityMode,
      chordLanguageLevel: chordLanguageLevel,
      romanPoolPreset: romanPoolPreset,
      activeKeyCenters: activeKeyCenters,
      melodyGenerationEnabled: melodyGenerationEnabled,
      melodyDensity: melodyDensity,
      melodyStyle: melodyStyle,
      melodyPlaybackMode: melodyPlaybackMode,
      autoPlayMelodyWithChords: autoPlayMelodyWithChords,
      autoPlayChordChanges: autoPlayChordChanges,
      chordSymbolStyle: chordSymbolStyle,
      allowV7sus4: allowV7sus4,
      allowTensions: allowTensions,
      enabledChordQualities: enabledChordQualities,
      selectedTensionOptions: selectedTensionOptions,
      smartGeneratorMode: smartGeneratorMode,
      secondaryDominantEnabled: secondaryDominantEnabled,
      substituteDominantEnabled: substituteDominantEnabled,
      modalInterchangeEnabled: modalInterchangeEnabled,
      modulationIntensity: modulationIntensity,
      jazzPreset: jazzPreset,
      sourceProfile: sourceProfile,
      voicingSuggestionsEnabled: voicingSuggestionsEnabled,
      voicingDisplayMode: voicingDisplayMode,
      voicingComplexity: voicingComplexity,
      allowRootlessVoicings: allowRootlessVoicings,
      maxVoicingNotes: maxVoicingNotes,
      lookAheadDepth: lookAheadDepth,
      bpm: bpm,
      inversionSettings: inversionSettings,
    );
  }

  PracticeSettings applyTo(PracticeSettings baseSettings) {
    return baseSettings.copyWith(
      guidedSetupCompleted: true,
      settingsComplexityMode: settingsComplexityMode,
      chordLanguageLevel: chordLanguageLevel,
      romanPoolPreset: romanPoolPreset,
      activeKeyCenters: activeKeyCenters,
      melodyGenerationEnabled: melodyGenerationEnabled,
      melodyDensity: melodyDensity,
      melodyStyle: melodyStyle,
      melodyPlaybackMode: melodyPlaybackMode,
      autoPlayMelodyWithChords: autoPlayMelodyWithChords,
      autoPlayChordChanges: autoPlayChordChanges,
      chordSymbolStyle: chordSymbolStyle,
      allowV7sus4: allowV7sus4,
      allowTensions: allowTensions,
      enabledChordQualities: enabledChordQualities,
      selectedTensionOptions: selectedTensionOptions,
      smartGeneratorMode: smartGeneratorMode,
      secondaryDominantEnabled: secondaryDominantEnabled,
      substituteDominantEnabled: substituteDominantEnabled,
      modalInterchangeEnabled: modalInterchangeEnabled,
      modulationIntensity: modulationIntensity,
      jazzPreset: jazzPreset,
      sourceProfile: sourceProfile,
      voicingSuggestionsEnabled: voicingSuggestionsEnabled,
      voicingDisplayMode: voicingDisplayMode,
      voicingComplexity: voicingComplexity,
      allowRootlessVoicings: allowRootlessVoicings,
      maxVoicingNotes: maxVoicingNotes,
      lookAheadDepth: lookAheadDepth,
      bpm: bpm,
      inversionSettings: inversionSettings,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'customLabel': customLabel,
      'settingsComplexityMode': settingsComplexityMode.name,
      'chordLanguageLevel': chordLanguageLevel.name,
      'romanPoolPreset': romanPoolPreset.name,
      'activeKeyCenters': activeKeyCenters
          .map((center) => center.serialize())
          .toList(growable: false),
      'melodyGenerationEnabled': melodyGenerationEnabled,
      'melodyDensity': melodyDensity.name,
      'melodyStyle': melodyStyle.name,
      'melodyPlaybackMode': melodyPlaybackMode.name,
      'autoPlayMelodyWithChords': autoPlayMelodyWithChords,
      'autoPlayChordChanges': autoPlayChordChanges,
      'chordSymbolStyle': chordSymbolStyle.name,
      'allowV7sus4': allowV7sus4,
      'allowTensions': allowTensions,
      'enabledChordQualities': enabledChordQualities
          .map((quality) => quality.name)
          .toList(growable: false),
      'selectedTensionOptions': selectedTensionOptions.toList(growable: false),
      'smartGeneratorMode': smartGeneratorMode,
      'secondaryDominantEnabled': secondaryDominantEnabled,
      'substituteDominantEnabled': substituteDominantEnabled,
      'modalInterchangeEnabled': modalInterchangeEnabled,
      'modulationIntensity': modulationIntensity.name,
      'jazzPreset': jazzPreset.name,
      'sourceProfile': sourceProfile.name,
      'voicingSuggestionsEnabled': voicingSuggestionsEnabled,
      'voicingDisplayMode': voicingDisplayMode.name,
      'voicingComplexity': voicingComplexity.name,
      'allowRootlessVoicings': allowRootlessVoicings,
      'maxVoicingNotes': maxVoicingNotes,
      'lookAheadDepth': lookAheadDepth,
      'bpm': bpm,
      'inversionSettings': <String, Object?>{
        'enabled': inversionSettings.enabled,
        'firstInversionEnabled': inversionSettings.firstInversionEnabled,
        'secondInversionEnabled': inversionSettings.secondInversionEnabled,
        'thirdInversionEnabled': inversionSettings.thirdInversionEnabled,
      },
    };
  }

  String toStorageString() => jsonEncode(toJson());

  static FavoriteStartPreset? fromStorageString(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }
      return FavoriteStartPreset.fromJson(Map<String, Object?>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  static String? _normalizedLabel(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed.length <= 28 ? trimmed : trimmed.substring(0, 28);
  }

  static String _compactKeyLabel(KeyCenter center) {
    final mode = switch (center.mode) {
      KeyMode.major => 'maj',
      KeyMode.minor => 'min',
    };
    return '${center.tonicName} $mode';
  }
}

class FavoriteStartSlots {
  const FavoriteStartSlots({this.slot1, this.slot2});

  static const int slotCount = 2;

  final FavoriteStartPreset? slot1;
  final FavoriteStartPreset? slot2;

  FavoriteStartPreset? slotAt(int index) {
    return switch (index) {
      0 => slot1,
      1 => slot2,
      _ => null,
    };
  }

  FavoriteStartSlots replacingSlot(int index, FavoriteStartPreset? preset) {
    return switch (index) {
      0 => FavoriteStartSlots(slot1: preset, slot2: slot2),
      1 => FavoriteStartSlots(slot1: slot1, slot2: preset),
      _ => this,
    };
  }
}

class FavoriteStartStore {
  const FavoriteStartStore({
    FavoriteStartPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String slot1Key = 'favorite_start_slot_1';
  static const String slot2Key = 'favorite_start_slot_2';

  final FavoriteStartPreferencesLoader _preferencesLoader;

  Future<FavoriteStartSlots> load() async {
    final preferences = await _preferencesLoader();
    return FavoriteStartSlots(
      slot1: FavoriteStartPreset.fromStorageString(
        preferences.getString(slot1Key),
      ),
      slot2: FavoriteStartPreset.fromStorageString(
        preferences.getString(slot2Key),
      ),
    );
  }

  Future<FavoriteStartSlots> setSlot(
    int index,
    FavoriteStartPreset? preset,
  ) async {
    final preferences = await _preferencesLoader();
    final key = _slotKey(index);
    if (preset == null) {
      await preferences.remove(key);
    } else {
      await preferences.setString(key, preset.toStorageString());
    }
    return load();
  }

  String _slotKey(int index) {
    return switch (index) {
      0 => slot1Key,
      1 => slot2Key,
      _ => throw RangeError.index(index, const <int>[0, 1], 'index'),
    };
  }
}
