import 'dart:math';

import '../../l10n/app_localizations.dart';
import '../../music/chord_formatting.dart';
import '../../music/chord_theory.dart';
import 'core_progression_curriculum.dart';
import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_task_evaluators.dart';
import '../study_harmony_catalog.dart';

const StudyHarmonyTrackId studyHarmonyCoreTrackId = 'core';
const StudyHarmonyCourseId studyHarmonyCoreCourseId = 'core-foundations-v1';

const StudyHarmonyChapterId studyHarmonyCoreNotesChapterId =
    'core-chapter-notes-keyboard';
const StudyHarmonyChapterId studyHarmonyCoreChordsChapterId =
    'core-chapter-chords-basics';
const StudyHarmonyChapterId studyHarmonyCoreScalesChapterId =
    'core-chapter-scales-keys';
const StudyHarmonyChapterId studyHarmonyCoreRomanChapterId =
    'core-chapter-roman-diatonicity';

StudyHarmonyCourseDefinition buildStudyHarmonyCoreCourse(
  AppLocalizations l10n,
) {
  final chapters = [
    _chapter(
      id: studyHarmonyCoreNotesChapterId,
      title: l10n.studyHarmonyChapterNotesTitle,
      description: l10n.studyHarmonyChapterNotesDescription,
      lessons: _buildNotesLessons(l10n),
    ),
    _chapter(
      id: studyHarmonyCoreChordsChapterId,
      title: l10n.studyHarmonyChapterChordsTitle,
      description: l10n.studyHarmonyChapterChordsDescription,
      lessons: _buildChordLessons(l10n),
    ),
    _chapter(
      id: studyHarmonyCoreScalesChapterId,
      title: l10n.studyHarmonyChapterScalesTitle,
      description: l10n.studyHarmonyChapterScalesDescription,
      lessons: _buildScaleLessons(l10n),
    ),
    _chapter(
      id: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyChapterRomanTitle,
      description: l10n.studyHarmonyChapterRomanDescription,
      lessons: _buildRomanLessons(l10n),
    ),
    ...buildStudyHarmonyCoreProgressionChapters(
      l10n: l10n,
      courseId: studyHarmonyCoreCourseId,
    ),
  ];

  return StudyHarmonyCourseDefinition(
    id: studyHarmonyCoreCourseId,
    trackId: studyHarmonyCoreTrackId,
    title: l10n.studyHarmonyCoreTrackTitle,
    description: l10n.studyHarmonyCoreTrackDescription,
    chapters: chapters,
    skillTags: {for (final chapter in chapters) ...chapter.skillTags},
  );
}

StudyHarmonyChapterDefinition _chapter({
  required StudyHarmonyChapterId id,
  required String title,
  required String description,
  required List<StudyHarmonyLessonDefinition> lessons,
}) {
  return StudyHarmonyChapterDefinition(
    id: id,
    courseId: studyHarmonyCoreCourseId,
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

const List<_PitchTarget> _whitePitches = <_PitchTarget>[
  _PitchTarget('C', 'C'),
  _PitchTarget('D', 'D'),
  _PitchTarget('E', 'E'),
  _PitchTarget('F', 'F'),
  _PitchTarget('G', 'G'),
  _PitchTarget('A', 'A'),
  _PitchTarget('B', 'B'),
];

const List<_PitchTarget> _blackPitches = <_PitchTarget>[
  _PitchTarget('C#', 'C# / Db'),
  _PitchTarget('Eb', 'D# / Eb'),
  _PitchTarget('F#', 'F# / Gb'),
  _PitchTarget('Ab', 'G# / Ab'),
  _PitchTarget('Bb', 'A# / Bb'),
];

const List<_ChordRecipe> _triadRecipes = <_ChordRecipe>[
  _ChordRecipe('C', ChordQuality.majorTriad),
  _ChordRecipe('F', ChordQuality.majorTriad),
  _ChordRecipe('G', ChordQuality.majorTriad),
  _ChordRecipe('D', ChordQuality.minorTriad),
  _ChordRecipe('E', ChordQuality.minorTriad),
  _ChordRecipe('A', ChordQuality.minorTriad),
  _ChordRecipe('B', ChordQuality.diminishedTriad),
];

const List<_ChordRecipe> _seventhRecipes = <_ChordRecipe>[
  _ChordRecipe('C', ChordQuality.major7),
  _ChordRecipe('F', ChordQuality.major7),
  _ChordRecipe('G', ChordQuality.dominant7),
  _ChordRecipe('D', ChordQuality.minor7),
  _ChordRecipe('E', ChordQuality.minor7),
  _ChordRecipe('A', ChordQuality.minor7),
];

const List<_ScaleRecipe> _majorScaleRecipes = <_ScaleRecipe>[
  _ScaleRecipe('C', _ScaleKind.major),
  _ScaleRecipe('G', _ScaleKind.major),
  _ScaleRecipe('D', _ScaleKind.major),
  _ScaleRecipe('F', _ScaleKind.major),
];

const List<_ScaleRecipe> _minorScaleRecipes = <_ScaleRecipe>[
  _ScaleRecipe('A', _ScaleKind.naturalMinor),
  _ScaleRecipe('E', _ScaleKind.naturalMinor),
  _ScaleRecipe('D', _ScaleKind.naturalMinor),
  _ScaleRecipe('A', _ScaleKind.harmonicMinor),
  _ScaleRecipe('E', _ScaleKind.harmonicMinor),
  _ScaleRecipe('D', _ScaleKind.harmonicMinor),
];

const List<_ScaleRecipe> _majorRomanKeyRecipes = <_ScaleRecipe>[
  _ScaleRecipe('C', _ScaleKind.major),
  _ScaleRecipe('G', _ScaleKind.major),
  _ScaleRecipe('D', _ScaleKind.major),
  _ScaleRecipe('F', _ScaleKind.major),
];

const List<_ScaleRecipe> _minorRomanKeyRecipes = <_ScaleRecipe>[
  _ScaleRecipe('A', _ScaleKind.naturalMinor),
  _ScaleRecipe('E', _ScaleKind.naturalMinor),
  _ScaleRecipe('D', _ScaleKind.naturalMinor),
];

List<StudyHarmonyLessonDefinition> _buildNotesLessons(AppLocalizations l10n) {
  const lessonId = 'core-notes-1-note-keyboard';
  const bossId = 'core-notes-boss-note-hunt';
  return [
    _lesson(
      l10n: l10n,
      id: lessonId,
      chapterId: studyHarmonyCoreNotesChapterId,
      title: l10n.studyHarmonyLessonNotesKeyboardTitle,
      description: l10n.studyHarmonyLessonNotesKeyboardDescription,
      boss: false,
      skillTags: const {'note.read', 'note.findKeyboard'},
      tasks: [
        _noteOnKeyboardBlueprint(
          lessonId: lessonId,
          blueprintId: '$lessonId:note-on-keyboard',
          l10n: l10n,
          pitchPool: _whitePitches,
          skillTags: const {'note.read', 'note.findKeyboard'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-notes-2-name-preview',
      chapterId: studyHarmonyCoreNotesChapterId,
      title: l10n.studyHarmonyLessonNotesPreviewTitle,
      description: l10n.studyHarmonyLessonNotesPreviewDescription,
      boss: false,
      skillTags: const {'note.read'},
      tasks: [
        _noteNameChoiceBlueprint(
          lessonId: 'core-notes-2-name-preview',
          blueprintId: 'core-notes-2-name-preview:note-name-choice',
          l10n: l10n,
          pitchPool: _whitePitches,
          answerPool: _whitePitches,
          skillTags: const {'note.read'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-notes-3-accidentals',
      chapterId: studyHarmonyCoreNotesChapterId,
      title: l10n.studyHarmonyLessonNotesAccidentalsTitle,
      description: l10n.studyHarmonyLessonNotesAccidentalsDescription,
      boss: false,
      skillTags: const {'note.read', 'note.findKeyboard', 'note.accidentals'},
      tasks: [
        _noteOnKeyboardBlueprint(
          lessonId: 'core-notes-3-accidentals',
          blueprintId: 'core-notes-3-accidentals:black-keyboard',
          l10n: l10n,
          pitchPool: _blackPitches,
          skillTags: const {'note.findKeyboard', 'note.accidentals'},
        ),
        _noteNameChoiceBlueprint(
          lessonId: 'core-notes-3-accidentals',
          blueprintId: 'core-notes-3-accidentals:black-name-choice',
          l10n: l10n,
          pitchPool: _blackPitches,
          answerPool: [..._whitePitches, ..._blackPitches],
          skillTags: const {'note.read', 'note.accidentals'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: bossId,
      chapterId: studyHarmonyCoreNotesChapterId,
      title: l10n.studyHarmonyLessonNotesBossTitle,
      description: l10n.studyHarmonyLessonNotesBossDescription,
      boss: true,
      skillTags: const {'note.read', 'note.findKeyboard', 'note.accidentals'},
      tasks: [
        _noteOnKeyboardBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:mixed-note-on-keyboard',
          l10n: l10n,
          pitchPool: [..._whitePitches, ..._blackPitches],
          skillTags: const {'note.findKeyboard'},
        ),
        _noteNameChoiceBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:mixed-note-name-choice',
          l10n: l10n,
          pitchPool: [..._whitePitches, ..._blackPitches],
          answerPool: [..._whitePitches, ..._blackPitches],
          skillTags: const {'note.read'},
        ),
      ],
    ),
  ];
}

List<StudyHarmonyLessonDefinition> _buildChordLessons(AppLocalizations l10n) {
  const bossId = 'core-chords-boss-review';
  final reviewBank = [..._triadRecipes, ..._seventhRecipes];
  return [
    _lesson(
      l10n: l10n,
      id: 'core-chords-1-triads-on-keys',
      chapterId: studyHarmonyCoreChordsChapterId,
      title: l10n.studyHarmonyLessonTriadKeyboardTitle,
      description: l10n.studyHarmonyLessonTriadKeyboardDescription,
      boss: false,
      skillTags: const {'chord.symbolToKeys'},
      tasks: [
        _chordOnKeyboardBlueprint(
          lessonId: 'core-chords-1-triads-on-keys',
          blueprintId: 'core-chords-1-triads-on-keys:triad-on-keyboard',
          l10n: l10n,
          recipePool: _triadRecipes,
          skillTags: const {'chord.symbolToKeys'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-chords-2-sevenths-on-keys',
      chapterId: studyHarmonyCoreChordsChapterId,
      title: l10n.studyHarmonyLessonSeventhKeyboardTitle,
      description: l10n.studyHarmonyLessonSeventhKeyboardDescription,
      boss: false,
      skillTags: const {'chord.symbolToKeys'},
      tasks: [
        _chordOnKeyboardBlueprint(
          lessonId: 'core-chords-2-sevenths-on-keys',
          blueprintId: 'core-chords-2-sevenths-on-keys:seventh-on-keyboard',
          l10n: l10n,
          recipePool: _seventhRecipes,
          skillTags: const {'chord.symbolToKeys'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-chords-3-name-highlighted',
      chapterId: studyHarmonyCoreChordsChapterId,
      title: l10n.studyHarmonyLessonChordNameTitle,
      description: l10n.studyHarmonyLessonChordNameDescription,
      boss: false,
      skillTags: const {'chord.nameFromTones'},
      tasks: [
        _chordNameChoiceBlueprint(
          lessonId: 'core-chords-3-name-highlighted',
          blueprintId: 'core-chords-3-name-highlighted:chord-name-choice',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'chord.nameFromTones'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: bossId,
      chapterId: studyHarmonyCoreChordsChapterId,
      title: l10n.studyHarmonyLessonChordsBossTitle,
      description: l10n.studyHarmonyLessonChordsBossDescription,
      boss: true,
      skillTags: const {'chord.symbolToKeys', 'chord.nameFromTones'},
      tasks: [
        _chordOnKeyboardBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:boss-chord-on-keyboard',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'chord.symbolToKeys'},
        ),
        _chordNameChoiceBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:boss-chord-name-choice',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'chord.nameFromTones'},
        ),
      ],
    ),
  ];
}

List<StudyHarmonyLessonDefinition> _buildScaleLessons(AppLocalizations l10n) {
  const bossId = 'core-scales-boss-repair';
  final reviewBank = [..._majorScaleRecipes, ..._minorScaleRecipes];
  return [
    _lesson(
      l10n: l10n,
      id: 'core-scales-1-major-builder',
      chapterId: studyHarmonyCoreScalesChapterId,
      title: l10n.studyHarmonyLessonMajorScaleTitle,
      description: l10n.studyHarmonyLessonMajorScaleDescription,
      boss: false,
      skillTags: const {'scale.build'},
      tasks: [
        _scaleBuilderBlueprint(
          lessonId: 'core-scales-1-major-builder',
          blueprintId: 'core-scales-1-major-builder:scale-builder',
          l10n: l10n,
          recipePool: _majorScaleRecipes,
          skillTags: const {'scale.build'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-scales-2-minor-builder',
      chapterId: studyHarmonyCoreScalesChapterId,
      title: l10n.studyHarmonyLessonMinorScaleTitle,
      description: l10n.studyHarmonyLessonMinorScaleDescription,
      boss: false,
      skillTags: const {'scale.build'},
      tasks: [
        _scaleBuilderBlueprint(
          lessonId: 'core-scales-2-minor-builder',
          blueprintId: 'core-scales-2-minor-builder:scale-builder',
          l10n: l10n,
          recipePool: _minorScaleRecipes,
          skillTags: const {'scale.build'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-scales-3-key-membership',
      chapterId: studyHarmonyCoreScalesChapterId,
      title: l10n.studyHarmonyLessonKeyMembershipTitle,
      description: l10n.studyHarmonyLessonKeyMembershipDescription,
      boss: false,
      skillTags: const {'scale.build', 'harmony.diatonicity'},
      tasks: [
        _keyMembershipBlueprint(
          lessonId: 'core-scales-3-key-membership',
          blueprintId: 'core-scales-3-key-membership:key-membership',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'scale.build', 'harmony.diatonicity'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: bossId,
      chapterId: studyHarmonyCoreScalesChapterId,
      title: l10n.studyHarmonyLessonScalesBossTitle,
      description: l10n.studyHarmonyLessonScalesBossDescription,
      boss: true,
      skillTags: const {'scale.build', 'harmony.diatonicity'},
      tasks: [
        _scaleBuilderBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:boss-scale-builder',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'scale.build'},
        ),
        _keyMembershipBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:boss-key-membership',
          l10n: l10n,
          recipePool: reviewBank,
          skillTags: const {'scale.build', 'harmony.diatonicity'},
        ),
      ],
    ),
  ];
}

const List<RomanNumeralId> _majorRomanBasics = <RomanNumeralId>[
  RomanNumeralId.iMaj7,
  RomanNumeralId.iiMin7,
  RomanNumeralId.iiiMin7,
  RomanNumeralId.ivMaj7,
  RomanNumeralId.vDom7,
  RomanNumeralId.viMin7,
  RomanNumeralId.viiHalfDiminished7,
];

const List<RomanNumeralId> _minorRomanBasics = <RomanNumeralId>[
  RomanNumeralId.iMin7,
  RomanNumeralId.iiHalfDiminishedMinor,
  RomanNumeralId.flatIIIMaj7Minor,
  RomanNumeralId.ivMin7Minor,
  RomanNumeralId.vDom7,
  RomanNumeralId.flatVIMaj7Minor,
  RomanNumeralId.flatVIIDom7Minor,
];

List<StudyHarmonyLessonDefinition> _buildRomanLessons(AppLocalizations l10n) {
  const bossId = 'core-roman-boss-basics';
  return [
    _lesson(
      l10n: l10n,
      id: 'core-roman-1-roman-to-chord',
      chapterId: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyLessonRomanToChordTitle,
      description: l10n.studyHarmonyLessonRomanToChordDescription,
      boss: false,
      skillTags: const {'roman.realize'},
      tasks: [
        _romanToChordBlueprint(
          lessonId: 'core-roman-1-roman-to-chord',
          blueprintId: 'core-roman-1-roman-to-chord:roman-to-chord',
          l10n: l10n,
          skillTags: const {'roman.realize'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-roman-2-chord-to-roman',
      chapterId: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyLessonChordToRomanTitle,
      description: l10n.studyHarmonyLessonChordToRomanDescription,
      boss: false,
      skillTags: const {'roman.identify'},
      tasks: [
        _chordToRomanBlueprint(
          lessonId: 'core-roman-2-chord-to-roman',
          blueprintId: 'core-roman-2-chord-to-roman:chord-to-roman',
          l10n: l10n,
          skillTags: const {'roman.identify'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-roman-3-diatonicity',
      chapterId: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyLessonDiatonicityTitle,
      description: l10n.studyHarmonyLessonDiatonicityDescription,
      boss: false,
      skillTags: const {'harmony.diatonicity'},
      tasks: [
        _diatonicityBlueprint(
          lessonId: 'core-roman-3-diatonicity',
          blueprintId: 'core-roman-3-diatonicity:diatonicity',
          l10n: l10n,
          skillTags: const {'harmony.diatonicity'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: 'core-roman-4-function',
      chapterId: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyLessonFunctionTitle,
      description: l10n.studyHarmonyLessonFunctionDescription,
      boss: false,
      skillTags: const {'harmony.function'},
      tasks: [
        _functionBlueprint(
          lessonId: 'core-roman-4-function',
          blueprintId: 'core-roman-4-function:function-choice',
          l10n: l10n,
          skillTags: const {'harmony.function'},
        ),
      ],
    ),
    _lesson(
      l10n: l10n,
      id: bossId,
      chapterId: studyHarmonyCoreRomanChapterId,
      title: l10n.studyHarmonyLessonRomanBossTitle,
      description: l10n.studyHarmonyLessonRomanBossDescription,
      boss: true,
      skillTags: const {
        'roman.realize',
        'roman.identify',
        'harmony.diatonicity',
        'harmony.function',
      },
      tasks: [
        _romanToChordBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:roman-to-chord',
          l10n: l10n,
          skillTags: const {'roman.realize'},
        ),
        _chordToRomanBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:chord-to-roman',
          l10n: l10n,
          skillTags: const {'roman.identify'},
        ),
        _diatonicityBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:diatonicity',
          l10n: l10n,
          skillTags: const {'harmony.diatonicity'},
        ),
        _functionBlueprint(
          lessonId: bossId,
          blueprintId: '$bossId:function-choice',
          l10n: l10n,
          skillTags: const {'harmony.function'},
        ),
      ],
    ),
  ];
}

StudyHarmonyTaskBlueprint _generatedBlueprint({
  required StudyHarmonyTaskBlueprintId blueprintId,
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskKind taskKind,
  required StudyHarmonyPromptSurfaceKind promptSurface,
  required StudyHarmonyAnswerSurfaceKind answerSurface,
  required StudyHarmonySelectionModeKind selectionMode,
  required Set<StudyHarmonySkillTag> skillTags,
  required StudyHarmonyTaskInstanceFactory instanceFactory,
}) {
  return StudyHarmonyTaskBlueprint(
    id: blueprintId,
    lessonId: lessonId,
    taskKind: taskKind,
    promptSpec: StudyHarmonyPromptSpec(
      id: '$blueprintId-template',
      surface: promptSurface,
      primaryLabel: blueprintId,
    ),
    answerOptions: const <StudyHarmonyAnswerOption>[],
    answerSummaryLabel: blueprintId,
    answerSurface: answerSurface,
    evaluator: selectionMode == StudyHarmonySelectionModeKind.single
        ? SingleChoiceEvaluator(
            acceptedChoiceIds: const ['template'],
            supportedTaskKinds: {taskKind},
          )
        : MultiChoiceEvaluator(
            acceptedAnswerSets: const [
              {'template'},
            ],
            supportedTaskKinds: {taskKind},
          ),
    instanceFactory: instanceFactory,
    skillTags: skillTags,
  );
}

StudyHarmonyTaskBlueprint _noteOnKeyboardBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_PitchTarget> pitchPool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.noteOnKeyboard,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
    selectionMode: StudyHarmonySelectionModeKind.multiple,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final pitch = _pickFrom(pitchPool, random);
          return _noteOnKeyboardInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptFindNoteOnKeyboard(
              pitch.displayLabel,
            ),
            pitch: pitch,
          );
        },
  );
}

StudyHarmonyTaskBlueprint _noteNameChoiceBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_PitchTarget> pitchPool,
  required List<_PitchTarget> answerPool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.noteNameChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.pianoPreview,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.single,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final pitch = _pickFrom(pitchPool, random);
          return _noteNameChoiceInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptNameHighlightedNote,
            correctPitch: pitch,
            answerPool: answerPool,
            random: random,
          );
        },
  );
}

StudyHarmonyTaskBlueprint _chordOnKeyboardBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_ChordRecipe> recipePool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.chordOnKeyboard,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
    selectionMode: StudyHarmonySelectionModeKind.multiple,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final recipe = _pickFrom(recipePool, random);
          return _chordOnKeyboardInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptFindChordOnKeyboard(
              recipe.label,
            ),
            recipe: recipe,
          );
        },
  );
}

StudyHarmonyTaskBlueprint _chordNameChoiceBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_ChordRecipe> recipePool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.chordNameChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.pianoPreview,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.single,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final recipe = _pickFrom(recipePool, random);
          return _chordNameChoiceInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptNameHighlightedChord,
            correctRecipe: recipe,
            distractors: _pickMany(
              [
                for (final candidate in recipePool)
                  if (candidate.label != recipe.label) candidate,
              ],
              3,
              random,
            ),
          );
        },
  );
}

StudyHarmonyTaskBlueprint _scaleBuilderBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_ScaleRecipe> recipePool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.scaleTonesChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.multiple,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final recipe = _pickFrom(recipePool, random);
          final scaleNotes = _scaleNotes(recipe);
          return _multiChoiceNoteSetInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptBuildScale(
              _scaleDisplayName(l10n, recipe),
            ),
            correctNotes: scaleNotes,
            candidateNotes: _shuffle([
              ...scaleNotes,
              ..._pickMany(_pitchOptionsExcluding(scaleNotes), 2, random),
            ], random),
            answerSummaryLabel: _noteSummaryLabel(scaleNotes),
          );
        },
  );
}

StudyHarmonyTaskBlueprint _keyMembershipBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required List<_ScaleRecipe> recipePool,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.scaleTonesChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.multiple,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final recipe = _pickFrom(recipePool, random);
          final scaleNotes = _scaleNotes(recipe);
          final correctNotes = _pickMany(scaleNotes, 4, random);
          return _multiChoiceNoteSetInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptKeyMembership(
              _keyDisplayName(l10n, recipe),
            ),
            correctNotes: correctNotes,
            candidateNotes: _shuffle([
              ...correctNotes,
              ..._pickMany(_pitchOptionsExcluding(scaleNotes), 2, random),
            ], random),
            answerSummaryLabel: _noteSummaryLabel(correctNotes),
          );
        },
  );
}

StudyHarmonyTaskBlueprint _romanToChordBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _romanChoiceBlueprint(
    lessonId: lessonId,
    blueprintId: blueprintId,
    l10n: l10n,
    taskKind: StudyHarmonyTaskKind.romanToChordChoice,
    skillTags: skillTags,
    choiceBuilder: (exercise) => exercise.chordLabel,
    promptBuilder: (exercise) => l10n.studyHarmonyPromptRomanToChord(
      exercise.keyLabel,
      exercise.romanLabel,
    ),
  );
}

StudyHarmonyTaskBlueprint _chordToRomanBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _romanChoiceBlueprint(
    lessonId: lessonId,
    blueprintId: blueprintId,
    l10n: l10n,
    taskKind: StudyHarmonyTaskKind.chordToRomanChoice,
    skillTags: skillTags,
    choiceBuilder: (exercise) => exercise.romanLabel,
    promptBuilder: (exercise) => l10n.studyHarmonyPromptChordToRoman(
      exercise.keyLabel,
      exercise.chordLabel,
    ),
  );
}

StudyHarmonyTaskBlueprint _diatonicityBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.diatonicityChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.single,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final exercise = _pickFrom(_romanExercises(l10n), random);
          final isDiatonic = random.nextBool();
          final correctLabel = isDiatonic
              ? l10n.studyHarmonyChoiceDiatonic
              : l10n.studyHarmonyChoiceNonDiatonic;
          return _singleChoiceInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptDiatonicity(
              exercise.keyLabel,
              isDiatonic ? exercise.chordLabel : exercise.nonDiatonicChordLabel,
            ),
            choices: [
              l10n.studyHarmonyChoiceDiatonic,
              l10n.studyHarmonyChoiceNonDiatonic,
            ],
            correctLabel: correctLabel,
            answerSummaryLabel: correctLabel,
          );
        },
  );
}

StudyHarmonyTaskBlueprint _functionBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: StudyHarmonyTaskKind.functionChoice,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.single,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final exercise = _pickFrom(_romanExercises(l10n), random);
          final correctLabel = _functionLabel(l10n, exercise.function);
          return _singleChoiceInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: l10n.studyHarmonyPromptFunction(
              exercise.keyLabel,
              exercise.chordLabel,
            ),
            choices: [
              l10n.studyHarmonyChoiceTonic,
              l10n.studyHarmonyChoicePredominant,
              l10n.studyHarmonyChoiceDominant,
            ],
            correctLabel: correctLabel,
            answerSummaryLabel: correctLabel,
          );
        },
  );
}

StudyHarmonyTaskBlueprint _romanChoiceBlueprint({
  required StudyHarmonyLessonId lessonId,
  required StudyHarmonyTaskBlueprintId blueprintId,
  required AppLocalizations l10n,
  required StudyHarmonyTaskKind taskKind,
  required Set<StudyHarmonySkillTag> skillTags,
  required String Function(_RomanExercise exercise) choiceBuilder,
  required String Function(_RomanExercise exercise) promptBuilder,
}) {
  return _generatedBlueprint(
    blueprintId: blueprintId,
    lessonId: lessonId,
    taskKind: taskKind,
    promptSurface: StudyHarmonyPromptSurfaceKind.text,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    selectionMode: StudyHarmonySelectionModeKind.single,
    skillTags: skillTags,
    instanceFactory:
        ({required blueprint, required sequenceNumber, required random}) {
          final exercises = _romanExercises(l10n);
          final exercise = _pickFrom(exercises, random);
          final correct = choiceBuilder(exercise);
          final pool = exercises
              .map(choiceBuilder)
              .where((value) => value != correct)
              .toSet()
              .toList(growable: false);
          return _singleChoiceInstance(
            blueprint: blueprint,
            sequenceNumber: sequenceNumber,
            promptLabel: promptBuilder(exercise),
            choices: _shuffle([correct, ..._pickMany(pool, 3, random)], random),
            correctLabel: correct,
            answerSummaryLabel: correct,
          );
        },
  );
}

StudyHarmonyTaskInstance _noteOnKeyboardInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required _PitchTarget pitch,
}) {
  return StudyHarmonyTaskInstance(
    blueprintId: blueprint.id,
    lessonId: blueprint.lessonId,
    taskKind: blueprint.taskKind,
    prompt: StudyHarmonyPromptSpec(
      id: '${blueprint.id}:${pitch.canonicalPitch}:$sequenceNumber',
      surface: StudyHarmonyPromptSurfaceKind.text,
      primaryLabel: promptLabel,
    ),
    answerOptions: _keyboardAnswerOptions(),
    answerSummaryLabel: pitch.displayLabel,
    answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
    evaluator: ExactSetEvaluator(
      acceptedAnswerSets: _acceptedKeyboardSetsForNotes([pitch.canonicalPitch]),
      supportedTaskKinds: {blueprint.taskKind},
    ),
    skillTags: blueprint.skillTags,
    sequenceNumber: sequenceNumber,
  );
}

StudyHarmonyTaskInstance _noteNameChoiceInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required _PitchTarget correctPitch,
  required List<_PitchTarget> answerPool,
  required Random random,
}) {
  final choices = _shuffle([
    correctPitch,
    ..._pickMany(
      [
        for (final pitch in answerPool)
          if (pitch.canonicalPitch != correctPitch.canonicalPitch) pitch,
      ],
      3,
      random,
    ),
  ], random);
  final highlightedChoices = _keyboardIdsForPitch(correctPitch.canonicalPitch);
  return _singleChoiceInstance(
    blueprint: blueprint,
    sequenceNumber: sequenceNumber,
    promptLabel: promptLabel,
    choices: [for (final choice in choices) choice.displayLabel],
    correctLabel: correctPitch.displayLabel,
    answerSummaryLabel: correctPitch.displayLabel,
    promptSurface: StudyHarmonyPromptSurfaceKind.pianoPreview,
    highlightedAnswerIds: {
      highlightedChoices[random.nextInt(highlightedChoices.length)],
    },
  );
}

StudyHarmonyTaskInstance _chordOnKeyboardInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required _ChordRecipe recipe,
}) {
  return StudyHarmonyTaskInstance(
    blueprintId: blueprint.id,
    lessonId: blueprint.lessonId,
    taskKind: blueprint.taskKind,
    prompt: StudyHarmonyPromptSpec(
      id: '${blueprint.id}:${recipe.label}:$sequenceNumber',
      surface: StudyHarmonyPromptSurfaceKind.text,
      primaryLabel: promptLabel,
    ),
    answerOptions: _keyboardAnswerOptions(),
    answerSummaryLabel: recipe.label,
    answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
    evaluator: MultiChoiceEvaluator(
      acceptedAnswerSets: _acceptedKeyboardSetsForNotes(recipe.noteNames),
      supportedTaskKinds: {blueprint.taskKind},
    ),
    skillTags: blueprint.skillTags,
    sequenceNumber: sequenceNumber,
  );
}

StudyHarmonyTaskInstance _chordNameChoiceInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required _ChordRecipe correctRecipe,
  required List<_ChordRecipe> distractors,
}) {
  return _singleChoiceInstance(
    blueprint: blueprint,
    sequenceNumber: sequenceNumber,
    promptLabel: promptLabel,
    choices: [
      correctRecipe.label,
      for (final distractor in distractors) distractor.label,
    ],
    correctLabel: correctRecipe.label,
    answerSummaryLabel: correctRecipe.label,
    promptSurface: StudyHarmonyPromptSurfaceKind.pianoPreview,
    highlightedAnswerIds: _acceptedKeyboardSetsForNotes(
      correctRecipe.noteNames,
    ).first,
  );
}

StudyHarmonyTaskInstance _multiChoiceNoteSetInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required List<String> correctNotes,
  required List<String> candidateNotes,
  required String answerSummaryLabel,
}) {
  return StudyHarmonyTaskInstance(
    blueprintId: blueprint.id,
    lessonId: blueprint.lessonId,
    taskKind: blueprint.taskKind,
    prompt: StudyHarmonyPromptSpec(
      id: '${blueprint.id}:$sequenceNumber',
      surface: StudyHarmonyPromptSurfaceKind.text,
      primaryLabel: promptLabel,
    ),
    answerOptions: [
      for (final note in candidateNotes)
        StudyHarmonyAnswerChoice(id: note, label: _displayPitchLabel(note)),
    ],
    answerSummaryLabel: answerSummaryLabel,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    evaluator: MultiChoiceEvaluator(
      acceptedAnswerSets: [correctNotes.toSet()],
      supportedTaskKinds: {blueprint.taskKind},
    ),
    skillTags: blueprint.skillTags,
    sequenceNumber: sequenceNumber,
  );
}

StudyHarmonyTaskInstance _singleChoiceInstance({
  required StudyHarmonyTaskBlueprint blueprint,
  required int sequenceNumber,
  required String promptLabel,
  required List<String> choices,
  required String correctLabel,
  required String answerSummaryLabel,
  StudyHarmonyPromptSurfaceKind promptSurface =
      StudyHarmonyPromptSurfaceKind.text,
  Set<StudyHarmonyAnswerOptionId> highlightedAnswerIds =
      const <StudyHarmonyAnswerOptionId>{},
}) {
  final labels = choices.toSet().toList(growable: false);
  final options = [
    for (var index = 0; index < labels.length; index += 1)
      StudyHarmonyAnswerChoice(id: 'choice-$index', label: labels[index]),
  ];
  return StudyHarmonyTaskInstance(
    blueprintId: blueprint.id,
    lessonId: blueprint.lessonId,
    taskKind: blueprint.taskKind,
    prompt: StudyHarmonyPromptSpec(
      id: '${blueprint.id}:$sequenceNumber',
      surface: promptSurface,
      primaryLabel: promptLabel,
      highlightedAnswerIds: highlightedAnswerIds,
    ),
    answerOptions: options,
    answerSummaryLabel: answerSummaryLabel,
    answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
    evaluator: SingleChoiceEvaluator(
      acceptedChoiceIds: [options[labels.indexOf(correctLabel)].id],
      supportedTaskKinds: {blueprint.taskKind},
    ),
    skillTags: blueprint.skillTags,
    sequenceNumber: sequenceNumber,
  );
}

List<StudyHarmonyAnswerOption> _keyboardAnswerOptions() => [
  for (final key in studyHarmonyKeyboardKeys)
    StudyHarmonyPianoAnswerOption(
      id: key.id,
      westernLabel: key.westernLabel,
      solfegeLabel: key.solfegeLabel,
      isBlack: key.isBlack,
      whiteIndex: key.whiteIndex,
      blackGapAfterWhiteIndex: key.blackGapAfterWhiteIndex,
    ),
];

List<Set<StudyHarmonyAnswerOptionId>> _acceptedKeyboardSetsForNotes(
  List<String> noteNames,
) {
  final idsByNote = [for (final note in noteNames) _keyboardIdsForPitch(note)];
  final results = <Set<StudyHarmonyAnswerOptionId>>[];

  void build(int index, Set<StudyHarmonyAnswerOptionId> current) {
    if (index == idsByNote.length) {
      results.add(Set<StudyHarmonyAnswerOptionId>.unmodifiable(current));
      return;
    }
    for (final answerId in idsByNote[index]) {
      build(index + 1, {...current, answerId});
    }
  }

  build(0, <StudyHarmonyAnswerOptionId>{});
  return results.toSet().toList(growable: false);
}

List<String> _keyboardIdsForPitch(String pitch) => [
  for (final key in studyHarmonyKeyboardKeys)
    if (MusicTheory.noteToSemitone[key.westernLabel] ==
        MusicTheory.noteToSemitone[pitch])
      key.id,
];

String _formatChordLabel(String root, ChordQuality quality) =>
    ChordSymbolFormatter.format(
      ChordSymbolData(
        root: root,
        harmonicQuality: quality,
        renderQuality: quality,
      ),
      ChordSymbolStyle.majText,
    );

T _pickFrom<T>(List<T> values, Random random) =>
    values[random.nextInt(values.length)];

List<T> _pickMany<T>(List<T> values, int count, Random random) =>
    ([...values]..shuffle(random)).take(count).toList(growable: false);

List<T> _shuffle<T>(List<T> values, Random random) =>
    [...values]..shuffle(random);

String _noteSummaryLabel(List<String> notes) =>
    notes.map(_displayPitchLabel).join(', ');

List<String> _scaleNotes(_ScaleRecipe recipe) {
  final offsets = switch (recipe.kind) {
    _ScaleKind.major => const [0, 2, 4, 5, 7, 9, 11],
    _ScaleKind.naturalMinor => const [0, 2, 3, 5, 7, 8, 10],
    _ScaleKind.harmonicMinor => const [0, 2, 3, 5, 7, 8, 11],
  };
  return [
    for (final offset in offsets)
      MusicTheory.transposePitch(
        recipe.tonic,
        offset,
        preferFlat: MusicTheory.prefersFlatSpellingForRoot(recipe.tonic),
      ),
  ];
}

List<String> _pitchOptionsExcluding(List<String> excludedNotes) {
  final excluded = {
    for (final note in excludedNotes) ?MusicTheory.noteToSemitone[note],
  };
  return [
    for (final pitch in [..._whitePitches, ..._blackPitches])
      if (!excluded.contains(MusicTheory.noteToSemitone[pitch.canonicalPitch]))
        pitch.canonicalPitch,
  ];
}

String _displayPitchLabel(String pitch) {
  for (final target in [..._whitePitches, ..._blackPitches]) {
    if (MusicTheory.noteToSemitone[target.canonicalPitch] ==
        MusicTheory.noteToSemitone[pitch]) {
      return target.displayLabel;
    }
  }
  return pitch;
}

String _scaleDisplayName(AppLocalizations l10n, _ScaleRecipe recipe) =>
    switch (recipe.kind) {
      _ScaleKind.major => l10n.studyHarmonyScaleNameMajor(recipe.tonic),
      _ScaleKind.naturalMinor => l10n.studyHarmonyScaleNameNaturalMinor(
        recipe.tonic,
      ),
      _ScaleKind.harmonicMinor => l10n.studyHarmonyScaleNameHarmonicMinor(
        recipe.tonic,
      ),
    };

String _keyDisplayName(AppLocalizations l10n, _ScaleRecipe recipe) =>
    switch (recipe.kind) {
      _ScaleKind.major => l10n.studyHarmonyKeyNameMajor(recipe.tonic),
      _ScaleKind.naturalMinor ||
      _ScaleKind.harmonicMinor => l10n.studyHarmonyKeyNameMinor(recipe.tonic),
    };

List<_RomanExercise> _romanExercises(AppLocalizations l10n) => [
  for (final recipe in _majorRomanKeyRecipes)
    ..._romanExercisesForKey(l10n, recipe, _majorRomanBasics),
  for (final recipe in _minorRomanKeyRecipes)
    ..._romanExercisesForKey(l10n, recipe, _minorRomanBasics),
];

List<_RomanExercise> _romanExercisesForKey(
  AppLocalizations l10n,
  _ScaleRecipe recipe,
  List<RomanNumeralId> romans,
) {
  final center = MusicTheory.keyCenterFor(
    recipe.tonic,
    mode: recipe.kind == _ScaleKind.major ? KeyMode.major : KeyMode.minor,
  );
  final keyLabel = _keyDisplayName(l10n, recipe);
  return [
    for (final romanId in romans)
      _buildRomanExercise(keyLabel: keyLabel, center: center, romanId: romanId),
  ];
}

_RomanExercise _buildRomanExercise({
  required String keyLabel,
  required KeyCenter center,
  required RomanNumeralId romanId,
}) {
  final triadQuality = _triadQualityForRoman(romanId);
  final root = MusicTheory.resolveChordRootForCenter(center, romanId);
  return _RomanExercise(
    keyLabel: keyLabel,
    chordLabel: _formatChordLabel(root, triadQuality),
    romanLabel: _basicRomanToken(romanId),
    function: MusicTheory.specFor(romanId).harmonicFunction,
    nonDiatonicChordLabel: _formatChordLabel(
      root,
      _alternateChordQuality(triadQuality),
    ),
  );
}

ChordQuality _triadQualityForRoman(RomanNumeralId romanId) =>
    switch (MusicTheory.specFor(romanId).quality) {
      ChordQuality.majorTriad ||
      ChordQuality.major7 ||
      ChordQuality.six ||
      ChordQuality.major69 ||
      ChordQuality.dominant7 ||
      ChordQuality.dominant7Alt ||
      ChordQuality.dominant7Sharp11 ||
      ChordQuality.dominant13sus4 ||
      ChordQuality.dominant7sus4 => ChordQuality.majorTriad,
      ChordQuality.minorTriad ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.minor6 => ChordQuality.minorTriad,
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 => ChordQuality.diminishedTriad,
      ChordQuality.augmentedTriad => ChordQuality.augmentedTriad,
    };

ChordQuality _alternateChordQuality(ChordQuality quality) => switch (quality) {
  ChordQuality.majorTriad => ChordQuality.minorTriad,
  ChordQuality.minorTriad ||
  ChordQuality.diminishedTriad ||
  ChordQuality.augmentedTriad => ChordQuality.majorTriad,
  _ => ChordQuality.majorTriad,
};

String _basicRomanToken(RomanNumeralId romanId) => switch (romanId) {
  RomanNumeralId.iMaj7 => 'I',
  RomanNumeralId.iiMin7 => 'ii',
  RomanNumeralId.iiiMin7 => 'iii',
  RomanNumeralId.ivMaj7 => 'IV',
  RomanNumeralId.vDom7 => 'V',
  RomanNumeralId.viMin7 => 'vi',
  RomanNumeralId.viiHalfDiminished7 => 'vii dim',
  RomanNumeralId.iMin7 => 'i',
  RomanNumeralId.iiHalfDiminishedMinor => 'ii dim',
  RomanNumeralId.flatIIIMaj7Minor => 'III',
  RomanNumeralId.ivMin7Minor => 'iv',
  RomanNumeralId.flatVIMaj7Minor => 'VI',
  RomanNumeralId.flatVIIDom7Minor => 'VII',
  _ => MusicTheory.romanTokenOf(romanId),
};

String _functionLabel(AppLocalizations l10n, HarmonicFunction function) =>
    switch (function) {
      HarmonicFunction.tonic => l10n.studyHarmonyChoiceTonic,
      HarmonicFunction.predominant => l10n.studyHarmonyChoicePredominant,
      HarmonicFunction.dominant => l10n.studyHarmonyChoiceDominant,
      HarmonicFunction.free => l10n.studyHarmonyChoiceTonic,
    };

class _PitchTarget {
  const _PitchTarget(this.canonicalPitch, this.displayLabel);

  final String canonicalPitch;
  final String displayLabel;
}

class _ChordRecipe {
  const _ChordRecipe(this.root, this.quality);

  final String root;
  final ChordQuality quality;

  List<String> get noteNames => [
    for (final offset in ChordToneFormulaLibrary.formulaFor(quality))
      MusicTheory.transposePitch(
        root,
        offset,
        preferFlat: MusicTheory.prefersFlatSpellingForRoot(root),
      ),
  ];

  String get label => _formatChordLabel(root, quality);
}

enum _ScaleKind { major, naturalMinor, harmonicMinor }

class _ScaleRecipe {
  const _ScaleRecipe(this.tonic, this.kind);

  final String tonic;
  final _ScaleKind kind;
}

class _RomanExercise {
  const _RomanExercise({
    required this.keyLabel,
    required this.chordLabel,
    required this.romanLabel,
    required this.function,
    required this.nonDiatonicChordLabel,
  });

  final String keyLabel;
  final String chordLabel;
  final String romanLabel;
  final HarmonicFunction function;
  final String nonDiatonicChordLabel;
}
