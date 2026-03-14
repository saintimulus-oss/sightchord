import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio/beat_clock.dart';
import 'audio/harmony_audio_models.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/metronome_audio_service.dart';
import 'audio/sightchord_audio_scope.dart';
import 'l10n/app_localizations.dart';
import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'music/practice_chord_queue_state.dart';
import 'music/voicing_engine.dart';
import 'music/voicing_models.dart';
import 'music/voicing_session_state.dart';
import 'settings/practice_settings.dart';
import 'settings/practice_settings_effects.dart';
import 'settings/practice_settings_drawer.dart';
import 'settings/settings_controller.dart';
import 'smart_generator.dart';
import 'widgets/beat_indicator_row.dart';
import 'widgets/practice_overview_card.dart';
import 'widgets/voicing_suggestions_section.dart';

part 'practice_home_page_labels.dart';
part 'practice_home_page_ui.dart';

class _WeightedGeneratedChordCandidate {
  const _WeightedGeneratedChordCandidate({
    required this.chord,
    required this.weight,
  });

  final GeneratedChord chord;
  final int weight;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.controller});

  final String title;
  final AppSettingsController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _minBpm = PracticeSettings.minBpm;
  static const int _maxBpm = PracticeSettings.maxBpm;
  static const int _beatsPerBar = 4;
  static const Duration _scheduledMetronomeLookAhead = Duration(
    milliseconds: 120,
  );
  static const Duration _scheduledMetronomePollInterval = Duration(
    milliseconds: 25,
  );

  final Random _random = Random();
  late final MetronomeAudioService _metronomeAudio;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _bpmController;

  Timer? _autoTimer;
  Timer? _scheduledMetronomeTimer;
  Stopwatch? _autoStopwatch;
  BeatClock? _autoBeatClock;
  int? _currentBeat;
  int _nextScheduledMetronomeSequence = 0;
  bool _autoRunning = false;
  double? _scheduledMetronomeBaseTimeSeconds;
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;
  PracticeChordQueueState _queueState = const PracticeChordQueueState();
  VoicingSessionState _voicingState = const VoicingSessionState();

  PracticeSettings get _settings => widget.controller.settings;
  GeneratedChord? get _previousChord => _queueState.previousChord;
  GeneratedChord? get _currentChord => _queueState.currentChord;
  GeneratedChord? get _nextChord => _queueState.nextChord;
  GeneratedChord? get _lookAheadChord => _queueState.lookAheadChord;
  List<QueuedSmartChord> get _plannedSmartChordQueue =>
      _queueState.plannedSmartChordQueue;
  VoicingRecommendationSet? get _voicingRecommendations =>
      _voicingState.recommendations;
  ConcreteVoicing? get _lockedCurrentVoicing =>
      _voicingState.lockedCurrentVoicing;
  ConcreteVoicing? get _continuityReferenceVoicing =>
      _voicingState.continuityReferenceVoicing;
  String? get _lastLoggedVoicingDiagnosticKey =>
      _voicingState.lastLoggedDiagnosticKey;

  @override
  void initState() {
    super.initState();
    _metronomeAudio = MetronomeAudioService(logWarning: _logAudioWarning);
    _bpmController = TextEditingController(text: '${_settings.bpm}');
    unawaited(_initAudio());
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requestedHarmonyAudioWarmUp) {
      return;
    }
    final harmonyAudio = SightChordAudioScope.maybeOf(context);
    _harmonyAudio = harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    _requestedHarmonyAudioWarmUp = true;
    unawaited(harmonyAudio.warmUp());
  }

  Future<void> _initAudio() async {
    await _queueMetronomeSoundLoad(_settings.metronomeSound);
  }

  Future<void> _queueMetronomeSoundLoad(MetronomeSound sound) async {
    final result = await _metronomeAudio.queueSoundLoad(sound);
    if (!mounted) {
      return;
    }
    if (result.preciseAssetReloaded && _autoRunning) {
      _restartMetronomeScheduling(immediateFirstBeat: false);
    }
  }

  Duration _beatInterval() {
    return Duration(microseconds: (60000000 / _effectiveBpm()).round());
  }

  Duration _beatIndicatorAnimationDuration() {
    final beatMilliseconds = _beatInterval().inMilliseconds;
    final scaledMilliseconds = (beatMilliseconds * 0.42).round();
    final clampedMilliseconds = scaledMilliseconds.clamp(55, 180);
    return Duration(milliseconds: clampedMilliseconds);
  }

  int _effectiveBpm() {
    final parsed = int.tryParse(_bpmController.text) ?? _settings.bpm;
    return parsed.clamp(_minBpm, _maxBpm);
  }

  bool get _usesPreciseMetronomeScheduling =>
      _metronomeAudio.supportsPreciseScheduling;

  bool get _shouldScheduleMetronomeAhead =>
      _usesPreciseMetronomeScheduling &&
      _metronomeAudio.isReady &&
      _autoRunning &&
      _settings.metronomeEnabled;

  double get _beatIntervalSeconds =>
      _beatInterval().inMicroseconds / Duration.microsecondsPerSecond;

  double _elapsedSeconds(Duration duration) =>
      duration.inMicroseconds / Duration.microsecondsPerSecond;

  bool get _usesKeyMode => _settings.usesKeyMode;

  List<KeyCenter> get _orderedKeyCenters => [
    for (final mode in KeyMode.values)
      for (final center in MusicTheory.orderedKeyCentersForMode(mode))
        if (_settings.activeKeyCenters.contains(center)) center,
  ];

  void _applySettings(
    PracticeSettings nextSettings, {
    bool reseed = false,
    bool syncBpmText = false,
  }) {
    final previousSettings = _settings;
    if (nextSettings.metronomeSound != previousSettings.metronomeSound) {
      unawaited(_queueMetronomeSoundLoad(nextSettings.metronomeSound));
    }
    final forceLookAheadRefresh =
        !reseed &&
        PracticeSettingsEffects.shouldForceLookAheadRefresh(
          previousSettings,
          nextSettings,
        );
    unawaited(_persistSettingsUpdate(nextSettings));
    setState(() {
      if (syncBpmText) {
        _bpmController.text = '${nextSettings.bpm}';
      }
      if (reseed) {
        _reseedChordQueue();
      } else {
        _recomputeVoicingSuggestions(
          forceLookAheadRefresh: forceLookAheadRefresh,
        );
      }
    });
    if (_autoRunning && nextSettings.bpm != previousSettings.bpm) {
      _startAutoLoop(immediateFirstBeat: false);
    } else if (_autoRunning &&
        (_usesPreciseMetronomeScheduling ||
            nextSettings.metronomeEnabled !=
                previousSettings.metronomeEnabled)) {
      _restartMetronomeScheduling(immediateFirstBeat: false);
    }
  }

  Future<void> _persistSettingsUpdate(PracticeSettings nextSettings) async {
    try {
      await widget.controller.update(nextSettings);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'sightchord',
          context: ErrorDescription('while saving practice settings'),
        ),
      );
    }
  }

  Future<void> _playCurrentChordPreview({
    required HarmonyPlaybackPattern pattern,
  }) async {
    final currentChord = _currentChord;
    final harmonyAudio = _harmonyAudio;
    if (currentChord == null || harmonyAudio == null) {
      return;
    }
    await harmonyAudio.playGeneratedChord(
      currentChord,
      voicing: _authoritativeSelectedVoicing(),
      pattern: pattern,
    );
  }

  void _ensureChordQueueInitialized() {
    _queueState = _queueState.ensureNextChord(_generateChord());
    _refreshLookAheadChord();
  }

  void _reseedChordQueue() {
    _queueState = _queueState.reset();
    _voicingState = _voicingState.reset();
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
  }

  ChordExclusionContext _buildExclusionContext({
    GeneratedChord? current,
    Set<String> renderedSymbols = const <String>{},
  }) {
    final nextRenderedSymbols = <String>{...renderedSymbols};
    final repeatGuardKeys = <String>{};
    final harmonicComparisonKeys = <String>{};
    if (current != null) {
      nextRenderedSymbols.add(
        ChordRenderingHelper.renderedSymbol(
          current,
          _settings.chordSymbolStyle,
        ),
      );
      repeatGuardKeys.add(current.repeatGuardKey);
      harmonicComparisonKeys.add(current.harmonicComparisonKey);
    }
    return ChordExclusionContext(
      renderedSymbols: nextRenderedSymbols,
      repeatGuardKeys: repeatGuardKeys,
      harmonicComparisonKeys: harmonicComparisonKeys,
    );
  }

  String _renderedSymbolForChord(GeneratedChord chord) {
    return ChordRenderingHelper.renderedSymbol(
      chord,
      _settings.chordSymbolStyle,
    );
  }

  void _refreshLookAheadChord({bool force = false}) {
    if (!_settings.voicingSuggestionsEnabled || _settings.lookAheadDepth < 2) {
      _queueState = _queueState.withLookAheadChord(null);
      return;
    }
    final nextChord = _nextChord;
    if (nextChord == null) {
      _queueState = _queueState.withLookAheadChord(null);
      return;
    }
    if (_lookAheadChord != null && !force) {
      return;
    }
    final renderedSymbols = <String>{};
    if (_currentChord != null) {
      renderedSymbols.add(_renderedSymbolForChord(_currentChord!));
    }
    _queueState = _queueState.withLookAheadChord(
      _generateChord(
        exclusionContext: _buildExclusionContext(
          current: nextChord,
          renderedSymbols: renderedSymbols,
        ),
        current: nextChord,
      ),
    );
  }

  List<GeneratedChord> _voicingFutureChords() => [?_lookAheadChord];

  VoicingContext? _composeVoicingContext({bool forceLookAheadRefresh = false}) {
    final currentChord = _currentChord;
    if (!_settings.voicingSuggestionsEnabled || currentChord == null) {
      return null;
    }
    _refreshLookAheadChord(force: forceLookAheadRefresh);
    return VoicingContext(
      previousChord: _previousChord,
      currentChord: currentChord,
      nextChord: _nextChord,
      futureChords: _voicingFutureChords(),
      previousVoicing: _continuityReferenceVoicing,
      lockedVoicing: _lockedCurrentVoicing,
      preferredTopNotePitchClass: _settings.voicingTopNotePreference.pitchClass,
      settings: _settings,
      lookAheadDepth: _settings.lookAheadDepth,
    );
  }

  ConcreteVoicing? _authoritativeSelectedVoicing() {
    return _voicingState.authoritativeSelectedVoicing;
  }

  void _promoteChordQueue() {
    _voicingState = _voicingState.promoteChordQueue();
    final nextCurrentChord =
        _nextChord ?? _generateChord(current: _currentChord);
    final nextQueuedChord =
        _lookAheadChord ??
        _generateChord(
          exclusionContext: _buildExclusionContext(current: nextCurrentChord),
          current: nextCurrentChord,
        );
    _queueState = _queueState.promote(
      nextCurrentChord: nextCurrentChord,
      nextQueuedChord: nextQueuedChord,
    );
    _recomputeVoicingSuggestions();
  }

  void _recomputeVoicingSuggestions({bool forceLookAheadRefresh = false}) {
    if (!_settings.voicingSuggestionsEnabled || _currentChord == null) {
      _voicingState = _voicingState.clearRecommendations();
      return;
    }

    final context = _composeVoicingContext(
      forceLookAheadRefresh: forceLookAheadRefresh,
    );
    if (context == null) {
      _voicingState = _voicingState.clearRecommendations();
      return;
    }

    final recommendations = VoicingEngine.recommend(context: context);
    _voicingState = _voicingState.applyRecommendations(recommendations);

    if (_settings.smartDiagnosticsEnabled &&
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
          name: 'sightchord.voicing',
        );
        _voicingState = _voicingState.markDiagnosticLogged(diagnosticKey);
      }
    } else {
      _voicingState = _voicingState.clearDiagnosticLog();
    }
  }

  void _handleVoicingSelected(VoicingSuggestion suggestion) {
    setState(() {
      _voicingState = _voicingState.selectSuggestion(suggestion);
      if (_lockedCurrentVoicing != null) {
        _recomputeVoicingSuggestions();
      }
    });
  }

  void _handleVoicingLockToggle(VoicingSuggestion suggestion) {
    setState(() {
      _voicingState = _voicingState.toggleLock(suggestion);
      _recomputeVoicingSuggestions();
    });
  }

  bool _isExcludedCandidate(
    GeneratedChord candidate,
    ChordExclusionContext exclusionContext,
  ) {
    return exclusionContext.renderedSymbols.contains(
          ChordRenderingHelper.renderedSymbol(
            candidate,
            _settings.chordSymbolStyle,
          ),
        ) ||
        exclusionContext.repeatGuardKeys.contains(candidate.repeatGuardKey) ||
        exclusionContext.harmonicComparisonKeys.contains(
          candidate.harmonicComparisonKey,
        );
  }

  GeneratedChord _generateChord({
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? current,
  }) {
    if (!_usesKeyMode) {
      while (true) {
        final root = MusicTheory
            .freeModeRoots[_random.nextInt(MusicTheory.freeModeRoots.length)];
        final quality =
            MusicTheory.freeModeQualities[_random.nextInt(
              MusicTheory.freeModeQualities.length,
            )];
        final generatedChord = _buildFreeGeneratedChord(root, quality);
        if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keyCenters = _orderedKeyCenters;
    if (keyCenters.isEmpty) {
      return _buildGeneratedChord(
        MusicTheory.keyOptions.first,
        RomanNumeralId.iMaj7,
      );
    }
    if (_settings.smartGeneratorMode) {
      return _generateSmartChord(
        keyCenters: keyCenters,
        exclusionContext: exclusionContext,
        current: current,
      );
    }

    return _generateRandomKeyModeChord(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChord _buildFreeGeneratedChord(
    String root,
    ChordQuality quality, {
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    // Free mode has no Roman identity, so V7sus4 stays unavailable here.
    final renderQuality = quality;
    final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
      random: _random,
      root: root,
      harmonicQuality: quality,
      renderQuality: renderQuality,
      romanNumeralId: null,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      sourceKind: ChordSourceKind.free,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      suppressTensions: false,
      inversionSettings: _settings.inversionSettings,
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

  GeneratedChord _buildGeneratedChord(
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
      allowV7sus4: _settings.allowV7sus4,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      inversionSettings: _settings.inversionSettings,
      debugChordStyle: _settings.chordSymbolStyle,
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
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return comparison.selected.chord;
  }

  GeneratedChord _attachSmartDebug(
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
              _settings.chordSymbolStyle,
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

  GeneratedChord _emitSmartDebug(GeneratedChord chord) {
    final smartDebug = chord.smartDebug;
    if (smartDebug is SmartDecisionTrace) {
      SmartDiagnosticsStore.record(smartDebug);
      if (_settings.smartDiagnosticsEnabled) {
        developer.log(
          smartDebug.describe(),
          name: 'sightchord.smart_generator',
        );
      }
    }
    return chord;
  }

  Map<RomanNumeralId, int> _randomKeyModeRomanWeightsFor(KeyMode mode) {
    if (mode == KeyMode.minor) {
      return const {
        RomanNumeralId.iMinMaj7: 16,
        RomanNumeralId.iMin7: 14,
        RomanNumeralId.iMin6: 12,
        RomanNumeralId.iiHalfDiminishedMinor: 12,
        RomanNumeralId.flatIIIMaj7Minor: 10,
        RomanNumeralId.ivMin7Minor: 12,
        RomanNumeralId.vDom7: 16,
        RomanNumeralId.flatVIMaj7Minor: 10,
        RomanNumeralId.flatVIIDom7Minor: 10,
      };
    }

    final weights = <RomanNumeralId, int>{
      RomanNumeralId.iMaj7: 18,
      RomanNumeralId.iiMin7: 16,
      RomanNumeralId.iiiMin7: 10,
      RomanNumeralId.ivMaj7: 14,
      RomanNumeralId.vDom7: 18,
      RomanNumeralId.viMin7: 14,
      RomanNumeralId.viiHalfDiminished7: 10,
    };
    if (_settings.modalInterchangeEnabled) {
      weights.addAll(const {
        RomanNumeralId.borrowedIvMin7: 4,
        RomanNumeralId.borrowedFlatVII7: 3,
        RomanNumeralId.borrowedFlatVIMaj7: 3,
        RomanNumeralId.borrowedFlatIIIMaj7: 2,
        RomanNumeralId.borrowedIiHalfDiminished7: 2,
        RomanNumeralId.borrowedFlatIIMaj7: 1,
      });
    }
    if (_settings.secondaryDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.secondaryOfII: 5,
        RomanNumeralId.secondaryOfIII: 5,
        RomanNumeralId.secondaryOfIV: 5,
        RomanNumeralId.secondaryOfV: 5,
        RomanNumeralId.secondaryOfVI: 5,
      });
    }
    if (_settings.substituteDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.substituteOfII: 2,
        RomanNumeralId.substituteOfIII: 2,
        RomanNumeralId.substituteOfIV: 2,
        RomanNumeralId.substituteOfV: 2,
        RomanNumeralId.substituteOfVI: 2,
      });
    }
    return weights;
  }

  Map<RomanNumeralId, int> _diatonicRomanWeightsFor(KeyMode mode) => {
    for (final roman in MusicTheory.diatonicRomansForMode(mode)) roman: 1,
  };

  List<_WeightedGeneratedChordCandidate> _buildWeightedKeyModeCandidates({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    Map<RomanNumeralId, int> Function(KeyMode mode)? romanWeightsForMode,
  }) {
    return [
      for (final keyCenter in keyCenters)
        for (final entry
            in (romanWeightsForMode ?? _randomKeyModeRomanWeightsFor)(
              keyCenter.mode,
            ).entries)
          if (entry.value > 0)
            () {
              final chord = _buildGeneratedChord(
                keyCenter.tonicName,
                entry.key,
                keyCenter: keyCenter,
              );
              if (_isExcludedCandidate(chord, exclusionContext)) {
                return null;
              }
              return _WeightedGeneratedChordCandidate(
                chord: chord,
                weight: entry.value,
              );
            }(),
    ].whereType<_WeightedGeneratedChordCandidate>().toList();
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
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
  }) {
    final candidates = _buildWeightedKeyModeCandidates(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
    if (candidates.isNotEmpty) {
      return _pickWeightedChord(candidates);
    }
    final fallbackCenter = keyCenters.first;
    return _buildGeneratedChord(
      fallbackCenter.tonicName,
      fallbackCenter.mode == KeyMode.major
          ? RomanNumeralId.iMaj7
          : RomanNumeralId.iMin7,
      keyCenter: fallbackCenter,
    );
  }

  GeneratedChord _generateRandomDiatonicChord({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    KeyCenter? preferredKeyCenter,
  }) {
    final preferredCenters =
        preferredKeyCenter != null && keyCenters.contains(preferredKeyCenter)
        ? [preferredKeyCenter]
        : keyCenters;
    final preferredCandidates = _buildWeightedKeyModeCandidates(
      keyCenters: preferredCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: _diatonicRomanWeightsFor,
    );
    if (preferredCandidates.isNotEmpty) {
      return preferredCandidates[_random.nextInt(preferredCandidates.length)]
          .chord;
    }

    final fallbackCandidates = _buildWeightedKeyModeCandidates(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: _diatonicRomanWeightsFor,
    );
    if (fallbackCandidates.isNotEmpty) {
      return fallbackCandidates[_random.nextInt(fallbackCandidates.length)]
          .chord;
    }

    final fallbackCenter = keyCenters.first;
    return _buildGeneratedChord(
      fallbackCenter.tonicName,
      fallbackCenter.mode == KeyMode.major
          ? RomanNumeralId.iMaj7
          : RomanNumeralId.iMin7,
      keyCenter: fallbackCenter,
    );
  }

  GeneratedChord? _buildFamilyAwareFallbackChord({
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
      allowV7sus4: _settings.allowV7sus4,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      inversionSettings: _settings.inversionSettings,
      debugChordStyle: _settings.chordSymbolStyle,
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
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return null;
  }

  GeneratedChord _generateSmartChord({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? current,
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
          secondaryDominantEnabled: _settings.secondaryDominantEnabled,
          substituteDominantEnabled: _settings.substituteDominantEnabled,
          modalInterchangeEnabled: _settings.modalInterchangeEnabled,
          modulationIntensity: _settings.modulationIntensity,
          jazzPreset: _settings.jazzPreset,
          sourceProfile: _settings.sourceProfile,
          allowV7sus4: _settings.allowV7sus4,
          allowTensions: _settings.allowTensions,
          selectedTensionOptions: _settings.selectedTensionOptions,
          inversionSettings: _settings.inversionSettings,
          smartDiagnosticsEnabled: _settings.smartDiagnosticsEnabled,
        ),
      );
      _queueState = _queueState.withPlannedSmartChordQueue(
        initialPlan.remainingQueuedChords,
      );
      final seededChord = _buildGeneratedChord(
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
      if (!_isExcludedCandidate(seededChord, exclusionContext)) {
        return _emitSmartDebug(seededChord);
      }
      final initialFallback = _buildFamilyAwareFallbackChord(
        plan: initialPlan,
        exclusionContext: exclusionContext,
        previousChord: current,
      );
      if (initialFallback != null) {
        return _emitSmartDebug(initialFallback);
      }
      return _emitSmartDebug(
        _attachSmartDebug(
          _generateRandomKeyModeChord(
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

    final plan = SmartGeneratorHelper.planNextStep(
      random: _random,
      request: SmartStepRequest(
        stepIndex:
            ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1,
        activeKeys: activeKeys,
        selectedKeyCenters: keyCenters,
        currentKeyCenter:
            current.keyCenter ?? MusicTheory.keyCenterFor(current.keyName!),
        currentRomanNumeralId: currentRomanNumeralId,
        currentResolutionRomanNumeralId: currentResolutionRomanId,
        currentHarmonicFunction: current.harmonicFunction,
        secondaryDominantEnabled: _settings.secondaryDominantEnabled,
        substituteDominantEnabled: _settings.substituteDominantEnabled,
        modalInterchangeEnabled: _settings.modalInterchangeEnabled,
        modulationIntensity: _settings.modulationIntensity,
        jazzPreset: _settings.jazzPreset,
        sourceProfile: _settings.sourceProfile,
        allowV7sus4: _settings.allowV7sus4,
        allowTensions: _settings.allowTensions,
        selectedTensionOptions: _settings.selectedTensionOptions,
        inversionSettings: _settings.inversionSettings,
        smartDiagnosticsEnabled: _settings.smartDiagnosticsEnabled,
        previousRomanNumeralId: _previousChord?.romanNumeralId,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
        currentRenderedNonDiatonic: current.isRenderedNonDiatonic,
        currentTrace: current.smartDebug as SmartDecisionTrace?,
        phraseContext: SmartPhraseContext.rollingForm(
          ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1,
        ),
      ),
    );
    _queueState = _queueState.withPlannedSmartChordQueue(
      plan.remainingQueuedChords,
    );

    final generatedChord = _buildGeneratedChord(
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
    if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
      return _emitSmartDebug(generatedChord);
    }

    final familyAwareFallback = _buildFamilyAwareFallbackChord(
      plan: plan,
      exclusionContext: exclusionContext,
      previousChord: current,
    );
    if (familyAwareFallback != null) {
      return _emitSmartDebug(familyAwareFallback);
    }

    if (plan.patternTag != null) {
      _queueState = _queueState.clearPlannedSmartChordQueue();
    }
    final fallbackChord = _generateRandomDiatonicChord(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      preferredKeyCenter: keyCenters.contains(plan.finalKeyCenter)
          ? plan.finalKeyCenter
          : current.keyCenter,
    );
    return _emitSmartDebug(
      _attachSmartDebug(
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

  void _playMetronomeIfNeeded({bool fromAutoTick = false}) {
    if (!_settings.metronomeEnabled) {
      return;
    }
    if (fromAutoTick && _shouldScheduleMetronomeAhead) {
      return;
    }
    if (!_metronomeAudio.isReady) {
      return;
    }
    unawaited(_metronomeAudio.playNow(volume: _settings.metronomeVolume));
  }

  void _advanceChordUnawaited() {
    _advanceChord();
  }

  void _advanceChord() {
    if (!mounted) {
      return;
    }
    setState(() {
      _promoteChordQueue();
      _currentBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
    });
    _playMetronomeIfNeeded();
  }

  void _handleAutoTick() {
    if (!mounted) {
      return;
    }
    var shouldAdvanceChord = false;
    setState(() {
      final nextBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
      _currentBeat = nextBeat;
      shouldAdvanceChord = nextBeat == 0;
    });

    _playMetronomeIfNeeded(fromAutoTick: true);

    if (!mounted || !shouldAdvanceChord) {
      return;
    }

    setState(() {
      _promoteChordQueue();
    });
  }

  void _runDueAutoTicks() {
    if (!mounted || !_autoRunning) {
      return;
    }
    final beatClock = _autoBeatClock;
    final autoStopwatch = _autoStopwatch;
    if (beatClock == null || autoStopwatch == null) {
      return;
    }
    for (final _ in beatClock.consumeDueSequences(autoStopwatch.elapsed)) {
      if (!mounted || !_autoRunning) {
        return;
      }
      _handleAutoTick();
    }
    _scheduleAutoTimer();
  }

  void _restartMetronomeScheduling({required bool immediateFirstBeat}) {
    _scheduledMetronomeTimer?.cancel();
    _scheduledMetronomeBaseTimeSeconds = null;
    _nextScheduledMetronomeSequence = 0;
    _metronomeAudio.cancelScheduled();
    if (!mounted || !_shouldScheduleMetronomeAhead) {
      return;
    }
    unawaited(
      _startMetronomeScheduling(immediateFirstBeat: immediateFirstBeat),
    );
  }

  Future<void> _startMetronomeScheduling({
    required bool immediateFirstBeat,
  }) async {
    final prepared = await _metronomeAudio.ensurePreciseReady();
    if (!prepared) {
      return;
    }
    if (!mounted || !_shouldScheduleMetronomeAhead) {
      return;
    }
    final autoStopwatch = _autoStopwatch;
    final beatClock = _autoBeatClock;
    if (autoStopwatch == null || beatClock == null) {
      return;
    }

    if (immediateFirstBeat) {
      await _metronomeAudio.playNow(volume: _settings.metronomeVolume);
      if (!mounted || !_shouldScheduleMetronomeAhead) {
        return;
      }
    }

    final currentTimeSeconds = _metronomeAudio.currentTimeSeconds;
    if (currentTimeSeconds == null) {
      return;
    }
    _scheduledMetronomeBaseTimeSeconds =
        currentTimeSeconds - _elapsedSeconds(autoStopwatch.elapsed);
    _nextScheduledMetronomeSequence = max(
      beatClock.lastSequence + 1,
      immediateFirstBeat ? 1 : 0,
    );
    _fillScheduledMetronomeWindow();
    _scheduledMetronomeTimer?.cancel();
    _scheduledMetronomeTimer = Timer.periodic(
      _scheduledMetronomePollInterval,
      (_) => _fillScheduledMetronomeWindow(),
    );
  }

  void _fillScheduledMetronomeWindow() {
    if (!mounted || !_shouldScheduleMetronomeAhead) {
      return;
    }
    final baseTimeSeconds = _scheduledMetronomeBaseTimeSeconds;
    final currentTimeSeconds = _metronomeAudio.currentTimeSeconds;
    if (baseTimeSeconds == null || currentTimeSeconds == null) {
      return;
    }
    final horizonSeconds =
        currentTimeSeconds + _elapsedSeconds(_scheduledMetronomeLookAhead);
    while (true) {
      final beatTimeSeconds =
          baseTimeSeconds +
          (_nextScheduledMetronomeSequence * _beatIntervalSeconds);
      if (beatTimeSeconds > horizonSeconds) {
        break;
      }
      _metronomeAudio.scheduleAt(
        whenSeconds: beatTimeSeconds,
        volume: _settings.metronomeVolume,
      );
      _nextScheduledMetronomeSequence += 1;
    }
  }

  void _startAutoLoop({required bool immediateFirstBeat}) {
    _autoTimer?.cancel();
    _autoStopwatch = Stopwatch()..start();
    _autoBeatClock = BeatClock(
      interval: _beatInterval(),
      immediateFirstBeat: immediateFirstBeat,
    );
    _restartMetronomeScheduling(immediateFirstBeat: immediateFirstBeat);
    if (immediateFirstBeat) {
      _runDueAutoTicks();
      return;
    }
    _scheduleAutoTimer();
  }

  void _scheduleAutoTimer() {
    _autoTimer?.cancel();
    if (!mounted || !_autoRunning) {
      return;
    }
    final beatClock = _autoBeatClock;
    final autoStopwatch = _autoStopwatch;
    if (beatClock == null || autoStopwatch == null) {
      return;
    }
    _autoTimer = Timer(
      beatClock.delayUntilNext(autoStopwatch.elapsed),
      _runDueAutoTicks,
    );
  }

  void _stopAutoPlay({bool resetBeat = true}) {
    _autoTimer?.cancel();
    _scheduledMetronomeTimer?.cancel();
    _metronomeAudio.cancelScheduled();
    _autoStopwatch = null;
    _autoBeatClock = null;
    _scheduledMetronomeBaseTimeSeconds = null;
    _nextScheduledMetronomeSequence = 0;
    setState(() {
      _autoRunning = false;
      if (resetBeat) {
        _currentBeat = null;
      }
    });
  }

  void _startAutoPlay() {
    setState(() {
      _autoRunning = true;
      _currentBeat = null;
    });
    _startAutoLoop(immediateFirstBeat: true);
  }

  void _rescheduleAutoTimer() {
    if (!mounted || !_autoRunning) {
      return;
    }
    _startAutoLoop(immediateFirstBeat: false);
  }

  void _toggleAutoPlay() {
    if (_autoRunning) {
      _stopAutoPlay();
      return;
    }
    _startAutoPlay();
  }

  bool _isEditableTextFocused() {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext == null) {
      return false;
    }
    if (focusedContext.widget is EditableText) {
      return true;
    }
    return focusedContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  VoidCallback _guardGlobalShortcut(VoidCallback action) {
    return () {
      if (_isEditableTextFocused()) {
        return;
      }
      action();
    };
  }

  void _logAudioWarning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'sightchord.audio',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _adjustBpm(int delta) {
    final next = (_effectiveBpm() + delta).clamp(_minBpm, _maxBpm).toInt();
    _applySettings(_settings.copyWith(bpm: next), syncBpmText: true);
  }

  void _handleBpmChanged(String value) {
    if (_autoRunning && int.tryParse(value) != null) {
      _rescheduleAutoTimer();
    }
    setState(() {});
  }

  void _normalizeBpm() {
    final normalized = _effectiveBpm();
    _applySettings(_settings.copyWith(bpm: normalized), syncBpmText: true);
  }

  @override
  void dispose() {
    _autoRunning = false;
    _autoTimer?.cancel();
    _scheduledMetronomeTimer?.cancel();
    _bpmController.dispose();
    unawaited(_metronomeAudio.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildPracticeHomePage(context);
}
