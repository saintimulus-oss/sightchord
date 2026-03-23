import 'package:flutter/material.dart';

import '../../settings/practice_settings.dart';
import '../../ui/chordest_ui_tokens.dart';
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
    required this.rhythmTitle,
    required this.rhythmEditingTitle,
    required this.transportTitle,
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
  final String rhythmTitle;
  final String rhythmEditingTitle;
  final String transportTitle;
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
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortViewport = MediaQuery.sizeOf(context).height < 720;
        final effectiveCompact =
            compact || shortViewport || constraints.maxWidth < 420;
        final useStackedLayout = constraints.maxWidth < 680;
        final beatRow = BeatIndicatorRow(
          beatCount: beatsPerBar,
          activeBeat: currentBeat,
          beatStates: beatStates,
          expanded: metronomePatternEditing,
          onPressed: !metronomePatternEditing ? onPressedBeatRow : null,
          onBeatPressed: metronomePatternEditing ? onPressedBeat : null,
          animationDuration: animationDuration,
        );

        final rhythmEditorAction = metronomePatternEditing
            ? _TransportActionButton(
                tooltip: MaterialLocalizations.of(context).okButtonLabel,
                icon: Icons.check_rounded,
                label: MaterialLocalizations.of(context).okButtonLabel,
                selected: true,
                compact: effectiveCompact,
                onPressed: onTogglePatternEditing,
              )
            : null;

        final sections = <Widget>[
          _TransportInfoCard(
            title: meterTooltip,
            value: meterLabel,
            icon: Icons.music_note_rounded,
            compact: effectiveCompact,
            onPressed: onOpenTimeSignaturePicker,
            buttonKey: const ValueKey('practice-time-signature-button'),
          ),
          _TransportBeatCard(
            title: metronomePatternEditing ? rhythmEditingTitle : rhythmTitle,
            compact: effectiveCompact,
            beatRow: beatRow,
            trailing: rhythmEditorAction,
            onPressed: metronomePatternEditing ? null : onPressedBeatRow,
          ),
          _TransportControlsCard(
            compact: effectiveCompact,
            title: transportTitle,
            autoRunning: autoRunning,
            startTooltip: startTooltip,
            pauseTooltip: pauseTooltip,
            resetTooltip: resetTooltip,
            onToggleAutoplay: onToggleAutoplay,
            onResetGeneratedChords: onResetGeneratedChords,
          ),
        ];

        if (useStackedLayout) {
          return DecoratedBox(
            decoration: ChordestUiTokens.panelDecoration(
              theme,
              borderRadius: ChordestUiTokens.radius(28),
            ),
            child: Padding(
              padding: EdgeInsets.all(shortViewport ? 6 : 8),
              child: Column(
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    sections[i],
                    if (i + 1 < sections.length)
                      SizedBox(height: shortViewport ? 6 : 8),
                  ],
                ],
              ),
            ),
          );
        }

        return DecoratedBox(
          decoration: ChordestUiTokens.panelDecoration(
            theme,
            borderRadius: ChordestUiTokens.radius(30),
          ),
          child: Padding(
            padding: EdgeInsets.all(shortViewport ? 8 : 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: sections[0]),
                SizedBox(width: shortViewport ? 8 : 10),
                Expanded(flex: 2, child: sections[1]),
                SizedBox(width: shortViewport ? 8 : 10),
                Expanded(child: sections[2]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TransportInfoCard extends StatelessWidget {
  const _TransportInfoCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.compact,
    required this.onPressed,
    required this.buttonKey,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool compact;
  final VoidCallback onPressed;
  final Key buttonKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        // Keep the transport legible without consuming too much vertical space.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ChordestUiTokens.overlineStyle(theme)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: buttonKey,
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 10 : 12,
                  vertical: compact ? 10 : 12,
                ),
                alignment: Alignment.centerLeft,
                side: BorderSide(color: colorScheme.outlineVariant),
                backgroundColor: colorScheme.surface.withValues(alpha: 0.68),
              ),
              icon: Icon(icon, size: compact ? 18 : 20),
              label: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportBeatCard extends StatelessWidget {
  const _TransportBeatCard({
    required this.title,
    required this.compact,
    required this.beatRow,
    this.trailing,
    this.onPressed,
  });

  final String title;
  final bool compact;
  final Widget beatRow;
  final Widget? trailing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerChildren = <Widget>[
      Expanded(
        child: Text(title, style: ChordestUiTokens.overlineStyle(theme)),
      ),
    ];
    if (trailing != null) {
      headerChildren.add(trailing!);
    }
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme, accent: true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        // Compact vertical rhythm matters because this strip sits above the main card.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: headerChildren),
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: ChordestUiTokens.radius(20),
                onTap: onPressed,
                child: Ink(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 10,
                    vertical: compact ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.56),
                    borderRadius: ChordestUiTokens.radius(20),
                  ),
                  child: Center(child: beatRow),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportControlsCard extends StatelessWidget {
  const _TransportControlsCard({
    required this.compact,
    required this.title,
    required this.autoRunning,
    required this.startTooltip,
    required this.pauseTooltip,
    required this.resetTooltip,
    required this.onToggleAutoplay,
    required this.onResetGeneratedChords,
  });

  final bool compact;
  final String title;
  final bool autoRunning;
  final String startTooltip;
  final String pauseTooltip;
  final String resetTooltip;
  final VoidCallback onToggleAutoplay;
  final VoidCallback onResetGeneratedChords;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        // The control group should stay tappable but still fit on smaller desktop heights.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ChordestUiTokens.overlineStyle(theme)),
            const SizedBox(height: 8),
            if (compact) ...[
              _TransportActionButton(
                tooltip: autoRunning ? pauseTooltip : startTooltip,
                icon: autoRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                label: autoRunning ? pauseTooltip : startTooltip,
                selected: autoRunning,
                compact: true,
                buttonKey: const ValueKey('practice-autoplay-button'),
                onPressed: onToggleAutoplay,
              ),
              const SizedBox(height: 8),
              _TransportActionButton(
                tooltip: resetTooltip,
                icon: Icons.stop_rounded,
                label: resetTooltip,
                compact: true,
                buttonKey: const ValueKey(
                  'practice-reset-generated-chords-button',
                ),
                onPressed: onResetGeneratedChords,
              ),
            ] else ...[
              _TransportActionButton(
                tooltip: autoRunning ? pauseTooltip : startTooltip,
                icon: autoRunning
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                label: autoRunning ? pauseTooltip : startTooltip,
                selected: autoRunning,
                buttonKey: const ValueKey('practice-autoplay-button'),
                onPressed: onToggleAutoplay,
              ),
              const SizedBox(height: 8),
              _TransportActionButton(
                tooltip: resetTooltip,
                icon: Icons.stop_rounded,
                label: resetTooltip,
                buttonKey: const ValueKey(
                  'practice-reset-generated-chords-button',
                ),
                onPressed: onResetGeneratedChords,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransportActionButton extends StatelessWidget {
  const _TransportActionButton({
    required this.tooltip,
    required this.icon,
    required this.label,
    this.selected = false,
    this.compact = false,
    this.buttonKey,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final String label;
  final bool selected;
  final bool compact;
  final Key? buttonKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Tooltip(
      message: tooltip,
      child: FilledButton.tonalIcon(
        key: buttonKey,
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 12,
            vertical: compact ? 10 : 12,
          ),
          minimumSize: Size.fromHeight(compact ? 40 : 44),
          backgroundColor: selected
              ? colorScheme.primary
              : colorScheme.surface.withValues(alpha: 0.72),
          foregroundColor: selected
              ? colorScheme.onPrimary
              : colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: ChordestUiTokens.radius(18),
            side: BorderSide(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.92),
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        icon: Icon(icon, size: compact ? 18 : 20),
        label: Text(
          compact ? label.split(' ').last : label,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
