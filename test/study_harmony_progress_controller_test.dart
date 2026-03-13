import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/study_harmony/application/study_harmony_progress_controller.dart';
import 'package:sightchord/study_harmony/data/study_harmony_progress_store.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_session_models.dart';

void main() {
  test(
    'continueRecommendationForCourse prefers the last played lesson',
    () async {
      final store = _MemoryProgressStore();
      final controller = StudyHarmonyProgressController(
        store: store,
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          lastPlayedTrackId: 'track-1',
          lastPlayedChapterId: 'chapter-1',
          lastPlayedLessonId: 'lesson-2',
          unlockedChapterIds: {'chapter-1'},
          unlockedLessonIds: {'lesson-1', 'lesson-2'},
        ),
        nowProvider: () => DateTime(2026, 3, 13),
      );
      final course = _buildCourse();

      await controller.syncCourse(course);
      final recommendation = controller.continueRecommendationForCourse(course);

      expect(recommendation, isNotNull);
      expect(recommendation!.lesson.id, 'lesson-2');
      expect(
        recommendation.source,
        StudyHarmonyRecommendationSource.lastPlayed,
      );
      expect(recommendation.sessionMode, StudyHarmonySessionMode.lesson);
    },
  );

  test('reviewRecommendationForCourse prefers queued review items', () async {
    final store = _MemoryProgressStore();
    final controller = StudyHarmonyProgressController(
      store: store,
      initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
        unlockedChapterIds: {'chapter-1'},
        unlockedLessonIds: {'lesson-1', 'lesson-2'},
        lessonResults: {
          'lesson-1': const StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-1',
            isCleared: true,
            bestAccuracy: 0.4,
            bestAttemptCount: 3,
            bestStars: 1,
            bestRank: 'C',
            bestElapsedMillis: 1000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-10T00:00:00.000Z',
          ),
        },
        reviewQueuePlaceholders: const [
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:lesson-2',
            lessonId: 'lesson-2',
            reason: 'retry-needed',
            dueAtIso8601: '2026-03-12T00:00:00.000Z',
            priority: 2,
            skillTags: {'chord.symbolToKeys'},
          ),
        ],
      ),
      nowProvider: () => DateTime(2026, 3, 13),
    );
    final course = _buildCourse();

    await controller.syncCourse(course);
    final recommendation = controller.reviewRecommendationForCourse(course);

    expect(recommendation, isNotNull);
    expect(recommendation!.lesson.id, 'lesson-2');
    expect(recommendation.source, StudyHarmonyRecommendationSource.reviewQueue);
    expect(recommendation.sessionMode, StudyHarmonySessionMode.review);
    expect(recommendation.focusSkillTags, contains('chord.symbolToKeys'));
  });

  test(
    'recordSessionResult updates mastery, review queue, and skips synthetic lesson completion',
    () async {
      final store = _MemoryProgressStore();
      final controller = StudyHarmonyProgressController(
        store: store,
        initialSnapshot: StudyHarmonyProgressSnapshot.initial().copyWith(
          unlockedChapterIds: {'chapter-1'},
          unlockedLessonIds: {'lesson-1', 'lesson-2'},
          skillMasteryPlaceholders: const {
            'note.read': StudyHarmonySkillMasteryPlaceholder(
              skillId: 'note.read',
              masteryScore: 0.45,
              exposureCount: 1,
              correctSessionCount: 0,
              recentAttemptScores: [0.5],
              recentAccuracy: 0.5,
              confidenceStreak: 0,
              lastSeenAtIso8601: '2026-03-10T00:00:00.000Z',
            ),
          },
        ),
        nowProvider: () => DateTime(2026, 3, 13, 9),
      );
      final course = _buildCourse();
      await controller.syncCourse(course);

      final reviewLesson = StudyHarmonyLessonDefinition(
        id: 'synthetic-review',
        chapterId: 'chapter-1',
        title: 'Review',
        description: 'Review session',
        objectiveLabel: 'Review',
        goalCorrectAnswers: 5,
        startingLives: 3,
        sessionMode: StudyHarmonySessionMode.review,
        tasks: const <StudyHarmonyTaskBlueprint>[],
        skillTags: const {'note.read', 'chord.symbolToKeys'},
        sessionMetadata: const StudyHarmonySessionMetadata(
          anchorLessonId: 'lesson-1',
          sourceLessonIds: {'lesson-1', 'lesson-2'},
          focusSkillTags: {'note.read', 'chord.symbolToKeys'},
          countsTowardLessonProgress: false,
          reviewReason: 'weak-spot',
        ),
      );

      final effect = await controller.recordSessionResult(
        trackId: 'track-1',
        chapterId: 'chapter-1',
        lesson: reviewLesson,
        cleared: true,
        attempts: 5,
        accuracy: 0.8,
        elapsed: const Duration(seconds: 20),
        performance: const StudyHarmonySessionPerformance(
          skillSummaries: {
            'note.read': StudyHarmonySkillSessionSummary(
              skillId: 'note.read',
              attemptCount: 3,
              correctCount: 2,
            ),
            'chord.symbolToKeys': StudyHarmonySkillSessionSummary(
              skillId: 'chord.symbolToKeys',
              attemptCount: 2,
              correctCount: 2,
            ),
          },
          lessonSummaries: {
            'lesson-1': StudyHarmonyLessonSessionSummary(
              lessonId: 'lesson-1',
              attemptCount: 3,
              correctCount: 2,
            ),
            'lesson-2': StudyHarmonyLessonSessionSummary(
              lessonId: 'lesson-2',
              attemptCount: 2,
              correctCount: 2,
            ),
          },
        ),
      );

      expect(effect.mode, StudyHarmonySessionMode.review);
      expect(effect.reviewReason, 'weak-spot');
      expect(
        effect.focusSkillTags,
        containsAll({'note.read', 'chord.symbolToKeys'}),
      );
      expect(
        controller.skillMasteryFor('note.read')?.masteryScore,
        greaterThan(0.45),
      );
      expect(
        controller.skillMasteryFor('chord.symbolToKeys')?.recentAttemptCount,
        1,
      );
      expect(controller.lessonResultFor('synthetic-review'), isNull);
      expect(
        controller.snapshot.reviewQueuePlaceholders.map(
          (entry) => entry.lessonId,
        ),
        contains('lesson-1'),
      );
    },
  );

  test(
    'daily recommendation is deterministic for the same local date',
    () async {
      final snapshot = StudyHarmonyProgressSnapshot.initial().copyWith(
        unlockedChapterIds: {'chapter-1', 'chapter-2'},
        unlockedLessonIds: {'lesson-1', 'lesson-2', 'lesson-3'},
        lessonResults: {
          'lesson-1': const StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-1',
            isCleared: true,
            bestAccuracy: 0.95,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 8000,
            playCount: 1,
            lastPlayedAtIso8601: '2026-03-10T00:00:00.000Z',
          ),
        },
        reviewQueuePlaceholders: const [
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:lesson-2',
            lessonId: 'lesson-2',
            reason: 'retry-needed',
            dueAtIso8601: '2026-03-12T00:00:00.000Z',
            priority: 3,
            skillTags: {'chord.symbolToKeys'},
          ),
        ],
      );
      final course = _buildCourse();
      final controllerA = StudyHarmonyProgressController(
        store: _MemoryProgressStore(),
        initialSnapshot: snapshot,
        nowProvider: () => DateTime(2026, 3, 13),
      );
      final controllerB = StudyHarmonyProgressController(
        store: _MemoryProgressStore(),
        initialSnapshot: snapshot,
        nowProvider: () => DateTime(2026, 3, 13),
      );

      await controllerA.syncCourse(course);
      await controllerB.syncCourse(course);

      final recommendationA = controllerA.dailyChallengeRecommendationForCourse(
        course,
      );
      final recommendationB = controllerB.dailyChallengeRecommendationForCourse(
        course,
      );

      expect(recommendationA, isNotNull);
      expect(recommendationB, isNotNull);
      expect(recommendationA!.sessionMode, StudyHarmonySessionMode.daily);
      expect(recommendationA.seedValue, recommendationB!.seedValue);
      expect(recommendationA.dailyDateKey, '2026-03-13');
      expect(
        recommendationA.resolvedSourceLessons
            .map((lesson) => lesson.id)
            .toList(),
        recommendationB.resolvedSourceLessons
            .map((lesson) => lesson.id)
            .toList(),
      );
      expect(
        recommendationA.resolvedSourceLessons.map((lesson) => lesson.id),
        containsAll(const ['lesson-2', 'lesson-3']),
      );
    },
  );

  test(
    'recordLessonResult stores completion and unlocks the next lesson',
    () async {
      final store = _MemoryProgressStore();
      final controller = StudyHarmonyProgressController(
        store: store,
        nowProvider: () => DateTime(2026, 3, 13),
      );
      final course = _buildCourse();

      await controller.syncCourse(course);
      await controller.recordLessonResult(
        trackId: 'track-1',
        chapterId: 'chapter-1',
        lesson: course.chapters.first.lessons.first,
        cleared: true,
        attempts: 2,
        accuracy: 0.9,
        elapsed: const Duration(seconds: 30),
      );

      expect(controller.lastPlayedLessonId, 'lesson-1');
      expect(controller.isLessonCleared('lesson-1'), isTrue);
      expect(controller.isLessonUnlocked('lesson-2'), isTrue);
      expect(controller.lessonResultFor('lesson-1')?.bestRank, 'A');
      expect(
        controller
            .snapshot
            .skillMasteryPlaceholders['note.read']
            ?.exposureCount,
        2,
      );
      expect(store.savedSnapshots, isNotEmpty);
    },
  );
}

StudyHarmonyCourseDefinition _buildCourse() {
  return StudyHarmonyCourseDefinition(
    id: 'course-1',
    trackId: 'track-1',
    title: 'Course',
    description: 'Progress course',
    chapters: [
      StudyHarmonyChapterDefinition(
        id: 'chapter-1',
        courseId: 'course-1',
        title: 'Chapter 1',
        description: 'Chapter one',
        lessons: [
          _buildLesson(id: 'lesson-1', skillTags: const {'note.read'}),
          _buildLesson(id: 'lesson-2', skillTags: const {'chord.symbolToKeys'}),
        ],
      ),
      StudyHarmonyChapterDefinition(
        id: 'chapter-2',
        courseId: 'course-1',
        title: 'Chapter 2',
        description: 'Chapter two',
        lessons: [
          _buildLesson(id: 'lesson-3', skillTags: const {'scale.build'}),
        ],
      ),
    ],
  );
}

StudyHarmonyLessonDefinition _buildLesson({
  required String id,
  required Set<StudyHarmonySkillTag> skillTags,
}) {
  final chapterId = id == 'lesson-3' ? 'chapter-2' : 'chapter-1';
  return StudyHarmonyLessonDefinition(
    id: id,
    chapterId: chapterId,
    title: 'Lesson $id',
    description: 'Lesson description',
    objectiveLabel: 'Clear the lesson',
    goalCorrectAnswers: 1,
    startingLives: 2,
    sessionMode: StudyHarmonySessionMode.lesson,
    tasks: const <StudyHarmonyTaskBlueprint>[],
    skillTags: skillTags,
  );
}

class _MemoryProgressStore implements StudyHarmonyProgressStore {
  StudyHarmonyProgressSnapshot snapshot =
      StudyHarmonyProgressSnapshot.initial();
  final List<StudyHarmonyProgressSnapshot> savedSnapshots =
      <StudyHarmonyProgressSnapshot>[];

  @override
  Future<StudyHarmonyProgressSnapshot> load({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) async {
    return snapshot;
  }

  @override
  Future<void> save(StudyHarmonyProgressSnapshot snapshot) async {
    this.snapshot = snapshot;
    savedSnapshots.add(snapshot);
  }
}
