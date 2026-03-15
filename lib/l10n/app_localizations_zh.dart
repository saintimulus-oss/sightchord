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
  String get systemDefaultLanguage => '跟隨系統';

  @override
  String get themeMode => '主題';

  @override
  String get themeModeSystem => '系統設定';

  @override
  String get themeModeLight => '淺色模式';

  @override
  String get themeModeDark => '深色模式';

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
  String get metronome => '節拍器';

  @override
  String get enabled => '啟用';

  @override
  String get disabled => '關閉';

  @override
  String get metronomeHelp => '練習時打開節拍器即可聽到每個節拍的咔噠聲。';

  @override
  String get metronomeSound => '節拍器音色';

  @override
  String get metronomeSoundClassic => '經典';

  @override
  String get metronomeSoundClickB => '點擊 B';

  @override
  String get metronomeSoundClickC => '點擊 C';

  @override
  String get metronomeSoundClickD => '點擊 D';

  @override
  String get metronomeSoundClickE => '點擊 E';

  @override
  String get metronomeSoundClickF => '點擊 F';

  @override
  String get metronomeVolume => '節拍器音量';

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
  String get keys => '調性';

  @override
  String get noKeysSelected => '尚未選擇任何調性。關閉所有調性後，即可在自由模式下練習所有根音。';

  @override
  String get keysSelectedHelp => '已選的調性會用於調性感知隨機模式與 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '優先考慮功能諧波運動，同時保留啟用的 非調內 選項。';

  @override
  String get advancedSmartGenerator => '進階 Smart Generator';

  @override
  String get modulationIntensity => '轉調強度';

  @override
  String get modulationIntensityOff => '關閉';

  @override
  String get modulationIntensityLow => '低';

  @override
  String get modulationIntensityMedium => '中';

  @override
  String get modulationIntensityHigh => '高';

  @override
  String get jazzPreset => '爵士預設';

  @override
  String get jazzPresetStandardsCore => '標準核心';

  @override
  String get jazzPresetModulationStudy => '調製研究';

  @override
  String get jazzPresetAdvanced => '先進的';

  @override
  String get sourceProfile => '來源簡介';

  @override
  String get sourceProfileFakebookStandard => '假書標準';

  @override
  String get sourceProfileRecordingInspired => '錄音靈感';

  @override
  String get smartDiagnostics => '智慧診斷';

  @override
  String get smartDiagnosticsHelp => '記錄 Smart Generator 決策追蹤以進行偵錯。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '至少選擇一個鍵以使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非調內';

  @override
  String get nonDiatonicRequiresKeyMode => '非 調內 選項僅在按鍵模式下可用。';

  @override
  String get secondaryDominant => '副屬和弦';

  @override
  String get substituteDominant => '替補主力';

  @override
  String get modalInterchange => '調式借用';

  @override
  String get modalInterchangeDisabledHelp => '模態交換僅出現在按鍵模式下，因此該選項在自由模式下停用。';

  @override
  String get rendering => '渲染';

  @override
  String get keyCenterLabelStyle => '按鍵標籤樣式';

  @override
  String get keyCenterLabelStyleHelp => '在明確的模式名稱和經典的大寫/小寫主音標籤之間進行選擇。';

  @override
  String get chordSymbolStyle => '和弦符號樣式';

  @override
  String get chordSymbolStyleHelp => '僅更改顯示層。調和邏輯仍然是規範的。';

  @override
  String get styleCompact => '袖珍的';

  @override
  String get styleMajText => '正文';

  @override
  String get styleDeltaJazz => '三角洲爵士樂';

  @override
  String get keyCenterLabelStyleModeText => 'C 大調： / C 小調：';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C： / C：';

  @override
  String get allowV7sus4 => '允許 V7sus4（V7、V7/x）';

  @override
  String get allowTensions => '允許緊張';

  @override
  String get chordTypeFilters => '和弦種類';

  @override
  String get chordTypeFiltersHelp => '選擇產生器中可出現的和弦種類。';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '已啟用 $selected / $total';
  }

  @override
  String get chordTypeGroupTriads => '三和弦';

  @override
  String get chordTypeGroupSevenths => '七和弦';

  @override
  String get chordTypeGroupSixthsAndAddedTone => '六和弦與附加音';

  @override
  String get chordTypeGroupDominantVariants => '屬功能變體';

  @override
  String get chordTypeRequiresKeyMode => '只有選擇至少一個調性時才能使用 V7sus4。';

  @override
  String get chordTypeKeepOneEnabled => '至少保留一種和弦種類為啟用狀態。';

  @override
  String get tensionHelp => '僅 羅馬數字 設定檔和選定晶片';

  @override
  String get inversions => '倒轉';

  @override
  String get enableInversions => '啟用反轉';

  @override
  String get inversionHelp => '選擇和弦後隨機斜線低音渲染；它不追蹤先前的低音。';

  @override
  String get firstInversion => '第一次反轉';

  @override
  String get secondInversion => '第二次反轉';

  @override
  String get thirdInversion => '第三次反轉';

  @override
  String get keyPracticeOverview => '主要實踐概述';

  @override
  String get freePracticeOverview => '自由練習概述';

  @override
  String get keyModeTag => '按鍵模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有按鍵';

  @override
  String get metronomeOnTag => '節拍器開啟';

  @override
  String get metronomeOffTag => '節拍器關閉';

  @override
  String get pressNextChordToBegin => '按下一個和弦開始';

  @override
  String get freeModeActive => '自由模式激活';

  @override
  String get freePracticeDescription => '使用具有隨機和弦品質的所有 12 個半音根音進行廣泛的閱讀練習。';

  @override
  String get smartPracticeDescription => '遵循所選按鍵中的 和聲功能 流程，同時允許優雅的智慧發電機運動。';

  @override
  String get keyPracticeDescription => '使用選定的按鍵並啟用 羅馬數字 產生 調內 練習材料。';

  @override
  String get keyboardShortcutHelp => '空格：下一個和弦 輸入：開始或停止自動播放 向上/向下：調整 BPM';

  @override
  String get nextChord => '下一個和弦';

  @override
  String get audioPlayChord => '彈奏和弦';

  @override
  String get audioPlayArpeggio => '彈奏琶音';

  @override
  String get audioPlayProgression => '遊戲行程';

  @override
  String get audioPlayPrompt => '播放提示';

  @override
  String get startAutoplay => '開始自動播放';

  @override
  String get stopAutoplay => '停止自動播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '增加每分鐘節拍數';

  @override
  String get bpmLabel => '業務流程管理';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return '允許範圍：$min-$max';
  }

  @override
  String get modeMajor => '主要的';

  @override
  String get modeMinor => '次要的';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => '和聲配置建議';

  @override
  String get voicingSuggestionsSubtitle => '看看該和弦的具體音符選擇。';

  @override
  String get voicingSuggestionsEnabled => '啟用語音建議';

  @override
  String get voicingSuggestionsHelp => '顯示當前和弦的三個可演奏音符級 和聲配置 想法。';

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
  String get voicingComplexity => '發聲複雜性';

  @override
  String get voicingComplexityHelp => '控制建議的豐富多彩程度。';

  @override
  String get voicingComplexityBasic => '基本的';

  @override
  String get voicingComplexityStandard => '標準';

  @override
  String get voicingComplexityModern => '現代的';

  @override
  String get voicingTopNotePreference => '前調偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      '向選定的 頂線 傾斜建議。鎖定的 和聲配置 首先獲勝，然後重複的和弦保持穩定。';

  @override
  String get voicingTopNotePreferenceAuto => '汽車';

  @override
  String get allowRootlessVoicings => '允許無根發聲';

  @override
  String get allowRootlessVoicingsHelp => '當 引導音 保持清晰時，讓建議忽略根。';

  @override
  String get maxVoicingNotes => '最大發聲音符';

  @override
  String get lookAheadDepth => '前瞻深度';

  @override
  String get lookAheadDepthHelp => '排名可能會考慮多少個未來和弦。';

  @override
  String get showVoicingReasons => '顯示表達原因';

  @override
  String get showVoicingReasonsHelp => '在每張建議卡上顯示簡短的解釋晶片。';

  @override
  String get voicingSuggestionNatural => '最自然';

  @override
  String get voicingSuggestionColorful => '最豐富多彩';

  @override
  String get voicingSuggestionEasy => '最簡單';

  @override
  String get voicingSuggestionNaturalSubtitle => '語音領先';

  @override
  String get voicingSuggestionColorfulSubtitle => '傾向於色調';

  @override
  String get voicingSuggestionEasySubtitle => '手型緊湊';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle => '連接和解析優先';

  @override
  String get voicingSuggestionNaturalStableSubtitle => '形狀相同，穩定配合';

  @override
  String get voicingSuggestionTopLineSubtitle => '頂線線索';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle => '改變了前面的張力';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => '現代四色';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Tritone-sub 邊緣帶有明亮的 引導音s';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle => '帶有明亮擴展的引導音';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle => '核心色調，範圍較小';

  @override
  String get voicingSuggestionEasyStableSubtitle => '重複友善的手形';

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
  String get voicingTopNoteLabel => '頂部';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return '頂線目標：$note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '鎖定 頂線：$note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '重複頂線：$note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '最近的 頂線 到 $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '沒有 $note 的確切 頂線';
  }

  @override
  String get voicingFamilyShell => '殼';

  @override
  String get voicingFamilyRootlessA => '無根A';

  @override
  String get voicingFamilyRootlessB => '無根B';

  @override
  String get voicingFamilySpread => '傳播';

  @override
  String get voicingFamilySus => '蘇斯';

  @override
  String get voicingFamilyQuartal => '誇塔爾';

  @override
  String get voicingFamilyAltered => '改變';

  @override
  String get voicingFamilyUpperStructure => '上部結構';

  @override
  String get voicingLockSuggestion => '鎖定建議';

  @override
  String get voicingUnlockSuggestion => '解鎖建議';

  @override
  String get voicingSelected => '已選擇';

  @override
  String get voicingLocked => '鎖定';

  @override
  String get voicingReasonEssentialCore => '涵蓋基本音調';

  @override
  String get voicingReasonGuideToneAnchor => '第三/第七主播';

  @override
  String voicingReasonGuideResolution(int count) {
    return '$count 引導音解析';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '$count 保留常用音調';
  }

  @override
  String get voicingReasonStableRepeat => '穩定重複';

  @override
  String get voicingReasonTopLineTarget => '頂線目標';

  @override
  String get voicingReasonLowMudAvoided => '低音域清晰度';

  @override
  String get voicingReasonCompactReach => '舒適的觸達範圍';

  @override
  String get voicingReasonBassAnchor => '受人尊敬的低音主播';

  @override
  String get voicingReasonNextChordReady => '下一個和弦準備好了';

  @override
  String get voicingReasonAlteredColor => '緊張局勢發生變化';

  @override
  String get voicingReasonRootlessClarity => '輕質無根形狀';

  @override
  String get voicingReasonSusRelease => 'Sus 發布設置';

  @override
  String get voicingReasonQuartalColor => '四分色';

  @override
  String get voicingReasonUpperStructureColor => '上部結構顏色';

  @override
  String get voicingReasonTritoneSubFlavor => 'Tritone-亞風味';

  @override
  String get voicingReasonLockedContinuity => '鎖定連續性';

  @override
  String get voicingReasonGentleMotion => '手部動作流暢';

  @override
  String get mainMenuIntro => '在同一個地方開始和弦練習、進行分析與和聲學習。';

  @override
  String get mainMenuGeneratorTitle => '和弦產生器';

  @override
  String get mainMenuGeneratorDescription => '用智慧走向與和弦配置提示快速建立練習題。';

  @override
  String get openGenerator => '開始練習';

  @override
  String get openAnalyzer => '分析進行';

  @override
  String get mainMenuAnalyzerTitle => '和弦分析器';

  @override
  String get mainMenuAnalyzerDescription => '讀取進行並快速查看調性、羅馬數字與和聲功能。';

  @override
  String get mainMenuStudyHarmonyTitle => '和聲學習';

  @override
  String get mainMenuStudyHarmonyDescription => '延續課程、複習章節，培養實戰和聲感。';

  @override
  String get openStudyHarmony => '開始和聲學習';

  @override
  String get studyHarmonyTitle => '和聲學習';

  @override
  String get studyHarmonySubtitle => '透過結構化和諧中心進行快速課程輸入和章節進展。';

  @override
  String get studyHarmonyPlaceholderTag => '學習甲板';

  @override
  String get studyHarmonyPlaceholderBody =>
      '課程數據、提示和答案介面已經共享一個可重複使用的音符、和弦、音階和進行練習的學習流程。';

  @override
  String get studyHarmonyTestLevelTag => '練習演練';

  @override
  String get studyHarmonyTestLevelAction => '開鑽';

  @override
  String get studyHarmonySubmit => '提交';

  @override
  String get studyHarmonyNextPrompt => '下一個提示';

  @override
  String get studyHarmonySelectedAnswers => '精選答案';

  @override
  String get studyHarmonySelectionEmpty => '尚未選出答案。';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total 正確';
  }

  @override
  String get studyHarmonyAttempts => '嘗試';

  @override
  String get studyHarmonyAccuracy => '準確性';

  @override
  String get studyHarmonyElapsedTime => '時間';

  @override
  String get studyHarmonyObjective => '目標';

  @override
  String get studyHarmonyPromptInstruction => '選擇匹配的答案';

  @override
  String get studyHarmonyNeedSelection => '提交前至少選擇一個答案。';

  @override
  String get studyHarmonyCorrectLabel => '正確的';

  @override
  String get studyHarmonyIncorrectLabel => '不正確';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return '正確的。 $answer 是正確答案。';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return '不正確。 $answer 是正確答案，但你卻失去了一條生命。';
  }

  @override
  String get studyHarmonyGameOverTitle => '遊戲結束';

  @override
  String get studyHarmonyGameOverBody => '三個人的命都沒有了。重試此等級或返回 和聲學習 中心。';

  @override
  String get studyHarmonyLevelCompleteTitle => '已通關等級';

  @override
  String get studyHarmonyLevelCompleteBody => '您已達到課程目標。請在下面檢查您的準確性和清除時間。';

  @override
  String get studyHarmonyBackToHub => '返回和聲學習';

  @override
  String get studyHarmonyRetry => '重試';

  @override
  String get studyHarmonyHubHeroEyebrow => '學習中心';

  @override
  String get studyHarmonyHubHeroBody =>
      '使用「繼續」恢復動力，使用「回顧」重新審視弱點，使用「每日」從解鎖的路徑中獲得確定性的教訓。';

  @override
  String get studyHarmonyTrackFilterLabel => '路線';

  @override
  String get studyHarmonyTrackCoreFilterLabel => '核心';

  @override
  String get studyHarmonyTrackPopFilterLabel => '流行';

  @override
  String get studyHarmonyTrackJazzFilterLabel => '爵士';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => '古典';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total 課程已清除';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total 章節已完成';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars星星';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return '$mastered/$total技能掌握';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count 評論已準備好';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return '連勝x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count 運行';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return '最佳$rank';
  }

  @override
  String get studyHarmonyBossTag => '老闆';

  @override
  String get studyHarmonyContinueCardTitle => '繼續';

  @override
  String get studyHarmonyContinueResumeHint => '繼續您最近接觸的課程。';

  @override
  String get studyHarmonyContinueFrontierHint => '直接跳到你目前前線的下一堂課。';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return '繼續：$lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => '繼續';

  @override
  String get studyHarmonyReviewCardTitle => '複習';

  @override
  String get studyHarmonyReviewQueueHint => '會從目前的複習佇列中抽出。';

  @override
  String get studyHarmonyReviewWeakHint => '會優先挑出你已玩課程中表現最弱的一項。';

  @override
  String get studyHarmonyReviewFallbackHint => '目前還沒有複習欠帳，所以會回到你的前線課程。';

  @override
  String get studyHarmonyReviewRetryNeededHint => '這堂課在失誤或未完成後，值得再補一次。';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint => '這堂課已排入佇列，準備做一次快速準確度刷新。';

  @override
  String get studyHarmonyReviewAction => '複習';

  @override
  String get studyHarmonyDailyCardTitle => '每日挑戰';

  @override
  String get studyHarmonyDailyCardHint => '從您已解鎖的課程中開啟今天的確定性精選內容。';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      '今天的每日挑戰已通關。想再刷一次也可以，或明天回來延續連勝。';

  @override
  String get studyHarmonyDailyAction => '開始每日挑戰';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return '種子 $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => '今天每日清倉';

  @override
  String get studyHarmonyReviewSessionTitle => '弱點回顧';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return '混合圍繞 $chapterTitle 和您最近最薄弱的技能的簡短回顧。';
  }

  @override
  String get studyHarmonyDailySessionTitle => '每日挑戰';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return '播放今天由 $chapterTitle 和您當前前沿構建的種子組合。';
  }

  @override
  String get studyHarmonyModeLesson => '課程模式';

  @override
  String get studyHarmonyModeReview => '複習模式';

  @override
  String get studyHarmonyModeDaily => '日常模式';

  @override
  String get studyHarmonyModeLegacy => '練習模式';

  @override
  String get studyHarmonyShortcutHint =>
      '輸入提交或繼續。 R 重新啟動。 1-9 選出一個答案。 Tab 和 Shift+Tab 移動焦點。';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$total $remaining 剩餘壽命';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => '技能增益';

  @override
  String get studyHarmonyResultReviewFocusTitle => '複習重點';

  @override
  String get studyHarmonyResultRewardTitle => '會話獎勵';

  @override
  String get studyHarmonyBonusGoalsTitle => '獎金目標';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return '排名 $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars星星';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return '最佳$rank·$stars星星';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return '每日連勝 x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => '新個人最佳成績';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded => '審核原因：需要重試';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh => '審核原因：精度刷新';

  @override
  String get studyHarmonyReviewReasonLowMastery => '點評理由：掌握程度低';

  @override
  String get studyHarmonyReviewReasonStaleSkill => '點評理由：技能陳舊';

  @override
  String get studyHarmonyReviewReasonWeakSpot => '點評理由：薄弱環節';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh => '評鑑理由：前沿刷新';

  @override
  String get studyHarmonyQuestBoardTitle => '任務看板';

  @override
  String get studyHarmonyQuestCompletedTag => '完全的';

  @override
  String get studyHarmonyQuestTodayTag => '今天';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target 完整';
  }

  @override
  String get studyHarmonyQuestDailyTitle => '每日連勝';

  @override
  String get studyHarmonyQuestDailyBody => '完成今天的每日種子組合，延續你的連勝。';

  @override
  String get studyHarmonyQuestDailyBodyCompleted => '今天的每日挑戰已通關，這一段連勝暫時安全。';

  @override
  String get studyHarmonyQuestFrontierTitle => '前緣推進';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return '通關 $lessonTitle，把學習路線再往前推一步。';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      '目前已解鎖的課程都已通關。可以重打首領課，或繼續追星。';

  @override
  String get studyHarmonyQuestStarsTitle => '追星';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return '將額外的星星推入 $chapterTitle 內。';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback => '在當前章節中添加額外的星星。';

  @override
  String studyHarmonyComboLabel(int count) {
    return '組合 x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return '最佳組合 x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => '留住所有的心';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return '精準度達到$percent%';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return '達到連擊 x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => '獎金橫掃';

  @override
  String get studyHarmonySkillNoteRead => '筆記閱讀';

  @override
  String get studyHarmonySkillNoteFindKeyboard => '鍵盤音符查找';

  @override
  String get studyHarmonySkillNoteAccidentals => '升號和平號';

  @override
  String get studyHarmonySkillChordSymbolToKeys => '和弦符號到琴鍵';

  @override
  String get studyHarmonySkillChordNameFromTones => '和弦命名';

  @override
  String get studyHarmonySkillScaleBuild => '規模建設';

  @override
  String get studyHarmonySkillRomanRealize => '羅馬數字的實現';

  @override
  String get studyHarmonySkillRomanIdentify => '羅馬數字識別';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => '全音階';

  @override
  String get studyHarmonySkillHarmonyFunction => '函數基礎知識';

  @override
  String get studyHarmonySkillProgressionKeyCenter => '進展 調性中心';

  @override
  String get studyHarmonySkillProgressionFunction => '漸進函數讀取';

  @override
  String get studyHarmonySkillProgressionNonDiatonic => '進展非調內檢測';

  @override
  String get studyHarmonySkillProgressionFillBlank => '進度填寫';

  @override
  String get studyHarmonyHubChapterSectionTitle => '章節';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return '$cleared/$total 課程已清除';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return '$count 課程';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count 已清除';
  }

  @override
  String get studyHarmonyOpenChapterAction => '打開章節';

  @override
  String get studyHarmonyLockedChapterTag => '鎖定章節';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return '下一個：$lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return '這條軌道仍然被鎖定。今天切換回$coreTrack繼續學習。';
  }

  @override
  String get studyHarmonyCoreTrackTitle => '核心路線';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '從音符和鍵盤開始，然後透過和弦、音階、羅馬數字、調內 基礎知識和短進行分析進行累積。';

  @override
  String get studyHarmonyChapterNotesTitle => '第一章：音符與鍵盤';

  @override
  String get studyHarmonyChapterNotesDescription => '將音符名稱映射到鍵盤並熟悉白鍵和簡單的記號。';

  @override
  String get studyHarmonyChapterChordsTitle => '第 2 章：和弦基礎知識';

  @override
  String get studyHarmonyChapterChordsDescription =>
      '拼寫基本的三和弦和七和弦，然後根據它們的音調說出常見的和弦形狀。';

  @override
  String get studyHarmonyChapterScalesTitle => '第 3 章：音階與調';

  @override
  String get studyHarmonyChapterScalesDescription => '建立大調和小調音階，然後找出哪些音屬於某個調。';

  @override
  String get studyHarmonyChapterRomanTitle => '第 4 章：羅馬數字與全音階';

  @override
  String get studyHarmonyChapterRomanDescription =>
      '將簡單的 羅馬數字 轉換為和弦，從和弦中識別它們，並按功能對 調內 基礎進行排序。';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle => '第5章 進階偵探Ⅰ';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '閱讀簡短的核心進行，找到可能的 調性中心，並找出和弦函數或奇數。';

  @override
  String get studyHarmonyChapterMissingChordTitle => '第 6 章：缺失和弦 I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      '在一個簡短的進程中填補一個空白，並了解下一步節奏和功能的發展方向。';

  @override
  String get studyHarmonyOpenLessonAction => '開啟課程';

  @override
  String get studyHarmonyLockedLessonAction => '未解鎖';

  @override
  String get studyHarmonyClearedTag => '已通關';

  @override
  String get studyHarmonyComingSoonTag => '即將推出';

  @override
  String get studyHarmonyPopTrackTitle => '流行路線';

  @override
  String get studyHarmonyPopTrackDescription => '核心曲目穩定後，將規劃以歌曲為中心的路徑。';

  @override
  String get studyHarmonyJazzTrackTitle => '爵士路線';

  @override
  String get studyHarmonyJazzTrackDescription => '在核心課程確定之前，爵士樂和聲內容將保持鎖定。';

  @override
  String get studyHarmonyClassicalTrackTitle => '古典路線';

  @override
  String get studyHarmonyClassicalTrackDescription => '古典語境中的功能和諧將在稍後階段實現。';

  @override
  String get studyHarmonyObjectiveQuickDrill => '快速練習';

  @override
  String get studyHarmonyObjectiveBossReview => '首領複習';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => '白鍵音符狩獵';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription => '閱讀音符名稱並點擊匹配的白鍵。';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => '命名突出顯示的註釋';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      '查看突出顯示的按鍵並選擇正確的音符名稱。';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => '黑鍵和雙胞胎';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      '首先了解黑鍵的升記號和降記號拼字。';

  @override
  String get studyHarmonyLessonNotesBossTitle => 'Boss：快速音符狩獵';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      '將筆記閱讀和鍵盤查找混合到一個簡短的快速回合。';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => '鍵盤上的三和弦';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      '直接在鍵盤上建立常見的大調、小調和減三和弦。';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => '鍵盤上的七度';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      '加入七和弦並在鍵盤上拼寫一些常見的七和弦。';

  @override
  String get studyHarmonyLessonChordNameTitle => '命名突出顯示的和弦';

  @override
  String get studyHarmonyLessonChordNameDescription => '閱讀突出顯示的和弦形狀並選擇正確的和弦名稱。';

  @override
  String get studyHarmonyLessonChordsBossTitle => '頭目：三合會和七合會評論';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      '在一篇混合評論中在和弦拼字和和弦命名之間切換。';

  @override
  String get studyHarmonyLessonMajorScaleTitle => '建構大調音階';

  @override
  String get studyHarmonyLessonMajorScaleDescription => '選擇屬於簡單大調音階的每個音調。';

  @override
  String get studyHarmonyLessonMinorScaleTitle => '建構小調音階';

  @override
  String get studyHarmonyLessonMinorScaleDescription => '從幾個常用調來建構自然小調和和聲小調音階。';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => '主要會員';

  @override
  String get studyHarmonyLessonKeyMembershipDescription => '尋找哪些音調屬於指定鍵。';

  @override
  String get studyHarmonyLessonScalesBossTitle => 'Boss：鱗片修復';

  @override
  String get studyHarmonyLessonScalesBossDescription => '在短期修復過程中混合規模建設和關鍵成員。';

  @override
  String get studyHarmonyLessonRomanToChordTitle => '羅馬音轉和弦';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      '讀取調和 羅馬數字，然後選擇相符的和弦。';

  @override
  String get studyHarmonyLessonChordToRomanTitle => '和弦轉羅馬音';

  @override
  String get studyHarmonyLessonChordToRomanDescription => '讀取調內的和弦並選擇匹配的 羅馬數字。';

  @override
  String get studyHarmonyLessonDiatonicityTitle => '是否全音階';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      '用簡單的調將和弦分類為 調內 和 非調內 答案。';

  @override
  String get studyHarmonyLessonFunctionTitle => '函數基礎知識';

  @override
  String get studyHarmonyLessonFunctionDescription => '將簡單和弦分類為主和弦、下屬功能 或屬和弦。';

  @override
  String get studyHarmonyLessonRomanBossTitle => 'Boss：功能基礎組合';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      '一起回顧羅馬音到和弦、和弦到羅馬音、調內ity 和功能。';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle => '找到鑰匙中心';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      '閱讀一個簡短的進展並選擇最清晰的 調性中心。';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle => '上下文中的函數';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      '專注於一個突出顯示的和弦，並在一個簡短的進行中命名它的角色。';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle => '尋找局外人';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      '求 調內 主要讀數以外的一個和弦。';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Boss：混合分析';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      '在一輪簡短的偵探中混合關鍵中心讀取、功能定位和 非調內 檢測。';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle => '填補缺失的和弦';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      '透過選擇最適合局部功能的和弦來完成短的四和弦進行。';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle => '節奏填充';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      '使用節奏拉力來選擇樂句末尾附近缺少的和弦。';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Boss：混合填充';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      '用更多的和聲壓力解決一組簡短的填充級數問題。';

  @override
  String get studyHarmonyChapterCheckpointTitle => '檢查站挑戰';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      '將關鍵中心、功能、顏色和填充練習結合到更快的混合複習集中。';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => '節奏衝刺';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      '快速讀出和聲的作用，然後在輕壓下插入缺少的終止和弦。';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => '顏色和基調';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      '在中心偵測和 非調內 顏色呼叫之間切換，不會遺失執行緒。';

  @override
  String get studyHarmonyLessonCheckpointBossTitle => 'Boss：檢查站挑戰';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      '清除一個混合了鍵中心、功能、顏色和節奏修復提示的綜合檢查點。';

  @override
  String get studyHarmonyChapterCapstoneTitle => '頂點試驗';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      '透過更艱難的混合進展回合完成核心路徑，這些回合要求速度、色彩聽覺和清晰的解析度選擇。';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => '週轉接力';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      '在緊湊的周轉中在功能讀取和缺失和弦修復之間進行交換。';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle => '借用顏色調用';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      '快速捕捉模態顏色，然後在 調性中心 消失之前對其進行確認。';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => '解析度實驗室';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      '追蹤每個樂句想要落地的位置，並選擇最能解決動作的和弦。';

  @override
  String get studyHarmonyLessonCapstoneBossTitle => 'Boss：最終升級考試';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      '通過一項最終混合考試，中心、功能、顏色和分辨率都在壓力下。';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return '在鍵盤上找到$note';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote => '哪個註釋突出顯示？';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return '在鍵盤上建構$chord';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord => '哪個和弦突出顯示？';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return '選擇$scaleName中的每個音符';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return '選擇屬於$keyName的筆記';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return '在$keyName中，哪一個和弦與$roman相符？';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return '在 $keyName 中，什麼 羅馬數字 與 $chord 相符？';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return '在$keyName中，$chord是調內嗎？';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return '$keyName中，$chord有什麼功能？';
  }

  @override
  String get studyHarmonyProgressionStripLabel => '進展';

  @override
  String get studyHarmonyPromptProgressionKeyCenter => '哪一個 調性中心 最適合這個進程？';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '$chord在這裡扮演什麼角色呢？';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic => '在這個進行中，哪個和弦感覺最不調內？';

  @override
  String get studyHarmonyPromptProgressionMissingChord => '哪個和弦最能填補空白？';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return '分析儀在 $keyLabel 中最清楚地讀取此進程。';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '在這種情況下，$chord 的行為最像 $functionLabel 和弦。';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord 在主要的 $keyLabel 讀數中脫穎而出，因此它是最好的 非調內 選擇。';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord 恢復了此進程中預期的 $functionLabel 拉力。';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index。 $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic專業';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic 自然小調';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic 和聲小調';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic專業';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic 小調';
  }

  @override
  String get studyHarmonyChoiceDiatonic => '全音階';

  @override
  String get studyHarmonyChoiceNonDiatonic => '非調內';

  @override
  String get studyHarmonyChoiceTonic => '補品';

  @override
  String get studyHarmonyChoicePredominant => '占主導地位';

  @override
  String get studyHarmonyChoiceDominant => '主導的';

  @override
  String get studyHarmonyChoiceOther => '其他';

  @override
  String get chordAnalyzerTitle => '和弦分析器';

  @override
  String get chordAnalyzerSubtitle => '貼上和弦進行，即可得到偏保守的和聲判讀。';

  @override
  String get chordAnalyzerInputLabel => '和弦進行';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      '括號外可用空格、| 或逗號分隔和弦。括號內的逗號會保留在同一個和弦之中。\n\n使用 ? 代表尚未確定的和弦空位。分析器會依前後和聲脈絡推定最自然的補法，若判讀有歧義也會提出候選。變化生成功能也能更自由地重新和聲化這個位置。\n\n支援小寫根音、斜線低音、sus/alt/add 形式，以及 C7(b9, #11) 這類張力寫法。\n\n在觸控裝置上可使用和弦面板，或在需要自由輸入時切換到 ABC 輸入。';

  @override
  String get chordAnalyzerInputHelpTitle => '輸入提示';

  @override
  String get chordAnalyzerAnalyze => '分析';

  @override
  String get chordAnalyzerKeyboardTitle => '和弦面板';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '點按符號來組出進行。若需要自由輸入，可切換到 ABC 輸入並保留系統鍵盤。';

  @override
  String get chordAnalyzerKeyboardDesktopHint => '可直接輸入、貼上，或點按符號插入到游標位置。';

  @override
  String get chordAnalyzerChordPad => '面板';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '貼上';

  @override
  String get chordAnalyzerClear => '重設';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => '空格鍵';

  @override
  String get chordAnalyzerAnalyzing => '正在分析進行...';

  @override
  String get chordAnalyzerInitialTitle => '先輸入一段進行';

  @override
  String get chordAnalyzerInitialBody =>
      '輸入像 Dm7, G7 | ? Am 或 Cmaj7 | Am7 D7 | Gmaj7 這樣的進行，即可查看可能的調性、羅馬數字、推定補全與簡短摘要。';

  @override
  String get chordAnalyzerPlaceholderExplanation => '這個 ? 是根據前後和聲脈絡推定出的空位。';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return '建議補入：$chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => '偵測到的調性';

  @override
  String get chordAnalyzerPrimaryReading => '主要判讀';

  @override
  String get chordAnalyzerAlternativeReading => '替代判讀';

  @override
  String get chordAnalyzerChordAnalysis => '逐和弦分析';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '第 $index 小節';
  }

  @override
  String get chordAnalyzerProgressionSummary => '進行摘要';

  @override
  String get chordAnalyzerWarnings => '警告與歧義';

  @override
  String get chordAnalyzerNoInputError => '請輸入要分析的和弦進行。';

  @override
  String get chordAnalyzerNoRecognizedChordsError => '這段進行中沒有找到可辨識的和弦。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '部分符號已略過：$tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '調性中心在 $primary 與 $alternative 之間仍然略帶歧義。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning => '部分和弦仍帶有歧義，因此這份判讀刻意保持保守。';

  @override
  String get chordAnalyzerFunctionTonic => '主功能';

  @override
  String get chordAnalyzerFunctionPredominant => '下屬功能';

  @override
  String get chordAnalyzerFunctionDominant => '屬功能';

  @override
  String get chordAnalyzerFunctionOther => '其他';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return '可能是指向 $target 的副屬和弦。';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '可能是指向 $target 的三全音替代。';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange => '可能是來自平行小調的調式借用。';

  @override
  String get chordAnalyzerRemarkAmbiguous => '這個和弦在目前的判讀中仍帶有歧義。';

  @override
  String get chordAnalyzerRemarkUnresolved => '依照目前偏保守的啟發式判斷，這個和弦仍未能明確定義。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 終止';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => '屬功能解決';

  @override
  String get chordAnalyzerTagPlagalColor => '變格 / 調式色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return '這段進行最有可能以 $key 為中心。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '另一種可能的判讀是 $key。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '它也呈現出 $tag 的特徵。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from 與 $through 在這裡可聽成通往 $target 的 $fromFunction 與 $throughFunction 和弦。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord 也可以聽成是指向 $target 的副屬和弦。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord 也可以聽成是指向 $target 的三全音替代。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord 增添了可能的調式借用色彩。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous => '部分細節仍帶有歧義，因此這份判讀刻意維持保守。';

  @override
  String get chordAnalyzerExamplesTitle => '範例';

  @override
  String get chordAnalyzerConfidenceLabel => '信心度';

  @override
  String get chordAnalyzerAmbiguityLabel => '歧義程度';

  @override
  String get chordAnalyzerWhyThisReading => '為何這樣判讀';

  @override
  String get chordAnalyzerCompetingReadings => '也有可能';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '已忽略的修飾：$details';
  }

  @override
  String get chordAnalyzerGenerateVariations => '建立變化版';

  @override
  String get chordAnalyzerVariationsTitle => '自然的變化版';

  @override
  String get chordAnalyzerVariationsBody =>
      '這些提案會保留原本的走向，並用相近功能的替代和弦重新著色。套用後會立刻重新分析。';

  @override
  String get chordAnalyzerApplyVariation => '套用這個變化版';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => '終止色彩';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      '保留原本的落點，同時讓下屬前功能更暗一些，並換成三全音替代屬和弦。';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Backdoor 色彩';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      '借用平行小調的 ivm7-bVII7 色彩，最後落回同一個主和弦。';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => '定向 ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      '重新組成一個仍然指向相同目標和弦的相關 ii-V。';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => '小調終止色彩';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      '保留小調終止感，但把色彩推向 iiø-Valt-i。';

  @override
  String get chordAnalyzerVariationColorLiftTitle => '色彩抬升';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      '維持接近的根音與功能，同時用自然的延伸音讓和弦更有表情。';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '輸入警告：$details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括號不平衡，導致符號的一部分無法完全確定。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '已忽略意外出現的右括號。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '明確的 $extension 色彩加強了這個判讀。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      '變化屬和弦的色彩支持它作為屬功能的判讀。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '斜線低音 $bass 讓低音線或轉位仍具有明確意義。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '下一個和弦支持它朝向 $target 解決。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => '這種色彩可聽成從平行調借來的效果。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor => '掛留色彩削弱了屬功能的拉力，但沒有把它抹去。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '低信心判讀';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '候選調性彼此太接近，或部分符號只能局部還原，因此請把它當作審慎的第一版判讀。';

  @override
  String get chordAnalyzerEmptyMeasure => '這一小節為空，但仍保留在計數之中。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure => '這一小節沒有還原出可分析的和弦記號。';

  @override
  String get chordAnalyzerParseIssuesTitle => '解析問題';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空白符號。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => '無法辨識根音。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root 不是支援的根音拼寫。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return '斜線低音 $bass 不是支援的低音拼寫。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '不支援的後綴或修飾：$suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

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
  String get studyHarmonyDailyReplayAction => '每日重播';

  @override
  String get studyHarmonyMilestoneCabinetTitle => '里程碑獎牌';

  @override
  String get studyHarmonyMilestoneLessonsTitle => '探路者獎章';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return '清除核心基礎中的 $target 課程。';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => '明星收藏家';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return '在 和聲學習 上收集 $target 星星。';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => '連勝傳奇';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return '達到 $target 的最佳每日連續記錄。';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => '精通學者';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return '掌握$target技能。';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return '獲得 $earned/$total 獎牌';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => '櫃子齊全';

  @override
  String get studyHarmonyMilestoneTierBronze => '銅牌';

  @override
  String get studyHarmonyMilestoneTierSilver => '銀牌';

  @override
  String get studyHarmonyMilestoneTierGold => '金牌';

  @override
  String get studyHarmonyMilestoneTierPlatinum => '白金獎章';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => '新獎牌';

  @override
  String get studyHarmonyChapterRemixTitle => '混音競技場';

  @override
  String get studyHarmonyChapterRemixDescription =>
      '更長的混合套裝，在沒有警告的情況下打亂 調性中心、功能和借用顏色。';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => '橋樑建造者';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      '縫合功能讀取並將缺少的和弦填充到一條流動的鏈中。';

  @override
  String get studyHarmonyLessonRemixPivotTitle => '色彩軸';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      '當進展在您腳下移動時，請追蹤借用的顏色和關鍵中心樞軸。';

  @override
  String get studyHarmonyLessonRemixSprintTitle => '決議衝刺';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      '以更快的速度連續朗讀功能、節奏填充和音調重力。';

  @override
  String get studyHarmonyLessonRemixBossTitle => '混音馬拉松';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      '最後的混合馬拉松將所有漸進閱讀鏡片重新投入設定。';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return '連勝保護卡 x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return '傳奇皇冠$count';
  }

  @override
  String get studyHarmonyModeFocus => '對焦模式';

  @override
  String get studyHarmonyModeLegend => '傳奇試煉';

  @override
  String get studyHarmonyFocusCardTitle => '焦點衝刺';

  @override
  String get studyHarmonyFocusCardHint => '用更少的生命與更緊的條件，集中攻克目前路線上最薄弱的環節。';

  @override
  String get studyHarmonyFocusFallbackHint => '先來一輪更硬的混合練習，測試目前的弱點。';

  @override
  String get studyHarmonyFocusAction => '開始衝刺';

  @override
  String get studyHarmonyFocusSessionTitle => '焦點衝刺';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return '從 $chapter 周邊最薄弱的環節抽出內容，做一輪更緊湊的混合衝刺。';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count 課程混合';
  }

  @override
  String get studyHarmonyFocusRewardLabel => '每週獎勵：連勝保護卡';

  @override
  String get studyHarmonyLegendCardTitle => '傳奇試煉';

  @override
  String get studyHarmonyLegendCardHint => '把銀階以上的章節用 2 條命的精熟挑戰再通一次，拿下傳奇王冠。';

  @override
  String get studyHarmonyLegendFallbackHint =>
      '先完成一個章節，並把平均表現推到每課約 2 顆星，即可解鎖傳奇試煉。';

  @override
  String get studyHarmonyLegendAction => '追逐傳奇';

  @override
  String get studyHarmonyLegendSessionTitle => '傳奇試煉';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return '針對 $chapter 進行一輪毫不鬆手的精熟重播，只為拿下傳奇王冠。';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count 課程連鎖';
  }

  @override
  String get studyHarmonyLegendRiskLabel => '傳奇王冠在此一搏';

  @override
  String get studyHarmonyWeeklyPlanTitle => '每週訓練計劃';

  @override
  String get studyHarmonyWeeklyRewardLabel => '獎勵：連勝保護卡';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => '獎勵已準備好';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => '已領取獎勵';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => '多日出現';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return '本週不同日子在 $target 上保持活躍。';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle => '保持每日循環的活力';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return '日誌 $target 本週每日清零。';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle => '完成焦點衝刺';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return '本週完成 $target 焦點衝刺。';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine => '昨天已使用連勝保護卡保住紀錄。';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return '獲得新的連勝保護卡。庫存：$count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => '焦點衝刺已清除。';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return '為 $chapter 固定傳奇錶冠。';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => '安可階梯';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      '一個簡短的完成階梯，將整個進度工具包壓縮為最終的加演集。';

  @override
  String get studyHarmonyLessonEncorePulseTitle => '音調脈衝';

  @override
  String get studyHarmonyLessonEncorePulseDescription => '鎖定音調中心和功能，無需任何預熱提示。';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => '顏色交換';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      '交替借用的顏色可以透過缺失和弦修復來調用，以保持耳朵的誠實。';

  @override
  String get studyHarmonyLessonEncoreBossTitle => '安可結局';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      '最後一輪緊湊的老闆回合會快速連續檢查每個進展鏡頭。';

  @override
  String get studyHarmonyChapterMasteryBronze => '青銅色透明';

  @override
  String get studyHarmonyChapterMasterySilver => '銀冠';

  @override
  String get studyHarmonyChapterMasteryGold => '金皇冠';

  @override
  String get studyHarmonyChapterMasteryLegendary => '傳奇皇冠';

  @override
  String get studyHarmonyModeBossRush => 'Boss 衝刺模式';

  @override
  String get studyHarmonyBossRushCardTitle => '首領衝刺';

  @override
  String get studyHarmonyBossRushCardHint => '以更少生命和更高分數門檻，連打已解鎖的首領課程。';

  @override
  String get studyHarmonyBossRushFallbackHint => '至少解鎖兩堂首領課，才能開啟真正的首領衝刺混合挑戰。';

  @override
  String get studyHarmonyBossRushAction => '開始首領衝刺';

  @override
  String get studyHarmonyBossRushSessionTitle => '首領衝刺';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return '把 $chapter 周邊已解鎖的首領課程串成一輪高壓首領挑戰。';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count 老大教訓混雜';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => '僅限 2 條命';

  @override
  String get studyHarmonyResultBossRushLine => 'Boss Rush 已清除。';

  @override
  String get studyHarmonyChapterSpotlightTitle => '聚光燈對決';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      '最後的聚光燈設定隔離了借用的顏色、節奏壓力和老闆級整合。';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => '借鏡頭';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      '追蹤 調性中心，而藉用的顏色則不斷試圖將您的閱讀拉向一邊。';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => '節奏交換';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      '在功能讀取和節奏恢復之間切換，而不會失去著陸點。';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => '聚光燈對決';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      '一個封閉的老闆套裝，迫使每個進展鏡頭在壓力下保持銳利。';

  @override
  String get studyHarmonyChapterAfterHoursTitle => '下班後實驗室';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      '遊戲後期實驗室剝離了熱身線索並混合了借用的顏色、節奏壓力和中心追蹤。';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => '模態陰影';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      '當借用的顏色不斷將讀數拖入黑暗時，請保留 調性中心。';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => '決議佯攻';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      '在短語滑過其真正的著陸點之前捕捉功能和節奏假動作。';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => '中心交叉淡入淡出';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      '混合中心偵測、功能讀取和缺失和弦修復，無需任何額外的鷹架。';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => '最後的電話老闆';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      '最後的深夜老闆設定要求每個進展鏡頭在壓力下保持清晰。';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return '接力獲勝 $count';
  }

  @override
  String get studyHarmonyModeRelay => '競技接力';

  @override
  String get studyHarmonyRelayCardTitle => '競技接力';

  @override
  String get studyHarmonyRelayCardHint => '把不同章節已解鎖的課程交錯成同一輪混合挑戰，測試快速切換與即時回想。';

  @override
  String get studyHarmonyRelayFallbackHint => '解鎖至少兩章才能開啟競技接力。';

  @override
  String get studyHarmonyRelayAction => '開始接力';

  @override
  String get studyHarmonyRelaySessionTitle => '競技接力';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return '交錯的繼電器運行混合 $chapter 周圍的解鎖章節。';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return '$count 課程轉播';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count章節混裝';
  }

  @override
  String get studyHarmonyRelayChainLabel => '壓力交錯';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return '接力獲勝 $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => '接力跑者';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return '清除 $target 競技接力 運行。';
  }

  @override
  String get studyHarmonyChapterNeonTitle => '霓虹燈繞道';

  @override
  String get studyHarmonyChapterNeonDescription =>
      '遊戲後期的章節不斷透過借用的顏色、樞軸壓力和恢復來彎曲道路。';

  @override
  String get studyHarmonyLessonNeonDetourTitle => '模態繞行';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      '即使借用的顏色不斷將短語推到小巷中，也要追蹤真正的中心。';

  @override
  String get studyHarmonyLessonNeonPivotTitle => '樞軸壓力';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      '在諧波車道再次改變之前，連續讀取中心移位和功能壓力。';

  @override
  String get studyHarmonyLessonNeonLandingTitle => '借用的著陸點';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      '在藉色假出改變預期解析度後修復缺少的著陸和弦。';

  @override
  String get studyHarmonyLessonNeonBossTitle => '城市之光老闆';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      '一個關閉的霓虹燈老闆，混合了樞軸閱讀、借用的顏色和節奏恢復，沒有軟著陸。';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tier聯賽';
  }

  @override
  String get studyHarmonyLeagueCardTitle => '和聲聯賽';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return '這週朝 $tier 聯賽再衝一點。現在最有效率的加成來源是 $mode。';
  }

  @override
  String get studyHarmonyLeagueCardHintMax => '本週鑽石已經穩住了。繼續串起高壓通關，守住目前節奏。';

  @override
  String get studyHarmonyLeagueFallbackHint => '一旦本周有推薦的跑步活動，你的聯賽攀登就會亮起來。';

  @override
  String get studyHarmonyLeagueAction => '衝刺聯賽';

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score 本週 XP';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target 本週 XP';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return '下一頁： $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return '最佳提升：$mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return '聯賽經驗+$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return '晉級$tier聯賽';
  }

  @override
  String get studyHarmonyLeagueTierRookie => '新秀';

  @override
  String get studyHarmonyLeagueTierBronze => '青銅';

  @override
  String get studyHarmonyLeagueTierSilver => '銀';

  @override
  String get studyHarmonyLeagueTierGold => '金子';

  @override
  String get studyHarmonyLeagueTierDiamond => '鑽石';

  @override
  String get studyHarmonyChapterMidnightTitle => '午夜轉接台';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      '最後的控制室章節迫使人們快速閱讀漂移的中心、錯誤的節奏和借用的重新路線。';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => '訊號漂移';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      '即使表面不斷漂移到借用的顏色，也能追蹤真實的色調訊號。';

  @override
  String get studyHarmonyLessonMidnightLineTitle => '假性走向';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      '在線路折疊回原位之前，透過假解析度讀取功能壓力。';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => '借用改道';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      '在藉用的顏色重新路由短語中流後恢復預期著陸。';

  @override
  String get studyHarmonyLessonMidnightBossTitle => '斷電首領';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      '一個關閉的停電設置，混合了每個遊戲後期鏡頭，而不給你一個安全的重置。';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return '任務箱 $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x 聯賽 XP x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => '任務寶箱';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count 剩餘任務';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => '任務寶箱 就緒';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => '任務寶箱 已開通';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x 聯賽 XP 直播';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return '獎勵：+$xp 聯賽經驗';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      '完成今天的三個任務，就能開啟額外寶箱，繼續推進本週的上升節奏。';

  @override
  String get studyHarmonyQuestChestReadyBody => '今天三個任務都完成了。再通關一輪，就能領走今天的寶箱獎勵。';

  @override
  String get studyHarmonyQuestChestOpenedBody => '今天的三人組已經完成，寶箱獎勵已經轉換為聯賽經驗值。';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return '今天的寶箱已開啟，接下來 $count 次通關都會套用 2x 聯賽 XP。';
  }

  @override
  String get studyHarmonyQuestChestAction => '完成三人組';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return '最佳收尾：$mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return '每日任務 $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => '任務寶箱 已開啟。';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return '任務寶箱 獎金 +$count 聯賽 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '接下來 $count 次通關可享 2x 聯賽 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return '加成獎勵 +$count 聯賽 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return '2x 升壓清除左側 $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return '接下來 $count 次通關可享 2x 聯賽 XP。趁加成還在，把它用在 $mode。';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => '天際迴路';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      '最後的天際線環線迫使人們快速混合閱讀幽靈中心、借來的重力和虛假的家園。';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => '殘像脈衝';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      '在短語鎖定到新車道之前，抓住殘像的中心並發揮作用。';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => '重力換位';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      '處理借來的重力和缺少的和弦修復，同時進程不斷交換其重量。';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => '假性歸宿';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      '在進程突然關閉之前，仔細閱讀錯誤到達並重建真實著陸。';

  @override
  String get studyHarmonyLessonSkylineBossTitle => '最終訊號首領';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      '最後的天際線首領將每個遊戲後期進展鏡頭都連結到一個結束訊號測試。';

  @override
  String get studyHarmonyChapterAfterglowTitle => '餘暉跑道';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      '一條由分歧決策、借來的誘餌和閃爍的中心組成的最後跑道，獎勵在壓力下乾淨的比賽後期閱讀。';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => '分途判斷';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      '選擇修復和弦，使功能保持移動​​，而不會讓樂句偏離軌道。';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => '借用誘引';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      '在進程快速返回之前，找出看起來像支點的借用顏色和弦。';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => '中心閃動';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      '按住音調中心，同時節奏提示閃爍並快速連續地重新路由。';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => '紅線回歸老闆';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      '全速進行 調性中心、功能、借用顏色和缺失和弦修復的最終混合測試。';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return '旅遊郵票 $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => '月遊清零';

  @override
  String get studyHarmonyTourTitle => '和聲巡迴';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return '$count/$target 巡迴郵票';
  }

  @override
  String get studyHarmonyTourReadyHeadline => '巡演大結局已準備就緒';

  @override
  String get studyHarmonyTourClaimedHeadline => '月遊清零';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return '獎勵：聯賽 XP +$xp，以及 $count 個連勝保護卡';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return '這個月在 $target 個不同日子上線，就能鎖定巡迴獎勵。';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return '本月打開 $target 個任務寶箱，讓巡迴印章本繼續往前推。';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return '本月完成 $target 次焦點挑戰。首領衝刺、競技接力、焦點衝刺、傳奇試煉與首領課程都會計入。';
  }

  @override
  String get studyHarmonyTourReadyBody => '本月的印章都收齊了。再通關一次，就能鎖定巡迴獎勵。';

  @override
  String get studyHarmonyTourClaimedBody => '這個月的旅行結束了。保持節奏清晰，讓下個月的路線開始火爆。';

  @override
  String get studyHarmonyTourAction => '提前遊覽';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return '活躍天數 $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return '任務寶箱s $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return '射燈 $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => '和聲巡迴 完成';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return '巡迴賽獎金 +$count 聯賽 XP';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return '連勝保護卡庫存 $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => '破曉頻率';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      '幽靈般的節奏、虛假的黎明轉折和借來的花朵的日出安可，迫使長跑後乾淨的遊戲後期閱讀。';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => '幻影終止';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      '同時修復樂句假裝結束但實際上落地時的節奏和功能。';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => '假曙光';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      '在進展再次拉開之前，抓住隱藏在過早日出中的中心轉變。';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => '借用綻放';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      '將借用的顏色和功能結合在一起，同時和諧地打開一條更明亮但不穩定的車道。';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => '日出超速 Boss';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      '最終的黎明速度 Boss 將 調性中心、功能、非調內 顏色和缺失和弦修復連結到最後一個過載組。';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return '二重唱連勝 $count';
  }

  @override
  String get studyHarmonyDuetTitle => '雙人契約';

  @override
  String get studyHarmonyDuetStartHeadline => '開始今天的二重唱';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return '二重唱連勝 $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return '二重唱鎖定當日 $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return '獎勵：在關鍵連勝節點獲得聯賽 XP +$xp';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody => '先完成今天的每日挑戰，再通關一次焦點挑戰，讓雙人契約延續下去。';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      '每日賽開始了。完成焦點賽、接力賽、Boss Rush、傳奇賽等一場聚光燈賽，或參加一場 Boss 課程來鎖定二重唱。';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return '今天的雙人契約已成立，共享連勝已來到 $count 天。';
  }

  @override
  String get studyHarmonyDuetDailyDone => '每日在';

  @override
  String get studyHarmonyDuetDailyMissing => '每日失蹤';

  @override
  String get studyHarmonyDuetSpotlightDone => '聚光燈下';

  @override
  String get studyHarmonyDuetSpotlightMissing => '聚光燈缺失';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return '每日$done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return '聚光燈$done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return '連勝$count/$target';
  }

  @override
  String get studyHarmonyDuetAction => '繼續二重唱';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return '二重唱連勝 $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return '二重唱獎勵+$count聯賽XP';
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
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle => '和聲學習原型';

  @override
  String get studyHarmonyPrototypeCourseDescription => '沿用到課程系統中的早期原型關卡。';

  @override
  String get studyHarmonyPrototypeChapterTitle => '原型課程';

  @override
  String get studyHarmonyPrototypeChapterDescription => '在擴充式學習系統上線前，暫時保留的課程。';

  @override
  String get studyHarmonyPrototypeLevelObjective => '在失去 3 條生命前答對 10 題即可通關';

  @override
  String get studyHarmonyPrototypeLevel1Title => '原型關卡 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description => '只辨認 Do、Mi、Sol 的基礎暖身關卡。';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      '原型關卡 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      '加快辨認 Do、Re、Mi、Sol、La 的中階關卡。';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      '原型關卡 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      '完整走過 Do-Re-Mi-Fa-Sol-La-Si-Do 音列的八度關卡。';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName（低音 C）';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName（高音 C）';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => '樣板';

  @override
  String get studyHarmonyChapterBlueHourTitle => '藍調時刻交匯';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      '交叉潮流、光環借用和雙重視野的暮光重演，以最好的方式讓遊戲後期的閱讀變得不穩定。';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => '交錯流向';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      '追蹤 調性中心 並運行，同時進程開始向兩個方向拉動。';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => '光暈借用';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      '在短語變得模糊之前，閱讀借來的顏色並恢復缺少的和弦。';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => '雙重地平線';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      '保持真正的到達點，同時兩個可能的地平線不斷進出。';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => '雙燈籠老闆';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      '最後的藍色時刻 Boss 強制快速交換中心、功能、借用的顏色和缺少的和弦修復。';

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
      'Paste a local audio file path and press enter to apply it. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter to apply it. Built-in sound remains the fallback.';

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
  String get systemDefaultLanguage => '跟随系统';

  @override
  String get themeMode => '主题';

  @override
  String get themeModeSystem => '系统设置';

  @override
  String get themeModeLight => '浅色模式';

  @override
  String get themeModeDark => '深色模式';

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
  String get metronome => '节拍器';

  @override
  String get enabled => '启用';

  @override
  String get disabled => '关闭';

  @override
  String get metronomeHelp => '练习时打开节拍器即可听到每个节拍的咔哒声。';

  @override
  String get metronomeSound => '节拍器音色';

  @override
  String get metronomeSoundClassic => '经典';

  @override
  String get metronomeSoundClickB => '点击 B';

  @override
  String get metronomeSoundClickC => '点击 C';

  @override
  String get metronomeSoundClickD => '点击 D';

  @override
  String get metronomeSoundClickE => '点击 E';

  @override
  String get metronomeSoundClickF => '点击 F';

  @override
  String get metronomeVolume => '节拍器音量';

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
  String get keys => '调性';

  @override
  String get noKeysSelected => '尚未选择任何调性。关闭所有调性后，即可在自由模式下练习所有根音。';

  @override
  String get keysSelectedHelp => '已选的调性会用于调性感知随机模式和 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '优先考虑功能谐波运动，同时保留启用的 非调内 选项。';

  @override
  String get advancedSmartGenerator => '高级 Smart Generator';

  @override
  String get modulationIntensity => '转调强度';

  @override
  String get modulationIntensityOff => '关闭';

  @override
  String get modulationIntensityLow => '低';

  @override
  String get modulationIntensityMedium => '中';

  @override
  String get modulationIntensityHigh => '高';

  @override
  String get jazzPreset => '爵士预设';

  @override
  String get jazzPresetStandardsCore => '标准核心';

  @override
  String get jazzPresetModulationStudy => '调制研究';

  @override
  String get jazzPresetAdvanced => '先进的';

  @override
  String get sourceProfile => '来源简介';

  @override
  String get sourceProfileFakebookStandard => '假书标准';

  @override
  String get sourceProfileRecordingInspired => '录音灵感';

  @override
  String get smartDiagnostics => '智慧诊断';

  @override
  String get smartDiagnosticsHelp => '记录 Smart Generator 决策追踪以进行侦错。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '至少选择一个键以使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非调内';

  @override
  String get nonDiatonicRequiresKeyMode => '非 调内 选项仅在按键模式下可用。';

  @override
  String get secondaryDominant => '副属和弦';

  @override
  String get substituteDominant => '替补主力';

  @override
  String get modalInterchange => '调式借用';

  @override
  String get modalInterchangeDisabledHelp => '模态交换仅出现在按键模式下，因此该选项在自由模式下停用。';

  @override
  String get rendering => '渲染';

  @override
  String get keyCenterLabelStyle => '按键标签样式';

  @override
  String get keyCenterLabelStyleHelp => '在明确的模式名称和经典的大写/小写主音标签之间进行选择。';

  @override
  String get chordSymbolStyle => '和弦符号样式';

  @override
  String get chordSymbolStyleHelp => '仅更改显示层。调和逻辑仍然是规范的。';

  @override
  String get styleCompact => '袖珍的';

  @override
  String get styleMajText => '正文';

  @override
  String get styleDeltaJazz => '三角洲爵士乐';

  @override
  String get keyCenterLabelStyleModeText => 'C 大调： / C 小调：';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C： / C：';

  @override
  String get allowV7sus4 => '允许 V7sus4（V7、V7/x）';

  @override
  String get allowTensions => '允许紧张';

  @override
  String get chordTypeFilters => '和弦种类';

  @override
  String get chordTypeFiltersHelp => '选择生成器中可出现的和弦种类。';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '已启用 $selected / $total';
  }

  @override
  String get chordTypeGroupTriads => '三和弦';

  @override
  String get chordTypeGroupSevenths => '七和弦';

  @override
  String get chordTypeGroupSixthsAndAddedTone => '六和弦与附加音';

  @override
  String get chordTypeGroupDominantVariants => '属功能变体';

  @override
  String get chordTypeRequiresKeyMode => '只有在至少选择一个调性时才能使用 V7sus4。';

  @override
  String get chordTypeKeepOneEnabled => '至少保留一种和弦种类为启用状态。';

  @override
  String get tensionHelp => '仅 罗马数字 设定档和选定晶片';

  @override
  String get inversions => '倒转';

  @override
  String get enableInversions => '启用反转';

  @override
  String get inversionHelp => '选择和弦后随机斜线低音渲染；它不追踪先前的低音。';

  @override
  String get firstInversion => '第一次反转';

  @override
  String get secondInversion => '第二次反转';

  @override
  String get thirdInversion => '第三次反转';

  @override
  String get keyPracticeOverview => '主要实践概述';

  @override
  String get freePracticeOverview => '自由练习概述';

  @override
  String get keyModeTag => '按键模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有按键';

  @override
  String get metronomeOnTag => '节拍器开启';

  @override
  String get metronomeOffTag => '节拍器关闭';

  @override
  String get pressNextChordToBegin => '按下一个和弦开始';

  @override
  String get freeModeActive => '自由模式激活';

  @override
  String get freePracticeDescription => '使用具有随机和弦品质的所有 12 个半音根音进行广泛的阅读练习。';

  @override
  String get smartPracticeDescription => '遵循所选按键中的 和声功能 流程，同时允许优雅的智慧发电机运动。';

  @override
  String get keyPracticeDescription => '使用选定的按键并启用 罗马数字 产生 调内 练习材料。';

  @override
  String get keyboardShortcutHelp => '空格：下一个和弦 输入：开始或停止自动播放 向上/向下：调整 BPM';

  @override
  String get nextChord => '下一个和弦';

  @override
  String get audioPlayChord => '弹奏和弦';

  @override
  String get audioPlayArpeggio => '弹奏琶音';

  @override
  String get audioPlayProgression => '游戏行程';

  @override
  String get audioPlayPrompt => '播放提示';

  @override
  String get startAutoplay => '开始自动播放';

  @override
  String get stopAutoplay => '停止自动播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '增加每分钟节拍数';

  @override
  String get bpmLabel => '业务流程管理';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

  @override
  String allowedRange(int min, int max) {
    return '允许范围：$min-$max';
  }

  @override
  String get modeMajor => '主要的';

  @override
  String get modeMinor => '次要的';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => '和声配置建议';

  @override
  String get voicingSuggestionsSubtitle => '看看该和弦的具体音符选择。';

  @override
  String get voicingSuggestionsEnabled => '启用语音建议';

  @override
  String get voicingSuggestionsHelp => '显示当前和弦的三个可演奏音符级 和声配置 想法。';

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
  String get voicingComplexity => '发声复杂性';

  @override
  String get voicingComplexityHelp => '控制建议的丰富多彩程度。';

  @override
  String get voicingComplexityBasic => '基本的';

  @override
  String get voicingComplexityStandard => '标准';

  @override
  String get voicingComplexityModern => '现代的';

  @override
  String get voicingTopNotePreference => '前调偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      '向选定的 顶线 倾斜建议。锁定的 和声配置 首先获胜，然后重复的和弦保持稳定。';

  @override
  String get voicingTopNotePreferenceAuto => '汽车';

  @override
  String get allowRootlessVoicings => '允许无根发声';

  @override
  String get allowRootlessVoicingsHelp => '当 引导音 保持清晰时，让建议忽略根。';

  @override
  String get maxVoicingNotes => '最大发声音符';

  @override
  String get lookAheadDepth => '前瞻深度';

  @override
  String get lookAheadDepthHelp => '排名可能会考虑多少个未来和弦。';

  @override
  String get showVoicingReasons => '显示表达原因';

  @override
  String get showVoicingReasonsHelp => '在每张建议卡上显示简短的解释晶片。';

  @override
  String get voicingSuggestionNatural => '最自然';

  @override
  String get voicingSuggestionColorful => '最丰富多彩';

  @override
  String get voicingSuggestionEasy => '最简单';

  @override
  String get voicingSuggestionNaturalSubtitle => '语音领先';

  @override
  String get voicingSuggestionColorfulSubtitle => '倾向于色调';

  @override
  String get voicingSuggestionEasySubtitle => '手型紧凑';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle => '连接和解析优先';

  @override
  String get voicingSuggestionNaturalStableSubtitle => '形状相同，稳定配合';

  @override
  String get voicingSuggestionTopLineSubtitle => '顶线线索';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle => '改变了前面的张力';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => '现代四色';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle =>
      'Tritone-sub 边缘带有明亮的 引导音s';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle => '带有明亮扩展的引导音';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle => '核心色调，范围较小';

  @override
  String get voicingSuggestionEasyStableSubtitle => '重复友善的手形';

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
  String get voicingTopNoteLabel => '顶部';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return '顶线目标：$note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '锁定 顶线：$note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '重复顶线：$note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '最近的 顶线 到 $note';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '没有 $note 的确切 顶线';
  }

  @override
  String get voicingFamilyShell => '壳';

  @override
  String get voicingFamilyRootlessA => '无根A';

  @override
  String get voicingFamilyRootlessB => '无根B';

  @override
  String get voicingFamilySpread => '传播';

  @override
  String get voicingFamilySus => '苏斯';

  @override
  String get voicingFamilyQuartal => '夸塔尔';

  @override
  String get voicingFamilyAltered => '改变';

  @override
  String get voicingFamilyUpperStructure => '上部结构';

  @override
  String get voicingLockSuggestion => '锁定建议';

  @override
  String get voicingUnlockSuggestion => '解锁建议';

  @override
  String get voicingSelected => '已选择';

  @override
  String get voicingLocked => '锁定';

  @override
  String get voicingReasonEssentialCore => '涵盖基本音调';

  @override
  String get voicingReasonGuideToneAnchor => '第三/第七主播';

  @override
  String voicingReasonGuideResolution(int count) {
    return '$count 引导音解析';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '$count 保留常用音调';
  }

  @override
  String get voicingReasonStableRepeat => '稳定重复';

  @override
  String get voicingReasonTopLineTarget => '顶线目标';

  @override
  String get voicingReasonLowMudAvoided => '低音域清晰度';

  @override
  String get voicingReasonCompactReach => '舒适的触达范围';

  @override
  String get voicingReasonBassAnchor => '受人尊敬的低音主播';

  @override
  String get voicingReasonNextChordReady => '下一个和弦准备好了';

  @override
  String get voicingReasonAlteredColor => '紧张局势发生变化';

  @override
  String get voicingReasonRootlessClarity => '轻质无根形状';

  @override
  String get voicingReasonSusRelease => 'Sus 发布设置';

  @override
  String get voicingReasonQuartalColor => '四分色';

  @override
  String get voicingReasonUpperStructureColor => '上部结构颜色';

  @override
  String get voicingReasonTritoneSubFlavor => 'Tritone-亚风味';

  @override
  String get voicingReasonLockedContinuity => '锁定连续性';

  @override
  String get voicingReasonGentleMotion => '手部动作流畅';

  @override
  String get mainMenuIntro => '在同一个地方开始和弦练习、进行分析与和声学习。';

  @override
  String get mainMenuGeneratorTitle => '和弦生成器';

  @override
  String get mainMenuGeneratorDescription => '用智能走向和和弦配置提示快速生成练习题。';

  @override
  String get openGenerator => '开始练习';

  @override
  String get openAnalyzer => '分析进行';

  @override
  String get mainMenuAnalyzerTitle => '和弦分析器';

  @override
  String get mainMenuAnalyzerDescription => '读取进行并快速查看调性、罗马数字与和声功能。';

  @override
  String get mainMenuStudyHarmonyTitle => '和声学习';

  @override
  String get mainMenuStudyHarmonyDescription => '继续课程、复习章节，培养实战和声感。';

  @override
  String get openStudyHarmony => '开始和声学习';

  @override
  String get studyHarmonyTitle => '和声学习';

  @override
  String get studyHarmonySubtitle => '透过结构化和谐中心进行快速课程输入和章节进展。';

  @override
  String get studyHarmonyPlaceholderTag => '学习甲板';

  @override
  String get studyHarmonyPlaceholderBody =>
      '课程数据、提示和答案介面已经共享一个可重复使用的音符、和弦、音阶和进行练习的学习流程。';

  @override
  String get studyHarmonyTestLevelTag => '练习演练';

  @override
  String get studyHarmonyTestLevelAction => '开钻';

  @override
  String get studyHarmonySubmit => '提交';

  @override
  String get studyHarmonyNextPrompt => '下一个提示';

  @override
  String get studyHarmonySelectedAnswers => '精选答案';

  @override
  String get studyHarmonySelectionEmpty => '尚未选出答案。';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total 正确';
  }

  @override
  String get studyHarmonyAttempts => '尝试';

  @override
  String get studyHarmonyAccuracy => '准确性';

  @override
  String get studyHarmonyElapsedTime => '时间';

  @override
  String get studyHarmonyObjective => '目标';

  @override
  String get studyHarmonyPromptInstruction => '选择匹配的答案';

  @override
  String get studyHarmonyNeedSelection => '提交前至少选择一个答案。';

  @override
  String get studyHarmonyCorrectLabel => '正确的';

  @override
  String get studyHarmonyIncorrectLabel => '不正确';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return '正确的。 $answer 是正确答案。';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return '不正确。 $answer 是正确答案，但你却失去了一条生命。';
  }

  @override
  String get studyHarmonyGameOverTitle => '游戏结束';

  @override
  String get studyHarmonyGameOverBody => '三个人的命都没有了。重试此等级或返回 和声学习 中心。';

  @override
  String get studyHarmonyLevelCompleteTitle => '已通关等级';

  @override
  String get studyHarmonyLevelCompleteBody => '您已达到课程目标。请在下面检查您的准确性和清除时间。';

  @override
  String get studyHarmonyBackToHub => '返回和声学习';

  @override
  String get studyHarmonyRetry => '重试';

  @override
  String get studyHarmonyHubHeroEyebrow => '学习中心';

  @override
  String get studyHarmonyHubHeroBody =>
      '使用「继续」恢复动力，使用「回顾」重新审视弱点，使用「每日」从解锁的路径中获得确定性的教训。';

  @override
  String get studyHarmonyTrackFilterLabel => '路线';

  @override
  String get studyHarmonyTrackCoreFilterLabel => '核心';

  @override
  String get studyHarmonyTrackPopFilterLabel => '流行';

  @override
  String get studyHarmonyTrackJazzFilterLabel => '爵士';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => '古典';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total 课程已清除';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total 章节已完成';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '$stars星星';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return '$mastered/$total技能掌握';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '$count 评论已准备好';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return '连胜x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count 运行';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return '最佳$rank';
  }

  @override
  String get studyHarmonyBossTag => '老板';

  @override
  String get studyHarmonyContinueCardTitle => '继续';

  @override
  String get studyHarmonyContinueResumeHint => '继续您最近接触的课程。';

  @override
  String get studyHarmonyContinueFrontierHint => '直接跳到你目前前线的下一堂课。';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return '继续：$lessonTitle';
  }

  @override
  String get studyHarmonyContinueAction => '继续';

  @override
  String get studyHarmonyReviewCardTitle => '复习';

  @override
  String get studyHarmonyReviewQueueHint => '会从当前的复习队列中抽出。';

  @override
  String get studyHarmonyReviewWeakHint => '会优先挑出你已玩课程中表现最弱的一项。';

  @override
  String get studyHarmonyReviewFallbackHint => '目前还没有复习欠账，所以会回到你的前线课程。';

  @override
  String get studyHarmonyReviewRetryNeededHint => '这堂课在失误或未完成后，值得再补一次。';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint => '这堂课已排入队列，准备做一次快速准确率刷新。';

  @override
  String get studyHarmonyReviewAction => '复习';

  @override
  String get studyHarmonyDailyCardTitle => '每日挑战';

  @override
  String get studyHarmonyDailyCardHint => '从您已解锁的课程中开启今天的确定性精选内容。';

  @override
  String get studyHarmonyDailyCardHintCompleted =>
      '今天的每日挑战已通关。想再刷一次也可以，或明天回来延续连胜。';

  @override
  String get studyHarmonyDailyAction => '开始每日挑战';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return '种子 $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => '今天每日清仓';

  @override
  String get studyHarmonyReviewSessionTitle => '弱点回顾';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return '混合围绕 $chapterTitle 和您最近最薄弱的技能的简短回顾。';
  }

  @override
  String get studyHarmonyDailySessionTitle => '每日挑战';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return '播放今天由 $chapterTitle 和您当前前沿构建的种子组合。';
  }

  @override
  String get studyHarmonyModeLesson => '课程模式';

  @override
  String get studyHarmonyModeReview => '复习模式';

  @override
  String get studyHarmonyModeDaily => '日常模式';

  @override
  String get studyHarmonyModeLegacy => '练习模式';

  @override
  String get studyHarmonyShortcutHint =>
      '输入提交或继续。 R 重新启动。 1-9 选出一个答案。 Tab 和 Shift+Tab 移动焦点。';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '$total $remaining 剩余寿命';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => '技能增益';

  @override
  String get studyHarmonyResultReviewFocusTitle => '复习重点';

  @override
  String get studyHarmonyResultRewardTitle => '会话奖励';

  @override
  String get studyHarmonyBonusGoalsTitle => '奖金目标';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return '排名 $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '$stars星星';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return '最佳$rank·$stars星星';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return '每日连胜 x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => '新个人最佳成绩';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded => '审核原因：需要重试';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh => '审核原因：精度刷新';

  @override
  String get studyHarmonyReviewReasonLowMastery => '点评理由：掌握程度低';

  @override
  String get studyHarmonyReviewReasonStaleSkill => '点评理由：技能陈旧';

  @override
  String get studyHarmonyReviewReasonWeakSpot => '点评理由：薄弱环节';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh => '评鉴理由：前沿刷新';

  @override
  String get studyHarmonyQuestBoardTitle => '任务面板';

  @override
  String get studyHarmonyQuestCompletedTag => '完全的';

  @override
  String get studyHarmonyQuestTodayTag => '今天';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target 完整';
  }

  @override
  String get studyHarmonyQuestDailyTitle => '每日连胜';

  @override
  String get studyHarmonyQuestDailyBody => '完成今天的每日种子组合，延续你的连胜。';

  @override
  String get studyHarmonyQuestDailyBodyCompleted => '今天的每日挑战已通关，这一段连胜暂时安全。';

  @override
  String get studyHarmonyQuestFrontierTitle => '前缘推进';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return '通关 $lessonTitle，把学习路线再往前推一步。';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      '目前已解锁的课程都已通关。可以重打首领课，或继续追星。';

  @override
  String get studyHarmonyQuestStarsTitle => '追星';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return '将额外的星星推入 $chapterTitle 内。';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback => '在当前章节中添加额外的星星。';

  @override
  String studyHarmonyComboLabel(int count) {
    return '组合 x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return '最佳组合 x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => '留住所有的心';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return '精准度达到$percent%';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return '达到连击 x$count';
  }

  @override
  String get studyHarmonyBonusSweepTag => '奖金横扫';

  @override
  String get studyHarmonySkillNoteRead => '笔记阅读';

  @override
  String get studyHarmonySkillNoteFindKeyboard => '键盘音符查找';

  @override
  String get studyHarmonySkillNoteAccidentals => '升号和平号';

  @override
  String get studyHarmonySkillChordSymbolToKeys => '和弦符号到琴键';

  @override
  String get studyHarmonySkillChordNameFromTones => '和弦命名';

  @override
  String get studyHarmonySkillScaleBuild => '规模建设';

  @override
  String get studyHarmonySkillRomanRealize => '罗马数字的实现';

  @override
  String get studyHarmonySkillRomanIdentify => '罗马数字识别';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => '全音阶';

  @override
  String get studyHarmonySkillHarmonyFunction => '函数基础知识';

  @override
  String get studyHarmonySkillProgressionKeyCenter => '进展 调性中心';

  @override
  String get studyHarmonySkillProgressionFunction => '渐进函数读取';

  @override
  String get studyHarmonySkillProgressionNonDiatonic => '进展非调内检测';

  @override
  String get studyHarmonySkillProgressionFillBlank => '进度填写';

  @override
  String get studyHarmonyHubChapterSectionTitle => '章节';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return '$cleared/$total 课程已清除';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return '$count 课程';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count 已清除';
  }

  @override
  String get studyHarmonyOpenChapterAction => '打开章节';

  @override
  String get studyHarmonyLockedChapterTag => '锁定章节';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return '下一个：$lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return '这条轨道仍然被锁定。今天切换回$coreTrack继续学习。';
  }

  @override
  String get studyHarmonyCoreTrackTitle => '核心路线';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '从音符和键盘开始，然后透过和弦、音阶、罗马数字、调内 基础知识和短进行分析进行累积。';

  @override
  String get studyHarmonyChapterNotesTitle => '第一章：音符与键盘';

  @override
  String get studyHarmonyChapterNotesDescription => '将音符名称映射到键盘并熟悉白键和简单的记号。';

  @override
  String get studyHarmonyChapterChordsTitle => '第 2 章：和弦基础知识';

  @override
  String get studyHarmonyChapterChordsDescription =>
      '拼写基本的三和弦和七和弦，然后根据它们的音调说出常见的和弦形状。';

  @override
  String get studyHarmonyChapterScalesTitle => '第 3 章：音阶与调';

  @override
  String get studyHarmonyChapterScalesDescription => '建立大调和小调音阶，然后找出哪些音属于某个调。';

  @override
  String get studyHarmonyChapterRomanTitle => '第 4 章：罗马数字与全音阶';

  @override
  String get studyHarmonyChapterRomanDescription =>
      '将简单的 罗马数字 转换为和弦，从和弦中识别它们，并按功能对 调内 基础进行排序。';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle => '第5章 进阶侦探Ⅰ';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '阅读简短的核心进行，找到可能的 调性中心，并找出和弦函数或奇数。';

  @override
  String get studyHarmonyChapterMissingChordTitle => '第 6 章：缺失和弦 I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      '在一个简短的进程中填补一个空白，并了解下一步节奏和功能的发展方向。';

  @override
  String get studyHarmonyOpenLessonAction => '打开课程';

  @override
  String get studyHarmonyLockedLessonAction => '未解锁';

  @override
  String get studyHarmonyClearedTag => '已通关';

  @override
  String get studyHarmonyComingSoonTag => '即将推出';

  @override
  String get studyHarmonyPopTrackTitle => '流行路线';

  @override
  String get studyHarmonyPopTrackDescription => '核心曲目稳定后，将规划以歌曲为中心的路径。';

  @override
  String get studyHarmonyJazzTrackTitle => '爵士路线';

  @override
  String get studyHarmonyJazzTrackDescription => '在核心课程确定之前，爵士乐和声内容将保持锁定。';

  @override
  String get studyHarmonyClassicalTrackTitle => '古典路线';

  @override
  String get studyHarmonyClassicalTrackDescription => '古典语境中的功能和谐将在稍后阶段实现。';

  @override
  String get studyHarmonyObjectiveQuickDrill => '快速训练';

  @override
  String get studyHarmonyObjectiveBossReview => '首领复习';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => '白键音符狩猎';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription => '阅读音符名称并点击匹配的白键。';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => '命名突出显示的注释';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      '查看突出显示的按键并选择正确的音符名称。';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => '黑键和双胞胎';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      '首先了解黑键的升记号和降记号拼字。';

  @override
  String get studyHarmonyLessonNotesBossTitle => 'Boss：快速音符狩猎';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      '将笔记阅读和键盘查找混合到一个简短的快速回合。';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => '键盘上的三和弦';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      '直接在键盘上建立常见的大调、小调和减三和弦。';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => '键盘上的七度';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      '加入七和弦并在键盘上拼写一些常见的七和弦。';

  @override
  String get studyHarmonyLessonChordNameTitle => '命名突出显示的和弦';

  @override
  String get studyHarmonyLessonChordNameDescription => '阅读突出显示的和弦形状并选择正确的和弦名称。';

  @override
  String get studyHarmonyLessonChordsBossTitle => '头目：三合会和七合会评论';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      '在一篇混合评论中在和弦拼字和和弦命名之间切换。';

  @override
  String get studyHarmonyLessonMajorScaleTitle => '建构大调音阶';

  @override
  String get studyHarmonyLessonMajorScaleDescription => '选择属于简单大调音阶的每个音调。';

  @override
  String get studyHarmonyLessonMinorScaleTitle => '建构小调音阶';

  @override
  String get studyHarmonyLessonMinorScaleDescription => '从几个常用调来建构自然小调和和声小调音阶。';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => '主要会员';

  @override
  String get studyHarmonyLessonKeyMembershipDescription => '寻找哪些音调属于指定键。';

  @override
  String get studyHarmonyLessonScalesBossTitle => 'Boss：鳞片修复';

  @override
  String get studyHarmonyLessonScalesBossDescription => '在短期修复过程中混合规模建设和关键成员。';

  @override
  String get studyHarmonyLessonRomanToChordTitle => '罗马音转和弦';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      '读取调和 罗马数字，然后选择相符的和弦。';

  @override
  String get studyHarmonyLessonChordToRomanTitle => '和弦转罗马音';

  @override
  String get studyHarmonyLessonChordToRomanDescription => '读取调内的和弦并选择匹配的 罗马数字。';

  @override
  String get studyHarmonyLessonDiatonicityTitle => '是否全音阶';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      '用简单的调将和弦分类为 调内 和 非调内 答案。';

  @override
  String get studyHarmonyLessonFunctionTitle => '函数基础知识';

  @override
  String get studyHarmonyLessonFunctionDescription => '将简单和弦分类为主和弦、下属功能 或属和弦。';

  @override
  String get studyHarmonyLessonRomanBossTitle => 'Boss：功能基础组合';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      '一起回顾罗马音到和弦、和弦到罗马音、调内ity 和功能。';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle => '找到钥匙中心';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      '阅读一个简短的进展并选择最清晰的 调性中心。';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle => '上下文中的函数';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      '专注于一个突出显示的和弦，并在一个简短的进行中命名它的角色。';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle => '寻找局外人';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      '求 调内 主要读数以外的一个和弦。';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Boss：混合分析';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      '在一轮简短的侦探中混合关键中心读取、功能定位和 非调内 检测。';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle => '填补缺失的和弦';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      '透过选择最适合局部功能的和弦来完成短的四和弦进行。';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle => '节奏填充';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      '使用节奏拉力来选择乐句末尾附近缺少的和弦。';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Boss：混合填充';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      '用更多的和声压力解决一组简短的填充级数问题。';

  @override
  String get studyHarmonyChapterCheckpointTitle => '检查站挑战';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      '将关键中心、功能、颜色和填充练习结合到更快的混合复习集中。';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => '节奏冲刺';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      '快速读出和声的作用，然后在轻压下插入缺少的终止和弦。';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => '颜色和基调';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      '在中心侦测和 非调内 颜色呼叫之间切换，不会遗失执行绪。';

  @override
  String get studyHarmonyLessonCheckpointBossTitle => 'Boss：检查站挑战';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      '清除一个混合了键中心、功能、颜色和节奏修复提示的综合检查点。';

  @override
  String get studyHarmonyChapterCapstoneTitle => '顶点试验';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      '透过更艰难的混合进展回合完成核心路径，这些回合要求速度、色彩听觉和清晰的解析度选择。';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => '周转接力';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      '在紧凑的周转中在功能读取和缺失和弦修复之间进行交换。';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle => '借用颜色调用';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      '快速捕捉模态颜色，然后在 调性中心 消失之前对其进行确认。';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => '解析度实验室';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      '追踪每个乐句想要落地的位置，并选择最能解决动作的和弦。';

  @override
  String get studyHarmonyLessonCapstoneBossTitle => 'Boss：最终升级考试';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      '通过一项最终混合考试，中心、功能、颜色和分辨率都在压力下。';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return '在键盘上找到$note';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote => '哪个注释突出显示？';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return '在键盘上建构$chord';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord => '哪个和弦突出显示？';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return '选择$scaleName中的每个音符';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return '选择属于$keyName的笔记';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return '在$keyName中，哪一个和弦与$roman相符？';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return '在 $keyName 中，什么 罗马数字 与 $chord 相符？';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return '在$keyName中，$chord是调内吗？';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return '$keyName中，$chord有什么功能？';
  }

  @override
  String get studyHarmonyProgressionStripLabel => '进展';

  @override
  String get studyHarmonyPromptProgressionKeyCenter => '哪一个 调性中心 最适合这个进程？';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '$chord在这里扮演什么角色呢？';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic => '在这个进行中，哪个和弦感觉最不调内？';

  @override
  String get studyHarmonyPromptProgressionMissingChord => '哪个和弦最能填补空白？';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return '分析仪在 $keyLabel 中最清楚地读取此进程。';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '在这种情况下，$chord 的行为最像 $functionLabel 和弦。';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord 在主要的 $keyLabel 读数中脱颖而出，因此它是最好的 非调内 选择。';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord 恢复了此进程中预期的 $functionLabel 拉力。';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index。 $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic专业';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic 自然小调';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic 和声小调';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic专业';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic 小调';
  }

  @override
  String get studyHarmonyChoiceDiatonic => '全音阶';

  @override
  String get studyHarmonyChoiceNonDiatonic => '非调内';

  @override
  String get studyHarmonyChoiceTonic => '补品';

  @override
  String get studyHarmonyChoicePredominant => '占主导地位';

  @override
  String get studyHarmonyChoiceDominant => '主导的';

  @override
  String get studyHarmonyChoiceOther => '其他';

  @override
  String get chordAnalyzerTitle => '和弦分析器';

  @override
  String get chordAnalyzerSubtitle => '贴上和弦进行，即可得到偏保守的和声判读。';

  @override
  String get chordAnalyzerInputLabel => '和弦进行';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      '括号外可用空格、| 或逗号分隔和弦。括号内的逗号会保留在同一个和弦之中。\n\n使用 ? 代表尚未确定的和弦空位。分析器会根据前后和声语境推断最自然的补法，若判读存在歧义也会给出候选。变奏生成功能也能更自由地重新和声化这个位置。\n\n支持小写根音、斜线低音、sus/alt/add 形式，以及 C7(b9, #11) 这类张力写法。\n\n在触控设备上可使用和弦面板，或在需要自由输入时切换到 ABC 输入。';

  @override
  String get chordAnalyzerInputHelpTitle => '输入提示';

  @override
  String get chordAnalyzerAnalyze => '分析';

  @override
  String get chordAnalyzerKeyboardTitle => '和弦面板';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '点按符号来组出进行。若需要自由输入，可切换到 ABC 输入并保留系统键盘。';

  @override
  String get chordAnalyzerKeyboardDesktopHint => '可直接输入、贴上，或点按符号插入到游标位置。';

  @override
  String get chordAnalyzerChordPad => '面板';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '贴上';

  @override
  String get chordAnalyzerClear => '重置';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => '空格键';

  @override
  String get chordAnalyzerAnalyzing => '正在分析进行...';

  @override
  String get chordAnalyzerInitialTitle => '先输入一段进行';

  @override
  String get chordAnalyzerInitialBody =>
      '输入像 Dm7, G7 | ? Am 或 Cmaj7 | Am7 D7 | Gmaj7 这样的进行，即可查看可能的调性、罗马数字、推断补全与简短摘要。';

  @override
  String get chordAnalyzerPlaceholderExplanation => '这个 ? 是根据前后和声语境推断出的空位。';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return '建议补入：$chord';
  }

  @override
  String get chordAnalyzerDetectedKeys => '检测到的调性';

  @override
  String get chordAnalyzerPrimaryReading => '主要判读';

  @override
  String get chordAnalyzerAlternativeReading => '替代判读';

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
  String get chordAnalyzerNoRecognizedChordsError => '这段进行中没有找到可辨识的和弦。';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '部分符号已略过：$tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '调性中心在 $primary 与 $alternative 之间仍然略带歧义。';
  }

  @override
  String get chordAnalyzerUnresolvedWarning => '部分和弦仍带有歧义，因此这份判读刻意保持保守。';

  @override
  String get chordAnalyzerFunctionTonic => '主功能';

  @override
  String get chordAnalyzerFunctionPredominant => '下属功能';

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
  String get chordAnalyzerRemarkModalInterchange => '可能是来自平行小调的调式借用。';

  @override
  String get chordAnalyzerRemarkAmbiguous => '这个和弦在目前的判读中仍带有歧义。';

  @override
  String get chordAnalyzerRemarkUnresolved => '依照目前偏保守的启发式判断，这个和弦仍未能明确定义。';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 终止';

  @override
  String get chordAnalyzerTagTurnaround => 'turnaround';

  @override
  String get chordAnalyzerTagDominantResolution => '属功能解决';

  @override
  String get chordAnalyzerTagPlagalColor => '变格 / 调式色彩';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return '这段进行最有可能以 $key 为中心。';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '另一种可能的判读是 $key。';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '它也呈现出 $tag 的特征。';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from 与 $through 在这里可听成通往 $target 的 $fromFunction 与 $throughFunction 和弦。';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord 也可以听成是指向 $target 的副属和弦。';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord 也可以听成是指向 $target 的三全音替代。';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord 增添了可能的调式借用色彩。';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous => '部分细节仍带有歧义，因此这份判读刻意维持保守。';

  @override
  String get chordAnalyzerExamplesTitle => '范例';

  @override
  String get chordAnalyzerConfidenceLabel => '信心度';

  @override
  String get chordAnalyzerAmbiguityLabel => '歧义程度';

  @override
  String get chordAnalyzerWhyThisReading => '为何这样判读';

  @override
  String get chordAnalyzerCompetingReadings => '也有可能';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '已忽略的修饰：$details';
  }

  @override
  String get chordAnalyzerGenerateVariations => '生成变体';

  @override
  String get chordAnalyzerVariationsTitle => '自然的变体';

  @override
  String get chordAnalyzerVariationsBody =>
      '这些建议会保留原本的走向，并用相近功能的替代和弦重新上色。套用后会立刻重新分析。';

  @override
  String get chordAnalyzerApplyVariation => '应用这个变体';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => '终止色彩';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      '保留原本的落点，同时让下属前功能更暗一些，并换成三全音替代属和弦。';

  @override
  String get chordAnalyzerVariationBackdoorTitle => 'Backdoor 色彩';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      '借用平行小调的 ivm7-bVII7 色彩，最后落回同一个主和弦。';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => '定向 ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      '重新组成一个仍然指向相同目标和弦的相关 ii-V。';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => '小调终止色彩';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      '保留小调终止感，但把色彩推向 iiø-Valt-i。';

  @override
  String get chordAnalyzerVariationColorLiftTitle => '色彩提升';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      '保持接近的根音与功能，同时用自然的扩展音让和弦更有表情。';

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '输入警告：$details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '括号不平衡，导致符号的一部分无法完全确定。';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '已忽略意外出现的右括号。';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '明确的 $extension 色彩加强了这个判读。';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      '变化属和弦的色彩支持它作为属功能的判读。';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '斜线低音 $bass 让低音线或转位仍具有明确意义。';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '下一个和弦支持它朝向 $target 解决。';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor => '这种色彩可听成从平行调借来的效果。';

  @override
  String get chordAnalyzerEvidenceSuspensionColor => '挂留色彩削弱了属功能的拉力，但没有把它抹去。';

  @override
  String get chordAnalyzerLowConfidenceTitle => '低信心判读';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '候选调性彼此太接近，或部分符号只能局部还原，因此请把它当作审慎的第一版判读。';

  @override
  String get chordAnalyzerEmptyMeasure => '这一小节为空，但仍保留在计数之中。';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure => '这一小节没有还原出可分析的和弦记号。';

  @override
  String get chordAnalyzerParseIssuesTitle => '解析问题';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '空白符号。';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => '无法辨识根音。';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root 不是支援的根音拼写。';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return '斜线低音 $bass 不是支援的低音拼写。';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '不支援的后缀或修饰：$suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => 'Analysis display';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      'Choose how much theory detail appears and how non-diatonic categories are highlighted.';

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
  String get studyHarmonyDailyReplayAction => '每日重播';

  @override
  String get studyHarmonyMilestoneCabinetTitle => '里程碑奖牌';

  @override
  String get studyHarmonyMilestoneLessonsTitle => '探路者奖章';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return '清除核心基础中的 $target 课程。';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => '明星收藏家';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return '在 和声学习 上收集 $target 星星。';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => '连胜传奇';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return '达到 $target 的最佳每日连续记录。';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => '精通学者';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return '掌握$target技能。';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return '获得 $earned/$total 奖牌';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => '柜子齐全';

  @override
  String get studyHarmonyMilestoneTierBronze => '铜牌';

  @override
  String get studyHarmonyMilestoneTierSilver => '银牌';

  @override
  String get studyHarmonyMilestoneTierGold => '金牌';

  @override
  String get studyHarmonyMilestoneTierPlatinum => '白金奖章';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$title $tier';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => '新奖牌';

  @override
  String get studyHarmonyChapterRemixTitle => '混音竞技场';

  @override
  String get studyHarmonyChapterRemixDescription =>
      '更长的混合套装，在没有警告的情况下打乱 调性中心、功能和借用颜色。';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => '桥梁建造者';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      '缝合功能读取并将缺少的和弦填充到一条流动的链中。';

  @override
  String get studyHarmonyLessonRemixPivotTitle => '色彩轴';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      '当进展在您脚下移动时，请追踪借用的颜色和关键中心枢轴。';

  @override
  String get studyHarmonyLessonRemixSprintTitle => '决议冲刺';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      '以更快的速度连续朗读功能、节奏填充和音调重力。';

  @override
  String get studyHarmonyLessonRemixBossTitle => '混音马拉松';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      '最后的混合马拉松将所有渐进阅读镜片重新投入设定。';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return '连胜保护卡 x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return '传奇皇冠$count';
  }

  @override
  String get studyHarmonyModeFocus => '对焦模式';

  @override
  String get studyHarmonyModeLegend => '传奇试炼';

  @override
  String get studyHarmonyFocusCardTitle => '焦点冲刺';

  @override
  String get studyHarmonyFocusCardHint => '用更少的生命与更紧的条件，集中攻克目前路线上最薄弱的环节。';

  @override
  String get studyHarmonyFocusFallbackHint => '先来一轮更硬的混合练习，测试目前的弱点。';

  @override
  String get studyHarmonyFocusAction => '开始冲刺';

  @override
  String get studyHarmonyFocusSessionTitle => '焦点冲刺';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return '从 $chapter 周边最薄弱的环节抽出内容，做一轮更紧凑的混合冲刺。';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '$count 课程混合';
  }

  @override
  String get studyHarmonyFocusRewardLabel => '每周奖励：连胜保护卡';

  @override
  String get studyHarmonyLegendCardTitle => '传奇试炼';

  @override
  String get studyHarmonyLegendCardHint => '把银阶以上的章节用 2 条命的精熟挑战再通一次，拿下传奇王冠。';

  @override
  String get studyHarmonyLegendFallbackHint =>
      '先完成一个章节，并把平均表现推到每课约 2 颗星，即可解锁传奇试炼。';

  @override
  String get studyHarmonyLegendAction => '追逐传奇';

  @override
  String get studyHarmonyLegendSessionTitle => '传奇试炼';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return '针对 $chapter 进行一轮毫不松手的精熟重播，只为拿下传奇王冠。';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '$count 课程连锁';
  }

  @override
  String get studyHarmonyLegendRiskLabel => '传奇王冠在此一搏';

  @override
  String get studyHarmonyWeeklyPlanTitle => '每周训练计划';

  @override
  String get studyHarmonyWeeklyRewardLabel => '奖励：连胜保护卡';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => '奖励已准备好';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => '已领取奖励';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => '多日出现';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return '本周不同日子在 $target 上保持活跃。';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle => '保持每日循环的活力';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return '日志 $target 本周每日清零。';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle => '完成焦点冲刺';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return '本周完成 $target 焦点冲刺。';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine => '昨天已使用连胜保护卡保住纪录。';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return '获得新的连胜保护卡。库存：$count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => '焦点冲刺已清除。';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return '为 $chapter 固定传奇表冠。';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => '安可阶梯';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      '一个简短的完成阶梯，将整个进度工具包压缩为最终的加演集。';

  @override
  String get studyHarmonyLessonEncorePulseTitle => '音调脉冲';

  @override
  String get studyHarmonyLessonEncorePulseDescription => '锁定音调中心和功能，无需任何预热提示。';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => '颜色交换';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      '交替借用的颜色可以透过缺失和弦修复来调用，以保持耳朵的诚实。';

  @override
  String get studyHarmonyLessonEncoreBossTitle => '安可结局';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      '最后一轮紧凑的老板回合会快速连续检查每个进展镜头。';

  @override
  String get studyHarmonyChapterMasteryBronze => '青铜色透明';

  @override
  String get studyHarmonyChapterMasterySilver => '银冠';

  @override
  String get studyHarmonyChapterMasteryGold => '金皇冠';

  @override
  String get studyHarmonyChapterMasteryLegendary => '传奇皇冠';

  @override
  String get studyHarmonyModeBossRush => 'Boss 冲刺模式';

  @override
  String get studyHarmonyBossRushCardTitle => '首领冲刺';

  @override
  String get studyHarmonyBossRushCardHint => '以更少生命和更高分数门槛，连打已解锁的首领课程。';

  @override
  String get studyHarmonyBossRushFallbackHint => '至少解锁两堂首领课，才能开启真正的首领冲刺混合挑战。';

  @override
  String get studyHarmonyBossRushAction => '开始首领冲刺';

  @override
  String get studyHarmonyBossRushSessionTitle => '首领冲刺';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return '把 $chapter 周边已解锁的首领课程串成一轮高压首领挑战。';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '$count 老大教训混杂';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => '仅限 2 条命';

  @override
  String get studyHarmonyResultBossRushLine => 'Boss Rush 已清除。';

  @override
  String get studyHarmonyChapterSpotlightTitle => '聚光灯对决';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      '最后的聚光灯设定隔离了借用的颜色、节奏压力和老板级整合。';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => '借镜头';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      '追踪 调性中心，而藉用的颜色则不断试图将您的阅读拉向一边。';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => '节奏交换';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      '在功能读取和节奏恢复之间切换，而不会失去著陆点。';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => '聚光灯对决';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      '一个封闭的老板套装，迫使每个进展镜头在压力下保持锐利。';

  @override
  String get studyHarmonyChapterAfterHoursTitle => '下班后实验室';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      '游戏后期实验室剥离了热身线索并混合了借用的颜色、节奏压力和中心追踪。';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => '模态阴影';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      '当借用的颜色不断将读数拖入黑暗时，请保留 调性中心。';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => '决议佯攻';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      '在短语滑过其真正的著陆点之前捕捉功能和节奏假动作。';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => '中心交叉淡入淡出';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      '混合中心侦测、功能读取和缺失和弦修复，无需任何额外的鹰架。';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => '最后的电话老板';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      '最后的深夜老板设定要求每个进展镜头在压力下保持清晰。';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return '接力获胜 $count';
  }

  @override
  String get studyHarmonyModeRelay => '竞技接力';

  @override
  String get studyHarmonyRelayCardTitle => '竞技接力';

  @override
  String get studyHarmonyRelayCardHint => '把不同章节已解锁的课程交错成同一轮混合挑战，测试快速切换与即时回想。';

  @override
  String get studyHarmonyRelayFallbackHint => '解锁至少两章才能开启竞技接力。';

  @override
  String get studyHarmonyRelayAction => '开始接力';

  @override
  String get studyHarmonyRelaySessionTitle => '竞技接力';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return '交错的继电器运行混合 $chapter 周围的解锁章节。';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return '$count 课程转播';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '$count章节混装';
  }

  @override
  String get studyHarmonyRelayChainLabel => '压力交错';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return '接力获胜 $count';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => '接力跑者';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return '清除 $target 竞技接力 运行。';
  }

  @override
  String get studyHarmonyChapterNeonTitle => '霓虹灯绕道';

  @override
  String get studyHarmonyChapterNeonDescription =>
      '游戏后期的章节不断透过借用的颜色、枢轴压力和恢复来弯曲道路。';

  @override
  String get studyHarmonyLessonNeonDetourTitle => '模态绕行';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      '即使借用的颜色不断将短语推到小巷中，也要追踪真正的中心。';

  @override
  String get studyHarmonyLessonNeonPivotTitle => '枢轴压力';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      '在谐波车道再次改变之前，连续读取中心移位和功能压力。';

  @override
  String get studyHarmonyLessonNeonLandingTitle => '借用的著陆点';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      '在藉色假出改变预期解析度后修复缺少的著陆和弦。';

  @override
  String get studyHarmonyLessonNeonBossTitle => '城市之光老板';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      '一个关闭的霓虹灯老板，混合了枢轴阅读、借用的颜色和节奏恢复，没有软著陆。';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tier联赛';
  }

  @override
  String get studyHarmonyLeagueCardTitle => '和声联赛';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return '这周朝 $tier 联赛再冲一点。现在最有效率的加成来源是 $mode。';
  }

  @override
  String get studyHarmonyLeagueCardHintMax => '本周钻石已经稳住了。继续串起高压通关，守住目前节奏。';

  @override
  String get studyHarmonyLeagueFallbackHint => '一旦本周有推荐的跑步活动，你的联赛攀登就会亮起来。';

  @override
  String get studyHarmonyLeagueAction => '冲刺联赛';

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '$score 本周 XP';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '$score/$target 本周 XP';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return '下一页： $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return '最佳提升：$mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return '联赛经验+$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return '晋级$tier联赛';
  }

  @override
  String get studyHarmonyLeagueTierRookie => '新秀';

  @override
  String get studyHarmonyLeagueTierBronze => '青铜';

  @override
  String get studyHarmonyLeagueTierSilver => '银';

  @override
  String get studyHarmonyLeagueTierGold => '金子';

  @override
  String get studyHarmonyLeagueTierDiamond => '钻石';

  @override
  String get studyHarmonyChapterMidnightTitle => '午夜转接台';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      '最后的控制室章节迫使人们快速阅读漂移的中心、错误的节奏和借用的重新路线。';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => '讯号漂移';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      '即使表面不断漂移到借用的颜色，也能追踪真实的色调讯号。';

  @override
  String get studyHarmonyLessonMidnightLineTitle => '假性走向';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      '在线路折叠回原位之前，透过假解析度读取功能压力。';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => '借用改道';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      '在藉用的颜色重新路由短语中流后恢复预期著陆。';

  @override
  String get studyHarmonyLessonMidnightBossTitle => '断电首领';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      '一个关闭的停电设置，混合了每个游戏后期镜头，而不给你一个安全的重置。';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return '任务箱 $count';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2x 联赛 XP x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => '任务宝箱';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '$count 剩余任务';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => '任务宝箱 就绪';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => '任务宝箱 已开通';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2x 联赛 XP 直播';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return '奖励：+$xp 联赛经验';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      '完成今天的三个任务，就能开启额外宝箱，继续推进本周的上升节奏。';

  @override
  String get studyHarmonyQuestChestReadyBody => '今天三个任务都完成了。再通关一轮，就能领走今天的宝箱奖励。';

  @override
  String get studyHarmonyQuestChestOpenedBody => '今天的三人组已经完成，宝箱奖励已经转换为联赛经验值。';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return '今天的宝箱已开启，接下来 $count 次通关都会套用 2x 联赛 XP。';
  }

  @override
  String get studyHarmonyQuestChestAction => '完成三人组';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return '最佳收尾：$mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return '每日任务 $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => '任务宝箱 已开启。';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return '任务宝箱 奖金 +$count 联赛 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '接下来 $count 次通关可享 2x 联赛 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return '加成奖励 +$count 联赛 XP';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return '2x 升压清除左侧 $count';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2x XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return '接下来 $count 次通关可享 2x 联赛 XP。趁加成还在，把它用在 $mode。';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => '天际回路';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      '最后的天际线环线迫使人们快速混合阅读幽灵中心、借来的重力和虚假的家园。';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => '残像脉冲';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      '在短语锁定到新车道之前，抓住残像的中心并发挥作用。';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => '重力换位';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      '处理借来的重力和缺少的和弦修复，同时进程不断交换其重量。';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => '假性归宿';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      '在进程突然关闭之前，仔细阅读错误到达并重建真实著陆。';

  @override
  String get studyHarmonyLessonSkylineBossTitle => '最终讯号首领';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      '最后的天际线首领将每个游戏后期进展镜头都连结到一个结束讯号测试。';

  @override
  String get studyHarmonyChapterAfterglowTitle => '余晖跑道';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      '一条由分歧决策、借来的诱饵和闪烁的中心组成的最后跑道，奖励在压力下干净的比赛后期阅读。';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => '分途判断';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      '选择修复和弦，使功能保持移动​​，而不会让乐句偏离轨道。';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => '借用诱引';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      '在进程快速返回之前，找出看起来像支点的借用颜色和弦。';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => '中心闪动';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      '按住音调中心，同时节奏提示闪烁并快速连续地重新路由。';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => '红线回归老板';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      '全速进行 调性中心、功能、借用颜色和缺失和弦修复的最终混合测试。';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return '旅游邮票 $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => '月游清零';

  @override
  String get studyHarmonyTourTitle => '和声巡回';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return '$count/$target 巡回邮票';
  }

  @override
  String get studyHarmonyTourReadyHeadline => '巡演大结局已准备就绪';

  @override
  String get studyHarmonyTourClaimedHeadline => '月游清零';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return '奖励：联赛 XP +$xp，以及 $count 个连胜保护卡';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return '这个月在 $target 个不同日子上线，就能锁定巡回奖励。';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return '本月打开 $target 个任务宝箱，让巡回印章本继续往前推。';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return '本月完成 $target 次焦点挑战。首领冲刺、竞技接力、焦点冲刺、传奇试炼与首领课程都会计入。';
  }

  @override
  String get studyHarmonyTourReadyBody => '本月的印章都收齐了。再通关一次，就能锁定巡回奖励。';

  @override
  String get studyHarmonyTourClaimedBody => '这个月的旅行结束了。保持节奏清晰，让下个月的路线开始火爆。';

  @override
  String get studyHarmonyTourAction => '提前游览';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return '活跃天数 $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return '任务宝箱s $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return '射灯 $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => '和声巡回 完成';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return '巡回赛奖金 +$count 联赛 XP';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return '连胜保护卡库存 $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => '破晓频率';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      '幽灵般的节奏、虚假的黎明转折和借来的花朵的日出安可，迫使长跑后干净的游戏后期阅读。';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => '幻影终止';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      '同时修复乐句假装结束但实际上落地时的节奏和功能。';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => '假曙光';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      '在进展再次拉开之前，抓住隐藏在过早日出中的中心转变。';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => '借用绽放';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      '将借用的颜色和功能结合在一起，同时和谐地打开一条更明亮但不稳定的车道。';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => '日出超速 Boss';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      '最终的黎明速度 Boss 将 调性中心、功能、非调内 颜色和缺失和弦修复连结到最后一个过载组。';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return '二重唱连胜 $count';
  }

  @override
  String get studyHarmonyDuetTitle => '双人契约';

  @override
  String get studyHarmonyDuetStartHeadline => '开始今天的二重唱';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return '二重唱连胜 $count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return '二重唱锁定当日 $count';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return '奖励：在关键连胜节点获得联赛 XP +$xp';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody => '先完成今天的每日挑战，再通关一次焦点挑战，让双人契约延续下去。';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      '每日赛开始了。完成焦点赛、接力赛、Boss Rush、传奇赛等一场聚光灯赛，或参加一场 Boss 课程来锁定二重唱。';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return '今天的双人契约已成立，共享连胜已来到 $count 天。';
  }

  @override
  String get studyHarmonyDuetDailyDone => '每日在';

  @override
  String get studyHarmonyDuetDailyMissing => '每日失踪';

  @override
  String get studyHarmonyDuetSpotlightDone => '聚光灯下';

  @override
  String get studyHarmonyDuetSpotlightMissing => '聚光灯缺失';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return '每日$done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return '聚光灯$done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return '连胜$count/$target';
  }

  @override
  String get studyHarmonyDuetAction => '继续二重唱';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return '二重唱连胜 $count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return '二重唱奖励+$count联赛XP';
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
  String get studyHarmonySolfegeTi => 'Si';

  @override
  String get studyHarmonyPrototypeCourseTitle => '和声学习原型';

  @override
  String get studyHarmonyPrototypeCourseDescription => '沿用到课程系统中的早期原型关卡。';

  @override
  String get studyHarmonyPrototypeChapterTitle => '原型课程';

  @override
  String get studyHarmonyPrototypeChapterDescription => '在扩展式学习系统上线前，暂时保留的课程。';

  @override
  String get studyHarmonyPrototypeLevelObjective => '在失去 3 条生命前答对 10 题即可通关';

  @override
  String get studyHarmonyPrototypeLevel1Title => '原型关卡 1 · Do / Mi / Sol';

  @override
  String get studyHarmonyPrototypeLevel1Description => '只辨认 Do、Mi、Sol 的基础暖身关卡。';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      '原型关卡 2 · Do / Re / Mi / Sol / La';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      '加快辨认 Do、Re、Mi、Sol、La 的中阶关卡。';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      '原型关卡 3 · Do / Re / Mi / Fa / Sol / La / Si / Do';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      '完整走过 Do-Re-Mi-Fa-Sol-La-Si-Do 音列的八度关卡。';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName（低音 C）';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName（高音 C）';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => '样板';

  @override
  String get studyHarmonyChapterBlueHourTitle => '蓝调时刻交汇';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      '交叉潮流、光环借用和双重视野的暮光重演，以最好的方式让游戏后期的阅读变得不稳定。';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => '交错流向';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      '追踪 调性中心 并运行，同时进程开始向两个方向拉动。';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => '光晕借用';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      '在短语变得模糊之前，阅读借来的颜色并恢复缺少的和弦。';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => '双重地平线';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      '保持真正的到达点，同时两个可能的地平线不断进出。';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => '双灯笼老板';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      '最后的蓝色时刻 Boss 强制快速交换中心、功能、借用的颜色和缺少的和弦修复。';

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
      'Paste a local audio file path and press enter to apply it. Built-in sound remains the fallback.';

  @override
  String get metronomeAccentLocalFilePath => 'Accent local file path';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      'Paste a local accent file path and press enter to apply it. Built-in sound remains the fallback.';

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
}
