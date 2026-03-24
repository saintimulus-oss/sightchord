import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:chordest/music/progression_variation_generator.dart';

void main() {
  const analyzer = ProgressionAnalyzer();
  const variationGenerator = ProgressionVariationGenerator();

  Map<String, Object?> semanticProjection(String input) {
    final analysis = analyzer.analyze(input);
    return <String, Object?>{
      'primaryKeyDisplay': analysis.primaryKeyDisplay,
      'globalAggregateKeyDisplay': analysis.globalAggregateKeyDisplay,
      'diagnosticStatus': analysis.diagnosticStatus.wireName,
      'warningCodes': [for (final code in analysis.warningCodes) code.wireName],
      'tagNames': [for (final tag in analysis.tags) tag.name],
      'segments': [
        for (final segment in analysis.analysisSegments)
          '${segment.segmentIndex}:${segment.keyDisplay}:${segment.reason}',
      ],
      'chords': [
        for (final chord in analysis.chordAnalyses)
          '${chord.romanNumeral}|${chord.primaryDisplayLabel}|${chord.harmonicFunction.name}|${chord.sourceKind?.name}|${chord.resolvedSymbol}',
      ],
      'suggestedFills': [
        for (final chord in analysis.chordAnalyses.where((item) => item.isInferred))
          [
            for (final suggestion in chord.suggestedFills)
              '${suggestion.resolvedSymbol}|${suggestion.romanNumeral}|${suggestion.harmonicFunction.name}',
          ],
      ],
    };
  }

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
    expect(firstChord.primaryDisplayLabel, 'subV7/I');
    expect(analysis.diagnosticStatus, isNot(ProgressionDiagnosticStatus.unresolvedHarmony));
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

    expect(analysis.primaryKey.keyCenter.tonicName, 'C');
    expect(
      analysis.chordAnalyses.any(
        (chord) => chord.harmonicFunction == ProgressionHarmonicFunction.tonic,
      ),
      isTrue,
    );
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
    expect(inferred.suggestedFills.length, greaterThanOrEqualTo(3));
    expect(
      inferred.suggestedFills.map((candidate) => candidate.resolvedSymbol).toSet().length,
      greaterThanOrEqualTo(3),
    );
    expect(
      inferred.suggestedFills.first.confidence,
      greaterThanOrEqualTo(inferred.suggestedFills[1].confidence),
    );
  });

  group('regression fixtures', () {
    test('A: C F G C keeps plain dominant resolution taxonomy', () {
      final analysis = analyzer.analyze('C F G C');

      expect(analysis.primaryKey.keyCenter.displayName, 'C major');
      expect(analysis.hasRealModulation, isFalse);
      expect(analysis.tags, contains(ProgressionTagId.dominantResolution));
      expect(analysis.tags, isNot(contains(ProgressionTagId.iiVI)));
      expect(analysis.tags, isNot(contains(ProgressionTagId.tonicization)));
      expect(analysis.tags, isNot(contains(ProgressionTagId.realModulation)));
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.appliedDominant)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.tonicization)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.modulation)),
      );
    });

    test('B: Am Dm E Am keeps plain minor dominant resolution taxonomy', () {
      final analysis = analyzer.analyze('Am Dm E Am');

      expect(analysis.primaryKey.keyCenter.displayName, 'A minor');
      expect(analysis.hasRealModulation, isFalse);
      expect(analysis.tags, contains(ProgressionTagId.dominantResolution));
      expect(analysis.tags, isNot(contains(ProgressionTagId.iiVI)));
      expect(analysis.tags, isNot(contains(ProgressionTagId.tonicization)));
      expect(analysis.tags, isNot(contains(ProgressionTagId.realModulation)));
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.appliedDominant)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.tonicization)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.modulation)),
      );
    });

    test('C: altered dominant stays distinct from applied dominant', () {
      final analysis = analyzer.analyze('C7(b9, #11) Fmaj7');

      expect(analysis.primaryKey.keyCenter.displayName, 'F major');
      expect(analysis.hasRealModulation, isFalse);
      expect(analysis.tags, contains(ProgressionTagId.dominantResolution));
      expect(
        analysis.highlightCategories,
        contains(ProgressionHighlightCategory.alteredDominant),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.appliedDominant)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.tonicization)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.modulation)),
      );
    });

    test(
      'D and E: tritone substitute does not imply tonicization or modulation',
      () {
        for (final input in ['Db7 Cmaj7', 'Db7(#11), Cmaj7']) {
          final analysis = analyzer.analyze(input);

          expect(analysis.primaryKey.keyCenter.displayName, 'C major');
          expect(analysis.hasRealModulation, isFalse);
          expect(analysis.tags, contains(ProgressionTagId.dominantResolution));
          expect(
            analysis.highlightCategories,
            contains(ProgressionHighlightCategory.tritoneSubstitute),
          );
          expect(
            analysis.highlightCategories,
            isNot(contains(ProgressionHighlightCategory.appliedDominant)),
          );
          expect(
            analysis.highlightCategories,
            isNot(contains(ProgressionHighlightCategory.tonicization)),
          );
          expect(
            analysis.highlightCategories,
            isNot(contains(ProgressionHighlightCategory.modulation)),
          );
        }
      },
    );

    test('F: common-tone diminished remains distinct from modulation', () {
      final analysis = analyzer.analyze('C#dim7 Cmaj7');

      expect(analysis.primaryKey.keyCenter.displayName, 'C major');
      expect(analysis.hasRealModulation, isFalse);
      expect(analysis.tags, contains(ProgressionTagId.commonToneMotion));
      expect(
        analysis.highlightCategories,
        contains(ProgressionHighlightCategory.commonTone),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.tonicization)),
      );
      expect(
        analysis.highlightCategories,
        isNot(contains(ProgressionHighlightCategory.modulation)),
      );
    });

    test(
      'G and H: applied dominant tonicization stays below real modulation',
      () {
        for (final input in ['Cmaj7 A7 Dm7 G7', 'Cmaj7/E A7(b9) Dm7 G7']) {
          final analysis = analyzer.analyze(input);

          expect(analysis.primaryKey.keyCenter.displayName, 'C major');
          expect(analysis.hasRealModulation, isFalse);
          expect(
            analysis.highlightCategories,
            contains(ProgressionHighlightCategory.appliedDominant),
          );
          expect(
            analysis.highlightCategories,
            contains(ProgressionHighlightCategory.tonicization),
          );
          expect(
            analysis.highlightCategories,
            isNot(contains(ProgressionHighlightCategory.modulation)),
          );
        }
      },
    );

    test('I: real modulation builds a segment-based key timeline', () {
      final analysis = analyzer.analyze(
        'Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7',
      );

      expect(analysis.hasRealModulation, isTrue);
      expect(analysis.tags, contains(ProgressionTagId.realModulation));
      expect(
        analysis.analysisSegments
            .map(
              (segment) => (
                segment.startMeasureIndex,
                segment.endMeasureIndex,
                segment.keyDisplay,
              ),
            )
            .toList(),
        [(0, 0, 'C major'), (1, 3, 'D major'), (4, 4, 'C major')],
      );

      final measure1 = analysis.groupedMeasures[1].chordAnalyses;
      final measure2 = analysis.groupedMeasures[2].chordAnalyses;
      final measure3 = analysis.groupedMeasures[3].chordAnalyses;
      final measure4 = analysis.groupedMeasures[4].chordAnalyses;

      expect(measure1[0].romanNumeral, 'IIm7');
      expect(
        measure1[0].harmonicFunction,
        ProgressionHarmonicFunction.predominant,
      );
      expect(measure1[1].romanNumeral, 'V7');
      expect(
        measure1[1].harmonicFunction,
        ProgressionHarmonicFunction.dominant,
      );
      expect(measure2[0].romanNumeral, 'Imaj7');
      expect(measure2[0].harmonicFunction, ProgressionHarmonicFunction.tonic);
      expect(measure2[1].romanNumeral, 'IVmaj7');
      expect(
        measure2[1].harmonicFunction ==
                ProgressionHarmonicFunction.predominant ||
            measure2[1].harmonicFunction == ProgressionHarmonicFunction.other,
        isTrue,
      );
      expect(measure3[0].romanNumeral, 'V7');
      expect(measure3[1].romanNumeral, 'Imaj7');
      expect(measure4[0].romanNumeral, 'V7');
      expect(measure4[1].romanNumeral, 'Imaj7');
      expect(
        analysis.chordAnalyses.every(
          (chord) => chord.segmentKeyDisplay.isNotEmpty,
        ),
        isTrue,
      );
    });

    test(
      'J: unresolved pad-like input suppresses variations and modulation highlight',
      () {
        final analysis = analyzer.analyze('Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5');
        final variations = variationGenerator.generate(analysis);

        expect(analysis.hasRealModulation, isFalse);
        expect(analysis.hasWarnings, isTrue);
        expect(analysis.unresolvedChordCount, greaterThanOrEqualTo(1));
        expect(
          analysis.highlightCategories,
          isNot(contains(ProgressionHighlightCategory.modulation)),
        );
        expect(variations, isEmpty);
      },
    );

    test(
      'K: invalid bass reports partial parse and keeps confidence ordering sane',
      () {
        final analysis = analyzer.analyze('C/H | G7');
        final variations = variationGenerator.generate(analysis);

        expect(analysis.hasWarnings, isTrue);
        expect(
          analysis.diagnosticStatus,
          ProgressionDiagnosticStatus.partialParse,
        );
        expect(
          analysis.warningCodes,
          containsAll(<ProgressionWarningCode>[
            ProgressionWarningCode.parseIssue,
            ProgressionWarningCode.invalidBass,
          ]),
        );
        expect(variations, isEmpty);
        if (analysis.alternativeKey != null) {
          expect(
            analysis.primaryKey.confidence >=
                analysis.alternativeKey!.confidence,
            isTrue,
          );
        }
      },
    );

    test(
      'L: placeholder inference reports placeholder diagnostics and gates variations',
      () {
        final analysis = analyzer.analyze('Dm7 - G7 - ? - Am7');
        final variations = variationGenerator.generate(analysis);

        expect(analysis.hasWarnings, isTrue);
        expect(
          analysis.diagnosticStatus,
          ProgressionDiagnosticStatus.placeholderInference,
        );
        expect(
          analysis.warningCodes,
          contains(ProgressionWarningCode.placeholderUsed),
        );
        expect(variations, isEmpty);
        if (analysis.alternativeKey != null) {
          expect(
            analysis.primaryKey.confidence >=
                analysis.alternativeKey!.confidence,
            isTrue,
          );
        }
      },
    );

    test(
      'M: unknown modifiers surface parse-style warnings and gate variations',
      () {
        final analysis = analyzer.analyze('C7(foo) Dm7 G7 Cmaj7');
        final variations = variationGenerator.generate(analysis);

        expect(analysis.hasWarnings, isTrue);
        expect(
          analysis.warningCodes,
          contains(ProgressionWarningCode.unknownModifier),
        );
        expect(variations, isEmpty);
      },
    );
  });

  group('golden semantic cases', () {
    test('A clean cases stay clean and musically natural', () {
      final iiVI = analyzer.analyze('Dm7 G7 Cmaj7');
      final triads = analyzer.analyze('C F G C');
      final minorTriads = analyzer.analyze('Am Dm E Am');
      final minus = analyzer.analyze('Bb-7 Eb7 Abmaj7');
      final tensions = analyzer.analyze('C7(b9, #11) Fmaj7');
      final slashApplied = analyzer.analyze('Cmaj7/E A7(b9) Dm7 G7');

      expect(iiVI.primaryKeyDisplay, 'C major');
      expect(iiVI.diagnosticStatus, ProgressionDiagnosticStatus.clean);

      expect(triads.primaryKeyDisplay, 'C major');
      expect(triads.diagnosticStatus, ProgressionDiagnosticStatus.clean);
      expect(
        triads.warningCodes,
        isNot(contains(ProgressionWarningCode.ambiguousInterpretation)),
      );
      expect(triads.hasRealModulation, isFalse);

      expect(minorTriads.primaryKeyDisplay, 'A minor');
      expect(minorTriads.diagnosticStatus, ProgressionDiagnosticStatus.clean);
      expect(
        minorTriads.warningCodes,
        isNot(contains(ProgressionWarningCode.ambiguousInterpretation)),
      );

      expect(minus.primaryKeyDisplay, 'Ab major');
      expect(minus.diagnosticStatus, ProgressionDiagnosticStatus.clean);

      expect(tensions.primaryKeyDisplay, 'F major');
      expect(tensions.diagnosticStatus, ProgressionDiagnosticStatus.clean);

      expect(slashApplied.primaryKeyDisplay, 'C major');
      expect(slashApplied.diagnosticStatus, ProgressionDiagnosticStatus.clean);
      expect(slashApplied.chordAnalyses[1].romanNumeral, 'V7(b9)/II');
      expect(slashApplied.hasRealModulation, isFalse);
    });

    test('modulation false positives are suppressed for deceptive recovery', () {
      final analysis = analyzer.analyze('Cmaj7 G7 Am7 | Dm7 G7 Cmaj7');

      expect(analysis.primaryKeyDisplay, 'C major');
      expect(analysis.hasRealModulation, isFalse);
      expect(analysis.tags, isNot(contains(ProgressionTagId.realModulation)));
      expect(analysis.analysisSegments, hasLength(1));
      expect(analysis.chordAnalyses[2].romanNumeral, 'VIm7');
    });

    test('sparse progression keeps the opening home key and avoids false certainty', () {
      final analysis = analyzer.analyze('C | | F | G');

      expect(analysis.primaryKeyDisplay, 'C major');
      expect(
        analysis.globalAggregateKeyDisplay == 'G major' ? analysis.keyConfidence < 0.8 : true,
        isTrue,
      );
      expect(
        analysis.diagnosticStatus == ProgressionDiagnosticStatus.clean ||
            analysis.diagnosticStatus ==
                ProgressionDiagnosticStatus.ambiguousHarmony,
        isTrue,
      );
      expect(
        analysis.diagnosticStatus,
        isNot(ProgressionDiagnosticStatus.unresolvedHarmony),
      );
    });

    test('backdoor and common-tone labels prefer natural user-facing names', () {
      final backdoor = analyzer.analyze('Fm7 Bb7 Cmaj7');
      final commonTone = analyzer.analyze('C#dim7 Cmaj7');

      expect(
        backdoor.chordAnalyses[1].primaryDisplayLabel == 'bVII7' ||
            backdoor.chordAnalyses[1].primaryDisplayLabel == 'Backdoor dominant',
        isTrue,
      );
      expect(
        backdoor.chordAnalyses[1].competingInterpretations.any(
          (candidate) => candidate.romanNumeral.startsWith('subV'),
        ),
        isTrue,
      );
      expect(
        (commonTone.chordAnalyses.first.displayAlias ?? '').contains('CT') ||
            commonTone.chordAnalyses.first.primaryDisplayLabel.contains('common-tone'),
        isTrue,
      );
    });

    test('placeholder inference returns ranked suggestions without single-answer hard lock', () {
      final analysis = analyzer.analyze('Dm7 - G7 - ? - Am7');
      final inferred = analysis.chordAnalyses[2];

      expect(analysis.diagnosticStatus, ProgressionDiagnosticStatus.placeholderInference);
      expect(inferred.suggestedFills.length, greaterThanOrEqualTo(3));
      expect(
        inferred.suggestedFills.map((item) => item.resolvedSymbol).toSet().length,
        greaterThanOrEqualTo(3),
      );
      expect(
        inferred.suggestedFills.every((item) => item.confidence > 0 && item.rationale.isNotEmpty),
        isTrue,
      );
    });
  });

  group('semantic parity', () {
    final cases = <(String, String)>[
      ('Dm7 G7 Cmaj7', 'Dm7, G7 | Cmaj7'),
      ('Fm7 Bb7 Cmaj7', 'Fm7 | Bb7 | Cmaj7'),
      ('C#dim7 Cmaj7', 'C#dim7 | Cmaj7'),
      ('Cmaj7 G7 Am7 | Dm7 G7 Cmaj7', 'Cmaj7, G7, Am7 | Dm7 G7 Cmaj7'),
      ('Cmaj7/E A7(b9) Dm7 G7', 'Cmaj7/E | A7(b9) Dm7 | G7'),
      ('Db7(#11), Cmaj7', 'Db7(#11) Cmaj7'),
      ('Dm7 G7 | ? Am', 'Dm7 - G7 - ? - Am'),
      ('Bm7b5 E7alt | Am6, Dm9 G13', 'Bm7b5 E7alt Am6 Dm9 G13'),
      ('Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5', 'Cmaj7 | Fadd11 Bsus4 | Dm7b5 E5 Gomit5'),
      ('C7(b9, #11)', 'C7(b9,#11)'),
    ];

    test('formatting variants preserve semantic output', () {
      for (final pair in cases) {
        expect(
          semanticProjection(pair.$1),
          semanticProjection(pair.$2),
          reason: '${pair.$1} vs ${pair.$2}',
        );
      }
    });
  });

  group('regression invariants', () {
    final cases = <String>[
      'C F G C',
      'Am Dm E Am',
      'C7(b9, #11) Fmaj7',
      'Db7 Cmaj7',
      'Db7(#11), Cmaj7',
      'C#dim7 Cmaj7',
      'Cmaj7 A7 Dm7 G7',
      'Cmaj7/E A7(b9) Dm7 G7',
      'Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7',
      'Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5',
      'C/H | G7',
      'Dm7 - G7 - ? - Am7',
      'C7(foo) Dm7 G7 Cmaj7',
    ];

    test(
      'alternative key confidence never exceeds the primary key confidence',
      () {
        final violations = <String>[];
        for (final input in cases) {
          final analysis = analyzer.analyze(input);
          if (analysis.alternativeKey != null &&
              analysis.alternativeKey!.confidence >
                  analysis.primaryKey.confidence) {
            violations.add(input);
          }
        }
        expect(violations, isEmpty);
      },
    );

    test(
      'non-modulation cases never expose modulation as a case-level highlight',
      () {
        final violations = <String>[];
        for (final input in cases) {
          final analysis = analyzer.analyze(input);
          if (!analysis.hasRealModulation &&
              analysis.highlightCategories.contains(
                ProgressionHighlightCategory.modulation,
              )) {
            violations.add(input);
          }
        }
        expect(violations, isEmpty);
      },
    );

    test('dirty or non-clean cases never expose variation suggestions', () {
      final violations = <String>[];
      for (final input in cases) {
        final analysis = analyzer.analyze(input);
        final variations = variationGenerator.generate(analysis);
        if (analysis.diagnosticStatus != ProgressionDiagnosticStatus.clean &&
            variations.isNotEmpty) {
          violations.add(input);
        }
      }
      expect(violations, isEmpty);
    });

    test('multi-segment analyses carry segment metadata on every chord', () {
      final violations = <String>[];
      for (final input in cases) {
        final analysis = analyzer.analyze(input);
        if (analysis.analysisSegments.length <= 1) {
          continue;
        }
        final allTagged = analysis.chordAnalyses.every(
          (chord) => chord.segmentKeyDisplay.isNotEmpty,
        );
        final allIndexed = analysis.chordAnalyses.every(
          (chord) => chord.segmentIndex >= 0,
        );
        if (!allTagged || !allIndexed) {
          violations.add(input);
        }
      }
      expect(violations, isEmpty);
    });
  });
}

