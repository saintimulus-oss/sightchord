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
