import 'package:flutter/material.dart';

import '../audio/metronome_audio_models.dart';

class BeatIndicatorRow extends StatelessWidget {
  const BeatIndicatorRow({
    super.key,
    required this.beatCount,
    required this.activeBeat,
    required this.animationDuration,
    this.beatStates,
    this.expanded = false,
    this.onPressed,
    this.onBeatPressed,
  });

  final int beatCount;
  final int? activeBeat;
  final Duration animationDuration;
  final List<MetronomeBeatState>? beatStates;
  final bool expanded;
  final VoidCallback? onPressed;
  final ValueChanged<int>? onBeatPressed;

  @override
  Widget build(BuildContext context) {
    final resolvedStates = beatStates == null
        ? List<MetronomeBeatState>.filled(
            beatCount,
            MetronomeBeatState.normal,
            growable: false,
          )
        : List<MetronomeBeatState>.generate(
            beatCount,
            (index) => index < beatStates!.length
                ? beatStates![index]
                : MetronomeBeatState.normal,
            growable: false,
          );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        beatCount,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: expanded ? 5 : 4),
          child: _BeatCircle(
            active: activeBeat == index,
            state: resolvedStates[index],
            animationDuration: animationDuration,
            index: index,
            expanded: expanded,
            onPressed: onBeatPressed == null
                ? null
                : () => onBeatPressed!(index),
          ),
        ),
      ),
    );

    if (onPressed == null || onBeatPressed != null) {
      return row;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: expanded ? 8 : 4,
            vertical: expanded ? 8 : 4,
          ),
          child: row,
        ),
      ),
    );
  }
}

class _BeatCircle extends StatelessWidget {
  const _BeatCircle({
    required this.active,
    required this.state,
    required this.animationDuration,
    required this.index,
    required this.expanded,
    this.onPressed,
  });

  final bool active;
  final MetronomeBeatState state;
  final Duration animationDuration;
  final int index;
  final bool expanded;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = colorScheme.primary;
    final inactiveColor = colorScheme.outlineVariant;
    final mutedColor = colorScheme.outline.withValues(alpha: 0.75);
    final size = expanded ? 18.0 : 12.0;
    final scale = active
        ? expanded
              ? 1.18
              : 1.12
        : expanded
        ? 1.05
        : 1.0;
    final fillColor = switch (state) {
      MetronomeBeatState.accent => accentColor.withValues(
        alpha: active ? 0.98 : 0.84,
      ),
      MetronomeBeatState.mute => colorScheme.surface,
      MetronomeBeatState.normal =>
        active
            ? accentColor.withValues(alpha: 0.92)
            : inactiveColor.withValues(alpha: 0.46),
    };
    final borderColor = switch (state) {
      MetronomeBeatState.accent => accentColor.withValues(
        alpha: active ? 1 : 0.9,
      ),
      MetronomeBeatState.mute => mutedColor,
      MetronomeBeatState.normal =>
        active
            ? accentColor.withValues(alpha: 0.95)
            : inactiveColor.withValues(alpha: 0.85),
    };
    final glowColor = switch (state) {
      MetronomeBeatState.accent => accentColor.withValues(alpha: 0.3),
      MetronomeBeatState.mute => Colors.transparent,
      MetronomeBeatState.normal => accentColor.withValues(alpha: 0.22),
    };
    final circle = AnimatedScale(
      scale: scale,
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        key: ValueKey('beat-circle-$index'),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: fillColor,
          border: Border.all(color: borderColor, width: expanded ? 1.5 : 1.2),
          boxShadow: active || state == MetronomeBeatState.accent
              ? [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: expanded ? 14 : 10,
                    spreadRadius: active ? 1.2 : 0.4,
                  ),
                ]
              : const [],
        ),
        child: state == MetronomeBeatState.mute
            ? Center(
                child: Container(
                  width: expanded ? 9 : 6,
                  height: 1.8,
                  decoration: BoxDecoration(
                    color: mutedColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              )
            : null,
      ),
    );

    if (onPressed == null) {
      return circle;
    }

    return Material(
      color: Colors.transparent,
      child: InkResponse(
        radius: expanded ? 22 : 18,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(expanded ? 2 : 0),
          child: circle,
        ),
      ),
    );
  }
}
