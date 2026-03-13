import 'package:shared_preferences/shared_preferences.dart';

import '../domain/study_harmony_progress_models.dart';

typedef StudyHarmonySharedPreferencesLoader =
    Future<SharedPreferences> Function();

abstract class StudyHarmonyProgressStore {
  Future<StudyHarmonyProgressSnapshot> load({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  });

  Future<void> save(StudyHarmonyProgressSnapshot snapshot);
}

class SharedPrefsStudyHarmonyProgressStore
    implements StudyHarmonyProgressStore {
  const SharedPrefsStudyHarmonyProgressStore({
    StudyHarmonySharedPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String progressKey = 'studyHarmony.progress.v1';
  static const String dailySeedKey = 'studyHarmony.dailySeed';

  final StudyHarmonySharedPreferencesLoader _preferencesLoader;

  @override
  Future<StudyHarmonyProgressSnapshot> load({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) async {
    final preferences = await _preferencesLoader();
    final storedProgress = preferences.getString(progressKey);
    final storedDailySeed = preferences.getString(dailySeedKey);

    final baseSnapshot = storedProgress == null
        ? fallbackSnapshot
        : StudyHarmonyProgressSnapshot.fromEncoded(storedProgress);
    final dailySeed = StudyHarmonyDailyChallengeSeedMetadata.fromEncoded(
      storedDailySeed,
    );

    if (dailySeed == null) {
      return baseSnapshot;
    }
    return baseSnapshot.copyWith(dailyChallengeSeedMetadata: dailySeed);
  }

  @override
  Future<void> save(StudyHarmonyProgressSnapshot snapshot) async {
    final preferences = await _preferencesLoader();
    await preferences.setString(progressKey, snapshot.encode());

    final dailySeed = snapshot.dailyChallengeSeedMetadata;
    if (dailySeed == null) {
      await preferences.remove(dailySeedKey);
      return;
    }
    await preferences.setString(dailySeedKey, dailySeed.encode());
  }
}
