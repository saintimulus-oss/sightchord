import '../l10n/app_localizations.dart';
import '../study_harmony/content/track_pedagogy_profiles.dart';
import '../study_harmony/domain/study_harmony_session_models.dart';
import 'chord_theory.dart';
import 'explanation_models.dart';
import 'melody_models.dart';
import 'progression_analysis_models.dart';
import 'progression_explainer.dart';
import 'progression_highlight_theme.dart';
import 'voicing_models.dart';

class ProgressionExplanationBundleBuilder {
  const ProgressionExplanationBundleBuilder({ProgressionExplainer? explainer})
    : _explainer = explainer ?? const ProgressionExplainer();

  final ProgressionExplainer _explainer;

  ExplanationBundle build({
    required AppLocalizations l10n,
    required ProgressionAnalysis analysis,
    StudyHarmonyTrackId? trackId,
    TrackExerciseFlavor? exerciseFlavor,
    AnalyzedChord? focusChord,
    VoicingSuggestion? voicingSuggestion,
    GeneratedMelodyEvent? melodyEvent,
  }) {
    final summaryLines = _explainer.buildSummary(
      l10n,
      analysis,
      detailLevel: ProgressionExplanationDetailLevel.concise,
    );
    final targetChord =
        focusChord ??
        analysis.chordAnalyses.firstWhere(
          (candidate) => candidate.isNonDiatonic || candidate.isAmbiguous,
          orElse: () => analysis.chordAnalyses.first,
        );

    final reasonTags = _reasonTags(
      l10n,
      analysis: analysis,
      targetChord: targetChord,
      exerciseFlavor: exerciseFlavor,
      voicingSuggestion: voicingSuggestion,
      melodyEvent: melodyEvent,
    );
    final confidenceBadge = ConfidenceBadgeModel(
      label: l10n.chordAnalyzerConfidenceLabel,
      value: analysis.confidence,
      tone: _confidenceToneForValue(analysis.confidence),
      caption: _confidenceCaption(l10n, analysis.confidence),
    );
    final ambiguityCaption = _ambiguityCaption(l10n, analysis);

    final alternatives = <AlternativeInterpretation>[
      if (analysis.alternativeKey != null)
        AlternativeInterpretation(
          label: l10n.explanationAlternativeKeyLabel(
            _explainer.keyLabel(l10n, analysis.alternativeKey!.keyCenter),
          ),
          detail: _alternativeKeyDetail(l10n, analysis),
          confidence: analysis.alternativeKey!.confidence,
        ),
      for (final candidate in targetChord.competingInterpretations.take(2))
        AlternativeInterpretation(
          label: l10n.explanationAlternativeReadingLabel(
            candidate.romanNumeral,
          ),
          detail: _alternativeReadingDetail(l10n, candidate),
          confidence: candidate.score.clamp(0.0, 1.0).toDouble(),
        ),
    ];

    return ExplanationBundle(
      summary: summaryLines.join(' '),
      trackContext: _trackContext(
        l10n,
        trackId: trackId,
        exerciseFlavor: exerciseFlavor,
      ),
      confidenceBadge: confidenceBadge,
      ambiguityValue: analysis.ambiguity,
      ambiguityCaption: ambiguityCaption,
      caution: _cautionText(l10n, analysis),
      reasonTags: reasonTags,
      listeningHints: _listeningHints(
        l10n,
        trackId: trackId,
        exerciseFlavor: exerciseFlavor,
        analysis: analysis,
        targetChord: targetChord,
      ),
      performanceHints: _performanceHints(
        l10n,
        trackId: trackId,
        exerciseFlavor: exerciseFlavor,
        analysis: analysis,
        targetChord: targetChord,
        voicingSuggestion: voicingSuggestion,
        melodyEvent: melodyEvent,
      ),
      alternativeInterpretations: alternatives,
    );
  }

  ConfidenceTone _confidenceToneForValue(double value) {
    if (value >= 0.82) {
      return ConfidenceTone.strong;
    }
    if (value >= 0.62) {
      return ConfidenceTone.moderate;
    }
    return ConfidenceTone.cautious;
  }

  String _confidenceCaption(AppLocalizations l10n, double value) {
    if (value >= 0.82) {
      return l10n.explanationConfidenceHigh;
    }
    if (value >= 0.62) {
      return l10n.explanationConfidenceMedium;
    }
    return l10n.explanationConfidenceLow;
  }

  String? _cautionText(AppLocalizations l10n, ProgressionAnalysis analysis) {
    if (analysis.parseResult.issues.isNotEmpty) {
      return l10n.explanationCautionParser;
    }
    if (analysis.unresolvedChordCount > 0 || analysis.ambiguousChordCount > 0) {
      return l10n.explanationCautionAmbiguous;
    }
    if (analysis.alternativeKey != null) {
      return l10n.explanationCautionAlternateKey;
    }
    return null;
  }

  String? _ambiguityCaption(
    AppLocalizations l10n,
    ProgressionAnalysis analysis,
  ) {
    final value = analysis.ambiguity;
    if (value >= 0.68 || analysis.unresolvedChordCount > 0) {
      return l10n.explanationAmbiguityHigh;
    }
    if (value >= 0.34 ||
        analysis.alternativeKey != null ||
        analysis.ambiguousChordCount > 0) {
      return l10n.explanationAmbiguityMedium;
    }
    if (value >= 0.16) {
      return l10n.explanationAmbiguityLow;
    }
    return null;
  }

  String _alternativeKeyDetail(
    AppLocalizations l10n,
    ProgressionAnalysis analysis,
  ) {
    final fragments = <String>[l10n.explanationAlternativeKeyBody];
    if (analysis.hasRealModulation) {
      fragments.add(l10n.chordAnalyzerSummaryAmbiguous);
    }
    return fragments.join(' ');
  }

  String _alternativeReadingDetail(
    AppLocalizations l10n,
    ChordInterpretationCandidate candidate,
  ) {
    final fragments = <String>[l10n.explanationAlternativeReadingBody];
    final firstRemark = candidate.remarks.cast<ProgressionRemark?>().firstWhere(
      (remark) => remark != null,
      orElse: () => null,
    );
    final firstEvidence = candidate.evidence
        .cast<ProgressionEvidence?>()
        .firstWhere(
          (evidence) =>
              evidence != null &&
              evidence.kind != ProgressionEvidenceKind.qualityMatch,
          orElse: () => null,
        );
    if (firstRemark != null) {
      fragments.add(_explainer.remarkLabel(l10n, firstRemark));
    } else if (firstEvidence != null) {
      fragments.add(_explainer.evidenceLabel(l10n, firstEvidence));
    } else if (candidate.harmonicFunction !=
        ProgressionHarmonicFunction.other) {
      fragments.add(
        l10n.chordAnalyzerFunctionLine(
          _explainer.functionLabel(l10n, candidate.harmonicFunction),
        ),
      );
    }
    return fragments.join(' ');
  }

  String? _trackContext(
    AppLocalizations l10n, {
    required StudyHarmonyTrackId? trackId,
    required TrackExerciseFlavor? exerciseFlavor,
  }) {
    if (trackId == null) {
      return null;
    }
    final pedagogy = trackPedagogyProfileForTrack(l10n, trackId);

    String focusAt(int index) {
      if (index < pedagogy.focusPoints.length) {
        return pedagogy.focusPoints[index];
      }
      return '';
    }

    final focus = switch (exerciseFlavor) {
      TrackExerciseFlavor.popHookLoop ||
      TrackExerciseFlavor.jazzGuideTone ||
      TrackExerciseFlavor.jazzShellVoicing ||
      TrackExerciseFlavor.classicalCadence => focusAt(0),
      TrackExerciseFlavor.popBorrowedLift ||
      TrackExerciseFlavor.jazzMinorCadence ||
      TrackExerciseFlavor.jazzRootlessVoicing ||
      TrackExerciseFlavor.classicalInversion => focusAt(1),
      TrackExerciseFlavor.popBassMotion ||
      TrackExerciseFlavor.jazzDominantColor ||
      TrackExerciseFlavor.jazzBackdoorCadence ||
      TrackExerciseFlavor.classicalSecondaryDominant => focusAt(2),
      _ => '',
    };

    final generic = switch (trackId) {
      'pop' => l10n.explanationTrackContextPop,
      'jazz' => l10n.explanationTrackContextJazz,
      'classical' => l10n.explanationTrackContextClassical,
      _ => null,
    };
    if (focus.isEmpty) {
      return generic;
    }
    if (generic == null || generic.isEmpty) {
      return '${pedagogy.theoryTone} $focus';
    }
    return '$generic ${pedagogy.theoryTone} $focus';
  }

  List<ReasonTag> _reasonTags(
    AppLocalizations l10n, {
    required ProgressionAnalysis analysis,
    required AnalyzedChord targetChord,
    required TrackExerciseFlavor? exerciseFlavor,
    required VoicingSuggestion? voicingSuggestion,
    required GeneratedMelodyEvent? melodyEvent,
  }) {
    final ordered = <ReasonCode, ReasonTag>{};

    void add(ReasonCode code, String label, String detail) {
      ordered.putIfAbsent(
        code,
        () => ReasonTag(code: code, label: label, detail: detail),
      );
    }

    if (targetChord.harmonicFunction != ProgressionHarmonicFunction.other) {
      add(
        ReasonCode.functionalResolution,
        l10n.explanationReasonFunctionalResolutionLabel,
        l10n.explanationReasonFunctionalResolutionBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.iiVI) ||
        targetChord.evidence.any(
          (evidence) => evidence.kind == ProgressionEvidenceKind.resolution,
        ) ||
        (voicingSuggestion?.reasonTags.contains(
              VoicingReasonTag.guideToneAnchor,
            ) ??
            false)) {
      add(
        ReasonCode.guideToneSmoothness,
        l10n.explanationReasonGuideToneSmoothnessLabel,
        l10n.explanationReasonGuideToneSmoothnessBody,
      );
    }

    if (targetChord.hasRemark(ProgressionRemarkKind.possibleModalInterchange) ||
        targetChord.hasRemark(ProgressionRemarkKind.subdominantMinor) ||
        targetChord.evidence.any(
          (evidence) => evidence.kind == ProgressionEvidenceKind.borrowedColor,
        )) {
      add(
        ReasonCode.borrowedColor,
        l10n.explanationReasonBorrowedColorLabel,
        l10n.explanationReasonBorrowedColorBody,
      );
    }

    if (targetChord.hasRemark(
          ProgressionRemarkKind.possibleSecondaryDominant,
        ) ||
        targetChord.sourceKind == ChordSourceKind.secondaryDominant) {
      add(
        ReasonCode.secondaryDominantPull,
        l10n.explanationReasonSecondaryDominantLabel,
        l10n.explanationReasonSecondaryDominantBody,
      );
    }

    if (targetChord.hasRemark(
          ProgressionRemarkKind.possibleTritoneSubstitute,
        ) ||
        targetChord.sourceKind == ChordSourceKind.substituteDominant) {
      add(
        ReasonCode.tritoneSubColor,
        l10n.explanationReasonTritoneSubLabel,
        l10n.explanationReasonTritoneSubBody,
      );
    }

    if (targetChord.chord.hasAlteredColor ||
        targetChord.evidence.any(
          (evidence) =>
              evidence.kind == ProgressionEvidenceKind.alteredDominantColor,
        ) ||
        exerciseFlavor == TrackExerciseFlavor.jazzDominantColor) {
      add(
        ReasonCode.dominantColor,
        l10n.explanationReasonDominantColorLabel,
        l10n.explanationReasonDominantColorBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.backdoorChain) ||
        targetChord.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
        targetChord.hasRemark(ProgressionRemarkKind.backdoorChain) ||
        targetChord.hasRemark(ProgressionRemarkKind.subdominantMinor) ||
        targetChord.evidence.any(
          (evidence) => evidence.kind == ProgressionEvidenceKind.backdoorMotion,
        ) ||
        exerciseFlavor == TrackExerciseFlavor.jazzBackdoorCadence) {
      add(
        ReasonCode.backdoorMotion,
        l10n.explanationReasonBackdoorMotionLabel,
        l10n.explanationReasonBackdoorMotionBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.dominantResolution) ||
        analysis.tags.contains(ProgressionTagId.deceptiveCadence) ||
        exerciseFlavor == TrackExerciseFlavor.classicalCadence) {
      add(
        ReasonCode.cadentialStrength,
        l10n.explanationReasonCadentialStrengthLabel,
        l10n.explanationReasonCadentialStrengthBody,
      );
    }

    if ((voicingSuggestion?.reasonTags.contains(
              VoicingReasonTag.guideToneResolution,
            ) ??
            false) ||
        (voicingSuggestion?.reasonTags.contains(
              VoicingReasonTag.commonToneRetention,
            ) ??
            false)) {
      add(
        ReasonCode.voiceLeadingStability,
        l10n.explanationReasonVoiceLeadingStabilityLabel,
        l10n.explanationReasonVoiceLeadingStabilityBody,
      );
    }

    if (exerciseFlavor == TrackExerciseFlavor.popHookLoop ||
        exerciseFlavor == TrackExerciseFlavor.popBorrowedLift ||
        melodyEvent != null) {
      add(
        ReasonCode.singableContour,
        l10n.explanationReasonSingableContourLabel,
        l10n.explanationReasonSingableContourBody,
      );
    }

    if (targetChord.chord.hasSlashBass ||
        exerciseFlavor == TrackExerciseFlavor.popBassMotion) {
      add(
        ReasonCode.slashBassLift,
        l10n.explanationReasonSlashBassLiftLabel,
        l10n.explanationReasonSlashBassLiftBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.turnaround) ||
        exerciseFlavor == TrackExerciseFlavor.jazzGuideTone ||
        exerciseFlavor == TrackExerciseFlavor.jazzShellVoicing ||
        exerciseFlavor == TrackExerciseFlavor.jazzRootlessVoicing ||
        exerciseFlavor == TrackExerciseFlavor.jazzBackdoorCadence ||
        exerciseFlavor == TrackExerciseFlavor.jazzDominantColor) {
      add(
        ReasonCode.turnaroundGravity,
        l10n.explanationReasonTurnaroundGravityLabel,
        l10n.explanationReasonTurnaroundGravityBody,
      );
    }

    if (exerciseFlavor == TrackExerciseFlavor.classicalInversion ||
        exerciseFlavor == TrackExerciseFlavor.classicalSecondaryDominant) {
      add(
        ReasonCode.inversionDiscipline,
        l10n.explanationReasonInversionDisciplineLabel,
        l10n.explanationReasonInversionDisciplineBody,
      );
    }

    if (targetChord.isAmbiguous ||
        targetChord.competingInterpretations.isNotEmpty ||
        targetChord.hasRemark(ProgressionRemarkKind.dualFunctionAmbiguity) ||
        targetChord.hasRemark(ProgressionRemarkKind.ambiguousInterpretation) ||
        targetChord.hasRemark(ProgressionRemarkKind.unresolved) ||
        analysis.ambiguity >= 0.34) {
      add(
        ReasonCode.ambiguityWindow,
        l10n.explanationReasonAmbiguityWindowLabel,
        l10n.explanationReasonAmbiguityWindowBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.chromaticLine) ||
        targetChord.hasRemark(ProgressionRemarkKind.lineClicheColor) ||
        targetChord.evidence.any(
          (evidence) => evidence.kind == ProgressionEvidenceKind.chromaticLine,
        )) {
      add(
        ReasonCode.chromaticLine,
        l10n.explanationReasonChromaticLineLabel,
        l10n.explanationReasonChromaticLineBody,
      );
    }

    return ordered.values.toList(growable: false);
  }

  List<ListeningHint> _listeningHints(
    AppLocalizations l10n, {
    required StudyHarmonyTrackId? trackId,
    required TrackExerciseFlavor? exerciseFlavor,
    required ProgressionAnalysis analysis,
    required AnalyzedChord targetChord,
  }) {
    final hints = <ListeningHint>[];

    void add(String title, String detail) {
      if (hints.any((hint) => hint.title == title && hint.detail == detail)) {
        return;
      }
      hints.add(ListeningHint(title: title, detail: detail));
    }

    if (analysis.tags.contains(ProgressionTagId.iiVI) ||
        exerciseFlavor == TrackExerciseFlavor.jazzGuideTone ||
        exerciseFlavor == TrackExerciseFlavor.jazzShellVoicing ||
        exerciseFlavor == TrackExerciseFlavor.jazzRootlessVoicing) {
      add(
        l10n.explanationListeningGuideToneTitle,
        l10n.explanationListeningGuideToneBody,
      );
    }

    if (targetChord.chord.hasAlteredColor ||
        targetChord.evidence.any(
          (evidence) =>
              evidence.kind == ProgressionEvidenceKind.alteredDominantColor,
        ) ||
        exerciseFlavor == TrackExerciseFlavor.jazzDominantColor) {
      add(
        l10n.explanationListeningDominantColorTitle,
        l10n.explanationListeningDominantColorBody,
      );
    }

    if (analysis.tags.contains(ProgressionTagId.backdoorChain) ||
        targetChord.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
        targetChord.hasRemark(ProgressionRemarkKind.subdominantMinor) ||
        targetChord.evidence.any(
          (evidence) => evidence.kind == ProgressionEvidenceKind.backdoorMotion,
        ) ||
        exerciseFlavor == TrackExerciseFlavor.jazzBackdoorCadence) {
      add(
        l10n.explanationListeningBackdoorTitle,
        l10n.explanationListeningBackdoorBody,
      );
    }

    if (targetChord.hasRemark(ProgressionRemarkKind.possibleModalInterchange) ||
        exerciseFlavor == TrackExerciseFlavor.popBorrowedLift) {
      add(
        l10n.explanationListeningBorrowedColorTitle,
        l10n.explanationListeningBorrowedColorBody,
      );
    }

    if (targetChord.chord.hasSlashBass ||
        exerciseFlavor == TrackExerciseFlavor.popBassMotion) {
      add(
        l10n.explanationListeningBassMotionTitle,
        l10n.explanationListeningBassMotionBody,
      );
    }

    if (trackId == 'classical' ||
        exerciseFlavor == TrackExerciseFlavor.classicalCadence) {
      add(
        l10n.explanationListeningCadenceTitle,
        l10n.explanationListeningCadenceBody,
      );
    }

    if (targetChord.isAmbiguous ||
        targetChord.competingInterpretations.isNotEmpty ||
        analysis.ambiguity >= 0.34) {
      add(
        l10n.explanationListeningAmbiguityTitle,
        l10n.explanationListeningAmbiguityBody,
      );
    }

    return hints.take(3).toList(growable: false);
  }

  List<PerformanceHint> _performanceHints(
    AppLocalizations l10n, {
    required StudyHarmonyTrackId? trackId,
    required TrackExerciseFlavor? exerciseFlavor,
    required ProgressionAnalysis analysis,
    required AnalyzedChord targetChord,
    required VoicingSuggestion? voicingSuggestion,
    required GeneratedMelodyEvent? melodyEvent,
  }) {
    final hints = <PerformanceHint>[];

    void add(String title, String detail) {
      if (hints.any((hint) => hint.title == title && hint.detail == detail)) {
        return;
      }
      hints.add(PerformanceHint(title: title, detail: detail));
    }

    if (exerciseFlavor == TrackExerciseFlavor.jazzShellVoicing) {
      add(
        l10n.explanationPerformanceJazzShellTitle,
        l10n.explanationPerformanceJazzShellBody,
      );
    } else if (exerciseFlavor == TrackExerciseFlavor.jazzRootlessVoicing) {
      add(
        l10n.explanationPerformanceJazzRootlessTitle,
        l10n.explanationPerformanceJazzRootlessBody,
      );
    }

    if (trackId == 'pop') {
      add(
        l10n.explanationPerformancePopTitle,
        l10n.explanationPerformancePopBody,
      );
    }
    if (trackId == 'jazz') {
      add(
        l10n.explanationPerformanceJazzTitle,
        l10n.explanationPerformanceJazzBody,
      );
    }
    if (trackId == 'classical') {
      add(
        l10n.explanationPerformanceClassicalTitle,
        l10n.explanationPerformanceClassicalBody,
      );
    }

    if (targetChord.chord.hasAlteredColor ||
        targetChord.evidence.any(
          (evidence) =>
              evidence.kind == ProgressionEvidenceKind.alteredDominantColor,
        ) ||
        targetChord.hasRemark(
          ProgressionRemarkKind.possibleTritoneSubstitute,
        ) ||
        targetChord.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
        analysis.tags.contains(ProgressionTagId.backdoorChain) ||
        exerciseFlavor == TrackExerciseFlavor.jazzDominantColor ||
        exerciseFlavor == TrackExerciseFlavor.jazzBackdoorCadence) {
      add(
        l10n.explanationPerformanceDominantColorTitle,
        l10n.explanationPerformanceDominantColorBody,
      );
    }

    if (targetChord.isAmbiguous ||
        targetChord.competingInterpretations.isNotEmpty ||
        analysis.ambiguity >= 0.34) {
      add(
        l10n.explanationPerformanceAmbiguityTitle,
        l10n.explanationPerformanceAmbiguityBody,
      );
    }
    if (voicingSuggestion != null &&
        voicingSuggestion.shortReasons.isNotEmpty &&
        hints.length < 3) {
      add(
        l10n.explanationPerformanceVoicingTitle,
        voicingSuggestion.shortReasons.take(2).join(', '),
      );
    }
    if (melodyEvent != null && hints.length < 3) {
      final structuralNotes = melodyEvent.notes.where(
        (note) => note.structural,
      );
      if (structuralNotes.isNotEmpty) {
        add(
          l10n.explanationPerformanceMelodyTitle,
          l10n.explanationPerformanceMelodyBody,
        );
      }
    }
    return hints.take(3).toList(growable: false);
  }
}
