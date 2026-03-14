part of 'practice_home_page.dart';

extension _PracticeHomePageUi on _MyHomePageState {
  Widget _buildSettingsDrawer() {
    return PracticeSettingsDrawer(
      settings: _settings,
      onClose: () => Navigator.of(context).maybePop(),
      onRunSetupAssistant: _openSetupAssistantFromSettings,
      onOpenStudyHarmony: widget.onOpenStudyHarmony,
      onOpenAdvancedSettings: _openAdvancedSettings,
      onApplySettings: (nextSettings, {bool reseed = false}) {
        _applySettings(nextSettings, reseed: reseed);
      },
    );
  }

  bool get _hasEnabledNonDiatonicOptions =>
      _settings.secondaryDominantEnabled ||
      _settings.substituteDominantEnabled ||
      _settings.modalInterchangeEnabled;

  Future<void> _openSetupAssistantFromSettings() async {
    if (!mounted) {
      return;
    }
    await _runSetupAssistant(mandatory: false);
  }

  String _settingsComplexityModeLabel(AppLocalizations l10n) {
    return switch (_settings.settingsComplexityMode) {
      SettingsComplexityMode.guided => l10n.setupAssistantModeGuided,
      SettingsComplexityMode.standard => l10n.setupAssistantModeStandard,
      SettingsComplexityMode.advanced => l10n.setupAssistantModeAdvanced,
    };
  }

  Future<void> _openAdvancedSettings() async {
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PracticeAdvancedSettingsPage(
          settings: _settings,
          onApplySettings: (nextSettings, {bool reseed = false}) {
            _applySettings(nextSettings, reseed: reseed);
          },
        ),
      ),
    );
  }

  Future<void> _openKeyCenterPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    var modalSettings = _settings;

    String compactLabel(KeyCenter center) {
      return center.mode == KeyMode.major
          ? MusicTheory.displayRootForKey(center.tonicName)
          : MusicTheory.classicalDisplayRootForKey(center.tonicName);
    }

    void applyKeyCenters(
      StateSetter setModalState,
      Set<KeyCenter> nextCenters,
    ) {
      final nextSettings = modalSettings.copyWith(
        activeKeyCenters: nextCenters,
      );
      setModalState(() {
        modalSettings = nextSettings;
      });
      _applySettings(nextSettings, reseed: true);
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildModeSection(KeyMode mode) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode == KeyMode.major ? l10n.modeMajor : l10n.modeMinor,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final center in MusicTheory.orderedKeyCentersForMode(
                        mode,
                      ))
                        FilterChip(
                          key: ValueKey(
                            'practice-key-center-${center.tonicName}-${center.mode.name}',
                          ),
                          label: Text(compactLabel(center)),
                          selected: modalSettings.activeKeyCenters.contains(
                            center,
                          ),
                          showCheckmark: false,
                          onSelected: (selected) {
                            final nextCenters = <KeyCenter>{
                              ...modalSettings.activeKeyCenters,
                            };
                            if (selected) {
                              nextCenters.add(center);
                            } else {
                              nextCenters.remove(center);
                            }
                            applyKeyCenters(setModalState, nextCenters);
                          },
                        ),
                    ],
                  ),
                ],
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  key: const ValueKey('practice-key-center-sheet'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.keys,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      modalSettings.usesKeyMode
                          ? l10n.keysSelectedHelp
                          : l10n.noKeysSelected,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        OutlinedButton.icon(
                          onPressed: modalSettings.activeKeyCenters.isEmpty
                              ? null
                              : () => applyKeyCenters(
                                  setModalState,
                                  const <KeyCenter>{},
                                ),
                          icon: const Icon(Icons.clear_all_rounded),
                          label: Text(l10n.freeModeTag),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildModeSection(KeyMode.major),
                    const SizedBox(height: 18),
                    buildModeSection(KeyMode.minor),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleQuickSmartGenerator(bool selected) {
    if (!_usesKeyMode) {
      return;
    }
    _applySettings(
      _settings.copyWith(smartGeneratorMode: selected),
      reseed: true,
    );
  }

  void _toggleQuickNonDiatonic(bool selected) {
    if (!_usesKeyMode) {
      return;
    }
    _applySettings(
      _settings.copyWith(
        secondaryDominantEnabled: selected,
        substituteDominantEnabled: selected,
        modalInterchangeEnabled: selected,
      ),
      reseed: true,
    );
  }

  List<String> _selectedChordQualityPreviewLabels() {
    return [
      for (final quality in MusicTheory.supportedGeneratorChordQualities)
        if (_settings.enabledChordQualities.contains(quality))
          MusicTheory.generatorQualityLabel(quality),
    ];
  }

  Future<void> _openChordQualityPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    var modalSettings = _settings;

    String groupLabel(GeneratorChordQualityGroup group) {
      return switch (group) {
        GeneratorChordQualityGroup.triads => l10n.chordTypeGroupTriads,
        GeneratorChordQualityGroup.sevenths => l10n.chordTypeGroupSevenths,
        GeneratorChordQualityGroup.sixthsAndAddedTone =>
          l10n.chordTypeGroupSixthsAndAddedTone,
        GeneratorChordQualityGroup.dominantVariants =>
          l10n.chordTypeGroupDominantVariants,
      };
    }

    Future<void> showKeepOneEnabledNotice(BuildContext sheetContext) async {
      ScaffoldMessenger.of(sheetContext)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.chordTypeKeepOneEnabled)));
    }

    void applyChordQualities(
      StateSetter setModalState,
      Set<ChordQuality> nextQualities,
    ) {
      final normalized = <ChordQuality>{
        for (final quality in MusicTheory.supportedGeneratorChordQualities)
          if (nextQualities.contains(quality)) quality,
      };
      final nextAllowV7sus4 = normalized.any(
        MusicTheory.susDominantQualities.contains,
      );
      final nextSettings = modalSettings.copyWith(
        enabledChordQualities: normalized,
        allowV7sus4: nextAllowV7sus4,
      );
      setModalState(() {
        modalSettings = nextSettings;
      });
      _applySettings(nextSettings, reseed: true);
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget buildGroup(GeneratorChordQualityGroup group) {
              final groupQualities = [
                for (final quality
                    in MusicTheory.supportedGeneratorChordQualities)
                  if (MusicTheory.generatorGroupForQuality(quality) == group)
                    quality,
              ];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupLabel(group),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final quality in groupQualities)
                        FilterChip(
                          key: ValueKey('chord-quality-chip-${quality.name}'),
                          label: Text(
                            MusicTheory.generatorQualityLabel(quality),
                          ),
                          selected: modalSettings.enabledChordQualities
                              .contains(quality),
                          showCheckmark: false,
                          onSelected:
                              !modalSettings.usesKeyMode &&
                                  MusicTheory.isKeyModeOnlyGeneratorQuality(
                                    quality,
                                  )
                              ? null
                              : (selected) {
                                  final nextQualities = <ChordQuality>{
                                    ...modalSettings.enabledChordQualities,
                                  };
                                  if (selected) {
                                    nextQualities.add(quality);
                                  } else {
                                    if (nextQualities.length == 1) {
                                      unawaited(
                                        showKeepOneEnabledNotice(sheetContext),
                                      );
                                      return;
                                    }
                                    nextQualities.remove(quality);
                                  }
                                  applyChordQualities(
                                    setModalState,
                                    nextQualities,
                                  );
                                },
                        ),
                    ],
                  ),
                ],
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  key: const ValueKey('practice-chord-quality-sheet'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.chordTypeFilters,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.chordTypeFiltersHelp,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!modalSettings.usesKeyMode) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.chordTypeRequiresKeyMode,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    buildGroup(GeneratorChordQualityGroup.triads),
                    const SizedBox(height: 18),
                    buildGroup(GeneratorChordQualityGroup.sevenths),
                    const SizedBox(height: 18),
                    buildGroup(GeneratorChordQualityGroup.sixthsAndAddedTone),
                    const SizedBox(height: 18),
                    buildGroup(GeneratorChordQualityGroup.dominantVariants),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleQuickTensions(bool selected) {
    if (!_usesKeyMode) {
      return;
    }
    _applySettings(_settings.copyWith(allowTensions: selected), reseed: true);
  }

  void _toggleQuickVoicingSuggestions(bool selected) {
    _applySettings(_settings.copyWith(voicingSuggestionsEnabled: selected));
  }

  void _toggleQuickInversions(bool selected) {
    _applySettings(
      _settings.copyWith(
        inversionSettings: _settings.inversionSettings.copyWith(
          enabled: selected,
        ),
      ),
      reseed: true,
    );
  }

  Widget _buildGeneratorQuickSettingsPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final previewLabels = _selectedKeyPreviewLabels(l10n);
    final chordQualityPreviewLabels = _selectedChordQualityPreviewLabels();
    final showExpandedGeneratorControls = !_usesGuidedSettingsMode;

    return DecoratedBox(
      key: const ValueKey('practice-quick-settings-panel'),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                '${l10n.setupAssistantCurrentMode}: '
                '${_settingsComplexityModeLabel(l10n)}',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const ValueKey('practice-key-selector-button'),
                onPressed: _openKeyCenterPicker,
                icon: const Icon(Icons.library_music_rounded),
                label: Text(
                  '${l10n.keys}: ${_selectedKeySummary(l10n)}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _usesKeyMode ? l10n.keysSelectedHelp : l10n.noKeysSelected,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (previewLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in previewLabels) Chip(label: Text(label)),
                  if (_orderedKeyCenters.length > previewLabels.length)
                    Chip(
                      label: Text(
                        '+${_orderedKeyCenters.length - previewLabels.length}',
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            if (showExpandedGeneratorControls) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const ValueKey('practice-chord-quality-button'),
                  onPressed: _openChordQualityPicker,
                  icon: const Icon(Icons.tune_rounded),
                  label: Text(
                    '${l10n.chordTypeFilters}: '
                    '${l10n.chordTypeFiltersSelection(_settings.enabledChordQualities.length, MusicTheory.supportedGeneratorChordQualities.length)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.chordTypeFiltersHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ] else
              Text(
                l10n.setupAssistantCardBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (showExpandedGeneratorControls &&
                chordQualityPreviewLabels.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final label in chordQualityPreviewLabels.take(6))
                    Chip(label: Text(label)),
                  if (chordQualityPreviewLabels.length > 6)
                    Chip(
                      label: Text('+${chordQualityPreviewLabels.length - 6}'),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _GeneratorQuickSettingChip(
                  chipKey: const ValueKey('smart-generator-mode-toggle'),
                  label: l10n.smartGeneratorMode,
                  selected: _settings.smartGeneratorMode,
                  onSelected: _usesKeyMode ? _toggleQuickSmartGenerator : null,
                ),
                _GeneratorQuickSettingChip(
                  chipKey: const ValueKey('voicing-suggestions-toggle'),
                  label: l10n.voicingSuggestionsTitle,
                  selected: _settings.voicingSuggestionsEnabled,
                  onSelected: _toggleQuickVoicingSuggestions,
                ),
                if (showExpandedGeneratorControls)
                  _GeneratorQuickSettingChip(
                    chipKey: const ValueKey('non-diatonic-toggle'),
                    label: l10n.nonDiatonic,
                    selected: _hasEnabledNonDiatonicOptions,
                    onSelected: _usesKeyMode ? _toggleQuickNonDiatonic : null,
                  ),
                if (showExpandedGeneratorControls)
                  _GeneratorQuickSettingChip(
                    chipKey: const ValueKey('allow-tensions-toggle'),
                    label: l10n.allowTensions,
                    selected: _settings.allowTensions,
                    onSelected: _usesKeyMode ? _toggleQuickTensions : null,
                  ),
                if (showExpandedGeneratorControls)
                  _GeneratorQuickSettingChip(
                    chipKey: const ValueKey('enable-inversions-toggle'),
                    label: l10n.inversions,
                    selected: _settings.inversionSettings.enabled,
                    onSelected: _toggleQuickInversions,
                  ),
              ],
            ),
            if (!_usesKeyMode) ...[
              const SizedBox(height: 10),
              Text(
                l10n.keyModeRequiredForSmartGenerator,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSetupPlaceholder(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DecoratedBox(
      key: const ValueKey('practice-setup-placeholder'),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(_settingsComplexityModeLabel(l10n))),
            const SizedBox(height: 16),
            Text(
              l10n.setupAssistantPreparingTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.setupAssistantPreparingBody,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeHomePage(BuildContext context) {
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
        const SingleActivator(LogicalKeyboardKey.space): _guardGlobalShortcut(
          _requestAdvanceChord,
        ),
        const SingleActivator(LogicalKeyboardKey.enter): _guardGlobalShortcut(
          _toggleAutoPlay,
        ),
        const SingleActivator(LogicalKeyboardKey.arrowUp): _guardGlobalShortcut(
          () => _adjustBpm(5),
        ),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            _guardGlobalShortcut(() => _adjustBpm(-5)),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          endDrawer: _buildSettingsDrawer(),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: const Icon(Icons.settings),
                tooltip: l10n.settings,
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    theme.colorScheme.primary.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06,
                    ),
                    theme.scaffoldBackgroundColor,
                  ),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
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
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_practiceSessionInitialized) ...[
                                Center(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface
                                          .withValues(alpha: 0.82),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          BeatIndicatorRow(
                                            beatCount:
                                                _MyHomePageState._beatsPerBar,
                                            activeBeat: _currentBeat,
                                            animationDuration:
                                                _beatIndicatorAnimationDuration(),
                                          ),
                                          const SizedBox(width: 14),
                                          _TransportToggleButton(
                                            running: _autoRunning,
                                            startTooltip: l10n.startAutoplay,
                                            stopTooltip: l10n.stopAutoplay,
                                            onPressed: _toggleAutoPlay,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _ChordSwipeSurface(
                                  key: _chordSwipeSurfaceKey,
                                  previousLabel: previousDisplay,
                                  currentLabel: currentDisplay,
                                  nextLabel: nextDisplay,
                                  statusLabel: _currentStatusLabel(l10n),
                                  canGoBack: _canRestorePreviousChord,
                                  onAdvance: _performManualAdvanceChord,
                                  onGoBack: _restorePreviousChord,
                                  controls: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _PreviewControlButton(
                                        buttonKey: const ValueKey(
                                          'practice-play-chord-button',
                                        ),
                                        icon: Icons.play_arrow_rounded,
                                        tooltip: l10n.audioPlayChord,
                                        onPressed: _currentChord == null
                                            ? null
                                            : () => _playCurrentChordPreview(
                                                pattern: HarmonyPlaybackPattern
                                                    .block,
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      _PreviewControlButton(
                                        buttonKey: const ValueKey(
                                          'practice-play-arpeggio-button',
                                        ),
                                        icon: Icons.multitrack_audio_rounded,
                                        tooltip: l10n.audioPlayArpeggio,
                                        onPressed: _currentChord == null
                                            ? null
                                            : () => _playCurrentChordPreview(
                                                pattern: HarmonyPlaybackPattern
                                                    .arpeggio,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),
                                _buildGeneratorQuickSettingsPanel(context),
                                if (_settings.voicingSuggestionsEnabled &&
                                    _voicingRecommendations != null &&
                                    _voicingRecommendations!
                                        .suggestions
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 18),
                                  VoicingSuggestionsSection(
                                    recommendations: _voicingRecommendations!,
                                    selectedSignature:
                                        _authoritativeSelectedVoicing()
                                            ?.signature,
                                    showReasons: _settings.showVoicingReasons,
                                    onSelectSuggestion: _handleVoicingSelected,
                                    onToggleLock: _handleVoicingLockToggle,
                                  ),
                                ],
                                const SizedBox(height: 18),
                                Center(
                                  child: _BpmControlCluster(
                                    bpmController: _bpmController,
                                    bpmLabel: l10n.bpmLabel,
                                    decreaseTooltip: l10n.decreaseBpm,
                                    increaseTooltip: l10n.increaseBpm,
                                    onAdjust: _adjustBpm,
                                    onChanged: _handleBpmChanged,
                                    onSubmitted: (_) => _normalizeBpm(),
                                    onTapOutside: (_) => _normalizeBpm(),
                                  ),
                                ),
                              ] else
                                _buildSetupPlaceholder(context),
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
      ),
    );
  }
}

class _TransportToggleButton extends StatelessWidget {
  const _TransportToggleButton({
    required this.running,
    required this.startTooltip,
    required this.stopTooltip,
    required this.onPressed,
  });

  final bool running;
  final String startTooltip;
  final String stopTooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: const ValueKey('practice-autoplay-button'),
      tooltip: running ? stopTooltip : startTooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: running
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerLow,
        foregroundColor: running
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        minimumSize: const Size.square(46),
        side: BorderSide(
          color: running
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      icon: Icon(running ? Icons.stop_rounded : Icons.play_arrow_rounded),
    );
  }
}

class _PreviewControlButton extends StatelessWidget {
  const _PreviewControlButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: buttonKey,
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerLow,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
        minimumSize: const Size.square(54),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      icon: Icon(icon, size: 28),
    );
  }
}

class _BpmControlCluster extends StatefulWidget {
  const _BpmControlCluster({
    required this.bpmController,
    required this.bpmLabel,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    required this.onAdjust,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final TextEditingController bpmController;
  final String bpmLabel;
  final String decreaseTooltip;
  final String increaseTooltip;
  final ValueChanged<int> onAdjust;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TapRegionCallback onTapOutside;

  @override
  State<_BpmControlCluster> createState() => _BpmControlClusterState();
}

class _BpmControlClusterState extends State<_BpmControlCluster> {
  static const Duration _repeatDelay = Duration(milliseconds: 320);
  static const Duration _repeatInterval = Duration(milliseconds: 90);
  static const double _dragStepPixels = 14;

  Timer? _repeatDelayTimer;
  Timer? _repeatTimer;
  double _dragCarry = 0;

  @override
  void dispose() {
    _stopContinuousAdjust();
    super.dispose();
  }

  void _startContinuousAdjust(int delta) {
    _stopContinuousAdjust();
    widget.onAdjust(delta);
    _repeatDelayTimer = Timer(_repeatDelay, () {
      _repeatTimer = Timer.periodic(_repeatInterval, (_) {
        widget.onAdjust(delta);
      });
    });
  }

  void _stopContinuousAdjust() {
    _repeatDelayTimer?.cancel();
    _repeatTimer?.cancel();
    _repeatDelayTimer = null;
    _repeatTimer = null;
  }

  void _handleDragStart(DragStartDetails details) {
    FocusManager.instance.primaryFocus?.unfocus();
    _dragCarry = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragCarry -= details.delta.dy;

    while (_dragCarry >= _dragStepPixels) {
      widget.onAdjust(1);
      _dragCarry -= _dragStepPixels;
    }

    while (_dragCarry <= -_dragStepPixels) {
      widget.onAdjust(-1);
      _dragCarry += _dragStepPixels;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragCarry = 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BpmAdjustButton(
              buttonKey: const ValueKey('bpm-decrease-button'),
              icon: Icons.remove_rounded,
              tooltip: widget.decreaseTooltip,
              onPressStart: () => _startContinuousAdjust(-5),
              onPressEnd: _stopContinuousAdjust,
            ),
            const SizedBox(width: 10),
            GestureDetector(
              key: const ValueKey('bpm-drag-surface'),
              behavior: HitTestBehavior.translucent,
              onVerticalDragStart: _handleDragStart,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              onVerticalDragCancel: () => _dragCarry = 0,
              child: Semantics(
                textField: true,
                label: widget.bpmLabel,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 84,
                          child: TextField(
                            key: const ValueKey('bpm-input'),
                            controller: widget.bpmController,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: false,
                            ),
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                            ),
                            onChanged: widget.onChanged,
                            onSubmitted: widget.onSubmitted,
                            onTapOutside: widget.onTapOutside,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _BpmAdjustButton(
              buttonKey: const ValueKey('bpm-increase-button'),
              icon: Icons.add_rounded,
              tooltip: widget.increaseTooltip,
              onPressStart: () => _startContinuousAdjust(5),
              onPressEnd: _stopContinuousAdjust,
            ),
          ],
        ),
      ),
    );
  }
}

class _BpmAdjustButton extends StatelessWidget {
  const _BpmAdjustButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressStart,
    required this.onPressEnd,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Listener(
          onPointerDown: (_) => onPressStart(),
          onPointerUp: (_) => onPressEnd(),
          onPointerCancel: (_) => onPressEnd(),
          child: DecoratedBox(
            key: buttonKey,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: SizedBox(width: 46, height: 46, child: Icon(icon)),
          ),
        ),
      ),
    );
  }
}

class _GeneratorQuickSettingChip extends StatelessWidget {
  const _GeneratorQuickSettingChip({
    required this.chipKey,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final Key chipKey;
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      key: chipKey,
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      selectedColor: theme.colorScheme.primaryContainer,
      side: BorderSide(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.18)
            : theme.colorScheme.outlineVariant,
      ),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      onSelected: onSelected,
    );
  }
}

class _ChordSwipeSurface extends StatefulWidget {
  const _ChordSwipeSurface({
    super.key,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.statusLabel,
    required this.canGoBack,
    required this.onAdvance,
    required this.onGoBack,
    required this.controls,
  });

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final String statusLabel;
  final bool canGoBack;
  final VoidCallback onAdvance;
  final VoidCallback onGoBack;
  final Widget controls;

  @override
  State<_ChordSwipeSurface> createState() => _ChordSwipeSurfaceState();
}

class _ChordSwipeSurfaceState extends State<_ChordSwipeSurface>
    with SingleTickerProviderStateMixin {
  static const Duration _settleDuration = Duration(milliseconds: 240);
  static const Duration _snapBackDuration = Duration(milliseconds: 180);

  late final AnimationController _controller;
  Animation<double>? _offsetAnimation;
  VoidCallback? _completionCallback;
  _ChordSwipeTransition? _pendingTransition;
  double _dragOffset = 0;
  double _surfaceWidth = 0;
  late String _displayPreviousLabel;
  late String _displayCurrentLabel;
  late String _displayNextLabel;

  double get _effectiveOffset => _offsetAnimation?.value ?? _dragOffset;
  bool get isTransitioning =>
      _controller.isAnimating || _pendingTransition != null;

  @override
  void initState() {
    super.initState();
    _displayPreviousLabel = widget.previousLabel;
    _displayCurrentLabel = widget.currentLabel;
    _displayNextLabel = widget.nextLabel;
    _controller = AnimationController(vsync: this, duration: _settleDuration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        final callback = _completionCallback;
        final settledOffset = _offsetAnimation?.value ?? _dragOffset;
        _completionCallback = null;
        _offsetAnimation = null;
        _dragOffset = settledOffset;
        if (callback == null) {
          _dragOffset = 0;
          setState(() {});
          return;
        }
        setState(() {});
        callback();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _pendingTransition == null) {
            return;
          }
          setState(() {
            _pendingTransition = null;
            _dragOffset = 0;
            _displayPreviousLabel = widget.previousLabel;
            _displayCurrentLabel = widget.currentLabel;
            _displayNextLabel = widget.nextLabel;
          });
        });
      });
  }

  @override
  void didUpdateWidget(covariant _ChordSwipeSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    final labelsChanged =
        oldWidget.previousLabel != widget.previousLabel ||
        oldWidget.currentLabel != widget.currentLabel ||
        oldWidget.nextLabel != widget.nextLabel;
    if (!labelsChanged) {
      return;
    }
    _controller.stop();
    _offsetAnimation = null;
    setState(() {
      _pendingTransition = null;
      _dragOffset = 0;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(
    double target, {
    VoidCallback? onCompleted,
    Duration duration = _settleDuration,
    Curve curve = Curves.easeInOutCubicEmphasized,
  }) {
    _controller.stop();
    _controller.duration = duration;
    _completionCallback = onCompleted;
    _offsetAnimation = Tween<double>(
      begin: _effectiveOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: curve));
    _controller.forward(from: 0);
  }

  void animateAdvance({VoidCallback? onCompleted}) {
    final completion = onCompleted ?? widget.onAdvance;
    if (_surfaceWidth <= 0) {
      completion();
      return;
    }
    if (isTransitioning) {
      return;
    }
    _pendingTransition = _ChordSwipeTransition.advance;
    _animateTo(-_surfaceWidth, onCompleted: completion);
  }

  void animateGoBack({VoidCallback? onCompleted}) {
    if (!widget.canGoBack) {
      return;
    }
    final completion = onCompleted ?? widget.onGoBack;
    if (_surfaceWidth <= 0) {
      completion();
      return;
    }
    if (isTransitioning) {
      return;
    }
    _pendingTransition = _ChordSwipeTransition.goBack;
    _animateTo(_surfaceWidth, onCompleted: completion);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isTransitioning) {
      return;
    }
    final maxOffset = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    setState(() {
      _dragOffset = (_dragOffset + (details.delta.dx * 0.94)).clamp(
        -maxOffset,
        maxOffset,
      );
    });
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    final velocity = details.primaryVelocity ?? 0;
    final threshold = width * 0.16;
    final targetOffset = _effectiveOffset;

    if (targetOffset <= -threshold || velocity <= -720) {
      animateAdvance();
      return;
    }
    if ((targetOffset >= threshold || velocity >= 720) && widget.canGoBack) {
      animateGoBack();
      return;
    }
    _animateTo(0, duration: _snapBackDuration, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentGlow = theme.colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.1,
    );

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          _surfaceWidth = width;
          final progress = width <= 0
              ? 0.0
              : (_effectiveOffset / width).clamp(-1.0, 1.0);
          return GestureDetector(
            key: const ValueKey('chord-swipe-surface'),
            behavior: HitTestBehavior.opaque,
            onTap: widget.onAdvance,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: (details) => _handleDragEnd(details, width),
            onHorizontalDragCancel: () => _animateTo(
              0,
              duration: _snapBackDuration,
              curve: Curves.easeOutCubic,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: accentGlow,
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: Stack(
                  children: [
                    Positioned(
                      top: -54,
                      right: -28,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentGlow,
                          ),
                          child: const SizedBox(width: 150, height: 150),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Column(
                        children: [
                          Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  key: const ValueKey('current-status-label'),
                                  widget.statusLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 154,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerLow
                                          .withValues(alpha: 0.82),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                _ChordMotionStage(
                                  previousLabel: _displayPreviousLabel,
                                  currentLabel: _displayCurrentLabel,
                                  nextLabel: _displayNextLabel,
                                  progress: progress,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          widget.controls,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _ChordSwipeTransition { advance, goBack }

enum _ChordTokenRole { previous, current, next }

class _ChordTokenLayout {
  const _ChordTokenLayout({
    required this.alignmentX,
    required this.prominence,
    required this.opacity,
  });

  final double alignmentX;
  final double prominence;
  final double opacity;
}

class _ChordMotionStage extends StatelessWidget {
  const _ChordMotionStage({
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.progress,
  });

  static const double _leftAnchor = -0.84;
  static const double _rightAnchor = 0.84;
  static const double _offLeftAnchor = -1.2;
  static const double _offRightAnchor = 1.2;

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          fit: StackFit.expand,
          children: [
            _buildToken(
              context,
              label: previousLabel,
              role: _ChordTokenRole.previous,
              layout: _layoutForRole(_ChordTokenRole.previous),
              width: width,
            ),
            _buildToken(
              context,
              label: currentLabel,
              role: _ChordTokenRole.current,
              layout: _layoutForRole(_ChordTokenRole.current),
              width: width,
            ),
            _buildToken(
              context,
              label: nextLabel,
              role: _ChordTokenRole.next,
              layout: _layoutForRole(_ChordTokenRole.next),
              width: width,
            ),
          ],
        );
      },
    );
  }

  _ChordTokenLayout _layoutForRole(_ChordTokenRole role) {
    switch (role) {
      case _ChordTokenRole.previous:
        if (progress >= 0) {
          final t = Curves.easeOutCubic.transform(progress);
          return _ChordTokenLayout(
            alignmentX: _lerpDouble(_leftAnchor, 0, t),
            prominence: t,
            opacity: 1,
          );
        }
        final t = Curves.easeOutCubic.transform(-progress);
        return _ChordTokenLayout(
          alignmentX: _lerpDouble(_leftAnchor, _offLeftAnchor, t),
          prominence: 0,
          opacity: _lerpDouble(1, 0.22, t),
        );
      case _ChordTokenRole.current:
        if (progress >= 0) {
          final t = Curves.easeOutCubic.transform(progress);
          return _ChordTokenLayout(
            alignmentX: _lerpDouble(0, _rightAnchor, t),
            prominence: 1 - t,
            opacity: 1,
          );
        }
        final t = Curves.easeOutCubic.transform(-progress);
        return _ChordTokenLayout(
          alignmentX: _lerpDouble(0, _leftAnchor, t),
          prominence: 1 - t,
          opacity: 1,
        );
      case _ChordTokenRole.next:
        if (progress <= 0) {
          final t = Curves.easeOutCubic.transform(-progress);
          return _ChordTokenLayout(
            alignmentX: _lerpDouble(_rightAnchor, 0, t),
            prominence: t,
            opacity: 1,
          );
        }
        final t = Curves.easeOutCubic.transform(progress);
        return _ChordTokenLayout(
          alignmentX: _lerpDouble(_rightAnchor, _offRightAnchor, t),
          prominence: 0,
          opacity: _lerpDouble(1, 0.22, t),
        );
    }
  }

  Widget _buildToken(
    BuildContext context, {
    required String label,
    required _ChordTokenRole role,
    required _ChordTokenLayout layout,
    required double width,
  }) {
    final theme = Theme.of(context);
    final sideColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.72,
    );
    final currentColor = theme.colorScheme.onSurface;
    final emphasis = layout.prominence.clamp(0.0, 1.0);
    final boxWidth = width * _lerpDouble(0.16, 0.62, emphasis);
    final textStyle = TextStyle.lerp(
      theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1,
      ),
      theme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.6,
        height: 1,
      ),
      emphasis,
    )?.copyWith(color: Color.lerp(sideColor, currentColor, emphasis));

    return IgnorePointer(
      child: Align(
        alignment: Alignment(layout.alignmentX, 0),
        child: Opacity(
          opacity: label.isEmpty ? 0 : layout.opacity,
          child: SizedBox(
            width: boxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                key: role == _ChordTokenRole.current
                    ? const ValueKey('current-chord-text')
                    : null,
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double _lerpDouble(double start, double end, double t) {
  return start + ((end - start) * t);
}
