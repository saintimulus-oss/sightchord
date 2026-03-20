import 'package:flutter/material.dart';

import 'practice_chord_swipe_surface.dart';

class PracticeChordDisplaySection extends StatelessWidget {
  const PracticeChordDisplaySection({
    super.key,
    required this.surfaceKey,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.compact,
    required this.performanceMode,
    required this.statusLabel,
    required this.availableBackSteps,
    required this.onTapAdvance,
    required this.onTapGoBack,
    required this.onSwipeAdvance,
    required this.onSwipeGoBack,
    required this.controls,
  });

  final GlobalKey<PracticeChordSwipeSurfaceState> surfaceKey;
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
  Widget build(BuildContext context) {
    return PracticeChordSwipeSurface(
      key: surfaceKey,
      previousLabel: previousLabel,
      currentLabel: currentLabel,
      nextLabel: nextLabel,
      compact: compact,
      performanceMode: performanceMode,
      statusLabel: statusLabel,
      availableBackSteps: availableBackSteps,
      onTapAdvance: onTapAdvance,
      onTapGoBack: onTapGoBack,
      onSwipeAdvance: onSwipeAdvance,
      onSwipeGoBack: onSwipeGoBack,
      controls: controls,
    );
  }
}
