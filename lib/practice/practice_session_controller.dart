import 'dart:developer' as developer;
import 'dart:math';

import '../music/anchor_loop_layout.dart';
import '../music/anchor_loop_planner.dart';
import '../music/chord_anchor_loop.dart';
import '../music/chord_formatting.dart';
import '../music/chord_timing_models.dart';
import '../music/chord_theory.dart';
import '../music/harmonic_rhythm_planner.dart';
import '../music/practice_chord_queue_state.dart';
import '../music/progression_analysis_models.dart';
import '../music/voicing_engine.dart';
import '../music/voicing_models.dart';
import '../music/voicing_session_state.dart';
import '../settings/practice_settings.dart';
import '../smart_generator.dart';
import 'practice_session_state.dart';

class PracticeSessionController {
  PracticeSessionController({
    Random? random,
    AnchorLoopPlanner? anchorLoopPlanner,
  }) : _random = random ?? Random(),
       _anchorLoopPlanner = anchorLoopPlanner ?? const AnchorLoopPlanner();

  final Random _random;
  final AnchorLoopPlanner _anchorLoopPlanner;

  PracticeSessionState _state = const PracticeSessionState();
  AnchorCyclePlan? _cachedAnchorCyclePlan;
  KeyCenter? _anchorLoopSeedKeyCenter;

  PracticeSessionState get state => _state;

  void initialize({required PracticeSettings settings}) {
    _state = _state.copyWith(initialized: true);
    _ensureChordQueueInitialized(settings);
    _recomputeVoicingSuggestions(settings);
  }

  void reseed({required PracticeSettings settings}) {
    _invalidateAnchorLoopPlanCache();
    _state = const PracticeSessionState(initialized: true);
    _ensureChordQueueInitialized(settings);
    _recomputeVoicingSuggestions(settings);
  }

  void restoreState(PracticeSessionState sessionState) {
    _state = sessionState;
  }

  void refreshForSettings({
    required PracticeSettings settings,
    bool forceLookAheadRefresh = false,
  }) {
    _invalidateAnchorLoopPlanCache();
    _recomputeVoicingSuggestions(
      settings,
      forceLookAheadRefresh: forceLookAheadRefresh,
    );
  }

  void promote({required PracticeSettings settings}) {
    _voicingState = _voicingState.promoteChordQueue();
    final nextCurrentEvent =
        _nextChordEvent ??
        _generateChordEvent(
          settings: settings,
          currentEvent: _currentChordEvent,
        );
    final nextQueuedEvent =
        _lookAheadChordEvent ??
        _generateChordEvent(
          settings: settings,
          exclusionContext: _buildExclusionContext(
            settings: settings,
            currentEvent: nextCurrentEvent,
          ),
          currentEvent: nextCurrentEvent,
        );
    _queueState = _queueState.promote(
      nextCurrentEvent: nextCurrentEvent,
      nextQueuedEvent: nextQueuedEvent,
    );
    _recomputeVoicingSuggestions(settings);
  }

  void selectVoicingSuggestion(
    VoicingSuggestion suggestion, {
    required PracticeSettings settings,
  }) {
    final hadLockedVoicing = _lockedCurrentVoicing != null;
    _voicingState = _voicingState.selectSuggestion(suggestion);
    if (hadLockedVoicing) {
      _recomputeVoicingSuggestions(settings);
    }
  }

  void toggleVoicingLock(
    VoicingSuggestion suggestion, {
    required PracticeSettings settings,
  }) {
    _voicingState = _voicingState.toggleLock(suggestion);
    _recomputeVoicingSuggestions(settings);
  }

  PracticeChordQueueState get _queueState => _state.queueState;
  set _queueState(PracticeChordQueueState value) {
    _state = _state.copyWith(queueState: value);
  }

  VoicingSessionState get _voicingState => _state.voicingState;
  set _voicingState(VoicingSessionState value) {
    _state = _state.copyWith(voicingState: value);
  }

  GeneratedChordEvent? get _currentChordEvent => _state.currentEvent;
  GeneratedChordEvent? get _nextChordEvent => _state.nextEvent;
  GeneratedChordEvent? get _lookAheadChordEvent => _state.lookAheadEvent;
  GeneratedChord? get _previousChord => _state.previousChord;
  GeneratedChord? get _currentChord => _state.currentChord;
  GeneratedChord? get _nextChord => _state.nextChord;
  GeneratedChord? get _lookAheadChord => _state.lookAheadChord;
  List<QueuedSmartChord> get _plannedSmartChordQueue =>
      _state.plannedSmartChordQueue;
  ConcreteVoicing? get _lockedCurrentVoicing => _state.lockedCurrentVoicing;
  ConcreteVoicing? get _continuityReferenceVoicing =>
      _state.continuityReferenceVoicing;
  String? get _lastLoggedVoicingDiagnosticKey => _state.lastLoggedDiagnosticKey;

  ChordAnchorLoop _anchorLoop(PracticeSettings settings) =>
      AnchorLoopLayout.sanitizeLoop(
        loop: settings.anchorLoop,
        timeSignature: settings.timeSignature,
        harmonicRhythmPreset: settings.harmonicRhythmPreset,
      );

  bool _hasAnchorLoop(PracticeSettings settings) =>
      _anchorLoop(settings).hasEnabledSlots;

  List<KeyCenter> _orderedKeyCenters(PracticeSettings settings) => [
    for (final mode in KeyMode.values)
      for (final center in MusicTheory.orderedKeyCentersForMode(mode))
        if (settings.activeKeyCenters.contains(center)) center,
  ];

  bool _allowsSusDominantQualities(PracticeSettings settings) =>
      settings.allowV7sus4 &&
      settings.enabledChordQualities.any(
        MusicTheory.susDominantQualities.contains,
      );

  Set<ChordQuality> _activeChordQualities(PracticeSettings settings) {
    final usesKeyMode = settings.usesKeyMode;
    final allowsSusDominantQualities = _allowsSusDominantQualities(settings);
    final enabled = <ChordQuality>{
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (settings.enabledChordQualities.contains(quality) &&
            (usesKeyMode ||
                !MusicTheory.isKeyModeOnlyGeneratorQuality(quality)) &&
            (!MusicTheory.susDominantQualities.contains(quality) ||
                allowsSusDominantQualities))
          quality,
    };
    if (enabled.isNotEmpty) {
      return enabled;
    }
    return {
      for (final quality in MusicTheory.defaultGeneratorChordQualities(
        allowV7sus4: allowsSusDominantQualities,
      ))
        if (usesKeyMode || !MusicTheory.isKeyModeOnlyGeneratorQuality(quality))
          quality,
    };
  }

  KeyCenter? _resolvedAnchorLoopSeedKeyCenter(PracticeSettings settings) {
    final cachedSeed = _anchorLoopSeedKeyCenter;
    if (cachedSeed != null) {
      return cachedSeed;
    }
    final orderedKeyCenters = _orderedKeyCenters(settings);
    if (orderedKeyCenters.isNotEmpty) {
      _anchorLoopSeedKeyCenter = orderedKeyCenters.first;
      return _anchorLoopSeedKeyCenter;
    }
    return null;
  }

  AnchorCyclePlan? _activeAnchorCyclePlan(PracticeSettings settings) {
    if (!_hasAnchorLoop(settings)) {
      return null;
    }
    return _cachedAnchorCyclePlan ??= _anchorLoopPlanner.buildCyclePlan(
      settings: settings,
      loop: _anchorLoop(settings),
      seedKeyCenter: _resolvedAnchorLoopSeedKeyCenter(settings),
    );
  }

  void _invalidateAnchorLoopPlanCache() {
    _cachedAnchorCyclePlan = null;
    _anchorLoopSeedKeyCenter = null;
  }

  String _displaySymbolForEvent(
    PracticeSettings settings,
    GeneratedChordEvent? event,
  ) {
    if (event == null) {
      return '';
    }
    return event.displaySymbolOverride ??
        ChordRenderingHelper.renderedSymbol(
          event.chord,
          settings.chordSymbolStyle,
          preferences: settings.notationPreferences,
        );
  }

  String _tonicRootForKeyCenter(KeyCenter keyCenter) {
    final tonicRoman = keyCenter.mode == KeyMode.major
        ? RomanNumeralId.iMaj7
        : RomanNumeralId.iMin7;
    return MusicTheory.resolveChordRootForCenter(keyCenter, tonicRoman);
  }

  GeneratedChord _fallbackGeneratedChord(
    PracticeSettings settings, {
    KeyCenter? keyCenter,
  }) {
    final quality = _activeChordQualities(settings).first;
    final root = keyCenter == null
        ? MusicTheory.freeModeRoots.first
        : _tonicRootForKeyCenter(keyCenter);
    final safeQuality = quality == ChordQuality.dominant7sus4
        ? ChordQuality.dominant7
        : quality;
    return _buildFreeGeneratedChord(settings, root, safeQuality);
  }

  GeneratedChord _fallbackKeyModeChord(
    PracticeSettings settings,
    List<KeyCenter> keyCenters,
  ) {
    for (final keyCenter in keyCenters) {
      for (final roman in SmartGeneratorHelper.diatonicRomansForPool(
        keyMode: keyCenter.mode,
        romanPoolPreset: settings.romanPoolPreset,
      )) {
        final chord = _buildGeneratedChord(
          settings,
          keyCenter.tonicName,
          roman,
          keyCenter: keyCenter,
        );
        if (chord != null) {
          return chord;
        }
      }
    }
    return _fallbackGeneratedChord(
      settings,
      keyCenter: keyCenters.isEmpty ? null : keyCenters.first,
    );
  }

  ChordTimingSpec _initialTimingSpec(PracticeSettings settings) {
    return HarmonicRhythmPlanner.initialTiming(
      settings: settings,
      anchorLoop: _anchorLoop(settings),
    );
  }

  ChordTimingSpec _nextTimingSpec(
    PracticeSettings settings, {
    required GeneratedChordEvent? currentEvent,
  }) {
    return HarmonicRhythmPlanner.nextTiming(
      settings: settings,
      currentEvent: currentEvent,
      anchorLoop: _anchorLoop(settings),
    );
  }

  SmartPhraseContext _phraseContextForTiming(
    PracticeSettings settings, {
    required int stepIndex,
    required ChordTimingSpec timing,
  }) {
    return SmartPhraseContext.rollingForm(
      stepIndex,
      timeSignature: settings.timeSignature,
      harmonicRhythmPreset: settings.harmonicRhythmPreset,
      timing: timing,
    );
  }

  GeneratedChordEvent _eventForChord({
    required GeneratedChord chord,
    required ChordTimingSpec timing,
  }) {
    return GeneratedChordEvent(chord: chord, timing: timing);
  }

  ChordExclusionContext _buildExclusionContext({
    required PracticeSettings settings,
    GeneratedChordEvent? currentEvent,
    Set<String> displayedSymbols = const <String>{},
  }) {
    final nextTiming = currentEvent == null
        ? _initialTimingSpec(settings)
        : _nextTimingSpec(settings, currentEvent: currentEvent);
    final nextRenderedSymbols = <String>{...displayedSymbols};
    final repeatGuardKeys = <String>{};
    final harmonicComparisonKeys = <String>{};
    final current = currentEvent?.chord;
    if (current != null) {
      nextRenderedSymbols.add(_displaySymbolForEvent(settings, currentEvent));
      repeatGuardKeys.add(current.repeatGuardKey);
      harmonicComparisonKeys.add(current.harmonicComparisonKey);
    }
    return ChordExclusionContext(
      renderedSymbols: nextRenderedSymbols,
      repeatGuardKeys: repeatGuardKeys,
      harmonicComparisonKeys: harmonicComparisonKeys,
      allowConsecutiveRepeat: _allowsConsecutiveRepeatForTiming(
        settings,
        nextTiming,
      ),
    );
  }

  bool _allowsConsecutiveRepeatForTiming(
    PracticeSettings settings,
    ChordTimingSpec timing,
  ) {
    return SmartGeneratorHelper.allowsConsecutiveRepeat(
      harmonicRhythmPreset: settings.harmonicRhythmPreset,
      phraseContext: _phraseContextForTiming(
        settings,
        stepIndex: timing.barIndex,
        timing: timing,
      ),
    );
  }

  bool _isExcludedCandidate(
    PracticeSettings settings,
    GeneratedChord candidate,
    ChordExclusionContext exclusionContext,
  ) {
    final blockedByRenderedSymbol = exclusionContext.renderedSymbols.contains(
      ChordRenderingHelper.renderedSymbol(
        candidate,
        settings.chordSymbolStyle,
        preferences: settings.notationPreferences,
      ),
    );
    final blockedByRepeatGuard = exclusionContext.repeatGuardKeys.contains(
      candidate.repeatGuardKey,
    );
    final blockedByHarmonicComparison = exclusionContext.harmonicComparisonKeys
        .contains(candidate.harmonicComparisonKey);
    if (exclusionContext.allowConsecutiveRepeat &&
        (blockedByRenderedSymbol ||
            blockedByRepeatGuard ||
            blockedByHarmonicComparison)) {
      return false;
    }
    return blockedByRenderedSymbol ||
        blockedByRepeatGuard ||
        blockedByHarmonicComparison;
  }

  AppliedType? _appliedTypeForSourceKind(ChordSourceKind sourceKind) {
    return switch (sourceKind) {
      ChordSourceKind.secondaryDominant => AppliedType.secondary,
      ChordSourceKind.substituteDominant => AppliedType.substitute,
      _ => null,
    };
  }

  HarmonicFunction _chordFunctionForProgressionFunction(
    ProgressionHarmonicFunction function,
  ) {
    return switch (function) {
      ProgressionHarmonicFunction.tonic => HarmonicFunction.tonic,
      ProgressionHarmonicFunction.predominant => HarmonicFunction.predominant,
      ProgressionHarmonicFunction.dominant => HarmonicFunction.dominant,
      ProgressionHarmonicFunction.other => HarmonicFunction.free,
    };
  }

  GeneratedChord _buildParsedGeneratedChord({
    required PracticeSettings settings,
    required ParsedChord parsedChord,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? previousChord,
    KeyCenter? keyCenter,
    RomanNumeralId? romanNumeralId,
    ChordSourceKind? sourceKind,
    HarmonicFunction? harmonicFunction,
    bool allowVariation = false,
  }) {
    final resolvedSourceKind =
        sourceKind ??
        (romanNumeralId == null
            ? ChordSourceKind.free
            : MusicTheory.specFor(romanNumeralId).sourceKind);
    final resolvedFunction =
        harmonicFunction ??
        (romanNumeralId == null
            ? HarmonicFunction.free
            : MusicTheory.specFor(romanNumeralId).harmonicFunction);
    if (allowVariation && romanNumeralId != null && keyCenter != null) {
      final generated = _buildGeneratedChord(
        settings,
        keyCenter.tonicName,
        romanNumeralId,
        keyCenter: keyCenter,
        previousChord: previousChord,
        exclusionContext: exclusionContext,
      );
      if (generated != null &&
          !_isExcludedCandidate(settings, generated, exclusionContext)) {
        return generated;
      }
    }
    final symbolData = ChordSymbolData(
      root: parsedChord.root,
      harmonicQuality: parsedChord.displayQuality,
      renderQuality: parsedChord.displayQuality,
      tensions: parsedChord.tensions,
      bass: parsedChord.bass,
    );
    final appliedType = _appliedTypeForSourceKind(resolvedSourceKind);
    final resolutionTargetRomanId = romanNumeralId == null || keyCenter == null
        ? null
        : MusicTheory.modeAwareResolutionTarget(romanNumeralId, keyCenter.mode);
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: keyCenter?.tonicName,
      romanNumeralId: romanNumeralId,
      harmonicFunction: resolvedFunction,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      symbolData: symbolData,
      sourceKind: resolvedSourceKind,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
          keyName: keyCenter?.tonicName,
          romanNumeralId: romanNumeralId,
          harmonicFunction: resolvedFunction,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          symbolData: symbolData,
          sourceKind: resolvedSourceKind,
          appliedType: appliedType,
          resolutionTargetRomanId: resolutionTargetRomanId,
        );
    return GeneratedChord(
      symbolData: symbolData,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      keyName: keyCenter?.tonicName,
      keyCenter: keyCenter,
      romanNumeralId: romanNumeralId,
      harmonicFunction: resolvedFunction,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      sourceKind: resolvedSourceKind,
      appliedType: appliedType,
      resolutionTargetRomanId: resolutionTargetRomanId,
      isRenderedNonDiatonic: ChordRenderingHelper.isRenderedNonDiatonic(
        romanNumeralId: romanNumeralId,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        sourceKind: resolvedSourceKind,
        renderQuality: symbolData.renderQuality,
        tensions: symbolData.tensions,
      ),
    );
  }

  GeneratedChordEvent? _buildAnchorLoopEvent({
    required PracticeSettings settings,
    required ChordTimingSpec timing,
    required ChordExclusionContext exclusionContext,
    GeneratedChordEvent? currentEvent,
  }) {
    final cyclePlan = _activeAnchorCyclePlan(settings);
    final slotPlan = cyclePlan?.planForTiming(timing);
    if (cyclePlan == null || slotPlan == null) {
      return null;
    }

    final analysis = slotPlan.primaryAnalysis;
    final keyCenter = cyclePlan.analysisKeyCenter ?? cyclePlan.seedKeyCenter;
    if (slotPlan.isAnchor) {
      final parsedAnchorChord = slotPlan.parsedAnchorChord;
      if (parsedAnchorChord == null) {
        return null;
      }
      _queueState = _queueState.clearPlannedSmartChordQueue();
      return GeneratedChordEvent(
        chord: _buildParsedGeneratedChord(
          settings: settings,
          parsedChord: parsedAnchorChord,
          exclusionContext: exclusionContext,
          previousChord: currentEvent?.chord,
          keyCenter: keyCenter,
          romanNumeralId: analysis?.romanNumeralId,
          sourceKind: analysis?.sourceKind,
          harmonicFunction: analysis == null
              ? HarmonicFunction.free
              : _chordFunctionForProgressionFunction(analysis.harmonicFunction),
        ),
        timing: timing,
        displaySymbolOverride: slotPlan.anchorSlot?.trimmedChordSymbol,
      );
    }

    if (analysis == null) {
      return null;
    }

    final anchorLoop = _anchorLoop(settings);
    final chosenAlternative =
        anchorLoop.varyNonAnchorSlots &&
            slotPlan.compatibleAlternatives.isNotEmpty
        ? slotPlan.compatibleAlternatives[_random.nextInt(
            slotPlan.compatibleAlternatives.length,
          )]
        : null;
    final chosenSymbol =
        chosenAlternative?.chordSymbol ?? analysis.resolvedSymbol;
    final parsedCandidate =
        _anchorLoopPlanner.tryParseChordSymbol(chosenSymbol) ?? analysis.chord;
    final chord = _buildParsedGeneratedChord(
      settings: settings,
      parsedChord: parsedCandidate,
      exclusionContext: exclusionContext,
      previousChord: currentEvent?.chord,
      keyCenter: keyCenter,
      romanNumeralId:
          chosenAlternative?.romanNumeralId ?? analysis.romanNumeralId,
      sourceKind: chosenAlternative?.sourceKind ?? analysis.sourceKind,
      harmonicFunction: _chordFunctionForProgressionFunction(
        chosenAlternative?.harmonicFunction ?? analysis.harmonicFunction,
      ),
      allowVariation:
          anchorLoop.varyNonAnchorSlots &&
          chosenAlternative == null &&
          analysis.romanNumeralId != null &&
          keyCenter != null,
    );
    if (_isExcludedCandidate(settings, chord, exclusionContext)) {
      return null;
    }
    _queueState = _queueState.clearPlannedSmartChordQueue();
    return GeneratedChordEvent(chord: chord, timing: timing);
  }

  GeneratedChord _generateChord({
    required PracticeSettings settings,
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? current,
    ChordTimingSpec? timing,
  }) {
    if (!settings.usesKeyMode) {
      final qualities = _activeChordQualities(settings).toList(growable: false);
      while (true) {
        final root = MusicTheory
            .freeModeRoots[_random.nextInt(MusicTheory.freeModeRoots.length)];
        final quality = qualities[_random.nextInt(qualities.length)];
        final generatedChord = _buildFreeGeneratedChord(
          settings,
          root,
          quality,
        );
        if (!_isExcludedCandidate(settings, generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keyCenters = _orderedKeyCenters(settings);
    if (keyCenters.isEmpty) {
      return _fallbackGeneratedChord(settings);
    }
    if (settings.smartGeneratorMode) {
      return _generateSmartChord(
        settings: settings,
        keyCenters: keyCenters,
        exclusionContext: exclusionContext,
        current: current,
        timing: timing,
      );
    }

    return _generateRandomKeyModeChord(
      settings: settings,
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChordEvent _generateChordEvent({
    required PracticeSettings settings,
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChordEvent? currentEvent,
  }) {
    final timing = currentEvent == null
        ? _initialTimingSpec(settings)
        : _nextTimingSpec(settings, currentEvent: currentEvent);
    final anchorEvent = _buildAnchorLoopEvent(
      settings: settings,
      timing: timing,
      exclusionContext: exclusionContext,
      currentEvent: currentEvent,
    );
    if (anchorEvent != null) {
      return anchorEvent;
    }
    final chord = _generateChord(
      settings: settings,
      exclusionContext: exclusionContext,
      current: currentEvent?.chord,
      timing: timing,
    );
    return _eventForChord(chord: chord, timing: timing);
  }

  GeneratedChord _buildFreeGeneratedChord(
    PracticeSettings settings,
    String root,
    ChordQuality quality, {
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
      random: _random,
      root: root,
      harmonicQuality: quality,
      renderQuality: quality,
      romanNumeralId: null,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      sourceKind: ChordSourceKind.free,
      allowTensions: settings.allowTensions,
      selectedTensionOptions: settings.selectedTensionOptions,
      suppressTensions: false,
      inversionSettings: settings.inversionSettings,
      chordLanguageLevel: settings.chordLanguageLevel,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: null,
      romanNumeralId: null,
      harmonicFunction: HarmonicFunction.free,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      symbolData: renderingSelection.symbolData,
      sourceKind: ChordSourceKind.free,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
          keyName: null,
          romanNumeralId: null,
          harmonicFunction: HarmonicFunction.free,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          symbolData: renderingSelection.symbolData,
          sourceKind: ChordSourceKind.free,
        );
    return GeneratedChord(
      symbolData: renderingSelection.symbolData,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      sourceKind: ChordSourceKind.free,
      smartDebug: smartDebug,
      wasExcludedFallback: wasExcludedFallback,
      isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
    );
  }

  GeneratedChord? _buildGeneratedChord(
    PracticeSettings settings,
    String key,
    RomanNumeralId romanNumeralId, {
    KeyCenter? keyCenter,
    KeyMode keyMode = KeyMode.major,
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    ChordQuality? renderQualityOverride,
    String? patternTag,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
    bool suppressTensions = false,
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? previousChord,
  }) {
    final effectiveKeyCenter =
        keyCenter ?? MusicTheory.keyCenterFor(key, mode: keyMode);
    final smartTrace = smartDebug is SmartDecisionTrace ? smartDebug : null;
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: _random,
      previousChord: previousChord,
      allowV7sus4: _allowsSusDominantQualities(settings),
      allowedRenderQualities: _activeChordQualities(settings),
      allowTensions: settings.allowTensions,
      chordLanguageLevel: settings.chordLanguageLevel,
      selectedTensionOptions: settings.selectedTensionOptions,
      inversionSettings: settings.inversionSettings,
      debugChordStyle: settings.chordSymbolStyle,
      candidates: [
        SmartRenderCandidate(
          keyCenter: effectiveKeyCenter,
          romanNumeralId: romanNumeralId,
          plannedChordKind: plannedChordKind,
          renderQualityOverride: renderQualityOverride,
          patternTag: patternTag,
          appliedType: appliedType,
          resolutionTargetRomanId: resolutionTargetRomanId,
          dominantContext: dominantContext,
          dominantIntent: dominantIntent,
          suppressTensions: suppressTensions,
          smartDebug: smartTrace,
          wasExcludedFallback: wasExcludedFallback,
        ),
      ],
    );
    if (comparison.rankedCandidates.isEmpty) {
      return null;
    }
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(settings, candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return comparison.selected.chord;
  }

  GeneratedChord _attachSmartDebug(
    PracticeSettings settings,
    GeneratedChord chord,
    SmartGenerationDebug smartDebug, {
    bool wasExcludedFallback = false,
  }) {
    final resolvedDebug =
        chord.keyCenter != null && chord.romanNumeralId != null
        ? smartDebug.withFinalSelection(
            finalKeyCenter: chord.keyCenter!,
            finalRomanNumeralId: chord.romanNumeralId!,
            finalChord: ChordRenderingHelper.renderedSymbol(
              chord,
              settings.chordSymbolStyle,
              preferences: settings.notationPreferences,
            ),
            fallbackOccurred: wasExcludedFallback,
            finalRoot: chord.symbolData.root,
            finalRenderQuality: chord.symbolData.renderQuality,
            finalTensions: chord.symbolData.tensions,
            finalRenderedNonDiatonic: chord.isRenderedNonDiatonic,
          )
        : smartDebug;
    return chord.copyWith(
      wasExcludedFallback: wasExcludedFallback,
      smartDebug: resolvedDebug,
    );
  }

  GeneratedChord _emitSmartDebug(
    PracticeSettings settings,
    GeneratedChord chord,
  ) {
    final smartDebug = chord.smartDebug;
    if (smartDebug is SmartDecisionTrace) {
      SmartDiagnosticsStore.record(smartDebug);
      if (settings.smartDiagnosticsEnabled) {
        developer.log(smartDebug.describe(), name: 'chordest.smart_generator');
      }
    }
    return chord;
  }

  Map<RomanNumeralId, int> _randomKeyModeRomanWeightsFor(
    PracticeSettings settings,
    KeyMode mode,
  ) {
    final baseWeights = mode == KeyMode.minor
        ? const {
            RomanNumeralId.iMinMaj7: 16,
            RomanNumeralId.iMin7: 14,
            RomanNumeralId.iMin6: 12,
            RomanNumeralId.iiHalfDiminishedMinor: 12,
            RomanNumeralId.flatIIIMaj7Minor: 10,
            RomanNumeralId.ivMin7Minor: 12,
            RomanNumeralId.vDom7: 16,
            RomanNumeralId.flatVIMaj7Minor: 10,
            RomanNumeralId.flatVIIDom7Minor: 10,
          }
        : <RomanNumeralId, int>{
            RomanNumeralId.iMaj7: 18,
            RomanNumeralId.iiMin7: 16,
            RomanNumeralId.iiiMin7: 10,
            RomanNumeralId.ivMaj7: 14,
            RomanNumeralId.vDom7: 18,
            RomanNumeralId.viMin7: 14,
            RomanNumeralId.viiHalfDiminished7: 10,
          };
    final weights = <RomanNumeralId, int>{...baseWeights};
    if (mode == KeyMode.major && settings.modalInterchangeEnabled) {
      weights.addAll(const {
        RomanNumeralId.borrowedIvMin7: 4,
        RomanNumeralId.borrowedFlatVII7: 3,
        RomanNumeralId.borrowedFlatVIMaj7: 3,
        RomanNumeralId.borrowedFlatIIIMaj7: 2,
        RomanNumeralId.borrowedIiHalfDiminished7: 2,
        RomanNumeralId.borrowedFlatIIMaj7: 1,
      });
    }
    if (mode == KeyMode.major && settings.secondaryDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.secondaryOfII: 5,
        RomanNumeralId.secondaryOfIII: 5,
        RomanNumeralId.secondaryOfIV: 5,
        RomanNumeralId.secondaryOfV: 5,
        RomanNumeralId.secondaryOfVI: 5,
      });
    }
    if (mode == KeyMode.major && settings.substituteDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.substituteOfII: 2,
        RomanNumeralId.substituteOfIII: 2,
        RomanNumeralId.substituteOfIV: 2,
        RomanNumeralId.substituteOfV: 2,
        RomanNumeralId.substituteOfVI: 2,
      });
    }
    final filtered = <RomanNumeralId, int>{
      for (final entry in weights.entries)
        if (SmartGeneratorHelper.allowsRomanForPool(
          romanNumeralId: entry.key,
          romanPoolPreset: settings.romanPoolPreset,
        ))
          entry.key: entry.value,
    };
    return filtered.isNotEmpty
        ? filtered
        : _diatonicRomanWeightsFor(settings, mode);
  }

  Map<RomanNumeralId, int> _diatonicRomanWeightsFor(
    PracticeSettings settings,
    KeyMode mode,
  ) => {
    for (final roman in SmartGeneratorHelper.diatonicRomansForPool(
      keyMode: mode,
      romanPoolPreset: settings.romanPoolPreset,
    ))
      roman: 1,
  };

  List<_WeightedGeneratedChordCandidate> _buildWeightedKeyModeCandidates({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    Map<RomanNumeralId, int> Function(KeyMode mode)? romanWeightsForMode,
  }) {
    return [
      for (final keyCenter in keyCenters)
        for (final entry
            in (romanWeightsForMode ??
                    (KeyMode mode) => _randomKeyModeRomanWeightsFor(
                      settings,
                      mode,
                    ))(keyCenter.mode)
                .entries)
          if (entry.value > 0)
            () {
              final chord = _buildGeneratedChord(
                settings,
                keyCenter.tonicName,
                entry.key,
                keyCenter: keyCenter,
              );
              if (chord == null) {
                return null;
              }
              if (_isExcludedCandidate(settings, chord, exclusionContext)) {
                return null;
              }
              return _WeightedGeneratedChordCandidate(
                chord: chord,
                weight: entry.value,
              );
            }(),
    ].whereType<_WeightedGeneratedChordCandidate>().toList(growable: false);
  }

  GeneratedChord _pickWeightedChord(
    List<_WeightedGeneratedChordCandidate> candidates,
  ) {
    final totalWeight = candidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    var remaining = _random.nextInt(totalWeight);
    for (final candidate in candidates) {
      if (remaining < candidate.weight) {
        return candidate.chord;
      }
      remaining -= candidate.weight;
    }
    return candidates.last.chord;
  }

  GeneratedChord _generateRandomKeyModeChord({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
  }) {
    final candidates = _buildWeightedKeyModeCandidates(
      settings: settings,
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
    if (candidates.isNotEmpty) {
      return _pickWeightedChord(candidates);
    }
    return _fallbackKeyModeChord(settings, keyCenters);
  }

  GeneratedChord _generateRandomDiatonicChord({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    KeyCenter? preferredKeyCenter,
  }) {
    final preferredCenters =
        preferredKeyCenter != null && keyCenters.contains(preferredKeyCenter)
        ? <KeyCenter>[preferredKeyCenter]
        : keyCenters;
    final preferredCandidates = _buildWeightedKeyModeCandidates(
      settings: settings,
      keyCenters: preferredCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: (mode) => _diatonicRomanWeightsFor(settings, mode),
    );
    if (preferredCandidates.isNotEmpty) {
      return preferredCandidates[_random.nextInt(preferredCandidates.length)]
          .chord;
    }

    final fallbackCandidates = _buildWeightedKeyModeCandidates(
      settings: settings,
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: (mode) => _diatonicRomanWeightsFor(settings, mode),
    );
    if (fallbackCandidates.isNotEmpty) {
      return fallbackCandidates[_random.nextInt(fallbackCandidates.length)]
          .chord;
    }
    return _fallbackKeyModeChord(settings, preferredCenters);
  }

  GeneratedChord? _buildFamilyAwareFallbackChord({
    required PracticeSettings settings,
    required SmartStepPlan plan,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? previousChord,
  }) {
    final harmonicFunction = _harmonicFunctionForGeneratedChord(
      plan.finalRomanNumeralId,
      plannedChordKind: plan.plannedChordKind,
      appliedType: plan.appliedType,
    );
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: _random,
      previousChord: previousChord,
      allowV7sus4: _allowsSusDominantQualities(settings),
      allowedRenderQualities: _activeChordQualities(settings),
      allowTensions: settings.allowTensions,
      chordLanguageLevel: settings.chordLanguageLevel,
      selectedTensionOptions: settings.selectedTensionOptions,
      inversionSettings: settings.inversionSettings,
      debugChordStyle: settings.chordSymbolStyle,
      candidates: [
        for (final roman in SmartGeneratorHelper.prioritizedFallbackRomans(
          keyMode: plan.finalKeyCenter.mode,
          finalRomanNumeralId: plan.finalRomanNumeralId,
          harmonicFunction: harmonicFunction,
          patternTag: plan.patternTag,
        ))
          SmartRenderCandidate(
            keyCenter: plan.finalKeyCenter,
            romanNumeralId: roman,
            plannedChordKind: roman == plan.finalRomanNumeralId
                ? plan.plannedChordKind
                : PlannedChordKind.resolvedRoman,
            renderQualityOverride: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.renderQualityOverride
                : null,
            patternTag: plan.patternTag,
            dominantContext: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.dominantContext
                : null,
            dominantIntent: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.dominantIntent
                : null,
            smartDebug: plan.debug.withDecision(
              'excluded-fallback-hierarchy',
              nextBlockedReason: SmartBlockedReason.excludedFallback,
              nextFallbackOccurred: true,
            ),
            wasExcludedFallback: true,
          ),
      ],
    );
    if (comparison.rankedCandidates.isEmpty) {
      return null;
    }
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(settings, candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return null;
  }

  GeneratedChord _generateSmartChord({
    required PracticeSettings settings,
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? current,
    ChordTimingSpec? timing,
  }) {
    if (current?.keyName == null ||
        current?.romanNumeralId == null ||
        !keyCenters.contains(current!.keyCenter)) {
      final activeKeys = {
        for (final center in keyCenters) center.tonicName,
      }.toList(growable: false);
      final initialPlan = SmartGeneratorHelper.planInitialStep(
        random: _random,
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
          initialTiming: timing,
          smartDiagnosticsEnabled: settings.smartDiagnosticsEnabled,
        ),
      );
      _queueState = _queueState.withPlannedSmartChordQueue(
        initialPlan.remainingQueuedChords,
      );
      final seededChord = _buildGeneratedChord(
        settings,
        initialPlan.finalKey,
        initialPlan.finalRomanNumeralId,
        keyCenter: initialPlan.finalKeyCenter,
        plannedChordKind: initialPlan.plannedChordKind,
        renderQualityOverride: initialPlan.renderingPlan.renderQualityOverride,
        patternTag: initialPlan.patternTag,
        appliedType: initialPlan.appliedType,
        resolutionTargetRomanId: initialPlan.resolutionTargetRomanId,
        dominantContext: initialPlan.renderingPlan.dominantContext,
        dominantIntent: initialPlan.renderingPlan.dominantIntent,
        suppressTensions: initialPlan.renderingPlan.suppressTensions,
        smartDebug: initialPlan.debug,
        exclusionContext: exclusionContext,
      );
      if (seededChord != null &&
          !_isExcludedCandidate(settings, seededChord, exclusionContext)) {
        return _emitSmartDebug(settings, seededChord);
      }
      final initialFallback = _buildFamilyAwareFallbackChord(
        settings: settings,
        plan: initialPlan,
        exclusionContext: exclusionContext,
        previousChord: current,
      );
      if (initialFallback != null) {
        return _emitSmartDebug(settings, initialFallback);
      }
      return _emitSmartDebug(
        settings,
        _attachSmartDebug(
          settings,
          _generateRandomKeyModeChord(
            settings: settings,
            keyCenters: keyCenters,
            exclusionContext: exclusionContext,
          ),
          initialPlan.debug.withDecision(
            'excluded-fallback',
            nextBlockedReason: SmartBlockedReason.excludedFallback,
            nextFallbackOccurred: true,
          ),
          wasExcludedFallback: true,
        ),
      );
    }

    final currentRomanNumeralId = current.romanNumeralId!;
    final currentResolutionRomanId =
        SmartGeneratorHelper.continuationResolutionRomanNumeralId(current);
    final activeKeys = {
      for (final center in keyCenters) center.tonicName,
    }.toList(growable: false);
    final stepIndex =
        ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1;
    final phraseContext = timing == null
        ? null
        : _phraseContextForTiming(
            settings,
            stepIndex: stepIndex,
            timing: timing,
          );

    final plan = SmartGeneratorHelper.planNextStep(
      random: _random,
      request: SmartStepRequest(
        stepIndex: stepIndex,
        activeKeys: activeKeys,
        selectedKeyCenters: keyCenters,
        currentKeyCenter:
            current.keyCenter ?? MusicTheory.keyCenterFor(current.keyName!),
        currentRomanNumeralId: currentRomanNumeralId,
        currentResolutionRomanNumeralId: currentResolutionRomanId,
        currentHarmonicFunction: current.harmonicFunction,
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
        smartDiagnosticsEnabled: settings.smartDiagnosticsEnabled,
        previousRomanNumeralId: _previousChord?.romanNumeralId,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
        currentRenderedNonDiatonic: current.isRenderedNonDiatonic,
        timeSignature: settings.timeSignature,
        harmonicRhythmPreset: settings.harmonicRhythmPreset,
        timing: timing,
        currentTrace: current.smartDebug as SmartDecisionTrace?,
        phraseContext: phraseContext,
      ),
    );
    _queueState = _queueState.withPlannedSmartChordQueue(
      plan.remainingQueuedChords,
    );

    final generatedChord = _buildGeneratedChord(
      settings,
      plan.finalKey,
      plan.finalRomanNumeralId,
      keyCenter: plan.finalKeyCenter,
      plannedChordKind: plan.plannedChordKind,
      renderQualityOverride: plan.renderingPlan.renderQualityOverride,
      patternTag: plan.patternTag,
      appliedType: plan.appliedType,
      resolutionTargetRomanId: plan.resolutionTargetRomanId,
      dominantContext: plan.renderingPlan.dominantContext,
      dominantIntent: plan.renderingPlan.dominantIntent,
      suppressTensions: plan.renderingPlan.suppressTensions,
      smartDebug: plan.debug,
      exclusionContext: exclusionContext,
      previousChord: current,
    );
    if (generatedChord != null &&
        !_isExcludedCandidate(settings, generatedChord, exclusionContext)) {
      return _emitSmartDebug(settings, generatedChord);
    }

    final familyAwareFallback = _buildFamilyAwareFallbackChord(
      settings: settings,
      plan: plan,
      exclusionContext: exclusionContext,
      previousChord: current,
    );
    if (familyAwareFallback != null) {
      return _emitSmartDebug(settings, familyAwareFallback);
    }

    if (plan.patternTag != null) {
      _queueState = _queueState.clearPlannedSmartChordQueue();
    }
    final fallbackChord = _generateRandomDiatonicChord(
      settings: settings,
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      preferredKeyCenter: keyCenters.contains(plan.finalKeyCenter)
          ? plan.finalKeyCenter
          : current.keyCenter,
    );
    return _emitSmartDebug(
      settings,
      _attachSmartDebug(
        settings,
        fallbackChord,
        plan.debug.withDecision(
          'excluded-fallback',
          nextBlockedReason: SmartBlockedReason.excludedFallback,
          nextFallbackOccurred: true,
        ),
        wasExcludedFallback: true,
      ),
    );
  }

  HarmonicFunction _harmonicFunctionForGeneratedChord(
    RomanNumeralId romanNumeralId, {
    required PlannedChordKind plannedChordKind,
    AppliedType? appliedType,
  }) {
    if (appliedType == AppliedType.secondary ||
        appliedType == AppliedType.substitute) {
      return HarmonicFunction.dominant;
    }
    if (plannedChordKind != PlannedChordKind.resolvedRoman) {
      return HarmonicFunction.tonic;
    }
    return MusicTheory.specFor(romanNumeralId).harmonicFunction;
  }

  void _ensureChordQueueInitialized(PracticeSettings settings) {
    final currentEvent =
        _queueState.currentEvent ?? _generateChordEvent(settings: settings);
    final nextEvent =
        _queueState.nextEvent ??
        _generateChordEvent(settings: settings, currentEvent: currentEvent);
    _queueState = _queueState.copyWith(
      currentEvent: currentEvent,
      nextEvent: nextEvent,
    );
  }

  void _refreshLookAheadChord(PracticeSettings settings, {bool force = false}) {
    if (!settings.voicingSuggestionsEnabled || settings.lookAheadDepth < 2) {
      _queueState = _queueState.withLookAheadEvent(null);
      return;
    }
    final nextEvent = _nextChordEvent;
    if (nextEvent == null) {
      _queueState = _queueState.withLookAheadEvent(null);
      return;
    }
    if (_lookAheadChordEvent != null && !force) {
      return;
    }
    final displayedSymbols = <String>{};
    if (_currentChordEvent != null) {
      displayedSymbols.add(
        _displaySymbolForEvent(settings, _currentChordEvent),
      );
    }
    _queueState = _queueState.withLookAheadEvent(
      _generateChordEvent(
        settings: settings,
        exclusionContext: _buildExclusionContext(
          settings: settings,
          currentEvent: nextEvent,
          displayedSymbols: displayedSymbols,
        ),
        currentEvent: nextEvent,
      ),
    );
  }

  List<GeneratedChord> _voicingFutureChords() => [?_lookAheadChord];

  VoicingContext? _composeVoicingContext(
    PracticeSettings settings, {
    bool forceLookAheadRefresh = false,
  }) {
    final currentChord = _currentChord;
    if (!settings.voicingSuggestionsEnabled || currentChord == null) {
      return null;
    }
    _refreshLookAheadChord(settings, force: forceLookAheadRefresh);
    return VoicingContext(
      previousChord: _previousChord,
      currentChord: currentChord,
      nextChord: _nextChord,
      futureChords: _voicingFutureChords(),
      previousVoicing: _continuityReferenceVoicing,
      lockedVoicing: _lockedCurrentVoicing,
      preferredTopNotePitchClass: settings.voicingTopNotePreference.pitchClass,
      settings: settings,
      lookAheadDepth: settings.lookAheadDepth,
    );
  }

  VoicingSuggestionKind _preferredVoicingSuggestionKind(
    PracticeSettings settings,
  ) => switch (settings.preferredSuggestionKind) {
    DefaultVoicingSuggestionKind.natural => VoicingSuggestionKind.natural,
    DefaultVoicingSuggestionKind.colorful => VoicingSuggestionKind.colorful,
    DefaultVoicingSuggestionKind.easy => VoicingSuggestionKind.easy,
  };

  void _recomputeVoicingSuggestions(
    PracticeSettings settings, {
    bool forceLookAheadRefresh = false,
  }) {
    if (!settings.voicingSuggestionsEnabled || _currentChord == null) {
      _voicingState = _voicingState.clearRecommendations();
      return;
    }

    final context = _composeVoicingContext(
      settings,
      forceLookAheadRefresh: forceLookAheadRefresh,
    );
    if (context == null) {
      _voicingState = _voicingState.clearRecommendations();
      return;
    }

    final recommendations = VoicingEngine.recommend(context: context);
    _voicingState = _voicingState.applyRecommendations(
      recommendations,
      preferredKind: _preferredVoicingSuggestionKind(settings),
    );

    if (settings.smartDiagnosticsEnabled &&
        recommendations.suggestions.isNotEmpty) {
      final bestSuggestion = recommendations.suggestions.first;
      final diagnosticKey =
          '${context.currentChord.harmonicComparisonKey}|'
          '${bestSuggestion.voicing.signature}';
      if (_lastLoggedVoicingDiagnosticKey != diagnosticKey) {
        developer.log(
          '${context.diagnosticSummary} '
          '${bestSuggestion.voicing.noteNames.join('-')} '
          '${bestSuggestion.breakdown.describe()}',
          name: 'chordest.voicing',
        );
        _voicingState = _voicingState.markDiagnosticLogged(diagnosticKey);
      }
    } else {
      _voicingState = _voicingState.clearDiagnosticLog();
    }
  }
}

class _WeightedGeneratedChordCandidate {
  const _WeightedGeneratedChordCandidate({
    required this.chord,
    required this.weight,
  });

  final GeneratedChord chord;
  final int weight;
}
