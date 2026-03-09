enum KeyMode { major, minor }

enum AppliedType { secondary, substitute }

enum PlannedChordKind { resolvedRoman, tonicDominant7, tonicSix }

enum ChordQuality {
  majorTriad,
  minorTriad,
  dominant7,
  major7,
  minor7,
  minorMajor7,
  halfDiminished7,
  diminishedTriad,
  diminished7,
  augmentedTriad,
  six,
  minor6,
  major69,
  dominant7Alt,
  dominant7Sharp11,
  dominant13sus4,
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
  tonicization,
}

enum RomanNumeralId {
  iMaj7,
  iMaj69,
  iiMin7,
  iiiMin7,
  ivMaj7,
  vDom7,
  viMin7,
  viiHalfDiminished7,
  sharpIDim7,
  iMinMaj7,
  iMin7,
  iMin6,
  iiHalfDiminishedMinor,
  flatIIIMaj7Minor,
  ivMin7Minor,
  flatVIMaj7Minor,
  flatVIIDom7Minor,
  relatedIiOfIII,
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

enum ModulationIntensity { off, low, medium, high }

enum JazzPreset { standardsCore, modulationStudy, advanced }

enum SourceProfile { fakebookStandard, recordingInspired }

enum DominantContext {
  primaryMajor,
  primaryMinor,
  secondaryToMajor,
  secondaryToMinor,
  tritoneSubstitute,
  backdoor,
  dominantIILydian,
  susDominant,
}

enum ModulationKind { none, tonicization, real }

enum SmartBlockedReason {
  singleActiveKey,
  noCompatibleKey,
  modalBranchChosen,
  appliedNotInserted,
  phrasePositionLowPriority,
  excludedFallback,
  noCadentialPattern,
}

class KeyCenter {
  const KeyCenter({
    required this.tonicName,
    required this.mode,
    this.closenessClass = 0,
  });

  final String tonicName;
  final KeyMode mode;
  final int closenessClass;

  String get displayName =>
      '${MusicTheory.displayRootForKey(tonicName)} ${mode.name}';

  bool get prefersFlatSpelling =>
      MusicTheory.prefersFlatSpellingForKey(tonicName);

  int? get tonicSemitone => MusicTheory.keyTonicSemitone(tonicName);

  String serialize() => '$tonicName|${mode.name}';

  KeyCenter copyWith({String? tonicName, KeyMode? mode, int? closenessClass}) {
    return KeyCenter(
      tonicName: tonicName ?? this.tonicName,
      mode: mode ?? this.mode,
      closenessClass: closenessClass ?? this.closenessClass,
    );
  }

  static KeyCenter fromSerialized(String value) {
    final parts = value.split('|');
    if (parts.length != 2) {
      return const KeyCenter(tonicName: 'C', mode: KeyMode.major);
    }
    return KeyCenter(
      tonicName: parts.first,
      mode: KeyMode.values.firstWhere(
        (candidate) => candidate.name == parts.last,
        orElse: () => KeyMode.major,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is KeyCenter &&
        other.tonicName == tonicName &&
        other.mode == mode;
  }

  @override
  int get hashCode => Object.hash(tonicName, mode);
}

class RomanSpec {
  const RomanSpec({
    required this.id,
    required this.token,
    required this.quality,
    required this.harmonicFunction,
    required this.sourceKind,
    this.homeMode,
    this.tonicSemitoneOffset,
    this.resolutionTargetId,
    this.preferFlatSpelling,
  });

  final RomanNumeralId id;
  final String token;
  final ChordQuality quality;
  final HarmonicFunction harmonicFunction;
  final ChordSourceKind sourceKind;
  final KeyMode? homeMode;
  final int? tonicSemitoneOffset;
  final RomanNumeralId? resolutionTargetId;
  final bool? preferFlatSpelling;

  bool get isNonDiatonic =>
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant ||
      sourceKind == ChordSourceKind.modalInterchange ||
      sourceKind == ChordSourceKind.tonicization;
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
    this.keyCenter,
    this.romanNumeralId,
    this.resolutionRomanNumeralId,
    this.harmonicFunction = HarmonicFunction.free,
    this.patternTag,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.sourceKind = ChordSourceKind.free,
    this.appliedType,
    this.resolutionTargetRomanId,
    this.dominantContext,
    this.modulationKind = ModulationKind.none,
    this.wasExcludedFallback = false,
    this.isRenderedNonDiatonic = false,
    this.smartDebug,
  });

  final ChordSymbolData symbolData;
  final String repeatGuardKey;
  final String harmonicComparisonKey;
  final String? keyName;
  final KeyCenter? keyCenter;
  final RomanNumeralId? romanNumeralId;
  final RomanNumeralId? resolutionRomanNumeralId;
  final HarmonicFunction harmonicFunction;
  final String? patternTag;
  final PlannedChordKind plannedChordKind;
  final ChordSourceKind sourceKind;
  final AppliedType? appliedType;
  final RomanNumeralId? resolutionTargetRomanId;
  final DominantContext? dominantContext;
  final ModulationKind modulationKind;
  final bool wasExcludedFallback;
  final bool isRenderedNonDiatonic;
  final SmartDebugInfo? smartDebug;

  bool get isAppliedDominant =>
      appliedType != null ||
      sourceKind == ChordSourceKind.secondaryDominant ||
      sourceKind == ChordSourceKind.substituteDominant;

  String get analysisLabel {
    if (romanNumeralId == null) {
      return '';
    }
    final centerLabel = keyCenter?.displayName ?? keyName;
    if (centerLabel == null || centerLabel.isEmpty) {
      return MusicTheory.romanTokenOf(romanNumeralId!);
    }
    return '$centerLabel: ${MusicTheory.romanTokenOf(romanNumeralId!)}';
  }

  GeneratedChord copyWith({
    ChordSymbolData? symbolData,
    String? repeatGuardKey,
    String? harmonicComparisonKey,
    String? keyName,
    KeyCenter? keyCenter,
    RomanNumeralId? romanNumeralId,
    RomanNumeralId? resolutionRomanNumeralId,
    HarmonicFunction? harmonicFunction,
    String? patternTag,
    PlannedChordKind? plannedChordKind,
    ChordSourceKind? sourceKind,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    ModulationKind? modulationKind,
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
      keyCenter: keyCenter ?? this.keyCenter,
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
      dominantContext: dominantContext ?? this.dominantContext,
      modulationKind: modulationKind ?? this.modulationKind,
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
    ChordQuality.minorMajor7: [0, 3, 7, 11],
    ChordQuality.halfDiminished7: [0, 3, 6, 10],
    ChordQuality.diminishedTriad: [0, 3, 6],
    ChordQuality.diminished7: [0, 3, 6, 9],
    ChordQuality.augmentedTriad: [0, 4, 8],
    ChordQuality.six: [0, 4, 7, 9],
    ChordQuality.minor6: [0, 3, 7, 9],
    ChordQuality.major69: [0, 4, 7, 9],
    ChordQuality.dominant7Alt: [0, 4, 7, 10],
    ChordQuality.dominant7Sharp11: [0, 4, 7, 10],
    ChordQuality.dominant13sus4: [0, 5, 7, 10],
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

  static const List<RomanNumeralId> majorDiatonicRomans = [
    RomanNumeralId.iMaj7,
    RomanNumeralId.iMaj69,
    RomanNumeralId.iiMin7,
    RomanNumeralId.iiiMin7,
    RomanNumeralId.ivMaj7,
    RomanNumeralId.vDom7,
    RomanNumeralId.viMin7,
    RomanNumeralId.viiHalfDiminished7,
  ];

  static const List<RomanNumeralId> minorDiatonicRomans = [
    RomanNumeralId.iMinMaj7,
    RomanNumeralId.iMin7,
    RomanNumeralId.iMin6,
    RomanNumeralId.iiHalfDiminishedMinor,
    RomanNumeralId.flatIIIMaj7Minor,
    RomanNumeralId.ivMin7Minor,
    RomanNumeralId.vDom7,
    RomanNumeralId.flatVIMaj7Minor,
    RomanNumeralId.flatVIIDom7Minor,
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
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 0,
    ),
    RomanNumeralId.iMaj69: RomanSpec(
      id: RomanNumeralId.iMaj69,
      token: 'I6/9',
      quality: ChordQuality.major69,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 0,
    ),
    RomanNumeralId.iiMin7: RomanSpec(
      id: RomanNumeralId.iiMin7,
      token: 'IIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 2,
    ),
    RomanNumeralId.iiiMin7: RomanSpec(
      id: RomanNumeralId.iiiMin7,
      token: 'IIIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 4,
    ),
    RomanNumeralId.ivMaj7: RomanSpec(
      id: RomanNumeralId.ivMaj7,
      token: 'IVM7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 5,
    ),
    RomanNumeralId.vDom7: RomanSpec(
      id: RomanNumeralId.vDom7,
      token: 'V7',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.diatonic,
      tonicSemitoneOffset: 7,
    ),
    RomanNumeralId.viMin7: RomanSpec(
      id: RomanNumeralId.viMin7,
      token: 'VIm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 9,
    ),
    RomanNumeralId.viiHalfDiminished7: RomanSpec(
      id: RomanNumeralId.viiHalfDiminished7,
      token: 'VIIm7b5',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 11,
    ),
    RomanNumeralId.sharpIDim7: RomanSpec(
      id: RomanNumeralId.sharpIDim7,
      token: '#Idim7',
      quality: ChordQuality.diminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.tonicization,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 1,
      preferFlatSpelling: false,
    ),
    RomanNumeralId.iMinMaj7: RomanSpec(
      id: RomanNumeralId.iMinMaj7,
      token: 'ImMaj7',
      quality: ChordQuality.minorMajor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 0,
    ),
    RomanNumeralId.iMin7: RomanSpec(
      id: RomanNumeralId.iMin7,
      token: 'Im7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 0,
    ),
    RomanNumeralId.iMin6: RomanSpec(
      id: RomanNumeralId.iMin6,
      token: 'Im6',
      quality: ChordQuality.minor6,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 0,
    ),
    RomanNumeralId.iiHalfDiminishedMinor: RomanSpec(
      id: RomanNumeralId.iiHalfDiminishedMinor,
      token: 'IIm7b5',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 2,
    ),
    RomanNumeralId.flatIIIMaj7Minor: RomanSpec(
      id: RomanNumeralId.flatIIIMaj7Minor,
      token: 'bIIImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 3,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.ivMin7Minor: RomanSpec(
      id: RomanNumeralId.ivMin7Minor,
      token: 'IVm7',
      quality: ChordQuality.minor7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 5,
    ),
    RomanNumeralId.flatVIMaj7Minor: RomanSpec(
      id: RomanNumeralId.flatVIMaj7Minor,
      token: 'bVImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 8,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.flatVIIDom7Minor: RomanSpec(
      id: RomanNumeralId.flatVIIDom7Minor,
      token: 'bVII7',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.diatonic,
      homeMode: KeyMode.minor,
      tonicSemitoneOffset: 10,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.relatedIiOfIII: RomanSpec(
      id: RomanNumeralId.relatedIiOfIII,
      token: 'IIm7b5/III',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.tonicization,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 6,
      resolutionTargetId: RomanNumeralId.iiiMin7,
      preferFlatSpelling: false,
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
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 5,
    ),
    RomanNumeralId.borrowedFlatVII7: RomanSpec(
      id: RomanNumeralId.borrowedFlatVII7,
      token: 'bVII7',
      quality: ChordQuality.dominant7,
      harmonicFunction: HarmonicFunction.dominant,
      sourceKind: ChordSourceKind.modalInterchange,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 10,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.borrowedFlatVIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatVIMaj7,
      token: 'bVImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 8,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.borrowedFlatIIIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatIIIMaj7,
      token: 'bIIImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.tonic,
      sourceKind: ChordSourceKind.modalInterchange,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 3,
      preferFlatSpelling: true,
    ),
    RomanNumeralId.borrowedIiHalfDiminished7: RomanSpec(
      id: RomanNumeralId.borrowedIiHalfDiminished7,
      token: 'iim7b5',
      quality: ChordQuality.halfDiminished7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 2,
    ),
    RomanNumeralId.borrowedFlatIIMaj7: RomanSpec(
      id: RomanNumeralId.borrowedFlatIIMaj7,
      token: 'bIImaj7',
      quality: ChordQuality.major7,
      harmonicFunction: HarmonicFunction.predominant,
      sourceKind: ChordSourceKind.modalInterchange,
      homeMode: KeyMode.major,
      tonicSemitoneOffset: 1,
      preferFlatSpelling: true,
    ),
  };

  static const Map<String, int> _keyTonicSemitones = {
    'C': 0,
    'C#/Db': 1,
    'D': 2,
    'D#/Eb': 3,
    'E': 4,
    'F': 5,
    'F#/Gb': 6,
    'G': 7,
    'G#/Ab': 8,
    'A': 9,
    'A#/Bb': 10,
    'B': 11,
  };

  static const Map<String, String> _displayRootsByKey = {
    'C': 'C',
    'C#/Db': 'Db',
    'D': 'D',
    'D#/Eb': 'Eb',
    'E': 'E',
    'F': 'F',
    'F#/Gb': 'Gb',
    'G': 'G',
    'G#/Ab': 'Ab',
    'A': 'A',
    'A#/Bb': 'Bb',
    'B': 'B',
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

  static List<RomanNumeralId> diatonicRomansForMode(KeyMode mode) {
    return mode == KeyMode.major ? majorDiatonicRomans : minorDiatonicRomans;
  }

  static KeyCenter keyCenterFor(String key, {KeyMode mode = KeyMode.major}) {
    return KeyCenter(tonicName: key, mode: mode);
  }

  static int? keyTonicSemitone(String key) => _keyTonicSemitones[key];

  static String displayRootForKey(String key) => _displayRootsByKey[key] ?? key;

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
    return resolveChordRootForCenter(
      keyCenterFor(
        key,
        mode: specFor(romanNumeralId).homeMode ?? KeyMode.major,
      ),
      romanNumeralId,
    );
  }

  static String resolveChordRootForCenter(
    KeyCenter keyCenter,
    RomanNumeralId romanNumeralId,
  ) {
    final spec = specFor(romanNumeralId);
    final tonicSemitone = keyCenter.tonicSemitone;
    if (tonicSemitone == null) {
      return 'C';
    }

    if (spec.tonicSemitoneOffset != null) {
      return spellPitch(
        tonicSemitone + spec.tonicSemitoneOffset!,
        preferFlat: spec.preferFlatSpelling ?? keyCenter.prefersFlatSpelling,
      );
    }

    final targetId = spec.resolutionTargetId;
    if (targetId == null) {
      return displayRootForKey(keyCenter.tonicName);
    }

    final targetRoot = resolveChordRootForCenter(keyCenter, targetId);
    final isSubstitute = spec.sourceKind == ChordSourceKind.substituteDominant;
    return _resolveAppliedDominantRoot(
      key: keyCenter.tonicName,
      targetRoot: targetRoot,
      isSubstitute: isSubstitute,
    );
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

  static ChordQuality resolveRenderQuality({
    required RomanNumeralId romanNumeralId,
    required PlannedChordKind plannedChordKind,
    required bool allowV7sus4,
    required int randomRoll,
    DominantContext? dominantContext,
  }) {
    switch (plannedChordKind) {
      case PlannedChordKind.tonicDominant7:
        return ChordQuality.dominant7;
      case PlannedChordKind.tonicSix:
        return ChordQuality.six;
      case PlannedChordKind.resolvedRoman:
        final baseQuality = specFor(romanNumeralId).quality;
        if (baseQuality != ChordQuality.dominant7) {
          return baseQuality;
        }
        if (dominantContext == DominantContext.susDominant) {
          return ChordQuality.dominant13sus4;
        }
        if (dominantContext == DominantContext.primaryMinor ||
            dominantContext == DominantContext.secondaryToMinor) {
          return randomRoll < 58
              ? ChordQuality.dominant7Alt
              : ChordQuality.dominant7;
        }
        if (dominantContext == DominantContext.tritoneSubstitute ||
            dominantContext == DominantContext.dominantIILydian) {
          return randomRoll < 68
              ? ChordQuality.dominant7Sharp11
              : ChordQuality.dominant7;
        }
        if (dominantContext == DominantContext.backdoor) {
          return randomRoll < 36
              ? ChordQuality.dominant7Sharp11
              : ChordQuality.dominant7;
        }
        if ((dominantContext == DominantContext.primaryMajor ||
                dominantContext == DominantContext.secondaryToMajor) &&
            allowV7sus4 &&
            randomRoll < 20) {
          return ChordQuality.dominant13sus4;
        }

        final sus4Chance = allowV7sus4
            ? v7sus4ChanceForRoman(romanNumeralId)
            : 0;
        if (sus4Chance > 0 && randomRoll < sus4Chance) {
          return ChordQuality.dominant7sus4;
        }
        return baseQuality;
    }
  }
}
