import 'dart:math' as math;

import '../smart_generator.dart';
import 'chord_theory.dart';
import 'progression_analysis_models.dart';
import 'progression_parser.dart';

class ProgressionAnalyzer {
  const ProgressionAnalyzer({this.parser = const ProgressionParser()});

  final ProgressionParser parser;

  ProgressionAnalysis analyze(String input) {
    final parseResult = parser.parse(input);
    final knownChords = parseResult.validChords;

    if (knownChords.isEmpty) {
      throw const ProgressionAnalysisException('no-valid-chords');
    }

    final evaluations =
        [
          for (final keyCenter in _candidateKeyCenters)
            _evaluateKeyCenter(keyCenter, parseResult),
        ]..sort(
          (left, right) => _compareKeyScores(
            leftScore: left.score,
            leftKeyCenter: left.keyCenter,
            rightScore: right.score,
            rightKeyCenter: right.keyCenter,
          ),
        );

    final rankedCandidates = _rankedKeyCandidates(evaluations);
    final aggregatePrimary = rankedCandidates.first;
    final segmentationBaseKey = _initialSegmentKey(
      parseResult: parseResult,
      fallback: aggregatePrimary.keyCenter,
    );
    final primaryKey = _selectHomeKeyCandidate(
      rankedCandidates: rankedCandidates,
      evaluations: evaluations,
      homeKeyCenter: segmentationBaseKey,
      parseResult: parseResult,
    );
    final primaryEvaluation = _evaluationForKeyCenter(
      evaluations,
      primaryKey.keyCenter,
    );
    final rawSegments = _buildAnalysisSegments(
      parseResult: parseResult,
      initialKey: primaryKey.keyCenter,
    );
    final analysisSegments = rawSegments.length > 1
        ? rawSegments
        : [
            AnalysisSegment(
              segmentIndex: 0,
              startMeasureIndex: parseResult.measures.first.measureIndex,
              endMeasureIndex: parseResult.measures.last.measureIndex,
              keyCenter: primaryKey.keyCenter,
              reason: 'primary',
            ),
          ];
    final rawChordAnalyses = analysisSegments.length > 1
        ? _reanalyzeBySegments(
            parseResult: parseResult,
            segments: analysisSegments,
          )
        : _applySingleSegmentMetadata(
            analyses: primaryEvaluation.chordAnalyses,
            keyCenter: primaryKey.keyCenter,
          );
    final chordAnalyses = _normalizeChordAnalyses(rawChordAnalyses);
    final alternativeKey = _selectAlternativeKeyCandidate(
      primaryKey: primaryKey,
      rankedCandidates: rankedCandidates,
      evaluations: evaluations,
      chordCount: knownChords.length,
    );
    final keyConfidence = _keyConfidence(
      primaryKey: primaryKey,
      rankedCandidates: rankedCandidates,
      chordAnalyses: chordAnalyses,
    );
    final analysisReliability = _analysisReliability(
      parseResult: parseResult,
      chordAnalyses: chordAnalyses,
      keyConfidence: keyConfidence,
      primaryKey: primaryKey,
      globalAggregateKey: aggregatePrimary,
      analysisSegments: analysisSegments,
    );
    final tags = _normalizeTags(
      chordAnalyses: chordAnalyses,
      analysisSegments: analysisSegments,
    );
    final warningCodes = _warningCodes(
      parseResult: parseResult,
      chordAnalyses: chordAnalyses,
      alternativeKey: alternativeKey,
      analysisReliability: analysisReliability,
      keyConfidence: keyConfidence,
    );
    final diagnosticStatus = _diagnosticStatus(
      parseResult: parseResult,
      chordAnalyses: chordAnalyses,
      warningCodes: warningCodes,
      alternativeKey: alternativeKey,
      analysisReliability: analysisReliability,
      keyConfidence: keyConfidence,
    );
    final selectionReason = _selectionReason(
      analysisSegments: analysisSegments,
      primary: primaryKey,
      alternative: alternativeKey,
    );

    return ProgressionAnalysis(
      input: input,
      parseResult: parseResult,
      primaryKey: primaryKey,
      globalAggregateKey: aggregatePrimary,
      alternativeKey: alternativeKey,
      keyCandidates: rankedCandidates
          .take(math.min(rankedCandidates.length, 5))
          .toList(),
      chordAnalyses: chordAnalyses,
      groupedMeasures: _groupAnalyzedMeasures(parseResult, chordAnalyses),
      analysisSegments: analysisSegments,
      tags: tags,
      keyConfidence: keyConfidence,
      analysisReliability: analysisReliability,
      confidence: analysisReliability,
      ambiguity: 1 - analysisReliability,
      diagnosticStatus: diagnosticStatus,
      warningCodes: warningCodes,
      selectionReason: selectionReason,
    );
  }

  static final List<KeyCenter> _candidateKeyCenters = [
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.major),
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.minor),
  ];

  static int _compareKeyScores({
    required double leftScore,
    required KeyCenter leftKeyCenter,
    required double rightScore,
    required KeyCenter rightKeyCenter,
  }) {
    final scoreCompare = rightScore.compareTo(leftScore);
    if (scoreCompare != 0) {
      return scoreCompare;
    }
    return MusicTheory.compareKeyCenters(leftKeyCenter, rightKeyCenter);
  }

  List<ProgressionKeyCandidate> _rankedKeyCandidates(
    List<_KeyEvaluation> evaluations,
  ) {
    if (evaluations.isEmpty) {
      return const [];
    }
    final maxScore = evaluations.first.score;
    const temperature = 5.6;
    final weights = [
      for (final evaluation in evaluations)
        math.exp((evaluation.score - maxScore) / temperature),
    ];
    final totalWeight = weights.fold<double>(0.0, (sum, value) => sum + value);
    return [
      for (var index = 0; index < evaluations.length; index += 1)
        ProgressionKeyCandidate(
          keyCenter: evaluations[index].keyCenter,
          score: evaluations[index].score,
          confidence: (weights[index] / math.max(0.0001, totalWeight))
              .clamp(0.02, 0.99)
              .toDouble(),
        ),
    ]..sort(
      (left, right) => _compareKeyScores(
        leftScore: left.score,
        leftKeyCenter: left.keyCenter,
        rightScore: right.score,
        rightKeyCenter: right.keyCenter,
      ),
    );
  }

  _KeyEvaluation _evaluationForKeyCenter(
    List<_KeyEvaluation> evaluations,
    KeyCenter keyCenter,
  ) {
    return evaluations.firstWhere(
      (evaluation) => evaluation.keyCenter == keyCenter,
      orElse: () => evaluations.first,
    );
  }

  ProgressionKeyCandidate _candidateForKeyCenter(
    List<ProgressionKeyCandidate> candidates,
    KeyCenter keyCenter,
  ) {
    return candidates.firstWhere(
      (candidate) => candidate.keyCenter == keyCenter,
      orElse: () => candidates.first,
    );
  }

  ProgressionKeyCandidate _selectHomeKeyCandidate({
    required List<ProgressionKeyCandidate> rankedCandidates,
    required List<_KeyEvaluation> evaluations,
    required KeyCenter homeKeyCenter,
    required ProgressionParseResult parseResult,
  }) {
    final aggregatePrimary = rankedCandidates.first;
    final aggregateEvaluation = evaluations.first;
    final openingAnchor = _openingHomeAnchorEvaluation(
      evaluations: evaluations,
      parseResult: parseResult,
    );
    if (openingAnchor != null &&
        openingAnchor.score >= aggregateEvaluation.score - 8.2) {
      return _candidateForKeyCenter(rankedCandidates, openingAnchor.keyCenter);
    }
    final homeCandidate = _candidateForKeyCenter(
      rankedCandidates,
      homeKeyCenter,
    );
    if (homeCandidate.keyCenter == aggregatePrimary.keyCenter) {
      return homeCandidate;
    }

    final homeEvaluation = _evaluationForKeyCenter(evaluations, homeKeyCenter);
    final scoreGap = aggregateEvaluation.score - homeEvaluation.score;
    final strongHomeAnchor = _hasStrongHomeAnchor(
      parseResult: parseResult,
      analyses: homeEvaluation.chordAnalyses,
    );
    if (strongHomeAnchor || scoreGap <= 4.4) {
      return homeCandidate;
    }
    return aggregatePrimary;
  }

  _KeyEvaluation? _openingHomeAnchorEvaluation({
    required List<_KeyEvaluation> evaluations,
    required ProgressionParseResult parseResult,
  }) {
    if (parseResult.validChords.length < 3) {
      return null;
    }
    for (final evaluation in evaluations) {
      final openingWindow = evaluation.chordAnalyses
          .take(4)
          .toList(growable: false);
      if (openingWindow.isEmpty || !_isTonic(openingWindow.first)) {
        continue;
      }
      if (_functionalCadenceBonus(
                analyses: openingWindow,
                measureCount: parseResult.measures.length,
              ) >
              0 ||
          _openingHomeGestureBonus(openingWindow) > 0) {
        return evaluation;
      }
    }
    return null;
  }

  ProgressionKeyCandidate? _selectAlternativeKeyCandidate({
    required ProgressionKeyCandidate primaryKey,
    required List<ProgressionKeyCandidate> rankedCandidates,
    required List<_KeyEvaluation> evaluations,
    required int chordCount,
  }) {
    for (final candidate in rankedCandidates.skip(1)) {
      if (candidate.keyCenter == primaryKey.keyCenter ||
          _isEnharmonicEquivalentKeyCenter(
            candidate.keyCenter,
            primaryKey.keyCenter,
          )) {
        continue;
      }
      final primaryEvaluation = _evaluationForKeyCenter(
        evaluations,
        primaryKey.keyCenter,
      );
      final candidateEvaluation = _evaluationForKeyCenter(
        evaluations,
        candidate.keyCenter,
      );
      if (_showAlternative(
        primaryEvaluation,
        candidateEvaluation,
        chordCount,
      )) {
        return candidate;
      }
      break;
    }
    return null;
  }

  bool _isEnharmonicEquivalentKeyCenter(KeyCenter left, KeyCenter right) {
    if (left.mode != right.mode) {
      return false;
    }
    final leftSemitone = left.tonicSemitone;
    final rightSemitone = right.tonicSemitone;
    return leftSemitone != null && leftSemitone == rightSemitone;
  }

  KeyCenter _initialSegmentKey({
    required ProgressionParseResult parseResult,
    required KeyCenter fallback,
  }) {
    final prefixChords = parseResult.validChords
        .take(4)
        .toList(growable: false);
    if (prefixChords.length < 2) {
      return fallback;
    }
    final evaluations = [
      for (final keyCenter in _candidateKeyCenters)
        _evaluateKeyCenterForChords(keyCenter: keyCenter, chords: prefixChords),
    ]..sort((left, right) => right.score.compareTo(left.score));
    if (evaluations.isEmpty) {
      return fallback;
    }
    final anchored = evaluations
        .where(
          (evaluation) =>
              evaluation.chordAnalyses.isNotEmpty &&
              _isTonic(evaluation.chordAnalyses.first) &&
              (_functionalCadenceBonus(
                        analyses: evaluation.chordAnalyses,
                        measureCount:
                            prefixChords.last.measureIndex -
                            prefixChords.first.measureIndex +
                            1,
                      ) >
                      0 ||
                  _hasOpeningCadentialReturn(evaluation.chordAnalyses)),
        )
        .toList(growable: false);
    if (anchored.isNotEmpty &&
        anchored.first.score >= evaluations.first.score - 4.8) {
      return anchored.first.keyCenter;
    }
    return evaluations.first.keyCenter;
  }

  List<AnalysisSegment> _buildAnalysisSegments({
    required ProgressionParseResult parseResult,
    required KeyCenter initialKey,
  }) {
    final chords = parseResult.validChords;
    if (chords.isEmpty) {
      return const [];
    }

    final lastMeasureIndex = chords.last.measureIndex;
    final segments = <AnalysisSegment>[];
    final homeKey = initialKey;
    var currentKey = initialKey;
    var currentStartMeasure = chords.first.measureIndex;
    var searchStartIndex = 0;
    var segmentIndex = 0;

    while (searchStartIndex < chords.length) {
      final candidate = _findRealModulationCandidate(
        chords: chords,
        currentKey: currentKey,
        homeKey: homeKey,
        searchStartIndex: searchStartIndex,
      );
      if (candidate == null) {
        segments.add(
          AnalysisSegment(
            segmentIndex: segmentIndex,
            startMeasureIndex: currentStartMeasure,
            endMeasureIndex: lastMeasureIndex,
            keyCenter: currentKey,
            reason: segmentIndex == 0 ? 'primary' : 'realModulation',
          ),
        );
        break;
      }

      final nextStartMeasure = chords[candidate.startIndex].measureIndex;
      if (nextStartMeasure > currentStartMeasure) {
        segments.add(
          AnalysisSegment(
            segmentIndex: segmentIndex,
            startMeasureIndex: currentStartMeasure,
            endMeasureIndex: nextStartMeasure - 1,
            keyCenter: currentKey,
            reason: segmentIndex == 0 ? 'primary' : 'realModulation',
          ),
        );
        segmentIndex += 1;
      }

      currentKey = candidate.targetKeyCenter;
      currentStartMeasure = nextStartMeasure;
      searchStartIndex = candidate.startIndex;

      final isLastMeasure = currentStartMeasure == lastMeasureIndex;
      if (isLastMeasure) {
        segments.add(
          AnalysisSegment(
            segmentIndex: segmentIndex,
            startMeasureIndex: currentStartMeasure,
            endMeasureIndex: lastMeasureIndex,
            keyCenter: currentKey,
            reason: currentKey == homeKey ? 'return' : 'realModulation',
          ),
        );
        break;
      }
      searchStartIndex = _firstChordIndexAtOrAfterMeasure(
        chords,
        currentStartMeasure + 1,
      );
    }

    if (segments.isEmpty) {
      return [
        AnalysisSegment(
          segmentIndex: 0,
          startMeasureIndex: chords.first.measureIndex,
          endMeasureIndex: lastMeasureIndex,
          keyCenter: currentKey,
          reason: 'primary',
        ),
      ];
    }

    return segments;
  }

  List<AnalyzedChord> _reanalyzeBySegments({
    required ProgressionParseResult parseResult,
    required List<AnalysisSegment> segments,
  }) {
    final byMeasure = <int, AnalysisSegment>{
      for (final segment in segments)
        for (
          var measure = segment.startMeasureIndex;
          measure <= segment.endMeasureIndex;
          measure += 1
        )
          measure: segment,
    };
    final homeKey = segments.first.keyCenter;
    final analyses = <AnalyzedChord>[];

    for (final segment in segments) {
      final segmentChords = parseResult.validChords
          .where(
            (chord) =>
                chord.measureIndex >= segment.startMeasureIndex &&
                chord.measureIndex <= segment.endMeasureIndex,
          )
          .toList(growable: false);
      if (segmentChords.isEmpty) {
        continue;
      }
      final localEvaluation = _evaluateKeyCenterForChords(
        keyCenter: segment.keyCenter,
        chords: segmentChords,
      );
      for (
        var index = 0;
        index < localEvaluation.chordAnalyses.length;
        index += 1
      ) {
        var analysis = localEvaluation.chordAnalyses[index].copyWith(
          segmentIndex: segment.segmentIndex,
          segmentKeyDisplay: segment.keyDisplay,
        );
        final nextRemarks = <ProgressionRemark>[...analysis.remarks];
        if (segment.segmentIndex > 0 &&
            segment.keyCenter != homeKey &&
            !analysis.hasRemark(ProgressionRemarkKind.realModulation)) {
          nextRemarks.add(
            ProgressionRemark(
              kind: ProgressionRemarkKind.realModulation,
              targetKeyCenter: segment.keyCenter,
            ),
          );
        }
        if (segment.reason == 'return' &&
            index == 0 &&
            !analysis.hasRemark(
              ProgressionRemarkKind.pivotChordInterpretation,
            )) {
          nextRemarks.add(
            ProgressionRemark(
              kind: ProgressionRemarkKind.pivotChordInterpretation,
              targetKeyCenter: segment.keyCenter,
            ),
          );
        }
        if (nextRemarks.length != analysis.remarks.length) {
          analysis = analysis.copyWith(
            remarks: List<ProgressionRemark>.unmodifiable(nextRemarks),
          );
        }
        analyses.add(analysis);
      }
    }

    return [
      for (final analysis in analyses)
        analysis.copyWith(
          segmentIndex:
              byMeasure[analysis.chord.measureIndex]?.segmentIndex ??
              analysis.segmentIndex,
          segmentKeyDisplay:
              byMeasure[analysis.chord.measureIndex]?.keyDisplay ??
              analysis.segmentKeyDisplay,
        ),
    ];
  }

  List<AnalyzedChord> _applySingleSegmentMetadata({
    required List<AnalyzedChord> analyses,
    required KeyCenter keyCenter,
  }) {
    return [
      for (final analysis in analyses)
        analysis.copyWith(
          segmentIndex: 0,
          segmentKeyDisplay: keyCenter.displayName,
        ),
    ];
  }

  _KeyEvaluation _evaluateKeyCenter(
    KeyCenter keyCenter,
    ProgressionParseResult parseResult,
  ) {
    final chords = parseResult.validChords;
    final chordAnalyses = <AnalyzedChord>[];
    var score = 0.0;

    for (var index = 0; index < chords.length; index += 1) {
      final best = _bestInterpretation(
        keyCenter: keyCenter,
        chords: chords,
        index: index,
      );
      chordAnalyses.add(best);
      score += best.score;
    }

    final resolvedAnalyses = parseResult.hasPlaceholders
        ? _resolvePlaceholderAnalyses(
            parseResult: parseResult,
            keyCenter: keyCenter,
            knownAnalyses: chordAnalyses,
          )
        : chordAnalyses;
    if (parseResult.hasPlaceholders) {
      score += resolvedAnalyses
          .where((analysis) => analysis.isInferred)
          .fold<double>(
            0.0,
            (total, analysis) => total + (analysis.score * 0.68),
          );
    }

    final enrichedAnalyses = _enrichContextualAnalyses(
      keyCenter: keyCenter,
      analyses: resolvedAnalyses,
    );
    final tags = _detectTags(enrichedAnalyses);
    score += _tagBonus(tags);
    score += _tonicAnchorBonus(enrichedAnalyses);
    score += _dominantResolutionBonus(enrichedAnalyses);
    score += _openingHomeGestureBonus(enrichedAnalyses);
    score += _functionalCadenceBonus(
      analyses: enrichedAnalyses,
      measureCount: parseResult.measures.length,
    );
    score += _accidentalAffinityBonus(
      keyCenter: keyCenter,
      chords: parseResult.validChords,
    );

    return _KeyEvaluation(
      keyCenter: keyCenter,
      score: score,
      chordAnalyses: enrichedAnalyses,
      tags: tags,
    );
  }

  _KeyEvaluation _evaluateKeyCenterForChords({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
  }) {
    final chordAnalyses = <AnalyzedChord>[];
    var score = 0.0;

    for (var index = 0; index < chords.length; index += 1) {
      final best = _bestInterpretation(
        keyCenter: keyCenter,
        chords: chords,
        index: index,
      );
      chordAnalyses.add(best);
      score += best.score;
    }

    final enrichedAnalyses = _enrichContextualAnalyses(
      keyCenter: keyCenter,
      analyses: chordAnalyses,
    );
    final tags = _detectTags(enrichedAnalyses);
    score += _tagBonus(tags);
    score += _tonicAnchorBonus(enrichedAnalyses);
    score += _dominantResolutionBonus(enrichedAnalyses);
    score += _openingHomeGestureBonus(enrichedAnalyses);
    score += _functionalCadenceBonus(
      analyses: enrichedAnalyses,
      measureCount: chords.isEmpty
          ? 0
          : (chords.last.measureIndex - chords.first.measureIndex + 1),
    );
    score += _accidentalAffinityBonus(keyCenter: keyCenter, chords: chords);

    return _KeyEvaluation(
      keyCenter: keyCenter,
      score: score,
      chordAnalyses: enrichedAnalyses,
      tags: tags,
    );
  }

  double _accidentalAffinityBonus({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
  }) {
    if (chords.isEmpty) {
      return 0;
    }
    var bonus = 0.0;
    var flatCount = 0;
    var sharpCount = 0;
    for (final chord in chords) {
      if (chord.root.contains('b')) {
        flatCount += 1;
      }
      if (chord.root.contains('#')) {
        sharpCount += 1;
      }
      if (chord.bass case final bass?) {
        if (bass.contains('b')) {
          flatCount += 1;
        }
        if (bass.contains('#')) {
          sharpCount += 1;
        }
      }
    }

    final displayRoot = MusicTheory.displayRootForKey(keyCenter.tonicName);
    final tonicMatches = chords.where((chord) {
      return chord.root == displayRoot || chord.bass == displayRoot;
    }).length;
    if (tonicMatches > 0) {
      bonus += 0.26 + (math.min(tonicMatches, 3) - 1) * 0.1;
    }

    final accidentalGap = (flatCount - sharpCount).abs();
    if (accidentalGap == 0) {
      return bonus;
    }
    final cappedGap = math.min(accidentalGap, 4);
    if (MusicTheory.prefersFlatSpellingForKey(keyCenter.tonicName)) {
      return bonus +
          (flatCount > sharpCount ? cappedGap * 0.18 : -(cappedGap * 0.18));
    }
    final prefersSharp =
        keyCenter.tonicName.contains('#') || keyCenter.tonicName == 'E#';
    if (prefersSharp) {
      return bonus +
          (sharpCount > flatCount ? cappedGap * 0.18 : -(cappedGap * 0.18));
    }
    return bonus;
  }

  List<AnalyzedChord> _resolvePlaceholderAnalyses({
    required ProgressionParseResult parseResult,
    required KeyCenter keyCenter,
    required List<AnalyzedChord> knownAnalyses,
  }) {
    if (!parseResult.hasPlaceholders) {
      return knownAnalyses;
    }

    final analysesByTokenIndex = <int, AnalyzedChord>{};
    var knownIndex = 0;
    for (final token in parseResult.tokens) {
      if (token.chord == null) {
        continue;
      }
      analysesByTokenIndex[token.index] = knownAnalyses[knownIndex];
      knownIndex += 1;
    }

    final nextKnownByTokenIndex = <int, AnalyzedChord?>{};
    AnalyzedChord? nextKnown;
    for (var index = parseResult.tokens.length - 1; index >= 0; index -= 1) {
      final token = parseResult.tokens[index];
      nextKnownByTokenIndex[token.index] = nextKnown;
      final current = analysesByTokenIndex[token.index];
      if (current != null) {
        nextKnown = current;
      }
    }

    final resolvedAnalyses = <AnalyzedChord>[];
    for (final token in parseResult.tokens) {
      final knownAnalysis = analysesByTokenIndex[token.index];
      if (knownAnalysis != null) {
        resolvedAnalyses.add(knownAnalysis);
        continue;
      }
      if (!token.isPlaceholder) {
        continue;
      }
      resolvedAnalyses.add(
        _inferPlaceholderAnalysis(
          token: token,
          keyCenter: keyCenter,
          left: resolvedAnalyses.isEmpty ? null : resolvedAnalyses.last,
          right: nextKnownByTokenIndex[token.index],
        ),
      );
    }

    return resolvedAnalyses;
  }

  List<AnalyzedChord> _enrichContextualAnalyses({
    required KeyCenter keyCenter,
    required List<AnalyzedChord> analyses,
  }) {
    if (analyses.isEmpty) {
      return analyses;
    }

    final nextRemarks = [
      for (final analysis in analyses) <ProgressionRemark>[...analysis.remarks],
    ];
    final nextEvidence = [
      for (final analysis in analyses)
        <ProgressionEvidence>[...analysis.evidence],
    ];

    void addRemark(int index, ProgressionRemark remark) {
      final remarks = nextRemarks[index];
      final exists = remarks.any(
        (candidate) =>
            candidate.kind == remark.kind &&
            candidate.targetRomanNumeral == remark.targetRomanNumeral &&
            candidate.targetKeyCenter == remark.targetKeyCenter &&
            candidate.detail == remark.detail,
      );
      if (!exists) {
        remarks.add(remark);
      }
    }

    void addEvidence(int index, ProgressionEvidence evidence) {
      final evidenceList = nextEvidence[index];
      final exists = evidenceList.any(
        (candidate) =>
            candidate.kind == evidence.kind &&
            candidate.detail == evidence.detail,
      );
      if (!exists) {
        evidenceList.add(evidence);
      }
    }

    for (var index = 0; index < analyses.length; index += 1) {
      final analysis = analyses[index];
      if (analysis.isAmbiguous &&
          analysis.competingInterpretations.any(
            (candidate) =>
                candidate.harmonicFunction != analysis.harmonicFunction,
          )) {
        addRemark(
          index,
          const ProgressionRemark(
            kind: ProgressionRemarkKind.dualFunctionAmbiguity,
          ),
        );
        addEvidence(
          index,
          ProgressionEvidence(
            kind: ProgressionEvidenceKind.competingReading,
            detail: analysis.competingInterpretations
                .take(2)
                .map((candidate) => candidate.romanNumeral)
                .join(', '),
          ),
        );
      }

      if (analysis.romanNumeralId == RomanNumeralId.borrowedIvMin7) {
        addRemark(
          index,
          const ProgressionRemark(kind: ProgressionRemarkKind.subdominantMinor),
        );
      }
    }

    for (var index = 0; index < analyses.length - 2; index += 1) {
      final first = analyses[index];
      final second = analyses[index + 1];
      final third = analyses[index + 2];
      if ((first.romanNumeralId == RomanNumeralId.borrowedIvMin7 ||
              first.hasRemark(ProgressionRemarkKind.subdominantMinor)) &&
          _isBackdoorDominantResolution(second, third) &&
          _isTonic(third)) {
        addRemark(
          index + 1,
          const ProgressionRemark(kind: ProgressionRemarkKind.backdoorDominant),
        );
        addRemark(
          index,
          const ProgressionRemark(kind: ProgressionRemarkKind.backdoorChain),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.backdoorMotion,
          ),
        );
        addEvidence(
          index + 1,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.backdoorMotion,
          ),
        );
      }
    }

    for (var index = 0; index < analyses.length - 1; index += 1) {
      final current = analyses[index];
      final next = analyses[index + 1];

      if (_isBackdoorDominantResolution(current, next) && _isTonic(next)) {
        addRemark(
          index,
          const ProgressionRemark(kind: ProgressionRemarkKind.backdoorDominant),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.backdoorMotion,
          ),
        );
      }

      if (current.romanNumeralId == RomanNumeralId.sharpIDim7 &&
          _isTonic(next) &&
          _sharesCommonTone(current.chord, next.chord)) {
        addRemark(
          index,
          const ProgressionRemark(
            kind: ProgressionRemarkKind.commonToneDiminished,
          ),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.commonToneSupport,
          ),
        );
      }

      if (_isDeceptiveResolution(current, next)) {
        addRemark(
          index + 1,
          const ProgressionRemark(kind: ProgressionRemarkKind.deceptiveCadence),
        );
        addEvidence(
          index + 1,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.deceptiveResolution,
          ),
        );
      }

      if (_isLineClichePair(current.chord, next.chord)) {
        addRemark(
          index,
          const ProgressionRemark(kind: ProgressionRemarkKind.lineClicheColor),
        );
        addRemark(
          index + 1,
          const ProgressionRemark(kind: ProgressionRemarkKind.lineClicheColor),
        );
        addEvidence(
          index,
          ProgressionEvidence(
            kind: ProgressionEvidenceKind.chromaticLine,
            detail:
                '${current.chord.sourceSymbol} -> ${next.chord.sourceSymbol}',
          ),
        );
        addEvidence(
          index + 1,
          ProgressionEvidence(
            kind: ProgressionEvidenceKind.chromaticLine,
            detail:
                '${current.chord.sourceSymbol} -> ${next.chord.sourceSymbol}',
          ),
        );
      }
    }

    for (var index = 0; index < analyses.length; index += 1) {
      final analysis = analyses[index];
      final resolutionTargetIndex = _findAppliedResolutionIndex(
        analysis: analysis,
        analyses: analyses,
        keyCenter: keyCenter,
        startIndex: index,
      );
      if (resolutionTargetIndex == null) {
        continue;
      }

      final target = analyses[resolutionTargetIndex];
      final targetKeyCenter = _localKeyCenterForAnalysis(target);
      if (targetKeyCenter == keyCenter) {
        continue;
      }
      final segmentEnd = math.min(analyses.length, resolutionTargetIndex + 4);
      final localWindow = _interpretSegmentInKey(
        keyCenter: targetKeyCenter,
        chords: [
          for (
            var segmentIndex = resolutionTargetIndex;
            segmentIndex < segmentEnd;
            segmentIndex += 1
          )
            analyses[segmentIndex].chord,
        ],
      );

      final hasCadentialArrival =
          localWindow.isNotEmpty &&
          localWindow.first.harmonicFunction ==
              ProgressionHarmonicFunction.tonic;
      final hasFollowThrough = _hasLocalKeyFollowThrough(localWindow);
      final hasPhraseBoundary =
          target.chord.positionInMeasure == 0 ||
          target.chord.measureIndex != analysis.chord.measureIndex;
      final pivotIndex = _pivotIndexBeforeTarget(
        analyses: analyses,
        primaryKey: keyCenter,
        targetKeyCenter: targetKeyCenter,
        startIndex: index,
        targetIndex: resolutionTargetIndex,
      );
      final hasPivot = pivotIndex != null;
      final hasCommonTone =
          (pivotIndex != null &&
              _sharesCommonTone(analyses[pivotIndex].chord, target.chord)) ||
          (index > 0 &&
              _sharesCommonTone(analyses[index - 1].chord, target.chord));
      final endsOnLocalTonic = _windowEndsOnLocalTonic(localWindow);
      final homeGravityWeakening =
          !_windowContainsPrimaryTonic(analyses, resolutionTargetIndex) &&
          endsOnLocalTonic;
      final hasModulationEvidence =
          homeGravityWeakening ||
          (endsOnLocalTonic &&
              (hasPhraseBoundary || hasPivot || hasCommonTone));

      if (hasCadentialArrival && hasFollowThrough && hasModulationEvidence) {
        addRemark(
          index,
          ProgressionRemark(
            kind: ProgressionRemarkKind.realModulation,
            targetKeyCenter: targetKeyCenter,
          ),
        );
        addRemark(
          resolutionTargetIndex,
          ProgressionRemark(
            kind: ProgressionRemarkKind.realModulation,
            targetKeyCenter: targetKeyCenter,
          ),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.cadentialArrival,
          ),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.followThroughSupport,
          ),
        );
        if (hasPhraseBoundary) {
          addEvidence(
            index,
            const ProgressionEvidence(
              kind: ProgressionEvidenceKind.phraseBoundary,
            ),
          );
        }
        if (homeGravityWeakening) {
          addEvidence(
            index,
            const ProgressionEvidence(
              kind: ProgressionEvidenceKind.homeGravityWeakening,
            ),
          );
        }
        if (pivotIndex != null) {
          addRemark(
            pivotIndex,
            ProgressionRemark(
              kind: ProgressionRemarkKind.pivotChordInterpretation,
              targetKeyCenter: targetKeyCenter,
            ),
          );
          addEvidence(
            pivotIndex,
            const ProgressionEvidence(
              kind: ProgressionEvidenceKind.pivotSupport,
            ),
          );
        } else if (hasCommonTone) {
          addRemark(
            index,
            ProgressionRemark(
              kind: ProgressionRemarkKind.commonToneModulation,
              targetKeyCenter: targetKeyCenter,
            ),
          );
          addEvidence(
            index,
            const ProgressionEvidence(
              kind: ProgressionEvidenceKind.commonToneSupport,
            ),
          );
        }
      } else if (hasCadentialArrival) {
        addRemark(
          index,
          ProgressionRemark(
            kind: ProgressionRemarkKind.tonicization,
            targetKeyCenter: targetKeyCenter,
          ),
        );
        addEvidence(
          index,
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.cadentialArrival,
          ),
        );
        if (hasPhraseBoundary) {
          addEvidence(
            index,
            const ProgressionEvidence(
              kind: ProgressionEvidenceKind.phraseBoundary,
            ),
          );
        }
      }
    }

    return [
      for (var index = 0; index < analyses.length; index += 1)
        analyses[index].copyWith(
          remarks: List<ProgressionRemark>.unmodifiable(nextRemarks[index]),
          evidence: List<ProgressionEvidence>.unmodifiable(nextEvidence[index]),
          isAmbiguous:
              analyses[index].isAmbiguous ||
              nextRemarks[index].any(
                (remark) =>
                    remark.kind ==
                        ProgressionRemarkKind.dualFunctionAmbiguity ||
                    remark.kind ==
                        ProgressionRemarkKind.ambiguousInterpretation ||
                    remark.kind == ProgressionRemarkKind.unresolved,
              ),
        ),
    ];
  }

  bool _isLineClichePair(ParsedChord left, ParsedChord right) {
    if (left.rootSemitone != right.rootSemitone) {
      return false;
    }
    const majorLine = {
      ChordQuality.majorTriad,
      ChordQuality.major7,
      ChordQuality.dominant7,
      ChordQuality.six,
      ChordQuality.major69,
    };
    const minorLine = {
      ChordQuality.minorTriad,
      ChordQuality.minorMajor7,
      ChordQuality.minor7,
      ChordQuality.minor6,
    };
    return (majorLine.contains(left.displayQuality) &&
            majorLine.contains(right.displayQuality) &&
            left.displayQuality != right.displayQuality) ||
        (minorLine.contains(left.displayQuality) &&
            minorLine.contains(right.displayQuality) &&
            left.displayQuality != right.displayQuality);
  }

  bool _isDeceptiveResolution(AnalyzedChord dominant, AnalyzedChord target) {
    if (dominant.harmonicFunction != ProgressionHarmonicFunction.dominant) {
      return false;
    }
    return target.romanNumeralId == RomanNumeralId.viMin7 ||
        target.romanNumeralId == RomanNumeralId.flatVIMaj7Minor;
  }

  bool _isBackdoorDominantResolution(
    AnalyzedChord dominant,
    AnalyzedChord target,
  ) {
    if (!dominant.chord.isDominantLike || !_isTonic(target)) {
      return false;
    }
    final intervalToTarget =
        (target.chord.rootSemitone - dominant.chord.rootSemitone) % 12;
    return dominant.romanNumeralId == RomanNumeralId.borrowedFlatVII7 ||
        intervalToTarget == 2;
  }

  int? _findAppliedResolutionIndex({
    required AnalyzedChord analysis,
    required List<AnalyzedChord> analyses,
    required KeyCenter keyCenter,
    required int startIndex,
  }) {
    final targetRomanId = analysis.romanNumeralId == null
        ? null
        : MusicTheory.modeAwareResolutionTarget(
            analysis.romanNumeralId!,
            keyCenter.mode,
          );
    if (targetRomanId == null) {
      return analysis.hasRemark(
                ProgressionRemarkKind.possibleTritoneSubstitute,
              ) &&
              startIndex + 1 < analyses.length
          ? startIndex + 1
          : null;
    }

    final targetRoot = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      targetRomanId,
    );
    final targetSemitone = MusicTheory.noteToSemitone[targetRoot];
    final targetQuality = MusicTheory.specFor(targetRomanId).quality;
    if (targetSemitone == null) {
      return null;
    }

    final searchEnd = math.min(analyses.length, startIndex + 3);
    for (var index = startIndex + 1; index < searchEnd; index += 1) {
      if (_matchesTarget(
        analyses[index].chord,
        targetSemitone,
        targetQuality,
      )) {
        return index;
      }
    }
    return null;
  }

  KeyCenter _localKeyCenterForAnalysis(AnalyzedChord analysis) {
    final tonicName = _keyOptionForSemitone(
      analysis.chord.rootSemitone,
      preferFlat:
          analysis.chord.root.contains('b') ||
          analysis.chord.sourceSymbol.contains('b'),
    );
    final mode = switch (analysis.chord.analysisFamily) {
      ChordFamily.minor ||
      ChordFamily.halfDiminished ||
      ChordFamily.diminished => KeyMode.minor,
      ChordFamily.major ||
      ChordFamily.dominant ||
      ChordFamily.augmented => KeyMode.major,
    };
    return KeyCenter(tonicName: tonicName, mode: mode);
  }

  String _keyOptionForSemitone(int semitone, {required bool preferFlat}) {
    final normalized = semitone % 12;
    final matches = [
      for (final key in MusicTheory.keyOptions)
        if (MusicTheory.keyTonicSemitone(key) == normalized) key,
    ];
    if (matches.isEmpty) {
      return MusicTheory.spellPitch(normalized, preferFlat: preferFlat);
    }
    for (final key in matches) {
      if (MusicTheory.prefersFlatSpellingForKey(key) == preferFlat) {
        return key;
      }
    }
    return matches.first;
  }

  List<AnalyzedChord> _interpretSegmentInKey({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
  }) {
    if (chords.isEmpty) {
      return const [];
    }
    return [
      for (var index = 0; index < chords.length; index += 1)
        _bestInterpretation(keyCenter: keyCenter, chords: chords, index: index),
    ];
  }

  bool _hasLocalKeyFollowThrough(List<AnalyzedChord> analyses) {
    if (analyses.length < 2) {
      return false;
    }
    for (var index = 0; index < analyses.length - 1; index += 1) {
      final first = analyses[index];
      final second = analyses[index + 1];
      if (first.harmonicFunction == ProgressionHarmonicFunction.predominant &&
          second.harmonicFunction == ProgressionHarmonicFunction.dominant) {
        return true;
      }
      if (first.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          second.harmonicFunction == ProgressionHarmonicFunction.tonic) {
        return true;
      }
    }
    final supportingCount = analyses
        .where(
          (analysis) =>
              analysis.harmonicFunction != ProgressionHarmonicFunction.other,
        )
        .length;
    return supportingCount >= 2;
  }

  int? _pivotIndexBeforeTarget({
    required List<AnalyzedChord> analyses,
    required KeyCenter primaryKey,
    required KeyCenter targetKeyCenter,
    required int startIndex,
    required int targetIndex,
  }) {
    for (
      var index = math.max(0, startIndex - 1);
      index < targetIndex;
      index += 1
    ) {
      final chord = analyses[index].chord;
      if (_bestDiatonicTarget(chord, primaryKey) != null &&
          _bestDiatonicTarget(chord, targetKeyCenter) != null) {
        return index;
      }
    }
    return null;
  }

  bool _windowContainsPrimaryTonic(
    List<AnalyzedChord> analyses,
    int startIndex,
  ) {
    final end = math.min(analyses.length, startIndex + 3);
    for (var index = startIndex; index < end; index += 1) {
      if (_isTonic(analyses[index])) {
        return true;
      }
    }
    return false;
  }

  bool _windowEndsOnLocalTonic(List<AnalyzedChord> analyses) {
    return analyses.isNotEmpty &&
        analyses.last.harmonicFunction == ProgressionHarmonicFunction.tonic;
  }

  _RealModulationCandidate? _findRealModulationCandidate({
    required List<ParsedChord> chords,
    required KeyCenter currentKey,
    required KeyCenter homeKey,
    required int searchStartIndex,
  }) {
    _RealModulationCandidate? best;

    for (
      var startIndex = searchStartIndex;
      startIndex < chords.length - 1;
      startIndex += 1
    ) {
      for (final targetKey in _candidateKeyCenters) {
        if (targetKey == currentKey) {
          continue;
        }

        _RealModulationCandidate? candidate;
        if (startIndex + 2 < chords.length) {
          final localThree = _interpretSegmentInKey(
            keyCenter: targetKey,
            chords: chords.sublist(startIndex, startIndex + 3),
          );
          if (_isStrictLocalCadence(localThree)) {
            candidate = _buildRealModulationCandidate(
              chords: chords,
              currentKey: currentKey,
              homeKey: homeKey,
              targetKey: targetKey,
              startIndex: startIndex,
              arrivalIndex: startIndex + 2,
              cadenceStrength: 2,
            );
          }
        }
        candidate ??= () {
          final localTwo = _interpretSegmentInKey(
            keyCenter: targetKey,
            chords: chords.sublist(startIndex, startIndex + 2),
          );
          if (_isDominantToTonic(localTwo)) {
            return _buildRealModulationCandidate(
              chords: chords,
              currentKey: currentKey,
              homeKey: homeKey,
              targetKey: targetKey,
              startIndex: startIndex,
              arrivalIndex: startIndex + 1,
              cadenceStrength: 1,
            );
          }
          return null;
        }();

        if (candidate == null) {
          continue;
        }
        if (best == null ||
            candidate.startIndex < best.startIndex ||
            (candidate.startIndex == best.startIndex &&
                candidate.score > best.score)) {
          best = candidate;
        }
      }
      if (best != null && best.startIndex == startIndex) {
        break;
      }
    }

    return best;
  }

  _RealModulationCandidate? _buildRealModulationCandidate({
    required List<ParsedChord> chords,
    required KeyCenter currentKey,
    required KeyCenter homeKey,
    required KeyCenter targetKey,
    required int startIndex,
    required int arrivalIndex,
    required int cadenceStrength,
  }) {
    if (arrivalIndex >= chords.length) {
      return null;
    }

    final arrivalChord = chords[arrivalIndex];
    final startChord = chords[startIndex];
    final followStart = arrivalIndex + 1;
    final followEnd = math.min(chords.length, arrivalIndex + 3);
    final followThrough = chords.sublist(followStart, followEnd);
    final hasSupportiveFollowThrough = followThrough.isEmpty
        ? arrivalIndex == chords.length - 1
        : followThrough.any(
            (chord) => _bestDiatonicTarget(chord, targetKey) != null,
          );
    final segmentPersists =
        (arrivalIndex - startIndex + 1) >= 2 ||
        arrivalChord.measureIndex > startChord.measureIndex;

    if (!hasSupportiveFollowThrough || !segmentPersists) {
      return null;
    }

    final fastReturnWindow = chords.sublist(
      arrivalIndex + 1,
      math.min(chords.length, arrivalIndex + 4),
    );
    if (targetKey != homeKey &&
        _hasQuickReturnCadence(homeKey: homeKey, chords: fastReturnWindow)) {
      return null;
    }

    final startMeasure = startChord.measureIndex;
    if (startMeasure == chords.first.measureIndex && targetKey != homeKey) {
      return null;
    }

    final priorMeasure = startMeasure == 0 ? null : startMeasure - 1;
    if (priorMeasure == null && targetKey != currentKey) {
      return null;
    }

    final currentReading = _interpretSegmentInKey(
      keyCenter: currentKey,
      chords: chords.sublist(
        startIndex,
        math.min(chords.length, arrivalIndex + 1),
      ),
    );
    final targetReading = _interpretSegmentInKey(
      keyCenter: targetKey,
      chords: chords.sublist(
        startIndex,
        math.min(chords.length, arrivalIndex + 1),
      ),
    );
    final targetDiatonicCount = targetReading
        .where((analysis) => analysis.sourceKind == ChordSourceKind.diatonic)
        .length;
    final currentDiatonicCount = currentReading
        .where((analysis) => analysis.sourceKind == ChordSourceKind.diatonic)
        .length;
    final currentScore = currentReading.fold<double>(
      0.0,
      (sum, analysis) => sum + analysis.score,
    );
    final targetScore = targetReading.fold<double>(
      0.0,
      (sum, analysis) => sum + analysis.score,
    );
    final structuralBoundary =
        startIndex > 0 &&
        (startChord.positionInMeasure == 0 ||
            startChord.measureIndex != chords[startIndex - 1].measureIndex);
    final meaningfulKeyDelta = (targetScore - currentScore) >= 2.6;
    final strongerTargetAlignment =
        targetDiatonicCount > currentDiatonicCount ||
        (targetDiatonicCount == currentDiatonicCount &&
            targetScore > currentScore + 1.5);
    final confirmationCount = [
      cadenceStrength >= 1,
      segmentPersists,
      structuralBoundary,
      strongerTargetAlignment,
      meaningfulKeyDelta,
    ].where((flag) => flag).length;

    if (targetDiatonicCount <= currentDiatonicCount && targetKey != homeKey) {
      return null;
    }
    if (confirmationCount < 4) {
      return null;
    }

    return _RealModulationCandidate(
      startIndex: startIndex,
      arrivalIndex: arrivalIndex,
      targetKeyCenter: targetKey,
      score:
          (cadenceStrength * 4.0) +
          targetDiatonicCount -
          (currentDiatonicCount * 0.5) +
          (targetKey == homeKey ? 1.0 : 0.0),
    );
  }

  bool _isStrictLocalCadence(List<AnalyzedChord> analyses) {
    if (analyses.length != 3) {
      return false;
    }
    final first = analyses[0];
    final second = analyses[1];
    final third = analyses[2];
    return _isStrictCadentialTwo(first) &&
        _isDominantLikeAnalysis(second) &&
        _isTonic(third);
  }

  bool _isDominantToTonic(List<AnalyzedChord> analyses) {
    return analyses.length == 2 &&
        _isDominantLikeAnalysis(analyses[0]) &&
        _isTonic(analyses[1]);
  }

  bool _isStrictCadentialTwo(AnalyzedChord analysis) {
    return analysis.romanNumeralId == RomanNumeralId.iiMin7 ||
        analysis.romanNumeralId == RomanNumeralId.iiHalfDiminishedMinor;
  }

  bool _isDominantLikeAnalysis(AnalyzedChord analysis) {
    return analysis.harmonicFunction == ProgressionHarmonicFunction.dominant;
  }

  int _firstChordIndexAtOrAfterMeasure(List<ParsedChord> chords, int measure) {
    for (var index = 0; index < chords.length; index += 1) {
      if (chords[index].measureIndex >= measure) {
        return index;
      }
    }
    return chords.length;
  }

  bool _hasQuickReturnCadence({
    required KeyCenter homeKey,
    required List<ParsedChord> chords,
  }) {
    if (chords.length < 2) {
      return false;
    }
    for (var index = 0; index < chords.length - 1; index += 1) {
      final localTwo = _interpretSegmentInKey(
        keyCenter: homeKey,
        chords: chords.sublist(index, index + 2),
      );
      if (_isDominantToTonic(localTwo)) {
        return true;
      }
    }
    return false;
  }

  bool _sharesCommonTone(ParsedChord left, ParsedChord right) {
    final leftPitchClasses = _corePitchClasses(left);
    final rightPitchClasses = _corePitchClasses(right);
    return leftPitchClasses.any(rightPitchClasses.contains);
  }

  Set<int> _corePitchClasses(ParsedChord chord) {
    final thirdOffset = switch (chord.displayQuality) {
      ChordQuality.minorTriad ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.minor6 ||
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 => 3,
      _ => 4,
    };
    final fifthOffset = switch (chord.displayQuality) {
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 ||
      ChordQuality.halfDiminished7 => 6,
      ChordQuality.augmentedTriad => 8,
      _ => 7,
    };
    final pitchClasses = <int>{
      chord.rootSemitone % 12,
      (chord.rootSemitone + thirdOffset) % 12,
      (chord.rootSemitone + fifthOffset) % 12,
    };
    if (chord.hasExtension) {
      final seventhOffset = switch (chord.displayQuality) {
        ChordQuality.major7 ||
        ChordQuality.major69 ||
        ChordQuality.minorMajor7 => 11,
        ChordQuality.minor7 ||
        ChordQuality.dominant7 ||
        ChordQuality.dominant7Alt ||
        ChordQuality.dominant7Sharp11 ||
        ChordQuality.dominant13sus4 ||
        ChordQuality.dominant7sus4 ||
        ChordQuality.halfDiminished7 ||
        ChordQuality.minor6 => 10,
        ChordQuality.diminished7 => 9,
        _ => null,
      };
      if (seventhOffset != null) {
        pitchClasses.add((chord.rootSemitone + seventhOffset) % 12);
      }
    }
    return pitchClasses;
  }

  AnalyzedChord _inferPlaceholderAnalysis({
    required ParsedChordToken token,
    required KeyCenter keyCenter,
    required AnalyzedChord? left,
    required AnalyzedChord? right,
  }) {
    final candidates = [
      for (final romanNumeralId in _candidateRomansForPlaceholder(
        keyCenter: keyCenter,
        left: left,
        right: right,
      ))
        _placeholderCandidateForRoman(
          token: token,
          keyCenter: keyCenter,
          romanNumeralId: romanNumeralId,
          left: left,
          right: right,
        ),
    ]..sort((left, right) => right.score.compareTo(left.score));

    final best = candidates.first;
    final suggestions = _buildSuggestedFills(candidates.take(5).toList());
    final competitors = _placeholderCompetingInterpretations(
      candidates: candidates,
      primary: best,
    );
    final second = competitors.isNotEmpty ? competitors.first : null;
    final gap = second == null ? 3.4 : best.score - second.score;
    final ambiguous = second != null && gap < 1.2;

    return AnalyzedChord(
      chord: _buildInferredParsedChord(
        token: token,
        keyCenter: keyCenter,
        romanNumeralId: best.romanNumeralId,
      ),
      romanNumeral: best.romanNumeral,
      harmonicFunction: best.harmonicFunction,
      isInferred: true,
      inferredSymbol: best.symbol,
      romanNumeralId: best.romanNumeralId,
      sourceKind: best.sourceKind,
      score: best.score,
      confidence: _placeholderConfidence(
        gap: gap,
        hasBothSides: left != null && right != null,
        sourceKind: best.sourceKind,
      ),
      isAmbiguous: ambiguous,
      remarks: [
        ...best.remarks,
        if (ambiguous)
          const ProgressionRemark(
            kind: ProgressionRemarkKind.ambiguousInterpretation,
          ),
      ],
      evidence: best.evidence,
      competingInterpretations: competitors,
      userFacingLabel: _userFacingLabelForAnalysis(
        romanNumeral: best.romanNumeral,
        remarks: best.remarks,
        romanNumeralId: best.romanNumeralId,
      ),
      suggestedFills: suggestions,
    );
  }

  Set<RomanNumeralId> _candidateRomansForPlaceholder({
    required KeyCenter keyCenter,
    required AnalyzedChord? left,
    required AnalyzedChord? right,
  }) {
    final romans = <RomanNumeralId>{
      ..._canonicalPlaceholderRomansForMode(keyCenter.mode),
    };

    final rightRoman = right?.romanNumeralId;
    if (rightRoman != null) {
      final secondary =
          SmartGeneratorHelper.secondaryDominantByResolution[rightRoman];
      if (secondary != null) {
        romans.add(secondary);
      }

      final substitute =
          SmartGeneratorHelper.substituteDominantByResolution[rightRoman];
      if (substitute != null) {
        romans.add(substitute);
      }

      if (rightRoman == RomanNumeralId.iiiMin7) {
        romans.add(RomanNumeralId.relatedIiOfIII);
      } else if (rightRoman == RomanNumeralId.ivMaj7) {
        romans.add(RomanNumeralId.relatedIiOfIV);
      }

      if (keyCenter.mode == KeyMode.major && _isTonicRoman(rightRoman)) {
        romans.add(RomanNumeralId.borrowedFlatVII7);
        romans.add(RomanNumeralId.borrowedFlatIIIMaj7);
      }
    }

    if (left?.romanNumeralId == RomanNumeralId.borrowedIvMin7) {
      romans.add(RomanNumeralId.borrowedFlatVII7);
    }

    return {
      for (final romanNumeralId in romans)
        if (_romanMatchesMode(romanNumeralId, keyCenter.mode)) romanNumeralId,
    };
  }

  List<RomanNumeralId> _canonicalPlaceholderRomansForMode(KeyMode mode) {
    return switch (mode) {
      KeyMode.major => const [
        RomanNumeralId.iMaj7,
        RomanNumeralId.iiMin7,
        RomanNumeralId.iiiMin7,
        RomanNumeralId.ivMaj7,
        RomanNumeralId.vDom7,
        RomanNumeralId.viMin7,
        RomanNumeralId.viiHalfDiminished7,
      ],
      KeyMode.minor => const [
        RomanNumeralId.iMin7,
        RomanNumeralId.iiHalfDiminishedMinor,
        RomanNumeralId.flatIIIMaj7Minor,
        RomanNumeralId.ivMin7Minor,
        RomanNumeralId.vDom7,
        RomanNumeralId.flatVIMaj7Minor,
        RomanNumeralId.flatVIIDom7Minor,
      ],
    };
  }

  bool _romanMatchesMode(RomanNumeralId romanNumeralId, KeyMode mode) {
    final spec = MusicTheory.specFor(romanNumeralId);
    return spec.homeMode == null || spec.homeMode == mode;
  }

  _PlaceholderCandidate _placeholderCandidateForRoman({
    required ParsedChordToken token,
    required KeyCenter keyCenter,
    required RomanNumeralId romanNumeralId,
    required AnalyzedChord? left,
    required AnalyzedChord? right,
  }) {
    final spec = MusicTheory.specFor(romanNumeralId);
    final symbol = _symbolForRoman(keyCenter, romanNumeralId);
    final parsedChord = _buildInferredParsedChord(
      token: token,
      keyCenter: keyCenter,
      romanNumeralId: romanNumeralId,
    );
    final harmonicFunction = _mapFunction(spec.harmonicFunction);
    var score = _basePlaceholderScoreForSource(spec.sourceKind);

    if (left != null) {
      score += _transitionBridgeScore(
        fromRoman: left.romanNumeralId,
        fromFunction: left.harmonicFunction,
        toRoman: romanNumeralId,
        toFunction: harmonicFunction,
        keyMode: keyCenter.mode,
      );
    }
    if (right != null) {
      score += _transitionBridgeScore(
        fromRoman: romanNumeralId,
        fromFunction: harmonicFunction,
        toRoman: right.romanNumeralId,
        toFunction: right.harmonicFunction,
        keyMode: keyCenter.mode,
      );
    }

    score += _placeholderBridgeBonus(
      candidateRoman: romanNumeralId,
      candidateFunction: harmonicFunction,
      left: left,
      right: right,
    );

    final rightRoman = right?.romanNumeralId;
    if (rightRoman != null && spec.resolutionTargetId == rightRoman) {
      score += switch (spec.sourceKind) {
        ChordSourceKind.secondaryDominant ||
        ChordSourceKind.substituteDominant => 5.2,
        ChordSourceKind.tonicization => 4.7,
        _ => 0.0,
      };
    }
    if (romanNumeralId == RomanNumeralId.borrowedFlatVII7 &&
        rightRoman != null &&
        _isTonicRoman(rightRoman)) {
      score += 4.4;
    }

    return _PlaceholderCandidate(
      romanNumeralId: romanNumeralId,
      symbol: symbol,
      romanNumeral: _displayRomanForCandidate(
        chord: parsedChord,
        romanNumeralId: romanNumeralId,
        sourceKind: spec.sourceKind,
        keyCenter: keyCenter,
        resolutionTarget: spec.resolutionTargetId,
      ),
      harmonicFunction: harmonicFunction,
      sourceKind: spec.sourceKind,
      score: score,
      sourceReason: _placeholderSourceReason(
        spec: spec,
        left: left,
        right: right,
      ),
      remarks: _placeholderRemarksForSpec(spec),
      evidence: _placeholderEvidenceForSpec(spec, rightRoman),
    );
  }

  double _basePlaceholderScoreForSource(ChordSourceKind sourceKind) {
    return switch (sourceKind) {
      ChordSourceKind.diatonic => 8.0,
      ChordSourceKind.tonicization => 7.3,
      ChordSourceKind.secondaryDominant => 6.9,
      ChordSourceKind.substituteDominant => 6.6,
      ChordSourceKind.modalInterchange => 6.3,
      ChordSourceKind.free => 4.8,
    };
  }

  double _transitionBridgeScore({
    required RomanNumeralId? fromRoman,
    required ProgressionHarmonicFunction fromFunction,
    required RomanNumeralId? toRoman,
    required ProgressionHarmonicFunction toFunction,
    required KeyMode keyMode,
  }) {
    var score = _functionTransitionScore(fromFunction, toFunction);
    if (fromRoman != null && toRoman != null) {
      score += _transitionPriorScore(fromRoman, toRoman, keyMode);
      if (fromRoman == toRoman) {
        score -= 0.9;
      }
    }
    return score;
  }

  double _transitionPriorScore(
    RomanNumeralId fromRoman,
    RomanNumeralId toRoman,
    KeyMode keyMode,
  ) {
    final transitionMap = keyMode == KeyMode.major
        ? SmartGeneratorHelper.majorDiatonicTransitions
        : SmartGeneratorHelper.minorDiatonicTransitions;
    for (final candidate
        in transitionMap[fromRoman] ?? const <WeightedNextRoman>[]) {
      if (candidate.romanNumeralId == toRoman) {
        return candidate.weight / 18;
      }
    }

    final spec = MusicTheory.specFor(fromRoman);
    if (spec.resolutionTargetId == toRoman) {
      return switch (spec.sourceKind) {
        ChordSourceKind.secondaryDominant ||
        ChordSourceKind.substituteDominant => 4.8,
        ChordSourceKind.tonicization => 4.2,
        _ => 0.0,
      };
    }

    if (fromRoman == RomanNumeralId.borrowedIvMin7 &&
        toRoman == RomanNumeralId.borrowedFlatVII7) {
      return 3.9;
    }
    if (fromRoman == RomanNumeralId.borrowedFlatVII7 &&
        _isTonicRoman(toRoman)) {
      return 4.5;
    }

    return 0.0;
  }

  double _functionTransitionScore(
    ProgressionHarmonicFunction from,
    ProgressionHarmonicFunction to,
  ) {
    return switch ((from, to)) {
      (
        ProgressionHarmonicFunction.tonic,
        ProgressionHarmonicFunction.predominant,
      ) =>
        1.0,
      (ProgressionHarmonicFunction.tonic, ProgressionHarmonicFunction.tonic) =>
        0.45,
      (
        ProgressionHarmonicFunction.predominant,
        ProgressionHarmonicFunction.dominant,
      ) =>
        1.9,
      (
        ProgressionHarmonicFunction.predominant,
        ProgressionHarmonicFunction.tonic,
      ) =>
        0.6,
      (
        ProgressionHarmonicFunction.dominant,
        ProgressionHarmonicFunction.tonic,
      ) =>
        2.7,
      (
        ProgressionHarmonicFunction.tonic,
        ProgressionHarmonicFunction.dominant,
      ) =>
        0.25,
      (
        ProgressionHarmonicFunction.predominant,
        ProgressionHarmonicFunction.predominant,
      ) =>
        0.2,
      (
        ProgressionHarmonicFunction.dominant,
        ProgressionHarmonicFunction.dominant,
      ) =>
        0.15,
      _ => 0.0,
    };
  }

  double _placeholderBridgeBonus({
    required RomanNumeralId candidateRoman,
    required ProgressionHarmonicFunction candidateFunction,
    required AnalyzedChord? left,
    required AnalyzedChord? right,
  }) {
    var score = 0.0;
    final rightRoman = right?.romanNumeralId;

    if (left != null && right != null) {
      if (left.harmonicFunction == ProgressionHarmonicFunction.predominant &&
          right.harmonicFunction == ProgressionHarmonicFunction.tonic &&
          candidateFunction == ProgressionHarmonicFunction.dominant) {
        score += 3.6;
      }
      if (left.harmonicFunction == ProgressionHarmonicFunction.tonic &&
          right.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          candidateFunction == ProgressionHarmonicFunction.predominant) {
        score += 2.6;
      }
      if (left.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          right.harmonicFunction == ProgressionHarmonicFunction.tonic) {
        score += _isTonicRoman(candidateRoman)
            ? 3.4
            : candidateFunction == ProgressionHarmonicFunction.tonic
            ? 1.4
            : 0;
      }
      if (rightRoman != null && candidateRoman == rightRoman) {
        score -= 1.1;
      }
    } else if (left != null) {
      if (left.harmonicFunction == ProgressionHarmonicFunction.predominant &&
          candidateFunction == ProgressionHarmonicFunction.dominant) {
        score += 2.2;
      }
      if (left.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _isTonicRoman(candidateRoman)) {
        score += 2.8;
      }
    } else if (right != null) {
      if (candidateFunction == ProgressionHarmonicFunction.predominant &&
          right.harmonicFunction == ProgressionHarmonicFunction.dominant) {
        score += 2.6;
      }
      if (_isTonicRoman(candidateRoman) &&
          right.harmonicFunction == ProgressionHarmonicFunction.tonic) {
        score += 1.2;
      }
    }

    return score;
  }

  List<ProgressionRemark> _placeholderRemarksForSpec(RomanSpec spec) {
    final resolutionTarget = spec.resolutionTargetId;
    return switch (spec.sourceKind) {
      ChordSourceKind.secondaryDominant when resolutionTarget != null => [
        ProgressionRemark(
          kind: ProgressionRemarkKind.possibleSecondaryDominant,
          targetRomanNumeral: _displayResolutionTargetRoman(resolutionTarget),
        ),
      ],
      ChordSourceKind.substituteDominant when resolutionTarget != null => [
        ProgressionRemark(
          kind: ProgressionRemarkKind.possibleTritoneSubstitute,
          targetRomanNumeral: _displayResolutionTargetRoman(resolutionTarget),
        ),
      ],
      ChordSourceKind.modalInterchange => const [
        ProgressionRemark(kind: ProgressionRemarkKind.possibleModalInterchange),
      ],
      _ => const <ProgressionRemark>[],
    };
  }

  List<ProgressionEvidence> _placeholderEvidenceForSpec(
    RomanSpec spec,
    RomanNumeralId? rightRoman,
  ) {
    final evidence = <ProgressionEvidence>[];
    if (spec.sourceKind == ChordSourceKind.modalInterchange) {
      evidence.add(
        const ProgressionEvidence(kind: ProgressionEvidenceKind.borrowedColor),
      );
    }
    if (rightRoman != null && spec.resolutionTargetId == rightRoman) {
      evidence.add(
        ProgressionEvidence(
          kind: ProgressionEvidenceKind.resolution,
          detail: _displayResolutionTargetRoman(rightRoman),
        ),
      );
    }
    return evidence;
  }

  double _placeholderConfidence({
    required double gap,
    required bool hasBothSides,
    required ChordSourceKind sourceKind,
  }) {
    var confidence = 0.42 + (gap / 5.8);
    if (hasBothSides) {
      confidence += 0.1;
    }
    if (sourceKind != ChordSourceKind.diatonic) {
      confidence -= 0.04;
    }
    return (confidence.clamp(0.2, 0.94) as num).toDouble();
  }

  ParsedChord _buildInferredParsedChord({
    required ParsedChordToken token,
    required KeyCenter keyCenter,
    required RomanNumeralId romanNumeralId,
  }) {
    final spec = MusicTheory.specFor(romanNumeralId);
    final root = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      romanNumeralId,
    );
    final rootSemitone = MusicTheory.noteToSemitone[root] ?? 0;
    final normalizedSuffix = _specQualitySuffix(spec.quality);

    return ParsedChord(
      sourceSymbol: token.rawText,
      root: root,
      rootSemitone: rootSemitone,
      displayQuality: spec.quality,
      analysisFamily: MusicTheory.familyForQuality(spec.quality),
      measureIndex: token.measureIndex,
      positionInMeasure: token.positionInMeasure,
      suffix: normalizedSuffix,
      normalizedSuffix: normalizedSuffix,
      extension: _extensionForQuality(spec.quality),
      tensions: _defaultTensionsForQuality(spec.quality),
      alterations: _defaultAlterationsForQuality(spec.quality),
      suspensions: _defaultSuspensionsForQuality(spec.quality),
    );
  }

  String _symbolForRoman(KeyCenter keyCenter, RomanNumeralId romanNumeralId) {
    final root = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      romanNumeralId,
    );
    return '$root${_specQualitySuffix(MusicTheory.specFor(romanNumeralId).quality)}';
  }

  int? _extensionForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.major7 ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminished7 ||
      ChordQuality.dominant7 ||
      ChordQuality.dominant7Alt ||
      ChordQuality.dominant7Sharp11 ||
      ChordQuality.dominant7sus4 => 7,
      ChordQuality.six || ChordQuality.minor6 || ChordQuality.major69 => 6,
      ChordQuality.dominant13sus4 => 13,
      _ => null,
    };
  }

  List<String> _defaultTensionsForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.major69 => const ['9'],
      ChordQuality.dominant7Sharp11 => const ['#11'],
      ChordQuality.dominant13sus4 => const ['13'],
      _ => const <String>[],
    };
  }

  List<String> _defaultAlterationsForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.dominant7Alt => const ['alt'],
      ChordQuality.dominant7Sharp11 => const ['#11'],
      _ => const <String>[],
    };
  }

  List<String> _defaultSuspensionsForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.dominant13sus4 || ChordQuality.dominant7sus4 => const ['4'],
      _ => const <String>[],
    };
  }

  AnalyzedChord _bestInterpretation({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
    required int index,
  }) {
    final chord = chords[index];
    final candidates = <_InterpretationCandidate>[
      ..._specCandidates(keyCenter: keyCenter, chords: chords, index: index),
      ..._genericTritoneCandidates(
        keyCenter: keyCenter,
        chords: chords,
        index: index,
      ),
    ]..sort((left, right) => right.score.compareTo(left.score));

    if (candidates.isEmpty) {
      return _fallbackInterpretation(chord, keyCenter);
    }

    final best = candidates.first;
    final competingInterpretations = _competingInterpretations(
      candidates: candidates,
      primary: best,
    );
    final second = competingInterpretations.isNotEmpty
        ? competingInterpretations.first
        : null;
    final gap = second == null ? 3.8 : best.score - second.score;
    final ambiguous = second != null && gap < 1.35;

    return AnalyzedChord(
      chord: chord,
      romanNumeral: best.romanNumeral,
      harmonicFunction: best.harmonicFunction,
      romanNumeralId: best.romanNumeralId,
      sourceKind: best.sourceKind,
      score: best.score,
      confidence: _candidateConfidence(chord: chord, gap: gap),
      isAmbiguous: ambiguous || best.ambiguous,
      remarks: [
        ...best.remarks,
        if (ambiguous)
          const ProgressionRemark(
            kind: ProgressionRemarkKind.ambiguousInterpretation,
          ),
      ],
      evidence: best.evidence,
      competingInterpretations: competingInterpretations,
      userFacingLabel: _userFacingLabelForAnalysis(
        romanNumeral: best.romanNumeral,
        remarks: best.remarks,
        romanNumeralId: best.romanNumeralId,
      ),
    );
  }

  List<_InterpretationCandidate> _specCandidates({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
    required int index,
  }) {
    final chord = chords[index];
    final nextChord = index + 1 < chords.length ? chords[index + 1] : null;
    final nextNextChord = index + 2 < chords.length ? chords[index + 2] : null;
    final candidates = <_InterpretationCandidate>[];

    for (final entry in MusicTheory.romanSpecs.entries) {
      final spec = entry.value;
      if (spec.homeMode != null && spec.homeMode != keyCenter.mode) {
        continue;
      }
      final resolutionTarget = MusicTheory.modeAwareResolutionTarget(
        entry.key,
        keyCenter.mode,
      );

      final resolvedRoot = MusicTheory.resolveChordRootForCenter(
        keyCenter,
        entry.key,
      );
      final resolvedSemitone = MusicTheory.noteToSemitone[resolvedRoot];
      if (resolvedSemitone == null || resolvedSemitone != chord.rootSemitone) {
        continue;
      }

      final compatibility = _qualityCompatibility(
        chord: chord,
        expected: spec.quality,
      );
      if (compatibility == null) {
        continue;
      }
      if ((spec.sourceKind == ChordSourceKind.secondaryDominant ||
              spec.sourceKind == ChordSourceKind.substituteDominant) &&
          !chord.isDominantLike) {
        continue;
      }

      var score = _baseScoreForSource(spec.sourceKind) * compatibility;
      final remarks = <ProgressionRemark>[];
      final evidence = <ProgressionEvidence>[
        const ProgressionEvidence(kind: ProgressionEvidenceKind.qualityMatch),
      ];

      score += _nuanceBonus(chord: chord, spec: spec);
      evidence.addAll(_evidenceForChord(chord: chord, spec: spec));

      if (_isTonicRoman(entry.key)) {
        if (index == chords.length - 1) {
          score += 4.0;
        }
        if (index == 0) {
          score += 1.5;
        }
      }

      if (spec.sourceKind == ChordSourceKind.secondaryDominant ||
          spec.sourceKind == ChordSourceKind.substituteDominant) {
        if (resolutionTarget != null) {
          final targetRoman = _displayResolutionTargetRoman(resolutionTarget);
          final resolutionScore = _resolutionScore(
            sourceChord: chord,
            keyCenter: keyCenter,
            resolutionTarget: resolutionTarget,
            nextChord: nextChord,
            nextNextChord: nextNextChord,
          );
          score += resolutionScore;
          if (resolutionScore > 0) {
            evidence.add(
              ProgressionEvidence(
                kind: ProgressionEvidenceKind.resolution,
                detail: targetRoman,
              ),
            );
          }
          remarks.add(
            ProgressionRemark(
              kind: spec.sourceKind == ChordSourceKind.secondaryDominant
                  ? ProgressionRemarkKind.possibleSecondaryDominant
                  : ProgressionRemarkKind.possibleTritoneSubstitute,
              targetRomanNumeral: targetRoman,
            ),
          );
          if (resolutionScore < 0) {
            remarks.add(
              const ProgressionRemark(
                kind: ProgressionRemarkKind.ambiguousInterpretation,
              ),
            );
          }
        }
      }

      if (spec.sourceKind == ChordSourceKind.modalInterchange) {
        remarks.add(
          const ProgressionRemark(
            kind: ProgressionRemarkKind.possibleModalInterchange,
          ),
        );
        evidence.add(
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.borrowedColor,
          ),
        );
      }

      candidates.add(
        _InterpretationCandidate(
          romanNumeral: _displayRomanForCandidate(
            chord: chord,
            romanNumeralId: entry.key,
            sourceKind: spec.sourceKind,
            keyCenter: keyCenter,
            resolutionTarget: resolutionTarget,
          ),
          harmonicFunction: _mapFunction(spec.harmonicFunction),
          romanNumeralId: entry.key,
          sourceKind: spec.sourceKind,
          score: score,
          sourceReason: _sourceReasonForSpec(spec),
          remarks: remarks,
          evidence: evidence,
        ),
      );
    }

    return candidates;
  }

  List<_InterpretationCandidate> _genericTritoneCandidates({
    required KeyCenter keyCenter,
    required List<ParsedChord> chords,
    required int index,
  }) {
    final chord = chords[index];
    if (!chord.isDominantFamily || index >= chords.length - 1) {
      return const [];
    }

    final nextChord = chords[index + 1];
    if (chord.rootSemitone != ((nextChord.rootSemitone + 1) % 12)) {
      return const [];
    }

    final targetCandidate = _bestDiatonicTarget(nextChord, keyCenter);
    final targetDegree = targetCandidate?.romanNumeralId == null
        ? _fallbackDegreeForChord(nextChord, keyCenter)
        : MusicTheory.romanDegreeTokenOf(targetCandidate!.romanNumeralId!);
    final targetRoman =
        targetCandidate?.romanNumeral ??
        _fallbackRomanForChord(nextChord, keyCenter);

    return [
      _InterpretationCandidate(
        romanNumeral:
            'subV${chord.normalizedSuffix.isEmpty ? '7' : chord.normalizedSuffix}/$targetDegree',
        harmonicFunction: ProgressionHarmonicFunction.dominant,
        score: 8.4 + (targetCandidate == null ? 0 : 1.2),
        sourceReason: 'tritone substitute motion',
        remarks: [
          ProgressionRemark(
            kind: ProgressionRemarkKind.possibleTritoneSubstitute,
            targetRomanNumeral: targetRoman,
          ),
        ],
        evidence: [
          const ProgressionEvidence(
            kind: ProgressionEvidenceKind.alteredDominantColor,
          ),
          ProgressionEvidence(
            kind: ProgressionEvidenceKind.resolution,
            detail: targetRoman,
          ),
          if (chord.hasSlashBass)
            ProgressionEvidence(
              kind: ProgressionEvidenceKind.slashBass,
              detail: chord.bass,
            ),
        ],
        ambiguous: true,
      ),
    ];
  }

  _InterpretationCandidate? _bestDiatonicTarget(
    ParsedChord chord,
    KeyCenter keyCenter,
  ) {
    final candidates = <_InterpretationCandidate>[];
    for (final romanId in MusicTheory.diatonicRomansForMode(keyCenter.mode)) {
      final spec = MusicTheory.specFor(romanId);
      final root = MusicTheory.resolveChordRootForCenter(keyCenter, romanId);
      final semitone = MusicTheory.noteToSemitone[root];
      final compatibility = _qualityCompatibility(
        chord: chord,
        expected: spec.quality,
      );
      if (semitone == chord.rootSemitone && compatibility != null) {
        candidates.add(
          _InterpretationCandidate(
            romanNumeral: _displayRomanForCandidate(
              chord: chord,
              romanNumeralId: romanId,
              sourceKind: spec.sourceKind,
              keyCenter: keyCenter,
            ),
            harmonicFunction: _mapFunction(spec.harmonicFunction),
            romanNumeralId: romanId,
            sourceKind: spec.sourceKind,
            score: 6 * compatibility,
            evidence: _evidenceForChord(chord: chord, spec: spec),
          ),
        );
      }
    }
    if (candidates.isEmpty) {
      return null;
    }
    candidates.sort((left, right) => right.score.compareTo(left.score));
    return candidates.first;
  }

  AnalyzedChord _fallbackInterpretation(
    ParsedChord chord,
    KeyCenter keyCenter,
  ) {
    return AnalyzedChord(
      chord: chord,
      romanNumeral: _fallbackRomanForChord(chord, keyCenter),
      harmonicFunction: _fallbackHarmonicFunction(chord, keyCenter),
      score: -2,
      confidence: 0.2,
      isAmbiguous: true,
      remarks: const [
        ProgressionRemark(kind: ProgressionRemarkKind.unresolved),
      ],
    );
  }

  String _fallbackRomanForChord(ParsedChord chord, KeyCenter keyCenter) {
    return '${_fallbackDegreeForChord(chord, keyCenter)}${chord.normalizedSuffix}';
  }

  String _fallbackDegreeForChord(ParsedChord chord, KeyCenter keyCenter) {
    final tonic = keyCenter.tonicSemitone;
    if (tonic == null) {
      return '?';
    }
    final offset = (chord.rootSemitone - tonic) % 12;
    return switch (offset) {
      0 => 'I',
      1 => 'bII',
      2 => 'II',
      3 => 'bIII',
      4 => 'III',
      5 => 'IV',
      6 => keyCenter.mode == KeyMode.major ? '#IV' : 'bV',
      7 => 'V',
      8 => 'bVI',
      9 => 'VI',
      10 => 'bVII',
      11 => 'VII',
      _ => '?',
    };
  }

  ProgressionHarmonicFunction _fallbackHarmonicFunction(
    ParsedChord chord,
    KeyCenter keyCenter,
  ) {
    final tonic = keyCenter.tonicSemitone;
    if (tonic == null) {
      return ProgressionHarmonicFunction.other;
    }

    final offset = (chord.rootSemitone - tonic) % 12;
    return switch (offset) {
      0 => ProgressionHarmonicFunction.tonic,
      2 || 5 => ProgressionHarmonicFunction.predominant,
      7 || 11 => ProgressionHarmonicFunction.dominant,
      _ => ProgressionHarmonicFunction.other,
    };
  }

  double? _qualityCompatibility({
    required ParsedChord chord,
    required ChordQuality expected,
  }) {
    final actualFamily = chord.analysisFamily;
    final expectedFamily = MusicTheory.familyForQuality(expected);

    if (actualFamily == expectedFamily) {
      return _sameFamilyCompatibility(chord: chord, expected: expected);
    }

    if (actualFamily == ChordFamily.major &&
        expectedFamily == ChordFamily.dominant) {
      return chord.displayQuality == ChordQuality.majorTriad ? 0.86 : 0.72;
    }

    if (actualFamily == ChordFamily.augmented &&
        expectedFamily == ChordFamily.dominant &&
        chord.extension == 7) {
      return 0.84;
    }

    if (actualFamily == ChordFamily.diminished &&
        expectedFamily == ChordFamily.halfDiminished) {
      return 0.62;
    }

    return null;
  }

  double _sameFamilyCompatibility({
    required ParsedChord chord,
    required ChordQuality expected,
  }) {
    return switch (chord.analysisFamily) {
      ChordFamily.major => switch (expected) {
        ChordQuality.major7 =>
          chord.displayQuality == ChordQuality.major7
              ? 1.0
              : chord.displayQuality == ChordQuality.majorTriad
              ? 0.93
              : chord.displayQuality == ChordQuality.six
              ? 0.87
              : 0.84,
        ChordQuality.major69 =>
          chord.displayQuality == ChordQuality.major69
              ? 1.0
              : chord.displayQuality == ChordQuality.six
              ? 0.9
              : chord.displayQuality == ChordQuality.majorTriad
              ? 0.86
              : 0.82,
        _ => 0.92,
      },
      ChordFamily.minor => switch (expected) {
        ChordQuality.minor7 =>
          chord.displayQuality == ChordQuality.minor7
              ? 1.0
              : chord.displayQuality == ChordQuality.minorTriad
              ? 0.93
              : chord.displayQuality == ChordQuality.minor6
              ? 0.88
              : 0.84,
        ChordQuality.minorMajor7 =>
          chord.displayQuality == ChordQuality.minorMajor7
              ? 1.0
              : chord.displayQuality == ChordQuality.minorTriad
              ? 0.88
              : 0.82,
        ChordQuality.minor6 =>
          chord.displayQuality == ChordQuality.minor6
              ? 1.0
              : chord.displayQuality == ChordQuality.minorTriad
              ? 0.9
              : 0.84,
        _ => 0.92,
      },
      ChordFamily.dominant => switch (expected) {
        ChordQuality.dominant13sus4 =>
          chord.displayQuality == ChordQuality.dominant13sus4
              ? 1.0
              : chord.hasSuspension
              ? 0.9
              : 0.8,
        ChordQuality.dominant7sus4 =>
          chord.displayQuality == ChordQuality.dominant7sus4
              ? 1.0
              : chord.displayQuality == ChordQuality.dominant13sus4
              ? 0.95
              : chord.hasSuspension
              ? 0.88
              : 0.8,
        ChordQuality.dominant7 =>
          chord.displayQuality == ChordQuality.dominant7
              ? 1.0
              : chord.hasSuspension
              ? 0.9
              : chord.hasAlteredColor
              ? 0.98
              : chord.normalizedSuffix.isEmpty
              ? 0.86
              : 0.94,
        _ => 0.9,
      },
      ChordFamily.halfDiminished =>
        expected == ChordQuality.halfDiminished7 ? 1.0 : 0.82,
      ChordFamily.diminished => switch (expected) {
        ChordQuality.diminished7 =>
          chord.displayQuality == ChordQuality.diminished7 ? 1.0 : 0.74,
        ChordQuality.diminishedTriad => 1.0,
        _ => 0.7,
      },
      ChordFamily.augmented =>
        chord.extension == 7 && expected == ChordQuality.dominant7
            ? 0.84
            : 0.72,
    };
  }

  String _displayRomanForCandidate({
    required ParsedChord chord,
    required RomanNumeralId romanNumeralId,
    required ChordSourceKind sourceKind,
    required KeyCenter keyCenter,
    RomanNumeralId? resolutionTarget,
  }) {
    if (sourceKind == ChordSourceKind.secondaryDominant ||
        sourceKind == ChordSourceKind.substituteDominant) {
      final dominantHead = sourceKind == ChordSourceKind.substituteDominant
          ? 'subV'
          : 'V';
      final denominator = resolutionTarget == null
          ? '?'
          : MusicTheory.romanDegreeTokenOf(resolutionTarget);
      return '$dominantHead${chord.normalizedSuffix}/$denominator';
    }
    return '${MusicTheory.romanDegreeTokenOf(romanNumeralId)}${chord.normalizedSuffix}';
  }

  String _displayResolutionTargetRoman(RomanNumeralId romanNumeralId) {
    final spec = MusicTheory.specFor(romanNumeralId);
    return '${MusicTheory.romanDegreeTokenOf(romanNumeralId)}${_specQualitySuffix(spec.quality)}';
  }

  String _specQualitySuffix(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.majorTriad => '',
      ChordQuality.minorTriad => 'm',
      ChordQuality.dominant7 => '7',
      ChordQuality.major7 => 'maj7',
      ChordQuality.minor7 => 'm7',
      ChordQuality.minorMajor7 => 'mMaj7',
      ChordQuality.halfDiminished7 => 'm7b5',
      ChordQuality.diminishedTriad => 'dim',
      ChordQuality.diminished7 => 'dim7',
      ChordQuality.augmentedTriad => 'aug',
      ChordQuality.six => '6',
      ChordQuality.minor6 => 'm6',
      ChordQuality.major69 => '6/9',
      ChordQuality.dominant7Alt => '7alt',
      ChordQuality.dominant7Sharp11 => '7(#11)',
      ChordQuality.dominant13sus4 => '13sus4',
      ChordQuality.dominant7sus4 => '7sus4',
    };
  }

  double _baseScoreForSource(ChordSourceKind sourceKind) {
    return switch (sourceKind) {
      ChordSourceKind.diatonic => 14,
      ChordSourceKind.secondaryDominant => 11.5,
      ChordSourceKind.substituteDominant => 10,
      ChordSourceKind.modalInterchange => 8.8,
      ChordSourceKind.tonicization => 8,
      ChordSourceKind.free => 4,
    };
  }

  double _nuanceBonus({required ParsedChord chord, required RomanSpec spec}) {
    var bonus = 0.0;
    if (chord.hasExtension && chord.extension! >= 9) {
      bonus += switch (spec.harmonicFunction) {
        HarmonicFunction.tonic => 0.4,
        HarmonicFunction.predominant => 0.3,
        HarmonicFunction.dominant => 0.55,
        HarmonicFunction.free => 0.0,
      };
    }
    if (chord.hasAlteredColor &&
        spec.harmonicFunction == HarmonicFunction.dominant) {
      bonus += 0.9;
    }
    if (chord.hasSuspension &&
        spec.harmonicFunction == HarmonicFunction.dominant) {
      bonus += 0.45;
    }
    if (chord.hasSlashBass) {
      final bassBonus = _slashBassBonus(chord: chord, spec: spec);
      bonus += bassBonus;
    }
    return bonus;
  }

  List<ProgressionEvidence> _evidenceForChord({
    required ParsedChord chord,
    required RomanSpec spec,
  }) {
    final evidence = <ProgressionEvidence>[];
    if (chord.hasExtension && chord.extension! >= 9) {
      evidence.add(
        ProgressionEvidence(
          kind: ProgressionEvidenceKind.extensionColor,
          detail: chord.extension!.toString(),
        ),
      );
    }
    if (chord.hasAlteredColor &&
        spec.harmonicFunction == HarmonicFunction.dominant) {
      evidence.add(
        const ProgressionEvidence(
          kind: ProgressionEvidenceKind.alteredDominantColor,
        ),
      );
    }
    if (chord.hasSuspension) {
      evidence.add(
        const ProgressionEvidence(
          kind: ProgressionEvidenceKind.suspensionColor,
        ),
      );
    }
    if (chord.hasSlashBass) {
      evidence.add(
        ProgressionEvidence(
          kind: ProgressionEvidenceKind.slashBass,
          detail: chord.bass,
        ),
      );
    }
    return evidence;
  }

  double _slashBassBonus({
    required ParsedChord chord,
    required RomanSpec spec,
  }) {
    final bassSemitone = chord.bassSemitone;
    if (bassSemitone == null) {
      return 0;
    }
    final thirdOffset = switch (spec.quality) {
      ChordQuality.minorTriad ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.minor6 ||
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 => 3,
      _ => 4,
    };
    if (bassSemitone == ((chord.rootSemitone + thirdOffset) % 12)) {
      return 0.48;
    }
    if (bassSemitone == ((chord.rootSemitone + 7) % 12)) {
      return 0.18;
    }
    if (spec.harmonicFunction == HarmonicFunction.dominant &&
        bassSemitone == ((chord.rootSemitone + 10) % 12)) {
      return 0.22;
    }
    return 0.08;
  }

  double _candidateConfidence({
    required ParsedChord chord,
    required double gap,
  }) {
    var confidence = 0.56 + (gap / 6.5);
    if (chord.hasParserWarnings) {
      confidence -= 0.08;
    }
    if (chord.hasAlteredColor) {
      confidence += 0.03;
    }
    if (chord.hasSlashBass) {
      confidence += 0.02;
    }
    return (confidence.clamp(0.18, 0.98) as num).toDouble();
  }

  ProgressionDiagnosticStatus _diagnosticStatus({
    required ProgressionParseResult parseResult,
    required List<AnalyzedChord> chordAnalyses,
    required List<ProgressionWarningCode> warningCodes,
    required ProgressionKeyCandidate? alternativeKey,
    required double analysisReliability,
    required double keyConfidence,
  }) {
    if (parseResult.issues.isNotEmpty) {
      return ProgressionDiagnosticStatus.partialParse;
    }
    if (parseResult.placeholders.isNotEmpty) {
      return ProgressionDiagnosticStatus.placeholderInference;
    }
    final unresolvedChordCount = chordAnalyses
        .where(
          (analysis) => analysis.hasRemark(ProgressionRemarkKind.unresolved),
        )
        .length;
    if (warningCodes.contains(ProgressionWarningCode.unresolvedChord) ||
        unresolvedChordCount > 0) {
      return ProgressionDiagnosticStatus.unresolvedHarmony;
    }
    final hasMeaningfulAmbiguity =
        warningCodes.contains(ProgressionWarningCode.ambiguousInterpretation) &&
        (alternativeKey != null ||
            chordAnalyses.any((analysis) => analysis.isAmbiguous) ||
            keyConfidence < 0.72);
    if (hasMeaningfulAmbiguity || analysisReliability < 0.68) {
      return ProgressionDiagnosticStatus.ambiguousHarmony;
    }
    return ProgressionDiagnosticStatus.clean;
  }

  List<ProgressionWarningCode> _warningCodes({
    required ProgressionParseResult parseResult,
    required List<AnalyzedChord> chordAnalyses,
    required ProgressionKeyCandidate? alternativeKey,
    required double analysisReliability,
    required double keyConfidence,
  }) {
    final codes = <ProgressionWarningCode>{};

    if (parseResult.issues.isNotEmpty) {
      codes.add(ProgressionWarningCode.parseIssue);
    }
    if (parseResult.issues.any((issue) => issue.error == 'invalid-bass')) {
      codes.add(ProgressionWarningCode.invalidBass);
    }
    if (parseResult.placeholders.isNotEmpty) {
      codes.add(ProgressionWarningCode.placeholderUsed);
    }
    if (chordAnalyses.any((analysis) => analysis.chord.hasParserWarnings)) {
      codes.add(ProgressionWarningCode.unknownModifier);
    }
    if (chordAnalyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.unresolved),
    )) {
      codes.add(ProgressionWarningCode.unresolvedChord);
    }
    final meaningfulAlternative =
        alternativeKey != null && keyConfidence < 0.72;
    final meaningfulChordAmbiguity = chordAnalyses.any(
      (analysis) => analysis.isAmbiguous,
    );
    final sparseContext = analysisReliability < 0.68 && keyConfidence < 0.74;
    if (meaningfulAlternative || meaningfulChordAmbiguity || sparseContext) {
      codes.add(ProgressionWarningCode.ambiguousInterpretation);
    }

    return codes.toList(growable: false);
  }

  List<AnalyzedChord> _normalizeChordAnalyses(List<AnalyzedChord> analyses) {
    return [
      for (final analysis in analyses)
        _normalizeChordAnalysis(analysis, analyses: analyses),
    ];
  }

  AnalyzedChord _normalizeChordAnalysis(
    AnalyzedChord analysis, {
    required List<AnalyzedChord> analyses,
  }) {
    var remarks = _dedupeRemarks(analysis.remarks);
    final evidence = _dedupeEvidence(analysis.evidence);
    var competitors = _dedupeCandidateList(
      analysis.competingInterpretations,
      primaryRoman: analysis.romanNumeral,
      primaryFunction: analysis.harmonicFunction,
      primarySourceKind: analysis.sourceKind,
      primaryScore: analysis.score,
    );
    var normalizedRoman = analysis.romanNumeral;
    var normalizedRomanId = analysis.romanNumeralId;
    var normalizedSourceKind = analysis.sourceKind;
    final isBackdoorPrimary = remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.backdoorDominant,
    );
    if (isBackdoorPrimary) {
      if (analysis.romanNumeral.startsWith('subV')) {
        competitors = _prependBackdoorAlternative(
          romanNumeral: analysis.romanNumeral,
          sourceKind: analysis.sourceKind,
          score: analysis.score - 0.3,
          candidates: competitors,
        );
        normalizedRoman = 'bVII7';
        normalizedRomanId = RomanNumeralId.borrowedFlatVII7;
        normalizedSourceKind = ChordSourceKind.modalInterchange;
      }
    }
    final meaningfulAmbiguity =
        competitors.isNotEmpty &&
        !competitors.every(
          (candidate) =>
              isBackdoorPrimary && _isBackdoorSemanticVariant(candidate),
        );
    if (!meaningfulAmbiguity) {
      remarks = [
        for (final remark in remarks)
          if (remark.kind != ProgressionRemarkKind.ambiguousInterpretation &&
              remark.kind != ProgressionRemarkKind.dualFunctionAmbiguity)
            remark,
      ];
    }
    return analysis.copyWith(
      romanNumeral: normalizedRoman,
      romanNumeralId: normalizedRomanId,
      sourceKind: normalizedSourceKind,
      remarks: remarks,
      evidence: evidence,
      competingInterpretations: competitors,
      isAmbiguous: analysis.hasRemark(ProgressionRemarkKind.unresolved)
          ? false
          : meaningfulAmbiguity,
      userFacingLabel: _userFacingLabelForAnalysis(
        romanNumeral: analysis.romanNumeral,
        remarks: remarks,
        romanNumeralId: analysis.romanNumeralId,
      ),
    );
  }

  List<ChordInterpretationCandidate> _prependBackdoorAlternative({
    required String romanNumeral,
    required ChordSourceKind? sourceKind,
    required double score,
    required List<ChordInterpretationCandidate> candidates,
  }) {
    final alternative = ChordInterpretationCandidate(
      romanNumeral: romanNumeral,
      harmonicFunction: ProgressionHarmonicFunction.dominant,
      sourceKind: sourceKind,
      score: score,
    );
    return _dedupeCandidateList(
      [alternative, ...candidates],
      primaryRoman: 'bVII7',
      primaryFunction: ProgressionHarmonicFunction.dominant,
      primarySourceKind: ChordSourceKind.modalInterchange,
      primaryScore: score + 0.3,
    );
  }

  bool _isBackdoorSemanticVariant(ChordInterpretationCandidate candidate) {
    return candidate.romanNumeral == 'bVII7' ||
        candidate.romanNumeral.startsWith('subV');
  }

  List<ProgressionRemark> _dedupeRemarks(List<ProgressionRemark> remarks) {
    final unique = <String, ProgressionRemark>{};
    for (final remark in remarks) {
      final key =
          '${remark.kind.name}|${remark.targetRomanNumeral ?? ''}|${remark.targetKeyCenter?.serialize() ?? ''}|${remark.detail ?? ''}';
      unique.putIfAbsent(key, () => remark);
    }
    return unique.values.toList(growable: false);
  }

  List<ProgressionEvidence> _dedupeEvidence(
    List<ProgressionEvidence> evidence,
  ) {
    final unique = <String, ProgressionEvidence>{};
    for (final item in evidence) {
      final key = '${item.kind.name}|${item.detail ?? ''}';
      unique.putIfAbsent(key, () => item);
    }
    return unique.values.toList(growable: false);
  }

  List<ChordInterpretationCandidate> _dedupeCandidateList(
    List<ChordInterpretationCandidate> candidates, {
    required String primaryRoman,
    required ProgressionHarmonicFunction primaryFunction,
    required ChordSourceKind? primarySourceKind,
    required double primaryScore,
  }) {
    final bySemanticKey = <String, ChordInterpretationCandidate>{};
    for (final candidate in candidates) {
      final isPrimaryEquivalent =
          candidate.romanNumeral == primaryRoman &&
          candidate.harmonicFunction == primaryFunction &&
          candidate.sourceKind == primarySourceKind;
      if (isPrimaryEquivalent) {
        continue;
      }
      if ((primaryScore - candidate.score) > 2.4) {
        continue;
      }
      final existing = bySemanticKey[candidate.semanticKey];
      if (existing == null || candidate.score > existing.score) {
        bySemanticKey[candidate.semanticKey] = candidate;
      }
    }
    final deduped = bySemanticKey.values.toList(growable: false)
      ..sort((left, right) => right.score.compareTo(left.score));
    return deduped.take(3).toList(growable: false);
  }

  List<ChordInterpretationCandidate> _competingInterpretations({
    required List<_InterpretationCandidate> candidates,
    required _InterpretationCandidate primary,
  }) {
    final raw = [
      for (final candidate in candidates.skip(1))
        ChordInterpretationCandidate(
          romanNumeral: candidate.romanNumeral,
          harmonicFunction: candidate.harmonicFunction,
          romanNumeralId: candidate.romanNumeralId,
          sourceKind: candidate.sourceKind,
          score: candidate.score,
          sourceReason: candidate.sourceReason,
          displayLabel: _userFacingLabelForAnalysis(
            romanNumeral: candidate.romanNumeral,
            remarks: candidate.remarks,
            romanNumeralId: candidate.romanNumeralId,
          ).primary,
          displayAlias: _userFacingLabelForAnalysis(
            romanNumeral: candidate.romanNumeral,
            remarks: candidate.remarks,
            romanNumeralId: candidate.romanNumeralId,
          ).alias,
          remarks: candidate.remarks,
          evidence: candidate.evidence,
        ),
    ];
    return _dedupeCandidateList(
      raw,
      primaryRoman: primary.romanNumeral,
      primaryFunction: primary.harmonicFunction,
      primarySourceKind: primary.sourceKind,
      primaryScore: primary.score,
    );
  }

  List<ChordInterpretationCandidate> _placeholderCompetingInterpretations({
    required List<_PlaceholderCandidate> candidates,
    required _PlaceholderCandidate primary,
  }) {
    final raw = [
      for (final candidate in candidates.skip(1))
        ChordInterpretationCandidate(
          romanNumeral: candidate.romanNumeral,
          harmonicFunction: candidate.harmonicFunction,
          chordSymbol: candidate.symbol,
          romanNumeralId: candidate.romanNumeralId,
          sourceKind: candidate.sourceKind,
          score: candidate.score,
          sourceReason: candidate.sourceReason,
          displayLabel: _userFacingLabelForAnalysis(
            romanNumeral: candidate.romanNumeral,
            remarks: candidate.remarks,
            romanNumeralId: candidate.romanNumeralId,
          ).primary,
          displayAlias: _userFacingLabelForAnalysis(
            romanNumeral: candidate.romanNumeral,
            remarks: candidate.remarks,
            romanNumeralId: candidate.romanNumeralId,
          ).alias,
          remarks: candidate.remarks,
          evidence: candidate.evidence,
        ),
    ];
    return _dedupeCandidateList(
      raw,
      primaryRoman: primary.romanNumeral,
      primaryFunction: primary.harmonicFunction,
      primarySourceKind: primary.sourceKind,
      primaryScore: primary.score,
    );
  }

  List<SuggestedFill> _buildSuggestedFills(
    List<_PlaceholderCandidate> candidates,
  ) {
    if (candidates.isEmpty) {
      return const [];
    }
    final maxScore = candidates.first.score;
    final weights = [
      for (final candidate in candidates)
        math.exp((candidate.score - maxScore) / 1.8),
    ];
    final total = weights.fold<double>(0.0, (sum, value) => sum + value);
    return [
      for (var index = 0; index < math.min(candidates.length, 4); index += 1)
        SuggestedFill(
          resolvedSymbol: candidates[index].symbol,
          romanNumeral: candidates[index].romanNumeral,
          harmonicFunction: candidates[index].harmonicFunction,
          score: candidates[index].score,
          confidence: (weights[index] / math.max(0.0001, total))
              .clamp(0.05, 0.95)
              .toDouble(),
          rationale: _placeholderRationaleForCandidate(candidates[index]),
          sourceReason: candidates[index].sourceReason,
          sourceKind: candidates[index].sourceKind,
        ),
    ];
  }

  UserFacingHarmonyLabel _userFacingLabelForAnalysis({
    required String romanNumeral,
    required List<ProgressionRemark> remarks,
    required RomanNumeralId? romanNumeralId,
  }) {
    if (remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.backdoorDominant,
    )) {
      return const UserFacingHarmonyLabel(
        primary: 'Backdoor dominant',
        alias: 'bVII7',
      );
    }
    if (remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.commonToneDiminished,
    )) {
      return const UserFacingHarmonyLabel(primary: '#Idim7', alias: 'CT°7');
    }
    if (romanNumeralId == RomanNumeralId.borrowedFlatVII7) {
      return const UserFacingHarmonyLabel(primary: 'bVII7');
    }
    return UserFacingHarmonyLabel(primary: romanNumeral);
  }

  String _sourceReasonForSpec(RomanSpec spec) {
    return switch (spec.sourceKind) {
      ChordSourceKind.diatonic => 'diatonic fit',
      ChordSourceKind.secondaryDominant => 'applied dominant pull',
      ChordSourceKind.substituteDominant => 'substitute dominant color',
      ChordSourceKind.modalInterchange => 'borrowed color',
      ChordSourceKind.tonicization => 'local cadence support',
      ChordSourceKind.free => 'contextual fallback',
    };
  }

  String _placeholderSourceReason({
    required RomanSpec spec,
    required AnalyzedChord? left,
    required AnalyzedChord? right,
  }) {
    if (spec.sourceKind == ChordSourceKind.secondaryDominant) {
      return 'resolves toward the following chord';
    }
    if (spec.sourceKind == ChordSourceKind.substituteDominant) {
      return 'chromatic substitute approach';
    }
    if (spec.sourceKind == ChordSourceKind.modalInterchange &&
        left?.hasRemark(ProgressionRemarkKind.subdominantMinor) == true) {
      return 'backdoor/modal interchange option';
    }
    if (left != null &&
        right != null &&
        left.harmonicFunction == ProgressionHarmonicFunction.predominant &&
        right.harmonicFunction == ProgressionHarmonicFunction.tonic) {
      return 'cadence completion';
    }
    return _sourceReasonForSpec(spec);
  }

  String _placeholderRationaleForCandidate(_PlaceholderCandidate candidate) {
    return switch (candidate.sourceKind) {
      ChordSourceKind.diatonic => 'Fits the current key best.',
      ChordSourceKind.secondaryDominant =>
        'Leads directly into the next target.',
      ChordSourceKind.substituteDominant =>
        'Offers a chromatic dominant approach.',
      ChordSourceKind.modalInterchange => 'Adds borrowed-color motion.',
      ChordSourceKind.tonicization => 'Supports a short local cadence.',
      ChordSourceKind.free => 'Loose contextual recovery.',
    };
  }

  bool _hasStrongHomeAnchor({
    required ProgressionParseResult parseResult,
    required List<AnalyzedChord> analyses,
  }) {
    if (analyses.isEmpty) {
      return false;
    }
    final openingWindow = analyses.take(4).toList(growable: false);
    if (_isTonic(analyses.first) &&
        (_functionalCadenceBonus(
                  analyses: openingWindow,
                  measureCount: math.max(1, parseResult.measures.length),
                ) >
                0 ||
            _openingHomeGestureBonus(openingWindow) > 0 ||
            _hasOpeningCadentialReturn(openingWindow))) {
      return true;
    }
    final emptyMeasureCount = parseResult.measures
        .where((measure) => measure.isEmpty)
        .length;
    return emptyMeasureCount > 0 &&
        _isTonic(analyses.first) &&
        analyses.any(
          (analysis) =>
              analysis.harmonicFunction == ProgressionHarmonicFunction.dominant,
        );
  }

  double _keyConfidence({
    required ProgressionKeyCandidate primaryKey,
    required List<ProgressionKeyCandidate> rankedCandidates,
    required List<AnalyzedChord> chordAnalyses,
  }) {
    if (rankedCandidates.isEmpty) {
      return 0.0;
    }
    final primaryIndex = rankedCandidates.indexWhere(
      (candidate) => candidate.keyCenter == primaryKey.keyCenter,
    );
    final topProbability = primaryIndex >= 0
        ? rankedCandidates[primaryIndex].confidence
        : rankedCandidates.first.confidence;
    final sortedProbabilities = [
      for (final candidate in rankedCandidates.take(5)) candidate.confidence,
    ];
    final entropy = sortedProbabilities.fold<double>(
      0.0,
      (sum, probability) => probability <= 0
          ? sum
          : sum - (probability * (math.log(probability) / math.ln2)),
    );
    final entropyNorm = sortedProbabilities.length <= 1
        ? 0.0
        : entropy / (math.log(sortedProbabilities.length) / math.ln2);
    final rivalProbability = rankedCandidates
        .where((candidate) => candidate.keyCenter != primaryKey.keyCenter)
        .map((candidate) => candidate.confidence)
        .fold<double>(0.0, math.max);
    final margin = (topProbability - rivalProbability).clamp(0.0, 1.0);
    final confidence =
        (0.22 +
        (topProbability * 0.46) +
        (margin * 0.22) +
        ((1 - entropyNorm) * 0.18));
    var adjusted = confidence;
    if (_hasStrongCadentialClosure(chordAnalyses)) {
      adjusted += 0.14;
    }
    if (_openingHomeGestureBonus(chordAnalyses) > 0) {
      adjusted += 0.1;
    }
    return adjusted.clamp(0.12, 0.97).toDouble();
  }

  double _analysisReliability({
    required ProgressionParseResult parseResult,
    required List<AnalyzedChord> chordAnalyses,
    required double keyConfidence,
    required ProgressionKeyCandidate primaryKey,
    required ProgressionKeyCandidate globalAggregateKey,
    required List<AnalysisSegment> analysisSegments,
  }) {
    var reliability = 0.24 + (keyConfidence * 0.64);
    final ambiguousRatio = chordAnalyses.isEmpty
        ? 0.0
        : chordAnalyses.where((analysis) => analysis.isAmbiguous).length /
              chordAnalyses.length;
    final unresolvedRatio = chordAnalyses.isEmpty
        ? 0.0
        : chordAnalyses
                  .where(
                    (analysis) =>
                        analysis.hasRemark(ProgressionRemarkKind.unresolved),
                  )
                  .length /
              chordAnalyses.length;
    if (parseResult.issues.isNotEmpty) {
      reliability -= 0.24 + math.min(0.12, parseResult.issues.length * 0.03);
    }
    if (parseResult.placeholders.isNotEmpty) {
      reliability -=
          0.2 + math.min(0.14, parseResult.placeholders.length * 0.05);
    }
    if (chordAnalyses.any((analysis) => analysis.chord.hasParserWarnings)) {
      reliability -= 0.04;
    }
    reliability -= unresolvedRatio * 0.42;
    reliability -= ambiguousRatio * 0.16;
    if (_hasIncompleteCadentialArc(chordAnalyses)) {
      reliability -= 0.07;
    }
    if (_hasSparseContext(parseResult: parseResult, analyses: chordAnalyses)) {
      reliability -= 0.06;
    }
    if (primaryKey.keyCenter != globalAggregateKey.keyCenter) {
      reliability -= 0.04;
    }
    if (analysisSegments.length > 1) {
      reliability -= 0.03;
    }
    if (_openingHomeGestureBonus(chordAnalyses) > 0 &&
        unresolvedRatio == 0 &&
        ambiguousRatio < 0.26) {
      reliability += 0.08;
    }
    return reliability.clamp(0.08, 0.97).toDouble();
  }

  bool _hasSparseContext({
    required ProgressionParseResult parseResult,
    required List<AnalyzedChord> analyses,
  }) {
    if (analyses.isEmpty) {
      return false;
    }
    final emptyMeasures = parseResult.measures
        .where((measure) => measure.isEmpty)
        .length;
    if (emptyMeasures > 0) {
      return true;
    }
    if (_hasStrongCadentialClosure(analyses)) {
      return false;
    }
    final hasFunctionalChain =
        analyses.isNotEmpty &&
        _isTonic(analyses.first) &&
        analyses.any(
          (analysis) =>
              analysis.harmonicFunction ==
              ProgressionHarmonicFunction.predominant,
        ) &&
        analyses.any(
          (analysis) =>
              analysis.harmonicFunction == ProgressionHarmonicFunction.dominant,
        );
    if (hasFunctionalChain && analyses.length >= 4) {
      return false;
    }
    return analyses.length <= 3 ||
        analyses.where((analysis) => _isTonic(analysis)).length < 2;
  }

  bool _hasIncompleteCadentialArc(List<AnalyzedChord> analyses) {
    final hasTonicAnchor = analyses.isNotEmpty && _isTonic(analyses.first);
    final hasPredominant = analyses.any(
      (analysis) =>
          analysis.harmonicFunction == ProgressionHarmonicFunction.predominant,
    );
    final hasDominant = analyses.any(
      (analysis) =>
          analysis.harmonicFunction == ProgressionHarmonicFunction.dominant,
    );
    final endsOnTonic = analyses.isNotEmpty && _isTonic(analyses.last);
    if (hasTonicAnchor &&
        hasPredominant &&
        hasDominant &&
        analyses.length >= 4) {
      return false;
    }
    return hasTonicAnchor && hasPredominant && hasDominant && !endsOnTonic;
  }

  bool _hasStrongCadentialClosure(List<AnalyzedChord> analyses) {
    for (var index = 0; index < analyses.length - 1; index += 1) {
      final left = analyses[index];
      final right = analyses[index + 1];
      if (left.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _isTonic(right)) {
        return true;
      }
    }
    return false;
  }

  List<ProgressionTagId> _normalizeTags({
    required List<AnalyzedChord> chordAnalyses,
    required List<AnalysisSegment> analysisSegments,
  }) {
    final tags = _detectTags(chordAnalyses).toSet();
    final hasRealModulation = analysisSegments.length > 1;
    final hasTonicization = chordAnalyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.tonicization),
    );
    if (hasRealModulation) {
      tags.add(ProgressionTagId.realModulation);
      tags.remove(ProgressionTagId.tonicization);
    } else {
      tags.remove(ProgressionTagId.realModulation);
      if (hasTonicization) {
        tags.add(ProgressionTagId.tonicization);
      } else {
        tags.remove(ProgressionTagId.tonicization);
      }
    }
    return tags.toList(growable: false);
  }

  ProgressionSelectionReason _selectionReason({
    required List<AnalysisSegment> analysisSegments,
    required ProgressionKeyCandidate primary,
    required ProgressionKeyCandidate? alternative,
  }) {
    if (analysisSegments.length > 1) {
      return ProgressionSelectionReason.segmentedModulation;
    }
    if (alternative != null &&
        (primary.score - alternative.score).abs() < 1.0) {
      return ProgressionSelectionReason.tieBreakerCadence;
    }
    return ProgressionSelectionReason.highestScore;
  }

  double _resolutionScore({
    required ParsedChord sourceChord,
    required KeyCenter keyCenter,
    required RomanNumeralId resolutionTarget,
    required ParsedChord? nextChord,
    required ParsedChord? nextNextChord,
  }) {
    final isMeasureEnd =
        nextChord == null || nextChord.measureIndex != sourceChord.measureIndex;
    if (nextChord == null) {
      return isMeasureEnd ? -1.6 : -1.2;
    }

    final targetRoot = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      resolutionTarget,
    );
    final targetSemitone = MusicTheory.noteToSemitone[targetRoot];
    final targetSpec = MusicTheory.specFor(resolutionTarget);

    if (targetSemitone == null) {
      return 0;
    }

    if (_matchesTarget(nextChord, targetSemitone, targetSpec.quality)) {
      final crossesIntoNextMeasure =
          nextChord.measureIndex == sourceChord.measureIndex + 1 &&
          nextChord.positionInMeasure == 0;
      return crossesIntoNextMeasure ? 6 : 5;
    }
    if (nextNextChord != null &&
        _matchesTarget(nextNextChord, targetSemitone, targetSpec.quality)) {
      final staysInCadentialWindow =
          nextNextChord.measureIndex - sourceChord.measureIndex <= 1;
      return staysInCadentialWindow ? 3.1 : 2.6;
    }
    return isMeasureEnd ? -1.6 : -1.2;
  }

  bool _matchesTarget(
    ParsedChord chord,
    int targetSemitone,
    ChordQuality targetQuality,
  ) {
    final compatibility = _qualityCompatibility(
      chord: chord,
      expected: targetQuality,
    );
    return chord.rootSemitone == targetSemitone && compatibility != null;
  }

  ProgressionHarmonicFunction _mapFunction(HarmonicFunction function) {
    return switch (function) {
      HarmonicFunction.tonic => ProgressionHarmonicFunction.tonic,
      HarmonicFunction.predominant => ProgressionHarmonicFunction.predominant,
      HarmonicFunction.dominant => ProgressionHarmonicFunction.dominant,
      HarmonicFunction.free => ProgressionHarmonicFunction.other,
    };
  }

  bool _isTonicRoman(RomanNumeralId romanNumeralId) {
    return romanNumeralId == RomanNumeralId.iMaj7 ||
        romanNumeralId == RomanNumeralId.iMaj69 ||
        romanNumeralId == RomanNumeralId.iMin7 ||
        romanNumeralId == RomanNumeralId.iMin6 ||
        romanNumeralId == RomanNumeralId.iMinMaj7;
  }

  List<ProgressionTagId> _detectTags(List<AnalyzedChord> analyses) {
    final tags = <ProgressionTagId>{};
    final hasRealModulation = analyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.realModulation),
    );

    for (var index = 0; index < analyses.length - 2; index += 1) {
      final first = analyses[index];
      final second = analyses[index + 1];
      final third = analyses[index + 2];
      if (!_spansCadentialWindow(first, third)) {
        continue;
      }

      final isIiVI =
          _isStrictCadentialTwo(first) &&
          _isDominantLikeAnalysis(second) &&
          _isTonic(third);
      if (isIiVI) {
        tags.add(ProgressionTagId.iiVI);
      }

      if (_isPlagalDecoration(first, second, third)) {
        tags.add(ProgressionTagId.plagalColor);
      }
    }

    for (var index = 0; index < analyses.length - 1; index += 1) {
      final left = analyses[index];
      final right = analyses[index + 1];
      if (left.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _spansCadentialWindow(left, right) &&
          _isTonic(right)) {
        tags.add(ProgressionTagId.dominantResolution);
      }
    }

    if (analyses.length >= 4 &&
        _isTonic(analyses[0]) &&
        analyses[1].remarks.any(
          (remark) =>
              remark.kind == ProgressionRemarkKind.possibleSecondaryDominant,
        ) &&
        _isStrictCadentialTwo(analyses[2]) &&
        analyses[3].harmonicFunction == ProgressionHarmonicFunction.dominant) {
      tags.add(ProgressionTagId.turnaround);
    }

    if (!hasRealModulation &&
        analyses.any(
          (analysis) => analysis.hasRemark(ProgressionRemarkKind.tonicization),
        )) {
      tags.add(ProgressionTagId.tonicization);
    }
    if (hasRealModulation) {
      tags.add(ProgressionTagId.realModulation);
    }
    if (analyses.any(
      (analysis) =>
          analysis.hasRemark(ProgressionRemarkKind.backdoorChain) ||
          analysis.hasRemark(ProgressionRemarkKind.backdoorDominant),
    )) {
      tags.add(ProgressionTagId.backdoorChain);
    }
    if (analyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.deceptiveCadence),
    )) {
      tags.add(ProgressionTagId.deceptiveCadence);
    }
    if (analyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.lineClicheColor),
    )) {
      tags.add(ProgressionTagId.chromaticLine);
    }
    if (analyses.any(
      (analysis) =>
          analysis.hasRemark(ProgressionRemarkKind.commonToneDiminished),
    )) {
      tags.add(ProgressionTagId.commonToneMotion);
    }

    return tags.toList();
  }

  bool _isPlagalDecoration(
    AnalyzedChord first,
    AnalyzedChord second,
    AnalyzedChord third,
  ) {
    if (!_isSubdominantColor(first) || !_isTonic(third)) {
      return false;
    }
    return _isTonic(second) ||
        (_isDominantLikeAnalysis(second) &&
            second.chord.measureIndex - first.chord.measureIndex <= 1);
  }

  bool _isSubdominantColor(AnalyzedChord analysis) {
    return analysis.romanNumeralId == RomanNumeralId.ivMaj7 ||
        analysis.romanNumeralId == RomanNumeralId.borrowedIvMin7 ||
        analysis.romanNumeralId == RomanNumeralId.ivMin7Minor ||
        analysis.hasRemark(ProgressionRemarkKind.subdominantMinor);
  }

  bool _isTonic(AnalyzedChord analysis) {
    return analysis.romanNumeralId != null &&
        _isTonicRoman(analysis.romanNumeralId!);
  }

  double _tagBonus(List<ProgressionTagId> tags) {
    var score = 0.0;
    for (final tag in tags) {
      score += switch (tag) {
        ProgressionTagId.iiVI => 8,
        ProgressionTagId.turnaround => 5.5,
        ProgressionTagId.dominantResolution => 2.5,
        ProgressionTagId.plagalColor => 2,
        ProgressionTagId.tonicization => 1.3,
        ProgressionTagId.realModulation => 1.8,
        ProgressionTagId.backdoorChain => 1.6,
        ProgressionTagId.deceptiveCadence => 0.8,
        ProgressionTagId.chromaticLine => 0.7,
        ProgressionTagId.commonToneMotion => 0.9,
      };
    }
    return score;
  }

  double _tonicAnchorBonus(List<AnalyzedChord> analyses) {
    if (analyses.isEmpty) {
      return 0;
    }

    var score = 0.0;
    if (_isTonic(analyses.last)) {
      score += 5;
    }
    if (_isTonic(analyses.first)) {
      score += 1.5;
    }
    for (final analysis in analyses) {
      if (analysis.chord.positionInMeasure == 0 && _isTonic(analysis)) {
        score += 1.15;
      }
    }
    return score;
  }

  double _dominantResolutionBonus(List<AnalyzedChord> analyses) {
    var score = 0.0;
    for (var index = 0; index < analyses.length - 1; index += 1) {
      final current = analyses[index];
      final next = analyses[index + 1];
      final endsMeasure = current.chord.measureIndex != next.chord.measureIndex;
      if (current.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _spansCadentialWindow(current, next) &&
          _isTonic(next)) {
        score += endsMeasure && next.chord.positionInMeasure == 0 ? 2.9 : 2.2;
      } else if (current.harmonicFunction ==
              ProgressionHarmonicFunction.dominant &&
          endsMeasure &&
          !_isTonic(next)) {
        score -= 0.5;
      }
    }
    return score;
  }

  double _functionalCadenceBonus({
    required List<AnalyzedChord> analyses,
    required int measureCount,
  }) {
    if (analyses.length < 3) {
      return 0.0;
    }
    final isTriadOnly = analyses.every(
      (analysis) =>
          analysis.chord.extension == null &&
          !analysis.chord.hasAlteredColor &&
          analysis.chord.addedTones.isEmpty &&
          analysis.chord.suspensions.isEmpty &&
          analysis.chord.diagnostics.isEmpty,
    );
    if (!isTriadOnly) {
      return 0.0;
    }

    final startsOnTonic = _isTonic(analyses.first);
    final predominantIndex = analyses.indexWhere(
      (analysis) =>
          analysis.harmonicFunction == ProgressionHarmonicFunction.predominant,
    );
    final dominantIndex = predominantIndex < 0
        ? -1
        : analyses.indexWhere(
            (analysis) =>
                analysis.harmonicFunction ==
                    ProgressionHarmonicFunction.dominant &&
                analysis.chord.measureIndex >=
                    analyses[predominantIndex].chord.measureIndex,
          );
    final finalTonicIndex = dominantIndex < 0
        ? -1
        : analyses.indexWhere(
            (analysis) =>
                _isTonic(analysis) &&
                analysis.chord.measureIndex >=
                    analyses[dominantIndex].chord.measureIndex,
          );

    var bonus = 0.0;
    if (startsOnTonic &&
        predominantIndex > 0 &&
        dominantIndex > predominantIndex) {
      bonus += 4.4;
      if (finalTonicIndex > dominantIndex) {
        bonus += 5.0;
      } else if (measureCount > analyses.length) {
        bonus += 2.1;
      }
    }
    return bonus;
  }

  double _openingHomeGestureBonus(List<AnalyzedChord> analyses) {
    if (analyses.length < 3 || !_isTonic(analyses.first)) {
      return 0.0;
    }
    final openingWindow = analyses.take(4).toList(growable: false);
    final supportingAnalyses = openingWindow
        .skip(1)
        .where(
          (analysis) =>
              analysis.sourceKind == ChordSourceKind.diatonic &&
              analysis.harmonicFunction != ProgressionHarmonicFunction.other,
        )
        .toList(growable: false);
    if (supportingAnalyses.length < 2) {
      return 0.0;
    }

    final hasPredominantOrDominant = supportingAnalyses.any(
      (analysis) =>
          analysis.harmonicFunction ==
              ProgressionHarmonicFunction.predominant ||
          analysis.harmonicFunction == ProgressionHarmonicFunction.dominant,
    );
    if (!hasPredominantOrDominant) {
      return 0.0;
    }

    final hasSlashBassSupport = supportingAnalyses.any(
      (analysis) => analysis.chord.hasSlashBass,
    );
    final closesOnFunctionalChord =
        openingWindow.last.harmonicFunction !=
        ProgressionHarmonicFunction.other;
    return 3.1 +
        (hasSlashBassSupport ? 0.8 : 0.0) +
        (closesOnFunctionalChord ? 0.4 : 0.0);
  }

  bool _hasOpeningCadentialReturn(List<AnalyzedChord> analyses) {
    if (analyses.length < 4 || !_isTonic(analyses.first)) {
      return false;
    }
    for (var index = 1; index < analyses.length - 1; index += 1) {
      final current = analyses[index];
      final next = analyses[index + 1];
      if (current.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _isTonic(next)) {
        return true;
      }
    }
    return false;
  }

  List<AnalyzedMeasure> _groupAnalyzedMeasures(
    ProgressionParseResult parseResult,
    List<AnalyzedChord> analyses,
  ) {
    final analysesByMeasure = <int, List<AnalyzedChord>>{};
    for (final analysis in analyses) {
      (analysesByMeasure[analysis.chord.measureIndex] ??= <AnalyzedChord>[])
          .add(analysis);
    }

    return [
      for (final measure in parseResult.measures)
        AnalyzedMeasure(
          measureIndex: measure.measureIndex,
          tokens: measure.tokens,
          chordAnalyses: analysesByMeasure[measure.measureIndex] ?? const [],
        ),
    ];
  }

  bool _spansCadentialWindow(AnalyzedChord start, AnalyzedChord end) {
    return end.chord.measureIndex - start.chord.measureIndex <= 2;
  }

  bool _showAlternative(
    _KeyEvaluation primary,
    _KeyEvaluation alternative,
    int chordCount,
  ) {
    if (chordCount <= 3) {
      return alternative.score >= primary.score - 8;
    }
    return alternative.score >= primary.score - 4.5;
  }
}

class _InterpretationCandidate {
  const _InterpretationCandidate({
    required this.romanNumeral,
    required this.harmonicFunction,
    required this.score,
    this.romanNumeralId,
    this.sourceKind,
    this.sourceReason,
    this.remarks = const [],
    this.evidence = const [],
    this.ambiguous = false,
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final String? sourceReason;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
  final bool ambiguous;
}

class _PlaceholderCandidate {
  const _PlaceholderCandidate({
    required this.romanNumeralId,
    required this.symbol,
    required this.romanNumeral,
    required this.harmonicFunction,
    required this.sourceKind,
    required this.score,
    this.sourceReason,
    this.remarks = const [],
    this.evidence = const [],
  });

  final RomanNumeralId romanNumeralId;
  final String symbol;
  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final ChordSourceKind sourceKind;
  final double score;
  final String? sourceReason;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
}

class _RealModulationCandidate {
  const _RealModulationCandidate({
    required this.startIndex,
    required this.arrivalIndex,
    required this.targetKeyCenter,
    required this.score,
  });

  final int startIndex;
  final int arrivalIndex;
  final KeyCenter targetKeyCenter;
  final double score;
}

class _KeyEvaluation {
  const _KeyEvaluation({
    required this.keyCenter,
    required this.score,
    required this.chordAnalyses,
    required this.tags,
  });

  final KeyCenter keyCenter;
  final double score;
  final List<AnalyzedChord> chordAnalyses;
  final List<ProgressionTagId> tags;
}
