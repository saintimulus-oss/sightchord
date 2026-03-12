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
  String get mainMenuAnalyzerTitle => 'Chord Analyzer';

  @override
  String get mainMenuAnalyzerDescription =>
      'Analyze a written progression for likely key centers, Roman numerals, and harmonic functions.';

  @override
  String get openGenerator => 'Open Generator';

  @override
  String get openAnalyzer => 'Open Analyzer';

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
      'Spaces, |, and commas are accepted. Slash chords and simple alterations are supported. Touch devices can use the chord pad or switch to ABC input.';

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
      'Some chords remain ambiguous under this MVP reading.';

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
      'This chord falls outside the current MVP heuristics.';

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
}
