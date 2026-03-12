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
      '선택한 키는 키 인식 랜덤 모드와 Smart Generator 모드에서 사용됩니다.';

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
      'Smart Generator 모드를 사용하려면 키를 하나 이상 선택하세요.';

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
      '모달 인터체인지는 키 모드에서만 나타나므로 자유 모드에서는 이 옵션이 비활성화됩니다.';

  @override
  String get rendering => '표기';

  @override
  String get keyCenterLabelStyle => '조성 표기 방식';

  @override
  String get keyCenterLabelStyleHelp =>
      '모드 이름을 직접 표시하는 방식과 전통적인 장·단조 대소문자 으뜸음 표기 중에서 선택하세요.';

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
      '코드를 고른 뒤 슬래시 베이스 표기를 무작위로 적용합니다. 이전 베이스 라인은 추적하지 않습니다.';

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
  String get pressNextChordToBegin => '시작하려면 다음 코드를 누르세요';

  @override
  String get freeModeActive => '자유 모드 활성';

  @override
  String get freePracticeDescription =>
      '12개의 모든 반음계 루트에서 무작위 코드 성질을 사용해 폭넓은 리딩 연습을 합니다.';

  @override
  String get smartPracticeDescription =>
      '선택한 키 안에서 화성 기능의 흐름을 따르면서도 자연스러운 Smart Generator 진행을 허용합니다.';

  @override
  String get keyPracticeDescription => '선택한 키와 활성화된 로마 숫자로 다이어토닉 연습 재료를 생성합니다.';

  @override
  String get keyboardShortcutHelp =>
      'Space: 다음 코드  Enter: 자동 재생 시작/정지  위/아래: BPM 조절';

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
  String get bpmLabel => 'BPM';

  @override
  String bpmTag(int value) {
    return '$value BPM';
  }

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
      '제안이 선택한 탑라인 쪽으로 기울어집니다. 잠근 보이싱이 가장 우선하고, 그다음에는 반복되는 코드에서 안정적으로 유지됩니다.';

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
      '밝은 익스텐션을 더한 가이드톤 중심';

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
    return '\$note에 가장 가까운 탑라인';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '\$note에 정확히 맞는 탑라인이 없습니다';
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
    return '가이드톤 해결 \$count개';
  }

  @override
  String voicingReasonCommonToneRetention(int count) {
    return '공통음 유지 \$count개';
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

  @override
  String get mainMenuIntro => '연습 생성기를 선택하거나, 별도의 진행 읽기 흐름을 위해 분석기를 열어 보세요.';

  @override
  String get mainMenuGeneratorTitle => '코드 생성기';

  @override
  String get mainMenuGeneratorDescription =>
      '키 인식 랜덤 모드, 스마트 진행, 보이싱 제안으로 연습용 코드를 생성합니다.';

  @override
  String get mainMenuAnalyzerTitle => '코드 분석기';

  @override
  String get mainMenuAnalyzerDescription =>
      '작성한 진행을 분석해 유력한 키 센터, 로마 숫자, 화성 기능을 보여줍니다.';

  @override
  String get openGenerator => '생성기 열기';

  @override
  String get openAnalyzer => '분석기 열기';

  @override
  String get chordAnalyzerTitle => '코드 분석기';

  @override
  String get chordAnalyzerSubtitle => '진행을 붙여 넣으면 보수적인 화성 해석 결과를 보여줍니다.';

  @override
  String get chordAnalyzerInputLabel => '코드 진행';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '공백, |, 쉼표를 사용할 수 있습니다. 슬래시 코드와 간단한 변형도 지원합니다. 터치 기기에서는 코드 패드를 쓰거나 ABC 입력으로 전환할 수 있습니다.';

  @override
  String get chordAnalyzerAnalyze => '분석';

  @override
  String get chordAnalyzerKeyboardTitle => '코드 패드';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '토큰을 눌러 진행을 구성하세요. 자유 입력이 필요할 때는 ABC 입력으로 전환하면 시스템 키보드를 계속 사용할 수 있습니다.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      '입력하거나 붙여 넣거나 토큰을 눌러 커서 위치에 삽입하세요.';

  @override
  String get chordAnalyzerChordPad => '패드';

  @override
  String get chordAnalyzerRawInput => 'ABC';

  @override
  String get chordAnalyzerPaste => '붙여넣기';

  @override
  String get chordAnalyzerClear => '지우기';

  @override
  String get chordAnalyzerBackspace => '백스페이스';

  @override
  String get chordAnalyzerSpace => '공백';

  @override
  String get chordAnalyzerAnalyzing => '진행을 분석하는 중...';

  @override
  String get chordAnalyzerInitialTitle => '진행부터 입력해 보세요';

  @override
  String get chordAnalyzerInitialBody =>
      'Dm7 G7 Cmaj7 또는 Cmaj7 | Am7 D7 | Gmaj7 같은 진행을 입력하면, 가능한 키와 로마 숫자, 짧은 요약을 볼 수 있습니다.';

  @override
  String get chordAnalyzerDetectedKeys => '감지된 키';

  @override
  String get chordAnalyzerPrimaryReading => '기본 해석';

  @override
  String get chordAnalyzerAlternativeReading => '대안 해석';

  @override
  String get chordAnalyzerChordAnalysis => '코드별 분석';

  @override
  String chordAnalyzerMeasureLabel(Object index) {
    return '$index마디';
  }

  @override
  String get chordAnalyzerProgressionSummary => '진행 요약';

  @override
  String get chordAnalyzerWarnings => '경고 및 모호한 지점';

  @override
  String get chordAnalyzerNoInputError => '분석할 코드 진행을 입력하세요.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      '진행에서 인식 가능한 코드를 찾지 못했습니다.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '일부 기호를 건너뛰었습니다: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '키 센터가 $primary와 $alternative 사이에서 아직 다소 모호합니다.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      '이 MVP 해석에서는 일부 코드가 여전히 모호하게 남아 있습니다.';

  @override
  String get chordAnalyzerFunctionTonic => '토닉';

  @override
  String get chordAnalyzerFunctionPredominant => '프리도미넌트';

  @override
  String get chordAnalyzerFunctionDominant => '도미넌트';

  @override
  String get chordAnalyzerFunctionOther => '기타';

  @override
  String chordAnalyzerRemarkSecondaryDominant(Object target) {
    return '$target을 향하는 세컨더리 도미넌트일 가능성이 있습니다.';
  }

  @override
  String chordAnalyzerRemarkTritoneSub(Object target) {
    return '$target을 향하는 트라이톤 서브스티튜트일 가능성이 있습니다.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      '병행 단조에서 빌려온 모달 인터체인지일 가능성이 있습니다.';

  @override
  String get chordAnalyzerRemarkAmbiguous => '현재 해석에서는 이 코드가 여전히 모호합니다.';

  @override
  String get chordAnalyzerRemarkUnresolved => '이 코드는 현재 MVP 휴리스틱 범위 밖에 있습니다.';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 진행';

  @override
  String get chordAnalyzerTagTurnaround => '턴어라운드';

  @override
  String get chordAnalyzerTagDominantResolution => '도미넌트 해결';

  @override
  String get chordAnalyzerTagPlagalColor => '플라갈/모달 컬러';

  @override
  String chordAnalyzerSummaryCenter(Object key) {
    return '이 진행의 중심 조성은 $key일 가능성이 가장 높습니다.';
  }

  @override
  String chordAnalyzerSummaryAlternative(Object key) {
    return '대안 해석으로는 $key도 가능합니다.';
  }

  @override
  String chordAnalyzerSummaryTag(Object tag) {
    return '이 진행은 $tag 성격을 보여줍니다.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from와 $through는 $target으로 향하는 $fromFunction, $throughFunction 기능으로 해석할 수 있습니다.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord는 $target을 향하는 세컨더리 도미넌트로 들릴 수 있습니다.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord는 $target을 향하는 트라이톤 서브스티튜트로 들릴 수 있습니다.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord는 모달 인터체인지 색채를 더해 줍니다.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      '일부 세부 요소는 여전히 모호하므로, 해석은 의도적으로 보수적으로 유지됩니다.';

  @override
  String get chordAnalyzerExamplesTitle => '예시';

  @override
  String get chordAnalyzerConfidenceLabel => '신뢰도';

  @override
  String get chordAnalyzerAmbiguityLabel => '모호성';

  @override
  String get chordAnalyzerWhyThisReading => '이렇게 해석한 이유';

  @override
  String get chordAnalyzerCompetingReadings => '함께 고려할 해석';

  @override
  String chordAnalyzerIgnoredModifiersWarning(Object details) {
    return '무시된 수식: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '입력 경고: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '괄호가 맞지 않아 기호 일부를 확실히 해석하지 못했습니다.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '예상치 못한 닫는 괄호를 무시했습니다.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '$extension 컬러가 이 해석을 더 강하게 뒷받침합니다.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      '얼터드 도미넌트 컬러가 도미넌트 기능을 뒷받침합니다.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '슬래시 베이스 $bass가 베이스 라인이나 전위의 의미를 살려 줍니다.';
  }

  @override
  String chordAnalyzerEvidenceResolution(Object target) {
    return '다음 코드가 $target으로의 해결을 뒷받침합니다.';
  }

  @override
  String get chordAnalyzerEvidenceBorrowedColor =>
      '이 색채는 병행 조성에서 빌려온 것으로 들릴 수 있습니다.';

  @override
  String get chordAnalyzerEvidenceSuspensionColor =>
      '서스펜션 컬러가 도미넌트의 긴장을 완전히 지우지 않으면서도 부드럽게 만듭니다.';
}
