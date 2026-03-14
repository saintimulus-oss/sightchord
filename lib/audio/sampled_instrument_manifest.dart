import 'dart:convert';
import 'dart:math' as math;

class SampledInstrumentManifest {
  SampledInstrumentManifest({
    required this.id,
    required this.displayName,
    required this.version,
    required this.range,
    required this.velocityLayers,
    required this.defaults,
    required this.regions,
  }) : _regionsByMidi = _indexRegionsByMidi(regions);

  factory SampledInstrumentManifest.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Instrument manifest must be a JSON object.');
    }
    return SampledInstrumentManifest.fromJson(decoded);
  }

  factory SampledInstrumentManifest.fromJson(Map<String, Object?> json) {
    final rangeJson = json['range'];
    final defaultsJson = json['defaults'];
    final velocityLayersJson = json['velocityLayers'];
    final regionsJson = json['regions'];

    if (rangeJson is! Map<String, Object?> ||
        defaultsJson is! Map<String, Object?> ||
        velocityLayersJson is! List<Object?> ||
        regionsJson is! List<Object?>) {
      throw const FormatException(
        'Instrument manifest is missing core fields.',
      );
    }

    return SampledInstrumentManifest(
      id: json['id'] as String? ?? 'unknown-instrument',
      displayName: json['displayName'] as String? ?? 'Unknown Instrument',
      version: (json['version'] as num?)?.toInt() ?? 1,
      range: InstrumentNoteRange.fromJson(rangeJson),
      velocityLayers: velocityLayersJson
          .whereType<Map<String, Object?>>()
          .map(InstrumentVelocityLayer.fromJson)
          .toList(growable: false),
      defaults: InstrumentPlaybackDefaults.fromJson(defaultsJson),
      regions: regionsJson
          .whereType<Map<String, Object?>>()
          .map(InstrumentSampleRegion.fromJson)
          .toList(growable: false),
    );
  }

  final String id;
  final String displayName;
  final int version;
  final InstrumentNoteRange range;
  final List<InstrumentVelocityLayer> velocityLayers;
  final InstrumentPlaybackDefaults defaults;
  final List<InstrumentSampleRegion> regions;
  final Map<int, List<InstrumentSampleRegion>> _regionsByMidi;

  ResolvedSampleRegion? resolveRegion({
    required int midiNote,
    required int velocity,
  }) {
    final normalizedMidi = defaults.clampOutOfRangeNotes
        ? range.foldToRange(midiNote)
        : midiNote;
    final normalizedVelocity = velocity.clamp(1, 127).toInt();
    final candidates = _regionsByMidi[normalizedMidi];
    if (candidates == null || candidates.isEmpty) {
      return null;
    }
    for (final region in candidates) {
      if (region.containsVelocity(normalizedVelocity)) {
        final semitoneOffset = normalizedMidi - region.pitchKeycenter;
        return ResolvedSampleRegion(
          originalMidi: midiNote,
          resolvedMidi: normalizedMidi,
          velocity: normalizedVelocity,
          pitchOffsetSemitones: semitoneOffset,
          playbackRate: math.pow(2.0, semitoneOffset / 12.0).toDouble(),
          region: region,
        );
      }
    }
    return null;
  }

  static Map<int, List<InstrumentSampleRegion>> _indexRegionsByMidi(
    List<InstrumentSampleRegion> regions,
  ) {
    final index = <int, List<InstrumentSampleRegion>>{};
    for (final region in regions) {
      for (var midi = region.lokey; midi <= region.hikey; midi += 1) {
        index.putIfAbsent(midi, () => <InstrumentSampleRegion>[]).add(region);
      }
    }
    for (final bucket in index.values) {
      bucket.sort((left, right) => left.lovel.compareTo(right.lovel));
    }
    return index;
  }
}

class InstrumentNoteRange {
  const InstrumentNoteRange({
    required this.minMidi,
    required this.maxMidi,
    required this.minLabel,
    required this.maxLabel,
  });

  factory InstrumentNoteRange.fromJson(Map<String, Object?> json) {
    return InstrumentNoteRange(
      minMidi: (json['minMidi'] as num?)?.toInt() ?? 36,
      maxMidi: (json['maxMidi'] as num?)?.toInt() ?? 84,
      minLabel: json['minLabel'] as String? ?? 'C2',
      maxLabel: json['maxLabel'] as String? ?? 'C6',
    );
  }

  final int minMidi;
  final int maxMidi;
  final String minLabel;
  final String maxLabel;

  int foldToRange(int midi) {
    var normalized = midi;
    while (normalized < minMidi) {
      normalized += 12;
    }
    while (normalized > maxMidi) {
      normalized -= 12;
    }
    return normalized.clamp(minMidi, maxMidi).toInt();
  }
}

class InstrumentVelocityLayer {
  const InstrumentVelocityLayer({
    required this.layer,
    required this.minVelocity,
    required this.maxVelocity,
  });

  factory InstrumentVelocityLayer.fromJson(Map<String, Object?> json) {
    return InstrumentVelocityLayer(
      layer: (json['layer'] as num?)?.toInt() ?? 0,
      minVelocity: (json['minVelocity'] as num?)?.toInt() ?? 1,
      maxVelocity: (json['maxVelocity'] as num?)?.toInt() ?? 127,
    );
  }

  final int layer;
  final int minVelocity;
  final int maxVelocity;
}

class InstrumentPlaybackDefaults {
  const InstrumentPlaybackDefaults({
    required this.polyphony,
    required this.releaseFadeOutMs,
    required this.defaultChordHoldMs,
    required this.defaultArpeggioStepMs,
    required this.defaultArpeggioHoldMs,
    required this.velocityCurvePower,
    required this.baseVolume,
    required this.noteOnPrerollVoices,
    required this.clampOutOfRangeNotes,
  });

  factory InstrumentPlaybackDefaults.fromJson(Map<String, Object?> json) {
    return InstrumentPlaybackDefaults(
      polyphony: (json['polyphony'] as num?)?.toInt() ?? 24,
      releaseFadeOutMs: (json['releaseFadeOutMs'] as num?)?.toInt() ?? 90,
      defaultChordHoldMs: (json['defaultChordHoldMs'] as num?)?.toInt() ?? 950,
      defaultArpeggioStepMs:
          (json['defaultArpeggioStepMs'] as num?)?.toInt() ?? 120,
      defaultArpeggioHoldMs:
          (json['defaultArpeggioHoldMs'] as num?)?.toInt() ?? 780,
      velocityCurvePower:
          (json['velocityCurvePower'] as num?)?.toDouble() ?? 0.88,
      baseVolume: (json['baseVolume'] as num?)?.toDouble() ?? 0.94,
      noteOnPrerollVoices: (json['noteOnPrerollVoices'] as num?)?.toInt() ?? 6,
      clampOutOfRangeNotes: json['clampOutOfRangeNotes'] as bool? ?? true,
    );
  }

  final int polyphony;
  final int releaseFadeOutMs;
  final int defaultChordHoldMs;
  final int defaultArpeggioStepMs;
  final int defaultArpeggioHoldMs;
  final double velocityCurvePower;
  final double baseVolume;
  final int noteOnPrerollVoices;
  final bool clampOutOfRangeNotes;
}

class InstrumentSampleRegion {
  const InstrumentSampleRegion({
    required this.sampleAssetPath,
    required this.lokey,
    required this.hikey,
    required this.pitchKeycenter,
    required this.layer,
    required this.lovel,
    required this.hivel,
  });

  factory InstrumentSampleRegion.fromJson(Map<String, Object?> json) {
    return InstrumentSampleRegion(
      sampleAssetPath: json['sample'] as String? ?? '',
      lokey: (json['lokey'] as num?)?.toInt() ?? 0,
      hikey: (json['hikey'] as num?)?.toInt() ?? 127,
      pitchKeycenter: (json['pitchKeycenter'] as num?)?.toInt() ?? 60,
      layer: (json['layer'] as num?)?.toInt() ?? 1,
      lovel: (json['lovel'] as num?)?.toInt() ?? 1,
      hivel: (json['hivel'] as num?)?.toInt() ?? 127,
    );
  }

  final String sampleAssetPath;
  final int lokey;
  final int hikey;
  final int pitchKeycenter;
  final int layer;
  final int lovel;
  final int hivel;

  bool containsVelocity(int velocity) => velocity >= lovel && velocity <= hivel;
}

class ResolvedSampleRegion {
  const ResolvedSampleRegion({
    required this.originalMidi,
    required this.resolvedMidi,
    required this.velocity,
    required this.pitchOffsetSemitones,
    required this.playbackRate,
    required this.region,
  });

  final int originalMidi;
  final int resolvedMidi;
  final int velocity;
  final int pitchOffsetSemitones;
  final double playbackRate;
  final InstrumentSampleRegion region;
}
