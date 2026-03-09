import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_theory.dart';

class ChordRenderingSelection {
  const ChordRenderingSelection({
    required this.symbolData,
    required this.isRenderedNonDiatonic,
  });

  final ChordSymbolData symbolData;
  final bool isRenderedNonDiatonic;
}

class ChordSymbolFormatter {
  const ChordSymbolFormatter._();

  static String format(ChordSymbolData chord, ChordSymbolStyle style) {
    final suffix = _qualitySuffixForStyle(chord.renderQuality, style);
    final tensionSuffix =
        chord.tensions.isEmpty ? '' : '(${chord.tensions.join(',')})';
    final bassSuffix = chord.bass == null ? '' : '/${chord.bass}';
    return '${chord.root}$suffix$tensionSuffix$bassSuffix';
  }

  static String example(ChordSymbolStyle style) {
    switch (style) {
      case ChordSymbolStyle.compact:
        return 'CM7  Cm7  C7';
      case ChordSymbolStyle.majText:
        return 'Cmaj7  Cm7  C7';
      case ChordSymbolStyle.deltaJazz:
        return 'CΔ7  C-7  C7';
    }
  }

  static String _qualitySuffixForStyle(
    ChordQuality quality,
    ChordSymbolStyle style,
  ) {
    switch (style) {
      case ChordSymbolStyle.compact:
        return switch (quality) {
          ChordQuality.majorTriad => '',
          ChordQuality.minorTriad => 'm',
          ChordQuality.dominant7 => '7',
          ChordQuality.major7 => 'M7',
          ChordQuality.minor7 => 'm7',
          ChordQuality.halfDiminished7 => 'm7b5',
          ChordQuality.diminishedTriad => 'dim',
          ChordQuality.diminished7 => 'dim7',
          ChordQuality.augmentedTriad => 'aug',
          ChordQuality.six => '6',
          ChordQuality.dominant7sus4 => '7sus4',
        };
      case ChordSymbolStyle.majText:
        return switch (quality) {
          ChordQuality.majorTriad => '',
          ChordQuality.minorTriad => 'm',
          ChordQuality.dominant7 => '7',
          ChordQuality.major7 => 'maj7',
          ChordQuality.minor7 => 'm7',
          ChordQuality.halfDiminished7 => 'm7b5',
          ChordQuality.diminishedTriad => 'dim',
          ChordQuality.diminished7 => 'dim7',
          ChordQuality.augmentedTriad => 'aug',
          ChordQuality.six => '6',
          ChordQuality.dominant7sus4 => '7sus4',
        };
      case ChordSymbolStyle.deltaJazz:
        return switch (quality) {
          ChordQuality.majorTriad => '',
          ChordQuality.minorTriad => '-',
          ChordQuality.dominant7 => '7',
          ChordQuality.major7 => 'Δ7',
          ChordQuality.minor7 => '-7',
          ChordQuality.halfDiminished7 => 'ø7',
          ChordQuality.diminishedTriad => '°',
          ChordQuality.diminished7 => '°7',
          ChordQuality.augmentedTriad => '+',
          ChordQuality.six => '6',
          ChordQuality.dominant7sus4 => '7sus4',
        };
    }
  }
}

class ChordRenderingHelper {
  const ChordRenderingHelper._();

  static const List<String> supportedTensionOptions = [
    '9',
    '11',
    '13',
    '#11',
    'b9',
    '#9',
    'b13',
  ];

  static const Set<String> alteredTensions = {'#11', 'b9', '#9', 'b13'};

  static const int dominantSus4Chance = 5;
  static const int triadInversionChance = 25;
  static const int extendedInversionChance = 30;

  static const Map<int, int> _inversionWeights = {1: 55, 2: 30, 3: 15};

  static const Map<String, List<String>> _tensionProfiles = {
    'major7': ['9', '13'],
    'major7Sharp11': ['9', '#11', '13'],
    'minor7': ['9', '11', '13'],
    'dominant7': ['9', 'b9', '#9', '#11', 'b13'],
    'halfDiminished7': ['11', 'b13'],
  };

  static const Map<String, List<List<String>>> _safeTensionPairs = {
    'major7': [
      ['9', '13'],
    ],
    'major7Sharp11': [
      ['9', '#11'],
      ['9', '13'],
      ['#11', '13'],
    ],
    'minor7': [
      ['9', '11'],
      ['9', '13'],
      ['11', '13'],
    ],
    'dominant7': [
      ['9', '#11'],
      ['9', 'b13'],
      ['b9', 'b13'],
      ['#9', 'b13'],
    ],
    'halfDiminished7': [
      ['11', 'b13'],
    ],
  };

  static String renderedSymbol(
    GeneratedChord chord,
    ChordSymbolStyle style,
  ) {
    return ChordSymbolFormatter.format(chord.symbolData, style);
  }

  static String harmonicFamily({
    required HarmonicFunction harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required ChordSymbolData symbolData,
    required ChordSourceKind sourceKind,
    AppliedType? appliedType,
  }) {
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return 'tonic-dominant7';
    }
    if (plannedChordKind == PlannedChordKind.tonicSix) {
      return 'tonic-six';
    }
    if (appliedType == AppliedType.secondary ||
        sourceKind == ChordSourceKind.secondaryDominant) {
      return 'secondary-applied';
    }
    if (appliedType == AppliedType.substitute ||
        sourceKind == ChordSourceKind.substituteDominant) {
      return 'substitute-applied';
    }
    if (sourceKind == ChordSourceKind.modalInterchange) {
      return 'modal-interchange';
    }
    if (harmonicFunction != HarmonicFunction.free) {
      return harmonicFunction.name;
    }
    return 'free-${symbolData.harmonicQuality.name}';
  }

  static String buildRepeatGuardKey({
    required String? keyName,
    required RomanNumeralId? romanNumeralId,
    required HarmonicFunction harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required ChordSymbolData symbolData,
    required ChordSourceKind sourceKind,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    String? patternTag,
  }) {
    return [
      keyName ?? '-',
      romanNumeralId == null ? '-' : MusicTheory.romanTokenOf(romanNumeralId),
      harmonicFamily(
        harmonicFunction: harmonicFunction,
        plannedChordKind: plannedChordKind,
        symbolData: symbolData,
        sourceKind: sourceKind,
        appliedType: appliedType,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      resolutionTargetRomanId == null
          ? '-'
          : MusicTheory.romanTokenOf(resolutionTargetRomanId),
      patternTag ?? '-',
    ].join('|');
  }

  static String buildHarmonicComparisonKey({
    required String? keyName,
    required RomanNumeralId? romanNumeralId,
    required HarmonicFunction harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required ChordSymbolData symbolData,
    required ChordSourceKind sourceKind,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    String? patternTag,
  }) {
    return [
      keyName ?? '-',
      romanNumeralId == null ? '-' : MusicTheory.romanTokenOf(romanNumeralId),
      harmonicFamily(
        harmonicFunction: harmonicFunction,
        plannedChordKind: plannedChordKind,
        symbolData: symbolData,
        sourceKind: sourceKind,
        appliedType: appliedType,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      resolutionTargetRomanId == null
          ? '-'
          : MusicTheory.romanTokenOf(resolutionTargetRomanId),
      patternTag ?? '-',
      symbolData.root,
      symbolData.harmonicQuality.name,
    ].join('|');
  }

  static List<String> selectTensions({
    required Random random,
    required RomanNumeralId? romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required bool allowTensions,
    required Set<String> selectedTensionOptions,
    required bool suppressTensions,
  }) {
    if (!allowTensions ||
        suppressTensions ||
        plannedChordKind != PlannedChordKind.resolvedRoman ||
        romanNumeralId == null) {
      return const [];
    }

    final profileKey = _tensionProfileKey(romanNumeralId);
    if (profileKey == null) {
      return const [];
    }

    final profile = _tensionProfiles[profileKey] ?? const <String>[];
    final available = [
      for (final tension in profile)
        if (selectedTensionOptions.contains(tension)) tension,
    ];
    if (available.isEmpty) {
      return const [];
    }

    final pairCandidates = [
      for (final pair in _safeTensionPairs[profileKey] ?? const <List<String>>[])
        if (pair.every(selectedTensionOptions.contains)) pair,
    ];
    if (pairCandidates.isNotEmpty && random.nextInt(100) < 20) {
      return pairCandidates[random.nextInt(pairCandidates.length)];
    }

    return [available[random.nextInt(available.length)]];
  }

  static String? _tensionProfileKey(RomanNumeralId romanNumeralId) {
    switch (romanNumeralId) {
      case RomanNumeralId.iMaj7:
      case RomanNumeralId.borrowedFlatIIIMaj7:
        return 'major7';
      case RomanNumeralId.ivMaj7:
      case RomanNumeralId.borrowedFlatVIMaj7:
      case RomanNumeralId.borrowedFlatIIMaj7:
        return 'major7Sharp11';
      case RomanNumeralId.iiMin7:
      case RomanNumeralId.iiiMin7:
      case RomanNumeralId.viMin7:
      case RomanNumeralId.borrowedIvMin7:
        return 'minor7';
      case RomanNumeralId.vDom7:
      case RomanNumeralId.secondaryOfII:
      case RomanNumeralId.secondaryOfIII:
      case RomanNumeralId.secondaryOfIV:
      case RomanNumeralId.secondaryOfV:
      case RomanNumeralId.secondaryOfVI:
      case RomanNumeralId.substituteOfII:
      case RomanNumeralId.substituteOfIII:
      case RomanNumeralId.substituteOfIV:
      case RomanNumeralId.substituteOfV:
      case RomanNumeralId.substituteOfVI:
      case RomanNumeralId.borrowedFlatVII7:
        return 'dominant7';
      case RomanNumeralId.viiHalfDiminished7:
      case RomanNumeralId.borrowedIiHalfDiminished7:
        return 'halfDiminished7';
    }
  }

  static ChordSymbolData maybeApplyInversion({
    required Random random,
    required ChordSymbolData symbolData,
    required InversionSettings inversionSettings,
  }) {
    if (!inversionSettings.enabled) {
      return symbolData;
    }

    final isTriad = ChordToneFormulaLibrary.isTriadLike(symbolData.renderQuality);
    final chance = isTriad ? triadInversionChance : extendedInversionChance;
    if (random.nextInt(100) >= chance) {
      return symbolData;
    }

    final validInversions = ChordToneFormulaLibrary.validInversionsFor(
      symbolData.renderQuality,
    );
    final enabledValidInversions = [
      for (final inversion in inversionSettings.enabledInversions)
        if (validInversions.contains(inversion)) inversion,
    ];
    if (enabledValidInversions.isEmpty) {
      return symbolData;
    }

    final totalWeight = enabledValidInversions.fold<int>(
      0,
      (sum, inversion) => sum + (_inversionWeights[inversion] ?? 0),
    );
    var remaining = random.nextInt(totalWeight);
    var selectedInversion = enabledValidInversions.first;
    for (final inversion in enabledValidInversions) {
      final weight = _inversionWeights[inversion] ?? 0;
      if (remaining < weight) {
        selectedInversion = inversion;
        break;
      }
      remaining -= weight;
    }

    final formula = ChordToneFormulaLibrary.formulaFor(symbolData.renderQuality);
    final bass = MusicTheory.transposePitch(
      symbolData.root,
      formula[selectedInversion],
      preferFlat: MusicTheory.prefersFlatSpellingForRoot(symbolData.root),
    );
    return symbolData.copyWith(bass: bass);
  }

  static bool isRenderedNonDiatonic({
    required PlannedChordKind plannedChordKind,
    required ChordSourceKind sourceKind,
    required List<String> tensions,
  }) {
    if (sourceKind == ChordSourceKind.secondaryDominant ||
        sourceKind == ChordSourceKind.substituteDominant ||
        sourceKind == ChordSourceKind.modalInterchange) {
      return true;
    }
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return true;
    }
    return tensions.any(alteredTensions.contains);
  }

  static ChordRenderingSelection buildRenderingSelection({
    required Random random,
    required String root,
    required ChordQuality harmonicQuality,
    required ChordQuality renderQuality,
    required RomanNumeralId? romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required ChordSourceKind sourceKind,
    required bool allowTensions,
    required Set<String> selectedTensionOptions,
    required bool suppressTensions,
    required InversionSettings inversionSettings,
  }) {
    final tensions = selectTensions(
      random: random,
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      allowTensions: allowTensions,
      selectedTensionOptions: selectedTensionOptions,
      suppressTensions: suppressTensions,
    );
    final baseData = ChordSymbolData(
      root: root,
      harmonicQuality: harmonicQuality,
      renderQuality: renderQuality,
      tensions: tensions,
    );
    final inverted = maybeApplyInversion(
      random: random,
      symbolData: baseData,
      inversionSettings: inversionSettings,
    );
    return ChordRenderingSelection(
      symbolData: inverted,
      isRenderedNonDiatonic: isRenderedNonDiatonic(
        plannedChordKind: plannedChordKind,
        sourceKind: sourceKind,
        tensions: tensions,
      ),
    );
  }
}
