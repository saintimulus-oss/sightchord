import '../l10n/app_localizations.dart';
import 'study_harmony_models.dart';

const List<StudyHarmonyPianoKeyDefinition> studyHarmonyKeyboardKeys = [
  StudyHarmonyPianoKeyDefinition(
    id: 'c4',
    westernLabel: 'C',
    solfegeLabel: 'Do',
    isBlack: false,
    whiteIndex: 0,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'cSharp4',
    westernLabel: 'C#',
    solfegeLabel: 'Do#',
    isBlack: true,
    blackGapAfterWhiteIndex: 0,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'd4',
    westernLabel: 'D',
    solfegeLabel: 'Re',
    isBlack: false,
    whiteIndex: 1,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'dSharp4',
    westernLabel: 'D#',
    solfegeLabel: 'Re#',
    isBlack: true,
    blackGapAfterWhiteIndex: 1,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'e4',
    westernLabel: 'E',
    solfegeLabel: 'Mi',
    isBlack: false,
    whiteIndex: 2,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'f4',
    westernLabel: 'F',
    solfegeLabel: 'Fa',
    isBlack: false,
    whiteIndex: 3,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'fSharp4',
    westernLabel: 'F#',
    solfegeLabel: 'Fa#',
    isBlack: true,
    blackGapAfterWhiteIndex: 3,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'g4',
    westernLabel: 'G',
    solfegeLabel: 'Sol',
    isBlack: false,
    whiteIndex: 4,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'gSharp4',
    westernLabel: 'G#',
    solfegeLabel: 'Sol#',
    isBlack: true,
    blackGapAfterWhiteIndex: 4,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'a4',
    westernLabel: 'A',
    solfegeLabel: 'La',
    isBlack: false,
    whiteIndex: 5,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'aSharp4',
    westernLabel: 'A#',
    solfegeLabel: 'La#',
    isBlack: true,
    blackGapAfterWhiteIndex: 5,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'b4',
    westernLabel: 'B',
    solfegeLabel: 'Ti',
    isBlack: false,
    whiteIndex: 6,
  ),
  StudyHarmonyPianoKeyDefinition(
    id: 'c5',
    westernLabel: 'C',
    solfegeLabel: 'Do',
    isBlack: false,
    whiteIndex: 7,
  ),
];

List<StudyHarmonyPianoKeyDefinition> buildStudyHarmonyKeyboardKeys(
  AppLocalizations l10n,
) {
  final doLabel = l10n.studyHarmonySolfegeDo;
  final reLabel = l10n.studyHarmonySolfegeRe;
  final miLabel = l10n.studyHarmonySolfegeMi;
  final faLabel = l10n.studyHarmonySolfegeFa;
  final solLabel = l10n.studyHarmonySolfegeSol;
  final laLabel = l10n.studyHarmonySolfegeLa;
  final tiLabel = l10n.studyHarmonySolfegeTi;

  String sharp(String syllable) => '$syllable#';

  return [
    StudyHarmonyPianoKeyDefinition(
      id: 'c4',
      westernLabel: 'C',
      solfegeLabel: doLabel,
      isBlack: false,
      whiteIndex: 0,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'cSharp4',
      westernLabel: 'C#',
      solfegeLabel: sharp(doLabel),
      isBlack: true,
      blackGapAfterWhiteIndex: 0,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'd4',
      westernLabel: 'D',
      solfegeLabel: reLabel,
      isBlack: false,
      whiteIndex: 1,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'dSharp4',
      westernLabel: 'D#',
      solfegeLabel: sharp(reLabel),
      isBlack: true,
      blackGapAfterWhiteIndex: 1,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'e4',
      westernLabel: 'E',
      solfegeLabel: miLabel,
      isBlack: false,
      whiteIndex: 2,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'f4',
      westernLabel: 'F',
      solfegeLabel: faLabel,
      isBlack: false,
      whiteIndex: 3,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'fSharp4',
      westernLabel: 'F#',
      solfegeLabel: sharp(faLabel),
      isBlack: true,
      blackGapAfterWhiteIndex: 3,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'g4',
      westernLabel: 'G',
      solfegeLabel: solLabel,
      isBlack: false,
      whiteIndex: 4,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'gSharp4',
      westernLabel: 'G#',
      solfegeLabel: sharp(solLabel),
      isBlack: true,
      blackGapAfterWhiteIndex: 4,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'a4',
      westernLabel: 'A',
      solfegeLabel: laLabel,
      isBlack: false,
      whiteIndex: 5,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'aSharp4',
      westernLabel: 'A#',
      solfegeLabel: sharp(laLabel),
      isBlack: true,
      blackGapAfterWhiteIndex: 5,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'b4',
      westernLabel: 'B',
      solfegeLabel: tiLabel,
      isBlack: false,
      whiteIndex: 6,
    ),
    StudyHarmonyPianoKeyDefinition(
      id: 'c5',
      westernLabel: 'C',
      solfegeLabel: doLabel,
      isBlack: false,
      whiteIndex: 7,
    ),
  ];
}

List<StudyHarmonyLevelDefinition> buildStudyHarmonyLevels(
  AppLocalizations l10n,
) {
  final keyboardKeys = buildStudyHarmonyKeyboardKeys(l10n);

  String noteLabel(String solfege, String western) => '$solfege ($western)';

  final doLabel = l10n.studyHarmonySolfegeDo;
  final reLabel = l10n.studyHarmonySolfegeRe;
  final miLabel = l10n.studyHarmonySolfegeMi;
  final faLabel = l10n.studyHarmonySolfegeFa;
  final solLabel = l10n.studyHarmonySolfegeSol;
  final laLabel = l10n.studyHarmonySolfegeLa;
  final tiLabel = l10n.studyHarmonySolfegeTi;

  return [
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-1',
      title: l10n.studyHarmonyPrototypeLevel1Title,
      description: l10n.studyHarmonyPrototypeLevel1Description,
      objective: l10n.studyHarmonyPrototypeLevelObjective,
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: keyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: noteLabel(doLabel, 'C'),
          answerSummaryLabel: noteLabel(doLabel, 'C'),
          acceptedAnswerSets: const [
            {'c4'},
            {'c5'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: noteLabel(miLabel, 'E'),
          answerSummaryLabel: noteLabel(miLabel, 'E'),
          acceptedAnswerSets: const [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: noteLabel(solLabel, 'G'),
          answerSummaryLabel: noteLabel(solLabel, 'G'),
          acceptedAnswerSets: const [
            {'g4'},
          ],
        ),
      ],
    ),
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-2',
      title: l10n.studyHarmonyPrototypeLevel2Title,
      description: l10n.studyHarmonyPrototypeLevel2Description,
      objective: l10n.studyHarmonyPrototypeLevelObjective,
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: keyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: noteLabel(doLabel, 'C'),
          answerSummaryLabel: noteLabel(doLabel, 'C'),
          acceptedAnswerSets: const [
            {'c4'},
            {'c5'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 're',
          promptLabel: noteLabel(reLabel, 'D'),
          answerSummaryLabel: noteLabel(reLabel, 'D'),
          acceptedAnswerSets: const [
            {'d4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: noteLabel(miLabel, 'E'),
          answerSummaryLabel: noteLabel(miLabel, 'E'),
          acceptedAnswerSets: const [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: noteLabel(solLabel, 'G'),
          answerSummaryLabel: noteLabel(solLabel, 'G'),
          acceptedAnswerSets: const [
            {'g4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'la',
          promptLabel: noteLabel(laLabel, 'A'),
          answerSummaryLabel: noteLabel(laLabel, 'A'),
          acceptedAnswerSets: const [
            {'a4'},
          ],
        ),
      ],
    ),
    StudyHarmonyLevelDefinition(
      id: 'temporary-level-3',
      title: l10n.studyHarmonyPrototypeLevel3Title,
      description: l10n.studyHarmonyPrototypeLevel3Description,
      objective: l10n.studyHarmonyPrototypeLevelObjective,
      goalCorrectAnswers: 10,
      startingLives: 3,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: keyboardKeys,
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do-low',
          promptLabel: l10n.studyHarmonyPrototypeLowCLabel(doLabel),
          answerSummaryLabel: l10n.studyHarmonyPrototypeLowCLabel(doLabel),
          acceptedAnswerSets: const [
            {'c4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 're',
          promptLabel: noteLabel(reLabel, 'D'),
          answerSummaryLabel: noteLabel(reLabel, 'D'),
          acceptedAnswerSets: const [
            {'d4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'mi',
          promptLabel: noteLabel(miLabel, 'E'),
          answerSummaryLabel: noteLabel(miLabel, 'E'),
          acceptedAnswerSets: const [
            {'e4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'fa',
          promptLabel: noteLabel(faLabel, 'F'),
          answerSummaryLabel: noteLabel(faLabel, 'F'),
          acceptedAnswerSets: const [
            {'f4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'sol',
          promptLabel: noteLabel(solLabel, 'G'),
          answerSummaryLabel: noteLabel(solLabel, 'G'),
          acceptedAnswerSets: const [
            {'g4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'la',
          promptLabel: noteLabel(laLabel, 'A'),
          answerSummaryLabel: noteLabel(laLabel, 'A'),
          acceptedAnswerSets: const [
            {'a4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'si',
          promptLabel: noteLabel(tiLabel, 'B'),
          answerSummaryLabel: noteLabel(tiLabel, 'B'),
          acceptedAnswerSets: const [
            {'b4'},
          ],
        ),
        StudyHarmonyPromptDefinition(
          id: 'do-high',
          promptLabel: l10n.studyHarmonyPrototypeHighCLabel(doLabel),
          answerSummaryLabel: l10n.studyHarmonyPrototypeHighCLabel(doLabel),
          acceptedAnswerSets: const [
            {'c5'},
          ],
        ),
      ],
    ),
  ];
}

StudyHarmonyLevelDefinition? studyHarmonyLevelById(
  Iterable<StudyHarmonyLevelDefinition> levels,
  String levelId,
) {
  for (final level in levels) {
    if (level.id == levelId) {
      return level;
    }
  }
  return null;
}
