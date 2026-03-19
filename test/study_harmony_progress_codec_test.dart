import 'dart:convert';

import 'package:chordest/study_harmony/data/study_harmony_progress_codec.dart';
import 'package:chordest/study_harmony/domain/study_harmony_progress_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const codec = StudyHarmonyProgressCodec();

  test('codec round-trips the current envelope format', () {
    const snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion: 14,
      lastPlayedTrackId: 'jazz',
      unlockedChapterIds: {'chapter-1'},
      unlockedLessonIds: {'lesson-1', 'lesson-2'},
      rewardCurrencyBalances: {'credits': 24},
    );

    final encoded = codec.encodeEnvelope(snapshot);
    final restored = codec.decodeEnvelope(encoded);

    expect(restored.lastPlayedTrackId, 'jazz');
    expect(restored.unlockedChapterIds, contains('chapter-1'));
    expect(
      restored.unlockedLessonIds,
      containsAll(const {'lesson-1', 'lesson-2'}),
    );
    expect(restored.rewardCurrencyBalances['credits'], 24);
  });

  test('codec round-trips a shadow copy with metadata hashes', () {
    const snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion: 14,
      unlockedChapterIds: {'chapter-shadow'},
      bestSessionCombo: 12,
    );

    final artifacts = codec.encodeArtifacts(snapshot);
    final restored = codec.decodeShadowCopy(
      segmentPayloads: artifacts.segmentPayloads,
      metadataPayload: artifacts.metadataPayload,
    );

    expect(restored.unlockedChapterIds, contains('chapter-shadow'));
    expect(restored.bestSessionCombo, 12);
  });

  test('codec accepts raw snapshot payloads for backward compatibility', () {
    const snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion: 14,
      unlockedLessonIds: {'legacy-lesson'},
    );

    final restored = codec.decodeEnvelope(snapshot.encode());

    expect(restored.unlockedLessonIds, contains('legacy-lesson'));
  });

  test('codec rejects tampered shadow payloads', () {
    const snapshot = StudyHarmonyProgressSnapshot(
      serializationVersion: 14,
      unlockedLessonIds: {'lesson-safe'},
    );
    final artifacts = codec.encodeArtifacts(snapshot);
    final tampered = Map<String, String>.from(artifacts.segmentPayloads)
      ..['lessonState'] = jsonEncode(<String, Object?>{
        'unlockedLessonIds': <String>['lesson-tampered'],
      });

    expect(
      () => codec.decodeShadowCopy(
        segmentPayloads: tampered,
        metadataPayload: artifacts.metadataPayload,
      ),
      throwsFormatException,
    );
  });
}
