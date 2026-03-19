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

  StudyHarmonyChapterDefinition chapterForTrack(
    Map<StudyHarmonyTrackId, StudyHarmonyCourseDefinition> courses,
    StudyHarmonyTrackId trackId,
    StudyHarmonyChapterId chapterId,
  ) {
    final course = courses[trackId];
    expect(course, isNotNull);
    return course!.chapters.firstWhere((chapter) => chapter.id == chapterId);
  }

  test('signature chapters use distinct lesson and task mixes per track', () {
    final courses = buildStudyHarmonyTrackCourses(l10n);

    final popChapter = chapterForTrack(
      courses,
      studyHarmonyPopTrackId,
      studyHarmonyPopSignatureChapterId,
    );
    final jazzChapter = chapterForTrack(
      courses,
      studyHarmonyJazzTrackId,
      studyHarmonyJazzSignatureChapterId,
    );
    final classicalChapter = chapterForTrack(
      courses,
      studyHarmonyClassicalTrackId,
      studyHarmonyClassicalSignatureChapterId,
    );

    expect(
      popChapter.lessons
          .map((lesson) => lesson.tasks.map((task) => task.taskKind).toList())
          .toList(),
      [
        [
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionMissingChordChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
      ],
    );

    expect(
      jazzChapter.lessons
          .map((lesson) => lesson.tasks.map((task) => task.taskKind).toList())
          .toList(),
      [
        [
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
      ],
    );

    expect(
      classicalChapter.lessons
          .map((lesson) => lesson.tasks.map((task) => task.taskKind).toList())
          .toList(),
      [
        [
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionMissingChordChoice,
          StudyHarmonyTaskKind.progressionFunctionChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
        ],
        [
          StudyHarmonyTaskKind.progressionFunctionChoice,
          StudyHarmonyTaskKind.progressionMissingChordChoice,
          StudyHarmonyTaskKind.progressionNonDiatonicChoice,
          StudyHarmonyTaskKind.progressionKeyCenterChoice,
        ],
      ],
    );
  });

  test('generated lesson instances carry track-specific explanation tone', () {
    final courses = buildStudyHarmonyTrackCourses(l10n);

    final popLesson = chapterForTrack(
      courses,
      studyHarmonyPopTrackId,
      studyHarmonyPopSignatureChapterId,
    ).lessons[1];
    final jazzLesson = chapterForTrack(
      courses,
      studyHarmonyJazzTrackId,
      studyHarmonyJazzSignatureChapterId,
    ).lessons[3];
    final classicalLesson = chapterForTrack(
      courses,
      studyHarmonyClassicalTrackId,
      studyHarmonyClassicalSignatureChapterId,
    ).lessons[2];

    final popInstance = popLesson.tasks.first.createInstance(
      sequenceNumber: 1,
      random: Random(21),
    );
    final jazzInstance = jazzLesson.tasks.first.createInstance(
      sequenceNumber: 1,
      random: Random(22),
    );
    final classicalInstance = classicalLesson.tasks.first.createInstance(
      sequenceNumber: 1,
      random: Random(23),
    );

    expect(
      popInstance.explanationBody,
      contains(l10n.studyHarmonyTrackPopTheoryTone),
    );
    expect(
      popInstance.explanationBody,
      contains(l10n.studyHarmonyTrackPopFocus2),
    );
    expect(
      jazzInstance.explanationBody,
      contains(l10n.studyHarmonyTrackJazzTheoryTone),
    );
    expect(
      jazzInstance.explanationBody,
      contains(l10n.studyHarmonyTrackJazzFocus2),
    );
    expect(
      classicalInstance.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalTheoryTone),
    );
    expect(
      classicalInstance.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalFocus3),
    );

    expect(
      popInstance.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextPop),
        contains(l10n.studyHarmonyTrackPopFocus2),
      ),
    );
    expect(
      jazzInstance.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextJazz),
        contains(l10n.studyHarmonyTrackJazzFocus2),
      ),
    );
    expect(
      classicalInstance.explanationBundle?.trackContext,
      allOf(
        contains(l10n.explanationTrackContextClassical),
        contains(l10n.studyHarmonyTrackClassicalFocus3),
      ),
    );
  });
}
