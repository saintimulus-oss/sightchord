class StudyHarmonyProgressStorageKeys {
  static const String legacyProgressKey = 'studyHarmony.progress.v1';
  static const String legacyDailySeedKey = 'studyHarmony.dailySeed';

  static const String progressEnvelopeKey = 'studyHarmony.progress.v2';
  static const String backupEnvelopeKey = 'studyHarmony.progress.v2.backup';
  static const String lastKnownGoodEnvelopeKey =
      'studyHarmony.progress.v2.lastGood';
  static const String progressMetadataKey = 'studyHarmony.progress.v2.meta';
  static const String corruptEnvelopeKey = 'studyHarmony.progress.v2.corrupt';
  static const String corruptBackupEnvelopeKey =
      'studyHarmony.progress.v2.backup.corrupt';
  static const String corruptLastKnownGoodEnvelopeKey =
      'studyHarmony.progress.v2.lastGood.corrupt';

  static String shadowSegmentKey(String segmentName) =>
      'studyHarmony.progress.v2.segment.$segmentName';

  const StudyHarmonyProgressStorageKeys._();
}
