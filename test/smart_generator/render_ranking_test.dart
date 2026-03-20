import 'fixtures.dart';

void main() {
  smartGeneratorTestSetUp();

  test('same-root sus release scoring prefers plain dominant payoff', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = realizeVoiceLed(
      candidate: SmartRenderCandidate(
        keyCenter: center,
        romanNumeralId: RomanNumeralId.vDom7,
        renderQualityOverride: ChordQuality.dominant13sus4,
      ),
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.vDom7,
          dominantContext: DominantContext.primaryMajor,
          dominantIntent: DominantIntent.primaryAuthenticMajor,
          smartDebug: buildTrace(
            currentRomanNumeralId: RomanNumeralId.vDom7,
            currentHarmonicFunction: HarmonicFunction.dominant,
          ),
        ),
      ],
    );
    final plainRelease = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality == ChordQuality.dominant7,
    );
    final susCarry = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality ==
              ChordQuality.dominant13sus4 ||
          candidate.chord.symbolData.renderQuality ==
              ChordQuality.dominant7sus4,
    );

    expect(
      comparison.selected.chord.symbolData.renderQuality,
      ChordQuality.dominant7,
    );
    expect(plainRelease.voiceLeading.sameRootSusPayoffBonus, greaterThan(0));
    expect(
      plainRelease.voiceLeading.total,
      greaterThan(susCarry.voiceLeading.total),
    );
    expect(
      (comparison.selected.chord.smartDebug as SmartDecisionTrace?)
          ?.voiceLeadingSummary,
      isNotNull,
    );
  });

  test(
    'sus override candidates downgrade to dominant7 when V7sus4 is disabled',
    () {
      const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
      final comparison = compareVoiceLeading(
        allowV7sus4: false,
        candidates: const [
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.vDom7,
            renderQualityOverride: ChordQuality.dominant13sus4,
            dominantContext: DominantContext.susDominant,
            dominantIntent: DominantIntent.susDelay,
          ),
        ],
      );

      expect(
        comparison.selected.chord.symbolData.renderQuality,
        ChordQuality.dominant7,
      );
      expect(
        comparison.rankedCandidates.any(
          (candidate) =>
              candidate.chord.symbolData.renderQuality ==
                  ChordQuality.dominant13sus4 ||
              candidate.chord.symbolData.renderQuality ==
                  ChordQuality.dominant7sus4,
        ),
        isFalse,
      );
    },
  );

  test(
    'voice-leading ties stay deterministic by preserving candidate source order',
    () {
      const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
      final comparison = compareVoiceLeading(
        candidates: const [
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.iiMin7,
            renderQualityOverride: ChordQuality.minor7,
          ),
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.iiiMin7,
            renderQualityOverride: ChordQuality.minor7,
          ),
        ],
      );

      expect(comparison.selected.chord.romanNumeralId, RomanNumeralId.iiMin7);
      expect(comparison.rankedCandidates.first.voiceLeading.total, 0);
      expect(comparison.rankedCandidates[1].voiceLeading.total, 0);
    },
  );

  test('quality-implied color tones influence voice-leading ranking', () {
    final previousChord = GeneratedChord(
      symbolData: const ChordSymbolData(
        root: 'A',
        harmonicQuality: ChordQuality.dominant7,
        renderQuality: ChordQuality.dominant7,
      ),
      repeatGuardKey: 'a7',
      harmonicComparisonKey: 'a7',
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      keyName: 'C',
      romanNumeralId: RomanNumeralId.secondaryOfII,
      harmonicFunction: HarmonicFunction.dominant,
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.vDom7,
          renderQualityOverride: ChordQuality.dominant7,
        ),
        SmartRenderCandidate(
          keyCenter: KeyCenter(tonicName: 'C', mode: KeyMode.major),
          romanNumeralId: RomanNumeralId.vDom7,
          renderQualityOverride: ChordQuality.dominant7Sharp11,
          dominantIntent: DominantIntent.lydianDominant,
        ),
      ],
    );
    final plain = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality == ChordQuality.dominant7,
    );
    final sharp11 = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.symbolData.renderQuality ==
          ChordQuality.dominant7Sharp11,
    );

    expect(
      comparison.selected.chord.symbolData.renderQuality,
      ChordQuality.dominant7Sharp11,
    );
    expect(
      sharp11.voiceLeading.commonToneRetentionBonus,
      greaterThan(plain.voiceLeading.commonToneRetentionBonus),
    );
  });

  test('major69 sixth participates in guide-tone resolution scoring', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = GeneratedChord(
      symbolData: const ChordSymbolData(
        root: 'C',
        harmonicQuality: ChordQuality.major69,
        renderQuality: ChordQuality.major69,
      ),
      repeatGuardKey: 'c69GuideTone',
      harmonicComparisonKey: 'c69GuideTone',
      keyCenter: center,
      keyName: 'C',
      romanNumeralId: RomanNumeralId.iMaj69,
      harmonicFunction: HarmonicFunction.tonic,
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.ivMaj7,
        ),
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.borrowedFlatVII7,
        ),
      ],
    );
    final ivArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.ivMaj7,
    );
    final flatVIIArrival = comparison.rankedCandidates.firstWhere(
      (candidate) =>
          candidate.chord.romanNumeralId == RomanNumeralId.borrowedFlatVII7,
    );

    expect(
      flatVIIArrival.voiceLeading.guideToneSemitoneBonus,
      greaterThan(ivArrival.voiceLeading.guideToneSemitoneBonus),
    );
    expect(
      comparison.selected.chord.romanNumeralId,
      RomanNumeralId.borrowedFlatVII7,
    );
  });

  test('guide-tone semitone resolution outranks a weaker alternative path', () {
    const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
    final previousChord = realizeVoiceLed(
      candidate: const SmartRenderCandidate(
        keyCenter: center,
        romanNumeralId: RomanNumeralId.vDom7,
        renderQualityOverride: ChordQuality.dominant7,
      ),
    );

    final comparison = compareVoiceLeading(
      previousChord: previousChord,
      candidates: const [
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iiMin7,
        ),
        SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iMaj7,
        ),
      ],
    );
    final tonicArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.iMaj7,
    );
    final iiArrival = comparison.rankedCandidates.firstWhere(
      (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.iiMin7,
    );

    expect(comparison.selected.chord.romanNumeralId, RomanNumeralId.iMaj7);
    expect(
      tonicArrival.voiceLeading.guideToneSemitoneBonus,
      greaterThan(iiArrival.voiceLeading.guideToneSemitoneBonus),
    );
    expect(
      tonicArrival.voiceLeading.total,
      greaterThan(iiArrival.voiceLeading.total),
    );
  });

  test(
    'large root leap loses to a same-function fallback with smoother motion',
    () {
      const center = KeyCenter(tonicName: 'C', mode: KeyMode.major);
      final previousChord = realizeVoiceLed(
        candidate: const SmartRenderCandidate(
          keyCenter: center,
          romanNumeralId: RomanNumeralId.iiiMin7,
        ),
      );

      final comparison = compareVoiceLeading(
        previousChord: previousChord,
        candidates: const [
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.borrowedFlatVII7,
          ),
          SmartRenderCandidate(
            keyCenter: center,
            romanNumeralId: RomanNumeralId.vDom7,
            renderQualityOverride: ChordQuality.dominant7,
          ),
        ],
      );
      final backdoorDominant = comparison.rankedCandidates.firstWhere(
        (candidate) =>
            candidate.chord.romanNumeralId == RomanNumeralId.borrowedFlatVII7,
      );
      final primaryDominant = comparison.rankedCandidates.firstWhere(
        (candidate) => candidate.chord.romanNumeralId == RomanNumeralId.vDom7,
      );

      expect(comparison.selected.chord.romanNumeralId, RomanNumeralId.vDom7);
      expect(backdoorDominant.voiceLeading.rootLeapPenalty, lessThan(0));
      expect(primaryDominant.voiceLeading.rootLeapPenalty, 0);
      expect(
        primaryDominant.voiceLeading.total,
        greaterThan(backdoorDominant.voiceLeading.total),
      );
    },
  );
}
