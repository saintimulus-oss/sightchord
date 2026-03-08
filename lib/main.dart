import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'smart_generator.dart';

class GeneratedChord {
  const GeneratedChord({
    required this.chord,
    required this.baseChord,
    required this.repeatGuardKey,
    required this.harmonicComparisonKey,
    this.keyName,
    this.romanNumeral,
    this.resolutionRomanNumeral,
    this.harmonicFunction = 'free',
    this.surfaceVariant,
    this.tensions = const [],
    this.patternTag,
    this.plannedChordKind = PlannedChordKind.resolvedRoman,
    this.appliedType,
    this.resolutionTargetRoman,
    this.wasExcludedFallback = false,
    this.isRenderedNonDiatonic = false,
    this.smartDebug,
  });

  final String chord;
  final String baseChord;
  final String repeatGuardKey;
  final String harmonicComparisonKey;
  final String? keyName;
  final String? romanNumeral;
  final String? resolutionRomanNumeral;
  final String harmonicFunction;
  final SurfaceVariant? surfaceVariant;
  final List<String> tensions;
  final String? patternTag;
  final PlannedChordKind plannedChordKind;
  final AppliedType? appliedType;
  final String? resolutionTargetRoman;
  final bool wasExcludedFallback;
  final bool isRenderedNonDiatonic;
  final SmartGenerationDebug? smartDebug;

  bool get isAppliedDominant =>
      appliedType != null ||
      romanNumeral?.startsWith('V7/') == true ||
      romanNumeral?.startsWith('subV7/') == true;

  GeneratedChord copyWith({
    String? chord,
    String? baseChord,
    String? repeatGuardKey,
    String? harmonicComparisonKey,
    String? keyName,
    String? romanNumeral,
    String? resolutionRomanNumeral,
    String? harmonicFunction,
    SurfaceVariant? surfaceVariant,
    List<String>? tensions,
    String? patternTag,
    PlannedChordKind? plannedChordKind,
    AppliedType? appliedType,
    String? resolutionTargetRoman,
    bool? wasExcludedFallback,
    bool? isRenderedNonDiatonic,
    SmartGenerationDebug? smartDebug,
  }) {
    return GeneratedChord(
      chord: chord ?? this.chord,
      baseChord: baseChord ?? this.baseChord,
      repeatGuardKey: repeatGuardKey ?? this.repeatGuardKey,
      harmonicComparisonKey:
          harmonicComparisonKey ?? this.harmonicComparisonKey,
      keyName: keyName ?? this.keyName,
      romanNumeral: romanNumeral ?? this.romanNumeral,
      resolutionRomanNumeral:
          resolutionRomanNumeral ?? this.resolutionRomanNumeral,
      harmonicFunction: harmonicFunction ?? this.harmonicFunction,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      tensions: tensions ?? this.tensions,
      patternTag: patternTag ?? this.patternTag,
      plannedChordKind: plannedChordKind ?? this.plannedChordKind,
      appliedType: appliedType ?? this.appliedType,
      resolutionTargetRoman:
          resolutionTargetRoman ?? this.resolutionTargetRoman,
      wasExcludedFallback: wasExcludedFallback ?? this.wasExcludedFallback,
      isRenderedNonDiatonic:
          isRenderedNonDiatonic ?? this.isRenderedNonDiatonic,
      smartDebug: smartDebug ?? this.smartDebug,
    );
  }

  String get analysisLabel {
    if (keyName == null || romanNumeral == null) {
      return '';
    }
    return '$keyName: $romanNumeral';
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

class ChordSymbolParts {
  const ChordSymbolParts({
    required this.root,
    required this.quality,
  });

  final String root;
  final String quality;
}

class ChordRenderingSelection {
  const ChordRenderingSelection({
    required this.chord,
    required this.surfaceVariant,
    required this.tensions,
    required this.isRenderedNonDiatonic,
  });

  final String chord;
  final SurfaceVariant? surfaceVariant;
  final List<String> tensions;
  final bool isRenderedNonDiatonic;
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

  static const Set<String> _alteredTensions = {
    '#11',
    'b9',
    '#9',
    'b13',
  };

  static const Map<String, List<String>> _tensionProfiles = {
    'IM7': ['9', '13'],
    'IIm7': ['9', '11', '13'],
    'IIIm7': ['9', '11'],
    'IVM7': ['9', '#11', '13'],
    'V7': ['9', 'b9', '#9', '#11', 'b13'],
    'VIm7': ['9', '11'],
    'VIIm7b5': ['11', 'b13'],
  };

  static const Map<String, List<List<String>>> _safeTensionPairs = {
    'IM7': [
      ['9', '13'],
    ],
    'IIm7': [
      ['9', '11'],
      ['9', '13'],
      ['11', '13'],
    ],
    'IIIm7': [
      ['9', '11'],
    ],
    'IVM7': [
      ['9', '#11'],
      ['9', '13'],
      ['#11', '13'],
    ],
    'V7': [
      ['9', '#11'],
      ['9', 'b13'],
      ['b9', 'b13'],
      ['#9', 'b13'],
    ],
    'VIm7': [
      ['9', '11'],
    ],
    'VIIm7b5': [
      ['11', 'b13'],
    ],
  };

  static const int dominantSus4Chance = 5;

  static ChordSymbolParts parseChordSymbol(String chord) {
    final match = RegExp(r'^[A-G](?:#|b)?').firstMatch(chord);
    final root = match?.group(0) ?? 'C';
    return ChordSymbolParts(
      root: root,
      quality: chord.substring(root.length),
    );
  }

  static String harmonicFamily({
    required String harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required String baseChord,
    AppliedType? appliedType,
  }) {
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return 'tonic-dominant7';
    }
    if (plannedChordKind == PlannedChordKind.tonicSix) {
      return 'tonic-six';
    }
    if (appliedType == AppliedType.secondary) {
      return 'secondary-applied';
    }
    if (appliedType == AppliedType.substitute) {
      return 'substitute-applied';
    }
    if (harmonicFunction != 'free') {
      return harmonicFunction;
    }

    final quality = parseChordSymbol(baseChord).quality;
    if (quality == '7') {
      return 'free-dominant';
    }
    if (quality == 'M7') {
      return 'free-major7';
    }
    if (quality == 'm7') {
      return 'free-minor7';
    }
    if (quality == 'm7b5') {
      return 'free-half-diminished';
    }
    return 'free-$quality';
  }

  static String buildRepeatGuardKey({
    required String? keyName,
    required String? romanNumeral,
    required String harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required String baseChord,
    AppliedType? appliedType,
    String? resolutionTargetRoman,
    String? patternTag,
  }) {
    return [
      keyName ?? '-',
      romanNumeral ?? baseChord,
      harmonicFamily(
        harmonicFunction: harmonicFunction,
        plannedChordKind: plannedChordKind,
        baseChord: baseChord,
        appliedType: appliedType,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      resolutionTargetRoman ?? '-',
      patternTag ?? '-',
    ].join('|');
  }

  static String buildHarmonicComparisonKey({
    required String? keyName,
    required String? romanNumeral,
    required String harmonicFunction,
    required PlannedChordKind plannedChordKind,
    required String baseChord,
    AppliedType? appliedType,
    String? resolutionTargetRoman,
    String? patternTag,
  }) {
    return [
      keyName ?? '-',
      romanNumeral ?? '-',
      harmonicFamily(
        harmonicFunction: harmonicFunction,
        plannedChordKind: plannedChordKind,
        baseChord: baseChord,
        appliedType: appliedType,
      ),
      plannedChordKind.name,
      appliedType?.name ?? '-',
      resolutionTargetRoman ?? '-',
      patternTag ?? '-',
      baseChord,
    ].join('|');
  }
  static SurfaceVariant? selectSurfaceVariant({
    required Random random,
    required bool allowV7sus4,
    required String baseChord,
    required PlannedChordKind plannedChordKind,
  }) {
    if (!allowV7sus4 || plannedChordKind != PlannedChordKind.resolvedRoman) {
      return null;
    }
    if (!isDominantQuality(baseChord)) {
      return null;
    }
    if (random.nextInt(100) >= dominantSus4Chance) {
      return null;
    }
    return SurfaceVariant.dominantSus4;
  }

  static List<String> selectTensions({
    required Random random,
    required String? romanNumeral,
    required PlannedChordKind plannedChordKind,
    required bool allowTensions,
    required Set<String> selectedTensionOptions,
    required bool suppressTensions,
  }) {
    if (!allowTensions ||
        suppressTensions ||
        plannedChordKind != PlannedChordKind.resolvedRoman ||
        romanNumeral == null) {
      return const [];
    }

    final profileKey = tensionProfileKey(romanNumeral);
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

  static String? tensionProfileKey(String romanNumeral) {
    if (romanNumeral.startsWith('subV7/') || romanNumeral.startsWith('V7/')) {
      return 'V7';
    }
    if (_tensionProfiles.containsKey(romanNumeral)) {
      return romanNumeral;
    }
    return null;
  }

  static bool isDominantQuality(String baseChord) {
    return parseChordSymbol(baseChord).quality == '7';
  }

  static String renderChordSymbol({
    required String baseChord,
    SurfaceVariant? surfaceVariant,
    List<String> tensions = const [],
  }) {
    final parts = parseChordSymbol(baseChord);
    var quality = parts.quality;
    if (surfaceVariant == SurfaceVariant.dominantSus4 && quality == '7') {
      quality = '7sus4';
    }
    final tensionSuffix =
        tensions.isEmpty ? '' : '(${tensions.join(',')})';
    return '${parts.root}$quality$tensionSuffix';
  }

  static bool isRenderedNonDiatonic({
    required PlannedChordKind plannedChordKind,
    required List<String> tensions,
    AppliedType? appliedType,
  }) {
    if (appliedType != null) {
      return true;
    }
    if (plannedChordKind == PlannedChordKind.tonicDominant7) {
      return true;
    }
    return tensions.any(_alteredTensions.contains);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SightChord',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6258)),
        scaffoldBackgroundColor: const Color(0xFFF6F2E8),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SightChord'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _defaultBpm = 60;
  static const int _minBpm = 20;
  static const int _maxBpm = 300;
  static const int _beatsPerBar = 4;
  static const String _tickAsset = 'tick.mp3';

  static const List<String> _keyOptions = [
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

  static const List<String> _allRoots = [
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

  static const List<String> _randomSuffixes = [
    '',
    'm',
    '7',
    'M7',
    'm7',
    'dim',
    'aug',
  ];

  static const List<String> _baseRomanNumerals = [
    'IM7',
    'IIm7',
    'IIIm7',
    'IVM7',
    'V7',
    'VIm7',
    'VIIm7b5',
  ];

  static const List<String> _secondaryDominants = [
    'V7/II',
    'V7/III',
    'V7/IV',
    'V7/V',
    'V7/VI',
  ];

  static const List<String> _substituteDominants = [
    'subV7/II',
    'subV7/III',
    'subV7/IV',
    'subV7/V',
    'subV7/VI',
  ];

  static const Map<String, List<String>> _diatonicChordMap = {
    'C': ['CM7', 'Dm7', 'Em7', 'FM7', 'G7', 'Am7', 'Bm7b5'],
    'C#/Db': ['DbM7', 'Ebm7', 'Fm7', 'GbM7', 'Ab7', 'Bbm7', 'Cm7b5'],
    'D': ['DM7', 'Em7', 'F#m7', 'GM7', 'A7', 'Bm7', 'C#m7b5'],
    'D#/Eb': ['EbM7', 'Fm7', 'Gm7', 'AbM7', 'Bb7', 'Cm7', 'Dm7b5'],
    'E': ['EM7', 'F#m7', 'G#m7', 'AM7', 'B7', 'C#m7', 'D#m7b5'],
    'F': ['FM7', 'Gm7', 'Am7', 'BbM7', 'C7', 'Dm7', 'Em7b5'],
    'F#/Gb': ['GbM7', 'Abm7', 'Bbm7', 'CbM7', 'Db7', 'Ebm7', 'Fm7b5'],
    'G': ['GM7', 'Am7', 'Bm7', 'CM7', 'D7', 'Em7', 'F#m7b5'],
    'G#/Ab': ['AbM7', 'Bbm7', 'Cm7', 'DbM7', 'Eb7', 'Fm7', 'Gm7b5'],
    'A': ['AM7', 'Bm7', 'C#m7', 'DM7', 'E7', 'F#m7', 'G#m7b5'],
    'A#/Bb': ['BbM7', 'Cm7', 'Dm7', 'EbM7', 'F7', 'Gm7', 'Am7b5'],
    'B': ['BM7', 'C#m7', 'D#m7', 'EM7', 'F#7', 'G#m7', 'A#m7b5'],
  };

  static const Map<String, String> _appliedResolutionMap = {
    'V7/II': 'IIm7',
    'V7/III': 'IIIm7',
    'V7/IV': 'IVM7',
    'V7/V': 'V7',
    'V7/VI': 'VIm7',
    'subV7/II': 'IIm7',
    'subV7/III': 'IIIm7',
    'subV7/IV': 'IVM7',
    'subV7/V': 'V7',
    'subV7/VI': 'VIm7',
  };

  static const Map<String, String> _harmonicFunctionMap = {
    'IM7': 'tonic',
    'IIIm7': 'tonic',
    'VIm7': 'tonic',
    'IIm7': 'predominant',
    'IVM7': 'predominant',
    'V7': 'dominant',
    'VIIm7b5': 'dominant',
  };

  static const Map<String, int> _noteToSemitone = {
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

  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _bpmController =
      TextEditingController(text: '$_defaultBpm');

  Timer? _autoTimer;
  Future<void>? _audioInitFuture;
  int? _currentBeat;
  bool _audioReady = false;
  bool _autoRunning = false;
  bool _metronomeEnabled = true;
  double _metronomeVolume = 1.0;
  bool _smartGeneratorMode = false;
  bool _secondaryDominantEnabled = false;
  bool _substituteDominantEnabled = false;
  bool _allowV7sus4 = false;
  bool _allowTensions = false;
  final Set<String> _selectedTensionOptions = {
    ...ChordRenderingHelper.supportedTensionOptions,
  };
  final Set<String> _activeKeys = <String>{};
  List<QueuedSmartChord> _plannedSmartChordQueue = const <QueuedSmartChord>[];

  GeneratedChord? _previousChord;
  GeneratedChord? _currentChord;
  GeneratedChord? _nextChord;

  @override
  void initState() {
    super.initState();
    _audioInitFuture = _initAudio();
    _ensureChordQueueInitialized();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setSource(AssetSource(_tickAsset));
      await _audioPlayer.setVolume(_metronomeVolume);
      _audioReady = true;
    } catch (_) {
      _audioReady = false;
    }
  }

  int _effectiveBpm() {
    final parsed = int.tryParse(_bpmController.text) ?? _defaultBpm;
    return parsed.clamp(_minBpm, _maxBpm);
  }

  bool get _usesKeyMode => _activeKeys.isNotEmpty;

  List<String> get _orderedKeys => [
        for (final key in _keyOptions)
          if (_activeKeys.contains(key)) key,
      ];

  List<String> get _practiceModeTags {
    final tags = <String>[_usesKeyMode ? '????®ÏÄ´Î???È∂?Ö∫??????ÖÎ???È•îÎÇÖ?????????îÎá°??? : '???ÍøîÍ∫Ç???ÂΩ±¬Ä?úÍ≥∏???È•îÎÇÖ?????????îÎá°???];
    if (_usesKeyMode) {
      tags.addAll(_orderedKeys);
      if (_smartGeneratorMode) {
        tags.add('Smart Generator');
      }
      if (_secondaryDominantEnabled) {
        tags.add('Secondary Dominant');
      }
      if (_substituteDominantEnabled) {
        tags.add('Substitute Dominant');
      }
    } else {
      tags.add('All Keys');
    }
    tags.add('${_effectiveBpm()} BPM');
    tags.add(_metronomeEnabled ? 'Metronome On' : 'Metronome Off');
    return tags;
  }

  String get _currentStatusLabel {
    if (_currentChord == null) {
      return '?????Î∞∏Î∏∂?????Â£§Íµø???ìÎÇØ??????¨Í≥£Î´ñÔßù?????????∞ÎÆõ???????;
    }
    final analysisLabel = _currentChord!.analysisLabel;
    return analysisLabel.isEmpty ? '???ÍøîÍ∫Ç???ÂΩ±¬Ä?úÍ≥∏???È•îÎÇÖ?????????îÎá°??? : analysisLabel;
  }

  String get _practiceModeDescription {
    if (!_usesKeyMode) {
      return '12?????????????úÔßü????????Î∞∏Î∏∂?????????éÏ≤é???‰∫?ªãÍº®Áå∑Î≥†ÍΩ¥????????Ô¶´ÎöÆƒ≤????????Ë´õÎ™ÉÎß??Œª????????Î∞∏Î∏∂?????Â£§Íµø???ìÎÇØ??????¨Í≥£Î´ñÔßù?????ÍøîÍ∫Ç??????';
    }
    if (_smartGeneratorMode) {
      return '????ÂΩ±¬Ä??•¬Ä?????? ?È•îÎÇÖ???????????Â´???????????????πÎïüÔßíÎÖπ????????????????????????øÌèé????È•îÎÇÖ??????Ô¶´ÎöÆ?????????????? ????¨Í≥£Î´ñÔßù?????ÍøîÍ∫Ç??????';
    }
    return '????ÂΩ±¬Ä??•¬Ä???????????úÔßü???????•Ïã≤Í∞?Åî??ÅÏòÉÔß?????¨Í≥ª?¢Â§∑?†Îáæ?????????????????Â´?????????¨Í≥£Î´ñÔßù?????ÍøîÍ∫Ç??????';
  }

  void _ensureChordQueueInitialized() {
    _currentChord ??= _generateChord();
    _nextChord ??= _generateChord(
      exclusionContext: _buildExclusionContext(current: _currentChord),
      current: _currentChord,
    );
  }

  void _reseedChordQueue() {
    _previousChord = null;
    _currentChord = null;
    _nextChord = null;
    _plannedSmartChordQueue = const <QueuedSmartChord>[];
    _ensureChordQueueInitialized();
  }

  List<String> _enabledRomanNumerals() {
    final pool = <String>[..._baseRomanNumerals];
    if (_secondaryDominantEnabled) {
      pool.addAll(_secondaryDominants);
    }
    if (_substituteDominantEnabled) {
      pool.addAll(_substituteDominants);
    }
    return pool;
  }

  ChordExclusionContext _buildExclusionContext({
    GeneratedChord? current,
    Set<String> renderedSymbols = const <String>{},
  }) {
    final nextRenderedSymbols = <String>{...renderedSymbols};
    final repeatGuardKeys = <String>{};
    final harmonicComparisonKeys = <String>{};
    if (current != null) {
      nextRenderedSymbols.add(current.chord);
      repeatGuardKeys.add(current.repeatGuardKey);
      harmonicComparisonKeys.add(current.harmonicComparisonKey);
    }
    return ChordExclusionContext(
      renderedSymbols: nextRenderedSymbols,
      repeatGuardKeys: repeatGuardKeys,
      harmonicComparisonKeys: harmonicComparisonKeys,
    );
  }

  bool _isExcludedCandidate(
    GeneratedChord candidate,
    ChordExclusionContext exclusionContext,
  ) {
    return exclusionContext.renderedSymbols.contains(candidate.chord) ||
        exclusionContext.repeatGuardKeys.contains(candidate.repeatGuardKey) ||
        exclusionContext.harmonicComparisonKeys
            .contains(candidate.harmonicComparisonKey);
  }

  GeneratedChord _generateChord({
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? current,
  }) {
    if (!_usesKeyMode) {
      while (true) {
        final root = _allRoots[_random.nextInt(_allRoots.length)];
        final suffix = _randomSuffixes[_random.nextInt(_randomSuffixes.length)];
        final generatedChord = _buildFreeGeneratedChord('$root$suffix');
        if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keys = _orderedKeys;
    final romanNumerals = _enabledRomanNumerals();

    if (_smartGeneratorMode) {
      return _generateSmartChord(
        keys: keys,
        romanNumerals: romanNumerals,
        exclusionContext: exclusionContext,
        current: current,
      );
    }

    return _generateRandomKeyModeChord(
      keys: keys,
      romanNumerals: romanNumerals,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChord _buildFreeGeneratedChord(
    String baseChord, {
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    final surfaceVariant = ChordRenderingHelper.selectSurfaceVariant(
      random: _random,
      allowV7sus4: _allowV7sus4,
      baseChord: baseChord,
      plannedChordKind: PlannedChordKind.resolvedRoman,
    );
    final chord = ChordRenderingHelper.renderChordSymbol(
      baseChord: baseChord,
      surfaceVariant: surfaceVariant,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: null,
      romanNumeral: null,
      harmonicFunction: 'free',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      baseChord: baseChord,
    );
    final harmonicComparisonKey = ChordRenderingHelper.buildHarmonicComparisonKey(
      keyName: null,
      romanNumeral: null,
      harmonicFunction: 'free',
      plannedChordKind: PlannedChordKind.resolvedRoman,
      baseChord: baseChord,
    );
    return GeneratedChord(
      chord: chord,
      baseChord: baseChord,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      smartDebug: smartDebug,
      wasExcludedFallback: wasExcludedFallback,
    );
  }

  ChordRenderingSelection _selectRenderingSelection({
    required String baseChord,
    required String? romanNumeral,
    required PlannedChordKind plannedChordKind,
    required bool suppressTensions,
    AppliedType? appliedType,
  }) {
    final surfaceVariant = ChordRenderingHelper.selectSurfaceVariant(
      random: _random,
      allowV7sus4: _allowV7sus4,
      baseChord: baseChord,
      plannedChordKind: plannedChordKind,
    );
    final tensions = ChordRenderingHelper.selectTensions(
      random: _random,
      romanNumeral: romanNumeral,
      plannedChordKind: plannedChordKind,
      allowTensions: _allowTensions,
      selectedTensionOptions: _selectedTensionOptions,
      suppressTensions: suppressTensions,
    );
    return ChordRenderingSelection(
      chord: ChordRenderingHelper.renderChordSymbol(
        baseChord: baseChord,
        surfaceVariant: surfaceVariant,
        tensions: tensions,
      ),
      surfaceVariant: surfaceVariant,
      tensions: tensions,
      isRenderedNonDiatonic: ChordRenderingHelper.isRenderedNonDiatonic(
        plannedChordKind: plannedChordKind,
        tensions: tensions,
        appliedType: appliedType,
      ),
    );
  }

  GeneratedChord _buildGeneratedChord(
    String key,
    String romanNumeral, {
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    String? patternTag,
    AppliedType? appliedType,
    String? resolutionTargetRoman,
    bool suppressTensions = false,
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    final normalizedAppliedType = appliedType ?? _appliedTypeForRoman(romanNumeral);
    final normalizedResolutionTargetRoman =
        resolutionTargetRoman ?? _appliedResolutionMap[romanNumeral];
    final baseChord = _resolvePlannedBaseChord(
      key,
      romanNumeral,
      plannedChordKind: plannedChordKind,
    );
    final harmonicFunction = _harmonicFunctionForGeneratedChord(
      romanNumeral,
      plannedChordKind: plannedChordKind,
      appliedType: normalizedAppliedType,
    );
    final renderingSelection = _selectRenderingSelection(
      baseChord: baseChord,
      romanNumeral: romanNumeral,
      plannedChordKind: plannedChordKind,
      suppressTensions: suppressTensions,
      appliedType: normalizedAppliedType,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: key,
      romanNumeral: romanNumeral,
      harmonicFunction: harmonicFunction,
      plannedChordKind: plannedChordKind,
      baseChord: baseChord,
      appliedType: normalizedAppliedType,
      resolutionTargetRoman: normalizedResolutionTargetRoman,
      patternTag: patternTag,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
      keyName: key,
      romanNumeral: romanNumeral,
      harmonicFunction: harmonicFunction,
      plannedChordKind: plannedChordKind,
      baseChord: baseChord,
      appliedType: normalizedAppliedType,
      resolutionTargetRoman: normalizedResolutionTargetRoman,
      patternTag: patternTag,
    );
    return GeneratedChord(
      chord: renderingSelection.chord,
      baseChord: baseChord,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      keyName: key,
      romanNumeral: romanNumeral,
      resolutionRomanNumeral: _appliedResolutionMap[romanNumeral],
      harmonicFunction: harmonicFunction,
      surfaceVariant: renderingSelection.surfaceVariant,
      tensions: renderingSelection.tensions,
      patternTag: patternTag,
      plannedChordKind: plannedChordKind,
      appliedType: normalizedAppliedType,
      resolutionTargetRoman: normalizedResolutionTargetRoman,
      wasExcludedFallback: wasExcludedFallback,
      isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
      smartDebug: smartDebug?.withFinalSelection(
        finalKey: key,
        finalRomanNumeral: romanNumeral,
        finalChord: renderingSelection.chord,
        renderedIsNonDiatonic: renderingSelection.isRenderedNonDiatonic,
        wasExcludedFallback: wasExcludedFallback,
      ),
    );
  }

  GeneratedChord _attachSmartDebug(
    GeneratedChord chord,
    SmartGenerationDebug smartDebug, {
    bool wasExcludedFallback = false,
  }) {
    final resolvedDebug = chord.keyName != null && chord.romanNumeral != null
        ? smartDebug.withFinalSelection(
            finalKey: chord.keyName!,
            finalRomanNumeral: chord.romanNumeral!,
            finalChord: chord.chord,
            renderedIsNonDiatonic: chord.isRenderedNonDiatonic,
            wasExcludedFallback: wasExcludedFallback,
          )
        : smartDebug;
    return chord.copyWith(
      wasExcludedFallback: wasExcludedFallback,
      smartDebug: resolvedDebug,
    );
  }

  GeneratedChord _emitSmartDebug(GeneratedChord chord) {
    assert(() {
      final smartDebug = chord.smartDebug;
      if (smartDebug != null) {
        debugPrint(smartDebug.describe());
      }
      return true;
    }());
    return chord;
  }

  List<GeneratedChord> _buildKeyModeCandidates({
    required List<String> keys,
    required List<String> romanNumerals,
    required ChordExclusionContext exclusionContext,
  }) {
    return [
      for (final key in keys)
        for (final romanNumeral in romanNumerals)
          _buildGeneratedChord(key, romanNumeral),
    ].where((candidate) => !_isExcludedCandidate(candidate, exclusionContext)).toList();
  }

  GeneratedChord _pickUniformChord(List<GeneratedChord> candidates) {
    return candidates[_random.nextInt(candidates.length)];
  }

  String _pickFallbackDiatonicRoman(List<String> allowedDiatonicRomans) {
    return allowedDiatonicRomans[_random.nextInt(allowedDiatonicRomans.length)];
  }

  GeneratedChord _generateRandomKeyModeChord({
    required List<String> keys,
    required List<String> romanNumerals,
    required ChordExclusionContext exclusionContext,
  }) {
    final candidates = _buildKeyModeCandidates(
      keys: keys,
      romanNumerals: romanNumerals,
      exclusionContext: exclusionContext,
    );
    if (candidates.isNotEmpty) {
      return _pickUniformChord(candidates);
    }
    return _buildGeneratedChord(keys.first, _baseRomanNumerals.first);
  }

  GeneratedChord _generateRandomDiatonicChord({
    required List<String> keys,
    required ChordExclusionContext exclusionContext,
    String? preferredKey,
  }) {
    final preferredKeys =
        preferredKey != null && keys.contains(preferredKey) ? [preferredKey] : keys;
    final preferredCandidates = _buildKeyModeCandidates(
      keys: preferredKeys,
      romanNumerals: _baseRomanNumerals,
      exclusionContext: exclusionContext,
    );
    if (preferredCandidates.isNotEmpty) {
      return _pickUniformChord(preferredCandidates);
    }

    final fallbackCandidates = _buildKeyModeCandidates(
      keys: keys,
      romanNumerals: _baseRomanNumerals,
      exclusionContext: exclusionContext,
    );
    if (fallbackCandidates.isNotEmpty) {
      return _pickUniformChord(fallbackCandidates);
    }

    return _buildGeneratedChord(keys.first, _baseRomanNumerals.first);
  }

  int? _keyTonicSemitone(String key) {
    return _noteToSemitone[_extractChordRoot(key)];
  }

  List<String> _findCompatibleModulationKeys({
    required List<String> keys,
    required String currentKey,
    required String resolutionRomanNumeral,
  }) {
    final targetChord = _resolveBaseChord(currentKey, resolutionRomanNumeral);
    final targetSemitone = _noteToSemitone[_extractChordRoot(targetChord)];
    if (targetSemitone == null) {
      return const [];
    }

    return SmartGeneratorHelper.findCompatibleModulationKeys(
      activeKeys: keys,
      currentKey: currentKey,
      targetSemitone: targetSemitone,
      keyTonicSemitoneResolver: _keyTonicSemitone,
    );
  }

  GeneratedChord _generateSmartChord({
    required List<String> keys,
    required List<String> romanNumerals,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? current,
  }) {
    if (current?.keyName == null ||
        current?.romanNumeral == null ||
        !keys.contains(current!.keyName)) {
      return _generateRandomKeyModeChord(
        keys: keys,
        romanNumerals: romanNumerals,
        exclusionContext: exclusionContext,
      );
    }

    final currentKey = current.keyName!;
    final currentRomanNumeral = current.romanNumeral!;
    final allowedDiatonicRomans = romanNumerals
        .where((romanNumeral) => _baseRomanNumerals.contains(romanNumeral))
        .toList();

    final currentResolutionRoman =
        current.resolutionTargetRoman ?? current.resolutionRomanNumeral;
    final modulationCandidateKeys = current.isAppliedDominant &&
            currentResolutionRoman != null
        ? _findCompatibleModulationKeys(
            keys: keys,
            currentKey: currentKey,
            resolutionRomanNumeral: currentResolutionRoman,
          )
        : const <String>[];

    final plan = SmartGeneratorHelper.planNextStep(
      random: _random,
      request: SmartStepRequest(
        currentKey: currentKey,
        currentRomanNumeral: currentRomanNumeral,
        currentResolutionRomanNumeral: currentResolutionRoman,
        currentHarmonicFunction: current.harmonicFunction,
        allowedDiatonicRomanNumerals: allowedDiatonicRomans,
        secondaryDominantEnabled: _secondaryDominantEnabled,
        substituteDominantEnabled: _substituteDominantEnabled,
        modulationCandidateKeys: modulationCandidateKeys,
        previousRomanNumeral: _previousChord?.romanNumeral,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
      ),
    );
    _plannedSmartChordQueue = plan.remainingQueuedChords;

    final generatedChord = _buildGeneratedChord(
      plan.finalKey,
      plan.finalRomanNumeral,
      plannedChordKind: plan.plannedChordKind,
      patternTag: plan.patternTag,
      appliedType: plan.appliedType,
      resolutionTargetRoman: plan.resolutionTargetRoman,
      suppressTensions: plan.renderingPlan.suppressTensions,
      smartDebug: plan.debug,
    );
    if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
      return _emitSmartDebug(generatedChord);
    }

    if (plan.patternTag != null) {
      _plannedSmartChordQueue = const <QueuedSmartChord>[];
    }
    final fallbackChord = _generateRandomDiatonicChord(
      keys: keys,
      exclusionContext: exclusionContext,
      preferredKey: keys.contains(plan.finalKey) ? plan.finalKey : currentKey,
    );
    return _emitSmartDebug(
      _attachSmartDebug(
        fallbackChord,
        plan.debug.withDecision('excluded-fallback'),
        wasExcludedFallback: true,
      ),
    );
  }

  String _harmonicFunctionForRoman(String romanNumeral) {
    if (romanNumeral.startsWith('subV7/')) {
      return 'substituteDominant';
    }
    if (romanNumeral.startsWith('V7/')) {
      return 'appliedDominant';
    }
    return _harmonicFunctionMap[romanNumeral] ?? 'free';
  }

  String _harmonicFunctionForGeneratedChord(
    String romanNumeral, {
    required PlannedChordKind plannedChordKind,
    AppliedType? appliedType,
  }) {
    if (appliedType == AppliedType.substitute) {
      return 'substituteDominant';
    }
    if (appliedType == AppliedType.secondary) {
      return 'appliedDominant';
    }
    if (plannedChordKind != PlannedChordKind.resolvedRoman) {
      return 'tonic';
    }
    return _harmonicFunctionForRoman(romanNumeral);
  }

  AppliedType? _appliedTypeForRoman(String romanNumeral) {
    if (romanNumeral.startsWith('subV7/')) {
      return AppliedType.substitute;
    }
    if (romanNumeral.startsWith('V7/')) {
      return AppliedType.secondary;
    }
    return null;
  }

  String _resolveBaseChord(String key, String romanNumeral) {
    final diatonicIndex = _baseRomanNumerals.indexOf(romanNumeral);
    if (diatonicIndex >= 0) {
      return _diatonicChordMap[key]![diatonicIndex];
    }

    final resolutionRomanNumeral = _appliedResolutionMap[romanNumeral];
    if (resolutionRomanNumeral != null) {
      return _resolveAppliedDominantChord(
        key,
        resolutionRomanNumeral,
        isSubstitute: romanNumeral.startsWith('subV7/'),
      );
    }

    return _diatonicChordMap[key]!.first;
  }

  String _resolvePlannedBaseChord(
    String key,
    String romanNumeral, {
    required PlannedChordKind plannedChordKind,
  }) {
    switch (plannedChordKind) {
      case PlannedChordKind.resolvedRoman:
        return _resolveBaseChord(key, romanNumeral);
      case PlannedChordKind.tonicDominant7:
        final tonicRoot = _extractChordRoot(_resolveBaseChord(key, 'IM7'));
        return '${tonicRoot}7';
      case PlannedChordKind.tonicSix:
        final tonicRoot = _extractChordRoot(_resolveBaseChord(key, 'IM7'));
        return '${tonicRoot}6';
    }
  }

  String _resolveAppliedDominantChord(
    String key,
    String resolutionRomanNumeral, {
    required bool isSubstitute,
  }) {
    final targetChord = _resolveBaseChord(key, resolutionRomanNumeral);
    final targetRoot = _extractChordRoot(targetChord);
    final targetSemitone = _noteToSemitone[targetRoot];
    if (targetSemitone == null) {
      return _diatonicChordMap[key]!.first;
    }

    final dominantSemitone = isSubstitute
        ? (targetSemitone + 1) % 12
        : (targetSemitone + 7) % 12;
    final dominantRoot = _spellPitchForKey(dominantSemitone, key);
    return '${dominantRoot}7';
  }

  String _extractChordRoot(String chord) {
    final match = RegExp(r'^[A-G](?:#|b)?').firstMatch(chord);
    return match?.group(0) ?? 'C';
  }

  String _spellPitchForKey(int semitone, String key) {
    final spellings = _flatPreferredKeys.contains(key)
        ? _flatNoteNames
        : _sharpNoteNames;
    return spellings[semitone % 12];
  }
  Future<void> _playMetronomeIfNeeded() async {
    if (!_metronomeEnabled) {
      return;
    }
    await (_audioInitFuture ?? Future<void>.value());
    if (!_audioReady) {
      return;
    }
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(_metronomeVolume);
      await _audioPlayer.resume();
    } catch (_) {}
  }

  void _advanceChordUnawaited() {
    unawaited(_advanceChord());
  }

  void _handleAutoTickUnawaited() {
    unawaited(_handleAutoTick());
  }

  Future<void> _advanceChord() async {
    setState(() {
      _previousChord = _currentChord;
      _currentChord = _nextChord ?? _generateChord(current: _currentChord);
      _nextChord = _generateChord(
        exclusionContext: _buildExclusionContext(current: _currentChord),
        current: _currentChord,
      );
      _currentBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
    });
    await _playMetronomeIfNeeded();
  }

  Future<void> _handleAutoTick() async {
    var shouldAdvanceChord = false;
    setState(() {
      final nextBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
      _currentBeat = nextBeat;
      shouldAdvanceChord = nextBeat == 0;
    });

    await _playMetronomeIfNeeded();

    if (!shouldAdvanceChord) {
      return;
    }

    setState(() {
      _previousChord = _currentChord;
      _currentChord = _nextChord ?? _generateChord(current: _currentChord);
      _nextChord = _generateChord(
        exclusionContext: _buildExclusionContext(current: _currentChord),
        current: _currentChord,
      );
    });
  }

  void _scheduleAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(
      Duration(milliseconds: (60000 / _effectiveBpm()).round()),
      (_) => _handleAutoTickUnawaited(),
    );
  }

  void _stopAutoPlay({bool resetBeat = true}) {
    _autoTimer?.cancel();
    setState(() {
      _autoRunning = false;
      if (resetBeat) {
        _currentBeat = null;
      }
    });
  }

  void _startAutoPlay() {
    setState(() {
      _autoRunning = true;
      _currentBeat = null;
    });
    _handleAutoTickUnawaited();
    _scheduleAutoTimer();
  }

  void _rescheduleAutoTimer() {
    if (!_autoRunning) {
      return;
    }
    _scheduleAutoTimer();
  }

  void _toggleAutoPlay() {
    if (_autoRunning) {
      _stopAutoPlay();
      return;
    }

    _startAutoPlay();
  }

  void _adjustBpm(int delta) {
    final next = (_effectiveBpm() + delta).clamp(_minBpm, _maxBpm);
    _bpmController.text = '$next';
    _rescheduleAutoTimer();
    setState(() {});
  }

  void _handleBpmChanged(String value) {
    if (_autoRunning && int.tryParse(value) != null) {
      _rescheduleAutoTimer();
    }
    setState(() {});
  }

  void _normalizeBpm() {
    _bpmController.text = '${_effectiveBpm()}';
    _rescheduleAutoTimer();
    setState(() {});
  }

  Widget _buildBeatCircle(int index) {
    final isActive = _currentBeat == index;
    return AnimatedContainer(
      key: ValueKey("beat-circle-$index-${isActive ? 'active' : 'inactive'}"),
      duration: const Duration(milliseconds: 180),
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildSummaryCard() {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _usesKeyMode ? '????®ÏÄ´Î???È∂?Ö∫??????ÖÎ?????????Ô¶??â¬Ä?????????' : '???ÍøîÍ∫Ç???ÂΩ±¬Ä?úÍ≥∏???È•îÎÇÖ?????????îÎá°???,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _practiceModeDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _practiceModeTags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              'Space: ????•Ïã≤Í∞?Åî????????Î∞∏Î∏∂???? ?? Enter: ??????È•îÎÇÖ??????Ô¶´ÎöÆ???????ÍøîÍ∫Ç???ÂΩ±¬Ä??∞ƒ??????Íæ®„Åç???¨Í≥•Î£??  ?? Up/Down: BPM ????®ÏÄ´Î?????,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsDrawer() {
    final theme = Theme.of(context);

    return SizedBox(
      width: min(MediaQuery.of(context).size.width * 0.9, 420),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '????•Ïã≤Í∞?Åî???,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                      tooltip: '???????,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('?È•îÎÇÖ??????????∑ÏÇ∞????ÍøîÍ∫Ç?????),
                        subtitle: Text(_metronomeEnabled ? '???Ë¢Å‚ë∏Ï¶¥Á≠å??Î∏êÎàñ?? : '?????????´ÏµÇ??),
                        value: _metronomeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _metronomeEnabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '????•Ïã≤Í∞?Åî???? ?È•îÎÇÖ???ÂΩ±¬Ä?Í≥óÎ™°Ô¶´ÎöÆ??ÍªÜÎπä???????πÎïüÔßíÎÖπ??????ÍøîÍ∫Ç??????',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('?È•îÎÇÖ??????????∑ÏÇ∞????ÍøîÍ∫Ç??????????∞ÎÆõ????, style: theme.textTheme.titleMedium),
                      Slider(
                        value: _metronomeVolume,
                        onChanged: _metronomeEnabled
                            ? (value) {
                                setState(() {
                                  _metronomeVolume = value;
                                });
                              }
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${(_metronomeVolume * 100).round()}%'),
                      ),
                      const SizedBox(height: 20),
                      Text('??????ÂΩ±¬Ä??•¬Ä??, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _activeKeys.isEmpty
                            ? '????ÂΩ±¬Ä??•¬Ä???? ???????±Ï∂ÆÔ¶ÑÍ≥å???øÎÄ????ÍøîÍ∫Ç???ÂΩ±¬Ä?úÍ≥∏???È•îÎÇÖ?????????îÎá°??????????ÊøöÎ∞∏√û??ßÎåÜ???ÍøîÍ∫Ç??????'
                            : '????ÂΩ±¬Ä??•¬Ä???????????úÔßü????????Î∞∏Î∏∂?????Â£§Íµø???ìÎÇØ??????¨Í≥£Î´ñÔßù?????ÍøîÍ∫Ç??????',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _keyOptions.map((key) {
                          return FilterChip(
                            label: Text(key),
                            selected: _activeKeys.contains(key),
                            showCheckmark: false,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _activeKeys.add(key);
                                } else {
                                  _activeKeys.remove(key);
                                }
                                _reseedChordQueue();
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Smart Generator Mode'),
                        subtitle: const Text('?È•îÎÇÖ???????????Â´????????????•¬Ä?£Îü∫ ?????πÎïü??Ë≤´Ê≤Ö??????????πÎïüÔßíÎÖπ??????????????????????????È•îÎÇÖ???????????????ÅÏ°Ñ.'),
                        value: _smartGeneratorMode,
                        onChanged: _usesKeyMode
                            ? (value) {
                                setState(() {
                                  _smartGeneratorMode = value;
                                  _reseedChordQueue();
                                });
                              }
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text('Non-Diatonic', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Secondary Dominant'),
                            selected: _secondaryDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    setState(() {
                                      _secondaryDominantEnabled = selected;
                                      _reseedChordQueue();
                                    });
                                  }
                                : null,
                          ),
                          FilterChip(
                            label: const Text('Substitute Dominant'),
                            selected: _substituteDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    setState(() {
                                      _substituteDominantEnabled = selected;
                                      _reseedChordQueue();
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Rendering', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            key: const ValueKey('allow-v7sus4-chip'),
                            label: const Text('Allow V7sus4'),
                            selected: _allowV7sus4,
                            showCheckmark: false,
                            onSelected: (selected) {
                              setState(() {
                                _allowV7sus4 = selected;
                                _reseedChordQueue();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        key: const ValueKey('allow-tensions-toggle'),
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Allow Tensions'),
                        subtitle: const Text('Roman numeral profile and selected chips only'),
                        value: _allowTensions,
                        onChanged: (value) {
                          setState(() {
                            _allowTensions = value;
                            _reseedChordQueue();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ChordRenderingHelper.supportedTensionOptions
                            .map((tension) {
                          return FilterChip(
                            key: ValueKey('tension-chip-$tension'),
                            label: Text(tension),
                            selected: _selectedTensionOptions.contains(tension),
                            showCheckmark: false,
                            onSelected: _allowTensions
                                ? (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedTensionOptions.add(tension);
                                      } else {
                                        _selectedTensionOptions.remove(tension);
                                      }
                                      _reseedChordQueue();
                                    });
                                  }
                                : null,
                          );
                        }).toList(),
                      ),                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _bpmController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previousDisplay = _previousChord?.chord ?? '';
    final currentDisplay = _currentChord?.chord ?? '';
    final nextDisplay = _nextChord?.chord ?? '';

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): _advanceChordUnawaited,
        const SingleActivator(LogicalKeyboardKey.enter): _toggleAutoPlay,
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _adjustBpm(5),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _adjustBpm(-5),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          endDrawer: _buildSettingsDrawer(),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: const Icon(Icons.settings),
                tooltip: '????•Ïã≤Í∞?Åî???,
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 760,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _beatsPerBar,
                                    _buildBeatCircle,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 170,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  previousDisplay,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: theme
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    key: const ValueKey('current-chord-text'),
                                                    currentDisplay,
                                                    style: theme
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  nextDisplay,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: theme
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 22,
                                        child: Center(
                                          child: Text(
                                            _currentStatusLabel,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              color: theme.colorScheme
                                                  .onSurfaceVariant,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildSummaryCard(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _advanceChordUnawaited,
                                    child: const Text('????•Ïã≤Í∞?Åî????????Î∞∏Î∏∂????),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _toggleAutoPlay,
                                    child: Text(
                                      _autoRunning
                                          ? '??????È•îÎÇÖ??????Ô¶´ÎöÆ?????????Íæ®„Åç???¨Í≥•Î£??'
                                          : '??????È•îÎÇÖ??????Ô¶´ÎöÆ???????ÍøîÍ∫Ç???ÂΩ±¬Ä??∞ƒ?,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton.outlined(
                                      onPressed: () => _adjustBpm(-5),
                                      icon: const Icon(Icons.remove),
                                      tooltip: 'BPM ???????,
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 96,
                                      child: TextField(
                                        key: const ValueKey('bpm-input'),
                                        controller: _bpmController,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                          signed: false,
                                          decimal: false,
                                        ),
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.center,
                                        onChanged: _handleBpmChanged,
                                        onSubmitted: (_) => _normalizeBpm(),
                                        onTapOutside: (_) => _normalizeBpm(),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton.outlined(
                                      onPressed: () => _adjustBpm(5),
                                      icon: const Icon(Icons.add),
                                      tooltip: 'BPM ?????∫Î∏ç???Î™Ñƒ?????´‚ÄòÔß£??,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'BPM',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '???????ºÍµ£Â°???????? $_minBpm-$_maxBpm',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}










