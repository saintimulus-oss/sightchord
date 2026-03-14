import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/voicing_engine.dart';
import 'package:sightchord/music/voicing_models.dart';
import 'package:sightchord/settings/practice_settings.dart';

GeneratedChord _buildChord({
  required String root,
  required ChordQuality quality,
  required String repeatKey,
  required RomanNumeralId? romanNumeralId,
  KeyCenter? keyCenter,
  List<String> tensions = const [],
  String? bass,
  HarmonicFunction harmonicFunction = HarmonicFunction.free,
  DominantContext? dominantContext,
  DominantIntent? dominantIntent,
}) {
  return GeneratedChord(
    symbolData: ChordSymbolData(
      root: root,
      harmonicQuality: quality,
      renderQuality: quality,
      tensions: tensions,
      bass: bass,
    ),
    repeatGuardKey: repeatKey,
    harmonicComparisonKey: repeatKey,
    keyName: keyCenter?.tonicName,
    keyCenter: keyCenter,
    romanNumeralId: romanNumeralId,
    harmonicFunction: harmonicFunction,
    dominantContext: dominantContext,
    dominantIntent: dominantIntent,
  );
}

void main() {
  final settings = PracticeSettings(
    activeKeys: const {'C', 'A'},
    allowTensions: true,
    voicingSuggestionsEnabled: true,
    allowRootlessVoicings: true,
    maxVoicingNotes: 4,
    lookAheadDepth: 1,
  );

  test('ii-V-I suggestions are stable and diverse', () {
    final dm7 = _buildChord(
      root: 'D',
      quality: ChordQuality.minor7,
      repeatKey: 'dm7',
      romanNumeralId: RomanNumeralId.iiMin7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.predominant,
    );
    final g7 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );
    final cmaj7 = _buildChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cmaj7',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final context = VoicingContext(
      previousChord: dm7,
      currentChord: g7,
      nextChord: cmaj7,
      settings: settings,
      lookAheadDepth: 1,
    );

    final first = VoicingEngine.recommend(context: context);
    final second = VoicingEngine.recommend(context: context);

    expect(first.suggestions, hasLength(3));
    expect(
      first.suggestions
          .map((suggestion) => suggestion.voicing.signature)
          .toSet(),
      hasLength(3),
    );
    expect(
      first.suggestions
          .map((suggestion) => suggestion.voicing.family)
          .toSet()
          .length,
      greaterThanOrEqualTo(2),
    );
    expect(
      first.suggestions
          .map((suggestion) => suggestion.voicing.signature)
          .toList(),
      second.suggestions
          .map((suggestion) => suggestion.voicing.signature)
          .toList(),
    );
  });

  test(
    'same display-only settings keep recommendation order deterministic',
    () {
      final g7 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'g7',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
      );
      final cmaj7 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cmaj7',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
      );
      final dmin7 = _buildChord(
        root: 'D',
        quality: ChordQuality.minor7,
        repeatKey: 'dm7',
        romanNumeralId: RomanNumeralId.iiMin7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.predominant,
      );

      final visibleReasons = VoicingEngine.recommend(
        context: VoicingContext(
          previousChord: dmin7,
          currentChord: g7,
          nextChord: cmaj7,
          settings: settings.copyWith(showVoicingReasons: true),
          lookAheadDepth: 1,
        ),
      );
      final hiddenReasons = VoicingEngine.recommend(
        context: VoicingContext(
          previousChord: dmin7,
          currentChord: g7,
          nextChord: cmaj7,
          settings: settings.copyWith(showVoicingReasons: false),
          lookAheadDepth: 1,
        ),
      );

      expect(
        visibleReasons.suggestions
            .map((suggestion) => suggestion.voicing.signature)
            .toList(),
        hiddenReasons.suggestions
            .map((suggestion) => suggestion.voicing.signature)
            .toList(),
      );
    },
  );

  test('modern minor contexts open quartal candidates only in modern mode', () {
    final dm7 = _buildChord(
      root: 'D',
      quality: ChordQuality.minor7,
      repeatKey: 'dm7',
      romanNumeralId: RomanNumeralId.iiMin7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.predominant,
    );

    final standardFamilies = VoicingEngine.generateCandidates(
      chord: dm7,
      settings: settings.copyWith(
        voicingComplexity: VoicingComplexity.standard,
      ),
    ).map((voicing) => voicing.family).toSet();
    final modernFamilies = VoicingEngine.generateCandidates(
      chord: dm7,
      settings: settings.copyWith(voicingComplexity: VoicingComplexity.modern),
    ).map((voicing) => voicing.family).toSet();

    expect(standardFamilies, isNot(contains(VoicingFamily.quartal)));
    expect(modernFamilies, contains(VoicingFamily.quartal));
  });

  test(
    'modern lydian and altered dominants open upper-structure candidates only in modern mode',
    () {
      final g7Sharp11 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'g7Sharp11',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        dominantContext: DominantContext.dominantIILydian,
        dominantIntent: DominantIntent.lydianDominant,
      );
      final cmaj7 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cmaj7',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
      );

      final standardFamilies = VoicingEngine.generateCandidates(
        chord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.standard,
        ),
      ).map((voicing) => voicing.family).toSet();
      final modernFamilies = VoicingEngine.generateCandidates(
        chord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ).map((voicing) => voicing.family).toSet();
      final modernResult = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
        ),
      );
      final majorFamilies = VoicingEngine.generateCandidates(
        chord: cmaj7,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ).map((voicing) => voicing.family).toSet();

      expect(standardFamilies, isNot(contains(VoicingFamily.upperStructure)));
      expect(modernFamilies, contains(VoicingFamily.upperStructure));
      expect(majorFamilies, isNot(contains(VoicingFamily.upperStructure)));
      expect(
        modernResult
            .suggestionFor(VoicingSuggestionKind.colorful)!
            .voicing
            .family,
        VoicingFamily.upperStructure,
      );
      expect(
        modernResult
            .suggestionFor(VoicingSuggestionKind.natural)!
            .voicing
            .family,
        isNot(VoicingFamily.upperStructure),
      );
    },
  );

  test('look-ahead contributes a positive cadence bonus', () {
    final g7 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );
    final cmaj7 = _buildChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cmaj7',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7,
        nextChord: cmaj7,
        settings: settings,
        lookAheadDepth: 1,
      ),
    );

    expect(
      result.suggestions.first.breakdown.nextChordLookAheadBonus,
      greaterThan(0),
    );
  });

  test('slash bass anchor is respected in the natural suggestion', () {
    final cOverE = _buildChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cOverE',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
      bass: 'E',
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(currentChord: cOverE, settings: settings),
    );
    final naturalSuggestion = result.suggestionFor(
      VoicingSuggestionKind.natural,
    );

    expect(naturalSuggestion, isNotNull);
    expect(naturalSuggestion!.voicing.noteNames.first, 'E');
    expect(naturalSuggestion.breakdown.bassAnchorMatched, isTrue);
  });

  test('major69 suggestions keep the ninth present', () {
    final c69 = _buildChord(
      root: 'C',
      quality: ChordQuality.major69,
      repeatKey: 'c69',
      romanNumeralId: RomanNumeralId.iMaj69,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(currentChord: c69, settings: settings),
    );

    expect(result.suggestions, isNotEmpty);
    for (final suggestion in result.suggestions) {
      expect(suggestion.voicing.toneLabels, contains('9'));
    }
  });

  test(
    'explicit tensions stay present even when normally treated as avoids',
    () {
      final cMaj11 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cMaj11',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
        tensions: const ['11'],
      );

      final result = VoicingEngine.recommend(
        context: VoicingContext(currentChord: cMaj11, settings: settings),
      );

      expect(result.suggestions, isNotEmpty);
      for (final suggestion in result.suggestions) {
        expect(suggestion.voicing.toneLabels, contains('11'));
      }
    },
  );

  test(
    'multi-tension chords still surface suggestions when max voicing notes is tight',
    () {
      final cMaj79and13 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cMaj79and13',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
        tensions: const ['9', '13'],
      );

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: cMaj79and13,
          settings: settings.copyWith(maxVoicingNotes: 3),
        ),
      );

      expect(result.suggestions, isNotEmpty);
      for (final suggestion in result.suggestions) {
        expect(suggestion.voicing.noteCount, lessThanOrEqualTo(3));
        expect(
          suggestion.voicing.toneLabels.any(
            (label) => label == '9' || label == '13',
          ),
          isTrue,
        );
      }
    },
  );

  test(
    'tight substitute dominant settings fall back to a playable shell instead of hiding suggestions',
    () {
      final eb7b9 = _buildChord(
        root: 'Eb',
        quality: ChordQuality.dominant7,
        repeatKey: 'eb7b9-tight-shell',
        romanNumeralId: RomanNumeralId.substituteOfII,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        tensions: const ['b9'],
      );

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: eb7b9,
          settings: settings.copyWith(
            allowRootlessVoicings: false,
            maxVoicingNotes: 3,
          ),
        ),
      );

      expect(result.suggestions, isNotEmpty);
      for (final suggestion in result.suggestions) {
        expect(suggestion.voicing.noteCount, lessThanOrEqualTo(3));
        expect(suggestion.voicing.containsRoot, isTrue);
        expect(suggestion.voicing.containsThird, isTrue);
        expect(suggestion.voicing.containsSeventh, isTrue);
      }
    },
  );

  test('rootless candidates retain explicit sharp11 color', () {
    final cMajSharp11 = _buildChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cMajSharp11',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
      tensions: const ['#11'],
    );

    final rootlessCandidates = VoicingEngine.generateCandidates(
      chord: cMajSharp11,
      settings: settings,
    ).where((candidate) => candidate.isRootless).toList(growable: false);

    expect(rootlessCandidates, isNotEmpty);
    for (final candidate in rootlessCandidates) {
      expect(candidate.toneLabels, contains('#11'));
    }
  });

  test('dominant13sus suggestions keep the thirteenth present', () {
    final g13sus = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant13sus4,
      repeatKey: 'g13sus',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.susDominant,
      dominantIntent: DominantIntent.susDelay,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(currentChord: g13sus, settings: settings),
    );

    expect(result.suggestions, isNotEmpty);
    for (final suggestion in result.suggestions) {
      expect(suggestion.voicing.toneLabels, contains('13'));
    }
  });

  test('locked voicing is preserved on rebuild for the same chord', () {
    final g7 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );

    final first = VoicingEngine.recommend(
      context: VoicingContext(currentChord: g7, settings: settings),
    );
    final lockedVoicing = first.suggestions.first.voicing;

    final relocked = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7,
        settings: settings,
        lockedVoicing: lockedVoicing,
      ),
    );
    final lockedSuggestion = relocked.suggestions.where((item) => item.locked);

    expect(lockedSuggestion, isNotEmpty);
    expect(lockedSuggestion.first.voicing.signature, lockedVoicing.signature);
    expect(
      relocked
          .candidateBySignature(lockedVoicing.signature)!
          .breakdown
          .lockContinuityBonus,
      greaterThan(0),
    );
  });

  test('locked voicing stays visible as the authoritative card choice', () {
    final g7Sharp11 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7Sharp11,
      repeatKey: 'g7Sharp11Locked',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.dominantIILydian,
      dominantIntent: DominantIntent.lydianDominant,
    );
    final initial = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final lockedVoicing = initial
        .suggestionFor(VoicingSuggestionKind.colorful)!
        .voicing;

    final relocked = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
        lockedVoicing: lockedVoicing,
      ),
    );

    expect(
      relocked.suggestions.any(
        (suggestion) => suggestion.voicing.signature == lockedVoicing.signature,
      ),
      isTrue,
    );
    expect(
      relocked.suggestionFor(VoicingSuggestionKind.natural)!.voicing.signature,
      lockedVoicing.signature,
    );
    expect(
      relocked.suggestionFor(VoicingSuggestionKind.natural)!.locked,
      isTrue,
    );
  });

  test('same chord repetition prefers the previous voicing shape', () {
    final cmaj7 = _buildChord(
      root: 'C',
      quality: ChordQuality.major7,
      repeatKey: 'cmaj7',
      romanNumeralId: RomanNumeralId.iMaj7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final firstPass = VoicingEngine.recommend(
      context: VoicingContext(currentChord: cmaj7, settings: settings),
    );
    final carriedVoicing = firstPass
        .suggestionFor(VoicingSuggestionKind.natural)!
        .voicing;

    final repeated = VoicingEngine.recommend(
      context: VoicingContext(
        previousChord: cmaj7,
        currentChord: cmaj7,
        previousVoicing: carriedVoicing,
        settings: settings,
      ),
    );
    final naturalSuggestion = repeated.suggestionFor(
      VoicingSuggestionKind.natural,
    );

    expect(naturalSuggestion, isNotNull);
    expect(naturalSuggestion!.voicing.signature, carriedVoicing.signature);
    expect(
      repeated
          .candidateBySignature(carriedVoicing.signature)!
          .breakdown
          .sameHarmonyStabilityBonus,
      greaterThan(0),
    );
  });

  test(
    'modern colorful cards can prefer quartal color while natural and easy stay practical',
    () {
      final dm7 = _buildChord(
        root: 'D',
        quality: ChordQuality.minor7,
        repeatKey: 'dm7',
        romanNumeralId: RomanNumeralId.iiMin7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.predominant,
      );

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: dm7,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
        ),
      );

      expect(
        result.suggestionFor(VoicingSuggestionKind.colorful)!.voicing.family,
        VoicingFamily.quartal,
      );
      expect(
        result.suggestionFor(VoicingSuggestionKind.colorful)!.reasonTags,
        contains(VoicingReasonTag.quartalColor),
      );
      expect(
        result.suggestionFor(VoicingSuggestionKind.natural)!.voicing.family,
        isNot(anyOf(VoicingFamily.quartal, VoicingFamily.upperStructure)),
      );
      expect(
        result.suggestionFor(VoicingSuggestionKind.easy)!.voicing.family,
        isNot(anyOf(VoicingFamily.quartal, VoicingFamily.upperStructure)),
      );
    },
  );

  test('modern sus contexts can surface quartal colorful voicings', () {
    final g7sus = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7sus4,
      repeatKey: 'g7sus',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.susDominant,
      dominantIntent: DominantIntent.susDelay,
    );

    final modernResult = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7sus,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final standardFamilies = VoicingEngine.generateCandidates(
      chord: g7sus,
      settings: settings.copyWith(
        voicingComplexity: VoicingComplexity.standard,
      ),
    ).map((voicing) => voicing.family).toSet();

    expect(standardFamilies, isNot(contains(VoicingFamily.quartal)));
    expect(
      modernResult
          .suggestionFor(VoicingSuggestionKind.colorful)!
          .voicing
          .family,
      VoicingFamily.quartal,
    );
  });

  test('minor ii-V-i altered dominant includes altered color', () {
    final bm7b5 = _buildChord(
      root: 'B',
      quality: ChordQuality.halfDiminished7,
      repeatKey: 'bm7b5',
      romanNumeralId: RomanNumeralId.iiHalfDiminishedMinor,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.predominant,
    );
    final e7alt = _buildChord(
      root: 'E',
      quality: ChordQuality.dominant7Alt,
      repeatKey: 'e7alt',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.primaryMinor,
      dominantIntent: DominantIntent.primaryAuthenticMinor,
    );
    final am6 = _buildChord(
      root: 'A',
      quality: ChordQuality.minor6,
      repeatKey: 'am6',
      romanNumeralId: RomanNumeralId.iMin6,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(
        previousChord: bm7b5,
        currentChord: e7alt,
        nextChord: am6,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
        lookAheadDepth: 1,
      ),
    );

    expect(
      result.suggestions.first.voicing.tensions.any(
        (label) =>
            label == 'b9' || label == '#9' || label == '#11' || label == 'b13',
      ),
      isTrue,
    );
  });

  test('same modern quartal context remains stable across repeats', () {
    final dm7 = _buildChord(
      root: 'D',
      quality: ChordQuality.minor7,
      repeatKey: 'dm7',
      romanNumeralId: RomanNumeralId.iiMin7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.predominant,
    );

    final firstPass = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: dm7,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final colorful = firstPass.suggestionFor(VoicingSuggestionKind.colorful)!;

    final repeated = VoicingEngine.recommend(
      context: VoicingContext(
        previousChord: dm7,
        currentChord: dm7,
        previousVoicing: colorful.voicing,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );

    expect(colorful.voicing.family, VoicingFamily.quartal);
    expect(
      repeated.suggestionFor(VoicingSuggestionKind.colorful)!.voicing.signature,
      colorful.voicing.signature,
    );
  });

  test('modern easy card stays piano-practical on altered dominant', () {
    final e7alt = _buildChord(
      root: 'E',
      quality: ChordQuality.dominant7Alt,
      repeatKey: 'e7alt',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.primaryMinor,
      dominantIntent: DominantIntent.primaryAuthenticMinor,
    );
    final am6 = _buildChord(
      root: 'A',
      quality: ChordQuality.minor6,
      repeatKey: 'am6',
      romanNumeralId: RomanNumeralId.iMin6,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.tonic,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: e7alt,
        nextChord: am6,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final easySuggestion = result.suggestionFor(VoicingSuggestionKind.easy)!;

    expect(easySuggestion.voicing.family, isNot(VoicingFamily.upperStructure));
    expect(easySuggestion.voicing.family, isNot(VoicingFamily.quartal));
    expect(easySuggestion.voicing.noteCount, lessThanOrEqualTo(4));
    expect(easySuggestion.breakdown.lowRegisterMudPenalty, 0);
    expect(easySuggestion.breakdown.pianoPlayabilityAdjustment, greaterThan(0));
    expect(easySuggestion.breakdown.handSpanSemitones, lessThanOrEqualTo(15));
  });

  test('tritone-sub flavor appears only in tritone-sub dominant contexts', () {
    final db7Sharp11 = _buildChord(
      root: 'Db',
      quality: ChordQuality.dominant7Sharp11,
      repeatKey: 'db7Sharp11',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.tritoneSubstitute,
      dominantIntent: DominantIntent.tritoneSub,
    );
    final g7Sharp11 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7Sharp11,
      repeatKey: 'g7Sharp11Lydian',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.dominantIILydian,
      dominantIntent: DominantIntent.lydianDominant,
    );

    final tritoneResult = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: db7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final lydianResult = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );

    expect(
      tritoneResult.suggestionFor(VoicingSuggestionKind.colorful)!.reasonTags,
      contains(VoicingReasonTag.tritoneSubFlavor),
    );
    expect(
      lydianResult.suggestionFor(VoicingSuggestionKind.colorful)!.reasonTags,
      isNot(contains(VoicingReasonTag.tritoneSubFlavor)),
    );
  });

  test(
    'plain modern dominant does not over-open upper-structure candidates',
    () {
      final g7 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'g7plain',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
      );

      final families = VoicingEngine.generateCandidates(
        chord: g7,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ).map((voicing) => voicing.family).toSet();

      expect(families, isNot(contains(VoicingFamily.upperStructure)));
      expect(families, isNot(contains(VoicingFamily.quartal)));
    },
  );

  test(
    'top-note preference hook can bias colorful suggestion when requested',
    () {
      final g7Sharp11 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'g7Sharp11',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        dominantContext: DominantContext.dominantIILydian,
        dominantIntent: DominantIntent.lydianDominant,
      );

      final defaultResult = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
        ),
      );
      final preferredResult = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
          preferredTopNotePitchClass: 4,
        ),
      );

      expect(
        defaultResult
            .suggestionFor(VoicingSuggestionKind.colorful)!
            .voicing
            .signature,
        VoicingEngine.recommend(
          context: VoicingContext(
            currentChord: g7Sharp11,
            settings: settings.copyWith(
              voicingComplexity: VoicingComplexity.modern,
            ),
          ),
        ).suggestionFor(VoicingSuggestionKind.colorful)!.voicing.signature,
      );
      expect(
        preferredResult
            .suggestionFor(VoicingSuggestionKind.colorful)!
            .voicing
            .topNotePitchClass,
        4,
      );
      expect(
        preferredResult
            .suggestionFor(VoicingSuggestionKind.colorful)!
            .breakdown
            .topNotePreferenceBonus,
        greaterThan(0),
      );
    },
  );

  test('explicit top-note preference stays deterministic across runs', () {
    final g7Sharp11 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7Sharp11,
      repeatKey: 'g7Sharp11Deterministic',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.dominantIILydian,
      dominantIntent: DominantIntent.lydianDominant,
    );
    final context = VoicingContext(
      currentChord: g7Sharp11,
      settings: settings.copyWith(voicingComplexity: VoicingComplexity.modern),
      preferredTopNotePitchClass: 4,
    );

    final first = VoicingEngine.recommend(context: context);
    final second = VoicingEngine.recommend(context: context);

    expect(
      [
        for (final suggestion in first.suggestions)
          suggestion.voicing.signature,
      ],
      [
        for (final suggestion in second.suggestions)
          suggestion.voicing.signature,
      ],
    );
    expect(first.effectiveTopNotePitchClass, 4);
    expect(first.topNoteSource, VoicingTopNoteSource.explicitPreference);
  });

  test(
    'locked continuity overrides explicit top-note preference conflicts',
    () {
      final dm7 = _buildChord(
        root: 'D',
        quality: ChordQuality.minor7,
        repeatKey: 'dm7LockedTop',
        romanNumeralId: RomanNumeralId.iiMin7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.predominant,
      );
      final first = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: dm7,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
        ),
      );
      final lockedVoicing = first
          .suggestionFor(VoicingSuggestionKind.natural)!
          .voicing;
      final conflictingPitchClass = (lockedVoicing.topNotePitchClass + 1) % 12;

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: dm7,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
          lockedVoicing: lockedVoicing,
          preferredTopNotePitchClass: conflictingPitchClass,
        ),
      );

      expect(result.topNoteSource, VoicingTopNoteSource.lockedContinuity);
      expect(
        result.effectiveTopNotePitchClass,
        lockedVoicing.topNotePitchClass,
      );
      expect(
        result
            .candidateBySignature(lockedVoicing.signature)!
            .breakdown
            .lockContinuityBonus,
        greaterThan(0),
      );
    },
  );

  test(
    'locked voicing stays authoritative across same-chord settings changes',
    () {
      final g7Sharp11 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'g7Sharp11LockFallback',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        dominantContext: DominantContext.dominantIILydian,
        dominantIntent: DominantIntent.lydianDominant,
      );

      final initial = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
            maxVoicingNotes: 4,
          ),
        ),
      );
      final lockedVoicing = initial
          .suggestionFor(VoicingSuggestionKind.colorful)!
          .voicing;
      final preferredTopNotePitchClass = initial
          .suggestionFor(VoicingSuggestionKind.natural)!
          .voicing
          .topNotePitchClass;

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.standard,
            maxVoicingNotes: 4,
          ),
          lockedVoicing: lockedVoicing,
          preferredTopNotePitchClass: preferredTopNotePitchClass,
        ),
      );

      expect(
        result.suggestions.any(
          (suggestion) =>
              suggestion.voicing.signature == lockedVoicing.signature,
        ),
        isTrue,
      );
      expect(result.topNoteSource, VoicingTopNoteSource.lockedContinuity);
      expect(
        result.effectiveTopNotePitchClass,
        lockedVoicing.topNotePitchClass,
      );
    },
  );

  test(
    'explicit top-note preference takes over when locked voicing is stale',
    () {
      final dm7 = _buildChord(
        root: 'D',
        quality: ChordQuality.minor7,
        repeatKey: 'dm7LockSource',
        romanNumeralId: RomanNumeralId.iiMin7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.predominant,
      );
      final g7Sharp11 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7Sharp11,
        repeatKey: 'g7Sharp11StaleLock',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
        dominantContext: DominantContext.dominantIILydian,
        dominantIntent: DominantIntent.lydianDominant,
      );

      final staleLock = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: dm7,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
          ),
        ),
      ).suggestionFor(VoicingSuggestionKind.natural)!.voicing;
      final preferredTopNotePitchClass = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.standard,
            maxVoicingNotes: 4,
          ),
        ),
      ).suggestionFor(VoicingSuggestionKind.natural)!.voicing.topNotePitchClass;

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7Sharp11,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.standard,
            maxVoicingNotes: 4,
          ),
          lockedVoicing: staleLock,
          preferredTopNotePitchClass: preferredTopNotePitchClass,
        ),
      );

      expect(
        result.suggestions.any(
          (suggestion) => suggestion.voicing.signature == staleLock.signature,
        ),
        isFalse,
      );
      expect(result.topNoteSource, VoicingTopNoteSource.explicitPreference);
      expect(result.effectiveTopNotePitchClass, preferredTopNotePitchClass);
    },
  );

  test('same-harmony repeat exposes stable repeat reason tags', () {
    final dm7 = _buildChord(
      root: 'D',
      quality: ChordQuality.minor7,
      repeatKey: 'dm7',
      romanNumeralId: RomanNumeralId.iiMin7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.predominant,
    );

    final first = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: dm7,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final natural = first.suggestionFor(VoicingSuggestionKind.natural)!;
    final repeated = VoicingEngine.recommend(
      context: VoicingContext(
        previousChord: dm7,
        currentChord: dm7,
        previousVoicing: natural.voicing,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );

    expect(
      repeated.suggestionFor(VoicingSuggestionKind.natural)!.reasonTags,
      contains(VoicingReasonTag.stableRepeat),
    );
    expect(
      repeated
          .suggestionFor(VoicingSuggestionKind.natural)!
          .breakdown
          .sameHarmonyStabilityBonus,
      greaterThan(0),
    );
  });

  test(
    'modern easy and natural cards avoid cramped low-root comping shapes',
    () {
      final g7 = _buildChord(
        root: 'G',
        quality: ChordQuality.dominant7,
        repeatKey: 'g7Comping',
        romanNumeralId: RomanNumeralId.vDom7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.dominant,
      );
      final cmaj7 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cmaj7Comping',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
      );

      bool isLowRootDenseCluster(ConcreteVoicing voicing) {
        if (!voicing.containsRoot || voicing.noteCount < 4) {
          return false;
        }
        final notes = voicing.midiNotes;
        return (notes[0] <= 43 && (notes[3] - notes[0]) <= 14) ||
            (notes[0] <= 41 && (notes[2] - notes[0]) <= 9);
      }

      bool isWideRootlessTopCluster(ConcreteVoicing voicing) {
        if (!voicing.isRootless || voicing.noteCount < 4) {
          return false;
        }
        final notes = voicing.midiNotes;
        final upperStartIndex = notes.length - 3;
        return (voicing.topNote - voicing.bassNote) >= 15 &&
            (notes[upperStartIndex] - notes[upperStartIndex - 1]) >= 6 &&
            (voicing.topNote - notes[upperStartIndex]) <= 4;
      }

      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: g7,
          nextChord: cmaj7,
          settings: settings.copyWith(
            voicingComplexity: VoicingComplexity.modern,
            maxVoicingNotes: 4,
          ),
        ),
      );

      final natural = result.suggestionFor(VoicingSuggestionKind.natural)!;
      final easy = result.suggestionFor(VoicingSuggestionKind.easy)!;

      expect(isLowRootDenseCluster(natural.voicing), isFalse);
      expect(isLowRootDenseCluster(easy.voicing), isFalse);
      expect(isWideRootlessTopCluster(easy.voicing), isFalse);
    },
  );

  test(
    'impossible explicit top-note preference falls back gracefully and stays deterministic',
    () {
      final cmaj7 = _buildChord(
        root: 'C',
        quality: ChordQuality.major7,
        repeatKey: 'cmaj7ImpossibleTop',
        romanNumeralId: RomanNumeralId.iMaj7,
        keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        harmonicFunction: HarmonicFunction.tonic,
      );
      final availableTopNotes = VoicingEngine.generateCandidates(
        chord: cmaj7,
        settings: settings,
      ).map((voicing) => voicing.topNotePitchClass).toSet();
      final impossiblePitchClass = List<int>.generate(12, (index) => index)
          .firstWhere(
            (pitchClass) => !availableTopNotes.contains(pitchClass),
            orElse: () => -1,
          );

      expect(impossiblePitchClass, isNot(-1));

      final context = VoicingContext(
        currentChord: cmaj7,
        settings: settings,
        preferredTopNotePitchClass: impossiblePitchClass,
      );
      final first = VoicingEngine.recommend(context: context);
      final second = VoicingEngine.recommend(context: context);

      expect(first.topNoteSource, VoicingTopNoteSource.explicitPreference);
      expect(first.topNoteMatch, isNot(VoicingTopNoteMatch.exact));
      expect(
        first.suggestions.any(
          (suggestion) =>
              suggestion.voicing.topNotePitchClass == impossiblePitchClass,
        ),
        isFalse,
      );
      expect(
        [
          for (final suggestion in first.suggestions)
            suggestion.voicing.signature,
        ],
        [
          for (final suggestion in second.suggestions)
            suggestion.voicing.signature,
        ],
      );
    },
  );

  test('altered dominant note naming stays consistent with accidentals', () {
    final bb7alt = _buildChord(
      root: 'Bb',
      quality: ChordQuality.dominant7Alt,
      repeatKey: 'bb7alt',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'Eb', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      tensions: const ['b9', '#9', '#11', 'b13'],
      dominantContext: DominantContext.secondaryToMajor,
      dominantIntent: DominantIntent.secondaryToMajor,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: bb7alt,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
      ),
    );
    final colorfulSuggestion = result.suggestionFor(
      VoicingSuggestionKind.colorful,
    );

    expect(colorfulSuggestion, isNotNull);
    for (
      var index = 0;
      index < colorfulSuggestion!.voicing.toneLabels.length;
      index += 1
    ) {
      final label = colorfulSuggestion.voicing.toneLabels[index];
      final noteName = colorfulSuggestion.voicing.noteNames[index];
      expect(noteName.contains('##') || noteName.contains('bb'), isFalse);
      if (label.startsWith('b')) {
        expect(noteName.contains('#'), isFalse);
      }
      if (label.startsWith('#')) {
        expect(noteName.contains('b'), isFalse);
      }
    }
  });

  test('modern complexity keeps at least as much altered color as basic', () {
    final e7alt = _buildChord(
      root: 'E',
      quality: ChordQuality.dominant7Alt,
      repeatKey: 'e7alt',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.primaryMinor,
      dominantIntent: DominantIntent.primaryAuthenticMinor,
    );
    final am6 = _buildChord(
      root: 'A',
      quality: ChordQuality.minor6,
      repeatKey: 'am6',
      romanNumeralId: RomanNumeralId.iMin6,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.tonic,
    );

    int alteredCountFor(VoicingComplexity complexity) {
      final result = VoicingEngine.recommend(
        context: VoicingContext(
          currentChord: e7alt,
          nextChord: am6,
          settings: settings.copyWith(voicingComplexity: complexity),
        ),
      );
      return result
          .suggestionFor(VoicingSuggestionKind.colorful)!
          .voicing
          .tensions
          .where(
            (label) =>
                label == 'b9' ||
                label == '#9' ||
                label == '#11' ||
                label == 'b13',
          )
          .length;
    }

    expect(
      alteredCountFor(VoicingComplexity.modern),
      greaterThanOrEqualTo(alteredCountFor(VoicingComplexity.basic)),
    );
  });

  test('compact altered dominant variants stay gated to altered contexts', () {
    final g7 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7,
      repeatKey: 'g7PlainForAlteredGate',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'C', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
    );
    final e7alt = _buildChord(
      root: 'E',
      quality: ChordQuality.dominant7Alt,
      repeatKey: 'e7altAlteredGate',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'A', mode: KeyMode.minor),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.primaryMinor,
      dominantIntent: DominantIntent.primaryAuthenticMinor,
    );

    final plainAlteredCount = VoicingEngine.generateCandidates(
      chord: g7,
      settings: settings.copyWith(voicingComplexity: VoicingComplexity.modern),
    ).where((voicing) => voicing.family == VoicingFamily.altered).length;
    final alteredContextCount = VoicingEngine.generateCandidates(
      chord: e7alt,
      settings: settings.copyWith(voicingComplexity: VoicingComplexity.modern),
    ).where((voicing) => voicing.family == VoicingFamily.altered).length;

    expect(plainAlteredCount, lessThan(alteredContextCount));
    expect(alteredContextCount, greaterThanOrEqualTo(2));
  });

  test('explicit top-note preference keeps modern dominant cards distinct', () {
    final g7Sharp11 = _buildChord(
      root: 'G',
      quality: ChordQuality.dominant7Sharp11,
      repeatKey: 'g7Sharp11CardDiversity',
      romanNumeralId: RomanNumeralId.vDom7,
      keyCenter: const KeyCenter(tonicName: 'D', mode: KeyMode.major),
      harmonicFunction: HarmonicFunction.dominant,
      dominantContext: DominantContext.dominantIILydian,
      dominantIntent: DominantIntent.lydianDominant,
    );

    final result = VoicingEngine.recommend(
      context: VoicingContext(
        currentChord: g7Sharp11,
        settings: settings.copyWith(
          voicingComplexity: VoicingComplexity.modern,
        ),
        preferredTopNotePitchClass: 4,
      ),
    );

    expect(
      result.suggestions
          .map((suggestion) => suggestion.voicing.signature)
          .toSet(),
      hasLength(3),
    );
    expect(result.topNoteMatch, VoicingTopNoteMatch.exact);
    expect(
      result.suggestionFor(VoicingSuggestionKind.colorful)!.voicing.family,
      VoicingFamily.upperStructure,
    );
    expect(
      result.suggestionFor(VoicingSuggestionKind.natural)!.voicing.signature,
      isNot(
        result.suggestionFor(VoicingSuggestionKind.easy)!.voicing.signature,
      ),
    );
    expect(
      result.suggestionFor(VoicingSuggestionKind.easy)!.voicing.family,
      isNot(VoicingFamily.upperStructure),
    );
  });
}
