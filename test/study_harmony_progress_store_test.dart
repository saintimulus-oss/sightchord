import 'dart:convert';

import 'package:chordest/study_harmony/data/study_harmony_progress_codec.dart';
import 'package:chordest/study_harmony/data/study_harmony_progress_storage_keys.dart';
import 'package:chordest/study_harmony/data/study_harmony_progress_store.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'progress store saves and restores unlock state and daily seed metadata',
    () async {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'chapter-1'},
        unlockedLessonIds: {'lesson-1', 'lesson-2'},
        dailyChallengeSeedMetadata: StudyHarmonyDailyChallengeSeedMetadata(
          version: 1,
          dateKey: '2026-03-13',
          seedValue: 777,
          lessonId: 'lesson-2',
        ),
      );

      final store = SharedPrefsStudyHarmonyProgressStore();
      await store.save(snapshot);
      final restored = await store.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );

      expect(restored.unlockedChapterIds, contains('chapter-1'));
      expect(
        restored.unlockedLessonIds,
        containsAll(const {'lesson-1', 'lesson-2'}),
      );
      expect(restored.dailyChallengeSeedMetadata?.seedValue, 777);

      final preferences = await SharedPreferences.getInstance();
      final metadata = _decodeMetadata(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.progressMetadataKey,
        ),
      );
      expect(metadata['lastGoodSource'], 'primary');
      for (final segmentName in StudyHarmonyProgressCodec.segmentNames) {
        expect(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.shadowSegmentKey(segmentName),
          ),
          isNotNull,
        );
      }
    },
  );

  test(
    'progress store migrates legacy payloads into the v2 envelope',
    () async {
      const legacySnapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'legacy-chapter'},
        unlockedLessonIds: {'legacy-lesson'},
      );
      const legacyDailySeed = StudyHarmonyDailyChallengeSeedMetadata(
        version: 1,
        dateKey: '2026-03-19',
        seedValue: 991,
        lessonId: 'legacy-lesson',
      );

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.legacyProgressKey: legacySnapshot
            .encode(),
        StudyHarmonyProgressStorageKeys.legacyDailySeedKey: legacyDailySeed
            .encode(),
      });

      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();

      expect(restored.unlockedChapterIds, contains('legacy-chapter'));
      expect(restored.dailyChallengeSeedMetadata?.seedValue, 991);
      expect(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
        ),
        isNotNull,
      );
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'legacy',
      );
    },
  );

  test(
    'progress store restores from backup when the primary envelope is corrupt',
    () async {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'backup-chapter'},
      );
      const codec = StudyHarmonyProgressCodec();
      final backupEnvelope = codec.encodeEnvelope(snapshot);

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: '{not-json',
        StudyHarmonyProgressStorageKeys.backupEnvelopeKey: backupEnvelope,
      });

      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();

      expect(restored.unlockedChapterIds, contains('backup-chapter'));
      expect(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.corruptEnvelopeKey,
        ),
        '{not-json',
      );
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'backup',
      );
    },
  );

  test(
    'progress store restores from shadow segments when both envelopes are corrupt',
    () async {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'shadow-chapter'},
        unlockedLessonIds: {'shadow-lesson'},
      );
      const codec = StudyHarmonyProgressCodec();
      final artifacts = codec.encodeArtifacts(snapshot);

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: '{bad-primary',
        StudyHarmonyProgressStorageKeys.backupEnvelopeKey: '{bad-backup',
        StudyHarmonyProgressStorageKeys.progressMetadataKey:
            artifacts.metadataPayload,
        for (final entry in artifacts.segmentPayloads.entries)
          StudyHarmonyProgressStorageKeys.shadowSegmentKey(entry.key):
              entry.value,
      });

      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();

      expect(restored.unlockedChapterIds, contains('shadow-chapter'));
      expect(restored.unlockedLessonIds, contains('shadow-lesson'));
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'shadow',
      );
      expect(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
        ),
        isNot('{bad-primary'),
      );
    },
  );

  test(
    'progress store rejects tampered shadow segments and falls back safely',
    () async {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'shadow-chapter'},
      );
      const codec = StudyHarmonyProgressCodec();
      final artifacts = codec.encodeArtifacts(snapshot);
      final tamperedSegments = Map<String, String>.from(
        artifacts.segmentPayloads,
      )..update('lessonState', (_) => '{"unlockedLessonIds":["oops"]}');

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: '{bad-primary',
        StudyHarmonyProgressStorageKeys.backupEnvelopeKey: '{bad-backup',
        StudyHarmonyProgressStorageKeys.progressMetadataKey:
            artifacts.metadataPayload,
        for (final entry in tamperedSegments.entries)
          StudyHarmonyProgressStorageKeys.shadowSegmentKey(entry.key):
              entry.value,
      });

      const fallback = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'fallback-chapter'},
      );
      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(fallbackSnapshot: fallback);

      expect(restored.unlockedChapterIds, contains('fallback-chapter'));
      expect(restored.unlockedChapterIds, isNot(contains('shadow-chapter')));
    },
  );

  test(
    'progress store migrates a valid legacy daily seed even when the legacy snapshot is corrupt',
    () async {
      const legacyDailySeed = StudyHarmonyDailyChallengeSeedMetadata(
        version: 1,
        dateKey: '2026-03-19',
        seedValue: 991,
        lessonId: 'legacy-lesson',
      );

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.legacyProgressKey: '{bad-legacy',
        StudyHarmonyProgressStorageKeys.legacyDailySeedKey: legacyDailySeed
            .encode(),
      });

      const fallback = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'fallback-chapter'},
      );
      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(fallbackSnapshot: fallback);

      expect(restored.unlockedChapterIds, contains('fallback-chapter'));
      expect(restored.dailyChallengeSeedMetadata?.seedValue, 991);
    },
  );

  test(
    'progress store refreshes metadata and shadow segments from a valid primary envelope',
    () async {
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'primary-chapter'},
      );
      const codec = StudyHarmonyProgressCodec();

      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: codec
            .encodeEnvelope(snapshot),
      });

      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();

      expect(restored.unlockedChapterIds, contains('primary-chapter'));
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'primary',
      );
      for (final segmentName in StudyHarmonyProgressCodec.segmentNames) {
        expect(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.shadowSegmentKey(segmentName),
          ),
          isNotNull,
        );
      }
    },
  );

  test(
    'progress store falls back to the provided snapshot when no recovery path exists',
    () async {
      SharedPreferences.setMockInitialValues({
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: '{still-bad',
      });

      const fallback = StudyHarmonyProgressSnapshot(
        serializationVersion: 1,
        unlockedChapterIds: {'fallback-chapter'},
      );
      final store = SharedPrefsStudyHarmonyProgressStore();
      final restored = await store.load(fallbackSnapshot: fallback);

      expect(restored.unlockedChapterIds, contains('fallback-chapter'));
    },
  );
}

Map<String, Object?> _decodeMetadata(String? encoded) {
  expect(encoded, isNotNull);
  final decoded = jsonDecode(encoded!);
  expect(decoded, isA<Map<Object?, Object?>>());
  return (decoded as Map<Object?, Object?>).cast<String, Object?>();
}
