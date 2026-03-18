import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math' as math;

import '../music/chord_theory.dart';
import '../music/progression_analysis_models.dart';
import '../music/voicing_models.dart';
import '../study_harmony/domain/study_harmony_session_models.dart';
import 'harmony_audio_models.dart';
import 'harmony_preview_resolver.dart';
import 'instrument_library_registry.dart';
import 'sampled_instrument_engine.dart';

class HarmonyAudioService {
  static const Duration _defaultBlockHold = Duration(milliseconds: 920);
  static const Duration _defaultSequenceGap = Duration(milliseconds: 140);
  static const Duration _defaultChordFadeOut = Duration(milliseconds: 70);
  static const Duration _defaultArpeggioNoteHold = Duration(milliseconds: 170);
  static const Duration _defaultArpeggioGap = Duration(milliseconds: 45);
  static const Duration _defaultArpeggioFadeOut = Duration(milliseconds: 36);
  static const Duration _interruptPollInterval = Duration(milliseconds: 20);

  HarmonyAudioService({
    SampledInstrumentEngine? engine,
    InstrumentLibraryDescriptor? instrument,
  }) : _instrument =
           instrument ?? InstrumentLibraryRegistry.defaultHarmonyPiano,
       _engine =
           engine ??
           SampledInstrumentEngine(
             bundle:
                 (instrument ?? InstrumentLibraryRegistry.defaultHarmonyPiano)
                     .bundle,
           );

  final InstrumentLibraryDescriptor _instrument;
  final SampledInstrumentEngine _engine;
  final math.Random _random = math.Random();
  Future<void>? _warmUpFuture;
  HarmonyAudioConfig _config = const HarmonyAudioConfig();
  bool _audioDisabled = false;
  int _playbackSessionSerial = 0;

  String get instrumentId => _instrument.id;
  HarmonyAudioCapabilities get capabilities => const HarmonyAudioCapabilities();
  HarmonyAudioConfig get config => _config;

  Future<void> warmUp() {
    if (_audioDisabled) {
      return Future<void>.value();
    }
    final pending = _warmUpFuture;
    if (pending != null) {
      return pending;
    }
    final future = _prepareSafely();
    _warmUpFuture = future;
    return future;
  }

  Future<void> setMasterVolume(double volume) async {
    await applyConfig(_config.copyWith(masterVolume: volume));
  }

  Future<void> applyConfig(HarmonyAudioConfig config) async {
    _config = config.clamped();
    if (!await _ensureReady()) {
      return;
    }
    await _safeRun(() => _engine.setMasterVolume(_config.masterVolume));
  }

  Future<ActiveInstrumentNote?> noteOn({
    required int midiNote,
    int velocity = 88,
    double gain = 1.0,
  }) async {
    if (!await _ensureReady()) {
      return null;
    }
    return _safeRun<ActiveInstrumentNote?>(
      () => _engine.noteOn(midiNote: midiNote, velocity: velocity, gain: gain),
      fallback: null,
    );
  }

  Future<void> noteOff(ActiveInstrumentNote note, {Duration? fadeOut}) async {
    await _safeRun(() => _engine.noteOff(note, fadeOut: fadeOut));
  }

  Future<void> playClip(
    HarmonyChordClip clip, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration? hold,
    HarmonyPlaybackOverrides? overrides,
  }) async {
    if (clip.isEmpty) {
      return;
    }
    final sessionId = await _beginPlaybackSession();
    if (sessionId == null) {
      return;
    }
    await _playClipForSession(
      clip,
      pattern: pattern,
      hold: hold,
      overrides: overrides,
      sessionId: sessionId,
    );
  }

  Future<void> playMelodyClip(HarmonyMelodyClip clip) async {
    if (clip.isEmpty) {
      return;
    }
    final sessionId = await _beginPlaybackSession();
    if (sessionId == null) {
      return;
    }
    await _playMelodyClipForSession(clip, sessionId: sessionId);
  }

  Future<void> playCompositeClip(
    HarmonyCompositeClip clip, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration? hold,
    HarmonyPlaybackOverrides? overrides,
  }) async {
    if (clip.isEmpty) {
      return;
    }
    final sessionId = await _beginPlaybackSession();
    if (sessionId == null) {
      return;
    }
    await _playCompositeClipForSession(
      clip,
      pattern: pattern,
      hold: hold,
      overrides: overrides,
      sessionId: sessionId,
    );
  }

  Future<void> playSequence(
    List<HarmonyChordClip> clips, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration gap = _defaultSequenceGap,
    Duration? hold,
    HarmonyPlaybackOverrides? overrides,
  }) async {
    if (clips.isEmpty) {
      return;
    }
    final sessionId = await _beginPlaybackSession();
    if (sessionId == null) {
      return;
    }
    for (var index = 0; index < clips.length; index += 1) {
      if (!_isPlaybackSessionCurrent(sessionId)) {
        return;
      }
      await _playClipForSession(
        clips[index],
        pattern: pattern,
        hold: hold,
        overrides: overrides,
        sessionId: sessionId,
      );
      if (index < clips.length - 1 && _isPlaybackSessionCurrent(sessionId)) {
        await _delayInterruptibly(gap, sessionId);
      }
    }
  }

  Future<void> playGeneratedChord(
    GeneratedChord chord, {
    ConcreteVoicing? voicing,
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
  }) {
    return playClip(
      HarmonyPreviewResolver.fromGeneratedChord(chord, voicing: voicing),
      pattern: pattern,
    );
  }

  Future<void> playParsedChord(
    ParsedChord chord, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
  }) {
    return playClip(
      HarmonyPreviewResolver.fromParsedChord(chord),
      pattern: pattern,
    );
  }

  Future<void> playProgressionAnalysis(
    ProgressionAnalysis analysis, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
  }) {
    return playSequence(
      HarmonyPreviewResolver.progressionFromAnalysis(analysis),
      pattern: pattern,
    );
  }

  Future<void> playProgressionLabels(
    Iterable<String> chordLabels, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
  }) {
    return playSequence(
      HarmonyPreviewResolver.progressionFromChordLabels(chordLabels),
      pattern: pattern,
    );
  }

  Future<void> playStudyPrompt(
    StudyHarmonyTaskInstance task, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
  }) {
    return playSequence(
      HarmonyPreviewResolver.promptClipsForStudyTask(task),
      pattern: pattern,
    );
  }

  HarmonyChordClip noteClipForStudyAnswerId(String answerId) {
    return HarmonyPreviewResolver.noteClipForStudyAnswerId(answerId);
  }

  Future<void> stopAll() async {
    _invalidatePlaybackSessions();
    await _safeRun(() => _engine.stopAll());
  }

  Future<void> dispose() async {
    _invalidatePlaybackSessions();
    await _safeRun(() => _engine.dispose());
  }

  Future<int?> _beginPlaybackSession() async {
    if (!await _ensureReady()) {
      return null;
    }
    final sessionId = ++_playbackSessionSerial;
    await _safeRun(() => _engine.stopAll());
    if (!_isPlaybackSessionCurrent(sessionId)) {
      return null;
    }
    return sessionId;
  }

  Future<void> _playClipForSession(
    HarmonyChordClip clip, {
    required HarmonyPlaybackPattern pattern,
    required Duration? hold,
    required HarmonyPlaybackOverrides? overrides,
    required int sessionId,
  }) async {
    if (clip.isEmpty || !_isPlaybackSessionCurrent(sessionId)) {
      return;
    }
    final requests = _buildRequests(clip);
    switch (pattern) {
      case HarmonyPlaybackPattern.block:
        await _playBlockClip(
          requests,
          hold:
              overrides?.blockHold ??
              hold ??
              _scaledDuration(_defaultBlockHold, _config.previewHoldFactor),
          sessionId: sessionId,
        );
      case HarmonyPlaybackPattern.arpeggio:
        await _playArpeggioClip(
          requests,
          noteHold:
              overrides?.arpeggioNoteHold ??
              hold ??
              _scaledDuration(
                _defaultArpeggioNoteHold,
                _config.previewHoldFactor,
              ),
          gap:
              overrides?.arpeggioGap ??
              _scaledDuration(
                _defaultArpeggioGap,
                1 / _config.arpeggioStepSpeed,
              ),
          sessionId: sessionId,
        );
    }
  }

  Future<void> _playCompositeClipForSession(
    HarmonyCompositeClip clip, {
    required HarmonyPlaybackPattern pattern,
    required Duration? hold,
    required HarmonyPlaybackOverrides? overrides,
    required int sessionId,
  }) async {
    final futures = <Future<void>>[];
    final chordClip = clip.chordClip;
    if (chordClip != null && !chordClip.isEmpty) {
      futures.add(
        _playClipForSession(
          chordClip,
          pattern: pattern,
          hold: hold,
          overrides: overrides,
          sessionId: sessionId,
        ),
      );
    }
    final melodyClip = clip.melodyClip;
    if (melodyClip != null && !melodyClip.isEmpty) {
      futures.add(_playMelodyClipForSession(melodyClip, sessionId: sessionId));
    }
    if (futures.isEmpty) {
      return;
    }
    await Future.wait<void>(futures);
  }

  Future<void> _playBlockClip(
    List<InstrumentNoteRequest> requests, {
    required Duration hold,
    required int sessionId,
  }) async {
    final activeNotes = await _startSessionChord(requests, sessionId);
    if (activeNotes.isEmpty || !_isPlaybackSessionCurrent(sessionId)) {
      return;
    }
    await _delayInterruptibly(hold, sessionId);
    if (!_isPlaybackSessionCurrent(sessionId)) {
      return;
    }
    await _releaseActiveNotes(activeNotes, fadeOut: _defaultChordFadeOut);
  }

  Future<void> _playArpeggioClip(
    List<InstrumentNoteRequest> requests, {
    required Duration noteHold,
    required Duration gap,
    required int sessionId,
  }) async {
    for (var index = 0; index < requests.length; index += 1) {
      if (!_isPlaybackSessionCurrent(sessionId)) {
        return;
      }
      final active = await _startSessionNote(requests[index], sessionId);
      if (active == null) {
        continue;
      }
      await _delayInterruptibly(noteHold, sessionId);
      if (!_isPlaybackSessionCurrent(sessionId)) {
        return;
      }
      await noteOff(active, fadeOut: _defaultArpeggioFadeOut);
      if (index < requests.length - 1) {
        await _delayInterruptibly(gap, sessionId);
      }
    }
  }

  Future<void> _playMelodyClipForSession(
    HarmonyMelodyClip clip, {
    required int sessionId,
  }) async {
    if (clip.isEmpty || !_isPlaybackSessionCurrent(sessionId)) {
      return;
    }
    final orderedNotes = [...clip.notes]
      ..sort((left, right) => left.startOffset.compareTo(right.startOffset));
    var elapsed = Duration.zero;
    final releaseFutures = <Future<void>>[];
    for (final note in orderedNotes) {
      if (!_isPlaybackSessionCurrent(sessionId)) {
        return;
      }
      final wait = note.startOffset - elapsed;
      if (wait > Duration.zero) {
        await _delayInterruptibly(wait, sessionId);
        elapsed += wait;
      }
      final active = await _startSessionNote(
        InstrumentNoteRequest(
          midiNote: note.midiNote,
          velocity: note.velocity,
          gain: note.gain,
          toneLabel: note.toneLabel,
        ),
        sessionId,
      );
      if (active == null) {
        continue;
      }
      releaseFutures.add(
        _holdAndReleaseNote(
          active,
          hold: note.duration,
          fadeOut: _defaultArpeggioFadeOut,
          sessionId: sessionId,
        ),
      );
    }
    if (releaseFutures.isEmpty) {
      return;
    }
    await Future.wait<void>(releaseFutures);
  }

  Future<ActiveInstrumentNote?> _startSessionNote(
    InstrumentNoteRequest request,
    int sessionId,
  ) async {
    if (!_isPlaybackSessionCurrent(sessionId)) {
      return null;
    }
    final active = await noteOn(
      midiNote: request.midiNote,
      velocity: request.velocity,
      gain: request.gain,
    );
    if (active == null) {
      return null;
    }
    if (_isPlaybackSessionCurrent(sessionId)) {
      return active;
    }
    await noteOff(active, fadeOut: Duration.zero);
    return null;
  }

  Future<List<ActiveInstrumentNote>> _startSessionChord(
    List<InstrumentNoteRequest> requests,
    int sessionId,
  ) async {
    if (requests.isEmpty || !_isPlaybackSessionCurrent(sessionId)) {
      return const <ActiveInstrumentNote>[];
    }
    if (!await _ensureReady()) {
      return const <ActiveInstrumentNote>[];
    }
    final activeNotes =
        await _safeRun<List<ActiveInstrumentNote>>(
          () => _engine.noteOnBatch(
            requests,
            startOffsets: _buildBlockStartOffsets(requests.length),
          ),
          fallback: const <ActiveInstrumentNote>[],
        ) ??
        const <ActiveInstrumentNote>[];
    if (_isPlaybackSessionCurrent(sessionId)) {
      return activeNotes;
    }
    await _releaseActiveNotes(activeNotes, fadeOut: Duration.zero);
    return const <ActiveInstrumentNote>[];
  }

  Future<void> _releaseActiveNotes(
    Iterable<ActiveInstrumentNote> notes, {
    Duration? fadeOut,
  }) async {
    await Future.wait<void>([
      for (final note in notes) noteOff(note, fadeOut: fadeOut),
    ]);
  }

  Future<void> _holdAndReleaseNote(
    ActiveInstrumentNote note, {
    required Duration hold,
    required Duration fadeOut,
    required int sessionId,
  }) async {
    await _delayInterruptibly(hold, sessionId);
    if (!_isPlaybackSessionCurrent(sessionId)) {
      return;
    }
    await noteOff(note, fadeOut: fadeOut);
  }

  Future<void> _delayInterruptibly(Duration duration, int sessionId) async {
    if (duration <= Duration.zero) {
      return;
    }
    var remaining = duration;
    while (remaining > Duration.zero && _isPlaybackSessionCurrent(sessionId)) {
      final slice = remaining > _interruptPollInterval
          ? _interruptPollInterval
          : remaining;
      await Future<void>.delayed(slice);
      remaining -= slice;
    }
  }

  int _invalidatePlaybackSessions() => ++_playbackSessionSerial;

  bool _isPlaybackSessionCurrent(int sessionId) =>
      _playbackSessionSerial == sessionId;

  Future<void> _prepareSafely() async {
    try {
      await _engine.prepare();
      await _engine.setMasterVolume(_config.masterVolume);
    } catch (error, stackTrace) {
      _disableAudio('warm-up', error: error, stackTrace: stackTrace);
    }
  }

  Future<bool> _ensureReady() async {
    if (_audioDisabled) {
      return false;
    }
    await warmUp();
    return !_audioDisabled;
  }

  Future<T?> _safeRun<T>(Future<T> Function() action, {T? fallback}) async {
    if (_audioDisabled) {
      return fallback;
    }
    try {
      return await action();
    } catch (error, stackTrace) {
      _disableAudio('playback', error: error, stackTrace: stackTrace);
      return fallback;
    }
  }

  void _disableAudio(
    String reason, {
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (_audioDisabled) {
      return;
    }
    _audioDisabled = true;
    developer.log(
      'Harmony audio disabled after $reason failed for ${_instrument.id}.',
      name: 'chordest.audio',
      error: error,
      stackTrace: stackTrace,
    );
  }

  List<InstrumentNoteRequest> _buildRequests(HarmonyChordClip clip) {
    return [
      for (final note in clip.notes)
        InstrumentNoteRequest(
          midiNote: note.midiNote,
          velocity: _humanizedVelocity(note.velocity),
          gain: _humanizedGain(note.gain),
          toneLabel: note.toneLabel,
        ),
    ];
  }

  int _humanizedVelocity(int baseVelocity) {
    if (_config.velocityHumanization <= 0) {
      return baseVelocity.clamp(1, 127);
    }
    final spread = (_config.velocityHumanization * 18).round();
    return (baseVelocity + _random.nextInt((spread * 2) + 1) - spread).clamp(
      1,
      127,
    );
  }

  double _humanizedGain(double baseGain) {
    if (_config.gainRandomness <= 0) {
      return baseGain;
    }
    final maxOffset = _config.gainRandomness * 0.16;
    final offset = (_random.nextDouble() * maxOffset * 2) - maxOffset;
    return (baseGain + offset).clamp(0.2, 1.4).toDouble();
  }

  Duration _timingHumanizationDelayRange() {
    if (_config.timingHumanization <= 0) {
      return Duration.zero;
    }
    return Duration(milliseconds: (18 * _config.timingHumanization).round());
  }

  List<Duration> _buildBlockStartOffsets(int noteCount) {
    if (noteCount <= 0) {
      return const <Duration>[];
    }
    final delayRange = _timingHumanizationDelayRange();
    if (delayRange <= Duration.zero) {
      return List<Duration>.filled(noteCount, Duration.zero, growable: false);
    }
    final offsets = <Duration>[Duration.zero];
    var cumulative = Duration.zero;
    for (var index = 1; index < noteCount; index += 1) {
      cumulative += _randomDuration(delayRange);
      offsets.add(cumulative);
    }
    return offsets;
  }

  Duration _randomDuration(Duration maxDuration) {
    if (maxDuration <= Duration.zero) {
      return Duration.zero;
    }
    final micros = _random.nextInt(maxDuration.inMicroseconds + 1);
    return Duration(microseconds: micros);
  }

  Duration _scaledDuration(Duration duration, double factor) {
    if (duration <= Duration.zero) {
      return Duration.zero;
    }
    return Duration(
      microseconds: math.max(1, (duration.inMicroseconds * factor).round()),
    );
  }
}
