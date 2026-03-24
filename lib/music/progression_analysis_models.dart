import 'chord_theory.dart';

enum ProgressionHarmonicFunction { tonic, predominant, dominant, other }

enum ProgressionHighlightCategory {
  appliedDominant,
  alteredDominant,
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

enum ProgressionDiagnosticStatus {
  partialParse,
  placeholderInference,
  unresolvedHarmony,
  ambiguousHarmony,
  clean,
}

enum ProgressionWarningCode {
  parseIssue,
  invalidBass,
  unknownModifier,
  placeholderUsed,
  unresolvedChord,
  ambiguousInterpretation,
}

enum ProgressionSelectionReason {
  highestScore,
  segmentedModulation,
  tieBreakerCadence,
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

enum ParsedChordTokenKind { chord, placeholder, noChord, ignored, issue }

class UserFacingHarmonyLabel {
  const UserFacingHarmonyLabel({
    required this.primary,
    this.alias,
    this.explanation,
  });

  final String primary;
  final String? alias;
  final String? explanation;
}

class SuggestedFill {
  const SuggestedFill({
    required this.resolvedSymbol,
    required this.romanNumeral,
    required this.harmonicFunction,
    required this.score,
    required this.confidence,
    required this.rationale,
    this.sourceReason,
    this.sourceKind,
  });

  final String resolvedSymbol;
  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final double score;
  final double confidence;
  final String rationale;
  final String? sourceReason;
  final ChordSourceKind? sourceKind;
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
    this.tokenKind = ParsedChordTokenKind.issue,
    this.chord,
    this.isPlaceholder = false,
    this.error,
    this.errorDetail,
  });

  final int index;
  final String rawText;
  final int measureIndex;
  final int positionInMeasure;
  final ParsedChordTokenKind tokenKind;
  final ParsedChord? chord;
  final bool isPlaceholder;
  final String? error;
  final String? errorDetail;

  bool get isValid => tokenKind != ParsedChordTokenKind.issue;
  bool get isNoChord => tokenKind == ParsedChordTokenKind.noChord;
  bool get isIgnored => tokenKind == ParsedChordTokenKind.ignored;
  bool get isStructuralToken => isNoChord || isIgnored;
}

class ParsedMeasure {
  const ParsedMeasure({required this.measureIndex, required this.tokens});

  final int measureIndex;
  final List<ParsedChordToken> tokens;

  bool get isEmpty => tokens.isEmpty;

  List<ParsedChord> get validChords => [
    for (final token in tokens)
      if (token.chord != null) token.chord!,
  ];

  List<ParsedChordToken> get placeholders => [
    for (final token in tokens)
      if (token.isPlaceholder) token,
  ];

  List<ParsedChordToken> get noChords => [
    for (final token in tokens)
      if (token.isNoChord) token,
  ];

  List<ParsedChordToken> get ignoredTokens => [
    for (final token in tokens)
      if (token.isIgnored) token,
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

  List<ParsedChordToken> get noChords => [
    for (final token in tokens)
      if (token.isNoChord) token,
  ];

  List<ParsedChordToken> get ignoredTokens => [
    for (final token in tokens)
      if (token.isIgnored) token,
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
      ProgressionEvidenceKind.alteredDominantColor =>
        ProgressionHighlightCategory.alteredDominant,
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
    this.displayLabel,
    this.displayAlias,
    this.sourceReason,
    this.remarks = const [],
    this.evidence = const [],
  });

  final String romanNumeral;
  final ProgressionHarmonicFunction harmonicFunction;
  final String? chordSymbol;
  final RomanNumeralId? romanNumeralId;
  final ChordSourceKind? sourceKind;
  final double score;
  final String? displayLabel;
  final String? displayAlias;
  final String? sourceReason;
  final List<ProgressionRemark> remarks;
  final List<ProgressionEvidence> evidence;

  String get semanticKey =>
      '$romanNumeral|${harmonicFunction.name}|${sourceKind?.name ?? 'none'}';

  String get primaryDisplayLabel => displayLabel ?? romanNumeral;
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
    this.userFacingLabel,
    this.suggestedFills = const [],
    this.segmentIndex = 0,
    this.segmentKeyDisplay = '',
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
  final UserFacingHarmonyLabel? userFacingLabel;
  final List<SuggestedFill> suggestedFills;
  final int segmentIndex;
  final String segmentKeyDisplay;

  String get resolvedSymbol => inferredSymbol ?? chord.canonicalSymbol;
  String get primaryDisplayLabel => userFacingLabel?.primary ?? romanNumeral;
  String? get displayAlias => userFacingLabel?.alias;

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
    final hasAppliedDominant = remarks.any(
      (remark) =>
          remark.kind == ProgressionRemarkKind.possibleSecondaryDominant,
    );
    final hasTritoneSubstitute = remarks.any(
      (remark) =>
          remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute,
    );
    final hasTonicization = remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.tonicization,
    );
    final hasModulation = remarks.any(
      (remark) =>
          remark.kind == ProgressionRemarkKind.realModulation ||
          remark.kind == ProgressionRemarkKind.pivotChordInterpretation ||
          remark.kind == ProgressionRemarkKind.commonToneModulation,
    );
    final hasCommonToneDiminished = remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.commonToneDiminished,
    );
    final hasBackdoor = remarks.any(
      (remark) =>
          remark.kind == ProgressionRemarkKind.backdoorDominant ||
          remark.kind == ProgressionRemarkKind.backdoorChain,
    );
    final hasBorrowedColor = remarks.any(
      (remark) =>
          remark.kind == ProgressionRemarkKind.possibleModalInterchange ||
          remark.kind == ProgressionRemarkKind.subdominantMinor,
    );
    final hasDeceptiveCadence = remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.deceptiveCadence,
    );
    final hasChromaticLine = remarks.any(
      (remark) => remark.kind == ProgressionRemarkKind.lineClicheColor,
    );
    final hasAlteredDominant =
        !hasAppliedDominant &&
        !hasTritoneSubstitute &&
        evidence.any(
          (item) => item.kind == ProgressionEvidenceKind.alteredDominantColor,
        );

    if (hasAppliedDominant || sourceKind == ChordSourceKind.secondaryDominant) {
      ordered.add(ProgressionHighlightCategory.appliedDominant);
    }
    if (hasAlteredDominant) {
      ordered.add(ProgressionHighlightCategory.alteredDominant);
    }
    if (hasTritoneSubstitute ||
        sourceKind == ChordSourceKind.substituteDominant) {
      ordered.add(ProgressionHighlightCategory.tritoneSubstitute);
    }
    if (hasTonicization ||
        (sourceKind == ChordSourceKind.tonicization &&
            !hasCommonToneDiminished &&
            !hasTritoneSubstitute)) {
      ordered.add(ProgressionHighlightCategory.tonicization);
    }
    if (hasModulation) {
      ordered.add(ProgressionHighlightCategory.modulation);
    }
    if (hasBackdoor) {
      ordered.add(ProgressionHighlightCategory.backdoor);
    }
    if (hasBorrowedColor || sourceKind == ChordSourceKind.modalInterchange) {
      ordered.add(ProgressionHighlightCategory.borrowedColor);
    }
    if (hasCommonToneDiminished) {
      ordered.add(ProgressionHighlightCategory.commonTone);
    }
    if (hasDeceptiveCadence) {
      ordered.add(ProgressionHighlightCategory.deceptiveCadence);
    }
    if (hasChromaticLine) {
      ordered.add(ProgressionHighlightCategory.chromaticLine);
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
    Object? userFacingLabel = _retainValue,
    List<SuggestedFill>? suggestedFills,
    int? segmentIndex,
    String? segmentKeyDisplay,
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
      userFacingLabel: switch (userFacingLabel) {
        _RetainValue() => this.userFacingLabel,
        UserFacingHarmonyLabel value => value,
        _ => null,
      },
      suggestedFills: suggestedFills ?? this.suggestedFills,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      segmentKeyDisplay: segmentKeyDisplay ?? this.segmentKeyDisplay,
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

class AnalysisSegment {
  const AnalysisSegment({
    required this.segmentIndex,
    required this.startMeasureIndex,
    required this.endMeasureIndex,
    required this.keyCenter,
    required this.reason,
  });

  final int segmentIndex;
  final int startMeasureIndex;
  final int endMeasureIndex;
  final KeyCenter keyCenter;
  final String reason;

  String get keyDisplay => keyCenter.displayName;
  String get tonic => MusicTheory.displayRootForKey(keyCenter.tonicName);
  String get mode => keyCenter.mode.name;
}

class ProgressionAnalysis {
  const ProgressionAnalysis({
    required this.input,
    required this.parseResult,
    required this.primaryKey,
    required this.globalAggregateKey,
    required this.keyCandidates,
    required this.chordAnalyses,
    required this.groupedMeasures,
    this.alternativeKey,
    this.analysisSegments = const [],
    this.tags = const [],
    this.keyConfidence = 0.5,
    this.analysisReliability = 0.5,
    this.confidence = 0.5,
    this.ambiguity = 0.5,
    this.diagnosticStatus = ProgressionDiagnosticStatus.clean,
    this.warningCodes = const [],
    this.selectionReason = ProgressionSelectionReason.highestScore,
  });

  final String input;
  final ProgressionParseResult parseResult;
  final ProgressionKeyCandidate primaryKey;
  final ProgressionKeyCandidate globalAggregateKey;
  final ProgressionKeyCandidate? alternativeKey;
  final List<ProgressionKeyCandidate> keyCandidates;
  final List<AnalyzedChord> chordAnalyses;
  final List<AnalyzedMeasure> groupedMeasures;
  final List<AnalysisSegment> analysisSegments;
  final List<ProgressionTagId> tags;
  final double keyConfidence;
  final double analysisReliability;
  final double confidence;
  final double ambiguity;
  final ProgressionDiagnosticStatus diagnosticStatus;
  final List<ProgressionWarningCode> warningCodes;
  final ProgressionSelectionReason selectionReason;

  double get finalSelectionConfidence => analysisReliability;
  double get primaryKeyScore => primaryKey.score;
  double? get alternativeKeyScore => alternativeKey?.score;
  double get primaryKeyConfidence => primaryKey.confidence;
  double get globalAggregateKeyConfidence => globalAggregateKey.confidence;
  String get primaryKeyDisplay => primaryKey.keyCenter.displayName;
  String get homeKeyDisplay => primaryKey.keyCenter.displayName;
  String get globalAggregateKeyDisplay => globalAggregateKey.keyCenter.displayName;

  int get ambiguousChordCount =>
      chordAnalyses.where((analysis) => analysis.isAmbiguous).length;

  int get inferredChordCount =>
      chordAnalyses.where((analysis) => analysis.isInferred).length;

  int get unresolvedChordCount => chordAnalyses
      .where(
        (analysis) => analysis.remarks.any(
          (remark) => remark.kind == ProgressionRemarkKind.unresolved,
        ),
      )
      .length;

  bool get hasWarnings => warningCodes.isNotEmpty;

  bool get hasRealModulation =>
      tags.contains(ProgressionTagId.realModulation) ||
      analysisSegments.length > 1;

  bool get hasTonicization => tags.contains(ProgressionTagId.tonicization);

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
        ProgressionTagId.realModulation =>
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
    if (!hasRealModulation) {
      categories.remove(ProgressionHighlightCategory.modulation);
    }
    return categories;
  }

  bool get canGenerateVariations =>
      diagnosticStatus == ProgressionDiagnosticStatus.clean &&
      !parseResult.hasPartialFailure &&
      parseResult.placeholders.isEmpty &&
      unresolvedChordCount == 0 &&
      !warningCodes.contains(ProgressionWarningCode.unknownModifier) &&
      analysisReliability >= 0.75;
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

extension ProgressionDiagnosticStatusX on ProgressionDiagnosticStatus {
  String get wireName => switch (this) {
    ProgressionDiagnosticStatus.partialParse => 'partial_parse',
    ProgressionDiagnosticStatus.placeholderInference => 'placeholder_inference',
    ProgressionDiagnosticStatus.unresolvedHarmony => 'unresolved_harmony',
    ProgressionDiagnosticStatus.ambiguousHarmony => 'ambiguous_harmony',
    ProgressionDiagnosticStatus.clean => 'clean',
  };
}

extension ProgressionWarningCodeX on ProgressionWarningCode {
  String get wireName => switch (this) {
    ProgressionWarningCode.parseIssue => 'parse_issue',
    ProgressionWarningCode.invalidBass => 'invalid_bass',
    ProgressionWarningCode.unknownModifier => 'unknown_modifier',
    ProgressionWarningCode.placeholderUsed => 'placeholder_used',
    ProgressionWarningCode.unresolvedChord => 'unresolved_chord',
    ProgressionWarningCode.ambiguousInterpretation =>
      'ambiguous_interpretation',
  };
}

extension ProgressionSelectionReasonX on ProgressionSelectionReason {
  String get wireName => switch (this) {
    ProgressionSelectionReason.highestScore => 'highest_score',
    ProgressionSelectionReason.segmentedModulation => 'segmented_modulation',
    ProgressionSelectionReason.tieBreakerCadence => 'tie_breaker_cadence',
  };
}
