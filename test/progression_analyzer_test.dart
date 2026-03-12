import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/progression_analysis_models.dart';
import 'package:sightchord/music/progression_analyzer.dart';

void main() {
  const analyzer = ProgressionAnalyzer();

  test('detects C major ii-V-I', () {
    final analysis = analyzer.analyze('Dm7 G7 Cmaj7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'IIm7',
      'V7',
      'IM7',
    ]);
    expect(
      analysis.chordAnalyses.map((chord) => chord.harmonicFunction).toList(),
      [
        ProgressionHarmonicFunction.predominant,
        ProgressionHarmonicFunction.dominant,
        ProgressionHarmonicFunction.tonic,
      ],
    );
    expect(analysis.groupedMeasures, hasLength(1));
    expect(analysis.tags, contains(ProgressionTagId.iiVI));
  });

  test('detects G major ii-V-I', () {
    final analysis = analyzer.analyze('Am7 D7 Gmaj7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'G');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'IIm7',
      'V7',
      'IM7',
    ]);
  });

  test('flags A7 as a possible secondary dominant in C major', () {
    final analysis = analyzer.analyze('Cmaj7 A7 Dm7 G7');
    final appliedChord = analysis.chordAnalyses[1];

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(appliedChord.romanNumeral, 'V7/II');
    expect(
      appliedChord.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant,
      ),
      isTrue,
    );
    expect(analysis.tags, contains(ProgressionTagId.turnaround));
  });

  test('keeps ii-V-I detection across adjacent measures', () {
    final analysis = analyzer.analyze('Dm7 | G7 | Cmaj7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.groupedMeasures, hasLength(3));
    expect(analysis.tags, contains(ProgressionTagId.iiVI));
    expect(
      analysis.groupedMeasures
          .map((measure) => measure.chordAnalyses.length)
          .toList(),
      [1, 1, 1],
    );
  });

  test('preserves applied dominant resolution across a barline', () {
    final analysis = analyzer.analyze('Cmaj7 | A7 | Dm7 G7');
    final appliedChord = analysis.groupedMeasures[1].chordAnalyses.single;

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(appliedChord.romanNumeral, 'V7/II');
    expect(
      appliedChord.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant,
      ),
      isTrue,
    );
  });

  test('flags a possible tritone substitute reading', () {
    final analysis = analyzer.analyze('Db7 Cmaj7');
    final firstChord = analysis.chordAnalyses.first;

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(firstChord.romanNumeral, 'subV7/IM7');
    expect(
      firstChord.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleTritoneSubstitute,
      ),
      isTrue,
    );
    expect(firstChord.isAmbiguous, isTrue);
    expect(firstChord.confidence, greaterThan(0));
  });

  test('keeps partial parses and ambiguity warnings conservative', () {
    final analysis = analyzer.analyze('Cmaj7 H7 G7');

    expect(analysis.parseResult.hasPartialFailure, isTrue);
    expect(analysis.parseResult.issues.single.rawText, 'H7');
    expect(analysis.alternativeKey, isNotNull);
    expect(analysis.ambiguity, greaterThan(0));
  });

  test('retains slash-bass evidence on a tonicized turnaround', () {
    final analysis = analyzer.analyze('Cmaj7/E A7(b9) Dm7 G7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(
      analysis.chordAnalyses.first.evidence.any(
        (evidence) => evidence.kind == ProgressionEvidenceKind.slashBass,
      ),
      isTrue,
    );
    expect(
      analysis.chordAnalyses[1].evidence.any(
        (evidence) => evidence.kind == ProgressionEvidenceKind.resolution,
      ),
      isTrue,
    );
  });
}
