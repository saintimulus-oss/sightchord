import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'settings/inversion_settings.dart';

part 'smart_generator_diagnostics.dart';
part 'music/smart_generator_legacy_priors.dart';
part 'music/smart_generator_models.dart';
part 'music/priors/smart_prior_models.dart';
part 'music/priors/smart_prior_lookup.dart';
part 'music/priors/smart_priors.dart';
part 'music/priors/generated/smart_family_priors.g.dart';
part 'music/priors/generated/smart_transition_priors.g.dart';
part 'music/priors/generated/smart_prior_profiles.g.dart';

class SmartGeneratorHelper {
  const SmartGeneratorHelper._();

  static const Map<RomanNumeralId, RomanNumeralId>
  secondaryDominantByResolution = _secondaryDominantByResolution;

  static const Map<RomanNumeralId, RomanNumeralId>
  substituteDominantByResolution = _substituteDominantByResolution;

  static const Map<RomanNumeralId, List<WeightedNextRoman>>
  majorDiatonicTransitions = _majorDiatonicTransitions;

  static const Map<RomanNumeralId, List<WeightedNextRoman>>
  minorDiatonicTransitions = _minorDiatonicTransitions;

  static SmartTransitionSelection selectNextRoman({
    required Random random,
    required RomanNumeralId? currentRomanNumeralId,
    required Iterable<RomanNumeralId> allowedRomanNumerals,
    KeyMode currentKeyMode = KeyMode.major,
  }) {
    final allowedSet = allowedRomanNumerals.toSet();
    final normalizedCurrentRoman = _normalizedTransitionRoman(
      currentRomanNumeralId,
      currentKeyMode,
    );
    final configuredCandidates = SmartPriorLookup.transitionCandidates(
      keyMode: currentKeyMode,
      currentRomanNumeralId: normalizedCurrentRoman,
    );

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

  static RomanNumeralId? continuationResolutionRomanNumeralId(
    GeneratedChord chord,
  ) {
    return chord.resolutionTargetRomanId ?? chord.resolutionRomanNumeralId;
  }

  static SmartCandidateComparison compareVoiceLeadingCandidates({
    required Random random,
    required List<SmartRenderCandidate> candidates,
    GeneratedChord? previousChord,
    bool allowV7sus4 = true,
    bool allowTensions = true,
    Set<String>? selectedTensionOptions,
    InversionSettings inversionSettings = const InversionSettings(),
    ChordSymbolStyle debugChordStyle = ChordSymbolStyle.majText,
  }) {
    final resolvedCandidates = <_RankedSmartCandidate>[];
    final tensionOptions =
        selectedTensionOptions ??
        ChordRenderingHelper.supportedTensionOptions.toSet();
    for (
      var sourceIndex = 0;
      sourceIndex < candidates.length;
      sourceIndex += 1
    ) {
      final candidate = candidates[sourceIndex];
      final spec = MusicTheory.specFor(candidate.romanNumeralId);
      final normalizedAppliedType =
          candidate.appliedType ??
          _appliedTypeForRoman(candidate.romanNumeralId);
      final normalizedResolutionTargetRomanId =
          candidate.resolutionTargetRomanId ?? spec.resolutionTargetId;
      final harmonicFunction = _harmonicFunctionForRoman(
        romanNumeralId: candidate.romanNumeralId,
        plannedChordKind: candidate.plannedChordKind,
        appliedType: normalizedAppliedType,
      );
      final root = MusicTheory.resolveChordRootForCenter(
        candidate.keyCenter,
        candidate.romanNumeralId,
      );
      final optionQualities = _renderQualityOptionsForCandidate(
        random: random,
        candidate: candidate,
        allowV7sus4: allowV7sus4,
      );
      final defaultQuality = optionQualities.first;
      for (
        var optionIndex = 0;
        optionIndex < optionQualities.length;
        optionIndex += 1
      ) {
        final optionQuality = optionQualities[optionIndex];
        final optionRandom = sourceIndex == 0 && optionIndex == 0
            ? random
            : Random(
                _rankedCandidateSeed(
                  sourceIndex: sourceIndex,
                  optionIndex: optionIndex,
                  candidate: candidate,
                ),
              );
        final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
          random: optionRandom,
          root: root,
          harmonicQuality: spec.quality,
          renderQuality: optionQuality,
          romanNumeralId: candidate.romanNumeralId,
          plannedChordKind: candidate.plannedChordKind,
          sourceKind: spec.sourceKind,
          allowTensions: allowTensions,
          selectedTensionOptions: tensionOptions,
          suppressTensions: candidate.suppressTensions,
          inversionSettings: inversionSettings,
          dominantContext: candidate.dominantContext,
          dominantIntent: candidate.dominantIntent,
        );
        final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
          keyName: candidate.keyCenter.tonicName,
          romanNumeralId: candidate.romanNumeralId,
          harmonicFunction: harmonicFunction,
          plannedChordKind: candidate.plannedChordKind,
          symbolData: renderingSelection.symbolData,
          sourceKind: spec.sourceKind,
          appliedType: normalizedAppliedType,
          resolutionTargetRomanId: normalizedResolutionTargetRomanId,
          patternTag: candidate.patternTag,
          dominantContext: candidate.dominantContext,
          dominantIntent: candidate.dominantIntent,
        );
        final harmonicComparisonKey =
            ChordRenderingHelper.buildHarmonicComparisonKey(
              keyName: candidate.keyCenter.tonicName,
              romanNumeralId: candidate.romanNumeralId,
              harmonicFunction: harmonicFunction,
              plannedChordKind: candidate.plannedChordKind,
              symbolData: renderingSelection.symbolData,
              sourceKind: spec.sourceKind,
              appliedType: normalizedAppliedType,
              resolutionTargetRomanId: normalizedResolutionTargetRomanId,
              patternTag: candidate.patternTag,
              dominantContext: candidate.dominantContext,
              dominantIntent: candidate.dominantIntent,
            );
        final chord = GeneratedChord(
          symbolData: renderingSelection.symbolData,
          repeatGuardKey: repeatGuardKey,
          harmonicComparisonKey: harmonicComparisonKey,
          keyName: candidate.keyCenter.tonicName,
          keyCenter: candidate.keyCenter,
          romanNumeralId: candidate.romanNumeralId,
          resolutionRomanNumeralId: spec.resolutionTargetId,
          harmonicFunction: harmonicFunction,
          patternTag: candidate.patternTag,
          plannedChordKind: candidate.plannedChordKind,
          sourceKind: spec.sourceKind,
          appliedType: normalizedAppliedType,
          resolutionTargetRomanId: normalizedResolutionTargetRomanId,
          dominantContext: candidate.dominantContext,
          dominantIntent: candidate.dominantIntent,
          wasExcludedFallback: candidate.wasExcludedFallback,
          isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
        );
        resolvedCandidates.add(
          _RankedSmartCandidate(
            chord: chord,
            candidate: candidate,
            voiceLeading: _scoreVoiceLeading(
              previousChord: previousChord,
              candidateChord: chord,
            ),
            sourceIndex: sourceIndex,
            optionIndex: optionIndex,
            defaultOption: optionQuality == defaultQuality,
            debugStyle: debugChordStyle,
          ),
        );
      }
    }

    resolvedCandidates.sort((left, right) {
      final scoreDelta = right.voiceLeading.total.compareTo(
        left.voiceLeading.total,
      );
      if (scoreDelta != 0) {
        return scoreDelta;
      }
      final defaultDelta = (right.defaultOption ? 1 : 0).compareTo(
        left.defaultOption ? 1 : 0,
      );
      if (defaultDelta != 0) {
        return defaultDelta;
      }
      final sourceDelta = left.sourceIndex.compareTo(right.sourceIndex);
      if (sourceDelta != 0) {
        return sourceDelta;
      }
      return left.optionIndex.compareTo(right.optionIndex);
    });

    final alternativeSummaries = [
      for (final ranked in resolvedCandidates.take(4))
        _debugSummaryForCandidate(
          chord: ranked.chord,
          style: debugChordStyle,
          breakdown: ranked.voiceLeading,
        ),
    ];

    return SmartCandidateComparison(
      rankedCandidates: [
        for (final ranked in resolvedCandidates)
          SmartRenderedCandidate(
            chord: _decorateVoiceLeadingDebug(
              candidate: ranked,
              alternatives: alternativeSummaries,
            ),
            voiceLeading: ranked.voiceLeading,
          ),
      ],
    );
  }

  static GeneratedChord _decorateVoiceLeadingDebug({
    required _RankedSmartCandidate candidate,
    required List<String> alternatives,
  }) {
    final chord = candidate.chord;
    final smartDebug = candidate.candidate.smartDebug;
    if (smartDebug == null) {
      return chord;
    }
    final decoratedDebug = smartDebug
        .withVoiceLeading(
          breakdown: candidate.voiceLeading,
          alternatives: alternatives,
        )
        .withFinalSelection(
          finalKeyCenter: chord.keyCenter!,
          finalRomanNumeralId: chord.romanNumeralId!,
          finalChord: ChordRenderingHelper.renderedSymbol(
            chord,
            candidate.debugStyle,
          ),
          fallbackOccurred:
              smartDebug.fallbackOccurred || chord.wasExcludedFallback,
          finalRoot: chord.symbolData.root,
          finalRenderQuality: chord.symbolData.renderQuality,
          finalTensions: chord.symbolData.tensions,
          finalRenderedNonDiatonic: chord.isRenderedNonDiatonic,
        );
    return chord.copyWith(smartDebug: decoratedDebug);
  }

  static String _debugSummaryForCandidate({
    required GeneratedChord chord,
    required ChordSymbolStyle style,
    required SmartVoiceLeadingBreakdown breakdown,
  }) {
    return '${ChordRenderingHelper.renderedSymbol(chord, style)} '
        '${breakdown.describe()}';
  }

  static int _rankedCandidateSeed({
    required int sourceIndex,
    required int optionIndex,
    required SmartRenderCandidate candidate,
  }) {
    return Object.hash(
          sourceIndex,
          optionIndex,
          candidate.keyCenter.serialize(),
          candidate.romanNumeralId.name,
          candidate.plannedChordKind.name,
          candidate.renderQualityOverride?.name,
          candidate.patternTag,
          candidate.appliedType?.name,
          candidate.resolutionTargetRomanId?.name,
          candidate.dominantContext?.name,
          candidate.dominantIntent?.name,
        ) &
        0x3fffffff;
  }

  static List<ChordQuality> _renderQualityOptionsForCandidate({
    required Random random,
    required SmartRenderCandidate candidate,
    required bool allowV7sus4,
  }) {
    if (candidate.renderQualityOverride != null) {
      return [candidate.renderQualityOverride!];
    }
    final defaultQuality = MusicTheory.resolveRenderQuality(
      romanNumeralId: candidate.romanNumeralId,
      plannedChordKind: candidate.plannedChordKind,
      allowV7sus4: allowV7sus4,
      randomRoll: random.nextInt(100),
      dominantContext: candidate.dominantContext,
      dominantIntent: candidate.dominantIntent,
    );
    final options = <ChordQuality>[defaultQuality];
    if (candidate.plannedChordKind != PlannedChordKind.resolvedRoman) {
      return options;
    }
    final baseQuality = MusicTheory.specFor(candidate.romanNumeralId).quality;
    if (baseQuality != ChordQuality.dominant7) {
      return options;
    }
    final effectiveIntent =
        candidate.dominantIntent ??
        MusicTheory.dominantIntentForContext(candidate.dominantContext);
    if (effectiveIntent == DominantIntent.primaryAuthenticMinor ||
        effectiveIntent == DominantIntent.secondaryToMinor) {
      options.addAll(const [ChordQuality.dominant7Alt, ChordQuality.dominant7]);
    } else if (effectiveIntent == DominantIntent.tritoneSub ||
        effectiveIntent == DominantIntent.lydianDominant ||
        effectiveIntent == DominantIntent.backdoor) {
      options.addAll(const [
        ChordQuality.dominant7Sharp11,
        ChordQuality.dominant7,
      ]);
    } else if (effectiveIntent == DominantIntent.susDelay) {
      options.addAll(const [
        ChordQuality.dominant13sus4,
        ChordQuality.dominant7sus4,
      ]);
    } else {
      options.add(ChordQuality.dominant7);
      if (allowV7sus4) {
        options.addAll(const [
          ChordQuality.dominant13sus4,
          ChordQuality.dominant7sus4,
        ]);
      }
    }
    final unique = <ChordQuality>[];
    for (final option in options) {
      if (!unique.contains(option)) {
        unique.add(option);
      }
    }
    return unique;
  }

  static SmartVoiceLeadingBreakdown _scoreVoiceLeading({
    required GeneratedChord? previousChord,
    required GeneratedChord candidateChord,
  }) {
    if (previousChord == null) {
      return const SmartVoiceLeadingBreakdown(total: 0);
    }
    final previousTones = _pitchClassesForChord(previousChord);
    final candidateTones = _pitchClassesForChord(candidateChord);
    final commonToneCount = previousTones.intersection(candidateTones).length;
    final commonToneBonus = min(0.72, commonToneCount * 0.24);

    var guideToneBonus = 0.0;
    for (final guideTone in _guideTonePitchClasses(previousChord.symbolData)) {
      final resolvesBySemitone =
          candidateTones.contains((guideTone + 1) % 12) ||
          candidateTones.contains((guideTone + 11) % 12);
      if (resolvesBySemitone) {
        guideToneBonus += 0.75;
      }
    }

    var rootLeapPenalty = 0.0;
    final previousAnchor = _rootAnchorSemitone(previousChord.symbolData);
    final candidateAnchor = _rootAnchorSemitone(candidateChord.symbolData);
    if (previousAnchor != null && candidateAnchor != null) {
      final leap = _pitchDistance(previousAnchor, candidateAnchor);
      if (leap >= 6) {
        rootLeapPenalty = -1.1;
      }
    }

    final sameRootSusPayoffBonus =
        _isSusDominantQuality(previousChord.symbolData.renderQuality) &&
            _isPlainDominantQuality(candidateChord.symbolData.renderQuality) &&
            previousChord.symbolData.root == candidateChord.symbolData.root
        ? 1.1
        : 0.0;

    final total =
        guideToneBonus +
        commonToneBonus +
        rootLeapPenalty +
        sameRootSusPayoffBonus;
    return SmartVoiceLeadingBreakdown(
      total: total,
      guideToneSemitoneBonus: guideToneBonus,
      commonToneRetentionBonus: commonToneBonus,
      rootLeapPenalty: rootLeapPenalty,
      sameRootSusPayoffBonus: sameRootSusPayoffBonus,
    );
  }

  static Set<int> _pitchClassesForChord(GeneratedChord chord) {
    return ChordRenderingHelper.targetPitchClassesForChord(chord);
  }

  static List<int> _guideTonePitchClasses(ChordSymbolData symbolData) {
    final rootSemitone = MusicTheory.noteToSemitone[symbolData.root];
    if (rootSemitone == null) {
      return const <int>[];
    }
    final formula = ChordToneFormulaLibrary.formulaFor(
      symbolData.renderQuality,
    );
    final guideOffsets = <int>[];
    if (formula.length >= 2) {
      guideOffsets.add(formula[1]);
    }
    if (formula.length >= 4 &&
        symbolData.renderQuality != ChordQuality.six &&
        symbolData.renderQuality != ChordQuality.minor6) {
      guideOffsets.add(formula[3]);
    }
    return [for (final offset in guideOffsets) (rootSemitone + offset) % 12];
  }

  static int? _rootAnchorSemitone(ChordSymbolData symbolData) {
    return MusicTheory.noteToSemitone[symbolData.bass ?? symbolData.root];
  }

  static int _pitchDistance(int left, int right) {
    final delta = (right - left).abs() % 12;
    return delta > 6 ? 12 - delta : delta;
  }

  static bool _isSusDominantQuality(ChordQuality quality) {
    return quality == ChordQuality.dominant13sus4 ||
        quality == ChordQuality.dominant7sus4;
  }

  static bool _isPlainDominantQuality(ChordQuality quality) {
    return quality == ChordQuality.dominant7 ||
        quality == ChordQuality.dominant7Alt ||
        quality == ChordQuality.dominant7Sharp11;
  }

  static SmartPhraseContext _phraseContextForRequest(SmartStepRequest request) {
    return request.phraseContext ??
        SmartPhraseContext.rollingForm(request.stepIndex);
  }

  static String? _homeCenterLabelForStep({
    required int stepIndex,
    required KeyCenter currentKeyCenter,
    required SmartDecisionTrace? previousTrace,
  }) {
    return previousTrace?.homeCenterLabel ??
        (stepIndex == 0 ? currentKeyCenter.displayName : null);
  }

  static bool _isBridgeReturnZone(SmartPhraseContext phraseContext) {
    return phraseContext.sectionRole == SectionRole.bridgeLike ||
        phraseContext.sectionRole == SectionRole.turnaroundTail ||
        phraseContext.sectionRole == SectionRole.tag;
  }

  static bool _isNearCadentialBoundary(SmartPhraseContext phraseContext) {
    return phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
  }

  static ResolutionDebt? _returnHomeDebtForRequest(SmartStepRequest request) {
    final debts = request.currentTrace?.outstandingDebts ?? const [];
    ResolutionDebt? selectedDebt;
    for (final debt in debts) {
      if (debt.debtType != ResolutionDebtType.returnHomeCadence) {
        continue;
      }
      if (selectedDebt == null ||
          debt.deadline < selectedDebt.deadline ||
          (debt.deadline == selectedDebt.deadline &&
              debt.severity > selectedDebt.severity)) {
        selectedDebt = debt;
      }
    }
    return selectedDebt;
  }

  static bool _isBridgeReturnWindowForDebt(
    SmartPhraseContext phraseContext, {
    ResolutionDebt? returnHomeDebt,
  }) {
    if (!_isBridgeReturnZone(phraseContext)) {
      return false;
    }
    if (_isNearCadentialBoundary(phraseContext)) {
      return true;
    }
    if (phraseContext.phraseRole != PhraseRole.continuation ||
        returnHomeDebt == null) {
      return false;
    }
    return returnHomeDebt.deadline <= 2 || returnHomeDebt.severity >= 4;
  }

  static KeyCenter? _returnHomeTargetCenterForRequest(
    SmartStepRequest request,
  ) {
    final targetedDebt = request.currentTrace?.outstandingDebts.firstWhere(
      (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
      orElse: () => const ResolutionDebt(
        debtType: ResolutionDebtType.returnHomeCadence,
        targetLabel: '',
        deadline: 0,
        severity: 0,
      ),
    );
    if (targetedDebt != null && targetedDebt.targetLabel.isNotEmpty) {
      final parsedDebtCenter = _parseDisplayCenterLabel(
        label: targetedDebt.targetLabel,
        activeKeys: request.activeKeys,
      );
      if (parsedDebtCenter != null) {
        return parsedDebtCenter;
      }
    }
    if (request.currentTrace?.homeCenterLabel != null) {
      final parsedHomeCenter = _parseDisplayCenterLabel(
        label: request.currentTrace!.homeCenterLabel!,
        activeKeys: request.activeKeys,
      );
      if (parsedHomeCenter != null) {
        return parsedHomeCenter;
      }
    }
    return _inferredHomeCenterForRequest(request);
  }

  static List<ResolutionDebt> _returnHomeDebtsForAwayArrival({
    required SmartStepRequest request,
    required KeyCenter finalTargetCenter,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final inferredHomeCenter = _returnHomeTargetCenterForRequest(request);
    final opensReturnHomeDebt =
        inferredHomeCenter != null &&
        inferredHomeCenter != finalTargetCenter &&
        _isBridgeReturnZone(phraseContext);
    if (!opensReturnHomeDebt) {
      return const [];
    }
    return [
      ResolutionDebt(
        debtType: ResolutionDebtType.returnHomeCadence,
        targetLabel: inferredHomeCenter.displayName,
        deadline: 4,
        severity: 3,
      ),
    ];
  }

  static LocalScope? _nextLocalScope({
    required LocalScope? previousScope,
    required QueuedSmartChord queuedChord,
  }) {
    var scope = previousScope?.tick();
    if (scope?.isExpired ?? false) {
      scope = null;
    }
    if (queuedChord.closeScope) {
      scope = null;
    }
    if (queuedChord.openScope != null) {
      scope = queuedChord.openScope;
    }
    if (queuedChord.modulationKind == ModulationKind.real &&
        queuedChord.postModulationConfirmationsRemaining > 0) {
      scope = LocalScope(
        center: queuedChord.keyCenter.copyWith(
          confirmationsRemaining:
              queuedChord.postModulationConfirmationsRemaining,
        ),
        headType: ScopeHeadType.tonicHead,
        confidence: queuedChord.modulationConfidence <= 0
            ? 0.72
            : queuedChord.modulationConfidence,
        expiresIn: queuedChord.postModulationConfirmationsRemaining,
      );
    }
    return scope;
  }

  static List<ResolutionDebt> _nextOutstandingDebts({
    required List<ResolutionDebt> previousDebts,
    required QueuedSmartChord queuedChord,
  }) {
    final next = <ResolutionDebt>[];
    for (final debt in previousDebts) {
      if (queuedChord.satisfiedDebtTypes.contains(debt.debtType)) {
        continue;
      }
      final decremented = debt.tick();
      if (!decremented.isExpired) {
        next.add(decremented);
      }
    }
    next.addAll(queuedChord.openedDebts);
    return next;
  }

  static LocalScope? _decayScope(LocalScope? scope) {
    final next = scope?.tick();
    if (next == null || next.isExpired) {
      return null;
    }
    return next;
  }

  static List<ResolutionDebt> _decayDebts(List<ResolutionDebt> debts) {
    return [
      for (final debt in debts)
        if (!debt.tick().isExpired) debt.tick(),
    ];
  }

  static List<SmartDecisionTrace> _recentPlanningTraces({int take = 16}) {
    final traces = SmartDiagnosticsStore.recent();
    if (traces.length <= take) {
      return traces;
    }
    return traces.sublist(traces.length - take);
  }

  static int _surpriseBudgetForPreset(JazzPreset preset) {
    return switch (preset) {
      JazzPreset.standardsCore => 3,
      JazzPreset.modulationStudy => 4,
      JazzPreset.advanced => 6,
    };
  }

  static int _usedSurpriseBudget(List<SmartDecisionTrace> recentTraces) {
    var used = 0;
    for (final trace in recentTraces) {
      if (trace.modulationKind == ModulationKind.real) {
        used +=
            trace.finalKeyRelation == KeyRelation.mediant ||
                trace.finalKeyRelation == KeyRelation.distant
            ? 2
            : 1;
      }
      if (trace.activePatternTag == 'dominant_chain_bridge_style') {
        used += 1;
      }
      if (trace.finalRenderQuality == ChordQuality.dominant7Alt ||
          trace.finalRenderQuality == ChordQuality.dominant7Sharp11) {
        used += 1;
      }
      if (trace.surfaceTags.any(
        (tag) =>
            tag == 'rareColor' ||
            tag == 'commonToneDim' ||
            tag == 'tritoneSub' ||
            tag == 'backdoorFlavor',
      )) {
        used += 1;
      }
    }
    return used;
  }

  static double _surpriseBudgetMultiplier({
    required SmartStepRequest request,
    bool rare = false,
    bool modulation = false,
  }) {
    final recentTraces = _recentPlanningTraces(take: 8);
    final phraseContext = _phraseContextForRequest(request);
    final showcaseContext = _isRareShowcaseContext(phraseContext);
    final remaining =
        _surpriseBudgetForPreset(request.jazzPreset) -
        _usedSurpriseBudget(recentTraces);
    if (remaining <= 0) {
      return 0;
    }
    if (rare && remaining == 1) {
      return showcaseContext ? 0.5 : 0.3;
    }
    if (modulation && remaining == 1) {
      return request.modulationIntensity == ModulationIntensity.high
          ? (showcaseContext ? 0.8 : 0.6)
          : (showcaseContext ? 0.55 : 0.4);
    }
    return 1;
  }

  static bool _isRareShowcaseContext(SmartPhraseContext phraseContext) {
    return phraseContext.sectionRole == SectionRole.bridgeLike ||
        phraseContext.sectionRole == SectionRole.turnaroundTail ||
        phraseContext.sectionRole == SectionRole.tag ||
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence;
  }

  static bool _isTonicizationHeavyFamily(SmartProgressionFamily family) {
    return switch (family) {
      SmartProgressionFamily.relativeMinorReframe ||
      SmartProgressionFamily.dominantHeadedScopeChain ||
      SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI ||
      SmartProgressionFamily.dominantChainBridgeStyle ||
      SmartProgressionFamily.appliedDominantWithRelatedIi => true,
      _ => false,
    };
  }

  static bool _isDominantHeavyFamily(SmartProgressionFamily family) {
    return switch (family) {
      SmartProgressionFamily.coreIiVIMajor ||
      SmartProgressionFamily.turnaroundIViIiV ||
      SmartProgressionFamily.relativeMinorReframe ||
      SmartProgressionFamily.dominantHeadedScopeChain ||
      SmartProgressionFamily.minorIiVAltI ||
      SmartProgressionFamily.dominantChainBridgeStyle ||
      SmartProgressionFamily.appliedDominantWithRelatedIi ||
      SmartProgressionFamily.cadenceBasedRealModulation => true,
      _ => false,
    };
  }

  static bool _isDominantHeavyPatternTag(String patternTag) {
    return patternTag == 'core_ii_v_i_major' ||
        patternTag == 'turnaround_i_vi_ii_v' ||
        patternTag == 'relative_minor_reframe' ||
        patternTag == 'dominant_headed_scope_chain' ||
        patternTag == 'minor_ii_halfdim_v_alt_i' ||
        patternTag == 'dominant_chain_bridge_style' ||
        patternTag == 'applied_dominant_with_related_ii' ||
        patternTag == 'cadence_based_real_modulation';
  }

  static bool _isCadentialFinalDominantPatternTag(String patternTag) {
    return patternTag == 'core_ii_v_i_major' ||
        patternTag == 'minor_ii_halfdim_v_alt_i' ||
        patternTag == 'closing_plagal_authentic_hybrid' ||
        patternTag == 'backdoor_recursive_prep' ||
        patternTag == 'backdoor_ivm_bVII_I' ||
        patternTag == 'classical_predominant_color' ||
        patternTag == 'bridge_return_home_cadence' ||
        patternTag == 'cadence_based_real_modulation' ||
        patternTag == 'common_chord_modulation' ||
        patternTag == 'mixture_pivot_modulation' ||
        patternTag == 'chromatic_mediant_common_tone_modulation' ||
        patternTag == 'coltrane_burst';
  }

  static bool _isCadentialFinalDominantTrace(SmartDecisionTrace trace) {
    final patternTag = trace.activePatternTag;
    return trace.finalRomanNumeralId == RomanNumeralId.vDom7 &&
        patternTag != null &&
        _isCadentialFinalDominantPatternTag(patternTag) &&
        trace.queuedPatternLength <= 1;
  }

  static int _dominantIntentBudgetForPreset(JazzPreset preset) {
    return switch (preset) {
      JazzPreset.standardsCore => 4,
      JazzPreset.modulationStudy => 5,
      JazzPreset.advanced => 5,
    };
  }

  static int _dominantIntentCostForTrace(SmartDecisionTrace trace) {
    var cost = 0;
    if (trace.finalRomanNumeralId == RomanNumeralId.vDom7) {
      cost += _isCadentialFinalDominantTrace(trace) ? 1 : 2;
    }
    if (trace.appliedType != null) {
      cost += 2;
    }
    if (trace.activePatternTag == 'dominant_chain_bridge_style' ||
        trace.activePatternTag == 'dominant_headed_scope_chain' ||
        trace.activePatternTag == 'applied_dominant_with_related_ii') {
      cost += 1;
    }
    return cost;
  }

  static int _usedDominantIntentBudget(List<SmartDecisionTrace> recentTraces) {
    return recentTraces.fold<int>(
      0,
      (sum, trace) => sum + _dominantIntentCostForTrace(trace),
    );
  }

  static int _dominantIntentOverflow(SmartStepRequest request, {int take = 8}) {
    final recentTraces = _recentPlanningTraces(take: take);
    return _usedDominantIntentBudget(recentTraces) -
        _dominantIntentBudgetForPreset(request.jazzPreset);
  }

  static bool _isRareReachabilityFamily(SmartProgressionFamily family) {
    return switch (family) {
      SmartProgressionFamily.backdoorRecursivePrep ||
      SmartProgressionFamily.commonChordModulation ||
      SmartProgressionFamily.chromaticMediantCommonToneModulation ||
      SmartProgressionFamily.coltraneBurst => true,
      _ => false,
    };
  }

  static int _patternStepStreak(String? patternTag) {
    if (patternTag == null) {
      return 0;
    }
    var streak = 0;
    for (final trace in _recentPlanningTraces(take: 8).reversed) {
      if (trace.activePatternTag != patternTag) {
        break;
      }
      streak += 1;
    }
    return streak;
  }

  static double _tonicizationPressureMultiplier({
    required SmartProgressionFamily family,
    required SmartStepRequest request,
  }) {
    if (!_isTonicizationHeavyFamily(family)) {
      return 1;
    }
    final phraseContext = _phraseContextForRequest(request);
    final recentTonicizations = _recentPlanningTraces(take: 8)
        .where((trace) => trace.modulationKind == ModulationKind.tonicization)
        .length;
    var multiplier = 1.0;
    if (recentTonicizations >= 2) {
      multiplier *= 0.84;
    }
    if (request.currentRenderedNonDiatonic) {
      multiplier *= 0.92;
    }
    if (request.activeKeys.length <= 1) {
      multiplier *= _isRareShowcaseContext(phraseContext) ? 0.82 : 0.68;
      if (family == SmartProgressionFamily.appliedDominantWithRelatedIi ||
          family == SmartProgressionFamily.dominantChainBridgeStyle ||
          family == SmartProgressionFamily.dominantHeadedScopeChain) {
        multiplier *= 0.9;
      }
    }
    return multiplier;
  }

  static KeyCenter? _returnHomeCandidateForRequest({
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
    ResolutionDebt? returnHomeDebt,
  }) {
    final inferredHomeCenter = _returnHomeTargetCenterForRequest(request);
    if (inferredHomeCenter == null ||
        inferredHomeCenter == request.currentKeyCenter) {
      return null;
    }
    for (final candidate in opportunity.candidates) {
      if (candidate == inferredHomeCenter) {
        return candidate;
      }
    }
    if (returnHomeDebt == null) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final relation = MusicTheory.relationBetweenCenters(
      request.currentKeyCenter,
      inferredHomeCenter,
    );
    if (!_relationAllowedForPreset(relation, request.jazzPreset)) {
      return null;
    }
    final confidence = _modulationConfidenceForTarget(
      currentCenter: request.currentKeyCenter,
      targetCenter: inferredHomeCenter,
      phraseContext: phraseContext,
      jazzPreset: request.jazzPreset,
      recentRealModulations: _recentPlanningTraces(
        take: 16,
      ).where((trace) => trace.modulationKind == ModulationKind.real).toList(),
    );
    if (confidence <= 0) {
      return null;
    }
    final boostedConfidence = min(
      0.98,
      confidence + (returnHomeDebt.deadline <= 2 ? 0.08 : 0.04),
    );
    return inferredHomeCenter.copyWith(
      relationToParent: relation,
      enteredBy: CenterEntryMethod.cadenceModulation,
      confidence: boostedConfidence,
      closenessClass: (boostedConfidence * 100).round(),
      confirmationsRemaining: 1,
    );
  }

  static double _dominantIntentPressureMultiplier({
    required SmartProgressionFamily family,
    required SmartStepRequest request,
  }) {
    final overflow = _dominantIntentOverflow(request);
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final phraseContext = _phraseContextForRequest(request);
    final preserveCadentialContext = _isNearCadentialBoundary(phraseContext);
    final bridgeReturnWindow = _isBridgeReturnWindowForDebt(
      phraseContext,
      returnHomeDebt: returnHomeDebt,
    );
    if (overflow <= 0) {
      if (family == SmartProgressionFamily.bridgeReturnHomeCadence &&
          returnHomeDebt != null &&
          bridgeReturnWindow) {
        return 1.08;
      }
      return 1;
    }

    final severeOverflow = overflow >= 3;
    var multiplier = 1.0;
    if (family == SmartProgressionFamily.bridgeReturnHomeCadence &&
        returnHomeDebt != null) {
      return bridgeReturnWindow ? 1.18 : 1.08;
    }
    if (family == SmartProgressionFamily.dominantChainBridgeStyle) {
      multiplier *= severeOverflow ? 0.22 : 0.42;
    } else if (family == SmartProgressionFamily.dominantHeadedScopeChain) {
      multiplier *= severeOverflow ? 0.34 : 0.56;
    } else if (family == SmartProgressionFamily.appliedDominantWithRelatedIi) {
      multiplier *= severeOverflow ? 0.42 : 0.64;
    } else if (family == SmartProgressionFamily.turnaroundIViIiV ||
        family == SmartProgressionFamily.turnaroundIIIviIiV) {
      multiplier *= preserveCadentialContext
          ? (severeOverflow ? 0.36 : 0.54)
          : (severeOverflow ? 0.48 : 0.68);
    } else if (_isDominantHeavyFamily(family)) {
      multiplier *= preserveCadentialContext
          ? (severeOverflow ? 0.86 : 0.94)
          : (severeOverflow ? 0.58 : 0.78);
    }
    if (returnHomeDebt != null &&
        bridgeReturnWindow &&
        (family == SmartProgressionFamily.dominantChainBridgeStyle ||
            family == SmartProgressionFamily.dominantHeadedScopeChain ||
            family == SmartProgressionFamily.appliedDominantWithRelatedIi ||
            family == SmartProgressionFamily.relativeMinorReframe)) {
      multiplier *= 0.72;
    }
    return multiplier;
  }

  static double _familySelectionQueueMultiplier({
    required _FamilyPlan familyPlan,
    required SmartStepRequest request,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final queueLength = familyPlan.queue.length;
    final showcaseRareFamily =
        _isRareReachabilityFamily(familyPlan.family) &&
        _isRareShowcaseContext(phraseContext);
    final preserveResolutionFamily =
        familyPlan.family == SmartProgressionFamily.bridgeReturnHomeCadence;
    var multiplier = 1.0;
    if (!showcaseRareFamily && !preserveResolutionFamily) {
      if (queueLength >= 4) {
        multiplier *= phraseContext.sectionRole == SectionRole.bridgeLike
            ? 0.82
            : 0.68;
      }
      if (queueLength >= 5) {
        multiplier *= phraseContext.sectionRole == SectionRole.bridgeLike
            ? 0.72
            : 0.58;
      }
    }
    if (_isDominantHeavyFamily(familyPlan.family)) {
      multiplier *= phraseContext.sectionRole == SectionRole.bridgeLike
          ? 0.86
          : 0.82;
    }
    if (familyPlan.family == SmartProgressionFamily.dominantChainBridgeStyle) {
      multiplier *= phraseContext.sectionRole == SectionRole.bridgeLike
          ? 0.52
          : 0.38;
    } else if (familyPlan.family ==
            SmartProgressionFamily.dominantHeadedScopeChain ||
        familyPlan.family ==
            SmartProgressionFamily.appliedDominantWithRelatedIi) {
      multiplier *= 0.62;
    }
    final dominantOverflow = _dominantIntentOverflow(request);
    final endsOnStandaloneDominant =
        familyPlan.queue.isNotEmpty &&
        familyPlan.queue.last.finalRomanNumeralId == RomanNumeralId.vDom7 &&
        !familyPlan.queue.any((chord) => chord.cadentialArrival);
    if (dominantOverflow > 0 && endsOnStandaloneDominant) {
      multiplier *= request.activeKeys.length <= 1
          ? (dominantOverflow >= 2 ? 0.34 : 0.5)
          : (dominantOverflow >= 2 ? 0.48 : 0.66);
    }
    if (dominantOverflow > 0 &&
        (familyPlan.family == SmartProgressionFamily.dominantChainBridgeStyle ||
            familyPlan.family ==
                SmartProgressionFamily.dominantHeadedScopeChain ||
            familyPlan.family ==
                SmartProgressionFamily.appliedDominantWithRelatedIi)) {
      multiplier *= dominantOverflow >= 3 ? 0.48 : 0.72;
    }
    final patternStreak = _patternStepStreak(request.currentPatternTag);
    if (patternStreak >= 2 && queueLength >= 3) {
      multiplier *= 0.86;
    }
    if (request.currentPatternTag == _familyTag(familyPlan.family)) {
      multiplier *= 0.72;
    } else if (request.currentPatternTag != null &&
        _isDominantHeavyPatternTag(request.currentPatternTag!) &&
        _isDominantHeavyFamily(familyPlan.family)) {
      multiplier *= 0.84;
    }
    return multiplier;
  }

  static _FamilyPlan _trimFamilyPlanHead({
    required _FamilyPlan familyPlan,
    required int skipCount,
    bool carryInitialScope = false,
  }) {
    if (skipCount <= 0 || familyPlan.queue.length - skipCount < 2) {
      return familyPlan;
    }
    final skipped = familyPlan.queue.take(skipCount).toList();
    final trimmedQueue = familyPlan.queue.skip(skipCount).toList();
    if (carryInitialScope && skipped.isNotEmpty && trimmedQueue.isNotEmpty) {
      var carriedScope = trimmedQueue.first.openScope;
      var carriedModulationAttempt = trimmedQueue.first.modulationAttempt;
      var carriedConfidence = trimmedQueue.first.modulationConfidence;
      final carriedSurfaceTags = <String>{...trimmedQueue.first.surfaceTags};
      for (final chord in skipped) {
        carriedScope ??= chord.openScope;
        carriedModulationAttempt =
            carriedModulationAttempt || chord.modulationAttempt;
        carriedConfidence = max(carriedConfidence, chord.modulationConfidence);
        carriedSurfaceTags.addAll(chord.surfaceTags);
      }
      trimmedQueue[0] = trimmedQueue.first.copyWith(
        openScope: carriedScope,
        modulationAttempt: carriedModulationAttempt,
        modulationConfidence: carriedConfidence,
        surfaceTags: carriedSurfaceTags.toList(),
      );
    }
    return _FamilyPlan(
      family: familyPlan.family,
      queue: trimmedQueue,
      destinationRomanNumeralId: familyPlan.destinationRomanNumeralId,
      modalCandidates: familyPlan.modalCandidates,
      appliedCandidates: familyPlan.appliedCandidates,
      modulationCandidates: familyPlan.modulationCandidates,
    );
  }

  static _FamilyPlan _compactFamilyPlanForContext({
    required Random random,
    required SmartStepRequest request,
    required _FamilyPlan familyPlan,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    if (familyPlan.queue.length < 3 ||
        phraseContext.phraseRole == PhraseRole.opener) {
      return familyPlan;
    }

    var skipCount = 0;
    var carryInitialScope = false;
    final dominantOverflow = _dominantIntentOverflow(request);
    final tightDominantBudget = dominantOverflow > 0;
    final severeDominantOverflow = dominantOverflow >= 3;
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final tailLikeContext =
        phraseContext.sectionRole == SectionRole.bridgeLike ||
        phraseContext.sectionRole == SectionRole.turnaroundTail ||
        phraseContext.sectionRole == SectionRole.tag;
    final cadentialWindow =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final bridgeReturnWindow = _isBridgeReturnWindowForDebt(
      phraseContext,
      returnHomeDebt: returnHomeDebt,
    );

    switch (familyPlan.family) {
      case SmartProgressionFamily.coreIiVIMajor:
        if ((request.currentHarmonicFunction == HarmonicFunction.predominant ||
                request.currentRomanNumeralId == RomanNumeralId.iiMin7 ||
                cadentialWindow) &&
            random.nextDouble() < (tailLikeContext ? 0.72 : 0.56)) {
          skipCount = 1;
        }
        break;
      case SmartProgressionFamily.turnaroundIViIiV:
        if ((request.currentHarmonicFunction == HarmonicFunction.tonic ||
                tailLikeContext) &&
            random.nextDouble() < (tailLikeContext ? 0.8 : 0.62)) {
          skipCount = 1;
        }
        break;
      case SmartProgressionFamily.turnaroundIIIviIiV:
        if ((request.currentHarmonicFunction == HarmonicFunction.tonic ||
                tailLikeContext) &&
            random.nextDouble() < 0.68) {
          skipCount = 1;
          if ((phraseContext.sectionRole == SectionRole.turnaroundTail ||
                  phraseContext.sectionRole == SectionRole.tag) &&
              familyPlan.queue.length - skipCount > 2 &&
              random.nextDouble() < 0.42) {
            skipCount += 1;
          }
        }
        break;
      case SmartProgressionFamily.relativeMinorReframe:
        if (request.currentKeyCenter.mode == KeyMode.major &&
            (phraseContext.phraseRole == PhraseRole.continuation ||
                _isRareShowcaseContext(phraseContext)) &&
            random.nextDouble() <
                (_isRareShowcaseContext(phraseContext) ? 0.72 : 0.58)) {
          skipCount = 1;
          carryInitialScope = true;
          if (familyPlan.queue.length - skipCount > 2 &&
              request.currentHarmonicFunction == HarmonicFunction.predominant &&
              random.nextDouble() < 0.3) {
            skipCount += 1;
          }
        }
        break;
      case SmartProgressionFamily.appliedDominantWithRelatedIi:
        if ((tailLikeContext ||
                tightDominantBudget ||
                returnHomeDebt != null) &&
            random.nextDouble() <
                (bridgeReturnWindow
                    ? 0.78
                    : tightDominantBudget
                    ? 0.62
                    : 0.42)) {
          skipCount = 1;
          carryInitialScope = true;
        }
        break;
      case SmartProgressionFamily.dominantHeadedScopeChain:
        if ((tailLikeContext || tightDominantBudget || returnHomeDebt != null) &&
            request.currentTrace?.activeLocalScope?.headType !=
                ScopeHeadType.dominantHead) {
          skipCount = severeDominantOverflow || bridgeReturnWindow ? 2 : 1;
          carryInitialScope = true;
        }
        break;
      case SmartProgressionFamily.dominantChainBridgeStyle:
        if (tailLikeContext || tightDominantBudget || returnHomeDebt != null) {
          skipCount = severeDominantOverflow || bridgeReturnWindow ? 3 : 2;
          carryInitialScope = true;
        }
        break;
      default:
        break;
    }

    return _trimFamilyPlanHead(
      familyPlan: familyPlan,
      skipCount: skipCount,
      carryInitialScope: carryInitialScope,
    );
  }

  static double _antiRepeatPenalty({
    required SmartProgressionFamily family,
    required SmartPhraseContext phraseContext,
  }) {
    final familyTag = _familyTag(family);
    final recent = _recentPlanningTraces(
      take: 12,
    ).where((trace) => trace.activePatternTag == familyTag).length;
    var penalty = 1.0;
    if (recent == 0) {
      penalty = 1.0;
    } else if (phraseContext.sectionRole == SectionRole.aLike && recent == 1) {
      penalty = 0.82;
    } else {
      penalty = max(0.28, 1 - recent * 0.24);
    }
    final recentDominantHeavyPatterns = _recentPlanningTraces(take: 10)
        .where(
          (trace) =>
              trace.activePatternTag != null &&
              _isDominantHeavyPatternTag(trace.activePatternTag!),
        )
        .length;
    if (_isDominantHeavyFamily(family) && recentDominantHeavyPatterns >= 4) {
      penalty *= recentDominantHeavyPatterns >= 6 ? 0.62 : 0.78;
    }
    return max(0.22, penalty);
  }

  static double _keyRelationPenalty(KeyRelation relation) {
    final recent = _recentPlanningTraces(
      take: 16,
    ).where((trace) => trace.finalKeyRelation == relation).length;
    if (recent == 0) {
      return 1;
    }
    return max(0.45, 1 - recent * 0.18);
  }

  static int _nonDiatonicStreakLength(SmartStepRequest request) {
    final recent = _recentPlanningTraces(take: 3).reversed.toList();
    var streak = request.currentRenderedNonDiatonic ? 1 : 0;
    for (final trace in recent) {
      final isNonDiatonic =
          trace.finalSourceKind != ChordSourceKind.diatonic ||
          trace.modulationKind != ModulationKind.none ||
          trace.finalRenderQuality == ChordQuality.dominant7Alt ||
          trace.finalRenderQuality == ChordQuality.dominant7Sharp11;
      if (!isNonDiatonic) {
        break;
      }
      streak += 1;
    }
    return streak;
  }

  static double _phraseRoleMultiplier(
    SmartProgressionFamily family,
    SmartPhraseContext phraseContext,
  ) {
    return switch (phraseContext.phraseRole) {
      PhraseRole.opener => switch (family) {
        SmartProgressionFamily.turnaroundIViIiV => 1.3,
        SmartProgressionFamily.turnaroundIIIviIiV => 1.18,
        SmartProgressionFamily.coreIiVIMajor => 0.82,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 0.58,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.3,
        SmartProgressionFamily.backdoorRecursivePrep => 0.28,
        SmartProgressionFamily.classicalPredominantColor => 0.14,
        SmartProgressionFamily.mixturePivotModulation => 0.12,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 0.08,
        SmartProgressionFamily.coltraneBurst => 0.04,
        SmartProgressionFamily.bridgeReturnHomeCadence => 0.12,
        SmartProgressionFamily.dominantHeadedScopeChain => 0.72,
        SmartProgressionFamily.minorIiVAltI => 0.82,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.45,
        SmartProgressionFamily.commonChordModulation => 0.52,
        _ => 1,
      },
      PhraseRole.continuation => switch (family) {
        SmartProgressionFamily.appliedDominantWithRelatedIi => 1.18,
        SmartProgressionFamily.dominantHeadedScopeChain => 1.28,
        SmartProgressionFamily.dominantChainBridgeStyle => 1.08,
        SmartProgressionFamily.turnaroundISharpIdimIiV => 1.12,
        SmartProgressionFamily.relativeMinorReframe => 1.16,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 0.84,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 1.18,
        SmartProgressionFamily.backdoorRecursivePrep => 0.72,
        SmartProgressionFamily.classicalPredominantColor => 0.44,
        SmartProgressionFamily.mixturePivotModulation => 0.58,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 0.72,
        SmartProgressionFamily.coltraneBurst => 0.52,
        SmartProgressionFamily.bridgeReturnHomeCadence => 0.18,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.78,
        _ => 1,
      },
      PhraseRole.preCadence => switch (family) {
        SmartProgressionFamily.coreIiVIMajor => 1.28,
        SmartProgressionFamily.minorIiVAltI => 1.24,
        SmartProgressionFamily.relativeMinorReframe => 1.12,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.24,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 1.12,
        SmartProgressionFamily.backdoorRecursivePrep => 1.18,
        SmartProgressionFamily.classicalPredominantColor => 1.24,
        SmartProgressionFamily.mixturePivotModulation => 1.2,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 1.18,
        SmartProgressionFamily.coltraneBurst => 1.2,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.22,
        SmartProgressionFamily.dominantHeadedScopeChain => 1.08,
        SmartProgressionFamily.backdoorIvmBviiI => 1.22,
        SmartProgressionFamily.cadenceBasedRealModulation => 1.16,
        SmartProgressionFamily.commonChordModulation => 1.1,
        _ => 0.94,
      },
      PhraseRole.cadence => switch (family) {
        SmartProgressionFamily.coreIiVIMajor => 1.42,
        SmartProgressionFamily.minorIiVAltI => 1.38,
        SmartProgressionFamily.relativeMinorReframe => 1.08,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.34,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.84,
        SmartProgressionFamily.backdoorRecursivePrep => 1.34,
        SmartProgressionFamily.classicalPredominantColor => 1.4,
        SmartProgressionFamily.mixturePivotModulation => 1.28,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 1.26,
        SmartProgressionFamily.coltraneBurst => 1.24,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.36,
        SmartProgressionFamily.dominantHeadedScopeChain => 0.88,
        SmartProgressionFamily.backdoorIvmBviiI => 1.3,
        SmartProgressionFamily.cadenceBasedRealModulation => 1.34,
        SmartProgressionFamily.commonChordModulation => 1.22,
        SmartProgressionFamily.turnaroundIViIiV => 0.82,
        _ => 0.92,
      },
      PhraseRole.release => switch (family) {
        SmartProgressionFamily.turnaroundIViIiV => 1.1,
        SmartProgressionFamily.minorLineCliche => 1.28,
        SmartProgressionFamily.relativeMinorReframe => 1.1,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.26,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.56,
        SmartProgressionFamily.backdoorRecursivePrep => 1.3,
        SmartProgressionFamily.classicalPredominantColor => 0.94,
        SmartProgressionFamily.mixturePivotModulation => 0.84,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 0.74,
        SmartProgressionFamily.coltraneBurst => 0.68,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.12,
        SmartProgressionFamily.dominantHeadedScopeChain => 0.7,
        SmartProgressionFamily.backdoorIvmBviiI => 1.18,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.92,
        _ => 0.95,
      },
    };
  }

  static double _sectionRoleMultiplier(
    SmartProgressionFamily family,
    SmartPhraseContext phraseContext,
  ) {
    return switch (phraseContext.sectionRole) {
      SectionRole.aLike => switch (family) {
        SmartProgressionFamily.coreIiVIMajor => 1.12,
        SmartProgressionFamily.turnaroundIViIiV => 1.18,
        SmartProgressionFamily.turnaroundIIIviIiV => 1.08,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.04,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.34,
        SmartProgressionFamily.backdoorRecursivePrep => 0.82,
        SmartProgressionFamily.classicalPredominantColor => 0.68,
        SmartProgressionFamily.mixturePivotModulation => 0.72,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 0.42,
        SmartProgressionFamily.coltraneBurst => 0.18,
        SmartProgressionFamily.bridgeReturnHomeCadence => 0.34,
        SmartProgressionFamily.dominantHeadedScopeChain => 0.94,
        SmartProgressionFamily.dominantChainBridgeStyle => 0.75,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.88,
        _ => 1,
      },
      SectionRole.bridgeLike => switch (family) {
        SmartProgressionFamily.dominantHeadedScopeChain => 1.34,
        SmartProgressionFamily.dominantChainBridgeStyle => 1.42,
        SmartProgressionFamily.cadenceBasedRealModulation => 1.34,
        SmartProgressionFamily.commonChordModulation => 1.28,
        SmartProgressionFamily.appliedDominantWithRelatedIi => 1.14,
        SmartProgressionFamily.relativeMinorReframe => 1.16,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 0.86,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 1.56,
        SmartProgressionFamily.backdoorRecursivePrep => 1.08,
        SmartProgressionFamily.classicalPredominantColor => 1.06,
        SmartProgressionFamily.mixturePivotModulation => 1.24,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 1.28,
        SmartProgressionFamily.coltraneBurst => 1.36,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.48,
        SmartProgressionFamily.turnaroundIViIiV => 0.75,
        _ => 1,
      },
      SectionRole.turnaroundTail => switch (family) {
        SmartProgressionFamily.turnaroundIViIiV => 1.38,
        SmartProgressionFamily.turnaroundISharpIdimIiV => 1.25,
        SmartProgressionFamily.backdoorIvmBviiI => 1.14,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.18,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.46,
        SmartProgressionFamily.backdoorRecursivePrep => 1.16,
        SmartProgressionFamily.classicalPredominantColor => 1.12,
        SmartProgressionFamily.mixturePivotModulation => 1.04,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 1.12,
        SmartProgressionFamily.coltraneBurst => 1.08,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.34,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.82,
        _ => 1,
      },
      SectionRole.tag => switch (family) {
        SmartProgressionFamily.backdoorIvmBviiI => 1.24,
        SmartProgressionFamily.minorLineCliche => 1.18,
        SmartProgressionFamily.coreIiVIMajor => 1.1,
        SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.28,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 0.36,
        SmartProgressionFamily.backdoorRecursivePrep => 1.24,
        SmartProgressionFamily.classicalPredominantColor => 1.08,
        SmartProgressionFamily.mixturePivotModulation => 0.78,
        SmartProgressionFamily.chromaticMediantCommonToneModulation => 0.64,
        SmartProgressionFamily.coltraneBurst => 0.48,
        SmartProgressionFamily.bridgeReturnHomeCadence => 1.22,
        SmartProgressionFamily.cadenceBasedRealModulation => 0.74,
        _ => 0.96,
      },
    };
  }

  static double _sourceProfileMultiplier(
    SmartProgressionFamily family,
    SourceProfile sourceProfile,
  ) {
    if (sourceProfile == SourceProfile.fakebookStandard) {
      return 1;
    }
    return switch (family) {
      SmartProgressionFamily.closingPlagalAuthenticHybrid => 1.18,
      SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI => 1.12,
      SmartProgressionFamily.backdoorRecursivePrep => 1.18,
      SmartProgressionFamily.classicalPredominantColor => 1.12,
      SmartProgressionFamily.mixturePivotModulation => 1.08,
      SmartProgressionFamily.chromaticMediantCommonToneModulation => 1.1,
      SmartProgressionFamily.coltraneBurst => 1.14,
      SmartProgressionFamily.bridgeReturnHomeCadence => 1.08,
      SmartProgressionFamily.dominantHeadedScopeChain => 1.16,
      SmartProgressionFamily.dominantChainBridgeStyle => 1.18,
      SmartProgressionFamily.backdoorIvmBviiI => 1.2,
      SmartProgressionFamily.minorLineCliche => 1.16,
      SmartProgressionFamily.relativeMinorReframe => 1.12,
      SmartProgressionFamily.turnaroundISharpIdimIiV => 1.14,
      SmartProgressionFamily.passingDimToIi => 1.12,
      SmartProgressionFamily.coreIiVIMajor => 0.92,
      _ => 1,
    };
  }

  static double _scopeAffinityMultiplier({
    required SmartProgressionFamily family,
    required SmartStepRequest request,
  }) {
    final scope = request.currentTrace?.activeLocalScope;
    if (scope == null) {
      return 1;
    }
    var multiplier = 1.0;
    final tightDominantBudget = _dominantIntentOverflow(request) > 0;
    if (scope.center.relationToParent == KeyRelation.relative) {
      if (family == SmartProgressionFamily.relativeMinorReframe) {
        multiplier *= 1.4;
      } else if (family == SmartProgressionFamily.dominantHeadedScopeChain) {
        multiplier *= 1.16;
      } else if (family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation) {
        multiplier *= 0.84;
      }
    }
    if (scope.center.relationToParent == KeyRelation.parallel) {
      if (family == SmartProgressionFamily.mixturePivotModulation) {
        multiplier *= 1.42;
      } else if (family == SmartProgressionFamily.bridgeReturnHomeCadence) {
        multiplier *= 1.16;
      } else if (family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation) {
        multiplier *= 0.88;
      }
    }
    if (scope.center.relationToParent == KeyRelation.subdominant) {
      if (family == SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI) {
        multiplier *= 1.42;
      } else if (family == SmartProgressionFamily.bridgeReturnHomeCadence) {
        multiplier *= 1.12;
      } else if (family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation) {
        multiplier *= 0.82;
      }
    }
    if (scope.headType == ScopeHeadType.tonicHead &&
        family == SmartProgressionFamily.relativeMinorReframe &&
        scope.center.relationToParent == KeyRelation.relative) {
      multiplier *= 1.12;
    }
    if (scope.headType == ScopeHeadType.tonicHead &&
        family == SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI &&
        scope.center.relationToParent == KeyRelation.subdominant) {
      multiplier *= 1.18;
    }
    if (scope.headType == ScopeHeadType.dominantHead) {
      if (family == SmartProgressionFamily.dominantHeadedScopeChain) {
        multiplier *= tightDominantBudget ? 0.92 : 1.34;
      } else if (family ==
          SmartProgressionFamily.appliedDominantWithRelatedIi) {
        multiplier *= tightDominantBudget ? 0.86 : 1.18;
      } else if (family ==
          SmartProgressionFamily.closingPlagalAuthenticHybrid) {
        multiplier *= 1.08;
      } else if (family == SmartProgressionFamily.coreIiVIMajor ||
          family == SmartProgressionFamily.minorIiVAltI ||
          family == SmartProgressionFamily.relativeMinorReframe) {
        multiplier *= tightDominantBudget ? 0.96 : 1.08;
      }
    }
    if (scope.headType == ScopeHeadType.pivotArea) {
      if (family == SmartProgressionFamily.mixturePivotModulation &&
          scope.center.relationToParent == KeyRelation.parallel) {
        multiplier *= 1.28;
      } else if (family == SmartProgressionFamily.bridgeReturnHomeCadence &&
          (scope.center.relationToParent == KeyRelation.parallel ||
              scope.center.relationToParent == KeyRelation.subdominant ||
              scope.center.relationToParent == KeyRelation.dominant)) {
        multiplier *= 1.18;
      } else if (family ==
              SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI &&
          scope.center.relationToParent == KeyRelation.subdominant) {
        multiplier *= 1.28;
      } else if (family == SmartProgressionFamily.commonChordModulation) {
        multiplier *= 1.26;
      } else if (family == SmartProgressionFamily.cadenceBasedRealModulation) {
        multiplier *= 1.12;
      }
    }
    return multiplier;
  }

  static double _debtPressureMultiplier({
    required SmartProgressionFamily family,
    required SmartStepRequest request,
  }) {
    final debts = request.currentTrace?.outstandingDebts ?? const [];
    if (debts.isEmpty) {
      return 1;
    }
    final needsDominantPayoff = debts.any(
      (debt) =>
          debt.debtType == ResolutionDebtType.dominantResolve ||
          debt.debtType == ResolutionDebtType.susResolve ||
          debt.debtType == ResolutionDebtType.predominantToDominant,
    );
    final needsRarePayoff = debts.any(
      (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
    );
    final needsModulationConfirm = debts.any(
      (debt) => debt.debtType == ResolutionDebtType.modulationConfirm,
    );
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final needsReturnHome = returnHomeDebt != null;

    var multiplier = 1.0;
    if (needsDominantPayoff) {
      if (family == SmartProgressionFamily.coreIiVIMajor ||
          family == SmartProgressionFamily.minorIiVAltI ||
          family == SmartProgressionFamily.relativeMinorReframe ||
          family == SmartProgressionFamily.dominantHeadedScopeChain ||
          family == SmartProgressionFamily.closingPlagalAuthenticHybrid ||
          family == SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI ||
          family == SmartProgressionFamily.backdoorRecursivePrep ||
          family == SmartProgressionFamily.backdoorIvmBviiI) {
        multiplier *= 1.18;
      } else if (family == SmartProgressionFamily.turnaroundISharpIdimIiV ||
          family == SmartProgressionFamily.passingDimToIi) {
        multiplier *= 0.78;
      }
    }
    if (needsRarePayoff) {
      if (family == SmartProgressionFamily.coreIiVIMajor ||
          family == SmartProgressionFamily.minorIiVAltI ||
          family == SmartProgressionFamily.relativeMinorReframe ||
          family == SmartProgressionFamily.dominantHeadedScopeChain ||
          family == SmartProgressionFamily.backdoorIvmBviiI) {
        multiplier *= 1.22;
      } else if (family == SmartProgressionFamily.turnaroundISharpIdimIiV ||
          family == SmartProgressionFamily.passingDimToIi) {
        multiplier *= 0.52;
      }
    }
    if (needsModulationConfirm) {
      if (family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation ||
          family == SmartProgressionFamily.mixturePivotModulation ||
          family ==
              SmartProgressionFamily.chromaticMediantCommonToneModulation ||
          family == SmartProgressionFamily.coltraneBurst ||
          family == SmartProgressionFamily.bridgeReturnHomeCadence ||
          family == SmartProgressionFamily.dominantChainBridgeStyle) {
        multiplier *= 0.72;
      } else if (family == SmartProgressionFamily.coreIiVIMajor ||
          family == SmartProgressionFamily.minorIiVAltI ||
          family == SmartProgressionFamily.relativeMinorReframe ||
          family == SmartProgressionFamily.dominantHeadedScopeChain) {
        multiplier *= 1.12;
      }
    }
    if (needsReturnHome) {
      final phraseContext = _phraseContextForRequest(request);
      final bridgeReturnWindow = _isBridgeReturnWindowForDebt(
        phraseContext,
        returnHomeDebt: returnHomeDebt,
      );
      final urgentReturn =
          returnHomeDebt.deadline <= 2 || returnHomeDebt.severity >= 4;
      if (family == SmartProgressionFamily.bridgeReturnHomeCadence) {
        multiplier *= bridgeReturnWindow ? (urgentReturn ? 2.4 : 2.0) : 1.72;
      } else if (family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation ||
          family == SmartProgressionFamily.mixturePivotModulation ||
          family ==
              SmartProgressionFamily.chromaticMediantCommonToneModulation ||
          family == SmartProgressionFamily.coltraneBurst) {
        multiplier *= bridgeReturnWindow ? 0.28 : 0.54;
      } else if (family == SmartProgressionFamily.dominantChainBridgeStyle ||
          family == SmartProgressionFamily.dominantHeadedScopeChain ||
          family == SmartProgressionFamily.appliedDominantWithRelatedIi ||
          family == SmartProgressionFamily.relativeMinorReframe) {
        multiplier *= bridgeReturnWindow ? 0.38 : 0.66;
      } else if (bridgeReturnWindow &&
          (family == SmartProgressionFamily.coreIiVIMajor ||
              family == SmartProgressionFamily.minorIiVAltI ||
              family == SmartProgressionFamily.closingPlagalAuthenticHybrid ||
              family == SmartProgressionFamily.backdoorRecursivePrep ||
              family == SmartProgressionFamily.backdoorIvmBviiI ||
              family == SmartProgressionFamily.classicalPredominantColor)) {
        multiplier *= 0.74;
      }
    }
    return multiplier;
  }

  static SmartStepPlan planInitialStep({
    required Random random,
    required SmartStartRequest request,
  }) {
    final startingCenter = _selectInitialKeyCenter(
      random: random,
      selectedKeyCenters: request.selectedKeyCenters,
      jazzPreset: request.jazzPreset,
      sourceProfile: request.sourceProfile,
    );
    final tonicRoman = startingCenter.mode == KeyMode.major
        ? RomanNumeralId.iMaj69
        : _selectMinorTonic(random, request.sourceProfile);
    final syntheticRequest = SmartStepRequest(
      stepIndex: 0,
      activeKeys: request.activeKeys,
      selectedKeyCenters: request.selectedKeyCenters,
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
      currentTrace: null,
      phraseContext: SmartPhraseContext.rollingForm(0),
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
        phraseContext: SmartPhraseContext.rollingForm(0),
        previousTrace: null,
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
      phraseContext: SmartPhraseContext.rollingForm(0),
      previousTrace: null,
      familyPlan: selectedFamily,
      blockedReason: null,
      decision: 'seeded-initial-family:${_familyTag(selectedFamily.family)}',
    );
  }

  static SmartStepPlan planNextStep({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.plannedQueue.isNotEmpty &&
        !_shouldReleaseQueuedFamily(random: random, request: request)) {
      final queuedDecision = dequeuePlannedSmartChord(
        plannedQueue: request.plannedQueue,
      );
      return _buildPlanFromQueuedChord(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        currentRomanNumeralId: request.currentRomanNumeralId,
        currentHarmonicFunction: request.currentHarmonicFunction,
        phraseContext: _phraseContextForRequest(request),
        previousTrace: request.currentTrace,
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
        phraseContext: _phraseContextForRequest(request),
        previousTrace: request.currentTrace,
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

  static bool _shouldReleaseQueuedFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.plannedQueue.isEmpty || request.currentTrace == null) {
      return false;
    }
    final previousTrace = request.currentTrace!;
    final patternTag = previousTrace.activePatternTag;
    if (patternTag == null) {
      return false;
    }
    final nextQueued = request.plannedQueue.first;
    if (nextQueued.cadentialArrival ||
        nextQueued.modulationKind == ModulationKind.real ||
        nextQueued.openScope != null ||
        nextQueued.closeScope ||
        nextQueued.openedDebts.isNotEmpty) {
      return false;
    }
    if (previousTrace.outstandingDebts.any(
      (debt) => nextQueued.satisfiedDebtTypes.contains(debt.debtType),
    )) {
      return false;
    }
    if (previousTrace.cadentialArrival) {
      return true;
    }
    if (previousTrace.phraseContext.phraseRole != PhraseRole.continuation ||
        _patternStepStreak(patternTag) < 2) {
      return false;
    }
    final queueSensitivePattern =
        patternTag == 'turnaround_i_vi_ii_v' ||
        patternTag == 'dominant_chain_bridge_style' ||
        patternTag == 'dominant_headed_scope_chain' ||
        patternTag == 'applied_dominant_with_related_ii' ||
        patternTag == 'relative_minor_reframe';
    if (!queueSensitivePattern) {
      return false;
    }
    return random.nextDouble() < 0.6;
  }

  static SmartSimulationSummary simulateSteps({
    required Random random,
    required int steps,
    required SmartStartRequest request,
  }) {
    return SmartDiagnosticsStore.runIsolated(() {
      final traces = <SmartDecisionTrace>[];
      final blockedReasonHistogram = <SmartBlockedReason, int>{};

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
                  ((currentChord.smartDebug as SmartDecisionTrace?)
                          ?.stepIndex ??
                      0) +
                  1,
              activeKeys: request.activeKeys,
              selectedKeyCenters: request.selectedKeyCenters,
              currentKeyCenter:
                  currentChord.keyCenter ??
                  MusicTheory.keyCenterFor(currentChord.keyName ?? 'C'),
              currentRomanNumeralId:
                  currentChord.romanNumeralId ?? RomanNumeralId.iMaj7,
              currentResolutionRomanNumeralId:
                  continuationResolutionRomanNumeralId(currentChord),
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
              currentTrace: currentChord.smartDebug as SmartDecisionTrace?,
              phraseContext: SmartPhraseContext.rollingForm(
                ((currentChord.smartDebug as SmartDecisionTrace?)?.stepIndex ??
                        0) +
                    1,
              ),
            ),
          );
        }

        plannedQueue = plan.remainingQueuedChords;
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
        final primaryComparison = compareVoiceLeadingCandidates(
          random: random,
          previousChord: currentChord,
          candidates: [
            SmartRenderCandidate(
              keyCenter: plan.finalKeyCenter,
              romanNumeralId: plan.finalRomanNumeralId,
              plannedChordKind: plan.plannedChordKind,
              renderQualityOverride: plan.renderingPlan.renderQualityOverride,
              patternTag: plan.patternTag,
              appliedType: plan.appliedType,
              resolutionTargetRomanId: plan.resolutionTargetRomanId,
              dominantContext: plan.renderingPlan.dominantContext,
              dominantIntent: plan.renderingPlan.dominantIntent,
              smartDebug: plan.debug,
            ),
          ],
        );
        GeneratedChord? simulatedChord;
        for (final candidate in primaryComparison.rankedCandidates) {
          if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
            simulatedChord = candidate.chord;
            break;
          }
        }

        if (simulatedChord == null) {
          fallbackCount += 1;
          final fallbackComparison = compareVoiceLeadingCandidates(
            random: random,
            previousChord: currentChord,
            candidates: [
              for (final roman in prioritizedFallbackRomans(
                keyMode: plan.finalKeyCenter.mode,
                finalRomanNumeralId: plan.finalRomanNumeralId,
                harmonicFunction: _harmonicFunctionForRoman(
                  romanNumeralId: plan.finalRomanNumeralId,
                  plannedChordKind: plan.plannedChordKind,
                  appliedType: plan.appliedType,
                ),
                patternTag: plan.patternTag,
              ))
                SmartRenderCandidate(
                  keyCenter: plan.finalKeyCenter,
                  romanNumeralId: roman,
                  plannedChordKind: roman == plan.finalRomanNumeralId
                      ? plan.plannedChordKind
                      : PlannedChordKind.resolvedRoman,
                  renderQualityOverride: roman == plan.finalRomanNumeralId
                      ? plan.renderingPlan.renderQualityOverride
                      : null,
                  patternTag: plan.patternTag,
                  dominantContext: roman == plan.finalRomanNumeralId
                      ? plan.renderingPlan.dominantContext
                      : null,
                  dominantIntent: roman == plan.finalRomanNumeralId
                      ? plan.renderingPlan.dominantIntent
                      : null,
                  smartDebug: plan.debug.withDecision(
                    'excluded-fallback-hierarchy',
                    nextBlockedReason: SmartBlockedReason.excludedFallback,
                    nextFallbackOccurred: true,
                  ),
                  wasExcludedFallback: true,
                ),
            ],
          );
          for (final candidate in fallbackComparison.rankedCandidates) {
            if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
              simulatedChord = candidate.chord;
              break;
            }
          }
          simulatedChord ??= compareVoiceLeadingCandidates(
            random: random,
            previousChord: currentChord,
            candidates: [
              SmartRenderCandidate(
                keyCenter:
                    currentChord?.keyCenter ??
                    MusicTheory.keyCenterFor(
                      request.activeKeys.isNotEmpty
                          ? request.activeKeys.first
                          : 'C',
                    ),
                romanNumeralId: currentChord?.keyCenter?.mode == KeyMode.minor
                    ? RomanNumeralId.iMin6
                    : RomanNumeralId.iMaj69,
                plannedChordKind: PlannedChordKind.resolvedRoman,
                smartDebug: plan.debug.withDecision(
                  'excluded-fallback',
                  nextBlockedReason: SmartBlockedReason.excludedFallback,
                  nextFallbackOccurred: true,
                ),
                wasExcludedFallback: true,
              ),
            ],
          ).selected.chord;
        }

        final resolvedChord = simulatedChord;
        final trace = resolvedChord.smartDebug as SmartDecisionTrace?;
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
        }

        currentChord = resolvedChord;
      }

      final familyHistogram = _familyStartHistogram(traces);
      final familyLengthHistogram = _familyLengthHistogram(traces);
      final cadenceHistogram = _cadenceHistogram(traces);
      final tonicizationCount = _countModulationKind(
        traces,
        ModulationKind.tonicization,
      );
      final realModulationCount = _countModulationKind(
        traces,
        ModulationKind.real,
      );
      final modulationRelationHistogram = _modulationRelationHistogram(traces);
      final phraseRoleModulationHistogram = _phraseRoleModulationHistogram(
        traces,
      );
      final relatedIiAppliedCount = _relatedIiAppliedCount(traces);
      final nakedAppliedCount = _nakedAppliedCount(traces);
      final dominantIntentHistogram = _dominantIntentHistogram(traces);
      final susReleaseCount = _susReleaseCount(traces);
      final susResolutionOpportunities = _susResolutionOpportunities(traces);
      final bridgeIvSectionHistogram = _familyStartSectionHistogram(
        traces,
        'bridge_iv_stabilized_by_local_ii_v_i',
      );
      final bridgeIvStabilizationSuccessCount =
          _bridgeIvStabilizationSuccessCount(traces);
      final bridgeIvFallbackCount = _familyFallbackCount(
        traces,
        'bridge_iv_stabilized_by_local_ii_v_i',
      );
      final bridgeReturnSectionHistogram = _familyStartSectionHistogram(
        traces,
        'bridge_return_home_cadence',
      );
      final chromaticMediantStartCount =
          familyHistogram['chromatic_mediant_common_tone_modulation'] ?? 0;
      final chromaticMediantDensity =
          chromaticMediantStartCount / max(1, steps);
      final chromaticMediantPayoffCount = _chromaticMediantPayoffCount(traces);
      final chromaticMediantFailedPayoffCount =
          _chromaticMediantFailedPayoffCount(traces);
      final returnHomeDebtOpenCount = _returnHomeDebtOpenCount(traces);
      final returnHomeDebtPayoffCount = _returnHomeDebtPayoffCount(traces);
      final returnHomeOpportunityCount = _returnHomeOpportunityCount(traces);
      final returnHomeSelectionCount = _returnHomeSelectionCount(traces);
      final v7SurfaceHistogram = _v7SurfaceHistogram(traces);
      final returnHomeMissedOpportunityReasons =
          _returnHomeMissedOpportunityReasons(traces);
      final returnHomeMissedOpportunityFamilies =
          _returnHomeMissedOpportunityFamilies(traces);
      final minorCenterOccupancy = _minorCenterOccupancy(traces, steps);
      final directAppliedToNewTonicViolations =
          _directAppliedToNewTonicViolations(traces);
      final rareColorUsage = _rareColorUsage(traces);
      final rareColorDebtOpenCount = _rareColorDebtOpenCount(traces);
      final rareColorPayoffCount = _rareColorPayoffCount(traces);
      final qaChecks = _qaChecksForSummary(
        jazzPreset: request.jazzPreset,
        steps: steps,
        familyHistogram: familyHistogram,
        realModulationCount: realModulationCount,
        minorCenterOccupancy: minorCenterOccupancy,
        fallbackCount: fallbackCount,
        rareColorUsage: rareColorUsage,
        rareColorDebtOpenCount: rareColorDebtOpenCount,
        rareColorPayoffCount: rareColorPayoffCount,
        susReleaseCount: susReleaseCount,
        susResolutionOpportunities: susResolutionOpportunities,
        chromaticMediantPotentialAvailable:
            request.modalInterchangeEnabled &&
            _hasChromaticMediantPotential(request.activeKeys),
        chromaticMediantStartCount: chromaticMediantStartCount,
        chromaticMediantDensity: chromaticMediantDensity,
        chromaticMediantPayoffCount: chromaticMediantPayoffCount,
        chromaticMediantFailedPayoffCount: chromaticMediantFailedPayoffCount,
        directAppliedToNewTonicViolations: directAppliedToNewTonicViolations,
        returnHomeDebtOpenCount: returnHomeDebtOpenCount,
        returnHomeDebtPayoffCount: returnHomeDebtPayoffCount,
        returnHomeOpportunityCount: returnHomeOpportunityCount,
        returnHomeSelectionCount: returnHomeSelectionCount,
      );

      return SmartSimulationSummary(
        jazzPreset: request.jazzPreset,
        sourceProfile: request.sourceProfile,
        modulationIntensity: request.modulationIntensity,
        steps: steps,
        modulationAttemptCount: modulationAttemptCount,
        modulationSuccessCount: modulationSuccessCount,
        blockedReasonHistogram: blockedReasonHistogram,
        modalBranchCount: modalBranchCount,
        appliedDominantInsertionCount: appliedDominantInsertionCount,
        fallbackCount: fallbackCount,
        familyHistogram: familyHistogram,
        familyLengthHistogram: familyLengthHistogram,
        cadenceHistogram: cadenceHistogram,
        tonicizationCount: tonicizationCount,
        realModulationCount: realModulationCount,
        modulationRelationHistogram: modulationRelationHistogram,
        phraseRoleModulationHistogram: phraseRoleModulationHistogram,
        relatedIiAppliedCount: relatedIiAppliedCount,
        nakedAppliedCount: nakedAppliedCount,
        dominantIntentHistogram: dominantIntentHistogram,
        susReleaseCount: susReleaseCount,
        susResolutionOpportunities: susResolutionOpportunities,
        bridgeIvSectionHistogram: bridgeIvSectionHistogram,
        bridgeIvStabilizationSuccessCount: bridgeIvStabilizationSuccessCount,
        bridgeIvFallbackCount: bridgeIvFallbackCount,
        bridgeReturnSectionHistogram: bridgeReturnSectionHistogram,
        chromaticMediantStartCount: chromaticMediantStartCount,
        chromaticMediantDensity: chromaticMediantDensity,
        chromaticMediantPayoffCount: chromaticMediantPayoffCount,
        chromaticMediantFailedPayoffCount: chromaticMediantFailedPayoffCount,
        returnHomeDebtOpenCount: returnHomeDebtOpenCount,
        returnHomeDebtPayoffCount: returnHomeDebtPayoffCount,
        returnHomeOpportunityCount: returnHomeOpportunityCount,
        returnHomeSelectionCount: returnHomeSelectionCount,
        v7SurfaceHistogram: v7SurfaceHistogram,
        returnHomeMissedOpportunityReasons: returnHomeMissedOpportunityReasons,
        returnHomeMissedOpportunityFamilies:
            returnHomeMissedOpportunityFamilies,
        minorCenterOccupancy: minorCenterOccupancy,
        directAppliedToNewTonicViolations: directAppliedToNewTonicViolations,
        rareColorUsage: rareColorUsage,
        rareColorDebtOpenCount: rareColorDebtOpenCount,
        rareColorPayoffCount: rareColorPayoffCount,
        qaChecks: qaChecks,
        traces: traces,
      );
    });
  }

  static SmartSimulationComparison compareSimulationSummaries({
    required SmartSimulationSummary baseline,
    required SmartSimulationSummary candidate,
  }) {
    final baselineModulationDensity =
        baseline.modulationSuccessCount / max(1, baseline.steps);
    final candidateModulationDensity =
        candidate.modulationSuccessCount / max(1, candidate.steps);
    final baselineCoreRatio = _coreFamilyRatio(baseline.familyHistogram);
    final candidateCoreRatio = _coreFamilyRatio(candidate.familyHistogram);
    final modulationStatus =
        candidateModulationDensity > baselineModulationDensity + 0.004
        ? SmartQaStatus.pass
        : candidateModulationDensity > baselineModulationDensity
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final coreRetentionStatus = candidateCoreRatio >= 0.3
        ? SmartQaStatus.pass
        : candidateCoreRatio >= 0.2
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final minorLiftStatus =
        candidate.minorCenterOccupancy >= baseline.minorCenterOccupancy + 0.03
        ? SmartQaStatus.pass
        : candidate.minorCenterOccupancy >= baseline.minorCenterOccupancy
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    return SmartSimulationComparison(
      baselinePreset: baseline.jazzPreset,
      candidatePreset: candidate.jazzPreset,
      qaChecks: [
        SmartQaCheck(
          id: 'modulation_density_lift',
          status: modulationStatus,
          detail:
              '${baseline.jazzPreset.name}=${baselineModulationDensity.toStringAsFixed(3)}, '
              '${candidate.jazzPreset.name}=${candidateModulationDensity.toStringAsFixed(3)}',
        ),
        SmartQaCheck(
          id: 'core_family_retention',
          status: coreRetentionStatus,
          detail:
              '${baseline.jazzPreset.name}=${baselineCoreRatio.toStringAsFixed(3)}, '
              '${candidate.jazzPreset.name}=${candidateCoreRatio.toStringAsFixed(3)}',
        ),
        SmartQaCheck(
          id: 'minor_center_lift',
          status: minorLiftStatus,
          detail:
              '${baseline.jazzPreset.name}=${baseline.minorCenterOccupancy.toStringAsFixed(3)}, '
              '${candidate.jazzPreset.name}=${candidate.minorCenterOccupancy.toStringAsFixed(3)}',
        ),
      ],
    );
  }

  static List<SmartQaCheck> _qaChecksForSummary({
    required JazzPreset jazzPreset,
    required int steps,
    required Map<String, int> familyHistogram,
    required int realModulationCount,
    required double minorCenterOccupancy,
    required int fallbackCount,
    required Map<String, int> rareColorUsage,
    required int rareColorDebtOpenCount,
    required int rareColorPayoffCount,
    required int susReleaseCount,
    required int susResolutionOpportunities,
    required bool chromaticMediantPotentialAvailable,
    required int chromaticMediantStartCount,
    required double chromaticMediantDensity,
    required int chromaticMediantPayoffCount,
    required int chromaticMediantFailedPayoffCount,
    required int directAppliedToNewTonicViolations,
    required int returnHomeDebtOpenCount,
    required int returnHomeDebtPayoffCount,
    required int returnHomeOpportunityCount,
    required int returnHomeSelectionCount,
  }) {
    final coreFamilyRatio = _coreFamilyRatio(familyHistogram);
    final coreStatus = switch (jazzPreset) {
      JazzPreset.standardsCore =>
        coreFamilyRatio >= 0.45
            ? SmartQaStatus.pass
            : coreFamilyRatio >= 0.32
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.modulationStudy =>
        coreFamilyRatio >= 0.28
            ? SmartQaStatus.pass
            : coreFamilyRatio >= 0.18
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.advanced =>
        coreFamilyRatio >= 0.3
            ? SmartQaStatus.pass
            : coreFamilyRatio >= 0.2
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
    };
    final modulationDensity = realModulationCount / max(1, steps);
    final modulationStatus = switch (jazzPreset) {
      JazzPreset.standardsCore =>
        modulationDensity <= 0.03
            ? SmartQaStatus.pass
            : modulationDensity <= 0.05
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.modulationStudy =>
        modulationDensity >= 0.015
            ? SmartQaStatus.pass
            : modulationDensity >= 0.008
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.advanced =>
        modulationDensity >= 0.01
            ? SmartQaStatus.pass
            : modulationDensity >= 0.005
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
    };
    final minorStatus = switch (jazzPreset) {
      JazzPreset.standardsCore =>
        minorCenterOccupancy >= 0.08
            ? SmartQaStatus.pass
            : minorCenterOccupancy >= 0.04
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.modulationStudy =>
        minorCenterOccupancy >= 0.18
            ? SmartQaStatus.pass
            : minorCenterOccupancy >= 0.1
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
      JazzPreset.advanced =>
        minorCenterOccupancy >= 0.1
            ? SmartQaStatus.pass
            : minorCenterOccupancy >= 0.05
            ? SmartQaStatus.warn
            : SmartQaStatus.fail,
    };
    final fallbackRatio = fallbackCount / max(1, steps);
    final fallbackStatus = fallbackRatio <= 0.12
        ? SmartQaStatus.pass
        : fallbackRatio <= 0.2
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final rareColorEvents = rareColorUsage.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );
    final rarePayoffRatio = rareColorDebtOpenCount == 0
        ? 1.0
        : rareColorPayoffCount / rareColorDebtOpenCount;
    final rareStatus = rarePayoffRatio >= 0.65
        ? SmartQaStatus.pass
        : rarePayoffRatio >= 0.45
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final susRatio = susResolutionOpportunities == 0
        ? 1.0
        : susReleaseCount / susResolutionOpportunities;
    final susStatus = susRatio >= 0.4
        ? SmartQaStatus.pass
        : susRatio >= 0.2
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final chromaticMediantPayoffRatio = chromaticMediantStartCount == 0
        ? 1.0
        : chromaticMediantPayoffCount / chromaticMediantStartCount;
    final chromaticMediantStatus =
        !chromaticMediantPotentialAvailable || jazzPreset != JazzPreset.advanced
        ? SmartQaStatus.pass
        : chromaticMediantFailedPayoffCount > 0
        ? SmartQaStatus.fail
        : chromaticMediantStartCount >= 2 &&
              chromaticMediantPayoffRatio >= 0.75 &&
              chromaticMediantDensity >= 0.001
        ? SmartQaStatus.pass
        : chromaticMediantStartCount > 0 && chromaticMediantPayoffRatio >= 0.5
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    final returnHomePayoffRatio = returnHomeDebtOpenCount == 0
        ? 1.0
        : returnHomeDebtPayoffCount / returnHomeDebtOpenCount;
    final returnHomeStartRatio = returnHomeOpportunityCount == 0
        ? 1.0
        : returnHomeSelectionCount / returnHomeOpportunityCount;
    final returnHomeStatus = returnHomeOpportunityCount == 0
        ? SmartQaStatus.pass
        : returnHomeStartRatio >= 0.55 || returnHomePayoffRatio >= 0.5
        ? SmartQaStatus.pass
        : returnHomeStartRatio >= 0.3 || returnHomePayoffRatio >= 0.25
        ? SmartQaStatus.warn
        : SmartQaStatus.fail;
    return [
      SmartQaCheck(
        id: 'core_family_balance',
        status: coreStatus,
        detail: 'coreRatio=${coreFamilyRatio.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'modulation_density',
        status: modulationStatus,
        detail: 'realModPerStep=${modulationDensity.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'minor_center_support',
        status: minorStatus,
        detail: 'minorOccupancy=${minorCenterOccupancy.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'fallback_pressure',
        status: fallbackStatus,
        detail: 'fallbackPerStep=${fallbackRatio.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'rare_color_payoff',
        status: rareStatus,
        detail: rareColorDebtOpenCount == 0
            ? 'no rare colors observed'
            : 'payoffRatio=${rarePayoffRatio.toStringAsFixed(3)} '
                  'payoff=$rareColorPayoffCount/$rareColorDebtOpenCount '
                  'usage=$rareColorEvents',
      ),
      SmartQaCheck(
        id: 'sus_release_followthrough',
        status: susStatus,
        detail: susResolutionOpportunities == 0
            ? 'no sus opportunities observed'
            : 'releaseRatio=${susRatio.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'chromatic_mediant_followthrough',
        status: chromaticMediantStatus,
        detail:
            !chromaticMediantPotentialAvailable ||
                jazzPreset != JazzPreset.advanced
            ? 'family unavailable for current preset/key set'
            : 'density=${chromaticMediantDensity.toStringAsFixed(3)}, '
                  'payoff=$chromaticMediantPayoffCount/$chromaticMediantStartCount, '
                  'failed=$chromaticMediantFailedPayoffCount',
      ),
      SmartQaCheck(
        id: 'bridge_return_followthrough',
        status: returnHomeStatus,
        detail: returnHomeOpportunityCount == 0
            ? 'no return-home debts observed'
            : 'startRatio=${returnHomeStartRatio.toStringAsFixed(3)}, '
                  'payoffRatio=${returnHomePayoffRatio.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'direct_applied_jump_guard',
        status: directAppliedToNewTonicViolations == 0
            ? SmartQaStatus.pass
            : SmartQaStatus.fail,
        detail: 'violations=$directAppliedToNewTonicViolations',
      ),
    ];
  }

  static double _coreFamilyRatio(Map<String, int> familyHistogram) {
    final totalStarts = familyHistogram.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );
    if (totalStarts == 0) {
      return 0;
    }
    final coreStarts =
        (familyHistogram['core_ii_v_i_major'] ?? 0) +
        (familyHistogram['turnaround_i_vi_ii_v'] ?? 0) +
        (familyHistogram['minor_ii_halfdim_v_alt_i'] ?? 0);
    return coreStarts / totalStarts;
  }

  static Map<String, int> _familyStartHistogram(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      final isFamilyStart =
          trace.decision?.startsWith('seeded-family:') == true ||
          trace.decision?.startsWith('seeded-initial-family:') == true ||
          trace.decision == 'resolved-applied-via-real-modulation';
      if (!isFamilyStart || trace.activePatternTag == null) {
        continue;
      }
      histogram.update(
        trace.activePatternTag!,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return histogram;
  }

  static Map<int, int> _familyLengthHistogram(List<SmartDecisionTrace> traces) {
    final histogram = <int, int>{};
    for (final trace in traces) {
      final isFamilyStart =
          trace.decision?.startsWith('seeded-family:') == true ||
          trace.decision?.startsWith('seeded-initial-family:') == true ||
          trace.decision == 'resolved-applied-via-real-modulation';
      if (!isFamilyStart) {
        continue;
      }
      final length = trace.queuedPatternLength + 1;
      histogram.update(length, (value) => value + 1, ifAbsent: () => 1);
    }
    return histogram;
  }

  static Map<String, int> _familyStartSectionHistogram(
    List<SmartDecisionTrace> traces,
    String familyTag,
  ) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      final isFamilyStart =
          trace.decision?.startsWith('seeded-family:') == true ||
          trace.decision?.startsWith('seeded-initial-family:') == true ||
          trace.decision == 'resolved-applied-via-real-modulation';
      if (!isFamilyStart || trace.activePatternTag != familyTag) {
        continue;
      }
      histogram.update(
        trace.phraseContext.sectionRole.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return histogram;
  }

  static Map<String, int> _cadenceHistogram(List<SmartDecisionTrace> traces) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      if (!trace.cadentialArrival) {
        continue;
      }
      final cadenceType = switch (trace.activePatternTag) {
        'backdoor_ivm_bVII_I' =>
          trace.selectedVariant == 'hybrid_authentic'
              ? 'hybrid_backdoor_authentic'
              : 'backdoor',
        'backdoor_recursive_prep' => 'recursive_backdoor',
        'classical_predominant_color' =>
          trace.selectedVariant == 'aug6_inspired_predominant'
              ? 'aug6_predominant_authentic'
              : 'neapolitan_predominant_authentic',
        'mixture_pivot_modulation' => 'mixture_pivot_authentic',
        'chromatic_mediant_common_tone_modulation' =>
          'chromatic_mediant_authentic',
        'coltrane_burst' => 'coltrane_burst_authentic',
        'bridge_return_home_cadence' => 'bridge_return_home',
        'closing_plagal_authentic_hybrid' =>
          trace.finalKeyMode == KeyMode.minor
              ? 'minor_plagal_authentic_hybrid'
              : trace.selectedVariant?.startsWith('borrowed_') ?? false
              ? 'borrowed_plagal_authentic_hybrid'
              : 'plagal_authentic_hybrid',
        'bridge_iv_stabilized_by_local_ii_v_i' => 'bridge_local_iv_cadence',
        'dominant_headed_scope_chain' => 'dominant_headed_scope_release',
        'relative_minor_reframe' =>
          trace.selectedVariant == 'major_to_relative_minor'
              ? 'relative_minor_reframe'
              : 'relative_major_reframe',
        'cadence_based_real_modulation' => 'modulation_authentic',
        'common_chord_modulation' => 'pivot_modulation_authentic',
        _ =>
          trace.finalKeyMode == KeyMode.minor
              ? 'minor_authentic'
              : 'major_authentic',
      };
      histogram.update(cadenceType, (value) => value + 1, ifAbsent: () => 1);
    }
    return histogram;
  }

  static int _familyFallbackCount(
    List<SmartDecisionTrace> traces,
    String familyTag,
  ) {
    return traces
        .where(
          (trace) =>
              trace.activePatternTag == familyTag && trace.fallbackOccurred,
        )
        .length;
  }

  static int _countModulationKind(
    List<SmartDecisionTrace> traces,
    ModulationKind modulationKind,
  ) {
    return traces
        .where((trace) => trace.modulationKind == modulationKind)
        .length;
  }

  static Map<String, int> _modulationRelationHistogram(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      if (trace.modulationKind != ModulationKind.real ||
          trace.finalKeyRelation == null) {
        continue;
      }
      histogram.update(
        trace.finalKeyRelation!.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return histogram;
  }

  static Map<String, int> _phraseRoleModulationHistogram(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      if (trace.modulationKind != ModulationKind.real) {
        continue;
      }
      histogram.update(
        trace.phraseContext.phraseRole.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return histogram;
  }

  static int _relatedIiAppliedCount(List<SmartDecisionTrace> traces) {
    return traces
        .where(
          (trace) =>
              trace.activePatternTag == 'applied_dominant_with_related_ii' &&
              trace.selectedAppliedApproach != null,
        )
        .length;
  }

  static int _nakedAppliedCount(List<SmartDecisionTrace> traces) {
    return traces
        .where(
          (trace) =>
              trace.selectedAppliedApproach != null &&
              trace.activePatternTag != 'applied_dominant_with_related_ii',
        )
        .length;
  }

  static Map<String, int> _dominantIntentHistogram(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (final trace in traces) {
      if (trace.dominantIntent == null) {
        continue;
      }
      histogram.update(
        trace.dominantIntent!.name,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return histogram;
  }

  static int _susResolutionOpportunities(List<SmartDecisionTrace> traces) {
    return traces
        .where((trace) => trace.dominantIntent == DominantIntent.susDelay)
        .length;
  }

  static int _susReleaseCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 0; index < traces.length - 1; index += 1) {
      final current = traces[index];
      final next = traces[index + 1];
      if (current.dominantIntent != DominantIntent.susDelay) {
        continue;
      }
      if (current.finalRoot == null ||
          current.finalRoot != next.finalRoot ||
          next.finalRenderQuality == null) {
        continue;
      }
      if (next.finalRenderQuality != ChordQuality.dominant13sus4 &&
          next.finalRenderQuality != ChordQuality.dominant7sus4) {
        count += 1;
      }
    }
    return count;
  }

  static int _bridgeIvStabilizationSuccessCount(
    List<SmartDecisionTrace> traces,
  ) {
    return traces
        .where(
          (trace) =>
              trace.activePatternTag ==
                  'bridge_iv_stabilized_by_local_ii_v_i' &&
              trace.cadentialArrival &&
              trace.modulationKind == ModulationKind.tonicization &&
              trace.activeLocalScope?.center.relationToParent ==
                  KeyRelation.subdominant &&
              trace.activeLocalScope?.headType == ScopeHeadType.tonicHead &&
              trace.surfaceTags.contains('localIVStabilized'),
        )
        .length;
  }

  static double _minorCenterOccupancy(
    List<SmartDecisionTrace> traces,
    int steps,
  ) {
    if (steps == 0) {
      return 0;
    }
    final minorSteps = traces
        .where((trace) => trace.finalKeyMode == KeyMode.minor)
        .length;
    return minorSteps / steps;
  }

  static bool _isTonicRoman(RomanNumeralId? romanNumeralId) {
    return romanNumeralId == RomanNumeralId.iMaj69 ||
        romanNumeralId == RomanNumeralId.iMaj7 ||
        romanNumeralId == RomanNumeralId.iMin6 ||
        romanNumeralId == RomanNumeralId.iMin7 ||
        romanNumeralId == RomanNumeralId.iMinMaj7;
  }

  static int _directAppliedToNewTonicViolations(
    List<SmartDecisionTrace> traces,
  ) {
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      if (previous.selectedAppliedApproach == null ||
          current.modulationKind != ModulationKind.real ||
          !_isTonicRoman(current.finalRomanNumeralId) ||
          current.activePatternTag == 'cadence_based_real_modulation' ||
          current.activePatternTag == 'common_chord_modulation') {
        continue;
      }
      count += 1;
    }
    return count;
  }

  static Map<String, int> _rareColorUsage(List<SmartDecisionTrace> traces) {
    const rareTags = {
      'rareColor',
      'commonToneDim',
      'neapolitanPredominant',
      'aug6Predominant',
      'chromaticMediant',
    };
    final histogram = <String, int>{};
    for (final trace in traces) {
      for (final tag in trace.surfaceTags) {
        if (!rareTags.contains(tag)) {
          continue;
        }
        histogram.update(tag, (value) => value + 1, ifAbsent: () => 1);
      }
    }
    return histogram;
  }

  static int _rareColorDebtOpenCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    var previousHadRareDebt = false;
    for (final trace in traces) {
      final hasRareDebt = trace.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      if (hasRareDebt && !previousHadRareDebt) {
        count += 1;
      }
      previousHadRareDebt = hasRareDebt;
    }
    return count;
  }

  static bool _hasChromaticMediantPotential(List<String> activeKeys) {
    final semitones = <int>{};
    for (final key in activeKeys) {
      final semitone = MusicTheory.keyTonicSemitone(key);
      if (semitone != null) {
        semitones.add(semitone);
      }
    }
    final values = semitones.toList();
    for (var index = 0; index < values.length; index += 1) {
      for (var other = index + 1; other < values.length; other += 1) {
        final distance = (values[other] - values[index]).abs() % 12;
        final interval = distance > 6 ? 12 - distance : distance;
        if (interval == 3 || interval == 4) {
          return true;
        }
      }
    }
    return false;
  }

  static int _rareColorPayoffCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      final hadRareDebt = previous.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      final hasRareDebt = current.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      if (hadRareDebt && !hasRareDebt) {
        count += 1;
      }
    }
    return count;
  }

  static int _chromaticMediantPayoffCount(List<SmartDecisionTrace> traces) {
    const familyTag = 'chromatic_mediant_common_tone_modulation';
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      final hadRareDebt = previous.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      final hasRareDebt = current.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      if (previous.activePatternTag == familyTag &&
          current.activePatternTag == familyTag &&
          hadRareDebt &&
          !hasRareDebt) {
        count += 1;
      }
    }
    return count;
  }

  static int _chromaticMediantFailedPayoffCount(
    List<SmartDecisionTrace> traces,
  ) {
    const familyTag = 'chromatic_mediant_common_tone_modulation';
    var count = 0;
    for (var index = 0; index < traces.length; index += 1) {
      final trace = traces[index];
      final isFamilyStart =
          trace.decision?.startsWith('seeded-family:') == true ||
          trace.decision?.startsWith('seeded-initial-family:') == true;
      final opensRareDebt = trace.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
      );
      if (!isFamilyStart ||
          trace.activePatternTag != familyTag ||
          !opensRareDebt) {
        continue;
      }
      var resolvedInsideFamily = false;
      var exitedFamily = false;
      for (
        var lookahead = index + 1;
        lookahead < traces.length;
        lookahead += 1
      ) {
        final candidate = traces[lookahead];
        final hasRareDebt = candidate.outstandingDebts.any(
          (debt) => debt.debtType == ResolutionDebtType.rareColorPayoff,
        );
        if (candidate.activePatternTag != familyTag) {
          exitedFamily = true;
          break;
        }
        if (!hasRareDebt) {
          resolvedInsideFamily = true;
          break;
        }
      }
      if (!resolvedInsideFamily && exitedFamily) {
        count += 1;
      }
    }
    return count;
  }

  static int _returnHomeDebtOpenCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 0; index < traces.length; index += 1) {
      final current = traces[index];
      final previous = index == 0 ? null : traces[index - 1];
      final hadReturnHomeDebt =
          previous?.outstandingDebts.any(
            (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
          ) ??
          false;
      final hasReturnHomeDebt = current.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
      );
      if (!hadReturnHomeDebt && hasReturnHomeDebt) {
        count += 1;
      }
    }
    return count;
  }

  static int _returnHomeOpportunityCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      if (_isReturnHomeOpportunity(previous: previous, current: current)) {
        count += 1;
      }
    }
    return count;
  }

  static int _returnHomeSelectionCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      if (_isReturnHomeOpportunity(previous: previous, current: current) &&
          current.activePatternTag == 'bridge_return_home_cadence') {
        count += 1;
      }
    }
    return count;
  }

  static int _returnHomeDebtPayoffCount(List<SmartDecisionTrace> traces) {
    var count = 0;
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      final hadReturnHomeDebt = previous.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
      );
      final hasReturnHomeDebt = current.outstandingDebts.any(
        (debt) => debt.debtType == ResolutionDebtType.returnHomeCadence,
      );
      if (hadReturnHomeDebt &&
          !hasReturnHomeDebt &&
          current.activePatternTag == 'bridge_return_home_cadence') {
        count += 1;
      }
    }
    return count;
  }

  static Map<String, int> _v7SurfaceHistogram(List<SmartDecisionTrace> traces) {
    final histogram = <String, int>{};
    for (var index = 0; index < traces.length; index += 1) {
      final bucket = _classifyV7SurfacePath(traces, index);
      if (bucket == null) {
        continue;
      }
      histogram.update(bucket, (value) => value + 1, ifAbsent: () => 1);
    }
    return histogram;
  }

  static String? _classifyV7SurfacePath(
    List<SmartDecisionTrace> traces,
    int index,
  ) {
    final trace = traces[index];
    if (trace.finalRomanNumeralId != RomanNumeralId.vDom7) {
      return null;
    }
    final patternTag = trace.activePatternTag;
    if (patternTag == 'bridge_return_home_cadence') {
      return 'bridge_return_cadence';
    }
    if (patternTag == 'dominant_chain_bridge_style' ||
        patternTag == 'dominant_headed_scope_chain') {
      return 'dominant_chain_or_scope';
    }
    final next = index + 1 < traces.length ? traces[index + 1] : null;
    if (next != null &&
        next.activePatternTag == patternTag &&
        next.cadentialArrival) {
      return 'cadential_final_v';
    }
    return 'preparatory_or_extra_v';
  }

  static Map<String, int> _returnHomeMissedOpportunityReasons(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (var index = 1; index < traces.length; index += 1) {
      final reason = _classifyReturnHomeMissedOpportunity(
        previous: traces[index - 1],
        current: traces[index],
      );
      if (reason == null) {
        continue;
      }
      histogram.update(reason, (value) => value + 1, ifAbsent: () => 1);
    }
    return histogram;
  }

  static Map<String, int> _returnHomeMissedOpportunityFamilies(
    List<SmartDecisionTrace> traces,
  ) {
    final histogram = <String, int>{};
    for (var index = 1; index < traces.length; index += 1) {
      final previous = traces[index - 1];
      final current = traces[index];
      if (!_isReturnHomeOpportunity(previous: previous, current: current) ||
          current.activePatternTag == 'bridge_return_home_cadence') {
        continue;
      }
      final familyTag = current.activePatternTag ?? '(none)';
      histogram.update(familyTag, (value) => value + 1, ifAbsent: () => 1);
    }
    return histogram;
  }

  static String? _classifyReturnHomeMissedOpportunity({
    required SmartDecisionTrace previous,
    required SmartDecisionTrace current,
  }) {
    if (!_isReturnHomeOpportunity(previous: previous, current: current) ||
        current.activePatternTag == 'bridge_return_home_cadence') {
      return null;
    }
    if (previous.postModulationConfirmationsRemaining > 0) {
      return 'post_modulation_confirmation';
    }
    final patternTag = current.activePatternTag;
    if (patternTag == 'dominant_chain_bridge_style' ||
        patternTag == 'dominant_headed_scope_chain' ||
        patternTag == 'applied_dominant_with_related_ii' ||
        patternTag == 'relative_minor_reframe') {
      return 'dominant_family_selected';
    }
    if (current.modulationKind == ModulationKind.real) {
      return 'competing_modulation_family';
    }
    return 'other_family_selected';
  }

  static bool _isReturnHomeOpportunity({
    required SmartDecisionTrace previous,
    required SmartDecisionTrace current,
  }) {
    final debt = previous.outstandingDebts.firstWhere(
      (candidate) => candidate.debtType == ResolutionDebtType.returnHomeCadence,
      orElse: () => const ResolutionDebt(
        debtType: ResolutionDebtType.returnHomeCadence,
        targetLabel: '',
        deadline: 0,
        severity: 0,
      ),
    );
    final familyStart =
        current.decision?.startsWith('seeded-family:') == true ||
        current.decision?.startsWith('seeded-initial-family:') == true ||
        current.decision == 'resolved-applied-via-real-modulation';
    return familyStart &&
        debt.targetLabel.isNotEmpty &&
        debt.targetLabel != current.currentKeyCenter &&
        _isBridgeReturnWindowForDebt(
          current.phraseContext,
          returnHomeDebt: debt,
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
    final phraseContext = _phraseContextForRequest(request);
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
          phraseContext: phraseContext,
          previousTrace: request.currentTrace,
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
      phraseContext: phraseContext,
      homeCenterLabel: _homeCenterLabelForStep(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        previousTrace: request.currentTrace,
      ),
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
      modulationConfidence: 0.42,
      finalKeyCenter: request.currentKeyCenter.displayName,
      finalKeyMode: request.currentKeyCenter.mode,
      finalKeyRelation: KeyRelation.same,
      finalRomanNumeralId: targetRoman,
      decision: 'resolved-dangling-applied',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      finalSourceKind: MusicTheory.specFor(targetRoman).sourceKind,
      dominantContext: targetMode == KeyMode.minor
          ? DominantContext.secondaryToMinor
          : DominantContext.secondaryToMajor,
      dominantIntent: targetMode == KeyMode.minor
          ? DominantIntent.secondaryToMinor
          : DominantIntent.secondaryToMajor,
      modulationKind: ModulationKind.tonicization,
      activeLocalScope: _decayScope(request.currentTrace?.activeLocalScope),
      outstandingDebts: _decayDebts(
        request.currentTrace?.outstandingDebts ?? const <ResolutionDebt>[],
      ),
      surfaceTags: const ['appliedResolution'],
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
        dominantIntent: targetMode == KeyMode.minor
            ? DominantIntent.secondaryToMinor
            : DominantIntent.secondaryToMajor,
      ),
      debug: trace,
      modulationKind: ModulationKind.tonicization,
      cadentialArrival: false,
      modulationAttempt: opportunity.candidates.isNotEmpty,
      phraseContext: phraseContext,
    );
  }

  static SmartStepPlan _resolveDanglingModalChord({
    required SmartStepRequest request,
  }) {
    final phraseContext = _phraseContextForRequest(request);
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
      phraseContext: phraseContext,
      homeCenterLabel: _homeCenterLabelForStep(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        previousTrace: request.currentTrace,
      ),
      selectedDiatonicDestination: exitSelection,
      modalInterchangeCandidates: [request.currentRomanNumeralId],
      selectedModalInterchange: request.currentRomanNumeralId,
      finalKeyCenter: request.currentKeyCenter.displayName,
      finalKeyMode: request.currentKeyCenter.mode,
      finalKeyRelation: KeyRelation.same,
      finalRomanNumeralId: exitSelection,
      decision: 'resolved-dangling-modal',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      finalSourceKind: MusicTheory.specFor(exitSelection).sourceKind,
      cadentialArrival: exitSelection == RomanNumeralId.iMaj69,
      activeLocalScope: _decayScope(request.currentTrace?.activeLocalScope),
      outstandingDebts: _decayDebts(
        request.currentTrace?.outstandingDebts ?? const <ResolutionDebt>[],
      ),
      surfaceTags: const ['backdoorFlavor'],
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
      phraseContext: phraseContext,
    );
  }

  static SmartStepPlan _planFromFamily({
    required int stepIndex,
    required KeyCenter currentKeyCenter,
    required RomanNumeralId currentRomanNumeralId,
    required HarmonicFunction currentHarmonicFunction,
    required SmartPhraseContext phraseContext,
    required SmartDecisionTrace? previousTrace,
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
      phraseContext: phraseContext,
      previousTrace: previousTrace,
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
    required SmartPhraseContext phraseContext,
    required SmartDecisionTrace? previousTrace,
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
    final activeScope = _nextLocalScope(
      previousScope: previousTrace?.activeLocalScope,
      queuedChord: queuedDecision.queuedChord,
    );
    final debts = _nextOutstandingDebts(
      previousDebts:
          previousTrace?.outstandingDebts ?? const <ResolutionDebt>[],
      queuedChord: queuedDecision.queuedChord,
    );
    final trace = SmartDecisionTrace(
      stepIndex: stepIndex,
      currentKeyCenter: currentKeyCenter.displayName,
      currentRomanNumeralId: currentRomanNumeralId,
      currentHarmonicFunction: currentHarmonicFunction,
      phraseContext: phraseContext,
      homeCenterLabel: _homeCenterLabelForStep(
        stepIndex: stepIndex,
        currentKeyCenter: currentKeyCenter,
        previousTrace: previousTrace,
      ),
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
      modulationConfidence: queuedDecision.queuedChord.modulationConfidence,
      finalKeyCenter: queuedDecision.queuedChord.keyCenter.displayName,
      finalKeyMode: queuedDecision.queuedChord.keyCenter.mode,
      finalKeyRelation: queuedDecision.queuedChord.keyCenter.relationToParent,
      finalRomanNumeralId: queuedRoman,
      decision: decision,
      activePatternTag: queuedDecision.queuedChord.patternTag,
      selectedVariant: queuedDecision.queuedChord.variantTag,
      queuedPatternLength: queuedDecision.remainingQueuedChords.length,
      returnedToNormalFlow: queuedDecision.returnedToNormalFlow,
      plannedChordKind: queuedDecision.queuedChord.plannedChordKind,
      finalSourceKind: queuedSourceKind,
      dominantContext: queuedDecision.queuedChord.dominantContext,
      dominantIntent: queuedDecision.queuedChord.dominantIntent,
      modulationKind: queuedDecision.queuedChord.modulationKind,
      cadentialArrival: queuedDecision.queuedChord.cadentialArrival,
      activeLocalScope: activeScope,
      outstandingDebts: debts,
      surfaceTags: queuedDecision.queuedChord.surfaceTags,
      postModulationConfirmationsRemaining:
          queuedDecision.queuedChord.postModulationConfirmationsRemaining,
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
        renderQualityOverride: queuedDecision.queuedChord.renderQualityOverride,
        suppressTensions: queuedDecision.queuedChord.suppressTensions,
        dominantContext: queuedDecision.queuedChord.dominantContext,
        dominantIntent: queuedDecision.queuedChord.dominantIntent,
      ),
      debug: trace,
      modulationKind: queuedDecision.queuedChord.modulationKind,
      cadentialArrival: queuedDecision.queuedChord.cadentialArrival,
      modulationAttempt: queuedDecision.queuedChord.modulationAttempt,
      phraseContext: phraseContext,
    );
  }

  static SmartStepPlan _planFallbackContinuation({
    required Random random,
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
  }) {
    final phraseContext = _phraseContextForRequest(request);
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
      phraseContext: phraseContext,
      homeCenterLabel: _homeCenterLabelForStep(
        stepIndex: request.stepIndex,
        currentKeyCenter: request.currentKeyCenter,
        previousTrace: request.currentTrace,
      ),
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
      dominantIntent: approachDecision.appliedType == AppliedType.substitute
          ? DominantIntent.tritoneSub
          : approachDecision.dominantContext == DominantContext.secondaryToMinor
          ? DominantIntent.secondaryToMinor
          : approachDecision.dominantContext == DominantContext.dominantIILydian
          ? DominantIntent.lydianDominant
          : approachDecision.dominantContext == DominantContext.secondaryToMajor
          ? DominantIntent.secondaryToMajor
          : null,
      modulationKind: approachDecision.insertedApproach
          ? ModulationKind.tonicization
          : ModulationKind.none,
      activeLocalScope: _decayScope(request.currentTrace?.activeLocalScope),
      outstandingDebts: _decayDebts(
        request.currentTrace?.outstandingDebts ?? const <ResolutionDebt>[],
      ),
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
        dominantIntent: approachDecision.appliedType == AppliedType.substitute
            ? DominantIntent.tritoneSub
            : approachDecision.dominantContext ==
                  DominantContext.secondaryToMinor
            ? DominantIntent.secondaryToMinor
            : approachDecision.dominantContext ==
                  DominantContext.dominantIILydian
            ? DominantIntent.lydianDominant
            : approachDecision.dominantContext ==
                  DominantContext.secondaryToMajor
            ? DominantIntent.secondaryToMajor
            : null,
      ),
      debug: trace,
      modulationKind: approachDecision.insertedApproach
          ? ModulationKind.tonicization
          : ModulationKind.none,
      cadentialArrival: false,
      modulationAttempt: false,
      phraseContext: phraseContext,
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
    final phraseContext = _phraseContextForRequest(request);
    final dominantOverflow = _dominantIntentOverflow(request, take: 6);
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final bridgeReturnWindow = _isBridgeReturnWindowForDebt(
      phraseContext,
      returnHomeDebt: returnHomeDebt,
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

    var substituteThreshold = request.activeKeys.length <= 1 ? 8 : 12;
    if (dominantOverflow > 0) {
      substituteThreshold -= 3;
    }
    if (dominantOverflow >= 3) {
      substituteThreshold -= 2;
    }
    if (returnHomeDebt != null || bridgeReturnWindow) {
      substituteThreshold -= 3;
    }
    substituteThreshold = substituteThreshold.clamp(2, 12);
    final useSubstitute =
        request.substituteDominantEnabled &&
        substituteDominant != null &&
        random.nextInt(100) < substituteThreshold;
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
      final recentTonicizations = _recentPlanningTraces(take: 8)
          .where((trace) => trace.modulationKind == ModulationKind.tonicization)
          .length;
      var threshold = targetMode == KeyMode.minor ? 30 : 18;
      if (request.activeKeys.length <= 1) {
        threshold -= 6;
      }
      if (recentTonicizations >= 2) {
        threshold -= 4;
      }
      if (dominantOverflow > 0) {
        threshold -= 6;
      }
      if (dominantOverflow >= 3) {
        threshold -= 4;
      }
      if (returnHomeDebt != null || bridgeReturnWindow) {
        threshold -= 4;
      }
      if (_isNearCadentialBoundary(phraseContext) &&
          destinationRomanNumeralId == RomanNumeralId.vDom7) {
        threshold -= 3;
      }
      threshold = threshold.clamp(4, 30);
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
        plans.add(
          _compactFamilyPlanForContext(
            random: random,
            request: request,
            familyPlan: built,
          ),
        );
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
    final totalWeight = familyPlans.fold<int>(0, (sum, plan) {
      final baseWeight = (weightByFamily[plan.family] ?? 1).toDouble();
      final adjustedWeight = max(
        1,
        (baseWeight *
                _familySelectionQueueMultiplier(
                  familyPlan: plan,
                  request: request,
                ))
            .round(),
      );
      return sum + adjustedWeight;
    });
    var remaining = random.nextInt(totalWeight);
    for (final plan in familyPlans) {
      final baseWeight = (weightByFamily[plan.family] ?? 1).toDouble();
      final weight = max(
        1,
        (baseWeight *
                _familySelectionQueueMultiplier(
                  familyPlan: plan,
                  request: request,
                ))
            .round(),
      );
      if (remaining < weight) {
        return plan;
      }
      remaining -= weight;
    }
    return familyPlans.last;
  }

  static List<RomanNumeralId> prioritizedFallbackRomans({
    required KeyMode keyMode,
    required RomanNumeralId finalRomanNumeralId,
    required HarmonicFunction harmonicFunction,
    String? patternTag,
  }) {
    final familyCandidates = switch (patternTag) {
      'core_ii_v_i_major' => const [
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj69,
        RomanNumeralId.iMaj7,
      ],
      'turnaround_i_vi_ii_v' => const [
        RomanNumeralId.viMin7,
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
      ],
      'turnaround_i_sharpIdim_ii_v' => const [
        RomanNumeralId.sharpIDim7,
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
      ],
      'closing_plagal_authentic_hybrid' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.borrowedIvMin7,
                RomanNumeralId.ivMaj7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
              ]
            : const [
                RomanNumeralId.ivMin7Minor,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMin6,
                RomanNumeralId.iMinMaj7,
                RomanNumeralId.iMin7,
              ],
      'bridge_iv_stabilized_by_local_ii_v_i' => const [
        RomanNumeralId.relatedIiOfIV,
        RomanNumeralId.secondaryOfIV,
        RomanNumeralId.substituteOfIV,
        RomanNumeralId.ivMaj7,
        RomanNumeralId.iiMin7,
      ],
      'backdoor_recursive_prep' => const [
        RomanNumeralId.borrowedFlatVIMaj7,
        RomanNumeralId.borrowedFlatIIIMaj7,
        RomanNumeralId.borrowedIvMin7,
        RomanNumeralId.borrowedFlatVII7,
        RomanNumeralId.iMaj69,
        RomanNumeralId.iMaj7,
      ],
      'classical_predominant_color' => const [
        RomanNumeralId.borrowedFlatIIMaj7,
        RomanNumeralId.ivMaj7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj69,
        RomanNumeralId.iMaj7,
      ],
      'mixture_pivot_modulation' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.borrowedIiHalfDiminished7,
                RomanNumeralId.borrowedIvMin7,
                RomanNumeralId.borrowedFlatIIIMaj7,
                RomanNumeralId.borrowedFlatVIMaj7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
              ]
            : const [
                RomanNumeralId.iiHalfDiminishedMinor,
                RomanNumeralId.ivMin7Minor,
                RomanNumeralId.flatIIIMaj7Minor,
                RomanNumeralId.flatVIMaj7Minor,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMin6,
              ],
      'chromatic_mediant_common_tone_modulation' =>
        finalRomanNumeralId == RomanNumeralId.borrowedFlatIIIMaj7 ||
                finalRomanNumeralId == RomanNumeralId.borrowedFlatVIMaj7
            ? const [
                RomanNumeralId.borrowedFlatIIIMaj7,
                RomanNumeralId.borrowedFlatVIMaj7,
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
              ]
            : finalRomanNumeralId == RomanNumeralId.iiMin7
            ? const [
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.borrowedFlatIIIMaj7,
                RomanNumeralId.borrowedFlatVIMaj7,
              ]
            : finalRomanNumeralId == RomanNumeralId.vDom7
            ? const [
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.iiMin7,
                RomanNumeralId.borrowedFlatIIIMaj7,
                RomanNumeralId.borrowedFlatVIMaj7,
              ]
            : const [
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.viMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iiMin7,
                RomanNumeralId.borrowedFlatIIIMaj7,
                RomanNumeralId.borrowedFlatVIMaj7,
              ],
      'coltrane_burst' =>
        finalRomanNumeralId == RomanNumeralId.iiMin7
            ? const [
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.viMin7,
              ]
            : finalRomanNumeralId == RomanNumeralId.vDom7
            ? const [
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.iiMin7,
                RomanNumeralId.viMin7,
              ]
            : const [
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.viMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iiMin7,
              ],
      'bridge_return_home_cadence' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.iMaj7,
                RomanNumeralId.viMin7,
              ]
            : const [
                RomanNumeralId.iiHalfDiminishedMinor,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMin6,
                RomanNumeralId.iMinMaj7,
                RomanNumeralId.ivMin7Minor,
              ],
      'dominant_headed_scope_chain' => const [
        RomanNumeralId.secondaryOfVI,
        RomanNumeralId.viiHalfDiminished7,
        RomanNumeralId.secondaryOfIII,
        RomanNumeralId.relatedIiOfIII,
        RomanNumeralId.viMin7,
        RomanNumeralId.iiiMin7,
      ],
      'relative_minor_reframe' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.viMin7,
                RomanNumeralId.viiHalfDiminished7,
                RomanNumeralId.secondaryOfVI,
              ]
            : const [
                RomanNumeralId.flatIIIMaj7Minor,
                RomanNumeralId.ivMin7Minor,
                RomanNumeralId.flatVIIDom7Minor,
              ],
      'minor_ii_halfdim_v_alt_i' => const [
        RomanNumeralId.iiHalfDiminishedMinor,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMin6,
        RomanNumeralId.iMinMaj7,
      ],
      'backdoor_ivm_bVII_I' => const [
        RomanNumeralId.borrowedIvMin7,
        RomanNumeralId.borrowedFlatVII7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj69,
      ],
      'cadence_based_real_modulation' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.viMin7,
              ]
            : const [
                RomanNumeralId.iiHalfDiminishedMinor,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMin6,
                RomanNumeralId.ivMin7Minor,
              ],
      'common_chord_modulation' =>
        keyMode == KeyMode.major
            ? const [
                RomanNumeralId.iiMin7,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMaj69,
                RomanNumeralId.viMin7,
              ]
            : const [
                RomanNumeralId.iiHalfDiminishedMinor,
                RomanNumeralId.vDom7,
                RomanNumeralId.iMin6,
                RomanNumeralId.ivMin7Minor,
              ],
      _ => const <RomanNumeralId>[],
    };
    final candidates = <RomanNumeralId>[
      finalRomanNumeralId,
      ...familyCandidates,
      ...switch (harmonicFunction) {
        HarmonicFunction.tonic =>
          keyMode == KeyMode.major
              ? const [RomanNumeralId.iMaj69, RomanNumeralId.iMaj7]
              : const [
                  RomanNumeralId.iMin6,
                  RomanNumeralId.iMinMaj7,
                  RomanNumeralId.iMin7,
                ],
        HarmonicFunction.predominant =>
          keyMode == KeyMode.major
              ? const [RomanNumeralId.iiMin7, RomanNumeralId.ivMaj7]
              : const [
                  RomanNumeralId.iiHalfDiminishedMinor,
                  RomanNumeralId.ivMin7Minor,
                ],
        HarmonicFunction.dominant => const [RomanNumeralId.vDom7],
        HarmonicFunction.free => const [],
      },
    ];
    final unique = <RomanNumeralId>[];
    for (final candidate in candidates) {
      if (!unique.contains(candidate)) {
        unique.add(candidate);
      }
    }
    return unique;
  }

  static Map<SmartProgressionFamily, int> _legacyBaseWeightsForPreset(
    JazzPreset jazzPreset,
  ) {
    return switch (jazzPreset) {
      JazzPreset.standardsCore => <SmartProgressionFamily, int>{
        SmartProgressionFamily.coreIiVIMajor: 24,
        SmartProgressionFamily.turnaroundIViIiV: 11,
        SmartProgressionFamily.turnaroundISharpIdimIiV: 4,
        SmartProgressionFamily.turnaroundIIIviIiV: 3,
        SmartProgressionFamily.relativeMinorReframe: 6,
        SmartProgressionFamily.dominantHeadedScopeChain: 4,
        SmartProgressionFamily.closingPlagalAuthenticHybrid: 5,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI: 3,
        SmartProgressionFamily.minorIiVAltI: 16,
        SmartProgressionFamily.minorLineCliche: 4,
        SmartProgressionFamily.appliedDominantWithRelatedIi: 10,
        SmartProgressionFamily.dominantChainBridgeStyle: 8,
        SmartProgressionFamily.cadenceBasedRealModulation: 8,
        SmartProgressionFamily.commonChordModulation: 4,
        SmartProgressionFamily.backdoorIvmBviiI: 6,
        SmartProgressionFamily.backdoorRecursivePrep: 0,
        SmartProgressionFamily.classicalPredominantColor: 0,
        SmartProgressionFamily.mixturePivotModulation: 0,
        SmartProgressionFamily.chromaticMediantCommonToneModulation: 0,
        SmartProgressionFamily.coltraneBurst: 0,
        SmartProgressionFamily.bridgeReturnHomeCadence: 2,
        SmartProgressionFamily.passingDimToIi: 4,
      },
      JazzPreset.modulationStudy => <SmartProgressionFamily, int>{
        SmartProgressionFamily.coreIiVIMajor: 18,
        SmartProgressionFamily.turnaroundIViIiV: 8,
        SmartProgressionFamily.turnaroundISharpIdimIiV: 2,
        SmartProgressionFamily.turnaroundIIIviIiV: 2,
        SmartProgressionFamily.relativeMinorReframe: 10,
        SmartProgressionFamily.dominantHeadedScopeChain: 8,
        SmartProgressionFamily.closingPlagalAuthenticHybrid: 4,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI: 7,
        SmartProgressionFamily.minorIiVAltI: 12,
        SmartProgressionFamily.minorLineCliche: 4,
        SmartProgressionFamily.appliedDominantWithRelatedIi: 12,
        SmartProgressionFamily.dominantChainBridgeStyle: 6,
        SmartProgressionFamily.cadenceBasedRealModulation: 18,
        SmartProgressionFamily.commonChordModulation: 10,
        SmartProgressionFamily.backdoorIvmBviiI: 4,
        SmartProgressionFamily.backdoorRecursivePrep: 0,
        SmartProgressionFamily.classicalPredominantColor: 1,
        SmartProgressionFamily.mixturePivotModulation: 6,
        SmartProgressionFamily.chromaticMediantCommonToneModulation: 0,
        SmartProgressionFamily.coltraneBurst: 0,
        SmartProgressionFamily.bridgeReturnHomeCadence: 6,
        SmartProgressionFamily.passingDimToIi: 2,
      },
      JazzPreset.advanced => <SmartProgressionFamily, int>{
        SmartProgressionFamily.coreIiVIMajor: 18,
        SmartProgressionFamily.turnaroundIViIiV: 8,
        SmartProgressionFamily.turnaroundISharpIdimIiV: 4,
        SmartProgressionFamily.turnaroundIIIviIiV: 4,
        SmartProgressionFamily.relativeMinorReframe: 8,
        SmartProgressionFamily.dominantHeadedScopeChain: 8,
        SmartProgressionFamily.closingPlagalAuthenticHybrid: 6,
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI: 7,
        SmartProgressionFamily.minorIiVAltI: 12,
        SmartProgressionFamily.minorLineCliche: 6,
        SmartProgressionFamily.appliedDominantWithRelatedIi: 10,
        SmartProgressionFamily.dominantChainBridgeStyle: 10,
        SmartProgressionFamily.cadenceBasedRealModulation: 8,
        SmartProgressionFamily.commonChordModulation: 8,
        SmartProgressionFamily.backdoorIvmBviiI: 6,
        SmartProgressionFamily.backdoorRecursivePrep: 4,
        SmartProgressionFamily.classicalPredominantColor: 4,
        SmartProgressionFamily.mixturePivotModulation: 4,
        SmartProgressionFamily.chromaticMediantCommonToneModulation: 3,
        SmartProgressionFamily.coltraneBurst: 1,
        SmartProgressionFamily.bridgeReturnHomeCadence: 5,
        SmartProgressionFamily.passingDimToIi: 4,
      },
    };
  }

  static int _legacyFamilyBaseWeight({
    required JazzPreset jazzPreset,
    required SmartProgressionFamily family,
  }) {
    return _legacyBaseWeightsForPreset(jazzPreset)[family] ?? 0;
  }

  static List<_WeightedFamily> _weightedFamiliesForRequest({
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
    required bool allowRealModulation,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final baseWeights = <SmartProgressionFamily, int>{
      for (final family in _legacyBaseWeightsForPreset(request.jazzPreset).keys)
        family: SmartPriorLookup.familyBaseWeight(
          jazzPreset: request.jazzPreset,
          family: family,
        ),
    };

    final modulationIntensityMultiplier = switch (request.modulationIntensity) {
      ModulationIntensity.off => 0.0,
      ModulationIntensity.low => 0.72,
      ModulationIntensity.medium => 1.0,
      ModulationIntensity.high => 1.3,
    };
    final nonDiatonicStreak = _nonDiatonicStreakLength(request);
    final nonDiatonicCapMultiplier = nonDiatonicStreak >= 3 ? 0.18 : 1.0;
    final relationPenalty = opportunity.candidates.isEmpty
        ? 1.0
        : _keyRelationPenalty(opportunity.candidates.first.relationToParent);

    final weights = <SmartProgressionFamily, int>{};
    for (final entry in baseWeights.entries) {
      final family = entry.key;
      var weight = entry.value.toDouble();
      weight *= SmartPriorLookup.phraseRoleMultiplier(family, phraseContext);
      weight *= SmartPriorLookup.sectionRoleMultiplier(family, phraseContext);
      weight *= SmartPriorLookup.sourceProfileMultiplier(
        family,
        request.sourceProfile,
      );
      weight *= _scopeAffinityMultiplier(family: family, request: request);
      weight *= _debtPressureMultiplier(family: family, request: request);
      weight *= _antiRepeatPenalty(
        family: family,
        phraseContext: phraseContext,
      );
      weight *= _tonicizationPressureMultiplier(
        family: family,
        request: request,
      );
      weight *= _dominantIntentPressureMultiplier(
        family: family,
        request: request,
      );

      final isModulationFamily =
          family == SmartProgressionFamily.mixturePivotModulation ||
          family ==
              SmartProgressionFamily.chromaticMediantCommonToneModulation ||
          family == SmartProgressionFamily.coltraneBurst ||
          family == SmartProgressionFamily.bridgeReturnHomeCadence ||
          family == SmartProgressionFamily.cadenceBasedRealModulation ||
          family == SmartProgressionFamily.commonChordModulation;
      final isRareColorFamily =
          family == SmartProgressionFamily.classicalPredominantColor ||
          family == SmartProgressionFamily.turnaroundISharpIdimIiV ||
          family == SmartProgressionFamily.passingDimToIi;
      if (isModulationFamily) {
        weight *= modulationIntensityMultiplier;
        weight *= relationPenalty;
        weight *= _surpriseBudgetMultiplier(request: request, modulation: true);
      }
      if (isRareColorFamily ||
          family ==
              SmartProgressionFamily.chromaticMediantCommonToneModulation ||
          family == SmartProgressionFamily.coltraneBurst) {
        weight *= _surpriseBudgetMultiplier(request: request, rare: true);
      }

      if (nonDiatonicStreak >= 3 &&
          family != SmartProgressionFamily.coreIiVIMajor &&
          family != SmartProgressionFamily.turnaroundIViIiV &&
          family != SmartProgressionFamily.minorIiVAltI &&
          family != SmartProgressionFamily.minorLineCliche) {
        weight *= nonDiatonicCapMultiplier;
      }

      weights[family] = max(0, weight.round());
    }

    if (request.currentKeyCenter.mode == KeyMode.major) {
      weights[SmartProgressionFamily.minorIiVAltI] = 0;
      weights[SmartProgressionFamily.minorLineCliche] = 0;
    } else {
      weights[SmartProgressionFamily.coreIiVIMajor] = 0;
      weights[SmartProgressionFamily.turnaroundIViIiV] = 0;
      weights[SmartProgressionFamily.turnaroundISharpIdimIiV] = 0;
      weights[SmartProgressionFamily.turnaroundIIIviIiV] = 0;
      weights[SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI] = 0;
      weights[SmartProgressionFamily.backdoorIvmBviiI] = 0;
      weights[SmartProgressionFamily.classicalPredominantColor] = 0;
      weights[SmartProgressionFamily.passingDimToIi] = 0;
    }

    if (!request.modalInterchangeEnabled) {
      weights[SmartProgressionFamily.backdoorIvmBviiI] = 0;
      weights[SmartProgressionFamily.backdoorRecursivePrep] = 0;
      weights[SmartProgressionFamily.classicalPredominantColor] = 0;
      weights[SmartProgressionFamily.mixturePivotModulation] = 0;
      weights[SmartProgressionFamily.chromaticMediantCommonToneModulation] = 0;
    }
    if (!request.secondaryDominantEnabled &&
        !request.substituteDominantEnabled) {
      weights[SmartProgressionFamily.appliedDominantWithRelatedIi] = 0;
      weights[SmartProgressionFamily.dominantHeadedScopeChain] = 0;
      weights[SmartProgressionFamily.dominantChainBridgeStyle] = 0;
      weights[SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI] = 0;
    }
    if (request.activeKeys.length <= 1) {
      weights.update(
        SmartProgressionFamily.appliedDominantWithRelatedIi,
        (value) => max(0, (value * 0.54).round()),
        ifAbsent: () => 0,
      );
      weights.update(
        SmartProgressionFamily.dominantHeadedScopeChain,
        (value) => max(0, (value * 0.42).round()),
        ifAbsent: () => 0,
      );
      weights.update(
        SmartProgressionFamily.dominantChainBridgeStyle,
        (value) => max(0, (value * 0.18).round()),
        ifAbsent: () => 0,
      );
    }
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final homeCandidate = _returnHomeCandidateForRequest(
      request: request,
      opportunity: opportunity,
      returnHomeDebt: returnHomeDebt,
    );
    if (!allowRealModulation ||
        request.modulationIntensity == ModulationIntensity.off ||
        opportunity.candidates.isEmpty) {
      weights[SmartProgressionFamily.cadenceBasedRealModulation] = 0;
      weights[SmartProgressionFamily.commonChordModulation] = 0;
      weights[SmartProgressionFamily.mixturePivotModulation] = 0;
      weights[SmartProgressionFamily.chromaticMediantCommonToneModulation] = 0;
      weights[SmartProgressionFamily.coltraneBurst] = 0;
      if (homeCandidate == null) {
        weights[SmartProgressionFamily.bridgeReturnHomeCadence] = 0;
      }
    }

    if (request.currentTrace?.postModulationConfirmationsRemaining != null &&
        request.currentTrace!.postModulationConfirmationsRemaining > 0) {
      weights[SmartProgressionFamily.cadenceBasedRealModulation] = 0;
      weights[SmartProgressionFamily.commonChordModulation] = 0;
      weights[SmartProgressionFamily.mixturePivotModulation] = 0;
      weights[SmartProgressionFamily.chromaticMediantCommonToneModulation] = 0;
      weights[SmartProgressionFamily.coltraneBurst] = 0;
      if (returnHomeDebt == null || homeCandidate == null) {
        weights[SmartProgressionFamily.bridgeReturnHomeCadence] = 0;
      }
      weights[SmartProgressionFamily.dominantHeadedScopeChain] = 0;
      weights[SmartProgressionFamily.dominantChainBridgeStyle] = 0;
      weights[SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI] = 0;
    }

    final inferredHomeCenter = _returnHomeTargetCenterForRequest(request);
    final hasReturnHomeDebt = returnHomeDebt != null;
    if (inferredHomeCenter == null ||
        inferredHomeCenter == request.currentKeyCenter ||
        homeCandidate == null) {
      weights[SmartProgressionFamily.bridgeReturnHomeCadence] = 0;
    } else {
      final bridgeReturnWindow = _isBridgeReturnWindowForDebt(
        phraseContext,
        returnHomeDebt: returnHomeDebt,
      );
      final returnBoost = bridgeReturnWindow
          ? 1.42
          : _isBridgeReturnZone(phraseContext)
          ? 1.18
          : 0.78;
      final returnDebtBoost = hasReturnHomeDebt
          ? (bridgeReturnWindow ? 2.0 : 1.44)
          : 1.0;
      weights.update(
        SmartProgressionFamily.bridgeReturnHomeCadence,
        (value) => max(4, (value * returnBoost * returnDebtBoost).round()),
      );
      if (hasReturnHomeDebt) {
        for (final family in const [
          SmartProgressionFamily.cadenceBasedRealModulation,
          SmartProgressionFamily.commonChordModulation,
          SmartProgressionFamily.mixturePivotModulation,
          SmartProgressionFamily.dominantChainBridgeStyle,
          SmartProgressionFamily.dominantHeadedScopeChain,
          SmartProgressionFamily.appliedDominantWithRelatedIi,
          SmartProgressionFamily.relativeMinorReframe,
        ]) {
          weights.update(
            family,
            (value) => max(0, (value * 0.58).round()),
            ifAbsent: () => 0,
          );
        }
        if (bridgeReturnWindow) {
          weights.update(
            SmartProgressionFamily.bridgeReturnHomeCadence,
            (value) => max(value + 14, (value * 1.82).round()),
          );
          for (final family in const [
            SmartProgressionFamily.coreIiVIMajor,
            SmartProgressionFamily.minorIiVAltI,
            SmartProgressionFamily.closingPlagalAuthenticHybrid,
            SmartProgressionFamily.turnaroundIViIiV,
            SmartProgressionFamily.turnaroundIIIviIiV,
            SmartProgressionFamily.backdoorIvmBviiI,
            SmartProgressionFamily.backdoorRecursivePrep,
            SmartProgressionFamily.classicalPredominantColor,
          ]) {
            weights.update(
              family,
              (value) => max(0, (value * 0.56).round()),
              ifAbsent: () => 0,
            );
          }
        }
      }
    }

    final dominantOverflow = _dominantIntentOverflow(request);
    if (dominantOverflow > 0) {
      weights.update(
        SmartProgressionFamily.turnaroundIViIiV,
        (value) => max(
          0,
          (value * (request.activeKeys.length <= 1 ? 0.42 : 0.58)).round(),
        ),
        ifAbsent: () => 0,
      );
      weights.update(
        SmartProgressionFamily.turnaroundIIIviIiV,
        (value) => max(0, (value * 0.54).round()),
        ifAbsent: () => 0,
      );
      if (request.currentKeyCenter.mode == KeyMode.major &&
          request.modalInterchangeEnabled &&
          (phraseContext.phraseRole == PhraseRole.preCadence ||
              phraseContext.phraseRole == PhraseRole.cadence ||
              phraseContext.phraseRole == PhraseRole.release ||
              request.activeKeys.length <= 1)) {
        for (final family in const [
          SmartProgressionFamily.coreIiVIMajor,
          SmartProgressionFamily.closingPlagalAuthenticHybrid,
          SmartProgressionFamily.classicalPredominantColor,
          SmartProgressionFamily.turnaroundISharpIdimIiV,
          SmartProgressionFamily.passingDimToIi,
        ]) {
          weights.update(
            family,
            (value) => max(
              0,
              (value * (request.activeKeys.length <= 1 ? 0.72 : 0.82)).round(),
            ),
            ifAbsent: () => 0,
          );
        }
        final altCadenceBoost = request.activeKeys.length <= 1 ? 6 : 4;
        weights.update(
          SmartProgressionFamily.backdoorRecursivePrep,
          (value) => max(value + altCadenceBoost, (value * 1.28).round()),
          ifAbsent: () => altCadenceBoost,
        );
        weights.update(
          SmartProgressionFamily.backdoorIvmBviiI,
          (value) => max(value + altCadenceBoost, (value * 1.22).round()),
          ifAbsent: () => altCadenceBoost,
        );
      }
    }

    if (request.currentHarmonicFunction == HarmonicFunction.tonic) {
      final dominantOverflowForTonic = _dominantIntentOverflow(request);
      final preferAltCadence =
          request.currentKeyCenter.mode == KeyMode.major &&
          request.modalInterchangeEnabled &&
          dominantOverflowForTonic > 0 &&
          (phraseContext.phraseRole == PhraseRole.preCadence ||
              phraseContext.phraseRole == PhraseRole.cadence ||
              phraseContext.phraseRole == PhraseRole.release ||
              request.activeKeys.length <= 1);
      final tonicFamily = preferAltCadence
          ? SmartProgressionFamily.backdoorRecursivePrep
          : request.currentKeyCenter.mode == KeyMode.major
          ? SmartProgressionFamily.turnaroundIViIiV
          : SmartProgressionFamily.minorLineCliche;
      weights.update(tonicFamily, (value) => value + 3, ifAbsent: () => 3);
    }
    if (request.currentHarmonicFunction == HarmonicFunction.predominant) {
      final cadenceFamily = request.currentKeyCenter.mode == KeyMode.major
          ? SmartProgressionFamily.coreIiVIMajor
          : SmartProgressionFamily.minorIiVAltI;
      weights.update(cadenceFamily, (value) => value + 4, ifAbsent: () => 4);
      weights.update(
        SmartProgressionFamily.closingPlagalAuthenticHybrid,
        (value) => value + 3,
        ifAbsent: () => 3,
      );
    }
    if (request.currentHarmonicFunction == HarmonicFunction.tonic &&
        (phraseContext.phraseRole == PhraseRole.preCadence ||
            phraseContext.phraseRole == PhraseRole.cadence ||
            phraseContext.phraseRole == PhraseRole.release)) {
      weights.update(
        SmartProgressionFamily.closingPlagalAuthenticHybrid,
        (value) => value + 2,
        ifAbsent: () => 2,
      );
    }
    if (request.jazzPreset == JazzPreset.advanced &&
        request.currentKeyCenter.mode == KeyMode.major &&
        (phraseContext.phraseRole == PhraseRole.preCadence ||
            phraseContext.phraseRole == PhraseRole.cadence ||
            phraseContext.phraseRole == PhraseRole.release)) {
      weights.update(
        SmartProgressionFamily.backdoorRecursivePrep,
        (value) => value + 3,
        ifAbsent: () => 3,
      );
    }
    if (request.jazzPreset == JazzPreset.advanced &&
        _supportedChromaticMediantTargetForRequest(
              request: request,
              candidates: opportunity.candidates,
            ) !=
            null) {
      final chromaticBoost =
          phraseContext.sectionRole == SectionRole.bridgeLike ||
              phraseContext.phraseRole == PhraseRole.preCadence ||
              phraseContext.phraseRole == PhraseRole.cadence
          ? 5
          : 2;
      weights.update(
        SmartProgressionFamily.chromaticMediantCommonToneModulation,
        (value) => value + chromaticBoost,
        ifAbsent: () => chromaticBoost,
      );
    }
    if (request.jazzPreset != JazzPreset.advanced ||
        request.modulationIntensity != ModulationIntensity.high ||
        !_hasColtraneCyclePotential(request.activeKeys) ||
        request.currentKeyCenter.mode != KeyMode.major) {
      weights[SmartProgressionFamily.coltraneBurst] = 0;
    } else {
      weights.update(
        SmartProgressionFamily.coltraneBurst,
        (value) => value + 4,
        ifAbsent: () => 4,
      );
    }
    if (request.currentKeyCenter.mode == KeyMode.major &&
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        (request.currentHarmonicFunction == HarmonicFunction.tonic ||
            request.currentHarmonicFunction == HarmonicFunction.predominant ||
            request.currentTrace?.activeLocalScope?.center.relationToParent ==
                KeyRelation.subdominant)) {
      weights.update(
        SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI,
        (value) => value + 6,
        ifAbsent: () => 6,
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
      case SmartProgressionFamily.relativeMinorReframe:
        return _buildRelativeMinorReframeFamily(request: request);
      case SmartProgressionFamily.dominantHeadedScopeChain:
        return _buildDominantHeadedScopeFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.closingPlagalAuthenticHybrid:
        return _buildClosingPlagalAuthenticHybridFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI:
        return _buildBridgeIVStabilizedByLocalIiVIFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.minorIiVAltI:
        return _buildMinorIiVAltIFamily(request: request);
      case SmartProgressionFamily.minorLineCliche:
        return _buildMinorLineClicheFamily(
          request: request,
          includeLeadingTonic: includeLeadingTonic,
        );
      case SmartProgressionFamily.backdoorIvmBviiI:
        return _buildBackdoorFamily(request: request);
      case SmartProgressionFamily.backdoorRecursivePrep:
        return _buildBackdoorRecursivePrepFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.classicalPredominantColor:
        return _buildClassicalPredominantColorFamily(
          random: random,
          request: request,
        );
      case SmartProgressionFamily.mixturePivotModulation:
        final targetCenter = opportunity.candidates.firstWhere(
          (candidate) => candidate.relationToParent == KeyRelation.parallel,
          orElse: () => const KeyCenter(tonicName: '', mode: KeyMode.major),
        );
        return targetCenter.tonicName.isEmpty
            ? null
            : _buildMixturePivotModulationFamily(
                request: request,
                targetCenter: targetCenter,
              );
      case SmartProgressionFamily.chromaticMediantCommonToneModulation:
        return _buildChromaticMediantCommonToneModulationFamily(
          request: request,
          opportunity: opportunity,
        );
      case SmartProgressionFamily.coltraneBurst:
        return _buildColtraneBurstFamily(
          request: request,
          opportunity: opportunity,
        );
      case SmartProgressionFamily.bridgeReturnHomeCadence:
        final homeCandidate = _returnHomeCandidateForRequest(
          request: request,
          opportunity: opportunity,
          returnHomeDebt: _returnHomeDebtForRequest(request),
        );
        return homeCandidate == null
            ? null
            : _buildBridgeReturnHomeCadenceFamily(
                request: request,
                targetCenter: homeCandidate,
              );
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
    final phraseContext = _phraseContextForRequest(request);
    final patternTag = _familyTag(SmartProgressionFamily.coreIiVIMajor);
    final arrivalRoman = _selectMajorArrivalRoman(
      phraseContext,
      request.sourceProfile,
    );
    final arrivalKind = _selectMajorArrivalChordKind(
      phraseContext,
      request.sourceProfile,
    );
    final useSusRelease =
        request.sourceProfile == SourceProfile.recordingInspired &&
        (phraseContext.phraseRole == PhraseRole.preCadence ||
            phraseContext.phraseRole == PhraseRole.cadence);
    final variantTag = useSusRelease ? 'ii_v_sus_release_i' : 'plain_ii_v_i';
    return _family(
      family: SmartProgressionFamily.coreIiVIMajor,
      destination: arrivalRoman,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: arrivalRoman,
            plannedChordKind: arrivalKind,
            patternTag: patternTag,
            variantTag: variantTag,
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: useSusRelease
              ? DominantContext.susDominant
              : DominantContext.primaryMajor,
          dominantIntent: useSusRelease
              ? DominantIntent.susDelay
              : DominantIntent.primaryAuthenticMajor,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: useSusRelease ? const ['susDelay'] : const [],
          openedDebts: useSusRelease
              ? const [
                  ResolutionDebt(
                    debtType: ResolutionDebtType.susResolve,
                    targetLabel: 'same-root dominant',
                    deadline: 1,
                    severity: 2,
                  ),
                ]
              : const [],
        ),
        if (useSusRelease)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
            satisfiedDebtTypes: const [ResolutionDebtType.susResolve],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: arrivalRoman,
          plannedChordKind: arrivalKind,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          surfaceTags: arrivalKind == PlannedChordKind.tonicSix
              ? const ['tonicAdd6']
              : arrivalRoman == RomanNumeralId.iMaj69
              ? const ['tonicMaj69']
              : const [],
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
    final phraseContext = _phraseContextForRequest(request);
    final patternTag = _familyTag(SmartProgressionFamily.turnaroundIViIiV);
    final leadRoman = _selectMajorArrivalRoman(
      phraseContext,
      request.sourceProfile,
    );
    final dominantOverflow = _dominantIntentOverflow(request);
    final handoffToPredominant =
        dominantOverflow > 0 &&
        (request.currentHarmonicFunction == HarmonicFunction.tonic ||
            phraseContext.phraseRole == PhraseRole.continuation ||
            phraseContext.sectionRole == SectionRole.turnaroundTail ||
            phraseContext.sectionRole == SectionRole.tag);
    final variantTag = handoffToPredominant ? 'handoff_to_ii' : 'classic';
    return _family(
      family: SmartProgressionFamily.turnaroundIViIiV,
      destination: handoffToPredominant
          ? RomanNumeralId.iiMin7
          : RomanNumeralId.vDom7,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: leadRoman,
            plannedChordKind: _selectMajorArrivalChordKind(
              phraseContext,
              request.sourceProfile,
            ),
            patternTag: patternTag,
            variantTag: variantTag,
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.viMin7,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: handoffToPredominant
              ? const ['predominantHandoff']
              : const [],
        ),
        if (!handoffToPredominant)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
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
    final phraseContext = _phraseContextForRequest(request);
    final patternTag = _familyTag(
      SmartProgressionFamily.turnaroundISharpIdimIiV,
    );
    final handoffToPredominant = _dominantIntentOverflow(request) > 0;
    const baseVariantTag = 'passing_dim';
    final variantTag = handoffToPredominant
        ? '${baseVariantTag}_handoff'
        : baseVariantTag;
    return _family(
      family: SmartProgressionFamily.turnaroundISharpIdimIiV,
      destination: handoffToPredominant
          ? RomanNumeralId.iiMin7
          : RomanNumeralId.vDom7,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: _selectMajorArrivalRoman(
              phraseContext,
              request.sourceProfile,
            ),
            plannedChordKind: _selectMajorArrivalChordKind(
              phraseContext,
              request.sourceProfile,
            ),
            patternTag: patternTag,
            variantTag: variantTag,
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.sharpIDim7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['commonToneDim', 'rareColor'],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.rareColorPayoff,
              targetLabel: 'ii approach payoff',
              deadline: 1,
              severity: 2,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.rareColorPayoff],
          surfaceTags: handoffToPredominant
              ? const ['predominantHandoff']
              : const [],
        ),
        if (!handoffToPredominant)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
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
    final patternTag = _familyTag(SmartProgressionFamily.turnaroundIIIviIiV);
    final phraseContext = _phraseContextForRequest(request);
    final handoffToPredominant =
        _dominantIntentOverflow(request) > 0 &&
        (phraseContext.phraseRole != PhraseRole.opener ||
            request.activeKeys.length <= 1);
    final variantTag = handoffToPredominant ? 'flowing_handoff' : 'flowing';
    return _family(
      family: SmartProgressionFamily.turnaroundIIIviIiV,
      destination: handoffToPredominant
          ? RomanNumeralId.iiMin7
          : RomanNumeralId.vDom7,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.viMin7,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: handoffToPredominant
              ? const ['predominantHandoff']
              : const [],
        ),
        if (!handoffToPredominant)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
          ),
      ],
    );
  }

  static _FamilyPlan? _buildRelativeMinorReframeFamily({
    required SmartStepRequest request,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final patternTag = _familyTag(SmartProgressionFamily.relativeMinorReframe);
    if (request.currentKeyCenter.mode == KeyMode.major) {
      if (!request.secondaryDominantEnabled) {
        return null;
      }
      final targetRoot = MusicTheory.resolveChordRootForCenter(
        request.currentKeyCenter,
        RomanNumeralId.viMin7,
      );
      final targetCenter = KeyCenter(
        tonicName: targetRoot,
        mode: KeyMode.minor,
        relationToParent: KeyRelation.relative,
        enteredBy: CenterEntryMethod.tonicization,
        confidence: 0.7,
        confirmationsRemaining: 1,
      );
      final arrivalQuality = _selectRelativeMinorArrivalQuality(
        phraseContext,
        request.sourceProfile,
      );
      final arrivalTags = <String>[
        'relativeReframe',
        if (arrivalQuality == ChordQuality.minor6) 'tonicMinor6',
        if (arrivalQuality == ChordQuality.minorMajor7) 'tonicMinorMaj7',
      ];
      return _family(
        family: SmartProgressionFamily.relativeMinorReframe,
        destination: RomanNumeralId.viMin7,
        queue: [
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.viMin7,
            patternTag: patternTag,
            variantTag: 'major_to_relative_minor',
            modulationKind: ModulationKind.tonicization,
            openScope: LocalScope(
              center: targetCenter,
              headType: ScopeHeadType.tonicHead,
              confidence: 0.68,
              expiresIn: 3,
            ),
            surfaceTags: const ['relativeReframe'],
          ),
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.viiHalfDiminished7,
            patternTag: patternTag,
            variantTag: 'major_to_relative_minor',
            modulationKind: ModulationKind.tonicization,
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.predominantToDominant,
                targetLabel: 'V7/VI',
                deadline: 1,
                severity: 1,
              ),
            ],
            surfaceTags: const ['relativeReframe'],
          ),
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.secondaryOfVI,
            appliedType: AppliedType.secondary,
            resolutionTargetRomanId: RomanNumeralId.viMin7,
            dominantContext: DominantContext.secondaryToMinor,
            dominantIntent: DominantIntent.secondaryToMinor,
            patternTag: patternTag,
            variantTag: 'major_to_relative_minor',
            modulationKind: ModulationKind.tonicization,
            satisfiedDebtTypes: const [
              ResolutionDebtType.predominantToDominant,
            ],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.dominantResolve,
                targetLabel: 'VIm as local i',
                deadline: 1,
                severity: 2,
              ),
            ],
            surfaceTags: const ['relativeReframe'],
          ),
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.viMin7,
            patternTag: patternTag,
            variantTag: 'major_to_relative_minor',
            renderQualityOverride: arrivalQuality,
            modulationKind: ModulationKind.tonicization,
            cadentialArrival: true,
            satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
            openScope: LocalScope(
              center: targetCenter,
              headType: ScopeHeadType.tonicHead,
              confidence: 0.74,
              expiresIn: 1,
            ),
            surfaceTags: arrivalTags,
          ),
        ],
      );
    }

    final targetRoot = MusicTheory.resolveChordRootForCenter(
      request.currentKeyCenter,
      RomanNumeralId.flatIIIMaj7Minor,
    );
    final targetCenter = KeyCenter(
      tonicName: targetRoot,
      mode: KeyMode.major,
      relationToParent: KeyRelation.relative,
      enteredBy: CenterEntryMethod.pivot,
      confidence: 0.7,
      confirmationsRemaining: 1,
    );
    final arrivalQuality = _selectRelativeMajorArrivalQuality(
      phraseContext,
      request.sourceProfile,
    );
    final arrivalTags = <String>[
      'relativeReframe',
      if (arrivalQuality == ChordQuality.major69) 'tonicMaj69',
      if (arrivalQuality == ChordQuality.six) 'tonicAdd6',
    ];
    return _family(
      family: SmartProgressionFamily.relativeMinorReframe,
      destination: RomanNumeralId.flatIIIMaj7Minor,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.flatIIIMaj7Minor,
          patternTag: patternTag,
          variantTag: 'minor_to_relative_major',
          modulationKind: ModulationKind.tonicization,
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.pivotArea,
            confidence: 0.68,
            expiresIn: 3,
          ),
          surfaceTags: const ['relativeReframe'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.ivMin7Minor,
          patternTag: patternTag,
          variantTag: 'minor_to_relative_major',
          modulationKind: ModulationKind.tonicization,
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.predominantToDominant,
              targetLabel: 'bVII7 as V/bIII',
              deadline: 1,
              severity: 1,
            ),
          ],
          surfaceTags: const ['relativeReframe'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.flatVIIDom7Minor,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          patternTag: patternTag,
          variantTag: 'minor_to_relative_major',
          modulationKind: ModulationKind.tonicization,
          satisfiedDebtTypes: const [ResolutionDebtType.predominantToDominant],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'bIII as relative I',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: const ['relativeReframe'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.flatIIIMaj7Minor,
          patternTag: patternTag,
          variantTag: 'minor_to_relative_major',
          renderQualityOverride: arrivalQuality,
          modulationKind: ModulationKind.tonicization,
          cadentialArrival: true,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.tonicHead,
            confidence: 0.74,
            expiresIn: 1,
          ),
          surfaceTags: arrivalTags,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildDominantHeadedScopeFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major ||
        !request.secondaryDominantEnabled) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final patternTag = _familyTag(
      SmartProgressionFamily.dominantHeadedScopeChain,
    );
    final activeScope = request.currentTrace?.activeLocalScope;
    final viRoot = MusicTheory.resolveChordRootForCenter(
      request.currentKeyCenter,
      RomanNumeralId.viMin7,
    );
    final iiiRoot = MusicTheory.resolveChordRootForCenter(
      request.currentKeyCenter,
      RomanNumeralId.iiiMin7,
    );
    late final RomanNumeralId targetRoman;
    late final RomanNumeralId relatedPrep;
    late final RomanNumeralId dominantRoman;
    if (activeScope?.headType == ScopeHeadType.dominantHead &&
        activeScope?.center.mode == KeyMode.minor &&
        activeScope?.center.tonicName == viRoot) {
      targetRoman = RomanNumeralId.viMin7;
      relatedPrep = RomanNumeralId.viiHalfDiminished7;
      dominantRoman = RomanNumeralId.secondaryOfVI;
    } else if (activeScope?.headType == ScopeHeadType.dominantHead &&
        activeScope?.center.mode == KeyMode.minor &&
        activeScope?.center.tonicName == iiiRoot) {
      targetRoman = RomanNumeralId.iiiMin7;
      relatedPrep = RomanNumeralId.relatedIiOfIII;
      dominantRoman = RomanNumeralId.secondaryOfIII;
    } else if (phraseContext.sectionRole == SectionRole.bridgeLike
        ? random.nextInt(100) < 56
        : random.nextInt(100) < 70) {
      targetRoman = RomanNumeralId.viMin7;
      relatedPrep = RomanNumeralId.viiHalfDiminished7;
      dominantRoman = RomanNumeralId.secondaryOfVI;
    } else {
      targetRoman = RomanNumeralId.iiiMin7;
      relatedPrep = RomanNumeralId.relatedIiOfIII;
      dominantRoman = RomanNumeralId.secondaryOfIII;
    }

    final targetRoot = MusicTheory.resolveChordRootForCenter(
      request.currentKeyCenter,
      targetRoman,
    );
    final targetCenter = KeyCenter(
      tonicName: targetRoot,
      mode: KeyMode.minor,
      relationToParent: targetRoman == RomanNumeralId.viMin7
          ? KeyRelation.relative
          : KeyRelation.mediant,
      enteredBy: CenterEntryMethod.tonicization,
      confidence: 0.66,
      confirmationsRemaining: 1,
    );
    final useSusHead =
        request.sourceProfile == SourceProfile.recordingInspired &&
        phraseContext.phraseRole != PhraseRole.opener;
    final arrivalQuality = _selectRelativeMinorArrivalQuality(
      phraseContext,
      request.sourceProfile,
    );
    final variantTag =
        '${useSusHead ? 'sus_headed' : 'plain_headed'}_'
        '${targetRoman == RomanNumeralId.viMin7 ? 'scope_of_vi' : 'scope_of_iii'}';
    return _family(
      family: SmartProgressionFamily.dominantHeadedScopeChain,
      destination: targetRoman,
      appliedCandidates: [dominantRoman],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: dominantRoman,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: targetRoman,
          dominantContext: useSusHead
              ? DominantContext.susDominant
              : DominantContext.secondaryToMinor,
          dominantIntent: DominantIntent.dominantHeadedScope,
          renderQualityOverride: useSusHead
              ? ChordQuality.dominant13sus4
              : null,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.dominantHead,
            confidence: 0.68,
            expiresIn: 4,
          ),
          openedDebts: [
            const ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'dominant-headed local tonic',
              deadline: 3,
              severity: 2,
            ),
            if (useSusHead)
              const ResolutionDebt(
                debtType: ResolutionDebtType.susResolve,
                targetLabel: 'same-root release',
                deadline: 2,
                severity: 2,
              ),
          ],
          surfaceTags: useSusHead
              ? const ['dominantHeadedScope', 'susDelay']
              : const ['dominantHeadedScope'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: relatedPrep,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          surfaceTags: const ['dominantHeadedScope'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: dominantRoman,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: targetRoman,
          dominantContext: DominantContext.secondaryToMinor,
          dominantIntent: DominantIntent.secondaryToMinor,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          satisfiedDebtTypes: useSusHead
              ? const [ResolutionDebtType.susResolve]
              : const [],
          surfaceTags: const ['dominantHeadedScope'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: targetRoman,
          patternTag: patternTag,
          variantTag: variantTag,
          renderQualityOverride: arrivalQuality,
          modulationKind: ModulationKind.tonicization,
          cadentialArrival: true,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.tonicHead,
            confidence: 0.74,
            expiresIn: 1,
          ),
          surfaceTags: [
            'dominantHeadedScope',
            if (arrivalQuality == ChordQuality.minor6) 'tonicMinor6',
            if (arrivalQuality == ChordQuality.minorMajor7) 'tonicMinorMaj7',
          ],
        ),
      ],
    );
  }

  static _FamilyPlan? _buildClosingPlagalAuthenticHybridFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final dominantOverflow = _dominantIntentOverflow(request);
    final patternTag = _familyTag(
      SmartProgressionFamily.closingPlagalAuthenticHybrid,
    );
    if (request.currentKeyCenter.mode == KeyMode.major) {
      final useBorrowedIv =
          request.modalInterchangeEnabled &&
          (phraseContext.phraseRole == PhraseRole.preCadence ||
              phraseContext.phraseRole == PhraseRole.cadence ||
              phraseContext.phraseRole == PhraseRole.release ||
              request.sourceProfile == SourceProfile.recordingInspired) &&
          random.nextInt(100) < 68;
      final arrivalRoman = _selectMajorArrivalRoman(
        phraseContext,
        request.sourceProfile,
      );
      final arrivalKind = _selectMajorArrivalChordKind(
        phraseContext,
        request.sourceProfile,
      );
      final susQuality =
          request.sourceProfile == SourceProfile.recordingInspired
          ? ChordQuality.dominant13sus4
          : ChordQuality.dominant7sus4;
      final useSingleDominantRelease =
          dominantOverflow > 0 &&
          (request.activeKeys.length <= 1 ||
              phraseContext.phraseRole != PhraseRole.opener);
      final variantTag = useSingleDominantRelease
          ? useBorrowedIv
                ? 'borrowed_ivm_single_authentic'
                : 'iv_single_authentic'
          : useBorrowedIv
          ? 'borrowed_ivm_sus_authentic'
          : 'iv_sus_authentic';
      final ivRoman = useBorrowedIv
          ? RomanNumeralId.borrowedIvMin7
          : RomanNumeralId.ivMaj7;
      return _family(
        family: SmartProgressionFamily.closingPlagalAuthenticHybrid,
        destination: arrivalRoman,
        modalCandidates: useBorrowedIv
            ? const [RomanNumeralId.borrowedIvMin7]
            : const [],
        queue: [
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: ivRoman,
            patternTag: patternTag,
            variantTag: variantTag,
            surfaceTags: useBorrowedIv
                ? const ['plagalColor', 'borrowedColor']
                : const ['plagalColor'],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.predominantToDominant,
                targetLabel: 'authentic dominant',
                deadline: 1,
                severity: 2,
              ),
            ],
          ),
          if (!useSingleDominantRelease)
            _queuedChord(
              keyCenter: request.currentKeyCenter,
              roman: RomanNumeralId.vDom7,
              renderQualityOverride: susQuality,
              dominantContext: DominantContext.susDominant,
              dominantIntent: DominantIntent.susDelay,
              patternTag: patternTag,
              variantTag: variantTag,
              satisfiedDebtTypes: const [
                ResolutionDebtType.predominantToDominant,
              ],
              openedDebts: const [
                ResolutionDebt(
                  debtType: ResolutionDebtType.susResolve,
                  targetLabel: 'same-root dominant release',
                  deadline: 1,
                  severity: 2,
                ),
              ],
              surfaceTags: const ['plagalColor', 'susDelay'],
            ),
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
            satisfiedDebtTypes: useSingleDominantRelease
                ? const [ResolutionDebtType.predominantToDominant]
                : const [ResolutionDebtType.susResolve],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.dominantResolve,
                targetLabel: 'I cadence',
                deadline: 1,
                severity: 2,
              ),
            ],
            surfaceTags: useSingleDominantRelease
                ? const ['plagalColor', 'compactDominant']
                : const ['plagalColor'],
          ),
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: arrivalRoman,
            plannedChordKind: arrivalKind,
            patternTag: patternTag,
            variantTag: variantTag,
            cadentialArrival: true,
            satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
            surfaceTags: arrivalKind == PlannedChordKind.tonicSix
                ? const ['plagalColor', 'tonicAdd6']
                : arrivalRoman == RomanNumeralId.iMaj69
                ? const ['plagalColor', 'tonicMaj69']
                : const ['plagalColor'],
          ),
        ],
      );
    }

    final tonic = _selectMinorArrivalFromContext(
      request.sourceProfile,
      phraseContext,
    );
    final susQuality = request.sourceProfile == SourceProfile.recordingInspired
        ? ChordQuality.dominant13sus4
        : ChordQuality.dominant7sus4;
    final finalDominantQuality =
        request.sourceProfile == SourceProfile.recordingInspired
        ? ChordQuality.dominant7Alt
        : null;
    final variantTag = 'minor_iv_sus_authentic';
    return _family(
      family: SmartProgressionFamily.closingPlagalAuthenticHybrid,
      destination: tonic,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.ivMin7Minor,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['plagalColor'],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.predominantToDominant,
              targetLabel: 'minor authentic dominant',
              deadline: 1,
              severity: 2,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          renderQualityOverride: susQuality,
          dominantContext: DominantContext.susDominant,
          dominantIntent: DominantIntent.susDelay,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.predominantToDominant],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.susResolve,
              targetLabel: 'same-root dominant release',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: const ['plagalColor', 'susDelay'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          renderQualityOverride: finalDominantQuality,
          dominantContext: DominantContext.primaryMinor,
          dominantIntent: DominantIntent.primaryAuthenticMinor,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.susResolve],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'minor i cadence',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: const ['plagalColor'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: tonic,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          surfaceTags: tonic == RomanNumeralId.iMinMaj7
              ? const ['plagalColor', 'tonicMinorMaj7']
              : tonic == RomanNumeralId.iMin6
              ? const ['plagalColor', 'tonicMinor6']
              : const ['plagalColor'],
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
    final phraseContext = _phraseContextForRequest(request);
    final tonic = _selectMinorArrivalFromContext(
      request.sourceProfile,
      phraseContext,
    );
    final useSusRelease =
        request.sourceProfile == SourceProfile.recordingInspired &&
        phraseContext.phraseRole != PhraseRole.opener;
    final patternTag = _familyTag(SmartProgressionFamily.minorIiVAltI);
    final variantTag = useSusRelease
        ? 'ii_halfdim_v_sus_v_alt_i'
        : 'ii_halfdim_v_alt_i';
    return _family(
      family: SmartProgressionFamily.minorIiVAltI,
      destination: tonic,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiHalfDiminishedMinor,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: useSusRelease
              ? DominantContext.susDominant
              : DominantContext.primaryMinor,
          dominantIntent: useSusRelease
              ? DominantIntent.susDelay
              : DominantIntent.primaryAuthenticMinor,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: useSusRelease ? const ['susDelay'] : const [],
          openedDebts: useSusRelease
              ? const [
                  ResolutionDebt(
                    debtType: ResolutionDebtType.susResolve,
                    targetLabel: 'minor dominant release',
                    deadline: 1,
                    severity: 2,
                  ),
                ]
              : const [],
        ),
        if (useSusRelease)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMinor,
            dominantIntent: DominantIntent.primaryAuthenticMinor,
            patternTag: patternTag,
            variantTag: variantTag,
            satisfiedDebtTypes: const [ResolutionDebtType.susResolve],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: tonic,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          surfaceTags: tonic == RomanNumeralId.iMinMaj7
              ? const ['tonicMinorMaj7']
              : tonic == RomanNumeralId.iMin6
              ? const ['tonicMinor6']
              : const [],
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
    final patternTag = _familyTag(SmartProgressionFamily.minorLineCliche);
    return _family(
      family: SmartProgressionFamily.minorLineCliche,
      destination: RomanNumeralId.iMin6,
      queue: [
        if (includeLeadingTonic)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.iMinMaj7,
            patternTag: patternTag,
            variantTag: 'full_line_cliche',
            surfaceTags: const ['tonicMinorMaj7'],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMin7,
          patternTag: patternTag,
          variantTag: 'full_line_cliche',
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMin6,
          patternTag: patternTag,
          variantTag: 'full_line_cliche',
          cadentialArrival: true,
          surfaceTags: const ['tonicMinor6'],
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
    final phraseContext = _phraseContextForRequest(request);
    final useAuthenticHybrid =
        request.sourceProfile == SourceProfile.recordingInspired &&
        (phraseContext.phraseRole == PhraseRole.cadence ||
            phraseContext.phraseRole == PhraseRole.release);
    final patternTag = _familyTag(SmartProgressionFamily.backdoorIvmBviiI);
    final variantTag = useAuthenticHybrid
        ? 'hybrid_authentic'
        : 'plain_backdoor';
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
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['backdoorFlavor'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedFlatVII7,
          dominantContext: DominantContext.backdoor,
          dominantIntent: DominantIntent.backdoor,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['backdoorFlavor'],
        ),
        if (useAuthenticHybrid)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
            surfaceTags: const ['susDelay'],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          surfaceTags: const ['tonicMaj69', 'backdoorFlavor'],
        ),
      ],
    );
  }

  static _FamilyPlan? _buildBackdoorRecursivePrepFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major ||
        !request.modalInterchangeEnabled ||
        request.jazzPreset == JazzPreset.standardsCore) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final cadentialZone =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    if (!cadentialZone && phraseContext.sectionRole != SectionRole.bridgeLike) {
      return null;
    }

    final patternTag = _familyTag(SmartProgressionFamily.backdoorRecursivePrep);
    final arrivalRoman = _selectMajorArrivalRoman(
      phraseContext,
      request.sourceProfile,
    );
    final arrivalKind = _selectMajorArrivalChordKind(
      phraseContext,
      request.sourceProfile,
    );
    final useExtendedPrep =
        request.sourceProfile == SourceProfile.recordingInspired &&
        (phraseContext.phraseRole == PhraseRole.release ||
            phraseContext.sectionRole == SectionRole.tag) &&
        random.nextInt(100) < 52;
    final variantTag = useExtendedPrep
        ? 'flatIII_flatVI_recursive_backdoor'
        : 'flatVI_recursive_backdoor';
    return _family(
      family: SmartProgressionFamily.backdoorRecursivePrep,
      destination: arrivalRoman,
      modalCandidates: useExtendedPrep
          ? const [
              RomanNumeralId.borrowedFlatIIIMaj7,
              RomanNumeralId.borrowedFlatVIMaj7,
              RomanNumeralId.borrowedIvMin7,
              RomanNumeralId.borrowedFlatVII7,
            ]
          : const [
              RomanNumeralId.borrowedFlatVIMaj7,
              RomanNumeralId.borrowedIvMin7,
              RomanNumeralId.borrowedFlatVII7,
            ],
      queue: [
        if (useExtendedPrep)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.borrowedFlatIIIMaj7,
            patternTag: patternTag,
            variantTag: variantTag,
            surfaceTags: const ['backdoorFlavor'],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.predominantToDominant,
                targetLabel: 'ivm backdoor chain',
                deadline: 3,
                severity: 1,
              ),
            ],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedFlatVIMaj7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['backdoorFlavor'],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.predominantToDominant,
              targetLabel: 'bVII backdoor dominant',
              deadline: 2,
              severity: 2,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedIvMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['backdoorFlavor'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedFlatVII7,
          dominantContext: DominantContext.backdoor,
          dominantIntent: DominantIntent.backdoor,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.predominantToDominant],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'I backdoor arrival',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: const ['backdoorFlavor'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: arrivalRoman,
          plannedChordKind: arrivalKind,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          surfaceTags: arrivalKind == PlannedChordKind.tonicSix
              ? const ['backdoorFlavor', 'tonicAdd6']
              : arrivalRoman == RomanNumeralId.iMaj69
              ? const ['backdoorFlavor', 'tonicMaj69']
              : const ['backdoorFlavor'],
        ),
      ],
    );
  }

  static _FamilyPlan? _buildClassicalPredominantColorFamily({
    required Random random,
    required SmartStepRequest request,
  }) {
    if (request.currentKeyCenter.mode != KeyMode.major ||
        !request.modalInterchangeEnabled) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final cadentialZone =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final bridgeContinuation =
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        phraseContext.phraseRole == PhraseRole.continuation;
    if (!cadentialZone && !bridgeContinuation) {
      return null;
    }

    final patternTag = _familyTag(
      SmartProgressionFamily.classicalPredominantColor,
    );
    final arrivalRoman = _selectMajorArrivalRoman(
      phraseContext,
      request.sourceProfile,
    );
    final arrivalKind = _selectMajorArrivalChordKind(
      phraseContext,
      request.sourceProfile,
    );
    final useAug6Inspired =
        request.sourceProfile == SourceProfile.recordingInspired &&
        (phraseContext.phraseRole == PhraseRole.cadence ||
            phraseContext.sectionRole == SectionRole.bridgeLike) &&
        random.nextInt(100) < 42;
    final useSusRelease =
        !useAug6Inspired &&
        request.sourceProfile == SourceProfile.recordingInspired &&
        phraseContext.phraseRole != PhraseRole.release &&
        random.nextInt(100) < 48;
    final variantTag = useAug6Inspired
        ? 'aug6_inspired_predominant'
        : useSusRelease
        ? 'neapolitan_sus_release'
        : 'neapolitan_predominant';
    final predominantTags = useAug6Inspired
        ? const ['aug6Predominant', 'rareColor']
        : const ['neapolitanPredominant', 'rareColor'];

    return _family(
      family: SmartProgressionFamily.classicalPredominantColor,
      destination: arrivalRoman,
      modalCandidates: const [RomanNumeralId.borrowedFlatIIMaj7],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.borrowedFlatIIMaj7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: predominantTags,
          openedDebts: [
            ResolutionDebt(
              debtType: ResolutionDebtType.rareColorPayoff,
              targetLabel: 'authentic dominant payoff',
              deadline: useSusRelease ? 3 : 2,
              severity: 3,
            ),
            const ResolutionDebt(
              debtType: ResolutionDebtType.predominantToDominant,
              targetLabel: 'dominant arrival after predominant color',
              deadline: 2,
              severity: 2,
            ),
          ],
        ),
        if (useSusRelease)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.susDominant,
            dominantIntent: DominantIntent.susDelay,
            patternTag: patternTag,
            variantTag: variantTag,
            surfaceTags: [...predominantTags, 'susDelay'],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.susResolve,
                targetLabel: 'same-root dominant release',
                deadline: 1,
                severity: 2,
              ),
            ],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: [
            ResolutionDebtType.rareColorPayoff,
            ResolutionDebtType.predominantToDominant,
            if (useSusRelease) ResolutionDebtType.susResolve,
          ],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'classical predominant cadence',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: predominantTags,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: arrivalRoman,
          plannedChordKind: arrivalKind,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          surfaceTags: arrivalKind == PlannedChordKind.tonicSix
              ? [...predominantTags, 'tonicAdd6']
              : arrivalRoman == RomanNumeralId.iMaj69
              ? [...predominantTags, 'tonicMaj69']
              : predominantTags,
        ),
      ],
    );
  }

  static _FamilyPlan? _buildMixturePivotModulationFamily({
    required SmartStepRequest request,
    required KeyCenter targetCenter,
  }) {
    if (!request.modalInterchangeEnabled ||
        targetCenter.relationToParent != KeyRelation.parallel) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final cadentialZone =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final bridgeContinuation =
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        phraseContext.phraseRole == PhraseRole.continuation;
    if (!cadentialZone && !bridgeContinuation) {
      return null;
    }

    final pivot = _findMixturePivotChord(
      currentCenter: request.currentKeyCenter,
      targetCenter: targetCenter,
      currentRomanNumeralId: request.currentRomanNumeralId,
    );
    if (pivot == null) {
      return null;
    }

    final patternTag = _familyTag(
      SmartProgressionFamily.mixturePivotModulation,
    );
    final variantTag =
        'mixture_${request.currentKeyCenter.mode.name}_to_${targetCenter.mode.name}_${targetCenter.relationToParent.name}';
    final rawCadence = _cadenceQueueForTarget(
      targetCenter: targetCenter.copyWith(enteredBy: CenterEntryMethod.pivot),
      patternTag: patternTag,
      variantTag: variantTag,
      modulationAttempt: true,
    );
    if (rawCadence.isEmpty) {
      return null;
    }

    final skipsCadenceHead = _sharesChordIdentity(
      firstCenter: request.currentKeyCenter,
      firstRoman: pivot.finalRomanNumeralId,
      secondCenter: targetCenter,
      secondRoman: rawCadence.first.finalRomanNumeralId,
    );
    final cadence = skipsCadenceHead ? rawCadence.skip(1).toList() : rawCadence;
    if (cadence.isEmpty) {
      return null;
    }
    final arrival = cadence.firstWhere(
      (item) => item.cadentialArrival,
      orElse: () => cadence.last,
    );
    final pivotTags = <String>['mixturePivot', 'parallelPivot'];
    final modalCandidates = request.currentKeyCenter.mode == KeyMode.major
        ? const [
            RomanNumeralId.borrowedIiHalfDiminished7,
            RomanNumeralId.borrowedIvMin7,
            RomanNumeralId.borrowedFlatIIIMaj7,
            RomanNumeralId.borrowedFlatVIMaj7,
          ]
        : const <RomanNumeralId>[];
    return _family(
      family: SmartProgressionFamily.mixturePivotModulation,
      destination: arrival.finalRomanNumeralId,
      modalCandidates: modalCandidates,
      modulationCandidates: [targetCenter],
      queue: [
        pivot.copyWith(
          patternTag: patternTag,
          variantTag: variantTag,
          modulationAttempt: true,
          modulationConfidence: targetCenter.confidence,
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.pivotArea,
            confidence: targetCenter.confidence,
            expiresIn: 2,
          ),
          openedDebts: skipsCadenceHead
              ? rawCadence.first.openedDebts
              : const [],
          surfaceTags: [...pivot.surfaceTags, ...pivotTags],
        ),
        ...cadence,
      ],
    );
  }

  static _FamilyPlan? _buildChromaticMediantCommonToneModulationFamily({
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
  }) {
    if (request.jazzPreset != JazzPreset.advanced ||
        !request.modalInterchangeEnabled ||
        request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final cadentialZone =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final bridgeContinuation =
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        phraseContext.phraseRole == PhraseRole.continuation;
    if (!cadentialZone && !bridgeContinuation) {
      return null;
    }

    final targetCenter = _supportedChromaticMediantTargetForRequest(
      request: request,
      candidates: opportunity.candidates,
    );
    if (targetCenter == null) {
      return null;
    }
    final pivotRoman = _chromaticMediantPivotRomanForTarget(
      currentCenter: request.currentKeyCenter,
      targetCenter: targetCenter,
    );
    if (pivotRoman == null || request.currentRomanNumeralId == pivotRoman) {
      return null;
    }

    final patternTag = _familyTag(
      SmartProgressionFamily.chromaticMediantCommonToneModulation,
    );
    final pivotVariant = pivotRoman == RomanNumeralId.borrowedFlatIIIMaj7
        ? 'flatIII'
        : 'flatVI';
    final variantTag =
        'chromatic_mediant_${pivotVariant}_${targetCenter.tonicName}_${targetCenter.mode.name}';
    final enteredTargetCenter = targetCenter.copyWith(
      enteredBy: CenterEntryMethod.commonTone,
    );
    final rawCadence = _cadenceQueueForTarget(
      targetCenter: enteredTargetCenter,
      patternTag: patternTag,
      variantTag: variantTag,
      modulationAttempt: true,
    );
    if (rawCadence.isEmpty) {
      return null;
    }
    final arrival = rawCadence.firstWhere(
      (item) => item.cadentialArrival,
      orElse: () => rawCadence.last,
    );
    final pivotTags = <String>[
      'chromaticMediant',
      'rareColor',
      'commonTonePivot',
    ];
    final returnHomeDebts = _returnHomeDebtsForAwayArrival(
      request: request,
      finalTargetCenter: enteredTargetCenter,
    );
    final cadenceHead = rawCadence.first.copyWith(
      surfaceTags: [...rawCadence.first.surfaceTags, 'chromaticMediantResolve'],
      satisfiedDebtTypes: [
        ...rawCadence.first.satisfiedDebtTypes,
        ResolutionDebtType.rareColorPayoff,
      ],
    );
    final cadenceTail = [
      for (final item in rawCadence.skip(1))
        item.cadentialArrival
            ? item.copyWith(
                surfaceTags: [
                  ...item.surfaceTags,
                  if (returnHomeDebts.isNotEmpty) 'returnHomePending',
                ],
                openedDebts: [...item.openedDebts, ...returnHomeDebts],
              )
            : item,
    ];
    return _family(
      family: SmartProgressionFamily.chromaticMediantCommonToneModulation,
      destination: arrival.finalRomanNumeralId,
      modalCandidates: [pivotRoman],
      modulationCandidates: [enteredTargetCenter],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: pivotRoman,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationAttempt: true,
          modulationConfidence: targetCenter.confidence,
          openScope: LocalScope(
            center: enteredTargetCenter,
            headType: ScopeHeadType.pivotArea,
            confidence: targetCenter.confidence,
            expiresIn: 2,
          ),
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.rareColorPayoff,
              targetLabel: 'chromatic mediant cadence payoff',
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: pivotTags,
        ),
        cadenceHead,
        ...cadenceTail,
      ],
    );
  }

  static _FamilyPlan? _buildColtraneBurstFamily({
    required SmartStepRequest request,
    required _ModulationOpportunity opportunity,
  }) {
    if (request.jazzPreset != JazzPreset.advanced ||
        request.modulationIntensity != ModulationIntensity.high ||
        request.currentKeyCenter.mode != KeyMode.major) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final cadentialZone =
        phraseContext.phraseRole == PhraseRole.preCadence ||
        phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release;
    final bridgeContinuation =
        phraseContext.sectionRole == SectionRole.bridgeLike &&
        phraseContext.phraseRole == PhraseRole.continuation;
    if (!cadentialZone && !bridgeContinuation) {
      return null;
    }

    final targets = _coltraneBurstTargetsForRequest(request);
    if (targets.length < 2) {
      return null;
    }
    final firstTarget = targets.first;
    final secondTarget = targets[1];
    final opportunityCoversTargets =
        opportunity.candidates.any((candidate) => candidate == firstTarget) &&
        opportunity.candidates.any((candidate) => candidate == secondTarget);
    if (!opportunityCoversTargets) {
      return null;
    }

    final patternTag = _familyTag(SmartProgressionFamily.coltraneBurst);
    final variantTag =
        'cycle_${request.currentKeyCenter.tonicName}_${firstTarget.tonicName}_${secondTarget.tonicName}';
    final firstCadence = _cadenceQueueForTarget(
      targetCenter: firstTarget.copyWith(
        enteredBy: CenterEntryMethod.symmetric,
      ),
      patternTag: patternTag,
      variantTag: variantTag,
      modulationAttempt: true,
    );
    final secondCadence = _cadenceQueueForTarget(
      targetCenter: secondTarget.copyWith(
        enteredBy: CenterEntryMethod.symmetric,
      ),
      patternTag: patternTag,
      variantTag: variantTag,
      modulationAttempt: true,
    );
    if (firstCadence.length < 3 || secondCadence.length < 4) {
      return null;
    }

    const cycleTags = <String>['coltraneBurst', 'symmetricCycle'];
    final returnHomeDebts = _returnHomeDebtsForAwayArrival(
      request: request,
      finalTargetCenter: secondTarget,
    );
    final firstScope = LocalScope(
      center: firstTarget,
      headType: ScopeHeadType.pivotArea,
      confidence: firstTarget.confidence,
      expiresIn: 3,
    );
    final secondScope = LocalScope(
      center: secondTarget,
      headType: ScopeHeadType.pivotArea,
      confidence: secondTarget.confidence,
      expiresIn: 4,
    );

    return _family(
      family: SmartProgressionFamily.coltraneBurst,
      destination: secondCadence[2].finalRomanNumeralId,
      modulationCandidates: [firstTarget, secondTarget],
      queue: [
        firstCadence[0].copyWith(
          openScope: firstScope,
          openedDebts: const [],
          surfaceTags: [
            ...firstCadence[0].surfaceTags,
            ...cycleTags,
            'cycleOne',
          ],
        ),
        firstCadence[1].copyWith(
          surfaceTags: [
            ...firstCadence[1].surfaceTags,
            ...cycleTags,
            'cycleOne',
          ],
        ),
        firstCadence[2].copyWith(
          postModulationConfirmationsRemaining: 0,
          surfaceTags: [
            ...firstCadence[2].surfaceTags,
            ...cycleTags,
            'cycleOneArrival',
          ],
        ),
        secondCadence[0].copyWith(
          openScope: secondScope,
          surfaceTags: [
            ...secondCadence[0].surfaceTags,
            ...cycleTags,
            'cycleTwo',
          ],
        ),
        secondCadence[1].copyWith(
          surfaceTags: [
            ...secondCadence[1].surfaceTags,
            ...cycleTags,
            'cycleTwo',
          ],
        ),
        secondCadence[2].copyWith(
          surfaceTags: [
            ...secondCadence[2].surfaceTags,
            ...cycleTags,
            'cycleTwoArrival',
            if (returnHomeDebts.isNotEmpty) 'returnHomePending',
          ],
          openedDebts: [...secondCadence[2].openedDebts, ...returnHomeDebts],
        ),
        secondCadence[3].copyWith(
          surfaceTags: [
            ...secondCadence[3].surfaceTags,
            ...cycleTags,
            'cycleConfirmation',
          ],
        ),
      ],
    );
  }

  static _FamilyPlan? _buildBridgeReturnHomeCadenceFamily({
    required SmartStepRequest request,
    required KeyCenter targetCenter,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final returnHomeDebt = _returnHomeDebtForRequest(request);
    final pendingReturnFollowthrough = returnHomeDebt != null;
    if (!_isBridgeReturnWindowForDebt(
          phraseContext,
          returnHomeDebt: returnHomeDebt,
        ) ||
        targetCenter == request.currentKeyCenter) {
      return null;
    }
    final patternTag = _familyTag(
      SmartProgressionFamily.bridgeReturnHomeCadence,
    );
    final variantTag =
        'return_${request.currentKeyCenter.mode.name}_${request.currentKeyCenter.tonicName}_to_${targetCenter.mode.name}_${targetCenter.tonicName}';
    final enteredTargetCenter = targetCenter.copyWith(
      enteredBy: CenterEntryMethod.cadenceModulation,
    );
    final preferBackdoorReturn =
        pendingReturnFollowthrough &&
        enteredTargetCenter.mode == KeyMode.major &&
        request.modalInterchangeEnabled &&
        _dominantIntentOverflow(request) > 0;
    if (preferBackdoorReturn) {
      return _family(
        family: SmartProgressionFamily.bridgeReturnHomeCadence,
        destination: RomanNumeralId.iMaj69,
        modulationCandidates: [enteredTargetCenter],
        queue: [
          _queuedChord(
            keyCenter: enteredTargetCenter,
            roman: RomanNumeralId.borrowedIvMin7,
            patternTag: patternTag,
            variantTag: '${variantTag}_backdoor',
            modulationKind: ModulationKind.real,
            modulationAttempt: true,
            modulationConfidence: enteredTargetCenter.confidence,
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.modulationConfirm,
                targetLabel: 'new-key confirmation',
                deadline: 3,
                severity: 3,
              ),
            ],
            surfaceTags: [
              'bridgeReturn',
              'backdoorFlavor',
              if (pendingReturnFollowthrough) 'returnHomeFollowthrough',
            ],
          ),
          _queuedChord(
            keyCenter: enteredTargetCenter,
            roman: RomanNumeralId.borrowedFlatVII7,
            patternTag: patternTag,
            variantTag: '${variantTag}_backdoor',
            modulationKind: ModulationKind.real,
            modulationConfidence: enteredTargetCenter.confidence,
            surfaceTags: [
              'bridgeReturn',
              'backdoorFlavor',
              if (pendingReturnFollowthrough) 'returnHomeFollowthrough',
            ],
          ),
          _queuedChord(
            keyCenter: enteredTargetCenter,
            roman: RomanNumeralId.iMaj69,
            patternTag: patternTag,
            variantTag: '${variantTag}_backdoor',
            modulationKind: ModulationKind.real,
            modulationConfidence: enteredTargetCenter.confidence,
            cadentialArrival: true,
            postModulationConfirmationsRemaining: 1,
            satisfiedDebtTypes: const [ResolutionDebtType.returnHomeCadence],
            surfaceTags: const [
              'bridgeReturn',
              'returnHomePayoff',
              'tonicMaj69',
            ],
          ),
          _queuedChord(
            keyCenter: enteredTargetCenter,
            roman: RomanNumeralId.viMin7,
            patternTag: patternTag,
            variantTag: '${variantTag}_backdoor',
            modulationKind: ModulationKind.real,
            modulationConfidence: enteredTargetCenter.confidence,
            satisfiedDebtTypes: const [ResolutionDebtType.modulationConfirm],
            surfaceTags: const ['bridgeReturn'],
          ),
        ],
      );
    }
    final cadence = _cadenceQueueForTarget(
      targetCenter: enteredTargetCenter,
      patternTag: patternTag,
      variantTag: variantTag,
      modulationAttempt: true,
    );
    if (cadence.isEmpty) {
      return null;
    }
    var resolvedCadence = [
      for (final chord in cadence)
        chord.copyWith(
          surfaceTags: [
            ...chord.surfaceTags,
            'bridgeReturn',
            if (pendingReturnFollowthrough) 'returnHomeFollowthrough',
            if (chord.cadentialArrival) 'returnHomePayoff',
          ],
          satisfiedDebtTypes: chord.cadentialArrival
              ? [
                  ...chord.satisfiedDebtTypes,
                  ResolutionDebtType.returnHomeCadence,
                ]
              : chord.satisfiedDebtTypes,
        ),
    ];
    if (pendingReturnFollowthrough &&
        request.currentHarmonicFunction == HarmonicFunction.predominant &&
        resolvedCadence.length >= 4) {
      final carriedHead = resolvedCadence[1].copyWith(
        modulationAttempt:
            resolvedCadence[0].modulationAttempt ||
            resolvedCadence[1].modulationAttempt,
        modulationConfidence: max(
          resolvedCadence[0].modulationConfidence,
          resolvedCadence[1].modulationConfidence,
        ),
        openedDebts: [
          ...resolvedCadence[0].openedDebts,
          ...resolvedCadence[1].openedDebts,
        ],
        surfaceTags: {
          ...resolvedCadence[0].surfaceTags,
          ...resolvedCadence[1].surfaceTags,
        }.toList(),
      );
      resolvedCadence = [carriedHead, ...resolvedCadence.skip(2)];
    }
    return _family(
      family: SmartProgressionFamily.bridgeReturnHomeCadence,
      destination: resolvedCadence.length >= 3
          ? resolvedCadence[2].finalRomanNumeralId
          : resolvedCadence.last.finalRomanNumeralId,
      modulationCandidates: [targetCenter],
      queue: resolvedCadence,
    );
  }

  static _FamilyPlan? _buildBridgeIVStabilizedByLocalIiVIFamily({
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
    final phraseContext = _phraseContextForRequest(request);
    final activeScope = request.currentTrace?.activeLocalScope;
    final hasSubdominantScope =
        activeScope?.center.relationToParent == KeyRelation.subdominant;
    if (phraseContext.sectionRole != SectionRole.bridgeLike &&
        !hasSubdominantScope &&
        random.nextInt(100) >= 18) {
      return null;
    }

    final patternTag = _familyTag(
      SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI,
    );
    final localIvCenter = KeyCenter(
      tonicName: MusicTheory.resolveChordRootForCenter(
        request.currentKeyCenter,
        RomanNumeralId.ivMaj7,
      ),
      mode: KeyMode.major,
      relationToParent: KeyRelation.subdominant,
      enteredBy: CenterEntryMethod.tonicization,
      confidence: 0.68,
      confirmationsRemaining: 1,
    );
    final useSubstitute =
        !request.secondaryDominantEnabled && request.substituteDominantEnabled;
    final useSusRelease =
        !useSubstitute &&
        request.sourceProfile == SourceProfile.recordingInspired &&
        phraseContext.phraseRole != PhraseRole.release;
    final dominantRoman = useSubstitute
        ? RomanNumeralId.substituteOfIV
        : RomanNumeralId.secondaryOfIV;
    final dominantContext = useSubstitute
        ? DominantContext.tritoneSubstitute
        : useSusRelease
        ? DominantContext.susDominant
        : DominantContext.secondaryToMajor;
    final dominantIntent = useSubstitute
        ? DominantIntent.tritoneSub
        : useSusRelease
        ? DominantIntent.susDelay
        : DominantIntent.secondaryToMajor;
    final variantTag = useSubstitute
        ? 'bridge_local_ii_subv_i'
        : useSusRelease
        ? 'bridge_local_ii_v_sus_release_i'
        : 'bridge_local_ii_v_i';
    final arrivalQuality =
        request.sourceProfile == SourceProfile.recordingInspired
        ? ChordQuality.major69
        : ChordQuality.major7;

    return _family(
      family: SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI,
      destination: RomanNumeralId.ivMaj7,
      appliedCandidates: [dominantRoman],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.relatedIiOfIV,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          openScope: LocalScope(
            center: localIvCenter,
            headType: ScopeHeadType.pivotArea,
            confidence: 0.62,
            expiresIn: 4,
          ),
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.predominantToDominant,
              targetLabel: 'V7/IV',
              deadline: 2,
              severity: 2,
            ),
          ],
          surfaceTags: const ['bridgeIVArea'],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: dominantRoman,
          appliedType: _appliedTypeForRoman(dominantRoman),
          resolutionTargetRomanId: RomanNumeralId.ivMaj7,
          renderQualityOverride: useSubstitute
              ? ChordQuality.dominant7Sharp11
              : useSusRelease
              ? ChordQuality.dominant13sus4
              : null,
          dominantContext: dominantContext,
          dominantIntent: dominantIntent,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          satisfiedDebtTypes: const [ResolutionDebtType.predominantToDominant],
          openedDebts: useSubstitute
              ? const [
                  ResolutionDebt(
                    debtType: ResolutionDebtType.dominantResolve,
                    targetLabel: 'IV local arrival',
                    deadline: 1,
                    severity: 2,
                  ),
                ]
              : const [
                  ResolutionDebt(
                    debtType: ResolutionDebtType.susResolve,
                    targetLabel: 'same-root V7/IV release',
                    deadline: 1,
                    severity: 2,
                  ),
                ],
          surfaceTags: useSubstitute
              ? const ['bridgeIVArea', 'tritoneSub']
              : useSusRelease
              ? const ['bridgeIVArea', 'susDelay']
              : const ['bridgeIVArea'],
        ),
        if (useSusRelease)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.secondaryOfIV,
            appliedType: AppliedType.secondary,
            resolutionTargetRomanId: RomanNumeralId.ivMaj7,
            dominantContext: DominantContext.secondaryToMajor,
            dominantIntent: DominantIntent.secondaryToMajor,
            patternTag: patternTag,
            variantTag: variantTag,
            modulationKind: ModulationKind.tonicization,
            satisfiedDebtTypes: const [ResolutionDebtType.susResolve],
            openedDebts: const [
              ResolutionDebt(
                debtType: ResolutionDebtType.dominantResolve,
                targetLabel: 'IV local arrival',
                deadline: 1,
                severity: 2,
              ),
            ],
            surfaceTags: const ['bridgeIVArea'],
          ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.ivMaj7,
          renderQualityOverride: arrivalQuality,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          cadentialArrival: true,
          openScope: LocalScope(
            center: localIvCenter.copyWith(confirmationsRemaining: 1),
            headType: ScopeHeadType.tonicHead,
            confidence: 0.76,
            expiresIn: 2,
          ),
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          surfaceTags: [
            'bridgeIVArea',
            'localIVStabilized',
            if (arrivalQuality == ChordQuality.major69) 'tonicMaj69',
          ],
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
    final patternTag = _familyTag(
      SmartProgressionFamily.dominantChainBridgeStyle,
    );
    final phraseContext = _phraseContextForRequest(request);
    final variantTag = phraseContext.sectionRole == SectionRole.bridgeLike
        ? 'bridge_long_chain'
        : 'dominant_chain';
    final useSubstituteLead =
        request.substituteDominantEnabled && random.nextInt(100) < 12;
    final inferredHomeCenter = _returnHomeTargetCenterForRequest(request);
    final opensReturnHomeDebt =
        inferredHomeCenter != null &&
        inferredHomeCenter != request.currentKeyCenter &&
        (phraseContext.sectionRole == SectionRole.bridgeLike ||
            phraseContext.sectionRole == SectionRole.turnaroundTail ||
            phraseContext.sectionRole == SectionRole.tag);
    final initialScope = LocalScope(
      center: KeyCenter(
        tonicName: MusicTheory.resolveChordRootForCenter(
          request.currentKeyCenter,
          RomanNumeralId.iiiMin7,
        ),
        mode: KeyMode.minor,
      ),
      headType: ScopeHeadType.dominantHead,
      confidence: 0.64,
      expiresIn: 2,
    );
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
          roman: useSubstituteLead
              ? RomanNumeralId.substituteOfIII
              : RomanNumeralId.secondaryOfIII,
          appliedType: useSubstituteLead
              ? AppliedType.substitute
              : AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.iiiMin7,
          dominantContext: useSubstituteLead
              ? DominantContext.tritoneSubstitute
              : DominantContext.secondaryToMinor,
          dominantIntent: useSubstituteLead
              ? DominantIntent.tritoneSub
              : DominantIntent.dominantHeadedScope,
          patternTag: patternTag,
          variantTag: variantTag,
          openScope: initialScope,
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: 'bridge dominant chain',
              deadline: 4,
              severity: 2,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfVI,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.viMin7,
          dominantContext: DominantContext.secondaryToMinor,
          dominantIntent: DominantIntent.secondaryToMinor,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfII,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.iiMin7,
          dominantContext: DominantContext.secondaryToMinor,
          dominantIntent: DominantIntent.secondaryToMinor,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.secondaryOfV,
          appliedType: AppliedType.secondary,
          resolutionTargetRomanId: RomanNumeralId.vDom7,
          dominantContext: DominantContext.dominantIILydian,
          dominantIntent: DominantIntent.lydianDominant,
          patternTag: patternTag,
          variantTag: variantTag,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: patternTag,
          variantTag: variantTag,
          cadentialArrival: true,
          surfaceTags: [
            'tonicMaj69',
            if (opensReturnHomeDebt) 'returnHomePending',
          ],
          openedDebts: opensReturnHomeDebt
              ? [
                  ResolutionDebt(
                    debtType: ResolutionDebtType.returnHomeCadence,
                    targetLabel: inferredHomeCenter.displayName,
                    deadline: 4,
                    severity: 3,
                  ),
                ]
              : const [],
          closeScope: true,
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
    final patternTag = _familyTag(
      SmartProgressionFamily.appliedDominantWithRelatedIi,
    );
    RomanNumeralId relatedIi;
    RomanNumeralId targetRoman;
    RomanNumeralId dominantRoman;
    DominantContext dominantContext;
    DominantIntent dominantIntent;
    if (targetRoll < 35) {
      relatedIi = RomanNumeralId.iiiMin7;
      targetRoman = RomanNumeralId.iiMin7;
      dominantRoman =
          request.substituteDominantEnabled && random.nextInt(100) < 16
          ? RomanNumeralId.substituteOfII
          : RomanNumeralId.secondaryOfII;
      dominantContext = dominantRoman == RomanNumeralId.substituteOfII
          ? DominantContext.tritoneSubstitute
          : DominantContext.secondaryToMinor;
      dominantIntent = dominantRoman == RomanNumeralId.substituteOfII
          ? DominantIntent.tritoneSub
          : DominantIntent.secondaryToMinor;
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
      dominantIntent = dominantRoman == RomanNumeralId.substituteOfVI
          ? DominantIntent.tritoneSub
          : DominantIntent.secondaryToMinor;
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
      dominantIntent = dominantRoman == RomanNumeralId.substituteOfIII
          ? DominantIntent.tritoneSub
          : DominantIntent.secondaryToMinor;
    }

    final appliedType = _appliedTypeForRoman(dominantRoman);
    final targetMode = _appliedTargetMode(
      request.currentKeyCenter,
      targetRoman,
    );
    final targetRoot = MusicTheory.resolveChordRootForCenter(
      request.currentKeyCenter,
      targetRoman,
    );
    final scope = LocalScope(
      center: KeyCenter(tonicName: targetRoot, mode: targetMode),
      headType: ScopeHeadType.dominantHead,
      confidence: 0.66,
      expiresIn: 3,
    );
    final variantTag =
        'ii_v_of_${MusicTheory.romanTokenOf(targetRoman).replaceAll('maj7', '').replaceAll('7', '').replaceAll('/', '_')}';
    return _family(
      family: SmartProgressionFamily.appliedDominantWithRelatedIi,
      destination: targetRoman,
      appliedCandidates: [dominantRoman],
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: relatedIi,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          openScope: scope,
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: dominantRoman,
          appliedType: appliedType,
          resolutionTargetRomanId: targetRoman,
          dominantContext: dominantContext,
          dominantIntent: dominantIntent,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          openedDebts: [
            ResolutionDebt(
              debtType: ResolutionDebtType.dominantResolve,
              targetLabel: MusicTheory.romanTokenOf(targetRoman),
              deadline: 1,
              severity: 2,
            ),
          ],
          surfaceTags: dominantIntent == DominantIntent.tritoneSub
              ? const ['tritoneSub']
              : const [],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: targetRoman,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.tonicization,
          satisfiedDebtTypes: const [ResolutionDebtType.dominantResolve],
          closeScope: true,
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
    final patternTag = _familyTag(SmartProgressionFamily.passingDimToIi);
    final handoffToPredominant = _dominantIntentOverflow(request) > 0;
    final variantTag = handoffToPredominant
        ? 'i_sharpIdim_ii_handoff'
        : 'i_sharpIdim_ii_v';
    return _family(
      family: SmartProgressionFamily.passingDimToIi,
      destination: RomanNumeralId.iiMin7,
      queue: [
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.sharpIDim7,
          patternTag: patternTag,
          variantTag: variantTag,
          surfaceTags: const ['commonToneDim', 'rareColor'],
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.rareColorPayoff,
              targetLabel: 'ii arrival',
              deadline: 1,
              severity: 2,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: request.currentKeyCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          satisfiedDebtTypes: const [ResolutionDebtType.rareColorPayoff],
          surfaceTags: handoffToPredominant
              ? const ['predominantHandoff']
              : const [],
        ),
        if (!handoffToPredominant)
          _queuedChord(
            keyCenter: request.currentKeyCenter,
            roman: RomanNumeralId.vDom7,
            dominantContext: DominantContext.primaryMajor,
            dominantIntent: DominantIntent.primaryAuthenticMajor,
            patternTag: patternTag,
            variantTag: variantTag,
          ),
      ],
    );
  }

  static _FamilyPlan? _buildCadenceBasedRealModulationFamily({
    required KeyCenter targetCenter,
  }) {
    final cadence = _cadenceQueueForTarget(
      targetCenter: targetCenter.copyWith(
        enteredBy: CenterEntryMethod.cadenceModulation,
      ),
      patternTag: _familyTag(SmartProgressionFamily.cadenceBasedRealModulation),
      variantTag:
          'cadence_${targetCenter.relationToParent.name}_${targetCenter.mode.name}',
      modulationAttempt: true,
    );
    if (cadence.isEmpty) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.cadenceBasedRealModulation,
      destination: cadence.length >= 3
          ? cadence[2].finalRomanNumeralId
          : cadence.last.finalRomanNumeralId,
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
      targetCenter: targetCenter.copyWith(enteredBy: CenterEntryMethod.pivot),
      patternTag: _familyTag(SmartProgressionFamily.commonChordModulation),
      variantTag:
          'pivot_${targetCenter.relationToParent.name}_${targetCenter.mode.name}',
    );
    if (cadence.isEmpty) {
      return null;
    }
    return _family(
      family: SmartProgressionFamily.commonChordModulation,
      destination: cadence.length >= 3
          ? cadence[2].finalRomanNumeralId
          : cadence.last.finalRomanNumeralId,
      modulationCandidates: [targetCenter],
      queue: [
        pivot.copyWith(
          patternTag: _familyTag(SmartProgressionFamily.commonChordModulation),
          variantTag:
              'pivot_${targetCenter.relationToParent.name}_${targetCenter.mode.name}',
          modulationAttempt: true,
          modulationConfidence: targetCenter.confidence,
          openScope: LocalScope(
            center: targetCenter,
            headType: ScopeHeadType.pivotArea,
            confidence: targetCenter.confidence,
            expiresIn: 2,
          ),
        ),
        ...cadence,
      ],
    );
  }

  static QueuedSmartChord _queuedChord({
    required KeyCenter keyCenter,
    required RomanNumeralId roman,
    required String patternTag,
    String? variantTag,
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    ChordQuality? renderQualityOverride,
    bool suppressTensions = false,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
    ModulationKind modulationKind = ModulationKind.none,
    bool cadentialArrival = false,
    bool modulationAttempt = false,
    List<String> surfaceTags = const [],
    LocalScope? openScope,
    bool closeScope = false,
    List<ResolutionDebt> openedDebts = const [],
    List<ResolutionDebtType> satisfiedDebtTypes = const [],
    double modulationConfidence = 0,
    int postModulationConfirmationsRemaining = 0,
  }) {
    return QueuedSmartChord(
      keyCenter: keyCenter,
      finalRomanNumeralId: roman,
      plannedChordKind: plannedChordKind,
      patternTag: patternTag,
      variantTag: variantTag,
      renderQualityOverride: renderQualityOverride,
      suppressTensions: suppressTensions,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
      modulationKind: modulationKind,
      cadentialArrival: cadentialArrival,
      modulationAttempt: modulationAttempt,
      surfaceTags: surfaceTags,
      openScope: openScope,
      closeScope: closeScope,
      openedDebts: openedDebts,
      satisfiedDebtTypes: satisfiedDebtTypes,
      modulationConfidence: modulationConfidence,
      postModulationConfirmationsRemaining:
          postModulationConfirmationsRemaining,
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
    required String variantTag,
    bool modulationAttempt = false,
  }) {
    if (targetCenter.mode == KeyMode.major) {
      return [
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.iiMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.real,
          modulationAttempt: modulationAttempt,
          modulationConfidence: targetCenter.confidence,
          openedDebts: const [
            ResolutionDebt(
              debtType: ResolutionDebtType.modulationConfirm,
              targetLabel: 'new-key confirmation',
              deadline: 3,
              severity: 3,
            ),
          ],
        ),
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.vDom7,
          patternTag: patternTag,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          variantTag: variantTag,
          modulationKind: ModulationKind.real,
          modulationConfidence: targetCenter.confidence,
        ),
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.iMaj69,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.real,
          cadentialArrival: true,
          modulationConfidence: targetCenter.confidence,
          postModulationConfirmationsRemaining: 1,
          surfaceTags: const ['tonicMaj69'],
        ),
        _queuedChord(
          keyCenter: targetCenter,
          roman: RomanNumeralId.viMin7,
          patternTag: patternTag,
          variantTag: variantTag,
          modulationKind: ModulationKind.real,
          modulationConfidence: targetCenter.confidence,
          satisfiedDebtTypes: const [ResolutionDebtType.modulationConfirm],
        ),
      ];
    }
    final tonic = _selectMinorArrivalFromContext(
      SourceProfile.fakebookStandard,
      SmartPhraseContext.rollingForm(0),
    );
    return [
      _queuedChord(
        keyCenter: targetCenter,
        roman: RomanNumeralId.iiHalfDiminishedMinor,
        patternTag: patternTag,
        variantTag: variantTag,
        modulationKind: ModulationKind.real,
        modulationAttempt: modulationAttempt,
        modulationConfidence: targetCenter.confidence,
        openedDebts: const [
          ResolutionDebt(
            debtType: ResolutionDebtType.modulationConfirm,
            targetLabel: 'new-key confirmation',
            deadline: 3,
            severity: 3,
          ),
        ],
      ),
      _queuedChord(
        keyCenter: targetCenter,
        roman: RomanNumeralId.vDom7,
        patternTag: patternTag,
        dominantContext: DominantContext.primaryMinor,
        dominantIntent: DominantIntent.primaryAuthenticMinor,
        variantTag: variantTag,
        modulationKind: ModulationKind.real,
        modulationConfidence: targetCenter.confidence,
      ),
      _queuedChord(
        keyCenter: targetCenter,
        roman: tonic,
        patternTag: patternTag,
        variantTag: variantTag,
        modulationKind: ModulationKind.real,
        cadentialArrival: true,
        modulationConfidence: targetCenter.confidence,
        postModulationConfirmationsRemaining: 1,
        surfaceTags: tonic == RomanNumeralId.iMinMaj7
            ? const ['tonicMinorMaj7']
            : const ['tonicMinor6'],
      ),
      _queuedChord(
        keyCenter: targetCenter,
        roman: RomanNumeralId.ivMin7Minor,
        patternTag: patternTag,
        variantTag: variantTag,
        modulationKind: ModulationKind.real,
        modulationConfidence: targetCenter.confidence,
        satisfiedDebtTypes: const [ResolutionDebtType.modulationConfirm],
      ),
    ];
  }

  static _ModulationOpportunity _modulationOpportunityForRequest({
    required SmartStepRequest request,
    required _PhrasePriority phrasePriority,
  }) {
    final phraseContext = _phraseContextForRequest(request);
    final hasRecentWideModulation = _recentPlanningTraces(take: 16).any(
      (trace) =>
          trace.modulationKind == ModulationKind.real &&
          (trace.finalKeyRelation == KeyRelation.mediant ||
              trace.finalKeyRelation == KeyRelation.distant),
    );
    if (request.activeKeys.length <= 1) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.singleActiveKey,
      );
    }
    if ((request.currentTrace?.postModulationConfirmationsRemaining ?? 0) > 0) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.insufficientConfirmationWindow,
      );
    }
    if (_surpriseBudgetMultiplier(request: request, modulation: true) <= 0) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.surpriseBudgetExhausted,
      );
    }
    final candidates = _compatibleTargetCenters(
      currentCenter: request.currentKeyCenter,
      activeKeys: request.activeKeys,
      jazzPreset: request.jazzPreset,
      phraseContext: phraseContext,
    );
    final onlyParallelCandidates =
        candidates.isNotEmpty &&
        candidates.every(
          (candidate) => candidate.relationToParent == KeyRelation.parallel,
        );
    if (hasRecentWideModulation &&
        request.jazzPreset != JazzPreset.standardsCore &&
        (candidates.isEmpty || onlyParallelCandidates)) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.recentDistantModulationLockout,
      );
    }
    if (candidates.isEmpty) {
      return const _ModulationOpportunity(
        candidates: [],
        blockedReason: SmartBlockedReason.noCompatibleKey,
      );
    }
    if ((phrasePriority == _PhrasePriority.low ||
            phraseContext.phraseRole == PhraseRole.opener ||
            phraseContext.phraseRole == PhraseRole.continuation) &&
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
    required SmartPhraseContext phraseContext,
  }) {
    final candidates = <KeyCenter>[];
    final recentRealModulations = _recentPlanningTraces(
      take: 16,
    ).where((trace) => trace.modulationKind == ModulationKind.real).toList();
    for (final key in activeKeys) {
      for (final mode in KeyMode.values) {
        final target = KeyCenter(tonicName: key, mode: mode);
        if (target == currentCenter) {
          continue;
        }
        final relation = MusicTheory.relationBetweenCenters(
          currentCenter,
          target,
        );
        if (!_relationAllowedForPreset(relation, jazzPreset)) {
          continue;
        }
        final confidence = _modulationConfidenceForTarget(
          currentCenter: currentCenter,
          targetCenter: target,
          phraseContext: phraseContext,
          jazzPreset: jazzPreset,
          recentRealModulations: recentRealModulations,
        );
        if (confidence <= 0) {
          continue;
        }
        candidates.add(
          target.copyWith(
            closenessClass: (confidence * 100).round(),
            relationToParent: relation,
            enteredBy: CenterEntryMethod.cadenceModulation,
            confidence: confidence,
            confirmationsRemaining: 2,
          ),
        );
      }
    }
    candidates.sort((a, b) => b.closenessClass.compareTo(a.closenessClass));
    return candidates;
  }

  static bool _relationAllowedForPreset(
    KeyRelation relation,
    JazzPreset jazzPreset,
  ) {
    return switch (jazzPreset) {
      JazzPreset.standardsCore =>
        relation == KeyRelation.relative ||
            relation == KeyRelation.dominant ||
            relation == KeyRelation.subdominant ||
            relation == KeyRelation.parallel,
      JazzPreset.modulationStudy => relation != KeyRelation.distant,
      JazzPreset.advanced => true,
    };
  }

  static double _modulationConfidenceForTarget({
    required KeyCenter currentCenter,
    required KeyCenter targetCenter,
    required SmartPhraseContext phraseContext,
    required JazzPreset jazzPreset,
    required List<SmartDecisionTrace> recentRealModulations,
  }) {
    final relation = MusicTheory.relationBetweenCenters(
      currentCenter,
      targetCenter,
    );
    var confidence = switch (relation) {
      KeyRelation.relative => 0.76,
      KeyRelation.dominant => 0.72,
      KeyRelation.subdominant => 0.7,
      KeyRelation.parallel => 0.64,
      KeyRelation.mediant => jazzPreset == JazzPreset.advanced ? 0.46 : 0.28,
      KeyRelation.distant => jazzPreset == JazzPreset.advanced ? 0.28 : 0.0,
      KeyRelation.same => 0.0,
    };
    if (confidence <= 0) {
      return 0;
    }
    confidence += switch (phraseContext.phraseRole) {
      PhraseRole.preCadence => 0.12,
      PhraseRole.cadence => 0.18,
      PhraseRole.release => 0.08,
      _ => -0.08,
    };
    if (phraseContext.sectionRole == SectionRole.bridgeLike) {
      confidence += 0.12;
    }
    if (phraseContext.sectionRole == SectionRole.tag &&
        relation != KeyRelation.relative) {
      confidence -= 0.08;
    }
    if (recentRealModulations.any(
      (trace) =>
          trace.finalKeyRelation == relation &&
          (relation == KeyRelation.mediant || relation == KeyRelation.distant),
    )) {
      confidence -= 0.2;
    }
    return (confidence.clamp(0.0, 0.98) as num).toDouble();
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

  static QueuedSmartChord? _findMixturePivotChord({
    required KeyCenter currentCenter,
    required KeyCenter targetCenter,
    required RomanNumeralId currentRomanNumeralId,
  }) {
    if (MusicTheory.relationBetweenCenters(currentCenter, targetCenter) !=
        KeyRelation.parallel) {
      return null;
    }
    final pivotPairs =
        currentCenter.mode == KeyMode.major &&
            targetCenter.mode == KeyMode.minor
        ? const <(RomanNumeralId, RomanNumeralId)>[
            (
              RomanNumeralId.borrowedIiHalfDiminished7,
              RomanNumeralId.iiHalfDiminishedMinor,
            ),
            (RomanNumeralId.borrowedIvMin7, RomanNumeralId.ivMin7Minor),
            (
              RomanNumeralId.borrowedFlatIIIMaj7,
              RomanNumeralId.flatIIIMaj7Minor,
            ),
            (RomanNumeralId.borrowedFlatVIMaj7, RomanNumeralId.flatVIMaj7Minor),
          ]
        : currentCenter.mode == KeyMode.minor &&
              targetCenter.mode == KeyMode.major
        ? const <(RomanNumeralId, RomanNumeralId)>[
            (RomanNumeralId.ivMin7Minor, RomanNumeralId.borrowedIvMin7),
            (
              RomanNumeralId.flatIIIMaj7Minor,
              RomanNumeralId.borrowedFlatIIIMaj7,
            ),
            (RomanNumeralId.flatVIMaj7Minor, RomanNumeralId.borrowedFlatVIMaj7),
            (
              RomanNumeralId.iiHalfDiminishedMinor,
              RomanNumeralId.borrowedIiHalfDiminished7,
            ),
          ]
        : const <(RomanNumeralId, RomanNumeralId)>[];
    for (final pair in pivotPairs) {
      if (pair.$1 == currentRomanNumeralId) {
        continue;
      }
      if (_sharesChordIdentity(
        firstCenter: currentCenter,
        firstRoman: pair.$1,
        secondCenter: targetCenter,
        secondRoman: pair.$2,
      )) {
        return _queuedChord(
          keyCenter: currentCenter,
          roman: pair.$1,
          patternTag: 'mixture_pivot_modulation',
        );
      }
    }
    return null;
  }

  static RomanNumeralId? _chromaticMediantPivotRomanForTarget({
    required KeyCenter currentCenter,
    required KeyCenter targetCenter,
  }) {
    if (currentCenter.mode != KeyMode.major ||
        targetCenter.mode != KeyMode.major ||
        targetCenter.relationToParent != KeyRelation.mediant) {
      return null;
    }
    final currentSemitone = currentCenter.tonicSemitone;
    final targetSemitone = targetCenter.tonicSemitone;
    if (currentSemitone == null || targetSemitone == null) {
      return null;
    }
    final semitoneDelta = (targetSemitone - currentSemitone + 12) % 12;
    if (semitoneDelta == 3) {
      return RomanNumeralId.borrowedFlatIIIMaj7;
    }
    if (semitoneDelta == 8) {
      return RomanNumeralId.borrowedFlatVIMaj7;
    }
    return null;
  }

  static KeyCenter? _supportedChromaticMediantTargetForRequest({
    required SmartStepRequest request,
    required List<KeyCenter> candidates,
  }) {
    final currentCenter = request.currentKeyCenter;
    for (final candidate in candidates) {
      if (_chromaticMediantPivotRomanForTarget(
            currentCenter: currentCenter,
            targetCenter: candidate,
          ) !=
          null) {
        return candidate;
      }
    }
    if (currentCenter.mode != KeyMode.major) {
      return null;
    }
    final phraseContext = _phraseContextForRequest(request);
    final recentRealModulations = _recentPlanningTraces(
      take: 16,
    ).where((trace) => trace.modulationKind == ModulationKind.real).toList();
    for (final activeKey in request.activeKeys) {
      if (activeKey == currentCenter.tonicName) {
        continue;
      }
      final fallbackTarget = KeyCenter(
        tonicName: activeKey,
        mode: KeyMode.major,
      );
      if (_chromaticMediantPivotRomanForTarget(
            currentCenter: currentCenter,
            targetCenter: fallbackTarget.copyWith(
              relationToParent: MusicTheory.relationBetweenCenters(
                currentCenter,
                fallbackTarget,
              ),
            ),
          ) ==
          null) {
        continue;
      }
      return fallbackTarget.copyWith(
        relationToParent: MusicTheory.relationBetweenCenters(
          currentCenter,
          fallbackTarget,
        ),
        enteredBy: CenterEntryMethod.commonTone,
        confidence: _modulationConfidenceForTarget(
          currentCenter: currentCenter,
          targetCenter: fallbackTarget,
          phraseContext: phraseContext,
          jazzPreset: request.jazzPreset,
          recentRealModulations: recentRealModulations,
        ),
        confirmationsRemaining: 2,
      );
    }
    return null;
  }

  static bool _hasColtraneCyclePotential(List<String> activeKeys) {
    final semitones = <int>{};
    for (final key in activeKeys) {
      final semitone = MusicTheory.keyTonicSemitone(key);
      if (semitone != null) {
        semitones.add(semitone);
      }
    }
    for (final semitone in semitones) {
      if (semitones.contains((semitone + 4) % 12) &&
          semitones.contains((semitone + 8) % 12)) {
        return true;
      }
    }
    return false;
  }

  static String? _activeKeyForSemitone({
    required int semitone,
    required List<String> activeKeys,
  }) {
    for (final key in activeKeys) {
      if (MusicTheory.keyTonicSemitone(key) == semitone) {
        return key;
      }
    }
    return null;
  }

  static List<KeyCenter> _coltraneBurstTargetsForRequest(
    SmartStepRequest request,
  ) {
    if (request.currentKeyCenter.mode != KeyMode.major) {
      return const [];
    }
    final currentSemitone = request.currentKeyCenter.tonicSemitone;
    if (currentSemitone == null) {
      return const [];
    }
    final phraseContext = _phraseContextForRequest(request);
    final recentRealModulations = _recentPlanningTraces(
      take: 16,
    ).where((trace) => trace.modulationKind == ModulationKind.real).toList();
    final targets = <KeyCenter>[];
    for (final semitone in [
      (currentSemitone + 4) % 12,
      (currentSemitone + 8) % 12,
    ]) {
      final key = _activeKeyForSemitone(
        semitone: semitone,
        activeKeys: request.activeKeys,
      );
      if (key == null) {
        return const [];
      }
      final target = KeyCenter(tonicName: key, mode: KeyMode.major);
      targets.add(
        target.copyWith(
          relationToParent: MusicTheory.relationBetweenCenters(
            targets.isEmpty ? request.currentKeyCenter : targets.last,
            target,
          ),
          enteredBy: CenterEntryMethod.symmetric,
          confidence: _modulationConfidenceForTarget(
            currentCenter: targets.isEmpty
                ? request.currentKeyCenter
                : targets.last,
            targetCenter: target,
            phraseContext: phraseContext,
            jazzPreset: request.jazzPreset,
            recentRealModulations: recentRealModulations,
          ),
          confirmationsRemaining: 2,
        ),
      );
    }
    return targets;
  }

  static KeyCenter? _inferredHomeCenterForRequest(SmartStepRequest request) {
    final traces = _recentPlanningTraces(take: 64);
    for (final trace in traces) {
      final isInitialSeed =
          trace.stepIndex == 0 &&
          (trace.decision == 'seeded-initial-tonic' ||
              trace.decision?.startsWith('seeded-initial-family:') == true);
      if (!isInitialSeed) {
        continue;
      }
      return _parseDisplayCenterLabel(
        label: trace.currentKeyCenter,
        activeKeys: request.activeKeys,
      );
    }
    return null;
  }

  static KeyCenter? _parseDisplayCenterLabel({
    required String label,
    required List<String> activeKeys,
  }) {
    final parts = label.split(' ');
    if (parts.length < 2) {
      return null;
    }
    final displayRoot = parts.first;
    final mode = KeyMode.values.firstWhere(
      (candidate) => candidate.name == parts.last,
      orElse: () => KeyMode.major,
    );
    final semitone = MusicTheory.noteToSemitone[displayRoot];
    if (semitone == null) {
      return null;
    }
    String? tonicName;
    for (final candidate in activeKeys) {
      if (MusicTheory.displayRootForKey(candidate) == displayRoot) {
        tonicName = candidate;
        break;
      }
      if (MusicTheory.keyTonicSemitone(candidate) == semitone) {
        tonicName ??= candidate;
      }
    }
    if (tonicName == null) {
      return null;
    }
    return KeyCenter(tonicName: tonicName, mode: mode);
  }

  static bool _sharesChordIdentity({
    required KeyCenter firstCenter,
    required RomanNumeralId firstRoman,
    required KeyCenter secondCenter,
    required RomanNumeralId secondRoman,
  }) {
    final firstSpec = MusicTheory.specFor(firstRoman);
    final secondSpec = MusicTheory.specFor(secondRoman);
    return firstSpec.quality == secondSpec.quality &&
        MusicTheory.resolveChordRootForCenter(firstCenter, firstRoman) ==
            MusicTheory.resolveChordRootForCenter(secondCenter, secondRoman);
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
    final phraseContext = SmartPhraseContext.rollingForm(stepIndex);
    if (phraseContext.barsToBoundary <= 1) {
      return _PhrasePriority.boundary;
    }
    if (phraseContext.barsToBoundary == 2) {
      return _PhrasePriority.cadence;
    }
    return _PhrasePriority.low;
  }

  static KeyCenter _selectInitialKeyCenter({
    required Random random,
    required List<KeyCenter> selectedKeyCenters,
    required JazzPreset jazzPreset,
    required SourceProfile sourceProfile,
  }) {
    if (selectedKeyCenters.isEmpty) {
      return const KeyCenter(tonicName: 'C', mode: KeyMode.major);
    }
    return selectedKeyCenters[random.nextInt(selectedKeyCenters.length)];
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

  static RomanNumeralId _selectMajorArrivalRoman(
    SmartPhraseContext phraseContext,
    SourceProfile sourceProfile,
  ) {
    if (phraseContext.phraseRole == PhraseRole.release &&
        sourceProfile == SourceProfile.recordingInspired) {
      return RomanNumeralId.iMaj7;
    }
    if (phraseContext.phraseRole == PhraseRole.cadence ||
        phraseContext.phraseRole == PhraseRole.release) {
      return RomanNumeralId.iMaj69;
    }
    return sourceProfile == SourceProfile.recordingInspired
        ? RomanNumeralId.iMaj69
        : RomanNumeralId.iMaj7;
  }

  static ChordQuality _selectRelativeMajorArrivalQuality(
    SmartPhraseContext phraseContext,
    SourceProfile sourceProfile,
  ) {
    if (phraseContext.phraseRole == PhraseRole.release &&
        sourceProfile == SourceProfile.recordingInspired) {
      return ChordQuality.six;
    }
    return (phraseContext.phraseRole == PhraseRole.cadence ||
            phraseContext.phraseRole == PhraseRole.release)
        ? ChordQuality.major69
        : ChordQuality.major7;
  }

  static PlannedChordKind _selectMajorArrivalChordKind(
    SmartPhraseContext phraseContext,
    SourceProfile sourceProfile,
  ) {
    if (phraseContext.phraseRole == PhraseRole.release &&
        sourceProfile == SourceProfile.recordingInspired) {
      return PlannedChordKind.tonicSix;
    }
    return PlannedChordKind.resolvedRoman;
  }

  static ChordQuality _selectRelativeMinorArrivalQuality(
    SmartPhraseContext phraseContext,
    SourceProfile sourceProfile,
  ) {
    return switch (phraseContext.phraseRole) {
      PhraseRole.release =>
        sourceProfile == SourceProfile.recordingInspired
            ? ChordQuality.minorMajor7
            : ChordQuality.minor6,
      PhraseRole.cadence => ChordQuality.minor6,
      PhraseRole.preCadence || PhraseRole.continuation => ChordQuality.minor7,
      PhraseRole.opener =>
        sourceProfile == SourceProfile.recordingInspired
            ? ChordQuality.minorMajor7
            : ChordQuality.minor7,
    };
  }

  static RomanNumeralId _selectMinorArrivalFromContext(
    SourceProfile profile,
    SmartPhraseContext phraseContext,
  ) {
    return switch (phraseContext.phraseRole) {
      PhraseRole.release =>
        profile == SourceProfile.recordingInspired
            ? RomanNumeralId.iMinMaj7
            : RomanNumeralId.iMin6,
      PhraseRole.cadence => RomanNumeralId.iMin6,
      PhraseRole.preCadence || PhraseRole.continuation => RomanNumeralId.iMin7,
      PhraseRole.opener =>
        profile == SourceProfile.recordingInspired
            ? RomanNumeralId.iMinMaj7
            : RomanNumeralId.iMin6,
    };
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
      RomanNumeralId.iiMin7 ||
      RomanNumeralId.iiiMin7 ||
      RomanNumeralId.viMin7 ||
      RomanNumeralId.relatedIiOfIII => KeyMode.minor,
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
      SmartProgressionFamily.relativeMinorReframe => 'relative_minor_reframe',
      SmartProgressionFamily.dominantHeadedScopeChain =>
        'dominant_headed_scope_chain',
      SmartProgressionFamily.closingPlagalAuthenticHybrid =>
        'closing_plagal_authentic_hybrid',
      SmartProgressionFamily.bridgeIVStabilizedByLocalIiVI =>
        'bridge_iv_stabilized_by_local_ii_v_i',
      SmartProgressionFamily.backdoorRecursivePrep => 'backdoor_recursive_prep',
      SmartProgressionFamily.classicalPredominantColor =>
        'classical_predominant_color',
      SmartProgressionFamily.mixturePivotModulation =>
        'mixture_pivot_modulation',
      SmartProgressionFamily.chromaticMediantCommonToneModulation =>
        'chromatic_mediant_common_tone_modulation',
      SmartProgressionFamily.coltraneBurst => 'coltrane_burst',
      SmartProgressionFamily.bridgeReturnHomeCadence =>
        'bridge_return_home_cadence',
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
