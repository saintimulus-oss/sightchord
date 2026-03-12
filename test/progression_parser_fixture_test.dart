import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/progression_parser.dart';

class _ShapeFixture {
  const _ShapeFixture({
    required this.suffix,
    required this.displayQuality,
    required this.analysisQuality,
    this.extension,
    this.tensions = const [],
    this.addedTones = const [],
    this.alterations = const [],
    this.suspensions = const [],
  });

  final String suffix;
  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> alterations;
  final List<String> suspensions;
}

class _SlashFixture {
  const _SlashFixture({
    required this.symbol,
    required this.root,
    required this.bass,
    required this.displayQuality,
    required this.analysisQuality,
    this.extension,
    this.tensions = const [],
    this.alterations = const [],
    this.suspensions = const [],
  });

  final String symbol;
  final String root;
  final String bass;
  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final int? extension;
  final List<String> tensions;
  final List<String> alterations;
  final List<String> suspensions;
}

void main() {
  const parser = ProgressionParser();

  const roots = <(String, String)>[
    ('C', 'C'),
    ('Db', 'Db'),
    ('f#', 'F#'),
    ('Cb', 'Cb'),
  ];

  const shapes = <_ShapeFixture>[
    _ShapeFixture(
      suffix: '',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
    ),
    _ShapeFixture(
      suffix: 'maj7',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'maj9',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 9,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: 'maj11',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 11,
      tensions: ['11'],
    ),
    _ShapeFixture(
      suffix: 'maj13',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 13,
      tensions: ['13'],
    ),
    _ShapeFixture(
      suffix: '6',
      displayQuality: ChordQuality.six,
      analysisQuality: ChordQuality.six,
      extension: 6,
    ),
    _ShapeFixture(
      suffix: '6/9',
      displayQuality: ChordQuality.major69,
      analysisQuality: ChordQuality.major69,
      extension: 6,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: '69',
      displayQuality: ChordQuality.major69,
      analysisQuality: ChordQuality.major69,
      extension: 6,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: 'add9',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      addedTones: ['9'],
    ),
    _ShapeFixture(
      suffix: 'add11',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      addedTones: ['11'],
    ),
    _ShapeFixture(
      suffix: 'add13',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      addedTones: ['13'],
    ),
    _ShapeFixture(
      suffix: 'm',
      displayQuality: ChordQuality.minorTriad,
      analysisQuality: ChordQuality.minorTriad,
    ),
    _ShapeFixture(
      suffix: 'm6',
      displayQuality: ChordQuality.minor6,
      analysisQuality: ChordQuality.minor6,
      extension: 6,
    ),
    _ShapeFixture(
      suffix: 'm7',
      displayQuality: ChordQuality.minor7,
      analysisQuality: ChordQuality.minor7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'm9',
      displayQuality: ChordQuality.minor7,
      analysisQuality: ChordQuality.minor7,
      extension: 9,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: 'm11',
      displayQuality: ChordQuality.minor7,
      analysisQuality: ChordQuality.minor7,
      extension: 11,
      tensions: ['11'],
    ),
    _ShapeFixture(
      suffix: 'mMaj7',
      displayQuality: ChordQuality.minorMajor7,
      analysisQuality: ChordQuality.minorMajor7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'm(maj7)',
      displayQuality: ChordQuality.minorMajor7,
      analysisQuality: ChordQuality.minorMajor7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'mmaj9',
      displayQuality: ChordQuality.minorMajor7,
      analysisQuality: ChordQuality.minorMajor7,
      extension: 9,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: 'mmaj13',
      displayQuality: ChordQuality.minorMajor7,
      analysisQuality: ChordQuality.minorMajor7,
      extension: 13,
      tensions: ['13'],
    ),
    _ShapeFixture(
      suffix: 'm7b5',
      displayQuality: ChordQuality.halfDiminished7,
      analysisQuality: ChordQuality.halfDiminished7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'dim',
      displayQuality: ChordQuality.diminishedTriad,
      analysisQuality: ChordQuality.diminishedTriad,
    ),
    _ShapeFixture(
      suffix: 'dim7',
      displayQuality: ChordQuality.diminished7,
      analysisQuality: ChordQuality.diminished7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: 'aug',
      displayQuality: ChordQuality.augmentedTriad,
      analysisQuality: ChordQuality.augmentedTriad,
    ),
    _ShapeFixture(
      suffix: '+',
      displayQuality: ChordQuality.augmentedTriad,
      analysisQuality: ChordQuality.augmentedTriad,
    ),
    _ShapeFixture(
      suffix: '7',
      displayQuality: ChordQuality.dominant7,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
    ),
    _ShapeFixture(
      suffix: '9',
      displayQuality: ChordQuality.dominant7,
      analysisQuality: ChordQuality.dominant7,
      extension: 9,
      tensions: ['9'],
    ),
    _ShapeFixture(
      suffix: '11',
      displayQuality: ChordQuality.dominant7,
      analysisQuality: ChordQuality.dominant7,
      extension: 11,
      tensions: ['11'],
    ),
    _ShapeFixture(
      suffix: '13',
      displayQuality: ChordQuality.dominant7,
      analysisQuality: ChordQuality.dominant7,
      extension: 13,
      tensions: ['13'],
    ),
    _ShapeFixture(
      suffix: '7b9',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['b9'],
      alterations: ['b9'],
    ),
    _ShapeFixture(
      suffix: '7#9',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['#9'],
      alterations: ['#9'],
    ),
    _ShapeFixture(
      suffix: '7#11',
      displayQuality: ChordQuality.dominant7Sharp11,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['#11'],
      alterations: ['#11'],
    ),
    _ShapeFixture(
      suffix: '7b13',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['b13'],
      alterations: ['b13'],
    ),
    _ShapeFixture(
      suffix: 'alt',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      alterations: ['alt'],
    ),
    _ShapeFixture(
      suffix: '7alt',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      alterations: ['alt'],
    ),
    _ShapeFixture(
      suffix: '7(b9,#11)',
      displayQuality: ChordQuality.dominant7Sharp11,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['b9', '#11'],
      alterations: ['b9', '#11'],
    ),
    _ShapeFixture(
      suffix: '7(b9,#11,b13)',
      displayQuality: ChordQuality.dominant7Sharp11,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['b9', '#11', 'b13'],
      alterations: ['b9', '#11', 'b13'],
    ),
    _ShapeFixture(
      suffix: '7sus4',
      displayQuality: ChordQuality.dominant7sus4,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      suspensions: ['4'],
    ),
    _ShapeFixture(
      suffix: '13sus4',
      displayQuality: ChordQuality.dominant13sus4,
      analysisQuality: ChordQuality.dominant7,
      extension: 13,
      tensions: ['13'],
      suspensions: ['4'],
    ),
    _ShapeFixture(
      suffix: 'sus4',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      suspensions: ['4'],
    ),
    _ShapeFixture(
      suffix: 'sus2',
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      suspensions: ['2'],
    ),
  ];

  const slashFixtures = <_SlashFixture>[
    _SlashFixture(
      symbol: 'G7/B',
      root: 'G',
      bass: 'B',
      displayQuality: ChordQuality.dominant7,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
    ),
    _SlashFixture(
      symbol: 'Cmaj7/E',
      root: 'C',
      bass: 'E',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 7,
    ),
    _SlashFixture(
      symbol: 'Dm7/G',
      root: 'D',
      bass: 'G',
      displayQuality: ChordQuality.minor7,
      analysisQuality: ChordQuality.minor7,
      extension: 7,
    ),
    _SlashFixture(
      symbol: 'Db7(#11)/C',
      root: 'Db',
      bass: 'C',
      displayQuality: ChordQuality.dominant7Sharp11,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      tensions: ['#11'],
      alterations: ['#11'],
    ),
    _SlashFixture(
      symbol: 'Cbmaj9/Eb',
      root: 'Cb',
      bass: 'Eb',
      displayQuality: ChordQuality.major7,
      analysisQuality: ChordQuality.major7,
      extension: 9,
      tensions: ['9'],
    ),
    _SlashFixture(
      symbol: 'F#m11/C#',
      root: 'F#',
      bass: 'C#',
      displayQuality: ChordQuality.minor7,
      analysisQuality: ChordQuality.minor7,
      extension: 11,
      tensions: ['11'],
    ),
    _SlashFixture(
      symbol: 'Bb13sus4/F',
      root: 'Bb',
      bass: 'F',
      displayQuality: ChordQuality.dominant13sus4,
      analysisQuality: ChordQuality.dominant7,
      extension: 13,
      tensions: ['13'],
      suspensions: ['4'],
    ),
    _SlashFixture(
      symbol: 'E7alt/G#',
      root: 'E',
      bass: 'G#',
      displayQuality: ChordQuality.dominant7Alt,
      analysisQuality: ChordQuality.dominant7,
      extension: 7,
      alterations: ['alt'],
    ),
  ];

  test('covers more than 150 practical chord symbol fixtures', () {
    final fixtureCount = roots.length * shapes.length + slashFixtures.length;
    expect(fixtureCount, greaterThanOrEqualTo(150));

    for (final root in roots) {
      for (final shape in shapes) {
        final symbol = '${root.$1}${shape.suffix}';
        final result = parser.parse(symbol);
        expect(result.validChords, hasLength(1), reason: symbol);
        expect(result.issues, isEmpty, reason: symbol);

        final chord = result.validChords.single;
        expect(chord.root, root.$2, reason: symbol);
        expect(chord.displayQuality, shape.displayQuality, reason: symbol);
        expect(chord.analysisQuality, shape.analysisQuality, reason: symbol);
        expect(chord.extension, shape.extension, reason: symbol);
        expect(chord.tensions, shape.tensions, reason: symbol);
        expect(chord.addedTones, shape.addedTones, reason: symbol);
        expect(chord.alterations, shape.alterations, reason: symbol);
        expect(chord.suspensions, shape.suspensions, reason: symbol);
      }
    }

    for (final fixture in slashFixtures) {
      final result = parser.parse(fixture.symbol);
      expect(result.validChords, hasLength(1), reason: fixture.symbol);
      expect(result.issues, isEmpty, reason: fixture.symbol);

      final chord = result.validChords.single;
      expect(chord.root, fixture.root, reason: fixture.symbol);
      expect(chord.bass, fixture.bass, reason: fixture.symbol);
      expect(chord.hasSlashBass, isTrue, reason: fixture.symbol);
      expect(chord.displayQuality, fixture.displayQuality, reason: fixture.symbol);
      expect(chord.analysisQuality, fixture.analysisQuality, reason: fixture.symbol);
      expect(chord.extension, fixture.extension, reason: fixture.symbol);
      expect(chord.tensions, fixture.tensions, reason: fixture.symbol);
      expect(chord.alterations, fixture.alterations, reason: fixture.symbol);
      expect(chord.suspensions, fixture.suspensions, reason: fixture.symbol);
    }
  });

  test('keeps commas inside parentheses inside a single chord token', () {
    final result = parser.parse('C7(b9,#11), Fmaj9 | Bb13sus4');

    expect(result.measures, hasLength(2));
    expect(result.validChords, hasLength(3));
    expect(result.validChords.first.sourceSymbol, 'C7(b9,#11)');
    expect(result.validChords.first.tensions, ['b9', '#11']);
    expect(result.validChords[1].sourceSymbol, 'Fmaj9');
    expect(result.validChords[2].sourceSymbol, 'Bb13sus4');
  });

  test('surfaces ignored modifiers and diagnostics instead of dropping them', () {
    final ignored = parser.parse('C7(foo) Dm7');
    final unbalanced = parser.parse('C7(b9,#11 Dm7');

    expect(ignored.validChords.first.ignoredTokens, ['foo']);
    expect(ignored.validChords.first.diagnostics, isEmpty);
    expect(unbalanced.validChords.first.diagnostics, ['unbalanced-parentheses']);
    expect(unbalanced.validChords.first.ignoredTokens, ['b9,#11 Dm7']);
  });

  test('flags invalid roots while keeping valid neighboring symbols', () {
    final result = parser.parse('Cmaj7 H7 Qm7 G7');

    expect(result.validChords.map((chord) => chord.sourceSymbol).toList(), [
      'Cmaj7',
      'G7',
    ]);
    expect(result.issues.map((issue) => issue.rawText).toList(), ['H7', 'Qm7']);
  });
}
