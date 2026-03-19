import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/content/track_pedagogy_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_session_models.dart';
import 'package:chordest/study_harmony/domain/study_harmony_track_profiles.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  TrackPedagogyProfile pedagogyFor(StudyHarmonyTrackId trackId) {
    return trackPedagogyProfileForTrack(l10n, trackId);
  }

  TrackRecommendationProfile recommendationFor(StudyHarmonyTrackId trackId) {
    return trackRecommendationProfileForTrack(l10n, trackId);
  }

  TrackSoundProfile soundFor(StudyHarmonyTrackId trackId) {
    return trackSoundProfileForTrack(l10n, trackId);
  }

  test('track profile metadata distinguishes pop, jazz, and classical', () {
    final popPedagogy = pedagogyFor(studyHarmonyPopTrackId);
    final jazzPedagogy = pedagogyFor(studyHarmonyJazzTrackId);
    final classicalPedagogy = pedagogyFor(studyHarmonyClassicalTrackId);

    final popRecommendation = recommendationFor(studyHarmonyPopTrackId);
    final jazzRecommendation = recommendationFor(studyHarmonyJazzTrackId);
    final classicalRecommendation = recommendationFor(
      studyHarmonyClassicalTrackId,
    );

    final popSound = soundFor(studyHarmonyPopTrackId);
    final jazzSound = soundFor(studyHarmonyJazzTrackId);
    final classicalSound = soundFor(studyHarmonyClassicalTrackId);

    expect(popPedagogy.pedagogyMode, TrackPedagogyMode.grooveAndHookFirst);
    expect(jazzPedagogy.pedagogyMode, TrackPedagogyMode.standardsLanguageFirst);
    expect(
      classicalPedagogy.pedagogyMode,
      TrackPedagogyMode.cadenceAndFunctionFirst,
    );

    expect(
      popPedagogy.prioritySkillTags,
      containsAll(const [
        'pop.loopGravity',
        'pop.borrowedColor',
        'pop.bassMotion',
      ]),
    );
    expect(
      jazzPedagogy.prioritySkillTags,
      containsAll(const [
        'jazz.guideTones',
        'jazz.shellVoicing',
        'jazz.minorCadence',
        'jazz.rootlessVoicing',
        'jazz.dominantColor',
        'jazz.backdoorCadence',
      ]),
    );
    expect(
      classicalPedagogy.prioritySkillTags,
      containsAll(const [
        'classical.cadence',
        'classical.inversion',
        'classical.secondaryDominant',
      ]),
    );

    expect(
      popPedagogy.deemphasizedSkillTags,
      isNot(equals(jazzPedagogy.deemphasizedSkillTags)),
    );
    expect(
      jazzPedagogy.deemphasizedSkillTags,
      isNot(equals(classicalPedagogy.deemphasizedSkillTags)),
    );

    expect(
      popRecommendation.recommendationMode,
      TrackRecommendationMode.songcraftFirst,
    );
    expect(
      jazzRecommendation.recommendationMode,
      TrackRecommendationMode.jazzLanguageGrowth,
    );
    expect(
      classicalRecommendation.recommendationMode,
      TrackRecommendationMode.voiceLeadingDiscipline,
    );

    expect(popSound.soundMode, TrackSoundMode.modernOpen);
    expect(jazzSound.soundMode, TrackSoundMode.dryWarm);
    expect(classicalSound.soundMode, TrackSoundMode.clearFocused);

    expect(popSound.profileId, isNot(equals(jazzSound.profileId)));
    expect(jazzSound.profileId, isNot(equals(classicalSound.profileId)));
    expect(popRecommendation.heroHeadline, isNotEmpty);
    expect(jazzRecommendation.heroHeadline, isNotEmpty);
    expect(classicalRecommendation.heroHeadline, isNotEmpty);
  });

  test(
    'generation profile signatures reflect track-specific harmonic policy',
    () {
      final popProfile = trackGenerationProfileForFlavor(
        studyHarmonyPopTrackId,
        TrackExerciseFlavor.popHookLoop,
      );
      final popBorrowedLift = trackGenerationProfileForFlavor(
        studyHarmonyPopTrackId,
        TrackExerciseFlavor.popBorrowedLift,
      );
      final jazzProfile = trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzDominantColor,
      );
      final jazzShellProfile = trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzShellVoicing,
      );
      final jazzRootlessProfile = trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzRootlessVoicing,
      );
      final jazzBackdoorProfile = trackGenerationProfileForFlavor(
        studyHarmonyJazzTrackId,
        TrackExerciseFlavor.jazzBackdoorCadence,
      );
      final classicalProfile = trackGenerationProfileForFlavor(
        studyHarmonyClassicalTrackId,
        TrackExerciseFlavor.classicalInversion,
      );

      expect(popProfile.differentiationSignature, contains('popModernLoop'));
      expect(
        popProfile.differentiationSignature,
        contains('substituteDominant:0'),
      );
      expect(
        popProfile.differentiationSignature,
        contains('voicings:spread+sus'),
      );
      expect(popProfile.differentiationSignature, contains('melody:'));

      expect(
        popBorrowedLift.differentiationSignature,
        contains('modalInterchange:1'),
      );
      expect(
        popBorrowedLift.differentiationSignature,
        contains('singleNonDiatonic:1'),
      );
      expect(
        popBorrowedLift.differentiationSignature,
        contains('candidateCount:4'),
      );

      expect(
        jazzProfile.differentiationSignature,
        contains('jazzStandardsLab'),
      );
      expect(
        jazzProfile.differentiationSignature,
        contains('substituteDominant:0'),
      );
      expect(
        jazzProfile.differentiationSignature,
        contains('modalInterchange:0'),
      );
      expect(
        jazzProfile.differentiationSignature,
        contains('voicings:rootlessA+rootlessB'),
      );
      expect(jazzProfile.differentiationSignature, contains('tensionSet:'));

      expect(
        jazzShellProfile.differentiationSignature,
        contains('voicings:shell'),
      );
      expect(jazzShellProfile.differentiationSignature, contains('tensions:0'));

      expect(
        jazzRootlessProfile.differentiationSignature,
        contains('voicings:rootlessA+rootlessB'),
      );
      expect(
        jazzRootlessProfile.differentiationSignature,
        contains('tensionSet:13+9'),
      );
      expect(
        jazzRootlessProfile.differentiationSignature,
        contains('singleNonDiatonic:0'),
      );

      expect(
        jazzBackdoorProfile.differentiationSignature,
        contains('substituteDominant:1'),
      );
      expect(
        jazzBackdoorProfile.differentiationSignature,
        contains('modalInterchange:1'),
      );
      expect(
        jazzBackdoorProfile.differentiationSignature,
        contains('voicings:quartal+rootlessA+rootlessB'),
      );

      expect(
        classicalProfile.differentiationSignature,
        contains('classicalCadenceLab'),
      );
      expect(classicalProfile.differentiationSignature, contains('triadsOnly'));
      expect(
        classicalProfile.differentiationSignature,
        contains('substituteDominant:0'),
      );
      expect(
        classicalProfile.differentiationSignature,
        contains('voicings:spread'),
      );

      expect(
        popProfile.differentiationSignature,
        isNot(equals(jazzProfile.differentiationSignature)),
      );
      expect(
        jazzShellProfile.differentiationSignature,
        isNot(equals(jazzRootlessProfile.differentiationSignature)),
      );
      expect(
        jazzRootlessProfile.differentiationSignature,
        isNot(equals(jazzBackdoorProfile.differentiationSignature)),
      );
      expect(
        jazzProfile.differentiationSignature,
        isNot(equals(classicalProfile.differentiationSignature)),
      );
    },
  );
}
