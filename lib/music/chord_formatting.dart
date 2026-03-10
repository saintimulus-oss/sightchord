import 'dart:math';

import '../settings/inversion_settings.dart';
import 'chord_theory.dart';

class ChordRenderingSelection {
  const ChordRenderingSelection({
    required this.symbolData,
    required this.isRenderedNonDiatonic,
  });

  final ChordSymbolData symbolData;
  final bool isRenderedNonDiatonic;
}

class _WeightedTension {
  const _WeightedTension(this.value, this.weight);

  final String value;
  final int weight;
}

class ChordSymbolFormatter {
  const ChordSymbolFormatter._();

  static String format(ChordSymbolData chord, ChordSymbolStyle style) {
    final suffix = _qualitySuffixForStyle(chord.renderQuality, style);
    final tensionSuffix = chord.tensions.isEmpty
        ? ''
        : '(${chord.tensions.join(',')})';
    final bassSuffix = chord.bass == null ? '' : '/${chord.bass}';
    return '${chord.root}$suffix$tensionSuffix$bassSuffix';
  }

  static String example(ChordSymbolStyle style) {
    switch (style) {
      case ChordSymbolStyle.compact:
        return 'CM7  Cm7  C7alt';
      case ChordSymbolStyle.majText:
        return 'Cmaj7  CmMaj7  C13sus4';
      case ChordSymbolStyle.deltaJazz:
        return 'CΔ7  C-Δ7  C7alt';
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
          ChordQuality.minorMajor7 => 'mMaj7',
          ChordQuality.halfDiminished7 => 'm7b5',
          ChordQuality.diminishedTriad => 'dim',
          ChordQuality.diminished7 => 'dim7',
          ChordQuality.augmentedTriad => 'aug',
          ChordQuality.six => '6',
          ChordQuality.minor6 => 'm6',
          ChordQuality.major69 => '6/9',
          ChordQuality.dominant7Alt => '7alt',
          ChordQuality.dominant7Sharp11 => '7(#11)',
          ChordQuality.dominant13sus4 => '13sus4',
          ChordQuality.dominant7sus4 => '7sus4',
        };
      case ChordSymbolStyle.majText:
        return switch (quality) {
          ChordQuality.majorTriad => '',
          ChordQuality.minorTriad => 'm',
          ChordQuality.dominant7 => '7',
          ChordQuality.major7 => 'maj7',
          ChordQuality.minor7 => 'm7',
          ChordQuality.minorMajor7 => 'mMaj7',
          ChordQuality.halfDiminished7 => 'm7b5',
          ChordQuality.diminishedTriad => 'dim',
          ChordQuality.diminished7 => 'dim7',
          ChordQuality.augmentedTriad => 'aug',
          ChordQuality.six => '6',
          ChordQuality.minor6 => 'm6',
          ChordQuality.major69 => '6/9',
          ChordQuality.dominant7Alt => '7alt',
          ChordQuality.dominant7Sharp11 => '7(#11)',
          ChordQuality.dominant13sus4 => '13sus4',
          ChordQuality.dominant7sus4 => '7sus4',
        };
      case ChordSymbolStyle.deltaJazz:
        return switch (quality) {
          ChordQuality.majorTriad => '',
          ChordQuality.minorTriad => '-',
          ChordQuality.dominant7 => '7',
          ChordQuality.major7 => 'Δ7',
          ChordQuality.minor7 => '-7',
          ChordQuality.minorMajor7 => '-Δ7',
          ChordQuality.halfDiminished7 => 'ø7',
          ChordQuality.diminishedTriad => '°',
          ChordQuality.diminished7 => '°7',
          ChordQuality.augmentedTriad => '+',
          ChordQuality.six => '6',
          ChordQuality.minor6 => '-6',
          ChordQuality.major69 => '6/9',
          ChordQuality.dominant7Alt => '7alt',
          ChordQuality.dominant7Sharp11 => '7(#11)',
          ChordQuality.dominant13sus4 => '13sus4',
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

  static const int triadInversionChance = 25;
  static const int extendedInversionChance = 30;

  static const Map<int, int> _inversionWeights = {1: 55, 2: 30, 3: 15};

  static const Map<String, List<_WeightedTension>> _tensionProfiles = {
    'major7': [_WeightedTension('9', 55), _WeightedTension('13', 45)],
    'major7Sharp11': [
      _WeightedTension('9', 40),
      _WeightedTension('#11', 35),
      _WeightedTension('13', 25),
    ],
    'minor7': [
      _WeightedTension('9', 34),
      _WeightedTension('11', 41),
      _WeightedTension('13', 25),
    ],
    'minorTonic': [_WeightedTension('9', 65), _WeightedTension('11', 35)],
    'halfDiminished7': [
      _WeightedTension('11', 58),
      _WeightedTension('b13', 42),
    ],
    'primaryAuthenticMajor': [
      _WeightedTension('9', 34),
      _WeightedTension('13', 28),
      _WeightedTension('#11', 8),
      _WeightedTension('b9', 4),
      _WeightedTension('#9', 4),
      _WeightedTension('b13', 4),
    ],
    'primaryAuthenticMinor': [
      _WeightedTension('b9', 26),
      _WeightedTension('b13', 22),
      _WeightedTension('#9', 18),
      _WeightedTension('9', 10),
      _WeightedTension('#11', 8),
      _WeightedTension('13', 6),
    ],
    'secondaryToMajor': [
      _WeightedTension('9', 28),
      _WeightedTension('13', 22),
      _WeightedTension('#11', 16),
      _WeightedTension('b9', 10),
      _WeightedTension('#9', 8),
      _WeightedTension('b13', 6),
    ],
    'secondaryToMinor': [
      _WeightedTension('b9', 22),
      _WeightedTension('b13', 20),
      _WeightedTension('#9', 18),
      _WeightedTension('#11', 14),
      _WeightedTension('9', 10),
      _WeightedTension('13', 8),
    ],
    'tritoneSub': [
      _WeightedTension('#11', 34),
      _WeightedTension('b13', 24),
      _WeightedTension('9', 18),
      _WeightedTension('#9', 10),
      _WeightedTension('b9', 7),
      _WeightedTension('13', 4),
    ],
    'backdoor': [
      _WeightedTension('9', 28),
      _WeightedTension('13', 24),
      _WeightedTension('#11', 18),
      _WeightedTension('b9', 6),
      _WeightedTension('#9', 6),
      _WeightedTension('b13', 6),
    ],
    'lydianDominant': [
      _WeightedTension('#11', 38),
      _WeightedTension('9', 24),
      _WeightedTension('13', 20),
      _WeightedTension('b9', 4),
      _WeightedTension('#9', 3),
      _WeightedTension('b13', 3),
    ],
    'susDelay': [
      _WeightedTension('9', 55),
      _WeightedTension('13', 35),
      _WeightedTension('#11', 10),
    ],
    'dominantHeadedScope': [
      _WeightedTension('9', 30),
      _WeightedTension('13', 22),
      _WeightedTension('#11', 18),
      _WeightedTension('b9', 10),
      _WeightedTension('#9', 10),
      _WeightedTension('b13', 10),
    ],
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
    'minorTonic': [
      ['9', '11'],
    ],
    'halfDiminished7': [
      ['11', 'b13'],
    ],
    'primaryAuthenticMajor': [
      ['9', '13'],
      ['9', '#11'],
    ],
    'primaryAuthenticMinor': [
      ['b9', 'b13'],
      ['#9', 'b13'],
    ],
    'secondaryToMajor': [
      ['9', '#11'],
      ['9', '13'],
    ],
    'secondaryToMinor': [
      ['b9', 'b13'],
      ['#9', 'b13'],
    ],
    'tritoneSub': [
      ['#11', 'b13'],
      ['9', '#11'],
    ],
    'backdoor': [
      ['9', '13'],
      ['9', '#11'],
    ],
    'lydianDominant': [
      ['9', '#11'],
      ['#11', '13'],
    ],
    'susDelay': [
      ['9', '13'],
    ],
    'dominantHeadedScope': [
      ['9', '13'],
      ['9', '#11'],
    ],
  };

  static String renderedSymbol(GeneratedChord chord, ChordSymbolStyle style) {
    return ChordSymbolFormatter.format(chord.symbolData, style);
  }

  static String harmonicFamily({
    required HarmonicFunction harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required ChordSymbolData symbolData,
    required ChordSourceKind sourceKind,
    AppliedType? appliedType,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return 'tonic-dominant7';
    }
    if (plannedChordKind == PlannedChordKind.tonicSix) {
      return 'tonic-six';
    }
    if (appliedType == AppliedType.secondary ||
        sourceKind == ChordSourceKind.secondaryDominant) {
      return 'secondary-applied-${dominantContext?.name ?? 'plain'}';
    }
    if (appliedType == AppliedType.substitute ||
        sourceKind == ChordSourceKind.substituteDominant) {
      return 'substitute-applied-${dominantContext?.name ?? 'plain'}';
    }
    if (sourceKind == ChordSourceKind.modalInterchange) {
      return 'modal-interchange';
    }
    if (sourceKind == ChordSourceKind.tonicization) {
      return 'tonicization';
    }
    if (harmonicFunction != HarmonicFunction.free) {
      final dominantLabel = dominantIntent?.name ?? dominantContext?.name;
      return dominantLabel == null
          ? harmonicFunction.name
          : '${harmonicFunction.name}-$dominantLabel';
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
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    final parts = [
      keyName ?? '-',
      romanNumeralId == null ? '-' : MusicTheory.romanTokenOf(romanNumeralId),
      harmonicFamily(
        harmonicFunction: harmonicFunction,
        plannedChordKind: plannedChordKind,
        symbolData: symbolData,
        sourceKind: sourceKind,
        appliedType: appliedType,
        dominantContext: dominantContext,
        dominantIntent: dominantIntent,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      dominantContext?.name ?? '-',
      dominantIntent?.name ?? '-',
      resolutionTargetRomanId == null
          ? '-'
          : MusicTheory.romanTokenOf(resolutionTargetRomanId),
      patternTag ?? '-',
    ];
    if (sourceKind == ChordSourceKind.free) {
      parts.add(symbolData.root);
      parts.add(symbolData.harmonicQuality.name);
    }
    return parts.join('|');
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
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
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
        dominantContext: dominantContext,
        dominantIntent: dominantIntent,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      dominantContext?.name ?? '-',
      dominantIntent?.name ?? '-',
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
    ChordQuality? renderQuality,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    if (!allowTensions ||
        suppressTensions ||
        plannedChordKind != PlannedChordKind.resolvedRoman ||
        romanNumeralId == null) {
      return const [];
    }

    if (renderQuality == ChordQuality.major69 ||
        renderQuality == ChordQuality.dominant7Alt) {
      return const [];
    }

    final profileKey = _tensionProfileKey(
      romanNumeralId: romanNumeralId,
      renderQuality: renderQuality,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
    );
    if (profileKey == null) {
      return const [];
    }

    final profile = _tensionProfiles[profileKey] ?? const <_WeightedTension>[];
    final available = [
      for (final tension in profile)
        if (selectedTensionOptions.contains(tension.value)) tension,
    ];
    if (available.isEmpty) {
      return const [];
    }

    final pairCandidates = [
      for (final pair
          in _safeTensionPairs[profileKey] ?? const <List<String>>[])
        if (pair.every(selectedTensionOptions.contains)) pair,
    ];
    if (pairCandidates.isNotEmpty && random.nextInt(100) < 22) {
      return pairCandidates[random.nextInt(pairCandidates.length)];
    }

    final totalWeight = available.fold<int>(
      0,
      (sum, tension) => sum + tension.weight,
    );
    var remaining = random.nextInt(totalWeight);
    for (final tension in available) {
      if (remaining < tension.weight) {
        return [tension.value];
      }
      remaining -= tension.weight;
    }
    return [available.last.value];
  }

  static List<String> prioritizedTensionOptionsFor({
    required RomanNumeralId? romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required bool allowTensions,
    required Set<String> selectedTensionOptions,
    required bool suppressTensions,
    required ChordQuality renderQuality,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    if (!allowTensions ||
        suppressTensions ||
        plannedChordKind != PlannedChordKind.resolvedRoman ||
        romanNumeralId == null) {
      return const [];
    }

    if (renderQuality == ChordQuality.major69 ||
        renderQuality == ChordQuality.dominant7Alt) {
      return const [];
    }

    final profileKey = _tensionProfileKey(
      romanNumeralId: romanNumeralId,
      renderQuality: renderQuality,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
    );
    if (profileKey == null) {
      return const [];
    }

    final available = [
      for (final tension
          in _tensionProfiles[profileKey] ?? const <_WeightedTension>[])
        if (selectedTensionOptions.contains(tension.value)) tension,
    ];
    available.sort((left, right) => right.weight.compareTo(left.weight));
    return [for (final tension in available) tension.value];
  }

  static String? _tensionProfileKey({
    required RomanNumeralId romanNumeralId,
    required ChordQuality? renderQuality,
    required DominantContext? dominantContext,
    required DominantIntent? dominantIntent,
  }) {
    final effectiveIntent =
        dominantIntent ?? MusicTheory.dominantIntentForContext(dominantContext);
    if (renderQuality == ChordQuality.dominant7Sharp11 ||
        effectiveIntent == DominantIntent.tritoneSub ||
        effectiveIntent == DominantIntent.lydianDominant) {
      return effectiveIntent == DominantIntent.tritoneSub
          ? 'tritoneSub'
          : effectiveIntent == DominantIntent.lydianDominant
          ? 'lydianDominant'
          : 'major7Sharp11';
    }
    if (renderQuality == ChordQuality.dominant13sus4 ||
        renderQuality == ChordQuality.dominant7sus4 ||
        effectiveIntent == DominantIntent.susDelay) {
      return 'susDelay';
    }
    if (effectiveIntent != null) {
      return switch (effectiveIntent) {
        DominantIntent.primaryAuthenticMajor => 'primaryAuthenticMajor',
        DominantIntent.primaryAuthenticMinor => 'primaryAuthenticMinor',
        DominantIntent.secondaryToMajor => 'secondaryToMajor',
        DominantIntent.secondaryToMinor => 'secondaryToMinor',
        DominantIntent.tritoneSub => 'tritoneSub',
        DominantIntent.backdoor => 'backdoor',
        DominantIntent.lydianDominant => 'lydianDominant',
        DominantIntent.susDelay => 'susDelay',
        DominantIntent.dominantHeadedScope => 'dominantHeadedScope',
      };
    }

    return switch (romanNumeralId) {
      RomanNumeralId.iMaj7 ||
      RomanNumeralId.borrowedFlatIIIMaj7 ||
      RomanNumeralId.flatIIIMaj7Minor => 'major7',
      RomanNumeralId.ivMaj7 ||
      RomanNumeralId.borrowedFlatVIMaj7 ||
      RomanNumeralId.borrowedFlatIIMaj7 ||
      RomanNumeralId.flatVIMaj7Minor => 'major7Sharp11',
      RomanNumeralId.iiMin7 ||
      RomanNumeralId.iiiMin7 ||
      RomanNumeralId.relatedIiOfIV ||
      RomanNumeralId.viMin7 ||
      RomanNumeralId.borrowedIvMin7 ||
      RomanNumeralId.ivMin7Minor => 'minor7',
      RomanNumeralId.iMinMaj7 ||
      RomanNumeralId.iMin7 ||
      RomanNumeralId.iMin6 => 'minorTonic',
      RomanNumeralId.vDom7 ||
      RomanNumeralId.secondaryOfII ||
      RomanNumeralId.secondaryOfIII ||
      RomanNumeralId.secondaryOfIV ||
      RomanNumeralId.secondaryOfV ||
      RomanNumeralId.secondaryOfVI ||
      RomanNumeralId.substituteOfII ||
      RomanNumeralId.substituteOfIII ||
      RomanNumeralId.substituteOfIV ||
      RomanNumeralId.substituteOfV ||
      RomanNumeralId.substituteOfVI ||
      RomanNumeralId.borrowedFlatVII7 ||
      RomanNumeralId.flatVIIDom7Minor => 'primaryAuthenticMajor',
      RomanNumeralId.viiHalfDiminished7 ||
      RomanNumeralId.borrowedIiHalfDiminished7 ||
      RomanNumeralId.iiHalfDiminishedMinor ||
      RomanNumeralId.relatedIiOfIII => 'halfDiminished7',
      RomanNumeralId.iMaj69 || RomanNumeralId.sharpIDim7 => null,
    };
  }

  static ChordSymbolData maybeApplyInversion({
    required Random random,
    required ChordSymbolData symbolData,
    required InversionSettings inversionSettings,
  }) {
    if (!inversionSettings.enabled) {
      return symbolData;
    }

    final isTriad = ChordToneFormulaLibrary.isTriadLike(
      symbolData.renderQuality,
    );
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

    final formula = ChordToneFormulaLibrary.formulaFor(
      symbolData.renderQuality,
    );
    final bass = MusicTheory.transposePitch(
      symbolData.root,
      formula[selectedInversion],
      preferFlat: MusicTheory.prefersFlatSpellingForRoot(symbolData.root),
    );
    return symbolData.copyWith(bass: bass);
  }

  static bool isRenderedNonDiatonic({
    required RomanNumeralId? romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required ChordSourceKind sourceKind,
    required ChordQuality renderQuality,
    required List<String> tensions,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    if (sourceKind == ChordSourceKind.secondaryDominant ||
        sourceKind == ChordSourceKind.substituteDominant ||
        sourceKind == ChordSourceKind.modalInterchange ||
        sourceKind == ChordSourceKind.tonicization) {
      return true;
    }
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return true;
    }
    if (renderQuality == ChordQuality.dominant7Alt) {
      return true;
    }
    if (renderQuality == ChordQuality.dominant7Sharp11 &&
        dominantContext == DominantContext.primaryMinor) {
      return true;
    }
    return tensions.any(
      (tension) =>
          alteredTensions.contains(tension) &&
          !_isDiatonicRenderedTension(
            romanNumeralId: romanNumeralId,
            tension: tension,
            dominantIntent: dominantIntent,
          ),
    );
  }

  static bool _isDiatonicRenderedTension({
    required RomanNumeralId? romanNumeralId,
    required String tension,
    required DominantIntent? dominantIntent,
  }) {
    if (romanNumeralId == null) {
      return false;
    }
    return switch (_tensionProfileKey(
      romanNumeralId: romanNumeralId,
      renderQuality: null,
      dominantContext: null,
      dominantIntent: dominantIntent,
    )) {
      'major7Sharp11' => tension == '#11',
      _ => false,
    };
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
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
  }) {
    final tensions = selectTensions(
      random: random,
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      allowTensions: allowTensions,
      selectedTensionOptions: selectedTensionOptions,
      suppressTensions: suppressTensions,
      renderQuality: renderQuality,
      dominantContext: dominantContext,
      dominantIntent: dominantIntent,
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
        romanNumeralId: romanNumeralId,
        plannedChordKind: plannedChordKind,
        sourceKind: sourceKind,
        renderQuality: renderQuality,
        tensions: tensions,
        dominantContext: dominantContext,
        dominantIntent: dominantIntent,
      ),
    );
  }
}
