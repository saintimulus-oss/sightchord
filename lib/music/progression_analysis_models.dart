import 'chord_theory.dart';

enum ProgressionHarmonicFunction { tonic, predominant, dominant, other }

enum ProgressionRemarkKind {
  possibleSecondaryDominant,
  possibleTritoneSubstitute,
  possibleModalInterchange,
  ambiguousInterpretation,
  unresolved,
}

enum ProgressionTagId {
  iiVI,
  turnaround,
  dominantResolution,
  plagalColor,
}

class ParsedChord {
  const ParsedChord({
    required this.sourceSymbol,
    required this.root,
    required this.rootSemitone,
    required this.displayQuality,
    required this.analysisQuality,
    this.suffix = '',
    this.tensions = const [],
    this.bass,
    this.bassSemitone,
  });

  final String sourceSymbol;
  final String root;
  final int rootSemitone;
  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final String suffix;
  final List<String> tensions;
  final String? bass;
  final int? bassSemitone;

  bool get hasSlashBass => bass != null;

  bool get isDominantFamily => analysisQuality == ChordQuality.dominant7;

  bool get hasAlteredColor =>
      displayQuality == ChordQuality.dominant7Alt ||
      tensions.any((tension) => tension.contains('#') || tension.contains('b'));
}

class ParsedChordToken {
  const ParsedChordToken({
    required this.index,
    required this.rawText,
    this.chord,
    this.error,
  });

  final int index;
  final String rawText;
  final ParsedChord? chord;
  final String? error;

  bool get isValid => chord != null;
}

class ProgressionParseResult {
  const ProgressionParseResult({required this.tokens});

  final List<ParsedChordToken> tokens;

  List<ParsedChord> get validChords => [
    for (final token in tokens)
      if (token.chord != null) token.chord!,
  ];

  List<ParsedChordToken> get issues => [
    for (final token in tokens)
      if (!token.isValid) token,
  ];

  bool get hasPartialFailure => validChords.isNotEmpty && issues.isNotEmpty;
}

class ProgressionRemark {
  const ProgressionRemark({
    required this.kind,
    this.targetRomanNumeral,
    this.detail,
  });

  final ProgressionRemarkKind kind;
  final String? targetRomanNumeral;
  final String? detail;
}

class AnalyzedChord {
  const AnalyzedChord({
    required this.chord,
    required this.romanNumeral,
    required this.harmonicFunction,
    this.romanNumeralId,
    this.sourceKind,
    this.score = 0,
    this.isAmbiguous = false,
    this.remarks = const [],
  });

  final ParsedChord chord;
  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final bool isAmbiguous;
  final List<ProgressionRemark> remarks;

  bool get isNonDiatonic =>
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant ||
      sourceKind == ChordSourceKind.modalInterchange ||
      remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            remark.kind == ProgressionRemarkKind.possibleModalInterchange,
      );
}

class ProgressionKeyCandidate {
  const ProgressionKeyCandidate({
    required this.keyCenter,
    required this.score,
  });

  final KeyCenter keyCenter;
  final double score;
}

class ProgressionAnalysis {
  const ProgressionAnalysis({
    required this.input,
    required this.parseResult,
    required this.primaryKey,
    required this.keyCandidates,
    required this.chordAnalyses,
    this.alternativeKey,
    this.tags = const [],
  });

  final String input;
  final ProgressionParseResult parseResult;
  final ProgressionKeyCandidate primaryKey;
  final ProgressionKeyCandidate? alternativeKey;
  final List<ProgressionKeyCandidate> keyCandidates;
  final List<AnalyzedChord> chordAnalyses;
  final List<ProgressionTagId> tags;

  int get ambiguousChordCount =>
      chordAnalyses.where((analysis) => analysis.isAmbiguous).length;

  int get unresolvedChordCount => chordAnalyses
      .where(
        (analysis) => analysis.remarks.any(
          (remark) =>
              remark.kind == ProgressionRemarkKind.ambiguousInterpretation ||
              remark.kind == ProgressionRemarkKind.unresolved,
        ),
      )
      .length;

  bool get hasWarnings =>
      parseResult.issues.isNotEmpty ||
      alternativeKey != null ||
      ambiguousChordCount > 0 ||
      unresolvedChordCount > 0;
}

class ProgressionAnalysisException implements Exception {
  const ProgressionAnalysisException(this.message);

  final String message;

  @override
  String toString() => message;
}
