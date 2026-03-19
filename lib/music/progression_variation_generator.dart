import '../smart_generator.dart';
import 'chord_theory.dart';
import 'progression_analysis_models.dart';

enum ProgressionVariationKind {
  cadentialColor,
  backdoorColor,
  appliedApproach,
  minorCadenceColor,
  colorLift,
}

class ProgressionVariation {
  const ProgressionVariation({
    required this.kind,
    required this.progression,
    required this.changeCount,
  });

  final ProgressionVariationKind kind;
  final String progression;
  final int changeCount;
}

class ProgressionVariationGenerator {
  const ProgressionVariationGenerator();

  List<ProgressionVariation> generate(ProgressionAnalysis analysis) {
    final variations = <ProgressionVariation>[];
    final keyCenter = analysis.primaryKey.keyCenter;
    final cadence = _bestCadenceWindow(analysis);

    if (cadence != null && keyCenter.mode == KeyMode.major) {
      final cadentialColor = _buildMajorCadentialColorVariation(
        analysis: analysis,
        cadence: cadence,
      );
      if (cadentialColor != null) {
        variations.add(cadentialColor);
      }

      final backdoor = _buildBackdoorVariation(
        analysis: analysis,
        cadence: cadence,
      );
      if (backdoor != null) {
        variations.add(backdoor);
      }
    }

    if (cadence != null && keyCenter.mode == KeyMode.minor) {
      final minorCadence = _buildMinorCadenceVariation(
        analysis: analysis,
        cadence: cadence,
      );
      if (minorCadence != null) {
        variations.add(minorCadence);
      }
    }

    final appliedApproach = _buildAppliedApproachVariation(analysis);
    if (appliedApproach != null) {
      variations.add(appliedApproach);
    }

    final colorLift = _buildColorLiftVariation(analysis);
    if (colorLift != null) {
      variations.add(colorLift);
    }

    final originalCanonical = _canonicalizeProgression(analysis.input);
    final seen = <String>{};
    final deduped = <ProgressionVariation>[];

    for (final variation in variations) {
      final canonical = _canonicalizeProgression(variation.progression);
      if (canonical == originalCanonical || !seen.add(canonical)) {
        continue;
      }
      deduped.add(variation);
      if (deduped.length == 3) {
        break;
      }
    }

    return deduped;
  }

  ProgressionVariation? _buildMajorCadentialColorVariation({
    required ProgressionAnalysis analysis,
    required _CadenceWindow cadence,
  }) {
    final target = analysis.chordAnalyses[cadence.targetIndex];
    if (!_isMajorTonic(target)) {
      return null;
    }

    final replacements = <_ChordSlot, String>{
      _slotFor(target): _symbol(target.chord.root, 'maj9'),
      _slotFor(analysis.chordAnalyses[cadence.dominantIndex]):
          _tritoneTargetSymbol(targetRoot: target.chord.root),
    };

    if (cadence.hasPredominant) {
      final predominant = analysis.chordAnalyses[cadence.startIndex];
      final predominantReplacement = _chromaticPredominantSymbol(
        predominant,
        analysis.primaryKey.keyCenter,
      );
      if (predominantReplacement != null) {
        replacements[_slotFor(predominant)] = predominantReplacement;
      }
    }

    return _materializeVariation(
      analysis: analysis,
      kind: ProgressionVariationKind.cadentialColor,
      replacements: replacements,
    );
  }

  ProgressionVariation? _buildBackdoorVariation({
    required ProgressionAnalysis analysis,
    required _CadenceWindow cadence,
  }) {
    final target = analysis.chordAnalyses[cadence.targetIndex];
    if (!_isMajorTonic(target)) {
      return null;
    }

    final keyCenter = analysis.primaryKey.keyCenter;
    final replacements = <_ChordSlot, String>{
      _slotFor(target): _symbol(target.chord.root, '6/9'),
      _slotFor(analysis.chordAnalyses[cadence.dominantIndex]): _symbolForRoman(
        keyCenter,
        RomanNumeralId.borrowedFlatVII7,
      ),
    };

    if (cadence.hasPredominant) {
      replacements[_slotFor(analysis.chordAnalyses[cadence.startIndex])] =
          _symbolForRoman(keyCenter, RomanNumeralId.borrowedIvMin7);
    }

    return _materializeVariation(
      analysis: analysis,
      kind: ProgressionVariationKind.backdoorColor,
      replacements: replacements,
    );
  }

  ProgressionVariation? _buildMinorCadenceVariation({
    required ProgressionAnalysis analysis,
    required _CadenceWindow cadence,
  }) {
    final target = analysis.chordAnalyses[cadence.targetIndex];
    if (!_isMinorTonic(target)) {
      return null;
    }

    final replacements = <_ChordSlot, String>{
      _slotFor(target): _symbol(target.chord.root, 'm6'),
      _slotFor(analysis.chordAnalyses[cadence.dominantIndex]): _symbol(
        analysis.chordAnalyses[cadence.dominantIndex].chord.root,
        '7alt',
      ),
    };

    if (cadence.hasPredominant) {
      final predominant = analysis.chordAnalyses[cadence.startIndex];
      replacements[_slotFor(predominant)] = _symbol(
        predominant.chord.root,
        'm7b5',
      );
    }

    return _materializeVariation(
      analysis: analysis,
      kind: ProgressionVariationKind.minorCadenceColor,
      replacements: replacements,
    );
  }

  ProgressionVariation? _buildAppliedApproachVariation(
    ProgressionAnalysis analysis,
  ) {
    final window = _bestAppliedApproachWindow(analysis);
    if (window == null) {
      return null;
    }

    final target = analysis.chordAnalyses[window.targetIndex];
    final replacements = <_ChordSlot, String>{
      _slotFor(analysis.chordAnalyses[window.leadIndex]): _symbolForRoman(
        analysis.primaryKey.keyCenter,
        window.relatedRoman,
      ),
      _slotFor(analysis.chordAnalyses[window.dominantIndex]): _symbolForRoman(
        analysis.primaryKey.keyCenter,
        window.dominantRoman,
        suffixOverride: window.useSubstitute
            ? '7(#11)'
            : _appliedDominantSuffixForTarget(target),
      ),
    };
    final targetReplacement = _liftedSymbolForAnalysis(
      target,
      next: window.targetIndex + 1 < analysis.chordAnalyses.length
          ? analysis.chordAnalyses[window.targetIndex + 1]
          : null,
      isFinal: window.targetIndex == analysis.chordAnalyses.length - 1,
    );
    if (targetReplacement != null) {
      replacements[_slotFor(target)] = targetReplacement;
    }

    return _materializeVariation(
      analysis: analysis,
      kind: ProgressionVariationKind.appliedApproach,
      replacements: replacements,
    );
  }

  ProgressionVariation? _buildColorLiftVariation(ProgressionAnalysis analysis) {
    final replacements = <_ChordSlot, String>{};

    for (var index = 0; index < analysis.chordAnalyses.length; index += 1) {
      final chordAnalysis = analysis.chordAnalyses[index];
      final next = index + 1 < analysis.chordAnalyses.length
          ? analysis.chordAnalyses[index + 1]
          : null;
      final replacement = _liftedSymbolForAnalysis(
        chordAnalysis,
        next: next,
        isFinal: index == analysis.chordAnalyses.length - 1,
      );
      if (replacement == null) {
        continue;
      }
      replacements[_slotFor(chordAnalysis)] = replacement;
    }

    return _materializeVariation(
      analysis: analysis,
      kind: ProgressionVariationKind.colorLift,
      replacements: replacements,
    );
  }

  _CadenceWindow? _bestCadenceWindow(ProgressionAnalysis analysis) {
    final analyses = analysis.chordAnalyses;
    _CadenceWindow? best;
    var bestScore = double.negativeInfinity;

    for (
      var dominantIndex = 0;
      dominantIndex < analyses.length - 1;
      dominantIndex += 1
    ) {
      final dominant = analyses[dominantIndex];
      final target = analyses[dominantIndex + 1];
      if (dominant.harmonicFunction != ProgressionHarmonicFunction.dominant ||
          target.harmonicFunction != ProgressionHarmonicFunction.tonic) {
        continue;
      }

      final hasPredominant =
          dominantIndex > 0 &&
          analyses[dominantIndex - 1].harmonicFunction ==
              ProgressionHarmonicFunction.predominant;
      var score = 7.0;
      if (hasPredominant) {
        score += 2.8;
      }
      if (dominantIndex + 1 == analyses.length - 1) {
        score += 2.2;
      }
      if (!_sameOrNextMeasure(dominant, target)) {
        score -= 0.8;
      }
      if (target.romanNumeralId != null &&
          _isTonicRoman(target.romanNumeralId!)) {
        score += 1.4;
      }
      if (dominant.isAmbiguous || target.isAmbiguous) {
        score -= 0.6;
      }

      if (score > bestScore) {
        bestScore = score;
        best = _CadenceWindow(
          startIndex: hasPredominant ? dominantIndex - 1 : dominantIndex,
          dominantIndex: dominantIndex,
          targetIndex: dominantIndex + 1,
          hasPredominant: hasPredominant,
        );
      }
    }

    return best;
  }

  _AppliedApproachWindow? _bestAppliedApproachWindow(
    ProgressionAnalysis analysis,
  ) {
    final analyses = analysis.chordAnalyses;
    _AppliedApproachWindow? best;
    var bestScore = double.negativeInfinity;

    for (var targetIndex = 2; targetIndex < analyses.length; targetIndex += 1) {
      final target = analyses[targetIndex];
      final dominant = analyses[targetIndex - 1];
      if (dominant.harmonicFunction != ProgressionHarmonicFunction.dominant ||
          target.harmonicFunction == ProgressionHarmonicFunction.tonic) {
        continue;
      }

      final targetRoman = target.romanNumeralId;
      if (targetRoman == null) {
        continue;
      }

      final relatedRoman = _relatedApproachRoman(targetRoman);
      if (relatedRoman == null) {
        continue;
      }

      final originalLooksLikeSubstitute =
          dominant.sourceKind == ChordSourceKind.substituteDominant ||
          dominant.chord.rootSemitone == ((target.chord.rootSemitone + 1) % 12);
      final dominantRoman = originalLooksLikeSubstitute
          ? SmartGeneratorHelper.substituteDominantByResolution[targetRoman] ??
                SmartGeneratorHelper.secondaryDominantByResolution[targetRoman]
          : SmartGeneratorHelper.secondaryDominantByResolution[targetRoman] ??
                SmartGeneratorHelper
                    .substituteDominantByResolution[targetRoman];
      if (dominantRoman == null) {
        continue;
      }

      var score = 6.0;
      if (_sameOrNextMeasure(dominant, target)) {
        score += 1.2;
      }
      if (dominant.chord.hasAlteredColor) {
        score += 0.5;
      }
      if (targetIndex == analyses.length - 2) {
        score += 0.8;
      }
      if (dominant.isAmbiguous || target.isAmbiguous) {
        score -= 0.6;
      }

      if (score > bestScore) {
        bestScore = score;
        best = _AppliedApproachWindow(
          leadIndex: targetIndex - 2,
          dominantIndex: targetIndex - 1,
          targetIndex: targetIndex,
          relatedRoman: relatedRoman,
          dominantRoman: dominantRoman,
          useSubstitute:
              SmartGeneratorHelper
                  .substituteDominantByResolution[targetRoman] ==
              dominantRoman,
        );
      }
    }

    return best;
  }

  ProgressionVariation? _materializeVariation({
    required ProgressionAnalysis analysis,
    required ProgressionVariationKind kind,
    required Map<_ChordSlot, String> replacements,
  }) {
    var changeCount = 0;
    final measureTexts = <String>[];
    final inferredDefaults = <_ChordSlot, String>{
      for (final chordAnalysis in analysis.chordAnalyses)
        if (chordAnalysis.isInferred)
          _slotFor(chordAnalysis): chordAnalysis.resolvedSymbol,
    };

    for (final measure in analysis.parseResult.measures) {
      final tokenTexts = <String>[];
      for (final token in measure.tokens) {
        final slot = _ChordSlot(
          measureIndex: token.measureIndex,
          positionInMeasure: token.positionInMeasure,
        );
        if (token.chord == null) {
          final original = token.rawText.trim();
          final replacement =
              replacements[slot] ??
              (token.isPlaceholder ? inferredDefaults[slot] : null);
          if (replacement != null && replacement.isNotEmpty) {
            if (!_sameSymbol(original, replacement)) {
              changeCount += 1;
            }
            tokenTexts.add(replacement);
          } else if (original.isNotEmpty) {
            tokenTexts.add(original);
          }
          continue;
        }
        final original = token.chord!.sourceSymbol.trim();
        final replacement = replacements[slot];
        final output = replacement == null || replacement.isEmpty
            ? original
            : replacement;
        if (replacement != null && !_sameSymbol(original, replacement)) {
          changeCount += 1;
        }
        tokenTexts.add(output);
      }
      measureTexts.add(tokenTexts.join(' ').trim());
    }

    if (changeCount == 0) {
      return null;
    }

    return ProgressionVariation(
      kind: kind,
      progression: measureTexts.join(' | '),
      changeCount: changeCount,
    );
  }

  String? _chromaticPredominantSymbol(
    AnalyzedChord analysis,
    KeyCenter keyCenter,
  ) {
    if (analysis.chord.analysisFamily == ChordFamily.halfDiminished) {
      return _symbol(analysis.chord.root, 'm7b5');
    }
    if (analysis.romanNumeralId == RomanNumeralId.iiMin7 ||
        analysis.romanNumeralId == RomanNumeralId.borrowedIiHalfDiminished7 ||
        (analysis.harmonicFunction == ProgressionHarmonicFunction.predominant &&
            analysis.chord.analysisFamily == ChordFamily.minor)) {
      final root = analysis.romanNumeralId == RomanNumeralId.iiMin7
          ? MusicTheory.resolveChordRootForCenter(
              keyCenter,
              RomanNumeralId.borrowedIiHalfDiminished7,
            )
          : analysis.chord.root;
      return _symbol(root, 'm7b5');
    }
    return null;
  }

  String _tritoneTargetSymbol({required String targetRoot}) {
    final root = MusicTheory.transposePitch(targetRoot, 1, preferFlat: true);
    return _symbol(root, '7');
  }

  String _appliedDominantSuffixForTarget(AnalyzedChord target) {
    if (target.chord.analysisFamily == ChordFamily.minor ||
        target.chord.analysisFamily == ChordFamily.halfDiminished) {
      return '7alt';
    }
    return '13';
  }

  String? _liftedSymbolForAnalysis(
    AnalyzedChord analysis, {
    required AnalyzedChord? next,
    required bool isFinal,
  }) {
    final inferredAlternative = _preferredInferredAlternative(analysis);
    if (inferredAlternative != null) {
      return inferredAlternative;
    }

    final root = analysis.chord.root;

    switch (analysis.harmonicFunction) {
      case ProgressionHarmonicFunction.tonic:
        if (analysis.chord.analysisFamily == ChordFamily.major) {
          return _sameSymbol(analysis.chord.sourceSymbol, _symbol(root, 'maj9'))
              ? null
              : _symbol(root, isFinal ? 'maj9' : 'maj9');
        }
        if (analysis.chord.analysisFamily == ChordFamily.minor) {
          final suffix = isFinal ? 'm6' : 'm9';
          return _sameSymbol(analysis.chord.sourceSymbol, _symbol(root, suffix))
              ? null
              : _symbol(root, suffix);
        }
        return null;
      case ProgressionHarmonicFunction.predominant:
        if (analysis.chord.analysisFamily == ChordFamily.minor) {
          return _sameSymbol(analysis.chord.sourceSymbol, _symbol(root, 'm9'))
              ? null
              : _symbol(root, 'm9');
        }
        if (analysis.chord.analysisFamily == ChordFamily.major) {
          return _sameSymbol(analysis.chord.sourceSymbol, _symbol(root, 'maj9'))
              ? null
              : _symbol(root, 'maj9');
        }
        return null;
      case ProgressionHarmonicFunction.dominant:
        final suffix =
            next != null &&
                next.harmonicFunction == ProgressionHarmonicFunction.tonic
            ? (next.chord.analysisFamily == ChordFamily.minor ||
                      analysis.chord.hasAlteredColor
                  ? '7alt'
                  : '13')
            : analysis.sourceKind == ChordSourceKind.substituteDominant
            ? '7(#11)'
            : analysis.chord.hasSuspension
            ? '13sus4'
            : '13';
        return _sameSymbol(analysis.chord.sourceSymbol, _symbol(root, suffix))
            ? null
            : _symbol(root, suffix);
      case ProgressionHarmonicFunction.other:
        return null;
    }
  }

  RomanNumeralId? _relatedApproachRoman(RomanNumeralId targetRoman) {
    return switch (targetRoman) {
      RomanNumeralId.iiMin7 => RomanNumeralId.iiiMin7,
      RomanNumeralId.iiiMin7 => RomanNumeralId.relatedIiOfIII,
      RomanNumeralId.ivMaj7 => RomanNumeralId.relatedIiOfIV,
      RomanNumeralId.viMin7 => RomanNumeralId.viiHalfDiminished7,
      _ => null,
    };
  }

  bool _sameOrNextMeasure(AnalyzedChord left, AnalyzedChord right) {
    return right.chord.measureIndex - left.chord.measureIndex <= 1;
  }

  String? _preferredInferredAlternative(AnalyzedChord analysis) {
    if (!analysis.isInferred) {
      return null;
    }
    for (final candidate in analysis.competingInterpretations) {
      final symbol = candidate.chordSymbol;
      if (symbol == null || _sameSymbol(symbol, analysis.resolvedSymbol)) {
        continue;
      }
      return symbol;
    }
    return null;
  }

  bool _isMajorTonic(AnalyzedChord analysis) {
    return analysis.harmonicFunction == ProgressionHarmonicFunction.tonic &&
        analysis.chord.analysisFamily == ChordFamily.major;
  }

  bool _isMinorTonic(AnalyzedChord analysis) {
    return analysis.harmonicFunction == ProgressionHarmonicFunction.tonic &&
        analysis.chord.analysisFamily == ChordFamily.minor;
  }

  bool _isTonicRoman(RomanNumeralId romanNumeralId) {
    return romanNumeralId == RomanNumeralId.iMaj7 ||
        romanNumeralId == RomanNumeralId.iMaj69 ||
        romanNumeralId == RomanNumeralId.iMin7 ||
        romanNumeralId == RomanNumeralId.iMin6 ||
        romanNumeralId == RomanNumeralId.iMinMaj7;
  }

  _ChordSlot _slotFor(AnalyzedChord analysis) {
    return _ChordSlot(
      measureIndex: analysis.chord.measureIndex,
      positionInMeasure: analysis.chord.positionInMeasure,
    );
  }

  String _symbolForRoman(
    KeyCenter keyCenter,
    RomanNumeralId romanNumeralId, {
    String? suffixOverride,
  }) {
    final root = MusicTheory.resolveChordRootForCenter(
      keyCenter,
      romanNumeralId,
    );
    return _symbol(
      root,
      suffixOverride ??
          _defaultSuffixForQuality(MusicTheory.specFor(romanNumeralId).quality),
    );
  }

  String _symbol(String root, String suffix) => '$root$suffix';

  String _defaultSuffixForQuality(ChordQuality quality) {
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

  String _canonicalizeProgression(String progression) {
    return progression.toLowerCase().replaceAll(RegExp(r'[\s,|]+'), ' ').trim();
  }

  bool _sameSymbol(String left, String right) {
    return left.toLowerCase().replaceAll(RegExp(r'\s+'), '') ==
        right.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }
}

class _CadenceWindow {
  const _CadenceWindow({
    required this.startIndex,
    required this.dominantIndex,
    required this.targetIndex,
    required this.hasPredominant,
  });

  final int startIndex;
  final int dominantIndex;
  final int targetIndex;
  final bool hasPredominant;
}

class _AppliedApproachWindow {
  const _AppliedApproachWindow({
    required this.leadIndex,
    required this.dominantIndex,
    required this.targetIndex,
    required this.relatedRoman,
    required this.dominantRoman,
    required this.useSubstitute,
  });

  final int leadIndex;
  final int dominantIndex;
  final int targetIndex;
  final RomanNumeralId relatedRoman;
  final RomanNumeralId dominantRoman;
  final bool useSubstitute;
}

class _ChordSlot {
  const _ChordSlot({
    required this.measureIndex,
    required this.positionInMeasure,
  });

  final int measureIndex;
  final int positionInMeasure;

  @override
  bool operator ==(Object other) {
    return other is _ChordSlot &&
        other.measureIndex == measureIndex &&
        other.positionInMeasure == positionInMeasure;
  }

  @override
  int get hashCode => Object.hash(measureIndex, positionInMeasure);
}
