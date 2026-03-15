part of '../smart_generator_core.dart';

enum SmartProgressionFamily {
  coreIiVIMajor,
  turnaroundIViIiV,
  turnaroundISharpIdimIiV,
  turnaroundIIIviIiV,
  relativeMinorReframe,
  dominantHeadedScopeChain,
  closingPlagalAuthenticHybrid,
  bridgeIVStabilizedByLocalIiVI,
  minorIiVAltI,
  minorLineCliche,
  backdoorIvmBviiI,
  backdoorRecursivePrep,
  classicalPredominantColor,
  mixturePivotModulation,
  chromaticMediantCommonToneModulation,
  coltraneBurst,
  bridgeReturnHomeCadence,
  dominantChainBridgeStyle,
  appliedDominantWithRelatedIi,
  passingDimToIi,
  commonChordModulation,
  cadenceBasedRealModulation,
}

enum PhraseRole { opener, continuation, preCadence, cadence, release }

enum SectionRole { aLike, bridgeLike, turnaroundTail, tag }

enum HarmonicDensity { oneChordPerBar, twoChordsPerBar, turnaroundSplit }

enum _PhrasePriority { low, cadence, boundary }

class SmartPhraseContext {
  const SmartPhraseContext({
    required this.phraseRole,
    required this.sectionRole,
    required this.harmonicDensity,
    required this.barInPhrase,
    required this.barsToBoundary,
    required this.phraseLength,
    this.timeSignature = PracticeTimeSignature.fourFour,
    this.harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
    this.beatsPerBar = 4,
    this.barIndex = 0,
    this.changeBeat = 0,
    this.durationBeats = 4,
    this.eventIndexInBar = 0,
    this.eventsInBar = 1,
  });

  final PhraseRole phraseRole;
  final SectionRole sectionRole;
  final HarmonicDensity harmonicDensity;
  final int barInPhrase;
  final int barsToBoundary;
  final int phraseLength;
  final PracticeTimeSignature timeSignature;
  final HarmonicRhythmPreset harmonicRhythmPreset;
  final int beatsPerBar;
  final int barIndex;
  final int changeBeat;
  final int durationBeats;
  final int eventIndexInBar;
  final int eventsInBar;

  bool get isWeakBeatChange => changeBeat > 0;
  bool get isAnticipationBeat => changeBeat == beatsPerBar - 1;
  bool get isSplitBar => eventsInBar > 1;
  bool get isCadentialPickup =>
      isWeakBeatChange &&
      (phraseRole == PhraseRole.preCadence ||
          phraseRole == PhraseRole.cadence ||
          phraseRole == PhraseRole.release);

  static SmartPhraseContext rollingForm(
    int stepIndex, {
    PracticeTimeSignature timeSignature = PracticeTimeSignature.fourFour,
    HarmonicRhythmPreset harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
    ChordTimingSpec? timing,
    int? barIndex,
    int? changeBeat,
    int? durationBeats,
    int? eventIndexInBar,
    int? eventsInBar,
  }) {
    final resolvedBarIndex = timing?.barIndex ?? barIndex ?? stepIndex;
    final resolvedBeatsPerBar = timeSignature.beatsPerBar;
    final resolvedChangeBeat = timing?.changeBeat ?? changeBeat ?? 0;
    final resolvedDurationBeats =
        timing?.durationBeats ?? durationBeats ?? resolvedBeatsPerBar;
    final resolvedEventIndexInBar =
        timing?.eventIndexInBar ?? eventIndexInBar ?? 0;
    final resolvedEventsInBar = timing?.eventsInBar ?? eventsInBar ?? 1;
    final cycleBar = resolvedBarIndex % 32;
    SectionRole sectionRole;
    int phraseLength;
    int barInPhrase;
    if (cycleBar < 8) {
      sectionRole = SectionRole.aLike;
      phraseLength = 8;
      barInPhrase = cycleBar;
    } else if (cycleBar < 16) {
      sectionRole = SectionRole.aLike;
      phraseLength = 8;
      barInPhrase = cycleBar - 8;
    } else if (cycleBar < 24) {
      sectionRole = SectionRole.bridgeLike;
      phraseLength = 8;
      barInPhrase = cycleBar - 16;
    } else if (cycleBar < 28) {
      sectionRole = SectionRole.turnaroundTail;
      phraseLength = 4;
      barInPhrase = cycleBar - 24;
    } else {
      sectionRole = SectionRole.tag;
      phraseLength = 4;
      barInPhrase = cycleBar - 28;
    }
    final barsToBoundary = phraseLength - 1 - barInPhrase;
    final basePhraseRole = switch (barsToBoundary) {
      0 => PhraseRole.release,
      1 => PhraseRole.cadence,
      2 => PhraseRole.preCadence,
      _ => barInPhrase == 0 ? PhraseRole.opener : PhraseRole.continuation,
    };
    final phraseRole = resolvedChangeBeat > 0
        ? barsToBoundary <= 1
              ? PhraseRole.cadence
              : barsToBoundary == 2
              ? PhraseRole.preCadence
              : basePhraseRole
        : basePhraseRole;
    final density = switch (harmonicRhythmPreset) {
      HarmonicRhythmPreset.onePerBar => HarmonicDensity.oneChordPerBar,
      HarmonicRhythmPreset.twoPerBar || HarmonicRhythmPreset.phraseAwareJazz =>
        resolvedEventsInBar > 1
            ? HarmonicDensity.twoChordsPerBar
            : sectionRole == SectionRole.bridgeLike &&
                  timeSignature == PracticeTimeSignature.fourFour
            ? HarmonicDensity.twoChordsPerBar
            : HarmonicDensity.oneChordPerBar,
      HarmonicRhythmPreset.cadenceCompression =>
        resolvedEventsInBar > 1 && resolvedChangeBeat >= resolvedBeatsPerBar - 1
            ? HarmonicDensity.turnaroundSplit
            : resolvedEventsInBar > 1
            ? HarmonicDensity.twoChordsPerBar
            : HarmonicDensity.oneChordPerBar,
    };
    return SmartPhraseContext(
      phraseRole: phraseRole,
      sectionRole: sectionRole,
      harmonicDensity: density,
      barInPhrase: barInPhrase,
      barsToBoundary: barsToBoundary,
      phraseLength: phraseLength,
      timeSignature: timeSignature,
      harmonicRhythmPreset: harmonicRhythmPreset,
      beatsPerBar: resolvedBeatsPerBar,
      barIndex: resolvedBarIndex,
      changeBeat: resolvedChangeBeat,
      durationBeats: resolvedDurationBeats,
      eventIndexInBar: resolvedEventIndexInBar,
      eventsInBar: resolvedEventsInBar,
    );
  }

  String describe() {
    return '${phraseRole.name}/${sectionRole.name}/'
        '${harmonicDensity.name}:bar=$barInPhrase/'
        '$phraseLength:toBoundary=$barsToBoundary/'
        'meter=${timeSignature.name}:beat=${changeBeat + 1}/'
        '${durationBeats}ev=${eventIndexInBar + 1}/$eventsInBar';
  }
}

class WeightedNextRoman {
  const WeightedNextRoman({required this.romanNumeralId, required this.weight});

  final RomanNumeralId romanNumeralId;
  final int weight;
}

class _WeightedFamily {
  const _WeightedFamily({required this.family, required this.weight});

  final SmartProgressionFamily family;
  final int weight;
}

class QueuedSmartChord {
  const QueuedSmartChord({
    required this.keyCenter,
    required this.finalRomanNumeralId,
    required this.plannedChordKind,
    required this.patternTag,
    this.variantTag,
    this.renderQualityOverride,
    this.suppressTensions = false,
    this.appliedType,
    this.resolutionTargetRomanId,
    this.dominantContext,
    this.dominantIntent,
    this.modulationKind = ModulationKind.none,
    this.cadentialArrival = false,
    this.modulationAttempt = false,
    this.surfaceTags = const [],
    this.openScope,
    this.closeScope = false,
    this.openedDebts = const [],
    this.satisfiedDebtTypes = const [],
    this.modulationConfidence = 0,
    this.postModulationConfirmationsRemaining = 0,
  });

  final KeyCenter keyCenter;
  final RomanNumeralId finalRomanNumeralId;
  final PlannedChordKind plannedChordKind;
  final String patternTag;
  final String? variantTag;
  final ChordQuality? renderQualityOverride;
  final bool suppressTensions;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final DominantContext? dominantContext;
  final DominantIntent? dominantIntent;
  final ModulationKind modulationKind;
  final bool cadentialArrival;
  final bool modulationAttempt;
  final List<String> surfaceTags;
  final LocalScope? openScope;
  final bool closeScope;
  final List<ResolutionDebt> openedDebts;
  final List<ResolutionDebtType> satisfiedDebtTypes;
  final double modulationConfidence;
  final int postModulationConfirmationsRemaining;

  QueuedSmartChord copyWith({
    KeyCenter? keyCenter,
    RomanNumeralId? finalRomanNumeralId,
    PlannedChordKind? plannedChordKind,
    String? patternTag,
    String? variantTag,
    ChordQuality? renderQualityOverride,
    bool? suppressTensions,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
    ModulationKind? modulationKind,
    bool? cadentialArrival,
    bool? modulationAttempt,
    List<String>? surfaceTags,
    LocalScope? openScope,
    bool? closeScope,
    List<ResolutionDebt>? openedDebts,
    List<ResolutionDebtType>? satisfiedDebtTypes,
    double? modulationConfidence,
    int? postModulationConfirmationsRemaining,
  }) {
    return QueuedSmartChord(
      keyCenter: keyCenter ?? this.keyCenter,
      finalRomanNumeralId: finalRomanNumeralId ?? this.finalRomanNumeralId,
      plannedChordKind: plannedChordKind ?? this.plannedChordKind,
      patternTag: patternTag ?? this.patternTag,
      variantTag: variantTag ?? this.variantTag,
      renderQualityOverride:
          renderQualityOverride ?? this.renderQualityOverride,
      suppressTensions: suppressTensions ?? this.suppressTensions,
      appliedType: appliedType ?? this.appliedType,
      resolutionTargetRomanId:
          resolutionTargetRomanId ?? this.resolutionTargetRomanId,
      dominantContext: dominantContext ?? this.dominantContext,
      dominantIntent: dominantIntent ?? this.dominantIntent,
      modulationKind: modulationKind ?? this.modulationKind,
      cadentialArrival: cadentialArrival ?? this.cadentialArrival,
      modulationAttempt: modulationAttempt ?? this.modulationAttempt,
      surfaceTags: surfaceTags ?? this.surfaceTags,
      openScope: openScope ?? this.openScope,
      closeScope: closeScope ?? this.closeScope,
      openedDebts: openedDebts ?? this.openedDebts,
      satisfiedDebtTypes: satisfiedDebtTypes ?? this.satisfiedDebtTypes,
      modulationConfidence: modulationConfidence ?? this.modulationConfidence,
      postModulationConfirmationsRemaining:
          postModulationConfirmationsRemaining ??
          this.postModulationConfirmationsRemaining,
    );
  }
}

class QueuedSmartChordDecision {
  const QueuedSmartChordDecision({
    required this.queuedChord,
    required this.remainingQueuedChords,
  });

  final QueuedSmartChord queuedChord;
  final List<QueuedSmartChord> remainingQueuedChords;

  bool get returnedToNormalFlow => remainingQueuedChords.isEmpty;
}

class SmartTransitionDebug {
  const SmartTransitionDebug({
    required this.currentRomanNumeralId,
    required this.availableCandidates,
    required this.totalWeight,
    required this.roll,
    required this.selectedRomanNumeralId,
    this.fallbackReason,
  });

  final RomanNumeralId? currentRomanNumeralId;
  final List<WeightedNextRoman> availableCandidates;
  final int totalWeight;
  final int? roll;
  final RomanNumeralId? selectedRomanNumeralId;
  final String? fallbackReason;

  bool get usedFallback => fallbackReason != null;

  String describe() {
    final candidates = availableCandidates
        .map(
          (candidate) =>
              '${MusicTheory.romanTokenOf(candidate.romanNumeralId)}(${candidate.weight})',
        )
        .join(', ');
    return 'currentRoman=${_token(currentRomanNumeralId)} '
        'candidates=[$candidates] '
        'totalWeight=$totalWeight '
        'roll=${roll ?? '-'} '
        'selected=${_token(selectedRomanNumeralId)} '
        'fallback=${fallbackReason ?? '-'}';
  }

  String _token(RomanNumeralId? value) {
    return value == null ? '-' : MusicTheory.romanTokenOf(value);
  }
}

class SmartTransitionSelection {
  const SmartTransitionSelection({
    required this.selectedRomanNumeralId,
    required this.debug,
  });

  final RomanNumeralId? selectedRomanNumeralId;
  final SmartTransitionDebug debug;

  bool get hasSelection => selectedRomanNumeralId != null;
}

class SmartApproachDecision {
  const SmartApproachDecision({
    required this.destinationRomanNumeralId,
    required this.selectedRomanNumeralId,
    required this.appliedType,
    required this.dominantContext,
    this.appliedTargetRomanNumeralId,
  });

  final RomanNumeralId destinationRomanNumeralId;
  final RomanNumeralId selectedRomanNumeralId;
  final AppliedType? appliedType;
  final DominantContext? dominantContext;
  final RomanNumeralId? appliedTargetRomanNumeralId;

  RomanNumeralId? get insertedAppliedApproach =>
      appliedType == null ? null : selectedRomanNumeralId;

  bool get insertedApproach => appliedType != null;
}

class _FamilyPlan {
  const _FamilyPlan({
    required this.family,
    required this.queue,
    required this.destinationRomanNumeralId,
    this.modalCandidates = const [],
    this.appliedCandidates = const [],
    this.modulationCandidates = const [],
  });

  final SmartProgressionFamily family;
  final List<QueuedSmartChord> queue;
  final RomanNumeralId destinationRomanNumeralId;
  final List<RomanNumeralId> modalCandidates;
  final List<RomanNumeralId> appliedCandidates;
  final List<KeyCenter> modulationCandidates;
}

class _ModulationOpportunity {
  const _ModulationOpportunity({
    required this.candidates,
    this.blockedReason,
    this.allowPhraseBoundary = false,
  });

  final List<KeyCenter> candidates;
  final SmartBlockedReason? blockedReason;
  final bool allowPhraseBoundary;
}

class SmartRenderCandidate {
  const SmartRenderCandidate({
    required this.keyCenter,
    required this.romanNumeralId,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.renderQualityOverride,
    this.patternTag,
    this.appliedType,
    this.resolutionTargetRomanId,
    this.dominantContext,
    this.dominantIntent,
    this.suppressTensions = false,
    this.smartDebug,
    this.wasExcludedFallback = false,
  });

  final KeyCenter keyCenter;
  final RomanNumeralId romanNumeralId;
  final PlannedChordKind plannedChordKind;
  final ChordQuality? renderQualityOverride;
  final String? patternTag;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final DominantContext? dominantContext;
  final DominantIntent? dominantIntent;
  final bool suppressTensions;
  final SmartDecisionTrace? smartDebug;
  final bool wasExcludedFallback;
}

class SmartVoiceLeadingBreakdown {
  const SmartVoiceLeadingBreakdown({
    required this.total,
    this.guideToneSemitoneBonus = 0,
    this.commonToneRetentionBonus = 0,
    this.rootLeapPenalty = 0,
    this.sameRootSusPayoffBonus = 0,
  });

  final double total;
  final double guideToneSemitoneBonus;
  final double commonToneRetentionBonus;
  final double rootLeapPenalty;
  final double sameRootSusPayoffBonus;

  String describe() {
    return 'score=${total.toStringAsFixed(2)} '
        'guide=${guideToneSemitoneBonus.toStringAsFixed(2)} '
        'common=${commonToneRetentionBonus.toStringAsFixed(2)} '
        'leap=${rootLeapPenalty.toStringAsFixed(2)} '
        'sus=${sameRootSusPayoffBonus.toStringAsFixed(2)}';
  }
}

class SmartRenderedCandidate {
  const SmartRenderedCandidate({
    required this.chord,
    required this.voiceLeading,
  });

  final GeneratedChord chord;
  final SmartVoiceLeadingBreakdown voiceLeading;
}

class SmartCandidateComparison {
  const SmartCandidateComparison({required this.rankedCandidates});

  final List<SmartRenderedCandidate> rankedCandidates;

  SmartRenderedCandidate get selected => rankedCandidates.first;
}

class _RankedSmartCandidate {
  const _RankedSmartCandidate({
    required this.chord,
    required this.candidate,
    required this.voiceLeading,
    required this.sourceIndex,
    required this.optionIndex,
    required this.defaultOption,
    required this.debugStyle,
  });

  final GeneratedChord chord;
  final SmartRenderCandidate candidate;
  final SmartVoiceLeadingBreakdown voiceLeading;
  final int sourceIndex;
  final int optionIndex;
  final bool defaultOption;
  final ChordSymbolStyle debugStyle;
}

class SmartRenderingPlan {
  const SmartRenderingPlan({
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.patternTag,
    this.renderQualityOverride,
    this.suppressTensions = false,
    this.dominantContext,
    this.dominantIntent,
  });

  final PlannedChordKind plannedChordKind;
  final String? patternTag;
  final ChordQuality? renderQualityOverride;
  final bool suppressTensions;
  final DominantContext? dominantContext;
  final DominantIntent? dominantIntent;
}

class SmartStartRequest {
  const SmartStartRequest({
    required this.activeKeys,
    required this.selectedKeyCenters,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationIntensity,
    required this.jazzPreset,
    required this.sourceProfile,
    this.allowV7sus4 = true,
    this.allowTensions = true,
    this.chordLanguageLevel = ChordLanguageLevel.fullExtensions,
    this.romanPoolPreset = RomanPoolPreset.expandedColor,
    this.selectedTensionOptions,
    this.inversionSettings = const InversionSettings(),
    this.timeSignature = PracticeTimeSignature.fourFour,
    this.harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
    this.initialTiming,
    required this.smartDiagnosticsEnabled,
  });

  final List<String> activeKeys;
  final List<KeyCenter> selectedKeyCenters;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final bool allowV7sus4;
  final bool allowTensions;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final Set<String>? selectedTensionOptions;
  final InversionSettings inversionSettings;
  final PracticeTimeSignature timeSignature;
  final HarmonicRhythmPreset harmonicRhythmPreset;
  final ChordTimingSpec? initialTiming;
  final bool smartDiagnosticsEnabled;
}

class SmartStepRequest {
  const SmartStepRequest({
    required this.stepIndex,
    required this.activeKeys,
    required this.selectedKeyCenters,
    required this.currentKeyCenter,
    required this.currentRomanNumeralId,
    required this.currentResolutionRomanNumeralId,
    required this.currentHarmonicFunction,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationIntensity,
    required this.jazzPreset,
    required this.sourceProfile,
    this.allowV7sus4 = true,
    this.allowTensions = true,
    this.chordLanguageLevel = ChordLanguageLevel.fullExtensions,
    this.romanPoolPreset = RomanPoolPreset.expandedColor,
    this.selectedTensionOptions,
    this.inversionSettings = const InversionSettings(),
    required this.smartDiagnosticsEnabled,
    required this.previousRomanNumeralId,
    required this.previousHarmonicFunction,
    required this.previousWasAppliedDominant,
    required this.currentPatternTag,
    required this.plannedQueue,
    required this.currentRenderedNonDiatonic,
    this.timeSignature = PracticeTimeSignature.fourFour,
    this.harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
    this.timing,
    this.currentTrace,
    this.phraseContext,
  });

  final int stepIndex;
  final List<String> activeKeys;
  final List<KeyCenter> selectedKeyCenters;
  final KeyCenter currentKeyCenter;
  final RomanNumeralId currentRomanNumeralId;
  final RomanNumeralId? currentResolutionRomanNumeralId;
  final HarmonicFunction currentHarmonicFunction;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final bool allowV7sus4;
  final bool allowTensions;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final Set<String>? selectedTensionOptions;
  final InversionSettings inversionSettings;
  final bool smartDiagnosticsEnabled;
  final RomanNumeralId? previousRomanNumeralId;
  final HarmonicFunction? previousHarmonicFunction;
  final bool previousWasAppliedDominant;
  final String? currentPatternTag;
  final List<QueuedSmartChord> plannedQueue;
  final bool currentRenderedNonDiatonic;
  final PracticeTimeSignature timeSignature;
  final HarmonicRhythmPreset harmonicRhythmPreset;
  final ChordTimingSpec? timing;
  final SmartDecisionTrace? currentTrace;
  final SmartPhraseContext? phraseContext;
}

class SmartStepPlan {
  const SmartStepPlan({
    required this.finalKeyCenter,
    required this.finalRomanNumeralId,
    required this.appliedType,
    required this.resolutionTargetRomanId,
    required this.plannedChordKind,
    required this.patternTag,
    required this.remainingQueuedChords,
    required this.returnedToNormalFlow,
    required this.renderingPlan,
    required this.debug,
    required this.modulationKind,
    required this.cadentialArrival,
    required this.modulationAttempt,
    required this.phraseContext,
  });

  final KeyCenter finalKeyCenter;
  final RomanNumeralId finalRomanNumeralId;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final PlannedChordKind plannedChordKind;
  final String? patternTag;
  final List<QueuedSmartChord> remainingQueuedChords;
  final bool returnedToNormalFlow;
  final SmartRenderingPlan renderingPlan;
  final SmartDecisionTrace debug;
  final ModulationKind modulationKind;
  final bool cadentialArrival;
  final bool modulationAttempt;
  final SmartPhraseContext phraseContext;

  String get finalKey => finalKeyCenter.tonicName;
}
