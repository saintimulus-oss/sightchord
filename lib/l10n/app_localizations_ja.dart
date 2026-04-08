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
      'スペース: 次のコード Enter: 自動再生の開始/一時停止 Up/Down: BPM の調整';

  @override
  String get currentChord => '現在のコード';

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
  String get pauseAutoplay => '自動再生を一時停止';

  @override
  String get stopAutoplay => '自動再生を停止する';

  @override
  String get resetGeneratedChords => '生成コードをリセット';

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
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

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
  String get mainMenuIntro =>
      'Chordestで次のコードループを作り、必要なときだけ Analyzer で慎重な和声読解を確認しましょう。';

  @override
  String get mainMenuGeneratorTitle => 'Chordest 生成';

  @override
  String get mainMenuGeneratorDescription =>
      'すぐ弾けるコードループ、ボイシング補助、素早い練習操作をまとめて始められます。';

  @override
  String get openGenerator => '練習を始める';

  @override
  String get openAnalyzer => '進行を分析';

  @override
  String get mainMenuAnalyzerTitle => 'コード解析';

  @override
  String get mainMenuAnalyzerDescription => '考えられるキー、ローマ数字、警告を保守的な進行解釈で確認できます。';

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
      'ポップ用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを進められます。';

  @override
  String get studyHarmonyJazzTrackTitle => 'ジャズコース';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'ジャズ用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを練習できます。';

  @override
  String get studyHarmonyClassicalTrackTitle => 'クラシックコース';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'クラシック用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを学べます。';

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
  String get chordAnalyzerSubtitle =>
      '進行を貼り付けると、考えられるキー、ローマ数字、和声機能を保守的に読み取ります。';

  @override
  String get chordAnalyzerInputLabel => 'コード進行';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      '括弧の外では、スペース、|、カンマでコードを区切れます。括弧内のカンマは同じコード内に残ります。\n\n不明なコード枠には ? を使えます。アナライザーが前後の文脈から最も自然な補完を推定し、解釈が曖昧な場合は候補も提案します。\n\n小文字ルート、スラッシュベース、sus/alt/add 形式、C7(b9, #11) のようなテンション表記に対応しています。\n\nタッチ端末ではコードパッドを使うか、自由入力したいときに ABC 入力へ切り替えられます。';

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
      'Dm7, G7 | ? Am や Cmaj7 | Am7 D7 | Gmaj7 のような進行を入力すると、考えられるキー、ローマ数字、警告、推定補完、短い要約を確認できます。';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'この ? は前後の和声文脈から推定されたものです。確定値ではなく、候補の補完として受け取ってください。';

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
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

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
      'バランス型の標準サウンドを使うか、ポップ / ジャズ / クラシックの再生キャラクターを固定できます。';

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
      'major ii-V-I、minor iiø-V-i、turnaround の流れ';

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
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'minor iiø-V-i の進行感と、そこでドミナントがより切迫して聞こえる理由をつかみます。';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

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
      'major ii-V-I、minor iiø-V-i、rootless color、慎重な reharm を組み合わせても、終止の着地点が読み取りやすいかを確かめます。';

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
  String get practiceFirstRunWelcomeTitle => '最初のコードが準備できました';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      '初心者向けの開始プロファイルがすでに適用されています。まずは音を聴いて、カードをスワイプして次のコードを見てみましょう。';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel の準備ができました。まずは音を聴いて、カードをスワイプして次の流れを見てみましょう。必要ならセットアップアシスタントで開始内容を調整できます。';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => '記譜言語';

  @override
  String get musicNotationLocaleHelp => 'ローマ数字補助やコードテキスト補助で使う言語を切り替えます。';

  @override
  String get musicNotationLocaleUiDefault => 'アプリの言語に合わせる';

  @override
  String get musicNotationLocaleEnglish => '英語';

  @override
  String get noteNamingStyle => '音名表記';

  @override
  String get noteNamingStyleHelp => '和声ロジックは変えずに、表示する音名と調名の表記だけを切り替えます。';

  @override
  String get noteNamingStyleEnglish => '英字表記';

  @override
  String get noteNamingStyleLatin => 'ドレミ';

  @override
  String get showRomanNumeralAssist => 'ローマ数字補助を表示';

  @override
  String get showRomanNumeralAssistHelp => 'ローマ数字ラベルの横に短い説明を添えます。';

  @override
  String get showChordTextAssist => 'コードテキスト補助を表示';

  @override
  String get showChordTextAssistHelp => 'コードの性質やテンションを短いテキストで補足します。';

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
    return '永久アンロック ($priceLabel)';
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
      '現在ストアに接続できません。無料機能はそのまま使えます。';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      '現在、プレミアム商品の情報を取得できません。しばらくしてからもう一度お試しください。';

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
      '購入を完了できませんでした。しばらくしてからもう一度お試しください。';

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

  @override
  String get undoLabel => 'Undo';

  @override
  String get favoriteStartsTitle => 'Favorite starts';

  @override
  String favoriteStartSlotTitle(int displayIndex) {
    return 'Favorite $displayIndex';
  }

  @override
  String get favoriteStartEmptyMessage => 'No saved start preset yet.';

  @override
  String get favoriteStartSaveLabel => 'Save current';

  @override
  String get favoriteStartUpdateLabel => 'Update';

  @override
  String get favoriteStartApplyLabel => 'Apply';

  @override
  String get favoriteStartRenameLabel => 'Rename';

  @override
  String get favoriteStartClearLabel => 'Clear';

  @override
  String favoriteStartSavedMessage(int displayIndex) {
    return 'Saved the current setup to Favorite $displayIndex.';
  }

  @override
  String favoriteStartAppliedMessage(int displayIndex) {
    return 'Applied Favorite $displayIndex.';
  }

  @override
  String favoriteStartClearedMessage(int displayIndex) {
    return 'Cleared Favorite $displayIndex.';
  }

  @override
  String favoriteStartRenamedMessage(int displayIndex, Object label) {
    return 'Updated Favorite $displayIndex to \"$label\".';
  }

  @override
  String favoriteStartRenameDialogTitle(int displayIndex) {
    return 'Name Favorite $displayIndex';
  }

  @override
  String get favoriteStartRenameDialogHelper =>
      'Leave this blank to use the automatic label.';

  @override
  String get favoriteStartRenameConfirmLabel => 'Save name';

  @override
  String get copyToolsTitle => 'Copy tools';

  @override
  String get copyCurrentChordLabel => 'Copy current chord';

  @override
  String get copyVisibleLoopLabel => 'Copy visible loop';

  @override
  String get copyMelodyPreviewLabel => 'Copy melody preview';

  @override
  String get recentCopiesTitle => 'Recent copies';

  @override
  String get recentCopyCurrentChordLabel => 'Current chord';

  @override
  String get recentCopyVisibleLoopLabel => 'Visible loop';

  @override
  String get recentCopyMelodyPreviewLabel => 'Melody preview';

  @override
  String get nothingToCopyMessage => 'There is nothing to copy yet.';

  @override
  String get noRecentCopiesMessage => 'There is no recent copied text yet.';

  @override
  String get copiedCurrentChordMessage => 'Copied the current chord.';

  @override
  String get copiedVisibleLoopMessage => 'Copied the visible loop.';

  @override
  String get copiedMelodyPreviewMessage => 'Copied the melody preview.';

  @override
  String get copiedRecentCopyMessage => 'Copied from recent history.';

  @override
  String get analyzeVisibleLoopLabel => 'Analyze visible loop';

  @override
  String get quickMovesTitle => 'Quick moves';

  @override
  String get nudgeEasierLabel => 'Make easier';

  @override
  String get nudgeRicherLabel => 'Make richer';

  @override
  String get nothingToAnalyzeMessage =>
      'There is no visible loop to analyze yet.';

  @override
  String get nudgedEasierMessage => 'Shifted toward an easier profile.';

  @override
  String get nudgedRicherMessage => 'Shifted toward a richer profile.';

  @override
  String get alreadyEasierMessage =>
      'This is already near the easiest setting.';

  @override
  String get alreadyRicherMessage =>
      'This is already near the richest quick setting.';

  @override
  String get currentChordLabel => 'Current';

  @override
  String get nextChordLabel => 'Next';

  @override
  String get chordAnalyzerPinnedSectionTitle => 'Pinned progressions';

  @override
  String get chordAnalyzerRecentSectionTitle => 'Recent analyses';

  @override
  String get chordAnalyzerPinLabel => 'Pin';

  @override
  String get chordAnalyzerUnpinLabel => 'Unpin';

  @override
  String get chordAnalyzerPinTooltip => 'Pin this progression for quick reuse.';

  @override
  String get chordAnalyzerUnpinTooltip =>
      'Remove this progression from pinned items.';

  @override
  String chordAnalyzerPinnedProgressionTooltip(Object progression) {
    return 'Analyze this pinned progression again.\n$progression';
  }

  @override
  String chordAnalyzerRecentProgressionTooltip(Object progression) {
    return 'Reopen this recent analysis.\n$progression';
  }

  @override
  String get chordAnalyzerPracticeThisKeyLabel => 'Practice this key';

  @override
  String chordAnalyzerPracticeThisKeyTooltip(Object keyLabel) {
    return 'Open the generator in $keyLabel. (G)';
  }
}

/// The translations for Japanese, as used in Japan (`ja_JP`).
class AppLocalizationsJaJp extends AppLocalizationsJa {
  AppLocalizationsJaJp() : super('ja_JP');

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
      'スペース: 次のコード Enter: 自動再生の開始/一時停止 Up/Down: BPM の調整';

  @override
  String get currentChord => '現在のコード';

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
  String get pauseAutoplay => '自動再生を一時停止';

  @override
  String get stopAutoplay => '自動再生を停止する';

  @override
  String get resetGeneratedChords => '生成コードをリセット';

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
  String get voicingDisplayMode => 'Voicing Display Mode';

  @override
  String get voicingDisplayModeHelp =>
      'Switch between the standard three-card view and a performance-focused current/next preview.';

  @override
  String get voicingDisplayModeStandard => 'Standard';

  @override
  String get voicingDisplayModePerformance => 'Performance';

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
  String get mainMenuIntro =>
      'Chordestで次のコードループを作り、必要なときだけ Analyzer で慎重な和声読解を確認しましょう。';

  @override
  String get mainMenuGeneratorTitle => 'Chordest 生成';

  @override
  String get mainMenuGeneratorDescription =>
      'すぐ弾けるコードループ、ボイシング補助、素早い練習操作をまとめて始められます。';

  @override
  String get openGenerator => '練習を始める';

  @override
  String get openAnalyzer => '進行を分析';

  @override
  String get mainMenuAnalyzerTitle => 'コード解析';

  @override
  String get mainMenuAnalyzerDescription => '考えられるキー、ローマ数字、警告を保守的な進行解釈で確認できます。';

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
      'ポップ用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを進められます。';

  @override
  String get studyHarmonyJazzTrackTitle => 'ジャズコース';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'ジャズ用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを練習できます。';

  @override
  String get studyHarmonyClassicalTrackTitle => 'クラシックコース';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'クラシック用の進行として、独立した進捗・デイリーピック・復習キューで全カリキュラムを学べます。';

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
  String get chordAnalyzerSubtitle =>
      '進行を貼り付けると、考えられるキー、ローマ数字、和声機能を保守的に読み取ります。';

  @override
  String get chordAnalyzerInputLabel => 'コード進行';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      '括弧の外では、スペース、|、カンマでコードを区切れます。括弧内のカンマは同じコード内に残ります。\n\n不明なコード枠には ? を使えます。アナライザーが前後の文脈から最も自然な補完を推定し、解釈が曖昧な場合は候補も提案します。\n\n小文字ルート、スラッシュベース、sus/alt/add 形式、C7(b9, #11) のようなテンション表記に対応しています。\n\nタッチ端末ではコードパッドを使うか、自由入力したいときに ABC 入力へ切り替えられます。';

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
      'Dm7, G7 | ? Am や Cmaj7 | Am7 D7 | Gmaj7 のような進行を入力すると、考えられるキー、ローマ数字、警告、推定補完、短い要約を確認できます。';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      'この ? は前後の和声文脈から推定されたものです。確定値ではなく、候補の補完として受け取ってください。';

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
  String get studyHarmonyTourEmptyBody =>
      'Monthly tour goals will appear here as you log activity this month.';

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
      'バランス型の標準サウンドを使うか、ポップ / ジャズ / クラシックの再生キャラクターを固定できます。';

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
      'major ii-V-I、minor iiø-V-i、turnaround の流れ';

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
      'Learn to hear cadence direction through inner lines, then add richer dominant color without losing the thread.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => 'Guide-Tone Hearing';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'Track the 3rds and 7ths that define a major ii-V-I with minimal clutter.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => 'Shell Voicings';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'Keep the cadence clear with lean shell shapes and simple turnaround motion.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => 'Minor Cadence';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'minor iiø-V-i の進行感と、そこでドミナントがより切迫して聞こえる理由をつかみます。';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => 'Rootless Voicings';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => 'Dominant Color';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      'Add safe tension and substitute color without losing the cadence target.';

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
      'major ii-V-I、minor iiø-V-i、rootless color、慎重な reharm を組み合わせても、終止の着地点が読み取りやすいかを確かめます。';

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
  String get practiceFirstRunWelcomeTitle => '最初のコードが準備できました';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      '初心者向けの開始プロファイルがすでに適用されています。まずは音を聴いて、カードをスワイプして次のコードを見てみましょう。';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel の準備ができました。まずは音を聴いて、カードをスワイプして次の流れを見てみましょう。必要ならセットアップアシスタントで開始内容を調整できます。';
  }

  @override
  String get practiceFirstRunSetupButton => 'Personalize';

  @override
  String get musicNotationLocale => '記譜言語';

  @override
  String get musicNotationLocaleHelp => 'ローマ数字補助やコードテキスト補助で使う言語を切り替えます。';

  @override
  String get musicNotationLocaleUiDefault => 'アプリの言語に合わせる';

  @override
  String get musicNotationLocaleEnglish => '英語';

  @override
  String get noteNamingStyle => '音名表記';

  @override
  String get noteNamingStyleHelp => '和声ロジックは変えずに、表示する音名と調名の表記だけを切り替えます。';

  @override
  String get noteNamingStyleEnglish => '英字表記';

  @override
  String get noteNamingStyleLatin => 'ドレミ';

  @override
  String get showRomanNumeralAssist => 'ローマ数字補助を表示';

  @override
  String get showRomanNumeralAssistHelp => 'ローマ数字ラベルの横に短い説明を添えます。';

  @override
  String get showChordTextAssist => 'コードテキスト補助を表示';

  @override
  String get showChordTextAssistHelp => 'コードの性質やテンションを短いテキストで補足します。';

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
    return '永久アンロック ($priceLabel)';
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
      '現在ストアに接続できません。無料機能はそのまま使えます。';

  @override
  String get premiumUnlockProductUnavailableTitle => 'Product not ready';

  @override
  String get premiumUnlockProductUnavailableBody =>
      '現在、プレミアム商品の情報を取得できません。しばらくしてからもう一度お試しください。';

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
      '購入を完了できませんでした。しばらくしてからもう一度お試しください。';

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

  @override
  String get undoLabel => 'Undo';

  @override
  String get favoriteStartsTitle => 'Favorite starts';

  @override
  String favoriteStartSlotTitle(int displayIndex) {
    return 'Favorite $displayIndex';
  }

  @override
  String get favoriteStartEmptyMessage => 'No saved start preset yet.';

  @override
  String get favoriteStartSaveLabel => 'Save current';

  @override
  String get favoriteStartUpdateLabel => 'Update';

  @override
  String get favoriteStartApplyLabel => 'Apply';

  @override
  String get favoriteStartRenameLabel => 'Rename';

  @override
  String get favoriteStartClearLabel => 'Clear';

  @override
  String favoriteStartSavedMessage(int displayIndex) {
    return 'Saved the current setup to Favorite $displayIndex.';
  }

  @override
  String favoriteStartAppliedMessage(int displayIndex) {
    return 'Applied Favorite $displayIndex.';
  }

  @override
  String favoriteStartClearedMessage(int displayIndex) {
    return 'Cleared Favorite $displayIndex.';
  }

  @override
  String favoriteStartRenamedMessage(int displayIndex, Object label) {
    return 'Updated Favorite $displayIndex to \"$label\".';
  }

  @override
  String favoriteStartRenameDialogTitle(int displayIndex) {
    return 'Name Favorite $displayIndex';
  }

  @override
  String get favoriteStartRenameDialogHelper =>
      'Leave this blank to use the automatic label.';

  @override
  String get favoriteStartRenameConfirmLabel => 'Save name';

  @override
  String get copyToolsTitle => 'Copy tools';

  @override
  String get copyCurrentChordLabel => 'Copy current chord';

  @override
  String get copyVisibleLoopLabel => 'Copy visible loop';

  @override
  String get copyMelodyPreviewLabel => 'Copy melody preview';

  @override
  String get recentCopiesTitle => 'Recent copies';

  @override
  String get recentCopyCurrentChordLabel => 'Current chord';

  @override
  String get recentCopyVisibleLoopLabel => 'Visible loop';

  @override
  String get recentCopyMelodyPreviewLabel => 'Melody preview';

  @override
  String get nothingToCopyMessage => 'There is nothing to copy yet.';

  @override
  String get noRecentCopiesMessage => 'There is no recent copied text yet.';

  @override
  String get copiedCurrentChordMessage => 'Copied the current chord.';

  @override
  String get copiedVisibleLoopMessage => 'Copied the visible loop.';

  @override
  String get copiedMelodyPreviewMessage => 'Copied the melody preview.';

  @override
  String get copiedRecentCopyMessage => 'Copied from recent history.';

  @override
  String get analyzeVisibleLoopLabel => 'Analyze visible loop';

  @override
  String get quickMovesTitle => 'Quick moves';

  @override
  String get nudgeEasierLabel => 'Make easier';

  @override
  String get nudgeRicherLabel => 'Make richer';

  @override
  String get nothingToAnalyzeMessage =>
      'There is no visible loop to analyze yet.';

  @override
  String get nudgedEasierMessage => 'Shifted toward an easier profile.';

  @override
  String get nudgedRicherMessage => 'Shifted toward a richer profile.';

  @override
  String get alreadyEasierMessage =>
      'This is already near the easiest setting.';

  @override
  String get alreadyRicherMessage =>
      'This is already near the richest quick setting.';

  @override
  String get currentChordLabel => 'Current';

  @override
  String get nextChordLabel => 'Next';

  @override
  String get chordAnalyzerPinnedSectionTitle => 'Pinned progressions';

  @override
  String get chordAnalyzerRecentSectionTitle => 'Recent analyses';

  @override
  String get chordAnalyzerPinLabel => 'Pin';

  @override
  String get chordAnalyzerUnpinLabel => 'Unpin';

  @override
  String get chordAnalyzerPinTooltip => 'Pin this progression for quick reuse.';

  @override
  String get chordAnalyzerUnpinTooltip =>
      'Remove this progression from pinned items.';

  @override
  String chordAnalyzerPinnedProgressionTooltip(Object progression) {
    return 'Analyze this pinned progression again.\n$progression';
  }

  @override
  String chordAnalyzerRecentProgressionTooltip(Object progression) {
    return 'Reopen this recent analysis.\n$progression';
  }

  @override
  String get chordAnalyzerPracticeThisKeyLabel => 'Practice this key';

  @override
  String chordAnalyzerPracticeThisKeyTooltip(Object keyLabel) {
    return 'Open the generator in $keyLabel. (G)';
  }
}
