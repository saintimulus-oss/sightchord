import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_formatting.dart';
import 'chord_theory.dart';
import 'voicing_models.dart';

class VoicingEngine {
  const VoicingEngine._();

  static const int _lookAheadCandidateCap = 8;
  static const List<String> _letters = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  static const Map<String, int> _naturalSemitones = {
    'C': 0,
    'D': 2,
    'E': 4,
    'F': 5,
    'G': 7,
    'A': 9,
    'B': 11,
  };
  static const Map<int, String> _sharpPitchClassNames = {
    0: 'C',
    1: 'C#',
    2: 'D',
    3: 'D#',
    4: 'E',
    5: 'F',
    6: 'F#',
    7: 'G',
    8: 'G#',
    9: 'A',
    10: 'A#',
    11: 'B',
  };
  static const Map<int, String> _flatPitchClassNames = {
    0: 'C',
    1: 'Db',
    2: 'D',
    3: 'Eb',
    4: 'E',
    5: 'F',
    6: 'Gb',
    7: 'G',
    8: 'Ab',
    9: 'A',
    10: 'Bb',
    11: 'B',
  };
  static const Map<String, int> _toneSemitones = {
    '1': 0,
    'b9': 1,
    '9': 2,
    '#9': 3,
    'b3': 3,
    '3': 4,
    '4': 5,
    '11': 5,
    '#11': 6,
    'b5': 6,
    '5': 7,
    '#5': 8,
    'b13': 8,
    '6': 9,
    '13': 9,
    'b7': 10,
    '7': 11,
  };
  static const Set<String> _tensionLabels = {
    'b9',
    '9',
    '#9',
    '11',
    '#11',
    'b13',
    '13',
  };
  static const Set<String> _alteredLabels = {'b9', '#9', '#11', 'b13'};

  static VoicingRecommendationSet recommend({required VoicingContext context}) {
    final interpretation = interpretChord(
      chord: context.currentChord,
      settings: context.settings,
    );
    final candidates = _mergeLockedCandidate(
      candidates: _generateCandidates(
        chord: context.currentChord,
        settings: context.settings,
        interpretation: interpretation,
      ),
      lockedVoicing: context.lockedVoicing,
      interpretation: interpretation,
    );
    if (candidates.isEmpty) {
      return VoicingRecommendationSet(
        currentChord: context.currentChord,
        interpretation: interpretation,
        rankedCandidates: const [],
        suggestions: const [],
      );
    }

    final progressionContext = _ResolvedProgressionContext(
      source: context,
      previousReference:
          context.continuityReferenceVoicing ??
          defaultReferenceVoicing(
            chord: context.previousChord,
            settings: context.settings,
          ),
      lookAheadChords: context.lookAheadChords,
      availableSignatures: {
        for (final candidate in candidates) candidate.signature,
      },
      availableTopNotePitchClasses: {
        for (final candidate in candidates) candidate.topNotePitchClass,
      },
    );

    final ranked = <RankedVoicingCandidate>[
      for (final voicing in candidates)
        _rankCandidate(
          progressionContext: progressionContext,
          interpretation: interpretation,
          voicing: voicing,
        ),
    ];

    ranked.sort((left, right) {
      final totalDelta = right.breakdown.total.compareTo(left.breakdown.total);
      if (totalDelta != 0) {
        return totalDelta;
      }
      final familyDelta = _familyOrder(
        left.voicing.family,
      ).compareTo(_familyOrder(right.voicing.family));
      if (familyDelta != 0) {
        return familyDelta;
      }
      return left.voicing.signature.compareTo(right.voicing.signature);
    });

    final suggestions = _buildSuggestions(
      rankedCandidates: ranked,
      progressionContext: progressionContext,
    );

    return VoicingRecommendationSet(
      currentChord: progressionContext.currentChord,
      interpretation: interpretation,
      rankedCandidates: ranked,
      suggestions: suggestions,
      effectiveTopNotePitchClass:
          progressionContext.topNotePitchClassPreference,
      topNoteSource: progressionContext.topNotePreferenceSource,
      topNoteMatch: progressionContext.topNoteMatch,
    );
  }

  static ConcreteVoicing? defaultReferenceVoicing({
    required GeneratedChord? chord,
    required PracticeSettings settings,
  }) {
    if (chord == null) {
      return null;
    }
    final fallbackResult = recommend(
      context: VoicingContext(
        currentChord: chord,
        settings: settings,
        lookAheadDepth: 0,
      ),
    );
    if (fallbackResult.rankedCandidates.isEmpty) {
      return null;
    }
    return fallbackResult.rankedCandidates.first.voicing;
  }

  static ChordVoicingInterpretation interpretChord({
    required GeneratedChord chord,
    required PracticeSettings settings,
  }) {
    final symbol = chord.symbolData;
    final rootSemitone = MusicTheory.noteToSemitone[symbol.root] ?? 0;
    final preferFlat =
        symbol.root.contains('b') ||
        symbol.bass?.contains('b') == true ||
        chord.keyCenter?.prefersFlatSpelling == true ||
        MusicTheory.prefersFlatSpellingForRoot(symbol.root);

    final prioritizedTensions =
        ChordRenderingHelper.prioritizedTensionOptionsFor(
          romanNumeralId: chord.romanNumeralId,
          plannedChordKind: chord.plannedChordKind,
          allowTensions: settings.allowTensions,
          selectedTensionOptions: settings.selectedTensionOptions,
          suppressTensions: false,
          renderQuality: symbol.renderQuality,
          dominantContext: chord.dominantContext,
          dominantIntent: chord.dominantIntent,
        );
    final explicitTensions = _dedupeLabels(symbol.tensions);
    final prioritizedLabels = _dedupeLabels([
      ...explicitTensions,
      ...prioritizedTensions,
    ]);

    List<String> essentialLabels;
    final optionalLabels = <String>[];
    final avoidLabels = <String>[];
    final styleTags = <String>{};
    var requiredAlteredToneCount = 0;
    var isMajorFamily = false;
    var isMinorFamily = false;
    var isDominantFamily = false;
    var isSusFamily = false;
    var isAlteredFamily = false;
    var isHalfDiminishedFamily = false;
    var isTriadFamily = false;
    var qualityImpliesColor = false;

    switch (symbol.renderQuality) {
      case ChordQuality.majorTriad:
        essentialLabels = const ['1', '3'];
        optionalLabels.add('5');
        isMajorFamily = true;
        isTriadFamily = true;
        break;
      case ChordQuality.minorTriad:
        essentialLabels = const ['1', 'b3'];
        optionalLabels.add('5');
        isMinorFamily = true;
        isTriadFamily = true;
        break;
      case ChordQuality.dominant7:
        essentialLabels = const ['3', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '13', '5', '1']),
        );
        isDominantFamily = true;
        break;
      case ChordQuality.major7:
        essentialLabels = const ['3', '7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '13', '5', '1']),
        );
        avoidLabels.add('11');
        isMajorFamily = true;
        break;
      case ChordQuality.minor7:
        essentialLabels = const ['b3', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '11', '13', '5', '1']),
        );
        isMinorFamily = true;
        break;
      case ChordQuality.minorMajor7:
        essentialLabels = const ['b3', '7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '11', '5', '1']),
        );
        isMinorFamily = true;
        break;
      case ChordQuality.halfDiminished7:
        essentialLabels = const ['b3', 'b5', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '11', 'b13', '1']),
        );
        isMinorFamily = true;
        isHalfDiminishedFamily = true;
        break;
      case ChordQuality.diminishedTriad:
        essentialLabels = const ['1', 'b3', 'b5'];
        isTriadFamily = true;
        break;
      case ChordQuality.diminished7:
        essentialLabels = const ['b3', 'b5', '6'];
        optionalLabels.add('1');
        break;
      case ChordQuality.augmentedTriad:
        essentialLabels = const ['1', '3', '#5'];
        isMajorFamily = true;
        isTriadFamily = true;
        break;
      case ChordQuality.six:
        essentialLabels = const ['3', '6'];
        optionalLabels.addAll(const ['5', '9', '1']);
        isMajorFamily = true;
        break;
      case ChordQuality.minor6:
        essentialLabels = const ['b3', '6'];
        optionalLabels.addAll(const ['5', '9', '11', '1']);
        isMinorFamily = true;
        break;
      case ChordQuality.major69:
        essentialLabels = const ['3', '6', '9'];
        optionalLabels.addAll(const ['5', '1']);
        avoidLabels.add('11');
        isMajorFamily = true;
        qualityImpliesColor = true;
        styleTags.add('major69');
        break;
      case ChordQuality.dominant7Alt:
        essentialLabels = const ['3', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels([
            for (final tension in [...prioritizedLabels, ..._alteredLabels])
              if (_isAlteredLabel(tension)) tension,
            '1',
            '5',
          ]),
        );
        isDominantFamily = true;
        isAlteredFamily = true;
        qualityImpliesColor = true;
        requiredAlteredToneCount =
            settings.voicingComplexity == VoicingComplexity.modern &&
                settings.maxVoicingNotes >= 5
            ? 2
            : 1;
        break;
      case ChordQuality.dominant7Sharp11:
        essentialLabels = const ['3', 'b7', '#11'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '13', '1', '5']),
        );
        isDominantFamily = true;
        qualityImpliesColor = true;
        break;
      case ChordQuality.dominant13sus4:
        essentialLabels = const ['4', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels(['13', ...prioritizedLabels, '9', '1', '5']),
        );
        isDominantFamily = true;
        isSusFamily = true;
        qualityImpliesColor = true;
        break;
      case ChordQuality.dominant7sus4:
        essentialLabels = const ['4', 'b7'];
        optionalLabels.addAll(
          _dedupeLabels([...prioritizedLabels, '9', '13', '1', '5']),
        );
        isDominantFamily = true;
        isSusFamily = true;
        break;
    }

    final bassAnchorSemitone = symbol.bass == null
        ? null
        : MusicTheory.noteToSemitone[symbol.bass!];
    final bassAnchorLabel = bassAnchorSemitone == null
        ? null
        : _bestLabelForRelativeSemitone(
            relativeSemitone: (bassAnchorSemitone - rootSemitone) % 12,
            candidateLabels: [
              ...essentialLabels,
              ...optionalLabels,
              ...avoidLabels,
            ],
            renderQuality: symbol.renderQuality,
          );

    return ChordVoicingInterpretation(
      root: symbol.root,
      rootSemitone: rootSemitone,
      preferFlatSpelling: preferFlat,
      essentialTones: _tonesFromLabels(essentialLabels, startPriority: 100),
      optionalTones: _tonesFromLabels(
        _dedupeLabels(optionalLabels),
        qualityImplied: qualityImpliesColor,
        priorityOverrides: {
          for (var index = 0; index < explicitTensions.length; index += 1)
            explicitTensions[index]: 92 - index,
          for (var index = 0; index < prioritizedTensions.length; index += 1)
            prioritizedTensions[index]: 78 - index,
        },
        startPriority: 64,
      ),
      avoidTones: _tonesFromLabels(avoidLabels, startPriority: 20),
      styleTags: styleTags,
      bassAnchorLabel: bassAnchorLabel,
      bassAnchorSemitone: bassAnchorSemitone,
      requiredAlteredToneCount: requiredAlteredToneCount,
      isMajorFamily: isMajorFamily,
      isMinorFamily: isMinorFamily,
      isDominantFamily: isDominantFamily,
      isSusFamily: isSusFamily,
      isAlteredFamily: isAlteredFamily,
      isHalfDiminishedFamily: isHalfDiminishedFamily,
      isTriadFamily: isTriadFamily,
      qualityImpliesColor: qualityImpliesColor,
    );
  }

  static List<ConcreteVoicing> generateCandidates({
    required GeneratedChord chord,
    required PracticeSettings settings,
  }) {
    final interpretation = interpretChord(chord: chord, settings: settings);
    return _generateCandidates(
      chord: chord,
      settings: settings,
      interpretation: interpretation,
    );
  }

  static List<ConcreteVoicing> _generateCandidates({
    required GeneratedChord chord,
    required PracticeSettings settings,
    required ChordVoicingInterpretation interpretation,
  }) {
    final maxNotes = settings.maxVoicingNotes.clamp(3, 5);
    final templates = _buildTemplates(
      chord: chord,
      settings: settings,
      interpretation: interpretation,
    );
    final candidates = <ConcreteVoicing>[];
    final seen = <String>{};

    for (final template in templates) {
      final labelVariants = _buildTemplateLabelVariants(
        template: template,
        interpretation: interpretation,
        maxNotes: maxNotes,
      );
      for (final labels in labelVariants) {
        if (labels.length < 3) {
          continue;
        }
        for (final registerShift in template.registerShifts) {
          final voicing = _realizeTemplate(
            chord: chord,
            interpretation: interpretation,
            template: template,
            toneLabels: labels,
            registerShift: registerShift,
            maxNotes: maxNotes,
          );
          if (voicing == null) {
            continue;
          }
          if (seen.add(voicing.signature)) {
            candidates.add(voicing);
          }
        }
      }
    }

    candidates.sort((left, right) {
      final familyDelta = _familyOrder(
        left.family,
      ).compareTo(_familyOrder(right.family));
      if (familyDelta != 0) {
        return familyDelta;
      }
      return left.signature.compareTo(right.signature);
    });

    return candidates;
  }

  static List<ConcreteVoicing> _mergeLockedCandidate({
    required List<ConcreteVoicing> candidates,
    required ConcreteVoicing? lockedVoicing,
    required ChordVoicingInterpretation interpretation,
  }) {
    if (lockedVoicing == null ||
        candidates.any(
          (candidate) => candidate.signature == lockedVoicing.signature,
        ) ||
        !_canReuseLockedVoicing(
          lockedVoicing: lockedVoicing,
          interpretation: interpretation,
        )) {
      return candidates;
    }
    return [...candidates, lockedVoicing];
  }

  static bool _canReuseLockedVoicing({
    required ConcreteVoicing lockedVoicing,
    required ChordVoicingInterpretation interpretation,
  }) {
    if (lockedVoicing.midiNotes.length < 3 ||
        lockedVoicing.midiNotes.length != lockedVoicing.noteNames.length ||
        lockedVoicing.midiNotes.length != lockedVoicing.toneLabels.length) {
      return false;
    }
    for (var index = 1; index < lockedVoicing.midiNotes.length; index += 1) {
      if (lockedVoicing.midiNotes[index] <=
          lockedVoicing.midiNotes[index - 1]) {
        return false;
      }
    }
    for (var index = 0; index < lockedVoicing.midiNotes.length; index += 1) {
      final expectedSemitone = _toneSemitones[lockedVoicing.toneLabels[index]];
      if (expectedSemitone == null) {
        return false;
      }
      final relativeSemitone =
          (lockedVoicing.midiNotes[index] - interpretation.rootSemitone) % 12;
      if (relativeSemitone != expectedSemitone % 12) {
        return false;
      }
    }
    final computedTensions = {
      for (final label in lockedVoicing.toneLabels)
        if (_tensionLabels.contains(label)) label,
    };
    return computedTensions.length == lockedVoicing.tensions.length &&
        computedTensions.containsAll(lockedVoicing.tensions) &&
        lockedVoicing.tensions.containsAll(computedTensions);
  }

  static RankedVoicingCandidate _rankCandidate({
    required _ResolvedProgressionContext progressionContext,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    final breakdown = _scoreVoicing(
      progressionContext: progressionContext,
      interpretation: interpretation,
      voicing: voicing,
    );
    final reasonTags = _reasonTagsForCandidate(
      chord: progressionContext.currentChord,
      progressionContext: progressionContext,
      interpretation: interpretation,
      voicing: voicing,
      breakdown: breakdown,
    );
    final naturalScore =
        breakdown.total +
        breakdown.guideToneResolutionBonus +
        breakdown.commonToneRetentionBonus +
        breakdown.nextChordLookAheadBonus -
        (breakdown.colorBonus * 0.15) +
        _roleSemanticAdjustment(
          kind: VoicingSuggestionKind.natural,
          progressionContext: progressionContext,
          chord: progressionContext.currentChord,
          interpretation: interpretation,
          voicing: voicing,
          settings: progressionContext.settings,
        );
    final colorfulScore =
        breakdown.total +
        (breakdown.colorBonus * 1.45) +
        (breakdown.nextChordLookAheadBonus * 0.35) -
        (breakdown.simplicityBonus * 0.12) +
        _roleSemanticAdjustment(
          kind: VoicingSuggestionKind.colorful,
          progressionContext: progressionContext,
          chord: progressionContext.currentChord,
          interpretation: interpretation,
          voicing: voicing,
          settings: progressionContext.settings,
        );
    final easyScore =
        breakdown.total +
        (breakdown.simplicityBonus * 1.35) -
        (breakdown.colorBonus * 0.42) +
        min(0.0, breakdown.handSpanPenalty) * 0.18 +
        _roleSemanticAdjustment(
          kind: VoicingSuggestionKind.easy,
          progressionContext: progressionContext,
          chord: progressionContext.currentChord,
          interpretation: interpretation,
          voicing: voicing,
          settings: progressionContext.settings,
        );
    return RankedVoicingCandidate(
      voicing: voicing,
      breakdown: breakdown,
      naturalScore: naturalScore,
      colorfulScore: colorfulScore,
      easyScore: easyScore,
      reasonTags: reasonTags,
    );
  }

  static VoicingBreakdown _scoreVoicing({
    required _ResolvedProgressionContext progressionContext,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    final essentialSet = interpretation.essentialLabels.toSet();
    final presentSet = voicing.toneLabels.toSet();
    final essentialCoveredCount = essentialSet.intersection(presentSet).length;
    final essentialMissingCount = essentialSet.length - essentialCoveredCount;
    final essentialCoverage =
        (essentialCoveredCount * 1.45) +
        (essentialMissingCount == 0 ? 1.2 : 0) -
        (essentialMissingCount * 2.6);

    final bassAnchorMatched =
        interpretation.bassAnchorSemitone == null ||
        (voicing.bassNote % 12) == interpretation.bassAnchorSemitone! % 12;
    final bassAnchorBonus = interpretation.bassAnchorSemitone == null
        ? 0.0
        : bassAnchorMatched
        ? 1.3
        : -1.8;

    final span = voicing.topNote - voicing.bassNote;
    final handSpanPenalty = span > 18 ? -((span - 18) * 0.12) : 0.0;
    final lowRegisterMudPenalty = _lowRegisterMudPenalty(voicing.midiNotes);
    final pianoPlayabilityAdjustment = _pianoPlayabilityAdjustment(
      interpretation: interpretation,
      voicing: voicing,
    );

    final alteredTensionCount = voicing.tensions.where(_isAlteredLabel).length;
    final colorBonus = _colorBonus(
      settings: progressionContext.settings,
      interpretation: interpretation,
      voicing: voicing,
      alteredTensionCount: alteredTensionCount,
    );
    final simplicityBonus = _simplicityBonus(
      interpretation: interpretation,
      voicing: voicing,
      handSpanSemitones: span,
      alteredTensionCount: alteredTensionCount,
    );
    var topNotePreferenceBonus = _topNotePreferenceBonus(
      progressionContext: progressionContext,
      interpretation: interpretation,
      voicing: voicing,
    );

    var guideToneResolutionBonus = 0.0;
    var commonToneRetentionBonus = 0.0;
    var totalVoiceMotionPenalty = 0.0;
    var outerVoiceLeapPenalty = 0.0;
    var bassMovementPenalty = 0.0;
    var sameHarmonyStabilityBonus = 0.0;
    var sameRootSusReleaseBonus = 0.0;
    var commonToneCount = 0;
    var guideResolutionCount = 0;
    var totalMotionSemitones = 0;
    final previousReference = progressionContext.previousReference;

    if (previousReference != null) {
      final transition = _scoreTransition(
        previousChord: progressionContext.previousChord,
        previousVoicing: previousReference,
        currentChord: progressionContext.currentChord,
        currentVoicing: voicing,
      );
      guideToneResolutionBonus = transition.guideToneResolutionBonus;
      commonToneRetentionBonus = transition.commonToneRetentionBonus;
      totalVoiceMotionPenalty = transition.totalVoiceMotionPenalty;
      outerVoiceLeapPenalty = transition.outerVoiceLeapPenalty;
      bassMovementPenalty = transition.bassMovementPenalty;
      sameRootSusReleaseBonus = transition.sameRootSusReleaseBonus;
      commonToneCount = transition.commonToneCount;
      guideResolutionCount = transition.guideResolutionCount;
      totalMotionSemitones = transition.totalMotionSemitones;
      if (progressionContext.previousChord != null &&
          progressionContext.previousChord!.harmonicComparisonKey ==
              progressionContext.currentChord.harmonicComparisonKey) {
        sameHarmonyStabilityBonus = _sameHarmonyStabilityBonus(
          previousReference: previousReference,
          voicing: voicing,
          motionSemitones: totalMotionSemitones,
        );
        sameHarmonyStabilityBonus += _sameHarmonyTopLineStabilityBonus(
          progressionContext: progressionContext,
          previousReference: previousReference,
          voicing: voicing,
        );
      }
    }

    final nextChordLookAheadBonus = _lookAheadBonus(
      currentChord: progressionContext.currentChord,
      currentVoicing: voicing,
      futureChords: progressionContext.lookAheadChords,
      settings: progressionContext.settings,
      depth: progressionContext.effectiveLookAheadDepth.clamp(0, 2),
    );
    topNotePreferenceBonus += _topLineLookAheadBalanceBonus(
      progressionContext: progressionContext,
      voicing: voicing,
      nextChordLookAheadBonus: nextChordLookAheadBonus,
    );

    final lockContinuityBonus =
        progressionContext.lockedContinuityReference?.signature ==
            voicing.signature
        ? 2.2
        : 0.0;

    final total =
        essentialCoverage +
        bassAnchorBonus +
        sameHarmonyStabilityBonus +
        guideToneResolutionBonus +
        commonToneRetentionBonus +
        totalVoiceMotionPenalty +
        outerVoiceLeapPenalty +
        bassMovementPenalty +
        lowRegisterMudPenalty +
        pianoPlayabilityAdjustment +
        handSpanPenalty +
        sameRootSusReleaseBonus +
        nextChordLookAheadBonus +
        colorBonus +
        simplicityBonus +
        topNotePreferenceBonus +
        lockContinuityBonus;

    return VoicingBreakdown(
      total: total,
      essentialCoverage: essentialCoverage,
      bassAnchorBonus: bassAnchorBonus,
      sameHarmonyStabilityBonus: sameHarmonyStabilityBonus,
      guideToneResolutionBonus: guideToneResolutionBonus,
      commonToneRetentionBonus: commonToneRetentionBonus,
      totalVoiceMotionPenalty: totalVoiceMotionPenalty,
      outerVoiceLeapPenalty: outerVoiceLeapPenalty,
      bassMovementPenalty: bassMovementPenalty,
      lowRegisterMudPenalty: lowRegisterMudPenalty,
      pianoPlayabilityAdjustment: pianoPlayabilityAdjustment,
      handSpanPenalty: handSpanPenalty,
      sameRootSusReleaseBonus: sameRootSusReleaseBonus,
      nextChordLookAheadBonus: nextChordLookAheadBonus,
      colorBonus: colorBonus,
      simplicityBonus: simplicityBonus,
      topNotePreferenceBonus: topNotePreferenceBonus,
      lockContinuityBonus: lockContinuityBonus,
      commonToneCount: commonToneCount,
      guideResolutionCount: guideResolutionCount,
      totalMotionSemitones: totalMotionSemitones,
      handSpanSemitones: span,
      alteredTensionCount: alteredTensionCount,
      bassAnchorMatched: bassAnchorMatched,
      essentialCoveredCount: essentialCoveredCount,
      essentialRequiredCount: essentialSet.length,
    );
  }

  static double _sameHarmonyStabilityBonus({
    required ConcreteVoicing previousReference,
    required ConcreteVoicing voicing,
    required int motionSemitones,
  }) {
    if (previousReference.signature == voicing.signature) {
      return 1.45;
    }
    var bonus = 0.0;
    if (motionSemitones <= 2) {
      bonus += 0.42;
    } else if (motionSemitones <= 4) {
      bonus += 0.18;
    }
    if (previousReference.family == voicing.family) {
      bonus += 0.18;
    }
    if (previousReference.topNotePitchClass == voicing.topNotePitchClass) {
      bonus += 0.18;
    } else if ((previousReference.topNote - voicing.topNote).abs() <= 2) {
      bonus += 0.08;
    }
    if (previousReference.topNote == voicing.topNote &&
        previousReference.bassNote == voicing.bassNote) {
      bonus += 0.22;
    }
    return min(0.82, max(0.0, bonus));
  }

  static double _sameHarmonyTopLineStabilityBonus({
    required _ResolvedProgressionContext progressionContext,
    required ConcreteVoicing previousReference,
    required ConcreteVoicing voicing,
  }) {
    final source = progressionContext.topNotePreferenceSource;
    if (source == null) {
      return 0.0;
    }
    if (previousReference.topNotePitchClass == voicing.topNotePitchClass) {
      return switch (source) {
        VoicingTopNoteSource.explicitPreference => 0.32,
        VoicingTopNoteSource.lockedContinuity => 0.18,
        VoicingTopNoteSource.sameHarmonyCarry => 0.44,
      };
    }
    if ((previousReference.topNote - voicing.topNote).abs() <= 2) {
      return switch (source) {
        VoicingTopNoteSource.explicitPreference => 0.14,
        VoicingTopNoteSource.lockedContinuity => 0.0,
        VoicingTopNoteSource.sameHarmonyCarry => 0.22,
      };
    }
    return 0.0;
  }

  static _TransitionScore _scoreTransition({
    required GeneratedChord? previousChord,
    required ConcreteVoicing previousVoicing,
    required GeneratedChord currentChord,
    required ConcreteVoicing currentVoicing,
  }) {
    final previousPitchClasses = {
      for (final midi in previousVoicing.midiNotes) midi % 12,
    };
    final currentPitchClasses = {
      for (final midi in currentVoicing.midiNotes) midi % 12,
    };
    final commonToneCount = previousPitchClasses
        .intersection(currentPitchClasses)
        .length;
    final commonToneRetentionBonus = min(1.2, commonToneCount * 0.34);

    var guideResolutionCount = 0;
    for (var index = 0; index < previousVoicing.toneLabels.length; index += 1) {
      final previousLabel = previousVoicing.toneLabels[index];
      if (!_isGuideToneLabel(previousLabel)) {
        continue;
      }
      final previousNote = previousVoicing.midiNotes[index];
      final resolvesBySemitone = currentVoicing.midiNotes.any(
        (note) => (note - previousNote).abs() == 1,
      );
      if (resolvesBySemitone) {
        guideResolutionCount += 1;
      }
    }
    final guideToneResolutionBonus = min(1.5, guideResolutionCount * 0.72);

    final totalMotionSemitones = _minimalVoiceMotion(
      previousVoicing.midiNotes,
      currentVoicing.midiNotes,
    );
    final totalVoiceMotionPenalty = -(totalMotionSemitones * 0.08);

    final topLeap = (currentVoicing.topNote - previousVoicing.topNote).abs();
    final bassLeap = (currentVoicing.bassNote - previousVoicing.bassNote).abs();
    final outerVoiceLeapPenalty =
        (topLeap > 7 ? -((topLeap - 7) * 0.07) : 0.0) +
        (bassLeap > 10 ? -((bassLeap - 10) * 0.04) : 0.0);

    final bassIntervalClass = bassLeap % 12;
    final bassMovementPenalty =
        bassLeap > 9 && bassIntervalClass != 5 && bassIntervalClass != 7
        ? -((bassLeap - 8) * 0.09)
        : 0.0;

    final sameRootSusReleaseBonus =
        previousChord != null &&
            _isSusQuality(previousChord.symbolData.renderQuality) &&
            previousChord.symbolData.root == currentChord.symbolData.root &&
            !_isSusQuality(currentChord.symbolData.renderQuality) &&
            currentVoicing.containsThird
        ? 1.0
        : 0.0;

    return _TransitionScore(
      guideToneResolutionBonus: guideToneResolutionBonus,
      commonToneRetentionBonus: commonToneRetentionBonus,
      totalVoiceMotionPenalty: totalVoiceMotionPenalty,
      outerVoiceLeapPenalty: outerVoiceLeapPenalty,
      bassMovementPenalty: bassMovementPenalty,
      sameRootSusReleaseBonus: sameRootSusReleaseBonus,
      commonToneCount: commonToneCount,
      guideResolutionCount: guideResolutionCount,
      totalMotionSemitones: totalMotionSemitones,
    );
  }

  static double _lookAheadBonus({
    required GeneratedChord currentChord,
    required ConcreteVoicing currentVoicing,
    required List<GeneratedChord> futureChords,
    required PracticeSettings settings,
    required int depth,
  }) {
    if (depth <= 0 || futureChords.isEmpty) {
      return 0;
    }

    final nextChord = futureChords.first;
    final nextCandidates = generateCandidates(
      chord: nextChord,
      settings: settings,
    ).take(_lookAheadCandidateCap).toList(growable: false);
    if (nextCandidates.isEmpty) {
      return 0;
    }

    var bestFutureScore = -8.0;
    for (final candidate in nextCandidates) {
      final transition = _scoreTransition(
        previousChord: currentChord,
        previousVoicing: currentVoicing,
        currentChord: nextChord,
        currentVoicing: candidate,
      );
      final candidateScore =
          transition.guideToneResolutionBonus +
          transition.commonToneRetentionBonus +
          transition.totalVoiceMotionPenalty +
          transition.outerVoiceLeapPenalty +
          transition.bassMovementPenalty +
          transition.sameRootSusReleaseBonus +
          _lookAheadBonus(
                currentChord: nextChord,
                currentVoicing: candidate,
                futureChords: futureChords.sublist(1),
                settings: settings,
                depth: depth - 1,
              ) *
              0.55;
      if (candidateScore > bestFutureScore) {
        bestFutureScore = candidateScore;
      }
    }

    return bestFutureScore.clamp(-2.0, 4.0) * 0.48;
  }

  static double _lowRegisterMudPenalty(List<int> notes) {
    var penalty = 0.0;
    for (var index = 0; index < notes.length - 1; index += 1) {
      final lower = notes[index];
      final upper = notes[index + 1];
      final gap = upper - lower;
      if (lower < 48 && gap < 3) {
        penalty -= 1.8;
      } else if (lower < 52 && gap < 4) {
        penalty -= 0.9;
      } else if (lower < 55 && gap < 2) {
        penalty -= 0.6;
      }
    }
    if (notes.length >= 3 && notes[2] < 57 && (notes[2] - notes[0]) <= 8) {
      penalty -= 0.7;
    }
    return penalty;
  }

  static double _pianoPlayabilityAdjustment({
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    var adjustment = 0.0;
    final notes = voicing.midiNotes;
    final span = voicing.topNote - voicing.bassNote;
    final lowRootDenseCluster = _hasLowRootDenseCluster(voicing);
    final wideRootlessTopCluster = _hasWideRootlessTopCluster(voicing);

    if (notes.length >= 4 && voicing.bassNote < 43) {
      adjustment -= 0.24;
    }
    if (voicing.noteCount <= 4 &&
        voicing.bassNote >= 38 &&
        voicing.bassNote <= 53 &&
        span >= 8 &&
        span <= 16) {
      adjustment += 0.2;
    }
    if (voicing.noteCount <= 4 &&
        voicing.bassNote >= 41 &&
        voicing.bassNote <= 55 &&
        span >= 9 &&
        span <= 15) {
      adjustment += 0.1;
    }

    for (var index = 0; index < notes.length - 1; index += 1) {
      final lower = notes[index];
      final gap = notes[index + 1] - lower;
      if (lower < 60 && gap <= 2) {
        adjustment -= 0.5;
      } else if (lower < 57 && gap == 3) {
        adjustment -= 0.18;
      }
      if (lower < 50 && gap <= 4) {
        adjustment -= 0.22;
      }
    }

    if (_hasSplitShellColorSpacing(
      interpretation: interpretation,
      voicing: voicing,
    )) {
      adjustment += interpretation.isDominantFamily ? 0.28 : 0.22;
    }

    if (lowRootDenseCluster) {
      adjustment -= voicing.noteCount >= 5 ? 0.58 : 0.46;
    }

    if (wideRootlessTopCluster) {
      adjustment -= 0.24;
    }

    if ((voicing.family == VoicingFamily.shell ||
            voicing.family == VoicingFamily.spread) &&
        voicing.hasGuideToneCore &&
        voicing.noteCount <= 4 &&
        voicing.bassNote >= 40 &&
        span <= 15) {
      adjustment += 0.16;
    }

    if (voicing.isRootless) {
      if (voicing.bassNote < 43) {
        adjustment -= 0.26;
      }
      if (voicing.noteCount >= 4 && voicing.bassNote < 45) {
        adjustment -= 0.14;
      }
      if (voicing.noteCount >= 4 && span > 15) {
        adjustment -= 0.3;
      }
      if (voicing.hasGuideToneCore &&
          voicing.noteCount <= 4 &&
          span >= 8 &&
          span <= 14) {
        adjustment += 0.18;
      }
      if (voicing.tensions.length > 1) {
        adjustment -= span > 14 ? 0.18 : 0.08;
      }
    }

    if (interpretation.isAlteredFamily) {
      if ((voicing.family == VoicingFamily.altered ||
              voicing.family == VoicingFamily.upperStructure) &&
          voicing.noteCount >= 4) {
        adjustment -= 0.18;
      }
      if (voicing.hasGuideToneCore &&
          voicing.tensions.length <= 1 &&
          span <= 14) {
        adjustment += 0.12;
      }
    }

    if (interpretation.isDominantFamily &&
        voicing.noteCount >= 4 &&
        voicing.bassNote < 41) {
      adjustment -= 0.18;
    }

    return adjustment;
  }

  static bool _hasSplitShellColorSpacing({
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    final notes = voicing.midiNotes;
    if (notes.length < 4 || voicing.bassNote < 38 || voicing.bassNote > 53) {
      return false;
    }
    final splitGap = notes[2] - notes[1];
    final leftSpan = notes[1] - notes[0];
    final upperClusterSpan = notes.last - notes[2];
    return voicing.hasGuideToneCore &&
        splitGap >= 4 &&
        splitGap <= 10 &&
        leftSpan >= 4 &&
        leftSpan <= 11 &&
        upperClusterSpan <= 8 &&
        (voicing.tensions.isNotEmpty || interpretation.isDominantFamily);
  }

  static bool _hasLowRootDenseCluster(ConcreteVoicing voicing) {
    if (!voicing.containsRoot || voicing.noteCount < 4) {
      return false;
    }
    final notes = voicing.midiNotes;
    final fourthSpan = notes[3] - notes[0];
    final innerSpan = notes[2] - notes[0];
    return (notes[0] <= 43 && fourthSpan <= 14) ||
        (notes[0] <= 41 && innerSpan <= 9);
  }

  static bool _hasWideRootlessTopCluster(ConcreteVoicing voicing) {
    final notes = voicing.midiNotes;
    if (!voicing.isRootless || notes.length < 4) {
      return false;
    }
    final upperStartIndex = max(1, notes.length - 3);
    final lowerToUpperGap = notes[upperStartIndex] - notes[upperStartIndex - 1];
    final upperClusterSpan = notes.last - notes[upperStartIndex];
    return (voicing.topNote - voicing.bassNote) >= 15 &&
        lowerToUpperGap >= 6 &&
        upperClusterSpan <= 4;
  }

  static double _topNotePreferenceBonus({
    required _ResolvedProgressionContext progressionContext,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    final preferredPitchClass = progressionContext.topNotePitchClassPreference;
    final source = progressionContext.topNotePreferenceSource;
    if (preferredPitchClass == null) {
      return 0.0;
    }
    final distance = _pitchClassDistance(
      voicing.topNotePitchClass,
      preferredPitchClass,
    );
    final colorTopBonus =
        _isColorTopNote(interpretation: interpretation, voicing: voicing)
        ? 0.12
        : 0.0;
    final exactMatchBonus = switch (source) {
      VoicingTopNoteSource.explicitPreference => 1.24,
      VoicingTopNoteSource.lockedContinuity => 1.0,
      VoicingTopNoteSource.sameHarmonyCarry => 0.72,
      null => 0.0,
    };
    final neighboringBonus = switch (source) {
      VoicingTopNoteSource.explicitPreference => 0.3,
      VoicingTopNoteSource.lockedContinuity => 0.0,
      VoicingTopNoteSource.sameHarmonyCarry => 0.12,
      null => 0.0,
    };
    final nearbyBonus = switch (source) {
      VoicingTopNoteSource.explicitPreference => 0.12,
      VoicingTopNoteSource.lockedContinuity => 0.0,
      VoicingTopNoteSource.sameHarmonyCarry => 0.05,
      null => 0.0,
    };
    if (distance == 0) {
      return exactMatchBonus + colorTopBonus;
    }
    if (distance == 1) {
      return neighboringBonus + (colorTopBonus * 0.4);
    }
    if (distance == 2 &&
        !interpretation.isAlteredFamily &&
        !interpretation.isSusFamily) {
      return nearbyBonus;
    }
    return 0.0;
  }

  static bool _matchesTopLineTarget({
    required _ResolvedProgressionContext progressionContext,
    required ConcreteVoicing voicing,
  }) {
    final preferredPitchClass = progressionContext.topNotePitchClassPreference;
    return preferredPitchClass != null &&
        voicing.topNotePitchClass == preferredPitchClass;
  }

  static bool _isNearTopLineTarget({
    required _ResolvedProgressionContext progressionContext,
    required ConcreteVoicing voicing,
  }) {
    final preferredPitchClass = progressionContext.topNotePitchClassPreference;
    return preferredPitchClass != null &&
        _pitchClassDistance(voicing.topNotePitchClass, preferredPitchClass) ==
            1;
  }

  static double _topLineLookAheadBalanceBonus({
    required _ResolvedProgressionContext progressionContext,
    required ConcreteVoicing voicing,
    required double nextChordLookAheadBonus,
  }) {
    final source = progressionContext.topNotePreferenceSource;
    if (source == null) {
      return 0.0;
    }
    if (_matchesTopLineTarget(
      progressionContext: progressionContext,
      voicing: voicing,
    )) {
      if (nextChordLookAheadBonus < 0) {
        return min(0.36, -nextChordLookAheadBonus * 0.42);
      }
      if (source == VoicingTopNoteSource.sameHarmonyCarry &&
          nextChordLookAheadBonus < 0.35) {
        return 0.08;
      }
      return 0.0;
    }
    if (_isNearTopLineTarget(
          progressionContext: progressionContext,
          voicing: voicing,
        ) &&
        source == VoicingTopNoteSource.explicitPreference &&
        nextChordLookAheadBonus < 0.2) {
      return 0.06;
    }
    return 0.0;
  }

  static double _colorBonus({
    required PracticeSettings settings,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
    required int alteredTensionCount,
  }) {
    final tensionCount = voicing.tensions.length;
    final basePerTension = switch (settings.voicingComplexity) {
      VoicingComplexity.basic => 0.14,
      VoicingComplexity.standard => 0.28,
      VoicingComplexity.modern => 0.42,
    };
    var bonus = tensionCount * basePerTension;
    bonus += alteredTensionCount * 0.36;
    if (voicing.family == VoicingFamily.altered ||
        voicing.family == VoicingFamily.sus) {
      bonus += 0.25;
    }
    if (settings.voicingComplexity == VoicingComplexity.modern) {
      if (voicing.family == VoicingFamily.quartal) {
        bonus += 0.46;
      } else if (voicing.family == VoicingFamily.upperStructure) {
        bonus += 0.4;
      }
    }
    if (interpretation.qualityImpliesColor && tensionCount > 0) {
      bonus += 0.25;
    }
    if (_isColorTopNote(interpretation: interpretation, voicing: voicing)) {
      bonus += 0.14;
    }
    return bonus;
  }

  static double _simplicityBonus({
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
    required int handSpanSemitones,
    required int alteredTensionCount,
  }) {
    var bonus = 2.75;
    bonus -= (voicing.noteCount - 3) * 0.55;
    bonus -= alteredTensionCount * 0.65;
    if (handSpanSemitones > 13) {
      bonus -= (handSpanSemitones - 13) * 0.08;
    }
    if (handSpanSemitones >= 9 && handSpanSemitones <= 14) {
      bonus += 0.14;
    }
    if (voicing.family == VoicingFamily.shell) {
      bonus += 0.55;
    } else if (voicing.family == VoicingFamily.spread) {
      bonus += 0.2;
    } else if (voicing.family == VoicingFamily.altered) {
      bonus -= 0.25;
    } else if (voicing.family == VoicingFamily.quartal) {
      bonus -= 0.18;
    } else if (voicing.family == VoicingFamily.upperStructure) {
      bonus -= 0.22;
    }
    if (interpretation.bassAnchorSemitone != null && voicing.containsRoot) {
      bonus += 0.12;
    }
    if (voicing.isRootless) {
      bonus -= 0.18;
      if (alteredTensionCount > 0 && handSpanSemitones > 13) {
        bonus -= 0.2;
      }
    }
    if (voicing.hasGuideToneCore && voicing.noteCount <= 4) {
      bonus += 0.16;
    }
    return bonus;
  }

  static List<VoicingSuggestion> _buildSuggestions({
    required List<RankedVoicingCandidate> rankedCandidates,
    required _ResolvedProgressionContext progressionContext,
  }) {
    final usedSignatures = <String>{};
    final usedFamilies = <VoicingFamily>{};
    final selectedVoicings = <ConcreteVoicing>[];
    return [
      _pickSuggestion(
        rankedCandidates: rankedCandidates,
        kind: VoicingSuggestionKind.natural,
        scoreFor: (candidate) => candidate.naturalScore,
        usedSignatures: usedSignatures,
        usedFamilies: usedFamilies,
        selectedVoicings: selectedVoicings,
        lockedVoicing: progressionContext.lockedContinuityReference,
        continuityReference: progressionContext.previousReference,
        allowContinuityReuse: false,
        progressionContext: progressionContext,
      ),
      _pickSuggestion(
        rankedCandidates: rankedCandidates,
        kind: VoicingSuggestionKind.colorful,
        scoreFor: (candidate) => candidate.colorfulScore,
        usedSignatures: usedSignatures,
        usedFamilies: usedFamilies,
        selectedVoicings: selectedVoicings,
        lockedVoicing: progressionContext.lockedContinuityReference,
        continuityReference: progressionContext.previousReference,
        allowContinuityReuse:
            progressionContext.previousChord?.harmonicComparisonKey ==
            progressionContext.currentChord.harmonicComparisonKey,
        progressionContext: progressionContext,
      ),
      _pickSuggestion(
        rankedCandidates: rankedCandidates,
        kind: VoicingSuggestionKind.easy,
        scoreFor: (candidate) => candidate.easyScore,
        usedSignatures: usedSignatures,
        usedFamilies: usedFamilies,
        selectedVoicings: selectedVoicings,
        lockedVoicing: progressionContext.lockedContinuityReference,
        continuityReference: progressionContext.previousReference,
        allowContinuityReuse: false,
        progressionContext: progressionContext,
      ),
    ];
  }

  static VoicingSuggestion _pickSuggestion({
    required List<RankedVoicingCandidate> rankedCandidates,
    required VoicingSuggestionKind kind,
    required double Function(RankedVoicingCandidate candidate) scoreFor,
    required Set<String> usedSignatures,
    required Set<VoicingFamily> usedFamilies,
    required List<ConcreteVoicing> selectedVoicings,
    required ConcreteVoicing? lockedVoicing,
    required ConcreteVoicing? continuityReference,
    required bool allowContinuityReuse,
    required _ResolvedProgressionContext progressionContext,
  }) {
    final rankedByKind = [...rankedCandidates]
      ..sort((left, right) {
        final scoreDelta = scoreFor(right).compareTo(scoreFor(left));
        if (scoreDelta != 0) {
          return scoreDelta;
        }
        final totalDelta = right.breakdown.total.compareTo(
          left.breakdown.total,
        );
        if (totalDelta != 0) {
          return totalDelta;
        }
        final familyBiasDelta = _suggestionFamilyBias(
          kind,
          right.voicing.family,
        ).compareTo(_suggestionFamilyBias(kind, left.voicing.family));
        if (familyBiasDelta != 0) {
          return familyBiasDelta;
        }
        final noteCountDelta = _suggestionNoteCountBias(
          kind,
          right.voicing.noteCount,
        ).compareTo(_suggestionNoteCountBias(kind, left.voicing.noteCount));
        if (noteCountDelta != 0) {
          return noteCountDelta;
        }
        final diversityDelta =
            _selectionDiversityBias(
              kind: kind,
              candidate: right,
              selectedVoicings: selectedVoicings,
              progressionContext: progressionContext,
            ).compareTo(
              _selectionDiversityBias(
                kind: kind,
                candidate: left,
                selectedVoicings: selectedVoicings,
                progressionContext: progressionContext,
              ),
            );
        if (diversityDelta != 0) {
          return diversityDelta;
        }
        final familyOrderDelta = _familyOrder(
          left.voicing.family,
        ).compareTo(_familyOrder(right.voicing.family));
        if (familyOrderDelta != 0) {
          return familyOrderDelta;
        }
        return left.voicing.signature.compareTo(right.voicing.signature);
      });

    RankedVoicingCandidate? lockedCandidate;
    if (selectedVoicings.isEmpty && lockedVoicing != null) {
      for (final candidate in rankedByKind) {
        if (candidate.voicing.signature == lockedVoicing.signature) {
          lockedCandidate = candidate;
          break;
        }
      }
    }

    RankedVoicingCandidate selected = lockedCandidate ?? rankedByKind.first;
    if (lockedCandidate == null) {
      for (final candidate in rankedByKind) {
        final isContinuityReuse =
            allowContinuityReuse &&
            continuityReference?.signature == candidate.voicing.signature &&
            usedSignatures.contains(candidate.voicing.signature);
        if (usedSignatures.contains(candidate.voicing.signature) &&
            !isContinuityReuse) {
          continue;
        }
        if (usedFamilies.contains(candidate.voicing.family) &&
            !isContinuityReuse &&
            rankedByKind.any(
              (other) =>
                  !usedFamilies.contains(other.voicing.family) &&
                  !usedSignatures.contains(other.voicing.signature),
            )) {
          continue;
        }
        selected = candidate;
        break;
      }
    }

    usedSignatures.add(selected.voicing.signature);
    usedFamilies.add(selected.voicing.family);
    selectedVoicings.add(selected.voicing);
    final orderedReasonTags = _orderedReasonTagsForKind(
      kind,
      selected.reasonTags,
    );

    return VoicingSuggestion(
      kind: kind,
      label: _defaultSuggestionLabel(kind),
      shortReasons: [
        for (final tag in orderedReasonTags.take(4)) _defaultReasonLabel(tag),
      ],
      score: scoreFor(selected),
      voicing: selected.voicing,
      breakdown: selected.breakdown,
      reasonTags: orderedReasonTags,
      locked: lockedVoicing?.signature == selected.voicing.signature,
    );
  }

  static double _selectionDiversityBias({
    required VoicingSuggestionKind kind,
    required RankedVoicingCandidate candidate,
    required List<ConcreteVoicing> selectedVoicings,
    required _ResolvedProgressionContext progressionContext,
  }) {
    if (selectedVoicings.isEmpty) {
      return _cardPayoffBias(
        kind: kind,
        candidate: candidate,
        progressionContext: progressionContext,
      );
    }
    var bias = _cardPayoffBias(
      kind: kind,
      candidate: candidate,
      progressionContext: progressionContext,
    );
    for (final selected in selectedVoicings) {
      final sameFamily = selected.family == candidate.voicing.family;
      final sameTopPitchClass =
          selected.topNotePitchClass == candidate.voicing.topNotePitchClass;
      final sameNoteCount = selected.noteCount == candidate.voicing.noteCount;
      if (!sameFamily) {
        bias += switch (kind) {
          VoicingSuggestionKind.colorful => 0.22,
          VoicingSuggestionKind.easy => 0.16,
          VoicingSuggestionKind.natural => 0.0,
        };
      } else {
        bias -= switch (kind) {
          VoicingSuggestionKind.colorful => 0.2,
          VoicingSuggestionKind.easy => 0.16,
          VoicingSuggestionKind.natural => 0.0,
        };
      }
      if (!sameTopPitchClass) {
        bias += switch (kind) {
          VoicingSuggestionKind.colorful => 0.12,
          VoicingSuggestionKind.easy => 0.08,
          VoicingSuggestionKind.natural => 0.0,
        };
      } else {
        bias -= switch (kind) {
          VoicingSuggestionKind.colorful => 0.16,
          VoicingSuggestionKind.easy => 0.12,
          VoicingSuggestionKind.natural => 0.0,
        };
      }
      if (!sameNoteCount) {
        bias += kind == VoicingSuggestionKind.natural ? 0.0 : 0.05;
      }
      if (sameFamily &&
          sameTopPitchClass &&
          sameNoteCount &&
          (selected.bassNote - candidate.voicing.bassNote).abs() <= 2) {
        bias -= switch (kind) {
          VoicingSuggestionKind.colorful => 0.18,
          VoicingSuggestionKind.easy => 0.14,
          VoicingSuggestionKind.natural => 0.0,
        };
      }
    }
    return bias;
  }

  static double _cardPayoffBias({
    required VoicingSuggestionKind kind,
    required RankedVoicingCandidate candidate,
    required _ResolvedProgressionContext progressionContext,
  }) {
    final voicing = candidate.voicing;
    return switch (kind) {
      VoicingSuggestionKind.colorful => () {
        var bias = 0.0;
        if (_hasMeaningfulColorPayoff(voicing)) {
          bias += 0.22;
        } else {
          bias -= 0.16;
        }
        if (_matchesTopLineTarget(
          progressionContext: progressionContext,
          voicing: voicing,
        )) {
          bias += 0.08;
        }
        return bias;
      }(),
      VoicingSuggestionKind.easy => () {
        var bias = 0.0;
        if (voicing.containsRoot) {
          bias += 0.08;
        }
        if (voicing.tensions.length <= 1) {
          bias += 0.06;
        } else {
          bias -= 0.12;
        }
        if (_hasMeaningfulColorPayoff(voicing)) {
          bias -= 0.08;
        }
        return bias;
      }(),
      VoicingSuggestionKind.natural => 0.0,
    };
  }

  static bool _hasMeaningfulColorPayoff(ConcreteVoicing voicing) {
    return voicing.tensions.length >= 2 ||
        voicing.family == VoicingFamily.quartal ||
        voicing.family == VoicingFamily.upperStructure ||
        voicing.family == VoicingFamily.altered;
  }

  static List<VoicingReasonTag> _reasonTagsForCandidate({
    required GeneratedChord chord,
    required _ResolvedProgressionContext progressionContext,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
    required VoicingBreakdown breakdown,
  }) {
    final tags = <VoicingReasonTag>[];
    if (breakdown.essentialCoveredCount == breakdown.essentialRequiredCount) {
      tags.add(VoicingReasonTag.essentialCore);
    }
    if (voicing.hasGuideToneCore) {
      tags.add(VoicingReasonTag.guideToneAnchor);
    }
    if (breakdown.bassAnchorMatched && breakdown.bassAnchorBonus > 0) {
      tags.add(VoicingReasonTag.bassAnchor);
    }
    if (breakdown.guideResolutionCount > 0) {
      tags.add(VoicingReasonTag.guideToneResolution);
    }
    if (breakdown.commonToneCount > 0) {
      tags.add(VoicingReasonTag.commonToneRetention);
    }
    if (breakdown.sameHarmonyStabilityBonus >= 0.55) {
      tags.add(VoicingReasonTag.stableRepeat);
    }
    if (_matchesTopLineTarget(
      progressionContext: progressionContext,
      voicing: voicing,
    )) {
      tags.add(VoicingReasonTag.topLineTarget);
    }
    if (breakdown.totalMotionSemitones <= 7 &&
        breakdown.totalVoiceMotionPenalty >= -0.65) {
      tags.add(VoicingReasonTag.gentleMotion);
    }
    if (breakdown.lowRegisterMudPenalty == 0) {
      tags.add(VoicingReasonTag.lowMudAvoided);
    }
    if (breakdown.handSpanSemitones <= 13) {
      tags.add(VoicingReasonTag.compactReach);
    }
    if (voicing.isRootless) {
      tags.add(VoicingReasonTag.rootlessClarity);
    }
    if (_shouldTagAlteredColor(
      interpretation: interpretation,
      voicing: voicing,
    )) {
      tags.add(VoicingReasonTag.alteredColor);
    }
    if (breakdown.sameRootSusReleaseBonus > 0) {
      tags.add(VoicingReasonTag.susRelease);
    }
    if (voicing.family == VoicingFamily.quartal) {
      tags.add(VoicingReasonTag.quartalColor);
    }
    if (voicing.family == VoicingFamily.upperStructure) {
      tags.add(VoicingReasonTag.upperStructureColor);
    }
    if (_isTritoneSubContext(chord, interpretation) &&
        (voicing.family == VoicingFamily.upperStructure ||
            voicing.tensions.contains('#11') ||
            voicing.tensions.contains('13'))) {
      tags.add(VoicingReasonTag.tritoneSubFlavor);
    }
    if (breakdown.nextChordLookAheadBonus > 0.3) {
      tags.add(VoicingReasonTag.nextChordReady);
    }
    if (breakdown.lockContinuityBonus > 0) {
      tags.add(VoicingReasonTag.lockedContinuity);
    }
    return tags;
  }

  static List<VoicingReasonTag> _orderedReasonTagsForKind(
    VoicingSuggestionKind kind,
    List<VoicingReasonTag> tags,
  ) {
    final priorityOrder = switch (kind) {
      VoicingSuggestionKind.natural => const [
        VoicingReasonTag.stableRepeat,
        VoicingReasonTag.topLineTarget,
        VoicingReasonTag.guideToneAnchor,
        VoicingReasonTag.guideToneResolution,
        VoicingReasonTag.commonToneRetention,
        VoicingReasonTag.gentleMotion,
        VoicingReasonTag.nextChordReady,
        VoicingReasonTag.susRelease,
        VoicingReasonTag.essentialCore,
        VoicingReasonTag.bassAnchor,
        VoicingReasonTag.lowMudAvoided,
        VoicingReasonTag.compactReach,
        VoicingReasonTag.lockedContinuity,
        VoicingReasonTag.rootlessClarity,
        VoicingReasonTag.alteredColor,
      ],
      VoicingSuggestionKind.colorful => const [
        VoicingReasonTag.tritoneSubFlavor,
        VoicingReasonTag.quartalColor,
        VoicingReasonTag.upperStructureColor,
        VoicingReasonTag.alteredColor,
        VoicingReasonTag.topLineTarget,
        VoicingReasonTag.guideToneAnchor,
        VoicingReasonTag.susRelease,
        VoicingReasonTag.nextChordReady,
        VoicingReasonTag.guideToneResolution,
        VoicingReasonTag.commonToneRetention,
        VoicingReasonTag.rootlessClarity,
        VoicingReasonTag.essentialCore,
        VoicingReasonTag.bassAnchor,
        VoicingReasonTag.lowMudAvoided,
        VoicingReasonTag.compactReach,
        VoicingReasonTag.gentleMotion,
        VoicingReasonTag.lockedContinuity,
      ],
      VoicingSuggestionKind.easy => const [
        VoicingReasonTag.stableRepeat,
        VoicingReasonTag.topLineTarget,
        VoicingReasonTag.compactReach,
        VoicingReasonTag.lowMudAvoided,
        VoicingReasonTag.guideToneAnchor,
        VoicingReasonTag.essentialCore,
        VoicingReasonTag.bassAnchor,
        VoicingReasonTag.gentleMotion,
        VoicingReasonTag.commonToneRetention,
        VoicingReasonTag.lockedContinuity,
        VoicingReasonTag.nextChordReady,
        VoicingReasonTag.rootlessClarity,
        VoicingReasonTag.guideToneResolution,
        VoicingReasonTag.susRelease,
        VoicingReasonTag.alteredColor,
      ],
    };
    final remaining = [...tags];
    final ordered = <VoicingReasonTag>[];
    for (final tag in priorityOrder) {
      if (remaining.remove(tag)) {
        ordered.add(tag);
      }
    }
    ordered.addAll(remaining);
    return ordered.take(4).toList(growable: false);
  }

  static double _suggestionFamilyBias(
    VoicingSuggestionKind kind,
    VoicingFamily family,
  ) {
    return switch (kind) {
      VoicingSuggestionKind.natural => switch (family) {
        VoicingFamily.shell => 0.45,
        VoicingFamily.rootlessA || VoicingFamily.rootlessB => 0.32,
        VoicingFamily.spread => 0.2,
        VoicingFamily.sus => 0.1,
        VoicingFamily.quartal => -0.12,
        VoicingFamily.altered => -0.08,
        VoicingFamily.upperStructure => -0.16,
      },
      VoicingSuggestionKind.colorful => switch (family) {
        VoicingFamily.quartal => 0.58,
        VoicingFamily.upperStructure => 0.52,
        VoicingFamily.altered => 0.46,
        VoicingFamily.sus => 0.28,
        VoicingFamily.rootlessA || VoicingFamily.rootlessB => 0.18,
        VoicingFamily.spread => 0.1,
        VoicingFamily.shell => -0.04,
      },
      VoicingSuggestionKind.easy => switch (family) {
        VoicingFamily.shell => 0.5,
        VoicingFamily.spread => 0.22,
        VoicingFamily.rootlessA || VoicingFamily.rootlessB => 0.06,
        VoicingFamily.sus => 0.02,
        VoicingFamily.quartal => -0.1,
        VoicingFamily.altered => -0.16,
        VoicingFamily.upperStructure => -0.18,
      },
    };
  }

  static double _suggestionNoteCountBias(
    VoicingSuggestionKind kind,
    int noteCount,
  ) {
    return switch (kind) {
      VoicingSuggestionKind.easy => (5 - noteCount) * 0.12,
      VoicingSuggestionKind.natural => (4 - (noteCount - 4).abs()) * 0.03,
      VoicingSuggestionKind.colorful => (noteCount - 3) * 0.06,
    };
  }

  static double _roleSemanticAdjustment({
    required VoicingSuggestionKind kind,
    required _ResolvedProgressionContext progressionContext,
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
    required PracticeSettings settings,
  }) {
    final modernMode = settings.voicingComplexity == VoicingComplexity.modern;
    final quartalContext =
        modernMode && _supportsModernQuartalContext(interpretation);
    final lydianDominantContext =
        modernMode && _isLydianDominantContext(chord, interpretation);
    final tritoneSubContext =
        modernMode && _isTritoneSubContext(chord, interpretation);
    final sameHarmonyRepeat = progressionContext.isSameHarmonyRepeat;
    final sameHarmonySignatureMatch =
        sameHarmonyRepeat &&
        progressionContext.previousReference?.signature == voicing.signature;
    final sameHarmonyFamilyMatch =
        sameHarmonyRepeat &&
        progressionContext.previousReference?.family == voicing.family;
    final matchesTopLineTarget = _matchesTopLineTarget(
      progressionContext: progressionContext,
      voicing: voicing,
    );
    final lowRootDenseCluster = _hasLowRootDenseCluster(voicing);
    final wideRootlessTopCluster = _hasWideRootlessTopCluster(voicing);
    final explicitTopLineMatch =
        matchesTopLineTarget &&
        progressionContext.topNotePreferenceSource ==
            VoicingTopNoteSource.explicitPreference;
    final meaningfulDominantColorPayoff =
        interpretation.isDominantFamily &&
        _hasMeaningfulDominantColorPayoff(
          chord: chord,
          interpretation: interpretation,
          voicing: voicing,
        );

    return switch (kind) {
      VoicingSuggestionKind.natural => () {
        var bonus = 0.0;
        if (sameHarmonySignatureMatch) {
          bonus += 0.32;
        } else if (sameHarmonyFamilyMatch) {
          bonus += 0.08;
        }
        if (voicing.hasGuideToneCore) {
          bonus += 0.18;
        }
        if (explicitTopLineMatch) {
          bonus += 0.26;
        }
        if (voicing.noteCount <= 4 &&
            (voicing.topNote - voicing.bassNote) >= 8 &&
            (voicing.topNote - voicing.bassNote) <= 16) {
          bonus += 0.12;
        }
        if (lowRootDenseCluster) {
          bonus -= 0.22;
        }
        if (wideRootlessTopCluster) {
          bonus -= 0.2;
        }
        if (voicing.family == VoicingFamily.quartal && quartalContext) {
          bonus -= sameHarmonyRepeat
              ? 1.12
              : interpretation.isMinorFamily
              ? 0.6
              : 0.36;
        }
        if (voicing.family == VoicingFamily.upperStructure) {
          bonus -= (lydianDominantContext || tritoneSubContext) ? 0.58 : 0.32;
        }
        if (voicing.family == VoicingFamily.altered &&
            !interpretation.isAlteredFamily) {
          bonus -= 0.24;
        }
        if (meaningfulDominantColorPayoff &&
            (voicing.family == VoicingFamily.upperStructure ||
                voicing.family == VoicingFamily.altered)) {
          bonus -= 0.14;
        }
        return bonus;
      }(),
      VoicingSuggestionKind.colorful => () {
        var bonus = 0.0;
        if (sameHarmonySignatureMatch) {
          bonus += 0.88;
        } else if (sameHarmonyFamilyMatch) {
          bonus += 0.2;
        }
        if (explicitTopLineMatch) {
          bonus += 0.34;
        }
        if (voicing.family == VoicingFamily.quartal && quartalContext) {
          bonus += interpretation.isSusFamily
              ? 0.44
              : interpretation.isMinorFamily
              ? 0.68
              : 0.36;
          if (interpretation.isMinorFamily && voicing.isRootless) {
            bonus += 0.08;
          }
        }
        if (voicing.family == VoicingFamily.upperStructure) {
          bonus += tritoneSubContext
              ? 0.8
              : lydianDominantContext
              ? 0.72
              : interpretation.isAlteredFamily
              ? 0.18
              : 0.0;
        }
        if (voicing.family == VoicingFamily.altered &&
            lydianDominantContext &&
            !interpretation.isAlteredFamily) {
          bonus -= 0.32;
        }
        if (interpretation.isDominantFamily) {
          if (meaningfulDominantColorPayoff) {
            bonus += 0.18;
          } else if (voicing.family == VoicingFamily.upperStructure ||
              voicing.family == VoicingFamily.altered) {
            bonus -= 0.28;
          }
        }
        bonus += _colorTopNoteSemanticBonus(
          chord: chord,
          interpretation: interpretation,
          voicing: voicing,
          modernMode: modernMode,
        );
        return bonus;
      }(),
      VoicingSuggestionKind.easy => () {
        var bonus = 0.0;
        if (sameHarmonySignatureMatch) {
          bonus += 0.58;
        } else if (sameHarmonyFamilyMatch) {
          bonus += 0.14;
        }
        if (explicitTopLineMatch) {
          bonus += 0.1;
        }
        if (voicing.hasGuideToneCore && voicing.noteCount <= 4) {
          bonus += 0.16;
        }
        if ((voicing.family == VoicingFamily.shell ||
                voicing.family == VoicingFamily.spread) &&
            voicing.hasGuideToneCore &&
            voicing.noteCount <= 4 &&
            (voicing.topNote - voicing.bassNote) <= 15) {
          bonus += 0.18;
        }
        if (voicing.family == VoicingFamily.quartal ||
            voicing.family == VoicingFamily.upperStructure) {
          bonus -= 0.14;
        }
        if (lowRootDenseCluster) {
          bonus -= 0.34;
        }
        if (voicing.isRootless && voicing.tensions.length > 1) {
          bonus -= 0.28;
        }
        if (wideRootlessTopCluster) {
          bonus -= 0.42;
        }
        if (interpretation.isAlteredFamily &&
            voicing.family == VoicingFamily.altered) {
          bonus -= 0.24;
        }
        if ((voicing.topNote - voicing.bassNote) > 15) {
          bonus -= 0.18;
        }
        if (meaningfulDominantColorPayoff &&
            (voicing.family == VoicingFamily.upperStructure ||
                voicing.family == VoicingFamily.altered)) {
          bonus -= 0.26;
        }
        return bonus;
      }(),
    };
  }

  static bool _hasMeaningfulDominantColorPayoff({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    if (!interpretation.isDominantFamily) {
      return false;
    }
    if (_isTritoneSubContext(chord, interpretation) ||
        _isLydianDominantContext(chord, interpretation)) {
      return voicing.tensions.contains('#11') ||
          voicing.tensions.contains('13') ||
          voicing.tensions.contains('9');
    }
    if (_supportsModernAlteredContext(chord, interpretation)) {
      return voicing.tensions.any(_isAlteredLabel);
    }
    return false;
  }

  static bool _supportsModernQuartalContext(
    ChordVoicingInterpretation interpretation,
  ) {
    return interpretation.isSusFamily ||
        (interpretation.isMinorFamily &&
            interpretation.essentialLabels.contains('b7') &&
            !interpretation.isHalfDiminishedFamily &&
            !interpretation.isTriadFamily);
  }

  static bool _supportsModernAlteredContext(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    return interpretation.isAlteredFamily ||
        chord.dominantIntent == DominantIntent.primaryAuthenticMinor ||
        chord.dominantIntent == DominantIntent.secondaryToMinor ||
        chord.dominantIntent == DominantIntent.tritoneSub ||
        chord.dominantIntent == DominantIntent.backdoor ||
        chord.dominantContext == DominantContext.primaryMinor ||
        chord.dominantContext == DominantContext.secondaryToMinor ||
        chord.dominantContext == DominantContext.tritoneSubstitute ||
        chord.dominantContext == DominantContext.backdoor;
  }

  static bool _isLydianDominantContext(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    return interpretation.isDominantFamily &&
        !interpretation.isAlteredFamily &&
        (chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11 ||
            chord.symbolData.tensions.contains('#11') ||
            chord.dominantIntent == DominantIntent.lydianDominant ||
            chord.dominantContext == DominantContext.dominantIILydian);
  }

  static bool _isTritoneSubContext(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    return interpretation.isDominantFamily &&
        (chord.dominantIntent == DominantIntent.tritoneSub ||
            chord.dominantContext == DominantContext.tritoneSubstitute);
  }

  static double _colorTopNoteSemanticBonus({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
    required bool modernMode,
  }) {
    if (!modernMode || voicing.toneLabels.isEmpty) {
      return 0.0;
    }
    final topLabel = voicing.toneLabels.last;
    if (interpretation.isAlteredFamily) {
      return switch (topLabel) {
        'b9' || '#9' || 'b13' || '#11' => 0.22,
        _ => 0.0,
      };
    }
    if (_isTritoneSubContext(chord, interpretation)) {
      return switch (topLabel) {
        '#11' || '13' || '9' => 0.24,
        _ => 0.0,
      };
    }
    if (_isLydianDominantContext(chord, interpretation)) {
      return switch (topLabel) {
        '#11' || '13' => 0.2,
        '9' => 0.12,
        _ => 0.0,
      };
    }
    if (interpretation.isSusFamily) {
      return switch (topLabel) {
        '13' || '9' || '4' => 0.14,
        _ => 0.0,
      };
    }
    return 0.0;
  }

  static bool _isColorTopNote({
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    if (voicing.toneLabels.isEmpty) {
      return false;
    }
    final topLabel = voicing.toneLabels.last;
    if (interpretation.isAlteredFamily) {
      return _isAlteredLabel(topLabel);
    }
    if (interpretation.isDominantFamily) {
      return topLabel == '#11' || topLabel == '13' || topLabel == '9';
    }
    if (interpretation.isMajorFamily || interpretation.isMinorFamily) {
      return topLabel == '9' || topLabel == '13' || topLabel == '11';
    }
    return false;
  }

  static bool _shouldTagAlteredColor({
    required ChordVoicingInterpretation interpretation,
    required ConcreteVoicing voicing,
  }) {
    if (interpretation.isAlteredFamily) {
      return voicing.tensions.any(_isAlteredLabel);
    }
    return voicing.tensions.any(
      (label) => label == 'b9' || label == '#9' || label == 'b13',
    );
  }

  static int _pitchClassDistance(int left, int right) {
    final distance = (left - right).abs() % 12;
    return min(distance, 12 - distance);
  }

  static String _defaultSuggestionLabel(VoicingSuggestionKind kind) {
    return switch (kind) {
      VoicingSuggestionKind.natural => 'Most natural',
      VoicingSuggestionKind.colorful => 'Most colorful',
      VoicingSuggestionKind.easy => 'Easiest',
    };
  }

  static String _defaultReasonLabel(VoicingReasonTag tag) {
    return switch (tag) {
      VoicingReasonTag.essentialCore => 'Essential tones covered',
      VoicingReasonTag.guideToneAnchor => 'Guide-tone anchor',
      VoicingReasonTag.guideToneResolution => 'Guide-tone pull',
      VoicingReasonTag.commonToneRetention => 'Common tones retained',
      VoicingReasonTag.stableRepeat => 'Stable repeat',
      VoicingReasonTag.topLineTarget => 'Top-line target',
      VoicingReasonTag.lowMudAvoided => 'Low-register clarity',
      VoicingReasonTag.compactReach => 'Comfortable reach',
      VoicingReasonTag.bassAnchor => 'Bass anchor respected',
      VoicingReasonTag.nextChordReady => 'Next chord ready',
      VoicingReasonTag.alteredColor => 'Altered tensions',
      VoicingReasonTag.rootlessClarity => 'Light rootless shape',
      VoicingReasonTag.susRelease => 'Sus release set up',
      VoicingReasonTag.quartalColor => 'Quartal color',
      VoicingReasonTag.upperStructureColor => 'Upper-structure color',
      VoicingReasonTag.tritoneSubFlavor => 'Tritone-sub flavor',
      VoicingReasonTag.lockedContinuity => 'Locked continuity',
      VoicingReasonTag.gentleMotion => 'Smooth hand move',
    };
  }

  static List<_VoicingTemplate> _buildTemplates({
    required GeneratedChord chord,
    required PracticeSettings settings,
    required ChordVoicingInterpretation interpretation,
  }) {
    final isModern = settings.voicingComplexity == VoicingComplexity.modern;
    final optionalLabels = interpretation.optionalLabels;
    final colorLabels = [
      for (final label in optionalLabels)
        if (_tensionLabels.contains(label) || _isAlteredLabel(label)) label,
    ];
    final supportLabels = [
      for (final label in optionalLabels)
        if (!colorLabels.contains(label)) label,
    ];
    final templates = <_VoicingTemplate>[];

    void addTemplate(_VoicingTemplate template) {
      if ((template.family == VoicingFamily.rootlessA ||
              template.family == VoicingFamily.rootlessB) &&
          !settings.allowRootlessVoicings) {
        return;
      }
      if (settings.voicingComplexity == VoicingComplexity.basic &&
          template.family == VoicingFamily.altered &&
          !interpretation.isAlteredFamily) {
        return;
      }
      templates.add(template);
    }

    if (interpretation.isSusFamily) {
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.sus,
          coreLabels: const ['1', 'b7', '4'],
          optionalLabels: _dedupeLabels(['13', '9', ...supportLabels]),
          targetMidis: const [41, 50, 57, 62, 67],
          registerShifts: const [0, 2],
        ),
      );
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: const ['1', '4', 'b7'],
          optionalLabels: _dedupeLabels(['9', '13', ...supportLabels]),
          targetMidis: const [42, 49, 56, 61, 66],
        ),
      );
      if (settings.allowRootlessVoicings) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessA,
            coreLabels: const ['4', 'b7'],
            optionalLabels: _dedupeLabels(['9', '13', ...supportLabels]),
            targetMidis: const [47, 53, 58, 63, 68],
          ),
        );
      }
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.spread,
          coreLabels: const ['1', 'b7', '4'],
          optionalLabels: _dedupeLabels(['13', '9', ...supportLabels]),
          targetMidis: const [38, 50, 58, 64, 69],
          registerShifts: const [0, 3],
        ),
      );
      if (isModern) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.quartal,
            coreLabels: const ['1', '4', 'b7', '9'],
            optionalLabels: _dedupeLabels(['13', ...colorLabels]),
            targetMidis: const [38, 43, 48, 53, 58],
          ),
        );
      }
      return templates;
    }

    if (interpretation.isDominantFamily) {
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: const ['1', 'b7', '3'],
          optionalLabels: _dedupeLabels([
            ...colorLabels,
            '13',
            '9',
            ...supportLabels,
          ]),
          targetMidis: const [41, 50, 56, 62, 67],
          registerShifts: const [0, 2],
        ),
      );
      if (settings.allowRootlessVoicings) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessA,
            coreLabels: const ['3', 'b7'],
            optionalLabels: _dedupeLabels([
              ...colorLabels,
              '9',
              '13',
              ...supportLabels,
            ]),
            targetMidis: const [47, 53, 58, 63, 68],
          ),
        );
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessB,
            coreLabels: const ['b7', '3'],
            optionalLabels: _dedupeLabels([
              ...colorLabels,
              '13',
              '9',
              ...supportLabels,
            ]),
            targetMidis: const [45, 51, 57, 62, 67],
          ),
        );
      }
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.spread,
          coreLabels: const ['1', 'b7', '3'],
          optionalLabels: _dedupeLabels([
            '13',
            ...colorLabels,
            '9',
            ...supportLabels,
          ]),
          targetMidis: const [38, 50, 57, 64, 69],
          registerShifts: const [0, 3],
        ),
      );
      final tritoneSubContext = _isTritoneSubContext(chord, interpretation);
      final lydianDominantContext = _isLydianDominantContext(
        chord,
        interpretation,
      );
      final shouldAddUpperStructure =
          isModern &&
          settings.allowRootlessVoicings &&
          (interpretation.isAlteredFamily ||
              chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11 ||
              chord.symbolData.tensions.contains('#11') ||
              chord.dominantIntent == DominantIntent.lydianDominant ||
              chord.dominantContext == DominantContext.dominantIILydian ||
              tritoneSubContext);
      if (shouldAddUpperStructure) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.upperStructure,
            coreLabels: const ['3', 'b7'],
            optionalLabels: interpretation.isAlteredFamily
                ? _dedupeLabels([
                    ...colorLabels.where(_isAlteredLabel),
                    'b13',
                    '#9',
                    'b9',
                    '#11',
                  ])
                : _dedupeLabels(['#11', '13', '9', ...colorLabels]),
            targetMidis: const [47, 53, 61, 64, 69],
          ),
        );
      }
      if (isModern &&
          settings.allowRootlessVoicings &&
          (lydianDominantContext || tritoneSubContext)) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.upperStructure,
            coreLabels: const ['3', 'b7', '#11'],
            optionalLabels: _dedupeLabels(['13', '9']),
            targetMidis: const [47, 53, 59, 64, 69],
          ),
        );
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.upperStructure,
            coreLabels: const ['3', 'b7', '#11', '13'],
            optionalLabels: _dedupeLabels(['9']),
            targetMidis: const [46, 52, 58, 63, 68],
          ),
        );
      }
      final shouldAddAltered =
          interpretation.isAlteredFamily ||
          (settings.voicingComplexity == VoicingComplexity.modern &&
              colorLabels.any(_isAlteredLabel) &&
              _supportsModernAlteredContext(chord, interpretation));
      if (shouldAddAltered) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.altered,
            coreLabels: const ['3', 'b7'],
            optionalLabels: _dedupeLabels([
              ...colorLabels.where(_isAlteredLabel),
              ...colorLabels,
              '13',
              '9',
            ]),
            targetMidis: const [46, 52, 58, 63, 68],
            registerShifts: const [0, 2],
          ),
        );
        if (isModern && interpretation.isAlteredFamily) {
          addTemplate(
            _VoicingTemplate(
              family: VoicingFamily.altered,
              coreLabels: const ['3', 'b7'],
              optionalLabels: _dedupeLabels(['b9', 'b13', '#9', '#11']),
              targetMidis: const [47, 53, 58, 64, 69],
            ),
          );
          addTemplate(
            _VoicingTemplate(
              family: VoicingFamily.altered,
              coreLabels: const ['3', 'b7', 'b9'],
              optionalLabels: _dedupeLabels(['b13', '#9']),
              targetMidis: const [46, 52, 57, 62, 67],
            ),
          );
        }
      }
      return templates;
    }

    if (interpretation.isHalfDiminishedFamily) {
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: const ['1', 'b7', 'b3'],
          optionalLabels: _dedupeLabels(['b5', ...colorLabels, '11', 'b13']),
          targetMidis: const [41, 49, 56, 61, 66],
        ),
      );
      if (settings.allowRootlessVoicings) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessA,
            coreLabels: const ['b3', 'b7'],
            optionalLabels: _dedupeLabels(['11', 'b13', 'b5']),
            targetMidis: const [46, 52, 58, 63, 68],
          ),
        );
      }
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.spread,
          coreLabels: const ['1', 'b7', 'b3'],
          optionalLabels: _dedupeLabels(['11', 'b5', 'b13']),
          targetMidis: const [38, 49, 57, 63, 68],
          registerShifts: const [0, 3],
        ),
      );
      return templates;
    }

    if (interpretation.isMinorFamily) {
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: const ['1', 'b7', 'b3'],
          optionalLabels: _dedupeLabels([
            ...colorLabels,
            '11',
            '9',
            '13',
            ...supportLabels,
          ]),
          targetMidis: const [41, 49, 56, 62, 67],
          registerShifts: const [0, 2],
        ),
      );
      if (settings.allowRootlessVoicings && !interpretation.isTriadFamily) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessA,
            coreLabels: const ['b3', 'b7'],
            optionalLabels: _dedupeLabels(['9', '11', '13', ...supportLabels]),
            targetMidis: const [46, 52, 58, 63, 68],
          ),
        );
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessB,
            coreLabels: const ['b7', 'b3'],
            optionalLabels: _dedupeLabels(['11', '9', '13', ...supportLabels]),
            targetMidis: const [44, 51, 57, 62, 67],
          ),
        );
      }
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.spread,
          coreLabels: const ['1', 'b7', 'b3'],
          optionalLabels: _dedupeLabels([
            '11',
            ...colorLabels,
            '9',
            '13',
            ...supportLabels,
          ]),
          targetMidis: const [38, 49, 57, 64, 69],
          registerShifts: const [0, 3],
        ),
      );
      if (isModern &&
          interpretation.essentialLabels.contains('b7') &&
          !interpretation.isTriadFamily) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.quartal,
            coreLabels: const ['11', 'b7', 'b3'],
            optionalLabels: _dedupeLabels(['13', '9', '1', ...colorLabels]),
            targetMidis: const [43, 48, 53, 58, 63],
          ),
        );
      }
      return templates;
    }

    if (interpretation.isMajorFamily) {
      final guideLabel = interpretation.essentialLabels.contains('7')
          ? '7'
          : '6';
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: ['1', guideLabel, '3'],
          optionalLabels: _dedupeLabels([
            ...colorLabels,
            '9',
            '13',
            '5',
            ...supportLabels,
          ]),
          targetMidis: const [41, 50, 56, 62, 67],
          registerShifts: const [0, 2],
        ),
      );
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.shell,
          coreLabels: ['1', '3', guideLabel],
          optionalLabels: _dedupeLabels([
            '9',
            ...colorLabels,
            '13',
            '5',
            ...supportLabels,
          ]),
          targetMidis: const [41, 48, 55, 61, 66],
        ),
      );
      if (settings.allowRootlessVoicings && !interpretation.isTriadFamily) {
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessA,
            coreLabels: ['3', guideLabel],
            optionalLabels: _dedupeLabels(['9', '13', '5', ...supportLabels]),
            targetMidis: const [47, 53, 58, 63, 68],
          ),
        );
        addTemplate(
          _VoicingTemplate(
            family: VoicingFamily.rootlessB,
            coreLabels: [guideLabel, '3'],
            optionalLabels: _dedupeLabels(['13', '9', '5', ...supportLabels]),
            targetMidis: const [45, 51, 57, 62, 67],
          ),
        );
      }
      addTemplate(
        _VoicingTemplate(
          family: VoicingFamily.spread,
          coreLabels: ['1', guideLabel, '3'],
          optionalLabels: _dedupeLabels([
            '9',
            ...colorLabels,
            '13',
            '5',
            ...supportLabels,
          ]),
          targetMidis: const [38, 50, 57, 64, 69],
          registerShifts: const [0, 3],
        ),
      );
      return templates;
    }

    addTemplate(
      _VoicingTemplate(
        family: VoicingFamily.shell,
        coreLabels: interpretation.essentialLabels,
        optionalLabels: supportLabels,
        targetMidis: const [41, 49, 56, 62, 67],
      ),
    );
    addTemplate(
      _VoicingTemplate(
        family: VoicingFamily.spread,
        coreLabels: interpretation.essentialLabels,
        optionalLabels: supportLabels,
        targetMidis: const [38, 49, 57, 64, 69],
        registerShifts: const [0, 3],
      ),
    );
    return templates;
  }

  static List<List<String>> _buildTemplateLabelVariants({
    required _VoicingTemplate template,
    required ChordVoicingInterpretation interpretation,
    required int maxNotes,
  }) {
    final essentialSet = interpretation.essentialLabels.toSet();
    var labels = _dedupeLabels(template.coreLabels);

    if (interpretation.bassAnchorLabel != null &&
        !labels.contains(interpretation.bassAnchorLabel)) {
      labels = [interpretation.bassAnchorLabel!, ...labels];
    }

    for (final essential in interpretation.essentialLabels) {
      if (!labels.contains(essential)) {
        labels.add(essential);
      }
    }

    final desiredMax = maxNotes.clamp(3, 5);
    for (final optional in template.optionalLabels) {
      if (labels.length >= desiredMax) {
        break;
      }
      if (interpretation.avoidTones.any((tone) => tone.label == optional)) {
        continue;
      }
      if (!labels.contains(optional)) {
        labels.add(optional);
      }
    }

    if (template.family == VoicingFamily.altered) {
      for (final alteredLabel in template.optionalLabels.where(
        _isAlteredLabel,
      )) {
        if (labels.where(_isAlteredLabel).length >=
            min(2, max(1, interpretation.requiredAlteredToneCount))) {
          break;
        }
        if (!labels.contains(alteredLabel)) {
          labels.add(alteredLabel);
        }
      }
    }

    final baseLabels = _trimLabelsToMax(
      labels: labels,
      maxNotes: desiredMax,
      essentialSet: essentialSet,
      bassAnchorLabel: interpretation.bassAnchorLabel,
      family: template.family,
    );
    final variants = <List<String>>[];
    final seen = <String>{};

    void addVariant(List<String> candidate) {
      if (candidate.length < 3) {
        return;
      }
      final signature = candidate.join(',');
      if (seen.add(signature)) {
        variants.add(candidate);
      }
    }

    addVariant(baseLabels);
    var working = [...baseLabels];
    while (working.length > 3) {
      final removable = _nextVariantRemovalLabel(
        labels: working,
        essentialSet: essentialSet,
        bassAnchorLabel: interpretation.bassAnchorLabel,
        family: template.family,
      );
      if (removable == null) {
        break;
      }
      working = [...working]..remove(removable);
      addVariant(working);
    }

    return variants;
  }

  static List<String> _trimLabelsToMax({
    required List<String> labels,
    required int maxNotes,
    required Set<String> essentialSet,
    required String? bassAnchorLabel,
    required VoicingFamily family,
  }) {
    final working = [...labels];
    final removablePreference = [
      '1',
      '5',
      '9',
      '11',
      '13',
      '#11',
      'b9',
      '#9',
      'b13',
      '6',
      '#5',
    ];
    while (working.length > maxNotes) {
      var removed = false;
      for (final candidate in removablePreference) {
        if (working.contains(candidate) &&
            !essentialSet.contains(candidate) &&
            candidate != bassAnchorLabel &&
            !(family == VoicingFamily.altered && _isAlteredLabel(candidate))) {
          working.remove(candidate);
          removed = true;
          break;
        }
      }
      if (!removed &&
          working.contains('1') &&
          '1' != bassAnchorLabel &&
          family != VoicingFamily.shell) {
        working.remove('1');
        removed = true;
      }
      if (!removed) {
        final removable = working.lastWhere(
          (label) => !essentialSet.contains(label) && label != bassAnchorLabel,
          orElse: () => '',
        );
        if (removable.isEmpty) {
          break;
        }
        working.remove(removable);
      }
    }
    return working;
  }

  static String? _nextVariantRemovalLabel({
    required List<String> labels,
    required Set<String> essentialSet,
    required String? bassAnchorLabel,
    required VoicingFamily family,
  }) {
    final removablePreference = switch (family) {
      VoicingFamily.shell => const [
        '13',
        '9',
        '11',
        '#11',
        'b9',
        '#9',
        'b13',
        '6',
        '#5',
        '5',
        '1',
      ],
      VoicingFamily.spread => const [
        '13',
        '9',
        '11',
        '#11',
        'b9',
        '#9',
        'b13',
        '6',
        '#5',
        '5',
        '1',
      ],
      VoicingFamily.quartal => const ['13', '9', '1', '5'],
      VoicingFamily.upperStructure => const [
        '13',
        '9',
        'b13',
        'b9',
        '#9',
        '1',
        '5',
      ],
      _ => const [
        '1',
        '5',
        '9',
        '11',
        '13',
        '#11',
        'b9',
        '#9',
        'b13',
        '6',
        '#5',
      ],
    };
    for (final candidate in removablePreference) {
      if (labels.contains(candidate) &&
          !essentialSet.contains(candidate) &&
          candidate != bassAnchorLabel) {
        return candidate;
      }
    }
    for (final label in labels.reversed) {
      if (!essentialSet.contains(label) && label != bassAnchorLabel) {
        return label;
      }
    }
    return null;
  }

  static ConcreteVoicing? _realizeTemplate({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required _VoicingTemplate template,
    required List<String> toneLabels,
    required int registerShift,
    required int maxNotes,
  }) {
    if (toneLabels.length > maxNotes) {
      return null;
    }

    final midiNotes = <int>[];
    final noteNames = <String>[];
    final targets = template.targetMidis;

    for (var index = 0; index < toneLabels.length; index += 1) {
      final toneLabel = toneLabels[index];
      final toneSemitone = _toneSemitones[toneLabel];
      if (toneSemitone == null) {
        return null;
      }
      final pitchClass = (interpretation.rootSemitone + toneSemitone) % 12;
      final target =
          (index < targets.length
              ? targets[index]
              : targets.last + ((index - targets.length + 1) * 5)) +
          registerShift;
      final minPitch = midiNotes.isEmpty
          ? 36
          : midiNotes.last + _minimumGap(midiNotes.last);
      final resolvedPitch = _nearestPitchForPitchClass(
        pitchClass: pitchClass,
        targetMidi: target,
        minPitch: minPitch,
        maxPitch: midiNotes.isEmpty ? 58 : 84,
      );
      if (resolvedPitch == null) {
        return null;
      }
      var pitch = resolvedPitch;
      if (midiNotes.isNotEmpty && pitch <= midiNotes.last) {
        while (pitch <= midiNotes.last) {
          pitch += 12;
        }
      }
      if (pitch > 84) {
        return null;
      }
      midiNotes.add(pitch);
      final isBassAnchor =
          index == 0 &&
          chord.symbolData.bass != null &&
          interpretation.bassAnchorLabel == toneLabel;
      noteNames.add(
        _spellDisplayTone(
          chord: chord,
          interpretation: interpretation,
          toneLabel: toneLabel,
          pitchClass: pitchClass,
          isBassAnchor: isBassAnchor,
        ),
      );
    }

    final voicing = ConcreteVoicing(
      midiNotes: midiNotes,
      noteNames: noteNames,
      toneLabels: toneLabels,
      tensions: {
        for (final label in toneLabels)
          if (_tensionLabels.contains(label) || _isAlteredLabel(label)) label,
      },
      family: template.family,
      topNote: midiNotes.last,
      bassNote: midiNotes.first,
      containsRoot: toneLabels.contains('1'),
      containsThird: toneLabels.contains('3') || toneLabels.contains('b3'),
      containsSeventh:
          toneLabels.contains('7') ||
          toneLabels.contains('b7') ||
          toneLabels.contains('6'),
      signature:
          '${template.family.name}:${midiNotes.join('-')}:${toneLabels.join(',')}',
    );

    if (!_isValidVoicing(
      voicing: voicing,
      interpretation: interpretation,
      maxNotes: maxNotes,
    )) {
      return null;
    }
    return voicing;
  }

  static bool _isValidVoicing({
    required ConcreteVoicing voicing,
    required ChordVoicingInterpretation interpretation,
    required int maxNotes,
  }) {
    if (voicing.noteCount < 3 || voicing.noteCount > maxNotes) {
      return false;
    }
    final labels = voicing.toneLabels.toSet();
    if (!interpretation.essentialLabels.every(labels.contains)) {
      return false;
    }
    if (interpretation.requiredAlteredToneCount > 0 &&
        voicing.tensions.where(_isAlteredLabel).length <
            interpretation.requiredAlteredToneCount) {
      return false;
    }
    if ((voicing.topNote - voicing.bassNote) > 24) {
      return false;
    }
    for (var index = 0; index < voicing.midiNotes.length - 1; index += 1) {
      final lower = voicing.midiNotes[index];
      final gap = voicing.midiNotes[index + 1] - lower;
      if (gap <= 0) {
        return false;
      }
      if (lower < 48 && gap < 3) {
        return false;
      }
      if (lower < 54 && gap < 2) {
        return false;
      }
    }
    return true;
  }

  static int? _nearestPitchForPitchClass({
    required int pitchClass,
    required int targetMidi,
    required int minPitch,
    required int maxPitch,
  }) {
    int? best;
    var bestDistance = 1 << 30;
    for (var octave = 2; octave <= 7; octave += 1) {
      final pitch = pitchClass + (octave * 12);
      if (pitch < minPitch || pitch > maxPitch) {
        continue;
      }
      final distance = (pitch - targetMidi).abs();
      if (distance < bestDistance) {
        best = pitch;
        bestDistance = distance;
      }
    }
    return best;
  }

  static int _minimumGap(int lowerMidi) {
    if (lowerMidi < 45) {
      return 5;
    }
    if (lowerMidi < 52) {
      return 4;
    }
    if (lowerMidi < 60) {
      return 3;
    }
    return 2;
  }

  static int _minimalVoiceMotion(List<int> previous, List<int> current) {
    final memo = <String, int>{};
    const skipPenalty = 6;

    int solve(int previousIndex, int currentIndex) {
      final key = '$previousIndex:$currentIndex';
      final cached = memo[key];
      if (cached != null) {
        return cached;
      }
      if (previousIndex >= previous.length && currentIndex >= current.length) {
        return 0;
      }
      if (previousIndex >= previous.length) {
        final remaining = (current.length - currentIndex) * skipPenalty;
        memo[key] = remaining;
        return remaining;
      }
      if (currentIndex >= current.length) {
        final remaining = (previous.length - previousIndex) * skipPenalty;
        memo[key] = remaining;
        return remaining;
      }

      final matchCost =
          (previous[previousIndex] - current[currentIndex]).abs() +
          solve(previousIndex + 1, currentIndex + 1);
      final skipPrevious = skipPenalty + solve(previousIndex + 1, currentIndex);
      final skipCurrent = skipPenalty + solve(previousIndex, currentIndex + 1);
      final result = min(matchCost, min(skipPrevious, skipCurrent));
      memo[key] = result;
      return result;
    }

    return solve(0, 0);
  }

  static List<String> _dedupeLabels(List<String> labels) {
    final seen = <String>{};
    final unique = <String>[];
    for (final label in labels) {
      if (seen.add(label)) {
        unique.add(label);
      }
    }
    return unique;
  }

  static List<VoicingTone> _tonesFromLabels(
    List<String> labels, {
    Map<String, int> priorityOverrides = const {},
    int startPriority = 60,
    bool qualityImplied = false,
  }) {
    final tones = <VoicingTone>[];
    for (var index = 0; index < labels.length; index += 1) {
      final label = labels[index];
      final semitone = _toneSemitones[label];
      if (semitone == null) {
        continue;
      }
      tones.add(
        VoicingTone(
          label: label,
          semitone: semitone,
          priority: priorityOverrides[label] ?? (startPriority - index),
          qualityImplied: qualityImplied && _tensionLabels.contains(label),
        ),
      );
    }
    return tones;
  }

  static String _bestLabelForRelativeSemitone({
    required int relativeSemitone,
    required List<String> candidateLabels,
    required ChordQuality renderQuality,
  }) {
    for (final label in candidateLabels) {
      if (_toneSemitones[label] == relativeSemitone) {
        return label;
      }
    }
    return switch (relativeSemitone) {
      0 => '1',
      1 => 'b9',
      2 => '9',
      3 =>
        renderQuality == ChordQuality.minorTriad ||
                renderQuality == ChordQuality.minor7 ||
                renderQuality == ChordQuality.halfDiminished7 ||
                renderQuality == ChordQuality.minor6 ||
                renderQuality == ChordQuality.minorMajor7
            ? 'b3'
            : '#9',
      4 => '3',
      5 => _isSusQuality(renderQuality) ? '4' : '11',
      6 => renderQuality == ChordQuality.halfDiminished7 ? 'b5' : '#11',
      7 => '5',
      8 => renderQuality == ChordQuality.augmentedTriad ? '#5' : 'b13',
      9 => renderQuality == ChordQuality.major69 ? '6' : '13',
      10 => 'b7',
      11 => '7',
      _ => '1',
    };
  }

  static String _spellDisplayTone({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required String toneLabel,
    required int pitchClass,
    required bool isBassAnchor,
  }) {
    if (isBassAnchor) {
      return chord.symbolData.bass!;
    }
    final spelledByDegree = _spellToneForRoot(chord.symbolData.root, toneLabel);
    if (!_hasComplexAccidental(spelledByDegree) &&
        !_shouldRespellByPitchClass(
          toneLabel: toneLabel,
          degreeSpelling: spelledByDegree,
          interpretation: interpretation,
        )) {
      return spelledByDegree;
    }
    return _spellPitchClass(
      pitchClass: pitchClass,
      preferFlat: _preferFlatForToneLabel(
        toneLabel: toneLabel,
        interpretation: interpretation,
      ),
    );
  }

  static bool _hasComplexAccidental(String noteName) {
    return noteName.contains('bb') || noteName.contains('##');
  }

  static bool _shouldRespellByPitchClass({
    required String toneLabel,
    required String degreeSpelling,
    required ChordVoicingInterpretation interpretation,
  }) {
    if (!_tensionLabels.contains(toneLabel) && !_isAlteredLabel(toneLabel)) {
      return false;
    }
    if (toneLabel.startsWith('b') && degreeSpelling.contains('#')) {
      return true;
    }
    if (toneLabel.startsWith('#') && degreeSpelling.contains('b')) {
      return true;
    }
    if (_isNeutralTensionLabel(toneLabel)) {
      if (interpretation.preferFlatSpelling && degreeSpelling.contains('#')) {
        return true;
      }
      if (!interpretation.preferFlatSpelling && degreeSpelling.contains('b')) {
        return true;
      }
    }
    return false;
  }

  static bool _isNeutralTensionLabel(String toneLabel) {
    return toneLabel == '9' || toneLabel == '11' || toneLabel == '13';
  }

  static bool _preferFlatForToneLabel({
    required String toneLabel,
    required ChordVoicingInterpretation interpretation,
  }) {
    if (toneLabel.startsWith('b')) {
      return true;
    }
    if (toneLabel.startsWith('#')) {
      return false;
    }
    return interpretation.preferFlatSpelling;
  }

  static String _spellPitchClass({
    required int pitchClass,
    required bool preferFlat,
  }) {
    final normalizedPitchClass = pitchClass % 12;
    return preferFlat
        ? (_flatPitchClassNames[normalizedPitchClass] ?? 'C')
        : (_sharpPitchClassNames[normalizedPitchClass] ?? 'C');
  }

  static String _spellToneForRoot(String root, String toneLabel) {
    final rootLetter = root.substring(0, 1);
    final rootLetterIndex = _letters.indexOf(rootLetter);
    final naturalRootSemitone = _naturalSemitones[rootLetter] ?? 0;
    final rootAccidental = _accidentalOffset(root.substring(1));
    final rootSemitone = (naturalRootSemitone + rootAccidental) % 12;
    final degreeNumber = _degreeNumberForLabel(toneLabel);
    final targetLetter = _letters[(rootLetterIndex + degreeNumber - 1) % 7];
    final targetNaturalSemitone = _naturalSemitones[targetLetter] ?? 0;
    final desiredSemitone =
        (rootSemitone + (_toneSemitones[toneLabel] ?? 0)) % 12;
    var accidentalDistance = desiredSemitone - targetNaturalSemitone;
    while (accidentalDistance > 6) {
      accidentalDistance -= 12;
    }
    while (accidentalDistance < -6) {
      accidentalDistance += 12;
    }
    final accidental = switch (accidentalDistance) {
      -2 => 'bb',
      -1 => 'b',
      0 => '',
      1 => '#',
      2 => '##',
      _ => accidentalDistance < 0 ? 'b' : '#',
    };
    return '$targetLetter$accidental';
  }

  static int _degreeNumberForLabel(String toneLabel) {
    return switch (toneLabel) {
      '1' => 1,
      'b9' || '9' || '#9' => 2,
      'b3' || '3' => 3,
      '4' || '11' || '#11' => 4,
      'b5' || '5' || '#5' => 5,
      '6' || '13' || 'b13' => 6,
      'b7' || '7' => 7,
      _ => 1,
    };
  }

  static int _accidentalOffset(String suffix) {
    var value = 0;
    for (final codeUnit in suffix.codeUnits) {
      if (codeUnit == '#'.codeUnitAt(0)) {
        value += 1;
      } else if (codeUnit == 'b'.codeUnitAt(0)) {
        value -= 1;
      }
    }
    return value;
  }

  static bool _isGuideToneLabel(String label) {
    return label == '3' ||
        label == 'b3' ||
        label == '7' ||
        label == 'b7' ||
        label == '4';
  }

  static bool _isAlteredLabel(String label) => _alteredLabels.contains(label);

  static bool _isSusQuality(ChordQuality quality) {
    return quality == ChordQuality.dominant7sus4 ||
        quality == ChordQuality.dominant13sus4;
  }

  static int _familyOrder(VoicingFamily family) {
    return switch (family) {
      VoicingFamily.shell => 0,
      VoicingFamily.rootlessA => 1,
      VoicingFamily.rootlessB => 2,
      VoicingFamily.spread => 3,
      VoicingFamily.sus => 4,
      VoicingFamily.quartal => 5,
      VoicingFamily.altered => 6,
      VoicingFamily.upperStructure => 7,
    };
  }
}

class _ResolvedProgressionContext {
  const _ResolvedProgressionContext({
    required this.source,
    required this.previousReference,
    required this.lookAheadChords,
    required this.availableSignatures,
    required this.availableTopNotePitchClasses,
  });

  final VoicingContext source;
  final ConcreteVoicing? previousReference;
  final List<GeneratedChord> lookAheadChords;
  final Set<String> availableSignatures;
  final Set<int> availableTopNotePitchClasses;

  PracticeSettings get settings => source.settings;

  GeneratedChord? get previousChord => source.previousChord;

  GeneratedChord get currentChord => source.currentChord;

  GeneratedChord? get nextChord => source.nextLookAheadChord;

  GeneratedChord? get nextNextChord => source.nextNextLookAheadChord;

  int get effectiveLookAheadDepth => source.effectiveLookAheadDepth;

  ConcreteVoicing? get lockedContinuityReference =>
      source.lockContinuityReference;

  bool get isSameHarmonyRepeat =>
      previousChord?.harmonicComparisonKey ==
      currentChord.harmonicComparisonKey;

  VoicingTopNoteSource? get topNotePreferenceSource {
    if (lockedContinuityReference != null &&
        availableSignatures.contains(lockedContinuityReference!.signature)) {
      return VoicingTopNoteSource.lockedContinuity;
    }
    if (source.preferredTopNotePitchClass != null) {
      return VoicingTopNoteSource.explicitPreference;
    }
    if (isSameHarmonyRepeat && previousReference != null) {
      return VoicingTopNoteSource.sameHarmonyCarry;
    }
    return null;
  }

  int? get topNotePitchClassPreference {
    return switch (topNotePreferenceSource) {
      VoicingTopNoteSource.lockedContinuity =>
        lockedContinuityReference?.topNotePitchClass,
      VoicingTopNoteSource.explicitPreference =>
        source.preferredTopNotePitchClass,
      VoicingTopNoteSource.sameHarmonyCarry =>
        previousReference?.topNotePitchClass,
      null => null,
    };
  }

  VoicingTopNoteMatch? get topNoteMatch {
    final preferredPitchClass = topNotePitchClassPreference;
    if (preferredPitchClass == null || availableTopNotePitchClasses.isEmpty) {
      return null;
    }
    final minimumDistance = availableTopNotePitchClasses
        .map(
          (pitchClass) => VoicingEngine._pitchClassDistance(
            pitchClass,
            preferredPitchClass,
          ),
        )
        .reduce(min);
    if (minimumDistance == 0) {
      return VoicingTopNoteMatch.exact;
    }
    if (minimumDistance == 1) {
      return VoicingTopNoteMatch.nearby;
    }
    return VoicingTopNoteMatch.unavailable;
  }

  bool get hasLockedContinuity => source.hasLockedContinuity;

  bool get isFreeModeFallback => source.isFreeModeFallback;

  String get diagnosticSummary => source.diagnosticSummary;
}

class _VoicingTemplate {
  const _VoicingTemplate({
    required this.family,
    required this.coreLabels,
    required this.optionalLabels,
    required this.targetMidis,
    this.registerShifts = const [0],
  });

  final VoicingFamily family;
  final List<String> coreLabels;
  final List<String> optionalLabels;
  final List<int> targetMidis;
  final List<int> registerShifts;
}

class _TransitionScore {
  const _TransitionScore({
    required this.guideToneResolutionBonus,
    required this.commonToneRetentionBonus,
    required this.totalVoiceMotionPenalty,
    required this.outerVoiceLeapPenalty,
    required this.bassMovementPenalty,
    required this.sameRootSusReleaseBonus,
    required this.commonToneCount,
    required this.guideResolutionCount,
    required this.totalMotionSemitones,
  });

  final double guideToneResolutionBonus;
  final double commonToneRetentionBonus;
  final double totalVoiceMotionPenalty;
  final double outerVoiceLeapPenalty;
  final double bassMovementPenalty;
  final double sameRootSusReleaseBonus;
  final int commonToneCount;
  final int guideResolutionCount;
  final int totalMotionSemitones;
}
