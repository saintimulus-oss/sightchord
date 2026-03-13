// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '設定';

  @override
  String get closeSettings => '關閉設定';

  @override
  String get language => '語言';

  @override
  String get systemDefaultLanguage => '系統預設';

  @override
  String get metronome => '節拍器';

  @override
  String get enabled => '開啟';

  @override
  String get disabled => '關閉';

  @override
  String get metronomeHelp => '練習時若想在每一拍都聽到點擊聲，請開啟節拍器。';

  @override
  String get metronomeSound => '節拍器音色';

  @override
  String get metronomeSoundClassic => '經典';

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
  String get metronomeVolume => '節拍器音量';

  @override
  String get keys => '調性';

  @override
  String get noKeysSelected =>
      'No keys selected. Leave all keys off to practice in free mode across every root.';

  @override
  String get keysSelectedHelp =>
      'Selected keys are used for key-aware random mode and Smart Generator mode.';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp =>
      'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.';

  @override
  String get advancedSmartGenerator => '進階 Smart Generator';

  @override
  String get modulationIntensity => '轉調強度';

  @override
  String get modulationIntensityOff => 'Off';

  @override
  String get modulationIntensityLow => 'Low';

  @override
  String get modulationIntensityMedium => 'Medium';

  @override
  String get modulationIntensityHigh => 'High';

  @override
  String get jazzPreset => '爵士預設';

  @override
  String get jazzPresetStandardsCore => 'Standards Core';

  @override
  String get jazzPresetModulationStudy => 'Modulation Study';

  @override
  String get jazzPresetAdvanced => 'Advanced';

  @override
  String get sourceProfile => '來源設定';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook Standard';

  @override
  String get sourceProfileRecordingInspired => 'Recording Inspired';

  @override
  String get smartDiagnostics => 'Smart 診斷';

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
  String get secondaryDominant => '副屬和弦';

  @override
  String get substituteDominant => '替代屬和弦';

  @override
  String get modalInterchange => '調式借用';

  @override
  String get modalInterchangeDisabledHelp =>
      'Modal interchange only appears in key mode, so this option is disabled in free mode.';

  @override
  String get rendering => '顯示';

  @override
  String get keyCenterLabelStyle => '調性標籤樣式';

  @override
  String get keyCenterLabelStyleHelp => '可選擇顯示 major/minor 文字，或使用古典的大寫/小寫主音標記。';

  @override
  String get chordSymbolStyle => '和弦符號樣式';

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
  String get keyCenterLabelStyleModeText => 'C 大調: / C 小調:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'Allow V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => '允許張力音';

  @override
  String get tensionHelp => 'Roman numeral profile and selected chips only';

  @override
  String get inversions => '轉位';

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
  String get keyPracticeOverview => '調性練習概覽';

  @override
  String get freePracticeOverview => '自由練習概覽';

  @override
  String get keyModeTag => '調性模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有調性';

  @override
  String get metronomeOnTag => 'Metronome On';

  @override
  String get metronomeOffTag => 'Metronome Off';

  @override
  String get pressNextChordToBegin => '按下 Next Chord 開始';

  @override
  String get freeModeActive => '自由模式啟用';

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
  String get nextChord => '下一個和弦';

  @override
  String get startAutoplay => '開始自動播放';

  @override
  String get stopAutoplay => '停止自動播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '提高 BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return '允許範圍：$min-$max';
  }

  @override
  String get modeMajor => '大調';

  @override
  String get modeMinor => '小調';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Voicing 建議';

  @override
  String get voicingSuggestionsSubtitle => '查看這個和弦可用的具體音符選擇。';

  @override
  String get voicingSuggestionsEnabled => '啟用 Voicing 建議';

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
  String get voicingTopNotePreference => '高音偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Leans suggestions toward a chosen top line. Locked voicings win first, then repeated chords keep it steady.';

  @override
  String get voicingTopNotePreferenceAuto => '自動';

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
  String get voicingTopNoteLabel => '高音';

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
  String get voicingSelected => '已選取';

  @override
  String get voicingLocked => '已鎖定';

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
  String get openAnalyzer => '打开分析器';

  @override
  String get mainMenuAnalyzerTitle => '和弦分析器';

  @override
  String get mainMenuAnalyzerDescription => '分析输入的和弦进行，给出可能的调性、罗马数字和和声功能。';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.';

  @override
  String get openStudyHarmony => '開啟 Study Harmony';

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
  String get studyHarmonySkillProgressionKeyCenter => 'Progression key center';

  @override
  String get studyHarmonySkillProgressionFunction =>
      'Progression function reading';

  @override
  String get studyHarmonySkillProgressionNonDiatonic =>
      'Progression non-diatonic detection';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'Progression fill-in';

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
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Chapter 5: Progression Detective I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      'Read short core progressions, find the likely key center, and spot the chord function or odd one out.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Chapter 6: Missing Chord I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      'Fill one blank inside a short progression and learn where cadence and function want to go next.';

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
  String get studyHarmonyLessonProgressionKeyCenterTitle =>
      'Find the Key Center';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      'Read a short progression and choose the key center that makes the clearest sense.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle =>
      'Function in Context';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      'Focus on one highlighted chord and name its role inside a short progression.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle =>
      'Find the Outsider';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'Spot the one chord that falls outside the main diatonic reading.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Boss: Mixed Analysis';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'Mix key-center reading, function spotting, and non-diatonic detection in one short detective round.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle =>
      'Fill the Missing Chord';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'Complete a short four-chord progression by choosing the chord that fits the local function best.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle => 'Cadence Fill-In';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'Use the pull toward a cadence to choose the missing chord near the end of a phrase.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Boss: Mixed Fill-In';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'Solve a short set of fill-in progression questions with a little more harmonic pressure.';

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
  String get studyHarmonyProgressionStripLabel => 'Progression';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      'Which key center best fits this progression?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return 'What function does $chord play here?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      'Which chord feels least diatonic in this progression?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      'Which chord best fills the blank?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'The analyzer reads this progression most clearly in $keyLabel.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord behaves most like a $functionLabel chord in this context.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord stands out against the main $keyLabel reading, so it is the best non-diatonic pick.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord restores the expected $functionLabel pull in this progression.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
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
  String get studyHarmonyChoiceOther => 'Other';

  @override
  String get chordAnalyzerTitle => '和弦分析器';

  @override
  String get chordAnalyzerSubtitle => '粘贴一段和弦进行，获得保守的和声解读。';

  @override
  String get chordAnalyzerInputLabel => '和弦进行';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '在括号外可以用空格、| 或逗号分隔和弦。括号内的逗号会保留在同一个和弦里作为张力音分隔符。支持小写根音、斜线低音、sus/alt/add 形式，以及 C7(b9, #11) 这类括号张力音。触摸设备可以使用和弦面板或切换到 ABC 输入。';

  @override
  String get chordAnalyzerAnalyze => '分析';

  @override
  String get chordAnalyzerKeyboardTitle => '和弦面板';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '点按符号来拼出进行。需要自由输入时，可以切换到 ABC 输入并继续使用系统键盘。';

  @override
  String get chordAnalyzerKeyboardDesktopHint => '可以直接输入、粘贴，或点按符号插入到光标位置。';

  @override
  String get chordAnalyzerChordPad => '面板';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '粘贴';

  @override
  String get chordAnalyzerClear => '清除';

  @override
  String get chordAnalyzerBackspace => '退格';

  @override
  String get chordAnalyzerSpace => '空格';

  @override
  String get chordAnalyzerAnalyzing => '正在分析进行...';

  @override
  String get chordAnalyzerInitialTitle => '先输入一段进行';

  @override
  String get chordAnalyzerInitialBody =>
      '输入 Dm7 G7 Cmaj7 或 Cmaj7 | Am7 D7 | Gmaj7 这样的进行，即可查看可能的调性、罗马数字和简短摘要。';

  @override
  String get chordAnalyzerDetectedKeys => '候选调性';

  @override
  String get chordAnalyzerPrimaryReading => '主要解读';

  @override
  String get chordAnalyzerAlternativeReading => '备选解读';

  @override
  String get chordAnalyzerChordAnalysis => '逐和弦分析';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '第 $index 小节';
  }

  @override
  String get chordAnalyzerProgressionSummary => '进行摘要';

  @override
  String get chordAnalyzerWarnings => '警告与歧义';

  @override
  String get chordAnalyzerNoInputError => '请输入要分析的和弦进行。';

  @override
  String get chordAnalyzerNoRecognizedChordsError => '没有找到可识别的和弦标记。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '有些符号被跳过了: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '调性中心在 $primary 和 $alternative 之间仍有一些歧义。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning => '仍有一些和弦比较模糊，因此这份解读会刻意保持保守。';

  @override
  String get chordAnalyzerFunctionTonic => '主功能';

  @override
  String get chordAnalyzerFunctionPredominant => '前属功能';

  @override
  String get chordAnalyzerFunctionDominant => '属功能';

  @override
  String get chordAnalyzerFunctionOther => '其他';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return '可能是指向 $target 的副属和弦。';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '可能是指向 $target 的三全音替代。';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange => '可能是从平行小调借来的调式互换。';

  @override
  String get chordAnalyzerRemarkAmbiguous => '这个和弦在当前解读下仍然有歧义。';

  @override
  String get chordAnalyzerRemarkUnresolved => '仅凭当前保守规则还无法明确判断这个和弦。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 终止';

  @override
  String get chordAnalyzerTagTurnaround => '回转';

  @override
  String get chordAnalyzerTagDominantResolution => '属功能解决';

  @override
  String get chordAnalyzerTagPlagalColor => '变格/调式色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return '这段进行最可能围绕 $key 展开。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '另一种可能的解读是 $key。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '它显示出 $tag 的特征。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from 和 $through 可以理解为通向 $target 的 $fromFunction 与 $throughFunction 和声功能。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord 可以听成是指向 $target 的副属和弦。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord 可以听成是指向 $target 的三全音替代。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord 增添了可能的调式互换色彩。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous => '仍有一些细节存在歧义，因此这份解读会刻意保持保守。';

  @override
  String get chordAnalyzerExamplesTitle => '示例';

  @override
  String get chordAnalyzerConfidenceLabel => '置信度';

  @override
  String get chordAnalyzerAmbiguityLabel => '歧义度';

  @override
  String get chordAnalyzerWhyThisReading => '这样解读的原因';

  @override
  String get chordAnalyzerCompetingReadings => '其他也可能';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '已忽略的修饰符: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '输入警告: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括号不平衡，导致部分符号无法确定。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '已忽略意外出现的右括号。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '明确写出的 $extension 色彩加强了这种解读。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'altered dominant 的色彩支持属功能解读。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '斜线低音 $bass 让低音线或转位信息保持有效。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '下一个和弦支持向 $target 解决。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => '这种色彩可以听成从平行调借来的。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor => '挂留色彩会柔化属功能的拉力，但不会完全抹去它。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '低置信度解读';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '候选调性彼此非常接近，或部分标记只被部分恢复，因此请把它看作谨慎的第一版解读。';

  @override
  String get chordAnalyzerEmptyMeasure => '这一小节为空，但为了保留小节编号仍然显示。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure => '这一小节没有恢复出可分析的和弦标记。';

  @override
  String get chordAnalyzerParseIssuesTitle => '解析问题';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空标记。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => '无法识别根音。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root 不是受支持的根音写法。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return '斜线低音 $bass 不是受支持的写法。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '不支持的后缀或修饰符: $suffix';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get settings => '设置';

  @override
  String get closeSettings => '关闭设置';

  @override
  String get language => '语言';

  @override
  String get systemDefaultLanguage => '系统默认';

  @override
  String get metronome => '节拍器';

  @override
  String get enabled => '开启';

  @override
  String get disabled => '关闭';

  @override
  String get metronomeHelp => '练习时如果想在每一拍都听到点击声，请开启节拍器。';

  @override
  String get metronomeSound => '节拍器音色';

  @override
  String get metronomeSoundClassic => '经典';

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
  String get metronomeVolume => '节拍器音量';

  @override
  String get keys => '调性';

  @override
  String get noKeysSelected =>
      'No keys selected. Leave all keys off to practice in free mode across every root.';

  @override
  String get keysSelectedHelp =>
      'Selected keys are used for key-aware random mode and Smart Generator mode.';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp =>
      'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.';

  @override
  String get advancedSmartGenerator => '高级 Smart Generator';

  @override
  String get modulationIntensity => '转调强度';

  @override
  String get modulationIntensityOff => 'Off';

  @override
  String get modulationIntensityLow => 'Low';

  @override
  String get modulationIntensityMedium => 'Medium';

  @override
  String get modulationIntensityHigh => 'High';

  @override
  String get jazzPreset => '爵士预设';

  @override
  String get jazzPresetStandardsCore => 'Standards Core';

  @override
  String get jazzPresetModulationStudy => 'Modulation Study';

  @override
  String get jazzPresetAdvanced => 'Advanced';

  @override
  String get sourceProfile => '来源配置';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook Standard';

  @override
  String get sourceProfileRecordingInspired => 'Recording Inspired';

  @override
  String get smartDiagnostics => 'Smart 诊断';

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
  String get secondaryDominant => '副属和弦';

  @override
  String get substituteDominant => '替代属和弦';

  @override
  String get modalInterchange => '调式借用';

  @override
  String get modalInterchangeDisabledHelp =>
      'Modal interchange only appears in key mode, so this option is disabled in free mode.';

  @override
  String get rendering => '显示';

  @override
  String get keyCenterLabelStyle => '调性标签样式';

  @override
  String get keyCenterLabelStyleHelp => '可选择显示 major/minor 文本，或使用古典的大写/小写主音标记。';

  @override
  String get chordSymbolStyle => '和弦符号样式';

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
  String get keyCenterLabelStyleModeText => 'C 大调: / C 小调:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'Allow V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => '允许张力音';

  @override
  String get tensionHelp => 'Roman numeral profile and selected chips only';

  @override
  String get inversions => '转位';

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
  String get keyPracticeOverview => '调性练习概览';

  @override
  String get freePracticeOverview => '自由练习概览';

  @override
  String get keyModeTag => '调性模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有调性';

  @override
  String get metronomeOnTag => 'Metronome On';

  @override
  String get metronomeOffTag => 'Metronome Off';

  @override
  String get pressNextChordToBegin => '按下 Next Chord 开始';

  @override
  String get freeModeActive => '自由模式已启用';

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
  String get nextChord => '下一个和弦';

  @override
  String get startAutoplay => '开始自动播放';

  @override
  String get stopAutoplay => '停止自动播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '提高 BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return '允许范围：$min-$max';
  }

  @override
  String get modeMajor => '大调';

  @override
  String get modeMinor => '小调';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'Voicing 建议';

  @override
  String get voicingSuggestionsSubtitle => '查看当前和弦的具体音符选择。';

  @override
  String get voicingSuggestionsEnabled => '启用 Voicing 建议';

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
  String get voicingTopNotePreference => '高音偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      'Leans suggestions toward a chosen top line. Locked voicings win first, then repeated chords keep it steady.';

  @override
  String get voicingTopNotePreferenceAuto => '自动';

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
  String get voicingTopNoteLabel => '高音';

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
  String get voicingSelected => '已选择';

  @override
  String get voicingLocked => '已锁定';

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
  String get openAnalyzer => '打开分析器';

  @override
  String get mainMenuAnalyzerTitle => '和弦分析器';

  @override
  String get mainMenuAnalyzerDescription => '分析输入的和弦进行，给出可能的调性、罗马数字和和声功能。';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.';

  @override
  String get openStudyHarmony => '打开 Study Harmony';

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
  String get chordAnalyzerTitle => '和弦分析器';

  @override
  String get chordAnalyzerSubtitle => '粘贴一段和弦进行，获得保守的和声解读。';

  @override
  String get chordAnalyzerInputLabel => '和弦进行';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '在括号外可以用空格、| 或逗号分隔和弦。括号内的逗号会保留在同一个和弦里作为张力音分隔符。支持小写根音、斜线低音、sus/alt/add 形式，以及 C7(b9, #11) 这类括号张力音。触摸设备可以使用和弦面板或切换到 ABC 输入。';

  @override
  String get chordAnalyzerAnalyze => '分析';

  @override
  String get chordAnalyzerKeyboardTitle => '和弦面板';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '点按符号来拼出进行。需要自由输入时，可以切换到 ABC 输入并继续使用系统键盘。';

  @override
  String get chordAnalyzerKeyboardDesktopHint => '可以直接输入、粘贴，或点按符号插入到光标位置。';

  @override
  String get chordAnalyzerChordPad => '面板';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '粘贴';

  @override
  String get chordAnalyzerClear => '清除';

  @override
  String get chordAnalyzerBackspace => '退格';

  @override
  String get chordAnalyzerSpace => '空格';

  @override
  String get chordAnalyzerAnalyzing => '正在分析进行...';

  @override
  String get chordAnalyzerInitialTitle => '先输入一段进行';

  @override
  String get chordAnalyzerInitialBody =>
      '输入 Dm7 G7 Cmaj7 或 Cmaj7 | Am7 D7 | Gmaj7 这样的进行，即可查看可能的调性、罗马数字和简短摘要。';

  @override
  String get chordAnalyzerDetectedKeys => '候选调性';

  @override
  String get chordAnalyzerPrimaryReading => '主要解读';

  @override
  String get chordAnalyzerAlternativeReading => '备选解读';

  @override
  String get chordAnalyzerChordAnalysis => '逐和弦分析';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '第 $index 小节';
  }

  @override
  String get chordAnalyzerProgressionSummary => '进行摘要';

  @override
  String get chordAnalyzerWarnings => '警告与歧义';

  @override
  String get chordAnalyzerNoInputError => '请输入要分析的和弦进行。';

  @override
  String get chordAnalyzerNoRecognizedChordsError => '没有找到可识别的和弦标记。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '有些符号被跳过了: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '调性中心在 $primary 和 $alternative 之间仍有一些歧义。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning => '仍有一些和弦比较模糊，因此这份解读会刻意保持保守。';

  @override
  String get chordAnalyzerFunctionTonic => '主功能';

  @override
  String get chordAnalyzerFunctionPredominant => '前属功能';

  @override
  String get chordAnalyzerFunctionDominant => '属功能';

  @override
  String get chordAnalyzerFunctionOther => '其他';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return '可能是指向 $target 的副属和弦。';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '可能是指向 $target 的三全音替代。';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange => '可能是从平行小调借来的调式互换。';

  @override
  String get chordAnalyzerRemarkAmbiguous => '这个和弦在当前解读下仍然有歧义。';

  @override
  String get chordAnalyzerRemarkUnresolved => '仅凭当前保守规则还无法明确判断这个和弦。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 终止';

  @override
  String get chordAnalyzerTagTurnaround => '回转';

  @override
  String get chordAnalyzerTagDominantResolution => '属功能解决';

  @override
  String get chordAnalyzerTagPlagalColor => '变格/调式色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return '这段进行最可能围绕 $key 展开。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '另一种可能的解读是 $key。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '它显示出 $tag 的特征。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from 和 $through 可以理解为通向 $target 的 $fromFunction 与 $throughFunction 和声功能。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord 可以听成是指向 $target 的副属和弦。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord 可以听成是指向 $target 的三全音替代。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord 增添了可能的调式互换色彩。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous => '仍有一些细节存在歧义，因此这份解读会刻意保持保守。';

  @override
  String get chordAnalyzerExamplesTitle => '示例';

  @override
  String get chordAnalyzerConfidenceLabel => '置信度';

  @override
  String get chordAnalyzerAmbiguityLabel => '歧义度';

  @override
  String get chordAnalyzerWhyThisReading => '这样解读的原因';

  @override
  String get chordAnalyzerCompetingReadings => '其他也可能';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '已忽略的修饰符: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '输入警告: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括号不平衡，导致部分符号无法确定。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '已忽略意外出现的右括号。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '明确写出的 $extension 色彩加强了这种解读。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'altered dominant 的色彩支持属功能解读。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '斜线低音 $bass 让低音线或转位信息保持有效。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '下一个和弦支持向 $target 解决。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => '这种色彩可以听成从平行调借来的。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor => '挂留色彩会柔化属功能的拉力，但不会完全抹去它。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '低置信度解读';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '候选调性彼此非常接近，或部分标记只被部分恢复，因此请把它看作谨慎的第一版解读。';

  @override
  String get chordAnalyzerEmptyMeasure => '这一小节为空，但为了保留小节编号仍然显示。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure => '这一小节没有恢复出可分析的和弦标记。';

  @override
  String get chordAnalyzerParseIssuesTitle => '解析问题';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空标记。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => '无法识别根音。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root 不是受支持的根音写法。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return '斜线低音 $bass 不是受支持的写法。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '不支持的后缀或修饰符: $suffix';
  }
}
