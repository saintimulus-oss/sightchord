import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import '../integrations/study_harmony_progression_adapter.dart';
import 'track_generation_profiles.dart';

enum TrackCurriculumTaskKind { keyCenter, function, nonDiatonic, missingChord }

class TrackCurriculumTaskSpec {
  const TrackCurriculumTaskSpec({
    required this.idSuffix,
    required this.kind,
    required this.exerciseFlavor,
    this.skillTags = const <StudyHarmonySkillTag>{},
    this.cadenceFocus = false,
    this.allowNonDiatonic,
    this.requireSingleNonDiatonic,
  });

  final String idSuffix;
  final TrackCurriculumTaskKind kind;
  final TrackExerciseFlavor exerciseFlavor;
  final Set<StudyHarmonySkillTag> skillTags;
  final bool cadenceFocus;
  final bool? allowNonDiatonic;
  final bool? requireSingleNonDiatonic;
}

class TrackCurriculumLessonSpec {
  const TrackCurriculumLessonSpec({
    required this.id,
    required this.title,
    required this.description,
    required this.skillTags,
    required this.tasks,
    this.boss = false,
  });

  final StudyHarmonyLessonId id;
  final String title;
  final String description;
  final Set<StudyHarmonySkillTag> skillTags;
  final List<TrackCurriculumTaskSpec> tasks;
  final bool boss;
}

StudyHarmonyChapterDefinition buildTrackProgressionChapter({
  required AppLocalizations l10n,
  required StudyHarmonyTrackId trackId,
  required StudyHarmonyCourseId courseId,
  required StudyHarmonyChapterId chapterId,
  required String title,
  required String description,
  required Set<StudyHarmonySkillTag> skillTags,
  required List<TrackCurriculumLessonSpec> lessons,
  StudyHarmonyProgressionAdapter? adapter,
}) {
  final progressionAdapter = adapter ?? StudyHarmonyProgressionAdapter();
  final chapterLessons = [
    for (final lesson in lessons)
      StudyHarmonyLessonDefinition(
        id: lesson.id,
        chapterId: chapterId,
        title: lesson.title,
        description: lesson.description,
        objectiveLabel: lesson.boss
            ? l10n.studyHarmonyObjectiveBossReview
            : l10n.studyHarmonyObjectiveQuickDrill,
        goalCorrectAnswers: lesson.boss ? 8 : 6,
        startingLives: lesson.boss ? 4 : 3,
        sessionMode: StudyHarmonySessionMode.lesson,
        tasks: [
          for (final task in lesson.tasks)
            _buildTaskBlueprint(
              l10n: l10n,
              adapter: progressionAdapter,
              trackId: trackId,
              lessonId: lesson.id,
              spec: task,
            ),
        ],
        skillTags: lesson.skillTags,
      ),
  ];

  return StudyHarmonyChapterDefinition(
    id: chapterId,
    courseId: courseId,
    title: title,
    description: description,
    lessons: chapterLessons,
    skillTags: skillTags,
  );
}

StudyHarmonyChapterDefinition buildTrackSignatureChapter({
  required AppLocalizations l10n,
  required StudyHarmonyTrackId trackId,
  required StudyHarmonyCourseId courseId,
  required StudyHarmonyChapterId chapterId,
  required String title,
  required String description,
  required Set<StudyHarmonySkillTag> skillTags,
  required List<TrackCurriculumLessonSpec> lessons,
  StudyHarmonyProgressionAdapter? adapter,
}) {
  return buildTrackProgressionChapter(
    l10n: l10n,
    trackId: trackId,
    courseId: courseId,
    chapterId: chapterId,
    title: title,
    description: description,
    skillTags: skillTags,
    lessons: lessons,
    adapter: adapter,
  );
}

StudyHarmonyTaskBlueprint _buildTaskBlueprint({
  required AppLocalizations l10n,
  required StudyHarmonyProgressionAdapter adapter,
  required StudyHarmonyTrackId trackId,
  required StudyHarmonyLessonId lessonId,
  required TrackCurriculumTaskSpec spec,
}) {
  final generationProfile = trackGenerationProfileForFlavor(
    trackId,
    spec.exerciseFlavor,
  );
  final blueprintId = '$lessonId:${spec.idSuffix}';

  switch (spec.kind) {
    case TrackCurriculumTaskKind.keyCenter:
      return adapter.buildKeyCenterBlueprint(
        lessonId: lessonId,
        blueprintId: blueprintId,
        l10n: l10n,
        skillTags: spec.skillTags,
        generationProfile: generationProfile,
        allowNonDiatonicOverride: spec.allowNonDiatonic,
      );
    case TrackCurriculumTaskKind.function:
      return adapter.buildFunctionBlueprint(
        lessonId: lessonId,
        blueprintId: blueprintId,
        l10n: l10n,
        skillTags: spec.skillTags,
        generationProfile: generationProfile,
        allowNonDiatonicOverride: spec.allowNonDiatonic,
      );
    case TrackCurriculumTaskKind.nonDiatonic:
      return adapter.buildNonDiatonicBlueprint(
        lessonId: lessonId,
        blueprintId: blueprintId,
        l10n: l10n,
        skillTags: spec.skillTags,
        generationProfile: generationProfile,
        requireSingleNonDiatonicOverride: spec.requireSingleNonDiatonic,
      );
    case TrackCurriculumTaskKind.missingChord:
      return adapter.buildMissingChordBlueprint(
        lessonId: lessonId,
        blueprintId: blueprintId,
        l10n: l10n,
        cadenceFocus: spec.cadenceFocus,
        allowNonDiatonicOverride: spec.allowNonDiatonic,
        requireSingleNonDiatonicOverride: spec.requireSingleNonDiatonic,
        skillTags: spec.skillTags,
        generationProfile: generationProfile,
      );
  }
}
