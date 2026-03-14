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
  String get nonDiatonic => '비다이아토닉';

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
  String get keyCenterLabelStyleClassicalCase => '씨: / 씨:';

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
  String get audioPlayChord => '코드 재생';

  @override
  String get audioPlayArpeggio => '아르페지오 재생';

  @override
  String get audioPlayProgression => '진행 재생';

  @override
  String get audioPlayPrompt => '문제 재생';

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

  @override
  String get mainMenuIntro => '코드 연습, 진행 분석, 화성 학습을 한 화면에서 시작하세요.';

  @override
  String get mainMenuGeneratorTitle => '코드 생성기';

  @override
  String get mainMenuGeneratorDescription => '스마트 진행과 보이싱 힌트로 연습용 코드를 바로 만듭니다.';

  @override
  String get openGenerator => '코드 연습 시작';

  @override
  String get openAnalyzer => '진행 분석 시작';

  @override
  String get mainMenuAnalyzerTitle => '코드 분석기';

  @override
  String get mainMenuAnalyzerDescription =>
      '진행을 읽고 조성, 로마 숫자, 화성 기능을 빠르게 확인합니다.';

  @override
  String get mainMenuStudyHarmonyTitle => '화성 학습';

  @override
  String get mainMenuStudyHarmonyDescription =>
      '레슨을 이어서 풀고, 챕터를 복습하며, 실전 화성 감각을 쌓습니다.';

  @override
  String get openStudyHarmony => '화성 학습 시작';

  @override
  String get studyHarmonyTitle => '화성 학습';

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
  String get studyHarmonyTrackCoreFilterLabel => '핵심';

  @override
  String get studyHarmonyTrackPopFilterLabel => '팝';

  @override
  String get studyHarmonyTrackJazzFilterLabel => '재즈';

  @override
  String get studyHarmonyTrackClassicalFilterLabel => '클래식';

  @override
  String studyHarmonyHubLessonsProgress(int cleared, int total) {
    return '$cleared/$total 수업 완료';
  }

  @override
  String studyHarmonyHubChaptersProgress(int cleared, int total) {
    return '$cleared/$total 챕터 완료';
  }

  @override
  String studyHarmonyProgressStars(int stars) {
    return '별 $stars개';
  }

  @override
  String studyHarmonyProgressSkillsMastered(int mastered, int total) {
    return '$mastered/$total 스킬 숙련';
  }

  @override
  String studyHarmonyProgressReviewsReady(int count) {
    return '복습 $count개 대기';
  }

  @override
  String studyHarmonyProgressStreak(int count) {
    return '연속 기록 x$count';
  }

  @override
  String studyHarmonyProgressRuns(int count) {
    return '$count회 플레이';
  }

  @override
  String studyHarmonyProgressBestRank(Object rank) {
    return '최고 $rank';
  }

  @override
  String get studyHarmonyBossTag => '보스';

  @override
  String get studyHarmonyContinueCardTitle => '이어하기';

  @override
  String get studyHarmonyContinueResumeHint => '가장 최근에 건드린 수업부터 이어서 시작합니다.';

  @override
  String get studyHarmonyContinueFrontierHint => '현재 진행선에서 다음 수업으로 바로 이동합니다.';

  @override
  String studyHarmonyContinueLessonLabel(Object lessonTitle) {
    return '$lessonTitle 이어하기';
  }

  @override
  String get studyHarmonyContinueAction => '이어하기';

  @override
  String get studyHarmonyReviewCardTitle => '복습';

  @override
  String get studyHarmonyReviewQueueHint => '현재 복습 대기열 기준으로 가져왔습니다.';

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
  String get studyHarmonyDailyCardHintCompleted =>
      '오늘의 데일리는 이미 클리어했습니다. 원하면 다시 돌고, 연속 기록은 내일 이어 가세요.';

  @override
  String get studyHarmonyDailyAction => '데일리 시작';

  @override
  String studyHarmonyDailyDateBadge(Object dateKey) {
    return '시드 $dateKey';
  }

  @override
  String get studyHarmonyDailyClearedTodayTag => '오늘의 데일리 클리어';

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
  String get studyHarmonyResultRewardTitle => '세션 보상';

  @override
  String get studyHarmonyBonusGoalsTitle => '보너스 목표';

  @override
  String studyHarmonyResultRankLine(Object rank) {
    return '랭크 $rank';
  }

  @override
  String studyHarmonyResultStarsLine(int stars) {
    return '별 $stars개';
  }

  @override
  String studyHarmonyResultBestLine(Object rank, int stars) {
    return '최고 $rank · 별 $stars개';
  }

  @override
  String studyHarmonyResultDailyStreakLine(int count) {
    return '데일리 연속 x$count';
  }

  @override
  String get studyHarmonyResultNewBestTag => '개인 최고 기록';

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
  String get studyHarmonyQuestBoardTitle => '퀘스트 보드';

  @override
  String get studyHarmonyQuestCompletedTag => '완료';

  @override
  String get studyHarmonyQuestTodayTag => '오늘';

  @override
  String studyHarmonyQuestProgressLabel(int current, int target) {
    return '$current/$target 진행';
  }

  @override
  String get studyHarmonyQuestDailyTitle => '데일리 연속';

  @override
  String get studyHarmonyQuestDailyBody => '오늘의 시드 세트를 클리어해서 연속 기록을 이어 가세요.';

  @override
  String get studyHarmonyQuestDailyBodyCompleted =>
      '오늘의 데일리는 이미 끝났습니다. 지금은 연속 기록이 유지되고 있습니다.';

  @override
  String get studyHarmonyQuestFrontierTitle => '프론티어 돌파';

  @override
  String studyHarmonyQuestFrontierBody(Object lessonTitle) {
    return '$lessonTitle을(를) 클리어해서 경로를 한 칸 밀어 보세요.';
  }

  @override
  String get studyHarmonyQuestFrontierBodyCompleted =>
      '현재 열려 있는 수업은 모두 클리어했습니다. 보스를 다시 돌거나 별을 더 모아 보세요.';

  @override
  String get studyHarmonyQuestStarsTitle => '별 수집';

  @override
  String studyHarmonyQuestStarsBody(Object chapterTitle) {
    return '$chapterTitle에서 추가 별을 모아 보세요.';
  }

  @override
  String get studyHarmonyQuestStarsBodyFallback => '현재 챕터에서 별을 더 모아 보세요.';

  @override
  String studyHarmonyComboLabel(int count) {
    return '콤보 x$count';
  }

  @override
  String studyHarmonyBestComboLabel(int count) {
    return '최고 콤보 x$count';
  }

  @override
  String get studyHarmonyBonusFullHearts => '하트 전부 유지';

  @override
  String studyHarmonyBonusAccuracyTarget(int percent) {
    return '정확도 $percent% 달성';
  }

  @override
  String studyHarmonyBonusComboTarget(int count) {
    return '콤보 x$count 달성';
  }

  @override
  String get studyHarmonyBonusSweepTag => '보너스 올클리어';

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
  String get studyHarmonyCoreTrackTitle => '핵심 트랙';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '음과 건반에서 시작해 코드, 스케일, 로마숫자, 다이아토닉 기초를 거쳐 짧은 코드 진행 분석까지 올라가는 기본 경로입니다.';

  @override
  String get studyHarmonyChapterNotesTitle => '1장: 메모 및 키보드';

  @override
  String get studyHarmonyChapterNotesDescription =>
      '음표 이름을 키보드에 매핑하고 흰색 건반과 간단한 우연 기호에 익숙해지세요.';

  @override
  String get studyHarmonyChapterChordsTitle => '2장: 코드 기초';

  @override
  String get studyHarmonyChapterChordsDescription =>
      '기본 3화음과 7도의 철자를 입력한 다음 해당 음에서 일반적인 화음 모양을 지정합니다.';

  @override
  String get studyHarmonyChapterScalesTitle => '3장: 저울 및 키';

  @override
  String get studyHarmonyChapterScalesDescription =>
      '메이저와 마이너 스케일을 만든 다음 키 안에 어떤 톤이 속하는지 알아보세요.';

  @override
  String get studyHarmonyChapterRomanTitle => '4장: 로마 숫자와 온음계';

  @override
  String get studyHarmonyChapterRomanDescription =>
      '간단한 로마 숫자를 코드로 변환하고, 코드에서 식별하고, 다이아토닉 기본 사항을 기능별로 정렬합니다.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle => '제5장 진행형 탐정Ⅰ';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '짧은 기본 진행을 보고 조성을 맞히고, 기능을 읽고, 어울리지 않는 코드를 찾아봅니다.';

  @override
  String get studyHarmonyChapterMissingChordTitle => '6장: 누락된 코드 I';

  @override
  String get studyHarmonyChapterMissingChordDescription =>
      '짧은 진행의 빈칸 하나를 채우면서 기능과 종지의 흐름을 읽는 감각을 익힙니다.';

  @override
  String get studyHarmonyOpenLessonAction => '레슨 열기';

  @override
  String get studyHarmonyLockedLessonAction => '잠김';

  @override
  String get studyHarmonyClearedTag => '클리어';

  @override
  String get studyHarmonyComingSoonTag => '곧 제공 예정';

  @override
  String get studyHarmonyPopTrackTitle => '팝 트랙';

  @override
  String get studyHarmonyPopTrackDescription => '코어 트랙이 안정되면 곡 중심의 길을 계획 중이다.';

  @override
  String get studyHarmonyJazzTrackTitle => '재즈 트랙';

  @override
  String get studyHarmonyJazzTrackDescription =>
      '재즈 하모니 콘텐츠는 핵심 커리큘럼이 확정될 때까지 잠긴 상태로 유지됩니다.';

  @override
  String get studyHarmonyClassicalTrackTitle => '클래식 트랙';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      '고전적인 맥락에서 기능적 조화는 나중 단계에 도달할 것입니다.';

  @override
  String get studyHarmonyObjectiveQuickDrill => '빠른 드릴';

  @override
  String get studyHarmonyObjectiveBossReview => '보스 복습';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => '화이트 키 노트 헌트';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      '음표 이름을 읽고 일치하는 흰색 건반을 탭하세요.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => '강조 표시된 메모 이름 지정';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      '강조 표시된 키를 보고 올바른 음표 이름을 선택하세요.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => '블랙 키와 쌍둥이';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      '검은 건반의 날카롭고 단조로운 철자를 먼저 살펴보세요.';

  @override
  String get studyHarmonyLessonNotesBossTitle => '보스: 빠른 노트 헌트';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      '노트 읽기와 키보드 찾기를 하나의 짧은 속도 라운드로 혼합합니다.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => '키보드의 트라이어드';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      '일반적인 장3화음, 단3화음, 감3화음을 키보드에서 직접 구성해 보세요.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => '키보드의 7분의 1';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      '7도를 추가하고 키보드에 몇 가지 일반적인 7도 코드를 입력하세요.';

  @override
  String get studyHarmonyLessonChordNameTitle => '강조 표시된 코드 이름 지정';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      '강조 표시된 코드 모양을 읽고 올바른 코드 이름을 선택하세요.';

  @override
  String get studyHarmonyLessonChordsBossTitle =>
      'Boss: Triads and Sevenths 리뷰';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      '한 번의 혼합 리뷰에서 코드 철자와 코드 이름 지정 사이를 전환하세요.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => '메이저 스케일 만들기';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      '단순한 메이저 스케일에 속하는 모든 음을 선택하세요.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => '마이너 스케일 구축';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      '몇 가지 공통 키를 사용하여 내추럴 마이너 및 하모닉 마이너 스케일을 만듭니다.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => '주요 회원';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      '명명된 키 안에 어떤 톤이 속하는지 찾아보세요.';

  @override
  String get studyHarmonyLessonScalesBossTitle => '보스: 스케일 수리';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      '짧은 수리 라운드에서 규모 구축과 주요 구성원을 혼합합니다.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => '로마에서 코드로';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      '조와 로마 숫자를 읽은 다음 일치하는 코드를 선택하세요.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => '코드에서 로마로';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      '키 내부의 코드를 읽고 일치하는 로마 숫자를 선택하세요.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => '온음계인지 아닌지';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      '간단한 키로 코드를 다이아토닉 및 비다이아토닉 답변으로 정렬합니다.';

  @override
  String get studyHarmonyLessonFunctionTitle => '기능 기본';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      '쉬운 코드를 토닉, 프리도미넌트 또는 지배적으로 분류합니다.';

  @override
  String get studyHarmonyLessonRomanBossTitle => '상사: 기능적 기본 믹스';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      '로마-코드, 코드-로마, 다이아토닉ity 및 기능을 함께 검토하세요.';

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
  String get studyHarmonyChapterCheckpointTitle => '체크포인트 건틀렛';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      '조성 중심, 기능, 컬러, 빈칸 채우기를 더 빠른 혼합 복습 세트로 묶어 봅니다.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => '케이던스 러시';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      '화성 기능을 빠르게 읽고, 이어서 빠진 케이던스 코드를 가벼운 압박 속에서 채워 넣으세요.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => '컬러와 조성 전환';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      '조성 판별과 비다이어토닉 컬러 판별을 번갈아 처리하면서도 흐름을 놓치지 마세요.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle => '보스: 체크포인트 건틀렛';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      '조성 중심, 기능, 컬러, 케이던스 복원을 한 번에 섞은 통합 체크포인트를 클리어하세요.';

  @override
  String get studyHarmonyChapterCapstoneTitle => '캡스톤 트라이얼';

  @override
  String get studyHarmonyChapterCapstoneDescription =>
      '속도, 컬러 감지, 해소 감각까지 묻는 더 빡빡한 혼합 진행 문제로 코어 트랙을 마무리합니다.';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundTitle => '턴어라운드 릴레이';

  @override
  String get studyHarmonyLessonCapstoneTurnaroundDescription =>
      '짧은 턴어라운드 안에서 기능 읽기와 빠진 코드 복원을 번갈아 이어 갑니다.';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorTitle => '차용 컬러 콜';

  @override
  String get studyHarmonyLessonCapstoneBorrowedColorDescription =>
      '모달 컬러를 재빨리 포착하고, 흐트러지기 전에 조성 중심까지 확인하세요.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => '리졸루션 랩';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      '프레이즈가 어디로 해소되려는지 따라가며 가장 설득력 있는 코드를 고르세요.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle => '보스: 최종 진행 시험';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      '조성 중심, 기능, 컬러, 해소를 모두 압박감 있게 섞은 최종 혼합 시험을 통과하세요.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return '키보드에서 $note를 찾으세요.';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote => '어떤 메모가 강조표시되어 있나요?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return '키보드에 $chord 빌드';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord => '어떤 코드가 강조 표시됩니까?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return '$scaleName의 모든 메모를 선택하세요.';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return '$keyName에 속한 메모를 선택하세요.';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return '$keyName에서 $roman와 일치하는 코드는 무엇입니까?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return '$keyName에서 로마 숫자가 $chord와 일치하는 것은 무엇입니까?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return '$keyName에서는 $chord 다이아토닉인가요?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return '$keyName에서 $chord에는 어떤 기능이 있나요?';
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
    return '$tonic 메이저';
  }

  @override
  String studyHarmonyScaleNameNaturalMinor(Object tonic) {
    return '$tonic 자연 마이너';
  }

  @override
  String studyHarmonyScaleNameHarmonicMinor(Object tonic) {
    return '$tonic 하모닉 마이너';
  }

  @override
  String studyHarmonyKeyNameMajor(Object tonic) {
    return '$tonic 메이저';
  }

  @override
  String studyHarmonyKeyNameMinor(Object tonic) {
    return '$tonic 마이너';
  }

  @override
  String get studyHarmonyChoiceDiatonic => '온음계';

  @override
  String get studyHarmonyChoiceNonDiatonic => '비다이아토닉';

  @override
  String get studyHarmonyChoiceTonic => '토닉';

  @override
  String get studyHarmonyChoicePredominant => '우세한';

  @override
  String get studyHarmonyChoiceDominant => '우성';

  @override
  String get studyHarmonyChoiceOther => '다른';

  @override
  String get chordAnalyzerTitle => '코드 분석기';

  @override
  String get chordAnalyzerSubtitle => '진행을 붙여 넣으면 보수적인 화성 해석을 보여줍니다.';

  @override
  String get chordAnalyzerInputLabel => '코드 진행';

  @override
  String get chordAnalyzerInputHint => 'DM7 G7 Cmaj7';

  @override
  String get chordAnalyzerInputHelper =>
      '괄호 바깥에서는 공백, |, 쉼표로 코드를 구분할 수 있습니다. 괄호 안의 쉼표는 같은 코드의 텐션 구분자로 유지됩니다. 소문자 루트, 슬래시 베이스, sus/alt/add 표기와 C7(b9, #11) 같은 괄호형 텐션을 지원합니다. 터치 기기에서는 코드 패드나 ABC 입력을 사용할 수 있습니다.';

  @override
  String get chordAnalyzerAnalyze => '분석하기';

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
  String get chordAnalyzerRawInput => '알파벳';

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
  String get chordAnalyzerDetectedKeys => '감지된 조성';

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

  @override
  String get studyHarmonyDailyReplayAction => '오늘의 도전 다시 하기';

  @override
  String get studyHarmonyMilestoneCabinetTitle => '마일스톤 메달';

  @override
  String get studyHarmonyMilestoneLessonsTitle => '개척자 메달';

  @override
  String studyHarmonyMilestoneLessonsBody(Object target) {
    return '코어 기초에서 레슨 $target개를 클리어하세요.';
  }

  @override
  String get studyHarmonyMilestoneStarsTitle => '별 수집가';

  @override
  String studyHarmonyMilestoneStarsBody(Object target) {
    return 'Study Harmony 전반에서 별 $target개를 모으세요.';
  }

  @override
  String get studyHarmonyMilestoneStreakTitle => '연속 도전 전설';

  @override
  String studyHarmonyMilestoneStreakBody(Object target) {
    return '최고 일일 연속 기록 $target일을 달성하세요.';
  }

  @override
  String get studyHarmonyMilestoneMasteryTitle => '숙련 학자';

  @override
  String studyHarmonyMilestoneMasteryBody(Object target) {
    return '스킬 $target개를 숙련 상태로 만드세요.';
  }

  @override
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total) {
    return '$earned/$total 메달 획득';
  }

  @override
  String get studyHarmonyMilestoneCompletedTag => '메달장 완성';

  @override
  String get studyHarmonyMilestoneTierBronze => '브론즈 메달';

  @override
  String get studyHarmonyMilestoneTierSilver => '실버 메달';

  @override
  String get studyHarmonyMilestoneTierGold => '골드 메달';

  @override
  String get studyHarmonyMilestoneTierPlatinum => '플래티넘 메달';

  @override
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier) {
    return '$tier · $title';
  }

  @override
  String get studyHarmonyResultMilestonesTitle => '새 메달';

  @override
  String get studyHarmonyChapterRemixTitle => '리믹스 아레나';

  @override
  String get studyHarmonyChapterRemixDescription =>
      '키 센터, 기능, 차용 색채를 예고 없이 섞어 읽는 후반부 종합 구간입니다.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => '브리지 빌더';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      '기능 읽기와 빈칸 채우기를 한 흐름의 진행으로 이어 붙입니다.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => '컬러 피벗';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      '진행이 흔들릴 때 차용 화음과 키 중심 전환 지점을 포착합니다.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => '리졸루션 스프린트';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      '기능, cadence fill, 조성 중력을 더 빠르게 연달아 읽어냅니다.';

  @override
  String get studyHarmonyLessonRemixBossTitle => '리믹스 마라톤';

  @override
  String get studyHarmonyLessonRemixBossDescription =>
      '지금까지의 진행 읽기 관점을 모두 다시 섞어 던지는 후반부 최종 마라톤입니다.';

  @override
  String studyHarmonyProgressStreakSaver(Object count) {
    return '세이버 x$count';
  }

  @override
  String studyHarmonyProgressLegendCrowns(Object count) {
    return '레전드 크라운 $count개';
  }

  @override
  String get studyHarmonyModeFocus => '포커스 모드';

  @override
  String get studyHarmonyModeLegend => '레전드 트라이얼';

  @override
  String get studyHarmonyFocusCardTitle => '포커스 스프린트';

  @override
  String get studyHarmonyFocusCardHint =>
      '현재 약한 지점이 겹치는 구간을 적은 목숨과 더 빡빡한 목표로 집중 공략합니다.';

  @override
  String get studyHarmonyFocusFallbackHint => '현재 약점을 짧고 강하게 압축한 혼합 드릴입니다.';

  @override
  String get studyHarmonyFocusAction => '스프린트 시작';

  @override
  String get studyHarmonyFocusSessionTitle => '포커스 스프린트';

  @override
  String studyHarmonyFocusSessionDescription(Object chapter) {
    return '$chapter 주변의 약한 지점을 압축한 고난도 혼합 스프린트입니다.';
  }

  @override
  String studyHarmonyFocusMixLabel(Object count) {
    return '레슨 $count개 혼합';
  }

  @override
  String get studyHarmonyFocusRewardLabel => '주간 세이버 보상';

  @override
  String get studyHarmonyLegendCardTitle => '레전드 트라이얼';

  @override
  String get studyHarmonyLegendCardHint =>
      '실버 이상 챕터를 목숨 2개짜리 마스터리 런으로 다시 돌파해 레전드 크라운을 확보하세요.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      '챕터를 클리어하고 레슨당 평균 2별 정도까지 올리면 레전드 트라이얼이 열립니다.';

  @override
  String get studyHarmonyLegendAction => '레전드 도전';

  @override
  String get studyHarmonyLegendSessionTitle => '레전드 트라이얼';

  @override
  String studyHarmonyLegendSessionDescription(Object chapter) {
    return '$chapter를 레전드 크라운용 무실수 마스터리 런으로 다시 압축한 세션입니다.';
  }

  @override
  String studyHarmonyLegendMixLabel(Object count) {
    return '레슨 $count개 연속';
  }

  @override
  String get studyHarmonyLegendRiskLabel => '레전드 크라운 도전';

  @override
  String get studyHarmonyWeeklyPlanTitle => '주간 트레이닝 플랜';

  @override
  String get studyHarmonyWeeklyRewardLabel => '보상: Streak Saver';

  @override
  String get studyHarmonyWeeklyRewardReadyTag => '보상 획득 가능';

  @override
  String get studyHarmonyWeeklyRewardClaimedTag => '보상 수령 완료';

  @override
  String get studyHarmonyWeeklyGoalActiveDaysTitle => '여러 날에 다시 오기';

  @override
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target) {
    return '이번 주에 서로 다른 날 $target일 활동하세요.';
  }

  @override
  String get studyHarmonyWeeklyGoalDailyTitle => '일일 루프 유지';

  @override
  String studyHarmonyWeeklyGoalDailyBody(Object target) {
    return '이번 주에 일일 도전을 $target회 클리어하세요.';
  }

  @override
  String get studyHarmonyWeeklyGoalFocusTitle => '포커스 스프린트 완료';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return '이번 주에 포커스 스프린트를 $target회 완료하세요.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      '어제의 공백을 보호하기 위해 Streak Saver를 사용했습니다.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return '새 Streak Saver를 획득했습니다. 현재 보유: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => '포커스 스프린트를 클리어했습니다.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return '$chapter 레전드 크라운을 확보했습니다.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => '앙코르 래더';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      '지금까지의 진행 읽기 도구를 짧고 진하게 압축한 마지막 앙코르 구간입니다.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => '토널 펄스';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      '워밍업 없이 바로 키 중심과 기능을 고정해서 읽어냅니다.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => '컬러 스왑';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      '차용 색채 판별과 missing chord 복원을 번갈아 처리하며 감각을 흔듭니다.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => '앙코르 피날레';

  @override
  String get studyHarmonyLessonEncoreBossDescription =>
      '진행 읽기 전 관점을 짧고 촘촘하게 다시 묻는 마지막 보스 라운드입니다.';

  @override
  String get studyHarmonyChapterMasteryBronze => '브론즈 클리어';

  @override
  String get studyHarmonyChapterMasterySilver => '실버 크라운';

  @override
  String get studyHarmonyChapterMasteryGold => '골드 크라운';

  @override
  String get studyHarmonyChapterMasteryLegendary => '레전드 크라운';

  @override
  String get studyHarmonyModeBossRush => '보스 러시 모드';

  @override
  String get studyHarmonyBossRushCardTitle => '보스 러시';

  @override
  String get studyHarmonyBossRushCardHint =>
      '해금한 보스 레슨들을 더 적은 목숨으로 연속 돌파하는 고위험 혼합 러시입니다.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      '보스 레슨 두 개 이상을 열면 더 긴장감 있는 러시 모드가 열립니다.';

  @override
  String get studyHarmonyBossRushAction => '러시 시작';

  @override
  String get studyHarmonyBossRushSessionTitle => '보스 러시';

  @override
  String studyHarmonyBossRushSessionDescription(Object chapter) {
    return '$chapter 주변에서 해금한 보스 레슨들로 구성한 고압 러시 세션입니다.';
  }

  @override
  String studyHarmonyBossRushMixLabel(Object count) {
    return '보스 레슨 $count개 혼합';
  }

  @override
  String get studyHarmonyBossRushHighRiskLabel => '목숨 2개 한정';

  @override
  String get studyHarmonyResultBossRushLine => '보스 러시를 클리어했습니다.';

  @override
  String get studyHarmonyChapterSpotlightTitle => '스포트라이트 쇼다운';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      '차용 색채, cadence 압박, 통합형 보스 판별을 정면으로 다루는 최종 스포트라이트 구간입니다.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => '차용 렌즈';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      '차용 화음이 시선을 흔들어도 키 중심을 놓치지 않고 추적합니다.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => '케이던스 스왑';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      '기능 읽기와 cadence 복원을 번갈아 처리하면서도 해결 지점을 유지합니다.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => '스포트라이트 쇼다운';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      '진행 읽기 전 관점을 압박 속에서도 끝까지 유지해야 하는 최종 보스 세트입니다.';

  @override
  String get studyHarmonyChapterAfterHoursTitle => '애프터 아워 랩';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      '워밍업 힌트를 줄이고 차용 색채, cadence 압박, 키 중심 추적을 거칠게 다시 섞는 후반부 실험 구간입니다.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => '모달 섀도우';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      '차용 색채가 읽기를 어둡게 흔들어도 키 중심을 놓치지 않고 붙잡습니다.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => '리졸루션 페인트';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      '기능과 cadence 페이크를 읽어내며 진짜 해결 지점을 끝까지 추적합니다.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => '센터 크로스페이드';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      '키 중심 판별, 기능 읽기, missing chord 복원을 추가 힌트 없이 한 흐름으로 묶습니다.';

  @override
  String get studyHarmonyLessonAfterHoursBossTitle => '라스트 콜 보스';

  @override
  String get studyHarmonyLessonAfterHoursBossDescription =>
      '늦은 후반부 압박 속에서도 진행 읽기 전 관점을 또렷하게 유지해야 하는 마지막 심화 보스입니다.';

  @override
  String studyHarmonyProgressRelayWins(Object count) {
    return '릴레이 승리 $count회';
  }

  @override
  String get studyHarmonyModeRelay => '아레나 릴레이';

  @override
  String get studyHarmonyRelayCardTitle => '아레나 릴레이';

  @override
  String get studyHarmonyRelayCardHint =>
      '서로 다른 챕터의 해금 레슨을 한 세션에 섞어 푸는 인터리빙 런입니다. 전환 적응력까지 같이 점검합니다.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      '서로 다른 챕터가 두 개 이상 열리면 아레나 릴레이가 열립니다.';

  @override
  String get studyHarmonyRelayAction => '릴레이 시작';

  @override
  String get studyHarmonyRelaySessionTitle => '아레나 릴레이';

  @override
  String studyHarmonyRelaySessionDescription(Object chapter) {
    return '$chapter 주변의 해금 챕터들을 섞어 진행하는 인터리빙 릴레이 세션입니다.';
  }

  @override
  String studyHarmonyRelayMixLabel(Object count) {
    return '레슨 $count개 릴레이';
  }

  @override
  String studyHarmonyRelayChapterSpreadLabel(Object count) {
    return '챕터 $count개 혼합';
  }

  @override
  String get studyHarmonyRelayChainLabel => '챕터 전환 적응';

  @override
  String studyHarmonyResultRelayLine(Object count) {
    return '아레나 릴레이 승리 $count회';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => '릴레이 러너';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return '아레나 릴레이를 $target회 클리어하세요.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => '네온 디투어';

  @override
  String get studyHarmonyChapterNeonDescription =>
      '차용 색채, 중심 전환, 착지 복원을 번갈아 흔들며 읽기 정확도를 끝까지 시험하는 후반부 종합 챕터입니다.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => '모달 디투어';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      '차용 색채가 진행을 옆길로 끌어도 실제 키 중심을 끝까지 추적합니다.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => '피벗 프레셔';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      '조성 중심 전환과 기능 압박을 연속으로 읽으며 다음 전환을 대비합니다.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => '차용 랜딩';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      '차용 색채 페이크 이후 비어 있는 착지 화음을 복원하며 진짜 해결 지점을 되찾습니다.';

  @override
  String get studyHarmonyLessonNeonBossTitle => '시티 라이트 보스';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      '피벗 읽기, 차용 색채, cadence 복원을 한 번에 섞어 부드러운 착지 없이 밀어붙이는 네온 보스입니다.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tier 리그';
  }

  @override
  String get studyHarmonyLeagueCardTitle => '하모니 리그';

  @override
  String studyHarmonyLeagueCardHint(Object tier, Object mode) {
    return '이번 주 $tier 리그까지 밀어 올리세요. 지금 가장 효율적인 부스트는 $mode입니다.';
  }

  @override
  String get studyHarmonyLeagueCardHintMax =>
      '이번 주 다이아 리그에 안착했습니다. 고난도 클리어를 이어서 페이스를 유지하세요.';

  @override
  String get studyHarmonyLeagueFallbackHint =>
      '이번 주 밀어 올릴 추천 런이 생기면 리그 카드가 더 또렷하게 활성화됩니다.';

  @override
  String get studyHarmonyLeagueAction => '리그 도전';

  @override
  String studyHarmonyLeagueScoreLabel(Object score) {
    return '이번 주 XP $score';
  }

  @override
  String studyHarmonyLeagueProgressLabel(Object score, Object target) {
    return '이번 주 XP $score/$target';
  }

  @override
  String studyHarmonyLeagueNextTierLabel(Object tier) {
    return '다음: $tier';
  }

  @override
  String studyHarmonyLeagueBoostLabel(Object mode) {
    return '추천 부스트: $mode';
  }

  @override
  String studyHarmonyResultLeagueXpLine(Object count) {
    return '리그 XP +$count';
  }

  @override
  String studyHarmonyResultLeaguePromotionLine(Object tier) {
    return '$tier 리그로 승급했습니다';
  }

  @override
  String get studyHarmonyLeagueTierRookie => '루키';

  @override
  String get studyHarmonyLeagueTierBronze => '브론즈';

  @override
  String get studyHarmonyLeagueTierSilver => '실버';

  @override
  String get studyHarmonyLeagueTierGold => '골드';

  @override
  String get studyHarmonyLeagueTierDiamond => '다이아';

  @override
  String get studyHarmonyChapterMidnightTitle => '심야 전환실';

  @override
  String get studyHarmonyChapterMidnightDescription =>
      '흔들리는 중심, 가짜 해결, 차용 우회를 빠르게 읽어내야 하는 마지막 관제실형 챕터입니다.';

  @override
  String get studyHarmonyLessonMidnightDriftTitle => '조성 신호 흔들림';

  @override
  String get studyHarmonyLessonMidnightDriftDescription =>
      '표면이 차용 색채로 흔들려도 실제 조성 신호를 끝까지 붙잡습니다.';

  @override
  String get studyHarmonyLessonMidnightLineTitle => '가짜 진행선';

  @override
  String get studyHarmonyLessonMidnightLineDescription =>
      '가짜 해결을 지나 기능 압박의 진짜 흐름을 읽어냅니다.';

  @override
  String get studyHarmonyLessonMidnightRerouteTitle => '차용 우회 진행';

  @override
  String get studyHarmonyLessonMidnightRerouteDescription =>
      '차용 색채로 우회된 진행 속에서 원래의 착지 지점을 다시 복원합니다.';

  @override
  String get studyHarmonyLessonMidnightBossTitle => '블랙아웃 보스';

  @override
  String get studyHarmonyLessonMidnightBossDescription =>
      '후반부 모든 읽기 렌즈를 안전장치 없이 섞어 붙이는 최종 보스 세트입니다.';

  @override
  String studyHarmonyProgressQuestChests(Object count) {
    return '퀘스트 상자 $count개';
  }

  @override
  String studyHarmonyProgressLeagueBoost(Object count) {
    return '2배 리그 XP x$count';
  }

  @override
  String get studyHarmonyQuestChestTitle => '퀘스트 상자';

  @override
  String studyHarmonyQuestChestLockedHeadline(Object count) {
    return '남은 퀘스트 $count개';
  }

  @override
  String get studyHarmonyQuestChestReadyHeadline => '퀘스트 체스트 준비 완료';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => '오늘의 체스트 오픈 완료';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2배 리그 XP 활성화';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return '보상: 리그 XP +$xp';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      '오늘의 퀘스트 3종을 마치면 보너스 체스트가 열리고 주간 리그 XP를 추가로 받습니다.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      '오늘의 퀘스트 3종이 모두 끝났습니다. 아무 런이나 하나 더 클리어하면 체스트 보상이 리그 XP로 반영됩니다.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      '오늘의 퀘스트 3종을 모두 끝내서 체스트 보상이 이미 리그 XP로 반영됐습니다.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return '오늘의 체스트를 열었고 다음 $count번 클리어에는 2배 리그 XP가 적용됩니다.';
  }

  @override
  String get studyHarmonyQuestChestAction => '퀘스트 마무리';

  @override
  String studyHarmonyQuestChestBoostLabel(Object mode) {
    return '가장 빠른 마무리: $mode';
  }

  @override
  String studyHarmonyQuestChestBoostReadyLabel(Object count) {
    return '2배 XP x$count';
  }

  @override
  String studyHarmonyQuestChestProgressLabel(Object count, Object target) {
    return '일일 퀘스트 $count/$target';
  }

  @override
  String get studyHarmonyResultQuestChestLine => '퀘스트 체스트를 열었습니다.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return '퀘스트 체스트 보너스 리그 XP +$count';
  }

  @override
  String studyHarmonyResultLeagueBoostReadyLine(Object count) {
    return '다음 $count번 클리어에 2배 리그 XP가 준비됐습니다.';
  }

  @override
  String studyHarmonyResultLeagueBoostAppliedLine(Object count) {
    return '부스트 보너스 리그 XP +$count';
  }

  @override
  String studyHarmonyResultLeagueBoostRemainingLine(Object count) {
    return '남은 2배 부스트 클리어 $count회';
  }

  @override
  String studyHarmonyLeagueBoostReadyLabel(Object count) {
    return '2배 XP x$count';
  }

  @override
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode) {
    return '다음 $count번 클리어에는 2배 리그 XP가 적용됩니다. 부스트가 살아 있을 때 $mode로 밀어붙이세요.';
  }

  @override
  String get studyHarmonyChapterSkylineTitle => '스카이라인 서킷';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      '흔들리는 중심, 차용 중력, 가짜 귀착을 빠르게 섞어 읽어야 하는 최종 스카이라인 챕터입니다.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => '잔상 펄스';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      '진행이 새 레인으로 잠기기 전에 잔상 속 키 중심과 기능을 먼저 붙잡습니다.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => '중력 전환';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      '차용 중력과 missing chord 복원을 동시에 처리하며 진행의 무게 이동을 따라갑니다.';

  @override
  String get studyHarmonyLessonSkylineHomeTitle => '헛귀착';

  @override
  String get studyHarmonyLessonSkylineHomeDescription =>
      '가짜 귀착을 통과한 뒤 진짜 착지 지점을 다시 복원해 진행을 끝까지 읽어냅니다.';

  @override
  String get studyHarmonyLessonSkylineBossTitle => '최종 신호 보스';

  @override
  String get studyHarmonyLessonSkylineBossDescription =>
      '후반부 진행 읽기 렌즈를 모두 한 번에 묶어 마지막 신호 테스트로 밀어붙이는 최종 보스입니다.';

  @override
  String get studyHarmonyChapterAfterglowTitle => '잔광 활주로';

  @override
  String get studyHarmonyChapterAfterglowDescription =>
      '갈라지는 해결, 차용 미끼, 흔들리는 중심을 끝까지 정확히 읽어야 하는 종반 압축 챕터입니다.';

  @override
  String get studyHarmonyLessonAfterglowSplitTitle => '분기 판단';

  @override
  String get studyHarmonyLessonAfterglowSplitDescription =>
      '기능 흐름을 잃지 않으면서 진행을 바로 세우는 복원 화음을 빠르게 고릅니다.';

  @override
  String get studyHarmonyLessonAfterglowLureTitle => '차용 유인';

  @override
  String get studyHarmonyLessonAfterglowLureDescription =>
      '전조처럼 보이는 차용 색채를 구분하고 진행이 진짜로 돌아오는 지점을 읽습니다.';

  @override
  String get studyHarmonyLessonAfterglowFlickerTitle => '중심 흔들림';

  @override
  String get studyHarmonyLessonAfterglowFlickerDescription =>
      '카덴스 단서가 빠르게 흔들리는 동안에도 키 중심을 끝까지 유지합니다.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => '레드라인 리턴 보스';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      '키 중심, 기능, 차용 색채, missing chord 복원을 최고 속도로 한 번에 묶는 종반 보스입니다.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return '투어 스탬프 $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => '이번 달 투어 완료';

  @override
  String get studyHarmonyTourTitle => '하모니 투어';

  @override
  String studyHarmonyTourProgressHeadline(Object count, Object target) {
    return '투어 스탬프 $count/$target';
  }

  @override
  String get studyHarmonyTourReadyHeadline => '투어 보상 준비 완료';

  @override
  String get studyHarmonyTourClaimedHeadline => '이번 달 투어 클리어';

  @override
  String studyHarmonyTourRewardLabel(Object xp, Object count) {
    return '보상: 리그 XP +$xp, Streak Saver +$count';
  }

  @override
  String studyHarmonyTourActiveDaysBody(Object target) {
    return '이번 달 $target일 이상 플레이해 투어 보너스를 잠가보세요.';
  }

  @override
  String studyHarmonyTourQuestChestBody(Object target) {
    return '이번 달 Quest Chest를 $target번 열어 투어 스탬프를 채워보세요.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return '이번 달 spotlight 클리어를 $target번 달성하세요. Boss Rush, Relay, Focus, Legend, 보스 레슨이 모두 카운트됩니다.';
  }

  @override
  String get studyHarmonyTourReadyBody =>
      '이번 달 스탬프를 모두 채웠습니다. 다음 클리어에서 투어 보상이 바로 지급됩니다.';

  @override
  String get studyHarmonyTourClaimedBody =>
      '이번 달 투어를 완주했습니다. 다음 달 루프가 열릴 때까지 고난도 감각을 유지해 보세요.';

  @override
  String get studyHarmonyTourAction => '투어 진행';

  @override
  String studyHarmonyTourActiveDaysLabel(Object count, Object target) {
    return '활동 일수 $count/$target';
  }

  @override
  String studyHarmonyTourQuestChestsLabel(Object count, Object target) {
    return 'Quest Chest $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return 'Spotlight $count/$target';
  }

  @override
  String get studyHarmonyResultTourCompleteLine => 'Harmony Tour 완료';

  @override
  String studyHarmonyResultTourXpLine(Object count) {
    return '투어 보너스 +$count 리그 XP';
  }

  @override
  String studyHarmonyResultTourStreakSaverLine(Object count) {
    return 'Streak Saver 보유 $count';
  }

  @override
  String get studyHarmonyChapterDaybreakTitle => '새벽 주파수';

  @override
  String get studyHarmonyChapterDaybreakDescription =>
      '유령 종지, 가짜 새벽, 차용된 개화를 섞어 긴 종반 러닝 뒤에도 선명한 판별을 유지하게 만드는 최종 확장 챕터입니다.';

  @override
  String get studyHarmonyLessonDaybreakGhostTitle => '허상 종지';

  @override
  String get studyHarmonyLessonDaybreakGhostDescription =>
      '끝난 것처럼 들리지만 닫히지 않는 구간에서 기능과 missing chord 복원을 동시에 읽어냅니다.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => '헛새벽';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      '너무 일찍 밝아지는 듯한 순간에 숨어 있는 중심 흔들림과 비다이아토닉 신호를 구분합니다.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => '차용 개화';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      '화성이 더 밝아지는 순간에도 차용 색채와 기능선을 함께 붙잡아 진행의 흐름을 지켜냅니다.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => '선라이즈 오버드라이브 보스';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      '키 중심, 기능, 비다이아토닉 색채, missing chord 복원을 새벽 속도로 한 번에 엮는 최종 오버드라이브 보스입니다.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return '듀엣 연속 x$count';
  }

  @override
  String get studyHarmonyDuetTitle => '듀엣 약속';

  @override
  String get studyHarmonyDuetStartHeadline => '오늘의 듀엣 시작';

  @override
  String studyHarmonyDuetInProgressHeadline(Object count) {
    return '듀엣 연속 x$count';
  }

  @override
  String studyHarmonyDuetReadyHeadline(Object count) {
    return '$count일 연속 듀엣 완료';
  }

  @override
  String studyHarmonyDuetRewardLabel(Object xp) {
    return '보상: 핵심 구간마다 리그 XP +$xp';
  }

  @override
  String get studyHarmonyDuetNeedDailyBody =>
      '먼저 오늘의 Daily를 끝내고, 이어서 spotlight 런 1회를 클리어해 듀엣을 이어가세요.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      'Daily는 끝났습니다. Focus, Relay, Boss Rush, Legend, 보스 레슨 중 하나를 클리어하면 오늘 듀엣이 잠깁니다.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return '오늘 Daily와 Spotlight를 모두 마쳐 듀엣이 잠겼습니다. 현재 공유 연속은 $count일입니다.';
  }

  @override
  String get studyHarmonyDuetDailyDone => 'Daily 완료';

  @override
  String get studyHarmonyDuetDailyMissing => 'Daily 필요';

  @override
  String get studyHarmonyDuetSpotlightDone => 'Spotlight 완료';

  @override
  String get studyHarmonyDuetSpotlightMissing => 'Spotlight 필요';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return '매일 $done';
  }

  @override
  String studyHarmonyDuetSpotlightLabel(bool done) {
    return '스포트라이트 $done';
  }

  @override
  String studyHarmonyDuetTargetLabel(Object count, Object target) {
    return '연속 $count/$target';
  }

  @override
  String get studyHarmonyDuetAction => '듀엣 이어가기';

  @override
  String studyHarmonyResultDuetLine(Object count) {
    return '듀엣 연속 x$count';
  }

  @override
  String studyHarmonyResultDuetRewardLine(Object count) {
    return '듀엣 보상 +$count 리그 XP';
  }

  @override
  String get studyHarmonySolfegeDo => '도';

  @override
  String get studyHarmonySolfegeRe => '레';

  @override
  String get studyHarmonySolfegeMi => '미';

  @override
  String get studyHarmonySolfegeFa => '파';

  @override
  String get studyHarmonySolfegeSol => '솔';

  @override
  String get studyHarmonySolfegeLa => '라';

  @override
  String get studyHarmonySolfegeTi => '시';

  @override
  String get studyHarmonyPrototypeCourseTitle => '화성 학습 프로토타입';

  @override
  String get studyHarmonyPrototypeCourseDescription =>
      '레슨 시스템에 옮겨 둔 초기 프로토타입 레벨입니다.';

  @override
  String get studyHarmonyPrototypeChapterTitle => '프로토타입 레슨';

  @override
  String get studyHarmonyPrototypeChapterDescription =>
      '확장형 학습 시스템을 도입하는 동안 보존해 둔 임시 레슨입니다.';

  @override
  String get studyHarmonyPrototypeLevelObjective =>
      '라이프 3개를 모두 잃기 전에 10문제를 맞히면 클리어';

  @override
  String get studyHarmonyPrototypeLevel1Title => '프로토타입 레벨 1 · 도 / 미 / 솔';

  @override
  String get studyHarmonyPrototypeLevel1Description =>
      '도, 미, 솔만 구분하는 가장 기본적인 워밍업 레벨입니다.';

  @override
  String get studyHarmonyPrototypeLevel2Title =>
      '프로토타입 레벨 2 · 도 / 레 / 미 / 솔 / 라';

  @override
  String get studyHarmonyPrototypeLevel2Description =>
      '도, 레, 미, 솔, 라를 빠르게 찾는 중간 단계 레벨입니다.';

  @override
  String get studyHarmonyPrototypeLevel3Title =>
      '프로토타입 레벨 3 · 도 / 레 / 미 / 파 / 솔 / 라 / 시 / 도';

  @override
  String get studyHarmonyPrototypeLevel3Description =>
      '도레미파솔라시도 전음을 다루는 옥타브 완성 레벨입니다.';

  @override
  String studyHarmonyPrototypeLowCLabel(String noteName) {
    return '$noteName (낮은 C)';
  }

  @override
  String studyHarmonyPrototypeHighCLabel(String noteName) {
    return '$noteName (높은 C)';
  }

  @override
  String get studyHarmonyTemplateChoiceLabel => '템플릿';

  @override
  String get studyHarmonyChapterBlueHourTitle => '블루 아워 교차점';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      '교차 흐름, 후광처럼 스치는 차용, 이중 지평선을 섞어 종반부 판별을 끝까지 흔드는 황혼 확장 챕터입니다.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => '교차 흐름';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      '진행이 두 방향으로 당겨질 때도 키 중심과 기능을 동시에 붙잡습니다.';

  @override
  String get studyHarmonyLessonBlueHourHaloTitle => '후광 차용';

  @override
  String get studyHarmonyLessonBlueHourHaloDescription =>
      '안개처럼 번지는 차용 색채 속에서 빠진 화음을 복원해 문장을 다시 세웁니다.';

  @override
  String get studyHarmonyLessonBlueHourHorizonTitle => '이중 지평선';

  @override
  String get studyHarmonyLessonBlueHourHorizonDescription =>
      '두 개의 도착점이 번갈아 보이는 상황에서도 진짜 귀착 지점을 끝까지 유지합니다.';

  @override
  String get studyHarmonyLessonBlueHourBossTitle => '트윈 랜턴즈 보스';

  @override
  String get studyHarmonyLessonBlueHourBossDescription =>
      '키 중심, 기능, 차용 색채, missing chord 복원을 황혼 속도로 교차시키는 최종 블루 아워 보스입니다.';
}
