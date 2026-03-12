import 'package:flutter/material.dart';

class BeatIndicatorRow extends StatelessWidget {
  const BeatIndicatorRow({
    super.key,
    required this.beatCount,
    required this.activeBeat,
    required this.animationDuration,
  });

  final int beatCount;
  final int? activeBeat;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        beatCount,
        (index) => _BeatCircle(
          active: activeBeat == index,
          animationDuration: animationDuration,
          index: index,
        ),
      ),
    );
  }
}

class _BeatCircle extends StatelessWidget {
  const _BeatCircle({
    required this.active,
    required this.animationDuration,
    required this.index,
  });

  final bool active;
  final Duration animationDuration;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.outlineVariant;

    return AnimatedScale(
      scale: active ? 1.18 : 1,
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        key: ValueKey('beat-circle-$index'),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: 0.95)
                : inactiveColor.withValues(alpha: 0.85),
          ),
          gradient: RadialGradient(
            radius: active ? 0.95 : 0.8,
            colors: active
                ? [
                    activeColor.withValues(alpha: 0.98),
                    activeColor.withValues(alpha: 0.74),
                  ]
                : [
                    inactiveColor.withValues(alpha: 0.82),
                    inactiveColor.withValues(alpha: 0.42),
                  ],
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.34),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
      ),
    );
  }
}
