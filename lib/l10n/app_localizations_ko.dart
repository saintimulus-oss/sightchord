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
  String get themeMode => '테마';

  @override
  String get themeModeSystem => '시스템 설정';

  @override
  String get themeModeLight => '라이트 모드';

  @override
  String get themeModeDark => '다크 모드';

  @override
  String get setupAssistantTitle => '설정 도우미';

  @override
  String get setupAssistantSubtitle =>
      '몇 가지 간단한 선택으로 첫 연습을 덜 부담스럽게 만들어요. 나중에 언제든 다시 실행할 수 있어요.';

  @override
  String get setupAssistantCurrentMode => '현재 모드';

  @override
  String get setupAssistantModeGuided => '가이드 모드';

  @override
  String get setupAssistantModeStandard => '표준 모드';

  @override
  String get setupAssistantModeAdvanced => '고급 모드';

  @override
  String get setupAssistantRunAgain => '설정 도우미 다시 실행';

  @override
  String get setupAssistantCardBody =>
      '지금은 더 편안한 시작 프로필을 쓰고, 익숙해지면 고급 옵션을 열어 보세요.';

  @override
  String get setupAssistantPreparingTitle => '부담 없이 시작할게요';

  @override
  String get setupAssistantPreparingBody =>
      '코드가 보이기 전에 몇 번의 탭으로 편안한 시작점을 먼저 맞춰둘게요.';

  @override
  String setupAssistantProgress(int current, int total) {
    return '$total단계 중 $current단계';
  }

  @override
  String get setupAssistantSkip => '건너뛰기';

  @override
  String get setupAssistantBack => '이전';

  @override
  String get setupAssistantNext => '다음';

  @override
  String get setupAssistantApply => '적용';

  @override
  String get setupAssistantGoalQuestionTitle => '이 생성기를 먼저 어디에 쓰고 싶나요?';

  @override
  String get setupAssistantGoalQuestionBody =>
      '가장 가까운 느낌을 고르세요. 나중에 언제든 바꿀 수 있어요.';

  @override
  String get setupAssistantGoalEarTitle => '코드를 듣고 익히기';

  @override
  String get setupAssistantGoalEarBody => '짧고 부담 없는 프롬프트로 듣기와 구분 연습을 해요.';

  @override
  String get setupAssistantGoalKeyboardTitle => '건반 손 연습';

  @override
  String get setupAssistantGoalKeyboardBody => '손에 먼저 잘 들어오는 쉬운 모양과 표기로 시작해요.';

  @override
  String get setupAssistantGoalSongTitle => '곡 아이디어';

  @override
  String get setupAssistantGoalSongBody => '너무 복잡하지 않게 음악적인 재료를 바로 꺼낼 수 있게 해요.';

  @override
  String get setupAssistantGoalHarmonyTitle => '화성 공부';

  @override
  String get setupAssistantGoalHarmonyBody =>
      '처음엔 명확하게, 나중에는 더 깊게 확장할 수 있게 해요.';

  @override
  String get setupAssistantLiteracyQuestionTitle => '지금 나에게 가장 가까운 문장은?';

  @override
  String get setupAssistantLiteracyQuestionBody => '잘하고 싶은 답보다 지금 편한 답을 골라주세요.';

  @override
  String get setupAssistantLiteracyAbsoluteTitle => 'C, Cm, C7, Cmaj7도 아직 헷갈린다';

  @override
  String get setupAssistantLiteracyAbsoluteBody => '표기와 진행을 최대한 읽기 쉽게 맞춰 드려요.';

  @override
  String get setupAssistantLiteracyBasicTitle => 'maj7 / m7 / 7 정도는 읽을 수 있다';

  @override
  String get setupAssistantLiteracyBasicBody => '안전하게 가되 범위를 조금 넓혀요.';

  @override
  String get setupAssistantLiteracyFunctionalTitle =>
      'ii-V-I와 다이아토닉 기능 흐름은 어느 정도 따라간다';

  @override
  String get setupAssistantLiteracyFunctionalBody => '명확한 화성에 약간의 움직임을 더해요.';

  @override
  String get setupAssistantLiteracyAdvancedTitle => '컬러풀한 리하모니와 익스텐션도 익숙하다';

  @override
  String get setupAssistantLiteracyAdvancedBody => '파워 유저용 범위를 더 많이 열어 둬요.';

  @override
  String get setupAssistantHandQuestionTitle => '건반에서 손은 어느 정도 편한가요?';

  @override
  String get setupAssistantHandQuestionBody => '무리 없는 보이싱 범위를 맞추는 데 쓸게요.';

  @override
  String get setupAssistantHandThreeTitle => '3음 정도가 편하다';

  @override
  String get setupAssistantHandThreeBody => '손 모양을 최대한 작게 유지해요.';

  @override
  String get setupAssistantHandFourTitle => '4음까지는 괜찮다';

  @override
  String get setupAssistantHandFourBody => '조금 더 넓은 모양도 허용해요.';

  @override
  String get setupAssistantHandJazzTitle => '재즈스러운 모양도 편하다';

  @override
  String get setupAssistantHandJazzBody => '나중에 더 큰 보이싱으로 넓혀 갈 수 있어요.';

  @override
  String get setupAssistantColorQuestionTitle => '처음엔 어느 정도 컬러감이 좋을까요?';

  @override
  String get setupAssistantColorQuestionBody => '헷갈리면 더 단순한 쪽이 좋아요.';

  @override
  String get setupAssistantColorSafeTitle => '안전하고 익숙하게';

  @override
  String get setupAssistantColorSafeBody => '읽기 쉬운 기본 화성에 가깝게 유지해요.';

  @override
  String get setupAssistantColorJazzyTitle => '조금 재즈스럽게';

  @override
  String get setupAssistantColorJazzyBody => '너무 과하지 않게 색을 조금 더해요.';

  @override
  String get setupAssistantColorColorfulTitle => '꽤 컬러풀하게';

  @override
  String get setupAssistantColorColorfulBody => '현대적인 색감을 더 많이 열어 둬요.';

  @override
  String get setupAssistantSymbolQuestionTitle => '어떤 코드 표기가 가장 읽기 편한가요?';

  @override
  String get setupAssistantSymbolQuestionBody => '보이는 표기만 바뀌고 화성 로직은 그대로예요.';

  @override
  String get setupAssistantSymbolMajTextBody => '가장 또렷하고 초보자에게 친절해요.';

  @override
  String get setupAssistantSymbolCompactBody => '짧은 표기가 이미 익숙하면 좋아요.';

  @override
  String get setupAssistantSymbolDeltaBody => '재즈 표기에 눈이 익었다면 좋아요.';

  @override
  String get setupAssistantKeyQuestionTitle => '어느 조부터 시작할까요?';

  @override
  String get setupAssistantKeyQuestionBody =>
      '기본 추천은 C major이고, 나중에 언제든 바꿀 수 있어요.';

  @override
  String get setupAssistantKeyCMajorBody => '가장 무난한 초보 시작점이에요.';

  @override
  String get setupAssistantKeyGMajorBody => '샵이 하나 있는 밝은 장조예요.';

  @override
  String get setupAssistantKeyFMajorBody => '플랫이 하나 있는 편안한 장조예요.';

  @override
  String get setupAssistantPreviewTitle => '이 설정이면 이렇게 시작해요';

  @override
  String get setupAssistantPreviewBody =>
      '대충 이런 느낌으로 생성됩니다. 시작 전에 더 쉽게 하거나 조금 더 재즈하게 바꿀 수 있어요.';

  @override
  String get setupAssistantPreviewListen => '샘플 들어보기';

  @override
  String get setupAssistantPreviewPlaying => '샘플 재생 중...';

  @override
  String get setupAssistantStartNow => '이대로 시작';

  @override
  String get setupAssistantAdjustEasier => '더 쉽게';

  @override
  String get setupAssistantAdjustJazzier => '조금 더 재즈하게';

  @override
  String get setupAssistantPreviewKeyLabel => '시작 조';

  @override
  String get setupAssistantPreviewNotationLabel => '표기';

  @override
  String get setupAssistantPreviewDifficultyLabel => '느낌';

  @override
  String get setupAssistantPreviewProgressionLabel => '샘플 진행';

  @override
  String get setupAssistantPreviewProgressionBody => '지금 설정으로 만든 짧은 4코드 예시입니다.';

  @override
  String get setupAssistantPreviewSummaryAbsolute => '초보 친화 시작';

  @override
  String get setupAssistantPreviewSummaryBasic => '읽기 편한 7화음 시작';

  @override
  String get setupAssistantPreviewSummaryFunctional => '기능 화성 중심 시작';

  @override
  String get setupAssistantPreviewSummaryAdvanced => '컬러가 있는 재즈 시작';

  @override
  String get setupAssistantPreviewBodyTriads =>
      '익숙한 트라이어드와 안전한 진행 위주로 시작해서 손과 눈에 부담을 줄입니다.';

  @override
  String get setupAssistantPreviewBodySevenths =>
      'maj7, m7, 7 정도는 보이되 전체 흐름은 차분하고 읽기 쉽게 유지합니다.';

  @override
  String get setupAssistantPreviewBodySafeExtensions =>
      '조금 더 색채는 생기지만 9, 11, 13 정도의 안전한 확장 안에서 머뭅니다.';

  @override
  String get setupAssistantPreviewBodyFullExtensions =>
      '더 풍부한 색채와 움직임을 허용해 재즈스러운 진행이 자연스럽게 나올 수 있습니다.';

  @override
  String get setupAssistantNotationMajText => 'Cmaj7 표기';

  @override
  String get setupAssistantNotationCompact => 'CM7 표기';

  @override
  String get setupAssistantNotationDelta => 'CΔ7 표기';

  @override
  String get setupAssistantDifficultyTriads => '단순한 트라이어드와 핵심 진행';

  @override
  String get setupAssistantDifficultySevenths => 'maj7 / m7 / 7 중심';

  @override
  String get setupAssistantDifficultySafeExtensions => '9 / 11 / 13 정도의 안전한 컬러';

  @override
  String get setupAssistantDifficultyFullExtensions => '넓은 컬러와 더 자유로운 진행';

  @override
  String get setupAssistantStudyHarmonyTitle => '기초 화성도 같이 시작할까요?';

  @override
  String get setupAssistantStudyHarmonyBody =>
      'Study Harmony에서 기본기를 같이 익히면 생성기를 더 덜 막막하게 시작할 수 있어요.';

  @override
  String get setupAssistantStudyHarmonyCta => 'Study Harmony 시작';

  @override
  String get setupAssistantGuidedSettingsTitle => '초보 친화 세팅 사용 중';

  @override
  String get setupAssistantGuidedSettingsBody =>
      '자주 쓰는 핵심만 여기 두고, 나머지 고급 옵션은 필요할 때 열 수 있게 정리했습니다.';

  @override
  String get setupAssistantAdvancedSectionTitle => '고급 설정 열기';

  @override
  String get setupAssistantAdvancedSectionBody =>
      '모든 생성 옵션을 보고 싶다면 전체 설정 페이지를 열어보세요.';

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
  String get practiceMeter => '박자표';

  @override
  String get practiceMeterHelp =>
      '각 마디의 박 수를 설정해 비트 표시, 자동 재생, 메트로놈 타이밍에 반영합니다.';

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
  String get harmonicRhythm => '화성 리듬';

  @override
  String get harmonicRhythmHelp => '마디 안에서 코드가 얼마나 자주 바뀔지 설정합니다.';

  @override
  String get harmonicRhythmOnePerBar => '마디당 1개';

  @override
  String get harmonicRhythmTwoPerBar => '마디당 2개';

  @override
  String get harmonicRhythmPhraseAwareJazz => '프레이즈 인지 재즈';

  @override
  String get harmonicRhythmCadenceCompression => '종지 압축';

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
  String get smartGeneratorHelp => '활성화된 논다이아토닉 옵션을 유지하면서 기능적 화성 진행을 우선합니다.';

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
  String get nonDiatonic => '논다이아토닉';

  @override
  String get nonDiatonicRequiresKeyMode => '논다이아토닉 옵션은 키 모드에서만 사용할 수 있습니다.';

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
  String get chordTypeFilters => '코드 종류';

  @override
  String get chordTypeFiltersHelp => '생성기에 표시할 코드 종류를 선택하세요.';

  @override
  String chordTypeFiltersSelection(int selected, int total) {
    return '$selected / $total 활성화';
  }

  @override
  String get chordTypeGroupTriads => '트라이어드';

  @override
  String get chordTypeGroupSevenths => '세븐스';

  @override
  String get chordTypeGroupSixthsAndAddedTone => '식스/부가음';

  @override
  String get chordTypeGroupDominantVariants => '도미넌트 변형';

  @override
  String get chordTypeRequiresKeyMode => 'V7sus4는 키를 하나 이상 선택했을 때만 사용할 수 있습니다.';

  @override
  String get chordTypeKeepOneEnabled => '최소 한 가지 코드 종류는 켜 두어야 합니다.';

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
  String get keyPracticeDescription => '선택한 키와 활성화된 로마 숫자로 다이아토닉 연습 문제를 생성합니다.';

  @override
  String get keyboardShortcutHelp =>
      'Space: 다음 코드  Enter: 자동 재생 시작/일시정지  위/아래: BPM 조절';

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
  String get pauseAutoplay => '자동 재생 일시정지';

  @override
  String get stopAutoplay => '자동 재생 중지';

  @override
  String get resetGeneratedChords => '생성된 코드 초기화';

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
  String get voicingDisplayMode => '보이싱 표시 모드';

  @override
  String get voicingDisplayModeHelp => '기존 3카드 보기와 연주 중심 현재/다음 미리보기 사이를 전환합니다.';

  @override
  String get voicingDisplayModeStandard => '표준';

  @override
  String get voicingDisplayModePerformance => '연주';

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
  String get maxVoicingNotes => '보이싱 최대 음 개수';

  @override
  String get lookAheadDepth => '앞보기 깊이';

  @override
  String get lookAheadDepthHelp => '랭킹 계산 시 고려할 미래 코드 수입니다.';

  @override
  String get showVoicingReasons => '보이싱 이유 표시';

  @override
  String get showVoicingReasonsHelp => '각 제안 카드에 짧은 설명 태그를 표시합니다.';

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
  String get voicingPerformanceSubtitle =>
      '대표 컴핑 보이싱 하나를 크게 보고, 다음 움직임까지 함께 확인하세요.';

  @override
  String get voicingPerformanceCurrentTitle => '현재 보이싱';

  @override
  String get voicingPerformanceNextTitle => '다음 미리보기';

  @override
  String get voicingPerformanceCurrentOnly => '현재만';

  @override
  String get voicingPerformanceShared => '공통음';

  @override
  String get voicingPerformanceNextOnly => '다음 이동';

  @override
  String voicingPerformanceTopLinePath(Object current, Object next) {
    return '탑라인: $current -> $next';
  }

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
      '레슨 데이터, 문제 문구, 정답 입력 UI는 이미 공통 학습 흐름으로 묶여 있어 음, 코드, 스케일, 진행 문제에 같은 구조를 재사용할 수 있습니다.';

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
  String get studyHarmonyContinueResumeHint => '가장 최근에 하던 수업부터 이어서 시작합니다.';

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
  String get studyHarmonyReviewFallbackHint => '아직 누적된 복습이 없어 현재 진행선으로 돌아갑니다.';

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
  String get studyHarmonyQuestFrontierTitle => '진도 밀기';

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
  String get studyHarmonySkillProgressionNonDiatonic => '진행의 논다이아토닉 코드 찾기';

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
    return '이 트랙은 아직 잠겨 있습니다. 오늘은 $coreTrack로 돌아가 계속 학습하세요.';
  }

  @override
  String get studyHarmonyCoreTrackTitle => '핵심 트랙';

  @override
  String get studyHarmonyCoreTrackDescription =>
      '음과 건반에서 시작해 코드, 스케일, 로마숫자, 다이아토닉 기초를 거쳐 짧은 코드 진행 분석까지 올라가는 기본 경로입니다.';

  @override
  String get studyHarmonyChapterNotesTitle => '1장: 음이름과 건반';

  @override
  String get studyHarmonyChapterNotesDescription =>
      '음이름을 건반에 연결하고 흰건반과 기본 임시표에 익숙해집니다.';

  @override
  String get studyHarmonyChapterChordsTitle => '2장: 코드 기초';

  @override
  String get studyHarmonyChapterChordsDescription =>
      '기본 3화음과 7화음의 구성음을 익히고, 구성음을 보고 흔한 코드 이름을 맞혀 봅니다.';

  @override
  String get studyHarmonyChapterScalesTitle => '3장: 스케일과 조성';

  @override
  String get studyHarmonyChapterScalesDescription =>
      '메이저와 마이너 스케일을 만든 뒤, 어떤 음이 조 안에 속하는지 찾아봅니다.';

  @override
  String get studyHarmonyChapterRomanTitle => '4장: 로마 숫자와 다이아토닉';

  @override
  String get studyHarmonyChapterRomanDescription =>
      '간단한 로마 숫자를 코드로 바꾸고, 코드를 로마 숫자로 읽고, 다이아토닉 기초를 기능별로 정리합니다.';

  @override
  String get studyHarmonyChapterProgressionDetectiveTitle => '5장: 코드 진행 탐정 I';

  @override
  String get studyHarmonyChapterProgressionDetectiveDescription =>
      '짧은 기본 진행을 보고 조성을 맞히고, 기능을 읽고, 어울리지 않는 코드를 찾아봅니다.';

  @override
  String get studyHarmonyChapterMissingChordTitle => '6장: 빈칸 코드 I';

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
  String get studyHarmonyPopTrackDescription =>
      '팝 전용 진행선에서 별도 진도, 데일리 추천, 복습 대기열로 전체 커리큘럼을 진행합니다.';

  @override
  String get studyHarmonyJazzTrackTitle => '재즈 트랙';

  @override
  String get studyHarmonyJazzTrackDescription =>
      '재즈 전용 진행선에서 별도 진도, 데일리 추천, 복습 대기열로 전체 커리큘럼을 연습합니다.';

  @override
  String get studyHarmonyClassicalTrackTitle => '클래식 트랙';

  @override
  String get studyHarmonyClassicalTrackDescription =>
      '클래식 전용 진행선에서 별도 진도, 데일리 추천, 복습 대기열로 전체 커리큘럼을 학습합니다.';

  @override
  String get studyHarmonyObjectiveQuickDrill => '빠른 드릴';

  @override
  String get studyHarmonyObjectiveBossReview => '보스 복습';

  @override
  String get studyHarmonyLessonNotesKeyboardTitle => '흰건반 음 찾기';

  @override
  String get studyHarmonyLessonNotesKeyboardDescription =>
      '음이름을 보고 맞는 흰건반을 탭하세요.';

  @override
  String get studyHarmonyLessonNotesPreviewTitle => '강조된 음 이름 맞히기';

  @override
  String get studyHarmonyLessonNotesPreviewDescription =>
      '강조된 건반을 보고 올바른 음이름을 고르세요.';

  @override
  String get studyHarmonyLessonNotesAccidentalsTitle => '검은건반의 두 이름';

  @override
  String get studyHarmonyLessonNotesAccidentalsDescription =>
      '검은건반의 샵/플랫 표기를 먼저 익혀 보세요.';

  @override
  String get studyHarmonyLessonNotesBossTitle => '보스: 빠른 음 찾기';

  @override
  String get studyHarmonyLessonNotesBossDescription =>
      '노트 읽기와 키보드 찾기를 하나의 짧은 속도 라운드로 혼합합니다.';

  @override
  String get studyHarmonyLessonTriadKeyboardTitle => '건반에서 3화음 만들기';

  @override
  String get studyHarmonyLessonTriadKeyboardDescription =>
      '일반적인 장3화음, 단3화음, 감3화음을 키보드에서 직접 구성해 보세요.';

  @override
  String get studyHarmonyLessonSeventhKeyboardTitle => '건반에서 7화음 만들기';

  @override
  String get studyHarmonyLessonSeventhKeyboardDescription =>
      '7음을 더해 몇 가지 흔한 7화음을 건반에서 직접 구성해 보세요.';

  @override
  String get studyHarmonyLessonChordNameTitle => '강조된 코드 이름 맞히기';

  @override
  String get studyHarmonyLessonChordNameDescription =>
      '강조 표시된 코드 모양을 읽고 올바른 코드 이름을 선택하세요.';

  @override
  String get studyHarmonyLessonChordsBossTitle => '보스: 3화음과 7화음 복습';

  @override
  String get studyHarmonyLessonChordsBossDescription =>
      '한 번의 혼합 복습에서 코드 스펠링과 코드 이름 맞히기를 오갑니다.';

  @override
  String get studyHarmonyLessonMajorScaleTitle => '메이저 스케일 만들기';

  @override
  String get studyHarmonyLessonMajorScaleDescription =>
      '단순한 메이저 스케일에 속하는 모든 음을 선택하세요.';

  @override
  String get studyHarmonyLessonMinorScaleTitle => '마이너 스케일 만들기';

  @override
  String get studyHarmonyLessonMinorScaleDescription =>
      '몇 가지 익숙한 조를 바탕으로 내추럴 마이너와 하모닉 마이너 스케일을 만들어 봅니다.';

  @override
  String get studyHarmonyLessonKeyMembershipTitle => '조성 구성음 찾기';

  @override
  String get studyHarmonyLessonKeyMembershipDescription =>
      '주어진 조에 속하는 음을 찾아보세요.';

  @override
  String get studyHarmonyLessonScalesBossTitle => '보스: 스케일 점검';

  @override
  String get studyHarmonyLessonScalesBossDescription =>
      '짧은 복습 라운드에서 스케일 만들기와 조성 구성음 찾기를 함께 연습합니다.';

  @override
  String get studyHarmonyLessonRomanToChordTitle => '로마 숫자 → 코드';

  @override
  String get studyHarmonyLessonRomanToChordDescription =>
      '조와 로마 숫자를 읽은 다음 일치하는 코드를 선택하세요.';

  @override
  String get studyHarmonyLessonChordToRomanTitle => '코드 → 로마 숫자';

  @override
  String get studyHarmonyLessonChordToRomanDescription =>
      '키 내부의 코드를 읽고 일치하는 로마 숫자를 선택하세요.';

  @override
  String get studyHarmonyLessonDiatonicityTitle => '다이아토닉 판별';

  @override
  String get studyHarmonyLessonDiatonicityDescription =>
      '간단한 조에서 코드를 다이아토닉과 논다이아토닉으로 나눠 봅니다.';

  @override
  String get studyHarmonyLessonFunctionTitle => '기능 기초';

  @override
  String get studyHarmonyLessonFunctionDescription =>
      '쉬운 코드를 토닉, 프리도미넌트, 도미넌트로 분류합니다.';

  @override
  String get studyHarmonyLessonRomanBossTitle => '보스: 기능 기초 믹스';

  @override
  String get studyHarmonyLessonRomanBossDescription =>
      '로마 숫자→코드, 코드→로마 숫자, 다이아토닉 판별, 기능 읽기를 함께 복습합니다.';

  @override
  String get studyHarmonyLessonProgressionKeyCenterTitle => '조성 찾기';

  @override
  String get studyHarmonyLessonProgressionKeyCenterDescription =>
      '짧은 코드 진행을 보고 가장 자연스러운 중심 조성을 고릅니다.';

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
  String get studyHarmonyLessonProgressionBossTitle => '보스: 혼합 분석';

  @override
  String get studyHarmonyLessonProgressionBossDescription =>
      '중심 조성 읽기, 기능 판별, 논다이아토닉 찾기를 짧은 탐정 라운드에서 함께 복습합니다.';

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
  String get studyHarmonyLessonMissingChordBossTitle => '보스: 혼합 빈칸 채우기';

  @override
  String get studyHarmonyLessonMissingChordBossDescription =>
      '기능과 흐름을 더 강하게 요구하는 빈칸 채우기 문제를 짧게 섞어 풉니다.';

  @override
  String get studyHarmonyChapterCheckpointTitle => '체크포인트 건틀렛';

  @override
  String get studyHarmonyChapterCheckpointDescription =>
      '중심 조성, 기능, 컬러, 빈칸 채우기를 더 빠른 혼합 복습 세트로 묶어 봅니다.';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushTitle => '종지 러시';

  @override
  String get studyHarmonyLessonCheckpointCadenceRushDescription =>
      '화성 기능을 빠르게 읽고, 이어서 빠진 종지 코드를 가벼운 압박 속에서 채워 넣으세요.';

  @override
  String get studyHarmonyLessonCheckpointColorKeyTitle => '컬러와 조성 전환';

  @override
  String get studyHarmonyLessonCheckpointColorKeyDescription =>
      '중심 조성 판별과 논다이아토닉 색채 판별을 번갈아 처리하면서도 흐름을 놓치지 마세요.';

  @override
  String get studyHarmonyLessonCheckpointBossTitle => '보스: 체크포인트 건틀렛';

  @override
  String get studyHarmonyLessonCheckpointBossDescription =>
      '중심 조성, 기능, 컬러, 종지 복원을 한 번에 섞은 통합 체크포인트를 클리어하세요.';

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
      '모달 컬러를 재빨리 포착하고, 흐트러지기 전에 중심 조성까지 확인하세요.';

  @override
  String get studyHarmonyLessonCapstoneResolutionTitle => '리졸루션 랩';

  @override
  String get studyHarmonyLessonCapstoneResolutionDescription =>
      '프레이즈가 어디로 해소되려는지 따라가며 가장 설득력 있는 코드를 고르세요.';

  @override
  String get studyHarmonyLessonCapstoneBossTitle => '보스: 최종 진행 시험';

  @override
  String get studyHarmonyLessonCapstoneBossDescription =>
      '중심 조성, 기능, 컬러, 해소를 모두 압박감 있게 섞은 최종 혼합 시험을 통과하세요.';

  @override
  String studyHarmonyPromptFindNoteOnKeyboard(Object note) {
    return '건반에서 $note를 찾으세요.';
  }

  @override
  String get studyHarmonyPromptNameHighlightedNote => '강조된 음은 무엇인가요?';

  @override
  String studyHarmonyPromptFindChordOnKeyboard(Object chord) {
    return '건반에서 $chord를 구성하세요.';
  }

  @override
  String get studyHarmonyPromptNameHighlightedChord => '강조된 코드는 무엇인가요?';

  @override
  String studyHarmonyPromptBuildScale(Object scaleName) {
    return '$scaleName에 들어가는 모든 음을 고르세요.';
  }

  @override
  String studyHarmonyPromptKeyMembership(Object keyName) {
    return '$keyName에 속하는 음을 고르세요.';
  }

  @override
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman) {
    return '$keyName에서 $roman에 해당하는 코드는 무엇인가요?';
  }

  @override
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord) {
    return '$keyName에서 $chord에 해당하는 로마 숫자는 무엇인가요?';
  }

  @override
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord) {
    return '$keyName에서 $chord는 다이아토닉인가요?';
  }

  @override
  String studyHarmonyPromptFunction(Object keyName, Object chord) {
    return '$keyName에서 $chord에는 어떤 기능이 있나요?';
  }

  @override
  String get studyHarmonyProgressionStripLabel => '진행';

  @override
  String get studyHarmonyPromptProgressionKeyCenter =>
      '이 진행에 가장 잘 맞는 중심 조성은 무엇인가요?';

  @override
  String studyHarmonyPromptProgressionFunction(Object chord) {
    return '$chord는 여기서 어떤 기능을 하나요?';
  }

  @override
  String get studyHarmonyPromptProgressionNonDiatonic =>
      '이 진행에서 가장 논다이아토닉하게 들리는 코드는 무엇인가요?';

  @override
  String get studyHarmonyPromptProgressionMissingChord =>
      '빈칸에 가장 잘 들어갈 코드는 무엇인가요?';

  @override
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel) {
    return '가능한 해석 중 하나는 이 진행을 $keyLabel 중심으로 읽는 것입니다.';
  }

  @override
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord는 이 문맥에서 $functionLabel 기능으로 들을 수 있는 후보입니다.';
  }

  @override
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  ) {
    return '$chord는 주된 $keyLabel 읽기 바깥에 있어서, 논다이아토닉 컬러로 들릴 가능성이 있습니다.';
  }

  @override
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  ) {
    return '$chord를 넣으면 이 진행의 $functionLabel 흐름이 어느 정도 복원될 수 있습니다.';
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
  String get studyHarmonyChoiceDiatonic => '다이아토닉';

  @override
  String get studyHarmonyChoiceNonDiatonic => '논다이아토닉';

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
  String get chordAnalyzerSubtitle => '진행을 넣으면 조성, 로마 숫자, 화성 기능을 바로 확인합니다.';

  @override
  String get chordAnalyzerInputLabel => '코드 진행';

  @override
  String get chordAnalyzerInputHint => 'Dm7, G7 | ? Am';

  @override
  String get chordAnalyzerInputHelper =>
      '코드 사이에는 Spacebar, |, 쉼표를 쓸 수 있습니다. 괄호 안의 쉼표는 같은 코드 안의 텐션 구분자로 유지됩니다.\n\n?는 아직 정하지 않은 코드 자리를 뜻합니다. 분석기는 앞뒤 화성 맥락을 바탕으로 가장 자연스러운 채움을 추론하고, 해석이 모호하면 후보도 함께 제안합니다. 변주 만들기에서는 그 자리를 더 자유롭게 리하모나이즈할 수 있습니다.\n\n소문자 루트, 슬래시 베이스, sus/alt/add 표기와 C7(b9, #11) 같은 괄호형 텐션을 지원합니다.\n\n터치 기기에서는 코드 패드를 쓰거나, 자유 입력이 필요할 때 ABC 입력으로 전환할 수 있습니다.';

  @override
  String get chordAnalyzerInputHelpTitle => '입력 팁';

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
  String get chordAnalyzerClear => 'Reset';

  @override
  String get chordAnalyzerBackspace => '⌫';

  @override
  String get chordAnalyzerSpace => 'Spacebar';

  @override
  String get chordAnalyzerAnalyzing => '진행을 분석하는 중...';

  @override
  String get chordAnalyzerInitialTitle => '진행을 입력해 보세요';

  @override
  String get chordAnalyzerInitialBody =>
      'Dm7, G7 | ? Am 또는 Cmaj7 | Am7 D7 | Gmaj7 같은 진행을 입력하면 가능한 조성, 로마 숫자, 추론된 채움, 짧은 요약을 볼 수 있습니다.';

  @override
  String get chordAnalyzerPlaceholderExplanation =>
      '이 ?는 앞뒤 화성 맥락을 바탕으로 추론한 자리이므로, 확정값보다 제안된 채움으로 보는 편이 좋습니다.';

  @override
  String chordAnalyzerSuggestedFill(Object chord) {
    return '추천 채움 화음: $chord';
  }

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
    return '중심 조성이 $primary와 $alternative 사이에서 아직 다소 모호합니다.';
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
    return '무시된 수식어: $details';
  }

  @override
  String get chordAnalyzerGenerateVariations => '변주 만들기';

  @override
  String get chordAnalyzerVariationsTitle => '자연스러운 변주';

  @override
  String get chordAnalyzerVariationsBody =>
      '같은 흐름을 유지하면서 가까운 기능 대체 화음으로 색감을 바꾼 제안입니다. 적용하면 바로 다시 분석합니다.';

  @override
  String get chordAnalyzerApplyVariation => '이 변주 적용';

  @override
  String get chordAnalyzerVariationCadentialColorTitle => '종지 색채';

  @override
  String get chordAnalyzerVariationCadentialColorBody =>
      '도착점은 유지한 채 프리도미넌트를 더 어둡게 만들고 트라이톤 서브 도미넌트로 바꿉니다.';

  @override
  String get chordAnalyzerVariationBackdoorTitle => '백도어 컬러';

  @override
  String get chordAnalyzerVariationBackdoorBody =>
      '평행단조의 ivm7-bVII7 색채로 같은 토닉에 착지합니다.';

  @override
  String get chordAnalyzerVariationAppliedApproachTitle => '타깃 ii-V';

  @override
  String get chordAnalyzerVariationAppliedApproachBody =>
      '같은 목적 화음으로 향하는 관련 ii-V를 다시 세웁니다.';

  @override
  String get chordAnalyzerVariationMinorCadenceTitle => '단조 종지 색채';

  @override
  String get chordAnalyzerVariationMinorCadenceBody =>
      '단조 종지는 유지하면서 iiø-Valt-i 색채를 더합니다.';

  @override
  String get chordAnalyzerVariationColorLiftTitle => '컬러 리프트';

  @override
  String get chordAnalyzerVariationColorLiftBody =>
      '루트와 기능은 가깝게 두고, 자연스러운 익스텐션으로 표정을 바꿉니다.';

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
      '얼터드 도미넌트 색채가 도미넌트 기능 해석을 뒷받침합니다.';

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
    return '지원하지 않는 접미 표기 또는 수식어입니다: $suffix';
  }

  @override
  String get chordAnalyzerDisplaySettings => '분석 표시';

  @override
  String get chordAnalyzerDisplaySettingsHelp =>
      '이론 설명의 깊이와 비다이어토닉 범주의 강조 색상을 조절합니다.';

  @override
  String get chordAnalyzerQuickStartHint =>
      '예시를 누르면 바로 결과를 볼 수 있고, 데스크톱에서는 Ctrl+Enter로도 분석할 수 있어요.';

  @override
  String get chordAnalyzerDetailLevel => '설명 상세도';

  @override
  String get chordAnalyzerDetailLevelConcise => '간단히';

  @override
  String get chordAnalyzerDetailLevelDetailed => '자세히';

  @override
  String get chordAnalyzerDetailLevelAdvanced => '고급';

  @override
  String get chordAnalyzerHighlightTheme => '강조 테마';

  @override
  String get chordAnalyzerThemePresetDefault => '기본';

  @override
  String get chordAnalyzerThemePresetHighContrast => '고대비';

  @override
  String get chordAnalyzerThemePresetColorBlindSafe => '색각 이상 배려';

  @override
  String get chordAnalyzerThemePresetCustom => '사용자 지정';

  @override
  String get chordAnalyzerThemeLegend => '범례';

  @override
  String get chordAnalyzerCustomColors => '범주별 사용자 색상';

  @override
  String get chordAnalyzerHighlightAppliedDominant => '적용 도미넌트';

  @override
  String get chordAnalyzerHighlightTritoneSubstitute => '트라이톤 대리';

  @override
  String get chordAnalyzerHighlightTonicization => '일시적 조성화';

  @override
  String get chordAnalyzerHighlightModulation => '전조';

  @override
  String get chordAnalyzerHighlightBackdoor => '백도어 / 서브도미넌트 마이너';

  @override
  String get chordAnalyzerHighlightBorrowedColor => '차용 화성 색채';

  @override
  String get chordAnalyzerHighlightCommonTone => '공통음 진행';

  @override
  String get chordAnalyzerHighlightDeceptiveCadence => '기만 종지';

  @override
  String get chordAnalyzerHighlightChromaticLine => '반음계 라인 색채';

  @override
  String get chordAnalyzerHighlightAmbiguity => '해석 중첩';

  @override
  String chordAnalyzerSummaryRealModulation(Object key) {
    return '$key(으)로의 실제 전조로 읽을 근거가 더 강합니다.';
  }

  @override
  String chordAnalyzerSummaryTonicization(Object target) {
    return '$target을 잠시 중심처럼 만들지만 완전히 정착하지는 않습니다.';
  }

  @override
  String get chordAnalyzerSummaryBackdoor =>
      '해결 직전에 백도어 또는 서브도미넌트 마이너 색채가 드러납니다.';

  @override
  String get chordAnalyzerSummaryDeceptiveCadence =>
      '한 종지가 예상한 토닉 대신 다른 곳으로 비껴 가며 기만 효과를 냅니다.';

  @override
  String get chordAnalyzerSummaryChromaticLine =>
      '구간 일부를 잇는 반음계 내성선 또는 line-cliche 색채가 보입니다.';

  @override
  String chordAnalyzerSummaryBackdoorDominant(Object chord) {
    return '$chord는 단순 차용 도미넌트보다 백도어 도미넌트로 읽는 편이 자연스럽습니다.';
  }

  @override
  String chordAnalyzerSummarySubdominantMinor(Object chord) {
    return '$chord는 뜬금없는 비다이어토닉 화음보다 서브도미넌트 마이너 색채로 읽는 편이 자연스럽습니다.';
  }

  @override
  String chordAnalyzerSummaryCommonToneDiminished(Object chord) {
    return '$chord는 공통음을 유지하며 해결되는 감화음 색채로 들을 수 있습니다.';
  }

  @override
  String chordAnalyzerSummaryDeceptiveTarget(Object chord) {
    return '$chord는 정격 종지보다 기만적 도착점에 참여합니다.';
  }

  @override
  String chordAnalyzerSummaryCompeting(Object readings) {
    return '고급 해석에서는 $readings 같은 경쟁 해석을 함께 유지합니다.';
  }

  @override
  String chordAnalyzerFunctionLine(Object function) {
    return '기능: $function';
  }

  @override
  String chordAnalyzerEvidenceLead(Object evidence) {
    return '근거: $evidence';
  }

  @override
  String chordAnalyzerAdvancedCompetingReadings(Object readings) {
    return '여기서는 $readings 같은 경쟁 해석도 계속 가능합니다.';
  }

  @override
  String chordAnalyzerRemarkTonicization(Object target) {
    return '완전한 전조보다는 $target의 일시적 조성화로 들립니다.';
  }

  @override
  String chordAnalyzerRemarkRealModulation(Object key) {
    return '$key(으)로 실제 전조가 이루어진 것으로 볼 근거가 있습니다.';
  }

  @override
  String get chordAnalyzerRemarkBackdoorDominant =>
      '서브도미넌트 마이너 색채를 가진 백도어 도미넌트로 들을 수 있습니다.';

  @override
  String get chordAnalyzerRemarkBackdoorChain =>
      '단순 차용 우회보다 백도어 체인에 속하는 흐름입니다.';

  @override
  String get chordAnalyzerRemarkSubdominantMinor =>
      '차용 iv 또는 서브도미넌트 마이너 색채가 프리도미넌트처럼 작동합니다.';

  @override
  String get chordAnalyzerRemarkCommonToneDiminished =>
      '이 감화음은 공통음 재해석으로 기능합니다.';

  @override
  String get chordAnalyzerRemarkPivotChord =>
      '다음 국소 조성으로 넘어가는 pivot chord 역할을 할 수 있습니다.';

  @override
  String get chordAnalyzerRemarkCommonToneModulation =>
      '공통음의 연속성이 이 전조를 더 그럴듯하게 만듭니다.';

  @override
  String get chordAnalyzerRemarkDeceptiveCadence =>
      '직접 토닉으로 가지 않고 기만 종지 쪽으로 향합니다.';

  @override
  String get chordAnalyzerRemarkLineCliche => '반음계 내성선 움직임이 이 화음 선택에 색채를 줍니다.';

  @override
  String get chordAnalyzerRemarkDualFunction =>
      '둘 이상의 기능 해석이 여전히 설득력 있게 남아 있습니다.';

  @override
  String get chordAnalyzerTagTonicization => '일시적 조성화';

  @override
  String get chordAnalyzerTagRealModulation => '실제 전조';

  @override
  String get chordAnalyzerTagBackdoorChain => '백도어 체인';

  @override
  String get chordAnalyzerTagDeceptiveCadence => '기만 종지';

  @override
  String get chordAnalyzerTagChromaticLine => '반음계 라인 색채';

  @override
  String get chordAnalyzerTagCommonToneMotion => '공통음 진행';

  @override
  String get chordAnalyzerEvidenceCadentialArrival =>
      '국소적 종지 도착이 임시 목표 중심을 뒷받침합니다.';

  @override
  String get chordAnalyzerEvidenceFollowThrough =>
      '뒤따르는 화음들도 새 국소 중심을 계속 지지합니다.';

  @override
  String get chordAnalyzerEvidencePhraseBoundary =>
      '구조적 강세나 프레이즈 경계 부근에서 변화가 일어납니다.';

  @override
  String get chordAnalyzerEvidencePivotSupport =>
      '공유 가능한 pivot 해석이 국소적 이동을 뒷받침합니다.';

  @override
  String get chordAnalyzerEvidenceCommonToneSupport =>
      '공통음 유지가 재해석 연결을 자연스럽게 만듭니다.';

  @override
  String get chordAnalyzerEvidenceHomeGravityWeakening =>
      '이 구간에서는 원래 토닉의 중력이 다소 약해집니다.';

  @override
  String get chordAnalyzerEvidenceBackdoorMotion =>
      '이 진행은 백도어 또는 서브도미넌트 마이너 해결 패턴과 맞습니다.';

  @override
  String get chordAnalyzerEvidenceDeceptiveResolution =>
      '도미넌트가 예상한 토닉이 아닌 다른 곳으로 해결됩니다.';

  @override
  String chordAnalyzerEvidenceChromaticLine(Object detail) {
    return '반음계 라인 근거: $detail.';
  }

  @override
  String chordAnalyzerEvidenceCompetingReading(Object detail) {
    return '경쟁 해석: $detail.';
  }

  @override
  String get studyHarmonyDailyReplayAction => '오늘의 도전 다시 하기';

  @override
  String get studyHarmonyMilestoneCabinetTitle => '성취 기록';

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
  String get studyHarmonyChapterRemixTitle => '고급 진행 혼합';

  @override
  String get studyHarmonyChapterRemixDescription =>
      '중심 조성, 기능, 차용 색채를 예고 없이 섞어 읽는 후반부 종합 구간입니다.';

  @override
  String get studyHarmonyLessonRemixBridgeTitle => '브리지 빌더';

  @override
  String get studyHarmonyLessonRemixBridgeDescription =>
      '기능 읽기와 빈칸 채우기를 한 흐름의 진행으로 이어 붙입니다.';

  @override
  String get studyHarmonyLessonRemixPivotTitle => '컬러 피벗';

  @override
  String get studyHarmonyLessonRemixPivotDescription =>
      '진행이 흔들릴 때 차용 화음과 중심 조성 전환 지점을 포착합니다.';

  @override
  String get studyHarmonyLessonRemixSprintTitle => '리졸루션 스프린트';

  @override
  String get studyHarmonyLessonRemixSprintDescription =>
      '기능, 종지 채우기, 조성 중력을 더 빠르게 연달아 읽어냅니다.';

  @override
  String get studyHarmonyLessonRemixBossTitle => '고급 진행 종합';

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
  String get studyHarmonyModeFocus => '약점 집중 훈련';

  @override
  String get studyHarmonyModeLegend => '최고 난도 도전';

  @override
  String get studyHarmonyFocusCardTitle => '약점 집중 훈련';

  @override
  String get studyHarmonyFocusCardHint =>
      '현재 약한 지점이 겹치는 구간을 적은 목숨과 더 빡빡한 목표로 집중 공략합니다.';

  @override
  String get studyHarmonyFocusFallbackHint => '현재 약점을 짧고 강하게 압축한 혼합 드릴입니다.';

  @override
  String get studyHarmonyFocusAction => '스프린트 시작';

  @override
  String get studyHarmonyFocusSessionTitle => '약점 집중 훈련';

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
  String get studyHarmonyLegendCardTitle => '최고 난도 도전';

  @override
  String get studyHarmonyLegendCardHint =>
      '실버 이상 챕터를 목숨 2개짜리 마스터리 런으로 다시 돌파해 레전드 크라운을 확보하세요.';

  @override
  String get studyHarmonyLegendFallbackHint =>
      '챕터를 클리어하고 레슨당 평균 2별 정도까지 올리면 최고 난도 도전이 열립니다.';

  @override
  String get studyHarmonyLegendAction => '도전 시작';

  @override
  String get studyHarmonyLegendSessionTitle => '최고 난도 도전';

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
  String get studyHarmonyWeeklyGoalFocusTitle => '약점 집중 훈련 완료';

  @override
  String studyHarmonyWeeklyGoalFocusBody(Object target) {
    return '이번 주에 약점 집중 훈련을 $target회 완료하세요.';
  }

  @override
  String get studyHarmonyResultStreakSaverUsedLine =>
      '어제의 공백을 보호하기 위해 Streak Saver를 사용했습니다.';

  @override
  String studyHarmonyResultStreakSaverEarnedLine(Object count) {
    return '새 Streak Saver를 획득했습니다. 현재 보유: $count';
  }

  @override
  String get studyHarmonyResultFocusSprintLine => '약점 집중 훈련을 클리어했습니다.';

  @override
  String studyHarmonyResultLegendLine(Object chapter) {
    return '$chapter 레전드 크라운을 확보했습니다.';
  }

  @override
  String get studyHarmonyChapterEncoreTitle => '최종 압축 훈련';

  @override
  String get studyHarmonyChapterEncoreDescription =>
      '지금까지의 진행 읽기 도구를 짧고 진하게 압축한 마지막 앙코르 구간입니다.';

  @override
  String get studyHarmonyLessonEncorePulseTitle => '토널 펄스';

  @override
  String get studyHarmonyLessonEncorePulseDescription =>
      '워밍업 없이 바로 중심 조성과 기능을 고정해서 읽어냅니다.';

  @override
  String get studyHarmonyLessonEncoreSwapTitle => '컬러 스왑';

  @override
  String get studyHarmonyLessonEncoreSwapDescription =>
      '차용 색채 판별과 빈칸 코드 복원을 번갈아 처리하며 감각을 다집니다.';

  @override
  String get studyHarmonyLessonEncoreBossTitle => '최종 압축 보스';

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
  String get studyHarmonyModeBossRush => '보스 연속 도전';

  @override
  String get studyHarmonyBossRushCardTitle => '보스 연속 도전';

  @override
  String get studyHarmonyBossRushCardHint =>
      '해금한 보스 레슨들을 더 적은 목숨으로 연속 돌파하는 고위험 혼합 러시입니다.';

  @override
  String get studyHarmonyBossRushFallbackHint =>
      '보스 레슨 두 개 이상을 열면 더 긴장감 있는 러시 모드가 열립니다.';

  @override
  String get studyHarmonyBossRushAction => '러시 시작';

  @override
  String get studyHarmonyBossRushSessionTitle => '보스 연속 도전';

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
  String get studyHarmonyResultBossRushLine => '보스 연속 도전을 클리어했습니다.';

  @override
  String get studyHarmonyChapterSpotlightTitle => '스포트라이트 쇼다운';

  @override
  String get studyHarmonyChapterSpotlightDescription =>
      '차용 색채, 종지 압박, 보스급 통합 판별을 정면으로 다루는 최종 스포트라이트 구간입니다.';

  @override
  String get studyHarmonyLessonSpotlightLensTitle => '차용 렌즈';

  @override
  String get studyHarmonyLessonSpotlightLensDescription =>
      '차용 색채가 시선을 흔들어도 중심 조성을 놓치지 않고 추적합니다.';

  @override
  String get studyHarmonyLessonSpotlightCadenceTitle => '종지 스왑';

  @override
  String get studyHarmonyLessonSpotlightCadenceDescription =>
      '기능 읽기와 종지 복원을 번갈아 처리하면서도 해결 지점을 놓치지 않습니다.';

  @override
  String get studyHarmonyLessonSpotlightBossTitle => '스포트라이트 쇼다운';

  @override
  String get studyHarmonyLessonSpotlightBossDescription =>
      '진행 읽기 전 관점을 압박 속에서도 끝까지 유지해야 하는 최종 보스 세트입니다.';

  @override
  String get studyHarmonyChapterAfterHoursTitle => '애프터 아워 랩';

  @override
  String get studyHarmonyChapterAfterHoursDescription =>
      '워밍업 힌트를 걷어내고 차용 색채, 종지 압박, 중심 조성 추적을 거칠게 다시 섞는 후반부 실험 구간입니다.';

  @override
  String get studyHarmonyLessonAfterHoursShadowTitle => '모달 섀도우';

  @override
  String get studyHarmonyLessonAfterHoursShadowDescription =>
      '차용 색채가 읽기를 어둡게 흔들어도 중심 조성을 놓치지 않고 붙잡습니다.';

  @override
  String get studyHarmonyLessonAfterHoursFeintTitle => '리졸루션 페인트';

  @override
  String get studyHarmonyLessonAfterHoursFeintDescription =>
      '기능과 종지 페이크를 읽어내며 진짜 해결 지점을 끝까지 추적합니다.';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeTitle => '센터 크로스페이드';

  @override
  String get studyHarmonyLessonAfterHoursCrossfadeDescription =>
      '중심 조성 판별, 기능 읽기, 빈칸 코드 복원을 추가 힌트 없이 한 흐름으로 묶습니다.';

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
  String get studyHarmonyModeRelay => '챕터 혼합 도전';

  @override
  String get studyHarmonyRelayCardTitle => '챕터 혼합 도전';

  @override
  String get studyHarmonyRelayCardHint =>
      '서로 다른 챕터의 해금 레슨을 한 세션에 섞어 푸는 인터리빙 런입니다. 전환 적응력까지 같이 점검합니다.';

  @override
  String get studyHarmonyRelayFallbackHint =>
      '서로 다른 챕터가 두 개 이상 열리면 챕터 혼합 도전이 열립니다.';

  @override
  String get studyHarmonyRelayAction => '릴레이 시작';

  @override
  String get studyHarmonyRelaySessionTitle => '챕터 혼합 도전';

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
    return '챕터 혼합 도전 승리 $count회';
  }

  @override
  String get studyHarmonyMilestoneRelayTitle => '릴레이 러너';

  @override
  String studyHarmonyMilestoneRelayBody(Object target) {
    return '챕터 혼합 도전을 $target회 클리어하세요.';
  }

  @override
  String get studyHarmonyChapterNeonTitle => '후반 전환 훈련';

  @override
  String get studyHarmonyChapterNeonDescription =>
      '차용 색채, 중심 전환, 착지 복원을 번갈아 흔들며 읽기 정확도를 끝까지 시험하는 후반부 종합 챕터입니다.';

  @override
  String get studyHarmonyLessonNeonDetourTitle => '차용 전환 읽기';

  @override
  String get studyHarmonyLessonNeonDetourDescription =>
      '차용 색채가 진행을 옆길로 끌어도 실제 중심 조성을 끝까지 추적합니다.';

  @override
  String get studyHarmonyLessonNeonPivotTitle => '전환 압박 읽기';

  @override
  String get studyHarmonyLessonNeonPivotDescription =>
      '중심 조성 전환과 기능 압박을 연속으로 읽으며 다음 전환을 대비합니다.';

  @override
  String get studyHarmonyLessonNeonLandingTitle => '차용 랜딩';

  @override
  String get studyHarmonyLessonNeonLandingDescription =>
      '차용 색채 페이크 이후 비어 있는 착지 화음을 복원하며 진짜 해결 지점을 되찾습니다.';

  @override
  String get studyHarmonyLessonNeonBossTitle => '전환 종합 보스';

  @override
  String get studyHarmonyLessonNeonBossDescription =>
      '피벗 읽기, 차용 색채, 종지 복원을 한 번에 섞어 부드러운 착지 없이 밀어붙이는 네온 보스입니다.';

  @override
  String studyHarmonyProgressLeague(Object tier) {
    return '$tier 리그';
  }

  @override
  String get studyHarmonyLeagueCardTitle => '주간 등급';

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
  String get studyHarmonyHubStartHereTitle => '지금 시작';

  @override
  String get studyHarmonyHubNextLessonTitle => '다음 레슨';

  @override
  String get studyHarmonyHubWhyItMattersTitle => '왜 중요한가';

  @override
  String get studyHarmonyHubQuickPracticeTitle => '빠른 연습';

  @override
  String get studyHarmonyHubMetaPreviewTitle => '다음 메타는 곧 열립니다';

  @override
  String get studyHarmonyHubMetaPreviewHeadline => '먼저 작은 학습 흐름부터 만드세요';

  @override
  String get studyHarmonyHubMetaPreviewBody =>
      '리그, 상점, 보상 시스템은 몇 개의 레슨을 마친 뒤에 더 유용하게 열립니다. 지금은 다음 레슨 하나와 짧은 연습 한 번에 집중하면 충분합니다.';

  @override
  String get studyHarmonyHubPlayNowAction => '바로 시작';

  @override
  String get studyHarmonyHubKeepMomentumAction => '흐름 이어가기';

  @override
  String get studyHarmonyClearTitleAction => '칭호 해제';

  @override
  String get studyHarmonyPlayerDeckTitle => '플레이어 덱';

  @override
  String get studyHarmonyPlayerDeckCardTitle => '플레이스타일';

  @override
  String get studyHarmonyPlayerDeckOverviewAction => '개요';

  @override
  String get studyHarmonyRunDirectorTitle => '런 디렉터';

  @override
  String get studyHarmonyRunDirectorAction => '추천으로 시작';

  @override
  String get studyHarmonyGameEconomyTitle => '게임 재화';

  @override
  String get studyHarmonyGameEconomyBody =>
      '상점 재고, 유틸리티 토큰, 메타 보상은 최근 플레이 흐름에 따라 달라집니다.';

  @override
  String studyHarmonyGameEconomyTitlesOwned(int count) {
    return '칭호 $count개 보유';
  }

  @override
  String studyHarmonyGameEconomyCosmeticsOwned(int count) {
    return '코스메틱 $count개 보유';
  }

  @override
  String studyHarmonyGameEconomyShopPurchases(int count) {
    return '상점 구매 $count회';
  }

  @override
  String get studyHarmonyGameEconomyWalletAction => '지갑 보기';

  @override
  String get studyHarmonyArcadeSpotlightTitle => '아케이드 스포트라이트';

  @override
  String get studyHarmonyArcadePlayAction => '아케이드 시작';

  @override
  String studyHarmonyArcadeModeCount(int count) {
    return '모드 $count개';
  }

  @override
  String get studyHarmonyArcadePlaylistAction => '세트 시작';

  @override
  String get studyHarmonyNightMarketTitle => '나이트 마켓';

  @override
  String studyHarmonyPurchaseSuccess(Object itemTitle) {
    return '$itemTitle 구매 완료';
  }

  @override
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle) {
    return '$itemTitle 구매 후 바로 장착했습니다';
  }

  @override
  String studyHarmonyPurchaseFailure(Object itemTitle) {
    return '$itemTitle 구매 조건이 아직 맞지 않습니다';
  }

  @override
  String studyHarmonyRewardEquipped(Object itemTitle) {
    return '$itemTitle 장착 완료';
  }

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
  String get studyHarmonyQuestChestReadyHeadline => '퀘스트 상자 준비 완료';

  @override
  String get studyHarmonyQuestChestOpenedHeadline => '오늘의 퀘스트 상자 개봉 완료';

  @override
  String get studyHarmonyQuestChestBoostHeadline => '2배 리그 XP 활성화';

  @override
  String studyHarmonyQuestChestRewardLabel(Object xp) {
    return '보상: 리그 XP +$xp';
  }

  @override
  String get studyHarmonyQuestChestLockedBody =>
      '오늘의 퀘스트 3종을 마치면 보너스 퀘스트 상자가 열리고 주간 리그 XP를 추가로 받습니다.';

  @override
  String get studyHarmonyQuestChestReadyBody =>
      '오늘의 퀘스트 3종이 모두 끝났습니다. 아무 런이나 하나 더 클리어하면 퀘스트 상자 보상이 리그 XP로 반영됩니다.';

  @override
  String get studyHarmonyQuestChestOpenedBody =>
      '오늘의 퀘스트 3종을 모두 끝내서 퀘스트 상자 보상이 이미 리그 XP로 반영됐습니다.';

  @override
  String studyHarmonyQuestChestOpenedBoostBody(Object count) {
    return '오늘의 퀘스트 상자를 열었고 다음 $count번 클리어에는 2배 리그 XP가 적용됩니다.';
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
  String get studyHarmonyResultQuestChestLine => '퀘스트 상자를 열었습니다.';

  @override
  String studyHarmonyResultQuestChestXpLine(Object count) {
    return '퀘스트 상자 보너스 리그 XP +$count';
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
  String get studyHarmonyChapterSkylineTitle => '최종 중심 읽기';

  @override
  String get studyHarmonyChapterSkylineDescription =>
      '흔들리는 중심, 차용 중력, 가짜 귀착을 빠르게 섞어 읽어야 하는 최종 스카이라인 챕터입니다.';

  @override
  String get studyHarmonyLessonSkylinePulseTitle => '잔상 펄스';

  @override
  String get studyHarmonyLessonSkylinePulseDescription =>
      '진행이 새 레인으로 잠기기 전에 잔상 속 중심 조성과 기능을 먼저 붙잡습니다.';

  @override
  String get studyHarmonyLessonSkylineSwapTitle => '중력 전환';

  @override
  String get studyHarmonyLessonSkylineSwapDescription =>
      '차용 중력과 빈칸 코드 복원을 동시에 처리하며 진행의 무게 이동을 따라갑니다.';

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
      '종지 단서가 빠르게 흔들리는 동안에도 중심 조성을 끝까지 유지합니다.';

  @override
  String get studyHarmonyLessonAfterglowBossTitle => '레드라인 리턴 보스';

  @override
  String get studyHarmonyLessonAfterglowBossDescription =>
      '중심 조성, 기능, 차용 색채, 빈칸 코드 복원을 최고 속도로 한 번에 묶는 종반 보스입니다.';

  @override
  String studyHarmonyProgressTour(Object count, Object target) {
    return '투어 스탬프 $count/$target';
  }

  @override
  String get studyHarmonyProgressTourClaimed => '이번 달 투어 완료';

  @override
  String get studyHarmonyTourTitle => '월간 도전';

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
    return '이번 달 퀘스트 상자를 $target번 열어 투어 스탬프를 채워 보세요.';
  }

  @override
  String studyHarmonyTourSpotlightBody(Object target) {
    return '이번 달 스포트라이트 런을 $target번 클리어하세요. 보스 연속 도전, 챕터 혼합 도전, 약점 집중 훈련, 최고 난도 도전, 보스 레슨이 모두 카운트됩니다.';
  }

  @override
  String get studyHarmonyTourEmptyBody => '이번 달 활동이 쌓이면 여기에 월간 도전 목표가 나타납니다.';

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
    return '퀘스트 상자 $count/$target';
  }

  @override
  String studyHarmonyTourSpotlightLabel(Object count, Object target) {
    return '스포트라이트 $count/$target';
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
      '끝난 것처럼 들리지만 실제로는 닿지 않는 구간에서 종지와 기능을 동시에 바로잡습니다.';

  @override
  String get studyHarmonyLessonDaybreakDawnTitle => '헛새벽';

  @override
  String get studyHarmonyLessonDaybreakDawnDescription =>
      '너무 일찍 밝아지는 듯한 순간에 숨어 있는 중심 조성의 흔들림과 논다이아토닉 신호를 구분합니다.';

  @override
  String get studyHarmonyLessonDaybreakBloomTitle => '차용 개화';

  @override
  String get studyHarmonyLessonDaybreakBloomDescription =>
      '화성이 더 밝아지는 순간에도 차용 색채와 기능선을 함께 붙잡아 진행의 흐름을 지켜냅니다.';

  @override
  String get studyHarmonyLessonDaybreakBossTitle => '선라이즈 오버드라이브 보스';

  @override
  String get studyHarmonyLessonDaybreakBossDescription =>
      '중심 조성, 기능, 논다이아토닉 색채, 빈칸 코드 복원을 새벽 속도로 한 번에 엮는 최종 오버드라이브 보스입니다.';

  @override
  String studyHarmonyProgressDuetPact(Object count) {
    return '듀엣 연속 x$count';
  }

  @override
  String get studyHarmonyDuetTitle => '연속 플레이 약속';

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
      '먼저 오늘의 데일리를 끝내고, 이어서 스포트라이트 런 1회를 클리어해 듀엣을 이어가세요.';

  @override
  String get studyHarmonyDuetNeedSpotlightBody =>
      '데일리는 끝났습니다. 약점 집중 훈련, 챕터 혼합 도전, 보스 연속 도전, 최고 난도 도전, 보스 레슨 중 하나를 클리어하면 오늘 연속 플레이 약속이 완성됩니다.';

  @override
  String studyHarmonyDuetActiveBody(Object count) {
    return '오늘 데일리와 스포트라이트를 모두 마쳐 듀엣이 완성됐습니다. 현재 공유 연속은 $count일입니다.';
  }

  @override
  String get studyHarmonyDuetDailyDone => '데일리 완료';

  @override
  String get studyHarmonyDuetDailyMissing => '데일리 필요';

  @override
  String get studyHarmonyDuetSpotlightDone => '스포트라이트 완료';

  @override
  String get studyHarmonyDuetSpotlightMissing => '스포트라이트 필요';

  @override
  String studyHarmonyDuetDailyLabel(bool done) {
    return '데일리 $done';
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
  String get studyHarmonyChapterBlueHourTitle => '최종 종합 교차';

  @override
  String get studyHarmonyChapterBlueHourDescription =>
      '교차 흐름, 후광처럼 스치는 차용, 이중 지평선을 섞어 종반부 판별을 끝까지 흔드는 황혼 확장 챕터입니다.';

  @override
  String get studyHarmonyLessonBlueHourCurrentTitle => '교차 흐름';

  @override
  String get studyHarmonyLessonBlueHourCurrentDescription =>
      '진행이 두 방향으로 당겨질 때도 중심 조성과 기능을 동시에 붙잡습니다.';

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
      '중심 조성, 기능, 차용 색채, 빈칸 코드 복원을 황혼 속도로 빠르게 교차시키는 최종 블루 아워 보스입니다.';

  @override
  String get anchorLoopTitle => '앵커 루프';

  @override
  String get anchorLoopHelp =>
      '특정 cycle slot의 코드를 고정해 두고, 나머지 slot만 그 주변 문맥에 맞게 생성합니다.';

  @override
  String get anchorLoopCycleLength => '사이클 길이(마디)';

  @override
  String get anchorLoopCycleLengthHelp => '앵커가 반복되는 길이를 마디 단위로 고르세요.';

  @override
  String get anchorLoopVaryNonAnchorSlots => '비앵커 slot 변형 허용';

  @override
  String get anchorLoopVaryNonAnchorSlotsHelp =>
      '앵커 slot은 정확히 유지하고, 나머지 filler만 같은 기능 안에서 조금씩 바꿉니다.';

  @override
  String anchorLoopBarLabel(int bar) {
    return '$bar마디';
  }

  @override
  String anchorLoopBeatLabel(int beat) {
    return '$beat박';
  }

  @override
  String get anchorLoopSlotEmpty => '설정된 앵커 코드 없음';

  @override
  String anchorLoopEditTitle(int bar, int beat) {
    return '$bar마디 $beat박 앵커 편집';
  }

  @override
  String get anchorLoopChordSymbol => '앵커 코드 심볼';

  @override
  String get anchorLoopChordHint =>
      '이 slot에 고정할 코드 심볼 하나를 입력하세요. 비우면 앵커가 해제됩니다.';

  @override
  String get anchorLoopInvalidChord => '이 앵커 slot을 저장하려면 지원되는 코드 심볼을 입력하세요.';

  @override
  String get harmonyPlaybackPatternBlock => '블록';

  @override
  String get harmonyPlaybackPatternArpeggio => '아르페지오';

  @override
  String get metronomeBeatStateNormal => '보통';

  @override
  String get metronomeBeatStateAccent => '강박';

  @override
  String get metronomeBeatStateMute => '뮤트';

  @override
  String get metronomePatternPresetCustom => '커스텀';

  @override
  String get metronomePatternPresetMeterAccent => '박자 기본 강세';

  @override
  String get metronomePatternPresetJazzTwoAndFour => '재즈 2·4';

  @override
  String get metronomeSourceKindBuiltIn => '내장 사운드';

  @override
  String get metronomeSourceKindLocalFile => '로컬 파일';

  @override
  String get transportAudioTitle => '트랜스포트 오디오';

  @override
  String get autoPlayChordChanges => '코드 변화 자동 재생';

  @override
  String get autoPlayChordChangesHelp =>
      '트랜스포트가 chord-change event에 도달하면 다음 코드를 자동으로 재생합니다.';

  @override
  String get autoPlayPattern => '자동 재생 패턴';

  @override
  String get autoPlayPatternHelp => '자동 재생을 블록 코드로 할지 짧은 아르페지오로 할지 고릅니다.';

  @override
  String get autoPlayHoldFactor => '자동 재생 길이';

  @override
  String get autoPlayHoldFactorHelp =>
      'event 길이에 비례해 자동 재생 코드가 얼마나 오래 울릴지 조절합니다.';

  @override
  String get autoPlayMelodyWithChords => '멜로디도 함께 재생';

  @override
  String get autoPlayMelodyWithChordsPlaceholder =>
      '멜로디 생성이 켜져 있으면 chord-change 자동 재생 때 현재 멜로디 라인도 함께 들려줍니다.';

  @override
  String get melodyGenerationTitle => '멜로디 라인';

  @override
  String get melodyGenerationHelp =>
      '현재 chord timeline을 따라가는 실전형 멜로디 라인을 생성합니다.';

  @override
  String get melodyDensity => '멜로디 밀도';

  @override
  String get melodyDensityHelp => '각 chord event 안에 멜로디 음이 얼마나 자주 나타날지 정합니다.';

  @override
  String get melodyDensitySparse => '성기게';

  @override
  String get melodyDensityBalanced => '균형';

  @override
  String get melodyDensityActive => '활발하게';

  @override
  String get motifRepetitionStrength => '모티프 반복 강도';

  @override
  String get motifRepetitionStrengthHelp =>
      '값이 높을수록 직전 멜로디 조각의 contour 정체성을 더 자주 이어갑니다.';

  @override
  String get approachToneDensity => '어프로치 음 밀도';

  @override
  String get approachToneDensityHelp =>
      '도착 직전의 passing, neighbor, approach 제스처가 얼마나 자주 나올지 조절합니다.';

  @override
  String get melodyRangeLow => '멜로디 최저음';

  @override
  String get melodyRangeHigh => '멜로디 최고음';

  @override
  String get melodyRangeHelp => '생성된 멜로디를 이 연주 가능 음역 안에 유지합니다.';

  @override
  String get melodyStyle => '멜로디 스타일';

  @override
  String get melodyStyleHelp =>
      '안전한 가이드톤 중심, 비밥 진행, 서정적 여백, 컬러 텐션 중심 중 하나로 성향을 정합니다.';

  @override
  String get melodyStyleSafe => '안전';

  @override
  String get melodyStyleBebop => '비밥';

  @override
  String get melodyStyleLyrical => '서정적';

  @override
  String get melodyStyleColorful => '컬러풀';

  @override
  String get allowChromaticApproaches => '반음 어프로치 허용';

  @override
  String get allowChromaticApproachesHelp =>
      '스타일이 허용할 때 weak beat에서 enclosure와 반음 접근음을 사용할 수 있게 합니다.';

  @override
  String get melodyPlaybackMode => '멜로디 재생 방식';

  @override
  String get melodyPlaybackModeHelp => '수동 미리듣기 버튼이 코드만, 멜로디만, 둘 다 재생할지 고릅니다.';

  @override
  String get melodyPlaybackModeChordsOnly => '코드만';

  @override
  String get melodyPlaybackModeMelodyOnly => '멜로디만';

  @override
  String get melodyPlaybackModeBoth => '둘 다';

  @override
  String get regenerateMelody => '멜로디 다시 생성';

  @override
  String get melodyPreviewCurrent => '현재 라인';

  @override
  String get melodyPreviewNext => '다음 도착음';

  @override
  String get metronomePatternTitle => '메트로놈 패턴';

  @override
  String get metronomePatternHelp => '박자표에 맞는 기본 패턴을 고르거나 각 박을 직접 지정하세요.';

  @override
  String get metronomeUseAccentSound => '강박용 별도 소리 사용';

  @override
  String get metronomeUseAccentSoundHelp =>
      '강박에서 단순 gain 상승 대신 다른 클릭 소리를 사용합니다.';

  @override
  String get metronomePrimarySource => '기본 클릭 소스';

  @override
  String get metronomeAccentSource => '강박 클릭 소스';

  @override
  String get metronomeSourceKind => '소스 종류';

  @override
  String get metronomeLocalFilePath => '로컬 파일 경로';

  @override
  String get metronomeLocalFilePathHelp =>
      '로컬 오디오 파일 경로를 붙여넣고 엔터를 누르세요. 실패하면 내장 사운드로 돌아갑니다.';

  @override
  String get metronomeAccentLocalFilePath => '강박 로컬 파일 경로';

  @override
  String get metronomeAccentLocalFilePathHelp =>
      '강박용 로컬 파일 경로를 붙여넣고 엔터를 누르세요. 실패하면 내장 사운드로 돌아갑니다.';

  @override
  String get harmonySoundTitle => '화성 오디오';

  @override
  String get harmonyMasterVolume => '마스터 볼륨';

  @override
  String get harmonyMasterVolumeHelp => '수동 미리듣기와 자동 chord playback 전체 볼륨입니다.';

  @override
  String get harmonyPreviewHoldFactor => '코드 유지 길이';

  @override
  String get harmonyPreviewHoldFactorHelp => '미리듣기 코드와 음이 얼마나 오래 유지될지 조절합니다.';

  @override
  String get harmonyArpeggioStepSpeed => '아르페지오 속도';

  @override
  String get harmonyArpeggioStepSpeedHelp => '아르페지오 음이 얼마나 빨리 진행될지 조절합니다.';

  @override
  String get harmonyVelocityHumanization => '벨로시티 휴머니징';

  @override
  String get harmonyVelocityHumanizationHelp =>
      '반복 재생이 덜 기계적으로 들리도록 미세한 벨로시티 변화를 줍니다.';

  @override
  String get harmonyGainRandomness => '게인 랜덤성';

  @override
  String get harmonyGainRandomnessHelp => '지원되는 재생 경로에서 음마다 작은 볼륨 차이를 추가합니다.';

  @override
  String get harmonyTimingHumanization => '타이밍 휴머니징';

  @override
  String get harmonyTimingHumanizationHelp =>
      '블록 코드의 동시 어택을 약간 풀어 덜 딱딱하게 들리게 합니다.';

  @override
  String get harmonySoundProfileSelectionTitle => '사운드 프로파일 모드';

  @override
  String get harmonySoundProfileSelectionHelp =>
      '중립 프리뷰를 쓰거나, Study Harmony 트랙을 따라가거나, 특정 트랙의 재생 성향을 고정할 수 있습니다.';

  @override
  String get harmonySoundProfileSelectionNeutral => '중립 공용 피아노';

  @override
  String get harmonySoundProfileSelectionTrackAware => '트랙 연동';

  @override
  String get harmonySoundProfileSelectionPop => '팝 프로파일';

  @override
  String get harmonySoundProfileSelectionJazz => '재즈 프로파일';

  @override
  String get harmonySoundProfileSelectionClassical => '클래식 프로파일';

  @override
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern) {
    return '악기: $instrument. 추천 프리뷰 패턴: $pattern.';
  }

  @override
  String get harmonySoundProfileTrackAwareFallback =>
      '자유 연습에서는 공용 피아노 프로파일을 유지하고, Study Harmony 세션에서는 현재 트랙에 맞는 사운드 shaping을 적용합니다.';

  @override
  String get harmonySoundProfileNeutralLabel => '균형형 공용 피아노';

  @override
  String get harmonySoundProfileNeutralSummary =>
      '공용 피아노 자산을 기반으로, 어떤 레슨에도 무리 없이 맞는 중립 프리뷰를 사용합니다.';

  @override
  String get harmonySoundTagBalanced => '균형형';

  @override
  String get harmonySoundTagPiano => '피아노';

  @override
  String get harmonySoundTagSoft => '부드러움';

  @override
  String get harmonySoundTagOpen => '열림';

  @override
  String get harmonySoundTagModern => '현대적';

  @override
  String get harmonySoundTagDry => '드라이';

  @override
  String get harmonySoundTagWarm => '따뜻함';

  @override
  String get harmonySoundTagEpReady => 'EP 지향';

  @override
  String get harmonySoundTagClear => '선명함';

  @override
  String get harmonySoundTagAcoustic => '어쿠스틱';

  @override
  String get harmonySoundTagFocused => '집중형';

  @override
  String get harmonySoundNeutralTrait1 => '기본 화성 확인에 무난한 안정적 홀드';

  @override
  String get harmonySoundNeutralTrait2 => '과한 색채 없이 균형 잡힌 어택';

  @override
  String get harmonySoundNeutralTrait3 => '어떤 레슨이나 자유 연습에도 안전한 기본값';

  @override
  String get harmonySoundNeutralExpansion1 => '향후 음역대나 공간감 기준의 공용 피아노 분기';

  @override
  String get harmonySoundNeutralExpansion2 => '헤드폰용 대체 공용 악기 세트 확장 가능';

  @override
  String get harmonySoundPopTrait1 => 'open hook과 add9 color를 살리는 조금 긴 sustain';

  @override
  String get harmonySoundPopTrait2 => '반복 프리뷰가 덜 딱딱하게 들리도록 부드러운 attack';

  @override
  String get harmonySoundPopTrait3 =>
      'loop가 너무 격자처럼 들리지 않게 하는 가벼운 humanization';

  @override
  String get harmonySoundPopExpansion1 => '밝은 팝 키보드 또는 piano-synth 레이어 자산';

  @override
  String get harmonySoundPopExpansion2 => 'chorus lift용 넓은 스테레오 보이싱 재생';

  @override
  String get harmonySoundJazzTrait1 => '종지 흐름이 보이도록 조금 짧은 hold';

  @override
  String get harmonySoundJazzTrait2 => 'guide-tone 청감을 돕는 빠른 broken-preview 감각';

  @override
  String get harmonySoundJazzTrait3 =>
      'shell과 rootless comping을 암시하는 더 큰 터치 변화';

  @override
  String get harmonySoundJazzExpansion1 => '드라이한 업라이트 또는 부드러운 EP 계열 악기';

  @override
  String get harmonySoundJazzExpansion2 => 'shell / rootless 드릴용 comping 프리셋';

  @override
  String get harmonySoundClassicalTrait1 => '기능과 종지를 분명하게 듣게 하는 중심형 sustain';

  @override
  String get harmonySoundClassicalTrait2 => 'voice-leading 안정성을 위한 낮은 랜덤성';

  @override
  String get harmonySoundClassicalTrait3 => '화성 도착감을 직접적으로 들려주는 block playback';

  @override
  String get harmonySoundClassicalExpansion1 => '공간감을 줄인 직접적인 어쿠스틱 피아노 프로파일';

  @override
  String get harmonySoundClassicalExpansion2 => 'cadence와 sequence 전용 프리뷰 보이싱';

  @override
  String get explanationSectionTitle => '왜 이렇게 들리는가';

  @override
  String get explanationReasonSection => '왜 이런 결과가 나왔는가';

  @override
  String get explanationConfidenceHigh => '신뢰도 높음';

  @override
  String get explanationConfidenceMedium => '설득력 있는 해석';

  @override
  String get explanationConfidenceLow => '잠정적 해석으로 보는 편이 좋습니다';

  @override
  String get explanationAmbiguityLow =>
      '대체로 한 방향으로 읽히지만, 약한 다른 해석 가능성도 남아 있습니다.';

  @override
  String get explanationAmbiguityMedium =>
      '둘 이상의 그럴듯한 해석이 함께 남아 있어서, 전후 문맥이 중요합니다.';

  @override
  String get explanationAmbiguityHigh =>
      '여러 해석이 경쟁하고 있으므로, 이번 설명은 문맥 의존적인 보수적 해석으로 보는 편이 안전합니다.';

  @override
  String get explanationCautionParser => '분석 전에 일부 코드 표기가 정규화되었습니다.';

  @override
  String get explanationCautionAmbiguous => '여기에는 둘 이상의 합리적인 해석이 가능합니다.';

  @override
  String get explanationCautionAlternateKey =>
      '가까운 다른 key center도 일부 구간을 설명합니다.';

  @override
  String get explanationAlternativeSection => '다른 해석';

  @override
  String explanationAlternativeKeyLabel(Object keyLabel) {
    return '대안 key: $keyLabel';
  }

  @override
  String get explanationAlternativeKeyBody =>
      '현재 해석도 유효하지만, 다른 key center로 읽어도 일부 코드 흐름이 설명됩니다.';

  @override
  String explanationAlternativeReadingLabel(Object romanNumeral) {
    return '대안 해석: $romanNumeral';
  }

  @override
  String get explanationAlternativeReadingBody =>
      '유일한 정답이라기보다 가능한 해석 중 하나로 보는 편이 안전합니다.';

  @override
  String get explanationListeningSection => '청감 포인트';

  @override
  String get explanationListeningGuideToneTitle => '3도와 7도를 따라 들어보세요';

  @override
  String get explanationListeningGuideToneBody =>
      '종지로 갈수록 안쪽 성부가 가장 작은 움직임으로 어떻게 연결되는지 들어보세요.';

  @override
  String get explanationListeningDominantColorTitle => 'dominant 컬러를 들어보세요';

  @override
  String get explanationListeningDominantColorBody =>
      '최종 도착 전에 dominant의 텐션이 어떻게 풀리려 하는지 먼저 느껴보세요.';

  @override
  String get explanationListeningBackdoorTitle => '부드러운 backdoor 끌림을 들어보세요';

  @override
  String get explanationListeningBackdoorBody =>
      '평범한 V-I 압력보다, subdominant minor 계열의 색채와 성부 진행으로 home으로 돌아오는 느낌을 들어보세요.';

  @override
  String get explanationListeningBorrowedColorTitle => '컬러가 바뀌는 순간을 들어보세요';

  @override
  String get explanationListeningBorrowedColorBody =>
      'borrowed chord가 들어오며 루프의 밝기나 어둠이 어떻게 바뀌는지 느껴보세요.';

  @override
  String get explanationListeningBassMotionTitle => '베이스 움직임을 따라 들어보세요';

  @override
  String get explanationListeningBassMotionBody =>
      '위쪽 화성이 크게 바뀌지 않아도, bass note가 추진감을 어떻게 바꾸는지 따라가 보세요.';

  @override
  String get explanationListeningCadenceTitle => '도착 지점을 들어보세요';

  @override
  String get explanationListeningCadenceBody =>
      '어느 코드가 안정점처럼 들리는지, 그리고 그 전에 어떤 준비가 있었는지 들어보세요.';

  @override
  String get explanationListeningAmbiguityTitle => '경쟁하는 해석을 비교해 들어보세요';

  @override
  String get explanationListeningAmbiguityBody =>
      '같은 코드를 한 번은 국소적 해결감으로, 한 번은 더 큰 key center 역할로 들어보며 차이를 비교해 보세요.';

  @override
  String get explanationPerformanceSection => '연주 포인트';

  @override
  String get explanationPerformancePopTitle => '훅이 잘 들리게 유지하세요';

  @override
  String get explanationPerformancePopBody =>
      '선명한 탑노트, 반복되는 윤곽, 열린 보이싱으로 보컬 라인을 받쳐 주세요.';

  @override
  String get explanationPerformanceJazzTitle => '가이드톤부터 잡으세요';

  @override
  String get explanationPerformanceJazzBody =>
      '추가 텐션이나 reharm을 얹기 전에 3도와 7도로 종지감을 먼저 만드세요.';

  @override
  String get explanationPerformanceJazzShellTitle => '먼저 shell tone으로 잡으세요';

  @override
  String get explanationPerformanceJazzShellBody =>
      'root, 3도, 7도를 먼저 또렷하게 놓아 종지 흐름이 쉽게 들리게 하세요.';

  @override
  String get explanationPerformanceJazzRootlessTitle => '3도와 7도가 형태를 이끌게 하세요';

  @override
  String get explanationPerformanceJazzRootlessBody =>
      'guide tone을 안정적으로 유지한 뒤, 해결감이 남아 있을 때만 9나 13을 더해 보세요.';

  @override
  String get explanationPerformanceClassicalTitle => '성부 진행을 단정하게 유지하세요';

  @override
  String get explanationPerformanceClassicalBody =>
      '안정적인 간격, 기능적 도착, 가능한 한 순차 진행을 우선하세요.';

  @override
  String get explanationPerformanceDominantColorTitle =>
      '목표를 먼저 분명히 한 뒤 텐션을 더하세요';

  @override
  String get explanationPerformanceDominantColorBody =>
      '가이드톤으로 해결 방향을 먼저 들리게 한 다음, 9, 13, altered color를 장식처럼 얹어 보세요.';

  @override
  String get explanationPerformanceAmbiguityTitle => '가장 안정적인 음을 먼저 고정하세요';

  @override
  String get explanationPerformanceAmbiguityBody =>
      '해석이 모호하다면 더 화려한 선택보다, 해결 가능성이 큰 타깃음을 먼저 강조해 주세요.';

  @override
  String get explanationPerformanceVoicingTitle => '보이싱 포인트';

  @override
  String get explanationPerformanceMelodyTitle => '멜로디 포인트';

  @override
  String get explanationPerformanceMelodyBody =>
      '구조적 타깃음을 먼저 잡고, 그 주변을 passing tone으로 메워 보세요.';

  @override
  String get explanationReasonFunctionalResolutionLabel => '기능적 끌림';

  @override
  String get explanationReasonFunctionalResolutionBody =>
      '코드들이 따로 놓인 소리가 아니라 tonic, predominant, dominant의 흐름으로 정리됩니다.';

  @override
  String get explanationReasonGuideToneSmoothnessLabel => '가이드톤 연결';

  @override
  String get explanationReasonGuideToneSmoothnessBody =>
      '안쪽 성부가 효율적으로 움직여 진행 방향이 더 분명해집니다.';

  @override
  String get explanationReasonBorrowedColorLabel => 'borrowed color';

  @override
  String get explanationReasonBorrowedColorBody =>
      '병행조 차용이 home key를 완전히 떠나지 않으면서 대비를 만듭니다.';

  @override
  String get explanationReasonSecondaryDominantLabel =>
      'secondary dominant의 끌림';

  @override
  String get explanationReasonSecondaryDominantBody =>
      '이 dominant는 tonic만이 아니라 특정 목표 코드로 강하게 향합니다.';

  @override
  String get explanationReasonTritoneSubLabel => 'tritone sub 컬러';

  @override
  String get explanationReasonTritoneSubBody =>
      'dominant 성격은 유지하면서 bass 진행만 대체 경로로 바뀝니다.';

  @override
  String get explanationReasonDominantColorLabel => 'dominant tension';

  @override
  String get explanationReasonDominantColorBody =>
      'altered 혹은 extended dominant 컬러가 전체 key 해석을 바꾸지 않으면서 다음 화음으로의 끌림을 강화합니다.';

  @override
  String get explanationReasonBackdoorMotionLabel => 'backdoor 진행';

  @override
  String get explanationReasonBackdoorMotionBody =>
      'subdominant minor나 backdoor 성격이 섞여 있어서, 더 부드럽지만 방향성 있는 해결감이 생깁니다.';

  @override
  String get explanationReasonCadentialStrengthLabel => '종지 형태';

  @override
  String get explanationReasonCadentialStrengthBody =>
      '중립적인 루프 반복보다 더 강한 도착감을 만드는 마무리 형태입니다.';

  @override
  String get explanationReasonVoiceLeadingStabilityLabel => '안정적인 성부 진행';

  @override
  String get explanationReasonVoiceLeadingStabilityBody =>
      '선택된 보이싱이 공통음을 유지하거나 경향음을 자연스럽게 해결합니다.';

  @override
  String get explanationReasonSingableContourLabel => '노래하기 쉬운 윤곽';

  @override
  String get explanationReasonSingableContourBody =>
      '지나치게 각진 선보다 기억하기 쉬운 움직임을 우선한 라인입니다.';

  @override
  String get explanationReasonSlashBassLiftLabel => '베이스 움직임의 리프트';

  @override
  String get explanationReasonSlashBassLiftBody =>
      '위쪽 화성은 가깝게 유지하면서도 bass가 추진감을 바꿉니다.';

  @override
  String get explanationReasonTurnaroundGravityLabel => 'turnaround의 중력';

  @override
  String get explanationReasonTurnaroundGravityBody =>
      '익숙한 재즈 해결 지점을 순환하며 다음 화음으로 끌어당깁니다.';

  @override
  String get explanationReasonInversionDisciplineLabel => 'inversion 제어';

  @override
  String get explanationReasonInversionDisciplineBody =>
      'inversion 선택이 outer voice와 종지 행동을 더 매끄럽게 만듭니다.';

  @override
  String get explanationReasonAmbiguityWindowLabel => '경쟁하는 해석';

  @override
  String get explanationReasonAmbiguityWindowBody =>
      '같은 음 구성으로도 둘 이상의 화성 역할이 가능해서, 어떤 해석이 더 강한지는 문맥이 결정합니다.';

  @override
  String get explanationReasonChromaticLineLabel => '반음계 라인';

  @override
  String get explanationReasonChromaticLineBody =>
      'bass나 내성의 반음계 연결이 추가 색채를 가진 화음도 자연스럽게 들리게 만듭니다.';

  @override
  String get explanationTrackContextPop =>
      '팝 문맥에서는 loop의 중력, 색채 대비, singable한 탑라인 쪽으로 기울어진 해석입니다.';

  @override
  String get explanationTrackContextJazz =>
      '재즈 문맥에서는 guide tone, 종지의 끌림, dominant color를 중심으로 볼 수 있는 가능한 해석입니다.';

  @override
  String get explanationTrackContextClassical =>
      '클래식 문맥에서는 기능 구분, inversion 인식, 종지 강도 쪽으로 기울어진 해석입니다.';

  @override
  String get studyHarmonyTrackFocusSectionTitle => '이 트랙에서 주로 다루는 것';

  @override
  String get studyHarmonyTrackLessFocusSectionTitle => '상대적으로 덜 다루는 것';

  @override
  String get studyHarmonyTrackRecommendedForSectionTitle => '추천 대상';

  @override
  String get studyHarmonyTrackSoundSectionTitle => '사운드 프로파일';

  @override
  String get studyHarmonyTrackSoundAssetPlaceholder =>
      '현재 릴리스는 공용 피아노 자산을 사용합니다. 이 프로파일은 향후 트랙별 사운드 확장을 위한 준비 계층입니다.';

  @override
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument) {
    return '현재 악기: $instrument';
  }

  @override
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern) {
    return '추천 프리뷰 패턴: $pattern';
  }

  @override
  String get studyHarmonyTrackSoundPlaybackTraitsTitle => '재생 성향';

  @override
  String get studyHarmonyTrackSoundExpansionTitle => '향후 확장 포인트';

  @override
  String get studyHarmonyTrackPopFocus1 => '다이아토닉 루프의 중력과 훅 친화적 반복';

  @override
  String get studyHarmonyTrackPopFocus2 =>
      'iv, bVII, IVMaj7 같은 절제된 borrowed color';

  @override
  String get studyHarmonyTrackPopFocus3 =>
      'pre-chorus lift를 만드는 slash bass와 pedal bass 감각';

  @override
  String get studyHarmonyTrackPopLess1 =>
      '촘촘한 재즈 reharm과 고급 substitute dominant';

  @override
  String get studyHarmonyTrackPopLess2 =>
      'rootless 보이싱 체계와 강한 altered dominant 언어';

  @override
  String get studyHarmonyTrackPopRecommendedFor =>
      '현대 팝, 발라드, 송라이팅 문맥에서 바로 쓸 수 있는 화성을 익히고 싶은 사용자에게 적합합니다.';

  @override
  String get studyHarmonyTrackPopTheoryTone =>
      '곡 중심이고 실용적이며, 용어 과부하 없이 색채를 체험하게 하는 톤입니다.';

  @override
  String get studyHarmonyTrackPopHeroHeadline => '훅이 살아 있는 루프 만들기';

  @override
  String get studyHarmonyTrackPopHeroBody =>
      '이 트랙은 loop의 중력, 절제된 borrowed color, section을 들어 올리는 bass 움직임을 중심으로 팝 화성을 가르칩니다.';

  @override
  String get studyHarmonyTrackPopQuickPracticeCue =>
      '시그니처 루프 챕터부터 시작한 뒤, 같은 훅이 bass와 borrowed color 때문에 어떻게 달라지는지 들어보세요.';

  @override
  String get studyHarmonyTrackPopSoundLabel => '부드럽고 열린 현대 팝 톤';

  @override
  String get studyHarmonyTrackPopSoundSummary =>
      '현재는 공용 피아노를 쓰지만, 향후 더 밝은 팝 키보드와 넓은 스테레오 보이싱으로 확장할 수 있습니다.';

  @override
  String get studyHarmonyTrackJazzFocus1 =>
      'guide-tone 청감과 shell에서 rootless로 가는 보이싱 성장';

  @override
  String get studyHarmonyTrackJazzFocus2 =>
      'major ii-V-I, minor iiø-V-i, turnaround의 흐름';

  @override
  String get studyHarmonyTrackJazzFocus3 =>
      'dominant color, tensions, tritone sub, backdoor의 입문 문맥';

  @override
  String get studyHarmonyTrackJazzLess1 => '종지 감각 없는 단순 반복형 song loop';

  @override
  String get studyHarmonyTrackJazzLess2 =>
      '주된 목표로서의 classical inversion literacy';

  @override
  String get studyHarmonyTrackJazzRecommendedFor =>
      '복잡한 reharm으로 바로 뛰지 않고도 기능적 재즈 화성을 귀와 손으로 익히고 싶은 사용자에게 추천합니다.';

  @override
  String get studyHarmonyTrackJazzTheoryTone =>
      '맥락적이고 신뢰도 인식형이며, 하나의 재즈 해석만을 정답처럼 과장하지 않는 톤입니다.';

  @override
  String get studyHarmonyTrackJazzHeroHeadline => '코드 안의 선율을 듣기';

  @override
  String get studyHarmonyTrackJazzHeroBody =>
      '이 트랙은 guide tone부터 시작해 종지 패밀리, 그리고 절제된 dominant color까지 재즈 화성을 단계적으로 체감하게 합니다.';

  @override
  String get studyHarmonyTrackJazzQuickPracticeCue =>
      'guide tone과 shell voicing부터 익힌 뒤, 같은 종지를 rootless color로 다시 들어보세요.';

  @override
  String get studyHarmonyTrackJazzSoundLabel => '드라이하고 따뜻한 재즈 톤';

  @override
  String get studyHarmonyTrackJazzSoundSummary =>
      '현재는 공용 피아노를 쓰지만, 향후 더 건조한 어택과 EP 친화 재생으로 확장할 수 있습니다.';

  @override
  String get studyHarmonyTrackClassicalFocus1 => 'T / S / D 기능 구분과 cadence 유형';

  @override
  String get studyHarmonyTrackClassicalFocus2 =>
      '1전위, 2전위, cadential 6/4를 포함한 inversion literacy';

  @override
  String get studyHarmonyTrackClassicalFocus3 =>
      '성부 진행 안정성, sequence, 기능적 modulation 기초';

  @override
  String get studyHarmonyTrackClassicalLess1 =>
      '강한 tension 적층, quartal color, upper-structure 사고';

  @override
  String get studyHarmonyTrackClassicalLess2 => '루프 반복을 중심으로 한 팝식 학습 프레임';

  @override
  String get studyHarmonyTrackClassicalRecommendedFor =>
      '기능 청감, inversion 인식, disciplined voice leading을 분명하게 배우고 싶은 사용자에게 적합합니다.';

  @override
  String get studyHarmonyTrackClassicalTheoryTone =>
      '구조적이고 기능 우선이며, 라벨 암기뿐 아니라 청감까지 연결하는 톤입니다.';

  @override
  String get studyHarmonyTrackClassicalHeroHeadline => '기능과 종지를 또렷하게 듣기';

  @override
  String get studyHarmonyTrackClassicalHeroBody =>
      '이 트랙은 기능적 도착, inversion 제어, 구조적으로 분명한 phrase ending에 집중합니다.';

  @override
  String get studyHarmonyTrackClassicalQuickPracticeCue =>
      'cadence lab부터 시작한 뒤, 같은 기능이 inversion 때문에 어떻게 달라지는지 비교해 보세요.';

  @override
  String get studyHarmonyTrackClassicalSoundLabel => '선명하고 집중된 어쿠스틱 톤';

  @override
  String get studyHarmonyTrackClassicalSoundSummary =>
      '현재는 공용 피아노를 쓰지만, 향후 더 직접적인 어쿠스틱 프로파일로 확장할 수 있습니다.';

  @override
  String get studyHarmonyPopChapterSignatureLoopsTitle => '시그니처 팝 루프';

  @override
  String get studyHarmonyPopChapterSignatureLoopsDescription =>
      'hook gravity, borrowed lift, bass motion을 통해 바로 곡에 쓸 수 있는 팝 감각을 만듭니다.';

  @override
  String get studyHarmonyPopLessonHookGravityTitle => '훅의 중력';

  @override
  String get studyHarmonyPopLessonHookGravityDescription =>
      '단순한 4코드 루프가 왜 계속 귀에 남는지 들어봅니다.';

  @override
  String get studyHarmonyPopLessonBorrowedLiftTitle => 'borrowed lift';

  @override
  String get studyHarmonyPopLessonBorrowedLiftDescription =>
      'hook를 망치지 않으면서 section의 분위기를 바꾸는 borrowed chord를 체험합니다.';

  @override
  String get studyHarmonyPopLessonBassMotionTitle => '베이스 움직임';

  @override
  String get studyHarmonyPopLessonBassMotionDescription =>
      '윗성부는 익숙하게 두고 bass line만으로도 리프트를 만드는 방법을 익힙니다.';

  @override
  String get studyHarmonyPopLessonBossTitle => '프리코러스 리프트 체크포인트';

  @override
  String get studyHarmonyPopLessonBossDescription =>
      'loop의 중력, borrowed color, bass motion을 한 번에 연결하는 팝형 문제 묶음입니다.';

  @override
  String get studyHarmonyJazzChapterGuideToneLabTitle => '가이드톤 랩';

  @override
  String get studyHarmonyJazzChapterGuideToneLabDescription =>
      '선명한 major ii-V-I에서 시작해 shell voicing, minor cadence, rootless color, reharm 입문까지 단계적으로 이어집니다.';

  @override
  String get studyHarmonyJazzLessonGuideTonesTitle => '가이드톤 청감';

  @override
  String get studyHarmonyJazzLessonGuideTonesDescription =>
      'extra color를 더하기 전에 선명한 major ii-V-I를 3도와 7도로 먼저 듣습니다.';

  @override
  String get studyHarmonyJazzLessonShellVoicingsTitle => '셸 보이싱';

  @override
  String get studyHarmonyJazzLessonShellVoicingsDescription =>
      'lean한 shell shape와 단순한 turnaround 안에서 종지의 뼈대를 듣습니다.';

  @override
  String get studyHarmonyJazzLessonMinorCadenceTitle => '마이너 종지';

  @override
  String get studyHarmonyJazzLessonMinorCadenceDescription =>
      'minor iiø-V-i가 주는 긴장과 도착의 감각을 익힙니다.';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsTitle => '루트리스 보이싱';

  @override
  String get studyHarmonyJazzLessonRootlessVoicingsDescription =>
      '베이스를 보이싱에서 덜어낸 뒤에도 turnaround의 목표음과 color tone이 어떻게 들리는지 익힙니다.';

  @override
  String get studyHarmonyJazzLessonDominantColorTitle => '도미넌트 텐션';

  @override
  String get studyHarmonyJazzLessonDominantColorDescription =>
      '종지 타깃을 잃지 않으면서도 9th, 13th, sus, altered pull을 단계적으로 듣습니다.';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceTitle => '트라이톤과 백도어';

  @override
  String get studyHarmonyJazzLessonBackdoorCadenceDescription =>
      '같은 토닉으로 가더라도 substitute dominant와 backdoor가 어떤 다른 경로로 들리는지 비교합니다.';

  @override
  String get studyHarmonyJazzLessonBossTitle => '턴어라운드 체크포인트';

  @override
  String get studyHarmonyJazzLessonBossDescription =>
      'major ii-V-I, minor iiø-V-i, rootless color, 신중한 reharm을 섞어도 종지 타깃이 계속 읽히는지 확인합니다.';

  @override
  String get studyHarmonyClassicalChapterCadenceLabTitle => '카덴스 랩';

  @override
  String get studyHarmonyClassicalChapterCadenceLabDescription =>
      'cadence, inversion, controlled secondary dominant를 통해 기능 청감을 강화합니다.';

  @override
  String get studyHarmonyClassicalLessonCadenceTitle => '카덴스 기능';

  @override
  String get studyHarmonyClassicalLessonCadenceDescription =>
      '어떤 화음이 준비하고, 어떤 화음이 도착을 완성하는지 기능으로 구분합니다.';

  @override
  String get studyHarmonyClassicalLessonInversionTitle => 'inversion 제어';

  @override
  String get studyHarmonyClassicalLessonInversionDescription =>
      'inversion이 bass line과 도착감에 어떤 차이를 만드는지 들어봅니다.';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantTitle =>
      '기능적 secondary dominant';

  @override
  String get studyHarmonyClassicalLessonSecondaryDominantDescription =>
      'secondary dominant를 막연한 색채가 아니라 목적지가 있는 기능 사건으로 다룹니다.';

  @override
  String get studyHarmonyClassicalLessonBossTitle => '도착 체크포인트';

  @override
  String get studyHarmonyClassicalLessonBossDescription =>
      'cadence 형태, inversion 인식, secondary dominant의 끌림을 한 phrase 안에서 함께 점검합니다.';

  @override
  String studyHarmonyPlayStyleLabel(String playStyle) {
    String _temp0 = intl.Intl.selectLogic(playStyle, {
      'competitor': '경쟁형',
      'collector': '수집형',
      'explorer': '탐색형',
      'stabilizer': '안정형',
      'balanced': '균형형',
      'other': '균형형',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyRewardFocusLabel(String focus) {
    String _temp0 = intl.Intl.selectLogic(focus, {
      'mastery': '집중: 숙련',
      'achievements': '집중: 업적',
      'cosmetics': '집중: 코스메틱',
      'currency': '집중: 재화',
      'collection': '집중: 수집',
      'other': '집중',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress) {
    return '다음 $rewardTitle $progress%';
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
      'recovery': '회복 레인',
      'groove': '그루브 레인',
      'push': '푸시 레인',
      'clutch': '클러치 레인',
      'legend': '레전드 레인',
      'other': '연습 레인',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPressureTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'calm': '차분한 압박',
      'steady': '안정 압박',
      'hot': '뜨거운 압박',
      'charged': '고조 압박',
      'overdrive': '오버드라이브',
      'other': '압박',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyForgivenessTierLabel(String tier) {
    String _temp0 = intl.Intl.selectLogic(tier, {
      'strict': '엄격한 판정',
      'tight': '좁은 판정',
      'balanced': '균형 판정',
      'kind': '관대한 판정',
      'generous': '매우 관대한 판정',
      'other': '판정',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyComboGoalLabel(int comboTarget) {
    return '콤보 목표 $comboTarget';
  }

  @override
  String studyHarmonyRuntimeTuningSummary(int lives, int goal) {
    return '라이프 $lives | 목표 $goal';
  }

  @override
  String studyHarmonyCoachLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': '지원형 코치',
      'structured': '구조형 코치',
      'challengeForward': '도전형 코치',
      'analytical': '분석형 코치',
      'restorative': '회복형 코치',
      'other': '코치',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyCoachLine(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'supportive': '흐름을 먼저 지키고 자신감을 자연스럽게 쌓아 보세요.',
      'structured': '구조를 따라가면 성과가 더 오래 남습니다.',
      'challengeForward': '적당한 압박을 받아들이고 더 선명한 런으로 밀어 보세요.',
      'analytical': '약한 지점을 읽고 정확하게 다듬어 보세요.',
      'restorative': '이번 런은 흔들리지 않게 리듬을 다시 세우는 데 집중합니다.',
      'other': '다음 런의 초점을 분명하게 유지해 보세요.',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyPacingSegmentLabel(String segment, int minutes) {
    String _temp0 = intl.Intl.selectLogic(segment, {
      'warmup': '워밍업',
      'tension': '긴장',
      'release': '이완',
      'reward': '보상',
      'other': '세그먼트',
    });
    return '$_temp0 $minutes분';
  }

  @override
  String studyHarmonyPacingSummaryLabel(String segments) {
    return '페이싱 $segments';
  }

  @override
  String studyHarmonyArcadeRiskLabel(String risk) {
    String _temp0 = intl.Intl.selectLogic(risk, {
      'forgiving': '낮은 리스크',
      'balanced': '균형 리스크',
      'tense': '높은 긴장',
      'punishing': '강한 리스크',
      'other': '아케이드 리스크',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRewardStyleLabel(String style) {
    String _temp0 = intl.Intl.selectLogic(style, {
      'currency': '재화 루프',
      'cosmetic': '코스메틱 수집',
      'title': '칭호 수집',
      'trophy': '트로피 런',
      'bundle': '번들 보상',
      'prestige': '명성 보상',
      'other': '보상 루프',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count) {
    return '콤보 보너스 $count마다';
  }

  @override
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives) {
    return '미스 시 라이프 $lives 감소';
  }

  @override
  String get studyHarmonyArcadeRuntimeModifierPulses => '변형 규칙';

  @override
  String get studyHarmonyArcadeRuntimeGhostPressure => '고스트 압박';

  @override
  String get studyHarmonyArcadeRuntimeShopBiasedLoot => '상점 편향 보상';

  @override
  String get studyHarmonyArcadeRuntimeSteadyRuleset => '안정 규칙';

  @override
  String studyHarmonyShopStateLabel(String state) {
    String _temp0 = intl.Intl.selectLogic(state, {
      'alreadyPurchased': '이미 구매함',
      'readyToBuy': '구매 가능',
      'progressLocked': '진행 잠금',
      'other': '상점 상태',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyShopActionLabel(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'buy': '구매',
      'equipped': '장착됨',
      'equip': '장착',
      'other': '상점 액션',
    });
    return '$_temp0';
  }

  @override
  String get melodyCurrentLineFeelTitle => '현재 라인 성향';

  @override
  String get melodyLinePersonalityTitle => '라인 성격';

  @override
  String get melodyLinePersonalityBody =>
      '이 네 개의 슬라이더는 화성을 바꾸기 전에도 guided, standard, advanced가 어떻게 다르게 느껴지는지를 정리합니다.';

  @override
  String get melodySyncopationBiasTitle => '싱코페이션 성향';

  @override
  String get melodySyncopationBiasBody =>
      '엇박 시작, anticipation, 리듬의 들뜸을 더 자주 선택하게 합니다.';

  @override
  String get melodyColorRealizationBiasTitle => '컬러 실현 성향';

  @override
  String get melodyColorRealizationBiasBody =>
      '멜로디가 tension과 color tone을 더 자주 집어들게 합니다.';

  @override
  String get melodyNoveltyTargetTitle => '새로움 목표';

  @override
  String get melodyNoveltyTargetBody => '완전한 반복을 줄이고 더 새로운 음정 윤곽으로 조금씩 밀어 줍니다.';

  @override
  String get melodyMotifVariationBiasTitle => '모티프 변형 성향';

  @override
  String get melodyMotifVariationBiasBody =>
      '모티프 재사용을 sequence, 꼬리 변화, 리듬 변형으로 이어지게 합니다.';

  @override
  String get studyHarmonyArcadeRulesTitle => '아케이드 규칙';

  @override
  String studyHarmonySessionLengthLabel(int minutes) {
    return '$minutes분 세션';
  }

  @override
  String studyHarmonyRewardKindLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'achievement': '업적',
      'title': '타이틀',
      'cosmetic': '외형',
      'shopItem': '상점 해금',
      'other': '보상',
    });
    return '$_temp0';
  }

  @override
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives) {
    return '미스 시 하트 $lives 감소';
  }

  @override
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount) {
    return '미스 시 진행 $amount 감소';
  }

  @override
  String studyHarmonyArcadeRuntimeComboProgressLabel(
    int threshold,
    int amount,
  ) {
    return '콤보 $threshold마다 진행 +$amount';
  }

  @override
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount) {
    return '콤보 $threshold마다 하트 +$amount';
  }

  @override
  String get studyHarmonyArcadeRuntimeComboResetLabel => '미스 시 콤보 초기화';

  @override
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount) {
    return '미스 시 콤보 $amount 감소';
  }

  @override
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel => '선택지가 다시 섞입니다';

  @override
  String get studyHarmonyArcadeRuntimeMissedReplayLabel => '놓친 문제가 다시 나옵니다';

  @override
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel => '문제 중복 없음';

  @override
  String get studyHarmonyRuntimeBundleClearBonusTitle => '클리어 보너스';

  @override
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle => '정확도 보너스';

  @override
  String get studyHarmonyRuntimeBundleComboBonusTitle => '콤보 보너스';

  @override
  String get studyHarmonyRuntimeBundleModeBonusTitle => '모드 보너스';

  @override
  String get studyHarmonyRuntimeBundleMasteryBonusTitle => '숙련 보너스';

  @override
  String get melodyQuickPresetGuideLineLabel => '가이드 라인';

  @override
  String get melodyQuickPresetSongLineLabel => '송 라인';

  @override
  String get melodyQuickPresetColorLineLabel => '컬러 라인';

  @override
  String get melodyQuickPresetGuideCompactLabel => '가이드';

  @override
  String get melodyQuickPresetSongCompactLabel => '송';

  @override
  String get melodyQuickPresetColorCompactLabel => '컬러';

  @override
  String get melodyQuickPresetGuideShort => '안정적인 가이드 톤 중심';

  @override
  String get melodyQuickPresetSongShort => '노래처럼 부르기 쉬운 윤곽';

  @override
  String get melodyQuickPresetColorShort => '컬러 톤을 앞세운 라인';

  @override
  String get melodyQuickPresetPanelTitle => '멜로디 프리셋';

  @override
  String get melodyQuickPresetPanelCompactTitle => '라인 프리셋';

  @override
  String get melodyQuickPresetOffLabel => '끔';

  @override
  String get melodyQuickPresetCompactOffLabel => '라인 끔';

  @override
  String get melodyMetricDensityLabel => '밀도';

  @override
  String get melodyMetricStyleLabel => '스타일';

  @override
  String get melodyMetricSyncLabel => '싱코페이션';

  @override
  String get melodyMetricColorLabel => '컬러';

  @override
  String get melodyMetricNoveltyLabel => '새로움';

  @override
  String get melodyMetricMotifLabel => '모티프';

  @override
  String get melodyMetricChromaticLabel => '반음계';

  @override
  String get practiceFirstRunWelcomeTitle => '첫 코드가 바로 준비됐어요';

  @override
  String get practiceFirstRunWelcomeBodyEmpty =>
      '초심자용 시작 프로파일이 이미 적용되어 있습니다. 먼저 들어보고, 카드를 넘겨 다음 코드를 살펴보세요.';

  @override
  String practiceFirstRunWelcomeBodyReady(Object chordLabel) {
    return '$chordLabel 코드가 준비됐어요. 먼저 들어보고, 카드를 넘겨 다음 흐름을 살펴보세요. 원하면 설정 도우미로 시작점을 더 다듬을 수 있습니다.';
  }

  @override
  String get practiceFirstRunSetupButton => '맞춤 설정';
}
