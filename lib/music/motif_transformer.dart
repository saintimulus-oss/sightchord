import 'dart:math';

import '../settings/practice_settings.dart';
import 'melody_generation_config.dart';
import 'melody_models.dart';
import 'phrase_planner.dart';
import 'rhythm_template_sampler.dart';

class MotifMemory {
  const MotifMemory({
    required this.intervalVector,
    required this.rhythmVector,
    required this.toneLabels,
    required this.contourSigns,
    required this.eventSignature,
    required this.intervalSignature,
    required this.zeroIntervalCount,
    this.anchorToneLabel,
    this.terminalToneLabel,
  });

  final List<int> intervalVector;
  final List<double> rhythmVector;
  final List<String?> toneLabels;
  final List<int> contourSigns;
  final String eventSignature;
  final String intervalSignature;
  final int zeroIntervalCount;
  final String? anchorToneLabel;
  final String? terminalToneLabel;

  bool get isMonotoneContour =>
      contourSigns.where((sign) => sign != 0).toSet().length <= 1;
}

class MotifTransformPlan {
  const MotifTransformPlan({
    required this.transformName,
    required this.memory,
    required this.usesPreviousMaterial,
    required this.signature,
    this.sourceDistance,
    this.sourceEventSignature,
  });

  final String transformName;
  final MotifMemory memory;
  final bool usesPreviousMaterial;
  final String signature;
  final int? sourceDistance;
  final String? sourceEventSignature;

  List<int> get contourSignature => memory.intervalVector;
}

class MotifTransformer {
  const MotifTransformer._();

  static const List<String> _defaultTonePalette = <String>[
    '1',
    '3',
    '5',
    '7',
    '9',
    '11',
    '#11',
    '13',
    'b3',
    'b7',
    'b9',
    '#9',
    'b13',
    '4',
    'b5',
  ];

  static MotifTransformPlan plan({
    required GeneratedMelodyEvent? previousEvent,
    required List<GeneratedMelodyEvent> recentEvents,
    required RhythmTemplateSample rhythm,
    required PracticeSettings settings,
    required MelodyStyle style,
    required PhrasePlan phrasePlan,
    required Random random,
  }) {
    final targetLength = _maxInt(0, rhythm.slots.length - 1);
    final sources = _collectSources(
      previousEvent: previousEvent,
      recentEvents: recentEvents,
    );
    final computedReuseChance =
        settings.motifRepetitionStrength +
        (settings.motifVariationBias * 0.22) +
        (settings.noveltyTarget * 0.10);
    final reuseChance = settings.motifRepetitionStrength >= 0.95
        ? 0.95
        : computedReuseChance.clamp(0.28, 0.62);
    if (sources.isEmpty || random.nextDouble() > reuseChance) {
      final fresh = _freshMemory(
        targetLength: targetLength,
        rhythm: rhythm,
        style: style,
        phrasePlan: phrasePlan,
        random: random,
      );
      return MotifTransformPlan(
        transformName: 'fresh',
        memory: fresh,
        usesPreviousMaterial: false,
        signature:
            'fresh:${fresh.intervalSignature}:${fresh.rhythmVector.map((value) => value.toStringAsFixed(2)).join(",")}',
      );
    }

    final source = _pickSource(sources, random);
    var transform = _pickTransform(
      settings.settingsComplexityMode,
      settings.motifVariationBias,
      source.memory,
      recentEvents,
      phrasePlan,
      random,
    );
    if (transform == 'exact' &&
        recentEvents.isNotEmpty &&
        recentEvents.last.intervalSignatureKey ==
            source.memory.intervalSignature) {
      transform = phrasePlan.isCadential ? 'tailChange' : 'rhythmVar';
    }
    final transformed = _applyTransform(
      transform,
      source.memory,
      targetLength: targetLength,
      rhythm: rhythm,
      phrasePlan: phrasePlan,
      random: random,
    );
    return MotifTransformPlan(
      transformName: transform,
      memory: transformed,
      usesPreviousMaterial: true,
      sourceDistance: source.distance,
      sourceEventSignature: source.memory.eventSignature,
      signature:
          '$transform@d${source.distance}:${transformed.intervalSignature}:${transformed.rhythmVector.map((value) => value.toStringAsFixed(2)).join(",")}',
    );
  }

  static MotifMemory fromEvent(GeneratedMelodyEvent event) {
    final intervals = <int>[];
    for (var index = 1; index < event.notes.length; index += 1) {
      intervals.add(
        event.notes[index].midiNote - event.notes[index - 1].midiNote,
      );
    }
    final contourSigns = <int>[
      for (final interval in intervals) interval == 0 ? 0 : interval.sign,
    ];
    return MotifMemory(
      intervalVector: intervals,
      rhythmVector: [for (final note in event.notes) note.durationBeats],
      toneLabels: [for (final note in event.notes) note.toneLabel],
      contourSigns: contourSigns,
      eventSignature: event.eventSignatureKey,
      intervalSignature: intervals.join(','),
      zeroIntervalCount: intervals.where((interval) => interval == 0).length,
      anchorToneLabel: event.firstNote?.toneLabel,
      terminalToneLabel: event.lastNote?.toneLabel,
    );
  }

  static List<_MotifSource> _collectSources({
    required GeneratedMelodyEvent? previousEvent,
    required List<GeneratedMelodyEvent> recentEvents,
  }) {
    final sources = <_MotifSource>[];
    final seen = <int>{};
    final candidates = <GeneratedMelodyEvent>[
      ...recentEvents,
      if (previousEvent != null) previousEvent,
    ];
    for (var index = 0; index < candidates.length; index += 1) {
      final event = candidates[index];
      if (event.notes.length < 2 || seen.contains(event.signatureHash)) {
        continue;
      }
      seen.add(event.signatureHash);
      final distance = _maxInt(1, candidates.length - index);
      sources.add(_MotifSource(memory: fromEvent(event), distance: distance));
    }
    return sources;
  }

  static _MotifSource _pickSource(List<_MotifSource> sources, Random random) {
    var total = 0.0;
    final weights = <double>[];
    for (final source in sources) {
      var weight = switch (source.distance) {
        1 => 1.45,
        2 => 1.18,
        3 => 0.96,
        _ => 0.82,
      };
      if (!source.memory.isMonotoneContour) {
        weight += 0.24;
      }
      if (source.memory.intervalVector.any((interval) => interval.abs() >= 2)) {
        weight += 0.12;
      }
      if (source.memory.zeroIntervalCount >
          source.memory.intervalVector.length ~/ 2) {
        weight -= 0.14;
      }
      final safeWeight = max(0.05, weight);
      weights.add(safeWeight);
      total += safeWeight;
    }
    final roll = random.nextDouble() * max(total, 0.0001);
    var cursor = 0.0;
    for (var index = 0; index < sources.length; index += 1) {
      cursor += weights[index];
      if (roll <= cursor) {
        return sources[index];
      }
    }
    return sources.last;
  }

  static String _pickTransform(
    SettingsComplexityMode mode,
    double variationBias,
    MotifMemory sourceMemory,
    List<GeneratedMelodyEvent> recentEvents,
    PhrasePlan phrasePlan,
    Random random,
  ) {
    final base = Map<String, double>.from(
      MelodyGenerationConfig.motifTransformProb[mode] ??
          MelodyGenerationConfig.motifTransformProb[SettingsComplexityMode
              .guided]!,
    );
    base.putIfAbsent('sequence', () => 0.10 + (variationBias * 0.02));
    base.putIfAbsent('inversionLite', () => 0.06 + (variationBias * 0.02));
    final recentVectorRepeats = recentEvents
        .where(
          (event) =>
              event.intervalSignatureKey == sourceMemory.intervalSignature,
        )
        .length;
    final exactReduction =
        (variationBias * 0.08) +
        (recentVectorRepeats * 0.05) +
        (sourceMemory.isMonotoneContour ? 0.06 : 0.0);
    base.update('exact', (value) => max(0.02, value - exactReduction));
    base.update(
      'tailChange',
      (value) => value + 0.04 + (phrasePlan.isCadential ? 0.04 : 0.0),
      ifAbsent: () => 0.10,
    );
    base.update(
      'rhythmVar',
      (value) => value + 0.04 + (variationBias * 0.04),
      ifAbsent: () => 0.12,
    );
    base.update(
      'sequence',
      (value) => value + 0.03 + (variationBias * 0.03),
      ifAbsent: () => 0.10,
    );
    base.update(
      'transpose',
      (value) => value + (sourceMemory.isMonotoneContour ? 0.04 : 0.0),
      ifAbsent: () => 0.12,
    );
    var total = 0.0;
    for (final value in base.values) {
      total += value;
    }
    final roll = random.nextDouble() * max(total, 0.0001);
    var cursor = 0.0;
    for (final entry in base.entries) {
      cursor += entry.value;
      if (roll <= cursor) {
        return entry.key;
      }
    }
    return base.keys.last;
  }

  static MotifMemory _applyTransform(
    String transform,
    MotifMemory source, {
    required int targetLength,
    required RhythmTemplateSample rhythm,
    required PhrasePlan phrasePlan,
    required Random random,
  }) {
    final baseIntervals = _fitLength(source.intervalVector, targetLength);
    final baseTones = _fitToneLength(source.toneLabels, targetLength + 1);
    final baseRhythm = _fitRhythmLength(
      source.rhythmVector,
      rhythm.slots.length,
    );
    final intervals = switch (transform) {
      'exact' => List<int>.from(baseIntervals, growable: false),
      'transpose' => _transpose(baseIntervals, random),
      'tailChange' => _tailChange(baseIntervals, phrasePlan, random),
      'rhythmVar' => _rhythmDrivenIntervals(baseIntervals, rhythm, random),
      'truncateExtend' => _truncateExtend(
        baseIntervals,
        targetLength,
        phrasePlan,
        random,
      ),
      'sequence' => _sequence(baseIntervals, phrasePlan, random),
      'inversionLite' => _inversionLite(baseIntervals, phrasePlan, random),
      _ => List<int>.from(baseIntervals, growable: false),
    };
    final toneLabels = switch (transform) {
      'transpose' => _shiftToneLabels(baseTones, random.nextBool() ? 1 : -1),
      'tailChange' => _tailToneLabels(baseTones, random),
      'rhythmVar' => _rhythmToneLabels(baseTones, rhythm, random),
      'truncateExtend' => _truncateToneLabels(
        baseTones,
        targetLength + 1,
        random,
      ),
      'sequence' => _sequenceToneLabels(baseTones, random),
      'inversionLite' => _inversionToneLabels(baseTones, random),
      _ => List<String?>.from(baseTones, growable: false),
    };
    final rhythmVector = switch (transform) {
      'exact' => baseRhythm,
      'rhythmVar' => _varyRhythmVector(baseRhythm, rhythm),
      'truncateExtend' => _truncateRhythmVector(baseRhythm, rhythm),
      'sequence' => _sequenceRhythmVector(baseRhythm, rhythm),
      _ => rhythm.rhythmVector,
    };
    return _buildMemory(
      intervalVector: intervals,
      rhythmVector: rhythmVector,
      toneLabels: toneLabels,
    );
  }

  static MotifMemory _freshMemory({
    required int targetLength,
    required RhythmTemplateSample rhythm,
    required MelodyStyle style,
    required PhrasePlan phrasePlan,
    required Random random,
  }) {
    final libraries = switch (style) {
      MelodyStyle.safe => const <List<int>>[
        <int>[1, -1],
        <int>[1, 0, -1],
        <int>[0, 1, -1],
        <int>[-1, 1],
      ],
      MelodyStyle.bebop => const <List<int>>[
        <int>[1, 1, -1, -1],
        <int>[2, -1, 1, -1],
        <int>[1, -1, 2, -2],
      ],
      MelodyStyle.lyrical => const <List<int>>[
        <int>[1, 0, -1],
        <int>[1, -1],
        <int>[0, 1, 0, -1],
      ],
      MelodyStyle.colorful => const <List<int>>[
        <int>[1, 2, -1, -1],
        <int>[2, -1, 1, -2],
        <int>[-1, 2, -1, 1],
      ],
    };
    final selected = libraries[random.nextInt(libraries.length)];
    final intervals = _fitLength(selected, targetLength);
    final adjusted = <int>[];
    for (var index = 0; index < intervals.length; index += 1) {
      final interval = intervals[index];
      if (phrasePlan.role == PhraseRole.preCadence &&
          index == intervals.length - 1 &&
          interval > 0) {
        adjusted.add(-interval.abs());
      } else {
        adjusted.add(interval);
      }
    }
    return _buildMemory(
      intervalVector: _ensureExpressiveContour(
        adjusted,
        phrasePlan: phrasePlan,
        random: random,
      ),
      rhythmVector: rhythm.rhythmVector,
      toneLabels: List<String?>.filled(rhythm.slots.length, null),
    );
  }

  static MotifMemory _buildMemory({
    required List<int> intervalVector,
    required List<double> rhythmVector,
    required List<String?> toneLabels,
  }) {
    final contourSigns = <int>[
      for (final interval in intervalVector) interval == 0 ? 0 : interval.sign,
    ];
    return MotifMemory(
      intervalVector: intervalVector,
      rhythmVector: rhythmVector,
      toneLabels: toneLabels,
      contourSigns: contourSigns,
      eventSignature:
          '${intervalVector.join(",")}:${rhythmVector.map((value) => value.toStringAsFixed(2)).join(",")}:${toneLabels.join(",")}',
      intervalSignature: intervalVector.join(','),
      zeroIntervalCount: intervalVector
          .where((interval) => interval == 0)
          .length,
      anchorToneLabel: toneLabels.isEmpty ? null : toneLabels.first,
      terminalToneLabel: toneLabels.isEmpty ? null : toneLabels.last,
    );
  }

  static List<int> _fitLength(List<int> source, int targetLength) {
    if (targetLength <= 0) {
      return const <int>[];
    }
    if (source.isEmpty) {
      return List<int>.filled(targetLength, 0, growable: false);
    }
    return List<int>.generate(
      targetLength,
      (index) => source[index % source.length],
      growable: false,
    );
  }

  static List<String?> _fitToneLength(List<String?> source, int targetLength) {
    if (targetLength <= 0) {
      return const <String?>[];
    }
    if (source.isEmpty) {
      return List<String?>.filled(targetLength, null, growable: false);
    }
    return List<String?>.generate(
      targetLength,
      (index) => source[index % source.length],
      growable: false,
    );
  }

  static List<double> _fitRhythmLength(List<double> source, int targetLength) {
    if (targetLength <= 0) {
      return const <double>[];
    }
    if (source.isEmpty) {
      return List<double>.filled(targetLength, 1.0, growable: false);
    }
    return List<double>.generate(
      targetLength,
      (index) => source[index % source.length],
      growable: false,
    );
  }

  static List<int> _transpose(List<int> intervals, Random random) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final lift = random.nextBool() ? 1 : -1;
    return _ensureExpressiveContour(<int>[
      for (final interval in intervals)
        interval == 0
            ? lift
            : interval.sign *
                  _clampInt(
                    interval.abs() + (lift.sign == interval.sign ? 1 : 0),
                    1,
                    4,
                  ),
    ], random: random);
  }

  static List<int> _tailChange(
    List<int> intervals,
    PhrasePlan phrasePlan,
    Random random,
  ) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final changed = List<int>.from(intervals, growable: false);
    final pivot = _maxInt(1, changed.length - _minInt(2, changed.length));
    for (var index = pivot; index < changed.length; index += 1) {
      final source = changed[index];
      final direction = index == changed.length - 1 && phrasePlan.isCadential
          ? -1
          : (index.isEven ? -source.sign : source.sign);
      final magnitude = source == 0
          ? 1 + random.nextInt(2)
          : _clampInt(source.abs() + random.nextInt(2) - 1, 1, 3);
      changed[index] = (direction == 0 ? -1 : direction) * magnitude;
    }
    return _ensureExpressiveContour(
      changed,
      phrasePlan: phrasePlan,
      random: random,
    );
  }

  static List<int> _rhythmDrivenIntervals(
    List<int> intervals,
    RhythmTemplateSample rhythm,
    Random random,
  ) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final target = <int>[];
    for (var index = 0; index < intervals.length; index += 1) {
      final source = intervals[index];
      final slot = rhythm.slots[_minInt(index + 1, rhythm.slots.length - 1)];
      final shortValue = source == 0
          ? (random.nextBool() ? 1 : -1)
          : source.sign;
      if (slot.durationBeats <= 0.5) {
        target.add(shortValue * _clampInt(source.abs(), 1, 2));
        continue;
      }
      if (slot.startBeatOffset % 1 != 0 || slot.anticipatory) {
        final magnitude = _clampInt(
          source.abs() + (index.isEven ? 0 : 1),
          1,
          3,
        );
        target.add((source == 0 ? 1 : source.sign) * magnitude);
        continue;
      }
      if (slot.durationBeats >= 1.0) {
        final magnitude = _clampInt(source.abs() + 1, 1, 4);
        target.add((source == 0 ? 1 : source.sign) * magnitude);
        continue;
      }
      target.add(source);
    }
    return _ensureExpressiveContour(target, random: random);
  }

  static List<int> _truncateExtend(
    List<int> intervals,
    int targetLength,
    PhrasePlan phrasePlan,
    Random random,
  ) {
    if (targetLength <= 0) {
      return const <int>[];
    }
    if (intervals.isEmpty) {
      return List<int>.filled(targetLength, 0, growable: false);
    }
    final start = intervals.length > 2
        ? random.nextInt(intervals.length - 1)
        : 0;
    final truncated = <int>[
      for (var index = start; index < intervals.length; index += 1)
        intervals[index],
    ];
    final target = <int>[
      for (
        var index = 0;
        index < _minInt(truncated.length, targetLength);
        index += 1
      )
        truncated[index],
    ];
    while (target.length < targetLength) {
      final previous = target.isEmpty ? intervals.first : target.last;
      final rebound = previous == 0
          ? (random.nextBool() ? 1 : -1)
          : -previous.sign * _clampInt(previous.abs(), 1, 3);
      target.add(
        phrasePlan.isCadential && target.length == targetLength - 1
            ? -rebound.abs()
            : rebound,
      );
    }
    return _ensureExpressiveContour(
      target.take(targetLength).toList(growable: false),
      phrasePlan: phrasePlan,
      random: random,
    );
  }

  static List<int> _sequence(
    List<int> intervals,
    PhrasePlan phrasePlan,
    Random random,
  ) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final fragmentLength = _minInt(_maxInt(2, intervals.length ~/ 2), 3);
    final fragment = intervals.take(fragmentLength).toList(growable: false);
    final tilt = random.nextBool() ? 1 : -1;
    final target = <int>[];
    for (var index = 0; index < intervals.length; index += 1) {
      final cycle = index ~/ fragmentLength;
      var value = fragment[index % fragmentLength];
      if (cycle > 0) {
        if (index % fragmentLength == 0) {
          value = value == 0 ? tilt : value + (value.sign * tilt);
        } else if (index % fragmentLength == fragmentLength - 1) {
          value = value == 0 ? -tilt : value - value.sign;
        }
      }
      target.add(value);
    }
    return _ensureExpressiveContour(
      target,
      phrasePlan: phrasePlan,
      random: random,
    );
  }

  static List<int> _inversionLite(
    List<int> intervals,
    PhrasePlan phrasePlan,
    Random random,
  ) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final target = <int>[];
    for (var index = 0; index < intervals.length; index += 1) {
      final interval = intervals[index];
      if (interval == 0) {
        target.add(index.isEven ? 1 : -1);
        continue;
      }
      final base = interval.abs() <= 3
          ? -interval
          : (-interval.sign * _maxInt(1, interval.abs() ~/ 2));
      target.add(index.isEven ? base : _clampInt(base + interval.sign, -4, 4));
    }
    return _ensureExpressiveContour(
      target,
      phrasePlan: phrasePlan,
      random: random,
    );
  }

  static List<int> _ensureExpressiveContour(
    List<int> intervals, {
    PhrasePlan? phrasePlan,
    required Random random,
  }) {
    if (intervals.isEmpty) {
      return intervals;
    }
    final result = List<int>.from(intervals, growable: false);
    for (var index = 0; index < result.length; index += 1) {
      final value = result[index];
      if (value.abs() > 5) {
        result[index] = value.sign * 5;
      }
      if (index > 0 && result[index] == 0 && result[index - 1] == 0) {
        result[index] = index.isEven ? 1 : -1;
      }
    }
    final nonZeroSigns = result
        .where((value) => value != 0)
        .map((value) => value.sign)
        .toSet();
    if (result.length >= 3 && nonZeroSigns.length <= 1) {
      final pivot = _maxInt(1, _minInt(result.length - 1, result.length ~/ 2));
      final pivotValue = result[pivot];
      result[pivot] = pivotValue == 0
          ? (random.nextBool() ? 1 : -1)
          : -pivotValue.sign * _clampInt(pivotValue.abs(), 1, 3);
    }
    if (phrasePlan?.isCadential ?? false) {
      final last = result.last;
      result[result.length - 1] = last == 0 ? -1 : -_clampInt(last.abs(), 1, 3);
    }
    return result;
  }

  static List<String?> _shiftToneLabels(List<String?> base, int shift) {
    final palette = _tonePalette(base);
    return [
      for (final label in base)
        label == null
            ? null
            : palette[_wrapIndex(
                palette.indexOf(label) + shift,
                palette.length,
              )],
    ];
  }

  static List<String?> _tailToneLabels(List<String?> base, Random random) {
    if (base.isEmpty) {
      return base;
    }
    final shifted = List<String?>.from(base, growable: false);
    final pivot = _maxInt(1, shifted.length - _minInt(2, shifted.length));
    final amount = random.nextBool() ? 1 : -1;
    final tail = _shiftToneLabels(shifted.sublist(pivot), amount);
    for (var index = pivot; index < shifted.length; index += 1) {
      shifted[index] = tail[index - pivot];
    }
    return shifted;
  }

  static List<String?> _rhythmToneLabels(
    List<String?> base,
    RhythmTemplateSample rhythm,
    Random random,
  ) {
    if (base.isEmpty) {
      return base;
    }
    final shifted = List<String?>.from(base, growable: false);
    for (var index = 0; index < shifted.length; index += 1) {
      final slot = rhythm.slots[_minInt(index, rhythm.slots.length - 1)];
      if (slot.startBeatOffset % 1 != 0 || slot.anticipatory) {
        shifted[index] = _shiftSingleLabel(
          shifted[index],
          random.nextBool() ? 1 : -1,
        );
      }
    }
    return shifted;
  }

  static List<String?> _truncateToneLabels(
    List<String?> base,
    int targetLength,
    Random random,
  ) {
    if (targetLength <= 0) {
      return const <String?>[];
    }
    if (base.isEmpty) {
      return List<String?>.filled(targetLength, null, growable: false);
    }
    final start = base.length > 2 ? random.nextInt(base.length - 1) : 0;
    final taken = <String?>[
      for (var index = start; index < base.length; index += 1) base[index],
    ];
    while (taken.length < targetLength) {
      final previous = taken.isEmpty ? null : taken.last;
      taken.add(_shiftSingleLabel(previous, taken.length.isEven ? 1 : -1));
    }
    return taken.take(targetLength).toList(growable: false);
  }

  static List<String?> _sequenceToneLabels(List<String?> base, Random random) {
    if (base.length < 3) {
      return _shiftToneLabels(base, random.nextBool() ? 1 : -1);
    }
    final fragmentLength = _minInt(3, _maxInt(2, base.length ~/ 2));
    final fragment = base.take(fragmentLength).toList(growable: false);
    final amount = random.nextBool() ? 1 : -1;
    final target = <String?>[];
    for (var index = 0; index < base.length; index += 1) {
      final cycle = index ~/ fragmentLength;
      var label = fragment[index % fragmentLength];
      if (cycle > 0 && label != null) {
        label = _shiftSingleLabel(label, amount);
      }
      target.add(label);
    }
    return target;
  }

  static List<String?> _inversionToneLabels(List<String?> base, Random random) {
    if (base.isEmpty) {
      return base;
    }
    final shifted = List<String?>.from(base.reversed, growable: false);
    return [
      for (var index = 0; index < shifted.length; index += 1)
        index.isEven
            ? shifted[index]
            : _shiftSingleLabel(shifted[index], random.nextBool() ? 1 : -1),
    ];
  }

  static String? _shiftSingleLabel(String? label, int amount) {
    if (label == null) {
      return null;
    }
    final palette = _tonePalette(<String?>[label]);
    return palette[_wrapIndex(palette.indexOf(label) + amount, palette.length)];
  }

  static List<String> _tonePalette(List<String?> base) {
    final palette = <String>[];
    for (final label in base) {
      if (label != null && !palette.contains(label)) {
        palette.add(label);
      }
    }
    for (final fallback in _defaultTonePalette) {
      if (!palette.contains(fallback)) {
        palette.add(fallback);
      }
    }
    return palette;
  }

  static int _wrapIndex(int index, int length) {
    if (length <= 0) {
      return 0;
    }
    final wrapped = index % length;
    return wrapped < 0 ? wrapped + length : wrapped;
  }

  static List<double> _varyRhythmVector(
    List<double> base,
    RhythmTemplateSample rhythm,
  ) {
    if (base.isEmpty) {
      return rhythm.rhythmVector;
    }
    final varied = <double>[];
    for (var index = 0; index < rhythm.rhythmVector.length; index += 1) {
      final source = base[index % base.length];
      final target = rhythm.rhythmVector[index];
      final blended = index.isOdd
          ? ((source * 0.35) + (target * 0.65))
          : ((source + target) / 2);
      varied.add(blended.clamp(0.25, 4.0));
    }
    return varied;
  }

  static List<double> _truncateRhythmVector(
    List<double> base,
    RhythmTemplateSample rhythm,
  ) {
    if (base.isEmpty) {
      return rhythm.rhythmVector;
    }
    final target = <double>[
      for (
        var index = 0;
        index < _minInt(base.length, rhythm.rhythmVector.length);
        index += 1
      )
        base[index],
    ];
    while (target.length < rhythm.rhythmVector.length) {
      target.add(rhythm.rhythmVector[target.length]);
    }
    return target.take(rhythm.rhythmVector.length).toList(growable: false);
  }

  static List<double> _sequenceRhythmVector(
    List<double> base,
    RhythmTemplateSample rhythm,
  ) {
    if (base.isEmpty) {
      return rhythm.rhythmVector;
    }
    final fragmentLength = _minInt(3, _maxInt(2, base.length ~/ 2));
    final fragment = base.take(fragmentLength).toList(growable: false);
    return List<double>.generate(rhythm.rhythmVector.length, (index) {
      final cycle = index ~/ fragmentLength;
      final source = fragment[index % fragmentLength];
      final target = rhythm.rhythmVector[index];
      final blended = cycle == 0 ? source : ((source * 0.45) + (target * 0.55));
      return blended.clamp(0.25, 4.0);
    }, growable: false);
  }
}

class _MotifSource {
  const _MotifSource({required this.memory, required this.distance});

  final MotifMemory memory;
  final int distance;
}

int _maxInt(int left, int right) => left > right ? left : right;

int _minInt(int left, int right) => left < right ? left : right;

int _clampInt(int value, int lower, int upper) {
  if (value < lower) {
    return lower;
  }
  if (value > upper) {
    return upper;
  }
  return value;
}
