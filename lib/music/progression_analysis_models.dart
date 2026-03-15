import 'chord_theory.dart';

enum ProgressionHarmonicFunction { tonic, predominant, dominant, other }

enum ProgressionHighlightCategory {
  appliedDominant,
  tritoneSubstitute,
  tonicization,
  modulation,
  backdoor,
  borrowedColor,
  commonTone,
  deceptiveCadence,
  chromaticLine,
  ambiguity,
}

enum ProgressionRemarkKind {
  possibleSecondaryDominant,
  possibleTritoneSubstitute,
  possibleModalInterchange,
  tonicization,
  realModulation,
  backdoorDominant,
  backdoorChain,
  subdominantMinor,
  commonToneDiminished,
  pivotChordInterpretation,
  commonToneModulation,
  deceptiveCadence,
  lineClicheColor,
  dualFunctionAmbiguity,
  ambiguousInterpretation,
  unresolved,
}

enum ProgressionTagId {
  iiVI,
  turnaround,
  dominantResolution,
  plagalColor,
  tonicization,
  realModulation,
  backdoorChain,
  deceptiveCadence,
  chromaticLine,
  commonToneMotion,
}

enum ProgressionEvidenceKind {
  qualityMatch,
  extensionColor,
  alteredDominantColor,
  slashBass,
  resolution,
  borrowedColor,
  suspensionColor,
  cadentialArrival,
  followThroughSupport,
  phraseBoundary,
  pivotSupport,
  commonToneSupport,
  homeGravityWeakening,
  backdoorMotion,
  deceptiveResolution,
  chromaticLine,
  competingReading,
}

class ParsedChord {
  const ParsedChord({
    required this.sourceSymbol,
    required this.root,
    required this.rootSemitone,
    required this.displayQuality,
    required this.analysisFamily,
    required this.measureIndex,
    required this.positionInMeasure,
    this.suffix = '',
    this.normalizedSuffix = '',
    this.extension,
    this.tensions = const [],
    this.addedTones = const [],
    this.omittedTones = const [],
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
  final ChordFamily analysisFamily;
  final int measureIndex;
  final int positionInMeasure;
  final String suffix;
  final String normalizedSuffix;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> omittedTones;
  final List<String> alterations;
  final List<String> suspensions;
  final List<String> ignoredTokens;
  final List<String> diagnostics;
  final String? bass;
  final int? bassSemitone;

  String get canonicalSymbol =>
      '$root$normalizedSuffix${bass == null ? '' : '/$bass'}';

  bool get hasSlashBass => bass != null;

  bool get isDominantFamily => analysisFamily == ChordFamily.dominant;

  bool get isDominantLike =>
      analysisFamily == ChordFamily.dominant ||
      (analysisFamily == ChordFamily.augmented && extension == 7);

  bool get hasExtension => extension != null;

  bool get hasSuspension => suspensions.isNotEmpty;

  bool get hasParserWarnings =>
      ignoredTokens.isNotEmpty || diagnostics.isNotEmpty;

  bool get hasAlteredColor =>
      isDominantLike &&
      (displayQuality == ChordQuality.dominant7Alt ||
          alterations.isNotEmpty ||
          tensions.any(
            (tension) => tension.contains('#') || tension.contains('b'),
          ));
}

class ParsedChordToken {
  const ParsedChordToken({
    required this.index,
    required this.rawText,
    required this.measureIndex,
    required this.positionInMeasure,
    this.chord,
    this.isPlaceholder = false,
    this.error,
    this.errorDetail,
  });

  final int index;
  final String rawText;
  final int measureIndex;
  final int positionInMeasure;
  final ParsedChord? chord;
  final bool isPlaceholder;
  final String? error;
  final String? errorDetail;

  bool get isValid => chord != null || isPlaceholder;
}

class ParsedMeasure {
  const ParsedMeasure({required this.measureIndex, required this.tokens});

  final int measureIndex;
  final List<ParsedChordToken> tokens;

  List<ParsedChord> get validChords => [
    for (final token in tokens)
      if (token.chord != null) token.chord!,
  ];

  List<ParsedChordToken> get placeholders => [
    for (final token in tokens)
      if (token.isPlaceholder) token,
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

  List<ParsedChordToken> get placeholders => [
    for (final token in tokens)
      if (token.isPlaceholder) token,
  ];

  List<ParsedChordToken> get issues => [
    for (final token in tokens)
      if (!token.isValid) token,
  ];

  bool get hasPartialFailure => validChords.isNotEmpty && issues.isNotEmpty;

  bool get hasPlaceholders => placeholders.isNotEmpty;
}

class ProgressionRemark {
  const ProgressionRemark({
    required this.kind,
    this.targetRomanNumeral,
    this.targetKeyCenter,
    this.detail,
  });

  final ProgressionRemarkKind kind;
  final String? targetRomanNumeral;
  final KeyCenter? targetKeyCenter;
  final String? detail;

  ProgressionHighlightCategory? get highlightCategory {
    return switch (kind) {
      ProgressionRemarkKind.possibleSecondaryDominant =>
        ProgressionHighlightCategory.appliedDominant,
      ProgressionRemarkKind.possibleTritoneSubstitute =>
        ProgressionHighlightCategory.tritoneSubstitute,
      ProgressionRemarkKind.tonicization =>
        ProgressionHighlightCategory.tonicization,
      ProgressionRemarkKind.realModulation ||
      ProgressionRemarkKind.pivotChordInterpretation ||
      ProgressionRemarkKind.commonToneModulation =>
        ProgressionHighlightCategory.modulation,
      ProgressionRemarkKind.backdoorDominant ||
      ProgressionRemarkKind.backdoorChain =>
        ProgressionHighlightCategory.backdoor,
      ProgressionRemarkKind.possibleModalInterchange ||
      ProgressionRemarkKind.subdominantMinor =>
        ProgressionHighlightCategory.borrowedColor,
      ProgressionRemarkKind.commonToneDiminished =>
        ProgressionHighlightCategory.commonTone,
      ProgressionRemarkKind.deceptiveCadence =>
        ProgressionHighlightCategory.deceptiveCadence,
      ProgressionRemarkKind.lineClicheColor =>
        ProgressionHighlightCategory.chromaticLine,
      ProgressionRemarkKind.dualFunctionAmbiguity ||
      ProgressionRemarkKind.ambiguousInterpretation ||
      ProgressionRemarkKind.unresolved =>
        ProgressionHighlightCategory.ambiguity,
    };
  }
}

class ProgressionEvidence {
  const ProgressionEvidence({required this.kind, this.detail});

  final ProgressionEvidenceKind kind;
  final String? detail;

  ProgressionHighlightCategory? get highlightCategory {
    return switch (kind) {
      ProgressionEvidenceKind.alteredDominantColor ||
      ProgressionEvidenceKind.resolution =>
        ProgressionHighlightCategory.appliedDominant,
      ProgressionEvidenceKind.borrowedColor =>
        ProgressionHighlightCategory.borrowedColor,
      ProgressionEvidenceKind.backdoorMotion =>
        ProgressionHighlightCategory.backdoor,
      ProgressionEvidenceKind.cadentialArrival ||
      ProgressionEvidenceKind.followThroughSupport ||
      ProgressionEvidenceKind.phraseBoundary ||
      ProgressionEvidenceKind.pivotSupport ||
      ProgressionEvidenceKind.homeGravityWeakening =>
        ProgressionHighlightCategory.modulation,
      ProgressionEvidenceKind.commonToneSupport =>
        ProgressionHighlightCategory.commonTone,
      ProgressionEvidenceKind.deceptiveResolution =>
        ProgressionHighlightCategory.deceptiveCadence,
      ProgressionEvidenceKind.chromaticLine =>
        ProgressionHighlightCategory.chromaticLine,
      ProgressionEvidenceKind.competingReading =>
        ProgressionHighlightCategory.ambiguity,
      _ => null,
    };
  }
}

class ChordInterpretationCandidate {
  const ChordInterpretationCandidate({
    required this.romanNumeral,
    required this.harmonicFunction,
    required this.score,
    this.chordSymbol,
    this.romanNumeralId,
    this.sourceKind,
    this.remarks = const [],
    this.evidence = const [],
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final String? chordSymbol;
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
    this.isInferred = false,
    this.inferredSymbol,
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
  final bool isInferred;
  final String? inferredSymbol;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final double confidence;
  final bool isAmbiguous;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;
  final List<ChordInterpretationCandidate> competingInterpretations;

  String get resolvedSymbol => inferredSymbol ?? chord.sourceSymbol;

  bool get isNonDiatonic =>
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant ||
      sourceKind == ChordSourceKind.modalInterchange ||
      sourceKind == ChordSourceKind.tonicization ||
      remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            remark.kind == ProgressionRemarkKind.possibleModalInterchange ||
            remark.kind == ProgressionRemarkKind.tonicization ||
            remark.kind == ProgressionRemarkKind.realModulation,
      );

  bool hasRemark(ProgressionRemarkKind kind) {
    return remarks.any((remark) => remark.kind == kind);
  }

  List<ProgressionHighlightCategory> get highlightCategories {
    final ordered = <ProgressionHighlightCategory>{};
    for (final remark in remarks) {
      final category = remark.highlightCategory;
      if (category != null) {
        ordered.add(category);
      }
    }
    for (final evidence in evidence) {
      final category = evidence.highlightCategory;
      if (category != null) {
        ordered.add(category);
      }
    }
    if (ordered.isEmpty) {
      switch (sourceKind) {
        case ChordSourceKind.secondaryDominant:
          ordered.add(ProgressionHighlightCategory.appliedDominant);
        case ChordSourceKind.substituteDominant:
          ordered.add(ProgressionHighlightCategory.tritoneSubstitute);
        case ChordSourceKind.modalInterchange:
          ordered.add(ProgressionHighlightCategory.borrowedColor);
        case ChordSourceKind.tonicization:
          ordered.add(ProgressionHighlightCategory.tonicization);
        case ChordSourceKind.free || ChordSourceKind.diatonic || null:
          break;
      }
    }
    if (isAmbiguous || hasRemark(ProgressionRemarkKind.unresolved)) {
      ordered.add(ProgressionHighlightCategory.ambiguity);
    }
    return ordered.toList(growable: false);
  }

  ProgressionHighlightCategory? get primaryHighlightCategory {
    final categories = highlightCategories;
    return categories.isEmpty ? null : categories.first;
  }

  AnalyzedChord copyWith({
    ParsedChord? chord,
    String? romanNumeral,
    ProgressionHarmonicFunction? harmonicFunction,
    bool? isInferred,
    Object? inferredSymbol = _retainValue,
    Object? romanNumeralId = _retainValue,
    Object? sourceKind = _retainValue,
    double? score,
    double? confidence,
    bool? isAmbiguous,
    List<ProgressionRemark>? remarks,
    List<ProgressionEvidence>? evidence,
    List<ChordInterpretationCandidate>? competingInterpretations,
  }) {
    return AnalyzedChord(
      chord: chord ?? this.chord,
      romanNumeral: romanNumeral ?? this.romanNumeral,
      harmonicFunction: harmonicFunction ?? this.harmonicFunction,
      isInferred: isInferred ?? this.isInferred,
      inferredSymbol: switch (inferredSymbol) {
        _RetainValue() => this.inferredSymbol,
        String value => value,
        _ => null,
      },
      romanNumeralId: switch (romanNumeralId) {
        _RetainValue() => this.romanNumeralId,
        RomanNumeralId value => value,
        _ => null,
      },
      sourceKind: switch (sourceKind) {
        _RetainValue() => this.sourceKind,
        ChordSourceKind value => value,
        _ => null,
      },
      score: score ?? this.score,
      confidence: confidence ?? this.confidence,
      isAmbiguous: isAmbiguous ?? this.isAmbiguous,
      remarks: remarks ?? this.remarks,
      evidence: evidence ?? this.evidence,
      competingInterpretations:
          competingInterpretations ?? this.competingInterpretations,
    );
  }

  static const _RetainValue _retainValue = _RetainValue();
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

  int get inferredChordCount =>
      chordAnalyses.where((analysis) => analysis.isInferred).length;

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
      parseResult.hasPlaceholders ||
      alternativeKey != null ||
      ambiguousChordCount > 0 ||
      unresolvedChordCount > 0;

  bool get hasRealModulation => chordAnalyses.any(
    (analysis) => analysis.hasRemark(ProgressionRemarkKind.realModulation),
  );

  bool get hasTonicization => chordAnalyses.any(
    (analysis) => analysis.hasRemark(ProgressionRemarkKind.tonicization),
  );

  Set<ProgressionHighlightCategory> get highlightCategories {
    final categories = <ProgressionHighlightCategory>{};
    for (final analysis in chordAnalyses) {
      categories.addAll(analysis.highlightCategories);
    }
    for (final tag in tags) {
      final category = switch (tag) {
        ProgressionTagId.plagalColor ||
        ProgressionTagId.backdoorChain => ProgressionHighlightCategory.backdoor,
        ProgressionTagId.tonicization =>
          ProgressionHighlightCategory.tonicization,
        ProgressionTagId.realModulation || ProgressionTagId.commonToneMotion =>
          ProgressionHighlightCategory.modulation,
        ProgressionTagId.deceptiveCadence =>
          ProgressionHighlightCategory.deceptiveCadence,
        ProgressionTagId.chromaticLine =>
          ProgressionHighlightCategory.chromaticLine,
        _ => null,
      };
      if (category != null) {
        categories.add(category);
      }
    }
    return categories;
  }
}

class AnalyzedMeasure {
  const AnalyzedMeasure({
    required this.measureIndex,
    required this.tokens,
    required this.chordAnalyses,
  });

  final int measureIndex;
  final List<ParsedChordToken> tokens;
  final List<AnalyzedChord> chordAnalyses;

  List<ParsedChordToken> get parseIssues => [
    for (final token in tokens)
      if (!token.isValid) token,
  ];

  bool get isEmpty => tokens.isEmpty;
}

class ProgressionAnalysisException implements Exception {
  const ProgressionAnalysisException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _RetainValue {
  const _RetainValue();
}
