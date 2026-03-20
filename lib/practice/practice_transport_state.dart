class PracticeTransportState {
  const PracticeTransportState({
    this.autoRunning = false,
    this.currentBeat,
    this.metronomeReady = false,
  });

  final bool autoRunning;
  final int? currentBeat;
  final bool metronomeReady;

  PracticeTransportState copyWith({
    bool? autoRunning,
    int? currentBeat,
    bool clearCurrentBeat = false,
    bool? metronomeReady,
  }) {
    return PracticeTransportState(
      autoRunning: autoRunning ?? this.autoRunning,
      currentBeat: clearCurrentBeat ? null : currentBeat ?? this.currentBeat,
      metronomeReady: metronomeReady ?? this.metronomeReady,
    );
  }
}
