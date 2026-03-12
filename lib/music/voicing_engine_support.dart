part of 'voicing_engine_core.dart';

class _ResolvedProgressionContext {
  const _ResolvedProgressionContext({
    required this.source,
    required this.previousReference,
    required this.lookAheadChords,
    required this.availableSignatures,
    required this.availableTopNotePitchClasses,
  });

  final VoicingContext source;
  final ConcreteVoicing? previousReference;
  final List<GeneratedChord> lookAheadChords;
  final Set<String> availableSignatures;
  final Set<int> availableTopNotePitchClasses;

  PracticeSettings get settings => source.settings;

  GeneratedChord? get previousChord => source.previousChord;

  GeneratedChord get currentChord => source.currentChord;

  GeneratedChord? get nextChord => source.nextLookAheadChord;

  GeneratedChord? get nextNextChord => source.nextNextLookAheadChord;

  int get effectiveLookAheadDepth => source.effectiveLookAheadDepth;

  ConcreteVoicing? get lockedContinuityReference =>
      source.lockContinuityReference;

  bool get isSameHarmonyRepeat =>
      previousChord?.harmonicComparisonKey ==
      currentChord.harmonicComparisonKey;

  VoicingTopNoteSource? get topNotePreferenceSource {
    if (lockedContinuityReference != null &&
        availableSignatures.contains(lockedContinuityReference!.signature)) {
      return VoicingTopNoteSource.lockedContinuity;
    }
    if (source.preferredTopNotePitchClass != null) {
      return VoicingTopNoteSource.explicitPreference;
    }
    if (isSameHarmonyRepeat && previousReference != null) {
      return VoicingTopNoteSource.sameHarmonyCarry;
    }
    return null;
  }

  int? get topNotePitchClassPreference {
    return switch (topNotePreferenceSource) {
      VoicingTopNoteSource.lockedContinuity =>
        lockedContinuityReference?.topNotePitchClass,
      VoicingTopNoteSource.explicitPreference =>
        source.preferredTopNotePitchClass,
      VoicingTopNoteSource.sameHarmonyCarry =>
        previousReference?.topNotePitchClass,
      null => null,
    };
  }

  VoicingTopNoteMatch? get topNoteMatch {
    final preferredPitchClass = topNotePitchClassPreference;
    if (preferredPitchClass == null || availableTopNotePitchClasses.isEmpty) {
      return null;
    }
    final minimumDistance = availableTopNotePitchClasses
        .map(
          (pitchClass) => VoicingEngine._pitchClassDistance(
            pitchClass,
            preferredPitchClass,
          ),
        )
        .reduce(min);
    if (minimumDistance == 0) {
      return VoicingTopNoteMatch.exact;
    }
    if (minimumDistance == 1) {
      return VoicingTopNoteMatch.nearby;
    }
    return VoicingTopNoteMatch.unavailable;
  }

  bool get hasLockedContinuity => source.hasLockedContinuity;

  bool get isFreeModeFallback => source.isFreeModeFallback;

  String get diagnosticSummary => source.diagnosticSummary;
}

class _VoicingTemplate {
  const _VoicingTemplate({
    required this.family,
    required this.coreLabels,
    required this.optionalLabels,
    required this.targetMidis,
    this.registerShifts = const [0],
  });

  final VoicingFamily family;
  final List<String> coreLabels;
  final List<String> optionalLabels;
  final List<int> targetMidis;
  final List<int> registerShifts;
}

class _TransitionScore {
  const _TransitionScore({
    required this.guideToneResolutionBonus,
    required this.commonToneRetentionBonus,
    required this.totalVoiceMotionPenalty,
    required this.outerVoiceLeapPenalty,
    required this.bassMovementPenalty,
    required this.sameRootSusReleaseBonus,
    required this.commonToneCount,
    required this.guideResolutionCount,
    required this.totalMotionSemitones,
  });

  final double guideToneResolutionBonus;
  final double commonToneRetentionBonus;
  final double totalVoiceMotionPenalty;
  final double outerVoiceLeapPenalty;
  final double bassMovementPenalty;
  final double sameRootSusReleaseBonus;
  final int commonToneCount;
  final int guideResolutionCount;
  final int totalMotionSemitones;
}
