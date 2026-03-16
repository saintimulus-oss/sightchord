import 'dart:math';

import '../settings/practice_settings.dart';
import 'melody_candidate_builder.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';
import 'melody_seed_util.dart';
import 'phrase_planner.dart';
import 'rhythm_template_sampler.dart';

class MelodyScoring {
  const MelodyScoring._();

  static double scoreCandidate({
    required MelodyCandidate candidate,
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required int slotIndex,
    required MelodyDecodeContext context,
  }) {
    final weights = MelodyGenerationConfig.scoringWeights;
    final chordFit = _chordFit(candidate, slot: slot, context: context);
    final intervalFit = _intervalFit(
      candidate,
      beamNotes: beamNotes,
      slot: slot,
      bpm: context.request.settings.bpm,
      context: context,
    );
    final directionFit = _directionFit(
      candidate,
      beamNotes: beamNotes,
      slot: slot,
      context: context,
    );
    final metricFit = _metricFit(candidate, slot: slot, context: context);
    final phraseFit = _phraseFit(candidate, slot: slot, context: context);
    final cadenceFit = _cadenceFit(
      candidate,
      beamNotes: beamNotes,
      slot: slot,
      context: context,
    );
    final motifFit = _motifFit(
      candidate,
      beamNotes: beamNotes,
      slotIndex: slotIndex,
      context: context,
    );
    final colorFit = _colorFit(
      candidate,
      beamNotes: beamNotes,
      slotIndex: slotIndex,
      slot: slot,
      context: context,
    );
    final noveltyFit = _noveltyFit(
      candidate,
      beamNotes: beamNotes,
      slot: slot,
      slotIndex: slotIndex,
      context: context,
    );
    final rangeFit = _rangeFit(candidate, context: context);
    final jitter = _jitter(
      MelodySeedUtil.stableHashAll(<Object?>[
        context.seed,
        slotIndex,
        beamNotes.length,
        candidate.midiNote,
      ]),
    );
    return (weights.chordFit * chordFit) +
        (weights.intervalFit * intervalFit) +
        (weights.directionFit * directionFit) +
        (weights.metricFit * metricFit) +
        (weights.phraseFit * phraseFit) +
        (weights.cadenceFit * cadenceFit) +
        (weights.motifFit * motifFit) +
        (weights.colorFit * colorFit) +
        (weights.noveltyFit * noveltyFit) +
        (weights.rangeFit * rangeFit) +
        jitter;
  }

  static double finalRerankAdjustment({
    required List<BeamNote> beamNotes,
    required MelodyDecodeContext context,
  }) {
    if (beamNotes.isEmpty) {
      return double.negativeInfinity;
    }
    final notes = [for (final beamNote in beamNotes) beamNote.note];
    final mode = context.request.settings.settingsComplexityMode;
    final recentEvents = _recentWindowEvents(context);
    var score = 0.0;
    for (var distance = 1; distance <= recentEvents.length; distance += 1) {
      final recent = recentEvents[recentEvents.length - distance];
      if (_isExactSameEvent(notes, recent.notes)) {
        score += _recentExactRepeatPenalty(mode, distance);
        continue;
      }
      if (_hasSameIntervalVector(notes, recent.notes)) {
        score += _recentIntervalVectorPenalty(mode, distance);
      }
      if (_hasSameRhythmVector(notes, recent.notes)) {
        score += _recentRhythmRepeatPenalty(mode, distance);
      }
    }
    if (_isMonotoneContour(notes)) {
      score += _monotoneContourPenalty(mode);
      if (recentEvents.any((event) => _isMonotoneContour(event.notes))) {
        score += _monotoneHistoryPenalty(mode);
      }
    }
    final samePitchRepeats = _samePitchOverflow(notes, window: 4);
    score -= samePitchRepeats * 0.50;
    final meanDuration =
        notes.fold<double>(0, (sum, note) => sum + note.durationBeats) /
        max(1, notes.length);
    final localMeanDuration = _localMeanBeforeFinal(notes);
    score += _apexAlignmentAdjustment(
      notes,
      meanDuration: meanDuration,
      context: context,
    );
    score += _cadenceResolutionAdjustment(
      notes,
      meanDuration: localMeanDuration,
      context: context,
    );
    if (notes.last.durationBeats >= localMeanDuration * 1.8) {
      score += 0.75;
    }
    if (context.palette.isColorChord) {
      final colorHits = notes
          .where(
            (note) => context.palette.containsIdentityLabel(note.toneLabel),
          )
          .length;
      final realized = colorHits / notes.length;
      final distinctIdentity = {
        for (final note in notes)
          if (context.palette.containsIdentityLabel(note.toneLabel))
            note.toneLabel!,
      }.length;
      final distinctCoverage = context.palette.identityLabels.isEmpty
          ? 1.0
          : distinctIdentity / context.palette.identityLabels.length;
      score +=
          ((realized - context.phrasePlan.targetColorExposure01) * 3.2) +
          (distinctCoverage * (context.palette.isHardColorChord ? 0.8 : 0.45));
    }
    if (context.request.settings.settingsComplexityMode ==
        SettingsComplexityMode.advanced) {
      final largeLeaps = _largeLeapCount(notes);
      if (largeLeaps == 1) {
        score += 0.15;
      } else if (largeLeaps > 2) {
        score -= (largeLeaps - 2) * 0.45;
      }
    }
    if (context.nextPalette != null) {
      final distanceToNext = context.nextPalette!.featuredPitchClasses
          .map((pitchClass) {
            final target = context.nextPalette!.nearestMidisForPitchClass(
              pitchClass,
              targetMidi: notes.last.midiNote,
              low: context.request.settings.melodyRangeLow,
              high: context.request.settings.melodyRangeHigh,
              count: 1,
            );
            if (target.isEmpty) {
              return 99;
            }
            return (target.first - notes.last.midiNote).abs();
          })
          .fold<int>(99, min);
      if (distanceToNext <= 2) {
        score += 0.9;
      }
    }
    return score;
  }

  static double _chordFit(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (candidate.toneLabel == null) {
      return candidate.category == MelodyCandidateCategory.chromatic
          ? -0.15
          : 0.1;
    }
    if (context.palette.containsIdentityLabel(candidate.toneLabel)) {
      final bias = context.request.settings.colorRealizationBias;
      final priority = context.palette.identityPriorityFor(candidate.toneLabel);
      final identityBonus = max(0.0, 0.26 - (priority * 0.05));
      final modeBase =
          switch (context.request.settings.settingsComplexityMode) {
            SettingsComplexityMode.guided => 0.16,
            SettingsComplexityMode.standard => 0.24,
            SettingsComplexityMode.advanced => 0.34,
          };
      final biasFactor =
          switch (context.request.settings.settingsComplexityMode) {
            SettingsComplexityMode.guided => 0.24,
            SettingsComplexityMode.standard => 0.40,
            SettingsComplexityMode.advanced => 0.58,
          };
      return context.palette.isColorChord
          ? modeBase + identityBonus + (bias * biasFactor)
          : (modeBase * 0.6) + identityBonus + (bias * (biasFactor * 0.5));
    }
    if (context.palette.featuredLabels.contains(candidate.toneLabel)) {
      final priority = context.palette.featuredPriorityFor(candidate.toneLabel);
      return 1.05 + max(0.0, 0.14 - (priority * 0.02));
    }
    if (context.palette.chordToneLabels.contains(candidate.toneLabel)) {
      final genericPenalty = context.palette.isColorChord && slot.isStrong
          ? 0.12
          : 0.0;
      return (slot.isStrong ? 0.95 : 0.65) - genericPenalty;
    }
    if (candidate.category == MelodyCandidateCategory.diatonic ||
        candidate.category == MelodyCandidateCategory.nonChord) {
      return slot.isStrong ? 0.05 : 0.30;
    }
    return -0.25;
  }

  static double _intervalFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required int bpm,
    required MelodyDecodeContext context,
  }) {
    if (beamNotes.isEmpty) {
      return 0.45;
    }
    final previousMidi = beamNotes.last.note.midiNote;
    final absSemitones = (candidate.midiNote - previousMidi).abs();
    var score =
        MelodyGenerationConfig.intervalBase[absSemitones] ??
        (-2.0 - ((absSemitones - 9) * 0.4));
    if (absSemitones == 0) {
      score += switch (context.request.settings.settingsComplexityMode) {
        SettingsComplexityMode.guided => 0.78,
        SettingsComplexityMode.standard => 0.42,
        SettingsComplexityMode.advanced => 0.28,
      };
    }
    final durMs = (slot.durationBeats * 60000 / max(1, bpm)).round();
    if (durMs < 700 && absSemitones > 2) {
      score -= 0.18 * (absSemitones - 2);
    }
    if (durMs < 350 && absSemitones > 4) {
      score -= 0.35 * (absSemitones - 4);
    }
    if (context.request.settings.settingsComplexityMode ==
            SettingsComplexityMode.advanced &&
        (slot.phrasePos01 - context.phrasePlan.apexPos01).abs() <= 0.14 &&
        absSemitones >= 8 &&
        absSemitones <= 12) {
      score += candidate.targetsColor ? 2.0 : 1.8;
    }
    return score;
  }

  static double _directionFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (beamNotes.isEmpty) {
      return 0.35;
    }
    final previousMidi = beamNotes.last.note.midiNote;
    final currentInterval = candidate.midiNote - previousMidi;
    if (currentInterval == 0) {
      return switch (context.request.settings.settingsComplexityMode) {
        SettingsComplexityMode.guided => 0.32,
        SettingsComplexityMode.standard => 0.12,
        SettingsComplexityMode.advanced => 0.18,
      };
    }
    final desiredDirection =
        context.targetMidiFor(min(1.0, slot.phrasePos01 + 0.18)) -
        context.targetMidiFor(slot.phrasePos01);
    var score = currentInterval.sign == desiredDirection.sign ? 0.35 : -0.10;
    if (context.request.settings.settingsComplexityMode ==
            SettingsComplexityMode.advanced &&
        (slot.phrasePos01 - context.phrasePlan.apexPos01).abs() <= 0.14 &&
        currentInterval.abs() >= 8 &&
        currentInterval.abs() <= 12) {
      score += candidate.targetsColor ? 0.55 : 0.42;
    }
    if (beamNotes.length >= 2) {
      final previousInterval =
          beamNotes.last.note.midiNote -
          beamNotes[beamNotes.length - 2].note.midiNote;
      if (previousInterval.abs() >= 5) {
        if (currentInterval.sign != previousInterval.sign &&
            currentInterval.abs() >= 1 &&
            currentInterval.abs() <= 3) {
          score += 0.90;
        }
        if (currentInterval.sign == previousInterval.sign &&
            currentInterval.abs() >= 5) {
          score -= 0.80;
        }
      } else if (context.effectiveStyle == MelodyStyle.lyrical &&
          currentInterval.sign == previousInterval.sign &&
          currentInterval.abs() <= 2) {
        score += 0.25;
      } else if (context.request.settings.settingsComplexityMode !=
              SettingsComplexityMode.guided &&
          currentInterval.sign != previousInterval.sign &&
          currentInterval.abs() <= 2) {
        score += 0.20;
      }
    }
    return score;
  }

  static double _metricFit(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    var score = slot.metricStrength - 0.4;
    if (slot.isStrong &&
        (candidate.category == MelodyCandidateCategory.chord ||
            candidate.category == MelodyCandidateCategory.tension)) {
      score += 0.30;
    }
    if (!slot.isStrong &&
        (candidate.category == MelodyCandidateCategory.diatonic ||
            candidate.category == MelodyCandidateCategory.chromatic)) {
      score += 0.08 + (context.request.settings.syncopationBias * 0.10);
    }
    if (slot.syncopationKey == '&2' || slot.syncopationKey == '&4') {
      score += context.request.settings.syncopationBias * 0.12;
    }
    if (slot.anticipatory) {
      score += context.request.settings.anticipationProbability * 0.22;
    }
    return score;
  }

  static double _phraseFit(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    final targetMidi = context.targetMidiFor(slot.phrasePos01);
    final distance = (candidate.midiNote - targetMidi).abs().toDouble();
    var score = max(0.0, 1.25 - (distance * 0.12));
    final apexDistance = (candidate.midiNote - context.phrasePlan.apexMidi)
        .abs();
    if ((slot.phrasePos01 - context.phrasePlan.apexPos01).abs() <= 0.18) {
      score += max(0.0, 0.55 - (apexDistance * 0.08));
    }
    score += switch (context.phrasePlan.role) {
      PhraseRole.opening => _openingPhraseBias(
        candidate,
        slot: slot,
        context: context,
      ),
      PhraseRole.continuation => _continuationPhraseBias(
        candidate,
        slot: slot,
        context: context,
      ),
      PhraseRole.preCadence => _preCadencePhraseBias(
        candidate,
        slot: slot,
        context: context,
      ),
      PhraseRole.cadence => _cadencePhraseBias(
        candidate,
        slot: slot,
        context: context,
      ),
    };
    return score;
  }

  static double _cadenceFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (!context.phrasePlan.isCadential) {
      return _boundaryFit(
        candidate,
        beamNotes: beamNotes,
        slot: slot,
        context: context,
      );
    }
    var score = 0.0;
    if (slot.index == context.rhythmSample.slots.length - 1) {
      final distanceToEnd = (candidate.midiNote - context.anchors.endMidi)
          .abs();
      score += max(0.0, 1.0 - (distanceToEnd * 0.14));
      if (_degreePriorityMatch(
        candidate.toneLabel,
        context.phrasePlan.endingDegreePriority,
      )) {
        score += 0.40;
      }
    }
    if (context.nextPalette != null) {
      final closestNext = context.nextPalette!.featuredPitchClasses
          .map((pitchClass) {
            final targets = context.nextPalette!.nearestMidisForPitchClass(
              pitchClass,
              targetMidi: candidate.midiNote,
              low: context.request.settings.melodyRangeLow,
              high: context.request.settings.melodyRangeHigh,
              count: 1,
            );
            if (targets.isEmpty) {
              return 99;
            }
            return (targets.first - candidate.midiNote).abs();
          })
          .fold<int>(99, min);
      score += max(0.0, 0.7 - (closestNext * 0.18));
    }
    return score +
        _boundaryFit(
          candidate,
          beamNotes: beamNotes,
          slot: slot,
          context: context,
        );
  }

  static bool _degreePriorityMatch(
    String? toneLabel,
    int endingDegreePriority,
  ) {
    return switch (endingDegreePriority) {
      1 => toneLabel == '1' || toneLabel == '3',
      3 => toneLabel == '3' || toneLabel == 'b3',
      5 => toneLabel == '5',
      7 => toneLabel == '7' || toneLabel == 'b7',
      _ => false,
    };
  }

  static double _motifFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required int slotIndex,
    required MelodyDecodeContext context,
  }) {
    if (slotIndex == 0 || context.motifPlan.memory.intervalVector.isEmpty) {
      return context.motifPlan.usesPreviousMaterial ? 0.18 : 0.08;
    }
    final previousMidi = beamNotes.isEmpty
        ? context.anchors.startMidi
        : beamNotes.last.note.midiNote;
    final interval = candidate.midiNote - previousMidi;
    final target =
        context.motifPlan.memory.intervalVector[min(
          slotIndex - 1,
          context.motifPlan.memory.intervalVector.length - 1,
        )];
    final delta = (interval - target).abs();
    var score = delta == 0 ? 1.0 : max(0.0, 0.9 - (delta * 0.22));
    final targetToneLabel =
        context.motifPlan.memory.toneLabels[min(
          slotIndex,
          context.motifPlan.memory.toneLabels.length - 1,
        )];
    if (targetToneLabel != null && candidate.toneLabel != null) {
      if (candidate.toneLabel == targetToneLabel) {
        score += 0.36;
      } else if (_toneFamily(candidate.toneLabel!) ==
          _toneFamily(targetToneLabel)) {
        score += 0.16;
      } else {
        score -= 0.14;
      }
    }
    if (context.motifPlan.transformName == 'exact' &&
        context.request.settings.exactRepeatTarget <= 0.04) {
      score -= switch (context.request.settings.settingsComplexityMode) {
        SettingsComplexityMode.guided => 0.22,
        SettingsComplexityMode.standard => 0.30,
        SettingsComplexityMode.advanced => 0.38,
      };
    } else if (context.motifPlan.transformName == 'tailChange' ||
        context.motifPlan.transformName == 'rhythmVar' ||
        context.motifPlan.transformName == 'sequence' ||
        context.motifPlan.transformName == 'inversionLite') {
      score += 0.10;
    }
    return score;
  }

  static double _colorFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required int slotIndex,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (!context.palette.isColorChord) {
      return candidate.targetsColor ? 0.12 : 0.0;
    }
    final identityHitLabels = {
      for (final note in beamNotes)
        if (context.palette.containsIdentityLabel(note.note.toneLabel))
          note.note.toneLabel!,
    };
    final realized =
        beamNotes
            .where(
              (note) =>
                  context.palette.containsIdentityLabel(note.note.toneLabel),
            )
            .length /
        max(1, slotIndex);
    final distinctCoverage = context.palette.identityLabels.isEmpty
        ? 1.0
        : identityHitLabels.length /
              min(context.palette.identityLabels.length, max(1, slotIndex));
    final outstanding = max(
      0.0,
      context.phrasePlan.targetColorExposure01 -
          ((realized * 0.72) + (distinctCoverage * 0.28)),
    );
    if (candidate.targetsColor) {
      final modeBase =
          switch (context.request.settings.settingsComplexityMode) {
            SettingsComplexityMode.guided => 0.04,
            SettingsComplexityMode.standard => 0.10,
            SettingsComplexityMode.advanced => 0.18,
          };
      final modeBonus =
          switch (context.request.settings.settingsComplexityMode) {
            SettingsComplexityMode.guided => 0.0,
            SettingsComplexityMode.standard => 0.03,
            SettingsComplexityMode.advanced => 0.08,
          };
      final missingIdentityBonus =
          candidate.toneLabel != null &&
              !identityHitLabels.contains(candidate.toneLabel)
          ? switch (context.request.settings.settingsComplexityMode) {
              SettingsComplexityMode.guided => 0.06,
              SettingsComplexityMode.standard => 0.12,
              SettingsComplexityMode.advanced => 0.18,
            }
          : 0.03;
      final hardColorBonus = context.palette.isHardColorChord
          ? (context.request.settings.settingsComplexityMode ==
                    SettingsComplexityMode.advanced
                ? 0.16
                : 0.08)
          : 0.0;
      return (modeBase +
              (context.request.settings.colorRealizationBias * 0.28)) +
          modeBonus +
          missingIdentityBonus +
          hardColorBonus +
          (outstanding *
              (0.52 + (context.request.settings.colorRealizationBias * 0.42)));
    }
    if (slot.isStrong && outstanding > 0.0) {
      final penalty =
          context.request.settings.settingsComplexityMode ==
              SettingsComplexityMode.advanced
          ? 0.16
          : 0.10;
      return -penalty -
          (outstanding * (context.palette.isHardColorChord ? 0.36 : 0.22));
    }
    if (!slot.isStrong &&
        outstanding > 0.0 &&
        context.request.settings.settingsComplexityMode ==
            SettingsComplexityMode.advanced) {
      return -0.08 - (outstanding * 0.18);
    }
    return -0.04;
  }

  static double _noveltyFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required int slotIndex,
    required MelodyDecodeContext context,
  }) {
    final mode = context.request.settings.settingsComplexityMode;
    final previousNote = beamNotes.isEmpty ? null : beamNotes.last.note;
    final sameRhythmPenalty = switch (mode) {
      SettingsComplexityMode.guided => -0.40,
      SettingsComplexityMode.standard => -0.65,
      SettingsComplexityMode.advanced => -0.85,
    };
    final sameIntervalPenalty = switch (mode) {
      SettingsComplexityMode.guided => -0.90,
      SettingsComplexityMode.standard => -1.25,
      SettingsComplexityMode.advanced => -1.60,
    };
    var score = context.request.settings.noveltyTarget * 0.55;
    if (previousNote != null && previousNote.midiNote == candidate.midiNote) {
      score += switch (mode) {
        SettingsComplexityMode.guided => 1.05,
        SettingsComplexityMode.standard => 0.72,
        SettingsComplexityMode.advanced => 0.28,
      };
    }
    if (slotIndex > 0 &&
        context.motifPlan.memory.rhythmVector.isNotEmpty &&
        slot.durationBeats.toStringAsFixed(2) ==
            context
                .motifPlan
                .memory
                .rhythmVector[min(
                  slotIndex,
                  context.motifPlan.memory.rhythmVector.length - 1,
                )]
                .toStringAsFixed(2)) {
      score += sameRhythmPenalty * 0.35;
    }
    if (beamNotes.length >= 2) {
      final previousInterval =
          beamNotes.last.note.midiNote -
          beamNotes[beamNotes.length - 2].note.midiNote;
      final currentInterval = candidate.midiNote - beamNotes.last.note.midiNote;
      if (currentInterval == previousInterval) {
        score += sameIntervalPenalty * 0.28;
      }
    }
    final recent = beamNotes.skip(max(0, beamNotes.length - 4));
    final window = [
      for (final note in recent) note.note.midiNote,
      candidate.midiNote,
    ];
    final repeats = window.where((midi) => midi == candidate.midiNote).length;
    if (repeats > 2) {
      score -= 0.45 * (repeats - 2);
    }
    final prospective = <GeneratedMelodyNote>[
      for (final beamNote in beamNotes) beamNote.note,
      GeneratedMelodyNote(
        midiNote: candidate.midiNote,
        startBeatOffset: slot.startBeatOffset,
        durationBeats: slot.durationBeats,
        role: candidate.role,
        toneLabel: candidate.toneLabel,
        structural: slot.structural,
      ),
    ];
    score += _recentPartialNoveltyPenalty(prospective, context: context);
    return score;
  }

  static double _rangeFit(
    MelodyCandidate candidate, {
    required MelodyDecodeContext context,
  }) {
    final center = context.phrasePlan.centerMidi;
    final radius = max(
      6.0,
      (context.request.settings.melodyRangeHigh -
                  context.request.settings.melodyRangeLow) /
              2.0 -
          2.0,
    );
    final distance = (candidate.midiNote - center).abs();
    return max(-0.4, 0.8 - (distance / radius));
  }

  static bool _isExactSameEvent(
    List<GeneratedMelodyNote> left,
    List<GeneratedMelodyNote> right,
  ) {
    if (left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index += 1) {
      if (left[index].midiNote != right[index].midiNote ||
          left[index].startBeatOffset.toStringAsFixed(2) !=
              right[index].startBeatOffset.toStringAsFixed(2) ||
          left[index].durationBeats.toStringAsFixed(2) !=
              right[index].durationBeats.toStringAsFixed(2)) {
        return false;
      }
    }
    return true;
  }

  static List<GeneratedMelodyEvent> _recentWindowEvents(
    MelodyDecodeContext context,
  ) {
    final merged = <GeneratedMelodyEvent>[
      ...context.request.recentMelodyEvents,
      if (context.request.previousMelodyEvent != null)
        context.request.previousMelodyEvent!,
    ];
    final deduped = <GeneratedMelodyEvent>[];
    final seen = <int>{};
    for (final event in merged) {
      if (seen.add(event.signatureHash)) {
        deduped.add(event);
      }
    }
    if (deduped.length <= 4) {
      return deduped;
    }
    return deduped.sublist(deduped.length - 4);
  }

  static double _recentPartialNoveltyPenalty(
    List<GeneratedMelodyNote> notes, {
    required MelodyDecodeContext context,
  }) {
    final mode = context.request.settings.settingsComplexityMode;
    final recentEvents = _recentWindowEvents(context);
    var score = 0.0;
    for (var distance = 1; distance <= recentEvents.length; distance += 1) {
      final recent = recentEvents[recentEvents.length - distance];
      if (recent.notes.length < notes.length) {
        continue;
      }
      final prefix = recent.notes.take(notes.length).toList(growable: false);
      if (_isExactSameEvent(notes, prefix)) {
        score += _recentExactRepeatPenalty(mode, distance) * 0.55;
        continue;
      }
      if (_hasSameIntervalVector(notes, prefix)) {
        score += _recentIntervalVectorPenalty(mode, distance) * 0.55;
      }
      if (_hasSameRhythmVector(notes, prefix)) {
        score += _recentRhythmRepeatPenalty(mode, distance) * 0.45;
      }
    }
    if (notes.length >= 4 && _isMonotoneContour(notes)) {
      score += _monotoneContourPenalty(mode) * 0.35;
    }
    return score;
  }

  static bool _hasSameIntervalVector(
    List<GeneratedMelodyNote> left,
    List<GeneratedMelodyNote> right,
  ) {
    return _intervalSignatureFor(left) == _intervalSignatureFor(right) &&
        _intervalSignatureFor(left).isNotEmpty;
  }

  static bool _hasSameRhythmVector(
    List<GeneratedMelodyNote> left,
    List<GeneratedMelodyNote> right,
  ) {
    return _rhythmSignatureFor(left) == _rhythmSignatureFor(right) &&
        _rhythmSignatureFor(left).isNotEmpty;
  }

  static String _intervalSignatureFor(List<GeneratedMelodyNote> notes) {
    if (notes.length < 2) {
      return '';
    }
    return [
      for (var index = 1; index < notes.length; index += 1)
        notes[index].midiNote - notes[index - 1].midiNote,
    ].join(',');
  }

  static String _rhythmSignatureFor(List<GeneratedMelodyNote> notes) {
    if (notes.isEmpty) {
      return '';
    }
    return notes.map((note) => note.durationBeats.toStringAsFixed(2)).join(',');
  }

  static double _recentExactRepeatPenalty(
    SettingsComplexityMode mode,
    int distance,
  ) {
    final base = switch (mode) {
      SettingsComplexityMode.guided => -3.00,
      SettingsComplexityMode.standard => -3.25,
      SettingsComplexityMode.advanced => -3.50,
    };
    return base * _distanceWeight(distance);
  }

  static double _recentIntervalVectorPenalty(
    SettingsComplexityMode mode,
    int distance,
  ) {
    final base = switch (mode) {
      SettingsComplexityMode.guided => -1.35,
      SettingsComplexityMode.standard => -1.75,
      SettingsComplexityMode.advanced => -2.10,
    };
    return base * _distanceWeight(distance);
  }

  static double _recentRhythmRepeatPenalty(
    SettingsComplexityMode mode,
    int distance,
  ) {
    final base = switch (mode) {
      SettingsComplexityMode.guided => -0.45,
      SettingsComplexityMode.standard => -0.70,
      SettingsComplexityMode.advanced => -0.95,
    };
    return base * _distanceWeight(distance);
  }

  static double _monotoneContourPenalty(SettingsComplexityMode mode) {
    return switch (mode) {
      SettingsComplexityMode.guided => -2.65,
      SettingsComplexityMode.standard => -2.85,
      SettingsComplexityMode.advanced => -3.00,
    };
  }

  static double _monotoneHistoryPenalty(SettingsComplexityMode mode) {
    return switch (mode) {
      SettingsComplexityMode.guided => -0.40,
      SettingsComplexityMode.standard => -0.55,
      SettingsComplexityMode.advanced => -0.70,
    };
  }

  static double _distanceWeight(int distance) {
    return switch (distance) {
      1 => 1.00,
      2 => 0.82,
      3 => 0.68,
      _ => 0.56,
    };
  }

  static String _toneFamily(String label) {
    if (label == '1' || label == '3' || label == 'b3' || label == '5') {
      return 'core';
    }
    if (label == '7' || label == 'b7') {
      return 'guide';
    }
    if (label == '9' ||
        label == '11' ||
        label == '#11' ||
        label == '13' ||
        label == 'b13') {
      return 'color';
    }
    if (label == 'b9' || label == '#9' || label == 'b5' || label == '4') {
      return 'edge';
    }
    return 'other';
  }

  static double _boundaryFit(
    MelodyCandidate candidate, {
    required List<BeamNote> beamNotes,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    var score = 0.0;
    final pitchClass = candidate.midiNote % 12;
    if (context.previousPalette != null &&
        context.request.previousChordEvent?.chord.harmonicComparisonKey !=
            context.request.chordEvent.chord.harmonicComparisonKey &&
        slot.index <= 1) {
      final previousPalette = context.previousPalette!;
      if (previousPalette.chordPitchClasses.contains(pitchClass) ||
          previousPalette.featuredPitchClasses.contains(pitchClass)) {
        score += 0.22;
      } else {
        final previousDistance = _distanceToPalette(
          candidate.midiNote,
          previousPalette,
        );
        score += max(0.0, 0.16 - (previousDistance * 0.06));
      }
      if (candidate.targetsColor &&
          !previousPalette.identityPitchClasses.contains(pitchClass)) {
        score += 0.18;
      }
    }
    if (context.nextPalette != null &&
        context.request.nextChordEvent?.chord.harmonicComparisonKey !=
            context.request.chordEvent.chord.harmonicComparisonKey &&
        (slot.anticipatory ||
            slot.index >= context.rhythmSample.slots.length - 2)) {
      final nextPalette = context.nextPalette!;
      final nextDistance = _distanceToPalette(candidate.midiNote, nextPalette);
      score += max(0.0, 0.36 - (nextDistance * 0.10));
      if (nextPalette.identityPitchClasses.contains(pitchClass)) {
        score += 0.24;
      } else if (nextPalette.featuredPitchClasses.contains(pitchClass)) {
        score += 0.14;
      }
      if (candidate.targetsColor && nextDistance <= 2) {
        score += 0.26;
      }
    }
    if (context.palette.isColorChord &&
        candidate.targetsColor &&
        beamNotes.isNotEmpty &&
        slot.index <= 2 &&
        context.request.settings.settingsComplexityMode ==
            SettingsComplexityMode.advanced) {
      score += 0.10;
    }
    return score;
  }

  static int _distanceToPalette(int midiNote, MelodyHarmonyPalette palette) {
    final targetPitchClasses = palette.identityPitchClasses.union(
      palette.chordPitchClasses,
    );
    if (targetPitchClasses.isEmpty) {
      return 99;
    }
    var best = 99;
    for (final pitchClass in targetPitchClasses) {
      final upward = (pitchClass - (midiNote % 12)) % 12;
      final downward = (((midiNote % 12) - pitchClass) % 12);
      best = min(best, min(upward, downward));
    }
    return best;
  }

  static bool _isMonotoneContour(List<GeneratedMelodyNote> notes) {
    if (notes.length < 3) {
      return false;
    }
    final intervals = <int>[];
    for (var index = 1; index < notes.length; index += 1) {
      intervals.add(notes[index].midiNote - notes[index - 1].midiNote);
    }
    final signs = intervals
        .where((interval) => interval != 0)
        .map((interval) => interval.sign)
        .toSet();
    return signs.length <= 1;
  }

  static int _samePitchOverflow(
    List<GeneratedMelodyNote> notes, {
    required int window,
  }) {
    var overflow = 0;
    for (var index = 0; index < notes.length; index += 1) {
      final start = max(0, index - window + 1);
      final count = notes
          .sublist(start, index + 1)
          .where((note) => note.midiNote == notes[index].midiNote)
          .length;
      if (count > 2) {
        overflow += count - 2;
      }
    }
    return overflow;
  }

  static int _largeLeapCount(List<GeneratedMelodyNote> notes) {
    var count = 0;
    for (var index = 1; index < notes.length; index += 1) {
      if ((notes[index].midiNote - notes[index - 1].midiNote).abs() > 7) {
        count += 1;
      }
    }
    return count;
  }

  static double _localMeanBeforeFinal(List<GeneratedMelodyNote> notes) {
    if (notes.isEmpty) {
      return 0.0;
    }
    if (notes.length == 1) {
      return notes.first.durationBeats;
    }
    return notes
            .take(notes.length - 1)
            .fold<double>(0, (sum, note) => sum + note.durationBeats) /
        (notes.length - 1);
  }

  static double _openingPhraseBias(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    var score = 0.0;
    if (slot.phrasePos01 < context.phrasePlan.apexPos01 - 0.08 &&
        candidate.midiNote > context.phrasePlan.apexMidi - 1) {
      score -= 0.28;
    }
    if (slot.index == 0) {
      score += max(
        0.0,
        0.24 -
            ((candidate.midiNote - context.phrasePlan.centerMidi).abs() * 0.06),
      );
    }
    return score;
  }

  static double _continuationPhraseBias(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (slot.phrasePos01 < context.phrasePlan.apexPos01) {
      return candidate.midiNote >= context.anchors.startMidi ? 0.10 : -0.04;
    }
    return candidate.midiNote <= context.phrasePlan.apexMidi ? 0.08 : -0.06;
  }

  static double _preCadencePhraseBias(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    var score = 0.0;
    if (slot.phrasePos01 >= 0.72) {
      score += max(
        0.0,
        0.36 - ((candidate.midiNote - context.anchors.endMidi).abs() * 0.08),
      );
      if (candidate.targetsColor && context.nextPalette != null) {
        score += 0.12;
      }
    }
    return score;
  }

  static double _cadencePhraseBias(
    MelodyCandidate candidate, {
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    var score = 0.0;
    if (slot.phrasePos01 >=
        max(0.72, context.phrasePlan.eventEndPos01 - 0.12)) {
      score += max(
        0.0,
        0.46 - ((candidate.midiNote - context.anchors.endMidi).abs() * 0.10),
      );
    }
    if (slot.phrasePos01 < context.phrasePlan.apexPos01 - 0.06 &&
        candidate.midiNote >= context.phrasePlan.apexMidi) {
      score -= 0.20;
    }
    if (_degreePriorityMatch(
      candidate.toneLabel,
      context.phrasePlan.endingDegreePriority,
    )) {
      score += 0.12;
    }
    return score;
  }

  static double _apexAlignmentAdjustment(
    List<GeneratedMelodyNote> notes, {
    required double meanDuration,
    required MelodyDecodeContext context,
  }) {
    if (notes.isEmpty ||
        context.request.chordEvent.timing.durationBeats <= 0 ||
        context.phrasePlan.phraseDurationBeats <= 0) {
      return 0.0;
    }
    final highest = notes.reduce(
      (left, right) => left.midiNote >= right.midiNote ? left : right,
    );
    final eventSpan01 =
        (context.phrasePlan.eventEndPos01 - context.phrasePlan.eventStartPos01)
            .clamp(0.0, 1.0);
    final localPos01 =
        (highest.startBeatOffset /
                context.request.chordEvent.timing.durationBeats.toDouble())
            .clamp(0.0, 1.0);
    final actualPhrasePos =
        context.phrasePlan.eventStartPos01 + (localPos01 * eventSpan01);
    final apexLivesHere =
        context.phrasePlan.apexPos01 >=
            context.phrasePlan.eventStartPos01 - 0.02 &&
        context.phrasePlan.apexPos01 <= context.phrasePlan.eventEndPos01 + 0.02;
    var score = 0.0;
    if (apexLivesHere) {
      final midiDistance = (highest.midiNote - context.phrasePlan.apexMidi)
          .abs()
          .toDouble();
      final posDistance = (actualPhrasePos - context.phrasePlan.apexPos01)
          .abs()
          .toDouble();
      score += max(0.0, 0.75 - (midiDistance * 0.12));
      score += max(0.0, 0.65 - (posDistance * 2.4));
      if (highest.durationBeats < meanDuration * 0.8) {
        score -= 0.10;
      }
    } else if (context.phrasePlan.eventEndPos01 <
        context.phrasePlan.apexPos01) {
      final overshoot = highest.midiNote - context.phrasePlan.apexMidi;
      if (overshoot > 0) {
        score -= overshoot * 0.14;
      } else if (notes.last.midiNote >= notes.first.midiNote) {
        score += 0.12;
      }
    } else if (context.phrasePlan.eventStartPos01 >
        context.phrasePlan.apexPos01) {
      final endDistance = (notes.last.midiNote - context.anchors.endMidi).abs();
      score += max(0.0, 0.22 - (endDistance * 0.06));
    }
    return score;
  }

  static double _cadenceResolutionAdjustment(
    List<GeneratedMelodyNote> notes, {
    required double meanDuration,
    required MelodyDecodeContext context,
  }) {
    if (notes.isEmpty) {
      return 0.0;
    }
    final role = context.phrasePlan.role;
    if (role != PhraseRole.preCadence && role != PhraseRole.cadence) {
      return 0.0;
    }
    final last = notes.last;
    var score = max(
      0.0,
      0.95 - ((last.midiNote - context.anchors.endMidi).abs() * 0.16),
    );
    if (role == PhraseRole.preCadence && context.nextPalette != null) {
      final nextDistance = _distanceToPalette(
        last.midiNote,
        context.nextPalette!,
      );
      score += max(0.0, 0.60 - (nextDistance * 0.16));
      if (last.startBeatOffset >=
          context.request.chordEvent.timing.durationBeats.toDouble() - 1.0) {
        score += 0.12;
      }
      return score;
    }
    if (last.durationBeats >= meanDuration * 2.0) {
      score += 1.05;
    } else {
      score -= 0.45;
    }
    if (notes.length >= 2) {
      final arrivalInterval = (last.midiNote - notes[notes.length - 2].midiNote)
          .abs();
      if (arrivalInterval <= 2) {
        score += 0.70;
      } else if (arrivalInterval <= 4) {
        score += 0.22;
      } else {
        score -= 0.35;
      }
    }
    if (_degreePriorityMatch(
      last.toneLabel,
      context.phrasePlan.endingDegreePriority,
    )) {
      score += 0.40;
    }
    if (context.palette.isColorChord &&
        context.palette.containsIdentityLabel(last.toneLabel)) {
      score += 0.20;
    }
    score += _endingVarietyAdjustment(last.toneLabel, context: context);
    return score;
  }

  static double _endingVarietyAdjustment(
    String? toneLabel, {
    required MelodyDecodeContext context,
  }) {
    if (toneLabel == null) {
      return 0.0;
    }
    final recentCadenceLabels = <String>[
      for (final event in _recentWindowEvents(context))
        if (event.phraseRole == PhraseRole.cadence &&
            event.lastNote?.toneLabel != null)
          event.lastNote!.toneLabel!,
    ];
    if (recentCadenceLabels.isEmpty) {
      return 0.0;
    }
    final repeats = recentCadenceLabels
        .take(3)
        .where((label) => label == toneLabel)
        .length;
    if (repeats == 0) {
      return 0.24;
    }
    if (repeats == 1) {
      return -0.12;
    }
    return -0.34;
  }

  static double _jitter(int seed) {
    final random = Random(seed & 0x3fffffff);
    return -0.12 + (random.nextDouble() * 0.24);
  }
}
