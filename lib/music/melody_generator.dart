import 'dart:math';

import '../settings/practice_settings.dart';
import 'melody_candidate_builder.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';
import 'melody_scoring.dart';
import 'melody_seed_util.dart';
import 'motif_transformer.dart';
import 'phrase_planner.dart';
import 'rhythm_template_sampler.dart';

class MelodyGenerator {
  const MelodyGenerator._();

  static GeneratedMelodyEvent generateEvent({
    required MelodyGenerationRequest request,
  }) {
    final effectiveMode = MelodyGenerationConfig.effectiveModeForSettings(
      request.settings,
    );
    final planningSeed = _seedForRequest(request);
    final phrasePlan = PhrasePlanner.plan(
      request: request,
      random: Random(planningSeed),
    );
    final decodeSeed = _seedForRequest(
      request,
      phraseVariantNonce: phrasePlan.phraseVariantNonce,
    );
    final palette = MelodyHarmonyPalette.fromChord(
      chord: request.chordEvent.chord,
      settings: request.settings,
    );
    final previousPalette = request.previousChordEvent == null
        ? null
        : MelodyHarmonyPalette.fromChord(
            chord: request.previousChordEvent!.chord,
            settings: request.settings,
          );
    final nextPalette = request.nextChordEvent == null
        ? null
        : MelodyHarmonyPalette.fromChord(
            chord: request.nextChordEvent!.chord,
            settings: request.settings,
          );
    final effectiveDensity = _sampleEffectiveDensity(
      request.settings,
      effectiveMode: effectiveMode,
      seed: MelodySeedUtil.stableHashAll(<Object?>[decodeSeed, 'density']),
    );
    final effectiveStyle = _sampleEffectiveStyle(
      request.settings,
      effectiveMode: effectiveMode,
      seed: MelodySeedUtil.stableHashAll(<Object?>[decodeSeed, 'style']),
    );
    final rhythm = RhythmTemplateSampler.sample(
      request: request,
      phrasePlan: phrasePlan,
      density: effectiveDensity,
      style: effectiveStyle,
      random: Random(
        MelodySeedUtil.stableHashAll(<Object?>[decodeSeed, 'rhythm']),
      ),
    );
    final motifPlan = MotifTransformer.plan(
      previousEvent: request.previousMelodyEvent,
      recentEvents: request.recentMelodyEvents,
      rhythm: rhythm,
      settings: request.settings,
      style: effectiveStyle,
      phrasePlan: phrasePlan,
      random: Random(
        MelodySeedUtil.stableHashAll(<Object?>[decodeSeed, 'motif']),
      ),
    );
    final anchors = _planAnchors(
      request: request,
      palette: palette,
      nextPalette: nextPalette,
      phrasePlan: phrasePlan,
      effectiveStyle: effectiveStyle,
    );
    if (rhythm.slots.isEmpty) {
      return _buildGeneratedEvent(
        request: request,
        notes: const <GeneratedMelodyNote>[],
        motifSignature: motifPlan.signature,
        contourSignature: motifPlan.contourSignature,
        anchors: anchors,
        phrasePlan: phrasePlan,
      );
    }
    final context = MelodyDecodeContext(
      request: request,
      effectiveMode: effectiveMode,
      palette: palette,
      previousPalette: previousPalette,
      nextPalette: nextPalette,
      phrasePlan: phrasePlan,
      anchors: anchors,
      rhythmSample: rhythm,
      motifPlan: motifPlan,
      effectiveDensity: effectiveDensity,
      effectiveStyle: effectiveStyle,
      seed: decodeSeed,
    );
    final notes = _decodePhrase(context);
    return _buildGeneratedEvent(
      request: request,
      notes: notes,
      motifSignature: motifPlan.signature,
      contourSignature: _intervalVector(notes),
      anchors: anchors,
      phrasePlan: phrasePlan,
    );
  }

  static GeneratedMelodyEvent _buildGeneratedEvent({
    required MelodyGenerationRequest request,
    required List<GeneratedMelodyNote> notes,
    required String motifSignature,
    required List<int> contourSignature,
    required PhraseAnchors anchors,
    required PhrasePlan phrasePlan,
  }) {
    return GeneratedMelodyEvent(
      chordEvent: request.chordEvent,
      notes: notes,
      motifSignature: motifSignature,
      contourSignature: contourSignature,
      anchorMidiNote: anchors.startMidi,
      arrivalMidiNote: anchors.endMidi,
      phraseRole: phrasePlan.role,
      phraseCenterMidi: phrasePlan.centerMidi,
      phraseApexMidi: phrasePlan.apexMidi,
      phraseApexPos01: phrasePlan.apexPos01,
      phraseEventStartPos01: phrasePlan.eventStartPos01,
      phraseEventEndPos01: phrasePlan.eventEndPos01,
      phraseEndingDegreePriority: phrasePlan.endingDegreePriority,
      phraseCadenceHoldMultiplier: phrasePlan.cadenceHoldMultiplier,
      phraseTargetNovelty01: phrasePlan.targetNovelty01,
      phraseTargetColorExposure01: phrasePlan.targetColorExposure01,
      sectionArcIndex: phrasePlan.sectionArcIndex,
      sectionArcSpan: phrasePlan.sectionArcSpan,
      sectionCenterLiftSemitones: phrasePlan.sectionCenterLiftSemitones,
      sectionApexLiftSemitones: phrasePlan.sectionApexLiftSemitones,
    );
  }

  static List<GeneratedMelodyNote> _decodePhrase(MelodyDecodeContext context) {
    final slots = context.rhythmSample.slots;
    if (slots.length == 1) {
      final slot = slots.first;
      final midi = context.phrasePlan.isCadential
          ? context.anchors.endMidi
          : context.anchors.startMidi;
      final toneLabel =
          context.palette.labelForPitchClass(midi % 12) ??
          context.anchors.startToneLabel;
      return [
        GeneratedMelodyNote(
          midiNote: midi,
          startBeatOffset: slot.startBeatOffset,
          durationBeats: slot.durationBeats,
          role: _roleForLabel(toneLabel),
          toneLabel: toneLabel,
          structural: true,
          sourceCategoryKey: MelodyCandidateCategory.chord.name,
          strongSlot: slot.isStrong,
        ),
      ];
    }

    final startSlot = slots.first;
    final startToneLabel =
        context.anchors.startToneLabel ??
        context.palette.labelForPitchClass(context.anchors.startMidi % 12);
    final startNote = BeamNote(
      note: GeneratedMelodyNote(
        midiNote: context.anchors.startMidi,
        startBeatOffset: startSlot.startBeatOffset,
        durationBeats: startSlot.durationBeats,
        role: _roleForLabel(startToneLabel),
        toneLabel: startToneLabel,
        structural: true,
        sourceCategoryKey: MelodyCandidateCategory.chord.name,
        strongSlot: startSlot.isStrong,
      ),
      category: MelodyCandidateCategory.chord,
      metricStrength: startSlot.metricStrength,
      anticipatory: startSlot.anticipatory,
    );

    var beams = <_MelodyBeam>[
      _MelodyBeam(notes: <BeamNote>[startNote], score: 0),
    ];

    for (var slotIndex = 1; slotIndex < slots.length; slotIndex += 1) {
      final slot = slots[slotIndex];
      final expanded = <_MelodyBeam>[];
      for (final beam in beams) {
        final candidates = MelodyCandidateBuilder.build(
          slot: slot,
          slotIndex: slotIndex,
          beamNotes: beam.notes,
          context: context,
        );
        for (final candidate in candidates) {
          final score = MelodyScoring.scoreCandidate(
            candidate: candidate,
            beamNotes: beam.notes,
            slot: slot,
            slotIndex: slotIndex,
            context: context,
          );
          expanded.add(
            beam.extend(
              BeamNote(
                note: GeneratedMelodyNote(
                  midiNote: candidate.midiNote,
                  startBeatOffset: slot.startBeatOffset,
                  durationBeats: slot.durationBeats,
                  role: candidate.role,
                  toneLabel: candidate.toneLabel,
                  structural: slot.structural,
                  sourceCategoryKey: candidate.category.name,
                  strongSlot: slot.isStrong,
                ),
                category: candidate.category,
                metricStrength: slot.metricStrength,
                anticipatory: slot.anticipatory,
              ),
              score,
            ),
          );
        }
      }
      if (expanded.isEmpty) {
        continue;
      }
      beams = _prune(
        expanded,
        width:
            MelodyGenerationConfig.beamWidth[context.effectiveMode] ??
            12,
      );
    }

    beams.sort((left, right) {
      final rightTotal =
          right.score +
          MelodyScoring.finalRerankAdjustment(
            beamNotes: right.notes,
            context: context,
          );
      final leftTotal =
          left.score +
          MelodyScoring.finalRerankAdjustment(
            beamNotes: left.notes,
            context: context,
          );
      return rightTotal.compareTo(leftTotal);
    });
    final best = beams.first;
    return [for (final beamNote in best.notes) beamNote.note];
  }

  static PhraseAnchors _planAnchors({
    required MelodyGenerationRequest request,
    required MelodyHarmonyPalette palette,
    required MelodyHarmonyPalette? nextPalette,
    required PhrasePlan phrasePlan,
    required MelodyStyle effectiveStyle,
  }) {
    final low = request.settings.melodyRangeLow;
    final high = request.settings.melodyRangeHigh;
    final recentEndingLabels = _recentCadenceEndingLabels(request);
    final previousMidiHint =
        request.previousMelodyEvent?.lastMidiNote ?? phrasePlan.centerMidi;
    final startTargetMidi = _startTargetMidiForRole(
      phrasePlan,
      previousMidiHint: previousMidiHint,
      low: low,
      high: high,
    );
    final carryOverMidi = request.previousMelodyEvent?.lastMidiNote;
    final carryOverPitchClass = carryOverMidi == null
        ? null
        : carryOverMidi % 12;
    final canCarryOver =
        carryOverMidi != null &&
        carryOverPitchClass != null &&
        carryOverMidi >= low &&
        carryOverMidi <= high &&
        (palette.chordPitchClasses.contains(carryOverPitchClass) ||
            palette.scalePitchClasses.contains(carryOverPitchClass) ||
            (palette.isColorChord &&
                palette.featuredPitchClasses.contains(carryOverPitchClass)));
    final startCandidates = <String>[
      ..._startLabelsForRole(
        palette,
        phrasePlan,
        effectiveStyle: effectiveStyle,
      ),
      if (request.previousChordEvent?.chord.harmonicComparisonKey ==
          request.chordEvent.chord.harmonicComparisonKey)
        ...(request.previousMelodyEvent?.lastNote?.toneLabel == null
            ? const <String>[]
            : <String>[request.previousMelodyEvent!.lastNote!.toneLabel!]),
      if (request.previousMelodyEvent?.lastNote?.toneLabel != null)
        request.previousMelodyEvent!.lastNote!.toneLabel!,
      if (palette.isColorChord && request.settings.colorRealizationBias >= 0.55)
        ...palette.featuredLabels.take(2),
      ...palette.chordToneLabels.take(3),
      ...palette.featuredLabels.take(2),
    ];
    final start = canCarryOver
        ? _AnchorChoice(
            carryOverMidi,
            palette.labelForPitchClass(carryOverPitchClass) ??
                request.previousMelodyEvent?.lastNote?.toneLabel ??
                (palette.chordToneLabels.isEmpty
                    ? '1'
                    : palette.chordToneLabels.first),
          )
        : _nearestMidiForLabels(
            palette,
            startCandidates,
            targetMidi: startTargetMidi,
            low: low,
            high: high,
          );
    final endTargetPalette =
        phrasePlan.role == PhraseRole.preCadence && nextPalette != null
        ? nextPalette
        : palette;
    final endTargetMidi = _endTargetMidiForRole(
      phrasePlan,
      startMidi: start.midiNote,
      low: low,
      high: high,
    );
    final endCandidates =
        phrasePlan.role == PhraseRole.preCadence && nextPalette != null
        ? _resolutionLabelsFor(
            nextPalette,
            phrasePlan,
            recentCadenceLabels: recentEndingLabels,
          )
        : _endingLabelsFor(
            palette,
            phrasePlan,
            effectiveStyle,
            recentCadenceLabels: recentEndingLabels,
          );
    final end = _nearestMidiForLabels(
      endTargetPalette,
      endCandidates,
      targetMidi: endTargetMidi,
      low: low,
      high: high,
    );
    final apexMidi = max(
      phrasePlan.apexMidi,
      max(start.midiNote, end.midiNote) + 1,
    ).clamp(low, high);
    return PhraseAnchors(
      startMidi: start.midiNote,
      endMidi: end.midiNote,
      apexMidi: apexMidi,
      startToneLabel: start.toneLabel,
      endToneLabel: end.toneLabel,
    );
  }

  static _AnchorChoice _nearestMidiForLabels(
    MelodyHarmonyPalette palette,
    Iterable<String> labels, {
    required int targetMidi,
    required int low,
    required int high,
  }) {
    _AnchorChoice? best;
    for (final label in labels) {
      if (!MelodyCandidateBuilder.toneSemitones.containsKey(label)) {
        continue;
      }
      final pitchClass = palette.pitchClassForLabel(label);
      final midis = palette.nearestMidisForPitchClass(
        pitchClass,
        targetMidi: targetMidi,
        low: low,
        high: high,
        count: 1,
      );
      if (midis.isEmpty) {
        continue;
      }
      final choice = _AnchorChoice(midis.first, label);
      if (best == null ||
          (choice.midiNote - targetMidi).abs() <
              (best.midiNote - targetMidi).abs()) {
        best = choice;
      }
    }
    if (best != null) {
      return best;
    }
    final fallback = palette.nearestMidisForPitchClass(
      palette.chordPitchClasses.isEmpty
          ? targetMidi % 12
          : palette.chordPitchClasses.first,
      targetMidi: targetMidi,
      low: low,
      high: high,
      count: 1,
    );
    return _AnchorChoice(
      fallback.isEmpty ? targetMidi.clamp(low, high) : fallback.first,
      palette.chordToneLabels.isEmpty ? '1' : palette.chordToneLabels.first,
    );
  }

  static List<String> _resolutionLabelsFor(
    MelodyHarmonyPalette palette,
    PhrasePlan phrasePlan, {
    List<String> recentCadenceLabels = const <String>[],
  }) {
    final priority = switch (phrasePlan.endingDegreePriority) {
      1 => <String>['1', '3', '7', '9'],
      3 => <String>['3', 'b3', '1', '5'],
      5 => <String>['5', '3', '1'],
      7 => <String>['7', 'b7', '3', '1'],
      _ => <String>['1', '3', '5'],
    };
    final labels = <String>[
      for (final label in priority)
        if (palette.featuredLabels.contains(label) ||
            palette.chordToneLabels.contains(label))
          label,
      ...palette.featuredLabels.take(3),
    ];
    return _rotateRepeatedEndingLabels(
      labels,
      recentCadenceLabels: recentCadenceLabels,
    );
  }

  static List<String> _endingLabelsFor(
    MelodyHarmonyPalette palette,
    PhrasePlan phrasePlan,
    MelodyStyle effectiveStyle, {
    List<String> recentCadenceLabels = const <String>[],
  }) {
    final priorityLabel = switch (phrasePlan.endingDegreePriority) {
      1 => '1',
      3 => palette.interpretation.isMinorFamily ? 'b3' : '3',
      5 => '5',
      7 => palette.interpretation.isDominantFamily ? 'b7' : '7',
      _ => '1',
    };
    final roleLabels = switch (phrasePlan.role) {
      PhraseRole.opening => <String>[
        priorityLabel,
        '3',
        ...palette.chordToneLabels.take(3),
      ],
      PhraseRole.continuation => <String>[
        priorityLabel,
        ...palette.featuredLabels.take(2),
        ...palette.chordToneLabels.take(3),
      ],
      PhraseRole.preCadence => <String>[
        if (palette.featuredLabels.contains('7') ||
            palette.chordToneLabels.contains('7'))
          '7',
        if (palette.featuredLabels.contains('b7') ||
            palette.chordToneLabels.contains('b7'))
          'b7',
        ...palette.featuredLabels.take(3),
        ...palette.chordToneLabels.take(3),
      ],
      PhraseRole.cadence => <String>[
        priorityLabel,
        palette.interpretation.isMinorFamily ? 'b3' : '3',
        '1',
        ..._cadentialColorReleaseLabels(palette),
        ...palette.chordToneLabels.take(4),
      ],
    };
    final labels = <String>[
      switch (phrasePlan.endingDegreePriority) {
        1 => '1',
        3 => palette.interpretation.isMinorFamily ? 'b3' : '3',
        5 => '5',
        7 => palette.interpretation.isDominantFamily ? 'b7' : '7',
        _ => '1',
      },
      ...roleLabels,
      if (effectiveStyle == MelodyStyle.colorful)
        ...palette.featuredLabels.take(3),
      ...palette.chordToneLabels.take(4),
    ];
    return _rotateRepeatedEndingLabels(
      labels,
      recentCadenceLabels: recentCadenceLabels,
    );
  }

  static List<String> _startLabelsForRole(
    MelodyHarmonyPalette palette,
    PhrasePlan phrasePlan, {
    required MelodyStyle effectiveStyle,
  }) {
    return switch (phrasePlan.role) {
      PhraseRole.opening => <String>[
        if (palette.chordToneLabels.contains('3')) '3',
        '1',
        ...palette.chordToneLabels.take(3),
      ],
      PhraseRole.continuation => <String>[
        ...palette.chordToneLabels.take(3),
        ...palette.featuredLabels.take(2),
      ],
      PhraseRole.preCadence => <String>[
        ...palette.featuredLabels.take(2),
        if (palette.chordToneLabels.contains('5')) '5',
        ...palette.chordToneLabels.take(3),
      ],
      PhraseRole.cadence => <String>[
        if (effectiveStyle == MelodyStyle.colorful)
          ..._cadentialColorReleaseLabels(palette).take(1),
        ...palette.chordToneLabels.take(3),
      ],
    };
  }

  static int _startTargetMidiForRole(
    PhrasePlan phrasePlan, {
    required int previousMidiHint,
    required int low,
    required int high,
  }) {
    final target = switch (phrasePlan.role) {
      PhraseRole.opening =>
        ((phrasePlan.centerMidi + previousMidiHint) / 2).round(),
      PhraseRole.continuation => previousMidiHint,
      PhraseRole.preCadence => max(previousMidiHint, phrasePlan.centerMidi - 1),
      PhraseRole.cadence => min(previousMidiHint, phrasePlan.centerMidi + 1),
    };
    return target.clamp(low, high);
  }

  static int _endTargetMidiForRole(
    PhrasePlan phrasePlan, {
    required int startMidi,
    required int low,
    required int high,
  }) {
    final target = switch (phrasePlan.role) {
      PhraseRole.opening => phrasePlan.centerMidi,
      PhraseRole.continuation =>
        ((phrasePlan.centerMidi + startMidi) / 2).round(),
      PhraseRole.preCadence => max(phrasePlan.centerMidi + 1, startMidi),
      PhraseRole.cadence => min(phrasePlan.centerMidi, startMidi + 2),
    };
    return target.clamp(low, high);
  }

  static List<String> _cadentialColorReleaseLabels(
    MelodyHarmonyPalette palette,
  ) {
    final labels = <String>{
      for (final label in palette.featuredLabels)
        if (!palette.chordToneLabels.contains(label) ||
            label == '9' ||
            label == '13' ||
            label == '11' ||
            label == '#11')
          label,
    };
    return labels.toList(growable: false);
  }

  static List<String> _rotateRepeatedEndingLabels(
    List<String> labels, {
    required List<String> recentCadenceLabels,
  }) {
    final ordered = labels.toSet().toList(growable: false);
    if (recentCadenceLabels.isEmpty) {
      return ordered;
    }
    final repeated = recentCadenceLabels.take(2).toSet();
    return [
      for (final label in ordered)
        if (!repeated.contains(label)) label,
      for (final label in ordered)
        if (repeated.contains(label)) label,
    ];
  }

  static List<String> _recentCadenceEndingLabels(
    MelodyGenerationRequest request,
  ) {
    final labels = <String>[
      for (final event in request.recentMelodyEvents.reversed)
        if (event.phraseRole == PhraseRole.cadence &&
            event.lastNote?.toneLabel != null)
          event.lastNote!.toneLabel!,
      if (request.previousMelodyEvent?.phraseRole == PhraseRole.cadence &&
          request.previousMelodyEvent?.lastNote?.toneLabel != null)
        request.previousMelodyEvent!.lastNote!.toneLabel!,
    ];
    return labels.toSet().toList(growable: false);
  }

  static MelodyDensity _sampleEffectiveDensity(
    PracticeSettings settings, {
    required SettingsComplexityMode effectiveMode,
    required int seed,
  }) {
    final profile = MelodyGenerationConfig.profileFor(effectiveMode);
    final weights = <MelodyDensity, double>{
      ...profile.densityWeights,
      settings.melodyDensity:
          (profile.densityWeights[settings.melodyDensity] ?? 0.0) + 0.35,
    };
    return _pickWeightedDensity(
      weights,
      seed: seed,
      fallback: settings.melodyDensity,
    );
  }

  static MelodyStyle _sampleEffectiveStyle(
    PracticeSettings settings, {
    required SettingsComplexityMode effectiveMode,
    required int seed,
  }) {
    final profile = MelodyGenerationConfig.profileFor(effectiveMode);
    final weights = <MelodyStyle, double>{
      ...profile.styleWeights,
      settings.melodyStyle:
          (profile.styleWeights[settings.melodyStyle] ?? 0.0) + 0.40,
    };
    return _pickWeightedStyle(
      weights,
      seed: seed,
      fallback: settings.melodyStyle,
    );
  }

  static MelodyDensity _pickWeightedDensity(
    Map<MelodyDensity, double> weights, {
    required int seed,
    required MelodyDensity fallback,
  }) {
    var total = 0.0;
    for (final value in weights.values) {
      total += value;
    }
    if (total <= 0) {
      return fallback;
    }
    final random = Random(seed & 0x3fffffff);
    final roll = random.nextDouble() * total;
    var cursor = 0.0;
    for (final entry in weights.entries) {
      cursor += entry.value;
      if (roll <= cursor) {
        return entry.key;
      }
    }
    return fallback;
  }

  static MelodyStyle _pickWeightedStyle(
    Map<MelodyStyle, double> weights, {
    required int seed,
    required MelodyStyle fallback,
  }) {
    var total = 0.0;
    for (final value in weights.values) {
      total += value;
    }
    if (total <= 0) {
      return fallback;
    }
    final random = Random(seed & 0x3fffffff);
    final roll = random.nextDouble() * total;
    var cursor = 0.0;
    for (final entry in weights.entries) {
      cursor += entry.value;
      if (roll <= cursor) {
        return entry.key;
      }
    }
    return fallback;
  }

  static List<_MelodyBeam> _prune(
    List<_MelodyBeam> beams, {
    required int width,
  }) {
    beams.sort((left, right) => right.score.compareTo(left.score));
    return beams.take(width).toList(growable: false);
  }

  static MelodyNoteRole _roleForLabel(String? label) {
    if (label == '3' ||
        label == 'b3' ||
        label == '7' ||
        label == 'b7' ||
        label == '4') {
      return MelodyNoteRole.guideTone;
    }
    if (label == '9' ||
        label == '11' ||
        label == '#11' ||
        label == '13' ||
        label == 'b13' ||
        label == 'b9' ||
        label == '#9') {
      return MelodyNoteRole.stableTension;
    }
    return MelodyNoteRole.chordTone;
  }

  static List<int> _intervalVector(List<GeneratedMelodyNote> notes) {
    if (notes.length < 2) {
      return const <int>[];
    }
    return [
      for (var index = 1; index < notes.length; index += 1)
        notes[index].midiNote - notes[index - 1].midiNote,
    ];
  }

  static int _seedForRequest(
    MelodyGenerationRequest request, {
    int phraseVariantNonce = 0,
  }) {
    final previousMelody = request.previousMelodyEvent;
    final effectiveMode = MelodyGenerationConfig.effectiveModeForSettings(
      request.settings,
    );
    return MelodySeedUtil.stableHashAll(<Object?>[
      request.seed,
      request.settings.settingsComplexityMode.name,
      effectiveMode.name,
      _biasBucket(request.settings.syncopationBias),
      _biasBucket(request.settings.colorRealizationBias),
      _biasBucket(request.settings.noveltyTarget),
      _biasBucket(request.settings.motifVariationBias),
      _biasBucket(request.settings.approachToneDensity),
      request.settings.allowChromaticApproaches,
      request.chordEvent.chord.harmonicComparisonKey,
      request.previousChordEvent?.chord.harmonicComparisonKey,
      request.nextChordEvent?.chord.harmonicComparisonKey,
      previousMelody?.signatureHash,
      previousMelody?.lastMidiNoteBucket,
      request.chordEvent.timing.barIndex,
      request.chordEvent.timing.changeBeat,
      request.chordEvent.timing.durationBeats,
      request.phraseWindowIndex,
      for (final event in request.phraseChordWindow)
        event.chord.harmonicComparisonKey,
      phraseVariantNonce,
    ]);
  }

  static int _biasBucket(double value) => (value.clamp(0.0, 1.0) * 100).round();
}

class _MelodyBeam {
  const _MelodyBeam({required this.notes, required this.score});

  final List<BeamNote> notes;
  final double score;

  _MelodyBeam extend(BeamNote note, double delta) {
    return _MelodyBeam(notes: [...notes, note], score: score + delta);
  }
}

class _AnchorChoice {
  const _AnchorChoice(this.midiNote, this.toneLabel);

  final int midiNote;
  final String toneLabel;
}
