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
  String get systemDefaultLanguage => 'システム設定';

  @override
  String get metronome => 'メトロノーム';

  @override
  String get enabled => 'オン';

  @override
  String get disabled => 'オフ';

  @override
  String get metronomeHelp => 'メトロノームを有効にすると、練習中の各拍でクリックが鳴ります。';

  @override
  String get metronomeSound => 'メトロノーム音';

  @override
  String get metronomeSoundClassic => 'クラシック';

  @override
  String get metronomeSoundClickB => 'クリック B';

  @override
  String get metronomeSoundClickC => 'クリック C';

  @override
  String get metronomeSoundClickD => 'クリック D';

  @override
  String get metronomeSoundClickE => 'クリック E';

  @override
  String get metronomeSoundClickF => 'クリック F';

  @override
  String get metronomeVolume => 'メトロノーム音量';

  @override
  String get keys => 'キー';

  @override
  String get noKeysSelected => 'キーが選択されていません。すべてオフにすると、全ルートを使うフリーモードで練習します。';

  @override
  String get keysSelectedHelp =>
      '選択したキーは、キー対応ランダムモードと Smart Generator モードで使われます。';

  @override
  String get smartGeneratorMode => 'Smart Generator モード';

  @override
  String get smartGeneratorHelp => '有効なノンダイアトニック設定を保ちながら、機能和声の流れを優先します。';

  @override
  String get advancedSmartGenerator => '高度な Smart Generator';

  @override
  String get modulationIntensity => '転調の強さ';

  @override
  String get modulationIntensityOff => 'オフ';

  @override
  String get modulationIntensityLow => '低';

  @override
  String get modulationIntensityMedium => '中';

  @override
  String get modulationIntensityHigh => '高';

  @override
  String get jazzPreset => 'ジャズ・プリセット';

  @override
  String get jazzPresetStandardsCore => 'スタンダード基準';

  @override
  String get jazzPresetModulationStudy => '転調研究';

  @override
  String get jazzPresetAdvanced => '上級';

  @override
  String get sourceProfile => 'ソース・プロファイル';

  @override
  String get sourceProfileFakebookStandard => 'フェイクブック標準';

  @override
  String get sourceProfileRecordingInspired => '録音寄り';

  @override
  String get smartDiagnostics => 'Smart 診断';

  @override
  String get smartDiagnosticsHelp => 'デバッグ用に Smart Generator の判断トレースをログ出力します。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator モードを使うには、少なくとも 1 つキーを選択してください。';

  @override
  String get nonDiatonic => 'ノンダイアトニック';

  @override
  String get nonDiatonicRequiresKeyMode => 'ノンダイアトニックのオプションはキーモードでのみ利用できます。';

  @override
  String get secondaryDominant => 'セカンダリー・ドミナント';

  @override
  String get substituteDominant => 'サブスティテュート・ドミナント';

  @override
  String get modalInterchange => 'モーダル・インターチェンジ';

  @override
  String get modalInterchangeDisabledHelp =>
      'モーダル・インターチェンジはキーモードでのみ現れるため、フリーモードではこのオプションは無効になります。';

  @override
  String get rendering => '表示';

  @override
  String get chordSymbolStyle => 'コード記号スタイル';

  @override
  String get chordSymbolStyleHelp => '表示レイヤーだけを変更します。和声ロジックは正規のままです。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => 'V7sus4 を許可 (V7, V7/x)';

  @override
  String get allowTensions => 'テンションを許可';

  @override
  String get tensionHelp => 'ローマ数字プロファイルと選択したチップのみ';

  @override
  String get inversions => '転回形';

  @override
  String get enableInversions => '転回形を使う';

  @override
  String get inversionHelp => 'コード選択後にスラッシュベース表記をランダムで適用します。前のベース進行は追跡しません。';

  @override
  String get firstInversion => '第1転回形';

  @override
  String get secondInversion => '第2転回形';

  @override
  String get thirdInversion => '第3転回形';

  @override
  String get keyPracticeOverview => 'キー練習の概要';

  @override
  String get freePracticeOverview => 'フリー練習の概要';

  @override
  String get keyModeTag => 'キーモード';

  @override
  String get freeModeTag => 'フリーモード';

  @override
  String get allKeysTag => '全キー';

  @override
  String get metronomeOnTag => 'メトロノーム ON';

  @override
  String get metronomeOffTag => 'メトロノーム OFF';

  @override
  String get pressNextChordToBegin => 'Next Chord を押して開始';

  @override
  String get freeModeActive => 'フリーモード有効';

  @override
  String get freePracticeDescription =>
      '12 の半音ルートとランダムなコード品質を使って、幅広い読譜練習を行います。';

  @override
  String get smartPracticeDescription =>
      '選択したキー内で機能和声の流れをたどりながら、自然な Smart Generator の動きを加えます。';

  @override
  String get keyPracticeDescription =>
      '選択したキーと有効なローマ数字を使って、ダイアトニックな練習素材を生成します。';

  @override
  String get keyboardShortcutHelp =>
      'Space: 次のコード  Enter: 自動再生の開始/停止  Up/Down: BPM 調整';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => '自動再生を開始';

  @override
  String get stopAutoplay => '自動再生を停止';

  @override
  String get decreaseBpm => 'BPM を下げる';

  @override
  String get increaseBpm => 'BPM を上げる';

  @override
  String allowedRange(int min, int max) {
    return '許容範囲: $min-$max';
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
      'Biases suggestions toward a chosen top line. Locked voicings override it, then same-chord carry keeps the line steady.';

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
  String get voicingSuggestionTopLineSubtitle => 'Top line stays in focus';

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
    return 'Target top note: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'Locked top line: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'Carry top line: $note';
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
  String get voicingReasonTopLineTarget => 'Top-line target';

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
