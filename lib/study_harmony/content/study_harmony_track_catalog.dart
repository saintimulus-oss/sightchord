import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import 'core_curriculum_catalog.dart';

const StudyHarmonyTrackId studyHarmonyPopTrackId = 'pop';
const StudyHarmonyTrackId studyHarmonyJazzTrackId = 'jazz';
const StudyHarmonyTrackId studyHarmonyClassicalTrackId = 'classical';

const StudyHarmonyCourseId studyHarmonyPopCourseId = 'pop-foundations-v1';
const StudyHarmonyCourseId studyHarmonyJazzCourseId = 'jazz-foundations-v1';
const StudyHarmonyCourseId studyHarmonyClassicalCourseId =
    'classical-foundations-v1';

StudyHarmonyTrackId normalizeStudyHarmonyTrackId(StudyHarmonyTrackId? trackId) {
  return switch (trackId) {
    studyHarmonyPopTrackId => studyHarmonyPopTrackId,
    studyHarmonyJazzTrackId => studyHarmonyJazzTrackId,
    studyHarmonyClassicalTrackId => studyHarmonyClassicalTrackId,
    _ => studyHarmonyCoreTrackId,
  };
}

Map<StudyHarmonyTrackId, StudyHarmonyCourseDefinition>
buildStudyHarmonyTrackCourses(AppLocalizations l10n) {
  final coreCourse = buildStudyHarmonyCoreCourse(l10n);
  return <StudyHarmonyTrackId, StudyHarmonyCourseDefinition>{
    studyHarmonyCoreTrackId: coreCourse,
    studyHarmonyPopTrackId: _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyPopTrackId,
      courseId: studyHarmonyPopCourseId,
      title: l10n.studyHarmonyPopTrackTitle,
      description: l10n.studyHarmonyPopTrackDescription,
    ),
    studyHarmonyJazzTrackId: _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyJazzTrackId,
      courseId: studyHarmonyJazzCourseId,
      title: l10n.studyHarmonyJazzTrackTitle,
      description: l10n.studyHarmonyJazzTrackDescription,
    ),
    studyHarmonyClassicalTrackId: _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyClassicalTrackId,
      courseId: studyHarmonyClassicalCourseId,
      title: l10n.studyHarmonyClassicalTrackTitle,
      description: l10n.studyHarmonyClassicalTrackDescription,
    ),
  };
}

StudyHarmonyCourseDefinition buildStudyHarmonyCourseForTrackId({
  required AppLocalizations l10n,
  required StudyHarmonyTrackId? trackId,
}) {
  final coreCourse = buildStudyHarmonyCoreCourse(l10n);
  return switch (normalizeStudyHarmonyTrackId(trackId)) {
    studyHarmonyCoreTrackId => coreCourse,
    studyHarmonyPopTrackId => _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyPopTrackId,
      courseId: studyHarmonyPopCourseId,
      title: l10n.studyHarmonyPopTrackTitle,
      description: l10n.studyHarmonyPopTrackDescription,
    ),
    studyHarmonyJazzTrackId => _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyJazzTrackId,
      courseId: studyHarmonyJazzCourseId,
      title: l10n.studyHarmonyJazzTrackTitle,
      description: l10n.studyHarmonyJazzTrackDescription,
    ),
    studyHarmonyClassicalTrackId => _buildCourseForTrack(
      source: coreCourse,
      trackId: studyHarmonyClassicalTrackId,
      courseId: studyHarmonyClassicalCourseId,
      title: l10n.studyHarmonyClassicalTrackTitle,
      description: l10n.studyHarmonyClassicalTrackDescription,
    ),
    _ => coreCourse,
  };
}

StudyHarmonyCourseDefinition _buildCourseForTrack({
  required StudyHarmonyCourseDefinition source,
  required StudyHarmonyTrackId trackId,
  required StudyHarmonyCourseId courseId,
  required String title,
  required String description,
}) {
  final chapterIds = <StudyHarmonyChapterId, StudyHarmonyChapterId>{
    for (final chapter in source.chapters)
      chapter.id: _trackScopedId(trackId, chapter.id),
  };
  final lessonIds = <StudyHarmonyLessonId, StudyHarmonyLessonId>{
    for (final chapter in source.chapters)
      for (final lesson in chapter.lessons)
        lesson.id: _trackScopedId(trackId, lesson.id),
  };

  final chapters = [
    for (final chapter in source.chapters)
      StudyHarmonyChapterDefinition(
        id: chapterIds[chapter.id]!,
        courseId: courseId,
        title: chapter.title,
        description: chapter.description,
        lessons: [
          for (final lesson in chapter.lessons)
            _cloneLesson(
              lesson,
              chapterId: chapterIds[chapter.id]!,
              lessonId: lessonIds[lesson.id]!,
              lessonIds: lessonIds,
              trackId: trackId,
            ),
        ],
        skillTags: chapter.skillTags,
      ),
  ];

  return StudyHarmonyCourseDefinition(
    id: courseId,
    trackId: trackId,
    title: title,
    description: description,
    chapters: chapters,
    skillTags: source.skillTags,
  );
}

StudyHarmonyLessonDefinition _cloneLesson(
  StudyHarmonyLessonDefinition lesson, {
  required StudyHarmonyChapterId chapterId,
  required StudyHarmonyLessonId lessonId,
  required Map<StudyHarmonyLessonId, StudyHarmonyLessonId> lessonIds,
  required StudyHarmonyTrackId trackId,
}) {
  return StudyHarmonyLessonDefinition(
    id: lessonId,
    chapterId: chapterId,
    title: lesson.title,
    description: lesson.description,
    objectiveLabel: lesson.objectiveLabel,
    goalCorrectAnswers: lesson.goalCorrectAnswers,
    startingLives: lesson.startingLives,
    sessionMode: lesson.sessionMode,
    tasks: [
      for (final task in lesson.tasks)
        _cloneTaskBlueprint(task, lessonId: lessonId, trackId: trackId),
    ],
    skillTags: lesson.skillTags,
    sessionMetadata: StudyHarmonySessionMetadata(
      anchorLessonId: lesson.sessionMetadata.anchorLessonId == null
          ? null
          : lessonIds[lesson.sessionMetadata.anchorLessonId!] ??
                lesson.sessionMetadata.anchorLessonId!,
      sourceLessonIds: {
        for (final sourceLessonId in lesson.sessionMetadata.sourceLessonIds)
          lessonIds[sourceLessonId] ?? sourceLessonId,
      },
      focusSkillTags: lesson.sessionMetadata.focusSkillTags,
      countsTowardLessonProgress:
          lesson.sessionMetadata.countsTowardLessonProgress,
      reviewReason: lesson.sessionMetadata.reviewReason,
      dailyDateKey: lesson.sessionMetadata.dailyDateKey,
      dailySeedValue: lesson.sessionMetadata.dailySeedValue,
    ),
  );
}

StudyHarmonyTaskBlueprint _cloneTaskBlueprint(
  StudyHarmonyTaskBlueprint task, {
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTrackId trackId,
}) {
  return StudyHarmonyTaskBlueprint(
    id: _trackScopedId(trackId, task.id),
    lessonId: lessonId,
    taskKind: task.taskKind,
    promptSpec: StudyHarmonyPromptSpec(
      id: _trackScopedId(trackId, task.promptSpec.id),
      surface: task.promptSpec.surface,
      primaryLabel: task.promptSpec.primaryLabel,
      highlightedAnswerIds: task.promptSpec.highlightedAnswerIds,
      hint: task.promptSpec.hint,
      progressionDisplay: task.promptSpec.progressionDisplay == null
          ? null
          : StudyHarmonyProgressionDisplaySpec(
              slots: [
                for (final slot in task.promptSpec.progressionDisplay!.slots)
                  StudyHarmonyProgressionSlotSpec(
                    id: _trackScopedId(trackId, slot.id),
                    label: slot.label,
                    measureLabel: slot.measureLabel,
                    isHidden: slot.isHidden,
                    isHighlighted: slot.isHighlighted,
                  ),
              ],
              summaryLabel: task.promptSpec.progressionDisplay!.summaryLabel,
            ),
    ),
    answerOptions: task.answerOptions,
    answerSummaryLabel: task.answerSummaryLabel,
    answerSurface: task.answerSurface,
    evaluator: task.evaluator,
    instanceFactory: task.instanceFactory,
    skillTags: task.skillTags,
    explanationTitle: task.explanationTitle,
    explanationBody: task.explanationBody,
  );
}

String _trackScopedId(StudyHarmonyTrackId trackId, String id) {
  const corePrefix = 'core-';
  if (id.startsWith(corePrefix)) {
    return '$trackId-${id.substring(corePrefix.length)}';
  }
  return '$trackId-$id';
}
