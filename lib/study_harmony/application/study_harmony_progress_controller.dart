import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/study_harmony_progress_store.dart';
import '../domain/study_harmony_progress_models.dart';
import '../domain/study_harmony_session_models.dart';

typedef StudyHarmonyNowProvider = DateTime Function();

enum StudyHarmonyRecommendationSource {
  lastPlayed,
  frontier,
  reviewQueue,
  weakSpot,
  dailySeed,
}

@immutable
class StudyHarmonySkillGainSummary {
  const StudyHarmonySkillGainSummary({
    required this.skillId,
    required this.beforeScore,
    required this.afterScore,
    required this.delta,
    required this.recentAccuracy,
  });

  final StudyHarmonySkillTag skillId;
  final double beforeScore;
  final double afterScore;
  final double delta;
  final double recentAccuracy;
}

@immutable
class StudyHarmonySessionProgressEffect {
  const StudyHarmonySessionProgressEffect({
    required this.mode,
    this.skillGains = const <StudyHarmonySkillGainSummary>[],
    this.focusSkillTags = const <StudyHarmonySkillTag>{},
    this.reviewReason,
    this.dailyDateKey,
  });

  final StudyHarmonySessionMode mode;
  final List<StudyHarmonySkillGainSummary> skillGains;
  final Set<StudyHarmonySkillTag> focusSkillTags;
  final String? reviewReason;
  final String? dailyDateKey;
}

@immutable
class StudyHarmonyLessonRecommendation {
  const StudyHarmonyLessonRecommendation({
    required this.lesson,
    required this.chapter,
    required this.source,
    this.sessionMode = StudyHarmonySessionMode.lesson,
    this.sourceLessons = const <StudyHarmonyLessonDefinition>[],
    this.focusSkillTags = const <StudyHarmonySkillTag>{},
    this.reviewEntry,
    this.reviewReason,
    this.dailyDateKey,
    this.seedValue,
  });

  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonyChapterDefinition chapter;
  final StudyHarmonyRecommendationSource source;
  final StudyHarmonySessionMode sessionMode;
  final List<StudyHarmonyLessonDefinition> sourceLessons;
  final Set<StudyHarmonySkillTag> focusSkillTags;
  final StudyHarmonyReviewQueuePlaceholderEntry? reviewEntry;
  final String? reviewReason;
  final String? dailyDateKey;
  final int? seedValue;

  List<StudyHarmonyLessonDefinition> get resolvedSourceLessons =>
      sourceLessons.isEmpty
      ? <StudyHarmonyLessonDefinition>[lesson]
      : sourceLessons;
}

@immutable
class StudyHarmonyChapterProgressSummaryView {
  const StudyHarmonyChapterProgressSummaryView({
    required this.chapter,
    required this.lessonCount,
    required this.clearedLessonCount,
    required this.unlocked,
    this.nextLesson,
  });

  final StudyHarmonyChapterDefinition chapter;
  final int lessonCount;
  final int clearedLessonCount;
  final bool unlocked;
  final StudyHarmonyLessonDefinition? nextLesson;

  bool get isCompleted => lessonCount > 0 && clearedLessonCount >= lessonCount;

  double get progressFraction =>
      lessonCount == 0 ? 0 : clearedLessonCount / lessonCount;
}

class StudyHarmonyProgressController extends ChangeNotifier {
  StudyHarmonyProgressController({
    StudyHarmonyProgressStore? store,
    StudyHarmonyProgressSnapshot? initialSnapshot,
    StudyHarmonyNowProvider? nowProvider,
  }) : _store = store ?? const SharedPrefsStudyHarmonyProgressStore(),
       _snapshot = initialSnapshot ?? StudyHarmonyProgressSnapshot.initial(),
       _nowProvider = nowProvider ?? _defaultNowProvider;

  final StudyHarmonyProgressStore _store;
  final StudyHarmonyNowProvider _nowProvider;

  final Map<StudyHarmonyCourseId, StudyHarmonyCourseDefinition> _coursesById =
      <StudyHarmonyCourseId, StudyHarmonyCourseDefinition>{};

  StudyHarmonyProgressSnapshot _snapshot;
  Future<void> _saveQueue = Future<void>.value();
  StudyHarmonyProgressSnapshot? _pendingSaveSnapshot;

  StudyHarmonyProgressSnapshot get snapshot => _snapshot;
  StudyHarmonyLessonId? get lastPlayedLessonId => _snapshot.lastPlayedLessonId;
  StudyHarmonyChapterId? get lastPlayedChapterId =>
      _snapshot.lastPlayedChapterId;
  StudyHarmonyTrackId? get lastPlayedTrackId => _snapshot.lastPlayedTrackId;

  Future<void> load() async {
    _snapshot = await _store.load(fallbackSnapshot: _snapshot);
    notifyListeners();
  }

  Future<void> syncCourse(StudyHarmonyCourseDefinition course) async {
    _coursesById[course.id] = course;
    final normalized = _applyUnlockRules(_snapshot, course);
    await _updateSnapshotIfChanged(normalized);
  }

  Future<void> markLessonStarted({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonId lessonId,
  }) async {
    final next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: chapterId,
      lastPlayedLessonId: lessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, lessonId},
    );
    await _updateSnapshotIfChanged(_applyUnlockRulesToRegisteredCourses(next));
  }

  Future<void> markSessionStarted({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyLessonDefinition lesson,
  }) async {
    final effectiveLessonId = _effectiveAnchorLessonId(lesson);
    final next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: lesson.chapterId,
      lastPlayedLessonId: effectiveLessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, lesson.chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, effectiveLessonId},
      dailyChallengeSeedMetadata: _mergeDailyMetadataFromLesson(lesson),
    );
    await _updateSnapshotIfChanged(_applyUnlockRulesToRegisteredCourses(next));
  }

  Future<StudyHarmonySessionProgressEffect> recordLessonResult({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
  }) {
    return recordSessionResult(
      trackId: trackId,
      chapterId: chapterId,
      lesson: lesson,
      cleared: cleared,
      attempts: attempts,
      accuracy: accuracy,
      elapsed: elapsed,
      performance: _defaultSessionPerformance(
        lesson: lesson,
        attempts: attempts,
        accuracy: accuracy,
      ),
    );
  }

  Future<StudyHarmonySessionProgressEffect> recordSessionResult({
    required StudyHarmonyTrackId trackId,
    required StudyHarmonyChapterId chapterId,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
    required StudyHarmonySessionPerformance performance,
  }) async {
    final now = _nowProvider().toUtc();
    final effectiveLessonId = _effectiveAnchorLessonId(lesson);
    final effectivePerformance = performance.isEmpty
        ? _defaultSessionPerformance(
            lesson: lesson,
            attempts: attempts,
            accuracy: accuracy,
          )
        : performance;
    final lessonSummaries = _normalizedLessonSummaries(
      lesson: lesson,
      performance: effectivePerformance,
      attempts: attempts,
      accuracy: accuracy,
    );
    final skillSummaries = _normalizedSkillSummaries(
      lesson: lesson,
      performance: effectivePerformance,
      attempts: attempts,
      accuracy: accuracy,
    );

    final beforeSkillScores = <StudyHarmonySkillTag, double>{
      for (final skillId in skillSummaries.keys)
        skillId:
            _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore ?? 0.45,
    };

    final nextLessonResults =
        Map<StudyHarmonyLessonId, StudyHarmonyLessonProgressSummary>.from(
          _snapshot.lessonResults,
        );
    if (lesson.sessionMetadata.countsTowardLessonProgress) {
      nextLessonResults[effectiveLessonId] = _mergeLessonResult(
        existing: _snapshot.lessonResults[effectiveLessonId],
        lesson: lesson,
        cleared: cleared,
        attempts: attempts,
        accuracy: accuracy,
        elapsed: elapsed,
        playedAt: now,
      );
    }

    final nextSkillMastery = _mergeSkillMasteryPlaceholders(
      skillSummaries: skillSummaries,
      updatedAt: now,
    );
    final nextReviewQueue = _mergeReviewQueuePlaceholders(
      lessonSummaries: lessonSummaries,
      sessionLesson: lesson,
      updatedAt: now,
    );

    var next = _snapshot.copyWith(
      lastPlayedTrackId: trackId,
      lastPlayedChapterId: chapterId,
      lastPlayedLessonId: effectiveLessonId,
      unlockedChapterIds: {..._snapshot.unlockedChapterIds, chapterId},
      unlockedLessonIds: {..._snapshot.unlockedLessonIds, effectiveLessonId},
      lessonResults: nextLessonResults,
      skillMasteryPlaceholders: nextSkillMastery,
      reviewQueuePlaceholders: nextReviewQueue,
      dailyChallengeSeedMetadata: _mergeDailyMetadataFromLesson(lesson),
    );
    next = _applyUnlockRulesToRegisteredCourses(next);
    await _updateSnapshotIfChanged(next);

    final skillGains =
        skillSummaries.keys
            .map((skillId) {
              final after = next.skillMasteryPlaceholders[skillId];
              if (after == null) {
                return null;
              }
              final beforeScore = beforeSkillScores[skillId] ?? 0;
              return StudyHarmonySkillGainSummary(
                skillId: skillId,
                beforeScore: beforeScore,
                afterScore: after.masteryScore,
                delta: after.masteryScore - beforeScore,
                recentAccuracy: after.recentAccuracy,
              );
            })
            .whereType<StudyHarmonySkillGainSummary>()
            .toList(growable: false)
          ..sort((left, right) => right.delta.compareTo(left.delta));

    return StudyHarmonySessionProgressEffect(
      mode: lesson.sessionMode,
      skillGains: skillGains,
      focusSkillTags: lesson.sessionMetadata.focusSkillTags.isEmpty
          ? skillSummaries.keys.toSet()
          : lesson.sessionMetadata.focusSkillTags,
      reviewReason: lesson.sessionMetadata.reviewReason,
      dailyDateKey: lesson.sessionMetadata.dailyDateKey,
    );
  }

  bool isLessonUnlocked(StudyHarmonyLessonId lessonId) {
    return _snapshot.unlockedLessonIds.contains(lessonId);
  }

  bool isChapterUnlocked(StudyHarmonyChapterId chapterId) {
    return _snapshot.unlockedChapterIds.contains(chapterId);
  }

  bool isLessonCleared(StudyHarmonyLessonId lessonId) {
    return _snapshot.lessonResults[lessonId]?.isCleared ?? false;
  }

  StudyHarmonyLessonProgressSummary? lessonResultFor(
    StudyHarmonyLessonId lessonId,
  ) {
    return _snapshot.lessonResults[lessonId];
  }

  StudyHarmonySkillMasteryPlaceholder? skillMasteryFor(
    StudyHarmonySkillTag skillId,
  ) {
    return _snapshot.skillMasteryPlaceholders[skillId];
  }

  StudyHarmonyChapterProgressSummaryView chapterProgressFor(
    StudyHarmonyChapterDefinition chapter,
  ) {
    final clearedLessonCount = chapter.lessons
        .where((lesson) => isLessonCleared(lesson.id))
        .length;
    final unlocked =
        isChapterUnlocked(chapter.id) ||
        chapter.lessons.any((lesson) => isLessonUnlocked(lesson.id));
    final nextLesson = chapter.lessons.firstWhere(
      (lesson) => isLessonUnlocked(lesson.id) && !isLessonCleared(lesson.id),
      orElse: () => chapter.lessons.firstWhere(
        (lesson) => isLessonUnlocked(lesson.id),
        orElse: () => chapter.lessons.first,
      ),
    );

    return StudyHarmonyChapterProgressSummaryView(
      chapter: chapter,
      lessonCount: chapter.lessons.length,
      clearedLessonCount: clearedLessonCount,
      unlocked: unlocked,
      nextLesson: unlocked ? nextLesson : null,
    );
  }

  StudyHarmonyLessonRecommendation? continueRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final lastPlayedLesson = lastPlayedTrackId == course.trackId
        ? _lessonForId(course, lastPlayedLessonId)
        : null;
    if (lastPlayedLesson != null &&
        _isLessonAccessible(course, lastPlayedLesson)) {
      return _recommendationForLesson(
        course: course,
        lesson: lastPlayedLesson,
        source: StudyHarmonyRecommendationSource.lastPlayed,
        focusSkillTags: lastPlayedLesson.skillTags,
      );
    }

    final frontierLesson =
        _frontierLessonForCourse(course) ?? _fallbackLesson(course);
    return _recommendationForLesson(
      course: course,
      lesson: frontierLesson,
      source: StudyHarmonyRecommendationSource.frontier,
      focusSkillTags: frontierLesson.skillTags,
    );
  }

  StudyHarmonyLessonRecommendation? reviewRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final rankedCandidates = _rankReviewCandidates(course);
    if (rankedCandidates.isEmpty) {
      final fallback = continueRecommendationForCourse(course);
      if (fallback == null) {
        return null;
      }
      return StudyHarmonyLessonRecommendation(
        lesson: fallback.lesson,
        chapter: fallback.chapter,
        source: fallback.source,
        sessionMode: StudyHarmonySessionMode.review,
        sourceLessons: <StudyHarmonyLessonDefinition>[fallback.lesson],
        focusSkillTags: fallback.focusSkillTags,
        reviewReason: 'frontier-refresh',
      );
    }

    final strongest = rankedCandidates.first;
    final sourceLessons = <StudyHarmonyLessonDefinition>[];
    final threshold = strongest.score * 0.6;
    for (final candidate in rankedCandidates) {
      if (candidate.score < threshold && sourceLessons.length >= 2) {
        break;
      }
      if (sourceLessons.any((lesson) => lesson.id == candidate.lesson.id)) {
        continue;
      }
      sourceLessons.add(candidate.lesson);
      if (sourceLessons.length >= 3) {
        break;
      }
    }

    return _recommendationForLesson(
      course: course,
      lesson: strongest.lesson,
      source: strongest.entry != null
          ? StudyHarmonyRecommendationSource.reviewQueue
          : StudyHarmonyRecommendationSource.weakSpot,
      sessionMode: StudyHarmonySessionMode.review,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      reviewEntry: strongest.entry,
      reviewReason: strongest.reason,
    );
  }

  StudyHarmonyLessonRecommendation? dailyChallengeRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    final unlockedLessons = _orderedLessons(course)
        .where((lesson) => _isLessonAccessible(course, lesson))
        .toList(growable: false);
    if (unlockedLessons.isEmpty) {
      return null;
    }

    final dateKey = _dailyDateKey(_nowProvider());
    final metadata = _snapshot.dailyChallengeSeedMetadata;
    if (metadata != null &&
        metadata.dateKey == dateKey &&
        metadata.trackId == course.trackId) {
      final storedLesson = _lessonForId(course, metadata.lessonId);
      final storedSourceLessons = metadata.sourceLessonIds
          .map((lessonId) => _lessonForId(course, lessonId))
          .whereType<StudyHarmonyLessonDefinition>()
          .where((lesson) => _isLessonAccessible(course, lesson))
          .toList(growable: false);
      if (storedLesson != null && _isLessonAccessible(course, storedLesson)) {
        final sourceLessons = storedSourceLessons.isEmpty
            ? <StudyHarmonyLessonDefinition>[storedLesson]
            : storedSourceLessons;
        return _recommendationForLesson(
          course: course,
          lesson: storedLesson,
          source: StudyHarmonyRecommendationSource.dailySeed,
          sessionMode: StudyHarmonySessionMode.daily,
          sourceLessons: sourceLessons,
          focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
          dailyDateKey: dateKey,
          seedValue: metadata.seedValue,
        );
      }
    }

    final seedValue = _dailySeedValue(course, dateKey);
    final sourceLessons = _buildDailySourceLessons(course, seedValue);
    if (sourceLessons.isEmpty) {
      return null;
    }
    return _recommendationForLesson(
      course: course,
      lesson: sourceLessons.first,
      source: StudyHarmonyRecommendationSource.dailySeed,
      sessionMode: StudyHarmonySessionMode.daily,
      sourceLessons: sourceLessons,
      focusSkillTags: _focusSkillTagsForLessons(sourceLessons),
      dailyDateKey: dateKey,
      seedValue: seedValue,
    );
  }

  Future<StudyHarmonyLessonRecommendation?>
  prepareDailyChallengeRecommendationForCourse(
    StudyHarmonyCourseDefinition course,
  ) async {
    final recommendation = dailyChallengeRecommendationForCourse(course);
    if (recommendation == null || recommendation.dailyDateKey == null) {
      return recommendation;
    }

    final metadata = StudyHarmonyDailyChallengeSeedMetadata(
      version: 1,
      dateKey: recommendation.dailyDateKey!,
      seedValue:
          recommendation.seedValue ??
          _dailySeedValue(course, recommendation.dailyDateKey!),
      trackId: course.trackId,
      chapterId: recommendation.chapter.id,
      lessonId: recommendation.lesson.id,
      sourceLessonIds: [
        for (final lesson in recommendation.resolvedSourceLessons) lesson.id,
      ],
    );
    await _updateSnapshotIfChanged(
      _snapshot.copyWith(dailyChallengeSeedMetadata: metadata),
    );
    return recommendation;
  }

  Future<void> _updateSnapshotIfChanged(
    StudyHarmonyProgressSnapshot nextSnapshot,
  ) async {
    if (_snapshot.encode() == nextSnapshot.encode()) {
      return;
    }

    _snapshot = nextSnapshot;
    notifyListeners();

    _pendingSaveSnapshot = nextSnapshot;
    _saveQueue = _saveQueue.catchError((_) {}).then((_) async {
      final snapshotToSave = _pendingSaveSnapshot;
      if (snapshotToSave == null) {
        return;
      }
      _pendingSaveSnapshot = null;
      await _store.save(snapshotToSave);
    });
    await _saveQueue;
  }

  StudyHarmonyProgressSnapshot _applyUnlockRulesToRegisteredCourses(
    StudyHarmonyProgressSnapshot snapshot,
  ) {
    var normalized = snapshot;
    for (final course in _coursesById.values) {
      normalized = _applyUnlockRules(normalized, course);
    }
    return normalized;
  }

  StudyHarmonyProgressSnapshot _applyUnlockRules(
    StudyHarmonyProgressSnapshot snapshot,
    StudyHarmonyCourseDefinition course,
  ) {
    final unlockedChapterIds = Set<StudyHarmonyChapterId>.from(
      snapshot.unlockedChapterIds,
    );
    final unlockedLessonIds = Set<StudyHarmonyLessonId>.from(
      snapshot.unlockedLessonIds,
    );

    if (course.chapters.isNotEmpty) {
      final firstChapter = course.chapters.first;
      unlockedChapterIds.add(firstChapter.id);
      if (firstChapter.lessons.isNotEmpty) {
        unlockedLessonIds.add(firstChapter.lessons.first.id);
      }
    }

    for (
      var chapterIndex = 0;
      chapterIndex < course.chapters.length;
      chapterIndex += 1
    ) {
      final chapter = course.chapters[chapterIndex];
      for (
        var lessonIndex = 0;
        lessonIndex < chapter.lessons.length;
        lessonIndex += 1
      ) {
        final lesson = chapter.lessons[lessonIndex];
        final lessonResult = snapshot.lessonResults[lesson.id];
        if (lessonResult?.isCleared != true) {
          continue;
        }

        if (lessonIndex + 1 < chapter.lessons.length) {
          unlockedLessonIds.add(chapter.lessons[lessonIndex + 1].id);
          continue;
        }

        if (chapterIndex + 1 < course.chapters.length) {
          final nextChapter = course.chapters[chapterIndex + 1];
          unlockedChapterIds.add(nextChapter.id);
          if (nextChapter.lessons.isNotEmpty) {
            unlockedLessonIds.add(nextChapter.lessons.first.id);
          }
        }
      }
    }

    return snapshot.copyWith(
      unlockedChapterIds: unlockedChapterIds,
      unlockedLessonIds: unlockedLessonIds,
    );
  }

  StudyHarmonyLessonProgressSummary _mergeLessonResult({
    required StudyHarmonyLessonProgressSummary? existing,
    required StudyHarmonyLessonDefinition lesson,
    required bool cleared,
    required int attempts,
    required double accuracy,
    required Duration elapsed,
    required DateTime playedAt,
  }) {
    final stars = _starsForResult(cleared: cleared, accuracy: accuracy);
    final rank = _rankForResult(cleared: cleared, accuracy: accuracy);
    final elapsedMillis = elapsed.inMilliseconds;

    if (existing == null) {
      return StudyHarmonyLessonProgressSummary(
        lessonId: _effectiveAnchorLessonId(lesson),
        isCleared: cleared,
        bestAccuracy: accuracy,
        bestAttemptCount: attempts,
        bestStars: stars,
        bestRank: rank,
        bestElapsedMillis: elapsedMillis,
        playCount: 1,
        lastPlayedAtIso8601: playedAt.toIso8601String(),
      );
    }

    return existing.copyWith(
      isCleared: existing.isCleared || cleared,
      bestAccuracy: accuracy > existing.bestAccuracy
          ? accuracy
          : existing.bestAccuracy,
      bestAttemptCount:
          existing.bestAttemptCount == 0 || attempts < existing.bestAttemptCount
          ? attempts
          : existing.bestAttemptCount,
      bestStars: stars > existing.bestStars ? stars : existing.bestStars,
      bestRank: _betterRank(existing.bestRank, rank),
      bestElapsedMillis:
          existing.bestElapsedMillis == 0 ||
              (elapsedMillis > 0 && elapsedMillis < existing.bestElapsedMillis)
          ? elapsedMillis
          : existing.bestElapsedMillis,
      playCount: existing.playCount + 1,
      lastPlayedAtIso8601: playedAt.toIso8601String(),
    );
  }

  Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>
  _mergeSkillMasteryPlaceholders({
    required Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>
    skillSummaries,
    required DateTime updatedAt,
  }) {
    final nextMastery =
        Map<StudyHarmonySkillTag, StudyHarmonySkillMasteryPlaceholder>.from(
          _snapshot.skillMasteryPlaceholders,
        );

    for (final entry in skillSummaries.entries) {
      final skillId = entry.key;
      if (skillId == 'legacy' || skillId.startsWith('legacy:')) {
        continue;
      }

      final summary = entry.value;
      final existing = nextMastery[skillId];
      final previousStreak = existing?.confidenceStreak ?? 0;
      final nextStreak = summary.accuracy >= 0.85
          ? previousStreak + 1
          : summary.accuracy < 0.65
          ? 0
          : previousStreak;
      final nextRecentScores = [
        ...(existing?.recentAttemptScores ?? const <double>[]),
        summary.accuracy,
      ];
      if (nextRecentScores.length > 5) {
        nextRecentScores.removeRange(0, nextRecentScores.length - 5);
      }

      final previousScore = existing?.masteryScore ?? 0.45;
      final nextScore = _clampUnitDouble(
        previousScore +
            _masteryDelta(
              accuracy: summary.accuracy,
              attemptCount: summary.attemptCount,
              previousStreak: previousStreak,
            ),
      );

      nextMastery[skillId] = StudyHarmonySkillMasteryPlaceholder(
        skillId: skillId,
        masteryScore: nextScore,
        exposureCount: (existing?.exposureCount ?? 0) + summary.attemptCount,
        correctSessionCount:
            (existing?.correctSessionCount ?? 0) +
            (summary.accuracy >= 0.85 ? 1 : 0),
        recentAttemptScores: nextRecentScores,
        recentAccuracy: _averageDoubles(nextRecentScores),
        confidenceStreak: nextStreak,
        lastSeenAtIso8601: updatedAt.toIso8601String(),
      );
    }

    return nextMastery;
  }

  List<StudyHarmonyReviewQueuePlaceholderEntry> _mergeReviewQueuePlaceholders({
    required Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>
    lessonSummaries,
    required StudyHarmonyLessonDefinition sessionLesson,
    required DateTime updatedAt,
  }) {
    final updatedLessonIds = lessonSummaries.keys.toSet();
    final nextQueue = _snapshot.reviewQueuePlaceholders
        .where((entry) => !updatedLessonIds.contains(entry.lessonId))
        .toList(growable: true);

    for (final summary in lessonSummaries.values) {
      final lessonDefinition = _registeredLessonById(summary.lessonId);
      final skillTags = lessonDefinition?.skillTags.isNotEmpty == true
          ? lessonDefinition!.skillTags
          : sessionLesson.sessionMetadata.focusSkillTags;

      if (summary.accuracy < 0.7) {
        nextQueue.add(
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:${summary.lessonId}',
            lessonId: summary.lessonId,
            reason: 'retry-needed',
            dueAtIso8601: updatedAt
                .add(const Duration(hours: 12))
                .toIso8601String(),
            priority: 3,
            skillTags: skillTags,
          ),
        );
        continue;
      }

      if (summary.accuracy < 0.9 || _averageMasteryForSkills(skillTags) < 0.6) {
        nextQueue.add(
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:${summary.lessonId}',
            lessonId: summary.lessonId,
            reason: summary.accuracy < 0.9 ? 'accuracy-refresh' : 'low-mastery',
            dueAtIso8601: updatedAt
                .add(const Duration(days: 1))
                .toIso8601String(),
            priority: summary.accuracy < 0.8 ? 2 : 1,
            skillTags: skillTags,
          ),
        );
      }
    }

    nextQueue.sort((left, right) {
      final priorityCompare = right.priority.compareTo(left.priority);
      if (priorityCompare != 0) {
        return priorityCompare;
      }
      return left.dueAtIso8601.compareTo(right.dueAtIso8601);
    });
    return nextQueue;
  }

  static DateTime _defaultNowProvider() => DateTime.now();

  int _starsForResult({required bool cleared, required double accuracy}) {
    if (!cleared) {
      return 0;
    }
    if (accuracy >= 0.95) {
      return 3;
    }
    if (accuracy >= 0.8) {
      return 2;
    }
    return 1;
  }

  String _rankForResult({required bool cleared, required double accuracy}) {
    if (!cleared) {
      return 'C';
    }
    if (accuracy >= 0.95) {
      return 'S';
    }
    if (accuracy >= 0.85) {
      return 'A';
    }
    if (accuracy >= 0.7) {
      return 'B';
    }
    return 'C';
  }

  String _betterRank(String left, String right) {
    const rankOrder = <String, int>{'S': 4, 'A': 3, 'B': 2, 'C': 1};
    final leftScore = rankOrder[left] ?? 0;
    final rightScore = rankOrder[right] ?? 0;
    return rightScore > leftScore ? right : left;
  }

  StudyHarmonyLessonRecommendation? _recommendationForLesson({
    required StudyHarmonyCourseDefinition course,
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonyRecommendationSource source,
    StudyHarmonySessionMode sessionMode = StudyHarmonySessionMode.lesson,
    List<StudyHarmonyLessonDefinition> sourceLessons =
        const <StudyHarmonyLessonDefinition>[],
    Set<StudyHarmonySkillTag> focusSkillTags = const <StudyHarmonySkillTag>{},
    StudyHarmonyReviewQueuePlaceholderEntry? reviewEntry,
    String? reviewReason,
    String? dailyDateKey,
    int? seedValue,
  }) {
    final chapter = _chapterForLesson(course, lesson);
    if (chapter == null) {
      return null;
    }
    return StudyHarmonyLessonRecommendation(
      lesson: lesson,
      chapter: chapter,
      source: source,
      sessionMode: sessionMode,
      sourceLessons: sourceLessons,
      focusSkillTags: focusSkillTags,
      reviewEntry: reviewEntry,
      reviewReason: reviewReason,
      dailyDateKey: dailyDateKey,
      seedValue: seedValue,
    );
  }

  StudyHarmonyLessonDefinition? _frontierLessonForCourse(
    StudyHarmonyCourseDefinition course,
  ) {
    for (final lesson in _orderedLessons(course)) {
      if (_isLessonAccessible(course, lesson) && !isLessonCleared(lesson.id)) {
        return lesson;
      }
    }
    return null;
  }

  List<StudyHarmonyLessonDefinition> _orderedLessons(
    StudyHarmonyCourseDefinition course,
  ) => [for (final chapter in course.chapters) ...chapter.lessons];

  StudyHarmonyLessonDefinition _fallbackLesson(
    StudyHarmonyCourseDefinition course,
  ) {
    return course.chapters.first.lessons.first;
  }

  StudyHarmonyLessonDefinition? _lessonForId(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonId? lessonId,
  ) {
    if (lessonId == null) {
      return null;
    }
    for (final chapter in course.chapters) {
      for (final lesson in chapter.lessons) {
        if (lesson.id == lessonId) {
          return lesson;
        }
      }
    }
    return null;
  }

  StudyHarmonyLessonDefinition? _registeredLessonById(
    StudyHarmonyLessonId lessonId,
  ) {
    for (final course in _coursesById.values) {
      final lesson = _lessonForId(course, lessonId);
      if (lesson != null) {
        return lesson;
      }
    }
    return null;
  }

  StudyHarmonyChapterDefinition? _chapterForLesson(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonDefinition lesson,
  ) {
    for (final chapter in course.chapters) {
      if (chapter.lessons.any((candidate) => candidate.id == lesson.id)) {
        return chapter;
      }
    }
    return null;
  }

  bool _isLessonAccessible(
    StudyHarmonyCourseDefinition course,
    StudyHarmonyLessonDefinition lesson,
  ) {
    final firstLessonId =
        course.chapters.isNotEmpty && course.chapters.first.lessons.isNotEmpty
        ? course.chapters.first.lessons.first.id
        : null;
    return isLessonUnlocked(lesson.id) || lesson.id == firstLessonId;
  }

  List<_ReviewCandidate> _rankReviewCandidates(
    StudyHarmonyCourseDefinition course,
  ) {
    final now = _nowProvider();
    final frontierLesson = _frontierLessonForCourse(course);
    final frontierSkills =
        frontierLesson?.skillTags ?? const <StudyHarmonySkillTag>{};
    final candidates = <_ReviewCandidate>[];

    for (final lesson in _orderedLessons(course)) {
      if (!_isLessonAccessible(course, lesson)) {
        continue;
      }

      final queueEntry = _bestReviewEntryForLesson(lesson.id);
      final result = _snapshot.lessonResults[lesson.id];
      final hasMasterySignal = lesson.skillTags.any(
        _snapshot.skillMasteryPlaceholders.containsKey,
      );
      if (queueEntry == null && result == null && !hasMasterySignal) {
        continue;
      }

      final masteryDebt = _masteryDebtForLesson(lesson);
      final recentMissFactor = _recentMissFactorForLesson(lesson);
      final staleDays = _stalenessDaysForLesson(lesson, now);
      final frontierOverlap = frontierSkills.isEmpty
          ? 0
          : lesson.skillTags.intersection(frontierSkills).length /
                frontierSkills.length;
      final dueBoost = queueEntry == null
          ? 0
          : 2.4 +
                (queueEntry.priority * 0.6) +
                (_isEntryDue(queueEntry, now) ? 0.4 : 0);
      final accuracyDebt = result == null
          ? 0.15
          : max(0, 0.85 - result.bestAccuracy);
      final unclearedBoost = result != null && !result.isCleared ? 0.75 : 0.0;
      final score =
          dueBoost +
          (masteryDebt * 2.1) +
          (recentMissFactor * 1.4) +
          (min(staleDays / 7, 2.0) * 0.7) +
          (frontierOverlap * 0.6) +
          (accuracyDebt * 1.8) +
          unclearedBoost;

      if (score <= 0.2) {
        continue;
      }

      candidates.add(
        _ReviewCandidate(
          lesson: lesson,
          score: score,
          reason:
              queueEntry?.reason ??
              (masteryDebt > 0.45
                  ? 'low-mastery'
                  : staleDays > 10
                  ? 'stale-skill'
                  : 'weak-spot'),
          entry: queueEntry,
        ),
      );
    }

    candidates.sort((left, right) {
      final scoreCompare = right.score.compareTo(left.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      final leftDue = left.entry == null
          ? 0
          : (_isEntryDue(left.entry!, now) ? 1 : 0);
      final rightDue = right.entry == null
          ? 0
          : (_isEntryDue(right.entry!, now) ? 1 : 0);
      return rightDue.compareTo(leftDue);
    });
    return candidates;
  }

  StudyHarmonyReviewQueuePlaceholderEntry? _bestReviewEntryForLesson(
    StudyHarmonyLessonId lessonId,
  ) {
    final matches = _snapshot.reviewQueuePlaceholders
        .where((entry) => entry.lessonId == lessonId)
        .toList(growable: false);
    if (matches.isEmpty) {
      return null;
    }
    final sorted = [...matches]
      ..sort((left, right) {
        final priorityCompare = right.priority.compareTo(left.priority);
        if (priorityCompare != 0) {
          return priorityCompare;
        }
        return left.dueAtIso8601.compareTo(right.dueAtIso8601);
      });
    return sorted.first;
  }

  double _masteryDebtForLesson(StudyHarmonyLessonDefinition lesson) {
    final scores = [
      for (final skillId in lesson.skillTags)
        _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore,
    ].whereType<double>().toList(growable: false);
    if (scores.isNotEmpty) {
      return 1 - _averageDoubles(scores);
    }
    final result = _snapshot.lessonResults[lesson.id];
    if (result != null) {
      return 1 - result.bestAccuracy;
    }
    return 0.55;
  }

  double _recentMissFactorForLesson(StudyHarmonyLessonDefinition lesson) {
    final values = [
      for (final skillId in lesson.skillTags)
        if (_snapshot.skillMasteryPlaceholders[skillId] case final mastery?)
          mastery.recentAttemptCount == 0
              ? 0.0
              : mastery.recentIncorrectCount / mastery.recentAttemptCount,
    ];
    if (values.isNotEmpty) {
      return _averageDoubles(values);
    }
    final result = _snapshot.lessonResults[lesson.id];
    if (result == null) {
      return 0;
    }
    return max(0, 1 - result.bestAccuracy);
  }

  double _stalenessDaysForLesson(
    StudyHarmonyLessonDefinition lesson,
    DateTime now,
  ) {
    final timestamps = <DateTime>[
      if (_snapshot.lessonResults[lesson.id]?.lastPlayedAtIso8601
          case final value?)
        ?_parseIsoDate(value),
      for (final skillId in lesson.skillTags)
        if (_snapshot.skillMasteryPlaceholders[skillId]?.lastSeenAtIso8601
            case final value?)
          ?_parseIsoDate(value),
    ];
    if (timestamps.isEmpty) {
      return 0;
    }
    timestamps.sort((left, right) => right.compareTo(left));
    return now.toUtc().difference(timestamps.first).inHours / 24;
  }

  Set<StudyHarmonySkillTag> _focusSkillTagsForLessons(
    List<StudyHarmonyLessonDefinition> lessons,
  ) {
    final skillIds = {
      for (final lesson in lessons) ...lesson.skillTags,
    }.toList(growable: false);
    skillIds.sort((left, right) {
      final leftScore =
          _snapshot.skillMasteryPlaceholders[left]?.masteryScore ?? 0.45;
      final rightScore =
          _snapshot.skillMasteryPlaceholders[right]?.masteryScore ?? 0.45;
      final scoreCompare = leftScore.compareTo(rightScore);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return left.compareTo(right);
    });
    return skillIds.take(3).toSet();
  }

  List<StudyHarmonyLessonDefinition> _buildDailySourceLessons(
    StudyHarmonyCourseDefinition course,
    int seedValue,
  ) {
    final accessibleLessons = _orderedLessons(course)
        .where((lesson) => _isLessonAccessible(course, lesson))
        .toList(growable: false);
    if (accessibleLessons.isEmpty) {
      return const <StudyHarmonyLessonDefinition>[];
    }

    final now = _nowProvider();
    final frontierLesson =
        _frontierLessonForCourse(course) ?? accessibleLessons.first;
    final rankedReviewCandidates = _rankReviewCandidates(course);
    final dueReviewLessons = rankedReviewCandidates
        .where(
          (candidate) =>
              candidate.entry != null && _isEntryDue(candidate.entry!, now),
        )
        .map((candidate) => candidate.lesson)
        .toList(growable: false);
    final sameChapterLessons = accessibleLessons
        .where(
          (lesson) =>
              lesson.chapterId == frontierLesson.chapterId &&
              lesson.id != frontierLesson.id,
        )
        .toList(growable: false);
    final lastPlayedLesson = _lessonForId(course, lastPlayedLessonId);

    final selected = <StudyHarmonyLessonDefinition>[];
    void addLesson(StudyHarmonyLessonDefinition? lesson) {
      if (lesson == null || !_isLessonAccessible(course, lesson)) {
        return;
      }
      if (selected.any((candidate) => candidate.id == lesson.id)) {
        return;
      }
      selected.add(lesson);
    }

    addLesson(frontierLesson);
    if (dueReviewLessons.isNotEmpty) {
      addLesson(dueReviewLessons[seedValue % dueReviewLessons.length]);
      if (dueReviewLessons.length > 1) {
        addLesson(
          dueReviewLessons[(seedValue ~/ 7).abs() % dueReviewLessons.length],
        );
      }
    } else if (rankedReviewCandidates.isNotEmpty) {
      addLesson(rankedReviewCandidates.first.lesson);
    }
    if (sameChapterLessons.isNotEmpty) {
      addLesson(
        sameChapterLessons[(seedValue ~/ 11).abs() % sameChapterLessons.length],
      );
    }
    addLesson(lastPlayedLesson);

    if (selected.length < 3) {
      final rankedAccessible = [...accessibleLessons]
        ..sort(
          (left, right) => _seededOrder(
            seedValue,
            left.id,
          ).compareTo(_seededOrder(seedValue, right.id)),
        );
      for (final lesson in rankedAccessible) {
        addLesson(lesson);
        if (selected.length >= 3) {
          break;
        }
      }
    }

    return selected;
  }

  Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>
  _normalizedLessonSummaries({
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonySessionPerformance performance,
    required int attempts,
    required double accuracy,
  }) {
    if (performance.lessonSummaries.isNotEmpty) {
      return Map<StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>.from(
        performance.lessonSummaries,
      );
    }

    final lessonId = _effectiveAnchorLessonId(lesson);
    return <StudyHarmonyLessonId, StudyHarmonyLessonSessionSummary>{
      lessonId: StudyHarmonyLessonSessionSummary(
        lessonId: lessonId,
        attemptCount: attempts,
        correctCount: _correctCountForAccuracy(attempts, accuracy),
      ),
    };
  }

  Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>
  _normalizedSkillSummaries({
    required StudyHarmonyLessonDefinition lesson,
    required StudyHarmonySessionPerformance performance,
    required int attempts,
    required double accuracy,
  }) {
    if (performance.skillSummaries.isNotEmpty) {
      return Map<StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>.from(
        performance.skillSummaries,
      );
    }

    final skillTags = lesson.sessionMetadata.focusSkillTags.isNotEmpty
        ? lesson.sessionMetadata.focusSkillTags
        : lesson.skillTags;
    if (skillTags.isEmpty) {
      return const <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{};
    }

    final correctCount = _correctCountForAccuracy(attempts, accuracy);
    return <StudyHarmonySkillTag, StudyHarmonySkillSessionSummary>{
      for (final skillId in skillTags)
        skillId: StudyHarmonySkillSessionSummary(
          skillId: skillId,
          attemptCount: attempts,
          correctCount: correctCount,
        ),
    };
  }

  StudyHarmonySessionPerformance _defaultSessionPerformance({
    required StudyHarmonyLessonDefinition lesson,
    required int attempts,
    required double accuracy,
  }) {
    return StudyHarmonySessionPerformance(
      skillSummaries: _normalizedSkillSummaries(
        lesson: lesson,
        performance: const StudyHarmonySessionPerformance(),
        attempts: attempts,
        accuracy: accuracy,
      ),
      lessonSummaries: _normalizedLessonSummaries(
        lesson: lesson,
        performance: const StudyHarmonySessionPerformance(),
        attempts: attempts,
        accuracy: accuracy,
      ),
    );
  }

  int _correctCountForAccuracy(int attempts, double accuracy) {
    if (attempts <= 0) {
      return 0;
    }
    return (_clampUnitDouble(accuracy) * attempts).round().clamp(0, attempts);
  }

  StudyHarmonyLessonId _effectiveAnchorLessonId(
    StudyHarmonyLessonDefinition lesson,
  ) {
    return lesson.sessionMetadata.anchorLessonId ??
        (lesson.sessionMetadata.sourceLessonIds.isNotEmpty
            ? lesson.sessionMetadata.sourceLessonIds.first
            : lesson.id);
  }

  StudyHarmonyDailyChallengeSeedMetadata? _mergeDailyMetadataFromLesson(
    StudyHarmonyLessonDefinition lesson,
  ) {
    if (lesson.sessionMode != StudyHarmonySessionMode.daily) {
      return _snapshot.dailyChallengeSeedMetadata;
    }

    final dateKey = lesson.sessionMetadata.dailyDateKey;
    final seedValue = lesson.sessionMetadata.dailySeedValue;
    if (dateKey == null || seedValue == null) {
      return _snapshot.dailyChallengeSeedMetadata;
    }

    final existing = _snapshot.dailyChallengeSeedMetadata;
    final sourceLessonIds = lesson.sessionMetadata.sourceLessonIds.isEmpty
        ? <StudyHarmonyLessonId>[_effectiveAnchorLessonId(lesson)]
        : lesson.sessionMetadata.sourceLessonIds.toList(growable: false);
    return StudyHarmonyDailyChallengeSeedMetadata(
      version: existing?.version ?? 1,
      dateKey: dateKey,
      seedValue: seedValue,
      trackId: existing?.trackId,
      chapterId: lesson.chapterId,
      lessonId: _effectiveAnchorLessonId(lesson),
      sourceLessonIds: sourceLessonIds,
    );
  }

  double _masteryDelta({
    required double accuracy,
    required int attemptCount,
    required int previousStreak,
  }) {
    final clampedAccuracy = _clampUnitDouble(accuracy);
    final volumeWeight = 0.6 + (min(attemptCount, 8) * 0.05);
    var delta = (clampedAccuracy - 0.65) * 0.22 * volumeWeight;
    if (clampedAccuracy >= 0.85) {
      delta += min(previousStreak, 3) * 0.012;
    } else if (clampedAccuracy < 0.55) {
      delta -= 0.025;
    }
    return delta;
  }

  double _averageMasteryForSkills(Set<StudyHarmonySkillTag> skillTags) {
    final scores = [
      for (final skillId in skillTags)
        _snapshot.skillMasteryPlaceholders[skillId]?.masteryScore,
    ].whereType<double>().toList(growable: false);
    return scores.isEmpty ? 0.45 : _averageDoubles(scores);
  }

  bool _isEntryDue(
    StudyHarmonyReviewQueuePlaceholderEntry entry,
    DateTime now,
  ) {
    final dueAt = _parseIsoDate(entry.dueAtIso8601);
    if (dueAt == null) {
      return true;
    }
    return !dueAt.isAfter(now.toUtc());
  }

  DateTime? _parseIsoDate(String value) {
    return DateTime.tryParse(value)?.toUtc();
  }

  int _dailySeedValue(StudyHarmonyCourseDefinition course, String dateKey) {
    return _stableHash('${course.trackId}|${course.id}|$dateKey');
  }

  int _seededOrder(int seedValue, String id) {
    return _stableHash('$seedValue|$id');
  }

  String _dailyDateKey(DateTime now) {
    final year = now.year.toString().padLeft(4, '0');
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

@immutable
class _ReviewCandidate {
  const _ReviewCandidate({
    required this.lesson,
    required this.score,
    required this.reason,
    this.entry,
  });

  final StudyHarmonyLessonDefinition lesson;
  final double score;
  final String reason;
  final StudyHarmonyReviewQueuePlaceholderEntry? entry;
}

double _averageDoubles(Iterable<double> values) {
  var count = 0;
  var sum = 0.0;
  for (final value in values) {
    sum += value;
    count += 1;
  }
  return count == 0 ? 0 : sum / count;
}

double _clampUnitDouble(double value) {
  if (value.isNaN) {
    return 0;
  }
  return value.clamp(0.0, 1.0).toDouble();
}

int _stableHash(String value) {
  var hash = 0;
  for (final unit in value.codeUnits) {
    hash = ((hash * 31) + unit) & 0x7fffffff;
  }
  return hash;
}
