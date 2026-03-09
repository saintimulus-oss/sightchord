// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '设置';

  @override
  String get closeSettings => '关闭设置';

  @override
  String get language => '语言';

  @override
  String get metronome => '节拍器';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get metronomeHelp => '打开节拍器后，练习时每一拍都会听到点击声。';

  @override
  String get metronomeVolume => '节拍器音量';

  @override
  String get keys => '调';

  @override
  String get noKeysSelected => '未选择任何调。保持全部关闭即可在自由模式下练习所有根音。';

  @override
  String get keysSelectedHelp => '所选调会用于有调性感知的随机模式和 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '优先采用功能和声走向，同时保留已启用的非自然和声选项。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '请至少选择一个调，才能使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非自然和声';

  @override
  String get nonDiatonicRequiresKeyMode => '非自然和声选项仅在调式模式下可用。';

  @override
  String get secondaryDominant => '副属和弦';

  @override
  String get substituteDominant => '替代属和弦';

  @override
  String get modalInterchange => '调式借用';

  @override
  String get modalInterchangeDisabledHelp => '调式借用只会在调式模式中出现，因此在自由模式下此选项会被禁用。';

  @override
  String get rendering => '显示';

  @override
  String get chordSymbolStyle => '和弦符号样式';

  @override
  String get chordSymbolStyleHelp => '只改变显示层，不会影响内部和声逻辑。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => '允许 V7sus4（仅 V7、V7/x）';

  @override
  String get allowTensions => '允许张力音';

  @override
  String get tensionHelp => '仅使用罗马数字配置和已选标签';

  @override
  String get inversions => '转位';

  @override
  String get enableInversions => '启用转位';

  @override
  String get inversionHelp => '在和弦确定后随机应用斜杠低音显示，不跟踪前一个低音进行。';

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
  String get allKeysTag => '全部调';

  @override
  String get metronomeOnTag => '节拍器开';

  @override
  String get metronomeOffTag => '节拍器关';

  @override
  String get pressNextChordToBegin => '按 Next Chord 开始';

  @override
  String get freeModeActive => '自由模式已启用';

  @override
  String get freePracticeDescription => '使用全部 12 个半音根音和随机和弦性质，进行更广泛的视奏练习。';

  @override
  String get smartPracticeDescription => '在所选调内遵循功能和声流动，同时允许自然、克制的智能生成走向。';

  @override
  String get keyPracticeDescription => '使用所选调和已启用的罗马数字生成自然音阶内练习素材。';

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
    return '允许范围：$min–$max';
  }
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
  String get metronome => '节拍器';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get metronomeHelp => '打开节拍器后，练习时每一拍都会听到点击声。';

  @override
  String get metronomeVolume => '节拍器音量';

  @override
  String get keys => '调';

  @override
  String get noKeysSelected => '未选择任何调。保持全部关闭即可在自由模式下练习所有根音。';

  @override
  String get keysSelectedHelp => '所选调会用于有调性感知的随机模式和 Smart Generator 模式。';

  @override
  String get smartGeneratorMode => 'Smart Generator 模式';

  @override
  String get smartGeneratorHelp => '优先采用功能和声走向，同时保留已启用的非自然和声选项。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      '请至少选择一个调，才能使用 Smart Generator 模式。';

  @override
  String get nonDiatonic => '非自然和声';

  @override
  String get nonDiatonicRequiresKeyMode => '非自然和声选项仅在调式模式下可用。';

  @override
  String get secondaryDominant => '副属和弦';

  @override
  String get substituteDominant => '替代属和弦';

  @override
  String get modalInterchange => '调式借用';

  @override
  String get modalInterchangeDisabledHelp => '调式借用只会在调式模式中出现，因此在自由模式下此选项会被禁用。';

  @override
  String get rendering => '显示';

  @override
  String get chordSymbolStyle => '和弦符号样式';

  @override
  String get chordSymbolStyleHelp => '只改变显示层，不会影响内部和声逻辑。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => '允许 V7sus4（仅 V7、V7/x）';

  @override
  String get allowTensions => '允许张力音';

  @override
  String get tensionHelp => '仅使用罗马数字配置和已选标签';

  @override
  String get inversions => '转位';

  @override
  String get enableInversions => '启用转位';

  @override
  String get inversionHelp => '在和弦确定后随机应用斜杠低音显示，不跟踪前一个低音进行。';

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
  String get allKeysTag => '全部调';

  @override
  String get metronomeOnTag => '节拍器开';

  @override
  String get metronomeOffTag => '节拍器关';

  @override
  String get pressNextChordToBegin => '按 Next Chord 开始';

  @override
  String get freeModeActive => '自由模式已启用';

  @override
  String get freePracticeDescription => '使用全部 12 个半音根音和随机和弦性质，进行更广泛的视奏练习。';

  @override
  String get smartPracticeDescription => '在所选调内遵循功能和声流动，同时允许自然、克制的智能生成走向。';

  @override
  String get keyPracticeDescription => '使用所选调和已启用的罗马数字生成自然音阶内练习素材。';

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
    return '允许范围：$min–$max';
  }
}
