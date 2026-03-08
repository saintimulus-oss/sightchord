import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _GeneratedChord {
  const _GeneratedChord({
    required this.chord,
    this.keyName,
    this.romanNumeral,
  });

  final String chord;
  final String? keyName;
  final String? romanNumeral;

  String get analysisLabel {
    if (keyName == null || romanNumeral == null) return '';
    return '$keyName: $romanNumeral';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _seedColor = Color(0xFF1E6258);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SightChord',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
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
  static const bool _defaultMetronomeEnabled = true;
  static const double _defaultMetronomeVolume = 1.0;

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

  static const List<String> _baseRomanNumeralPool = [
    'IM7',
    'IIm7',
    'IIIm7',
    'IVM7',
    'V7',
    'VIm7',
    'VIIm7b5',
  ];

  static const List<String> _secondaryDominantRomanNumeralPool = [
    'V7/II',
    'V7/III',
    'V7/IV',
    'V7/V',
    'V7/VI',
  ];

  static const List<String> _substituteDominantRomanNumeralPool = [
    'subV7/I',
    'subV7/II',
    'subV7/III',
    'subV7/IV',
    'subV7/V',
    'subV7/VI',
  ];

  static const List<List<String>> _randomRootSpellings = [
    ['C'],
    ['C?', 'D??],
    ['D'],
    ['D?', 'E??],
    ['E'],
    ['F'],
    ['F?', 'G??],
    ['G'],
    ['G?', 'A??],
    ['A'],
    ['A?', 'B??],
    ['B'],
  ];

  static const List<String> _randomChordSuffixes = [
    '',
    'm',
    'aug',
    'dim',
    'M7',
    'm7',
    '7',
    'm7??',
    'aug7',
    'augM7',
    'dim7',
  ];

  static const Map<String, int> _diatonicRomanNumeralIndexMap = {
    'IM7': 0,
    'IIm7': 1,
    'IIIm7': 2,
    'IVM7': 3,
    'V7': 4,
    'VIm7': 5,
    'VIIm7b5': 6,
  };

  static const Map<String, int> _scaleDegreeIndexMap = {
    'I': 0,
    'II': 1,
    'III': 2,
    'IV': 3,
    'V': 4,
    'VI': 5,
    'VII': 6,
  };

  static const Map<String, List<String>> _diatonicChordMap = {
    'C': ['CM7', 'Dm7', 'Em7', 'FM7', 'G7', 'Am7', 'Bm7??'],
    'C#/Db': ['D?癲?', 'E???', 'Fm7', 'G?癲?', 'A??', 'B???', 'Cm7??'],
    'D': ['DM7', 'Em7', 'F?m7', 'GM7', 'A7', 'Bm7', 'C?m7??'],
    'D#/Eb': ['E?癲?', 'Fm7', 'Gm7', 'A?癲?', 'B??', 'Cm7', 'Dm7??'],
    'E': ['EM7', 'F?m7', 'G?m7', 'AM7', 'B7', 'C?m7', 'D?m7??'],
    'F': ['FM7', 'Gm7', 'Am7', 'B?癲?', 'C7', 'Dm7', 'Em7??'],
    'F#/Gb': ['G?癲?', 'A???', 'B???', 'C?癲?', 'D??', 'E???', 'Fm7??'],
    'G': ['GM7', 'Am7', 'Bm7', 'CM7', 'D7', 'Em7', 'F?m7??'],
    'G#/Ab': ['A?癲?', 'B???', 'Cm7', 'D?癲?', 'E??', 'Fm7', 'Gm7??'],
    'A': ['AM7', 'Bm7', 'C?m7', 'DM7', 'E7', 'F?m7', 'G?m7??'],
    'A#/Bb': ['B?癲?', 'Cm7', 'Dm7', 'E?癲?', 'F7', 'Gm7', 'Am7??'],
    'B': ['BM7', 'C?m7', 'D?m7', 'EM7', 'F?7', 'G?m7', 'A?m7??'],
  };

  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _bpmController =
      TextEditingController(text: '$_defaultBpm');

  late final Future<void> _audioInitFuture;

  Timer? _autoTimer;
  DateTime? _nextBeatAt;

  bool _isAutoRunning = false;
  bool _isStartingAuto = false;
  bool _isUpdatingBpmText = false;
  bool _audioReady = false;
  bool _audioUnlocked = false;
  bool _audioInitialized = false;

  bool _savedMetronomeEnabled = _defaultMetronomeEnabled;
  double _savedMetronomeVolume = _defaultMetronomeVolume;
  Set<String> _savedActiveKeys = <String>{};
  bool _savedSmartGeneratorMode = false;
  bool _savedSecondaryDominantEnabled = false;
  bool _savedSubstituteDominantEnabled = false;

  bool _draftMetronomeEnabled = _defaultMetronomeEnabled;
  double _draftMetronomeVolume = _defaultMetronomeVolume;
  Set<String> _draftActiveKeys = <String>{};
  bool _draftSmartGeneratorMode = false;
  bool _draftSecondaryDominantEnabled = false;
  bool _draftSubstituteDominantEnabled = false;

  int _lastValidBpm = _defaultBpm;
  int? _currentBeat;
  _GeneratedChord? _previousChord;
  _GeneratedChord? _currentChord;
  _GeneratedChord? _nextChord;

  double get _effectiveMetronomeVolume =>
      _savedMetronomeEnabled
          ? _savedMetronomeVolume.clamp(0.0, 1.0).toDouble()
          : 0.0;

  bool get _usesKeyMode => _savedActiveKeys.isNotEmpty;

  String get _currentStatusLabel {
    final currentAnalysis = _currentChord?.analysisLabel ?? '';
    if (currentAnalysis.isNotEmpty) return currentAnalysis;
    return _usesKeyMode ? '?????뚯???維◈??꿔꺂??袁ㅻ븶??? : '??嶺뚮㉡?ｏ쭗??꿔꺂??袁ㅻ븶???;
  }

  String get _practiceModeTitle => _usesKeyMode ? '?????뚯???維◈??꿔꺂??袁ㅻ븶??? : '??嶺뚮㉡?ｏ쭗??꿔꺂??袁ㅻ븶???;

  String get _practiceModeDescription {
    if (_usesKeyMode) {
      return '????ｋ?????????⑥쥓援??Roman numeral ???뚯???????Β????ш끽維????節륁춻????꾩룆????嶺뚮ㅎ????';
    }
    return '?熬곣뫖利?????12????????뚯???????Β????猷매?댚??? ??ш끽維?????????⑤０?????類ㅺ퉻?????됰슦???????嶺뚮ㅎ????';
  }

  List<String> get _practiceModeTags {
    final tags = <String>[];

    if (_usesKeyMode) {
      tags.addAll(_orderedKeys(_savedActiveKeys));
      if (_savedSmartGeneratorMode) {
        tags.add('Smart Generator');
      }
      if (_savedSecondaryDominantEnabled) {
        tags.add('Secondary Dominant');
      }
      if (_savedSubstituteDominantEnabled) {
        tags.add('Substitute Dominant');
      }
    } else {
      tags.add('All Keys');
    }

    tags.add('${_getEffectiveBpm()} BPM');
    tags.add(_savedMetronomeEnabled ? '?꿔꺂??????⑷턂??嶺뚮㉡???On' : '?꿔꺂??????⑷턂??嶺뚮㉡???Off');
    return tags;
  }

  bool get _showAudioWarning => _audioInitialized && !_audioReady;

  @override
  void initState() {
    super.initState();
    _restoreDraftSettings();
    _ensureChordQueueInitialized();
    _audioInitFuture = _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setSource(AssetSource(_tickAsset));
      await _audioPlayer.setVolume(_effectiveMetronomeVolume);
      _audioReady = true;
    } catch (e) {
      _audioReady = false;
      debugPrint('?????⑦떍???潁??용끏????????곌숯: $e');
    } finally {
      _audioInitialized = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _ensureAudioReady() async {
    await _audioInitFuture;
  }

  Future<void> _syncMetronomeVolume() async {
    await _ensureAudioReady();
    if (!_audioReady) return;

    try {
      await _audioPlayer.setVolume(_effectiveMetronomeVolume);
    } catch (e) {
      debugPrint('?꿔꺂??????⑷턂??嶺뚮㉡?????⑤슢????????쇨덫???????곌숯: $e');
    }
  }

  Future<void> _unlockAudioIfNeeded() async {
    if (_audioUnlocked) return;

    await _ensureAudioReady();
    if (!_audioReady) return;

    try {
      await _audioPlayer.setVolume(0);
      await _audioPlayer.resume();
      await _audioPlayer.stop();
      await _audioPlayer.seek(Duration.zero);
      _audioUnlocked = true;
    } catch (e) {
      debugPrint('?????⑦떍??unlock ?????곌숯: $e');
    } finally {
      try {
        await _audioPlayer.setVolume(_effectiveMetronomeVolume);
      } catch (_) {}
    }
  }

  void _restoreDraftSettings() {
    _draftMetronomeEnabled = _savedMetronomeEnabled;
    _draftMetronomeVolume = _savedMetronomeVolume;
    _draftActiveKeys = Set<String>.from(_savedActiveKeys);
    _draftSmartGeneratorMode = _savedSmartGeneratorMode;
    _draftSecondaryDominantEnabled = _savedSecondaryDominantEnabled;
    _draftSubstituteDominantEnabled = _savedSubstituteDominantEnabled;
  }

  List<String> _orderedKeys(Set<String> keys) {
    return [
      for (final key in _keyOptions)
        if (keys.contains(key)) key,
    ];
  }

  bool _sameStringSet(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  int _coerceBpm(int bpm) {
    if (bpm < _minBpm) return _minBpm;
    if (bpm > _maxBpm) return _maxBpm;
    return bpm;
  }

  void _openSettings() {
    FocusScope.of(context).unfocus();
    setState(_restoreDraftSettings);
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _applySettings() async {
    final keySettingsChanged = !_sameStringSet(
      _savedActiveKeys,
      _draftActiveKeys,
    );

    final nonDiatonicSettingsChanged =
        _savedSecondaryDominantEnabled != _draftSecondaryDominantEnabled ||
        _savedSubstituteDominantEnabled != _draftSubstituteDominantEnabled;

    final smartGeneratorModeChanged =
        _savedSmartGeneratorMode != _draftSmartGeneratorMode;

    final keyModeRelevant =
        _savedActiveKeys.isNotEmpty || _draftActiveKeys.isNotEmpty;

    final chordGenerationSettingsChanged =
        keySettingsChanged ||
        smartGeneratorModeChanged ||
        (keyModeRelevant && nonDiatonicSettingsChanged);

    final hadChordQueue =
        (_currentChord?.chord.isNotEmpty ?? false) ||
        (_nextChord?.chord.isNotEmpty ?? false);

    setState(() {
      _savedMetronomeEnabled = _draftMetronomeEnabled;
      _savedMetronomeVolume = _draftMetronomeVolume;
      _savedActiveKeys = Set<String>.from(_draftActiveKeys);
      _savedSmartGeneratorMode = _draftSmartGeneratorMode;
      _savedSecondaryDominantEnabled = _draftSecondaryDominantEnabled;
      _savedSubstituteDominantEnabled = _draftSubstituteDominantEnabled;

      if (chordGenerationSettingsChanged) {
        _previousChord = null;
        _currentChord = null;
        _nextChord = null;

        if (hadChordQueue || _isAutoRunning) {
          _ensureChordQueueInitialized();
        }

        _currentBeat = _isAutoRunning ? 0 : null;
      }
    });

    if (_savedMetronomeEnabled) {
      await _unlockAudioIfNeeded();
    }
    await _syncMetronomeVolume();

    if (_isAutoRunning && chordGenerationSettingsChanged) {
      await _playMetronomeSound();
      _restartAutoTimer();
    }

    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  _GeneratedChord _generateRandomChord({Set<String> exclude = const {}}) {
    if (_savedActiveKeys.isNotEmpty) {
      return _generateRandomChordFromSelectedKeys(exclude: exclude);
    }
    return _generateFullyRandomChord(exclude: exclude);
  }

  _GeneratedChord _generateFullyRandomChord({Set<String> exclude = const {}}) {
    while (true) {
      final rootSpellings =
          _randomRootSpellings[_random.nextInt(_randomRootSpellings.length)];
      final root = rootSpellings[_random.nextInt(rootSpellings.length)];
      final suffix =
          _randomChordSuffixes[_random.nextInt(_randomChordSuffixes.length)];
      final chord = '$root$suffix';

      if (exclude.contains(chord)) continue;
      return _GeneratedChord(chord: chord);
    }
  }

  List<String> _getEnabledRomanNumeralPool() {
    final pool = List<String>.from(_baseRomanNumeralPool);

    if (_savedSecondaryDominantEnabled) {
      pool.addAll(_secondaryDominantRomanNumeralPool);
    }

    if (_savedSubstituteDominantEnabled) {
      pool.addAll(_substituteDominantRomanNumeralPool);
    }

    return pool;
  }

  bool _isSecondaryOrSubDominant(String romanNumeral) {
    return romanNumeral.startsWith('V7/') || romanNumeral.startsWith('subV7/');
  }

  String? _extractTargetRomanNumeral(String romanNumeral) {
    if (!_isSecondaryOrSubDominant(romanNumeral)) return null;

    final prefixLength = romanNumeral.startsWith('subV7/') ? 6 : 3;
    final degreeName = romanNumeral.substring(prefixLength);
    final degreeIndex = _scaleDegreeIndexMap[degreeName];
    if (degreeIndex == null || degreeIndex >= _baseRomanNumeralPool.length) {
      return null;
    }

    return _baseRomanNumeralPool[degreeIndex];
  }

  String? _getDeceptiveRomanNumeral(String targetRomanNumeral) {
    final targetIndex = _diatonicRomanNumeralIndexMap[targetRomanNumeral];
    if (targetIndex == null) return null;

    final deceptiveIndex = (targetIndex + 2) % _baseRomanNumeralPool.length;
    return _baseRomanNumeralPool[deceptiveIndex];
  }

  String? _selectSmartResolutionRomanNumeral() {
    if (!_savedSmartGeneratorMode) return null;

    final previousRomanNumeral = _previousChord?.romanNumeral;
    if (previousRomanNumeral == null ||
        !_isSecondaryOrSubDominant(previousRomanNumeral)) {
      return null;
    }

    final targetRomanNumeral = _extractTargetRomanNumeral(previousRomanNumeral);
    if (targetRomanNumeral == null) return null;

    final deceptiveRomanNumeral =
        _getDeceptiveRomanNumeral(targetRomanNumeral) ?? targetRomanNumeral;

    final useTarget = _random.nextDouble() < 0.7;
    return useTarget ? targetRomanNumeral : deceptiveRomanNumeral;
  }

  bool _prefersFlatsForKey(String key) {
    switch (key) {
      case 'F':
      case 'C#/Db':
      case 'D#/Eb':
      case 'F#/Gb':
      case 'G#/Ab':
      case 'A#/Bb':
        return true;
      default:
        return false;
    }
  }

  int _normalizePitchClass(int pitch) {
    return ((pitch % 12) + 12) % 12;
  }

  String _extractRootNote(String chord) {
    final match = RegExp(r'^[A-G](?:?|???').firstMatch(chord);
    return match?.group(0) ?? chord;
  }

  int _noteToSemitone(String note) {
    switch (note) {
      case 'C':
      case 'B?':
        return 0;
      case 'C?':
      case 'D??:
        return 1;
      case 'D':
        return 2;
      case 'D?':
      case 'E??:
        return 3;
      case 'E':
      case 'F??:
        return 4;
      case 'E?':
      case 'F':
        return 5;
      case 'F?':
      case 'G??:
        return 6;
      case 'G':
        return 7;
      case 'G?':
      case 'A??:
        return 8;
      case 'A':
        return 9;
      case 'A?':
      case 'B??:
        return 10;
      case 'B':
      case 'C??:
        return 11;
      default:
        throw ArgumentError('????????紐꾪닓 ??????? $note');
    }
  }

  String _pitchToSharpNoteName(int pitch) {
    const names = [
      'C',
      'C?',
      'D',
      'D?',
      'E',
      'F',
      'F?',
      'G',
      'G?',
      'A',
      'A?',
      'B',
    ];
    return names[_normalizePitchClass(pitch)];
  }

  String _pitchToFlatNoteName(int pitch) {
    const names = [
      'C',
      'D??,
      'D',
      'E??,
      'E',
      'F',
      'G??,
      'G',
      'A??,
      'A',
      'B??,
      'B',
    ];
    return names[_normalizePitchClass(pitch)];
  }

  String _pitchToNoteName(int pitch, {required bool preferFlats}) {
    return preferFlats
        ? _pitchToFlatNoteName(pitch)
        : _pitchToSharpNoteName(pitch);
  }

  String _getScaleDegreeRoot(String key, int degreeIndex) {
    final diatonicChords = _diatonicChordMap[key];
    if (diatonicChords == null ||
        degreeIndex < 0 ||
        degreeIndex >= diatonicChords.length) {
      throw StateError('????ъ군???? ??? key ?????scale degree: $key / $degreeIndex');
    }

    return _extractRootNote(diatonicChords[degreeIndex]);
  }

  String _resolveRomanNumeralToChordName(String key, String romanNumeral) {
    final diatonicIndex = _diatonicRomanNumeralIndexMap[romanNumeral];
    if (diatonicIndex != null) {
      final diatonicChords = _diatonicChordMap[key];
      if (diatonicChords == null || diatonicIndex >= diatonicChords.length) {
        return _generateFullyRandomChord().chord;
      }
      return diatonicChords[diatonicIndex];
    }

    if (romanNumeral.startsWith('V7/')) {
      final degreeName = romanNumeral.substring(3);
      final degreeIndex = _scaleDegreeIndexMap[degreeName];
      if (degreeIndex == null) {
        return _generateFullyRandomChord().chord;
      }

      final targetRoot = _getScaleDegreeRoot(key, degreeIndex);
      final dominantPitch = _normalizePitchClass(_noteToSemitone(targetRoot) + 7);
      final dominantRoot = _pitchToNoteName(
        dominantPitch,
        preferFlats: _prefersFlatsForKey(key),
      );

      return '${dominantRoot}7';
    }

    if (romanNumeral.startsWith('subV7/')) {
      final degreeName = romanNumeral.substring(6);
      final degreeIndex = _scaleDegreeIndexMap[degreeName];
      if (degreeIndex == null) {
        return _generateFullyRandomChord().chord;
      }

      final targetRoot = _getScaleDegreeRoot(key, degreeIndex);
      final substitutePitch =
          _normalizePitchClass(_noteToSemitone(targetRoot) + 1);
      final substituteRoot = _pitchToFlatNoteName(substitutePitch);

      return '${substituteRoot}7';
    }

    return _generateFullyRandomChord().chord;
  }

  _GeneratedChord _buildChordFromKeyAndRomanNumeral(
    String key,
    String romanNumeral,
  ) {
    return _GeneratedChord(
      chord: _resolveRomanNumeralToChordName(key, romanNumeral),
      keyName: key,
      romanNumeral: romanNumeral,
    );
  }

  _GeneratedChord _generateRandomChordFromSelectedKeys({
    Set<String> exclude = const {},
  }) {
    final activeKeys = _orderedKeys(_savedActiveKeys);
    final romanNumeralPool = _getEnabledRomanNumeralPool();
    final smartResolutionRomanNumeral = _selectSmartResolutionRomanNumeral();
    final candidateRomanNumerals =
        smartResolutionRomanNumeral == null
            ? romanNumeralPool
            : [smartResolutionRomanNumeral];

    if (activeKeys.isEmpty || candidateRomanNumerals.isEmpty) {
      return _generateFullyRandomChord(exclude: exclude);
    }

    for (var attempt = 0; attempt < 100; attempt++) {
      final selectedKey = activeKeys[_random.nextInt(activeKeys.length)];
      final romanNumeral =
          candidateRomanNumerals[_random.nextInt(candidateRomanNumerals.length)];

      final generated = _buildChordFromKeyAndRomanNumeral(
        selectedKey,
        romanNumeral,
      );

      if (exclude.contains(generated.chord)) continue;
      return generated;
    }

    final available = <_GeneratedChord>[];
    final seenChords = <String>{};

    for (final key in activeKeys) {
      for (final romanNumeral in candidateRomanNumerals) {
        final generated = _buildChordFromKeyAndRomanNumeral(key, romanNumeral);
        if (!exclude.contains(generated.chord) &&
            seenChords.add(generated.chord)) {
          available.add(generated);
        }
      }
    }

    if (available.isNotEmpty) {
      return available[_random.nextInt(available.length)];
    }

    for (final key in activeKeys) {
      for (final romanNumeral in candidateRomanNumerals) {
        return _buildChordFromKeyAndRomanNumeral(key, romanNumeral);
      }
    }

    return _generateFullyRandomChord(exclude: exclude);
  }

  void _ensureChordQueueInitialized() {
    if (_currentChord == null || _currentChord!.chord.isEmpty) {
      _previousChord = null;
      _currentChord = _generateRandomChord();
    }

    if (_nextChord == null ||
        _nextChord!.chord.isEmpty ||
        _nextChord!.chord == _currentChord!.chord) {
      _nextChord = _generateRandomChord(exclude: {_currentChord!.chord});
    }
  }

  void _generateOrShiftChordInternal() {
    if (_currentChord == null || _currentChord!.chord.isEmpty) {
      _previousChord = null;
      _currentChord = _generateRandomChord();
      _nextChord = _generateRandomChord(exclude: {_currentChord!.chord});
      return;
    }

    _previousChord = _currentChord;
    _currentChord = (_nextChord == null || _nextChord!.chord.isEmpty)
        ? _generateRandomChord(exclude: {_previousChord!.chord})
        : _nextChord;

    _nextChord = _generateRandomChord(
      exclude: {
        if (_previousChord != null) _previousChord!.chord,
        if (_currentChord != null) _currentChord!.chord,
      },
    );
  }

  Future<void> _playMetronomeSound() async {
    if (!mounted) return;
    if (!_savedMetronomeEnabled) return;

    await _ensureAudioReady();
    if (!_audioReady) return;

    try {
      await _audioPlayer.setVolume(_effectiveMetronomeVolume);
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('?꿔꺂??????⑷턂??嶺뚮㉡??????????嚥??????곌숯: $e');
    }
  }

  int _getEffectiveBpm() {
    final parsed = int.tryParse(_bpmController.text);
    if (parsed == null || parsed <= 0) {
      return _lastValidBpm;
    }
    return _coerceBpm(parsed);
  }

  Duration _getBeatDuration() {
    final microseconds = (60000000 / _getEffectiveBpm()).round();
    return Duration(microseconds: microseconds < 1 ? 1 : microseconds);
  }

  void _setBpmText(String text) {
    _isUpdatingBpmText = true;
    _bpmController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _isUpdatingBpmText = false;
  }

  void _normalizeBpmIfNeeded() {
    final value = _bpmController.text;

    if (value.isEmpty) {
      _setBpmText(_lastValidBpm.toString());
      return;
    }

    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      _setBpmText(_lastValidBpm.toString());
      return;
    }

    final coerced = _coerceBpm(parsed);
    _lastValidBpm = coerced;

    if (coerced.toString() != value) {
      _setBpmText(coerced.toString());
    }
  }

  void _handleBpmChanged(String value) {
    if (_isUpdatingBpmText || value.isEmpty) return;

    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) {
      _setBpmText(_lastValidBpm.toString());
      return;
    }

    final coerced = _coerceBpm(parsed);
    _lastValidBpm = coerced;

    if (coerced.toString() != value) {
      _setBpmText(coerced.toString());
    }

    if (_isAutoRunning) {
      _restartAutoTimer();
    }
  }

  void _adjustBpm(int delta) {
    final nextValue = _coerceBpm(_getEffectiveBpm() + delta);
    _lastValidBpm = nextValue;
    _setBpmText(nextValue.toString());

    if (_isAutoRunning) {
      _restartAutoTimer();
    }
  }

  Future<void> _manualPickChord() async {
    _normalizeBpmIfNeeded();

    setState(() {
      _generateOrShiftChordInternal();
      _currentBeat = _isAutoRunning ? 0 : null;
    });

    if (_isAutoRunning) {
      await _playMetronomeSound();
      _restartAutoTimer();
    }
  }

  void _advanceAutoBeat() {
    if (!_isAutoRunning || !mounted) return;

    setState(() {
      _ensureChordQueueInitialized();

      if (_currentBeat == null) {
        _currentBeat = 0;
      } else if (_currentBeat! < _beatsPerBar - 1) {
        _currentBeat = _currentBeat! + 1;
      } else {
        _generateOrShiftChordInternal();
        _currentBeat = 0;
      }
    });

    unawaited(_playMetronomeSound());
  }

  void _scheduleNextBeat() {
    if (!_isAutoRunning || _nextBeatAt == null) return;

    var delay = _nextBeatAt!.difference(DateTime.now());
    if (delay.isNegative) {
      delay = Duration.zero;
    }

    _autoTimer = Timer(delay, () {
      if (!mounted || !_isAutoRunning || _nextBeatAt == null) return;

      final scheduledBeatAt = _nextBeatAt!;
      final beatDuration = _getBeatDuration();

      _advanceAutoBeat();

      final now = DateTime.now();
      final drift = now.difference(scheduledBeatAt);

      if (drift.compareTo(beatDuration) > 0) {
        _nextBeatAt = now.add(beatDuration);
      } else {
        _nextBeatAt = scheduledBeatAt.add(beatDuration);
      }

      _scheduleNextBeat();
    });
  }

  void _restartAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = null;
    _nextBeatAt = null;

    if (!_isAutoRunning) return;

    _nextBeatAt = DateTime.now().add(_getBeatDuration());
    _scheduleNextBeat();
  }

  Future<void> _startAutoPick() async {
    if (!mounted || _isAutoRunning || _isStartingAuto) return;

    setState(() {
      _isStartingAuto = true;
    });

    try {
      _normalizeBpmIfNeeded();
      if (_savedMetronomeEnabled) {
        await _unlockAudioIfNeeded();
      }
      if (!mounted) return;

      setState(() {
        _isAutoRunning = true;
        _ensureChordQueueInitialized();
        _currentBeat = 0;
      });

      await _playMetronomeSound();
      _restartAutoTimer();
    } finally {
      if (mounted) {
        setState(() {
          _isStartingAuto = false;
        });
      } else {
        _isStartingAuto = false;
      }
    }
  }

  void _stopAutoPick() {
    _autoTimer?.cancel();
    _autoTimer = null;
    _nextBeatAt = null;
    unawaited(_audioPlayer.stop());

    setState(() {
      _isAutoRunning = false;
      _currentBeat = null;
    });
  }

  Future<void> _toggleAutoPick() async {
    if (_isAutoRunning) {
      _stopAutoPick();
    } else {
      await _startAutoPick();
    }
  }

  bool get _isTextInputFocused {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    return focusedContext?.widget is EditableText;
  }

  void _handleManualShortcut() {
    if (_isTextInputFocused || _isStartingAuto) return;
    unawaited(_manualPickChord());
  }

  void _handleAutoShortcut() {
    if (_isTextInputFocused || _isStartingAuto) return;
    unawaited(_toggleAutoPick());
  }

  void _handleBpmShortcut(int delta) {
    if (_isTextInputFocused) return;
    setState(() {
      _adjustBpm(delta);
    });
  }

  Widget _buildBeatCircle(int index) {
    final theme = Theme.of(context);
    final isFilled = _currentBeat != null && index <= _currentBeat!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isFilled
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
        border: Border.all(color: theme.colorScheme.outline),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _practiceModeTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _practiceModeDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _practiceModeTags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 10),
          Text(
            'Space: ???繹먮굞????ш끽維??? ?  Enter: ???嶺???嶺뚮??ｆ뤃?嚥싳쉶瑗??꾧틡?  ?  ???? BPM ??됰슦????,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (_showAudioWarning) ...[
            const SizedBox(height: 8),
            Text(
              '?꿔꺂??????⑷턂??嶺뚮㉡????????⑦떍??? ?潁??용끏????????鶯? ?꿔꺂??쭫?묒쒜?壤?????? ??ш끽維?????癲ル슢캉??낆춹?????源껎꺘??????????????????嚥??? ????⑤０??????????????딅젩.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsDrawer() {
    final theme = Theme.of(context);

    return SizedBox(
      width: min(MediaQuery.of(context).size.width * 0.9, 420.0),
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
                        '???繹먮냱??,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
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
                        title: const Text('?꿔꺂??????⑷턂??嶺뚮㉡???),
                        subtitle: Text(_draftMetronomeEnabled ? '??獄쏅챷?붼땡? : '???Β?ル빢傭?),
                        value: _draftMetronomeEnabled,
                        onChanged: (value) {
                          setState(() {
                            _draftMetronomeEnabled = value;
                          });
                        },
                      ),
                      if (_showAudioWarning) ...[
                        Text(
                          '????썹땟???????ъ졒??????꿔꺂??????⑷턂??嶺뚮㉡????????⑦떍??? 嚥싳쉶瑗ц짆堉샕?????얜뀥???? ?????깅뉼??????',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        '?꿔꺂??????⑷턂??嶺뚮㉡?????⑤슢????,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: _draftMetronomeEnabled ? 1 : 0.45,
                        child: IgnorePointer(
                          ignoring: !_draftMetronomeEnabled,
                          child: Column(
                            children: [
                              Slider(
                                value: _draftMetronomeVolume,
                                onChanged: (value) {
                                  setState(() {
                                    _draftMetronomeVolume = value;
                                  });
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${(_draftMetronomeVolume * 100).round()}%',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '??嶺???????????key)',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _draftActiveKeys.isEmpty
                            ? '????ｋ?????? ????ㅼ굡?類㎮뵾?????Β??뼐 ??嶺뚮㉡?ｏ쭗??꿔꺂??袁ㅻ븶??????????源껎꺘??嶺뚮ㅎ????'
                            : '????ｋ?????嚥????β뼯援η뙴???亦껋꼨援?? ???쒙쭫???? Roman numeral pool???????????꿔꺂??嶺뚣끇쨘????ш끽維????節륁춻??꿔꺂??????????딅젩.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _keyOptions.map((key) {
                          final selected = _draftActiveKeys.contains(key);

                          return FilterChip(
                            label: Text(key),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  _draftActiveKeys.add(key);
                                } else {
                                  _draftActiveKeys.remove(key);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Smart Generator Mode'),
                        subtitle: const Text(
                          '?? ??? Secondary/Substitute Dominant? ?? ?? ??? resolution ???? ?????.',
                        ),
                        value: _draftSmartGeneratorMode,
                        onChanged: (value) {
                          setState(() {
                            _draftSmartGeneratorMode = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OFF? ?? ?? Roman numeral pool? ??? ?????.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Non-Diatonic',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '?????뚯???維◈??꿔꺂??袁ㅻ븶??????影?쀫븸?????쇨덫???嶺뚮ㅎ???? ??獄쏅챷???Roman numeral pool??????????ㅿ폑?????ル뒇?????????ㅻ쿋???醫딆쓧? ???ㅻ쿋????嶺뚮ㅎ????',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Secondary Dominant'),
                            selected: _draftSecondaryDominantEnabled,
                            showCheckmark: false,
                            onSelected: (value) {
                              setState(() {
                                _draftSecondaryDominantEnabled = value;
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Substitute Dominant'),
                            selected: _draftSubstituteDominantEnabled,
                            showCheckmark: false,
                            onSelected: (value) {
                              setState(() {
                                _draftSubstituteDominantEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _applySettings,
                        child: const Text('????쇨덫??),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(_restoreDraftSettings);
                        },
                        child: const Text('??????),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                        child: const Text('???????),
                      ),
                    ),
                  ],
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
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final previousDisplay = _previousChord?.chord ?? '';
    final currentDisplay = _currentChord?.chord ?? '';
    final nextDisplay = _nextChord?.chord ?? '';

    final sideTextStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurfaceVariant,
    );

    final topSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_beatsPerBar, _buildBeatCircle),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 170,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          previousDisplay,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: sideTextStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            currentDisplay,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          nextDisplay,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: sideTextStyle,
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
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
    );

    final bottomSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isStartingAuto ? null : _manualPickChord,
            child: const Text('???繹먮굞????ш끽維???),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isStartingAuto ? null : _toggleAutoPick,
            child: Text(
              _isStartingAuto
                  ? '嚥싳쉶瑗ц짆堉샕??嚥?..'
                  : (_isAutoRunning ? '???嶺??꿔꺂????紐꾩뗄?嚥싳쉶瑗??꾧틡?' : '???嶺??꿔꺂????紐꾩뗄???嶺뚮??ｆ뤃?),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              onPressed: () {
                setState(() {
                  _adjustBpm(-5);
                });
              },
              icon: const Icon(Icons.remove),
              tooltip: 'BPM ???????,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 96,
              child: TextField(
                controller: _bpmController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                onChanged: _handleBpmChanged,
                onSubmitted: (_) {
                  _normalizeBpmIfNeeded();
                  FocusScope.of(context).unfocus();
                },
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
              onPressed: () {
                setState(() {
                  _adjustBpm(5);
                });
              },
              icon: const Icon(Icons.add),
              tooltip: 'BPM ??????틓楹?,
            ),
            const SizedBox(width: 10),
            Text(
              'BPM',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '????怨몄７ ?筌????? $_minBpm-$_maxBpm',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): _handleManualShortcut,
        const SingleActivator(LogicalKeyboardKey.enter): _handleAutoShortcut,
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          _handleBpmShortcut(5);
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          _handleBpmShortcut(-5);
        },
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
                onPressed: _openSettings,
                icon: const Icon(Icons.settings),
                tooltip: '???繹먮냱??,
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
                            topSection,
                            const SizedBox(height: 20),
                            bottomSection,
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

