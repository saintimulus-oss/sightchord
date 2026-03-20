import 'dart:math';

import '../music/chord_timing_models.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import '../music/harmonic_rhythm_planner.dart';
import '../smart_generator.dart';
import 'practice_setup_models.dart';
import 'practice_settings.dart';
import 'practice_settings_factory.dart';

class PracticeSetupPreview {
  const PracticeSetupPreview({
    required this.profile,
    required this.settings,
    required this.chords,
  });

  final GeneratorProfile profile;
  final PracticeSettings settings;
  final List<GeneratedChord> chords;

  KeyCenter get startingKeyCenter => settings.activeKeyCenters.isEmpty
      ? GeneratorProfile.defaultStartingKeyCenter
      : settings.activeKeyCenters.first;

  bool get recommendsStudyHarmony =>
      profile.harmonyLiteracy == HarmonyLiteracy.absoluteBeginner;

  List<String> chordSymbols() {
    return [
      for (final chord in chords)
        ChordRenderingHelper.renderedSymbol(
          chord,
          settings.chordSymbolStyle,
          preferences: settings.notationPreferences,
        ),
    ];
  }
}

class PracticeSetupPreviewBuilder {
  const PracticeSetupPreviewBuilder._();

  static const int previewChordCount = 4;

  static PracticeSetupPreview build({
    required GeneratorProfile profile,
    required PracticeSettings baseSettings,
  }) {
    return fromSettings(
      settings: PracticeSettingsFactory.fromGeneratorProfile(
        profile,
        baseSettings: baseSettings,
      ),
    );
  }

  static PracticeSetupPreview fromSettings({
    required PracticeSettings settings,
  }) {
    final normalizedSettings = settings.copyWith(
      smartDiagnosticsEnabled: false,
    );
    final profile = PracticeSettingsFactory.profileFromSettings(
      normalizedSettings,
    );
    final chords = _buildProgression(
      settings: normalizedSettings,
      chordCount: previewChordCount,
    );
    return PracticeSetupPreview(
      profile: profile,
      settings: normalizedSettings,
      chords: chords,
    );
  }

  static List<GeneratedChord> _buildProgression({
    required PracticeSettings settings,
    required int chordCount,
  }) {
    final keyCenters = _orderedKeyCenters(settings);
    if (settings.smartGeneratorMode && keyCenters.isNotEmpty) {
      final smartChords = _buildSmartProgression(
        settings: settings,
        keyCenters: keyCenters,
        chordCount: chordCount,
      );
      if (smartChords.length == chordCount) {
        return smartChords;
      }
    }

    return _buildFallbackProgression(
      settings: settings,
      keyCenters: keyCenters,
      chordCount: chordCount,
    );
  }

  static List<GeneratedChord> _buildSmartProgression({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required int chordCount,
  }) {
    final random = Random(_seedForSettings(settings));
    final activeKeys = {
      for (final center in keyCenters) center.tonicName,
    }.toList(growable: false);
    final chords = <GeneratedChord>[];
    var plannedQueue = const <QueuedSmartChord>[];
    GeneratedChord? currentChord;
    ChordTimingSpec? currentTiming;

    for (var stepIndex = 0; stepIndex < chordCount; stepIndex += 1) {
      if (currentChord == null) {
        final initialTiming = HarmonicRhythmPlanner.initialTiming(
          settings: settings,
        );
        final initialPlan = SmartGeneratorHelper.planInitialStep(
          random: random,
          request: SmartStartRequest(
            activeKeys: activeKeys,
            selectedKeyCenters: keyCenters,
            secondaryDominantEnabled: settings.secondaryDominantEnabled,
            substituteDominantEnabled: settings.substituteDominantEnabled,
            modalInterchangeEnabled: settings.modalInterchangeEnabled,
            modulationIntensity: settings.modulationIntensity,
            jazzPreset: settings.jazzPreset,
            sourceProfile: settings.sourceProfile,
            allowV7sus4: _allowsSusDominantQualities(settings),
            allowTensions: settings.allowTensions,
            chordLanguageLevel: settings.chordLanguageLevel,
            romanPoolPreset: settings.romanPoolPreset,
            selectedTensionOptions: settings.selectedTensionOptions,
            inversionSettings: settings.inversionSettings,
            timeSignature: settings.timeSignature,
            harmonicRhythmPreset: settings.harmonicRhythmPreset,
            initialTiming: initialTiming,
            smartDiagnosticsEnabled: false,
          ),
        );
        plannedQueue = initialPlan.remainingQueuedChords;
        currentChord = _buildChord(
          random: random,
          settings: settings,
          keyCenter: initialPlan.finalKeyCenter,
          romanNumeralId: initialPlan.finalRomanNumeralId,
          plannedChordKind: initialPlan.plannedChordKind,
          renderQualityOverride:
              initialPlan.renderingPlan.renderQualityOverride,
          patternTag: initialPlan.patternTag,
          appliedType: initialPlan.appliedType,
          resolutionTargetRomanId: initialPlan.resolutionTargetRomanId,
          dominantContext: initialPlan.renderingPlan.dominantContext,
          dominantIntent: initialPlan.renderingPlan.dominantIntent,
          suppressTensions: initialPlan.renderingPlan.suppressTensions,
        );
        currentTiming = initialTiming;
      } else {
        final previousChord = chords.length >= 2
            ? chords[chords.length - 2]
            : null;
        final nextTiming = HarmonicRhythmPlanner.nextTiming(
          settings: settings,
          currentEvent: GeneratedChordEvent(
            chord: currentChord,
            timing: currentTiming!,
          ),
        );
        final plan = SmartGeneratorHelper.planNextStep(
          random: random,
          request: SmartStepRequest(
            stepIndex: stepIndex,
            activeKeys: activeKeys,
            selectedKeyCenters: keyCenters,
            currentKeyCenter:
                currentChord.keyCenter ??
                MusicTheory.keyCenterFor(currentChord.keyName!),
            currentRomanNumeralId: currentChord.romanNumeralId!,
            currentResolutionRomanNumeralId:
                SmartGeneratorHelper.continuationResolutionRomanNumeralId(
                  currentChord,
                ),
            currentHarmonicFunction: currentChord.harmonicFunction,
            secondaryDominantEnabled: settings.secondaryDominantEnabled,
            substituteDominantEnabled: settings.substituteDominantEnabled,
            modalInterchangeEnabled: settings.modalInterchangeEnabled,
            modulationIntensity: settings.modulationIntensity,
            jazzPreset: settings.jazzPreset,
            sourceProfile: settings.sourceProfile,
            allowV7sus4: _allowsSusDominantQualities(settings),
            allowTensions: settings.allowTensions,
            chordLanguageLevel: settings.chordLanguageLevel,
            romanPoolPreset: settings.romanPoolPreset,
            selectedTensionOptions: settings.selectedTensionOptions,
            inversionSettings: settings.inversionSettings,
            smartDiagnosticsEnabled: false,
            previousRomanNumeralId: previousChord?.romanNumeralId,
            previousHarmonicFunction: previousChord?.harmonicFunction,
            previousWasAppliedDominant:
                previousChord?.isAppliedDominant ?? false,
            currentPatternTag: currentChord.patternTag,
            plannedQueue: plannedQueue,
            currentRenderedNonDiatonic: currentChord.isRenderedNonDiatonic,
            timeSignature: settings.timeSignature,
            harmonicRhythmPreset: settings.harmonicRhythmPreset,
            timing: nextTiming,
            currentTrace: currentChord.smartDebug as SmartDecisionTrace?,
            phraseContext: SmartPhraseContext.rollingForm(
              stepIndex,
              timeSignature: settings.timeSignature,
              harmonicRhythmPreset: settings.harmonicRhythmPreset,
              timing: nextTiming,
            ),
          ),
        );
        plannedQueue = plan.remainingQueuedChords;
        currentChord = _buildChord(
          random: random,
          settings: settings,
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
          previousChord: currentChord,
        );
        currentTiming = nextTiming;
      }

      if (currentChord == null) {
        break;
      }
      chords.add(currentChord);
    }

    return chords;
  }

  static List<GeneratedChord> _buildFallbackProgression({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required int chordCount,
  }) {
    final random = Random(_seedForSettings(settings));
    final center = keyCenters.isEmpty
        ? GeneratorProfile.defaultStartingKeyCenter
        : keyCenters.first;
    final romans = _fallbackRomanLoopFor(
      keyMode: center.mode,
      romanPoolPreset: settings.romanPoolPreset,
    );
    final chords = <GeneratedChord>[];
    GeneratedChord? previousChord;

    for (var index = 0; index < chordCount; index += 1) {
      final chord = _buildChord(
        random: random,
        settings: settings,
        keyCenter: center,
        romanNumeralId: romans[index % romans.length],
        previousChord: previousChord,
      );
      if (chord == null) {
        break;
      }
      chords.add(chord);
      previousChord = chord;
    }

    return chords;
  }

  static GeneratedChord? _buildChord({
    required Random random,
    required PracticeSettings settings,
    required KeyCenter keyCenter,
    required RomanNumeralId romanNumeralId,
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    ChordQuality? renderQualityOverride,
    String? patternTag,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
    bool suppressTensions = false,
    GeneratedChord? previousChord,
  }) {
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: random,
      previousChord: previousChord,
      allowV7sus4: _allowsSusDominantQualities(settings),
      allowedRenderQualities: _activeChordQualitiesFor(settings),
      allowTensions: settings.allowTensions,
      chordLanguageLevel: settings.chordLanguageLevel,
      selectedTensionOptions: settings.selectedTensionOptions,
      inversionSettings: settings.inversionSettings,
      debugChordStyle: settings.chordSymbolStyle,
      candidates: [
        SmartRenderCandidate(
          keyCenter: keyCenter,
          romanNumeralId: romanNumeralId,
          plannedChordKind: plannedChordKind,
          renderQualityOverride: renderQualityOverride,
          patternTag: patternTag,
          appliedType: appliedType,
          resolutionTargetRomanId: resolutionTargetRomanId,
          dominantContext: dominantContext,
          dominantIntent: dominantIntent,
          suppressTensions: suppressTensions,
        ),
      ],
    );
    if (comparison.rankedCandidates.isEmpty) {
      return null;
    }
    return comparison.selected.chord;
  }

  static List<KeyCenter> _orderedKeyCenters(PracticeSettings settings) {
    final centers = settings.activeKeyCenters.toList(growable: false);
    if (centers.isEmpty) {
      return const [GeneratorProfile.defaultStartingKeyCenter];
    }
    centers.sort((a, b) {
      final modeCompare = a.mode.index.compareTo(b.mode.index);
      if (modeCompare != 0) {
        return modeCompare;
      }
      return a.tonicName.compareTo(b.tonicName);
    });
    return centers;
  }

  static bool _allowsSusDominantQualities(PracticeSettings settings) {
    return settings.allowV7sus4 &&
        settings.enabledChordQualities.any(
          MusicTheory.susDominantQualities.contains,
        );
  }

  static Set<ChordQuality> _activeChordQualitiesFor(PracticeSettings settings) {
    final enabled = <ChordQuality>{
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (settings.enabledChordQualities.contains(quality) &&
            (!_isSusDominantQuality(quality) ||
                _allowsSusDominantQualities(settings)))
          quality,
    };
    if (enabled.isNotEmpty) {
      return enabled;
    }
    return {
      for (final quality in MusicTheory.defaultGeneratorChordQualities(
        allowV7sus4: _allowsSusDominantQualities(settings),
      ))
        quality,
    };
  }

  static bool _isSusDominantQuality(ChordQuality quality) {
    return MusicTheory.susDominantQualities.contains(quality);
  }

  static List<RomanNumeralId> _fallbackRomanLoopFor({
    required KeyMode keyMode,
    required RomanPoolPreset romanPoolPreset,
  }) {
    if (keyMode == KeyMode.minor) {
      return const [
        RomanNumeralId.iMin7,
        RomanNumeralId.flatIIIMaj7Minor,
        RomanNumeralId.ivMin7Minor,
        RomanNumeralId.flatVIIDom7Minor,
      ];
    }

    return switch (romanPoolPreset) {
      RomanPoolPreset.corePrimary => const [
        RomanNumeralId.iMaj7,
        RomanNumeralId.ivMaj7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj7,
      ],
      RomanPoolPreset.coreDiatonic || RomanPoolPreset.fullDiatonic => const [
        RomanNumeralId.iMaj7,
        RomanNumeralId.viMin7,
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
      ],
      RomanPoolPreset.functionalJazz || RomanPoolPreset.expandedColor => const [
        RomanNumeralId.iiMin7,
        RomanNumeralId.vDom7,
        RomanNumeralId.iMaj7,
        RomanNumeralId.viMin7,
      ],
    };
  }

  static int _seedForSettings(PracticeSettings settings) {
    final activeCenters = _orderedKeyCenters(
      settings,
    ).map((center) => '${center.tonicName}:${center.mode.name}').join('|');
    final source = [
      settings.chordLanguageLevel.name,
      settings.romanPoolPreset.name,
      settings.chordSymbolStyle.name,
      settings.preferredSuggestionKind.name,
      settings.maxVoicingNotes.toString(),
      activeCenters,
    ].join('#');

    var hash = 17;
    for (final codeUnit in source.codeUnits) {
      hash = ((hash * 37) + codeUnit) & 0x7fffffff;
    }
    return hash;
  }
}
