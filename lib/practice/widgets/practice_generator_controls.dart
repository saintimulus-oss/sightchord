import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../audio/harmony_audio_models.dart';
import '../../l10n/app_localizations.dart';
import '../../settings/practice_settings.dart';
import '../../ui/chordest_ui_tokens.dart';

class PracticeGeneratorControls extends StatelessWidget {
  const PracticeGeneratorControls({
    super.key,
    required this.compact,
    required this.currentChordAvailable,
    required this.melodyGenerationEnabled,
    required this.autoPlayChordChanges,
    required this.autoPlayPattern,
    required this.currentMelodyPreviewText,
    required this.nextMelodyPreviewText,
    required this.melodyPlaybackMode,
    required this.bpmController,
    required this.onPlayChord,
    required this.onToggleBlockAutoplay,
    required this.onPlayArpeggio,
    required this.onToggleArpeggioAutoplay,
    required this.onRegenerateMelody,
    required this.onAdjustBpm,
    required this.onBpmChanged,
    required this.onBpmSubmitted,
    required this.onBpmTapOutside,
    required this.onSelectMelodyPlaybackMode,
  });

  final bool compact;
  final bool currentChordAvailable;
  final bool melodyGenerationEnabled;
  final bool autoPlayChordChanges;
  final HarmonyPlaybackPattern autoPlayPattern;
  final String currentMelodyPreviewText;
  final String nextMelodyPreviewText;
  final MelodyPlaybackMode melodyPlaybackMode;
  final TextEditingController bpmController;
  final VoidCallback onPlayChord;
  final VoidCallback onToggleBlockAutoplay;
  final VoidCallback onPlayArpeggio;
  final VoidCallback onToggleArpeggioAutoplay;
  final VoidCallback onRegenerateMelody;
  final ValueChanged<int> onAdjustBpm;
  final ValueChanged<String> onBpmChanged;
  final ValueChanged<String> onBpmSubmitted;
  final TapRegionCallback onBpmTapOutside;
  final ValueChanged<MelodyPlaybackMode> onSelectMelodyPlaybackMode;

  @override
  Widget build(BuildContext context) {
    final shortViewport = MediaQuery.sizeOf(context).height < 720;
    final dense = compact || shortViewport;
    final embedMelodyPlaybackSelector =
        melodyGenerationEnabled && shortViewport && !compact;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (embedMelodyPlaybackSelector) ...[
          _EmbeddedMelodyPlaybackCard(
            compact: dense,
            melodyPlaybackMode: melodyPlaybackMode,
            onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
          ),
          SizedBox(height: dense ? 10 : 12),
        ],
        _GeneratorControlShell(
          compact: compact,
          dense: dense,
          currentChordAvailable: currentChordAvailable,
          melodyGenerationEnabled: melodyGenerationEnabled,
          autoPlayChordChanges: autoPlayChordChanges,
          autoPlayPattern: autoPlayPattern,
          bpmController: bpmController,
          onPlayChord: onPlayChord,
          onToggleBlockAutoplay: onToggleBlockAutoplay,
          onPlayArpeggio: onPlayArpeggio,
          onToggleArpeggioAutoplay: onToggleArpeggioAutoplay,
          onRegenerateMelody: onRegenerateMelody,
          onAdjustBpm: onAdjustBpm,
          onBpmChanged: onBpmChanged,
          onBpmSubmitted: onBpmSubmitted,
          onBpmTapOutside: onBpmTapOutside,
        ),
        if (melodyGenerationEnabled) ...[
          SizedBox(height: dense ? 10 : 12),
          _MelodyPlaybackSection(
            compact: dense,
            showModeSelector: !embedMelodyPlaybackSelector,
            currentMelodyPreviewText: currentMelodyPreviewText,
            nextMelodyPreviewText: nextMelodyPreviewText,
            melodyPlaybackMode: melodyPlaybackMode,
            onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
          ),
        ],
      ],
    );
  }
}

class _GeneratorControlShell extends StatelessWidget {
  const _GeneratorControlShell({
    required this.compact,
    required this.dense,
    required this.currentChordAvailable,
    required this.melodyGenerationEnabled,
    required this.autoPlayChordChanges,
    required this.autoPlayPattern,
    required this.bpmController,
    required this.onPlayChord,
    required this.onToggleBlockAutoplay,
    required this.onPlayArpeggio,
    required this.onToggleArpeggioAutoplay,
    required this.onRegenerateMelody,
    required this.onAdjustBpm,
    required this.onBpmChanged,
    required this.onBpmSubmitted,
    required this.onBpmTapOutside,
  });

  final bool compact;
  final bool dense;
  final bool currentChordAvailable;
  final bool melodyGenerationEnabled;
  final bool autoPlayChordChanges;
  final HarmonyPlaybackPattern autoPlayPattern;
  final TextEditingController bpmController;
  final VoidCallback onPlayChord;
  final VoidCallback onToggleBlockAutoplay;
  final VoidCallback onPlayArpeggio;
  final VoidCallback onToggleArpeggioAutoplay;
  final VoidCallback onRegenerateMelody;
  final ValueChanged<int> onAdjustBpm;
  final ValueChanged<String> onBpmChanged;
  final ValueChanged<String> onBpmSubmitted;
  final TapRegionCallback onBpmTapOutside;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final useStackedLayout = constraints.maxWidth < 700;
        final denseLayout = dense || constraints.maxWidth < 520;
        final actionCards = <Widget>[
          _PreviewActionCard(
            buttonKey: const ValueKey('practice-play-chord-button'),
            icon: Icons.volume_up_rounded,
            title: l10n.audioPlayChord,
            modeLabel: HarmonyPlaybackPattern.block.localizedLabel(l10n),
            compact: compact,
            dense: denseLayout,
            enabled: currentChordAvailable,
            autoplayEnabled:
                autoPlayChordChanges &&
                autoPlayPattern == HarmonyPlaybackPattern.block,
            onPressed: onPlayChord,
            onToggleAutoplay: onToggleBlockAutoplay,
          ),
          _PreviewActionCard(
            buttonKey: const ValueKey('practice-play-arpeggio-button'),
            icon: Icons.multitrack_audio_rounded,
            title: l10n.audioPlayArpeggio,
            modeLabel: HarmonyPlaybackPattern.arpeggio.localizedLabel(l10n),
            compact: compact,
            dense: denseLayout,
            enabled: currentChordAvailable,
            autoplayEnabled:
                autoPlayChordChanges &&
                autoPlayPattern == HarmonyPlaybackPattern.arpeggio,
            onPressed: onPlayArpeggio,
            onToggleAutoplay: onToggleArpeggioAutoplay,
          ),
          if (melodyGenerationEnabled)
            _PreviewActionCard(
              buttonKey: const ValueKey('practice-regenerate-melody-button'),
              icon: Icons.auto_fix_high_rounded,
              title: l10n.regenerateMelody,
              modeLabel: l10n.melodyGenerationTitle,
              compact: compact,
              dense: denseLayout,
              enabled: true,
              autoplayEnabled: false,
              showsAutoplayToggle: false,
              onPressed: onRegenerateMelody,
            ),
        ];

        if (useStackedLayout) {
          return Column(
            children: [
              for (final card in actionCards) ...[
                card,
                if (card != actionCards.last) const SizedBox(height: 10),
              ],
              const SizedBox(height: 10),
              _BpmControlCluster(
                bpmController: bpmController,
                bpmLabel: l10n.bpmLabel,
                decreaseTooltip: l10n.decreaseBpm,
                increaseTooltip: l10n.increaseBpm,
                compact: true,
                dense: true,
                onAdjust: onAdjustBpm,
                onChanged: onBpmChanged,
                onSubmitted: onBpmSubmitted,
                onTapOutside: onBpmTapOutside,
              ),
            ],
          );
        }

        final cardWidth = actionCards.length == 3 ? 172.0 : 204.0;
        final actionGrid = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final card in actionCards)
              SizedBox(width: cardWidth, child: card),
          ],
        );
        final bpmCluster = _BpmControlCluster(
          bpmController: bpmController,
          bpmLabel: l10n.bpmLabel,
          decreaseTooltip: l10n.decreaseBpm,
          increaseTooltip: l10n.increaseBpm,
          dense: denseLayout,
          onAdjust: onAdjustBpm,
          onChanged: onBpmChanged,
          onSubmitted: onBpmSubmitted,
          onTapOutside: onBpmTapOutside,
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: actionGrid),
            const SizedBox(width: 12),
            Expanded(child: bpmCluster),
          ],
        );
      },
    );
  }
}

class _PreviewActionCard extends StatelessWidget {
  const _PreviewActionCard({
    required this.buttonKey,
    required this.icon,
    required this.title,
    required this.modeLabel,
    required this.compact,
    required this.dense,
    required this.enabled,
    required this.autoplayEnabled,
    required this.onPressed,
    this.onToggleAutoplay,
    this.showsAutoplayToggle = true,
  });

  final Key buttonKey;
  final IconData icon;
  final String title;
  final String modeLabel;
  final bool compact;
  final bool dense;
  final bool enabled;
  final bool autoplayEnabled;
  final VoidCallback onPressed;
  final VoidCallback? onToggleAutoplay;
  final bool showsAutoplayToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(
        theme,
        accent: autoplayEnabled,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          dense ? 10 : 12,
          dense ? 8 : 10,
          dense ? 10 : 12,
          dense ? 8 : 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(modeLabel, style: ChordestUiTokens.overlineStyle(theme)),
            SizedBox(height: dense ? 6 : 8),
            FilledButton.tonalIcon(
              key: buttonKey,
              onPressed: enabled ? onPressed : null,
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(dense ? 40 : (compact ? 42 : 46)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                alignment: Alignment.centerLeft,
                backgroundColor: enabled
                    ? colorScheme.surface.withValues(alpha: 0.78)
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: ChordestUiTokens.radius(18),
                  side: BorderSide(
                    color: enabled
                        ? colorScheme.outlineVariant.withValues(alpha: 0.84)
                        : colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
              icon: Icon(icon, size: dense ? 18 : 20),
              label: Text(
                title,
                style:
                    (dense
                            ? theme.textTheme.labelMedium
                            : theme.textTheme.labelLarge)
                        ?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: dense ? 6 : 8),
            if (showsAutoplayToggle)
              compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.autoPlayChordChanges,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _InlineStatusToggle(
                          selected: autoplayEnabled,
                          dense: dense,
                          enabled: onToggleAutoplay != null,
                          onPressed: onToggleAutoplay,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.autoPlayChordChanges,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _InlineStatusToggle(
                          selected: autoplayEnabled,
                          dense: dense,
                          enabled: onToggleAutoplay != null,
                          onPressed: onToggleAutoplay,
                        ),
                      ],
                    )
            else
              Text(
                compact ? l10n.melodyGenerationTitle : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InlineStatusToggle extends StatelessWidget {
  const _InlineStatusToggle({
    required this.selected,
    required this.enabled,
    this.dense = false,
    this.onPressed,
  });

  final bool selected;
  final bool enabled;
  final bool dense;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextButton.icon(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 7 : 8,
          vertical: dense ? 6 : 7,
        ),
        backgroundColor: selected
            ? colorScheme.primaryContainer.withValues(alpha: 0.72)
            : colorScheme.surface.withValues(alpha: 0.72),
        foregroundColor: selected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: ChordestUiTokens.radius(14),
          side: BorderSide(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.24)
                : colorScheme.outlineVariant.withValues(alpha: 0.84),
          ),
        ),
      ),
      icon: Icon(
        selected ? Icons.autorenew_rounded : Icons.do_not_disturb_alt_rounded,
        size: dense ? 14 : 16,
      ),
      label: Text(
        selected ? l10n.enabled : l10n.disabled,
        style:
            (dense ? theme.textTheme.labelSmall : theme.textTheme.labelMedium)
                ?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MelodyPlaybackSection extends StatelessWidget {
  const _MelodyPlaybackSection({
    required this.compact,
    this.showModeSelector = true,
    required this.currentMelodyPreviewText,
    required this.nextMelodyPreviewText,
    required this.melodyPlaybackMode,
    required this.onSelectMelodyPlaybackMode,
  });

  final bool compact;
  final bool showModeSelector;
  final String currentMelodyPreviewText;
  final String nextMelodyPreviewText;
  final MelodyPlaybackMode melodyPlaybackMode;
  final ValueChanged<MelodyPlaybackMode> onSelectMelodyPlaybackMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.melodyGenerationTitle,
              style: ChordestUiTokens.overlineStyle(theme),
            ),
            if (showModeSelector) ...[
              const SizedBox(height: 10),
              _MelodyPlaybackModeSelector(
                compact: compact,
                melodyPlaybackMode: melodyPlaybackMode,
                onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
              ),
            ],
            if (currentMelodyPreviewText.isNotEmpty) ...[
              SizedBox(height: showModeSelector ? (compact ? 10 : 12) : 10),
              _MelodyPreviewStrip(
                currentText: currentMelodyPreviewText,
                nextText: nextMelodyPreviewText,
                currentLabel: l10n.melodyPreviewCurrent,
                nextLabel: l10n.melodyPreviewNext,
                compact: compact,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmbeddedMelodyPlaybackCard extends StatelessWidget {
  const _EmbeddedMelodyPlaybackCard({
    required this.compact,
    required this.melodyPlaybackMode,
    required this.onSelectMelodyPlaybackMode,
  });

  final bool compact;
  final MelodyPlaybackMode melodyPlaybackMode;
  final ValueChanged<MelodyPlaybackMode> onSelectMelodyPlaybackMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.melodyGenerationTitle,
              style: ChordestUiTokens.overlineStyle(theme),
            ),
            const SizedBox(height: 8),
            _MelodyPlaybackModeSelector(
              compact: compact,
              melodyPlaybackMode: melodyPlaybackMode,
              onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
            ),
          ],
        ),
      ),
    );
  }
}

class _MelodyPlaybackModeSelector extends StatelessWidget {
  const _MelodyPlaybackModeSelector({
    required this.compact,
    required this.melodyPlaybackMode,
    required this.onSelectMelodyPlaybackMode,
  });

  final bool compact;
  final MelodyPlaybackMode melodyPlaybackMode;
  final ValueChanged<MelodyPlaybackMode> onSelectMelodyPlaybackMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final mode in MelodyPlaybackMode.values)
          _PlaybackModeChip(
            buttonKey: ValueKey('melody-playback-mode-${mode.name}'),
            icon: _iconForMode(mode),
            label: mode.localizedLabel(l10n),
            selected: melodyPlaybackMode == mode,
            compact: compact,
            onPressed: () => onSelectMelodyPlaybackMode(mode),
          ),
      ],
    );
  }

  IconData _iconForMode(MelodyPlaybackMode mode) {
    return switch (mode) {
      MelodyPlaybackMode.chordsOnly => Icons.piano_rounded,
      MelodyPlaybackMode.melodyOnly => Icons.graphic_eq_rounded,
      MelodyPlaybackMode.both => Icons.layers_rounded,
    };
  }
}

class _PlaybackModeChip extends StatelessWidget {
  const _PlaybackModeChip({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.selected,
    required this.compact,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: ChordestUiTokens.radius(16),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.74)
                : colorScheme.surface.withValues(alpha: 0.74),
            borderRadius: ChordestUiTokens.radius(16),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.24)
                  : colorScheme.outlineVariant.withValues(alpha: 0.84),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? colorScheme.primary : colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
    required this.compact,
  });

  final String currentText;
  final String nextText;
  final String currentLabel;
  final String nextLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: ChordestUiTokens.radius(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: _MelodyPreviewColumn(
                label: currentLabel,
                text: currentText,
                compact: compact,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ),
            Expanded(
              child: _MelodyPreviewColumn(
                label: nextLabel,
                text: nextText,
                compact: compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MelodyPreviewColumn extends StatelessWidget {
  const _MelodyPreviewColumn({
    required this.label,
    required this.text,
    required this.compact,
  });

  final String label;
  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ChordestUiTokens.overlineStyle(theme)),
        const SizedBox(height: 6),
        Text(
          text.isEmpty ? '...' : text,
          maxLines: compact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style:
              (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                  ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
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
    this.dense = false,
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
  final bool dense;
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
            color: theme.colorScheme.surface.withValues(alpha: 0.82),
            borderRadius: ChordestUiTokens.radius(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 10 : (widget.dense ? 10 : 12),
              vertical: widget.compact ? 5 : (widget.dense ? 5 : 7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tempo', style: ChordestUiTokens.overlineStyle(theme)),
                const SizedBox(height: 2),
                TextField(
                  key: const ValueKey('bpm-input'),
                  controller: widget.bpmController,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  style:
                      (widget.compact
                              ? theme.textTheme.headlineSmall
                              : (widget.dense
                                    ? theme.textTheme.headlineMedium
                                    : theme.textTheme.displaySmall))
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.2,
                            height: 1,
                          ),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onTapOutside: widget.onTapOutside,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixText: widget.bpmLabel,
                    suffixStyle: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
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
      decoration: ChordestUiTokens.innerPanelDecoration(theme, accent: true),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          widget.dense ? 10 : 12,
          widget.dense ? 8 : 10,
          widget.dense ? 10 : 12,
          widget.dense ? 8 : 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bpmLabel, style: ChordestUiTokens.overlineStyle(theme)),
            SizedBox(height: widget.dense ? 6 : 8),
            if (widget.compact) ...[
              fieldSurface,
              SizedBox(height: widget.dense ? 6 : 8),
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
            ] else
              Row(
                children: [
                  _BpmAdjustButton(
                    buttonKey: const ValueKey('bpm-decrease-button'),
                    icon: Icons.remove_rounded,
                    tooltip: widget.decreaseTooltip,
                    onPressStart: () => _startContinuousAdjust(-5),
                    onPressEnd: _stopContinuousAdjust,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: fieldSurface),
                  const SizedBox(width: 8),
                  _BpmAdjustButton(
                    buttonKey: const ValueKey('bpm-increase-button'),
                    icon: Icons.add_rounded,
                    tooltip: widget.increaseTooltip,
                    onPressStart: () => _startContinuousAdjust(5),
                    onPressEnd: _stopContinuousAdjust,
                  ),
                ],
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
    this.compact = false,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: Listener(
        onPointerDown: (_) => onPressStart(),
        onPointerUp: (_) => onPressEnd(),
        onPointerCancel: (_) => onPressEnd(),
        child: DecoratedBox(
          key: buttonKey,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.78),
            borderRadius: ChordestUiTokens.radius(18),
          ),
          child: SizedBox(
            width: compact ? 40 : 42,
            height: compact ? 40 : 42,
            child: Icon(icon, size: compact ? 20 : 22),
          ),
        ),
      ),
    );
  }
}
