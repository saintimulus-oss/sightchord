enum AppliedType { secondary, substitute }

enum PlannedChordKind {
  resolvedRoman,
  // Surface-only major-tonic line-cliche variant (I7).
  tonicDominant7,
  // Surface-only major-tonic line-cliche variant (I6), not a full 6/m6/mM7/augM7 system.
  tonicSix,
}

enum ChordQuality {
  majorTriad,
  minorTriad,
  dominant7,
  major7,
  minor7,
  halfDiminished7,
  diminishedTriad,
  diminished7,
  augmentedTriad,
  six,
  dominant7sus4,
}

enum ChordSymbolStyle { compact, majText, deltaJazz }

enum HarmonicFunction { tonic, predominant, dominant, free }

enum ChordSourceKind {
  free,
  diatonic,
  secondaryDominant,
  substituteDominant,
  modalInterchange,
}

enum RomanNumeralId {
  iMaj7,
  iiMin7,
  iiiMin7,
  ivMaj7,
  vDom7,
  viMin7,
  viiHalfDiminished7,
  secondaryOfII,
  secondaryOfIII,
  secondaryOfIV,
  secondaryOfV,
  secondaryOfVI,
  substituteOfII,
  substituteOfIII,
  substituteOfIV,
  substituteOfV,
  substituteOfVI,
  borrowedIvMin7,
  borrowedFlatVII7,
  borrowedFlatVIMaj7,
  borrowedFlatIIIMaj7,
  borrowedIiHalfDiminished7,
  borrowedFlatIIMaj7,
}

class RomanSpec {
  const RomanSpec({
    required this.id,
    required this.token,
    required this.quality,
    required this.harmonicFunction,
    required this.sourceKind,
    this.resolutionTargetId,
  });

  final RomanNumeralId id;
  final String token;
  final ChordQuality quality;
  final HarmonicFunction harmonicFunction;
  final ChordSourceKind sourceKind;
  final RomanNumeralId? resolutionTargetId;

  bool get isNonDiatonic =>
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant ||
      sourceKind == ChordSourceKind.modalInterchange;
}

class ChordSymbolData {
  const ChordSymbolData({
    required this.root,
    required this.harmonicQuality,
    required this.renderQuality,
    this.tensions = const [],
    this.bass,
  });

  final String root;
  final ChordQuality harmonicQuality;
  final ChordQuality renderQuality;
  final List<String> tensions;
  final String? bass;

  ChordSymbolData copyWith({
    String? root,
    ChordQuality? harmonicQuality,
    ChordQuality? renderQuality,
    List<String>? tensions,
    String? bass,
    bool clearBass = false,
  }) {
    return ChordSymbolData(
      root: root ?? this.root,
      harmonicQuality: harmonicQuality ?? this.harmonicQuality,
      renderQuality: renderQuality ?? this.renderQuality,
      tensions: tensions ?? this.tensions,
      bass: clearBass ? null : bass ?? this.bass,
    );
  }
}

abstract class SmartDebugInfo {
  String describe();
}

class GeneratedChord {
  const GeneratedChord({
    required this.symbolData,
    required this.repeatGuardKey,
    required this.harmonicComparisonKey,
    this.keyName,
    this.romanNumeralId,
    this.resolutionRomanNumeralId,
    this.harmonicFunction = HarmonicFunction.free,
    this.patternTag,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.sourceKind = ChordSourceKind.free,
    this.appliedType,
    this.resolutionTargetRomanId,
    this.wasExcludedFallback = false,
    this.isRenderedNonDiatonic = false,
    this.smartDebug,
  });

  final ChordSymbolData symbolData;
  final String repeatGuardKey;
  final String harmonicComparisonKey;
  final String? keyName;
  final RomanNumeralId? romanNumeralId;
  final RomanNumeralId? resolutionRomanNumeralId;
  final HarmonicFunction harmonicFunction;
  final String? patternTag;
  final PlannedChordKind plannedChordKind;
  final ChordSourceKind sourceKind;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final bool wasExcludedFallback;
  final bool isRenderedNonDiatonic;
  final SmartDebugInfo? smartDebug;

  bool get isAppliedDominant =>
      appliedType != null ||
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant;

  String get analysisLabel {
    if (keyName == null || romanNumeralId == null) {
      return '';
    }
    return '$keyName: ${MusicTheory.romanTokenOf(romanNumeralId!)}';
  }

  GeneratedChord copyWith({
    ChordSymbolData? symbolData,
    String? repeatGuardKey,
    String? harmonicComparisonKey,
    String? keyName,
    RomanNumeralId? romanNumeralId,
    RomanNumeralId? resolutionRomanNumeralId,
    HarmonicFunction? harmonicFunction,
    String? patternTag,
    PlannedChordKind? plannedChordKind,
    ChordSourceKind? sourceKind,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    bool? wasExcludedFallback,
    bool? isRenderedNonDiatonic,
    SmartDebugInfo? smartDebug,
  }) {
    return GeneratedChord(
      symbolData: symbolData ?? this.symbolData,
      repeatGuardKey: repeatGuardKey ?? this.repeatGuardKey,
      harmonicComparisonKey:
          harmonicComparisonKey ?? this.harmonicComparisonKey,
      keyName: keyName ?? this.keyName,
      romanNumeralId: romanNumeralId ?? this.romanNumeralId,
      resolutionRomanNumeralId:
          resolutionRomanNumeralId ?? this.resolutionRomanNumeralId,
      harmonicFunction: harmonicFunction ?? this.harmonicFunction,
      patternTag: patternTag ?? this.patternTag,
      plannedChordKind: plannedChordKind ?? this.plannedChordKind,
      sourceKind: sourceKind ?? this.sourceKind,
      appliedType: appliedType ?? this.appliedType,
      resolutionTargetRomanId:
          resolutionTargetRomanId ?? this.resolutionTargetRomanId,
      wasExcludedFallback: wasExcludedFallback ?? this.wasExcludedFallback,
      isRenderedNonDiatonic:
          isRenderedNonDiatonic ?? this.isRenderedNonDiatonic,
      smartDebug: smartDebug ?? this.smartDebug,
    );
  }
}

class ChordExclusionContext {
  const ChordExclusionContext({
    this.renderedSymbols = const <String>{},
    this.repeatGuardKeys = const <String>{},
    this.harmonicComparisonKeys = const <String>{},
  });

  final Set<String> renderedSymbols;
  final Set<String> repeatGuardKeys;
  final Set<String> harmonicComparisonKeys;
}

class ChordToneFormulaLibrary {
  const ChordToneFormulaLibrary._();

  static const Map<ChordQuality, List<int>> formulas = {
    ChordQuality.majorTriad: [0, 4, 7],
    ChordQuality.minorTriad: [0, 3, 7],
    ChordQuality.dominant7: [0, 4, 7, 10],
    ChordQuality.major7: [0, 4, 7, 11],
    ChordQuality.minor7: [0, 3, 7, 10],
    ChordQuality.halfDiminished7: [0, 3, 6, 10],
    ChordQuality.diminishedTriad: [0, 3, 6],
    ChordQuality.diminished7: [0, 3, 6, 9],
    ChordQuality.augmentedTriad: [0, 4, 8],
    ChordQuality.six: [0, 4, 7, 9],
    ChordQuality.dominant7sus4: [0, 5, 7, 10],
  };

  static List<int> formulaFor(ChordQuality quality) => formulas[quality]!;

  static bool isTriadLike(ChordQuality quality) =>
      formulaFor(quality).length == 3;

  static List<int> validInversionsFor(ChordQuality quality) {
    final chordSize = formulaFor(quality).length;
    final maxInversion = chordSize > 4 ? 3 : chordSize - 1;
    return [
      for (var inversion = 1; inversion <= maxInversion; inversion += 1)
        inversion,
    ];
  }
}

class MusicTheory {
  const MusicTheory._();

  static const List<String> keyOptions = [
    'C',
    'C#/Db',
    'D',
    'D#/Eb',
    'E',
    'F',
    'F#/Gb',
    'G',
    'G#/Ab',
    'A',
    'A#/Bb',
    'B',
  ];

  static const List<String> freeModeRoots = [
    'C',
    'C#',
    'D',
    'Eb',
    'E',
    'F',
    'F#',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  static const List<ChordQuality> freeModeQualities = [
    ChordQuality.majorTriad,
    ChordQuality.minorTriad,
    ChordQuality.dominant7,
    ChordQuality.major7,
    ChordQuality.minor7,
    ChordQuality.diminishedTriad,
    ChordQuality.augmentedTriad,
  ];

  static const List<RomanNumeralId> diatonicRomans = [
    RomanNumeralId.iMaj7,
    RomanNumeralId.iiMin7,
    RomanNumeralId.iiiMin7,
    RomanNumeralId.ivMaj7,
    RomanNumeralId.vDom7,
    RomanNumeralId.viMin7,
    RomanNumeralId.viiHalfDiminished7,
  ];

  static const List<RomanNumeralId> secondaryRomans = [
    RomanNumeralId.secondaryOfII,
    RomanNumeralId.secondaryOfIII,
    RomanNumeralId.secondaryOfIV,
    RomanNumeralId.secondaryOfV,
    RomanNumeralId.secondaryOfVI,
  ];

  static const List<RomanNumeralId> substituteRomans = [
    RomanNumeralId.substituteOfII,
    RomanNumeralId.substituteOfIII,
    RomanNumeralId.substituteOfIV,
    RomanNumeralId.substituteOfV,
    RomanNumeralId.substituteOfVI,
  ];

  static const List<RomanNumeralId> modalInterchangeRomans = [
    RomanNumeralId.borrowedIvMin7,
    RomanNumeralId.borrowedFlatVII7,
    RomanNumeralId.borrowedFlatVIMaj7,
    RomanNumeralId.borrowedFlatIIIMaj7,
    RomanNumeralId.borrowedIiHalfDiminished7,
    RomanNumeralId.borrowedFlatIIMaj7,
  ];

  static const Map<RomanNumeralId, RomanSpec> romanSpecs = {
    RomanNumeralId.iMaj7: RomanSpec(
      id: RomanNumeralId.iMaj7,
      token: 'IM7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.iiMin7: RomanSpec(
      id: RomanNumeralId.iiMin7,
      token: 'IIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.iiiMin7: RomanSpec(
      id: RomanNumeralId.iiiMin7,
      token: 'IIIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.ivMaj7: RomanSpec(
      id: RomanNumeralId.ivMaj7,
      token: 'IVM7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.vDom7: RomanSpec(
      id: RomanNumeralId.vDom7,
      token: 'V7',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.viMin7: RomanSpec(
      id: RomanNumeralId.viMin7,
      token: 'VIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.viiHalfDiminished7: RomanSpec(
      id: RomanNumeralId.viiHalfDiminished7,
      token: 'VIIm7b5',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.diatonic,
    ),
    RomanNumeralId.secondaryOfII: RomanSpec(
      id: RomanNumeralId.secondaryOfII,
      token: 'V7/II',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.secondaryDominant,
      resolutionTargetId: RomanNumeralId.iiMin7,
    ),
    RomanNumeralId.secondaryOfIII: RomanSpec(
      id: RomanNumeralId.secondaryOfIII,
      token: 'V7/III',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.secondaryDominant,
      resolutionTargetId: RomanNumeralId.iiiMin7,
    ),
    RomanNumeralId.secondaryOfIV: RomanSpec(
      id: RomanNumeralId.secondaryOfIV,
      token: 'V7/IV',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.secondaryDominant,
      resolutionTargetId: RomanNumeralId.ivMaj7,
    ),
    RomanNumeralId.secondaryOfV: RomanSpec(
      id: RomanNumeralId.secondaryOfV,
      token: 'V7/V',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.secondaryDominant,
      resolutionTargetId: RomanNumeralId.vDom7,
    ),
    RomanNumeralId.secondaryOfVI: RomanSpec(
      id: RomanNumeralId.secondaryOfVI,
      token: 'V7/VI',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.secondaryDominant,
      resolutionTargetId: RomanNumeralId.viMin7,
    ),
    RomanNumeralId.substituteOfII: RomanSpec(
      id: RomanNumeralId.substituteOfII,
      token: 'subV7/II',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.substituteDominant,
      resolutionTargetId: RomanNumeralId.iiMin7,
    ),
    RomanNumeralId.substituteOfIII: RomanSpec(
      id: RomanNumeralId.substituteOfIII,
      token: 'subV7/III',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.substituteDominant,
      resolutionTargetId: RomanNumeralId.iiiMin7,
    ),
    RomanNumeralId.substituteOfIV: RomanSpec(
      id: RomanNumeralId.substituteOfIV,
      token: 'subV7/IV',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.substituteDominant,
      resolutionTargetId: RomanNumeralId.ivMaj7,
    ),
    RomanNumeralId.substituteOfV: RomanSpec(
      id: RomanNumeralId.substituteOfV,
      token: 'subV7/V',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.substituteDominant,
      resolutionTargetId: RomanNumeralId.vDom7,
    ),
    RomanNumeralId.substituteOfVI: RomanSpec(
      id: RomanNumeralId.substituteOfVI,
      token: 'subV7/VI',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.substituteDominant,
      resolutionTargetId: RomanNumeralId.viMin7,
    ),
    RomanNumeralId.borrowedIvMin7: RomanSpec(
      id: RomanNumeralId.borrowedIvMin7,
      token: 'ivm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
    RomanNumeralId.borrowedFlatVII7: RomanSpec(
      id: RomanNumeralId.borrowedFlatVII7,
      token: 'bVII7',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
    RomanNumeralId.borrowedFlatVIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatVIMaj7,
      token: 'bVImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
    RomanNumeralId.borrowedFlatIIIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatIIIMaj7,
      token: 'bIIImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
    RomanNumeralId.borrowedIiHalfDiminished7: RomanSpec(
      id: RomanNumeralId.borrowedIiHalfDiminished7,
      token: 'iiø7',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
    RomanNumeralId.borrowedFlatIIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatIIMaj7,
      token: 'bIImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
    ),
  };

  static const Map<String, List<String>> _majorScaleRootsByKey = {
    'C': ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
    'C#/Db': ['Db', 'Eb', 'F', 'Gb', 'Ab', 'Bb', 'C'],
    'D': ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
    'D#/Eb': ['Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D'],
    'E': ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
    'F': ['F', 'G', 'A', 'Bb', 'C', 'D', 'E'],
    'F#/Gb': ['Gb', 'Ab', 'Bb', 'Cb', 'Db', 'Eb', 'F'],
    'G': ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
    'G#/Ab': ['Ab', 'Bb', 'C', 'Db', 'Eb', 'F', 'G'],
    'A': ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
    'A#/Bb': ['Bb', 'C', 'D', 'Eb', 'F', 'G', 'A'],
    'B': ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A#'],
  };

  static const Map<String, int> noteToSemitone = {
    'C': 0,
    'B#': 0,
    'C#': 1,
    'Db': 1,
    'D': 2,
    'D#': 3,
    'Eb': 3,
    'E': 4,
    'Fb': 4,
    'F': 5,
    'E#': 5,
    'F#': 6,
    'Gb': 6,
    'G': 7,
    'G#': 8,
    'Ab': 8,
    'A': 9,
    'A#': 10,
    'Bb': 10,
    'B': 11,
    'Cb': 11,
  };

  static const List<String> _sharpNoteNames = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];

  static const List<String> _flatNoteNames = [
    'C',
    'Db',
    'D',
    'Eb',
    'E',
    'F',
    'Gb',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  static const Set<String> _flatPreferredKeys = {
    'F',
    'C#/Db',
    'D#/Eb',
    'F#/Gb',
    'G#/Ab',
    'A#/Bb',
  };

  static RomanSpec specFor(RomanNumeralId romanNumeralId) =>
      romanSpecs[romanNumeralId]!;

  static String romanTokenOf(RomanNumeralId romanNumeralId) =>
      specFor(romanNumeralId).token;

  static const int diatonicV7sus4Chance = 7;
  static const int appliedV7sus4Chance = 4;

  static int v7sus4ChanceForRoman(RomanNumeralId romanNumeralId) {
    if (romanNumeralId == RomanNumeralId.vDom7) {
      return diatonicV7sus4Chance;
    }
    if (specFor(romanNumeralId).sourceKind ==
        ChordSourceKind.secondaryDominant) {
      return appliedV7sus4Chance;
    }
    return 0;
  }

  static int? keyTonicSemitone(String key) {
    final tonicRoot = _majorScaleRootsByKey[key]?.first;
    return tonicRoot == null ? null : noteToSemitone[tonicRoot];
  }

  static bool prefersFlatSpellingForKey(String key) =>
      _flatPreferredKeys.contains(key);

  static bool prefersFlatSpellingForRoot(String root) =>
      root.contains('b') || root == 'F';

  static String spellPitch(int semitone, {required bool preferFlat}) {
    final spellings = preferFlat ? _flatNoteNames : _sharpNoteNames;
    return spellings[semitone % 12];
  }

  static String transposePitch(
    String root,
    int semitoneOffset, {
    bool? preferFlat,
  }) {
    final semitone = noteToSemitone[root];
    if (semitone == null) {
      return root;
    }
    return spellPitch(
      (semitone + semitoneOffset) % 12,
      preferFlat: preferFlat ?? prefersFlatSpellingForRoot(root),
    );
  }

  static String lowerPitch(String note, {bool preferFlat = true}) {
    final semitone = noteToSemitone[note];
    if (semitone == null) {
      return note;
    }
    return spellPitch((semitone + 11) % 12, preferFlat: preferFlat);
  }

  static String resolveChordRoot(String key, RomanNumeralId romanNumeralId) {
    final spec = specFor(romanNumeralId);
    final scale = _majorScaleRootsByKey[key];
    if (scale == null) {
      return 'C';
    }

    switch (romanNumeralId) {
      case RomanNumeralId.iMaj7:
        return scale[0];
      case RomanNumeralId.iiMin7:
      case RomanNumeralId.borrowedIiHalfDiminished7:
        return scale[1];
      case RomanNumeralId.iiiMin7:
        return scale[2];
      case RomanNumeralId.ivMaj7:
      case RomanNumeralId.borrowedIvMin7:
        return scale[3];
      case RomanNumeralId.vDom7:
        return scale[4];
      case RomanNumeralId.viMin7:
        return scale[5];
      case RomanNumeralId.viiHalfDiminished7:
        return scale[6];
      case RomanNumeralId.borrowedFlatVII7:
        return _borrowedFlatRootForKey(key, 10);
      case RomanNumeralId.borrowedFlatVIMaj7:
        return _borrowedFlatRootForKey(key, 8);
      case RomanNumeralId.borrowedFlatIIIMaj7:
        return _borrowedFlatRootForKey(key, 3);
      case RomanNumeralId.borrowedFlatIIMaj7:
        return _borrowedFlatRootForKey(key, 1);
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
        final targetId = spec.resolutionTargetId;
        if (targetId == null) {
          return scale[0];
        }
        final targetRoot = resolveChordRoot(key, targetId);
        final isSubstitute =
            spec.sourceKind == ChordSourceKind.substituteDominant;
        return _resolveAppliedDominantRoot(
          key: key,
          targetRoot: targetRoot,
          isSubstitute: isSubstitute,
        );
    }
  }

  static String _borrowedFlatRootForKey(String key, int semitoneOffset) {
    final tonicSemitone = keyTonicSemitone(key);
    if (tonicSemitone == null) {
      return 'C';
    }
    return spellPitch((tonicSemitone + semitoneOffset) % 12, preferFlat: true);
  }

  static String _resolveAppliedDominantRoot({
    required String key,
    required String targetRoot,
    required bool isSubstitute,
  }) {
    final targetSemitone = noteToSemitone[targetRoot];
    if (targetSemitone == null) {
      return 'C';
    }
    final dominantSemitone = isSubstitute
        ? (targetSemitone + 1) % 12
        : (targetSemitone + 7) % 12;
    final preferFlat =
        isSubstitute ||
        targetRoot.contains('b') ||
        prefersFlatSpellingForKey(key);
    return spellPitch(dominantSemitone, preferFlat: preferFlat);
  }

  static ChordQuality resolveRenderQuality({
    required RomanNumeralId romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required bool allowV7sus4,
    required int randomRoll,
  }) {
    switch (plannedChordKind) {
      case PlannedChordKind.tonicDominant7:
        return ChordQuality.dominant7;
      case PlannedChordKind.tonicSix:
        return ChordQuality.six;
      case PlannedChordKind.resolvedRoman:
        final baseQuality = specFor(romanNumeralId).quality;
        // Limit sus4 rendering to canonical V7 and applied V7/x identities.
        final sus4Chance = allowV7sus4
            ? v7sus4ChanceForRoman(romanNumeralId)
            : 0;
        if (baseQuality == ChordQuality.dominant7 &&
            sus4Chance > 0 &&
            randomRoll < sus4Chance) {
          return ChordQuality.dominant7sus4;
        }
        return baseQuality;
    }
  }
}
