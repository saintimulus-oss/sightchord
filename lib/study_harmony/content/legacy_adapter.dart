import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_task_evaluators.dart';
import '../study_harmony_models.dart';

class StudyHarmonyLegacyLessonAdapter {
  const StudyHarmonyLegacyLessonAdapter();

  static const StudyHarmonyTrackId prototypeTrackId =
      'legacy-study-harmony-track';
  static const StudyHarmonyCourseId prototypeCourseId =
      'legacy-study-harmony-course';
  static const StudyHarmonyChapterId prototypeChapterId =
      'legacy-study-harmony-chapter';

  StudyHarmonyCourseDefinition buildPrototypeCourse(
    Iterable<StudyHarmonyLevelDefinition> levels,
  ) {
    final lessons = [for (final level in levels) adaptLevel(level)];
    return StudyHarmonyCourseDefinition(
      id: prototypeCourseId,
      trackId: prototypeTrackId,
      title: 'Study Harmony Prototype',
      description: 'Legacy prototype levels carried into the lesson system.',
      chapters: [
        StudyHarmonyChapterDefinition(
          id: prototypeChapterId,
          courseId: prototypeCourseId,
          title: 'Prototype Lessons',
          description:
              'Temporary lessons preserved while the expandable study system is introduced.',
          lessons: lessons,
          skillTags: {for (final lesson in lessons) ...lesson.skillTags},
        ),
      ],
      skillTags: {for (final lesson in lessons) ...lesson.skillTags},
    );
  }

  StudyHarmonyLessonDefinition adaptLevel(StudyHarmonyLevelDefinition level) {
    final taskKinds = {
      for (final prompt in level.prompts)
        _taskKindForPrompt(level, prompt).name,
    };
    return StudyHarmonyLessonDefinition(
      id: level.id,
      chapterId: prototypeChapterId,
      title: level.title,
      description: level.description,
      objectiveLabel: level.objective,
      goalCorrectAnswers: level.goalCorrectAnswers,
      startingLives: level.startingLives,
      sessionMode: StudyHarmonySessionMode.legacyLevel,
      skillTags: {'legacy', 'legacy:${level.id}', ...taskKinds},
      tasks: [
        for (final prompt in level.prompts)
          _adaptPrompt(level: level, prompt: prompt),
      ],
    );
  }

  StudyHarmonyTaskBlueprint _adaptPrompt({
    required StudyHarmonyLevelDefinition level,
    required StudyHarmonyPromptDefinition prompt,
  }) {
    final taskKind = _taskKindForPrompt(level, prompt);
    return StudyHarmonyTaskBlueprint(
      id: '${level.id}:${prompt.id}',
      lessonId: level.id,
      taskKind: taskKind,
      promptSpec: StudyHarmonyPromptSpec(
        id: prompt.id,
        surface: _mapPromptSurface(level.promptSurface),
        primaryLabel: prompt.promptLabel,
        highlightedAnswerIds: prompt.promptHighlightedAnswerIds,
        hint: prompt.promptHint,
      ),
      answerOptions: _adaptAnswerOptions(level),
      answerSummaryLabel: prompt.answerSummaryLabel,
      answerSurface: _mapAnswerSurface(level.answerSurface),
      evaluator: _buildEvaluator(
        level: level,
        prompt: prompt,
        taskKind: taskKind,
      ),
      skillTags: {
        'legacy',
        'legacy:${level.id}',
        'prompt:${prompt.id}',
        taskKind.name,
      },
    );
  }

  List<StudyHarmonyAnswerOption> _adaptAnswerOptions(
    StudyHarmonyLevelDefinition level,
  ) {
    return switch (level.answerSurface) {
      StudyHarmonyAnswerSurface.pianoKeyboard => [
        for (final key in level.pianoKeys)
          StudyHarmonyPianoAnswerOption(
            id: key.id,
            westernLabel: key.westernLabel,
            solfegeLabel: key.solfegeLabel,
            isBlack: key.isBlack,
            whiteIndex: key.whiteIndex,
            blackGapAfterWhiteIndex: key.blackGapAfterWhiteIndex,
          ),
      ],
      StudyHarmonyAnswerSurface.choiceChips => [
        for (final choice in level.answerChoices)
          StudyHarmonyAnswerChoice(id: choice.id, label: choice.label),
      ],
    };
  }

  StudyHarmonyTaskEvaluator _buildEvaluator({
    required StudyHarmonyLevelDefinition level,
    required StudyHarmonyPromptDefinition prompt,
    required StudyHarmonyTaskKind taskKind,
  }) {
    return switch (level.selectionMode) {
      StudyHarmonySelectionMode.single
          when _allAcceptedSetsAreSingleChoice(prompt) =>
        SingleChoiceEvaluator(
          acceptedChoiceIds: prompt.acceptedAnswerSets.expand(
            (acceptedSet) => acceptedSet,
          ),
          supportedTaskKinds: {taskKind},
        ),
      StudyHarmonySelectionMode.multiple => MultiChoiceEvaluator(
        acceptedAnswerSets: prompt.acceptedAnswerSets,
        supportedTaskKinds: {taskKind},
      ),
      _ => ExactSetEvaluator(
        acceptedAnswerSets: prompt.acceptedAnswerSets,
        selectionMode: level.selectionMode == StudyHarmonySelectionMode.single
            ? StudyHarmonySelectionModeKind.single
            : StudyHarmonySelectionModeKind.multiple,
        supportedTaskKinds: {taskKind},
      ),
    };
  }

  bool _allAcceptedSetsAreSingleChoice(StudyHarmonyPromptDefinition prompt) {
    return prompt.acceptedAnswerSets.every(
      (acceptedSet) => acceptedSet.length == 1,
    );
  }

  StudyHarmonyTaskKind _taskKindForPrompt(
    StudyHarmonyLevelDefinition level,
    StudyHarmonyPromptDefinition prompt,
  ) {
    if (level.answerSurface == StudyHarmonyAnswerSurface.pianoKeyboard) {
      final hasCompoundAnswer = prompt.acceptedAnswerSets.any(
        (acceptedSet) => acceptedSet.length > 1,
      );
      return hasCompoundAnswer
          ? StudyHarmonyTaskKind.chordOnKeyboard
          : StudyHarmonyTaskKind.noteOnKeyboard;
    }

    if (level.promptSurface == StudyHarmonyPromptSurface.pianoPreview &&
        level.answerSurface == StudyHarmonyAnswerSurface.choiceChips) {
      final hasCompoundPreview = prompt.promptHighlightedAnswerIds.length > 1;
      return hasCompoundPreview
          ? StudyHarmonyTaskKind.chordNameChoice
          : StudyHarmonyTaskKind.noteNameChoice;
    }

    if (level.answerSurface == StudyHarmonyAnswerSurface.choiceChips &&
        level.selectionMode == StudyHarmonySelectionMode.multiple) {
      return StudyHarmonyTaskKind.scaleTonesChoice;
    }

    return StudyHarmonyTaskKind.noteNameChoice;
  }

  StudyHarmonyPromptSurfaceKind _mapPromptSurface(
    StudyHarmonyPromptSurface surface,
  ) {
    return switch (surface) {
      StudyHarmonyPromptSurface.text => StudyHarmonyPromptSurfaceKind.text,
      StudyHarmonyPromptSurface.pianoPreview =>
        StudyHarmonyPromptSurfaceKind.pianoPreview,
    };
  }

  StudyHarmonyAnswerSurfaceKind _mapAnswerSurface(
    StudyHarmonyAnswerSurface surface,
  ) {
    return switch (surface) {
      StudyHarmonyAnswerSurface.pianoKeyboard =>
        StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
      StudyHarmonyAnswerSurface.choiceChips =>
        StudyHarmonyAnswerSurfaceKind.choiceChips,
    };
  }
}
