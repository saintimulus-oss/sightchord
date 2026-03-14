import 'dart:js_interop';

import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import 'scheduled_metronome_interface.dart';

const double _immediateSchedulingSafetySeconds = 0.005;

ScheduledMetronome createScheduledMetronome() => _WebScheduledMetronome();

class _WebScheduledMetronome implements ScheduledMetronome {
  web.AudioContext? _audioContext;
  web.AudioBuffer? _buffer;
  final List<_ScheduledWebClick> _scheduledClicks = <_ScheduledWebClick>[];

  @override
  bool get supportsPreciseScheduling => true;

  @override
  bool get isLoaded => _buffer != null;

  @override
  double? get currentTimeSeconds => _audioContext?.currentTime;

  @override
  Future<void> loadAsset(String assetPath) async {
    final context = _audioContext ??= web.AudioContext();
    final assetData = await rootBundle.load(assetPath);
    final tightBytes = Uint8List.fromList(
      assetData.buffer.asUint8List(
        assetData.offsetInBytes,
        assetData.lengthInBytes,
      ),
    );
    final decodedBuffer = await context
        .decodeAudioData(tightBytes.buffer.toJS)
        .toDart;
    _buffer = decodedBuffer;
    _pruneCompletedClicks();
  }

  @override
  Future<void> ensureReady() async {
    final context = _audioContext ??= web.AudioContext();
    if (context.state == 'suspended') {
      await context.resume().toDart;
    }
  }

  @override
  Future<void> playNow({required double volume}) async {
    await ensureReady();
    final now = currentTimeSeconds;
    if (now == null) {
      return;
    }
    scheduleAt(
      whenSeconds: now + _immediateSchedulingSafetySeconds,
      volume: volume,
    );
  }

  @override
  void scheduleAt({required double whenSeconds, required double volume}) {
    final context = _audioContext;
    final buffer = _buffer;
    if (context == null || buffer == null) {
      return;
    }

    _pruneCompletedClicks();

    final source = context.createBufferSource();
    final gain = context.createGain();
    gain.gain.value = volume;
    source.buffer = buffer;
    source.connect(gain);
    gain.connect(context.destination);
    source.start(whenSeconds);

    _scheduledClicks.add(
      _ScheduledWebClick(
        source: source,
        gain: gain,
        whenSeconds: whenSeconds,
        durationSeconds: buffer.duration,
      ),
    );
  }

  @override
  void cancelScheduled() {
    final now = currentTimeSeconds ?? 0;
    final keepPlaying = <_ScheduledWebClick>[];
    for (final click in _scheduledClicks) {
      if (click.whenSeconds <= now + _immediateSchedulingSafetySeconds) {
        keepPlaying.add(click);
        continue;
      }
      click.stop();
      click.dispose();
    }
    _scheduledClicks
      ..clear()
      ..addAll(keepPlaying);
    _pruneCompletedClicks();
  }

  @override
  Future<void> dispose() async {
    for (final click in _scheduledClicks) {
      click.stop();
      click.dispose();
    }
    _scheduledClicks.clear();
    final context = _audioContext;
    _audioContext = null;
    _buffer = null;
    if (context != null) {
      await context.close().toDart;
    }
  }

  void _pruneCompletedClicks() {
    final now = currentTimeSeconds ?? 0;
    _scheduledClicks.removeWhere((click) {
      final finished = click.whenSeconds + click.durationSeconds <= now;
      if (finished) {
        click.dispose();
      }
      return finished;
    });
  }
}

class _ScheduledWebClick {
  _ScheduledWebClick({
    required this.source,
    required this.gain,
    required this.whenSeconds,
    required this.durationSeconds,
  });

  final web.AudioBufferSourceNode source;
  final web.GainNode gain;
  final double whenSeconds;
  final double durationSeconds;

  void stop() {
    try {
      source.stop();
    } catch (error, stackTrace) {
      developer.log(
        'Stopping a scheduled web metronome click failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    try {
      source.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a scheduled web metronome source failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
    try {
      gain.disconnect();
    } catch (error, stackTrace) {
      developer.log(
        'Disconnecting a scheduled web metronome gain node failed.',
        name: 'chordest.audio.web',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
