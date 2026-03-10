import '../settings/practice_settings.dart';
import 'chord_theory.dart';

enum VoicingFamily {
  shell,
  rootlessA,
  rootlessB,
  spread,
  sus,
  quartal,
  altered,
  upperStructure,
}

enum VoicingSuggestionKind { natural, colorful, easy }

enum VoicingTopNoteSource {
  explicitPreference,
  lockedContinuity,
  sameHarmonyCarry,
}

enum VoicingReasonTag {
  essentialCore,
  guideToneAnchor,
  guideToneResolution,
  commonToneRetention,
  stableRepeat,
  lowMudAvoided,
  compactReach,
  bassAnchor,
  nextChordReady,
  topLineTarget,
  alteredColor,
  rootlessClarity,
  susRelease,
  quartalColor,
  upperStructureColor,
  tritoneSubFlavor,
  lockedContinuity,
  gentleMotion,
}

class VoicingTone {
  const VoicingTone({
    required this.label,
    required this.semitone,
    this.priority = 0,
    this.qualityImplied = false,
  });

  final String label;
  final int semitone;
  final int priority;
  final bool qualityImplied;

  VoicingTone copyWith({
    String? label,
    int? semitone,
    int? priority,
    bool? qualityImplied,
  }) {
    return VoicingTone(
      label: label ?? this.label,
      semitone: semitone ?? this.semitone,
      priority: priority ?? this.priority,
      qualityImplied: qualityImplied ?? this.qualityImplied,
    );
  }
}

class ChordVoicingInterpretation {
  const ChordVoicingInterpretation({
    required this.root,
    required this.rootSemitone,
    required this.preferFlatSpelling,
    required this.essentialTones,
    required this.optionalTones,
    required this.avoidTones,
    required this.styleTags,
    this.bassAnchorLabel,
    this.bassAnchorSemitone,
    this.requiredAlteredToneCount = 0,
    this.isMajorFamily = false,
    this.isMinorFamily = false,
    this.isDominantFamily = false,
    this.isSusFamily = false,
    this.isAlteredFamily = false,
    this.isHalfDiminishedFamily = false,
    this.isTriadFamily = false,
    this.qualityImpliesColor = false,
  });

  final String root;
  final int rootSemitone;
  final bool preferFlatSpelling;
  final List<VoicingTone> essentialTones;
  final List<VoicingTone> optionalTones;
  final List<VoicingTone> avoidTones;
  final Set<String> styleTags;
  final String? bassAnchorLabel;
  final int? bassAnchorSemitone;
  final int requiredAlteredToneCount;
  final bool isMajorFamily;
  final bool isMinorFamily;
  final bool isDominantFamily;
  final bool isSusFamily;
  final bool isAlteredFamily;
  final bool isHalfDiminishedFamily;
  final bool isTriadFamily;
  final bool qualityImpliesColor;

  List<String> get essentialLabels => [
    for (final tone in essentialTones) tone.label,
  ];

  List<String> get optionalLabels => [
    for (final tone in optionalTones) tone.label,
  ];

  ChordVoicingInterpretation copyWith({
    String? root,
    int? rootSemitone,
    bool? preferFlatSpelling,
    List<VoicingTone>? essentialTones,
    List<VoicingTone>? optionalTones,
    List<VoicingTone>? avoidTones,
    Set<String>? styleTags,
    String? bassAnchorLabel,
    int? bassAnchorSemitone,
    int? requiredAlteredToneCount,
    bool? isMajorFamily,
    bool? isMinorFamily,
    bool? isDominantFamily,
    bool? isSusFamily,
    bool? isAlteredFamily,
    bool? isHalfDiminishedFamily,
    bool? isTriadFamily,
    bool? qualityImpliesColor,
  }) {
    return ChordVoicingInterpretation(
      root: root ?? this.root,
      rootSemitone: rootSemitone ?? this.rootSemitone,
      preferFlatSpelling: preferFlatSpelling ?? this.preferFlatSpelling,
      essentialTones: essentialTones ?? this.essentialTones,
      optionalTones: optionalTones ?? this.optionalTones,
      avoidTones: avoidTones ?? this.avoidTones,
      styleTags: styleTags ?? this.styleTags,
      bassAnchorLabel: bassAnchorLabel ?? this.bassAnchorLabel,
      bassAnchorSemitone: bassAnchorSemitone ?? this.bassAnchorSemitone,
      requiredAlteredToneCount:
          requiredAlteredToneCount ?? this.requiredAlteredToneCount,
      isMajorFamily: isMajorFamily ?? this.isMajorFamily,
      isMinorFamily: isMinorFamily ?? this.isMinorFamily,
      isDominantFamily: isDominantFamily ?? this.isDominantFamily,
      isSusFamily: isSusFamily ?? this.isSusFamily,
      isAlteredFamily: isAlteredFamily ?? this.isAlteredFamily,
      isHalfDiminishedFamily:
          isHalfDiminishedFamily ?? this.isHalfDiminishedFamily,
      isTriadFamily: isTriadFamily ?? this.isTriadFamily,
      qualityImpliesColor: qualityImpliesColor ?? this.qualityImpliesColor,
    );
  }
}

class ConcreteVoicing {
  const ConcreteVoicing({
    required this.midiNotes,
    required this.noteNames,
    required this.toneLabels,
    required this.tensions,
    required this.family,
    required this.topNote,
    required this.bassNote,
    required this.containsRoot,
    required this.containsThird,
    required this.containsSeventh,
    required this.signature,
  });

  final List<int> midiNotes;
  final List<String> noteNames;
  final List<String> toneLabels;
  final Set<String> tensions;
  final VoicingFamily family;
  final int topNote;
  final int bassNote;
  final bool containsRoot;
  final bool containsThird;
  final bool containsSeventh;
  final String signature;

  int get noteCount => midiNotes.length;
  bool get isRootless => !containsRoot;
  bool get hasGuideToneCore => containsThird && containsSeventh;
  int get topNotePitchClass => topNote % 12;
  String get topNoteName => noteNames.last;

  ConcreteVoicing copyWith({
    List<int>? midiNotes,
    List<String>? noteNames,
    List<String>? toneLabels,
    Set<String>? tensions,
    VoicingFamily? family,
    int? topNote,
    int? bassNote,
    bool? containsRoot,
    bool? containsThird,
    bool? containsSeventh,
    String? signature,
  }) {
    return ConcreteVoicing(
      midiNotes: midiNotes ?? this.midiNotes,
      noteNames: noteNames ?? this.noteNames,
      toneLabels: toneLabels ?? this.toneLabels,
      tensions: tensions ?? this.tensions,
      family: family ?? this.family,
      topNote: topNote ?? this.topNote,
      bassNote: bassNote ?? this.bassNote,
      containsRoot: containsRoot ?? this.containsRoot,
      containsThird: containsThird ?? this.containsThird,
      containsSeventh: containsSeventh ?? this.containsSeventh,
      signature: signature ?? this.signature,
    );
  }
}

class VoicingBreakdown {
  const VoicingBreakdown({
    required this.total,
    this.essentialCoverage = 0,
    this.bassAnchorBonus = 0,
    this.sameHarmonyStabilityBonus = 0,
    this.guideToneResolutionBonus = 0,
    this.commonToneRetentionBonus = 0,
    this.totalVoiceMotionPenalty = 0,
    this.outerVoiceLeapPenalty = 0,
    this.bassMovementPenalty = 0,
    this.lowRegisterMudPenalty = 0,
    this.pianoPlayabilityAdjustment = 0,
    this.handSpanPenalty = 0,
    this.sameRootSusReleaseBonus = 0,
    this.nextChordLookAheadBonus = 0,
    this.colorBonus = 0,
    this.simplicityBonus = 0,
    this.topNotePreferenceBonus = 0,
    this.lockContinuityBonus = 0,
    this.commonToneCount = 0,
    this.guideResolutionCount = 0,
    this.totalMotionSemitones = 0,
    this.handSpanSemitones = 0,
    this.alteredTensionCount = 0,
    this.bassAnchorMatched = false,
    this.essentialCoveredCount = 0,
    this.essentialRequiredCount = 0,
  });

  final double total;
  final double essentialCoverage;
  final double bassAnchorBonus;
  final double sameHarmonyStabilityBonus;
  final double guideToneResolutionBonus;
  final double commonToneRetentionBonus;
  final double totalVoiceMotionPenalty;
  final double outerVoiceLeapPenalty;
  final double bassMovementPenalty;
  final double lowRegisterMudPenalty;
  final double pianoPlayabilityAdjustment;
  final double handSpanPenalty;
  final double sameRootSusReleaseBonus;
  final double nextChordLookAheadBonus;
  final double colorBonus;
  final double simplicityBonus;
  final double topNotePreferenceBonus;
  final double lockContinuityBonus;
  final int commonToneCount;
  final int guideResolutionCount;
  final int totalMotionSemitones;
  final int handSpanSemitones;
  final int alteredTensionCount;
  final bool bassAnchorMatched;
  final int essentialCoveredCount;
  final int essentialRequiredCount;

  VoicingBreakdown copyWith({
    double? total,
    double? essentialCoverage,
    double? bassAnchorBonus,
    double? sameHarmonyStabilityBonus,
    double? guideToneResolutionBonus,
    double? commonToneRetentionBonus,
    double? totalVoiceMotionPenalty,
    double? outerVoiceLeapPenalty,
    double? bassMovementPenalty,
    double? lowRegisterMudPenalty,
    double? pianoPlayabilityAdjustment,
    double? handSpanPenalty,
    double? sameRootSusReleaseBonus,
    double? nextChordLookAheadBonus,
    double? colorBonus,
    double? simplicityBonus,
    double? topNotePreferenceBonus,
    double? lockContinuityBonus,
    int? commonToneCount,
    int? guideResolutionCount,
    int? totalMotionSemitones,
    int? handSpanSemitones,
    int? alteredTensionCount,
    bool? bassAnchorMatched,
    int? essentialCoveredCount,
    int? essentialRequiredCount,
  }) {
    return VoicingBreakdown(
      total: total ?? this.total,
      essentialCoverage: essentialCoverage ?? this.essentialCoverage,
      bassAnchorBonus: bassAnchorBonus ?? this.bassAnchorBonus,
      sameHarmonyStabilityBonus:
          sameHarmonyStabilityBonus ?? this.sameHarmonyStabilityBonus,
      guideToneResolutionBonus:
          guideToneResolutionBonus ?? this.guideToneResolutionBonus,
      commonToneRetentionBonus:
          commonToneRetentionBonus ?? this.commonToneRetentionBonus,
      totalVoiceMotionPenalty:
          totalVoiceMotionPenalty ?? this.totalVoiceMotionPenalty,
      outerVoiceLeapPenalty:
          outerVoiceLeapPenalty ?? this.outerVoiceLeapPenalty,
      bassMovementPenalty: bassMovementPenalty ?? this.bassMovementPenalty,
      lowRegisterMudPenalty:
          lowRegisterMudPenalty ?? this.lowRegisterMudPenalty,
      pianoPlayabilityAdjustment:
          pianoPlayabilityAdjustment ?? this.pianoPlayabilityAdjustment,
      handSpanPenalty: handSpanPenalty ?? this.handSpanPenalty,
      sameRootSusReleaseBonus:
          sameRootSusReleaseBonus ?? this.sameRootSusReleaseBonus,
      nextChordLookAheadBonus:
          nextChordLookAheadBonus ?? this.nextChordLookAheadBonus,
      colorBonus: colorBonus ?? this.colorBonus,
      simplicityBonus: simplicityBonus ?? this.simplicityBonus,
      topNotePreferenceBonus:
          topNotePreferenceBonus ?? this.topNotePreferenceBonus,
      lockContinuityBonus: lockContinuityBonus ?? this.lockContinuityBonus,
      commonToneCount: commonToneCount ?? this.commonToneCount,
      guideResolutionCount: guideResolutionCount ?? this.guideResolutionCount,
      totalMotionSemitones: totalMotionSemitones ?? this.totalMotionSemitones,
      handSpanSemitones: handSpanSemitones ?? this.handSpanSemitones,
      alteredTensionCount: alteredTensionCount ?? this.alteredTensionCount,
      bassAnchorMatched: bassAnchorMatched ?? this.bassAnchorMatched,
      essentialCoveredCount:
          essentialCoveredCount ?? this.essentialCoveredCount,
      essentialRequiredCount:
          essentialRequiredCount ?? this.essentialRequiredCount,
    );
  }

  String describe() {
    return 'score=${total.toStringAsFixed(2)} '
        'essential=${essentialCoverage.toStringAsFixed(2)} '
        'repeat=${sameHarmonyStabilityBonus.toStringAsFixed(2)} '
        'guide=${guideToneResolutionBonus.toStringAsFixed(2)} '
        'common=${commonToneRetentionBonus.toStringAsFixed(2)} '
        'motion=${totalVoiceMotionPenalty.toStringAsFixed(2)} '
        'play=${pianoPlayabilityAdjustment.toStringAsFixed(2)} '
        'top=${topNotePreferenceBonus.toStringAsFixed(2)} '
        'lookAhead=${nextChordLookAheadBonus.toStringAsFixed(2)} '
        'mud=${lowRegisterMudPenalty.toStringAsFixed(2)}';
  }
}

class RankedVoicingCandidate {
  const RankedVoicingCandidate({
    required this.voicing,
    required this.breakdown,
    required this.naturalScore,
    required this.colorfulScore,
    required this.easyScore,
    this.reasonTags = const [],
  });

  final ConcreteVoicing voicing;
  final VoicingBreakdown breakdown;
  final double naturalScore;
  final double colorfulScore;
  final double easyScore;
  final List<VoicingReasonTag> reasonTags;

  RankedVoicingCandidate copyWith({
    ConcreteVoicing? voicing,
    VoicingBreakdown? breakdown,
    double? naturalScore,
    double? colorfulScore,
    double? easyScore,
    List<VoicingReasonTag>? reasonTags,
  }) {
    return RankedVoicingCandidate(
      voicing: voicing ?? this.voicing,
      breakdown: breakdown ?? this.breakdown,
      naturalScore: naturalScore ?? this.naturalScore,
      colorfulScore: colorfulScore ?? this.colorfulScore,
      easyScore: easyScore ?? this.easyScore,
      reasonTags: reasonTags ?? this.reasonTags,
    );
  }
}

class VoicingSuggestion {
  const VoicingSuggestion({
    required this.kind,
    required this.label,
    required this.shortReasons,
    required this.score,
    required this.voicing,
    required this.breakdown,
    this.reasonTags = const [],
    this.locked = false,
  });

  final VoicingSuggestionKind kind;
  final String label;
  final List<String> shortReasons;
  final double score;
  final ConcreteVoicing voicing;
  final VoicingBreakdown breakdown;
  final List<VoicingReasonTag> reasonTags;
  final bool locked;

  VoicingSuggestion copyWith({
    VoicingSuggestionKind? kind,
    String? label,
    List<String>? shortReasons,
    double? score,
    ConcreteVoicing? voicing,
    VoicingBreakdown? breakdown,
    List<VoicingReasonTag>? reasonTags,
    bool? locked,
  }) {
    return VoicingSuggestion(
      kind: kind ?? this.kind,
      label: label ?? this.label,
      shortReasons: shortReasons ?? this.shortReasons,
      score: score ?? this.score,
      voicing: voicing ?? this.voicing,
      breakdown: breakdown ?? this.breakdown,
      reasonTags: reasonTags ?? this.reasonTags,
      locked: locked ?? this.locked,
    );
  }
}

class VoicingContext {
  const VoicingContext({
    required this.currentChord,
    required this.settings,
    this.previousChord,
    this.nextChord,
    this.futureChords = const [],
    this.previousVoicing,
    this.lockedVoicing,
    this.preferredTopNotePitchClass,
    this.lookAheadDepth = 1,
  });

  final GeneratedChord currentChord;
  final PracticeSettings settings;
  final GeneratedChord? previousChord;
  final GeneratedChord? nextChord;
  final List<GeneratedChord> futureChords;
  final ConcreteVoicing? previousVoicing;
  final ConcreteVoicing? lockedVoicing;
  final int? preferredTopNotePitchClass;
  final int lookAheadDepth;

  ConcreteVoicing? get continuityReferenceVoicing => previousVoicing;

  ConcreteVoicing? get lockContinuityReference => lockedVoicing;

  bool get hasLockedContinuity => lockedVoicing != null;

  bool get hasPreviousChosenVoicing => previousVoicing != null;

  GeneratedChord? get nextLookAheadChord =>
      orderedFutureChords.isEmpty ? null : orderedFutureChords.first;

  GeneratedChord? get nextNextLookAheadChord =>
      orderedFutureChords.length < 2 ? null : orderedFutureChords[1];

  int get effectiveLookAheadDepth => orderedFutureChords.length < lookAheadDepth
      ? orderedFutureChords.length
      : lookAheadDepth;

  List<GeneratedChord> get lookAheadChords =>
      orderedFutureChords.take(effectiveLookAheadDepth).toList(growable: false);

  bool get hasProgressionContext =>
      previousChord != null || orderedFutureChords.isNotEmpty;

  bool get isFreeModeFallback =>
      !settings.usesKeyMode &&
      previousChord == null &&
      orderedFutureChords.isEmpty;

  List<GeneratedChord> get orderedFutureChords => [
    ?nextChord,
    for (final chord in futureChords)
      if (nextChord == null ||
          chord.harmonicComparisonKey != nextChord!.harmonicComparisonKey)
        chord,
  ];

  String get diagnosticSummary {
    final progressionMode = switch (effectiveLookAheadDepth) {
      0 => 'local',
      1 => 'depth1',
      _ => 'depth2',
    };
    final lockedLabel = hasLockedContinuity ? 'locked' : 'open';
    final fallbackLabel = isFreeModeFallback ? 'free' : 'progression';
    return '$progressionMode/$lockedLabel/$fallbackLabel';
  }

  VoicingContext copyWith({
    GeneratedChord? currentChord,
    PracticeSettings? settings,
    GeneratedChord? previousChord,
    GeneratedChord? nextChord,
    List<GeneratedChord>? futureChords,
    ConcreteVoicing? previousVoicing,
    ConcreteVoicing? lockedVoicing,
    int? preferredTopNotePitchClass,
    int? lookAheadDepth,
  }) {
    return VoicingContext(
      currentChord: currentChord ?? this.currentChord,
      settings: settings ?? this.settings,
      previousChord: previousChord ?? this.previousChord,
      nextChord: nextChord ?? this.nextChord,
      futureChords: futureChords ?? this.futureChords,
      previousVoicing: previousVoicing ?? this.previousVoicing,
      lockedVoicing: lockedVoicing ?? this.lockedVoicing,
      preferredTopNotePitchClass:
          preferredTopNotePitchClass ?? this.preferredTopNotePitchClass,
      lookAheadDepth: lookAheadDepth ?? this.lookAheadDepth,
    );
  }
}

class VoicingRecommendationSet {
  const VoicingRecommendationSet({
    required this.currentChord,
    required this.interpretation,
    required this.rankedCandidates,
    required this.suggestions,
    this.effectiveTopNotePitchClass,
    this.topNoteSource,
  });

  final GeneratedChord currentChord;
  final ChordVoicingInterpretation interpretation;
  final List<RankedVoicingCandidate> rankedCandidates;
  final List<VoicingSuggestion> suggestions;
  final int? effectiveTopNotePitchClass;
  final VoicingTopNoteSource? topNoteSource;

  VoicingSuggestion? suggestionFor(VoicingSuggestionKind kind) {
    for (final suggestion in suggestions) {
      if (suggestion.kind == kind) {
        return suggestion;
      }
    }
    return null;
  }

  RankedVoicingCandidate? candidateBySignature(String signature) {
    for (final candidate in rankedCandidates) {
      if (candidate.voicing.signature == signature) {
        return candidate;
      }
    }
    return null;
  }
}
