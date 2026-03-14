import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/audio/sampled_instrument_manifest.dart';

void main() {
  Map<String, Object?> buildManifestJson({required bool clampOutOfRangeNotes}) {
    return <String, Object?>{
      'id': 'test-piano',
      'displayName': 'Test Piano',
      'version': 1,
      'range': <String, Object?>{
        'minMidi': 48,
        'maxMidi': 72,
        'minLabel': 'C3',
        'maxLabel': 'C5',
      },
      'velocityLayers': <Map<String, Object?>>[
        <String, Object?>{'layer': 1, 'minVelocity': 1, 'maxVelocity': 63},
        <String, Object?>{'layer': 10, 'minVelocity': 64, 'maxVelocity': 127},
      ],
      'defaults': <String, Object?>{
        'polyphony': 8,
        'releaseFadeOutMs': 80,
        'defaultChordHoldMs': 600,
        'defaultArpeggioStepMs': 100,
        'defaultArpeggioHoldMs': 540,
        'velocityCurvePower': 0.9,
        'baseVolume': 0.9,
        'noteOnPrerollVoices': 0,
        'clampOutOfRangeNotes': clampOutOfRangeNotes,
      },
      'regions': <Map<String, Object?>>[
        <String, Object?>{
          'sample': 'samples/C3v1.flac',
          'lokey': 47,
          'hikey': 49,
          'pitchKeycenter': 48,
          'layer': 1,
          'lovel': 1,
          'hivel': 63,
        },
        <String, Object?>{
          'sample': 'samples/C3v10.flac',
          'lokey': 47,
          'hikey': 49,
          'pitchKeycenter': 48,
          'layer': 10,
          'lovel': 64,
          'hivel': 127,
        },
        <String, Object?>{
          'sample': 'samples/C4v1.flac',
          'lokey': 59,
          'hikey': 61,
          'pitchKeycenter': 60,
          'layer': 1,
          'lovel': 1,
          'hivel': 63,
        },
        <String, Object?>{
          'sample': 'samples/C4v10.flac',
          'lokey': 59,
          'hikey': 61,
          'pitchKeycenter': 60,
          'layer': 10,
          'lovel': 64,
          'hivel': 127,
        },
      ],
    };
  }

  group('SampledInstrumentManifest', () {
    test('resolves velocity layers and playback rate', () {
      final manifest = SampledInstrumentManifest.fromJson(
        buildManifestJson(clampOutOfRangeNotes: true),
      );

      final softHit = manifest.resolveRegion(midiNote: 60, velocity: 24);
      final loudHit = manifest.resolveRegion(midiNote: 61, velocity: 100);

      expect(softHit, isNotNull);
      expect(softHit!.region.layer, 1);
      expect(loudHit, isNotNull);
      expect(loudHit!.region.layer, 10);
      expect(loudHit.pitchOffsetSemitones, 1);
      expect(loudHit.playbackRate, closeTo(1.05946, 0.0001));
    });

    test('folds out-of-range notes by octave when enabled', () {
      final manifest = SampledInstrumentManifest.fromJson(
        buildManifestJson(clampOutOfRangeNotes: true),
      );

      final resolved = manifest.resolveRegion(midiNote: 36, velocity: 96);

      expect(resolved, isNotNull);
      expect(resolved!.resolvedMidi, 48);
      expect(resolved.region.sampleAssetPath, 'samples/C3v10.flac');
    });

    test('returns null for out-of-range notes when folding is disabled', () {
      final manifest = SampledInstrumentManifest.fromJson(
        buildManifestJson(clampOutOfRangeNotes: false),
      );

      expect(manifest.resolveRegion(midiNote: 36, velocity: 96), isNull);
    });
  });
}

