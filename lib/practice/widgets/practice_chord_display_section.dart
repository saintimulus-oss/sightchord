import 'package:flutter/material.dart';

import 'practice_chord_swipe_surface.dart';

class PracticeChordDisplaySection extends StatelessWidget {
  const PracticeChordDisplaySection({
    super.key,
    required this.surfaceKey,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.lookAheadLabel,
    required this.compact,
    required this.performanceMode,
    required this.statusLabel,
    required this.currentInsight,
    required this.nextInsight,
    required this.playing,
    required this.beatsPerBar,
    required this.currentBeat,
    required this.prioritizeControls,
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
  final String lookAheadLabel;
  final bool compact;
  final bool performanceMode;
  final String statusLabel;
  final PracticeChordInsight currentInsight;
  final PracticeChordInsight nextInsight;
  final bool playing;
  final int beatsPerBar;
  final int? currentBeat;
  final bool prioritizeControls;
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
      lookAheadLabel: lookAheadLabel,
      compact: compact,
      performanceMode: performanceMode,
      statusLabel: statusLabel,
      currentInsight: currentInsight,
      nextInsight: nextInsight,
      playing: playing,
      beatsPerBar: beatsPerBar,
      currentBeat: currentBeat,
      prioritizeControls: prioritizeControls,
      availableBackSteps: availableBackSteps,
      onTapAdvance: onTapAdvance,
      onTapGoBack: onTapGoBack,
      onSwipeAdvance: onSwipeAdvance,
      onSwipeGoBack: onSwipeGoBack,
      controls: controls,
    );
  }
}
