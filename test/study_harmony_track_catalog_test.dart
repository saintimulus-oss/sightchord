import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('track ids remain stable and distinct', () {
    expect(studyHarmonyPopTrackId, isNot(equals(studyHarmonyJazzTrackId)));
    expect(studyHarmonyPopTrackId, isNot(equals(studyHarmonyClassicalTrackId)));
    expect(
      studyHarmonyJazzTrackId,
      isNot(equals(studyHarmonyClassicalTrackId)),
    );
    expect(studyHarmonyPopTrackId, 'pop');
    expect(studyHarmonyJazzTrackId, 'jazz');
    expect(studyHarmonyClassicalTrackId, 'classical');
  });

  test('track generation profiles stay differentiated by track family', () {
    final pop = trackGenerationProfileForFlavor(
      studyHarmonyPopTrackId,
      TrackExerciseFlavor.popHookLoop,
    );
    final jazz = trackGenerationProfileForFlavor(
      studyHarmonyJazzTrackId,
      TrackExerciseFlavor.jazzDominantColor,
    );
    final classical = trackGenerationProfileForFlavor(
      studyHarmonyClassicalTrackId,
      TrackExerciseFlavor.classicalSecondaryDominant,
    );

    expect(
      pop.differentiationSignature,
      isNot(equals(jazz.differentiationSignature)),
    );
    expect(
      jazz.differentiationSignature,
      isNot(equals(classical.differentiationSignature)),
    );
    expect(pop.differentiationSignature, contains('popModernLoop'));
    expect(jazz.differentiationSignature, contains('jazzStandardsLab'));
    expect(classical.differentiationSignature, contains('classicalCadenceLab'));
  });

  test('track signature chapters use distinct lesson task shapes', () {
    final l10n = AppLocalizationsEn();
    final courses = buildStudyHarmonyTrackCourses(l10n);

    final pop = courses[studyHarmonyPopTrackId]!.chapters.firstWhere(
      (chapter) => chapter.id == 'pop-chapter-signature-loops',
    );
    final jazz = courses[studyHarmonyJazzTrackId]!.chapters.firstWhere(
      (chapter) => chapter.id == 'jazz-chapter-guide-tone-lab',
    );
    final classical = courses[studyHarmonyClassicalTrackId]!.chapters
        .firstWhere((chapter) => chapter.id == 'classical-chapter-cadence-lab');

    expect(pop.lessons.every((lesson) => lesson.tasks.length >= 2), isTrue);
    expect(jazz.lessons.every((lesson) => lesson.tasks.length >= 2), isTrue);
    expect(
      classical.lessons.every((lesson) => lesson.tasks.length >= 2),
      isTrue,
    );
    expect(jazz.lessons, hasLength(7));

    expect(
      pop.lessons[1].tasks.map((task) => task.taskKind).toList(),
      equals([
        StudyHarmonyTaskKind.progressionNonDiatonicChoice,
        StudyHarmonyTaskKind.progressionFunctionChoice,
      ]),
    );
    expect(
      jazz.lessons[1].tasks.map((task) => task.taskKind).toList(),
      equals([
        StudyHarmonyTaskKind.progressionFunctionChoice,
        StudyHarmonyTaskKind.progressionMissingChordChoice,
      ]),
    );
    expect(
      jazz.lessons[3].tasks.map((task) => task.taskKind).toList(),
      equals([
        StudyHarmonyTaskKind.progressionKeyCenterChoice,
        StudyHarmonyTaskKind.progressionFunctionChoice,
      ]),
    );
    expect(
      jazz.lessons[5].tasks.map((task) => task.taskKind).toList(),
      equals([
        StudyHarmonyTaskKind.progressionNonDiatonicChoice,
        StudyHarmonyTaskKind.progressionMissingChordChoice,
      ]),
    );
    expect(
      classical.lessons[2].tasks.map((task) => task.taskKind).toList(),
      equals([
        StudyHarmonyTaskKind.progressionNonDiatonicChoice,
        StudyHarmonyTaskKind.progressionMissingChordChoice,
      ]),
    );

    expect(
      pop.lessons[1].tasks.map((task) => task.trackExerciseFlavor).toSet(),
      equals({TrackExerciseFlavor.popBorrowedLift}),
    );
    expect(
      jazz.lessons[1].tasks.map((task) => task.trackExerciseFlavor).toSet(),
      equals({TrackExerciseFlavor.jazzShellVoicing}),
    );
    expect(
      jazz.lessons[2].tasks.map((task) => task.trackExerciseFlavor).toSet(),
      equals({TrackExerciseFlavor.jazzMinorCadence}),
    );
    expect(
      jazz.lessons[3].tasks.map((task) => task.trackExerciseFlavor).toSet(),
      equals({TrackExerciseFlavor.jazzRootlessVoicing}),
    );
    expect(
      jazz.lessons[5].tasks.map((task) => task.trackExerciseFlavor).toSet(),
      equals({TrackExerciseFlavor.jazzBackdoorCadence}),
    );
    expect(
      classical.lessons[1].tasks
          .map((task) => task.trackExerciseFlavor)
          .toSet(),
      equals({TrackExerciseFlavor.classicalInversion}),
    );
  });
}
