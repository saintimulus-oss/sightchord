import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio/beat_clock.dart';
import 'audio/harmony_audio_models.dart';
import 'audio/harmony_preview_resolver.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/metronome_audio_service.dart';
import 'audio/sightchord_audio_scope.dart';
import 'l10n/app_localizations.dart';
import 'music/anchor_loop_layout.dart';
import 'music/anchor_loop_planner.dart';
import 'music/chord_anchor_loop.dart';
import 'music/chord_formatting.dart';
import 'music/chord_timing_models.dart';
import 'music/chord_theory.dart';
import 'music/harmonic_rhythm_planner.dart';
import 'music/melody_generator.dart';
import 'music/melody_models.dart';
import 'music/practice_chord_queue_state.dart';
import 'music/progression_analysis_models.dart';
import 'music/voicing_engine.dart';
import 'music/voicing_models.dart';
import 'music/voicing_session_state.dart';
import 'settings/practice_settings.dart';
import 'settings/practice_settings_effects.dart';
import 'settings/practice_advanced_settings_page.dart';
import 'settings/practice_setup_assistant.dart';
import 'settings/practice_settings_factory.dart';
import 'settings/practice_settings_drawer.dart';
import 'settings/settings_controller.dart';
import 'smart_generator.dart';
import 'widgets/beat_indicator_row.dart';
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

class _PracticeHistoryEntry {
  const _PracticeHistoryEntry({
    required this.queueState,
    required this.melodyState,
    required this.voicingState,
    required this.currentBeat,
    required this.melodyGenerationSeed,
  });

  final PracticeChordQueueState queueState;
  final PracticeMelodyQueueState melodyState;
  final VoicingSessionState voicingState;
  final int? currentBeat;
  final int melodyGenerationSeed;
}

@visibleForTesting
({int nextBeat, bool shouldAdvanceChord}) computeNextPracticeAutoBeat({
  required int? currentBeat,
  int beatCount = 4,
  int nextChangeBeat = 0,
}) {
  final nextBeat = ((currentBeat ?? -1) + 1) % beatCount;
  return (
    nextBeat: nextBeat,
    shouldAdvanceChord: currentBeat != null && nextBeat == nextChangeBeat,
  );
}

@visibleForTesting
bool shouldStartPracticeAutoplayImmediately(int? currentBeat) {
  return currentBeat == null;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.controller,
    this.onOpenStudyHarmony,
  });

  final String title;
  final AppSettingsController controller;
  final VoidCallback? onOpenStudyHarmony;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _minBpm = PracticeSettings.minBpm;
  static const int _maxBpm = PracticeSettings.maxBpm;
  static const int _practiceHistoryLimit = 24;
  static const double _combinedPlaybackChordGainScale = 0.74;
  static const double _combinedPlaybackMelodyGainScale = 1.24;
  static const double _combinedPlaybackGuideGainBoost = 0.08;
  static const int _combinedPlaybackMelodyVelocityBoost = 14;
  static const Duration _scheduledMetronomeLookAhead = Duration(
    milliseconds: 120,
  );
  static const Duration _scheduledMetronomePollInterval = Duration(
    milliseconds: 25,
  );

  final Random _random = Random();
  final AnchorLoopPlanner _anchorLoopPlanner = const AnchorLoopPlanner();
  late final MetronomeAudioService _metronomeAudio;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<_ChordSwipeSurfaceState> _chordSwipeSurfaceKey =
      GlobalKey<_ChordSwipeSurfaceState>();
  late final TextEditingController _bpmController;

  Timer? _autoTimer;
  Timer? _scheduledMetronomeTimer;
  Stopwatch? _autoStopwatch;
  BeatClock? _autoBeatClock;
  int? _currentBeat;
  int _nextScheduledMetronomeSequence = 0;
  int _scheduledMetronomeBeatSeed = 0;
  bool _autoRunning = false;
  bool _metronomePatternEditing = false;
  bool _practiceSessionInitialized = false;
  bool _showFirstRunWelcomeCard = false;
  double? _scheduledMetronomeBaseTimeSeconds;
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;
  AnchorCyclePlan? _cachedAnchorCyclePlan;
  KeyCenter? _anchorLoopSeedKeyCenter;
  PracticeChordQueueState _queueState = const PracticeChordQueueState();
  PracticeMelodyQueueState _melodyState = const PracticeMelodyQueueState();
  VoicingSessionState _voicingState = const VoicingSessionState();
  int _melodyGenerationSeed = 0;
  final List<_PracticeHistoryEntry> _practiceHistory =
      <_PracticeHistoryEntry>[];

  PracticeSettings get _settings => widget.controller.settings;
  ChordAnchorLoop get _anchorLoop => AnchorLoopLayout.sanitizeLoop(
    loop: _settings.anchorLoop,
    timeSignature: _settings.timeSignature,
    harmonicRhythmPreset: _settings.harmonicRhythmPreset,
  );
  bool get _hasAnchorLoop => _anchorLoop.hasEnabledSlots;
  int get _beatsPerBar => _settings.beatsPerBar;
  GeneratedChordEvent? get _currentChordEvent => _queueState.currentEvent;
  GeneratedChordEvent? get _nextChordEvent => _queueState.nextEvent;
  GeneratedChordEvent? get _lookAheadChordEvent => _queueState.lookAheadEvent;
  GeneratedChord? get _previousChord => _queueState.previousChord;
  GeneratedChord? get _currentChord => _queueState.currentChord;
  GeneratedChord? get _nextChord => _queueState.nextChord;
  GeneratedChord? get _lookAheadChord => _queueState.lookAheadChord;
  GeneratedMelodyEvent? get _currentMelodyEvent => _melodyState.currentEvent;
  GeneratedMelodyEvent? get _nextMelodyEvent => _melodyState.nextEvent;
  List<QueuedSmartChord> get _plannedSmartChordQueue =>
      _queueState.plannedSmartChordQueue;
  VoicingRecommendationSet? get _voicingRecommendations =>
      _voicingState.recommendations;
  PerformanceVoicingPreview? get _performanceVoicingPreview =>
      _voicingRecommendations?.performancePreview;
  ConcreteVoicing? get _lockedCurrentVoicing =>
      _voicingState.lockedCurrentVoicing;
  ConcreteVoicing? get _continuityReferenceVoicing =>
      _voicingState.continuityReferenceVoicing;
  String? get _lastLoggedVoicingDiagnosticKey =>
      _voicingState.lastLoggedDiagnosticKey;
  bool get _usesGuidedSettingsMode =>
      _settings.settingsComplexityMode == SettingsComplexityMode.guided;
  bool get _isSetupAssistantRequired => !_settings.guidedSetupCompleted;
  int get _nextChangeBeat => _nextChordEvent?.timing.changeBeat ?? 0;

  void _setMetronomePatternEditing(bool value) {
    if (!mounted || _metronomePatternEditing == value) {
      return;
    }
    setState(() {
      _metronomePatternEditing = value;
    });
  }

  KeyCenter? get _resolvedAnchorLoopSeedKeyCenter {
    final cachedSeed = _anchorLoopSeedKeyCenter;
    if (cachedSeed != null) {
      return cachedSeed;
    }
    if (_orderedKeyCenters.isNotEmpty) {
      _anchorLoopSeedKeyCenter = _orderedKeyCenters.first;
      return _anchorLoopSeedKeyCenter;
    }
    return null;
  }

  AnchorCyclePlan? get _activeAnchorCyclePlan {
    if (!_hasAnchorLoop) {
      return null;
    }
    return _cachedAnchorCyclePlan ??= _anchorLoopPlanner.buildCyclePlan(
      settings: _settings,
      loop: _anchorLoop,
      seedKeyCenter: _resolvedAnchorLoopSeedKeyCenter,
    );
  }

  void _invalidateAnchorLoopPlanCache() {
    _cachedAnchorCyclePlan = null;
    _anchorLoopSeedKeyCenter = null;
  }

  String _displaySymbolForEvent(GeneratedChordEvent? event) {
    if (event == null) {
      return '';
    }
    return event.displaySymbolOverride ??
        ChordRenderingHelper.renderedSymbol(
          event.chord,
          _settings.chordSymbolStyle,
        );
  }

  bool _preferFlatForMelodyEvent(GeneratedMelodyEvent? event) {
    final chord = event?.chordEvent.chord;
    if (chord == null) {
      return true;
    }
    return chord.keyCenter?.prefersFlatSpelling ??
        MusicTheory.prefersFlatSpellingForRoot(chord.symbolData.root);
  }

  String _previewTextForMelodyEvent(GeneratedMelodyEvent? event) {
    if (event == null || event.notes.isEmpty) {
      return '';
    }
    return event.previewText(preferFlat: _preferFlatForMelodyEvent(event));
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

  @override
  void initState() {
    super.initState();
    _metronomeAudio = MetronomeAudioService(logWarning: _logAudioWarning);
    _bpmController = TextEditingController(text: '${_settings.bpm}');
    unawaited(_initAudio());
    if (_isSetupAssistantRequired) {
      _showFirstRunWelcomeCard = true;
      _applySettings(
        PracticeSettingsFactory.beginnerSafePreset(baseSettings: _settings),
        reseed: true,
        syncBpmText: true,
      );
    } else {
      _initializePracticeSession();
    }
  }

  void _initializePracticeSession() {
    _practiceSessionInitialized = true;
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
  }

  Future<void> _runSetupAssistant({required bool mandatory}) async {
    if (!mounted) {
      return;
    }
    if (_autoRunning) {
      _stopAutoPlay();
    }
    final nextSettings = await showPracticeSetupAssistant(
      context: context,
      currentSettings: _settings,
      mandatory: mandatory,
      onOpenStudyHarmony: widget.onOpenStudyHarmony,
    );
    if (!mounted) {
      return;
    }
    final resolvedSettings =
        nextSettings ??
        (mandatory
            ? PracticeSettingsFactory.beginnerSafePreset(
                baseSettings: _settings,
              )
            : null);
    if (resolvedSettings == null) {
      return;
    }
    _applySettings(resolvedSettings, reseed: true, syncBpmText: true);
  }

  void _dismissFirstRunWelcomeCard() {
    if (!mounted || !_showFirstRunWelcomeCard) {
      return;
    }
    setState(() {
      _showFirstRunWelcomeCard = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final harmonyAudio = SightChordAudioScope.maybeOf(context);
    _harmonyAudio = harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    unawaited(_syncHarmonyAudioConfig(_settings));
    if (_requestedHarmonyAudioWarmUp) {
      return;
    }
    _requestedHarmonyAudioWarmUp = true;
    unawaited(harmonyAudio.warmUp());
  }

  Future<void> _initAudio() async {
    await Future.wait<void>([
      _queueMetronomeAudioLoad(_settings),
      _syncHarmonyAudioConfig(_settings),
    ]);
  }

  Future<void> _queueMetronomeAudioLoad(PracticeSettings settings) async {
    final result = await _metronomeAudio.queueSourceLoad(
      primarySource: settings.metronomeSource,
      accentSource: settings.metronomeAccentSource,
      useAccentSource: settings.metronomeUseAccentSound,
    );
    if (!mounted) {
      return;
    }
    if (result.preciseAssetReloaded && _autoRunning) {
      _restartMetronomeScheduling(immediateFirstBeat: false);
    }
  }

  Future<void> _syncHarmonyAudioConfig(PracticeSettings settings) async {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    await harmonyAudio.applyConfig(
      HarmonyAudioConfig(
        masterVolume: settings.harmonyMasterVolume,
        previewHoldFactor: settings.harmonyPreviewHoldFactor,
        arpeggioStepSpeed: settings.harmonyArpeggioStepSpeed,
        velocityHumanization: settings.harmonyVelocityHumanization,
        gainRandomness: settings.harmonyGainRandomness,
        timingHumanization: settings.harmonyTimingHumanization,
      ),
    );
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

  bool get _allowsSusDominantQualities =>
      _settings.allowV7sus4 &&
      _settings.enabledChordQualities.any(
        MusicTheory.susDominantQualities.contains,
      );

  Set<ChordQuality> get _activeChordQualities {
    final enabled = <ChordQuality>{
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (_settings.enabledChordQualities.contains(quality) &&
            (_usesKeyMode ||
                !MusicTheory.isKeyModeOnlyGeneratorQuality(quality)) &&
            (!_isSusDominantQuality(quality) || _allowsSusDominantQualities))
          quality,
    };
    if (enabled.isNotEmpty) {
      return enabled;
    }
    return {
      for (final quality in MusicTheory.defaultGeneratorChordQualities(
        allowV7sus4: _allowsSusDominantQualities,
      ))
        if (_usesKeyMode || !MusicTheory.isKeyModeOnlyGeneratorQuality(quality))
          quality,
    };
  }

  bool _isSusDominantQuality(ChordQuality quality) {
    return MusicTheory.susDominantQualities.contains(quality);
  }

  String _tonicRootForKeyCenter(KeyCenter keyCenter) {
    final tonicRoman = keyCenter.mode == KeyMode.major
        ? RomanNumeralId.iMaj7
        : RomanNumeralId.iMin7;
    return MusicTheory.resolveChordRootForCenter(keyCenter, tonicRoman);
  }

  GeneratedChord _fallbackGeneratedChord({KeyCenter? keyCenter}) {
    final quality = _activeChordQualities.first;
    final root = keyCenter == null
        ? MusicTheory.freeModeRoots.first
        : _tonicRootForKeyCenter(keyCenter);
    final safeQuality = quality == ChordQuality.dominant7sus4
        ? ChordQuality.dominant7
        : quality;
    return _buildFreeGeneratedChord(root, safeQuality);
  }

  GeneratedChord _fallbackKeyModeChord(List<KeyCenter> keyCenters) {
    for (final keyCenter in keyCenters) {
      for (final roman in SmartGeneratorHelper.diatonicRomansForPool(
        keyMode: keyCenter.mode,
        romanPoolPreset: _settings.romanPoolPreset,
      )) {
        final chord = _buildGeneratedChord(
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
      keyCenter: keyCenters.isEmpty ? null : keyCenters.first,
    );
  }

  ChordTimingSpec _initialTimingSpec() {
    return HarmonicRhythmPlanner.initialTiming(
      settings: _settings,
      anchorLoop: _anchorLoop,
    );
  }

  ChordTimingSpec _nextTimingSpec({
    required GeneratedChordEvent? currentEvent,
  }) {
    return HarmonicRhythmPlanner.nextTiming(
      settings: _settings,
      currentEvent: currentEvent,
      anchorLoop: _anchorLoop,
    );
  }

  SmartPhraseContext _phraseContextForTiming({
    required int stepIndex,
    required ChordTimingSpec timing,
  }) {
    return SmartPhraseContext.rollingForm(
      stepIndex,
      timeSignature: _settings.timeSignature,
      harmonicRhythmPreset: _settings.harmonicRhythmPreset,
      timing: timing,
    );
  }

  GeneratedChordEvent _eventForChord({
    required GeneratedChord chord,
    required ChordTimingSpec timing,
  }) {
    return GeneratedChordEvent(chord: chord, timing: timing);
  }

  int? _manualBeatStateForEvent(GeneratedChordEvent? event) {
    if (_settings.usesLegacyBarTiming) {
      return null;
    }
    return event?.timing.changeBeat;
  }

  int? _normalizeBeatForSettings(PracticeSettings settings, int? currentBeat) {
    if (currentBeat == null) {
      return null;
    }
    return currentBeat.clamp(0, settings.beatsPerBar - 1).toInt();
  }

  int _beatIndexForScheduledSequence(int sequence) {
    return (_scheduledMetronomeBeatSeed + sequence) % _beatsPerBar;
  }

  HarmonyPlaybackOverrides _autoPlayOverridesForEvent(
    GeneratedChordEvent event,
    HarmonyChordClip clip, {
    required HarmonyPlaybackPattern pattern,
  }) {
    final totalBeatMicros =
        _beatInterval().inMicroseconds * event.timing.durationBeats;
    final totalHoldFactor =
        (_settings.autoPlayHoldFactor * _settings.harmonyPreviewHoldFactor)
            .clamp(0.18, 2.0);
    final totalBudget = Duration(
      microseconds: max(1, (totalBeatMicros * totalHoldFactor).round()),
    );
    switch (pattern) {
      case HarmonyPlaybackPattern.block:
        final trimmedBudget = totalBudget - const Duration(milliseconds: 18);
        return HarmonyPlaybackOverrides(
          blockHold: trimmedBudget > const Duration(milliseconds: 70)
              ? trimmedBudget
              : const Duration(milliseconds: 70),
        );
      case HarmonyPlaybackPattern.arpeggio:
        final noteCount = max(1, clip.notes.length);
        final maxGapMicros = noteCount <= 1
            ? 0
            : (totalBudget.inMicroseconds * 0.24).round();
        final gapMicros = noteCount <= 1
            ? 0
            : (maxGapMicros / noteCount).round().clamp(0, 140000);
        final noteHoldMicros = max(
          50000,
          ((totalBudget.inMicroseconds - (gapMicros * max(0, noteCount - 1))) /
                  noteCount)
              .round()
              .clamp(50000, 420000),
        );
        return HarmonyPlaybackOverrides(
          arpeggioNoteHold: Duration(microseconds: noteHoldMicros),
          arpeggioGap: Duration(microseconds: gapMicros),
        );
    }
  }

  Future<void> _playEventChord(
    GeneratedChordEvent event, {
    required HarmonyPlaybackPattern pattern,
    bool isAutoPlay = false,
    ConcreteVoicing? preferredVoicing,
    GeneratedMelodyEvent? melodyEvent,
    MelodyPlaybackMode playbackMode = MelodyPlaybackMode.chordsOnly,
  }) async {
    await _playEventPreview(
      event: event,
      pattern: pattern,
      playbackMode: playbackMode,
      preferredVoicing: preferredVoicing,
      melodyEvent: melodyEvent,
      isAutoPlay: isAutoPlay,
    );
  }

  Future<void> _playAutoChordChangeForCurrentEvent() async {
    if (!_settings.autoPlayChordChanges) {
      return;
    }
    final currentEvent = _currentChordEvent;
    if (currentEvent == null) {
      return;
    }
    await _playEventChord(
      currentEvent,
      pattern: _settings.autoPlayPattern,
      isAutoPlay: true,
      preferredVoicing: _preferredPlaybackVoicing(),
      melodyEvent: _currentMelodyEvent,
      playbackMode: _autoPlaybackMode(),
    );
  }

  Future<void> _playUpcomingAutoChordChange(GeneratedChordEvent event) async {
    if (!_settings.autoPlayChordChanges) {
      return;
    }
    await _playEventChord(
      event,
      pattern: _settings.autoPlayPattern,
      isAutoPlay: true,
      preferredVoicing: _preferredUpcomingPlaybackVoicing(),
      melodyEvent: _nextMelodyEvent,
      playbackMode: _autoPlaybackMode(),
    );
  }

  void _applySettings(
    PracticeSettings nextSettings, {
    bool reseed = false,
    bool syncBpmText = false,
  }) {
    final previousSettings = _settings;
    _invalidateAnchorLoopPlanCache();
    if (nextSettings.metronomeSource != previousSettings.metronomeSource ||
        nextSettings.metronomeAccentSource !=
            previousSettings.metronomeAccentSource ||
        nextSettings.metronomeUseAccentSound !=
            previousSettings.metronomeUseAccentSound) {
      unawaited(_queueMetronomeAudioLoad(nextSettings));
    }
    if (PracticeSettingsEffects.harmonyAudioChanged(
      previousSettings,
      nextSettings,
    )) {
      unawaited(_syncHarmonyAudioConfig(nextSettings));
    }
    final shouldRegenerateMelody =
        !reseed &&
        PracticeSettingsEffects.melodyGenerationChanged(
          previousSettings,
          nextSettings,
        );
    final forceLookAheadRefresh =
        !reseed &&
        PracticeSettingsEffects.shouldForceLookAheadRefresh(
          previousSettings,
          nextSettings,
        );
    unawaited(_persistSettingsUpdate(nextSettings));
    setState(() {
      _practiceHistory.clear();
      _currentBeat = _normalizeBeatForSettings(nextSettings, _currentBeat);
      if (syncBpmText) {
        _bpmController.text = '${nextSettings.bpm}';
      }
      if (reseed) {
        _reseedChordQueue();
      } else {
        if (shouldRegenerateMelody) {
          _melodyGenerationSeed += 1;
          _rebuildMelodyQueue();
        } else if (!nextSettings.melodyGenerationEnabled) {
          _melodyState = _melodyState.reset();
        }
        _recomputeVoicingSuggestions(
          forceLookAheadRefresh: forceLookAheadRefresh,
        );
      }
    });
    if (_autoRunning &&
        (nextSettings.bpm != previousSettings.bpm ||
            nextSettings.timeSignature != previousSettings.timeSignature ||
            nextSettings.harmonicRhythmPreset !=
                previousSettings.harmonicRhythmPreset)) {
      _startAutoLoop(immediateFirstBeat: false);
    } else if (_autoRunning &&
        PracticeSettingsEffects.metronomeAudioChanged(
          previousSettings,
          nextSettings,
        )) {
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
          library: 'chordest',
          context: ErrorDescription('while saving practice settings'),
        ),
      );
    }
  }

  GeneratedMelodyEvent _generateMelodyEvent({
    required GeneratedChordEvent chordEvent,
    GeneratedChordEvent? previousChordEvent,
    GeneratedChordEvent? nextChordEvent,
    GeneratedChordEvent? lookAheadChordEvent,
    GeneratedMelodyEvent? previousMelodyEvent,
    List<GeneratedMelodyEvent>? recentMelodyEvents,
    List<GeneratedChordEvent>? phraseChordWindow,
    int? phraseWindowIndex,
  }) {
    return MelodyGenerator.generateEvent(
      request: MelodyGenerationRequest(
        chordEvent: chordEvent,
        previousChordEvent: previousChordEvent,
        nextChordEvent: nextChordEvent,
        lookAheadChordEvent: lookAheadChordEvent,
        previousMelodyEvent: previousMelodyEvent,
        recentMelodyEvents:
            recentMelodyEvents ?? const <GeneratedMelodyEvent>[],
        phraseChordWindow: phraseChordWindow ?? const <GeneratedChordEvent>[],
        phraseWindowIndex: phraseWindowIndex,
        settings: _settings,
        seed: _melodyGenerationSeed,
      ),
    );
  }

  ({List<GeneratedChordEvent> events, int currentIndex}) _phraseWindowFor({
    GeneratedChordEvent? previousChordEvent,
    required GeneratedChordEvent chordEvent,
    GeneratedChordEvent? nextChordEvent,
    GeneratedChordEvent? lookAheadChordEvent,
  }) {
    final events = <GeneratedChordEvent>[
      ?previousChordEvent,
      chordEvent,
      ?nextChordEvent,
      ?lookAheadChordEvent,
    ];
    final currentIndex = previousChordEvent == null ? 0 : 1;
    return (events: events, currentIndex: currentIndex);
  }

  List<GeneratedMelodyEvent> _recentMelodyHistory({int limit = 4}) {
    final history = <GeneratedMelodyEvent>[
      for (final entry in _practiceHistory)
        if (entry.melodyState.currentEvent
            case final GeneratedMelodyEvent event)
          event,
    ];
    if (history.length <= limit) {
      return history;
    }
    return history.sublist(history.length - limit);
  }

  void _rebuildMelodyQueue() {
    if (!_settings.melodyGenerationEnabled) {
      _melodyState = _melodyState.reset();
      return;
    }

    GeneratedMelodyEvent? build(
      GeneratedChordEvent? chordEvent, {
      GeneratedChordEvent? previousChordEvent,
      GeneratedChordEvent? nextChordEvent,
      GeneratedChordEvent? lookAheadChordEvent,
      GeneratedMelodyEvent? previousMelodyEvent,
      List<GeneratedMelodyEvent>? recentMelodyEvents,
    }) {
      if (chordEvent == null) {
        return null;
      }
      final phraseWindow = _phraseWindowFor(
        previousChordEvent: previousChordEvent,
        chordEvent: chordEvent,
        nextChordEvent: nextChordEvent,
        lookAheadChordEvent: lookAheadChordEvent,
      );
      return _generateMelodyEvent(
        chordEvent: chordEvent,
        previousChordEvent: previousChordEvent,
        nextChordEvent: nextChordEvent,
        lookAheadChordEvent: lookAheadChordEvent,
        previousMelodyEvent: previousMelodyEvent,
        recentMelodyEvents: recentMelodyEvents,
        phraseChordWindow: phraseWindow.events,
        phraseWindowIndex: phraseWindow.currentIndex,
      );
    }

    List<GeneratedMelodyEvent> appendRecent(
      List<GeneratedMelodyEvent> recent,
      GeneratedMelodyEvent? event,
    ) {
      if (event == null) {
        return recent;
      }
      final next = <GeneratedMelodyEvent>[
        ...recent.where(
          (candidate) => candidate.signatureHash != event.signatureHash,
        ),
        event,
      ];
      if (next.length <= 4) {
        return next;
      }
      return next.sublist(next.length - 4);
    }

    final baseRecentMelodies = _recentMelodyHistory();
    final previousMelody = build(
      _queueState.previousEvent,
      recentMelodyEvents: baseRecentMelodies,
      nextChordEvent: _queueState.currentEvent,
      lookAheadChordEvent: _queueState.nextEvent,
    );
    final currentRecentMelodies = appendRecent(
      baseRecentMelodies,
      previousMelody,
    );
    final currentMelody = build(
      _currentChordEvent,
      previousChordEvent: _queueState.previousEvent,
      nextChordEvent: _nextChordEvent,
      lookAheadChordEvent: _lookAheadChordEvent,
      previousMelodyEvent: previousMelody,
      recentMelodyEvents: currentRecentMelodies,
    );
    final nextRecentMelodies = appendRecent(
      currentRecentMelodies,
      currentMelody,
    );
    final nextMelody = build(
      _nextChordEvent,
      previousChordEvent: _currentChordEvent,
      nextChordEvent: _lookAheadChordEvent,
      lookAheadChordEvent: null,
      previousMelodyEvent: currentMelody ?? previousMelody,
      recentMelodyEvents: nextRecentMelodies,
    );
    final lookAheadRecentMelodies = appendRecent(
      nextRecentMelodies,
      nextMelody,
    );
    final lookAheadMelody = build(
      _lookAheadChordEvent,
      previousChordEvent: _nextChordEvent,
      previousMelodyEvent: nextMelody ?? currentMelody ?? previousMelody,
      recentMelodyEvents: lookAheadRecentMelodies,
    );
    _melodyState = PracticeMelodyQueueState(
      previousEvent: previousMelody,
      currentEvent: currentMelody,
      nextEvent: nextMelody,
      lookAheadEvent: lookAheadMelody,
    );
  }

  MelodyPlaybackMode _autoPlaybackMode() {
    if (_settings.melodyGenerationEnabled &&
        _settings.autoPlayMelodyWithChords) {
      return MelodyPlaybackMode.both;
    }
    return MelodyPlaybackMode.chordsOnly;
  }

  bool _playbackModeUsesChord(MelodyPlaybackMode mode) {
    return mode == MelodyPlaybackMode.chordsOnly ||
        mode == MelodyPlaybackMode.both;
  }

  bool _playbackModeUsesMelody(MelodyPlaybackMode mode) {
    return mode == MelodyPlaybackMode.melodyOnly ||
        mode == MelodyPlaybackMode.both;
  }

  HarmonyMelodyClip _melodyClipForEvent(
    GeneratedMelodyEvent melodyEvent, {
    bool emphasizeLead = false,
  }) {
    final beatMicros = _beatInterval().inMicroseconds;

    Duration durationFromBeats(double beats) {
      return Duration(microseconds: max(1, (beatMicros * beats).round()));
    }

    return HarmonyMelodyClip(
      label: _displaySymbolForEvent(melodyEvent.chordEvent),
      notes: [
        for (final note in melodyEvent.notes)
          HarmonyMelodyNote(
            midiNote: note.midiNote,
            startOffset: durationFromBeats(note.startBeatOffset),
            duration: durationFromBeats(note.durationBeats),
            velocity: emphasizeLead
                ? (note.velocity + _combinedPlaybackMelodyVelocityBoost)
                      .clamp(1, 127)
                      .toInt()
                : note.velocity,
            gain: emphasizeLead ? _emphasizedMelodyGain(note) : note.gain,
            toneLabel: note.toneLabel,
          ),
      ],
    );
  }

  double _emphasizedMelodyGain(GeneratedMelodyNote note) {
    final roleBoost = switch (note.role) {
      MelodyNoteRole.guideTone ||
      MelodyNoteRole.stableTension ||
      MelodyNoteRole.anticipation => _combinedPlaybackGuideGainBoost,
      _ => 0.0,
    };
    return (note.gain * _combinedPlaybackMelodyGainScale + roleBoost)
        .clamp(0.35, 1.55)
        .toDouble();
  }

  HarmonyChordClip _softenChordClipForCombinedPlayback(HarmonyChordClip clip) {
    return HarmonyChordClip(
      label: clip.label,
      notes: [
        for (final note in clip.notes)
          HarmonyPreviewNote(
            midiNote: note.midiNote,
            velocity: note.velocity,
            gain: (note.gain * _combinedPlaybackChordGainScale)
                .clamp(0.2, 1.0)
                .toDouble(),
            toneLabel: note.toneLabel,
          ),
      ],
    );
  }

  Future<void> _playEventPreview({
    required GeneratedChordEvent event,
    required HarmonyPlaybackPattern pattern,
    required MelodyPlaybackMode playbackMode,
    ConcreteVoicing? preferredVoicing,
    GeneratedMelodyEvent? melodyEvent,
    bool isAutoPlay = false,
  }) async {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    final baseChordClip = _playbackModeUsesChord(playbackMode)
        ? HarmonyPreviewResolver.auditionClipForGeneratedChord(
            event.chord,
            preferredVoicing: preferredVoicing,
          )
        : null;
    final includesMelody =
        _playbackModeUsesMelody(playbackMode) && melodyEvent != null;
    final chordClip = baseChordClip != null && includesMelody
        ? _softenChordClipForCombinedPlayback(baseChordClip)
        : baseChordClip;
    final compositeClip = HarmonyCompositeClip(
      chordClip: chordClip,
      melodyClip: includesMelody
          ? _melodyClipForEvent(melodyEvent, emphasizeLead: chordClip != null)
          : null,
      label: _displaySymbolForEvent(event),
    );
    if (compositeClip.isEmpty) {
      return;
    }
    await harmonyAudio.playCompositeClip(
      compositeClip,
      pattern: pattern,
      overrides: isAutoPlay && chordClip != null
          ? _autoPlayOverridesForEvent(event, chordClip, pattern: pattern)
          : null,
    );
  }

  Future<void> _playCurrentChordPreview({
    required HarmonyPlaybackPattern pattern,
  }) async {
    final currentEvent = _currentChordEvent;
    if (currentEvent == null) {
      return;
    }
    _dismissFirstRunWelcomeCard();
    await _playEventPreview(
      event: currentEvent,
      pattern: pattern,
      playbackMode: _settings.melodyPlaybackMode,
      preferredVoicing: _preferredPlaybackVoicing(),
      melodyEvent: _currentMelodyEvent,
    );
  }

  Future<void> _playVoicingSuggestionPreview(
    VoicingSuggestion suggestion,
  ) async {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    await harmonyAudio.playClip(
      HarmonyPreviewResolver.fromVoicing(
        suggestion.voicing,
        label: suggestion.label,
      ),
    );
  }

  void _ensureChordQueueInitialized() {
    final currentEvent = _queueState.currentEvent ?? _generateChordEvent();
    final nextEvent =
        _queueState.nextEvent ??
        _generateChordEvent(currentEvent: currentEvent);
    _queueState = _queueState.copyWith(
      currentEvent: currentEvent,
      nextEvent: nextEvent,
    );
    _refreshLookAheadChord();
    _rebuildMelodyQueue();
  }

  void _reseedChordQueue() {
    _practiceSessionInitialized = true;
    _practiceHistory.clear();
    _invalidateAnchorLoopPlanCache();
    _melodyGenerationSeed += 1;
    _queueState = _queueState.reset();
    _melodyState = _melodyState.reset();
    _voicingState = _voicingState.reset();
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
  }

  void _recordPracticeHistory() {
    if (_practiceHistory.length == _practiceHistoryLimit) {
      _practiceHistory.removeAt(0);
    }
    _practiceHistory.add(
      _PracticeHistoryEntry(
        queueState: _queueState,
        melodyState: _melodyState,
        voicingState: _voicingState,
        currentBeat: _currentBeat,
        melodyGenerationSeed: _melodyGenerationSeed,
      ),
    );
  }

  void _regenerateCurrentMelody() {
    if (!_settings.melodyGenerationEnabled) {
      return;
    }
    setState(() {
      _melodyGenerationSeed += 1;
      _rebuildMelodyQueue();
    });
  }

  void _restorePreviousChord({bool playAutoPreview = false}) {
    if (!mounted || _practiceHistory.isEmpty) {
      return;
    }
    final shouldRestartAutoLoop = _autoRunning;
    final snapshot = _practiceHistory.removeLast();
    setState(() {
      _queueState = snapshot.queueState;
      _melodyState = snapshot.melodyState;
      _voicingState = snapshot.voicingState;
      _melodyGenerationSeed = snapshot.melodyGenerationSeed;
      _currentBeat = _settings.usesLegacyBarTiming
          ? null
          : _normalizeBeatForSettings(_settings, snapshot.currentBeat);
    });
    if (playAutoPreview) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_playAutoChordChangeForCurrentEvent());
      });
    }
    if (shouldRestartAutoLoop) {
      _startAutoLoop(immediateFirstBeat: false);
    }
  }

  ChordExclusionContext _buildExclusionContext({
    GeneratedChordEvent? currentEvent,
    Set<String> displayedSymbols = const <String>{},
  }) {
    final nextTiming = currentEvent == null
        ? _initialTimingSpec()
        : _nextTimingSpec(currentEvent: currentEvent);
    final nextRenderedSymbols = <String>{...displayedSymbols};
    final repeatGuardKeys = <String>{};
    final harmonicComparisonKeys = <String>{};
    final current = currentEvent?.chord;
    if (current != null) {
      nextRenderedSymbols.add(_displaySymbolForEvent(currentEvent));
      repeatGuardKeys.add(current.repeatGuardKey);
      harmonicComparisonKeys.add(current.harmonicComparisonKey);
    }
    return ChordExclusionContext(
      renderedSymbols: nextRenderedSymbols,
      repeatGuardKeys: repeatGuardKeys,
      harmonicComparisonKeys: harmonicComparisonKeys,
      allowConsecutiveRepeat: _allowsConsecutiveRepeatForTiming(nextTiming),
    );
  }

  bool _allowsConsecutiveRepeatForTiming(ChordTimingSpec timing) {
    return SmartGeneratorHelper.allowsConsecutiveRepeat(
      harmonicRhythmPreset: _settings.harmonicRhythmPreset,
      phraseContext: _phraseContextForTiming(
        stepIndex: timing.barIndex,
        timing: timing,
      ),
    );
  }

  void _refreshLookAheadChord({bool force = false}) {
    if (!_settings.voicingSuggestionsEnabled || _settings.lookAheadDepth < 2) {
      _queueState = _queueState.withLookAheadEvent(null);
      _rebuildMelodyQueue();
      return;
    }
    final nextEvent = _nextChordEvent;
    if (nextEvent == null) {
      _queueState = _queueState.withLookAheadEvent(null);
      _rebuildMelodyQueue();
      return;
    }
    if (_lookAheadChordEvent != null && !force) {
      return;
    }
    final displayedSymbols = <String>{};
    if (_currentChordEvent != null) {
      displayedSymbols.add(_displaySymbolForEvent(_currentChordEvent));
    }
    _queueState = _queueState.withLookAheadEvent(
      _generateChordEvent(
        exclusionContext: _buildExclusionContext(
          currentEvent: nextEvent,
          displayedSymbols: displayedSymbols,
        ),
        currentEvent: nextEvent,
      ),
    );
    _rebuildMelodyQueue();
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

  ConcreteVoicing? _performanceRepresentativeVoicing() {
    return _performanceVoicingPreview?.representativeVoicing;
  }

  ConcreteVoicing? _preferredPlaybackVoicing() {
    final performanceVoicing = _performanceRepresentativeVoicing();
    if (_settings.voicingDisplayMode == VoicingDisplayMode.performance &&
        performanceVoicing != null) {
      return performanceVoicing;
    }
    return _authoritativeSelectedVoicing() ??
        (_voicingRecommendations != null &&
                _voicingRecommendations!.suggestions.isNotEmpty
            ? _voicingRecommendations!.suggestions.first.voicing
            : null);
  }

  ConcreteVoicing? _preferredUpcomingPlaybackVoicing() {
    if (_settings.voicingDisplayMode != VoicingDisplayMode.performance) {
      return null;
    }
    return _performanceVoicingPreview?.nextVoicing;
  }

  String? _displayedVoicingSignature() {
    if (_settings.voicingDisplayMode == VoicingDisplayMode.performance) {
      return _performanceRepresentativeVoicing()?.signature ??
          _authoritativeSelectedVoicing()?.signature;
    }
    return _authoritativeSelectedVoicing()?.signature;
  }

  VoicingSuggestionKind get _preferredVoicingSuggestionKind =>
      switch (_settings.preferredSuggestionKind) {
        DefaultVoicingSuggestionKind.natural => VoicingSuggestionKind.natural,
        DefaultVoicingSuggestionKind.colorful => VoicingSuggestionKind.colorful,
        DefaultVoicingSuggestionKind.easy => VoicingSuggestionKind.easy,
      };

  void _promoteChordQueue() {
    _voicingState = _voicingState.promoteChordQueue();
    final nextCurrentEvent =
        _nextChordEvent ??
        _generateChordEvent(currentEvent: _currentChordEvent);
    final nextQueuedEvent =
        _lookAheadChordEvent ??
        _generateChordEvent(
          exclusionContext: _buildExclusionContext(
            currentEvent: nextCurrentEvent,
          ),
          currentEvent: nextCurrentEvent,
        );
    _queueState = _queueState.promote(
      nextCurrentEvent: nextCurrentEvent,
      nextQueuedEvent: nextQueuedEvent,
    );
    _rebuildMelodyQueue();
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
    _voicingState = _voicingState.applyRecommendations(
      recommendations,
      preferredKind: _preferredVoicingSuggestionKind,
    );

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
          name: 'chordest.voicing',
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
    final blockedByRenderedSymbol = exclusionContext.renderedSymbols.contains(
      ChordRenderingHelper.renderedSymbol(
        candidate,
        _settings.chordSymbolStyle,
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

  GeneratedChord _buildParsedGeneratedChord({
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
        keyCenter.tonicName,
        romanNumeralId,
        keyCenter: keyCenter,
        previousChord: previousChord,
        exclusionContext: exclusionContext,
      );
      if (generated != null &&
          !_isExcludedCandidate(generated, exclusionContext)) {
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
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: keyCenter?.tonicName,
      romanNumeralId: romanNumeralId,
      harmonicFunction: resolvedFunction,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      symbolData: symbolData,
      sourceKind: resolvedSourceKind,
      appliedType: appliedType,
      resolutionTargetRomanId: romanNumeralId == null || keyCenter == null
          ? null
          : MusicTheory.modeAwareResolutionTarget(
              romanNumeralId,
              keyCenter.mode,
            ),
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
          resolutionTargetRomanId: romanNumeralId == null || keyCenter == null
              ? null
              : MusicTheory.modeAwareResolutionTarget(
                  romanNumeralId,
                  keyCenter.mode,
                ),
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
      resolutionTargetRomanId: romanNumeralId == null || keyCenter == null
          ? null
          : MusicTheory.modeAwareResolutionTarget(
              romanNumeralId,
              keyCenter.mode,
            ),
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
    required ChordTimingSpec timing,
    required ChordExclusionContext exclusionContext,
    GeneratedChordEvent? currentEvent,
  }) {
    final cyclePlan = _activeAnchorCyclePlan;
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

    final chosenAlternative =
        _anchorLoop.varyNonAnchorSlots &&
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
          _anchorLoop.varyNonAnchorSlots &&
          chosenAlternative == null &&
          analysis.romanNumeralId != null &&
          keyCenter != null,
    );
    if (_isExcludedCandidate(chord, exclusionContext)) {
      return null;
    }
    _queueState = _queueState.clearPlannedSmartChordQueue();
    return GeneratedChordEvent(chord: chord, timing: timing);
  }

  GeneratedChord _generateChord({
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? current,
    ChordTimingSpec? timing,
  }) {
    if (!_usesKeyMode) {
      final qualities = _activeChordQualities.toList(growable: false);
      while (true) {
        final root = MusicTheory
            .freeModeRoots[_random.nextInt(MusicTheory.freeModeRoots.length)];
        final quality = qualities[_random.nextInt(qualities.length)];
        final generatedChord = _buildFreeGeneratedChord(root, quality);
        if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keyCenters = _orderedKeyCenters;
    if (keyCenters.isEmpty) {
      return _fallbackGeneratedChord();
    }
    if (_settings.smartGeneratorMode) {
      return _generateSmartChord(
        keyCenters: keyCenters,
        exclusionContext: exclusionContext,
        current: current,
        timing: timing,
      );
    }

    return _generateRandomKeyModeChord(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChordEvent _generateChordEvent({
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChordEvent? currentEvent,
  }) {
    final timing = currentEvent == null
        ? _initialTimingSpec()
        : _nextTimingSpec(currentEvent: currentEvent);
    final anchorEvent = _buildAnchorLoopEvent(
      timing: timing,
      exclusionContext: exclusionContext,
      currentEvent: currentEvent,
    );
    if (anchorEvent != null) {
      return anchorEvent;
    }
    final chord = _generateChord(
      exclusionContext: exclusionContext,
      current: currentEvent?.chord,
      timing: timing,
    );
    return _eventForChord(chord: chord, timing: timing);
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
      chordLanguageLevel: _settings.chordLanguageLevel,
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
      allowV7sus4: _allowsSusDominantQualities,
      allowedRenderQualities: _activeChordQualities,
      allowTensions: _settings.allowTensions,
      chordLanguageLevel: _settings.chordLanguageLevel,
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
    if (comparison.rankedCandidates.isEmpty) {
      return null;
    }
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
        developer.log(smartDebug.describe(), name: 'chordest.smart_generator');
      }
    }
    return chord;
  }

  Map<RomanNumeralId, int> _randomKeyModeRomanWeightsFor(KeyMode mode) {
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
    if (mode == KeyMode.major && _settings.modalInterchangeEnabled) {
      weights.addAll(const {
        RomanNumeralId.borrowedIvMin7: 4,
        RomanNumeralId.borrowedFlatVII7: 3,
        RomanNumeralId.borrowedFlatVIMaj7: 3,
        RomanNumeralId.borrowedFlatIIIMaj7: 2,
        RomanNumeralId.borrowedIiHalfDiminished7: 2,
        RomanNumeralId.borrowedFlatIIMaj7: 1,
      });
    }
    if (mode == KeyMode.major && _settings.secondaryDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.secondaryOfII: 5,
        RomanNumeralId.secondaryOfIII: 5,
        RomanNumeralId.secondaryOfIV: 5,
        RomanNumeralId.secondaryOfV: 5,
        RomanNumeralId.secondaryOfVI: 5,
      });
    }
    if (mode == KeyMode.major && _settings.substituteDominantEnabled) {
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
          romanPoolPreset: _settings.romanPoolPreset,
        ))
          entry.key: entry.value,
    };
    return filtered.isNotEmpty ? filtered : _diatonicRomanWeightsFor(mode);
  }

  Map<RomanNumeralId, int> _diatonicRomanWeightsFor(KeyMode mode) => {
    for (final roman in SmartGeneratorHelper.diatonicRomansForPool(
      keyMode: mode,
      romanPoolPreset: _settings.romanPoolPreset,
    ))
      roman: 1,
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
              if (chord == null) {
                return null;
              }
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
    return _fallbackKeyModeChord(keyCenters);
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
    return _fallbackKeyModeChord(preferredCenters);
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
      allowV7sus4: _allowsSusDominantQualities,
      allowedRenderQualities: _activeChordQualities,
      allowTensions: _settings.allowTensions,
      chordLanguageLevel: _settings.chordLanguageLevel,
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
    if (comparison.rankedCandidates.isEmpty) {
      return null;
    }
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
          secondaryDominantEnabled: _settings.secondaryDominantEnabled,
          substituteDominantEnabled: _settings.substituteDominantEnabled,
          modalInterchangeEnabled: _settings.modalInterchangeEnabled,
          modulationIntensity: _settings.modulationIntensity,
          jazzPreset: _settings.jazzPreset,
          sourceProfile: _settings.sourceProfile,
          allowV7sus4: _allowsSusDominantQualities,
          allowTensions: _settings.allowTensions,
          chordLanguageLevel: _settings.chordLanguageLevel,
          romanPoolPreset: _settings.romanPoolPreset,
          selectedTensionOptions: _settings.selectedTensionOptions,
          inversionSettings: _settings.inversionSettings,
          timeSignature: _settings.timeSignature,
          harmonicRhythmPreset: _settings.harmonicRhythmPreset,
          initialTiming: timing,
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
      if (seededChord != null &&
          !_isExcludedCandidate(seededChord, exclusionContext)) {
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
    final stepIndex =
        ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1;
    final phraseContext = timing == null
        ? null
        : _phraseContextForTiming(stepIndex: stepIndex, timing: timing);

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
        secondaryDominantEnabled: _settings.secondaryDominantEnabled,
        substituteDominantEnabled: _settings.substituteDominantEnabled,
        modalInterchangeEnabled: _settings.modalInterchangeEnabled,
        modulationIntensity: _settings.modulationIntensity,
        jazzPreset: _settings.jazzPreset,
        sourceProfile: _settings.sourceProfile,
        allowV7sus4: _allowsSusDominantQualities,
        allowTensions: _settings.allowTensions,
        chordLanguageLevel: _settings.chordLanguageLevel,
        romanPoolPreset: _settings.romanPoolPreset,
        selectedTensionOptions: _settings.selectedTensionOptions,
        inversionSettings: _settings.inversionSettings,
        smartDiagnosticsEnabled: _settings.smartDiagnosticsEnabled,
        previousRomanNumeralId: _previousChord?.romanNumeralId,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
        currentRenderedNonDiatonic: current.isRenderedNonDiatonic,
        timeSignature: _settings.timeSignature,
        harmonicRhythmPreset: _settings.harmonicRhythmPreset,
        timing: timing,
        currentTrace: current.smartDebug as SmartDecisionTrace?,
        phraseContext: phraseContext,
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
    if (generatedChord != null &&
        !_isExcludedCandidate(generatedChord, exclusionContext)) {
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

  void _playMetronomeIfNeeded({bool fromAutoTick = false, int? beatIndex}) {
    if (!_settings.metronomeEnabled) {
      return;
    }
    if (fromAutoTick && _shouldScheduleMetronomeAhead) {
      return;
    }
    if (!_metronomeAudio.isReady) {
      return;
    }
    final resolvedBeatIndex = beatIndex ?? _currentBeat;
    if (resolvedBeatIndex == null) {
      return;
    }
    final beatState = _settings.metronomeBeatStateForBeat(resolvedBeatIndex);
    if (beatState == MetronomeBeatState.mute) {
      return;
    }
    unawaited(
      _metronomeAudio.playBeat(beatState, volume: _settings.metronomeVolume),
    );
  }

  void _requestAdvanceChord() {
    if (!_practiceSessionInitialized) {
      return;
    }
    final swipeSurfaceState = _chordSwipeSurfaceKey.currentState;
    if (swipeSurfaceState == null) {
      _performManualAdvanceChord();
      return;
    }
    if (swipeSurfaceState.isTransitioning) {
      return;
    }
    swipeSurfaceState.animateAdvance();
  }

  void _performManualAdvanceChord({bool playAutoPreview = true}) {
    if (!mounted || !_practiceSessionInitialized) {
      return;
    }
    _dismissFirstRunWelcomeCard();
    final shouldRestartAutoLoop = _autoRunning;
    _recordPracticeHistory();
    setState(() {
      _promoteChordQueue();
      _currentBeat = _manualBeatStateForEvent(_currentChordEvent);
    });
    if (playAutoPreview) {
      unawaited(_playAutoChordChangeForCurrentEvent());
    }
    if (shouldRestartAutoLoop) {
      _startAutoLoop(immediateFirstBeat: false);
    }
  }

  void _performAutoAdvanceChord({bool chordPlaybackHandled = false}) {
    if (!mounted || !_practiceSessionInitialized) {
      return;
    }
    _recordPracticeHistory();
    setState(() {
      _promoteChordQueue();
    });
    if (!chordPlaybackHandled) {
      unawaited(_playAutoChordChangeForCurrentEvent());
    }
  }

  void _handleAutoTick() {
    if (!mounted || !_practiceSessionInitialized) {
      return;
    }
    var shouldAdvanceChord = false;
    setState(() {
      final autoTick = computeNextPracticeAutoBeat(
        currentBeat: _currentBeat,
        beatCount: _beatsPerBar,
        nextChangeBeat: _nextChangeBeat,
      );
      _currentBeat = autoTick.nextBeat;
      shouldAdvanceChord = autoTick.shouldAdvanceChord;
    });

    _playMetronomeIfNeeded(fromAutoTick: true);

    if (!mounted || !shouldAdvanceChord) {
      return;
    }

    final swipeSurfaceState = _chordSwipeSurfaceKey.currentState;
    if (swipeSurfaceState == null || swipeSurfaceState.isTransitioning) {
      _performAutoAdvanceChord();
      return;
    }
    var playbackHandled = false;
    final nextEvent = _nextChordEvent;
    if (_settings.autoPlayChordChanges && nextEvent != null) {
      playbackHandled = true;
      unawaited(_playUpcomingAutoChordChange(nextEvent));
    }
    swipeSurfaceState.animateAdvance(
      onCompleted: () =>
          _performAutoAdvanceChord(chordPlaybackHandled: playbackHandled),
    );
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
      final immediateBeatState = _settings.metronomeBeatStateForBeat(0);
      if (immediateBeatState != MetronomeBeatState.mute) {
        await _metronomeAudio.playBeat(
          immediateBeatState,
          volume: _settings.metronomeVolume,
        );
      }
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
      final beatIndex = _beatIndexForScheduledSequence(
        _nextScheduledMetronomeSequence,
      );
      final beatState = _settings.metronomeBeatStateForBeat(beatIndex);
      _metronomeAudio.scheduleBeatAt(
        beatState,
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
    _scheduledMetronomeBeatSeed = immediateFirstBeat ? 0 : (_currentBeat ?? 0);
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
    _scheduledMetronomeBeatSeed = 0;
    setState(() {
      _autoRunning = false;
      if (resetBeat) {
        _currentBeat = null;
      }
    });
  }

  void _startAutoPlay() {
    if (!_practiceSessionInitialized) {
      return;
    }
    final immediateFirstBeat = shouldStartPracticeAutoplayImmediately(
      _currentBeat,
    );
    setState(() {
      _autoRunning = true;
      if (immediateFirstBeat) {
        _currentBeat = null;
      }
    });
    _startAutoLoop(immediateFirstBeat: immediateFirstBeat);
  }

  void _rescheduleAutoTimer() {
    if (!mounted || !_autoRunning) {
      return;
    }
    _startAutoLoop(immediateFirstBeat: false);
  }

  void _toggleAutoPlay() {
    if (!_practiceSessionInitialized && !_autoRunning) {
      return;
    }
    _dismissFirstRunWelcomeCard();
    if (_autoRunning) {
      _stopAutoPlay(resetBeat: false);
      return;
    }
    _startAutoPlay();
  }

  void _resetGeneratedChords() {
    if (!_practiceSessionInitialized) {
      return;
    }
    _chordSwipeSurfaceKey.currentState?.cancelTransition();
    if (_autoRunning) {
      _stopAutoPlay();
    }
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio != null) {
      unawaited(harmonyAudio.stopAll());
    }
    setState(() {
      _currentBeat = null;
      _reseedChordQueue();
    });
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
      name: 'chordest.audio',
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
