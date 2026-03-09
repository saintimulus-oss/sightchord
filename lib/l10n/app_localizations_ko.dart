// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get settings => '설정';

  @override
  String get closeSettings => '설정 닫기';

  @override
  String get language => '언어';

  @override
  String get metronome => '메트로놈';

  @override
  String get enabled => '켜짐';

  @override
  String get disabled => '꺼짐';

  @override
  String get metronomeHelp => '메트로놈을 켜면 연습 중 매 박마다 클릭 소리가 납니다.';

  @override
  String get metronomeVolume => '메트로놈 볼륨';

  @override
  String get keys => '키';

  @override
  String get noKeysSelected => '선택된 키가 없습니다. 모두 끄면 모든 루트에서 자유 모드로 연습합니다.';

  @override
  String get keysSelectedHelp =>
      '선택한 키는 키 기반 랜덤 모드와 Smart Generator 모드에 사용됩니다.';

  @override
  String get smartGeneratorMode => 'Smart Generator 모드';

  @override
  String get smartGeneratorHelp => '활성화된 비다이아토닉 옵션을 유지하면서 기능적 화성 진행을 우선합니다.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator 모드를 쓰려면 최소 한 개의 키를 선택하세요.';

  @override
  String get nonDiatonic => '비다이아토닉';

  @override
  String get nonDiatonicRequiresKeyMode => '비다이아토닉 옵션은 키 모드에서만 사용할 수 있습니다.';

  @override
  String get secondaryDominant => '세컨더리 도미넌트';

  @override
  String get substituteDominant => '서브스티튜트 도미넌트';

  @override
  String get modalInterchange => '모달 인터체인지';

  @override
  String get modalInterchangeDisabledHelp =>
      '모달 인터체인지는 키 모드에서만 나오므로 자유 모드에서는 비활성화됩니다.';

  @override
  String get rendering => '표기';

  @override
  String get chordSymbolStyle => '코드 심벌 표기 스타일';

  @override
  String get chordSymbolStyleHelp => '표시 레이어만 바뀌며 내부 화성 로직은 그대로 유지됩니다.';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleMajText => 'MajText';

  @override
  String get styleDeltaJazz => 'DeltaJazz';

  @override
  String get allowV7sus4 => 'V7sus4 허용 (V7, V7/x)';

  @override
  String get allowTensions => '텐션 허용';

  @override
  String get tensionHelp => '로마 숫자 프로필과 선택한 칩만 사용';

  @override
  String get inversions => '전위';

  @override
  String get enableInversions => '전위 사용';

  @override
  String get inversionHelp =>
      '코드가 결정된 뒤 임의 슬래시 베이스 표기로 적용하며, 이전 베이스 진행은 추적하지 않습니다.';

  @override
  String get firstInversion => '1전위';

  @override
  String get secondInversion => '2전위';

  @override
  String get thirdInversion => '3전위';

  @override
  String get keyPracticeOverview => '키 연습 개요';

  @override
  String get freePracticeOverview => '자유 연습 개요';

  @override
  String get keyModeTag => '키 모드';

  @override
  String get freeModeTag => '자유 모드';

  @override
  String get allKeysTag => '전체 키';

  @override
  String get metronomeOnTag => '메트로놈 켜짐';

  @override
  String get metronomeOffTag => '메트로놈 꺼짐';

  @override
  String get pressNextChordToBegin => 'Next Chord를 눌러 시작';

  @override
  String get freeModeActive => '자유 모드 활성';

  @override
  String get freePracticeDescription =>
      '12개의 반음 루트와 랜덤 코드 퀄리티를 사용해 폭넓은 리딩 연습을 합니다.';

  @override
  String get smartPracticeDescription =>
      '선택한 키 안에서 기능 화성 흐름을 따르면서 자연스러운 Smart Generator 진행을 허용합니다.';

  @override
  String get keyPracticeDescription =>
      '선택한 키와 활성화된 로마 숫자를 사용해 다이아토닉 연습 재료를 생성합니다.';

  @override
  String get keyboardShortcutHelp =>
      'Space: 다음 코드  Enter: 자동 재생 시작/정지  Up/Down: BPM 조절';

  @override
  String get nextChord => 'Next Chord';

  @override
  String get startAutoplay => '자동 재생 시작';

  @override
  String get stopAutoplay => '자동 재생 중지';

  @override
  String get decreaseBpm => 'BPM 낮추기';

  @override
  String get increaseBpm => 'BPM 높이기';

  @override
  String allowedRange(int min, int max) {
    return '허용 범위: $min–$max';
  }
}
