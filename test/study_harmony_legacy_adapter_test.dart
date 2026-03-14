import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/content/legacy_adapter.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_task_evaluators.dart';
import 'package:chordest/study_harmony/study_harmony_models.dart';

void main() {
  test('legacy level adapts into lesson and task blueprints', () {
    const legacyLevel = StudyHarmonyLevelDefinition(
      id: 'legacy-level',
      title: 'Legacy Level',
      description: 'Adapter test level',
      objective: 'Reach one correct answer',
      goalCorrectAnswers: 1,
      startingLives: 2,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: [
        StudyHarmonyPianoKeyDefinition(
          id: 'c4',
          westernLabel: 'C',
          solfegeLabel: 'Do',
          isBlack: false,
          whiteIndex: 0,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'c5',
          westernLabel: 'C',
          solfegeLabel: 'Do',
          isBlack: false,
          whiteIndex: 1,
        ),
      ],
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: 'Do (C)',
          answerSummaryLabel: 'Do (C)',
          acceptedAnswerSets: [
            {'c4'},
            {'c5'},
          ],
        ),
      ],
    );

    const adapter = StudyHarmonyLegacyLessonAdapter();
    final lesson = adapter.adaptLevel(legacyLevel);

    expect(lesson.id, legacyLevel.id);
    expect(lesson.sessionMode, StudyHarmonySessionMode.legacyLevel);
    expect(lesson.goalCorrectAnswers, legacyLevel.goalCorrectAnswers);
    expect(lesson.tasks, hasLength(1));

    final task = lesson.tasks.single;
    expect(task.taskKind, StudyHarmonyTaskKind.noteOnKeyboard);
    expect(task.answerSurface, StudyHarmonyAnswerSurfaceKind.pianoKeyboard);
    expect(task.selectionMode, StudyHarmonySelectionModeKind.multiple);
    expect(task.evaluator, isA<MultiChoiceEvaluator>());
    expect(task.pianoOptions.map((option) => option.id), ['c4', 'c5']);
  });

  test('legacy levels can be wrapped into a prototype course structure', () {
    const legacyLevel = StudyHarmonyLevelDefinition(
      id: 'legacy-level',
      title: 'Legacy Level',
      description: 'Adapter test level',
      objective: 'Reach one correct answer',
      goalCorrectAnswers: 1,
      startingLives: 2,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.choiceChips,
      selectionMode: StudyHarmonySelectionMode.single,
      answerChoices: [
        StudyHarmonyChoiceDefinition(id: 'c', label: 'C'),
        StudyHarmonyChoiceDefinition(id: 'd', label: 'D'),
      ],
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: 'Select C',
          answerSummaryLabel: 'C',
          acceptedAnswerSets: [
            {'c'},
          ],
        ),
      ],
    );

    const adapter = StudyHarmonyLegacyLessonAdapter();
    final course = adapter.buildPrototypeCourse([
      legacyLevel,
    ], AppLocalizationsEn());

    expect(course.id, StudyHarmonyLegacyLessonAdapter.prototypeCourseId);
    expect(course.chapters, hasLength(1));
    expect(course.chapters.single.lessons.single.id, legacyLevel.id);
    expect(
      course.chapters.single.lessons.single.tasks.single.taskKind,
      StudyHarmonyTaskKind.noteNameChoice,
    );
  });
}

