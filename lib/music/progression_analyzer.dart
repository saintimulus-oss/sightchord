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
      for (
        var index = 0;
        index < math.min(evaluations.length, 3);
        index += 1
      )
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
      groupedMeasures: _groupAnalyzedMeasures(primary.chordAnalyses),
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
        final resolutionTarget = spec.resolutionTargetId;
        if (resolutionTarget != null) {
          final targetRoman = MusicTheory.romanTokenOf(resolutionTarget);
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
          const ProgressionEvidence(kind: ProgressionEvidenceKind.borrowedColor),
        );
      }

      candidates.add(
        _InterpretationCandidate(
          romanNumeral: MusicTheory.romanTokenOf(entry.key),
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
    final targetRoman =
        targetCandidate?.romanNumeral ??
        _fallbackRomanForChord(nextChord, keyCenter);

    return [
      _InterpretationCandidate(
        romanNumeral: 'subV7/$targetRoman',
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
            romanNumeral: MusicTheory.romanTokenOf(romanId),
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
      harmonicFunction: ProgressionHarmonicFunction.other,
      score: -2,
      confidence: 0.2,
      isAmbiguous: true,
      remarks: const [
        ProgressionRemark(kind: ProgressionRemarkKind.unresolved),
      ],
    );
  }

  String _fallbackRomanForChord(ParsedChord chord, KeyCenter keyCenter) {
    final tonic = keyCenter.tonicSemitone;
    if (tonic == null) {
      return '?';
    }
    final offset = (chord.rootSemitone - tonic) % 12;
    final degree = switch (offset) {
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
    return '$degree${_fallbackQualitySuffix(chord)}';
  }

  String _fallbackQualitySuffix(ParsedChord chord) {
    if (chord.hasSuspension) {
      return chord.suspensions.first == '2' ? 'sus2' : 'sus4';
    }
    if (chord.addedTones.isNotEmpty) {
      return 'add${chord.addedTones.first}';
    }
    if (chord.extension == 9 &&
        chord.analysisQuality == ChordQuality.dominant7) {
      return '9';
    }
    if (chord.extension == 11 &&
        chord.analysisQuality == ChordQuality.dominant7) {
      return '11';
    }
    if (chord.extension == 13 &&
        chord.analysisQuality == ChordQuality.dominant7) {
      return '13';
    }
    final quality = chord.analysisQuality;
    return switch (quality) {
      ChordQuality.major7 => 'maj7',
      ChordQuality.major69 => '6/9',
      ChordQuality.six => '6',
      ChordQuality.minor7 => 'm7',
      ChordQuality.minorMajor7 => 'mMaj7',
      ChordQuality.minor6 => 'm6',
      ChordQuality.minorTriad => 'm',
      ChordQuality.dominant7 => '7',
      ChordQuality.halfDiminished7 => 'm7b5',
      ChordQuality.diminished7 => 'dim7',
      ChordQuality.diminishedTriad => 'dim',
      ChordQuality.augmentedTriad => 'aug',
      _ => '',
    };
  }

  double? _qualityCompatibility({
    required ParsedChord chord,
    required ChordQuality expected,
  }) {
    final actual = chord.analysisQuality;
    if (actual == expected) {
      return 1.0;
    }

    if (actual == ChordQuality.majorTriad &&
        (expected == ChordQuality.major7 || expected == ChordQuality.major69)) {
      return 0.7;
    }

    if ((actual == ChordQuality.major7 || actual == ChordQuality.six) &&
        expected == ChordQuality.major69) {
      return 0.78;
    }

    if (actual == ChordQuality.major69 && expected == ChordQuality.major7) {
      return 0.82;
    }

    if (actual == ChordQuality.minorTriad &&
        (expected == ChordQuality.minor7 ||
            expected == ChordQuality.minorMajor7 ||
            expected == ChordQuality.minor6)) {
      return 0.7;
    }

    if (actual == ChordQuality.diminishedTriad &&
        (expected == ChordQuality.halfDiminished7 ||
            expected == ChordQuality.diminished7)) {
      return 0.55;
    }

    if (chord.hasSuspension &&
        actual == ChordQuality.majorTriad &&
        expected == ChordQuality.dominant7) {
      return 0.62;
    }

    return null;
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
    if (chord.hasAlteredColor && spec.harmonicFunction == HarmonicFunction.dominant) {
      bonus += 0.9;
    }
    if (chord.hasSuspension && spec.harmonicFunction == HarmonicFunction.dominant) {
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
    if (chord.hasAlteredColor && spec.harmonicFunction == HarmonicFunction.dominant) {
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

  double _slashBassBonus({required ParsedChord chord, required RomanSpec spec}) {
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

  double _candidateConfidence({required ParsedChord chord, required double gap}) {
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

  List<AnalyzedMeasure> _groupAnalyzedMeasures(List<AnalyzedChord> analyses) {
    final grouped = <AnalyzedMeasure>[];
    for (final analysis in analyses) {
      if (grouped.isEmpty ||
          grouped.last.measureIndex != analysis.chord.measureIndex) {
        grouped.add(
          AnalyzedMeasure(
            measureIndex: analysis.chord.measureIndex,
            chordAnalyses: [analysis],
          ),
        );
        continue;
      }
      grouped.last.chordAnalyses.add(analysis);
    }
    return grouped;
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
