import 'package:flutter/material.dart';

import '../../settings/practice_settings.dart';
import '../../widgets/beat_indicator_row.dart';

class PracticeTransportStrip extends StatelessWidget {
  const PracticeTransportStrip({
    super.key,
    required this.compact,
    required this.beatsPerBar,
    required this.currentBeat,
    required this.beatStates,
    required this.metronomePatternEditing,
    required this.animationDuration,
    required this.meterLabel,
    required this.meterTooltip,
    required this.startTooltip,
    required this.pauseTooltip,
    required this.resetTooltip,
    required this.autoRunning,
    required this.onPressedBeatRow,
    required this.onPressedBeat,
    required this.onTogglePatternEditing,
    required this.onOpenTimeSignaturePicker,
    required this.onToggleAutoplay,
    required this.onResetGeneratedChords,
  });

  final bool compact;
  final int beatsPerBar;
  final int? currentBeat;
  final List<MetronomeBeatState> beatStates;
  final bool metronomePatternEditing;
  final Duration animationDuration;
  final String meterLabel;
  final String meterTooltip;
  final String startTooltip;
  final String pauseTooltip;
  final String resetTooltip;
  final bool autoRunning;
  final VoidCallback onPressedBeatRow;
  final ValueChanged<int> onPressedBeat;
  final VoidCallback onTogglePatternEditing;
  final VoidCallback onOpenTimeSignaturePicker;
  final VoidCallback onToggleAutoplay;
  final VoidCallback onResetGeneratedChords;

  @override
  Widget build(BuildContext context) {
    final materialL10n = MaterialLocalizations.of(context);
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveCompact = compact || constraints.maxWidth < 360;
        final beatRow = BeatIndicatorRow(
          beatCount: beatsPerBar,
          activeBeat: currentBeat,
          beatStates: beatStates,
          expanded: metronomePatternEditing,
          onPressed: !metronomePatternEditing ? onPressedBeatRow : null,
          onBeatPressed: metronomePatternEditing ? onPressedBeat : null,
          animationDuration: animationDuration,
        );
        final editDoneButton = metronomePatternEditing
            ? Padding(
                padding: EdgeInsets.only(left: effectiveCompact ? 8 : 10),
                child: IconButton(
                  tooltip: materialL10n.okButtonLabel,
                  onPressed: onTogglePatternEditing,
                  style: IconButton.styleFrom(
                    minimumSize: Size.square(effectiveCompact ? 34 : 38),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.primary,
                  ),
                  icon: Icon(
                    Icons.check_rounded,
                    size: effectiveCompact ? 18 : 20,
                  ),
                ),
              )
            : const SizedBox.shrink();

        final meterButton = _TransportMeterButton(
          label: meterLabel,
          tooltip: meterTooltip,
          compact: effectiveCompact,
          onPressed: onOpenTimeSignaturePicker,
        );

        final transportButtons = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TransportToggleButton(
              running: autoRunning,
              startTooltip: startTooltip,
              pauseTooltip: pauseTooltip,
              compact: effectiveCompact,
              onPressed: onToggleAutoplay,
            ),
            const SizedBox(width: 8),
            _TransportResetButton(
              tooltip: resetTooltip,
              compact: effectiveCompact,
              onPressed: onResetGeneratedChords,
            ),
          ],
        );

        final stackedLayout =
            metronomePatternEditing ||
            beatsPerBar > 7 ||
            constraints.maxWidth < 360;

        return Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: effectiveCompact ? 10 : 16,
                vertical: effectiveCompact ? 8 : 10,
              ),
              child: stackedLayout
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [meterButton, transportButtons],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: effectiveCompact ? 8 : 10,
                          runSpacing: effectiveCompact ? 8 : 10,
                          children: [
                            beatRow,
                            if (metronomePatternEditing) editDoneButton,
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        meterButton,
                        const SizedBox(width: 12),
                        beatRow,
                        editDoneButton,
                        const SizedBox(width: 12),
                        transportButtons,
                      ],
                    ),
            ),
          ),
        );
      },
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
