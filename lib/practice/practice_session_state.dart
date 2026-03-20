import '../music/chord_timing_models.dart';
import '../music/chord_theory.dart';
import '../music/practice_chord_queue_state.dart';
import '../music/voicing_models.dart';
import '../music/voicing_session_state.dart';
import '../smart_generator.dart';

class PracticeSessionState {
  const PracticeSessionState({
    this.initialized = false,
    this.queueState = const PracticeChordQueueState(),
    this.voicingState = const VoicingSessionState(),
  });

  final bool initialized;
  final PracticeChordQueueState queueState;
  final VoicingSessionState voicingState;

  GeneratedChordEvent? get previousEvent => queueState.previousEvent;
  GeneratedChordEvent? get currentEvent => queueState.currentEvent;
  GeneratedChordEvent? get nextEvent => queueState.nextEvent;
  GeneratedChordEvent? get lookAheadEvent => queueState.lookAheadEvent;

  GeneratedChord? get previousChord => queueState.previousChord;
  GeneratedChord? get currentChord => queueState.currentChord;
  GeneratedChord? get nextChord => queueState.nextChord;
  GeneratedChord? get lookAheadChord => queueState.lookAheadChord;
  List<QueuedSmartChord> get plannedSmartChordQueue =>
      queueState.plannedSmartChordQueue;

  VoicingRecommendationSet? get voicingRecommendations =>
      voicingState.recommendations;
  PerformanceVoicingPreview? get performanceVoicingPreview =>
      voicingRecommendations?.performancePreview;
  ConcreteVoicing? get lockedCurrentVoicing =>
      voicingState.lockedCurrentVoicing;
  ConcreteVoicing? get continuityReferenceVoicing =>
      voicingState.continuityReferenceVoicing;
  ConcreteVoicing? get authoritativeSelectedVoicing =>
      voicingState.authoritativeSelectedVoicing;
  String? get lastLoggedDiagnosticKey => voicingState.lastLoggedDiagnosticKey;

  PracticeSessionState copyWith({
    bool? initialized,
    PracticeChordQueueState? queueState,
    VoicingSessionState? voicingState,
  }) {
    return PracticeSessionState(
      initialized: initialized ?? this.initialized,
      queueState: queueState ?? this.queueState,
      voicingState: voicingState ?? this.voicingState,
    );
  }
}
