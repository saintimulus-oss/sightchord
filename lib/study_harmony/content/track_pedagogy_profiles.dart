import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_track_profiles.dart';

TrackPedagogyProfile trackPedagogyProfileForTrack(
  AppLocalizations l10n,
  StudyHarmonyTrackId trackId,
) {
  return switch (trackId) {
    studyHarmonyPopTrackId => TrackPedagogyProfile(
      trackId: trackId,
      pedagogyMode: TrackPedagogyMode.grooveAndHookFirst,
      focusPoints: [
        l10n.studyHarmonyTrackPopFocus1,
        l10n.studyHarmonyTrackPopFocus2,
        l10n.studyHarmonyTrackPopFocus3,
      ],
      lighterFocusPoints: [
        l10n.studyHarmonyTrackPopLess1,
        l10n.studyHarmonyTrackPopLess2,
      ],
      prioritySkillTags: const [
        'pop.loopGravity',
        'pop.borrowedColor',
        'pop.bassMotion',
      ],
      deemphasizedSkillTags: const [
        'jazz.guideTones',
        'jazz.dominantColor',
        'classical.secondaryDominant',
      ],
      recommendedFor: l10n.studyHarmonyTrackPopRecommendedFor,
      theoryTone: l10n.studyHarmonyTrackPopTheoryTone,
    ),
    studyHarmonyJazzTrackId => TrackPedagogyProfile(
      trackId: trackId,
      pedagogyMode: TrackPedagogyMode.standardsLanguageFirst,
      focusPoints: [
        l10n.studyHarmonyTrackJazzFocus1,
        l10n.studyHarmonyTrackJazzFocus2,
        l10n.studyHarmonyTrackJazzFocus3,
      ],
      lighterFocusPoints: [
        l10n.studyHarmonyTrackJazzLess1,
        l10n.studyHarmonyTrackJazzLess2,
      ],
      prioritySkillTags: const [
        'jazz.guideTones',
        'jazz.shellVoicing',
        'jazz.minorCadence',
        'jazz.rootlessVoicing',
        'jazz.dominantColor',
        'jazz.backdoorCadence',
      ],
      deemphasizedSkillTags: const [
        'pop.loopGravity',
        'pop.bassMotion',
        'classical.cadence',
      ],
      recommendedFor: l10n.studyHarmonyTrackJazzRecommendedFor,
      theoryTone: l10n.studyHarmonyTrackJazzTheoryTone,
    ),
    studyHarmonyClassicalTrackId => TrackPedagogyProfile(
      trackId: trackId,
      pedagogyMode: TrackPedagogyMode.cadenceAndFunctionFirst,
      focusPoints: [
        l10n.studyHarmonyTrackClassicalFocus1,
        l10n.studyHarmonyTrackClassicalFocus2,
        l10n.studyHarmonyTrackClassicalFocus3,
      ],
      lighterFocusPoints: [
        l10n.studyHarmonyTrackClassicalLess1,
        l10n.studyHarmonyTrackClassicalLess2,
      ],
      prioritySkillTags: const [
        'classical.cadence',
        'classical.inversion',
        'classical.secondaryDominant',
      ],
      deemphasizedSkillTags: const [
        'pop.borrowedColor',
        'jazz.dominantColor',
        'jazz.minorCadence',
      ],
      recommendedFor: l10n.studyHarmonyTrackClassicalRecommendedFor,
      theoryTone: l10n.studyHarmonyTrackClassicalTheoryTone,
    ),
    _ => TrackPedagogyProfile(
      trackId: trackId,
      pedagogyMode: TrackPedagogyMode.grooveAndHookFirst,
      focusPoints: const <String>[],
      lighterFocusPoints: const <String>[],
      prioritySkillTags: const <String>[],
      deemphasizedSkillTags: const <String>[],
      recommendedFor: l10n.studyHarmonyCoreTrackDescription,
      theoryTone: l10n.studyHarmonyCoreTrackDescription,
    ),
  };
}

TrackRecommendationProfile trackRecommendationProfileForTrack(
  AppLocalizations l10n,
  StudyHarmonyTrackId trackId,
) {
  return switch (trackId) {
    studyHarmonyPopTrackId => TrackRecommendationProfile(
      trackId: trackId,
      recommendationMode: TrackRecommendationMode.songcraftFirst,
      heroHeadline: l10n.studyHarmonyTrackPopHeroHeadline,
      heroBody: l10n.studyHarmonyTrackPopHeroBody,
      quickPracticeCue: l10n.studyHarmonyTrackPopQuickPracticeCue,
    ),
    studyHarmonyJazzTrackId => TrackRecommendationProfile(
      trackId: trackId,
      recommendationMode: TrackRecommendationMode.jazzLanguageGrowth,
      heroHeadline: l10n.studyHarmonyTrackJazzHeroHeadline,
      heroBody: l10n.studyHarmonyTrackJazzHeroBody,
      quickPracticeCue: l10n.studyHarmonyTrackJazzQuickPracticeCue,
    ),
    studyHarmonyClassicalTrackId => TrackRecommendationProfile(
      trackId: trackId,
      recommendationMode: TrackRecommendationMode.voiceLeadingDiscipline,
      heroHeadline: l10n.studyHarmonyTrackClassicalHeroHeadline,
      heroBody: l10n.studyHarmonyTrackClassicalHeroBody,
      quickPracticeCue: l10n.studyHarmonyTrackClassicalQuickPracticeCue,
    ),
    _ => TrackRecommendationProfile(
      trackId: trackId,
      recommendationMode: TrackRecommendationMode.songcraftFirst,
      heroHeadline: l10n.studyHarmonyCoreTrackTitle,
      heroBody: l10n.studyHarmonyCoreTrackDescription,
      quickPracticeCue: l10n.studyHarmonyContinueCardTitle,
    ),
  };
}
