import 'package:flutter/foundation.dart';

import '../../audio/harmony_audio_models.dart';
import '../../music/chord_theory.dart';
import '../../music/melody_models.dart';
import '../../music/voicing_models.dart';
import '../../settings/practice_settings.dart';
import 'study_harmony_session_models.dart';

enum TrackLessonFlavor {
  foundations,
  popModernLoop,
  jazzStandardsLab,
  classicalCadenceLab,
}

const StudyHarmonyTrackId studyHarmonyPopTrackId = 'pop';
const StudyHarmonyTrackId studyHarmonyJazzTrackId = 'jazz';
const StudyHarmonyTrackId studyHarmonyClassicalTrackId = 'classical';

enum TrackPedagogyMode {
  grooveAndHookFirst,
  standardsLanguageFirst,
  cadenceAndFunctionFirst,
}

enum TrackRecommendationMode {
  songcraftFirst,
  jazzLanguageGrowth,
  voiceLeadingDiscipline,
}

enum TrackSoundMode { modernOpen, dryWarm, clearFocused }

@immutable
class TrackPedagogyProfile {
  const TrackPedagogyProfile({
    required this.trackId,
    required this.pedagogyMode,
    required this.focusPoints,
    required this.lighterFocusPoints,
    required this.prioritySkillTags,
    required this.deemphasizedSkillTags,
    required this.recommendedFor,
    required this.theoryTone,
  });

  final StudyHarmonyTrackId trackId;
  final TrackPedagogyMode pedagogyMode;
  final List<String> focusPoints;
  final List<String> lighterFocusPoints;
  final List<String> prioritySkillTags;
  final List<String> deemphasizedSkillTags;
  final String recommendedFor;
  final String theoryTone;
}

@immutable
class TrackRecommendationProfile {
  const TrackRecommendationProfile({
    required this.trackId,
    required this.recommendationMode,
    required this.heroHeadline,
    required this.heroBody,
    required this.quickPracticeCue,
  });

  final StudyHarmonyTrackId trackId;
  final TrackRecommendationMode recommendationMode;
  final String heroHeadline;
  final String heroBody;
  final String quickPracticeCue;
}

@immutable
class TrackSoundProfile {
  const TrackSoundProfile({
    required this.trackId,
    required this.profileId,
    required this.soundMode,
    required this.label,
    required this.summary,
    required this.suggestedInstrumentId,
    required this.runtimeProfile,
    this.tags = const <String>[],
    this.playbackTraits = const <String>[],
    this.expansionTargets = const <String>[],
    this.assetStatusNote,
  });

  final StudyHarmonyTrackId trackId;
  final String profileId;
  final TrackSoundMode soundMode;
  final String label;
  final String summary;
  final String suggestedInstrumentId;
  final HarmonyAudioRuntimeProfile runtimeProfile;
  final List<String> tags;
  final List<String> playbackTraits;
  final List<String> expansionTargets;
  final String? assetStatusNote;
}

@immutable
class TrackGenerationProfile {
  const TrackGenerationProfile({
    required this.trackId,
    required this.lessonFlavor,
    required this.exerciseFlavor,
    required this.keyCenters,
    required this.minLength,
    required this.maxLength,
    required this.allowNonDiatonic,
    this.requireSingleNonDiatonic = false,
    this.allowSecondaryDominant = false,
    this.allowSubstituteDominant = false,
    this.allowModalInterchange = false,
    this.modulationIntensity = ModulationIntensity.off,
    this.allowV7sus4 = false,
    this.allowTensions = false,
    this.chordLanguageLevel = ChordLanguageLevel.seventhChords,
    this.romanPoolPreset = RomanPoolPreset.coreDiatonic,
    this.jazzPreset = JazzPreset.standardsCore,
    this.sourceProfile = SourceProfile.fakebookStandard,
    this.selectedTensionOptions = const <String>{},
    this.preferredVoicingFamilies = const <VoicingFamily>{},
    this.preferredMelodyRoles = const <MelodyNoteRole>{},
    this.preferredCandidateInputs = const <String>[],
  });

  final StudyHarmonyTrackId trackId;
  final TrackLessonFlavor lessonFlavor;
  final TrackExerciseFlavor exerciseFlavor;
  final List<KeyCenter> keyCenters;
  final int minLength;
  final int maxLength;
  final bool allowNonDiatonic;
  final bool requireSingleNonDiatonic;
  final bool allowSecondaryDominant;
  final bool allowSubstituteDominant;
  final bool allowModalInterchange;
  final ModulationIntensity modulationIntensity;
  final bool allowV7sus4;
  final bool allowTensions;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final Set<String> selectedTensionOptions;
  final Set<VoicingFamily> preferredVoicingFamilies;
  final Set<MelodyNoteRole> preferredMelodyRoles;
  final List<String> preferredCandidateInputs;

  String get differentiationSignature {
    final voicingFamilyNames =
        preferredVoicingFamilies.map((family) => family.name).toList()..sort();
    final melodyRoleNames =
        preferredMelodyRoles.map((role) => role.name).toList()..sort();
    final tensionNames = selectedTensionOptions.toList()..sort();
    final buffer = <String>[
      lessonFlavor.name,
      exerciseFlavor.name,
      chordLanguageLevel.name,
      romanPoolPreset.name,
      jazzPreset.name,
      sourceProfile.name,
      'nonDiatonic:${allowNonDiatonic ? 1 : 0}',
      'singleNonDiatonic:${requireSingleNonDiatonic ? 1 : 0}',
      'secondaryDominant:${allowSecondaryDominant ? 1 : 0}',
      'substituteDominant:${allowSubstituteDominant ? 1 : 0}',
      'modalInterchange:${allowModalInterchange ? 1 : 0}',
      'modulation:${modulationIntensity.name}',
      'v7sus4:${allowV7sus4 ? 1 : 0}',
      'tensions:${allowTensions ? 1 : 0}',
      'voicings:${voicingFamilyNames.join("+")}',
      'melody:${melodyRoleNames.join("+")}',
      if (tensionNames.isNotEmpty) 'tensionSet:${tensionNames.join("+")}',
      if (preferredCandidateInputs.isNotEmpty)
        'candidateCount:${preferredCandidateInputs.length}',
    ];
    return buffer.join('|');
  }
}
