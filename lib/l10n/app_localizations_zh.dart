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
  String get metronomeHelp => '打開節拍器後，練習時每一拍都會聽到點擊聲。';

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
  String get keys => '調';

  @override
  String get noKeysSelected => '尚未選擇任何調。全部關閉即可在自由模式下跨所有根音練習。';

  @override
  String get keysSelectedHelp => '所選調會用於有調性感知的隨機模式和 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '在保留已啟用的非自然音選項時，優先遵循功能和聲的流動。';

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
  String get jazzPresetModulationStudy => '轉調練習';

  @override
  String get jazzPresetAdvanced => '進階';

  @override
  String get sourceProfile => '來源設定';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook 標準';

  @override
  String get sourceProfileRecordingInspired => '錄音靈感';

  @override
  String get smartDiagnostics => 'Smart 診斷';

  @override
  String get smartDiagnosticsHelp => '記錄 Smart Generator 的決策追蹤以便除錯。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '請至少選擇一個調，才能使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非自然音';

  @override
  String get nonDiatonicRequiresKeyMode => '非自然音選項僅在調式模式中可用。';

  @override
  String get secondaryDominant => '副屬和弦';

  @override
  String get substituteDominant => '替代屬和弦';

  @override
  String get modalInterchange => '調式互換';

  @override
  String get modalInterchangeDisabledHelp => '調式互換只會出現在調式模式中，因此此選項在自由模式下會停用。';

  @override
  String get rendering => '顯示';

  @override
  String get chordSymbolStyle => '和弦符號樣式';

  @override
  String get chordSymbolStyleHelp => '只改變顯示層。和聲邏輯保持標準形式。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => '允許 V7sus4（V7, V7/x）';

  @override
  String get allowTensions => '允許張力音';

  @override
  String get tensionHelp => '僅使用羅馬數字設定與所選晶片';

  @override
  String get inversions => '轉位';

  @override
  String get enableInversions => '啟用轉位';

  @override
  String get inversionHelp => '選定和弦後會隨機套用斜線低音表示法；不會追蹤前一個低音。';

  @override
  String get firstInversion => '第一轉位';

  @override
  String get secondInversion => '第二轉位';

  @override
  String get thirdInversion => '第三轉位';

  @override
  String get keyPracticeOverview => '調式練習概覽';

  @override
  String get freePracticeOverview => '自由練習概覽';

  @override
  String get keyModeTag => '調式模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有調';

  @override
  String get metronomeOnTag => '節拍器開';

  @override
  String get metronomeOffTag => '節拍器關';

  @override
  String get pressNextChordToBegin => '按下 Next Chord 開始';

  @override
  String get freeModeActive => '自由模式啟用中';

  @override
  String get freePracticeDescription => '使用全部 12 個半音根音與隨機和弦品質，進行廣泛的讀譜練習。';

  @override
  String get smartPracticeDescription =>
      '在所選調內遵循功能和聲流動，同時加入自然的 Smart Generator 動作。';

  @override
  String get keyPracticeDescription => '使用所選調與已啟用的羅馬數字來產生自然音階練習素材。';

  @override
  String get keyboardShortcutHelp =>
      'Space: 下一個和弦  Enter: 開始或停止自動播放  Up/Down: 調整 BPM';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => '開始自動播放';

  @override
  String get stopAutoplay => '停止自動播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '提高 BPM';

  @override
  String allowedRange(int min, int max) {
    return '允許範圍: $min-$max';
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
  String get voicingTopNotePreference => '高音偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      '让建议倾向你选择的高音线。锁定的和声音型先优先，同一和弦重复时会尽量保持高音线稳定。';

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
  String get voicingSuggestionTopLineSubtitle => '先看高音线';

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
    return '目标高音：$note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '锁定高音线：$note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '重复高音线：$note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '最接近 $note 的高音线';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '没有能准确落在 $note 的高音线';
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
  String get voicingReasonTopLineTarget => '高音线目标';

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
  String get metronomeHelp => '打开节拍器后，练习时每一拍都会听到点击声。';

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
  String get keys => '调';

  @override
  String get noKeysSelected => '尚未选择任何调。全部关闭即可在自由模式下跨所有根音练习。';

  @override
  String get keysSelectedHelp => '所选调会用于有调性感知的随机模式和 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '在保留已启用的非自然音选项时，优先遵循功能和声的流动。';

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
  String get jazzPresetModulationStudy => '转调练习';

  @override
  String get jazzPresetAdvanced => '高级';

  @override
  String get sourceProfile => '来源配置';

  @override
  String get sourceProfileFakebookStandard => 'Fakebook 标准';

  @override
  String get sourceProfileRecordingInspired => '录音启发';

  @override
  String get smartDiagnostics => 'Smart 诊断';

  @override
  String get smartDiagnosticsHelp => '记录 Smart Generator 的决策轨迹以便调试。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '请至少选择一个调，才能使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非自然音';

  @override
  String get nonDiatonicRequiresKeyMode => '非自然音选项仅在调式模式中可用。';

  @override
  String get secondaryDominant => '副属和弦';

  @override
  String get substituteDominant => '替代属和弦';

  @override
  String get modalInterchange => '调式互换';

  @override
  String get modalInterchangeDisabledHelp => '调式互换只会出现在调式模式中，因此此选项在自由模式下会停用。';

  @override
  String get rendering => '显示';

  @override
  String get chordSymbolStyle => '和弦符号样式';

  @override
  String get chordSymbolStyleHelp => '只改变显示层。和声逻辑保持标准形式。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => '允许 V7sus4（V7, V7/x）';

  @override
  String get allowTensions => '允许张力音';

  @override
  String get tensionHelp => '仅使用罗马数字配置与所选芯片';

  @override
  String get inversions => '转位';

  @override
  String get enableInversions => '启用转位';

  @override
  String get inversionHelp => '选定和弦后会随机套用斜线低音表示法；不会跟踪前一个低音。';

  @override
  String get firstInversion => '第一转位';

  @override
  String get secondInversion => '第二转位';

  @override
  String get thirdInversion => '第三转位';

  @override
  String get keyPracticeOverview => '调式练习概览';

  @override
  String get freePracticeOverview => '自由练习概览';

  @override
  String get keyModeTag => '调式模式';

  @override
  String get freeModeTag => '自由模式';

  @override
  String get allKeysTag => '所有调';

  @override
  String get metronomeOnTag => '节拍器开';

  @override
  String get metronomeOffTag => '节拍器关';

  @override
  String get pressNextChordToBegin => '按下 Next Chord 开始';

  @override
  String get freeModeActive => '自由模式启用中';

  @override
  String get freePracticeDescription => '使用全部 12 个半音根音与随机和弦品质，进行广泛的读谱练习。';

  @override
  String get smartPracticeDescription =>
      '在所选调内遵循功能和声流动，同时加入自然的 Smart Generator 动作。';

  @override
  String get keyPracticeDescription => '使用所选调与已启用的罗马数字来生成自然音阶练习素材。';

  @override
  String get keyboardShortcutHelp =>
      'Space: 下一个和弦  Enter: 开始或停止自动播放  Up/Down: 调整 BPM';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => '开始自动播放';

  @override
  String get stopAutoplay => '停止自动播放';

  @override
  String get decreaseBpm => '降低 BPM';

  @override
  String get increaseBpm => '提高 BPM';

  @override
  String allowedRange(int min, int max) {
    return '允许范围: $min-$max';
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
  String get voicingTopNotePreference => '高音偏好';

  @override
  String get voicingTopNotePreferenceHelp =>
      '让建议倾向你选择的高音线。锁定的和声音型先优先，同一和弦重复时会尽量保持高音线稳定。';

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
  String get voicingSuggestionTopLineSubtitle => '先看高音线';

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
    return '目标高音：$note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '锁定高音线：$note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '重复高音线：$note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '最接近 $note 的高音线';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '没有能准确落在 $note 的高音线';
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
  String get voicingReasonTopLineTarget => '高音线目标';

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
