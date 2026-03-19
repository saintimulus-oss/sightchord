import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import 'study_harmony_track_catalog.dart';
import 'track_progression_curriculum_factory.dart';

const StudyHarmonyChapterId studyHarmonyJazzSignatureChapterId =
    'jazz-chapter-guide-tone-lab';

List<StudyHarmonyChapterDefinition> buildStudyHarmonyJazzProgressionChapters({
  required AppLocalizations l10n,
  required StudyHarmonyCourseId courseId,
}) {
  return [
    buildTrackSignatureChapter(
      l10n: l10n,
      trackId: studyHarmonyJazzTrackId,
      courseId: courseId,
      chapterId: studyHarmonyJazzSignatureChapterId,
      title: l10n.studyHarmonyJazzChapterGuideToneLabTitle,
      description: l10n.studyHarmonyJazzChapterGuideToneLabDescription,
      skillTags: const {
        'progression.function',
        'progression.keyCenter',
        'progression.nonDiatonic',
        'progression.fillBlank',
        'jazz.guideTones',
        'jazz.shellVoicing',
        'jazz.minorCadence',
        'jazz.rootlessVoicing',
        'jazz.dominantColor',
        'jazz.backdoorCadence',
      },
      lessons: [
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-1-guide-tones',
          title: l10n.studyHarmonyJazzLessonGuideTonesTitle,
          description: l10n.studyHarmonyJazzLessonGuideTonesDescription,
          skillTags: const {'progression.function', 'jazz.guideTones'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
              skillTags: {'progression.function', 'jazz.guideTones'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
              cadenceFocus: true,
              skillTags: {'progression.fillBlank', 'jazz.guideTones'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-2-shell-voicings',
          title: l10n.studyHarmonyJazzLessonShellVoicingsTitle,
          description: l10n.studyHarmonyJazzLessonShellVoicingsDescription,
          skillTags: const {'progression.function', 'jazz.shellVoicing'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzShellVoicing,
              skillTags: {'progression.function', 'jazz.shellVoicing'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzShellVoicing,
              cadenceFocus: true,
              skillTags: {'progression.fillBlank', 'jazz.shellVoicing'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-3-minor-cadence',
          title: l10n.studyHarmonyJazzLessonMinorCadenceTitle,
          description: l10n.studyHarmonyJazzLessonMinorCadenceDescription,
          skillTags: const {'progression.keyCenter', 'jazz.minorCadence'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.jazzMinorCadence,
              allowNonDiatonic: true,
              skillTags: {'progression.keyCenter', 'jazz.minorCadence'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzMinorCadence,
              cadenceFocus: true,
              allowNonDiatonic: true,
              skillTags: {'progression.fillBlank', 'jazz.minorCadence'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-4-rootless-voicings',
          title: l10n.studyHarmonyJazzLessonRootlessVoicingsTitle,
          description: l10n.studyHarmonyJazzLessonRootlessVoicingsDescription,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'jazz.rootlessVoicing',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.jazzRootlessVoicing,
              skillTags: {'progression.keyCenter', 'jazz.rootlessVoicing'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzRootlessVoicing,
              skillTags: {'progression.function', 'jazz.rootlessVoicing'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-5-dominant-color',
          title: l10n.studyHarmonyJazzLessonDominantColorTitle,
          description: l10n.studyHarmonyJazzLessonDominantColorDescription,
          skillTags: const {'progression.nonDiatonic', 'jazz.dominantColor'},
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.jazzDominantColor,
              skillTags: {'progression.nonDiatonic', 'jazz.dominantColor'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzDominantColor,
              allowNonDiatonic: true,
              skillTags: {'progression.function', 'jazz.dominantColor'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-6-reharm-cadence',
          title: l10n.studyHarmonyJazzLessonBackdoorCadenceTitle,
          description: l10n.studyHarmonyJazzLessonBackdoorCadenceDescription,
          skillTags: const {
            'progression.nonDiatonic',
            'progression.fillBlank',
            'jazz.backdoorCadence',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'non-diatonic',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.jazzBackdoorCadence,
              requireSingleNonDiatonic: false,
              skillTags: {'progression.nonDiatonic', 'jazz.backdoorCadence'},
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzBackdoorCadence,
              cadenceFocus: true,
              allowNonDiatonic: true,
              requireSingleNonDiatonic: false,
              skillTags: {'progression.fillBlank', 'jazz.backdoorCadence'},
            ),
          ],
        ),
        TrackCurriculumLessonSpec(
          id: 'jazz-signature-boss-turnaround',
          title: l10n.studyHarmonyJazzLessonBossTitle,
          description: l10n.studyHarmonyJazzLessonBossDescription,
          boss: true,
          skillTags: const {
            'progression.function',
            'progression.keyCenter',
            'progression.nonDiatonic',
            'progression.fillBlank',
            'jazz.guideTones',
            'jazz.shellVoicing',
            'jazz.minorCadence',
            'jazz.rootlessVoicing',
            'jazz.dominantColor',
            'jazz.backdoorCadence',
          },
          tasks: [
            const TrackCurriculumTaskSpec(
              idSuffix: 'major-function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'shell-fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzShellVoicing,
              cadenceFocus: true,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'minor-key-center',
              kind: TrackCurriculumTaskKind.keyCenter,
              exerciseFlavor: TrackExerciseFlavor.jazzMinorCadence,
              allowNonDiatonic: true,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'rootless-function',
              kind: TrackCurriculumTaskKind.function,
              exerciseFlavor: TrackExerciseFlavor.jazzRootlessVoicing,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'dominant-color',
              kind: TrackCurriculumTaskKind.nonDiatonic,
              exerciseFlavor: TrackExerciseFlavor.jazzDominantColor,
            ),
            const TrackCurriculumTaskSpec(
              idSuffix: 'reharm-fill',
              kind: TrackCurriculumTaskKind.missingChord,
              exerciseFlavor: TrackExerciseFlavor.jazzBackdoorCadence,
              cadenceFocus: true,
              allowNonDiatonic: true,
              requireSingleNonDiatonic: false,
            ),
          ],
        ),
      ],
    ),
  ];
}
