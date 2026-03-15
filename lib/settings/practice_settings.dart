import 'package:flutter/material.dart';

import '../audio/harmony_audio_models.dart';
import '../audio/metronome_audio_models.dart';
import '../l10n/app_localizations.dart';
import '../music/chord_anchor_loop.dart';
import '../music/chord_theory.dart';
import '../music/progression_highlight_theme.dart';
import 'inversion_settings.dart';

export '../audio/metronome_audio_models.dart';
export '../music/progression_highlight_theme.dart';

enum AppLanguage { system, en, es, zh, zhHans, ja, ko }

enum AppThemeMode { system, light, dark }

enum PracticeTimeSignature { twoFour, threeFour, fourFour }

enum HarmonicRhythmPreset {
  onePerBar,
  twoPerBar,
  phraseAwareJazz,
  cadenceCompression,
}

enum MelodyDensity { sparse, balanced, active }

enum MelodyStyle { safe, bebop, lyrical, colorful }

enum MelodyPlaybackMode { chordsOnly, melodyOnly, both }

enum SettingsComplexityMode { guided, standard, advanced }

enum DefaultVoicingSuggestionKind { natural, colorful, easy }

enum ChordLanguageLevel {
  triadsOnly,
  seventhChords,
  safeExtensions,
  fullExtensions,
}

enum RomanPoolPreset {
  corePrimary,
  coreDiatonic,
  fullDiatonic,
  functionalJazz,
  expandedColor,
}

enum VoicingComplexity { basic, standard, modern }

enum VoicingDisplayMode { standard, performance }

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

extension AppThemeModeX on AppThemeMode {
  ThemeMode get materialThemeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  String get storageKey {
    switch (this) {
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  static AppThemeMode fromStorageKey(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.storageKey == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

extension PracticeTimeSignatureX on PracticeTimeSignature {
  String get storageKey => name;

  int get beatsPerBar {
    return switch (this) {
      PracticeTimeSignature.twoFour => 2,
      PracticeTimeSignature.threeFour => 3,
      PracticeTimeSignature.fourFour => 4,
    };
  }

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      PracticeTimeSignature.twoFour => l10n.practiceTimeSignatureTwoFour,
      PracticeTimeSignature.threeFour => l10n.practiceTimeSignatureThreeFour,
      PracticeTimeSignature.fourFour => l10n.practiceTimeSignatureFourFour,
    };
  }

  static PracticeTimeSignature fromStorageKey(String? value) {
    return PracticeTimeSignature.values.firstWhere(
      (signature) => signature.storageKey == value,
      orElse: () => PracticeTimeSignature.fourFour,
    );
  }
}

extension HarmonicRhythmPresetX on HarmonicRhythmPreset {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      HarmonicRhythmPreset.onePerBar => l10n.harmonicRhythmOnePerBar,
      HarmonicRhythmPreset.twoPerBar => l10n.harmonicRhythmTwoPerBar,
      HarmonicRhythmPreset.phraseAwareJazz =>
        l10n.harmonicRhythmPhraseAwareJazz,
      HarmonicRhythmPreset.cadenceCompression =>
        l10n.harmonicRhythmCadenceCompression,
    };
  }

  static HarmonicRhythmPreset fromStorageKey(String? value) {
    return HarmonicRhythmPreset.values.firstWhere(
      (preset) => preset.storageKey == value,
      orElse: () => HarmonicRhythmPreset.onePerBar,
    );
  }
}

extension MelodyDensityX on MelodyDensity {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MelodyDensity.sparse => l10n.melodyDensitySparse,
      MelodyDensity.balanced => l10n.melodyDensityBalanced,
      MelodyDensity.active => l10n.melodyDensityActive,
    };
  }

  static MelodyDensity fromStorageKey(String? value) {
    return MelodyDensity.values.firstWhere(
      (density) => density.storageKey == value,
      orElse: () => MelodyDensity.balanced,
    );
  }
}

extension MelodyStyleX on MelodyStyle {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MelodyStyle.safe => l10n.melodyStyleSafe,
      MelodyStyle.bebop => l10n.melodyStyleBebop,
      MelodyStyle.lyrical => l10n.melodyStyleLyrical,
      MelodyStyle.colorful => l10n.melodyStyleColorful,
    };
  }

  static MelodyStyle fromStorageKey(String? value) {
    return MelodyStyle.values.firstWhere(
      (style) => style.storageKey == value,
      orElse: () => MelodyStyle.safe,
    );
  }
}

extension MelodyPlaybackModeX on MelodyPlaybackMode {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MelodyPlaybackMode.chordsOnly => l10n.melodyPlaybackModeChordsOnly,
      MelodyPlaybackMode.melodyOnly => l10n.melodyPlaybackModeMelodyOnly,
      MelodyPlaybackMode.both => l10n.melodyPlaybackModeBoth,
    };
  }

  static MelodyPlaybackMode fromStorageKey(String? value) {
    return MelodyPlaybackMode.values.firstWhere(
      (mode) => mode.storageKey == value,
      orElse: () => MelodyPlaybackMode.both,
    );
  }
}

extension SettingsComplexityModeX on SettingsComplexityMode {
  String get storageKey => name;

  static SettingsComplexityMode fromStorageKey(String? value) {
    return SettingsComplexityMode.values.firstWhere(
      (mode) => mode.storageKey == value,
      orElse: () => SettingsComplexityMode.guided,
    );
  }
}

extension DefaultVoicingSuggestionKindX on DefaultVoicingSuggestionKind {
  String get storageKey => name;

  static DefaultVoicingSuggestionKind fromStorageKey(String? value) {
    return DefaultVoicingSuggestionKind.values.firstWhere(
      (kind) => kind.storageKey == value,
      orElse: () => DefaultVoicingSuggestionKind.natural,
    );
  }
}

extension ChordLanguageLevelX on ChordLanguageLevel {
  String get storageKey => name;

  static ChordLanguageLevel fromStorageKey(String? value) {
    return ChordLanguageLevel.values.firstWhere(
      (level) => level.storageKey == value,
      orElse: () => ChordLanguageLevel.fullExtensions,
    );
  }
}

extension RomanPoolPresetX on RomanPoolPreset {
  String get storageKey => name;

  static RomanPoolPreset fromStorageKey(String? value) {
    return RomanPoolPreset.values.firstWhere(
      (preset) => preset.storageKey == value,
      orElse: () => RomanPoolPreset.expandedColor,
    );
  }
}

extension VoicingDisplayModeX on VoicingDisplayMode {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      VoicingDisplayMode.standard => l10n.voicingDisplayModeStandard,
      VoicingDisplayMode.performance => l10n.voicingDisplayModePerformance,
    };
  }

  static VoicingDisplayMode fromStorageKey(String? value) {
    return VoicingDisplayMode.values.firstWhere(
      (mode) => mode.storageKey == value,
      orElse: () => VoicingDisplayMode.standard,
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
  static const double minAutoPlayHoldFactor = 0.2;
  static const double maxAutoPlayHoldFactor = 1.4;
  static const double minMelodyMotifStrength = 0;
  static const double maxMelodyMotifStrength = 1;
  static const double minMelodyApproachToneDensity = 0;
  static const double maxMelodyApproachToneDensity = 1;
  static const int minMelodyRangeMidi = 48;
  static const int maxMelodyRangeMidi = 90;
  static const int minMelodyRangeSpan = 7;
  static const double minHarmonyMasterVolume = 0;
  static const double maxHarmonyMasterVolume = 1;
  static const double minHarmonyHoldFactor = 0.35;
  static const double maxHarmonyHoldFactor = 1.75;
  static const double minHarmonyArpeggioStepSpeed = 0.5;
  static const double maxHarmonyArpeggioStepSpeed = 2.0;
  static const double minHumanizationAmount = 0;
  static const double maxHumanizationAmount = 1;
  static const int minBpm = 20;
  static const int maxBpm = 300;

  PracticeSettings({
    this.language = AppLanguage.system,
    this.appThemeMode = AppThemeMode.system,
    this.guidedSetupCompleted = false,
    this.settingsComplexityMode = SettingsComplexityMode.guided,
    this.preferredSuggestionKind = DefaultVoicingSuggestionKind.natural,
    this.chordLanguageLevel = ChordLanguageLevel.fullExtensions,
    this.romanPoolPreset = RomanPoolPreset.expandedColor,
    this.metronomeEnabled = true,
    double metronomeVolume = 1,
    MetronomeSound metronomeSound = MetronomeSound.tick,
    MetronomeSourceSpec? metronomeSource,
    MetronomePatternSettings? metronomePattern,
    this.metronomeUseAccentSound = false,
    MetronomeSourceSpec? metronomeAccentSource,
    this.timeSignature = PracticeTimeSignature.fourFour,
    this.harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
    this.autoPlayChordChanges = false,
    this.autoPlayPattern = HarmonyPlaybackPattern.block,
    double autoPlayHoldFactor = 0.82,
    this.autoPlayMelodyWithChords = false,
    this.melodyGenerationEnabled = false,
    this.melodyDensity = MelodyDensity.balanced,
    double motifRepetitionStrength = 0.55,
    double approachToneDensity = 0.32,
    int melodyRangeLow = 60,
    int melodyRangeHigh = 84,
    this.melodyStyle = MelodyStyle.safe,
    this.allowChromaticApproaches = false,
    this.melodyPlaybackMode = MelodyPlaybackMode.both,
    double harmonyMasterVolume = 1,
    double harmonyPreviewHoldFactor = 1,
    double harmonyArpeggioStepSpeed = 1,
    double harmonyVelocityHumanization = 0,
    double harmonyGainRandomness = 0,
    double harmonyTimingHumanization = 0,
    ChordAnchorLoop? anchorLoop,
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
    Set<ChordQuality>? enabledChordQualities,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    this.voicingSuggestionsEnabled = true,
    this.voicingDisplayMode = VoicingDisplayMode.standard,
    this.voicingComplexity = VoicingComplexity.standard,
    this.voicingTopNotePreference = VoicingTopNotePreference.auto,
    this.allowRootlessVoicings = true,
    int maxVoicingNotes = 4,
    int lookAheadDepth = 1,
    this.showVoicingReasons = true,
    int bpm = 60,
    this.keyCenterLabelStyle = KeyCenterLabelStyle.modeText,
    this.progressionExplanationDetailLevel =
        ProgressionExplanationDetailLevel.concise,
    ProgressionHighlightTheme? progressionHighlightTheme,
  }) : metronomeVolume = metronomeVolume
           .clamp(minMetronomeVolume, maxMetronomeVolume)
           .toDouble(),
       metronomeSource =
           (metronomeSource ??
                   MetronomeSourceSpec.builtIn(sound: metronomeSound))
               .normalized(fallbackSound: metronomeSound),
       metronomePattern = (metronomePattern ?? const MetronomePatternSettings())
           .normalized(beatsPerBar: timeSignature.beatsPerBar),
       metronomeAccentSource =
           (metronomeAccentSource ??
                   const MetronomeSourceSpec.builtIn(
                     sound: MetronomeSound.tickF,
                   ))
               .normalized(fallbackSound: MetronomeSound.tickF),
       autoPlayHoldFactor = autoPlayHoldFactor
           .clamp(minAutoPlayHoldFactor, maxAutoPlayHoldFactor)
           .toDouble(),
       motifRepetitionStrength = motifRepetitionStrength
           .clamp(minMelodyMotifStrength, maxMelodyMotifStrength)
           .toDouble(),
       approachToneDensity = approachToneDensity
           .clamp(
             minMelodyApproachToneDensity,
             maxMelodyApproachToneDensity,
           )
           .toDouble(),
       melodyRangeLow = _clampMelodyRangeLow(melodyRangeLow),
       melodyRangeHigh = _clampMelodyRangeHigh(
         low: _clampMelodyRangeLow(melodyRangeLow),
         high: melodyRangeHigh,
       ),
       harmonyMasterVolume = harmonyMasterVolume
           .clamp(minHarmonyMasterVolume, maxHarmonyMasterVolume)
           .toDouble(),
       harmonyPreviewHoldFactor = harmonyPreviewHoldFactor
           .clamp(minHarmonyHoldFactor, maxHarmonyHoldFactor)
           .toDouble(),
       harmonyArpeggioStepSpeed = harmonyArpeggioStepSpeed
           .clamp(minHarmonyArpeggioStepSpeed, maxHarmonyArpeggioStepSpeed)
           .toDouble(),
       harmonyVelocityHumanization = harmonyVelocityHumanization
           .clamp(minHumanizationAmount, maxHumanizationAmount)
           .toDouble(),
       harmonyGainRandomness = harmonyGainRandomness
           .clamp(minHumanizationAmount, maxHumanizationAmount)
           .toDouble(),
       harmonyTimingHumanization = harmonyTimingHumanization
           .clamp(minHumanizationAmount, maxHumanizationAmount)
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
       enabledChordQualities = Set.unmodifiable(
         _sanitizeEnabledChordQualities(
           enabledChordQualities,
           allowV7sus4: allowV7sus4,
         ),
       ),
       inversionSettings = inversionSettings ?? const InversionSettings(),
       anchorLoop = (anchorLoop ?? const ChordAnchorLoop()).normalized(),
       progressionHighlightTheme =
           (progressionHighlightTheme ?? ProgressionHighlightTheme())
               .normalized(),
       maxVoicingNotes = maxVoicingNotes.clamp(3, 5),
       lookAheadDepth = lookAheadDepth.clamp(0, 2),
       bpm = bpm.clamp(minBpm, maxBpm).toInt();

  final AppLanguage language;
  final AppThemeMode appThemeMode;
  final bool guidedSetupCompleted;
  final SettingsComplexityMode settingsComplexityMode;
  final DefaultVoicingSuggestionKind preferredSuggestionKind;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final bool metronomeEnabled;
  final double metronomeVolume;
  final MetronomeSourceSpec metronomeSource;
  final MetronomePatternSettings metronomePattern;
  final bool metronomeUseAccentSound;
  final MetronomeSourceSpec metronomeAccentSource;
  final PracticeTimeSignature timeSignature;
  final HarmonicRhythmPreset harmonicRhythmPreset;
  final bool autoPlayChordChanges;
  final HarmonyPlaybackPattern autoPlayPattern;
  final double autoPlayHoldFactor;
  final bool autoPlayMelodyWithChords;
  final bool melodyGenerationEnabled;
  final MelodyDensity melodyDensity;
  final double motifRepetitionStrength;
  final double approachToneDensity;
  final int melodyRangeLow;
  final int melodyRangeHigh;
  final MelodyStyle melodyStyle;
  final bool allowChromaticApproaches;
  final MelodyPlaybackMode melodyPlaybackMode;
  final double harmonyMasterVolume;
  final double harmonyPreviewHoldFactor;
  final double harmonyArpeggioStepSpeed;
  final double harmonyVelocityHumanization;
  final double harmonyGainRandomness;
  final double harmonyTimingHumanization;
  final ChordAnchorLoop anchorLoop;
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
  final Set<ChordQuality> enabledChordQualities;
  final Set<String> selectedTensionOptions;
  final InversionSettings inversionSettings;
  final bool voicingSuggestionsEnabled;
  final VoicingDisplayMode voicingDisplayMode;
  final VoicingComplexity voicingComplexity;
  final VoicingTopNotePreference voicingTopNotePreference;
  final bool allowRootlessVoicings;
  final int maxVoicingNotes;
  final int lookAheadDepth;
  final bool showVoicingReasons;
  final int bpm;
  final KeyCenterLabelStyle keyCenterLabelStyle;
  final ProgressionExplanationDetailLevel progressionExplanationDetailLevel;
  final ProgressionHighlightTheme progressionHighlightTheme;

  Locale? get locale => language.locale;
  ThemeMode get themeMode => appThemeMode.materialThemeMode;
  int get beatsPerBar => timeSignature.beatsPerBar;
  int get melodyRangeCenter => ((melodyRangeLow + melodyRangeHigh) / 2).round();
  MetronomeSound get metronomeSound => metronomeSource.builtInSound;
  MetronomeSound get metronomeAccentSound => metronomeAccentSource.builtInSound;
  List<MetronomeBeatState> get metronomeBeatStates =>
      metronomePattern.resolve(beatsPerBar: beatsPerBar);
  MetronomeBeatState metronomeBeatStateForBeat(int beatIndex) {
    final beatStates = metronomeBeatStates;
    return beatStates[beatIndex % beatStates.length];
  }

  bool get usesLegacyBarTiming =>
      timeSignature == PracticeTimeSignature.fourFour &&
      harmonicRhythmPreset == HarmonicRhythmPreset.onePerBar;
  bool get usesKeyMode => activeKeyCenters.isNotEmpty;
  Set<String> get activeKeys =>
      Set.unmodifiable(activeKeyCenters.map((center) => center.tonicName));

  PracticeSettings copyWith({
    AppLanguage? language,
    AppThemeMode? appThemeMode,
    bool? guidedSetupCompleted,
    SettingsComplexityMode? settingsComplexityMode,
    DefaultVoicingSuggestionKind? preferredSuggestionKind,
    ChordLanguageLevel? chordLanguageLevel,
    RomanPoolPreset? romanPoolPreset,
    bool? metronomeEnabled,
    double? metronomeVolume,
    MetronomeSound? metronomeSound,
    MetronomeSourceSpec? metronomeSource,
    MetronomePatternSettings? metronomePattern,
    bool? metronomeUseAccentSound,
    MetronomeSound? metronomeAccentSound,
    MetronomeSourceSpec? metronomeAccentSource,
    PracticeTimeSignature? timeSignature,
    HarmonicRhythmPreset? harmonicRhythmPreset,
    bool? autoPlayChordChanges,
    HarmonyPlaybackPattern? autoPlayPattern,
    double? autoPlayHoldFactor,
    bool? autoPlayMelodyWithChords,
    bool? melodyGenerationEnabled,
    MelodyDensity? melodyDensity,
    double? motifRepetitionStrength,
    double? approachToneDensity,
    int? melodyRangeLow,
    int? melodyRangeHigh,
    MelodyStyle? melodyStyle,
    bool? allowChromaticApproaches,
    MelodyPlaybackMode? melodyPlaybackMode,
    double? harmonyMasterVolume,
    double? harmonyPreviewHoldFactor,
    double? harmonyArpeggioStepSpeed,
    double? harmonyVelocityHumanization,
    double? harmonyGainRandomness,
    double? harmonyTimingHumanization,
    ChordAnchorLoop? anchorLoop,
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
    Set<ChordQuality>? enabledChordQualities,
    Set<String>? selectedTensionOptions,
    InversionSettings? inversionSettings,
    bool? voicingSuggestionsEnabled,
    VoicingDisplayMode? voicingDisplayMode,
    VoicingComplexity? voicingComplexity,
    VoicingTopNotePreference? voicingTopNotePreference,
    bool? allowRootlessVoicings,
    int? maxVoicingNotes,
    int? lookAheadDepth,
    bool? showVoicingReasons,
    int? bpm,
    KeyCenterLabelStyle? keyCenterLabelStyle,
    ProgressionExplanationDetailLevel? progressionExplanationDetailLevel,
    ProgressionHighlightTheme? progressionHighlightTheme,
  }) {
    final resolvedMetronomeSource =
        metronomeSource ??
        (metronomeSound != null
            ? this.metronomeSource.copyWith(builtInSound: metronomeSound)
            : this.metronomeSource);
    final resolvedAccentSource =
        metronomeAccentSource ??
        (metronomeAccentSound != null
            ? this.metronomeAccentSource.copyWith(
                builtInSound: metronomeAccentSound,
              )
            : this.metronomeAccentSource);
    return PracticeSettings(
      language: language ?? this.language,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      guidedSetupCompleted: guidedSetupCompleted ?? this.guidedSetupCompleted,
      settingsComplexityMode:
          settingsComplexityMode ?? this.settingsComplexityMode,
      preferredSuggestionKind:
          preferredSuggestionKind ?? this.preferredSuggestionKind,
      chordLanguageLevel: chordLanguageLevel ?? this.chordLanguageLevel,
      romanPoolPreset: romanPoolPreset ?? this.romanPoolPreset,
      metronomeEnabled: metronomeEnabled ?? this.metronomeEnabled,
      metronomeVolume: metronomeVolume ?? this.metronomeVolume,
      metronomeSound: resolvedMetronomeSource.builtInSound,
      metronomeSource: resolvedMetronomeSource,
      metronomePattern: metronomePattern ?? this.metronomePattern,
      metronomeUseAccentSound:
          metronomeUseAccentSound ?? this.metronomeUseAccentSound,
      metronomeAccentSource: resolvedAccentSource,
      timeSignature: timeSignature ?? this.timeSignature,
      harmonicRhythmPreset: harmonicRhythmPreset ?? this.harmonicRhythmPreset,
      autoPlayChordChanges: autoPlayChordChanges ?? this.autoPlayChordChanges,
      autoPlayPattern: autoPlayPattern ?? this.autoPlayPattern,
      autoPlayHoldFactor: autoPlayHoldFactor ?? this.autoPlayHoldFactor,
      autoPlayMelodyWithChords:
          autoPlayMelodyWithChords ?? this.autoPlayMelodyWithChords,
      melodyGenerationEnabled:
          melodyGenerationEnabled ?? this.melodyGenerationEnabled,
      melodyDensity: melodyDensity ?? this.melodyDensity,
      motifRepetitionStrength:
          motifRepetitionStrength ?? this.motifRepetitionStrength,
      approachToneDensity: approachToneDensity ?? this.approachToneDensity,
      melodyRangeLow: melodyRangeLow ?? this.melodyRangeLow,
      melodyRangeHigh: melodyRangeHigh ?? this.melodyRangeHigh,
      melodyStyle: melodyStyle ?? this.melodyStyle,
      allowChromaticApproaches:
          allowChromaticApproaches ?? this.allowChromaticApproaches,
      melodyPlaybackMode: melodyPlaybackMode ?? this.melodyPlaybackMode,
      harmonyMasterVolume: harmonyMasterVolume ?? this.harmonyMasterVolume,
      harmonyPreviewHoldFactor:
          harmonyPreviewHoldFactor ?? this.harmonyPreviewHoldFactor,
      harmonyArpeggioStepSpeed:
          harmonyArpeggioStepSpeed ?? this.harmonyArpeggioStepSpeed,
      harmonyVelocityHumanization:
          harmonyVelocityHumanization ?? this.harmonyVelocityHumanization,
      harmonyGainRandomness:
          harmonyGainRandomness ?? this.harmonyGainRandomness,
      harmonyTimingHumanization:
          harmonyTimingHumanization ?? this.harmonyTimingHumanization,
      anchorLoop: anchorLoop ?? this.anchorLoop,
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
      enabledChordQualities:
          enabledChordQualities ?? this.enabledChordQualities,
      selectedTensionOptions:
          selectedTensionOptions ?? this.selectedTensionOptions,
      inversionSettings: inversionSettings ?? this.inversionSettings,
      voicingSuggestionsEnabled:
          voicingSuggestionsEnabled ?? this.voicingSuggestionsEnabled,
      voicingDisplayMode: voicingDisplayMode ?? this.voicingDisplayMode,
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
      progressionExplanationDetailLevel:
          progressionExplanationDetailLevel ??
          this.progressionExplanationDetailLevel,
      progressionHighlightTheme:
          progressionHighlightTheme ?? this.progressionHighlightTheme,
    );
  }

  static Set<ChordQuality> _sanitizeEnabledChordQualities(
    Set<ChordQuality>? enabledChordQualities, {
    required bool allowV7sus4,
  }) {
    final source =
        enabledChordQualities ??
        MusicTheory.defaultGeneratorChordQualities(allowV7sus4: allowV7sus4);
    final ordered = <ChordQuality>{
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (source.contains(quality)) quality,
    };
    if (ordered.isNotEmpty) {
      return ordered;
    }
    return MusicTheory.defaultGeneratorChordQualities(allowV7sus4: allowV7sus4);
  }

  static int _clampMelodyRangeLow(int value) {
    return value.clamp(
      minMelodyRangeMidi,
      maxMelodyRangeMidi - minMelodyRangeSpan,
    );
  }

  static int _clampMelodyRangeHigh({
    required int low,
    required int high,
  }) {
    final normalizedLow = _clampMelodyRangeLow(low);
    return high.clamp(
      normalizedLow + minMelodyRangeSpan,
      maxMelodyRangeMidi,
    );
  }
}
