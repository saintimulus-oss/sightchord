import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';

void main() {
  test(
    'progress snapshot serialization round-trips with mastery, review, and daily metadata',
    () {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 2,
        lastPlayedTrackId: 'track-1',
        lastPlayedChapterId: 'chapter-1',
        lastPlayedLessonId: 'lesson-1',
        unlockedChapterIds: {'chapter-1'},
        unlockedLessonIds: {'lesson-1', 'lesson-2'},
        lessonResults: {
          'lesson-1': StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-1',
            isCleared: true,
            bestAccuracy: 0.92,
            bestAttemptCount: 3,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 42000,
            playCount: 4,
            lastPlayedAtIso8601: '2026-03-13T00:00:00.000Z',
          ),
        },
        skillMasteryPlaceholders: {
          'note.findKeyboard': StudyHarmonySkillMasteryPlaceholder(
            skillId: 'note.findKeyboard',
            masteryScore: 0.75,
            exposureCount: 5,
            correctSessionCount: 3,
            recentAttemptScores: [0.25, 0.75, 1.0],
            recentAccuracy: 0.67,
            confidenceStreak: 2,
            lastSeenAtIso8601: '2026-03-13T00:00:00.000Z',
          ),
        },
        reviewQueuePlaceholders: [
          StudyHarmonyReviewQueuePlaceholderEntry(
            itemId: 'lesson:lesson-2',
            lessonId: 'lesson-2',
            reason: 'retry-needed',
            dueAtIso8601: '2026-03-14T00:00:00.000Z',
            priority: 2,
            skillTags: {'note.findKeyboard'},
          ),
        ],
        dailyChallengeSeedMetadata: StudyHarmonyDailyChallengeSeedMetadata(
          version: 1,
          dateKey: '2026-03-13',
          seedValue: 4242,
          trackId: 'track-1',
          chapterId: 'chapter-1',
          lessonId: 'lesson-2',
          sourceLessonIds: ['lesson-1', 'lesson-2'],
        ),
      );

      final decoded = StudyHarmonyProgressSnapshot.fromEncoded(
        snapshot.encode(),
      );

      expect(decoded.serializationVersion, 2);
      expect(decoded.lastPlayedTrackId, 'track-1');
      expect(decoded.lastPlayedLessonId, 'lesson-1');
      expect(
        decoded.unlockedLessonIds,
        containsAll(const {'lesson-1', 'lesson-2'}),
      );
      expect(decoded.lessonResults['lesson-1']?.bestRank, 'A');
      expect(
        decoded
            .skillMasteryPlaceholders['note.findKeyboard']
            ?.recentAttemptCount,
        3,
      );
      expect(
        decoded.skillMasteryPlaceholders['note.findKeyboard']?.confidenceStreak,
        2,
      );
      expect(
        decoded.reviewQueuePlaceholders.single.skillTags,
        contains('note.findKeyboard'),
      );
      expect(
        decoded.dailyChallengeSeedMetadata?.sourceLessonIds,
        equals(['lesson-1', 'lesson-2']),
      );
    },
  );

  test('progress snapshot serialization round-trips loadout ownership', () {
    const snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion: StudyHarmonyProgressSnapshot.currentSerializationVersion,
      ownedTitleIds: {'title.spark', 'title.riff_runner'},
      ownedCosmeticIds: {'cosmetic.frame.neon', 'cosmetic.trail.confetti'},
      equippedTitleId: 'title.spark',
      equippedCosmeticIds: [
        'cosmetic.frame.neon',
        'cosmetic.trail.confetti',
      ],
    );

    final decoded = StudyHarmonyProgressSnapshot.fromEncoded(snapshot.encode());

    expect(decoded.ownedTitleIds, containsAll(const {'title.spark', 'title.riff_runner'}));
    expect(
      decoded.ownedCosmeticIds,
      containsAll(const {'cosmetic.frame.neon', 'cosmetic.trail.confetti'}),
    );
    expect(decoded.equippedTitleId, 'title.spark');
    expect(
      decoded.equippedCosmeticIds,
      equals(const ['cosmetic.frame.neon', 'cosmetic.trail.confetti']),
    );
  });

  test('legacy snapshot payloads without loadout fields still decode safely', () {
    final decoded = StudyHarmonyProgressSnapshot.fromJsonValue(
      const <String, Object?>{
        'serializationVersion': 13,
      },
    );

    expect(decoded.ownedTitleIds, isEmpty);
    expect(decoded.ownedCosmeticIds, isEmpty);
    expect(decoded.equippedTitleId, isNull);
    expect(decoded.equippedCosmeticIds, isEmpty);
  });
}

