import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'music/voicing_engine.dart';
import 'music/voicing_models.dart';
import 'settings/inversion_settings.dart';
import 'settings/practice_settings.dart';
import 'settings/practice_settings_drawer.dart';
import 'settings/settings_controller.dart';
import 'smart_generator.dart';
import 'widgets/voicing_suggestions_section.dart';

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

  static const List<Locale> supportedLocales =
      AppLocalizations.supportedLocales;

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
  const MyHomePage({super.key, required this.title, required this.controller});

  final String title;
  final AppSettingsController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _minBpm = 20;
  static const int _maxBpm = 300;
  static const int _beatsPerBar = 4;

  final Random _random = Random();
  static const int _metronomePoolMinPlayers = 2;
  static const int _metronomePoolMaxPlayers = 4;

  AudioPool? _metronomePool;
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
  GeneratedChord? _lookAheadChord;
  VoicingRecommendationSet? _voicingRecommendations;
  ConcreteVoicing? _selectedVoicing;
  ConcreteVoicing? _lockedCurrentVoicing;
  ConcreteVoicing? _continuityReferenceVoicing;
  String? _lastLoggedVoicingDiagnosticKey;

  PracticeSettings get _settings => widget.controller.settings;

  @override
  void initState() {
    super.initState();
    _bpmController = TextEditingController(text: '${_settings.bpm}');
    _audioInitFuture = _initAudio();
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
  }

  Future<void> _initAudio() async {
    await _queueMetronomeSoundLoad(_settings.metronomeSound);
  }

  Future<void> _queueMetronomeSoundLoad(MetronomeSound sound) {
    final previousInit = _audioInitFuture;
    final loadFuture = () async {
      if (previousInit != null) {
        try {
          await previousInit;
        } catch (_) {}
      }
      await _loadMetronomeSound(sound);
    }();
    _audioInitFuture = loadFuture;
    return loadFuture;
  }

  Future<void> _loadMetronomeSound(MetronomeSound sound) async {
    final previousPool = _metronomePool;
    try {
      // Use a small player pool for metronome clicks so rapid beats do not
      // contend with a single stop/resume cycle.
      final nextPool = await AudioPool.createFromAsset(
        path: sound.assetFileName,
        minPlayers: _metronomePoolMinPlayers,
        maxPlayers: _metronomePoolMaxPlayers,
      );
      if (!mounted) {
        await nextPool.dispose();
        return;
      }
      _metronomePool = nextPool;
      _audioReady = true;
      await previousPool?.dispose();
    } catch (_) {
      if (!mounted) {
        return;
      }
      _metronomePool = previousPool;
      _audioReady = _metronomePool != null;
    }
  }

  Duration _beatInterval() {
    return Duration(microseconds: (60000000 / _effectiveBpm()).round());
  }

  Duration _beatIndicatorAnimationDuration() {
    final beatMilliseconds = _beatInterval().inMilliseconds;
    final scaledMilliseconds = (beatMilliseconds * 0.42).round();
    final clampedMilliseconds = scaledMilliseconds.clamp(55, 180);
    return Duration(milliseconds: clampedMilliseconds);
  }

  int _effectiveBpm() {
    final parsed = int.tryParse(_bpmController.text) ?? _settings.bpm;
    return parsed.clamp(_minBpm, _maxBpm);
  }

  bool get _usesKeyMode => _settings.usesKeyMode;

  List<KeyCenter> get _orderedKeyCenters => [
    for (final mode in KeyMode.values)
      for (final center in MusicTheory.orderedKeyCentersForMode(mode))
        if (_settings.activeKeyCenters.contains(center)) center,
  ];

  bool _setEquals<T>(Set<T> left, Set<T> right) {
    if (identical(left, right)) {
      return true;
    }
    if (left.length != right.length) {
      return false;
    }
    for (final value in left) {
      if (!right.contains(value)) {
        return false;
      }
    }
    return true;
  }

  bool _sameInversionSettings(InversionSettings left, InversionSettings right) {
    return left.enabled == right.enabled &&
        left.firstInversionEnabled == right.firstInversionEnabled &&
        left.secondInversionEnabled == right.secondInversionEnabled &&
        left.thirdInversionEnabled == right.thirdInversionEnabled;
  }

  bool _queueAffectingSettingsChanged(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    return !_setEquals(previous.activeKeyCenters, next.activeKeyCenters) ||
        previous.smartGeneratorMode != next.smartGeneratorMode ||
        previous.secondaryDominantEnabled != next.secondaryDominantEnabled ||
        previous.substituteDominantEnabled != next.substituteDominantEnabled ||
        previous.modalInterchangeEnabled != next.modalInterchangeEnabled ||
        previous.modulationIntensity != next.modulationIntensity ||
        previous.jazzPreset != next.jazzPreset ||
        previous.sourceProfile != next.sourceProfile ||
        previous.allowV7sus4 != next.allowV7sus4 ||
        previous.allowTensions != next.allowTensions ||
        !_setEquals(
          previous.selectedTensionOptions,
          next.selectedTensionOptions,
        ) ||
        !_sameInversionSettings(
          previous.inversionSettings,
          next.inversionSettings,
        );
  }

  bool _shouldForceLookAheadRefresh(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    if (!next.voicingSuggestionsEnabled || next.lookAheadDepth < 2) {
      return false;
    }
    if (!previous.voicingSuggestionsEnabled || previous.lookAheadDepth < 2) {
      return true;
    }
    return _queueAffectingSettingsChanged(previous, next);
  }

  void _applySettings(
    PracticeSettings nextSettings, {
    bool reseed = false,
    bool syncBpmText = false,
  }) {
    final previousSettings = _settings;
    if (nextSettings.metronomeSound != previousSettings.metronomeSound) {
      _audioInitFuture = _queueMetronomeSoundLoad(nextSettings.metronomeSound);
    }
    final forceLookAheadRefresh =
        !reseed && _shouldForceLookAheadRefresh(previousSettings, nextSettings);
    unawaited(widget.controller.update(nextSettings));
    setState(() {
      if (syncBpmText) {
        _bpmController.text = '${nextSettings.bpm}';
      }
      if (reseed) {
        _reseedChordQueue();
      } else {
        _recomputeVoicingSuggestions(
          forceLookAheadRefresh: forceLookAheadRefresh,
        );
      }
    });
  }

  List<String> _practiceModeTags(AppLocalizations l10n) {
    final tags = <String>[_usesKeyMode ? l10n.keyModeTag : l10n.freeModeTag];
    if (_usesKeyMode) {
      tags.addAll(
        _orderedKeyCenters.map(
          (center) => _keyCenterLabel(l10n, center, trailingColon: false),
        ),
      );
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
      _settings.metronomeEnabled ? l10n.metronomeOnTag : l10n.metronomeOffTag,
    );
    return tags;
  }

  String _currentStatusLabel(AppLocalizations l10n) {
    if (_currentChord == null) {
      return l10n.pressNextChordToBegin;
    }
    final analysisLabel = _localizedAnalysisLabel(l10n, _currentChord!);
    return analysisLabel.isEmpty ? l10n.freeModeActive : analysisLabel;
  }

  String _localizedAnalysisLabel(AppLocalizations l10n, GeneratedChord chord) {
    final romanNumeralId = chord.romanNumeralId;
    if (romanNumeralId == null) {
      return '';
    }

    final keyCenter = chord.keyCenter;
    final centerLabel = keyCenter == null
        ? chord.keyName
        : _keyCenterLabel(l10n, keyCenter, trailingColon: true);
    final roman = MusicTheory.romanTokenOf(romanNumeralId);

    if (centerLabel == null || centerLabel.isEmpty) {
      return roman;
    }
    return '$centerLabel $roman';
  }

  String _keyCenterLabel(
    AppLocalizations l10n,
    KeyCenter center, {
    required bool trailingColon,
  }) {
    final root = switch (_settings.keyCenterLabelStyle) {
      KeyCenterLabelStyle.modeText => MusicTheory.displayRootForKey(
        center.tonicName,
      ),
      KeyCenterLabelStyle.classicalCase =>
        center.mode == KeyMode.major
            ? MusicTheory.displayRootForKey(center.tonicName)
            : MusicTheory.classicalDisplayRootForKey(center.tonicName),
    };
    final label = switch (_settings.keyCenterLabelStyle) {
      KeyCenterLabelStyle.modeText =>
        '$root ${center.mode == KeyMode.major ? l10n.modeMajor : l10n.modeMinor}',
      KeyCenterLabelStyle.classicalCase => root,
    };
    return trailingColon ? '$label:' : label;
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
    _refreshLookAheadChord();
  }

  void _reseedChordQueue() {
    _previousChord = null;
    _currentChord = null;
    _nextChord = null;
    _lookAheadChord = null;
    _plannedSmartChordQueue = const <QueuedSmartChord>[];
    _selectedVoicing = null;
    _lockedCurrentVoicing = null;
    _continuityReferenceVoicing = null;
    _voicingRecommendations = null;
    _lastLoggedVoicingDiagnosticKey = null;
    _ensureChordQueueInitialized();
    _recomputeVoicingSuggestions();
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

  String _renderedSymbolForChord(GeneratedChord chord) {
    return ChordRenderingHelper.renderedSymbol(
      chord,
      _settings.chordSymbolStyle,
    );
  }

  void _refreshLookAheadChord({bool force = false}) {
    if (!_settings.voicingSuggestionsEnabled || _settings.lookAheadDepth < 2) {
      _lookAheadChord = null;
      return;
    }
    final nextChord = _nextChord;
    if (nextChord == null) {
      _lookAheadChord = null;
      return;
    }
    if (_lookAheadChord != null && !force) {
      return;
    }
    final renderedSymbols = <String>{};
    if (_currentChord != null) {
      renderedSymbols.add(_renderedSymbolForChord(_currentChord!));
    }
    _lookAheadChord = _generateChord(
      exclusionContext: _buildExclusionContext(
        current: nextChord,
        renderedSymbols: renderedSymbols,
      ),
      current: nextChord,
    );
  }

  List<GeneratedChord> _voicingFutureChords() => [?_lookAheadChord];

  VoicingContext? _composeVoicingContext({bool forceLookAheadRefresh = false}) {
    final currentChord = _currentChord;
    if (!_settings.voicingSuggestionsEnabled || currentChord == null) {
      return null;
    }
    _refreshLookAheadChord(force: forceLookAheadRefresh);
    return VoicingContext(
      previousChord: _previousChord,
      currentChord: currentChord,
      nextChord: _nextChord,
      futureChords: _voicingFutureChords(),
      previousVoicing: _continuityReferenceVoicing,
      lockedVoicing: _lockedCurrentVoicing,
      preferredTopNotePitchClass: _settings.voicingTopNotePreference.pitchClass,
      settings: _settings,
      lookAheadDepth: _settings.lookAheadDepth,
    );
  }

  ConcreteVoicing? _matchVoicingBySignature(
    ConcreteVoicing? existing,
    VoicingRecommendationSet recommendations,
  ) {
    if (existing == null) {
      return null;
    }
    final matched = recommendations.candidateBySignature(existing.signature);
    return matched?.voicing;
  }

  ConcreteVoicing? _continuitySourceVoicing() {
    return _lockedCurrentVoicing ??
        _selectedVoicing ??
        (_voicingRecommendations != null &&
                _voicingRecommendations!.suggestions.isNotEmpty
            ? _voicingRecommendations!.suggestions.first.voicing
            : null);
  }

  void _promoteChordQueue() {
    _continuityReferenceVoicing = _continuitySourceVoicing();
    _previousChord = _currentChord;
    _currentChord = _nextChord ?? _generateChord(current: _currentChord);
    _nextChord =
        _lookAheadChord ??
        _generateChord(
          exclusionContext: _buildExclusionContext(current: _currentChord),
          current: _currentChord,
        );
    _lookAheadChord = null;
    _lockedCurrentVoicing = null;
    _selectedVoicing = null;
    _recomputeVoicingSuggestions();
  }

  void _recomputeVoicingSuggestions({bool forceLookAheadRefresh = false}) {
    if (!_settings.voicingSuggestionsEnabled || _currentChord == null) {
      _voicingRecommendations = null;
      _selectedVoicing = null;
      _lockedCurrentVoicing = null;
      _lastLoggedVoicingDiagnosticKey = null;
      return;
    }

    final context = _composeVoicingContext(
      forceLookAheadRefresh: forceLookAheadRefresh,
    );
    if (context == null) {
      _voicingRecommendations = null;
      return;
    }

    final recommendations = VoicingEngine.recommend(context: context);
    _voicingRecommendations = recommendations;
    _lockedCurrentVoicing = _matchVoicingBySignature(
      _lockedCurrentVoicing,
      recommendations,
    );
    _selectedVoicing =
        _lockedCurrentVoicing ??
        _matchVoicingBySignature(_selectedVoicing, recommendations) ??
        (recommendations.suggestions.isNotEmpty
            ? recommendations.suggestions.first.voicing
            : null);

    if (_settings.smartDiagnosticsEnabled &&
        recommendations.suggestions.isNotEmpty) {
      final bestSuggestion = recommendations.suggestions.first;
      final diagnosticKey =
          '${context.currentChord.harmonicComparisonKey}|'
          '${bestSuggestion.voicing.signature}';
      if (_lastLoggedVoicingDiagnosticKey != diagnosticKey) {
        developer.log(
          '${context.diagnosticSummary} '
          '${bestSuggestion.voicing.noteNames.join('-')} '
          '${bestSuggestion.breakdown.describe()}',
          name: 'sightchord.voicing',
        );
        _lastLoggedVoicingDiagnosticKey = diagnosticKey;
      }
    } else {
      _lastLoggedVoicingDiagnosticKey = null;
    }
  }

  void _handleVoicingSelected(VoicingSuggestion suggestion) {
    setState(() {
      _selectedVoicing = suggestion.voicing;
    });
  }

  void _handleVoicingLockToggle(VoicingSuggestion suggestion) {
    setState(() {
      if (_lockedCurrentVoicing?.signature == suggestion.voicing.signature) {
        _lockedCurrentVoicing = null;
      } else {
        _lockedCurrentVoicing = suggestion.voicing;
        _selectedVoicing = suggestion.voicing;
      }
      _recomputeVoicingSuggestions();
    });
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
        final root = MusicTheory
            .freeModeRoots[_random.nextInt(MusicTheory.freeModeRoots.length)];
        final quality =
            MusicTheory.freeModeQualities[_random.nextInt(
              MusicTheory.freeModeQualities.length,
            )];
        final generatedChord = _buildFreeGeneratedChord(root, quality);
        if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
          return generatedChord;
        }
      }
    }

    final keyCenters = _orderedKeyCenters;
    if (keyCenters.isEmpty) {
      return _buildGeneratedChord(
        MusicTheory.keyOptions.first,
        RomanNumeralId.iMaj7,
      );
    }
    if (_settings.smartGeneratorMode) {
      return _generateSmartChord(
        keyCenters: keyCenters,
        exclusionContext: exclusionContext,
        current: current,
      );
    }

    return _generateRandomKeyModeChord(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
  }

  GeneratedChord _buildFreeGeneratedChord(
    String root,
    ChordQuality quality, {
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
  }) {
    // Free mode has no Roman identity, so V7sus4 stays unavailable here.
    final renderQuality = quality;
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
    KeyCenter? keyCenter,
    KeyMode keyMode = KeyMode.major,
    PlannedChordKind plannedChordKind = PlannedChordKind.resolvedRoman,
    ChordQuality? renderQualityOverride,
    String? patternTag,
    AppliedType? appliedType,
    RomanNumeralId? resolutionTargetRomanId,
    DominantContext? dominantContext,
    DominantIntent? dominantIntent,
    bool suppressTensions = false,
    SmartGenerationDebug? smartDebug,
    bool wasExcludedFallback = false,
    ChordExclusionContext exclusionContext = const ChordExclusionContext(),
    GeneratedChord? previousChord,
  }) {
    final effectiveKeyCenter =
        keyCenter ?? MusicTheory.keyCenterFor(key, mode: keyMode);
    final smartTrace = smartDebug is SmartDecisionTrace ? smartDebug : null;
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: _random,
      previousChord: previousChord,
      allowV7sus4: _settings.allowV7sus4,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      inversionSettings: _settings.inversionSettings,
      debugChordStyle: _settings.chordSymbolStyle,
      candidates: [
        SmartRenderCandidate(
          keyCenter: effectiveKeyCenter,
          romanNumeralId: romanNumeralId,
          plannedChordKind: plannedChordKind,
          renderQualityOverride: renderQualityOverride,
          patternTag: patternTag,
          appliedType: appliedType,
          resolutionTargetRomanId: resolutionTargetRomanId,
          dominantContext: dominantContext,
          dominantIntent: dominantIntent,
          suppressTensions: suppressTensions,
          smartDebug: smartTrace,
          wasExcludedFallback: wasExcludedFallback,
        ),
      ],
    );
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return comparison.selected.chord;
  }

  GeneratedChord _attachSmartDebug(
    GeneratedChord chord,
    SmartGenerationDebug smartDebug, {
    bool wasExcludedFallback = false,
  }) {
    final resolvedDebug =
        chord.keyCenter != null && chord.romanNumeralId != null
        ? smartDebug.withFinalSelection(
            finalKeyCenter: chord.keyCenter!,
            finalRomanNumeralId: chord.romanNumeralId!,
            finalChord: ChordRenderingHelper.renderedSymbol(
              chord,
              _settings.chordSymbolStyle,
            ),
            fallbackOccurred: wasExcludedFallback,
            finalRoot: chord.symbolData.root,
            finalRenderQuality: chord.symbolData.renderQuality,
            finalTensions: chord.symbolData.tensions,
          )
        : smartDebug;
    return chord.copyWith(
      wasExcludedFallback: wasExcludedFallback,
      smartDebug: resolvedDebug,
    );
  }

  GeneratedChord _emitSmartDebug(GeneratedChord chord) {
    final smartDebug = chord.smartDebug;
    if (smartDebug is SmartDecisionTrace) {
      SmartDiagnosticsStore.record(smartDebug);
      if (_settings.smartDiagnosticsEnabled) {
        developer.log(
          smartDebug.describe(),
          name: 'sightchord.smart_generator',
        );
      }
    }
    return chord;
  }

  Map<RomanNumeralId, int> _randomKeyModeRomanWeightsFor(KeyMode mode) {
    if (mode == KeyMode.minor) {
      return const {
        RomanNumeralId.iMinMaj7: 16,
        RomanNumeralId.iMin7: 14,
        RomanNumeralId.iMin6: 12,
        RomanNumeralId.iiHalfDiminishedMinor: 12,
        RomanNumeralId.flatIIIMaj7Minor: 10,
        RomanNumeralId.ivMin7Minor: 12,
        RomanNumeralId.vDom7: 16,
        RomanNumeralId.flatVIMaj7Minor: 10,
        RomanNumeralId.flatVIIDom7Minor: 10,
      };
    }

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

  Map<RomanNumeralId, int> _diatonicRomanWeightsFor(KeyMode mode) => {
    for (final roman in MusicTheory.diatonicRomansForMode(mode)) roman: 1,
  };

  List<_WeightedGeneratedChordCandidate> _buildWeightedKeyModeCandidates({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    Map<RomanNumeralId, int> Function(KeyMode mode)? romanWeightsForMode,
  }) {
    return [
      for (final keyCenter in keyCenters)
        for (final entry
            in (romanWeightsForMode ?? _randomKeyModeRomanWeightsFor)(
              keyCenter.mode,
            ).entries)
          if (entry.value > 0)
            () {
              final chord = _buildGeneratedChord(
                keyCenter.tonicName,
                entry.key,
                keyCenter: keyCenter,
              );
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
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
  }) {
    final candidates = _buildWeightedKeyModeCandidates(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
    );
    if (candidates.isNotEmpty) {
      return _pickWeightedChord(candidates);
    }
    final fallbackCenter = keyCenters.first;
    return _buildGeneratedChord(
      fallbackCenter.tonicName,
      fallbackCenter.mode == KeyMode.major
          ? RomanNumeralId.iMaj7
          : RomanNumeralId.iMin7,
      keyCenter: fallbackCenter,
    );
  }

  GeneratedChord _generateRandomDiatonicChord({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    KeyCenter? preferredKeyCenter,
  }) {
    final preferredCenters =
        preferredKeyCenter != null && keyCenters.contains(preferredKeyCenter)
        ? [preferredKeyCenter]
        : keyCenters;
    final preferredCandidates = _buildWeightedKeyModeCandidates(
      keyCenters: preferredCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: _diatonicRomanWeightsFor,
    );
    if (preferredCandidates.isNotEmpty) {
      return preferredCandidates[_random.nextInt(preferredCandidates.length)]
          .chord;
    }

    final fallbackCandidates = _buildWeightedKeyModeCandidates(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      romanWeightsForMode: _diatonicRomanWeightsFor,
    );
    if (fallbackCandidates.isNotEmpty) {
      return fallbackCandidates[_random.nextInt(fallbackCandidates.length)]
          .chord;
    }

    final fallbackCenter = keyCenters.first;
    return _buildGeneratedChord(
      fallbackCenter.tonicName,
      fallbackCenter.mode == KeyMode.major
          ? RomanNumeralId.iMaj7
          : RomanNumeralId.iMin7,
      keyCenter: fallbackCenter,
    );
  }

  GeneratedChord? _buildFamilyAwareFallbackChord({
    required SmartStepPlan plan,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? previousChord,
  }) {
    final harmonicFunction = _harmonicFunctionForGeneratedChord(
      plan.finalRomanNumeralId,
      plannedChordKind: plan.plannedChordKind,
      appliedType: plan.appliedType,
    );
    final comparison = SmartGeneratorHelper.compareVoiceLeadingCandidates(
      random: _random,
      previousChord: previousChord,
      allowV7sus4: _settings.allowV7sus4,
      allowTensions: _settings.allowTensions,
      selectedTensionOptions: _settings.selectedTensionOptions,
      inversionSettings: _settings.inversionSettings,
      debugChordStyle: _settings.chordSymbolStyle,
      candidates: [
        for (final roman in SmartGeneratorHelper.prioritizedFallbackRomans(
          keyMode: plan.finalKeyCenter.mode,
          finalRomanNumeralId: plan.finalRomanNumeralId,
          harmonicFunction: harmonicFunction,
          patternTag: plan.patternTag,
        ))
          SmartRenderCandidate(
            keyCenter: plan.finalKeyCenter,
            romanNumeralId: roman,
            plannedChordKind: roman == plan.finalRomanNumeralId
                ? plan.plannedChordKind
                : PlannedChordKind.resolvedRoman,
            renderQualityOverride: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.renderQualityOverride
                : null,
            patternTag: plan.patternTag,
            dominantContext: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.dominantContext
                : null,
            dominantIntent: roman == plan.finalRomanNumeralId
                ? plan.renderingPlan.dominantIntent
                : null,
            smartDebug: plan.debug.withDecision(
              'excluded-fallback-hierarchy',
              nextBlockedReason: SmartBlockedReason.excludedFallback,
              nextFallbackOccurred: true,
            ),
            wasExcludedFallback: true,
          ),
      ],
    );
    for (final candidate in comparison.rankedCandidates) {
      if (!_isExcludedCandidate(candidate.chord, exclusionContext)) {
        return candidate.chord;
      }
    }
    return null;
  }

  GeneratedChord _generateSmartChord({
    required List<KeyCenter> keyCenters,
    required ChordExclusionContext exclusionContext,
    GeneratedChord? current,
  }) {
    if (current?.keyName == null ||
        current?.romanNumeralId == null ||
        !keyCenters.contains(current!.keyCenter)) {
      final activeKeys = {
        for (final center in keyCenters) center.tonicName,
      }.toList(growable: false);
      final initialPlan = SmartGeneratorHelper.planInitialStep(
        random: _random,
        request: SmartStartRequest(
          activeKeys: activeKeys,
          selectedKeyCenters: keyCenters,
          secondaryDominantEnabled: _settings.secondaryDominantEnabled,
          substituteDominantEnabled: _settings.substituteDominantEnabled,
          modalInterchangeEnabled: _settings.modalInterchangeEnabled,
          modulationIntensity: _settings.modulationIntensity,
          jazzPreset: _settings.jazzPreset,
          sourceProfile: _settings.sourceProfile,
          smartDiagnosticsEnabled: _settings.smartDiagnosticsEnabled,
        ),
      );
      _plannedSmartChordQueue = initialPlan.remainingQueuedChords;
      final seededChord = _buildGeneratedChord(
        initialPlan.finalKey,
        initialPlan.finalRomanNumeralId,
        keyCenter: initialPlan.finalKeyCenter,
        plannedChordKind: initialPlan.plannedChordKind,
        renderQualityOverride: initialPlan.renderingPlan.renderQualityOverride,
        patternTag: initialPlan.patternTag,
        appliedType: initialPlan.appliedType,
        resolutionTargetRomanId: initialPlan.resolutionTargetRomanId,
        dominantContext: initialPlan.renderingPlan.dominantContext,
        dominantIntent: initialPlan.renderingPlan.dominantIntent,
        suppressTensions: initialPlan.renderingPlan.suppressTensions,
        smartDebug: initialPlan.debug,
        exclusionContext: exclusionContext,
      );
      if (!_isExcludedCandidate(seededChord, exclusionContext)) {
        return _emitSmartDebug(seededChord);
      }
      final initialFallback = _buildFamilyAwareFallbackChord(
        plan: initialPlan,
        exclusionContext: exclusionContext,
        previousChord: current,
      );
      if (initialFallback != null) {
        return _emitSmartDebug(initialFallback);
      }
      return _emitSmartDebug(
        _attachSmartDebug(
          _generateRandomKeyModeChord(
            keyCenters: keyCenters,
            exclusionContext: exclusionContext,
          ),
          initialPlan.debug.withDecision(
            'excluded-fallback',
            nextBlockedReason: SmartBlockedReason.excludedFallback,
            nextFallbackOccurred: true,
          ),
          wasExcludedFallback: true,
        ),
      );
    }

    final currentRomanNumeralId = current.romanNumeralId!;
    final currentResolutionRomanId =
        current.resolutionTargetRomanId ?? current.resolutionRomanNumeralId;
    final activeKeys = {
      for (final center in keyCenters) center.tonicName,
    }.toList(growable: false);

    final plan = SmartGeneratorHelper.planNextStep(
      random: _random,
      request: SmartStepRequest(
        stepIndex:
            ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1,
        activeKeys: activeKeys,
        selectedKeyCenters: keyCenters,
        currentKeyCenter:
            current.keyCenter ?? MusicTheory.keyCenterFor(current.keyName!),
        currentRomanNumeralId: currentRomanNumeralId,
        currentResolutionRomanNumeralId: currentResolutionRomanId,
        currentHarmonicFunction: current.harmonicFunction,
        secondaryDominantEnabled: _settings.secondaryDominantEnabled,
        substituteDominantEnabled: _settings.substituteDominantEnabled,
        modalInterchangeEnabled: _settings.modalInterchangeEnabled,
        modulationIntensity: _settings.modulationIntensity,
        jazzPreset: _settings.jazzPreset,
        sourceProfile: _settings.sourceProfile,
        smartDiagnosticsEnabled: _settings.smartDiagnosticsEnabled,
        previousRomanNumeralId: _previousChord?.romanNumeralId,
        previousHarmonicFunction: _previousChord?.harmonicFunction,
        previousWasAppliedDominant: _previousChord?.isAppliedDominant ?? false,
        currentPatternTag: current.patternTag,
        plannedQueue: _plannedSmartChordQueue,
        currentRenderedNonDiatonic: current.isRenderedNonDiatonic,
        currentTrace: current.smartDebug as SmartDecisionTrace?,
        phraseContext: SmartPhraseContext.rollingForm(
          ((current.smartDebug as SmartDecisionTrace?)?.stepIndex ?? 0) + 1,
        ),
      ),
    );
    _plannedSmartChordQueue = plan.remainingQueuedChords;

    final generatedChord = _buildGeneratedChord(
      plan.finalKey,
      plan.finalRomanNumeralId,
      keyCenter: plan.finalKeyCenter,
      plannedChordKind: plan.plannedChordKind,
      renderQualityOverride: plan.renderingPlan.renderQualityOverride,
      patternTag: plan.patternTag,
      appliedType: plan.appliedType,
      resolutionTargetRomanId: plan.resolutionTargetRomanId,
      dominantContext: plan.renderingPlan.dominantContext,
      dominantIntent: plan.renderingPlan.dominantIntent,
      suppressTensions: plan.renderingPlan.suppressTensions,
      smartDebug: plan.debug,
      exclusionContext: exclusionContext,
      previousChord: current,
    );
    if (!_isExcludedCandidate(generatedChord, exclusionContext)) {
      return _emitSmartDebug(generatedChord);
    }

    final familyAwareFallback = _buildFamilyAwareFallbackChord(
      plan: plan,
      exclusionContext: exclusionContext,
      previousChord: current,
    );
    if (familyAwareFallback != null) {
      return _emitSmartDebug(familyAwareFallback);
    }

    if (plan.patternTag != null) {
      _plannedSmartChordQueue = const <QueuedSmartChord>[];
    }
    final fallbackChord = _generateRandomDiatonicChord(
      keyCenters: keyCenters,
      exclusionContext: exclusionContext,
      preferredKeyCenter: keyCenters.contains(plan.finalKeyCenter)
          ? plan.finalKeyCenter
          : current.keyCenter,
    );
    return _emitSmartDebug(
      _attachSmartDebug(
        fallbackChord,
        plan.debug.withDecision(
          'excluded-fallback',
          nextBlockedReason: SmartBlockedReason.excludedFallback,
          nextFallbackOccurred: true,
        ),
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

  void _playMetronomeIfNeeded() {
    if (!_settings.metronomeEnabled) {
      return;
    }
    final pool = _metronomePool;
    if (!_audioReady || pool == null) {
      return;
    }
    unawaited(_startMetronomePlayback(pool));
  }

  Future<void> _startMetronomePlayback(AudioPool pool) async {
    try {
      await pool.start(volume: _settings.metronomeVolume);
    } catch (_) {}
  }

  void _advanceChordUnawaited() {
    _advanceChord();
  }

  void _handleAutoTickUnawaited() {
    _handleAutoTick();
  }

  void _advanceChord() {
    if (!mounted) {
      return;
    }
    setState(() {
      _promoteChordQueue();
      _currentBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
    });
    _playMetronomeIfNeeded();
  }

  void _handleAutoTick() {
    if (!mounted) {
      return;
    }
    var shouldAdvanceChord = false;
    setState(() {
      final nextBeat = ((_currentBeat ?? -1) + 1) % _beatsPerBar;
      _currentBeat = nextBeat;
      shouldAdvanceChord = nextBeat == 0;
    });

    _playMetronomeIfNeeded();

    if (!mounted || !shouldAdvanceChord) {
      return;
    }

    setState(() {
      _promoteChordQueue();
    });
  }

  void _scheduleAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(
      _beatInterval(),
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
    _applySettings(_settings.copyWith(bpm: next), syncBpmText: true);
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
    _applySettings(_settings.copyWith(bpm: normalized), syncBpmText: true);
    _rescheduleAutoTimer();
  }

  Widget _buildBeatCircle(int index) {
    final isActive = _currentBeat == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final animationDuration = _beatIndicatorAnimationDuration();
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.outlineVariant;

    return AnimatedScale(
      scale: isActive ? 1.18 : 1,
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        key: ValueKey('beat-circle-$index'),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.95)
                : inactiveColor.withValues(alpha: 0.85),
          ),
          gradient: RadialGradient(
            radius: isActive ? 0.95 : 0.8,
            colors: isActive
                ? [
                    activeColor.withValues(alpha: 0.98),
                    activeColor.withValues(alpha: 0.74),
                  ]
                : [
                    inactiveColor.withValues(alpha: 0.82),
                    inactiveColor.withValues(alpha: 0.42),
                  ],
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.34),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
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

  Widget _buildSettingsDrawer() {
    return PracticeSettingsDrawer(
      settings: _settings,
      onClose: () => Navigator.of(context).maybePop(),
      onApplySettings: (nextSettings, {bool reseed = false}) {
        _applySettings(nextSettings, reseed: reseed);
      },
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _bpmController.dispose();
    final metronomePool = _metronomePool;
    _metronomePool = null;
    if (metronomePool != null) {
      unawaited(metronomePool.dispose());
    }
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
          endDrawer: _buildSettingsDrawer(),
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
                                            key: const ValueKey(
                                              'current-status-label',
                                            ),
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
                                if (_settings.voicingSuggestionsEnabled &&
                                    _voicingRecommendations != null &&
                                    _voicingRecommendations!
                                        .suggestions
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  VoicingSuggestionsSection(
                                    recommendations: _voicingRecommendations!,
                                    selectedSignature:
                                        _selectedVoicing?.signature,
                                    showReasons: _settings.showVoicingReasons,
                                    onSelectSuggestion: _handleVoicingSelected,
                                    onToggleLock: _handleVoicingLockToggle,
                                  ),
                                ],
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
