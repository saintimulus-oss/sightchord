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
        evaluations.length > 1 && _showAlternative(primary, evaluations[1], chords.length)
        ? evaluations[1]
        : null;

    return ProgressionAnalysis(
      input: input,
      parseResult: parseResult,
      primaryKey: ProgressionKeyCandidate(
        keyCenter: primary.keyCenter,
        score: primary.score,
      ),
      alternativeKey: alternative == null
          ? null
          : ProgressionKeyCandidate(
              keyCenter: alternative.keyCenter,
              score: alternative.score,
            ),
      keyCandidates: [
        ProgressionKeyCandidate(
          keyCenter: primary.keyCenter,
          score: primary.score,
        ),
        if (alternative != null)
          ProgressionKeyCandidate(
            keyCenter: alternative.keyCenter,
            score: alternative.score,
          ),
      ],
      chordAnalyses: primary.chordAnalyses,
      tags: primary.tags,
    );
  }

  static final List<KeyCenter> _candidateKeyCenters = [
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.major),
    ...MusicTheory.orderedKeyCentersForMode(KeyMode.minor),
  ];

  _KeyEvaluation _evaluateKeyCenter(KeyCenter keyCenter, List<ParsedChord> chords) {
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
      ..._specCandidates(
        keyCenter: keyCenter,
        chords: chords,
        index: index,
      ),
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
    final ambiguous = second != null && (best.score - second.score) < 1.6;

    return AnalyzedChord(
      chord: chord,
      romanNumeral: best.romanNumeral,
      harmonicFunction: best.harmonicFunction,
      romanNumeralId: best.romanNumeralId,
      sourceKind: best.sourceKind,
      score: best.score,
      isAmbiguous: ambiguous || best.ambiguous,
      remarks: [
        ...best.remarks,
        if (ambiguous)
          const ProgressionRemark(
            kind: ProgressionRemarkKind.ambiguousInterpretation,
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
        chord.analysisQuality,
        spec.quality,
      );
      if (compatibility == null) {
        continue;
      }

      var score = _baseScoreForSource(spec.sourceKind) * compatibility;
      final remarks = <ProgressionRemark>[];

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
            keyCenter: keyCenter,
            resolutionTarget: resolutionTarget,
            nextChord: nextChord,
            nextNextChord: nextNextChord,
          );
          score += resolutionScore;
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
      }

      candidates.add(
        _InterpretationCandidate(
          romanNumeral: MusicTheory.romanTokenOf(entry.key),
          harmonicFunction: _mapFunction(spec.harmonicFunction),
          romanNumeralId: entry.key,
          sourceKind: spec.sourceKind,
          score: score,
          remarks: remarks,
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
        targetCandidate?.romanNumeral ?? _fallbackRomanForChord(nextChord, keyCenter);

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
        chord.analysisQuality,
        spec.quality,
      );
      if (semitone == chord.rootSemitone && compatibility != null) {
        candidates.add(
          _InterpretationCandidate(
            romanNumeral: MusicTheory.romanTokenOf(romanId),
            harmonicFunction: _mapFunction(spec.harmonicFunction),
            romanNumeralId: romanId,
            sourceKind: spec.sourceKind,
            score: 6 * compatibility,
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

  AnalyzedChord _fallbackInterpretation(ParsedChord chord, KeyCenter keyCenter) {
    return AnalyzedChord(
      chord: chord,
      romanNumeral: _fallbackRomanForChord(chord, keyCenter),
      harmonicFunction: ProgressionHarmonicFunction.other,
      score: -2,
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
    return '$degree${_fallbackQualitySuffix(chord.analysisQuality)}';
  }

  String _fallbackQualitySuffix(ChordQuality quality) {
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

  double? _qualityCompatibility(ChordQuality actual, ChordQuality expected) {
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

  double _resolutionScore({
    required KeyCenter keyCenter,
    required RomanNumeralId resolutionTarget,
    required ParsedChord? nextChord,
    required ParsedChord? nextNextChord,
  }) {
    if (nextChord == null) {
      return -1.2;
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
      return 5;
    }
    if (nextNextChord != null &&
        _matchesTarget(nextNextChord, targetSemitone, targetSpec.quality)) {
      return 2.6;
    }
    return -1.2;
  }

  bool _matchesTarget(
    ParsedChord chord,
    int targetSemitone,
    ChordQuality targetQuality,
  ) {
    final compatibility = _qualityCompatibility(
      chord.analysisQuality,
      targetQuality,
    );
    return chord.rootSemitone == targetSemitone && compatibility != null;
  }

  ProgressionHarmonicFunction _mapFunction(HarmonicFunction function) {
    return switch (function) {
      HarmonicFunction.tonic => ProgressionHarmonicFunction.tonic,
      HarmonicFunction.predominant =>
        ProgressionHarmonicFunction.predominant,
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

      final isIiVI = _isPredominantTwo(first) &&
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
    return score;
  }

  double _dominantResolutionBonus(List<AnalyzedChord> analyses) {
    var score = 0.0;
    for (var index = 0; index < analyses.length - 1; index += 1) {
      if (analyses[index].harmonicFunction ==
              ProgressionHarmonicFunction.dominant &&
          _isTonic(analyses[index + 1])) {
        score += 2.2;
      }
    }
    return score;
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
    this.ambiguous = false,
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final List<ProgressionRemark> remarks;
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
