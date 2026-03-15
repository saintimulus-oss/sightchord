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

    final evaluations = [
      for (final keyCenter in _candidateKeyCenters)
        _evaluateKeyCenter(keyCenter, parseResult),
    ]..sort((left, right) => right.score.compareTo(left.score));

    final primary = evaluations.first;
    final alternative =
        evaluations.length > 1 &&
            _showAlternative(primary, evaluations[1], knownChords.length)
        ? evaluations[1]
        : null;
    final primaryConfidence = _analysisConfidence(
      primary: primary,
      alternative: alternative,
      parseResult: parseResult,
    );
    final chordAnalyses = primary.chordAnalyses;
    final tags = primary.tags;
    final keyCandidates = [
      for (var index = 0; index < math.min(evaluations.length, 5); index += 1)
        ProgressionKeyCandidate(
          keyCenter: evaluations[index].keyCenter,
          score: evaluations[index].score,
          confidence: _keyCandidateConfidence(
            evaluation: evaluations[index],
            primaryScore: primary.score,
          ),
        ),
    ];

    return ProgressionAnalysis(
      input: input,
      parseResult: parseResult,
      primaryKey: ProgressionKeyCandidate(
        keyCenter: primary.keyCenter,
        score: primary.score,
        confidence: primaryConfidence,
      ),
      alternativeKey: alternative == null
          ? null
          : ProgressionKeyCandidate(
              keyCenter: alternative.keyCenter,
              score: alternative.score,
              confidence: _keyCandidateConfidence(
                evaluation: alternative,
                primaryScore: primary.score,
              ),
            ),
      keyCandidates: keyCandidates,
      chordAnalyses: chordAnalyses,
      groupedMeasures: _groupAnalyzedMeasures(parseResult, chordAnalyses),
      tags: tags,
      confidence: primaryConfidence,
      ambiguity: 1 - primaryConfidence,
    );
  }

  static final List<KeyCenter> _candidateKeyCenters = [
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.major),
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.minor),
  ];

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

    return _KeyEvaluation(
      keyCenter: keyCenter,
      score: score,
      chordAnalyses: enrichedAnalyses,
      tags: tags,
    );
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
    final second = candidates.length > 1 ? candidates[1] : null;
    final gap = second == null ? 3.4 : best.score - second.score;
    final ambiguous = second != null && gap < 1.4;

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
      competingInterpretations: [
        for (final candidate in candidates.skip(1).take(3))
          ChordInterpretationCandidate(
            romanNumeral: candidate.romanNumeral,
            harmonicFunction: candidate.harmonicFunction,
            chordSymbol: candidate.symbol,
            romanNumeralId: candidate.romanNumeralId,
            sourceKind: candidate.sourceKind,
            score: candidate.score,
            remarks: candidate.remarks,
            evidence: candidate.evidence,
          ),
      ],
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
    final second = candidates.length > 1 ? candidates[1] : null;
    final gap = second == null ? 3.8 : best.score - second.score;
    final ambiguous = second != null && gap < 1.6;

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
      competingInterpretations: [
        for (final candidate in candidates.skip(1).take(2))
          ChordInterpretationCandidate(
            romanNumeral: candidate.romanNumeral,
            harmonicFunction: candidate.harmonicFunction,
            romanNumeralId: candidate.romanNumeralId,
            sourceKind: candidate.sourceKind,
            score: candidate.score,
            remarks: candidate.remarks,
            evidence: candidate.evidence,
          ),
      ],
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

  double _analysisConfidence({
    required _KeyEvaluation primary,
    required _KeyEvaluation? alternative,
    required ProgressionParseResult parseResult,
  }) {
    final gap = alternative == null ? 8.5 : primary.score - alternative.score;
    var confidence = 0.54 + (gap / 18);
    if (parseResult.hasPartialFailure) {
      confidence -= 0.08;
    }
    if (parseResult.hasPlaceholders) {
      confidence -= math.min(0.18, parseResult.placeholders.length * 0.05);
    }
    final ambiguousRatio = primary.chordAnalyses.isEmpty
        ? 0.0
        : primary.chordAnalyses
                  .where((analysis) => analysis.isAmbiguous)
                  .length /
              primary.chordAnalyses.length;
    confidence -= ambiguousRatio * 0.22;
    return (confidence.clamp(0.2, 0.98) as num).toDouble();
  }

  double _keyCandidateConfidence({
    required _KeyEvaluation evaluation,
    required double primaryScore,
  }) {
    final gap = primaryScore - evaluation.score;
    return (1 - (gap / 18)).clamp(0.12, 0.98).toDouble();
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

    for (var index = 0; index < analyses.length - 2; index += 1) {
      final first = analyses[index];
      final second = analyses[index + 1];
      final third = analyses[index + 2];
      if (!_spansCadentialWindow(first, third)) {
        continue;
      }

      final isIiVI =
          _isPredominantTwo(first) &&
          second.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _isTonic(third);
      if (isIiVI) {
        tags.add(ProgressionTagId.iiVI);
      }

      if (first.sourceKind == ChordSourceKind.modalInterchange &&
          second.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          _isTonic(third)) {
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
        _isPredominantTwo(analyses[2]) &&
        analyses[3].harmonicFunction == ProgressionHarmonicFunction.dominant) {
      tags.add(ProgressionTagId.turnaround);
    }

    if (analyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.tonicization),
    )) {
      tags.add(ProgressionTagId.tonicization);
    }
    if (analyses.any(
      (analysis) => analysis.hasRemark(ProgressionRemarkKind.realModulation),
    )) {
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
          analysis.hasRemark(ProgressionRemarkKind.commonToneDiminished) ||
          analysis.hasRemark(ProgressionRemarkKind.commonToneModulation),
    )) {
      tags.add(ProgressionTagId.commonToneMotion);
    }

    return tags.toList();
  }

  bool _isPredominantTwo(AnalyzedChord analysis) {
    return analysis.romanNumeralId == RomanNumeralId.iiMin7 ||
        analysis.romanNumeralId == RomanNumeralId.iiHalfDiminishedMinor ||
        analysis.harmonicFunction == ProgressionHarmonicFunction.predominant;
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
    this.remarks = const [],
    this.evidence = const [],
    this.ambiguous = false,
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
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
    this.remarks = const [],
    this.evidence = const [],
  });

  final RomanNumeralId romanNumeralId;
  final String symbol;
  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final ChordSourceKind sourceKind;
  final double score;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
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
