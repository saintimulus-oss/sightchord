// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuración';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Predeterminado del sistema';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Activa el metrónomo para escuchar un clic en cada pulso mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metrónomo';

  @override
  String get metronomeSoundClassic => 'Clásico';

  @override
  String get metronomeSoundClickB => 'Click B';

  @override
  String get metronomeSoundClickC => 'Click C';

  @override
  String get metronomeSoundClickD => 'Click D';

  @override
  String get metronomeSoundClickE => 'Click E';

  @override
  String get metronomeSoundClickF => 'Click F';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get keys => 'Tonalidades';

  @override
  String get noKeysSelected =>
      'No hay tonalidades seleccionadas. Deja todas apagadas para practicar en modo libre con todas las raíces.';

  @override
  String get keysSelectedHelp =>
      'Las tonalidades seleccionadas se usan para el modo aleatorio por tonalidad y para Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional y conserva las opciones no diatónicas activadas.';

  @override
  String get advancedSmartGenerator => 'Smart Generator avanzado';

  @override
  String get modulationIntensity => 'Intensidad de modulación';

  @override
  String get modulationIntensityOff => 'Desactivada';

  @override
  String get modulationIntensityLow => 'Baja';

  @override
  String get modulationIntensityMedium => 'Media';

  @override
  String get modulationIntensityHigh => 'Alta';

  @override
  String get jazzPreset => 'Preajuste jazz';

  @override
  String get jazzPresetStandardsCore => 'Estándar esencial';

  @override
  String get jazzPresetModulationStudy => 'Estudio de modulaciones';

  @override
  String get jazzPresetAdvanced => 'Avanzado';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook estándar';

  @override
  String get sourceProfileRecordingInspired => 'Inspirado en grabaciones';

  @override
  String get smartDiagnostics => 'Diagnósticos Smart';

  @override
  String get smartDiagnosticsHelp =>
      'Registra trazas de decisión de Smart Generator para depuración.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Selecciona al menos una tonalidad para usar Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones no diatónicas solo están disponibles en el modo por tonalidad.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Dominante sustituta';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal solo aparece en modo por tonalidad, por eso esta opción se desactiva en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Solo cambia la capa visual. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get tensionHelp =>
      'Solo perfil por número romano y chips seleccionados';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Activar inversiones';

  @override
  String get inversionHelp =>
      'Aplica aleatoriamente la notación con bajo en slash después de elegir el acorde; no sigue el bajo anterior.';

  @override
  String get firstInversion => '1.ª inversión';

  @override
  String get secondInversion => '2.ª inversión';

  @override
  String get thirdInversion => '3.ª inversión';

  @override
  String get keyPracticeOverview => 'Resumen de práctica por tonalidad';

  @override
  String get freePracticeOverview => 'Resumen de práctica libre';

  @override
  String get keyModeTag => 'Modo tonalidad';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las tonalidades';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Pulsa Next Chord para empezar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Usa las 12 raíces cromáticas con calidades de acorde aleatorias para una práctica amplia de lectura.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo de funciones armónicas en las tonalidades seleccionadas y permite movimientos inteligentes con buen gusto.';

  @override
  String get keyPracticeDescription =>
      'Usa las tonalidades seleccionadas y los números romanos activados para generar material diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Space: siguiente acorde  Enter: iniciar o detener autoplay  Up/Down: ajustar BPM';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => 'Iniciar autoplay';

  @override
  String get stopAutoplay => 'Detener autoplay';

  @override
  String get decreaseBpm => 'Bajar BPM';

  @override
  String get increaseBpm => 'Subir BPM';

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min-$max';
  }

  @override
  String get voicingSuggestionsTitle => 'Voicing Suggestions';

  @override
  String get voicingSuggestionsSubtitle =>
      'See concrete note choices for this chord.';

  @override
  String get voicingSuggestionsEnabled => 'Enable Voicing Suggestions';

  @override
  String get voicingSuggestionsHelp =>
      'Shows three playable note-level voicing ideas for the current chord.';

  @override
  String get voicingComplexity => 'Voicing Complexity';

  @override
  String get voicingComplexityHelp =>
      'Controls how colorful the suggestions may become.';

  @override
  String get voicingComplexityBasic => 'Basic';

  @override
  String get voicingComplexityStandard => 'Standard';

  @override
  String get voicingComplexityModern => 'Modern';

  @override
  String get voicingTopNotePreference => 'Preferencia de nota superior';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Inclina las sugerencias hacia una linea superior elegida. Los voicings bloqueados mandan primero y los acordes repetidos la mantienen estable.';

  @override
  String get voicingTopNotePreferenceAuto => 'Auto';

  @override
  String get allowRootlessVoicings => 'Allow Rootless Voicings';

  @override
  String get allowRootlessVoicingsHelp =>
      'Lets suggestions omit the root when the guide tones stay clear.';

  @override
  String get maxVoicingNotes => 'Max Voicing Notes';

  @override
  String get lookAheadDepth => 'Look-Ahead Depth';

  @override
  String get lookAheadDepthHelp =>
      'How many future chords the ranking may consider.';

  @override
  String get showVoicingReasons => 'Show Voicing Reasons';

  @override
  String get showVoicingReasonsHelp =>
      'Displays short explanation chips on each suggestion card.';

  @override
  String get voicingSuggestionNatural => 'Most Natural';

  @override
  String get voicingSuggestionColorful => 'Most Colorful';

  @override
  String get voicingSuggestionEasy => 'Easiest';

  @override
  String get voicingSuggestionNaturalSubtitle => 'Voice-leading first';

  @override
  String get voicingSuggestionColorfulSubtitle => 'Leans into color tones';

  @override
  String get voicingSuggestionEasySubtitle => 'Compact hand shape';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle =>
      'Connection and resolution first';

  @override
  String get voicingSuggestionNaturalStableSubtitle =>
      'Same shape, steady comping';

  @override
  String get voicingSuggestionTopLineSubtitle => 'La linea superior manda';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle =>
      'Altered tension up front';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'Modern quartal color';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Tritone-sub edge with bright guide tones';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      'Guide tones with bright extensions';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle =>
      'Core tones, smaller reach';

  @override
  String get voicingSuggestionEasyStableSubtitle =>
      'Repeat-friendly hand shape';

  @override
  String get voicingTopNoteLabel => 'Superior';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'Nota superior objetivo: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Linea superior bloqueada: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'Linea superior repetida: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'Linea superior mas cercana a $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No hay nota superior exacta para $note';
  }

  @override
  String get voicingFamilyShell => 'Shell';

  @override
  String get voicingFamilyRootlessA => 'Rootless A';

  @override
  String get voicingFamilyRootlessB => 'Rootless B';

  @override
  String get voicingFamilySpread => 'Spread';

  @override
  String get voicingFamilySus => 'Sus';

  @override
  String get voicingFamilyQuartal => 'Quartal';

  @override
  String get voicingFamilyAltered => 'Altered';

  @override
  String get voicingFamilyUpperStructure => 'Upper Structure';

  @override
  String get voicingLockSuggestion => 'Lock suggestion';

  @override
  String get voicingUnlockSuggestion => 'Unlock suggestion';

  @override
  String get voicingSelected => 'Selected';

  @override
  String get voicingLocked => 'Locked';

  @override
  String get voicingReasonEssentialCore => 'Essential tones covered';

  @override
  String get voicingReasonGuideToneAnchor => '3rd/7th anchor';

  @override
  String voicingReasonGuideResolution(int count) {
    return '$count guide-tone resolves';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '$count common tones kept';
  }

  @override
  String get voicingReasonStableRepeat => 'Stable repeat';

  @override
  String get voicingReasonTopLineTarget => 'Objetivo de linea superior';

  @override
  String get voicingReasonLowMudAvoided => 'Low-register clarity';

  @override
  String get voicingReasonCompactReach => 'Comfortable reach';

  @override
  String get voicingReasonBassAnchor => 'Bass anchor respected';

  @override
  String get voicingReasonNextChordReady => 'Next chord ready';

  @override
  String get voicingReasonAlteredColor => 'Altered tensions';

  @override
  String get voicingReasonRootlessClarity => 'Light rootless shape';

  @override
  String get voicingReasonSusRelease => 'Sus release set up';

  @override
  String get voicingReasonQuartalColor => 'Quartal color';

  @override
  String get voicingReasonUpperStructureColor => 'Upper-structure color';

  @override
  String get voicingReasonTritoneSubFlavor => 'Tritone-sub flavor';

  @override
  String get voicingReasonLockedContinuity => 'Locked continuity';

  @override
  String get voicingReasonGentleMotion => 'Smooth hand move';
}
