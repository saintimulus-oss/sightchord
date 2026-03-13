import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/app.dart';
import 'package:sightchord/l10n/app_localizations.dart';
import 'package:sightchord/l10n/app_localizations_en.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';
import 'package:sightchord/study_harmony/application/study_harmony_progress_controller.dart';
import 'package:sightchord/study_harmony/content/core_curriculum_catalog.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_task_evaluators.dart';
import 'package:sightchord/study_harmony_page.dart';
import 'package:sightchord/study_harmony/study_harmony_level_page.dart';
import 'package:sightchord/study_harmony/study_harmony_models.dart';
import 'package:sightchord/study_harmony/study_harmony_session_page.dart';

StudyHarmonyLessonDefinition _buildShortcutLesson() {
  const lessonId = 'shortcut-lesson';
  const choiceA = StudyHarmonyAnswerChoice(id: 'choice-a', label: 'C');
  const choiceB = StudyHarmonyAnswerChoice(id: 'choice-b', label: 'D');

  return StudyHarmonyLessonDefinition(
    id: lessonId,
    chapterId: studyHarmonyCoreNotesChapterId,
    title: 'Shortcut Lesson',
    description: 'Test keyboard actions and focus flow.',
    objectiveLabel: 'Quick Drill',
    goalCorrectAnswers: 2,
    startingLives: 2,
    sessionMode: StudyHarmonySessionMode.lesson,
    tasks: [
      StudyHarmonyTaskBlueprint(
        id: 'shortcut-blueprint',
        lessonId: lessonId,
        taskKind: StudyHarmonyTaskKind.noteNameChoice,
        promptSpec: const StudyHarmonyPromptSpec(
          id: 'shortcut-template',
          surface: StudyHarmonyPromptSurfaceKind.text,
          primaryLabel: 'Question 1',
        ),
        answerOptions: const [choiceA, choiceB],
        answerSummaryLabel: 'C',
        answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
        evaluator: SingleChoiceEvaluator(acceptedChoiceIds: ['choice-a']),
        instanceFactory:
            ({required blueprint, required sequenceNumber, required random}) =>
                StudyHarmonyTaskInstance(
                  blueprintId: blueprint.id,
                  lessonId: blueprint.lessonId,
                  taskKind: blueprint.taskKind,
                  prompt: StudyHarmonyPromptSpec(
                    id: 'shortcut-question-$sequenceNumber',
                    surface: StudyHarmonyPromptSurfaceKind.text,
                    primaryLabel: 'Question ${sequenceNumber + 1}',
                  ),
                  answerOptions: blueprint.answerOptions,
                  answerSummaryLabel: blueprint.answerSummaryLabel,
                  answerSurface: blueprint.answerSurface,
                  evaluator: blueprint.evaluator,
                  skillTags: const {'note.read'},
                  sequenceNumber: sequenceNumber,
                ),
      ),
    ],
    skillTags: const {'note.read'},
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    StudyHarmonyProgressSnapshot? progressSnapshot,
  }) async {
    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MyApp(
        controller: AppSettingsController(
          initialSettings: PracticeSettings(language: AppLanguage.en),
        ),
        studyHarmonyProgressController: StudyHarmonyProgressController(
          initialSnapshot:
              progressSnapshot ?? StudyHarmonyProgressSnapshot.initial(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('main menu shows a study harmony entry point', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
      findsOneWidget,
    );
    expect(find.text('Study Harmony'), findsWidgets);
  });

  testWidgets(
    'main menu surfaces a lightweight study harmony progress summary',
    (WidgetTester tester) async {
      final snapshot = StudyHarmonyProgressSnapshot.initial().copyWith(
        lastPlayedTrackId: studyHarmonyCoreTrackId,
        lastPlayedChapterId: studyHarmonyCoreNotesChapterId,
        lastPlayedLessonId: 'core-notes-2-name-preview',
        unlockedChapterIds: {studyHarmonyCoreNotesChapterId},
        unlockedLessonIds: {
          'core-notes-1-note-keyboard',
          'core-notes-2-name-preview',
        },
        lessonResults: {
          'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-1-note-keyboard',
            isCleared: true,
            bestAccuracy: 0.92,
            bestAttemptCount: 2,
            bestStars: 3,
            bestRank: 'A',
            bestElapsedMillis: 16000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
          ),
        },
      );

      await pumpApp(tester, progressSnapshot: snapshot);

      expect(
        find.byKey(const ValueKey('main-open-study-harmony-button-supporting')),
        findsOneWidget,
      );
      expect(find.text('Continue: Name the Highlighted Note'), findsOneWidget);
      expect(find.text('Chapter 1: Notes & Keyboard'), findsOneWidget);
      expect(find.text('1/24 lessons cleared'), findsOneWidget);
    },
  );

  testWidgets(
    'study harmony hub renders continue, review, daily, and chapter cards',
    (WidgetTester tester) async {
      await pumpApp(tester);

      await tester.ensureVisible(
        find.byKey(const ValueKey('main-open-study-harmony-button')),
      );
      await tester.tap(
        find.byKey(const ValueKey('main-open-study-harmony-button')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('study-harmony-page')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('study-harmony-hero-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-continue-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-review-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-daily-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-notes-keyboard',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-chords-basics',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-progression-detective',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-lock-core-chapter-chords-basics',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('track filter switches to locked placeholder content', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jazz'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('study-harmony-track-placeholder')),
      findsOneWidget,
    );
    expect(find.text('Coming soon'), findsWidgets);
  });

  testWidgets('chapter card opens lesson sheet and launches a session', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const ValueKey(
          'study-harmony-open-chapter-core-chapter-notes-keyboard',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-sheet-core-chapter-notes-keyboard',
        ),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(
        const ValueKey('study-harmony-open-lesson-core-notes-1-note-keyboard'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('study-harmony-prompt-card')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('study-harmony-piano-keyboard')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('study-harmony-lives')), findsOneWidget);
  });

  testWidgets('continue card surfaces the last played lesson when available', (
    WidgetTester tester,
  ) async {
    final snapshot = StudyHarmonyProgressSnapshot.initial().copyWith(
      lastPlayedTrackId: studyHarmonyCoreTrackId,
      lastPlayedChapterId: studyHarmonyCoreNotesChapterId,
      lastPlayedLessonId: 'core-notes-2-name-preview',
      unlockedChapterIds: {studyHarmonyCoreNotesChapterId},
      unlockedLessonIds: {
        'core-notes-1-note-keyboard',
        'core-notes-2-name-preview',
      },
    );

    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StudyHarmonyPage(
          progressController: StudyHarmonyProgressController(
            initialSnapshot: snapshot,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final continueCard = find.byKey(
      const ValueKey('study-harmony-continue-card'),
    );

    expect(continueCard, findsOneWidget);
    expect(
      find.descendant(
        of: continueCard,
        matching: find.text('Name the Highlighted Note'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: continueCard,
        matching: find.text('Resume the lesson you touched most recently.'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('review and daily cards open routed session modes', (
    WidgetTester tester,
  ) async {
    final snapshot = StudyHarmonyProgressSnapshot.initial().copyWith(
      unlockedChapterIds: {
        studyHarmonyCoreNotesChapterId,
        studyHarmonyCoreChordsChapterId,
      },
      unlockedLessonIds: {
        'core-notes-1-note-keyboard',
        'core-notes-2-name-preview',
        'core-notes-3-accidentals',
        'core-notes-boss-note-hunt',
        'core-chords-1-triads-on-keys',
      },
      lessonResults: {
        'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
          lessonId: 'core-notes-1-note-keyboard',
          isCleared: true,
          bestAccuracy: 0.55,
          bestAttemptCount: 4,
          bestStars: 1,
          bestRank: 'C',
          bestElapsedMillis: 20000,
          playCount: 1,
          lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
        ),
      },
      reviewQueuePlaceholders: const [
        StudyHarmonyReviewQueuePlaceholderEntry(
          itemId: 'lesson:core-notes-1-note-keyboard',
          lessonId: 'core-notes-1-note-keyboard',
          reason: 'retry-needed',
          dueAtIso8601: '2026-03-12T12:00:00.000Z',
          priority: 3,
          skillTags: {'note.findKeyboard'},
        ),
      ],
    );

    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StudyHarmonyPage(
          progressController: StudyHarmonyProgressController(
            initialSnapshot: snapshot,
            nowProvider: () => DateTime(2026, 3, 13),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('study-harmony-review-card')),
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('study-harmony-review-card')),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Review Mode'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('study-harmony-daily-card')),
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('study-harmony-daily-card')),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Daily Mode'), findsWidgets);
  });

  testWidgets(
    'session page supports shortcut selection, submit, next, and restart',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StudyHarmonySessionPage(
            lesson: _buildShortcutLesson(),
            trackId: studyHarmonyCoreTrackId,
            progressController: StudyHarmonyProgressController(
              initialSnapshot: StudyHarmonyProgressSnapshot.initial(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Question 1'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('study-harmony-selected-C')),
        findsOneWidget,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('study-harmony-feedback-banner')),
        findsOneWidget,
      );
      expect(find.text('Next prompt'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Question 2'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyR);
      await tester.pumpAndSettle();

      expect(find.text('Question 1'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('study-harmony-feedback-banner')),
        findsNothing,
      );
    },
  );

  test('core course catalog exposes six chapters and lesson counts', () {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());

    expect(course.trackId, studyHarmonyCoreTrackId);
    expect(course.chapters, hasLength(6));
    expect(
      course.chapters.map((chapter) => chapter.lessons.length).toList(),
      equals([4, 4, 4, 5, 4, 3]),
    );
    expect(
      course.chapters.first.lessons.first.id,
      'core-notes-1-note-keyboard',
    );
    expect(
      course.chapters[4].lessons.first.id,
      'core-progression-1-key-center',
    );
  });

  testWidgets('submitting the correct key completes a single-question level', (
    WidgetTester tester,
  ) async {
    const level = StudyHarmonyLevelDefinition(
      id: 'single-c',
      title: 'Single prompt',
      description: 'Test level',
      objective: 'Clear one answer',
      goalCorrectAnswers: 1,
      startingLives: 1,
      promptSurface: StudyHarmonyPromptSurface.text,
      answerSurface: StudyHarmonyAnswerSurface.pianoKeyboard,
      selectionMode: StudyHarmonySelectionMode.multiple,
      pianoKeys: [
        StudyHarmonyPianoKeyDefinition(
          id: 'c4',
          westernLabel: 'C',
          solfegeLabel: 'Do',
          isBlack: false,
          whiteIndex: 0,
        ),
        StudyHarmonyPianoKeyDefinition(
          id: 'd4',
          westernLabel: 'D',
          solfegeLabel: 'Re',
          isBlack: false,
          whiteIndex: 1,
        ),
      ],
      prompts: [
        StudyHarmonyPromptDefinition(
          id: 'do',
          promptLabel: 'Do (C)',
          answerSummaryLabel: 'Do (C)',
          acceptedAnswerSets: [
            {'c4'},
          ],
        ),
      ],
    );

    tester.view.physicalSize = const Size(1280, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StudyHarmonyLevelPage(
          level: level,
          progressController: StudyHarmonyProgressController(
            initialSnapshot: StudyHarmonyProgressSnapshot.initial(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('study-harmony-key-c4')),
    );
    await tester.tap(find.byKey(const ValueKey('study-harmony-key-c4')));
    await tester.pump();
    await tester.ensureVisible(
      find.byKey(const ValueKey('study-harmony-submit-button')),
    );
    await tester.tap(find.byKey(const ValueKey('study-harmony-submit-button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('study-harmony-feedback-banner')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('study-harmony-result-overlay')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('study-harmony-retry-button')),
      findsOneWidget,
    );
  });
}
