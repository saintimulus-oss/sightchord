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
  String get metronome => 'メトロノーム';

  @override
  String get enabled => 'オン';

  @override
  String get disabled => 'オフ';

  @override
  String get metronomeHelp => 'メトロノームを有効にすると、練習中の各拍でクリックが鳴ります。';

  @override
  String get metronomeVolume => 'メトロノーム音量';

  @override
  String get keys => 'キー';

  @override
  String get noKeysSelected =>
      'キーが選択されていません。すべてオフのままにすると、全ルートを使うフリーモードで練習できます。';

  @override
  String get keysSelectedHelp =>
      '選択したキーは、キー対応ランダムモードと Smart Generator モードで使われます。';

  @override
  String get smartGeneratorMode => 'Smart Generator モード';

  @override
  String get smartGeneratorHelp => '有効なノンダイアトニック設定を保ちながら、機能和声の流れを優先します。';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator モードを使うには、少なくとも 1 つキーを選択してください。';

  @override
  String get nonDiatonic => 'ノンダイアトニック';

  @override
  String get nonDiatonicRequiresKeyMode => 'ノンダイアトニック設定はキーモードでのみ利用できます。';

  @override
  String get secondaryDominant => 'セカンダリー・ドミナント';

  @override
  String get substituteDominant => 'サブスティテュート・ドミナント';

  @override
  String get modalInterchange => 'モーダル・インターチェンジ';

  @override
  String get modalInterchangeDisabledHelp =>
      'モーダル・インターチェンジはキーモードでのみ登場するため、フリーモードでは無効になります。';

  @override
  String get rendering => '表示';

  @override
  String get chordSymbolStyle => 'コード表記スタイル';

  @override
  String get chordSymbolStyleHelp => '表示だけを変更します。内部の和声ロジックは変わりません。';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => 'V7sus4 を許可';

  @override
  String get allowTensions => 'テンションを許可';

  @override
  String get tensionHelp => 'ローマ数字プロファイルと選択中のチップのみ';

  @override
  String get inversions => '転回形';

  @override
  String get enableInversions => '転回形を有効化';

  @override
  String get inversionHelp => 'コード決定後にスラッシュベース表記を適用します。';

  @override
  String get firstInversion => '第1転回形';

  @override
  String get secondInversion => '第2転回形';

  @override
  String get thirdInversion => '第3転回形';

  @override
  String get keyPracticeOverview => 'キープラクティス概要';

  @override
  String get freePracticeOverview => 'フリープラクティス概要';

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
  String get freeModeActive => 'フリーモード実行中';

  @override
  String get freePracticeDescription =>
      '12 の半音ルートとランダムなコードクオリティを使い、幅広い初見練習を行います。';

  @override
  String get smartPracticeDescription =>
      '選択したキー内で機能和声の流れに沿いながら、自然な Smart Generator の動きを加えます。';

  @override
  String get keyPracticeDescription =>
      '選択したキーと有効なローマ数字を使って、ダイアトニックな練習素材を生成します。';

  @override
  String get keyboardShortcutHelp =>
      'Space: 次のコード  Enter: オートプレイ開始/停止  Up/Down: BPM 調整';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => 'オートプレイ開始';

  @override
  String get stopAutoplay => 'オートプレイ停止';

  @override
  String get decreaseBpm => 'BPM を下げる';

  @override
  String get increaseBpm => 'BPM を上げる';

  @override
  String allowedRange(int min, int max) {
    return '許容範囲: $min–$max';
  }
}
