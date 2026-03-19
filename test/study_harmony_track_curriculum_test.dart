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

  test('track signature chapters use distinct lesson and task mixes', () {
    final popChapter = buildStudyHarmonyPopProgressionChapters(
      l10n: l10n,
      courseId: studyHarmonyPopCourseId,
    ).single;
    final jazzChapter = buildStudyHarmonyJazzProgressionChapters(
      l10n: l10n,
      courseId: studyHarmonyJazzCourseId,
    ).single;
    final classicalChapter = buildStudyHarmonyClassicalProgressionChapters(
      l10n: l10n,
      courseId: studyHarmonyClassicalCourseId,
    ).single;

    expect(popChapter.lessons, hasLength(4));
    expect(jazzChapter.lessons, hasLength(7));
    expect(classicalChapter.lessons, hasLength(4));

    expect(popChapter.lessons.first.tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionKeyCenterChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(popChapter.lessons[1].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionNonDiatonicChoice,
      StudyHarmonyTaskKind.progressionFunctionChoice,
    ]);
    expect(
      popChapter.lessons
          .expand((lesson) => lesson.tasks)
          .any(
            (task) =>
                task.taskKind == StudyHarmonyTaskKind.progressionFunctionChoice,
          ),
      isTrue,
    );

    expect(jazzChapter.lessons.first.tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionFunctionChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(jazzChapter.lessons[1].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionFunctionChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(jazzChapter.lessons[2].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionKeyCenterChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(jazzChapter.lessons[3].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionKeyCenterChoice,
      StudyHarmonyTaskKind.progressionFunctionChoice,
    ]);
    expect(jazzChapter.lessons[4].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionNonDiatonicChoice,
      StudyHarmonyTaskKind.progressionFunctionChoice,
    ]);
    expect(jazzChapter.lessons[5].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionNonDiatonicChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(jazzChapter.lessons.last.tasks, hasLength(6));

    expect(classicalChapter.lessons.first.tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionFunctionChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(classicalChapter.lessons[2].tasks.map((task) => task.taskKind), [
      StudyHarmonyTaskKind.progressionNonDiatonicChoice,
      StudyHarmonyTaskKind.progressionMissingChordChoice,
    ]);
    expect(
      classicalChapter.lessons
          .expand((lesson) => lesson.tasks)
          .any(
            (task) =>
                task.trackExerciseFlavor ==
                TrackExerciseFlavor.classicalSecondaryDominant,
          ),
      isTrue,
    );
  });

  test('track-generated task instances carry distinct explanation tone', () {
    final popTask =
        buildStudyHarmonyPopProgressionChapters(
          l10n: l10n,
          courseId: studyHarmonyPopCourseId,
        ).single.lessons[1].tasks.first.createInstance(
          sequenceNumber: 1,
          random: Random(12),
        );
    final jazzTask =
        buildStudyHarmonyJazzProgressionChapters(
          l10n: l10n,
          courseId: studyHarmonyJazzCourseId,
        ).single.lessons[3].tasks.first.createInstance(
          sequenceNumber: 1,
          random: Random(13),
        );
    final classicalTask =
        buildStudyHarmonyClassicalProgressionChapters(
          l10n: l10n,
          courseId: studyHarmonyClassicalCourseId,
        ).single.lessons.first.tasks.first.createInstance(
          sequenceNumber: 1,
          random: Random(14),
        );

    expect(
      popTask.explanationBody,
      contains(l10n.studyHarmonyTrackPopTheoryTone),
    );
    expect(popTask.explanationBody, contains(l10n.studyHarmonyTrackPopFocus2));
    expect(
      popTask.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextPop),
        contains(l10n.studyHarmonyTrackPopFocus2),
      ),
    );

    expect(
      jazzTask.explanationBody,
      contains(l10n.studyHarmonyTrackJazzTheoryTone),
    );
    expect(
      jazzTask.explanationBody,
      contains(l10n.studyHarmonyTrackJazzFocus2),
    );
    expect(
      jazzTask.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextJazz),
        contains(l10n.studyHarmonyTrackJazzFocus2),
      ),
    );

    expect(
      classicalTask.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalTheoryTone),
    );
    expect(
      classicalTask.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalFocus1),
    );
    expect(
      classicalTask.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextClassical),
        contains(l10n.studyHarmonyTrackClassicalFocus1),
      ),
    );
  });
}
