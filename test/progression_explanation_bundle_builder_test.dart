import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/music/explanation_models.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:chordest/music/progression_explanation_bundle_builder.dart';
import 'package:chordest/study_harmony/content/study_harmony_track_catalog.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const analyzer = ProgressionAnalyzer();
  const builder = ProgressionExplanationBundleBuilder();
  final l10n = AppLocalizationsEn();

  test(
    'builder maps functional jazz cadences into structured explanation tags',
    () {
      final analysis = analyzer.analyze('Dm7 G7 Cmaj7');
      final bundle = builder.build(
        l10n: l10n,
        analysis: analysis,
        trackId: studyHarmonyJazzTrackId,
        exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
      );

      expect(bundle.summary, isNotEmpty);
      expect(bundle.trackContext, isNotNull);
      expect(
        bundle.reasonTags.map((tag) => tag.code),
        contains(ReasonCode.functionalResolution),
      );
      expect(
        bundle.reasonTags.map((tag) => tag.code),
        contains(ReasonCode.guideToneSmoothness),
      );
      expect(bundle.confidenceBadge, isNotNull);
    },
  );

  test('builder highlights borrowed-color readings for pop contexts', () {
    final analysis = analyzer.analyze('Cmaj7 Bbmaj7 Fmaj7 Cmaj7');
    final bundle = builder.build(
      l10n: l10n,
      analysis: analysis,
      trackId: studyHarmonyPopTrackId,
      exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
    );

    expect(
      bundle.reasonTags.map((tag) => tag.code),
      contains(ReasonCode.borrowedColor),
    );
    expect(bundle.listeningHints, isNotEmpty);
    expect(bundle.performanceHints, isNotEmpty);
  });

  test('builder track context reflects exercise-specific pedagogy focus', () {
    final popBundle = builder.build(
      l10n: l10n,
      analysis: analyzer.analyze('Cmaj7 Bbmaj7 Fmaj7 Cmaj7'),
      trackId: studyHarmonyPopTrackId,
      exerciseFlavor: TrackExerciseFlavor.popBorrowedLift,
    );
    final jazzBundle = builder.build(
      l10n: l10n,
      analysis: analyzer.analyze('Dm7 G7 Cmaj7'),
      trackId: studyHarmonyJazzTrackId,
      exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
    );
    final jazzReharmBundle = builder.build(
      l10n: l10n,
      analysis: analyzer.analyze('Fm7 Bb7 Cmaj7'),
      trackId: studyHarmonyJazzTrackId,
      exerciseFlavor: TrackExerciseFlavor.jazzBackdoorCadence,
    );
    final classicalBundle = builder.build(
      l10n: l10n,
      analysis: analyzer.analyze('C F G C'),
      trackId: studyHarmonyClassicalTrackId,
      exerciseFlavor: TrackExerciseFlavor.classicalCadence,
    );

    expect(popBundle.trackContext, contains(l10n.studyHarmonyTrackPopFocus2));
    expect(jazzBundle.trackContext, contains(l10n.studyHarmonyTrackJazzFocus1));
    expect(
      jazzReharmBundle.trackContext,
      contains(l10n.studyHarmonyTrackJazzFocus3),
    );
    expect(jazzReharmBundle.listeningHints, isNotEmpty);
    expect(
      classicalBundle.trackContext,
      contains(l10n.studyHarmonyTrackClassicalFocus1),
    );
  });

  test('builder surfaces ambiguity captions and competing readings', () {
    final analysis = analyzer.analyze('Db7 Cmaj7');
    final bundle = builder.build(
      l10n: l10n,
      analysis: analysis,
      focusChord: analysis.chordAnalyses.first,
    );

    expect(bundle.ambiguityValue, greaterThan(0));
    expect(bundle.ambiguityCaption, isNotNull);
    expect(
      bundle.reasonTags.map((tag) => tag.code),
      contains(ReasonCode.ambiguityWindow),
    );
    expect(
      bundle.reasonTags.map((tag) => tag.code),
      contains(ReasonCode.tritoneSubColor),
    );
    expect(bundle.alternativeInterpretations, isNotEmpty);
  });

  test(
    'builder maps dominant color and backdoor bundles into focused hints',
    () {
      final dominantBundle = builder.build(
        l10n: l10n,
        analysis: analyzer.analyze('C7(b9, #11) Fmaj7'),
        trackId: studyHarmonyJazzTrackId,
        exerciseFlavor: TrackExerciseFlavor.jazzDominantColor,
      );
      final backdoorBundle = builder.build(
        l10n: l10n,
        analysis: analyzer.analyze('Fm7 Bb7 Cmaj7'),
        trackId: studyHarmonyJazzTrackId,
        exerciseFlavor: TrackExerciseFlavor.jazzBackdoorCadence,
      );

      expect(
        dominantBundle.reasonTags.map((tag) => tag.code),
        contains(ReasonCode.dominantColor),
      );
      expect(
        dominantBundle.listeningHints.map((hint) => hint.title),
        contains(l10n.explanationListeningDominantColorTitle),
      );
      expect(
        dominantBundle.performanceHints.map((hint) => hint.title),
        contains(l10n.explanationPerformanceDominantColorTitle),
      );

      expect(
        backdoorBundle.reasonTags.map((tag) => tag.code),
        contains(ReasonCode.backdoorMotion),
      );
      expect(
        backdoorBundle.listeningHints.map((hint) => hint.title),
        contains(l10n.explanationListeningBackdoorTitle),
      );
    },
  );

  test(
    'builder prioritizes parser caution and preserves alternate-key context',
    () {
      final analysis = analyzer.analyze('Cmaj7 H7 G7');
      final bundle = builder.build(l10n: l10n, analysis: analysis);

      expect(bundle.caution, l10n.explanationCautionParser);
      expect(bundle.confidenceBadge, isNotNull);
      expect(bundle.ambiguityCaption, isNotNull);
      expect(bundle.alternativeInterpretations, isNotEmpty);
    },
  );

  test(
    'builder exposes competing readings for inferred placeholder chords',
    () {
      final analysis = analyzer.analyze('Dm7 - G7 - ? - Am7');
      final focusChord = analysis.chordAnalyses[2];
      final bundle = builder.build(
        l10n: l10n,
        analysis: analysis,
        trackId: studyHarmonyJazzTrackId,
        exerciseFlavor: TrackExerciseFlavor.jazzGuideTone,
        focusChord: focusChord,
      );

      expect(bundle.caution, isNotNull);
      expect(bundle.alternativeInterpretations, isNotEmpty);
      expect(
        bundle.reasonTags.map((tag) => tag.code),
        contains(ReasonCode.ambiguityWindow),
      );
    },
  );
}
