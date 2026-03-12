import '../l10n/app_localizations.dart';
import 'chord_theory.dart';
import 'progression_analysis_models.dart';

class ProgressionExplainer {
  const ProgressionExplainer();

  List<String> buildSummary(
    AppLocalizations l10n,
    ProgressionAnalysis analysis,
  ) {
    final sentences = <String>[];
    final primaryLabel = _keyLabel(l10n, analysis.primaryKey.keyCenter);
    sentences.add(l10n.chordAnalyzerSummaryCenter(primaryLabel));

    final leadTag = analysis.tags.isEmpty ? null : analysis.tags.first;
    if (leadTag != null) {
      sentences.add(l10n.chordAnalyzerSummaryTag(_tagLabel(l10n, leadTag)));
    }

    final cadenceSpan = _iiVISpan(analysis.chordAnalyses);
    if (cadenceSpan != null) {
      sentences.add(
        l10n.chordAnalyzerSummaryFlow(
          cadenceSpan.first.chord.sourceSymbol,
          cadenceSpan.second.chord.sourceSymbol,
          _functionLabel(
            l10n,
            cadenceSpan.first.harmonicFunction,
          ).toLowerCase(),
          _functionLabel(
            l10n,
            cadenceSpan.second.harmonicFunction,
          ).toLowerCase(),
          cadenceSpan.third.chord.sourceSymbol,
        ),
      );
    }

    final notable = _firstNotableChord(analysis.chordAnalyses);
    if (notable != null) {
      final remark = notable.remarks.firstWhere(
        (candidate) =>
            candidate.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            candidate.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            candidate.kind == ProgressionRemarkKind.possibleModalInterchange,
      );
      switch (remark.kind) {
        case ProgressionRemarkKind.possibleSecondaryDominant:
          sentences.add(
            l10n.chordAnalyzerSummarySecondaryDominant(
              notable.chord.sourceSymbol,
              remark.targetRomanNumeral ?? '?',
            ),
          );
        case ProgressionRemarkKind.possibleTritoneSubstitute:
          sentences.add(
            l10n.chordAnalyzerSummaryTritoneSub(
              notable.chord.sourceSymbol,
              remark.targetRomanNumeral ?? '?',
            ),
          );
        case ProgressionRemarkKind.possibleModalInterchange:
          sentences.add(
            l10n.chordAnalyzerSummaryModalInterchange(
              notable.chord.sourceSymbol,
            ),
          );
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

    return sentences.take(5).toList();
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
      ProgressionRemarkKind.ambiguousInterpretation =>
        l10n.chordAnalyzerRemarkAmbiguous,
      ProgressionRemarkKind.unresolved => l10n.chordAnalyzerRemarkUnresolved,
    };
  }

  String evidenceLabel(AppLocalizations l10n, ProgressionEvidence evidence) {
    return switch (evidence.kind) {
      ProgressionEvidenceKind.qualityMatch =>
        l10n.chordAnalyzerFunctionOther,
      ProgressionEvidenceKind.extensionColor =>
        l10n.chordAnalyzerEvidenceExtensionColor(evidence.detail ?? '?'),
      ProgressionEvidenceKind.alteredDominantColor =>
        l10n.chordAnalyzerEvidenceAlteredDominantColor,
      ProgressionEvidenceKind.slashBass =>
        l10n.chordAnalyzerEvidenceSlashBass(evidence.detail ?? '?'),
      ProgressionEvidenceKind.resolution =>
        l10n.chordAnalyzerEvidenceResolution(evidence.detail ?? '?'),
      ProgressionEvidenceKind.borrowedColor =>
        l10n.chordAnalyzerEvidenceBorrowedColor,
      ProgressionEvidenceKind.suspensionColor =>
        l10n.chordAnalyzerEvidenceSuspensionColor,
    };
  }

  AnalyzedChord? _firstNotableChord(List<AnalyzedChord> analyses) {
    for (final analysis in analyses) {
      if (analysis.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
            remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
            remark.kind == ProgressionRemarkKind.possibleModalInterchange,
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
