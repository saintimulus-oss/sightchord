import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import '../integrations/study_harmony_progression_adapter.dart';

const StudyHarmonyChapterId studyHarmonyCoreProgressionChapterId =
    'core-chapter-progression-detective';
const StudyHarmonyChapterId studyHarmonyCoreMissingChordChapterId =
    'core-chapter-missing-chord';

List<StudyHarmonyChapterDefinition> buildStudyHarmonyCoreProgressionChapters({
  required AppLocalizations l10n,
  required StudyHarmonyCourseId courseId,
}) {
  final adapter = StudyHarmonyProgressionAdapter();

  return [
    _chapter(
      id: studyHarmonyCoreProgressionChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterProgressionDetectiveTitle,
      description: l10n.studyHarmonyChapterProgressionDetectiveDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-progression-1-key-center',
          chapterId: studyHarmonyCoreProgressionChapterId,
          title: l10n.studyHarmonyLessonProgressionKeyCenterTitle,
          description: l10n.studyHarmonyLessonProgressionKeyCenterDescription,
          boss: false,
          skillTags: const {'progression.keyCenter'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-progression-1-key-center',
              blueprintId: 'core-progression-1-key-center:key-center',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-progression-2-function',
          chapterId: studyHarmonyCoreProgressionChapterId,
          title: l10n.studyHarmonyLessonProgressionFunctionTitle,
          description: l10n.studyHarmonyLessonProgressionFunctionDescription,
          boss: false,
          skillTags: const {'progression.function', 'harmony.function'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-progression-2-function',
              blueprintId: 'core-progression-2-function:function',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-progression-3-non-diatonic',
          chapterId: studyHarmonyCoreProgressionChapterId,
          title: l10n.studyHarmonyLessonProgressionNonDiatonicTitle,
          description: l10n.studyHarmonyLessonProgressionNonDiatonicDescription,
          boss: false,
          skillTags: const {'progression.nonDiatonic', 'harmony.diatonicity'},
          tasks: [
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-progression-3-non-diatonic',
              blueprintId: 'core-progression-3-non-diatonic:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-progression-boss-detective',
          chapterId: studyHarmonyCoreProgressionChapterId,
          title: l10n.studyHarmonyLessonProgressionBossTitle,
          description: l10n.studyHarmonyLessonProgressionBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-progression-boss-detective',
              blueprintId: 'core-progression-boss-detective:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-progression-boss-detective',
              blueprintId: 'core-progression-boss-detective:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-progression-boss-detective',
              blueprintId: 'core-progression-boss-detective:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreMissingChordChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterMissingChordTitle,
      description: l10n.studyHarmonyChapterMissingChordDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-missing-1-four-chord-fill',
          chapterId: studyHarmonyCoreMissingChordChapterId,
          title: l10n.studyHarmonyLessonMissingChordPatternTitle,
          description: l10n.studyHarmonyLessonMissingChordPatternDescription,
          boss: false,
          skillTags: const {'progression.fillBlank', 'progression.function'},
          tasks: [
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-missing-1-four-chord-fill',
              blueprintId: 'core-missing-1-four-chord-fill:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-missing-2-cadence-fill',
          chapterId: studyHarmonyCoreMissingChordChapterId,
          title: l10n.studyHarmonyLessonMissingChordCadenceTitle,
          description: l10n.studyHarmonyLessonMissingChordCadenceDescription,
          boss: false,
          skillTags: const {'progression.fillBlank', 'progression.function'},
          tasks: [
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-missing-2-cadence-fill',
              blueprintId: 'core-missing-2-cadence-fill:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-missing-boss-fill',
          chapterId: studyHarmonyCoreMissingChordChapterId,
          title: l10n.studyHarmonyLessonMissingChordBossTitle,
          description: l10n.studyHarmonyLessonMissingChordBossDescription,
          boss: true,
          skillTags: const {'progression.fillBlank', 'progression.function'},
          tasks: [
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-missing-boss-fill',
              blueprintId: 'core-missing-boss-fill:general',
              l10n: l10n,
              cadenceFocus: false,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-missing-boss-fill',
              blueprintId: 'core-missing-boss-fill:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
  ];
}

StudyHarmonyChapterDefinition _chapter({
  required StudyHarmonyChapterId id,
  required StudyHarmonyCourseId courseId,
  required String title,
  required String description,
  required List<StudyHarmonyLessonDefinition> lessons,
}) {
  return StudyHarmonyChapterDefinition(
    id: id,
    courseId: courseId,
    title: title,
    description: description,
    lessons: lessons,
    skillTags: {for (final lesson in lessons) ...lesson.skillTags},
  );
}

StudyHarmonyLessonDefinition _lesson({
  required AppLocalizations l10n,
  required StudyHarmonyLessonId id,
  required StudyHarmonyChapterId chapterId,
  required String title,
  required String description,
  required bool boss,
  required List<StudyHarmonyTaskBlueprint> tasks,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return StudyHarmonyLessonDefinition(
    id: id,
    chapterId: chapterId,
    title: title,
    description: description,
    objectiveLabel: boss
        ? l10n.studyHarmonyObjectiveBossReview
        : l10n.studyHarmonyObjectiveQuickDrill,
    goalCorrectAnswers: boss ? 9 : 6,
    startingLives: boss ? 4 : 3,
    sessionMode: StudyHarmonySessionMode.lesson,
    tasks: tasks,
    skillTags: skillTags,
  );
}
