// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Ajustes';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Valor predeterminado del sistema';

  @override
  String get themeMode => 'Tema';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get setupAssistantTitle => 'Setup Assistant';

  @override
  String get setupAssistantSubtitle =>
      'A few quick choices will make your first practice session feel calmer. You can rerun this anytime.';

  @override
  String get setupAssistantCurrentMode => 'Current setup';

  @override
  String get setupAssistantModeGuided => 'Guided mode';

  @override
  String get setupAssistantModeStandard => 'Standard mode';

  @override
  String get setupAssistantModeAdvanced => 'Advanced mode';

  @override
  String get setupAssistantRunAgain => 'Run setup assistant again';

  @override
  String get setupAssistantCardBody =>
      'Use a gentler profile now, then open advanced controls whenever you want more room.';

  @override
  String get setupAssistantPreparingTitle => 'We\'ll start gently';

  @override
  String get setupAssistantPreparingBody =>
      'Before the generator shows any chords, we\'ll set up a comfortable starting point in a few taps.';

  @override
  String setupAssistantProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setupAssistantSkip => 'Skip';

  @override
  String get setupAssistantBack => 'Back';

  @override
  String get setupAssistantNext => 'Next';

  @override
  String get setupAssistantApply => 'Apply';

  @override
  String get setupAssistantGoalQuestionTitle =>
      'What would you like this generator to help with first?';

  @override
  String get setupAssistantGoalQuestionBody =>
      'Pick the one that sounds closest. Nothing here is permanent.';

  @override
  String get setupAssistantGoalEarTitle => 'Hear and recognize chords';

  @override
  String get setupAssistantGoalEarBody =>
      'Short, friendly prompts for listening and recognition.';

  @override
  String get setupAssistantGoalKeyboardTitle => 'Keyboard hand practice';

  @override
  String get setupAssistantGoalKeyboardBody =>
      'Simple shapes and readable symbols for your hands first.';

  @override
  String get setupAssistantGoalSongTitle => 'Song ideas';

  @override
  String get setupAssistantGoalSongBody =>
      'Keep the generator musical without dumping you into chaos.';

  @override
  String get setupAssistantGoalHarmonyTitle => 'Harmony study';

  @override
  String get setupAssistantGoalHarmonyBody =>
      'Start clear, then leave room to grow into deeper harmony.';

  @override
  String get setupAssistantLiteracyQuestionTitle =>
      'Which sentence feels closest right now?';

  @override
  String get setupAssistantLiteracyQuestionBody =>
      'Choose the most comfortable answer, not the most ambitious one.';

  @override
  String get setupAssistantLiteracyAbsoluteTitle =>
      'C, Cm, C7, and Cmaj7 still blur together';

  @override
  String get setupAssistantLiteracyAbsoluteBody =>
      'Keep things extra readable and familiar.';

  @override
  String get setupAssistantLiteracyBasicTitle => 'I can read maj7 / m7 / 7';

  @override
  String get setupAssistantLiteracyBasicBody =>
      'Stay safe, but allow a little more range.';

  @override
  String get setupAssistantLiteracyFunctionalTitle =>
      'I mostly follow ii-V-I and diatonic function';

  @override
  String get setupAssistantLiteracyFunctionalBody =>
      'Keep the harmony clear with a bit more motion.';

  @override
  String get setupAssistantLiteracyAdvancedTitle =>
      'Colorful reharmonization and extensions already feel familiar';

  @override
  String get setupAssistantLiteracyAdvancedBody =>
      'Leave more of the power-user range available.';

  @override
  String get setupAssistantHandQuestionTitle =>
      'How comfortable do your hands feel on keys?';

  @override
  String get setupAssistantHandQuestionBody =>
      'We\'ll use this to keep voicings playable.';

  @override
  String get setupAssistantHandThreeTitle => 'Three-note shapes feel best';

  @override
  String get setupAssistantHandThreeBody => 'Keep the hand shape compact.';

  @override
  String get setupAssistantHandFourTitle => 'Four notes are okay';

  @override
  String get setupAssistantHandFourBody => 'Allow a little more spread.';

  @override
  String get setupAssistantHandJazzTitle => 'Jazzier shapes feel comfortable';

  @override
  String get setupAssistantHandJazzBody =>
      'Open the door to larger voicings later.';

  @override
  String get setupAssistantColorQuestionTitle =>
      'How colorful should the sound feel at first?';

  @override
  String get setupAssistantColorQuestionBody => 'When in doubt, start simpler.';

  @override
  String get setupAssistantColorSafeTitle => 'Safe and familiar';

  @override
  String get setupAssistantColorSafeBody =>
      'Stay close to classic, readable harmony.';

  @override
  String get setupAssistantColorJazzyTitle => 'A little jazzy';

  @override
  String get setupAssistantColorJazzyBody =>
      'Add a touch of color without getting wild.';

  @override
  String get setupAssistantColorColorfulTitle => 'Quite colorful';

  @override
  String get setupAssistantColorColorfulBody =>
      'Leave more room for modern color.';

  @override
  String get setupAssistantSymbolQuestionTitle =>
      'Which chord spelling feels easiest to read?';

  @override
  String get setupAssistantSymbolQuestionBody =>
      'This only changes how the chord is shown.';

  @override
  String get setupAssistantSymbolMajTextBody => 'Clear and beginner-friendly.';

  @override
  String get setupAssistantSymbolCompactBody =>
      'Shorter if you already like compact symbols.';

  @override
  String get setupAssistantSymbolDeltaBody =>
      'Jazz-style if that is what your eyes expect.';

  @override
  String get setupAssistantKeyQuestionTitle => 'Which key should we start in?';

  @override
  String get setupAssistantKeyQuestionBody =>
      'C major is the easiest default, but you can change it later.';

  @override
  String get setupAssistantKeyCMajorBody => 'Best beginner starting point.';

  @override
  String get setupAssistantKeyGMajorBody =>
      'A bright major key with one sharp.';

  @override
  String get setupAssistantKeyFMajorBody => 'A warm major key with one flat.';

  @override
  String get setupAssistantPreviewTitle => 'Try your first result';

  @override
  String get setupAssistantPreviewBody =>
      'This is about what the generator will feel like. You can make it simpler or a little jazzier before you start.';

  @override
  String get setupAssistantPreviewListen => 'Hear this sample';

  @override
  String get setupAssistantPreviewPlaying => 'Playing sample...';

  @override
  String get setupAssistantStartNow => 'Start with this';

  @override
  String get setupAssistantAdjustEasier => 'Make it easier';

  @override
  String get setupAssistantAdjustJazzier => 'A little more jazzy';

  @override
  String get setupAssistantPreviewKeyLabel => 'Key';

  @override
  String get setupAssistantPreviewNotationLabel => 'Notation';

  @override
  String get setupAssistantPreviewDifficultyLabel => 'Feel';

  @override
  String get setupAssistantPreviewProgressionLabel => 'Sample progression';

  @override
  String get setupAssistantPreviewProgressionBody =>
      'A short four-chord sample built from your setup.';

  @override
  String get setupAssistantPreviewSummaryAbsolute => 'Beginner-friendly start';

  @override
  String get setupAssistantPreviewSummaryBasic =>
      'Readable seventh-chord start';

  @override
  String get setupAssistantPreviewSummaryFunctional =>
      'Functional harmony start';

  @override
  String get setupAssistantPreviewSummaryAdvanced => 'Colorful jazz start';

  @override
  String get setupAssistantPreviewBodyTriads =>
      'Mostly familiar triads in a safe key, with compact voicings and no spicy surprises.';

  @override
  String get setupAssistantPreviewBodySevenths =>
      'maj7, m7, and 7 show up clearly, while the progression still stays calm and readable.';

  @override
  String get setupAssistantPreviewBodySafeExtensions =>
      'A little extra color can appear, but it stays within safe, familiar extensions.';

  @override
  String get setupAssistantPreviewBodyFullExtensions =>
      'The preview leaves more room for modern color, richer movement, and denser harmony.';

  @override
  String get setupAssistantNotationMajText => 'Cmaj7 style';

  @override
  String get setupAssistantNotationCompact => 'CM7 style';

  @override
  String get setupAssistantNotationDelta => 'CΔ7 style';

  @override
  String get setupAssistantDifficultyTriads =>
      'Simple triads and core movement';

  @override
  String get setupAssistantDifficultySevenths => 'maj7 / m7 / 7 centered';

  @override
  String get setupAssistantDifficultySafeExtensions =>
      'Safe color with 9 / 11 / 13';

  @override
  String get setupAssistantDifficultyFullExtensions =>
      'Full color and wider motion';

  @override
  String get setupAssistantStudyHarmonyTitle =>
      'Want a gentler theory path too?';

  @override
  String get setupAssistantStudyHarmonyBody =>
      'Study Harmony can walk you through the basics while this generator stays in a safe lane.';

  @override
  String get setupAssistantStudyHarmonyCta => 'Start Study Harmony';

  @override
  String get setupAssistantGuidedSettingsTitle =>
      'Beginner-friendly setup is on';

  @override
  String get setupAssistantGuidedSettingsBody =>
      'Core controls stay close by here. Everything else is still available when you want it.';

  @override
  String get setupAssistantAdvancedSectionTitle => 'More controls';

  @override
  String get setupAssistantAdvancedSectionBody =>
      'Open the full settings page if you want every generator option.';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Enciende el metrónomo para escuchar un clic en cada tiempo mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metrónomo';

  @override
  String get metronomeSoundClassic => 'Clásico';

  @override
  String get metronomeSoundClickB => 'Haga clic en B';

  @override
  String get metronomeSoundClickC => 'Haga clic en C';

  @override
  String get metronomeSoundClickD => 'Haga clic en D';

  @override
  String get metronomeSoundClickE => 'Haga clic en E';

  @override
  String get metronomeSoundClickF => 'Haga clic en F';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get practiceMeter => 'Time Signature';

  @override
  String get practiceMeterHelp =>
      'Choose how many beats are in each bar for transport and metronome timing.';

  @override
  String get practiceTimeSignatureTwoFour => '2/4';

  @override
  String get practiceTimeSignatureThreeFour => '3/4';

  @override
  String get practiceTimeSignatureFourFour => '4/4';

  @override
  String get practiceTimeSignatureFiveFour => '5/4';

  @override
  String get practiceTimeSignatureSixEight => '6/8';

  @override
  String get practiceTimeSignatureSevenEight => '7/8';

  @override
  String get practiceTimeSignatureTwelveEight => '12/8';

  @override
  String get harmonicRhythm => 'Harmonic Rhythm';

  @override
  String get harmonicRhythmHelp =>
      'Choose how often chord changes can happen inside the bar.';

  @override
  String get harmonicRhythmOnePerBar => 'One per bar';

  @override
  String get harmonicRhythmTwoPerBar => 'Two per bar';

  @override
  String get harmonicRhythmPhraseAwareJazz => 'Phrase-aware jazz';

  @override
  String get harmonicRhythmCadenceCompression => 'Cadence compression';

  @override
  String get keys => 'Llaves';

  @override
  String get noKeysSelected =>
      'No hay claves seleccionadas. Deja todas las teclas apagadas para practicar en modo libre en cada raíz.';

  @override
  String get keysSelectedHelp =>
      'Las claves seleccionadas se utilizan para el modo aleatorio con reconocimiento de clave y el modo Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional conservando las opciones no diatónico habilitadas.';

  @override
  String get advancedSmartGenerator => 'Avanzado Smart Generator';

  @override
  String get modulationIntensity => 'Intensidad de modulación';

  @override
  String get modulationIntensityOff => 'Apagado';

  @override
  String get modulationIntensityLow => 'Bajo';

  @override
  String get modulationIntensityMedium => 'Medio';

  @override
  String get modulationIntensityHigh => 'Alto';

  @override
  String get jazzPreset => 'Preajuste de jazz';

  @override
  String get jazzPresetStandardsCore => 'Núcleo de estándares';

  @override
  String get jazzPresetModulationStudy => 'Estudio de modulación';

  @override
  String get jazzPresetAdvanced => 'Avanzado';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Estándar de libro falso';

  @override
  String get sourceProfileRecordingInspired => 'Grabación inspirada';

  @override
  String get smartDiagnostics => 'Diagnóstico inteligente';

  @override
  String get smartDiagnosticsHelp =>
      'Registra los seguimientos de decisiones Smart Generator para la depuración.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Seleccione al menos una tecla para usar el modo Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones que no son diatónico están disponibles solo en modo clave.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Sustituto dominante';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal sólo aparece en modo clave, por lo que esta opción está deshabilitada en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get keyCenterLabelStyle => 'Estilo de etiqueta clave';

  @override
  String get keyCenterLabelStyleHelp =>
      'Elija entre nombres de modo explícitos y etiquetas tónicas clásicas en mayúsculas/minúsculas.';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Cambia solo la capa de visualización. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compacto';

  @override
  String get styleMajText => 'MajTexto';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get keyCenterLabelStyleModeText => 'Do mayor: / Do menor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C:/c:';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get chordTypeFilters => 'Tipos de acordes';

  @override
  String get chordTypeFiltersHelp =>
      'Elige que tipos de acordes pueden aparecer en el generador.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total activados';
  }

  @override
  String get chordTypeGroupTriads => 'Triadas';

  @override
  String get chordTypeGroupSevenths => 'Septimas';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sextas y notas anadidas';

  @override
  String get chordTypeGroupDominantVariants => 'Variantes dominantes';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 solo esta disponible cuando se selecciona al menos una tonalidad.';

  @override
  String get chordTypeKeepOneEnabled =>
      'Manten al menos un tipo de acorde activado.';

  @override
  String get tensionHelp =>
      'Perfil número romano y chips seleccionados únicamente';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Habilitar inversiones';

  @override
  String get inversionHelp =>
      'Representación aleatoria de graves después de la selección de acordes; no rastrea el bajo anterior.';

  @override
  String get firstInversion => '1ra inversión';

  @override
  String get secondInversion => '2da inversión';

  @override
  String get thirdInversion => '3ra inversión';

  @override
  String get keyPracticeOverview =>
      'Descripción general de las prácticas clave';

  @override
  String get freePracticeOverview => 'Descripción general de la práctica libre';

  @override
  String get keyModeTag => 'Modo clave';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las claves';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Presione Siguiente acorde para comenzar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Utiliza las 12 raíces cromáticas con cualidades de acordes aleatorios para una práctica de lectura amplia.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo función armónica en las teclas seleccionadas al tiempo que permite un movimiento elegante del generador inteligente.';

  @override
  String get keyPracticeDescription =>
      'Utiliza las claves seleccionadas y los número romano habilitados para generar material de práctica diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Espacio: siguiente acorde Enter: iniciar o pausar la reproducción automática Arriba/Abajo: ajustar BPM';

  @override
  String get currentChord => 'Acorde actual';

  @override
  String get nextChord => 'Acorde siguiente';

  @override
  String get audioPlayChord => 'tocar acorde';

  @override
  String get audioPlayArpeggio => 'Tocar arpegio';

  @override
  String get audioPlayProgression => 'Progresión del juego';

  @override
  String get audioPlayPrompt => 'Reproducir mensaje';

  @override
  String get startAutoplay => 'Iniciar reproducción automática';

  @override
  String get pauseAutoplay => 'Pausar reproducción automática';

  @override
  String get stopAutoplay => 'Detener la reproducción automática';

  @override
  String get resetGeneratedChords => 'Reiniciar acordes generados';

  @override
  String get decreaseBpm => 'Disminuir BPM';

  @override
  String get increaseBpm => 'Aumentar BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min-$max';
  }

  @override
  String get modeMajor => 'importante';

  @override
  String get modeMinor => 'menor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Sugerencias de voicings';

  @override
  String get voicingSuggestionsSubtitle =>
      'Vea opciones de notas concretas para este acorde.';

  @override
  String get voicingSuggestionsEnabled => 'Habilitar sugerencias de voz';

  @override
  String get voicingSuggestionsHelp =>
      'Muestra tres ideas voicing a nivel de nota reproducibles para el acorde actual.';

  @override
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

  @override
  String get voicingComplexity => 'Complejidad de expresión';

  @override
  String get voicingComplexityHelp =>
      'Controla el color que pueden llegar a tener las sugerencias.';

  @override
  String get voicingComplexityBasic => 'Básico';

  @override
  String get voicingComplexityStandard => 'Estándar';

  @override
  String get voicingComplexityModern => 'Moderno';

  @override
  String get voicingTopNotePreference => 'Preferencia de nota superior';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Inclina sugerencias hacia un línea superior elegido. Los voicing bloqueados ganan primero, luego los acordes repetidos lo mantienen estable.';

  @override
  String get voicingTopNotePreferenceAuto => 'Automático';

  @override
  String get allowRootlessVoicings => 'Permitir voces desarraigadas';

  @override
  String get allowRootlessVoicingsHelp =>
      'Permitamos que las sugerencias omitan la raíz cuando los nota guía permanezcan claros.';

  @override
  String get maxVoicingNotes => 'Notas de voz máximas';

  @override
  String get lookAheadDepth => 'Profundidad de anticipación';

  @override
  String get lookAheadDepthHelp =>
      'Cuántos acordes futuros puede considerar el ranking.';

  @override
  String get showVoicingReasons => 'Mostrar razones para expresar';

  @override
  String get showVoicingReasonsHelp =>
      'Muestra breves fichas explicativas en cada tarjeta de sugerencias.';

  @override
  String get voicingSuggestionNatural => 'más natural';

  @override
  String get voicingSuggestionColorful => 'más colorido';

  @override
  String get voicingSuggestionEasy => 'mas facil';

  @override
  String get voicingSuggestionNaturalSubtitle => 'Primero la voz principal';

  @override
  String get voicingSuggestionColorfulSubtitle =>
      'Se inclina hacia los tonos de color.';

  @override
  String get voicingSuggestionEasySubtitle => 'Forma de mano compacta';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle =>
      'Conexión y resolución primero.';

  @override
  String get voicingSuggestionNaturalStableSubtitle =>
      'Misma forma, competición constante';

  @override
  String get voicingSuggestionTopLineSubtitle =>
      'Clientes potenciales de primera línea';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle =>
      'Tensión alterada en la delantera';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'Color cuarto moderno';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Borde sub-tritono con nota guía brillantes';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      'Tonos guía con extensiones brillantes.';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle =>
      'Tonos centrales, menor alcance';

  @override
  String get voicingSuggestionEasyStableSubtitle =>
      'Forma de mano fácil de repetir';

  @override
  String get voicingPerformanceSubtitle =>
      'Feature one representative comping shape and keep the next move in view.';

  @override
  String get voicingPerformanceCurrentTitle => 'Current voicing';

  @override
  String get voicingPerformanceNextTitle => 'Next preview';

  @override
  String get voicingPerformanceCurrentOnly => 'Current only';

  @override
  String get voicingPerformanceShared => 'Shared';

  @override
  String get voicingPerformanceNextOnly => 'Next move';

  @override
  String voicingPerformanceTopLinePath(Object current, Object next) {
    return 'Top line: $current -> $next';
  }

  @override
  String get voicingTopNoteLabel => 'Arriba';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'Objetivo de línea superior: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Bloqueado línea superior: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'línea superior repetido: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'línea superior más cercano a $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No hay línea superior exacto para $note';
  }

  @override
  String get voicingFamilyShell => 'Caparazón';

  @override
  String get voicingFamilyRootlessA => 'Sin raíces A';

  @override
  String get voicingFamilyRootlessB => 'Sin raíces B';

  @override
  String get voicingFamilySpread => 'Desparramar';

  @override
  String get voicingFamilySus => 'sus';

  @override
  String get voicingFamilyQuartal => 'cuarto';

  @override
  String get voicingFamilyAltered => 'alterado';

  @override
  String get voicingFamilyUpperStructure => 'Estructura superior';

  @override
  String get voicingLockSuggestion => 'Sugerencia de bloqueo';

  @override
  String get voicingUnlockSuggestion => 'Sugerencia de desbloqueo';

  @override
  String get voicingSelected => 'Seleccionado';

  @override
  String get voicingLocked => 'bloqueado';

  @override
  String get voicingReasonEssentialCore => 'Tonos esenciales cubiertos';

  @override
  String get voicingReasonGuideToneAnchor => '3.º/7.º ancla';

  @override
  String voicingReasonGuideResolution(int count) {
    return 'El tono guía $count se resuelve';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return 'Se mantienen los tonos comunes $count';
  }

  @override
  String get voicingReasonStableRepeat => 'Repetición estable';

  @override
  String get voicingReasonTopLineTarget => 'Objetivo de primera línea';

  @override
  String get voicingReasonLowMudAvoided => 'Claridad de registro bajo';

  @override
  String get voicingReasonCompactReach => 'Alcance cómodo';

  @override
  String get voicingReasonBassAnchor => 'Ancla de bajo respetada';

  @override
  String get voicingReasonNextChordReady => 'Siguiente acorde listo';

  @override
  String get voicingReasonAlteredColor => 'Tensiones alteradas';

  @override
  String get voicingReasonRootlessClarity => 'Forma ligera y sin raíces.';

  @override
  String get voicingReasonSusRelease => 'Configuración de lanzamiento de Sus';

  @override
  String get voicingReasonQuartalColor => 'color cuarto';

  @override
  String get voicingReasonUpperStructureColor =>
      'Color de la estructura superior';

  @override
  String get voicingReasonTritoneSubFlavor => 'Sabor sub-tritono';

  @override
  String get voicingReasonLockedContinuity => 'Continuidad bloqueada';

  @override
  String get voicingReasonGentleMotion => 'Movimiento suave de la mano';

  @override
  String get mainMenuIntro =>
      'Genera tu siguiente loop de acordes en Chordest y usa el Analyzer solo cuando necesites una lectura armónica cautelosa.';

  @override
  String get mainMenuGeneratorTitle => 'Generador Chordest';

  @override
  String get mainMenuGeneratorDescription =>
      'Empieza con un loop tocable, ayuda de voicings y controles rápidos de práctica.';

  @override
  String get openGenerator => 'Empezar práctica';

  @override
  String get openAnalyzer => 'Analizar progresión';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Consulta tonalidades probables, números romanos y avisos con una lectura conservadora.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Estudio de armonía';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Retoma lecciones, repasa capítulos y fortalece tu armonía práctica.';

  @override
  String get openStudyHarmony => 'Empezar armonía';

  @override
  String get studyHarmonyTitle => 'Estudio de armonía';

  @override
  String get studyHarmonySubtitle =>
      'Trabaje a través de un centro de armonía estructurado con entradas rápidas de lecciones y progreso de capítulos.';

  @override
  String get studyHarmonyPlaceholderTag => 'cubierta de estudio';

  @override
  String get studyHarmonyPlaceholderBody =>
      'Los datos de las lecciones, las indicaciones y las superficies de respuestas ya comparten un flujo de estudio reutilizable para notas, acordes, escalas y ejercicios de progresión.';

  @override
  String get studyHarmonyTestLevelTag => 'Ejercicio de practica';

  @override
  String get studyHarmonyTestLevelAction => 'taladro abierto';

  @override
  String get studyHarmonySubmit => 'Entregar';

  @override
  String get studyHarmonyNextPrompt => 'Siguiente mensaje';

  @override
  String get studyHarmonySelectedAnswers => 'Respuestas seleccionadas';

  @override
  String get studyHarmonySelectionEmpty =>
      'Aún no se han seleccionado respuestas.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total correcto';
  }

  @override
  String get studyHarmonyAttempts => 'Intentos';

  @override
  String get studyHarmonyAccuracy => 'Exactitud';

  @override
  String get studyHarmonyElapsedTime => 'Tiempo';

  @override
  String get studyHarmonyObjective => 'Meta';

  @override
  String get studyHarmonyPromptInstruction =>
      'Elige la respuesta correspondiente';

  @override
  String get studyHarmonyNeedSelection =>
      'Elija al menos una respuesta antes de enviar.';

  @override
  String get studyHarmonyCorrectLabel => 'Correcto';

  @override
  String get studyHarmonyIncorrectLabel => 'Incorrecto';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return 'Correcto. $answer fue la respuesta correcta.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return 'Incorrecto. $answer fue la respuesta correcta y perdiste una vida.';
  }

  @override
  String get studyHarmonyGameOverTitle => 'Juego terminado';

  @override
  String get studyHarmonyGameOverBody =>
      'Las tres vidas se han ido. Vuelva a intentar este nivel o regrese al centro Estudio de armonía.';

  @override
  String get studyHarmonyLevelCompleteTitle => 'Nivel superado';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'Has alcanzado el objetivo de la lección. Verifique su precisión y tiempo claro a continuación.';

  @override
  String get studyHarmonyBackToHub => 'Volver a Estudio de armonía';

  @override
  String get studyHarmonyRetry => 'Rever';

  @override
  String get studyHarmonyHubHeroEyebrow => 'Centro de estudios';

  @override
  String get studyHarmonyHubHeroBody =>
      'Utilice Continuar para retomar el impulso, Revisar para volver a visitar los puntos débiles y Diariamente para obtener una lección determinista de su camino desbloqueado.';

  @override
  String get studyHarmonyTrackFilterLabel => 'Rutas';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Base';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Clásica';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return 'Capítulos $cleared/$total completados';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return 'Habilidades $mastered/$total dominadas';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count revisiones listas';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'Racha x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count se ejecuta';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'Mejor $rank';
  }

  @override
  String get studyHarmonyBossTag => 'Jefe';

  @override
  String get studyHarmonyContinueCardTitle => 'Continuar';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Reanude la lección que tocó más recientemente.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Salta a la siguiente lección de tu frontera actual.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return 'Continuar: $lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => 'Continuar';

  @override
  String get studyHarmonyReviewCardTitle => 'Repaso';

  @override
  String get studyHarmonyReviewQueueHint => 'Sale de tu cola de repaso actual.';

  @override
  String get studyHarmonyReviewWeakHint =>
      'Sale del resultado más flojo entre tus lecciones jugadas.';

  @override
  String get studyHarmonyReviewFallbackHint =>
      'Aún no hay deuda de repaso, así que volvemos a tu frontera actual.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      'Esta lección pide otro intento tras un fallo o una sesión sin cerrar.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      'Esta lección está en cola para un repaso rápido de precisión.';

  @override
  String get studyHarmonyReviewAction => 'Repasar';

  @override
  String get studyHarmonyDailyCardTitle => 'Desafío diario';

  @override
  String get studyHarmonyDailyCardHint =>
      'Abra la selección determinista de hoy de sus lecciones desbloqueadas.';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      'La diaria de hoy ya está superada. Si quieres, vuelve a jugarla, o regresa mañana para cuidar la racha.';

  @override
  String get studyHarmonyDailyAction => 'Jugar diaria';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Semilla $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => 'Borrado diariamente hoy';

  @override
  String get studyHarmonyReviewSessionTitle => 'Revisión de puntos débiles';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return 'Combine una breve reseña sobre $chapterTitle y sus habilidades recientes más débiles.';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'Desafío diario';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return 'Juega la mezcla inicial de hoy creada a partir de $chapterTitle y tu frontera actual.';
  }

  @override
  String get studyHarmonyModeLesson => 'Modo de lección';

  @override
  String get studyHarmonyModeReview => 'Modo de revisión';

  @override
  String get studyHarmonyModeDaily => 'Modo diario';

  @override
  String get studyHarmonyModeLegacy => 'Modo de práctica';

  @override
  String get studyHarmonyShortcutHint =>
      'Ingrese envíos o continúe. R se reinicia. 1-9 elige una respuesta. Tab y Shift+Tab mueven el foco.';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$remaining de $total vidas restantes';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'Ganancias de habilidades';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Enfoque de revisión';

  @override
  String get studyHarmonyResultRewardTitle => 'Recompensa de sesión';

  @override
  String get studyHarmonyBonusGoalsTitle => 'Objetivos de bonificación';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'Rango $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return 'Mejores estrellas $rank · $stars';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return 'Racha diaria x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => 'Nueva marca personal';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded =>
      'Motivo de la revisión: es necesario volver a intentarlo';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh =>
      'Motivo de la revisión: actualización de precisión';

  @override
  String get studyHarmonyReviewReasonLowMastery =>
      'Motivo de la revisión: bajo dominio';

  @override
  String get studyHarmonyReviewReasonStaleSkill =>
      'Motivo de la revisión: habilidad obsoleta';

  @override
  String get studyHarmonyReviewReasonWeakSpot =>
      'Motivo de la revisión: punto débil';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh =>
      'Motivo de la revisión: actualización de frontera';

  @override
  String get studyHarmonyQuestBoardTitle => 'Tablero de misiones';

  @override
  String get studyHarmonyQuestCompletedTag => 'Terminado';

  @override
  String get studyHarmonyQuestTodayTag => 'Hoy';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target completo';
  }

  @override
  String get studyHarmonyQuestDailyTitle => 'Racha diaria';

  @override
  String get studyHarmonyQuestDailyBody =>
      'Completa la mezcla sembrada de hoy para alargar tu racha.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      'La diaria de hoy ya está completada. La racha está a salvo por ahora.';

  @override
  String get studyHarmonyQuestFrontierTitle => 'Empuje fronterizo';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return 'Supera $lessonTitle para empujar la ruta hacia delante.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'Ya superaste todas las lecciones desbloqueadas por ahora. Repite un jefe o ve por más estrellas.';

  @override
  String get studyHarmonyQuestStarsTitle => 'caza de estrellas';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return 'Empuja estrellas adicionales dentro de $chapterTitle.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback =>
      'Empuja estrellas adicionales en tu capítulo actual.';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'Combinado x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'Mejor combinación x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'Mantenga todos los corazones';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return 'Alcance $percent% de precisión';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'Alcanza el combo x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'barrido de bonificación';

  @override
  String get studyHarmonySkillNoteRead => 'Lectura de notas';

  @override
  String get studyHarmonySkillNoteFindKeyboard =>
      'Búsqueda de notas del teclado';

  @override
  String get studyHarmonySkillNoteAccidentals => 'Sostenidos y bemoles';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'Símbolo de acorde a teclas';

  @override
  String get studyHarmonySkillChordNameFromTones => 'Nomenclatura de acordes';

  @override
  String get studyHarmonySkillScaleBuild => 'Construcción a escala';

  @override
  String get studyHarmonySkillRomanRealize => 'Realización de número romano';

  @override
  String get studyHarmonySkillRomanIdentify => 'Identificación número romano';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'diatonicidad';

  @override
  String get studyHarmonySkillHarmonyFunction =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonySkillProgressionKeyCenter => 'Progresión centro tonal';

  @override
  String get studyHarmonySkillProgressionFunction =>
      'Lectura de la función de progresión';

  @override
  String get studyHarmonySkillProgressionNonDiatonic =>
      'Detección de progresión no diatónico';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'Relleno de progresión';

  @override
  String get studyHarmonyHubChapterSectionTitle => 'Capítulos';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return 'Lecciones $count';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count borrado';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'capitulo abierto';

  @override
  String get studyHarmonyLockedChapterTag => 'Capítulo bloqueado';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return 'Siguiente: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return 'Esta pista todavía está bloqueada. Vuelve a $coreTrack para seguir estudiando hoy.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Ruta base';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Comience con notas y el teclado, luego avance a través de acordes, escalas, conceptos básicos de número romano, diatónico y análisis de progresión breve.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Capítulo 1: Notas y teclado';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Asigne nombres de notas al teclado y siéntase cómodo con las teclas blancas y las alteraciones simples.';

  @override
  String get studyHarmonyChapterChordsTitle =>
      'Capítulo 2: Conceptos básicos de acordes';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Deletrea tríadas y séptimas básicas, luego nombra formas de acordes comunes a partir de sus tonos.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Capítulo 3: Escalas y claves';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Construya escalas mayores y menores, luego determine qué tonos pertenecen dentro de una clave.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Capítulo 4: Números romanos y diatonicidad';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Convierta número romano simples en acordes, identifíquelos a partir de acordes y ordene los conceptos básicos de diatónico por función.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Capítulo 5: Detective de progresión I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      'Lea progresiones básicas breves, encuentre el centro tonal probable y detecte la función de acorde o alguna extraña.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Capítulo 6: Acorde faltante I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      'Llene un espacio en blanco dentro de una breve progresión y aprenda hacia dónde quieren ir la cadencia y la función a continuación.';

  @override
  String get studyHarmonyOpenLessonAction => 'Abrir lección';

  @override
  String get studyHarmonyLockedLessonAction => 'Bloqueado';

  @override
  String get studyHarmonyClearedTag => 'Superada';

  @override
  String get studyHarmonyComingSoonTag => 'Próximamente';

  @override
  String get studyHarmonyPopTrackTitle => 'Ruta pop';

  @override
  String get studyHarmonyPopTrackDescription =>
      'Recorre toda la ruta de armonía en una vía pop con su propio progreso, elección diaria y cola de repaso.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Ruta de jazz';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practica todo el plan de estudios en una vía jazz con progreso, elección diaria y cola de repaso separados.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Ruta clásica';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Estudia todo el plan de estudios en una vía clásica con progreso, elección diaria y cola de repaso independientes.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Práctica rápida';

  @override
  String get studyHarmonyObjectiveBossReview => 'Repaso de jefe';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle =>
      'Búsqueda de notas de tecla blanca';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Lea los nombres de las notas y toque la tecla blanca correspondiente.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Nombra la nota resaltada';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Mire una tecla resaltada y elija el nombre de nota correcto.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle =>
      'Llaves negras y gemelos';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Eche un primer vistazo a la ortografía aguda y plana de las teclas negras.';

  @override
  String get studyHarmonyLessonNotesBossTitle =>
      'Jefe: Búsqueda rápida de notas';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mezcle la lectura de notas y la búsqueda de teclado en una ronda corta y rápida.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Tríadas en el teclado';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Cree tríadas comunes mayores, menores y disminuidas directamente en el teclado.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => 'Séptimas en el teclado';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Agrega la séptima y deletrea algunos acordes de séptima comunes en el teclado.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Nombra el acorde resaltado';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Lea una forma de acorde resaltada y elija el nombre del acorde correcto.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Jefe: Revisión de tríadas y séptimas';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Cambie entre la ortografía y la denominación de acordes en una revisión mixta.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Construir escalas mayores';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Elija cada tono que pertenezca a una escala mayor simple.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Construir escalas menores';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Construya escalas menores naturales y menores armónicas a partir de algunas tonalidades comunes.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Membresía clave';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Encuentre qué tonos pertenecen dentro de una clave con nombre.';

  @override
  String get studyHarmonyLessonScalesBossTitle =>
      'Jefe: Reparación de básculas';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Combine construcción de escala y membresía clave en una breve ronda de reparación.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Romano a acorde';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Lea una clave y número romano, luego elija el acorde correspondiente.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Acorde a romano';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Lea un acorde dentro de una clave y elija el número romano correspondiente.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatónico o no';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Ordene acordes en respuestas diatónico y no diatónico en claves simples.';

  @override
  String get studyHarmonyLessonFunctionTitle =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Clasifica los acordes fáciles como tónicos, predominante o dominantes.';

  @override
  String get studyHarmonyLessonRomanBossTitle =>
      'Jefe: Mezcla de conceptos básicos funcionales';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Revise romano a acorde, acorde a romano, diatónicoity y funcionen juntos.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle =>
      'Encuentra el centro clave';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      'Lea una breve progresión y elija el centro tonal que tenga más sentido.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle =>
      'Función en contexto';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      'Concéntrate en un acorde resaltado y nombra su función dentro de una progresión corta.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle =>
      'Encuentra al forastero';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'Localice el único acorde que queda fuera de la lectura principal diatónico.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Jefe: Análisis Mixto';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'Combine lectura del centro de claves, detección de funciones y detección de no diatónico en una breve ronda de detectives.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle =>
      'Completa el acorde que falta';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'Complete una breve progresión de cuatro acordes eligiendo el acorde que mejor se adapte a la función local.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle =>
      'Relleno de cadencia';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'Utilice la atracción hacia una cadencia para elegir el acorde que falta cerca del final de una frase.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Jefe: relleno mixto';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'Resuelva un breve conjunto de preguntas de progresión para completar con un poco más de presión armónica.';

  @override
  String get studyHarmonyChapterCheckpointTitle =>
      'Guantelete de punto de control';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'Combine ejercicios de centro de clave, función, color y relleno en conjuntos de revisión mixtos más rápidos.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle =>
      'Acometida de cadencia';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      'Lea rápidamente la función armónica y luego conecte el acorde cadencial que falta ejerciendo una ligera presión.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle =>
      'Cambio de color y clave';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'Cambie entre detección central y llamadas de color no diatónico sin perder el hilo.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle =>
      'Jefe: Guantelete del punto de control';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'Borre un punto de control integrado que combina indicaciones de reparación de centro de clave, función, color y cadencia.';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'Pruebas finales';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'Termine el camino principal con rondas de progresión mixta más difíciles que requieren velocidad, audición de colores y opciones de resolución limpia.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'Relevo de respuesta';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'Cambie entre lectura de funciones y reparación de acordes faltantes mediante cambios compactos.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle =>
      'Llamadas de colores prestados';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'Capte el color modal rápidamente y luego confirme el centro tonal antes de que desaparezca.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle =>
      'Laboratorio de resolución';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      'Realice un seguimiento de dónde quiere aterrizar cada frase y elija el acorde que mejor resuelva el movimiento.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle =>
      'Jefe: Examen de progresión final';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'Apruebe un examen final mixto con centro, función, color y resolución, todo bajo presión.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Encuentra $note en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      '¿Qué nota está resaltada?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Construya $chord en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      '¿Qué acorde está resaltado?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Elige cada nota en $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Elige las notas que pertenecen a $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'En $keyName, ¿qué acorde coincide con $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'En $keyName, ¿qué número romano coincide con $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'En $keyName, ¿$chord es diatónico?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'En $keyName, ¿qué función tiene $chord?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => 'Progresión';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '¿Qué centro tonal se adapta mejor a esta progresión?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '¿Qué función juega $chord aquí?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '¿Qué acorde se siente menos diatónico en esta progresión?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '¿Qué acorde llena mejor el espacio en blanco?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'One likely reading keeps this progression centered on $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can be heard as a $functionLabel chord in this context.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord sits outside the main $keyLabel reading, so it stands out as a plausible non-diatonic color.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can restore some of the expected $functionLabel pull in this progression.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic menor natural';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic armónico menor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic menor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatónico';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'No diatónico';

  @override
  String get studyHarmonyChoiceTonic => 'Tónico';

  @override
  String get studyHarmonyChoicePredominant => 'Predominante';

  @override
  String get studyHarmonyChoiceDominant => 'Dominante';

  @override
  String get studyHarmonyChoiceOther => 'Otro';

  @override
  String get chordAnalyzerTitle => 'Analizador de acordes';

  @override
  String get chordAnalyzerSubtitle =>
      'Pega una progresión para obtener una lectura conservadora de tonalidades probables, números romanos y función armónica.';

  @override
  String get chordAnalyzerInputLabel => 'Progresión de acordes';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Fuera de paréntesis, puedes separar acordes con espacios, | o comas. Las comas dentro de paréntesis se mantienen dentro del mismo acorde.\n\nUsa ? para un hueco de acorde desconocido. El analizador inferirá la opción más natural según el contexto y mostrará alternativas si la lectura es ambigua.\n\nSe admiten fundamentales en minúscula, bajo con barra, formas sus/alt/add y tensiones como C7(b9, #11).\n\nEn dispositivos táctiles puedes usar el pad de acordes o cambiar a la entrada ABC cuando necesites escribir libremente.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Consejos de entrada';

  @override
  String get chordAnalyzerAnalyze => 'Analizar';

  @override
  String get chordAnalyzerKeyboardTitle => 'Pad de acordes';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Toca los tokens para armar una progresión. La entrada ABC mantiene disponible el teclado del sistema cuando necesitas escribir libremente.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Escribe, pega o toca tokens para insertarlos en la posición del cursor.';

  @override
  String get chordAnalyzerChordPad => 'Panel';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => 'Pegar';

  @override
  String get chordAnalyzerClear => 'Reiniciar';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'Espacio';

  @override
  String get chordAnalyzerAnalyzing => 'Analizando progresión...';

  @override
  String get chordAnalyzerInitialTitle => 'Empieza con una progresión';

  @override
  String get chordAnalyzerInitialBody =>
      'Introduce una progresión como Dm7, G7 | ? Am o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos, avisos, rellenos inferidos y un breve resumen.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'Este ? se infirió del contexto armónico circundante, así que tómalo como un relleno sugerido y no como una certeza.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Relleno sugerido: $chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => 'Tonalidades detectadas';

  @override
  String get chordAnalyzerPrimaryReading => 'Lectura principal';

  @override
  String get chordAnalyzerAlternativeReading => 'Lectura alternativa';

  @override
  String get chordAnalyzerChordAnalysis => 'Análisis acorde por acorde';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return 'Compás $index';
  }

  @override
  String get chordAnalyzerProgressionSummary => 'Resumen de la progresión';

  @override
  String get chordAnalyzerWarnings => 'Advertencias y ambigüedades';

  @override
  String get chordAnalyzerNoInputError =>
      'Introduce una progresión de acordes para analizarla.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      'No se encontraron acordes reconocibles en la progresión.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return 'Se omitieron algunos símbolos: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'El centro tonal sigue siendo algo ambiguo entre $primary y $alternative.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'Algunos acordes siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerFunctionTonic => 'Tónica';

  @override
  String get chordAnalyzerFunctionPredominant => 'Predominante';

  @override
  String get chordAnalyzerFunctionDominant => 'Dominante';

  @override
  String get chordAnalyzerFunctionOther => 'Otro';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return 'Posible dominante secundaria dirigida a $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Posible sustitución por tritono dirigida a $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Posible intercambio modal desde el menor paralelo.';

  @override
  String get chordAnalyzerRemarkAmbiguous =>
      'Este acorde sigue siendo ambiguo en la lectura actual.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'Este acorde sigue sin resolverse con las heurísticas conservadoras actuales.';

  @override
  String get chordAnalyzerTagIiVI => 'cadencia ii-V-I';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => 'resolución dominante';

  @override
  String get chordAnalyzerTagPlagalColor => 'color plagal/modal';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'Esta progresión se centra muy probablemente en $key.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return 'Una lectura alternativa es $key.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'Sugiere un $tag.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from y $through se comportan como acordes de $fromFunction y $throughFunction que conducen hacia $target.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord puede oírse como una posible dominante secundaria que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord puede oírse como un posible sustituto por tritono que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord añade un posible color de intercambio modal.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      'Algunos detalles siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerExamplesTitle => 'Ejemplos';

  @override
  String get chordAnalyzerConfidenceLabel => 'Confianza';

  @override
  String get chordAnalyzerAmbiguityLabel => 'Ambigüedad';

  @override
  String get chordAnalyzerWhyThisReading => 'Por qué esta lectura';

  @override
  String get chordAnalyzerCompetingReadings => 'También plausible';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return 'Modificadores ignorados: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => 'Crear variaciones';

  @override
  String get chordAnalyzerVariationsTitle => 'Variaciones naturales';

  @override
  String get chordAnalyzerVariationsBody =>
      'Estas opciones reharmonizan el mismo flujo con sustituciones funcionales cercanas. Aplica una para volver a analizarla al instante.';

  @override
  String get chordAnalyzerApplyVariation => 'Usar variación';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Color cadencial';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Oscurece el predominante y cambia el dominante por un sustituto por tritono sin mover la llegada.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Color backdoor';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Usa el color ivm7-bVII7 del menor paralelo antes de caer en la misma tónica.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'ii-V dirigido';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Construye un ii-V relacionado que sigue apuntando al mismo acorde de destino.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle =>
      'Color de cadencia menor';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Mantiene la cadencia menor, pero se inclina hacia el color iiø-Valt-i.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Realce de color';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Mantiene cercanos la raíz y la función, pero eleva los acordes con extensiones naturales.';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return 'Advertencia de entrada: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      'Los paréntesis desequilibrados dejaron parte del símbolo en duda.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'Se ignoró un paréntesis de cierre inesperado.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'El color explícito de $extension refuerza esta lectura.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'El color de dominante alterada respalda una función dominante.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'El bajo con barra $bass mantiene significativo el movimiento del bajo o la inversión.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'El siguiente acorde respalda una resolución hacia $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'Este color puede oírse como prestado del modo paralelo.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'El color de suspensión suaviza la atracción dominante sin borrarla.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Lectura de baja confianza';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'Las tonalidades candidatas están muy próximas o algunos símbolos solo se recuperaron de forma parcial, así que tómalo como una primera lectura cautelosa.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'Este compás está vacío y se conservó en el conteo.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No se recuperaron símbolos de acorde analizables en este compás.';

  @override
  String get chordAnalyzerParseIssuesTitle => 'Problemas de análisis';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => 'Token vacío.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot =>
      'No se pudo reconocer la fundamental.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root no es una grafía de fundamental admitida.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'El bajo con barra $bass no es una grafía de bajo admitida.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Sufijo o modificador no admitido: $suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

  @override
  String get chordAnalyzerQuickStartHint =>
      'Tap an example to see instant results, or press Ctrl+Enter on desktop to analyze.';

  @override
  String get chordAnalyzerDetailLevel => 'Explanation detail';

  @override
  String get chordAnalyzerDetailLevelConcise => 'Concise';

  @override
  String get chordAnalyzerDetailLevelDetailed => 'Detailed';

  @override
  String get chordAnalyzerDetailLevelAdvanced => 'Advanced';

  @override
  String get chordAnalyzerHighlightTheme => 'Highlight theme';

  @override
  String get chordAnalyzerThemePresetDefault => 'Default';

  @override
  String get chordAnalyzerThemePresetHighContrast => 'High contrast';

  @override
  String get chordAnalyzerThemePresetColorBlindSafe => 'Color-blind safe';

  @override
  String get chordAnalyzerThemePresetCustom => 'Custom';

  @override
  String get chordAnalyzerThemeLegend => 'Category legend';

  @override
  String get chordAnalyzerCustomColors => 'Custom category colors';

  @override
  String get chordAnalyzerHighlightAppliedDominant => 'Applied dominant';

  @override
  String get chordAnalyzerHighlightTritoneSubstitute => 'Tritone substitute';

  @override
  String get chordAnalyzerHighlightTonicization => 'Tonicization';

  @override
  String get chordAnalyzerHighlightModulation => 'Modulation';

  @override
  String get chordAnalyzerHighlightBackdoor => 'Backdoor / subdominant minor';

  @override
  String get chordAnalyzerHighlightBorrowedColor => 'Borrowed color';

  @override
  String get chordAnalyzerHighlightCommonTone => 'Common-tone motion';

  @override
  String get chordAnalyzerHighlightDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerHighlightChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerHighlightAmbiguity => 'Ambiguity';

  @override
  String chordAnalyzerSummaryRealModulation(Object key) {
    return 'It makes a stronger case for a real modulation toward $key.';
  }

  @override
  String chordAnalyzerSummaryTonicization(Object target) {
    return 'It briefly tonicizes $target without fully settling there.';
  }

  @override
  String get chordAnalyzerSummaryBackdoor =>
      'The progression leans into backdoor or subdominant-minor color before resolving.';

  @override
  String get chordAnalyzerSummaryDeceptiveCadence =>
      'One cadence sidesteps the expected tonic for a deceptive effect.';

  @override
  String get chordAnalyzerSummaryChromaticLine =>
      'A chromatic inner-line or line-cliche color helps connect part of the phrase.';

  @override
  String chordAnalyzerSummaryBackdoorDominant(Object chord) {
    return '$chord works like a backdoor dominant rather than a plain borrowed dominant.';
  }

  @override
  String chordAnalyzerSummarySubdominantMinor(Object chord) {
    return '$chord reads more naturally as subdominant-minor color than as a random non-diatonic chord.';
  }

  @override
  String chordAnalyzerSummaryCommonToneDiminished(Object chord) {
    return '$chord can be heard as a common-tone diminished color that resolves by shared pitch content.';
  }

  @override
  String chordAnalyzerSummaryDeceptiveTarget(Object chord) {
    return '$chord participates in a deceptive landing instead of a plain authentic cadence.';
  }

  @override
  String chordAnalyzerSummaryCompeting(Object readings) {
    return 'An advanced reading keeps competing interpretations in play, such as $readings.';
  }

  @override
  String chordAnalyzerFunctionLine(Object function) {
    return 'Function: $function';
  }

  @override
  String chordAnalyzerEvidenceLead(Object evidence) {
    return 'Evidence: $evidence';
  }

  @override
  String chordAnalyzerAdvancedCompetingReadings(Object readings) {
    return 'Competing readings remain possible here: $readings.';
  }

  @override
  String chordAnalyzerRemarkTonicization(Object target) {
    return 'This sounds more like a local tonicization of $target than a full modulation.';
  }

  @override
  String chordAnalyzerRemarkRealModulation(Object key) {
    return 'This supports a real modulation toward $key.';
  }

  @override
  String get chordAnalyzerRemarkBackdoorDominant =>
      'This can be heard as a backdoor dominant with subdominant-minor color.';

  @override
  String get chordAnalyzerRemarkBackdoorChain =>
      'This belongs to a backdoor chain rather than a plain borrowed detour.';

  @override
  String get chordAnalyzerRemarkSubdominantMinor =>
      'This borrowed iv or subdominant-minor color behaves like a predominant area.';

  @override
  String get chordAnalyzerRemarkCommonToneDiminished =>
      'This diminished chord works through common-tone reinterpretation.';

  @override
  String get chordAnalyzerRemarkPivotChord =>
      'This chord can act as a pivot into the next local key area.';

  @override
  String get chordAnalyzerRemarkCommonToneModulation =>
      'Common-tone continuity helps the modulation feel plausible.';

  @override
  String get chordAnalyzerRemarkDeceptiveCadence =>
      'This points toward a deceptive cadence rather than a direct tonic arrival.';

  @override
  String get chordAnalyzerRemarkLineCliche =>
      'Chromatic inner-line motion colors this chord choice.';

  @override
  String get chordAnalyzerRemarkDualFunction =>
      'More than one functional reading stays credible here.';

  @override
  String get chordAnalyzerTagTonicization => 'Tonicization';

  @override
  String get chordAnalyzerTagRealModulation => 'Real modulation';

  @override
  String get chordAnalyzerTagBackdoorChain => 'Backdoor chain';

  @override
  String get chordAnalyzerTagDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerTagChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerTagCommonToneMotion => 'Common-tone motion';

  @override
  String get chordAnalyzerEvidenceCadentialArrival =>
      'A local cadential arrival supports hearing a temporary target.';

  @override
  String get chordAnalyzerEvidenceFollowThrough =>
      'Follow-through chords continue to support the new local center.';

  @override
  String get chordAnalyzerEvidencePhraseBoundary =>
      'The change lands near a phrase boundary or structural accent.';

  @override
  String get chordAnalyzerEvidencePivotSupport =>
      'A pivot-like shared reading supports the local shift.';

  @override
  String get chordAnalyzerEvidenceCommonToneSupport =>
      'Shared common tones help connect the reinterpretation.';

  @override
  String get chordAnalyzerEvidenceHomeGravityWeakening =>
      'The original tonic loses some of its pull in this window.';

  @override
  String get chordAnalyzerEvidenceBackdoorMotion =>
      'The motion matches a backdoor or subdominant-minor resolution pattern.';

  @override
  String get chordAnalyzerEvidenceDeceptiveResolution =>
      'The dominant resolves away from the expected tonic target.';

  @override
  String chordAnalyzerEvidenceChromaticLine(Object detail) {
    return 'Chromatic line support: $detail.';
  }

  @override
  String chordAnalyzerEvidenceCompetingReading(Object detail) {
    return 'Competing reading: $detail.';
  }

  @override
  String get studyHarmonyDailyReplayAction => 'Repetir diariamente';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'Medallas de hito';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'Medalla del Conquistador';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Borrar lecciones $target en Core Foundations.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'Coleccionista de estrellas';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Recoge estrellas $target en Estudio de armonía.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'Leyenda de la racha';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return 'Alcanza la mejor racha diaria de $target.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => 'Académico de maestría';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return 'Domina las habilidades $target.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return 'Medallas $earned/$total obtenidas';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'Gabinete completo';

  @override
  String get studyHarmonyMilestoneTierBronze => 'Medalla de Bronce';

  @override
  String get studyHarmonyMilestoneTierSilver => 'Medalla de Plata';

  @override
  String get studyHarmonyMilestoneTierGold => 'Medalla de oro';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'Medalla de Platino';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => 'Nuevas medallas';

  @override
  String get studyHarmonyChapterRemixTitle => 'Arena remezclada';

  @override
  String get studyHarmonyChapterRemixDescription =>
      'Conjuntos mixtos más largos que mezclan centro tonal, función y color prestado sin previo aviso.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => 'Constructor de puentes';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'La función de puntada lee y rellena los acordes faltantes en una cadena fluida.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'Pivote de color';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      'Realice un seguimiento del color prestado y de los pivotes centrales clave a medida que la progresión cambia debajo de usted.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => 'Sprint de resolución';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      'Lea la función, el relleno de cadencia y la gravedad tonal consecutivamente a un ritmo más rápido.';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'Maratón de remezclas';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      'Un maratón mixto final que devuelve al conjunto todas las lentes de lectura de progresión.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'Salva racha x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'Coronas de leyenda $count';
  }

  @override
  String get studyHarmonyModeFocus => 'Modo de enfoque';

  @override
  String get studyHarmonyModeLegend => 'Prueba de leyenda';

  @override
  String get studyHarmonyFocusCardTitle => 'Sprint de enfoque';

  @override
  String get studyHarmonyFocusCardHint =>
      'Ataca el punto más débil de tu ruta actual con menos vidas y objetivos más exigentes.';

  @override
  String get studyHarmonyFocusFallbackHint =>
      'Completa un mix más exigente para presionar tus puntos débiles actuales.';

  @override
  String get studyHarmonyFocusAction => 'Iniciar sprint';

  @override
  String get studyHarmonyFocusSessionTitle => 'Sprint de enfoque';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return 'Un sprint mixto más ajustado construido desde los puntos más débiles alrededor de $chapter.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count lecciones mixtas';
  }

  @override
  String get studyHarmonyFocusRewardLabel => 'Recompensa semanal: Salva racha';

  @override
  String get studyHarmonyLegendCardTitle => 'Prueba de leyenda';

  @override
  String get studyHarmonyLegendCardHint =>
      'Repite un capítulo de nivel plata o superior en una sesión de dominio con 2 vidas para asegurar su corona de leyenda.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'Completa un capítulo y súbelo a unas 2 estrellas por lección para desbloquear una prueba de leyenda.';

  @override
  String get studyHarmonyLegendAction => 'Ir por la leyenda';

  @override
  String get studyHarmonyLegendSessionTitle => 'Prueba de leyenda';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return 'Una repetición de dominio sin margen en $chapter, pensada para asegurar su corona de leyenda.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count lecciones encadenadas';
  }

  @override
  String get studyHarmonyLegendRiskLabel =>
      'La corona de leyenda está en juego';

  @override
  String get studyHarmonyWeeklyPlanTitle => 'Plan de entrenamiento semanal';

  @override
  String get studyHarmonyWeeklyRewardLabel => 'Recompensa: Salva racha';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => 'Recompensa lista';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => 'Recompensa reclamada';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => 'Aparecer varios días';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return 'Esté activo en $target diferentes días de esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle =>
      'Mantenga vivo el ciclo diario';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return 'El registro $target se borra diariamente esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle =>
      'Terminar un sprint de concentración';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return 'Completa $target Focus Sprints esta semana.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      'Un Salva racha protegió el día de ayer.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return 'Ganaste un nuevo Salva racha. Inventario: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine =>
      'Sprint de enfoque despejado.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return 'Corona legendaria asegurada para $chapter.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'Escalera bis';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      'Una breve escalera de acabado que comprime todo el conjunto de herramientas de progresión en un conjunto final de bises.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'Pulso tonal';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'Bloquee el centro tonal y funcione sin indicaciones de calentamiento.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'Intercambio de color';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      'Llamadas de colores prestados alternativos con restauración de acordes faltantes para mantener el oído honesto.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'Bis final';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'Una última ronda de jefe compacta que comprueba cada lente de progresión en rápida sucesión.';

  @override
  String get studyHarmonyChapterMasteryBronze => 'Bronce Claro';

  @override
  String get studyHarmonyChapterMasterySilver => 'Corona de plata';

  @override
  String get studyHarmonyChapterMasteryGold => 'corona de oro';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'Corona de leyenda';

  @override
  String get studyHarmonyModeBossRush => 'Modo Boss Rush';

  @override
  String get studyHarmonyBossRushCardTitle => 'Boss Rush';

  @override
  String get studyHarmonyBossRushCardHint =>
      'Encadena las lecciones de jefe desbloqueadas con menos vidas y un umbral de puntuación más alto.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      'Desbloquea al menos dos lecciones de jefe para abrir una Boss Rush mixta de verdad.';

  @override
  String get studyHarmonyBossRushAction => 'Iniciar Boss Rush';

  @override
  String get studyHarmonyBossRushSessionTitle => 'Boss Rush';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return 'Un gauntlet de alta presión construido con las lecciones de jefe desbloqueadas alrededor de $chapter.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count lecciones de jefe mixtas';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => 'Solo 2 vidas';

  @override
  String get studyHarmonyResultBossRushLine => 'Jefe Rush despejado.';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      'Un último conjunto de focos que aísla el color prestado, la presión de la cadencia y la integración a nivel de jefe.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => 'Lente prestada';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      'Realice un seguimiento de centro tonal mientras el color prestado sigue intentando desviar la lectura.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle =>
      'Intercambio de cadencia';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      'Cambia entre lectura de funciones y restauración de cadencia sin perder el punto de aterrizaje.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'Un conjunto de jefes finales que obliga a cada lente de progresión a mantenerse nítida bajo presión.';

  @override
  String get studyHarmonyChapterAfterHoursTitle =>
      'Laboratorio fuera de horario';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'Un laboratorio de finales de juego que elimina pistas de calentamiento y mezcla colores prestados, presión de cadencia y seguimiento central.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'Sombra modal';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      'Mantenga presionado el centro tonal mientras el color prestado sigue arrastrando la lectura hacia la oscuridad.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => 'Finta de resolución';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'Capte las falsificaciones de función y cadencia antes de que la frase pase de su verdadero lugar de aterrizaje.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle =>
      'Fundido cruzado central';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      'Combine la detección del centro, la lectura de funciones y la reparación de cuerdas faltantes sin necesidad de andamios adicionales.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'Jefe de última llamada';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'Un último set de jefe nocturno que pide a cada lente de progresión que se mantenga clara bajo presión.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyModeRelay => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardTitle => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardHint =>
      'Mezcla lecciones desbloqueadas de distintos capítulos en una sola tanda intercalada para poner a prueba tanto el cambio rápido como el recuerdo inmediato.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'Desbloquea al menos dos capítulos para abrir Relevo de arena.';

  @override
  String get studyHarmonyRelayAction => 'Iniciar relevo';

  @override
  String get studyHarmonyRelaySessionTitle => 'Relevo de arena';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return 'Una ejecución de retransmisión entrelazada que mezcla capítulos desbloqueados sobre $chapter.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return 'Lecciones $count transmitidas';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count capítulos mezclados';
  }

  @override
  String get studyHarmonyRelayChainLabel => 'Intercalado bajo presión';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'Corredor de relevos';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return 'Borre las ejecuciones $target Relevo de arena.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'Desvíos de neón';

  @override
  String get studyHarmonyChapterNeonDescription =>
      'Un capítulo del final del juego que sigue cambiando el camino con color prestado, presión de pivote y lecturas de recuperación.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'Desvío modal';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      'Siga el verdadero centro incluso cuando el color prestado sigue empujando la frase a una calle lateral.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'Presión de pivote';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      'Lea los cambios de centro y la presión de función espalda con espalda antes de que el carril armónico cambie nuevamente.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => 'Aterrizaje prestado';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      'Repare la cuerda de aterrizaje que falta después de que una falsificación de color prestado cambie la resolución esperada.';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'Jefe de luces de la ciudad';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'Un jefe de neón final que combina lecturas pivotantes, colores prestados y recuperación de cadencia sin un aterrizaje suave.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return 'Liga $tier';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'Liga de armonía';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return 'Empuja hacia la liga $tier esta semana. El impulso más limpio ahora mismo viene de $mode.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      'Diamante ya está asegurado esta semana. Sigue encadenando superadas de alta presión para mantener el ritmo.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      'Tu ascenso de liga se iluminará una vez que haya una carrera recomendada para impulsar esta semana.';

  @override
  String get studyHarmonyLeagueAction => 'Subir de liga';

  @override
  String get studyHarmonyHubStartHereTitle => 'Start Here';

  @override
  String get studyHarmonyHubNextLessonTitle => 'Next Lesson';

  @override
  String get studyHarmonyHubWhyItMattersTitle => 'Why It Matters';

  @override
  String get studyHarmonyHubQuickPracticeTitle => 'Quick Practice';

  @override
  String get studyHarmonyHubMetaPreviewTitle => 'More Opens Soon';

  @override
  String get studyHarmonyHubMetaPreviewHeadline =>
      'Build a little momentum first';

  @override
  String get studyHarmonyHubMetaPreviewBody =>
      'League, shop, and reward systems open up more fully after a few clears. For now, finish your next lesson and one quick practice run.';

  @override
  String get studyHarmonyHubPlayNowAction => 'Play Now';

  @override
  String get studyHarmonyHubKeepMomentumAction => 'Keep Momentum';

  @override
  String get studyHarmonyClearTitleAction => 'Clear title';

  @override
  String get studyHarmonyPlayerDeckTitle => 'Player Deck';

  @override
  String get studyHarmonyPlayerDeckCardTitle => 'Playstyle';

  @override
  String get studyHarmonyPlayerDeckOverviewAction => 'Overview';

  @override
  String get studyHarmonyRunDirectorTitle => 'Run Director';

  @override
  String get studyHarmonyRunDirectorAction => 'Play Recommended';

  @override
  String get studyHarmonyGameEconomyTitle => 'Game Economy';

  @override
  String get studyHarmonyGameEconomyBody =>
      'Shop stock, utility tokens, and meta items all react to your recent run history.';

  @override
  String studyHarmonyGameEconomyTitlesOwned(int count) {
    return '$count titles owned';
  }

  @override
  String studyHarmonyGameEconomyCosmeticsOwned(int count) {
    return '$count cosmetics owned';
  }

  @override
  String studyHarmonyGameEconomyShopPurchases(int count) {
    return '$count shop purchases';
  }

  @override
  String get studyHarmonyGameEconomyWalletAction => 'View Wallet';

  @override
  String get studyHarmonyArcadeSpotlightTitle => 'Arcade Spotlight';

  @override
  String get studyHarmonyArcadePlayAction => 'Play Arcade';

  @override
  String studyHarmonyArcadeModeCount(int count) {
    return '$count modes';
  }

  @override
  String get studyHarmonyArcadePlaylistAction => 'Play Set';

  @override
  String get studyHarmonyNightMarketTitle => 'Night Market';

  @override
  String studyHarmonyPurchaseSuccess(Object itemTitle) {
    return 'Purchased $itemTitle';
  }

  @override
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle) {
    return 'Purchased and equipped $itemTitle';
  }

  @override
  String studyHarmonyPurchaseFailure(Object itemTitle) {
    return 'Cannot purchase $itemTitle yet';
  }

  @override
  String studyHarmonyRewardEquipped(Object itemTitle) {
    return 'Equipped $itemTitle';
  }

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score XP esta semana';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target XP esta semana';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return 'Siguiente: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return 'Mejor impulso: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'XP de liga +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return 'Ascendido a la liga $tier';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'Novato';

  @override
  String get studyHarmonyLeagueTierBronze => 'Bronce';

  @override
  String get studyHarmonyLeagueTierSilver => 'Plata';

  @override
  String get studyHarmonyLeagueTierGold => 'Oro';

  @override
  String get studyHarmonyLeagueTierDiamond => 'Diamante';

  @override
  String get studyHarmonyChapterMidnightTitle => 'Central de medianoche';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      'Un capítulo final de sala de control que obliga a lecturas rápidas a través de centros a la deriva, cadencias falsas y desvíos prestados.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'Deriva de señal';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      'Siga la verdadera señal tonal incluso mientras la superficie sigue adoptando un color prestado.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => 'Línea engañosa';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      'Lea la presión de la función a través de resoluciones falsas antes de que la línea vuelva a colocarse en su lugar.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => 'Desvío prestado';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      'Recupera el aterrizaje esperado después de que el color prestado desvía la frase a mitad de camino.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'Jefe del apagón';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      'Un conjunto de oscurecimiento final que combina todos los lentes del juego tardío sin brindarte un reinicio seguro.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'Cofres de misiones $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x XP de liga x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'Cofre de misiones';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count misiones restantes';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'Cofre de misiones listo';

  @override
  String get studyHarmonyQuestChestOpenedHeadline =>
      'Cofre de misiones abierto';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x Liga XP en vivo';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return 'Recompensa: +$xp liga XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      'Completa el trío de misiones de hoy para abrir el cofre extra y sostener el ascenso semanal.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      'Las tres misiones de hoy ya están hechas. Supera una partida más para cobrar el bono del cofre.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      'El trío de hoy está completo y la bonificación del cofre ya se ha convertido en XP de liga.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return 'El cofre de hoy ya está abierto y el 2x de XP de liga se aplica a tus próximas $count superadas.';
  }

  @override
  String get studyHarmonyQuestChestAction => 'Terminar trío';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'Mejor remate: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'Misiones diarias $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'Se abrió Cofre de misiones.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'Bonificación Cofre de misiones + XP de liga $count';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '2x de XP de liga listo para tus próximas $count superadas';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'Bono de impulso +$count de XP de liga';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return 'El impulso 2x se borra a la izquierda $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return 'Tienes 2x de XP de liga durante las próximas $count superadas. Aprovéchalo en $mode mientras dure el impulso.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'Circuito del horizonte';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'Un circuito final del horizonte que obliga a lecturas rápidas y mixtas a través de centros fantasmas, gravedad prestada y casas falsas.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => 'Pulso residual';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'Capte el centro y funcione en la imagen residual antes de que la frase se bloquee en un nuevo carril.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => 'Cambio de gravedad';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      'Maneja la gravedad prestada y repara los acordes faltantes mientras la progresión sigue cambiando su peso.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => 'Falsa llegada';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      'Lea la llegada falsa y reconstruya el aterrizaje real antes de que la progresión se cierre de golpe.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => 'Jefe de la señal final';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'Un último jefe del horizonte que encadena cada lente de progresión del juego tardío en una prueba de señal de cierre.';

  @override
  String get studyHarmonyChapterAfterglowTitle => 'Pista del resplandor';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'Una pista cerrada de decisiones divididas, cebo prestado y centros parpadeantes que recompensa lecturas limpias al final del juego bajo presión.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => 'Decisión dividida';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'Elija el acorde de reparación que mantenga la función en movimiento sin permitir que la frase se desvíe de su curso.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => 'Señuelo prestado';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      'Encuentra el acorde de color prestado que parece un pivote antes de que la progresión regrese a casa.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => 'Parpadeo del centro';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'Mantén el centro tonal mientras las señales de cadencia parpadean y se desvían en rápida sucesión.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle =>
      'Jefe de retorno de línea roja';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'Una prueba final mixta de centro tonal, función, color prestado y reparación de acordes faltantes a toda velocidad.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'Tour mensual autorizado';

  @override
  String get studyHarmonyTourTitle => 'Tour de armonía';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'Listo el final de la gira';

  @override
  String get studyHarmonyTourClaimedHeadline => 'Tour mensual autorizado';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return 'Recompensa: +$xp de XP de liga y $count Salva racha';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return 'Aparece en $target días distintos este mes para asegurar el bono del tour.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return 'Abre $target cofres de misiones este mes para que el cuaderno del tour siga avanzando.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return 'Supera $target retos destacados este mes. Cuentan Boss Rush, Relevo de arena, Sprint de enfoque, Prueba de leyenda y las lecciones de jefe.';
  }

  @override
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

  @override
  String get studyHarmonyTourReadyBody =>
      'Ya reuniste todos los sellos del mes. Una partida más completada asegura el bono del tour.';

  @override
  String get studyHarmonyTourClaimedBody =>
      'La gira de este mes está completa. Mantén el ritmo fuerte para que la ruta del próximo mes empiece caliente.';

  @override
  String get studyHarmonyTourAction => 'recorrido anticipado';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return 'Días activos $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Cofre de misioness $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Focos $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Tour de armonía completo';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'Bono de gira +$count XP de liga';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Reserva de Salva racha $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => 'Frecuencia del amanecer';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'Un bis al amanecer de cadencias fantasmales, giros falsos del amanecer y flores prestadas que obliga a lecturas limpias al final del juego después de una larga carrera.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => 'Cadencia fantasma';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'Repara la cadencia y funciona al mismo tiempo cuando la frase pretende cerrarse sin llegar a aterrizar.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => 'Falso amanecer';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      'Capte el cambio central escondido dentro de un amanecer demasiado temprano antes de que la progresión se aleje nuevamente.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => 'Brote prestado';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      'Realice un seguimiento del color prestado y funcionen juntos mientras la armonía se abre hacia un carril más brillante pero inestable.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle =>
      'Jefe de sobremarcha del amanecer';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'Un jefe final a la velocidad del amanecer que encadena centro tonal, función, color no diatónico y reparación de acordes faltantes en un último conjunto de sobremarcha.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'Pacto a dúo';

  @override
  String get studyHarmonyDuetStartHeadline => 'Empieza el dueto de hoy.';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return 'Dueto bloqueado por el día $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return 'Recompensa: +$xp de XP de liga en rachas clave';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'Primero completa la diaria de hoy y luego supera un reto destacado para mantener vivo el pacto a dúo.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Lo diario está de moda. Termina una carrera destacada como Focus, Relay, Boss Rush, Legend o una lección de jefe para sellar el dúo.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return 'El dúo de hoy ya quedó sellado y la racha compartida va en $count días.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Diariamente en';

  @override
  String get studyHarmonyDuetDailyMissing => 'Falta diaria';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Foco en';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Falta foco';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return 'Diario $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'Foco $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'Racha $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'Sigue el dueto';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'Recompensa de dúo +$count XP de liga';
  }

  @override
  String get studyHarmonySolfegeDo => 'Do';

  @override
  String get studyHarmonySolfegeRe => 'Re';

  @override
  String get studyHarmonySolfegeMi => 'Mi';

  @override
  String get studyHarmonySolfegeFa => 'Fa';

  @override
  String get studyHarmonySolfegeSol => 'Sol';

  @override
  String get studyHarmonySolfegeLa => 'La';

  @override
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle =>
      'Prototipo de Estudio de armonía';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Niveles heredados del prototipo integrados en el sistema de lecciones.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Lecciones prototipo';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Lecciones temporales conservadas mientras se incorpora el sistema de estudio ampliable.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Supera 10 respuestas correctas antes de perder las 3 vidas';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Nivel prototipo 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'Un calentamiento básico para distinguir solo Do, Mi y Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Nivel prototipo 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'Un nivel intermedio para acelerar el reconocimiento de Do, Re, Mi, Sol y La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Nivel prototipo 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'Una prueba de octava completa que recorre toda la serie Do-Re-Mi-Fa-Sol-La-Si-Do.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (C grave)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (C agudo)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Plantilla';

  @override
  String get studyHarmonyChapterBlueHourTitle => 'Cruce de la hora azul';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      'Un bis crepuscular de corrientes cruzadas, préstamos con halo y horizontes duales que mantienen inestables las lecturas tardías del juego de la mejor manera.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => 'Corriente cruzada';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'Siga centro tonal y funcione mientras la progresión comienza a moverse en dos direcciones a la vez.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => 'Halo prestado';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      'Lea el color prestado y restablezca el acorde que falta antes de que la frase se vuelva confusa.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => 'Horizonte doble';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      'Mantenga el punto de llegada real mientras dos posibles horizontes siguen apareciendo y desapareciendo.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'Jefe de linternas gemelas';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'Un jefe final de hora azul que obliga a cambios rápidos entre el centro, la función, el color prestado y la reparación de acordes faltantes.';

  @override
  String get anchorLoopTitle => 'Anchor Loop';

  @override
  String get anchorLoopHelp =>
      'Fix specific cycle slots so the same chord returns every cycle while the other slots can still be generated around it.';

  @override
  String get anchorLoopCycleLength => 'Cycle Length (bars)';

  @override
  String get anchorLoopCycleLengthHelp =>
      'Choose how many bars the repeating anchor cycle lasts.';

  @override
  String get anchorLoopVaryNonAnchorSlots => 'Vary non-anchor slots';

  @override
  String get anchorLoopVaryNonAnchorSlotsHelp =>
      'Keep anchor slots exact while letting the generated filler vary inside the same local function.';

  @override
  String anchorLoopBarLabel(int bar) {
    return 'Bar $bar';
  }

  @override
  String anchorLoopBeatLabel(int beat) {
    return 'Beat $beat';
  }

  @override
  String get anchorLoopSlotEmpty => 'No anchor chord set';

  @override
  String anchorLoopEditTitle(int bar, int beat) {
    return 'Edit anchor for bar $bar, beat $beat';
  }

  @override
  String get anchorLoopChordSymbol => 'Anchor chord symbol';

  @override
  String get anchorLoopChordHint =>
      'Enter one chord symbol for this slot. Leave it empty to clear the anchor.';

  @override
  String get anchorLoopInvalidChord =>
      'Enter a supported chord symbol before saving this anchor slot.';

  @override
  String get harmonyPlaybackPatternBlock => 'Block';

  @override
  String get harmonyPlaybackPatternArpeggio => 'Arpeggio';

  @override
  String get metronomeBeatStateNormal => 'Normal';

  @override
  String get metronomeBeatStateAccent => 'Accent';

  @override
  String get metronomeBeatStateMute => 'Mute';

  @override
  String get metronomePatternPresetCustom => 'Custom';

  @override
  String get metronomePatternPresetMeterAccent => 'Meter accent';

  @override
  String get metronomePatternPresetJazzTwoAndFour => 'Jazz 2 & 4';

  @override
  String get metronomeSourceKindBuiltIn => 'Built-in asset';

  @override
  String get metronomeSourceKindLocalFile => 'Local file';

  @override
  String get transportAudioTitle => 'Transport Audio';

  @override
  String get autoPlayChordChanges => 'Auto-play chord changes';

  @override
  String get autoPlayChordChangesHelp =>
      'Play the next chord automatically when the transport reaches a chord-change event.';

  @override
  String get autoPlayPattern => 'Auto-play pattern';

  @override
  String get autoPlayPatternHelp =>
      'Choose whether auto-play uses a block chord or a short arpeggio.';

  @override
  String get autoPlayHoldFactor => 'Auto-play hold length';

  @override
  String get autoPlayHoldFactorHelp =>
      'Scale how long auto-played chord changes ring relative to the event duration.';

  @override
  String get autoPlayMelodyWithChords => 'Play melody with chords';

  @override
  String get autoPlayMelodyWithChordsPlaceholder =>
      'When melody generation is enabled, include the current melody line in auto-play chord-change previews.';

  @override
  String get melodyGenerationTitle => 'Melody line';

  @override
  String get melodyGenerationHelp =>
      'Generate a simple performance-ready melody that follows the current chord timeline.';

  @override
  String get melodyDensity => 'Melody density';

  @override
  String get melodyDensityHelp =>
      'Choose how many melody notes tend to appear inside each chord event.';

  @override
  String get melodyDensitySparse => 'Sparse';

  @override
  String get melodyDensityBalanced => 'Balanced';

  @override
  String get melodyDensityActive => 'Active';

  @override
  String get motifRepetitionStrength => 'Motif repetition';

  @override
  String get motifRepetitionStrengthHelp =>
      'Higher values keep the contour identity of recent melody fragments more often.';

  @override
  String get approachToneDensity => 'Approach tone density';

  @override
  String get approachToneDensityHelp =>
      'Control how often passing, neighbor, and approach gestures appear before arrivals.';

  @override
  String get melodyRangeLow => 'Melody range low';

  @override
  String get melodyRangeHigh => 'Melody range high';

  @override
  String get melodyRangeHelp =>
      'Keep generated melody notes inside this playable register window.';

  @override
  String get melodyStyle => 'Melody style';

  @override
  String get melodyStyleHelp =>
      'Bias the line toward safer guide tones, bebop motion, lyrical space, or colorful tensions.';

  @override
  String get melodyStyleSafe => 'Safe';

  @override
  String get melodyStyleBebop => 'Bebop';

  @override
  String get melodyStyleLyrical => 'Lyrical';

  @override
  String get melodyStyleColorful => 'Colorful';

  @override
  String get allowChromaticApproaches => 'Allow chromatic approaches';

  @override
  String get allowChromaticApproachesHelp =>
      'Permit enclosures and chromatic approach notes on weak beats when the style allows it.';

  @override
  String get melodyPlaybackMode => 'Melody playback';

  @override
  String get melodyPlaybackModeHelp =>
      'Choose whether manual preview buttons play chords, melody, or both together.';

  @override
  String get melodyPlaybackModeChordsOnly => 'Chords only';

  @override
  String get melodyPlaybackModeMelodyOnly => 'Melody only';

  @override
  String get melodyPlaybackModeBoth => 'Both';

  @override
  String get regenerateMelody => 'Regenerate melody';

  @override
  String get melodyPreviewCurrent => 'Current line';

  @override
  String get melodyPreviewNext => 'Next arrival';

  @override
  String get metronomePatternTitle => 'Metronome Pattern';

  @override
  String get metronomePatternHelp =>
      'Choose a meter-aware click pattern or define each beat manually.';

  @override
  String get metronomeUseAccentSound => 'Use separate accent sound';

  @override
  String get metronomeUseAccentSoundHelp =>
      'Use a different click source for accented beats instead of only raising the gain.';

  @override
  String get metronomePrimarySource => 'Primary click source';

  @override
  String get metronomeAccentSource => 'Accent click source';

  @override
  String get metronomeSourceKind => 'Source type';

  @override
  String get metronomeLocalFilePath => 'Local file path';

  @override
  String get metronomeLocalFilePathHelp =>
      'Paste a local audio file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeCustomSoundHelp =>
      'Upload your own metronome click. The app stores a private copy and keeps the built-in sound as fallback.';

  @override
  String get metronomeCustomSoundStatusBuiltIn =>
      'Currently using a built-in sound.';

  @override
  String metronomeCustomSoundStatusFile(Object fileName) {
    return 'Custom file: $fileName';
  }

  @override
  String get metronomeCustomSoundUpload => 'Upload custom sound';

  @override
  String get metronomeCustomSoundReplace => 'Replace custom sound';

  @override
  String get metronomeCustomSoundReset => 'Use built-in sound';

  @override
  String get metronomeCustomSoundUploadSuccess =>
      'Custom metronome sound saved.';

  @override
  String get metronomeCustomSoundResetSuccess =>
      'Switched back to the built-in metronome sound.';

  @override
  String get metronomeCustomSoundUploadError =>
      'Couldn\'t save the selected metronome audio file.';

  @override
  String get harmonySoundTitle => 'Harmony Sound';

  @override
  String get harmonyMasterVolume => 'Master volume';

  @override
  String get harmonyMasterVolumeHelp =>
      'Overall harmony preview loudness for manual and automatic chord playback.';

  @override
  String get harmonyPreviewHoldFactor => 'Chord hold length';

  @override
  String get harmonyPreviewHoldFactorHelp =>
      'Scale how long previewed chords and notes sustain.';

  @override
  String get harmonyArpeggioStepSpeed => 'Arpeggio step speed';

  @override
  String get harmonyArpeggioStepSpeedHelp =>
      'Control how quickly arpeggiated notes step forward.';

  @override
  String get harmonyVelocityHumanization => 'Velocity humanization';

  @override
  String get harmonyVelocityHumanizationHelp =>
      'Add small velocity variation so repeated previews feel less mechanical.';

  @override
  String get harmonyGainRandomness => 'Gain randomness';

  @override
  String get harmonyGainRandomnessHelp =>
      'Add slight per-note loudness variation on supported playback paths.';

  @override
  String get harmonyTimingHumanization => 'Timing humanization';

  @override
  String get harmonyTimingHumanizationHelp =>
      'Slightly loosen simultaneous note attacks for a less rigid block chord.';

  @override
  String get harmonySoundProfileSelectionTitle => 'Sound profile mode';

  @override
  String get harmonySoundProfileSelectionHelp =>
      'Elige un sonido equilibrado por defecto o fija un carácter de reproducción para practicar pop, jazz o clásico.';

  @override
  String get harmonySoundProfileSelectionNeutral => 'Neutral shared piano';

  @override
  String get harmonySoundProfileSelectionTrackAware => 'Track-aware';

  @override
  String get harmonySoundProfileSelectionPop => 'Pop profile';

  @override
  String get harmonySoundProfileSelectionJazz => 'Jazz profile';

  @override
  String get harmonySoundProfileSelectionClassical => 'Classical profile';

  @override
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern) {
    return 'Instrument: $instrument. Recommended preview: $pattern.';
  }

  @override
  String get harmonySoundProfileTrackAwareFallback =>
      'In free practice this stays on the shared piano profile. Study Harmony sessions switch to the active track\'s sound shaping.';

  @override
  String get harmonySoundProfileNeutralLabel => 'Balanced / shared piano';

  @override
  String get harmonySoundProfileNeutralSummary =>
      'Use the shared piano asset with a steady, all-purpose preview shape.';

  @override
  String get harmonySoundTagBalanced => 'balanced';

  @override
  String get harmonySoundTagPiano => 'piano';

  @override
  String get harmonySoundTagSoft => 'soft';

  @override
  String get harmonySoundTagOpen => 'open';

  @override
  String get harmonySoundTagModern => 'modern';

  @override
  String get harmonySoundTagDry => 'dry';

  @override
  String get harmonySoundTagWarm => 'warm';

  @override
  String get harmonySoundTagEpReady => 'EP-ready';

  @override
  String get harmonySoundTagClear => 'clear';

  @override
  String get harmonySoundTagAcoustic => 'acoustic';

  @override
  String get harmonySoundTagFocused => 'focused';

  @override
  String get harmonySoundNeutralTrait1 =>
      'Steady hold for general harmonic checking';

  @override
  String get harmonySoundNeutralTrait2 => 'Balanced attack with low coloration';

  @override
  String get harmonySoundNeutralTrait3 =>
      'Safe fallback for any lesson or free-play context';

  @override
  String get harmonySoundNeutralExpansion1 =>
      'Future split by piano register or room size';

  @override
  String get harmonySoundNeutralExpansion2 =>
      'Possible alternate shared instrument set for headphones';

  @override
  String get harmonySoundPopTrait1 =>
      'Longer sustain for open hooks and add9 color';

  @override
  String get harmonySoundPopTrait2 =>
      'Softer attack with a little width in repeated previews';

  @override
  String get harmonySoundPopTrait3 =>
      'Gentle humanization so loops feel less grid-locked';

  @override
  String get harmonySoundPopExpansion1 =>
      'Bright pop keys or layered piano-synth asset';

  @override
  String get harmonySoundPopExpansion2 =>
      'Wider stereo voicing playback for chorus lift';

  @override
  String get harmonySoundJazzTrait1 =>
      'Shorter hold to keep cadence motion readable';

  @override
  String get harmonySoundJazzTrait2 =>
      'Faster broken-preview feel for guide-tone hearing';

  @override
  String get harmonySoundJazzTrait3 =>
      'More touch variation to suggest shell and rootless comping';

  @override
  String get harmonySoundJazzExpansion1 =>
      'Dry upright or mellow electric-piano instrument family';

  @override
  String get harmonySoundJazzExpansion2 =>
      'Track-aware comping presets for shell and rootless drills';

  @override
  String get harmonySoundClassicalTrait1 =>
      'Centered sustain for function and cadence clarity';

  @override
  String get harmonySoundClassicalTrait2 =>
      'Low randomness to keep voice-leading stable';

  @override
  String get harmonySoundClassicalTrait3 =>
      'More direct block playback for harmonic arrival';

  @override
  String get harmonySoundClassicalExpansion1 =>
      'Direct acoustic piano profile with less ambient spread';

  @override
  String get harmonySoundClassicalExpansion2 =>
      'Dedicated cadence and sequence preview voicings';

  @override
  String get explanationSectionTitle => 'Why this works';

  @override
  String get explanationReasonSection => 'Why this result';

  @override
  String get explanationConfidenceHigh => 'High confidence';

  @override
  String get explanationConfidenceMedium => 'Plausible reading';

  @override
  String get explanationConfidenceLow => 'Treat as a tentative reading';

  @override
  String get explanationAmbiguityLow =>
      'Most of the progression points in one direction, but a light alternate reading is still possible.';

  @override
  String get explanationAmbiguityMedium =>
      'More than one plausible reading is still in play, so context matters here.';

  @override
  String get explanationAmbiguityHigh =>
      'Several readings are competing, so treat this as a cautious, context-dependent explanation.';

  @override
  String get explanationCautionParser =>
      'Some chord symbols were normalized before analysis.';

  @override
  String get explanationCautionAmbiguous =>
      'There is more than one reasonable reading here.';

  @override
  String get explanationCautionAlternateKey =>
      'A nearby key center also fits part of this progression.';

  @override
  String get explanationAlternativeSection => 'Other readings';

  @override
  String explanationAlternativeKeyLabel(Object keyLabel) {
    return 'Alternate key: $keyLabel';
  }

  @override
  String get explanationAlternativeKeyBody =>
      'The harmonic pull is still valid, but another key center also explains some of the same chords.';

  @override
  String explanationAlternativeReadingLabel(Object romanNumeral) {
    return 'Alternate reading: $romanNumeral';
  }

  @override
  String get explanationAlternativeReadingBody =>
      'This is another possible interpretation rather than a single definitive label.';

  @override
  String get explanationListeningSection => 'Listening focus';

  @override
  String get explanationListeningGuideToneTitle => 'Follow the 3rds and 7ths';

  @override
  String get explanationListeningGuideToneBody =>
      'Listen for the smallest inner-line motion as the cadence resolves.';

  @override
  String get explanationListeningDominantColorTitle =>
      'Listen for the dominant color';

  @override
  String get explanationListeningDominantColorBody =>
      'Notice how the tension on the dominant wants to release, even before the final arrival lands.';

  @override
  String get explanationListeningBackdoorTitle =>
      'Hear the softer backdoor pull';

  @override
  String get explanationListeningBackdoorBody =>
      'Listen for the subdominant-minor color leading home by color and voice leading rather than a plain V-I push.';

  @override
  String get explanationListeningBorrowedColorTitle => 'Hear the color shift';

  @override
  String get explanationListeningBorrowedColorBody =>
      'Notice how the borrowed chord darkens or brightens the loop before it returns home.';

  @override
  String get explanationListeningBassMotionTitle => 'Follow the bass motion';

  @override
  String get explanationListeningBassMotionBody =>
      'Track how the bass note reshapes momentum, even when the upper harmony stays closely related.';

  @override
  String get explanationListeningCadenceTitle => 'Hear the arrival';

  @override
  String get explanationListeningCadenceBody =>
      'Pay attention to which chord feels like the point of rest and how the approach prepares it.';

  @override
  String get explanationListeningAmbiguityTitle =>
      'Compare the competing readings';

  @override
  String get explanationListeningAmbiguityBody =>
      'Try hearing the same chord once for its local pull and once for its larger key-center role.';

  @override
  String get explanationPerformanceSection => 'Performance focus';

  @override
  String get explanationPerformancePopTitle => 'Keep the hook singable';

  @override
  String get explanationPerformancePopBody =>
      'Favor clear top notes, repeated contour, and open voicings that support the vocal line.';

  @override
  String get explanationPerformanceJazzTitle => 'Target guide tones first';

  @override
  String get explanationPerformanceJazzBody =>
      'Outline the 3rd and 7th before adding extra tensions or reharm color.';

  @override
  String get explanationPerformanceJazzShellTitle => 'Start with shell tones';

  @override
  String get explanationPerformanceJazzShellBody =>
      'Place the root, 3rd, and 7th cleanly first so the cadence stays easy to hear.';

  @override
  String get explanationPerformanceJazzRootlessTitle =>
      'Let the 3rd and 7th carry the shape';

  @override
  String get explanationPerformanceJazzRootlessBody =>
      'Keep the guide tones stable, then add 9 or 13 only if the line still resolves clearly.';

  @override
  String get explanationPerformanceClassicalTitle =>
      'Keep the voices disciplined';

  @override
  String get explanationPerformanceClassicalBody =>
      'Prioritize stable spacing, functional arrivals, and stepwise motion where possible.';

  @override
  String get explanationPerformanceDominantColorTitle =>
      'Add tension after the target is clear';

  @override
  String get explanationPerformanceDominantColorBody =>
      'Land the guide tones first, then treat 9, 13, or altered color as decoration rather than the main signal.';

  @override
  String get explanationPerformanceAmbiguityTitle =>
      'Anchor the most stable tones';

  @override
  String get explanationPerformanceAmbiguityBody =>
      'If the reading is ambiguous, emphasize the likely resolution tones before leaning into the more colorful option.';

  @override
  String get explanationPerformanceVoicingTitle => 'Voicing cue';

  @override
  String get explanationPerformanceMelodyTitle => 'Melody cue';

  @override
  String get explanationPerformanceMelodyBody =>
      'Lean on the structural target notes, then let passing tones fill the space around them.';

  @override
  String get explanationReasonFunctionalResolutionLabel => 'Functional pull';

  @override
  String get explanationReasonFunctionalResolutionBody =>
      'The chords line up as tonic, predominant, and dominant functions rather than isolated sonorities.';

  @override
  String get explanationReasonGuideToneSmoothnessLabel => 'Guide-tone motion';

  @override
  String get explanationReasonGuideToneSmoothnessBody =>
      'The inner voices move efficiently, which strengthens the sense of direction.';

  @override
  String get explanationReasonBorrowedColorLabel => 'Borrowed color';

  @override
  String get explanationReasonBorrowedColorBody =>
      'A parallel-mode borrowing adds contrast without fully leaving the home key.';

  @override
  String get explanationReasonSecondaryDominantLabel =>
      'Secondary dominant pull';

  @override
  String get explanationReasonSecondaryDominantBody =>
      'This dominant points strongly toward a local target chord instead of only the tonic.';

  @override
  String get explanationReasonTritoneSubLabel => 'Tritone-sub color';

  @override
  String get explanationReasonTritoneSubBody =>
      'The dominant color is preserved while the bass motion shifts to a substitute route.';

  @override
  String get explanationReasonDominantColorLabel => 'Dominant tension';

  @override
  String get explanationReasonDominantColorBody =>
      'Altered or extended dominant color strengthens the pull toward the next chord without changing the whole key reading.';

  @override
  String get explanationReasonBackdoorMotionLabel => 'Backdoor motion';

  @override
  String get explanationReasonBackdoorMotionBody =>
      'This reading leans on subdominant-minor or backdoor motion, so the resolution feels softer but still directed.';

  @override
  String get explanationReasonCadentialStrengthLabel => 'Cadential shape';

  @override
  String get explanationReasonCadentialStrengthBody =>
      'The phrase ends with a stronger arrival than a neutral loop continuation.';

  @override
  String get explanationReasonVoiceLeadingStabilityLabel =>
      'Stable voice leading';

  @override
  String get explanationReasonVoiceLeadingStabilityBody =>
      'The selected voicing keeps common tones or resolves tendency tones cleanly.';

  @override
  String get explanationReasonSingableContourLabel => 'Singable contour';

  @override
  String get explanationReasonSingableContourBody =>
      'The line favors memorable motion over angular, highly technical shapes.';

  @override
  String get explanationReasonSlashBassLiftLabel => 'Bass-motion lift';

  @override
  String get explanationReasonSlashBassLiftBody =>
      'The bass note changes the momentum even when the harmony stays closely related.';

  @override
  String get explanationReasonTurnaroundGravityLabel => 'Turnaround gravity';

  @override
  String get explanationReasonTurnaroundGravityBody =>
      'This pattern creates forward pull by cycling through familiar jazz resolution points.';

  @override
  String get explanationReasonInversionDisciplineLabel => 'Inversion control';

  @override
  String get explanationReasonInversionDisciplineBody =>
      'The inversion choice supports smoother outer-voice motion and clearer cadence behavior.';

  @override
  String get explanationReasonAmbiguityWindowLabel => 'Competing readings';

  @override
  String get explanationReasonAmbiguityWindowBody =>
      'Some of the same notes support more than one harmonic role, so context decides which reading feels stronger.';

  @override
  String get explanationReasonChromaticLineLabel => 'Chromatic line';

  @override
  String get explanationReasonChromaticLineBody =>
      'A chromatic bass or inner-line connection helps explain why this chord fits despite the extra color.';

  @override
  String get explanationTrackContextPop =>
      'In a pop context, this reading leans toward loop gravity, color contrast, and a singable top line.';

  @override
  String get explanationTrackContextJazz =>
      'In a jazz context, this is one plausible reading that highlights guide tones, cadence pull, and usable dominant color.';

  @override
  String get explanationTrackContextClassical =>
      'In a classical context, this reading leans toward function, inversion awareness, and cadence strength.';

  @override
  String get studyHarmonyTrackFocusSectionTitle => 'This track emphasizes';

  @override
  String get studyHarmonyTrackLessFocusSectionTitle =>
      'This track treats more lightly';

  @override
  String get studyHarmonyTrackRecommendedForSectionTitle => 'Recommended for';

  @override
  String get studyHarmonyTrackSoundSectionTitle => 'Sound profile';

  @override
  String get studyHarmonyTrackSoundAssetPlaceholder =>
      'Current release uses the shared piano asset. This profile prepares future track-specific sound choices.';

  @override
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument) {
    return 'Current instrument: $instrument';
  }

  @override
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern) {
    return 'Recommended preview pattern: $pattern';
  }

  @override
  String get studyHarmonyTrackSoundPlaybackTraitsTitle => 'Playback character';

  @override
  String get studyHarmonyTrackSoundExpansionTitle => 'Expansion path';

  @override
  String get studyHarmonyTrackPopFocus1 =>
      'Diatonic loop gravity and hook-friendly repetition';

  @override
  String get studyHarmonyTrackPopFocus2 =>
      'Borrowed-color lifts such as iv, bVII, or IVMaj7';

  @override
  String get studyHarmonyTrackPopFocus3 =>
      'Slash-bass and pedal-bass motion that supports pre-chorus lift';

  @override
  String get studyHarmonyTrackPopLess1 =>
      'Dense jazz reharmonization and advanced substitute dominants';

  @override
  String get studyHarmonyTrackPopLess2 =>
      'Rootless voicing systems and heavy altered-dominant language';

  @override
  String get studyHarmonyTrackPopRecommendedFor =>
      'Writers, producers, and players who want modern pop or ballad harmony that sounds usable quickly.';

  @override
  String get studyHarmonyTrackPopTheoryTone =>
      'Practical, song-first, and color-aware without overloading the learner with jargon.';

  @override
  String get studyHarmonyTrackPopHeroHeadline => 'Build hook-friendly loops';

  @override
  String get studyHarmonyTrackPopHeroBody =>
      'This track teaches loop gravity, restrained borrowed color, and bass movement that lifts a section without losing clarity.';

  @override
  String get studyHarmonyTrackPopQuickPracticeCue =>
      'Start with the signature loop chapter, then listen for how the bass and borrowed color reshape the same hook.';

  @override
  String get studyHarmonyTrackPopSoundLabel => 'Soft / open / modern';

  @override
  String get studyHarmonyTrackPopSoundSummary =>
      'Balanced piano now, with future room for brighter pop keys and wider stereo voicings.';

  @override
  String get studyHarmonyTrackJazzFocus1 =>
      'Guide-tone hearing and shell-to-rootless voicing growth';

  @override
  String get studyHarmonyTrackJazzFocus2 =>
      'Major ii-V-I, minor iiø-V-i y comportamiento del turnaround';

  @override
  String get studyHarmonyTrackJazzFocus3 =>
      'Dominant color, tensions, tritone sub, and backdoor entry points';

  @override
  String get studyHarmonyTrackJazzLess1 =>
      'Purely song-loop repetition without cadence awareness';

  @override
  String get studyHarmonyTrackJazzLess2 =>
      'Classical inversion literacy as a primary objective';

  @override
  String get studyHarmonyTrackJazzRecommendedFor =>
      'Players who want to hear and use functional jazz harmony without jumping straight into maximal reharm complexity.';

  @override
  String get studyHarmonyTrackJazzTheoryTone =>
      'Contextual, confidence-aware, and careful about calling one reading the only correct jazz answer.';

  @override
  String get studyHarmonyTrackJazzHeroHeadline =>
      'Hear the line inside the chords';

  @override
  String get studyHarmonyTrackJazzHeroBody =>
      'This track turns jazz harmony into manageable steps: guide tones first, then cadence families, then tasteful dominant color.';

  @override
  String get studyHarmonyTrackJazzQuickPracticeCue =>
      'Start with guide tones and shell voicings, then revisit the same cadence with rootless color.';

  @override
  String get studyHarmonyTrackJazzSoundLabel => 'Dry / warm / EP-ready';

  @override
  String get studyHarmonyTrackJazzSoundSummary =>
      'Shared piano for now, with placeholders for drier attacks and future electric-piano friendly playback.';

  @override
  String get studyHarmonyTrackClassicalFocus1 =>
      'Tonic / predominant / dominant function and cadence types';

  @override
  String get studyHarmonyTrackClassicalFocus2 =>
      'Inversion literacy, including first inversion and cadential 6/4 behavior';

  @override
  String get studyHarmonyTrackClassicalFocus3 =>
      'Voice-leading stability, sequence, and functional modulation basics';

  @override
  String get studyHarmonyTrackClassicalLess1 =>
      'Heavy tension stacking, quartal color, and upper-structure thinking';

  @override
  String get studyHarmonyTrackClassicalLess2 =>
      'Loop-driven pop repetition as the main learning frame';

  @override
  String get studyHarmonyTrackClassicalRecommendedFor =>
      'Learners who want clear functional hearing, inversion awareness, and disciplined voice leading.';

  @override
  String get studyHarmonyTrackClassicalTheoryTone =>
      'Structured, function-first, and phrased in a way that supports listening as well as label recognition.';

  @override
  String get studyHarmonyTrackClassicalHeroHeadline =>
      'Hear function and cadence clearly';

  @override
  String get studyHarmonyTrackClassicalHeroBody =>
      'This track emphasizes functional arrival, inversion control, and phrase endings that feel architecturally clear.';

  @override
  String get studyHarmonyTrackClassicalQuickPracticeCue =>
      'Start with cadence lab drills, then compare how inversions change the same function.';

  @override
  String get studyHarmonyTrackClassicalSoundLabel =>
      'Clear / acoustic / focused';

  @override
  String get studyHarmonyTrackClassicalSoundSummary =>
      'Shared piano for now, with room for a more direct acoustic profile in later releases.';

  @override
  String get studyHarmonyPopChapterSignatureLoopsTitle => 'Signature Pop Loops';

  @override
  String get studyHarmonyPopChapterSignatureLoopsDescription =>
      'Build practical pop instincts with hook gravity, borrowed lift, and bass motion that feels arrangement-ready.';

  @override
  String get studyHarmonyPopLessonHookGravityTitle => 'Hook Gravity';

  @override
  String get studyHarmonyPopLessonHookGravityDescription =>
      'Hear why modern four-chord loops stay catchy even when the harmony is simple.';

  @override
  String get studyHarmonyPopLessonBorrowedLiftTitle => 'Borrowed Lift';

  @override
  String get studyHarmonyPopLessonBorrowedLiftDescription =>
      'Experience restrained borrowed-color chords that brighten or darken a section without derailing the hook.';

  @override
  String get studyHarmonyPopLessonBassMotionTitle => 'Bass Motion';

  @override
  String get studyHarmonyPopLessonBassMotionDescription =>
      'Use slash-bass and line motion to create lift while the upper harmony stays familiar.';

  @override
  String get studyHarmonyPopLessonBossTitle => 'Pre-Chorus Lift Checkpoint';

  @override
  String get studyHarmonyPopLessonBossDescription =>
      'Combine loop gravity, borrowed color, and bass motion in one song-ready pop slice.';

  @override
  String get studyHarmonyJazzChapterGuideToneLabTitle => 'Guide-Tone Lab';

  @override
  String get studyHarmonyJazzChapterGuideToneLabDescription =>
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Reconoce cómo se siente el movimiento minor iiø-V-i y por qué allí el dominante suena más urgente.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceTitle =>
      'Tritone and Backdoor';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceDescription =>
      'Compare substitute-dominant and backdoor arrivals as plausible jazz routes into the same tonic.';

  @override
  String get studyHarmonyJazzLessonBossTitle => 'Turnaround Checkpoint';

  @override
  String get studyHarmonyJazzLessonBossDescription =>
      'Combina major ii-V-I, minor iiø-V-i, color rootless y reharm cuidadoso sin perder la claridad del punto de llegada de la cadencia.';

  @override
  String get studyHarmonyClassicalChapterCadenceLabTitle => 'Cadence Lab';

  @override
  String get studyHarmonyClassicalChapterCadenceLabDescription =>
      'Strengthen functional hearing with cadences, inversions, and carefully controlled secondary dominants.';

  @override
  String get studyHarmonyClassicalLessonCadenceTitle => 'Cadence Function';

  @override
  String get studyHarmonyClassicalLessonCadenceDescription =>
      'Sort tonic, predominant, and dominant behavior by how each chord prepares or completes the phrase.';

  @override
  String get studyHarmonyClassicalLessonInversionTitle => 'Inversion Control';

  @override
  String get studyHarmonyClassicalLessonInversionDescription =>
      'Hear how inversions change the bass line and the stability of an arrival.';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantTitle =>
      'Functional Secondary Dominants';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantDescription =>
      'Treat secondary dominants as directed functional events instead of generic color chords.';

  @override
  String get studyHarmonyClassicalLessonBossTitle => 'Arrival Checkpoint';

  @override
  String get studyHarmonyClassicalLessonBossDescription =>
      'Combine cadence shape, inversion awareness, and secondary-dominant pull in one controlled phrase.';

  @override
  String studyHarmonyPlayStyleLabel(String playStyle) {
    String _temp0 = intl.Intl.selectLogic(playStyle, {
      'competitor': 'Competitor',
      'collector': 'Collector',
      'explorer': 'Explorer',
      'stabilizer': 'Stabilizer',
      'balanced': 'Balanced',
      'other': 'Balanced',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyRewardFocusLabel(String focus) {
    String _temp0 = intl.Intl.selectLogic(focus, {
      'mastery': 'Focus: Mastery',
      'achievements': 'Focus: Achievements',
      'cosmetics': 'Focus: Cosmetics',
      'currency': 'Focus: Currency',
      'collection': 'Focus: Collection',
      'other': 'Focus',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress) {
    return 'Next $rewardTitle $progress%';
  }

  @override
  String studyHarmonyCurrencyBalanceLabel(String currencyTitle, int amount) {
    return '$currencyTitle $amount';
  }

  @override
  String studyHarmonyCurrencyGrantLabel(String currencyTitle, int amount) {
    return '$currencyTitle +$amount';
  }

  @override
  String studyHarmonyDifficultyLaneLabel(String lane) {
    String _temp0 = intl.Intl.selectLogic(lane, {
      'recovery': 'Recovery Lane',
      'groove': 'Groove Lane',
      'push': 'Push Lane',
      'clutch': 'Clutch Lane',
      'legend': 'Legend Lane',
      'other': 'Practice Lane',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPressureTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'calm': 'Calm Pressure',
      'steady': 'Steady Pressure',
      'hot': 'Hot Pressure',
      'charged': 'Charged Pressure',
      'overdrive': 'Overdrive',
      'other': 'Pressure',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyForgivenessTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'strict': 'Strict Windows',
      'tight': 'Tight Windows',
      'balanced': 'Balanced Windows',
      'kind': 'Kind Windows',
      'generous': 'Generous Windows',
      'other': 'Timing Windows',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyComboGoalLabel(int comboTarget) {
    return 'Combo Goal $comboTarget';
  }

  @override
  String studyHarmonyRuntimeTuningSummary(int lives, int goal) {
    return 'Lives $lives | Goal $goal';
  }

  @override
  String studyHarmonyCoachLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Supportive Coach',
      'structured': 'Structured Coach',
      'challengeForward': 'Challenge Coach',
      'analytical': 'Analytical Coach',
      'restorative': 'Restorative Coach',
      'other': 'Coach',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyCoachLine(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Protect flow first and let confidence compound.',
      'structured': 'Follow the structure and the gains will stick.',
      'challengeForward': 'Lean into the pressure and push for a sharper run.',
      'analytical': 'Read the weak point and refine it with precision.',
      'restorative': 'This run is about rebuilding rhythm without tilt.',
      'other': 'Keep the next run focused and intentional.',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPacingSegmentLabel(String segment, int minutes) {
    String _temp0 = intl.Intl.selectLogic(segment, {
      'warmup': 'Warmup',
      'tension': 'Tension',
      'release': 'Release',
      'reward': 'Reward',
      'other': 'Segment',
    });
    return '$_temp0 ${minutes}m';
  }

  @override
  String studyHarmonyPacingSummaryLabel(String segments) {
    return 'Pacing $segments';
  }

  @override
  String studyHarmonyArcadeRiskLabel(String risk) {
    String _temp0 = intl.Intl.selectLogic(risk, {
      'forgiving': 'Low Risk',
      'balanced': 'Balanced Risk',
      'tense': 'High Tension',
      'punishing': 'Punishing Risk',
      'other': 'Arcade Risk',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRewardStyleLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'currency': 'Currency Loop',
      'cosmetic': 'Cosmetic Hunt',
      'title': 'Title Hunt',
      'trophy': 'Trophy Run',
      'bundle': 'Bundle Rewards',
      'prestige': 'Prestige Rewards',
      'other': 'Reward Loop',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count) {
    return 'Combo bonus every $count';
  }

  @override
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives) {
    return 'Miss costs $lives';
  }

  @override
  String get studyHarmonyArcadeRuntimeModifierPulses => 'Modifier pulses';

  @override
  String get studyHarmonyArcadeRuntimeGhostPressure => 'Ghost pressure';

  @override
  String get studyHarmonyArcadeRuntimeShopBiasedLoot => 'Shop-biased loot';

  @override
  String get studyHarmonyArcadeRuntimeSteadyRuleset => 'Steady ruleset';

  @override
  String studyHarmonyShopStateLabel(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'alreadyPurchased': 'Already purchased',
      'readyToBuy': 'Ready to buy',
      'progressLocked': 'Progress locked',
      'other': 'Shop state',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyShopActionLabel(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'buy': 'Buy',
      'equipped': 'Equipped',
      'equip': 'Equip',
      'other': 'Shop action',
    });
    return '$_temp0';
  }

  @override
  String get melodyCurrentLineFeelTitle => 'Current line feel';

  @override
  String get melodyLinePersonalityTitle => 'Line personality';

  @override
  String get melodyLinePersonalityBody =>
      'These four sliders shape why guided, standard, and advanced can feel different even before you change the harmony.';

  @override
  String get melodySyncopationBiasTitle => 'Syncopation Bias';

  @override
  String get melodySyncopationBiasBody =>
      'Leans toward offbeat starts, anticipations, and rhythmic lift.';

  @override
  String get melodyColorRealizationBiasTitle => 'Color Realization Bias';

  @override
  String get melodyColorRealizationBiasBody =>
      'Lets the melody pick up featured tensions and color tones more often.';

  @override
  String get melodyNoveltyTargetTitle => 'Novelty Target';

  @override
  String get melodyNoveltyTargetBody =>
      'Reduces exact repeats and nudges the line toward fresher interval shapes.';

  @override
  String get melodyMotifVariationBiasTitle => 'Motif Variation Bias';

  @override
  String get melodyMotifVariationBiasBody =>
      'Turns motif reuse into sequence, tail changes, and rhythmic variation.';

  @override
  String get studyHarmonyArcadeRulesTitle => 'Arcade Rules';

  @override
  String studyHarmonySessionLengthLabel(int minutes) {
    return '$minutes min run';
  }

  @override
  String studyHarmonyRewardKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'achievement': 'Achievement',
      'title': 'Title',
      'cosmetic': 'Cosmetic',
      'shopItem': 'Shop Unlock',
      'other': 'Reward',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives) {
    return 'Misses cost $lives hearts';
  }

  @override
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount) {
    return 'Misses push progress back by $amount';
  }

  @override
  String studyHarmonyArcadeRuntimeComboProgressLabel(
    int threshold,
    int amount,
  ) {
    return 'Every $threshold combo adds +$amount progress';
  }

  @override
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount) {
    return 'Every $threshold combo adds +$amount heart';
  }

  @override
  String get studyHarmonyArcadeRuntimeComboResetLabel => 'Misses reset combo';

  @override
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount) {
    return 'Misses cut combo by $amount';
  }

  @override
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel =>
      'Choices reshuffle';

  @override
  String get studyHarmonyArcadeRuntimeMissedReplayLabel =>
      'Missed prompts replay';

  @override
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel => 'No prompt repeats';

  @override
  String get studyHarmonyRuntimeBundleClearBonusTitle => 'Clear Bonus';

  @override
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle => 'Precision Bonus';

  @override
  String get studyHarmonyRuntimeBundleComboBonusTitle => 'Combo Bonus';

  @override
  String get studyHarmonyRuntimeBundleModeBonusTitle => 'Mode Bonus';

  @override
  String get studyHarmonyRuntimeBundleMasteryBonusTitle => 'Mastery Bonus';

  @override
  String get melodyQuickPresetGuideLineLabel => 'Guide Line';

  @override
  String get melodyQuickPresetSongLineLabel => 'Song Line';

  @override
  String get melodyQuickPresetColorLineLabel => 'Color Line';

  @override
  String get melodyQuickPresetGuideCompactLabel => 'Guide';

  @override
  String get melodyQuickPresetSongCompactLabel => 'Song';

  @override
  String get melodyQuickPresetColorCompactLabel => 'Color';

  @override
  String get melodyQuickPresetGuideShort => 'steady guide notes';

  @override
  String get melodyQuickPresetSongShort => 'singable contour';

  @override
  String get melodyQuickPresetColorShort => 'color-forward line';

  @override
  String get melodyQuickPresetPanelTitle => 'Melody Presets';

  @override
  String get melodyQuickPresetPanelCompactTitle => 'Line Presets';

  @override
  String get melodyQuickPresetOffLabel => 'Off';

  @override
  String get melodyQuickPresetCompactOffLabel => 'Line Off';

  @override
  String get melodyMetricDensityLabel => 'Density';

  @override
  String get melodyMetricStyleLabel => 'Style';

  @override
  String get melodyMetricSyncLabel => 'Sync';

  @override
  String get melodyMetricColorLabel => 'Color';

  @override
  String get melodyMetricNoveltyLabel => 'Novelty';

  @override
  String get melodyMetricMotifLabel => 'Motif';

  @override
  String get melodyMetricChromaticLabel => 'Chromatic';

  @override
  String get practiceFirstRunWelcomeTitle => 'Tu primer acorde está listo';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'Ya se aplicó un perfil inicial apto para principiantes. Escúchalo primero y luego desliza la tarjeta para explorar el siguiente acorde.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel está listo. Escúchalo primero y luego desliza la tarjeta para explorar lo que sigue. También puedes abrir el asistente de configuración para personalizar el inicio.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Idioma de notación musical';

  @override
  String get musicNotationLocaleHelp =>
      'Controla el idioma usado para las ayudas opcionales de números romanos y texto de acordes.';

  @override
  String get musicNotationLocaleUiDefault => 'Igual que la app';

  @override
  String get musicNotationLocaleEnglish => 'Inglés';

  @override
  String get noteNamingStyle => 'Nombres de notas';

  @override
  String get noteNamingStyleHelp =>
      'Cambia los nombres visibles de notas y tonalidades sin alterar la lógica armónica.';

  @override
  String get noteNamingStyleEnglish => 'Letras inglesas';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Mostrar ayuda de números romanos';

  @override
  String get showRomanNumeralAssistHelp =>
      'Añade una breve explicación junto a las etiquetas de números romanos.';

  @override
  String get showChordTextAssist => 'Mostrar ayuda de texto de acordes';

  @override
  String get showChordTextAssistHelp =>
      'Añade una breve explicación sobre la cualidad del acorde y sus tensiones.';

  @override
  String get premiumUnlockTitle => 'Chordest Premium';

  @override
  String get premiumUnlockBody =>
      'A one-time purchase permanently unlocks Smart Generator and advanced harmonic color controls. Free Generator, Analyzer, metronome, and language support stay available.';

  @override
  String get premiumUnlockRequestedFeatureTitle => 'Requested in this flow';

  @override
  String get premiumUnlockOfflineCacheTitle =>
      'Using your last confirmed unlock';

  @override
  String get premiumUnlockOfflineCacheBody =>
      'The store is unavailable right now, so the app is using your last confirmed premium unlock cache.';

  @override
  String get premiumUnlockFreeTierTitle => 'Free';

  @override
  String get premiumUnlockFreeTierLineGenerator =>
      'Basic Generator, chord display, inversions, slash bass, and core metronome';

  @override
  String get premiumUnlockFreeTierLineAnalyzer =>
      'Conservative Analyzer with confidence and ambiguity warnings';

  @override
  String get premiumUnlockFreeTierLineMetronome =>
      'Language, theme, setup assistant, and standard practice settings';

  @override
  String get premiumUnlockPremiumTierTitle => 'Premium unlock';

  @override
  String get premiumUnlockPremiumLineSmartGenerator =>
      'Smart Generator mode for progression-aware generation in selected keys';

  @override
  String get premiumUnlockPremiumLineHarmonyColors =>
      'Secondary dominants, substitute dominants, modal interchange, and advanced tensions';

  @override
  String get premiumUnlockPremiumLineAdvancedSmartControls =>
      'Modulation intensity, jazz preset, and source profile controls for Smart Generator';

  @override
  String premiumUnlockBuyButton(Object priceLabel) {
    return 'Desbloqueo permanente ($priceLabel)';
  }

  @override
  String get premiumUnlockBuyButtonUnavailable => 'Unlock permanently';

  @override
  String get premiumUnlockRestoreButton => 'Restore purchase';

  @override
  String get premiumUnlockKeepFreeButton => 'Keep using free';

  @override
  String get premiumUnlockStoreFallbackBody =>
      'Store product info is not available right now. Free features keep working, and you can retry or restore later.';

  @override
  String get premiumUnlockStorePriceHint =>
      'Price comes from the store. The app does not hardcode a fixed price.';

  @override
  String get premiumUnlockStoreUnavailableTitle => 'Store unavailable';

  @override
  String get premiumUnlockStoreUnavailableBody =>
      'La conexión con la tienda no está disponible en este momento. Las funciones gratuitas siguen funcionando.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'La información del producto premium no está disponible ahora mismo. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockPurchaseSuccessTitle => 'Premium unlocked';

  @override
  String get premiumUnlockPurchaseSuccessBody =>
      'Your permanent premium unlock is now active on this device.';

  @override
  String get premiumUnlockRestoreSuccessTitle => 'Purchase restored';

  @override
  String get premiumUnlockRestoreSuccessBody =>
      'Your premium unlock was restored from the store.';

  @override
  String get premiumUnlockRestoreNotFoundTitle => 'Nothing to restore';

  @override
  String get premiumUnlockRestoreNotFoundBody =>
      'No matching premium unlock was found for this store account.';

  @override
  String get premiumUnlockPurchaseCancelledTitle => 'Purchase canceled';

  @override
  String get premiumUnlockPurchaseCancelledBody =>
      'No charge was made. Free features are still available.';

  @override
  String get premiumUnlockPurchasePendingTitle => 'Purchase pending';

  @override
  String get premiumUnlockPurchasePendingBody =>
      'The store marked this purchase as pending. Premium unlock will activate after confirmation.';

  @override
  String get premiumUnlockPurchaseFailedTitle => 'Purchase failed';

  @override
  String get premiumUnlockPurchaseFailedBody =>
      'No se pudo completar la compra. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockAlreadyOwned => 'Premium unlocked';

  @override
  String get premiumUnlockAlreadyOwnedTitle => 'Already unlocked';

  @override
  String get premiumUnlockAlreadyOwnedBody =>
      'This store account already has the premium unlock.';

  @override
  String get premiumUnlockHighlightSmartGenerator =>
      'Smart Generator mode and its deeper progression controls are part of the premium unlock.';

  @override
  String get premiumUnlockHighlightAdvancedHarmony =>
      'Non-diatonic color options and advanced tensions are part of the premium unlock.';

  @override
  String get premiumUnlockCardTitle => 'Premium unlock';

  @override
  String get premiumUnlockCardBodyUnlocked =>
      'Your one-time premium unlock is active.';

  @override
  String get premiumUnlockCardBodyLocked =>
      'Unlock Smart Generator and advanced harmonic color controls with one purchase.';

  @override
  String get premiumUnlockCardButton => 'View premium';

  @override
  String get premiumUnlockGeneratorHint =>
      'Smart Generator and advanced harmonic colors unlock with a one-time premium purchase.';

  @override
  String get premiumUnlockSettingsHintTitle => 'Premium controls';

  @override
  String get premiumUnlockSettingsHintBody =>
      'Smart Generator, non-diatonic color controls, and advanced tensions are part of the one-time premium unlock.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountCardSignedOutBody =>
      'Sign in to link premium to your account and restore it on your other devices.';

  @override
  String accountCardSignedInBody(Object email) {
    return 'Signed in as $email. Premium sync and restore now follow this account.';
  }

  @override
  String get accountCardUnavailableBody =>
      'Account features are not configured in this build yet. Add Firebase runtime configuration to enable sign-in.';

  @override
  String get accountOpenButton => 'Sign in';

  @override
  String get accountManageButton => 'Manage account';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String get accountCreateButton => 'Create account';

  @override
  String get accountSwitchToCreateButton => 'Create a new account';

  @override
  String get accountSwitchToSignInButton => 'I already have an account';

  @override
  String get accountForgotPasswordButton => 'Reset password';

  @override
  String get accountSignOutButton => 'Sign out';

  @override
  String get accountMessageSignedIn => 'You\'re signed in.';

  @override
  String get accountMessageSignedUp =>
      'Your account was created and signed in.';

  @override
  String get accountMessageSignedOut => 'You signed out of this account.';

  @override
  String get accountMessagePasswordResetSent => 'Password reset email sent.';

  @override
  String get accountMessageInvalidCredentials =>
      'Check your email and password and try again.';

  @override
  String get accountMessageEmailInUse => 'That email is already in use.';

  @override
  String get accountMessageWeakPassword =>
      'Use a stronger password to create this account.';

  @override
  String get accountMessageUserNotFound =>
      'No account was found for that email.';

  @override
  String get accountMessageTooManyRequests =>
      'Too many attempts right now. Please try again later.';

  @override
  String get accountMessageNetworkError =>
      'The network request failed. Please check your connection.';

  @override
  String get accountMessageAuthUnavailable =>
      'Account sign-in is not configured in this build yet.';

  @override
  String get accountMessageUnknownError =>
      'The account request could not be completed.';

  @override
  String get accountDeleteButton => 'Delete account';

  @override
  String get accountDeleteDialogTitle => 'Delete account?';

  @override
  String accountDeleteDialogBody(Object email) {
    return 'This permanently deletes the Chordest account for $email and removes synced premium data. Store purchase history stays with your store account.';
  }

  @override
  String get accountDeletePasswordHelper =>
      'Enter your current password to confirm this deletion request.';

  @override
  String get accountDeleteConfirmButton => 'Delete permanently';

  @override
  String get accountDeleteCancelButton => 'Cancel';

  @override
  String get accountDeletePasswordRequired =>
      'Enter your current password to delete this account.';

  @override
  String get accountMessageDeleted =>
      'Your account and synced premium data were deleted.';

  @override
  String get accountMessageDeleteRequiresRecentLogin =>
      'For safety, enter your current password and try again.';

  @override
  String get accountMessageDataDeletionFailed =>
      'We couldn\'t remove your synced account data. Please try again.';

  @override
  String get premiumUnlockAccountSyncTitle => 'Account sync';

  @override
  String get premiumUnlockAccountSyncSignedOutBody =>
      'You can keep using premium locally, but signing in lets this unlock follow your account to other devices.';

  @override
  String premiumUnlockAccountSyncSignedInBody(Object email) {
    return 'Premium purchases and restores will sync to $email when this account is signed in.';
  }

  @override
  String get premiumUnlockAccountSyncUnavailableBody =>
      'Account sync is not configured in this build yet, so premium currently stays local to this device.';

  @override
  String get premiumUnlockAccountOpenButton => 'Account';

  @override
  String get undoLabel => 'Undo';

  @override
  String get favoriteStartsTitle => 'Favorite starts';

  @override
  String favoriteStartSlotTitle(int displayIndex) {
    return 'Favorite $displayIndex';
  }

  @override
  String get favoriteStartEmptyMessage => 'No saved start preset yet.';

  @override
  String get favoriteStartSaveLabel => 'Save current';

  @override
  String get favoriteStartUpdateLabel => 'Update';

  @override
  String get favoriteStartApplyLabel => 'Apply';

  @override
  String get favoriteStartRenameLabel => 'Rename';

  @override
  String get favoriteStartClearLabel => 'Clear';

  @override
  String favoriteStartSavedMessage(int displayIndex) {
    return 'Saved the current setup to Favorite $displayIndex.';
  }

  @override
  String favoriteStartAppliedMessage(int displayIndex) {
    return 'Applied Favorite $displayIndex.';
  }

  @override
  String favoriteStartClearedMessage(int displayIndex) {
    return 'Cleared Favorite $displayIndex.';
  }

  @override
  String favoriteStartRenamedMessage(int displayIndex, Object label) {
    return 'Updated Favorite $displayIndex to \"$label\".';
  }

  @override
  String favoriteStartRenameDialogTitle(int displayIndex) {
    return 'Name Favorite $displayIndex';
  }

  @override
  String get favoriteStartRenameDialogHelper =>
      'Leave this blank to use the automatic label.';

  @override
  String get favoriteStartRenameConfirmLabel => 'Save name';

  @override
  String get copyToolsTitle => 'Copy tools';

  @override
  String get copyCurrentChordLabel => 'Copy current chord';

  @override
  String get copyVisibleLoopLabel => 'Copy visible loop';

  @override
  String get copyMelodyPreviewLabel => 'Copy melody preview';

  @override
  String get recentCopiesTitle => 'Recent copies';

  @override
  String get recentCopyCurrentChordLabel => 'Current chord';

  @override
  String get recentCopyVisibleLoopLabel => 'Visible loop';

  @override
  String get recentCopyMelodyPreviewLabel => 'Melody preview';

  @override
  String get nothingToCopyMessage => 'There is nothing to copy yet.';

  @override
  String get noRecentCopiesMessage => 'There is no recent copied text yet.';

  @override
  String get copiedCurrentChordMessage => 'Copied the current chord.';

  @override
  String get copiedVisibleLoopMessage => 'Copied the visible loop.';

  @override
  String get copiedMelodyPreviewMessage => 'Copied the melody preview.';

  @override
  String get copiedRecentCopyMessage => 'Copied from recent history.';

  @override
  String get analyzeVisibleLoopLabel => 'Analyze visible loop';

  @override
  String get quickMovesTitle => 'Quick moves';

  @override
  String get nudgeEasierLabel => 'Make easier';

  @override
  String get nudgeRicherLabel => 'Make richer';

  @override
  String get nothingToAnalyzeMessage =>
      'There is no visible loop to analyze yet.';

  @override
  String get nudgedEasierMessage => 'Shifted toward an easier profile.';

  @override
  String get nudgedRicherMessage => 'Shifted toward a richer profile.';

  @override
  String get alreadyEasierMessage =>
      'This is already near the easiest setting.';

  @override
  String get alreadyRicherMessage =>
      'This is already near the richest quick setting.';

  @override
  String get currentChordLabel => 'Current';

  @override
  String get nextChordLabel => 'Next';

  @override
  String get chordAnalyzerPinnedSectionTitle => 'Pinned progressions';

  @override
  String get chordAnalyzerRecentSectionTitle => 'Recent analyses';

  @override
  String get chordAnalyzerPinLabel => 'Pin';

  @override
  String get chordAnalyzerUnpinLabel => 'Unpin';

  @override
  String get chordAnalyzerPinTooltip => 'Pin this progression for quick reuse.';

  @override
  String get chordAnalyzerUnpinTooltip =>
      'Remove this progression from pinned items.';

  @override
  String chordAnalyzerPinnedProgressionTooltip(Object progression) {
    return 'Analyze this pinned progression again.\n$progression';
  }

  @override
  String chordAnalyzerRecentProgressionTooltip(Object progression) {
    return 'Reopen this recent analysis.\n$progression';
  }

  @override
  String get chordAnalyzerPracticeThisKeyLabel => 'Practice this key';

  @override
  String chordAnalyzerPracticeThisKeyTooltip(Object keyLabel) {
    return 'Open the generator in $keyLabel. (G)';
  }
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get settings => 'Ajustes';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Valor predeterminado del sistema';

  @override
  String get themeMode => 'Tema';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get setupAssistantTitle => 'Setup Assistant';

  @override
  String get setupAssistantSubtitle =>
      'A few quick choices will make your first practice session feel calmer. You can rerun this anytime.';

  @override
  String get setupAssistantCurrentMode => 'Current setup';

  @override
  String get setupAssistantModeGuided => 'Guided mode';

  @override
  String get setupAssistantModeStandard => 'Standard mode';

  @override
  String get setupAssistantModeAdvanced => 'Advanced mode';

  @override
  String get setupAssistantRunAgain => 'Run setup assistant again';

  @override
  String get setupAssistantCardBody =>
      'Use a gentler profile now, then open advanced controls whenever you want more room.';

  @override
  String get setupAssistantPreparingTitle => 'We\'ll start gently';

  @override
  String get setupAssistantPreparingBody =>
      'Before the generator shows any chords, we\'ll set up a comfortable starting point in a few taps.';

  @override
  String setupAssistantProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setupAssistantSkip => 'Skip';

  @override
  String get setupAssistantBack => 'Back';

  @override
  String get setupAssistantNext => 'Next';

  @override
  String get setupAssistantApply => 'Apply';

  @override
  String get setupAssistantGoalQuestionTitle =>
      'What would you like this generator to help with first?';

  @override
  String get setupAssistantGoalQuestionBody =>
      'Pick the one that sounds closest. Nothing here is permanent.';

  @override
  String get setupAssistantGoalEarTitle => 'Hear and recognize chords';

  @override
  String get setupAssistantGoalEarBody =>
      'Short, friendly prompts for listening and recognition.';

  @override
  String get setupAssistantGoalKeyboardTitle => 'Keyboard hand practice';

  @override
  String get setupAssistantGoalKeyboardBody =>
      'Simple shapes and readable symbols for your hands first.';

  @override
  String get setupAssistantGoalSongTitle => 'Song ideas';

  @override
  String get setupAssistantGoalSongBody =>
      'Keep the generator musical without dumping you into chaos.';

  @override
  String get setupAssistantGoalHarmonyTitle => 'Harmony study';

  @override
  String get setupAssistantGoalHarmonyBody =>
      'Start clear, then leave room to grow into deeper harmony.';

  @override
  String get setupAssistantLiteracyQuestionTitle =>
      'Which sentence feels closest right now?';

  @override
  String get setupAssistantLiteracyQuestionBody =>
      'Choose the most comfortable answer, not the most ambitious one.';

  @override
  String get setupAssistantLiteracyAbsoluteTitle =>
      'C, Cm, C7, and Cmaj7 still blur together';

  @override
  String get setupAssistantLiteracyAbsoluteBody =>
      'Keep things extra readable and familiar.';

  @override
  String get setupAssistantLiteracyBasicTitle => 'I can read maj7 / m7 / 7';

  @override
  String get setupAssistantLiteracyBasicBody =>
      'Stay safe, but allow a little more range.';

  @override
  String get setupAssistantLiteracyFunctionalTitle =>
      'I mostly follow ii-V-I and diatonic function';

  @override
  String get setupAssistantLiteracyFunctionalBody =>
      'Keep the harmony clear with a bit more motion.';

  @override
  String get setupAssistantLiteracyAdvancedTitle =>
      'Colorful reharmonization and extensions already feel familiar';

  @override
  String get setupAssistantLiteracyAdvancedBody =>
      'Leave more of the power-user range available.';

  @override
  String get setupAssistantHandQuestionTitle =>
      'How comfortable do your hands feel on keys?';

  @override
  String get setupAssistantHandQuestionBody =>
      'We\'ll use this to keep voicings playable.';

  @override
  String get setupAssistantHandThreeTitle => 'Three-note shapes feel best';

  @override
  String get setupAssistantHandThreeBody => 'Keep the hand shape compact.';

  @override
  String get setupAssistantHandFourTitle => 'Four notes are okay';

  @override
  String get setupAssistantHandFourBody => 'Allow a little more spread.';

  @override
  String get setupAssistantHandJazzTitle => 'Jazzier shapes feel comfortable';

  @override
  String get setupAssistantHandJazzBody =>
      'Open the door to larger voicings later.';

  @override
  String get setupAssistantColorQuestionTitle =>
      'How colorful should the sound feel at first?';

  @override
  String get setupAssistantColorQuestionBody => 'When in doubt, start simpler.';

  @override
  String get setupAssistantColorSafeTitle => 'Safe and familiar';

  @override
  String get setupAssistantColorSafeBody =>
      'Stay close to classic, readable harmony.';

  @override
  String get setupAssistantColorJazzyTitle => 'A little jazzy';

  @override
  String get setupAssistantColorJazzyBody =>
      'Add a touch of color without getting wild.';

  @override
  String get setupAssistantColorColorfulTitle => 'Quite colorful';

  @override
  String get setupAssistantColorColorfulBody =>
      'Leave more room for modern color.';

  @override
  String get setupAssistantSymbolQuestionTitle =>
      'Which chord spelling feels easiest to read?';

  @override
  String get setupAssistantSymbolQuestionBody =>
      'This only changes how the chord is shown.';

  @override
  String get setupAssistantSymbolMajTextBody => 'Clear and beginner-friendly.';

  @override
  String get setupAssistantSymbolCompactBody =>
      'Shorter if you already like compact symbols.';

  @override
  String get setupAssistantSymbolDeltaBody =>
      'Jazz-style if that is what your eyes expect.';

  @override
  String get setupAssistantKeyQuestionTitle => 'Which key should we start in?';

  @override
  String get setupAssistantKeyQuestionBody =>
      'C major is the easiest default, but you can change it later.';

  @override
  String get setupAssistantKeyCMajorBody => 'Best beginner starting point.';

  @override
  String get setupAssistantKeyGMajorBody =>
      'A bright major key with one sharp.';

  @override
  String get setupAssistantKeyFMajorBody => 'A warm major key with one flat.';

  @override
  String get setupAssistantPreviewTitle => 'Try your first result';

  @override
  String get setupAssistantPreviewBody =>
      'This is about what the generator will feel like. You can make it simpler or a little jazzier before you start.';

  @override
  String get setupAssistantPreviewListen => 'Hear this sample';

  @override
  String get setupAssistantPreviewPlaying => 'Playing sample...';

  @override
  String get setupAssistantStartNow => 'Start with this';

  @override
  String get setupAssistantAdjustEasier => 'Make it easier';

  @override
  String get setupAssistantAdjustJazzier => 'A little more jazzy';

  @override
  String get setupAssistantPreviewKeyLabel => 'Key';

  @override
  String get setupAssistantPreviewNotationLabel => 'Notation';

  @override
  String get setupAssistantPreviewDifficultyLabel => 'Feel';

  @override
  String get setupAssistantPreviewProgressionLabel => 'Sample progression';

  @override
  String get setupAssistantPreviewProgressionBody =>
      'A short four-chord sample built from your setup.';

  @override
  String get setupAssistantPreviewSummaryAbsolute => 'Beginner-friendly start';

  @override
  String get setupAssistantPreviewSummaryBasic =>
      'Readable seventh-chord start';

  @override
  String get setupAssistantPreviewSummaryFunctional =>
      'Functional harmony start';

  @override
  String get setupAssistantPreviewSummaryAdvanced => 'Colorful jazz start';

  @override
  String get setupAssistantPreviewBodyTriads =>
      'Mostly familiar triads in a safe key, with compact voicings and no spicy surprises.';

  @override
  String get setupAssistantPreviewBodySevenths =>
      'maj7, m7, and 7 show up clearly, while the progression still stays calm and readable.';

  @override
  String get setupAssistantPreviewBodySafeExtensions =>
      'A little extra color can appear, but it stays within safe, familiar extensions.';

  @override
  String get setupAssistantPreviewBodyFullExtensions =>
      'The preview leaves more room for modern color, richer movement, and denser harmony.';

  @override
  String get setupAssistantNotationMajText => 'Cmaj7 style';

  @override
  String get setupAssistantNotationCompact => 'CM7 style';

  @override
  String get setupAssistantNotationDelta => 'CΔ7 style';

  @override
  String get setupAssistantDifficultyTriads =>
      'Simple triads and core movement';

  @override
  String get setupAssistantDifficultySevenths => 'maj7 / m7 / 7 centered';

  @override
  String get setupAssistantDifficultySafeExtensions =>
      'Safe color with 9 / 11 / 13';

  @override
  String get setupAssistantDifficultyFullExtensions =>
      'Full color and wider motion';

  @override
  String get setupAssistantStudyHarmonyTitle =>
      'Want a gentler theory path too?';

  @override
  String get setupAssistantStudyHarmonyBody =>
      'Study Harmony can walk you through the basics while this generator stays in a safe lane.';

  @override
  String get setupAssistantStudyHarmonyCta => 'Start Study Harmony';

  @override
  String get setupAssistantGuidedSettingsTitle =>
      'Beginner-friendly setup is on';

  @override
  String get setupAssistantGuidedSettingsBody =>
      'Core controls stay close by here. Everything else is still available when you want it.';

  @override
  String get setupAssistantAdvancedSectionTitle => 'More controls';

  @override
  String get setupAssistantAdvancedSectionBody =>
      'Open the full settings page if you want every generator option.';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Enciende el metrónomo para escuchar un clic en cada tiempo mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metrónomo';

  @override
  String get metronomeSoundClassic => 'Clásico';

  @override
  String get metronomeSoundClickB => 'Haga clic en B';

  @override
  String get metronomeSoundClickC => 'Haga clic en C';

  @override
  String get metronomeSoundClickD => 'Haga clic en D';

  @override
  String get metronomeSoundClickE => 'Haga clic en E';

  @override
  String get metronomeSoundClickF => 'Haga clic en F';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get practiceMeter => 'Time Signature';

  @override
  String get practiceMeterHelp =>
      'Choose how many beats are in each bar for transport and metronome timing.';

  @override
  String get practiceTimeSignatureTwoFour => '2/4';

  @override
  String get practiceTimeSignatureThreeFour => '3/4';

  @override
  String get practiceTimeSignatureFourFour => '4/4';

  @override
  String get practiceTimeSignatureFiveFour => '5/4';

  @override
  String get practiceTimeSignatureSixEight => '6/8';

  @override
  String get practiceTimeSignatureSevenEight => '7/8';

  @override
  String get practiceTimeSignatureTwelveEight => '12/8';

  @override
  String get harmonicRhythm => 'Harmonic Rhythm';

  @override
  String get harmonicRhythmHelp =>
      'Choose how often chord changes can happen inside the bar.';

  @override
  String get harmonicRhythmOnePerBar => 'One per bar';

  @override
  String get harmonicRhythmTwoPerBar => 'Two per bar';

  @override
  String get harmonicRhythmPhraseAwareJazz => 'Phrase-aware jazz';

  @override
  String get harmonicRhythmCadenceCompression => 'Cadence compression';

  @override
  String get keys => 'Llaves';

  @override
  String get noKeysSelected =>
      'No hay claves seleccionadas. Deja todas las teclas apagadas para practicar en modo libre en cada raíz.';

  @override
  String get keysSelectedHelp =>
      'Las claves seleccionadas se utilizan para el modo aleatorio con reconocimiento de clave y el modo Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional conservando las opciones no diatónico habilitadas.';

  @override
  String get advancedSmartGenerator => 'Avanzado Smart Generator';

  @override
  String get modulationIntensity => 'Intensidad de modulación';

  @override
  String get modulationIntensityOff => 'Apagado';

  @override
  String get modulationIntensityLow => 'Bajo';

  @override
  String get modulationIntensityMedium => 'Medio';

  @override
  String get modulationIntensityHigh => 'Alto';

  @override
  String get jazzPreset => 'Preajuste de jazz';

  @override
  String get jazzPresetStandardsCore => 'Núcleo de estándares';

  @override
  String get jazzPresetModulationStudy => 'Estudio de modulación';

  @override
  String get jazzPresetAdvanced => 'Avanzado';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Estándar de libro falso';

  @override
  String get sourceProfileRecordingInspired => 'Grabación inspirada';

  @override
  String get smartDiagnostics => 'Diagnóstico inteligente';

  @override
  String get smartDiagnosticsHelp =>
      'Registra los seguimientos de decisiones Smart Generator para la depuración.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Seleccione al menos una tecla para usar el modo Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones que no son diatónico están disponibles solo en modo clave.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Sustituto dominante';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal sólo aparece en modo clave, por lo que esta opción está deshabilitada en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get keyCenterLabelStyle => 'Estilo de etiqueta clave';

  @override
  String get keyCenterLabelStyleHelp =>
      'Elija entre nombres de modo explícitos y etiquetas tónicas clásicas en mayúsculas/minúsculas.';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Cambia solo la capa de visualización. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compacto';

  @override
  String get styleMajText => 'MajTexto';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get keyCenterLabelStyleModeText => 'Do mayor: / Do menor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C:/c:';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get chordTypeFilters => 'Tipos de acordes';

  @override
  String get chordTypeFiltersHelp =>
      'Elige que tipos de acordes pueden aparecer en el generador.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total activados';
  }

  @override
  String get chordTypeGroupTriads => 'Triadas';

  @override
  String get chordTypeGroupSevenths => 'Septimas';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sextas y notas anadidas';

  @override
  String get chordTypeGroupDominantVariants => 'Variantes dominantes';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 solo esta disponible cuando se selecciona al menos una tonalidad.';

  @override
  String get chordTypeKeepOneEnabled =>
      'Manten al menos un tipo de acorde activado.';

  @override
  String get tensionHelp =>
      'Perfil número romano y chips seleccionados únicamente';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Habilitar inversiones';

  @override
  String get inversionHelp =>
      'Representación aleatoria de graves después de la selección de acordes; no rastrea el bajo anterior.';

  @override
  String get firstInversion => '1ra inversión';

  @override
  String get secondInversion => '2da inversión';

  @override
  String get thirdInversion => '3ra inversión';

  @override
  String get keyPracticeOverview =>
      'Descripción general de las prácticas clave';

  @override
  String get freePracticeOverview => 'Descripción general de la práctica libre';

  @override
  String get keyModeTag => 'Modo clave';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las claves';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Presione Siguiente acorde para comenzar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Utiliza las 12 raíces cromáticas con cualidades de acordes aleatorios para una práctica de lectura amplia.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo función armónica en las teclas seleccionadas al tiempo que permite un movimiento elegante del generador inteligente.';

  @override
  String get keyPracticeDescription =>
      'Utiliza las claves seleccionadas y los número romano habilitados para generar material de práctica diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Espacio: siguiente acorde Enter: iniciar o pausar la reproducción automática Arriba/Abajo: ajustar BPM';

  @override
  String get currentChord => 'Acorde actual';

  @override
  String get nextChord => 'Acorde siguiente';

  @override
  String get audioPlayChord => 'tocar acorde';

  @override
  String get audioPlayArpeggio => 'Tocar arpegio';

  @override
  String get audioPlayProgression => 'Progresión del juego';

  @override
  String get audioPlayPrompt => 'Reproducir mensaje';

  @override
  String get startAutoplay => 'Iniciar reproducción automática';

  @override
  String get pauseAutoplay => 'Pausar reproducción automática';

  @override
  String get stopAutoplay => 'Detener la reproducción automática';

  @override
  String get resetGeneratedChords => 'Reiniciar acordes generados';

  @override
  String get decreaseBpm => 'Disminuir BPM';

  @override
  String get increaseBpm => 'Aumentar BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min-$max';
  }

  @override
  String get modeMajor => 'importante';

  @override
  String get modeMinor => 'menor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Sugerencias de voicings';

  @override
  String get voicingSuggestionsSubtitle =>
      'Vea opciones de notas concretas para este acorde.';

  @override
  String get voicingSuggestionsEnabled => 'Habilitar sugerencias de voz';

  @override
  String get voicingSuggestionsHelp =>
      'Muestra tres ideas voicing a nivel de nota reproducibles para el acorde actual.';

  @override
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

  @override
  String get voicingComplexity => 'Complejidad de expresión';

  @override
  String get voicingComplexityHelp =>
      'Controla el color que pueden llegar a tener las sugerencias.';

  @override
  String get voicingComplexityBasic => 'Básico';

  @override
  String get voicingComplexityStandard => 'Estándar';

  @override
  String get voicingComplexityModern => 'Moderno';

  @override
  String get voicingTopNotePreference => 'Preferencia de nota superior';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Inclina sugerencias hacia un línea superior elegido. Los voicing bloqueados ganan primero, luego los acordes repetidos lo mantienen estable.';

  @override
  String get voicingTopNotePreferenceAuto => 'Automático';

  @override
  String get allowRootlessVoicings => 'Permitir voces desarraigadas';

  @override
  String get allowRootlessVoicingsHelp =>
      'Permitamos que las sugerencias omitan la raíz cuando los nota guía permanezcan claros.';

  @override
  String get maxVoicingNotes => 'Notas de voz máximas';

  @override
  String get lookAheadDepth => 'Profundidad de anticipación';

  @override
  String get lookAheadDepthHelp =>
      'Cuántos acordes futuros puede considerar el ranking.';

  @override
  String get showVoicingReasons => 'Mostrar razones para expresar';

  @override
  String get showVoicingReasonsHelp =>
      'Muestra breves fichas explicativas en cada tarjeta de sugerencias.';

  @override
  String get voicingSuggestionNatural => 'más natural';

  @override
  String get voicingSuggestionColorful => 'más colorido';

  @override
  String get voicingSuggestionEasy => 'mas facil';

  @override
  String get voicingSuggestionNaturalSubtitle => 'Primero la voz principal';

  @override
  String get voicingSuggestionColorfulSubtitle =>
      'Se inclina hacia los tonos de color.';

  @override
  String get voicingSuggestionEasySubtitle => 'Forma de mano compacta';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle =>
      'Conexión y resolución primero.';

  @override
  String get voicingSuggestionNaturalStableSubtitle =>
      'Misma forma, competición constante';

  @override
  String get voicingSuggestionTopLineSubtitle =>
      'Clientes potenciales de primera línea';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle =>
      'Tensión alterada en la delantera';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'Color cuarto moderno';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Borde sub-tritono con nota guía brillantes';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      'Tonos guía con extensiones brillantes.';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle =>
      'Tonos centrales, menor alcance';

  @override
  String get voicingSuggestionEasyStableSubtitle =>
      'Forma de mano fácil de repetir';

  @override
  String get voicingPerformanceSubtitle =>
      'Feature one representative comping shape and keep the next move in view.';

  @override
  String get voicingPerformanceCurrentTitle => 'Current voicing';

  @override
  String get voicingPerformanceNextTitle => 'Next preview';

  @override
  String get voicingPerformanceCurrentOnly => 'Current only';

  @override
  String get voicingPerformanceShared => 'Shared';

  @override
  String get voicingPerformanceNextOnly => 'Next move';

  @override
  String voicingPerformanceTopLinePath(Object current, Object next) {
    return 'Top line: $current -> $next';
  }

  @override
  String get voicingTopNoteLabel => 'Arriba';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'Objetivo de línea superior: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Bloqueado línea superior: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'línea superior repetido: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'línea superior más cercano a $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No hay línea superior exacto para $note';
  }

  @override
  String get voicingFamilyShell => 'Caparazón';

  @override
  String get voicingFamilyRootlessA => 'Sin raíces A';

  @override
  String get voicingFamilyRootlessB => 'Sin raíces B';

  @override
  String get voicingFamilySpread => 'Desparramar';

  @override
  String get voicingFamilySus => 'sus';

  @override
  String get voicingFamilyQuartal => 'cuarto';

  @override
  String get voicingFamilyAltered => 'alterado';

  @override
  String get voicingFamilyUpperStructure => 'Estructura superior';

  @override
  String get voicingLockSuggestion => 'Sugerencia de bloqueo';

  @override
  String get voicingUnlockSuggestion => 'Sugerencia de desbloqueo';

  @override
  String get voicingSelected => 'Seleccionado';

  @override
  String get voicingLocked => 'bloqueado';

  @override
  String get voicingReasonEssentialCore => 'Tonos esenciales cubiertos';

  @override
  String get voicingReasonGuideToneAnchor => '3.º/7.º ancla';

  @override
  String voicingReasonGuideResolution(int count) {
    return 'El tono guía $count se resuelve';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return 'Se mantienen los tonos comunes $count';
  }

  @override
  String get voicingReasonStableRepeat => 'Repetición estable';

  @override
  String get voicingReasonTopLineTarget => 'Objetivo de primera línea';

  @override
  String get voicingReasonLowMudAvoided => 'Claridad de registro bajo';

  @override
  String get voicingReasonCompactReach => 'Alcance cómodo';

  @override
  String get voicingReasonBassAnchor => 'Ancla de bajo respetada';

  @override
  String get voicingReasonNextChordReady => 'Siguiente acorde listo';

  @override
  String get voicingReasonAlteredColor => 'Tensiones alteradas';

  @override
  String get voicingReasonRootlessClarity => 'Forma ligera y sin raíces.';

  @override
  String get voicingReasonSusRelease => 'Configuración de lanzamiento de Sus';

  @override
  String get voicingReasonQuartalColor => 'color cuarto';

  @override
  String get voicingReasonUpperStructureColor =>
      'Color de la estructura superior';

  @override
  String get voicingReasonTritoneSubFlavor => 'Sabor sub-tritono';

  @override
  String get voicingReasonLockedContinuity => 'Continuidad bloqueada';

  @override
  String get voicingReasonGentleMotion => 'Movimiento suave de la mano';

  @override
  String get mainMenuIntro =>
      'Genera tu siguiente loop de acordes en Chordest y usa el Analyzer solo cuando necesites una lectura armónica cautelosa.';

  @override
  String get mainMenuGeneratorTitle => 'Generador Chordest';

  @override
  String get mainMenuGeneratorDescription =>
      'Empieza con un loop tocable, ayuda de voicings y controles rápidos de práctica.';

  @override
  String get openGenerator => 'Empezar práctica';

  @override
  String get openAnalyzer => 'Analizar progresión';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Consulta tonalidades probables, números romanos y avisos con una lectura conservadora.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Estudio de armonía';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Retoma lecciones, repasa capítulos y fortalece tu armonía práctica.';

  @override
  String get openStudyHarmony => 'Empezar armonía';

  @override
  String get studyHarmonyTitle => 'Estudio de armonía';

  @override
  String get studyHarmonySubtitle =>
      'Trabaje a través de un centro de armonía estructurado con entradas rápidas de lecciones y progreso de capítulos.';

  @override
  String get studyHarmonyPlaceholderTag => 'cubierta de estudio';

  @override
  String get studyHarmonyPlaceholderBody =>
      'Los datos de las lecciones, las indicaciones y las superficies de respuestas ya comparten un flujo de estudio reutilizable para notas, acordes, escalas y ejercicios de progresión.';

  @override
  String get studyHarmonyTestLevelTag => 'Ejercicio de practica';

  @override
  String get studyHarmonyTestLevelAction => 'taladro abierto';

  @override
  String get studyHarmonySubmit => 'Entregar';

  @override
  String get studyHarmonyNextPrompt => 'Siguiente mensaje';

  @override
  String get studyHarmonySelectedAnswers => 'Respuestas seleccionadas';

  @override
  String get studyHarmonySelectionEmpty =>
      'Aún no se han seleccionado respuestas.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total correcto';
  }

  @override
  String get studyHarmonyAttempts => 'Intentos';

  @override
  String get studyHarmonyAccuracy => 'Exactitud';

  @override
  String get studyHarmonyElapsedTime => 'Tiempo';

  @override
  String get studyHarmonyObjective => 'Meta';

  @override
  String get studyHarmonyPromptInstruction =>
      'Elige la respuesta correspondiente';

  @override
  String get studyHarmonyNeedSelection =>
      'Elija al menos una respuesta antes de enviar.';

  @override
  String get studyHarmonyCorrectLabel => 'Correcto';

  @override
  String get studyHarmonyIncorrectLabel => 'Incorrecto';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return 'Correcto. $answer fue la respuesta correcta.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return 'Incorrecto. $answer fue la respuesta correcta y perdiste una vida.';
  }

  @override
  String get studyHarmonyGameOverTitle => 'Juego terminado';

  @override
  String get studyHarmonyGameOverBody =>
      'Las tres vidas se han ido. Vuelva a intentar este nivel o regrese al centro Estudio de armonía.';

  @override
  String get studyHarmonyLevelCompleteTitle => 'Nivel superado';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'Has alcanzado el objetivo de la lección. Verifique su precisión y tiempo claro a continuación.';

  @override
  String get studyHarmonyBackToHub => 'Volver a Estudio de armonía';

  @override
  String get studyHarmonyRetry => 'Rever';

  @override
  String get studyHarmonyHubHeroEyebrow => 'Centro de estudios';

  @override
  String get studyHarmonyHubHeroBody =>
      'Utilice Continuar para retomar el impulso, Revisar para volver a visitar los puntos débiles y Diariamente para obtener una lección determinista de su camino desbloqueado.';

  @override
  String get studyHarmonyTrackFilterLabel => 'Rutas';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Base';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Clásica';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return 'Capítulos $cleared/$total completados';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return 'Habilidades $mastered/$total dominadas';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count revisiones listas';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'Racha x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count se ejecuta';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'Mejor $rank';
  }

  @override
  String get studyHarmonyBossTag => 'Jefe';

  @override
  String get studyHarmonyContinueCardTitle => 'Continuar';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Reanude la lección que tocó más recientemente.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Salta a la siguiente lección de tu frontera actual.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return 'Continuar: $lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => 'Continuar';

  @override
  String get studyHarmonyReviewCardTitle => 'Repaso';

  @override
  String get studyHarmonyReviewQueueHint => 'Sale de tu cola de repaso actual.';

  @override
  String get studyHarmonyReviewWeakHint =>
      'Sale del resultado más flojo entre tus lecciones jugadas.';

  @override
  String get studyHarmonyReviewFallbackHint =>
      'Aún no hay deuda de repaso, así que volvemos a tu frontera actual.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      'Esta lección pide otro intento tras un fallo o una sesión sin cerrar.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      'Esta lección está en cola para un repaso rápido de precisión.';

  @override
  String get studyHarmonyReviewAction => 'Repasar';

  @override
  String get studyHarmonyDailyCardTitle => 'Desafío diario';

  @override
  String get studyHarmonyDailyCardHint =>
      'Abra la selección determinista de hoy de sus lecciones desbloqueadas.';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      'La diaria de hoy ya está superada. Si quieres, vuelve a jugarla, o regresa mañana para cuidar la racha.';

  @override
  String get studyHarmonyDailyAction => 'Jugar diaria';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Semilla $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => 'Borrado diariamente hoy';

  @override
  String get studyHarmonyReviewSessionTitle => 'Revisión de puntos débiles';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return 'Combine una breve reseña sobre $chapterTitle y sus habilidades recientes más débiles.';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'Desafío diario';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return 'Juega la mezcla inicial de hoy creada a partir de $chapterTitle y tu frontera actual.';
  }

  @override
  String get studyHarmonyModeLesson => 'Modo de lección';

  @override
  String get studyHarmonyModeReview => 'Modo de revisión';

  @override
  String get studyHarmonyModeDaily => 'Modo diario';

  @override
  String get studyHarmonyModeLegacy => 'Modo de práctica';

  @override
  String get studyHarmonyShortcutHint =>
      'Ingrese envíos o continúe. R se reinicia. 1-9 elige una respuesta. Tab y Shift+Tab mueven el foco.';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$remaining de $total vidas restantes';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'Ganancias de habilidades';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Enfoque de revisión';

  @override
  String get studyHarmonyResultRewardTitle => 'Recompensa de sesión';

  @override
  String get studyHarmonyBonusGoalsTitle => 'Objetivos de bonificación';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'Rango $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return 'Mejores estrellas $rank · $stars';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return 'Racha diaria x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => 'Nueva marca personal';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded =>
      'Motivo de la revisión: es necesario volver a intentarlo';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh =>
      'Motivo de la revisión: actualización de precisión';

  @override
  String get studyHarmonyReviewReasonLowMastery =>
      'Motivo de la revisión: bajo dominio';

  @override
  String get studyHarmonyReviewReasonStaleSkill =>
      'Motivo de la revisión: habilidad obsoleta';

  @override
  String get studyHarmonyReviewReasonWeakSpot =>
      'Motivo de la revisión: punto débil';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh =>
      'Motivo de la revisión: actualización de frontera';

  @override
  String get studyHarmonyQuestBoardTitle => 'Tablero de misiones';

  @override
  String get studyHarmonyQuestCompletedTag => 'Terminado';

  @override
  String get studyHarmonyQuestTodayTag => 'Hoy';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target completo';
  }

  @override
  String get studyHarmonyQuestDailyTitle => 'Racha diaria';

  @override
  String get studyHarmonyQuestDailyBody =>
      'Completa la mezcla sembrada de hoy para alargar tu racha.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      'La diaria de hoy ya está completada. La racha está a salvo por ahora.';

  @override
  String get studyHarmonyQuestFrontierTitle => 'Empuje fronterizo';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return 'Supera $lessonTitle para empujar la ruta hacia delante.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'Ya superaste todas las lecciones desbloqueadas por ahora. Repite un jefe o ve por más estrellas.';

  @override
  String get studyHarmonyQuestStarsTitle => 'caza de estrellas';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return 'Empuja estrellas adicionales dentro de $chapterTitle.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback =>
      'Empuja estrellas adicionales en tu capítulo actual.';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'Combinado x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'Mejor combinación x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'Mantenga todos los corazones';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return 'Alcance $percent% de precisión';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'Alcanza el combo x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'barrido de bonificación';

  @override
  String get studyHarmonySkillNoteRead => 'Lectura de notas';

  @override
  String get studyHarmonySkillNoteFindKeyboard =>
      'Búsqueda de notas del teclado';

  @override
  String get studyHarmonySkillNoteAccidentals => 'Sostenidos y bemoles';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'Símbolo de acorde a teclas';

  @override
  String get studyHarmonySkillChordNameFromTones => 'Nomenclatura de acordes';

  @override
  String get studyHarmonySkillScaleBuild => 'Construcción a escala';

  @override
  String get studyHarmonySkillRomanRealize => 'Realización de número romano';

  @override
  String get studyHarmonySkillRomanIdentify => 'Identificación número romano';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'diatonicidad';

  @override
  String get studyHarmonySkillHarmonyFunction =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonySkillProgressionKeyCenter => 'Progresión centro tonal';

  @override
  String get studyHarmonySkillProgressionFunction =>
      'Lectura de la función de progresión';

  @override
  String get studyHarmonySkillProgressionNonDiatonic =>
      'Detección de progresión no diatónico';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'Relleno de progresión';

  @override
  String get studyHarmonyHubChapterSectionTitle => 'Capítulos';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return 'Lecciones $count';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count borrado';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'capitulo abierto';

  @override
  String get studyHarmonyLockedChapterTag => 'Capítulo bloqueado';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return 'Siguiente: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return 'Esta pista todavía está bloqueada. Vuelve a $coreTrack para seguir estudiando hoy.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Ruta base';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Comience con notas y el teclado, luego avance a través de acordes, escalas, conceptos básicos de número romano, diatónico y análisis de progresión breve.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Capítulo 1: Notas y teclado';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Asigne nombres de notas al teclado y siéntase cómodo con las teclas blancas y las alteraciones simples.';

  @override
  String get studyHarmonyChapterChordsTitle =>
      'Capítulo 2: Conceptos básicos de acordes';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Deletrea tríadas y séptimas básicas, luego nombra formas de acordes comunes a partir de sus tonos.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Capítulo 3: Escalas y claves';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Construya escalas mayores y menores, luego determine qué tonos pertenecen dentro de una clave.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Capítulo 4: Números romanos y diatonicidad';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Convierta número romano simples en acordes, identifíquelos a partir de acordes y ordene los conceptos básicos de diatónico por función.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Capítulo 5: Detective de progresión I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      'Lea progresiones básicas breves, encuentre el centro tonal probable y detecte la función de acorde o alguna extraña.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Capítulo 6: Acorde faltante I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      'Llene un espacio en blanco dentro de una breve progresión y aprenda hacia dónde quieren ir la cadencia y la función a continuación.';

  @override
  String get studyHarmonyOpenLessonAction => 'Abrir lección';

  @override
  String get studyHarmonyLockedLessonAction => 'Bloqueado';

  @override
  String get studyHarmonyClearedTag => 'Superada';

  @override
  String get studyHarmonyComingSoonTag => 'Próximamente';

  @override
  String get studyHarmonyPopTrackTitle => 'Ruta pop';

  @override
  String get studyHarmonyPopTrackDescription =>
      'Recorre toda la ruta de armonía en una vía pop con su propio progreso, elección diaria y cola de repaso.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Ruta de jazz';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practica todo el plan de estudios en una vía jazz con progreso, elección diaria y cola de repaso separados.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Ruta clásica';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Estudia todo el plan de estudios en una vía clásica con progreso, elección diaria y cola de repaso independientes.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Práctica rápida';

  @override
  String get studyHarmonyObjectiveBossReview => 'Repaso de jefe';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle =>
      'Búsqueda de notas de tecla blanca';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Lea los nombres de las notas y toque la tecla blanca correspondiente.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Nombra la nota resaltada';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Mire una tecla resaltada y elija el nombre de nota correcto.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle =>
      'Llaves negras y gemelos';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Eche un primer vistazo a la ortografía aguda y plana de las teclas negras.';

  @override
  String get studyHarmonyLessonNotesBossTitle =>
      'Jefe: Búsqueda rápida de notas';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mezcle la lectura de notas y la búsqueda de teclado en una ronda corta y rápida.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Tríadas en el teclado';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Cree tríadas comunes mayores, menores y disminuidas directamente en el teclado.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => 'Séptimas en el teclado';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Agrega la séptima y deletrea algunos acordes de séptima comunes en el teclado.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Nombra el acorde resaltado';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Lea una forma de acorde resaltada y elija el nombre del acorde correcto.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Jefe: Revisión de tríadas y séptimas';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Cambie entre la ortografía y la denominación de acordes en una revisión mixta.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Construir escalas mayores';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Elija cada tono que pertenezca a una escala mayor simple.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Construir escalas menores';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Construya escalas menores naturales y menores armónicas a partir de algunas tonalidades comunes.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Membresía clave';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Encuentre qué tonos pertenecen dentro de una clave con nombre.';

  @override
  String get studyHarmonyLessonScalesBossTitle =>
      'Jefe: Reparación de básculas';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Combine construcción de escala y membresía clave en una breve ronda de reparación.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Romano a acorde';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Lea una clave y número romano, luego elija el acorde correspondiente.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Acorde a romano';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Lea un acorde dentro de una clave y elija el número romano correspondiente.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatónico o no';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Ordene acordes en respuestas diatónico y no diatónico en claves simples.';

  @override
  String get studyHarmonyLessonFunctionTitle =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Clasifica los acordes fáciles como tónicos, predominante o dominantes.';

  @override
  String get studyHarmonyLessonRomanBossTitle =>
      'Jefe: Mezcla de conceptos básicos funcionales';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Revise romano a acorde, acorde a romano, diatónicoity y funcionen juntos.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle =>
      'Encuentra el centro clave';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      'Lea una breve progresión y elija el centro tonal que tenga más sentido.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle =>
      'Función en contexto';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      'Concéntrate en un acorde resaltado y nombra su función dentro de una progresión corta.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle =>
      'Encuentra al forastero';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'Localice el único acorde que queda fuera de la lectura principal diatónico.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Jefe: Análisis Mixto';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'Combine lectura del centro de claves, detección de funciones y detección de no diatónico en una breve ronda de detectives.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle =>
      'Completa el acorde que falta';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'Complete una breve progresión de cuatro acordes eligiendo el acorde que mejor se adapte a la función local.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle =>
      'Relleno de cadencia';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'Utilice la atracción hacia una cadencia para elegir el acorde que falta cerca del final de una frase.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Jefe: relleno mixto';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'Resuelva un breve conjunto de preguntas de progresión para completar con un poco más de presión armónica.';

  @override
  String get studyHarmonyChapterCheckpointTitle =>
      'Guantelete de punto de control';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'Combine ejercicios de centro de clave, función, color y relleno en conjuntos de revisión mixtos más rápidos.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle =>
      'Acometida de cadencia';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      'Lea rápidamente la función armónica y luego conecte el acorde cadencial que falta ejerciendo una ligera presión.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle =>
      'Cambio de color y clave';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'Cambie entre detección central y llamadas de color no diatónico sin perder el hilo.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle =>
      'Jefe: Guantelete del punto de control';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'Borre un punto de control integrado que combina indicaciones de reparación de centro de clave, función, color y cadencia.';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'Pruebas finales';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'Termine el camino principal con rondas de progresión mixta más difíciles que requieren velocidad, audición de colores y opciones de resolución limpia.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'Relevo de respuesta';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'Cambie entre lectura de funciones y reparación de acordes faltantes mediante cambios compactos.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle =>
      'Llamadas de colores prestados';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'Capte el color modal rápidamente y luego confirme el centro tonal antes de que desaparezca.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle =>
      'Laboratorio de resolución';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      'Realice un seguimiento de dónde quiere aterrizar cada frase y elija el acorde que mejor resuelva el movimiento.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle =>
      'Jefe: Examen de progresión final';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'Apruebe un examen final mixto con centro, función, color y resolución, todo bajo presión.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Encuentra $note en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      '¿Qué nota está resaltada?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Construya $chord en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      '¿Qué acorde está resaltado?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Elige cada nota en $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Elige las notas que pertenecen a $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'En $keyName, ¿qué acorde coincide con $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'En $keyName, ¿qué número romano coincide con $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'En $keyName, ¿$chord es diatónico?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'En $keyName, ¿qué función tiene $chord?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => 'Progresión';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '¿Qué centro tonal se adapta mejor a esta progresión?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '¿Qué función juega $chord aquí?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '¿Qué acorde se siente menos diatónico en esta progresión?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '¿Qué acorde llena mejor el espacio en blanco?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'One likely reading keeps this progression centered on $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can be heard as a $functionLabel chord in this context.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord sits outside the main $keyLabel reading, so it stands out as a plausible non-diatonic color.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can restore some of the expected $functionLabel pull in this progression.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic menor natural';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic armónico menor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic menor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatónico';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'No diatónico';

  @override
  String get studyHarmonyChoiceTonic => 'Tónico';

  @override
  String get studyHarmonyChoicePredominant => 'Predominante';

  @override
  String get studyHarmonyChoiceDominant => 'Dominante';

  @override
  String get studyHarmonyChoiceOther => 'Otro';

  @override
  String get chordAnalyzerTitle => 'Analizador de acordes';

  @override
  String get chordAnalyzerSubtitle =>
      'Pega una progresión para obtener una lectura conservadora de tonalidades probables, números romanos y función armónica.';

  @override
  String get chordAnalyzerInputLabel => 'Progresión de acordes';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Fuera de paréntesis, puedes separar acordes con espacios, | o comas. Las comas dentro de paréntesis se mantienen dentro del mismo acorde.\n\nUsa ? para un hueco de acorde desconocido. El analizador inferirá la opción más natural según el contexto y mostrará alternativas si la lectura es ambigua.\n\nSe admiten fundamentales en minúscula, bajo con barra, formas sus/alt/add y tensiones como C7(b9, #11).\n\nEn dispositivos táctiles puedes usar el pad de acordes o cambiar a la entrada ABC cuando necesites escribir libremente.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Consejos de entrada';

  @override
  String get chordAnalyzerAnalyze => 'Analizar';

  @override
  String get chordAnalyzerKeyboardTitle => 'Pad de acordes';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Toca los tokens para armar una progresión. La entrada ABC mantiene disponible el teclado del sistema cuando necesitas escribir libremente.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Escribe, pega o toca tokens para insertarlos en la posición del cursor.';

  @override
  String get chordAnalyzerChordPad => 'Panel';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => 'Pegar';

  @override
  String get chordAnalyzerClear => 'Reiniciar';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'Espacio';

  @override
  String get chordAnalyzerAnalyzing => 'Analizando progresión...';

  @override
  String get chordAnalyzerInitialTitle => 'Empieza con una progresión';

  @override
  String get chordAnalyzerInitialBody =>
      'Introduce una progresión como Dm7, G7 | ? Am o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos, avisos, rellenos inferidos y un breve resumen.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'Este ? se infirió del contexto armónico circundante, así que tómalo como un relleno sugerido y no como una certeza.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Relleno sugerido: $chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => 'Tonalidades detectadas';

  @override
  String get chordAnalyzerPrimaryReading => 'Lectura principal';

  @override
  String get chordAnalyzerAlternativeReading => 'Lectura alternativa';

  @override
  String get chordAnalyzerChordAnalysis => 'Análisis acorde por acorde';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return 'Compás $index';
  }

  @override
  String get chordAnalyzerProgressionSummary => 'Resumen de la progresión';

  @override
  String get chordAnalyzerWarnings => 'Advertencias y ambigüedades';

  @override
  String get chordAnalyzerNoInputError =>
      'Introduce una progresión de acordes para analizarla.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      'No se encontraron acordes reconocibles en la progresión.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return 'Se omitieron algunos símbolos: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'El centro tonal sigue siendo algo ambiguo entre $primary y $alternative.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'Algunos acordes siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerFunctionTonic => 'Tónica';

  @override
  String get chordAnalyzerFunctionPredominant => 'Predominante';

  @override
  String get chordAnalyzerFunctionDominant => 'Dominante';

  @override
  String get chordAnalyzerFunctionOther => 'Otro';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return 'Posible dominante secundaria dirigida a $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Posible sustitución por tritono dirigida a $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Posible intercambio modal desde el menor paralelo.';

  @override
  String get chordAnalyzerRemarkAmbiguous =>
      'Este acorde sigue siendo ambiguo en la lectura actual.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'Este acorde sigue sin resolverse con las heurísticas conservadoras actuales.';

  @override
  String get chordAnalyzerTagIiVI => 'cadencia ii-V-I';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => 'resolución dominante';

  @override
  String get chordAnalyzerTagPlagalColor => 'color plagal/modal';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'Esta progresión se centra muy probablemente en $key.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return 'Una lectura alternativa es $key.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'Sugiere un $tag.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from y $through se comportan como acordes de $fromFunction y $throughFunction que conducen hacia $target.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord puede oírse como una posible dominante secundaria que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord puede oírse como un posible sustituto por tritono que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord añade un posible color de intercambio modal.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      'Algunos detalles siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerExamplesTitle => 'Ejemplos';

  @override
  String get chordAnalyzerConfidenceLabel => 'Confianza';

  @override
  String get chordAnalyzerAmbiguityLabel => 'Ambigüedad';

  @override
  String get chordAnalyzerWhyThisReading => 'Por qué esta lectura';

  @override
  String get chordAnalyzerCompetingReadings => 'También plausible';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return 'Modificadores ignorados: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => 'Crear variaciones';

  @override
  String get chordAnalyzerVariationsTitle => 'Variaciones naturales';

  @override
  String get chordAnalyzerVariationsBody =>
      'Estas opciones reharmonizan el mismo flujo con sustituciones funcionales cercanas. Aplica una para volver a analizarla al instante.';

  @override
  String get chordAnalyzerApplyVariation => 'Usar variación';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Color cadencial';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Oscurece el predominante y cambia el dominante por un sustituto por tritono sin mover la llegada.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Color backdoor';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Usa el color ivm7-bVII7 del menor paralelo antes de caer en la misma tónica.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'ii-V dirigido';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Construye un ii-V relacionado que sigue apuntando al mismo acorde de destino.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle =>
      'Color de cadencia menor';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Mantiene la cadencia menor, pero se inclina hacia el color iiø-Valt-i.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Realce de color';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Mantiene cercanos la raíz y la función, pero eleva los acordes con extensiones naturales.';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return 'Advertencia de entrada: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      'Los paréntesis desequilibrados dejaron parte del símbolo en duda.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'Se ignoró un paréntesis de cierre inesperado.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'El color explícito de $extension refuerza esta lectura.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'El color de dominante alterada respalda una función dominante.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'El bajo con barra $bass mantiene significativo el movimiento del bajo o la inversión.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'El siguiente acorde respalda una resolución hacia $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'Este color puede oírse como prestado del modo paralelo.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'El color de suspensión suaviza la atracción dominante sin borrarla.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Lectura de baja confianza';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'Las tonalidades candidatas están muy próximas o algunos símbolos solo se recuperaron de forma parcial, así que tómalo como una primera lectura cautelosa.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'Este compás está vacío y se conservó en el conteo.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No se recuperaron símbolos de acorde analizables en este compás.';

  @override
  String get chordAnalyzerParseIssuesTitle => 'Problemas de análisis';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => 'Token vacío.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot =>
      'No se pudo reconocer la fundamental.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root no es una grafía de fundamental admitida.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'El bajo con barra $bass no es una grafía de bajo admitida.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Sufijo o modificador no admitido: $suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

  @override
  String get chordAnalyzerQuickStartHint =>
      'Tap an example to see instant results, or press Ctrl+Enter on desktop to analyze.';

  @override
  String get chordAnalyzerDetailLevel => 'Explanation detail';

  @override
  String get chordAnalyzerDetailLevelConcise => 'Concise';

  @override
  String get chordAnalyzerDetailLevelDetailed => 'Detailed';

  @override
  String get chordAnalyzerDetailLevelAdvanced => 'Advanced';

  @override
  String get chordAnalyzerHighlightTheme => 'Highlight theme';

  @override
  String get chordAnalyzerThemePresetDefault => 'Default';

  @override
  String get chordAnalyzerThemePresetHighContrast => 'High contrast';

  @override
  String get chordAnalyzerThemePresetColorBlindSafe => 'Color-blind safe';

  @override
  String get chordAnalyzerThemePresetCustom => 'Custom';

  @override
  String get chordAnalyzerThemeLegend => 'Category legend';

  @override
  String get chordAnalyzerCustomColors => 'Custom category colors';

  @override
  String get chordAnalyzerHighlightAppliedDominant => 'Applied dominant';

  @override
  String get chordAnalyzerHighlightTritoneSubstitute => 'Tritone substitute';

  @override
  String get chordAnalyzerHighlightTonicization => 'Tonicization';

  @override
  String get chordAnalyzerHighlightModulation => 'Modulation';

  @override
  String get chordAnalyzerHighlightBackdoor => 'Backdoor / subdominant minor';

  @override
  String get chordAnalyzerHighlightBorrowedColor => 'Borrowed color';

  @override
  String get chordAnalyzerHighlightCommonTone => 'Common-tone motion';

  @override
  String get chordAnalyzerHighlightDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerHighlightChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerHighlightAmbiguity => 'Ambiguity';

  @override
  String chordAnalyzerSummaryRealModulation(Object key) {
    return 'It makes a stronger case for a real modulation toward $key.';
  }

  @override
  String chordAnalyzerSummaryTonicization(Object target) {
    return 'It briefly tonicizes $target without fully settling there.';
  }

  @override
  String get chordAnalyzerSummaryBackdoor =>
      'The progression leans into backdoor or subdominant-minor color before resolving.';

  @override
  String get chordAnalyzerSummaryDeceptiveCadence =>
      'One cadence sidesteps the expected tonic for a deceptive effect.';

  @override
  String get chordAnalyzerSummaryChromaticLine =>
      'A chromatic inner-line or line-cliche color helps connect part of the phrase.';

  @override
  String chordAnalyzerSummaryBackdoorDominant(Object chord) {
    return '$chord works like a backdoor dominant rather than a plain borrowed dominant.';
  }

  @override
  String chordAnalyzerSummarySubdominantMinor(Object chord) {
    return '$chord reads more naturally as subdominant-minor color than as a random non-diatonic chord.';
  }

  @override
  String chordAnalyzerSummaryCommonToneDiminished(Object chord) {
    return '$chord can be heard as a common-tone diminished color that resolves by shared pitch content.';
  }

  @override
  String chordAnalyzerSummaryDeceptiveTarget(Object chord) {
    return '$chord participates in a deceptive landing instead of a plain authentic cadence.';
  }

  @override
  String chordAnalyzerSummaryCompeting(Object readings) {
    return 'An advanced reading keeps competing interpretations in play, such as $readings.';
  }

  @override
  String chordAnalyzerFunctionLine(Object function) {
    return 'Function: $function';
  }

  @override
  String chordAnalyzerEvidenceLead(Object evidence) {
    return 'Evidence: $evidence';
  }

  @override
  String chordAnalyzerAdvancedCompetingReadings(Object readings) {
    return 'Competing readings remain possible here: $readings.';
  }

  @override
  String chordAnalyzerRemarkTonicization(Object target) {
    return 'This sounds more like a local tonicization of $target than a full modulation.';
  }

  @override
  String chordAnalyzerRemarkRealModulation(Object key) {
    return 'This supports a real modulation toward $key.';
  }

  @override
  String get chordAnalyzerRemarkBackdoorDominant =>
      'This can be heard as a backdoor dominant with subdominant-minor color.';

  @override
  String get chordAnalyzerRemarkBackdoorChain =>
      'This belongs to a backdoor chain rather than a plain borrowed detour.';

  @override
  String get chordAnalyzerRemarkSubdominantMinor =>
      'This borrowed iv or subdominant-minor color behaves like a predominant area.';

  @override
  String get chordAnalyzerRemarkCommonToneDiminished =>
      'This diminished chord works through common-tone reinterpretation.';

  @override
  String get chordAnalyzerRemarkPivotChord =>
      'This chord can act as a pivot into the next local key area.';

  @override
  String get chordAnalyzerRemarkCommonToneModulation =>
      'Common-tone continuity helps the modulation feel plausible.';

  @override
  String get chordAnalyzerRemarkDeceptiveCadence =>
      'This points toward a deceptive cadence rather than a direct tonic arrival.';

  @override
  String get chordAnalyzerRemarkLineCliche =>
      'Chromatic inner-line motion colors this chord choice.';

  @override
  String get chordAnalyzerRemarkDualFunction =>
      'More than one functional reading stays credible here.';

  @override
  String get chordAnalyzerTagTonicization => 'Tonicization';

  @override
  String get chordAnalyzerTagRealModulation => 'Real modulation';

  @override
  String get chordAnalyzerTagBackdoorChain => 'Backdoor chain';

  @override
  String get chordAnalyzerTagDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerTagChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerTagCommonToneMotion => 'Common-tone motion';

  @override
  String get chordAnalyzerEvidenceCadentialArrival =>
      'A local cadential arrival supports hearing a temporary target.';

  @override
  String get chordAnalyzerEvidenceFollowThrough =>
      'Follow-through chords continue to support the new local center.';

  @override
  String get chordAnalyzerEvidencePhraseBoundary =>
      'The change lands near a phrase boundary or structural accent.';

  @override
  String get chordAnalyzerEvidencePivotSupport =>
      'A pivot-like shared reading supports the local shift.';

  @override
  String get chordAnalyzerEvidenceCommonToneSupport =>
      'Shared common tones help connect the reinterpretation.';

  @override
  String get chordAnalyzerEvidenceHomeGravityWeakening =>
      'The original tonic loses some of its pull in this window.';

  @override
  String get chordAnalyzerEvidenceBackdoorMotion =>
      'The motion matches a backdoor or subdominant-minor resolution pattern.';

  @override
  String get chordAnalyzerEvidenceDeceptiveResolution =>
      'The dominant resolves away from the expected tonic target.';

  @override
  String chordAnalyzerEvidenceChromaticLine(Object detail) {
    return 'Chromatic line support: $detail.';
  }

  @override
  String chordAnalyzerEvidenceCompetingReading(Object detail) {
    return 'Competing reading: $detail.';
  }

  @override
  String get studyHarmonyDailyReplayAction => 'Repetir diariamente';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'Medallas de hito';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'Medalla del Conquistador';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Borrar lecciones $target en Core Foundations.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'Coleccionista de estrellas';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Recoge estrellas $target en Estudio de armonía.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'Leyenda de la racha';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return 'Alcanza la mejor racha diaria de $target.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => 'Académico de maestría';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return 'Domina las habilidades $target.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return 'Medallas $earned/$total obtenidas';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'Gabinete completo';

  @override
  String get studyHarmonyMilestoneTierBronze => 'Medalla de Bronce';

  @override
  String get studyHarmonyMilestoneTierSilver => 'Medalla de Plata';

  @override
  String get studyHarmonyMilestoneTierGold => 'Medalla de oro';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'Medalla de Platino';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => 'Nuevas medallas';

  @override
  String get studyHarmonyChapterRemixTitle => 'Arena remezclada';

  @override
  String get studyHarmonyChapterRemixDescription =>
      'Conjuntos mixtos más largos que mezclan centro tonal, función y color prestado sin previo aviso.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => 'Constructor de puentes';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'La función de puntada lee y rellena los acordes faltantes en una cadena fluida.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'Pivote de color';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      'Realice un seguimiento del color prestado y de los pivotes centrales clave a medida que la progresión cambia debajo de usted.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => 'Sprint de resolución';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      'Lea la función, el relleno de cadencia y la gravedad tonal consecutivamente a un ritmo más rápido.';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'Maratón de remezclas';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      'Un maratón mixto final que devuelve al conjunto todas las lentes de lectura de progresión.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'Salva racha x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'Coronas de leyenda $count';
  }

  @override
  String get studyHarmonyModeFocus => 'Modo de enfoque';

  @override
  String get studyHarmonyModeLegend => 'Prueba de leyenda';

  @override
  String get studyHarmonyFocusCardTitle => 'Sprint de enfoque';

  @override
  String get studyHarmonyFocusCardHint =>
      'Ataca el punto más débil de tu ruta actual con menos vidas y objetivos más exigentes.';

  @override
  String get studyHarmonyFocusFallbackHint =>
      'Completa un mix más exigente para presionar tus puntos débiles actuales.';

  @override
  String get studyHarmonyFocusAction => 'Iniciar sprint';

  @override
  String get studyHarmonyFocusSessionTitle => 'Sprint de enfoque';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return 'Un sprint mixto más ajustado construido desde los puntos más débiles alrededor de $chapter.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count lecciones mixtas';
  }

  @override
  String get studyHarmonyFocusRewardLabel => 'Recompensa semanal: Salva racha';

  @override
  String get studyHarmonyLegendCardTitle => 'Prueba de leyenda';

  @override
  String get studyHarmonyLegendCardHint =>
      'Repite un capítulo de nivel plata o superior en una sesión de dominio con 2 vidas para asegurar su corona de leyenda.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'Completa un capítulo y súbelo a unas 2 estrellas por lección para desbloquear una prueba de leyenda.';

  @override
  String get studyHarmonyLegendAction => 'Ir por la leyenda';

  @override
  String get studyHarmonyLegendSessionTitle => 'Prueba de leyenda';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return 'Una repetición de dominio sin margen en $chapter, pensada para asegurar su corona de leyenda.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count lecciones encadenadas';
  }

  @override
  String get studyHarmonyLegendRiskLabel =>
      'La corona de leyenda está en juego';

  @override
  String get studyHarmonyWeeklyPlanTitle => 'Plan de entrenamiento semanal';

  @override
  String get studyHarmonyWeeklyRewardLabel => 'Recompensa: Salva racha';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => 'Recompensa lista';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => 'Recompensa reclamada';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => 'Aparecer varios días';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return 'Esté activo en $target diferentes días de esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle =>
      'Mantenga vivo el ciclo diario';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return 'El registro $target se borra diariamente esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle =>
      'Terminar un sprint de concentración';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return 'Completa $target Focus Sprints esta semana.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      'Un Salva racha protegió el día de ayer.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return 'Ganaste un nuevo Salva racha. Inventario: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine =>
      'Sprint de enfoque despejado.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return 'Corona legendaria asegurada para $chapter.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'Escalera bis';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      'Una breve escalera de acabado que comprime todo el conjunto de herramientas de progresión en un conjunto final de bises.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'Pulso tonal';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'Bloquee el centro tonal y funcione sin indicaciones de calentamiento.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'Intercambio de color';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      'Llamadas de colores prestados alternativos con restauración de acordes faltantes para mantener el oído honesto.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'Bis final';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'Una última ronda de jefe compacta que comprueba cada lente de progresión en rápida sucesión.';

  @override
  String get studyHarmonyChapterMasteryBronze => 'Bronce Claro';

  @override
  String get studyHarmonyChapterMasterySilver => 'Corona de plata';

  @override
  String get studyHarmonyChapterMasteryGold => 'corona de oro';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'Corona de leyenda';

  @override
  String get studyHarmonyModeBossRush => 'Modo Boss Rush';

  @override
  String get studyHarmonyBossRushCardTitle => 'Boss Rush';

  @override
  String get studyHarmonyBossRushCardHint =>
      'Encadena las lecciones de jefe desbloqueadas con menos vidas y un umbral de puntuación más alto.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      'Desbloquea al menos dos lecciones de jefe para abrir una Boss Rush mixta de verdad.';

  @override
  String get studyHarmonyBossRushAction => 'Iniciar Boss Rush';

  @override
  String get studyHarmonyBossRushSessionTitle => 'Boss Rush';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return 'Un gauntlet de alta presión construido con las lecciones de jefe desbloqueadas alrededor de $chapter.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count lecciones de jefe mixtas';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => 'Solo 2 vidas';

  @override
  String get studyHarmonyResultBossRushLine => 'Jefe Rush despejado.';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      'Un último conjunto de focos que aísla el color prestado, la presión de la cadencia y la integración a nivel de jefe.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => 'Lente prestada';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      'Realice un seguimiento de centro tonal mientras el color prestado sigue intentando desviar la lectura.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle =>
      'Intercambio de cadencia';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      'Cambia entre lectura de funciones y restauración de cadencia sin perder el punto de aterrizaje.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'Un conjunto de jefes finales que obliga a cada lente de progresión a mantenerse nítida bajo presión.';

  @override
  String get studyHarmonyChapterAfterHoursTitle =>
      'Laboratorio fuera de horario';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'Un laboratorio de finales de juego que elimina pistas de calentamiento y mezcla colores prestados, presión de cadencia y seguimiento central.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'Sombra modal';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      'Mantenga presionado el centro tonal mientras el color prestado sigue arrastrando la lectura hacia la oscuridad.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => 'Finta de resolución';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'Capte las falsificaciones de función y cadencia antes de que la frase pase de su verdadero lugar de aterrizaje.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle =>
      'Fundido cruzado central';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      'Combine la detección del centro, la lectura de funciones y la reparación de cuerdas faltantes sin necesidad de andamios adicionales.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'Jefe de última llamada';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'Un último set de jefe nocturno que pide a cada lente de progresión que se mantenga clara bajo presión.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyModeRelay => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardTitle => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardHint =>
      'Mezcla lecciones desbloqueadas de distintos capítulos en una sola tanda intercalada para poner a prueba tanto el cambio rápido como el recuerdo inmediato.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'Desbloquea al menos dos capítulos para abrir Relevo de arena.';

  @override
  String get studyHarmonyRelayAction => 'Iniciar relevo';

  @override
  String get studyHarmonyRelaySessionTitle => 'Relevo de arena';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return 'Una ejecución de retransmisión entrelazada que mezcla capítulos desbloqueados sobre $chapter.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return 'Lecciones $count transmitidas';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count capítulos mezclados';
  }

  @override
  String get studyHarmonyRelayChainLabel => 'Intercalado bajo presión';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'Corredor de relevos';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return 'Borre las ejecuciones $target Relevo de arena.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'Desvíos de neón';

  @override
  String get studyHarmonyChapterNeonDescription =>
      'Un capítulo del final del juego que sigue cambiando el camino con color prestado, presión de pivote y lecturas de recuperación.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'Desvío modal';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      'Siga el verdadero centro incluso cuando el color prestado sigue empujando la frase a una calle lateral.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'Presión de pivote';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      'Lea los cambios de centro y la presión de función espalda con espalda antes de que el carril armónico cambie nuevamente.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => 'Aterrizaje prestado';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      'Repare la cuerda de aterrizaje que falta después de que una falsificación de color prestado cambie la resolución esperada.';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'Jefe de luces de la ciudad';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'Un jefe de neón final que combina lecturas pivotantes, colores prestados y recuperación de cadencia sin un aterrizaje suave.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return 'Liga $tier';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'Liga de armonía';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return 'Empuja hacia la liga $tier esta semana. El impulso más limpio ahora mismo viene de $mode.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      'Diamante ya está asegurado esta semana. Sigue encadenando superadas de alta presión para mantener el ritmo.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      'Tu ascenso de liga se iluminará una vez que haya una carrera recomendada para impulsar esta semana.';

  @override
  String get studyHarmonyLeagueAction => 'Subir de liga';

  @override
  String get studyHarmonyHubStartHereTitle => 'Start Here';

  @override
  String get studyHarmonyHubNextLessonTitle => 'Next Lesson';

  @override
  String get studyHarmonyHubWhyItMattersTitle => 'Why It Matters';

  @override
  String get studyHarmonyHubQuickPracticeTitle => 'Quick Practice';

  @override
  String get studyHarmonyHubMetaPreviewTitle => 'More Opens Soon';

  @override
  String get studyHarmonyHubMetaPreviewHeadline =>
      'Build a little momentum first';

  @override
  String get studyHarmonyHubMetaPreviewBody =>
      'League, shop, and reward systems open up more fully after a few clears. For now, finish your next lesson and one quick practice run.';

  @override
  String get studyHarmonyHubPlayNowAction => 'Play Now';

  @override
  String get studyHarmonyHubKeepMomentumAction => 'Keep Momentum';

  @override
  String get studyHarmonyClearTitleAction => 'Clear title';

  @override
  String get studyHarmonyPlayerDeckTitle => 'Player Deck';

  @override
  String get studyHarmonyPlayerDeckCardTitle => 'Playstyle';

  @override
  String get studyHarmonyPlayerDeckOverviewAction => 'Overview';

  @override
  String get studyHarmonyRunDirectorTitle => 'Run Director';

  @override
  String get studyHarmonyRunDirectorAction => 'Play Recommended';

  @override
  String get studyHarmonyGameEconomyTitle => 'Game Economy';

  @override
  String get studyHarmonyGameEconomyBody =>
      'Shop stock, utility tokens, and meta items all react to your recent run history.';

  @override
  String studyHarmonyGameEconomyTitlesOwned(int count) {
    return '$count titles owned';
  }

  @override
  String studyHarmonyGameEconomyCosmeticsOwned(int count) {
    return '$count cosmetics owned';
  }

  @override
  String studyHarmonyGameEconomyShopPurchases(int count) {
    return '$count shop purchases';
  }

  @override
  String get studyHarmonyGameEconomyWalletAction => 'View Wallet';

  @override
  String get studyHarmonyArcadeSpotlightTitle => 'Arcade Spotlight';

  @override
  String get studyHarmonyArcadePlayAction => 'Play Arcade';

  @override
  String studyHarmonyArcadeModeCount(int count) {
    return '$count modes';
  }

  @override
  String get studyHarmonyArcadePlaylistAction => 'Play Set';

  @override
  String get studyHarmonyNightMarketTitle => 'Night Market';

  @override
  String studyHarmonyPurchaseSuccess(Object itemTitle) {
    return 'Purchased $itemTitle';
  }

  @override
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle) {
    return 'Purchased and equipped $itemTitle';
  }

  @override
  String studyHarmonyPurchaseFailure(Object itemTitle) {
    return 'Cannot purchase $itemTitle yet';
  }

  @override
  String studyHarmonyRewardEquipped(Object itemTitle) {
    return 'Equipped $itemTitle';
  }

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score XP esta semana';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target XP esta semana';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return 'Siguiente: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return 'Mejor impulso: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'XP de liga +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return 'Ascendido a la liga $tier';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'Novato';

  @override
  String get studyHarmonyLeagueTierBronze => 'Bronce';

  @override
  String get studyHarmonyLeagueTierSilver => 'Plata';

  @override
  String get studyHarmonyLeagueTierGold => 'Oro';

  @override
  String get studyHarmonyLeagueTierDiamond => 'Diamante';

  @override
  String get studyHarmonyChapterMidnightTitle => 'Central de medianoche';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      'Un capítulo final de sala de control que obliga a lecturas rápidas a través de centros a la deriva, cadencias falsas y desvíos prestados.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'Deriva de señal';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      'Siga la verdadera señal tonal incluso mientras la superficie sigue adoptando un color prestado.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => 'Línea engañosa';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      'Lea la presión de la función a través de resoluciones falsas antes de que la línea vuelva a colocarse en su lugar.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => 'Desvío prestado';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      'Recupera el aterrizaje esperado después de que el color prestado desvía la frase a mitad de camino.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'Jefe del apagón';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      'Un conjunto de oscurecimiento final que combina todos los lentes del juego tardío sin brindarte un reinicio seguro.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'Cofres de misiones $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x XP de liga x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'Cofre de misiones';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count misiones restantes';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'Cofre de misiones listo';

  @override
  String get studyHarmonyQuestChestOpenedHeadline =>
      'Cofre de misiones abierto';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x Liga XP en vivo';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return 'Recompensa: +$xp liga XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      'Completa el trío de misiones de hoy para abrir el cofre extra y sostener el ascenso semanal.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      'Las tres misiones de hoy ya están hechas. Supera una partida más para cobrar el bono del cofre.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      'El trío de hoy está completo y la bonificación del cofre ya se ha convertido en XP de liga.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return 'El cofre de hoy ya está abierto y el 2x de XP de liga se aplica a tus próximas $count superadas.';
  }

  @override
  String get studyHarmonyQuestChestAction => 'Terminar trío';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'Mejor remate: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'Misiones diarias $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'Se abrió Cofre de misiones.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'Bonificación Cofre de misiones + XP de liga $count';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '2x de XP de liga listo para tus próximas $count superadas';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'Bono de impulso +$count de XP de liga';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return 'El impulso 2x se borra a la izquierda $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return 'Tienes 2x de XP de liga durante las próximas $count superadas. Aprovéchalo en $mode mientras dure el impulso.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'Circuito del horizonte';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'Un circuito final del horizonte que obliga a lecturas rápidas y mixtas a través de centros fantasmas, gravedad prestada y casas falsas.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => 'Pulso residual';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'Capte el centro y funcione en la imagen residual antes de que la frase se bloquee en un nuevo carril.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => 'Cambio de gravedad';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      'Maneja la gravedad prestada y repara los acordes faltantes mientras la progresión sigue cambiando su peso.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => 'Falsa llegada';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      'Lea la llegada falsa y reconstruya el aterrizaje real antes de que la progresión se cierre de golpe.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => 'Jefe de la señal final';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'Un último jefe del horizonte que encadena cada lente de progresión del juego tardío en una prueba de señal de cierre.';

  @override
  String get studyHarmonyChapterAfterglowTitle => 'Pista del resplandor';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'Una pista cerrada de decisiones divididas, cebo prestado y centros parpadeantes que recompensa lecturas limpias al final del juego bajo presión.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => 'Decisión dividida';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'Elija el acorde de reparación que mantenga la función en movimiento sin permitir que la frase se desvíe de su curso.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => 'Señuelo prestado';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      'Encuentra el acorde de color prestado que parece un pivote antes de que la progresión regrese a casa.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => 'Parpadeo del centro';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'Mantén el centro tonal mientras las señales de cadencia parpadean y se desvían en rápida sucesión.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle =>
      'Jefe de retorno de línea roja';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'Una prueba final mixta de centro tonal, función, color prestado y reparación de acordes faltantes a toda velocidad.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'Tour mensual autorizado';

  @override
  String get studyHarmonyTourTitle => 'Tour de armonía';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'Listo el final de la gira';

  @override
  String get studyHarmonyTourClaimedHeadline => 'Tour mensual autorizado';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return 'Recompensa: +$xp de XP de liga y $count Salva racha';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return 'Aparece en $target días distintos este mes para asegurar el bono del tour.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return 'Abre $target cofres de misiones este mes para que el cuaderno del tour siga avanzando.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return 'Supera $target retos destacados este mes. Cuentan Boss Rush, Relevo de arena, Sprint de enfoque, Prueba de leyenda y las lecciones de jefe.';
  }

  @override
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

  @override
  String get studyHarmonyTourReadyBody =>
      'Ya reuniste todos los sellos del mes. Una partida más completada asegura el bono del tour.';

  @override
  String get studyHarmonyTourClaimedBody =>
      'La gira de este mes está completa. Mantén el ritmo fuerte para que la ruta del próximo mes empiece caliente.';

  @override
  String get studyHarmonyTourAction => 'recorrido anticipado';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return 'Días activos $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Cofre de misioness $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Focos $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Tour de armonía completo';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'Bono de gira +$count XP de liga';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Reserva de Salva racha $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => 'Frecuencia del amanecer';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'Un bis al amanecer de cadencias fantasmales, giros falsos del amanecer y flores prestadas que obliga a lecturas limpias al final del juego después de una larga carrera.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => 'Cadencia fantasma';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'Repara la cadencia y funciona al mismo tiempo cuando la frase pretende cerrarse sin llegar a aterrizar.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => 'Falso amanecer';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      'Capte el cambio central escondido dentro de un amanecer demasiado temprano antes de que la progresión se aleje nuevamente.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => 'Brote prestado';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      'Realice un seguimiento del color prestado y funcionen juntos mientras la armonía se abre hacia un carril más brillante pero inestable.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle =>
      'Jefe de sobremarcha del amanecer';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'Un jefe final a la velocidad del amanecer que encadena centro tonal, función, color no diatónico y reparación de acordes faltantes en un último conjunto de sobremarcha.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'Pacto a dúo';

  @override
  String get studyHarmonyDuetStartHeadline => 'Empieza el dueto de hoy.';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return 'Dueto bloqueado por el día $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return 'Recompensa: +$xp de XP de liga en rachas clave';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'Primero completa la diaria de hoy y luego supera un reto destacado para mantener vivo el pacto a dúo.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Lo diario está de moda. Termina una carrera destacada como Focus, Relay, Boss Rush, Legend o una lección de jefe para sellar el dúo.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return 'El dúo de hoy ya quedó sellado y la racha compartida va en $count días.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Diariamente en';

  @override
  String get studyHarmonyDuetDailyMissing => 'Falta diaria';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Foco en';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Falta foco';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return 'Diario $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'Foco $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'Racha $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'Sigue el dueto';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'Recompensa de dúo +$count XP de liga';
  }

  @override
  String get studyHarmonySolfegeDo => 'Do';

  @override
  String get studyHarmonySolfegeRe => 'Re';

  @override
  String get studyHarmonySolfegeMi => 'Mi';

  @override
  String get studyHarmonySolfegeFa => 'Fa';

  @override
  String get studyHarmonySolfegeSol => 'Sol';

  @override
  String get studyHarmonySolfegeLa => 'La';

  @override
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle =>
      'Prototipo de Estudio de armonía';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Niveles heredados del prototipo integrados en el sistema de lecciones.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Lecciones prototipo';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Lecciones temporales conservadas mientras se incorpora el sistema de estudio ampliable.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Supera 10 respuestas correctas antes de perder las 3 vidas';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Nivel prototipo 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'Un calentamiento básico para distinguir solo Do, Mi y Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Nivel prototipo 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'Un nivel intermedio para acelerar el reconocimiento de Do, Re, Mi, Sol y La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Nivel prototipo 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'Una prueba de octava completa que recorre toda la serie Do-Re-Mi-Fa-Sol-La-Si-Do.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (C grave)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (C agudo)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Plantilla';

  @override
  String get studyHarmonyChapterBlueHourTitle => 'Cruce de la hora azul';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      'Un bis crepuscular de corrientes cruzadas, préstamos con halo y horizontes duales que mantienen inestables las lecturas tardías del juego de la mejor manera.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => 'Corriente cruzada';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'Siga centro tonal y funcione mientras la progresión comienza a moverse en dos direcciones a la vez.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => 'Halo prestado';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      'Lea el color prestado y restablezca el acorde que falta antes de que la frase se vuelva confusa.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => 'Horizonte doble';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      'Mantenga el punto de llegada real mientras dos posibles horizontes siguen apareciendo y desapareciendo.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'Jefe de linternas gemelas';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'Un jefe final de hora azul que obliga a cambios rápidos entre el centro, la función, el color prestado y la reparación de acordes faltantes.';

  @override
  String get anchorLoopTitle => 'Anchor Loop';

  @override
  String get anchorLoopHelp =>
      'Fix specific cycle slots so the same chord returns every cycle while the other slots can still be generated around it.';

  @override
  String get anchorLoopCycleLength => 'Cycle Length (bars)';

  @override
  String get anchorLoopCycleLengthHelp =>
      'Choose how many bars the repeating anchor cycle lasts.';

  @override
  String get anchorLoopVaryNonAnchorSlots => 'Vary non-anchor slots';

  @override
  String get anchorLoopVaryNonAnchorSlotsHelp =>
      'Keep anchor slots exact while letting the generated filler vary inside the same local function.';

  @override
  String anchorLoopBarLabel(int bar) {
    return 'Bar $bar';
  }

  @override
  String anchorLoopBeatLabel(int beat) {
    return 'Beat $beat';
  }

  @override
  String get anchorLoopSlotEmpty => 'No anchor chord set';

  @override
  String anchorLoopEditTitle(int bar, int beat) {
    return 'Edit anchor for bar $bar, beat $beat';
  }

  @override
  String get anchorLoopChordSymbol => 'Anchor chord symbol';

  @override
  String get anchorLoopChordHint =>
      'Enter one chord symbol for this slot. Leave it empty to clear the anchor.';

  @override
  String get anchorLoopInvalidChord =>
      'Enter a supported chord symbol before saving this anchor slot.';

  @override
  String get harmonyPlaybackPatternBlock => 'Block';

  @override
  String get harmonyPlaybackPatternArpeggio => 'Arpeggio';

  @override
  String get metronomeBeatStateNormal => 'Normal';

  @override
  String get metronomeBeatStateAccent => 'Accent';

  @override
  String get metronomeBeatStateMute => 'Mute';

  @override
  String get metronomePatternPresetCustom => 'Custom';

  @override
  String get metronomePatternPresetMeterAccent => 'Meter accent';

  @override
  String get metronomePatternPresetJazzTwoAndFour => 'Jazz 2 & 4';

  @override
  String get metronomeSourceKindBuiltIn => 'Built-in asset';

  @override
  String get metronomeSourceKindLocalFile => 'Local file';

  @override
  String get transportAudioTitle => 'Transport Audio';

  @override
  String get autoPlayChordChanges => 'Auto-play chord changes';

  @override
  String get autoPlayChordChangesHelp =>
      'Play the next chord automatically when the transport reaches a chord-change event.';

  @override
  String get autoPlayPattern => 'Auto-play pattern';

  @override
  String get autoPlayPatternHelp =>
      'Choose whether auto-play uses a block chord or a short arpeggio.';

  @override
  String get autoPlayHoldFactor => 'Auto-play hold length';

  @override
  String get autoPlayHoldFactorHelp =>
      'Scale how long auto-played chord changes ring relative to the event duration.';

  @override
  String get autoPlayMelodyWithChords => 'Play melody with chords';

  @override
  String get autoPlayMelodyWithChordsPlaceholder =>
      'When melody generation is enabled, include the current melody line in auto-play chord-change previews.';

  @override
  String get melodyGenerationTitle => 'Melody line';

  @override
  String get melodyGenerationHelp =>
      'Generate a simple performance-ready melody that follows the current chord timeline.';

  @override
  String get melodyDensity => 'Melody density';

  @override
  String get melodyDensityHelp =>
      'Choose how many melody notes tend to appear inside each chord event.';

  @override
  String get melodyDensitySparse => 'Sparse';

  @override
  String get melodyDensityBalanced => 'Balanced';

  @override
  String get melodyDensityActive => 'Active';

  @override
  String get motifRepetitionStrength => 'Motif repetition';

  @override
  String get motifRepetitionStrengthHelp =>
      'Higher values keep the contour identity of recent melody fragments more often.';

  @override
  String get approachToneDensity => 'Approach tone density';

  @override
  String get approachToneDensityHelp =>
      'Control how often passing, neighbor, and approach gestures appear before arrivals.';

  @override
  String get melodyRangeLow => 'Melody range low';

  @override
  String get melodyRangeHigh => 'Melody range high';

  @override
  String get melodyRangeHelp =>
      'Keep generated melody notes inside this playable register window.';

  @override
  String get melodyStyle => 'Melody style';

  @override
  String get melodyStyleHelp =>
      'Bias the line toward safer guide tones, bebop motion, lyrical space, or colorful tensions.';

  @override
  String get melodyStyleSafe => 'Safe';

  @override
  String get melodyStyleBebop => 'Bebop';

  @override
  String get melodyStyleLyrical => 'Lyrical';

  @override
  String get melodyStyleColorful => 'Colorful';

  @override
  String get allowChromaticApproaches => 'Allow chromatic approaches';

  @override
  String get allowChromaticApproachesHelp =>
      'Permit enclosures and chromatic approach notes on weak beats when the style allows it.';

  @override
  String get melodyPlaybackMode => 'Melody playback';

  @override
  String get melodyPlaybackModeHelp =>
      'Choose whether manual preview buttons play chords, melody, or both together.';

  @override
  String get melodyPlaybackModeChordsOnly => 'Chords only';

  @override
  String get melodyPlaybackModeMelodyOnly => 'Melody only';

  @override
  String get melodyPlaybackModeBoth => 'Both';

  @override
  String get regenerateMelody => 'Regenerate melody';

  @override
  String get melodyPreviewCurrent => 'Current line';

  @override
  String get melodyPreviewNext => 'Next arrival';

  @override
  String get metronomePatternTitle => 'Metronome Pattern';

  @override
  String get metronomePatternHelp =>
      'Choose a meter-aware click pattern or define each beat manually.';

  @override
  String get metronomeUseAccentSound => 'Use separate accent sound';

  @override
  String get metronomeUseAccentSoundHelp =>
      'Use a different click source for accented beats instead of only raising the gain.';

  @override
  String get metronomePrimarySource => 'Primary click source';

  @override
  String get metronomeAccentSource => 'Accent click source';

  @override
  String get metronomeSourceKind => 'Source type';

  @override
  String get metronomeLocalFilePath => 'Local file path';

  @override
  String get metronomeLocalFilePathHelp =>
      'Paste a local audio file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeCustomSoundHelp =>
      'Upload your own metronome click. The app stores a private copy and keeps the built-in sound as fallback.';

  @override
  String get metronomeCustomSoundStatusBuiltIn =>
      'Currently using a built-in sound.';

  @override
  String metronomeCustomSoundStatusFile(Object fileName) {
    return 'Custom file: $fileName';
  }

  @override
  String get metronomeCustomSoundUpload => 'Upload custom sound';

  @override
  String get metronomeCustomSoundReplace => 'Replace custom sound';

  @override
  String get metronomeCustomSoundReset => 'Use built-in sound';

  @override
  String get metronomeCustomSoundUploadSuccess =>
      'Custom metronome sound saved.';

  @override
  String get metronomeCustomSoundResetSuccess =>
      'Switched back to the built-in metronome sound.';

  @override
  String get metronomeCustomSoundUploadError =>
      'Couldn\'t save the selected metronome audio file.';

  @override
  String get harmonySoundTitle => 'Harmony Sound';

  @override
  String get harmonyMasterVolume => 'Master volume';

  @override
  String get harmonyMasterVolumeHelp =>
      'Overall harmony preview loudness for manual and automatic chord playback.';

  @override
  String get harmonyPreviewHoldFactor => 'Chord hold length';

  @override
  String get harmonyPreviewHoldFactorHelp =>
      'Scale how long previewed chords and notes sustain.';

  @override
  String get harmonyArpeggioStepSpeed => 'Arpeggio step speed';

  @override
  String get harmonyArpeggioStepSpeedHelp =>
      'Control how quickly arpeggiated notes step forward.';

  @override
  String get harmonyVelocityHumanization => 'Velocity humanization';

  @override
  String get harmonyVelocityHumanizationHelp =>
      'Add small velocity variation so repeated previews feel less mechanical.';

  @override
  String get harmonyGainRandomness => 'Gain randomness';

  @override
  String get harmonyGainRandomnessHelp =>
      'Add slight per-note loudness variation on supported playback paths.';

  @override
  String get harmonyTimingHumanization => 'Timing humanization';

  @override
  String get harmonyTimingHumanizationHelp =>
      'Slightly loosen simultaneous note attacks for a less rigid block chord.';

  @override
  String get harmonySoundProfileSelectionTitle => 'Sound profile mode';

  @override
  String get harmonySoundProfileSelectionHelp =>
      'Elige un sonido equilibrado por defecto o fija un carácter de reproducción para practicar pop, jazz o clásico.';

  @override
  String get harmonySoundProfileSelectionNeutral => 'Neutral shared piano';

  @override
  String get harmonySoundProfileSelectionTrackAware => 'Track-aware';

  @override
  String get harmonySoundProfileSelectionPop => 'Pop profile';

  @override
  String get harmonySoundProfileSelectionJazz => 'Jazz profile';

  @override
  String get harmonySoundProfileSelectionClassical => 'Classical profile';

  @override
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern) {
    return 'Instrument: $instrument. Recommended preview: $pattern.';
  }

  @override
  String get harmonySoundProfileTrackAwareFallback =>
      'In free practice this stays on the shared piano profile. Study Harmony sessions switch to the active track\'s sound shaping.';

  @override
  String get harmonySoundProfileNeutralLabel => 'Balanced / shared piano';

  @override
  String get harmonySoundProfileNeutralSummary =>
      'Use the shared piano asset with a steady, all-purpose preview shape.';

  @override
  String get harmonySoundTagBalanced => 'balanced';

  @override
  String get harmonySoundTagPiano => 'piano';

  @override
  String get harmonySoundTagSoft => 'soft';

  @override
  String get harmonySoundTagOpen => 'open';

  @override
  String get harmonySoundTagModern => 'modern';

  @override
  String get harmonySoundTagDry => 'dry';

  @override
  String get harmonySoundTagWarm => 'warm';

  @override
  String get harmonySoundTagEpReady => 'EP-ready';

  @override
  String get harmonySoundTagClear => 'clear';

  @override
  String get harmonySoundTagAcoustic => 'acoustic';

  @override
  String get harmonySoundTagFocused => 'focused';

  @override
  String get harmonySoundNeutralTrait1 =>
      'Steady hold for general harmonic checking';

  @override
  String get harmonySoundNeutralTrait2 => 'Balanced attack with low coloration';

  @override
  String get harmonySoundNeutralTrait3 =>
      'Safe fallback for any lesson or free-play context';

  @override
  String get harmonySoundNeutralExpansion1 =>
      'Future split by piano register or room size';

  @override
  String get harmonySoundNeutralExpansion2 =>
      'Possible alternate shared instrument set for headphones';

  @override
  String get harmonySoundPopTrait1 =>
      'Longer sustain for open hooks and add9 color';

  @override
  String get harmonySoundPopTrait2 =>
      'Softer attack with a little width in repeated previews';

  @override
  String get harmonySoundPopTrait3 =>
      'Gentle humanization so loops feel less grid-locked';

  @override
  String get harmonySoundPopExpansion1 =>
      'Bright pop keys or layered piano-synth asset';

  @override
  String get harmonySoundPopExpansion2 =>
      'Wider stereo voicing playback for chorus lift';

  @override
  String get harmonySoundJazzTrait1 =>
      'Shorter hold to keep cadence motion readable';

  @override
  String get harmonySoundJazzTrait2 =>
      'Faster broken-preview feel for guide-tone hearing';

  @override
  String get harmonySoundJazzTrait3 =>
      'More touch variation to suggest shell and rootless comping';

  @override
  String get harmonySoundJazzExpansion1 =>
      'Dry upright or mellow electric-piano instrument family';

  @override
  String get harmonySoundJazzExpansion2 =>
      'Track-aware comping presets for shell and rootless drills';

  @override
  String get harmonySoundClassicalTrait1 =>
      'Centered sustain for function and cadence clarity';

  @override
  String get harmonySoundClassicalTrait2 =>
      'Low randomness to keep voice-leading stable';

  @override
  String get harmonySoundClassicalTrait3 =>
      'More direct block playback for harmonic arrival';

  @override
  String get harmonySoundClassicalExpansion1 =>
      'Direct acoustic piano profile with less ambient spread';

  @override
  String get harmonySoundClassicalExpansion2 =>
      'Dedicated cadence and sequence preview voicings';

  @override
  String get explanationSectionTitle => 'Why this works';

  @override
  String get explanationReasonSection => 'Why this result';

  @override
  String get explanationConfidenceHigh => 'High confidence';

  @override
  String get explanationConfidenceMedium => 'Plausible reading';

  @override
  String get explanationConfidenceLow => 'Treat as a tentative reading';

  @override
  String get explanationAmbiguityLow =>
      'Most of the progression points in one direction, but a light alternate reading is still possible.';

  @override
  String get explanationAmbiguityMedium =>
      'More than one plausible reading is still in play, so context matters here.';

  @override
  String get explanationAmbiguityHigh =>
      'Several readings are competing, so treat this as a cautious, context-dependent explanation.';

  @override
  String get explanationCautionParser =>
      'Some chord symbols were normalized before analysis.';

  @override
  String get explanationCautionAmbiguous =>
      'There is more than one reasonable reading here.';

  @override
  String get explanationCautionAlternateKey =>
      'A nearby key center also fits part of this progression.';

  @override
  String get explanationAlternativeSection => 'Other readings';

  @override
  String explanationAlternativeKeyLabel(Object keyLabel) {
    return 'Alternate key: $keyLabel';
  }

  @override
  String get explanationAlternativeKeyBody =>
      'The harmonic pull is still valid, but another key center also explains some of the same chords.';

  @override
  String explanationAlternativeReadingLabel(Object romanNumeral) {
    return 'Alternate reading: $romanNumeral';
  }

  @override
  String get explanationAlternativeReadingBody =>
      'This is another possible interpretation rather than a single definitive label.';

  @override
  String get explanationListeningSection => 'Listening focus';

  @override
  String get explanationListeningGuideToneTitle => 'Follow the 3rds and 7ths';

  @override
  String get explanationListeningGuideToneBody =>
      'Listen for the smallest inner-line motion as the cadence resolves.';

  @override
  String get explanationListeningDominantColorTitle =>
      'Listen for the dominant color';

  @override
  String get explanationListeningDominantColorBody =>
      'Notice how the tension on the dominant wants to release, even before the final arrival lands.';

  @override
  String get explanationListeningBackdoorTitle =>
      'Hear the softer backdoor pull';

  @override
  String get explanationListeningBackdoorBody =>
      'Listen for the subdominant-minor color leading home by color and voice leading rather than a plain V-I push.';

  @override
  String get explanationListeningBorrowedColorTitle => 'Hear the color shift';

  @override
  String get explanationListeningBorrowedColorBody =>
      'Notice how the borrowed chord darkens or brightens the loop before it returns home.';

  @override
  String get explanationListeningBassMotionTitle => 'Follow the bass motion';

  @override
  String get explanationListeningBassMotionBody =>
      'Track how the bass note reshapes momentum, even when the upper harmony stays closely related.';

  @override
  String get explanationListeningCadenceTitle => 'Hear the arrival';

  @override
  String get explanationListeningCadenceBody =>
      'Pay attention to which chord feels like the point of rest and how the approach prepares it.';

  @override
  String get explanationListeningAmbiguityTitle =>
      'Compare the competing readings';

  @override
  String get explanationListeningAmbiguityBody =>
      'Try hearing the same chord once for its local pull and once for its larger key-center role.';

  @override
  String get explanationPerformanceSection => 'Performance focus';

  @override
  String get explanationPerformancePopTitle => 'Keep the hook singable';

  @override
  String get explanationPerformancePopBody =>
      'Favor clear top notes, repeated contour, and open voicings that support the vocal line.';

  @override
  String get explanationPerformanceJazzTitle => 'Target guide tones first';

  @override
  String get explanationPerformanceJazzBody =>
      'Outline the 3rd and 7th before adding extra tensions or reharm color.';

  @override
  String get explanationPerformanceJazzShellTitle => 'Start with shell tones';

  @override
  String get explanationPerformanceJazzShellBody =>
      'Place the root, 3rd, and 7th cleanly first so the cadence stays easy to hear.';

  @override
  String get explanationPerformanceJazzRootlessTitle =>
      'Let the 3rd and 7th carry the shape';

  @override
  String get explanationPerformanceJazzRootlessBody =>
      'Keep the guide tones stable, then add 9 or 13 only if the line still resolves clearly.';

  @override
  String get explanationPerformanceClassicalTitle =>
      'Keep the voices disciplined';

  @override
  String get explanationPerformanceClassicalBody =>
      'Prioritize stable spacing, functional arrivals, and stepwise motion where possible.';

  @override
  String get explanationPerformanceDominantColorTitle =>
      'Add tension after the target is clear';

  @override
  String get explanationPerformanceDominantColorBody =>
      'Land the guide tones first, then treat 9, 13, or altered color as decoration rather than the main signal.';

  @override
  String get explanationPerformanceAmbiguityTitle =>
      'Anchor the most stable tones';

  @override
  String get explanationPerformanceAmbiguityBody =>
      'If the reading is ambiguous, emphasize the likely resolution tones before leaning into the more colorful option.';

  @override
  String get explanationPerformanceVoicingTitle => 'Voicing cue';

  @override
  String get explanationPerformanceMelodyTitle => 'Melody cue';

  @override
  String get explanationPerformanceMelodyBody =>
      'Lean on the structural target notes, then let passing tones fill the space around them.';

  @override
  String get explanationReasonFunctionalResolutionLabel => 'Functional pull';

  @override
  String get explanationReasonFunctionalResolutionBody =>
      'The chords line up as tonic, predominant, and dominant functions rather than isolated sonorities.';

  @override
  String get explanationReasonGuideToneSmoothnessLabel => 'Guide-tone motion';

  @override
  String get explanationReasonGuideToneSmoothnessBody =>
      'The inner voices move efficiently, which strengthens the sense of direction.';

  @override
  String get explanationReasonBorrowedColorLabel => 'Borrowed color';

  @override
  String get explanationReasonBorrowedColorBody =>
      'A parallel-mode borrowing adds contrast without fully leaving the home key.';

  @override
  String get explanationReasonSecondaryDominantLabel =>
      'Secondary dominant pull';

  @override
  String get explanationReasonSecondaryDominantBody =>
      'This dominant points strongly toward a local target chord instead of only the tonic.';

  @override
  String get explanationReasonTritoneSubLabel => 'Tritone-sub color';

  @override
  String get explanationReasonTritoneSubBody =>
      'The dominant color is preserved while the bass motion shifts to a substitute route.';

  @override
  String get explanationReasonDominantColorLabel => 'Dominant tension';

  @override
  String get explanationReasonDominantColorBody =>
      'Altered or extended dominant color strengthens the pull toward the next chord without changing the whole key reading.';

  @override
  String get explanationReasonBackdoorMotionLabel => 'Backdoor motion';

  @override
  String get explanationReasonBackdoorMotionBody =>
      'This reading leans on subdominant-minor or backdoor motion, so the resolution feels softer but still directed.';

  @override
  String get explanationReasonCadentialStrengthLabel => 'Cadential shape';

  @override
  String get explanationReasonCadentialStrengthBody =>
      'The phrase ends with a stronger arrival than a neutral loop continuation.';

  @override
  String get explanationReasonVoiceLeadingStabilityLabel =>
      'Stable voice leading';

  @override
  String get explanationReasonVoiceLeadingStabilityBody =>
      'The selected voicing keeps common tones or resolves tendency tones cleanly.';

  @override
  String get explanationReasonSingableContourLabel => 'Singable contour';

  @override
  String get explanationReasonSingableContourBody =>
      'The line favors memorable motion over angular, highly technical shapes.';

  @override
  String get explanationReasonSlashBassLiftLabel => 'Bass-motion lift';

  @override
  String get explanationReasonSlashBassLiftBody =>
      'The bass note changes the momentum even when the harmony stays closely related.';

  @override
  String get explanationReasonTurnaroundGravityLabel => 'Turnaround gravity';

  @override
  String get explanationReasonTurnaroundGravityBody =>
      'This pattern creates forward pull by cycling through familiar jazz resolution points.';

  @override
  String get explanationReasonInversionDisciplineLabel => 'Inversion control';

  @override
  String get explanationReasonInversionDisciplineBody =>
      'The inversion choice supports smoother outer-voice motion and clearer cadence behavior.';

  @override
  String get explanationReasonAmbiguityWindowLabel => 'Competing readings';

  @override
  String get explanationReasonAmbiguityWindowBody =>
      'Some of the same notes support more than one harmonic role, so context decides which reading feels stronger.';

  @override
  String get explanationReasonChromaticLineLabel => 'Chromatic line';

  @override
  String get explanationReasonChromaticLineBody =>
      'A chromatic bass or inner-line connection helps explain why this chord fits despite the extra color.';

  @override
  String get explanationTrackContextPop =>
      'In a pop context, this reading leans toward loop gravity, color contrast, and a singable top line.';

  @override
  String get explanationTrackContextJazz =>
      'In a jazz context, this is one plausible reading that highlights guide tones, cadence pull, and usable dominant color.';

  @override
  String get explanationTrackContextClassical =>
      'In a classical context, this reading leans toward function, inversion awareness, and cadence strength.';

  @override
  String get studyHarmonyTrackFocusSectionTitle => 'This track emphasizes';

  @override
  String get studyHarmonyTrackLessFocusSectionTitle =>
      'This track treats more lightly';

  @override
  String get studyHarmonyTrackRecommendedForSectionTitle => 'Recommended for';

  @override
  String get studyHarmonyTrackSoundSectionTitle => 'Sound profile';

  @override
  String get studyHarmonyTrackSoundAssetPlaceholder =>
      'Current release uses the shared piano asset. This profile prepares future track-specific sound choices.';

  @override
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument) {
    return 'Current instrument: $instrument';
  }

  @override
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern) {
    return 'Recommended preview pattern: $pattern';
  }

  @override
  String get studyHarmonyTrackSoundPlaybackTraitsTitle => 'Playback character';

  @override
  String get studyHarmonyTrackSoundExpansionTitle => 'Expansion path';

  @override
  String get studyHarmonyTrackPopFocus1 =>
      'Diatonic loop gravity and hook-friendly repetition';

  @override
  String get studyHarmonyTrackPopFocus2 =>
      'Borrowed-color lifts such as iv, bVII, or IVMaj7';

  @override
  String get studyHarmonyTrackPopFocus3 =>
      'Slash-bass and pedal-bass motion that supports pre-chorus lift';

  @override
  String get studyHarmonyTrackPopLess1 =>
      'Dense jazz reharmonization and advanced substitute dominants';

  @override
  String get studyHarmonyTrackPopLess2 =>
      'Rootless voicing systems and heavy altered-dominant language';

  @override
  String get studyHarmonyTrackPopRecommendedFor =>
      'Writers, producers, and players who want modern pop or ballad harmony that sounds usable quickly.';

  @override
  String get studyHarmonyTrackPopTheoryTone =>
      'Practical, song-first, and color-aware without overloading the learner with jargon.';

  @override
  String get studyHarmonyTrackPopHeroHeadline => 'Build hook-friendly loops';

  @override
  String get studyHarmonyTrackPopHeroBody =>
      'This track teaches loop gravity, restrained borrowed color, and bass movement that lifts a section without losing clarity.';

  @override
  String get studyHarmonyTrackPopQuickPracticeCue =>
      'Start with the signature loop chapter, then listen for how the bass and borrowed color reshape the same hook.';

  @override
  String get studyHarmonyTrackPopSoundLabel => 'Soft / open / modern';

  @override
  String get studyHarmonyTrackPopSoundSummary =>
      'Balanced piano now, with future room for brighter pop keys and wider stereo voicings.';

  @override
  String get studyHarmonyTrackJazzFocus1 =>
      'Guide-tone hearing and shell-to-rootless voicing growth';

  @override
  String get studyHarmonyTrackJazzFocus2 =>
      'Major ii-V-I, minor iiø-V-i y comportamiento del turnaround';

  @override
  String get studyHarmonyTrackJazzFocus3 =>
      'Dominant color, tensions, tritone sub, and backdoor entry points';

  @override
  String get studyHarmonyTrackJazzLess1 =>
      'Purely song-loop repetition without cadence awareness';

  @override
  String get studyHarmonyTrackJazzLess2 =>
      'Classical inversion literacy as a primary objective';

  @override
  String get studyHarmonyTrackJazzRecommendedFor =>
      'Players who want to hear and use functional jazz harmony without jumping straight into maximal reharm complexity.';

  @override
  String get studyHarmonyTrackJazzTheoryTone =>
      'Contextual, confidence-aware, and careful about calling one reading the only correct jazz answer.';

  @override
  String get studyHarmonyTrackJazzHeroHeadline =>
      'Hear the line inside the chords';

  @override
  String get studyHarmonyTrackJazzHeroBody =>
      'This track turns jazz harmony into manageable steps: guide tones first, then cadence families, then tasteful dominant color.';

  @override
  String get studyHarmonyTrackJazzQuickPracticeCue =>
      'Start with guide tones and shell voicings, then revisit the same cadence with rootless color.';

  @override
  String get studyHarmonyTrackJazzSoundLabel => 'Dry / warm / EP-ready';

  @override
  String get studyHarmonyTrackJazzSoundSummary =>
      'Shared piano for now, with placeholders for drier attacks and future electric-piano friendly playback.';

  @override
  String get studyHarmonyTrackClassicalFocus1 =>
      'Tonic / predominant / dominant function and cadence types';

  @override
  String get studyHarmonyTrackClassicalFocus2 =>
      'Inversion literacy, including first inversion and cadential 6/4 behavior';

  @override
  String get studyHarmonyTrackClassicalFocus3 =>
      'Voice-leading stability, sequence, and functional modulation basics';

  @override
  String get studyHarmonyTrackClassicalLess1 =>
      'Heavy tension stacking, quartal color, and upper-structure thinking';

  @override
  String get studyHarmonyTrackClassicalLess2 =>
      'Loop-driven pop repetition as the main learning frame';

  @override
  String get studyHarmonyTrackClassicalRecommendedFor =>
      'Learners who want clear functional hearing, inversion awareness, and disciplined voice leading.';

  @override
  String get studyHarmonyTrackClassicalTheoryTone =>
      'Structured, function-first, and phrased in a way that supports listening as well as label recognition.';

  @override
  String get studyHarmonyTrackClassicalHeroHeadline =>
      'Hear function and cadence clearly';

  @override
  String get studyHarmonyTrackClassicalHeroBody =>
      'This track emphasizes functional arrival, inversion control, and phrase endings that feel architecturally clear.';

  @override
  String get studyHarmonyTrackClassicalQuickPracticeCue =>
      'Start with cadence lab drills, then compare how inversions change the same function.';

  @override
  String get studyHarmonyTrackClassicalSoundLabel =>
      'Clear / acoustic / focused';

  @override
  String get studyHarmonyTrackClassicalSoundSummary =>
      'Shared piano for now, with room for a more direct acoustic profile in later releases.';

  @override
  String get studyHarmonyPopChapterSignatureLoopsTitle => 'Signature Pop Loops';

  @override
  String get studyHarmonyPopChapterSignatureLoopsDescription =>
      'Build practical pop instincts with hook gravity, borrowed lift, and bass motion that feels arrangement-ready.';

  @override
  String get studyHarmonyPopLessonHookGravityTitle => 'Hook Gravity';

  @override
  String get studyHarmonyPopLessonHookGravityDescription =>
      'Hear why modern four-chord loops stay catchy even when the harmony is simple.';

  @override
  String get studyHarmonyPopLessonBorrowedLiftTitle => 'Borrowed Lift';

  @override
  String get studyHarmonyPopLessonBorrowedLiftDescription =>
      'Experience restrained borrowed-color chords that brighten or darken a section without derailing the hook.';

  @override
  String get studyHarmonyPopLessonBassMotionTitle => 'Bass Motion';

  @override
  String get studyHarmonyPopLessonBassMotionDescription =>
      'Use slash-bass and line motion to create lift while the upper harmony stays familiar.';

  @override
  String get studyHarmonyPopLessonBossTitle => 'Pre-Chorus Lift Checkpoint';

  @override
  String get studyHarmonyPopLessonBossDescription =>
      'Combine loop gravity, borrowed color, and bass motion in one song-ready pop slice.';

  @override
  String get studyHarmonyJazzChapterGuideToneLabTitle => 'Guide-Tone Lab';

  @override
  String get studyHarmonyJazzChapterGuideToneLabDescription =>
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Reconoce cómo se siente el movimiento minor iiø-V-i y por qué allí el dominante suena más urgente.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceTitle =>
      'Tritone and Backdoor';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceDescription =>
      'Compare substitute-dominant and backdoor arrivals as plausible jazz routes into the same tonic.';

  @override
  String get studyHarmonyJazzLessonBossTitle => 'Turnaround Checkpoint';

  @override
  String get studyHarmonyJazzLessonBossDescription =>
      'Combina major ii-V-I, minor iiø-V-i, color rootless y reharm cuidadoso sin perder la claridad del punto de llegada de la cadencia.';

  @override
  String get studyHarmonyClassicalChapterCadenceLabTitle => 'Cadence Lab';

  @override
  String get studyHarmonyClassicalChapterCadenceLabDescription =>
      'Strengthen functional hearing with cadences, inversions, and carefully controlled secondary dominants.';

  @override
  String get studyHarmonyClassicalLessonCadenceTitle => 'Cadence Function';

  @override
  String get studyHarmonyClassicalLessonCadenceDescription =>
      'Sort tonic, predominant, and dominant behavior by how each chord prepares or completes the phrase.';

  @override
  String get studyHarmonyClassicalLessonInversionTitle => 'Inversion Control';

  @override
  String get studyHarmonyClassicalLessonInversionDescription =>
      'Hear how inversions change the bass line and the stability of an arrival.';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantTitle =>
      'Functional Secondary Dominants';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantDescription =>
      'Treat secondary dominants as directed functional events instead of generic color chords.';

  @override
  String get studyHarmonyClassicalLessonBossTitle => 'Arrival Checkpoint';

  @override
  String get studyHarmonyClassicalLessonBossDescription =>
      'Combine cadence shape, inversion awareness, and secondary-dominant pull in one controlled phrase.';

  @override
  String studyHarmonyPlayStyleLabel(String playStyle) {
    String _temp0 = intl.Intl.selectLogic(playStyle, {
      'competitor': 'Competitor',
      'collector': 'Collector',
      'explorer': 'Explorer',
      'stabilizer': 'Stabilizer',
      'balanced': 'Balanced',
      'other': 'Balanced',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyRewardFocusLabel(String focus) {
    String _temp0 = intl.Intl.selectLogic(focus, {
      'mastery': 'Focus: Mastery',
      'achievements': 'Focus: Achievements',
      'cosmetics': 'Focus: Cosmetics',
      'currency': 'Focus: Currency',
      'collection': 'Focus: Collection',
      'other': 'Focus',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress) {
    return 'Next $rewardTitle $progress%';
  }

  @override
  String studyHarmonyCurrencyBalanceLabel(String currencyTitle, int amount) {
    return '$currencyTitle $amount';
  }

  @override
  String studyHarmonyCurrencyGrantLabel(String currencyTitle, int amount) {
    return '$currencyTitle +$amount';
  }

  @override
  String studyHarmonyDifficultyLaneLabel(String lane) {
    String _temp0 = intl.Intl.selectLogic(lane, {
      'recovery': 'Recovery Lane',
      'groove': 'Groove Lane',
      'push': 'Push Lane',
      'clutch': 'Clutch Lane',
      'legend': 'Legend Lane',
      'other': 'Practice Lane',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPressureTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'calm': 'Calm Pressure',
      'steady': 'Steady Pressure',
      'hot': 'Hot Pressure',
      'charged': 'Charged Pressure',
      'overdrive': 'Overdrive',
      'other': 'Pressure',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyForgivenessTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'strict': 'Strict Windows',
      'tight': 'Tight Windows',
      'balanced': 'Balanced Windows',
      'kind': 'Kind Windows',
      'generous': 'Generous Windows',
      'other': 'Timing Windows',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyComboGoalLabel(int comboTarget) {
    return 'Combo Goal $comboTarget';
  }

  @override
  String studyHarmonyRuntimeTuningSummary(int lives, int goal) {
    return 'Lives $lives | Goal $goal';
  }

  @override
  String studyHarmonyCoachLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Supportive Coach',
      'structured': 'Structured Coach',
      'challengeForward': 'Challenge Coach',
      'analytical': 'Analytical Coach',
      'restorative': 'Restorative Coach',
      'other': 'Coach',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyCoachLine(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Protect flow first and let confidence compound.',
      'structured': 'Follow the structure and the gains will stick.',
      'challengeForward': 'Lean into the pressure and push for a sharper run.',
      'analytical': 'Read the weak point and refine it with precision.',
      'restorative': 'This run is about rebuilding rhythm without tilt.',
      'other': 'Keep the next run focused and intentional.',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPacingSegmentLabel(String segment, int minutes) {
    String _temp0 = intl.Intl.selectLogic(segment, {
      'warmup': 'Warmup',
      'tension': 'Tension',
      'release': 'Release',
      'reward': 'Reward',
      'other': 'Segment',
    });
    return '$_temp0 ${minutes}m';
  }

  @override
  String studyHarmonyPacingSummaryLabel(String segments) {
    return 'Pacing $segments';
  }

  @override
  String studyHarmonyArcadeRiskLabel(String risk) {
    String _temp0 = intl.Intl.selectLogic(risk, {
      'forgiving': 'Low Risk',
      'balanced': 'Balanced Risk',
      'tense': 'High Tension',
      'punishing': 'Punishing Risk',
      'other': 'Arcade Risk',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRewardStyleLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'currency': 'Currency Loop',
      'cosmetic': 'Cosmetic Hunt',
      'title': 'Title Hunt',
      'trophy': 'Trophy Run',
      'bundle': 'Bundle Rewards',
      'prestige': 'Prestige Rewards',
      'other': 'Reward Loop',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count) {
    return 'Combo bonus every $count';
  }

  @override
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives) {
    return 'Miss costs $lives';
  }

  @override
  String get studyHarmonyArcadeRuntimeModifierPulses => 'Modifier pulses';

  @override
  String get studyHarmonyArcadeRuntimeGhostPressure => 'Ghost pressure';

  @override
  String get studyHarmonyArcadeRuntimeShopBiasedLoot => 'Shop-biased loot';

  @override
  String get studyHarmonyArcadeRuntimeSteadyRuleset => 'Steady ruleset';

  @override
  String studyHarmonyShopStateLabel(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'alreadyPurchased': 'Already purchased',
      'readyToBuy': 'Ready to buy',
      'progressLocked': 'Progress locked',
      'other': 'Shop state',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyShopActionLabel(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'buy': 'Buy',
      'equipped': 'Equipped',
      'equip': 'Equip',
      'other': 'Shop action',
    });
    return '$_temp0';
  }

  @override
  String get melodyCurrentLineFeelTitle => 'Current line feel';

  @override
  String get melodyLinePersonalityTitle => 'Line personality';

  @override
  String get melodyLinePersonalityBody =>
      'These four sliders shape why guided, standard, and advanced can feel different even before you change the harmony.';

  @override
  String get melodySyncopationBiasTitle => 'Syncopation Bias';

  @override
  String get melodySyncopationBiasBody =>
      'Leans toward offbeat starts, anticipations, and rhythmic lift.';

  @override
  String get melodyColorRealizationBiasTitle => 'Color Realization Bias';

  @override
  String get melodyColorRealizationBiasBody =>
      'Lets the melody pick up featured tensions and color tones more often.';

  @override
  String get melodyNoveltyTargetTitle => 'Novelty Target';

  @override
  String get melodyNoveltyTargetBody =>
      'Reduces exact repeats and nudges the line toward fresher interval shapes.';

  @override
  String get melodyMotifVariationBiasTitle => 'Motif Variation Bias';

  @override
  String get melodyMotifVariationBiasBody =>
      'Turns motif reuse into sequence, tail changes, and rhythmic variation.';

  @override
  String get studyHarmonyArcadeRulesTitle => 'Arcade Rules';

  @override
  String studyHarmonySessionLengthLabel(int minutes) {
    return '$minutes min run';
  }

  @override
  String studyHarmonyRewardKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'achievement': 'Achievement',
      'title': 'Title',
      'cosmetic': 'Cosmetic',
      'shopItem': 'Shop Unlock',
      'other': 'Reward',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives) {
    return 'Misses cost $lives hearts';
  }

  @override
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount) {
    return 'Misses push progress back by $amount';
  }

  @override
  String studyHarmonyArcadeRuntimeComboProgressLabel(
    int threshold,
    int amount,
  ) {
    return 'Every $threshold combo adds +$amount progress';
  }

  @override
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount) {
    return 'Every $threshold combo adds +$amount heart';
  }

  @override
  String get studyHarmonyArcadeRuntimeComboResetLabel => 'Misses reset combo';

  @override
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount) {
    return 'Misses cut combo by $amount';
  }

  @override
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel =>
      'Choices reshuffle';

  @override
  String get studyHarmonyArcadeRuntimeMissedReplayLabel =>
      'Missed prompts replay';

  @override
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel => 'No prompt repeats';

  @override
  String get studyHarmonyRuntimeBundleClearBonusTitle => 'Clear Bonus';

  @override
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle => 'Precision Bonus';

  @override
  String get studyHarmonyRuntimeBundleComboBonusTitle => 'Combo Bonus';

  @override
  String get studyHarmonyRuntimeBundleModeBonusTitle => 'Mode Bonus';

  @override
  String get studyHarmonyRuntimeBundleMasteryBonusTitle => 'Mastery Bonus';

  @override
  String get melodyQuickPresetGuideLineLabel => 'Guide Line';

  @override
  String get melodyQuickPresetSongLineLabel => 'Song Line';

  @override
  String get melodyQuickPresetColorLineLabel => 'Color Line';

  @override
  String get melodyQuickPresetGuideCompactLabel => 'Guide';

  @override
  String get melodyQuickPresetSongCompactLabel => 'Song';

  @override
  String get melodyQuickPresetColorCompactLabel => 'Color';

  @override
  String get melodyQuickPresetGuideShort => 'steady guide notes';

  @override
  String get melodyQuickPresetSongShort => 'singable contour';

  @override
  String get melodyQuickPresetColorShort => 'color-forward line';

  @override
  String get melodyQuickPresetPanelTitle => 'Melody Presets';

  @override
  String get melodyQuickPresetPanelCompactTitle => 'Line Presets';

  @override
  String get melodyQuickPresetOffLabel => 'Off';

  @override
  String get melodyQuickPresetCompactOffLabel => 'Line Off';

  @override
  String get melodyMetricDensityLabel => 'Density';

  @override
  String get melodyMetricStyleLabel => 'Style';

  @override
  String get melodyMetricSyncLabel => 'Sync';

  @override
  String get melodyMetricColorLabel => 'Color';

  @override
  String get melodyMetricNoveltyLabel => 'Novelty';

  @override
  String get melodyMetricMotifLabel => 'Motif';

  @override
  String get melodyMetricChromaticLabel => 'Chromatic';

  @override
  String get practiceFirstRunWelcomeTitle => 'Tu primer acorde está listo';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'Ya se aplicó un perfil inicial apto para principiantes. Escúchalo primero y luego desliza la tarjeta para explorar el siguiente acorde.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel está listo. Escúchalo primero y luego desliza la tarjeta para explorar lo que sigue. También puedes abrir el asistente de configuración para personalizar el inicio.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Idioma de notación musical';

  @override
  String get musicNotationLocaleHelp =>
      'Controla el idioma usado para las ayudas opcionales de números romanos y texto de acordes.';

  @override
  String get musicNotationLocaleUiDefault => 'Igual que la app';

  @override
  String get musicNotationLocaleEnglish => 'Inglés';

  @override
  String get noteNamingStyle => 'Nombres de notas';

  @override
  String get noteNamingStyleHelp =>
      'Cambia los nombres visibles de notas y tonalidades sin alterar la lógica armónica.';

  @override
  String get noteNamingStyleEnglish => 'Letras inglesas';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Mostrar ayuda de números romanos';

  @override
  String get showRomanNumeralAssistHelp =>
      'Añade una breve explicación junto a las etiquetas de números romanos.';

  @override
  String get showChordTextAssist => 'Mostrar ayuda de texto de acordes';

  @override
  String get showChordTextAssistHelp =>
      'Añade una breve explicación sobre la cualidad del acorde y sus tensiones.';

  @override
  String get premiumUnlockTitle => 'Chordest Premium';

  @override
  String get premiumUnlockBody =>
      'A one-time purchase permanently unlocks Smart Generator and advanced harmonic color controls. Free Generator, Analyzer, metronome, and language support stay available.';

  @override
  String get premiumUnlockRequestedFeatureTitle => 'Requested in this flow';

  @override
  String get premiumUnlockOfflineCacheTitle =>
      'Using your last confirmed unlock';

  @override
  String get premiumUnlockOfflineCacheBody =>
      'The store is unavailable right now, so the app is using your last confirmed premium unlock cache.';

  @override
  String get premiumUnlockFreeTierTitle => 'Free';

  @override
  String get premiumUnlockFreeTierLineGenerator =>
      'Basic Generator, chord display, inversions, slash bass, and core metronome';

  @override
  String get premiumUnlockFreeTierLineAnalyzer =>
      'Conservative Analyzer with confidence and ambiguity warnings';

  @override
  String get premiumUnlockFreeTierLineMetronome =>
      'Language, theme, setup assistant, and standard practice settings';

  @override
  String get premiumUnlockPremiumTierTitle => 'Premium unlock';

  @override
  String get premiumUnlockPremiumLineSmartGenerator =>
      'Smart Generator mode for progression-aware generation in selected keys';

  @override
  String get premiumUnlockPremiumLineHarmonyColors =>
      'Secondary dominants, substitute dominants, modal interchange, and advanced tensions';

  @override
  String get premiumUnlockPremiumLineAdvancedSmartControls =>
      'Modulation intensity, jazz preset, and source profile controls for Smart Generator';

  @override
  String premiumUnlockBuyButton(Object priceLabel) {
    return 'Desbloqueo permanente ($priceLabel)';
  }

  @override
  String get premiumUnlockBuyButtonUnavailable => 'Unlock permanently';

  @override
  String get premiumUnlockRestoreButton => 'Restore purchase';

  @override
  String get premiumUnlockKeepFreeButton => 'Keep using free';

  @override
  String get premiumUnlockStoreFallbackBody =>
      'Store product info is not available right now. Free features keep working, and you can retry or restore later.';

  @override
  String get premiumUnlockStorePriceHint =>
      'Price comes from the store. The app does not hardcode a fixed price.';

  @override
  String get premiumUnlockStoreUnavailableTitle => 'Store unavailable';

  @override
  String get premiumUnlockStoreUnavailableBody =>
      'La conexión con la tienda no está disponible en este momento. Las funciones gratuitas siguen funcionando.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'La información del producto premium no está disponible ahora mismo. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockPurchaseSuccessTitle => 'Premium unlocked';

  @override
  String get premiumUnlockPurchaseSuccessBody =>
      'Your permanent premium unlock is now active on this device.';

  @override
  String get premiumUnlockRestoreSuccessTitle => 'Purchase restored';

  @override
  String get premiumUnlockRestoreSuccessBody =>
      'Your premium unlock was restored from the store.';

  @override
  String get premiumUnlockRestoreNotFoundTitle => 'Nothing to restore';

  @override
  String get premiumUnlockRestoreNotFoundBody =>
      'No matching premium unlock was found for this store account.';

  @override
  String get premiumUnlockPurchaseCancelledTitle => 'Purchase canceled';

  @override
  String get premiumUnlockPurchaseCancelledBody =>
      'No charge was made. Free features are still available.';

  @override
  String get premiumUnlockPurchasePendingTitle => 'Purchase pending';

  @override
  String get premiumUnlockPurchasePendingBody =>
      'The store marked this purchase as pending. Premium unlock will activate after confirmation.';

  @override
  String get premiumUnlockPurchaseFailedTitle => 'Purchase failed';

  @override
  String get premiumUnlockPurchaseFailedBody =>
      'No se pudo completar la compra. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockAlreadyOwned => 'Premium unlocked';

  @override
  String get premiumUnlockAlreadyOwnedTitle => 'Already unlocked';

  @override
  String get premiumUnlockAlreadyOwnedBody =>
      'This store account already has the premium unlock.';

  @override
  String get premiumUnlockHighlightSmartGenerator =>
      'Smart Generator mode and its deeper progression controls are part of the premium unlock.';

  @override
  String get premiumUnlockHighlightAdvancedHarmony =>
      'Non-diatonic color options and advanced tensions are part of the premium unlock.';

  @override
  String get premiumUnlockCardTitle => 'Premium unlock';

  @override
  String get premiumUnlockCardBodyUnlocked =>
      'Your one-time premium unlock is active.';

  @override
  String get premiumUnlockCardBodyLocked =>
      'Unlock Smart Generator and advanced harmonic color controls with one purchase.';

  @override
  String get premiumUnlockCardButton => 'View premium';

  @override
  String get premiumUnlockGeneratorHint =>
      'Smart Generator and advanced harmonic colors unlock with a one-time premium purchase.';

  @override
  String get premiumUnlockSettingsHintTitle => 'Premium controls';

  @override
  String get premiumUnlockSettingsHintBody =>
      'Smart Generator, non-diatonic color controls, and advanced tensions are part of the one-time premium unlock.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountCardSignedOutBody =>
      'Sign in to link premium to your account and restore it on your other devices.';

  @override
  String accountCardSignedInBody(Object email) {
    return 'Signed in as $email. Premium sync and restore now follow this account.';
  }

  @override
  String get accountCardUnavailableBody =>
      'Account features are not configured in this build yet. Add Firebase runtime configuration to enable sign-in.';

  @override
  String get accountOpenButton => 'Sign in';

  @override
  String get accountManageButton => 'Manage account';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String get accountCreateButton => 'Create account';

  @override
  String get accountSwitchToCreateButton => 'Create a new account';

  @override
  String get accountSwitchToSignInButton => 'I already have an account';

  @override
  String get accountForgotPasswordButton => 'Reset password';

  @override
  String get accountSignOutButton => 'Sign out';

  @override
  String get accountMessageSignedIn => 'You\'re signed in.';

  @override
  String get accountMessageSignedUp =>
      'Your account was created and signed in.';

  @override
  String get accountMessageSignedOut => 'You signed out of this account.';

  @override
  String get accountMessagePasswordResetSent => 'Password reset email sent.';

  @override
  String get accountMessageInvalidCredentials =>
      'Check your email and password and try again.';

  @override
  String get accountMessageEmailInUse => 'That email is already in use.';

  @override
  String get accountMessageWeakPassword =>
      'Use a stronger password to create this account.';

  @override
  String get accountMessageUserNotFound =>
      'No account was found for that email.';

  @override
  String get accountMessageTooManyRequests =>
      'Too many attempts right now. Please try again later.';

  @override
  String get accountMessageNetworkError =>
      'The network request failed. Please check your connection.';

  @override
  String get accountMessageAuthUnavailable =>
      'Account sign-in is not configured in this build yet.';

  @override
  String get accountMessageUnknownError =>
      'The account request could not be completed.';

  @override
  String get accountDeleteButton => 'Delete account';

  @override
  String get accountDeleteDialogTitle => 'Delete account?';

  @override
  String accountDeleteDialogBody(Object email) {
    return 'This permanently deletes the Chordest account for $email and removes synced premium data. Store purchase history stays with your store account.';
  }

  @override
  String get accountDeletePasswordHelper =>
      'Enter your current password to confirm this deletion request.';

  @override
  String get accountDeleteConfirmButton => 'Delete permanently';

  @override
  String get accountDeleteCancelButton => 'Cancel';

  @override
  String get accountDeletePasswordRequired =>
      'Enter your current password to delete this account.';

  @override
  String get accountMessageDeleted =>
      'Your account and synced premium data were deleted.';

  @override
  String get accountMessageDeleteRequiresRecentLogin =>
      'For safety, enter your current password and try again.';

  @override
  String get accountMessageDataDeletionFailed =>
      'We couldn\'t remove your synced account data. Please try again.';

  @override
  String get premiumUnlockAccountSyncTitle => 'Account sync';

  @override
  String get premiumUnlockAccountSyncSignedOutBody =>
      'You can keep using premium locally, but signing in lets this unlock follow your account to other devices.';

  @override
  String premiumUnlockAccountSyncSignedInBody(Object email) {
    return 'Premium purchases and restores will sync to $email when this account is signed in.';
  }

  @override
  String get premiumUnlockAccountSyncUnavailableBody =>
      'Account sync is not configured in this build yet, so premium currently stays local to this device.';

  @override
  String get premiumUnlockAccountOpenButton => 'Account';
}

/// The translations for Spanish Castilian, as used in Spain (`es_ES`).
class AppLocalizationsEsEs extends AppLocalizationsEs {
  AppLocalizationsEsEs() : super('es_ES');

  @override
  String get settings => 'Ajustes';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Valor predeterminado del sistema';

  @override
  String get themeMode => 'Tema';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get setupAssistantTitle => 'Setup Assistant';

  @override
  String get setupAssistantSubtitle =>
      'A few quick choices will make your first practice session feel calmer. You can rerun this anytime.';

  @override
  String get setupAssistantCurrentMode => 'Current setup';

  @override
  String get setupAssistantModeGuided => 'Guided mode';

  @override
  String get setupAssistantModeStandard => 'Standard mode';

  @override
  String get setupAssistantModeAdvanced => 'Advanced mode';

  @override
  String get setupAssistantRunAgain => 'Run setup assistant again';

  @override
  String get setupAssistantCardBody =>
      'Use a gentler profile now, then open advanced controls whenever you want more room.';

  @override
  String get setupAssistantPreparingTitle => 'We\'ll start gently';

  @override
  String get setupAssistantPreparingBody =>
      'Before the generator shows any chords, we\'ll set up a comfortable starting point in a few taps.';

  @override
  String setupAssistantProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setupAssistantSkip => 'Skip';

  @override
  String get setupAssistantBack => 'Back';

  @override
  String get setupAssistantNext => 'Next';

  @override
  String get setupAssistantApply => 'Apply';

  @override
  String get setupAssistantGoalQuestionTitle =>
      'What would you like this generator to help with first?';

  @override
  String get setupAssistantGoalQuestionBody =>
      'Pick the one that sounds closest. Nothing here is permanent.';

  @override
  String get setupAssistantGoalEarTitle => 'Hear and recognize chords';

  @override
  String get setupAssistantGoalEarBody =>
      'Short, friendly prompts for listening and recognition.';

  @override
  String get setupAssistantGoalKeyboardTitle => 'Keyboard hand practice';

  @override
  String get setupAssistantGoalKeyboardBody =>
      'Simple shapes and readable symbols for your hands first.';

  @override
  String get setupAssistantGoalSongTitle => 'Song ideas';

  @override
  String get setupAssistantGoalSongBody =>
      'Keep the generator musical without dumping you into chaos.';

  @override
  String get setupAssistantGoalHarmonyTitle => 'Harmony study';

  @override
  String get setupAssistantGoalHarmonyBody =>
      'Start clear, then leave room to grow into deeper harmony.';

  @override
  String get setupAssistantLiteracyQuestionTitle =>
      'Which sentence feels closest right now?';

  @override
  String get setupAssistantLiteracyQuestionBody =>
      'Choose the most comfortable answer, not the most ambitious one.';

  @override
  String get setupAssistantLiteracyAbsoluteTitle =>
      'C, Cm, C7, and Cmaj7 still blur together';

  @override
  String get setupAssistantLiteracyAbsoluteBody =>
      'Keep things extra readable and familiar.';

  @override
  String get setupAssistantLiteracyBasicTitle => 'I can read maj7 / m7 / 7';

  @override
  String get setupAssistantLiteracyBasicBody =>
      'Stay safe, but allow a little more range.';

  @override
  String get setupAssistantLiteracyFunctionalTitle =>
      'I mostly follow ii-V-I and diatonic function';

  @override
  String get setupAssistantLiteracyFunctionalBody =>
      'Keep the harmony clear with a bit more motion.';

  @override
  String get setupAssistantLiteracyAdvancedTitle =>
      'Colorful reharmonization and extensions already feel familiar';

  @override
  String get setupAssistantLiteracyAdvancedBody =>
      'Leave more of the power-user range available.';

  @override
  String get setupAssistantHandQuestionTitle =>
      'How comfortable do your hands feel on keys?';

  @override
  String get setupAssistantHandQuestionBody =>
      'We\'ll use this to keep voicings playable.';

  @override
  String get setupAssistantHandThreeTitle => 'Three-note shapes feel best';

  @override
  String get setupAssistantHandThreeBody => 'Keep the hand shape compact.';

  @override
  String get setupAssistantHandFourTitle => 'Four notes are okay';

  @override
  String get setupAssistantHandFourBody => 'Allow a little more spread.';

  @override
  String get setupAssistantHandJazzTitle => 'Jazzier shapes feel comfortable';

  @override
  String get setupAssistantHandJazzBody =>
      'Open the door to larger voicings later.';

  @override
  String get setupAssistantColorQuestionTitle =>
      'How colorful should the sound feel at first?';

  @override
  String get setupAssistantColorQuestionBody => 'When in doubt, start simpler.';

  @override
  String get setupAssistantColorSafeTitle => 'Safe and familiar';

  @override
  String get setupAssistantColorSafeBody =>
      'Stay close to classic, readable harmony.';

  @override
  String get setupAssistantColorJazzyTitle => 'A little jazzy';

  @override
  String get setupAssistantColorJazzyBody =>
      'Add a touch of color without getting wild.';

  @override
  String get setupAssistantColorColorfulTitle => 'Quite colorful';

  @override
  String get setupAssistantColorColorfulBody =>
      'Leave more room for modern color.';

  @override
  String get setupAssistantSymbolQuestionTitle =>
      'Which chord spelling feels easiest to read?';

  @override
  String get setupAssistantSymbolQuestionBody =>
      'This only changes how the chord is shown.';

  @override
  String get setupAssistantSymbolMajTextBody => 'Clear and beginner-friendly.';

  @override
  String get setupAssistantSymbolCompactBody =>
      'Shorter if you already like compact symbols.';

  @override
  String get setupAssistantSymbolDeltaBody =>
      'Jazz-style if that is what your eyes expect.';

  @override
  String get setupAssistantKeyQuestionTitle => 'Which key should we start in?';

  @override
  String get setupAssistantKeyQuestionBody =>
      'C major is the easiest default, but you can change it later.';

  @override
  String get setupAssistantKeyCMajorBody => 'Best beginner starting point.';

  @override
  String get setupAssistantKeyGMajorBody =>
      'A bright major key with one sharp.';

  @override
  String get setupAssistantKeyFMajorBody => 'A warm major key with one flat.';

  @override
  String get setupAssistantPreviewTitle => 'Try your first result';

  @override
  String get setupAssistantPreviewBody =>
      'This is about what the generator will feel like. You can make it simpler or a little jazzier before you start.';

  @override
  String get setupAssistantPreviewListen => 'Hear this sample';

  @override
  String get setupAssistantPreviewPlaying => 'Playing sample...';

  @override
  String get setupAssistantStartNow => 'Start with this';

  @override
  String get setupAssistantAdjustEasier => 'Make it easier';

  @override
  String get setupAssistantAdjustJazzier => 'A little more jazzy';

  @override
  String get setupAssistantPreviewKeyLabel => 'Key';

  @override
  String get setupAssistantPreviewNotationLabel => 'Notation';

  @override
  String get setupAssistantPreviewDifficultyLabel => 'Feel';

  @override
  String get setupAssistantPreviewProgressionLabel => 'Sample progression';

  @override
  String get setupAssistantPreviewProgressionBody =>
      'A short four-chord sample built from your setup.';

  @override
  String get setupAssistantPreviewSummaryAbsolute => 'Beginner-friendly start';

  @override
  String get setupAssistantPreviewSummaryBasic =>
      'Readable seventh-chord start';

  @override
  String get setupAssistantPreviewSummaryFunctional =>
      'Functional harmony start';

  @override
  String get setupAssistantPreviewSummaryAdvanced => 'Colorful jazz start';

  @override
  String get setupAssistantPreviewBodyTriads =>
      'Mostly familiar triads in a safe key, with compact voicings and no spicy surprises.';

  @override
  String get setupAssistantPreviewBodySevenths =>
      'maj7, m7, and 7 show up clearly, while the progression still stays calm and readable.';

  @override
  String get setupAssistantPreviewBodySafeExtensions =>
      'A little extra color can appear, but it stays within safe, familiar extensions.';

  @override
  String get setupAssistantPreviewBodyFullExtensions =>
      'The preview leaves more room for modern color, richer movement, and denser harmony.';

  @override
  String get setupAssistantNotationMajText => 'Cmaj7 style';

  @override
  String get setupAssistantNotationCompact => 'CM7 style';

  @override
  String get setupAssistantNotationDelta => 'CΔ7 style';

  @override
  String get setupAssistantDifficultyTriads =>
      'Simple triads and core movement';

  @override
  String get setupAssistantDifficultySevenths => 'maj7 / m7 / 7 centered';

  @override
  String get setupAssistantDifficultySafeExtensions =>
      'Safe color with 9 / 11 / 13';

  @override
  String get setupAssistantDifficultyFullExtensions =>
      'Full color and wider motion';

  @override
  String get setupAssistantStudyHarmonyTitle =>
      'Want a gentler theory path too?';

  @override
  String get setupAssistantStudyHarmonyBody =>
      'Study Harmony can walk you through the basics while this generator stays in a safe lane.';

  @override
  String get setupAssistantStudyHarmonyCta => 'Start Study Harmony';

  @override
  String get setupAssistantGuidedSettingsTitle =>
      'Beginner-friendly setup is on';

  @override
  String get setupAssistantGuidedSettingsBody =>
      'Core controls stay close by here. Everything else is still available when you want it.';

  @override
  String get setupAssistantAdvancedSectionTitle => 'More controls';

  @override
  String get setupAssistantAdvancedSectionBody =>
      'Open the full settings page if you want every generator option.';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Enciende el metrónomo para escuchar un clic en cada tiempo mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metrónomo';

  @override
  String get metronomeSoundClassic => 'Clásico';

  @override
  String get metronomeSoundClickB => 'Haga clic en B';

  @override
  String get metronomeSoundClickC => 'Haga clic en C';

  @override
  String get metronomeSoundClickD => 'Haga clic en D';

  @override
  String get metronomeSoundClickE => 'Haga clic en E';

  @override
  String get metronomeSoundClickF => 'Haga clic en F';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get practiceMeter => 'Time Signature';

  @override
  String get practiceMeterHelp =>
      'Choose how many beats are in each bar for transport and metronome timing.';

  @override
  String get practiceTimeSignatureTwoFour => '2/4';

  @override
  String get practiceTimeSignatureThreeFour => '3/4';

  @override
  String get practiceTimeSignatureFourFour => '4/4';

  @override
  String get practiceTimeSignatureFiveFour => '5/4';

  @override
  String get practiceTimeSignatureSixEight => '6/8';

  @override
  String get practiceTimeSignatureSevenEight => '7/8';

  @override
  String get practiceTimeSignatureTwelveEight => '12/8';

  @override
  String get harmonicRhythm => 'Harmonic Rhythm';

  @override
  String get harmonicRhythmHelp =>
      'Choose how often chord changes can happen inside the bar.';

  @override
  String get harmonicRhythmOnePerBar => 'One per bar';

  @override
  String get harmonicRhythmTwoPerBar => 'Two per bar';

  @override
  String get harmonicRhythmPhraseAwareJazz => 'Phrase-aware jazz';

  @override
  String get harmonicRhythmCadenceCompression => 'Cadence compression';

  @override
  String get keys => 'Llaves';

  @override
  String get noKeysSelected =>
      'No hay claves seleccionadas. Deja todas las teclas apagadas para practicar en modo libre en cada raíz.';

  @override
  String get keysSelectedHelp =>
      'Las claves seleccionadas se utilizan para el modo aleatorio con reconocimiento de clave y el modo Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional conservando las opciones no diatónico habilitadas.';

  @override
  String get advancedSmartGenerator => 'Avanzado Smart Generator';

  @override
  String get modulationIntensity => 'Intensidad de modulación';

  @override
  String get modulationIntensityOff => 'Apagado';

  @override
  String get modulationIntensityLow => 'Bajo';

  @override
  String get modulationIntensityMedium => 'Medio';

  @override
  String get modulationIntensityHigh => 'Alto';

  @override
  String get jazzPreset => 'Preajuste de jazz';

  @override
  String get jazzPresetStandardsCore => 'Núcleo de estándares';

  @override
  String get jazzPresetModulationStudy => 'Estudio de modulación';

  @override
  String get jazzPresetAdvanced => 'Avanzado';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Estándar de libro falso';

  @override
  String get sourceProfileRecordingInspired => 'Grabación inspirada';

  @override
  String get smartDiagnostics => 'Diagnóstico inteligente';

  @override
  String get smartDiagnosticsHelp =>
      'Registra los seguimientos de decisiones Smart Generator para la depuración.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Seleccione al menos una tecla para usar el modo Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones que no son diatónico están disponibles solo en modo clave.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Sustituto dominante';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal sólo aparece en modo clave, por lo que esta opción está deshabilitada en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get keyCenterLabelStyle => 'Estilo de etiqueta clave';

  @override
  String get keyCenterLabelStyleHelp =>
      'Elija entre nombres de modo explícitos y etiquetas tónicas clásicas en mayúsculas/minúsculas.';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Cambia solo la capa de visualización. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compacto';

  @override
  String get styleMajText => 'MajTexto';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get keyCenterLabelStyleModeText => 'Do mayor: / Do menor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C:/c:';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get chordTypeFilters => 'Tipos de acordes';

  @override
  String get chordTypeFiltersHelp =>
      'Elige que tipos de acordes pueden aparecer en el generador.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total activados';
  }

  @override
  String get chordTypeGroupTriads => 'Triadas';

  @override
  String get chordTypeGroupSevenths => 'Septimas';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sextas y notas anadidas';

  @override
  String get chordTypeGroupDominantVariants => 'Variantes dominantes';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 solo esta disponible cuando se selecciona al menos una tonalidad.';

  @override
  String get chordTypeKeepOneEnabled =>
      'Manten al menos un tipo de acorde activado.';

  @override
  String get tensionHelp =>
      'Perfil número romano y chips seleccionados únicamente';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Habilitar inversiones';

  @override
  String get inversionHelp =>
      'Representación aleatoria de graves después de la selección de acordes; no rastrea el bajo anterior.';

  @override
  String get firstInversion => '1ra inversión';

  @override
  String get secondInversion => '2da inversión';

  @override
  String get thirdInversion => '3ra inversión';

  @override
  String get keyPracticeOverview =>
      'Descripción general de las prácticas clave';

  @override
  String get freePracticeOverview => 'Descripción general de la práctica libre';

  @override
  String get keyModeTag => 'Modo clave';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las claves';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Presione Siguiente acorde para comenzar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Utiliza las 12 raíces cromáticas con cualidades de acordes aleatorios para una práctica de lectura amplia.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo función armónica en las teclas seleccionadas al tiempo que permite un movimiento elegante del generador inteligente.';

  @override
  String get keyPracticeDescription =>
      'Utiliza las claves seleccionadas y los número romano habilitados para generar material de práctica diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Espacio: siguiente acorde Enter: iniciar o pausar la reproducción automática Arriba/Abajo: ajustar BPM';

  @override
  String get currentChord => 'Acorde actual';

  @override
  String get nextChord => 'Acorde siguiente';

  @override
  String get audioPlayChord => 'tocar acorde';

  @override
  String get audioPlayArpeggio => 'Tocar arpegio';

  @override
  String get audioPlayProgression => 'Progresión del juego';

  @override
  String get audioPlayPrompt => 'Reproducir mensaje';

  @override
  String get startAutoplay => 'Iniciar reproducción automática';

  @override
  String get pauseAutoplay => 'Pausar reproducción automática';

  @override
  String get stopAutoplay => 'Detener la reproducción automática';

  @override
  String get resetGeneratedChords => 'Reiniciar acordes generados';

  @override
  String get decreaseBpm => 'Disminuir BPM';

  @override
  String get increaseBpm => 'Aumentar BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min-$max';
  }

  @override
  String get modeMajor => 'importante';

  @override
  String get modeMinor => 'menor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Sugerencias de voicings';

  @override
  String get voicingSuggestionsSubtitle =>
      'Vea opciones de notas concretas para este acorde.';

  @override
  String get voicingSuggestionsEnabled => 'Habilitar sugerencias de voz';

  @override
  String get voicingSuggestionsHelp =>
      'Muestra tres ideas voicing a nivel de nota reproducibles para el acorde actual.';

  @override
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

  @override
  String get voicingComplexity => 'Complejidad de expresión';

  @override
  String get voicingComplexityHelp =>
      'Controla el color que pueden llegar a tener las sugerencias.';

  @override
  String get voicingComplexityBasic => 'Básico';

  @override
  String get voicingComplexityStandard => 'Estándar';

  @override
  String get voicingComplexityModern => 'Moderno';

  @override
  String get voicingTopNotePreference => 'Preferencia de nota superior';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Inclina sugerencias hacia un línea superior elegido. Los voicing bloqueados ganan primero, luego los acordes repetidos lo mantienen estable.';

  @override
  String get voicingTopNotePreferenceAuto => 'Automático';

  @override
  String get allowRootlessVoicings => 'Permitir voces desarraigadas';

  @override
  String get allowRootlessVoicingsHelp =>
      'Permitamos que las sugerencias omitan la raíz cuando los nota guía permanezcan claros.';

  @override
  String get maxVoicingNotes => 'Notas de voz máximas';

  @override
  String get lookAheadDepth => 'Profundidad de anticipación';

  @override
  String get lookAheadDepthHelp =>
      'Cuántos acordes futuros puede considerar el ranking.';

  @override
  String get showVoicingReasons => 'Mostrar razones para expresar';

  @override
  String get showVoicingReasonsHelp =>
      'Muestra breves fichas explicativas en cada tarjeta de sugerencias.';

  @override
  String get voicingSuggestionNatural => 'más natural';

  @override
  String get voicingSuggestionColorful => 'más colorido';

  @override
  String get voicingSuggestionEasy => 'mas facil';

  @override
  String get voicingSuggestionNaturalSubtitle => 'Primero la voz principal';

  @override
  String get voicingSuggestionColorfulSubtitle =>
      'Se inclina hacia los tonos de color.';

  @override
  String get voicingSuggestionEasySubtitle => 'Forma de mano compacta';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle =>
      'Conexión y resolución primero.';

  @override
  String get voicingSuggestionNaturalStableSubtitle =>
      'Misma forma, competición constante';

  @override
  String get voicingSuggestionTopLineSubtitle =>
      'Clientes potenciales de primera línea';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle =>
      'Tensión alterada en la delantera';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'Color cuarto moderno';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Borde sub-tritono con nota guía brillantes';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      'Tonos guía con extensiones brillantes.';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle =>
      'Tonos centrales, menor alcance';

  @override
  String get voicingSuggestionEasyStableSubtitle =>
      'Forma de mano fácil de repetir';

  @override
  String get voicingPerformanceSubtitle =>
      'Feature one representative comping shape and keep the next move in view.';

  @override
  String get voicingPerformanceCurrentTitle => 'Current voicing';

  @override
  String get voicingPerformanceNextTitle => 'Next preview';

  @override
  String get voicingPerformanceCurrentOnly => 'Current only';

  @override
  String get voicingPerformanceShared => 'Shared';

  @override
  String get voicingPerformanceNextOnly => 'Next move';

  @override
  String voicingPerformanceTopLinePath(Object current, Object next) {
    return 'Top line: $current -> $next';
  }

  @override
  String get voicingTopNoteLabel => 'Arriba';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'Objetivo de línea superior: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Bloqueado línea superior: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'línea superior repetido: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'línea superior más cercano a $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No hay línea superior exacto para $note';
  }

  @override
  String get voicingFamilyShell => 'Caparazón';

  @override
  String get voicingFamilyRootlessA => 'Sin raíces A';

  @override
  String get voicingFamilyRootlessB => 'Sin raíces B';

  @override
  String get voicingFamilySpread => 'Desparramar';

  @override
  String get voicingFamilySus => 'sus';

  @override
  String get voicingFamilyQuartal => 'cuarto';

  @override
  String get voicingFamilyAltered => 'alterado';

  @override
  String get voicingFamilyUpperStructure => 'Estructura superior';

  @override
  String get voicingLockSuggestion => 'Sugerencia de bloqueo';

  @override
  String get voicingUnlockSuggestion => 'Sugerencia de desbloqueo';

  @override
  String get voicingSelected => 'Seleccionado';

  @override
  String get voicingLocked => 'bloqueado';

  @override
  String get voicingReasonEssentialCore => 'Tonos esenciales cubiertos';

  @override
  String get voicingReasonGuideToneAnchor => '3.º/7.º ancla';

  @override
  String voicingReasonGuideResolution(int count) {
    return 'El tono guía $count se resuelve';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return 'Se mantienen los tonos comunes $count';
  }

  @override
  String get voicingReasonStableRepeat => 'Repetición estable';

  @override
  String get voicingReasonTopLineTarget => 'Objetivo de primera línea';

  @override
  String get voicingReasonLowMudAvoided => 'Claridad de registro bajo';

  @override
  String get voicingReasonCompactReach => 'Alcance cómodo';

  @override
  String get voicingReasonBassAnchor => 'Ancla de bajo respetada';

  @override
  String get voicingReasonNextChordReady => 'Siguiente acorde listo';

  @override
  String get voicingReasonAlteredColor => 'Tensiones alteradas';

  @override
  String get voicingReasonRootlessClarity => 'Forma ligera y sin raíces.';

  @override
  String get voicingReasonSusRelease => 'Configuración de lanzamiento de Sus';

  @override
  String get voicingReasonQuartalColor => 'color cuarto';

  @override
  String get voicingReasonUpperStructureColor =>
      'Color de la estructura superior';

  @override
  String get voicingReasonTritoneSubFlavor => 'Sabor sub-tritono';

  @override
  String get voicingReasonLockedContinuity => 'Continuidad bloqueada';

  @override
  String get voicingReasonGentleMotion => 'Movimiento suave de la mano';

  @override
  String get mainMenuIntro =>
      'Genera tu siguiente loop de acordes en Chordest y usa el Analyzer solo cuando necesites una lectura armónica cautelosa.';

  @override
  String get mainMenuGeneratorTitle => 'Generador Chordest';

  @override
  String get mainMenuGeneratorDescription =>
      'Empieza con un loop tocable, ayuda de voicings y controles rápidos de práctica.';

  @override
  String get openGenerator => 'Empezar práctica';

  @override
  String get openAnalyzer => 'Analizar progresión';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Consulta tonalidades probables, números romanos y avisos con una lectura conservadora.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Estudio de armonía';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Retoma lecciones, repasa capítulos y fortalece tu armonía práctica.';

  @override
  String get openStudyHarmony => 'Empezar armonía';

  @override
  String get studyHarmonyTitle => 'Estudio de armonía';

  @override
  String get studyHarmonySubtitle =>
      'Trabaje a través de un centro de armonía estructurado con entradas rápidas de lecciones y progreso de capítulos.';

  @override
  String get studyHarmonyPlaceholderTag => 'cubierta de estudio';

  @override
  String get studyHarmonyPlaceholderBody =>
      'Los datos de las lecciones, las indicaciones y las superficies de respuestas ya comparten un flujo de estudio reutilizable para notas, acordes, escalas y ejercicios de progresión.';

  @override
  String get studyHarmonyTestLevelTag => 'Ejercicio de practica';

  @override
  String get studyHarmonyTestLevelAction => 'taladro abierto';

  @override
  String get studyHarmonySubmit => 'Entregar';

  @override
  String get studyHarmonyNextPrompt => 'Siguiente mensaje';

  @override
  String get studyHarmonySelectedAnswers => 'Respuestas seleccionadas';

  @override
  String get studyHarmonySelectionEmpty =>
      'Aún no se han seleccionado respuestas.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total correcto';
  }

  @override
  String get studyHarmonyAttempts => 'Intentos';

  @override
  String get studyHarmonyAccuracy => 'Exactitud';

  @override
  String get studyHarmonyElapsedTime => 'Tiempo';

  @override
  String get studyHarmonyObjective => 'Meta';

  @override
  String get studyHarmonyPromptInstruction =>
      'Elige la respuesta correspondiente';

  @override
  String get studyHarmonyNeedSelection =>
      'Elija al menos una respuesta antes de enviar.';

  @override
  String get studyHarmonyCorrectLabel => 'Correcto';

  @override
  String get studyHarmonyIncorrectLabel => 'Incorrecto';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return 'Correcto. $answer fue la respuesta correcta.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return 'Incorrecto. $answer fue la respuesta correcta y perdiste una vida.';
  }

  @override
  String get studyHarmonyGameOverTitle => 'Juego terminado';

  @override
  String get studyHarmonyGameOverBody =>
      'Las tres vidas se han ido. Vuelva a intentar este nivel o regrese al centro Estudio de armonía.';

  @override
  String get studyHarmonyLevelCompleteTitle => 'Nivel superado';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'Has alcanzado el objetivo de la lección. Verifique su precisión y tiempo claro a continuación.';

  @override
  String get studyHarmonyBackToHub => 'Volver a Estudio de armonía';

  @override
  String get studyHarmonyRetry => 'Rever';

  @override
  String get studyHarmonyHubHeroEyebrow => 'Centro de estudios';

  @override
  String get studyHarmonyHubHeroBody =>
      'Utilice Continuar para retomar el impulso, Revisar para volver a visitar los puntos débiles y Diariamente para obtener una lección determinista de su camino desbloqueado.';

  @override
  String get studyHarmonyTrackFilterLabel => 'Rutas';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Base';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Clásica';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return 'Capítulos $cleared/$total completados';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return 'Habilidades $mastered/$total dominadas';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count revisiones listas';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'Racha x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count se ejecuta';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'Mejor $rank';
  }

  @override
  String get studyHarmonyBossTag => 'Jefe';

  @override
  String get studyHarmonyContinueCardTitle => 'Continuar';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Reanude la lección que tocó más recientemente.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Salta a la siguiente lección de tu frontera actual.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return 'Continuar: $lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => 'Continuar';

  @override
  String get studyHarmonyReviewCardTitle => 'Repaso';

  @override
  String get studyHarmonyReviewQueueHint => 'Sale de tu cola de repaso actual.';

  @override
  String get studyHarmonyReviewWeakHint =>
      'Sale del resultado más flojo entre tus lecciones jugadas.';

  @override
  String get studyHarmonyReviewFallbackHint =>
      'Aún no hay deuda de repaso, así que volvemos a tu frontera actual.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      'Esta lección pide otro intento tras un fallo o una sesión sin cerrar.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      'Esta lección está en cola para un repaso rápido de precisión.';

  @override
  String get studyHarmonyReviewAction => 'Repasar';

  @override
  String get studyHarmonyDailyCardTitle => 'Desafío diario';

  @override
  String get studyHarmonyDailyCardHint =>
      'Abra la selección determinista de hoy de sus lecciones desbloqueadas.';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      'La diaria de hoy ya está superada. Si quieres, vuelve a jugarla, o regresa mañana para cuidar la racha.';

  @override
  String get studyHarmonyDailyAction => 'Jugar diaria';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Semilla $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => 'Borrado diariamente hoy';

  @override
  String get studyHarmonyReviewSessionTitle => 'Revisión de puntos débiles';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return 'Combine una breve reseña sobre $chapterTitle y sus habilidades recientes más débiles.';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'Desafío diario';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return 'Juega la mezcla inicial de hoy creada a partir de $chapterTitle y tu frontera actual.';
  }

  @override
  String get studyHarmonyModeLesson => 'Modo de lección';

  @override
  String get studyHarmonyModeReview => 'Modo de revisión';

  @override
  String get studyHarmonyModeDaily => 'Modo diario';

  @override
  String get studyHarmonyModeLegacy => 'Modo de práctica';

  @override
  String get studyHarmonyShortcutHint =>
      'Ingrese envíos o continúe. R se reinicia. 1-9 elige una respuesta. Tab y Shift+Tab mueven el foco.';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$remaining de $total vidas restantes';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'Ganancias de habilidades';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Enfoque de revisión';

  @override
  String get studyHarmonyResultRewardTitle => 'Recompensa de sesión';

  @override
  String get studyHarmonyBonusGoalsTitle => 'Objetivos de bonificación';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'Rango $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return 'Mejores estrellas $rank · $stars';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return 'Racha diaria x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => 'Nueva marca personal';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded =>
      'Motivo de la revisión: es necesario volver a intentarlo';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh =>
      'Motivo de la revisión: actualización de precisión';

  @override
  String get studyHarmonyReviewReasonLowMastery =>
      'Motivo de la revisión: bajo dominio';

  @override
  String get studyHarmonyReviewReasonStaleSkill =>
      'Motivo de la revisión: habilidad obsoleta';

  @override
  String get studyHarmonyReviewReasonWeakSpot =>
      'Motivo de la revisión: punto débil';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh =>
      'Motivo de la revisión: actualización de frontera';

  @override
  String get studyHarmonyQuestBoardTitle => 'Tablero de misiones';

  @override
  String get studyHarmonyQuestCompletedTag => 'Terminado';

  @override
  String get studyHarmonyQuestTodayTag => 'Hoy';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target completo';
  }

  @override
  String get studyHarmonyQuestDailyTitle => 'Racha diaria';

  @override
  String get studyHarmonyQuestDailyBody =>
      'Completa la mezcla sembrada de hoy para alargar tu racha.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      'La diaria de hoy ya está completada. La racha está a salvo por ahora.';

  @override
  String get studyHarmonyQuestFrontierTitle => 'Empuje fronterizo';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return 'Supera $lessonTitle para empujar la ruta hacia delante.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'Ya superaste todas las lecciones desbloqueadas por ahora. Repite un jefe o ve por más estrellas.';

  @override
  String get studyHarmonyQuestStarsTitle => 'caza de estrellas';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return 'Empuja estrellas adicionales dentro de $chapterTitle.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback =>
      'Empuja estrellas adicionales en tu capítulo actual.';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'Combinado x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'Mejor combinación x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'Mantenga todos los corazones';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return 'Alcance $percent% de precisión';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'Alcanza el combo x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'barrido de bonificación';

  @override
  String get studyHarmonySkillNoteRead => 'Lectura de notas';

  @override
  String get studyHarmonySkillNoteFindKeyboard =>
      'Búsqueda de notas del teclado';

  @override
  String get studyHarmonySkillNoteAccidentals => 'Sostenidos y bemoles';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'Símbolo de acorde a teclas';

  @override
  String get studyHarmonySkillChordNameFromTones => 'Nomenclatura de acordes';

  @override
  String get studyHarmonySkillScaleBuild => 'Construcción a escala';

  @override
  String get studyHarmonySkillRomanRealize => 'Realización de número romano';

  @override
  String get studyHarmonySkillRomanIdentify => 'Identificación número romano';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'diatonicidad';

  @override
  String get studyHarmonySkillHarmonyFunction =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonySkillProgressionKeyCenter => 'Progresión centro tonal';

  @override
  String get studyHarmonySkillProgressionFunction =>
      'Lectura de la función de progresión';

  @override
  String get studyHarmonySkillProgressionNonDiatonic =>
      'Detección de progresión no diatónico';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'Relleno de progresión';

  @override
  String get studyHarmonyHubChapterSectionTitle => 'Capítulos';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return 'Lecciones $count';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count borrado';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'capitulo abierto';

  @override
  String get studyHarmonyLockedChapterTag => 'Capítulo bloqueado';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return 'Siguiente: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return 'Esta pista todavía está bloqueada. Vuelve a $coreTrack para seguir estudiando hoy.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Ruta base';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Comience con notas y el teclado, luego avance a través de acordes, escalas, conceptos básicos de número romano, diatónico y análisis de progresión breve.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Capítulo 1: Notas y teclado';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Asigne nombres de notas al teclado y siéntase cómodo con las teclas blancas y las alteraciones simples.';

  @override
  String get studyHarmonyChapterChordsTitle =>
      'Capítulo 2: Conceptos básicos de acordes';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Deletrea tríadas y séptimas básicas, luego nombra formas de acordes comunes a partir de sus tonos.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Capítulo 3: Escalas y claves';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Construya escalas mayores y menores, luego determine qué tonos pertenecen dentro de una clave.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Capítulo 4: Números romanos y diatonicidad';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Convierta número romano simples en acordes, identifíquelos a partir de acordes y ordene los conceptos básicos de diatónico por función.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Capítulo 5: Detective de progresión I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      'Lea progresiones básicas breves, encuentre el centro tonal probable y detecte la función de acorde o alguna extraña.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Capítulo 6: Acorde faltante I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      'Llene un espacio en blanco dentro de una breve progresión y aprenda hacia dónde quieren ir la cadencia y la función a continuación.';

  @override
  String get studyHarmonyOpenLessonAction => 'Abrir lección';

  @override
  String get studyHarmonyLockedLessonAction => 'Bloqueado';

  @override
  String get studyHarmonyClearedTag => 'Superada';

  @override
  String get studyHarmonyComingSoonTag => 'Próximamente';

  @override
  String get studyHarmonyPopTrackTitle => 'Ruta pop';

  @override
  String get studyHarmonyPopTrackDescription =>
      'Recorre toda la ruta de armonía en una vía pop con su propio progreso, elección diaria y cola de repaso.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Ruta de jazz';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practica todo el plan de estudios en una vía jazz con progreso, elección diaria y cola de repaso separados.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Ruta clásica';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Estudia todo el plan de estudios en una vía clásica con progreso, elección diaria y cola de repaso independientes.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Práctica rápida';

  @override
  String get studyHarmonyObjectiveBossReview => 'Repaso de jefe';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle =>
      'Búsqueda de notas de tecla blanca';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Lea los nombres de las notas y toque la tecla blanca correspondiente.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Nombra la nota resaltada';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Mire una tecla resaltada y elija el nombre de nota correcto.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle =>
      'Llaves negras y gemelos';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Eche un primer vistazo a la ortografía aguda y plana de las teclas negras.';

  @override
  String get studyHarmonyLessonNotesBossTitle =>
      'Jefe: Búsqueda rápida de notas';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mezcle la lectura de notas y la búsqueda de teclado en una ronda corta y rápida.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Tríadas en el teclado';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Cree tríadas comunes mayores, menores y disminuidas directamente en el teclado.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => 'Séptimas en el teclado';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Agrega la séptima y deletrea algunos acordes de séptima comunes en el teclado.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Nombra el acorde resaltado';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Lea una forma de acorde resaltada y elija el nombre del acorde correcto.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Jefe: Revisión de tríadas y séptimas';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Cambie entre la ortografía y la denominación de acordes en una revisión mixta.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Construir escalas mayores';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Elija cada tono que pertenezca a una escala mayor simple.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Construir escalas menores';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Construya escalas menores naturales y menores armónicas a partir de algunas tonalidades comunes.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Membresía clave';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Encuentre qué tonos pertenecen dentro de una clave con nombre.';

  @override
  String get studyHarmonyLessonScalesBossTitle =>
      'Jefe: Reparación de básculas';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Combine construcción de escala y membresía clave en una breve ronda de reparación.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Romano a acorde';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Lea una clave y número romano, luego elija el acorde correspondiente.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Acorde a romano';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Lea un acorde dentro de una clave y elija el número romano correspondiente.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatónico o no';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Ordene acordes en respuestas diatónico y no diatónico en claves simples.';

  @override
  String get studyHarmonyLessonFunctionTitle =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Clasifica los acordes fáciles como tónicos, predominante o dominantes.';

  @override
  String get studyHarmonyLessonRomanBossTitle =>
      'Jefe: Mezcla de conceptos básicos funcionales';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Revise romano a acorde, acorde a romano, diatónicoity y funcionen juntos.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle =>
      'Encuentra el centro clave';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      'Lea una breve progresión y elija el centro tonal que tenga más sentido.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle =>
      'Función en contexto';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      'Concéntrate en un acorde resaltado y nombra su función dentro de una progresión corta.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle =>
      'Encuentra al forastero';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'Localice el único acorde que queda fuera de la lectura principal diatónico.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Jefe: Análisis Mixto';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'Combine lectura del centro de claves, detección de funciones y detección de no diatónico en una breve ronda de detectives.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle =>
      'Completa el acorde que falta';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'Complete una breve progresión de cuatro acordes eligiendo el acorde que mejor se adapte a la función local.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle =>
      'Relleno de cadencia';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'Utilice la atracción hacia una cadencia para elegir el acorde que falta cerca del final de una frase.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Jefe: relleno mixto';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'Resuelva un breve conjunto de preguntas de progresión para completar con un poco más de presión armónica.';

  @override
  String get studyHarmonyChapterCheckpointTitle =>
      'Guantelete de punto de control';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'Combine ejercicios de centro de clave, función, color y relleno en conjuntos de revisión mixtos más rápidos.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle =>
      'Acometida de cadencia';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      'Lea rápidamente la función armónica y luego conecte el acorde cadencial que falta ejerciendo una ligera presión.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle =>
      'Cambio de color y clave';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'Cambie entre detección central y llamadas de color no diatónico sin perder el hilo.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle =>
      'Jefe: Guantelete del punto de control';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'Borre un punto de control integrado que combina indicaciones de reparación de centro de clave, función, color y cadencia.';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'Pruebas finales';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'Termine el camino principal con rondas de progresión mixta más difíciles que requieren velocidad, audición de colores y opciones de resolución limpia.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'Relevo de respuesta';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'Cambie entre lectura de funciones y reparación de acordes faltantes mediante cambios compactos.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle =>
      'Llamadas de colores prestados';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'Capte el color modal rápidamente y luego confirme el centro tonal antes de que desaparezca.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle =>
      'Laboratorio de resolución';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      'Realice un seguimiento de dónde quiere aterrizar cada frase y elija el acorde que mejor resuelva el movimiento.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle =>
      'Jefe: Examen de progresión final';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'Apruebe un examen final mixto con centro, función, color y resolución, todo bajo presión.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Encuentra $note en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      '¿Qué nota está resaltada?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Construya $chord en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      '¿Qué acorde está resaltado?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Elige cada nota en $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Elige las notas que pertenecen a $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'En $keyName, ¿qué acorde coincide con $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'En $keyName, ¿qué número romano coincide con $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'En $keyName, ¿$chord es diatónico?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'En $keyName, ¿qué función tiene $chord?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => 'Progresión';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '¿Qué centro tonal se adapta mejor a esta progresión?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '¿Qué función juega $chord aquí?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '¿Qué acorde se siente menos diatónico en esta progresión?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '¿Qué acorde llena mejor el espacio en blanco?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'One likely reading keeps this progression centered on $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can be heard as a $functionLabel chord in this context.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord sits outside the main $keyLabel reading, so it stands out as a plausible non-diatonic color.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can restore some of the expected $functionLabel pull in this progression.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic menor natural';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic armónico menor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic menor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatónico';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'No diatónico';

  @override
  String get studyHarmonyChoiceTonic => 'Tónico';

  @override
  String get studyHarmonyChoicePredominant => 'Predominante';

  @override
  String get studyHarmonyChoiceDominant => 'Dominante';

  @override
  String get studyHarmonyChoiceOther => 'Otro';

  @override
  String get chordAnalyzerTitle => 'Analizador de acordes';

  @override
  String get chordAnalyzerSubtitle =>
      'Pega una progresión para obtener una lectura conservadora de tonalidades probables, números romanos y función armónica.';

  @override
  String get chordAnalyzerInputLabel => 'Progresión de acordes';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Fuera de paréntesis, puedes separar acordes con espacios, | o comas. Las comas dentro de paréntesis se mantienen dentro del mismo acorde.\n\nUsa ? para un hueco de acorde desconocido. El analizador inferirá la opción más natural según el contexto y mostrará alternativas si la lectura es ambigua.\n\nSe admiten fundamentales en minúscula, bajo con barra, formas sus/alt/add y tensiones como C7(b9, #11).\n\nEn dispositivos táctiles puedes usar el pad de acordes o cambiar a la entrada ABC cuando necesites escribir libremente.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Consejos de entrada';

  @override
  String get chordAnalyzerAnalyze => 'Analizar';

  @override
  String get chordAnalyzerKeyboardTitle => 'Pad de acordes';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Toca los tokens para armar una progresión. La entrada ABC mantiene disponible el teclado del sistema cuando necesitas escribir libremente.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Escribe, pega o toca tokens para insertarlos en la posición del cursor.';

  @override
  String get chordAnalyzerChordPad => 'Panel';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => 'Pegar';

  @override
  String get chordAnalyzerClear => 'Reiniciar';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'Espacio';

  @override
  String get chordAnalyzerAnalyzing => 'Analizando progresión...';

  @override
  String get chordAnalyzerInitialTitle => 'Empieza con una progresión';

  @override
  String get chordAnalyzerInitialBody =>
      'Introduce una progresión como Dm7, G7 | ? Am o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos, avisos, rellenos inferidos y un breve resumen.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'Este ? se infirió del contexto armónico circundante, así que tómalo como un relleno sugerido y no como una certeza.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Relleno sugerido: $chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => 'Tonalidades detectadas';

  @override
  String get chordAnalyzerPrimaryReading => 'Lectura principal';

  @override
  String get chordAnalyzerAlternativeReading => 'Lectura alternativa';

  @override
  String get chordAnalyzerChordAnalysis => 'Análisis acorde por acorde';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return 'Compás $index';
  }

  @override
  String get chordAnalyzerProgressionSummary => 'Resumen de la progresión';

  @override
  String get chordAnalyzerWarnings => 'Advertencias y ambigüedades';

  @override
  String get chordAnalyzerNoInputError =>
      'Introduce una progresión de acordes para analizarla.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      'No se encontraron acordes reconocibles en la progresión.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return 'Se omitieron algunos símbolos: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'El centro tonal sigue siendo algo ambiguo entre $primary y $alternative.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'Algunos acordes siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerFunctionTonic => 'Tónica';

  @override
  String get chordAnalyzerFunctionPredominant => 'Predominante';

  @override
  String get chordAnalyzerFunctionDominant => 'Dominante';

  @override
  String get chordAnalyzerFunctionOther => 'Otro';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return 'Posible dominante secundaria dirigida a $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Posible sustitución por tritono dirigida a $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Posible intercambio modal desde el menor paralelo.';

  @override
  String get chordAnalyzerRemarkAmbiguous =>
      'Este acorde sigue siendo ambiguo en la lectura actual.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'Este acorde sigue sin resolverse con las heurísticas conservadoras actuales.';

  @override
  String get chordAnalyzerTagIiVI => 'cadencia ii-V-I';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => 'resolución dominante';

  @override
  String get chordAnalyzerTagPlagalColor => 'color plagal/modal';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'Esta progresión se centra muy probablemente en $key.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return 'Una lectura alternativa es $key.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'Sugiere un $tag.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from y $through se comportan como acordes de $fromFunction y $throughFunction que conducen hacia $target.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord puede oírse como una posible dominante secundaria que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord puede oírse como un posible sustituto por tritono que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord añade un posible color de intercambio modal.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      'Algunos detalles siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerExamplesTitle => 'Ejemplos';

  @override
  String get chordAnalyzerConfidenceLabel => 'Confianza';

  @override
  String get chordAnalyzerAmbiguityLabel => 'Ambigüedad';

  @override
  String get chordAnalyzerWhyThisReading => 'Por qué esta lectura';

  @override
  String get chordAnalyzerCompetingReadings => 'También plausible';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return 'Modificadores ignorados: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => 'Crear variaciones';

  @override
  String get chordAnalyzerVariationsTitle => 'Variaciones naturales';

  @override
  String get chordAnalyzerVariationsBody =>
      'Estas opciones reharmonizan el mismo flujo con sustituciones funcionales cercanas. Aplica una para volver a analizarla al instante.';

  @override
  String get chordAnalyzerApplyVariation => 'Usar variación';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Color cadencial';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Oscurece el predominante y cambia el dominante por un sustituto por tritono sin mover la llegada.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Color backdoor';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Usa el color ivm7-bVII7 del menor paralelo antes de caer en la misma tónica.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'ii-V dirigido';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Construye un ii-V relacionado que sigue apuntando al mismo acorde de destino.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle =>
      'Color de cadencia menor';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Mantiene la cadencia menor, pero se inclina hacia el color iiø-Valt-i.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Realce de color';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Mantiene cercanos la raíz y la función, pero eleva los acordes con extensiones naturales.';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return 'Advertencia de entrada: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      'Los paréntesis desequilibrados dejaron parte del símbolo en duda.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'Se ignoró un paréntesis de cierre inesperado.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'El color explícito de $extension refuerza esta lectura.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'El color de dominante alterada respalda una función dominante.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'El bajo con barra $bass mantiene significativo el movimiento del bajo o la inversión.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'El siguiente acorde respalda una resolución hacia $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'Este color puede oírse como prestado del modo paralelo.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'El color de suspensión suaviza la atracción dominante sin borrarla.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Lectura de baja confianza';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'Las tonalidades candidatas están muy próximas o algunos símbolos solo se recuperaron de forma parcial, así que tómalo como una primera lectura cautelosa.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'Este compás está vacío y se conservó en el conteo.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No se recuperaron símbolos de acorde analizables en este compás.';

  @override
  String get chordAnalyzerParseIssuesTitle => 'Problemas de análisis';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => 'Token vacío.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot =>
      'No se pudo reconocer la fundamental.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root no es una grafía de fundamental admitida.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'El bajo con barra $bass no es una grafía de bajo admitida.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Sufijo o modificador no admitido: $suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

  @override
  String get chordAnalyzerQuickStartHint =>
      'Tap an example to see instant results, or press Ctrl+Enter on desktop to analyze.';

  @override
  String get chordAnalyzerDetailLevel => 'Explanation detail';

  @override
  String get chordAnalyzerDetailLevelConcise => 'Concise';

  @override
  String get chordAnalyzerDetailLevelDetailed => 'Detailed';

  @override
  String get chordAnalyzerDetailLevelAdvanced => 'Advanced';

  @override
  String get chordAnalyzerHighlightTheme => 'Highlight theme';

  @override
  String get chordAnalyzerThemePresetDefault => 'Default';

  @override
  String get chordAnalyzerThemePresetHighContrast => 'High contrast';

  @override
  String get chordAnalyzerThemePresetColorBlindSafe => 'Color-blind safe';

  @override
  String get chordAnalyzerThemePresetCustom => 'Custom';

  @override
  String get chordAnalyzerThemeLegend => 'Category legend';

  @override
  String get chordAnalyzerCustomColors => 'Custom category colors';

  @override
  String get chordAnalyzerHighlightAppliedDominant => 'Applied dominant';

  @override
  String get chordAnalyzerHighlightTritoneSubstitute => 'Tritone substitute';

  @override
  String get chordAnalyzerHighlightTonicization => 'Tonicization';

  @override
  String get chordAnalyzerHighlightModulation => 'Modulation';

  @override
  String get chordAnalyzerHighlightBackdoor => 'Backdoor / subdominant minor';

  @override
  String get chordAnalyzerHighlightBorrowedColor => 'Borrowed color';

  @override
  String get chordAnalyzerHighlightCommonTone => 'Common-tone motion';

  @override
  String get chordAnalyzerHighlightDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerHighlightChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerHighlightAmbiguity => 'Ambiguity';

  @override
  String chordAnalyzerSummaryRealModulation(Object key) {
    return 'It makes a stronger case for a real modulation toward $key.';
  }

  @override
  String chordAnalyzerSummaryTonicization(Object target) {
    return 'It briefly tonicizes $target without fully settling there.';
  }

  @override
  String get chordAnalyzerSummaryBackdoor =>
      'The progression leans into backdoor or subdominant-minor color before resolving.';

  @override
  String get chordAnalyzerSummaryDeceptiveCadence =>
      'One cadence sidesteps the expected tonic for a deceptive effect.';

  @override
  String get chordAnalyzerSummaryChromaticLine =>
      'A chromatic inner-line or line-cliche color helps connect part of the phrase.';

  @override
  String chordAnalyzerSummaryBackdoorDominant(Object chord) {
    return '$chord works like a backdoor dominant rather than a plain borrowed dominant.';
  }

  @override
  String chordAnalyzerSummarySubdominantMinor(Object chord) {
    return '$chord reads more naturally as subdominant-minor color than as a random non-diatonic chord.';
  }

  @override
  String chordAnalyzerSummaryCommonToneDiminished(Object chord) {
    return '$chord can be heard as a common-tone diminished color that resolves by shared pitch content.';
  }

  @override
  String chordAnalyzerSummaryDeceptiveTarget(Object chord) {
    return '$chord participates in a deceptive landing instead of a plain authentic cadence.';
  }

  @override
  String chordAnalyzerSummaryCompeting(Object readings) {
    return 'An advanced reading keeps competing interpretations in play, such as $readings.';
  }

  @override
  String chordAnalyzerFunctionLine(Object function) {
    return 'Function: $function';
  }

  @override
  String chordAnalyzerEvidenceLead(Object evidence) {
    return 'Evidence: $evidence';
  }

  @override
  String chordAnalyzerAdvancedCompetingReadings(Object readings) {
    return 'Competing readings remain possible here: $readings.';
  }

  @override
  String chordAnalyzerRemarkTonicization(Object target) {
    return 'This sounds more like a local tonicization of $target than a full modulation.';
  }

  @override
  String chordAnalyzerRemarkRealModulation(Object key) {
    return 'This supports a real modulation toward $key.';
  }

  @override
  String get chordAnalyzerRemarkBackdoorDominant =>
      'This can be heard as a backdoor dominant with subdominant-minor color.';

  @override
  String get chordAnalyzerRemarkBackdoorChain =>
      'This belongs to a backdoor chain rather than a plain borrowed detour.';

  @override
  String get chordAnalyzerRemarkSubdominantMinor =>
      'This borrowed iv or subdominant-minor color behaves like a predominant area.';

  @override
  String get chordAnalyzerRemarkCommonToneDiminished =>
      'This diminished chord works through common-tone reinterpretation.';

  @override
  String get chordAnalyzerRemarkPivotChord =>
      'This chord can act as a pivot into the next local key area.';

  @override
  String get chordAnalyzerRemarkCommonToneModulation =>
      'Common-tone continuity helps the modulation feel plausible.';

  @override
  String get chordAnalyzerRemarkDeceptiveCadence =>
      'This points toward a deceptive cadence rather than a direct tonic arrival.';

  @override
  String get chordAnalyzerRemarkLineCliche =>
      'Chromatic inner-line motion colors this chord choice.';

  @override
  String get chordAnalyzerRemarkDualFunction =>
      'More than one functional reading stays credible here.';

  @override
  String get chordAnalyzerTagTonicization => 'Tonicization';

  @override
  String get chordAnalyzerTagRealModulation => 'Real modulation';

  @override
  String get chordAnalyzerTagBackdoorChain => 'Backdoor chain';

  @override
  String get chordAnalyzerTagDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerTagChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerTagCommonToneMotion => 'Common-tone motion';

  @override
  String get chordAnalyzerEvidenceCadentialArrival =>
      'A local cadential arrival supports hearing a temporary target.';

  @override
  String get chordAnalyzerEvidenceFollowThrough =>
      'Follow-through chords continue to support the new local center.';

  @override
  String get chordAnalyzerEvidencePhraseBoundary =>
      'The change lands near a phrase boundary or structural accent.';

  @override
  String get chordAnalyzerEvidencePivotSupport =>
      'A pivot-like shared reading supports the local shift.';

  @override
  String get chordAnalyzerEvidenceCommonToneSupport =>
      'Shared common tones help connect the reinterpretation.';

  @override
  String get chordAnalyzerEvidenceHomeGravityWeakening =>
      'The original tonic loses some of its pull in this window.';

  @override
  String get chordAnalyzerEvidenceBackdoorMotion =>
      'The motion matches a backdoor or subdominant-minor resolution pattern.';

  @override
  String get chordAnalyzerEvidenceDeceptiveResolution =>
      'The dominant resolves away from the expected tonic target.';

  @override
  String chordAnalyzerEvidenceChromaticLine(Object detail) {
    return 'Chromatic line support: $detail.';
  }

  @override
  String chordAnalyzerEvidenceCompetingReading(Object detail) {
    return 'Competing reading: $detail.';
  }

  @override
  String get studyHarmonyDailyReplayAction => 'Repetir diariamente';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'Medallas de hito';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'Medalla del Conquistador';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Borrar lecciones $target en Core Foundations.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'Coleccionista de estrellas';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Recoge estrellas $target en Estudio de armonía.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'Leyenda de la racha';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return 'Alcanza la mejor racha diaria de $target.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => 'Académico de maestría';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return 'Domina las habilidades $target.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return 'Medallas $earned/$total obtenidas';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'Gabinete completo';

  @override
  String get studyHarmonyMilestoneTierBronze => 'Medalla de Bronce';

  @override
  String get studyHarmonyMilestoneTierSilver => 'Medalla de Plata';

  @override
  String get studyHarmonyMilestoneTierGold => 'Medalla de oro';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'Medalla de Platino';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => 'Nuevas medallas';

  @override
  String get studyHarmonyChapterRemixTitle => 'Arena remezclada';

  @override
  String get studyHarmonyChapterRemixDescription =>
      'Conjuntos mixtos más largos que mezclan centro tonal, función y color prestado sin previo aviso.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => 'Constructor de puentes';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'La función de puntada lee y rellena los acordes faltantes en una cadena fluida.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'Pivote de color';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      'Realice un seguimiento del color prestado y de los pivotes centrales clave a medida que la progresión cambia debajo de usted.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => 'Sprint de resolución';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      'Lea la función, el relleno de cadencia y la gravedad tonal consecutivamente a un ritmo más rápido.';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'Maratón de remezclas';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      'Un maratón mixto final que devuelve al conjunto todas las lentes de lectura de progresión.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'Salva racha x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'Coronas de leyenda $count';
  }

  @override
  String get studyHarmonyModeFocus => 'Modo de enfoque';

  @override
  String get studyHarmonyModeLegend => 'Prueba de leyenda';

  @override
  String get studyHarmonyFocusCardTitle => 'Sprint de enfoque';

  @override
  String get studyHarmonyFocusCardHint =>
      'Ataca el punto más débil de tu ruta actual con menos vidas y objetivos más exigentes.';

  @override
  String get studyHarmonyFocusFallbackHint =>
      'Completa un mix más exigente para presionar tus puntos débiles actuales.';

  @override
  String get studyHarmonyFocusAction => 'Iniciar sprint';

  @override
  String get studyHarmonyFocusSessionTitle => 'Sprint de enfoque';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return 'Un sprint mixto más ajustado construido desde los puntos más débiles alrededor de $chapter.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count lecciones mixtas';
  }

  @override
  String get studyHarmonyFocusRewardLabel => 'Recompensa semanal: Salva racha';

  @override
  String get studyHarmonyLegendCardTitle => 'Prueba de leyenda';

  @override
  String get studyHarmonyLegendCardHint =>
      'Repite un capítulo de nivel plata o superior en una sesión de dominio con 2 vidas para asegurar su corona de leyenda.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'Completa un capítulo y súbelo a unas 2 estrellas por lección para desbloquear una prueba de leyenda.';

  @override
  String get studyHarmonyLegendAction => 'Ir por la leyenda';

  @override
  String get studyHarmonyLegendSessionTitle => 'Prueba de leyenda';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return 'Una repetición de dominio sin margen en $chapter, pensada para asegurar su corona de leyenda.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count lecciones encadenadas';
  }

  @override
  String get studyHarmonyLegendRiskLabel =>
      'La corona de leyenda está en juego';

  @override
  String get studyHarmonyWeeklyPlanTitle => 'Plan de entrenamiento semanal';

  @override
  String get studyHarmonyWeeklyRewardLabel => 'Recompensa: Salva racha';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => 'Recompensa lista';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => 'Recompensa reclamada';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => 'Aparecer varios días';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return 'Esté activo en $target diferentes días de esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle =>
      'Mantenga vivo el ciclo diario';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return 'El registro $target se borra diariamente esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle =>
      'Terminar un sprint de concentración';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return 'Completa $target Focus Sprints esta semana.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      'Un Salva racha protegió el día de ayer.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return 'Ganaste un nuevo Salva racha. Inventario: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine =>
      'Sprint de enfoque despejado.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return 'Corona legendaria asegurada para $chapter.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'Escalera bis';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      'Una breve escalera de acabado que comprime todo el conjunto de herramientas de progresión en un conjunto final de bises.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'Pulso tonal';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'Bloquee el centro tonal y funcione sin indicaciones de calentamiento.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'Intercambio de color';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      'Llamadas de colores prestados alternativos con restauración de acordes faltantes para mantener el oído honesto.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'Bis final';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'Una última ronda de jefe compacta que comprueba cada lente de progresión en rápida sucesión.';

  @override
  String get studyHarmonyChapterMasteryBronze => 'Bronce Claro';

  @override
  String get studyHarmonyChapterMasterySilver => 'Corona de plata';

  @override
  String get studyHarmonyChapterMasteryGold => 'corona de oro';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'Corona de leyenda';

  @override
  String get studyHarmonyModeBossRush => 'Modo Boss Rush';

  @override
  String get studyHarmonyBossRushCardTitle => 'Boss Rush';

  @override
  String get studyHarmonyBossRushCardHint =>
      'Encadena las lecciones de jefe desbloqueadas con menos vidas y un umbral de puntuación más alto.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      'Desbloquea al menos dos lecciones de jefe para abrir una Boss Rush mixta de verdad.';

  @override
  String get studyHarmonyBossRushAction => 'Iniciar Boss Rush';

  @override
  String get studyHarmonyBossRushSessionTitle => 'Boss Rush';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return 'Un gauntlet de alta presión construido con las lecciones de jefe desbloqueadas alrededor de $chapter.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count lecciones de jefe mixtas';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => 'Solo 2 vidas';

  @override
  String get studyHarmonyResultBossRushLine => 'Jefe Rush despejado.';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      'Un último conjunto de focos que aísla el color prestado, la presión de la cadencia y la integración a nivel de jefe.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => 'Lente prestada';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      'Realice un seguimiento de centro tonal mientras el color prestado sigue intentando desviar la lectura.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle =>
      'Intercambio de cadencia';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      'Cambia entre lectura de funciones y restauración de cadencia sin perder el punto de aterrizaje.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'Un conjunto de jefes finales que obliga a cada lente de progresión a mantenerse nítida bajo presión.';

  @override
  String get studyHarmonyChapterAfterHoursTitle =>
      'Laboratorio fuera de horario';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'Un laboratorio de finales de juego que elimina pistas de calentamiento y mezcla colores prestados, presión de cadencia y seguimiento central.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'Sombra modal';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      'Mantenga presionado el centro tonal mientras el color prestado sigue arrastrando la lectura hacia la oscuridad.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => 'Finta de resolución';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'Capte las falsificaciones de función y cadencia antes de que la frase pase de su verdadero lugar de aterrizaje.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle =>
      'Fundido cruzado central';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      'Combine la detección del centro, la lectura de funciones y la reparación de cuerdas faltantes sin necesidad de andamios adicionales.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'Jefe de última llamada';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'Un último set de jefe nocturno que pide a cada lente de progresión que se mantenga clara bajo presión.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyModeRelay => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardTitle => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardHint =>
      'Mezcla lecciones desbloqueadas de distintos capítulos en una sola tanda intercalada para poner a prueba tanto el cambio rápido como el recuerdo inmediato.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'Desbloquea al menos dos capítulos para abrir Relevo de arena.';

  @override
  String get studyHarmonyRelayAction => 'Iniciar relevo';

  @override
  String get studyHarmonyRelaySessionTitle => 'Relevo de arena';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return 'Una ejecución de retransmisión entrelazada que mezcla capítulos desbloqueados sobre $chapter.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return 'Lecciones $count transmitidas';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count capítulos mezclados';
  }

  @override
  String get studyHarmonyRelayChainLabel => 'Intercalado bajo presión';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'Corredor de relevos';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return 'Borre las ejecuciones $target Relevo de arena.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'Desvíos de neón';

  @override
  String get studyHarmonyChapterNeonDescription =>
      'Un capítulo del final del juego que sigue cambiando el camino con color prestado, presión de pivote y lecturas de recuperación.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'Desvío modal';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      'Siga el verdadero centro incluso cuando el color prestado sigue empujando la frase a una calle lateral.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'Presión de pivote';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      'Lea los cambios de centro y la presión de función espalda con espalda antes de que el carril armónico cambie nuevamente.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => 'Aterrizaje prestado';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      'Repare la cuerda de aterrizaje que falta después de que una falsificación de color prestado cambie la resolución esperada.';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'Jefe de luces de la ciudad';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'Un jefe de neón final que combina lecturas pivotantes, colores prestados y recuperación de cadencia sin un aterrizaje suave.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return 'Liga $tier';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'Liga de armonía';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return 'Empuja hacia la liga $tier esta semana. El impulso más limpio ahora mismo viene de $mode.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      'Diamante ya está asegurado esta semana. Sigue encadenando superadas de alta presión para mantener el ritmo.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      'Tu ascenso de liga se iluminará una vez que haya una carrera recomendada para impulsar esta semana.';

  @override
  String get studyHarmonyLeagueAction => 'Subir de liga';

  @override
  String get studyHarmonyHubStartHereTitle => 'Start Here';

  @override
  String get studyHarmonyHubNextLessonTitle => 'Next Lesson';

  @override
  String get studyHarmonyHubWhyItMattersTitle => 'Why It Matters';

  @override
  String get studyHarmonyHubQuickPracticeTitle => 'Quick Practice';

  @override
  String get studyHarmonyHubMetaPreviewTitle => 'More Opens Soon';

  @override
  String get studyHarmonyHubMetaPreviewHeadline =>
      'Build a little momentum first';

  @override
  String get studyHarmonyHubMetaPreviewBody =>
      'League, shop, and reward systems open up more fully after a few clears. For now, finish your next lesson and one quick practice run.';

  @override
  String get studyHarmonyHubPlayNowAction => 'Play Now';

  @override
  String get studyHarmonyHubKeepMomentumAction => 'Keep Momentum';

  @override
  String get studyHarmonyClearTitleAction => 'Clear title';

  @override
  String get studyHarmonyPlayerDeckTitle => 'Player Deck';

  @override
  String get studyHarmonyPlayerDeckCardTitle => 'Playstyle';

  @override
  String get studyHarmonyPlayerDeckOverviewAction => 'Overview';

  @override
  String get studyHarmonyRunDirectorTitle => 'Run Director';

  @override
  String get studyHarmonyRunDirectorAction => 'Play Recommended';

  @override
  String get studyHarmonyGameEconomyTitle => 'Game Economy';

  @override
  String get studyHarmonyGameEconomyBody =>
      'Shop stock, utility tokens, and meta items all react to your recent run history.';

  @override
  String studyHarmonyGameEconomyTitlesOwned(int count) {
    return '$count titles owned';
  }

  @override
  String studyHarmonyGameEconomyCosmeticsOwned(int count) {
    return '$count cosmetics owned';
  }

  @override
  String studyHarmonyGameEconomyShopPurchases(int count) {
    return '$count shop purchases';
  }

  @override
  String get studyHarmonyGameEconomyWalletAction => 'View Wallet';

  @override
  String get studyHarmonyArcadeSpotlightTitle => 'Arcade Spotlight';

  @override
  String get studyHarmonyArcadePlayAction => 'Play Arcade';

  @override
  String studyHarmonyArcadeModeCount(int count) {
    return '$count modes';
  }

  @override
  String get studyHarmonyArcadePlaylistAction => 'Play Set';

  @override
  String get studyHarmonyNightMarketTitle => 'Night Market';

  @override
  String studyHarmonyPurchaseSuccess(Object itemTitle) {
    return 'Purchased $itemTitle';
  }

  @override
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle) {
    return 'Purchased and equipped $itemTitle';
  }

  @override
  String studyHarmonyPurchaseFailure(Object itemTitle) {
    return 'Cannot purchase $itemTitle yet';
  }

  @override
  String studyHarmonyRewardEquipped(Object itemTitle) {
    return 'Equipped $itemTitle';
  }

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score XP esta semana';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target XP esta semana';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return 'Siguiente: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return 'Mejor impulso: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'XP de liga +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return 'Ascendido a la liga $tier';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'Novato';

  @override
  String get studyHarmonyLeagueTierBronze => 'Bronce';

  @override
  String get studyHarmonyLeagueTierSilver => 'Plata';

  @override
  String get studyHarmonyLeagueTierGold => 'Oro';

  @override
  String get studyHarmonyLeagueTierDiamond => 'Diamante';

  @override
  String get studyHarmonyChapterMidnightTitle => 'Central de medianoche';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      'Un capítulo final de sala de control que obliga a lecturas rápidas a través de centros a la deriva, cadencias falsas y desvíos prestados.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'Deriva de señal';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      'Siga la verdadera señal tonal incluso mientras la superficie sigue adoptando un color prestado.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => 'Línea engañosa';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      'Lea la presión de la función a través de resoluciones falsas antes de que la línea vuelva a colocarse en su lugar.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => 'Desvío prestado';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      'Recupera el aterrizaje esperado después de que el color prestado desvía la frase a mitad de camino.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'Jefe del apagón';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      'Un conjunto de oscurecimiento final que combina todos los lentes del juego tardío sin brindarte un reinicio seguro.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'Cofres de misiones $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x XP de liga x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'Cofre de misiones';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count misiones restantes';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'Cofre de misiones listo';

  @override
  String get studyHarmonyQuestChestOpenedHeadline =>
      'Cofre de misiones abierto';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x Liga XP en vivo';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return 'Recompensa: +$xp liga XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      'Completa el trío de misiones de hoy para abrir el cofre extra y sostener el ascenso semanal.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      'Las tres misiones de hoy ya están hechas. Supera una partida más para cobrar el bono del cofre.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      'El trío de hoy está completo y la bonificación del cofre ya se ha convertido en XP de liga.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return 'El cofre de hoy ya está abierto y el 2x de XP de liga se aplica a tus próximas $count superadas.';
  }

  @override
  String get studyHarmonyQuestChestAction => 'Terminar trío';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'Mejor remate: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'Misiones diarias $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'Se abrió Cofre de misiones.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'Bonificación Cofre de misiones + XP de liga $count';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '2x de XP de liga listo para tus próximas $count superadas';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'Bono de impulso +$count de XP de liga';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return 'El impulso 2x se borra a la izquierda $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return 'Tienes 2x de XP de liga durante las próximas $count superadas. Aprovéchalo en $mode mientras dure el impulso.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'Circuito del horizonte';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'Un circuito final del horizonte que obliga a lecturas rápidas y mixtas a través de centros fantasmas, gravedad prestada y casas falsas.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => 'Pulso residual';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'Capte el centro y funcione en la imagen residual antes de que la frase se bloquee en un nuevo carril.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => 'Cambio de gravedad';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      'Maneja la gravedad prestada y repara los acordes faltantes mientras la progresión sigue cambiando su peso.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => 'Falsa llegada';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      'Lea la llegada falsa y reconstruya el aterrizaje real antes de que la progresión se cierre de golpe.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => 'Jefe de la señal final';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'Un último jefe del horizonte que encadena cada lente de progresión del juego tardío en una prueba de señal de cierre.';

  @override
  String get studyHarmonyChapterAfterglowTitle => 'Pista del resplandor';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'Una pista cerrada de decisiones divididas, cebo prestado y centros parpadeantes que recompensa lecturas limpias al final del juego bajo presión.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => 'Decisión dividida';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'Elija el acorde de reparación que mantenga la función en movimiento sin permitir que la frase se desvíe de su curso.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => 'Señuelo prestado';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      'Encuentra el acorde de color prestado que parece un pivote antes de que la progresión regrese a casa.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => 'Parpadeo del centro';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'Mantén el centro tonal mientras las señales de cadencia parpadean y se desvían en rápida sucesión.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle =>
      'Jefe de retorno de línea roja';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'Una prueba final mixta de centro tonal, función, color prestado y reparación de acordes faltantes a toda velocidad.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'Tour mensual autorizado';

  @override
  String get studyHarmonyTourTitle => 'Tour de armonía';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'Listo el final de la gira';

  @override
  String get studyHarmonyTourClaimedHeadline => 'Tour mensual autorizado';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return 'Recompensa: +$xp de XP de liga y $count Salva racha';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return 'Aparece en $target días distintos este mes para asegurar el bono del tour.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return 'Abre $target cofres de misiones este mes para que el cuaderno del tour siga avanzando.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return 'Supera $target retos destacados este mes. Cuentan Boss Rush, Relevo de arena, Sprint de enfoque, Prueba de leyenda y las lecciones de jefe.';
  }

  @override
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

  @override
  String get studyHarmonyTourReadyBody =>
      'Ya reuniste todos los sellos del mes. Una partida más completada asegura el bono del tour.';

  @override
  String get studyHarmonyTourClaimedBody =>
      'La gira de este mes está completa. Mantén el ritmo fuerte para que la ruta del próximo mes empiece caliente.';

  @override
  String get studyHarmonyTourAction => 'recorrido anticipado';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return 'Días activos $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Cofre de misioness $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Focos $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Tour de armonía completo';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'Bono de gira +$count XP de liga';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Reserva de Salva racha $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => 'Frecuencia del amanecer';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'Un bis al amanecer de cadencias fantasmales, giros falsos del amanecer y flores prestadas que obliga a lecturas limpias al final del juego después de una larga carrera.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => 'Cadencia fantasma';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'Repara la cadencia y funciona al mismo tiempo cuando la frase pretende cerrarse sin llegar a aterrizar.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => 'Falso amanecer';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      'Capte el cambio central escondido dentro de un amanecer demasiado temprano antes de que la progresión se aleje nuevamente.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => 'Brote prestado';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      'Realice un seguimiento del color prestado y funcionen juntos mientras la armonía se abre hacia un carril más brillante pero inestable.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle =>
      'Jefe de sobremarcha del amanecer';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'Un jefe final a la velocidad del amanecer que encadena centro tonal, función, color no diatónico y reparación de acordes faltantes en un último conjunto de sobremarcha.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'Pacto a dúo';

  @override
  String get studyHarmonyDuetStartHeadline => 'Empieza el dueto de hoy.';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return 'Dueto bloqueado por el día $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return 'Recompensa: +$xp de XP de liga en rachas clave';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'Primero completa la diaria de hoy y luego supera un reto destacado para mantener vivo el pacto a dúo.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Lo diario está de moda. Termina una carrera destacada como Focus, Relay, Boss Rush, Legend o una lección de jefe para sellar el dúo.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return 'El dúo de hoy ya quedó sellado y la racha compartida va en $count días.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Diariamente en';

  @override
  String get studyHarmonyDuetDailyMissing => 'Falta diaria';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Foco en';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Falta foco';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return 'Diario $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'Foco $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'Racha $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'Sigue el dueto';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'Recompensa de dúo +$count XP de liga';
  }

  @override
  String get studyHarmonySolfegeDo => 'Do';

  @override
  String get studyHarmonySolfegeRe => 'Re';

  @override
  String get studyHarmonySolfegeMi => 'Mi';

  @override
  String get studyHarmonySolfegeFa => 'Fa';

  @override
  String get studyHarmonySolfegeSol => 'Sol';

  @override
  String get studyHarmonySolfegeLa => 'La';

  @override
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle =>
      'Prototipo de Estudio de armonía';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Niveles heredados del prototipo integrados en el sistema de lecciones.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Lecciones prototipo';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Lecciones temporales conservadas mientras se incorpora el sistema de estudio ampliable.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Supera 10 respuestas correctas antes de perder las 3 vidas';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Nivel prototipo 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'Un calentamiento básico para distinguir solo Do, Mi y Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Nivel prototipo 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'Un nivel intermedio para acelerar el reconocimiento de Do, Re, Mi, Sol y La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Nivel prototipo 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'Una prueba de octava completa que recorre toda la serie Do-Re-Mi-Fa-Sol-La-Si-Do.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (C grave)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (C agudo)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Plantilla';

  @override
  String get studyHarmonyChapterBlueHourTitle => 'Cruce de la hora azul';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      'Un bis crepuscular de corrientes cruzadas, préstamos con halo y horizontes duales que mantienen inestables las lecturas tardías del juego de la mejor manera.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => 'Corriente cruzada';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'Siga centro tonal y funcione mientras la progresión comienza a moverse en dos direcciones a la vez.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => 'Halo prestado';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      'Lea el color prestado y restablezca el acorde que falta antes de que la frase se vuelva confusa.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => 'Horizonte doble';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      'Mantenga el punto de llegada real mientras dos posibles horizontes siguen apareciendo y desapareciendo.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'Jefe de linternas gemelas';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'Un jefe final de hora azul que obliga a cambios rápidos entre el centro, la función, el color prestado y la reparación de acordes faltantes.';

  @override
  String get anchorLoopTitle => 'Anchor Loop';

  @override
  String get anchorLoopHelp =>
      'Fix specific cycle slots so the same chord returns every cycle while the other slots can still be generated around it.';

  @override
  String get anchorLoopCycleLength => 'Cycle Length (bars)';

  @override
  String get anchorLoopCycleLengthHelp =>
      'Choose how many bars the repeating anchor cycle lasts.';

  @override
  String get anchorLoopVaryNonAnchorSlots => 'Vary non-anchor slots';

  @override
  String get anchorLoopVaryNonAnchorSlotsHelp =>
      'Keep anchor slots exact while letting the generated filler vary inside the same local function.';

  @override
  String anchorLoopBarLabel(int bar) {
    return 'Bar $bar';
  }

  @override
  String anchorLoopBeatLabel(int beat) {
    return 'Beat $beat';
  }

  @override
  String get anchorLoopSlotEmpty => 'No anchor chord set';

  @override
  String anchorLoopEditTitle(int bar, int beat) {
    return 'Edit anchor for bar $bar, beat $beat';
  }

  @override
  String get anchorLoopChordSymbol => 'Anchor chord symbol';

  @override
  String get anchorLoopChordHint =>
      'Enter one chord symbol for this slot. Leave it empty to clear the anchor.';

  @override
  String get anchorLoopInvalidChord =>
      'Enter a supported chord symbol before saving this anchor slot.';

  @override
  String get harmonyPlaybackPatternBlock => 'Block';

  @override
  String get harmonyPlaybackPatternArpeggio => 'Arpeggio';

  @override
  String get metronomeBeatStateNormal => 'Normal';

  @override
  String get metronomeBeatStateAccent => 'Accent';

  @override
  String get metronomeBeatStateMute => 'Mute';

  @override
  String get metronomePatternPresetCustom => 'Custom';

  @override
  String get metronomePatternPresetMeterAccent => 'Meter accent';

  @override
  String get metronomePatternPresetJazzTwoAndFour => 'Jazz 2 & 4';

  @override
  String get metronomeSourceKindBuiltIn => 'Built-in asset';

  @override
  String get metronomeSourceKindLocalFile => 'Local file';

  @override
  String get transportAudioTitle => 'Transport Audio';

  @override
  String get autoPlayChordChanges => 'Auto-play chord changes';

  @override
  String get autoPlayChordChangesHelp =>
      'Play the next chord automatically when the transport reaches a chord-change event.';

  @override
  String get autoPlayPattern => 'Auto-play pattern';

  @override
  String get autoPlayPatternHelp =>
      'Choose whether auto-play uses a block chord or a short arpeggio.';

  @override
  String get autoPlayHoldFactor => 'Auto-play hold length';

  @override
  String get autoPlayHoldFactorHelp =>
      'Scale how long auto-played chord changes ring relative to the event duration.';

  @override
  String get autoPlayMelodyWithChords => 'Play melody with chords';

  @override
  String get autoPlayMelodyWithChordsPlaceholder =>
      'When melody generation is enabled, include the current melody line in auto-play chord-change previews.';

  @override
  String get melodyGenerationTitle => 'Melody line';

  @override
  String get melodyGenerationHelp =>
      'Generate a simple performance-ready melody that follows the current chord timeline.';

  @override
  String get melodyDensity => 'Melody density';

  @override
  String get melodyDensityHelp =>
      'Choose how many melody notes tend to appear inside each chord event.';

  @override
  String get melodyDensitySparse => 'Sparse';

  @override
  String get melodyDensityBalanced => 'Balanced';

  @override
  String get melodyDensityActive => 'Active';

  @override
  String get motifRepetitionStrength => 'Motif repetition';

  @override
  String get motifRepetitionStrengthHelp =>
      'Higher values keep the contour identity of recent melody fragments more often.';

  @override
  String get approachToneDensity => 'Approach tone density';

  @override
  String get approachToneDensityHelp =>
      'Control how often passing, neighbor, and approach gestures appear before arrivals.';

  @override
  String get melodyRangeLow => 'Melody range low';

  @override
  String get melodyRangeHigh => 'Melody range high';

  @override
  String get melodyRangeHelp =>
      'Keep generated melody notes inside this playable register window.';

  @override
  String get melodyStyle => 'Melody style';

  @override
  String get melodyStyleHelp =>
      'Bias the line toward safer guide tones, bebop motion, lyrical space, or colorful tensions.';

  @override
  String get melodyStyleSafe => 'Safe';

  @override
  String get melodyStyleBebop => 'Bebop';

  @override
  String get melodyStyleLyrical => 'Lyrical';

  @override
  String get melodyStyleColorful => 'Colorful';

  @override
  String get allowChromaticApproaches => 'Allow chromatic approaches';

  @override
  String get allowChromaticApproachesHelp =>
      'Permit enclosures and chromatic approach notes on weak beats when the style allows it.';

  @override
  String get melodyPlaybackMode => 'Melody playback';

  @override
  String get melodyPlaybackModeHelp =>
      'Choose whether manual preview buttons play chords, melody, or both together.';

  @override
  String get melodyPlaybackModeChordsOnly => 'Chords only';

  @override
  String get melodyPlaybackModeMelodyOnly => 'Melody only';

  @override
  String get melodyPlaybackModeBoth => 'Both';

  @override
  String get regenerateMelody => 'Regenerate melody';

  @override
  String get melodyPreviewCurrent => 'Current line';

  @override
  String get melodyPreviewNext => 'Next arrival';

  @override
  String get metronomePatternTitle => 'Metronome Pattern';

  @override
  String get metronomePatternHelp =>
      'Choose a meter-aware click pattern or define each beat manually.';

  @override
  String get metronomeUseAccentSound => 'Use separate accent sound';

  @override
  String get metronomeUseAccentSoundHelp =>
      'Use a different click source for accented beats instead of only raising the gain.';

  @override
  String get metronomePrimarySource => 'Primary click source';

  @override
  String get metronomeAccentSource => 'Accent click source';

  @override
  String get metronomeSourceKind => 'Source type';

  @override
  String get metronomeLocalFilePath => 'Local file path';

  @override
  String get metronomeLocalFilePathHelp =>
      'Paste a local audio file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeCustomSoundHelp =>
      'Upload your own metronome click. The app stores a private copy and keeps the built-in sound as fallback.';

  @override
  String get metronomeCustomSoundStatusBuiltIn =>
      'Currently using a built-in sound.';

  @override
  String metronomeCustomSoundStatusFile(Object fileName) {
    return 'Custom file: $fileName';
  }

  @override
  String get metronomeCustomSoundUpload => 'Upload custom sound';

  @override
  String get metronomeCustomSoundReplace => 'Replace custom sound';

  @override
  String get metronomeCustomSoundReset => 'Use built-in sound';

  @override
  String get metronomeCustomSoundUploadSuccess =>
      'Custom metronome sound saved.';

  @override
  String get metronomeCustomSoundResetSuccess =>
      'Switched back to the built-in metronome sound.';

  @override
  String get metronomeCustomSoundUploadError =>
      'Couldn\'t save the selected metronome audio file.';

  @override
  String get harmonySoundTitle => 'Harmony Sound';

  @override
  String get harmonyMasterVolume => 'Master volume';

  @override
  String get harmonyMasterVolumeHelp =>
      'Overall harmony preview loudness for manual and automatic chord playback.';

  @override
  String get harmonyPreviewHoldFactor => 'Chord hold length';

  @override
  String get harmonyPreviewHoldFactorHelp =>
      'Scale how long previewed chords and notes sustain.';

  @override
  String get harmonyArpeggioStepSpeed => 'Arpeggio step speed';

  @override
  String get harmonyArpeggioStepSpeedHelp =>
      'Control how quickly arpeggiated notes step forward.';

  @override
  String get harmonyVelocityHumanization => 'Velocity humanization';

  @override
  String get harmonyVelocityHumanizationHelp =>
      'Add small velocity variation so repeated previews feel less mechanical.';

  @override
  String get harmonyGainRandomness => 'Gain randomness';

  @override
  String get harmonyGainRandomnessHelp =>
      'Add slight per-note loudness variation on supported playback paths.';

  @override
  String get harmonyTimingHumanization => 'Timing humanization';

  @override
  String get harmonyTimingHumanizationHelp =>
      'Slightly loosen simultaneous note attacks for a less rigid block chord.';

  @override
  String get harmonySoundProfileSelectionTitle => 'Sound profile mode';

  @override
  String get harmonySoundProfileSelectionHelp =>
      'Elige un sonido equilibrado por defecto o fija un carácter de reproducción para practicar pop, jazz o clásico.';

  @override
  String get harmonySoundProfileSelectionNeutral => 'Neutral shared piano';

  @override
  String get harmonySoundProfileSelectionTrackAware => 'Track-aware';

  @override
  String get harmonySoundProfileSelectionPop => 'Pop profile';

  @override
  String get harmonySoundProfileSelectionJazz => 'Jazz profile';

  @override
  String get harmonySoundProfileSelectionClassical => 'Classical profile';

  @override
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern) {
    return 'Instrument: $instrument. Recommended preview: $pattern.';
  }

  @override
  String get harmonySoundProfileTrackAwareFallback =>
      'In free practice this stays on the shared piano profile. Study Harmony sessions switch to the active track\'s sound shaping.';

  @override
  String get harmonySoundProfileNeutralLabel => 'Balanced / shared piano';

  @override
  String get harmonySoundProfileNeutralSummary =>
      'Use the shared piano asset with a steady, all-purpose preview shape.';

  @override
  String get harmonySoundTagBalanced => 'balanced';

  @override
  String get harmonySoundTagPiano => 'piano';

  @override
  String get harmonySoundTagSoft => 'soft';

  @override
  String get harmonySoundTagOpen => 'open';

  @override
  String get harmonySoundTagModern => 'modern';

  @override
  String get harmonySoundTagDry => 'dry';

  @override
  String get harmonySoundTagWarm => 'warm';

  @override
  String get harmonySoundTagEpReady => 'EP-ready';

  @override
  String get harmonySoundTagClear => 'clear';

  @override
  String get harmonySoundTagAcoustic => 'acoustic';

  @override
  String get harmonySoundTagFocused => 'focused';

  @override
  String get harmonySoundNeutralTrait1 =>
      'Steady hold for general harmonic checking';

  @override
  String get harmonySoundNeutralTrait2 => 'Balanced attack with low coloration';

  @override
  String get harmonySoundNeutralTrait3 =>
      'Safe fallback for any lesson or free-play context';

  @override
  String get harmonySoundNeutralExpansion1 =>
      'Future split by piano register or room size';

  @override
  String get harmonySoundNeutralExpansion2 =>
      'Possible alternate shared instrument set for headphones';

  @override
  String get harmonySoundPopTrait1 =>
      'Longer sustain for open hooks and add9 color';

  @override
  String get harmonySoundPopTrait2 =>
      'Softer attack with a little width in repeated previews';

  @override
  String get harmonySoundPopTrait3 =>
      'Gentle humanization so loops feel less grid-locked';

  @override
  String get harmonySoundPopExpansion1 =>
      'Bright pop keys or layered piano-synth asset';

  @override
  String get harmonySoundPopExpansion2 =>
      'Wider stereo voicing playback for chorus lift';

  @override
  String get harmonySoundJazzTrait1 =>
      'Shorter hold to keep cadence motion readable';

  @override
  String get harmonySoundJazzTrait2 =>
      'Faster broken-preview feel for guide-tone hearing';

  @override
  String get harmonySoundJazzTrait3 =>
      'More touch variation to suggest shell and rootless comping';

  @override
  String get harmonySoundJazzExpansion1 =>
      'Dry upright or mellow electric-piano instrument family';

  @override
  String get harmonySoundJazzExpansion2 =>
      'Track-aware comping presets for shell and rootless drills';

  @override
  String get harmonySoundClassicalTrait1 =>
      'Centered sustain for function and cadence clarity';

  @override
  String get harmonySoundClassicalTrait2 =>
      'Low randomness to keep voice-leading stable';

  @override
  String get harmonySoundClassicalTrait3 =>
      'More direct block playback for harmonic arrival';

  @override
  String get harmonySoundClassicalExpansion1 =>
      'Direct acoustic piano profile with less ambient spread';

  @override
  String get harmonySoundClassicalExpansion2 =>
      'Dedicated cadence and sequence preview voicings';

  @override
  String get explanationSectionTitle => 'Why this works';

  @override
  String get explanationReasonSection => 'Why this result';

  @override
  String get explanationConfidenceHigh => 'High confidence';

  @override
  String get explanationConfidenceMedium => 'Plausible reading';

  @override
  String get explanationConfidenceLow => 'Treat as a tentative reading';

  @override
  String get explanationAmbiguityLow =>
      'Most of the progression points in one direction, but a light alternate reading is still possible.';

  @override
  String get explanationAmbiguityMedium =>
      'More than one plausible reading is still in play, so context matters here.';

  @override
  String get explanationAmbiguityHigh =>
      'Several readings are competing, so treat this as a cautious, context-dependent explanation.';

  @override
  String get explanationCautionParser =>
      'Some chord symbols were normalized before analysis.';

  @override
  String get explanationCautionAmbiguous =>
      'There is more than one reasonable reading here.';

  @override
  String get explanationCautionAlternateKey =>
      'A nearby key center also fits part of this progression.';

  @override
  String get explanationAlternativeSection => 'Other readings';

  @override
  String explanationAlternativeKeyLabel(Object keyLabel) {
    return 'Alternate key: $keyLabel';
  }

  @override
  String get explanationAlternativeKeyBody =>
      'The harmonic pull is still valid, but another key center also explains some of the same chords.';

  @override
  String explanationAlternativeReadingLabel(Object romanNumeral) {
    return 'Alternate reading: $romanNumeral';
  }

  @override
  String get explanationAlternativeReadingBody =>
      'This is another possible interpretation rather than a single definitive label.';

  @override
  String get explanationListeningSection => 'Listening focus';

  @override
  String get explanationListeningGuideToneTitle => 'Follow the 3rds and 7ths';

  @override
  String get explanationListeningGuideToneBody =>
      'Listen for the smallest inner-line motion as the cadence resolves.';

  @override
  String get explanationListeningDominantColorTitle =>
      'Listen for the dominant color';

  @override
  String get explanationListeningDominantColorBody =>
      'Notice how the tension on the dominant wants to release, even before the final arrival lands.';

  @override
  String get explanationListeningBackdoorTitle =>
      'Hear the softer backdoor pull';

  @override
  String get explanationListeningBackdoorBody =>
      'Listen for the subdominant-minor color leading home by color and voice leading rather than a plain V-I push.';

  @override
  String get explanationListeningBorrowedColorTitle => 'Hear the color shift';

  @override
  String get explanationListeningBorrowedColorBody =>
      'Notice how the borrowed chord darkens or brightens the loop before it returns home.';

  @override
  String get explanationListeningBassMotionTitle => 'Follow the bass motion';

  @override
  String get explanationListeningBassMotionBody =>
      'Track how the bass note reshapes momentum, even when the upper harmony stays closely related.';

  @override
  String get explanationListeningCadenceTitle => 'Hear the arrival';

  @override
  String get explanationListeningCadenceBody =>
      'Pay attention to which chord feels like the point of rest and how the approach prepares it.';

  @override
  String get explanationListeningAmbiguityTitle =>
      'Compare the competing readings';

  @override
  String get explanationListeningAmbiguityBody =>
      'Try hearing the same chord once for its local pull and once for its larger key-center role.';

  @override
  String get explanationPerformanceSection => 'Performance focus';

  @override
  String get explanationPerformancePopTitle => 'Keep the hook singable';

  @override
  String get explanationPerformancePopBody =>
      'Favor clear top notes, repeated contour, and open voicings that support the vocal line.';

  @override
  String get explanationPerformanceJazzTitle => 'Target guide tones first';

  @override
  String get explanationPerformanceJazzBody =>
      'Outline the 3rd and 7th before adding extra tensions or reharm color.';

  @override
  String get explanationPerformanceJazzShellTitle => 'Start with shell tones';

  @override
  String get explanationPerformanceJazzShellBody =>
      'Place the root, 3rd, and 7th cleanly first so the cadence stays easy to hear.';

  @override
  String get explanationPerformanceJazzRootlessTitle =>
      'Let the 3rd and 7th carry the shape';

  @override
  String get explanationPerformanceJazzRootlessBody =>
      'Keep the guide tones stable, then add 9 or 13 only if the line still resolves clearly.';

  @override
  String get explanationPerformanceClassicalTitle =>
      'Keep the voices disciplined';

  @override
  String get explanationPerformanceClassicalBody =>
      'Prioritize stable spacing, functional arrivals, and stepwise motion where possible.';

  @override
  String get explanationPerformanceDominantColorTitle =>
      'Add tension after the target is clear';

  @override
  String get explanationPerformanceDominantColorBody =>
      'Land the guide tones first, then treat 9, 13, or altered color as decoration rather than the main signal.';

  @override
  String get explanationPerformanceAmbiguityTitle =>
      'Anchor the most stable tones';

  @override
  String get explanationPerformanceAmbiguityBody =>
      'If the reading is ambiguous, emphasize the likely resolution tones before leaning into the more colorful option.';

  @override
  String get explanationPerformanceVoicingTitle => 'Voicing cue';

  @override
  String get explanationPerformanceMelodyTitle => 'Melody cue';

  @override
  String get explanationPerformanceMelodyBody =>
      'Lean on the structural target notes, then let passing tones fill the space around them.';

  @override
  String get explanationReasonFunctionalResolutionLabel => 'Functional pull';

  @override
  String get explanationReasonFunctionalResolutionBody =>
      'The chords line up as tonic, predominant, and dominant functions rather than isolated sonorities.';

  @override
  String get explanationReasonGuideToneSmoothnessLabel => 'Guide-tone motion';

  @override
  String get explanationReasonGuideToneSmoothnessBody =>
      'The inner voices move efficiently, which strengthens the sense of direction.';

  @override
  String get explanationReasonBorrowedColorLabel => 'Borrowed color';

  @override
  String get explanationReasonBorrowedColorBody =>
      'A parallel-mode borrowing adds contrast without fully leaving the home key.';

  @override
  String get explanationReasonSecondaryDominantLabel =>
      'Secondary dominant pull';

  @override
  String get explanationReasonSecondaryDominantBody =>
      'This dominant points strongly toward a local target chord instead of only the tonic.';

  @override
  String get explanationReasonTritoneSubLabel => 'Tritone-sub color';

  @override
  String get explanationReasonTritoneSubBody =>
      'The dominant color is preserved while the bass motion shifts to a substitute route.';

  @override
  String get explanationReasonDominantColorLabel => 'Dominant tension';

  @override
  String get explanationReasonDominantColorBody =>
      'Altered or extended dominant color strengthens the pull toward the next chord without changing the whole key reading.';

  @override
  String get explanationReasonBackdoorMotionLabel => 'Backdoor motion';

  @override
  String get explanationReasonBackdoorMotionBody =>
      'This reading leans on subdominant-minor or backdoor motion, so the resolution feels softer but still directed.';

  @override
  String get explanationReasonCadentialStrengthLabel => 'Cadential shape';

  @override
  String get explanationReasonCadentialStrengthBody =>
      'The phrase ends with a stronger arrival than a neutral loop continuation.';

  @override
  String get explanationReasonVoiceLeadingStabilityLabel =>
      'Stable voice leading';

  @override
  String get explanationReasonVoiceLeadingStabilityBody =>
      'The selected voicing keeps common tones or resolves tendency tones cleanly.';

  @override
  String get explanationReasonSingableContourLabel => 'Singable contour';

  @override
  String get explanationReasonSingableContourBody =>
      'The line favors memorable motion over angular, highly technical shapes.';

  @override
  String get explanationReasonSlashBassLiftLabel => 'Bass-motion lift';

  @override
  String get explanationReasonSlashBassLiftBody =>
      'The bass note changes the momentum even when the harmony stays closely related.';

  @override
  String get explanationReasonTurnaroundGravityLabel => 'Turnaround gravity';

  @override
  String get explanationReasonTurnaroundGravityBody =>
      'This pattern creates forward pull by cycling through familiar jazz resolution points.';

  @override
  String get explanationReasonInversionDisciplineLabel => 'Inversion control';

  @override
  String get explanationReasonInversionDisciplineBody =>
      'The inversion choice supports smoother outer-voice motion and clearer cadence behavior.';

  @override
  String get explanationReasonAmbiguityWindowLabel => 'Competing readings';

  @override
  String get explanationReasonAmbiguityWindowBody =>
      'Some of the same notes support more than one harmonic role, so context decides which reading feels stronger.';

  @override
  String get explanationReasonChromaticLineLabel => 'Chromatic line';

  @override
  String get explanationReasonChromaticLineBody =>
      'A chromatic bass or inner-line connection helps explain why this chord fits despite the extra color.';

  @override
  String get explanationTrackContextPop =>
      'In a pop context, this reading leans toward loop gravity, color contrast, and a singable top line.';

  @override
  String get explanationTrackContextJazz =>
      'In a jazz context, this is one plausible reading that highlights guide tones, cadence pull, and usable dominant color.';

  @override
  String get explanationTrackContextClassical =>
      'In a classical context, this reading leans toward function, inversion awareness, and cadence strength.';

  @override
  String get studyHarmonyTrackFocusSectionTitle => 'This track emphasizes';

  @override
  String get studyHarmonyTrackLessFocusSectionTitle =>
      'This track treats more lightly';

  @override
  String get studyHarmonyTrackRecommendedForSectionTitle => 'Recommended for';

  @override
  String get studyHarmonyTrackSoundSectionTitle => 'Sound profile';

  @override
  String get studyHarmonyTrackSoundAssetPlaceholder =>
      'Current release uses the shared piano asset. This profile prepares future track-specific sound choices.';

  @override
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument) {
    return 'Current instrument: $instrument';
  }

  @override
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern) {
    return 'Recommended preview pattern: $pattern';
  }

  @override
  String get studyHarmonyTrackSoundPlaybackTraitsTitle => 'Playback character';

  @override
  String get studyHarmonyTrackSoundExpansionTitle => 'Expansion path';

  @override
  String get studyHarmonyTrackPopFocus1 =>
      'Diatonic loop gravity and hook-friendly repetition';

  @override
  String get studyHarmonyTrackPopFocus2 =>
      'Borrowed-color lifts such as iv, bVII, or IVMaj7';

  @override
  String get studyHarmonyTrackPopFocus3 =>
      'Slash-bass and pedal-bass motion that supports pre-chorus lift';

  @override
  String get studyHarmonyTrackPopLess1 =>
      'Dense jazz reharmonization and advanced substitute dominants';

  @override
  String get studyHarmonyTrackPopLess2 =>
      'Rootless voicing systems and heavy altered-dominant language';

  @override
  String get studyHarmonyTrackPopRecommendedFor =>
      'Writers, producers, and players who want modern pop or ballad harmony that sounds usable quickly.';

  @override
  String get studyHarmonyTrackPopTheoryTone =>
      'Practical, song-first, and color-aware without overloading the learner with jargon.';

  @override
  String get studyHarmonyTrackPopHeroHeadline => 'Build hook-friendly loops';

  @override
  String get studyHarmonyTrackPopHeroBody =>
      'This track teaches loop gravity, restrained borrowed color, and bass movement that lifts a section without losing clarity.';

  @override
  String get studyHarmonyTrackPopQuickPracticeCue =>
      'Start with the signature loop chapter, then listen for how the bass and borrowed color reshape the same hook.';

  @override
  String get studyHarmonyTrackPopSoundLabel => 'Soft / open / modern';

  @override
  String get studyHarmonyTrackPopSoundSummary =>
      'Balanced piano now, with future room for brighter pop keys and wider stereo voicings.';

  @override
  String get studyHarmonyTrackJazzFocus1 =>
      'Guide-tone hearing and shell-to-rootless voicing growth';

  @override
  String get studyHarmonyTrackJazzFocus2 =>
      'Major ii-V-I, minor iiø-V-i y comportamiento del turnaround';

  @override
  String get studyHarmonyTrackJazzFocus3 =>
      'Dominant color, tensions, tritone sub, and backdoor entry points';

  @override
  String get studyHarmonyTrackJazzLess1 =>
      'Purely song-loop repetition without cadence awareness';

  @override
  String get studyHarmonyTrackJazzLess2 =>
      'Classical inversion literacy as a primary objective';

  @override
  String get studyHarmonyTrackJazzRecommendedFor =>
      'Players who want to hear and use functional jazz harmony without jumping straight into maximal reharm complexity.';

  @override
  String get studyHarmonyTrackJazzTheoryTone =>
      'Contextual, confidence-aware, and careful about calling one reading the only correct jazz answer.';

  @override
  String get studyHarmonyTrackJazzHeroHeadline =>
      'Hear the line inside the chords';

  @override
  String get studyHarmonyTrackJazzHeroBody =>
      'This track turns jazz harmony into manageable steps: guide tones first, then cadence families, then tasteful dominant color.';

  @override
  String get studyHarmonyTrackJazzQuickPracticeCue =>
      'Start with guide tones and shell voicings, then revisit the same cadence with rootless color.';

  @override
  String get studyHarmonyTrackJazzSoundLabel => 'Dry / warm / EP-ready';

  @override
  String get studyHarmonyTrackJazzSoundSummary =>
      'Shared piano for now, with placeholders for drier attacks and future electric-piano friendly playback.';

  @override
  String get studyHarmonyTrackClassicalFocus1 =>
      'Tonic / predominant / dominant function and cadence types';

  @override
  String get studyHarmonyTrackClassicalFocus2 =>
      'Inversion literacy, including first inversion and cadential 6/4 behavior';

  @override
  String get studyHarmonyTrackClassicalFocus3 =>
      'Voice-leading stability, sequence, and functional modulation basics';

  @override
  String get studyHarmonyTrackClassicalLess1 =>
      'Heavy tension stacking, quartal color, and upper-structure thinking';

  @override
  String get studyHarmonyTrackClassicalLess2 =>
      'Loop-driven pop repetition as the main learning frame';

  @override
  String get studyHarmonyTrackClassicalRecommendedFor =>
      'Learners who want clear functional hearing, inversion awareness, and disciplined voice leading.';

  @override
  String get studyHarmonyTrackClassicalTheoryTone =>
      'Structured, function-first, and phrased in a way that supports listening as well as label recognition.';

  @override
  String get studyHarmonyTrackClassicalHeroHeadline =>
      'Hear function and cadence clearly';

  @override
  String get studyHarmonyTrackClassicalHeroBody =>
      'This track emphasizes functional arrival, inversion control, and phrase endings that feel architecturally clear.';

  @override
  String get studyHarmonyTrackClassicalQuickPracticeCue =>
      'Start with cadence lab drills, then compare how inversions change the same function.';

  @override
  String get studyHarmonyTrackClassicalSoundLabel =>
      'Clear / acoustic / focused';

  @override
  String get studyHarmonyTrackClassicalSoundSummary =>
      'Shared piano for now, with room for a more direct acoustic profile in later releases.';

  @override
  String get studyHarmonyPopChapterSignatureLoopsTitle => 'Signature Pop Loops';

  @override
  String get studyHarmonyPopChapterSignatureLoopsDescription =>
      'Build practical pop instincts with hook gravity, borrowed lift, and bass motion that feels arrangement-ready.';

  @override
  String get studyHarmonyPopLessonHookGravityTitle => 'Hook Gravity';

  @override
  String get studyHarmonyPopLessonHookGravityDescription =>
      'Hear why modern four-chord loops stay catchy even when the harmony is simple.';

  @override
  String get studyHarmonyPopLessonBorrowedLiftTitle => 'Borrowed Lift';

  @override
  String get studyHarmonyPopLessonBorrowedLiftDescription =>
      'Experience restrained borrowed-color chords that brighten or darken a section without derailing the hook.';

  @override
  String get studyHarmonyPopLessonBassMotionTitle => 'Bass Motion';

  @override
  String get studyHarmonyPopLessonBassMotionDescription =>
      'Use slash-bass and line motion to create lift while the upper harmony stays familiar.';

  @override
  String get studyHarmonyPopLessonBossTitle => 'Pre-Chorus Lift Checkpoint';

  @override
  String get studyHarmonyPopLessonBossDescription =>
      'Combine loop gravity, borrowed color, and bass motion in one song-ready pop slice.';

  @override
  String get studyHarmonyJazzChapterGuideToneLabTitle => 'Guide-Tone Lab';

  @override
  String get studyHarmonyJazzChapterGuideToneLabDescription =>
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Reconoce cómo se siente el movimiento minor iiø-V-i y por qué allí el dominante suena más urgente.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceTitle =>
      'Tritone and Backdoor';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceDescription =>
      'Compare substitute-dominant and backdoor arrivals as plausible jazz routes into the same tonic.';

  @override
  String get studyHarmonyJazzLessonBossTitle => 'Turnaround Checkpoint';

  @override
  String get studyHarmonyJazzLessonBossDescription =>
      'Combina major ii-V-I, minor iiø-V-i, color rootless y reharm cuidadoso sin perder la claridad del punto de llegada de la cadencia.';

  @override
  String get studyHarmonyClassicalChapterCadenceLabTitle => 'Cadence Lab';

  @override
  String get studyHarmonyClassicalChapterCadenceLabDescription =>
      'Strengthen functional hearing with cadences, inversions, and carefully controlled secondary dominants.';

  @override
  String get studyHarmonyClassicalLessonCadenceTitle => 'Cadence Function';

  @override
  String get studyHarmonyClassicalLessonCadenceDescription =>
      'Sort tonic, predominant, and dominant behavior by how each chord prepares or completes the phrase.';

  @override
  String get studyHarmonyClassicalLessonInversionTitle => 'Inversion Control';

  @override
  String get studyHarmonyClassicalLessonInversionDescription =>
      'Hear how inversions change the bass line and the stability of an arrival.';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantTitle =>
      'Functional Secondary Dominants';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantDescription =>
      'Treat secondary dominants as directed functional events instead of generic color chords.';

  @override
  String get studyHarmonyClassicalLessonBossTitle => 'Arrival Checkpoint';

  @override
  String get studyHarmonyClassicalLessonBossDescription =>
      'Combine cadence shape, inversion awareness, and secondary-dominant pull in one controlled phrase.';

  @override
  String studyHarmonyPlayStyleLabel(String playStyle) {
    String _temp0 = intl.Intl.selectLogic(playStyle, {
      'competitor': 'Competitor',
      'collector': 'Collector',
      'explorer': 'Explorer',
      'stabilizer': 'Stabilizer',
      'balanced': 'Balanced',
      'other': 'Balanced',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyRewardFocusLabel(String focus) {
    String _temp0 = intl.Intl.selectLogic(focus, {
      'mastery': 'Focus: Mastery',
      'achievements': 'Focus: Achievements',
      'cosmetics': 'Focus: Cosmetics',
      'currency': 'Focus: Currency',
      'collection': 'Focus: Collection',
      'other': 'Focus',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress) {
    return 'Next $rewardTitle $progress%';
  }

  @override
  String studyHarmonyCurrencyBalanceLabel(String currencyTitle, int amount) {
    return '$currencyTitle $amount';
  }

  @override
  String studyHarmonyCurrencyGrantLabel(String currencyTitle, int amount) {
    return '$currencyTitle +$amount';
  }

  @override
  String studyHarmonyDifficultyLaneLabel(String lane) {
    String _temp0 = intl.Intl.selectLogic(lane, {
      'recovery': 'Recovery Lane',
      'groove': 'Groove Lane',
      'push': 'Push Lane',
      'clutch': 'Clutch Lane',
      'legend': 'Legend Lane',
      'other': 'Practice Lane',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPressureTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'calm': 'Calm Pressure',
      'steady': 'Steady Pressure',
      'hot': 'Hot Pressure',
      'charged': 'Charged Pressure',
      'overdrive': 'Overdrive',
      'other': 'Pressure',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyForgivenessTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'strict': 'Strict Windows',
      'tight': 'Tight Windows',
      'balanced': 'Balanced Windows',
      'kind': 'Kind Windows',
      'generous': 'Generous Windows',
      'other': 'Timing Windows',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyComboGoalLabel(int comboTarget) {
    return 'Combo Goal $comboTarget';
  }

  @override
  String studyHarmonyRuntimeTuningSummary(int lives, int goal) {
    return 'Lives $lives | Goal $goal';
  }

  @override
  String studyHarmonyCoachLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Supportive Coach',
      'structured': 'Structured Coach',
      'challengeForward': 'Challenge Coach',
      'analytical': 'Analytical Coach',
      'restorative': 'Restorative Coach',
      'other': 'Coach',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyCoachLine(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Protect flow first and let confidence compound.',
      'structured': 'Follow the structure and the gains will stick.',
      'challengeForward': 'Lean into the pressure and push for a sharper run.',
      'analytical': 'Read the weak point and refine it with precision.',
      'restorative': 'This run is about rebuilding rhythm without tilt.',
      'other': 'Keep the next run focused and intentional.',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPacingSegmentLabel(String segment, int minutes) {
    String _temp0 = intl.Intl.selectLogic(segment, {
      'warmup': 'Warmup',
      'tension': 'Tension',
      'release': 'Release',
      'reward': 'Reward',
      'other': 'Segment',
    });
    return '$_temp0 ${minutes}m';
  }

  @override
  String studyHarmonyPacingSummaryLabel(String segments) {
    return 'Pacing $segments';
  }

  @override
  String studyHarmonyArcadeRiskLabel(String risk) {
    String _temp0 = intl.Intl.selectLogic(risk, {
      'forgiving': 'Low Risk',
      'balanced': 'Balanced Risk',
      'tense': 'High Tension',
      'punishing': 'Punishing Risk',
      'other': 'Arcade Risk',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRewardStyleLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'currency': 'Currency Loop',
      'cosmetic': 'Cosmetic Hunt',
      'title': 'Title Hunt',
      'trophy': 'Trophy Run',
      'bundle': 'Bundle Rewards',
      'prestige': 'Prestige Rewards',
      'other': 'Reward Loop',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count) {
    return 'Combo bonus every $count';
  }

  @override
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives) {
    return 'Miss costs $lives';
  }

  @override
  String get studyHarmonyArcadeRuntimeModifierPulses => 'Modifier pulses';

  @override
  String get studyHarmonyArcadeRuntimeGhostPressure => 'Ghost pressure';

  @override
  String get studyHarmonyArcadeRuntimeShopBiasedLoot => 'Shop-biased loot';

  @override
  String get studyHarmonyArcadeRuntimeSteadyRuleset => 'Steady ruleset';

  @override
  String studyHarmonyShopStateLabel(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'alreadyPurchased': 'Already purchased',
      'readyToBuy': 'Ready to buy',
      'progressLocked': 'Progress locked',
      'other': 'Shop state',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyShopActionLabel(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'buy': 'Buy',
      'equipped': 'Equipped',
      'equip': 'Equip',
      'other': 'Shop action',
    });
    return '$_temp0';
  }

  @override
  String get melodyCurrentLineFeelTitle => 'Current line feel';

  @override
  String get melodyLinePersonalityTitle => 'Line personality';

  @override
  String get melodyLinePersonalityBody =>
      'These four sliders shape why guided, standard, and advanced can feel different even before you change the harmony.';

  @override
  String get melodySyncopationBiasTitle => 'Syncopation Bias';

  @override
  String get melodySyncopationBiasBody =>
      'Leans toward offbeat starts, anticipations, and rhythmic lift.';

  @override
  String get melodyColorRealizationBiasTitle => 'Color Realization Bias';

  @override
  String get melodyColorRealizationBiasBody =>
      'Lets the melody pick up featured tensions and color tones more often.';

  @override
  String get melodyNoveltyTargetTitle => 'Novelty Target';

  @override
  String get melodyNoveltyTargetBody =>
      'Reduces exact repeats and nudges the line toward fresher interval shapes.';

  @override
  String get melodyMotifVariationBiasTitle => 'Motif Variation Bias';

  @override
  String get melodyMotifVariationBiasBody =>
      'Turns motif reuse into sequence, tail changes, and rhythmic variation.';

  @override
  String get studyHarmonyArcadeRulesTitle => 'Arcade Rules';

  @override
  String studyHarmonySessionLengthLabel(int minutes) {
    return '$minutes min run';
  }

  @override
  String studyHarmonyRewardKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'achievement': 'Achievement',
      'title': 'Title',
      'cosmetic': 'Cosmetic',
      'shopItem': 'Shop Unlock',
      'other': 'Reward',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives) {
    return 'Misses cost $lives hearts';
  }

  @override
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount) {
    return 'Misses push progress back by $amount';
  }

  @override
  String studyHarmonyArcadeRuntimeComboProgressLabel(
    int threshold,
    int amount,
  ) {
    return 'Every $threshold combo adds +$amount progress';
  }

  @override
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount) {
    return 'Every $threshold combo adds +$amount heart';
  }

  @override
  String get studyHarmonyArcadeRuntimeComboResetLabel => 'Misses reset combo';

  @override
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount) {
    return 'Misses cut combo by $amount';
  }

  @override
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel =>
      'Choices reshuffle';

  @override
  String get studyHarmonyArcadeRuntimeMissedReplayLabel =>
      'Missed prompts replay';

  @override
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel => 'No prompt repeats';

  @override
  String get studyHarmonyRuntimeBundleClearBonusTitle => 'Clear Bonus';

  @override
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle => 'Precision Bonus';

  @override
  String get studyHarmonyRuntimeBundleComboBonusTitle => 'Combo Bonus';

  @override
  String get studyHarmonyRuntimeBundleModeBonusTitle => 'Mode Bonus';

  @override
  String get studyHarmonyRuntimeBundleMasteryBonusTitle => 'Mastery Bonus';

  @override
  String get melodyQuickPresetGuideLineLabel => 'Guide Line';

  @override
  String get melodyQuickPresetSongLineLabel => 'Song Line';

  @override
  String get melodyQuickPresetColorLineLabel => 'Color Line';

  @override
  String get melodyQuickPresetGuideCompactLabel => 'Guide';

  @override
  String get melodyQuickPresetSongCompactLabel => 'Song';

  @override
  String get melodyQuickPresetColorCompactLabel => 'Color';

  @override
  String get melodyQuickPresetGuideShort => 'steady guide notes';

  @override
  String get melodyQuickPresetSongShort => 'singable contour';

  @override
  String get melodyQuickPresetColorShort => 'color-forward line';

  @override
  String get melodyQuickPresetPanelTitle => 'Melody Presets';

  @override
  String get melodyQuickPresetPanelCompactTitle => 'Line Presets';

  @override
  String get melodyQuickPresetOffLabel => 'Off';

  @override
  String get melodyQuickPresetCompactOffLabel => 'Line Off';

  @override
  String get melodyMetricDensityLabel => 'Density';

  @override
  String get melodyMetricStyleLabel => 'Style';

  @override
  String get melodyMetricSyncLabel => 'Sync';

  @override
  String get melodyMetricColorLabel => 'Color';

  @override
  String get melodyMetricNoveltyLabel => 'Novelty';

  @override
  String get melodyMetricMotifLabel => 'Motif';

  @override
  String get melodyMetricChromaticLabel => 'Chromatic';

  @override
  String get practiceFirstRunWelcomeTitle => 'Tu primer acorde está listo';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'Ya se aplicó un perfil inicial apto para principiantes. Escúchalo primero y luego desliza la tarjeta para explorar el siguiente acorde.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel está listo. Escúchalo primero y luego desliza la tarjeta para explorar lo que sigue. También puedes abrir el asistente de configuración para personalizar el inicio.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Idioma de notación musical';

  @override
  String get musicNotationLocaleHelp =>
      'Controla el idioma usado para las ayudas opcionales de números romanos y texto de acordes.';

  @override
  String get musicNotationLocaleUiDefault => 'Igual que la app';

  @override
  String get musicNotationLocaleEnglish => 'Inglés';

  @override
  String get noteNamingStyle => 'Nombres de notas';

  @override
  String get noteNamingStyleHelp =>
      'Cambia los nombres visibles de notas y tonalidades sin alterar la lógica armónica.';

  @override
  String get noteNamingStyleEnglish => 'Letras inglesas';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Mostrar ayuda de números romanos';

  @override
  String get showRomanNumeralAssistHelp =>
      'Añade una breve explicación junto a las etiquetas de números romanos.';

  @override
  String get showChordTextAssist => 'Mostrar ayuda de texto de acordes';

  @override
  String get showChordTextAssistHelp =>
      'Añade una breve explicación sobre la cualidad del acorde y sus tensiones.';

  @override
  String get premiumUnlockTitle => 'Chordest Premium';

  @override
  String get premiumUnlockBody =>
      'A one-time purchase permanently unlocks Smart Generator and advanced harmonic color controls. Free Generator, Analyzer, metronome, and language support stay available.';

  @override
  String get premiumUnlockRequestedFeatureTitle => 'Requested in this flow';

  @override
  String get premiumUnlockOfflineCacheTitle =>
      'Using your last confirmed unlock';

  @override
  String get premiumUnlockOfflineCacheBody =>
      'The store is unavailable right now, so the app is using your last confirmed premium unlock cache.';

  @override
  String get premiumUnlockFreeTierTitle => 'Free';

  @override
  String get premiumUnlockFreeTierLineGenerator =>
      'Basic Generator, chord display, inversions, slash bass, and core metronome';

  @override
  String get premiumUnlockFreeTierLineAnalyzer =>
      'Conservative Analyzer with confidence and ambiguity warnings';

  @override
  String get premiumUnlockFreeTierLineMetronome =>
      'Language, theme, setup assistant, and standard practice settings';

  @override
  String get premiumUnlockPremiumTierTitle => 'Premium unlock';

  @override
  String get premiumUnlockPremiumLineSmartGenerator =>
      'Smart Generator mode for progression-aware generation in selected keys';

  @override
  String get premiumUnlockPremiumLineHarmonyColors =>
      'Secondary dominants, substitute dominants, modal interchange, and advanced tensions';

  @override
  String get premiumUnlockPremiumLineAdvancedSmartControls =>
      'Modulation intensity, jazz preset, and source profile controls for Smart Generator';

  @override
  String premiumUnlockBuyButton(Object priceLabel) {
    return 'Desbloqueo permanente ($priceLabel)';
  }

  @override
  String get premiumUnlockBuyButtonUnavailable => 'Unlock permanently';

  @override
  String get premiumUnlockRestoreButton => 'Restore purchase';

  @override
  String get premiumUnlockKeepFreeButton => 'Keep using free';

  @override
  String get premiumUnlockStoreFallbackBody =>
      'Store product info is not available right now. Free features keep working, and you can retry or restore later.';

  @override
  String get premiumUnlockStorePriceHint =>
      'Price comes from the store. The app does not hardcode a fixed price.';

  @override
  String get premiumUnlockStoreUnavailableTitle => 'Store unavailable';

  @override
  String get premiumUnlockStoreUnavailableBody =>
      'La conexión con la tienda no está disponible en este momento. Las funciones gratuitas siguen funcionando.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'La información del producto premium no está disponible ahora mismo. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockPurchaseSuccessTitle => 'Premium unlocked';

  @override
  String get premiumUnlockPurchaseSuccessBody =>
      'Your permanent premium unlock is now active on this device.';

  @override
  String get premiumUnlockRestoreSuccessTitle => 'Purchase restored';

  @override
  String get premiumUnlockRestoreSuccessBody =>
      'Your premium unlock was restored from the store.';

  @override
  String get premiumUnlockRestoreNotFoundTitle => 'Nothing to restore';

  @override
  String get premiumUnlockRestoreNotFoundBody =>
      'No matching premium unlock was found for this store account.';

  @override
  String get premiumUnlockPurchaseCancelledTitle => 'Purchase canceled';

  @override
  String get premiumUnlockPurchaseCancelledBody =>
      'No charge was made. Free features are still available.';

  @override
  String get premiumUnlockPurchasePendingTitle => 'Purchase pending';

  @override
  String get premiumUnlockPurchasePendingBody =>
      'The store marked this purchase as pending. Premium unlock will activate after confirmation.';

  @override
  String get premiumUnlockPurchaseFailedTitle => 'Purchase failed';

  @override
  String get premiumUnlockPurchaseFailedBody =>
      'No se pudo completar la compra. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockAlreadyOwned => 'Premium unlocked';

  @override
  String get premiumUnlockAlreadyOwnedTitle => 'Already unlocked';

  @override
  String get premiumUnlockAlreadyOwnedBody =>
      'This store account already has the premium unlock.';

  @override
  String get premiumUnlockHighlightSmartGenerator =>
      'Smart Generator mode and its deeper progression controls are part of the premium unlock.';

  @override
  String get premiumUnlockHighlightAdvancedHarmony =>
      'Non-diatonic color options and advanced tensions are part of the premium unlock.';

  @override
  String get premiumUnlockCardTitle => 'Premium unlock';

  @override
  String get premiumUnlockCardBodyUnlocked =>
      'Your one-time premium unlock is active.';

  @override
  String get premiumUnlockCardBodyLocked =>
      'Unlock Smart Generator and advanced harmonic color controls with one purchase.';

  @override
  String get premiumUnlockCardButton => 'View premium';

  @override
  String get premiumUnlockGeneratorHint =>
      'Smart Generator and advanced harmonic colors unlock with a one-time premium purchase.';

  @override
  String get premiumUnlockSettingsHintTitle => 'Premium controls';

  @override
  String get premiumUnlockSettingsHintBody =>
      'Smart Generator, non-diatonic color controls, and advanced tensions are part of the one-time premium unlock.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountCardSignedOutBody =>
      'Sign in to link premium to your account and restore it on your other devices.';

  @override
  String accountCardSignedInBody(Object email) {
    return 'Signed in as $email. Premium sync and restore now follow this account.';
  }

  @override
  String get accountCardUnavailableBody =>
      'Account features are not configured in this build yet. Add Firebase runtime configuration to enable sign-in.';

  @override
  String get accountOpenButton => 'Sign in';

  @override
  String get accountManageButton => 'Manage account';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String get accountCreateButton => 'Create account';

  @override
  String get accountSwitchToCreateButton => 'Create a new account';

  @override
  String get accountSwitchToSignInButton => 'I already have an account';

  @override
  String get accountForgotPasswordButton => 'Reset password';

  @override
  String get accountSignOutButton => 'Sign out';

  @override
  String get accountMessageSignedIn => 'You\'re signed in.';

  @override
  String get accountMessageSignedUp =>
      'Your account was created and signed in.';

  @override
  String get accountMessageSignedOut => 'You signed out of this account.';

  @override
  String get accountMessagePasswordResetSent => 'Password reset email sent.';

  @override
  String get accountMessageInvalidCredentials =>
      'Check your email and password and try again.';

  @override
  String get accountMessageEmailInUse => 'That email is already in use.';

  @override
  String get accountMessageWeakPassword =>
      'Use a stronger password to create this account.';

  @override
  String get accountMessageUserNotFound =>
      'No account was found for that email.';

  @override
  String get accountMessageTooManyRequests =>
      'Too many attempts right now. Please try again later.';

  @override
  String get accountMessageNetworkError =>
      'The network request failed. Please check your connection.';

  @override
  String get accountMessageAuthUnavailable =>
      'Account sign-in is not configured in this build yet.';

  @override
  String get accountMessageUnknownError =>
      'The account request could not be completed.';

  @override
  String get accountDeleteButton => 'Delete account';

  @override
  String get accountDeleteDialogTitle => 'Delete account?';

  @override
  String accountDeleteDialogBody(Object email) {
    return 'This permanently deletes the Chordest account for $email and removes synced premium data. Store purchase history stays with your store account.';
  }

  @override
  String get accountDeletePasswordHelper =>
      'Enter your current password to confirm this deletion request.';

  @override
  String get accountDeleteConfirmButton => 'Delete permanently';

  @override
  String get accountDeleteCancelButton => 'Cancel';

  @override
  String get accountDeletePasswordRequired =>
      'Enter your current password to delete this account.';

  @override
  String get accountMessageDeleted =>
      'Your account and synced premium data were deleted.';

  @override
  String get accountMessageDeleteRequiresRecentLogin =>
      'For safety, enter your current password and try again.';

  @override
  String get accountMessageDataDeletionFailed =>
      'We couldn\'t remove your synced account data. Please try again.';

  @override
  String get premiumUnlockAccountSyncTitle => 'Account sync';

  @override
  String get premiumUnlockAccountSyncSignedOutBody =>
      'You can keep using premium locally, but signing in lets this unlock follow your account to other devices.';

  @override
  String premiumUnlockAccountSyncSignedInBody(Object email) {
    return 'Premium purchases and restores will sync to $email when this account is signed in.';
  }

  @override
  String get premiumUnlockAccountSyncUnavailableBody =>
      'Account sync is not configured in this build yet, so premium currently stays local to this device.';

  @override
  String get premiumUnlockAccountOpenButton => 'Account';
}

/// The translations for Spanish Castilian, as used in the United States (`es_US`).
class AppLocalizationsEsUs extends AppLocalizationsEs {
  AppLocalizationsEsUs() : super('es_US');

  @override
  String get settings => 'Ajustes';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Valor predeterminado del sistema';

  @override
  String get themeMode => 'Tema';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get setupAssistantTitle => 'Setup Assistant';

  @override
  String get setupAssistantSubtitle =>
      'A few quick choices will make your first practice session feel calmer. You can rerun this anytime.';

  @override
  String get setupAssistantCurrentMode => 'Current setup';

  @override
  String get setupAssistantModeGuided => 'Guided mode';

  @override
  String get setupAssistantModeStandard => 'Standard mode';

  @override
  String get setupAssistantModeAdvanced => 'Advanced mode';

  @override
  String get setupAssistantRunAgain => 'Run setup assistant again';

  @override
  String get setupAssistantCardBody =>
      'Use a gentler profile now, then open advanced controls whenever you want more room.';

  @override
  String get setupAssistantPreparingTitle => 'We\'ll start gently';

  @override
  String get setupAssistantPreparingBody =>
      'Before the generator shows any chords, we\'ll set up a comfortable starting point in a few taps.';

  @override
  String setupAssistantProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setupAssistantSkip => 'Skip';

  @override
  String get setupAssistantBack => 'Back';

  @override
  String get setupAssistantNext => 'Next';

  @override
  String get setupAssistantApply => 'Apply';

  @override
  String get setupAssistantGoalQuestionTitle =>
      'What would you like this generator to help with first?';

  @override
  String get setupAssistantGoalQuestionBody =>
      'Pick the one that sounds closest. Nothing here is permanent.';

  @override
  String get setupAssistantGoalEarTitle => 'Hear and recognize chords';

  @override
  String get setupAssistantGoalEarBody =>
      'Short, friendly prompts for listening and recognition.';

  @override
  String get setupAssistantGoalKeyboardTitle => 'Keyboard hand practice';

  @override
  String get setupAssistantGoalKeyboardBody =>
      'Simple shapes and readable symbols for your hands first.';

  @override
  String get setupAssistantGoalSongTitle => 'Song ideas';

  @override
  String get setupAssistantGoalSongBody =>
      'Keep the generator musical without dumping you into chaos.';

  @override
  String get setupAssistantGoalHarmonyTitle => 'Harmony study';

  @override
  String get setupAssistantGoalHarmonyBody =>
      'Start clear, then leave room to grow into deeper harmony.';

  @override
  String get setupAssistantLiteracyQuestionTitle =>
      'Which sentence feels closest right now?';

  @override
  String get setupAssistantLiteracyQuestionBody =>
      'Choose the most comfortable answer, not the most ambitious one.';

  @override
  String get setupAssistantLiteracyAbsoluteTitle =>
      'C, Cm, C7, and Cmaj7 still blur together';

  @override
  String get setupAssistantLiteracyAbsoluteBody =>
      'Keep things extra readable and familiar.';

  @override
  String get setupAssistantLiteracyBasicTitle => 'I can read maj7 / m7 / 7';

  @override
  String get setupAssistantLiteracyBasicBody =>
      'Stay safe, but allow a little more range.';

  @override
  String get setupAssistantLiteracyFunctionalTitle =>
      'I mostly follow ii-V-I and diatonic function';

  @override
  String get setupAssistantLiteracyFunctionalBody =>
      'Keep the harmony clear with a bit more motion.';

  @override
  String get setupAssistantLiteracyAdvancedTitle =>
      'Colorful reharmonization and extensions already feel familiar';

  @override
  String get setupAssistantLiteracyAdvancedBody =>
      'Leave more of the power-user range available.';

  @override
  String get setupAssistantHandQuestionTitle =>
      'How comfortable do your hands feel on keys?';

  @override
  String get setupAssistantHandQuestionBody =>
      'We\'ll use this to keep voicings playable.';

  @override
  String get setupAssistantHandThreeTitle => 'Three-note shapes feel best';

  @override
  String get setupAssistantHandThreeBody => 'Keep the hand shape compact.';

  @override
  String get setupAssistantHandFourTitle => 'Four notes are okay';

  @override
  String get setupAssistantHandFourBody => 'Allow a little more spread.';

  @override
  String get setupAssistantHandJazzTitle => 'Jazzier shapes feel comfortable';

  @override
  String get setupAssistantHandJazzBody =>
      'Open the door to larger voicings later.';

  @override
  String get setupAssistantColorQuestionTitle =>
      'How colorful should the sound feel at first?';

  @override
  String get setupAssistantColorQuestionBody => 'When in doubt, start simpler.';

  @override
  String get setupAssistantColorSafeTitle => 'Safe and familiar';

  @override
  String get setupAssistantColorSafeBody =>
      'Stay close to classic, readable harmony.';

  @override
  String get setupAssistantColorJazzyTitle => 'A little jazzy';

  @override
  String get setupAssistantColorJazzyBody =>
      'Add a touch of color without getting wild.';

  @override
  String get setupAssistantColorColorfulTitle => 'Quite colorful';

  @override
  String get setupAssistantColorColorfulBody =>
      'Leave more room for modern color.';

  @override
  String get setupAssistantSymbolQuestionTitle =>
      'Which chord spelling feels easiest to read?';

  @override
  String get setupAssistantSymbolQuestionBody =>
      'This only changes how the chord is shown.';

  @override
  String get setupAssistantSymbolMajTextBody => 'Clear and beginner-friendly.';

  @override
  String get setupAssistantSymbolCompactBody =>
      'Shorter if you already like compact symbols.';

  @override
  String get setupAssistantSymbolDeltaBody =>
      'Jazz-style if that is what your eyes expect.';

  @override
  String get setupAssistantKeyQuestionTitle => 'Which key should we start in?';

  @override
  String get setupAssistantKeyQuestionBody =>
      'C major is the easiest default, but you can change it later.';

  @override
  String get setupAssistantKeyCMajorBody => 'Best beginner starting point.';

  @override
  String get setupAssistantKeyGMajorBody =>
      'A bright major key with one sharp.';

  @override
  String get setupAssistantKeyFMajorBody => 'A warm major key with one flat.';

  @override
  String get setupAssistantPreviewTitle => 'Try your first result';

  @override
  String get setupAssistantPreviewBody =>
      'This is about what the generator will feel like. You can make it simpler or a little jazzier before you start.';

  @override
  String get setupAssistantPreviewListen => 'Hear this sample';

  @override
  String get setupAssistantPreviewPlaying => 'Playing sample...';

  @override
  String get setupAssistantStartNow => 'Start with this';

  @override
  String get setupAssistantAdjustEasier => 'Make it easier';

  @override
  String get setupAssistantAdjustJazzier => 'A little more jazzy';

  @override
  String get setupAssistantPreviewKeyLabel => 'Key';

  @override
  String get setupAssistantPreviewNotationLabel => 'Notation';

  @override
  String get setupAssistantPreviewDifficultyLabel => 'Feel';

  @override
  String get setupAssistantPreviewProgressionLabel => 'Sample progression';

  @override
  String get setupAssistantPreviewProgressionBody =>
      'A short four-chord sample built from your setup.';

  @override
  String get setupAssistantPreviewSummaryAbsolute => 'Beginner-friendly start';

  @override
  String get setupAssistantPreviewSummaryBasic =>
      'Readable seventh-chord start';

  @override
  String get setupAssistantPreviewSummaryFunctional =>
      'Functional harmony start';

  @override
  String get setupAssistantPreviewSummaryAdvanced => 'Colorful jazz start';

  @override
  String get setupAssistantPreviewBodyTriads =>
      'Mostly familiar triads in a safe key, with compact voicings and no spicy surprises.';

  @override
  String get setupAssistantPreviewBodySevenths =>
      'maj7, m7, and 7 show up clearly, while the progression still stays calm and readable.';

  @override
  String get setupAssistantPreviewBodySafeExtensions =>
      'A little extra color can appear, but it stays within safe, familiar extensions.';

  @override
  String get setupAssistantPreviewBodyFullExtensions =>
      'The preview leaves more room for modern color, richer movement, and denser harmony.';

  @override
  String get setupAssistantNotationMajText => 'Cmaj7 style';

  @override
  String get setupAssistantNotationCompact => 'CM7 style';

  @override
  String get setupAssistantNotationDelta => 'CΔ7 style';

  @override
  String get setupAssistantDifficultyTriads =>
      'Simple triads and core movement';

  @override
  String get setupAssistantDifficultySevenths => 'maj7 / m7 / 7 centered';

  @override
  String get setupAssistantDifficultySafeExtensions =>
      'Safe color with 9 / 11 / 13';

  @override
  String get setupAssistantDifficultyFullExtensions =>
      'Full color and wider motion';

  @override
  String get setupAssistantStudyHarmonyTitle =>
      'Want a gentler theory path too?';

  @override
  String get setupAssistantStudyHarmonyBody =>
      'Study Harmony can walk you through the basics while this generator stays in a safe lane.';

  @override
  String get setupAssistantStudyHarmonyCta => 'Start Study Harmony';

  @override
  String get setupAssistantGuidedSettingsTitle =>
      'Beginner-friendly setup is on';

  @override
  String get setupAssistantGuidedSettingsBody =>
      'Core controls stay close by here. Everything else is still available when you want it.';

  @override
  String get setupAssistantAdvancedSectionTitle => 'More controls';

  @override
  String get setupAssistantAdvancedSectionBody =>
      'Open the full settings page if you want every generator option.';

  @override
  String get metronome => 'Metrónomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Enciende el metrónomo para escuchar un clic en cada tiempo mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metrónomo';

  @override
  String get metronomeSoundClassic => 'Clásico';

  @override
  String get metronomeSoundClickB => 'Haga clic en B';

  @override
  String get metronomeSoundClickC => 'Haga clic en C';

  @override
  String get metronomeSoundClickD => 'Haga clic en D';

  @override
  String get metronomeSoundClickE => 'Haga clic en E';

  @override
  String get metronomeSoundClickF => 'Haga clic en F';

  @override
  String get metronomeVolume => 'Volumen del metrónomo';

  @override
  String get practiceMeter => 'Time Signature';

  @override
  String get practiceMeterHelp =>
      'Choose how many beats are in each bar for transport and metronome timing.';

  @override
  String get practiceTimeSignatureTwoFour => '2/4';

  @override
  String get practiceTimeSignatureThreeFour => '3/4';

  @override
  String get practiceTimeSignatureFourFour => '4/4';

  @override
  String get practiceTimeSignatureFiveFour => '5/4';

  @override
  String get practiceTimeSignatureSixEight => '6/8';

  @override
  String get practiceTimeSignatureSevenEight => '7/8';

  @override
  String get practiceTimeSignatureTwelveEight => '12/8';

  @override
  String get harmonicRhythm => 'Harmonic Rhythm';

  @override
  String get harmonicRhythmHelp =>
      'Choose how often chord changes can happen inside the bar.';

  @override
  String get harmonicRhythmOnePerBar => 'One per bar';

  @override
  String get harmonicRhythmTwoPerBar => 'Two per bar';

  @override
  String get harmonicRhythmPhraseAwareJazz => 'Phrase-aware jazz';

  @override
  String get harmonicRhythmCadenceCompression => 'Cadence compression';

  @override
  String get keys => 'Llaves';

  @override
  String get noKeysSelected =>
      'No hay claves seleccionadas. Deja todas las teclas apagadas para practicar en modo libre en cada raíz.';

  @override
  String get keysSelectedHelp =>
      'Las claves seleccionadas se utilizan para el modo aleatorio con reconocimiento de clave y el modo Smart Generator.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioriza el movimiento armónico funcional conservando las opciones no diatónico habilitadas.';

  @override
  String get advancedSmartGenerator => 'Avanzado Smart Generator';

  @override
  String get modulationIntensity => 'Intensidad de modulación';

  @override
  String get modulationIntensityOff => 'Apagado';

  @override
  String get modulationIntensityLow => 'Bajo';

  @override
  String get modulationIntensityMedium => 'Medio';

  @override
  String get modulationIntensityHigh => 'Alto';

  @override
  String get jazzPreset => 'Preajuste de jazz';

  @override
  String get jazzPresetStandardsCore => 'Núcleo de estándares';

  @override
  String get jazzPresetModulationStudy => 'Estudio de modulación';

  @override
  String get jazzPresetAdvanced => 'Avanzado';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Estándar de libro falso';

  @override
  String get sourceProfileRecordingInspired => 'Grabación inspirada';

  @override
  String get smartDiagnostics => 'Diagnóstico inteligente';

  @override
  String get smartDiagnosticsHelp =>
      'Registra los seguimientos de decisiones Smart Generator para la depuración.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Seleccione al menos una tecla para usar el modo Smart Generator.';

  @override
  String get nonDiatonic => 'No diatónico';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Las opciones que no son diatónico están disponibles solo en modo clave.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Sustituto dominante';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'El intercambio modal sólo aparece en modo clave, por lo que esta opción está deshabilitada en modo libre.';

  @override
  String get rendering => 'Representación';

  @override
  String get keyCenterLabelStyle => 'Estilo de etiqueta clave';

  @override
  String get keyCenterLabelStyleHelp =>
      'Elija entre nombres de modo explícitos y etiquetas tónicas clásicas en mayúsculas/minúsculas.';

  @override
  String get chordSymbolStyle => 'Estilo de símbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Cambia solo la capa de visualización. La lógica armónica sigue siendo canónica.';

  @override
  String get styleCompact => 'Compacto';

  @override
  String get styleMajText => 'MajTexto';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get keyCenterLabelStyleModeText => 'Do mayor: / Do menor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C:/c:';

  @override
  String get allowV7sus4 => 'Permitir V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get chordTypeFilters => 'Tipos de acordes';

  @override
  String get chordTypeFiltersHelp =>
      'Elige que tipos de acordes pueden aparecer en el generador.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total activados';
  }

  @override
  String get chordTypeGroupTriads => 'Triadas';

  @override
  String get chordTypeGroupSevenths => 'Septimas';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sextas y notas anadidas';

  @override
  String get chordTypeGroupDominantVariants => 'Variantes dominantes';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 solo esta disponible cuando se selecciona al menos una tonalidad.';

  @override
  String get chordTypeKeepOneEnabled =>
      'Manten al menos un tipo de acorde activado.';

  @override
  String get tensionHelp =>
      'Perfil número romano y chips seleccionados únicamente';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Habilitar inversiones';

  @override
  String get inversionHelp =>
      'Representación aleatoria de graves después de la selección de acordes; no rastrea el bajo anterior.';

  @override
  String get firstInversion => '1ra inversión';

  @override
  String get secondInversion => '2da inversión';

  @override
  String get thirdInversion => '3ra inversión';

  @override
  String get keyPracticeOverview =>
      'Descripción general de las prácticas clave';

  @override
  String get freePracticeOverview => 'Descripción general de la práctica libre';

  @override
  String get keyModeTag => 'Modo clave';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las claves';

  @override
  String get metronomeOnTag => 'Metrónomo activado';

  @override
  String get metronomeOffTag => 'Metrónomo desactivado';

  @override
  String get pressNextChordToBegin => 'Presione Siguiente acorde para comenzar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Utiliza las 12 raíces cromáticas con cualidades de acordes aleatorios para una práctica de lectura amplia.';

  @override
  String get smartPracticeDescription =>
      'Sigue el flujo función armónica en las teclas seleccionadas al tiempo que permite un movimiento elegante del generador inteligente.';

  @override
  String get keyPracticeDescription =>
      'Utiliza las claves seleccionadas y los número romano habilitados para generar material de práctica diatónico.';

  @override
  String get keyboardShortcutHelp =>
      'Espacio: siguiente acorde Enter: iniciar o pausar la reproducción automática Arriba/Abajo: ajustar BPM';

  @override
  String get currentChord => 'Acorde actual';

  @override
  String get nextChord => 'Acorde siguiente';

  @override
  String get audioPlayChord => 'tocar acorde';

  @override
  String get audioPlayArpeggio => 'Tocar arpegio';

  @override
  String get audioPlayProgression => 'Progresión del juego';

  @override
  String get audioPlayPrompt => 'Reproducir mensaje';

  @override
  String get startAutoplay => 'Iniciar reproducción automática';

  @override
  String get pauseAutoplay => 'Pausar reproducción automática';

  @override
  String get stopAutoplay => 'Detener la reproducción automática';

  @override
  String get resetGeneratedChords => 'Reiniciar acordes generados';

  @override
  String get decreaseBpm => 'Disminuir BPM';

  @override
  String get increaseBpm => 'Aumentar BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return 'Rango permitido: $min-$max';
  }

  @override
  String get modeMajor => 'importante';

  @override
  String get modeMinor => 'menor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Sugerencias de voicings';

  @override
  String get voicingSuggestionsSubtitle =>
      'Vea opciones de notas concretas para este acorde.';

  @override
  String get voicingSuggestionsEnabled => 'Habilitar sugerencias de voz';

  @override
  String get voicingSuggestionsHelp =>
      'Muestra tres ideas voicing a nivel de nota reproducibles para el acorde actual.';

  @override
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

  @override
  String get voicingComplexity => 'Complejidad de expresión';

  @override
  String get voicingComplexityHelp =>
      'Controla el color que pueden llegar a tener las sugerencias.';

  @override
  String get voicingComplexityBasic => 'Básico';

  @override
  String get voicingComplexityStandard => 'Estándar';

  @override
  String get voicingComplexityModern => 'Moderno';

  @override
  String get voicingTopNotePreference => 'Preferencia de nota superior';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Inclina sugerencias hacia un línea superior elegido. Los voicing bloqueados ganan primero, luego los acordes repetidos lo mantienen estable.';

  @override
  String get voicingTopNotePreferenceAuto => 'Automático';

  @override
  String get allowRootlessVoicings => 'Permitir voces desarraigadas';

  @override
  String get allowRootlessVoicingsHelp =>
      'Permitamos que las sugerencias omitan la raíz cuando los nota guía permanezcan claros.';

  @override
  String get maxVoicingNotes => 'Notas de voz máximas';

  @override
  String get lookAheadDepth => 'Profundidad de anticipación';

  @override
  String get lookAheadDepthHelp =>
      'Cuántos acordes futuros puede considerar el ranking.';

  @override
  String get showVoicingReasons => 'Mostrar razones para expresar';

  @override
  String get showVoicingReasonsHelp =>
      'Muestra breves fichas explicativas en cada tarjeta de sugerencias.';

  @override
  String get voicingSuggestionNatural => 'más natural';

  @override
  String get voicingSuggestionColorful => 'más colorido';

  @override
  String get voicingSuggestionEasy => 'mas facil';

  @override
  String get voicingSuggestionNaturalSubtitle => 'Primero la voz principal';

  @override
  String get voicingSuggestionColorfulSubtitle =>
      'Se inclina hacia los tonos de color.';

  @override
  String get voicingSuggestionEasySubtitle => 'Forma de mano compacta';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle =>
      'Conexión y resolución primero.';

  @override
  String get voicingSuggestionNaturalStableSubtitle =>
      'Misma forma, competición constante';

  @override
  String get voicingSuggestionTopLineSubtitle =>
      'Clientes potenciales de primera línea';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle =>
      'Tensión alterada en la delantera';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'Color cuarto moderno';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Borde sub-tritono con nota guía brillantes';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      'Tonos guía con extensiones brillantes.';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle =>
      'Tonos centrales, menor alcance';

  @override
  String get voicingSuggestionEasyStableSubtitle =>
      'Forma de mano fácil de repetir';

  @override
  String get voicingPerformanceSubtitle =>
      'Feature one representative comping shape and keep the next move in view.';

  @override
  String get voicingPerformanceCurrentTitle => 'Current voicing';

  @override
  String get voicingPerformanceNextTitle => 'Next preview';

  @override
  String get voicingPerformanceCurrentOnly => 'Current only';

  @override
  String get voicingPerformanceShared => 'Shared';

  @override
  String get voicingPerformanceNextOnly => 'Next move';

  @override
  String voicingPerformanceTopLinePath(Object current, Object next) {
    return 'Top line: $current -> $next';
  }

  @override
  String get voicingTopNoteLabel => 'Arriba';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'Objetivo de línea superior: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Bloqueado línea superior: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'línea superior repetido: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'línea superior más cercano a $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No hay línea superior exacto para $note';
  }

  @override
  String get voicingFamilyShell => 'Caparazón';

  @override
  String get voicingFamilyRootlessA => 'Sin raíces A';

  @override
  String get voicingFamilyRootlessB => 'Sin raíces B';

  @override
  String get voicingFamilySpread => 'Desparramar';

  @override
  String get voicingFamilySus => 'sus';

  @override
  String get voicingFamilyQuartal => 'cuarto';

  @override
  String get voicingFamilyAltered => 'alterado';

  @override
  String get voicingFamilyUpperStructure => 'Estructura superior';

  @override
  String get voicingLockSuggestion => 'Sugerencia de bloqueo';

  @override
  String get voicingUnlockSuggestion => 'Sugerencia de desbloqueo';

  @override
  String get voicingSelected => 'Seleccionado';

  @override
  String get voicingLocked => 'bloqueado';

  @override
  String get voicingReasonEssentialCore => 'Tonos esenciales cubiertos';

  @override
  String get voicingReasonGuideToneAnchor => '3.º/7.º ancla';

  @override
  String voicingReasonGuideResolution(int count) {
    return 'El tono guía $count se resuelve';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return 'Se mantienen los tonos comunes $count';
  }

  @override
  String get voicingReasonStableRepeat => 'Repetición estable';

  @override
  String get voicingReasonTopLineTarget => 'Objetivo de primera línea';

  @override
  String get voicingReasonLowMudAvoided => 'Claridad de registro bajo';

  @override
  String get voicingReasonCompactReach => 'Alcance cómodo';

  @override
  String get voicingReasonBassAnchor => 'Ancla de bajo respetada';

  @override
  String get voicingReasonNextChordReady => 'Siguiente acorde listo';

  @override
  String get voicingReasonAlteredColor => 'Tensiones alteradas';

  @override
  String get voicingReasonRootlessClarity => 'Forma ligera y sin raíces.';

  @override
  String get voicingReasonSusRelease => 'Configuración de lanzamiento de Sus';

  @override
  String get voicingReasonQuartalColor => 'color cuarto';

  @override
  String get voicingReasonUpperStructureColor =>
      'Color de la estructura superior';

  @override
  String get voicingReasonTritoneSubFlavor => 'Sabor sub-tritono';

  @override
  String get voicingReasonLockedContinuity => 'Continuidad bloqueada';

  @override
  String get voicingReasonGentleMotion => 'Movimiento suave de la mano';

  @override
  String get mainMenuIntro =>
      'Genera tu siguiente loop de acordes en Chordest y usa el Analyzer solo cuando necesites una lectura armónica cautelosa.';

  @override
  String get mainMenuGeneratorTitle => 'Generador Chordest';

  @override
  String get mainMenuGeneratorDescription =>
      'Empieza con un loop tocable, ayuda de voicings y controles rápidos de práctica.';

  @override
  String get openGenerator => 'Empezar práctica';

  @override
  String get openAnalyzer => 'Analizar progresión';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Consulta tonalidades probables, números romanos y avisos con una lectura conservadora.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Estudio de armonía';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Retoma lecciones, repasa capítulos y fortalece tu armonía práctica.';

  @override
  String get openStudyHarmony => 'Empezar armonía';

  @override
  String get studyHarmonyTitle => 'Estudio de armonía';

  @override
  String get studyHarmonySubtitle =>
      'Trabaje a través de un centro de armonía estructurado con entradas rápidas de lecciones y progreso de capítulos.';

  @override
  String get studyHarmonyPlaceholderTag => 'cubierta de estudio';

  @override
  String get studyHarmonyPlaceholderBody =>
      'Los datos de las lecciones, las indicaciones y las superficies de respuestas ya comparten un flujo de estudio reutilizable para notas, acordes, escalas y ejercicios de progresión.';

  @override
  String get studyHarmonyTestLevelTag => 'Ejercicio de practica';

  @override
  String get studyHarmonyTestLevelAction => 'taladro abierto';

  @override
  String get studyHarmonySubmit => 'Entregar';

  @override
  String get studyHarmonyNextPrompt => 'Siguiente mensaje';

  @override
  String get studyHarmonySelectedAnswers => 'Respuestas seleccionadas';

  @override
  String get studyHarmonySelectionEmpty =>
      'Aún no se han seleccionado respuestas.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total correcto';
  }

  @override
  String get studyHarmonyAttempts => 'Intentos';

  @override
  String get studyHarmonyAccuracy => 'Exactitud';

  @override
  String get studyHarmonyElapsedTime => 'Tiempo';

  @override
  String get studyHarmonyObjective => 'Meta';

  @override
  String get studyHarmonyPromptInstruction =>
      'Elige la respuesta correspondiente';

  @override
  String get studyHarmonyNeedSelection =>
      'Elija al menos una respuesta antes de enviar.';

  @override
  String get studyHarmonyCorrectLabel => 'Correcto';

  @override
  String get studyHarmonyIncorrectLabel => 'Incorrecto';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return 'Correcto. $answer fue la respuesta correcta.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return 'Incorrecto. $answer fue la respuesta correcta y perdiste una vida.';
  }

  @override
  String get studyHarmonyGameOverTitle => 'Juego terminado';

  @override
  String get studyHarmonyGameOverBody =>
      'Las tres vidas se han ido. Vuelva a intentar este nivel o regrese al centro Estudio de armonía.';

  @override
  String get studyHarmonyLevelCompleteTitle => 'Nivel superado';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'Has alcanzado el objetivo de la lección. Verifique su precisión y tiempo claro a continuación.';

  @override
  String get studyHarmonyBackToHub => 'Volver a Estudio de armonía';

  @override
  String get studyHarmonyRetry => 'Rever';

  @override
  String get studyHarmonyHubHeroEyebrow => 'Centro de estudios';

  @override
  String get studyHarmonyHubHeroBody =>
      'Utilice Continuar para retomar el impulso, Revisar para volver a visitar los puntos débiles y Diariamente para obtener una lección determinista de su camino desbloqueado.';

  @override
  String get studyHarmonyTrackFilterLabel => 'Rutas';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Base';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Clásica';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return 'Capítulos $cleared/$total completados';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return 'Habilidades $mastered/$total dominadas';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count revisiones listas';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'Racha x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count se ejecuta';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'Mejor $rank';
  }

  @override
  String get studyHarmonyBossTag => 'Jefe';

  @override
  String get studyHarmonyContinueCardTitle => 'Continuar';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Reanude la lección que tocó más recientemente.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Salta a la siguiente lección de tu frontera actual.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return 'Continuar: $lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => 'Continuar';

  @override
  String get studyHarmonyReviewCardTitle => 'Repaso';

  @override
  String get studyHarmonyReviewQueueHint => 'Sale de tu cola de repaso actual.';

  @override
  String get studyHarmonyReviewWeakHint =>
      'Sale del resultado más flojo entre tus lecciones jugadas.';

  @override
  String get studyHarmonyReviewFallbackHint =>
      'Aún no hay deuda de repaso, así que volvemos a tu frontera actual.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      'Esta lección pide otro intento tras un fallo o una sesión sin cerrar.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      'Esta lección está en cola para un repaso rápido de precisión.';

  @override
  String get studyHarmonyReviewAction => 'Repasar';

  @override
  String get studyHarmonyDailyCardTitle => 'Desafío diario';

  @override
  String get studyHarmonyDailyCardHint =>
      'Abra la selección determinista de hoy de sus lecciones desbloqueadas.';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      'La diaria de hoy ya está superada. Si quieres, vuelve a jugarla, o regresa mañana para cuidar la racha.';

  @override
  String get studyHarmonyDailyAction => 'Jugar diaria';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Semilla $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => 'Borrado diariamente hoy';

  @override
  String get studyHarmonyReviewSessionTitle => 'Revisión de puntos débiles';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return 'Combine una breve reseña sobre $chapterTitle y sus habilidades recientes más débiles.';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'Desafío diario';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return 'Juega la mezcla inicial de hoy creada a partir de $chapterTitle y tu frontera actual.';
  }

  @override
  String get studyHarmonyModeLesson => 'Modo de lección';

  @override
  String get studyHarmonyModeReview => 'Modo de revisión';

  @override
  String get studyHarmonyModeDaily => 'Modo diario';

  @override
  String get studyHarmonyModeLegacy => 'Modo de práctica';

  @override
  String get studyHarmonyShortcutHint =>
      'Ingrese envíos o continúe. R se reinicia. 1-9 elige una respuesta. Tab y Shift+Tab mueven el foco.';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$remaining de $total vidas restantes';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'Ganancias de habilidades';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Enfoque de revisión';

  @override
  String get studyHarmonyResultRewardTitle => 'Recompensa de sesión';

  @override
  String get studyHarmonyBonusGoalsTitle => 'Objetivos de bonificación';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'Rango $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars estrellas';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return 'Mejores estrellas $rank · $stars';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return 'Racha diaria x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => 'Nueva marca personal';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded =>
      'Motivo de la revisión: es necesario volver a intentarlo';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh =>
      'Motivo de la revisión: actualización de precisión';

  @override
  String get studyHarmonyReviewReasonLowMastery =>
      'Motivo de la revisión: bajo dominio';

  @override
  String get studyHarmonyReviewReasonStaleSkill =>
      'Motivo de la revisión: habilidad obsoleta';

  @override
  String get studyHarmonyReviewReasonWeakSpot =>
      'Motivo de la revisión: punto débil';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh =>
      'Motivo de la revisión: actualización de frontera';

  @override
  String get studyHarmonyQuestBoardTitle => 'Tablero de misiones';

  @override
  String get studyHarmonyQuestCompletedTag => 'Terminado';

  @override
  String get studyHarmonyQuestTodayTag => 'Hoy';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target completo';
  }

  @override
  String get studyHarmonyQuestDailyTitle => 'Racha diaria';

  @override
  String get studyHarmonyQuestDailyBody =>
      'Completa la mezcla sembrada de hoy para alargar tu racha.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      'La diaria de hoy ya está completada. La racha está a salvo por ahora.';

  @override
  String get studyHarmonyQuestFrontierTitle => 'Empuje fronterizo';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return 'Supera $lessonTitle para empujar la ruta hacia delante.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'Ya superaste todas las lecciones desbloqueadas por ahora. Repite un jefe o ve por más estrellas.';

  @override
  String get studyHarmonyQuestStarsTitle => 'caza de estrellas';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return 'Empuja estrellas adicionales dentro de $chapterTitle.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback =>
      'Empuja estrellas adicionales en tu capítulo actual.';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'Combinado x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'Mejor combinación x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'Mantenga todos los corazones';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return 'Alcance $percent% de precisión';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'Alcanza el combo x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'barrido de bonificación';

  @override
  String get studyHarmonySkillNoteRead => 'Lectura de notas';

  @override
  String get studyHarmonySkillNoteFindKeyboard =>
      'Búsqueda de notas del teclado';

  @override
  String get studyHarmonySkillNoteAccidentals => 'Sostenidos y bemoles';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'Símbolo de acorde a teclas';

  @override
  String get studyHarmonySkillChordNameFromTones => 'Nomenclatura de acordes';

  @override
  String get studyHarmonySkillScaleBuild => 'Construcción a escala';

  @override
  String get studyHarmonySkillRomanRealize => 'Realización de número romano';

  @override
  String get studyHarmonySkillRomanIdentify => 'Identificación número romano';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'diatonicidad';

  @override
  String get studyHarmonySkillHarmonyFunction =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonySkillProgressionKeyCenter => 'Progresión centro tonal';

  @override
  String get studyHarmonySkillProgressionFunction =>
      'Lectura de la función de progresión';

  @override
  String get studyHarmonySkillProgressionNonDiatonic =>
      'Detección de progresión no diatónico';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'Relleno de progresión';

  @override
  String get studyHarmonyHubChapterSectionTitle => 'Capítulos';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return 'Lecciones $cleared/$total borradas';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return 'Lecciones $count';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count borrado';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'capitulo abierto';

  @override
  String get studyHarmonyLockedChapterTag => 'Capítulo bloqueado';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return 'Siguiente: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return 'Esta pista todavía está bloqueada. Vuelve a $coreTrack para seguir estudiando hoy.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Ruta base';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Comience con notas y el teclado, luego avance a través de acordes, escalas, conceptos básicos de número romano, diatónico y análisis de progresión breve.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Capítulo 1: Notas y teclado';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Asigne nombres de notas al teclado y siéntase cómodo con las teclas blancas y las alteraciones simples.';

  @override
  String get studyHarmonyChapterChordsTitle =>
      'Capítulo 2: Conceptos básicos de acordes';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Deletrea tríadas y séptimas básicas, luego nombra formas de acordes comunes a partir de sus tonos.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Capítulo 3: Escalas y claves';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Construya escalas mayores y menores, luego determine qué tonos pertenecen dentro de una clave.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Capítulo 4: Números romanos y diatonicidad';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Convierta número romano simples en acordes, identifíquelos a partir de acordes y ordene los conceptos básicos de diatónico por función.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Capítulo 5: Detective de progresión I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      'Lea progresiones básicas breves, encuentre el centro tonal probable y detecte la función de acorde o alguna extraña.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Capítulo 6: Acorde faltante I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      'Llene un espacio en blanco dentro de una breve progresión y aprenda hacia dónde quieren ir la cadencia y la función a continuación.';

  @override
  String get studyHarmonyOpenLessonAction => 'Abrir lección';

  @override
  String get studyHarmonyLockedLessonAction => 'Bloqueado';

  @override
  String get studyHarmonyClearedTag => 'Superada';

  @override
  String get studyHarmonyComingSoonTag => 'Próximamente';

  @override
  String get studyHarmonyPopTrackTitle => 'Ruta pop';

  @override
  String get studyHarmonyPopTrackDescription =>
      'Recorre toda la ruta de armonía en una vía pop con su propio progreso, elección diaria y cola de repaso.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Ruta de jazz';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practica todo el plan de estudios en una vía jazz con progreso, elección diaria y cola de repaso separados.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Ruta clásica';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Estudia todo el plan de estudios en una vía clásica con progreso, elección diaria y cola de repaso independientes.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Práctica rápida';

  @override
  String get studyHarmonyObjectiveBossReview => 'Repaso de jefe';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle =>
      'Búsqueda de notas de tecla blanca';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Lea los nombres de las notas y toque la tecla blanca correspondiente.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Nombra la nota resaltada';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Mire una tecla resaltada y elija el nombre de nota correcto.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle =>
      'Llaves negras y gemelos';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Eche un primer vistazo a la ortografía aguda y plana de las teclas negras.';

  @override
  String get studyHarmonyLessonNotesBossTitle =>
      'Jefe: Búsqueda rápida de notas';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mezcle la lectura de notas y la búsqueda de teclado en una ronda corta y rápida.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Tríadas en el teclado';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Cree tríadas comunes mayores, menores y disminuidas directamente en el teclado.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => 'Séptimas en el teclado';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Agrega la séptima y deletrea algunos acordes de séptima comunes en el teclado.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Nombra el acorde resaltado';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Lea una forma de acorde resaltada y elija el nombre del acorde correcto.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Jefe: Revisión de tríadas y séptimas';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Cambie entre la ortografía y la denominación de acordes en una revisión mixta.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Construir escalas mayores';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Elija cada tono que pertenezca a una escala mayor simple.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Construir escalas menores';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Construya escalas menores naturales y menores armónicas a partir de algunas tonalidades comunes.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Membresía clave';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Encuentre qué tonos pertenecen dentro de una clave con nombre.';

  @override
  String get studyHarmonyLessonScalesBossTitle =>
      'Jefe: Reparación de básculas';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Combine construcción de escala y membresía clave en una breve ronda de reparación.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Romano a acorde';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Lea una clave y número romano, luego elija el acorde correspondiente.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Acorde a romano';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Lea un acorde dentro de una clave y elija el número romano correspondiente.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatónico o no';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Ordene acordes en respuestas diatónico y no diatónico en claves simples.';

  @override
  String get studyHarmonyLessonFunctionTitle =>
      'Conceptos básicos de funciones';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Clasifica los acordes fáciles como tónicos, predominante o dominantes.';

  @override
  String get studyHarmonyLessonRomanBossTitle =>
      'Jefe: Mezcla de conceptos básicos funcionales';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Revise romano a acorde, acorde a romano, diatónicoity y funcionen juntos.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle =>
      'Encuentra el centro clave';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      'Lea una breve progresión y elija el centro tonal que tenga más sentido.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle =>
      'Función en contexto';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      'Concéntrate en un acorde resaltado y nombra su función dentro de una progresión corta.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle =>
      'Encuentra al forastero';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'Localice el único acorde que queda fuera de la lectura principal diatónico.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Jefe: Análisis Mixto';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'Combine lectura del centro de claves, detección de funciones y detección de no diatónico en una breve ronda de detectives.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle =>
      'Completa el acorde que falta';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'Complete una breve progresión de cuatro acordes eligiendo el acorde que mejor se adapte a la función local.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle =>
      'Relleno de cadencia';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'Utilice la atracción hacia una cadencia para elegir el acorde que falta cerca del final de una frase.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Jefe: relleno mixto';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'Resuelva un breve conjunto de preguntas de progresión para completar con un poco más de presión armónica.';

  @override
  String get studyHarmonyChapterCheckpointTitle =>
      'Guantelete de punto de control';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'Combine ejercicios de centro de clave, función, color y relleno en conjuntos de revisión mixtos más rápidos.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle =>
      'Acometida de cadencia';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      'Lea rápidamente la función armónica y luego conecte el acorde cadencial que falta ejerciendo una ligera presión.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle =>
      'Cambio de color y clave';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'Cambie entre detección central y llamadas de color no diatónico sin perder el hilo.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle =>
      'Jefe: Guantelete del punto de control';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'Borre un punto de control integrado que combina indicaciones de reparación de centro de clave, función, color y cadencia.';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'Pruebas finales';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'Termine el camino principal con rondas de progresión mixta más difíciles que requieren velocidad, audición de colores y opciones de resolución limpia.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'Relevo de respuesta';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'Cambie entre lectura de funciones y reparación de acordes faltantes mediante cambios compactos.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle =>
      'Llamadas de colores prestados';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'Capte el color modal rápidamente y luego confirme el centro tonal antes de que desaparezca.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle =>
      'Laboratorio de resolución';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      'Realice un seguimiento de dónde quiere aterrizar cada frase y elija el acorde que mejor resuelva el movimiento.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle =>
      'Jefe: Examen de progresión final';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'Apruebe un examen final mixto con centro, función, color y resolución, todo bajo presión.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Encuentra $note en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      '¿Qué nota está resaltada?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Construya $chord en el teclado';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      '¿Qué acorde está resaltado?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Elige cada nota en $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Elige las notas que pertenecen a $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'En $keyName, ¿qué acorde coincide con $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'En $keyName, ¿qué número romano coincide con $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'En $keyName, ¿$chord es diatónico?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'En $keyName, ¿qué función tiene $chord?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => 'Progresión';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '¿Qué centro tonal se adapta mejor a esta progresión?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '¿Qué función juega $chord aquí?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '¿Qué acorde se siente menos diatónico en esta progresión?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '¿Qué acorde llena mejor el espacio en blanco?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'One likely reading keeps this progression centered on $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can be heard as a $functionLabel chord in this context.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord sits outside the main $keyLabel reading, so it stands out as a plausible non-diatonic color.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord can restore some of the expected $functionLabel pull in this progression.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic menor natural';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic armónico menor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic mayor';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic menor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatónico';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'No diatónico';

  @override
  String get studyHarmonyChoiceTonic => 'Tónico';

  @override
  String get studyHarmonyChoicePredominant => 'Predominante';

  @override
  String get studyHarmonyChoiceDominant => 'Dominante';

  @override
  String get studyHarmonyChoiceOther => 'Otro';

  @override
  String get chordAnalyzerTitle => 'Analizador de acordes';

  @override
  String get chordAnalyzerSubtitle =>
      'Pega una progresión para obtener una lectura conservadora de tonalidades probables, números romanos y función armónica.';

  @override
  String get chordAnalyzerInputLabel => 'Progresión de acordes';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Fuera de paréntesis, puedes separar acordes con espacios, | o comas. Las comas dentro de paréntesis se mantienen dentro del mismo acorde.\n\nUsa ? para un hueco de acorde desconocido. El analizador inferirá la opción más natural según el contexto y mostrará alternativas si la lectura es ambigua.\n\nSe admiten fundamentales en minúscula, bajo con barra, formas sus/alt/add y tensiones como C7(b9, #11).\n\nEn dispositivos táctiles puedes usar el pad de acordes o cambiar a la entrada ABC cuando necesites escribir libremente.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Consejos de entrada';

  @override
  String get chordAnalyzerAnalyze => 'Analizar';

  @override
  String get chordAnalyzerKeyboardTitle => 'Pad de acordes';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Toca los tokens para armar una progresión. La entrada ABC mantiene disponible el teclado del sistema cuando necesitas escribir libremente.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Escribe, pega o toca tokens para insertarlos en la posición del cursor.';

  @override
  String get chordAnalyzerChordPad => 'Panel';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => 'Pegar';

  @override
  String get chordAnalyzerClear => 'Reiniciar';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'Espacio';

  @override
  String get chordAnalyzerAnalyzing => 'Analizando progresión...';

  @override
  String get chordAnalyzerInitialTitle => 'Empieza con una progresión';

  @override
  String get chordAnalyzerInitialBody =>
      'Introduce una progresión como Dm7, G7 | ? Am o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos, avisos, rellenos inferidos y un breve resumen.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'Este ? se infirió del contexto armónico circundante, así que tómalo como un relleno sugerido y no como una certeza.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Relleno sugerido: $chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => 'Tonalidades detectadas';

  @override
  String get chordAnalyzerPrimaryReading => 'Lectura principal';

  @override
  String get chordAnalyzerAlternativeReading => 'Lectura alternativa';

  @override
  String get chordAnalyzerChordAnalysis => 'Análisis acorde por acorde';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return 'Compás $index';
  }

  @override
  String get chordAnalyzerProgressionSummary => 'Resumen de la progresión';

  @override
  String get chordAnalyzerWarnings => 'Advertencias y ambigüedades';

  @override
  String get chordAnalyzerNoInputError =>
      'Introduce una progresión de acordes para analizarla.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      'No se encontraron acordes reconocibles en la progresión.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return 'Se omitieron algunos símbolos: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'El centro tonal sigue siendo algo ambiguo entre $primary y $alternative.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'Algunos acordes siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerFunctionTonic => 'Tónica';

  @override
  String get chordAnalyzerFunctionPredominant => 'Predominante';

  @override
  String get chordAnalyzerFunctionDominant => 'Dominante';

  @override
  String get chordAnalyzerFunctionOther => 'Otro';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return 'Posible dominante secundaria dirigida a $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Posible sustitución por tritono dirigida a $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Posible intercambio modal desde el menor paralelo.';

  @override
  String get chordAnalyzerRemarkAmbiguous =>
      'Este acorde sigue siendo ambiguo en la lectura actual.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'Este acorde sigue sin resolverse con las heurísticas conservadoras actuales.';

  @override
  String get chordAnalyzerTagIiVI => 'cadencia ii-V-I';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => 'resolución dominante';

  @override
  String get chordAnalyzerTagPlagalColor => 'color plagal/modal';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'Esta progresión se centra muy probablemente en $key.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return 'Una lectura alternativa es $key.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'Sugiere un $tag.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from y $through se comportan como acordes de $fromFunction y $throughFunction que conducen hacia $target.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord puede oírse como una posible dominante secundaria que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord puede oírse como un posible sustituto por tritono que apunta hacia $target.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord añade un posible color de intercambio modal.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      'Algunos detalles siguen siendo ambiguos, así que esta lectura se mantiene deliberadamente conservadora.';

  @override
  String get chordAnalyzerExamplesTitle => 'Ejemplos';

  @override
  String get chordAnalyzerConfidenceLabel => 'Confianza';

  @override
  String get chordAnalyzerAmbiguityLabel => 'Ambigüedad';

  @override
  String get chordAnalyzerWhyThisReading => 'Por qué esta lectura';

  @override
  String get chordAnalyzerCompetingReadings => 'También plausible';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return 'Modificadores ignorados: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => 'Crear variaciones';

  @override
  String get chordAnalyzerVariationsTitle => 'Variaciones naturales';

  @override
  String get chordAnalyzerVariationsBody =>
      'Estas opciones reharmonizan el mismo flujo con sustituciones funcionales cercanas. Aplica una para volver a analizarla al instante.';

  @override
  String get chordAnalyzerApplyVariation => 'Usar variación';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Color cadencial';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Oscurece el predominante y cambia el dominante por un sustituto por tritono sin mover la llegada.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Color backdoor';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Usa el color ivm7-bVII7 del menor paralelo antes de caer en la misma tónica.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'ii-V dirigido';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Construye un ii-V relacionado que sigue apuntando al mismo acorde de destino.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle =>
      'Color de cadencia menor';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Mantiene la cadencia menor, pero se inclina hacia el color iiø-Valt-i.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Realce de color';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Mantiene cercanos la raíz y la función, pero eleva los acordes con extensiones naturales.';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return 'Advertencia de entrada: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      'Los paréntesis desequilibrados dejaron parte del símbolo en duda.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'Se ignoró un paréntesis de cierre inesperado.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'El color explícito de $extension refuerza esta lectura.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'El color de dominante alterada respalda una función dominante.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'El bajo con barra $bass mantiene significativo el movimiento del bajo o la inversión.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'El siguiente acorde respalda una resolución hacia $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'Este color puede oírse como prestado del modo paralelo.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'El color de suspensión suaviza la atracción dominante sin borrarla.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Lectura de baja confianza';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'Las tonalidades candidatas están muy próximas o algunos símbolos solo se recuperaron de forma parcial, así que tómalo como una primera lectura cautelosa.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'Este compás está vacío y se conservó en el conteo.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No se recuperaron símbolos de acorde analizables en este compás.';

  @override
  String get chordAnalyzerParseIssuesTitle => 'Problemas de análisis';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => 'Token vacío.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot =>
      'No se pudo reconocer la fundamental.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root no es una grafía de fundamental admitida.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'El bajo con barra $bass no es una grafía de bajo admitida.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Sufijo o modificador no admitido: $suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

  @override
  String get chordAnalyzerQuickStartHint =>
      'Tap an example to see instant results, or press Ctrl+Enter on desktop to analyze.';

  @override
  String get chordAnalyzerDetailLevel => 'Explanation detail';

  @override
  String get chordAnalyzerDetailLevelConcise => 'Concise';

  @override
  String get chordAnalyzerDetailLevelDetailed => 'Detailed';

  @override
  String get chordAnalyzerDetailLevelAdvanced => 'Advanced';

  @override
  String get chordAnalyzerHighlightTheme => 'Highlight theme';

  @override
  String get chordAnalyzerThemePresetDefault => 'Default';

  @override
  String get chordAnalyzerThemePresetHighContrast => 'High contrast';

  @override
  String get chordAnalyzerThemePresetColorBlindSafe => 'Color-blind safe';

  @override
  String get chordAnalyzerThemePresetCustom => 'Custom';

  @override
  String get chordAnalyzerThemeLegend => 'Category legend';

  @override
  String get chordAnalyzerCustomColors => 'Custom category colors';

  @override
  String get chordAnalyzerHighlightAppliedDominant => 'Applied dominant';

  @override
  String get chordAnalyzerHighlightTritoneSubstitute => 'Tritone substitute';

  @override
  String get chordAnalyzerHighlightTonicization => 'Tonicization';

  @override
  String get chordAnalyzerHighlightModulation => 'Modulation';

  @override
  String get chordAnalyzerHighlightBackdoor => 'Backdoor / subdominant minor';

  @override
  String get chordAnalyzerHighlightBorrowedColor => 'Borrowed color';

  @override
  String get chordAnalyzerHighlightCommonTone => 'Common-tone motion';

  @override
  String get chordAnalyzerHighlightDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerHighlightChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerHighlightAmbiguity => 'Ambiguity';

  @override
  String chordAnalyzerSummaryRealModulation(Object key) {
    return 'It makes a stronger case for a real modulation toward $key.';
  }

  @override
  String chordAnalyzerSummaryTonicization(Object target) {
    return 'It briefly tonicizes $target without fully settling there.';
  }

  @override
  String get chordAnalyzerSummaryBackdoor =>
      'The progression leans into backdoor or subdominant-minor color before resolving.';

  @override
  String get chordAnalyzerSummaryDeceptiveCadence =>
      'One cadence sidesteps the expected tonic for a deceptive effect.';

  @override
  String get chordAnalyzerSummaryChromaticLine =>
      'A chromatic inner-line or line-cliche color helps connect part of the phrase.';

  @override
  String chordAnalyzerSummaryBackdoorDominant(Object chord) {
    return '$chord works like a backdoor dominant rather than a plain borrowed dominant.';
  }

  @override
  String chordAnalyzerSummarySubdominantMinor(Object chord) {
    return '$chord reads more naturally as subdominant-minor color than as a random non-diatonic chord.';
  }

  @override
  String chordAnalyzerSummaryCommonToneDiminished(Object chord) {
    return '$chord can be heard as a common-tone diminished color that resolves by shared pitch content.';
  }

  @override
  String chordAnalyzerSummaryDeceptiveTarget(Object chord) {
    return '$chord participates in a deceptive landing instead of a plain authentic cadence.';
  }

  @override
  String chordAnalyzerSummaryCompeting(Object readings) {
    return 'An advanced reading keeps competing interpretations in play, such as $readings.';
  }

  @override
  String chordAnalyzerFunctionLine(Object function) {
    return 'Function: $function';
  }

  @override
  String chordAnalyzerEvidenceLead(Object evidence) {
    return 'Evidence: $evidence';
  }

  @override
  String chordAnalyzerAdvancedCompetingReadings(Object readings) {
    return 'Competing readings remain possible here: $readings.';
  }

  @override
  String chordAnalyzerRemarkTonicization(Object target) {
    return 'This sounds more like a local tonicization of $target than a full modulation.';
  }

  @override
  String chordAnalyzerRemarkRealModulation(Object key) {
    return 'This supports a real modulation toward $key.';
  }

  @override
  String get chordAnalyzerRemarkBackdoorDominant =>
      'This can be heard as a backdoor dominant with subdominant-minor color.';

  @override
  String get chordAnalyzerRemarkBackdoorChain =>
      'This belongs to a backdoor chain rather than a plain borrowed detour.';

  @override
  String get chordAnalyzerRemarkSubdominantMinor =>
      'This borrowed iv or subdominant-minor color behaves like a predominant area.';

  @override
  String get chordAnalyzerRemarkCommonToneDiminished =>
      'This diminished chord works through common-tone reinterpretation.';

  @override
  String get chordAnalyzerRemarkPivotChord =>
      'This chord can act as a pivot into the next local key area.';

  @override
  String get chordAnalyzerRemarkCommonToneModulation =>
      'Common-tone continuity helps the modulation feel plausible.';

  @override
  String get chordAnalyzerRemarkDeceptiveCadence =>
      'This points toward a deceptive cadence rather than a direct tonic arrival.';

  @override
  String get chordAnalyzerRemarkLineCliche =>
      'Chromatic inner-line motion colors this chord choice.';

  @override
  String get chordAnalyzerRemarkDualFunction =>
      'More than one functional reading stays credible here.';

  @override
  String get chordAnalyzerTagTonicization => 'Tonicization';

  @override
  String get chordAnalyzerTagRealModulation => 'Real modulation';

  @override
  String get chordAnalyzerTagBackdoorChain => 'Backdoor chain';

  @override
  String get chordAnalyzerTagDeceptiveCadence => 'Deceptive cadence';

  @override
  String get chordAnalyzerTagChromaticLine => 'Chromatic line color';

  @override
  String get chordAnalyzerTagCommonToneMotion => 'Common-tone motion';

  @override
  String get chordAnalyzerEvidenceCadentialArrival =>
      'A local cadential arrival supports hearing a temporary target.';

  @override
  String get chordAnalyzerEvidenceFollowThrough =>
      'Follow-through chords continue to support the new local center.';

  @override
  String get chordAnalyzerEvidencePhraseBoundary =>
      'The change lands near a phrase boundary or structural accent.';

  @override
  String get chordAnalyzerEvidencePivotSupport =>
      'A pivot-like shared reading supports the local shift.';

  @override
  String get chordAnalyzerEvidenceCommonToneSupport =>
      'Shared common tones help connect the reinterpretation.';

  @override
  String get chordAnalyzerEvidenceHomeGravityWeakening =>
      'The original tonic loses some of its pull in this window.';

  @override
  String get chordAnalyzerEvidenceBackdoorMotion =>
      'The motion matches a backdoor or subdominant-minor resolution pattern.';

  @override
  String get chordAnalyzerEvidenceDeceptiveResolution =>
      'The dominant resolves away from the expected tonic target.';

  @override
  String chordAnalyzerEvidenceChromaticLine(Object detail) {
    return 'Chromatic line support: $detail.';
  }

  @override
  String chordAnalyzerEvidenceCompetingReading(Object detail) {
    return 'Competing reading: $detail.';
  }

  @override
  String get studyHarmonyDailyReplayAction => 'Repetir diariamente';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'Medallas de hito';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'Medalla del Conquistador';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Borrar lecciones $target en Core Foundations.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'Coleccionista de estrellas';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Recoge estrellas $target en Estudio de armonía.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'Leyenda de la racha';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return 'Alcanza la mejor racha diaria de $target.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => 'Académico de maestría';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return 'Domina las habilidades $target.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return 'Medallas $earned/$total obtenidas';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'Gabinete completo';

  @override
  String get studyHarmonyMilestoneTierBronze => 'Medalla de Bronce';

  @override
  String get studyHarmonyMilestoneTierSilver => 'Medalla de Plata';

  @override
  String get studyHarmonyMilestoneTierGold => 'Medalla de oro';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'Medalla de Platino';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => 'Nuevas medallas';

  @override
  String get studyHarmonyChapterRemixTitle => 'Arena remezclada';

  @override
  String get studyHarmonyChapterRemixDescription =>
      'Conjuntos mixtos más largos que mezclan centro tonal, función y color prestado sin previo aviso.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => 'Constructor de puentes';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'La función de puntada lee y rellena los acordes faltantes en una cadena fluida.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'Pivote de color';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      'Realice un seguimiento del color prestado y de los pivotes centrales clave a medida que la progresión cambia debajo de usted.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => 'Sprint de resolución';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      'Lea la función, el relleno de cadencia y la gravedad tonal consecutivamente a un ritmo más rápido.';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'Maratón de remezclas';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      'Un maratón mixto final que devuelve al conjunto todas las lentes de lectura de progresión.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'Salva racha x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'Coronas de leyenda $count';
  }

  @override
  String get studyHarmonyModeFocus => 'Modo de enfoque';

  @override
  String get studyHarmonyModeLegend => 'Prueba de leyenda';

  @override
  String get studyHarmonyFocusCardTitle => 'Sprint de enfoque';

  @override
  String get studyHarmonyFocusCardHint =>
      'Ataca el punto más débil de tu ruta actual con menos vidas y objetivos más exigentes.';

  @override
  String get studyHarmonyFocusFallbackHint =>
      'Completa un mix más exigente para presionar tus puntos débiles actuales.';

  @override
  String get studyHarmonyFocusAction => 'Iniciar sprint';

  @override
  String get studyHarmonyFocusSessionTitle => 'Sprint de enfoque';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return 'Un sprint mixto más ajustado construido desde los puntos más débiles alrededor de $chapter.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count lecciones mixtas';
  }

  @override
  String get studyHarmonyFocusRewardLabel => 'Recompensa semanal: Salva racha';

  @override
  String get studyHarmonyLegendCardTitle => 'Prueba de leyenda';

  @override
  String get studyHarmonyLegendCardHint =>
      'Repite un capítulo de nivel plata o superior en una sesión de dominio con 2 vidas para asegurar su corona de leyenda.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'Completa un capítulo y súbelo a unas 2 estrellas por lección para desbloquear una prueba de leyenda.';

  @override
  String get studyHarmonyLegendAction => 'Ir por la leyenda';

  @override
  String get studyHarmonyLegendSessionTitle => 'Prueba de leyenda';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return 'Una repetición de dominio sin margen en $chapter, pensada para asegurar su corona de leyenda.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count lecciones encadenadas';
  }

  @override
  String get studyHarmonyLegendRiskLabel =>
      'La corona de leyenda está en juego';

  @override
  String get studyHarmonyWeeklyPlanTitle => 'Plan de entrenamiento semanal';

  @override
  String get studyHarmonyWeeklyRewardLabel => 'Recompensa: Salva racha';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => 'Recompensa lista';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => 'Recompensa reclamada';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => 'Aparecer varios días';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return 'Esté activo en $target diferentes días de esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle =>
      'Mantenga vivo el ciclo diario';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return 'El registro $target se borra diariamente esta semana.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle =>
      'Terminar un sprint de concentración';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return 'Completa $target Focus Sprints esta semana.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      'Un Salva racha protegió el día de ayer.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return 'Ganaste un nuevo Salva racha. Inventario: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine =>
      'Sprint de enfoque despejado.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return 'Corona legendaria asegurada para $chapter.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'Escalera bis';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      'Una breve escalera de acabado que comprime todo el conjunto de herramientas de progresión en un conjunto final de bises.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'Pulso tonal';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'Bloquee el centro tonal y funcione sin indicaciones de calentamiento.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'Intercambio de color';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      'Llamadas de colores prestados alternativos con restauración de acordes faltantes para mantener el oído honesto.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'Bis final';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'Una última ronda de jefe compacta que comprueba cada lente de progresión en rápida sucesión.';

  @override
  String get studyHarmonyChapterMasteryBronze => 'Bronce Claro';

  @override
  String get studyHarmonyChapterMasterySilver => 'Corona de plata';

  @override
  String get studyHarmonyChapterMasteryGold => 'corona de oro';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'Corona de leyenda';

  @override
  String get studyHarmonyModeBossRush => 'Modo Boss Rush';

  @override
  String get studyHarmonyBossRushCardTitle => 'Boss Rush';

  @override
  String get studyHarmonyBossRushCardHint =>
      'Encadena las lecciones de jefe desbloqueadas con menos vidas y un umbral de puntuación más alto.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      'Desbloquea al menos dos lecciones de jefe para abrir una Boss Rush mixta de verdad.';

  @override
  String get studyHarmonyBossRushAction => 'Iniciar Boss Rush';

  @override
  String get studyHarmonyBossRushSessionTitle => 'Boss Rush';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return 'Un gauntlet de alta presión construido con las lecciones de jefe desbloqueadas alrededor de $chapter.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count lecciones de jefe mixtas';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => 'Solo 2 vidas';

  @override
  String get studyHarmonyResultBossRushLine => 'Jefe Rush despejado.';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      'Un último conjunto de focos que aísla el color prestado, la presión de la cadencia y la integración a nivel de jefe.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => 'Lente prestada';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      'Realice un seguimiento de centro tonal mientras el color prestado sigue intentando desviar la lectura.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle =>
      'Intercambio de cadencia';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      'Cambia entre lectura de funciones y restauración de cadencia sin perder el punto de aterrizaje.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'Enfrentamiento destacado';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'Un conjunto de jefes finales que obliga a cada lente de progresión a mantenerse nítida bajo presión.';

  @override
  String get studyHarmonyChapterAfterHoursTitle =>
      'Laboratorio fuera de horario';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'Un laboratorio de finales de juego que elimina pistas de calentamiento y mezcla colores prestados, presión de cadencia y seguimiento central.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'Sombra modal';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      'Mantenga presionado el centro tonal mientras el color prestado sigue arrastrando la lectura hacia la oscuridad.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => 'Finta de resolución';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'Capte las falsificaciones de función y cadencia antes de que la frase pase de su verdadero lugar de aterrizaje.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle =>
      'Fundido cruzado central';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      'Combine la detección del centro, la lectura de funciones y la reparación de cuerdas faltantes sin necesidad de andamios adicionales.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'Jefe de última llamada';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'Un último set de jefe nocturno que pide a cada lente de progresión que se mantenga clara bajo presión.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyModeRelay => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardTitle => 'Relevo de arena';

  @override
  String get studyHarmonyRelayCardHint =>
      'Mezcla lecciones desbloqueadas de distintos capítulos en una sola tanda intercalada para poner a prueba tanto el cambio rápido como el recuerdo inmediato.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'Desbloquea al menos dos capítulos para abrir Relevo de arena.';

  @override
  String get studyHarmonyRelayAction => 'Iniciar relevo';

  @override
  String get studyHarmonyRelaySessionTitle => 'Relevo de arena';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return 'Una ejecución de retransmisión entrelazada que mezcla capítulos desbloqueados sobre $chapter.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return 'Lecciones $count transmitidas';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count capítulos mezclados';
  }

  @override
  String get studyHarmonyRelayChainLabel => 'Intercalado bajo presión';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'El relevo gana $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'Corredor de relevos';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return 'Borre las ejecuciones $target Relevo de arena.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'Desvíos de neón';

  @override
  String get studyHarmonyChapterNeonDescription =>
      'Un capítulo del final del juego que sigue cambiando el camino con color prestado, presión de pivote y lecturas de recuperación.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'Desvío modal';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      'Siga el verdadero centro incluso cuando el color prestado sigue empujando la frase a una calle lateral.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'Presión de pivote';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      'Lea los cambios de centro y la presión de función espalda con espalda antes de que el carril armónico cambie nuevamente.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => 'Aterrizaje prestado';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      'Repare la cuerda de aterrizaje que falta después de que una falsificación de color prestado cambie la resolución esperada.';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'Jefe de luces de la ciudad';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'Un jefe de neón final que combina lecturas pivotantes, colores prestados y recuperación de cadencia sin un aterrizaje suave.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return 'Liga $tier';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'Liga de armonía';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return 'Empuja hacia la liga $tier esta semana. El impulso más limpio ahora mismo viene de $mode.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      'Diamante ya está asegurado esta semana. Sigue encadenando superadas de alta presión para mantener el ritmo.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      'Tu ascenso de liga se iluminará una vez que haya una carrera recomendada para impulsar esta semana.';

  @override
  String get studyHarmonyLeagueAction => 'Subir de liga';

  @override
  String get studyHarmonyHubStartHereTitle => 'Start Here';

  @override
  String get studyHarmonyHubNextLessonTitle => 'Next Lesson';

  @override
  String get studyHarmonyHubWhyItMattersTitle => 'Why It Matters';

  @override
  String get studyHarmonyHubQuickPracticeTitle => 'Quick Practice';

  @override
  String get studyHarmonyHubMetaPreviewTitle => 'More Opens Soon';

  @override
  String get studyHarmonyHubMetaPreviewHeadline =>
      'Build a little momentum first';

  @override
  String get studyHarmonyHubMetaPreviewBody =>
      'League, shop, and reward systems open up more fully after a few clears. For now, finish your next lesson and one quick practice run.';

  @override
  String get studyHarmonyHubPlayNowAction => 'Play Now';

  @override
  String get studyHarmonyHubKeepMomentumAction => 'Keep Momentum';

  @override
  String get studyHarmonyClearTitleAction => 'Clear title';

  @override
  String get studyHarmonyPlayerDeckTitle => 'Player Deck';

  @override
  String get studyHarmonyPlayerDeckCardTitle => 'Playstyle';

  @override
  String get studyHarmonyPlayerDeckOverviewAction => 'Overview';

  @override
  String get studyHarmonyRunDirectorTitle => 'Run Director';

  @override
  String get studyHarmonyRunDirectorAction => 'Play Recommended';

  @override
  String get studyHarmonyGameEconomyTitle => 'Game Economy';

  @override
  String get studyHarmonyGameEconomyBody =>
      'Shop stock, utility tokens, and meta items all react to your recent run history.';

  @override
  String studyHarmonyGameEconomyTitlesOwned(int count) {
    return '$count titles owned';
  }

  @override
  String studyHarmonyGameEconomyCosmeticsOwned(int count) {
    return '$count cosmetics owned';
  }

  @override
  String studyHarmonyGameEconomyShopPurchases(int count) {
    return '$count shop purchases';
  }

  @override
  String get studyHarmonyGameEconomyWalletAction => 'View Wallet';

  @override
  String get studyHarmonyArcadeSpotlightTitle => 'Arcade Spotlight';

  @override
  String get studyHarmonyArcadePlayAction => 'Play Arcade';

  @override
  String studyHarmonyArcadeModeCount(int count) {
    return '$count modes';
  }

  @override
  String get studyHarmonyArcadePlaylistAction => 'Play Set';

  @override
  String get studyHarmonyNightMarketTitle => 'Night Market';

  @override
  String studyHarmonyPurchaseSuccess(Object itemTitle) {
    return 'Purchased $itemTitle';
  }

  @override
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle) {
    return 'Purchased and equipped $itemTitle';
  }

  @override
  String studyHarmonyPurchaseFailure(Object itemTitle) {
    return 'Cannot purchase $itemTitle yet';
  }

  @override
  String studyHarmonyRewardEquipped(Object itemTitle) {
    return 'Equipped $itemTitle';
  }

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score XP esta semana';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target XP esta semana';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return 'Siguiente: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return 'Mejor impulso: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'XP de liga +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return 'Ascendido a la liga $tier';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'Novato';

  @override
  String get studyHarmonyLeagueTierBronze => 'Bronce';

  @override
  String get studyHarmonyLeagueTierSilver => 'Plata';

  @override
  String get studyHarmonyLeagueTierGold => 'Oro';

  @override
  String get studyHarmonyLeagueTierDiamond => 'Diamante';

  @override
  String get studyHarmonyChapterMidnightTitle => 'Central de medianoche';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      'Un capítulo final de sala de control que obliga a lecturas rápidas a través de centros a la deriva, cadencias falsas y desvíos prestados.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'Deriva de señal';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      'Siga la verdadera señal tonal incluso mientras la superficie sigue adoptando un color prestado.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => 'Línea engañosa';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      'Lea la presión de la función a través de resoluciones falsas antes de que la línea vuelva a colocarse en su lugar.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => 'Desvío prestado';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      'Recupera el aterrizaje esperado después de que el color prestado desvía la frase a mitad de camino.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'Jefe del apagón';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      'Un conjunto de oscurecimiento final que combina todos los lentes del juego tardío sin brindarte un reinicio seguro.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'Cofres de misiones $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x XP de liga x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'Cofre de misiones';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count misiones restantes';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'Cofre de misiones listo';

  @override
  String get studyHarmonyQuestChestOpenedHeadline =>
      'Cofre de misiones abierto';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x Liga XP en vivo';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return 'Recompensa: +$xp liga XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      'Completa el trío de misiones de hoy para abrir el cofre extra y sostener el ascenso semanal.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      'Las tres misiones de hoy ya están hechas. Supera una partida más para cobrar el bono del cofre.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      'El trío de hoy está completo y la bonificación del cofre ya se ha convertido en XP de liga.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return 'El cofre de hoy ya está abierto y el 2x de XP de liga se aplica a tus próximas $count superadas.';
  }

  @override
  String get studyHarmonyQuestChestAction => 'Terminar trío';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'Mejor remate: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'Misiones diarias $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'Se abrió Cofre de misiones.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'Bonificación Cofre de misiones + XP de liga $count';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '2x de XP de liga listo para tus próximas $count superadas';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'Bono de impulso +$count de XP de liga';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return 'El impulso 2x se borra a la izquierda $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x de XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return 'Tienes 2x de XP de liga durante las próximas $count superadas. Aprovéchalo en $mode mientras dure el impulso.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'Circuito del horizonte';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'Un circuito final del horizonte que obliga a lecturas rápidas y mixtas a través de centros fantasmas, gravedad prestada y casas falsas.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => 'Pulso residual';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'Capte el centro y funcione en la imagen residual antes de que la frase se bloquee en un nuevo carril.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => 'Cambio de gravedad';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      'Maneja la gravedad prestada y repara los acordes faltantes mientras la progresión sigue cambiando su peso.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => 'Falsa llegada';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      'Lea la llegada falsa y reconstruya el aterrizaje real antes de que la progresión se cierre de golpe.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => 'Jefe de la señal final';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'Un último jefe del horizonte que encadena cada lente de progresión del juego tardío en una prueba de señal de cierre.';

  @override
  String get studyHarmonyChapterAfterglowTitle => 'Pista del resplandor';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'Una pista cerrada de decisiones divididas, cebo prestado y centros parpadeantes que recompensa lecturas limpias al final del juego bajo presión.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => 'Decisión dividida';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'Elija el acorde de reparación que mantenga la función en movimiento sin permitir que la frase se desvíe de su curso.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => 'Señuelo prestado';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      'Encuentra el acorde de color prestado que parece un pivote antes de que la progresión regrese a casa.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => 'Parpadeo del centro';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'Mantén el centro tonal mientras las señales de cadencia parpadean y se desvían en rápida sucesión.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle =>
      'Jefe de retorno de línea roja';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'Una prueba final mixta de centro tonal, función, color prestado y reparación de acordes faltantes a toda velocidad.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'Tour mensual autorizado';

  @override
  String get studyHarmonyTourTitle => 'Tour de armonía';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return 'Sellos turísticos $count/$target';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'Listo el final de la gira';

  @override
  String get studyHarmonyTourClaimedHeadline => 'Tour mensual autorizado';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return 'Recompensa: +$xp de XP de liga y $count Salva racha';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return 'Aparece en $target días distintos este mes para asegurar el bono del tour.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return 'Abre $target cofres de misiones este mes para que el cuaderno del tour siga avanzando.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return 'Supera $target retos destacados este mes. Cuentan Boss Rush, Relevo de arena, Sprint de enfoque, Prueba de leyenda y las lecciones de jefe.';
  }

  @override
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

  @override
  String get studyHarmonyTourReadyBody =>
      'Ya reuniste todos los sellos del mes. Una partida más completada asegura el bono del tour.';

  @override
  String get studyHarmonyTourClaimedBody =>
      'La gira de este mes está completa. Mantén el ritmo fuerte para que la ruta del próximo mes empiece caliente.';

  @override
  String get studyHarmonyTourAction => 'recorrido anticipado';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return 'Días activos $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Cofre de misioness $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Focos $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Tour de armonía completo';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'Bono de gira +$count XP de liga';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Reserva de Salva racha $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => 'Frecuencia del amanecer';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'Un bis al amanecer de cadencias fantasmales, giros falsos del amanecer y flores prestadas que obliga a lecturas limpias al final del juego después de una larga carrera.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => 'Cadencia fantasma';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'Repara la cadencia y funciona al mismo tiempo cuando la frase pretende cerrarse sin llegar a aterrizar.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => 'Falso amanecer';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      'Capte el cambio central escondido dentro de un amanecer demasiado temprano antes de que la progresión se aleje nuevamente.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => 'Brote prestado';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      'Realice un seguimiento del color prestado y funcionen juntos mientras la armonía se abre hacia un carril más brillante pero inestable.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle =>
      'Jefe de sobremarcha del amanecer';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'Un jefe final a la velocidad del amanecer que encadena centro tonal, función, color no diatónico y reparación de acordes faltantes en un último conjunto de sobremarcha.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'Pacto a dúo';

  @override
  String get studyHarmonyDuetStartHeadline => 'Empieza el dueto de hoy.';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return 'Dueto bloqueado por el día $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return 'Recompensa: +$xp de XP de liga en rachas clave';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'Primero completa la diaria de hoy y luego supera un reto destacado para mantener vivo el pacto a dúo.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Lo diario está de moda. Termina una carrera destacada como Focus, Relay, Boss Rush, Legend o una lección de jefe para sellar el dúo.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return 'El dúo de hoy ya quedó sellado y la racha compartida va en $count días.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Diariamente en';

  @override
  String get studyHarmonyDuetDailyMissing => 'Falta diaria';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Foco en';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Falta foco';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return 'Diario $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'Foco $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'Racha $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'Sigue el dueto';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'Racha de dueto $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'Recompensa de dúo +$count XP de liga';
  }

  @override
  String get studyHarmonySolfegeDo => 'Do';

  @override
  String get studyHarmonySolfegeRe => 'Re';

  @override
  String get studyHarmonySolfegeMi => 'Mi';

  @override
  String get studyHarmonySolfegeFa => 'Fa';

  @override
  String get studyHarmonySolfegeSol => 'Sol';

  @override
  String get studyHarmonySolfegeLa => 'La';

  @override
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle =>
      'Prototipo de Estudio de armonía';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Niveles heredados del prototipo integrados en el sistema de lecciones.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Lecciones prototipo';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Lecciones temporales conservadas mientras se incorpora el sistema de estudio ampliable.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Supera 10 respuestas correctas antes de perder las 3 vidas';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Nivel prototipo 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'Un calentamiento básico para distinguir solo Do, Mi y Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Nivel prototipo 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'Un nivel intermedio para acelerar el reconocimiento de Do, Re, Mi, Sol y La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Nivel prototipo 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'Una prueba de octava completa que recorre toda la serie Do-Re-Mi-Fa-Sol-La-Si-Do.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (C grave)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (C agudo)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Plantilla';

  @override
  String get studyHarmonyChapterBlueHourTitle => 'Cruce de la hora azul';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      'Un bis crepuscular de corrientes cruzadas, préstamos con halo y horizontes duales que mantienen inestables las lecturas tardías del juego de la mejor manera.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => 'Corriente cruzada';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'Siga centro tonal y funcione mientras la progresión comienza a moverse en dos direcciones a la vez.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => 'Halo prestado';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      'Lea el color prestado y restablezca el acorde que falta antes de que la frase se vuelva confusa.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => 'Horizonte doble';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      'Mantenga el punto de llegada real mientras dos posibles horizontes siguen apareciendo y desapareciendo.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'Jefe de linternas gemelas';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'Un jefe final de hora azul que obliga a cambios rápidos entre el centro, la función, el color prestado y la reparación de acordes faltantes.';

  @override
  String get anchorLoopTitle => 'Anchor Loop';

  @override
  String get anchorLoopHelp =>
      'Fix specific cycle slots so the same chord returns every cycle while the other slots can still be generated around it.';

  @override
  String get anchorLoopCycleLength => 'Cycle Length (bars)';

  @override
  String get anchorLoopCycleLengthHelp =>
      'Choose how many bars the repeating anchor cycle lasts.';

  @override
  String get anchorLoopVaryNonAnchorSlots => 'Vary non-anchor slots';

  @override
  String get anchorLoopVaryNonAnchorSlotsHelp =>
      'Keep anchor slots exact while letting the generated filler vary inside the same local function.';

  @override
  String anchorLoopBarLabel(int bar) {
    return 'Bar $bar';
  }

  @override
  String anchorLoopBeatLabel(int beat) {
    return 'Beat $beat';
  }

  @override
  String get anchorLoopSlotEmpty => 'No anchor chord set';

  @override
  String anchorLoopEditTitle(int bar, int beat) {
    return 'Edit anchor for bar $bar, beat $beat';
  }

  @override
  String get anchorLoopChordSymbol => 'Anchor chord symbol';

  @override
  String get anchorLoopChordHint =>
      'Enter one chord symbol for this slot. Leave it empty to clear the anchor.';

  @override
  String get anchorLoopInvalidChord =>
      'Enter a supported chord symbol before saving this anchor slot.';

  @override
  String get harmonyPlaybackPatternBlock => 'Block';

  @override
  String get harmonyPlaybackPatternArpeggio => 'Arpeggio';

  @override
  String get metronomeBeatStateNormal => 'Normal';

  @override
  String get metronomeBeatStateAccent => 'Accent';

  @override
  String get metronomeBeatStateMute => 'Mute';

  @override
  String get metronomePatternPresetCustom => 'Custom';

  @override
  String get metronomePatternPresetMeterAccent => 'Meter accent';

  @override
  String get metronomePatternPresetJazzTwoAndFour => 'Jazz 2 & 4';

  @override
  String get metronomeSourceKindBuiltIn => 'Built-in asset';

  @override
  String get metronomeSourceKindLocalFile => 'Local file';

  @override
  String get transportAudioTitle => 'Transport Audio';

  @override
  String get autoPlayChordChanges => 'Auto-play chord changes';

  @override
  String get autoPlayChordChangesHelp =>
      'Play the next chord automatically when the transport reaches a chord-change event.';

  @override
  String get autoPlayPattern => 'Auto-play pattern';

  @override
  String get autoPlayPatternHelp =>
      'Choose whether auto-play uses a block chord or a short arpeggio.';

  @override
  String get autoPlayHoldFactor => 'Auto-play hold length';

  @override
  String get autoPlayHoldFactorHelp =>
      'Scale how long auto-played chord changes ring relative to the event duration.';

  @override
  String get autoPlayMelodyWithChords => 'Play melody with chords';

  @override
  String get autoPlayMelodyWithChordsPlaceholder =>
      'When melody generation is enabled, include the current melody line in auto-play chord-change previews.';

  @override
  String get melodyGenerationTitle => 'Melody line';

  @override
  String get melodyGenerationHelp =>
      'Generate a simple performance-ready melody that follows the current chord timeline.';

  @override
  String get melodyDensity => 'Melody density';

  @override
  String get melodyDensityHelp =>
      'Choose how many melody notes tend to appear inside each chord event.';

  @override
  String get melodyDensitySparse => 'Sparse';

  @override
  String get melodyDensityBalanced => 'Balanced';

  @override
  String get melodyDensityActive => 'Active';

  @override
  String get motifRepetitionStrength => 'Motif repetition';

  @override
  String get motifRepetitionStrengthHelp =>
      'Higher values keep the contour identity of recent melody fragments more often.';

  @override
  String get approachToneDensity => 'Approach tone density';

  @override
  String get approachToneDensityHelp =>
      'Control how often passing, neighbor, and approach gestures appear before arrivals.';

  @override
  String get melodyRangeLow => 'Melody range low';

  @override
  String get melodyRangeHigh => 'Melody range high';

  @override
  String get melodyRangeHelp =>
      'Keep generated melody notes inside this playable register window.';

  @override
  String get melodyStyle => 'Melody style';

  @override
  String get melodyStyleHelp =>
      'Bias the line toward safer guide tones, bebop motion, lyrical space, or colorful tensions.';

  @override
  String get melodyStyleSafe => 'Safe';

  @override
  String get melodyStyleBebop => 'Bebop';

  @override
  String get melodyStyleLyrical => 'Lyrical';

  @override
  String get melodyStyleColorful => 'Colorful';

  @override
  String get allowChromaticApproaches => 'Allow chromatic approaches';

  @override
  String get allowChromaticApproachesHelp =>
      'Permit enclosures and chromatic approach notes on weak beats when the style allows it.';

  @override
  String get melodyPlaybackMode => 'Melody playback';

  @override
  String get melodyPlaybackModeHelp =>
      'Choose whether manual preview buttons play chords, melody, or both together.';

  @override
  String get melodyPlaybackModeChordsOnly => 'Chords only';

  @override
  String get melodyPlaybackModeMelodyOnly => 'Melody only';

  @override
  String get melodyPlaybackModeBoth => 'Both';

  @override
  String get regenerateMelody => 'Regenerate melody';

  @override
  String get melodyPreviewCurrent => 'Current line';

  @override
  String get melodyPreviewNext => 'Next arrival';

  @override
  String get metronomePatternTitle => 'Metronome Pattern';

  @override
  String get metronomePatternHelp =>
      'Choose a meter-aware click pattern or define each beat manually.';

  @override
  String get metronomeUseAccentSound => 'Use separate accent sound';

  @override
  String get metronomeUseAccentSoundHelp =>
      'Use a different click source for accented beats instead of only raising the gain.';

  @override
  String get metronomePrimarySource => 'Primary click source';

  @override
  String get metronomeAccentSource => 'Accent click source';

  @override
  String get metronomeSourceKind => 'Source type';

  @override
  String get metronomeLocalFilePath => 'Local file path';

  @override
  String get metronomeLocalFilePathHelp =>
      'Paste a local audio file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter, or upload a file below. Built-in sound remains the fallback.';

  @override
  String get metronomeCustomSoundHelp =>
      'Upload your own metronome click. The app stores a private copy and keeps the built-in sound as fallback.';

  @override
  String get metronomeCustomSoundStatusBuiltIn =>
      'Currently using a built-in sound.';

  @override
  String metronomeCustomSoundStatusFile(Object fileName) {
    return 'Custom file: $fileName';
  }

  @override
  String get metronomeCustomSoundUpload => 'Upload custom sound';

  @override
  String get metronomeCustomSoundReplace => 'Replace custom sound';

  @override
  String get metronomeCustomSoundReset => 'Use built-in sound';

  @override
  String get metronomeCustomSoundUploadSuccess =>
      'Custom metronome sound saved.';

  @override
  String get metronomeCustomSoundResetSuccess =>
      'Switched back to the built-in metronome sound.';

  @override
  String get metronomeCustomSoundUploadError =>
      'Couldn\'t save the selected metronome audio file.';

  @override
  String get harmonySoundTitle => 'Harmony Sound';

  @override
  String get harmonyMasterVolume => 'Master volume';

  @override
  String get harmonyMasterVolumeHelp =>
      'Overall harmony preview loudness for manual and automatic chord playback.';

  @override
  String get harmonyPreviewHoldFactor => 'Chord hold length';

  @override
  String get harmonyPreviewHoldFactorHelp =>
      'Scale how long previewed chords and notes sustain.';

  @override
  String get harmonyArpeggioStepSpeed => 'Arpeggio step speed';

  @override
  String get harmonyArpeggioStepSpeedHelp =>
      'Control how quickly arpeggiated notes step forward.';

  @override
  String get harmonyVelocityHumanization => 'Velocity humanization';

  @override
  String get harmonyVelocityHumanizationHelp =>
      'Add small velocity variation so repeated previews feel less mechanical.';

  @override
  String get harmonyGainRandomness => 'Gain randomness';

  @override
  String get harmonyGainRandomnessHelp =>
      'Add slight per-note loudness variation on supported playback paths.';

  @override
  String get harmonyTimingHumanization => 'Timing humanization';

  @override
  String get harmonyTimingHumanizationHelp =>
      'Slightly loosen simultaneous note attacks for a less rigid block chord.';

  @override
  String get harmonySoundProfileSelectionTitle => 'Sound profile mode';

  @override
  String get harmonySoundProfileSelectionHelp =>
      'Elige un sonido equilibrado por defecto o fija un carácter de reproducción para practicar pop, jazz o clásico.';

  @override
  String get harmonySoundProfileSelectionNeutral => 'Neutral shared piano';

  @override
  String get harmonySoundProfileSelectionTrackAware => 'Track-aware';

  @override
  String get harmonySoundProfileSelectionPop => 'Pop profile';

  @override
  String get harmonySoundProfileSelectionJazz => 'Jazz profile';

  @override
  String get harmonySoundProfileSelectionClassical => 'Classical profile';

  @override
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern) {
    return 'Instrument: $instrument. Recommended preview: $pattern.';
  }

  @override
  String get harmonySoundProfileTrackAwareFallback =>
      'In free practice this stays on the shared piano profile. Study Harmony sessions switch to the active track\'s sound shaping.';

  @override
  String get harmonySoundProfileNeutralLabel => 'Balanced / shared piano';

  @override
  String get harmonySoundProfileNeutralSummary =>
      'Use the shared piano asset with a steady, all-purpose preview shape.';

  @override
  String get harmonySoundTagBalanced => 'balanced';

  @override
  String get harmonySoundTagPiano => 'piano';

  @override
  String get harmonySoundTagSoft => 'soft';

  @override
  String get harmonySoundTagOpen => 'open';

  @override
  String get harmonySoundTagModern => 'modern';

  @override
  String get harmonySoundTagDry => 'dry';

  @override
  String get harmonySoundTagWarm => 'warm';

  @override
  String get harmonySoundTagEpReady => 'EP-ready';

  @override
  String get harmonySoundTagClear => 'clear';

  @override
  String get harmonySoundTagAcoustic => 'acoustic';

  @override
  String get harmonySoundTagFocused => 'focused';

  @override
  String get harmonySoundNeutralTrait1 =>
      'Steady hold for general harmonic checking';

  @override
  String get harmonySoundNeutralTrait2 => 'Balanced attack with low coloration';

  @override
  String get harmonySoundNeutralTrait3 =>
      'Safe fallback for any lesson or free-play context';

  @override
  String get harmonySoundNeutralExpansion1 =>
      'Future split by piano register or room size';

  @override
  String get harmonySoundNeutralExpansion2 =>
      'Possible alternate shared instrument set for headphones';

  @override
  String get harmonySoundPopTrait1 =>
      'Longer sustain for open hooks and add9 color';

  @override
  String get harmonySoundPopTrait2 =>
      'Softer attack with a little width in repeated previews';

  @override
  String get harmonySoundPopTrait3 =>
      'Gentle humanization so loops feel less grid-locked';

  @override
  String get harmonySoundPopExpansion1 =>
      'Bright pop keys or layered piano-synth asset';

  @override
  String get harmonySoundPopExpansion2 =>
      'Wider stereo voicing playback for chorus lift';

  @override
  String get harmonySoundJazzTrait1 =>
      'Shorter hold to keep cadence motion readable';

  @override
  String get harmonySoundJazzTrait2 =>
      'Faster broken-preview feel for guide-tone hearing';

  @override
  String get harmonySoundJazzTrait3 =>
      'More touch variation to suggest shell and rootless comping';

  @override
  String get harmonySoundJazzExpansion1 =>
      'Dry upright or mellow electric-piano instrument family';

  @override
  String get harmonySoundJazzExpansion2 =>
      'Track-aware comping presets for shell and rootless drills';

  @override
  String get harmonySoundClassicalTrait1 =>
      'Centered sustain for function and cadence clarity';

  @override
  String get harmonySoundClassicalTrait2 =>
      'Low randomness to keep voice-leading stable';

  @override
  String get harmonySoundClassicalTrait3 =>
      'More direct block playback for harmonic arrival';

  @override
  String get harmonySoundClassicalExpansion1 =>
      'Direct acoustic piano profile with less ambient spread';

  @override
  String get harmonySoundClassicalExpansion2 =>
      'Dedicated cadence and sequence preview voicings';

  @override
  String get explanationSectionTitle => 'Why this works';

  @override
  String get explanationReasonSection => 'Why this result';

  @override
  String get explanationConfidenceHigh => 'High confidence';

  @override
  String get explanationConfidenceMedium => 'Plausible reading';

  @override
  String get explanationConfidenceLow => 'Treat as a tentative reading';

  @override
  String get explanationAmbiguityLow =>
      'Most of the progression points in one direction, but a light alternate reading is still possible.';

  @override
  String get explanationAmbiguityMedium =>
      'More than one plausible reading is still in play, so context matters here.';

  @override
  String get explanationAmbiguityHigh =>
      'Several readings are competing, so treat this as a cautious, context-dependent explanation.';

  @override
  String get explanationCautionParser =>
      'Some chord symbols were normalized before analysis.';

  @override
  String get explanationCautionAmbiguous =>
      'There is more than one reasonable reading here.';

  @override
  String get explanationCautionAlternateKey =>
      'A nearby key center also fits part of this progression.';

  @override
  String get explanationAlternativeSection => 'Other readings';

  @override
  String explanationAlternativeKeyLabel(Object keyLabel) {
    return 'Alternate key: $keyLabel';
  }

  @override
  String get explanationAlternativeKeyBody =>
      'The harmonic pull is still valid, but another key center also explains some of the same chords.';

  @override
  String explanationAlternativeReadingLabel(Object romanNumeral) {
    return 'Alternate reading: $romanNumeral';
  }

  @override
  String get explanationAlternativeReadingBody =>
      'This is another possible interpretation rather than a single definitive label.';

  @override
  String get explanationListeningSection => 'Listening focus';

  @override
  String get explanationListeningGuideToneTitle => 'Follow the 3rds and 7ths';

  @override
  String get explanationListeningGuideToneBody =>
      'Listen for the smallest inner-line motion as the cadence resolves.';

  @override
  String get explanationListeningDominantColorTitle =>
      'Listen for the dominant color';

  @override
  String get explanationListeningDominantColorBody =>
      'Notice how the tension on the dominant wants to release, even before the final arrival lands.';

  @override
  String get explanationListeningBackdoorTitle =>
      'Hear the softer backdoor pull';

  @override
  String get explanationListeningBackdoorBody =>
      'Listen for the subdominant-minor color leading home by color and voice leading rather than a plain V-I push.';

  @override
  String get explanationListeningBorrowedColorTitle => 'Hear the color shift';

  @override
  String get explanationListeningBorrowedColorBody =>
      'Notice how the borrowed chord darkens or brightens the loop before it returns home.';

  @override
  String get explanationListeningBassMotionTitle => 'Follow the bass motion';

  @override
  String get explanationListeningBassMotionBody =>
      'Track how the bass note reshapes momentum, even when the upper harmony stays closely related.';

  @override
  String get explanationListeningCadenceTitle => 'Hear the arrival';

  @override
  String get explanationListeningCadenceBody =>
      'Pay attention to which chord feels like the point of rest and how the approach prepares it.';

  @override
  String get explanationListeningAmbiguityTitle =>
      'Compare the competing readings';

  @override
  String get explanationListeningAmbiguityBody =>
      'Try hearing the same chord once for its local pull and once for its larger key-center role.';

  @override
  String get explanationPerformanceSection => 'Performance focus';

  @override
  String get explanationPerformancePopTitle => 'Keep the hook singable';

  @override
  String get explanationPerformancePopBody =>
      'Favor clear top notes, repeated contour, and open voicings that support the vocal line.';

  @override
  String get explanationPerformanceJazzTitle => 'Target guide tones first';

  @override
  String get explanationPerformanceJazzBody =>
      'Outline the 3rd and 7th before adding extra tensions or reharm color.';

  @override
  String get explanationPerformanceJazzShellTitle => 'Start with shell tones';

  @override
  String get explanationPerformanceJazzShellBody =>
      'Place the root, 3rd, and 7th cleanly first so the cadence stays easy to hear.';

  @override
  String get explanationPerformanceJazzRootlessTitle =>
      'Let the 3rd and 7th carry the shape';

  @override
  String get explanationPerformanceJazzRootlessBody =>
      'Keep the guide tones stable, then add 9 or 13 only if the line still resolves clearly.';

  @override
  String get explanationPerformanceClassicalTitle =>
      'Keep the voices disciplined';

  @override
  String get explanationPerformanceClassicalBody =>
      'Prioritize stable spacing, functional arrivals, and stepwise motion where possible.';

  @override
  String get explanationPerformanceDominantColorTitle =>
      'Add tension after the target is clear';

  @override
  String get explanationPerformanceDominantColorBody =>
      'Land the guide tones first, then treat 9, 13, or altered color as decoration rather than the main signal.';

  @override
  String get explanationPerformanceAmbiguityTitle =>
      'Anchor the most stable tones';

  @override
  String get explanationPerformanceAmbiguityBody =>
      'If the reading is ambiguous, emphasize the likely resolution tones before leaning into the more colorful option.';

  @override
  String get explanationPerformanceVoicingTitle => 'Voicing cue';

  @override
  String get explanationPerformanceMelodyTitle => 'Melody cue';

  @override
  String get explanationPerformanceMelodyBody =>
      'Lean on the structural target notes, then let passing tones fill the space around them.';

  @override
  String get explanationReasonFunctionalResolutionLabel => 'Functional pull';

  @override
  String get explanationReasonFunctionalResolutionBody =>
      'The chords line up as tonic, predominant, and dominant functions rather than isolated sonorities.';

  @override
  String get explanationReasonGuideToneSmoothnessLabel => 'Guide-tone motion';

  @override
  String get explanationReasonGuideToneSmoothnessBody =>
      'The inner voices move efficiently, which strengthens the sense of direction.';

  @override
  String get explanationReasonBorrowedColorLabel => 'Borrowed color';

  @override
  String get explanationReasonBorrowedColorBody =>
      'A parallel-mode borrowing adds contrast without fully leaving the home key.';

  @override
  String get explanationReasonSecondaryDominantLabel =>
      'Secondary dominant pull';

  @override
  String get explanationReasonSecondaryDominantBody =>
      'This dominant points strongly toward a local target chord instead of only the tonic.';

  @override
  String get explanationReasonTritoneSubLabel => 'Tritone-sub color';

  @override
  String get explanationReasonTritoneSubBody =>
      'The dominant color is preserved while the bass motion shifts to a substitute route.';

  @override
  String get explanationReasonDominantColorLabel => 'Dominant tension';

  @override
  String get explanationReasonDominantColorBody =>
      'Altered or extended dominant color strengthens the pull toward the next chord without changing the whole key reading.';

  @override
  String get explanationReasonBackdoorMotionLabel => 'Backdoor motion';

  @override
  String get explanationReasonBackdoorMotionBody =>
      'This reading leans on subdominant-minor or backdoor motion, so the resolution feels softer but still directed.';

  @override
  String get explanationReasonCadentialStrengthLabel => 'Cadential shape';

  @override
  String get explanationReasonCadentialStrengthBody =>
      'The phrase ends with a stronger arrival than a neutral loop continuation.';

  @override
  String get explanationReasonVoiceLeadingStabilityLabel =>
      'Stable voice leading';

  @override
  String get explanationReasonVoiceLeadingStabilityBody =>
      'The selected voicing keeps common tones or resolves tendency tones cleanly.';

  @override
  String get explanationReasonSingableContourLabel => 'Singable contour';

  @override
  String get explanationReasonSingableContourBody =>
      'The line favors memorable motion over angular, highly technical shapes.';

  @override
  String get explanationReasonSlashBassLiftLabel => 'Bass-motion lift';

  @override
  String get explanationReasonSlashBassLiftBody =>
      'The bass note changes the momentum even when the harmony stays closely related.';

  @override
  String get explanationReasonTurnaroundGravityLabel => 'Turnaround gravity';

  @override
  String get explanationReasonTurnaroundGravityBody =>
      'This pattern creates forward pull by cycling through familiar jazz resolution points.';

  @override
  String get explanationReasonInversionDisciplineLabel => 'Inversion control';

  @override
  String get explanationReasonInversionDisciplineBody =>
      'The inversion choice supports smoother outer-voice motion and clearer cadence behavior.';

  @override
  String get explanationReasonAmbiguityWindowLabel => 'Competing readings';

  @override
  String get explanationReasonAmbiguityWindowBody =>
      'Some of the same notes support more than one harmonic role, so context decides which reading feels stronger.';

  @override
  String get explanationReasonChromaticLineLabel => 'Chromatic line';

  @override
  String get explanationReasonChromaticLineBody =>
      'A chromatic bass or inner-line connection helps explain why this chord fits despite the extra color.';

  @override
  String get explanationTrackContextPop =>
      'In a pop context, this reading leans toward loop gravity, color contrast, and a singable top line.';

  @override
  String get explanationTrackContextJazz =>
      'In a jazz context, this is one plausible reading that highlights guide tones, cadence pull, and usable dominant color.';

  @override
  String get explanationTrackContextClassical =>
      'In a classical context, this reading leans toward function, inversion awareness, and cadence strength.';

  @override
  String get studyHarmonyTrackFocusSectionTitle => 'This track emphasizes';

  @override
  String get studyHarmonyTrackLessFocusSectionTitle =>
      'This track treats more lightly';

  @override
  String get studyHarmonyTrackRecommendedForSectionTitle => 'Recommended for';

  @override
  String get studyHarmonyTrackSoundSectionTitle => 'Sound profile';

  @override
  String get studyHarmonyTrackSoundAssetPlaceholder =>
      'Current release uses the shared piano asset. This profile prepares future track-specific sound choices.';

  @override
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument) {
    return 'Current instrument: $instrument';
  }

  @override
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern) {
    return 'Recommended preview pattern: $pattern';
  }

  @override
  String get studyHarmonyTrackSoundPlaybackTraitsTitle => 'Playback character';

  @override
  String get studyHarmonyTrackSoundExpansionTitle => 'Expansion path';

  @override
  String get studyHarmonyTrackPopFocus1 =>
      'Diatonic loop gravity and hook-friendly repetition';

  @override
  String get studyHarmonyTrackPopFocus2 =>
      'Borrowed-color lifts such as iv, bVII, or IVMaj7';

  @override
  String get studyHarmonyTrackPopFocus3 =>
      'Slash-bass and pedal-bass motion that supports pre-chorus lift';

  @override
  String get studyHarmonyTrackPopLess1 =>
      'Dense jazz reharmonization and advanced substitute dominants';

  @override
  String get studyHarmonyTrackPopLess2 =>
      'Rootless voicing systems and heavy altered-dominant language';

  @override
  String get studyHarmonyTrackPopRecommendedFor =>
      'Writers, producers, and players who want modern pop or ballad harmony that sounds usable quickly.';

  @override
  String get studyHarmonyTrackPopTheoryTone =>
      'Practical, song-first, and color-aware without overloading the learner with jargon.';

  @override
  String get studyHarmonyTrackPopHeroHeadline => 'Build hook-friendly loops';

  @override
  String get studyHarmonyTrackPopHeroBody =>
      'This track teaches loop gravity, restrained borrowed color, and bass movement that lifts a section without losing clarity.';

  @override
  String get studyHarmonyTrackPopQuickPracticeCue =>
      'Start with the signature loop chapter, then listen for how the bass and borrowed color reshape the same hook.';

  @override
  String get studyHarmonyTrackPopSoundLabel => 'Soft / open / modern';

  @override
  String get studyHarmonyTrackPopSoundSummary =>
      'Balanced piano now, with future room for brighter pop keys and wider stereo voicings.';

  @override
  String get studyHarmonyTrackJazzFocus1 =>
      'Guide-tone hearing and shell-to-rootless voicing growth';

  @override
  String get studyHarmonyTrackJazzFocus2 =>
      'Major ii-V-I, minor iiø-V-i y comportamiento del turnaround';

  @override
  String get studyHarmonyTrackJazzFocus3 =>
      'Dominant color, tensions, tritone sub, and backdoor entry points';

  @override
  String get studyHarmonyTrackJazzLess1 =>
      'Purely song-loop repetition without cadence awareness';

  @override
  String get studyHarmonyTrackJazzLess2 =>
      'Classical inversion literacy as a primary objective';

  @override
  String get studyHarmonyTrackJazzRecommendedFor =>
      'Players who want to hear and use functional jazz harmony without jumping straight into maximal reharm complexity.';

  @override
  String get studyHarmonyTrackJazzTheoryTone =>
      'Contextual, confidence-aware, and careful about calling one reading the only correct jazz answer.';

  @override
  String get studyHarmonyTrackJazzHeroHeadline =>
      'Hear the line inside the chords';

  @override
  String get studyHarmonyTrackJazzHeroBody =>
      'This track turns jazz harmony into manageable steps: guide tones first, then cadence families, then tasteful dominant color.';

  @override
  String get studyHarmonyTrackJazzQuickPracticeCue =>
      'Start with guide tones and shell voicings, then revisit the same cadence with rootless color.';

  @override
  String get studyHarmonyTrackJazzSoundLabel => 'Dry / warm / EP-ready';

  @override
  String get studyHarmonyTrackJazzSoundSummary =>
      'Shared piano for now, with placeholders for drier attacks and future electric-piano friendly playback.';

  @override
  String get studyHarmonyTrackClassicalFocus1 =>
      'Tonic / predominant / dominant function and cadence types';

  @override
  String get studyHarmonyTrackClassicalFocus2 =>
      'Inversion literacy, including first inversion and cadential 6/4 behavior';

  @override
  String get studyHarmonyTrackClassicalFocus3 =>
      'Voice-leading stability, sequence, and functional modulation basics';

  @override
  String get studyHarmonyTrackClassicalLess1 =>
      'Heavy tension stacking, quartal color, and upper-structure thinking';

  @override
  String get studyHarmonyTrackClassicalLess2 =>
      'Loop-driven pop repetition as the main learning frame';

  @override
  String get studyHarmonyTrackClassicalRecommendedFor =>
      'Learners who want clear functional hearing, inversion awareness, and disciplined voice leading.';

  @override
  String get studyHarmonyTrackClassicalTheoryTone =>
      'Structured, function-first, and phrased in a way that supports listening as well as label recognition.';

  @override
  String get studyHarmonyTrackClassicalHeroHeadline =>
      'Hear function and cadence clearly';

  @override
  String get studyHarmonyTrackClassicalHeroBody =>
      'This track emphasizes functional arrival, inversion control, and phrase endings that feel architecturally clear.';

  @override
  String get studyHarmonyTrackClassicalQuickPracticeCue =>
      'Start with cadence lab drills, then compare how inversions change the same function.';

  @override
  String get studyHarmonyTrackClassicalSoundLabel =>
      'Clear / acoustic / focused';

  @override
  String get studyHarmonyTrackClassicalSoundSummary =>
      'Shared piano for now, with room for a more direct acoustic profile in later releases.';

  @override
  String get studyHarmonyPopChapterSignatureLoopsTitle => 'Signature Pop Loops';

  @override
  String get studyHarmonyPopChapterSignatureLoopsDescription =>
      'Build practical pop instincts with hook gravity, borrowed lift, and bass motion that feels arrangement-ready.';

  @override
  String get studyHarmonyPopLessonHookGravityTitle => 'Hook Gravity';

  @override
  String get studyHarmonyPopLessonHookGravityDescription =>
      'Hear why modern four-chord loops stay catchy even when the harmony is simple.';

  @override
  String get studyHarmonyPopLessonBorrowedLiftTitle => 'Borrowed Lift';

  @override
  String get studyHarmonyPopLessonBorrowedLiftDescription =>
      'Experience restrained borrowed-color chords that brighten or darken a section without derailing the hook.';

  @override
  String get studyHarmonyPopLessonBassMotionTitle => 'Bass Motion';

  @override
  String get studyHarmonyPopLessonBassMotionDescription =>
      'Use slash-bass and line motion to create lift while the upper harmony stays familiar.';

  @override
  String get studyHarmonyPopLessonBossTitle => 'Pre-Chorus Lift Checkpoint';

  @override
  String get studyHarmonyPopLessonBossDescription =>
      'Combine loop gravity, borrowed color, and bass motion in one song-ready pop slice.';

  @override
  String get studyHarmonyJazzChapterGuideToneLabTitle => 'Guide-Tone Lab';

  @override
  String get studyHarmonyJazzChapterGuideToneLabDescription =>
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Reconoce cómo se siente el movimiento minor iiø-V-i y por qué allí el dominante suena más urgente.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceTitle =>
      'Tritone and Backdoor';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceDescription =>
      'Compare substitute-dominant and backdoor arrivals as plausible jazz routes into the same tonic.';

  @override
  String get studyHarmonyJazzLessonBossTitle => 'Turnaround Checkpoint';

  @override
  String get studyHarmonyJazzLessonBossDescription =>
      'Combina major ii-V-I, minor iiø-V-i, color rootless y reharm cuidadoso sin perder la claridad del punto de llegada de la cadencia.';

  @override
  String get studyHarmonyClassicalChapterCadenceLabTitle => 'Cadence Lab';

  @override
  String get studyHarmonyClassicalChapterCadenceLabDescription =>
      'Strengthen functional hearing with cadences, inversions, and carefully controlled secondary dominants.';

  @override
  String get studyHarmonyClassicalLessonCadenceTitle => 'Cadence Function';

  @override
  String get studyHarmonyClassicalLessonCadenceDescription =>
      'Sort tonic, predominant, and dominant behavior by how each chord prepares or completes the phrase.';

  @override
  String get studyHarmonyClassicalLessonInversionTitle => 'Inversion Control';

  @override
  String get studyHarmonyClassicalLessonInversionDescription =>
      'Hear how inversions change the bass line and the stability of an arrival.';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantTitle =>
      'Functional Secondary Dominants';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantDescription =>
      'Treat secondary dominants as directed functional events instead of generic color chords.';

  @override
  String get studyHarmonyClassicalLessonBossTitle => 'Arrival Checkpoint';

  @override
  String get studyHarmonyClassicalLessonBossDescription =>
      'Combine cadence shape, inversion awareness, and secondary-dominant pull in one controlled phrase.';

  @override
  String studyHarmonyPlayStyleLabel(String playStyle) {
    String _temp0 = intl.Intl.selectLogic(playStyle, {
      'competitor': 'Competitor',
      'collector': 'Collector',
      'explorer': 'Explorer',
      'stabilizer': 'Stabilizer',
      'balanced': 'Balanced',
      'other': 'Balanced',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyRewardFocusLabel(String focus) {
    String _temp0 = intl.Intl.selectLogic(focus, {
      'mastery': 'Focus: Mastery',
      'achievements': 'Focus: Achievements',
      'cosmetics': 'Focus: Cosmetics',
      'currency': 'Focus: Currency',
      'collection': 'Focus: Collection',
      'other': 'Focus',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress) {
    return 'Next $rewardTitle $progress%';
  }

  @override
  String studyHarmonyCurrencyBalanceLabel(String currencyTitle, int amount) {
    return '$currencyTitle $amount';
  }

  @override
  String studyHarmonyCurrencyGrantLabel(String currencyTitle, int amount) {
    return '$currencyTitle +$amount';
  }

  @override
  String studyHarmonyDifficultyLaneLabel(String lane) {
    String _temp0 = intl.Intl.selectLogic(lane, {
      'recovery': 'Recovery Lane',
      'groove': 'Groove Lane',
      'push': 'Push Lane',
      'clutch': 'Clutch Lane',
      'legend': 'Legend Lane',
      'other': 'Practice Lane',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPressureTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'calm': 'Calm Pressure',
      'steady': 'Steady Pressure',
      'hot': 'Hot Pressure',
      'charged': 'Charged Pressure',
      'overdrive': 'Overdrive',
      'other': 'Pressure',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyForgivenessTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'strict': 'Strict Windows',
      'tight': 'Tight Windows',
      'balanced': 'Balanced Windows',
      'kind': 'Kind Windows',
      'generous': 'Generous Windows',
      'other': 'Timing Windows',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyComboGoalLabel(int comboTarget) {
    return 'Combo Goal $comboTarget';
  }

  @override
  String studyHarmonyRuntimeTuningSummary(int lives, int goal) {
    return 'Lives $lives | Goal $goal';
  }

  @override
  String studyHarmonyCoachLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Supportive Coach',
      'structured': 'Structured Coach',
      'challengeForward': 'Challenge Coach',
      'analytical': 'Analytical Coach',
      'restorative': 'Restorative Coach',
      'other': 'Coach',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyCoachLine(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': 'Protect flow first and let confidence compound.',
      'structured': 'Follow the structure and the gains will stick.',
      'challengeForward': 'Lean into the pressure and push for a sharper run.',
      'analytical': 'Read the weak point and refine it with precision.',
      'restorative': 'This run is about rebuilding rhythm without tilt.',
      'other': 'Keep the next run focused and intentional.',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPacingSegmentLabel(String segment, int minutes) {
    String _temp0 = intl.Intl.selectLogic(segment, {
      'warmup': 'Warmup',
      'tension': 'Tension',
      'release': 'Release',
      'reward': 'Reward',
      'other': 'Segment',
    });
    return '$_temp0 ${minutes}m';
  }

  @override
  String studyHarmonyPacingSummaryLabel(String segments) {
    return 'Pacing $segments';
  }

  @override
  String studyHarmonyArcadeRiskLabel(String risk) {
    String _temp0 = intl.Intl.selectLogic(risk, {
      'forgiving': 'Low Risk',
      'balanced': 'Balanced Risk',
      'tense': 'High Tension',
      'punishing': 'Punishing Risk',
      'other': 'Arcade Risk',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRewardStyleLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'currency': 'Currency Loop',
      'cosmetic': 'Cosmetic Hunt',
      'title': 'Title Hunt',
      'trophy': 'Trophy Run',
      'bundle': 'Bundle Rewards',
      'prestige': 'Prestige Rewards',
      'other': 'Reward Loop',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count) {
    return 'Combo bonus every $count';
  }

  @override
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives) {
    return 'Miss costs $lives';
  }

  @override
  String get studyHarmonyArcadeRuntimeModifierPulses => 'Modifier pulses';

  @override
  String get studyHarmonyArcadeRuntimeGhostPressure => 'Ghost pressure';

  @override
  String get studyHarmonyArcadeRuntimeShopBiasedLoot => 'Shop-biased loot';

  @override
  String get studyHarmonyArcadeRuntimeSteadyRuleset => 'Steady ruleset';

  @override
  String studyHarmonyShopStateLabel(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'alreadyPurchased': 'Already purchased',
      'readyToBuy': 'Ready to buy',
      'progressLocked': 'Progress locked',
      'other': 'Shop state',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyShopActionLabel(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'buy': 'Buy',
      'equipped': 'Equipped',
      'equip': 'Equip',
      'other': 'Shop action',
    });
    return '$_temp0';
  }

  @override
  String get melodyCurrentLineFeelTitle => 'Current line feel';

  @override
  String get melodyLinePersonalityTitle => 'Line personality';

  @override
  String get melodyLinePersonalityBody =>
      'These four sliders shape why guided, standard, and advanced can feel different even before you change the harmony.';

  @override
  String get melodySyncopationBiasTitle => 'Syncopation Bias';

  @override
  String get melodySyncopationBiasBody =>
      'Leans toward offbeat starts, anticipations, and rhythmic lift.';

  @override
  String get melodyColorRealizationBiasTitle => 'Color Realization Bias';

  @override
  String get melodyColorRealizationBiasBody =>
      'Lets the melody pick up featured tensions and color tones more often.';

  @override
  String get melodyNoveltyTargetTitle => 'Novelty Target';

  @override
  String get melodyNoveltyTargetBody =>
      'Reduces exact repeats and nudges the line toward fresher interval shapes.';

  @override
  String get melodyMotifVariationBiasTitle => 'Motif Variation Bias';

  @override
  String get melodyMotifVariationBiasBody =>
      'Turns motif reuse into sequence, tail changes, and rhythmic variation.';

  @override
  String get studyHarmonyArcadeRulesTitle => 'Arcade Rules';

  @override
  String studyHarmonySessionLengthLabel(int minutes) {
    return '$minutes min run';
  }

  @override
  String studyHarmonyRewardKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'achievement': 'Achievement',
      'title': 'Title',
      'cosmetic': 'Cosmetic',
      'shopItem': 'Shop Unlock',
      'other': 'Reward',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives) {
    return 'Misses cost $lives hearts';
  }

  @override
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount) {
    return 'Misses push progress back by $amount';
  }

  @override
  String studyHarmonyArcadeRuntimeComboProgressLabel(
    int threshold,
    int amount,
  ) {
    return 'Every $threshold combo adds +$amount progress';
  }

  @override
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount) {
    return 'Every $threshold combo adds +$amount heart';
  }

  @override
  String get studyHarmonyArcadeRuntimeComboResetLabel => 'Misses reset combo';

  @override
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount) {
    return 'Misses cut combo by $amount';
  }

  @override
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel =>
      'Choices reshuffle';

  @override
  String get studyHarmonyArcadeRuntimeMissedReplayLabel =>
      'Missed prompts replay';

  @override
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel => 'No prompt repeats';

  @override
  String get studyHarmonyRuntimeBundleClearBonusTitle => 'Clear Bonus';

  @override
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle => 'Precision Bonus';

  @override
  String get studyHarmonyRuntimeBundleComboBonusTitle => 'Combo Bonus';

  @override
  String get studyHarmonyRuntimeBundleModeBonusTitle => 'Mode Bonus';

  @override
  String get studyHarmonyRuntimeBundleMasteryBonusTitle => 'Mastery Bonus';

  @override
  String get melodyQuickPresetGuideLineLabel => 'Guide Line';

  @override
  String get melodyQuickPresetSongLineLabel => 'Song Line';

  @override
  String get melodyQuickPresetColorLineLabel => 'Color Line';

  @override
  String get melodyQuickPresetGuideCompactLabel => 'Guide';

  @override
  String get melodyQuickPresetSongCompactLabel => 'Song';

  @override
  String get melodyQuickPresetColorCompactLabel => 'Color';

  @override
  String get melodyQuickPresetGuideShort => 'steady guide notes';

  @override
  String get melodyQuickPresetSongShort => 'singable contour';

  @override
  String get melodyQuickPresetColorShort => 'color-forward line';

  @override
  String get melodyQuickPresetPanelTitle => 'Melody Presets';

  @override
  String get melodyQuickPresetPanelCompactTitle => 'Line Presets';

  @override
  String get melodyQuickPresetOffLabel => 'Off';

  @override
  String get melodyQuickPresetCompactOffLabel => 'Line Off';

  @override
  String get melodyMetricDensityLabel => 'Density';

  @override
  String get melodyMetricStyleLabel => 'Style';

  @override
  String get melodyMetricSyncLabel => 'Sync';

  @override
  String get melodyMetricColorLabel => 'Color';

  @override
  String get melodyMetricNoveltyLabel => 'Novelty';

  @override
  String get melodyMetricMotifLabel => 'Motif';

  @override
  String get melodyMetricChromaticLabel => 'Chromatic';

  @override
  String get practiceFirstRunWelcomeTitle => 'Tu primer acorde está listo';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'Ya se aplicó un perfil inicial apto para principiantes. Escúchalo primero y luego desliza la tarjeta para explorar el siguiente acorde.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel está listo. Escúchalo primero y luego desliza la tarjeta para explorar lo que sigue. También puedes abrir el asistente de configuración para personalizar el inicio.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Idioma de notación musical';

  @override
  String get musicNotationLocaleHelp =>
      'Controla el idioma usado para las ayudas opcionales de números romanos y texto de acordes.';

  @override
  String get musicNotationLocaleUiDefault => 'Igual que la app';

  @override
  String get musicNotationLocaleEnglish => 'Inglés';

  @override
  String get noteNamingStyle => 'Nombres de notas';

  @override
  String get noteNamingStyleHelp =>
      'Cambia los nombres visibles de notas y tonalidades sin alterar la lógica armónica.';

  @override
  String get noteNamingStyleEnglish => 'Letras inglesas';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Mostrar ayuda de números romanos';

  @override
  String get showRomanNumeralAssistHelp =>
      'Añade una breve explicación junto a las etiquetas de números romanos.';

  @override
  String get showChordTextAssist => 'Mostrar ayuda de texto de acordes';

  @override
  String get showChordTextAssistHelp =>
      'Añade una breve explicación sobre la cualidad del acorde y sus tensiones.';

  @override
  String get premiumUnlockTitle => 'Chordest Premium';

  @override
  String get premiumUnlockBody =>
      'A one-time purchase permanently unlocks Smart Generator and advanced harmonic color controls. Free Generator, Analyzer, metronome, and language support stay available.';

  @override
  String get premiumUnlockRequestedFeatureTitle => 'Requested in this flow';

  @override
  String get premiumUnlockOfflineCacheTitle =>
      'Using your last confirmed unlock';

  @override
  String get premiumUnlockOfflineCacheBody =>
      'The store is unavailable right now, so the app is using your last confirmed premium unlock cache.';

  @override
  String get premiumUnlockFreeTierTitle => 'Free';

  @override
  String get premiumUnlockFreeTierLineGenerator =>
      'Basic Generator, chord display, inversions, slash bass, and core metronome';

  @override
  String get premiumUnlockFreeTierLineAnalyzer =>
      'Conservative Analyzer with confidence and ambiguity warnings';

  @override
  String get premiumUnlockFreeTierLineMetronome =>
      'Language, theme, setup assistant, and standard practice settings';

  @override
  String get premiumUnlockPremiumTierTitle => 'Premium unlock';

  @override
  String get premiumUnlockPremiumLineSmartGenerator =>
      'Smart Generator mode for progression-aware generation in selected keys';

  @override
  String get premiumUnlockPremiumLineHarmonyColors =>
      'Secondary dominants, substitute dominants, modal interchange, and advanced tensions';

  @override
  String get premiumUnlockPremiumLineAdvancedSmartControls =>
      'Modulation intensity, jazz preset, and source profile controls for Smart Generator';

  @override
  String premiumUnlockBuyButton(Object priceLabel) {
    return 'Desbloqueo permanente ($priceLabel)';
  }

  @override
  String get premiumUnlockBuyButtonUnavailable => 'Unlock permanently';

  @override
  String get premiumUnlockRestoreButton => 'Restore purchase';

  @override
  String get premiumUnlockKeepFreeButton => 'Keep using free';

  @override
  String get premiumUnlockStoreFallbackBody =>
      'Store product info is not available right now. Free features keep working, and you can retry or restore later.';

  @override
  String get premiumUnlockStorePriceHint =>
      'Price comes from the store. The app does not hardcode a fixed price.';

  @override
  String get premiumUnlockStoreUnavailableTitle => 'Store unavailable';

  @override
  String get premiumUnlockStoreUnavailableBody =>
      'La conexión con la tienda no está disponible en este momento. Las funciones gratuitas siguen funcionando.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'La información del producto premium no está disponible ahora mismo. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockPurchaseSuccessTitle => 'Premium unlocked';

  @override
  String get premiumUnlockPurchaseSuccessBody =>
      'Your permanent premium unlock is now active on this device.';

  @override
  String get premiumUnlockRestoreSuccessTitle => 'Purchase restored';

  @override
  String get premiumUnlockRestoreSuccessBody =>
      'Your premium unlock was restored from the store.';

  @override
  String get premiumUnlockRestoreNotFoundTitle => 'Nothing to restore';

  @override
  String get premiumUnlockRestoreNotFoundBody =>
      'No matching premium unlock was found for this store account.';

  @override
  String get premiumUnlockPurchaseCancelledTitle => 'Purchase canceled';

  @override
  String get premiumUnlockPurchaseCancelledBody =>
      'No charge was made. Free features are still available.';

  @override
  String get premiumUnlockPurchasePendingTitle => 'Purchase pending';

  @override
  String get premiumUnlockPurchasePendingBody =>
      'The store marked this purchase as pending. Premium unlock will activate after confirmation.';

  @override
  String get premiumUnlockPurchaseFailedTitle => 'Purchase failed';

  @override
  String get premiumUnlockPurchaseFailedBody =>
      'No se pudo completar la compra. Inténtalo de nuevo más tarde.';

  @override
  String get premiumUnlockAlreadyOwned => 'Premium unlocked';

  @override
  String get premiumUnlockAlreadyOwnedTitle => 'Already unlocked';

  @override
  String get premiumUnlockAlreadyOwnedBody =>
      'This store account already has the premium unlock.';

  @override
  String get premiumUnlockHighlightSmartGenerator =>
      'Smart Generator mode and its deeper progression controls are part of the premium unlock.';

  @override
  String get premiumUnlockHighlightAdvancedHarmony =>
      'Non-diatonic color options and advanced tensions are part of the premium unlock.';

  @override
  String get premiumUnlockCardTitle => 'Premium unlock';

  @override
  String get premiumUnlockCardBodyUnlocked =>
      'Your one-time premium unlock is active.';

  @override
  String get premiumUnlockCardBodyLocked =>
      'Unlock Smart Generator and advanced harmonic color controls with one purchase.';

  @override
  String get premiumUnlockCardButton => 'View premium';

  @override
  String get premiumUnlockGeneratorHint =>
      'Smart Generator and advanced harmonic colors unlock with a one-time premium purchase.';

  @override
  String get premiumUnlockSettingsHintTitle => 'Premium controls';

  @override
  String get premiumUnlockSettingsHintBody =>
      'Smart Generator, non-diatonic color controls, and advanced tensions are part of the one-time premium unlock.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountCardSignedOutBody =>
      'Sign in to link premium to your account and restore it on your other devices.';

  @override
  String accountCardSignedInBody(Object email) {
    return 'Signed in as $email. Premium sync and restore now follow this account.';
  }

  @override
  String get accountCardUnavailableBody =>
      'Account features are not configured in this build yet. Add Firebase runtime configuration to enable sign-in.';

  @override
  String get accountOpenButton => 'Sign in';

  @override
  String get accountManageButton => 'Manage account';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountSignInButton => 'Sign in';

  @override
  String get accountCreateButton => 'Create account';

  @override
  String get accountSwitchToCreateButton => 'Create a new account';

  @override
  String get accountSwitchToSignInButton => 'I already have an account';

  @override
  String get accountForgotPasswordButton => 'Reset password';

  @override
  String get accountSignOutButton => 'Sign out';

  @override
  String get accountMessageSignedIn => 'You\'re signed in.';

  @override
  String get accountMessageSignedUp =>
      'Your account was created and signed in.';

  @override
  String get accountMessageSignedOut => 'You signed out of this account.';

  @override
  String get accountMessagePasswordResetSent => 'Password reset email sent.';

  @override
  String get accountMessageInvalidCredentials =>
      'Check your email and password and try again.';

  @override
  String get accountMessageEmailInUse => 'That email is already in use.';

  @override
  String get accountMessageWeakPassword =>
      'Use a stronger password to create this account.';

  @override
  String get accountMessageUserNotFound =>
      'No account was found for that email.';

  @override
  String get accountMessageTooManyRequests =>
      'Too many attempts right now. Please try again later.';

  @override
  String get accountMessageNetworkError =>
      'The network request failed. Please check your connection.';

  @override
  String get accountMessageAuthUnavailable =>
      'Account sign-in is not configured in this build yet.';

  @override
  String get accountMessageUnknownError =>
      'The account request could not be completed.';

  @override
  String get accountDeleteButton => 'Delete account';

  @override
  String get accountDeleteDialogTitle => 'Delete account?';

  @override
  String accountDeleteDialogBody(Object email) {
    return 'This permanently deletes the Chordest account for $email and removes synced premium data. Store purchase history stays with your store account.';
  }

  @override
  String get accountDeletePasswordHelper =>
      'Enter your current password to confirm this deletion request.';

  @override
  String get accountDeleteConfirmButton => 'Delete permanently';

  @override
  String get accountDeleteCancelButton => 'Cancel';

  @override
  String get accountDeletePasswordRequired =>
      'Enter your current password to delete this account.';

  @override
  String get accountMessageDeleted =>
      'Your account and synced premium data were deleted.';

  @override
  String get accountMessageDeleteRequiresRecentLogin =>
      'For safety, enter your current password and try again.';

  @override
  String get accountMessageDataDeletionFailed =>
      'We couldn\'t remove your synced account data. Please try again.';

  @override
  String get premiumUnlockAccountSyncTitle => 'Account sync';

  @override
  String get premiumUnlockAccountSyncSignedOutBody =>
      'You can keep using premium locally, but signing in lets this unlock follow your account to other devices.';

  @override
  String premiumUnlockAccountSyncSignedInBody(Object email) {
    return 'Premium purchases and restores will sync to $email when this account is signed in.';
  }

  @override
  String get premiumUnlockAccountSyncUnavailableBody =>
      'Account sync is not configured in this build yet, so premium currently stays local to this device.';

  @override
  String get premiumUnlockAccountOpenButton => 'Account';
}
