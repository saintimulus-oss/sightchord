part of '../../smart_generator_core.dart';

SmartCandidateComparison _compareVoiceLeadingCandidates({
  required Random random,
  required List<SmartRenderCandidate> candidates,
  GeneratedChord? previousChord,
  bool allowV7sus4 = true,
  Set<ChordQuality>? allowedRenderQualities,
  bool allowTensions = true,
  ChordLanguageLevel chordLanguageLevel = ChordLanguageLevel.fullExtensions,
  Set<String>? selectedTensionOptions,
  InversionSettings inversionSettings = const InversionSettings(),
  ChordSymbolStyle debugChordStyle = ChordSymbolStyle.majText,
}) {
  final resolvedCandidates = <_RankedSmartCandidate>[];
  final tensionOptions =
      selectedTensionOptions ??
      ChordRenderingHelper.supportedTensionOptions.toSet();
  for (var sourceIndex = 0; sourceIndex < candidates.length; sourceIndex += 1) {
    final candidate = candidates[sourceIndex];
    final spec = MusicTheory.specFor(candidate.romanNumeralId);
    final normalizedAppliedType =
        candidate.appliedType ??
        SmartGeneratorHelper._appliedTypeForRoman(candidate.romanNumeralId);
    final normalizedResolutionTargetRomanId =
        candidate.resolutionTargetRomanId ?? spec.resolutionTargetId;
    final harmonicFunction = SmartGeneratorHelper._harmonicFunctionForRoman(
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
      allowedRenderQualities: allowedRenderQualities,
    );
    if (optionQualities.isEmpty) {
      continue;
    }
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
        chordLanguageLevel: chordLanguageLevel,
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

GeneratedChord _decorateVoiceLeadingDebug({
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

String _debugSummaryForCandidate({
  required GeneratedChord chord,
  required ChordSymbolStyle style,
  required SmartVoiceLeadingBreakdown breakdown,
}) {
  return '${ChordRenderingHelper.renderedSymbol(chord, style)} '
      '${breakdown.describe()}';
}

int _rankedCandidateSeed({
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

List<ChordQuality> _renderQualityOptionsForCandidate({
  required Random random,
  required SmartRenderCandidate candidate,
  required bool allowV7sus4,
  Set<ChordQuality>? allowedRenderQualities,
}) {
  final resolvedPreferredQuality = candidate.renderQualityOverride != null
      ? (!allowV7sus4 && _isSusDominantQuality(candidate.renderQualityOverride!)
            ? MusicTheory.resolveRenderQuality(
                romanNumeralId: candidate.romanNumeralId,
                plannedChordKind: candidate.plannedChordKind,
                allowV7sus4: false,
                randomRoll: random.nextInt(100),
                dominantContext: candidate.dominantContext,
                dominantIntent: candidate.dominantIntent,
              )
            : candidate.renderQualityOverride!)
      : MusicTheory.resolveRenderQuality(
          romanNumeralId: candidate.romanNumeralId,
          plannedChordKind: candidate.plannedChordKind,
          allowV7sus4: allowV7sus4,
          randomRoll: random.nextInt(100),
          dominantContext: candidate.dominantContext,
          dominantIntent: candidate.dominantIntent,
        );
  final options = _compatibleRenderQualitiesForCandidate(
    candidate: candidate,
    preferredQuality: resolvedPreferredQuality,
    allowV7sus4: allowV7sus4,
  );
  final filtered = <ChordQuality>[];
  for (final option in options) {
    if (!allowV7sus4 && _isSusDominantQuality(option)) {
      continue;
    }
    if (allowedRenderQualities != null &&
        !allowedRenderQualities.contains(option)) {
      continue;
    }
    if (!filtered.contains(option)) {
      filtered.add(option);
    }
  }
  return filtered;
}

List<ChordQuality> _compatibleRenderQualitiesForCandidate({
  required SmartRenderCandidate candidate,
  required ChordQuality preferredQuality,
  required bool allowV7sus4,
}) {
  final options = <ChordQuality>[preferredQuality];
  switch (preferredQuality) {
    case ChordQuality.major7:
      options.add(ChordQuality.majorTriad);
      break;
    case ChordQuality.major69:
      options.addAll(const [
        ChordQuality.six,
        ChordQuality.major7,
        ChordQuality.majorTriad,
      ]);
      break;
    case ChordQuality.six:
      options.addAll(const [ChordQuality.major7, ChordQuality.majorTriad]);
      break;
    case ChordQuality.minor7:
      options.add(ChordQuality.minorTriad);
      break;
    case ChordQuality.minorMajor7:
      options.addAll(const [ChordQuality.minor7, ChordQuality.minorTriad]);
      break;
    case ChordQuality.minor6:
      options.addAll(const [ChordQuality.minor7, ChordQuality.minorTriad]);
      break;
    case ChordQuality.halfDiminished7:
    case ChordQuality.diminished7:
      options.add(ChordQuality.diminishedTriad);
      break;
    case ChordQuality.dominant7:
    case ChordQuality.dominant7Alt:
    case ChordQuality.dominant7Sharp11:
    case ChordQuality.dominant13sus4:
    case ChordQuality.dominant7sus4:
      options.addAll(
        _dominantRenderQualityAlternatives(
          candidate: candidate,
          allowV7sus4: allowV7sus4,
        ),
      );
      options.addAll(const [
        ChordQuality.majorTriad,
        ChordQuality.augmentedTriad,
      ]);
      break;
    case ChordQuality.majorTriad:
    case ChordQuality.minorTriad:
    case ChordQuality.diminishedTriad:
    case ChordQuality.augmentedTriad:
      break;
  }
  return options;
}

List<ChordQuality> _dominantRenderQualityAlternatives({
  required SmartRenderCandidate candidate,
  required bool allowV7sus4,
}) {
  final effectiveIntent =
      candidate.dominantIntent ??
      MusicTheory.dominantIntentForContext(candidate.dominantContext);
  final options = <ChordQuality>[];
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
    options.add(ChordQuality.dominant7);
    if (allowV7sus4) {
      options.addAll(const [
        ChordQuality.dominant13sus4,
        ChordQuality.dominant7sus4,
      ]);
    }
  } else {
    options.add(ChordQuality.dominant7);
    if (allowV7sus4) {
      options.addAll(const [
        ChordQuality.dominant13sus4,
        ChordQuality.dominant7sus4,
      ]);
    }
  }
  return options;
}

SmartVoiceLeadingBreakdown _scoreVoiceLeading({
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

Set<int> _pitchClassesForChord(GeneratedChord chord) {
  return ChordRenderingHelper.targetPitchClassesForChord(chord);
}

List<int> _guideTonePitchClasses(ChordSymbolData symbolData) {
  final rootSemitone = MusicTheory.noteToSemitone[symbolData.root];
  if (rootSemitone == null) {
    return const <int>[];
  }
  final formula = ChordToneFormulaLibrary.formulaFor(symbolData.renderQuality);
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

int? _rootAnchorSemitone(ChordSymbolData symbolData) {
  return MusicTheory.noteToSemitone[symbolData.bass ?? symbolData.root];
}

int _pitchDistance(int left, int right) {
  final delta = (right - left).abs() % 12;
  return delta > 6 ? 12 - delta : delta;
}

bool _isSusDominantQuality(ChordQuality quality) {
  return quality == ChordQuality.dominant13sus4 ||
      quality == ChordQuality.dominant7sus4;
}

bool _isPlainDominantQuality(ChordQuality quality) {
  return quality == ChordQuality.dominant7 ||
      quality == ChordQuality.dominant7Alt ||
      quality == ChordQuality.dominant7Sharp11;
}
