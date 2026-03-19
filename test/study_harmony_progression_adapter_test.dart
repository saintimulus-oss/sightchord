import 'dart:math';

import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/integrations/study_harmony_progression_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();
  final adapter = StudyHarmonyProgressionAdapter();

  test('generated task explanations inherit track-specific tone', () {
    final popBlueprint = adapter.buildKeyCenterBlueprint(
      lessonId: 'pop-tone-test',
      blueprintId: 'pop-tone-test:key',
      l10n: l10n,
      generationProfile: trackGenerationProfileForFlavor(
        studyHarmonyPopTrackId,
        TrackExerciseFlavor.popBorrowedLift,
      ),
      allowNonDiatonicOverride: true,
    );
    final jazzBlueprint = adapter.buildFunctionBlueprint(
      lessonId: 'jazz-tone-test',
      blueprintId: 'jazz-tone-test:function',
      l10n: l10n,
      generationProfile: trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzDominantColor,
      ),
      allowNonDiatonicOverride: true,
    );
    final classicalBlueprint = adapter.buildFunctionBlueprint(
      lessonId: 'classical-tone-test',
      blueprintId: 'classical-tone-test:function',
      l10n: l10n,
      generationProfile: trackGenerationProfileForFlavor(
        studyHarmonyClassicalTrackId,
        TrackExerciseFlavor.classicalCadence,
      ),
    );

    final popTask = popBlueprint.createInstance(
      sequenceNumber: 1,
      random: Random(21),
    );
    final jazzTask = jazzBlueprint.createInstance(
      sequenceNumber: 1,
      random: Random(22),
    );
    final classicalTask = classicalBlueprint.createInstance(
      sequenceNumber: 1,
      random: Random(23),
    );

    expect(popTask.explanationBody, contains(l10n.studyHarmonyTrackPopTheoryTone));
    expect(popTask.explanationBody, contains(l10n.studyHarmonyTrackPopFocus2));
    expect(
      jazzTask.explanationBody,
      contains(l10n.studyHarmonyTrackJazzTheoryTone),
    );
    expect(jazzTask.explanationBody, contains(l10n.studyHarmonyTrackJazzFocus3));
    expect(
      classicalTask.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalTheoryTone),
    );
    expect(
      classicalTask.explanationBody,
      contains(l10n.studyHarmonyTrackClassicalFocus1),
    );
  });
}
