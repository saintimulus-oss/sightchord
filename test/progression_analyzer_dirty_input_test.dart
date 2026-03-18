import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const analyzer = ProgressionAnalyzer();

  test('accepts delta notation in mixed lead-sheet input', () {
    final analysis = analyzer.analyze('C△7 D7 Gmaj9');

    expect(analysis.parseResult.issues, isEmpty);
    expect(analysis.primaryKey.keyCenter.tonicName, 'G');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
  });

  test('accepts minus notation in flat-key ii-V-I input', () {
    final analysis = analyzer.analyze('Bb-7 Eb7 Abmaj7');

    expect(analysis.parseResult.issues, isEmpty);
    expect(analysis.primaryKey.keyCenter.tonicName, 'G#/Ab');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    expect(analysis.chordAnalyses.map((item) => item.romanNumeral).toList(), [
      'IIm7',
      'V7',
      'Imaj7',
    ]);
  });

  test('treats N.C. as partial parse noise while keeping context chords', () {
    final analysis = analyzer.analyze('N.C. Dm7 G7 Cmaj7');

    expect(analysis.parseResult.hasPartialFailure, isTrue);
    expect(analysis.parseResult.issues.first.rawText, 'N.C.');
    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
  });

  test(
    'keeps harmonic reading when repeat and section markers are mixed in',
    () {
      final analysis = analyzer.analyze('[A] Cmaj7 |: Dm7 G7 :| Cmaj7');

      expect(analysis.parseResult.hasPartialFailure, isTrue);
      expect(
        analysis.parseResult.issues.map((issue) => issue.rawText).toList(),
        containsAll(<String>['[A]', ':', ':']),
      );
      expect(analysis.primaryKey.keyCenter.tonicName, 'C');
      expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    },
  );

  test('keeps slash-bass evidence in slash-heavy real-book style input', () {
    final analysis = analyzer.analyze('C/E A7(b9) Dm7 G7/B');

    expect(analysis.parseResult.issues, isEmpty);
    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(
      analysis.chordAnalyses.first.evidence.any(
        (evidence) => evidence.kind == ProgressionEvidenceKind.slashBass,
      ),
      isTrue,
    );
    expect(
      analysis.chordAnalyses.last.evidence.any(
        (evidence) => evidence.kind == ProgressionEvidenceKind.slashBass,
      ),
      isTrue,
    );
  });
}
