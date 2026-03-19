import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../music/chord_formatting.dart';
import '../../music/chord_theory.dart';
import '../../music/progression_analysis_models.dart';
import '../../music/progression_analyzer.dart';
import '../../settings/inversion_settings.dart';
import '../../settings/practice_settings.dart';
import '../../smart_generator.dart';
import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_track_profiles.dart';

typedef StudyHarmonyProgressionCandidateFactory =
    StudyHarmonyGeneratedProgressionCandidate Function({
      required Random random,
      required int minLength,
      required int maxLength,
      required bool allowNonDiatonic,
    });

typedef StudyHarmonyProgressionAcceptance =
    bool Function(StudyHarmonyGeneratedProgression progression);

@immutable
class StudyHarmonyGeneratedProgressionCandidate {
  const StudyHarmonyGeneratedProgressionCandidate({
    required this.input,
    required this.chordSymbols,
    this.generatedChords = const <GeneratedChord>[],
  });

  final String input;
  final List<String> chordSymbols;
  final List<GeneratedChord> generatedChords;
}

@immutable
class StudyHarmonyGeneratedProgression {
  const StudyHarmonyGeneratedProgression({
    required this.input,
    required this.chordSymbols,
    required this.generatedChords,
    required this.analysis,
    required this.attemptCount,
  });

  final String input;
  final List<String> chordSymbols;
  final List<GeneratedChord> generatedChords;
  final ProgressionAnalysis analysis;
  final int attemptCount;

  List<AnalyzedChord> get nonDiatonicAnalyses => [
    for (final chord in analysis.chordAnalyses)
      if (chord.isNonDiatonic) chord,
  ];
}

class StudyHarmonyGeneratorAdapter {
  StudyHarmonyGeneratorAdapter({
    ProgressionAnalyzer? analyzer,
    StudyHarmonyProgressionCandidateFactory? candidateFactory,
    this.maxAttempts = 12,
    this.minimumConfidence = 0.72,
    this.maximumAmbiguity = 0.34,
    this.minimumChordConfidence = 0.46,
  }) : _analyzer = analyzer ?? const ProgressionAnalyzer(),
       _candidateFactory = candidateFactory;

  final ProgressionAnalyzer _analyzer;
  final StudyHarmonyProgressionCandidateFactory? _candidateFactory;
  final int maxAttempts;
  final double minimumConfidence;
  final double maximumAmbiguity;
  final double minimumChordConfidence;

  static final List<KeyCenter> _commonCoreCenters = <KeyCenter>[
    for (final tonic in const ['C', 'G', 'D', 'F', 'A'])
      MusicTheory.keyCenterFor(tonic),
  ];

  static const Set<ChordQuality> _allowedRenderQualities = <ChordQuality>{
    ChordQuality.majorTriad,
    ChordQuality.minorTriad,
    ChordQuality.major7,
    ChordQuality.minor7,
    ChordQuality.dominant7,
    ChordQuality.halfDiminished7,
    ChordQuality.diminishedTriad,
  };

  StudyHarmonyGeneratedProgression generateCommonProgression({
    required Random random,
    int minLength = 3,
    int maxLength = 5,
    bool allowNonDiatonic = false,
    bool requireSingleNonDiatonic = false,
    StudyHarmonyProgressionAcceptance? extraAcceptance,
  }) {
    final candidateFactory = _candidateFactory ?? _buildCandidate;

    for (var attempt = 1; attempt <= maxAttempts; attempt += 1) {
      final candidate = candidateFactory(
        random: random,
        minLength: minLength,
        maxLength: maxLength,
        allowNonDiatonic: allowNonDiatonic,
      );
      final progression = _tryAnalyzeCandidate(
        candidate,
        attemptCount: attempt,
      );
      if (progression == null) {
        continue;
      }
      if (_acceptProgression(
        progression,
        allowNonDiatonic: allowNonDiatonic,
        requireSingleNonDiatonic: requireSingleNonDiatonic,
        extraAcceptance: extraAcceptance,
      )) {
        return progression;
      }
    }

    var fallbackAttempt = maxAttempts;
    for (final fallback in _fallbackCandidates(allowNonDiatonic)) {
      fallbackAttempt += 1;
      final progression = _tryAnalyzeCandidate(
        fallback,
        attemptCount: fallbackAttempt,
      );
      if (progression == null) {
        continue;
      }
      if (_acceptProgression(
        progression,
        allowNonDiatonic: allowNonDiatonic,
        requireSingleNonDiatonic: requireSingleNonDiatonic,
        extraAcceptance: extraAcceptance,
      )) {
        return progression;
      }
    }

    throw StateError('Unable to generate a clear Study Harmony progression.');
  }

  StudyHarmonyGeneratedProgression generateProgressionForProfile({
    required Random random,
    required TrackGenerationProfile profile,
    int? minLengthOverride,
    int? maxLengthOverride,
    bool? allowNonDiatonicOverride,
    bool requireSingleNonDiatonicOverride = false,
    StudyHarmonyProgressionAcceptance? extraAcceptance,
  }) {
    final allowNonDiatonic =
        allowNonDiatonicOverride ?? profile.allowNonDiatonic;
    final requireSingleNonDiatonic =
        requireSingleNonDiatonicOverride || profile.requireSingleNonDiatonic;
    final minLength = minLengthOverride ?? profile.minLength;
    final maxLength = maxLengthOverride ?? profile.maxLength;

    for (var attempt = 1; attempt <= maxAttempts; attempt += 1) {
      final candidate = _buildCandidateForProfile(
        random: random,
        minLength: minLength,
        maxLength: maxLength,
        profile: profile,
      );
      final progression = _tryAnalyzeCandidate(
        candidate,
        attemptCount: attempt,
      );
      if (progression == null) {
        continue;
      }
      if (_acceptProgression(
        progression,
        allowNonDiatonic: allowNonDiatonic,
        requireSingleNonDiatonic: requireSingleNonDiatonic,
        extraAcceptance: (candidate) =>
            _acceptProgressionForProfile(candidate, profile) &&
            (extraAcceptance?.call(candidate) ?? true),
      )) {
        return progression;
      }
    }

    var fallbackAttempt = maxAttempts;
    for (final fallback in _profileFallbackCandidates(profile)) {
      fallbackAttempt += 1;
      final progression = _tryAnalyzeCandidate(
        fallback,
        attemptCount: fallbackAttempt,
      );
      if (progression == null) {
        continue;
      }
      if (_acceptProgression(
        progression,
        allowNonDiatonic: allowNonDiatonic,
        requireSingleNonDiatonic: requireSingleNonDiatonic,
        extraAcceptance: (candidate) =>
            _acceptProgressionForProfile(candidate, profile) &&
            (extraAcceptance?.call(candidate) ?? true),
      )) {
        return progression;
      }
    }

    return generateCommonProgression(
      random: random,
      minLength: minLength,
      maxLength: maxLength,
      allowNonDiatonic: allowNonDiatonic,
      requireSingleNonDiatonic: requireSingleNonDiatonic,
      extraAcceptance: (candidate) =>
          _acceptProgressionForProfile(candidate, profile) &&
          (extraAcceptance?.call(candidate) ?? true),
    );
  }

  bool _acceptProgressionForProfile(
    StudyHarmonyGeneratedProgression progression,
    TrackGenerationProfile profile,
  ) {
    final analyses = progression.analysis.chordAnalyses;
    final symbols = progression.chordSymbols;
    final nonDiatonicAnalyses = progression.nonDiatonicAnalyses;
    final hasSlashBass = analyses.any(
      (analysis) => analysis.chord.hasSlashBass,
    );
    final hasHalfDiminished = analyses.any(
      (analysis) =>
          analysis.chord.displayQuality == ChordQuality.halfDiminished7,
    );
    final hasTurnaround = progression.analysis.tags.contains(
      ProgressionTagId.turnaround,
    );
    final hasIiVI = progression.analysis.tags.contains(ProgressionTagId.iiVI);
    final hasCadentialPull =
        progression.analysis.tags.contains(
          ProgressionTagId.dominantResolution,
        ) ||
        hasIiVI;
    final hasBorrowedColor = analyses.any(
      (analysis) =>
          analysis.hasRemark(ProgressionRemarkKind.possibleModalInterchange) ||
          analysis.hasRemark(ProgressionRemarkKind.subdominantMinor),
    );
    final hasSecondaryDominant = analyses.any(
      (analysis) =>
          analysis.sourceKind == ChordSourceKind.secondaryDominant ||
          analysis.hasRemark(ProgressionRemarkKind.possibleSecondaryDominant),
    );
    final hasSubstituteDominant = analyses.any(
      (analysis) =>
          analysis.sourceKind == ChordSourceKind.substituteDominant ||
          analysis.hasRemark(ProgressionRemarkKind.possibleTritoneSubstitute),
    );
    final hasBackdoorCadence =
        progression.analysis.tags.contains(ProgressionTagId.backdoorChain) ||
        analyses.any(
          (analysis) =>
              analysis.hasRemark(ProgressionRemarkKind.backdoorDominant) ||
              analysis.hasRemark(ProgressionRemarkKind.backdoorChain),
        );
    final hasSuspension = analyses.any(
      (analysis) => analysis.chord.suspensions.isNotEmpty,
    );
    final hasRichExtensions = analyses.any(
      (analysis) =>
          analysis.chord.tensions.isNotEmpty ||
          analysis.chord.addedTones.isNotEmpty ||
          analysis.chord.alterations.isNotEmpty,
    );
    final hasDominantTensionColor = analyses.any(
      (analysis) =>
          (analysis.harmonicFunction == ProgressionHarmonicFunction.dominant ||
              analysis.sourceKind == ChordSourceKind.secondaryDominant ||
              analysis.sourceKind == ChordSourceKind.substituteDominant) &&
          (analysis.chord.tensions.isNotEmpty ||
              analysis.chord.addedTones.isNotEmpty ||
              analysis.chord.alterations.isNotEmpty),
    );
    final hasDominantColor =
        hasSubstituteDominant || hasSuspension || hasDominantTensionColor;
    final startsAndEndsOnSameRoot =
        analyses.length >= 2 &&
        analyses.first.chord.root == analyses.last.chord.root;
    final hasReharmColor = hasSubstituteDominant || hasBackdoorCadence;
    final primaryMode = progression.analysis.primaryKey.keyCenter.mode;

    if (profile.exerciseFlavor == TrackExerciseFlavor.coreFunctional) {
      return nonDiatonicAnalyses.isEmpty && hasCadentialPull;
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.popHookLoop) {
      return nonDiatonicAnalyses.isEmpty &&
          !_containsAdvancedJazzSurface(symbols) &&
          !_containsRepeatedRootLoop(symbols);
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.popBorrowedLift) {
      return nonDiatonicAnalyses.length == 1 &&
          hasBorrowedColor &&
          !_containsAdvancedJazzSurface(symbols);
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.popBassMotion) {
      return hasSlashBass && nonDiatonicAnalyses.isEmpty;
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzGuideTone) {
      return hasIiVI &&
          primaryMode == KeyMode.major &&
          nonDiatonicAnalyses.isEmpty &&
          !hasTurnaround &&
          !hasDominantColor &&
          !_containsAdvancedJazzSurface(symbols, allowSuspensions: true);
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzShellVoicing) {
      return hasCadentialPull &&
          primaryMode == KeyMode.major &&
          nonDiatonicAnalyses.isEmpty &&
          !hasHalfDiminished &&
          !hasDominantColor &&
          !_containsAdvancedJazzSurface(symbols, allowSuspensions: true);
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzMinorCadence) {
      return hasHalfDiminished &&
          hasCadentialPull &&
          primaryMode == KeyMode.minor &&
          !hasSubstituteDominant &&
          !hasBackdoorCadence;
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzRootlessVoicing) {
      return hasCadentialPull &&
          primaryMode == KeyMode.major &&
          nonDiatonicAnalyses.isEmpty &&
          hasRichExtensions &&
          !hasHalfDiminished &&
          !hasReharmColor &&
          !_containsAdvancedJazzSurface(
            symbols,
            allowSuspensions: true,
            allowThirteen: true,
          );
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzDominantColor) {
      return nonDiatonicAnalyses.isNotEmpty &&
          (hasSuspension || hasDominantTensionColor || hasSecondaryDominant) &&
          !hasReharmColor;
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.jazzBackdoorCadence) {
      return nonDiatonicAnalyses.isNotEmpty &&
          (hasCadentialPull || hasBackdoorCadence) &&
          hasReharmColor;
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.classicalCadence) {
      return nonDiatonicAnalyses.isEmpty &&
          startsAndEndsOnSameRoot &&
          !_containsAdvancedJazzSurface(symbols, allowSlashBass: true);
    }
    if (profile.exerciseFlavor == TrackExerciseFlavor.classicalInversion) {
      return hasSlashBass && nonDiatonicAnalyses.isEmpty;
    }
    if (profile.exerciseFlavor ==
        TrackExerciseFlavor.classicalSecondaryDominant) {
      return hasSecondaryDominant &&
          nonDiatonicAnalyses.length == 1 &&
          !hasSubstituteDominant &&
          !_containsAdvancedJazzSurface(symbols, allowSlashBass: true);
    }
    return true;
  }

  bool _containsAdvancedJazzSurface(
    List<String> symbols, {
    bool allowSuspensions = false,
    bool allowSlashBass = false,
    bool allowThirteen = false,
  }) {
    for (final symbol in symbols) {
      final lower = symbol.toLowerCase();
      if (!allowSlashBass && symbol.contains('/')) {
        return true;
      }
      if (lower.contains('alt') ||
          lower.contains('m7b5') ||
          lower.contains('ø') ||
          lower.contains('#11') ||
          lower.contains('b9') ||
          lower.contains('#9') ||
          lower.contains('b13') ||
          (!allowThirteen && lower.contains('13'))) {
        return true;
      }
      if (!allowSuspensions && lower.contains('sus')) {
        return true;
      }
    }
    return false;
  }

  bool _containsRepeatedRootLoop(List<String> symbols) {
    final roots = <String>{
      for (final symbol in symbols)
        symbol.split('/').first.replaceAll(RegExp(r'[^A-Gb#]'), ''),
    };
    return roots.length <= 2;
  }

  StudyHarmonyGeneratedProgression _analyzeCandidate(
    StudyHarmonyGeneratedProgressionCandidate candidate, {
    required int attemptCount,
  }) {
    final analysis = _analyzer.analyze(candidate.input);
    return StudyHarmonyGeneratedProgression(
      input: candidate.input,
      chordSymbols: candidate.chordSymbols,
      generatedChords: candidate.generatedChords,
      analysis: analysis,
      attemptCount: attemptCount,
    );
  }

  StudyHarmonyGeneratedProgression? _tryAnalyzeCandidate(
    StudyHarmonyGeneratedProgressionCandidate candidate, {
    required int attemptCount,
  }) {
    try {
      return _analyzeCandidate(candidate, attemptCount: attemptCount);
    } on ProgressionAnalysisException {
      return null;
    }
  }

  bool _acceptProgression(
    StudyHarmonyGeneratedProgression progression, {
    required bool allowNonDiatonic,
    required bool requireSingleNonDiatonic,
    required StudyHarmonyProgressionAcceptance? extraAcceptance,
  }) {
    final analysis = progression.analysis;
    if (analysis.parseResult.issues.isNotEmpty) {
      return false;
    }
    if (analysis.confidence < minimumConfidence ||
        analysis.ambiguity > maximumAmbiguity) {
      return false;
    }
    if (analysis.chordAnalyses.any(
      (analysis) => analysis.confidence < minimumChordConfidence,
    )) {
      return false;
    }

    final nonDiatonicCount = progression.nonDiatonicAnalyses.length;
    if (!allowNonDiatonic && nonDiatonicCount > 0) {
      return false;
    }
    if (requireSingleNonDiatonic && nonDiatonicCount != 1) {
      return false;
    }

    if (!_areChordSymbolsUniqueEnough(progression.chordSymbols)) {
      return false;
    }

    final generatedChords = progression.generatedChords;
    if (generatedChords.isNotEmpty) {
      if (generatedChords.any(
        (chord) =>
            !_allowedRenderQualities.contains(chord.symbolData.renderQuality),
      )) {
        return false;
      }
      if (generatedChords.any(
        (chord) => chord.modulationKind == ModulationKind.real,
      )) {
        return false;
      }
      final firstCenter = generatedChords.first.keyCenter;
      if (firstCenter != null &&
          generatedChords.any(
            (chord) =>
                chord.keyCenter?.tonicName != firstCenter.tonicName ||
                chord.keyCenter?.mode != firstCenter.mode,
          )) {
        return false;
      }
    }

    if (extraAcceptance != null && !extraAcceptance(progression)) {
      return false;
    }
    return true;
  }

  bool _areChordSymbolsUniqueEnough(List<String> chordSymbols) {
    if (chordSymbols.length <= 1) {
      return false;
    }
    for (var index = 1; index < chordSymbols.length; index += 1) {
      if (chordSymbols[index] == chordSymbols[index - 1]) {
        return false;
      }
    }
    return chordSymbols.toSet().length >= chordSymbols.length - 1;
  }

  StudyHarmonyGeneratedProgressionCandidate _buildCandidate({
    required Random random,
    required int minLength,
    required int maxLength,
    required bool allowNonDiatonic,
  }) {
    final request = SmartStartRequest(
      activeKeys: [for (final center in _commonCoreCenters) center.tonicName],
      selectedKeyCenters: _commonCoreCenters,
      secondaryDominantEnabled: allowNonDiatonic,
      substituteDominantEnabled: false,
      modalInterchangeEnabled: false,
      modulationIntensity: ModulationIntensity.off,
      jazzPreset: JazzPreset.standardsCore,
      sourceProfile: SourceProfile.fakebookStandard,
      allowV7sus4: false,
      allowTensions: false,
      chordLanguageLevel: ChordLanguageLevel.seventhChords,
      romanPoolPreset: allowNonDiatonic
          ? RomanPoolPreset.functionalJazz
          : RomanPoolPreset.coreDiatonic,
      selectedTensionOptions: const <String>{},
      inversionSettings: const InversionSettings(),
      smartDiagnosticsEnabled: false,
    );
    return _buildCandidateFromRequest(
      random: random,
      minLength: minLength,
      maxLength: maxLength,
      request: request,
    );
  }

  StudyHarmonyGeneratedProgressionCandidate _buildCandidateForProfile({
    required Random random,
    required int minLength,
    required int maxLength,
    required TrackGenerationProfile profile,
  }) {
    if (profile.preferredCandidateInputs.isNotEmpty &&
        random.nextDouble() < 0.42) {
      final input =
          profile.preferredCandidateInputs[random.nextInt(
            profile.preferredCandidateInputs.length,
          )];
      return StudyHarmonyGeneratedProgressionCandidate(
        input: input,
        chordSymbols: input.split(' | '),
      );
    }

    final keyCenters = profile.keyCenters.isEmpty
        ? _commonCoreCenters
        : profile.keyCenters;
    final request = SmartStartRequest(
      activeKeys: [for (final center in keyCenters) center.tonicName],
      selectedKeyCenters: keyCenters,
      secondaryDominantEnabled: profile.allowSecondaryDominant,
      substituteDominantEnabled: profile.allowSubstituteDominant,
      modalInterchangeEnabled: profile.allowModalInterchange,
      modulationIntensity: profile.modulationIntensity,
      jazzPreset: profile.jazzPreset,
      sourceProfile: profile.sourceProfile,
      allowV7sus4: profile.allowV7sus4,
      allowTensions: profile.allowTensions,
      chordLanguageLevel: profile.chordLanguageLevel,
      romanPoolPreset: profile.romanPoolPreset,
      selectedTensionOptions: profile.selectedTensionOptions,
      inversionSettings: const InversionSettings(),
      smartDiagnosticsEnabled: false,
    );
    return _buildCandidateFromRequest(
      random: random,
      minLength: minLength,
      maxLength: maxLength,
      request: request,
    );
  }

  StudyHarmonyGeneratedProgressionCandidate _buildCandidateFromRequest({
    required Random random,
    required int minLength,
    required int maxLength,
    required SmartStartRequest request,
  }) {
    final targetLength = minLength == maxLength
        ? minLength
        : minLength + random.nextInt((maxLength - minLength) + 1);

    final generatedChords = <GeneratedChord>[];
    var previousChord = null as GeneratedChord?;
    var currentChord = null as GeneratedChord?;
    var plannedQueue = const <QueuedSmartChord>[];

    for (var step = 0; step < targetLength; step += 1) {
      final plan = currentChord == null
          ? SmartGeneratorHelper.planInitialStep(
              random: random,
              request: request,
            )
          : SmartGeneratorHelper.planNextStep(
              random: random,
              request: SmartStepRequest(
                stepIndex: step,
                activeKeys: request.activeKeys,
                selectedKeyCenters: request.selectedKeyCenters,
                currentKeyCenter:
                    currentChord.keyCenter ??
                    MusicTheory.keyCenterFor(currentChord.keyName ?? 'C'),
                currentRomanNumeralId:
                    currentChord.romanNumeralId ?? RomanNumeralId.iMaj7,
                currentResolutionRomanNumeralId:
                    SmartGeneratorHelper.continuationResolutionRomanNumeralId(
                      currentChord,
                    ),
                currentHarmonicFunction: currentChord.harmonicFunction,
                secondaryDominantEnabled: request.secondaryDominantEnabled,
                substituteDominantEnabled: request.substituteDominantEnabled,
                modalInterchangeEnabled: request.modalInterchangeEnabled,
                modulationIntensity: request.modulationIntensity,
                jazzPreset: request.jazzPreset,
                sourceProfile: request.sourceProfile,
                allowV7sus4: request.allowV7sus4,
                allowTensions: request.allowTensions,
                chordLanguageLevel: request.chordLanguageLevel,
                romanPoolPreset: request.romanPoolPreset,
                selectedTensionOptions: request.selectedTensionOptions,
                inversionSettings: request.inversionSettings,
                smartDiagnosticsEnabled: request.smartDiagnosticsEnabled,
                previousRomanNumeralId: previousChord?.romanNumeralId,
                previousHarmonicFunction: previousChord?.harmonicFunction,
                previousWasAppliedDominant:
                    previousChord?.isAppliedDominant ?? false,
                currentPatternTag: currentChord.patternTag,
                plannedQueue: plannedQueue,
                currentRenderedNonDiatonic: currentChord.isRenderedNonDiatonic,
                currentTrace: currentChord.smartDebug as SmartDecisionTrace?,
                phraseContext: SmartPhraseContext.rollingForm(step),
              ),
            );

      plannedQueue = plan.remainingQueuedChords;
      final nextChord = _renderChordFromPlan(
        random: random,
        plan: plan,
        previousChord: currentChord,
        chordLanguageLevel: request.chordLanguageLevel,
      );
      generatedChords.add(nextChord);
      previousChord = currentChord;
      currentChord = nextChord;
    }

    final chordSymbols = [
      for (final chord in generatedChords)
        ChordRenderingHelper.renderedSymbol(chord, ChordSymbolStyle.majText),
    ];
    return StudyHarmonyGeneratedProgressionCandidate(
      input: chordSymbols.join(' | '),
      chordSymbols: chordSymbols,
      generatedChords: generatedChords,
    );
  }

  GeneratedChord _renderChordFromPlan({
    required Random random,
    required SmartStepPlan plan,
    required GeneratedChord? previousChord,
    required ChordLanguageLevel chordLanguageLevel,
  }) {
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: random,
      previousChord: previousChord,
      allowV7sus4: false,
      allowTensions: false,
      chordLanguageLevel: chordLanguageLevel,
      selectedTensionOptions: const <String>{},
      inversionSettings: const InversionSettings(),
      debugChordStyle: ChordSymbolStyle.majText,
      candidates: [
        SmartRenderCandidate(
          keyCenter: plan.finalKeyCenter,
          romanNumeralId: plan.finalRomanNumeralId,
          plannedChordKind: plan.plannedChordKind,
          renderQualityOverride: plan.renderingPlan.renderQualityOverride,
          patternTag: plan.patternTag,
          appliedType: plan.appliedType,
          resolutionTargetRomanId: plan.resolutionTargetRomanId,
          dominantContext: plan.renderingPlan.dominantContext,
          dominantIntent: plan.renderingPlan.dominantIntent,
          suppressTensions: plan.renderingPlan.suppressTensions,
          smartDebug: plan.debug,
        ),
      ],
    );
    return comparison.selected.chord;
  }

  Iterable<StudyHarmonyGeneratedProgressionCandidate> _fallbackCandidates(
    bool allowNonDiatonic,
  ) sync* {
    final source = allowNonDiatonic
        ? const [
            'Cmaj7 | A7 | Dm7 | G7',
            'Gmaj7 | E7 | Am7 | D7',
            'Fmaj7 | D7 | Gm7 | C7',
            'Dmaj7 | B7 | Em7 | A7',
          ]
        : const [
            'Cmaj7 | Dm7 | G7 | Cmaj7',
            'Gmaj7 | Am7 | D7 | Gmaj7',
            'Fmaj7 | Gm7 | C7 | Fmaj7',
            'Dmaj7 | Em7 | A7 | Dmaj7',
          ];
    for (final input in source) {
      yield StudyHarmonyGeneratedProgressionCandidate(
        input: input,
        chordSymbols: input.split(' | '),
      );
    }
  }

  Iterable<StudyHarmonyGeneratedProgressionCandidate>
  _profileFallbackCandidates(TrackGenerationProfile profile) sync* {
    for (final input in profile.preferredCandidateInputs) {
      yield StudyHarmonyGeneratedProgressionCandidate(
        input: input,
        chordSymbols: input.split(' | '),
      );
    }
    yield* _fallbackCandidates(profile.allowNonDiatonic);
  }
}
