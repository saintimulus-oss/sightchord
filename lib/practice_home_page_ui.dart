part of 'practice_home_page.dart';

// ignore_for_file: unused_element, unused_element_parameter

extension _PracticeHomePageUi on _MyHomePageState {
  Widget _buildSettingsDrawer() {
    return PracticeSettingsDrawer(
      settings: _settings,
      onClose: () => Navigator.of(context).maybePop(),
      onRunSetupAssistant: _openSetupAssistantFromSettings,
      onOpenStudyHarmony: _studyHarmonyEntryPoint,
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
    return _settings.settingsComplexityMode.localizedLabel(l10n);
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

  bool _usesCompactMobileLayout(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.width < 720;
  }

  List<MetronomeBeatState> _resolvedMetronomeBeatStates() {
    return _settings.metronomePattern.resolve(beatsPerBar: _beatsPerBar);
  }

  MetronomeBeatState _nextMetronomeBeatState(MetronomeBeatState current) {
    return switch (current) {
      MetronomeBeatState.normal => MetronomeBeatState.accent,
      MetronomeBeatState.accent => MetronomeBeatState.mute,
      MetronomeBeatState.mute => MetronomeBeatState.normal,
    };
  }

  void _toggleMetronomePatternEditor() {
    _setMetronomePatternEditing(!_metronomePatternEditing);
  }

  void _cycleMetronomeBeatState(int beatIndex) {
    final nextStates = List<MetronomeBeatState>.from(
      _resolvedMetronomeBeatStates(),
    );
    nextStates[beatIndex] = _nextMetronomeBeatState(nextStates[beatIndex]);
    _applySettings(
      _settings.copyWith(
        metronomePattern: _settings.metronomePattern.copyWith(
          preset: MetronomePatternPreset.custom,
          customBeatStates: nextStates,
        ),
      ),
    );
  }

  void _togglePreviewAutoPlay(HarmonyPlaybackPattern pattern) {
    final isAlreadyPinned =
        _settings.autoPlayChordChanges && _settings.autoPlayPattern == pattern;
    _applySettings(
      _settings.copyWith(
        autoPlayChordChanges: !isAlreadyPinned,
        autoPlayPattern: pattern,
      ),
    );
  }

  Future<void> _openTimeSignaturePicker() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.practiceMeter,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.practiceMeterHelp,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final signature in PracticeTimeSignature.values)
                      ChoiceChip(
                        key: ValueKey(
                          'practice-time-signature-${signature.name}',
                        ),
                        label: Text(signature.localizedLabel(l10n)),
                        selected: _settings.timeSignature == signature,
                        onSelected: (selected) {
                          if (!selected) {
                            return;
                          }
                          Navigator.of(sheetContext).pop();
                          _setMetronomePatternEditing(false);
                          _applySettings(
                            _settings.copyWith(timeSignature: signature),
                            reseed: true,
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openKeyCenterPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    var modalSettings = _settings;

    String compactLabelForTonics(List<String> tonicNames) {
      return tonicNames
          .map(
            (tonicName) => MusicNotationFormatter.formatPitch(
              MusicTheory.displayRootForKey(tonicName),
              preferences: _settings.notationPreferences,
            ),
          )
          .join('/');
    }

    String? selectedTonicNameForOption(KeySelectionOption option) {
      return MusicTheory.selectedTonicNameForOption(
        modalSettings.activeKeyCenters,
        option,
      );
    }

    String? nextTonicNameForCommonOption(KeySelectionOption option) {
      final selectedTonicName = selectedTonicNameForOption(option);
      final currentIndex = option.cycleTonicNames.indexOf(
        selectedTonicName ?? '',
      );
      if (currentIndex == -1) {
        return option.cycleTonicNames.first;
      }
      if (currentIndex + 1 < option.cycleTonicNames.length) {
        return option.cycleTonicNames[currentIndex + 1];
      }
      return null;
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
                      for (final option
                          in MusicTheory.commonKeySelectionOptionsForMode(mode))
                        FilterChip(
                          key: ValueKey(
                            'practice-key-center-'
                            '${option.displayTonicNames.join('-')}-${option.mode.name}',
                          ),
                          label: Text(
                            compactLabelForTonics(option.displayTonicNames),
                          ),
                          selected: selectedTonicNameForOption(option) != null,
                          showCheckmark: false,
                          onSelected: (_) {
                            final nextTonicName = nextTonicNameForCommonOption(
                              option,
                            );
                            final nextCenters =
                                MusicTheory.replaceKeyCenterSelection(
                                  modalSettings.activeKeyCenters,
                                  mode: option.mode,
                                  semitone: option.semitone,
                                  tonicName: nextTonicName,
                                );
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
    if (selected && !_isPremiumUnlocked) {
      unawaited(
        _openPremiumPaywall(highlightedFeature: PremiumFeature.smartGenerator),
      );
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

  MelodyQuickPreset get _currentQuickMelodyPreset =>
      PracticeSettingsFactory.quickMelodyPresetForSettings(_settings);

  MelodyPresetDescriptor? get _currentQuickMelodyDescriptor =>
      !_settings.melodyGenerationEnabled
      ? null
      : PracticeSettingsFactory.describeActiveMelodySettings(_settings);

  String _quickMelodyToggleLabel(
    AppLocalizations l10n, {
    bool compact = false,
  }) {
    final value = !_settings.melodyGenerationEnabled
        ? _melodyPresetOffLabelText(context)
        : _quickMelodyPresetLabel(context, l10n, _currentQuickMelodyPreset);
    if (compact) {
      return !_settings.melodyGenerationEnabled
          ? _compactMelodyOffLabelText(context)
          : value;
    }
    return '${l10n.melodyGenerationTitle}: $value';
  }

  void _applyQuickMelodyPresetSelection(MelodyQuickPreset preset) {
    _applySettings(
      PracticeSettingsFactory.applyQuickMelodyPreset(_settings, preset),
    );
  }

  void _disableQuickMelodyPreset() {
    _applySettings(_settings.copyWith(melodyGenerationEnabled: false));
  }

  void _toggleQuickMelodyGeneration(bool _) {
    if (!_settings.melodyGenerationEnabled) {
      _applyQuickMelodyPresetSelection(MelodyQuickPreset.guideLine);
      return;
    }
    if (_currentQuickMelodyPreset == MelodyQuickPreset.colorLine) {
      _disableQuickMelodyPreset();
      return;
    }
    _applyQuickMelodyPresetSelection(_currentQuickMelodyPreset.next);
  }

  bool _usesKoreanUiCopy(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ko';
  }

  String _melodyPresetOffLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '끔' : 'Off';
  }

  String _compactMelodyOffLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '라인 끔' : 'Line Off';
  }

  String _localizedQuickMelodyPresetLabel(
    BuildContext context,
    AppLocalizations l10n,
    MelodyQuickPreset preset, {
    bool compact = false,
  }) {
    if (_usesKoreanUiCopy(context)) {
      return switch ((preset, compact)) {
        (MelodyQuickPreset.guideLine, true) => '가이드',
        (MelodyQuickPreset.songLine, true) => '송',
        (MelodyQuickPreset.colorLine, true) => '컬러',
        (MelodyQuickPreset.guideLine, false) => '가이드 라인',
        (MelodyQuickPreset.songLine, false) => '송 라인',
        (MelodyQuickPreset.colorLine, false) => '컬러 라인',
      };
    }
    if (compact) {
      return switch (preset) {
        MelodyQuickPreset.guideLine => 'Guide',
        MelodyQuickPreset.songLine => 'Song',
        MelodyQuickPreset.colorLine => 'Color',
      };
    }
    return preset.localizedLabel(l10n);
  }

  String _localizedQuickMelodyShortDescription(
    BuildContext context,
    MelodyQuickPreset preset,
  ) {
    if (_usesKoreanUiCopy(context)) {
      return switch (preset) {
        MelodyQuickPreset.guideLine => '안정적인 가이드 음과 차분한 리듬',
        MelodyQuickPreset.songLine => '따라 부르기 쉬운 선율과 적당한 움직임',
        MelodyQuickPreset.colorLine => '컬러 음을 적극적으로 쓰는 역동적인 라인',
      };
    }
    return preset.shortDescription();
  }

  String _melodyPresetPanelTitle(
    BuildContext context, {
    required bool compact,
  }) {
    if (_usesKoreanUiCopy(context)) {
      return compact ? '라인 프리셋' : '멜로디 프리셋';
    }
    return compact ? 'Line Presets' : 'Melody Presets';
  }

  String _melodyMetricLabel(BuildContext context, String label) {
    if (!_usesKoreanUiCopy(context)) {
      return label;
    }
    return switch (label) {
      'Density' => '밀도',
      'Style' => '스타일',
      'Sync' => '싱코페이션',
      'Color' => '컬러',
      'Novelty' => '새로움',
      'Motif' => '모티프',
      'Chromatic' => '반음계',
      _ => label,
    };
  }

  String _melodyOnOffLabel(BuildContext context, bool value) {
    if (_usesKoreanUiCopy(context)) {
      return value ? '켜짐' : '끔';
    }
    return value ? 'On' : 'Off';
  }

  String _melodyPresetOffLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.melodyQuickPresetOffLabel;
  }

  String _compactMelodyOffLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.melodyQuickPresetCompactOffLabel;
  }

  String _quickMelodyPresetLabel(
    BuildContext context,
    AppLocalizations l10n,
    MelodyQuickPreset preset, {
    bool compact = false,
  }) {
    return compact
        ? preset.compactLocalizedLabel(l10n)
        : preset.localizedLabel(l10n);
  }

  String _quickMelodyPresetShortDescription(
    BuildContext context,
    MelodyQuickPreset preset,
  ) {
    return preset.localizedShortDescription(AppLocalizations.of(context)!);
  }

  String _melodyPresetPanelTitleText(
    BuildContext context, {
    required bool compact,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return compact
        ? l10n.melodyQuickPresetPanelCompactTitle
        : l10n.melodyQuickPresetPanelTitle;
  }

  String _melodyMetricLabelText(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    return switch (label) {
      'Density' => l10n.melodyMetricDensityLabel,
      'Style' => l10n.melodyMetricStyleLabel,
      'Sync' => l10n.melodyMetricSyncLabel,
      'Color' => l10n.melodyMetricColorLabel,
      'Novelty' => l10n.melodyMetricNoveltyLabel,
      'Motif' => l10n.melodyMetricMotifLabel,
      'Chromatic' => l10n.melodyMetricChromaticLabel,
      _ => label,
    };
  }

  String _melodyOnOffText(BuildContext context, bool value) {
    final l10n = AppLocalizations.of(context)!;
    return value ? l10n.enabled : l10n.disabled;
  }

  Widget _buildMelodyPresetSelector(
    BuildContext context, {
    required bool compact,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final presetLabel = _quickMelodyPresetLabel(
      context,
      l10n,
      _currentQuickMelodyPreset,
      compact: compact,
    );
    final shortDescription = _quickMelodyPresetShortDescription(
      context,
      _currentQuickMelodyPreset,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _melodyPresetPanelTitleText(context, compact: compact),
          style: ChordestUiTokens.overlineStyle(theme),
        ),
        const SizedBox(height: 6),
        Text(
          compact ? presetLabel : '$presetLabel · $shortDescription',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Tooltip(
              message: _melodyPresetOffLabelText(context),
              child: ChoiceChip(
                key: const ValueKey('melody-preset-off'),
                label: Text(_melodyPresetOffLabelText(context)),
                selected: !_settings.melodyGenerationEnabled,
                onSelected: (_) => _disableQuickMelodyPreset(),
              ),
            ),
            for (final preset in MelodyQuickPreset.values)
              Tooltip(
                message: _quickMelodyPresetShortDescription(context, preset),
                child: ChoiceChip(
                  key: ValueKey('melody-preset-${preset.name}'),
                  label: Text(
                    _quickMelodyPresetLabel(
                      context,
                      l10n,
                      preset,
                      compact: compact,
                    ),
                  ),
                  selected:
                      _settings.melodyGenerationEnabled &&
                      _currentQuickMelodyPreset == preset,
                  onSelected: (selected) {
                    if (!selected &&
                        _settings.melodyGenerationEnabled &&
                        _currentQuickMelodyPreset == preset) {
                      return;
                    }
                    _applyQuickMelodyPresetSelection(preset);
                  },
                ),
              ),
          ],
        ),
      ],
    );
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

  String _inlineVoicingSuggestionLabel(
    AppLocalizations l10n,
    VoicingSuggestion suggestion,
  ) {
    final labels = <String>{
      for (final kind in suggestion.matchedKinds)
        switch (kind) {
          VoicingSuggestionKind.natural => l10n.voicingSuggestionNatural,
          VoicingSuggestionKind.colorful => l10n.voicingSuggestionColorful,
          VoicingSuggestionKind.easy => l10n.voicingSuggestionEasy,
        },
    };
    return labels.join(' · ');
  }

  Widget _buildInlineVoicingSuggestionsPanel(
    BuildContext context, {
    required bool compact,
  }) {
    final recommendations = _voicingRecommendations;
    if (recommendations == null || recommendations.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectedSignature = _displayedVoicingSignature();
    final suggestions = recommendations.suggestions
        .take(compact ? 2 : 3)
        .toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = compact ? 8.0 : 10.0;
        final cardWidth = compact
            ? constraints.maxWidth
            : (constraints.maxWidth - (spacing * (suggestions.length - 1))) /
                  suggestions.length;

        return Column(
          key: const ValueKey('voicing-suggestions-section'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.voicingSuggestionsTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final suggestion in suggestions)
                  SizedBox(
                    width: cardWidth,
                    child: _InlineVoicingSuggestionCard(
                      suggestion: suggestion,
                      label: _inlineVoicingSuggestionLabel(l10n, suggestion),
                      selected:
                          selectedSignature == suggestion.voicing.signature,
                      compact: compact,
                      notationPreferences: _settings.notationPreferences,
                      onSelect: () => _handleVoicingSelected(suggestion),
                      onPlay: () => _playVoicingSuggestionPreview(suggestion),
                      onToggleLock: () => _handleVoicingLockToggle(suggestion),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGeneratorTransportAndBpmRow(
    BuildContext context, {
    required bool compact,
  }) {
    return PracticeGeneratorControls(
      compact: compact,
      currentChordAvailable: _currentChord != null,
      melodyGenerationEnabled: _settings.melodyGenerationEnabled,
      autoPlayChordChanges: _settings.autoPlayChordChanges,
      autoPlayPattern: _settings.autoPlayPattern,
      currentMelodyPreviewText: _previewTextForMelodyEvent(_currentMelodyEvent),
      nextMelodyPreviewText: _previewTextForMelodyEvent(_nextMelodyEvent),
      melodyPlaybackMode: _settings.melodyPlaybackMode,
      bpmController: _bpmController,
      onPlayChord: () =>
          _playCurrentChordPreview(pattern: HarmonyPlaybackPattern.block),
      onToggleBlockAutoplay: () =>
          _togglePreviewAutoPlay(HarmonyPlaybackPattern.block),
      onPlayArpeggio: () =>
          _playCurrentChordPreview(pattern: HarmonyPlaybackPattern.arpeggio),
      onToggleArpeggioAutoplay: () =>
          _togglePreviewAutoPlay(HarmonyPlaybackPattern.arpeggio),
      onRegenerateMelody: _regenerateCurrentMelody,
      onAdjustBpm: _adjustBpm,
      onBpmChanged: _handleBpmChanged,
      onBpmSubmitted: (_) => _normalizeBpm(),
      onBpmTapOutside: (_) => _normalizeBpm(),
      onSelectMelodyPlaybackMode: (mode) =>
          _applySettings(_settings.copyWith(melodyPlaybackMode: mode)),
    );
  }

  Widget _buildMelodyPlaybackSection(
    BuildContext context, {
    required bool compact,
  }) {
    return PracticeGeneratorControls(
      compact: compact,
      currentChordAvailable: _currentChord != null,
      melodyGenerationEnabled: true,
      autoPlayChordChanges: _settings.autoPlayChordChanges,
      autoPlayPattern: _settings.autoPlayPattern,
      currentMelodyPreviewText: _previewTextForMelodyEvent(_currentMelodyEvent),
      nextMelodyPreviewText: _previewTextForMelodyEvent(_nextMelodyEvent),
      melodyPlaybackMode: _settings.melodyPlaybackMode,
      bpmController: _bpmController,
      onPlayChord: () {},
      onToggleBlockAutoplay: () {},
      onPlayArpeggio: () {},
      onToggleArpeggioAutoplay: () {},
      onRegenerateMelody: _regenerateCurrentMelody,
      onAdjustBpm: _adjustBpm,
      onBpmChanged: _handleBpmChanged,
      onBpmSubmitted: (_) => _normalizeBpm(),
      onBpmTapOutside: (_) => _normalizeBpm(),
      onSelectMelodyPlaybackMode: (mode) =>
          _applySettings(_settings.copyWith(melodyPlaybackMode: mode)),
    );
  }

  Widget _buildMelodyPlaybackModeSelector(
    BuildContext context, {
    required bool compact,
  }) {
    return const SizedBox.shrink();
  }

  Widget _buildTransportStrip(BuildContext context, {required bool compact}) {
    final l10n = AppLocalizations.of(context)!;
    return PracticeTransportStrip(
      compact: compact,
      beatsPerBar: _beatsPerBar,
      currentBeat: _currentBeat,
      beatStates: _resolvedMetronomeBeatStates(),
      metronomePatternEditing: _metronomePatternEditing,
      animationDuration: _beatIndicatorAnimationDuration(),
      meterLabel: _settings.timeSignature.localizedLabel(l10n),
      meterTooltip: l10n.practiceMeter,
      startTooltip: l10n.startAutoplay,
      pauseTooltip: l10n.pauseAutoplay,
      resetTooltip: l10n.resetGeneratedChords,
      bpmLabel: l10n.bpmLabel,
      decreaseBpmTooltip: l10n.decreaseBpm,
      increaseBpmTooltip: l10n.increaseBpm,
      autoRunning: _autoRunning,
      bpmController: _bpmController,
      onPressedBeatRow: _toggleMetronomePatternEditor,
      onPressedBeat: _cycleMetronomeBeatState,
      onTogglePatternEditing: _toggleMetronomePatternEditor,
      onOpenTimeSignaturePicker: _openTimeSignaturePicker,
      onToggleAutoplay: _toggleAutoPlay,
      onResetGeneratedChords: _resetGeneratedChords,
      onAdjustBpm: _adjustBpm,
      onBpmChanged: _handleBpmChanged,
      onBpmSubmitted: (_) => _normalizeBpm(),
      onBpmTapOutside: (_) => _normalizeBpm(),
    );
  }

  Widget _buildTransportStripListenable(
    BuildContext context, {
    required bool compact,
  }) {
    return ListenableBuilder(
      listenable: _practiceTransportController,
      builder: (context, _) {
        return _buildTransportStrip(context, compact: compact);
      },
    );
  }

  Widget _buildChordDisplaySection(
    BuildContext context, {
    required bool compactLayout,
    required String previousDisplay,
    required String currentDisplay,
    required String nextDisplay,
    required String lookAheadDisplay,
    required PracticeChordInsight currentInsight,
    required PracticeChordInsight nextInsight,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return PracticeChordDisplaySection(
      surfaceKey: _chordSwipeSurfaceKey,
      previousLabel: previousDisplay,
      currentLabel: currentDisplay,
      nextLabel: nextDisplay,
      lookAheadLabel: lookAheadDisplay,
      compact: compactLayout,
      performanceMode:
          _settings.voicingDisplayMode == VoicingDisplayMode.performance,
      statusLabel: _currentStatusLabel(l10n),
      currentInsight: currentInsight,
      nextInsight: nextInsight,
      playing: _autoRunning,
      beatsPerBar: _beatsPerBar,
      currentBeat: _currentBeat,
      prioritizeControls: _settings.melodyGenerationEnabled,
      availableBackSteps: _practiceHistory.length,
      onTapAdvance: _performManualAdvanceChord,
      onTapGoBack: () => _restorePreviousChord(playAutoPreview: true),
      onSwipeAdvance: () => _performManualAdvanceChord(playAutoPreview: false),
      onSwipeGoBack: () => _restorePreviousChord(playAutoPreview: false),
      controls: _buildGeneratorTransportAndBpmRow(
        context,
        compact: compactLayout,
      ),
    );
  }

  Widget _buildChordDisplaySectionListenable(
    BuildContext context, {
    required bool compactLayout,
    required String previousDisplay,
    required String currentDisplay,
    required String nextDisplay,
    required String lookAheadDisplay,
    required PracticeChordInsight currentInsight,
    required PracticeChordInsight nextInsight,
  }) {
    return ListenableBuilder(
      listenable: _practiceTransportController,
      builder: (context, _) {
        return _buildChordDisplaySection(
          context,
          compactLayout: compactLayout,
          previousDisplay: previousDisplay,
          currentDisplay: currentDisplay,
          nextDisplay: nextDisplay,
          lookAheadDisplay: lookAheadDisplay,
          currentInsight: currentInsight,
          nextInsight: nextInsight,
        );
      },
    );
  }

  Widget _buildCompactGeneratorQuickSettingsPanel(BuildContext context) {
    return _buildGeneratorQuickSettingsPanel(context);
  }

  Widget _buildGeneratorQuickSettingsPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final compact = _usesCompactMobileLayout(context);
    final showExpandedGeneratorControls = !_usesGuidedSettingsMode;
    final hasVoicingSuggestions =
        _settings.voicingSuggestionsEnabled &&
        _voicingRecommendations != null &&
        _voicingRecommendations!.suggestions.isNotEmpty;

    return DecoratedBox(
      key: const ValueKey('practice-quick-settings-panel'),
      decoration: ChordestUiTokens.panelDecoration(
        theme,
        borderRadius: ChordestUiTokens.radius(compact ? 28 : 30),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 14 : 18,
          compact ? 14 : 18,
          compact ? 14 : 18,
          compact ? 14 : 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compact) ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _settingsComplexityModeLabel(l10n),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openAdvancedSettings,
                    icon: const Icon(Icons.tune_rounded),
                    label: Text(l10n.setupAssistantAdvancedSectionTitle),
                  ),
                ],
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _settingsComplexityModeLabel(l10n),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openAdvancedSettings,
                    icon: const Icon(Icons.tune_rounded),
                    label: Text(l10n.setupAssistantAdvancedSectionTitle),
                  ),
                ],
              ),
            SizedBox(height: compact ? 12 : 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  key: const ValueKey('practice-key-selector-button'),
                  onPressed: _openKeyCenterPicker,
                  icon: const Icon(Icons.library_music_rounded),
                  label: Text(
                    '${l10n.keys}: ${_selectedKeySummary(l10n)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showExpandedGeneratorControls)
                  OutlinedButton.icon(
                    key: const ValueKey('practice-chord-quality-button'),
                    onPressed: _openChordQualityPicker,
                    icon: const Icon(Icons.tune_rounded),
                    label: Text(
                      '${l10n.chordTypeFilters}: '
                      '${_settings.enabledChordQualities.length}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 10 : 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _GeneratorQuickSettingChip(
                  chipKey: const ValueKey('smart-generator-mode-toggle'),
                  label: l10n.smartGeneratorMode,
                  selected: _settings.smartGeneratorMode,
                  locked: !_isPremiumUnlocked,
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
                  label: _quickMelodyToggleLabel(l10n, compact: compact),
                  selected: _settings.melodyGenerationEnabled,
                  onSelected: _toggleQuickMelodyGeneration,
                ),
                if (showExpandedGeneratorControls)
                  _GeneratorQuickSettingChip(
                    chipKey: const ValueKey('non-diatonic-toggle'),
                    label: l10n.nonDiatonic,
                    selected: _hasEnabledNonDiatonicOptions,
                    locked: !_isPremiumUnlocked,
                    onSelected: _usesKeyMode ? _toggleQuickNonDiatonic : null,
                  ),
                if (showExpandedGeneratorControls)
                  _GeneratorQuickSettingChip(
                    chipKey: const ValueKey('allow-tensions-toggle'),
                    label: l10n.allowTensions,
                    selected: _settings.allowTensions,
                    locked: !_isPremiumUnlocked,
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
            if (_settings.melodyGenerationEnabled) ...[
              SizedBox(height: compact ? 12 : 14),
              Container(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.24),
              ),
              SizedBox(height: compact ? 12 : 14),
              _buildMelodyPresetSelector(context, compact: compact),
            ],
            if (hasVoicingSuggestions) ...[
              SizedBox(height: compact ? 12 : 14),
              Container(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.24),
              ),
              SizedBox(height: compact ? 12 : 14),
              _buildInlineVoicingSuggestionsPanel(context, compact: compact),
            ],
            if (!_usesKeyMode) ...[
              SizedBox(height: compact ? 10 : 12),
              Text(
                l10n.keyModeRequiredForSmartGenerator,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
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
    return PracticeSetupPlaceholder(
      complexityLabel: _settingsComplexityModeLabel(l10n),
      title: l10n.setupAssistantPreparingTitle,
      body: l10n.setupAssistantPreparingBody,
    );
  }

  String _firstRunWelcomeTitle(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '첫 코드가 바로 준비됐어요'
        : 'Your first chord is ready';
  }

  String _firstRunWelcomeBody(BuildContext context, String chordLabel) {
    if (_usesKoreanUiCopy(context)) {
      if (chordLabel.isEmpty) {
        return '지금은 쉬운 시작 프로필이 적용돼 있어요. 코드 재생으로 먼저 들어보고, 카드를 좌우로 넘겨 다음 코드를 살펴보세요.';
      }
      return '$chordLabel 코드가 바로 준비됐어요. 먼저 들어보고, 카드를 좌우로 넘겨 다음 코드를 살펴보세요. 더 내 취향에 맞게 시작하고 싶다면 설정 도우미를 열어도 됩니다.';
    }
    if (chordLabel.isEmpty) {
      return 'A beginner-friendly starting profile is already applied. Listen first, then swipe the card to explore the next chord.';
    }
    return '$chordLabel is ready to go. Listen first, then swipe the card to explore what comes next. You can still open the setup assistant to personalize the start.';
  }

  String _firstRunSetupButtonLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '맞춤 설정' : 'Personalize';
  }

  String _firstRunWelcomeTitleText(BuildContext context) {
    return AppLocalizations.of(context)!.practiceFirstRunWelcomeTitle;
  }

  String _firstRunWelcomeBodyText(BuildContext context, String chordLabel) {
    final l10n = AppLocalizations.of(context)!;
    if (chordLabel.isEmpty) {
      return l10n.practiceFirstRunWelcomeBodyEmpty;
    }
    return l10n.practiceFirstRunWelcomeBodyReady(chordLabel);
  }

  String _firstRunSetupButtonLabelText(BuildContext context) {
    return AppLocalizations.of(context)!.practiceFirstRunSetupButton;
  }

  Widget _buildFirstRunWelcomeCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLabel = _displaySymbolForEvent(_currentChordEvent);

    return PracticeFirstRunWelcomeCard(
      title: _firstRunWelcomeTitleText(context),
      body: _firstRunWelcomeBodyText(context, currentLabel),
      closeTooltip: l10n.closeSettings,
      playButtonLabel: l10n.audioPlayChord,
      setupButtonLabel: _firstRunSetupButtonLabelText(context),
      canPlayCurrentChord: _currentChordEvent != null,
      onDismiss: _dismissFirstRunWelcomeCard,
      onPlayCurrentChord: () =>
          _playCurrentChordPreview(pattern: HarmonyPlaybackPattern.block),
      onOpenSetupAssistant: () {
        _dismissFirstRunWelcomeCard();
        unawaited(_runSetupAssistant(mandatory: false));
      },
    );
  }

  Widget _buildPracticeHomePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final previousDisplay = _displaySymbolForEvent(_queueState.previousEvent);
    final currentDisplay = _displaySymbolForEvent(_currentChordEvent);
    final nextDisplay = _displaySymbolForEvent(_nextChordEvent);
    final lookAheadDisplay = _displaySymbolForEvent(_lookAheadChordEvent);
    final compactLayout = _usesCompactMobileLayout(context);
    final currentSectionLabel = l10n.currentChord;
    final nextSectionLabel = l10n.nextChord;
    final currentInsight = _buildChordInsight(
      l10n,
      _currentChordEvent,
      sectionLabel: currentSectionLabel,
    );
    final nextInsight = _buildChordInsight(
      l10n,
      _nextChordEvent,
      sectionLabel: nextSectionLabel,
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
          body: PracticePageBody(
            compactLayout: compactLayout,
            practiceSessionInitialized: _practiceSessionInitialized,
            showFirstRunWelcomeCard: _showFirstRunWelcomeCard,
            transportStrip: _buildTransportStripListenable(
              context,
              compact: compactLayout,
            ),
            firstRunWelcomeCard: _buildFirstRunWelcomeCard(context),
            chordDisplaySection: _buildChordDisplaySectionListenable(
              context,
              compactLayout: compactLayout,
              previousDisplay: previousDisplay,
              currentDisplay: currentDisplay,
              nextDisplay: nextDisplay,
              lookAheadDisplay: lookAheadDisplay,
              currentInsight: currentInsight,
              nextInsight: nextInsight,
            ),
            voicingSuggestionsSection: null,
            quickSettingsPanel: _buildGeneratorQuickSettingsPanel(context),
            setupPlaceholder: _buildSetupPlaceholder(context),
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
    required this.pauseTooltip,
    this.compact = false,
    required this.onPressed,
  });

  final bool running;
  final String startTooltip;
  final String pauseTooltip;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: const ValueKey('practice-autoplay-button'),
      tooltip: running ? pauseTooltip : startTooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: running
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerLow,
        foregroundColor: running
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        minimumSize: Size.square(compact ? 40 : 46),
        side: BorderSide(
          color: running
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      icon: Icon(
        running ? Icons.pause_rounded : Icons.play_arrow_rounded,
        size: compact ? 22 : 24,
      ),
    );
  }
}

class _TransportResetButton extends StatelessWidget {
  const _TransportResetButton({
    required this.tooltip,
    this.compact = false,
    required this.onPressed,
  });

  final String tooltip;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: const ValueKey('practice-reset-generated-chords-button'),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        foregroundColor: theme.colorScheme.onSurface,
        minimumSize: Size.square(compact ? 40 : 46),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      icon: Icon(Icons.stop_rounded, size: compact ? 22 : 24),
    );
  }
}

class _TransportMeterButton extends StatelessWidget {
  const _TransportMeterButton({
    required this.label,
    required this.tooltip,
    this.compact = false,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: OutlinedButton.icon(
        key: const ValueKey('practice-time-signature-button'),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, compact ? 40 : 46),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 8 : 10,
          ),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        icon: Icon(Icons.music_note_rounded, size: compact ? 16 : 20),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PreviewControlButton extends StatelessWidget {
  const _PreviewControlButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.onLongPress,
    this.badgeIcon,
    this.compact = false,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final IconData? badgeIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null || onLongPress != null;
    final size = compact ? 46.0 : 54.0;
    final backgroundColor = enabled
        ? theme.colorScheme.surface
        : theme.colorScheme.surfaceContainerLow;
    final foregroundColor = enabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurfaceVariant;

    return Tooltip(
      message: tooltip,
      child: Material(
        key: buttonKey,
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(compact ? 18 : 20),
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(compact ? 18 : 20),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: compact ? 24 : 28, color: foregroundColor),
                if (badgeIcon != null)
                  Positioned(
                    top: compact ? 5 : 6,
                    right: compact ? 5 : 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(compact ? 2 : 2.5),
                        child: Icon(
                          badgeIcon,
                          size: compact ? 10 : 12,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MelodyPreviewStrip extends StatelessWidget {
  const _MelodyPreviewStrip({
    required this.currentText,
    required this.nextText,
    required this.currentLabel,
    required this.nextLabel,
    this.compact = false,
  });

  final String currentText;
  final String nextText;
  final String currentLabel;
  final String nextLabel;
  final bool compact;

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
              style:
                  (compact
                          ? theme.textTheme.labelSmall
                          : theme.textTheme.labelMedium)
                      ?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
            ),
            const SizedBox(height: 4),
            Text(
              text.isEmpty ? '...' : text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  (compact
                          ? theme.textTheme.bodySmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(fontWeight: FontWeight.w600),
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
        padding: EdgeInsets.fromLTRB(
          compact ? 12 : 14,
          compact ? 10 : 12,
          compact ? 12 : 14,
          compact ? 10 : 12,
        ),
        child: Row(
          children: [
            buildColumn(currentLabel, currentText),
            SizedBox(width: compact ? 10 : 12),
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
    this.compact = false,
    required this.onAdjust,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final TextEditingController bpmController;
  final String bpmLabel;
  final String decreaseTooltip;
  final String increaseTooltip;
  final bool compact;
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
    final fieldSurface = GestureDetector(
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
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 8 : 14,
              vertical: widget.compact ? 4 : 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: widget.compact ? 16 : 18,
                ),
                SizedBox(width: widget.compact ? 8 : 10),
                SizedBox(
                  width: widget.compact ? 60 : 84,
                  child: TextField(
                    key: const ValueKey('bpm-input'),
                    controller: widget.bpmController,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    style:
                        (widget.compact
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.headlineSmall)
                            ?.copyWith(
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
                        vertical: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: widget.compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  fieldSurface,
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _BpmAdjustButton(
                          buttonKey: const ValueKey('bpm-decrease-button'),
                          icon: Icons.remove_rounded,
                          tooltip: widget.decreaseTooltip,
                          compact: true,
                          onPressStart: () => _startContinuousAdjust(-5),
                          onPressEnd: _stopContinuousAdjust,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _BpmAdjustButton(
                          buttonKey: const ValueKey('bpm-increase-button'),
                          icon: Icons.add_rounded,
                          tooltip: widget.increaseTooltip,
                          compact: true,
                          onPressStart: () => _startContinuousAdjust(5),
                          onPressEnd: _stopContinuousAdjust,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BpmAdjustButton(
                    buttonKey: const ValueKey('bpm-decrease-button'),
                    icon: Icons.remove_rounded,
                    tooltip: widget.decreaseTooltip,
                    compact: false,
                    onPressStart: () => _startContinuousAdjust(-5),
                    onPressEnd: _stopContinuousAdjust,
                  ),
                  const SizedBox(width: 10),
                  fieldSurface,
                  const SizedBox(width: 10),
                  _BpmAdjustButton(
                    buttonKey: const ValueKey('bpm-increase-button'),
                    icon: Icons.add_rounded,
                    tooltip: widget.increaseTooltip,
                    compact: false,
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
    this.compact = false,
    required this.onPressStart,
    required this.onPressEnd,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final bool compact;
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
            child: SizedBox(
              width: compact ? 36 : 46,
              height: compact ? 36 : 46,
              child: Icon(icon, size: compact ? 20 : 24),
            ),
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
    this.locked = false,
  });

  final Key chipKey;
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      key: chipKey,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locked) ...[
            const Icon(Icons.lock_outline_rounded, size: 16),
            const SizedBox(width: 6),
          ],
          Flexible(child: Text(label)),
        ],
      ),
      selected: selected,
      showCheckmark: false,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.74),
      selectedColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.78),
      side: BorderSide(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.18)
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.84),
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

class _MelodyMetricChip extends StatelessWidget {
  const _MelodyMetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$label $value',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InlineVoicingSuggestionCard extends StatelessWidget {
  const _InlineVoicingSuggestionCard({
    required this.suggestion,
    required this.label,
    required this.selected,
    required this.compact,
    required this.notationPreferences,
    required this.onSelect,
    required this.onPlay,
    required this.onToggleLock,
  });

  final VoicingSuggestion suggestion;
  final String label;
  final bool selected;
  final bool compact;
  final NotationPreferences notationPreferences;
  final VoidCallback onSelect;
  final VoidCallback onPlay;
  final VoidCallback onToggleLock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final noteSummary = suggestion.voicing.noteNames
        .map(
          (note) => MusicNotationFormatter.formatPitch(
            note,
            preferences: notationPreferences,
          ),
        )
        .join(' ');
    final toneSummary = suggestion.voicing.toneLabels.join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('voicing-suggestion-card-${suggestion.cardKey}'),
        onTap: onSelect,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.44)
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: compact ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: compact ? 2 : 4),
                    SizedBox(
                      width: compact ? 40 : 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: compact ? 20 : 24,
                            height: compact ? 20 : 24,
                            child: IconButton(
                              key: ValueKey(
                                'voicing-play-${suggestion.cardKey}',
                              ),
                              tooltip: l10n.audioPlayChord,
                              onPressed: onPlay,
                              constraints: BoxConstraints.tightFor(
                                width: compact ? 20 : 24,
                                height: compact ? 20 : 24,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              splashRadius: 14,
                              icon: Icon(
                                Icons.volume_up_rounded,
                                size: compact ? 13 : 15,
                              ),
                            ),
                          ),
                          SizedBox(width: compact ? 0 : 2),
                          SizedBox(
                            width: compact ? 20 : 24,
                            height: compact ? 20 : 24,
                            child: IconButton(
                              key: ValueKey(
                                'voicing-lock-${suggestion.cardKey}',
                              ),
                              tooltip: suggestion.locked
                                  ? l10n.voicingUnlockSuggestion
                                  : l10n.voicingLockSuggestion,
                              onPressed: onToggleLock,
                              constraints: BoxConstraints.tightFor(
                                width: compact ? 20 : 24,
                                height: compact ? 20 : 24,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              splashRadius: 14,
                              icon: Icon(
                                suggestion.locked
                                    ? Icons.lock
                                    : Icons.lock_open_rounded,
                                size: compact ? 13 : 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  key: ValueKey('voicing-notes-${suggestion.cardKey}'),
                  width: double.infinity,
                  child: Text(
                    noteSummary,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  key: ValueKey('voicing-tones-${suggestion.cardKey}'),
                  width: double.infinity,
                  child: Text(
                    toneSummary,
                    maxLines: compact ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                ),
                if (selected || suggestion.locked) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (selected)
                        DecoratedBox(
                          key: ValueKey(
                            'voicing-selected-badge-${suggestion.cardKey}',
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            child: Text(
                              l10n.voicingSelected,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (suggestion.locked)
                        DecoratedBox(
                          key: ValueKey(
                            'voicing-locked-badge-${suggestion.cardKey}',
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: colorScheme.primary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            child: Text(
                              l10n.voicingLocked,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactQuickActionTile extends StatelessWidget {
  const _CompactQuickActionTile({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.88),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 17, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactQuickToggleButton extends StatelessWidget {
  const _CompactQuickToggleButton({
    this.buttonKey,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key? buttonKey;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = selected
        ? colorScheme.primaryContainer.withValues(alpha: 0.78)
        : colorScheme.surface.withValues(alpha: 0.72);
    final foregroundColor = selected
        ? colorScheme.primary
        : colorScheme.onSurface;

    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.25)
                    : colorScheme.outlineVariant.withValues(alpha: 0.84),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 136, minWidth: 92),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 17, color: foregroundColor),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foregroundColor,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChordSwipeSurface extends StatefulWidget {
  const _ChordSwipeSurface({
    super.key,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    this.compact = false,
    this.performanceMode = false,
    required this.statusLabel,
    required this.availableBackSteps,
    required this.onTapAdvance,
    required this.onTapGoBack,
    required this.onSwipeAdvance,
    required this.onSwipeGoBack,
    required this.controls,
  });

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final bool compact;
  final bool performanceMode;
  final String statusLabel;
  final int availableBackSteps;
  final VoidCallback onTapAdvance;
  final VoidCallback onTapGoBack;
  final VoidCallback onSwipeAdvance;
  final VoidCallback onSwipeGoBack;
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

  void cancelTransition() {
    _swipeController.stop();
    _edgeRevealController.stop();
    _swipeOffsetAnimation = null;
    if (!mounted) {
      return;
    }
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
    cancelTransition();
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
    final completion = onCompleted ?? widget.onTapAdvance;
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
    final completion = onCompleted ?? widget.onTapGoBack;
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
        onCompleted: widget.onSwipeAdvance,
        steps: _stepCountForFling(velocity),
        useMomentum: prefersMomentum,
      );
      return;
    }
    if ((projectedOffset >= threshold || velocity >= 720) && _canGoBack) {
      animateGoBack(
        onCompleted: widget.onSwipeGoBack,
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
                      padding: EdgeInsets.fromLTRB(
                        widget.compact ? 14 : 18,
                        widget.compact ? 14 : 18,
                        widget.compact ? 14 : 18,
                        widget.compact ? 14 : 18,
                      ),
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
                                    style:
                                        (widget.compact
                                                ? theme.textTheme.labelMedium
                                                : theme.textTheme.labelLarge)
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.w700,
                                            ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: widget.compact ? 12 : 18),
                          ],
                          SizedBox(
                            height: widget.compact
                                ? (widget.performanceMode ? 118 : 132)
                                : (widget.performanceMode ? 136 : 154),
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
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.34,
                                      heightFactor: 1,
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        key: const ValueKey(
                                          'previous-chord-hit-zone',
                                        ),
                                        behavior: HitTestBehavior.translucent,
                                        onTap: _canGoBack && !isTransitioning
                                            ? animateGoBack
                                            : null,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.34,
                                      heightFactor: 1,
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        key: const ValueKey(
                                          'next-chord-hit-zone',
                                        ),
                                        behavior: HitTestBehavior.translucent,
                                        onTap:
                                            !isTransitioning &&
                                                _displayNextLabel.isNotEmpty
                                            ? animateAdvance
                                            : null,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: widget.compact ? 12 : 18),
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
