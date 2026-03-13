// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuracion';

  @override
  String get closeSettings => 'Cerrar configuracion';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefaultLanguage => 'Predeterminado del sistema';

  @override
  String get metronome => 'Metronomo';

  @override
  String get enabled => 'Activado';

  @override
  String get disabled => 'Desactivado';

  @override
  String get metronomeHelp =>
      'Activa el metronomo para escuchar un clic en cada pulso mientras practicas.';

  @override
  String get metronomeSound => 'Sonido del metronomo';

  @override
  String get metronomeSoundClassic => 'Clasico';

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
  String get metronomeVolume => 'Volumen del metronomo';

  @override
  String get keys => 'Tonalidades';

  @override
  String get noKeysSelected =>
      'No keys selected. Leave all keys off to practice in free mode across every root.';

  @override
  String get keysSelectedHelp =>
      'Selected keys are used for key-aware random mode and Smart Generator mode.';

  @override
  String get smartGeneratorMode => 'Modo Smart Generator';

  @override
  String get smartGeneratorHelp =>
      'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.';

  @override
  String get advancedSmartGenerator => 'Smart Generator avanzado';

  @override
  String get modulationIntensity => 'Intensidad de modulacion';

  @override
  String get modulationIntensityOff => 'Off';

  @override
  String get modulationIntensityLow => 'Low';

  @override
  String get modulationIntensityMedium => 'Medium';

  @override
  String get modulationIntensityHigh => 'High';

  @override
  String get jazzPreset => 'Preajuste jazz';

  @override
  String get jazzPresetStandardsCore => 'Standards Core';

  @override
  String get jazzPresetModulationStudy => 'Modulation Study';

  @override
  String get jazzPresetAdvanced => 'Advanced';

  @override
  String get sourceProfile => 'Perfil de origen';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook Standard';

  @override
  String get sourceProfileRecordingInspired => 'Recording Inspired';

  @override
  String get smartDiagnostics => 'Diagnosticos Smart';

  @override
  String get smartDiagnosticsHelp =>
      'Logs Smart Generator decision traces for debugging.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Select at least one key to use Smart Generator mode.';

  @override
  String get nonDiatonic => 'Non-Diatonic';

  @override
  String get nonDiatonicRequiresKeyMode =>
      'Non-diatonic options are available in key mode only.';

  @override
  String get secondaryDominant => 'Dominante secundaria';

  @override
  String get substituteDominant => 'Dominante sustituta';

  @override
  String get modalInterchange => 'Intercambio modal';

  @override
  String get modalInterchangeDisabledHelp =>
      'Modal interchange only appears in key mode, so this option is disabled in free mode.';

  @override
  String get rendering => 'Representacion';

  @override
  String get keyCenterLabelStyle => 'Estilo de tonalidad';

  @override
  String get keyCenterLabelStyleHelp =>
      'Elige entre mostrar mayor/menor en texto o usar mayusculas y minusculas al estilo clasico.';

  @override
  String get chordSymbolStyle => 'Estilo de simbolo de acorde';

  @override
  String get chordSymbolStyleHelp =>
      'Changes the display layer only. Harmonic logic stays canonical.';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get keyCenterLabelStyleModeText => 'C mayor: / C menor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'Allow V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Permitir tensiones';

  @override
  String get tensionHelp => 'Roman numeral profile and selected chips only';

  @override
  String get inversions => 'Inversiones';

  @override
  String get enableInversions => 'Enable Inversions';

  @override
  String get inversionHelp =>
      'Random slash-bass rendering after chord selection; it does not track the previous bass.';

  @override
  String get firstInversion => '1st Inversion';

  @override
  String get secondInversion => '2nd Inversion';

  @override
  String get thirdInversion => '3rd Inversion';

  @override
  String get keyPracticeOverview => 'Resumen de practica tonal';

  @override
  String get freePracticeOverview => 'Resumen de practica libre';

  @override
  String get keyModeTag => 'Modo tonal';

  @override
  String get freeModeTag => 'Modo libre';

  @override
  String get allKeysTag => 'Todas las tonalidades';

  @override
  String get metronomeOnTag => 'Metronome On';

  @override
  String get metronomeOffTag => 'Metronome Off';

  @override
  String get pressNextChordToBegin => 'Pulsa Next Chord para empezar';

  @override
  String get freeModeActive => 'Modo libre activo';

  @override
  String get freePracticeDescription =>
      'Uses all 12 chromatic roots with random chord qualities for broad reading practice.';

  @override
  String get smartPracticeDescription =>
      'Follows harmonic function flow in the selected keys while allowing tasteful smart-generator movement.';

  @override
  String get keyPracticeDescription =>
      'Uses the selected keys and enabled Roman numerals to generate diatonic practice material.';

  @override
  String get keyboardShortcutHelp =>
      'Space: next chord  Enter: start or stop autoplay  Up/Down: adjust BPM';

  @override
  String get nextChord => 'Siguiente acorde';

  @override
  String get startAutoplay => 'Iniciar autoplay';

  @override
  String get stopAutoplay => 'Detener autoplay';

  @override
  String get decreaseBpm => 'Bajar BPM';

  @override
  String get increaseBpm => 'Subir BPM';

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
  String get modeMajor => 'mayor';

  @override
  String get modeMinor => 'menor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Sugerencias de voicing';

  @override
  String get voicingSuggestionsSubtitle =>
      'Mira opciones concretas de notas para este acorde.';

  @override
  String get voicingSuggestionsEnabled => 'Activar sugerencias de voicing';

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
      'Leans suggestions toward a chosen top line. Locked voicings win first, then repeated chords keep it steady.';

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
  String get voicingSuggestionTopLineSubtitle => 'Top line leads';

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
    return 'Top line target: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Locked top line: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'Repeated top line: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return 'Nearest top line to $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return 'No exact top line for $note';
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
  String get voicingSelected => 'Seleccionado';

  @override
  String get voicingLocked => 'Bloqueado';

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
  String get voicingReasonTopLineTarget => 'Top line target';

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

  @override
  String get mainMenuIntro =>
      'Choose a practice generator or open the analyzer for a separate progression reading workflow.';

  @override
  String get mainMenuGeneratorTitle => 'Chord Generator';

  @override
  String get mainMenuGeneratorDescription =>
      'Generate practice chords with key-aware random mode, smart motion, and voicing suggestions.';

  @override
  String get openGenerator => 'Open Generator';

  @override
  String get openAnalyzer => 'Abrir analizador';

  @override
  String get mainMenuAnalyzerTitle => 'Analizador de acordes';

  @override
  String get mainMenuAnalyzerDescription =>
      'Analiza una progresión escrita para estimar tonalidades, números romanos y funciones armónicas.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.';

  @override
  String get openStudyHarmony => 'Abrir Study Harmony';

  @override
  String get studyHarmonyTitle => 'Study Harmony';

  @override
  String get studyHarmonySubtitle =>
      'Work through a structured harmony hub with quick lesson entries and chapter progress.';

  @override
  String get studyHarmonyPlaceholderTag => 'Prototype system';

  @override
  String get studyHarmonyPlaceholderBody =>
      'The prototype separates level data, prompt presentation, and answer input so future note, chord, scale, and reverse-identification drills can reuse the same flow.';

  @override
  String get studyHarmonyTestLevelTag => 'Test level';

  @override
  String get studyHarmonyTestLevelAction => 'Open test level';

  @override
  String get studyHarmonySubmit => 'Submit';

  @override
  String get studyHarmonySelectedAnswers => 'Selected answers';

  @override
  String get studyHarmonySelectionEmpty => 'No answers selected yet.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total correct';
  }

  @override
  String get studyHarmonyAttempts => 'Attempts';

  @override
  String get studyHarmonyAccuracy => 'Accuracy';

  @override
  String get studyHarmonyElapsedTime => 'Time';

  @override
  String get studyHarmonyObjective => 'Goal';

  @override
  String get studyHarmonyPromptInstruction => 'Pick the matching answer';

  @override
  String get studyHarmonyNeedSelection =>
      'Choose at least one answer before submitting.';

  @override
  String get studyHarmonyCorrectLabel => 'Correct';

  @override
  String get studyHarmonyIncorrectLabel => 'Incorrect';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return 'Correct. $answer was the right answer.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return 'Incorrect. $answer was the right answer and you lost one life.';
  }

  @override
  String get studyHarmonyGameOverTitle => 'Game Over';

  @override
  String get studyHarmonyGameOverBody =>
      'All three lives are gone. Retry this level or go back to the Study Harmony hub.';

  @override
  String get studyHarmonyLevelCompleteTitle => 'Level Cleared';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'You reached the lesson goal. Check your accuracy and clear time below.';

  @override
  String get studyHarmonyBackToHub => 'Back to Study Harmony';

  @override
  String get studyHarmonyRetry => 'Retry';

  @override
  String get studyHarmonyHubHeroEyebrow => 'Study Hub';

  @override
  String get studyHarmonyHubHeroBody =>
      'Use Continue to resume momentum, Review to revisit weak spots, and Daily to get one deterministic lesson from your unlocked path.';

  @override
  String get studyHarmonyTrackFilterLabel => 'Tracks';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Core';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Classical';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total lessons cleared';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total chapters completed';
  }

  @override
  String get studyHarmonyContinueCardTitle => 'Continue';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Resume the lesson you touched most recently.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Jump to the next lesson at your current frontier.';

  @override
  String get studyHarmonyContinueAction => 'Continue';

  @override
  String get studyHarmonyReviewCardTitle => 'Review';

  @override
  String get studyHarmonyReviewQueueHint =>
      'Pulled from your current review queue placeholder.';

  @override
  String get studyHarmonyReviewWeakHint =>
      'Picked from the weakest result in your played lessons.';

  @override
  String get studyHarmonyReviewFallbackHint =>
      'No review debt yet, so this falls back to your current frontier.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      'This lesson needs another pass after a miss or unfinished run.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      'This lesson is queued for a quick accuracy refresh.';

  @override
  String get studyHarmonyReviewAction => 'Review';

  @override
  String get studyHarmonyDailyCardTitle => 'Daily Challenge';

  @override
  String get studyHarmonyDailyCardHint =>
      'Open today\'s deterministic lesson from your unlocked path.';

  @override
  String get studyHarmonyDailyAction => 'Play Daily';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Seed $dateKey';
  }

  @override
  String get studyHarmonyReviewSessionTitle => 'Weak Spot Review';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return 'Mix a short review set around $chapterTitle and your weakest recent skills.';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'Daily Challenge';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return 'Play today\'s seeded mix built from $chapterTitle and your current frontier.';
  }

  @override
  String get studyHarmonyModeLesson => 'Lesson Mode';

  @override
  String get studyHarmonyModeReview => 'Review Mode';

  @override
  String get studyHarmonyModeDaily => 'Daily Mode';

  @override
  String get studyHarmonyModeLegacy => 'Legacy Mode';

  @override
  String get studyHarmonyResultSkillGainTitle => 'Skill gains';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Review focus';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded =>
      'Review reason: retry needed';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh =>
      'Review reason: accuracy refresh';

  @override
  String get studyHarmonyReviewReasonLowMastery => 'Review reason: low mastery';

  @override
  String get studyHarmonyReviewReasonStaleSkill => 'Review reason: stale skill';

  @override
  String get studyHarmonyReviewReasonWeakSpot => 'Review reason: weak spot';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh =>
      'Review reason: frontier refresh';

  @override
  String get studyHarmonySkillNoteRead => 'Note reading';

  @override
  String get studyHarmonySkillNoteFindKeyboard => 'Keyboard note finding';

  @override
  String get studyHarmonySkillNoteAccidentals => 'Sharps and flats';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'Chord symbol to keys';

  @override
  String get studyHarmonySkillChordNameFromTones => 'Chord naming';

  @override
  String get studyHarmonySkillScaleBuild => 'Scale building';

  @override
  String get studyHarmonySkillRomanRealize => 'Roman numeral realization';

  @override
  String get studyHarmonySkillRomanIdentify => 'Roman numeral identification';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'Diatonicity';

  @override
  String get studyHarmonySkillHarmonyFunction => 'Function basics';

  @override
  String get studyHarmonyHubChapterSectionTitle => 'Chapters';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return '$cleared/$total lessons cleared';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count completed';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'Open chapter';

  @override
  String get studyHarmonyLockedChapterTag => 'Locked';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return 'Next up: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return '$coreTrack is the active path right now. The other tracks stay visible so the hub can grow without another navigation rewrite.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Core Track';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Start with notes and the keyboard, then build up through chords, scales, Roman numerals, and diatonic basics.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Chapter 1: Notes & Keyboard';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Map note names to the keyboard and get comfortable with white keys and simple accidentals.';

  @override
  String get studyHarmonyChapterChordsTitle => 'Chapter 2: Chord Basics';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Spell basic triads and sevenths, then name common chord shapes from their tones.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Chapter 3: Scales & Keys';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Build major and minor scales, then spot which tones belong inside a key.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Chapter 4: Roman Numerals & Diatonicity';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Turn simple Roman numerals into chords, identify them from chords, and sort diatonic basics by function.';

  @override
  String get studyHarmonyOpenLessonAction => 'Open lesson';

  @override
  String get studyHarmonyLockedLessonAction => 'Locked';

  @override
  String get studyHarmonyClearedTag => 'Cleared';

  @override
  String get studyHarmonyComingSoonTag => 'Coming soon';

  @override
  String get studyHarmonyPopTrackTitle => 'Pop Track';

  @override
  String get studyHarmonyPopTrackDescription =>
      'A song-focused path is planned after the Core track is stable.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Jazz Track';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Jazz harmony content stays locked until the Core curriculum settles.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Classical Track';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Functional harmony in classical contexts will arrive in a later phase.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Quick Drill';

  @override
  String get studyHarmonyObjectiveBossReview => 'Boss Review';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => 'White-Key Note Hunt';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Read note names and tap the matching white key.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Name the Highlighted Note';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Look at a highlighted key and choose the correct note name.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => 'Black Keys and Twins';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Get a first look at sharp and flat spellings for the black keys.';

  @override
  String get studyHarmonyLessonNotesBossTitle => 'Boss: Fast Note Hunt';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mix note reading and keyboard finding into one short speed round.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Triads on the Keyboard';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Build common major, minor, and diminished triads directly on the keyboard.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle =>
      'Sevenths on the Keyboard';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Add the seventh and spell a few common 7th chords on the keyboard.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Name the Highlighted Chord';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Read a highlighted chord shape and choose the correct chord name.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Boss: Triads and Sevenths Review';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Switch between chord spelling and chord naming in one mixed review.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Build Major Scales';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Choose every tone that belongs to a simple major scale.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Build Minor Scales';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Build natural minor and harmonic minor scales from a few common keys.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Key Membership';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Find which tones belong inside a named key.';

  @override
  String get studyHarmonyLessonScalesBossTitle => 'Boss: Scale Repair';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Mix scale building and key membership in a short repair round.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Roman to Chord';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Read a key and Roman numeral, then choose the matching chord.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Chord to Roman';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Read a chord inside a key and choose the matching Roman numeral.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatonic or Not';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Sort chords into diatonic and non-diatonic answers in simple keys.';

  @override
  String get studyHarmonyLessonFunctionTitle => 'Function Basics';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Classify easy chords as tonic, predominant, or dominant.';

  @override
  String get studyHarmonyLessonRomanBossTitle => 'Boss: Functional Basics Mix';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Review Roman-to-chord, chord-to-Roman, diatonicity, and function together.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Find $note on the keyboard';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      'Which note is highlighted?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Build $chord on the keyboard';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      'Which chord is highlighted?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Pick every note in $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Pick the notes that belong to $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'In $keyName, which chord matches $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'In $keyName, what Roman numeral matches $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'In $keyName, is $chord diatonic?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'In $keyName, what function does $chord have?';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic major';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic natural minor';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic harmonic minor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic major';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic minor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatonic';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'Non-diatonic';

  @override
  String get studyHarmonyChoiceTonic => 'Tonic';

  @override
  String get studyHarmonyChoicePredominant => 'Predominant';

  @override
  String get studyHarmonyChoiceDominant => 'Dominant';

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
      'Fuera de paréntesis puedes separar con espacios, | o comas. Las comas dentro de paréntesis se mantienen dentro del mismo acorde. Se admiten raíces en minúscula, bajo con slash, formas sus/alt/add y tensiones como C7(b9, #11). En dispositivos táctiles puedes usar el panel de acordes o cambiar a entrada ABC.';

  @override
  String get chordAnalyzerAnalyze => 'Analizar';

  @override
  String get chordAnalyzerKeyboardTitle => 'Panel de acordes';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Toca símbolos para construir una progresión. La entrada ABC mantiene disponible el teclado del sistema cuando necesitas escribir libremente.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Escribe, pega o toca símbolos para insertarlos en el cursor.';

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
      'Introduce una progresión como Dm7 G7 Cmaj7 o Cmaj7 | Am7 D7 | Gmaj7 para ver tonalidades probables, números romanos y un resumen breve.';

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
      'Introduce una progresión de acordes para analizar.';

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
      'Algunos acordes siguen siendo ambiguos, así que esta lectura se mantiene intencionalmente conservadora.';

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
    return 'Posible dominante secundaria hacia $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Posible sustituto por tritono hacia $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Posible intercambio modal desde el modo paralelo menor.';

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
    return 'Esta progresión probablemente se centra en $key.';
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
    return '$from y $through funcionan como acordes de $fromFunction y $throughFunction que conducen a $target.';
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
      'Algunos detalles siguen siendo ambiguos, así que esta lectura se mantiene intencionalmente conservadora.';

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
      'Los paréntesis desequilibrados dejaron incierta parte del símbolo.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'Se ignoró un paréntesis de cierre inesperado.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'El color explícito $extension refuerza esta lectura.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'El color dominante alterado apoya una función dominante.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'El bajo con slash $bass mantiene significativa la línea de bajo o la inversión.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'El siguiente acorde apoya una resolución hacia $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'Este color puede oírse como prestado del modo paralelo.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'El color suspendido suaviza la atracción dominante sin borrarla.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Lectura de baja confianza';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'Las tonalidades candidatas están muy cerca entre sí o algunos símbolos solo se recuperaron parcialmente, así que tómalo como una primera lectura cautelosa.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'Este compás está vacío y se conservó en la numeración.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No se recuperaron símbolos analizables en este compás.';

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
      'No se pudo reconocer la raíz.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root no es una escritura de raíz admitida.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'El bajo con slash $bass no es una escritura admitida.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Sufijo o modificador no admitido: $suffix';
  }
}
