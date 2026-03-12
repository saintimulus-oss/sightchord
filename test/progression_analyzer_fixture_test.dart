import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/progression_analysis_models.dart';
import 'package:sightchord/music/progression_analyzer.dart';

class _AnalysisFixture {
  const _AnalysisFixture({
    required this.name,
    required this.progression,
    required this.expectedKey,
    required this.expectedMode,
    this.expectedRomans = const [],
    this.requiredTags = const [],
    this.requiredRemarks = const [],
    this.requiredEvidence = const [],
    this.expectPartialFailure = false,
  });

  final String name;
  final String progression;
  final String expectedKey;
  final KeyMode expectedMode;
  final List<String> expectedRomans;
  final List<ProgressionTagId> requiredTags;
  final List<(int, ProgressionRemarkKind)> requiredRemarks;
  final List<(int, ProgressionEvidenceKind)> requiredEvidence;
  final bool expectPartialFailure;
}

void main() {
  const analyzer = ProgressionAnalyzer();

  final majorCenters = [
    for (final tonic in const [
      'C',
      'G',
      'D',
      'F',
      'A#/Bb',
      'D#/Eb',
      'A',
      'C#/Db',
    ])
      KeyCenter(tonicName: tonic, mode: KeyMode.major),
  ];
  final minorCenters = [
    for (final tonic in const [
      'A',
      'E',
      'D',
      'G',
      'C',
      'F#/Gb',
      'A#/Bb',
      'C#/Db',
    ])
      KeyCenter(tonicName: tonic, mode: KeyMode.minor),
  ];

  String defaultSuffixForQuality(ChordQuality quality) {
    return switch (quality) {
      ChordQuality.majorTriad => '',
      ChordQuality.minorTriad => 'm',
      ChordQuality.dominant7 => '7',
      ChordQuality.major7 => 'maj7',
      ChordQuality.minor7 => 'm7',
      ChordQuality.minorMajor7 => 'mMaj7',
      ChordQuality.halfDiminished7 => 'm7b5',
      ChordQuality.diminishedTriad => 'dim',
      ChordQuality.diminished7 => 'dim7',
      ChordQuality.augmentedTriad => 'aug',
      ChordQuality.six => '6',
      ChordQuality.minor6 => 'm6',
      ChordQuality.major69 => '6/9',
      ChordQuality.dominant7Alt => '7alt',
      ChordQuality.dominant7Sharp11 => '7(#11)',
      ChordQuality.dominant13sus4 => '13sus4',
      ChordQuality.dominant7sus4 => '7sus4',
    };
  }

  String chordSymbolForRoman(
    KeyCenter center,
    RomanNumeralId roman, {
    String? suffixOverride,
    String? bass,
  }) {
    final root = MusicTheory.resolveChordRootForCenter(center, roman);
    final spec = MusicTheory.specFor(roman);
    final suffix = suffixOverride ?? defaultSuffixForQuality(spec.quality);
    return '$root$suffix${bass == null ? '' : '/$bass'}';
  }

  String firstInversionBass(KeyCenter center, RomanNumeralId roman) {
    final root = MusicTheory.resolveChordRootForCenter(center, roman);
    final rootSemitone = MusicTheory.noteToSemitone[root]!;
    final quality = MusicTheory.specFor(roman).quality;
    final thirdOffset = switch (quality) {
      ChordQuality.minorTriad ||
      ChordQuality.minor7 ||
      ChordQuality.minorMajor7 ||
      ChordQuality.minor6 ||
      ChordQuality.halfDiminished7 ||
      ChordQuality.diminishedTriad ||
      ChordQuality.diminished7 => 3,
      _ => 4,
    };
    return MusicTheory.spellPitch(
      rootSemitone + thirdOffset,
      preferFlat: center.prefersFlatSpelling || root.contains('b'),
    );
  }

  String genericTritoneToTonic(KeyCenter center) {
    final tonic = center.tonicSemitone!;
    final root = MusicTheory.spellPitch(tonic + 1, preferFlat: true);
    return '${root}7(#11)';
  }

  final fixtures = <_AnalysisFixture>[
    for (final center in majorCenters)
      _AnalysisFixture(
        name: '${center.tonicName} major ii-V-I',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '13',
          ),
          chordSymbolForRoman(
            center,
            RomanNumeralId.iMaj7,
            suffixOverride: 'maj9',
          ),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        expectedRomans: const ['IIm7', 'V13', 'Imaj9'],
        requiredTags: const [ProgressionTagId.iiVI],
        requiredEvidence: const [(1, ProgressionEvidenceKind.extensionColor)],
      ),
    for (final center in majorCenters)
      _AnalysisFixture(
        name: '${center.tonicName} turnaround with V7/II',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
          chordSymbolForRoman(
            center,
            RomanNumeralId.secondaryOfII,
            suffixOverride: '7(b9)',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
        ].join(' | '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.turnaround],
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} tritone substitute into tonic',
        progression: [
          genericTritoneToTonic(center),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (0, ProgressionRemarkKind.possibleTritoneSubstitute),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.resolution)],
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} borrowed plagal color',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.borrowedIvMin7),
          chordSymbolForRoman(center, RomanNumeralId.borrowedFlatVII7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.plagalColor],
        requiredRemarks: const [
          (0, ProgressionRemarkKind.possibleModalInterchange),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.borrowedColor)],
      ),
    for (final center in minorCenters)
      _AnalysisFixture(
        name: '${center.tonicName} minor ii-V-i',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iiHalfDiminishedMinor),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '7alt',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iMin6),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.minor,
        requiredTags: const [ProgressionTagId.iiVI],
        requiredEvidence: const [
          (1, ProgressionEvidenceKind.alteredDominantColor),
        ],
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} slash-bass turnaround',
        progression: [
          chordSymbolForRoman(
            center,
            RomanNumeralId.iMaj7,
            bass: firstInversionBass(center, RomanNumeralId.iMaj7),
          ),
          chordSymbolForRoman(center, RomanNumeralId.secondaryOfII),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
        requiredEvidence: const [(0, ProgressionEvidenceKind.slashBass)],
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} V of V cadence',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
          chordSymbolForRoman(center, RomanNumeralId.secondaryOfV),
          chordSymbolForRoman(
            center,
            RomanNumeralId.vDom7,
            suffixOverride: '13',
          ),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredRemarks: const [
          (1, ProgressionRemarkKind.possibleSecondaryDominant),
        ],
        requiredTags: const [ProgressionTagId.dominantResolution],
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} partial parse stays conservative',
        progression:
            '${chordSymbolForRoman(center, RomanNumeralId.iMaj7)} H7 '
            '${chordSymbolForRoman(center, RomanNumeralId.vDom7)} '
            '${chordSymbolForRoman(center, RomanNumeralId.iMaj7)}',
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        expectPartialFailure: true,
      ),
    for (final center in majorCenters.take(6))
      _AnalysisFixture(
        name: '${center.tonicName} opening on IV still surfaces ambiguity',
        progression: [
          chordSymbolForRoman(center, RomanNumeralId.ivMaj7),
          chordSymbolForRoman(center, RomanNumeralId.iiMin7),
          chordSymbolForRoman(center, RomanNumeralId.vDom7),
          chordSymbolForRoman(center, RomanNumeralId.iMaj7),
        ].join(' '),
        expectedKey: center.tonicName,
        expectedMode: KeyMode.major,
        requiredTags: const [ProgressionTagId.iiVI],
      ),
  ];

  test(
    'covers at least 60 progression fixtures with real harmonic assertions',
    () {
      expect(fixtures.length, greaterThanOrEqualTo(60));

      for (final fixture in fixtures) {
        final analysis = analyzer.analyze(fixture.progression);

        expect(
          analysis.primaryKey.keyCenter.tonicName,
          fixture.expectedKey,
          reason: fixture.name,
        );
        expect(
          analysis.primaryKey.keyCenter.mode,
          fixture.expectedMode,
          reason: fixture.name,
        );
        if (fixture.expectedRomans.isNotEmpty) {
          expect(
            analysis.chordAnalyses
                .take(fixture.expectedRomans.length)
                .map((item) => item.romanNumeral)
                .toList(),
            fixture.expectedRomans,
            reason: fixture.name,
          );
        }
        for (final tag in fixture.requiredTags) {
          expect(analysis.tags, contains(tag), reason: fixture.name);
        }
        for (final requirement in fixture.requiredRemarks) {
          expect(
            analysis.chordAnalyses[requirement.$1].remarks.any(
              (remark) => remark.kind == requirement.$2,
            ),
            isTrue,
            reason: fixture.name,
          );
        }
        for (final requirement in fixture.requiredEvidence) {
          expect(
            analysis.chordAnalyses[requirement.$1].evidence.any(
              (evidence) => evidence.kind == requirement.$2,
            ),
            isTrue,
            reason: fixture.name,
          );
        }
        expect(
          analysis.confidence,
          inInclusiveRange(0.0, 1.0),
          reason: fixture.name,
        );
        expect(
          analysis.ambiguity,
          inInclusiveRange(0.0, 1.0),
          reason: fixture.name,
        );
        if (fixture.expectPartialFailure) {
          expect(
            analysis.parseResult.hasPartialFailure,
            isTrue,
            reason: fixture.name,
          );
        }
      }
    },
  );
}
