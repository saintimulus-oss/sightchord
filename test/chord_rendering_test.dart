import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/l10n/app_localizations_en.dart';
import 'package:chordest/l10n/app_localizations_ko.dart';
import 'package:chordest/music/chord_formatting.dart';
import 'package:chordest/music/notation_presentation.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/inversion_settings.dart';
import 'package:chordest/settings/practice_settings.dart';

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
        'C\u03947',
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
        'C\u00f87',
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
        'C\u03947(#11)/E',
      );
    });

    test('renders new jazz qualities consistently', () {
      expect(
        ChordSymbolFormatter.format(
          _symbol('A', ChordQuality.minorMajor7),
          ChordSymbolStyle.majText,
        ),
        'AmMaj7',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('A', ChordQuality.minor6),
          ChordSymbolStyle.compact,
        ),
        'Am6',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('C', ChordQuality.major69),
          ChordSymbolStyle.majText,
        ),
        'C6/9',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('E', ChordQuality.dominant7Alt),
          ChordSymbolStyle.majText,
        ),
        'E7alt',
      );
      expect(
        ChordSymbolFormatter.format(
          _symbol('D', ChordQuality.dominant13sus4),
          ChordSymbolStyle.majText,
        ),
        'D13sus4',
      );
    });

    test(
      'applies note naming preferences without changing chord semantics',
      () {
        final latinPreferences = const NotationPreferences(
          noteNamingStyle: NoteNamingStyle.latin,
        );

        expect(
          ChordSymbolFormatter.format(
            _symbol('Bb', ChordQuality.major7, bass: 'D'),
            ChordSymbolStyle.majText,
            preferences: latinPreferences,
          ),
          'Sibmaj7/Re',
        );
        expect(
          MusicNotationFormatter.formatKeyCenterLabel(
            center: const KeyCenter(tonicName: 'Bb', mode: KeyMode.major),
            labelStyle: KeyCenterLabelStyle.modeText,
            preferences: latinPreferences,
            l10n: AppLocalizationsEn(),
          ),
          'Sib major',
        );
      },
    );
  });

  group('Notation assist', () {
    test('can keep music notation in English under Korean UI', () {
      final preferences = const NotationPreferences(
        locale: MusicNotationLocale.english,
        showRomanNumeralAssist: true,
        showChordTextAssist: true,
      );
      final chord = GeneratedChord(
        symbolData: _symbol('D', ChordQuality.dominant7, tensions: const ['9']),
        repeatGuardKey: 'd7(9)',
        harmonicComparisonKey: 'd7(9)',
        keyName: 'C',
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        romanNumeralId: RomanNumeralId.secondaryOfV,
        harmonicFunction: HarmonicFunction.dominant,
      );

      expect(
        ChordRenderingHelper.displayedRomanLabel(
          chord,
          l10n: AppLocalizationsKo(),
          preferences: preferences,
        ),
        'V7(9)/V (dominant of dominant)',
      );
      expect(
        ChordRenderingHelper.chordAssistLabel(
          chord,
          l10n: AppLocalizationsKo(),
          preferences: preferences,
        ),
        'dominant seventh with nine',
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

  group('Displayed Roman tokens', () {
    test(
      'reflect rendered quality replacements instead of the planned token',
      () {
        final chord = GeneratedChord(
          symbolData: _symbol('C', ChordQuality.major7),
          repeatGuardKey: 'cmaj7',
          harmonicComparisonKey: 'cmaj7',
          keyName: 'C',
          keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.iMaj69,
          harmonicFunction: HarmonicFunction.tonic,
        );

        expect(ChordRenderingHelper.displayedRomanToken(chord), 'Imaj7');
      },
    );

    test(
      'keeps applied-dominant targets while reflecting rendered tensions',
      () {
        final chord = GeneratedChord(
          symbolData: _symbol(
            'D',
            ChordQuality.dominant7,
            tensions: const ['9'],
          ),
          repeatGuardKey: 'd7(9)',
          harmonicComparisonKey: 'd7(9)',
          keyName: 'C',
          keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.secondaryOfV,
          harmonicFunction: HarmonicFunction.dominant,
        );

        expect(ChordRenderingHelper.displayedRomanToken(chord), 'V7(9)/V');
      },
    );
  });

  group('V7sus4 gating', () {
    test('allows diatonic V7 to render as sus4', () {
      expect(
        MusicTheory.resolveRenderQuality(
          romanNumeralId: RomanNumeralId.vDom7,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          allowV7sus4: true,
          randomRoll: 0,
        ),
        ChordQuality.dominant7sus4,
      );
    });

    test('allows applied V7/x to render as sus4', () {
      expect(
        MusicTheory.resolveRenderQuality(
          romanNumeralId: RomanNumeralId.secondaryOfV,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          allowV7sus4: true,
          randomRoll: 0,
        ),
        ChordQuality.dominant7sus4,
      );
    });

    test('gives diatonic V7 a higher sus4 chance than V7/x', () {
      expect(
        MusicTheory.v7sus4ChanceForRoman(RomanNumeralId.vDom7),
        greaterThan(
          MusicTheory.v7sus4ChanceForRoman(RomanNumeralId.secondaryOfV),
        ),
      );
    });

    test('blocks substitute dominant from rendering as sus4', () {
      expect(
        MusicTheory.resolveRenderQuality(
          romanNumeralId: RomanNumeralId.substituteOfV,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          allowV7sus4: true,
          randomRoll: 0,
        ),
        ChordQuality.dominant7,
      );
    });

    test('blocks modal-interchange dominant from rendering as sus4', () {
      expect(
        MusicTheory.resolveRenderQuality(
          romanNumeralId: RomanNumeralId.borrowedFlatVII7,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          allowV7sus4: true,
          randomRoll: 0,
        ),
        ChordQuality.dominant7,
      );
    });

    test('falls back to dominant7 for sus-delay intent when disabled', () {
      expect(
        MusicTheory.resolveRenderQuality(
          romanNumeralId: RomanNumeralId.vDom7,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          allowV7sus4: false,
          randomRoll: 0,
          dominantContext: DominantContext.susDominant,
          dominantIntent: DominantIntent.susDelay,
        ),
        ChordQuality.dominant7,
      );
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

    test(
      'falls back to root position when only invalid inversion is enabled',
      () {
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
      },
    );
  });

  group('Tensions', () {
    test('treats major69 as a real 6/9 pitch-class target', () {
      final pitchClasses = ChordRenderingHelper.targetPitchClassesForSymbolData(
        symbolData: _symbol('C', ChordQuality.major69),
        romanNumeralId: RomanNumeralId.iMaj69,
      );

      expect(pitchClasses, {0, 2, 4, 7, 9});
    });

    test(
      'quality-implied dominant colors get distinct target pitch classes',
      () {
        final plain = ChordRenderingHelper.targetPitchClassesForSymbolData(
          symbolData: _symbol('G', ChordQuality.dominant7),
          romanNumeralId: RomanNumeralId.vDom7,
        );
        final sharp11 = ChordRenderingHelper.targetPitchClassesForSymbolData(
          symbolData: _symbol('G', ChordQuality.dominant7Sharp11),
          romanNumeralId: RomanNumeralId.vDom7,
          dominantIntent: DominantIntent.lydianDominant,
        );
        final sus13 = ChordRenderingHelper.targetPitchClassesForSymbolData(
          symbolData: _symbol('G', ChordQuality.dominant13sus4),
          romanNumeralId: RomanNumeralId.vDom7,
          dominantIntent: DominantIntent.susDelay,
        );
        final altered = ChordRenderingHelper.targetPitchClassesForSymbolData(
          symbolData: _symbol('G', ChordQuality.dominant7Alt),
          romanNumeralId: RomanNumeralId.vDom7,
          dominantIntent: DominantIntent.primaryAuthenticMinor,
        );

        expect(sharp11, isNot(plain));
        expect(sus13, isNot(plain));
        expect(altered, isNot(plain));
        expect(sharp11, contains(1));
        expect(sus13, contains(4));
        expect(altered, containsAll(<int>{3, 8}));
      },
    );

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

    test('triads-only language simplifies dominant surfaces aggressively', () {
      final selection = ChordRenderingHelper.buildRenderingSelection(
        random: _FixedRandom(0),
        root: 'G',
        harmonicQuality: ChordQuality.dominant7,
        renderQuality: ChordQuality.dominant7Alt,
        romanNumeralId: RomanNumeralId.vDom7,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        sourceKind: ChordSourceKind.diatonic,
        allowTensions: true,
        selectedTensionOptions: {'b9', '#9', '13'},
        suppressTensions: false,
        inversionSettings: const InversionSettings(),
        chordLanguageLevel: ChordLanguageLevel.triadsOnly,
        dominantContext: DominantContext.primaryMinor,
      );

      expect(selection.symbolData.renderQuality, ChordQuality.majorTriad);
      expect(selection.symbolData.tensions, isEmpty);
      expect(selection.isRenderedNonDiatonic, isFalse);
    });

    test('safe-extensions language keeps only gentle extension options', () {
      final prioritized = ChordRenderingHelper.prioritizedTensionOptionsFor(
        romanNumeralId: RomanNumeralId.vDom7,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        allowTensions: true,
        selectedTensionOptions: {'b9', '#11', '13', '9'},
        suppressTensions: false,
        renderQuality: ChordQuality.dominant7Sharp11,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        dominantIntent: DominantIntent.lydianDominant,
      );

      expect(prioritized, ['9', '13']);
    });

    test('does not mark IVmaj7 sharp eleven as rendered non-diatonic', () {
      final selection = ChordRenderingHelper.buildRenderingSelection(
        random: _FixedRandom(0),
        root: 'F',
        harmonicQuality: ChordQuality.major7,
        renderQuality: ChordQuality.major7,
        romanNumeralId: RomanNumeralId.ivMaj7,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        sourceKind: ChordSourceKind.diatonic,
        allowTensions: true,
        selectedTensionOptions: {'#11'},
        suppressTensions: false,
        inversionSettings: const InversionSettings(),
      );

      expect(selection.symbolData.tensions, ['#11']);
      expect(selection.isRenderedNonDiatonic, isFalse);
    });

    test(
      'honors suppressTensions when an exception requests a clean surface',
      () {
        final selection = ChordRenderingHelper.buildRenderingSelection(
          random: _FixedRandom(0),
          root: 'G',
          harmonicQuality: ChordQuality.dominant7,
          renderQuality: ChordQuality.dominant7,
          romanNumeralId: RomanNumeralId.vDom7,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          sourceKind: ChordSourceKind.diatonic,
          allowTensions: true,
          selectedTensionOptions: {'9', '#11'},
          suppressTensions: true,
          inversionSettings: const InversionSettings(),
        );

        expect(selection.symbolData.tensions, isEmpty);
      },
    );

    test('uses context-specific altered profile for minor dominant', () {
      final selection = ChordRenderingHelper.buildRenderingSelection(
        random: _FixedRandom(0),
        root: 'E',
        harmonicQuality: ChordQuality.dominant7,
        renderQuality: ChordQuality.dominant7Alt,
        romanNumeralId: RomanNumeralId.secondaryOfVI,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        sourceKind: ChordSourceKind.secondaryDominant,
        allowTensions: true,
        selectedTensionOptions: {'b9', '#9', 'b13'},
        suppressTensions: false,
        inversionSettings: const InversionSettings(),
        dominantContext: DominantContext.secondaryToMinor,
      );

      expect(selection.symbolData.renderQuality, ChordQuality.dominant7Alt);
      expect(selection.symbolData.tensions, isEmpty);
      expect(selection.isRenderedNonDiatonic, isTrue);
    });

    test(
      'uses dominant-II tension profile when context is lydian dominant',
      () {
        final selection = ChordRenderingHelper.buildRenderingSelection(
          random: _FixedRandom(0),
          root: 'D',
          harmonicQuality: ChordQuality.dominant7,
          renderQuality: ChordQuality.dominant7Sharp11,
          romanNumeralId: RomanNumeralId.vDom7,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          sourceKind: ChordSourceKind.diatonic,
          allowTensions: true,
          selectedTensionOptions: {'#11', '13'},
          suppressTensions: false,
          inversionSettings: const InversionSettings(),
          dominantContext: DominantContext.dominantIILydian,
        );

        expect(selection.symbolData.tensions, ['#11', '13']);
      },
    );

    test('marks tonicization source as rendered non-diatonic', () {
      final renderedNonDiatonic = ChordRenderingHelper.isRenderedNonDiatonic(
        romanNumeralId: RomanNumeralId.secondaryOfV,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        sourceKind: ChordSourceKind.tonicization,
        renderQuality: ChordQuality.dominant7,
        tensions: const [],
      );

      expect(renderedNonDiatonic, isTrue);
    });

    test('prioritizes dominant headed scope tensions by profile weight', () {
      final prioritized = ChordRenderingHelper.prioritizedTensionOptionsFor(
        romanNumeralId: RomanNumeralId.vDom7,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        allowTensions: true,
        selectedTensionOptions: {'#9', '13', '9'},
        suppressTensions: false,
        renderQuality: ChordQuality.dominant7,
        dominantIntent: DominantIntent.dominantHeadedScope,
      );
      expect(prioritized, ['9', '13', '#9']);
    });
  });

  group('Repeat guard', () {
    test('free mode keeps same quality available across different roots', () {
      final cMajor = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: null,
        romanNumeralId: null,
        harmonicFunction: HarmonicFunction.free,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('C', ChordQuality.major7),
        sourceKind: ChordSourceKind.free,
      );
      final dMajor = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: null,
        romanNumeralId: null,
        harmonicFunction: HarmonicFunction.free,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('D', ChordQuality.major7),
        sourceKind: ChordSourceKind.free,
      );

      expect(cMajor, isNot(dMajor));
    });

    test('includes dominant context in applied repeat guard keys', () {
      final primaryMinor = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        romanNumeralId: RomanNumeralId.secondaryOfVI,
        harmonicFunction: HarmonicFunction.dominant,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('E', ChordQuality.dominant7),
        sourceKind: ChordSourceKind.secondaryDominant,
        appliedType: AppliedType.secondary,
        resolutionTargetRomanId: RomanNumeralId.viMin7,
        dominantContext: DominantContext.primaryMinor,
      );
      final secondaryMinor = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        romanNumeralId: RomanNumeralId.secondaryOfVI,
        harmonicFunction: HarmonicFunction.dominant,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('E', ChordQuality.dominant7),
        sourceKind: ChordSourceKind.secondaryDominant,
        appliedType: AppliedType.secondary,
        resolutionTargetRomanId: RomanNumeralId.viMin7,
        dominantContext: DominantContext.secondaryToMinor,
      );

      expect(primaryMinor, isNot(secondaryMinor));
    });

    test('includes dominant intent in applied repeat guard keys', () {
      final primary = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        romanNumeralId: RomanNumeralId.secondaryOfV,
        harmonicFunction: HarmonicFunction.dominant,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('D', ChordQuality.dominant7),
        sourceKind: ChordSourceKind.secondaryDominant,
        appliedType: AppliedType.secondary,
        resolutionTargetRomanId: RomanNumeralId.vDom7,
        dominantContext: DominantContext.secondaryToMajor,
        dominantIntent: DominantIntent.secondaryToMajor,
      );
      final scopeHeaded = ChordRenderingHelper.buildRepeatGuardKey(
        keyName: 'C',
        romanNumeralId: RomanNumeralId.secondaryOfV,
        harmonicFunction: HarmonicFunction.dominant,
        plannedChordKind: PlannedChordKind.resolvedRoman,
        symbolData: _symbol('D', ChordQuality.dominant7),
        sourceKind: ChordSourceKind.secondaryDominant,
        appliedType: AppliedType.secondary,
        resolutionTargetRomanId: RomanNumeralId.vDom7,
        dominantContext: DominantContext.secondaryToMajor,
        dominantIntent: DominantIntent.dominantHeadedScope,
      );
      expect(primary, isNot(scopeHeaded));
    });
  });
}
