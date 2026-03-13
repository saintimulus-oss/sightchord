// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settings => '設定';

  @override
  String get closeSettings => '設定を閉じる';

  @override
  String get language => '言語';

  @override
  String get systemDefaultLanguage => 'システム既定';

  @override
  String get metronome => 'メトロノーム';

  @override
  String get enabled => 'オン';

  @override
  String get disabled => 'オフ';

  @override
  String get metronomeHelp => '練習中に各拍でクリックを鳴らすにはメトロノームをオンにします。';

  @override
  String get metronomeSound => 'メトロノーム音';

  @override
  String get metronomeSoundClassic => 'クラシック';

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
  String get metronomeVolume => 'メトロノーム音量';

  @override
  String get keys => 'キー';

  @override
  String get noKeysSelected =>
      'No keys selected. Leave all keys off to practice in free mode across every root.';

  @override
  String get keysSelectedHelp =>
      'Selected keys are used for key-aware random mode and Smart Generator mode.';

  @override
  String get smartGeneratorMode => 'Smart Generator モード';

  @override
  String get smartGeneratorHelp =>
      'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.';

  @override
  String get advancedSmartGenerator => '高度な Smart Generator';

  @override
  String get modulationIntensity => '転調の強さ';

  @override
  String get modulationIntensityOff => 'Off';

  @override
  String get modulationIntensityLow => 'Low';

  @override
  String get modulationIntensityMedium => 'Medium';

  @override
  String get modulationIntensityHigh => 'High';

  @override
  String get jazzPreset => 'ジャズプリセット';

  @override
  String get jazzPresetStandardsCore => 'Standards Core';

  @override
  String get jazzPresetModulationStudy => 'Modulation Study';

  @override
  String get jazzPresetAdvanced => 'Advanced';

  @override
  String get sourceProfile => 'ソースプロファイル';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook Standard';

  @override
  String get sourceProfileRecordingInspired => 'Recording Inspired';

  @override
  String get smartDiagnostics => 'Smart 診断';

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
  String get secondaryDominant => 'セカンダリードミナント';

  @override
  String get substituteDominant => 'サブスティテュートドミナント';

  @override
  String get modalInterchange => 'モーダルインターチェンジ';

  @override
  String get modalInterchangeDisabledHelp =>
      'Modal interchange only appears in key mode, so this option is disabled in free mode.';

  @override
  String get rendering => '表記';

  @override
  String get keyCenterLabelStyle => 'キー表示スタイル';

  @override
  String get keyCenterLabelStyleHelp =>
      'メジャー/マイナー表記と、クラシック式の大文字/小文字トニック表記から選べます。';

  @override
  String get chordSymbolStyle => 'コード記号スタイル';

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
  String get keyCenterLabelStyleModeText => 'C メジャー: / C マイナー:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'Allow V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'テンションを許可';

  @override
  String get tensionHelp => 'Roman numeral profile and selected chips only';

  @override
  String get inversions => '転回形';

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
  String get keyPracticeOverview => 'キー練習の概要';

  @override
  String get freePracticeOverview => 'フリー練習の概要';

  @override
  String get keyModeTag => 'キーモード';

  @override
  String get freeModeTag => 'フリーモード';

  @override
  String get allKeysTag => 'すべてのキー';

  @override
  String get metronomeOnTag => 'Metronome On';

  @override
  String get metronomeOffTag => 'Metronome Off';

  @override
  String get pressNextChordToBegin => '開始するには Next Chord を押してください';

  @override
  String get freeModeActive => 'フリーモード有効';

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
  String get nextChord => '次のコード';

  @override
  String get startAutoplay => '自動再生を開始';

  @override
  String get stopAutoplay => '自動再生を停止';

  @override
  String get decreaseBpm => 'BPM を下げる';

  @override
  String get increaseBpm => 'BPM を上げる';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return '許容範囲: $min-$max';
  }

  @override
  String get modeMajor => '長調';

  @override
  String get modeMinor => '短調';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'ボイシング提案';

  @override
  String get voicingSuggestionsSubtitle => 'このコードに合う具体的な音の選択を表示します。';

  @override
  String get voicingSuggestionsEnabled => 'ボイシング提案を有効化';

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
  String get voicingTopNotePreference => 'トップノートの好み';

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
  String get voicingTopNoteLabel => 'トップ';

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
  String get voicingSelected => '選択中';

  @override
  String get voicingLocked => '固定中';

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
  String get openAnalyzer => 'アナライザーを開く';

  @override
  String get mainMenuAnalyzerTitle => 'コードアナライザー';

  @override
  String get mainMenuAnalyzerDescription => '入力した進行から、あり得るキー、ローマ数字、和声機能を推定します。';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.';

  @override
  String get openStudyHarmony => 'Study Harmony を開く';

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
  String get chordAnalyzerTitle => 'コードアナライザー';

  @override
  String get chordAnalyzerSubtitle => '進行を貼り付けると、保守的な和声解釈を表示します。';

  @override
  String get chordAnalyzerInputLabel => 'コード進行';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '括弧の外では、空白、|、カンマでコードを区切れます。括弧内のカンマは同じコード内のテンション区切りとして保持されます。小文字ルート、スラッシュベース、sus/alt/add 表記、C7(b9, #11) のような括弧付きテンションに対応しています。タッチ端末ではコードパッドと ABC 入力を切り替えられます。';

  @override
  String get chordAnalyzerAnalyze => '解析';

  @override
  String get chordAnalyzerKeyboardTitle => 'コードパッド';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'トークンをタップして進行を組み立てます。自由入力が必要なときは ABC 入力に切り替えるとシステムキーボードを使い続けられます。';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      '入力、貼り付け、またはトークンのタップでカーソル位置に挿入できます。';

  @override
  String get chordAnalyzerChordPad => 'パッド';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '貼り付け';

  @override
  String get chordAnalyzerClear => 'クリア';

  @override
  String get chordAnalyzerBackspace => 'バックスペース';

  @override
  String get chordAnalyzerSpace => 'スペース';

  @override
  String get chordAnalyzerAnalyzing => '進行を解析中...';

  @override
  String get chordAnalyzerInitialTitle => '進行を入力してください';

  @override
  String get chordAnalyzerInitialBody =>
      'Dm7 G7 Cmaj7 や Cmaj7 | Am7 D7 | Gmaj7 のような進行を入力すると、候補キー、ローマ数字、短い要約を確認できます。';

  @override
  String get chordAnalyzerDetectedKeys => '候補キー';

  @override
  String get chordAnalyzerPrimaryReading => '第一候補';

  @override
  String get chordAnalyzerAlternativeReading => '別候補';

  @override
  String get chordAnalyzerChordAnalysis => 'コードごとの解析';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '$index小節';
  }

  @override
  String get chordAnalyzerProgressionSummary => '進行の要約';

  @override
  String get chordAnalyzerWarnings => '警告とあいまいさ';

  @override
  String get chordAnalyzerNoInputError => '解析するコード進行を入力してください。';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      '進行内に認識可能なコード表記が見つかりませんでした。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '一部の記号はスキップされました: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'キー中心は $primary と $alternative の間でまだやや曖昧です。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'いくつかのコードはなお曖昧なので、この読みは意図的に保守的なままにしています。';

  @override
  String get chordAnalyzerFunctionTonic => 'トニック';

  @override
  String get chordAnalyzerFunctionPredominant => 'プレドミナント';

  @override
  String get chordAnalyzerFunctionDominant => 'ドミナント';

  @override
  String get chordAnalyzerFunctionOther => 'その他';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return '$target に向かうセカンダリー・ドミナントの可能性があります。';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '$target に向かうトライトーン・サブの可能性があります。';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      '平行短調からのモーダルインターチェンジの可能性があります。';

  @override
  String get chordAnalyzerRemarkAmbiguous => 'このコードは現在の読みではなお曖昧です。';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'このコードは現在の保守的なヒューリスティクスだけでは確定できません。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I カデンツ';

  @override
  String get chordAnalyzerTagTurnaround => 'ターンアラウンド';

  @override
  String get chordAnalyzerTagDominantResolution => 'ドミナント解決';

  @override
  String get chordAnalyzerTagPlagalColor => 'プラガル/モーダルな色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'この進行の中心は $key である可能性が最も高いです。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '別の読みとして $key も考えられます。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'これは $tag を示しています。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from と $through は $target に向かう $fromFunction と $throughFunction の機能として捉えられます。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord は $target に向かうセカンダリー・ドミナントとして聞こえる可能性があります。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord は $target に向かうトライトーン・サブとして聞こえる可能性があります。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord がモーダルインターチェンジの色彩を加えています。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous => 'いくつかの細部はまだ曖昧なため、この読みは意図的に保守的です。';

  @override
  String get chordAnalyzerExamplesTitle => '例';

  @override
  String get chordAnalyzerConfidenceLabel => '信頼度';

  @override
  String get chordAnalyzerAmbiguityLabel => '曖昧さ';

  @override
  String get chordAnalyzerWhyThisReading => 'この読みの根拠';

  @override
  String get chordAnalyzerCompetingReadings => '他にもあり得る読み';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '無視された modifier: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '入力警告: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括弧の対応が崩れていたため、記号の一部が不確かになりました。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '予期しない閉じ括弧は無視されました。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '明示された $extension の色彩がこの読みを強めます。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'オルタード・ドミナントの色彩がドミナント機能を支えています。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'スラッシュベース $bass がベースラインや転回の意味を保っています。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '次のコードが $target への解決を支えています。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => 'この色彩は平行調から借用されたものとして聞こえます。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'サスペンションの色彩がドミナントの引力を消さずに和らげています。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '信頼度の低い読み';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '候補キー同士が近いか、一部の記号が部分的にしか復元できなかったため、慎重な一次解釈として扱ってください。';

  @override
  String get chordAnalyzerEmptyMeasure => 'この小節は空ですが、小節番号を保つためにそのまま表示しています。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'この小節では解析可能なコード表記を復元できませんでした。';

  @override
  String get chordAnalyzerParseIssuesTitle => 'パース上の問題';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空のトークンです。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => 'ルート音を認識できませんでした。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root は対応しているルート表記ではありません。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'スラッシュベース $bass は対応している表記ではありません。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '未対応の suffix / modifier です: $suffix';
  }
}
