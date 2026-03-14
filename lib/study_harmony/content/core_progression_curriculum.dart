import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import '../integrations/study_harmony_progression_adapter.dart';

const StudyHarmonyChapterId studyHarmonyCoreProgressionChapterId =
    'core-chapter-progression-detective';
const StudyHarmonyChapterId studyHarmonyCoreMissingChordChapterId =
    'core-chapter-missing-chord';
const StudyHarmonyChapterId studyHarmonyCoreCheckpointChapterId =
    'core-chapter-checkpoint-gauntlet';
const StudyHarmonyChapterId studyHarmonyCoreCapstoneChapterId =
    'core-chapter-capstone-trials';
const StudyHarmonyChapterId studyHarmonyCoreRemixArenaChapterId =
    'core-chapter-remix-arena';
const StudyHarmonyChapterId studyHarmonyCoreEncoreChapterId =
    'core-chapter-encore-ladder';
const StudyHarmonyChapterId studyHarmonyCoreSpotlightChapterId =
    'core-chapter-spotlight-showdown';
const StudyHarmonyChapterId studyHarmonyCoreAfterHoursChapterId =
    'core-chapter-after-hours-lab';
const StudyHarmonyChapterId studyHarmonyCoreNeonChapterId =
    'core-chapter-neon-detours';
const StudyHarmonyChapterId studyHarmonyCoreMidnightChapterId =
    'core-chapter-midnight-switchboard';
const StudyHarmonyChapterId studyHarmonyCoreSkylineChapterId =
    'core-chapter-skyline-circuit';
const StudyHarmonyChapterId studyHarmonyCoreAfterglowChapterId =
    'core-chapter-afterglow-runway';
const StudyHarmonyChapterId studyHarmonyCoreDaybreakChapterId =
    'core-chapter-daybreak-frequency';
const StudyHarmonyChapterId studyHarmonyCoreBlueHourChapterId =
    'core-chapter-blue-hour-exchange';

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
    _chapter(
      id: studyHarmonyCoreCheckpointChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterCheckpointTitle,
      description: l10n.studyHarmonyChapterCheckpointDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-checkpoint-1-cadence-rush',
          chapterId: studyHarmonyCoreCheckpointChapterId,
          title: l10n.studyHarmonyLessonCheckpointCadenceRushTitle,
          description: l10n.studyHarmonyLessonCheckpointCadenceRushDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-checkpoint-1-cadence-rush',
              blueprintId: 'core-checkpoint-1-cadence-rush:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-checkpoint-1-cadence-rush',
              blueprintId: 'core-checkpoint-1-cadence-rush:cadence-fill',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-checkpoint-2-key-color',
          chapterId: studyHarmonyCoreCheckpointChapterId,
          title: l10n.studyHarmonyLessonCheckpointColorKeyTitle,
          description: l10n.studyHarmonyLessonCheckpointColorKeyDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'harmony.diatonicity',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-checkpoint-2-key-color',
              blueprintId: 'core-checkpoint-2-key-color:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-checkpoint-2-key-color',
              blueprintId: 'core-checkpoint-2-key-color:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-checkpoint-boss-gauntlet',
          chapterId: studyHarmonyCoreCheckpointChapterId,
          title: l10n.studyHarmonyLessonCheckpointBossTitle,
          description: l10n.studyHarmonyLessonCheckpointBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-checkpoint-boss-gauntlet',
              blueprintId: 'core-checkpoint-boss-gauntlet:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-checkpoint-boss-gauntlet',
              blueprintId: 'core-checkpoint-boss-gauntlet:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-checkpoint-boss-gauntlet',
              blueprintId: 'core-checkpoint-boss-gauntlet:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-checkpoint-boss-gauntlet',
              blueprintId: 'core-checkpoint-boss-gauntlet:cadence-fill',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreCapstoneChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterCapstoneTitle,
      description: l10n.studyHarmonyChapterCapstoneDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-capstone-1-turnaround-relay',
          chapterId: studyHarmonyCoreCapstoneChapterId,
          title: l10n.studyHarmonyLessonCapstoneTurnaroundTitle,
          description: l10n.studyHarmonyLessonCapstoneTurnaroundDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-capstone-1-turnaround-relay',
              blueprintId: 'core-capstone-1-turnaround-relay:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-capstone-1-turnaround-relay',
              blueprintId: 'core-capstone-1-turnaround-relay:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-capstone-2-borrowed-color',
          chapterId: studyHarmonyCoreCapstoneChapterId,
          title: l10n.studyHarmonyLessonCapstoneBorrowedColorTitle,
          description: l10n.studyHarmonyLessonCapstoneBorrowedColorDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'harmony.diatonicity',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-capstone-2-borrowed-color',
              blueprintId: 'core-capstone-2-borrowed-color:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-capstone-2-borrowed-color',
              blueprintId: 'core-capstone-2-borrowed-color:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-capstone-3-resolution-lab',
          chapterId: studyHarmonyCoreCapstoneChapterId,
          title: l10n.studyHarmonyLessonCapstoneResolutionTitle,
          description: l10n.studyHarmonyLessonCapstoneResolutionDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-capstone-3-resolution-lab',
              blueprintId: 'core-capstone-3-resolution-lab:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-capstone-3-resolution-lab',
              blueprintId: 'core-capstone-3-resolution-lab:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-capstone-3-resolution-lab',
              blueprintId: 'core-capstone-3-resolution-lab:cadence-fill',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-capstone-boss-final-exam',
          chapterId: studyHarmonyCoreCapstoneChapterId,
          title: l10n.studyHarmonyLessonCapstoneBossTitle,
          description: l10n.studyHarmonyLessonCapstoneBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-capstone-boss-final-exam',
              blueprintId: 'core-capstone-boss-final-exam:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-capstone-boss-final-exam',
              blueprintId: 'core-capstone-boss-final-exam:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-capstone-boss-final-exam',
              blueprintId: 'core-capstone-boss-final-exam:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-capstone-boss-final-exam',
              blueprintId: 'core-capstone-boss-final-exam:cadence-fill',
              l10n: l10n,
              cadenceFocus: true,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-capstone-boss-final-exam',
              blueprintId: 'core-capstone-boss-final-exam:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreRemixArenaChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterRemixTitle,
      description: l10n.studyHarmonyChapterRemixDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-remix-1-bridge-builder',
          chapterId: studyHarmonyCoreRemixArenaChapterId,
          title: l10n.studyHarmonyLessonRemixBridgeTitle,
          description: l10n.studyHarmonyLessonRemixBridgeDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-remix-1-bridge-builder',
              blueprintId: 'core-remix-1-bridge-builder:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-remix-1-bridge-builder',
              blueprintId: 'core-remix-1-bridge-builder:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-remix-1-bridge-builder',
              blueprintId: 'core-remix-1-bridge-builder:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-remix-2-color-pivot',
          chapterId: studyHarmonyCoreRemixArenaChapterId,
          title: l10n.studyHarmonyLessonRemixPivotTitle,
          description: l10n.studyHarmonyLessonRemixPivotDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'harmony.diatonicity',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-remix-2-color-pivot',
              blueprintId: 'core-remix-2-color-pivot:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-remix-2-color-pivot',
              blueprintId: 'core-remix-2-color-pivot:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-remix-2-color-pivot',
              blueprintId: 'core-remix-2-color-pivot:key-center-2',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-remix-3-resolution-sprint',
          chapterId: studyHarmonyCoreRemixArenaChapterId,
          title: l10n.studyHarmonyLessonRemixSprintTitle,
          description: l10n.studyHarmonyLessonRemixSprintDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-remix-3-resolution-sprint',
              blueprintId: 'core-remix-3-resolution-sprint:function',
              l10n: l10n,
            ),
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-remix-3-resolution-sprint',
              blueprintId: 'core-remix-3-resolution-sprint:key-center',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-remix-3-resolution-sprint',
              blueprintId: 'core-remix-3-resolution-sprint:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-remix-boss-marathon',
          chapterId: studyHarmonyCoreRemixArenaChapterId,
          title: l10n.studyHarmonyLessonRemixBossTitle,
          description: l10n.studyHarmonyLessonRemixBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-remix-boss-marathon',
              blueprintId: 'core-remix-boss-marathon:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-remix-boss-marathon',
              blueprintId: 'core-remix-boss-marathon:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-remix-boss-marathon',
              blueprintId: 'core-remix-boss-marathon:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-remix-boss-marathon',
              blueprintId: 'core-remix-boss-marathon:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-remix-boss-marathon',
              blueprintId: 'core-remix-boss-marathon:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreEncoreChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterEncoreTitle,
      description: l10n.studyHarmonyChapterEncoreDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-encore-1-tonal-pulse',
          chapterId: studyHarmonyCoreEncoreChapterId,
          title: l10n.studyHarmonyLessonEncorePulseTitle,
          description: l10n.studyHarmonyLessonEncorePulseDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.function'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-encore-1-tonal-pulse',
              blueprintId: 'core-encore-1-tonal-pulse:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-encore-1-tonal-pulse',
              blueprintId: 'core-encore-1-tonal-pulse:function',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-encore-2-color-swap',
          chapterId: studyHarmonyCoreEncoreChapterId,
          title: l10n.studyHarmonyLessonEncoreSwapTitle,
          description: l10n.studyHarmonyLessonEncoreSwapDescription,
          boss: false,
          skillTags: const {'progression.nonDiatonic', 'progression.fillBlank'},
          tasks: [
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-encore-2-color-swap',
              blueprintId: 'core-encore-2-color-swap:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-encore-2-color-swap',
              blueprintId: 'core-encore-2-color-swap:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-encore-boss-finale',
          chapterId: studyHarmonyCoreEncoreChapterId,
          title: l10n.studyHarmonyLessonEncoreBossTitle,
          description: l10n.studyHarmonyLessonEncoreBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-encore-boss-finale',
              blueprintId: 'core-encore-boss-finale:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-encore-boss-finale',
              blueprintId: 'core-encore-boss-finale:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-encore-boss-finale',
              blueprintId: 'core-encore-boss-finale:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-encore-boss-finale',
              blueprintId: 'core-encore-boss-finale:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreSpotlightChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterSpotlightTitle,
      description: l10n.studyHarmonyChapterSpotlightDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-spotlight-1-borrowed-lens',
          chapterId: studyHarmonyCoreSpotlightChapterId,
          title: l10n.studyHarmonyLessonSpotlightLensTitle,
          description: l10n.studyHarmonyLessonSpotlightLensDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-spotlight-1-borrowed-lens',
              blueprintId: 'core-spotlight-1-borrowed-lens:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-spotlight-1-borrowed-lens',
              blueprintId: 'core-spotlight-1-borrowed-lens:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-spotlight-2-cadence-swap',
          chapterId: studyHarmonyCoreSpotlightChapterId,
          title: l10n.studyHarmonyLessonSpotlightCadenceTitle,
          description: l10n.studyHarmonyLessonSpotlightCadenceDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-spotlight-2-cadence-swap',
              blueprintId: 'core-spotlight-2-cadence-swap:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-spotlight-2-cadence-swap',
              blueprintId: 'core-spotlight-2-cadence-swap:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-spotlight-boss-showdown',
          chapterId: studyHarmonyCoreSpotlightChapterId,
          title: l10n.studyHarmonyLessonSpotlightBossTitle,
          description: l10n.studyHarmonyLessonSpotlightBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-spotlight-boss-showdown',
              blueprintId: 'core-spotlight-boss-showdown:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-spotlight-boss-showdown',
              blueprintId: 'core-spotlight-boss-showdown:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-spotlight-boss-showdown',
              blueprintId: 'core-spotlight-boss-showdown:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-spotlight-boss-showdown',
              blueprintId: 'core-spotlight-boss-showdown:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreAfterHoursChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterAfterHoursTitle,
      description: l10n.studyHarmonyChapterAfterHoursDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-after-hours-1-modal-shadow',
          chapterId: studyHarmonyCoreAfterHoursChapterId,
          title: l10n.studyHarmonyLessonAfterHoursShadowTitle,
          description: l10n.studyHarmonyLessonAfterHoursShadowDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-after-hours-1-modal-shadow',
              blueprintId: 'core-after-hours-1-modal-shadow:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-after-hours-1-modal-shadow',
              blueprintId: 'core-after-hours-1-modal-shadow:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-after-hours-2-resolution-feint',
          chapterId: studyHarmonyCoreAfterHoursChapterId,
          title: l10n.studyHarmonyLessonAfterHoursFeintTitle,
          description: l10n.studyHarmonyLessonAfterHoursFeintDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-after-hours-2-resolution-feint',
              blueprintId: 'core-after-hours-2-resolution-feint:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-after-hours-2-resolution-feint',
              blueprintId: 'core-after-hours-2-resolution-feint:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-after-hours-3-center-crossfade',
          chapterId: studyHarmonyCoreAfterHoursChapterId,
          title: l10n.studyHarmonyLessonAfterHoursCrossfadeTitle,
          description: l10n.studyHarmonyLessonAfterHoursCrossfadeDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-after-hours-3-center-crossfade',
              blueprintId: 'core-after-hours-3-center-crossfade:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-after-hours-3-center-crossfade',
              blueprintId: 'core-after-hours-3-center-crossfade:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-after-hours-3-center-crossfade',
              blueprintId: 'core-after-hours-3-center-crossfade:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-after-hours-boss-last-call',
          chapterId: studyHarmonyCoreAfterHoursChapterId,
          title: l10n.studyHarmonyLessonAfterHoursBossTitle,
          description: l10n.studyHarmonyLessonAfterHoursBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-after-hours-boss-last-call',
              blueprintId: 'core-after-hours-boss-last-call:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-after-hours-boss-last-call',
              blueprintId: 'core-after-hours-boss-last-call:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-after-hours-boss-last-call',
              blueprintId: 'core-after-hours-boss-last-call:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-after-hours-boss-last-call',
              blueprintId: 'core-after-hours-boss-last-call:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreNeonChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterNeonTitle,
      description: l10n.studyHarmonyChapterNeonDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-neon-1-modal-detour',
          chapterId: studyHarmonyCoreNeonChapterId,
          title: l10n.studyHarmonyLessonNeonDetourTitle,
          description: l10n.studyHarmonyLessonNeonDetourDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-neon-1-modal-detour',
              blueprintId: 'core-neon-1-modal-detour:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-neon-1-modal-detour',
              blueprintId: 'core-neon-1-modal-detour:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-neon-2-pivot-pressure',
          chapterId: studyHarmonyCoreNeonChapterId,
          title: l10n.studyHarmonyLessonNeonPivotTitle,
          description: l10n.studyHarmonyLessonNeonPivotDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.function'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-neon-2-pivot-pressure',
              blueprintId: 'core-neon-2-pivot-pressure:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-neon-2-pivot-pressure',
              blueprintId: 'core-neon-2-pivot-pressure:function',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-neon-3-borrowed-landing',
          chapterId: studyHarmonyCoreNeonChapterId,
          title: l10n.studyHarmonyLessonNeonLandingTitle,
          description: l10n.studyHarmonyLessonNeonLandingDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-neon-3-borrowed-landing',
              blueprintId: 'core-neon-3-borrowed-landing:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-neon-3-borrowed-landing',
              blueprintId: 'core-neon-3-borrowed-landing:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-neon-boss-city-lights',
          chapterId: studyHarmonyCoreNeonChapterId,
          title: l10n.studyHarmonyLessonNeonBossTitle,
          description: l10n.studyHarmonyLessonNeonBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-neon-boss-city-lights',
              blueprintId: 'core-neon-boss-city-lights:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-neon-boss-city-lights',
              blueprintId: 'core-neon-boss-city-lights:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-neon-boss-city-lights',
              blueprintId: 'core-neon-boss-city-lights:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-neon-boss-city-lights',
              blueprintId: 'core-neon-boss-city-lights:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreMidnightChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterMidnightTitle,
      description: l10n.studyHarmonyChapterMidnightDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-midnight-1-signal-drift',
          chapterId: studyHarmonyCoreMidnightChapterId,
          title: l10n.studyHarmonyLessonMidnightDriftTitle,
          description: l10n.studyHarmonyLessonMidnightDriftDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-midnight-1-signal-drift',
              blueprintId: 'core-midnight-1-signal-drift:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-midnight-1-signal-drift',
              blueprintId: 'core-midnight-1-signal-drift:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-midnight-2-false-line',
          chapterId: studyHarmonyCoreMidnightChapterId,
          title: l10n.studyHarmonyLessonMidnightLineTitle,
          description: l10n.studyHarmonyLessonMidnightLineDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-midnight-2-false-line',
              blueprintId: 'core-midnight-2-false-line:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-midnight-2-false-line',
              blueprintId: 'core-midnight-2-false-line:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-midnight-3-borrowed-reroute',
          chapterId: studyHarmonyCoreMidnightChapterId,
          title: l10n.studyHarmonyLessonMidnightRerouteTitle,
          description: l10n.studyHarmonyLessonMidnightRerouteDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-midnight-3-borrowed-reroute',
              blueprintId: 'core-midnight-3-borrowed-reroute:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-midnight-3-borrowed-reroute:function',
              blueprintId: 'core-midnight-3-borrowed-reroute:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-midnight-3-borrowed-reroute',
              blueprintId: 'core-midnight-3-borrowed-reroute:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-midnight-boss-blackout',
          chapterId: studyHarmonyCoreMidnightChapterId,
          title: l10n.studyHarmonyLessonMidnightBossTitle,
          description: l10n.studyHarmonyLessonMidnightBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-midnight-boss-blackout',
              blueprintId: 'core-midnight-boss-blackout:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-midnight-boss-blackout',
              blueprintId: 'core-midnight-boss-blackout:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-midnight-boss-blackout',
              blueprintId: 'core-midnight-boss-blackout:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-midnight-boss-blackout',
              blueprintId: 'core-midnight-boss-blackout:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreSkylineChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterSkylineTitle,
      description: l10n.studyHarmonyChapterSkylineDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-skyline-1-afterimage-pulse',
          chapterId: studyHarmonyCoreSkylineChapterId,
          title: l10n.studyHarmonyLessonSkylinePulseTitle,
          description: l10n.studyHarmonyLessonSkylinePulseDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.function'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-skyline-1-afterimage-pulse',
              blueprintId: 'core-skyline-1-afterimage-pulse:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-skyline-1-afterimage-pulse',
              blueprintId: 'core-skyline-1-afterimage-pulse:function',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-skyline-2-gravity-swap',
          chapterId: studyHarmonyCoreSkylineChapterId,
          title: l10n.studyHarmonyLessonSkylineSwapTitle,
          description: l10n.studyHarmonyLessonSkylineSwapDescription,
          boss: false,
          skillTags: const {'progression.nonDiatonic', 'progression.fillBlank'},
          tasks: [
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-skyline-2-gravity-swap',
              blueprintId: 'core-skyline-2-gravity-swap:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-skyline-2-gravity-swap',
              blueprintId: 'core-skyline-2-gravity-swap:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-skyline-3-false-home',
          chapterId: studyHarmonyCoreSkylineChapterId,
          title: l10n.studyHarmonyLessonSkylineHomeTitle,
          description: l10n.studyHarmonyLessonSkylineHomeDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-skyline-3-false-home',
              blueprintId: 'core-skyline-3-false-home:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-skyline-3-false-home',
              blueprintId: 'core-skyline-3-false-home:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-skyline-3-false-home',
              blueprintId: 'core-skyline-3-false-home:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-skyline-boss-final-signal',
          chapterId: studyHarmonyCoreSkylineChapterId,
          title: l10n.studyHarmonyLessonSkylineBossTitle,
          description: l10n.studyHarmonyLessonSkylineBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-skyline-boss-final-signal',
              blueprintId: 'core-skyline-boss-final-signal:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-skyline-boss-final-signal',
              blueprintId: 'core-skyline-boss-final-signal:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-skyline-boss-final-signal',
              blueprintId: 'core-skyline-boss-final-signal:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-skyline-boss-final-signal',
              blueprintId: 'core-skyline-boss-final-signal:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreAfterglowChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterAfterglowTitle,
      description: l10n.studyHarmonyChapterAfterglowDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-afterglow-1-split-decision',
          chapterId: studyHarmonyCoreAfterglowChapterId,
          title: l10n.studyHarmonyLessonAfterglowSplitTitle,
          description: l10n.studyHarmonyLessonAfterglowSplitDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-afterglow-1-split-decision',
              blueprintId: 'core-afterglow-1-split-decision:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-afterglow-1-split-decision',
              blueprintId: 'core-afterglow-1-split-decision:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-afterglow-2-borrowed-lure',
          chapterId: studyHarmonyCoreAfterglowChapterId,
          title: l10n.studyHarmonyLessonAfterglowLureTitle,
          description: l10n.studyHarmonyLessonAfterglowLureDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-afterglow-2-borrowed-lure',
              blueprintId: 'core-afterglow-2-borrowed-lure:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-afterglow-2-borrowed-lure',
              blueprintId: 'core-afterglow-2-borrowed-lure:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-afterglow-3-center-flicker',
          chapterId: studyHarmonyCoreAfterglowChapterId,
          title: l10n.studyHarmonyLessonAfterglowFlickerTitle,
          description: l10n.studyHarmonyLessonAfterglowFlickerDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-afterglow-3-center-flicker',
              blueprintId: 'core-afterglow-3-center-flicker:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-afterglow-3-center-flicker',
              blueprintId: 'core-afterglow-3-center-flicker:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-afterglow-3-center-flicker',
              blueprintId: 'core-afterglow-3-center-flicker:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-afterglow-boss-redline-return',
          chapterId: studyHarmonyCoreAfterglowChapterId,
          title: l10n.studyHarmonyLessonAfterglowBossTitle,
          description: l10n.studyHarmonyLessonAfterglowBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-afterglow-boss-redline-return',
              blueprintId: 'core-afterglow-boss-redline-return:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-afterglow-boss-redline-return',
              blueprintId: 'core-afterglow-boss-redline-return:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-afterglow-boss-redline-return',
              blueprintId: 'core-afterglow-boss-redline-return:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-afterglow-boss-redline-return',
              blueprintId: 'core-afterglow-boss-redline-return:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreDaybreakChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterDaybreakTitle,
      description: l10n.studyHarmonyChapterDaybreakDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-daybreak-1-ghost-cadence',
          chapterId: studyHarmonyCoreDaybreakChapterId,
          title: l10n.studyHarmonyLessonDaybreakGhostTitle,
          description: l10n.studyHarmonyLessonDaybreakGhostDescription,
          boss: false,
          skillTags: const {'progression.function', 'progression.fillBlank'},
          tasks: [
            adapter.buildFunctionBlueprint(
              lessonId: 'core-daybreak-1-ghost-cadence',
              blueprintId: 'core-daybreak-1-ghost-cadence:function',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-daybreak-1-ghost-cadence',
              blueprintId: 'core-daybreak-1-ghost-cadence:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-daybreak-2-false-dawn',
          chapterId: studyHarmonyCoreDaybreakChapterId,
          title: l10n.studyHarmonyLessonDaybreakDawnTitle,
          description: l10n.studyHarmonyLessonDaybreakDawnDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.nonDiatonic'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-daybreak-2-false-dawn',
              blueprintId: 'core-daybreak-2-false-dawn:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-daybreak-2-false-dawn',
              blueprintId: 'core-daybreak-2-false-dawn:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-daybreak-3-borrowed-bloom',
          chapterId: studyHarmonyCoreDaybreakChapterId,
          title: l10n.studyHarmonyLessonDaybreakBloomTitle,
          description: l10n.studyHarmonyLessonDaybreakBloomDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-daybreak-3-borrowed-bloom',
              blueprintId: 'core-daybreak-3-borrowed-bloom:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-daybreak-3-borrowed-bloom',
              blueprintId: 'core-daybreak-3-borrowed-bloom:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-daybreak-3-borrowed-bloom',
              blueprintId: 'core-daybreak-3-borrowed-bloom:non-diatonic',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-daybreak-boss-sunrise-overdrive',
          chapterId: studyHarmonyCoreDaybreakChapterId,
          title: l10n.studyHarmonyLessonDaybreakBossTitle,
          description: l10n.studyHarmonyLessonDaybreakBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-daybreak-boss-sunrise-overdrive',
              blueprintId: 'core-daybreak-boss-sunrise-overdrive:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-daybreak-boss-sunrise-overdrive',
              blueprintId: 'core-daybreak-boss-sunrise-overdrive:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-daybreak-boss-sunrise-overdrive',
              blueprintId: 'core-daybreak-boss-sunrise-overdrive:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-daybreak-boss-sunrise-overdrive',
              blueprintId: 'core-daybreak-boss-sunrise-overdrive:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
      ],
    ),
    _chapter(
      id: studyHarmonyCoreBlueHourChapterId,
      courseId: courseId,
      title: l10n.studyHarmonyChapterBlueHourTitle,
      description: l10n.studyHarmonyChapterBlueHourDescription,
      lessons: [
        _lesson(
          l10n: l10n,
          id: 'core-blue-hour-1-cross-current',
          chapterId: studyHarmonyCoreBlueHourChapterId,
          title: l10n.studyHarmonyLessonBlueHourCurrentTitle,
          description: l10n.studyHarmonyLessonBlueHourCurrentDescription,
          boss: false,
          skillTags: const {'progression.keyCenter', 'progression.function'},
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-blue-hour-1-cross-current',
              blueprintId: 'core-blue-hour-1-cross-current:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-blue-hour-1-cross-current',
              blueprintId: 'core-blue-hour-1-cross-current:function',
              l10n: l10n,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-blue-hour-2-halo-borrow',
          chapterId: studyHarmonyCoreBlueHourChapterId,
          title: l10n.studyHarmonyLessonBlueHourHaloTitle,
          description: l10n.studyHarmonyLessonBlueHourHaloDescription,
          boss: false,
          skillTags: const {'progression.nonDiatonic', 'progression.fillBlank'},
          tasks: [
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-blue-hour-2-halo-borrow',
              blueprintId: 'core-blue-hour-2-halo-borrow:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-blue-hour-2-halo-borrow',
              blueprintId: 'core-blue-hour-2-halo-borrow:fill',
              l10n: l10n,
              cadenceFocus: false,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-blue-hour-3-dual-horizon',
          chapterId: studyHarmonyCoreBlueHourChapterId,
          title: l10n.studyHarmonyLessonBlueHourHorizonTitle,
          description: l10n.studyHarmonyLessonBlueHourHorizonDescription,
          boss: false,
          skillTags: const {
            'progression.keyCenter',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-blue-hour-3-dual-horizon',
              blueprintId: 'core-blue-hour-3-dual-horizon:key-center',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-blue-hour-3-dual-horizon',
              blueprintId: 'core-blue-hour-3-dual-horizon:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-blue-hour-3-dual-horizon',
              blueprintId: 'core-blue-hour-3-dual-horizon:cadence',
              l10n: l10n,
              cadenceFocus: true,
            ),
          ],
        ),
        _lesson(
          l10n: l10n,
          id: 'core-blue-hour-boss-twin-lanterns',
          chapterId: studyHarmonyCoreBlueHourChapterId,
          title: l10n.studyHarmonyLessonBlueHourBossTitle,
          description: l10n.studyHarmonyLessonBlueHourBossDescription,
          boss: true,
          skillTags: const {
            'progression.keyCenter',
            'progression.function',
            'progression.nonDiatonic',
            'progression.fillBlank',
          },
          tasks: [
            adapter.buildKeyCenterBlueprint(
              lessonId: 'core-blue-hour-boss-twin-lanterns',
              blueprintId: 'core-blue-hour-boss-twin-lanterns:key-center',
              l10n: l10n,
            ),
            adapter.buildFunctionBlueprint(
              lessonId: 'core-blue-hour-boss-twin-lanterns',
              blueprintId: 'core-blue-hour-boss-twin-lanterns:function',
              l10n: l10n,
            ),
            adapter.buildNonDiatonicBlueprint(
              lessonId: 'core-blue-hour-boss-twin-lanterns',
              blueprintId: 'core-blue-hour-boss-twin-lanterns:non-diatonic',
              l10n: l10n,
            ),
            adapter.buildMissingChordBlueprint(
              lessonId: 'core-blue-hour-boss-twin-lanterns',
              blueprintId: 'core-blue-hour-boss-twin-lanterns:fill',
              l10n: l10n,
              cadenceFocus: false,
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
