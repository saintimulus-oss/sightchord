import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_theory.dart';
import 'chord_timing_models.dart';
import 'melody_models.dart';
import 'voicing_engine.dart';
import 'voicing_models.dart';

class MelodyGenerator {
  const MelodyGenerator._();

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

  static GeneratedMelodyEvent generateEvent({
    required MelodyGenerationRequest request,
  }) {
    final random = Random(_seedForRequest(request));
    final palette = _buildPalette(
      chord: request.chordEvent.chord,
      settings: request.settings,
    );
    final nextPalette = request.nextChordEvent == null
        ? null
        : _buildPalette(
            chord: request.nextChordEvent!.chord,
            settings: request.settings,
          );
    final skeleton = _buildGuideToneSkeleton(
      request: request,
      random: random,
      palette: palette,
      nextPalette: nextPalette,
    );
    final motif = _buildMotifPlan(
      request: request,
      random: random,
      skeleton: skeleton,
    );
    final notes = _embellishLine(
      request: request,
      random: random,
      palette: palette,
      nextPalette: nextPalette,
      skeleton: skeleton,
      motif: motif,
    );
    return GeneratedMelodyEvent(
      chordEvent: request.chordEvent,
      notes: notes,
      motifSignature: motif.signature,
      contourSignature: motif.contourSignature,
      anchorMidiNote: skeleton.start.midiNote,
      arrivalMidiNote: skeleton.nextTarget?.midiNote,
    );
  }

  static int _seedForRequest(MelodyGenerationRequest request) {
    final timing = request.chordEvent.timing;
    return Object.hash(
          request.seed,
          request.chordEvent.chord.harmonicComparisonKey,
          timing.barIndex,
          timing.changeBeat,
          timing.durationBeats,
          request.settings.melodyDensity.name,
          request.settings.melodyStyle.name,
        ) &
        0x3fffffff;
  }

  static _MelodyPalette _buildPalette({
    required GeneratedChord chord,
    required PracticeSettings settings,
  }) {
    final interpretation = VoicingEngine.interpretChord(
      chord: chord,
      settings: settings,
    );
    final style = settings.melodyStyle;
    return _MelodyPalette(
      chord: chord,
      interpretation: interpretation,
      structuralLabels: _orderedStructuralLabels(
        chord: chord,
        interpretation: interpretation,
        style: style,
      ),
      weakStableLabels: _orderedWeakStableLabels(
        chord: chord,
        interpretation: interpretation,
        style: style,
      ),
      scalePitchClasses: {
        for (final relative in _relativeScaleSemitonesFor(
          chord: chord,
          interpretation: interpretation,
          style: style,
        ))
          (interpretation.rootSemitone + relative) % 12,
      },
      preferFlat: interpretation.preferFlatSpelling,
    );
  }

  static _GuideToneSkeleton _buildGuideToneSkeleton({
    required MelodyGenerationRequest request,
    required Random random,
    required _MelodyPalette palette,
    required _MelodyPalette? nextPalette,
  }) {
    final start = _chooseStructuralTone(
      random: random,
      palette: palette,
      nextPalette: nextPalette,
      previousMidiHint: request.previousMelodyEvent?.lastMidiNote,
      targetMidiHint: request.settings.melodyRangeCenter,
      settings: request.settings,
    );
    final nextTarget = request.nextChordEvent == null || nextPalette == null
        ? null
        : _chooseStructuralTone(
            random: random,
            palette: nextPalette,
            nextPalette: null,
            previousMidiHint: start.midiNote,
            targetMidiHint: start.midiNote,
            settings: request.settings,
          );
    return _GuideToneSkeleton(start: start, nextTarget: nextTarget);
  }

  static _MotifPlan _buildMotifPlan({
    required MelodyGenerationRequest request,
    required Random random,
    required _GuideToneSkeleton skeleton,
  }) {
    final slots = _buildRhythmSlots(
      settings: request.settings,
      timing: request.chordEvent.timing,
    );
    final previousMotif = request.previousMelodyEvent;
    final reusesPreviousMotif =
        previousMotif != null &&
        previousMotif.notes.length >= 2 &&
        random.nextDouble() < request.settings.motifRepetitionStrength;
    final contourSignature = reusesPreviousMotif
        ? _adaptContourSignature(
            previousMotif.contourSignature,
            targetLength: max(0, slots.length - 1),
          )
        : _buildFreshContourSignature(
            random: random,
            style: request.settings.melodyStyle,
            targetLength: max(0, slots.length - 1),
          );
    return _MotifPlan(
      slots: slots,
      contourSignature: contourSignature,
      signature:
          '${request.chordEvent.timing.durationBeats}:${slots.map((slot) => slot.startBeatOffset.toStringAsFixed(2)).join(',')}:${contourSignature.join(',')}',
      reusesPreviousMotif: reusesPreviousMotif,
      skeleton: skeleton,
    );
  }

  static List<GeneratedMelodyNote> _embellishLine({
    required MelodyGenerationRequest request,
    required Random random,
    required _MelodyPalette palette,
    required _MelodyPalette? nextPalette,
    required _GuideToneSkeleton skeleton,
    required _MotifPlan motif,
  }) {
    if (motif.slots.isEmpty) {
      return const <GeneratedMelodyNote>[];
    }

    final anchors = <int, _ResolvedTone>{0: skeleton.start};
    for (var index = 1; index < motif.slots.length; index += 1) {
      final slot = motif.slots[index];
      if (!slot.structural) {
        continue;
      }
      anchors[index] = _chooseStructuralTone(
        random: random,
        palette: palette,
        nextPalette: nextPalette,
        previousMidiHint: anchors[index - 1]?.midiNote ?? skeleton.start.midiNote,
        targetMidiHint: _interpolatedMidiTarget(
          from: skeleton.start.midiNote,
          to: skeleton.nextTarget?.midiNote ?? skeleton.start.midiNote,
          t: slot.startBeatOffset / request.chordEvent.timing.durationBeats,
        ),
        settings: request.settings,
      );
    }

    final notes = <_ResolvedNoteBuilder>[];
    for (var index = 0; index < motif.slots.length; index += 1) {
      final slot = motif.slots[index];
      final anchored = anchors[index];
      if (anchored != null) {
        notes.add(
          _ResolvedNoteBuilder(
            midiNote: anchored.midiNote,
            toneLabel: anchored.toneLabel,
            role: _roleForResolvedTone(anchored),
            structural: true,
            startBeatOffset: slot.startBeatOffset,
          ),
        );
        continue;
      }

      final previous = notes.isEmpty ? skeleton.start : notes.last.asTone();
      final nextAnchor = _nextAnchorAfter(index, anchors) ?? skeleton.nextTarget;
      final contourStep = motif.contourSignature[index - 1];
      final targetMidi = nextAnchor == null
          ? previous.midiNote + (contourStep * 2)
          : _interpolatedMidiTarget(
              from: previous.midiNote,
              to: nextAnchor.midiNote,
              t: 1 / max(1, motif.slots.length - index),
            );
      final resolved = _chooseWeakTone(
        random: random,
        palette: palette,
        nextPalette: nextPalette,
        previousTone: previous,
        nextTarget: nextAnchor,
        slot: slot,
        targetMidiHint: targetMidi + (contourStep * 2),
        settings: request.settings,
        isLastSlot: index == motif.slots.length - 1,
      );
      notes.add(
        _ResolvedNoteBuilder(
          midiNote: resolved.midiNote,
          toneLabel: resolved.toneLabel,
          role: resolved.role ?? MelodyNoteRole.passing,
          structural: false,
          startBeatOffset: slot.startBeatOffset,
        ),
      );
    }

    _applyLeapCompensation(
      notes,
      palette,
      settings: request.settings,
    );
    _applyNeighborCompression(
      notes: notes,
      palette: palette,
      nextTarget: skeleton.nextTarget,
      settings: request.settings,
    );

    return [
      for (var index = 0; index < notes.length; index += 1)
        GeneratedMelodyNote(
          midiNote: notes[index].midiNote,
          startBeatOffset: notes[index].startBeatOffset,
          durationBeats: _durationForIndex(
            notes: notes,
            index: index,
            totalDurationBeats:
                request.chordEvent.timing.durationBeats.toDouble(),
          ),
          role: notes[index].role,
          toneLabel: notes[index].toneLabel,
          structural: notes[index].structural,
          velocity: notes[index].velocity,
          gain: notes[index].gain,
        ),
    ];
  }

  static List<_MelodySlot> _buildRhythmSlots({
    required PracticeSettings settings,
    required ChordTimingSpec timing,
  }) {
    final duration = timing.durationBeats.toDouble();
    final baseOffsets = switch (settings.melodyDensity) {
      MelodyDensity.sparse => _sparseOffsets(duration),
      MelodyDensity.balanced => _balancedOffsets(duration),
      MelodyDensity.active => _activeOffsets(duration),
    };
    final effectiveOffsets = switch (settings.melodyStyle) {
      MelodyStyle.lyrical => baseOffsets.length <= 2
          ? baseOffsets
          : baseOffsets
                .where(
                  (offset) => offset == 0 || offset >= duration - 1,
                )
                .toList(growable: false),
      MelodyStyle.bebop => _bebopOffsets(duration, baseOffsets),
      MelodyStyle.colorful => _colorfulOffsets(duration, baseOffsets),
      MelodyStyle.safe => baseOffsets,
    };
    final uniqueOffsets = effectiveOffsets.toSet().toList(growable: false)
      ..sort();
    return [
      for (final offset in uniqueOffsets)
        if (offset >= 0 && offset < duration)
          _MelodySlot(
            startBeatOffset: offset,
            structural: _isStructuralMelodyBeat(
                  timing: timing,
                  startBeatOffset: offset,
                ) ||
                offset == 0,
          ),
    ];
  }

  static List<double> _sparseOffsets(double duration) {
    if (duration <= 1) {
      return const [0];
    }
    if (duration <= 2) {
      return const [0, 1];
    }
    return [0, max(1.5, duration - 1)];
  }

  static List<double> _balancedOffsets(double duration) {
    if (duration <= 1) {
      return const [0, 0.5];
    }
    if (duration <= 2) {
      return const [0, 1];
    }
    if (duration <= 3) {
      return const [0, 1, 2];
    }
    return const [0, 1, 2, 3];
  }

  static List<double> _activeOffsets(double duration) {
    if (duration <= 1) {
      return const [0, 0.5];
    }
    if (duration <= 2) {
      return const [0, 0.5, 1, 1.5];
    }
    if (duration <= 3) {
      return const [0, 0.5, 1.5, 2, 2.5];
    }
    return const [0, 0.5, 1.5, 2, 3, 3.5];
  }

  static List<double> _bebopOffsets(double duration, List<double> baseOffsets) {
    if (duration < 2) {
      return baseOffsets;
    }
    final offsets = <double>{...baseOffsets, duration - 0.5};
    if (duration >= 4) {
      offsets.add(1.5);
    }
    final ordered = offsets.toList(growable: false)..sort();
    return ordered;
  }

  static List<double> _colorfulOffsets(
    double duration,
    List<double> baseOffsets,
  ) {
    if (duration < 2) {
      return baseOffsets;
    }
    final offsets = <double>{...baseOffsets, duration - 0.5};
    if (duration >= 3) {
      offsets.add(1.5);
    }
    final ordered = offsets.toList(growable: false)..sort();
    return ordered;
  }

  static bool _isStructuralMelodyBeat({
    required ChordTimingSpec timing,
    required double startBeatOffset,
  }) {
    final absoluteBeat = timing.changeBeat + startBeatOffset.floor();
    return switch (timing.beatsPerBar) {
      4 => absoluteBeat == 0 || absoluteBeat == 2,
      3 => absoluteBeat == 0,
      2 => absoluteBeat == 0,
      _ => absoluteBeat == 0,
    };
  }

  static List<int> _adaptContourSignature(
    List<int> previousSignature, {
    required int targetLength,
  }) {
    if (targetLength <= 0) {
      return const <int>[];
    }
    if (previousSignature.isEmpty) {
      return List<int>.filled(targetLength, 0, growable: false);
    }
    return [
      for (var index = 0; index < targetLength; index += 1)
        previousSignature[index % previousSignature.length],
    ];
  }

  static List<int> _buildFreshContourSignature({
    required Random random,
    required MelodyStyle style,
    required int targetLength,
  }) {
    if (targetLength <= 0) {
      return const <int>[];
    }
    final libraries = switch (style) {
      MelodyStyle.safe => const [
          [1, -1],
          [1, 0, -1],
          [0, 1, -1],
          [-1, 1],
        ],
      MelodyStyle.bebop => const [
          [1, 1, -1, -1],
          [1, -1, 1, -1],
          [2, -1, 1, -1],
          [-1, 1, -1, 1],
        ],
      MelodyStyle.lyrical => const [
          [1, 0, -1],
          [1, -1],
          [0, 1, 0, -1],
          [-1, 1],
        ],
      MelodyStyle.colorful => const [
          [1, 2, -1, -1],
          [2, -1, 1, -2],
          [1, -1, 2, -2],
          [-1, 2, -1, 1],
        ],
    };
    return _adaptContourSignature(
      libraries[random.nextInt(libraries.length)],
      targetLength: targetLength,
    );
  }

  static _ResolvedTone _chooseStructuralTone({
    required Random random,
    required _MelodyPalette palette,
    required _MelodyPalette? nextPalette,
    required int? previousMidiHint,
    required int targetMidiHint,
    required PracticeSettings settings,
  }) {
    final candidateLabels = palette.structuralLabels.isEmpty
        ? palette.weakStableLabels
        : palette.structuralLabels;
    var bestTone = _resolvedRootTone(
      palette,
      targetMidiHint,
      low: settings.melodyRangeLow,
      high: settings.melodyRangeHigh,
    );
    var bestScore = double.negativeInfinity;
    for (var index = 0; index < candidateLabels.length; index += 1) {
      final label = candidateLabels[index];
      final relative = _toneSemitones[label];
      if (relative == null) {
        continue;
      }
      final pitchClass =
          (palette.interpretation.rootSemitone + relative) % 12;
      for (final midi in _midiCandidatesForPitchClass(
        pitchClass,
        low: settings.melodyRangeLow,
        high: settings.melodyRangeHigh,
      )) {
        var score = 10.0 - index;
        score -= (midi - targetMidiHint).abs() * 0.16;
        if (previousMidiHint != null) {
          final leap = (midi - previousMidiHint).abs();
          score += leap <= 2 ? 2.3 : 0;
          score -= leap * 0.12;
          if (leap > 9) {
            score -= 2.4;
          }
        }
        if (_isGuideToneLabel(label)) {
          score += 2.6;
        }
        if (_isStableTensionLabel(label)) {
          score += switch (settings.melodyStyle) {
            MelodyStyle.safe => 0.1,
            MelodyStyle.lyrical => 0.65,
            MelodyStyle.bebop => 0.45,
            MelodyStyle.colorful => 1.1,
          };
        }
        if (nextPalette != null) {
          score += _nextResolutionBonus(
            midi: midi,
            nextPalette: nextPalette,
            settings: settings,
          );
        }
        score += (random.nextDouble() - 0.5) * 0.18;
        if (score > bestScore) {
          bestScore = score;
          bestTone = _ResolvedTone(
            midiNote: midi,
            toneLabel: label,
            stable: true,
          );
        }
      }
    }
    return bestTone;
  }

  static _ResolvedTone _chooseWeakTone({
    required Random random,
    required _MelodyPalette palette,
    required _MelodyPalette? nextPalette,
    required _ResolvedTone previousTone,
    required _ResolvedTone? nextTarget,
    required _MelodySlot slot,
    required int targetMidiHint,
    required PracticeSettings settings,
    required bool isLastSlot,
  }) {
    final shouldApproach =
        nextTarget != null &&
        isLastSlot &&
        random.nextDouble() < settings.approachToneDensity;
    if (shouldApproach) {
      final useAnticipation =
          settings.melodyStyle != MelodyStyle.safe &&
          random.nextDouble() <
              (settings.melodyStyle == MelodyStyle.colorful ? 0.3 : 0.16);
      if (useAnticipation) {
        return _ResolvedTone(
          midiNote: nextTarget.midiNote,
          toneLabel: nextTarget.toneLabel,
          stable: true,
          role: MelodyNoteRole.anticipation,
        );
      }
      final chromatic =
          settings.allowChromaticApproaches &&
          random.nextDouble() < settings.approachToneDensity;
      return _ResolvedTone(
        midiNote: _approachMidiToward(
          targetMidi: nextTarget.midiNote,
          fromMidi: previousTone.midiNote,
          chromatic: chromatic,
          low: settings.melodyRangeLow,
          high: settings.melodyRangeHigh,
        ),
        toneLabel: null,
        stable: false,
        role: chromatic ? MelodyNoteRole.approach : MelodyNoteRole.passing,
      );
    }

    final candidatePitchClasses = {
      ...palette.scalePitchClasses,
      if (nextTarget != null && settings.allowChromaticApproaches)
        (nextTarget.midiNote + 11) % 12,
      if (nextTarget != null && settings.allowChromaticApproaches)
        (nextTarget.midiNote + 1) % 12,
    };
    var best = _ResolvedTone(
      midiNote: previousTone.midiNote,
      toneLabel: previousTone.toneLabel,
      stable: false,
      role: MelodyNoteRole.passing,
    );
    var bestScore = double.negativeInfinity;
    for (final pitchClass in candidatePitchClasses) {
      for (final midi in _midiCandidatesForPitchClass(
        pitchClass,
        low: settings.melodyRangeLow,
        high: settings.melodyRangeHigh,
      )) {
        final motion = (midi - previousTone.midiNote).abs();
        var score = 0.0;
        score -= motion * 0.18;
        score -= (midi - targetMidiHint).abs() * 0.12;
        if (motion <= 2) {
          score += 1.7;
        }
        if (nextTarget != null) {
          score += max(0, 2.1 - ((midi - nextTarget.midiNote).abs() * 0.22));
        }
        final label = _bestToneLabelForPitchClass(
          pitchClass: pitchClass,
          palette: palette,
        );
        final stable = label != null && palette.weakStableLabels.contains(label);
        if (!slot.structural && stable) {
          score += 0.25;
        }
        if (motion > 7) {
          score -= 2.8;
        }
        score += (random.nextDouble() - 0.5) * 0.12;
        if (score > bestScore) {
          bestScore = score;
          best = _ResolvedTone(
            midiNote: midi,
            toneLabel: label,
            stable: stable,
            role: stable ? MelodyNoteRole.neighbor : MelodyNoteRole.passing,
          );
        }
      }
    }
    return best;
  }

  static void _applyLeapCompensation(
    List<_ResolvedNoteBuilder> notes,
    _MelodyPalette palette, {
    required PracticeSettings settings,
  }) {
    for (var index = 1; index < notes.length; index += 1) {
      final leap = notes[index].midiNote - notes[index - 1].midiNote;
      if (leap.abs() <= 8) {
        continue;
      }
      final direction = leap.isNegative ? -1 : 1;
      final compensatedMidi = notes[index - 1].midiNote + (direction * 5);
      final resolved = _nearestPaletteMidi(
        pitchClass: compensatedMidi % 12,
        targetMidi: compensatedMidi,
        low: settings.melodyRangeLow,
        high: settings.melodyRangeHigh,
      );
      if (resolved != null) {
        notes[index] = notes[index].copyWith(
          midiNote: resolved,
          role: MelodyNoteRole.passing,
          toneLabel: _bestToneLabelForPitchClass(
            pitchClass: resolved % 12,
            palette: palette,
          ),
        );
      }
    }
  }

  static void _applyNeighborCompression({
    required List<_ResolvedNoteBuilder> notes,
    required _MelodyPalette palette,
    required _ResolvedTone? nextTarget,
    required PracticeSettings settings,
  }) {
    if (notes.length < 3 ||
        nextTarget == null ||
        !settings.allowChromaticApproaches ||
        settings.melodyStyle == MelodyStyle.safe ||
        settings.approachToneDensity < 0.45) {
      return;
    }
    final lastIndex = notes.length - 1;
    if (notes[lastIndex].role == MelodyNoteRole.approach ||
        notes[lastIndex].role == MelodyNoteRole.anticipation) {
      return;
    }
    final upper = _clampMidi(
      nextTarget.midiNote + 1,
      low: settings.melodyRangeLow,
      high: settings.melodyRangeHigh,
    );
    final lower = _clampMidi(
      nextTarget.midiNote - 1,
      low: settings.melodyRangeLow,
      high: settings.melodyRangeHigh,
    );
    notes[lastIndex - 1] = notes[lastIndex - 1].copyWith(
      midiNote: upper,
      role: MelodyNoteRole.enclosure,
      toneLabel: _bestToneLabelForPitchClass(
        pitchClass: upper % 12,
        palette: palette,
      ),
    );
    notes[lastIndex] = notes[lastIndex].copyWith(
      midiNote: lower,
      role: MelodyNoteRole.enclosure,
      toneLabel: _bestToneLabelForPitchClass(
        pitchClass: lower % 12,
        palette: palette,
      ),
    );
  }

  static double _durationForIndex({
    required List<_ResolvedNoteBuilder> notes,
    required int index,
    required double totalDurationBeats,
  }) {
    final currentStart = notes[index].startBeatOffset;
    final nextStart = index + 1 < notes.length
        ? notes[index + 1].startBeatOffset
        : totalDurationBeats;
    return max(0.25, nextStart - currentStart);
  }

  static int _interpolatedMidiTarget({
    required int from,
    required int to,
    required double t,
  }) {
    return (from + ((to - from) * t)).round();
  }

  static _ResolvedTone? _nextAnchorAfter(
    int index,
    Map<int, _ResolvedTone> anchors,
  ) {
    final orderedEntries = anchors.entries.toList(growable: false)
      ..sort((left, right) => left.key.compareTo(right.key));
    for (final entry in orderedEntries) {
      if (entry.key > index) {
        return entry.value;
      }
    }
    return null;
  }

  static _ResolvedTone _resolvedRootTone(
    _MelodyPalette palette,
    int targetMidiHint, {
    required int low,
    required int high,
  }) {
    final rootMidi = _nearestPaletteMidi(
      pitchClass: palette.interpretation.rootSemitone,
      targetMidi: targetMidiHint,
      low: low,
      high: high,
    );
    return _ResolvedTone(
      midiNote: rootMidi ?? targetMidiHint,
      toneLabel: '1',
      stable: true,
    );
  }

  static double _nextResolutionBonus({
    required int midi,
    required _MelodyPalette nextPalette,
    required PracticeSettings settings,
  }) {
    var best = 0.0;
    for (var index = 0; index < nextPalette.structuralLabels.length; index += 1) {
      final label = nextPalette.structuralLabels[index];
      final relative = _toneSemitones[label];
      if (relative == null) {
        continue;
      }
      final pitchClass =
          (nextPalette.interpretation.rootSemitone + relative) % 12;
      final closest = _nearestPaletteMidi(
        pitchClass: pitchClass,
        targetMidi: midi,
        low: settings.melodyRangeLow,
        high: settings.melodyRangeHigh,
      );
      if (closest == null) {
        continue;
      }
      final distance = (closest - midi).abs();
      final score = max(0.0, 2.4 - (distance * 0.55));
      if (score > best) {
        best = score;
      }
    }
    return best;
  }

  static List<int> _relativeScaleSemitonesFor({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required MelodyStyle style,
  }) {
    if (interpretation.isDominantFamily) {
      if (interpretation.isSusFamily) {
        return const [0, 2, 5, 7, 9, 10];
      }
      if (chord.symbolData.renderQuality == ChordQuality.dominant7Alt &&
          style != MelodyStyle.safe) {
        return const [0, 1, 3, 4, 6, 8, 10];
      }
      if (chord.appliedType == AppliedType.substitute ||
          chord.dominantIntent == DominantIntent.tritoneSub ||
          chord.dominantIntent == DominantIntent.lydianDominant ||
          chord.dominantIntent == DominantIntent.backdoor ||
          chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11) {
        return const [0, 2, 4, 6, 7, 9, 10];
      }
      if (style == MelodyStyle.bebop) {
        return const [0, 2, 4, 5, 7, 9, 10, 11];
      }
      return const [0, 2, 4, 5, 7, 9, 10];
    }
    if (interpretation.isHalfDiminishedFamily) {
      return const [0, 1, 3, 5, 6, 8, 10];
    }
    if (chord.symbolData.renderQuality == ChordQuality.diminished7) {
      return const [0, 2, 3, 5, 6, 8, 9, 11];
    }
    if (chord.romanNumeralId == RomanNumeralId.borrowedIvMin7) {
      return const [0, 2, 3, 5, 7, 8, 10];
    }
    if (interpretation.isMinorFamily) {
      return const [0, 2, 3, 5, 7, 9, 10];
    }
    if (chord.symbolData.renderQuality == ChordQuality.augmentedTriad &&
        style == MelodyStyle.colorful) {
      return const [0, 2, 4, 6, 8, 9, 11];
    }
    return const [0, 2, 4, 5, 7, 9, 11];
  }

  static List<String> _orderedStructuralLabels({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required MelodyStyle style,
  }) {
    if (interpretation.isDominantFamily) {
      if (interpretation.isSusFamily) {
        return const ['4', 'b7', '9', '13', '1', '5'];
      }
      if (chord.symbolData.renderQuality == ChordQuality.dominant7Alt &&
          style != MelodyStyle.safe) {
        return const ['3', 'b7', 'b9', '#9', 'b13', '#11'];
      }
      if (chord.appliedType == AppliedType.substitute ||
          chord.dominantIntent == DominantIntent.tritoneSub ||
          chord.dominantIntent == DominantIntent.lydianDominant ||
          chord.dominantIntent == DominantIntent.backdoor ||
          chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11) {
        return const ['3', 'b7', '#11', '9', '13', '1'];
      }
      return const ['3', 'b7', '9', '13', '1', '5'];
    }
    if (interpretation.isHalfDiminishedFamily) {
      return const ['b3', 'b7', 'b5', '11', '1'];
    }
    if (interpretation.isMinorFamily) {
      final labels = <String>['b3', 'b7', '9', '11', '1', '5'];
      if (style != MelodyStyle.safe) {
        labels.add('13');
      }
      return labels;
    }
    final labels = <String>['3', '7', '9', '1', '5'];
    if (chord.symbolData.renderQuality == ChordQuality.major69 ||
        style != MelodyStyle.safe) {
      labels.insert(2, '13');
    }
    return labels;
  }

  static List<String> _orderedWeakStableLabels({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
    required MelodyStyle style,
  }) {
    final labels = <String>[
      ..._orderedStructuralLabels(
        chord: chord,
        interpretation: interpretation,
        style: style,
      ),
    ];
    if (interpretation.isMinorFamily && style == MelodyStyle.colorful) {
      labels.add('6');
    }
    if (interpretation.isDominantFamily &&
        !interpretation.isSusFamily &&
        style == MelodyStyle.bebop) {
      labels.add('7');
    }
    if (!labels.contains('5')) {
      labels.add('5');
    }
    return labels;
  }

  static List<int> _midiCandidatesForPitchClass(
    int pitchClass, {
    required int low,
    required int high,
  }) {
    final candidates = <int>[];
    for (var midi = low; midi <= high; midi += 1) {
      if (midi % 12 == pitchClass) {
        candidates.add(midi);
      }
    }
    return candidates;
  }

  static int? _nearestPaletteMidi({
    required int pitchClass,
    required int targetMidi,
    required int low,
    required int high,
  }) {
    int? best;
    var bestDistance = 1 << 30;
    for (final midi in _midiCandidatesForPitchClass(
      pitchClass,
      low: low,
      high: high,
    )) {
      final distance = (midi - targetMidi).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        best = midi;
      }
    }
    return best;
  }

  static String? _bestToneLabelForPitchClass({
    required int pitchClass,
    required _MelodyPalette palette,
  }) {
    for (final label in [
      ...palette.structuralLabels,
      ...palette.weakStableLabels,
    ]) {
      final relative = _toneSemitones[label];
      if (relative == null) {
        continue;
      }
      if ((palette.interpretation.rootSemitone + relative) % 12 == pitchClass) {
        return label;
      }
    }
    return null;
  }

  static MelodyNoteRole _roleForResolvedTone(_ResolvedTone tone) {
    if (tone.role != null) {
      return tone.role!;
    }
    if (_isGuideToneLabel(tone.toneLabel)) {
      return MelodyNoteRole.guideTone;
    }
    if (_isStableTensionLabel(tone.toneLabel)) {
      return MelodyNoteRole.stableTension;
    }
    return MelodyNoteRole.chordTone;
  }

  static bool _isGuideToneLabel(String? label) {
    return label == '3' ||
        label == 'b3' ||
        label == '7' ||
        label == 'b7' ||
        label == '4';
  }

  static bool _isStableTensionLabel(String? label) {
    return label == '9' ||
        label == '11' ||
        label == '#11' ||
        label == '13' ||
        label == '6' ||
        label == 'b13';
  }

  static int _approachMidiToward({
    required int targetMidi,
    required int fromMidi,
    required bool chromatic,
    required int low,
    required int high,
  }) {
    final direction = fromMidi <= targetMidi ? -1 : 1;
    final step = chromatic ? 1 : 2;
    return _clampMidi(targetMidi + (direction * step), low: low, high: high);
  }

  static int _clampMidi(
    int midi, {
    required int low,
    required int high,
  }) {
    return midi.clamp(low, high);
  }
}

class _MelodyPalette {
  const _MelodyPalette({
    required this.chord,
    required this.interpretation,
    required this.structuralLabels,
    required this.weakStableLabels,
    required this.scalePitchClasses,
    required this.preferFlat,
  });

  final GeneratedChord chord;
  final ChordVoicingInterpretation interpretation;
  final List<String> structuralLabels;
  final List<String> weakStableLabels;
  final Set<int> scalePitchClasses;
  final bool preferFlat;
}

class _GuideToneSkeleton {
  const _GuideToneSkeleton({
    required this.start,
    required this.nextTarget,
  });

  final _ResolvedTone start;
  final _ResolvedTone? nextTarget;
}

class _MotifPlan {
  const _MotifPlan({
    required this.slots,
    required this.contourSignature,
    required this.signature,
    required this.reusesPreviousMotif,
    required this.skeleton,
  });

  final List<_MelodySlot> slots;
  final List<int> contourSignature;
  final String signature;
  final bool reusesPreviousMotif;
  final _GuideToneSkeleton skeleton;
}

class _MelodySlot {
  const _MelodySlot({
    required this.startBeatOffset,
    required this.structural,
  });

  final double startBeatOffset;
  final bool structural;
}

class _ResolvedTone {
  const _ResolvedTone({
    required this.midiNote,
    required this.toneLabel,
    required this.stable,
    this.role,
  });

  final int midiNote;
  final String? toneLabel;
  final bool stable;
  final MelodyNoteRole? role;
}

class _ResolvedNoteBuilder {
  const _ResolvedNoteBuilder({
    required this.midiNote,
    required this.startBeatOffset,
    required this.role,
    required this.structural,
    this.velocity = 92,
    this.gain = 1.0,
    this.toneLabel,
  });

  final int midiNote;
  final double startBeatOffset;
  final MelodyNoteRole role;
  final bool structural;
  final int velocity;
  final double gain;
  final String? toneLabel;

  _ResolvedTone asTone() {
    return _ResolvedTone(
      midiNote: midiNote,
      toneLabel: toneLabel,
      stable: structural,
      role: role,
    );
  }

  _ResolvedNoteBuilder copyWith({
    int? midiNote,
    double? startBeatOffset,
    MelodyNoteRole? role,
    bool? structural,
    int? velocity,
    double? gain,
    String? toneLabel,
  }) {
    return _ResolvedNoteBuilder(
      midiNote: midiNote ?? this.midiNote,
      startBeatOffset: startBeatOffset ?? this.startBeatOffset,
      role: role ?? this.role,
      structural: structural ?? this.structural,
      velocity: velocity ?? this.velocity,
      gain: gain ?? this.gain,
      toneLabel: toneLabel ?? this.toneLabel,
    );
  }
}
