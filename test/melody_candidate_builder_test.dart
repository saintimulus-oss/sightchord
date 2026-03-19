import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/melody_candidate_builder.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const keyCenter = KeyCenter(tonicName: 'C', mode: KeyMode.major);

  MelodyHarmonyPalette buildPalette() {
    return MelodyHarmonyPalette.fromChord(
      chord: GeneratedChord(
        symbolData: const ChordSymbolData(
          root: 'C',
          harmonicQuality: ChordQuality.major7,
          renderQuality: ChordQuality.major7,
        ),
        repeatGuardKey: 'Cmaj7',
        harmonicComparisonKey: 'Cmaj7',
        keyName: 'C',
        keyCenter: keyCenter,
        romanNumeralId: RomanNumeralId.iMaj7,
        harmonicFunction: HarmonicFunction.tonic,
      ),
      settings: PracticeSettings(
        melodyGenerationEnabled: true,
        melodyRangeLow: 0,
        melodyRangeHigh: 12,
      ),
    );
  }

  test('nearest midi selection breaks ties deterministically', () {
    final palette = buildPalette();
    final nearest = palette.nearestMidisForPitchClass(
      0,
      targetMidi: 6,
      low: 0,
      high: 12,
      count: 1,
    );

    expect(nearest, <int>[0]);
  });

  test('nearest midi selection preserves both equidistant candidates', () {
    final palette = buildPalette();
    final nearest = palette.nearestMidisForPitchClass(
      0,
      targetMidi: 6,
      low: 0,
      high: 12,
      count: 2,
    );

    expect(nearest, <int>[0, 12]);
  });
}
