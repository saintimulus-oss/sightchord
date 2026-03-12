import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/chord_theory.dart';
import 'inversion_settings.dart';

enum AppLanguage { system, en, es, zh, zhHans, ja, ko }

enum MetronomeSound { tick, tickB, tickC, tickD, tickE, tickF }

enum VoicingComplexity { basic, standard, modern }

enum VoicingTopNotePreference { auto, c, db, d, eb, e, f, gb, g, ab, a, bb, b }

extension AppLanguageX on AppLanguage {
  Locale? get locale {
    switch (this) {
      case AppLanguage.system:
        return null;
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.es:
        return const Locale('es');
      case AppLanguage.zh:
        return const Locale('zh');
      case AppLanguage.zhHans:
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      case AppLanguage.ja:
        return const Locale('ja');
      case AppLanguage.ko:
        return const Locale('ko');
    }
  }

  String get storageKey {
    switch (this) {
      case AppLanguage.system:
        return 'system';
      case AppLanguage.en:
        return 'en';
      case AppLanguage.es:
        return 'es';
      case AppLanguage.zh:
        return 'zh';
      case AppLanguage.zhHans:
        return 'zh_Hans';
      case AppLanguage.ja:
        return 'ja';
      case AppLanguage.ko:
        return 'ko';
    }
  }

  String get nativeLabel {
    switch (this) {
      case AppLanguage.system:
        return 'System';
      case AppLanguage.en:
        return 'English';
      case AppLanguage.es:
        return 'Espa\u00f1ol';
      case AppLanguage.zh:
        return '\u7e41\u9ad4\u4e2d\u6587';
      case AppLanguage.zhHans:
        return '\u7b80\u4f53\u4e2d\u6587';
      case AppLanguage.ja:
        return '\u65e5\u672c\u8a9e';
      case AppLanguage.ko:
        return '\ud55c\uad6d\uc5b4';
    }
  }

  static AppLanguage fromStorageKey(String? value) {
    return AppLanguage.values.firstWhere(
      (language) => language.storageKey == value,
      orElse: () => AppLanguage.system,
    );
  }
}

extension MetronomeSoundX on MetronomeSound {
  String get storageKey {
    switch (this) {
      case MetronomeSound.tick:
        return 'tick';
      case MetronomeSound.tickB:
        return 'tickB';
      case MetronomeSound.tickC:
        return 'tickC';
      case MetronomeSound.tickD:
        return 'tickD';
      case MetronomeSound.tickE:
        return 'tickE';
      case MetronomeSound.tickF:
        return 'tickF';
    }
  }

  String get assetFileName {
    switch (this) {
      case MetronomeSound.tick:
        return 'tick.mp3';
      case MetronomeSound.tickB:
        return 'tickB.mp3';
      case MetronomeSound.tickC:
        return 'tickC.mp3';
      case MetronomeSound.tickD:
        return 'tickD.mp3';
      case MetronomeSound.tickE:
        return 'tickE.mp3';
      case MetronomeSound.tickF:
        return 'tickF.mp3';
    }
  }

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case MetronomeSound.tick:
        return l10n.metronomeSoundClassic;
      case MetronomeSound.tickB:
        return l10n.metronomeSoundClickB;
      case MetronomeSound.tickC:
        return l10n.metronomeSoundClickC;
      case MetronomeSound.tickD:
        return l10n.metronomeSoundClickD;
      case MetronomeSound.tickE:
        return l10n.metronomeSoundClickE;
      case MetronomeSound.tickF:
        return l10n.metronomeSoundClickF;
    }
  }

  static MetronomeSound fromStorageKey(String? value) {
    return MetronomeSound.values.firstWhere(
      (sound) => sound.storageKey == value,
      orElse: () => MetronomeSound.tick,
    );
  }
}

extension VoicingTopNotePreferenceX on VoicingTopNotePreference {
  String get storageKey {
    return switch (this) {
      VoicingTopNotePreference.auto => 'auto',
      VoicingTopNotePreference.c => 'c',
      VoicingTopNotePreference.db => 'db',
      VoicingTopNotePreference.d => 'd',
      VoicingTopNotePreference.eb => 'eb',
      VoicingTopNotePreference.e => 'e',
      VoicingTopNotePreference.f => 'f',
      VoicingTopNotePreference.gb => 'gb',
      VoicingTopNotePreference.g => 'g',
      VoicingTopNotePreference.ab => 'ab',
      VoicingTopNotePreference.a => 'a',
      VoicingTopNotePreference.bb => 'bb',
      VoicingTopNotePreference.b => 'b',
    };
  }

  int? get pitchClass {
    return switch (this) {
      VoicingTopNotePreference.auto => null,
      VoicingTopNotePreference.c => 0,
      VoicingTopNotePreference.db => 1,
      VoicingTopNotePreference.d => 2,
      VoicingTopNotePreference.eb => 3,
      VoicingTopNotePreference.e => 4,
      VoicingTopNotePreference.f => 5,
      VoicingTopNotePreference.gb => 6,
      VoicingTopNotePreference.g => 7,
      VoicingTopNotePreference.ab => 8,
      VoicingTopNotePreference.a => 9,
      VoicingTopNotePreference.bb => 10,
      VoicingTopNotePreference.b => 11,
    };
  }

  String get noteLabel {
    return switch (this) {
      VoicingTopNotePreference.auto => 'Auto',
      VoicingTopNotePreference.c => 'C',
      VoicingTopNotePreference.db => 'Db',
      VoicingTopNotePreference.d => 'D',
      VoicingTopNotePreference.eb => 'Eb',
      VoicingTopNotePreference.e => 'E',
      VoicingTopNotePreference.f => 'F',
      VoicingTopNotePreference.gb => 'Gb',
      VoicingTopNotePreference.g => 'G',
      VoicingTopNotePreference.ab => 'Ab',
      VoicingTopNotePreference.a => 'A',
      VoicingTopNotePreference.bb => 'Bb',
      VoicingTopNotePreference.b => 'B',
    };
  }

  static VoicingTopNotePreference fromStorageKey(String? value) {
    return VoicingTopNotePreference.values.firstWhere(
      (preference) => preference.storageKey == value,
      orElse: () => VoicingTopNotePreference.auto,
    );
  }
}

class PracticeSettings {
  static const double minMetronomeVolume = 0;
  static const double maxMetronomeVolume = 1;
  static const int minBpm = 20;
  static const int maxBpm = 300;

  PracticeSettings({
    this.language = AppLanguage.system,
    this.metronomeEnabled = true,
    double metronomeVolume = 1,
    this.metronomeSound = MetronomeSound.tick,
    Set<String>? activeKeys,
    Set<KeyCenter>? activeKeyCenters,
    this.smartGeneratorMode = false,
    this.secondaryDominantEnabled = false,
    this.substituteDominantEnabled = false,
    this.modalInterchangeEnabled = false,
    this.modulationIntensity = ModulationIntensity.low,
    this.jazzPreset = JazzPreset.standardsCore,
    this.sourceProfile = SourceProfile.fakebookStandard,
    this.smartDiagnosticsEnabled = false,
    this.chordSymbolStyle = ChordSymbolStyle.compact,
    this.allowV7sus4 = false,
    this.allowTensions = false,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    this.voicingSuggestionsEnabled = true,
    this.voicingComplexity = VoicingComplexity.standard,
    this.voicingTopNotePreference = VoicingTopNotePreference.auto,
    this.allowRootlessVoicings = true,
    int maxVoicingNotes = 4,
    int lookAheadDepth = 1,
    this.showVoicingReasons = true,
    int bpm = 60,
    this.keyCenterLabelStyle = KeyCenterLabelStyle.modeText,
  }) : metronomeVolume = metronomeVolume
           .clamp(minMetronomeVolume, maxMetronomeVolume)
           .toDouble(),
       activeKeyCenters = Set.unmodifiable(
         activeKeyCenters ??
             (activeKeys == null
                 ? const <KeyCenter>{}
                 : activeKeys
                       .map((key) => MusicTheory.keyCenterFor(key))
                       .toSet()),
       ),
       selectedTensionOptions = Set.unmodifiable(
         selectedTensionOptions ??
             const <String>{'9', '11', '13', '#11', 'b9', '#9', 'b13'},
       ),
       inversionSettings = inversionSettings ?? const InversionSettings(),
       maxVoicingNotes = maxVoicingNotes.clamp(3, 5),
       lookAheadDepth = lookAheadDepth.clamp(0, 2),
       bpm = bpm.clamp(minBpm, maxBpm).toInt();

  final AppLanguage language;
  final bool metronomeEnabled;
  final double metronomeVolume;
  final MetronomeSound metronomeSound;
  final Set<KeyCenter> activeKeyCenters;
  final bool smartGeneratorMode;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final bool smartDiagnosticsEnabled;
  final ChordSymbolStyle chordSymbolStyle;
  final bool allowV7sus4;
  final bool allowTensions;
  final Set<String> selectedTensionOptions;
  final InversionSettings inversionSettings;
  final bool voicingSuggestionsEnabled;
  final VoicingComplexity voicingComplexity;
  final VoicingTopNotePreference voicingTopNotePreference;
  final bool allowRootlessVoicings;
  final int maxVoicingNotes;
  final int lookAheadDepth;
  final bool showVoicingReasons;
  final int bpm;
  final KeyCenterLabelStyle keyCenterLabelStyle;

  Locale? get locale => language.locale;
  bool get usesKeyMode => activeKeyCenters.isNotEmpty;
  Set<String> get activeKeys =>
      Set.unmodifiable(activeKeyCenters.map((center) => center.tonicName));

  PracticeSettings copyWith({
    AppLanguage? language,
    bool? metronomeEnabled,
    double? metronomeVolume,
    MetronomeSound? metronomeSound,
    Set<String>? activeKeys,
    Set<KeyCenter>? activeKeyCenters,
    bool? smartGeneratorMode,
    bool? secondaryDominantEnabled,
    bool? substituteDominantEnabled,
    bool? modalInterchangeEnabled,
    ModulationIntensity? modulationIntensity,
    JazzPreset? jazzPreset,
    SourceProfile? sourceProfile,
    bool? smartDiagnosticsEnabled,
    ChordSymbolStyle? chordSymbolStyle,
    bool? allowV7sus4,
    bool? allowTensions,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    bool? voicingSuggestionsEnabled,
    VoicingComplexity? voicingComplexity,
    VoicingTopNotePreference? voicingTopNotePreference,
    bool? allowRootlessVoicings,
    int? maxVoicingNotes,
    int? lookAheadDepth,
    bool? showVoicingReasons,
    int? bpm,
    KeyCenterLabelStyle? keyCenterLabelStyle,
  }) {
    return PracticeSettings(
      language: language ?? this.language,
      metronomeEnabled: metronomeEnabled ?? this.metronomeEnabled,
      metronomeVolume: metronomeVolume ?? this.metronomeVolume,
      metronomeSound: metronomeSound ?? this.metronomeSound,
      activeKeyCenters:
          activeKeyCenters ??
          (activeKeys != null
              ? activeKeys.map((key) => MusicTheory.keyCenterFor(key)).toSet()
              : this.activeKeyCenters),
      smartGeneratorMode: smartGeneratorMode ?? this.smartGeneratorMode,
      secondaryDominantEnabled:
          secondaryDominantEnabled ?? this.secondaryDominantEnabled,
      substituteDominantEnabled:
          substituteDominantEnabled ?? this.substituteDominantEnabled,
      modalInterchangeEnabled:
          modalInterchangeEnabled ?? this.modalInterchangeEnabled,
      modulationIntensity: modulationIntensity ?? this.modulationIntensity,
      jazzPreset: jazzPreset ?? this.jazzPreset,
      sourceProfile: sourceProfile ?? this.sourceProfile,
      smartDiagnosticsEnabled:
          smartDiagnosticsEnabled ?? this.smartDiagnosticsEnabled,
      chordSymbolStyle: chordSymbolStyle ?? this.chordSymbolStyle,
      allowV7sus4: allowV7sus4 ?? this.allowV7sus4,
      allowTensions: allowTensions ?? this.allowTensions,
      selectedTensionOptions:
          selectedTensionOptions ?? this.selectedTensionOptions,
      inversionSettings: inversionSettings ?? this.inversionSettings,
      voicingSuggestionsEnabled:
          voicingSuggestionsEnabled ?? this.voicingSuggestionsEnabled,
      voicingComplexity: voicingComplexity ?? this.voicingComplexity,
      voicingTopNotePreference:
          voicingTopNotePreference ?? this.voicingTopNotePreference,
      allowRootlessVoicings:
          allowRootlessVoicings ?? this.allowRootlessVoicings,
      maxVoicingNotes: maxVoicingNotes ?? this.maxVoicingNotes,
      lookAheadDepth: lookAheadDepth ?? this.lookAheadDepth,
      showVoicingReasons: showVoicingReasons ?? this.showVoicingReasons,
      bpm: bpm ?? this.bpm,
      keyCenterLabelStyle: keyCenterLabelStyle ?? this.keyCenterLabelStyle,
    );
  }
}
