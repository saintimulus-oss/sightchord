import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/audio/harmony_audio_service.dart';
import 'package:chordest/audio/sampled_instrument_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new playback requests interrupt an active arpeggio', () async {
    final events = <String>[];
    final engine = _FakeSampledInstrumentEngine(events);
    final service = HarmonyAudioService(engine: engine);

    final firstPlayback = service.playClip(
      const HarmonyChordClip(
        notes: <HarmonyPreviewNote>[
          HarmonyPreviewNote(midiNote: 60),
          HarmonyPreviewNote(midiNote: 64),
          HarmonyPreviewNote(midiNote: 67),
        ],
      ),
      pattern: HarmonyPlaybackPattern.arpeggio,
    );

    await Future<void>.delayed(const Duration(milliseconds: 30));
    await service.playClip(
      const HarmonyChordClip(
        notes: <HarmonyPreviewNote>[HarmonyPreviewNote(midiNote: 72)],
      ),
    );
    await firstPlayback;

    expect(events.where((event) => event == 'noteOn:64'), isEmpty);
    expect(events.where((event) => event == 'noteOn:67'), isEmpty);
    expect(events, contains('noteOn:60'));
    expect(events, contains('noteOn:72'));
    expect(
      events.lastIndexOf('noteOn:72'),
      greaterThan(events.lastIndexOf('stopAll')),
    );
  });

  test('arpeggios release each note before the next note starts', () async {
    final events = <String>[];
    final engine = _FakeSampledInstrumentEngine(events);
    final service = HarmonyAudioService(engine: engine);

    await service.playClip(
      const HarmonyChordClip(
        notes: <HarmonyPreviewNote>[
          HarmonyPreviewNote(midiNote: 60),
          HarmonyPreviewNote(midiNote: 64),
          HarmonyPreviewNote(midiNote: 67),
        ],
      ),
      pattern: HarmonyPlaybackPattern.arpeggio,
    );

    final firstOn = events.indexOf('noteOn:60');
    final firstOff = events.indexOf('noteOff:60');
    final secondOn = events.indexOf('noteOn:64');

    expect(firstOn, greaterThanOrEqualTo(0));
    expect(firstOff, greaterThan(firstOn));
    expect(secondOn, greaterThan(firstOff));
  });

  test(
    'composite clips can play melody notes alongside the chord clip',
    () async {
      final events = <String>[];
      final engine = _FakeSampledInstrumentEngine(events);
      final service = HarmonyAudioService(engine: engine);

      await service.playCompositeClip(
        const HarmonyCompositeClip(
          chordClip: HarmonyChordClip(
            notes: <HarmonyPreviewNote>[
              HarmonyPreviewNote(midiNote: 60),
              HarmonyPreviewNote(midiNote: 64),
            ],
          ),
          melodyClip: HarmonyMelodyClip(
            notes: <HarmonyMelodyNote>[
              HarmonyMelodyNote(
                midiNote: 72,
                startOffset: Duration.zero,
                duration: Duration(milliseconds: 12),
              ),
            ],
          ),
        ),
        overrides: HarmonyPlaybackOverrides(
          blockHold: Duration(milliseconds: 18),
        ),
      );

      expect(events, contains('noteOn:60'));
      expect(events, contains('noteOn:64'));
      expect(events, contains('noteOn:72'));
    },
  );

  test('block chords start through the batch note-on path', () async {
    final events = <String>[];
    final engine = _FakeSampledInstrumentEngine(events);
    final service = HarmonyAudioService(engine: engine);

    await service.playClip(
      const HarmonyChordClip(
        notes: <HarmonyPreviewNote>[
          HarmonyPreviewNote(midiNote: 60),
          HarmonyPreviewNote(midiNote: 64),
          HarmonyPreviewNote(midiNote: 67),
        ],
      ),
      overrides: HarmonyPlaybackOverrides(
        blockHold: Duration(milliseconds: 12),
      ),
    );

    expect(events, contains('noteOnBatch:60,64,67'));
    expect(events.indexOf('noteOnBatch:60,64,67'), greaterThanOrEqualTo(0));
  });
}

class _FakeSampledInstrumentEngine extends SampledInstrumentEngine {
  _FakeSampledInstrumentEngine(this.events)
    : super(
        bundle: const SampledInstrumentAssetBundle(
          id: 'fake-piano',
          manifestAssetPath: 'unused.json',
          assetRootPath: 'unused',
        ),
      );

  final List<String> events;
  int _nextNoteId = 1;

  @override
  Future<void> prepare() async {}

  @override
  Future<ActiveInstrumentNote?> noteOn({
    required int midiNote,
    int velocity = 88,
    double gain = 1.0,
  }) async {
    events.add('noteOn:$midiNote');
    return ActiveInstrumentNote(
      id: _nextNoteId++,
      midiNote: midiNote,
      velocity: velocity,
    );
  }

  @override
  Future<List<ActiveInstrumentNote>> noteOnBatch(
    Iterable<InstrumentNoteRequest> notes, {
    List<Duration>? startOffsets,
  }) async {
    final requestList = notes.toList(growable: false);
    events.add(
      'noteOnBatch:${requestList.map((note) => note.midiNote).join(',')}',
    );
    return [
      for (final note in requestList)
        (await noteOn(
          midiNote: note.midiNote,
          velocity: note.velocity,
          gain: note.gain,
        ))!,
    ];
  }

  @override
  Future<void> noteOff(ActiveInstrumentNote note, {Duration? fadeOut}) async {
    events.add('noteOff:${note.midiNote}');
  }

  @override
  Future<void> stopAll() async {
    events.add('stopAll');
  }

  @override
  Future<void> dispose() async {
    events.add('dispose');
  }
}
