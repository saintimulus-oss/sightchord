import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/voicing_models.dart';
import 'package:chordest/music/voicing_session_state.dart';

void main() {
  test('applyRecommendations preserves matching locked voicings', () {
    final locked = _buildVoicing('locked');
    final alternate = _buildVoicing('alternate');
    final state = VoicingSessionState(lockedCurrentVoicing: locked);
    final recommendations = _buildRecommendations([locked, alternate]);

    final updated = state.applyRecommendations(recommendations);

    expect(updated.lockedCurrentVoicing?.signature, locked.signature);
    expect(updated.selectedVoicing?.signature, locked.signature);
    expect(updated.recommendations, same(recommendations));
  });

  test('continuity source falls back to the top suggestion', () {
    final suggested = _buildVoicing('suggested');
    final state = VoicingSessionState(
      recommendations: _buildRecommendations([suggested]),
    );

    expect(state.continuitySourceVoicing?.signature, suggested.signature);
  });

  test(
    'promoting the queue carries forward continuity and clears selection state',
    () {
      final locked = _buildVoicing('locked');
      final promoted = VoicingSessionState(
        recommendations: _buildRecommendations([locked]),
        selectedVoicing: locked,
        lockedCurrentVoicing: locked,
        lastLoggedDiagnosticKey: 'diag',
      ).promoteChordQueue();

      expect(promoted.continuityReferenceVoicing?.signature, locked.signature);
      expect(promoted.recommendations, isNull);
      expect(promoted.selectedVoicing, isNull);
      expect(promoted.lockedCurrentVoicing, isNull);
      expect(promoted.lastLoggedDiagnosticKey, isNull);
    },
  );
}

ConcreteVoicing _buildVoicing(String signature) {
  return ConcreteVoicing(
    midiNotes: const [48, 52, 59, 62],
    noteNames: const ['C', 'E', 'B', 'D'],
    toneLabels: const ['1', '3', '7', '9'],
    tensions: const {'9'},
    family: VoicingFamily.rootlessA,
    topNote: 62,
    bassNote: 48,
    containsRoot: true,
    containsThird: true,
    containsSeventh: true,
    signature: signature,
  );
}

VoicingRecommendationSet _buildRecommendations(List<ConcreteVoicing> voicings) {
  final ranked = [
    for (final voicing in voicings)
      RankedVoicingCandidate(
        voicing: voicing,
        breakdown: const VoicingBreakdown(total: 1),
        naturalScore: 1,
        colorfulScore: 1,
        easyScore: 1,
      ),
  ];
  final suggestions = [
    for (var index = 0; index < voicings.length; index += 1)
      VoicingSuggestion(
        kind: switch (index) {
          0 => VoicingSuggestionKind.natural,
          1 => VoicingSuggestionKind.colorful,
          _ => VoicingSuggestionKind.easy,
        },
        label: 'Suggestion $index',
        shortReasons: const ['test'],
        score: 1,
        voicing: voicings[index],
        breakdown: const VoicingBreakdown(total: 1),
      ),
  ];
  return VoicingRecommendationSet(
    currentChord: _buildChord(),
    interpretation: const ChordVoicingInterpretation(
      root: 'C',
      rootSemitone: 0,
      preferFlatSpelling: false,
      essentialTones: [],
      optionalTones: [],
      avoidTones: [],
      styleTags: {},
    ),
    rankedCandidates: ranked,
    suggestions: suggestions,
  );
}

GeneratedChord _buildChord() {
  return const GeneratedChord(
    symbolData: ChordSymbolData(
      root: 'C',
      harmonicQuality: ChordQuality.major7,
      renderQuality: ChordQuality.major7,
    ),
    repeatGuardKey: 'Cmaj7',
    harmonicComparisonKey: 'C:maj7',
    keyName: 'C',
    keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
    romanNumeralId: RomanNumeralId.iMaj7,
    harmonicFunction: HarmonicFunction.tonic,
  );
}

