import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'settings/practice_settings.dart';
import 'settings/settings_controller.dart';
import 'smart_generator.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppSettingsController();
  await controller.load();
  runApp(MyApp(controller: controller));
}

class _WeightedGeneratedChordCandidate {
  const _WeightedGeneratedChordCandidate({
    required this.chord,
    required this.weight,
  });

  final GeneratedChord chord;
  final int weight;
}

class MyApp extends StatelessWidget {
  MyApp({super.key, AppSettingsController? controller})
    : controller = controller ?? AppSettingsController();

  final AppSettingsController controller;

  static final List<Locale> supportedLocales = AppLanguage.values
      .map((language) => language.locale)
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'SightChord',
          debugShowCheckedModeBanner: false,
          locale: controller.settings.locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1E6258),
            ),
            scaffoldBackgroundColor: const Color(0xFFF6F2E8),
            useMaterial3: true,
          ),
          home: MyHomePage(title: 'SightChord', controller: controller),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final AppSettingsController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _minBpm = 20;
  static const int _maxBpm = 300;
  static const int _beatsPerBar = 4;
  static const String _tickAsset = 'tick.mp3';

  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _bpmController;

  Timer? _autoTimer;
  Future<void>? _audioInitFuture;
  int? _currentBeat;
  bool _audioReady = false;
  bool _autoRunning = false;
  List<QueuedSmartChord> _plannedSmartChordQueue = const <QueuedSmartChord>[];

  GeneratedChord? _previousChord;
  GeneratedChord? _currentChord;
  GeneratedChord? _nextChord;

  PracticeSettings get _settings => widget.controller.settings;

  @override
  void initState() {
    super.initState();
    _bpmController = TextEditingController(text: '${_settings.bpm}');
    _audioInitFuture = _initAudio();
    _ensureChordQueueInitialized();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.setSource(AssetSource(_tickAsset));
      await _audioPlayer.setVolume(_settings.metronomeVolume);
      _audioReady = true;
    } catch (_) {
      _audioReady = false;
    }
  }

  int _effectiveBpm() {
    final parsed = int.tryParse(_bpmController.text) ?? _settings.bpm;
    return parsed.clamp(_minBpm, _maxBpm);
  }

  bool get _usesKeyMode => _settings.usesKeyMode;

  List<String> get _orderedKeys => [
    for (final key in MusicTheory.keyOptions)
      if (_settings.activeKeys.contains(key)) key,
  ];

  void _applySettings(
    PracticeSettings nextSettings, {
    bool reseed = false,
    bool syncBpmText = false,
  }) {
    unawaited(widget.controller.update(nextSettings));
    setState(() {
      if (syncBpmText) {
        _bpmController.text = '${nextSettings.bpm}';
      }
      if (reseed) {
        _reseedChordQueue();
      }
    });
  }

  List<String> _practiceModeTags(AppLocalizations l10n) {
    final tags = <String>[
      _usesKeyMode ? l10n.keyModeTag : l10n.freeModeTag,
    ];
    if (_usesKeyMode) {
      tags.addAll(_orderedKeys);
      if (_settings.smartGeneratorMode) {
        tags.add(l10n.smartGeneratorMode);
      }
      if (_settings.secondaryDominantEnabled) {
        tags.add(l10n.secondaryDominant);
      }
      if (_settings.substituteDominantEnabled) {
        tags.add(l10n.substituteDominant);
      }
      if (_settings.modalInterchangeEnabled) {
        tags.add(l10n.modalInterchange);
      }
    } else {
      tags.add(l10n.allKeysTag);
    }
    tags.add('${_effectiveBpm()} BPM');
    tags.add(
      _settings.metronomeEnabled
          ? l10n.metronomeOnTag
          : l10n.metronomeOffTag,
    );
    return tags;
  }

  String _currentStatusLabel(AppLocalizations l10n) {
    if (_currentChord == null) {
      return l10n.pressNextChordToBegin;
    }
    final analysisLabel = _currentChord!.analysisLabel;
    return analysisLabel.isEmpty ? l10n.freeModeActive : analysisLabel;
  }

  String _practiceModeDescription(AppLocalizations l10n) {
    if (!_usesKeyMode) {
      return l10n.freePracticeDescription;
    }
    if (_settings.smartGeneratorMode) {
      return l10n.smartPracticeDescription;
    }
    return l10n.keyPracticeDescription;
  }

  void _ensureChordQueueInitialized() {
    _nextChord ??= _generateChord();
  }

  void _reseedChordQueue() {
    _previousChord = null;
    _currentChord = null;
    _nextChord = null;
    _plannedSmartChordQueue = const <QueuedSmartChord>[];
    _ensureChordQueueInitialized();
  }

  ChordExclusionContext _buildExclusionContext({
    GeneratedChord? current,
    Set<String> renderedSymbols = const <String>{},
  }) {
    final nextRenderedSymbols = <String>{...renderedSymbols};
    final repeatGuardKeys = <String>{};
    final harmonicComparisonKeys = <String>{};
    if (current != null) {
      nextRenderedSymbols.add(
        ChordRenderingHelper.renderedSymbol(
          current,
          _settings.chordSymbolStyle,
        ),
      );
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
    return exclusionContext.renderedSymbols.contains(
          ChordRenderingHelper.renderedSymbol(
            candidate,
            _settings.chordSymbolStyle,
          ),
        ) ||
        exclusionContext.repeatGuardKeys.contains(candidate.repeatGuardKey) ||
        exclusionContext.harmonicComparisonKeys.contains(
          candidate.harmonicComparisonKey,
        );
  }

  GeneratedChord _generateChord({
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? current,
  }) {
    if (!_usesKeyMode) {
      while (true) {
        final root = MusicTheory.freeModeRoots[
            _random.nextInt(MusicTheory.freeModeRoots.length)];
        final quality = MusicTheory.freeModeQualities[
            _random.nextInt(MusicTheory.freeModeQualities.length)];
        final generatedChord = _buildFreeGeneratedChord(root, quality);
        if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keys = _orderedKeys;
    if (_settings.smartGeneratorMode) {
      return _generateSmartChord(
        keys: keys,
        exclusionContext: exclusionContext,
        current: current,
      );
    }

    return _generateRandomKeyModeChord(
      keys: keys,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChord _buildFreeGeneratedChord(
    String root,
    ChordQuality quality, {
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    final renderQuality =
        quality == ChordQuality.dominant7 &&
            _settings.allowV7sus4 &&
            _random.nextInt(100) < ChordRenderingHelper.dominantSus4Chance
        ? ChordQuality.dominant7sus4
        : quality;
    final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
      random: _random,
      root: root,
      harmonicQuality: quality,
      renderQuality: renderQuality,
      romanNumeralId: null,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      sourceKind: ChordSourceKind.free,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      suppressTensions: false,
      inversionSettings: _settings.inversionSettings,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: null,
      romanNumeralId: null,
      harmonicFunction: HarmonicFunction.free,
      plannedChordKind: PlannedChordKind.resolvedRoman,
      symbolData: renderingSelection.symbolData,
      sourceKind: ChordSourceKind.free,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
          keyName: null,
          romanNumeralId: null,
          harmonicFunction: HarmonicFunction.free,
          plannedChordKind: PlannedChordKind.resolvedRoman,
          symbolData: renderingSelection.symbolData,
          sourceKind: ChordSourceKind.free,
        );
    return GeneratedChord(
      symbolData: renderingSelection.symbolData,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      sourceKind: ChordSourceKind.free,
      smartDebug: smartDebug,
      wasExcludedFallback: wasExcludedFallback,
      isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
    );
  }

  GeneratedChord _buildGeneratedChord(
    String key,
    RomanNumeralId romanNumeralId, {
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    String? patternTag,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    bool suppressTensions = false,
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    final spec = MusicTheory.specFor(romanNumeralId);
    final normalizedAppliedType =
        appliedType ?? _appliedTypeForRoman(romanNumeralId);
    final normalizedResolutionTargetRomanId =
        resolutionTargetRomanId ?? spec.resolutionTargetId;
    final root = MusicTheory.resolveChordRoot(key, romanNumeralId);
    final renderQuality = MusicTheory.resolveRenderQuality(
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      allowV7sus4: _settings.allowV7sus4,
      randomRoll: _random.nextInt(100),
    );
    final harmonicFunction = _harmonicFunctionForGeneratedChord(
      romanNumeralId,
      plannedChordKind: plannedChordKind,
      appliedType: normalizedAppliedType,
    );
    final renderingSelection = ChordRenderingHelper.buildRenderingSelection(
      random: _random,
      root: root,
      harmonicQuality: spec.quality,
      renderQuality: renderQuality,
      romanNumeralId: romanNumeralId,
      plannedChordKind: plannedChordKind,
      sourceKind: spec.sourceKind,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      suppressTensions: suppressTensions,
      inversionSettings: _settings.inversionSettings,
    );
    final repeatGuardKey = ChordRenderingHelper.buildRepeatGuardKey(
      keyName: key,
      romanNumeralId: romanNumeralId,
      harmonicFunction: harmonicFunction,
      plannedChordKind: plannedChordKind,
      symbolData: renderingSelection.symbolData,
      sourceKind: spec.sourceKind,
      appliedType: normalizedAppliedType,
      resolutionTargetRomanId: normalizedResolutionTargetRomanId,
      patternTag: patternTag,
    );
    final harmonicComparisonKey =
        ChordRenderingHelper.buildHarmonicComparisonKey(
          keyName: key,
          romanNumeralId: romanNumeralId,
          harmonicFunction: harmonicFunction,
          plannedChordKind: plannedChordKind,
          symbolData: renderingSelection.symbolData,
          sourceKind: spec.sourceKind,
          appliedType: normalizedAppliedType,
          resolutionTargetRomanId: normalizedResolutionTargetRomanId,
          patternTag: patternTag,
        );
    return GeneratedChord(
      symbolData: renderingSelection.symbolData,
      repeatGuardKey: repeatGuardKey,
      harmonicComparisonKey: harmonicComparisonKey,
      keyName: key,
      romanNumeralId: romanNumeralId,
      resolutionRomanNumeralId: spec.resolutionTargetId,
      harmonicFunction: harmonicFunction,
      patternTag: patternTag,
      plannedChordKind: plannedChordKind,
      sourceKind: spec.sourceKind,
      appliedType: normalizedAppliedType,
      resolutionTargetRomanId: normalizedResolutionTargetRomanId,
      wasExcludedFallback: wasExcludedFallback,
      isRenderedNonDiatonic: renderingSelection.isRenderedNonDiatonic,
      smartDebug: smartDebug?.withFinalSelection(
        finalKey: key,
        finalRomanNumeralId: romanNumeralId,
        finalChord: ChordRenderingHelper.renderedSymbol(
          GeneratedChord(
            symbolData: renderingSelection.symbolData,
            repeatGuardKey: repeatGuardKey,
            harmonicComparisonKey: harmonicComparisonKey,
          ),
          _settings.chordSymbolStyle,
        ),
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
    final resolvedDebug = chord.keyName != null && chord.romanNumeralId != null
        ? smartDebug.withFinalSelection(
            finalKey: chord.keyName!,
            finalRomanNumeralId: chord.romanNumeralId!,
            finalChord: ChordRenderingHelper.renderedSymbol(
              chord,
              _settings.chordSymbolStyle,
            ),
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

  Map<RomanNumeralId, int> _randomKeyModeRomanWeights() {
    final weights = <RomanNumeralId, int>{
      RomanNumeralId.iMaj7: 18,
      RomanNumeralId.iiMin7: 16,
      RomanNumeralId.iiiMin7: 10,
      RomanNumeralId.ivMaj7: 14,
      RomanNumeralId.vDom7: 18,
      RomanNumeralId.viMin7: 14,
      RomanNumeralId.viiHalfDiminished7: 10,
    };
    if (_settings.modalInterchangeEnabled) {
      weights.addAll(const {
        RomanNumeralId.borrowedIvMin7: 4,
        RomanNumeralId.borrowedFlatVII7: 3,
        RomanNumeralId.borrowedFlatVIMaj7: 3,
        RomanNumeralId.borrowedFlatIIIMaj7: 2,
        RomanNumeralId.borrowedIiHalfDiminished7: 2,
        RomanNumeralId.borrowedFlatIIMaj7: 1,
      });
    }
    if (_settings.secondaryDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.secondaryOfII: 5,
        RomanNumeralId.secondaryOfIII: 5,
        RomanNumeralId.secondaryOfIV: 5,
        RomanNumeralId.secondaryOfV: 5,
        RomanNumeralId.secondaryOfVI: 5,
      });
    }
    if (_settings.substituteDominantEnabled) {
      weights.addAll(const {
        RomanNumeralId.substituteOfII: 2,
        RomanNumeralId.substituteOfIII: 2,
        RomanNumeralId.substituteOfIV: 2,
        RomanNumeralId.substituteOfV: 2,
        RomanNumeralId.substituteOfVI: 2,
      });
    }
    return weights;
  }

  List<_WeightedGeneratedChordCandidate> _buildWeightedKeyModeCandidates({
    required List<String> keys,
    required Map<RomanNumeralId, int> romanWeights,
    required ChordExclusionContext exclusionContext,
  }) {
    return [
      for (final key in keys)
        for (final entry in romanWeights.entries)
          if (entry.value > 0)
            () {
              final chord = _buildGeneratedChord(key, entry.key);
              if (_isExcludedCandidate(chord, exclusionContext)) {
                return null;
              }
              return _WeightedGeneratedChordCandidate(
                chord: chord,
                weight: entry.value,
              );
            }(),
      ].whereType<_WeightedGeneratedChordCandidate>().toList();
  }

  GeneratedChord _pickWeightedChord(
    List<_WeightedGeneratedChordCandidate> candidates,
  ) {
    final totalWeight = candidates.fold<int>(
      0,
      (sum, candidate) => sum + candidate.weight,
    );
    var remaining = _random.nextInt(totalWeight);
    for (final candidate in candidates) {
      if (remaining < candidate.weight) {
        return candidate.chord;
      }
      remaining -= candidate.weight;
    }
    return candidates.last.chord;
  }

  GeneratedChord _generateRandomKeyModeChord({
    required List<String> keys,
    required ChordExclusionContext exclusionContext,
  }) {
    final candidates = _buildWeightedKeyModeCandidates(
      keys: keys,
      romanWeights: _randomKeyModeRomanWeights(),
      exclusionContext: exclusionContext,
    );
    if (candidates.isNotEmpty) {
      return _pickWeightedChord(candidates);
    }
    return _buildGeneratedChord(keys.first, RomanNumeralId.iMaj7);
  }

  GeneratedChord _generateRandomDiatonicChord({
    required List<String> keys,
    required ChordExclusionContext exclusionContext,
    String? preferredKey,
  }) {
    final preferredKeys = preferredKey != null && keys.contains(preferredKey)
        ? [preferredKey]
        : keys;
    final preferredCandidates = _buildWeightedKeyModeCandidates(
      keys: preferredKeys,
      romanWeights: const {
        RomanNumeralId.iMaj7: 1,
        RomanNumeralId.iiMin7: 1,
        RomanNumeralId.iiiMin7: 1,
        RomanNumeralId.ivMaj7: 1,
        RomanNumeralId.vDom7: 1,
        RomanNumeralId.viMin7: 1,
        RomanNumeralId.viiHalfDiminished7: 1,
      },
      exclusionContext: exclusionContext,
    );
    if (preferredCandidates.isNotEmpty) {
      return preferredCandidates[
              _random.nextInt(preferredCandidates.length)]
          .chord;
    }

    final fallbackCandidates = _buildWeightedKeyModeCandidates(
      keys: keys,
      romanWeights: const {
        RomanNumeralId.iMaj7: 1,
        RomanNumeralId.iiMin7: 1,
        RomanNumeralId.iiiMin7: 1,
        RomanNumeralId.ivMaj7: 1,
        RomanNumeralId.vDom7: 1,
        RomanNumeralId.viMin7: 1,
        RomanNumeralId.viiHalfDiminished7: 1,
      },
      exclusionContext: exclusionContext,
    );
    if (fallbackCandidates.isNotEmpty) {
      return fallbackCandidates[
              _random.nextInt(fallbackCandidates.length)]
          .chord;
    }

    return _buildGeneratedChord(keys.first, RomanNumeralId.iMaj7);
  }

  List<String> _findCompatibleModulationKeys({
    required List<String> keys,
    required String currentKey,
    required RomanNumeralId resolutionRomanNumeralId,
  }) {
    final targetRoot = MusicTheory.resolveChordRoot(
      currentKey,
      resolutionRomanNumeralId,
    );
    final targetSemitone = MusicTheory.noteToSemitone[targetRoot];
    if (targetSemitone == null) {
      return const [];
    }

    return SmartGeneratorHelper.findCompatibleModulationKeys(
      activeKeys: keys,
      currentKey: currentKey,
      targetSemitone: targetSemitone,
      keyTonicSemitoneResolver: MusicTheory.keyTonicSemitone,
    );
  }

  GeneratedChord _generateSmartChord({
    required List<String> keys,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? current,
  }) {
    if (current?.keyName == null ||
        current?.romanNumeralId == null ||
        !keys.contains(current!.keyName)) {
      return _generateRandomKeyModeChord(
        keys: keys,
        exclusionContext: exclusionContext,
      );
    }

    final currentKey = current.keyName!;
    final currentRomanNumeralId = current.romanNumeralId!;
    final currentResolutionRomanId =
        current.resolutionTargetRomanId ?? current.resolutionRomanNumeralId;
    final modulationCandidateKeys =
        current.isAppliedDominant && currentResolutionRomanId != null
        ? _findCompatibleModulationKeys(
            keys: keys,
            currentKey: currentKey,
            resolutionRomanNumeralId: currentResolutionRomanId,
          )
        : const <String>[];

    final plan = SmartGeneratorHelper.planNextStep(
      random: _random,
      request: SmartStepRequest(
        currentKey: currentKey,
        currentRomanNumeralId: currentRomanNumeralId,
        currentResolutionRomanNumeralId: currentResolutionRomanId,
        currentHarmonicFunction: current.harmonicFunction,
        allowedDiatonicRomanNumerals: MusicTheory.diatonicRomans,
        secondaryDominantEnabled: _settings.secondaryDominantEnabled,
        substituteDominantEnabled: _settings.substituteDominantEnabled,
        modalInterchangeEnabled: _settings.modalInterchangeEnabled,
        modulationCandidateKeys: modulationCandidateKeys,
        previousRomanNumeralId: _previousChord?.romanNumeralId,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
        currentRenderedNonDiatonic: current.isRenderedNonDiatonic,
      ),
    );
    _plannedSmartChordQueue = plan.remainingQueuedChords;

    final generatedChord = _buildGeneratedChord(
      plan.finalKey,
      plan.finalRomanNumeralId,
      plannedChordKind: plan.plannedChordKind,
      patternTag: plan.patternTag,
      appliedType: plan.appliedType,
      resolutionTargetRomanId: plan.resolutionTargetRomanId,
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

  HarmonicFunction _harmonicFunctionForGeneratedChord(
    RomanNumeralId romanNumeralId, {
    required PlannedChordKind plannedChordKind,
    AppliedType? appliedType,
  }) {
    if (appliedType == AppliedType.secondary ||
        appliedType == AppliedType.substitute) {
      return HarmonicFunction.dominant;
    }
    if (plannedChordKind != PlannedChordKind.resolvedRoman) {
      return HarmonicFunction.tonic;
    }
    return MusicTheory.specFor(romanNumeralId).harmonicFunction;
  }

  AppliedType? _appliedTypeForRoman(RomanNumeralId romanNumeralId) {
    final sourceKind = MusicTheory.specFor(romanNumeralId).sourceKind;
    if (sourceKind == ChordSourceKind.substituteDominant) {
      return AppliedType.substitute;
    }
    if (sourceKind == ChordSourceKind.secondaryDominant) {
      return AppliedType.secondary;
    }
    return null;
  }

  Future<void> _playMetronomeIfNeeded() async {
    if (!_settings.metronomeEnabled) {
      return;
    }
    await (_audioInitFuture ?? Future<void>.value());
    if (!_audioReady) {
      return;
    }
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(_settings.metronomeVolume);
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
    if (!mounted) {
      return;
    }
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
    if (!mounted) {
      return;
    }
    var shouldAdvanceChord = false;
    setState(() {
      final nextBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
      _currentBeat = nextBeat;
      shouldAdvanceChord = nextBeat == 0;
    });

    await _playMetronomeIfNeeded();

    if (!mounted || !shouldAdvanceChord) {
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
    _applySettings(
      _settings.copyWith(bpm: next),
      syncBpmText: true,
    );
    _rescheduleAutoTimer();
  }

  void _handleBpmChanged(String value) {
    if (_autoRunning && int.tryParse(value) != null) {
      _rescheduleAutoTimer();
    }
    setState(() {});
  }

  void _normalizeBpm() {
    final normalized = _effectiveBpm();
    _applySettings(
      _settings.copyWith(bpm: normalized),
      syncBpmText: true,
    );
    _rescheduleAutoTimer();
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

  Widget _buildSummaryCard(AppLocalizations l10n) {
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
              _usesKeyMode
                  ? l10n.keyPracticeOverview
                  : l10n.freePracticeOverview,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _practiceModeDescription(l10n),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _practiceModeTags(l10n)
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
              l10n.keyboardShortcutHelp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildSettingsDrawer(AppLocalizations l10n) {
    final theme = Theme.of(context);

    return SizedBox(
      width: min(MediaQuery.of(context).size.width * 0.9, 430),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settings,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                      tooltip: l10n.closeSettings,
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
                      _buildSettingsSectionTitle(l10n.language),
                      DropdownButtonFormField<AppLanguage>(
                        key: const ValueKey('language-selector'),
                        initialValue: _settings.language,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.language,
                          isDense: true,
                        ),
                        items: AppLanguage.values
                            .map(
                              (language) => DropdownMenuItem<AppLanguage>(
                                value: language,
                                child: Text(language.nativeLabel),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          _applySettings(_settings.copyWith(language: value));
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildSettingsSectionTitle(l10n.metronome),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.metronome),
                        subtitle: Text(
                          _settings.metronomeEnabled
                              ? l10n.enabled
                              : l10n.disabled,
                        ),
                        value: _settings.metronomeEnabled,
                        onChanged: (value) {
                          _applySettings(
                            _settings.copyWith(metronomeEnabled: value),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.metronomeHelp,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.metronomeVolume,
                        style: theme.textTheme.titleMedium,
                      ),
                      Slider(
                        value: _settings.metronomeVolume,
                        onChanged: _settings.metronomeEnabled
                            ? (value) {
                                _applySettings(
                                  _settings.copyWith(metronomeVolume: value),
                                );
                              }
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(_settings.metronomeVolume * 100).round()}%',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingsSectionTitle(l10n.keys),
                      Text(
                        _usesKeyMode ? l10n.keysSelectedHelp : l10n.noKeysSelected,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MusicTheory.keyOptions.map((key) {
                          return FilterChip(
                            label: Text(key),
                            selected: _settings.activeKeys.contains(key),
                            showCheckmark: false,
                            onSelected: (selected) {
                              final nextKeys = <String>{..._settings.activeKeys};
                              if (selected) {
                                nextKeys.add(key);
                              } else {
                                nextKeys.remove(key);
                              }
                              _applySettings(
                                _settings.copyWith(activeKeys: nextKeys),
                                reseed: true,
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.smartGeneratorMode),
                        subtitle: Text(
                          _usesKeyMode
                              ? l10n.smartGeneratorHelp
                              : l10n.keyModeRequiredForSmartGenerator,
                        ),
                        value: _settings.smartGeneratorMode,
                        onChanged: _usesKeyMode
                            ? (value) {
                                _applySettings(
                                  _settings.copyWith(
                                    smartGeneratorMode: value,
                                  ),
                                  reseed: true,
                                );
                              }
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsSectionTitle(l10n.nonDiatonic),
                      if (!_usesKeyMode)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.nonDiatonicRequiresKeyMode,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: Text(l10n.secondaryDominant),
                            selected: _settings.secondaryDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    _applySettings(
                                      _settings.copyWith(
                                        secondaryDominantEnabled: selected,
                                      ),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                          FilterChip(
                            label: Text(l10n.substituteDominant),
                            selected: _settings.substituteDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    _applySettings(
                                      _settings.copyWith(
                                        substituteDominantEnabled: selected,
                                      ),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                          FilterChip(
                            key: const ValueKey('modal-interchange-chip'),
                            label: Text(l10n.modalInterchange),
                            selected: _settings.modalInterchangeEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    _applySettings(
                                      _settings.copyWith(
                                        modalInterchangeEnabled: selected,
                                      ),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                      if (!_usesKeyMode)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.modalInterchangeDisabledHelp,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _buildSettingsSectionTitle(l10n.rendering),
                      DropdownButtonFormField<ChordSymbolStyle>(
                        key: const ValueKey('chord-symbol-style-dropdown'),
                        initialValue: _settings.chordSymbolStyle,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.chordSymbolStyle,
                          helperText: l10n.chordSymbolStyleHelp,
                        ),
                        items: ChordSymbolStyle.values.map((style) {
                          final label = switch (style) {
                            ChordSymbolStyle.compact => l10n.styleCompact,
                            ChordSymbolStyle.majText => l10n.styleMajText,
                            ChordSymbolStyle.deltaJazz => l10n.styleDeltaJazz,
                          };
                          return DropdownMenuItem<ChordSymbolStyle>(
                            value: style,
                            child: Text(
                              '$label  ${ChordSymbolFormatter.example(style)}',
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return ChordSymbolStyle.values.map((style) {
                            final label = switch (style) {
                              ChordSymbolStyle.compact => l10n.styleCompact,
                              ChordSymbolStyle.majText => l10n.styleMajText,
                              ChordSymbolStyle.deltaJazz => l10n.styleDeltaJazz,
                            };
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(label, overflow: TextOverflow.ellipsis),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          _applySettings(
                            _settings.copyWith(chordSymbolStyle: value),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            key: const ValueKey('allow-v7sus4-chip'),
                            label: Text(l10n.allowV7sus4),
                            selected: _settings.allowV7sus4,
                            showCheckmark: false,
                            onSelected: (selected) {
                              _applySettings(
                                _settings.copyWith(allowV7sus4: selected),
                                reseed: true,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        key: const ValueKey('allow-tensions-toggle'),
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.allowTensions),
                        subtitle: Text(l10n.tensionHelp),
                        value: _settings.allowTensions,
                        onChanged: (value) {
                          _applySettings(
                            _settings.copyWith(allowTensions: value),
                            reseed: true,
                          );
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
                                selected: _settings.selectedTensionOptions
                                    .contains(tension),
                                showCheckmark: false,
                                onSelected: _settings.allowTensions
                                    ? (selected) {
                                        final nextTensions = <String>{
                                          ..._settings.selectedTensionOptions,
                                        };
                                        if (selected) {
                                          nextTensions.add(tension);
                                        } else {
                                          nextTensions.remove(tension);
                                        }
                                        _applySettings(
                                          _settings.copyWith(
                                            selectedTensionOptions:
                                                nextTensions,
                                          ),
                                          reseed: true,
                                        );
                                      }
                                    : null,
                              );
                            })
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Text(l10n.inversions, style: theme.textTheme.titleMedium),
                      SwitchListTile.adaptive(
                        key: const ValueKey('enable-inversions-toggle'),
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.enableInversions),
                        subtitle: Text(l10n.inversionHelp),
                        value: _settings.inversionSettings.enabled,
                        onChanged: (value) {
                          _applySettings(
                            _settings.copyWith(
                              inversionSettings: _settings.inversionSettings
                                  .copyWith(enabled: value),
                            ),
                            reseed: true,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              key: const ValueKey('first-inversion-chip'),
                              label: Text(l10n.firstInversion),
                              selected: _settings
                                  .inversionSettings
                                  .firstInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      _applySettings(
                                        _settings.copyWith(
                                          inversionSettings: _settings
                                              .inversionSettings
                                              .copyWith(
                                                firstInversionEnabled: selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              key: const ValueKey('second-inversion-chip'),
                              label: Text(l10n.secondInversion),
                              selected: _settings
                                  .inversionSettings
                                  .secondInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      _applySettings(
                                        _settings.copyWith(
                                          inversionSettings: _settings
                                              .inversionSettings
                                              .copyWith(
                                                secondInversionEnabled:
                                                    selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              key: const ValueKey('third-inversion-chip'),
                              label: Text(l10n.thirdInversion),
                              selected: _settings
                                  .inversionSettings
                                  .thirdInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      _applySettings(
                                        _settings.copyWith(
                                          inversionSettings: _settings
                                              .inversionSettings
                                              .copyWith(
                                                thirdInversionEnabled: selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final previousDisplay = _previousChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _previousChord!,
            _settings.chordSymbolStyle,
          );
    final currentDisplay = _currentChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _currentChord!,
            _settings.chordSymbolStyle,
          );
    final nextDisplay = _nextChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _nextChord!,
            _settings.chordSymbolStyle,
          );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): _advanceChordUnawaited,
        const SingleActivator(LogicalKeyboardKey.enter): _toggleAutoPlay,
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _adjustBpm(5),
        const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
            _adjustBpm(-5),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          endDrawer: _buildSettingsDrawer(l10n),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: const Icon(Icons.settings),
                tooltip: l10n.settings,
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
                                                    key: const ValueKey(
                                                      'current-chord-text',
                                                    ),
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
                                            _currentStatusLabel(l10n),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
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
                                _buildSummaryCard(l10n),
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
                                    child: Text(l10n.nextChord),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _toggleAutoPlay,
                                    child: Text(
                                      _autoRunning
                                          ? l10n.stopAutoplay
                                          : l10n.startAutoplay,
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
                                      tooltip: l10n.decreaseBpm,
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
                                          FilteringTextInputFormatter
                                              .digitsOnly,
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
                                      tooltip: l10n.increaseBpm,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'BPM',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.allowedRange(_minBpm, _maxBpm),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
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
