import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/app.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/settings_controller.dart';
import 'package:chordest/study_harmony/application/study_harmony_progress_controller.dart';
import 'package:chordest/study_harmony/content/core_curriculum_catalog.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_task_evaluators.dart';
import 'package:chordest/study_harmony_page.dart';
import 'package:chordest/study_harmony/study_harmony_level_page.dart';
import 'package:chordest/study_harmony/study_harmony_models.dart';
import 'package:chordest/study_harmony/study_harmony_session_page.dart';

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

StudyHarmonyLessonDefinition _buildPromptPreviewLesson() {
  const lessonId = 'prompt-preview-lesson';

  return StudyHarmonyLessonDefinition(
    id: lessonId,
    chapterId: studyHarmonyCoreNotesChapterId,
    title: 'Prompt Preview Lesson',
    description: 'Shows reusable prompt playback controls.',
    objectiveLabel: 'Preview Prompt',
    goalCorrectAnswers: 1,
    startingLives: 2,
    sessionMode: StudyHarmonySessionMode.lesson,
    tasks: [
      StudyHarmonyTaskBlueprint(
        id: 'prompt-preview-blueprint',
        lessonId: lessonId,
        taskKind: StudyHarmonyTaskKind.noteOnKeyboard,
        promptSpec: const StudyHarmonyPromptSpec(
          id: 'prompt-preview',
          surface: StudyHarmonyPromptSurfaceKind.pianoPreview,
          primaryLabel: 'Find the highlighted note',
          highlightedAnswerIds: <StudyHarmonyAnswerOptionId>{'c4'},
        ),
        answerOptions: const [
          StudyHarmonyPianoAnswerOption(
            id: 'c4',
            westernLabel: 'C',
            solfegeLabel: 'Do',
            isBlack: false,
            whiteIndex: 0,
          ),
          StudyHarmonyPianoAnswerOption(
            id: 'd4',
            westernLabel: 'D',
            solfegeLabel: 'Re',
            isBlack: false,
            whiteIndex: 1,
          ),
        ],
        answerSummaryLabel: 'C',
        answerSurface: StudyHarmonyAnswerSurfaceKind.pianoKeyboard,
        evaluator: MultiChoiceEvaluator(
          acceptedAnswerSets: const <Set<StudyHarmonyAnswerOptionId>>[
            <StudyHarmonyAnswerOptionId>{'c4'},
          ],
        ),
      ),
    ],
    skillTags: const {'note.findKeyboard'},
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
        find.byKey(const ValueKey('main-open-study-harmony-button')),
        findsOneWidget,
      );
      expect(
        find.textContaining('Continue: Name the Highlighted Note'),
        findsOneWidget,
      );
      expect(find.textContaining('1/69 lessons cleared'), findsOneWidget);
      expect(find.text('Chapter 1: Notes & Keyboard'), findsNothing);
      expect(find.text('3 stars'), findsNothing);
    },
  );

  testWidgets('main menu summary follows the last played non-core track', (
    WidgetTester tester,
  ) async {
    final snapshot = StudyHarmonyProgressSnapshot.initial().copyWith(
      lastPlayedTrackId: studyHarmonyJazzTrackId,
      lastPlayedChapterId: 'jazz-chapter-notes-keyboard',
      lastPlayedLessonId: 'jazz-notes-2-name-preview',
      unlockedChapterIds: {'jazz-chapter-notes-keyboard'},
      unlockedLessonIds: {
        'jazz-notes-1-note-keyboard',
        'jazz-notes-2-name-preview',
      },
      lessonResults: {
        'jazz-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
          lessonId: 'jazz-notes-1-note-keyboard',
          isCleared: true,
          bestAccuracy: 0.92,
          bestAttemptCount: 2,
          bestStars: 3,
          bestRank: 'A',
          bestElapsedMillis: 16000,
          playCount: 1,
        ),
      },
    );

    await pumpApp(tester, progressSnapshot: snapshot);

    expect(
      find.textContaining('Continue: Name the Highlighted Note'),
      findsOneWidget,
    );
    expect(find.textContaining('1/69 lessons cleared'), findsOneWidget);
  });

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
        find.byKey(const ValueKey('study-harmony-tour-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-duet-card')),
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
        find.byKey(const ValueKey('study-harmony-legend-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-league-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-relay-card')),
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
            'study-harmony-chapter-card-core-chapter-checkpoint-gauntlet',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-capstone-trials',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('study-harmony-chapter-card-core-chapter-remix-arena'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-encore-ladder',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-spotlight-showdown',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-after-hours-lab',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-neon-detours',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-midnight-switchboard',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-skyline-circuit',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-afterglow-runway',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-daybreak-frequency',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-card-core-chapter-blue-hour-exchange',
          ),
        ),
        findsOneWidget,
      );
      expect(find.text('Daily missing'), findsOneWidget);
      expect(find.text('Spotlight missing'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey(
            'study-harmony-chapter-lock-core-chapter-chords-basics',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-quest-card-dailyStreak')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-quest-card-frontierLesson')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-quest-card-chapterStars')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-quest-chest-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-milestone-card-lessonPath')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('study-harmony-milestone-card-starCollector'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-milestone-card-streakLegend')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('study-harmony-milestone-card-masteryScholar'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-milestone-card-relayRunner')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-focus-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-boss-rush-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-weekly-goal-card-activeDays')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('study-harmony-weekly-goal-card-dailyClears'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('study-harmony-weekly-goal-card-focusSprint'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('track filter switches to live track content', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
    );
    await tester.pumpAndSettle();

    final jazzChip = find.byKey(
      const ValueKey('study-harmony-track-filter-jazz'),
    );
    await tester.ensureVisible(jazzChip);
    await tester.pumpAndSettle();
    await tester.tap(jazzChip);
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-card-jazz-chapter-notes-keyboard',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-card-core-chapter-notes-keyboard',
        ),
      ),
      findsNothing,
    );
  });

  testWidgets('track filter stays responsive on narrow widths', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 900);
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
            initialSnapshot: StudyHarmonyProgressSnapshot.initial(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final jazzChip = find.byKey(
      const ValueKey('study-harmony-track-filter-jazz'),
    );
    await tester.ensureVisible(jazzChip);
    await tester.pumpAndSettle();
    await tester.tap(jazzChip);
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-card-jazz-chapter-notes-keyboard',
        ),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('study harmony page opens on the last played track', (
    WidgetTester tester,
  ) async {
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
            initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
              lastPlayedTrackId: studyHarmonyJazzTrackId,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-card-jazz-chapter-notes-keyboard',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey(
          'study-harmony-chapter-card-core-chapter-notes-keyboard',
        ),
      ),
      findsNothing,
    );
  });

  testWidgets('daily streak and quest board surface momentum cues', (
    WidgetTester tester,
  ) async {
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
            initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
              completedDailyChallengeDateKeys: {'2026-03-11', '2026-03-12'},
              bestDailyChallengeStreak: 2,
            ),
            nowProvider: () => DateTime(2026, 3, 13),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Streak x2'), findsWidgets);
    expect(find.text('Quest Board'), findsOneWidget);
    expect(find.text('Daily streak'), findsOneWidget);
  });

  testWidgets('chapter card opens lesson sheet and launches a session', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(
        const ValueKey(
          'study-harmony-open-chapter-core-chapter-notes-keyboard',
        ),
      ),
    );
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
    expect(
      find.descendant(
        of: continueCard,
        matching: find.text('Next up: Name the Highlighted Note'),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'review, relay, legend, boss rush, focus, and daily cards open routed session modes',
    (WidgetTester tester) async {
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
          'core-chords-boss-review',
        },
        lessonResults: {
          'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-1-note-keyboard',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
          ),
          'core-notes-2-name-preview': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-2-name-preview',
            isCleared: true,
            bestAccuracy: 0.91,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
          ),
          'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-3-accidentals',
            isCleared: true,
            bestAccuracy: 0.92,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-12T00:00:00.000Z',
          ),
          'core-notes-boss-note-hunt': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-boss-note-hunt',
            isCleared: true,
            bestAccuracy: 0.95,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
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
        find.byKey(const ValueKey('study-harmony-relay-card')),
      );
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('study-harmony-relay-card')),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Arena Relay'), findsWidgets);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('study-harmony-legend-card')),
      );
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('study-harmony-legend-card')),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Legend Trial'), findsWidgets);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('study-harmony-boss-rush-card')),
      );
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('study-harmony-boss-rush-card')),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Boss Rush Mode'), findsWidgets);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('study-harmony-focus-card')),
      );
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('study-harmony-focus-card')),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Focus Mode'), findsWidgets);

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
    },
  );

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

  testWidgets(
    'session page shows prompt playback controls when preview exists',
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
            lesson: _buildPromptPreviewLesson(),
            trackId: studyHarmonyCoreTrackId,
            progressController: StudyHarmonyProgressController(
              initialSnapshot: StudyHarmonyProgressSnapshot.initial(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('study-harmony-play-prompt-button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('study-harmony-play-prompt-arpeggio-button')),
        findsOneWidget,
      );
    },
  );

  test('core course catalog exposes eighteen chapters and lesson counts', () {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());

    expect(course.trackId, studyHarmonyCoreTrackId);
    expect(course.chapters, hasLength(18));
    expect(
      course.chapters.map((chapter) => chapter.lessons.length).toList(),
      equals([4, 4, 4, 5, 4, 3, 3, 4, 4, 3, 3, 4, 4, 4, 4, 4, 4, 4]),
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

  test('alternate track catalogs clone the curriculum with unique ids', () {
    final courses = buildStudyHarmonyTrackCourses(AppLocalizationsEn());
    final coreCourse = courses[studyHarmonyCoreTrackId]!;
    final jazzCourse = courses[studyHarmonyJazzTrackId]!;

    expect(jazzCourse.trackId, studyHarmonyJazzTrackId);
    expect(jazzCourse.id, studyHarmonyJazzCourseId);
    expect(jazzCourse.chapters, hasLength(coreCourse.chapters.length));
    expect(
      jazzCourse.chapters.map((chapter) => chapter.lessons.length).toList(),
      equals(
        coreCourse.chapters.map((chapter) => chapter.lessons.length).toList(),
      ),
    );
    expect(jazzCourse.chapters.first.id, 'jazz-chapter-notes-keyboard');
    expect(jazzCourse.chapters.first.id, isNot(coreCourse.chapters.first.id));
    expect(
      jazzCourse.chapters.first.lessons.first.id,
      'jazz-notes-1-note-keyboard',
    );
    expect(
      jazzCourse.chapters.first.lessons.first.tasks.first.lessonId,
      'jazz-notes-1-note-keyboard',
    );
    expect(
      jazzCourse.chapters[4].lessons.first.id,
      'jazz-progression-1-key-center',
    );
  });

  test('weekly plan targets stay fixed even as progress grows', () {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        activityDateKeys: {
          '2026-03-09',
          '2026-03-10',
          '2026-03-11',
          '2026-03-12',
        },
        completedDailyChallengeDateKeys: {
          '2026-03-09',
          '2026-03-10',
          '2026-03-11',
          '2026-03-12',
        },
        completedFocusChallengeDateKeys: {'2026-03-10', '2026-03-11'},
      ),
      nowProvider: () => DateTime(2026, 3, 13),
    );

    final weeklyGoals = controller.weeklyPlanForCourse(course);

    expect(weeklyGoals, hasLength(3));
    expect(
      weeklyGoals
          .map((goal) => (goal.kind, goal.target))
          .toList(growable: false),
      equals([
        (StudyHarmonyWeeklyGoalKind.activeDays, 3),
        (StudyHarmonyWeeklyGoalKind.dailyClears, 2),
        (StudyHarmonyWeeklyGoalKind.focusSprint, 1),
      ]),
    );
  });

  test('daily clears extend streak and update the best streak', () async {
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        completedDailyChallengeDateKeys: {'2026-03-11', '2026-03-12'},
        bestDailyChallengeStreak: 2,
      ),
      nowProvider: () => DateTime(2026, 3, 13),
    );

    const lesson = StudyHarmonyLessonDefinition(
      id: 'synthetic-daily-test',
      chapterId: studyHarmonyCoreNotesChapterId,
      title: 'Daily Test',
      description: 'Synthetic daily lesson for streak tests.',
      objectiveLabel: 'Daily',
      goalCorrectAnswers: 6,
      startingLives: 4,
      sessionMode: StudyHarmonySessionMode.daily,
      tasks: <StudyHarmonyTaskBlueprint>[],
      skillTags: {'note.read'},
      sessionMetadata: StudyHarmonySessionMetadata(
        anchorLessonId: 'core-notes-1-note-keyboard',
        sourceLessonIds: {'core-notes-1-note-keyboard'},
        focusSkillTags: {'note.read'},
        countsTowardLessonProgress: false,
        dailyDateKey: '2026-03-13',
        dailySeedValue: 42,
      ),
    );

    final effect = await controller.recordSessionResult(
      trackId: studyHarmonyCoreTrackId,
      chapterId: studyHarmonyCoreNotesChapterId,
      lesson: lesson,
      cleared: true,
      attempts: 6,
      accuracy: 1,
      elapsed: const Duration(seconds: 30),
      performance: const StudyHarmonySessionPerformance(
        skillSummaries: {
          'note.read': StudyHarmonySkillSessionSummary(
            skillId: 'note.read',
            attemptCount: 6,
            correctCount: 6,
          ),
        },
      ),
    );

    expect(effect.dailyChallengeCompleted, isTrue);
    expect(effect.dailyStreakCount, 3);
    expect(controller.currentDailyChallengeStreak(), 3);
    expect(controller.bestDailyChallengeStreak(), 3);
  });

  test('best streak normalizes from stored daily keys', () {
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        completedDailyChallengeDateKeys: {
          '2026-03-09',
          '2026-03-10',
          '2026-03-11',
        },
        bestDailyChallengeStreak: 1,
      ),
    );

    expect(controller.bestDailyChallengeStreak(), 3);
  });

  test(
    'continue recommendation advances to the frontier after clearing last played lesson',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          lastPlayedTrackId: studyHarmonyCoreTrackId,
          lastPlayedChapterId: studyHarmonyCoreNotesChapterId,
          lastPlayedLessonId: 'core-notes-1-note-keyboard',
          unlockedChapterIds: {studyHarmonyCoreNotesChapterId},
          unlockedLessonIds: {
            'core-notes-1-note-keyboard',
            'core-notes-2-name-preview',
          },
          lessonResults: {
            'core-notes-1-note-keyboard':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-1-note-keyboard',
                  isCleared: true,
                  bestAccuracy: 0.96,
                  bestAttemptCount: 2,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 15000,
                  playCount: 1,
                  lastPlayedAtIso8601: '2026-03-13T00:00:00.000Z',
                ),
          },
        ),
      );

      await controller.syncCourse(course);
      final recommendation = controller.continueRecommendationForCourse(course);

      expect(recommendation, isNotNull);
      expect(recommendation!.lesson.id, 'core-notes-2-name-preview');
      expect(recommendation.source, StudyHarmonyRecommendationSource.frontier);
    },
  );

  test(
    'boss rush waits until at least two boss lessons are unlocked',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          unlockedChapterIds: {studyHarmonyCoreNotesChapterId},
          unlockedLessonIds: {
            'core-notes-1-note-keyboard',
            'core-notes-2-name-preview',
            'core-notes-3-accidentals',
            'core-notes-boss-note-hunt',
          },
        ),
      );

      await controller.syncCourse(course);

      expect(controller.bossRushRecommendationForCourse(course), isNull);
    },
  );

  test('completed chapters stop surfacing a misleading next lesson', () async {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        unlockedChapterIds: {studyHarmonyCoreNotesChapterId},
        unlockedLessonIds: {
          'core-notes-1-note-keyboard',
          'core-notes-2-name-preview',
          'core-notes-3-accidentals',
          'core-notes-boss-note-hunt',
        },
        lessonResults: {
          'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-1-note-keyboard',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-2-name-preview': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-2-name-preview',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-3-accidentals',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-boss-note-hunt': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-boss-note-hunt',
            isCleared: true,
            bestAccuracy: 0.95,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
        },
      ),
    );

    await controller.syncCourse(course);
    final summary = controller.chapterProgressFor(course.chapters.first);

    expect(summary.isCompleted, isTrue);
    expect(summary.nextLesson, isNull);
    expect(summary.masteryTier, StudyHarmonyChapterMasteryTier.silver);
  });

  test('legend trial crowns the next eligible completed chapter', () async {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
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
          'core-chords-boss-review',
        },
        lessonResults: {
          'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-1-note-keyboard',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-2-name-preview': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-2-name-preview',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-3-accidentals',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-boss-note-hunt': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-boss-note-hunt',
            isCleared: true,
            bestAccuracy: 0.95,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
        },
      ),
    );

    await controller.syncCourse(course);
    final recommendation = controller.legendTrialRecommendationForCourse(
      course,
    );

    expect(recommendation, isNotNull);
    expect(recommendation!.chapter.id, studyHarmonyCoreNotesChapterId);
    expect(recommendation.sessionMode, StudyHarmonySessionMode.legend);

    final sessionLesson = StudyHarmonyLessonDefinition(
      id: 'synthetic-legend-test',
      chapterId: recommendation.chapter.id,
      title: 'Legend Trial',
      description: 'Synthetic legend session for crown tests.',
      objectiveLabel: 'Legend',
      goalCorrectAnswers: 9,
      startingLives: 2,
      sessionMode: StudyHarmonySessionMode.legend,
      tasks: [
        for (final lesson in recommendation.resolvedSourceLessons)
          ...lesson.tasks,
      ],
      skillTags: recommendation.focusSkillTags,
      sessionMetadata: StudyHarmonySessionMetadata(
        anchorLessonId: recommendation.lesson.id,
        sourceLessonIds: {
          for (final lesson in recommendation.resolvedSourceLessons) lesson.id,
        },
        focusSkillTags: recommendation.focusSkillTags,
        countsTowardLessonProgress: false,
      ),
    );

    await controller.recordSessionResult(
      trackId: studyHarmonyCoreTrackId,
      chapterId: sessionLesson.chapterId,
      lesson: sessionLesson,
      cleared: true,
      attempts: 9,
      accuracy: 0.97,
      elapsed: const Duration(seconds: 55),
      performance: const StudyHarmonySessionPerformance(
        skillSummaries: {
          'note.read': StudyHarmonySkillSessionSummary(
            skillId: 'note.read',
            attemptCount: 9,
            correctCount: 9,
          ),
        },
      ),
    );

    expect(
      controller.isChapterLegendary(studyHarmonyCoreNotesChapterId),
      isTrue,
    );
    expect(controller.legendaryChapterCountForCourse(course), 1);
    expect(
      controller.chapterMasteryTierFor(course.chapters.first),
      StudyHarmonyChapterMasteryTier.legendary,
    );
  });

  test(
    'relay recommendation opens after two chapters and counts relay wins',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
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
            'core-chords-2-sevenths-on-keys',
          },
          lessonResults: {
            'core-notes-1-note-keyboard':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-1-note-keyboard',
                  isCleared: true,
                  bestAccuracy: 0.9,
                  bestAttemptCount: 3,
                  bestStars: 2,
                  bestRank: 'A',
                  bestElapsedMillis: 18000,
                  playCount: 1,
                ),
            'core-notes-2-name-preview':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-2-name-preview',
                  isCleared: true,
                  bestAccuracy: 0.9,
                  bestAttemptCount: 3,
                  bestStars: 2,
                  bestRank: 'A',
                  bestElapsedMillis: 18000,
                  playCount: 1,
                ),
            'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
              lessonId: 'core-notes-3-accidentals',
              isCleared: true,
              bestAccuracy: 0.9,
              bestAttemptCount: 3,
              bestStars: 2,
              bestRank: 'A',
              bestElapsedMillis: 18000,
              playCount: 1,
            ),
            'core-notes-boss-note-hunt':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-boss-note-hunt',
                  isCleared: true,
                  bestAccuracy: 0.95,
                  bestAttemptCount: 3,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 18000,
                  playCount: 1,
                ),
          },
          reviewQueuePlaceholders: const [
            StudyHarmonyReviewQueuePlaceholderEntry(
              itemId: 'lesson:core-notes-1-note-keyboard',
              lessonId: 'core-notes-1-note-keyboard',
              reason: 'accuracy-refresh',
              dueAtIso8601: '2026-03-12T12:00:00.000Z',
              priority: 2,
              skillTags: {'note.findKeyboard'},
            ),
          ],
        ),
        nowProvider: () => DateTime(2026, 3, 13),
      );

      await controller.syncCourse(course);
      final recommendation = controller.relayRecommendationForCourse(course);

      expect(recommendation, isNotNull);
      expect(recommendation!.sessionMode, StudyHarmonySessionMode.relay);
      expect(
        recommendation.resolvedSourceLessons
            .map((lesson) => lesson.chapterId)
            .toSet()
            .length,
        greaterThanOrEqualTo(2),
      );

      final sessionLesson = StudyHarmonyLessonDefinition(
        id: 'synthetic-relay-test',
        chapterId: recommendation.chapter.id,
        title: 'Arena Relay',
        description: 'Synthetic relay session for win-count tests.',
        objectiveLabel: 'Relay',
        goalCorrectAnswers: 9,
        startingLives: 3,
        sessionMode: StudyHarmonySessionMode.relay,
        tasks: [
          for (final lesson in recommendation.resolvedSourceLessons)
            ...lesson.tasks,
        ],
        skillTags: recommendation.focusSkillTags,
        sessionMetadata: StudyHarmonySessionMetadata(
          anchorLessonId: recommendation.lesson.id,
          sourceLessonIds: {
            for (final lesson in recommendation.resolvedSourceLessons)
              lesson.id,
          },
          focusSkillTags: recommendation.focusSkillTags,
          countsTowardLessonProgress: false,
        ),
      );

      final effect = await controller.recordSessionResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: sessionLesson.chapterId,
        lesson: sessionLesson,
        cleared: true,
        attempts: 9,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 52),
        performance: const StudyHarmonySessionPerformance(
          skillSummaries: {
            'note.read': StudyHarmonySkillSessionSummary(
              skillId: 'note.read',
              attemptCount: 9,
              correctCount: 9,
            ),
          },
        ),
      );

      expect(controller.relayWinCount(), 1);
      expect(effect.relayWinCount, 1);
      expect(
        controller
            .milestoneBoardForCourse(course)
            .firstWhere(
              (milestone) =>
                  milestone.kind == StudyHarmonyMilestoneKind.relayRunner,
            )
            .earnedCount,
        1,
      );
    },
  );

  test('weekly league XP promotes the player into the next tier', () async {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        weeklyLeagueScores: const {'2026-03-09': 30},
      ),
      nowProvider: () => DateTime(2026, 3, 13),
    );

    await controller.syncCourse(course);
    final lesson = course.chapters.first.lessons.first;

    final effect = await controller.recordLessonResult(
      trackId: studyHarmonyCoreTrackId,
      chapterId: lesson.chapterId,
      lesson: lesson,
      cleared: true,
      attempts: 6,
      accuracy: 0.97,
      elapsed: const Duration(seconds: 24),
    );

    final leagueProgress = controller.currentLeagueProgress();

    expect(effect.weeklyLeagueScoreDelta, 23);
    expect(effect.weeklyLeagueScore, 53);
    expect(effect.promotedLeagueTier, StudyHarmonyLeagueTier.bronze);
    expect(leagueProgress.score, 53);
    expect(leagueProgress.tier, StudyHarmonyLeagueTier.bronze);
    expect(leagueProgress.nextTier, StudyHarmonyLeagueTier.silver);
    expect(leagueProgress.nextTarget, 100);
  });

  test(
    'frontier quest completes when today\'s frontier lesson is cleared',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          completedDailyChallengeDateKeys: {'2026-03-13'},
        ),
        nowProvider: () => DateTime(2026, 3, 13),
      );

      await controller.syncCourse(course);
      final frontierLesson = controller
          .continueRecommendationForCourse(course)!
          .lesson;

      await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: frontierLesson.chapterId,
        lesson: frontierLesson,
        cleared: true,
        attempts: 6,
        accuracy: 0.95,
        elapsed: const Duration(seconds: 24),
      );

      final frontierQuest = controller
          .questBoardForCourse(course)
          .firstWhere(
            (quest) => quest.kind == StudyHarmonyQuestKind.frontierLesson,
          );

      expect(frontierQuest.completedToday, isTrue);
      expect(frontierQuest.current, 1);
      expect(frontierQuest.target, 1);
    },
  );

  test(
    'daily quest chest opens after the last missing quest and awards league xp',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          completedDailyChallengeDateKeys: {'2026-03-13'},
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
            'core-chords-2-sevenths-on-keys',
            'core-chords-3-name-highlighted',
            'core-chords-boss-review',
          },
          lessonResults: {
            'core-notes-1-note-keyboard':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-1-note-keyboard',
                  isCleared: true,
                  bestAccuracy: 0.96,
                  bestAttemptCount: 2,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 15000,
                  playCount: 1,
                ),
            'core-notes-2-name-preview':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-2-name-preview',
                  isCleared: true,
                  bestAccuracy: 0.94,
                  bestAttemptCount: 2,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 15000,
                  playCount: 1,
                ),
            'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
              lessonId: 'core-notes-3-accidentals',
              isCleared: true,
              bestAccuracy: 0.93,
              bestAttemptCount: 2,
              bestStars: 3,
              bestRank: 'A',
              bestElapsedMillis: 15000,
              playCount: 1,
            ),
            'core-notes-boss-note-hunt':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-notes-boss-note-hunt',
                  isCleared: true,
                  bestAccuracy: 0.95,
                  bestAttemptCount: 3,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 18000,
                  playCount: 1,
                ),
            'core-chords-1-triads-on-keys':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-chords-1-triads-on-keys',
                  isCleared: true,
                  bestAccuracy: 0.96,
                  bestAttemptCount: 2,
                  bestStars: 3,
                  bestRank: 'S',
                  bestElapsedMillis: 16000,
                  playCount: 1,
                ),
            'core-chords-2-sevenths-on-keys':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-chords-2-sevenths-on-keys',
                  isCleared: true,
                  bestAccuracy: 0.94,
                  bestAttemptCount: 2,
                  bestStars: 3,
                  bestRank: 'A',
                  bestElapsedMillis: 16000,
                  playCount: 1,
                ),
            'core-chords-3-name-highlighted':
                const StudyHarmonyLessonProgressSummary(
                  lessonId: 'core-chords-3-name-highlighted',
                  isCleared: true,
                  bestAccuracy: 0.91,
                  bestAttemptCount: 2,
                  bestStars: 2,
                  bestRank: 'A',
                  bestElapsedMillis: 16000,
                  playCount: 1,
                ),
          },
        ),
        nowProvider: () => DateTime(2026, 3, 13),
      );

      await controller.syncCourse(course);
      final bossLesson = course.chapters[1].lessons.last;

      final effect = await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: bossLesson.chapterId,
        lesson: bossLesson,
        cleared: true,
        attempts: 9,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 48),
      );

      final chestStatus = controller.questChestStatusForCourse(course);

      expect(effect.dailyQuestChestOpened, isTrue);
      expect(effect.questChestLeagueXpBonus, 12);
      expect(effect.leagueXpBoostUnlocked, isTrue);
      expect(effect.leagueXpBoostChargeCount, 2);
      expect(controller.questChestCount(), 1);
      expect(chestStatus.openedToday, isTrue);
      expect(chestStatus.openedCount, 1);
      expect(controller.currentLeagueProgress().score, 35);
      expect(controller.currentLeagueXpBoost().chargeCount, 2);
    },
  );

  test(
    'active league xp boost doubles one cleared run and consumes a charge',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          activeLeagueXpBoostDateKey: '2026-03-13',
          activeLeagueXpBoostCharges: 2,
        ),
        nowProvider: () => DateTime(2026, 3, 13),
      );

      await controller.syncCourse(course);
      final lesson = course.chapters.first.lessons.first;

      final effect = await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: lesson.chapterId,
        lesson: lesson,
        cleared: true,
        attempts: 3,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 18),
      );

      expect(effect.weeklyLeagueScoreDelta, 23);
      expect(effect.leagueXpBoostAppliedBonus, 23);
      expect(effect.leagueXpBoostChargeCount, 1);
      expect(controller.currentLeagueProgress().score, 46);
      expect(controller.currentLeagueXpBoost().chargeCount, 1);
    },
  );

  test(
    'league xp boost carries across a date change until its charges are spent',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          activeLeagueXpBoostDateKey: '2026-03-13',
          activeLeagueXpBoostCharges: 2,
        ),
        nowProvider: () => DateTime(2026, 3, 14),
      );

      await controller.syncCourse(course);
      expect(controller.currentLeagueXpBoost().chargeCount, 2);

      final lesson = course.chapters.first.lessons.first;
      final effect = await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: lesson.chapterId,
        lesson: lesson,
        cleared: true,
        attempts: 3,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 18),
      );

      expect(effect.leagueXpBoostAppliedBonus, 23);
      expect(effect.leagueXpBoostChargeCount, 1);
      expect(controller.currentLeagueProgress().score, 46);
      expect(controller.currentLeagueXpBoost().chargeCount, 1);
    },
  );

  test(
    'monthly tour reward unlocks after the last spotlight clear of the month',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          activityDateKeys: {
            '2026-03-01',
            '2026-03-03',
            '2026-03-05',
            '2026-03-07',
            '2026-03-09',
            '2026-03-11',
            '2026-03-13',
            '2026-03-15',
          },
          awardedDailyQuestChestDateKeys: {
            '2026-03-02',
            '2026-03-06',
            '2026-03-10',
            '2026-03-14',
          },
          monthlySpotlightClearCounts: {'2026-03': 3},
        ),
        nowProvider: () => DateTime(2026, 3, 15),
      );

      await controller.syncCourse(course);
      final bossLesson = course.chapters.first.lessons.last;

      final effect = await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: bossLesson.chapterId,
        lesson: bossLesson,
        cleared: true,
        attempts: 9,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 45),
      );

      final monthlyTour = controller.monthlyTourProgressForCourse(course);

      expect(effect.monthlyTourRewardUnlocked, isTrue);
      expect(effect.monthlyTourLeagueXpBonus, 18);
      expect(effect.monthlyTourStreakSaverCount, 1);
      expect(controller.currentLeagueProgress().score, 41);
      expect(controller.currentStreakSaverCount(), 1);
      expect(monthlyTour.rewardClaimed, isTrue);
      expect(monthlyTour.completedGoalCount, monthlyTour.totalGoalCount);
    },
  );

  test(
    'duet pact reward unlocks when a third shared streak day is sealed',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          completedDailyChallengeDateKeys: {
            '2026-03-12',
            '2026-03-13',
            '2026-03-14',
          },
          completedSpotlightChallengeDateKeys: {'2026-03-12', '2026-03-13'},
        ),
        nowProvider: () => DateTime(2026, 3, 14),
      );

      await controller.syncCourse(course);
      final bossLesson = course.chapters.first.lessons.last;

      final effect = await controller.recordLessonResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: bossLesson.chapterId,
        lesson: bossLesson,
        cleared: true,
        attempts: 9,
        accuracy: 0.96,
        elapsed: const Duration(seconds: 45),
      );

      final duetPact = controller.duetPactProgress();

      expect(effect.duetPactActiveToday, isTrue);
      expect(effect.duetPactCurrentStreak, 3);
      expect(effect.duetPactRewardUnlocked, isTrue);
      expect(effect.duetPactLeagueXpBonus, 10);
      expect(duetPact.bestStreak, 3);
      expect(
        controller.currentLeagueProgress().score,
        greaterThanOrEqualTo(10),
      );
    },
  );

  test(
    'duet pact preserves its historical best streak after old dates trim away',
    () {
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          completedDailyChallengeDateKeys: {'2025-10-01'},
          completedSpotlightChallengeDateKeys: {'2025-10-01'},
          bestDuetPactStreak: 14,
        ),
        nowProvider: () => DateTime(2026, 3, 14),
      );

      final duetPact = controller.duetPactProgress();

      expect(duetPact.bestStreak, 14);
      expect(duetPact.currentStreak, 0);
      expect(duetPact.activeToday, isFalse);
    },
  );

  test('session results surface newly unlocked milestone medals', () async {
    final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
    final controller = StudyHarmonyProgressController(
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
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
          'core-chords-2-sevenths-on-keys',
        },
        lessonResults: {
          'core-notes-1-note-keyboard': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-1-note-keyboard',
            isCleared: true,
            bestAccuracy: 0.9,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-2-name-preview': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-2-name-preview',
            isCleared: true,
            bestAccuracy: 0.92,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-3-accidentals': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-3-accidentals',
            isCleared: true,
            bestAccuracy: 0.94,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
          'core-notes-boss-note-hunt': const StudyHarmonyLessonProgressSummary(
            lessonId: 'core-notes-boss-note-hunt',
            isCleared: true,
            bestAccuracy: 0.95,
            bestAttemptCount: 3,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 18000,
            playCount: 1,
          ),
        },
      ),
    );

    await controller.syncCourse(course);
    final lesson = course.chapters[1].lessons.first;
    final effect = await controller.recordLessonResult(
      trackId: studyHarmonyCoreTrackId,
      chapterId: lesson.chapterId,
      lesson: lesson,
      cleared: true,
      attempts: 6,
      accuracy: 0.96,
      elapsed: const Duration(seconds: 20),
    );

    expect(effect.newlyUnlockedMilestoneIds, contains('lessonPath-1'));
  });

  test(
    'daily streak saver repairs a one-day gap when the user returns',
    () async {
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          completedDailyChallengeDateKeys: {'2026-03-09'},
          streakSaverCount: 1,
        ),
        nowProvider: () => DateTime(2026, 3, 11),
      );

      const lesson = StudyHarmonyLessonDefinition(
        id: 'synthetic-daily-repair',
        chapterId: studyHarmonyCoreNotesChapterId,
        title: 'Daily Repair',
        description: 'Synthetic daily repair lesson.',
        objectiveLabel: 'Daily',
        goalCorrectAnswers: 6,
        startingLives: 4,
        sessionMode: StudyHarmonySessionMode.daily,
        tasks: <StudyHarmonyTaskBlueprint>[],
        skillTags: {'note.read'},
        sessionMetadata: StudyHarmonySessionMetadata(
          anchorLessonId: 'core-notes-1-note-keyboard',
          sourceLessonIds: {'core-notes-1-note-keyboard'},
          focusSkillTags: {'note.read'},
          countsTowardLessonProgress: false,
          dailyDateKey: '2026-03-11',
          dailySeedValue: 7,
        ),
      );

      final effect = await controller.recordSessionResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: studyHarmonyCoreNotesChapterId,
        lesson: lesson,
        cleared: true,
        attempts: 6,
        accuracy: 0.93,
        elapsed: const Duration(seconds: 40),
        performance: const StudyHarmonySessionPerformance(
          skillSummaries: {
            'note.read': StudyHarmonySkillSessionSummary(
              skillId: 'note.read',
              attemptCount: 6,
              correctCount: 6,
            ),
          },
        ),
      );

      expect(effect.streakSaverUsed, isTrue);
      expect(controller.currentDailyChallengeStreak(), 3);
      expect(controller.currentStreakSaverCount(), 0);
    },
  );

  test(
    'weekly plan awards a streak saver after the focus sprint closes the set',
    () async {
      final course = buildStudyHarmonyCoreCourse(AppLocalizationsEn());
      final controller = StudyHarmonyProgressController(
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          activityDateKeys: {'2026-03-09', '2026-03-10'},
          completedDailyChallengeDateKeys: {'2026-03-09', '2026-03-10'},
        ),
        nowProvider: () => DateTime(2026, 3, 11),
      );

      await controller.syncCourse(course);
      final recommendation = controller.focusSprintRecommendationForCourse(
        course,
      );

      expect(recommendation, isNotNull);

      final sessionLesson = StudyHarmonyLessonDefinition(
        id: 'synthetic-focus-test',
        chapterId: recommendation!.chapter.id,
        title: 'Focus Sprint',
        description: 'Synthetic focus session for weekly reward tests.',
        objectiveLabel: 'Focus',
        goalCorrectAnswers: 7,
        startingLives: 2,
        sessionMode: StudyHarmonySessionMode.focus,
        tasks: [
          for (final lesson in recommendation.resolvedSourceLessons)
            ...lesson.tasks,
        ],
        skillTags: recommendation.focusSkillTags,
        sessionMetadata: StudyHarmonySessionMetadata(
          anchorLessonId: recommendation.lesson.id,
          sourceLessonIds: {
            for (final lesson in recommendation.resolvedSourceLessons)
              lesson.id,
          },
          focusSkillTags: recommendation.focusSkillTags,
          countsTowardLessonProgress: false,
          reviewReason: recommendation.reviewReason,
        ),
      );

      final effect = await controller.recordSessionResult(
        trackId: studyHarmonyCoreTrackId,
        chapterId: sessionLesson.chapterId,
        lesson: sessionLesson,
        cleared: true,
        attempts: 7,
        accuracy: 0.94,
        elapsed: const Duration(seconds: 50),
        performance: const StudyHarmonySessionPerformance(
          skillSummaries: {
            'note.read': StudyHarmonySkillSessionSummary(
              skillId: 'note.read',
              attemptCount: 7,
              correctCount: 7,
            ),
          },
        ),
      );

      expect(effect.focusSprintCompleted, isTrue);
      expect(effect.weeklyRewardUnlocked, isTrue);
      expect(controller.currentStreakSaverCount(), 1);
    },
  );

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
    expect(find.text('Session reward'), findsOneWidget);
    expect(find.text('Rank S'), findsOneWidget);
    expect(find.text('3 stars'), findsOneWidget);
    expect(find.text('Bonus goals'), findsWidgets);
    expect(find.text('Keep all hearts'), findsWidgets);
    expect(
      find.byKey(const ValueKey('study-harmony-retry-button')),
      findsOneWidget,
    );
  });
}
