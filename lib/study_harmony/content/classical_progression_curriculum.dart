import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import 'study_harmony_track_catalog.dart';
import 'track_progression_curriculum_factory.dart';

const StudyHarmonyChapterId studyHarmonyClassicalSignatureChapterId =
    'classical-chapter-cadence-lab';

List<StudyHarmonyChapterDefinition>
buildStudyHarmonyClassicalProgressionChapters({
  required AppLocalizations l10n,
  required StudyHarmonyCourseId courseId,
}) {
  return [
    buildTrackSignatureChapter(
      l10n: l10n,
      trackId: studyHarmonyClassicalTrackId,
      courseId: courseId,
      chapterId: studyHarmonyClassicalSignatureChapterId,
      title: l10n.studyHarmonyClassicalChapterCadenceLabTitle,
      description: l10n.studyHarmonyClassicalChapterCadenceLabDescription,
      skillTags: const {
        'progression.function',
        'progression.fillBlank',
        'progression.nonDiatonic',
        'classical.cadence',
        'classical.inversion',
        'classical.secondaryDominant',
      },
      lessons: [
        TrackCurriculumLessonSpec(
          id: 'classical-signature-1-cadence',
          title: l10n.studyHarmonyClassicalLessonCadenceTitle,
          description: l10n.studyHarmonyClassicalLessonCadenceDescription,
          skillTags: const {'progression.function', 'classical.cadence'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.classicalCadence,
              skillTags: {'progression.function', 'classical.cadence'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.classicalCadence,
              cadenceFocus: true,
              skillTags: {'progression.fillBlank', 'classical.cadence'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'classical-signature-2-inversion',
          title: l10n.studyHarmonyClassicalLessonInversionTitle,
          description: l10n.studyHarmonyClassicalLessonInversionDescription,
          skillTags: const {'progression.fillBlank', 'classical.inversion'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.classicalInversion,
              skillTags: {'progression.fillBlank', 'classical.inversion'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.classicalInversion,
              skillTags: {'progression.function', 'classical.inversion'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'classical-signature-3-secondary-dominant',
          title: l10n.studyHarmonyClassicalLessonSecondaryDominantTitle,
          description:
              l10n.studyHarmonyClassicalLessonSecondaryDominantDescription,
          skillTags: const {
            'progression.nonDiatonic',
            'progression.fillBlank',
            'classical.secondaryDominant',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.classicalSecondaryDominant,
              skillTags: {
                'progression.nonDiatonic',
                'classical.secondaryDominant',
              },
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.classicalSecondaryDominant,
              cadenceFocus: true,
              allowNonDiatonic: true,
              requireSingleNonDiatonic: true,
              skillTags: {
                'progression.fillBlank',
                'classical.secondaryDominant',
              },
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'classical-signature-boss-arrival',
          title: l10n.studyHarmonyClassicalLessonBossTitle,
          description: l10n.studyHarmonyClassicalLessonBossDescription,
          boss: true,
          skillTags: const {
            'progression.function',
            'progression.fillBlank',
            'progression.nonDiatonic',
            'classical.cadence',
            'classical.inversion',
            'classical.secondaryDominant',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.classicalCadence,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.classicalInversion,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.classicalSecondaryDominant,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.classicalCadence,
            ),
          ],
        ),
      ],
    ),
  ];
}
