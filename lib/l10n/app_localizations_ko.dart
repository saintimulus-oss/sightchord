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
  String get metronomeHelp => '메트로놈을 켜면 연습 중 매 박마다 클릭 소리가 납니다.';

  @override
  String get metronomeSound => '메트로놈 사운드';

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
  String get smartGeneratorHelp => '활성화된 비다이어토닉 옵션을 유지하면서 기능 화성 진행을 우선합니다.';

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
  String get sourceProfileRecordingInspired => '레코딩 지향';

  @override
  String get smartDiagnostics => 'Smart 진단 로그';

  @override
  String get smartDiagnosticsHelp =>
      '디버깅용으로 Smart Generator 의사결정 추적을 로그에 남깁니다.';

  @override
  String get keyModeRequiredForSmartGenerator =>
      'Smart Generator 모드를 쓰려면 최소 한 개의 키를 선택하세요.';

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
  String get chordSymbolStyle => '코드 심벌 표기 스타일';

  @override
  String get chordSymbolStyleHelp => '표시 방식만 바꾸며, 화성 로직은 그대로 유지됩니다.';

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
      '코드가 선택된 뒤 슬래시 베이스 표기를 랜덤으로 적용하며, 이전 베이스 진행은 추적하지 않습니다.';

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
      '12개의 반음 루트와 랜덤 코드 품질을 사용해 폭넓은 리딩 연습을 합니다.';

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
    return '허용 범위: $min-$max';
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
  String get voicingTopNotePreference => '탑노트 선호';

  @override
  String get voicingTopNotePreferenceHelp =>
      '추천을 선택한 탑라인 쪽으로 기울입니다. 잠근 보이싱이 먼저 우선하고, 같은 코드 반복에서는 탑라인을 안정적으로 유지합니다.';

  @override
  String get voicingTopNotePreferenceAuto => '자동';

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
  String get voicingSuggestionTopLineSubtitle => '탑라인 우선';

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
  String get voicingTopNoteLabel => '탑';

  @override
  String voicingTopNoteContextExplicit(Object note) {
    return '목표 탑노트: $note';
  }

  @override
  String voicingTopNoteContextLocked(Object note) {
    return '잠금 탑라인: $note';
  }

  @override
  String voicingTopNoteContextCarry(Object note) {
    return '반복 탑라인: $note';
  }

  @override
  String voicingTopNoteContextNearby(Object note) {
    return '$note에 가장 가까운 탑라인';
  }

  @override
  String voicingTopNoteContextFallback(Object note) {
    return '$note를 정확히 둘 탑라인이 없음';
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
  String get voicingReasonTopLineTarget => '탑라인 타깃';

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
