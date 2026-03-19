import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/integrations/study_harmony_generator_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final adapter = StudyHarmonyGeneratorAdapter();

  test('pop bass-motion profile lands on slash-bass material', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(11),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyPopTrackId,
        TrackExerciseFlavor.popBassMotion,
      ),
    );

    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) => analysis.chord.hasSlashBass,
      ),
      isTrue,
    );
    expect(progression.nonDiatonicAnalyses, isEmpty);
  });

  test('pop borrowed-lift profile keeps a single borrowed-color event', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(12),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyPopTrackId,
        TrackExerciseFlavor.popBorrowedLift,
      ),
    );

    expect(progression.nonDiatonicAnalyses.length, 1);
    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.hasRemark(
              ProgressionRemarkKind.possibleModalInterchange,
            ) ||
            analysis.hasRemark(ProgressionRemarkKind.subdominantMinor),
      ),
      isTrue,
    );
  });

  test('jazz guide-tone profile stays on a clear major ii-V-I lane', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(21),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzGuideTone,
      ),
    );

    expect(progression.nonDiatonicAnalyses, isEmpty);
    expect(progression.analysis.tags, contains(ProgressionTagId.iiVI));
    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.sourceKind == ChordSourceKind.substituteDominant ||
            analysis.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
            analysis.hasRemark(ProgressionRemarkKind.backdoorChain),
      ),
      isFalse,
    );
  });

  test('jazz shell-voicing profile leans into clean turnaround motion', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(22),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzShellVoicing,
      ),
    );

    expect(progression.nonDiatonicAnalyses, isEmpty);
    expect(
      progression.analysis.tags,
      anyOf(
        contains(ProgressionTagId.iiVI),
        contains(ProgressionTagId.dominantResolution),
      ),
    );
    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.chord.tensions.isNotEmpty ||
            analysis.chord.alterations.isNotEmpty ||
            analysis.chord.suspensions.isNotEmpty,
      ),
      isFalse,
    );
  });

  test('jazz minor-cadence profile includes ii half-diminished pull', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(23),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzMinorCadence,
      ),
    );

    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.chord.displayQuality == ChordQuality.halfDiminished7,
      ),
      isTrue,
    );
    expect(
      progression.analysis.tags,
      anyOf(
        contains(ProgressionTagId.iiVI),
        contains(ProgressionTagId.dominantResolution),
      ),
    );
  });

  test(
    'jazz rootless-voicing profile adds extensions without reharm color',
    () {
      final progression = adapter.generateProgressionForProfile(
        random: Random(24),
        profile: trackGenerationProfileForFlavor(
          studyHarmonyJazzTrackId,
          TrackExerciseFlavor.jazzRootlessVoicing,
        ),
      );

      expect(progression.nonDiatonicAnalyses, isEmpty);
      expect(
        progression.analysis.tags,
        anyOf(
          contains(ProgressionTagId.iiVI),
          contains(ProgressionTagId.dominantResolution),
        ),
      );
      expect(
        progression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.chord.tensions.isNotEmpty ||
              analysis.chord.addedTones.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        progression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.substituteDominant ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorChain),
        ),
        isFalse,
      );
    },
  );

  test(
    'jazz dominant-color profile surfaces non-diatonic dominant tension',
    () {
      final progression = adapter.generateProgressionForProfile(
        random: Random(25),
        profile: trackGenerationProfileForFlavor(
          studyHarmonyJazzTrackId,
          TrackExerciseFlavor.jazzDominantColor,
        ),
      );

      expect(progression.nonDiatonicAnalyses, isNotEmpty);
      expect(
        progression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.secondaryDominant ||
              analysis.chord.suspensions.isNotEmpty ||
              analysis.chord.tensions.isNotEmpty ||
              analysis.chord.alterations.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        progression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.substituteDominant ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorChain),
        ),
        isFalse,
      );
    },
  );

  test('jazz reharm profile reaches tritone or backdoor cadence color', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(26),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzBackdoorCadence,
      ),
    );

    expect(progression.nonDiatonicAnalyses, isNotEmpty);
    expect(
      progression.analysis.chordAnalyses.any(
            (analysis) =>
                analysis.sourceKind == ChordSourceKind.substituteDominant ||
                analysis.hasRemark(
                  ProgressionRemarkKind.possibleTritoneSubstitute,
                ),
          ) ||
          progression.analysis.tags.contains(ProgressionTagId.backdoorChain),
      isTrue,
    );
  });

  test('classical secondary-dominant profile avoids jazz-substitute color', () {
    final progression = adapter.generateProgressionForProfile(
      random: Random(14),
      profile: trackGenerationProfileForFlavor(
        studyHarmonyClassicalTrackId,
        TrackExerciseFlavor.classicalSecondaryDominant,
      ),
    );

    expect(progression.nonDiatonicAnalyses.length, 1);
    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.sourceKind == ChordSourceKind.secondaryDominant ||
            analysis.hasRemark(ProgressionRemarkKind.possibleSecondaryDominant),
      ),
      isTrue,
    );
    expect(
      progression.analysis.chordAnalyses.any(
        (analysis) =>
            analysis.sourceKind == ChordSourceKind.substituteDominant ||
            analysis.hasRemark(ProgressionRemarkKind.possibleTritoneSubstitute),
      ),
      isFalse,
    );
  });

  test('track preset families stay separated across representative seeds', () {
    final popSeeds = <int>[11, 31, 41];
    for (final seed in popSeeds) {
      final popProgression = adapter.generateProgressionForProfile(
        random: Random(seed),
        profile: trackGenerationProfileForFlavor(
          studyHarmonyPopTrackId,
          TrackExerciseFlavor.popHookLoop,
        ),
      );

      expect(
        popProgression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.substituteDominant ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorChain),
        ),
        isFalse,
        reason:
            'pop hook loop should stay out of jazz reharm space (seed $seed)',
      );
      expect(
        popProgression.nonDiatonicAnalyses,
        isEmpty,
        reason: 'pop hook loop should remain diatonic by default (seed $seed)',
      );
    }

    final jazzReharmDetected = <int>[26, 27, 28, 29].any((seed) {
      final jazzProgression = adapter.generateProgressionForProfile(
        random: Random(seed),
        profile: trackGenerationProfileForFlavor(
          studyHarmonyJazzTrackId,
          TrackExerciseFlavor.jazzBackdoorCadence,
        ),
      );
      return jazzProgression.analysis.chordAnalyses.any(
            (analysis) =>
                analysis.sourceKind == ChordSourceKind.substituteDominant ||
                analysis.hasRemark(
                  ProgressionRemarkKind.possibleTritoneSubstitute,
                ),
          ) ||
          jazzProgression.analysis.tags.contains(
            ProgressionTagId.backdoorChain,
          );
    });

    expect(jazzReharmDetected, isTrue);

    final classicalSeeds = <int>[14, 24, 34];
    for (final seed in classicalSeeds) {
      final classicalProgression = adapter.generateProgressionForProfile(
        random: Random(seed),
        profile: trackGenerationProfileForFlavor(
          studyHarmonyClassicalTrackId,
          TrackExerciseFlavor.classicalSecondaryDominant,
        ),
      );

      expect(
        classicalProgression.analysis.chordAnalyses.any(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.substituteDominant ||
              analysis.hasRemark(
                ProgressionRemarkKind.possibleTritoneSubstitute,
              ) ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorDominant),
        ),
        isFalse,
        reason:
            'classical secondary dominant should avoid jazz reharm color (seed $seed)',
      );
    }
  });
}
