import 'package:shared_preferences/shared_preferences.dart';

import '../domain/study_harmony_progress_models.dart';
import 'study_harmony_progress_repository.dart';

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
  SharedPrefsStudyHarmonyProgressStore({
    StudyHarmonySharedPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _repository = StudyHarmonyProgressRepository(
         preferencesLoader: preferencesLoader,
       );

  final StudyHarmonyProgressRepository _repository;

  @override
  Future<StudyHarmonyProgressSnapshot> load({
    required StudyHarmonyProgressSnapshot fallbackSnapshot,
  }) => _repository.load(fallbackSnapshot: fallbackSnapshot);

  @override
  Future<void> save(StudyHarmonyProgressSnapshot snapshot) =>
      _repository.save(snapshot);
}
