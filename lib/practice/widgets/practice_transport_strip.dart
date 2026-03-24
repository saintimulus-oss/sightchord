import 'package:flutter/material.dart';

import '../../settings/practice_settings.dart';
import '../../ui/chordest_ui_tokens.dart';
import '../../widgets/beat_indicator_row.dart';
import 'practice_generator_controls.dart';

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
    required this.bpmLabel,
    required this.decreaseBpmTooltip,
    required this.increaseBpmTooltip,
    required this.autoRunning,
    required this.bpmController,
    required this.onPressedBeatRow,
    required this.onPressedBeat,
    required this.onTogglePatternEditing,
    required this.onOpenTimeSignaturePicker,
    required this.onToggleAutoplay,
    required this.onResetGeneratedChords,
    required this.onAdjustBpm,
    required this.onBpmChanged,
    required this.onBpmSubmitted,
    required this.onBpmTapOutside,
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
  final String bpmLabel;
  final String decreaseBpmTooltip;
  final String increaseBpmTooltip;
  final bool autoRunning;
  final TextEditingController bpmController;
  final VoidCallback onPressedBeatRow;
  final ValueChanged<int> onPressedBeat;
  final VoidCallback onTogglePatternEditing;
  final VoidCallback onOpenTimeSignaturePicker;
  final VoidCallback onToggleAutoplay;
  final VoidCallback onResetGeneratedChords;
  final ValueChanged<int> onAdjustBpm;
  final ValueChanged<String> onBpmChanged;
  final ValueChanged<String> onBpmSubmitted;
  final TapRegionCallback onBpmTapOutside;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shortViewport = MediaQuery.sizeOf(context).height < 720;
    return LayoutBuilder(
      builder: (context, constraints) {
        final dense = compact || shortViewport || constraints.maxWidth < 880;
        final stacked = constraints.maxWidth < 760;
        final beatRow = BeatIndicatorRow(
          beatCount: beatsPerBar,
          activeBeat: currentBeat,
          beatStates: beatStates,
          expanded: metronomePatternEditing,
          onPressed: !metronomePatternEditing ? onPressedBeatRow : null,
          onBeatPressed: metronomePatternEditing ? onPressedBeat : null,
          animationDuration: animationDuration,
        );

        final controlRail = Wrap(
          spacing: dense ? 8 : 10,
          runSpacing: dense ? 8 : 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _TransportPrimaryAction(
              buttonKey: const ValueKey('practice-autoplay-button'),
              icon: autoRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              tooltip: autoRunning ? pauseTooltip : startTooltip,
              selected: autoRunning,
              compact: dense,
              onPressed: onToggleAutoplay,
            ),
            _TransportSecondaryAction(
              buttonKey: const ValueKey(
                'practice-reset-generated-chords-button',
              ),
              icon: Icons.stop_rounded,
              tooltip: resetTooltip,
              compact: dense,
              onPressed: onResetGeneratedChords,
            ),
            _TransportInfoButton(
              buttonKey: const ValueKey('practice-time-signature-button'),
              icon: Icons.music_note_rounded,
              label: meterLabel,
              tooltip: meterTooltip,
              compact: dense,
              onPressed: onOpenTimeSignaturePicker,
            ),
            PracticeBpmControlCluster(
              bpmController: bpmController,
              bpmLabel: bpmLabel,
              decreaseTooltip: decreaseBpmTooltip,
              increaseTooltip: increaseBpmTooltip,
              compact: true,
              onAdjust: onAdjustBpm,
              onChanged: onBpmChanged,
              onSubmitted: onBpmSubmitted,
              onTapOutside: onBpmTapOutside,
            ),
          ],
        );

        final beatLane = _BeatLane(
          compact: dense,
          beatRow: beatRow,
          editing: metronomePatternEditing,
          onPressed: onPressedBeatRow,
          onCompleteEditing: onTogglePatternEditing,
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.74),
            borderRadius: ChordestUiTokens.radius(30),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            boxShadow: ChordestUiTokens.panelShadows(theme),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              dense ? 12 : 16,
              dense ? 10 : 12,
              dense ? 12 : 16,
              dense ? 10 : 12,
            ),
            child: stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controlRail,
                      SizedBox(height: dense ? 10 : 12),
                      beatLane,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 5, child: beatLane),
                      _StripDivider(compact: dense),
                      Flexible(flex: 4, child: controlRail),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _BeatLane extends StatelessWidget {
  const _BeatLane({
    required this.compact,
    required this.beatRow,
    required this.editing,
    required this.onPressed,
    required this.onCompleteEditing,
  });

  final bool compact;
  final Widget beatRow;
  final bool editing;
  final VoidCallback onPressed;
  final VoidCallback onCompleteEditing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: ChordestUiTokens.radius(22),
        onTap: editing ? null : onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.56),
            borderRadius: ChordestUiTokens.radius(22),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 14,
            vertical: compact ? 8 : 10,
          ),
          child: Row(
            children: [
              Expanded(child: Center(child: beatRow)),
              if (editing) ...[
                const SizedBox(width: 10),
                _TransportPrimaryAction(
                  icon: Icons.check_rounded,
                  tooltip: MaterialLocalizations.of(context).okButtonLabel,
                  selected: true,
                  compact: compact,
                  onPressed: onCompleteEditing,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TransportPrimaryAction extends StatelessWidget {
  const _TransportPrimaryAction({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.compact,
    required this.onPressed,
    this.buttonKey,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final bool compact;
  final VoidCallback onPressed;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        key: buttonKey,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: Size.square(compact ? 40 : 44),
          backgroundColor: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface.withValues(alpha: 0.9),
          foregroundColor: selected
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: ChordestUiTokens.radius(compact ? 14 : 16),
          ),
        ),
        icon: Icon(icon, size: compact ? 20 : 22),
      ),
    );
  }
}

class _TransportSecondaryAction extends StatelessWidget {
  const _TransportSecondaryAction({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.compact,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        key: buttonKey,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: Size.square(compact ? 40 : 44),
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.56),
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: ChordestUiTokens.radius(compact ? 14 : 16),
          ),
        ),
        icon: Icon(icon, size: compact ? 20 : 22),
      ),
    );
  }
}

class _TransportInfoButton extends StatelessWidget {
  const _TransportInfoButton({
    required this.buttonKey,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.compact,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
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
        key: buttonKey,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, compact ? 40 : 44),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 10 : 12,
          ),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.56),
          foregroundColor: theme.colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: ChordestUiTokens.radius(compact ? 14 : 16),
          ),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: Icon(icon, size: compact ? 16 : 18),
        label: Text(label),
      ),
    );
  }
}

class _StripDivider extends StatelessWidget {
  const _StripDivider({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: compact ? 36 : 44,
      margin: EdgeInsets.symmetric(horizontal: compact ? 10 : 14),
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.26),
    );
  }
}
