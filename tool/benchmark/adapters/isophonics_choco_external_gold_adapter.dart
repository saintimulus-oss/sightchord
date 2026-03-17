import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/chord_theory.dart';

import '../chord_analyzer_external_gold_schema.dart';

class ChocoSurfaceExternalGoldConfig {
  const ChocoSurfaceExternalGoldConfig({
    required this.corpusId,
    required this.corpusName,
    required this.sourceUrl,
    required this.licenseNote,
    required this.genreFamily,
    required this.recordIdPrefix,
    this.adapterVersion = '0.1.0',
  });

  final String corpusId;
  final String corpusName;
  final String sourceUrl;
  final String licenseNote;
  final String genreFamily;
  final String recordIdPrefix;
  final String adapterVersion;
}

const ChocoSurfaceExternalGoldConfig _defaultIsophonicsChocoConfig =
    ChocoSurfaceExternalGoldConfig(
      corpusId: 'isophonics_choco_slice',
      corpusName: 'ChoCo Isophonics Beatles Slice',
      sourceUrl: 'https://github.com/smashub/choco',
      licenseNote:
          'Source JAMS files from ChoCo Isophonics (CC BY 4.0). '
          'Fixture provenance is documented in '
          'tool/benchmark_fixtures/external_gold/isophonics_choco/README.md.',
      genreFamily: 'pop',
      recordIdPrefix: 'isophonics',
    );

class IsophonicsChocoExternalGoldImportResult {
  const IsophonicsChocoExternalGoldImportResult({
    required this.manifest,
    required this.skippedRecords,
    required this.skippedSegments,
    required this.rawRecordCount,
    required this.rawSegmentCount,
    required this.keptSegmentCount,
    required this.rawHarmonicSegmentCount,
    required this.keptHarmonicSegmentCount,
    required this.rawNonHarmonicSegmentCount,
    required this.keptNonHarmonicSegmentCount,
    required this.coverageBySourceId,
    required this.importMode,
    this.fixtureDirectory,
  });

  final ExternalGoldCorpusManifest manifest;
  final List<IsophonicsChocoSkippedItem> skippedRecords;
  final List<IsophonicsChocoSkippedItem> skippedSegments;
  final int rawRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final int rawHarmonicSegmentCount;
  final int keptHarmonicSegmentCount;
  final int rawNonHarmonicSegmentCount;
  final int keptNonHarmonicSegmentCount;
  final Map<String, IsophonicsChocoSourceCoverage> coverageBySourceId;
  final String importMode;
  final String? fixtureDirectory;

  int get loadedRecordCount => manifest.records.length;

  int get skippedRecordCount => skippedRecords.length;

  int get skippedSegmentCount => rawSegmentCount - keptSegmentCount;

  Map<String, int> get skipReasonCounts =>
      _countReasons(skippedSegments.map((item) => item.reason));

  Map<String, int> get recordDropReasonCounts =>
      _countReasons(skippedRecords.map((item) => item.reason));

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedRecordCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  double? get harmonicCoverageRatio => rawHarmonicSegmentCount == 0
      ? null
      : keptHarmonicSegmentCount / rawHarmonicSegmentCount;

  double? get nonHarmonicRetentionRatio => rawNonHarmonicSegmentCount == 0
      ? null
      : keptNonHarmonicSegmentCount / rawNonHarmonicSegmentCount;

  void writeManifest(String path) {
    final file = File(path)..createSync(recursive: true);
    file.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(manifest.toJson())}\n',
    );
  }
}

class IsophonicsChocoSourceCoverage {
  const IsophonicsChocoSourceCoverage({
    required this.sourceId,
    required this.rawRecordCount,
    required this.loadedRecordCount,
    required this.skippedRecordCount,
    required this.rawSegmentCount,
    required this.keptSegmentCount,
    required this.rawHarmonicSegmentCount,
    required this.keptHarmonicSegmentCount,
    required this.rawNonHarmonicSegmentCount,
    required this.keptNonHarmonicSegmentCount,
  });

  final String sourceId;
  final int rawRecordCount;
  final int loadedRecordCount;
  final int skippedRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final int rawHarmonicSegmentCount;
  final int keptHarmonicSegmentCount;
  final int rawNonHarmonicSegmentCount;
  final int keptNonHarmonicSegmentCount;

  int get skippedSegmentCount => rawSegmentCount - keptSegmentCount;

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedRecordCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  double? get harmonicCoverageRatio => rawHarmonicSegmentCount == 0
      ? null
      : keptHarmonicSegmentCount / rawHarmonicSegmentCount;

  double? get nonHarmonicRetentionRatio => rawNonHarmonicSegmentCount == 0
      ? null
      : keptNonHarmonicSegmentCount / rawNonHarmonicSegmentCount;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sourceId': sourceId,
      'rawRecordCount': rawRecordCount,
      'loadedRecordCount': loadedRecordCount,
      'skippedRecordCount': skippedRecordCount,
      'rawSegmentCount': rawSegmentCount,
      'keptSegmentCount': keptSegmentCount,
      'skippedSegmentCount': skippedSegmentCount,
      'rawHarmonicSegmentCount': rawHarmonicSegmentCount,
      'keptHarmonicSegmentCount': keptHarmonicSegmentCount,
      'rawNonHarmonicSegmentCount': rawNonHarmonicSegmentCount,
      'keptNonHarmonicSegmentCount': keptNonHarmonicSegmentCount,
      'recordCoverageRatio': recordCoverageRatio,
      'segmentCoverageRatio': segmentCoverageRatio,
      'harmonicCoverageRatio': harmonicCoverageRatio,
      'nonHarmonicRetentionRatio': nonHarmonicRetentionRatio,
    };
  }
}

class IsophonicsChocoSkippedItem {
  const IsophonicsChocoSkippedItem({
    required this.sourceId,
    required this.reason,
    this.recordId,
    this.index,
    this.label,
  });

  final String sourceId;
  final String reason;
  final String? recordId;
  final int? index;
  final String? label;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sourceId': sourceId,
      'recordId': recordId,
      'index': index,
      'label': label,
      'reason': reason,
    };
  }
}

class IsophonicsChocoExternalGoldAdapter {
  const IsophonicsChocoExternalGoldAdapter({
    ChocoSurfaceExternalGoldConfig? config,
  }) : _config = config ?? _defaultIsophonicsChocoConfig;

  final ChocoSurfaceExternalGoldConfig _config;

  IsophonicsChocoExternalGoldImportResult importExcerptDirectory(
    String inputDir, {
    String? manifestOutputPath,
  }) {
    final root = Directory(inputDir);
    final metadataFile = File(
      '${root.path}${Platform.pathSeparator}metadata.tsv',
    );
    final jamsDirectory = Directory(
      '${root.path}${Platform.pathSeparator}jams',
    );

    if (!metadataFile.existsSync()) {
      throw FileSystemException(
        'Isophonics metadata.tsv fixture not found',
        metadataFile.path,
      );
    }
    if (!jamsDirectory.existsSync()) {
      throw FileSystemException(
        'Isophonics jams fixture folder not found',
        jamsDirectory.path,
      );
    }

    final metadataByStem = <String, _IsophonicsFixtureMetadata>{
      for (final row in _readTsv(metadataFile.path))
        if ((row['file_stem'] ?? '').isNotEmpty)
          row['file_stem']!: _IsophonicsFixtureMetadata.fromTsv(row),
    };

    final skippedRecords = <IsophonicsChocoSkippedItem>[];
    final skippedSegments = <IsophonicsChocoSkippedItem>[];
    final records = <ExternalGoldRecord>[];
    final coverageBuilders = <String, _MutableCoverage>{};
    var rawSegmentCount = 0;
    var keptSegmentCount = 0;
    var rawHarmonicSegmentCount = 0;
    var keptHarmonicSegmentCount = 0;
    var rawNonHarmonicSegmentCount = 0;
    var keptNonHarmonicSegmentCount = 0;

    final files =
        jamsDirectory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.jams'))
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));

    for (final file in files) {
      final stem = file.uri.pathSegments.last.replaceAll('.jams', '');
      final fixtureMetadata = metadataByStem[stem];
      final parsed = _parseJamsFile(file.path);
      final sourceId = fixtureMetadata?.sourceId ?? _slug(parsed.title);
      final recordId = '${_config.recordIdPrefix}-$stem';
      final coverage = coverageBuilders.putIfAbsent(
        sourceId,
        () => _MutableCoverage(sourceId),
      );
      coverage.rawRecordCount += 1;

      if (parsed.keyCenter == null) {
        skippedRecords.add(
          IsophonicsChocoSkippedItem(
            sourceId: sourceId,
            recordId: recordId,
            reason: 'missing_key_mode_annotation',
          ),
        );
        coverage.skippedRecordCount += 1;
        continue;
      }
      if (parsed.chords.isEmpty) {
        skippedRecords.add(
          IsophonicsChocoSkippedItem(
            sourceId: sourceId,
            recordId: recordId,
            reason: 'missing_chord_annotation',
          ),
        );
        coverage.skippedRecordCount += 1;
        continue;
      }

      rawSegmentCount += parsed.chords.length;
      coverage.rawSegmentCount += parsed.chords.length;
      final rawNoChordCount = parsed.chords
          .where((item) => item.value == 'N')
          .length;
      final rawHarmonicCount = parsed.chords.length - rawNoChordCount;
      rawHarmonicSegmentCount += rawHarmonicCount;
      rawNonHarmonicSegmentCount += rawNoChordCount;
      coverage.rawHarmonicSegmentCount += rawHarmonicCount;
      coverage.rawNonHarmonicSegmentCount += rawNoChordCount;

      final preparedSegments = <_PreparedIsophonicsSegment>[];
      for (var index = 0; index < parsed.chords.length; index += 1) {
        final prepared = _convertChordObservation(
          sourceId: sourceId,
          recordId: recordId,
          eventIndex: index,
          keyCenter: parsed.keyCenter!,
          sectionLabel: _sectionLabelAtTime(
            parsed.sections,
            parsed.chords[index].time,
          ),
          observation: parsed.chords[index],
          skippedSegments: skippedSegments,
        );
        if (prepared != null) {
          preparedSegments.add(prepared);
        }
      }

      final keptHarmonicSegments = preparedSegments
          .where((segment) => segment.segment.isHarmonic)
          .toList(growable: false);
      final keptNonHarmonicSegments = preparedSegments
          .where((segment) => segment.segment.isNoChord)
          .toList(growable: false);

      if (keptHarmonicSegments.length < 2) {
        skippedRecords.add(
          IsophonicsChocoSkippedItem(
            sourceId: sourceId,
            recordId: recordId,
            reason: 'insufficient_supported_segments',
          ),
        );
        coverage.skippedRecordCount += 1;
        continue;
      }

      keptSegmentCount += preparedSegments.length;
      keptHarmonicSegmentCount += keptHarmonicSegments.length;
      keptNonHarmonicSegmentCount += keptNonHarmonicSegments.length;
      coverage.loadedRecordCount += 1;
      coverage.keptSegmentCount += preparedSegments.length;
      coverage.keptHarmonicSegmentCount += keptHarmonicSegments.length;
      coverage.keptNonHarmonicSegmentCount += keptNonHarmonicSegments.length;

      final rowLevelSkippedCount = skippedSegments
          .where((item) => item.recordId == recordId)
          .length;
      final title = parsed.release.isEmpty
          ? parsed.title
          : '${parsed.title} (${parsed.release})';

      records.add(
        ExternalGoldRecord(
          recordId: recordId,
          sourceId: sourceId,
          genreFamily: _config.genreFamily,
          workId: stem,
          title: title,
          progressionInput: _buildProgressionInput(preparedSegments),
          primaryKey: parsed.keyCenter!.tonicName,
          primaryMode: parsed.keyCenter!.mode,
          annotationLevel: ExternalGoldAnnotationLevel.surface,
          alignmentType: ExternalGoldAlignmentType.audioAligned,
          keyScope: ExternalGoldKeyScope.globalMovement,
          segmentationScope: ExternalGoldSegmentationScope.fullMovement,
          splitTag: 'external_eval',
          licenseNotes: _config.licenseNote,
          composerOrArtist: parsed.performer,
          movementOrSection: 'full track',
          globalKey: parsed.keyCenter!.displayName,
          confidenceOrAgreement: 'expert annotation',
          segments: [for (final prepared in preparedSegments) prepared.segment],
          metadata: <String, Object?>{
            'sourceRepository': _config.sourceUrl,
            'fixturePath': file.path,
            'fileStem': stem,
            'release': parsed.release,
            'trackNumber': parsed.trackNumber,
            'rawSegmentCount': parsed.chords.length,
            'keptSegmentCount': preparedSegments.length,
            'rawHarmonicSegmentCount': rawHarmonicCount,
            'keptHarmonicSegmentCount': keptHarmonicSegments.length,
            'rawNonHarmonicSegmentCount': rawNoChordCount,
            'keptNonHarmonicSegmentCount': keptNonHarmonicSegments.length,
            'rowLevelSkippedSegmentCount': rowLevelSkippedCount,
            'selectionNote': fixtureMetadata?.selectionNote ?? '',
            'performers': parsed.performer,
            'annotationNamespaces': parsed.annotationNamespaces,
          },
        ),
      );
    }

    final manifest = ExternalGoldCorpusManifest(
      corpusId: _config.corpusId,
      corpusName: _config.corpusName,
      adapterVersion: _config.adapterVersion,
      sourceUrl: _config.sourceUrl,
      licenseNote: _config.licenseNote,
      records: records,
    );
    final result = IsophonicsChocoExternalGoldImportResult(
      manifest: manifest,
      skippedRecords: skippedRecords,
      skippedSegments: skippedSegments,
      rawRecordCount: files.length,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
      rawHarmonicSegmentCount: rawHarmonicSegmentCount,
      keptHarmonicSegmentCount: keptHarmonicSegmentCount,
      rawNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
      keptNonHarmonicSegmentCount: keptNonHarmonicSegmentCount,
      coverageBySourceId: {
        for (final entry
            in (coverageBuilders.entries.toList()
              ..sort((left, right) => left.key.compareTo(right.key))))
          entry.key: entry.value.build(),
      },
      importMode: 'excerpt_directory',
      fixtureDirectory: root.path,
    );

    if (manifestOutputPath != null) {
      result.writeManifest(manifestOutputPath);
    }

    return result;
  }

  _ParsedIsophonicsJams _parseJamsFile(String path) {
    final payload =
        jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
    final annotations = (payload['annotations'] as List<Object?>)
        .cast<Map<String, Object?>>();
    final fileMetadata =
        payload['file_metadata'] as Map<String, Object?>? ??
        const <String, Object?>{};
    final sandbox =
        payload['sandbox'] as Map<String, Object?>? ??
        const <String, Object?>{};

    final chordAnnotation = annotations.firstWhere(
      (annotation) => annotation['namespace'] == 'chord',
      orElse: () => const <String, Object?>{},
    );
    final keyAnnotation = annotations.firstWhere(
      (annotation) => annotation['namespace'] == 'key_mode',
      orElse: () => const <String, Object?>{},
    );
    final sectionAnnotation = annotations.firstWhere(
      (annotation) => annotation['namespace'] == 'segment_open',
      orElse: () => const <String, Object?>{},
    );

    return _ParsedIsophonicsJams(
      title: (fileMetadata['title'] as String?)?.trim() ?? '',
      release: (fileMetadata['release'] as String?)?.trim() ?? '',
      performer:
          ((sandbox['performers'] as List<Object?>?) ?? const <Object?>[])
              .whereType<String>()
              .join(', '),
      trackNumber: (sandbox['track_number'] as String?)?.trim() ?? '',
      keyCenter: _parseKeyMode(
        ((keyAnnotation['data'] as List<Object?>?) ?? const <Object?>[])
            .cast<Map<String, Object?>>(),
      ),
      chords: [
        for (final item
            in ((chordAnnotation['data'] as List<Object?>?) ??
                    const <Object?>[])
                .cast<Map<String, Object?>>())
          _IsophonicsObservation.fromJson(item),
      ],
      sections: [
        for (final item
            in ((sectionAnnotation['data'] as List<Object?>?) ??
                    const <Object?>[])
                .cast<Map<String, Object?>>())
          _IsophonicsObservation.fromJson(item),
      ],
      annotationNamespaces: [
        for (final annotation in annotations)
          if (annotation['namespace'] is String)
            annotation['namespace'] as String,
      ],
    );
  }

  _PreparedIsophonicsSegment? _convertChordObservation({
    required String sourceId,
    required String recordId,
    required int eventIndex,
    required KeyCenter keyCenter,
    required String? sectionLabel,
    required _IsophonicsObservation observation,
    required List<IsophonicsChocoSkippedItem> skippedSegments,
  }) {
    if (observation.value == 'N') {
      return _PreparedIsophonicsSegment(
        segment: ExternalGoldSegment(
          index: eventIndex,
          chordRaw: observation.value,
          chordNormHarte: observation.value,
          segmentRole: ExternalGoldSegmentRole.noChord,
          expectedKey: keyCenter.tonicName,
          expectedMode: keyCenter.mode,
          note:
              'time=${observation.time.toStringAsFixed(3)}; '
              'duration=${observation.duration.toStringAsFixed(3)}; '
              'section=${sectionLabel ?? 'unknown'}; source=${observation.value}; '
              'non_harmonic=true',
        ),
      );
    }

    final resolved = _renderLeadSheetFromHarte(observation.value);
    if (resolved == null) {
      skippedSegments.add(
        IsophonicsChocoSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          index: eventIndex,
          label: observation.value,
          reason: 'unsupported_harte_symbol',
        ),
      );
      return null;
    }

    return _PreparedIsophonicsSegment(
      segment: ExternalGoldSegment(
        index: eventIndex,
        chordRaw: observation.value,
        chordNormHarte: observation.value,
        segmentRole: ExternalGoldSegmentRole.harmonic,
        expectedKey: keyCenter.tonicName,
        expectedMode: keyCenter.mode,
        expectedResolvedSymbol: resolved.renderedSymbol,
        bassOrInversion: resolved.bassNote,
        note:
            'time=${observation.time.toStringAsFixed(3)}; '
            'duration=${observation.duration.toStringAsFixed(3)}; '
            'section=${sectionLabel ?? 'unknown'}; source=${observation.value}',
      ),
    );
  }
}

class _PreparedIsophonicsSegment {
  const _PreparedIsophonicsSegment({required this.segment});

  final ExternalGoldSegment segment;
}

class _ParsedIsophonicsJams {
  const _ParsedIsophonicsJams({
    required this.title,
    required this.release,
    required this.performer,
    required this.trackNumber,
    required this.keyCenter,
    required this.chords,
    required this.sections,
    required this.annotationNamespaces,
  });

  final String title;
  final String release;
  final String performer;
  final String trackNumber;
  final KeyCenter? keyCenter;
  final List<_IsophonicsObservation> chords;
  final List<_IsophonicsObservation> sections;
  final List<String> annotationNamespaces;
}

class _IsophonicsObservation {
  const _IsophonicsObservation({
    required this.time,
    required this.duration,
    required this.value,
  });

  final double time;
  final double duration;
  final String value;

  factory _IsophonicsObservation.fromJson(Map<String, Object?> json) {
    return _IsophonicsObservation(
      time: (json['time'] as num?)?.toDouble() ?? 0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0,
      value: (json['value'] as String?)?.trim() ?? '',
    );
  }
}

class _IsophonicsFixtureMetadata {
  const _IsophonicsFixtureMetadata({
    required this.fileStem,
    required this.sourceId,
    required this.selectionNote,
  });

  final String fileStem;
  final String sourceId;
  final String selectionNote;

  factory _IsophonicsFixtureMetadata.fromTsv(Map<String, String> row) {
    return _IsophonicsFixtureMetadata(
      fileStem: row['file_stem']!.trim(),
      sourceId: row['source_id']!.trim(),
      selectionNote: row['selection_note']?.trim() ?? '',
    );
  }
}

class _MutableCoverage {
  _MutableCoverage(this.sourceId);

  final String sourceId;
  int rawRecordCount = 0;
  int loadedRecordCount = 0;
  int skippedRecordCount = 0;
  int rawSegmentCount = 0;
  int keptSegmentCount = 0;
  int rawHarmonicSegmentCount = 0;
  int keptHarmonicSegmentCount = 0;
  int rawNonHarmonicSegmentCount = 0;
  int keptNonHarmonicSegmentCount = 0;

  IsophonicsChocoSourceCoverage build() {
    return IsophonicsChocoSourceCoverage(
      sourceId: sourceId,
      rawRecordCount: rawRecordCount,
      loadedRecordCount: loadedRecordCount,
      skippedRecordCount: skippedRecordCount,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
      rawHarmonicSegmentCount: rawHarmonicSegmentCount,
      keptHarmonicSegmentCount: keptHarmonicSegmentCount,
      rawNonHarmonicSegmentCount: rawNonHarmonicSegmentCount,
      keptNonHarmonicSegmentCount: keptNonHarmonicSegmentCount,
    );
  }
}

class _RenderedLeadSheetChord {
  const _RenderedLeadSheetChord({required this.renderedSymbol, this.bassNote});

  final String renderedSymbol;
  final String? bassNote;
}

Iterable<Map<String, String>> _readTsv(String path) sync* {
  final lines = File(path).readAsLinesSync();
  if (lines.isEmpty) {
    return;
  }
  final headers = lines.first.split('\t');
  for (final rawLine in lines.skip(1)) {
    if (rawLine.trim().isEmpty) {
      continue;
    }
    final values = rawLine.split('\t');
    yield <String, String>{
      for (var index = 0; index < headers.length; index += 1)
        headers[index]: index < values.length ? values[index] : '',
    };
  }
}

Map<String, int> _countReasons(Iterable<String> reasons) {
  final counts = <String, int>{};
  for (final reason in reasons) {
    counts.update(reason, (value) => value + 1, ifAbsent: () => 1);
  }
  return counts;
}

KeyCenter? _parseKeyMode(List<Map<String, Object?>> items) {
  if (items.isEmpty) {
    return null;
  }
  final value = (items.first['value'] as String?)?.trim() ?? '';
  final match = RegExp(
    r'^([A-G](?:#|b)?)(?::(minor|major))?$',
  ).firstMatch(value);
  if (match == null) {
    return null;
  }
  return KeyCenter(
    tonicName: match.group(1)!,
    mode: match.group(2) == 'minor' ? KeyMode.minor : KeyMode.major,
  );
}

String? _sectionLabelAtTime(
  List<_IsophonicsObservation> sections,
  double time,
) {
  for (final section in sections) {
    final start = section.time;
    final end = section.time + section.duration;
    if (time >= start && time < end) {
      return section.value;
    }
  }
  return null;
}

_RenderedLeadSheetChord? _renderLeadSheetFromHarte(String value) {
  final match = RegExp(
    r'^([A-G](?:#|b)?)(?::([^/]+))?(?:/(.+))?$',
  ).firstMatch(value);
  if (match == null) {
    return null;
  }
  final root = match.group(1)!;
  final descriptor = match.group(2)?.trim() ?? '';
  final bassToken = match.group(3)?.trim();
  final suffix = _leadSheetSuffixForDescriptor(descriptor);
  if (suffix == null) {
    return null;
  }
  final bassNote = bassToken == null || bassToken.isEmpty
      ? null
      : _bassNoteFromToken(root, bassToken);
  if (bassToken != null && bassNote == null) {
    return null;
  }
  return _RenderedLeadSheetChord(
    renderedSymbol: '$root$suffix${bassNote == null ? '' : '/$bassNote'}',
    bassNote: bassNote,
  );
}

String? _leadSheetSuffixForDescriptor(String descriptor) {
  return switch (descriptor) {
    '' || 'maj' => '',
    'min' => 'm',
    'min7' => 'm7',
    'min6' => 'm6',
    'maj7' => 'maj7',
    'maj6' => '6',
    'maj6(9)' => '6/9',
    '7' => '7',
    '7(#9)' => '7#9',
    '9' => '9',
    'sus4' => 'sus4',
    'dim' => 'dim',
    'dim7' => 'dim7',
    'aug' => 'aug',
    _ => null,
  };
}

String? _bassNoteFromToken(String root, String token) {
  if (MusicTheory.noteToSemitone.containsKey(token)) {
    return token;
  }
  final semitone = _intervalTokenToSemitone(token);
  if (semitone == null) {
    return null;
  }
  return MusicTheory.transposePitch(
    root,
    semitone,
    preferFlat: root.contains('b') || token.contains('b'),
  );
}

int? _intervalTokenToSemitone(String token) {
  return switch (token) {
    '1' => 0,
    'b2' => 1,
    '2' || '9' => 2,
    '#2' || 'b3' => 3,
    '3' => 4,
    '4' || '11' => 5,
    '#4' || 'b5' => 6,
    '5' => 7,
    '#5' || 'b6' => 8,
    '6' || '13' => 9,
    'bb7' => 9,
    'b7' => 10,
    '7' => 11,
    _ => null,
  };
}

String _buildProgressionInput(List<_PreparedIsophonicsSegment> segments) {
  return [
    for (final segment in segments) segment.segment.progressionToken,
  ].join(' ');
}

String _slug(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}
