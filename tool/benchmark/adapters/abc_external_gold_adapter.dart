import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/chord_theory.dart';

import '../chord_analyzer_external_gold_schema.dart';

const String _abcCorpusId = 'dcml_abc_excerpt';
const String _abcCorpusName = 'DCML Annotated Beethoven Corpus Excerpts';
const String _abcSourceUrl = 'https://github.com/DCMLab/ABC';
const String _abcLicenseNote =
    'Source excerpts from DCMLab ABC (CC BY-NC-SA 4.0). '
    'Fixture provenance is documented in tool/benchmark_fixtures/external_gold/abc/README.md.';

class AbcExternalGoldImportResult {
  const AbcExternalGoldImportResult({
    required this.manifest,
    required this.skippedRecords,
    required this.skippedSegments,
    required this.rawRecordCount,
    required this.rawSegmentCount,
    required this.keptSegmentCount,
    required this.coverageBySourceId,
    required this.importMode,
    this.fixtureDirectory,
    this.selectionManifestPath,
    this.sourceCorpusRootPath,
  });

  final ExternalGoldCorpusManifest manifest;
  final List<AbcSkippedItem> skippedRecords;
  final List<AbcSkippedItem> skippedSegments;
  final int rawRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final Map<String, AbcSourceCoverage> coverageBySourceId;
  final String importMode;
  final String? fixtureDirectory;
  final String? selectionManifestPath;
  final String? sourceCorpusRootPath;

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

  void writeManifest(String path) {
    final file = File(path)..createSync(recursive: true);
    file.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(manifest.toJson())}\n',
    );
  }
}

class AbcSourceCoverage {
  const AbcSourceCoverage({
    required this.sourceId,
    required this.rawRecordCount,
    required this.loadedRecordCount,
    required this.skippedRecordCount,
    required this.rawSegmentCount,
    required this.keptSegmentCount,
  });

  final String sourceId;
  final int rawRecordCount;
  final int loadedRecordCount;
  final int skippedRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;

  int get skippedSegmentCount => rawSegmentCount - keptSegmentCount;

  double? get recordCoverageRatio =>
      rawRecordCount == 0 ? null : loadedRecordCount / rawRecordCount;

  double? get segmentCoverageRatio =>
      rawSegmentCount == 0 ? null : keptSegmentCount / rawSegmentCount;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sourceId': sourceId,
      'rawRecordCount': rawRecordCount,
      'loadedRecordCount': loadedRecordCount,
      'skippedRecordCount': skippedRecordCount,
      'rawSegmentCount': rawSegmentCount,
      'keptSegmentCount': keptSegmentCount,
      'skippedSegmentCount': skippedSegmentCount,
      'recordCoverageRatio': recordCoverageRatio,
      'segmentCoverageRatio': segmentCoverageRatio,
    };
  }
}

class AbcSkippedItem {
  const AbcSkippedItem({
    required this.sourceId,
    required this.reason,
    this.recordId,
    this.measureNumber,
    this.label,
  });

  final String sourceId;
  final String reason;
  final String? recordId;
  final int? measureNumber;
  final String? label;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sourceId': sourceId,
      'recordId': recordId,
      'measureNumber': measureNumber,
      'label': label,
      'reason': reason,
    };
  }
}

class AbcExternalGoldAdapter {
  const AbcExternalGoldAdapter();

  AbcExternalGoldImportResult importExcerptDirectory(
    String inputDir, {
    String? manifestOutputPath,
  }) {
    final root = Directory(inputDir);
    final metadataFile = File(
      '${root.path}${Platform.pathSeparator}metadata.tsv',
    );
    final harmonyDir = Directory(
      '${root.path}${Platform.pathSeparator}harmonies',
    );

    if (!metadataFile.existsSync()) {
      throw FileSystemException(
        'ABC metadata.tsv fixture not found',
        metadataFile.path,
      );
    }
    if (!harmonyDir.existsSync()) {
      throw FileSystemException(
        'ABC harmonies fixture folder not found',
        harmonyDir.path,
      );
    }

    final metadataByPiece = _metadataByPiece(metadataFile.path);
    final inputs = <_ExcerptImportInput>[];

    final harmonyFiles =
        harmonyDir
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.harmonies.tsv'))
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));

    for (final file in harmonyFiles) {
      final excerpt = _ExcerptFileName.tryParse(file.path);
      if (excerpt == null) {
        inputs.add(
          _ExcerptImportInput.invalid(
            sourceId: file.uri.pathSegments.isEmpty
                ? file.path
                : file.uri.pathSegments.last,
            reason: 'unrecognized_excerpt_filename',
          ),
        );
        continue;
      }
      inputs.add(
        _ExcerptImportInput(
          excerpt: excerpt,
          rawRows: [
            for (final row in _readTsv(file.path)) _AbcHarmonyRow.fromTsv(row),
          ],
          sourcePath: 'harmonies/${excerpt.sourceId}.harmonies.tsv',
          fixturePath: file.path,
        ),
      );
    }

    return _importPreparedInputs(
      metadataByPiece: metadataByPiece,
      inputs: inputs,
      manifestOutputPath: manifestOutputPath,
      importMode: 'excerpt_directory',
      fixtureDirectory: root.path,
    );
  }

  AbcExternalGoldImportResult importSelectionManifest({
    required String sourceCorpusRoot,
    required String selectionManifestPath,
    String? manifestOutputPath,
  }) {
    final root = Directory(sourceCorpusRoot);
    final metadataFile = File(
      '${root.path}${Platform.pathSeparator}metadata.tsv',
    );
    final harmonyDir = Directory(
      '${root.path}${Platform.pathSeparator}harmonies',
    );
    final selectionFile = File(selectionManifestPath);

    if (!metadataFile.existsSync()) {
      throw FileSystemException(
        'ABC metadata.tsv source not found',
        metadataFile.path,
      );
    }
    if (!harmonyDir.existsSync()) {
      throw FileSystemException(
        'ABC harmonies source folder not found',
        harmonyDir.path,
      );
    }
    if (!selectionFile.existsSync()) {
      throw FileSystemException(
        'ABC selection manifest not found',
        selectionFile.path,
      );
    }

    final metadataByPiece = _metadataByPiece(metadataFile.path);
    final inputs = <_ExcerptImportInput>[];

    for (final row in _readTsv(selectionFile.path)) {
      final selection = _AbcSelectionRow.fromTsv(row);
      final excerpt = _ExcerptFileName(
        sourceId: selection.sourceId,
        measureStart: selection.measureStart,
        measureEnd: selection.measureEnd,
      );
      final harmonyFile = File(
        '${harmonyDir.path}${Platform.pathSeparator}${selection.sourceId}.harmonies.tsv',
      );
      if (!harmonyFile.existsSync()) {
        inputs.add(
          _ExcerptImportInput.invalid(
            sourceId: selection.sourceId,
            recordId: excerpt.recordId,
            reason: 'missing_source_harmony_file',
          ),
        );
        continue;
      }

      final rawRows =
          [
                for (final row in _readTsv(harmonyFile.path))
                  _AbcHarmonyRow.fromTsv(row),
              ]
              .where((row) {
                return row.measureNumber >= selection.measureStart &&
                    row.measureNumber <= selection.measureEnd;
              })
              .toList(growable: false);

      inputs.add(
        _ExcerptImportInput(
          excerpt: excerpt,
          rawRows: rawRows,
          sourcePath: 'harmonies/${selection.sourceId}.harmonies.tsv',
          fixturePath: selectionFile.path,
          selectionNote: selection.selectionNote,
        ),
      );
    }

    return _importPreparedInputs(
      metadataByPiece: metadataByPiece,
      inputs: inputs,
      manifestOutputPath: manifestOutputPath,
      importMode: 'selection_manifest',
      fixtureDirectory: selectionFile.parent.path,
      selectionManifestPath: selectionFile.path,
      sourceCorpusRootPath: root.path,
    );
  }

  AbcExternalGoldImportResult _importPreparedInputs({
    required Map<String, _AbcMetadataRow> metadataByPiece,
    required List<_ExcerptImportInput> inputs,
    required String importMode,
    String? manifestOutputPath,
    String? fixtureDirectory,
    String? selectionManifestPath,
    String? sourceCorpusRootPath,
  }) {
    final skippedRecords = <AbcSkippedItem>[];
    final skippedSegments = <AbcSkippedItem>[];
    final records = <ExternalGoldRecord>[];
    final coverageBuilders = <String, _MutableCoverage>{};
    var rawSegmentCount = 0;
    var keptSegmentCount = 0;

    for (final input in inputs) {
      if (input.invalidReason != null) {
        skippedRecords.add(
          AbcSkippedItem(
            sourceId: input.sourceId,
            recordId: input.recordId,
            reason: input.invalidReason!,
          ),
        );
        coverageBuilders
                .putIfAbsent(
                  input.sourceId,
                  () => _MutableCoverage(input.sourceId),
                )
                .rawRecordCount +=
            1;
        coverageBuilders[input.sourceId]!.skippedRecordCount += 1;
        continue;
      }

      final excerpt = input.excerpt!;
      final sourceCoverage = coverageBuilders.putIfAbsent(
        excerpt.sourceId,
        () => _MutableCoverage(excerpt.sourceId),
      );
      sourceCoverage.rawRecordCount += 1;
      sourceCoverage.rawSegmentCount += input.rawRows.length;
      rawSegmentCount += input.rawRows.length;

      final metadata = metadataByPiece[excerpt.sourceId];
      if (metadata == null) {
        skippedRecords.add(
          AbcSkippedItem(
            sourceId: excerpt.sourceId,
            recordId: excerpt.recordId,
            reason: 'missing_metadata_row',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      if (input.rawRows.isEmpty) {
        skippedRecords.add(
          AbcSkippedItem(
            sourceId: excerpt.sourceId,
            recordId: excerpt.recordId,
            reason: 'empty_excerpt',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      final preparedSegments = <_PreparedSegment>[];
      for (var index = 0; index < input.rawRows.length; index += 1) {
        final row = input.rawRows[index];
        final prepared = _convertRow(
          recordId: excerpt.recordId,
          segmentIndex: index,
          sourceId: excerpt.sourceId,
          row: row,
          skippedSegments: skippedSegments,
        );
        if (prepared != null) {
          preparedSegments.add(prepared);
        }
      }

      if (preparedSegments.length < 2) {
        skippedRecords.add(
          AbcSkippedItem(
            sourceId: excerpt.sourceId,
            recordId: excerpt.recordId,
            reason: 'insufficient_supported_segments',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      final firstKey = preparedSegments.first.expectedKeyCenter;
      final recordTitleBase = metadata.displayTitle.isNotEmpty
          ? metadata.displayTitle
          : excerpt.sourceId;
      final movementSection =
          'mc ${excerpt.measureStart}-${excerpt.measureEnd}';
      final rowLevelSkippedCount = skippedSegments
          .where((item) => item.recordId == excerpt.recordId)
          .length;

      final metadataMap = <String, Object?>{
        'sourceRepository': _abcSourceUrl,
        'sourcePath': input.sourcePath,
        'fixturePath': input.fixturePath,
        'globalKeyToken': input.rawRows.first.globalKey,
        'initialLocalKeyToken': input.rawRows.first.localKey,
        'sourceMeasures': movementSection,
        'rawSegmentCount': input.rawRows.length,
        'keptSegmentCount': preparedSegments.length,
        'rowLevelSkippedSegmentCount': rowLevelSkippedCount,
        if (input.selectionNote != null && input.selectionNote!.isNotEmpty)
          'selectionNote': input.selectionNote,
        'selectionManifestPath': selectionManifestPath,
        'sourceCorpusRootPath': sourceCorpusRootPath,
      };

      records.add(
        ExternalGoldRecord(
          recordId: excerpt.recordId,
          sourceId: excerpt.sourceId,
          genreFamily: 'classical',
          workId: excerpt.sourceId,
          title: '$recordTitleBase ($movementSection)',
          composerOrArtist: metadata.composer,
          movementOrSection: movementSection,
          progressionInput: _buildProgressionInput(preparedSegments),
          primaryKey: firstKey.tonicName,
          primaryMode: firstKey.mode,
          annotationLevel: ExternalGoldAnnotationLevel.functional,
          alignmentType: ExternalGoldAlignmentType.symbolic,
          keyScope: ExternalGoldKeyScope.localExcerpt,
          segmentationScope: ExternalGoldSegmentationScope.measureWindow,
          splitTag: 'external_eval',
          licenseNotes: _abcLicenseNote,
          globalKey: _parseAbsoluteKeyToken(
            input.rawRows.first.globalKey,
          ).displayName,
          localKey: firstKey.displayName,
          confidenceOrAgreement: 'expert annotation',
          segments: [for (final prepared in preparedSegments) prepared.segment],
          metadata: metadataMap,
        ),
      );

      sourceCoverage.loadedRecordCount += 1;
      sourceCoverage.keptSegmentCount += preparedSegments.length;
      keptSegmentCount += preparedSegments.length;
    }

    final manifest = ExternalGoldCorpusManifest(
      corpusId: _abcCorpusId,
      corpusName: _abcCorpusName,
      adapterVersion: '0.2.0',
      sourceUrl: _abcSourceUrl,
      licenseNote: _abcLicenseNote,
      records: records,
    );
    final result = AbcExternalGoldImportResult(
      manifest: manifest,
      skippedRecords: skippedRecords,
      skippedSegments: skippedSegments,
      rawRecordCount: inputs.length,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
      coverageBySourceId: {
        for (final entry
            in (coverageBuilders.entries.toList()
              ..sort((left, right) => left.key.compareTo(right.key))))
          entry.key: entry.value.build(),
      },
      importMode: importMode,
      fixtureDirectory: fixtureDirectory,
      selectionManifestPath: selectionManifestPath,
      sourceCorpusRootPath: sourceCorpusRootPath,
    );

    if (manifestOutputPath != null) {
      result.writeManifest(manifestOutputPath);
    }

    return result;
  }

  _PreparedSegment? _convertRow({
    required String recordId,
    required int segmentIndex,
    required String sourceId,
    required _AbcHarmonyRow row,
    required List<AbcSkippedItem> skippedSegments,
  }) {
    if (!_supportedChordTypes.contains(row.chordType)) {
      skippedSegments.add(
        AbcSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          measureNumber: row.measureNumber,
          label: row.label,
          reason: 'unsupported_chord_type:${row.chordType}',
        ),
      );
      return null;
    }
    if (row.numeral.isEmpty || row.rootCoordinate == null) {
      skippedSegments.add(
        AbcSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          measureNumber: row.measureNumber,
          label: row.label,
          reason: 'missing_numeral_or_root',
        ),
      );
      return null;
    }

    final localKeyCenter = _resolveAbsoluteKey(
      globalKeyToken: row.globalKey,
      localKeyToken: row.localKey,
    );
    final rootNote = _noteFromFifths(
      localKeyCenter.fifths + row.rootCoordinate!,
    );
    final bassNote = row.bassCoordinate == null
        ? null
        : _noteFromFifths(localKeyCenter.fifths + row.bassCoordinate!);

    if (!_isAnalyzerCompatibleNote(rootNote) ||
        (bassNote != null && !_isAnalyzerCompatibleNote(bassNote))) {
      skippedSegments.add(
        AbcSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          measureNumber: row.measureNumber,
          label: row.label,
          reason:
              'unsupported_spelling:$rootNote${bassNote == null ? '' : '/$bassNote'}',
        ),
      );
      return null;
    }

    final resolvedSymbol = _renderChordSymbol(
      rootNote: rootNote,
      bassNote: bassNote,
      chordType: row.chordType,
    );
    final canonicalRoman = _canonicalRomanToken(row);
    final expectedFunction = _expectedFunction(row.numeral);

    return _PreparedSegment(
      measureNumber: row.measureNumber,
      expectedKeyCenter: localKeyCenter,
      segment: ExternalGoldSegment(
        index: segmentIndex,
        chordRaw: row.label,
        chordNormHarte: _renderHarteSymbol(
          rootNote: rootNote,
          bassNote: bassNote,
          chordType: row.chordType,
        ),
        expectedKey: localKeyCenter.tonicName,
        expectedMode: localKeyCenter.mode,
        surfaceRomanLabel: row.chord,
        canonicalRomanLabel: canonicalRoman,
        expectedFunction: expectedFunction,
        expectedResolvedSymbol: resolvedSymbol,
        bassOrInversion: bassNote,
        note:
            'sourceChord=${row.chord}; localKey=${localKeyCenter.displayName}; '
            'measure=${row.measureNumber}; sourceLabel=${row.label}',
      ),
    );
  }
}

class _ExcerptImportInput {
  _ExcerptImportInput({
    required this.excerpt,
    required this.rawRows,
    required this.sourcePath,
    required this.fixturePath,
    this.selectionNote,
  }) : invalidReason = null,
       sourceId = excerpt!.sourceId,
       recordId = excerpt.recordId;

  _ExcerptImportInput.invalid({
    required this.sourceId,
    required String reason,
    this.recordId,
  }) : excerpt = null,
       rawRows = const <_AbcHarmonyRow>[],
       sourcePath = '',
       fixturePath = '',
       selectionNote = null,
       invalidReason = reason;

  final _ExcerptFileName? excerpt;
  final List<_AbcHarmonyRow> rawRows;
  final String sourcePath;
  final String fixturePath;
  final String? selectionNote;
  final String sourceId;
  final String? recordId;
  final String? invalidReason;
}

class _MutableCoverage {
  _MutableCoverage(this.sourceId);

  final String sourceId;
  int rawRecordCount = 0;
  int loadedRecordCount = 0;
  int skippedRecordCount = 0;
  int rawSegmentCount = 0;
  int keptSegmentCount = 0;

  AbcSourceCoverage build() {
    return AbcSourceCoverage(
      sourceId: sourceId,
      rawRecordCount: rawRecordCount,
      loadedRecordCount: loadedRecordCount,
      skippedRecordCount: skippedRecordCount,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
    );
  }
}

class _AbcSelectionRow {
  const _AbcSelectionRow({
    required this.sourceId,
    required this.measureStart,
    required this.measureEnd,
    this.selectionNote,
  });

  final String sourceId;
  final int measureStart;
  final int measureEnd;
  final String? selectionNote;

  factory _AbcSelectionRow.fromTsv(Map<String, String> row) {
    final sourceId = row['source_id'] ?? '';
    final measureStart = int.parse(row['measure_start'] ?? '');
    final measureEnd = int.parse(row['measure_end'] ?? '');
    if (sourceId.isEmpty) {
      throw FormatException('ABC selection row is missing source_id');
    }
    return _AbcSelectionRow(
      sourceId: sourceId,
      measureStart: measureStart,
      measureEnd: measureEnd,
      selectionNote: row['selection_note'],
    );
  }
}

class _PreparedSegment {
  const _PreparedSegment({
    required this.measureNumber,
    required this.expectedKeyCenter,
    required this.segment,
  });

  final int measureNumber;
  final _AbsoluteKeyCenter expectedKeyCenter;
  final ExternalGoldSegment segment;
}

class _ExcerptFileName {
  const _ExcerptFileName({
    required this.sourceId,
    required this.measureStart,
    required this.measureEnd,
  });

  final String sourceId;
  final int measureStart;
  final int measureEnd;

  String get recordId =>
      'abc-$sourceId-mc$measureStart-${measureEnd.toString().padLeft(2, '0')}';

  static _ExcerptFileName? tryParse(String path) {
    final fileName = path.replaceAll('\\', '/').split('/').last;
    final match = RegExp(
      r'^(.+)__mm(\d+)-(\d+)\.harmonies\.tsv$',
    ).firstMatch(fileName);
    if (match == null) {
      return null;
    }
    return _ExcerptFileName(
      sourceId: match.group(1)!,
      measureStart: int.parse(match.group(2)!),
      measureEnd: int.parse(match.group(3)!),
    );
  }
}

class _AbcMetadataRow {
  const _AbcMetadataRow({
    required this.piece,
    required this.annotatedKey,
    required this.composer,
    required this.movementTitle,
    required this.relPath,
  });

  final String piece;
  final String annotatedKey;
  final String composer;
  final String movementTitle;
  final String relPath;

  String get displayTitle => movementTitle.trim();

  factory _AbcMetadataRow.fromTsv(Map<String, String> row) {
    return _AbcMetadataRow(
      piece: row['piece'] ?? '',
      annotatedKey: row['annotated_key'] ?? '',
      composer: row['composer'] ?? '',
      movementTitle: row['movementTitle'] ?? '',
      relPath: row['rel_path'] ?? '',
    );
  }
}

class _AbcHarmonyRow {
  const _AbcHarmonyRow({
    required this.measureNumber,
    required this.label,
    required this.globalKey,
    required this.localKey,
    required this.chord,
    required this.numeral,
    required this.relativeroot,
    required this.chordType,
    required this.rootCoordinate,
    required this.bassCoordinate,
  });

  final int measureNumber;
  final String label;
  final String globalKey;
  final String localKey;
  final String chord;
  final String numeral;
  final String relativeroot;
  final String chordType;
  final int? rootCoordinate;
  final int? bassCoordinate;

  factory _AbcHarmonyRow.fromTsv(Map<String, String> row) {
    return _AbcHarmonyRow(
      measureNumber: _parseInt(row['mc']) ?? 0,
      label: row['label'] ?? '',
      globalKey: row['globalkey'] ?? '',
      localKey: (row['localkey'] ?? '').isEmpty ? 'I' : row['localkey']!,
      chord: row['chord'] ?? '',
      numeral: row['numeral'] ?? '',
      relativeroot: row['relativeroot'] ?? '',
      chordType: row['chord_type'] ?? '',
      rootCoordinate: _parseInt(row['root']),
      bassCoordinate: _parseInt(row['bass_note']),
    );
  }
}

class _AbsoluteKeyCenter {
  const _AbsoluteKeyCenter({
    required this.fifths,
    required this.tonicName,
    required this.mode,
  });

  final int fifths;
  final String tonicName;
  final KeyMode mode;

  String get displayName => '$tonicName ${mode.name}';
}

const Set<String> _supportedChordTypes = <String>{
  'M',
  'm',
  'Mm7',
  'MM7',
  'mm7',
  'o',
  'o7',
  '%7',
  '+',
  '+7',
};

const Map<String, int> _romanOffsets = <String, int>{
  'I': 0,
  'II': 2,
  'III': 4,
  'IV': -1,
  'V': 1,
  'VI': 3,
  'VII': 5,
};

const Map<String, int> _noteLetterFifths = <String, int>{
  'F': -1,
  'C': 0,
  'G': 1,
  'D': 2,
  'A': 3,
  'E': 4,
  'B': 5,
};

Map<String, _AbcMetadataRow> _metadataByPiece(String metadataPath) {
  return <String, _AbcMetadataRow>{
    for (final row in _readTsv(metadataPath))
      if ((row['piece'] ?? '').isNotEmpty)
        row['piece']!: _AbcMetadataRow.fromTsv(row),
  };
}

Map<String, int> _countReasons(Iterable<String> reasons) {
  final counts = <String, int>{};
  for (final reason in reasons) {
    counts.update(reason, (count) => count + 1, ifAbsent: () => 1);
  }
  return Map<String, int>.fromEntries(
    counts.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value)),
  );
}

List<Map<String, String>> _readTsv(String path) {
  final lines = File(path)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .toList(growable: false);
  if (lines.isEmpty) {
    return const <Map<String, String>>[];
  }
  final header = lines.first.split('\t');
  final rows = <Map<String, String>>[];
  for (final line in lines.skip(1)) {
    final values = line.split('\t');
    final padded = values.length >= header.length
        ? values
        : [
            ...values,
            ...List<String>.filled(header.length - values.length, ''),
          ];
    rows.add(<String, String>{
      for (var index = 0; index < header.length; index += 1)
        header[index]: index < padded.length ? padded[index] : '',
    });
  }
  return rows;
}

String _buildProgressionInput(List<_PreparedSegment> segments) {
  final parts = <String>[];
  int? lastMeasure;
  for (final prepared in segments) {
    if (lastMeasure != null && prepared.measureNumber != lastMeasure) {
      parts.add('|');
    }
    parts.add(prepared.segment.expectedResolvedSymbol!);
    lastMeasure = prepared.measureNumber;
  }
  return parts.join(' ');
}

_AbsoluteKeyCenter _resolveAbsoluteKey({
  required String globalKeyToken,
  required String localKeyToken,
}) {
  final global = _parseAbsoluteKeyToken(globalKeyToken);
  if (localKeyToken.trim().isEmpty || localKeyToken.trim() == 'I') {
    return _AbsoluteKeyCenter(
      fifths: global.fifths,
      tonicName: global.tonicName,
      mode: KeyMode.major,
    );
  }
  if (localKeyToken.trim() == 'i') {
    return _AbsoluteKeyCenter(
      fifths: global.fifths,
      tonicName: global.tonicName,
      mode: KeyMode.minor,
    );
  }
  final relative = _parseRelativeKeyToken(localKeyToken);
  final absoluteFifths = global.fifths + relative.$1;
  return _AbsoluteKeyCenter(
    fifths: absoluteFifths,
    tonicName: _noteFromFifths(absoluteFifths),
    mode: relative.$2,
  );
}

_AbsoluteKeyCenter _parseAbsoluteKeyToken(String token) {
  final trimmed = token.trim();
  final match = RegExp(r'^([A-Ga-g])([#b]*)$').firstMatch(trimmed);
  if (match == null) {
    throw FormatException('Unsupported ABC key token: $token');
  }
  final letter = match.group(1)!.toUpperCase();
  final accidentals = match.group(2)!;
  final mode = match.group(1) == match.group(1)!.toUpperCase()
      ? KeyMode.major
      : KeyMode.minor;
  final base = _noteLetterFifths[letter]!;
  final fifths =
      base +
      '#'.allMatches(accidentals).length * 7 -
      'b'.allMatches(accidentals).length * 7;
  return _AbsoluteKeyCenter(
    fifths: fifths,
    tonicName: _noteFromFifths(fifths),
    mode: mode,
  );
}

(int, KeyMode) _parseRelativeKeyToken(String token) {
  final trimmed = token.trim();
  final match = RegExp(r'^([#b]*)([ivIV]+)$').firstMatch(trimmed);
  if (match == null) {
    throw FormatException('Unsupported ABC relative key token: $token');
  }
  final accidentalPrefix = match.group(1)!;
  final numeral = match.group(2)!;
  final roman = numeral.toUpperCase();
  final baseOffset = _romanOffsets[roman];
  if (baseOffset == null) {
    throw FormatException('Unsupported ABC relative key numeral: $token');
  }
  final accidentalOffset =
      '#'.allMatches(accidentalPrefix).length * 7 -
      'b'.allMatches(accidentalPrefix).length * 7;
  final mode = numeral == roman ? KeyMode.major : KeyMode.minor;
  return (baseOffset + accidentalOffset, mode);
}

String _noteFromFifths(int fifths) {
  const letters = <String>['F', 'C', 'G', 'D', 'A', 'E', 'B'];
  final shifted = fifths + 1;
  final letterIndex = ((shifted % 7) + 7) % 7;
  final letter = letters[letterIndex];
  final accidentalCount = _floorDiv(shifted - letterIndex, 7);
  if (accidentalCount > 0) {
    return '$letter${'#' * accidentalCount}';
  }
  if (accidentalCount < 0) {
    return '$letter${'b' * (-accidentalCount)}';
  }
  return letter;
}

int _floorDiv(int dividend, int divisor) {
  final quotient = dividend ~/ divisor;
  final remainder = dividend % divisor;
  if (remainder == 0 || dividend >= 0) {
    return quotient;
  }
  return quotient - 1;
}

bool _isAnalyzerCompatibleNote(String note) =>
    RegExp(r'^[A-G](?:#|b)?$').hasMatch(note);

String _renderChordSymbol({
  required String rootNote,
  required String? bassNote,
  required String chordType,
}) {
  final suffix = switch (chordType) {
    'M' => '',
    'm' => 'm',
    'Mm7' => '7',
    'MM7' => 'maj7',
    'mm7' => 'm7',
    'o' => 'dim',
    'o7' => 'dim7',
    '%7' => 'm7b5',
    '+' => 'aug',
    '+7' => '7#5',
    _ => '',
  };
  final bassSuffix = bassNote == null || bassNote == rootNote
      ? ''
      : '/$bassNote';
  return '$rootNote$suffix$bassSuffix';
}

String _renderHarteSymbol({
  required String rootNote,
  required String? bassNote,
  required String chordType,
}) {
  final quality = switch (chordType) {
    'M' => 'maj',
    'm' => 'min',
    'Mm7' => '7',
    'MM7' => 'maj7',
    'mm7' => 'min7',
    'o' => 'dim',
    'o7' => 'dim7',
    '%7' => 'hdim7',
    '+' => 'aug',
    '+7' => 'aug7',
    _ => 'maj',
  };
  final bassSuffix = bassNote == null || bassNote == rootNote
      ? ''
      : '/$bassNote';
  return '$rootNote:$quality$bassSuffix';
}

String _canonicalRomanToken(_AbcHarmonyRow row) {
  final base = _normalizeRomanBase(row.numeral);
  final suffix = switch (row.chordType) {
    'M' => '',
    'm' => 'm',
    'Mm7' => '7',
    'MM7' => 'maj7',
    'mm7' => 'm7',
    'o' => 'dim',
    'o7' => 'dim7',
    '%7' => 'm7b5',
    '+' => 'aug',
    '+7' => '7#5',
    _ => '',
  };
  if (row.relativeroot.trim().isEmpty) {
    return '$base$suffix';
  }
  return '$base$suffix/${_normalizeRomanBase(row.relativeroot)}';
}

String _normalizeRomanBase(String token) {
  final match = RegExp(r'^([#b]*)([ivIV]+)$').firstMatch(token.trim());
  if (match == null) {
    return token.trim();
  }
  return '${match.group(1)!}${match.group(2)!.toUpperCase()}';
}

String _expectedFunction(String numeralToken) {
  final base = _normalizeRomanBase(
    numeralToken,
  ).replaceAll(RegExp(r'^[#b]+'), '');
  return switch (base) {
    'I' || 'III' || 'VI' => 'tonic',
    'II' || 'IV' => 'predominant',
    'V' || 'VII' => 'dominant',
    _ => 'other',
  };
}

int? _parseInt(String? value) => int.tryParse((value ?? '').trim());
