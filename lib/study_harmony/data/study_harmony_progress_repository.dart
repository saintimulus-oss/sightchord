import 'package:shared_preferences/shared_preferences.dart';

import '../domain/study_harmony_progress_models.dart';
import 'study_harmony_progress_codec.dart';
import 'study_harmony_progress_migrator.dart';
import 'study_harmony_progress_storage_keys.dart';

class StudyHarmonyProgressRepository {
  const StudyHarmonyProgressRepository({
    Future<SharedPreferences> Function() preferencesLoader =
        SharedPreferences.getInstance,
    StudyHarmonyProgressCodec codec = const StudyHarmonyProgressCodec(),
    StudyHarmonyProgressMigrator migrator =
        const StudyHarmonyProgressMigrator(),
  }) : _preferencesLoader = preferencesLoader,
       _codec = codec,
       _migrator = migrator;

  final Future<SharedPreferences> Function() _preferencesLoader;
  final StudyHarmonyProgressCodec _codec;
  final StudyHarmonyProgressMigrator _migrator;

  static const String _primarySource = 'primary';
  static const String _backupSource = 'backup';
  static const String _lastKnownGoodSource = 'lastKnownGood';
  static const String _shadowSource = 'shadow';
  static const String _legacySource = 'legacy';
  static const String _saveSource = 'save';

  Future<StudyHarmonyProgressSnapshot> load({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) async {
    final preferences = await _preferencesLoader();
    final primaryPayload = preferences.getString(
      StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
    );
    if (primaryPayload != null && primaryPayload.isNotEmpty) {
      try {
        final snapshot = _decodeOrMigrateEnvelopePayload(
          primaryPayload,
          fallbackSnapshot: fallbackSnapshot,
        );
        final normalizedEnvelope = _codec.encodeEnvelope(snapshot);
        await preferences.setString(
          StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
          normalizedEnvelope,
        );
        await _writeDerivedArtifacts(
          preferences,
          snapshot,
          lastGoodSource: _primarySource,
          envelopePayload: normalizedEnvelope,
        );
        return snapshot;
      } on FormatException {
        await preferences.setString(
          StudyHarmonyProgressStorageKeys.corruptEnvelopeKey,
          primaryPayload,
        );
      }
    }

    final backupPayload = preferences.getString(
      StudyHarmonyProgressStorageKeys.backupEnvelopeKey,
    );
    if (backupPayload != null && backupPayload.isNotEmpty) {
      try {
        final restored = _decodeOrMigrateEnvelopePayload(
          backupPayload,
          fallbackSnapshot: fallbackSnapshot,
        );
        await _commitRecoveredSnapshot(
          preferences,
          restored,
          lastGoodSource: _backupSource,
        );
        return restored;
      } on FormatException {
        await preferences.setString(
          StudyHarmonyProgressStorageKeys.corruptBackupEnvelopeKey,
          backupPayload,
        );
      }
    }

    final lastKnownGoodPayload = preferences.getString(
      StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey,
    );
    if (lastKnownGoodPayload != null && lastKnownGoodPayload.isNotEmpty) {
      try {
        final restored = _decodeOrMigrateEnvelopePayload(
          lastKnownGoodPayload,
          fallbackSnapshot: fallbackSnapshot,
        );
        await _commitRecoveredSnapshot(
          preferences,
          restored,
          lastGoodSource: _lastKnownGoodSource,
        );
        return restored;
      } on FormatException {
        await preferences.setString(
          StudyHarmonyProgressStorageKeys.corruptLastKnownGoodEnvelopeKey,
          lastKnownGoodPayload,
        );
      }
    }

    final shadowRestored = _tryRestoreShadowCopy(preferences);
    if (shadowRestored != null) {
      await _commitRecoveredSnapshot(
        preferences,
        shadowRestored,
        lastGoodSource: _shadowSource,
      );
      return shadowRestored;
    }

    final migrated = _migrator.migrateLegacy(
      fallbackSnapshot: fallbackSnapshot,
      legacyProgressPayload: preferences.getString(
        StudyHarmonyProgressStorageKeys.legacyProgressKey,
      ),
      legacyDailySeedPayload: preferences.getString(
        StudyHarmonyProgressStorageKeys.legacyDailySeedKey,
      ),
    );

    if (migrated != null) {
      await _commitRecoveredSnapshot(
        preferences,
        migrated,
        lastGoodSource: _legacySource,
      );
      return migrated;
    }

    return fallbackSnapshot;
  }

  Future<void> save(StudyHarmonyProgressSnapshot snapshot) async {
    final preferences = await _preferencesLoader();
    final artifacts = _codec.encodeArtifacts(
      snapshot,
      lastGoodSource: _saveSource,
    );
    final currentPrimary = preferences.getString(
      StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
    );
    final currentLastKnownGood = preferences.getString(
      StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey,
    );
    final backupPayload = _hasPayload(currentPrimary)
        ? currentPrimary!
        : _hasPayload(currentLastKnownGood)
        ? currentLastKnownGood!
        : artifacts.envelopePayload;

    await preferences.setString(
      StudyHarmonyProgressStorageKeys.backupEnvelopeKey,
      backupPayload,
    );
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
      artifacts.envelopePayload,
    );
    await _writeDerivedArtifacts(
      preferences,
      snapshot,
      lastGoodSource: _saveSource,
      artifacts: artifacts,
      envelopePayload: artifacts.envelopePayload,
    );
  }

  StudyHarmonyProgressSnapshot? _tryRestoreShadowCopy(
    SharedPreferences preferences,
  ) {
    final metadataPayload = preferences.getString(
      StudyHarmonyProgressStorageKeys.progressMetadataKey,
    );
    if (!_hasPayload(metadataPayload)) {
      return null;
    }

    final segmentPayloads = <String, String?>{
      for (final segmentName in StudyHarmonyProgressCodec.segmentNames)
        segmentName: preferences.getString(
          StudyHarmonyProgressStorageKeys.shadowSegmentKey(segmentName),
        ),
    };
    try {
      return _codec.decodeShadowCopy(
        segmentPayloads: segmentPayloads,
        metadataPayload: metadataPayload!,
      );
    } on FormatException {
      return null;
    }
  }

  Future<void> _commitRecoveredSnapshot(
    SharedPreferences preferences,
    StudyHarmonyProgressSnapshot snapshot, {
    required String lastGoodSource,
  }) async {
    final artifacts = _codec.encodeArtifacts(
      snapshot,
      lastGoodSource: lastGoodSource,
    );
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.backupEnvelopeKey,
      artifacts.envelopePayload,
    );
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.progressEnvelopeKey,
      artifacts.envelopePayload,
    );
    await _writeDerivedArtifacts(
      preferences,
      snapshot,
      lastGoodSource: lastGoodSource,
      artifacts: artifacts,
    );
  }

  Future<void> _writeDerivedArtifacts(
    SharedPreferences preferences,
    StudyHarmonyProgressSnapshot snapshot, {
    required String lastGoodSource,
    StudyHarmonyProgressEncodedArtifacts? artifacts,
    String? envelopePayload,
  }) async {
    final effectiveArtifacts =
        artifacts ??
        _codec.encodeArtifacts(snapshot, lastGoodSource: lastGoodSource);

    await preferences.setString(
      StudyHarmonyProgressStorageKeys.lastKnownGoodEnvelopeKey,
      envelopePayload ?? effectiveArtifacts.envelopePayload,
    );
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.progressMetadataKey,
      effectiveArtifacts.metadataPayload,
    );
    for (final entry in effectiveArtifacts.segmentPayloads.entries) {
      await preferences.setString(
        StudyHarmonyProgressStorageKeys.shadowSegmentKey(entry.key),
        entry.value,
      );
    }
    await _writeLegacyCompatibility(preferences, snapshot);
  }

  Future<void> _writeLegacyCompatibility(
    SharedPreferences preferences,
    StudyHarmonyProgressSnapshot snapshot,
  ) async {
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.legacyProgressKey,
      snapshot.encode(),
    );
    final dailySeed = snapshot.dailyChallengeSeedMetadata;
    if (dailySeed == null) {
      await preferences.remove(
        StudyHarmonyProgressStorageKeys.legacyDailySeedKey,
      );
      return;
    }
    await preferences.setString(
      StudyHarmonyProgressStorageKeys.legacyDailySeedKey,
      dailySeed.encode(),
    );
  }

  bool _hasPayload(String? payload) => payload != null && payload.isNotEmpty;

  StudyHarmonyProgressSnapshot _decodeOrMigrateEnvelopePayload(
    String payload, {
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) {
    try {
      return _codec.decodeEnvelope(payload);
    } on FormatException {
      final migrated = _migrator.migrateEnvelopePayload(
        encodedPayload: payload,
        fallbackSnapshot: fallbackSnapshot,
      );
      if (migrated != null) {
        return migrated;
      }
      rethrow;
    }
  }
}
