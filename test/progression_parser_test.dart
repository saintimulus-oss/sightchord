import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/progression_parser.dart';

void main() {
  const parser = ProgressionParser();

  test('parses whitespace-separated progressions', () {
    final result = parser.parse('Dm7 G7 Cmaj7');

    expect(result.validChords, hasLength(3));
    expect(result.issues, isEmpty);
    expect(result.measures, hasLength(1));
    expect(result.validChords.map((chord) => chord.root).toList(), [
      'D',
      'G',
      'C',
    ]);
    expect(result.validChords.map((chord) => chord.measureIndex).toList(), [
      0,
      0,
      0,
    ]);
  });

  test('parses bar-separated progressions', () {
    final result = parser.parse('Cmaj7 | Am7 D7 | Gmaj7');

    expect(result.validChords, hasLength(4));
    expect(result.issues, isEmpty);
    expect(result.measures, hasLength(3));
    expect(
      result.measures.map((measure) => measure.validChords.length).toList(),
      [1, 2, 1],
    );
    expect(result.validChords.last.sourceSymbol, 'Gmaj7');
  });

  test('parses slash chords', () {
    final result = parser.parse('Db7(#11)/C');

    expect(result.validChords, hasLength(1));
    expect(result.validChords.single.root, 'Db');
    expect(result.validChords.single.bass, 'C');
    expect(result.validChords.single.hasSlashBass, isTrue);
  });

  test('parses alterations and tensions conservatively', () {
    final result = parser.parse('Db7(#11)/C, G7alt');

    expect(result.validChords, hasLength(2));
    expect(result.issues, isEmpty);
    expect(
      result.validChords.first.displayQuality,
      ChordQuality.dominant7Sharp11,
    );
    expect(result.validChords.first.analysisFamily, ChordFamily.dominant);
    expect(result.validChords.first.tensions, ['#11']);
    expect(result.validChords.last.displayQuality, ChordQuality.dominant7Alt);
  });

  test('preserves empty measures while preserving measure metadata', () {
    final result = parser.parse('| Dm7 G7 || Cmaj7 |');

    expect(result.measures, hasLength(5));
    expect(result.validChords.map((chord) => chord.measureIndex).toList(), [
      1,
      1,
      3,
    ]);
    expect(
      result.validChords.map((chord) => chord.positionInMeasure).toList(),
      [0, 1, 0],
    );
  });

  test('keeps explicit empty measures in their original positions', () {
    final result = parser.parse('C | | F | G');

    expect(result.measures, hasLength(4));
    expect(result.measures[0].validChords.single.sourceSymbol, 'C');
    expect(result.measures[1].tokens, isEmpty);
    expect(result.measures[2].validChords.single.sourceSymbol, 'F');
    expect(result.measures[3].validChords.single.sourceSymbol, 'G');
  });
}
