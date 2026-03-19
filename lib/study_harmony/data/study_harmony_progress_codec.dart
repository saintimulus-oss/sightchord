import 'dart:convert';

import '../domain/study_harmony_progress_models.dart';

class StudyHarmonyProgressEncodedArtifacts {
  const StudyHarmonyProgressEncodedArtifacts({
    required this.envelopePayload,
    required this.metadataPayload,
    required this.segmentPayloads,
  });

  final String envelopePayload;
  final String metadataPayload;
  final Map<String, String> segmentPayloads;
}

class StudyHarmonyProgressCodec {
  const StudyHarmonyProgressCodec();

  static const int currentSchemaVersion = 2;
  static const int currentMetadataVersion = 1;
  static const List<String> segmentNames = <String>[
    'profile',
    'lessonState',
    'skillState',
    'dailyState',
    'rewardState',
    'seasonalState',
  ];

  String encodeEnvelope(StudyHarmonyProgressSnapshot snapshot) {
    return encodeArtifacts(snapshot).envelopePayload;
  }

  StudyHarmonyProgressEncodedArtifacts encodeArtifacts(
    StudyHarmonyProgressSnapshot snapshot, {
    String lastGoodSource = 'save',
  }) {
    final snapshotJson = snapshot.toJson();
    final savedAtIso8601 = DateTime.now().toUtc().toIso8601String();
    final segments = _snapshotSegments(snapshotJson);
    final segmentPayloads = <String, String>{
      for (final entry in segments.entries) entry.key: jsonEncode(entry.value),
    };
    final envelope = <String, Object?>{
      'schemaVersion': currentSchemaVersion,
      'serializationVersion': snapshot.serializationVersion,
      'savedAtIso8601': savedAtIso8601,
      'segments': segments,
    };
    final metadata = <String, Object?>{
      'metadataVersion': currentMetadataVersion,
      'schemaVersion': currentSchemaVersion,
      'serializationVersion': snapshot.serializationVersion,
      'savedAtIso8601': savedAtIso8601,
      'lastGoodSource': lastGoodSource,
      'segmentOrder': segmentNames,
      'segmentHashes': <String, String>{
        for (final entry in segmentPayloads.entries)
          entry.key: _fingerprint(entry.value),
      },
    };
    return StudyHarmonyProgressEncodedArtifacts(
      envelopePayload: jsonEncode(envelope),
      metadataPayload: jsonEncode(metadata),
      segmentPayloads: segmentPayloads,
    );
  }

  StudyHarmonyProgressSnapshot decodeEnvelope(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException(
        'Study Harmony progress envelope is not a map.',
      );
    }
    final json = decoded.cast<String, Object?>();
    final schemaVersion = _intOrNull(json['schemaVersion']);

    if (schemaVersion == null &&
        json.containsKey('serializationVersion') &&
        !json.containsKey('segments')) {
      return StudyHarmonyProgressSnapshot.fromJsonValue(json);
    }

    if (schemaVersion != null && schemaVersion > currentSchemaVersion) {
      throw FormatException(
        'Unsupported Study Harmony progress schema version: $schemaVersion.',
      );
    }

    final segmentsValue = json['segments'];
    if (segmentsValue is! Map<Object?, Object?>) {
      throw const FormatException(
        'Study Harmony progress envelope is missing segments.',
      );
    }
    final segments = segmentsValue.cast<String, Object?>();
    final merged = <String, Object?>{};
    for (final segmentKey in segmentNames) {
      final value = segments[segmentKey];
      if (value == null) {
        continue;
      }
      if (value is! Map<Object?, Object?>) {
        throw FormatException(
          'Study Harmony progress segment "$segmentKey" is not a map.',
        );
      }
      merged.addAll(value.cast<String, Object?>());
    }
    if (merged.isEmpty) {
      throw const FormatException('Study Harmony progress envelope is empty.');
    }
    if (!merged.containsKey('serializationVersion')) {
      merged['serializationVersion'] =
          json['serializationVersion'] ??
          StudyHarmonyProgressSnapshot.currentSerializationVersion;
    }
    return StudyHarmonyProgressSnapshot.fromJsonValue(merged);
  }

  StudyHarmonyProgressSnapshot decodeShadowCopy({
    required Map<String, String?> segmentPayloads,
    required String metadataPayload,
  }) {
    final metadata = _decodeMetadata(metadataPayload);
    final segmentOrder = _decodeSegmentOrder(metadata);
    final segmentHashes = _decodeSegmentHashes(metadata);
    final merged = <String, Object?>{};

    for (final segmentName in segmentOrder) {
      final payload = segmentPayloads[segmentName];
      if (payload == null || payload.isEmpty) {
        throw FormatException(
          'Missing Study Harmony progress shadow segment "$segmentName".',
        );
      }
      final expectedHash = segmentHashes[segmentName];
      if (expectedHash == null || expectedHash != _fingerprint(payload)) {
        throw FormatException(
          'Study Harmony progress shadow segment "$segmentName" failed hash validation.',
        );
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<Object?, Object?>) {
        throw FormatException(
          'Study Harmony progress shadow segment "$segmentName" is not a map.',
        );
      }
      merged.addAll(decoded.cast<String, Object?>());
    }

    if (merged.isEmpty) {
      throw const FormatException(
        'Study Harmony progress shadow copy is empty.',
      );
    }
    merged.putIfAbsent(
      'serializationVersion',
      () =>
          _intOrNull(metadata['serializationVersion']) ??
          StudyHarmonyProgressSnapshot.currentSerializationVersion,
    );
    return StudyHarmonyProgressSnapshot.fromJsonValue(merged);
  }

  Map<String, Object?> _snapshotSegments(Map<String, Object?> snapshotJson) {
    return <String, Object?>{
      'profile': _pick(snapshotJson, const [
        'serializationVersion',
        'lastPlayedTrackId',
        'lastPlayedChapterId',
        'lastPlayedLessonId',
      ]),
      'lessonState': _pick(snapshotJson, const [
        'unlockedChapterIds',
        'unlockedLessonIds',
        'lessonResults',
      ]),
      'skillState': _pick(snapshotJson, const [
        'skillMastery',
        'reviewQueueEntries',
      ]),
      'dailyState': _pick(snapshotJson, const [
        'dailyChallengeSeedMetadata',
        'completedDailyChallengeDateKeys',
        'protectedDailyChallengeDateKeys',
        'activityDateKeys',
        'completedFocusChallengeDateKeys',
        'completedSpotlightChallengeDateKeys',
        'completedFrontierQuestDateKeys',
      ]),
      'rewardState': _pick(snapshotJson, const [
        'rewardCurrencyBalances',
        'rewardCurrencySpent',
        'shopPurchaseCount',
        'purchasedUniqueShopItemIds',
        'ownedTitleIds',
        'ownedCosmeticIds',
        'equippedTitleId',
        'equippedCosmeticIds',
        'bestSessionCombo',
        'legendaryChapterIds',
        'relayWinCount',
        'streakSaverCount',
        'questChestCount',
      ]),
      'seasonalState': _pick(snapshotJson, const [
        'awardedWeeklyPlanWeekKeys',
        'awardedDailyQuestChestDateKeys',
        'awardedMonthlyTourMonthKeys',
        'weeklyLeagueScores',
        'monthlySpotlightClearCounts',
        'modeSessionCounts',
        'modeClearCounts',
        'bestDailyChallengeStreak',
        'bestDuetPactStreak',
        'activeLeagueXpBoostDateKey',
        'activeLeagueXpBoostCharges',
      ]),
    };
  }

  Map<String, Object?> _pick(
    Map<String, Object?> snapshotJson,
    List<String> keys,
  ) {
    return <String, Object?>{
      for (final key in keys)
        if (snapshotJson.containsKey(key)) key: snapshotJson[key],
    };
  }

  Map<String, Object?> _decodeMetadata(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<Object?, Object?>) {
      throw const FormatException(
        'Study Harmony progress metadata is not a map.',
      );
    }
    final metadata = decoded.cast<String, Object?>();
    final metadataVersion =
        _intOrNull(metadata['metadataVersion']) ?? currentMetadataVersion;
    if (metadataVersion > currentMetadataVersion) {
      throw FormatException(
        'Unsupported Study Harmony progress metadata version: $metadataVersion.',
      );
    }
    return metadata;
  }

  List<String> _decodeSegmentOrder(Map<String, Object?> metadata) {
    final rawOrder = metadata['segmentOrder'];
    if (rawOrder is! List) {
      throw const FormatException(
        'Study Harmony progress metadata is missing segment order.',
      );
    }
    final order = rawOrder.whereType<String>().toList(growable: false);
    if (order.length != segmentNames.length ||
        !segmentNames.every(order.contains)) {
      throw const FormatException(
        'Study Harmony progress metadata has an invalid segment order.',
      );
    }
    return order;
  }

  Map<String, String> _decodeSegmentHashes(Map<String, Object?> metadata) {
    final rawHashes = metadata['segmentHashes'];
    if (rawHashes is! Map<Object?, Object?>) {
      throw const FormatException(
        'Study Harmony progress metadata is missing segment hashes.',
      );
    }
    final hashes = <String, String>{
      for (final entry in rawHashes.entries)
        if (entry.key is String && entry.value is String)
          entry.key as String: entry.value as String,
    };
    if (hashes.length != segmentNames.length ||
        !segmentNames.every(hashes.containsKey)) {
      throw const FormatException(
        'Study Harmony progress metadata has incomplete segment hashes.',
      );
    }
    return hashes;
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

  String _fingerprint(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}
