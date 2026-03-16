import 'dart:math';

import '../settings/practice_settings.dart';
import 'chord_timing_models.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';
import 'phrase_planner.dart';

class RhythmSlot {
  const RhythmSlot({
    required this.index,
    required this.startBeatOffset,
    required this.durationBeats,
    required this.metricStrength,
    required this.phrasePos01,
    required this.isStrong,
    required this.structural,
    this.anticipatory = false,
  });

  final int index;
  final double startBeatOffset;
  final double durationBeats;
  final double metricStrength;
  final double phrasePos01;
  final bool isStrong;
  final bool structural;
  final bool anticipatory;

  String get syncopationKey {
    final eighthIndex = (startBeatOffset * 2).round();
    return switch (eighthIndex % 8) {
      1 => '&1',
      3 => '&2',
      5 => '&3',
      7 => '&4',
      _ => '',
    };
  }
}

class RhythmTemplateSample {
  const RhythmTemplateSample({
    required this.templateId,
    required this.slots,
    required this.meanDurationBeats,
    required this.usedAnticipation,
  });

  final String templateId;
  final List<RhythmSlot> slots;
  final double meanDurationBeats;
  final bool usedAnticipation;

  List<double> get rhythmVector => [
    for (final slot in slots) slot.durationBeats,
  ];
}

class RhythmTemplateSampler {
  const RhythmTemplateSampler._();

  static const List<_WeightedRhythmTemplate> _guidedSparseTemplates = [
    _WeightedRhythmTemplate('g-sparse-1', <double>[0, 2], 0.22),
    _WeightedRhythmTemplate('g-sparse-2', <double>[0, 3], 0.18),
    _WeightedRhythmTemplate('g-sparse-3', <double>[0, 1, 3], 0.14),
    _WeightedRhythmTemplate('g-sparse-4', <double>[0, 2.5], 0.10),
    _WeightedRhythmTemplate('g-sparse-5', <double>[0, 2, 3], 0.18),
    _WeightedRhythmTemplate('g-sparse-6', <double>[0, 1.5, 3], 0.10),
    _WeightedRhythmTemplate('g-sparse-7', <double>[0, 1, 2.5], 0.08),
  ];

  static const List<_WeightedRhythmTemplate> _guidedBalancedTemplates = [
    _WeightedRhythmTemplate('g-bal-1', <double>[0, 1, 2, 3], 0.22),
    _WeightedRhythmTemplate('g-bal-2', <double>[0, 1, 3], 0.12),
    _WeightedRhythmTemplate('g-bal-3', <double>[0, 2, 3], 0.10),
    _WeightedRhythmTemplate('g-bal-4', <double>[0, 1.5, 3], 0.10),
    _WeightedRhythmTemplate('g-bal-5', <double>[0, 0.5, 2, 3], 0.08),
    _WeightedRhythmTemplate('g-bal-6', <double>[0, 1, 2.5, 3], 0.08),
    _WeightedRhythmTemplate('g-bal-7', <double>[0, 1, 2, 3.5], 0.08),
    _WeightedRhythmTemplate('g-bal-8', <double>[0, 1.5, 2.5, 3], 0.08),
    _WeightedRhythmTemplate('g-bal-9', <double>[0, 2, 3.5], 0.07),
    _WeightedRhythmTemplate('g-bal-10', <double>[0, 0.5, 1.5, 3], 0.07),
  ];

  static const List<_WeightedRhythmTemplate> _guidedActiveTemplates = [
    _WeightedRhythmTemplate('g-act-1', <double>[0, 1, 2, 3], 0.18),
    _WeightedRhythmTemplate('g-act-2', <double>[0, 0.5, 2, 3], 0.14),
    _WeightedRhythmTemplate('g-act-3', <double>[0, 1.5, 2.5, 3], 0.14),
    _WeightedRhythmTemplate('g-act-4', <double>[0, 1, 2.5, 3.5], 0.14),
    _WeightedRhythmTemplate('g-act-5', <double>[0, 0.5, 1.5, 3], 0.14),
    _WeightedRhythmTemplate('g-act-6', <double>[0, 1, 1.5, 3], 0.12),
    _WeightedRhythmTemplate('g-act-7', <double>[0, 1, 2, 3.5], 0.14),
  ];

  static const List<_WeightedRhythmTemplate> _standardBalancedTemplates = [
    _WeightedRhythmTemplate('s-bal-1', <double>[0, 1, 2, 3], 0.16),
    _WeightedRhythmTemplate('s-bal-2', <double>[0, 1, 2, 3.5], 0.11),
    _WeightedRhythmTemplate('s-bal-3', <double>[0, 1.5, 2.5, 3], 0.10),
    _WeightedRhythmTemplate('s-bal-4', <double>[0, 0.5, 2, 3], 0.08),
    _WeightedRhythmTemplate('s-bal-5', <double>[0, 1, 2.5, 3.5], 0.10),
    _WeightedRhythmTemplate('s-bal-6', <double>[0, 0.5, 1.5, 3], 0.08),
    _WeightedRhythmTemplate('s-bal-7', <double>[0, 1.5, 3], 0.07),
    _WeightedRhythmTemplate('s-bal-8', <double>[0, 1, 3.5], 0.07),
    _WeightedRhythmTemplate('s-bal-9', <double>[0, 2, 3.5], 0.07),
    _WeightedRhythmTemplate('s-bal-10', <double>[0, 1, 1.5, 3], 0.08),
    _WeightedRhythmTemplate('s-bal-11', <double>[0, 0.5, 2, 3.5], 0.08),
  ];

  static const List<_WeightedRhythmTemplate> _standardActiveTemplates = [
    _WeightedRhythmTemplate('s-act-1', <double>[0, 1, 1.5, 2.5, 3], 0.11),
    _WeightedRhythmTemplate('s-act-2', <double>[0, 0.5, 1.5, 2, 3], 0.10),
    _WeightedRhythmTemplate('s-act-3', <double>[0, 1, 2, 2.5, 3.5], 0.10),
    _WeightedRhythmTemplate('s-act-4', <double>[0, 0.5, 2, 3, 3.5], 0.09),
    _WeightedRhythmTemplate('s-act-5', <double>[0, 1, 1.5, 2, 3.5], 0.10),
    _WeightedRhythmTemplate('s-act-6', <double>[0, 0.5, 1, 2.5, 3], 0.09),
    _WeightedRhythmTemplate('s-act-7', <double>[0, 1, 2, 3, 3.5], 0.10),
    _WeightedRhythmTemplate('s-act-8', <double>[0, 0.5, 1.5, 2.5, 3], 0.09),
    _WeightedRhythmTemplate('s-act-9', <double>[0, 1.5, 2, 3, 3.5], 0.11),
    _WeightedRhythmTemplate('s-act-10', <double>[0, 1, 2, 2.5, 3], 0.11),
  ];

  static const List<_WeightedRhythmTemplate> _advancedBalancedTemplates = [
    _WeightedRhythmTemplate('a-bal-1', <double>[0, 1, 2, 3.5], 0.10),
    _WeightedRhythmTemplate('a-bal-2', <double>[0, 1.5, 2.5, 3], 0.10),
    _WeightedRhythmTemplate('a-bal-3', <double>[0, 0.5, 2, 3.5], 0.09),
    _WeightedRhythmTemplate('a-bal-4', <double>[0, 1, 2.5, 3.5], 0.10),
    _WeightedRhythmTemplate('a-bal-5', <double>[0, 0.5, 1.5, 3], 0.09),
    _WeightedRhythmTemplate('a-bal-6', <double>[0, 1, 1.5, 3.5], 0.08),
    _WeightedRhythmTemplate('a-bal-7', <double>[0, 1, 2, 3], 0.08),
    _WeightedRhythmTemplate('a-bal-8', <double>[0, 0.5, 1.5, 2.5, 3], 0.12),
    _WeightedRhythmTemplate('a-bal-9', <double>[0, 1, 2, 2.5, 3.5], 0.12),
    _WeightedRhythmTemplate('a-bal-10', <double>[0, 1.5, 2, 3.5], 0.12),
  ];

  static const List<_WeightedRhythmTemplate> _advancedActiveTemplates = [
    _WeightedRhythmTemplate('a-act-1', <double>[0, 1, 1.5, 2.5, 3, 3.5], 0.10),
    _WeightedRhythmTemplate('a-act-2', <double>[0, 0.5, 1.5, 2, 3, 3.5], 0.09),
    _WeightedRhythmTemplate('a-act-3', <double>[0, 1, 2, 2.5, 3, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-4', <double>[0, 0.5, 1, 2.5, 3, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-5', <double>[0, 1, 1.5, 2, 3, 3.5], 0.09),
    _WeightedRhythmTemplate('a-act-6', <double>[0, 0.5, 1.5, 2.5, 3], 0.07),
    _WeightedRhythmTemplate('a-act-7', <double>[0, 1, 2, 3, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-8', <double>[0, 0.5, 2, 3, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-9', <double>[0, 1.5, 2, 3, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-10', <double>[0, 0.5, 1, 2, 3.5], 0.07),
    _WeightedRhythmTemplate('a-act-11', <double>[0, 1, 2, 2.5, 3.5], 0.08),
    _WeightedRhythmTemplate('a-act-12', <double>[0, 0.5, 1.5, 2, 3], 0.08),
  ];

  static RhythmTemplateSample sample({
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required MelodyDensity density,
    required MelodyStyle style,
    required Random random,
  }) {
    final timing = request.chordEvent.timing;
    final templates = _templatesFor(
      mode: request.settings.settingsComplexityMode,
      density: density,
    );
    final targetOffbeatRatio = _targetOffbeatOnsetRatio(
      request: request,
      phrasePlan: phrasePlan,
      density: density,
    );
    final picked = _pickTemplate(
      templates,
      request: request,
      phrasePlan: phrasePlan,
      density: density,
      style: style,
      targetOffbeatRatio: targetOffbeatRatio,
      random: random,
    );
    final offsets = _normalizeOffsets(
      picked.offsets,
      durationBeats: timing.durationBeats.toDouble(),
    ).toList(growable: true);
    _maybeEnhanceSyncopation(
      offsets,
      request: request,
      phrasePlan: phrasePlan,
      density: density,
      style: style,
      targetOffbeatRatio: targetOffbeatRatio,
      random: random,
    );
    final usedAnticipation = _maybeApplyAnticipation(
      offsets,
      request: request,
      phrasePlan: phrasePlan,
      random: random,
    );
    _applyCadentialHold(
      offsets,
      request: request,
      phrasePlan: phrasePlan,
      random: random,
    );
    _rebalanceOffbeatDistribution(
      offsets,
      request: request,
      phrasePlan: phrasePlan,
      density: density,
      targetOffbeatRatio: targetOffbeatRatio,
      random: random,
    );
    offsets.sort();
    final slots = <RhythmSlot>[];
    final totalDuration = timing.durationBeats.toDouble();
    for (var index = 0; index < offsets.length; index += 1) {
      final start = offsets[index];
      final nextStart = index + 1 < offsets.length
          ? offsets[index + 1]
          : totalDuration;
      final durationBeats = max(0.25, nextStart - start);
      final localPos01 = totalDuration <= 0
          ? 0.0
          : (start / totalDuration).clamp(0.0, 1.0);
      final phraseSpan01 =
          (phrasePlan.eventEndPos01 - phrasePlan.eventStartPos01).clamp(
            0.0,
            1.0,
          );
      final phrasePos01 =
          phrasePlan.eventStartPos01 + (localPos01 * phraseSpan01);
      final metricStrength = _metricStrength(
        timing: timing,
        startBeatOffset: start,
      );
      final isStrong = metricStrength >= 0.58;
      slots.add(
        RhythmSlot(
          index: index,
          startBeatOffset: start,
          durationBeats: durationBeats,
          metricStrength: metricStrength,
          phrasePos01: phrasePos01,
          isStrong: isStrong,
          structural: index == 0 || index == offsets.length - 1 || isStrong,
          anticipatory:
              usedAnticipation && index == offsets.length - 1 && start % 1 != 0,
        ),
      );
    }
    final meanDuration = slots.isEmpty
        ? totalDuration
        : slots.fold<double>(0, (sum, slot) => sum + slot.durationBeats) /
              slots.length;
    return RhythmTemplateSample(
      templateId: picked.id,
      slots: slots,
      meanDurationBeats: meanDuration,
      usedAnticipation: usedAnticipation,
    );
  }

  static List<_WeightedRhythmTemplate> _templatesFor({
    required SettingsComplexityMode mode,
    required MelodyDensity density,
  }) {
    return switch ((mode, density)) {
      (SettingsComplexityMode.guided, MelodyDensity.sparse) =>
        _guidedSparseTemplates,
      (SettingsComplexityMode.guided, MelodyDensity.active) =>
        _guidedActiveTemplates,
      (SettingsComplexityMode.guided, MelodyDensity.balanced) =>
        _guidedBalancedTemplates,
      (SettingsComplexityMode.standard, MelodyDensity.active) =>
        _standardActiveTemplates,
      (SettingsComplexityMode.standard, MelodyDensity.sparse) =>
        _standardBalancedTemplates,
      (SettingsComplexityMode.standard, MelodyDensity.balanced) =>
        _standardBalancedTemplates,
      (SettingsComplexityMode.advanced, MelodyDensity.active) =>
        _advancedActiveTemplates,
      (SettingsComplexityMode.advanced, MelodyDensity.sparse) =>
        _advancedBalancedTemplates,
      (SettingsComplexityMode.advanced, MelodyDensity.balanced) =>
        _advancedBalancedTemplates,
    };
  }

  static _WeightedRhythmTemplate _pickTemplate(
    List<_WeightedRhythmTemplate> templates, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required MelodyDensity density,
    required MelodyStyle style,
    required double targetOffbeatRatio,
    required Random random,
  }) {
    final weighted = <_WeightedRhythmTemplate>[];
    var totalWeight = 0.0;
    for (final template in templates) {
      var weight = template.weight;
      final offbeatRatio = _offbeatRatioOfOffsets(template.offsets);
      final lastOffset = template.offsets.isEmpty ? 0.0 : template.offsets.last;
      final containsTwoAnd = _hasOffset(template.offsets, 1.5);
      final containsFourAnd = _hasOffset(template.offsets, 3.5);
      weight += max(
        0.0,
        0.22 - ((offbeatRatio - targetOffbeatRatio).abs() * 0.65),
      );
      weight += switch (phrasePlan.role) {
        PhraseRole.opening => template.offsets.length <= 4 ? 0.07 : -0.04,
        PhraseRole.continuation => containsTwoAnd ? 0.06 : 0.0,
        PhraseRole.preCadence =>
          containsFourAnd
              ? _modeWeightedSyncBonus(
                  request.settings.settingsComplexityMode,
                  fourAnd: true,
                )
              : (containsTwoAnd ? 0.05 : -0.03),
        PhraseRole.cadence => lastOffset <= 2.5 ? 0.14 : -0.12,
      };
      if (phrasePlan.role == PhraseRole.cadence && containsFourAnd) {
        weight -= 0.16;
      }
      if (phrasePlan.role == PhraseRole.preCadence && lastOffset >= 3.0) {
        weight += 0.08;
      }
      if (style == MelodyStyle.lyrical && template.offsets.length <= 4) {
        weight += 0.08;
      }
      if (style == MelodyStyle.safe &&
          offbeatRatio > (targetOffbeatRatio + 0.08)) {
        weight -= 0.12;
      }
      if ((style == MelodyStyle.bebop || style == MelodyStyle.colorful) &&
          (containsTwoAnd || containsFourAnd)) {
        weight += 0.05;
      }
      if (density == MelodyDensity.sparse && template.offsets.length > 4) {
        weight -= 0.12;
      }
      if (density == MelodyDensity.active && template.offsets.length >= 5) {
        weight += 0.04;
      }
      weighted.add(
        _WeightedRhythmTemplate(template.id, template.offsets, weight),
      );
      totalWeight += max(0.001, weight);
    }
    final roll = random.nextDouble() * max(totalWeight, 0.0001);
    var cursor = 0.0;
    for (final template in weighted) {
      cursor += max(0.001, template.weight);
      if (roll <= cursor) {
        return template;
      }
    }
    return weighted.last;
  }

  static List<double> _normalizeOffsets(
    List<double> offsets, {
    required double durationBeats,
  }) {
    final normalized = <double>{
      for (final offset in offsets)
        if (offset >= 0 && offset < durationBeats)
          ((offset * 2).roundToDouble() / 2.0),
      0,
    }.toList(growable: true)..sort();
    return normalized;
  }

  static double _targetOffbeatOnsetRatio({
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required MelodyDensity density,
  }) {
    final mode = request.settings.settingsComplexityMode;
    var target = switch ((mode, density)) {
      (SettingsComplexityMode.guided, MelodyDensity.sparse) => 0.12,
      (SettingsComplexityMode.guided, MelodyDensity.balanced) => 0.18,
      (SettingsComplexityMode.guided, MelodyDensity.active) => 0.22,
      (SettingsComplexityMode.standard, MelodyDensity.sparse) => 0.18,
      (SettingsComplexityMode.standard, MelodyDensity.balanced) => 0.28,
      (SettingsComplexityMode.standard, MelodyDensity.active) => 0.34,
      (SettingsComplexityMode.advanced, MelodyDensity.sparse) => 0.22,
      (SettingsComplexityMode.advanced, MelodyDensity.balanced) => 0.32,
      (SettingsComplexityMode.advanced, MelodyDensity.active) => 0.40,
    };
    target += (request.settings.syncopationBias - 0.5) * 0.08;
    target += switch (phrasePlan.role) {
      PhraseRole.opening => -0.04,
      PhraseRole.continuation => 0.00,
      PhraseRole.preCadence => 0.05,
      PhraseRole.cadence => -0.10,
    };
    return target.clamp(0.08, 0.48).toDouble();
  }

  static void _maybeEnhanceSyncopation(
    List<double> offsets, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required MelodyDensity density,
    required MelodyStyle style,
    required double targetOffbeatRatio,
    required Random random,
  }) {
    if (request.chordEvent.timing.beatsPerBar != 4 || offsets.length < 2) {
      return;
    }
    final currentRatio = _offbeatRatioOfOffsets(offsets);
    var probability = switch (request.settings.settingsComplexityMode) {
      SettingsComplexityMode.guided => 0.10,
      SettingsComplexityMode.standard => 0.22,
      SettingsComplexityMode.advanced => 0.34,
    };
    probability += switch (density) {
      MelodyDensity.sparse => -0.04,
      MelodyDensity.balanced => 0.00,
      MelodyDensity.active => 0.08,
    };
    probability += switch (phrasePlan.role) {
      PhraseRole.opening => -0.08,
      PhraseRole.continuation => 0.02,
      PhraseRole.preCadence => 0.10,
      PhraseRole.cadence => -0.14,
    };
    if (style == MelodyStyle.safe) {
      probability -= 0.06;
    } else if (style == MelodyStyle.bebop || style == MelodyStyle.colorful) {
      probability += 0.04;
    }
    if (currentRatio >= targetOffbeatRatio + 0.08) {
      probability -= 0.16;
    }
    probability = probability.clamp(0.0, 0.65).toDouble();
    if (random.nextDouble() >= probability) {
      return;
    }
    _injectPreferredSyncopation(
      offsets,
      request: request,
      phrasePlan: phrasePlan,
    );
  }

  static bool _injectPreferredSyncopation(
    List<double> offsets, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
  }) {
    final candidates =
        <double>[
          1.5,
          if (phrasePlan.role != PhraseRole.opening) 3.5,
          2.5,
          if (request.settings.settingsComplexityMode !=
              SettingsComplexityMode.guided)
            0.5,
        ]..sort(
          (left, right) =>
              _offbeatRetentionScore(
                right,
                request: request,
                phrasePlan: phrasePlan,
              ).compareTo(
                _offbeatRetentionScore(
                  left,
                  request: request,
                  phrasePlan: phrasePlan,
                ),
              ),
        );
    for (final target in candidates) {
      if (_hasOffset(offsets, target)) {
        continue;
      }
      final sourceIndex = _sourceIndexForSyncopation(offsets, target);
      if (sourceIndex == null || sourceIndex <= 0) {
        continue;
      }
      final previous = offsets[sourceIndex - 1];
      final next = sourceIndex + 1 < offsets.length
          ? offsets[sourceIndex + 1]
          : request.chordEvent.timing.durationBeats.toDouble();
      if (target <= previous || target >= next) {
        continue;
      }
      offsets[sourceIndex] = target;
      offsets.sort();
      return true;
    }
    return false;
  }

  static bool _maybeApplyAnticipation(
    List<double> offsets, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required Random random,
  }) {
    if (offsets.isEmpty || request.nextChordEvent == null) {
      return false;
    }
    final base = max(
      request.settings.anticipationProbability,
      MelodyGenerationConfig.profileFor(
        request.settings.settingsComplexityMode,
      ).anticipationProbability,
    );
    final lastOffset = offsets.last;
    final currentStrength = _metricStrength(
      timing: request.chordEvent.timing,
      startBeatOffset: lastOffset,
    );
    final nextStrength = _metricStrength(
      timing: request.chordEvent.timing,
      startBeatOffset: request.chordEvent.timing.durationBeats.toDouble(),
    );
    var probability =
        base +
        (nextStrength > currentStrength ? 0.10 : 0.0) +
        0.08 -
        (phrasePlan.role == PhraseRole.cadence ? 0.10 : 0.0);
    if (request.chordEvent.timing.beatsPerBar == 4) {
      probability += phrasePlan.role == PhraseRole.preCadence ? 0.10 : 0.0;
      probability += request.nextChordEvent != null ? 0.08 : 0.0;
      probability -= _hasOffset(offsets, 3.5) ? 0.12 : 0.0;
    }
    probability *= 0.34 + (request.settings.syncopationBias * 0.42);
    probability = probability.clamp(0.0, 0.60).toDouble();
    if (random.nextDouble() >= probability) {
      return false;
    }
    final targetOffset = request.chordEvent.timing.beatsPerBar == 4
        ? 3.5
        : max(0.5, request.chordEvent.timing.durationBeats - 0.5).toDouble();
    final replacementIndex = offsets.length - 1;
    final previous = replacementIndex > 0 ? offsets[replacementIndex - 1] : 0.0;
    if (targetOffset > previous) {
      offsets[replacementIndex] = targetOffset.toDouble();
      offsets.sort();
    }
    return true;
  }

  static void _applyCadentialHold(
    List<double> offsets, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required Random random,
  }) {
    if (offsets.length <= 1) {
      return;
    }
    if (phrasePlan.role == PhraseRole.preCadence &&
        request.nextChordEvent != null) {
      final target =
          request.settings.settingsComplexityMode ==
              SettingsComplexityMode.guided
          ? 3.0
          : 3.5;
      final replacementIndex = offsets.length - 1;
      final previous = replacementIndex > 0
          ? offsets[replacementIndex - 1]
          : 0.0;
      if (target > previous) {
        offsets[replacementIndex] = target;
        offsets.sort();
      }
      return;
    }
    final isPhraseEnd =
        phrasePlan.role == PhraseRole.cadence || request.nextChordEvent == null;
    if (!isPhraseEnd) {
      return;
    }
    final totalDuration = request.chordEvent.timing.durationBeats.toDouble();
    if (offsets.length < 3) {
      final inserted = min(1.0, max(0.5, totalDuration - 2.5));
      if (!_hasOffset(offsets, inserted) &&
          inserted > 0 &&
          inserted < totalDuration - 0.5) {
        offsets.insert(max(1, offsets.length - 1), inserted);
      }
    }
    _compressCadentialTexture(offsets, request: request);
    while (offsets.length > 2 && offsets[offsets.length - 2] > 1.0) {
      offsets.removeAt(offsets.length - 2);
    }
    for (final candidate in const <double>[0.5, 1.0, 1.5]) {
      if (offsets.length >= 3) {
        break;
      }
      if (_hasOffset(offsets, candidate) ||
          candidate <= 0 ||
          candidate >= totalDuration - 0.5) {
        continue;
      }
      offsets.insert(max(1, offsets.length - 1), candidate);
    }
    final mean = totalDuration / offsets.length;
    final desiredFinalDuration = max(
      totalDuration * 0.60,
      (mean * phrasePlan.cadenceHoldMultiplier).clamp(0.75, totalDuration),
    );
    final desiredLastStart = max(0.0, totalDuration - desiredFinalDuration);
    final previousStart = offsets.length > 1
        ? offsets[offsets.length - 2]
        : 0.0;
    final cappedLastStart = switch (request.settings.settingsComplexityMode) {
      SettingsComplexityMode.guided => desiredLastStart.clamp(1.25, 1.55),
      SettingsComplexityMode.standard => desiredLastStart.clamp(1.25, 1.60),
      SettingsComplexityMode.advanced => desiredLastStart.clamp(1.35, 1.75),
    };
    offsets[offsets.length - 1] = max(previousStart + 0.5, cappedLastStart);
    offsets.sort();
  }

  static void _rebalanceOffbeatDistribution(
    List<double> offsets, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
    required MelodyDensity density,
    required double targetOffbeatRatio,
    required Random random,
  }) {
    if (request.chordEvent.timing.beatsPerBar != 4 || offsets.length <= 1) {
      return;
    }
    final mode = request.settings.settingsComplexityMode;
    final highMargin = switch (mode) {
      SettingsComplexityMode.guided => 0.04,
      SettingsComplexityMode.standard => 0.06,
      SettingsComplexityMode.advanced => 0.08,
    };
    while (_offbeatRatioOfOffsets(offsets) > targetOffbeatRatio + highMargin) {
      final offbeatIndexes = <int>[
        for (var index = 1; index < offsets.length; index += 1)
          if (_isOffbeat(offsets[index])) index,
      ];
      if (offbeatIndexes.isEmpty) {
        break;
      }
      offbeatIndexes.sort(
        (left, right) =>
            _offbeatRetentionScore(
              offsets[left],
              request: request,
              phrasePlan: phrasePlan,
            ).compareTo(
              _offbeatRetentionScore(
                offsets[right],
                request: request,
                phrasePlan: phrasePlan,
              ),
            ),
      );
      final index = offbeatIndexes.first;
      final snapped = _nearestOnbeat(offsets[index]);
      final previous = offsets[index - 1];
      final next = index + 1 < offsets.length
          ? offsets[index + 1]
          : request.chordEvent.timing.durationBeats.toDouble();
      if (!_hasOffset(offsets, snapped) &&
          snapped > previous &&
          snapped < next) {
        offsets[index] = snapped;
      } else if (offsets.length > 2) {
        offsets.removeAt(index);
      } else {
        break;
      }
      offsets.sort();
    }
    final lowMargin = switch (mode) {
      SettingsComplexityMode.guided => 0.08,
      SettingsComplexityMode.standard => 0.06,
      SettingsComplexityMode.advanced => 0.06,
    };
    if (_offbeatRatioOfOffsets(offsets) < targetOffbeatRatio - lowMargin &&
        phrasePlan.role != PhraseRole.cadence) {
      while (_offbeatRatioOfOffsets(offsets) < targetOffbeatRatio - lowMargin) {
        final changed = _injectPreferredSyncopation(
          offsets,
          request: request,
          phrasePlan: phrasePlan,
        );
        if (!changed) {
          break;
        }
      }
    }
  }

  static void _compressCadentialTexture(
    List<double> offsets, {
    required MelodyGenerationRequest request,
  }) {
    offsets.removeWhere(
      (offset) =>
          _isOffbeat(offset) &&
          offset >= 2.5 &&
          offset < request.chordEvent.timing.durationBeats.toDouble(),
    );
    final maxSlots = switch (request.settings.settingsComplexityMode) {
      SettingsComplexityMode.guided => 3,
      SettingsComplexityMode.standard => 3,
      SettingsComplexityMode.advanced => 3,
    };
    while (offsets.length > maxSlots) {
      offsets.removeAt(offsets.length - 2);
    }
    offsets.sort();
  }

  static double _metricStrength({
    required ChordTimingSpec timing,
    required double startBeatOffset,
  }) {
    if (timing.beatsPerBar == 4) {
      final eighth = ((startBeatOffset * 2).round()) % 8;
      final base = MelodyGenerationConfig.metricStrength4_4_8[eighth];
      if (eighth == 3) {
        return base + 0.04;
      }
      if (eighth == 7) {
        return base + 0.06;
      }
      return base;
    }
    final beat =
        (timing.changeBeat + startBeatOffset.floor()) % timing.beatsPerBar;
    final structuralBeats = switch (timing.beatsPerBar) {
      12 => const <int>[0, 3, 6, 9],
      7 => const <int>[0, 4],
      6 => const <int>[0, 3],
      5 => const <int>[0, 3],
      3 => const <int>[0],
      2 => const <int>[0],
      _ => const <int>[0, 2],
    };
    if (beat == 0) {
      return 1.0;
    }
    if (structuralBeats.contains(beat)) {
      return 0.72;
    }
    return startBeatOffset % 1 == 0 ? 0.48 : 0.30;
  }

  static double _offbeatRatioOfOffsets(List<double> offsets) {
    if (offsets.isEmpty) {
      return 0.0;
    }
    final count = offsets.where(_isOffbeat).length;
    return count / offsets.length;
  }

  static bool _isOffbeat(double offset) {
    return offset % 1 != 0;
  }

  static bool _hasOffset(List<double> offsets, double target) {
    return offsets.any((offset) => _gridKey(offset) == _gridKey(target));
  }

  static int _gridKey(double offset) {
    return (offset * 2).round();
  }

  static int? _sourceIndexForSyncopation(List<double> offsets, double target) {
    final desiredSource = switch (_gridKey(target)) {
      1 => 1.0,
      3 => 2.0,
      5 => 3.0,
      7 => 3.0,
      _ => null,
    };
    if (desiredSource == null) {
      return null;
    }
    for (var index = 1; index < offsets.length; index += 1) {
      if (_gridKey(offsets[index]) == _gridKey(desiredSource)) {
        return index;
      }
    }
    return null;
  }

  static double _nearestOnbeat(double offset) {
    final floor = offset.floorToDouble();
    final ceil = offset.ceilToDouble();
    return (offset - floor).abs() <= (ceil - offset).abs() ? floor : ceil;
  }

  static double _offbeatRetentionScore(
    double offset, {
    required MelodyGenerationRequest request,
    required PhrasePlan phrasePlan,
  }) {
    var score = switch (_gridKey(offset)) {
      1 => 0.22,
      3 => 0.54,
      5 => 0.30,
      7 => 0.62,
      _ => 0.10,
    };
    score += switch (phrasePlan.role) {
      PhraseRole.opening => -0.05,
      PhraseRole.continuation => _gridKey(offset) == 3 ? 0.08 : 0.0,
      PhraseRole.preCadence => switch (_gridKey(offset)) {
        3 => 0.12,
        7 => 0.24,
        _ => 0.02,
      },
      PhraseRole.cadence => -0.18,
    };
    score += switch (request.settings.settingsComplexityMode) {
      SettingsComplexityMode.guided => -0.06,
      SettingsComplexityMode.standard => 0.0,
      SettingsComplexityMode.advanced => switch (_gridKey(offset)) {
        3 || 7 => 0.08,
        _ => 0.02,
      },
    };
    return score;
  }

  static double _modeWeightedSyncBonus(
    SettingsComplexityMode mode, {
    required bool fourAnd,
  }) {
    return switch (mode) {
      SettingsComplexityMode.guided => fourAnd ? 0.10 : 0.05,
      SettingsComplexityMode.standard => fourAnd ? 0.16 : 0.07,
      SettingsComplexityMode.advanced => fourAnd ? 0.22 : 0.10,
    };
  }
}

class _WeightedRhythmTemplate {
  const _WeightedRhythmTemplate(this.id, this.offsets, this.weight);

  final String id;
  final List<double> offsets;
  final double weight;
}
