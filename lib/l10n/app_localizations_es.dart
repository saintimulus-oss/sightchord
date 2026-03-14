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
      'Espacio: siguiente acorde Enter: iniciar o detener la reproducción automática Arriba/Abajo: ajustar BPM';

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
  String get stopAutoplay => 'Detener la reproducción automática';

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
      'Elija un generador de práctica o abra el analizador para un flujo de trabajo de lectura de progresión independiente.';

  @override
  String get mainMenuGeneratorTitle => 'Generador de acordes';

  @override
  String get mainMenuGeneratorDescription =>
      'Genere acordes de práctica con modo aleatorio con reconocimiento de clave, movimiento inteligente y sugerencias voicing.';

  @override
  String get openGenerator => 'Generador abierto';

  @override
  String get openAnalyzer => 'Analizador abierto';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Analice una progresión escrita para posibles centro tonal, número romano y función armónica.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Estudio de armonía';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Muévase a través de un centro de estudio de armonía real con lecciones continuas, de repaso, diarias y basadas en capítulos.';

  @override
  String get openStudyHarmony => 'Abrir Estudio de armonía';

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
      'Se planea un camino centrado en la canción después de que la pista principal esté estable.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Ruta de jazz';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'El contenido de armonía del jazz permanece bloqueado hasta que se asienta el plan de estudios básico.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Ruta clásica';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'La armonía funcional en contextos clásicos llegará en una fase posterior.';

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
    return 'El analizador lee esta progresión con mayor claridad en $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord se comporta más como un acorde $functionLabel en este contexto.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord se destaca frente a la lectura principal de $keyLabel, por lo que es la mejor elección de no diatónico.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord restaura el tirón esperado de $functionLabel en esta progresión.';
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
      'Pega una progresión y obtén una lectura armónica conservadora.';

  @override
  String get chordAnalyzerInputLabel => 'Progresión de acordes';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      'Fuera de paréntesis, los separadores pueden ser espacios, | o comas. Las comas dentro de paréntesis permanecen dentro de un mismo acorde. Se admiten fundamentales en minúscula, bajo con barra, formas sus/alt/add y tensiones como C7(b9, #11). En dispositivos táctiles puedes usar el pad de acordes o cambiar a la entrada ABC.';

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
  String get chordAnalyzerClear => 'Borrar';

  @override
  String get chordAnalyzerBackspace => 'Retroceso';

  @override
  String get chordAnalyzerSpace => 'Espacio';

  @override
  String get chordAnalyzerAnalyzing => 'Analizando progresión...';

  @override
  String get chordAnalyzerInitialTitle => 'Empieza con una progresión';

  @override
  String get chordAnalyzerInitialBody =>
      'Introduce una progresión como Dm7 G7 Cmaj7 o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos y un breve resumen.';

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
}
