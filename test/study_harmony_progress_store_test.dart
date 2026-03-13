import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/study_harmony/data/study_harmony_progress_store.dart';
import 'package:sightchord/study_harmony/domain/study_harmony_progress_models.dart';

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

      const store = SharedPrefsStudyHarmonyProgressStore();
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
    },
  );
}
