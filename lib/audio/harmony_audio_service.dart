import 'dart:async';
import 'dart:developer' as developer;

import '../music/chord_theory.dart';
import '../music/progression_analysis_models.dart';
import '../music/voicing_models.dart';
import '../study_harmony/domain/study_harmony_session_models.dart';
import 'harmony_audio_models.dart';
import 'harmony_preview_resolver.dart';
import 'instrument_library_registry.dart';
import 'sampled_instrument_engine.dart';

class HarmonyAudioService {
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
  Future<void>? _warmUpFuture;
  bool _audioDisabled = false;

  String get instrumentId => _instrument.id;

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
    if (!await _ensureReady()) {
      return;
    }
    await _safeRun(() => _engine.setMasterVolume(volume));
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
  }) async {
    if (clip.isEmpty || !await _ensureReady()) {
      return;
    }
    final requests = [
      for (final note in clip.notes)
        InstrumentNoteRequest(
          midiNote: note.midiNote,
          velocity: note.velocity,
          gain: note.gain,
          toneLabel: note.toneLabel,
        ),
    ];
    if (pattern == HarmonyPlaybackPattern.arpeggio) {
      await _safeRun(() => _engine.playArpeggio(requests, hold: hold));
      return;
    }
    await _safeRun(() => _engine.playChord(requests, hold: hold));
  }

  Future<void> playSequence(
    List<HarmonyChordClip> clips, {
    HarmonyPlaybackPattern pattern = HarmonyPlaybackPattern.block,
    Duration gap = const Duration(milliseconds: 140),
    Duration? hold,
  }) async {
    if (clips.isEmpty || !await _ensureReady()) {
      return;
    }
    for (var index = 0; index < clips.length; index += 1) {
      await playClip(clips[index], pattern: pattern, hold: hold);
      if (index < clips.length - 1) {
        await Future<void>.delayed(gap);
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

  Future<void> stopAll() => _safeRun(() => _engine.stopAll());

  Future<void> dispose() => _safeRun(() => _engine.dispose());

  Future<void> _prepareSafely() async {
    try {
      await _engine.prepare();
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
      name: 'sightchord.audio',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
