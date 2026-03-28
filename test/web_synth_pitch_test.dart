import 'package:chordest/audio/web_synth_pitch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveWebSynthSourceMidiNote', () {
    test('parses natural sample note names', () {
      expect(
        resolveWebSynthSourceMidiNote(
          'assets/piano/salamander_essential/samples/C4v10.flac',
        ),
        60,
      );
    });

    test('parses encoded sharp sample note names', () {
      expect(
        resolveWebSynthSourceMidiNote(
          'assets/piano/salamander_essential/samples/D%232v16.flac',
        ),
        39,
      );
    });

    test('returns null for unrelated asset names', () {
      expect(resolveWebSynthSourceMidiNote('assets/tick.mp3'), isNull);
    });
  });

  group('resolveWebSynthFrequency', () {
    test('uses concert pitch for exact sample playback', () {
      expect(
        resolveWebSynthFrequency(
          assetPath: 'assets/piano/salamander_essential/samples/A4v10.flac',
          playbackRate: 1,
        ),
        closeTo(440.0, 0.001),
      );
    });

    test('applies playback-rate transposition', () {
      expect(
        resolveWebSynthFrequency(
          assetPath: 'assets/piano/salamander_essential/samples/C4v10.flac',
          playbackRate: 2,
        ),
        closeTo(523.251, 0.01),
      );
    });
  });
}
