import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/progression_analyzer.dart';

void main() {
  const analyzer = ProgressionAnalyzer();

  test('detects C major ii-V-I', () {
    final analysis = analyzer.analyze('Dm7 G7 Cmaj7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'IIm7',
      'V7',
      'Imaj7',
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
      'Imaj7',
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

  test('distinguishes tonicization from real modulation conservatively', () {
    final tonicization = analyzer.analyze('Cmaj7 | A7 | Dm7 G7 | Cmaj7');
    final realModulation = analyzer.analyze(
      'Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7',
    );

    expect(tonicization.hasRealModulation, isFalse);
    expect(tonicization.hasTonicization, isTrue);
    expect(tonicization.tags, contains(ProgressionTagId.tonicization));
    expect(realModulation.hasRealModulation, isTrue);
    expect(realModulation.tags, contains(ProgressionTagId.realModulation));
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
    expect(firstChord.romanNumeral, 'subV7/I');
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

  test(
    'surfaces warning state when parser issues and alternate key compete',
    () {
      final analysis = analyzer.analyze('Cmaj7 H7 G7');

      expect(analysis.parseResult.hasPartialFailure, isTrue);
      expect(analysis.hasWarnings, isTrue);
      expect(analysis.alternativeKey, isNotNull);
      expect(analysis.ambiguity, greaterThan(0));
      expect(analysis.confidence, lessThan(1));
    },
  );

  test('detects backdoor and subdominant minor color separately', () {
    final analysis = analyzer.analyze('Fm7 Bb7 Cmaj7');

    expect(analysis.tags, contains(ProgressionTagId.backdoorChain));
    expect(
      analysis.chordAnalyses.first.hasRemark(
        ProgressionRemarkKind.subdominantMinor,
      ),
      isTrue,
    );
    expect(
      analysis.chordAnalyses[1].hasRemark(
        ProgressionRemarkKind.backdoorDominant,
      ),
      isTrue,
    );
  });

  test('detects common-tone diminished color and tags it distinctly', () {
    final analysis = analyzer.analyze('C#dim7 Cmaj7');

    expect(
      analysis.chordAnalyses.first.hasRemark(
        ProgressionRemarkKind.commonToneDiminished,
      ),
      isTrue,
    );
    expect(analysis.tags, contains(ProgressionTagId.commonToneMotion));
  });

  test('detects deceptive cadence without collapsing the whole reading', () {
    final analysis = analyzer.analyze('Cmaj7 G7 Am7 | Dm7 G7 Cmaj7');

    expect(
      analysis.chordAnalyses[2].hasRemark(
        ProgressionRemarkKind.deceptiveCadence,
      ),
      isTrue,
    );
    expect(analysis.tags, contains(ProgressionTagId.deceptiveCadence));
    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
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

  test('keeps roman display aligned with input quality extensions', () {
    final analysis = analyzer.analyze('Dm9 G13 Cmaj9');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'IIm9',
      'V13',
      'Imaj9',
    ]);
  });

  test('reads plain major triads as tonic, subdominant, and dominant', () {
    final analysis = analyzer.analyze('C F G C');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.major);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'I',
      'IV',
      'V',
      'I',
    ]);
    expect(
      analysis.chordAnalyses.map((chord) => chord.harmonicFunction).toList(),
      [
        ProgressionHarmonicFunction.tonic,
        ProgressionHarmonicFunction.predominant,
        ProgressionHarmonicFunction.dominant,
        ProgressionHarmonicFunction.tonic,
      ],
    );
  });

  test('reads plain minor triads conservatively in minor', () {
    final analysis = analyzer.analyze('Am Dm E Am');

    expect(analysis.primaryKey.keyCenter.tonicName, 'A');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.minor);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'Im',
      'IVm',
      'V',
      'Im',
    ]);
  });

  test('uses mode-aware secondary dominant targets in minor', () {
    final analysis = analyzer.analyze('B7 Em7b5 A7 Dm');

    expect(analysis.primaryKey.keyCenter.tonicName, 'D');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.minor);
    expect(analysis.chordAnalyses.first.romanNumeral, 'V7/II');
    expect(
      analysis.chordAnalyses.first.remarks.any(
        (remark) => remark.targetRomanNumeral == 'IIm7b5',
      ),
      isTrue,
    );
  });

  test('preserves explicit empty measures in grouped analysis', () {
    final analysis = analyzer.analyze('C | | F | G');

    expect(analysis.groupedMeasures, hasLength(4));
    expect(analysis.groupedMeasures[1].isEmpty, isTrue);
    expect(analysis.groupedMeasures[1].chordAnalyses, isEmpty);
  });

  test('supports lowercase roots and slash-aware tokenization', () {
    final analysis = analyzer.analyze('cmaj7 am7 d7 gmaj7');

    expect(analysis.parseResult.issues, isEmpty);
    expect(analysis.primaryKey.keyCenter.tonicName, 'G');
    expect(analysis.chordAnalyses.last.romanNumeral, 'Imaj7');
  });

  test(
    'keeps altered tensions on dominant readings without splitting tokens',
    () {
      final analysis = analyzer.analyze('C7(b9, #11) Fmaj7');

      expect(analysis.parseResult.issues, isEmpty);
      expect(analysis.primaryKey.keyCenter.tonicName, 'F');
      expect(analysis.chordAnalyses.first.romanNumeral, 'V7(b9,#11)');
      expect(
        analysis.chordAnalyses.first.evidence.any(
          (evidence) =>
              evidence.kind == ProgressionEvidenceKind.alteredDominantColor,
        ),
        isTrue,
      );
    },
  );

  test('supports minor ii-V-i with tonic minor-major seventh display', () {
    final analysis = analyzer.analyze('Dm7b5 G7 CmMaj7');

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.minor);
    expect(analysis.chordAnalyses.map((chord) => chord.romanNumeral).toList(), [
      'IIm7b5',
      'V7',
      'ImMaj7',
    ]);
  });
  test('does not label non-dominant chords as secondary dominants', () {
    final analysis = analyzer.analyze('D G C');
    final first = analysis.chordAnalyses.first;

    expect(first.romanNumeral, 'II');
    expect(
      first.remarks.any(
        (remark) =>
            remark.kind == ProgressionRemarkKind.possibleSecondaryDominant,
      ),
      isFalse,
    );
  });

  test('surfaces grouped measure parse issues with detailed token errors', () {
    final analysis = analyzer.analyze('C/H | G7');
    final firstMeasure = analysis.groupedMeasures.first;

    expect(firstMeasure.parseIssues, hasLength(1));
    expect(firstMeasure.parseIssues.single.error, 'invalid-bass');
    expect(firstMeasure.parseIssues.single.errorDetail, 'H');
  });

  test('infers placeholder chords from surrounding harmonic context', () {
    final analysis = analyzer.analyze('Dm7 - G7 - ? - Am7');
    final inferred = analysis.chordAnalyses[2];

    expect(analysis.primaryKey.keyCenter.tonicName, 'A');
    expect(analysis.primaryKey.keyCenter.mode, KeyMode.minor);
    expect(analysis.chordAnalyses, hasLength(4));
    expect(analysis.parseResult.placeholders, hasLength(1));
    expect(analysis.inferredChordCount, 1);
    expect(analysis.hasWarnings, isTrue);
    expect(inferred.isInferred, isTrue);
    expect(inferred.chord.sourceSymbol, '?');
    expect(inferred.resolvedSymbol, 'Cmaj7');
    expect(inferred.romanNumeral, 'bIIImaj7');
    expect(
      inferred.competingInterpretations
          .where((candidate) => candidate.chordSymbol != null)
          .map((candidate) => candidate.chordSymbol),
      isNotEmpty,
    );
  });
}
