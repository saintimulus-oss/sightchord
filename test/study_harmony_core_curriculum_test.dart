import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/application/study_harmony_session_controller.dart';
import 'package:chordest/study_harmony/content/core_curriculum_catalog.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/study_harmony_catalog.dart';

void main() {
  StudyHarmonyCourseDefinition buildCourse() =>
      buildStudyHarmonyCoreCourse(AppLocalizationsEn());

  test('generated task instances stay valid across representative seeds', () {
    final course = buildCourse();
    var sequenceNumber = 0;

    for (final chapter in course.chapters) {
      for (final lesson in chapter.lessons) {
        for (final blueprint in lesson.tasks) {
          for (var seed = 0; seed < 10; seed += 1) {
            final task = blueprint.createInstance(
              sequenceNumber: sequenceNumber++,
              random: Random(seed),
            );

            expect(task.prompt.primaryLabel.trim(), isNotEmpty);
            expect(task.answerOptions, isNotEmpty);

            final optionIds = task.answerOptions
                .map((option) => option.id)
                .toSet();
            expect(optionIds.length, task.answerOptions.length);

            for (final option in task.answerOptions) {
              expect(option.displayLabel.trim(), isNotEmpty);
            }

            if (task.answerSurface ==
                StudyHarmonyAnswerSurfaceKind.choiceChips) {
              expect(task.choiceOptions.length, greaterThanOrEqualTo(2));
            }

            if (task.prompt.showsPianoPreview) {
              final previewKeyIds = {
                for (final key in studyHarmonyKeyboardKeys) key.id,
              };
              expect(task.prompt.highlightedAnswerIds, isNotEmpty);
              expect(
                task.prompt.highlightedAnswerIds.difference(previewKeyIds),
                isEmpty,
              );
            }

            final evaluator = task.evaluator;
            expect(
              evaluator.supportedTaskKinds.contains(task.taskKind),
              isTrue,
            );
            expect(evaluator, isA<StudyHarmonyAcceptedAnswerSetProvider>());

            final provider = evaluator as StudyHarmonyAcceptedAnswerSetProvider;
            expect(provider.acceptedAnswerSets, isNotEmpty);
            for (final acceptedSet in provider.acceptedAnswerSets) {
              expect(acceptedSet, isNotEmpty);
              expect(acceptedSet.difference(optionIds), isEmpty);
            }
          }
        }
      }
    }
  });

  test('representative lessons can be cleared with evaluator answers', () {
    final course = buildCourse();
    final representativeLessons = [
      course.chapters[0].lessons.first,
      course.chapters[1].lessons.last,
      course.chapters[2].lessons[1],
      course.chapters[3].lessons.last,
      course.chapters[4].lessons.first,
      course.chapters[5].lessons.last,
    ];

    for (final lesson in representativeLessons) {
      final controller = StudyHarmonySessionController(
        lesson: lesson,
        random: Random(7),
      );

      _playToCompletion(controller);

      expect(controller.state.isCompleted, isTrue, reason: lesson.id);
      expect(
        controller.state.correctAnswers,
        greaterThanOrEqualTo(lesson.goalCorrectAnswers),
      );
    }
  });
}

void _playToCompletion(StudyHarmonySessionController controller) {
  var safety = 0;

  while (!controller.state.isFinished && safety < 200) {
    final phase = controller.state.phase;
    if (phase == StudyHarmonySessionPhase.submittedCorrect ||
        phase == StudyHarmonySessionPhase.submittedIncorrect) {
      controller.toggleAnswer('__advance__');
      safety += 1;
      continue;
    }

    final task = controller.state.currentTask;
    expect(task, isNotNull);

    final evaluator = task!.evaluator as StudyHarmonyAcceptedAnswerSetProvider;
    final acceptedAnswers = evaluator.acceptedAnswerSets.first;
    for (final answerId in acceptedAnswers) {
      controller.toggleAnswer(answerId);
    }

    final result = controller.submit();
    expect(result.isCorrect, isTrue, reason: task.blueprintId);
    safety += 1;
  }

  expect(safety, lessThan(200));
}

