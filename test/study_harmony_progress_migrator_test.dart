import 'dart:convert';

import 'package:chordest/study_harmony/data/study_harmony_progress_migrator.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const migrator = StudyHarmonyProgressMigrator();
  const fallback = StudyHarmonyProgressSnapshot(
    serializationVersion: 14,
    unlockedChapterIds: {'fallback-chapter'},
  );

  test('migrator upgrades schema v1 top-level segments into a snapshot', () {
    final migrated = migrator.migrateEnvelopePayload(
      encodedPayload: jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'serializationVersion': 7,
        'profile': <String, Object?>{'lastPlayedTrackId': 'jazz'},
        'lessonState': <String, Object?>{
          'unlockedChapterIds': <String>['jazz-signature'],
          'unlockedLessonIds': <String>['jazz-shell-1'],
        },
        'skillState': <String, Object?>{},
        'dailyState': <String, Object?>{},
        'rewardState': <String, Object?>{
          'rewardCurrencyBalances': <String, Object?>{'credits': 8},
        },
        'seasonalState': <String, Object?>{},
      }),
      fallbackSnapshot: fallback,
    );

    expect(migrated, isNotNull);
    expect(
      migrated!.serializationVersion,
      StudyHarmonyProgressSnapshot.currentSerializationVersion,
    );
    expect(migrated.lastPlayedTrackId, 'jazz');
    expect(migrated.unlockedChapterIds, contains('jazz-signature'));
    expect(migrated.rewardCurrencyBalances['credits'], 8);
  });

  test(
    'migrator preserves valid legacy daily seed even when legacy snapshot is corrupt',
    () {
      const dailySeed = StudyHarmonyDailyChallengeSeedMetadata(
        version: 1,
        dateKey: '2026-03-19',
        seedValue: 321,
        lessonId: 'lesson-x',
      );

      final migrated = migrator.migrateLegacy(
        fallbackSnapshot: fallback,
        legacyProgressPayload: '{bad-json',
        legacyDailySeedPayload: dailySeed.encode(),
      );

      expect(migrated, isNotNull);
      expect(migrated!.unlockedChapterIds, contains('fallback-chapter'));
      expect(migrated.dailyChallengeSeedMetadata?.seedValue, 321);
    },
  );

  test('migrator returns null when no legacy payload exists', () {
    final migrated = migrator.migrateLegacy(fallbackSnapshot: fallback);

    expect(migrated, isNull);
  });
}
