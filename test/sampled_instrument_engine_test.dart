import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:chordest/audio/sampled_instrument_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('normalizeAssetPathForAudioPlayer', () {
    test('strips the flutter assets prefix for audioplayers asset loading', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'assets/piano/salamander_essential/samples/C4v10.flac',
        ),
        'piano/salamander_essential/samples/C4v10.flac',
      );
    });

    test('leaves already relative asset paths unchanged', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'piano/salamander_essential/samples/C4v10.flac',
        ),
        'piano/salamander_essential/samples/C4v10.flac',
      );
    });

    test('does not alter package asset paths', () {
      expect(
        normalizeAssetPathForAudioPlayer(
          'packages/chordest/audio/piano/C4v10.flac',
        ),
        'packages/chordest/audio/piano/C4v10.flac',
      );
    });
  });

  group('AudioPlayerVoiceFactory', () {
    test(
      'primes playback rate before the audible start when it changes',
      () async {
        final backend = _FakeAudioPlayerBackend();
        final voice = await AudioPlayerVoiceFactory(
          backendFactory: () => backend,
        ).createVoice();

        await voice.prepare(
          assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
          playbackRate: 0.5,
        );

        expect(backend.calls, <String>[
          'setPlayerMode:${_expectedPlayerMode()}',
          'setReleaseMode:ReleaseMode.stop',
          'setSourceAsset:piano/salamander_essential/samples/C4v10.flac',
          'setVolume:0.0',
          'resume',
          'setPlaybackRate:0.5',
          'stop',
        ]);

        await voice.start(volume: 0.72);

        expect(backend.calls, <String>[
          'setPlayerMode:${_expectedPlayerMode()}',
          'setReleaseMode:ReleaseMode.stop',
          'setSourceAsset:piano/salamander_essential/samples/C4v10.flac',
          'setVolume:0.0',
          'resume',
          'setPlaybackRate:0.5',
          'stop',
          'setVolume:0.72',
          'resume',
        ]);
      },
    );

    test('reuses the current playback rate when nothing changed', () async {
      final backend = _FakeAudioPlayerBackend();
      final voice = await AudioPlayerVoiceFactory(
        backendFactory: () => backend,
      ).createVoice();

      await voice.prepare(
        assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
        playbackRate: 0.5,
      );
      await voice.start(volume: 0.72);

      backend.calls.clear();

      await voice.prepare(
        assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
        playbackRate: 0.5,
      );
      await voice.start(volume: 0.64);

      expect(backend.calls, <String>['setVolume:0.64', 'resume']);
    });
  });

  group('SampledInstrumentEngine', () {
    const manifestAssetPath = 'test/audio/test_manifest.json';
    late _TestManifestLoader manifestLoader;

    setUp(() {
      manifestLoader = _TestManifestLoader(
        assets: <String, String>{manifestAssetPath: _testManifestJson},
      )..install();
    });

    tearDown(() {
      manifestLoader.dispose();
    });

    test('prepares every chord voice before starting any note', () async {
      final eventLog = <String>[];
      final engine = SampledInstrumentEngine(
        bundle: const SampledInstrumentAssetBundle(
          id: 'test-piano',
          manifestAssetPath: manifestAssetPath,
          assetRootPath: 'assets/test-piano',
        ),
        voiceFactory: _RecordingVoiceFactory(
          eventLog,
          prepareDurations: <Duration>[
            const Duration(milliseconds: 3),
            const Duration(milliseconds: 1),
            const Duration(milliseconds: 2),
          ],
        ),
      );

      await engine.playChord(const <InstrumentNoteRequest>[
        InstrumentNoteRequest(midiNote: 60),
        InstrumentNoteRequest(midiNote: 64),
        InstrumentNoteRequest(midiNote: 67),
      ], hold: Duration.zero);

      final firstStartIndex = eventLog.indexWhere(
        (event) => event.contains('.start'),
      );
      final lastPrepareIndex = eventLog.lastIndexWhere(
        (event) => event.contains('.prepare'),
      );

      expect(firstStartIndex, greaterThan(-1));
      expect(lastPrepareIndex, greaterThan(-1));
      expect(firstStartIndex, greaterThan(lastPrepareIndex));
    });

    test(
      'prepares every arpeggio voice before starting the first note',
      () async {
        final eventLog = <String>[];
        final engine = SampledInstrumentEngine(
          bundle: const SampledInstrumentAssetBundle(
            id: 'test-piano',
            manifestAssetPath: manifestAssetPath,
            assetRootPath: 'assets/test-piano',
          ),
          voiceFactory: _RecordingVoiceFactory(
            eventLog,
            prepareDurations: <Duration>[
              const Duration(milliseconds: 2),
              const Duration(milliseconds: 4),
              const Duration(milliseconds: 1),
            ],
          ),
        );

        await engine.playArpeggio(
          const <InstrumentNoteRequest>[
            InstrumentNoteRequest(midiNote: 60),
            InstrumentNoteRequest(midiNote: 64),
            InstrumentNoteRequest(midiNote: 67),
          ],
          step: Duration.zero,
          hold: Duration.zero,
        );

        final firstStartIndex = eventLog.indexWhere(
          (event) => event.contains('.start'),
        );
        final lastPrepareIndex = eventLog.lastIndexWhere(
          (event) => event.contains('.prepare'),
        );

        expect(firstStartIndex, greaterThan(-1));
        expect(lastPrepareIndex, greaterThan(-1));
        expect(firstStartIndex, greaterThan(lastPrepareIndex));
      },
    );
    test('logs and releases the slot when prepare fails during noteOn', () async {
      final warnings = <String>[];
      final events = <String>[];
      final engine = SampledInstrumentEngine(
        bundle: const SampledInstrumentAssetBundle(
          id: 'test-piano',
          manifestAssetPath: manifestAssetPath,
          assetRootPath: 'assets/test-piano',
        ),
        voiceFactory: _SingleVoiceFactory(
          _ControlledVoice(
            onPrepare: () async => throw StateError('prepare failed'),
            eventLog: events,
          ),
        ),
        logWarning: (message, {error, stackTrace}) => warnings.add(message),
      );

      final note = await engine.noteOn(midiNote: 60);

      expect(note, isNull);
      expect(
        warnings,
        contains('Preparing instrument note-on failed for test-piano.'),
      );
      expect(events, contains('setVolume:1.0'));
    });

    test('logs and releases the slot when start fails during noteOn', () async {
      final warnings = <String>[];
      final events = <String>[];
      final engine = SampledInstrumentEngine(
        bundle: const SampledInstrumentAssetBundle(
          id: 'test-piano',
          manifestAssetPath: manifestAssetPath,
          assetRootPath: 'assets/test-piano',
        ),
        voiceFactory: _SingleVoiceFactory(
          _ControlledVoice(
            onStart: () async => throw StateError('start failed'),
            eventLog: events,
          ),
        ),
        logWarning: (message, {error, stackTrace}) => warnings.add(message),
      );

      final note = await engine.noteOn(midiNote: 60);

      expect(note, isNull);
      expect(
        warnings,
        contains('Starting instrument note-on failed for test-piano.'),
      );
      expect(events, contains('setVolume:1.0'));
    });

    test('reuses prefetched voice slots for the same notes', () async {
      final eventLog = <String>[];
      final engine = SampledInstrumentEngine(
        bundle: const SampledInstrumentAssetBundle(
          id: 'test-piano',
          manifestAssetPath: manifestAssetPath,
          assetRootPath: 'assets/test-piano',
        ),
        voiceFactory: _RecordingVoiceFactory(
          eventLog,
          cacheRepeatedPrepare: true,
        ),
      );

      await engine.prefetchNotes(const <InstrumentNoteRequest>[
        InstrumentNoteRequest(midiNote: 60),
        InstrumentNoteRequest(midiNote: 64),
        InstrumentNoteRequest(midiNote: 67),
      ]);

      eventLog.clear();

      final activeNotes = await engine.noteOnBatch(const <InstrumentNoteRequest>[
        InstrumentNoteRequest(midiNote: 60),
        InstrumentNoteRequest(midiNote: 64),
        InstrumentNoteRequest(midiNote: 67),
      ]);

      expect(activeNotes, hasLength(3));
      expect(
        eventLog.where((event) => event.contains('.prepare')),
        isEmpty,
      );
      expect(
        eventLog.where((event) => event.contains('.start')).length,
        3,
      );
    });

    test('fade out never boosts a quiet note before release', () async {
      final eventLog = <String>[];
      final engine = SampledInstrumentEngine(
        bundle: const SampledInstrumentAssetBundle(
          id: 'test-piano',
          manifestAssetPath: manifestAssetPath,
          assetRootPath: 'assets/test-piano',
        ),
        voiceFactory: _SingleVoiceFactory(
          _ControlledVoice(eventLog: eventLog),
        ),
      );

      final note = await engine.noteOn(midiNote: 60, velocity: 16, gain: 0.2);

      expect(note, isNotNull);

      await engine.noteOff(
        note!,
        fadeOut: const Duration(milliseconds: 20),
      );

      final stopIndex = eventLog.indexOf('stop');
      expect(stopIndex, greaterThan(0));

      final startEvent = eventLog.firstWhere((event) => event.startsWith('start:'));
      final startVolume = double.parse(startEvent.split(':')[1]);
      final fadeVolumes = eventLog
          .take(stopIndex)
          .where((event) => event.startsWith('setVolume:'))
          .map((event) => double.parse(event.split(':')[1]))
          .toList(growable: false);

      expect(fadeVolumes, isNotEmpty);
      expect(
        fadeVolumes.every((volume) => volume <= startVolume + 0.0001),
        isTrue,
      );
      expect(fadeVolumes.last, closeTo(0.0, 0.0001));
    });
  });
}

PlayerMode _expectedPlayerMode() =>
    PlayerMode.mediaPlayer;

class _FakeAudioPlayerBackend implements AudioPlayerBackend {
  final List<String> calls = <String>[];

  @override
  Future<void> dispose() async {
    calls.add('dispose');
  }

  @override
  Future<void> resume() async {
    calls.add('resume');
  }

  @override
  Future<void> setPlaybackRate(double playbackRate) async {
    calls.add('setPlaybackRate:$playbackRate');
  }

  @override
  Future<void> setPlayerMode(PlayerMode mode) async {
    calls.add('setPlayerMode:$mode');
  }

  @override
  Future<void> setReleaseMode(ReleaseMode mode) async {
    calls.add('setReleaseMode:$mode');
  }

  @override
  Future<void> setSourceAsset(String path) async {
    calls.add('setSourceAsset:$path');
  }

  @override
  Future<void> setVolume(double volume) async {
    calls.add('setVolume:$volume');
  }

  @override
  Future<void> stop() async {
    calls.add('stop');
  }
}

class _RecordingVoiceFactory implements SamplePlayerVoiceFactory {
  _RecordingVoiceFactory(
    this.eventLog, {
    List<Duration>? prepareDurations,
    this.cacheRepeatedPrepare = false,
  }) : _prepareDurations = prepareDurations ?? const <Duration>[];

  final List<String> eventLog;
  final List<Duration> _prepareDurations;
  final bool cacheRepeatedPrepare;
  int _createdVoices = 0;

  @override
  Future<SamplePlayerVoice> createVoice() async {
    final voiceId = _createdVoices;
    _createdVoices += 1;
    final prepareDelay = voiceId < _prepareDurations.length
        ? _prepareDurations[voiceId]
        : Duration.zero;
    final voice = _RecordingVoice(
      id: voiceId,
      eventLog: eventLog,
      prepareDelay: prepareDelay,
      cacheRepeatedPrepare: cacheRepeatedPrepare,
    );
    await voice.configure();
    return voice;
  }
}

class _RecordingVoice implements SamplePlayerVoice {
  _RecordingVoice({
    required this.id,
    required this.eventLog,
    required this.prepareDelay,
    this.cacheRepeatedPrepare = false,
  });

  final int id;
  final List<String> eventLog;
  final Duration prepareDelay;
  final bool cacheRepeatedPrepare;
  String? _preparedAssetPath;
  double _preparedPlaybackRate = 1.0;

  @override
  Future<void> configure() async {
    eventLog.add('voice$id.configure');
  }

  @override
  Future<void> prepare({
    required String assetPath,
    required double playbackRate,
  }) async {
    if (cacheRepeatedPrepare &&
        _preparedAssetPath == assetPath &&
        (_preparedPlaybackRate - playbackRate).abs() <= 0.0001) {
      return;
    }
    eventLog.add('voice$id.prepare:$assetPath@$playbackRate');
    _preparedAssetPath = assetPath;
    _preparedPlaybackRate = playbackRate;
    if (prepareDelay > Duration.zero) {
      await Future<void>.delayed(prepareDelay);
    }
  }

  @override
  Future<void> start({required double volume}) async {
    eventLog.add('voice$id.start:$volume');
  }

  @override
  Future<void> setVolume(double volume) async {
    eventLog.add('voice$id.volume:$volume');
  }

  @override
  Future<void> stop() async {
    eventLog.add('voice$id.stop');
  }

  @override
  Future<void> dispose() async {
    eventLog.add('voice$id.dispose');
  }
}

class _SingleVoiceFactory implements SamplePlayerVoiceFactory {
  _SingleVoiceFactory(this.voice);

  final SamplePlayerVoice voice;

  @override
  Future<SamplePlayerVoice> createVoice() async {
    await voice.configure();
    return voice;
  }
}

class _ControlledVoice implements SamplePlayerVoice {
  _ControlledVoice({
    this.onPrepare,
    this.onStart,
    this.eventLog,
  });

  final Future<void> Function()? onPrepare;
  final Future<void> Function()? onStart;
  final List<String>? eventLog;

  @override
  Future<void> configure() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> prepare({
    required String assetPath,
    required double playbackRate,
  }) async {
    eventLog?.add('prepare:$assetPath@$playbackRate');
    if (onPrepare != null) {
      await onPrepare!.call();
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    eventLog?.add('setVolume:$volume');
  }

  @override
  Future<void> start({required double volume}) async {
    eventLog?.add('start:$volume');
    if (onStart != null) {
      await onStart!.call();
    }
  }

  @override
  Future<void> stop() async {
    eventLog?.add('stop');
  }
}
class _TestManifestLoader {
  _TestManifestLoader({required Map<String, String> assets}) : _assets = assets;

  final Map<String, String> _assets;

  void install() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', _handleMessage);
  }

  Future<ByteData?> _handleMessage(ByteData? message) async {
    if (message == null) {
      return null;
    }
    final key = utf8.decode(message.buffer.asUint8List());
    final asset = _assets[key];
    if (asset == null) {
      return null;
    }
    final bytes = Uint8List.fromList(utf8.encode(asset));
    return ByteData.sublistView(bytes);
  }

  void dispose() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  }
}

const String _testManifestJson = '''
{
  "id": "test-piano",
  "displayName": "Test Piano",
  "version": 1,
  "range": {
    "minMidi": 48,
    "maxMidi": 72,
    "minLabel": "C3",
    "maxLabel": "C5"
  },
  "velocityLayers": [
    {
      "layer": 1,
      "minVelocity": 1,
      "maxVelocity": 127
    }
  ],
  "defaults": {
    "polyphony": 8,
    "releaseFadeOutMs": 0,
    "defaultChordHoldMs": 0,
    "defaultArpeggioStepMs": 0,
    "defaultArpeggioHoldMs": 0,
    "velocityCurvePower": 1.0,
    "baseVolume": 1.0,
    "noteOnPrerollVoices": 3,
    "clampOutOfRangeNotes": true
  },
  "regions": [
    {
      "sample": "samples/C4.flac",
      "lokey": 59,
      "hikey": 61,
      "pitchKeycenter": 60,
      "layer": 1,
      "lovel": 1,
      "hivel": 127
    },
    {
      "sample": "samples/E4.flac",
      "lokey": 63,
      "hikey": 65,
      "pitchKeycenter": 64,
      "layer": 1,
      "lovel": 1,
      "hivel": 127
    },
    {
      "sample": "samples/G4.flac",
      "lokey": 66,
      "hikey": 68,
      "pitchKeycenter": 67,
      "layer": 1,
      "lovel": 1,
      "hivel": 127
    }
  ]
}
''';
