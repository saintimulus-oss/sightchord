import '../l10n/app_localizations.dart';
import 'chord_theory.dart';
import 'progression_analysis_models.dart';
import 'progression_highlight_theme.dart';

class ProgressionExplainer {
  const ProgressionExplainer();

  List<String> buildSummary(
    AppLocalizations l10n,
    ProgressionAnalysis analysis, {
    ProgressionExplanationDetailLevel detailLevel =
        ProgressionExplanationDetailLevel.concise,
  }) {
    final sentences = <String>[];
    final primaryLabel = _keyLabel(l10n, analysis.primaryKey.keyCenter);
    sentences.add(l10n.chordAnalyzerSummaryCenter(primaryLabel));

    final modulationRemark = _firstRemark(
      analysis.chordAnalyses,
      ProgressionRemarkKind.realModulation,
    );
    if (modulationRemark?.targetKeyCenter case final targetKeyCenter?) {
      sentences.add(
        l10n.chordAnalyzerSummaryRealModulation(
          _keyLabel(l10n, targetKeyCenter),
        ),
      );
    } else {
      final tonicizationRemark = _firstRemark(
        analysis.chordAnalyses,
        ProgressionRemarkKind.tonicization,
      );
      if (tonicizationRemark != null) {
        final targetText = tonicizationRemark.targetKeyCenter != null
            ? _keyLabel(l10n, tonicizationRemark.targetKeyCenter!)
            : tonicizationRemark.targetRomanNumeral ?? '?';
        sentences.add(l10n.chordAnalyzerSummaryTonicization(targetText));
      }
    }

    final leadTag = analysis.tags.isEmpty ? null : analysis.tags.first;
    if (leadTag != null) {
      sentences.add(l10n.chordAnalyzerSummaryTag(_tagLabel(l10n, leadTag)));
    }

    final cadenceSpan = _iiVISpan(analysis.chordAnalyses);
    if (cadenceSpan != null &&
        detailLevel != ProgressionExplanationDetailLevel.concise) {
      sentences.add(
        l10n.chordAnalyzerSummaryFlow(
          cadenceSpan.first.resolvedSymbol,
          cadenceSpan.second.resolvedSymbol,
          _functionLabel(
            l10n,
            cadenceSpan.first.harmonicFunction,
          ).toLowerCase(),
          _functionLabel(
            l10n,
            cadenceSpan.second.harmonicFunction,
          ).toLowerCase(),
          cadenceSpan.third.resolvedSymbol,
        ),
      );
    }

    if (analysis.tags.contains(ProgressionTagId.backdoorChain)) {
      sentences.add(l10n.chordAnalyzerSummaryBackdoor);
    }
    if (analysis.tags.contains(ProgressionTagId.deceptiveCadence)) {
      sentences.add(l10n.chordAnalyzerSummaryDeceptiveCadence);
    }
    if (analysis.tags.contains(ProgressionTagId.chromaticLine)) {
      sentences.add(l10n.chordAnalyzerSummaryChromaticLine);
    }

    final notable = _firstNotableChord(analysis.chordAnalyses);
    if (notable != null) {
      final remark = notable.remarks.firstWhere(
        (candidate) =>
            candidate.kind == ProgressionRemarkKind.backdoorDominant ||
            candidate.kind == ProgressionRemarkKind.subdominantMinor ||
            candidate.kind == ProgressionRemarkKind.commonToneDiminished ||
            candidate.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            candidate.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            candidate.kind == ProgressionRemarkKind.possibleModalInterchange ||
            candidate.kind == ProgressionRemarkKind.deceptiveCadence,
      );
      switch (remark.kind) {
        case ProgressionRemarkKind.backdoorDominant:
          sentences.add(
            l10n.chordAnalyzerSummaryBackdoorDominant(notable.resolvedSymbol),
          );
        case ProgressionRemarkKind.subdominantMinor:
          sentences.add(
            l10n.chordAnalyzerSummarySubdominantMinor(notable.resolvedSymbol),
          );
        case ProgressionRemarkKind.commonToneDiminished:
          sentences.add(
            l10n.chordAnalyzerSummaryCommonToneDiminished(
              notable.resolvedSymbol,
            ),
          );
        case ProgressionRemarkKind.possibleSecondaryDominant:
          sentences.add(
            l10n.chordAnalyzerSummarySecondaryDominant(
              notable.resolvedSymbol,
              remark.targetRomanNumeral ?? '?',
            ),
          );
        case ProgressionRemarkKind.possibleTritoneSubstitute:
          sentences.add(
            l10n.chordAnalyzerSummaryTritoneSub(
              notable.resolvedSymbol,
              remark.targetRomanNumeral ?? '?',
            ),
          );
        case ProgressionRemarkKind.possibleModalInterchange:
          sentences.add(
            l10n.chordAnalyzerSummaryModalInterchange(notable.resolvedSymbol),
          );
        case ProgressionRemarkKind.deceptiveCadence:
          sentences.add(
            l10n.chordAnalyzerSummaryDeceptiveTarget(notable.resolvedSymbol),
          );
        case ProgressionRemarkKind.tonicization:
        case ProgressionRemarkKind.realModulation:
        case ProgressionRemarkKind.backdoorChain:
        case ProgressionRemarkKind.pivotChordInterpretation:
        case ProgressionRemarkKind.commonToneModulation:
        case ProgressionRemarkKind.lineClicheColor:
        case ProgressionRemarkKind.dualFunctionAmbiguity:
        case ProgressionRemarkKind.ambiguousInterpretation:
        case ProgressionRemarkKind.unresolved:
          break;
      }
    }

    if (analysis.alternativeKey != null) {
      sentences.add(
        l10n.chordAnalyzerSummaryAlternative(
          _keyLabel(l10n, analysis.alternativeKey!.keyCenter),
        ),
      );
    }

    if (analysis.ambiguousChordCount > 0 ||
        analysis.unresolvedChordCount > 0 ||
        analysis.parseResult.hasPartialFailure) {
      sentences.add(l10n.chordAnalyzerSummaryAmbiguous);
    }

    if (detailLevel == ProgressionExplanationDetailLevel.advanced) {
      final advancedFocus = analysis.chordAnalyses.firstWhere(
        (candidate) =>
            candidate.hasRemark(ProgressionRemarkKind.dualFunctionAmbiguity) ||
            candidate.competingInterpretations.isNotEmpty,
        orElse: () => analysis.chordAnalyses.first,
      );
      if (advancedFocus.competingInterpretations.isNotEmpty) {
        sentences.add(
          l10n.chordAnalyzerSummaryCompeting(
            advancedFocus.competingInterpretations
                .take(2)
                .map((candidate) => candidate.romanNumeral)
                .join(', '),
          ),
        );
      }
    }

    return sentences.take(_summaryLimit(detailLevel)).toList();
  }

  String keyLabel(AppLocalizations l10n, KeyCenter keyCenter) {
    return _keyLabel(l10n, keyCenter);
  }

  String functionLabel(
    AppLocalizations l10n,
    ProgressionHarmonicFunction function,
  ) {
    return _functionLabel(l10n, function);
  }

  String tagLabel(AppLocalizations l10n, ProgressionTagId tag) {
    return _tagLabel(l10n, tag);
  }

  String buildChordExplanation(
    AppLocalizations l10n,
    AnalyzedChord analysis, {
    required ProgressionExplanationDetailLevel detailLevel,
  }) {
    final parts = <String>[
      l10n.chordAnalyzerFunctionLine(
        _functionLabel(l10n, analysis.harmonicFunction),
      ),
    ];
    final nonAmbiguousRemarks = [
      for (final remark in analysis.remarks)
        if (remark.kind != ProgressionRemarkKind.ambiguousInterpretation)
          remarkLabel(l10n, remark),
    ];
    if (nonAmbiguousRemarks.isNotEmpty) {
      final limit = detailLevel == ProgressionExplanationDetailLevel.concise
          ? 1
          : 2;
      parts.add(nonAmbiguousRemarks.take(limit).join(' '));
    }

    if (detailLevel != ProgressionExplanationDetailLevel.concise) {
      final evidenceText = [
        for (final evidence in analysis.evidence)
          if (evidence.kind != ProgressionEvidenceKind.qualityMatch)
            evidenceLabel(l10n, evidence),
      ];
      if (evidenceText.isNotEmpty) {
        parts.add(
          l10n.chordAnalyzerEvidenceLead(
            evidenceText
                .take(
                  detailLevel == ProgressionExplanationDetailLevel.detailed
                      ? 1
                      : 2,
                )
                .join(' '),
          ),
        );
      }
    }

    if (detailLevel == ProgressionExplanationDetailLevel.advanced &&
        analysis.competingInterpretations.isNotEmpty) {
      parts.add(
        l10n.chordAnalyzerAdvancedCompetingReadings(
          analysis.competingInterpretations
              .take(2)
              .map((candidate) => candidate.romanNumeral)
              .join(', '),
        ),
      );
    }

    return parts.join(' ');
  }

  String remarkLabel(AppLocalizations l10n, ProgressionRemark remark) {
    return switch (remark.kind) {
      ProgressionRemarkKind.possibleSecondaryDominant =>
        l10n.chordAnalyzerRemarkSecondaryDominant(
          remark.targetRomanNumeral ?? '?',
        ),
      ProgressionRemarkKind.possibleTritoneSubstitute =>
        l10n.chordAnalyzerRemarkTritoneSub(remark.targetRomanNumeral ?? '?'),
      ProgressionRemarkKind.possibleModalInterchange =>
        l10n.chordAnalyzerRemarkModalInterchange,
      ProgressionRemarkKind.tonicization =>
        l10n.chordAnalyzerRemarkTonicization(
          remark.targetKeyCenter == null
              ? remark.targetRomanNumeral ?? '?'
              : _keyLabel(l10n, remark.targetKeyCenter!),
        ),
      ProgressionRemarkKind.realModulation =>
        l10n.chordAnalyzerRemarkRealModulation(
          remark.targetKeyCenter == null
              ? '?'
              : _keyLabel(l10n, remark.targetKeyCenter!),
        ),
      ProgressionRemarkKind.backdoorDominant =>
        l10n.chordAnalyzerRemarkBackdoorDominant,
      ProgressionRemarkKind.backdoorChain =>
        l10n.chordAnalyzerRemarkBackdoorChain,
      ProgressionRemarkKind.subdominantMinor =>
        l10n.chordAnalyzerRemarkSubdominantMinor,
      ProgressionRemarkKind.commonToneDiminished =>
        l10n.chordAnalyzerRemarkCommonToneDiminished,
      ProgressionRemarkKind.pivotChordInterpretation =>
        l10n.chordAnalyzerRemarkPivotChord,
      ProgressionRemarkKind.commonToneModulation =>
        l10n.chordAnalyzerRemarkCommonToneModulation,
      ProgressionRemarkKind.deceptiveCadence =>
        l10n.chordAnalyzerRemarkDeceptiveCadence,
      ProgressionRemarkKind.lineClicheColor =>
        l10n.chordAnalyzerRemarkLineCliche,
      ProgressionRemarkKind.dualFunctionAmbiguity =>
        l10n.chordAnalyzerRemarkDualFunction,
      ProgressionRemarkKind.ambiguousInterpretation =>
        l10n.chordAnalyzerRemarkAmbiguous,
      ProgressionRemarkKind.unresolved => l10n.chordAnalyzerRemarkUnresolved,
    };
  }

  String evidenceLabel(AppLocalizations l10n, ProgressionEvidence evidence) {
    return switch (evidence.kind) {
      ProgressionEvidenceKind.qualityMatch => l10n.chordAnalyzerFunctionOther,
      ProgressionEvidenceKind.extensionColor =>
        l10n.chordAnalyzerEvidenceExtensionColor(evidence.detail ?? '?'),
      ProgressionEvidenceKind.alteredDominantColor =>
        l10n.chordAnalyzerEvidenceAlteredDominantColor,
      ProgressionEvidenceKind.slashBass => l10n.chordAnalyzerEvidenceSlashBass(
        evidence.detail ?? '?',
      ),
      ProgressionEvidenceKind.resolution =>
        l10n.chordAnalyzerEvidenceResolution(evidence.detail ?? '?'),
      ProgressionEvidenceKind.borrowedColor =>
        l10n.chordAnalyzerEvidenceBorrowedColor,
      ProgressionEvidenceKind.suspensionColor =>
        l10n.chordAnalyzerEvidenceSuspensionColor,
      ProgressionEvidenceKind.cadentialArrival =>
        l10n.chordAnalyzerEvidenceCadentialArrival,
      ProgressionEvidenceKind.followThroughSupport =>
        l10n.chordAnalyzerEvidenceFollowThrough,
      ProgressionEvidenceKind.phraseBoundary =>
        l10n.chordAnalyzerEvidencePhraseBoundary,
      ProgressionEvidenceKind.pivotSupport =>
        l10n.chordAnalyzerEvidencePivotSupport,
      ProgressionEvidenceKind.commonToneSupport =>
        l10n.chordAnalyzerEvidenceCommonToneSupport,
      ProgressionEvidenceKind.homeGravityWeakening =>
        l10n.chordAnalyzerEvidenceHomeGravityWeakening,
      ProgressionEvidenceKind.backdoorMotion =>
        l10n.chordAnalyzerEvidenceBackdoorMotion,
      ProgressionEvidenceKind.deceptiveResolution =>
        l10n.chordAnalyzerEvidenceDeceptiveResolution,
      ProgressionEvidenceKind.chromaticLine =>
        l10n.chordAnalyzerEvidenceChromaticLine(evidence.detail ?? '?'),
      ProgressionEvidenceKind.competingReading =>
        l10n.chordAnalyzerEvidenceCompetingReading(evidence.detail ?? '?'),
    };
  }

  AnalyzedChord? _firstNotableChord(List<AnalyzedChord> analyses) {
    for (final analysis in analyses) {
      if (analysis.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.backdoorDominant ||
            remark.kind == ProgressionRemarkKind.subdominantMinor ||
            remark.kind == ProgressionRemarkKind.commonToneDiminished ||
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            remark.kind == ProgressionRemarkKind.possibleModalInterchange ||
            remark.kind == ProgressionRemarkKind.deceptiveCadence,
      )) {
        return analysis;
      }
    }
    return null;
  }

  _CadenceSpan? _iiVISpan(List<AnalyzedChord> analyses) {
    for (var index = 0; index < analyses.length - 2; index += 1) {
      final first = analyses[index];
      final second = analyses[index + 1];
      final third = analyses[index + 2];
      if (third.chord.measureIndex - first.chord.measureIndex > 2) {
        continue;
      }
      final isIiVI =
          (first.romanNumeralId == RomanNumeralId.iiMin7 ||
              first.romanNumeralId == RomanNumeralId.iiHalfDiminishedMinor) &&
          second.harmonicFunction == ProgressionHarmonicFunction.dominant &&
          (third.romanNumeralId == RomanNumeralId.iMaj7 ||
              third.romanNumeralId == RomanNumeralId.iMaj69 ||
              third.romanNumeralId == RomanNumeralId.iMin7 ||
              third.romanNumeralId == RomanNumeralId.iMin6 ||
              third.romanNumeralId == RomanNumeralId.iMinMaj7);
      if (isIiVI) {
        return _CadenceSpan(first: first, second: second, third: third);
      }
    }
    return null;
  }

  String _keyLabel(AppLocalizations l10n, KeyCenter keyCenter) {
    final tonic = MusicTheory.displayRootForKey(keyCenter.tonicName);
    final mode = keyCenter.mode == KeyMode.major
        ? l10n.modeMajor
        : l10n.modeMinor;
    return '$tonic $mode';
  }

  String _functionLabel(
    AppLocalizations l10n,
    ProgressionHarmonicFunction function,
  ) {
    return switch (function) {
      ProgressionHarmonicFunction.tonic => l10n.chordAnalyzerFunctionTonic,
      ProgressionHarmonicFunction.predominant =>
        l10n.chordAnalyzerFunctionPredominant,
      ProgressionHarmonicFunction.dominant =>
        l10n.chordAnalyzerFunctionDominant,
      ProgressionHarmonicFunction.other => l10n.chordAnalyzerFunctionOther,
    };
  }

  String _tagLabel(AppLocalizations l10n, ProgressionTagId tag) {
    return switch (tag) {
      ProgressionTagId.iiVI => l10n.chordAnalyzerTagIiVI,
      ProgressionTagId.turnaround => l10n.chordAnalyzerTagTurnaround,
      ProgressionTagId.dominantResolution =>
        l10n.chordAnalyzerTagDominantResolution,
      ProgressionTagId.plagalColor => l10n.chordAnalyzerTagPlagalColor,
      ProgressionTagId.tonicization => l10n.chordAnalyzerTagTonicization,
      ProgressionTagId.realModulation => l10n.chordAnalyzerTagRealModulation,
      ProgressionTagId.backdoorChain => l10n.chordAnalyzerTagBackdoorChain,
      ProgressionTagId.deceptiveCadence =>
        l10n.chordAnalyzerTagDeceptiveCadence,
      ProgressionTagId.chromaticLine => l10n.chordAnalyzerTagChromaticLine,
      ProgressionTagId.commonToneMotion =>
        l10n.chordAnalyzerTagCommonToneMotion,
    };
  }

  ProgressionRemark? _firstRemark(
    List<AnalyzedChord> analyses,
    ProgressionRemarkKind kind,
  ) {
    for (final analysis in analyses) {
      for (final remark in analysis.remarks) {
        if (remark.kind == kind) {
          return remark;
        }
      }
    }
    return null;
  }

  int _summaryLimit(ProgressionExplanationDetailLevel detailLevel) {
    return switch (detailLevel) {
      ProgressionExplanationDetailLevel.concise => 4,
      ProgressionExplanationDetailLevel.detailed => 6,
      ProgressionExplanationDetailLevel.advanced => 8,
    };
  }
}

class _CadenceSpan {
  const _CadenceSpan({
    required this.first,
    required this.second,
    required this.third,
  });

  final AnalyzedChord first;
  final AnalyzedChord second;
  final AnalyzedChord third;
}
