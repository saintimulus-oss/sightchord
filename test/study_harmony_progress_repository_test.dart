import 'dart:convert';

import 'package:chordest/study_harmony/data/study_harmony_progress_codec.dart';
import 'package:chordest/study_harmony/data/study_harmony_progress_repository.dart';
import 'package:chordest/study_harmony/data/study_harmony_progress_storage_keys.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test(
    'repository save writes primary backup last-known-good and metadata',
    () async {
      const repository = StudyHarmonyProgressRepository();
      const firstSnapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 14,
        unlockedChapterIds: {'chapter-a'},
      );
      const secondSnapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 14,
        unlockedChapterIds: {'chapter-b'},
      );

      await repository.save(firstSnapshot);
      await repository.save(secondSnapshot);

      final preferences = await SharedPreferences.getInstance();
      final primaryPayload = preferences.getString(
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
      );
      final backupPayload = preferences.getString(
        StudyHarmonyProgressStorageKeys.backupEnvelopeKey,
      );
      final lastKnownGoodPayload = preferences.getString(
        StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey,
      );
      final codec = const StudyHarmonyProgressCodec();

      expect(primaryPayload, isNotNull);
      expect(backupPayload, isNotNull);
      expect(lastKnownGoodPayload, isNotNull);
      expect(
        codec.decodeEnvelope(primaryPayload!).unlockedChapterIds,
        contains('chapter-b'),
      );
      expect(
        codec.decodeEnvelope(backupPayload!).unlockedChapterIds,
        contains('chapter-a'),
      );
      expect(
        codec.decodeEnvelope(lastKnownGoodPayload!).unlockedChapterIds,
        contains('chapter-b'),
      );
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'save',
      );
    },
  );

  test(
    'repository restores from last-known-good before shadow or fallback',
    () async {
      const codec = StudyHarmonyProgressCodec();
      const repository = StudyHarmonyProgressRepository();
      const snapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 14,
        unlockedChapterIds: {'last-good-chapter'},
      );

      SharedPreferences.setMockInitialValues(<String, Object>{
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: '{bad-primary',
        StudyHarmonyProgressStorageKeys.backupEnvelopeKey: '{bad-backup',
        StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey: codec
            .encodeEnvelope(snapshot),
      });

      final restored = await repository.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();

      expect(restored.unlockedChapterIds, contains('last-good-chapter'));
      expect(
        _decodeMetadata(
          preferences.getString(
            StudyHarmonyProgressStorageKeys.progressMetadataKey,
          ),
        )['lastGoodSource'],
        'lastKnownGood',
      );
    },
  );

  test(
    'repository migrates a schema v1 primary envelope and rewrites v2 artifacts',
    () async {
      const repository = StudyHarmonyProgressRepository();
      final legacyV1Envelope = jsonEncode(<String, Object?>{
        'schemaVersion': 1,
        'serializationVersion': 6,
        'profile': <String, Object?>{'lastPlayedTrackId': 'classical'},
        'lessonState': <String, Object?>{
          'unlockedChapterIds': <String>['classical-cadence'],
        },
        'skillState': <String, Object?>{},
        'dailyState': <String, Object?>{},
        'rewardState': <String, Object?>{},
        'seasonalState': <String, Object?>{},
      });

      SharedPreferences.setMockInitialValues(<String, Object>{
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: legacyV1Envelope,
      });

      final restored = await repository.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();
      final upgradedEnvelope = _decodeMap(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
        ),
      );

      expect(restored.lastPlayedTrackId, 'classical');
      expect(restored.unlockedChapterIds, contains('classical-cadence'));
      expect(
        upgradedEnvelope['schemaVersion'],
        StudyHarmonyProgressCodec.currentSchemaVersion,
      );
      expect(upgradedEnvelope['segments'], isA<Map<Object?, Object?>>());
    },
  );

  test(
    'repository upgrades a raw snapshot payload into the v2 envelope',
    () async {
      const repository = StudyHarmonyProgressRepository();
      const rawSnapshot = StudyHarmonyProgressSnapshot(
        serializationVersion: 14,
        lastPlayedTrackId: 'pop',
        unlockedLessonIds: {'pop-hooks-1'},
      );

      SharedPreferences.setMockInitialValues(<String, Object>{
        StudyHarmonyProgressStorageKeys.progressEnvelopeKey: rawSnapshot
            .encode(),
      });

      final restored = await repository.load(
        fallbackSnapshot: StudyHarmonyProgressSnapshot.initial(),
      );
      final preferences = await SharedPreferences.getInstance();
      final upgradedEnvelope = _decodeMap(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
        ),
      );

      expect(restored.lastPlayedTrackId, 'pop');
      expect(restored.unlockedLessonIds, contains('pop-hooks-1'));
      expect(
        upgradedEnvelope['schemaVersion'],
        StudyHarmonyProgressCodec.currentSchemaVersion,
      );
      expect(
        preferences.getString(
          StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey,
        ),
        isNotNull,
      );
    },
  );
}

Map<String, Object?> _decodeMetadata(String? encoded) {
  expect(encoded, isNotNull);
  return _decodeMap(encoded);
}

Map<String, Object?> _decodeMap(String? encoded) {
  expect(encoded, isNotNull);
  final decoded = jsonDecode(encoded!);
  expect(decoded, isA<Map<Object?, Object?>>());
  return (decoded as Map<Object?, Object?>).cast<String, Object?>();
}
