import 'dart:convert';

import 'study_harmony_progress_codec.dart';
import '../domain/study_harmony_progress_models.dart';

class StudyHarmonyProgressMigrator {
  const StudyHarmonyProgressMigrator();

  StudyHarmonyProgressSnapshot? migrateEnvelopePayload({
    required String encodedPayload,
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    if (encodedPayload.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(encodedPayload);
      if (decoded is! Map<Object?, Object?>) {
        return null;
      }
      return migrateEnvelopeMap(
        payload: decoded.cast<String, Object?>(),
        fallbackSnapshot: fallbackSnapshot,
      );
    } on FormatException {
      return null;
    }
  }

  StudyHarmonyProgressSnapshot? migrateEnvelopeMap({
    required Map<String, Object?> payload,
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    if (payload.isEmpty) {
      return null;
    }

    final schemaVersion = _intOrNull(payload['schemaVersion']);
    if (schemaVersion == null) {
      if (payload.containsKey('serializationVersion') &&
          !payload.containsKey('segments')) {
        return _validatedMigratedSnapshot(
          StudyHarmonyProgressSnapshot.fromJsonValue(payload),
          fallbackSnapshot: fallbackSnapshot,
        );
      }
      return null;
    }

    if (schemaVersion > StudyHarmonyProgressCodec.currentSchemaVersion) {
      throw FormatException(
        'Unsupported Study Harmony progress schema version: $schemaVersion.',
      );
    }

    if (schemaVersion == 1) {
      return _migrateSchemaV1Envelope(
        payload,
        fallbackSnapshot: fallbackSnapshot,
      );
    }

    return _migrateSegmentEnvelope(payload, fallbackSnapshot: fallbackSnapshot);
  }

  StudyHarmonyProgressSnapshot? migrateLegacy({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
    String? legacyProgressPayload,
    String? legacyDailySeedPayload,
  }) {
    final hasLegacyPayload =
        (legacyProgressPayload?.isNotEmpty ?? false) ||
        (legacyDailySeedPayload?.isNotEmpty ?? false);
    if (!hasLegacyPayload) {
      return null;
    }

    var snapshot = _decodeLegacySnapshot(
      legacyProgressPayload,
      fallbackSnapshot: fallbackSnapshot,
    );
    final legacyDailySeed = StudyHarmonyDailyChallengeSeedMetadata.fromEncoded(
      legacyDailySeedPayload,
    );
    if (legacyDailySeed != null) {
      snapshot = snapshot.copyWith(dailyChallengeSeedMetadata: legacyDailySeed);
    }
    return _validatedMigratedSnapshot(
      snapshot.copyWith(
        serializationVersion:
            StudyHarmonyProgressSnapshot.currentSerializationVersion,
      ),
      fallbackSnapshot: fallbackSnapshot,
    );
  }

  StudyHarmonyProgressSnapshot? _migrateSchemaV1Envelope(
    Map<String, Object?> payload, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    final snapshotValue = payload['snapshot'];
    if (snapshotValue is Map<Object?, Object?>) {
      return _validatedMigratedSnapshot(
        StudyHarmonyProgressSnapshot.fromJsonValue(
          snapshotValue.cast<String, Object?>(),
        ),
        fallbackSnapshot: fallbackSnapshot,
      );
    }

    final segments = <String, Object?>{
      for (final segmentName in StudyHarmonyProgressCodec.segmentNames)
        if (payload.containsKey(segmentName)) segmentName: payload[segmentName],
    };
    if (segments.isEmpty) {
      return _migrateSegmentEnvelope(
        payload,
        fallbackSnapshot: fallbackSnapshot,
      );
    }
    return _migrateMergedSegments(
      segments,
      serializationVersion: _intOrNull(payload['serializationVersion']),
      fallbackSnapshot: fallbackSnapshot,
    );
  }

  StudyHarmonyProgressSnapshot? _migrateSegmentEnvelope(
    Map<String, Object?> payload, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    final segmentsValue = payload['segments'];
    if (segmentsValue is! Map<Object?, Object?>) {
      return null;
    }
    return _migrateMergedSegments(
      segmentsValue.cast<String, Object?>(),
      serializationVersion: _intOrNull(payload['serializationVersion']),
      fallbackSnapshot: fallbackSnapshot,
    );
  }

  StudyHarmonyProgressSnapshot? _migrateMergedSegments(
    Map<String, Object?> segments, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
    int? serializationVersion,
  }) {
    final merged = _mergeSegments(segments);
    if (merged == null || merged.isEmpty) {
      return null;
    }
    merged.putIfAbsent(
      'serializationVersion',
      () =>
          serializationVersion ??
          StudyHarmonyProgressSnapshot.currentSerializationVersion,
    );
    return _validatedMigratedSnapshot(
      StudyHarmonyProgressSnapshot.fromJsonValue(merged),
      fallbackSnapshot: fallbackSnapshot,
    );
  }

  Map<String, Object?>? _mergeSegments(Map<String, Object?> segments) {
    final merged = <String, Object?>{};
    for (final segmentName in StudyHarmonyProgressCodec.segmentNames) {
      final value = segments[segmentName];
      if (value == null) {
        continue;
      }
      if (value is! Map<Object?, Object?>) {
        return null;
      }
      merged.addAll(value.cast<String, Object?>());
    }
    return merged.isEmpty ? null : merged;
  }

  StudyHarmonyProgressSnapshot _validatedMigratedSnapshot(
    StudyHarmonyProgressSnapshot snapshot, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    final normalized = StudyHarmonyProgressSnapshot.fromJsonValue(
      snapshot.toJson(),
    );
    if (normalized.serializationVersion <= 0) {
      return fallbackSnapshot.copyWith(
        serializationVersion:
            StudyHarmonyProgressSnapshot.currentSerializationVersion,
      );
    }
    return normalized.copyWith(
      serializationVersion:
          StudyHarmonyProgressSnapshot.currentSerializationVersion,
    );
  }

  StudyHarmonyProgressSnapshot _decodeLegacySnapshot(
    String? encoded, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    if (encoded == null || encoded.isEmpty) {
      return fallbackSnapshot;
    }
    try {
      return StudyHarmonyProgressSnapshot.fromJsonValue(jsonDecode(encoded));
    } on FormatException {
      return fallbackSnapshot;
    }
  }

  int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}
