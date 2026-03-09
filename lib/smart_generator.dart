import 'dart:math';

import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'settings/practice_settings.dart';

enum SmartProgressionFamily {
  coreIiVIMajor,
  turnaroundIViIiV,
  turnaroundISharpIdimIiV,
  turnaroundIIIviIiV,
  minorIiVAltI,
  minorLineCliche,
  backdoorIvmBviiI,
  dominantChainBridgeStyle,
  appliedDominantWithRelatedIi,
  passingDimToIi,
  commonChordModulation,
  cadenceBasedRealModulation,
}

enum _PhrasePriority { low, cadence, boundary }

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
    this.suppressTensions = false,
    this.appliedType,
    this.resolutionTargetRomanId,
    this.dominantContext,
    this.modulationKind = ModulationKind.none,
    this.cadentialArrival = false,
    this.modulationAttempt = false,
  });

  final KeyCenter keyCenter;
  final RomanNumeralId finalRomanNumeralId;
  final PlannedChordKind plannedChordKind;
  final String patternTag;
  final bool suppressTensions;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final DominantContext? dominantContext;
  final ModulationKind modulationKind;
  final bool cadentialArrival;

  final bool modulationAttempt;

  QueuedSmartChord copyWith({
    KeyCenter? keyCenter,
    RomanNumeralId? finalRomanNumeralId,
    PlannedChordKind? plannedChordKind,
    String? patternTag,
    bool? suppressTensions,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    ModulationKind? modulationKind,
    bool? cadentialArrival,
    bool? modulationAttempt,
  }) {
    return QueuedSmartChord(
      keyCenter: keyCenter ?? this.keyCenter,
      finalRomanNumeralId: finalRomanNumeralId ?? this.finalRomanNumeralId,
      plannedChordKind: plannedChordKind ?? this.plannedChordKind,
      patternTag: patternTag ?? this.patternTag,
      suppressTensions: suppressTensions ?? this.suppressTensions,
      appliedType: appliedType ?? this.appliedType,
      resolutionTargetRomanId:
          resolutionTargetRomanId ?? this.resolutionTargetRomanId,
      dominantContext: dominantContext ?? this.dominantContext,
      modulationKind: modulationKind ?? this.modulationKind,
      cadentialArrival: cadentialArrival ?? this.cadentialArrival,
      modulationAttempt: modulationAttempt ?? this.modulationAttempt,
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

class SmartDecisionTrace implements SmartDebugInfo {
  const SmartDecisionTrace({
    required this.stepIndex,
    required this.currentKeyCenter,
    required this.currentRomanNumeralId,
    required this.currentHarmonicFunction,
    this.selectedDiatonicDestination,
    this.modalInterchangeCandidates = const [],
    this.selectedModalInterchange,
    this.appliedCandidates = const [],
    this.selectedAppliedApproach,
    this.appliedType,
    this.appliedTargetRomanNumeralId,
    this.modulationCandidateKeys = const [],
    this.blockedReason,
    this.fallbackOccurred = false,
    this.modulationAttempted = false,
    this.modulationSucceeded = false,
    this.finalKeyCenter,
    this.finalRomanNumeralId,
    this.finalChord,
    this.decision,
    this.transitionDebugSummary,
    this.activePatternTag,
    this.queuedPatternLength = 0,
    this.returnedToNormalFlow = false,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.finalSourceKind = ChordSourceKind.diatonic,
    this.dominantContext,
    this.modulationKind = ModulationKind.none,
    this.cadentialArrival = false,
  });

  final int stepIndex;
  final String currentKeyCenter;
  final RomanNumeralId currentRomanNumeralId;
  final HarmonicFunction currentHarmonicFunction;
  final RomanNumeralId? selectedDiatonicDestination;
  final List<RomanNumeralId> modalInterchangeCandidates;
  final RomanNumeralId? selectedModalInterchange;
  final List<RomanNumeralId> appliedCandidates;
  final RomanNumeralId? selectedAppliedApproach;
  final AppliedType? appliedType;
  final RomanNumeralId? appliedTargetRomanNumeralId;
  final List<String> modulationCandidateKeys;
  final SmartBlockedReason? blockedReason;
  final bool fallbackOccurred;
  final bool modulationAttempted;
  final bool modulationSucceeded;
  final String? finalKeyCenter;
  final RomanNumeralId? finalRomanNumeralId;
  final String? finalChord;
  final String? decision;
  final String? transitionDebugSummary;
  final String? activePatternTag;
  final int queuedPatternLength;
  final bool returnedToNormalFlow;
  final PlannedChordKind plannedChordKind;
  final ChordSourceKind finalSourceKind;
  final DominantContext? dominantContext;
  final ModulationKind modulationKind;
  final bool cadentialArrival;

  RomanNumeralId? get insertedAppliedApproach => selectedAppliedApproach;

  SmartDecisionTrace withDecision(
    String nextDecision, {
    SmartBlockedReason? nextBlockedReason,
    bool? nextFallbackOccurred,
  }) {
    return SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      selectedDiatonicDestination: selectedDiatonicDestination,
      modalInterchangeCandidates: modalInterchangeCandidates,
      selectedModalInterchange: selectedModalInterchange,
      appliedCandidates: appliedCandidates,
      selectedAppliedApproach: selectedAppliedApproach,
      appliedType: appliedType,
      appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
      modulationCandidateKeys: modulationCandidateKeys,
      blockedReason: nextBlockedReason ?? blockedReason,
      fallbackOccurred: nextFallbackOccurred ?? fallbackOccurred,
      modulationAttempted: modulationAttempted,
      modulationSucceeded: modulationSucceeded,
      finalKeyCenter: finalKeyCenter,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      decision: nextDecision,
      transitionDebugSummary: transitionDebugSummary,
      activePatternTag: activePatternTag,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
      dominantContext: dominantContext,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
    );
  }

  SmartDecisionTrace withFinalSelection({
    required KeyCenter finalKeyCenter,
    required RomanNumeralId finalRomanNumeralId,
    required String finalChord,
    required bool fallbackOccurred,
  }) {
    return SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      selectedDiatonicDestination: selectedDiatonicDestination,
      modalInterchangeCandidates: modalInterchangeCandidates,
      selectedModalInterchange: selectedModalInterchange,
      appliedCandidates: appliedCandidates,
      selectedAppliedApproach: selectedAppliedApproach,
      appliedType: appliedType,
      appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
      modulationCandidateKeys: modulationCandidateKeys,
      blockedReason: blockedReason,
      fallbackOccurred: fallbackOccurred,
      modulationAttempted: modulationAttempted,
      modulationSucceeded: modulationSucceeded,
      finalKeyCenter: finalKeyCenter.displayName,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      decision: decision,
      transitionDebugSummary: transitionDebugSummary,
      activePatternTag: activePatternTag,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
      dominantContext: dominantContext,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
    );
  }

  @override
  String describe() {
    final modulationKeys = modulationCandidateKeys.isEmpty
        ? '-'
        : modulationCandidateKeys.join(', ');
    return 'step=$stepIndex '
        'currentKeyCenter=$currentKeyCenter '
        'currentRoman=${MusicTheory.romanTokenOf(currentRomanNumeralId)} '
        'currentFunction=${currentHarmonicFunction.name} '
        'destination=${_token(selectedDiatonicDestination)} '
        'modalSelected=${_token(selectedModalInterchange)} '
        'appliedSelected=${_token(selectedAppliedApproach)} '
        'appliedType=${appliedType?.name ?? '-'} '
        'appliedTarget=${_token(appliedTargetRomanNumeralId)} '
        'modulationCandidates=[$modulationKeys] '
        'blockedReason=${blockedReason?.name ?? '-'} '
        'fallback=$fallbackOccurred '
        'modulationAttempted=$modulationAttempted '
        'modulationSucceeded=$modulationSucceeded '
        'modulationKind=${modulationKind.name} '
        'dominantContext=${dominantContext?.name ?? '-'} '
        'cadentialArrival=$cadentialArrival '
        'pattern=${activePatternTag ?? '-'} '
        'queueLength=$queuedPatternLength '
        'returnedToNormalFlow=$returnedToNormalFlow '
        'finalKeyCenter=${finalKeyCenter ?? '-'} '
        'finalRoman=${_token(finalRomanNumeralId)} '
        'finalChord=${finalChord ?? '-'} '
        'decision=${decision ?? '-'} '
        'transition=${transitionDebugSummary ?? '-'}';
  }

  String _token(RomanNumeralId? value) {
    return value == null ? '-' : MusicTheory.romanTokenOf(value);
  }
}

typedef SmartGenerationDebug = SmartDecisionTrace;

class SmartDiagnosticsStore {
  static const int _maxTraceCount = 512;
  static final List<SmartDecisionTrace> _recentTraces = <SmartDecisionTrace>[];

  static void record(SmartDecisionTrace trace) {
    _recentTraces.add(trace);
    if (_recentTraces.length > _maxTraceCount) {
      _recentTraces.removeAt(0);
    }
  }

  static List<SmartDecisionTrace> recent() =>
      List<SmartDecisionTrace>.unmodifiable(_recentTraces);

  static void clear() {
    _recentTraces.clear();
  }
}

class SmartRenderingPlan {
  const SmartRenderingPlan({
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.patternTag,
    this.suppressTensions = false,
    this.dominantContext,
  });

  final PlannedChordKind plannedChordKind;
  final String? patternTag;
  final bool suppressTensions;
  final DominantContext? dominantContext;
}

class SmartStartRequest {
  const SmartStartRequest({
    required this.activeKeys,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationIntensity,
    required this.jazzPreset,
    required this.sourceProfile,
    required this.smartDiagnosticsEnabled,
  });

  final List<String> activeKeys;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final ModulationIntensity modulationIntensity;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final bool smartDiagnosticsEnabled;
}

class SmartStepRequest {
  const SmartStepRequest({
    required this.stepIndex,
    required this.activeKeys,
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
    required this.smartDiagnosticsEnabled,
    required this.previousRomanNumeralId,
    required this.previousHarmonicFunction,
    required this.previousWasAppliedDominant,
    required this.currentPatternTag,
    required this.plannedQueue,
    required this.currentRenderedNonDiatonic,
  });

  final int stepIndex;
  final List<String> activeKeys;
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
  final bool smartDiagnosticsEnabled;
  final RomanNumeralId? previousRomanNumeralId;
  final HarmonicFunction? previousHarmonicFunction;
  final bool previousWasAppliedDominant;
  final String? currentPatternTag;
  final List<QueuedSmartChord> plannedQueue;
  final bool currentRenderedNonDiatonic;
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

  String get finalKey => finalKeyCenter.tonicName;
}

class SmartSimulationSummary {
  const SmartSimulationSummary({
    required this.steps,
    required this.modulationAttemptCount,
    required this.modulationSuccessCount,
    required this.blockedReasonHistogram,
    required this.modalBranchCount,
    required this.appliedDominantInsertionCount,
    required this.fallbackCount,
    required this.familyHistogram,
    required this.traces,
  });

  final int steps;
  final int modulationAttemptCount;
  final int modulationSuccessCount;
  final Map<SmartBlockedReason, int> blockedReasonHistogram;
  final int modalBranchCount;
  final int appliedDominantInsertionCount;
  final int fallbackCount;
  final Map<String, int> familyHistogram;
  final List<SmartDecisionTrace> traces;
}

class SmartGeneratorHelper {
  const SmartGeneratorHelper._();

  static const Map<RomanNumeralId, RomanNumeralId>
  secondaryDominantByResolution = {
    RomanNumeralId.iiMin7: RomanNumeralId.secondaryOfII,
    RomanNumeralId.iiiMin7: RomanNumeralId.secondaryOfIII,
    RomanNumeralId.ivMaj7: RomanNumeralId.secondaryOfIV,
    RomanNumeralId.vDom7: RomanNumeralId.secondaryOfV,
    RomanNumeralId.viMin7: RomanNumeralId.secondaryOfVI,
  };

  static const Map<RomanNumeralId, RomanNumeralId>
  substituteDominantByResolution = {
    RomanNumeralId.iiMin7: RomanNumeralId.substituteOfII,
    RomanNumeralId.iiiMin7: RomanNumeralId.substituteOfIII,
    RomanNumeralId.ivMaj7: RomanNumeralId.substituteOfIV,
    RomanNumeralId.vDom7: RomanNumeralId.substituteOfV,
    RomanNumeralId.viMin7: RomanNumeralId.substituteOfVI,
  };

  static const Map<RomanNumeralId, List<WeightedNextRoman>>
  majorDiatonicTransitions = {
    RomanNumeralId.iMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 34),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 30),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 12),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 9),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 5),
    ],
    RomanNumeralId.iMaj69: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 36),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 31),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 11),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 12),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 10),
    ],
    RomanNumeralId.iiMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 78),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 12),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.viiHalfDiminished7,
        weight: 10,
      ),
    ],
    RomanNumeralId.iiiMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 62),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 22),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 16),
    ],
    RomanNumeralId.ivMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 64),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 22),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 14),
    ],
    RomanNumeralId.vDom7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 62),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 20),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 12),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 6),
    ],
    RomanNumeralId.viMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 62),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 18),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 12),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj69, weight: 8),
    ],
    RomanNumeralId.viiHalfDiminished7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 55),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 35),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
    ],
  };

  static const Map<RomanNumeralId, List<WeightedNextRoman>>
  minorDiatonicTransitions = {
    RomanNumeralId.iMinMaj7: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
        weight: 28,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
        weight: 16,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin7, weight: 16),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 16),
    ],
    RomanNumeralId.iMin7: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
        weight: 28,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatVIIDom7Minor,
        weight: 14,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 18),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 16),
    ],
    RomanNumeralId.iMin6: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
        weight: 30,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 24),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
        weight: 16,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 18),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatVIMaj7Minor,
        weight: 12,
      ),
    ],
    RomanNumeralId.iiHalfDiminishedMinor: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 82),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 18),
    ],
    RomanNumeralId.flatIIIMaj7Minor: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 34),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 32),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatVIMaj7Minor,
        weight: 20,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 14),
    ],
    RomanNumeralId.ivMin7Minor: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 70),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatVIIDom7Minor,
        weight: 18,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 12),
    ],
    RomanNumeralId.vDom7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 46),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMinMaj7, weight: 34),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin7, weight: 20),
    ],
    RomanNumeralId.flatVIMaj7Minor: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
        weight: 30,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMin7Minor, weight: 26),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 24),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 20),
    ],
    RomanNumeralId.flatVIIDom7Minor: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMin6, weight: 48),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.flatIIIMaj7Minor,
        weight: 32,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 20),
    ],
  };

  static SmartTransitionSelection selectNextRoman({
    required Random random,
    required RomanNumeralId? currentRomanNumeralId,
    required Iterable<RomanNumeralId> allowedRomanNumerals,
    KeyMode currentKeyMode = KeyMode.major,
  }) {
    final allowedSet = allowedRomanNumerals.toSet();
    final configuredCandidates =
        (currentKeyMode == KeyMode.major
        ? majorDiatonicTransitions
        : minorDiatonicTransitions)[_normalizedTransitionRoman(
          currentRomanNumeralId,
          currentKeyMode,
        )];

    if (currentRomanNumeralId == null || configuredCandidates == null) {
      return SmartTransitionSelection(
        selectedRomanNumeralId: null,
        debug: SmartTransitionDebug(
          currentRomanNumeralId: currentRomanNumeralId,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeralId: null,
          fallbackReason:
              'No weighted transition is configured for the current Roman numeral.',
        ),
      );
    }

    final filteredCandidates = [
      for (final candidate in configuredCandidates)
        if (allowedSet.contains(candidate.romanNumeralId)) candidate,
    ];
    return _selectWeightedCandidate(
      random: random,
      currentRomanNumeralId: currentRomanNumeralId,
      filteredCandidates: filteredCandidates,
      emptyReason:
          'All weighted transition candidates were filtered out by the current settings.',
      nonPositiveReason:
          'Weighted transition candidates produced a non-positive total weight.',
    );
  }

  static List<String> findCompatibleModulationKeys({
    required Iterable<String> activeKeys,
    required String currentKey,
    required int targetSemitone,
    required int? Function(String key) keyTonicSemitoneResolver,
  }) {
    return [
      for (final key in activeKeys)
        if (key != currentKey &&
            keyTonicSemitoneResolver(key) == targetSemitone)
          key,
    ];
  }

  static QueuedSmartChordDecision dequeuePlannedSmartChord({
    required List<QueuedSmartChord> plannedQueue,
  }) {
    return QueuedSmartChordDecision(
      queuedChord: plannedQueue.first,
      remainingQueuedChords: plannedQueue.sublist(1),
    );
  }

  static List<SmartDecisionTrace> recentDiagnostics() {
    return SmartDiagnosticsStore.recent();
  }

  static SmartStepPlan planInitialStep({
    required Random random,
    required SmartStartRequest request,
  }) {
    final startingCenter = _selectInitialKeyCenter(
      random: random,
      activeKeys: request.activeKeys,
      jazzPreset: request.jazzPreset,
      sourceProfile: request.sourceProfile,
    );
    final tonicRoman = startingCenter.mode == KeyMode.major
        ? RomanNumeralId.iMaj69
        : _selectMinorTonic(random, request.sourceProfile);
    final syntheticRequest = SmartStepRequest(
      stepIndex: 0,
      activeKeys: request.activeKeys,
      currentKeyCenter: startingCenter,
      currentRomanNumeralId: tonicRoman,
      currentResolutionRomanNumeralId: null,
      currentHarmonicFunction: HarmonicFunction.tonic,
      secondaryDominantEnabled: request.secondaryDominantEnabled,
      substituteDominantEnabled: request.substituteDominantEnabled,
      modalInterchangeEnabled: request.modalInterchangeEnabled,
      modulationIntensity: request.modulationIntensity,
      jazzPreset: request.jazzPreset,
      sourceProfile: request.sourceProfile,
      smartDiagnosticsEnabled: request.smartDiagnosticsEnabled,
      previousRomanNumeralId: null,
      previousHarmonicFunction: null,
      previousWasAppliedDominant: false,
      currentPatternTag: null,
      plannedQueue: const [],
      currentRenderedNonDiatonic: false,
    );
    final familyPlans = _buildFamilyPlans(
      random: random,
      request: syntheticRequest,
      opportunity: const _ModulationOpportunity(candidates: []),
      allowRealModulation: false,
      includeLeadingTonic: true,
    );
    if (familyPlans.isEmpty) {
      return _buildPlanFromQueuedChord(
        stepIndex: 0,
        currentKeyCenter: startingCenter,
        currentRomanNumeralId: tonicRoman,
        currentHarmonicFunction: HarmonicFunction.tonic,
        queuedDecision: QueuedSmartChordDecision(
          queuedChord: _queuedChord(
            keyCenter: startingCenter,
            roman: tonicRoman,
            patternTag: 'initial_tonic',
            cadentialArrival: true,
          ),
          remainingQueuedChords: const [],
        ),
        destinationRomanNumeralId: tonicRoman,
        decision: 'seeded-initial-tonic',
      );
    }

    final selectedFamily = _selectFamilyPlan(
      random: random,
      request: syntheticRequest,
      familyPlans: familyPlans,
      opportunity: const _ModulationOpportunity(candidates: []),
    );
    return _planFromFamily(
      stepIndex: 0,
      currentKeyCenter: startingCenter,
      currentRomanNumeralId: tonicRoman,
      currentHarmonicFunction: HarmonicFunction.tonic,
      familyPlan: selectedFamily,
      blockedReason: null,
      decision: 'seeded-initial-family:${_familyTag(selectedFamily.family)}',
    );
  }

  static SmartStepPlan planNextStep({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.plannedQueue.isNotEmpty) {
      final queuedDecision = dequeuePlannedSmartChord(
        plannedQueue: request.plannedQueue,
      );
      return _buildPlanFromQueuedChord(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        currentRomanNumeralId: request.currentRomanNumeralId,
        currentHarmonicFunction: request.currentHarmonicFunction,
        queuedDecision: queuedDecision,
        destinationRomanNumeralId:
            queuedDecision.queuedChord.finalRomanNumeralId,
        decision: 'queued-family-step',
      );
    }

    final phrasePriority = _phrasePriorityForStep(request.stepIndex);
    final opportunity = _modulationOpportunityForRequest(
      request: request,
      phrasePriority: phrasePriority,
    );

    if (_isAppliedDominant(request.currentRomanNumeralId)) {
      return _resolveDanglingAppliedChord(
        random: random,
        request: request,
        opportunity: opportunity,
      );
    }

    if (_isModalInterchange(request.currentRomanNumeralId)) {
      return _resolveDanglingModalChord(request: request);
    }

    final familyPlans = _buildFamilyPlans(
      random: random,
      request: request,
      opportunity: opportunity,
      allowRealModulation: true,
      includeLeadingTonic: false,
    );
    if (familyPlans.isNotEmpty) {
      final selectedFamily = _selectFamilyPlan(
        random: random,
        request: request,
        familyPlans: familyPlans,
        opportunity: opportunity,
      );
      final blockedReason =
          _familyTag(selectedFamily.family) == 'backdoor_ivm_bVII_I' &&
              opportunity.candidates.isNotEmpty
          ? SmartBlockedReason.modalBranchChosen
          : opportunity.blockedReason;
      return _planFromFamily(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        currentRomanNumeralId: request.currentRomanNumeralId,
        currentHarmonicFunction: request.currentHarmonicFunction,
        familyPlan: selectedFamily,
        blockedReason: blockedReason,
        decision: 'seeded-family:${_familyTag(selectedFamily.family)}',
      );
    }

    return _planFallbackContinuation(
      random: random,
      request: request,
      opportunity: opportunity,
    );
  }

  static SmartSimulationSummary simulateSteps({
    required Random random,
    required int steps,
    required SmartStartRequest request,
  }) {
    final traces = <SmartDecisionTrace>[];
    final blockedReasonHistogram = <SmartBlockedReason, int>{};
    final familyHistogram = <String, int>{};

    SmartDiagnosticsStore.clear();
    var modulationAttemptCount = 0;
    var modulationSuccessCount = 0;
    var modalBranchCount = 0;
    var appliedDominantInsertionCount = 0;
    var fallbackCount = 0;
    var plannedQueue = const <QueuedSmartChord>[];

    GeneratedChord? currentChord;
    for (var step = 0; step < steps; step += 1) {
      SmartStepPlan plan;
      if (currentChord == null) {
        plan = planInitialStep(random: random, request: request);
      } else {
        plan = planNextStep(
          random: random,
          request: SmartStepRequest(
            stepIndex:
                ((currentChord.smartDebug as SmartDecisionTrace?)?.stepIndex ??
                    0) +
                1,
            activeKeys: request.activeKeys,
            currentKeyCenter:
                currentChord.keyCenter ??
                MusicTheory.keyCenterFor(currentChord.keyName ?? 'C'),
            currentRomanNumeralId:
                currentChord.romanNumeralId ?? RomanNumeralId.iMaj7,
            currentResolutionRomanNumeralId:
                currentChord.resolutionTargetRomanId,
            currentHarmonicFunction: currentChord.harmonicFunction,
            secondaryDominantEnabled: request.secondaryDominantEnabled,
            substituteDominantEnabled: request.substituteDominantEnabled,
            modalInterchangeEnabled: request.modalInterchangeEnabled,
            modulationIntensity: request.modulationIntensity,
            jazzPreset: request.jazzPreset,
            sourceProfile: request.sourceProfile,
            smartDiagnosticsEnabled: request.smartDiagnosticsEnabled,
            previousRomanNumeralId:
                (currentChord.smartDebug as SmartDecisionTrace?)
                    ?.currentRomanNumeralId,
            previousHarmonicFunction:
                (currentChord.smartDebug as SmartDecisionTrace?)
                    ?.currentHarmonicFunction,
            previousWasAppliedDominant: currentChord.isAppliedDominant,
            currentPatternTag: currentChord.patternTag,
            plannedQueue: plannedQueue,
            currentRenderedNonDiatonic: currentChord.isRenderedNonDiatonic,
          ),
        );
      }

      plannedQueue = plan.remainingQueuedChords;
      var simulatedChord = _buildSimulatedChord(
        random: random,
        keyCenter: plan.finalKeyCenter,
        romanNumeralId: plan.finalRomanNumeralId,
        plannedChordKind: plan.plannedChordKind,
        patternTag: plan.patternTag,
        appliedType: plan.appliedType,
        resolutionTargetRomanId: plan.resolutionTargetRomanId,
        dominantContext: plan.renderingPlan.dominantContext,
        smartDebug: plan.debug,
      );

      final exclusionContext = currentChord == null
          ? const ChordExclusionContext()
          : ChordExclusionContext(
              renderedSymbols: {
                ChordRenderingHelper.renderedSymbol(
                  currentChord,
                  ChordSymbolStyle.majText,
                ),
              },
              repeatGuardKeys: {currentChord.repeatGuardKey},
              harmonicComparisonKeys: {currentChord.harmonicComparisonKey},
            );
      if (_isExcludedCandidate(simulatedChord, exclusionContext)) {
        fallbackCount += 1;
        simulatedChord = _buildSimulatedChord(
          random: random,
          keyCenter:
              currentChord?.keyCenter ??
              MusicTheory.keyCenterFor(request.activeKeys.first),
          romanNumeralId: (currentChord?.keyCenter?.mode == KeyMode.minor
              ? RomanNumeralId.iMin6
              : RomanNumeralId.iMaj69),
          plannedChordKind: PlannedChordKind.resolvedRoman,
          smartDebug: plan.debug.withDecision(
            'excluded-fallback',
            nextBlockedReason: SmartBlockedReason.excludedFallback,
            nextFallbackOccurred: true,
          ),
        );
      }

      final trace = simulatedChord.smartDebug as SmartDecisionTrace?;
      if (trace != null) {
        traces.add(trace);
        SmartDiagnosticsStore.record(trace);
        if (trace.blockedReason != null) {
          blockedReasonHistogram.update(
            trace.blockedReason!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
        if (trace.modulationAttempted) {
          modulationAttemptCount += 1;
        }
        if (trace.modulationSucceeded) {
          modulationSuccessCount += 1;
        }
        if (trace.blockedReason == SmartBlockedReason.modalBranchChosen) {
          modalBranchCount += 1;
        }
        if (trace.selectedAppliedApproach != null) {
          appliedDominantInsertionCount += 1;
        }
        if (trace.activePatternTag != null) {
          familyHistogram.update(
            trace.activePatternTag!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }

      currentChord = simulatedChord;
    }

    return SmartSimulationSummary(
      steps: steps,
      modulationAttemptCount: modulationAttemptCount,
      modulationSuccessCount: modulationSuccessCount,
      blockedReasonHistogram: blockedReasonHistogram,
      modalBranchCount: modalBranchCount,
      appliedDominantInsertionCount: appliedDominantInsertionCount,
      fallbackCount: fallbackCount,
      familyHistogram: familyHistogram,
      traces: traces,
    );
  }

  static GeneratedChord _buildSimulatedChord({
    required Random random,
    required KeyCenter keyCenter,
    required RomanNumeralId romanNumeralId,
    required PlannedChordKind plannedChordKind,
    String? patternTag,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    SmartDecisionTrace? smartDebug,
  }) {
    final spec = MusicTheory.specFor(romanNumeralId);
    final root = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      romanNumeralId,
    );
    final renderQuality = MusicTheory.resolveRenderQuality(
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      allowV7sus4: true,
      randomRoll: random.nextInt(100),
      dominantContext: dominantContext,
    );
    final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
      random: random,
      root: root,
      harmonicQuality: spec.quality,
      renderQuality: renderQuality,
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      sourceKind: spec.sourceKind,
      allowTensions: true,
      selectedTensionOptions: ChordRenderingHelper.supportedTensionOptions
          .toSet(),
      suppressTensions: false,
      inversionSettings: const InversionSettings(),
      dominantContext: dominantContext,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: keyCenter.tonicName,
      romanNumeralId: romanNumeralId,
      harmonicFunction: _harmonicFunctionForRoman(
        romanNumeralId: romanNumeralId,
        plannedChordKind: plannedChordKind,
        appliedType: appliedType,
      ),
      plannedChordKind: plannedChordKind,
      symbolData: renderingSelection.symbolData,
      sourceKind: spec.sourceKind,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
      patternTag: patternTag,
      dominantContext: dominantContext,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
          keyName: keyCenter.tonicName,
          romanNumeralId: romanNumeralId,
          harmonicFunction: _harmonicFunctionForRoman(
            romanNumeralId: romanNumeralId,
            plannedChordKind: plannedChordKind,
            appliedType: appliedType,
          ),
          plannedChordKind: plannedChordKind,
          symbolData: renderingSelection.symbolData,
          sourceKind: spec.sourceKind,
          appliedType: appliedType,
          resolutionTargetRomanId: resolutionTargetRomanId,
          patternTag: patternTag,
          dominantContext: dominantContext,
        );
    final chord = GeneratedChord(
      symbolData: renderingSelection.symbolData,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      keyName: keyCenter.tonicName,
      keyCenter: keyCenter,
      romanNumeralId: romanNumeralId,
      resolutionRomanNumeralId: spec.resolutionTargetId,
      harmonicFunction: _harmonicFunctionForRoman(
        romanNumeralId: romanNumeralId,
        plannedChordKind: plannedChordKind,
        appliedType: appliedType,
      ),
      patternTag: patternTag,
      plannedChordKind: plannedChordKind,
      sourceKind: spec.sourceKind,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
      dominantContext: dominantContext,
      smartDebug: smartDebug,
      isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
    );
    if (smartDebug == null) {
      return chord;
    }
    return chord.copyWith(
      smartDebug: smartDebug.withFinalSelection(
        finalKeyCenter: keyCenter,
        finalRomanNumeralId: romanNumeralId,
        finalChord: ChordRenderingHelper.renderedSymbol(
          chord,
          ChordSymbolStyle.majText,
        ),
        fallbackOccurred: smartDebug.fallbackOccurred,
      ),
    );
  }

  static bool _isExcludedCandidate(
    GeneratedChord candidate,
    ChordExclusionContext exclusionContext,
  ) {
    return exclusionContext.renderedSymbols.contains(
          ChordRenderingHelper.renderedSymbol(
            candidate,
            ChordSymbolStyle.majText,
          ),
        ) ||
        exclusionContext.repeatGuardKeys.contains(candidate.repeatGuardKey) ||
        exclusionContext.harmonicComparisonKeys.contains(
          candidate.harmonicComparisonKey,
        );
  }

  static SmartStepPlan _resolveDanglingAppliedChord({
    required Random random,
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
  }) {
    final targetRoman =
        request.currentResolutionRomanNumeralId ?? RomanNumeralId.iiMin7;
    final targetMode = _appliedTargetMode(
      request.currentKeyCenter,
      targetRoman,
    );
    if (opportunity.candidates.isNotEmpty &&
        request.modulationIntensity != ModulationIntensity.off &&
        _phrasePriorityForStep(request.stepIndex) != _PhrasePriority.low) {
      final modulationFamily =
          _buildCadenceBasedRealModulationFamily(
            targetCenter: opportunity.candidates.first,
          ) ??
          _buildCommonChordModulationFamily(
            request: request,
            targetCenter: opportunity.candidates.first,
          );
      if (modulationFamily != null) {
        return _planFromFamily(
          stepIndex: request.stepIndex,
          currentKeyCenter: request.currentKeyCenter,
          currentRomanNumeralId: request.currentRomanNumeralId,
          currentHarmonicFunction: request.currentHarmonicFunction,
          familyPlan: modulationFamily,
          blockedReason: null,
          decision: 'resolved-applied-via-real-modulation',
        );
      }
    }

    final trace = SmartDecisionTrace(
      stepIndex: request.stepIndex,
      currentKeyCenter: request.currentKeyCenter.displayName,
      currentRomanNumeralId: request.currentRomanNumeralId,
      currentHarmonicFunction: request.currentHarmonicFunction,
      selectedDiatonicDestination: targetRoman,
      appliedCandidates: [request.currentRomanNumeralId],
      selectedAppliedApproach: request.currentRomanNumeralId,
      appliedType: _appliedTypeForRoman(request.currentRomanNumeralId),
      appliedTargetRomanNumeralId: targetRoman,
      modulationCandidateKeys: [
        for (final candidate in opportunity.candidates) candidate.displayName,
      ],
      blockedReason: opportunity.blockedReason,
      modulationAttempted: opportunity.candidates.isNotEmpty,
      finalKeyCenter: request.currentKeyCenter.displayName,
      finalRomanNumeralId: targetRoman,
      decision: 'resolved-dangling-applied',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      finalSourceKind: MusicTheory.specFor(targetRoman).sourceKind,
      dominantContext: targetMode == KeyMode.minor
          ? DominantContext.secondaryToMinor
          : DominantContext.secondaryToMajor,
      modulationKind: ModulationKind.tonicization,
    );
    return SmartStepPlan(
      finalKeyCenter: request.currentKeyCenter,
      finalRomanNumeralId: targetRoman,
      appliedType: null,
      resolutionTargetRomanId: null,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: null,
      remainingQueuedChords: const [],
      returnedToNormalFlow: true,
      renderingPlan: SmartRenderingPlan(
        dominantContext: targetMode == KeyMode.minor
            ? DominantContext.secondaryToMinor
            : DominantContext.secondaryToMajor,
      ),
      debug: trace,
      modulationKind: ModulationKind.tonicization,
      cadentialArrival: false,
      modulationAttempt: opportunity.candidates.isNotEmpty,
    );
  }

  static SmartStepPlan _resolveDanglingModalChord({
    required SmartStepRequest request,
  }) {
    final exitSelection =
        request.currentRomanNumeralId == RomanNumeralId.borrowedFlatVII7
        ? RomanNumeralId.iMaj69
        : request.currentRomanNumeralId == RomanNumeralId.borrowedIvMin7
        ? RomanNumeralId.borrowedFlatVII7
        : RomanNumeralId.iMaj69;
    final trace = SmartDecisionTrace(
      stepIndex: request.stepIndex,
      currentKeyCenter: request.currentKeyCenter.displayName,
      currentRomanNumeralId: request.currentRomanNumeralId,
      currentHarmonicFunction: request.currentHarmonicFunction,
      selectedDiatonicDestination: exitSelection,
      modalInterchangeCandidates: [request.currentRomanNumeralId],
      selectedModalInterchange: request.currentRomanNumeralId,
      finalKeyCenter: request.currentKeyCenter.displayName,
      finalRomanNumeralId: exitSelection,
      decision: 'resolved-dangling-modal',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      finalSourceKind: MusicTheory.specFor(exitSelection).sourceKind,
      cadentialArrival: exitSelection == RomanNumeralId.iMaj69,
    );
    return SmartStepPlan(
      finalKeyCenter: request.currentKeyCenter,
      finalRomanNumeralId: exitSelection,
      appliedType: null,
      resolutionTargetRomanId: null,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: null,
      remainingQueuedChords: const [],
      returnedToNormalFlow: true,
      renderingPlan: const SmartRenderingPlan(),
      debug: trace,
      modulationKind: ModulationKind.none,
      cadentialArrival: exitSelection == RomanNumeralId.iMaj69,
      modulationAttempt: false,
    );
  }

  static SmartStepPlan _planFromFamily({
    required int stepIndex,
    required KeyCenter currentKeyCenter,
    required RomanNumeralId currentRomanNumeralId,
    required HarmonicFunction currentHarmonicFunction,
    required _FamilyPlan familyPlan,
    required SmartBlockedReason? blockedReason,
    required String decision,
  }) {
    final queuedDecision = dequeuePlannedSmartChord(
      plannedQueue: familyPlan.queue,
    );
    return _buildPlanFromQueuedChord(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      queuedDecision: queuedDecision,
      destinationRomanNumeralId: familyPlan.destinationRomanNumeralId,
      decision: decision,
      blockedReason: blockedReason,
      modalCandidates: familyPlan.modalCandidates,
      appliedCandidates: familyPlan.appliedCandidates,
      modulationCandidates: familyPlan.modulationCandidates,
    );
  }

  static SmartStepPlan _buildPlanFromQueuedChord({
    required int stepIndex,
    required KeyCenter currentKeyCenter,
    required RomanNumeralId currentRomanNumeralId,
    required HarmonicFunction currentHarmonicFunction,
    required QueuedSmartChordDecision queuedDecision,
    required RomanNumeralId destinationRomanNumeralId,
    required String decision,
    SmartBlockedReason? blockedReason,
    List<RomanNumeralId> modalCandidates = const [],
    List<RomanNumeralId> appliedCandidates = const [],
    List<KeyCenter> modulationCandidates = const [],
  }) {
    final queuedRoman = queuedDecision.queuedChord.finalRomanNumeralId;
    final queuedSourceKind = MusicTheory.specFor(queuedRoman).sourceKind;
    final trace = SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter.displayName,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      selectedDiatonicDestination: destinationRomanNumeralId,
      modalInterchangeCandidates: modalCandidates,
      selectedModalInterchange: modalCandidates.contains(queuedRoman)
          ? queuedRoman
          : null,
      appliedCandidates: appliedCandidates,
      selectedAppliedApproach: queuedDecision.queuedChord.appliedType == null
          ? null
          : queuedRoman,
      appliedType: queuedDecision.queuedChord.appliedType,
      appliedTargetRomanNumeralId:
          queuedDecision.queuedChord.resolutionTargetRomanId,
      modulationCandidateKeys: [
        for (final candidate in modulationCandidates) candidate.displayName,
      ],
      blockedReason: blockedReason,
      modulationAttempted: queuedDecision.queuedChord.modulationAttempt,
      modulationSucceeded:
          queuedDecision.queuedChord.modulationKind == ModulationKind.real &&
          queuedDecision.queuedChord.cadentialArrival,
      finalKeyCenter: queuedDecision.queuedChord.keyCenter.displayName,
      finalRomanNumeralId: queuedRoman,
      decision: decision,
      activePatternTag: queuedDecision.queuedChord.patternTag,
      queuedPatternLength: queuedDecision.remainingQueuedChords.length,
      returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
      plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
      finalSourceKind: queuedSourceKind,
      dominantContext: queuedDecision.queuedChord.dominantContext,
      modulationKind: queuedDecision.queuedChord.modulationKind,
      cadentialArrival: queuedDecision.queuedChord.cadentialArrival,
    );
    return SmartStepPlan(
      finalKeyCenter: queuedDecision.queuedChord.keyCenter,
      finalRomanNumeralId: queuedRoman,
      appliedType: queuedDecision.queuedChord.appliedType,
      resolutionTargetRomanId:
          queuedDecision.queuedChord.resolutionTargetRomanId,
      plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
      patternTag: queuedDecision.queuedChord.patternTag,
      remainingQueuedChords: queuedDecision.remainingQueuedChords,
      returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
      renderingPlan: SmartRenderingPlan(
        plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
        patternTag: queuedDecision.queuedChord.patternTag,
        suppressTensions: queuedDecision.queuedChord.suppressTensions,
        dominantContext: queuedDecision.queuedChord.dominantContext,
      ),
      debug: trace,
      modulationKind: queuedDecision.queuedChord.modulationKind,
      cadentialArrival: queuedDecision.queuedChord.cadentialArrival,
      modulationAttempt: queuedDecision.queuedChord.modulationAttempt,
    );
  }

  static SmartStepPlan _planFallbackContinuation({
    required Random random,
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
  }) {
    final allowedRomans = MusicTheory.diatonicRomansForMode(
      request.currentKeyCenter.mode,
    );
    final destinationSelection = selectNextRoman(
      random: random,
      currentRomanNumeralId: request.currentRomanNumeralId,
      allowedRomanNumerals: allowedRomans,
      currentKeyMode: request.currentKeyCenter.mode,
    );
    final selectedDestination =
        destinationSelection.selectedRomanNumeralId ??
        allowedRomans[random.nextInt(allowedRomans.length)];

    final approachDecision = _maybeInsertAppliedApproach(
      random: random,
      request: request,
      destinationRomanNumeralId: selectedDestination,
    );
    final trace = SmartDecisionTrace(
      stepIndex: request.stepIndex,
      currentKeyCenter: request.currentKeyCenter.displayName,
      currentRomanNumeralId: request.currentRomanNumeralId,
      currentHarmonicFunction: request.currentHarmonicFunction,
      selectedDiatonicDestination: selectedDestination,
      appliedCandidates: [
        if (secondaryDominantByResolution[selectedDestination] != null)
          secondaryDominantByResolution[selectedDestination]!,
        if (substituteDominantByResolution[selectedDestination] != null)
          substituteDominantByResolution[selectedDestination]!,
      ],
      selectedAppliedApproach: approachDecision.insertedAppliedApproach,
      appliedType: approachDecision.appliedType,
      appliedTargetRomanNumeralId: approachDecision.appliedTargetRomanNumeralId,
      modulationCandidateKeys: [
        for (final candidate in opportunity.candidates) candidate.displayName,
      ],
      blockedReason: approachDecision.insertedApproach
          ? opportunity.blockedReason
          : SmartBlockedReason.appliedNotInserted,
      decision: approachDecision.insertedApproach
          ? 'fallback-with-applied-approach'
          : 'fallback-diatonic-continuation',
      transitionDebugSummary: destinationSelection.debug.describe(),
      plannedChordKind: PlannedChordKind.resolvedRoman,
      finalSourceKind: MusicTheory.specFor(
        approachDecision.selectedRomanNumeralId,
      ).sourceKind,
      dominantContext: approachDecision.dominantContext,
      modulationKind: approachDecision.insertedApproach
          ? ModulationKind.tonicization
          : ModulationKind.none,
    );
    return SmartStepPlan(
      finalKeyCenter: request.currentKeyCenter,
      finalRomanNumeralId: approachDecision.selectedRomanNumeralId,
      appliedType: approachDecision.appliedType,
      resolutionTargetRomanId: approachDecision.appliedTargetRomanNumeralId,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: null,
      remainingQueuedChords: const [],
      returnedToNormalFlow: true,
      renderingPlan: SmartRenderingPlan(
        dominantContext: approachDecision.dominantContext,
      ),
      debug: trace,
      modulationKind: approachDecision.insertedApproach
          ? ModulationKind.tonicization
          : ModulationKind.none,
      cadentialArrival: false,
      modulationAttempt: false,
    );
  }

  static SmartApproachDecision _maybeInsertAppliedApproach({
    required Random random,
    required SmartStepRequest request,
    required RomanNumeralId destinationRomanNumeralId,
  }) {
    final secondaryDominant =
        secondaryDominantByResolution[destinationRomanNumeralId];
    final substituteDominant =
        substituteDominantByResolution[destinationRomanNumeralId];
    final targetMode = _appliedTargetMode(
      request.currentKeyCenter,
      destinationRomanNumeralId,
    );
    if (!request.secondaryDominantEnabled &&
        !request.substituteDominantEnabled) {
      return SmartApproachDecision(
        destinationRomanNumeralId: destinationRomanNumeralId,
        selectedRomanNumeralId: destinationRomanNumeralId,
        appliedType: null,
        dominantContext: null,
      );
    }

    final useSubstitute =
        request.substituteDominantEnabled &&
        substituteDominant != null &&
        random.nextInt(100) < 18;
    if (useSubstitute) {
      return SmartApproachDecision(
        destinationRomanNumeralId: destinationRomanNumeralId,
        selectedRomanNumeralId: substituteDominant,
        appliedType: AppliedType.substitute,
        dominantContext: DominantContext.tritoneSubstitute,
        appliedTargetRomanNumeralId: destinationRomanNumeralId,
      );
    }
    if (request.secondaryDominantEnabled && secondaryDominant != null) {
      final threshold = targetMode == KeyMode.minor ? 38 : 24;
      if (random.nextInt(100) < threshold) {
        return SmartApproachDecision(
          destinationRomanNumeralId: destinationRomanNumeralId,
          selectedRomanNumeralId: secondaryDominant,
          appliedType: AppliedType.secondary,
          dominantContext: targetMode == KeyMode.minor
              ? DominantContext.secondaryToMinor
              : destinationRomanNumeralId == RomanNumeralId.vDom7
              ? DominantContext.dominantIILydian
              : DominantContext.secondaryToMajor,
          appliedTargetRomanNumeralId: destinationRomanNumeralId,
        );
      }
    }
    return SmartApproachDecision(
      destinationRomanNumeralId: destinationRomanNumeralId,
      selectedRomanNumeralId: destinationRomanNumeralId,
      appliedType: null,
      dominantContext: null,
    );
  }

  static List<_FamilyPlan> _buildFamilyPlans({
    required Random random,
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
    required bool allowRealModulation,
    required bool includeLeadingTonic,
  }) {
    final weightedFamilies = _weightedFamiliesForRequest(
      request: request,
      opportunity: opportunity,
      allowRealModulation: allowRealModulation,
    );
    final plans = <_FamilyPlan>[];
    for (final weighted in weightedFamilies) {
      if (weighted.weight <= 0) {
        continue;
      }
      final built = _buildFamily(
        random: random,
        request: request,
        family: weighted.family,
        opportunity: opportunity,
        includeLeadingTonic: includeLeadingTonic,
      );
      if (built != null) {
        plans.add(built);
      }
    }
    return plans;
  }

  static _FamilyPlan _selectFamilyPlan({
    required Random random,
    required SmartStepRequest request,
    required List<_FamilyPlan> familyPlans,
    required _ModulationOpportunity opportunity,
  }) {
    final weights = _weightedFamiliesForRequest(
      request: request,
      opportunity: opportunity,
      allowRealModulation: true,
    );
    final weightByFamily = {
      for (final item in weights) item.family: item.weight,
    };
    final totalWeight = familyPlans.fold<int>(
      0,
      (sum, plan) => sum + (weightByFamily[plan.family] ?? 1),
    );
    var remaining = random.nextInt(totalWeight);
    for (final plan in familyPlans) {
      final weight = weightByFamily[plan.family] ?? 1;
      if (remaining < weight) {
        return plan;
      }
      remaining -= weight;
    }
    return familyPlans.last;
  }

  static List<_WeightedFamily> _weightedFamiliesForRequest({
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
    required bool allowRealModulation,
  }) {
    final weights = <SmartProgressionFamily, int>{};
    switch (request.jazzPreset) {
      case JazzPreset.standardsCore:
        weights.addAll({
          SmartProgressionFamily.coreIiVIMajor: 26,
          SmartProgressionFamily.turnaroundIViIiV: 9,
          SmartProgressionFamily.turnaroundISharpIdimIiV: 5,
          SmartProgressionFamily.turnaroundIIIviIiV: 4,
          SmartProgressionFamily.minorIiVAltI: 14,
          SmartProgressionFamily.minorLineCliche: 6,
          SmartProgressionFamily.appliedDominantWithRelatedIi: 10,
          SmartProgressionFamily.dominantChainBridgeStyle: 8,
          SmartProgressionFamily.cadenceBasedRealModulation: 5,
          SmartProgressionFamily.commonChordModulation: 3,
          SmartProgressionFamily.backdoorIvmBviiI: 6,
          SmartProgressionFamily.passingDimToIi: 3,
        });
      case JazzPreset.modulationStudy:
        weights.addAll({
          SmartProgressionFamily.coreIiVIMajor: 18,
          SmartProgressionFamily.turnaroundIViIiV: 6,
          SmartProgressionFamily.turnaroundISharpIdimIiV: 4,
          SmartProgressionFamily.turnaroundIIIviIiV: 4,
          SmartProgressionFamily.minorIiVAltI: 12,
          SmartProgressionFamily.minorLineCliche: 6,
          SmartProgressionFamily.appliedDominantWithRelatedIi: 8,
          SmartProgressionFamily.dominantChainBridgeStyle: 10,
          SmartProgressionFamily.cadenceBasedRealModulation: 12,
          SmartProgressionFamily.commonChordModulation: 10,
          SmartProgressionFamily.backdoorIvmBviiI: 5,
          SmartProgressionFamily.passingDimToIi: 3,
        });
      case JazzPreset.advanced:
        weights.addAll({
          SmartProgressionFamily.coreIiVIMajor: 20,
          SmartProgressionFamily.turnaroundIViIiV: 8,
          SmartProgressionFamily.turnaroundISharpIdimIiV: 6,
          SmartProgressionFamily.turnaroundIIIviIiV: 6,
          SmartProgressionFamily.minorIiVAltI: 14,
          SmartProgressionFamily.minorLineCliche: 7,
          SmartProgressionFamily.appliedDominantWithRelatedIi: 11,
          SmartProgressionFamily.dominantChainBridgeStyle: 12,
          SmartProgressionFamily.cadenceBasedRealModulation: 8,
          SmartProgressionFamily.commonChordModulation: 7,
          SmartProgressionFamily.backdoorIvmBviiI: 6,
          SmartProgressionFamily.passingDimToIi: 3,
        });
    }

    if (request.sourceProfile == SourceProfile.recordingInspired) {
      weights.update(
        SmartProgressionFamily.dominantChainBridgeStyle,
        (value) => value + 2,
      );
      weights.update(
        SmartProgressionFamily.backdoorIvmBviiI,
        (value) => value + 2,
      );
      weights.update(
        SmartProgressionFamily.minorLineCliche,
        (value) => value + 1,
      );
      weights.update(
        SmartProgressionFamily.coreIiVIMajor,
        (value) => max(0, value - 2),
      );
    }

    final phrasePriority = _phrasePriorityForStep(request.stepIndex);
    if (phrasePriority == _PhrasePriority.low) {
      weights.update(
        SmartProgressionFamily.cadenceBasedRealModulation,
        (value) =>
            request.modulationIntensity == ModulationIntensity.high ? 2 : 0,
      );
      weights.update(
        SmartProgressionFamily.commonChordModulation,
        (value) =>
            request.modulationIntensity == ModulationIntensity.high ? 1 : 0,
      );
    } else if (phrasePriority == _PhrasePriority.cadence) {
      weights.update(
        SmartProgressionFamily.coreIiVIMajor,
        (value) => value + 8,
      );
      weights.update(SmartProgressionFamily.minorIiVAltI, (value) => value + 8);
      weights.update(
        SmartProgressionFamily.backdoorIvmBviiI,
        (value) => value + 3,
      );
      weights.update(
        SmartProgressionFamily.cadenceBasedRealModulation,
        (value) => value + 5,
      );
      weights.update(
        SmartProgressionFamily.commonChordModulation,
        (value) => value + 4,
      );
    } else {
      weights.update(
        SmartProgressionFamily.turnaroundIViIiV,
        (value) => value + 3,
      );
      weights.update(
        SmartProgressionFamily.turnaroundISharpIdimIiV,
        (value) => value + 2,
      );
    }

    if (request.currentKeyCenter.mode == KeyMode.major) {
      weights[SmartProgressionFamily.minorIiVAltI] = 0;
      weights[SmartProgressionFamily.minorLineCliche] = 0;
    } else {
      weights[SmartProgressionFamily.coreIiVIMajor] = 0;
      weights[SmartProgressionFamily.turnaroundIViIiV] = 0;
      weights[SmartProgressionFamily.turnaroundISharpIdimIiV] = 0;
      weights[SmartProgressionFamily.turnaroundIIIviIiV] = 0;
      weights[SmartProgressionFamily.backdoorIvmBviiI] = 0;
      weights[SmartProgressionFamily.passingDimToIi] = 0;
    }

    if (!request.modalInterchangeEnabled) {
      weights[SmartProgressionFamily.backdoorIvmBviiI] = 0;
    }
    if (!request.secondaryDominantEnabled &&
        !request.substituteDominantEnabled) {
      weights[SmartProgressionFamily.appliedDominantWithRelatedIi] = 0;
      weights[SmartProgressionFamily.dominantChainBridgeStyle] = 0;
    }
    if (!allowRealModulation ||
        request.modulationIntensity == ModulationIntensity.off) {
      weights[SmartProgressionFamily.cadenceBasedRealModulation] = 0;
      weights[SmartProgressionFamily.commonChordModulation] = 0;
    }
    if (opportunity.candidates.isEmpty) {
      weights[SmartProgressionFamily.cadenceBasedRealModulation] = 0;
      weights[SmartProgressionFamily.commonChordModulation] = 0;
    }

    if (request.currentHarmonicFunction == HarmonicFunction.tonic) {
      weights.update(
        request.currentKeyCenter.mode == KeyMode.major
            ? SmartProgressionFamily.turnaroundIViIiV
            : SmartProgressionFamily.minorLineCliche,
        (value) => value + 4,
        ifAbsent: () => 4,
      );
    }
    if (request.currentHarmonicFunction == HarmonicFunction.predominant) {
      weights.update(
        request.currentKeyCenter.mode == KeyMode.major
            ? SmartProgressionFamily.coreIiVIMajor
            : SmartProgressionFamily.minorIiVAltI,
        (value) => value + 5,
        ifAbsent: () => 5,
      );
    }

    return [
      for (final entry in weights.entries)
        _WeightedFamily(family: entry.key, weight: entry.value),
    ];
  }

  static _FamilyPlan? _buildFamily({
    required Random random,
    required SmartStepRequest request,
    required SmartProgressionFamily family,
    required _ModulationOpportunity opportunity,
    required bool includeLeadingTonic,
  }) {
    switch (family) {
      case SmartProgressionFamily.coreIiVIMajor:
        return _buildCoreIiVIMajorFamily(
          request: request,
          includeLeadingTonic: includeLeadingTonic,
        );
      case SmartProgressionFamily.turnaroundIViIiV:
        return _buildTurnaroundIViIiVFamily(
          request: request,
          includeLeadingTonic: includeLeadingTonic,
        );
      case SmartProgressionFamily.turnaroundISharpIdimIiV:
        return _buildTurnaroundISharpIdimIiVFamily(
          request: request,
          includeLeadingTonic: includeLeadingTonic,
        );
      case SmartProgressionFamily.turnaroundIIIviIiV:
        return _buildTurnaroundIIIviIiVFamily(request: request);
      case SmartProgressionFamily.minorIiVAltI:
        return _buildMinorIiVAltIFamily(request: request);
      case SmartProgressionFamily.minorLineCliche:
        return _buildMinorLineClicheFamily(
          request: request,
          includeLeadingTonic: includeLeadingTonic,
        );
      case SmartProgressionFamily.backdoorIvmBviiI:
        return _buildBackdoorFamily(request: request);
      case SmartProgressionFamily.dominantChainBridgeStyle:
        return _buildDominantChainFamily(random: random, request: request);
      case SmartProgressionFamily.appliedDominantWithRelatedIi:
        return _buildAppliedDominantWithRelatedIiFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.passingDimToIi:
        return _buildPassingDimToIiFamily(request: request);
      case SmartProgressionFamily.commonChordModulation:
        return opportunity.candidates.isEmpty
            ? null
            : _buildCommonChordModulationFamily(
                request: request,
                targetCenter: opportunity.candidates.first,
              );
      case SmartProgressionFamily.cadenceBasedRealModulation:
        return opportunity.candidates.isEmpty
            ? null
            : _buildCadenceBasedRealModulationFamily(
                targetCenter: opportunity.candidates.first,
              );
    }
  }

  static _FamilyPlan? _buildCoreIiVIMajorFamily({
    required SmartStepRequest request,
    required bool includeLeadingTonic,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.coreIiVIMajor,
      destination: RomanNumeralId.iMaj69,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.iMaj69,
            patternTag: _familyTag(SmartProgressionFamily.coreIiVIMajor),
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: _familyTag(SmartProgressionFamily.coreIiVIMajor),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(SmartProgressionFamily.coreIiVIMajor),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: _familyTag(SmartProgressionFamily.coreIiVIMajor),
          cadentialArrival: true,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildTurnaroundIViIiVFamily({
    required SmartStepRequest request,
    required bool includeLeadingTonic,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.turnaroundIViIiV,
      destination: RomanNumeralId.vDom7,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.iMaj69,
            patternTag: _familyTag(SmartProgressionFamily.turnaroundIViIiV),
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.viMin7,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIViIiV),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIViIiV),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIViIiV),
        ),
      ],
    );
  }

  static _FamilyPlan? _buildTurnaroundISharpIdimIiVFamily({
    required SmartStepRequest request,
    required bool includeLeadingTonic,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.turnaroundISharpIdimIiV,
      destination: RomanNumeralId.vDom7,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.iMaj69,
            patternTag: _familyTag(
              SmartProgressionFamily.turnaroundISharpIdimIiV,
            ),
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.sharpIDim7,
          patternTag: _familyTag(
            SmartProgressionFamily.turnaroundISharpIdimIiV,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: _familyTag(
            SmartProgressionFamily.turnaroundISharpIdimIiV,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(
            SmartProgressionFamily.turnaroundISharpIdimIiV,
          ),
        ),
      ],
    );
  }

  static _FamilyPlan? _buildTurnaroundIIIviIiVFamily({
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.turnaroundIIIviIiV,
      destination: RomanNumeralId.vDom7,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiiMin7,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIIIviIiV),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.viMin7,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIIIviIiV),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIIIviIiV),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(SmartProgressionFamily.turnaroundIIIviIiV),
        ),
      ],
    );
  }

  static _FamilyPlan? _buildMinorIiVAltIFamily({
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.minor) {
      return null;
    }
    final tonic = _selectMinorArrivalFromContext(request.sourceProfile);
    return _family(
      family: SmartProgressionFamily.minorIiVAltI,
      destination: tonic,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiHalfDiminishedMinor,
          patternTag: _familyTag(SmartProgressionFamily.minorIiVAltI),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMinor,
          patternTag: _familyTag(SmartProgressionFamily.minorIiVAltI),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: tonic,
          patternTag: _familyTag(SmartProgressionFamily.minorIiVAltI),
          cadentialArrival: true,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildMinorLineClicheFamily({
    required SmartStepRequest request,
    required bool includeLeadingTonic,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.minor) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.minorLineCliche,
      destination: RomanNumeralId.iMin6,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.iMinMaj7,
            patternTag: _familyTag(SmartProgressionFamily.minorLineCliche),
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMin7,
          patternTag: _familyTag(SmartProgressionFamily.minorLineCliche),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMin6,
          patternTag: _familyTag(SmartProgressionFamily.minorLineCliche),
          cadentialArrival: true,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildBackdoorFamily({
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major ||
        !request.modalInterchangeEnabled) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.backdoorIvmBviiI,
      destination: RomanNumeralId.iMaj69,
      modalCandidates: const [
        RomanNumeralId.borrowedIvMin7,
        RomanNumeralId.borrowedFlatVII7,
      ],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedIvMin7,
          patternTag: _familyTag(SmartProgressionFamily.backdoorIvmBviiI),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedFlatVII7,
          dominantContext: DominantContext.backdoor,
          patternTag: _familyTag(SmartProgressionFamily.backdoorIvmBviiI),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: _familyTag(SmartProgressionFamily.backdoorIvmBviiI),
          cadentialArrival: true,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildDominantChainFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (!request.secondaryDominantEnabled &&
        !request.substituteDominantEnabled) {
      return null;
    }
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.dominantChainBridgeStyle,
      destination: RomanNumeralId.iMaj69,
      appliedCandidates: const [
        RomanNumeralId.secondaryOfIII,
        RomanNumeralId.secondaryOfVI,
        RomanNumeralId.secondaryOfII,
        RomanNumeralId.secondaryOfV,
      ],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: request.substituteDominantEnabled && random.nextInt(100) < 12
              ? RomanNumeralId.substituteOfIII
              : RomanNumeralId.secondaryOfIII,
          appliedType:
              request.substituteDominantEnabled && random.nextInt(100) < 12
              ? AppliedType.substitute
              : AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.iiiMin7,
          dominantContext:
              request.substituteDominantEnabled && random.nextInt(100) < 12
              ? DominantContext.tritoneSubstitute
              : DominantContext.secondaryToMinor,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfVI,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.viMin7,
          dominantContext: DominantContext.secondaryToMinor,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfII,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.iiMin7,
          dominantContext: DominantContext.secondaryToMajor,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfV,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.vDom7,
          dominantContext: DominantContext.dominantIILydian,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: _familyTag(
            SmartProgressionFamily.dominantChainBridgeStyle,
          ),
          cadentialArrival: true,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildAppliedDominantWithRelatedIiFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    if (!request.secondaryDominantEnabled &&
        !request.substituteDominantEnabled) {
      return null;
    }

    final targetRoll = random.nextInt(100);
    RomanNumeralId relatedIi;
    RomanNumeralId targetRoman;
    RomanNumeralId dominantRoman;
    DominantContext dominantContext;
    if (targetRoll < 35) {
      relatedIi = RomanNumeralId.iiiMin7;
      targetRoman = RomanNumeralId.iiMin7;
      dominantRoman =
          request.substituteDominantEnabled && random.nextInt(100) < 16
          ? RomanNumeralId.substituteOfII
          : RomanNumeralId.secondaryOfII;
      dominantContext = dominantRoman == RomanNumeralId.substituteOfII
          ? DominantContext.tritoneSubstitute
          : DominantContext.secondaryToMajor;
    } else if (targetRoll < 70) {
      relatedIi = RomanNumeralId.viiHalfDiminished7;
      targetRoman = RomanNumeralId.viMin7;
      dominantRoman =
          request.substituteDominantEnabled && random.nextInt(100) < 16
          ? RomanNumeralId.substituteOfVI
          : RomanNumeralId.secondaryOfVI;
      dominantContext = dominantRoman == RomanNumeralId.substituteOfVI
          ? DominantContext.tritoneSubstitute
          : DominantContext.secondaryToMinor;
    } else {
      relatedIi = RomanNumeralId.relatedIiOfIII;
      targetRoman = RomanNumeralId.iiiMin7;
      dominantRoman =
          request.substituteDominantEnabled && random.nextInt(100) < 16
          ? RomanNumeralId.substituteOfIII
          : RomanNumeralId.secondaryOfIII;
      dominantContext = dominantRoman == RomanNumeralId.substituteOfIII
          ? DominantContext.tritoneSubstitute
          : DominantContext.secondaryToMinor;
    }

    final appliedType = _appliedTypeForRoman(dominantRoman);
    return _family(
      family: SmartProgressionFamily.appliedDominantWithRelatedIi,
      destination: targetRoman,
      appliedCandidates: [dominantRoman],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: relatedIi,
          patternTag: _familyTag(
            SmartProgressionFamily.appliedDominantWithRelatedIi,
          ),
          modulationKind: ModulationKind.tonicization,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: dominantRoman,
          appliedType: appliedType,
          resolutionTargetRomanId: targetRoman,
          dominantContext: dominantContext,
          patternTag: _familyTag(
            SmartProgressionFamily.appliedDominantWithRelatedIi,
          ),
          modulationKind: ModulationKind.tonicization,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: targetRoman,
          patternTag: _familyTag(
            SmartProgressionFamily.appliedDominantWithRelatedIi,
          ),
          modulationKind: ModulationKind.tonicization,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildPassingDimToIiFamily({
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.passingDimToIi,
      destination: RomanNumeralId.iiMin7,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.sharpIDim7,
          patternTag: _familyTag(SmartProgressionFamily.passingDimToIi),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: _familyTag(SmartProgressionFamily.passingDimToIi),
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          patternTag: _familyTag(SmartProgressionFamily.passingDimToIi),
        ),
      ],
    );
  }

  static _FamilyPlan? _buildCadenceBasedRealModulationFamily({
    required KeyCenter targetCenter,
  }) {
    final cadence = _cadenceQueueForTarget(
      targetCenter: targetCenter,
      patternTag: _familyTag(SmartProgressionFamily.cadenceBasedRealModulation),
      modulationAttempt: true,
    );
    if (cadence.isEmpty) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.cadenceBasedRealModulation,
      destination: cadence.last.finalRomanNumeralId,
      modulationCandidates: [targetCenter],
      queue: cadence,
    );
  }

  static _FamilyPlan? _buildCommonChordModulationFamily({
    required SmartStepRequest request,
    required KeyCenter targetCenter,
  }) {
    final pivot = _findCommonPivotChord(
      currentCenter: request.currentKeyCenter,
      targetCenter: targetCenter,
      currentRomanNumeralId: request.currentRomanNumeralId,
    );
    if (pivot == null) {
      return null;
    }
    final cadence = _cadenceQueueForTarget(
      targetCenter: targetCenter,
      patternTag: _familyTag(SmartProgressionFamily.commonChordModulation),
    );
    if (cadence.isEmpty) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.commonChordModulation,
      destination: cadence.last.finalRomanNumeralId,
      modulationCandidates: [targetCenter],
      queue: [
        pivot.copyWith(
          patternTag: _familyTag(SmartProgressionFamily.commonChordModulation),
          modulationAttempt: true,
        ),
        ...cadence,
      ],
    );
  }

  static QueuedSmartChord _queuedChord({
    required KeyCenter keyCenter,
    required RomanNumeralId roman,
    required String patternTag,
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    bool suppressTensions = false,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    ModulationKind modulationKind = ModulationKind.none,
    bool cadentialArrival = false,
    bool modulationAttempt = false,
  }) {
    return QueuedSmartChord(
      keyCenter: keyCenter,
      finalRomanNumeralId: roman,
      plannedChordKind: plannedChordKind,
      patternTag: patternTag,
      suppressTensions: suppressTensions,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
      dominantContext: dominantContext,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
      modulationAttempt: modulationAttempt,
    );
  }

  static _FamilyPlan _family({
    required SmartProgressionFamily family,
    required RomanNumeralId destination,
    required List<QueuedSmartChord> queue,
    List<RomanNumeralId> modalCandidates = const [],
    List<RomanNumeralId> appliedCandidates = const [],
    List<KeyCenter> modulationCandidates = const [],
  }) {
    return _FamilyPlan(
      family: family,
      queue: queue,
      destinationRomanNumeralId: destination,
      modalCandidates: modalCandidates,
      appliedCandidates: appliedCandidates,
      modulationCandidates: modulationCandidates,
    );
  }

  static List<QueuedSmartChord> _cadenceQueueForTarget({
    required KeyCenter targetCenter,
    required String patternTag,
    bool modulationAttempt = false,
  }) {
    if (targetCenter.mode == KeyMode.major) {
      return [
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          modulationKind: ModulationKind.real,
          modulationAttempt: modulationAttempt,
        ),
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.vDom7,
          patternTag: patternTag,
          dominantContext: DominantContext.primaryMajor,
          modulationKind: ModulationKind.real,
        ),
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: patternTag,
          modulationKind: ModulationKind.real,
          cadentialArrival: true,
        ),
      ];
    }
    final tonic = _selectMinorArrivalFromContext(
      SourceProfile.fakebookStandard,
    );
    return [
      _queuedChord(
        keyCenter: targetCenter,
        roman: RomanNumeralId.iiHalfDiminishedMinor,
        patternTag: patternTag,
        modulationKind: ModulationKind.real,
        modulationAttempt: modulationAttempt,
      ),
      _queuedChord(
        keyCenter: targetCenter,
        roman: RomanNumeralId.vDom7,
        patternTag: patternTag,
        dominantContext: DominantContext.primaryMinor,
        modulationKind: ModulationKind.real,
      ),
      _queuedChord(
        keyCenter: targetCenter,
        roman: tonic,
        patternTag: patternTag,
        modulationKind: ModulationKind.real,
        cadentialArrival: true,
      ),
    ];
  }

  static _ModulationOpportunity _modulationOpportunityForRequest({
    required SmartStepRequest request,
    required _PhrasePriority phrasePriority,
  }) {
    if (request.activeKeys.length <= 1) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.singleActiveKey,
      );
    }
    final candidates = _compatibleTargetCenters(
      currentCenter: request.currentKeyCenter,
      activeKeys: request.activeKeys,
      jazzPreset: request.jazzPreset,
    );
    if (candidates.isEmpty) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.noCompatibleKey,
      );
    }
    if (phrasePriority == _PhrasePriority.low &&
        request.modulationIntensity != ModulationIntensity.high) {
      return _ModulationOpportunity(
        candidates: candidates,
        blockedReason: SmartBlockedReason.phrasePositionLowPriority,
      );
    }
    return _ModulationOpportunity(
      candidates: candidates,
      allowPhraseBoundary: phrasePriority != _PhrasePriority.low,
    );
  }

  static List<KeyCenter> _compatibleTargetCenters({
    required KeyCenter currentCenter,
    required List<String> activeKeys,
    required JazzPreset jazzPreset,
  }) {
    final candidates = <KeyCenter>[];
    for (final key in activeKeys) {
      for (final mode in KeyMode.values) {
        final target = KeyCenter(tonicName: key, mode: mode);
        if (target == currentCenter) {
          continue;
        }
        final closeness = _closenessWeight(
          currentCenter: currentCenter,
          targetCenter: target,
          jazzPreset: jazzPreset,
        );
        if (closeness <= 0) {
          continue;
        }
        candidates.add(target.copyWith(closenessClass: closeness));
      }
    }
    candidates.sort((a, b) => b.closenessClass.compareTo(a.closenessClass));
    return candidates;
  }

  static int _closenessWeight({
    required KeyCenter currentCenter,
    required KeyCenter targetCenter,
    required JazzPreset jazzPreset,
  }) {
    final currentSemitone = currentCenter.tonicSemitone;
    final targetSemitone = targetCenter.tonicSemitone;
    if (currentSemitone == null || targetSemitone == null) {
      return 0;
    }
    final semitoneDistance = (targetSemitone - currentSemitone).abs() % 12;
    final interval = min(semitoneDistance, 12 - semitoneDistance);
    final relativePair =
        currentCenter.mode != targetCenter.mode &&
        ((currentSemitone + 3) % 12 == targetSemitone ||
            (currentSemitone + 9) % 12 == targetSemitone);
    if (relativePair) {
      return 6;
    }
    if (interval == 5 || interval == 7) {
      return 5;
    }
    if (interval == 2 || interval == 10) {
      return 3;
    }
    if (jazzPreset == JazzPreset.advanced && (interval == 3 || interval == 4)) {
      return 2;
    }
    return 0;
  }

  static QueuedSmartChord? _findCommonPivotChord({
    required KeyCenter currentCenter,
    required KeyCenter targetCenter,
    required RomanNumeralId currentRomanNumeralId,
  }) {
    final currentOptions = _pivotEligibleRomansForMode(currentCenter.mode);
    final targetOptions = _pivotEligibleRomansForMode(targetCenter.mode);
    for (final currentRoman in currentOptions) {
      if (currentRoman == currentRomanNumeralId) {
        continue;
      }
      final currentSpec = MusicTheory.specFor(currentRoman);
      final currentRoot = MusicTheory.resolveChordRootForCenter(
        currentCenter,
        currentRoman,
      );
      for (final targetRoman in targetOptions) {
        final targetSpec = MusicTheory.specFor(targetRoman);
        final targetRoot = MusicTheory.resolveChordRootForCenter(
          targetCenter,
          targetRoman,
        );
        if (currentRoot == targetRoot &&
            currentSpec.quality == targetSpec.quality &&
            currentSpec.harmonicFunction != HarmonicFunction.dominant &&
            targetSpec.harmonicFunction != HarmonicFunction.dominant) {
          return _queuedChord(
            keyCenter: currentCenter,
            roman: currentRoman,
            patternTag: 'common_chord_modulation',
          );
        }
      }
    }
    return null;
  }

  static List<RomanNumeralId> _pivotEligibleRomansForMode(KeyMode mode) {
    return mode == KeyMode.major
        ? const [
            RomanNumeralId.iMaj7,
            RomanNumeralId.iMaj69,
            RomanNumeralId.iiMin7,
            RomanNumeralId.iiiMin7,
            RomanNumeralId.ivMaj7,
            RomanNumeralId.viMin7,
          ]
        : const [
            RomanNumeralId.iMin7,
            RomanNumeralId.iMin6,
            RomanNumeralId.flatIIIMaj7Minor,
            RomanNumeralId.ivMin7Minor,
            RomanNumeralId.flatVIMaj7Minor,
          ];
  }

  static _PhrasePriority _phrasePriorityForStep(int stepIndex) {
    final phrasePosition = stepIndex % 8;
    if (phrasePosition == 7 || phrasePosition == 3) {
      return _PhrasePriority.boundary;
    }
    if (phrasePosition == 2 || phrasePosition == 6) {
      return _PhrasePriority.cadence;
    }
    return _PhrasePriority.low;
  }

  static KeyCenter _selectInitialKeyCenter({
    required Random random,
    required List<String> activeKeys,
    required JazzPreset jazzPreset,
    required SourceProfile sourceProfile,
  }) {
    final tonic = activeKeys[random.nextInt(activeKeys.length)];
    final minorWeight = switch (jazzPreset) {
      JazzPreset.standardsCore => 38,
      JazzPreset.modulationStudy => 44,
      JazzPreset.advanced => 48,
    };
    final adjustedMinorWeight = sourceProfile == SourceProfile.recordingInspired
        ? min(60, minorWeight + 4)
        : minorWeight;
    final mode = random.nextInt(100) < adjustedMinorWeight
        ? KeyMode.minor
        : KeyMode.major;
    return KeyCenter(tonicName: tonic, mode: mode);
  }

  static RomanNumeralId _selectMinorTonic(
    Random random,
    SourceProfile sourceProfile,
  ) {
    final roll = random.nextInt(100);
    if (sourceProfile == SourceProfile.recordingInspired) {
      if (roll < 44) {
        return RomanNumeralId.iMinMaj7;
      }
      if (roll < 78) {
        return RomanNumeralId.iMin6;
      }
      return RomanNumeralId.iMin7;
    }
    if (roll < 34) {
      return RomanNumeralId.iMinMaj7;
    }
    if (roll < 74) {
      return RomanNumeralId.iMin6;
    }
    return RomanNumeralId.iMin7;
  }

  static RomanNumeralId _selectMinorArrivalFromContext(SourceProfile profile) {
    return profile == SourceProfile.recordingInspired
        ? RomanNumeralId.iMinMaj7
        : RomanNumeralId.iMin6;
  }

  static RomanNumeralId _normalizedTransitionRoman(
    RomanNumeralId? roman,
    KeyMode mode,
  ) {
    if (roman == null) {
      return mode == KeyMode.major
          ? RomanNumeralId.iMaj7
          : RomanNumeralId.iMin6;
    }
    if (mode == KeyMode.major && roman == RomanNumeralId.iMaj69) {
      return RomanNumeralId.iMaj7;
    }
    return roman;
  }

  static bool _isAppliedDominant(RomanNumeralId romanNumeralId) {
    final sourceKind = MusicTheory.specFor(romanNumeralId).sourceKind;
    return sourceKind == ChordSourceKind.secondaryDominant ||
        sourceKind == ChordSourceKind.substituteDominant;
  }

  static bool _isModalInterchange(RomanNumeralId romanNumeralId) {
    return MusicTheory.specFor(romanNumeralId).sourceKind ==
        ChordSourceKind.modalInterchange;
  }

  static AppliedType? _appliedTypeForRoman(RomanNumeralId romanNumeralId) {
    final sourceKind = MusicTheory.specFor(romanNumeralId).sourceKind;
    if (sourceKind == ChordSourceKind.substituteDominant) {
      return AppliedType.substitute;
    }
    if (sourceKind == ChordSourceKind.secondaryDominant) {
      return AppliedType.secondary;
    }
    return null;
  }

  static KeyMode _appliedTargetMode(
    KeyCenter currentCenter,
    RomanNumeralId targetRoman,
  ) {
    if (currentCenter.mode == KeyMode.minor) {
      return KeyMode.minor;
    }
    return switch (targetRoman) {
      RomanNumeralId.iiiMin7 || RomanNumeralId.viMin7 => KeyMode.minor,
      _ => KeyMode.major,
    };
  }

  static HarmonicFunction _harmonicFunctionForRoman({
    required RomanNumeralId romanNumeralId,
    required PlannedChordKind plannedChordKind,
    AppliedType? appliedType,
  }) {
    if (appliedType == AppliedType.secondary ||
        appliedType == AppliedType.substitute) {
      return HarmonicFunction.dominant;
    }
    if (plannedChordKind != PlannedChordKind.resolvedRoman) {
      return HarmonicFunction.tonic;
    }
    return MusicTheory.specFor(romanNumeralId).harmonicFunction;
  }

  static SmartTransitionSelection _selectWeightedCandidate({
    required Random random,
    required RomanNumeralId? currentRomanNumeralId,
    required List<WeightedNextRoman> filteredCandidates,
    required String emptyReason,
    required String nonPositiveReason,
  }) {
    if (filteredCandidates.isEmpty) {
      return SmartTransitionSelection(
        selectedRomanNumeralId: null,
        debug: SmartTransitionDebug(
          currentRomanNumeralId: currentRomanNumeralId,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeralId: null,
          fallbackReason: emptyReason,
        ),
      );
    }

    final totalWeight = filteredCandidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    if (totalWeight <= 0) {
      return SmartTransitionSelection(
        selectedRomanNumeralId: null,
        debug: SmartTransitionDebug(
          currentRomanNumeralId: currentRomanNumeralId,
          availableCandidates: filteredCandidates,
          totalWeight: 0,
          roll: null,
          selectedRomanNumeralId: null,
          fallbackReason: nonPositiveReason,
        ),
      );
    }

    final roll = random.nextInt(totalWeight);
    var remaining = roll;
    for (final candidate in filteredCandidates) {
      if (remaining < candidate.weight) {
        return SmartTransitionSelection(
          selectedRomanNumeralId: candidate.romanNumeralId,
          debug: SmartTransitionDebug(
            currentRomanNumeralId: currentRomanNumeralId,
            availableCandidates: filteredCandidates,
            totalWeight: totalWeight,
            roll: roll,
            selectedRomanNumeralId: candidate.romanNumeralId,
          ),
        );
      }
      remaining -= candidate.weight;
    }

    final fallbackCandidate = filteredCandidates.last;
    return SmartTransitionSelection(
      selectedRomanNumeralId: fallbackCandidate.romanNumeralId,
      debug: SmartTransitionDebug(
        currentRomanNumeralId: currentRomanNumeralId,
        availableCandidates: filteredCandidates,
        totalWeight: totalWeight,
        roll: roll,
        selectedRomanNumeralId: fallbackCandidate.romanNumeralId,
      ),
    );
  }

  static String _familyTag(SmartProgressionFamily family) {
    return switch (family) {
      SmartProgressionFamily.coreIiVIMajor => 'core_ii_v_i_major',
      SmartProgressionFamily.turnaroundIViIiV => 'turnaround_i_vi_ii_v',
      SmartProgressionFamily.turnaroundISharpIdimIiV =>
        'turnaround_i_sharpIdim_ii_v',
      SmartProgressionFamily.turnaroundIIIviIiV => 'turnaround_iii_vi_ii_v',
      SmartProgressionFamily.minorIiVAltI => 'minor_ii_halfdim_v_alt_i',
      SmartProgressionFamily.minorLineCliche => 'minor_line_cliche',
      SmartProgressionFamily.backdoorIvmBviiI => 'backdoor_ivm_bVII_I',
      SmartProgressionFamily.dominantChainBridgeStyle =>
        'dominant_chain_bridge_style',
      SmartProgressionFamily.appliedDominantWithRelatedIi =>
        'applied_dominant_with_related_ii',
      SmartProgressionFamily.passingDimToIi => 'passing_dim_to_ii',
      SmartProgressionFamily.commonChordModulation => 'common_chord_modulation',
      SmartProgressionFamily.cadenceBasedRealModulation =>
        'cadence_based_real_modulation',
    };
  }
}
