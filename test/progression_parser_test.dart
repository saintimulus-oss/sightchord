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
    expect(result.validChords.first.analysisQuality, ChordQuality.dominant7);
    expect(result.validChords.first.tensions, ['#11']);
    expect(result.validChords.last.displayQuality, ChordQuality.dominant7Alt);
  });

  test('collapses empty measures while preserving measure metadata', () {
    final result = parser.parse('| Dm7 G7 || Cmaj7 |');

    expect(result.measures, hasLength(2));
    expect(result.validChords.map((chord) => chord.measureIndex).toList(), [
      0,
      0,
      1,
    ]);
    expect(
      result.validChords.map((chord) => chord.positionInMeasure).toList(),
      [0, 1, 0],
    );
  });
}
