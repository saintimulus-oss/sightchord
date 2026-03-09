import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_formatting.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/settings/practice_settings.dart';

class _FixedRandom implements Random {
  _FixedRandom(this.value);

  final int value;

  @override
  bool nextBool() => value.isEven;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => value % max;
}

class _SequenceRandom implements Random {
  _SequenceRandom(this.values);

  final List<int> values;
  int _index = 0;

  @override
  bool nextBool() => nextInt(2) == 0;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) {
    final value = values[_index % values.length];
    _index += 1;
    return value % max;
  }
}

ChordSymbolData _symbol(
  String root,
  ChordQuality quality, {
  List<String> tensions = const [],
  String? bass,
}) {
  return ChordSymbolData(
    root: root,
    harmonicQuality: quality,
    renderQuality: quality,
    tensions: tensions,
    bass: bass,
  );
}

void main() {
  group('ChordSymbolFormatter', () {
    test('formats style presets consistently', () {
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.major7),
          ChordSymbolStyle.compact,
        ),
        'CM7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.major7),
          ChordSymbolStyle.majText,
        ),
        'Cmaj7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.major7),
          ChordSymbolStyle.deltaJazz,
        ),
        'CΔ7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.minor7),
          ChordSymbolStyle.deltaJazz,
        ),
        'C-7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.halfDiminished7),
          ChordSymbolStyle.deltaJazz,
        ),
        'Cø7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.augmentedTriad),
          ChordSymbolStyle.deltaJazz,
        ),
        'C+',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.diminishedTriad),
          ChordSymbolStyle.compact,
        ),
        'Cdim',
      );
    });

    test('keeps tensions and slash bass across styles', () {
      final symbol = _symbol(
        'C',
        ChordQuality.major7,
        tensions: const ['#11'],
        bass: 'E',
      );

      expect(
        ChordSymbolFormatter.format(symbol, ChordSymbolStyle.compact),
        'CM7(#11)/E',
      );
      expect(
        ChordSymbolFormatter.format(symbol, ChordSymbolStyle.majText),
        'Cmaj7(#11)/E',
      );
      expect(
        ChordSymbolFormatter.format(symbol, ChordSymbolStyle.deltaJazz),
        'CΔ7(#11)/E',
      );
    });
  });

  group('Modal interchange spelling', () {
    test('resolves borrowed roots in C major with pragmatic spelling', () {
      final modalSymbols = <RomanNumeralId, String>{
        RomanNumeralId.borrowedIvMin7: 'Fm7',
        RomanNumeralId.borrowedFlatVII7: 'Bb7',
        RomanNumeralId.borrowedFlatVIMaj7: 'Abmaj7',
        RomanNumeralId.borrowedFlatIIIMaj7: 'Ebmaj7',
        RomanNumeralId.borrowedIiHalfDiminished7: 'Dm7b5',
        RomanNumeralId.borrowedFlatIIMaj7: 'Dbmaj7',
      };

      for (final entry in modalSymbols.entries) {
        final spec = MusicTheory.specFor(entry.key);
        final rendered = ChordSymbolFormatter.format(
          ChordSymbolData(
            root: MusicTheory.resolveChordRoot('C', entry.key),
            harmonicQuality: spec.quality,
            renderQuality: spec.quality,
          ),
          ChordSymbolStyle.majText,
        );
        expect(rendered, entry.value);
      }
    });
  });

  group('Inversions', () {
    test('renders major seventh slash chords', () {
      final settings = const InversionSettings(
        enabled: true,
        firstInversionEnabled: true,
        secondInversionEnabled: false,
        thirdInversionEnabled: false,
      );
      final first = ChordRenderingHelper.maybeApplyInversion(
        random: _SequenceRandom([0, 0]),
        symbolData: _symbol('C', ChordQuality.major7),
        inversionSettings: settings,
      );
      expect(
        ChordSymbolFormatter.format(first, ChordSymbolStyle.majText),
        'Cmaj7/E',
      );

      final second = ChordRenderingHelper.maybeApplyInversion(
        random: _SequenceRandom([0, 0]),
        symbolData: _symbol('C', ChordQuality.major7),
        inversionSettings: const InversionSettings(
          enabled: true,
          firstInversionEnabled: false,
          secondInversionEnabled: true,
          thirdInversionEnabled: false,
        ),
      );
      expect(
        ChordSymbolFormatter.format(second, ChordSymbolStyle.majText),
        'Cmaj7/G',
      );

      final third = ChordRenderingHelper.maybeApplyInversion(
        random: _SequenceRandom([0, 0]),
        symbolData: _symbol('C', ChordQuality.major7),
        inversionSettings: const InversionSettings(
          enabled: true,
          firstInversionEnabled: false,
          secondInversionEnabled: false,
          thirdInversionEnabled: true,
        ),
      );
      expect(
        ChordSymbolFormatter.format(third, ChordSymbolStyle.majText),
        'Cmaj7/B',
      );
    });

    test('uses actual chord members for sus4 inversion', () {
      final inverted = ChordRenderingHelper.maybeApplyInversion(
        random: _SequenceRandom([0, 0]),
        symbolData: _symbol('G', ChordQuality.dominant7sus4),
        inversionSettings: const InversionSettings(
          enabled: true,
          firstInversionEnabled: true,
          secondInversionEnabled: false,
          thirdInversionEnabled: false,
        ),
      );

      expect(
        ChordSymbolFormatter.format(inverted, ChordSymbolStyle.majText),
        'G7sus4/C',
      );
    });

    test('falls back to root position when only invalid inversion is enabled', () {
      final result = ChordRenderingHelper.maybeApplyInversion(
        random: _SequenceRandom([0, 0]),
        symbolData: _symbol('C', ChordQuality.majorTriad),
        inversionSettings: const InversionSettings(
          enabled: true,
          firstInversionEnabled: false,
          secondInversionEnabled: false,
          thirdInversionEnabled: true,
        ),
      );

      expect(
        ChordSymbolFormatter.format(result, ChordSymbolStyle.majText),
        'C',
      );
    });
  });

  group('Tensions', () {
    test('filters tension chips against profile', () {
      final tensions = ChordRenderingHelper.selectTensions(
        random: _FixedRandom(0),
        romanNumeralId: RomanNumeralId.vDom7,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        allowTensions: true,
        selectedTensionOptions: {'9', '#11'},
        suppressTensions: false,
      );

      expect(tensions, ['9', '#11']);
    });
  });
}
