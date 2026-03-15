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
  String get systemDefaultLanguage => 'システムのデフォルト';

  @override
  String get themeMode => 'テーマ';

  @override
  String get themeModeSystem => 'システム設定';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

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
  String get metronome => 'メトロノーム';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get metronomeHelp => 'メトロノームをオンにすると、練習中にビートごとにクリック音が聞こえます。';

  @override
  String get metronomeSound => 'メトロノーム音';

  @override
  String get metronomeSoundClassic => 'クラシック';

  @override
  String get metronomeSoundClickB => 'Bをクリック';

  @override
  String get metronomeSoundClickC => 'Cをクリックします';

  @override
  String get metronomeSoundClickD => 'Dをクリックします';

  @override
  String get metronomeSoundClickE => 'Eをクリックします';

  @override
  String get metronomeSoundClickF => 'Fをクリックします';

  @override
  String get metronomeVolume => 'メトロノームの音量';

  @override
  String get keys => 'キー';

  @override
  String get noKeysSelected =>
      'キーが選択されていません。すべてのルートでフリー モードで練習するには、すべてのキーをオフのままにしてください。';

  @override
  String get keysSelectedHelp =>
      '選択されたキーは、キー認識ランダム モードおよび Smart Generator モードに使用されます。';

  @override
  String get smartGeneratorMode => 'Smart Generator モード';

  @override
  String get smartGeneratorHelp => '有効な ノンダイアトニック オプションを維持しながら、機能調和運動を優先します。';

  @override
  String get advancedSmartGenerator => '高度な Smart Generator';

  @override
  String get modulationIntensity => '変調強度';

  @override
  String get modulationIntensityOff => 'オフ';

  @override
  String get modulationIntensityLow => '低い';

  @override
  String get modulationIntensityMedium => '中くらい';

  @override
  String get modulationIntensityHigh => '高い';

  @override
  String get jazzPreset => 'ジャズプリセット';

  @override
  String get jazzPresetStandardsCore => '標準コア';

  @override
  String get jazzPresetModulationStudy => '変調研究';

  @override
  String get jazzPresetAdvanced => '高度な';

  @override
  String get sourceProfile => 'ソースプロファイル';

  @override
  String get sourceProfileFakebookStandard => 'フェイクブック標準';

  @override
  String get sourceProfileRecordingInspired => 'レコーディングにインスピレーションを得た';

  @override
  String get smartDiagnostics => 'スマート診断';

  @override
  String get smartDiagnosticsHelp =>
      'デバッグのために Smart Generator 決定トレースをログに記録します。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator モードを使用するには、少なくとも 1 つのキーを選択します。';

  @override
  String get nonDiatonic => 'ノンダイアトニック';

  @override
  String get nonDiatonicRequiresKeyMode => 'ダイアトニック 以外のオプションは、キー モードでのみ使用できます。';

  @override
  String get secondaryDominant => 'セカンダリー・ドミナント';

  @override
  String get substituteDominant => '代理ドミナント';

  @override
  String get modalInterchange => 'モーダル・インターチェンジ';

  @override
  String get modalInterchangeDisabledHelp =>
      'モーダル交換はキー モードでのみ表示されるため、このオプションはフリー モードでは無効になります。';

  @override
  String get rendering => 'レンダリング';

  @override
  String get keyCenterLabelStyle => 'キーラベルのスタイル';

  @override
  String get keyCenterLabelStyleHelp =>
      '明示的なモード名と古典的な大文​​字/小文字の主音ラベルのどちらかを選択します。';

  @override
  String get chordSymbolStyle => 'コード記号のスタイル';

  @override
  String get chordSymbolStyleHelp => '表示レイヤーのみを変更します。調和ロジックは標準のままです。';

  @override
  String get styleCompact => 'コンパクト';

  @override
  String get styleMajText => 'マジテキスト';

  @override
  String get styleDeltaJazz => 'デルタジャズ';

  @override
  String get keyCenterLabelStyleModeText => 'ハ長調: / ハ短調:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

  @override
  String get allowV7sus4 => 'V7sus4 (V7、V7/x) を許可します。';

  @override
  String get allowTensions => '緊張を許容する';

  @override
  String get chordTypeFilters => 'コード種類';

  @override
  String get chordTypeFiltersHelp => 'ジェネレーターに表示するコード種類を選択します。';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total 有効';
  }

  @override
  String get chordTypeGroupTriads => 'トライアド';

  @override
  String get chordTypeGroupSevenths => 'セブンス';

  @override
  String get chordTypeGroupSixthsAndAddedTone => '6th と付加音';

  @override
  String get chordTypeGroupDominantVariants => 'ドミナント・バリエーション';

  @override
  String get chordTypeRequiresKeyMode => 'V7sus4 はキーを 1 つ以上選択したときのみ利用できます。';

  @override
  String get chordTypeKeepOneEnabled => '少なくとも 1 つのコード種類を有効にしてください。';

  @override
  String get tensionHelp => 'ローマ数字 プロファイルと選択されたチップのみ';

  @override
  String get inversions => '反転';

  @override
  String get enableInversions => '反転を有効にする';

  @override
  String get inversionHelp => 'コード選択後のランダムなスラッシュベースのレンダリング。前のベースを追跡しません。';

  @override
  String get firstInversion => '1回目の反転';

  @override
  String get secondInversion => '2回目の反転';

  @override
  String get thirdInversion => '3回目の転回';

  @override
  String get keyPracticeOverview => '主要な実践の概要';

  @override
  String get freePracticeOverview => 'フリープラクティスの概要';

  @override
  String get keyModeTag => 'キーモード';

  @override
  String get freeModeTag => 'フリーモード';

  @override
  String get allKeysTag => 'すべてのキー';

  @override
  String get metronomeOnTag => 'メトロノームオン';

  @override
  String get metronomeOffTag => 'メトロノームオフ';

  @override
  String get pressNextChordToBegin => '次のコードを押して開始します';

  @override
  String get freeModeActive => 'フリーモード有効';

  @override
  String get freePracticeDescription =>
      '幅広い音読の練習のために、ランダムなコード品質を持つ 12 の半音階ルートすべてを使用します。';

  @override
  String get smartPracticeDescription =>
      '選択されたキーの 和声機能 フローに従い、スマートジェネレーターの上品な動きを可能にします。';

  @override
  String get keyPracticeDescription =>
      '選択したキーと有効な ローマ数字 を使用して、ダイアトニック 演習資料を生成します。';

  @override
  String get keyboardShortcutHelp =>
      'スペース: 次のコード Enter: 自動再生の開始または停止 Up/Down: BPM の調整';

  @override
  String get nextChord => '次のコード';

  @override
  String get audioPlayChord => 'プレイコード';

  @override
  String get audioPlayArpeggio => 'アルペジオを演奏する';

  @override
  String get audioPlayProgression => 'プレイの進行';

  @override
  String get audioPlayPrompt => 'プロンプトを再生';

  @override
  String get startAutoplay => '自動再生の開始';

  @override
  String get stopAutoplay => '自動再生を停止する';

  @override
  String get decreaseBpm => 'BPMを下げる';

  @override
  String get increaseBpm => 'BPMを上げる';

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
  String get modeMajor => '選考科目';

  @override
  String get modeMinor => 'マイナー';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => 'ボイシング提案';

  @override
  String get voicingSuggestionsSubtitle => 'このコードの具体的な音の選択を参照してください。';

  @override
  String get voicingSuggestionsEnabled => '音声提案を有効にする';

  @override
  String get voicingSuggestionsHelp =>
      '現在のコードの 3 つの再生可能なノートレベルの ボイシング アイデアを示します。';

  @override
  String get voicingComplexity => '発声の複雑さ';

  @override
  String get voicingComplexityHelp => '提案がどの程度カラフルになるかを制御します。';

  @override
  String get voicingComplexityBasic => '基本';

  @override
  String get voicingComplexityStandard => '標準';

  @override
  String get voicingComplexityModern => 'モダンな';

  @override
  String get voicingTopNotePreference => 'トップノートの好み';

  @override
  String get voicingTopNotePreferenceHelp =>
      '選択した トップライン に基づいて提案を行います。ロックされた ボイシング が最初に勝ち、次にコードを繰り返すと安定した状態が維持されます。';

  @override
  String get voicingTopNotePreferenceAuto => '自動';

  @override
  String get allowRootlessVoicings => 'ルートレスボイシングを許可する';

  @override
  String get allowRootlessVoicingsHelp => 'ガイドトーン が明確な場合、提案でルートが省略されるようにします。';

  @override
  String get maxVoicingNotes => '最大ボイシングノート数';

  @override
  String get lookAheadDepth => '先読みの深さ';

  @override
  String get lookAheadDepthHelp => 'ランキングで考慮される将来のコードの数。';

  @override
  String get showVoicingReasons => '音声の理由を表示';

  @override
  String get showVoicingReasonsHelp => '各提案カードに短い説明チップを表示します。';

  @override
  String get voicingSuggestionNatural => '最も自然な';

  @override
  String get voicingSuggestionColorful => '最もカラフルな';

  @override
  String get voicingSuggestionEasy => '最も簡単な';

  @override
  String get voicingSuggestionNaturalSubtitle => 'まずは音声主導';

  @override
  String get voicingSuggestionColorfulSubtitle => 'カラートーンにこだわる';

  @override
  String get voicingSuggestionEasySubtitle => 'コンパクトなハンド形状';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle => 'まずは接続と解決';

  @override
  String get voicingSuggestionNaturalStableSubtitle => '同じ形状、安定したコンピング';

  @override
  String get voicingSuggestionTopLineSubtitle => 'トップラインのリード';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle => '前線のテンションの変化';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => 'モダンなクアルタルカラー';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      '明るい ガイドトーン を備えた Tritone-sub エッジ';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      '明るいエクステンションを備えたガイドトーン';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle => 'コアトーン、より小さなリーチ';

  @override
  String get voicingSuggestionEasyStableSubtitle => 'リピートしやすい手の形状';

  @override
  String get voicingTopNoteLabel => 'トップ';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return 'トップラインターゲット: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return 'ロックされた トップライン: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return 'トップライン の繰り返し: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '最寄りの トップライン から $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '$note に正確な トップライン はありません';
  }

  @override
  String get voicingFamilyShell => 'シェル';

  @override
  String get voicingFamilyRootlessA => '根無しA';

  @override
  String get voicingFamilyRootlessB => '根無しB';

  @override
  String get voicingFamilySpread => '広める';

  @override
  String get voicingFamilySus => 'サス';

  @override
  String get voicingFamilyQuartal => 'クアルタル';

  @override
  String get voicingFamilyAltered => '変更された';

  @override
  String get voicingFamilyUpperStructure => '上部構造';

  @override
  String get voicingLockSuggestion => 'ロックの提案';

  @override
  String get voicingUnlockSuggestion => '提案のロックを解除する';

  @override
  String get voicingSelected => '選択済み';

  @override
  String get voicingLocked => 'ロックされています';

  @override
  String get voicingReasonEssentialCore => '必須のトーンをカバー';

  @override
  String get voicingReasonGuideToneAnchor => '3番目/7番目のアンカー';

  @override
  String voicingReasonGuideResolution(int count) {
    return '$count ガイドトーン解決';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '$count 共通のトーンを維持';
  }

  @override
  String get voicingReasonStableRepeat => '安定したリピート';

  @override
  String get voicingReasonTopLineTarget => 'トップライン目標';

  @override
  String get voicingReasonLowMudAvoided => '低音域の明瞭さ';

  @override
  String get voicingReasonCompactReach => '快適なリーチ';

  @override
  String get voicingReasonBassAnchor => '尊敬されるバスアンカー';

  @override
  String get voicingReasonNextChordReady => '次のコードの準備ができました';

  @override
  String get voicingReasonAlteredColor => '変化した緊張';

  @override
  String get voicingReasonRootlessClarity => '軽い根なし形状';

  @override
  String get voicingReasonSusRelease => 'サスリリースのセットアップ';

  @override
  String get voicingReasonQuartalColor => '四分の一の色';

  @override
  String get voicingReasonUpperStructureColor => '上部構造の色';

  @override
  String get voicingReasonTritoneSubFlavor => 'トリトーネサブフレーバー';

  @override
  String get voicingReasonLockedContinuity => 'ロックされた連続性';

  @override
  String get voicingReasonGentleMotion => 'スムーズな手の動き';

  @override
  String get mainMenuIntro => 'コード練習、進行分析、和声学習をひとつの場所から始めましょう。';

  @override
  String get mainMenuGeneratorTitle => 'コード生成';

  @override
  String get mainMenuGeneratorDescription => 'スマートな進行とボイシング補助で練習用コードをすぐ作れます。';

  @override
  String get openGenerator => '練習を始める';

  @override
  String get openAnalyzer => '進行を分析';

  @override
  String get mainMenuAnalyzerTitle => 'コード解析';

  @override
  String get mainMenuAnalyzerDescription => '進行を読み取り、調性・ローマ数字・機能をすばやく確認できます。';

  @override
  String get mainMenuStudyHarmonyTitle => '和声学習';

  @override
  String get mainMenuStudyHarmonyDescription => 'レッスンを続け、章を復習し、実践的な和声感覚を育てます。';

  @override
  String get openStudyHarmony => '和声学習を始める';

  @override
  String get studyHarmonyTitle => '和声学習';

  @override
  String get studyHarmonySubtitle =>
      '簡単なレッスンのエントリと章の進行により、構造化されたハーモニーハブを学習します。';

  @override
  String get studyHarmonyPlaceholderTag => 'スタディデッキ';

  @override
  String get studyHarmonyPlaceholderBody =>
      'レッスン データ、プロンプト、解答面は、音符、コード、スケール、進行ドリルの 1 つの再利用可能な学習フローをすでに共有しています。';

  @override
  String get studyHarmonyTestLevelTag => '練習ドリル';

  @override
  String get studyHarmonyTestLevelAction => 'オープンドリル';

  @override
  String get studyHarmonySubmit => '提出する';

  @override
  String get studyHarmonyNextPrompt => '次のプロンプト';

  @override
  String get studyHarmonySelectedAnswers => '選択された回答';

  @override
  String get studyHarmonySelectionEmpty => 'まだ回答が選択されていません。';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total 正解';
  }

  @override
  String get studyHarmonyAttempts => '試み';

  @override
  String get studyHarmonyAccuracy => '正確さ';

  @override
  String get studyHarmonyElapsedTime => '時間';

  @override
  String get studyHarmonyObjective => 'ゴール';

  @override
  String get studyHarmonyPromptInstruction => '一致する答えを選択してください';

  @override
  String get studyHarmonyNeedSelection => '送信する前に少なくとも 1 つの回答を選択してください。';

  @override
  String get studyHarmonyCorrectLabel => '正しい';

  @override
  String get studyHarmonyIncorrectLabel => '正しくない';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return '正しい。 $answer が正解でした。';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return '正しくない。 $answer は正解で、命を 1 つ失いました。';
  }

  @override
  String get studyHarmonyGameOverTitle => 'ゲームオーバー';

  @override
  String get studyHarmonyGameOverBody =>
      '三人の命はすべて消え去った。このレベルを再試行するか、和声学習 ハブに戻ります。';

  @override
  String get studyHarmonyLevelCompleteTitle => 'レベルクリア';

  @override
  String get studyHarmonyLevelCompleteBody =>
      'レッスンの目標を達成しました。以下で正確さとクリアタイムを確認してください。';

  @override
  String get studyHarmonyBackToHub => '和声学習 に戻る';

  @override
  String get studyHarmonyRetry => 'リトライ';

  @override
  String get studyHarmonyHubHeroEyebrow => 'スタディハブ';

  @override
  String get studyHarmonyHubHeroBody =>
      '継続を使用して勢いを回復し、レビューを使用して弱点を再確認し、毎日を使用してロックされていない道から 1 つの決定的な教訓を得ることができます。';

  @override
  String get studyHarmonyTrackFilterLabel => 'コース';

  @override
  String get studyHarmonyTrackCoreFilterLabel => '基礎';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'ポップ';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'ジャズ';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'クラシック';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total レッスンをクリアしました';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total 章を完了しました';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars の星';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return '$mastered/$total スキルを習得しました';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count レビュー準備完了';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return 'ストリーク x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count が実行される';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return 'ベスト $rank';
  }

  @override
  String get studyHarmonyBossTag => 'ボス';

  @override
  String get studyHarmonyContinueCardTitle => '続きから';

  @override
  String get studyHarmonyContinueResumeHint => '最後に行ったレッスンを再開します。';

  @override
  String get studyHarmonyContinueFrontierHint => 'いまのフロンティアにある次のレッスンへ進みます。';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return '続行: $lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => '続ける';

  @override
  String get studyHarmonyReviewCardTitle => '復習';

  @override
  String get studyHarmonyReviewQueueHint => '現在の復習キューから選ばれます。';

  @override
  String get studyHarmonyReviewWeakHint => 'プレイ済みレッスンの中で最も弱かった結果から選ばれます。';

  @override
  String get studyHarmonyReviewFallbackHint => 'まだ復習のたまりはないため、現在のフロンティアに戻ります。';

  @override
  String get studyHarmonyReviewRetryNeededHint => 'ミスや未完走のあとに、もう一度通したいレッスンです。';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      '精度を手早く整え直すために、このレッスンがキューに入っています。';

  @override
  String get studyHarmonyReviewAction => '復習する';

  @override
  String get studyHarmonyDailyCardTitle => 'デイリーチャレンジ';

  @override
  String get studyHarmonyDailyCardHint => 'ロック解除されたレッスンから今日の決定的な選択を開きます。';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      '今日のデイリーはクリア済みです。必要なら再挑戦し、連続記録は明日につなげましょう。';

  @override
  String get studyHarmonyDailyAction => 'デイリーを開始';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return 'シード $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => '今日はデイリークリアしました';

  @override
  String get studyHarmonyReviewSessionTitle => '弱点レビュー';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return '$chapterTitle に関する短いレビューと、最近最も苦手なスキルを組み合わせてください。';
  }

  @override
  String get studyHarmonyDailySessionTitle => 'デイリーチャレンジ';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return '$chapterTitle と現在のフロンティアから構築された今日のシード ミックスをプレイします。';
  }

  @override
  String get studyHarmonyModeLesson => 'レッスンモード';

  @override
  String get studyHarmonyModeReview => 'レビューモード';

  @override
  String get studyHarmonyModeDaily => 'デイリーモード';

  @override
  String get studyHarmonyModeLegacy => '練習モード';

  @override
  String get studyHarmonyShortcutHint =>
      '「送信」または「次へ」と入力します。 Rが再起動します。 1 ～ 9 で答えを選択します。 Tab キーと Shift+Tab キーでフォーカスを移動します。';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$total 人中 $remaining 人の残りの命';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => 'スキルの向上';

  @override
  String get studyHarmonyResultReviewFocusTitle => 'レビューの焦点';

  @override
  String get studyHarmonyResultRewardTitle => 'セッション報酬';

  @override
  String get studyHarmonyBonusGoalsTitle => 'ボーナスゴール';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return 'ランク$rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars の星';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return '$rank · $stars のベストスター';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return '毎日の連続記録 x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => '自己ベストを更新';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded => 'レビュー理由: 再試行が必要です';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh => 'レビュー理由: 精度の更新';

  @override
  String get studyHarmonyReviewReasonLowMastery => 'レビュー理由: 習熟度が低い';

  @override
  String get studyHarmonyReviewReasonStaleSkill => 'レビュー理由: スキルが古い';

  @override
  String get studyHarmonyReviewReasonWeakSpot => 'レビュー理由：弱点';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh => 'レビュー理由：フロンティアリフレッシュ';

  @override
  String get studyHarmonyQuestBoardTitle => 'クエストボード';

  @override
  String get studyHarmonyQuestCompletedTag => '完了';

  @override
  String get studyHarmonyQuestTodayTag => '今日';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target 完了';
  }

  @override
  String get studyHarmonyQuestDailyTitle => '毎日の連続記録';

  @override
  String get studyHarmonyQuestDailyBody => '今日のシードミックスをクリアして連続記録を伸ばしましょう。';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      '今日のデイリーはすでにクリアされています。ストリークは今のところ安全です。';

  @override
  String get studyHarmonyQuestFrontierTitle => 'フロンティアプッシュ';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return '$lessonTitle をクリアして学習ルートを前へ進めましょう。';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      'いま解放されているレッスンはすべてクリア済みです。ボスをやり直すか、さらに星を取りに行きましょう。';

  @override
  String get studyHarmonyQuestStarsTitle => 'スターハント';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return '余分な星を $chapterTitle 内に押し込みます。';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback => '現在の章に追加のスターを押してください。';

  @override
  String studyHarmonyComboLabel(int count) {
    return 'コンボx$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return 'ベストコンボ x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => 'すべての心を守ります';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return '$percent% の精度に達する';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return 'リーチコンボ x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => 'ボーナススイープ';

  @override
  String get studyHarmonySkillNoteRead => 'ノートの読み方';

  @override
  String get studyHarmonySkillNoteFindKeyboard => 'キーボードノートの検索';

  @override
  String get studyHarmonySkillNoteAccidentals => 'シャープとフラット';

  @override
  String get studyHarmonySkillChordSymbolToKeys => 'キーへのコード記号';

  @override
  String get studyHarmonySkillChordNameFromTones => 'コードのネーミング';

  @override
  String get studyHarmonySkillScaleBuild => 'スケールビルディング';

  @override
  String get studyHarmonySkillRomanRealize => 'ローマ数字の実現';

  @override
  String get studyHarmonySkillRomanIdentify => 'ローマ数字 の識別';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => 'ダイアトニシティ';

  @override
  String get studyHarmonySkillHarmonyFunction => '関数の基本';

  @override
  String get studyHarmonySkillProgressionKeyCenter => '進行状況 キーセンター';

  @override
  String get studyHarmonySkillProgressionFunction => '進行関数の読み取り';

  @override
  String get studyHarmonySkillProgressionNonDiatonic => '進行状況 ノンダイアトニック の検出';

  @override
  String get studyHarmonySkillProgressionFillBlank => 'プログレッションフィルイン';

  @override
  String get studyHarmonyHubChapterSectionTitle => '章';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return '$cleared/$total レッスンをクリアしました';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return '$count レッスン';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count クリア';
  }

  @override
  String get studyHarmonyOpenChapterAction => '章を開く';

  @override
  String get studyHarmonyLockedChapterTag => 'ロックされた章';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return '次は $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return 'このトラックはまだロックされています。 $coreTrack に戻って今日も勉強を続けてください。';
  }

  @override
  String get studyHarmonyCoreTrackTitle => '基礎コース';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '音符とキーボードから始めて、コード、スケール、ローマ数字、ダイアトニック の基本、短い進行分析を通じて構築していきます。';

  @override
  String get studyHarmonyChapterNotesTitle => '第 1 章: ノートとキーボード';

  @override
  String get studyHarmonyChapterNotesDescription =>
      '音名をキーボードにマッピングし、白鍵とシンプルな臨時記号に慣れてください。';

  @override
  String get studyHarmonyChapterChordsTitle => '第 2 章: コードの基本';

  @override
  String get studyHarmonyChapterChordsDescription =>
      '基本的なトライアドとセブンスを綴り、その音色から一般的なコードの形に名前を付けます。';

  @override
  String get studyHarmonyChapterScalesTitle => '第 3 章: スケールとキー';

  @override
  String get studyHarmonyChapterScalesDescription =>
      '長音階と短音階を作成し、キー内にどの音が属するかを特定します。';

  @override
  String get studyHarmonyChapterRomanTitle => '第 4 章: ローマ数字とダイアトニシティ';

  @override
  String get studyHarmonyChapterRomanDescription =>
      '単純な ローマ数字 をコードに変換し、コードから識別し、ダイアトニック の基本を機能別に分類します。';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle => '第5章 進行探偵I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '短いコア進行を読み、可能性の高い キーセンター を見つけて、コード関数または奇妙なコードを見つけます。';

  @override
  String get studyHarmonyChapterMissingChordTitle => '第6章: ミッシングコード I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      '短い進行内の空白を 1 つ埋めて、リズムと機能が次にどこに進むべきかを学びます。';

  @override
  String get studyHarmonyOpenLessonAction => 'レッスンを開く';

  @override
  String get studyHarmonyLockedLessonAction => '未開放';

  @override
  String get studyHarmonyClearedTag => 'クリア';

  @override
  String get studyHarmonyComingSoonTag => '近日公開';

  @override
  String get studyHarmonyPopTrackTitle => 'ポップコース';

  @override
  String get studyHarmonyPopTrackDescription =>
      'コアトラックが安定した後に、歌に焦点を当てたパスが計画されています。';

  @override
  String get studyHarmonyJazzTrackTitle => 'ジャズコース';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'ジャズ ハーモニー コンテンツは、コア カリキュラムが定着するまでロックされたままになります。';

  @override
  String get studyHarmonyClassicalTrackTitle => 'クラシックコース';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      '古典的な文脈における機能的調和は、後の段階で登場します。';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'クイックドリル';

  @override
  String get studyHarmonyObjectiveBossReview => 'ボス復習';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => '白鍵ノートハント';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      '音名を読み、一致する白鍵をタップします。';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'ハイライト表示されたメモに名前を付けます';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'ハイライト表示されたキーを見て、正しい音名を選択してください。';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => '黒鍵と双子';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      '黒鍵のシャープスペルとフラットスペルを初めて見てみましょう。';

  @override
  String get studyHarmonyLessonNotesBossTitle => 'ボス: ファストノートハント';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      '音符の読み取りとキーボードの検索を 1 つの短いスピード ラウンドに混ぜ合わせます。';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'キーボード上のトライアド';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      '一般的なメジャー、マイナー、ディミニッシュ トライアドをキーボード上で直接作成します。';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => 'キーボードのセブンス';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'セブンスを追加し、キーボードで一般的なセブンスコードをいくつか綴ります。';

  @override
  String get studyHarmonyLessonChordNameTitle => 'ハイライト表示されたコードに名前を付けます';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'ハイライト表示されたコードシェイプを読み取って、正しいコード名を選択します。';

  @override
  String get studyHarmonyLessonChordsBossTitle => 'Boss: トライアドとセブンス レビュー';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      '1 つの混合レビューでコードのスペルとコードのネーミングを切り替えます。';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'メジャースケールを構築する';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      '単純なメジャースケールに属するすべての音を選択します。';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'マイナースケールを構築する';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'いくつかの共通のキーからナチュラルマイナースケールとハーモニックマイナースケールを構築します。';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => '主要メンバー';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      '名前付きキー内にどのトーンが属するかを見つけます。';

  @override
  String get studyHarmonyLessonScalesBossTitle => 'ボス：鱗の修理';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      '短期間の修理ラウンドで大規模な構築と主要なメンバーシップを組み合わせます。';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'ローマ字から和音へ';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'キーと ローマ数字 を読み取り、一致するコードを選択します。';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'コードからローマ字へ';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'キー内のコードを読み取り、一致する ローマ数字 を選択します。';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'ダイアトニックか否か';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'コードを簡単なキーで ダイアトニック と ノンダイアトニック の答えに分類します。';

  @override
  String get studyHarmonyLessonFunctionTitle => '関数の基本';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      '簡単なコードをトニック、プレドミナント、またはドミナントに分類します。';

  @override
  String get studyHarmonyLessonRomanBossTitle => 'ボス: ファンクショナルベーシックミックス';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'ローマ字からコード、コードからローマ字、ダイアトニックity、および機能を一緒に確認してください。';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle => 'キーセンターを見つける';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      '短い進行を読んで、最も明確に意味のある キーセンター を選択してください。';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle => 'コンテキスト内の関数';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      '強調表示された 1 つのコードに焦点を当て、短い進行の中でのその役割に名前を付けます。';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle => 'アウトサイダーを探せ';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      'メインの ダイアトニック 読み取り値の範囲外にある 1 つのコードを見つけます。';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'ボス: 混合分析';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      'キーセンターの読み取り、関数の検出、および ノンダイアトニック の検出を 1 つの短い検出ラウンドに組み合わせます。';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle => '足りないコードを埋める';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      'ローカル機能に最もよく適合するコードを選択して、短い 4 つのコード進行を完成させます。';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle => 'ケイデンスフィルイン';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      'フレーズの終わり近くで欠落しているコードを選択するには、リズムに向かってプルを使用します。';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'ボス: ミックスフィルイン';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      'もう少し調和的な圧力を加えて、穴埋め進行の問題の短いセットを解きます。';

  @override
  String get studyHarmonyChapterCheckpointTitle => 'チェックポイント ガントレット';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      'キーセンター、機能、色、および塗りつぶしのドリルを組み合わせて、より高速な混合レビュー セットを作成します。';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => 'ケイデンスラッシュ';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      '和声の役割を素早く読み取り、欠けているカデンシャルコードを軽い圧力で埋め込みます。';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => 'カラーとキーシフト';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      'スレッドを失うことなく、中心検出と ノンダイアトニック カラー呼び出しを切り替えます。';

  @override
  String get studyHarmonyLessonCheckpointBossTitle => 'ボス：チェックポイント・ガントレット';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      'キーセンター、機能、色、およびリズムの修復プロンプトを組み合わせた 1 つの統合チェックポイントをクリアします。';

  @override
  String get studyHarmonyChapterCapstoneTitle => 'キャップストーントライアル';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      'スピード、色の聴力、きれいな解像度の選択が求められる、より厳しい混合進行ラウンドでコア パスを終了します。';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => 'ターンアラウンドリレー';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      'コンパクトなターンアラウンドで、関数の読み取りと欠落コードの修復を切り替えます。';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle => '借用したカラーコール';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      'モーダルカラーを素早くキャッ​​チし、滑り落ちてしまう前に キーセンター を確認します。';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => '解像度ラボ';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      '各フレーズが着地したい場所を追跡し、モーションを最もよく解決するコードを選択します。';

  @override
  String get studyHarmonyLessonCapstoneBossTitle => 'ボス：最終昇級試験';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      'センター、機能、色、解像度のすべてがプレッシャーにさらされている最後の混合試験に合格します。';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'キーボードで $note を見つけます';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote => 'どの音符が強調表示されていますか?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'キーボード上に $chord をビルドします';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord => 'どのコードが強調表示されますか?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return '$scaleName 内のすべての音符を選択します';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return '$keyName に属するノートを選択します';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return '$keyName で、$roman に一致するコードはどれですか?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return '$keyName で、ローマ数字 が $chord と一致するものはどれですか?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return '$keyName では、$chord ダイアトニック ですか?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return '$keyNameにおいて、$chordはどのような機能を持っていますか？';
  }

  @override
  String get studyHarmonyProgressionStripLabel => '進行状況';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      'この進行に最も適合する キーセンター はどれですか?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '$chord はここでどのような機能を果たしますか?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      'この進行の中で ダイアトニック が最も感じられないコードはどれですか?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      'どのコードが空白を埋めるのに最も適していますか?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return 'アナライザーは、$keyLabel でこの進行を最も明確に読み取ります。';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return 'このコンテキストでは、$chord は $functionLabel コードと最もよく似た動作をします。';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord はメインの $keyLabel 読み取り値に対して際立っているため、ノンダイアトニック の最良の選択です。';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord は、この進行で予想される $functionLabel プルを復元します。';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index。 $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonicメジャー';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic ナチュラルマイナー';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonicハーモニックマイナー';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonicメジャー';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic マイナー';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'ダイアトニック';

  @override
  String get studyHarmonyChoiceNonDiatonic => '非 ダイアトニック';

  @override
  String get studyHarmonyChoiceTonic => 'トニック';

  @override
  String get studyHarmonyChoicePredominant => '優勢';

  @override
  String get studyHarmonyChoiceDominant => '支配的な';

  @override
  String get studyHarmonyChoiceOther => '他の';

  @override
  String get chordAnalyzerTitle => 'コード解析';

  @override
  String get chordAnalyzerSubtitle => '進行を貼り付けると、保守的な和声解釈を返します。';

  @override
  String get chordAnalyzerInputLabel => 'コード進行';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7, ? | Am7';

  @override
  String get chordAnalyzerInputHelper =>
      '括弧の外では、スペース、|、カンマでコードを区切れます。括弧内のカンマは同じコード内に残ります。\n\n不明なコード枠には ? を使えます。アナライザーが前後の文脈から最も自然な補完を推定し、解釈が曖昧な場合は候補も提案します。変化生成でもその枠はより自由に再ハーモナイズできます。\n\n小文字ルート、スラッシュベース、sus/alt/add 形式、C7(b9, #11) のようなテンション表記に対応しています。\n\nタッチ端末ではコードパッドを使うか、自由入力したいときに ABC 入力へ切り替えられます。';

  @override
  String get chordAnalyzerInputHelpTitle => '入力のヒント';

  @override
  String get chordAnalyzerAnalyze => '解析する';

  @override
  String get chordAnalyzerKeyboardTitle => 'コードパッド';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      'トークンをタップして進行を組み立てます。ABC 入力にすると、自由入力が必要なときもシステムキーボードを使えます。';

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
  String get chordAnalyzerClear => 'リセット';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'スペース';

  @override
  String get chordAnalyzerAnalyzing => '進行を解析中...';

  @override
  String get chordAnalyzerInitialTitle => '進行から始める';

  @override
  String get chordAnalyzerInitialBody =>
      'Dm7, G7, ? | Am7 や Cmaj7 | Am7 D7 | Gmaj7 のような進行を入力すると、考えられるキー、ローマ数字、推定補完、短い要約を確認できます。';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'この ? は前後の和声文脈から推定したスロットです。';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return '推定候補: $chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => '検出されたキー';

  @override
  String get chordAnalyzerPrimaryReading => '主要な読み';

  @override
  String get chordAnalyzerAlternativeReading => '代替の読み';

  @override
  String get chordAnalyzerChordAnalysis => 'コードごとの分析';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '$index 小節目';
  }

  @override
  String get chordAnalyzerProgressionSummary => '進行の要約';

  @override
  String get chordAnalyzerWarnings => '注意点と曖昧さ';

  @override
  String get chordAnalyzerNoInputError => '解析するコード進行を入力してください。';

  @override
  String get chordAnalyzerNoRecognizedChordsError => '進行内に認識できるコードが見つかりませんでした。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '一部の記号を読み飛ばしました: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return 'キーセンターは $primary と $alternative の間で、まだやや曖昧です。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      '一部のコードはなお曖昧なままなので、この読みは意図的に保守的にとどめています。';

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
    return '$target に向かう可能性のあるセカンダリー・ドミナントです。';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '$target に向かう可能性のあるトライトーン・サブです。';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      '平行短調からのモーダル・インターチェンジの可能性があります。';

  @override
  String get chordAnalyzerRemarkAmbiguous => 'このコードは現在の読みでも曖昧さが残ります。';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      'このコードは現在の保守的なヒューリスティクスでは未解決のままです。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I ケーデンス';

  @override
  String get chordAnalyzerTagTurnaround => 'ターンアラウンド';

  @override
  String get chordAnalyzerTagDominantResolution => 'ドミナント解決';

  @override
  String get chordAnalyzerTagPlagalColor => 'プラガル / モーダルな色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return 'この進行は $key を中心とみるのが最も自然そうです。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '別の読みとしては $key が考えられます。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '$tag の性格も示しています。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from と $through は、$target に向かう $fromFunction と $throughFunction の和音のように振る舞います。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord は $target に向かう可能性のあるセカンダリー・ドミナントとして捉えることもできます。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord は $target に向かう可能性のあるトライトーン・サブとして捉えることもできます。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord はモーダル・インターチェンジ由来の色彩を加えている可能性があります。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      '細部には曖昧さが残るため、この読みは意図的に保守的に保っています。';

  @override
  String get chordAnalyzerExamplesTitle => '例';

  @override
  String get chordAnalyzerConfidenceLabel => '確信度';

  @override
  String get chordAnalyzerAmbiguityLabel => '曖昧さ';

  @override
  String get chordAnalyzerWhyThisReading => 'この読みになる理由';

  @override
  String get chordAnalyzerCompetingReadings => '他にもあり得る読み';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '無視された修飾子: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => 'バリエーションを作る';

  @override
  String get chordAnalyzerVariationsTitle => '自然なバリエーション';

  @override
  String get chordAnalyzerVariationsBody =>
      '近い機能の代理和音で流れを保ったまま色味を変えた提案です。適用するとそのまま再解析します。';

  @override
  String get chordAnalyzerApplyVariation => 'この変形を使う';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => '終止の色替え';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      '到着先はそのままに、プレドミナントを少し暗くしてトライトーン代理のドミナントへ置き換えます。';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'バックドアの色味';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      '平行短調由来の ivm7-bVII7 の色で、同じトニックへ着地します。';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => '狙いを保つ ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      '同じ着地点へ向かう関連 ii-V を組み直します。';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => '短調終止の色味';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      '短調の終止感は保ったまま、iiø-Valt-i の色を強めます。';

  @override
  String get chordAnalyzerVariationColorLiftTitle => 'カラーリフト';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      'ルートと機能は近く保ちつつ、自然なテンションで表情を持ち上げます。';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '入力上の注意: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括弧の対応が崩れているため、記号の一部が不確かです。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '予期しない閉じ括弧を無視しました。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '$extension の明示的な色彩がこの読みを補強します。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'オルタード・ドミナントの色彩がドミナント機能を支えています。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return 'スラッシュベース $bass はベースラインや転回の意味を保っています。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '次のコードが $target への解決を支えています。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => 'この色彩は平行調から借用されたものとして聞けます。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      'サスペンションの色彩が、ドミナントの引力を消さずに和らげています。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '低信頼の読み';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      'キー候補どうしが近いか、一部の記号が部分的にしか復元できていないため、まずは慎重な一次読みとして扱ってください。';

  @override
  String get chordAnalyzerEmptyMeasure => 'この小節は空ですが、カウントには残しています。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      'この小節では解析可能なコード記号を復元できませんでした。';

  @override
  String get chordAnalyzerParseIssuesTitle => '解析上の問題';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空のトークンです。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => 'ルートを認識できませんでした。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root は対応していないルート表記です。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return 'スラッシュベース $bass は対応していないベース表記です。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '未対応のサフィックスまたは修飾子です: $suffix';
  }

  @override
  String get studyHarmonyDailyReplayAction => '毎日リプレイ';

  @override
  String get studyHarmonyMilestoneCabinetTitle => 'マイルストーンメダル';

  @override
  String get studyHarmonyMilestoneLessonsTitle => 'パスファインダーメダル';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return 'Core Foundations の $target レッスンをクリアします。';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => 'スターコレクター';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return '和声学習 全体で $target 個のスターを集めます。';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => 'ストリークレジェンド';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return '毎日の最高連続記録 $target を達成しましょう。';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => '熟練学者';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return '$target スキルをマスターしましょう。';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return '$earned/$total メダル獲得数';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => 'キャビネット完成';

  @override
  String get studyHarmonyMilestoneTierBronze => '銅メダル';

  @override
  String get studyHarmonyMilestoneTierSilver => '銀メダル';

  @override
  String get studyHarmonyMilestoneTierGold => '金メダル';

  @override
  String get studyHarmonyMilestoneTierPlatinum => 'プラチナメダル';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => '新しいメダル';

  @override
  String get studyHarmonyChapterRemixTitle => 'リミックスアリーナ';

  @override
  String get studyHarmonyChapterRemixDescription =>
      '警告なしに キーセンター、関数、および借用した色をシャッフルする長い混合セット。';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => '橋を架ける人';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      'ステッチ機能が読み取り、欠落しているコードを 1 つの流れるチェーンに埋め込みます。';

  @override
  String get studyHarmonyLessonRemixPivotTitle => 'カラーピボット';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      '進行状況が下で変化するにつれて、借用した色とキー中心のピボットを追跡します。';

  @override
  String get studyHarmonyLessonRemixSprintTitle => '解像度スプリント';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      '関数、ケイデンスフィル、トーングラビティを連続してより速いペースで読み取ります。';

  @override
  String get studyHarmonyLessonRemixBossTitle => 'リミックスマラソン';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      '進行を読むあらゆるレンズをセットに戻す最後の混合マラソン。';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return 'ストリークセーバー x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return 'レジェンドクラウン $count';
  }

  @override
  String get studyHarmonyModeFocus => 'フォーカスモード';

  @override
  String get studyHarmonyModeLegend => 'レジェンドトライアル';

  @override
  String get studyHarmonyFocusCardTitle => 'フォーカススプリント';

  @override
  String get studyHarmonyFocusCardHint =>
      '現在の進路でいちばん弱い重なりを、少ないライフと厳しめの目標で集中的に攻めます。';

  @override
  String get studyHarmonyFocusFallbackHint => 'いまの弱点に圧をかける、少し厳しめのミックスドリルです。';

  @override
  String get studyHarmonyFocusAction => 'スプリント開始';

  @override
  String get studyHarmonyFocusSessionTitle => 'フォーカススプリント';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return '$chapter 付近の最も弱いスポットから構築された、より緊密な混合スプリント。';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count レッスン混合';
  }

  @override
  String get studyHarmonyFocusRewardLabel => '週次報酬: ストリークセーバー';

  @override
  String get studyHarmonyLegendCardTitle => 'レジェンドトライアル';

  @override
  String get studyHarmonyLegendCardHint =>
      'シルバー以上のチャプターを 2 ライフのマスタリーランで再突破して、レジェンドクラウンを確保しましょう。';

  @override
  String get studyHarmonyLegendFallbackHint =>
      'チャプターを 1 つ仕上げ、1 レッスンあたりおよそ 2 つ星まで伸ばすとレジェンド試練が開放されます。';

  @override
  String get studyHarmonyLegendAction => 'レジェンド挑戦';

  @override
  String get studyHarmonyLegendSessionTitle => 'レジェンドトライアル';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return '$chapter をもう一度きっちり通し、レジェンドクラウンを確保するための精熟リプレイです。';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count レッスンの連鎖';
  }

  @override
  String get studyHarmonyLegendRiskLabel => 'レジェンドの栄冠がかかっている';

  @override
  String get studyHarmonyWeeklyPlanTitle => '週間トレーニング計画';

  @override
  String get studyHarmonyWeeklyRewardLabel => '報酬: ストリークセーバー';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => '報酬の準備完了';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => '報酬の請求';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => '複数の日に現れる';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return '今週は $target の異なる日にアクティブに過ごしましょう。';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle => '毎日のループを維持する';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return '今週はログ $target が毎日クリアされます。';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle => 'フォーカススプリントを完了する';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return '今週は $target フォーカス スプリントを完了してください。';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      '昨日はストリークセーバーで連続記録を守りました。';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return '新しいストリークセーバーを獲得しました。在庫: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => 'フォーカススプリントをクリアしました。';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return '$chapterのレジェンド王冠確保。';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => 'アンコールラダー';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      '進行ツールキット全体を最終的なアンコール セットに圧縮する短い仕上げのラダーです。';

  @override
  String get studyHarmonyLessonEncorePulseTitle => 'トーナルパルス';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      'ウォームアッププロンプトなしで音の中心を固定し、機能します。';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => 'カラースワップ';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      '借用した色の呼び出しを交互に行い、失われたコードを復元して耳を正直に保ちます。';

  @override
  String get studyHarmonyLessonEncoreBossTitle => 'アンコールフィナーレ';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      'すべてのプログレッション レンズを立て続けにチェックする最後のコンパクトなボス ラウンド。';

  @override
  String get studyHarmonyChapterMasteryBronze => 'ブロンズクリア';

  @override
  String get studyHarmonyChapterMasterySilver => 'シルバークラウン';

  @override
  String get studyHarmonyChapterMasteryGold => 'ゴールドクラウン';

  @override
  String get studyHarmonyChapterMasteryLegendary => 'レジェンドクラウン';

  @override
  String get studyHarmonyModeBossRush => 'ボスラッシュモード';

  @override
  String get studyHarmonyBossRushCardTitle => 'ボスラッシュ';

  @override
  String get studyHarmonyBossRushCardHint =>
      '解放済みのボスレッスンを、少ないライフと高めのスコア条件で連続攻略します。';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      '本格的なボスラッシュを開くには、ボスレッスンを少なくとも 2 つ解放してください。';

  @override
  String get studyHarmonyBossRushAction => 'ラッシュ開始';

  @override
  String get studyHarmonyBossRushSessionTitle => 'ボスラッシュ';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return '$chapter 周辺で解放したボスレッスンを束ねた、高圧のボスガントレットです。';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count ボスレッスン混合';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => '2ライフのみ';

  @override
  String get studyHarmonyResultBossRushLine => 'ボスラッシュクリアしました。';

  @override
  String get studyHarmonyChapterSpotlightTitle => 'スポットライト対決';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      '借用したカラー、ケイデンスプレッシャー、ボスレベルの統合を分離する最後のスポットライトセット。';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => '借りたレンズ';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      '借用した色が読み取りを横に引っ張ろうとしている間、キーセンター を追跡します。';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => 'ケイデンススワップ';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      '着地点を失うことなく、関数の読み取りとケイデンスの復元を切り替えます。';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => 'スポットライト対決';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      'あらゆる累進レンズを圧力下でも鮮明に保つクロージングボスセット。';

  @override
  String get studyHarmonyChapterAfterHoursTitle => '時間外ラボ';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      'ウォームアップの手がかりを取り除き、借用したカラー、ケイデンスプレッシャー、センタートラッキングを混ぜ合わせたゲーム終盤のラボ。';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => 'モーダルシャドウ';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      '借用した色が読み取り値を暗闇に引きずり続ける間、キーセンター を押し続けます。';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => '解像度フェイント';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      'フレーズが本来の着地点を通り過ぎる前に、ファンクションとケイデンスのフェイクアウトをキャッチします。';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => 'センタークロスフェード';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      '追加の足場を必要とせずに、ブレンドセンターの検出、関数の読み取り、欠落コードの修復を行います。';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => 'ラストコールボス';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      'すべてのプログレッションレンズにプレッシャーの下でもクリアを保つよう要求する、深夜の最後のボスセット。';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return 'リレーが $count で勝利';
  }

  @override
  String get studyHarmonyModeRelay => 'アリーナリレー';

  @override
  String get studyHarmonyRelayCardTitle => 'アリーナリレー';

  @override
  String get studyHarmonyRelayCardHint =>
      '別々のチャプターで解放したレッスンを 1 本のインターリーブランに混ぜ、瞬時の切り替えと記憶の両方を試します。';

  @override
  String get studyHarmonyRelayFallbackHint =>
      'アリーナリレー を開くには、少なくとも 2 つの章のロックを解除してください。';

  @override
  String get studyHarmonyRelayAction => 'リレー開始';

  @override
  String get studyHarmonyRelaySessionTitle => 'アリーナリレー';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return '$chapter 周辺のロック解除されたチャプターを混合したインターリーブリレー実行。';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return '$count のレッスンが中継されました';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count チャプターが混在';
  }

  @override
  String get studyHarmonyRelayChainLabel => '圧力下でのインターリーブ';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return 'リレーが $count で勝利';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => 'リレーランナー';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return '$target をクリア アリーナリレー が実行されます。';
  }

  @override
  String get studyHarmonyChapterNeonTitle => 'ネオンの迂回路';

  @override
  String get studyHarmonyChapterNeonDescription =>
      '借りた色、ピボットプレッシャー、リカバリーリードで道を曲げ続けるゲーム終盤の章。';

  @override
  String get studyHarmonyLessonNeonDetourTitle => 'モーダル迂回路';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      '借用した色がフレーズを脇道に押し込み続けながらも、真の中心を追跡します。';

  @override
  String get studyHarmonyLessonNeonPivotTitle => 'ピボット圧力';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      '高調波レーンが再び変更される前に、センターシフトと機能圧力を連続して読み取ります。';

  @override
  String get studyHarmonyLessonNeonLandingTitle => '借用着陸';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      '借用色のフェイクアウトにより予想される解像度が変化した後、欠落している着陸コードを修復します。';

  @override
  String get studyHarmonyLessonNeonBossTitle => 'シティライツのボス';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      'ピボットの読み取り、借用した色、リズムの回復をソフトランディングなしで組み合わせた、最後のネオンボス。';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tierリーグ';
  }

  @override
  String get studyHarmonyLeagueCardTitle => 'ハーモニーリーグ';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return '今週は $tier リーグを目指しましょう。いま最も効率よく伸ばせるのは $mode です。';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      '今週のダイヤは確保済みです。このまま高圧のクリアをつないでペースを守りましょう。';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      '今週プッシュすべき推奨ランがあると、リーグの上昇が点灯します。';

  @override
  String get studyHarmonyLeagueAction => 'リーグ挑戦';

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '今週の $score XP';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '今週の $score/$target XP';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return '次へ: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return '最高のブースト: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return 'リーグ XP +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return '$tierリーグに昇格';
  }

  @override
  String get studyHarmonyLeagueTierRookie => 'ルーキー';

  @override
  String get studyHarmonyLeagueTierBronze => 'ブロンズ';

  @override
  String get studyHarmonyLeagueTierSilver => '銀';

  @override
  String get studyHarmonyLeagueTierGold => '金';

  @override
  String get studyHarmonyLeagueTierDiamond => 'ダイヤモンド';

  @override
  String get studyHarmonyChapterMidnightTitle => '深夜の切替盤';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      '最後のコントロールルームの章では、センターの漂流、誤ったリズム、借用した再ルートを介して高速読み取りを強制します。';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => 'シグナルの揺れ';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      '表面が借用した色に漂い続けているときでも、真の音色信号を追跡します。';

  @override
  String get studyHarmonyLessonMidnightLineTitle => '見せかけの進行線';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      '線が所定の位置に折り返される前に、偽の解像度を通じて関数の圧力を読み取ります。';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => '借用による迂回';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      '借用した色によってフレーズの途中でルートが変更された後、予想される着地を回復します。';

  @override
  String get studyHarmonyLessonMidnightBossTitle => 'ブラックアウト・ボス';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      '安全なリセットを提供せずに、ゲーム終盤のあらゆるレンズを組み合わせたクロージング ブラックアウト セット。';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return 'クエストチェスト $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return 'リーグ XP 2 倍 x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => 'クエスト宝箱';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count クエストが残っています';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => 'クエスト宝箱 準備完了';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => 'クエスト宝箱 がオープンしました';

  @override
  String get studyHarmonyQuestChestBoostHeadline => 'リーグ XP ライブ 2 倍';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return '報酬: +$xp リーグ XP';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      '今日のクエスト 3 つを終えてボーナス宝箱を開け、今週の上昇をつなげましょう。';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      '今日のクエスト 3 つはすべて完了です。あと 1 ラン クリアすると宝箱ボーナスを受け取れます。';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      '今日のトリオは完了し、チェストボーナスはすでにリーグ XP に変換されています。';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return '今日の宝箱は開いていて、次の $count クリアはリーグ XP が 2 倍になります。';
  }

  @override
  String get studyHarmonyQuestChestAction => 'フィニッシュ・トリオ';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return 'おすすめの締め: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return 'XP 2倍 x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return 'デイリークエスト $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => 'クエスト宝箱 がオープンしました。';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return 'クエスト宝箱 ボーナス +$count リーグ XP';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '次の $count クリアはリーグ XP 2 倍';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return 'ブーストボーナス +$count リーグ XP';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return '2倍ブーストで左$countをクリア';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return 'XP 2倍 x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return '次の $count クリアはリーグ XP 2 倍です。ブースト中に $mode へ使いましょう。';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => 'スカイライン・サーキット';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      'ゴーストセンター、借用した重力、偽のホーム全体で高速混合読み取りを強制する最後のスカイライン回路。';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => '残像パルス';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      'フレーズが新しいレーンに固定される前に、中心を捉えて残像の中で機能します。';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => '重力反転';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      '進行がその重みを交換し続ける間、借用した重力と欠落コードの修復を処理します。';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => '偽着地';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      '進行が止まる前に、誤った到着を読み、真の着陸を再構築します。';

  @override
  String get studyHarmonyLessonSkylineBossTitle => '最終シグナル・ボス';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      'スカイラインの最後のボスは、ゲーム後半のすべての進行レンズを 1 つの終了信号テストに連鎖させます。';

  @override
  String get studyHarmonyChapterAfterglowTitle => '残光ランウェイ';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      'スプリットディシジョン、借用餌、明滅するセンターの終わりの滑走路は、プレッシャーの下でゲーム終盤のきれいな読みに報いる。';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => '分岐判断';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      'フレーズがコースから外れることなく機能を維持できる修復コードを選択してください。';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => '借用の誘い';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      '進行が元に戻る前に、ピボットのように見える借用したカラー コードを見つけます。';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => '中心の揺らぎ';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      'ケイデンスキューが点滅している間、音の中心を押したままにして、素早く連続してルートを変更します。';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => 'レッドラインリターンボス';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      'キーセンター、機能、借用色、欠落コード修復をフルスピードで組み合わせた最終混合テスト。';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return 'ツアースタンプ $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => 'マンスリーツアーをクリアしました';

  @override
  String get studyHarmonyTourTitle => 'ハーモニーツアー';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return '$count/$target ツアースタンプ';
  }

  @override
  String get studyHarmonyTourReadyHeadline => 'ツアーファイナル準備完了';

  @override
  String get studyHarmonyTourClaimedHeadline => 'マンスリーツアーをクリアしました';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return '報酬: リーグ XP +$xp とストリークセーバー $count';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return '今月は $target 日以上プレイして、ツアーボーナスを確定させましょう。';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return '今月はクエスト宝箱を $target 個開けて、ツアーのスタンプ帳を前に進めましょう。';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return '今月はスポットライトランを $target 回クリアしましょう。ボスラッシュ、アリーナリレー、フォーカススプリント、レジェンドトライアル、ボスレッスンはすべて対象です。';
  }

  @override
  String get studyHarmonyTourReadyBody =>
      '今月のスタンプはすべてそろいました。あと 1 クリアでツアーボーナスが確定します。';

  @override
  String get studyHarmonyTourClaimedBody =>
      '今月のツアーは終了しました。来月のルートが熱く始まるように、リズムを鋭く保ちましょう。';

  @override
  String get studyHarmonyTourAction => '事前ツアー';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return '活動日 $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'クエスト宝箱 $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'スポットライト $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'ハーモニーツアー 完了';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return 'ツアーボーナス +$count リーグ XP';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'ストリークセーバー在庫 $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => '夜明けの周波数';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      'ゴーストのリズム、偽の夜明けのピボット、借用した花々からなる日の出のアンコールは、長いランの後にクリーンなゲーム後半の読みを強制します。';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => '幻の終止';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      'フレーズが実際には着地せずに閉じているように見える場合、ケイデンスと機能を同時に修復します。';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => '見せかけの夜明け';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      '進行が再び遠ざかる前に、早すぎる日の出の中に隠れているセンターシフトを捉えてください。';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => '借用の開花';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      '借用した色と機能を一緒に追跡しながら、ハーモニーはより明るく、しかし不安定なレーンへと広がります。';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => 'サンライズオーバードライブボス';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      'キーセンター、機能、ノンダイアトニック カラー、ミッシングコード修復を最後の 1 つのオーバードライブ セットに連鎖させる、ドーン スピードの最後のボスです。';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return 'デュエット ストリーク $count';
  }

  @override
  String get studyHarmonyDuetTitle => 'デュエット契約';

  @override
  String get studyHarmonyDuetStartHeadline => '今日のデュエットを始めます';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return 'デュエット ストリーク $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return '$count 日はデュエットがロックされました';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return '報酬: 節目のストリークでリーグ XP +$xp';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      'まず今日のデイリーを終えて、そのあとスポットライトランを 1 回クリアしてデュエットをつなぎましょう。';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'デイリーが始まります。フォーカス、リレー、ボス ラッシュ、レジェンド、またはボス レッスンなどのスポットライト ランを 1 つ完了して、デュエットを封印します。';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return '今日のデュエットは成立済みで、共有ストリークは $count 日まで伸びています。';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'デイリーイン';

  @override
  String get studyHarmonyDuetDailyMissing => '毎日行方不明';

  @override
  String get studyHarmonyDuetSpotlightDone => 'スポットライトイン';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'スポットライトがありません';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return '毎日$done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return 'スポットライト $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return 'ストリーク $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => 'デュエットを続けてください';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return 'デュエット ストリーク $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return 'デュエット報酬 +$count リーグ XP';
  }

  @override
  String get studyHarmonySolfegeDo => 'ド';

  @override
  String get studyHarmonySolfegeRe => 'レ';

  @override
  String get studyHarmonySolfegeMi => 'ミ';

  @override
  String get studyHarmonySolfegeFa => 'ファ';

  @override
  String get studyHarmonySolfegeSol => 'ソ';

  @override
  String get studyHarmonySolfegeLa => 'ラ';

  @override
  String get studyHarmonySolfegeTi => 'シ';

  @override
  String get studyHarmonyPrototypeCourseTitle => '和声学習プロトタイプ';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      'レッスン制に引き継いだ初期プロトタイプのレベルです。';

  @override
  String get studyHarmonyPrototypeChapterTitle => 'プロトタイプレッスン';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      '拡張型の学習システムを導入する間、暫定的に残しているレッスンです。';

  @override
  String get studyHarmonyPrototypeLevelObjective => 'ライフを3つ失う前に10問正解でクリア';

  @override
  String get studyHarmonyPrototypeLevel1Title => 'プロトタイプレベル 1 ・ド / ミ / ソ';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      'ド、ミ、ソだけを聞き分ける基礎ウォームアップです。';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      'プロトタイプレベル 2 ・ド / レ / ミ / ソ / ラ';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      'ド、レ、ミ、ソ、ラの認識を素早くする中級前のレベルです。';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      'プロトタイプレベル 3 ・ド / レ / ミ / ファ / ソ / ラ / シ / ド';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      'ドレミファソラシドをひと通り扱うオクターブ完成レベルです。';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName（低い C）';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName（高い C）';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => 'テンプレート';

  @override
  String get studyHarmonyChapterBlueHourTitle => 'ブルーアワー交差';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      '交差する流れ、後光の借景、そしてゲーム終盤の読みを最良の方法で不安定に保つ二重地平線の黄昏のアンコール。';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => '交差する流れ';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      'キーセンター を追跡し、進行が同時に 2 方向に引っ張り始める間機能します。';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => '光輪の借用';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      '借りた色を読み取って、フレーズが霞む前に失われたコードを復元します。';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => '二重の地平線';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      '2 つの可能性のある地平線が点滅し続ける間、実際の到着点を保持します。';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => 'ツインランタンのボス';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      'ブルーアワーの最後のボスは、センター、機能、借用カラー、欠落コードの修復全体で高速スワップを強制します。';
}
