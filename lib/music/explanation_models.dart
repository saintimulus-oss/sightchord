import 'package:flutter/foundation.dart';

enum ReasonCode {
  functionalResolution,
  guideToneSmoothness,
  borrowedColor,
  secondaryDominantPull,
  tritoneSubColor,
  dominantColor,
  backdoorMotion,
  cadentialStrength,
  voiceLeadingStability,
  singableContour,
  slashBassLift,
  turnaroundGravity,
  inversionDiscipline,
  ambiguityWindow,
  chromaticLine,
}

enum ConfidenceTone { strong, moderate, cautious }

@immutable
class ReasonTag {
  const ReasonTag({
    required this.code,
    required this.label,
    required this.detail,
  });

  final ReasonCode code;
  final String label;
  final String detail;
}

@immutable
class ListeningHint {
  const ListeningHint({required this.title, required this.detail});

  final String title;
  final String detail;
}

@immutable
class PerformanceHint {
  const PerformanceHint({required this.title, required this.detail});

  final String title;
  final String detail;
}

@immutable
class AlternativeInterpretation {
  const AlternativeInterpretation({
    required this.label,
    required this.detail,
    this.confidence,
  });

  final String label;
  final String detail;
  final double? confidence;
}

@immutable
class ConfidenceBadgeModel {
  const ConfidenceBadgeModel({
    required this.label,
    required this.value,
    required this.tone,
    this.caption,
  });

  final String label;
  final double value;
  final ConfidenceTone tone;
  final String? caption;
}

@immutable
class ExplanationBundle {
  const ExplanationBundle({
    required this.summary,
    this.trackContext,
    this.confidenceBadge,
    this.ambiguityValue,
    this.ambiguityCaption,
    this.caution,
    this.reasonTags = const <ReasonTag>[],
    this.listeningHints = const <ListeningHint>[],
    this.performanceHints = const <PerformanceHint>[],
    this.alternativeInterpretations = const <AlternativeInterpretation>[],
  });

  final String summary;
  final String? trackContext;
  final ConfidenceBadgeModel? confidenceBadge;
  final double? ambiguityValue;
  final String? ambiguityCaption;
  final String? caution;
  final List<ReasonTag> reasonTags;
  final List<ListeningHint> listeningHints;
  final List<PerformanceHint> performanceHints;
  final List<AlternativeInterpretation> alternativeInterpretations;

  bool get hasDetails =>
      trackContext != null ||
      confidenceBadge != null ||
      ambiguityValue != null ||
      ambiguityCaption != null ||
      caution != null ||
      reasonTags.isNotEmpty ||
      listeningHints.isNotEmpty ||
      performanceHints.isNotEmpty ||
      alternativeInterpretations.isNotEmpty;
}
