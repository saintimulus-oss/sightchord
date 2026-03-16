import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_theory.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';
import 'melody_seed_util.dart';
import 'motif_transformer.dart';
import 'phrase_planner.dart';
import 'rhythm_template_sampler.dart';
import 'voicing_engine.dart';
import 'voicing_models.dart';

enum MelodyCandidateCategory { chord, tension, nonChord, diatonic, chromatic }

class MelodyHarmonyPalette {
  const MelodyHarmonyPalette({
    required this.chord,
    required this.interpretation,
    required this.chordClassKey,
    required this.chordToneLabels,
    required this.featuredLabels,
    required this.identityLabels,
    required this.colorLabels,
    required this.scalePitchClasses,
    required this.chordPitchClasses,
    required this.preferFlat,
    required this.isColorChord,
    required this.isHardColorChord,
  });

  final GeneratedChord chord;
  final ChordVoicingInterpretation interpretation;
  final String chordClassKey;
  final List<String> chordToneLabels;
  final List<String> featuredLabels;
  final List<String> identityLabels;
  final List<String> colorLabels;
  final Set<int> scalePitchClasses;
  final Set<int> chordPitchClasses;
  final bool preferFlat;
  final bool isColorChord;
  final bool isHardColorChord;

  Set<int> get featuredPitchClasses => {
    for (final label in featuredLabels)
      if (MelodyCandidateBuilder.toneSemitones.containsKey(label))
        pitchClassForLabel(label),
  };

  Set<int> get identityPitchClasses => {
    for (final label in identityLabels)
      if (MelodyCandidateBuilder.toneSemitones.containsKey(label))
        pitchClassForLabel(label),
  };

  int pitchClassForLabel(String label) {
    final relative = MelodyCandidateBuilder.toneSemitones[label] ?? 0;
    return (interpretation.rootSemitone + relative) % 12;
  }

  bool containsIdentityLabel(String? label) {
    return label != null && identityLabels.contains(label);
  }

  int featuredPriorityFor(String? label) {
    if (label == null) {
      return 99;
    }
    final index = featuredLabels.indexOf(label);
    return index < 0 ? 99 : index;
  }

  int identityPriorityFor(String? label) {
    if (label == null) {
      return 99;
    }
    final index = identityLabels.indexOf(label);
    return index < 0 ? 99 : index;
  }

  String? labelForPitchClass(int pitchClass) {
    for (final label in [
      ...identityLabels,
      ...featuredLabels,
      ...chordToneLabels,
    ]) {
      if (pitchClassForLabel(label) == pitchClass % 12) {
        return label;
      }
    }
    return null;
  }

  List<int> nearestMidisForPitchClass(
    int pitchClass, {
    required int targetMidi,
    required int low,
    required int high,
    int count = 2,
  }) {
    final candidates = <int>[];
    for (var midi = low; midi <= high; midi += 1) {
      if (midi % 12 == pitchClass % 12) {
        candidates.add(midi);
      }
    }
    candidates.sort(
      (left, right) =>
          (left - targetMidi).abs().compareTo((right - targetMidi).abs()),
    );
    return candidates.take(count).toList(growable: false);
  }

  factory MelodyHarmonyPalette.fromChord({
    required GeneratedChord chord,
    required PracticeSettings settings,
  }) {
    final interpretation = VoicingEngine.interpretChord(
      chord: chord,
      settings: settings,
    );
    final chordClassKey = _chordClassKey(chord, interpretation);
    final featuredLabels =
        MelodyGenerationConfig.featuredDegrees[chordClassKey] ??
        _fallbackFeaturedLabels(chord, interpretation);
    final chordToneLabels = _chordToneLabels(chord, interpretation);
    final identityLabels = _identityLabelsFor(
      chordClassKey,
      chord: chord,
      featuredLabels: featuredLabels,
      chordToneLabels: chordToneLabels,
    );
    final scalePitchClasses = {
      for (final relative in _relativeScaleSemitonesFor(
        chord: chord,
        interpretation: interpretation,
      ))
        (interpretation.rootSemitone + relative) % 12,
    };
    final chordPitchClasses = {
      for (final label in chordToneLabels)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(label))
          (interpretation.rootSemitone +
                  MelodyCandidateBuilder.toneSemitones[label]!) %
              12,
    };
    final colorLabels = <String>[
      for (final label in identityLabels)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(label)) label,
    ];
    final isHardColorChord =
        chordClassKey == 'dom7alt' ||
        chordClassKey == 'lydianDom' ||
        chordClassKey == 'borrowedIv' ||
        chordClassKey == 'halfDim';
    final isColorChord =
        identityLabels.isNotEmpty ||
        chord.symbolData.tensions.isNotEmpty ||
        chord.isRenderedNonDiatonic ||
        isHardColorChord;
    return MelodyHarmonyPalette(
      chord: chord,
      interpretation: interpretation,
      chordClassKey: chordClassKey,
      chordToneLabels: chordToneLabels,
      featuredLabels: featuredLabels,
      identityLabels: identityLabels,
      colorLabels: colorLabels,
      scalePitchClasses: scalePitchClasses,
      chordPitchClasses: chordPitchClasses,
      preferFlat: interpretation.preferFlatSpelling,
      isColorChord: isColorChord,
      isHardColorChord: isHardColorChord,
    );
  }

  static String _chordClassKey(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    if (chord.symbolData.renderQuality == ChordQuality.dominant7Alt ||
        interpretation.isAlteredFamily) {
      return 'dom7alt';
    }
    if (chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11 ||
        chord.dominantIntent == DominantIntent.lydianDominant ||
        chord.dominantIntent == DominantIntent.backdoor ||
        chord.appliedType == AppliedType.substitute) {
      return 'lydianDom';
    }
    if (interpretation.isHalfDiminishedFamily) {
      return 'halfDim';
    }
    if (chord.romanNumeralId == RomanNumeralId.borrowedIvMin7) {
      return 'borrowedIv';
    }
    if (interpretation.isMinorFamily &&
        chord.symbolData.tensions.contains('11') &&
        !chord.symbolData.tensions.contains('13')) {
      return 'minor11';
    }
    if (interpretation.isMinorFamily &&
        (chord.symbolData.tensions.contains('13') ||
            chord.symbolData.tensions.contains('11'))) {
      return 'minor13';
    }
    if (interpretation.isMinorFamily) {
      return 'minor7';
    }
    if (interpretation.isDominantFamily) {
      return 'dominant7';
    }
    if (chord.symbolData.tensions.contains('#11')) {
      return 'maj7#11';
    }
    return 'maj7';
  }

  static List<String> _fallbackFeaturedLabels(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    if (interpretation.isDominantFamily) {
      return const <String>['3', 'b7', '9', '13', '1', '5'];
    }
    if (interpretation.isMinorFamily) {
      return const <String>['b3', 'b7', '9', '11', '1', '5'];
    }
    if (interpretation.isHalfDiminishedFamily) {
      return const <String>['b3', 'b5', 'b7', '11', '1'];
    }
    return chord.symbolData.tensions.contains('#11')
        ? const <String>['3', '7', '#11', '9', '13', '1']
        : const <String>['3', '7', '9', '13', '1', '5'];
  }

  static List<String> _identityLabelsFor(
    String chordClassKey, {
    required GeneratedChord chord,
    required List<String> featuredLabels,
    required List<String> chordToneLabels,
  }) {
    final configured =
        MelodyGenerationConfig.colorIdentityDegrees[chordClassKey];
    final labels = <String>{
      if (configured != null) ...configured,
      for (final tension in chord.symbolData.tensions)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(tension)) tension,
      if (chordClassKey == 'lydianDom' || chordClassKey == 'dom7alt') '3',
      if (chordClassKey == 'lydianDom' || chordClassKey == 'dom7alt') 'b7',
    };
    if (labels.isEmpty &&
        (chord.isRenderedNonDiatonic ||
            chord.appliedType == AppliedType.substitute ||
            chord.dominantIntent == DominantIntent.backdoor ||
            chord.dominantIntent == DominantIntent.lydianDominant)) {
      labels.addAll(
        featuredLabels.where(
          (label) =>
              !chordToneLabels.contains(label) || !_isCoreChordLabel(label),
        ),
      );
    }
    if (labels.isEmpty) {
      return const <String>[];
    }
    final resolved = <String>{
      for (final label in labels)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(label)) label,
    };
    return resolved.toList(growable: false);
  }

  static List<String> _fallbackIdentityLabels(
    String chordClassKey,
    List<String> featuredLabels,
    List<String> chordToneLabels,
  ) {
    final explicit = switch (chordClassKey) {
      'dom7alt' => const <String>['b9', '#9', '#11', 'b13', '3', 'b7'],
      'lydianDom' => const <String>['#11', '9', '13', '3', 'b7'],
      'maj7#11' => const <String>['#11', '9', '7'],
      'minor11' => const <String>['11', '9', 'b3', 'b7'],
      'minor13' => const <String>['13', '11', '9', 'b3', 'b7'],
      'halfDim' => const <String>['b5', '11', 'b3'],
      'borrowedIv' => const <String>['b3', '11', '9', 'b7'],
      _ => <String>[
        for (final label in featuredLabels)
          if (!chordToneLabels.contains(label) || !_isCoreChordLabel(label))
            label,
      ],
    };
    final resolved = <String>{
      for (final label in explicit)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(label)) label,
    };
    if (resolved.isEmpty) {
      resolved.addAll(
        featuredLabels.where(MelodyCandidateBuilder.toneSemitones.containsKey),
      );
    }
    return resolved.toList(growable: false);
  }

  static List<String> _chordToneLabels(
    GeneratedChord chord,
    ChordVoicingInterpretation interpretation,
  ) {
    final ordered = <String>{
      for (final label in interpretation.essentialLabels)
        if (MelodyCandidateBuilder.toneSemitones.containsKey(label)) label,
      for (final label in interpretation.optionalLabels)
        if (_isCoreChordLabel(label)) label,
    };
    if (ordered.isEmpty) {
      if (interpretation.isMinorFamily) {
        return const <String>['1', 'b3', '5', 'b7'];
      }
      if (interpretation.isDominantFamily) {
        return interpretation.isSusFamily
            ? const <String>['1', '4', '5', 'b7']
            : const <String>['1', '3', '5', 'b7'];
      }
      if (interpretation.isHalfDiminishedFamily) {
        return const <String>['1', 'b3', 'b5', 'b7'];
      }
      return const <String>['1', '3', '5', '7'];
    }
    return ordered.toList(growable: false);
  }

  static List<int> _relativeScaleSemitonesFor({
    required GeneratedChord chord,
    required ChordVoicingInterpretation interpretation,
  }) {
    if (interpretation.isDominantFamily) {
      if (interpretation.isSusFamily) {
        return const <int>[0, 2, 5, 7, 9, 10];
      }
      if (chord.symbolData.renderQuality == ChordQuality.dominant7Alt) {
        return const <int>[0, 1, 3, 4, 6, 8, 10];
      }
      if (chord.appliedType == AppliedType.substitute ||
          chord.dominantIntent == DominantIntent.tritoneSub ||
          chord.dominantIntent == DominantIntent.lydianDominant ||
          chord.dominantIntent == DominantIntent.backdoor ||
          chord.symbolData.renderQuality == ChordQuality.dominant7Sharp11) {
        return const <int>[0, 2, 4, 6, 7, 9, 10];
      }
      return const <int>[0, 2, 4, 5, 7, 9, 10];
    }
    if (interpretation.isHalfDiminishedFamily) {
      return const <int>[0, 1, 3, 5, 6, 8, 10];
    }
    if (chord.romanNumeralId == RomanNumeralId.borrowedIvMin7) {
      return const <int>[0, 2, 3, 5, 7, 8, 10];
    }
    if (interpretation.isMinorFamily) {
      return const <int>[0, 2, 3, 5, 7, 9, 10];
    }
    return chord.symbolData.tensions.contains('#11')
        ? const <int>[0, 2, 4, 6, 7, 9, 11]
        : const <int>[0, 2, 4, 5, 7, 9, 11];
  }

  static bool _isCoreChordLabel(String label) {
    return label == '1' ||
        label == '3' ||
        label == 'b3' ||
        label == '5' ||
        label == 'b5' ||
        label == '7' ||
        label == 'b7' ||
        label == '4' ||
        label == '6';
  }
}

class MelodyDecodeContext {
  const MelodyDecodeContext({
    required this.request,
    required this.palette,
    required this.previousPalette,
    required this.nextPalette,
    required this.phrasePlan,
    required this.anchors,
    required this.rhythmSample,
    required this.motifPlan,
    required this.effectiveDensity,
    required this.effectiveStyle,
    required this.seed,
  });

  final MelodyGenerationRequest request;
  final MelodyHarmonyPalette palette;
  final MelodyHarmonyPalette? previousPalette;
  final MelodyHarmonyPalette? nextPalette;
  final PhrasePlan phrasePlan;
  final PhraseAnchors anchors;
  final RhythmTemplateSample rhythmSample;
  final MotifTransformPlan motifPlan;
  final MelodyDensity effectiveDensity;
  final MelodyStyle effectiveStyle;
  final int seed;

  int targetMidiFor(double phrasePos01) {
    final clamped = phrasePos01.clamp(0.0, 1.0);
    final linear =
        anchors.startMidi + ((anchors.endMidi - anchors.startMidi) * clamped);
    final distanceToApex = (clamped - phrasePlan.apexPos01).abs();
    final apexInfluence = max(0.0, 1.0 - (distanceToApex / 0.35));
    final baselineAtApex =
        anchors.startMidi +
        ((anchors.endMidi - anchors.startMidi) * phrasePlan.apexPos01);
    final apexLift = phrasePlan.apexMidi - baselineAtApex;
    return (linear + (apexLift * apexInfluence)).round();
  }
}

class MelodyCandidate {
  const MelodyCandidate({
    required this.midiNote,
    required this.toneLabel,
    required this.category,
    required this.role,
    required this.preScore,
    required this.targetsColor,
  });

  final int midiNote;
  final String? toneLabel;
  final MelodyCandidateCategory category;
  final MelodyNoteRole role;
  final double preScore;
  final bool targetsColor;
}

class BeamNote {
  const BeamNote({
    required this.note,
    required this.category,
    required this.metricStrength,
    required this.anticipatory,
  });

  final GeneratedMelodyNote note;
  final MelodyCandidateCategory category;
  final double metricStrength;
  final bool anticipatory;
}

class MelodyCandidateBuilder {
  const MelodyCandidateBuilder._();

  static const Map<String, int> toneSemitones = {
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

  static List<MelodyCandidate> build({
    required RhythmSlot slot,
    required int slotIndex,
    required List<BeamNote> beamNotes,
    required MelodyDecodeContext context,
  }) {
    final previousMidi = beamNotes.isEmpty
        ? context.anchors.startMidi
        : beamNotes.last.note.midiNote;
    final targetMidi = context.targetMidiFor(slot.phrasePos01);
    final categories = _categoryOrder(
      slot: slot,
      slotIndex: slotIndex,
      beamNotes: beamNotes,
      context: context,
    );
    final candidates = <MelodyCandidate>[];
    for (final category in categories) {
      candidates.addAll(
        _buildForCategory(
          category,
          slot: slot,
          slotIndex: slotIndex,
          previousMidi: previousMidi,
          targetMidi: targetMidi,
          context: context,
        ),
      );
    }
    candidates.addAll(
      _samePitchCandidates(slot: slot, beamNotes: beamNotes, context: context),
    );
    candidates.addAll(
      _apexLeapCandidates(slot: slot, beamNotes: beamNotes, context: context),
    );
    final byMidi = <int, MelodyCandidate>{};
    for (final candidate in candidates) {
      final existing = byMidi[candidate.midiNote];
      if (existing == null || candidate.preScore > existing.preScore) {
        byMidi[candidate.midiNote] = candidate;
      }
    }
    final ordered = byMidi.values.toList(growable: false)
      ..sort((left, right) => right.preScore.compareTo(left.preScore));
    final limit =
        MelodyGenerationConfig.candidateLimit[context
            .request
            .settings
            .settingsComplexityMode] ??
        10;
    return ordered.take(limit).toList(growable: false);
  }

  static List<MelodyCandidate> _samePitchCandidates({
    required RhythmSlot slot,
    required List<BeamNote> beamNotes,
    required MelodyDecodeContext context,
  }) {
    if (beamNotes.isEmpty) {
      return const <MelodyCandidate>[];
    }
    final previousMidi = beamNotes.last.note.midiNote;
    final pitchClass = previousMidi % 12;
    if (!context.palette.scalePitchClasses.contains(pitchClass) &&
        !context.palette.chordPitchClasses.contains(pitchClass)) {
      return const <MelodyCandidate>[];
    }
    final mode = context.request.settings.settingsComplexityMode;
    final preferred = switch (mode) {
      SettingsComplexityMode.guided => slot.isStrong ? 6.4 : 5.6,
      SettingsComplexityMode.standard => slot.isStrong ? 5.1 : 4.4,
      SettingsComplexityMode.advanced => 3.2,
    };
    final category = context.palette.chordPitchClasses.contains(pitchClass)
        ? MelodyCandidateCategory.chord
        : MelodyCandidateCategory.diatonic;
    final toneLabel = category == MelodyCandidateCategory.chord
        ? context.palette.labelForPitchClass(pitchClass)
        : null;
    return [
      MelodyCandidate(
        midiNote: previousMidi,
        toneLabel: toneLabel,
        category: category,
        role: _roleForCandidate(
          toneLabel,
          category: category,
          slot: slot,
          context: context,
        ),
        preScore: preferred,
        targetsColor:
            toneLabel != null &&
            context.palette.colorLabels.contains(toneLabel),
      ),
    ];
  }

  static List<MelodyCandidate> _apexLeapCandidates({
    required RhythmSlot slot,
    required List<BeamNote> beamNotes,
    required MelodyDecodeContext context,
  }) {
    if (context.request.settings.settingsComplexityMode !=
            SettingsComplexityMode.advanced ||
        beamNotes.isEmpty ||
        (slot.phrasePos01 - context.phrasePlan.apexPos01).abs() > 0.14) {
      return const <MelodyCandidate>[];
    }
    final leapGate =
        MelodySeedUtil.stableHashAll(<Object?>[
          context.seed,
          context.request.chordEvent.chord.harmonicComparisonKey,
          slot.index,
        ]) &
        0x7fffffff;
    if (leapGate % 3 != 0) {
      return const <MelodyCandidate>[];
    }
    final previousMidi = beamNotes.last.note.midiNote;
    final low = context.request.settings.melodyRangeLow;
    final high = context.request.settings.melodyRangeHigh;
    final targetMidi = max(
      context.targetMidiFor(slot.phrasePos01),
      context.phrasePlan.apexMidi,
    );
    final leapMidis = <int>{};
    final labelPool = <String>{
      ...context.palette.featuredLabels.take(4),
      ...context.palette.chordToneLabels.take(2),
    };
    for (final label in labelPool) {
      if (!toneSemitones.containsKey(label)) {
        continue;
      }
      final pitchClass = context.palette.pitchClassForLabel(label);
      final baseMidis = context.palette.nearestMidisForPitchClass(
        pitchClass,
        targetMidi: targetMidi,
        low: low,
        high: high,
        count: 2,
      );
      for (final baseMidi in baseMidis) {
        for (final displacement in const <int>[0, 12, -12]) {
          final midi = baseMidi + displacement;
          final interval = (midi - previousMidi).abs();
          if (midi < low || midi > high || interval < 8 || interval > 12) {
            continue;
          }
          leapMidis.add(midi);
        }
      }
    }
    return [
      for (final midi in leapMidis)
        if ((midi - previousMidi).abs() >= 8)
          MelodyCandidate(
            midiNote: midi,
            toneLabel: context.palette.labelForPitchClass(midi % 12),
            category:
                context.palette.colorLabels.contains(
                  context.palette.labelForPitchClass(midi % 12),
                )
                ? MelodyCandidateCategory.tension
                : MelodyCandidateCategory.chord,
            role: _roleForCandidate(
              context.palette.labelForPitchClass(midi % 12),
              category: MelodyCandidateCategory.tension,
              slot: slot,
              context: context,
            ),
            preScore:
                context.palette.colorLabels.contains(
                  context.palette.labelForPitchClass(midi % 12),
                )
                ? 2.45
                : 2.1,
            targetsColor: context.palette.colorLabels.contains(
              context.palette.labelForPitchClass(midi % 12),
            ),
          ),
    ];
  }

  static List<MelodyCandidateCategory> _categoryOrder({
    required RhythmSlot slot,
    required int slotIndex,
    required List<BeamNote> beamNotes,
    required MelodyDecodeContext context,
  }) {
    final baseMap = Map<String, double>.from(
      slot.isStrong
          ? MelodyGenerationConfig.strongSlotCategoryProb[context
                    .request
                    .settings
                    .settingsComplexityMode] ??
                const <String, double>{}
          : MelodyGenerationConfig.weakSlotCategoryProb[context
                    .request
                    .settings
                    .settingsComplexityMode] ??
                const <String, double>{},
    );
    final outstandingColor = _outstandingColorNeed(
      beamNotes: beamNotes,
      slotIndex: slotIndex,
      context: context,
    );
    if (context.palette.isColorChord && outstandingColor > 0.0) {
      final key = slot.isStrong ? 'tension' : 'tension';
      final mode = context.request.settings.settingsComplexityMode;
      final colorPressure =
          switch (mode) {
            SettingsComplexityMode.guided => 0.06,
            SettingsComplexityMode.standard => 0.12,
            SettingsComplexityMode.advanced => 0.18,
          } +
          (outstandingColor * 0.24) +
          (context.palette.isHardColorChord
              ? switch (mode) {
                  SettingsComplexityMode.guided => 0.00,
                  SettingsComplexityMode.standard => 0.04,
                  SettingsComplexityMode.advanced => 0.08,
                }
              : 0.0);
      baseMap.update(
        key,
        (value) => value + colorPressure,
        ifAbsent: () => colorPressure,
      );
      if (slot.isStrong) {
        baseMap.update(
          'chord',
          (value) => max(0.18, value - (0.10 + (outstandingColor * 0.12))),
        );
      } else if (slot.anticipatory || slot.startBeatOffset % 1 != 0) {
        baseMap.update(
          'chromatic',
          (value) => value + (context.palette.isHardColorChord ? 0.06 : 0.02),
          ifAbsent: () => context.palette.isHardColorChord ? 0.06 : 0.02,
        );
      }
    }
    final primary = _pickCategory(
      baseMap,
      hashSeed: MelodySeedUtil.stableHashAll(<Object?>[
        context.seed,
        slotIndex,
        beamNotes.length,
      ]),
      fallback: slot.isStrong
          ? MelodyCandidateCategory.chord
          : MelodyCandidateCategory.diatonic,
    );
    final ordered = <MelodyCandidateCategory>[primary];
    if (slot.isStrong && primary != MelodyCandidateCategory.chord) {
      ordered.add(MelodyCandidateCategory.chord);
    } else if (!slot.isStrong && primary != MelodyCandidateCategory.diatonic) {
      ordered.add(MelodyCandidateCategory.diatonic);
    }
    if (context.palette.isColorChord &&
        primary != MelodyCandidateCategory.tension &&
        slot.isStrong) {
      ordered.add(MelodyCandidateCategory.tension);
    }
    if (context.palette.isColorChord &&
        outstandingColor >= 0.08 &&
        primary != MelodyCandidateCategory.tension &&
        !slot.isStrong) {
      ordered.add(MelodyCandidateCategory.tension);
    }
    return ordered.toSet().toList(growable: false);
  }

  static double _outstandingColorNeed({
    required List<BeamNote> beamNotes,
    required int slotIndex,
    required MelodyDecodeContext context,
  }) {
    if (!context.palette.isColorChord) {
      return 0.0;
    }
    final seen = max(1, slotIndex);
    final hits = beamNotes
        .where(
          (note) => context.palette.containsIdentityLabel(note.note.toneLabel),
        )
        .length;
    final realized = hits / seen;
    final distinctIdentityHits = {
      for (final note in beamNotes)
        if (context.palette.containsIdentityLabel(note.note.toneLabel))
          note.note.toneLabel!,
    }.length;
    final identityCoverage = context.palette.identityLabels.isEmpty
        ? 1.0
        : distinctIdentityHits /
              min(context.palette.identityLabels.length, max(1, slotIndex));
    final effectiveRealization = (realized * 0.72) + (identityCoverage * 0.28);
    return max(
      0.0,
      context.phrasePlan.targetColorExposure01 - effectiveRealization,
    );
  }

  static MelodyCandidateCategory _pickCategory(
    Map<String, double> weights, {
    required int hashSeed,
    required MelodyCandidateCategory fallback,
  }) {
    var total = 0.0;
    for (final value in weights.values) {
      total += value;
    }
    if (total <= 0) {
      return fallback;
    }
    final random = Random(hashSeed & 0x3fffffff);
    final roll = random.nextDouble() * total;
    var cursor = 0.0;
    for (final entry in weights.entries) {
      cursor += entry.value;
      if (roll <= cursor) {
        return switch (entry.key) {
          'chord' => MelodyCandidateCategory.chord,
          'tension' => MelodyCandidateCategory.tension,
          'nonChord' => MelodyCandidateCategory.nonChord,
          'diatonic' => MelodyCandidateCategory.diatonic,
          'chromatic' => MelodyCandidateCategory.chromatic,
          _ => fallback,
        };
      }
    }
    return fallback;
  }

  static List<MelodyCandidate> _buildForCategory(
    MelodyCandidateCategory category, {
    required RhythmSlot slot,
    required int slotIndex,
    required int previousMidi,
    required int targetMidi,
    required MelodyDecodeContext context,
  }) {
    final low = context.request.settings.melodyRangeLow;
    final high = context.request.settings.melodyRangeHigh;
    final raw = <MelodyCandidate>[];
    switch (category) {
      case MelodyCandidateCategory.chord:
        final chordLabels = _chordCategoryLabels(context.palette);
        for (final label in chordLabels) {
          raw.addAll(
            _fromLabel(
              label,
              category: category,
              slot: slot,
              previousMidi: previousMidi,
              targetMidi: targetMidi,
              context: context,
              low: low,
              high: high,
            ),
          );
        }
      case MelodyCandidateCategory.tension:
        final tensionLabels = _tensionCategoryLabels(context.palette);
        for (final label in tensionLabels) {
          raw.addAll(
            _fromLabel(
              label,
              category: category,
              slot: slot,
              previousMidi: previousMidi,
              targetMidi: targetMidi,
              context: context,
              low: low,
              high: high,
            ),
          );
        }
      case MelodyCandidateCategory.nonChord:
      case MelodyCandidateCategory.diatonic:
        final pitchClasses = {
          for (final pitchClass in context.palette.scalePitchClasses)
            if (!context.palette.chordPitchClasses.contains(pitchClass))
              pitchClass,
        };
        for (final pitchClass in pitchClasses) {
          raw.addAll(
            _fromPitchClass(
              pitchClass,
              category: category,
              slot: slot,
              previousMidi: previousMidi,
              targetMidi: targetMidi,
              context: context,
              low: low,
              high: high,
            ),
          );
        }
      case MelodyCandidateCategory.chromatic:
        final chromaticPitchClasses = <int>{
          (previousMidi + 1) % 12,
          (previousMidi + 11) % 12,
          (targetMidi + 1) % 12,
          (targetMidi + 11) % 12,
        };
        if (context.nextPalette != null) {
          for (final label in context.nextPalette!.featuredLabels.take(3)) {
            final pitchClass = context.nextPalette!.pitchClassForLabel(label);
            chromaticPitchClasses.add((pitchClass + 1) % 12);
            chromaticPitchClasses.add((pitchClass + 11) % 12);
          }
        }
        for (final pitchClass in chromaticPitchClasses) {
          raw.addAll(
            _fromPitchClass(
              pitchClass,
              category: category,
              slot: slot,
              previousMidi: previousMidi,
              targetMidi: targetMidi,
              context: context,
              low: low,
              high: high,
            ),
          );
        }
    }
    raw.sort((left, right) => right.preScore.compareTo(left.preScore));
    return raw.take(8).toList(growable: false);
  }

  static List<MelodyCandidate> _fromLabel(
    String label, {
    required MelodyCandidateCategory category,
    required RhythmSlot slot,
    required int previousMidi,
    required int targetMidi,
    required MelodyDecodeContext context,
    required int low,
    required int high,
  }) {
    if (!toneSemitones.containsKey(label)) {
      return const <MelodyCandidate>[];
    }
    final pitchClass = context.palette.pitchClassForLabel(label);
    final midis = context.palette.nearestMidisForPitchClass(
      pitchClass,
      targetMidi: targetMidi,
      low: low,
      high: high,
      count: 3,
    );
    return [
      for (final midi in midis)
        _candidate(
          midi,
          toneLabel: label,
          category: category,
          slot: slot,
          previousMidi: previousMidi,
          targetMidi: targetMidi,
          context: context,
        ),
    ];
  }

  static List<MelodyCandidate> _fromPitchClass(
    int pitchClass, {
    required MelodyCandidateCategory category,
    required RhythmSlot slot,
    required int previousMidi,
    required int targetMidi,
    required MelodyDecodeContext context,
    required int low,
    required int high,
  }) {
    final toneLabel =
        category == MelodyCandidateCategory.chord &&
            context.palette.chordPitchClasses.contains(pitchClass % 12)
        ? context.palette.labelForPitchClass(pitchClass)
        : null;
    final midis = context.palette.nearestMidisForPitchClass(
      pitchClass,
      targetMidi: targetMidi,
      low: low,
      high: high,
      count: 2,
    );
    return [
      for (final midi in midis)
        _candidate(
          midi,
          toneLabel: toneLabel,
          category: category,
          slot: slot,
          previousMidi: previousMidi,
          targetMidi: targetMidi,
          context: context,
        ),
    ];
  }

  static MelodyCandidate _candidate(
    int midiNote, {
    required String? toneLabel,
    required MelodyCandidateCategory category,
    required RhythmSlot slot,
    required int previousMidi,
    required int targetMidi,
    required MelodyDecodeContext context,
  }) {
    final distanceToTarget = (midiNote - targetMidi).abs().toDouble();
    final interval = (midiNote - previousMidi).abs().toDouble();
    final targetsColor = context.palette.containsIdentityLabel(toneLabel);
    var preScore = 2.2 - (distanceToTarget * 0.16) - (interval * 0.08);
    final identityPriority = context.palette.identityPriorityFor(toneLabel);
    final featuredPriority = context.palette.featuredPriorityFor(toneLabel);
    if (targetsColor) {
      final modeColorBonus =
          switch (context.request.settings.settingsComplexityMode) {
            SettingsComplexityMode.guided => 0.06,
            SettingsComplexityMode.standard => 0.12,
            SettingsComplexityMode.advanced => 0.20,
          };
      preScore +=
          0.24 +
          max(0.0, 0.28 - (identityPriority * 0.06)) +
          (slot.isStrong ? 0.14 : 0.08) +
          modeColorBonus;
    } else if (featuredPriority < 99) {
      preScore += max(0.0, 0.16 - (featuredPriority * 0.03));
    }
    if (context.palette.isColorChord &&
        category == MelodyCandidateCategory.tension) {
      preScore +=
          0.08 +
          (context.request.settings.colorRealizationBias * 0.10) +
          (context.palette.isHardColorChord
              ? (context.request.settings.settingsComplexityMode ==
                        SettingsComplexityMode.advanced
                    ? 0.08
                    : 0.03)
              : 0.0);
    }
    if (context.palette.isColorChord &&
        !targetsColor &&
        category == MelodyCandidateCategory.chord &&
        slot.isStrong) {
      preScore -= 0.10 + (context.palette.isHardColorChord ? 0.06 : 0.0);
    }
    if (slot.anticipatory && context.nextPalette != null) {
      final nextPitchClasses = {
        ...context.nextPalette!.identityPitchClasses,
        ...context.nextPalette!.featuredPitchClasses,
      };
      if (nextPitchClasses.contains(midiNote % 12)) {
        preScore += 0.42;
      }
    }
    preScore += _boundaryPreScore(
      midiNote,
      toneLabel: toneLabel,
      slot: slot,
      context: context,
      targetsColor: targetsColor,
    );
    final role = _roleForCandidate(
      toneLabel,
      category: category,
      slot: slot,
      context: context,
    );
    return MelodyCandidate(
      midiNote: midiNote,
      toneLabel: toneLabel,
      category: category,
      role: role,
      preScore: preScore,
      targetsColor: targetsColor,
    );
  }

  static List<String> _chordCategoryLabels(MelodyHarmonyPalette palette) {
    final labels = <String>[
      for (final label in palette.chordToneLabels)
        if (!palette.identityLabels.contains(label)) label,
    ];
    if (labels.isEmpty) {
      labels.addAll(palette.chordToneLabels);
    }
    return labels;
  }

  static List<String> _tensionCategoryLabels(MelodyHarmonyPalette palette) {
    final labels = <String>[
      ...palette.identityLabels,
      for (final label in palette.featuredLabels)
        if (!palette.identityLabels.contains(label) &&
            !palette.chordToneLabels.contains(label))
          label,
    ];
    if (labels.isEmpty) {
      labels.addAll(palette.featuredLabels);
    }
    return labels.toSet().toList(growable: false);
  }

  static double _boundaryPreScore(
    int midiNote, {
    required String? toneLabel,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
    required bool targetsColor,
  }) {
    var score = 0.0;
    final pitchClass = midiNote % 12;
    if (context.previousPalette != null &&
        context.request.previousChordEvent?.chord.harmonicComparisonKey !=
            context.request.chordEvent.chord.harmonicComparisonKey &&
        slot.index <= 1) {
      final previousPalette = context.previousPalette!;
      if (previousPalette.chordPitchClasses.contains(pitchClass) ||
          previousPalette.featuredPitchClasses.contains(pitchClass)) {
        score += 0.18;
      } else {
        final stepToPrevious = _distanceToPitchClasses(
          midiNote,
          previousPalette.featuredPitchClasses.union(
            previousPalette.chordPitchClasses,
          ),
        );
        if (stepToPrevious <= 2) {
          score += 0.12;
        }
      }
      if (targetsColor &&
          !previousPalette.identityPitchClasses.contains(pitchClass)) {
        score += 0.16 + (slot.isStrong ? 0.06 : 0.0);
      }
    }
    if (context.nextPalette != null &&
        context.request.nextChordEvent?.chord.harmonicComparisonKey !=
            context.request.chordEvent.chord.harmonicComparisonKey &&
        (slot.anticipatory ||
            slot.index >= context.rhythmSample.slots.length - 2)) {
      final nextPalette = context.nextPalette!;
      final stepToNext = _distanceToPitchClasses(
        midiNote,
        nextPalette.identityPitchClasses.union(nextPalette.chordPitchClasses),
      );
      score += max(0.0, 0.32 - (stepToNext * 0.08));
      if (nextPalette.identityPitchClasses.contains(pitchClass)) {
        score += 0.18;
      } else if (nextPalette.featuredPitchClasses.contains(pitchClass)) {
        score += 0.10;
      }
      if (targetsColor && stepToNext <= 2) {
        score += 0.20;
      }
      if (toneLabel != null &&
          nextPalette.containsIdentityLabel(
            nextPalette.labelForPitchClass(pitchClass),
          )) {
        score += 0.12;
      }
    }
    return score;
  }

  static int _distanceToPitchClasses(int midiNote, Set<int> pitchClasses) {
    if (pitchClasses.isEmpty) {
      return 99;
    }
    var best = 99;
    for (final pitchClass in pitchClasses) {
      final upward = (pitchClass - (midiNote % 12)) % 12;
      final downward = (((midiNote % 12) - pitchClass) % 12);
      best = min(best, min(upward, downward));
    }
    return best;
  }

  static MelodyNoteRole _roleForCandidate(
    String? toneLabel, {
    required MelodyCandidateCategory category,
    required RhythmSlot slot,
    required MelodyDecodeContext context,
  }) {
    if (slot.anticipatory && context.nextPalette != null) {
      final pitchClasses = context.nextPalette!.featuredPitchClasses;
      if (toneLabel != null &&
          pitchClasses.contains(
            context.palette.pitchClassForLabel(toneLabel),
          )) {
        return MelodyNoteRole.anticipation;
      }
    }
    if (category == MelodyCandidateCategory.chromatic) {
      return MelodyNoteRole.approach;
    }
    if (toneLabel == '3' ||
        toneLabel == 'b3' ||
        toneLabel == '7' ||
        toneLabel == 'b7' ||
        toneLabel == '4') {
      return MelodyNoteRole.guideTone;
    }
    if (toneLabel == '9' ||
        toneLabel == '11' ||
        toneLabel == '#11' ||
        toneLabel == '13' ||
        toneLabel == 'b13' ||
        toneLabel == '6' ||
        toneLabel == 'b9' ||
        toneLabel == '#9') {
      return MelodyNoteRole.stableTension;
    }
    if (category == MelodyCandidateCategory.chord) {
      return slot.isStrong ? MelodyNoteRole.chordTone : MelodyNoteRole.neighbor;
    }
    if (category == MelodyCandidateCategory.tension) {
      return MelodyNoteRole.stableTension;
    }
    return MelodyNoteRole.passing;
  }
}
