import 'dart:math';

enum AppliedType { secondary, substitute }

enum PlannedChordKind { resolvedRoman, tonicDominant7, tonicSix }

enum SurfaceVariant { dominantSus4 }

class WeightedNextRoman {
  const WeightedNextRoman({required this.romanNumeral, required this.weight});

  final String romanNumeral;
  final int weight;
}

class QueuedSmartChord {
  const QueuedSmartChord({
    required this.finalRomanNumeral,
    required this.plannedChordKind,
    required this.patternTag,
    this.suppressTensions = false,
  });

  final String finalRomanNumeral;
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
    required this.currentRomanNumeral,
    required this.availableCandidates,
    required this.totalWeight,
    required this.roll,
    required this.selectedRomanNumeral,
    this.fallbackReason,
  });

  final String? currentRomanNumeral;
  final List<WeightedNextRoman> availableCandidates;
  final int totalWeight;
  final int? roll;
  final String? selectedRomanNumeral;
  final String? fallbackReason;

  bool get usedFallback => fallbackReason != null;

  SmartTransitionDebug withFallbackReason(String reason) {
    return SmartTransitionDebug(
      currentRomanNumeral: currentRomanNumeral,
      availableCandidates: availableCandidates,
      totalWeight: totalWeight,
      roll: roll,
      selectedRomanNumeral: selectedRomanNumeral,
      fallbackReason: reason,
    );
  }

  String describe() {
    final candidates = availableCandidates
        .map((candidate) => '${candidate.romanNumeral}(${candidate.weight})')
        .join(', ');
    return 'currentRoman=${currentRomanNumeral ?? '-'} '
        'candidates=[$candidates] '
        'totalWeight=$totalWeight '
        'roll=${roll ?? '-'} '
        'selected=${selectedRomanNumeral ?? '-'} '
        'fallback=${fallbackReason ?? '-'}';
  }
}

class SmartTransitionSelection {
  const SmartTransitionSelection({
    required this.selectedRomanNumeral,
    required this.debug,
  });

  final String? selectedRomanNumeral;
  final SmartTransitionDebug debug;

  bool get hasSelection => selectedRomanNumeral != null;
}

class SmartApproachDecision {
  const SmartApproachDecision({
    required this.destinationRomanNumeral,
    required this.selectedRomanNumeral,
    required this.appliedType,
    this.appliedTargetRomanNumeral,
    this.roll,
  });

  final String destinationRomanNumeral;
  final String selectedRomanNumeral;
  final AppliedType? appliedType;
  final String? appliedTargetRomanNumeral;
  final int? roll;

  String? get insertedAppliedApproach =>
      appliedType == null ? null : selectedRomanNumeral;

  bool get insertedApproach => appliedType != null;
}

class AppliedResolutionDecision {
  const AppliedResolutionDecision({
    required this.finalKey,
    required this.finalRomanNumeral,
    required this.appliedTargetRomanNumeral,
    required this.modulationCandidateKeys,
    required this.resolvedToTarget,
    this.modulationKey,
  });

  final String finalKey;
  final String finalRomanNumeral;
  final String appliedTargetRomanNumeral;
  final List<String> modulationCandidateKeys;
  final bool resolvedToTarget;
  final String? modulationKey;

  bool get didModulate => modulationKey != null;
}

class SmartGenerationDebug {
  const SmartGenerationDebug({
    required this.currentKey,
    required this.currentRomanNumeral,
    this.selectedDiatonicDestination,
    this.insertedAppliedApproach,
    this.appliedType,
    this.appliedTargetRomanNumeral,
    this.modulationCandidateKeys = const [],
    this.finalKey,
    this.finalRomanNumeral,
    this.finalChord,
    this.decision,
    this.transitionDebugSummary,
    this.wasExcludedFallback = false,
    this.renderedIsNonDiatonic = false,
    this.activePatternTag,
    this.lineClicheQueueLength = 0,
    this.returnedToNormalFlow = false,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
  });

  final String currentKey;
  final String currentRomanNumeral;
  final String? selectedDiatonicDestination;
  final String? insertedAppliedApproach;
  final AppliedType? appliedType;
  final String? appliedTargetRomanNumeral;
  final List<String> modulationCandidateKeys;
  final String? finalKey;
  final String? finalRomanNumeral;
  final String? finalChord;
  final String? decision;
  final String? transitionDebugSummary;
  final bool wasExcludedFallback;
  final bool renderedIsNonDiatonic;
  final String? activePatternTag;
  final int lineClicheQueueLength;
  final bool returnedToNormalFlow;
  final PlannedChordKind plannedChordKind;

  SmartGenerationDebug withDecision(String nextDecision) {
    return SmartGenerationDebug(
      currentKey: currentKey,
      currentRomanNumeral: currentRomanNumeral,
      selectedDiatonicDestination: selectedDiatonicDestination,
      insertedAppliedApproach: insertedAppliedApproach,
      appliedType: appliedType,
      appliedTargetRomanNumeral: appliedTargetRomanNumeral,
      modulationCandidateKeys: modulationCandidateKeys,
      finalKey: finalKey,
      finalRomanNumeral: finalRomanNumeral,
      finalChord: finalChord,
      decision: nextDecision,
      transitionDebugSummary: transitionDebugSummary,
      wasExcludedFallback: wasExcludedFallback,
      renderedIsNonDiatonic: renderedIsNonDiatonic,
      activePatternTag: activePatternTag,
      lineClicheQueueLength: lineClicheQueueLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
    );
  }

  SmartGenerationDebug withFinalSelection({
    required String finalKey,
    required String finalRomanNumeral,
    required String finalChord,
    required bool renderedIsNonDiatonic,
    required bool wasExcludedFallback,
  }) {
    return SmartGenerationDebug(
      currentKey: currentKey,
      currentRomanNumeral: currentRomanNumeral,
      selectedDiatonicDestination: selectedDiatonicDestination,
      insertedAppliedApproach: insertedAppliedApproach,
      appliedType: appliedType,
      appliedTargetRomanNumeral: appliedTargetRomanNumeral,
      modulationCandidateKeys: modulationCandidateKeys,
      finalKey: finalKey,
      finalRomanNumeral: finalRomanNumeral,
      finalChord: finalChord,
      decision: decision,
      transitionDebugSummary: transitionDebugSummary,
      wasExcludedFallback: wasExcludedFallback,
      renderedIsNonDiatonic: renderedIsNonDiatonic,
      activePatternTag: activePatternTag,
      lineClicheQueueLength: lineClicheQueueLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
    );
  }

  String describe() {
    final modulationKeys = modulationCandidateKeys.isEmpty
        ? '-'
        : modulationCandidateKeys.join(', ');
    return 'currentKey=$currentKey '
        'currentRoman=$currentRomanNumeral '
        'destination=${selectedDiatonicDestination ?? '-'} '
        'appliedApproach=${insertedAppliedApproach ?? '-'} '
        'appliedType=${appliedType?.name ?? '-'} '
        'appliedTarget=${appliedTargetRomanNumeral ?? '-'} '
        'pattern=${activePatternTag ?? '-'} '
        'plannedKind=${plannedChordKind.name} '
        'queueLength=$lineClicheQueueLength '
        'returnedToNormalFlow=$returnedToNormalFlow '
        'excludedFallback=$wasExcludedFallback '
        'renderedNonDiatonic=$renderedIsNonDiatonic '
        'modulationCandidates=[$modulationKeys] '
        'finalKey=${finalKey ?? '-'} '
        'finalRoman=${finalRomanNumeral ?? '-'} '
        'finalChord=${finalChord ?? '-'} '
        'decision=${decision ?? '-'} '
        'transition=${transitionDebugSummary ?? '-'}';
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
    required this.currentRomanNumeral,
    required this.currentResolutionRomanNumeral,
    required this.currentHarmonicFunction,
    required this.allowedDiatonicRomanNumerals,
    required this.secondaryDominantEnabled,
    required this.substituteDominantEnabled,
    required this.modulationCandidateKeys,
    required this.previousRomanNumeral,
    required this.previousHarmonicFunction,
    required this.previousWasAppliedDominant,
    required this.currentPatternTag,
    required this.plannedQueue,
  });

  final String currentKey;
  final String currentRomanNumeral;
  final String? currentResolutionRomanNumeral;
  final String currentHarmonicFunction;
  final List<String> allowedDiatonicRomanNumerals;
  final bool secondaryDominantEnabled;
  final bool substituteDominantEnabled;
  final List<String> modulationCandidateKeys;
  final String? previousRomanNumeral;
  final String? previousHarmonicFunction;
  final bool previousWasAppliedDominant;
  final String? currentPatternTag;
  final List<QueuedSmartChord> plannedQueue;
}

class SmartStepPlan {
  const SmartStepPlan({
    required this.finalKey,
    required this.finalRomanNumeral,
    required this.appliedType,
    required this.resolutionTargetRoman,
    required this.plannedChordKind,
    required this.patternTag,
    required this.remainingQueuedChords,
    required this.returnedToNormalFlow,
    required this.renderingPlan,
    required this.debug,
  });

  final String finalKey;
  final String finalRomanNumeral;
  final AppliedType? appliedType;
  final String? resolutionTargetRoman;
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

  static const Map<String, String> secondaryDominantByResolution = {
    'IIm7': 'V7/II',
    'IIIm7': 'V7/III',
    'IVM7': 'V7/IV',
    'V7': 'V7/V',
    'VIm7': 'V7/VI',
  };

  static const Map<String, String> substituteDominantByResolution = {
    'IIm7': 'subV7/II',
    'IIIm7': 'subV7/III',
    'IVM7': 'subV7/IV',
    'V7': 'subV7/V',
    'VIm7': 'subV7/VI',
  };

  static const Map<String, List<WeightedNextRoman>> majorDiatonicTransitions = {
    'IM7': [
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 40),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 35),
      WeightedNextRoman(romanNumeral: 'IIIm7', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 10),
      WeightedNextRoman(romanNumeral: 'V7', weight: 5),
    ],
    'IIm7': [
      WeightedNextRoman(romanNumeral: 'V7', weight: 85),
      WeightedNextRoman(romanNumeral: 'VIIm7b5', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 5),
    ],
    'IIIm7': [
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 80),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 10),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 10),
    ],
    'IVM7': [
      WeightedNextRoman(romanNumeral: 'V7', weight: 70),
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 20),
      WeightedNextRoman(romanNumeral: 'VIIm7b5', weight: 10),
    ],
    'V7': [
      WeightedNextRoman(romanNumeral: 'IM7', weight: 75),
      WeightedNextRoman(romanNumeral: 'VIm7', weight: 20),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 5),
    ],
    'VIm7': [
      WeightedNextRoman(romanNumeral: 'IIm7', weight: 75),
      WeightedNextRoman(romanNumeral: 'IVM7', weight: 15),
      WeightedNextRoman(romanNumeral: 'V7', weight: 10),
    ],
    'VIIm7b5': [
      WeightedNextRoman(romanNumeral: 'IM7', weight: 70),
      WeightedNextRoman(romanNumeral: 'V7', weight: 20),
      WeightedNextRoman(romanNumeral: 'IIIm7', weight: 10),
    ],
  };

  static SmartTransitionSelection selectNextRoman({
    required Random random,
    required String? currentRomanNumeral,
    required Iterable<String> allowedRomanNumerals,
  }) {
    final allowedSet = allowedRomanNumerals.toSet();
    final configuredCandidates = majorDiatonicTransitions[currentRomanNumeral];

    if (currentRomanNumeral == null || configuredCandidates == null) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'No weighted transition is configured for the current Roman numeral.',
        ),
      );
    }

    final filteredCandidates = [
      for (final candidate in configuredCandidates)
        if (allowedSet.contains(candidate.romanNumeral)) candidate,
    ];

    if (filteredCandidates.isEmpty) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: const [],
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'All weighted transition candidates were filtered out by the current settings.',
        ),
      );
    }

    final totalWeight = filteredCandidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    if (totalWeight <= 0) {
      return SmartTransitionSelection(
        selectedRomanNumeral: null,
        debug: SmartTransitionDebug(
          currentRomanNumeral: currentRomanNumeral,
          availableCandidates: filteredCandidates,
          totalWeight: 0,
          roll: null,
          selectedRomanNumeral: null,
          fallbackReason:
              'Weighted transition candidates produced a non-positive total weight.',
        ),
      );
    }

    final roll = random.nextInt(totalWeight);
    var remaining = roll;
    for (final candidate in filteredCandidates) {
      if (remaining < candidate.weight) {
        return SmartTransitionSelection(
          selectedRomanNumeral: candidate.romanNumeral,
          debug: SmartTransitionDebug(
            currentRomanNumeral: currentRomanNumeral,
            availableCandidates: filteredCandidates,
            totalWeight: totalWeight,
            roll: roll,
            selectedRomanNumeral: candidate.romanNumeral,
          ),
        );
      }
      remaining -= candidate.weight;
    }

    final fallbackCandidate = filteredCandidates.last;
    return SmartTransitionSelection(
      selectedRomanNumeral: fallbackCandidate.romanNumeral,
      debug: SmartTransitionDebug(
        currentRomanNumeral: currentRomanNumeral,
        availableCandidates: filteredCandidates,
        totalWeight: totalWeight,
        roll: roll,
        selectedRomanNumeral: fallbackCandidate.romanNumeral,
      ),
    );
  }

  static SmartApproachDecision maybeInsertAppliedApproach({
    required Random random,
    required String destinationRomanNumeral,
    required bool secondaryDominantEnabled,
    required bool substituteDominantEnabled,
  }) {
    final secondaryDominant =
        secondaryDominantByResolution[destinationRomanNumeral];
    final substituteDominant =
        substituteDominantByResolution[destinationRomanNumeral];

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
          : (nonDiatonicVisibilityBoost *
                secondaryWeight ~/
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
        romanNumeral: destinationRomanNumeral,
        weight: diatonicWeight,
      ),
    ];
    if (secondaryWeight > 0 && secondaryDominant != null) {
      candidates.add(
        WeightedNextRoman(
          romanNumeral: secondaryDominant,
          weight: secondaryWeight,
        ),
      );
    }
    if (substituteWeight > 0 && substituteDominant != null) {
      candidates.add(
        WeightedNextRoman(
          romanNumeral: substituteDominant,
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
        final appliedType = candidate.romanNumeral == destinationRomanNumeral
            ? null
            : _appliedTypeForRoman(candidate.romanNumeral);
        return SmartApproachDecision(
          destinationRomanNumeral: destinationRomanNumeral,
          selectedRomanNumeral: candidate.romanNumeral,
          appliedType: appliedType,
          appliedTargetRomanNumeral: appliedType == null
              ? null
              : destinationRomanNumeral,
          roll: roll,
        );
      }
      remaining -= candidate.weight;
    }

    return SmartApproachDecision(
      destinationRomanNumeral: destinationRomanNumeral,
      selectedRomanNumeral: destinationRomanNumeral,
      appliedType: null,
      roll: roll,
    );
  }

  static AppliedResolutionDecision resolveAppliedOrModulate({
    required Random random,
    required String currentKey,
    required String appliedTargetRomanNumeral,
    required List<String> allowedDiatonicRomanNumerals,
    required List<String> modulationCandidateKeys,
  }) {
    final resolutionRoll = random.nextInt(100);
    if (resolutionRoll >= appliedResolutionChance) {
      final continuationSelection = selectNextRoman(
        random: random,
        currentRomanNumeral: appliedTargetRomanNumeral,
        allowedRomanNumerals: allowedDiatonicRomanNumerals,
      );
      final fallbackRoman =
          continuationSelection.selectedRomanNumeral ??
          _fallbackDiatonicRoman(
            random: random,
            allowedDiatonicRomanNumerals: allowedDiatonicRomanNumerals,
          );
      return AppliedResolutionDecision(
        finalKey: currentKey,
        finalRomanNumeral: fallbackRoman,
        appliedTargetRomanNumeral: appliedTargetRomanNumeral,
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
        finalRomanNumeral: 'IM7',
        appliedTargetRomanNumeral: appliedTargetRomanNumeral,
        modulationCandidateKeys: modulationCandidateKeys,
        resolvedToTarget: true,
        modulationKey: modulationKey,
      );
    }

    return AppliedResolutionDecision(
      finalKey: currentKey,
      finalRomanNumeral: appliedTargetRomanNumeral,
      appliedTargetRomanNumeral: appliedTargetRomanNumeral,
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
    if (request.currentRomanNumeral != 'IM7') {
      return const [];
    }

    final tonicResting =
        request.currentHarmonicFunction == 'tonic' &&
        request.previousHarmonicFunction == 'tonic' &&
        request.previousRomanNumeral == 'IM7';
    final cadenceArrival =
        request.previousWasAppliedDominant ||
        request.previousHarmonicFunction == 'dominant';

    if (!tonicResting && !cadenceArrival) {
      return const [];
    }

    if (random.nextInt(100) >= lineClicheTriggerChance) {
      return const [];
    }

    return const [
      QueuedSmartChord(
        finalRomanNumeral: 'IM7',
        plannedChordKind: PlannedChordKind.tonicDominant7,
        patternTag: 'major-tonic-cliche',
        suppressTensions: true,
      ),
      QueuedSmartChord(
        finalRomanNumeral: 'IM7',
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
      return SmartStepPlan(
        finalKey: request.currentKey,
        finalRomanNumeral: queuedDecision.queuedChord.finalRomanNumeral,
        appliedType: null,
        resolutionTargetRoman: null,
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
          currentRomanNumeral: request.currentRomanNumeral,
          selectedDiatonicDestination: request.currentRomanNumeral,
          finalKey: request.currentKey,
          finalRomanNumeral: queuedDecision.queuedChord.finalRomanNumeral,
          decision: 'queued-line-cliche',
          activePatternTag: queuedDecision.queuedChord.patternTag,
          lineClicheQueueLength: queuedDecision.remainingQueuedChords.length,
          returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
          plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
        ),
      );
    }

    if (_isAppliedDominant(request.currentRomanNumeral)) {
      final appliedTargetRomanNumeral =
          request.currentResolutionRomanNumeral ??
          _fallbackDiatonicRoman(
            random: random,
            allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
          );
      final resolutionDecision = resolveAppliedOrModulate(
        random: random,
        currentKey: request.currentKey,
        appliedTargetRomanNumeral: appliedTargetRomanNumeral,
        allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
        modulationCandidateKeys: request.modulationCandidateKeys,
      );
      final appliedType = _appliedTypeForRoman(request.currentRomanNumeral);
      return SmartStepPlan(
        finalKey: resolutionDecision.finalKey,
        finalRomanNumeral: resolutionDecision.finalRomanNumeral,
        appliedType: appliedType,
        resolutionTargetRoman: appliedTargetRomanNumeral,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        patternTag: null,
        remainingQueuedChords: const [],
        returnedToNormalFlow: false,
        renderingPlan: const SmartRenderingPlan(),
        debug: SmartGenerationDebug(
          currentKey: request.currentKey,
          currentRomanNumeral: request.currentRomanNumeral,
          selectedDiatonicDestination: appliedTargetRomanNumeral,
          insertedAppliedApproach: request.currentRomanNumeral,
          appliedType: appliedType,
          appliedTargetRomanNumeral: appliedTargetRomanNumeral,
          modulationCandidateKeys: resolutionDecision.modulationCandidateKeys,
          finalKey: resolutionDecision.finalKey,
          finalRomanNumeral: resolutionDecision.finalRomanNumeral,
          decision: resolutionDecision.didModulate
              ? 'modulated-via-applied-resolution'
              : resolutionDecision.resolvedToTarget
              ? 'resolved-applied-target'
              : 'continued-after-applied',
          plannedChordKind: PlannedChordKind.resolvedRoman,
        ),
      );
    }

    final destinationSelection = selectNextRoman(
      random: random,
      currentRomanNumeral: request.currentRomanNumeral,
      allowedRomanNumerals: request.allowedDiatonicRomanNumerals,
    );
    final selectedDestination =
        destinationSelection.selectedRomanNumeral ??
        _fallbackDiatonicRoman(
          random: random,
          allowedDiatonicRomanNumerals: request.allowedDiatonicRomanNumerals,
        );
    final approachDecision = maybeInsertAppliedApproach(
      random: random,
      destinationRomanNumeral: selectedDestination,
      secondaryDominantEnabled: request.secondaryDominantEnabled,
      substituteDominantEnabled: request.substituteDominantEnabled,
    );

    return SmartStepPlan(
      finalKey: request.currentKey,
      finalRomanNumeral: approachDecision.selectedRomanNumeral,
      appliedType: approachDecision.appliedType,
      resolutionTargetRoman: approachDecision.appliedTargetRomanNumeral,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      patternTag: null,
      remainingQueuedChords: const [],
      returnedToNormalFlow: false,
      renderingPlan: const SmartRenderingPlan(),
      debug: SmartGenerationDebug(
        currentKey: request.currentKey,
        currentRomanNumeral: request.currentRomanNumeral,
        selectedDiatonicDestination: selectedDestination,
        insertedAppliedApproach: approachDecision.insertedAppliedApproach,
        appliedType: approachDecision.appliedType,
        appliedTargetRomanNumeral: approachDecision.appliedTargetRomanNumeral,
        modulationCandidateKeys: const [],
        finalKey: request.currentKey,
        finalRomanNumeral: approachDecision.selectedRomanNumeral,
        decision: approachDecision.insertedApproach
            ? 'inserted-applied-approach'
            : 'selected-diatonic-destination',
        transitionDebugSummary: destinationSelection.debug.describe(),
        plannedChordKind: PlannedChordKind.resolvedRoman,
      ),
    );
  }

  static bool _isAppliedDominant(String romanNumeral) {
    return romanNumeral.startsWith('V7/') || romanNumeral.startsWith('subV7/');
  }

  static AppliedType? _appliedTypeForRoman(String romanNumeral) {
    if (romanNumeral.startsWith('subV7/')) {
      return AppliedType.substitute;
    }
    if (romanNumeral.startsWith('V7/')) {
      return AppliedType.secondary;
    }
    return null;
  }

  static String _fallbackDiatonicRoman({
    required Random random,
    required List<String> allowedDiatonicRomanNumerals,
  }) {
    return allowedDiatonicRomanNumerals[random.nextInt(
      allowedDiatonicRomanNumerals.length,
    )];
  }
}
