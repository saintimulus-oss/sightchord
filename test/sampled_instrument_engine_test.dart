import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/audio/sampled_instrument_engine.dart';

void main() {
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
}

