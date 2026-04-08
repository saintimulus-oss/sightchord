part of 'practice_home_page.dart';

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

  void _applyQuickComplexityMode(SettingsComplexityMode mode) {
    if (_settings.settingsComplexityMode == mode) {
      return;
    }
    final previousSettings = _settings;
    _applySettings(
      PracticeSettingsFactory.applyComplexityModeMelodyPreset(_settings, mode),
      reseed: true,
    );
    _showComplexityUndoSnackBar(previousSettings, mode);
  }

  void _showUndoSnackBar({
    required String message,
    required VoidCallback onUndo,
  }) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            key: const ValueKey('practice-undo-snackbar-action'),
            label: AppLocalizations.of(context)!.undoLabel,
            onPressed: onUndo,
          ),
        ),
      );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _showComplexityUndoSnackBar(
    PracticeSettings previousSettings,
    SettingsComplexityMode mode,
  ) {
    final l10n = AppLocalizations.of(context)!;
    _showUndoSnackBar(
      message:
          '${l10n.setupAssistantCurrentMode}: ${mode.localizedLabel(l10n)}',
      onUndo: () {
        _applySettings(
          previousSettings,
          reseed: true,
          syncBpmText: previousSettings.bpm != _settings.bpm,
        );
      },
    );
  }

  void _showResetUndoSnackBar(_PracticeResetSnapshot snapshot) {
    final l10n = AppLocalizations.of(context)!;
    _showUndoSnackBar(
      message: l10n.resetGeneratedChords,
      onUndo: () {
        _restoreResetSnapshot(snapshot);
      },
    );
  }

  String _favoriteStartsTitle(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartsTitle;
  }

  String _favoriteStartSlotTitle(BuildContext context, int index) {
    return AppLocalizations.of(context)!.favoriteStartSlotTitle(index + 1);
  }

  String _favoriteStartLabel(FavoriteStartPreset preset) {
    return preset.displayLabel;
  }

  String _favoriteStartEmptyMessage(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartEmptyMessage;
  }

  String _favoriteStartSaveLabel(
    BuildContext context, {
    required bool hasPreset,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return hasPreset ? l10n.favoriteStartUpdateLabel : l10n.favoriteStartSaveLabel;
  }

  String _favoriteStartApplyLabel(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartApplyLabel;
  }

  String _favoriteStartRenameLabel(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartRenameLabel;
  }

  String _favoriteStartClearLabel(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartClearLabel;
  }

  String _favoriteStartSavedMessage(BuildContext context, int index) {
    return AppLocalizations.of(context)!.favoriteStartSavedMessage(index + 1);
  }

  String _favoriteStartAppliedMessage(BuildContext context, int index) {
    return AppLocalizations.of(context)!.favoriteStartAppliedMessage(index + 1);
  }

  String _favoriteStartClearedMessage(BuildContext context, int index) {
    return AppLocalizations.of(context)!.favoriteStartClearedMessage(index + 1);
  }

  String _favoriteStartRenamedMessage(
    BuildContext context,
    int index,
    FavoriteStartPreset preset,
  ) {
    return AppLocalizations.of(context)!
        .favoriteStartRenamedMessage(index + 1, preset.displayLabel);
  }

  String _favoriteStartRenameDialogTitle(BuildContext context, int index) {
    return AppLocalizations.of(context)!.favoriteStartRenameDialogTitle(index + 1);
  }

  String _favoriteStartRenameDialogHelper(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartRenameDialogHelper;
  }

  String _favoriteStartRenameFieldHint(
    BuildContext context,
    FavoriteStartPreset preset,
  ) {
    return preset.suggestedLabel;
  }

  String _favoriteStartRenameConfirmLabel(BuildContext context) {
    return AppLocalizations.of(context)!.favoriteStartRenameConfirmLabel;
  }

  String _favoriteStartSummary(
    AppLocalizations l10n,
    FavoriteStartPreset preset,
  ) {
    final resolved = preset.applyTo(_settings);
    final orderedKeyCenters = <KeyCenter>[
      for (final mode in KeyMode.values)
        for (final center in MusicTheory.orderedKeyCentersForMode(mode))
          if (resolved.activeKeyCenters.contains(center)) center,
    ];
    final keyLabel = orderedKeyCenters.isEmpty
        ? l10n.allKeysTag
        : orderedKeyCenters
              .take(2)
              .map(
                (center) => MusicNotationFormatter.formatKeyCenterLabel(
                  center: center,
                  labelStyle: KeyCenterLabelStyle.modeText,
                  preferences: resolved.notationPreferences,
                  l10n: l10n,
                  trailingColon: false,
                ),
              )
              .join(' | ');
    final melodySummary = kEnableMelodyGenerationEntryPoints
        ? !resolved.melodyGenerationEnabled
              ? l10n.melodyQuickPresetCompactOffLabel
              : PracticeSettingsFactory.quickMelodyPresetForSettings(
                  resolved,
                ).compactLocalizedLabel(l10n)
        : null;
    return '${resolved.settingsComplexityMode.localizedLabel(l10n)} | '
        '$keyLabel'
        '${melodySummary == null ? '' : ' | $melodySummary'}'
        ' | ${resolved.bpm} ${l10n.bpmLabel}';
  }

  Future<void> _saveCurrentFavoriteStartToSlot(int index) async {
    final previousPreset = _favoriteStartSlots.slotAt(index);
    await _replaceFavoriteStartSlot(
      index,
      FavoriteStartPreset.fromSettings(
        _settings,
        customLabel: previousPreset?.customLabel,
      ),
    );
    if (!mounted) {
      return;
    }
    _showUndoSnackBar(
      message: _favoriteStartSavedMessage(context, index),
      onUndo: () {
        unawaited(_replaceFavoriteStartSlot(index, previousPreset));
      },
    );
  }

  Future<void> _clearFavoriteStartSlot(int index) async {
    final previousPreset = _favoriteStartSlots.slotAt(index);
    if (previousPreset == null) {
      return;
    }
    await _replaceFavoriteStartSlot(index, null);
    if (!mounted) {
      return;
    }
    _showUndoSnackBar(
      message: _favoriteStartClearedMessage(context, index),
      onUndo: () {
        unawaited(_replaceFavoriteStartSlot(index, previousPreset));
      },
    );
  }

  void _applyFavoriteStartPreset(int index, FavoriteStartPreset preset) {
    final previousSettings = _settings;
    final nextSettings = preset.applyTo(_settings);
    _applySettings(
      nextSettings,
      reseed: true,
      syncBpmText: previousSettings.bpm != nextSettings.bpm,
    );
    _showUndoSnackBar(
      message: _favoriteStartAppliedMessage(context, index),
      onUndo: () {
        _applySettings(
          previousSettings,
          reseed: true,
          syncBpmText: previousSettings.bpm != nextSettings.bpm,
        );
      },
    );
  }

  Future<void> _renameFavoriteStartSlot(int index) async {
    final preset = _favoriteStartSlots.slotAt(index);
    if (preset == null || !mounted) {
      return;
    }
    var draftLabel = preset.customLabel ?? '';
    final nextLabel = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final materialLocalizations = MaterialLocalizations.of(dialogContext);
        return AlertDialog(
          title: Text(_favoriteStartRenameDialogTitle(context, index)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _favoriteStartRenameDialogHelper(context),
                  style: Theme.of(dialogContext).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: ValueKey('favorite-start-slot-$index-name-field'),
                  initialValue: draftLabel,
                  autofocus: true,
                  maxLength: 28,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => draftLabel = value,
                  onFieldSubmitted: (value) =>
                      Navigator.of(dialogContext).pop(value),
                  decoration: InputDecoration(
                    hintText: _favoriteStartRenameFieldHint(context, preset),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              key: ValueKey('favorite-start-slot-$index-name-cancel-button'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(materialLocalizations.cancelButtonLabel),
            ),
            FilledButton(
              key: ValueKey('favorite-start-slot-$index-name-save-button'),
              onPressed: () => Navigator.of(dialogContext).pop(draftLabel),
              child: Text(_favoriteStartRenameConfirmLabel(context)),
            ),
          ],
        );
      },
    );
    if (nextLabel == null) {
      return;
    }
    final previousPreset = preset;
    final renamedPreset = preset.withCustomLabel(nextLabel);
    if (previousPreset.customLabel == renamedPreset.customLabel) {
      return;
    }
    await _replaceFavoriteStartSlot(index, renamedPreset);
    if (!mounted) {
      return;
    }
    _showUndoSnackBar(
      message: _favoriteStartRenamedMessage(context, index, renamedPreset),
      onUndo: () {
        unawaited(_replaceFavoriteStartSlot(index, previousPreset));
      },
    );
  }

  Future<void> _openFavoriteStartsSheet() async {
    await _restoreFavoriteStartSlots();
    if (!mounted) {
      return;
    }
    final materialLocalizations = MaterialLocalizations.of(context);
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        final colorScheme = theme.colorScheme;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _favoriteStartsTitle(context),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('favorite-starts-close-button'),
                      onPressed: () => Navigator.of(sheetContext).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: materialLocalizations.closeButtonTooltip,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (
                  var index = 0;
                  index < FavoriteStartSlots.slotCount;
                  index++
                )
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == FavoriteStartSlots.slotCount - 1
                          ? 0
                          : 12,
                    ),
                    child: Builder(
                      builder: (_) {
                        final preset = _favoriteStartSlots.slotAt(index);
                        return DecoratedBox(
                          key: ValueKey('favorite-start-slot-$index'),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  preset == null
                                      ? _favoriteStartSlotTitle(context, index)
                                      : _favoriteStartLabel(preset),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (preset != null &&
                                    preset.hasCustomLabel) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    _favoriteStartSlotTitle(context, index),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  preset == null
                                      ? _favoriteStartEmptyMessage(context)
                                      : _favoriteStartSummary(l10n, preset),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilledButton.tonal(
                                      key: ValueKey(
                                        'favorite-start-slot-$index-save-button',
                                      ),
                                      onPressed: () {
                                        Navigator.of(sheetContext).maybePop();
                                        unawaited(
                                          _saveCurrentFavoriteStartToSlot(
                                            index,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        _favoriteStartSaveLabel(
                                          context,
                                          hasPreset: preset != null,
                                        ),
                                      ),
                                    ),
                                    if (preset != null)
                                      OutlinedButton(
                                        key: ValueKey(
                                          'favorite-start-slot-$index-rename-button',
                                        ),
                                        onPressed: () async {
                                          await Navigator.of(
                                            sheetContext,
                                          ).maybePop();
                                          if (!mounted) {
                                            return;
                                          }
                                          unawaited(
                                            _renameFavoriteStartSlot(index),
                                          );
                                        },
                                        child: Text(
                                          _favoriteStartRenameLabel(context),
                                        ),
                                      ),
                                    if (preset != null)
                                      OutlinedButton(
                                        key: ValueKey(
                                          'favorite-start-slot-$index-apply-button',
                                        ),
                                        onPressed: () {
                                          Navigator.of(sheetContext).maybePop();
                                          _applyFavoriteStartPreset(
                                            index,
                                            preset,
                                          );
                                        },
                                        child: Text(
                                          _favoriteStartApplyLabel(context),
                                        ),
                                      ),
                                    if (preset != null)
                                      OutlinedButton(
                                        key: ValueKey(
                                          'favorite-start-slot-$index-clear-button',
                                        ),
                                        onPressed: () {
                                          Navigator.of(sheetContext).maybePop();
                                          unawaited(
                                            _clearFavoriteStartSlot(index),
                                          );
                                        },
                                        child: Text(
                                          _favoriteStartClearLabel(context),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _copyToolsTitle(BuildContext context) {
    return AppLocalizations.of(context)!.copyToolsTitle;
  }

  String _copyCurrentChordLabel(BuildContext context) {
    return AppLocalizations.of(context)!.copyCurrentChordLabel;
  }

  String _copyVisibleLoopLabel(BuildContext context) {
    return AppLocalizations.of(context)!.copyVisibleLoopLabel;
  }

  String _copyMelodyPreviewLabel(BuildContext context) {
    return AppLocalizations.of(context)!.copyMelodyPreviewLabel;
  }

  String _recentCopiesTitle(BuildContext context) {
    return AppLocalizations.of(context)!.recentCopiesTitle;
  }

  String _recentCopyKindLabel(BuildContext context, RecentCopyKind kind) {
    final l10n = AppLocalizations.of(context)!;
    return switch (kind) {
      RecentCopyKind.currentChord => l10n.recentCopyCurrentChordLabel,
      RecentCopyKind.visibleLoop => l10n.recentCopyVisibleLoopLabel,
      RecentCopyKind.melodyPreview => l10n.recentCopyMelodyPreviewLabel,
    };
  }

  IconData _recentCopyKindIcon(RecentCopyKind kind) {
    return switch (kind) {
      RecentCopyKind.currentChord => Icons.music_note_rounded,
      RecentCopyKind.visibleLoop => Icons.linear_scale_rounded,
      RecentCopyKind.melodyPreview => Icons.graphic_eq_rounded,
    };
  }

  String _analyzeVisibleLoopLabel(BuildContext context) {
    return AppLocalizations.of(context)!.analyzeVisibleLoopLabel;
  }

  String _quickMovesTitle(BuildContext context) {
    return AppLocalizations.of(context)!.quickMovesTitle;
  }

  String _nudgeEasierLabel(BuildContext context) {
    return AppLocalizations.of(context)!.nudgeEasierLabel;
  }

  String _nudgeRicherLabel(BuildContext context) {
    return AppLocalizations.of(context)!.nudgeRicherLabel;
  }

  String _nothingToCopyMessage(BuildContext context) {
    return AppLocalizations.of(context)!.nothingToCopyMessage;
  }

  String _noRecentCopiesMessage(BuildContext context) {
    return AppLocalizations.of(context)!.noRecentCopiesMessage;
  }

  String _nothingToAnalyzeMessage(BuildContext context) {
    return AppLocalizations.of(context)!.nothingToAnalyzeMessage;
  }

  String _copiedCurrentChordMessage(BuildContext context) {
    return AppLocalizations.of(context)!.copiedCurrentChordMessage;
  }

  String _copiedVisibleLoopMessage(BuildContext context) {
    return AppLocalizations.of(context)!.copiedVisibleLoopMessage;
  }

  String _copiedMelodyPreviewMessage(BuildContext context) {
    return AppLocalizations.of(context)!.copiedMelodyPreviewMessage;
  }

  String _copiedRecentCopyMessage(BuildContext context) {
    return AppLocalizations.of(context)!.copiedRecentCopyMessage;
  }

  String _nudgedEasierMessage(BuildContext context) {
    return AppLocalizations.of(context)!.nudgedEasierMessage;
  }

  String _nudgedRicherMessage(BuildContext context) {
    return AppLocalizations.of(context)!.nudgedRicherMessage;
  }

  String _alreadyEasyMessage(BuildContext context) {
    return AppLocalizations.of(context)!.alreadyEasierMessage;
  }

  String _alreadyRicherMessage(BuildContext context) {
    return AppLocalizations.of(context)!.alreadyRicherMessage;
  }

  List<String> _visibleChordLoopLabels() {
    return <String>[
      _displaySymbolForEvent(_queueState.previousEvent),
      _displaySymbolForEvent(_currentChordEvent),
      _displaySymbolForEvent(_nextChordEvent),
      _displaySymbolForEvent(_lookAheadChordEvent),
    ].where((label) => label.isNotEmpty).toList(growable: false);
  }

  String _visibleChordLoopCopyText() {
    final labels = _visibleChordLoopLabels();
    return labels.join(' -> ');
  }

  String _visibleChordLoopAnalyzerText() {
    final labels = _visibleChordLoopLabels();
    return labels.join(' | ');
  }

  String _melodyPreviewCopyText(BuildContext context) {
    final currentPreview = _previewTextForMelodyEvent(_currentMelodyEvent);
    final nextPreview = _previewTextForMelodyEvent(_nextMelodyEvent);
    if (currentPreview.isEmpty && nextPreview.isEmpty) {
      return '';
    }
    final l10n = AppLocalizations.of(context)!;
    final currentLabel = l10n.currentChordLabel;
    final nextLabel = l10n.nextChordLabel;
    final lines = <String>[
      if (currentPreview.isNotEmpty) '$currentLabel: $currentPreview',
      if (nextPreview.isNotEmpty) '$nextLabel: $nextPreview',
    ];
    return lines.join('\n');
  }

  Future<void> _copyTextToClipboard(
    String text, {
    required String successMessage,
    RecentCopyKind? rememberAs,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      _showInfoSnackBar(_nothingToCopyMessage(context));
      return;
    }
    await Clipboard.setData(ClipboardData(text: normalized));
    if (rememberAs != null) {
      try {
        await _recentCopyHistoryStore.remember(rememberAs, normalized);
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'chordest',
            context: ErrorDescription('while saving recent copy history'),
          ),
        );
      }
    }
    _showInfoSnackBar(successMessage);
  }

  Future<void> _copyCurrentChordToClipboard() {
    return _copyTextToClipboard(
      _displaySymbolForEvent(_currentChordEvent),
      successMessage: _copiedCurrentChordMessage(context),
      rememberAs: RecentCopyKind.currentChord,
    );
  }

  Future<void> _copyVisibleLoopToClipboard() {
    return _copyTextToClipboard(
      _visibleChordLoopCopyText(),
      successMessage: _copiedVisibleLoopMessage(context),
      rememberAs: RecentCopyKind.visibleLoop,
    );
  }

  Future<void> _copyMelodyPreviewToClipboard() {
    return _copyTextToClipboard(
      _melodyPreviewCopyText(context),
      successMessage: _copiedMelodyPreviewMessage(context),
      rememberAs: RecentCopyKind.melodyPreview,
    );
  }

  Future<void> _copyRecentEntryToClipboard(RecentCopyEntry entry) {
    return _copyTextToClipboard(
      entry.text,
      successMessage: _copiedRecentCopyMessage(context),
      rememberAs: entry.kind,
    );
  }

  Future<void> _openAnalyzerFromVisibleLoop() async {
    final progression = _visibleChordLoopAnalyzerText().trim();
    if (progression.isEmpty) {
      _showInfoSnackBar(_nothingToAnalyzeMessage(context));
      return;
    }
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChordAnalyzerPage(
          controller: widget.controller,
          initialInput: progression,
          autoAnalyzeOnStart: true,
        ),
      ),
    );
  }

  void _applyQuickNudge({
    required PracticeSettings nextSettings,
    required String successMessage,
    required String noChangeMessage,
  }) {
    final resolvedSettings = sanitizePracticeSettingsForAvailability(
      nextSettings,
      premiumUnlocked: _isPremiumUnlocked,
    );
    if (resolvedSettings == _settings) {
      _showInfoSnackBar(noChangeMessage);
      return;
    }
    final previousSettings = _settings;
    _applySettings(resolvedSettings, reseed: true);
    _showUndoSnackBar(
      message: successMessage,
      onUndo: () {
        _applySettings(
          previousSettings,
          reseed: true,
          syncBpmText: previousSettings.bpm != _settings.bpm,
        );
      },
    );
  }

  void _nudgeTowardEasier() {
    _applyQuickNudge(
      nextSettings: PracticeSettingsFactory.nudgeTowardEasier(_settings),
      successMessage: _nudgedEasierMessage(context),
      noChangeMessage: _alreadyEasyMessage(context),
    );
  }

  void _nudgeTowardRicher() {
    _applyQuickNudge(
      nextSettings: PracticeSettingsFactory.nudgeTowardJazzier(_settings),
      successMessage: _nudgedRicherMessage(context),
      noChangeMessage: _alreadyRicherMessage(context),
    );
  }

  Future<void> _openCopyToolsSheet() async {
    if (!mounted) {
      return;
    }
    final theme = Theme.of(context);
    final materialLocalizations = MaterialLocalizations.of(context);
    final currentChord = _displaySymbolForEvent(_currentChordEvent);
    final visibleLoop = _visibleChordLoopCopyText();
    final analyzerLoop = _visibleChordLoopAnalyzerText();
    final melodyPreview = _melodyPreviewCopyText(context);
    final recentCopies = await _recentCopyHistoryStore.load();
    if (!mounted) {
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.66,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _copyToolsTitle(context),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        key: const ValueKey('practice-copy-tools-close-button'),
                        onPressed: () => Navigator.of(sheetContext).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: materialLocalizations.closeButtonTooltip,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      key: const ValueKey('practice-copy-tools-sheet-list'),
                      children: [
                        ListTile(
                          key: const ValueKey(
                            'practice-copy-current-chord-button',
                          ),
                          leading: const Icon(Icons.music_note_rounded),
                          title: Text(_copyCurrentChordLabel(context)),
                          subtitle: Text(
                            currentChord.isEmpty ? '...' : currentChord,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            unawaited(_copyCurrentChordToClipboard());
                          },
                        ),
                        ListTile(
                          key: const ValueKey(
                            'practice-copy-visible-loop-button',
                          ),
                          leading: const Icon(Icons.linear_scale_rounded),
                          title: Text(_copyVisibleLoopLabel(context)),
                          subtitle: Text(
                            visibleLoop.isEmpty ? '...' : visibleLoop,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            unawaited(_copyVisibleLoopToClipboard());
                          },
                        ),
                        ListTile(
                          key: const ValueKey(
                            'practice-open-analyzer-from-copy-tools-button',
                          ),
                          leading: const Icon(Icons.insights_rounded),
                          title: Text(_analyzeVisibleLoopLabel(context)),
                          subtitle: Text(
                            analyzerLoop.isEmpty ? '...' : analyzerLoop,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            Navigator.of(sheetContext).pop();
                            await Future<void>.delayed(Duration.zero);
                            if (!mounted) {
                              return;
                            }
                            await _openAnalyzerFromVisibleLoop();
                          },
                        ),
                        if (_settings.melodyGenerationEnabled)
                          ListTile(
                            key: const ValueKey(
                              'practice-copy-melody-preview-button',
                            ),
                            leading: const Icon(Icons.graphic_eq_rounded),
                            title: Text(_copyMelodyPreviewLabel(context)),
                            subtitle: Text(
                              melodyPreview.isEmpty ? '...' : melodyPreview,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              unawaited(_copyMelodyPreviewToClipboard());
                            },
                          ),
                        if (recentCopies.isNotEmpty) ...[
                          const Divider(height: 28),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Text(
                              _recentCopiesTitle(context),
                              key: const ValueKey(
                                'practice-recent-copy-section',
                              ),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          for (
                            var index = 0;
                            index < recentCopies.items.length;
                            index += 1
                          )
                            ListTile(
                              key: ValueKey(
                                'practice-recent-copy-entry-$index-button',
                              ),
                              leading: Icon(
                                _recentCopyKindIcon(
                                  recentCopies.items[index].kind,
                                ),
                              ),
                              title: Text(
                                _recentCopyKindLabel(
                                  context,
                                  recentCopies.items[index].kind,
                                ),
                              ),
                              subtitle: Text(
                                recentCopies.items[index].text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                final entry = recentCopies.items[index];
                                Navigator.of(sheetContext).pop();
                                unawaited(_copyRecentEntryToClipboard(entry));
                              },
                            ),
                        ] else ...[
                          const Divider(height: 28),
                          ListTile(
                            leading: const Icon(Icons.history_rounded),
                            title: Text(_recentCopiesTitle(context)),
                            subtitle: Text(_noRecentCopiesMessage(context)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openKeyboardShortcutsHelp() async {
    if (!mounted) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final materialLocalizations = MaterialLocalizations.of(context);
    final shortcuts = <({String keyLabel, String actionLabel})>[
      (keyLabel: '?', actionLabel: l10n.keyboardShortcutHelp),
      (keyLabel: 'S', actionLabel: l10n.settings),
      (keyLabel: 'Right / Space', actionLabel: l10n.nextChord),
      (keyLabel: 'Left', actionLabel: materialLocalizations.backButtonTooltip),
      (
        keyLabel: 'Enter',
        actionLabel: '${l10n.startAutoplay} / ${l10n.pauseAutoplay}',
      ),
      (keyLabel: 'P', actionLabel: l10n.audioPlayPrompt),
      (keyLabel: 'Shift+P', actionLabel: l10n.audioPlayArpeggio),
      (keyLabel: 'R', actionLabel: l10n.resetGeneratedChords),
      (
        keyLabel: '1 / 2 / 3',
        actionLabel:
            '${l10n.setupAssistantModeGuided} / '
            '${l10n.setupAssistantModeStandard} / '
            '${l10n.setupAssistantModeAdvanced}',
      ),
      (
        keyLabel: 'Up / Down',
        actionLabel: '${l10n.increaseBpm} / ${l10n.decreaseBpm}',
      ),
      (keyLabel: 'A', actionLabel: _analyzeVisibleLoopLabel(context)),
      (keyLabel: 'C', actionLabel: _copyCurrentChordLabel(context)),
      (keyLabel: 'Shift+C', actionLabel: _copyVisibleLoopLabel(context)),
    ];
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.82,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.keyboardShortcutHelp,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        key: const ValueKey(
                          'practice-shortcuts-help-close-button',
                        ),
                        onPressed: () => Navigator.of(sheetContext).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: materialLocalizations.closeButtonTooltip,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final shortcut in shortcuts) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 112,
                                  child: Text(
                                    shortcut.keyLabel,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    shortcut.actionLabel,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (shortcut != shortcuts.last)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
      melodyGenerationEnabled:
          kEnableMelodyGenerationEntryPoints &&
          _settings.melodyGenerationEnabled,
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
    return RepaintBoundary(
      child: PracticeChordDisplaySection(
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
                if (kEnableMelodyGenerationEntryPoints)
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
            if (kEnableMelodyGenerationEntryPoints &&
                _settings.melodyGenerationEnabled) ...[
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
        const SingleActivator(LogicalKeyboardKey.arrowRight):
            _guardGlobalShortcut(_requestAdvanceChord),
        const SingleActivator(
          LogicalKeyboardKey.arrowLeft,
        ): _guardGlobalShortcut(
          () => _restorePreviousChord(playAutoPreview: true),
        ),
        const SingleActivator(LogicalKeyboardKey.enter): _guardGlobalShortcut(
          _toggleAutoPlay,
        ),
        const SingleActivator(LogicalKeyboardKey.keyP): _guardGlobalShortcut(
          () {
            unawaited(
              _playCurrentChordPreview(pattern: HarmonyPlaybackPattern.block),
            );
          },
        ),
        const SingleActivator(
          LogicalKeyboardKey.keyP,
          shift: true,
        ): _guardGlobalShortcut(() {
          unawaited(
            _playCurrentChordPreview(pattern: HarmonyPlaybackPattern.arpeggio),
          );
        }),
        const SingleActivator(LogicalKeyboardKey.keyR): _guardGlobalShortcut(
          _resetGeneratedChords,
        ),
        const SingleActivator(LogicalKeyboardKey.keyC): _guardGlobalShortcut(
          () {
            unawaited(_copyCurrentChordToClipboard());
          },
        ),
        const SingleActivator(LogicalKeyboardKey.keyA): _guardGlobalShortcut(
          () {
            unawaited(_openAnalyzerFromVisibleLoop());
          },
        ),
        const SingleActivator(
          LogicalKeyboardKey.keyC,
          shift: true,
        ): _guardGlobalShortcut(() {
          unawaited(_copyVisibleLoopToClipboard());
        }),
        const SingleActivator(LogicalKeyboardKey.keyS): _guardGlobalShortcut(
          () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
        const SingleActivator(LogicalKeyboardKey.digit1): _guardGlobalShortcut(
          () => _applyQuickComplexityMode(SettingsComplexityMode.guided),
        ),
        const SingleActivator(LogicalKeyboardKey.digit2): _guardGlobalShortcut(
          () => _applyQuickComplexityMode(SettingsComplexityMode.standard),
        ),
        const SingleActivator(LogicalKeyboardKey.digit3): _guardGlobalShortcut(
          () => _applyQuickComplexityMode(SettingsComplexityMode.advanced),
        ),
        const SingleActivator(LogicalKeyboardKey.arrowUp): _guardGlobalShortcut(
          () => _adjustBpm(5),
        ),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            _guardGlobalShortcut(() => _adjustBpm(-5)),
        const SingleActivator(
          LogicalKeyboardKey.slash,
          shift: true,
        ): _guardGlobalShortcut(() {
          unawaited(_openKeyboardShortcutsHelp());
        }),
        const SingleActivator(LogicalKeyboardKey.keyH): _guardGlobalShortcut(
          () {
            unawaited(_openKeyboardShortcutsHelp());
          },
        ),
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
                key: const ValueKey('practice-open-favorite-starts-button'),
                onPressed: _openFavoriteStartsSheet,
                icon: const Icon(Icons.bookmark_rounded),
                tooltip: _favoriteStartsTitle(context),
              ),
              IconButton(
                key: const ValueKey('practice-open-shortcuts-help-button'),
                onPressed: _openKeyboardShortcutsHelp,
                icon: const Icon(Icons.keyboard_command_key_rounded),
                tooltip: l10n.keyboardShortcutHelp,
              ),
              IconButton(
                key: const ValueKey('practice-open-copy-tools-button'),
                onPressed: _openCopyToolsSheet,
                icon: const Icon(Icons.content_copy_rounded),
                tooltip: _copyToolsTitle(context),
              ),
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

