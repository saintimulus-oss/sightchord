import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import 'study_harmony_track_catalog.dart';
import 'track_progression_curriculum_factory.dart';

const StudyHarmonyChapterId studyHarmonyPopSignatureChapterId =
    'pop-chapter-signature-loops';

List<StudyHarmonyChapterDefinition> buildStudyHarmonyPopProgressionChapters({
  required AppLocalizations l10n,
  required StudyHarmonyCourseId courseId,
}) {
  return [
    buildTrackSignatureChapter(
      l10n: l10n,
      trackId: studyHarmonyPopTrackId,
      courseId: courseId,
      chapterId: studyHarmonyPopSignatureChapterId,
      title: l10n.studyHarmonyPopChapterSignatureLoopsTitle,
      description: l10n.studyHarmonyPopChapterSignatureLoopsDescription,
      skillTags: const {
        'progression.keyCenter',
        'progression.nonDiatonic',
        'progression.fillBlank',
        'progression.function',
        'pop.loopGravity',
        'pop.borrowedColor',
        'pop.bassMotion',
      },
      lessons: [
        TrackCurriculumLessonSpec(
          id: 'pop-signature-1-hook-gravity',
          title: l10n.studyHarmonyPopLessonHookGravityTitle,
          description: l10n.studyHarmonyPopLessonHookGravityDescription,
          skillTags: const {
            'progression.keyCenter',
            'progression.fillBlank',
            'pop.loopGravity',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.popHookLoop,
              skillTags: {'progression.keyCenter', 'pop.loopGravity'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.popHookLoop,
              skillTags: {'progression.fillBlank', 'pop.loopGravity'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'pop-signature-2-borrowed-lift',
          title: l10n.studyHarmonyPopLessonBorrowedLiftTitle,
          description: l10n.studyHarmonyPopLessonBorrowedLiftDescription,
          skillTags: const {
            'progression.nonDiatonic',
            'progression.function',
            'pop.borrowedColor',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
              skillTags: {'progression.nonDiatonic', 'pop.borrowedColor'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
              allowNonDiatonic: true,
              skillTags: {'progression.function', 'pop.borrowedColor'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'pop-signature-3-bass-motion',
          title: l10n.studyHarmonyPopLessonBassMotionTitle,
          description: l10n.studyHarmonyPopLessonBassMotionDescription,
          skillTags: const {
            'progression.fillBlank',
            'progression.function',
            'pop.bassMotion',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.popBassMotion,
              skillTags: {'progression.fillBlank', 'pop.bassMotion'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.popBassMotion,
              skillTags: {'progression.function', 'pop.bassMotion'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'pop-signature-boss-pre-chorus',
          title: l10n.studyHarmonyPopLessonBossTitle,
          description: l10n.studyHarmonyPopLessonBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'progression.fillBlank',
            'progression.function',
            'pop.loopGravity',
            'pop.borrowedColor',
            'pop.bassMotion',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.popHookLoop,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.popBassMotion,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
              allowNonDiatonic: true,
            ),
          ],
        ),
      ],
    ),
  ];
}
