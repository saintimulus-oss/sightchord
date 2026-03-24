import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio/harmony_audio_models.dart';
import 'audio/harmony_preview_resolver.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/chordest_audio_scope.dart';
import 'l10n/app_localizations.dart';
import 'music/chord_formatting.dart';
import 'music/notation_presentation.dart';
import 'music/chord_timing_models.dart';
import 'music/chord_theory.dart';
import 'music/melody_generator.dart';
import 'music/melody_models.dart';
import 'music/practice_chord_queue_state.dart';
import 'practice/practice_session_controller.dart';
import 'practice/practice_page_body.dart';
import 'practice/practice_session_state.dart';
import 'practice/practice_transport_controller.dart';
import 'practice/practice_transport_state.dart';
import 'practice/widgets/practice_chord_display_section.dart';
import 'practice/widgets/practice_chord_swipe_surface.dart';
import 'practice/widgets/practice_generator_controls.dart';
import 'practice/widgets/practice_page_sections.dart';
import 'practice/widgets/practice_transport_strip.dart';
import 'ui/chordest_ui_tokens.dart';
import 'music/voicing_models.dart';
import 'settings/practice_settings.dart';
import 'settings/practice_settings_effects.dart';
import 'settings/practice_advanced_settings_page.dart';
import 'settings/practice_setup_assistant.dart';
import 'settings/practice_settings_factory.dart';
import 'settings/practice_settings_drawer.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/content/track_generation_profiles.dart';
part 'practice_home_page_labels.dart';
part 'practice_home_page_ui.dart';

class _PracticeHistoryEntry {
  const _PracticeHistoryEntry({
    required this.sessionState,
    required this.melodyState,
    required this.currentBeat,
    required this.melodyGenerationSeed,
  });

  final PracticeSessionState sessionState;
  final PracticeMelodyQueueState melodyState;
  final int? currentBeat;
  final int melodyGenerationSeed;
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

  late final PracticeSessionController _practiceSessionController;
  late final PracticeTransportController _practiceTransportController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<PracticeChordSwipeSurfaceState> _chordSwipeSurfaceKey =
      GlobalKey<PracticeChordSwipeSurfaceState>();
  late final TextEditingController _bpmController;

  bool _metronomePatternEditing = false;
  bool _showFirstRunWelcomeCard = false;
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;
  String? _lastCurrentPreviewPrefetchKey;
  String? _lastNextPreviewPrefetchKey;
  PracticeMelodyQueueState _melodyState = const PracticeMelodyQueueState();
  int _melodyGenerationSeed = 0;
  final List<_PracticeHistoryEntry> _practiceHistory =
      <_PracticeHistoryEntry>[];

  PracticeSettings get _settings => widget.controller.settings;
  int get _beatsPerBar => _settings.beatsPerBar;
  PracticeTransportState get _transportState =>
      _practiceTransportController.state;
  int? get _currentBeat => _transportState.currentBeat;
  bool get _autoRunning => _transportState.autoRunning;
  bool get _practiceSessionInitialized =>
      _practiceSessionController.state.initialized;
  PracticeSessionState get _sessionState => _practiceSessionController.state;
  PracticeChordQueueState get _queueState => _sessionState.queueState;
  GeneratedChordEvent? get _currentChordEvent =>
      _practiceSessionController.state.currentEvent;
  GeneratedChordEvent? get _nextChordEvent =>
      _practiceSessionController.state.nextEvent;
  GeneratedChordEvent? get _lookAheadChordEvent =>
      _practiceSessionController.state.lookAheadEvent;
  GeneratedChord? get _currentChord =>
      _practiceSessionController.state.currentChord;
  GeneratedMelodyEvent? get _currentMelodyEvent => _melodyState.currentEvent;
  GeneratedMelodyEvent? get _nextMelodyEvent => _melodyState.nextEvent;
  VoicingRecommendationSet? get _voicingRecommendations =>
      _practiceSessionController.state.voicingRecommendations;
  PerformanceVoicingPreview? get _performanceVoicingPreview =>
      _practiceSessionController.state.performanceVoicingPreview;
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

  String _displaySymbolForEvent(GeneratedChordEvent? event) {
    if (event == null) {
      return '';
    }
    return event.displaySymbolOverride ??
        ChordRenderingHelper.renderedSymbol(
          event.chord,
          _settings.chordSymbolStyle,
          preferences: _settings.notationPreferences,
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
    final preferFlat = _preferFlatForMelodyEvent(event);
    return event.notes
        .map(
          (note) => MusicNotationFormatter.formatPitchWithOctave(
            note.displayLabel(preferFlat: preferFlat),
            preferences: _settings.notationPreferences,
          ),
        )
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    _practiceSessionController = PracticeSessionController();
    _practiceTransportController = PracticeTransportController(
      logWarning: _logAudioWarning,
    );
    _practiceTransportController.addListener(_handleTransportStateChanged);
    _bpmController = TextEditingController(text: '${_settings.bpm}');
    _syncTransportBindings();
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

  void _handleTransportStateChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _initializePracticeSession() {
    _practiceSessionController.initialize(settings: _settings);
    _syncTransportBindings();
    _rebuildMelodyQueue();
    _queueHarmonyPreviewPrefetch();
  }

  Future<void> _runSetupAssistant({required bool mandatory}) async {
    if (!mounted) {
      return;
    }
    if (_autoRunning) {
      _stopAutoplayAndHarmonyPreview();
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
    final harmonyAudio = ChordestAudioScope.maybeOf(context);
    if (!identical(_harmonyAudio, harmonyAudio)) {
      _resetHarmonyPreviewPrefetchCache();
    }
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
    _queueHarmonyPreviewPrefetch();
  }

  Future<void> _initAudio() async {
    await Future.wait<void>([
      _practiceTransportController.initializeAudio(),
      _syncHarmonyAudioConfig(_settings),
    ]);
  }

  Future<void> _syncHarmonyAudioConfig(PracticeSettings settings) async {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final soundProfile = trackSoundProfileForSelection(
      l10n,
      selection: settings.harmonySoundProfileSelection,
    );
    await harmonyAudio.applyRuntimeProfile(
      soundProfile.runtimeProfile,
      baseConfig: harmonyAudioBaseConfigForSettings(settings),
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

  void _syncTransportBindings({
    PracticeSettings? settings,
    int? bpm,
    int? nextChangeBeat,
  }) {
    _practiceTransportController.bind(
      settings: settings ?? _settings,
      bpm: bpm ?? _effectiveBpm(),
      nextChangeBeat: nextChangeBeat ?? _nextChangeBeat,
      onAdvanceChord: _handleTransportAdvanceRequested,
    );
  }

  bool get _usesKeyMode => _settings.usesKeyMode;

  List<KeyCenter> get _orderedKeyCenters => [
    for (final mode in KeyMode.values)
      for (final center in MusicTheory.orderedKeyCentersForMode(mode))
        if (_settings.activeKeyCenters.contains(center)) center,
  ];

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
      if (syncBpmText) {
        _bpmController.text = '${nextSettings.bpm}';
      }
      if (reseed) {
        _melodyGenerationSeed += 1;
        _reseedChordQueue();
      } else {
        if (shouldRegenerateMelody) {
          _melodyGenerationSeed += 1;
        }
        _recomputeVoicingSuggestions(
          forceLookAheadRefresh: forceLookAheadRefresh,
        );
        if (nextSettings.melodyGenerationEnabled) {
          _rebuildMelodyQueue();
        } else {
          _melodyState = _melodyState.reset();
        }
      }
      _syncTransportBindings(settings: nextSettings);
    });
    _queueHarmonyPreviewPrefetch();
    unawaited(
      _practiceTransportController.handleSettingsChanged(
        previousSettings: previousSettings,
      ),
    );
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

  HarmonyCompositeClip _buildCompositePreviewClip({
    required GeneratedChordEvent event,
    required MelodyPlaybackMode playbackMode,
    ConcreteVoicing? preferredVoicing,
    GeneratedMelodyEvent? melodyEvent,
  }) {
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
    return HarmonyCompositeClip(
      chordClip: chordClip,
      melodyClip: includesMelody
          ? _melodyClipForEvent(melodyEvent, emphasizeLead: chordClip != null)
          : null,
      label: _displaySymbolForEvent(event),
    );
  }

  void _resetHarmonyPreviewPrefetchCache() {
    _lastCurrentPreviewPrefetchKey = null;
    _lastNextPreviewPrefetchKey = null;
  }

  void _queueHarmonyPreviewPrefetch() {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      _resetHarmonyPreviewPrefetchCache();
      return;
    }

    final currentEvent = _currentChordEvent;
    if (currentEvent != null) {
      final currentClip = _buildCompositePreviewClip(
        event: currentEvent,
        playbackMode: _settings.melodyPlaybackMode,
        preferredVoicing: _preferredPlaybackVoicing(),
        melodyEvent: _currentMelodyEvent,
      );
      _scheduleCompositePreviewPrefetch(
        harmonyAudio: harmonyAudio,
        clip: currentClip,
        isCurrentClip: true,
      );
    } else {
      _lastCurrentPreviewPrefetchKey = null;
    }

    final nextEvent = _nextChordEvent;
    if (nextEvent != null) {
      final nextClip = _buildCompositePreviewClip(
        event: nextEvent,
        playbackMode: _autoPlaybackMode(),
        preferredVoicing: _preferredUpcomingPlaybackVoicing(),
        melodyEvent: _nextMelodyEvent,
      );
      _scheduleCompositePreviewPrefetch(
        harmonyAudio: harmonyAudio,
        clip: nextClip,
        isCurrentClip: false,
      );
    } else {
      _lastNextPreviewPrefetchKey = null;
    }
  }

  void _scheduleCompositePreviewPrefetch({
    required HarmonyAudioService harmonyAudio,
    required HarmonyCompositeClip clip,
    required bool isCurrentClip,
  }) {
    if (clip.isEmpty) {
      if (isCurrentClip) {
        _lastCurrentPreviewPrefetchKey = null;
      } else {
        _lastNextPreviewPrefetchKey = null;
      }
      return;
    }
    final key = _compositeClipPrefetchKey(clip);
    final previousKey = isCurrentClip
        ? _lastCurrentPreviewPrefetchKey
        : _lastNextPreviewPrefetchKey;
    if (key == previousKey) {
      return;
    }
    if (isCurrentClip) {
      _lastCurrentPreviewPrefetchKey = key;
    } else {
      _lastNextPreviewPrefetchKey = key;
    }
    unawaited(
      _completeCompositePreviewPrefetch(
        harmonyAudio: harmonyAudio,
        clip: clip,
        key: key,
        isCurrentClip: isCurrentClip,
      ),
    );
  }

  Future<void> _completeCompositePreviewPrefetch({
    required HarmonyAudioService harmonyAudio,
    required HarmonyCompositeClip clip,
    required String key,
    required bool isCurrentClip,
  }) async {
    final prepared = await harmonyAudio.prepareCompositeClip(clip);
    if (prepared) {
      return;
    }
    final cachedKey = isCurrentClip
        ? _lastCurrentPreviewPrefetchKey
        : _lastNextPreviewPrefetchKey;
    if (cachedKey != key) {
      return;
    }
    if (isCurrentClip) {
      _lastCurrentPreviewPrefetchKey = null;
    } else {
      _lastNextPreviewPrefetchKey = null;
    }
  }

  String _compositeClipPrefetchKey(HarmonyCompositeClip clip) {
    final buffer = StringBuffer();
    buffer.write(clip.label ?? '');
    buffer.write('|chord:');
    final chordClip = clip.chordClip;
    if (chordClip != null) {
      for (final note in chordClip.notes) {
        _appendPreviewNoteKey(buffer, note);
      }
    }
    buffer.write('|melody:');
    final melodyClip = clip.melodyClip;
    if (melodyClip != null) {
      for (final note in melodyClip.notes) {
        _appendMelodyNoteKey(buffer, note);
      }
    }
    return buffer.toString();
  }

  static void _appendPreviewNoteKey(
    StringBuffer buffer,
    HarmonyPreviewNote note,
  ) {
    buffer
      ..write(note.midiNote)
      ..write('/')
      ..write(note.velocity)
      ..write('/')
      ..write(note.gain.toStringAsFixed(3))
      ..write('/')
      ..write(note.toneLabel ?? '')
      ..write(';');
  }

  static void _appendMelodyNoteKey(
    StringBuffer buffer,
    HarmonyMelodyNote note,
  ) {
    buffer
      ..write(note.midiNote)
      ..write('/')
      ..write(note.velocity)
      ..write('/')
      ..write(note.gain.toStringAsFixed(3))
      ..write('/')
      ..write(note.startOffset.inMilliseconds)
      ..write('/')
      ..write(note.duration.inMilliseconds)
      ..write('/')
      ..write(note.toneLabel ?? '')
      ..write(';');
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
    final compositeClip = _buildCompositePreviewClip(
      event: event,
      playbackMode: playbackMode,
      preferredVoicing: preferredVoicing,
      melodyEvent: melodyEvent,
    );
    final chordClip = compositeClip.chordClip;
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

  void _reseedChordQueue() {
    _practiceHistory.clear();
    _practiceSessionController.reseed(settings: _settings);
    _syncTransportBindings();
    _melodyState = _melodyState.reset();
    _rebuildMelodyQueue();
    _queueHarmonyPreviewPrefetch();
  }

  void _recordPracticeHistory() {
    if (_practiceHistory.length == _practiceHistoryLimit) {
      _practiceHistory.removeAt(0);
    }
    _practiceHistory.add(
      _PracticeHistoryEntry(
        sessionState: _sessionState,
        melodyState: _melodyState,
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
      _practiceSessionController.restoreState(snapshot.sessionState);
      _melodyState = snapshot.melodyState;
      _melodyGenerationSeed = snapshot.melodyGenerationSeed;
      _syncTransportBindings();
      _practiceTransportController.setCurrentBeat(
        _settings.usesLegacyBarTiming
            ? null
            : _normalizeBeatForSettings(_settings, snapshot.currentBeat),
      );
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
      _practiceTransportController.rescheduleAutoplay();
    }
  }

  ConcreteVoicing? _authoritativeSelectedVoicing() {
    return _practiceSessionController.state.authoritativeSelectedVoicing;
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

  void _promoteChordQueue() {
    _practiceSessionController.promote(settings: _settings);
    _syncTransportBindings();
    _rebuildMelodyQueue();
    _queueHarmonyPreviewPrefetch();
  }

  void _recomputeVoicingSuggestions({bool forceLookAheadRefresh = false}) {
    _practiceSessionController.refreshForSettings(
      settings: _settings,
      forceLookAheadRefresh: forceLookAheadRefresh,
    );
  }

  void _handleVoicingSelected(VoicingSuggestion suggestion) {
    setState(() {
      _practiceSessionController.selectVoicingSuggestion(
        suggestion,
        settings: _settings,
      );
    });
    _queueHarmonyPreviewPrefetch();
  }

  void _handleVoicingLockToggle(VoicingSuggestion suggestion) {
    setState(() {
      _practiceSessionController.toggleVoicingLock(
        suggestion,
        settings: _settings,
      );
    });
    _queueHarmonyPreviewPrefetch();
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
    _recordPracticeHistory();
    setState(() {
      _promoteChordQueue();
      _practiceTransportController.handleManualChordAdvance(
        currentBeat: _manualBeatStateForEvent(_currentChordEvent),
      );
    });
    if (playAutoPreview) {
      unawaited(_playAutoChordChangeForCurrentEvent());
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

  void _handleTransportAdvanceRequested() {
    if (!mounted || !_practiceSessionInitialized) {
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

  void _toggleAutoPlay() {
    if (!_practiceSessionInitialized && !_autoRunning) {
      return;
    }
    _dismissFirstRunWelcomeCard();
    if (_autoRunning) {
      _stopAutoplayAndHarmonyPreview(resetBeat: false);
      return;
    }
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio != null) {
      unawaited(harmonyAudio.activate());
      _queueHarmonyPreviewPrefetch();
    }
    _syncTransportBindings();
    _practiceTransportController.startAutoplay();
  }

  void _resetGeneratedChords() {
    if (!_practiceSessionInitialized) {
      return;
    }
    _chordSwipeSurfaceKey.currentState?.cancelTransition();
    _stopAutoplayAndHarmonyPreview();
    setState(() {
      _melodyGenerationSeed += 1;
      _reseedChordQueue();
    });
  }

  void _stopAutoplayAndHarmonyPreview({bool resetBeat = true}) {
    _practiceTransportController.stopAutoplay(resetBeat: resetBeat);
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio != null) {
      unawaited(harmonyAudio.stopAll());
    }
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
    final parsed = int.tryParse(value);
    if (parsed != null) {
      final normalized = parsed.clamp(_minBpm, _maxBpm).toInt();
      _syncTransportBindings(bpm: normalized);
      _practiceTransportController.handleLiveBpmChanged(normalized);
    }
    setState(() {});
  }

  void _normalizeBpm() {
    final normalized = _effectiveBpm();
    _applySettings(_settings.copyWith(bpm: normalized), syncBpmText: true);
  }

  @override
  void dispose() {
    _practiceTransportController.removeListener(_handleTransportStateChanged);
    _bpmController.dispose();
    unawaited(_practiceTransportController.shutdown());
    _practiceTransportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _buildPracticeHomePage(context);
}
