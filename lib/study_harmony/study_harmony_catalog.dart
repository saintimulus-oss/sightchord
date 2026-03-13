import 'study_harmony_models.dart';

const List<StudyHarmonyPianoKeyDefinition> studyHarmonyKeyboardKeys = [
  StudyHarmonyPianoKeyDefinition(
    id: 'c4',
    westernLabel: 'C',
    solfegeLabel: '도',
    isBlack: false,
    whiteIndex: 0,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'cSharp4',
    westernLabel: 'C#',
    solfegeLabel: '도#',
    isBlack: true,
    blackGapAfterWhiteIndex: 0,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'd4',
    westernLabel: 'D',
    solfegeLabel: '레',
    isBlack: false,
    whiteIndex: 1,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'dSharp4',
    westernLabel: 'D#',
    solfegeLabel: '레#',
    isBlack: true,
    blackGapAfterWhiteIndex: 1,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'e4',
    westernLabel: 'E',
    solfegeLabel: '미',
    isBlack: false,
    whiteIndex: 2,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'f4',
    westernLabel: 'F',
    solfegeLabel: '파',
    isBlack: false,
    whiteIndex: 3,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'fSharp4',
    westernLabel: 'F#',
    solfegeLabel: '파#',
    isBlack: true,
    blackGapAfterWhiteIndex: 3,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'g4',
    westernLabel: 'G',
    solfegeLabel: '솔',
    isBlack: false,
    whiteIndex: 4,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'gSharp4',
    westernLabel: 'G#',
    solfegeLabel: '솔#',
    isBlack: true,
    blackGapAfterWhiteIndex: 4,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'a4',
    westernLabel: 'A',
    solfegeLabel: '라',
    isBlack: false,
    whiteIndex: 5,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'aSharp4',
    westernLabel: 'A#',
    solfegeLabel: '라#',
    isBlack: true,
    blackGapAfterWhiteIndex: 5,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'b4',
    westernLabel: 'B',
    solfegeLabel: '시',
    isBlack: false,
    whiteIndex: 6,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'c5',
    westernLabel: 'C',
    solfegeLabel: '도',
    isBlack: false,
    whiteIndex: 7,
  ),
];

const StudyHarmonyLevelDefinition studyHarmonyTemporaryLevel1 =
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-1',
      title: '임시 레벨 1 · 도 / 미 / 솔',
      description: '도, 미, 솔만 구분하는 가장 기본적인 테스트 레벨입니다.',
      objective: '라이프 3개를 잃기 전에 10문제를 맞히면 클리어',
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: studyHarmonyKeyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: '도 (C)',
          answerSummaryLabel: '도 (C)',
          acceptedAnswerSets: [
            {'c4'},
            {'c5'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: '미 (E)',
          answerSummaryLabel: '미 (E)',
          acceptedAnswerSets: [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: '솔 (G)',
          answerSummaryLabel: '솔 (G)',
          acceptedAnswerSets: [
            {'g4'},
          ],
        ),
      ],
    );

const StudyHarmonyLevelDefinition studyHarmonyTemporaryLevel2 =
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-2',
      title: '임시 레벨 2 · 도 / 레 / 미 / 솔 / 라',
      description: '도, 레, 미, 솔, 라를 빠르게 찾는 중간 단계 테스트 레벨입니다.',
      objective: '라이프 3개를 잃기 전에 10문제를 맞히면 클리어',
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: studyHarmonyKeyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: '도 (C)',
          answerSummaryLabel: '도 (C)',
          acceptedAnswerSets: [
            {'c4'},
            {'c5'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 're',
          promptLabel: '레 (D)',
          answerSummaryLabel: '레 (D)',
          acceptedAnswerSets: [
            {'d4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: '미 (E)',
          answerSummaryLabel: '미 (E)',
          acceptedAnswerSets: [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: '솔 (G)',
          answerSummaryLabel: '솔 (G)',
          acceptedAnswerSets: [
            {'g4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'la',
          promptLabel: '라 (A)',
          answerSummaryLabel: '라 (A)',
          acceptedAnswerSets: [
            {'a4'},
          ],
        ),
      ],
    );

const StudyHarmonyLevelDefinition studyHarmonyTemporaryLevel3 =
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-3',
      title: '임시 레벨 3 · 도 / 레 / 미 / 파 / 솔 / 라 / 시 / 도',
      description: '도레미파솔라시도 전체를 다루는 옥타브 완성 테스트 레벨입니다.',
      objective: '라이프 3개를 잃기 전에 10문제를 맞히면 클리어',
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: studyHarmonyKeyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do-low',
          promptLabel: '도 (아래 C)',
          answerSummaryLabel: '도 (아래 C)',
          acceptedAnswerSets: [
            {'c4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 're',
          promptLabel: '레 (D)',
          answerSummaryLabel: '레 (D)',
          acceptedAnswerSets: [
            {'d4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: '미 (E)',
          answerSummaryLabel: '미 (E)',
          acceptedAnswerSets: [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'fa',
          promptLabel: '파 (F)',
          answerSummaryLabel: '파 (F)',
          acceptedAnswerSets: [
            {'f4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: '솔 (G)',
          answerSummaryLabel: '솔 (G)',
          acceptedAnswerSets: [
            {'g4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'la',
          promptLabel: '라 (A)',
          answerSummaryLabel: '라 (A)',
          acceptedAnswerSets: [
            {'a4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'si',
          promptLabel: '시 (B)',
          answerSummaryLabel: '시 (B)',
          acceptedAnswerSets: [
            {'b4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'do-high',
          promptLabel: '도 (위 C)',
          answerSummaryLabel: '도 (위 C)',
          acceptedAnswerSets: [
            {'c5'},
          ],
        ),
      ],
    );

const List<StudyHarmonyLevelDefinition> studyHarmonyLevels = [
  studyHarmonyTemporaryLevel1,
  studyHarmonyTemporaryLevel2,
  studyHarmonyTemporaryLevel3,
];
