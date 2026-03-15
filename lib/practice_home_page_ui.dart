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

  void _toggleQuickMelodyGeneration(bool selected) {
    _applySettings(_settings.copyWith(melodyGenerationEnabled: selected));
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
                _GeneratorQuickSettingChip(
                  chipKey: const ValueKey('melody-generation-toggle'),
                  label: l10n.melodyGenerationTitle,
                  selected: _settings.melodyGenerationEnabled,
                  onSelected: _toggleQuickMelodyGeneration,
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
    final previousDisplay = _displaySymbolForEvent(_queueState.previousEvent);
    final currentDisplay = _displaySymbolForEvent(_currentChordEvent);
    final nextDisplay = _displaySymbolForEvent(_nextChordEvent);

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
                                            beatCount: _beatsPerBar,
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
                                  performanceMode:
                                      _settings.voicingDisplayMode ==
                                      VoicingDisplayMode.performance,
                                  statusLabel: _currentStatusLabel(l10n),
                                  availableBackSteps: _practiceHistory.length,
                                  onAdvance: _performManualAdvanceChord,
                                  onGoBack: _restorePreviousChord,
                                  controls: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _PreviewControlButton(
                                            buttonKey: const ValueKey(
                                              'practice-play-chord-button',
                                            ),
                                            icon: Icons.volume_up_rounded,
                                            tooltip: l10n.audioPlayChord,
                                            onPressed: _currentChord == null
                                                ? null
                                                : () => _playCurrentChordPreview(
                                                    pattern:
                                                        HarmonyPlaybackPattern
                                                            .block,
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                          _PreviewControlButton(
                                            buttonKey: const ValueKey(
                                              'practice-play-arpeggio-button',
                                            ),
                                            icon:
                                                Icons.multitrack_audio_rounded,
                                            tooltip: l10n.audioPlayArpeggio,
                                            onPressed: _currentChord == null
                                                ? null
                                                : () => _playCurrentChordPreview(
                                                    pattern:
                                                        HarmonyPlaybackPattern
                                                            .arpeggio,
                                                  ),
                                          ),
                                          if (_settings
                                              .melodyGenerationEnabled) ...[
                                            const SizedBox(width: 12),
                                            _PreviewControlButton(
                                              buttonKey: const ValueKey(
                                                'practice-regenerate-melody-button',
                                              ),
                                              icon:
                                                  Icons.auto_fix_high_rounded,
                                              tooltip:
                                                  l10n.regenerateMelody,
                                              onPressed: _regenerateCurrentMelody,
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (_settings.melodyGenerationEnabled) ...[
                                        const SizedBox(height: 10),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            for (final mode
                                                in MelodyPlaybackMode.values)
                                              ChoiceChip(
                                                key: ValueKey(
                                                  'melody-playback-mode-${mode.name}',
                                                ),
                                                label: Text(
                                                  mode.localizedLabel(l10n),
                                                ),
                                                selected:
                                                    _settings
                                                        .melodyPlaybackMode ==
                                                    mode,
                                                onSelected: (selected) {
                                                  if (!selected) {
                                                    return;
                                                  }
                                                  _applySettings(
                                                    _settings.copyWith(
                                                      melodyPlaybackMode: mode,
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                        if (_currentMelodyEvent != null &&
                                            _previewTextForMelodyEvent(
                                              _currentMelodyEvent,
                                            ).isNotEmpty) ...[
                                          const SizedBox(height: 10),
                                          _MelodyPreviewStrip(
                                            currentText:
                                                _previewTextForMelodyEvent(
                                                  _currentMelodyEvent,
                                                ),
                                            nextText:
                                                _previewTextForMelodyEvent(
                                                  _nextMelodyEvent,
                                                ),
                                            currentLabel:
                                                l10n.melodyPreviewCurrent,
                                            nextLabel:
                                                l10n.melodyPreviewNext,
                                          ),
                                        ],
                                      ],
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
                                    displayMode: _settings.voicingDisplayMode,
                                    selectedSignature:
                                        _displayedVoicingSignature(),
                                    showReasons: _settings.showVoicingReasons,
                                    onSelectSuggestion: _handleVoicingSelected,
                                    onToggleLock: _handleVoicingLockToggle,
                                    onPlaySuggestion:
                                        _playVoicingSuggestionPreview,
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

class _MelodyPreviewStrip extends StatelessWidget {
  const _MelodyPreviewStrip({
    required this.currentText,
    required this.nextText,
    required this.currentLabel,
    required this.nextLabel,
  });

  final String currentText;
  final String nextText;
  final String currentLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildColumn(String label, String text) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              text.isEmpty ? '...' : text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            buildColumn(currentLabel, currentText),
            const SizedBox(width: 12),
            buildColumn(nextLabel, nextText),
          ],
        ),
      ),
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
      if (!mounted) {
        return;
      }
      _repeatTimer = Timer.periodic(_repeatInterval, (_) {
        if (!mounted) {
          _stopContinuousAdjust();
          return;
        }
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
    this.performanceMode = false,
    required this.statusLabel,
    required this.availableBackSteps,
    required this.onAdvance,
    required this.onGoBack,
    required this.controls,
  });

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final bool performanceMode;
  final String statusLabel;
  final int availableBackSteps;
  final VoidCallback onAdvance;
  final VoidCallback onGoBack;
  final Widget controls;

  @override
  State<_ChordSwipeSurface> createState() => _ChordSwipeSurfaceState();
}

class _ChordSwipeSurfaceState extends State<_ChordSwipeSurface>
    with TickerProviderStateMixin {
  static const Duration _swipeDuration = Duration(milliseconds: 260);
  static const Duration _momentumSwipeDuration = Duration(milliseconds: 220);
  static const Duration _snapBackDuration = Duration(milliseconds: 190);
  static const Duration _edgeRevealDuration = Duration(milliseconds: 170);

  late final AnimationController _swipeController;
  late final AnimationController _edgeRevealController;
  Animation<double>? _swipeOffsetAnimation;
  VoidCallback? _sequenceCallback;
  _ChordSwipeTransition? _activeTransition;
  _ChordSwipeTransition? _edgeRevealTransition;
  _ChordSwipeTransition? _sequenceDirection;
  var _remainingSequenceSteps = 0;
  var _sequenceUsesMomentum = false;
  var _momentumSequenceCommittedSteps = 0;
  var _momentumSequenceTotalSteps = 0;
  var _momentumSequenceActive = false;
  double _dragOffset = 0;
  double _surfaceWidth = 0;
  late String _displayPreviousLabel;
  late String _displayCurrentLabel;
  late String _displayNextLabel;

  bool get _canGoBack => widget.availableBackSteps > 0;
  double get _effectiveOffset {
    final rawOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
    if (!_momentumSequenceActive || _sequenceDirection == null) {
      return rawOffset;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final committedTravel = width * _momentumSequenceCommittedSteps;
    return rawOffset +
        (_sequenceDirection == _ChordSwipeTransition.advance
            ? committedTravel
            : -committedTravel);
  }

  double get _edgeRevealProgress =>
      _edgeRevealController.isAnimating ? _edgeRevealController.value : 1;
  bool get isTransitioning =>
      _swipeController.isAnimating ||
      _edgeRevealController.isAnimating ||
      _activeTransition != null ||
      _remainingSequenceSteps > 0;

  @override
  void initState() {
    super.initState();
    _displayPreviousLabel = widget.previousLabel;
    _displayCurrentLabel = widget.currentLabel;
    _displayNextLabel = widget.nextLabel;
    _swipeController =
        AnimationController(vsync: this, duration: _swipeDuration)
          ..addListener(_handleSwipeAnimationTick)
          ..addStatusListener((status) {
            if (status != AnimationStatus.completed) {
              return;
            }
            if (_momentumSequenceActive) {
              _finishMomentumSequence();
              return;
            }
            final callback = _sequenceCallback;
            final settledOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
            _swipeOffsetAnimation = null;
            _dragOffset = settledOffset;
            if (callback == null) {
              _dragOffset = 0;
              _activeTransition = null;
              setState(() {});
              return;
            }
            setState(() {});
            callback();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _syncLabelsAfterCommittedTransition();
            });
          });
    _edgeRevealController =
        AnimationController(vsync: this, duration: _edgeRevealDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status != AnimationStatus.completed) {
              return;
            }
            if (!mounted) {
              return;
            }
            setState(() {
              _edgeRevealTransition = null;
            });
            _startNextQueuedStepIfNeeded();
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
    if (_activeTransition != null) {
      return;
    }
    _swipeController.stop();
    _edgeRevealController.stop();
    _swipeOffsetAnimation = null;
    setState(() {
      _activeTransition = null;
      _edgeRevealTransition = null;
      _sequenceDirection = null;
      _sequenceCallback = null;
      _remainingSequenceSteps = 0;
      _sequenceUsesMomentum = false;
      _momentumSequenceCommittedSteps = 0;
      _momentumSequenceTotalSteps = 0;
      _momentumSequenceActive = false;
      _dragOffset = 0;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _edgeRevealController.dispose();
    super.dispose();
  }

  void _animateSwipeTo(
    double target, {
    VoidCallback? onCommitted,
    Duration duration = _swipeDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
    _swipeController.stop();
    _swipeController.duration = duration;
    _sequenceCallback = onCommitted;
    _swipeOffsetAnimation = Tween<double>(
      begin: _effectiveOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _swipeController, curve: curve));
    _swipeController.forward(from: 0);
  }

  void _queueSequence(
    _ChordSwipeTransition direction, {
    required int steps,
    required VoidCallback callback,
    bool usesMomentum = false,
  }) {
    if (steps <= 0 || isTransitioning) {
      return;
    }
    if (usesMomentum) {
      _startMomentumSequence(direction, steps: steps, callback: callback);
      return;
    }
    _sequenceDirection = direction;
    _sequenceCallback = callback;
    _remainingSequenceSteps = steps;
    _sequenceUsesMomentum = usesMomentum;
    _startNextQueuedStepIfNeeded();
  }

  void _handleSwipeAnimationTick() {
    if (_momentumSequenceActive) {
      _consumeMomentumCommits();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Duration _momentumDurationForSteps(int steps) {
    final additionalMilliseconds = (steps - 1).clamp(0, 6) * 110;
    return Duration(
      milliseconds:
          _momentumSwipeDuration.inMilliseconds + additionalMilliseconds,
    );
  }

  void _startMomentumSequence(
    _ChordSwipeTransition direction, {
    required int steps,
    required VoidCallback callback,
  }) {
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final directionSign = direction == _ChordSwipeTransition.advance
        ? -1.0
        : 1.0;
    _sequenceDirection = direction;
    _sequenceCallback = callback;
    _sequenceUsesMomentum = true;
    _momentumSequenceActive = true;
    _momentumSequenceCommittedSteps = 0;
    _momentumSequenceTotalSteps = steps;
    _remainingSequenceSteps = 0;
    _activeTransition = direction;
    _animateSwipeTo(
      directionSign * width * steps,
      duration: _momentumDurationForSteps(steps),
      curve: Curves.easeOutCubic,
    );
    _sequenceCallback = callback;
  }

  void _consumeMomentumCommits() {
    if (!_momentumSequenceActive ||
        _sequenceDirection == null ||
        _sequenceCallback == null) {
      return;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final rawOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
    final direction = _sequenceDirection!;
    final advances = direction == _ChordSwipeTransition.advance;
    while (_momentumSequenceCommittedSteps < _momentumSequenceTotalSteps) {
      final nextBoundary = width * (_momentumSequenceCommittedSteps + 1);
      final crossed = advances
          ? rawOffset <= -nextBoundary
          : rawOffset >= nextBoundary;
      if (!crossed) {
        break;
      }
      _momentumSequenceCommittedSteps += 1;
      _applyMomentumDisplayShift(direction);
      _sequenceCallback!.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_momentumSequenceActive) {
          return;
        }
        setState(() {
          _displayPreviousLabel = widget.previousLabel;
          _displayCurrentLabel = widget.currentLabel;
          _displayNextLabel = widget.nextLabel;
        });
      });
    }
  }

  void _applyMomentumDisplayShift(_ChordSwipeTransition direction) {
    final previousLabel = _displayPreviousLabel;
    final currentLabel = _displayCurrentLabel;
    final nextLabel = _displayNextLabel;
    if (direction == _ChordSwipeTransition.advance) {
      _displayPreviousLabel = currentLabel;
      _displayCurrentLabel = nextLabel;
      _displayNextLabel = '';
      return;
    }
    _displayPreviousLabel = '';
    _displayCurrentLabel = previousLabel;
    _displayNextLabel = currentLabel;
  }

  void _finishMomentumSequence() {
    _swipeOffsetAnimation = null;
    setState(() {
      _activeTransition = null;
      _sequenceCallback = null;
      _sequenceDirection = null;
      _sequenceUsesMomentum = false;
      _momentumSequenceActive = false;
      _momentumSequenceCommittedSteps = 0;
      _momentumSequenceTotalSteps = 0;
      _remainingSequenceSteps = 0;
      _dragOffset = 0;
      _edgeRevealTransition = null;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
    });
  }

  void _startNextQueuedStepIfNeeded() {
    if (!mounted ||
        _remainingSequenceSteps <= 0 ||
        _sequenceDirection == null ||
        _activeTransition != null ||
        _swipeController.isAnimating ||
        _edgeRevealController.isAnimating) {
      return;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final direction = _sequenceDirection!;
    _remainingSequenceSteps -= 1;
    _activeTransition = direction;
    _animateSwipeTo(
      direction == _ChordSwipeTransition.advance ? -width : width,
      onCommitted: _sequenceCallback,
      duration: _sequenceUsesMomentum ? _momentumSwipeDuration : _swipeDuration,
      curve: _sequenceUsesMomentum
          ? Curves.linearToEaseOut
          : Curves.easeOutCubic,
    );
  }

  void _syncLabelsAfterCommittedTransition() {
    final revealTransition = _activeTransition;
    setState(() {
      _activeTransition = null;
      _dragOffset = 0;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
      _edgeRevealTransition = revealTransition;
    });
    if (revealTransition == null) {
      _startNextQueuedStepIfNeeded();
      return;
    }
    _edgeRevealController.forward(from: 0);
  }

  void animateAdvance({
    VoidCallback? onCompleted,
    int steps = 1,
    bool useMomentum = false,
  }) {
    final completion = onCompleted ?? widget.onAdvance;
    if (_surfaceWidth <= 0) {
      for (var index = 0; index < steps; index += 1) {
        completion();
      }
      return;
    }
    _queueSequence(
      _ChordSwipeTransition.advance,
      steps: steps,
      callback: completion,
      usesMomentum: useMomentum || steps > 1,
    );
  }

  void animateGoBack({
    VoidCallback? onCompleted,
    int steps = 1,
    bool useMomentum = false,
  }) {
    if (!_canGoBack) {
      return;
    }
    final completion = onCompleted ?? widget.onGoBack;
    if (_surfaceWidth <= 0) {
      final safeSteps = steps.clamp(0, widget.availableBackSteps);
      for (var index = 0; index < safeSteps; index += 1) {
        completion();
      }
      return;
    }
    _queueSequence(
      _ChordSwipeTransition.goBack,
      steps: steps.clamp(0, widget.availableBackSteps),
      callback: completion,
      usesMomentum: useMomentum || steps > 1,
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isTransitioning) {
      return;
    }
    final maxOffset = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(
        -maxOffset,
        maxOffset,
      );
    });
  }

  int _stepCountForFling(double velocity) {
    final magnitude = velocity.abs();
    var steps = 1;
    if (magnitude >= 2400) {
      steps += 1;
    }
    if (magnitude >= 4200) {
      steps += 1;
    }
    if (magnitude >= 6000) {
      steps += 1;
    }
    return steps;
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    if (isTransitioning) {
      return;
    }
    final velocity = details.primaryVelocity ?? 0;
    final threshold = width * 0.16;
    final targetOffset = _effectiveOffset;
    final projectedOffset =
        targetOffset + (velocity * (_surfaceWidth > 0 ? 0.08 : 0.06));
    final prefersMomentum =
        velocity.abs() >= 900 || projectedOffset.abs() >= width * 0.28;

    if (projectedOffset <= -threshold || velocity <= -720) {
      animateAdvance(
        steps: _stepCountForFling(velocity),
        useMomentum: prefersMomentum,
      );
      return;
    }
    if ((projectedOffset >= threshold || velocity >= 720) && _canGoBack) {
      animateGoBack(
        steps: _stepCountForFling(velocity).clamp(1, widget.availableBackSteps),
        useMomentum: prefersMomentum,
      );
      return;
    }
    _animateSwipeTo(0, duration: _snapBackDuration, curve: Curves.easeOutCubic);
  }

  void _handleDragCancel() {
    if (_swipeController.isAnimating || _effectiveOffset.abs() < 0.001) {
      return;
    }
    _animateSwipeTo(0, duration: _snapBackDuration, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentGlow = theme.colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.1,
    );
    final hasStatusLabel = widget.statusLabel.trim().isNotEmpty;

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
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: (details) => _handleDragEnd(details, width),
            onHorizontalDragCancel: _handleDragCancel,
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
                          if (hasStatusLabel) ...[
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
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          SizedBox(
                            height: widget.performanceMode ? 136 : 154,
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
                                  performanceMode: widget.performanceMode,
                                  progress: progress,
                                  edgeRevealTransition: _edgeRevealTransition,
                                  edgeRevealProgress: _edgeRevealProgress,
                                  onPreviousTap: _canGoBack && !isTransitioning
                                      ? animateGoBack
                                      : null,
                                  onNextTap:
                                      !isTransitioning &&
                                          _displayNextLabel.isNotEmpty
                                      ? animateAdvance
                                      : null,
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

class _ChordTokenSpec {
  const _ChordTokenSpec({
    required this.label,
    required this.role,
    required this.layout,
  });

  final String label;
  final _ChordTokenRole role;
  final _ChordTokenLayout layout;
}

class _ChordMotionStage extends StatelessWidget {
  const _ChordMotionStage({
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.performanceMode,
    required this.progress,
    required this.edgeRevealTransition,
    required this.edgeRevealProgress,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  static const double _leftAnchor = -0.76;
  static const double _rightAnchor = 0.76;
  static const double _offLeftAnchor = -1.22;
  static const double _offRightAnchor = 1.22;
  static const double _sideProminence = 0.26;
  static const double _restSideOpacity = 0.68;

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final bool performanceMode;
  final double progress;
  final _ChordSwipeTransition? edgeRevealTransition;
  final double edgeRevealProgress;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final specs =
            <_ChordTokenSpec>[
              _ChordTokenSpec(
                label: previousLabel,
                role: _ChordTokenRole.previous,
                layout: _layoutForRole(_ChordTokenRole.previous),
              ),
              _ChordTokenSpec(
                label: currentLabel,
                role: _ChordTokenRole.current,
                layout: _layoutForRole(_ChordTokenRole.current),
              ),
              _ChordTokenSpec(
                label: nextLabel,
                role: _ChordTokenRole.next,
                layout: _layoutForRole(_ChordTokenRole.next),
              ),
            ]..sort(
              (left, right) =>
                  left.layout.prominence.compareTo(right.layout.prominence),
            );
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final spec in specs)
              _buildToken(
                context,
                label: spec.label,
                role: spec.role,
                layout: spec.layout,
                width: width,
              ),
          ],
        );
      },
    );
  }

  _ChordTokenLayout _restLayoutForRole(_ChordTokenRole role) {
    return switch (role) {
      _ChordTokenRole.previous => const _ChordTokenLayout(
        alignmentX: _leftAnchor,
        prominence: _sideProminence,
        opacity: _restSideOpacity,
      ),
      _ChordTokenRole.current => const _ChordTokenLayout(
        alignmentX: 0,
        prominence: 1,
        opacity: 1,
      ),
      _ChordTokenRole.next => const _ChordTokenLayout(
        alignmentX: _rightAnchor,
        prominence: _sideProminence,
        opacity: _restSideOpacity,
      ),
    };
  }

  _ChordTokenLayout _lerpLayout(
    _ChordTokenLayout start,
    _ChordTokenLayout end,
    double t,
  ) {
    return _ChordTokenLayout(
      alignmentX: _lerpDouble(start.alignmentX, end.alignmentX, t),
      prominence: _lerpDouble(start.prominence, end.prominence, t),
      opacity: _lerpDouble(start.opacity, end.opacity, t),
    );
  }

  _ChordTokenLayout _applyEdgeReveal(
    _ChordTokenRole role,
    _ChordTokenLayout layout,
  ) {
    if (edgeRevealTransition == null || edgeRevealProgress >= 1) {
      return layout;
    }
    final t = Curves.easeOutCubic.transform(edgeRevealProgress.clamp(0.0, 1.0));
    switch (edgeRevealTransition!) {
      case _ChordSwipeTransition.advance:
        if (role != _ChordTokenRole.next) {
          return layout;
        }
        return _lerpLayout(
          const _ChordTokenLayout(
            alignmentX: _offRightAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          _restLayoutForRole(_ChordTokenRole.next),
          t,
        );
      case _ChordSwipeTransition.goBack:
        if (role != _ChordTokenRole.previous) {
          return layout;
        }
        return _lerpLayout(
          const _ChordTokenLayout(
            alignmentX: _offLeftAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          _restLayoutForRole(_ChordTokenRole.previous),
          t,
        );
    }
  }

  _ChordTokenLayout _layoutForRole(_ChordTokenRole role) {
    final settled = _restLayoutForRole(role);
    if (progress.abs() < 0.0001) {
      return _applyEdgeReveal(role, settled);
    }
    final t = Curves.easeOutCubic.transform(progress.abs().clamp(0.0, 1.0));
    switch (role) {
      case _ChordTokenRole.previous:
        if (progress >= 0) {
          return _lerpLayout(
            settled,
            const _ChordTokenLayout(alignmentX: 0, prominence: 1, opacity: 1),
            t,
          );
        }
        return _lerpLayout(
          settled,
          const _ChordTokenLayout(
            alignmentX: _offLeftAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          t,
        );
      case _ChordTokenRole.current:
        if (progress >= 0) {
          return _lerpLayout(
            _restLayoutForRole(_ChordTokenRole.current),
            const _ChordTokenLayout(
              alignmentX: _rightAnchor,
              prominence: _sideProminence,
              opacity: 0.78,
            ),
            t,
          );
        }
        return _lerpLayout(
          _restLayoutForRole(_ChordTokenRole.current),
          const _ChordTokenLayout(
            alignmentX: _leftAnchor,
            prominence: _sideProminence,
            opacity: 0.78,
          ),
          t,
        );
      case _ChordTokenRole.next:
        if (progress <= 0) {
          return _lerpLayout(
            settled,
            const _ChordTokenLayout(alignmentX: 0, prominence: 1, opacity: 1),
            t,
          );
        }
        return _lerpLayout(
          settled,
          const _ChordTokenLayout(
            alignmentX: _offRightAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          t,
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
    final boxWidth = width * _lerpDouble(0.18, 0.62, emphasis);
    final verticalOffset = _lerpDouble(10, 0, emphasis);
    final onTap = switch (role) {
      _ChordTokenRole.previous => onPreviousTap,
      _ChordTokenRole.next => onNextTap,
      _ChordTokenRole.current => null,
    };
    final tokenKey = switch (role) {
      _ChordTokenRole.previous => const ValueKey('previous-chord-text'),
      _ChordTokenRole.next => const ValueKey('next-chord-text'),
      _ChordTokenRole.current => null,
    };
    final textKey = switch (role) {
      _ChordTokenRole.previous => null,
      _ChordTokenRole.next => null,
      _ChordTokenRole.current => const ValueKey('current-chord-text'),
    };
    final textStyle = TextStyle.lerp(
      performanceMode
          ? theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              height: 1,
            )
          : theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1,
            ),
      performanceMode
          ? theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.9,
              height: 1,
            )
          : theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.6,
              height: 1,
            ),
      emphasis,
    )?.copyWith(color: Color.lerp(sideColor, currentColor, emphasis));

    return Align(
      alignment: Alignment(layout.alignmentX, 0),
      child: Opacity(
        opacity: label.isEmpty ? 0 : layout.opacity,
        child: Transform.translate(
          offset: Offset(0, verticalOffset),
          child: SizedBox(
            width: boxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: MouseRegion(
                cursor: onTap == null || label.isEmpty
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: GestureDetector(
                  key: tokenKey,
                  behavior: HitTestBehavior.opaque,
                  onTap: label.isEmpty || onTap == null
                      ? null
                      : () {
                          onTap();
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Text(
                      key: textKey,
                      label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                ),
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
