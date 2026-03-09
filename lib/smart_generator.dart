import 'dart:math';

import 'music/chord_theory.dart';

class WeightedNextRoman {
  const WeightedNextRoman({
    required this.romanNumeralId,
    required this.weight,
  });

  final RomanNumeralId romanNumeralId;
  final int weight;
}

class QueuedSmartChord {
  const QueuedSmartChord({
    required this.finalRomanNumeralId,
    required this.plannedChordKind,
    required this.patternTag,
    this.suppressTensions = false,
  });

  final RomanNumeralId finalRomanNumeralId;
  final PlannedChordKind plannedChordKind;
  final String patternTag;
  final bool suppressTensions;
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
    this.appliedTargetRomanNumeralId,
    this.roll,
  });

  final RomanNumeralId destinationRomanNumeralId;
  final RomanNumeralId selectedRomanNumeralId;
  final AppliedType? appliedType;
  final RomanNumeralId? appliedTargetRomanNumeralId;
  final int? roll;

  RomanNumeralId? get insertedAppliedApproach =>
      appliedType == null ? null : selectedRomanNumeralId;

  bool get insertedApproach => appliedType != null;
}

class ModalInterchangeDecision {
  const ModalInterchangeDecision({
    required this.selectedRomanNumeralId,
    required this.remainingQueuedChords,
    required this.patternTag,
    required this.decision,
  });

  final RomanNumeralId selectedRomanNumeralId;
  final List<QueuedSmartChord> remainingQueuedChords;
  final String? patternTag;
  final String decision;
}

class AppliedResolutionDecision {
  const AppliedResolutionDecision({
    required this.finalKey,
    required this.finalRomanNumeralId,
    required this.appliedTargetRomanNumeralId,
    required this.modulationCandidateKeys,
    required this.resolvedToTarget,
    this.modulationKey,
  });

  final String finalKey;
  final RomanNumeralId finalRomanNumeralId;
  final RomanNumeralId appliedTargetRomanNumeralId;
  final List<String> modulationCandidateKeys;
  final bool resolvedToTarget;
  final String? modulationKey;

  bool get didModulate => modulationKey != null;
}

class SmartGenerationDebug implements SmartDebugInfo {
  const SmartGenerationDebug({
    required this.currentKey,
    required this.currentRomanNumeralId,
    this.selectedDiatonicDestination,
    this.insertedAppliedApproach,
    this.selectedModalInterchange,
    this.appliedType,
    this.appliedTargetRomanNumeralId,
    this.modulationCandidateKeys = const [],
    this.finalKey,
    this.finalRomanNumeralId,
    this.finalChord,
    this.decision,
    this.transitionDebugSummary,
    this.wasExcludedFallback = false,
    this.renderedIsNonDiatonic = false,
    this.activePatternTag,
    this.queuedPatternLength = 0,
    this.returnedToNormalFlow = false,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.finalSourceKind = ChordSourceKind.diatonic,
  });

  final String currentKey;
  final RomanNumeralId currentRomanNumeralId;
  final RomanNumeralId? selectedDiatonicDestination;
  final RomanNumeralId? insertedAppliedApproach;
  final RomanNumeralId? selectedModalInterchange;
  final AppliedType? appliedType;
  final RomanNumeralId? appliedTargetRomanNumeralId;
  final List<String> modulationCandidateKeys;
  final String? finalKey;
  final RomanNumeralId? finalRomanNumeralId;
  final String? finalChord;
  final String? decision;
  final String? transitionDebugSummary;
  final bool wasExcludedFallback;
  final bool renderedIsNonDiatonic;
  final String? activePatternTag;
  final int queuedPatternLength;
  final bool returnedToNormalFlow;
  final PlannedChordKind plannedChordKind;
  final ChordSourceKind finalSourceKind;

  SmartGenerationDebug withDecision(String nextDecision) {
    return SmartGenerationDebug(
      currentKey: currentKey,
      currentRomanNumeralId: currentRomanNumeralId,
      selectedDiatonicDestination: selectedDiatonicDestination,
      insertedAppliedApproach: insertedAppliedApproach,
      selectedModalInterchange: selectedModalInterchange,
      appliedType: appliedType,
      appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
      modulationCandidateKeys: modulationCandidateKeys,
      finalKey: finalKey,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      decision: nextDecision,
      transitionDebugSummary: transitionDebugSummary,
      wasExcludedFallback: wasExcludedFallback,
      renderedIsNonDiatonic: renderedIsNonDiatonic,
      activePatternTag: activePatternTag,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
    );
  }

  SmartGenerationDebug withFinalSelection({
    required String finalKey,
    required RomanNumeralId finalRomanNumeralId,
    required String finalChord,
    required bool renderedIsNonDiatonic,
    required bool wasExcludedFallback,
  }) {
    return SmartGenerationDebug(
      currentKey: currentKey,
      currentRomanNumeralId: currentRomanNumeralId,
      selectedDiatonicDestination: selectedDiatonicDestination,
      insertedAppliedApproach: insertedAppliedApproach,
      selectedModalInterchange: selectedModalInterchange,
      appliedType: appliedType,
      appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
      modulationCandidateKeys: modulationCandidateKeys,
      finalKey: finalKey,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      decision: decision,
      transitionDebugSummary: transitionDebugSummary,
      wasExcludedFallback: wasExcludedFallback,
      renderedIsNonDiatonic: renderedIsNonDiatonic,
      activePatternTag: activePatternTag,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
    );
  }

  @override
  String describe() {
    final modulationKeys = modulationCandidateKeys.isEmpty
        ? '-'
        : modulationCandidateKeys.join(', ');
    return 'currentKey=$currentKey '
        'currentRoman=${_token(currentRomanNumeralId)} '
        'destination=${_token(selectedDiatonicDestination)} '
        'modal=${_token(selectedModalInterchange)} '
        'appliedApproach=${_token(insertedAppliedApproach)} '
        'appliedType=${appliedType?.name ?? '-'} '
        'appliedTarget=${_token(appliedTargetRomanNumeralId)} '
        'pattern=${activePatternTag ?? '-'} '
        'plannedKind=${plannedChordKind.name} '
        'queueLength=$queuedPatternLength '
        'returnedToNormalFlow=$returnedToNormalFlow '
        'excludedFallback=$wasExcludedFallback '
        'renderedNonDiatonic=$renderedIsNonDiatonic '
        'finalSource=${finalSourceKind.name} '
        'modulationCandidates=[$modulationKeys] '
        'finalKey=${finalKey ?? '-'} '
        'finalRoman=${_token(finalRomanNumeralId)} '
        'finalChord=${finalChord ?? '-'} '
        'decision=${decision ?? '-'} '
        'transition=${transitionDebugSummary ?? '-'}';
  }

  String _token(RomanNumeralId? value) {
    return value == null ? '-' : MusicTheory.romanTokenOf(value);
  }
}

class SmartRenderingPlan {
  const SmartRenderingPlan({
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.patternTag,
    this.suppressTensions = false,
  });

  final PlannedChordKind plannedChordKind;
  final String? patternTag;
  final bool suppressTensions;
}

class SmartStepRequest {
  const SmartStepRequest({
    required this.currentKey,
    required this.currentRomanNumeralId,
    required this.currentResolutionRomanNumeralId,
    required this.currentHarmonicFunction,
    required this.allowedDiatonicRomanNumerals,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modalInterchangeEnabled,
    required this.modulationCandidateKeys,
    required this.previousRomanNumeralId,
    required this.previousHarmonicFunction,
    required this.previousWasAppliedDominant,
    required this.currentPatternTag,
    required this.plannedQueue,
    required this.currentRenderedNonDiatonic,
  });

  final String currentKey;
  final RomanNumeralId currentRomanNumeralId;
  final RomanNumeralId? currentResolutionRomanNumeralId;
  final HarmonicFunction currentHarmonicFunction;
  final List<RomanNumeralId> allowedDiatonicRomanNumerals;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final bool modalInterchangeEnabled;
  final List<String> modulationCandidateKeys;
  final RomanNumeralId? previousRomanNumeralId;
  final HarmonicFunction? previousHarmonicFunction;
  final bool previousWasAppliedDominant;
  final String? currentPatternTag;
  final List<QueuedSmartChord> plannedQueue;
  final bool currentRenderedNonDiatonic;
}

class SmartStepPlan {
  const SmartStepPlan({
    required this.finalKey,
    required this.finalRomanNumeralId,
    required this.appliedType,
    required this.resolutionTargetRomanId,
    required this.plannedChordKind,
    required this.patternTag,
    required this.remainingQueuedChords,
    required this.returnedToNormalFlow,
    required this.renderingPlan,
    required this.debug,
  });

  final String finalKey;
  final RomanNumeralId finalRomanNumeralId;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final PlannedChordKind plannedChordKind;
  final String? patternTag;
  final List<QueuedSmartChord> remainingQueuedChords;
  final bool returnedToNormalFlow;
  final SmartRenderingPlan renderingPlan;
  final SmartGenerationDebug debug;
}

class SmartGeneratorHelper {
  const SmartGeneratorHelper._();

  static const int secondaryApproachChance = 30;
  static const int substituteApproachChance = 14;
  static const int appliedResolutionChance = 88;
  static const int modulationChance = 30;
  static const int nonDiatonicVisibilityBoost = 8;
  static const int lineClicheTriggerChance = 6;

  static const int modalChanceTonic = 14;
  static const int modalChancePredominant = 18;
  static const int modalChanceDominant = 6;
  static const int modalChanceAfterNonDiatonic = 4;

  static const int backdoorTriggerChance = 55;
  static const int borrowedMinorTwoFiveTriggerChance = 70;
  static const int neapolitanDirectResolutionChance = 60;

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
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 40),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 35),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 10),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 5),
    ],
    RomanNumeralId.iiMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 85),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.viiHalfDiminished7,
        weight: 10,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 5),
    ],
    RomanNumeralId.iiiMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 80),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 10),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 10),
    ],
    RomanNumeralId.ivMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 70),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 20),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.viiHalfDiminished7,
        weight: 10,
      ),
    ],
    RomanNumeralId.vDom7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 75),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 20),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 5),
    ],
    RomanNumeralId.viMin7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 75),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.ivMaj7, weight: 15),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 10),
    ],
    RomanNumeralId.viiHalfDiminished7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 70),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 20),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiiMin7, weight: 10),
    ],
  };

  static const Map<HarmonicFunction, List<WeightedNextRoman>>
  modalPoolByContext = {
    HarmonicFunction.tonic: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedIvMin7,
        weight: 24,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVIMaj7,
        weight: 22,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIIMaj7,
        weight: 18,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        weight: 16,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedIiHalfDiminished7,
        weight: 12,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIMaj7,
        weight: 8,
      ),
    ],
    HarmonicFunction.predominant: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedIvMin7,
        weight: 28,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedIiHalfDiminished7,
        weight: 24,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVIMaj7,
        weight: 18,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        weight: 14,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIMaj7,
        weight: 10,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIIMaj7,
        weight: 6,
      ),
    ],
    HarmonicFunction.dominant: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVIMaj7,
        weight: 32,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIMaj7,
        weight: 24,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedIvMin7,
        weight: 18,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        weight: 16,
      ),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatIIIMaj7,
        weight: 10,
      ),
    ],
  };

  static const Map<RomanNumeralId, List<WeightedNextRoman>>
  modalExitTransitions = {
    RomanNumeralId.borrowedIvMin7: [
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        weight: 45,
      ),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 30),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 25),
    ],
    RomanNumeralId.borrowedFlatVII7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 75),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.viMin7, weight: 15),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 10),
    ],
    RomanNumeralId.borrowedFlatVIMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 55),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 25),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 20),
    ],
    RomanNumeralId.borrowedFlatIIIMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 45),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 35),
      WeightedNextRoman(
        romanNumeralId: RomanNumeralId.borrowedFlatVIMaj7,
        weight: 20,
      ),
    ],
    RomanNumeralId.borrowedIiHalfDiminished7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 80),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 20),
    ],
    RomanNumeralId.borrowedFlatIIMaj7: [
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iMaj7, weight: 60),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.vDom7, weight: 25),
      WeightedNextRoman(romanNumeralId: RomanNumeralId.iiMin7, weight: 15),
    ],
  };

  static SmartTransitionSelection selectNextRoman({
    required Random random,
    required RomanNumeralId? currentRomanNumeralId,
    required Iterable<RomanNumeralId> allowedRomanNumerals,
  }) {
    final allowedSet = allowedRomanNumerals.toSet();
    final configuredCandidates = majorDiatonicTransitions[currentRomanNumeralId];

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

  static SmartApproachDecision maybeInsertAppliedApproach({
    required Random random,
    required RomanNumeralId destinationRomanNumeralId,
    required bool secondaryDominantEnabled,
    required bool substituteDominantEnabled,
  }) {
    final secondaryDominant =
        secondaryDominantByResolution[destinationRomanNumeralId];
    final substituteDominant =
        substituteDominantByResolution[destinationRomanNumeralId];

    var secondaryWeight = secondaryDominantEnabled && secondaryDominant != null
        ? secondaryApproachChance
        : 0;
    var substituteWeight =
        substituteDominantEnabled && substituteDominant != null
        ? substituteApproachChance
        : 0;

    final totalAppliedWeight = secondaryWeight + substituteWeight;
    if (totalAppliedWeight > 0) {
      final secondaryBoost = secondaryWeight == 0
          ? 0
          : substituteWeight == 0
          ? nonDiatonicVisibilityBoost
          : (nonDiatonicVisibilityBoost * secondaryWeight ~/
                totalAppliedWeight);
      final substituteBoost = substituteWeight == 0
          ? 0
          : secondaryWeight == 0
          ? nonDiatonicVisibilityBoost
          : nonDiatonicVisibilityBoost - secondaryBoost;
      secondaryWeight += secondaryBoost;
      substituteWeight += substituteBoost;
    }

    final diatonicWeight = (100 - secondaryWeight - substituteWeight).clamp(
      1,
      100,
    );
    final candidates = <WeightedNextRoman>[
      WeightedNextRoman(
        romanNumeralId: destinationRomanNumeralId,
        weight: diatonicWeight,
      ),
    ];
    if (secondaryWeight > 0 && secondaryDominant != null) {
      candidates.add(
        WeightedNextRoman(
          romanNumeralId: secondaryDominant,
          weight: secondaryWeight,
        ),
      );
    }
    if (substituteWeight > 0 && substituteDominant != null) {
      candidates.add(
        WeightedNextRoman(
          romanNumeralId: substituteDominant,
          weight: substituteWeight,
        ),
      );
    }

    final totalWeight = candidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    final roll = random.nextInt(totalWeight);
    var remaining = roll;
    for (final candidate in candidates) {
      if (remaining < candidate.weight) {
        final appliedType = candidate.romanNumeralId == destinationRomanNumeralId
            ? null
            : _appliedTypeForRoman(candidate.romanNumeralId);
        return SmartApproachDecision(
          destinationRomanNumeralId: destinationRomanNumeralId,
          selectedRomanNumeralId: candidate.romanNumeralId,
          appliedType: appliedType,
          appliedTargetRomanNumeralId:
              appliedType == null ? null : destinationRomanNumeralId,
          roll: roll,
        );
      }
      remaining -= candidate.weight;
    }

    return SmartApproachDecision(
      destinationRomanNumeralId: destinationRomanNumeralId,
      selectedRomanNumeralId: destinationRomanNumeralId,
      appliedType: null,
      roll: roll,
    );
  }

  static AppliedResolutionDecision resolveAppliedOrModulate({
    required Random random,
    required String currentKey,
    required RomanNumeralId appliedTargetRomanNumeralId,
    required List<RomanNumeralId> allowedDiatonicRomanNumerals,
    required List<String> modulationCandidateKeys,
  }) {
    final resolutionRoll = random.nextInt(100);
    if (resolutionRoll >= appliedResolutionChance) {
      final continuationSelection = selectNextRoman(
        random: random,
        currentRomanNumeralId: appliedTargetRomanNumeralId,
        allowedRomanNumerals: allowedDiatonicRomanNumerals,
      );
      final fallbackRoman =
          continuationSelection.selectedRomanNumeralId ??
          _fallbackDiatonicRoman(
            random: random,
            allowedDiatonicRomanNumerals: allowedDiatonicRomanNumerals,
          );
      return AppliedResolutionDecision(
        finalKey: currentKey,
        finalRomanNumeralId: fallbackRoman,
        appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
        modulationCandidateKeys: modulationCandidateKeys,
        resolvedToTarget: false,
      );
    }

    final modulationRoll = random.nextInt(100);
    if (modulationCandidateKeys.isNotEmpty &&
        modulationRoll < modulationChance) {
      final modulationKey =
          modulationCandidateKeys[random.nextInt(
            modulationCandidateKeys.length,
          )];
      return AppliedResolutionDecision(
        finalKey: modulationKey,
        finalRomanNumeralId: RomanNumeralId.iMaj7,
        appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
        modulationCandidateKeys: modulationCandidateKeys,
        resolvedToTarget: true,
        modulationKey: modulationKey,
      );
    }

    return AppliedResolutionDecision(
      finalKey: currentKey,
      finalRomanNumeralId: appliedTargetRomanNumeralId,
      appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
      modulationCandidateKeys: modulationCandidateKeys,
      resolvedToTarget: true,
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

  static List<QueuedSmartChord> maybeQueueLineCliche({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.plannedQueue.isNotEmpty || request.currentPatternTag != null) {
      return const [];
    }
    if (request.currentRomanNumeralId != RomanNumeralId.iMaj7) {
      return const [];
    }

    final tonicResting =
        request.currentHarmonicFunction == HarmonicFunction.tonic &&
        request.previousHarmonicFunction == HarmonicFunction.tonic &&
        request.previousRomanNumeralId == RomanNumeralId.iMaj7;
    final cadenceArrival =
        request.previousWasAppliedDominant ||
        request.previousHarmonicFunction == HarmonicFunction.dominant;

    if (!tonicResting && !cadenceArrival) {
      return const [];
    }
    if (random.nextInt(100) >= lineClicheTriggerChance) {
      return const [];
    }

    return const [
      QueuedSmartChord(
        finalRomanNumeralId: RomanNumeralId.iMaj7,
        plannedChordKind: PlannedChordKind.tonicDominant7,
        patternTag: 'major-tonic-cliche',
        suppressTensions: true,
      ),
      QueuedSmartChord(
        finalRomanNumeralId: RomanNumeralId.iMaj7,
        plannedChordKind: PlannedChordKind.tonicSix,
        patternTag: 'major-tonic-cliche',
        suppressTensions: true,
      ),
    ];
  }

  static QueuedSmartChordDecision dequeuePlannedSmartChord({
    required List<QueuedSmartChord> plannedQueue,
  }) {
    final queuedChord = plannedQueue.first;
    final remainingQueuedChords = plannedQueue.sublist(1);
    return QueuedSmartChordDecision(
      queuedChord: queuedChord,
      remainingQueuedChords: remainingQueuedChords,
    );
  }

  static SmartStepPlan planNextStep({
    required Random random,
    required SmartStepRequest request,
  }) {
    final seededQueue = request.plannedQueue.isNotEmpty
        ? request.plannedQueue
        : maybeQueueLineCliche(random: random, request: request);
    if (seededQueue.isNotEmpty) {
      final queuedDecision = dequeuePlannedSmartChord(
        plannedQueue: seededQueue,
      );
      final queuedRoman = queuedDecision.queuedChord.finalRomanNumeralId;
      final queuedSourceKind = MusicTheory.specFor(queuedRoman).sourceKind;
      return SmartStepPlan(
        finalKey: request.currentKey,
        finalRomanNumeralId: queuedRoman,
        appliedType: null,
        resolutionTargetRomanId: null,
        plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
        patternTag: queuedDecision.queuedChord.patternTag,
        remainingQueuedChords: queuedDecision.remainingQueuedChords,
        returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
        renderingPlan: SmartRenderingPlan(
          plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
          patternTag: queuedDecision.queuedChord.patternTag,
          suppressTensions: queuedDecision.queuedChord.suppressTensions,
        ),
        debug: SmartGenerationDebug(
          currentKey: request.currentKey,
          currentRomanNumeralId: request.currentRomanNumeralId,
          selectedDiatonicDestination: request.currentRomanNumeralId,
          finalKey: request.currentKey,
          finalRomanNumeralId: queuedRoman,
          decision: 'queued-line-cliche',
          activePatternTag: queuedDecision.queuedChord.patternTag,
          queuedPatternLength: queuedDecision.remainingQueuedChords.length,
          returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
          plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
          finalSourceKind: queuedSourceKind,
        ),
      );
    }

    if (_isAppliedDominant(request.currentRomanNumeralId)) {
      final appliedTargetRomanNumeralId =
          request.currentResolutionRomanNumeralId ??
          _fallbackDiatonicRoman(
            random: random,
            allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
          );
      final resolutionDecision = resolveAppliedOrModulate(
        random: random,
        currentKey: request.currentKey,
        appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
        allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
        modulationCandidateKeys: request.modulationCandidateKeys,
      );
      final appliedType = _appliedTypeForRoman(request.currentRomanNumeralId);
      return SmartStepPlan(
        finalKey: resolutionDecision.finalKey,
        finalRomanNumeralId: resolutionDecision.finalRomanNumeralId,
        appliedType: appliedType,
        resolutionTargetRomanId: appliedTargetRomanNumeralId,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        patternTag: null,
        remainingQueuedChords: const [],
        returnedToNormalFlow: false,
        renderingPlan: const SmartRenderingPlan(),
        debug: SmartGenerationDebug(
          currentKey: request.currentKey,
          currentRomanNumeralId: request.currentRomanNumeralId,
          selectedDiatonicDestination: appliedTargetRomanNumeralId,
          insertedAppliedApproach: request.currentRomanNumeralId,
          appliedType: appliedType,
          appliedTargetRomanNumeralId: appliedTargetRomanNumeralId,
          modulationCandidateKeys: resolutionDecision.modulationCandidateKeys,
          finalKey: resolutionDecision.finalKey,
          finalRomanNumeralId: resolutionDecision.finalRomanNumeralId,
          decision: resolutionDecision.didModulate
              ? 'modulated-via-applied-resolution'
              : resolutionDecision.resolvedToTarget
              ? 'resolved-applied-target'
              : 'continued-after-applied',
          plannedChordKind: PlannedChordKind.resolvedRoman,
          finalSourceKind: MusicTheory
              .specFor(resolutionDecision.finalRomanNumeralId)
              .sourceKind,
        ),
      );
    }

    if (_isModalInterchange(request.currentRomanNumeralId)) {
      final modalExitSelection = _selectModalExit(
        random: random,
        currentRomanNumeralId: request.currentRomanNumeralId,
      );
      final selectedModalExit =
          modalExitSelection.selectedRomanNumeralId ??
          _fallbackDiatonicRoman(
            random: random,
            allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
          );
      return SmartStepPlan(
        finalKey: request.currentKey,
        finalRomanNumeralId: selectedModalExit,
        appliedType: null,
        resolutionTargetRomanId: null,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        patternTag: null,
        remainingQueuedChords: const [],
        returnedToNormalFlow: false,
        renderingPlan: const SmartRenderingPlan(),
        debug: SmartGenerationDebug(
          currentKey: request.currentKey,
          currentRomanNumeralId: request.currentRomanNumeralId,
          selectedModalInterchange: request.currentRomanNumeralId,
          finalKey: request.currentKey,
          finalRomanNumeralId: selectedModalExit,
          decision: 'resolved-modal-interchange',
          transitionDebugSummary: modalExitSelection.debug.describe(),
          plannedChordKind: PlannedChordKind.resolvedRoman,
          finalSourceKind: MusicTheory.specFor(selectedModalExit).sourceKind,
        ),
      );
    }

    final destinationSelection = selectNextRoman(
      random: random,
      currentRomanNumeralId: request.currentRomanNumeralId,
      allowedRomanNumerals: request.allowedDiatonicRomanNumerals,
    );
    final selectedDestination =
        destinationSelection.selectedRomanNumeralId ??
        _fallbackDiatonicRoman(
          random: random,
          allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
        );

    final modalDecision = maybeSelectModalInterchange(
      random: random,
      request: request,
    );
    if (modalDecision != null) {
      final finalSourceKind = MusicTheory
          .specFor(modalDecision.selectedRomanNumeralId)
          .sourceKind;
      return SmartStepPlan(
        finalKey: request.currentKey,
        finalRomanNumeralId: modalDecision.selectedRomanNumeralId,
        appliedType: null,
        resolutionTargetRomanId: null,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        patternTag: modalDecision.patternTag,
        remainingQueuedChords: modalDecision.remainingQueuedChords,
        returnedToNormalFlow: false,
        renderingPlan: SmartRenderingPlan(
          plannedChordKind: PlannedChordKind.resolvedRoman,
          patternTag: modalDecision.patternTag,
        ),
        debug: SmartGenerationDebug(
          currentKey: request.currentKey,
          currentRomanNumeralId: request.currentRomanNumeralId,
          selectedDiatonicDestination: selectedDestination,
          selectedModalInterchange: modalDecision.selectedRomanNumeralId,
          finalKey: request.currentKey,
          finalRomanNumeralId: modalDecision.selectedRomanNumeralId,
          decision: modalDecision.decision,
          activePatternTag: modalDecision.patternTag,
          queuedPatternLength: modalDecision.remainingQueuedChords.length,
          transitionDebugSummary: destinationSelection.debug.describe(),
          plannedChordKind: PlannedChordKind.resolvedRoman,
          finalSourceKind: finalSourceKind,
        ),
      );
    }

    final approachDecision = maybeInsertAppliedApproach(
      random: random,
      destinationRomanNumeralId: selectedDestination,
      secondaryDominantEnabled: request.secondaryDominantEnabled,
      substituteDominantEnabled: request.substituteDominantEnabled,
    );

    return SmartStepPlan(
      finalKey: request.currentKey,
      finalRomanNumeralId: approachDecision.selectedRomanNumeralId,
      appliedType: approachDecision.appliedType,
      resolutionTargetRomanId: approachDecision.appliedTargetRomanNumeralId,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: null,
      remainingQueuedChords: const [],
      returnedToNormalFlow: false,
      renderingPlan: const SmartRenderingPlan(),
      debug: SmartGenerationDebug(
        currentKey: request.currentKey,
        currentRomanNumeralId: request.currentRomanNumeralId,
        selectedDiatonicDestination: selectedDestination,
        insertedAppliedApproach: approachDecision.insertedAppliedApproach,
        appliedType: approachDecision.appliedType,
        appliedTargetRomanNumeralId: approachDecision.appliedTargetRomanNumeralId,
        finalKey: request.currentKey,
        finalRomanNumeralId: approachDecision.selectedRomanNumeralId,
        decision: approachDecision.insertedApproach
            ? 'inserted-applied-approach'
            : 'selected-diatonic-destination',
        transitionDebugSummary: destinationSelection.debug.describe(),
        plannedChordKind: PlannedChordKind.resolvedRoman,
        finalSourceKind: MusicTheory
            .specFor(approachDecision.selectedRomanNumeralId)
            .sourceKind,
      ),
    );
  }

  static ModalInterchangeDecision? maybeSelectModalInterchange({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (!request.modalInterchangeEnabled) {
      return null;
    }
    final chance = _modalInsertionChance(request);
    if (chance <= 0 || random.nextInt(100) >= chance) {
      return null;
    }

    final pool = modalPoolByContext[request.currentHarmonicFunction] ??
        modalPoolByContext[HarmonicFunction.tonic]!;
    final selection = _selectWeightedCandidate(
      random: random,
      currentRomanNumeralId: request.currentRomanNumeralId,
      filteredCandidates: pool,
      emptyReason: 'No modal interchange candidates were configured.',
      nonPositiveReason:
          'Modal interchange candidates produced a non-positive total weight.',
    );
    final selectedRoman =
        selection.selectedRomanNumeralId ??
        RomanNumeralId.borrowedIvMin7;
    final queuedFollowers = _queuedFollowersForModalSelection(
      random: random,
      selectedRomanNumeralId: selectedRoman,
    );
    final patternTag = queuedFollowers.isEmpty
        ? null
        : queuedFollowers.first.patternTag;
    return ModalInterchangeDecision(
      selectedRomanNumeralId: selectedRoman,
      remainingQueuedChords: queuedFollowers,
      patternTag: patternTag,
      decision: queuedFollowers.isEmpty
          ? 'inserted-modal-interchange'
          : 'inserted-modal-pattern',
    );
  }

  static SmartTransitionSelection _selectModalExit({
    required Random random,
    required RomanNumeralId currentRomanNumeralId,
  }) {
    final candidates = modalExitTransitions[currentRomanNumeralId] ?? const [];
    return _selectWeightedCandidate(
      random: random,
      currentRomanNumeralId: currentRomanNumeralId,
      filteredCandidates: candidates,
      emptyReason: 'No modal interchange exit candidates were configured.',
      nonPositiveReason:
          'Modal interchange exit candidates produced a non-positive total weight.',
    );
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

  static int _modalInsertionChance(SmartStepRequest request) {
    if (request.currentRenderedNonDiatonic) {
      return modalChanceAfterNonDiatonic;
    }
    switch (request.currentHarmonicFunction) {
      case HarmonicFunction.tonic:
        return modalChanceTonic;
      case HarmonicFunction.predominant:
        return modalChancePredominant;
      case HarmonicFunction.dominant:
        return modalChanceDominant;
      case HarmonicFunction.free:
        return 0;
    }
  }

  static List<QueuedSmartChord> _queuedFollowersForModalSelection({
    required Random random,
    required RomanNumeralId selectedRomanNumeralId,
  }) {
    switch (selectedRomanNumeralId) {
      case RomanNumeralId.borrowedIvMin7:
        if (random.nextInt(100) < backdoorTriggerChance) {
          return const [
            QueuedSmartChord(
              finalRomanNumeralId: RomanNumeralId.borrowedFlatVII7,
              plannedChordKind: PlannedChordKind.resolvedRoman,
              patternTag: 'backdoor-cadence',
            ),
            QueuedSmartChord(
              finalRomanNumeralId: RomanNumeralId.iMaj7,
              plannedChordKind: PlannedChordKind.resolvedRoman,
              patternTag: 'backdoor-cadence',
            ),
          ];
        }
        return const [];
      case RomanNumeralId.borrowedIiHalfDiminished7:
        if (random.nextInt(100) < borrowedMinorTwoFiveTriggerChance) {
          return const [
            QueuedSmartChord(
              finalRomanNumeralId: RomanNumeralId.vDom7,
              plannedChordKind: PlannedChordKind.resolvedRoman,
              patternTag: 'borrowed-minor-ii-v-i',
            ),
            QueuedSmartChord(
              finalRomanNumeralId: RomanNumeralId.iMaj7,
              plannedChordKind: PlannedChordKind.resolvedRoman,
              patternTag: 'borrowed-minor-ii-v-i',
            ),
          ];
        }
        return const [];
      case RomanNumeralId.borrowedFlatIIMaj7:
        if (random.nextInt(100) < neapolitanDirectResolutionChance) {
          return const [
            QueuedSmartChord(
              finalRomanNumeralId: RomanNumeralId.iMaj7,
              plannedChordKind: PlannedChordKind.resolvedRoman,
              patternTag: 'neapolitan-color',
            ),
          ];
        }
        return const [
          QueuedSmartChord(
            finalRomanNumeralId: RomanNumeralId.vDom7,
            plannedChordKind: PlannedChordKind.resolvedRoman,
            patternTag: 'neapolitan-color',
          ),
          QueuedSmartChord(
            finalRomanNumeralId: RomanNumeralId.iMaj7,
            plannedChordKind: PlannedChordKind.resolvedRoman,
            patternTag: 'neapolitan-color',
          ),
        ];
      default:
        return const [];
    }
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

  static RomanNumeralId _fallbackDiatonicRoman({
    required Random random,
    required List<RomanNumeralId> allowedDiatonicRomanNumerals,
  }) {
    return allowedDiatonicRomanNumerals[random.nextInt(
      allowedDiatonicRomanNumerals.length,
    )];
  }
}
