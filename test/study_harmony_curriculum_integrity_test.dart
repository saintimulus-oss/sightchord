import 'dart:math';

import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/content/classical_progression_curriculum.dart';
import 'package:chordest/study_harmony/content/jazz_progression_curriculum.dart';
import 'package:chordest/study_harmony/content/pop_progression_curriculum.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  bool isProgressionTask(StudyHarmonyTaskKind kind) {
    return switch (kind) {
      StudyHarmonyTaskKind.progressionKeyCenterChoice ||
      StudyHarmonyTaskKind.progressionFunctionChoice ||
      StudyHarmonyTaskKind.progressionNonDiatonicChoice ||
      StudyHarmonyTaskKind.progressionMissingChordChoice => true,
      _ => false,
    };
  }

  StudyHarmonyTaskInstance generateStableInstance(
    StudyHarmonyTaskBlueprint task,
  ) {
    for (var seed = 1; seed <= 24; seed++) {
      try {
        return task.createInstance(sequenceNumber: 1, random: Random(seed));
      } catch (_) {
        continue;
      }
    }
    fail('unable to generate stable instance for ${task.id}');
  }

  test(
    'track curriculum keeps chapter, lesson, and task ids globally unique',
    () {
      final courses = buildStudyHarmonyTrackCourses(l10n);
      final chapterIds = <String>{};
      final lessonIds = <String>{};
      final taskIds = <String>{};

      for (final courseEntry in courses.entries) {
        final course = courseEntry.value;
        expect(course.id.trim(), isNotEmpty);
        expect(course.title.trim(), isNotEmpty);
        expect(course.description.trim(), isNotEmpty);
        expect(course.chapters, isNotEmpty);

        for (final chapter in course.chapters) {
          expect(
            chapterIds.add(chapter.id),
            isTrue,
            reason: 'duplicate chapter id: ${chapter.id}',
          );
          expect(chapter.title.trim(), isNotEmpty);
          expect(chapter.description.trim(), isNotEmpty);
          expect(chapter.lessons, isNotEmpty);

          for (final lesson in chapter.lessons) {
            expect(
              lessonIds.add(lesson.id),
              isTrue,
              reason: 'duplicate lesson id: ${lesson.id}',
            );
            expect(lesson.chapterId, chapter.id);
            expect(lesson.title.trim(), isNotEmpty);
            expect(lesson.description.trim(), isNotEmpty);
            expect(lesson.objectiveLabel.trim(), isNotEmpty);
            expect(lesson.tasks, isNotEmpty);

            for (final task in lesson.tasks) {
              expect(
                taskIds.add(task.id),
                isTrue,
                reason: 'duplicate task id: ${task.id}',
              );
              expect(
                task.lessonId.startsWith(lesson.id),
                isTrue,
                reason:
                    'task lesson linkage drifted: ${task.id} -> ${task.lessonId}',
              );
              expect(task.promptSpec.id.trim(), isNotEmpty);
              expect(task.answerSummaryLabel.trim(), isNotEmpty);
            }
          }
        }
      }
    },
  );

  test(
    'progression tasks carry track flavor and explanation data in signature chapters',
    () {
      final courses = buildStudyHarmonyTrackCourses(l10n);

      for (final trackId in <StudyHarmonyTrackId>[
        studyHarmonyPopTrackId,
        studyHarmonyJazzTrackId,
        studyHarmonyClassicalTrackId,
      ]) {
        final course = courses[trackId];
        expect(course, isNotNull);

        final signatureId = switch (trackId) {
          studyHarmonyPopTrackId => studyHarmonyPopSignatureChapterId,
          studyHarmonyJazzTrackId => studyHarmonyJazzSignatureChapterId,
          studyHarmonyClassicalTrackId =>
            studyHarmonyClassicalSignatureChapterId,
          _ => '',
        };
        final signatureChapters = course!.chapters.where(
          (chapter) => chapter.id == signatureId,
        );
        expect(signatureChapters, isNotEmpty);

        for (final chapter in signatureChapters) {
          final progressionTasks = chapter.lessons
              .expand((lesson) => lesson.tasks)
              .where((task) => isProgressionTask(task.taskKind))
              .toList(growable: false);

          expect(
            progressionTasks,
            isNotEmpty,
            reason:
                'signature chapter should expose progression tasks: ${chapter.id}',
          );
          expect(
            progressionTasks.every((task) => task.trackExerciseFlavor != null),
            isTrue,
            reason: 'progression task missing track flavor in ${chapter.id}',
          );
          expect(
            progressionTasks.any((task) {
              try {
                final instance = generateStableInstance(task);
                return instance.trackExerciseFlavor != null &&
                    ((instance.explanationBody?.trim().isNotEmpty ?? false) ||
                        instance.explanationBundle != null);
              } catch (_) {
                return false;
              }
            }),
            isTrue,
            reason:
                'signature chapter missing a viable explained progression sample in ${chapter.id}',
          );
          expect(
            progressionTasks.any((task) {
              try {
                return generateStableInstance(task).answerOptions.isNotEmpty;
              } catch (_) {
                return false;
              }
            }),
            isTrue,
            reason:
                'signature chapter missing a viable progression answer set in ${chapter.id}',
          );
        }
      }
    },
  );
}
