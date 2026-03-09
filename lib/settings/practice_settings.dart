import 'package:flutter/material.dart';

import '../music/chord_theory.dart';

enum AppLanguage { en, es, zhHans, ja, ko }

enum MetronomeSound { tick, tickB, tickC, tickD, tickE, tickF }

extension AppLanguageX on AppLanguage {
  Locale get locale {
    switch (this) {
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.es:
        return const Locale('es');
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
      case AppLanguage.en:
        return 'en';
      case AppLanguage.es:
        return 'es';
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
      case AppLanguage.en:
        return 'English';
      case AppLanguage.es:
        return 'Español';
      case AppLanguage.zhHans:
        return '简体中文';
      case AppLanguage.ja:
        return '日本語';
      case AppLanguage.ko:
        return '한국어';
    }
  }

  static AppLanguage fromStorageKey(String? value) {
    return AppLanguage.values.firstWhere(
      (language) => language.storageKey == value,
      orElse: () => AppLanguage.en,
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

  String get label {
    switch (this) {
      case MetronomeSound.tick:
        return 'Classic';
      case MetronomeSound.tickB:
        return 'Click B';
      case MetronomeSound.tickC:
        return 'Click C';
      case MetronomeSound.tickD:
        return 'Click D';
      case MetronomeSound.tickE:
        return 'Click E';
      case MetronomeSound.tickF:
        return 'Click F';
    }
  }

  static MetronomeSound fromStorageKey(String? value) {
    return MetronomeSound.values.firstWhere(
      (sound) => sound.storageKey == value,
      orElse: () => MetronomeSound.tick,
    );
  }
}

class InversionSettings {
  const InversionSettings({
    this.enabled = false,
    this.firstInversionEnabled = true,
    this.secondInversionEnabled = true,
    this.thirdInversionEnabled = false,
  });

  final bool enabled;
  final bool firstInversionEnabled;
  final bool secondInversionEnabled;
  final bool thirdInversionEnabled;

  InversionSettings copyWith({
    bool? enabled,
    bool? firstInversionEnabled,
    bool? secondInversionEnabled,
    bool? thirdInversionEnabled,
  }) {
    return InversionSettings(
      enabled: enabled ?? this.enabled,
      firstInversionEnabled:
          firstInversionEnabled ?? this.firstInversionEnabled,
      secondInversionEnabled:
          secondInversionEnabled ?? this.secondInversionEnabled,
      thirdInversionEnabled:
          thirdInversionEnabled ?? this.thirdInversionEnabled,
    );
  }

  List<int> get enabledInversions {
    final inversions = <int>[];
    if (firstInversionEnabled) {
      inversions.add(1);
    }
    if (secondInversionEnabled) {
      inversions.add(2);
    }
    if (thirdInversionEnabled) {
      inversions.add(3);
    }
    return inversions;
  }
}

class PracticeSettings {
  PracticeSettings({
    this.language = AppLanguage.en,
    this.metronomeEnabled = true,
    this.metronomeVolume = 1,
    this.metronomeSound = MetronomeSound.tick,
    Set<String>? activeKeys,
    this.smartGeneratorMode = false,
    this.secondaryDominantEnabled = false,
    this.substituteDominantEnabled = false,
    this.modalInterchangeEnabled = false,
    this.chordSymbolStyle = ChordSymbolStyle.compact,
    this.allowV7sus4 = false,
    this.allowTensions = false,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    this.bpm = 60,
  }) : activeKeys = Set.unmodifiable(activeKeys ?? const <String>{}),
       selectedTensionOptions = Set.unmodifiable(
         selectedTensionOptions ??
             const <String>{'9', '11', '13', '#11', 'b9', '#9', 'b13'},
       ),
       inversionSettings = inversionSettings ?? const InversionSettings();

  final AppLanguage language;
  final bool metronomeEnabled;
  final double metronomeVolume;
  final MetronomeSound metronomeSound;
  final Set<String> activeKeys;
  final bool smartGeneratorMode;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ChordSymbolStyle chordSymbolStyle;
  final bool allowV7sus4;
  final bool allowTensions;
  final Set<String> selectedTensionOptions;
  final InversionSettings inversionSettings;
  final int bpm;

  Locale get locale => language.locale;
  bool get usesKeyMode => activeKeys.isNotEmpty;

  PracticeSettings copyWith({
    AppLanguage? language,
    bool? metronomeEnabled,
    double? metronomeVolume,
    MetronomeSound? metronomeSound,
    Set<String>? activeKeys,
    bool? smartGeneratorMode,
    bool? secondaryDominantEnabled,
    bool? substituteDominantEnabled,
    bool? modalInterchangeEnabled,
    ChordSymbolStyle? chordSymbolStyle,
    bool? allowV7sus4,
    bool? allowTensions,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    int? bpm,
  }) {
    return PracticeSettings(
      language: language ?? this.language,
      metronomeEnabled: metronomeEnabled ?? this.metronomeEnabled,
      metronomeVolume: metronomeVolume ?? this.metronomeVolume,
      metronomeSound: metronomeSound ?? this.metronomeSound,
      activeKeys: activeKeys ?? this.activeKeys,
      smartGeneratorMode: smartGeneratorMode ?? this.smartGeneratorMode,
      secondaryDominantEnabled:
          secondaryDominantEnabled ?? this.secondaryDominantEnabled,
      substituteDominantEnabled:
          substituteDominantEnabled ?? this.substituteDominantEnabled,
      modalInterchangeEnabled:
          modalInterchangeEnabled ?? this.modalInterchangeEnabled,
      chordSymbolStyle: chordSymbolStyle ?? this.chordSymbolStyle,
      allowV7sus4: allowV7sus4 ?? this.allowV7sus4,
      allowTensions: allowTensions ?? this.allowTensions,
      selectedTensionOptions:
          selectedTensionOptions ?? this.selectedTensionOptions,
      inversionSettings: inversionSettings ?? this.inversionSettings,
      bpm: bpm ?? this.bpm,
    );
  }
}
