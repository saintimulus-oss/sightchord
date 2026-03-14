// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get closeSettings => 'Close settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefaultLanguage => 'System default';

  @override
  String get metronome => 'Metronome';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get metronomeHelp =>
      'Turn the metronome on to hear a click on every beat while you practice.';

  @override
  String get metronomeSound => 'Metronome Sound';

  @override
  String get metronomeSoundClassic => 'Classic';

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
  String get metronomeVolume => 'Metronome Volume';

  @override
  String get keys => 'Keys';

  @override
  String get noKeysSelected =>
      'No keys selected. Leave all keys off to practice in free mode across every root.';

  @override
  String get keysSelectedHelp =>
      'Selected keys are used for key-aware random mode and Smart Generator mode.';

  @override
  String get smartGeneratorMode => 'Smart Generator Mode';

  @override
  String get smartGeneratorHelp =>
      'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.';

  @override
  String get advancedSmartGenerator => 'Advanced Smart Generator';

  @override
  String get modulationIntensity => 'Modulation Intensity';

  @override
  String get modulationIntensityOff => 'Off';

  @override
  String get modulationIntensityLow => 'Low';

  @override
  String get modulationIntensityMedium => 'Medium';

  @override
  String get modulationIntensityHigh => 'High';

  @override
  String get jazzPreset => 'Jazz Preset';

  @override
  String get jazzPresetStandardsCore => 'Standards Core';

  @override
  String get jazzPresetModulationStudy => 'Modulation Study';

  @override
  String get jazzPresetAdvanced => 'Advanced';

  @override
  String get sourceProfile => 'Source Profile';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook Standard';

  @override
  String get sourceProfileRecordingInspired => 'Recording Inspired';

  @override
  String get smartDiagnostics => 'Smart Diagnostics';

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
  String get secondaryDominant => 'Secondary Dominant';

  @override
  String get substituteDominant => 'Substitute Dominant';

  @override
  String get modalInterchange => 'Modal Interchange';

  @override
  String get modalInterchangeDisabledHelp =>
      'Modal interchange only appears in key mode, so this option is disabled in free mode.';

  @override
  String get rendering => 'Rendering';

  @override
  String get keyCenterLabelStyle => 'Key Label Style';

  @override
  String get keyCenterLabelStyleHelp =>
      'Choose between explicit mode names and classical uppercase/lowercase tonic labels.';

  @override
  String get chordSymbolStyle => 'Chord Symbol Style';

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
  String get keyCenterLabelStyleModeText => 'C major: / C minor:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'Allow V7sus4 (V7, V7/x)';

  @override
  String get allowTensions => 'Allow Tensions';

  @override
  String get tensionHelp => 'Roman numeral profile and selected chips only';

  @override
  String get inversions => 'Inversions';

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
  String get keyPracticeOverview => 'Key Practice Overview';

  @override
  String get freePracticeOverview => 'Free Practice Overview';

  @override
  String get keyModeTag => 'Key Mode';

  @override
  String get freeModeTag => 'Free Mode';

  @override
  String get allKeysTag => 'All Keys';

  @override
  String get metronomeOnTag => 'Metronome On';

  @override
  String get metronomeOffTag => 'Metronome Off';

  @override
  String get pressNextChordToBegin => 'Press Next Chord to begin';

  @override
  String get freeModeActive => 'Free mode active';

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
  String get nextChord => 'Next Chord';

  @override
  String get audioPlayChord => 'Play Chord';

  @override
  String get audioPlayArpeggio => 'Play Arpeggio';

  @override
  String get audioPlayProgression => 'Play Progression';

  @override
  String get audioPlayPrompt => 'Play Prompt';

  @override
  String get startAutoplay => 'Start Autoplay';

  @override
  String get stopAutoplay => 'Stop Autoplay';

  @override
  String get decreaseBpm => 'Decrease BPM';

  @override
  String get increaseBpm => 'Increase BPM';

  @override
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return 'Allowed range: $min-$max';
  }

  @override
  String get modeMajor => 'major';

  @override
  String get modeMinor => 'minor';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
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
  String get voicingTopNotePreference => 'Top Note Preference';

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
  String get voicingTopNoteLabel => 'Top';

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
  String get openAnalyzer => 'Open Analyzer';

  @override
  String get mainMenuAnalyzerTitle => 'Chord Analyzer';

  @override
  String get mainMenuAnalyzerDescription =>
      'Analyze a written progression for likely key centers, Roman numerals, and harmonic functions.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.';

  @override
  String get openStudyHarmony => 'Open Study Harmony';

  @override
  String get studyHarmonyTitle => 'Study Harmony';

  @override
  String get studyHarmonySubtitle =>
      'Work through a structured harmony hub with quick lesson entries and chapter progress.';

  @override
  String get studyHarmonyPlaceholderTag => 'Study deck';

  @override
  String get studyHarmonyPlaceholderBody =>
      'Lesson data, prompts, and answer surfaces already share one reusable study flow for notes, chords, scales, and progression drills.';

  @override
  String get studyHarmonyTestLevelTag => 'Practice drill';

  @override
  String get studyHarmonyTestLevelAction => 'Open drill';

  @override
  String get studyHarmonySubmit => 'Submit';

  @override
  String get studyHarmonyNextPrompt => 'Next prompt';

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
  String studyHarmonyProgressStars(int stars) {
    return '$stars stars';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return '$mastered/$total skills mastered';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count reviews ready';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'Streak x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count runs';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'Best $rank';
  }

  @override
  String get studyHarmonyBossTag => 'Boss';

  @override
  String get studyHarmonyContinueCardTitle => 'Continue';

  @override
  String get studyHarmonyContinueResumeHint =>
      'Resume the lesson you touched most recently.';

  @override
  String get studyHarmonyContinueFrontierHint =>
      'Jump to the next lesson at your current frontier.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return 'Continue: $lessonTitle';
  }

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
      'Open today\'s deterministic pick from your unlocked lessons.';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      'Today\'s daily is cleared. Replay it if you want, or come back tomorrow to keep the streak going.';

  @override
  String get studyHarmonyDailyAction => 'Play daily';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'Seed $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => 'Daily cleared today';

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
  String get studyHarmonyModeLegacy => 'Practice Mode';

  @override
  String get studyHarmonyShortcutHint =>
      'Enter submits or moves on. R restarts. 1-9 chooses an answer. Tab and Shift+Tab move focus.';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$remaining of $total lives remaining';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'Skill gains';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'Review focus';

  @override
  String get studyHarmonyResultRewardTitle => 'Session reward';

  @override
  String get studyHarmonyBonusGoalsTitle => 'Bonus goals';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'Rank $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars stars';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return 'Best $rank · $stars stars';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return 'Daily streak x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => 'New personal best';

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
  String get studyHarmonyQuestBoardTitle => 'Quest Board';

  @override
  String get studyHarmonyQuestCompletedTag => 'Completed';

  @override
  String get studyHarmonyQuestTodayTag => 'Today';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target complete';
  }

  @override
  String get studyHarmonyQuestDailyTitle => 'Daily streak';

  @override
  String get studyHarmonyQuestDailyBody =>
      'Clear today\'s seeded mix to extend your streak.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      'Today\'s daily is already cleared. The streak is safe for now.';

  @override
  String get studyHarmonyQuestFrontierTitle => 'Frontier push';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return 'Clear $lessonTitle to move the path forward.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'Every currently unlocked lesson is cleared. Replay a boss or chase more stars.';

  @override
  String get studyHarmonyQuestStarsTitle => 'Star hunt';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return 'Push extra stars inside $chapterTitle.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback =>
      'Push extra stars in your current chapter.';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'Combo x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'Best combo x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'Keep all hearts';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return 'Reach $percent% accuracy';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'Reach combo x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'Bonus sweep';

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
    return '$count cleared';
  }

  @override
  String get studyHarmonyOpenChapterAction => 'Open chapter';

  @override
  String get studyHarmonyLockedChapterTag => 'Locked chapter';

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
    return 'This track is still locked. Switch back to $coreTrack to keep studying today.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Core Track';

  @override
  String get studyHarmonyCoreTrackDescription =>
      'Start with notes and the keyboard, then build up through chords, scales, Roman numerals, diatonic basics, and short progression analysis.';

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
  String get studyHarmonyChapterCheckpointTitle => 'Checkpoint Gauntlet';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'Combine key-center, function, color, and fill-in drills in faster mixed review sets.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => 'Cadence Rush';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      'Read the harmonic role quickly, then plug the missing cadential chord under light pressure.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => 'Color and Key Shift';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'Switch between center detection and non-diatonic color calls without losing the thread.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle =>
      'Boss: Checkpoint Gauntlet';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'Clear one integrated checkpoint that mixes key-center, function, color, and cadence repair prompts.';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'Capstone Trials';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'Finish the core path with tougher mixed progression rounds that ask for speed, color hearing, and clean resolution choices.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'Turnaround Relay';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'Swap between function reading and missing-chord repair across compact turnarounds.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle =>
      'Borrowed Color Calls';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'Catch modal color quickly, then confirm the key center before it slips away.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => 'Resolution Lab';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      'Track where each phrase wants to land and choose the chord that best resolves the motion.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle =>
      'Boss: Final Progression Exam';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'Pass one final mixed exam with center, function, color, and resolution all under pressure.';

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
  String get chordAnalyzerTitle => 'Chord Analyzer';

  @override
  String get chordAnalyzerSubtitle =>
      'Paste a progression and get a conservative harmonic reading.';

  @override
  String get chordAnalyzerInputLabel => 'Chord progression';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      'Separators outside parentheses can be spaces, |, or commas. Commas inside parentheses stay inside one chord. Lowercase roots, slash bass, sus/alt/add forms, and tensions such as C7(b9, #11) are supported. Touch devices can use the chord pad or switch to ABC input.';

  @override
  String get chordAnalyzerAnalyze => 'Analyze';

  @override
  String get chordAnalyzerKeyboardTitle => 'Chord Pad';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'Tap tokens to build a progression. ABC input keeps the system keyboard available when you need free typing.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      'Type, paste, or tap tokens to insert them at the cursor.';

  @override
  String get chordAnalyzerChordPad => 'Pad';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => 'Paste';

  @override
  String get chordAnalyzerClear => 'Clear';

  @override
  String get chordAnalyzerBackspace => 'Backspace';

  @override
  String get chordAnalyzerSpace => 'Space';

  @override
  String get chordAnalyzerAnalyzing => 'Analyzing progression...';

  @override
  String get chordAnalyzerInitialTitle => 'Start with a progression';

  @override
  String get chordAnalyzerInitialBody =>
      'Enter a progression such as Dm7 G7 Cmaj7 or Cmaj7 | Am7 D7 | Gmaj7 to see likely keys, Roman numerals, and a short summary.';

  @override
  String get chordAnalyzerDetectedKeys => 'Detected Keys';

  @override
  String get chordAnalyzerPrimaryReading => 'Primary reading';

  @override
  String get chordAnalyzerAlternativeReading => 'Alternative reading';

  @override
  String get chordAnalyzerChordAnalysis => 'Chord-by-chord analysis';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return 'Measure $index';
  }

  @override
  String get chordAnalyzerProgressionSummary => 'Progression summary';

  @override
  String get chordAnalyzerWarnings => 'Warnings and ambiguities';

  @override
  String get chordAnalyzerNoInputError =>
      'Enter a chord progression to analyze.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      'No recognizable chords were found in the progression.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return 'Some symbols were skipped: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'The key center is still somewhat ambiguous between $primary and $alternative.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      'Some chords stay ambiguous, so this reading remains intentionally conservative.';

  @override
  String get chordAnalyzerFunctionTonic => 'Tonic';

  @override
  String get chordAnalyzerFunctionPredominant => 'Predominant';

  @override
  String get chordAnalyzerFunctionDominant => 'Dominant';

  @override
  String get chordAnalyzerFunctionOther => 'Other';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return 'Possible secondary dominant targeting $target.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return 'Possible tritone substitute targeting $target.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      'Possible modal interchange from the parallel minor.';

  @override
  String get chordAnalyzerRemarkAmbiguous =>
      'This chord stays ambiguous in the current reading.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'This chord stays unresolved under the current conservative heuristics.';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I cadence';

  @override
  String get chordAnalyzerTagTurnaround => 'Turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => 'Dominant resolution';

  @override
  String get chordAnalyzerTagPlagalColor => 'Plagal/modal color';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'This progression most likely centers on $key.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return 'An alternative reading is $key.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return 'It suggests a $tag.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from and $through behave like $fromFunction and $throughFunction chords leading into $target.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord can be heard as a possible secondary dominant pointing toward $target.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord can be heard as a possible tritone substitute pointing toward $target.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord adds a possible modal interchange color.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      'Some details remain ambiguous, so this reading stays intentionally conservative.';

  @override
  String get chordAnalyzerExamplesTitle => 'Examples';

  @override
  String get chordAnalyzerConfidenceLabel => 'Confidence';

  @override
  String get chordAnalyzerAmbiguityLabel => 'Ambiguity';

  @override
  String get chordAnalyzerWhyThisReading => 'Why this reading';

  @override
  String get chordAnalyzerCompetingReadings => 'Also plausible';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return 'Ignored modifiers: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return 'Input warning: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      'Unbalanced parentheses left part of the symbol uncertain.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      'An unexpected closing parenthesis was ignored.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return 'Explicit $extension color strengthens this reading.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'Altered dominant color supports a dominant function.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'Slash bass $bass keeps the bass line or inversion meaningful.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return 'The next chord supports a resolution toward $target.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      'This color can be heard as borrowed from the parallel mode.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'Suspension color softens the dominant pull without erasing it.';

  @override
  String get chordAnalyzerLowConfidenceTitle => 'Low-confidence reading';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'The key candidates are close together or some symbols were only partially recovered, so treat this as a cautious first pass.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      'This measure is empty and was preserved in the count.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'No analyzable chord symbols were recovered in this measure.';

  @override
  String get chordAnalyzerParseIssuesTitle => 'Parse issues';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => 'Empty token.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot =>
      'The root could not be recognized.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root is not a supported root spelling.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'Slash bass $bass is not a supported bass spelling.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return 'Unsupported suffix or modifier: $suffix';
  }

  @override
  String get studyHarmonyDailyReplayAction => 'Replay daily';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'Milestone Medals';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'Pathfinder Medal';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Clear $target lessons in Core Foundations.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'Star Collector';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Collect $target stars across Study Harmony.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'Streak Legend';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return 'Reach a best daily streak of $target.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => 'Mastery Scholar';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return 'Master $target skills.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return '$earned/$total medals earned';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'Cabinet complete';

  @override
  String get studyHarmonyMilestoneTierBronze => 'Bronze Medal';

  @override
  String get studyHarmonyMilestoneTierSilver => 'Silver Medal';

  @override
  String get studyHarmonyMilestoneTierGold => 'Gold Medal';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'Platinum Medal';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$tier $title';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => 'New medals';

  @override
  String get studyHarmonyChapterRemixTitle => 'Remix Arena';

  @override
  String get studyHarmonyChapterRemixDescription =>
      'Longer mixed sets that shuffle key center, function, and borrowed color without warning.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => 'Bridge Builder';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'Stitch function reads and missing-chord fills into one flowing chain.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'Color Pivot';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      'Track borrowed color and key-center pivots as the progression shifts underneath you.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => 'Resolution Sprint';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      'Read function, cadence fill, and tonal gravity back-to-back at a quicker pace.';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'Remix Marathon';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      'A final mixed marathon that throws every progression-reading lens back into the set.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'Savers x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'Legend crowns $count';
  }

  @override
  String get studyHarmonyModeFocus => 'Focus Mode';

  @override
  String get studyHarmonyModeLegend => 'Legend Trial';

  @override
  String get studyHarmonyFocusCardTitle => 'Focus Sprint';

  @override
  String get studyHarmonyFocusCardHint =>
      'Target the weakest overlap in your current path with fewer lives and tighter goals.';

  @override
  String get studyHarmonyFocusFallbackHint =>
      'Run a harder mixed drill to pressure-test your current weak spots.';

  @override
  String get studyHarmonyFocusAction => 'Start sprint';

  @override
  String get studyHarmonyFocusSessionTitle => 'Focus Sprint';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return 'A tighter mixed sprint built from the weakest spots around $chapter.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count lessons mixed';
  }

  @override
  String get studyHarmonyFocusRewardLabel => 'Weekly saver reward';

  @override
  String get studyHarmonyLegendCardTitle => 'Legend Trial';

  @override
  String get studyHarmonyLegendCardHint =>
      'Replay a silver-or-better chapter as a two-life mastery run to secure a legend crown.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'Finish a chapter and push it to about 2 stars per lesson to unlock a Legend Trial.';

  @override
  String get studyHarmonyLegendAction => 'Chase legend';

  @override
  String get studyHarmonyLegendSessionTitle => 'Legend Trial';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return 'A no-slack mastery replay of $chapter built to secure its legend crown.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count lessons chained';
  }

  @override
  String get studyHarmonyLegendRiskLabel => 'Legend crown at stake';

  @override
  String get studyHarmonyWeeklyPlanTitle => 'Weekly Training Plan';

  @override
  String get studyHarmonyWeeklyRewardLabel => 'Reward: Streak Saver';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => 'Reward ready';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => 'Reward claimed';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle =>
      'Show up on multiple days';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return 'Be active on $target different days this week.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle => 'Keep the daily loop alive';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return 'Log $target daily clears this week.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle => 'Finish a Focus Sprint';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return 'Complete $target Focus Sprints this week.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      'Streak Saver used to protect yesterday.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return 'New Streak Saver earned. Inventory: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => 'Focus Sprint cleared.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return 'Legend crown secured for $chapter.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'Encore Ladder';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      'A short finishing ladder that compresses the whole progression toolkit into a final encore set.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'Tonal Pulse';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'Lock in tonal center and function without any warm-up prompts.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'Color Swap';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      'Alternate borrowed color calls with missing-chord restoration to keep the ear honest.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'Encore Finale';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'One last compact boss round that checks every progression lens in quick succession.';

  @override
  String get studyHarmonyChapterMasteryBronze => 'Bronze Clear';

  @override
  String get studyHarmonyChapterMasterySilver => 'Silver Crown';

  @override
  String get studyHarmonyChapterMasteryGold => 'Gold Crown';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'Legend Crown';

  @override
  String get studyHarmonyModeBossRush => 'Boss Rush Mode';

  @override
  String get studyHarmonyBossRushCardTitle => 'Boss Rush';

  @override
  String get studyHarmonyBossRushCardHint =>
      'Chain together the unlocked boss lessons with fewer lives and a bigger score ceiling.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      'Unlock at least two boss lessons to open a real mixed boss run.';

  @override
  String get studyHarmonyBossRushAction => 'Start rush';

  @override
  String get studyHarmonyBossRushSessionTitle => 'Boss Rush';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return 'A high-pressure boss gauntlet built from the unlocked boss lessons around $chapter.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count boss lessons mixed';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => '2 lives only';

  @override
  String get studyHarmonyResultBossRushLine => 'Boss Rush cleared.';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'Spotlight Showdown';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      'A final spotlight set that isolates borrowed color, cadence pressure, and boss-level integration.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => 'Borrowed Lens';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      'Track key center while borrowed color keeps trying to pull your read sideways.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => 'Cadence Swap';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      'Switch between function reading and cadence restoration without losing the landing point.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'Spotlight Showdown';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'A closing boss set that forces every progression lens to stay sharp under pressure.';

  @override
  String get studyHarmonyChapterAfterHoursTitle => 'After Hours Lab';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'A late-game lab that strips away warm-up clues and mixes borrowed color, cadence pressure, and center tracking.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'Modal Shadow';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      'Keep hold of the key center while borrowed color keeps dragging the read into the dark.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => 'Resolution Feint';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'Catch function and cadence fakeouts before the phrase slips past its true landing spot.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => 'Center Crossfade';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      'Blend center detection, function reading, and missing-chord repair without any extra scaffolding.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'Last Call Boss';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'A final late-night boss set that asks every progression lens to stay clear under pressure.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'Relay wins $count';
  }

  @override
  String get studyHarmonyModeRelay => 'Arena Relay';

  @override
  String get studyHarmonyRelayCardTitle => 'Arena Relay';

  @override
  String get studyHarmonyRelayCardHint =>
      'Interleave unlocked lessons from different chapters into one mixed run that tests fast switching as much as raw recall.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'Unlock at least two chapters to open Arena Relay.';

  @override
  String get studyHarmonyRelayAction => 'Start relay';

  @override
  String get studyHarmonyRelaySessionTitle => 'Arena Relay';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return 'An interleaved relay run mixing unlocked chapters around $chapter.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return '$count lessons relayed';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count chapters mixed';
  }

  @override
  String get studyHarmonyRelayChainLabel => 'Interleaving under pressure';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'Relay wins $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'Relay Runner';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return 'Clear $target Arena Relay runs.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'Neon Detours';

  @override
  String get studyHarmonyChapterNeonDescription =>
      'A late-game chapter that keeps bending the path with borrowed color, pivot pressure, and recovery reads.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'Modal Detour';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      'Track the true center even while borrowed color keeps shoving the phrase into a side street.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'Pivot Pressure';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      'Read center shifts and function pressure back to back before the harmonic lane changes again.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => 'Borrowed Landing';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      'Repair the missing landing chord after a borrowed-color fakeout changes the expected resolution.';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'City Lights Boss';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'A closing neon boss that mixes pivot reads, borrowed color, and cadence recovery without a soft landing.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tier league';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'Harmony League';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return 'Push toward $tier league this week. The cleanest boost right now is $mode.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      'Diamond is secured for this week. Keep chaining high-pressure clears to hold the pace.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      'Your league climb will light up once there is a recommended run to push this week.';

  @override
  String get studyHarmonyLeagueAction => 'Climb league';

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score XP this week';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target XP this week';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return 'Next: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return 'Best boost: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'League XP +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return 'Promoted to $tier league';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'Rookie';

  @override
  String get studyHarmonyLeagueTierBronze => 'Bronze';

  @override
  String get studyHarmonyLeagueTierSilver => 'Silver';

  @override
  String get studyHarmonyLeagueTierGold => 'Gold';

  @override
  String get studyHarmonyLeagueTierDiamond => 'Diamond';

  @override
  String get studyHarmonyChapterMidnightTitle => 'Midnight Switchboard';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      'A final control-room chapter that forces fast reads across drifting centers, false cadences, and borrowed reroutes.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'Signal Drift';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      'Track the true tonal signal even while the surface keeps drifting into borrowed color.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => 'False Line';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      'Read function pressure through fake resolutions before the line folds back into place.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => 'Borrowed Reroute';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      'Recover the expected landing after borrowed color reroutes the phrase midstream.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'Blackout Boss';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      'A closing blackout set that mixes every late-game lens without giving you a safe reset.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'Quest chests $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x league XP x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'Quest Chest';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count quests left';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'Quest Chest ready';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => 'Quest Chest opened';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x League XP live';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return 'Reward: +$xp league XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      'Finish today\'s quest trio to cash out a bonus chest and keep the weekly climb moving.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      'All three quests are done. Clear one more run to cash out today\'s chest bonus.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      'Today\'s trio is complete and the chest bonus has already been converted into league XP.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return 'Today\'s chest is open and 2x League XP is active for your next $count clears.';
  }

  @override
  String get studyHarmonyQuestChestAction => 'Finish trio';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'Best finish: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'Daily quests $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'Quest Chest opened.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'Quest Chest bonus +$count League XP';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '2x League XP boost ready for the next $count clears';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'Boost bonus +$count League XP';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return '2x boost clears left $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return '2x League XP is live for $count clears. Spend it on $mode while the boost lasts.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'Skyline Circuit';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'A final skyline circuit that forces fast mixed reads across ghosted centers, borrowed gravity, and false homes.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => 'Afterimage Pulse';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'Catch center and function in the afterimage before the phrase locks into a new lane.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => 'Gravity Swap';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      'Handle borrowed gravity and missing-chord repair while the progression keeps swapping its weight.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => 'False Home';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      'Read through the false arrival and rebuild the true landing before the progression snaps shut.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => 'Final Signal Boss';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'A last skyline boss that chains every late-game progression lens into one closing signal test.';

  @override
  String get studyHarmonyChapterAfterglowTitle => 'Afterglow Runway';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'A closing runway of split decisions, borrowed bait, and flickering centers that rewards clean late-game reads under pressure.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => 'Split Decision';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'Choose the repair chord that keeps the function moving without letting the phrase drift off course.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => 'Borrowed Lure';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      'Spot the borrowed color chord that looks like a pivot before the progression snaps back home.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => 'Center Flicker';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'Hold the tonal center while cadence cues blink and reroute in quick succession.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => 'Redline Return Boss';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'A final mixed test of key center, function, borrowed color, and missing-chord repair at full speed.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'Tour stamps $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'Monthly tour cleared';

  @override
  String get studyHarmonyTourTitle => 'Harmony Tour';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return '$count/$target tour stamps';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'Tour finale ready';

  @override
  String get studyHarmonyTourClaimedHeadline => 'Monthly tour cleared';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return 'Reward: +$xp league XP and $count Streak Saver';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return 'Show up on $target different days this month to lock in the tour bonus.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return 'Open $target Quest Chests this month to keep the tour stamp book moving.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return 'Clear $target spotlight runs this month. Boss Rush, Relay, Focus, Legend, and boss lessons all count.';
  }

  @override
  String get studyHarmonyTourReadyBody =>
      'Every monthly stamp is in. One more clear locks in the tour bonus.';

  @override
  String get studyHarmonyTourClaimedBody =>
      'This month\'s tour is complete. Keep the rhythm sharp so next month\'s route starts hot.';

  @override
  String get studyHarmonyTourAction => 'Advance tour';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return 'Active days $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Quest Chests $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Spotlights $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Harmony Tour complete';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'Tour bonus +$count League XP';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Streak Saver stock $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => 'Daybreak Frequency';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'A sunrise encore of ghost cadences, false dawn pivots, and borrowed blooms that forces clean late-game reads after a long run.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => 'Ghost Cadence';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'Repair the cadence and function at the same time when the phrase pretends to close without actually landing.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => 'False Dawn';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      'Catch the center shift hiding inside a too-early sunrise before the progression pulls away again.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => 'Borrowed Bloom';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      'Track borrowed color and function together while the harmony opens into a brighter but unstable lane.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => 'Sunrise Overdrive Boss';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'A final dawn-speed boss that chains key center, function, non-diatonic color, and missing-chord repair into one last overdrive set.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'Duet streak $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'Duet Pact';

  @override
  String get studyHarmonyDuetStartHeadline => 'Start today\'s duet';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'Duet streak $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return 'Duet locked for day $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return 'Reward: +$xp league XP at key streaks';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'Clear today\'s Daily first, then land one spotlight run to keep the duet alive.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Daily is in. Finish one spotlight run like Focus, Relay, Boss Rush, Legend, or a boss lesson to seal the duet.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return 'Today\'s duet is sealed and the shared streak is now $count days long.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Daily in';

  @override
  String get studyHarmonyDuetDailyMissing => 'Daily missing';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Spotlight in';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Spotlight missing';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return 'Daily $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'Spotlight $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'Streak $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'Keep duet going';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'Duet streak $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'Duet reward +$count League XP';
  }

  @override
  String get studyHarmonyChapterBlueHourTitle => 'Blue Hour Exchange';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      'A twilight encore of crossing currents, haloed borrows, and dual horizons that keeps late-game reads unstable in the best way.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => 'Cross Current';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'Track key center and function while the progression starts pulling in two directions at once.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => 'Halo Borrow';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      'Read the borrowed color and restore the missing chord before the phrase turns hazy.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => 'Dual Horizon';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      'Hold the real arrival point while two possible horizons keep flashing in and out.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'Twin Lanterns Boss';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'A final blue-hour boss that forces fast swaps across center, function, borrowed color, and missing-chord repair.';
}
