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
  String get openGenerator => '생성기 열기';

  @override
  String get openAnalyzer => '분석기 열기';

  @override
  String get mainMenuAnalyzerTitle => '코드 분석기';

  @override
  String get mainMenuAnalyzerDescription =>
      '입력한 코드 진행에서 가능한 조성, 로마 숫자, 화성 기능을 보수적으로 분석합니다.';

  @override
  String get mainMenuStudyHarmonyTitle => 'Study Harmony';

  @override
  String get mainMenuStudyHarmonyDescription =>
      '계속하기, 복습, 데일리, 챕터 수업이 있는 실제 화성 학습 허브로 이동합니다.';

  @override
  String get openStudyHarmony => 'Study Harmony 열기';

  @override
  String get studyHarmonyTitle => 'Study Harmony';

  @override
  String get studyHarmonySubtitle =>
      '빠른 수업 진입과 챕터 진행도를 갖춘 구조화된 화성 학습 허브를 진행해 보세요.';

  @override
  String get studyHarmonyPlaceholderTag => '학습 덱';

  @override
  String get studyHarmonyPlaceholderBody =>
      '레슨 데이터, 문제 표현, 정답 입력 표면을 하나의 학습 흐름으로 묶어 두어 음, 코드, 스케일, 진행 과제를 같은 방식으로 확장할 수 있습니다.';

  @override
  String get studyHarmonyTestLevelTag => '연습 드릴';

  @override
  String get studyHarmonyTestLevelAction => '드릴 열기';

  @override
  String get studyHarmonySubmit => '제출';

  @override
  String get studyHarmonyNextPrompt => '다음 문제';

  @override
  String get studyHarmonySelectedAnswers => '선택한 답';

  @override
  String get studyHarmonySelectionEmpty => '아직 선택한 답이 없습니다.';

  @override
  String studyHarmonyClearProgress(int current, int total) {
    return '$current/$total 정답';
  }

  @override
  String get studyHarmonyAttempts => '시도';

  @override
  String get studyHarmonyAccuracy => '정답률';

  @override
  String get studyHarmonyElapsedTime => '시간';

  @override
  String get studyHarmonyObjective => '목표';

  @override
  String get studyHarmonyPromptInstruction => '맞는 답을 고르세요';

  @override
  String get studyHarmonyNeedSelection => '제출하기 전에 답을 하나 이상 선택하세요.';

  @override
  String get studyHarmonyCorrectLabel => '정답';

  @override
  String get studyHarmonyIncorrectLabel => '오답';

  @override
  String studyHarmonyCorrectFeedback(Object answer) {
    return '정답입니다. $answer가 맞았습니다.';
  }

  @override
  String studyHarmonyIncorrectFeedback(Object answer) {
    return '오답입니다. 정답은 $answer이며 라이프가 1개 줄었습니다.';
  }

  @override
  String get studyHarmonyGameOverTitle => '게임 오버';

  @override
  String get studyHarmonyGameOverBody =>
      '라이프 3개를 모두 잃었습니다. 이 레벨을 다시 하거나 Study Harmony 허브로 돌아가세요.';

  @override
  String get studyHarmonyLevelCompleteTitle => '레벨 클리어';

  @override
  String get studyHarmonyLevelCompleteBody =>
      '레슨 목표를 달성했습니다. 아래에서 정답률과 클리어 시간을 확인하세요.';

  @override
  String get studyHarmonyBackToHub => 'Study Harmony로 돌아가기';

  @override
  String get studyHarmonyRetry => '다시 하기';

  @override
  String get studyHarmonyHubHeroEyebrow => '학습 허브';

  @override
  String get studyHarmonyHubHeroBody =>
      '계속하기로 흐름을 이어가고, 복습으로 약한 지점을 다시 보고, 데일리로 현재 열린 경로에서 오늘의 고정 수업 하나를 바로 시작하세요.';

  @override
  String get studyHarmonyTrackFilterLabel => '트랙';

  @override
  String get studyHarmonyTrackCoreFilterLabel => 'Core';

  @override
  String get studyHarmonyTrackPopFilterLabel => 'Pop';

  @override
  String get studyHarmonyTrackJazzFilterLabel => 'Jazz';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => 'Classical';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total 수업 완료';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total 챕터 완료';
  }

  @override
  String get studyHarmonyContinueCardTitle => '계속하기';

  @override
  String get studyHarmonyContinueResumeHint => '가장 최근에 건드린 수업부터 이어서 시작합니다.';

  @override
  String get studyHarmonyContinueFrontierHint => '현재 진행선에서 다음 수업으로 바로 이동합니다.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return '$lessonTitle 이어하기';
  }

  @override
  String get studyHarmonyContinueAction => '계속하기';

  @override
  String get studyHarmonyReviewCardTitle => '복습하기';

  @override
  String get studyHarmonyReviewQueueHint =>
      '현재 review queue placeholder 기준으로 가져왔습니다.';

  @override
  String get studyHarmonyReviewWeakHint => '플레이한 수업 중 가장 약한 결과를 기준으로 골랐습니다.';

  @override
  String get studyHarmonyReviewFallbackHint => '아직 복습 부채가 없어 현재 진행선으로 되돌아갑니다.';

  @override
  String get studyHarmonyReviewRetryNeededHint =>
      '오답이나 미완료 기록이 있어 한 번 더 볼 필요가 있습니다.';

  @override
  String get studyHarmonyReviewAccuracyRefreshHint =>
      '정답률을 다시 다듬기 위한 빠른 복습 대상으로 잡혔습니다.';

  @override
  String get studyHarmonyReviewAction => '복습하기';

  @override
  String get studyHarmonyDailyCardTitle => '데일리 챌린지';

  @override
  String get studyHarmonyDailyCardHint => '현재 열린 경로에서 오늘의 고정 수업을 엽니다.';

  @override
  String get studyHarmonyDailyAction => '데일리 시작';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return '시드 $dateKey';
  }

  @override
  String get studyHarmonyReviewSessionTitle => '약점 복습';

  @override
  String studyHarmonyReviewSessionDescription(Object chapterTitle) {
    return '$chapterTitle 주변의 약한 기술을 짧게 섞어 복습합니다.';
  }

  @override
  String get studyHarmonyDailySessionTitle => '데일리 챌린지';

  @override
  String studyHarmonyDailySessionDescription(Object chapterTitle) {
    return '$chapterTitle와 현재 진행 구간을 바탕으로 오늘의 고정 믹스를 플레이합니다.';
  }

  @override
  String get studyHarmonyModeLesson => '레슨 모드';

  @override
  String get studyHarmonyModeReview => '복습 모드';

  @override
  String get studyHarmonyModeDaily => '데일리 모드';

  @override
  String get studyHarmonyModeLegacy => '연습 모드';

  @override
  String get studyHarmonyShortcutHint =>
      'Enter: 제출/다음 · R: 다시 시작 · 1-9: 보기 선택 · Tab/Shift+Tab: 포커스 이동';

  @override
  String studyHarmonyLivesRemaining(int remaining, int total) {
    return '라이프 $total개 중 $remaining개 남음';
  }

  @override
  String get studyHarmonyResultSkillGainTitle => '스킬 변화';

  @override
  String get studyHarmonyResultReviewFocusTitle => '복습 포인트';

  @override
  String studyHarmonyResultSkillGainLine(Object skill, Object delta) {
    return '$skill $delta';
  }

  @override
  String get studyHarmonyReviewReasonRetryNeeded => '복습 이유: 다시 시도 필요';

  @override
  String get studyHarmonyReviewReasonAccuracyRefresh => '복습 이유: 정답률 다듬기';

  @override
  String get studyHarmonyReviewReasonLowMastery => '복습 이유: mastery 낮음';

  @override
  String get studyHarmonyReviewReasonStaleSkill => '복습 이유: 오래 안 본 스킬';

  @override
  String get studyHarmonyReviewReasonWeakSpot => '복습 이유: 약점 보강';

  @override
  String get studyHarmonyReviewReasonFrontierRefresh => '복습 이유: 현재 진행선 정리';

  @override
  String get studyHarmonySkillNoteRead => '음이름 읽기';

  @override
  String get studyHarmonySkillNoteFindKeyboard => '건반에서 음 찾기';

  @override
  String get studyHarmonySkillNoteAccidentals => '샵과 플랫';

  @override
  String get studyHarmonySkillChordSymbolToKeys => '코드명에서 건반 찾기';

  @override
  String get studyHarmonySkillChordNameFromTones => '구성음으로 코드명 찾기';

  @override
  String get studyHarmonySkillScaleBuild => '스케일 구성';

  @override
  String get studyHarmonySkillRomanRealize => '로마숫자에서 코드 만들기';

  @override
  String get studyHarmonySkillRomanIdentify => '코드의 로마숫자 찾기';

  @override
  String get studyHarmonySkillHarmonyDiatonicity => '다이아토닉 판별';

  @override
  String get studyHarmonySkillHarmonyFunction => '기능 분류 기초';

  @override
  String get studyHarmonySkillProgressionKeyCenter => '진행의 조성 찾기';

  @override
  String get studyHarmonySkillProgressionFunction => '진행 안에서 기능 읽기';

  @override
  String get studyHarmonySkillProgressionNonDiatonic => '비다이아토닉 코드 찾기';

  @override
  String get studyHarmonySkillProgressionFillBlank => '진행 빈칸 채우기';

  @override
  String get studyHarmonyHubChapterSectionTitle => '챕터';

  @override
  String studyHarmonyChapterProgressText(int cleared, int total) {
    return '$cleared/$total 수업 완료';
  }

  @override
  String studyHarmonyLessonsCount(int count) {
    return '$count개 수업';
  }

  @override
  String studyHarmonyCompletedLessonsCount(int count) {
    return '$count개 완료';
  }

  @override
  String get studyHarmonyOpenChapterAction => '챕터 열기';

  @override
  String get studyHarmonyLockedChapterTag => '잠김';

  @override
  String studyHarmonyChapterNextUp(Object lessonTitle) {
    return '다음: $lessonTitle';
  }

  @override
  String studyHarmonyChapterViewTitle(Object chapterTitle) {
    return '$chapterTitle';
  }

  @override
  String studyHarmonyTrackPlaceholderBody(Object coreTrack) {
    return '지금은 $coreTrack 트랙이 활성 경로입니다. 다른 트랙은 이후 허브를 다시 뜯어고치지 않고 확장할 수 있도록 자리만 먼저 보여 줍니다.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => 'Core Track';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '음과 건반에서 시작해 코드, 스케일, 로마숫자, 다이아토닉 기초를 거쳐 짧은 코드 진행 분석까지 올라가는 기본 경로입니다.';

  @override
  String get studyHarmonyChapterNotesTitle => 'Chapter 1: Notes & Keyboard';

  @override
  String get studyHarmonyChapterNotesDescription =>
      'Map note names to the keyboard and get comfortable with white keys and simple accidentals.';

  @override
  String get studyHarmonyChapterChordsTitle => 'Chapter 2: Chord Basics';

  @override
  String get studyHarmonyChapterChordsDescription =>
      'Spell basic triads and sevenths, then name common chord shapes from their tones.';

  @override
  String get studyHarmonyChapterScalesTitle => 'Chapter 3: Scales & Keys';

  @override
  String get studyHarmonyChapterScalesDescription =>
      'Build major and minor scales, then spot which tones belong inside a key.';

  @override
  String get studyHarmonyChapterRomanTitle =>
      'Chapter 4: Roman Numerals & Diatonicity';

  @override
  String get studyHarmonyChapterRomanDescription =>
      'Turn simple Roman numerals into chords, identify them from chords, and sort diatonic basics by function.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle =>
      'Chapter 5: Progression Detective I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '짧은 기본 진행을 보고 조성을 맞히고, 기능을 읽고, 어울리지 않는 코드를 찾아봅니다.';

  @override
  String get studyHarmonyChapterMissingChordTitle =>
      'Chapter 6: Missing Chord I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      '짧은 진행의 빈칸 하나를 채우면서 기능과 종지의 흐름을 읽는 감각을 익힙니다.';

  @override
  String get studyHarmonyOpenLessonAction => 'Open lesson';

  @override
  String get studyHarmonyLockedLessonAction => 'Locked';

  @override
  String get studyHarmonyClearedTag => 'Cleared';

  @override
  String get studyHarmonyComingSoonTag => 'Coming soon';

  @override
  String get studyHarmonyPopTrackTitle => 'Pop Track';

  @override
  String get studyHarmonyPopTrackDescription =>
      'A song-focused path is planned after the Core track is stable.';

  @override
  String get studyHarmonyJazzTrackTitle => 'Jazz Track';

  @override
  String get studyHarmonyJazzTrackDescription =>
      'Jazz harmony content stays locked until the Core curriculum settles.';

  @override
  String get studyHarmonyClassicalTrackTitle => 'Classical Track';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      'Functional harmony in classical contexts will arrive in a later phase.';

  @override
  String get studyHarmonyObjectiveQuickDrill => 'Quick Drill';

  @override
  String get studyHarmonyObjectiveBossReview => 'Boss Review';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => 'White-Key Note Hunt';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      'Read note names and tap the matching white key.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => 'Name the Highlighted Note';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      'Look at a highlighted key and choose the correct note name.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => 'Black Keys and Twins';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      'Get a first look at sharp and flat spellings for the black keys.';

  @override
  String get studyHarmonyLessonNotesBossTitle => 'Boss: Fast Note Hunt';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      'Mix note reading and keyboard finding into one short speed round.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => 'Triads on the Keyboard';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      'Build common major, minor, and diminished triads directly on the keyboard.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle =>
      'Sevenths on the Keyboard';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      'Add the seventh and spell a few common 7th chords on the keyboard.';

  @override
  String get studyHarmonyLessonChordNameTitle => 'Name the Highlighted Chord';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      'Read a highlighted chord shape and choose the correct chord name.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Boss: Triads and Sevenths Review';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      'Switch between chord spelling and chord naming in one mixed review.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => 'Build Major Scales';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      'Choose every tone that belongs to a simple major scale.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => 'Build Minor Scales';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      'Build natural minor and harmonic minor scales from a few common keys.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => 'Key Membership';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      'Find which tones belong inside a named key.';

  @override
  String get studyHarmonyLessonScalesBossTitle => 'Boss: Scale Repair';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      'Mix scale building and key membership in a short repair round.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => 'Roman to Chord';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      'Read a key and Roman numeral, then choose the matching chord.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => 'Chord to Roman';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      'Read a chord inside a key and choose the matching Roman numeral.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => 'Diatonic or Not';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      'Sort chords into diatonic and non-diatonic answers in simple keys.';

  @override
  String get studyHarmonyLessonFunctionTitle => 'Function Basics';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      'Classify easy chords as tonic, predominant, or dominant.';

  @override
  String get studyHarmonyLessonRomanBossTitle => 'Boss: Functional Basics Mix';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      'Review Roman-to-chord, chord-to-Roman, diatonicity, and function together.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle => '조성 찾기';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      '짧은 코드 진행을 보고 가장 자연스러운 key center를 고릅니다.';

  @override
  String get studyHarmonyLessonProgressionFunctionTitle => '맥락 속 기능 읽기';

  @override
  String get studyHarmonyLessonProgressionFunctionDescription =>
      '하이라이트된 코드 하나를 보고 진행 안에서 어떤 기능을 하는지 고릅니다.';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicTitle => '튀는 코드 찾기';

  @override
  String get studyHarmonyLessonProgressionNonDiatonicDescription =>
      '주된 다이아토닉 읽기에서 벗어나는 코드를 하나 골라냅니다.';

  @override
  String get studyHarmonyLessonProgressionBossTitle => 'Boss: 혼합 분석';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      '조성, 기능, 비다이아토닉 판별을 짧은 분석 라운드로 함께 복습합니다.';

  @override
  String get studyHarmonyLessonMissingChordPatternTitle => '빈칸 코드 채우기';

  @override
  String get studyHarmonyLessonMissingChordPatternDescription =>
      '짧은 4코드 진행의 빈칸에 가장 잘 맞는 코드를 골라 넣습니다.';

  @override
  String get studyHarmonyLessonMissingChordCadenceTitle => '종지 빈칸 채우기';

  @override
  String get studyHarmonyLessonMissingChordCadenceDescription =>
      '구의 끝에서 어디로 끌리는지 보고 빈칸 코드를 고릅니다.';

  @override
  String get studyHarmonyLessonMissingChordBossTitle => 'Boss: 혼합 빈칸 채우기';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      '기능과 흐름을 더 강하게 요구하는 빈칸 채우기 문제를 짧게 섞어 풉니다.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return 'Find $note on the keyboard';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote =>
      'Which note is highlighted?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return 'Build $chord on the keyboard';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord =>
      'Which chord is highlighted?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return 'Pick every note in $scaleName';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return 'Pick the notes that belong to $keyName';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return 'In $keyName, which chord matches $roman?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return 'In $keyName, what Roman numeral matches $chord?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return 'In $keyName, is $chord diatonic?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return 'In $keyName, what function does $chord have?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => '진행';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '이 진행에 가장 잘 맞는 key center는 무엇인가요?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '$chord는 여기서 어떤 기능을 하나요?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '이 진행에서 가장 비다이아토닉한 코드는 무엇인가요?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '빈칸에 가장 잘 들어갈 코드는 무엇인가요?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return '분석기는 이 진행을 $keyLabel 중심으로 읽는 것이 가장 자연스럽다고 봅니다.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord는 이 문맥에서 $functionLabel 기능으로 읽는 것이 가장 자연스럽습니다.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord는 주된 $keyLabel 읽기에서 벗어나므로 비다이아토닉 후보로 가장 적절합니다.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord를 넣으면 이 진행의 $functionLabel 흐름이 가장 자연스럽게 복원됩니다.';
  }

  @override
  String studyHarmonyProgressionChoiceSlot(int index, Object chord) {
    return '$index. $chord';
  }

  @override
  String studyHarmonyScaleNameMajor(Object tonic) {
    return '$tonic major';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic natural minor';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic harmonic minor';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic major';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic minor';
  }

  @override
  String get studyHarmonyChoiceDiatonic => 'Diatonic';

  @override
  String get studyHarmonyChoiceNonDiatonic => 'Non-diatonic';

  @override
  String get studyHarmonyChoiceTonic => 'Tonic';

  @override
  String get studyHarmonyChoicePredominant => 'Predominant';

  @override
  String get studyHarmonyChoiceDominant => 'Dominant';

  @override
  String get studyHarmonyChoiceOther => 'Other';

  @override
  String get chordAnalyzerTitle => '코드 분석기';

  @override
  String get chordAnalyzerSubtitle => '진행을 붙여 넣으면 보수적인 화성 해석을 보여줍니다.';

  @override
  String get chordAnalyzerInputLabel => '코드 진행';

  @override
  String get chordAnalyzerInputHint => 'Dm7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '괄호 바깥에서는 공백, |, 쉼표로 코드를 구분할 수 있습니다. 괄호 안의 쉼표는 같은 코드의 텐션 구분자로 유지됩니다. 소문자 루트, 슬래시 베이스, sus/alt/add 표기와 C7(b9, #11) 같은 괄호형 텐션을 지원합니다. 터치 기기에서는 코드 패드나 ABC 입력을 사용할 수 있습니다.';

  @override
  String get chordAnalyzerAnalyze => '분석';

  @override
  String get chordAnalyzerKeyboardTitle => '코드 패드';

  @override
  String get chordAnalyzerKeyboardTouchHint =>
      '토큰을 눌러 진행을 조합하세요. 자유 입력이 필요할 때는 ABC 입력으로 전환하면 시스템 키보드를 계속 사용할 수 있습니다.';

  @override
  String get chordAnalyzerKeyboardDesktopHint =>
      '직접 입력하거나 붙여 넣고, 토큰을 눌러 커서 위치에 삽입할 수도 있습니다.';

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
  String get chordAnalyzerInitialTitle => '진행을 입력해 보세요';

  @override
  String get chordAnalyzerInitialBody =>
      'Dm7 G7 Cmaj7 또는 Cmaj7 | Am7 D7 | Gmaj7 같은 진행을 입력하면 가능한 조성, 로마 숫자, 짧은 요약을 볼 수 있습니다.';

  @override
  String get chordAnalyzerDetectedKeys => '가능한 조성';

  @override
  String get chordAnalyzerPrimaryReading => '주요 해석';

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
  String get chordAnalyzerWarnings => '경고와 모호한 지점';

  @override
  String get chordAnalyzerNoInputError => '분석할 코드 진행을 입력해 주세요.';

  @override
  String get chordAnalyzerNoRecognizedChordsError =>
      '진행에서 인식 가능한 코드 표기를 찾지 못했습니다.';

  @override
  String chordAnalyzerPartialParseWarning(Object tokens) {
    return '일부 기호를 건너뛰었습니다: $tokens';
  }

  @override
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative) {
    return '조성 중심이 $primary와 $alternative 사이에서 아직 다소 모호합니다.';
  }

  @override
  String get chordAnalyzerUnresolvedWarning =>
      '일부 코드는 여전히 모호하므로, 이번 해석은 의도적으로 보수적으로 유지됩니다.';

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
    return '$target을 향하는 트라이톤 대리도미넌트일 가능성이 있습니다.';
  }

  @override
  String get chordAnalyzerRemarkModalInterchange =>
      '병행 단조에서 빌려온 모달 인터체인지일 가능성이 있습니다.';

  @override
  String get chordAnalyzerRemarkAmbiguous => '현재 해석에서는 이 코드가 여전히 모호합니다.';

  @override
  String get chordAnalyzerRemarkUnresolved =>
      '이 코드는 현재의 보수적 규칙만으로는 단정하기 어렵습니다.';

  @override
  String get chordAnalyzerTagIiVI => 'ii-V-I 진행';

  @override
  String get chordAnalyzerTagTurnaround => '턴어라운드';

  @override
  String get chordAnalyzerTagDominantResolution => '도미넌트 해결';

  @override
  String get chordAnalyzerTagPlagalColor => '플래갈/모달 색채';

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
    return '이 진행은 $tag의 성격을 보여줍니다.';
  }

  @override
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  ) {
    return '$from와 $through는 $target으로 향하는 $fromFunction, $throughFunction 기능으로 볼 수 있습니다.';
  }

  @override
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target) {
    return '$chord는 $target을 향하는 세컨더리 도미넌트로 들릴 수 있습니다.';
  }

  @override
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target) {
    return '$chord는 $target을 향하는 트라이톤 대리도미넌트로 들릴 수 있습니다.';
  }

  @override
  String chordAnalyzerSummaryModalInterchange(Object chord) {
    return '$chord가 모달 인터체인지 색채를 더해 줍니다.';
  }

  @override
  String get chordAnalyzerSummaryAmbiguous =>
      '몇몇 세부 요소는 여전히 모호하므로, 해석을 의도적으로 보수적으로 유지합니다.';

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
    return '무시된 modifier: $details';
  }

  @override
  String chordAnalyzerParserDiagnosticWarning(Object details) {
    return '입력 경고: $details';
  }

  @override
  String get chordAnalyzerDiagnosticUnbalancedParentheses =>
      '괄호가 맞지 않아 기호 일부를 확정적으로 읽지 못했습니다.';

  @override
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis =>
      '예상하지 못한 닫는 괄호를 무시했습니다.';

  @override
  String chordAnalyzerEvidenceExtensionColor(Object extension) {
    return '$extension 확장음 표기가 이 해석을 더 강하게 지지합니다.';
  }

  @override
  String get chordAnalyzerEvidenceAlteredDominantColor =>
      'altered dominant 색채가 도미넌트 기능 해석을 뒷받침합니다.';

  @override
  String chordAnalyzerEvidenceSlashBass(Object bass) {
    return '슬래시 베이스 $bass가 베이스 라인이나 전위 정보를 유지해 줍니다.';
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
      '서스펜션 색채가 도미넌트의 긴장을 완전히 지우지 않으면서 부드럽게 만듭니다.';

  @override
  String get chordAnalyzerLowConfidenceTitle => '신뢰도가 낮은 해석';

  @override
  String get chordAnalyzerLowConfidenceBody =>
      '후보 조성이 서로 가깝거나 일부 표기가 부분 복구 상태라서, 우선 신중한 1차 해석으로 봐 주세요.';

  @override
  String get chordAnalyzerEmptyMeasure =>
      '이 마디는 비어 있지만 마디 번호 보존을 위해 그대로 표시했습니다.';

  @override
  String get chordAnalyzerNoAnalyzableChordsInMeasure =>
      '이 마디에서는 분석 가능한 코드 표기를 복구하지 못했습니다.';

  @override
  String get chordAnalyzerParseIssuesTitle => '파싱 이슈';

  @override
  String chordAnalyzerParseIssueLine(Object token, Object reason) {
    return '$token: $reason';
  }

  @override
  String get chordAnalyzerParseIssueEmpty => '비어 있는 토큰입니다.';

  @override
  String get chordAnalyzerParseIssueInvalidRoot => '루트 음을 인식하지 못했습니다.';

  @override
  String chordAnalyzerParseIssueUnknownRoot(Object root) {
    return '$root 표기는 지원되는 루트 음 표기가 아닙니다.';
  }

  @override
  String chordAnalyzerParseIssueInvalidBass(Object bass) {
    return '슬래시 베이스 $bass 표기는 지원되지 않습니다.';
  }

  @override
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix) {
    return '지원하지 않는 suffix 또는 modifier입니다: $suffix';
  }
}
