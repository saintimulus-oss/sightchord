import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/study_harmony/study_harmony_engine.dart';
import 'package:chordest/study_harmony/study_harmony_models.dart';

const StudyHarmonyLevelDefinition _engineTestLevel =
    StudyHarmonyLevelDefinition(
      id: 'engine-test',
      title: 'Engine Test',
      description: 'Engine test level',
      objective: 'Reach 2 correct answers',
      goalCorrectAnswers: 2,
      startingLives: 2,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: [
        StudyHarmonyPianoKeyDefinition(
          id: 'c4',
          westernLabel: 'C',
          solfegeLabel: '도',
          isBlack: false,
          whiteIndex: 0,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'c5',
          westernLabel: 'C',
          solfegeLabel: '도',
          isBlack: false,
          whiteIndex: 1,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'e4',
          westernLabel: 'E',
          solfegeLabel: '미',
          isBlack: false,
          whiteIndex: 2,
        ),
      ],
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
      ],
    );

void main() {
  test('accepts either low or high C when the prompt answer allows both', () {
    const doOnlyLevel = StudyHarmonyLevelDefinition(
      id: 'do-only',
      title: 'Do Only',
      description: 'Only C answers',
      objective: 'Answer C',
      goalCorrectAnswers: 1,
      startingLives: 2,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: [
        StudyHarmonyPianoKeyDefinition(
          id: 'c4',
          westernLabel: 'C',
          solfegeLabel: '도',
          isBlack: false,
          whiteIndex: 0,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'c5',
          westernLabel: 'C',
          solfegeLabel: '도',
          isBlack: false,
          whiteIndex: 1,
        ),
      ],
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
      ],
    );

    final engine = StudyHarmonyLevelEngine(
      level: doOnlyLevel,
      random: Random(0),
    );

    engine.toggleAnswer('c5');
    final feedback = engine.submit();

    expect(feedback.type, StudyHarmonySubmissionFeedbackType.correct);
    expect(engine.correctAnswers, 1);
    expect(engine.livesRemaining, 2);
  });

  test(
    'wrong submissions remove lives and exact matching rejects extra keys',
    () {
      final engine = StudyHarmonyLevelEngine(
        level: _engineTestLevel,
        random: Random(0),
      );

      engine.toggleAnswer('c4');
      engine.toggleAnswer('c5');
      final feedback = engine.submit();

      expect(feedback.type, StudyHarmonySubmissionFeedbackType.incorrect);
      expect(engine.livesRemaining, 1);
      expect(engine.correctAnswers, 0);
    },
  );

  test('restart resets score, attempts, and lives after game over', () {
    const oneLifeLevel = StudyHarmonyLevelDefinition(
      id: 'one-life',
      title: 'One Life',
      description: 'Lose once',
      objective: 'Test restart',
      goalCorrectAnswers: 1,
      startingLives: 1,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: [
        StudyHarmonyPianoKeyDefinition(
          id: 'c4',
          westernLabel: 'C',
          solfegeLabel: '도',
          isBlack: false,
          whiteIndex: 0,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'd4',
          westernLabel: 'D',
          solfegeLabel: '레',
          isBlack: false,
          whiteIndex: 1,
        ),
      ],
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: '도 (C)',
          answerSummaryLabel: '도 (C)',
          acceptedAnswerSets: [
            {'c4'},
          ],
        ),
      ],
    );

    final engine = StudyHarmonyLevelEngine(
      level: oneLifeLevel,
      random: Random(0),
    );

    engine.toggleAnswer('d4');
    engine.submit();

    expect(engine.isGameOver, isTrue);

    engine.restart();

    expect(engine.isGameOver, isFalse);
    expect(engine.correctAnswers, 0);
    expect(engine.attempts, 0);
    expect(engine.livesRemaining, 1);
    expect(engine.selectedAnswerIds, isEmpty);
  });
}

