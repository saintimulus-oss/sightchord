import 'chord_theory.dart';

enum ProgressionHarmonicFunction { tonic, predominant, dominant, other }

enum ProgressionRemarkKind {
  possibleSecondaryDominant,
  possibleTritoneSubstitute,
  possibleModalInterchange,
  ambiguousInterpretation,
  unresolved,
}

enum ProgressionTagId { iiVI, turnaround, dominantResolution, plagalColor }

enum ProgressionEvidenceKind {
  qualityMatch,
  extensionColor,
  alteredDominantColor,
  slashBass,
  resolution,
  borrowedColor,
  suspensionColor,
}

class ParsedChord {
  const ParsedChord({
    required this.sourceSymbol,
    required this.root,
    required this.rootSemitone,
    required this.displayQuality,
    required this.analysisQuality,
    required this.measureIndex,
    required this.positionInMeasure,
    this.suffix = '',
    this.normalizedSuffix = '',
    this.extension,
    this.tensions = const [],
    this.addedTones = const [],
    this.alterations = const [],
    this.suspensions = const [],
    this.ignoredTokens = const [],
    this.diagnostics = const [],
    this.bass,
    this.bassSemitone,
  });

  final String sourceSymbol;
  final String root;
  final int rootSemitone;
  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final int measureIndex;
  final int positionInMeasure;
  final String suffix;
  final String normalizedSuffix;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> alterations;
  final List<String> suspensions;
  final List<String> ignoredTokens;
  final List<String> diagnostics;
  final String? bass;
  final int? bassSemitone;

  String get canonicalSymbol =>
      '$root$normalizedSuffix${bass == null ? '' : '/$bass'}';

  bool get hasSlashBass => bass != null;

  bool get isDominantFamily => analysisQuality == ChordQuality.dominant7;

  bool get hasExtension => extension != null;

  bool get hasSuspension => suspensions.isNotEmpty;

  bool get hasParserWarnings => ignoredTokens.isNotEmpty || diagnostics.isNotEmpty;

  bool get hasAlteredColor =>
      displayQuality == ChordQuality.dominant7Alt ||
      alterations.isNotEmpty ||
      tensions.any((tension) => tension.contains('#') || tension.contains('b'));
}

class ParsedChordToken {
  const ParsedChordToken({
    required this.index,
    required this.rawText,
    required this.measureIndex,
    required this.positionInMeasure,
    this.chord,
    this.error,
  });

  final int index;
  final String rawText;
  final int measureIndex;
  final int positionInMeasure;
  final ParsedChord? chord;
  final String? error;

  bool get isValid => chord != null;
}

class ParsedMeasure {
  const ParsedMeasure({required this.measureIndex, required this.tokens});

  final int measureIndex;
  final List<ParsedChordToken> tokens;

  List<ParsedChord> get validChords => [
    for (final token in tokens)
      if (token.chord != null) token.chord!,
  ];

  List<ParsedChordToken> get issues => [
    for (final token in tokens)
      if (!token.isValid) token,
  ];
}

class ProgressionParseResult {
  const ProgressionParseResult({required this.tokens, required this.measures});

  final List<ParsedChordToken> tokens;
  final List<ParsedMeasure> measures;

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

class ProgressionEvidence {
  const ProgressionEvidence({required this.kind, this.detail});

  final ProgressionEvidenceKind kind;
  final String? detail;
}

class ChordInterpretationCandidate {
  const ChordInterpretationCandidate({
    required this.romanNumeral,
    required this.harmonicFunction,
    required this.score,
    this.romanNumeralId,
    this.sourceKind,
    this.remarks = const [],
    this.evidence = const [],
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
}

class AnalyzedChord {
  const AnalyzedChord({
    required this.chord,
    required this.romanNumeral,
    required this.harmonicFunction,
    this.romanNumeralId,
    this.sourceKind,
    this.score = 0,
    this.confidence = 0.5,
    this.isAmbiguous = false,
    this.remarks = const [],
    this.evidence = const [],
    this.competingInterpretations = const [],
  });

  final ParsedChord chord;
  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final double confidence;
  final bool isAmbiguous;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
  final List<ChordInterpretationCandidate> competingInterpretations;

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
    this.confidence = 0.5,
  });

  final KeyCenter keyCenter;
  final double score;
  final double confidence;
}

class ProgressionAnalysis {
  const ProgressionAnalysis({
    required this.input,
    required this.parseResult,
    required this.primaryKey,
    required this.keyCandidates,
    required this.chordAnalyses,
    required this.groupedMeasures,
    this.alternativeKey,
    this.tags = const [],
    this.confidence = 0.5,
    this.ambiguity = 0.5,
  });

  final String input;
  final ProgressionParseResult parseResult;
  final ProgressionKeyCandidate primaryKey;
  final ProgressionKeyCandidate? alternativeKey;
  final List<ProgressionKeyCandidate> keyCandidates;
  final List<AnalyzedChord> chordAnalyses;
  final List<AnalyzedMeasure> groupedMeasures;
  final List<ProgressionTagId> tags;
  final double confidence;
  final double ambiguity;

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

class AnalyzedMeasure {
  const AnalyzedMeasure({
    required this.measureIndex,
    required this.chordAnalyses,
  });

  final int measureIndex;
  final List<AnalyzedChord> chordAnalyses;
}

class ProgressionAnalysisException implements Exception {
  const ProgressionAnalysisException(this.message);

  final String message;

  @override
  String toString() => message;
}
