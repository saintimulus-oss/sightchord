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
  String get systemDefaultLanguage => '시스템 기본값';

  @override
  String get metronome => '메트로놈';

  @override
  String get enabled => '켜짐';

  @override
  String get disabled => '꺼짐';

  @override
  String get metronomeHelp => '연습 중 모든 박자에 클릭 소리를 들으려면 메트로놈을 켜세요.';

  @override
  String get metronomeSound => '메트로놈 소리';

  @override
  String get metronomeSoundClassic => '클래식';

  @override
  String get metronomeSoundClickB => '클릭 B';

  @override
  String get metronomeSoundClickC => '클릭 C';

  @override
  String get metronomeSoundClickD => '클릭 D';

  @override
  String get metronomeSoundClickE => '클릭 E';

  @override
  String get metronomeSoundClickF => '클릭 F';

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
  String get smartGeneratorHelp => '활성화된 비다이어토닉 옵션을 유지하면서 기능적 화성 진행을 우선합니다.';

  @override
  String get advancedSmartGenerator => '고급 Smart Generator';

  @override
  String get modulationIntensity => '전조 강도';

  @override
  String get modulationIntensityOff => '끔';

  @override
  String get modulationIntensityLow => '낮음';

  @override
  String get modulationIntensityMedium => '보통';

  @override
  String get modulationIntensityHigh => '높음';

  @override
  String get jazzPreset => '재즈 프리셋';

  @override
  String get jazzPresetStandardsCore => '스탠더드 코어';

  @override
  String get jazzPresetModulationStudy => '전조 스터디';

  @override
  String get jazzPresetAdvanced => '고급';

  @override
  String get sourceProfile => '소스 프로필';

  @override
  String get sourceProfileFakebookStandard => '페이크북 표준';

  @override
  String get sourceProfileRecordingInspired => '레코딩 영감';

  @override
  String get smartDiagnostics => 'Smart 진단';

  @override
  String get smartDiagnosticsHelp => '디버깅을 위해 Smart Generator 결정 추적을 기록합니다.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator를 사용하려면 최소 한 개의 키를 선택하세요.';

  @override
  String get nonDiatonic => '비다이어토닉';

  @override
  String get nonDiatonicRequiresKeyMode => '비다이어토닉 옵션은 키 모드에서만 사용할 수 있습니다.';

  @override
  String get secondaryDominant => '세컨더리 도미넌트';

  @override
  String get substituteDominant => '서브스티튜트 도미넌트';

  @override
  String get modalInterchange => '모달 인터체인지';

  @override
  String get modalInterchangeDisabledHelp =>
      '모달 인터체인지는 키 모드에서만 나타나므로 자유 모드에서는 비활성화됩니다.';

  @override
  String get rendering => '표기';

  @override
  String get keyCenterLabelStyle => '조성 표기 방식';

  @override
  String get keyCenterLabelStyleHelp =>
      '장조/단조를 글자로 표시할지, 클래식처럼 대소문자로 표시할지 선택합니다.';

  @override
  String get chordSymbolStyle => '코드 심볼 스타일';

  @override
  String get chordSymbolStyleHelp => '표시 방식만 바뀌며 화성 로직은 그대로 유지됩니다.';

  @override
  String get styleCompact => '간결형';

  @override
  String get styleMajText => 'Maj 표기';

  @override
  String get styleDeltaJazz => '델타 재즈';

  @override
  String get keyCenterLabelStyleModeText => 'C 장조: / C 단조:';

  @override
  String get keyCenterLabelStyleClassicalCase => 'C: / c:';

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
      '코드 선택 후 슬래시 베이스 표기를 무작위로 적용하며, 이전 베이스는 추적하지 않습니다.';

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
  String get pressNextChordToBegin => '시작하려면 Next Chord를 누르세요';

  @override
  String get freeModeActive => '자유 모드 활성';

  @override
  String get freePracticeDescription =>
      '12개 모든 반음 루트와 무작위 코드 퀄리티로 폭넓은 리딩 연습을 합니다.';

  @override
  String get smartPracticeDescription =>
      '선택한 키에서 화성 기능 흐름을 따르며 Smart Generator 진행을 더합니다.';

  @override
  String get keyPracticeDescription => '선택한 키와 활성화된 로마 숫자로 다이어토닉 연습 재료를 생성합니다.';

  @override
  String get keyboardShortcutHelp =>
      'Space: 다음 코드  Enter: 자동 재생 시작/중지  Up/Down: BPM 조절';

  @override
  String get nextChord => '다음 코드';

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
    return '허용 범위: $min-$max';
  }

  @override
  String get modeMajor => '장조';

  @override
  String get modeMinor => '단조';

  @override
  String analysisLabelWithCenter(Object center, Object roman) {
    return '$center: $roman';
  }

  @override
  String get voicingSuggestionsTitle => '보이싱 제안';

  @override
  String get voicingSuggestionsSubtitle => '현재 코드에 맞는 구체적인 음 선택을 확인하세요.';

  @override
  String get voicingSuggestionsEnabled => '보이싱 제안 사용';

  @override
  String get voicingSuggestionsHelp => '현재 코드에 대해 연주 가능한 보이싱 아이디어 3개를 보여줍니다.';

  @override
  String get voicingComplexity => '보이싱 복잡도';

  @override
  String get voicingComplexityHelp => '제안이 얼마나 다채로워질 수 있는지 조절합니다.';

  @override
  String get voicingComplexityBasic => '기본';

  @override
  String get voicingComplexityStandard => '표준';

  @override
  String get voicingComplexityModern => '모던';

  @override
  String get voicingTopNotePreference => '탑노트 선호';

  @override
  String get voicingTopNotePreferenceHelp =>
      '제안을 선택한 탑라인 쪽으로 유도합니다. 잠근 보이싱이 우선되며 같은 코드는 탑라인을 안정적으로 유지합니다.';

  @override
  String get voicingTopNotePreferenceAuto => '자동';

  @override
  String get allowRootlessVoicings => '루트리스 보이싱 허용';

  @override
  String get allowRootlessVoicingsHelp => '가이드톤이 분명할 때 루트를 생략한 제안을 허용합니다.';

  @override
  String get maxVoicingNotes => '최대 보이싱 음수';

  @override
  String get lookAheadDepth => '미리보기 깊이';

  @override
  String get lookAheadDepthHelp => '랭킹 계산 시 고려할 미래 코드 수입니다.';

  @override
  String get showVoicingReasons => '보이싱 이유 표시';

  @override
  String get showVoicingReasonsHelp => '각 제안 카드에 짧은 설명 칩을 표시합니다.';

  @override
  String get voicingSuggestionNatural => '가장 자연스러움';

  @override
  String get voicingSuggestionColorful => '가장 컬러풀함';

  @override
  String get voicingSuggestionEasy => '가장 쉬움';

  @override
  String get voicingSuggestionNaturalSubtitle => '보이스 리딩 우선';

  @override
  String get voicingSuggestionColorfulSubtitle => '컬러 톤을 강조';

  @override
  String get voicingSuggestionEasySubtitle => '컴팩트한 손 모양';

  @override
  String get voicingSuggestionNaturalConnectedSubtitle => '연결과 해결 우선';

  @override
  String get voicingSuggestionNaturalStableSubtitle => '같은 모양, 안정적인 컴핑';

  @override
  String get voicingSuggestionTopLineSubtitle => '탑라인 우선';

  @override
  String get voicingSuggestionColorfulAlteredSubtitle => '얼터드 텐션을 전면에';

  @override
  String get voicingSuggestionColorfulQuartalSubtitle => '모던한 4도 보이싱 컬러';

  @override
  String get voicingSuggestionColorfulTritoneSubtitle => '밝은 가이드톤의 트라이톤 서브 느낌';

  @override
  String get voicingSuggestionColorfulUpperStructureSubtitle =>
      '밝은 확장음을 가진 가이드톤';

  @override
  String get voicingSuggestionEasyAnchoredSubtitle => '핵심 음 중심, 더 작은 도약';

  @override
  String get voicingSuggestionEasyStableSubtitle => '반복하기 쉬운 손 모양';

  @override
  String get voicingTopNoteLabel => '탑';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return '목표 탑라인: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '잠금된 탑라인: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '반복된 탑라인: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '$note에 가장 가까운 탑라인';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '$note에 정확히 맞는 탑라인이 없습니다';
  }

  @override
  String get voicingFamilyShell => '셸';

  @override
  String get voicingFamilyRootlessA => '루트리스 A';

  @override
  String get voicingFamilyRootlessB => '루트리스 B';

  @override
  String get voicingFamilySpread => '스프레드';

  @override
  String get voicingFamilySus => '서스';

  @override
  String get voicingFamilyQuartal => '4도';

  @override
  String get voicingFamilyAltered => '얼터드';

  @override
  String get voicingFamilyUpperStructure => '어퍼 스트럭처';

  @override
  String get voicingLockSuggestion => '제안 잠그기';

  @override
  String get voicingUnlockSuggestion => '제안 잠금 해제';

  @override
  String get voicingSelected => '선택됨';

  @override
  String get voicingLocked => '잠김';

  @override
  String get voicingReasonEssentialCore => '핵심 음 포함';

  @override
  String get voicingReasonGuideToneAnchor => '3도/7도 앵커';

  @override
  String voicingReasonGuideResolution(int count) {
    return '가이드톤 해결 $count개';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '공통음 유지 $count개';
  }

  @override
  String get voicingReasonStableRepeat => '안정적인 반복';

  @override
  String get voicingReasonTopLineTarget => '탑라인 목표';

  @override
  String get voicingReasonLowMudAvoided => '저음역 탁함 회피';

  @override
  String get voicingReasonCompactReach => '편한 손 뻗기';

  @override
  String get voicingReasonBassAnchor => '베이스 앵커 유지';

  @override
  String get voicingReasonNextChordReady => '다음 코드 준비';

  @override
  String get voicingReasonAlteredColor => '얼터드 텐션';

  @override
  String get voicingReasonRootlessClarity => '가벼운 루트리스 형태';

  @override
  String get voicingReasonSusRelease => '서스 해결 준비';

  @override
  String get voicingReasonQuartalColor => '4도 컬러';

  @override
  String get voicingReasonUpperStructureColor => '어퍼 스트럭처 컬러';

  @override
  String get voicingReasonTritoneSubFlavor => '트라이톤 서브 느낌';

  @override
  String get voicingReasonLockedContinuity => '잠금된 연속성';

  @override
  String get voicingReasonGentleMotion => '부드러운 손 이동';
}
