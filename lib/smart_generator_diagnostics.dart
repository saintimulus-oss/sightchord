part of 'smart_generator.dart';

class SmartDecisionTrace implements SmartDebugInfo {
  const SmartDecisionTrace({
    required this.stepIndex,
    required this.currentKeyCenter,
    required this.currentRomanNumeralId,
    required this.currentHarmonicFunction,
    required this.phraseContext,
    this.homeCenterLabel,
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
    this.modulationConfidence = 0,
    this.finalKeyCenter,
    this.finalKeyMode,
    this.finalKeyRelation,
    this.finalRomanNumeralId,
    this.finalChord,
    this.finalRoot,
    this.finalRenderQuality,
    this.finalTensions = const [],
    this.decision,
    this.transitionDebugSummary,
    this.activePatternTag,
    this.selectedVariant,
    this.queuedPatternLength = 0,
    this.returnedToNormalFlow = false,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.finalSourceKind = ChordSourceKind.diatonic,
    this.dominantContext,
    this.dominantIntent,
    this.modulationKind = ModulationKind.none,
    this.cadentialArrival = false,
    this.activeLocalScope,
    this.outstandingDebts = const [],
    this.surfaceTags = const [],
    this.postModulationConfirmationsRemaining = 0,
    this.voiceLeadingScore,
    this.voiceLeadingSummary,
    this.voiceLeadingAlternatives = const [],
  });

  final int stepIndex;
  final String currentKeyCenter;
  final RomanNumeralId currentRomanNumeralId;
  final HarmonicFunction currentHarmonicFunction;
  final SmartPhraseContext phraseContext;
  final String? homeCenterLabel;
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
  final double modulationConfidence;
  final String? finalKeyCenter;
  final KeyMode? finalKeyMode;
  final KeyRelation? finalKeyRelation;
  final RomanNumeralId? finalRomanNumeralId;
  final String? finalChord;
  final String? finalRoot;
  final ChordQuality? finalRenderQuality;
  final List<String> finalTensions;
  final String? decision;
  final String? transitionDebugSummary;
  final String? activePatternTag;
  final String? selectedVariant;
  final int queuedPatternLength;
  final bool returnedToNormalFlow;
  final PlannedChordKind plannedChordKind;
  final ChordSourceKind finalSourceKind;
  final DominantContext? dominantContext;
  final DominantIntent? dominantIntent;
  final ModulationKind modulationKind;
  final bool cadentialArrival;
  final LocalScope? activeLocalScope;
  final List<ResolutionDebt> outstandingDebts;
  final List<String> surfaceTags;
  final int postModulationConfirmationsRemaining;
  final double? voiceLeadingScore;
  final String? voiceLeadingSummary;
  final List<String> voiceLeadingAlternatives;

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
      phraseContext: phraseContext,
      homeCenterLabel: homeCenterLabel,
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
      modulationConfidence: modulationConfidence,
      finalKeyCenter: finalKeyCenter,
      finalKeyMode: finalKeyMode,
      finalKeyRelation: finalKeyRelation,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      finalRoot: finalRoot,
      finalRenderQuality: finalRenderQuality,
      finalTensions: finalTensions,
      decision: nextDecision,
      transitionDebugSummary: transitionDebugSummary,
      activePatternTag: activePatternTag,
      selectedVariant: selectedVariant,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
      activeLocalScope: activeLocalScope,
      outstandingDebts: outstandingDebts,
      surfaceTags: surfaceTags,
      postModulationConfirmationsRemaining:
          postModulationConfirmationsRemaining,
      voiceLeadingScore: voiceLeadingScore,
      voiceLeadingSummary: voiceLeadingSummary,
      voiceLeadingAlternatives: voiceLeadingAlternatives,
    );
  }

  SmartDecisionTrace withVoiceLeading({
    required SmartVoiceLeadingBreakdown breakdown,
    required List<String> alternatives,
  }) {
    return SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      phraseContext: phraseContext,
      homeCenterLabel: homeCenterLabel,
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
      modulationConfidence: modulationConfidence,
      finalKeyCenter: finalKeyCenter,
      finalKeyMode: finalKeyMode,
      finalKeyRelation: finalKeyRelation,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      finalRoot: finalRoot,
      finalRenderQuality: finalRenderQuality,
      finalTensions: finalTensions,
      decision: decision,
      transitionDebugSummary: transitionDebugSummary,
      activePatternTag: activePatternTag,
      selectedVariant: selectedVariant,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
      activeLocalScope: activeLocalScope,
      outstandingDebts: outstandingDebts,
      surfaceTags: surfaceTags,
      postModulationConfirmationsRemaining:
          postModulationConfirmationsRemaining,
      voiceLeadingScore: breakdown.total,
      voiceLeadingSummary: breakdown.describe(),
      voiceLeadingAlternatives: alternatives,
    );
  }

  SmartDecisionTrace withFinalSelection({
    required KeyCenter finalKeyCenter,
    required RomanNumeralId finalRomanNumeralId,
    required String finalChord,
    required bool fallbackOccurred,
    required String finalRoot,
    required ChordQuality finalRenderQuality,
    required List<String> finalTensions,
  }) {
    return SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      phraseContext: phraseContext,
      homeCenterLabel: homeCenterLabel,
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
      modulationConfidence: modulationConfidence,
      finalKeyCenter: finalKeyCenter.displayName,
      finalKeyMode: finalKeyCenter.mode,
      finalKeyRelation: finalKeyCenter.relationToParent,
      finalRomanNumeralId: finalRomanNumeralId,
      finalChord: finalChord,
      finalRoot: finalRoot,
      finalRenderQuality: finalRenderQuality,
      finalTensions: finalTensions,
      decision: decision,
      transitionDebugSummary: transitionDebugSummary,
      activePatternTag: activePatternTag,
      selectedVariant: selectedVariant,
      queuedPatternLength: queuedPatternLength,
      returnedToNormalFlow: returnedToNormalFlow,
      plannedChordKind: plannedChordKind,
      finalSourceKind: finalSourceKind,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
      activeLocalScope: activeLocalScope,
      outstandingDebts: outstandingDebts,
      surfaceTags: surfaceTags,
      postModulationConfirmationsRemaining:
          postModulationConfirmationsRemaining,
      voiceLeadingScore: voiceLeadingScore,
      voiceLeadingSummary: voiceLeadingSummary,
      voiceLeadingAlternatives: voiceLeadingAlternatives,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'stepIndex': stepIndex,
      'currentKeyCenter': currentKeyCenter,
      'homeCenter': homeCenterLabel,
      'currentRoman': MusicTheory.romanTokenOf(currentRomanNumeralId),
      'currentFunction': currentHarmonicFunction.name,
      'phraseRole': phraseContext.phraseRole.name,
      'sectionRole': phraseContext.sectionRole.name,
      'harmonicDensity': phraseContext.harmonicDensity.name,
      'barInPhrase': phraseContext.barInPhrase,
      'barsToBoundary': phraseContext.barsToBoundary,
      'phraseLength': phraseContext.phraseLength,
      'selectedDestination': _token(selectedDiatonicDestination),
      'selectedModalInterchange': _token(selectedModalInterchange),
      'selectedAppliedApproach': _token(selectedAppliedApproach),
      'appliedType': appliedType?.name,
      'appliedTarget': _token(appliedTargetRomanNumeralId),
      'selectedVariant': selectedVariant,
      'activePatternTag': activePatternTag,
      'queuedPatternLength': queuedPatternLength,
      'returnedToNormalFlow': returnedToNormalFlow,
      'modulationCandidates': modulationCandidateKeys,
      'blockedReason': blockedReason?.name,
      'fallbackOccurred': fallbackOccurred,
      'modulationAttempted': modulationAttempted,
      'modulationSucceeded': modulationSucceeded,
      'modulationConfidence': modulationConfidence,
      'modulationKind': modulationKind.name,
      'cadentialArrival': cadentialArrival,
      'dominantContext': dominantContext?.name,
      'dominantIntent': dominantIntent?.name,
      'activeLocalScope': activeLocalScope?.describe(),
      'outstandingDebts': [
        for (final debt in outstandingDebts) debt.describe(),
      ],
      'surfaceTags': surfaceTags,
      'finalKeyCenter': finalKeyCenter,
      'finalKeyMode': finalKeyMode?.name,
      'finalKeyRelation': finalKeyRelation?.name,
      'finalRoman': _token(finalRomanNumeralId),
      'finalChord': finalChord,
      'finalRoot': finalRoot,
      'finalRenderQuality': finalRenderQuality?.name,
      'finalTensions': finalTensions,
      'decision': decision,
      'transition': transitionDebugSummary,
      'postModulationConfirmationsRemaining':
          postModulationConfirmationsRemaining,
      'voiceLeadingScore': voiceLeadingScore,
      'voiceLeadingSummary': voiceLeadingSummary,
      'voiceLeadingAlternatives': voiceLeadingAlternatives,
    };
  }

  @override
  String describe() {
    final modulationKeys = modulationCandidateKeys.isEmpty
        ? '-'
        : modulationCandidateKeys.join(', ');
    final debts = outstandingDebts.isEmpty
        ? '-'
        : outstandingDebts.map((debt) => debt.describe()).join(',');
    return 'step=$stepIndex '
        'currentKeyCenter=$currentKeyCenter '
        'homeCenter=${homeCenterLabel ?? '-'} '
        'currentRoman=${MusicTheory.romanTokenOf(currentRomanNumeralId)} '
        'currentFunction=${currentHarmonicFunction.name} '
        'phrase=${phraseContext.describe()} '
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
        'modulationConfidence=${modulationConfidence.toStringAsFixed(2)} '
        'modulationKind=${modulationKind.name} '
        'dominantContext=${dominantContext?.name ?? '-'} '
        'dominantIntent=${dominantIntent?.name ?? '-'} '
        'cadentialArrival=$cadentialArrival '
        'pattern=${activePatternTag ?? '-'} '
        'variant=${selectedVariant ?? '-'} '
        'queueLength=$queuedPatternLength '
        'returnedToNormalFlow=$returnedToNormalFlow '
        'scope=${activeLocalScope?.describe() ?? '-'} '
        'debts=$debts '
        'voiceLeading=${voiceLeadingSummary ?? '-'} '
        'finalKeyCenter=${finalKeyCenter ?? '-'} '
        'finalKeyRelation=${finalKeyRelation?.name ?? '-'} '
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

  static T runIsolated<T>(T Function() body) {
    final snapshot = List<SmartDecisionTrace>.from(_recentTraces);
    _recentTraces.clear();
    try {
      return body();
    } finally {
      _recentTraces
        ..clear()
        ..addAll(
          snapshot.length <= _maxTraceCount
              ? snapshot
              : snapshot.sublist(snapshot.length - _maxTraceCount),
        );
    }
  }

  static String dumpJson({bool pretty = false}) {
    final payload = [for (final trace in _recentTraces) trace.toJson()];
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(payload)
        : jsonEncode(payload);
  }

  static void clear() {
    _recentTraces.clear();
  }
}

enum SmartQaStatus { pass, warn, fail }

class SmartQaCheck {
  const SmartQaCheck({
    required this.id,
    required this.status,
    required this.detail,
  });

  final String id;
  final SmartQaStatus status;
  final String detail;

  Map<String, Object?> toJson() {
    return {'id': id, 'status': status.name, 'detail': detail};
  }

  String describe() => '$id:${status.name}:$detail';
}

class SmartSimulationComparison {
  const SmartSimulationComparison({
    required this.baselinePreset,
    required this.candidatePreset,
    required this.qaChecks,
  });

  final JazzPreset baselinePreset;
  final JazzPreset candidatePreset;
  final List<SmartQaCheck> qaChecks;

  Map<String, Object?> toJson() {
    return {
      'baselinePreset': baselinePreset.name,
      'candidatePreset': candidatePreset.name,
      'qaChecks': [for (final check in qaChecks) check.toJson()],
    };
  }

  String toJsonString({bool pretty = false}) {
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(toJson())
        : jsonEncode(toJson());
  }

  String toCsv() {
    final buffer = StringBuffer()..writeln('check,status,detail');
    for (final check in qaChecks) {
      buffer.writeln('${check.id},${check.status.name},"${check.detail}"');
    }
    return buffer.toString();
  }
}

class SmartSimulationSummary {
  const SmartSimulationSummary({
    required this.jazzPreset,
    required this.sourceProfile,
    required this.modulationIntensity,
    required this.steps,
    required this.modulationAttemptCount,
    required this.modulationSuccessCount,
    required this.blockedReasonHistogram,
    required this.modalBranchCount,
    required this.appliedDominantInsertionCount,
    required this.fallbackCount,
    required this.familyHistogram,
    required this.familyLengthHistogram,
    required this.cadenceHistogram,
    required this.tonicizationCount,
    required this.realModulationCount,
    required this.modulationRelationHistogram,
    required this.phraseRoleModulationHistogram,
    required this.relatedIiAppliedCount,
    required this.nakedAppliedCount,
    required this.dominantIntentHistogram,
    required this.susReleaseCount,
    required this.susResolutionOpportunities,
    required this.bridgeIvSectionHistogram,
    required this.bridgeIvStabilizationSuccessCount,
    required this.bridgeIvFallbackCount,
    required this.bridgeReturnSectionHistogram,
    required this.chromaticMediantStartCount,
    required this.chromaticMediantDensity,
    required this.chromaticMediantPayoffCount,
    required this.chromaticMediantFailedPayoffCount,
    required this.returnHomeDebtOpenCount,
    required this.returnHomeDebtPayoffCount,
    required this.returnHomeOpportunityCount,
    required this.returnHomeSelectionCount,
    required this.minorCenterOccupancy,
    required this.directAppliedToNewTonicViolations,
    required this.rareColorUsage,
    required this.rareColorPayoffCount,
    required this.qaChecks,
    required this.traces,
  });

  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final ModulationIntensity modulationIntensity;
  final int steps;
  final int modulationAttemptCount;
  final int modulationSuccessCount;
  final Map<SmartBlockedReason, int> blockedReasonHistogram;
  final int modalBranchCount;
  final int appliedDominantInsertionCount;
  final int fallbackCount;
  final Map<String, int> familyHistogram;
  final Map<int, int> familyLengthHistogram;
  final Map<String, int> cadenceHistogram;
  final int tonicizationCount;
  final int realModulationCount;
  final Map<String, int> modulationRelationHistogram;
  final Map<String, int> phraseRoleModulationHistogram;
  final int relatedIiAppliedCount;
  final int nakedAppliedCount;
  final Map<String, int> dominantIntentHistogram;
  final int susReleaseCount;
  final int susResolutionOpportunities;
  final Map<String, int> bridgeIvSectionHistogram;
  final int bridgeIvStabilizationSuccessCount;
  final int bridgeIvFallbackCount;
  final Map<String, int> bridgeReturnSectionHistogram;
  final int chromaticMediantStartCount;
  final double chromaticMediantDensity;
  final int chromaticMediantPayoffCount;
  final int chromaticMediantFailedPayoffCount;
  final int returnHomeDebtOpenCount;
  final int returnHomeDebtPayoffCount;
  final int returnHomeOpportunityCount;
  final int returnHomeSelectionCount;
  final double minorCenterOccupancy;
  final int directAppliedToNewTonicViolations;
  final Map<String, int> rareColorUsage;
  final int rareColorPayoffCount;
  final List<SmartQaCheck> qaChecks;
  final List<SmartDecisionTrace> traces;

  Map<String, Object?> toJson() {
    return {
      'jazzPreset': jazzPreset.name,
      'sourceProfile': sourceProfile.name,
      'modulationIntensity': modulationIntensity.name,
      'steps': steps,
      'modulationAttemptCount': modulationAttemptCount,
      'modulationSuccessCount': modulationSuccessCount,
      'blockedReasonHistogram': {
        for (final entry in blockedReasonHistogram.entries)
          entry.key.name: entry.value,
      },
      'modalBranchCount': modalBranchCount,
      'appliedDominantInsertionCount': appliedDominantInsertionCount,
      'fallbackCount': fallbackCount,
      'familyHistogram': familyHistogram,
      'familyLengthHistogram': {
        for (final entry in familyLengthHistogram.entries)
          entry.key.toString(): entry.value,
      },
      'cadenceHistogram': cadenceHistogram,
      'tonicizationCount': tonicizationCount,
      'realModulationCount': realModulationCount,
      'modulationRelationHistogram': modulationRelationHistogram,
      'phraseRoleModulationHistogram': phraseRoleModulationHistogram,
      'relatedIiAppliedCount': relatedIiAppliedCount,
      'nakedAppliedCount': nakedAppliedCount,
      'dominantIntentHistogram': dominantIntentHistogram,
      'susReleaseCount': susReleaseCount,
      'susResolutionOpportunities': susResolutionOpportunities,
      'bridgeIvSectionHistogram': bridgeIvSectionHistogram,
      'bridgeIvStabilizationSuccessCount': bridgeIvStabilizationSuccessCount,
      'bridgeIvFallbackCount': bridgeIvFallbackCount,
      'bridgeReturnSectionHistogram': bridgeReturnSectionHistogram,
      'chromaticMediantStartCount': chromaticMediantStartCount,
      'chromaticMediantDensity': chromaticMediantDensity,
      'chromaticMediantPayoffCount': chromaticMediantPayoffCount,
      'chromaticMediantFailedPayoffCount': chromaticMediantFailedPayoffCount,
      'returnHomeDebtOpenCount': returnHomeDebtOpenCount,
      'returnHomeDebtPayoffCount': returnHomeDebtPayoffCount,
      'returnHomeOpportunityCount': returnHomeOpportunityCount,
      'returnHomeSelectionCount': returnHomeSelectionCount,
      'minorCenterOccupancy': minorCenterOccupancy,
      'directAppliedToNewTonicViolations': directAppliedToNewTonicViolations,
      'rareColorUsage': rareColorUsage,
      'rareColorPayoffCount': rareColorPayoffCount,
      'qaChecks': [for (final check in qaChecks) check.toJson()],
    };
  }

  String toJsonString({bool pretty = false}) {
    return pretty
        ? const JsonEncoder.withIndent('  ').convert(toJson())
        : jsonEncode(toJson());
  }

  String toCsv() {
    final buffer = StringBuffer()..writeln('metric,value');
    void writeMetric(String name, Object value) {
      buffer.writeln('$name,$value');
    }

    writeMetric('steps', steps);
    writeMetric('modulationAttemptCount', modulationAttemptCount);
    writeMetric('modulationSuccessCount', modulationSuccessCount);
    writeMetric('tonicizationCount', tonicizationCount);
    writeMetric('realModulationCount', realModulationCount);
    writeMetric('fallbackCount', fallbackCount);
    writeMetric(
      'bridgeIvStabilizationSuccessCount',
      bridgeIvStabilizationSuccessCount,
    );
    writeMetric('bridgeIvFallbackCount', bridgeIvFallbackCount);
    writeMetric('chromaticMediantStartCount', chromaticMediantStartCount);
    writeMetric(
      'chromaticMediantDensity',
      chromaticMediantDensity.toStringAsFixed(3),
    );
    writeMetric('chromaticMediantPayoffCount', chromaticMediantPayoffCount);
    writeMetric(
      'chromaticMediantFailedPayoffCount',
      chromaticMediantFailedPayoffCount,
    );
    writeMetric('returnHomeDebtOpenCount', returnHomeDebtOpenCount);
    writeMetric('returnHomeDebtPayoffCount', returnHomeDebtPayoffCount);
    writeMetric('returnHomeOpportunityCount', returnHomeOpportunityCount);
    writeMetric('returnHomeSelectionCount', returnHomeSelectionCount);
    writeMetric(
      'minorCenterOccupancy',
      minorCenterOccupancy.toStringAsFixed(3),
    );
    writeMetric(
      'directAppliedToNewTonicViolations',
      directAppliedToNewTonicViolations,
    );
    for (final check in qaChecks) {
      writeMetric('qa:${check.id}', '${check.status.name}|${check.detail}');
    }
    return buffer.toString();
  }
}
