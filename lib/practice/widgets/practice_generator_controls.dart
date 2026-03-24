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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final shortViewport = MediaQuery.sizeOf(context).height < 720;
    final dense = compact || shortViewport;
    final inlineModeSelector =
        melodyGenerationEnabled && shortViewport && !compact;
    final blockSelected =
        autoPlayChordChanges && autoPlayPattern == HarmonyPlaybackPattern.block;
    final arpeggioSelected =
        autoPlayChordChanges &&
        autoPlayPattern == HarmonyPlaybackPattern.arpeggio;
    final hasMelodyPreview =
        currentMelodyPreviewText.isNotEmpty || nextMelodyPreviewText.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: dense ? 8 : 10,
          runSpacing: dense ? 8 : 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _PrimaryActionButton(
              buttonKey: const ValueKey('practice-play-chord-button'),
              icon: Icons.volume_up_rounded,
              label: l10n.audioPlayChord,
              enabled: currentChordAvailable,
              compact: dense,
              onPressed: onPlayChord,
            ),
            _SecondaryActionButton(
              buttonKey: const ValueKey('practice-play-arpeggio-button'),
              icon: Icons.multitrack_audio_rounded,
              label: l10n.audioPlayArpeggio,
              enabled: currentChordAvailable,
              compact: dense,
              onPressed: onPlayArpeggio,
            ),
            if (melodyGenerationEnabled)
              _SecondaryActionButton(
                buttonKey: const ValueKey('practice-regenerate-melody-button'),
                icon: Icons.auto_fix_high_rounded,
                label: l10n.regenerateMelody,
                compact: dense,
                onPressed: onRegenerateMelody,
              ),
            _StateToggleChip(
              label: HarmonyPlaybackPattern.block.localizedLabel(l10n),
              selected: blockSelected,
              compact: dense,
              onPressed: onToggleBlockAutoplay,
            ),
            _StateToggleChip(
              label: HarmonyPlaybackPattern.arpeggio.localizedLabel(l10n),
              selected: arpeggioSelected,
              compact: dense,
              onPressed: onToggleArpeggioAutoplay,
            ),
          ],
        ),
        if (melodyGenerationEnabled) ...[
          SizedBox(height: dense ? 8 : 10),
          if (!inlineModeSelector) ...[
            _QuietDivider(compact: dense),
            SizedBox(height: dense ? 10 : 12),
          ],
          _MelodyPlaybackModeSelector(
            compact: dense,
            melodyPlaybackMode: melodyPlaybackMode,
            onSelectMelodyPlaybackMode: onSelectMelodyPlaybackMode,
          ),
        ],
        if (melodyGenerationEnabled &&
            hasMelodyPreview &&
            !inlineModeSelector) ...[
          SizedBox(height: dense ? 8 : 10),
          Text(
            '${l10n.melodyPreviewCurrent}: '
            '${currentMelodyPreviewText.isEmpty ? '...' : currentMelodyPreviewText}'
            '  →  '
            '${nextMelodyPreviewText.isEmpty ? '...' : nextMelodyPreviewText}',
            maxLines: dense ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ],
    );
  }
}

class PracticeBpmControlCluster extends StatefulWidget {
  const PracticeBpmControlCluster({
    super.key,
    required this.bpmController,
    required this.bpmLabel,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    required this.onAdjust,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapOutside,
    this.compact = false,
  });

  final TextEditingController bpmController;
  final String bpmLabel;
  final String decreaseTooltip;
  final String increaseTooltip;
  final ValueChanged<int> onAdjust;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TapRegionCallback onTapOutside;
  final bool compact;

  @override
  State<PracticeBpmControlCluster> createState() =>
      _PracticeBpmControlClusterState();
}

class _PracticeBpmControlClusterState extends State<PracticeBpmControlCluster> {
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
    final compact = widget.compact;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: ChordestUiTokens.radius(compact ? 18 : 20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 6 : 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BpmAdjustButton(
              buttonKey: const ValueKey('bpm-decrease-button'),
              icon: Icons.remove_rounded,
              tooltip: widget.decreaseTooltip,
              compact: compact,
              onPressStart: () => _startContinuousAdjust(-5),
              onPressEnd: _stopContinuousAdjust,
            ),
            SizedBox(width: compact ? 6 : 8),
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
                    color: theme.colorScheme.surface.withValues(alpha: 0.88),
                    borderRadius: ChordestUiTokens.radius(compact ? 16 : 18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 10 : 12,
                      vertical: compact ? 4 : 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: compact ? 42 : 54,
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
                                (compact
                                        ? theme.textTheme.titleLarge
                                        : theme.textTheme.headlineSmall)
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      height: 1,
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
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.bpmLabel,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: compact ? 6 : 8),
            _BpmAdjustButton(
              buttonKey: const ValueKey('bpm-increase-button'),
              icon: Icons.add_rounded,
              tooltip: widget.increaseTooltip,
              compact: compact,
              onPressStart: () => _startContinuousAdjust(5),
              onPressEnd: _stopContinuousAdjust,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.enabled,
    required this.compact,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final bool enabled;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.icon(
      key: buttonKey,
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        minimumSize: Size(0, compact ? 42 : 46),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 16,
          vertical: compact ? 10 : 12,
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: ChordestUiTokens.radius(compact ? 16 : 18),
        ),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      icon: Icon(icon, size: compact ? 18 : 20),
      label: Text(label),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.compact,
    required this.onPressed,
    this.enabled = true,
  });

  final Key buttonKey;
  final IconData icon;
  final String label;
  final bool compact;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      key: buttonKey,
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, compact ? 42 : 46),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 14,
          vertical: compact ? 10 : 12,
        ),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.46),
        shape: RoundedRectangleBorder(
          borderRadius: ChordestUiTokens.radius(compact ? 16 : 18),
        ),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      icon: Icon(icon, size: compact ? 18 : 20),
      label: Text(label),
    );
  }
}

class _StateToggleChip extends StatelessWidget {
  const _StateToggleChip({
    required this.label,
    required this.selected,
    required this.compact,
    required this.onPressed,
  });

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
        onTap: onPressed,
        borderRadius: ChordestUiTokens.radius(999),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 12,
            vertical: compact ? 8 : 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.62)
                : colorScheme.surface.withValues(alpha: 0.38),
            borderRadius: ChordestUiTokens.radius(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected
                    ? Icons.autorenew_rounded
                    : Icons.do_not_disturb_alt_rounded,
                size: compact ? 15 : 16,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style:
                    (compact
                            ? theme.textTheme.labelMedium
                            : theme.textTheme.labelLarge)
                        ?.copyWith(
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
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
      spacing: compact ? 8 : 10,
      runSpacing: compact ? 8 : 10,
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
            vertical: compact ? 9 : 11,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.66)
                : colorScheme.surface.withValues(alpha: 0.42),
            borderRadius: ChordestUiTokens.radius(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: compact ? 16 : 18,
                color: selected ? colorScheme.primary : colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style:
                    (compact
                            ? theme.textTheme.labelMedium
                            : theme.textTheme.labelLarge)
                        ?.copyWith(
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
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

class _BpmAdjustButton extends StatelessWidget {
  const _BpmAdjustButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressStart,
    required this.onPressEnd,
    required this.compact,
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
            color: theme.colorScheme.surface.withValues(alpha: 0.82),
            borderRadius: ChordestUiTokens.radius(compact ? 14 : 16),
          ),
          child: SizedBox(
            width: compact ? 32 : 36,
            height: compact ? 32 : 36,
            child: Icon(icon, size: compact ? 18 : 20),
          ),
        ),
      ),
    );
  }
}

class _QuietDivider extends StatelessWidget {
  const _QuietDivider({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 1,
      margin: EdgeInsets.only(right: compact ? 0 : 24),
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.26),
    );
  }
}
