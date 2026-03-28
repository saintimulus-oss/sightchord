// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get closeSettings => 'Close settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefaultLanguage => 'System default';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

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
  String get setupAssistantNotationDelta => 'C?7 style';

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
  String get chordTypeFilters => 'Chord Types';

  @override
  String get chordTypeFiltersHelp =>
      'Choose which chord types can appear in the generator.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total enabled';
  }

  @override
  String get chordTypeGroupTriads => 'Triads';

  @override
  String get chordTypeGroupSevenths => 'Sevenths';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sixths & Added Tone';

  @override
  String get chordTypeGroupDominantVariants => 'Dominant Variants';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 is available only when at least one key is selected.';

  @override
  String get chordTypeKeepOneEnabled => 'Keep at least one chord type enabled.';

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
      'Space: next chord  Enter: start or pause autoplay  Up/Down: adjust BPM';

  @override
  String get currentChord => 'Current Chord';

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
  String get pauseAutoplay => 'Pause Autoplay';

  @override
  String get stopAutoplay => 'Stop Autoplay';

  @override
  String get resetGeneratedChords => 'Reset Generated Chords';

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
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

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
      'Generate your next chord loop in Chordest, then use Analyzer for a cautious harmony read when you need context.';

  @override
  String get mainMenuGeneratorTitle => 'Chordest Generator';

  @override
  String get mainMenuGeneratorDescription =>
      'Start with a playable chord loop, voicing support, and quick practice controls.';

  @override
  String get openGenerator => 'Start Practice';

  @override
  String get openAnalyzer => 'Analyze Progression';

  @override
  String get mainMenuAnalyzerTitle => 'Chord Analyzer';

  @override
  String get mainMenuAnalyzerDescription =>
      'Check likely keys, Roman numerals, and warnings with a conservative progression read.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Continue lessons, review chapters, and build practical harmony fluency.';

  @override
  String get openStudyHarmony => 'Start Study Harmony';

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
      'Pulled from your current review queue.';

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
    return 'Best $rank 쨌 $stars stars';
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
      'Run the full harmony path in a pop lane with its own progress, daily picks, and review queue.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Jazz Track';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practice the full curriculum in a jazz lane with separate progress, daily picks, and review queue.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Classical Track';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Study the full curriculum in a classical lane with independent progress, daily picks, and review queue.';

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
      'Paste a progression to get a conservative read of likely keys, Roman numerals, and harmonic function.';

  @override
  String get chordAnalyzerInputLabel => 'Chord progression';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Use spaces, |, or commas between chords. Commas inside parentheses stay in the same chord.\n\nUse ? for an unknown chord slot. The analyzer will infer the most natural fill from context and surface alternatives when the reading is ambiguous.\n\nLowercase roots, slash bass, sus/alt/add forms, and tensions like C7(b9, #11) are supported.\n\nOn touch devices, use the chord pad or switch to ABC input when you want free typing.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Input tips';

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
  String get chordAnalyzerClear => 'Reset';

  @override
  String get chordAnalyzerBackspace => 'Backspace';

  @override
  String get chordAnalyzerSpace => 'Spacebar';

  @override
  String get chordAnalyzerAnalyzing => 'Analyzing progression...';

  @override
  String get chordAnalyzerInitialTitle => 'Start with a progression';

  @override
  String get chordAnalyzerInitialBody =>
      'Enter a progression such as Dm7, G7 | ? Am or Cmaj7 | Am7 D7 | Gmaj7 to see likely keys, Roman numerals, warnings, inferred fills, and a short summary.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'This ? was inferred from the surrounding harmonic context, so treat it as a suggested fill rather than a certainty.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Suggested fill: $chord';
  }

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
  String get chordAnalyzerGenerateVariations => 'Create Variations';

  @override
  String get chordAnalyzerVariationsTitle => 'Natural variations';

  @override
  String get chordAnalyzerVariationsBody =>
      'These reharmonize the same flow with nearby functional substitutes. Apply one to send it back through the analyzer.';

  @override
  String get chordAnalyzerApplyVariation => 'Use Variation';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Cadential color';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Darkens the predominant and swaps in a tritone dominant while keeping the same arrival.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Backdoor color';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Uses ivm7-bVII7 color from the parallel minor before landing on the same tonic.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'Targeted ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Builds a related ii-V that still points to the same destination chord.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => 'Minor cadence color';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Keeps the minor cadence intact but leans into ii泥?Valt-i color.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Color lift';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Keeps the roots and functions close, but upgrades the chords with natural extensions.';

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
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

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
  String get studyHarmonySolfegeTi => 'Ti';

  @override
  String get studyHarmonyPrototypeCourseTitle => 'Study Harmony Prototype';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Legacy prototype levels carried into the lesson system.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Prototype Lessons';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Temporary lessons preserved while the expandable study system is introduced.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Clear by answering 10 prompts before you lose all 3 lives.';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Prototype Level 1 쨌 Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'A basic warm-up that asks you to distinguish only Do, Mi, and Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Prototype Level 2 쨌 Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'A mid-stage note hunt that speeds up recognition for Do, Re, Mi, Sol, and La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Prototype Level 3 쨌 Do / Re / Mi / Fa / Sol / La / Ti / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'An octave-complete test that runs across the full Do-Re-Mi-Fa-Sol-La-Ti-Do span.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (low C)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (high C)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Template';

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
      'Choose a balanced default sound or pin one playback character for pop, jazz, or classical practice.';

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
      'Major ii-V-I, minor ii첩-V-i, and turnaround behavior';

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
      'Move from clear major ii-V-I hearing into shell voicings, minor cadences, rootless color, and careful reharm entry points.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a clear major ii-V-I before adding extra color.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Recognize how minor ii첩-V-i motion feels and why the dominant sounds more urgent there.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Tension';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add 9ths, 13ths, sus, or altered pull without losing the cadence target.';

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
      'Mix major ii-V-I, minor ii첩-V-i, rootless color, and careful reharm so the cadence target still stays readable.';

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
  String get practiceFirstRunWelcomeTitle => 'Your first chord is ready';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'A beginner-friendly starting profile is already applied. Listen first, then swipe the card to explore the next chord.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel is ready to go. Listen first, then swipe the card to explore what comes next. You can still open the setup assistant to personalize the start.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Music notation language';

  @override
  String get musicNotationLocaleHelp =>
      'Controls the language used for optional Roman numeral and chord-text assists.';

  @override
  String get musicNotationLocaleUiDefault => 'Match app language';

  @override
  String get musicNotationLocaleEnglish => 'English';

  @override
  String get noteNamingStyle => 'Note naming';

  @override
  String get noteNamingStyleHelp =>
      'Switches displayed note and key names without changing harmonic logic.';

  @override
  String get noteNamingStyleEnglish => 'English letters';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Show Roman numeral assist';

  @override
  String get showRomanNumeralAssistHelp =>
      'Adds a short explanation next to Roman numeral labels.';

  @override
  String get showChordTextAssist => 'Show chord text assist';

  @override
  String get showChordTextAssistHelp =>
      'Adds a short text explanation for chord quality and tensions.';

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
    return 'Unlock permanently ($priceLabel)';
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
      'The store connection is unavailable right now. Free features still work.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'Premium product info is unavailable right now. Please try again later.';

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
      'The purchase could not be completed. Please try again later.';

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

/// The translations for Georgian, as used in Georgia (`ka_GE`).
class AppLocalizationsKaGe extends AppLocalizationsKa {
  AppLocalizationsKaGe() : super('ka_GE');

  @override
  String get settings => 'Settings';

  @override
  String get closeSettings => 'Close settings';

  @override
  String get language => 'Language';

  @override
  String get systemDefaultLanguage => 'System default';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

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
  String get setupAssistantNotationDelta => 'C?7 style';

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
  String get chordTypeFilters => 'Chord Types';

  @override
  String get chordTypeFiltersHelp =>
      'Choose which chord types can appear in the generator.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total enabled';
  }

  @override
  String get chordTypeGroupTriads => 'Triads';

  @override
  String get chordTypeGroupSevenths => 'Sevenths';

  @override
  String get chordTypeGroupSixthsAndAddedTone => 'Sixths & Added Tone';

  @override
  String get chordTypeGroupDominantVariants => 'Dominant Variants';

  @override
  String get chordTypeRequiresKeyMode =>
      'V7sus4 is available only when at least one key is selected.';

  @override
  String get chordTypeKeepOneEnabled => 'Keep at least one chord type enabled.';

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
      'Space: next chord  Enter: start or pause autoplay  Up/Down: adjust BPM';

  @override
  String get currentChord => 'Current Chord';

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
  String get pauseAutoplay => 'Pause Autoplay';

  @override
  String get stopAutoplay => 'Stop Autoplay';

  @override
  String get resetGeneratedChords => 'Reset Generated Chords';

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
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

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
      'Generate your next chord loop in Chordest, then use Analyzer for a cautious harmony read when you need context.';

  @override
  String get mainMenuGeneratorTitle => 'Chordest Generator';

  @override
  String get mainMenuGeneratorDescription =>
      'Start with a playable chord loop, voicing support, and quick practice controls.';

  @override
  String get openGenerator => 'Start Practice';

  @override
  String get openAnalyzer => 'Analyze Progression';

  @override
  String get mainMenuAnalyzerTitle => 'Chord Analyzer';

  @override
  String get mainMenuAnalyzerDescription =>
      'Check likely keys, Roman numerals, and warnings with a conservative progression read.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      'Continue lessons, review chapters, and build practical harmony fluency.';

  @override
  String get openStudyHarmony => 'Start Study Harmony';

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
      'Pulled from your current review queue.';

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
    return 'Best $rank 夷?$stars stars';
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
      'Run the full harmony path in a pop lane with its own progress, daily picks, and review queue.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Jazz Track';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Practice the full curriculum in a jazz lane with separate progress, daily picks, and review queue.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Classical Track';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Study the full curriculum in a classical lane with independent progress, daily picks, and review queue.';

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
      'Paste a progression to get a conservative read of likely keys, Roman numerals, and harmonic function.';

  @override
  String get chordAnalyzerInputLabel => 'Chord progression';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      'Use spaces, |, or commas between chords. Commas inside parentheses stay in the same chord.\n\nUse ? for an unknown chord slot. The analyzer will infer the most natural fill from context and surface alternatives when the reading is ambiguous.\n\nLowercase roots, slash bass, sus/alt/add forms, and tensions like C7(b9, #11) are supported.\n\nOn touch devices, use the chord pad or switch to ABC input when you want free typing.';

  @override
  String get chordAnalyzerInputHelpTitle => 'Input tips';

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
  String get chordAnalyzerClear => 'Reset';

  @override
  String get chordAnalyzerBackspace => 'Backspace';

  @override
  String get chordAnalyzerSpace => 'Spacebar';

  @override
  String get chordAnalyzerAnalyzing => 'Analyzing progression...';

  @override
  String get chordAnalyzerInitialTitle => 'Start with a progression';

  @override
  String get chordAnalyzerInitialBody =>
      'Enter a progression such as Dm7, G7 | ? Am or Cmaj7 | Am7 D7 | Gmaj7 to see likely keys, Roman numerals, warnings, inferred fills, and a short summary.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'This ? was inferred from the surrounding harmonic context, so treat it as a suggested fill rather than a certainty.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return 'Suggested fill: $chord';
  }

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
  String get chordAnalyzerGenerateVariations => 'Create Variations';

  @override
  String get chordAnalyzerVariationsTitle => 'Natural variations';

  @override
  String get chordAnalyzerVariationsBody =>
      'These reharmonize the same flow with nearby functional substitutes. Apply one to send it back through the analyzer.';

  @override
  String get chordAnalyzerApplyVariation => 'Use Variation';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => 'Cadential color';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      'Darkens the predominant and swaps in a tritone dominant while keeping the same arrival.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Backdoor color';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      'Uses ivm7-bVII7 color from the parallel minor before landing on the same tonic.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => 'Targeted ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      'Builds a related ii-V that still points to the same destination chord.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => 'Minor cadence color';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      'Keeps the minor cadence intact but leans into ii筌?Valt-i color.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'Color lift';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'Keeps the roots and functions close, but upgrades the chords with natural extensions.';

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
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

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
  String get studyHarmonySolfegeTi => 'Ti';

  @override
  String get studyHarmonyPrototypeCourseTitle => 'Study Harmony Prototype';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'Legacy prototype levels carried into the lesson system.';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'Prototype Lessons';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      'Temporary lessons preserved while the expandable study system is introduced.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      'Clear by answering 10 prompts before you lose all 3 lives.';

  @override
  String get studyHarmonyPrototypeLevel1Title =>
      'Prototype Level 1 夷?Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'A basic warm-up that asks you to distinguish only Do, Mi, and Sol.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'Prototype Level 2 夷?Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'A mid-stage note hunt that speeds up recognition for Do, Re, Mi, Sol, and La.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'Prototype Level 3 夷?Do / Re / Mi / Fa / Sol / La / Ti / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'An octave-complete test that runs across the full Do-Re-Mi-Fa-Sol-La-Ti-Do span.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (low C)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (high C)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'Template';

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
      'Choose a balanced default sound or pin one playback character for pop, jazz, or classical practice.';

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
      'Major ii-V-I, minor ii泥?V-i, and turnaround behavior';

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
      'Move from clear major ii-V-I hearing into shell voicings, minor cadences, rootless color, and careful reharm entry points.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a clear major ii-V-I before adding extra color.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'Recognize how minor ii泥?V-i motion feels and why the dominant sounds more urgent there.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Tension';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add 9ths, 13ths, sus, or altered pull without losing the cadence target.';

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
      'Mix major ii-V-I, minor ii泥?V-i, rootless color, and careful reharm so the cadence target still stays readable.';

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
  String get practiceFirstRunWelcomeTitle => 'Your first chord is ready';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      'A beginner-friendly starting profile is already applied. Listen first, then swipe the card to explore the next chord.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel is ready to go. Listen first, then swipe the card to explore what comes next. You can still open the setup assistant to personalize the start.';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => 'Music notation language';

  @override
  String get musicNotationLocaleHelp =>
      'Controls the language used for optional Roman numeral and chord-text assists.';

  @override
  String get musicNotationLocaleUiDefault => 'Match app language';

  @override
  String get musicNotationLocaleEnglish => 'English';

  @override
  String get noteNamingStyle => 'Note naming';

  @override
  String get noteNamingStyleHelp =>
      'Switches displayed note and key names without changing harmonic logic.';

  @override
  String get noteNamingStyleEnglish => 'English letters';

  @override
  String get noteNamingStyleLatin => 'Do Re Mi';

  @override
  String get showRomanNumeralAssist => 'Show Roman numeral assist';

  @override
  String get showRomanNumeralAssistHelp =>
      'Adds a short explanation next to Roman numeral labels.';

  @override
  String get showChordTextAssist => 'Show chord text assist';

  @override
  String get showChordTextAssistHelp =>
      'Adds a short text explanation for chord quality and tensions.';

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
    return 'Unlock permanently ($priceLabel)';
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
      'The store connection is unavailable right now. Free features still work.';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      'Premium product info is unavailable right now. Please try again later.';

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
      'The purchase could not be completed. Please try again later.';

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
