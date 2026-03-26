import '../../audio/harmony_audio_models.dart';
import '../../audio/instrument_library_registry.dart';
import '../../l10n/app_localizations.dart';
import '../../music/chord_theory.dart';
import '../../music/melody_models.dart';
import '../../music/voicing_models.dart';
import '../../settings/practice_settings.dart';
import 'core_curriculum_catalog.dart';
import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_track_profiles.dart';

final List<KeyCenter> _commonMajorCenters = <KeyCenter>[
  for (final tonic in const ['C', 'G', 'D', 'F', 'A'])
    MusicTheory.keyCenterFor(tonic),
];

final List<KeyCenter> _commonMinorCenters = <KeyCenter>[
  for (final tonic in const ['A', 'D', 'E', 'G'])
    MusicTheory.keyCenterFor(tonic, mode: KeyMode.minor),
];

TrackGenerationProfile trackGenerationProfileForFlavor(
  StudyHarmonyTrackId trackId,
  TrackExerciseFlavor flavor,
) {
  return switch ((trackId, flavor)) {
    (studyHarmonyPopTrackId, TrackExerciseFlavor.popHookLoop) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.popModernLoop,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        allowV7sus4: true,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.coreDiatonic,
        sourceProfile: SourceProfile.recordingInspired,
        preferredVoicingFamilies: const {
          VoicingFamily.spread,
          VoicingFamily.sus,
        },
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.stableTension,
          MelodyNoteRole.guideTone,
        },
        preferredCandidateInputs: const [
          'Cmaj7 | G | Am7 | Fmaj7',
          'Am7 | Fadd9 | Cmaj7 | Gsus4',
          'Fmaj7 | G | Em7 | Am7',
          'G | D | Em7 | Cadd9',
        ],
      ),
    (studyHarmonyPopTrackId, TrackExerciseFlavor.popBorrowedLift) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.popModernLoop,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: true,
        requireSingleNonDiatonic: true,
        allowModalInterchange: true,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.expandedColor,
        sourceProfile: SourceProfile.recordingInspired,
        preferredVoicingFamilies: const {
          VoicingFamily.spread,
          VoicingFamily.sus,
        },
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.stableTension,
          MelodyNoteRole.approach,
        },
        preferredCandidateInputs: const [
          'Cmaj7 | Bbmaj7 | Fmaj7 | Cmaj7',
          'Gmaj7 | CmMaj7 | Gmaj7 | Dsus4',
          'Dmaj7 | Cmaj7 | Gmaj7 | Dmaj7',
          'Amaj7 | Fmaj7 | Dmaj7 | E',
        ],
      ),
    (studyHarmonyPopTrackId, TrackExerciseFlavor.popBassMotion) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.popModernLoop,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.coreDiatonic,
        sourceProfile: SourceProfile.recordingInspired,
        preferredVoicingFamilies: const {VoicingFamily.spread},
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.guideTone,
        },
        preferredCandidateInputs: const [
          'Cmaj7 | G/B | Am7 | Fmaj7',
          'Fmaj7 | C/E | Dm7 | C',
          'G | D/F# | Em7 | C',
          'D | A/C# | Bm7 | G',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzGuideTone) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        chordLanguageLevel: ChordLanguageLevel.seventhChords,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.shell},
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.chordTone,
        },
        preferredCandidateInputs: const [
          'Dm7 | G7 | Cmaj7 | C6/9',
          'Gm7 | C7 | Fmaj7 | F6/9',
          'Cm7 | F7 | Bbmaj7 | Bb6/9',
          'Am7 | D7 | Gmaj7 | G6/9',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzShellVoicing) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        chordLanguageLevel: ChordLanguageLevel.seventhChords,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.shell},
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.chordTone,
        },
        preferredCandidateInputs: const [
          'Am7 | Dm7 | G7 | Cmaj7',
          'Dm7 | Gm7 | C7 | Fmaj7',
          'Gm7 | Cm7 | F7 | Bbmaj7',
          'Em7 | Am7 | D7 | Gmaj7',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzMinorCadence) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMinorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: true,
        requireSingleNonDiatonic: false,
        allowSecondaryDominant: true,
        chordLanguageLevel: ChordLanguageLevel.seventhChords,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.shell},
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.approach,
        },
        preferredCandidateInputs: const [
          'Bm7b5 | E7 | AmMaj7 | Am6',
          'Em7b5 | A7 | DmMaj7 | Dm6',
          'Am7b5 | D7 | GmMaj7 | Gm6',
          'Dm7b5 | G7 | CmMaj7 | Cm6',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzRootlessVoicing) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        allowTensions: true,
        chordLanguageLevel: ChordLanguageLevel.fullExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        selectedTensionOptions: const {'9', '13'},
        preferredVoicingFamilies: const {
          VoicingFamily.rootlessA,
          VoicingFamily.rootlessB,
        },
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.approach,
          MelodyNoteRole.stableTension,
        },
        preferredCandidateInputs: const [
          'Am7 | Dm9 | G13 | Cmaj9',
          'Dm7 | Gm9 | C13 | Fmaj9',
          'Gm7 | Cm9 | F13 | Bbmaj9',
          'Em7 | Am9 | D13 | Gmaj9',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzDominantColor) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: [..._commonMajorCenters, ..._commonMinorCenters],
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: true,
        allowSecondaryDominant: true,
        modulationIntensity: ModulationIntensity.off,
        allowV7sus4: true,
        allowTensions: true,
        chordLanguageLevel: ChordLanguageLevel.fullExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.fakebookStandard,
        selectedTensionOptions: const {'9', 'b9', '#9', '13'},
        preferredVoicingFamilies: const {
          VoicingFamily.rootlessA,
          VoicingFamily.rootlessB,
        },
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.approach,
          MelodyNoteRole.enclosure,
          MelodyNoteRole.stableTension,
        },
        preferredCandidateInputs: const [
          'Cmaj9 | A7b9 | Dm9 | G13',
          'Fmaj9 | D7b9 | Gm9 | C13',
          'Bbmaj9 | G7alt | Cm9 | F13',
          'Gmaj9 | A7sus4 | D7 | Gmaj9',
        ],
      ),
    (studyHarmonyJazzTrackId, TrackExerciseFlavor.jazzBackdoorCadence) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.jazzStandardsLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: true,
        allowSubstituteDominant: true,
        allowModalInterchange: true,
        allowTensions: true,
        chordLanguageLevel: ChordLanguageLevel.fullExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.fakebookStandard,
        selectedTensionOptions: const {'9', '#11', '13'},
        preferredVoicingFamilies: const {
          VoicingFamily.rootlessA,
          VoicingFamily.rootlessB,
          VoicingFamily.quartal,
        },
        preferredMelodyRoles: const {
          MelodyNoteRole.guideTone,
          MelodyNoteRole.approach,
          MelodyNoteRole.enclosure,
          MelodyNoteRole.stableTension,
        },
        preferredCandidateInputs: const [
          'Dm7 | Db7 | Cmaj9 | C6/9',
          'Fm7 | Bb7 | Cmaj9 | C6/9',
          'Gm7 | Gb7 | Fmaj9 | F6/9',
          'Bbm7 | Eb7 | Fmaj9 | F6/9',
        ],
      ),
    (studyHarmonyClassicalTrackId, TrackExerciseFlavor.classicalCadence) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.classicalCadenceLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        chordLanguageLevel: ChordLanguageLevel.triadsOnly,
        romanPoolPreset: RomanPoolPreset.coreDiatonic,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.spread},
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.guideTone,
        },
        preferredCandidateInputs: const [
          'C | F | G | C',
          'G | C | D | G',
          'D | G | A | D',
          'F | Bb | C | F',
        ],
      ),
    (studyHarmonyClassicalTrackId, TrackExerciseFlavor.classicalInversion) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.classicalCadenceLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: false,
        chordLanguageLevel: ChordLanguageLevel.triadsOnly,
        romanPoolPreset: RomanPoolPreset.coreDiatonic,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.spread},
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.guideTone,
          MelodyNoteRole.passing,
        },
        preferredCandidateInputs: const [
          'C | G/B | Am | F',
          'G | D/F# | Em | C',
          'F | C/E | Dm | Bb',
          'D | A/C# | Bm | G',
        ],
      ),
    (
      studyHarmonyClassicalTrackId,
      TrackExerciseFlavor.classicalSecondaryDominant,
    ) =>
      TrackGenerationProfile(
        trackId: trackId,
        lessonFlavor: TrackLessonFlavor.classicalCadenceLab,
        exerciseFlavor: flavor,
        keyCenters: _commonMajorCenters,
        minLength: 4,
        maxLength: 4,
        allowNonDiatonic: true,
        requireSingleNonDiatonic: true,
        allowSecondaryDominant: true,
        chordLanguageLevel: ChordLanguageLevel.seventhChords,
        romanPoolPreset: RomanPoolPreset.fullDiatonic,
        sourceProfile: SourceProfile.fakebookStandard,
        preferredVoicingFamilies: const {VoicingFamily.spread},
        preferredMelodyRoles: const {
          MelodyNoteRole.chordTone,
          MelodyNoteRole.guideTone,
        },
        preferredCandidateInputs: const [
          'C | A7 | Dm | G',
          'G | E7 | Am | D',
          'D | B7 | Em | A',
          'F | D7 | Gm | C',
        ],
      ),
    _ => TrackGenerationProfile(
      trackId: trackId,
      lessonFlavor: TrackLessonFlavor.foundations,
      exerciseFlavor: TrackExerciseFlavor.coreFunctional,
      keyCenters: _commonMajorCenters,
      minLength: 3,
      maxLength: 4,
      allowNonDiatonic: false,
      chordLanguageLevel: ChordLanguageLevel.seventhChords,
      romanPoolPreset: RomanPoolPreset.coreDiatonic,
      sourceProfile: SourceProfile.fakebookStandard,
      preferredVoicingFamilies: const {VoicingFamily.spread},
      preferredMelodyRoles: const {
        MelodyNoteRole.chordTone,
        MelodyNoteRole.guideTone,
      },
      preferredCandidateInputs: const [
        'Cmaj7 | Dm7 | G7 | Cmaj7',
        'Gmaj7 | Am7 | D7 | Gmaj7',
      ],
    ),
  };
}

HarmonyAudioConfig harmonyAudioBaseConfigForSettings(
  PracticeSettings settings,
) {
  return HarmonyAudioConfig(
    masterVolume: settings.harmonyMasterVolume,
    previewHoldFactor: settings.harmonyPreviewHoldFactor,
    arpeggioStepSpeed: settings.harmonyArpeggioStepSpeed,
    velocityHumanization: settings.harmonyVelocityHumanization,
    gainRandomness: settings.harmonyGainRandomness,
    timingHumanization: settings.harmonyTimingHumanization,
  );
}

TrackSoundProfile trackSoundProfileForSelection(
  AppLocalizations l10n, {
  required HarmonySoundProfileSelection selection,
  StudyHarmonyTrackId? activeTrackId,
}) {
  return switch (selection) {
    HarmonySoundProfileSelection.neutral => _coreSoundProfile(l10n),
    HarmonySoundProfileSelection.trackAware => trackSoundProfileForTrack(
      l10n,
      activeTrackId ?? studyHarmonyCoreTrackId,
    ),
    HarmonySoundProfileSelection.pop => trackSoundProfileForTrack(
      l10n,
      studyHarmonyPopTrackId,
    ),
    HarmonySoundProfileSelection.jazz => trackSoundProfileForTrack(
      l10n,
      studyHarmonyJazzTrackId,
    ),
    HarmonySoundProfileSelection.classical => trackSoundProfileForTrack(
      l10n,
      studyHarmonyClassicalTrackId,
    ),
  };
}

TrackSoundProfile trackSoundProfileForTrack(
  AppLocalizations l10n,
  StudyHarmonyTrackId trackId,
) {
  return switch (trackId) {
    studyHarmonyPopTrackId => _popSoundProfile(l10n),
    studyHarmonyJazzTrackId => _jazzSoundProfile(l10n),
    studyHarmonyClassicalTrackId => _classicalSoundProfile(l10n),
    _ => _coreSoundProfile(l10n, trackId: trackId),
  };
}

TrackSoundProfile _coreSoundProfile(
  AppLocalizations l10n, {
  StudyHarmonyTrackId trackId = studyHarmonyCoreTrackId,
}) {
  return TrackSoundProfile(
    trackId: trackId,
    profileId: 'core-balanced-piano',
    soundMode: TrackSoundMode.modernOpen,
    label: l10n.harmonySoundProfileNeutralLabel,
    summary: l10n.harmonySoundProfileNeutralSummary,
    suggestedInstrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
    runtimeProfile: HarmonyAudioRuntimeProfile(
      profileId: 'core-balanced-piano',
      instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
      preferredPattern: HarmonyPlaybackPattern.block,
      tuning: const HarmonyAudioProfileTuning(
        masterVolumeScale: 1.0,
        previewHoldFactorScale: 1.0,
        arpeggioStepSpeedScale: 1.0,
      ),
      futureAssetHint: l10n.studyHarmonyTrackSoundAssetPlaceholder,
    ),
    tags: [l10n.harmonySoundTagBalanced, l10n.harmonySoundTagPiano],
    playbackTraits: [
      l10n.harmonySoundNeutralTrait1,
      l10n.harmonySoundNeutralTrait2,
      l10n.harmonySoundNeutralTrait3,
    ],
    expansionTargets: [
      l10n.harmonySoundNeutralExpansion1,
      l10n.harmonySoundNeutralExpansion2,
    ],
    assetStatusNote: l10n.studyHarmonyTrackSoundAssetPlaceholder,
  );
}

TrackSoundProfile _popSoundProfile(AppLocalizations l10n) {
  return TrackSoundProfile(
    trackId: studyHarmonyPopTrackId,
    profileId: 'pop-soft-open',
    soundMode: TrackSoundMode.modernOpen,
    label: l10n.studyHarmonyTrackPopSoundLabel,
    summary: l10n.studyHarmonyTrackPopSoundSummary,
    suggestedInstrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
    runtimeProfile: HarmonyAudioRuntimeProfile(
      profileId: 'pop-soft-open',
      instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
      preferredPattern: HarmonyPlaybackPattern.block,
      tuning: const HarmonyAudioProfileTuning(
        masterVolumeScale: 0.98,
        previewHoldFactorScale: 1.12,
        arpeggioStepSpeedScale: 0.94,
        timingHumanizationFloor: 0.08,
      ),
      futureAssetHint: l10n.studyHarmonyTrackSoundAssetPlaceholder,
    ),
    tags: [
      l10n.harmonySoundTagSoft,
      l10n.harmonySoundTagOpen,
      l10n.harmonySoundTagModern,
    ],
    playbackTraits: [
      l10n.harmonySoundPopTrait1,
      l10n.harmonySoundPopTrait2,
      l10n.harmonySoundPopTrait3,
    ],
    expansionTargets: [
      l10n.harmonySoundPopExpansion1,
      l10n.harmonySoundPopExpansion2,
    ],
    assetStatusNote: l10n.studyHarmonyTrackSoundAssetPlaceholder,
  );
}

TrackSoundProfile _jazzSoundProfile(AppLocalizations l10n) {
  return TrackSoundProfile(
    trackId: studyHarmonyJazzTrackId,
    profileId: 'jazz-dry-warm',
    soundMode: TrackSoundMode.dryWarm,
    label: l10n.studyHarmonyTrackJazzSoundLabel,
    summary: l10n.studyHarmonyTrackJazzSoundSummary,
    suggestedInstrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
    runtimeProfile: HarmonyAudioRuntimeProfile(
      profileId: 'jazz-dry-warm',
      instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
      preferredPattern: HarmonyPlaybackPattern.arpeggio,
      tuning: const HarmonyAudioProfileTuning(
        masterVolumeScale: 0.95,
        previewHoldFactorScale: 0.9,
        arpeggioStepSpeedScale: 1.16,
        timingHumanizationFloor: 0.12,
      ),
      futureAssetHint: l10n.studyHarmonyTrackSoundAssetPlaceholder,
    ),
    tags: [
      l10n.harmonySoundTagDry,
      l10n.harmonySoundTagWarm,
      l10n.harmonySoundTagEpReady,
    ],
    playbackTraits: [
      l10n.harmonySoundJazzTrait1,
      l10n.harmonySoundJazzTrait2,
      l10n.harmonySoundJazzTrait3,
    ],
    expansionTargets: [
      l10n.harmonySoundJazzExpansion1,
      l10n.harmonySoundJazzExpansion2,
    ],
    assetStatusNote: l10n.studyHarmonyTrackSoundAssetPlaceholder,
  );
}

TrackSoundProfile _classicalSoundProfile(AppLocalizations l10n) {
  return TrackSoundProfile(
    trackId: studyHarmonyClassicalTrackId,
    profileId: 'classical-clear-focused',
    soundMode: TrackSoundMode.clearFocused,
    label: l10n.studyHarmonyTrackClassicalSoundLabel,
    summary: l10n.studyHarmonyTrackClassicalSoundSummary,
    suggestedInstrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
    runtimeProfile: HarmonyAudioRuntimeProfile(
      profileId: 'classical-clear-focused',
      instrumentId: InstrumentLibraryRegistry.defaultHarmonyPianoId,
      preferredPattern: HarmonyPlaybackPattern.block,
      tuning: const HarmonyAudioProfileTuning(
        masterVolumeScale: 1.0,
        previewHoldFactorScale: 1.05,
        arpeggioStepSpeedScale: 0.9,
        timingHumanizationFloor: 0.03,
      ),
      futureAssetHint: l10n.studyHarmonyTrackSoundAssetPlaceholder,
    ),
    tags: [
      l10n.harmonySoundTagClear,
      l10n.harmonySoundTagAcoustic,
      l10n.harmonySoundTagFocused,
    ],
    playbackTraits: [
      l10n.harmonySoundClassicalTrait1,
      l10n.harmonySoundClassicalTrait2,
      l10n.harmonySoundClassicalTrait3,
    ],
    expansionTargets: [
      l10n.harmonySoundClassicalExpansion1,
      l10n.harmonySoundClassicalExpansion2,
    ],
    assetStatusNote: l10n.studyHarmonyTrackSoundAssetPlaceholder,
  );
}
