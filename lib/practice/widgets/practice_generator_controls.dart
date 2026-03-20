import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../audio/harmony_audio_models.dart';
import '../../l10n/app_localizations.dart';
import '../../settings/practice_settings.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GeneratorTransportAndBpmRow(
          compact: compact,
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
          SizedBox(height: compact ? 8 : 10),
          _MelodyPlaybackSection(
            compact: compact,
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

class _GeneratorTransportAndBpmRow extends StatelessWidget {
  const _GeneratorTransportAndBpmRow({
    required this.compact,
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
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: compact ? 8 : 12,
      runSpacing: compact ? 8 : 10,
      children: [
        _PreviewControlButton(
          buttonKey: const ValueKey('practice-play-chord-button'),
          icon: Icons.volume_up_rounded,
          tooltip: l10n.audioPlayChord,
          compact: compact,
          badgeIcon:
              autoPlayChordChanges &&
                  autoPlayPattern == HarmonyPlaybackPattern.block
              ? Icons.autorenew_rounded
              : null,
          onPressed: currentChordAvailable ? onPlayChord : null,
          onLongPress: currentChordAvailable ? onToggleBlockAutoplay : null,
        ),
        _PreviewControlButton(
          buttonKey: const ValueKey('practice-play-arpeggio-button'),
          icon: Icons.multitrack_audio_rounded,
          tooltip: l10n.audioPlayArpeggio,
          compact: compact,
          badgeIcon:
              autoPlayChordChanges &&
                  autoPlayPattern == HarmonyPlaybackPattern.arpeggio
              ? Icons.autorenew_rounded
              : null,
          onPressed: currentChordAvailable ? onPlayArpeggio : null,
          onLongPress: currentChordAvailable ? onToggleArpeggioAutoplay : null,
        ),
        if (melodyGenerationEnabled)
          _PreviewControlButton(
            buttonKey: const ValueKey('practice-regenerate-melody-button'),
            icon: Icons.auto_fix_high_rounded,
            tooltip: l10n.regenerateMelody,
            compact: compact,
            onPressed: onRegenerateMelody,
          ),
        _BpmControlCluster(
          bpmController: bpmController,
          bpmLabel: l10n.bpmLabel,
          decreaseTooltip: l10n.decreaseBpm,
          increaseTooltip: l10n.increaseBpm,
          compact: true,
          onAdjust: onAdjustBpm,
          onChanged: onBpmChanged,
          onSubmitted: onBpmSubmitted,
          onTapOutside: onBpmTapOutside,
        ),
      ],
    );
  }
}

class _MelodyPlaybackSection extends StatelessWidget {
  const _MelodyPlaybackSection({
    required this.compact,
    required this.currentMelodyPreviewText,
    required this.nextMelodyPreviewText,
    required this.melodyPlaybackMode,
    required this.onSelectMelodyPlaybackMode,
  });

  final bool compact;
  final String currentMelodyPreviewText;
  final String nextMelodyPreviewText;
  final MelodyPlaybackMode melodyPlaybackMode;
  final ValueChanged<MelodyPlaybackMode> onSelectMelodyPlaybackMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _MelodyPlaybackModeSelector(
          compact: compact,
          melodyPlaybackMode: melodyPlaybackMode,
          onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
        ),
        if (currentMelodyPreviewText.isNotEmpty) ...[
          SizedBox(height: compact ? 8 : 10),
          _MelodyPreviewStrip(
            currentText: currentMelodyPreviewText,
            nextText: nextMelodyPreviewText,
            currentLabel: l10n.melodyPreviewCurrent,
            nextLabel: l10n.melodyPreviewNext,
            compact: compact,
          ),
        ],
      ],
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
    if (!compact) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final mode in MelodyPlaybackMode.values)
            ChoiceChip(
              key: ValueKey('melody-playback-mode-${mode.name}'),
              label: Text(mode.localizedLabel(l10n)),
              selected: melodyPlaybackMode == mode,
              onSelected: (selected) {
                if (!selected) {
                  return;
                }
                onSelectMelodyPlaybackMode(mode);
              },
            ),
        ],
      );
    }

    IconData iconForMode(MelodyPlaybackMode mode) {
      return switch (mode) {
        MelodyPlaybackMode.chordsOnly => Icons.piano_rounded,
        MelodyPlaybackMode.melodyOnly => Icons.graphic_eq_rounded,
        MelodyPlaybackMode.both => Icons.layers_rounded,
      };
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final mode in MelodyPlaybackMode.values)
          _CompactPlaybackModeButton(
            buttonKey: ValueKey('melody-playback-mode-${mode.name}'),
            icon: iconForMode(mode),
            label: mode.localizedLabel(l10n),
            selected: melodyPlaybackMode == mode,
            onPressed: () => onSelectMelodyPlaybackMode(mode),
          ),
      ],
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
              compact: widget.compact,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.compact ? 12 : 14,
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
                        const SizedBox(width: 10),
                        SizedBox(
                          width: widget.compact ? 68 : 84,
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
            ),
            const SizedBox(width: 10),
            _BpmAdjustButton(
              buttonKey: const ValueKey('bpm-increase-button'),
              icon: Icons.add_rounded,
              tooltip: widget.increaseTooltip,
              compact: widget.compact,
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
              width: compact ? 40 : 46,
              height: compact ? 40 : 46,
              child: Icon(icon, size: compact ? 20 : 24),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactPlaybackModeButton extends StatelessWidget {
  const _CompactPlaybackModeButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
