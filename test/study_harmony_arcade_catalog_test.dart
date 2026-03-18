import 'package:flutter_test/flutter_test.dart';

import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:chordest/study_harmony/meta/study_harmony_arcade_catalog.dart';

void main() {
  group('StudyHarmony arcade catalog', () {
    test('catalog exposes a game-like mix of modes and playlists', () {
      expect(studyHarmonyArcadeModeCatalog.length, greaterThanOrEqualTo(6));
      expect(studyHarmonyArcadePlaylistCatalog.length, greaterThanOrEqualTo(3));

      final modeIds = studyHarmonyArcadeModeCatalog
          .map((mode) => mode.id)
          .toSet();
      expect(modeIds.length, studyHarmonyArcadeModeCatalog.length);

      for (final mode in studyHarmonyArcadeModeCatalog) {
        expect(mode.title, isNotEmpty);
        expect(mode.subtitle, isNotEmpty);
        expect(mode.fantasy, isNotEmpty);
        expect(mode.shortLoop, isNotEmpty);
        expect(mode.recommendationReasons, isNotEmpty);
        expect(mode.unlockRules, isNotEmpty);
      }

      expect(
        studyHarmonyArcadeModeCatalog
            .where((mode) => mode.spotlight)
            .map((mode) => mode.id),
        isNotEmpty,
      );
    });

    test('progress summary can be built from lesson summaries alone', () {
      final lessons = <StudyHarmonyLessonProgressSummary>[
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-a',
          isCleared: true,
          bestAccuracy: 0.97,
          bestAttemptCount: 1,
          bestStars: 3,
          bestRank: 'S',
          bestElapsedMillis: 90000,
          playCount: 3,
        ),
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-b',
          isCleared: true,
          bestAccuracy: 0.82,
          bestAttemptCount: 2,
          bestStars: 2,
          bestRank: 'A',
          bestElapsedMillis: 110000,
          playCount: 2,
        ),
        const StudyHarmonyLessonProgressSummary(
          lessonId: 'lesson-c',
          isCleared: false,
          bestAccuracy: 0.61,
          bestAttemptCount: 4,
          bestStars: 1,
          bestRank: 'B',
          bestElapsedMillis: 130000,
          playCount: 5,
        ),
      ];

      final summary = summarizeStudyHarmonyArcadeProgress(
        lessons,
        totalLessons: 8,
        reviewQueueSize: 4,
        chapterClears: 1,
        bossClears: 0,
        currentStreak: 3,
      );

      expect(summary.totalLessons, 8);
      expect(summary.completedLessons, 2);
      expect(summary.averageAccuracy, closeTo(0.8, 0.000001));
      expect(summary.bestAccuracy, closeTo(0.97, 0.000001));
      expect(summary.sRanks, 1);
      expect(summary.perfectRuns, 1);
      expect(summary.currentStreak, 3);
      expect(summary.reviewQueueSize, 4);
      expect(summary.chapterClears, 1);
      expect(summary.playCount, 10);
      expect(summary.completionRate, closeTo(0.25, 0.000001));
    });

    test(
      'unlock rules and recommendation cues reflect the current progress',
      () {
        final warmSummary = summarizeStudyHarmonyArcadeProgress(
          const [
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-a',
              isCleared: true,
              bestAccuracy: 0.74,
              bestAttemptCount: 2,
              bestStars: 2,
              bestRank: 'B',
              bestElapsedMillis: 105000,
              playCount: 2,
            ),
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-b',
              isCleared: false,
              bestAccuracy: 0.59,
              bestAttemptCount: 3,
              bestStars: 1,
              bestRank: 'C',
              bestElapsedMillis: 124000,
              playCount: 1,
            ),
          ],
          totalLessons: 12,
          reviewQueueSize: 2,
          currentStreak: 1,
        );

        final neonSprint = studyHarmonyArcadeModeById('neon-sprint')!;
        final bossRush = studyHarmonyArcadeModeById('boss-rush')!;

        expect(neonSprint.isUnlocked(warmSummary), isTrue);
        expect(bossRush.isUnlocked(warmSummary), isFalse);
        expect(
          neonSprint.recommendationCueFor(warmSummary),
          contains('fast, forgiving burst'),
        );

        final highSkillSummary = summarizeStudyHarmonyArcadeProgress(
          const [
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-a',
              isCleared: true,
              bestAccuracy: 0.98,
              bestAttemptCount: 1,
              bestStars: 3,
              bestRank: 'S',
              bestElapsedMillis: 84000,
              playCount: 4,
            ),
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-b',
              isCleared: true,
              bestAccuracy: 0.95,
              bestAttemptCount: 1,
              bestStars: 3,
              bestRank: 'S',
              bestElapsedMillis: 88000,
              playCount: 3,
            ),
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-c',
              isCleared: true,
              bestAccuracy: 0.91,
              bestAttemptCount: 1,
              bestStars: 3,
              bestRank: 'A',
              bestElapsedMillis: 93000,
              playCount: 2,
            ),
            StudyHarmonyLessonProgressSummary(
              lessonId: 'lesson-d',
              isCleared: true,
              bestAccuracy: 0.88,
              bestAttemptCount: 2,
              bestStars: 2,
              bestRank: 'A',
              bestElapsedMillis: 101000,
              playCount: 1,
            ),
          ],
          totalLessons: 10,
          reviewQueueSize: 0,
          chapterClears: 2,
          bossClears: 1,
          currentStreak: 5,
        );

        expect(bossRush.isUnlocked(highSkillSummary), isTrue);
        expect(
          bossRush.recommendationCueFor(highSkillSummary),
          contains('serious test of nerve'),
        );
      },
    );

    test('featured modes and playlists are ranked from progress signals', () {
      final progress = summarizeStudyHarmonyArcadeProgress(
        const [
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-a',
            isCleared: true,
            bestAccuracy: 0.97,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 80000,
            playCount: 4,
          ),
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-b',
            isCleared: true,
            bestAccuracy: 0.94,
            bestAttemptCount: 1,
            bestStars: 3,
            bestRank: 'S',
            bestElapsedMillis: 84000,
            playCount: 4,
          ),
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-c',
            isCleared: true,
            bestAccuracy: 0.86,
            bestAttemptCount: 1,
            bestStars: 2,
            bestRank: 'A',
            bestElapsedMillis: 90000,
            playCount: 3,
          ),
          StudyHarmonyLessonProgressSummary(
            lessonId: 'lesson-d',
            isCleared: true,
            bestAccuracy: 0.79,
            bestAttemptCount: 2,
            bestStars: 2,
            bestRank: 'B',
            bestElapsedMillis: 100000,
            playCount: 2,
          ),
        ],
        totalLessons: 12,
        reviewQueueSize: 3,
        chapterClears: 2,
        bossClears: 1,
        currentStreak: 4,
      );

      final featuredCards = buildStudyHarmonyFeaturedArcadeModeCards(
        progress,
        limit: 4,
      );

      expect(featuredCards, isNotEmpty);
      expect(featuredCards.first.mode.id, anyOf('boss-rush', 'crown-loop'));
      expect(
        featuredCards.map((entry) => entry.mode.id),
        contains('neon-sprint'),
      );

      final featuredFromLessons =
          buildStudyHarmonyFeaturedArcadeModesFromLessonSummaries(
            const [
              StudyHarmonyLessonProgressSummary(
                lessonId: 'lesson-a',
                isCleared: true,
                bestAccuracy: 0.92,
                bestAttemptCount: 1,
                bestStars: 3,
                bestRank: 'S',
                bestElapsedMillis: 83000,
                playCount: 2,
              ),
              StudyHarmonyLessonProgressSummary(
                lessonId: 'lesson-b',
                isCleared: true,
                bestAccuracy: 0.85,
                bestAttemptCount: 1,
                bestStars: 2,
                bestRank: 'A',
                bestElapsedMillis: 92000,
                playCount: 2,
              ),
            ],
            totalLessons: 6,
            reviewQueueSize: 1,
            chapterClears: 1,
            currentStreak: 2,
          );

      expect(featuredFromLessons, isNotEmpty);
      expect(featuredFromLessons.first.id, 'neon-sprint');

      final featuredPlaylists = buildStudyHarmonyFeaturedArcadePlaylists(
        progress,
        limit: 2,
      );

      expect(featuredPlaylists, isNotEmpty);
      expect(
        featuredPlaylists.first.playlist.id,
        anyOf('boss-ladder', 'after-dark'),
      );
      expect(featuredPlaylists.first.cue, isNotEmpty);
    });
  });
}
