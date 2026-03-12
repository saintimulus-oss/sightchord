import 'dart:math' as math;

import 'chord_theory.dart';
import 'progression_analysis_models.dart';
import 'progression_parser.dart';

class ProgressionAnalyzer {
  const ProgressionAnalyzer({this.parser = const ProgressionParser()});

  final ProgressionParser parser;

  ProgressionAnalysis analyze(String input) {
    final parseResult = parser.parse(input);
    final chords = parseResult.validChords;

    if (chords.isEmpty) {
      throw const ProgressionAnalysisException('no-valid-chords');
    }

    final evaluations = [
      for (final keyCenter in _candidateKeyCenters)
        _evaluateKeyCenter(keyCenter, chords),
    ]..sort((left, right) => right.score.compareTo(left.score));

    final primary = evaluations.first;
    final alternative =
        evaluations.length > 1 &&
            _showAlternative(primary, evaluations[1], chords.length)
        ? evaluations[1]
        : null;
    final primaryConfidence = _analysisConfidence(
      primary: primary,
      alternative: alternative,
      parseResult: parseResult,
    );
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
      chordAnalyses: primary.chordAnalyses,
      groupedMeasures: _groupAnalyzedMeasures(
        parseResult,
        primary.chordAnalyses,
      ),
      tags: primary.tags,
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
    List<ParsedChord> chords,
  ) {
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

    final tags = _detectTags(chordAnalyses);
    score += _tagBonus(tags);
    score += _tonicAnchorBonus(chordAnalyses);
    score += _dominantResolutionBonus(chordAnalyses);

    return _KeyEvaluation(
      keyCenter: keyCenter,
      score: score,
      chordAnalyses: chordAnalyses,
      tags: tags,
    );
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
