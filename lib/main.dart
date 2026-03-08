import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'smart_generator.dart';

class GeneratedChord {
  const GeneratedChord({
    required this.chord,
    this.keyName,
    this.romanNumeral,
    this.resolutionRomanNumeral,
    this.harmonicFunction = 'free',
    this.smartDebug,
  });

  final String chord;
  final String? keyName;
  final String? romanNumeral;
  final String? resolutionRomanNumeral;
  final String harmonicFunction;
  final SmartGenerationDebug? smartDebug;

  bool get isAppliedDominant =>
      romanNumeral?.startsWith('V7/') == true ||
      romanNumeral?.startsWith('subV7/') == true;

  String get analysisLabel {
    if (keyName == null || romanNumeral == null) {
      return '';
    }
    return '$keyName: $romanNumeral';
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
  final Set<String> _activeKeys = <String>{};

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
    final tags = <String>[_usesKeyMode ? '???怨쀫뮡??鶯ㅺ동????딅뭽??饔낅떽????ш낄?뉔뇡??? : '???꿔꺂???影瑜곸떻??饔낅떽????ш낄?뉔뇡???];
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
      return '?????밸븶?????壤굿?쒓낯?????熬곣뫖利????????쇰뮛???????;
    }
    final analysisLabel = _currentChord!.analysisLabel;
    return analysisLabel.isEmpty ? '???꿔꺂???影瑜곸떻??饔낅떽????ш낄?뉔뇡??? : analysisLabel;
  }

  String get _practiceModeDescription {
    if (!_usesKeyMode) {
      return '12????????????關履????????밸븶??????關?쒎첎???亦껋꼨猷볠꽴????????嶺뚮Ĳ????????諛몃마??λ????????밸븶?????壤굿?쒓낯?????熬곣뫖利?????꿔꺂??????';
    }
    if (_smartGeneratorMode) {
      return '????影?력?????? ?饔낅떽??????????嫄??????????????썹땟戮녹???????????????????????ㅿ폎????饔낅떽?????嶺뚮ㅎ????????????? ???熬곣뫖利?????꿔꺂??????';
    }
    return '????影?력??????????關履??????嚥싲갭큔?댁옃紐????熬곻퐢夷①뇾?????????????????嫄????????熬곣뫖利?????꿔꺂??????';
  }

  void _ensureChordQueueInitialized() {
    _currentChord ??= _generateChord();
    _nextChord ??= _generateChord(
      excluding: {_currentChord!.chord},
      current: _currentChord,
    );
  }

  void _reseedChordQueue() {
    _previousChord = null;
    _currentChord = null;
    _nextChord = null;
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

  GeneratedChord _generateChord({
    Set<String> excluding = const {},
    GeneratedChord? current,
  }) {
    if (!_usesKeyMode) {
      while (true) {
        final root = _allRoots[_random.nextInt(_allRoots.length)];
        final suffix = _randomSuffixes[_random.nextInt(_randomSuffixes.length)];
        final chord = '$root$suffix';
        if (!excluding.contains(chord)) {
          return GeneratedChord(chord: chord);
        }
      }
    }

    final keys = _orderedKeys;
    final romanNumerals = _enabledRomanNumerals();

    if (_smartGeneratorMode) {
      return _generateSmartChord(
        keys: keys,
        romanNumerals: romanNumerals,
        excluding: excluding,
        current: current,
      );
    }

    return _generateRandomKeyModeChord(
      keys: keys,
      romanNumerals: romanNumerals,
      excluding: excluding,
    );
  }

  GeneratedChord _buildGeneratedChord(
    String key,
    String romanNumeral, {
    SmartGenerationDebug? smartDebug,
  }) {
    final chord = _resolveChord(key, romanNumeral);
    return GeneratedChord(
      chord: chord,
      keyName: key,
      romanNumeral: romanNumeral,
      resolutionRomanNumeral: _appliedResolutionMap[romanNumeral],
      harmonicFunction: _harmonicFunctionForRoman(romanNumeral),
      smartDebug: smartDebug?.withFinalSelection(
        finalKey: key,
        finalRomanNumeral: romanNumeral,
        finalChord: chord,
      ),
    );
  }

  GeneratedChord _attachSmartDebug(
    GeneratedChord chord,
    SmartGenerationDebug smartDebug,
  ) {
    return GeneratedChord(
      chord: chord.chord,
      keyName: chord.keyName,
      romanNumeral: chord.romanNumeral,
      resolutionRomanNumeral: chord.resolutionRomanNumeral,
      harmonicFunction: chord.harmonicFunction,
      smartDebug: chord.keyName != null && chord.romanNumeral != null
          ? smartDebug.withFinalSelection(
              finalKey: chord.keyName!,
              finalRomanNumeral: chord.romanNumeral!,
              finalChord: chord.chord,
            )
          : smartDebug,
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
    required Set<String> excluding,
  }) {
    return [
      for (final key in keys)
        for (final romanNumeral in romanNumerals)
          _buildGeneratedChord(key, romanNumeral),
    ].where((candidate) => !excluding.contains(candidate.chord)).toList();
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
    required Set<String> excluding,
  }) {
    final candidates = _buildKeyModeCandidates(
      keys: keys,
      romanNumerals: romanNumerals,
      excluding: excluding,
    );
    if (candidates.isNotEmpty) {
      return _pickUniformChord(candidates);
    }
    return _buildGeneratedChord(keys.first, _baseRomanNumerals.first);
  }

  GeneratedChord _generateRandomDiatonicChord({
    required List<String> keys,
    required Set<String> excluding,
    String? preferredKey,
  }) {
    final preferredKeys =
        preferredKey != null && keys.contains(preferredKey) ? [preferredKey] : keys;
    final preferredCandidates = _buildKeyModeCandidates(
      keys: preferredKeys,
      romanNumerals: _baseRomanNumerals,
      excluding: excluding,
    );
    if (preferredCandidates.isNotEmpty) {
      return _pickUniformChord(preferredCandidates);
    }

    final fallbackCandidates = _buildKeyModeCandidates(
      keys: keys,
      romanNumerals: _baseRomanNumerals,
      excluding: excluding,
    );
    if (fallbackCandidates.isNotEmpty) {
      return _pickUniformChord(fallbackCandidates);
    }

    return _buildGeneratedChord(keys.first, _baseRomanNumerals.first);
  }

  SmartTransitionSelection _selectNextDiatonicDestination({
    required String currentRomanNumeral,
    required List<String> allowedDiatonicRomans,
  }) {
    return SmartGeneratorHelper.selectNextRoman(
      random: _random,
      currentRomanNumeral: currentRomanNumeral,
      allowedRomanNumerals: allowedDiatonicRomans,
    );
  }

  SmartApproachDecision _maybeInsertAppliedApproach({
    required String destinationRomanNumeral,
  }) {
    return SmartGeneratorHelper.maybeInsertAppliedApproach(
      random: _random,
      destinationRomanNumeral: destinationRomanNumeral,
      secondaryDominantEnabled: _secondaryDominantEnabled,
      substituteDominantEnabled: _substituteDominantEnabled,
    );
  }

  AppliedResolutionDecision _resolveAppliedOrModulate({
    required String currentKey,
    required String appliedTargetRomanNumeral,
    required List<String> allowedDiatonicRomans,
    required List<String> modulationCandidateKeys,
  }) {
    return SmartGeneratorHelper.resolveAppliedOrModulate(
      random: _random,
      currentKey: currentKey,
      appliedTargetRomanNumeral: appliedTargetRomanNumeral,
      allowedDiatonicRomanNumerals: allowedDiatonicRomans,
      modulationCandidateKeys: modulationCandidateKeys,
    );
  }

  int? _keyTonicSemitone(String key) {
    return _noteToSemitone[_extractChordRoot(key)];
  }

  List<String> _findCompatibleModulationKeys({
    required List<String> keys,
    required String currentKey,
    required String resolutionRomanNumeral,
  }) {
    final targetChord = _resolveChord(currentKey, resolutionRomanNumeral);
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
    required Set<String> excluding,
    GeneratedChord? current,
  }) {
    if (current?.keyName == null ||
        current?.romanNumeral == null ||
        !keys.contains(current!.keyName)) {
      return _generateRandomKeyModeChord(
        keys: keys,
        romanNumerals: romanNumerals,
        excluding: excluding,
      );
    }

    final currentKey = current.keyName!;
    final currentRomanNumeral = current.romanNumeral!;
    final allowedDiatonicRomans = romanNumerals
        .where((romanNumeral) => _baseRomanNumerals.contains(romanNumeral))
        .toList();

    if (current.isAppliedDominant) {
      final appliedTargetRomanNumeral = current.resolutionRomanNumeral ??
          _pickFallbackDiatonicRoman(allowedDiatonicRomans);
      final modulationCandidateKeys = _findCompatibleModulationKeys(
        keys: keys,
        currentKey: currentKey,
        resolutionRomanNumeral: appliedTargetRomanNumeral,
      );
      final resolutionDecision = _resolveAppliedOrModulate(
        currentKey: currentKey,
        appliedTargetRomanNumeral: appliedTargetRomanNumeral,
        allowedDiatonicRomans: allowedDiatonicRomans,
        modulationCandidateKeys: modulationCandidateKeys,
      );
      final smartDebug = SmartGenerationDebug(
        currentKey: currentKey,
        currentRomanNumeral: currentRomanNumeral,
        selectedDiatonicDestination: appliedTargetRomanNumeral,
        insertedAppliedApproach: currentRomanNumeral,
        appliedTargetRomanNumeral: appliedTargetRomanNumeral,
        modulationCandidateKeys: modulationCandidateKeys,
        finalKey: resolutionDecision.finalKey,
        finalRomanNumeral: resolutionDecision.finalRomanNumeral,
        decision: resolutionDecision.didModulate
            ? 'modulated-via-applied-resolution'
            : resolutionDecision.resolvedToTarget
                ? 'resolved-applied-target'
                : 'continued-after-applied',
      );
      final generatedChord = _buildGeneratedChord(
        resolutionDecision.finalKey,
        resolutionDecision.finalRomanNumeral,
        smartDebug: smartDebug,
      );
      if (!excluding.contains(generatedChord.chord)) {
        return _emitSmartDebug(generatedChord);
      }

      final fallbackChord = _generateRandomDiatonicChord(
        keys: keys,
        excluding: excluding,
        preferredKey: keys.contains(resolutionDecision.finalKey)
            ? resolutionDecision.finalKey
            : currentKey,
      );
      return _emitSmartDebug(
        _attachSmartDebug(
          fallbackChord,
          smartDebug.withDecision('excluded-fallback'),
        ),
      );
    }

    final destinationSelection = _selectNextDiatonicDestination(
      currentRomanNumeral: currentRomanNumeral,
      allowedDiatonicRomans: allowedDiatonicRomans,
    );
    final selectedDiatonicDestination =
        destinationSelection.selectedRomanNumeral ??
            _pickFallbackDiatonicRoman(allowedDiatonicRomans);
    final approachDecision = _maybeInsertAppliedApproach(
      destinationRomanNumeral: selectedDiatonicDestination,
    );
    final smartDebug = SmartGenerationDebug(
      currentKey: currentKey,
      currentRomanNumeral: currentRomanNumeral,
      selectedDiatonicDestination: selectedDiatonicDestination,
      insertedAppliedApproach: approachDecision.insertedAppliedApproach,
      appliedTargetRomanNumeral: approachDecision.appliedTargetRomanNumeral,
      modulationCandidateKeys: const [],
      finalKey: currentKey,
      finalRomanNumeral: approachDecision.selectedRomanNumeral,
      decision: approachDecision.insertedApproach
          ? 'inserted-applied-approach'
          : 'selected-diatonic-destination',
      transitionDebugSummary: destinationSelection.debug.describe(),
    );
    final generatedChord = _buildGeneratedChord(
      currentKey,
      approachDecision.selectedRomanNumeral,
      smartDebug: smartDebug,
    );
    if (!excluding.contains(generatedChord.chord)) {
      return _emitSmartDebug(generatedChord);
    }

    final fallbackChord = _generateRandomDiatonicChord(
      keys: keys,
      excluding: excluding,
      preferredKey: currentKey,
    );
    return _emitSmartDebug(
      _attachSmartDebug(
        fallbackChord,
        smartDebug.withDecision('excluded-fallback'),
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

  String _resolveChord(String key, String romanNumeral) {
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

  String _resolveAppliedDominantChord(
    String key,
    String resolutionRomanNumeral, {
    required bool isSubstitute,
  }) {
    final targetChord = _resolveChord(key, resolutionRomanNumeral);
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
        excluding: {
          if (_currentChord != null) _currentChord!.chord,
        },
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
        excluding: {
          if (_currentChord != null) _currentChord!.chord,
        },
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
              _usesKeyMode ? '???怨쀫뮡??鶯ㅺ동????딅뭽????????力?肉?????????' : '???꿔꺂???影瑜곸떻??饔낅떽????ш낄?뉔뇡???,
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
              'Space: ???嚥싲갭큔????????밸븶???? ?? Enter: ??????饔낅떽?????嶺뚮ㅎ??????꿔꺂???影?우Ŀ??關???꾨き??熬곥룊??  ?? Up/Down: BPM ???怨쀫뮡????,
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
                        '???嚥싲갭큔???,
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
                        title: const Text('?饔낅떽????????猷산샵???꿔꺂?????),
                        subtitle: Text(_metronomeEnabled ? '???袁⑸즴筌??븐눖釉? : '????????ル쵂??),
                        value: _metronomeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _metronomeEnabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '???嚥싲갭큔???? ?饔낅떽??影?곗몡嶺뚮??껆빊??????썹땟戮녹??????꿔꺂??????',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('?饔낅떽????????猷산샵???꿔꺂?????????쇰뮛????, style: theme.textTheme.titleMedium),
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
                      Text('??????影?력??, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        _activeKeys.isEmpty
                            ? '????影?력???? ??????쇱춮濾곌풁?녿뀋????꿔꺂???影瑜곸떻??饔낅떽????ш낄?뉔뇡??????????濚밸Þ?쀧댆???꿔꺂??????'
                            : '????影?력??????????關履????????밸븶?????壤굿?쒓낯?????熬곣뫖利?????꿔꺂??????',
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
                        subtitle: const Text('?饔낅떽??????????嫄???????????⑥ャ럺 ????썹땟??貫沅?????????썹땟戮녹??????????????????????????饔낅떽?????????????놁졄.'),
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
                    ],
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
                tooltip: '???嚥싲갭큔???,
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
                                    child: const Text('???嚥싲갭큔????????밸븶????),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _toggleAutoPlay,
                                    child: Text(
                                      _autoRunning
                                          ? '??????饔낅떽?????嶺뚮ㅎ????關???꾨き??熬곥룊??'
                                          : '??????饔낅떽?????嶺뚮ㅎ??????꿔꺂???影?우Ŀ?,
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
                                      tooltip: 'BPM ????遺븍き??몄Ŀ????ル‘泥??,
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
                                  '??????ㅼ굣塋??癲????? $_minBpm-$_maxBpm',
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
