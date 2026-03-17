import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/chord_theory.dart';

import '../chord_analyzer_external_gold_schema.dart';

const String _whenInRomeCorpusId = 'when_in_rome_rntxt_excerpt';
const String _whenInRomeCorpusName = 'When in Rome RomanText Excerpts';
const String _whenInRomeSourceUrl =
    'https://github.com/MarkGotham/When-in-Rome';
const String _whenInRomeLicenseNote =
    'Source analyses from When in Rome (CC BY-SA 4.0). '
    'Selection provenance is documented in '
    'tool/benchmark_fixtures/external_gold/when_in_rome/README.md.';

class WhenInRomeExternalGoldImportResult {
  const WhenInRomeExternalGoldImportResult({
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
  final List<WhenInRomeSkippedItem> skippedRecords;
  final List<WhenInRomeSkippedItem> skippedSegments;
  final int rawRecordCount;
  final int rawSegmentCount;
  final int keptSegmentCount;
  final Map<String, WhenInRomeSourceCoverage> coverageBySourceId;
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

class WhenInRomeSourceCoverage {
  const WhenInRomeSourceCoverage({
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

class WhenInRomeSkippedItem {
  const WhenInRomeSkippedItem({
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

class WhenInRomeExternalGoldAdapter {
  const WhenInRomeExternalGoldAdapter();

  WhenInRomeExternalGoldImportResult importSelectionManifest({
    required String sourceCorpusRoot,
    required String selectionManifestPath,
    String? manifestOutputPath,
  }) {
    final root = Directory(sourceCorpusRoot);
    final selectionFile = File(selectionManifestPath);
    if (!root.existsSync()) {
      throw FileSystemException(
        'When in Rome source root not found',
        root.path,
      );
    }
    if (!selectionFile.existsSync()) {
      throw FileSystemException(
        'When in Rome selection manifest not found',
        selectionFile.path,
      );
    }

    final selections = [
      for (final row in _readTsv(selectionFile.path))
        _WhenInRomeSelectionRow.fromTsv(row),
    ];
    final parsedCache = <String, _ParsedWhenInRomeAnalysis>{};
    final skippedRecords = <WhenInRomeSkippedItem>[];
    final skippedSegments = <WhenInRomeSkippedItem>[];
    final records = <ExternalGoldRecord>[];
    final coverageBuilders = <String, _MutableCoverage>{};
    var rawSegmentCount = 0;
    var keptSegmentCount = 0;

    for (final selection in selections) {
      final sourceCoverage = coverageBuilders.putIfAbsent(
        selection.sourceId,
        () => _MutableCoverage(selection.sourceId),
      );
      sourceCoverage.rawRecordCount += 1;

      final analysisPath = _resolvePath(
        root.path,
        selection.relativeAnalysisPath,
      );
      final analysisFile = File(analysisPath);
      final recordId =
          '${selection.sourceId}-mm${selection.measureStart}-${selection.measureEnd}';

      if (!analysisFile.existsSync()) {
        skippedRecords.add(
          WhenInRomeSkippedItem(
            sourceId: selection.sourceId,
            recordId: recordId,
            reason: 'missing_analysis_file',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      final parsedAnalysis = parsedCache.putIfAbsent(
        analysisFile.path,
        () => _parseAnalysisFile(analysisFile.path),
      );
      final rawEvents = [
        for (final event in parsedAnalysis.events)
          if (event.measureNumber >= selection.measureStart &&
              event.measureNumber <= selection.measureEnd)
            event,
      ];
      rawSegmentCount += rawEvents.length;
      sourceCoverage.rawSegmentCount += rawEvents.length;

      if (rawEvents.isEmpty) {
        skippedRecords.add(
          WhenInRomeSkippedItem(
            sourceId: selection.sourceId,
            recordId: recordId,
            reason: 'empty_measure_window',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      final preparedSegments = <_PreparedWhenInRomeSegment>[];
      for (var index = 0; index < rawEvents.length; index += 1) {
        final prepared = _convertEvent(
          sourceId: selection.sourceId,
          recordId: recordId,
          eventIndex: index,
          event: rawEvents[index],
          skippedSegments: skippedSegments,
        );
        if (prepared != null) {
          preparedSegments.add(prepared);
        }
      }

      if (preparedSegments.length < 2) {
        skippedRecords.add(
          WhenInRomeSkippedItem(
            sourceId: selection.sourceId,
            recordId: recordId,
            reason: 'insufficient_supported_segments',
          ),
        );
        sourceCoverage.skippedRecordCount += 1;
        continue;
      }

      final firstKey = preparedSegments.first.expectedKeyCenter;
      final rowLevelSkippedCount = skippedSegments
          .where((item) => item.recordId == recordId)
          .length;
      final movementSection =
          'mm ${selection.measureStart}-${selection.measureEnd}';
      final titleBase = parsedAnalysis.header.title?.isNotEmpty == true
          ? parsedAnalysis.header.title!
          : selection.sourceId;

      records.add(
        ExternalGoldRecord(
          recordId: recordId,
          sourceId: selection.sourceId,
          genreFamily: 'classical',
          workId: selection.sourceId,
          title: '$titleBase ($movementSection)',
          composerOrArtist: parsedAnalysis.header.composer,
          movementOrSection: movementSection,
          progressionInput: _buildProgressionInput(preparedSegments),
          primaryKey: firstKey.tonicName,
          primaryMode: firstKey.mode,
          annotationLevel: ExternalGoldAnnotationLevel.roman,
          alignmentType: ExternalGoldAlignmentType.symbolic,
          keyScope: ExternalGoldKeyScope.localExcerpt,
          segmentationScope: ExternalGoldSegmentationScope.measureWindow,
          splitTag: 'external_eval',
          licenseNotes: _whenInRomeLicenseNote,
          globalKey: firstKey.displayName,
          localKey: firstKey.displayName,
          confidenceOrAgreement: 'expert annotation',
          segments: [for (final prepared in preparedSegments) prepared.segment],
          metadata: <String, Object?>{
            'sourceRepository': _whenInRomeSourceUrl,
            'relativeAnalysisPath': selection.relativeAnalysisPath,
            'selectionNote': selection.selectionNote,
            'selectionMeasureStart': selection.measureStart,
            'selectionMeasureEnd': selection.measureEnd,
            'analysisAnalyst': parsedAnalysis.header.analyst,
            'analysisProofreader': parsedAnalysis.header.proofreader,
            'rawSegmentCount': rawEvents.length,
            'keptSegmentCount': preparedSegments.length,
            'rowLevelSkippedSegmentCount': rowLevelSkippedCount,
            'progressionInputDerivedFromRoman': true,
            if (selectionManifestPath.isNotEmpty)
              'selectionManifestPath': selectionManifestPath,
            'sourceCorpusRootPath': root.path,
          },
        ),
      );

      sourceCoverage.loadedRecordCount += 1;
      sourceCoverage.keptSegmentCount += preparedSegments.length;
      keptSegmentCount += preparedSegments.length;
    }

    final manifest = ExternalGoldCorpusManifest(
      corpusId: _whenInRomeCorpusId,
      corpusName: _whenInRomeCorpusName,
      adapterVersion: '0.1.0',
      sourceUrl: _whenInRomeSourceUrl,
      licenseNote: _whenInRomeLicenseNote,
      records: records,
    );
    final result = WhenInRomeExternalGoldImportResult(
      manifest: manifest,
      skippedRecords: skippedRecords,
      skippedSegments: skippedSegments,
      rawRecordCount: selections.length,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
      coverageBySourceId: {
        for (final entry
            in (coverageBuilders.entries.toList()
              ..sort((left, right) => left.key.compareTo(right.key))))
          entry.key: entry.value.build(),
      },
      importMode: 'selection_manifest',
      fixtureDirectory: selectionFile.parent.path,
      selectionManifestPath: selectionFile.path,
      sourceCorpusRootPath: root.path,
    );

    if (manifestOutputPath != null) {
      result.writeManifest(manifestOutputPath);
    }

    return result;
  }

  _ParsedWhenInRomeAnalysis _parseAnalysisFile(String path) {
    final header = <String, String>{};
    final events = <_WhenInRomeEvent>[];
    _RomanKeyContext? currentKey;

    for (final rawLine in File(path).readAsLinesSync()) {
      final line = rawLine.trim();
      if (line.isEmpty ||
          line.startsWith('Note:') ||
          line.startsWith('Time Signature:') ||
          line.startsWith('Tempo:') ||
          line.startsWith('Form:') ||
          line.startsWith('Pedal:')) {
        continue;
      }

      final measureMatch = RegExp(
        r'^m(\d+)(?:-(\d+))?\s*(.*)$',
      ).firstMatch(line);
      if (measureMatch == null) {
        final headerMatch = RegExp(r'^([^:]+):\s*(.+)$').firstMatch(line);
        if (headerMatch != null) {
          header[headerMatch.group(1)!.trim()] = headerMatch.group(2)!.trim();
        }
        continue;
      }

      final measureNumber = int.parse(measureMatch.group(1)!);
      final body = measureMatch.group(3)?.trim() ?? '';
      if (body.isEmpty || body.contains('=')) {
        continue;
      }

      final tokens = body
          .split(RegExp(r'\s+'))
          .where((token) => token.isNotEmpty)
          .toList(growable: false);
      var beatText = '1';
      for (var index = 0; index < tokens.length; index += 1) {
        final token = tokens[index];
        if (_isBeatToken(token)) {
          beatText = token.substring(1);
          continue;
        }
        if (token == '||') {
          continue;
        }

        String? eventToken = token;
        if (token.endsWith(':')) {
          final parsedKey = _parseKeyToken(
            token.substring(0, token.length - 1),
          );
          if (parsedKey != null) {
            currentKey = parsedKey;
            eventToken = null;
          }
        } else if (token.contains(':')) {
          final separator = token.indexOf(':');
          final parsedKey = _parseKeyToken(token.substring(0, separator));
          if (parsedKey != null) {
            currentKey = parsedKey;
            final trailing = token.substring(separator + 1).trim();
            eventToken = trailing.isEmpty ? null : trailing;
          }
        }

        if (eventToken == null || eventToken.isEmpty) {
          continue;
        }
        if (currentKey == null) {
          continue;
        }

        events.add(
          _WhenInRomeEvent(
            measureNumber: measureNumber,
            beatText: beatText,
            surfaceRoman: eventToken,
            keyContext: currentKey,
          ),
        );
      }
    }

    return _ParsedWhenInRomeAnalysis(
      header: _WhenInRomeHeader(
        composer: header['Composer'],
        title: header['Title'] ?? header['Piece'],
        analyst: header['Analyst'],
        proofreader: header['Proofreader'],
      ),
      events: events,
    );
  }

  _PreparedWhenInRomeSegment? _convertEvent({
    required String sourceId,
    required String recordId,
    required int eventIndex,
    required _WhenInRomeEvent event,
    required List<WhenInRomeSkippedItem> skippedSegments,
  }) {
    final parsedRoman = _parseRomanSurface(
      event.surfaceRoman,
      event.keyContext,
    );
    if (parsedRoman == null) {
      skippedSegments.add(
        WhenInRomeSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          measureNumber: event.measureNumber,
          label: event.surfaceRoman,
          reason: 'unsupported_roman_surface',
        ),
      );
      return null;
    }

    final root = parsedRoman.rootNote;
    final bass = parsedRoman.bassNote;
    if (!_isAnalyzerCompatibleNote(root) ||
        (bass != null && !_isAnalyzerCompatibleNote(bass))) {
      skippedSegments.add(
        WhenInRomeSkippedItem(
          sourceId: sourceId,
          recordId: recordId,
          measureNumber: event.measureNumber,
          label: event.surfaceRoman,
          reason: 'unsupported_spelling:$root${bass == null ? '' : '/$bass'}',
        ),
      );
      return null;
    }

    final resolvedSymbol = _renderChordSymbol(
      root: root,
      quality: parsedRoman.quality,
      bass: bass,
    );
    final canonicalRoman = parsedRoman.canonicalRoman;
    return _PreparedWhenInRomeSegment(
      measureNumber: event.measureNumber,
      expectedKeyCenter: event.keyContext.keyCenter,
      segment: ExternalGoldSegment(
        index: eventIndex,
        chordRaw: resolvedSymbol,
        chordNormHarte: resolvedSymbol,
        expectedKey: event.keyContext.keyCenter.tonicName,
        expectedMode: event.keyContext.keyCenter.mode,
        surfaceRomanLabel: event.surfaceRoman,
        canonicalRomanLabel: canonicalRoman,
        expectedFunction: _expectedFunction(canonicalRoman),
        expectedResolvedSymbol: resolvedSymbol,
        bassOrInversion: bass,
        note:
            'measure=${event.measureNumber}; beat=${event.beatText}; '
            'sourceRoman=${event.surfaceRoman}; localKey='
            '${event.keyContext.keyCenter.displayName}',
      ),
    );
  }
}

class _WhenInRomeSelectionRow {
  const _WhenInRomeSelectionRow({
    required this.sourceId,
    required this.relativeAnalysisPath,
    required this.measureStart,
    required this.measureEnd,
    required this.selectionNote,
  });

  final String sourceId;
  final String relativeAnalysisPath;
  final int measureStart;
  final int measureEnd;
  final String selectionNote;

  factory _WhenInRomeSelectionRow.fromTsv(Map<String, String> row) {
    return _WhenInRomeSelectionRow(
      sourceId: row['source_id']!.trim(),
      relativeAnalysisPath: row['relative_analysis_path']!.trim(),
      measureStart: int.parse(row['measure_start']!.trim()),
      measureEnd: int.parse(row['measure_end']!.trim()),
      selectionNote: row['selection_note']?.trim() ?? '',
    );
  }
}

class _WhenInRomeHeader {
  const _WhenInRomeHeader({
    this.composer,
    this.title,
    this.analyst,
    this.proofreader,
  });

  final String? composer;
  final String? title;
  final String? analyst;
  final String? proofreader;
}

class _ParsedWhenInRomeAnalysis {
  const _ParsedWhenInRomeAnalysis({required this.header, required this.events});

  final _WhenInRomeHeader header;
  final List<_WhenInRomeEvent> events;
}

class _WhenInRomeEvent {
  const _WhenInRomeEvent({
    required this.measureNumber,
    required this.beatText,
    required this.surfaceRoman,
    required this.keyContext,
  });

  final int measureNumber;
  final String beatText;
  final String surfaceRoman;
  final _RomanKeyContext keyContext;
}

class _PreparedWhenInRomeSegment {
  const _PreparedWhenInRomeSegment({
    required this.measureNumber,
    required this.expectedKeyCenter,
    required this.segment,
  });

  final int measureNumber;
  final KeyCenter expectedKeyCenter;
  final ExternalGoldSegment segment;
}

class _MutableCoverage {
  _MutableCoverage(this.sourceId);

  final String sourceId;
  int rawRecordCount = 0;
  int loadedRecordCount = 0;
  int skippedRecordCount = 0;
  int rawSegmentCount = 0;
  int keptSegmentCount = 0;

  WhenInRomeSourceCoverage build() {
    return WhenInRomeSourceCoverage(
      sourceId: sourceId,
      rawRecordCount: rawRecordCount,
      loadedRecordCount: loadedRecordCount,
      skippedRecordCount: skippedRecordCount,
      rawSegmentCount: rawSegmentCount,
      keptSegmentCount: keptSegmentCount,
    );
  }
}

class _RomanKeyContext {
  const _RomanKeyContext({
    required this.tonicPitch,
    required this.keyCenter,
    required this.preferFlat,
  });

  final String tonicPitch;
  final KeyCenter keyCenter;
  final bool preferFlat;
}

class _ParsedRomanSurface {
  const _ParsedRomanSurface({
    required this.rootNote,
    required this.bassNote,
    required this.quality,
    required this.canonicalRoman,
  });

  final String rootNote;
  final String? bassNote;
  final ChordQuality quality;
  final String canonicalRoman;
}

class _RomanDegree {
  const _RomanDegree({
    required this.accidentalOffset,
    required this.accidentalToken,
    required this.romanLetters,
  });

  final int accidentalOffset;
  final String accidentalToken;
  final String romanLetters;

  bool get isMinorLike => romanLetters == romanLetters.toLowerCase();

  int get degreeNumber => switch (romanLetters.toUpperCase()) {
    'I' => 1,
    'II' => 2,
    'III' => 3,
    'IV' => 4,
    'V' => 5,
    'VI' => 6,
    'VII' => 7,
    _ => 1,
  };

  String get canonicalToken => '$accidentalToken${romanLetters.toUpperCase()}';
}

Map<String, int> _countReasons(Iterable<String> reasons) {
  final counts = <String, int>{};
  for (final reason in reasons) {
    counts.update(reason, (value) => value + 1, ifAbsent: () => 1);
  }
  return counts;
}

String _resolvePath(String root, String relativePath) {
  final normalized = relativePath.replaceAll('/', Platform.pathSeparator);
  return '$root${Platform.pathSeparator}$normalized';
}

Iterable<Map<String, String>> _readTsv(String path) sync* {
  final lines = File(path).readAsLinesSync();
  if (lines.isEmpty) {
    return;
  }
  final headers = _splitTsvLine(lines.first);
  for (final rawLine in lines.skip(1)) {
    if (rawLine.trim().isEmpty) {
      continue;
    }
    final values = _splitTsvLine(rawLine);
    yield <String, String>{
      for (var index = 0; index < headers.length; index += 1)
        headers[index]: index < values.length ? values[index] : '',
    };
  }
}

List<String> _splitTsvLine(String line) => line.split('\t');

bool _isBeatToken(String token) => RegExp(r'^b\d+(?:\.\d+)?$').hasMatch(token);

_RomanKeyContext? _parseKeyToken(String token) {
  final match = RegExp(r'^([A-Ga-g])([#b]?)(.*)$').firstMatch(token.trim());
  if (match == null) {
    return null;
  }
  final letter = match.group(1)!;
  final accidental = match.group(2) ?? '';
  final tonicPitch = '${letter.toUpperCase()}$accidental';
  final semitone = MusicTheory.noteToSemitone[tonicPitch];
  if (semitone == null) {
    return null;
  }
  final mode = letter == letter.toLowerCase() ? KeyMode.minor : KeyMode.major;
  final preferFlat =
      accidental == 'b' ||
      (accidental.isEmpty &&
          MusicTheory.prefersFlatSpellingForRoot(tonicPitch));
  final keyName = _keyOptionForSemitone(semitone, preferFlat: preferFlat);
  return _RomanKeyContext(
    tonicPitch: tonicPitch,
    keyCenter: KeyCenter(tonicName: keyName, mode: mode),
    preferFlat: preferFlat,
  );
}

String _keyOptionForSemitone(int semitone, {required bool preferFlat}) {
  final normalized = semitone % 12;
  final matches = [
    for (final key in MusicTheory.keyOptions)
      if (MusicTheory.keyTonicSemitone(key) == normalized) key,
  ];
  if (matches.isEmpty) {
    return MusicTheory.spellPitch(normalized, preferFlat: preferFlat);
  }
  for (final key in matches) {
    if (MusicTheory.prefersFlatSpellingForKey(key) == preferFlat) {
      return key;
    }
  }
  return matches.first;
}

enum _SpecialRomanType {
  none,
  cadential64,
  neapolitan,
  italianSixth,
  frenchSixth,
  germanSixth,
}

class _ParsedRomanHead {
  const _ParsedRomanHead({
    required this.special,
    required this.degree,
    required this.qualityMarker,
    required this.figure,
  });

  final _SpecialRomanType special;
  final _RomanDegree? degree;
  final String? qualityMarker;
  final String? figure;
}

_ParsedRomanSurface? _parseRomanSurface(
  String surfaceRoman,
  _RomanKeyContext keyContext,
) {
  final normalized = _normalizeRomanSurface(surfaceRoman);
  if (normalized.isEmpty) {
    return null;
  }

  final slashIndex = normalized.indexOf('/');
  final headToken = slashIndex >= 0
      ? normalized.substring(0, slashIndex)
      : normalized;
  final targetToken = slashIndex >= 0
      ? normalized.substring(slashIndex + 1)
      : null;
  final parsedHead = _parseRomanHead(headToken);
  if (parsedHead == null) {
    return null;
  }

  if (parsedHead.special == _SpecialRomanType.italianSixth ||
      parsedHead.special == _SpecialRomanType.frenchSixth ||
      parsedHead.special == _SpecialRomanType.germanSixth) {
    return null;
  }

  final effectiveKey = targetToken == null
      ? keyContext
      : _resolveAppliedTargetKey(targetToken, keyContext);
  if (effectiveKey == null) {
    return null;
  }

  final rootNote = switch (parsedHead.special) {
    _SpecialRomanType.cadential64 => effectiveKey.tonicPitch,
    _SpecialRomanType.neapolitan => _degreeNote(
      degreeNumber: 2,
      accidentalOffset: -1,
      keyContext: effectiveKey,
      preferFlatHint: true,
    ),
    _SpecialRomanType.none => _degreeNote(
      degreeNumber: parsedHead.degree!.degreeNumber,
      accidentalOffset: parsedHead.degree!.accidentalOffset,
      keyContext: effectiveKey,
      preferFlatHint: parsedHead.degree!.accidentalToken.contains('b'),
    ),
    _ => null,
  };
  if (rootNote == null) {
    return null;
  }

  final quality = _qualityForRomanHead(parsedHead);
  final inversion = _inversionForRomanHead(parsedHead);
  final bassNote = inversion == 0
      ? null
      : _bassForInversion(
          rootNote: rootNote,
          quality: quality,
          inversion: inversion,
          preferFlat: rootNote.contains('b') || effectiveKey.preferFlat,
        );
  final canonicalHead = switch (parsedHead.special) {
    _SpecialRomanType.cadential64 => 'I',
    _SpecialRomanType.neapolitan => 'bII',
    _SpecialRomanType.none =>
      '${parsedHead.degree!.canonicalToken}${_canonicalSuffixForQuality(quality)}',
    _ => null,
  };
  if (canonicalHead == null) {
    return null;
  }
  final canonicalRoman = targetToken == null
      ? canonicalHead
      : '$canonicalHead/${_canonicalAppliedTarget(targetToken)}';

  return _ParsedRomanSurface(
    rootNote: rootNote,
    bassNote: bassNote,
    quality: quality,
    canonicalRoman: canonicalRoman,
  );
}

String _normalizeRomanSurface(String surfaceRoman) {
  return surfaceRoman
      .replaceAll('/o', 'h')
      .replaceAll(RegExp(r'[^\x00-\x7F]'), 'h')
      .replaceAll(RegExp(r'(?<=\d)/(?=\d)'), '')
      .replaceAll(RegExp(r'\[[^\]]*\]'), '')
      .replaceAll(' ', '')
      .trim();
}

_ParsedRomanHead? _parseRomanHead(String token) {
  if (token.startsWith('Cad64')) {
    return const _ParsedRomanHead(
      special: _SpecialRomanType.cadential64,
      degree: null,
      qualityMarker: null,
      figure: '64',
    );
  }
  if (token.startsWith('Ger')) {
    return _ParsedRomanHead(
      special: _SpecialRomanType.germanSixth,
      degree: null,
      qualityMarker: null,
      figure: token.substring(3),
    );
  }
  if (token.startsWith('Fr')) {
    return _ParsedRomanHead(
      special: _SpecialRomanType.frenchSixth,
      degree: null,
      qualityMarker: null,
      figure: token.substring(2),
    );
  }
  if (token.startsWith('It')) {
    return _ParsedRomanHead(
      special: _SpecialRomanType.italianSixth,
      degree: null,
      qualityMarker: null,
      figure: token.substring(2),
    );
  }
  if (token.startsWith('N')) {
    return _ParsedRomanHead(
      special: _SpecialRomanType.neapolitan,
      degree: null,
      qualityMarker: null,
      figure: token.substring(1),
    );
  }

  final match = RegExp(
    r'^([#b]*)([IViv]+)(h|o|\+)?([0-9]*)$',
  ).firstMatch(token);
  if (match == null) {
    return null;
  }

  return _ParsedRomanHead(
    special: _SpecialRomanType.none,
    degree: _RomanDegree(
      accidentalOffset: _accidentalOffset(match.group(1)!),
      accidentalToken: match.group(1)!,
      romanLetters: match.group(2)!,
    ),
    qualityMarker: match.group(3),
    figure: match.group(4),
  );
}

int _accidentalOffset(String token) {
  var offset = 0;
  for (final rune in token.runes) {
    if (rune == '#'.codeUnitAt(0)) {
      offset += 1;
    } else if (rune == 'b'.codeUnitAt(0)) {
      offset -= 1;
    }
  }
  return offset;
}

_RomanKeyContext? _resolveAppliedTargetKey(
  String targetToken,
  _RomanKeyContext currentKey,
) {
  final parsedTarget = _parseRomanHead(targetToken);
  if (parsedTarget == null || parsedTarget.degree == null) {
    return null;
  }
  final targetRoot = _degreeNote(
    degreeNumber: parsedTarget.degree!.degreeNumber,
    accidentalOffset: parsedTarget.degree!.accidentalOffset,
    keyContext: currentKey,
    preferFlatHint: parsedTarget.degree!.accidentalToken.contains('b'),
  );
  final semitone = MusicTheory.noteToSemitone[targetRoot];
  if (semitone == null) {
    return null;
  }
  final mode = parsedTarget.degree!.isMinorLike ? KeyMode.minor : KeyMode.major;
  final preferFlat =
      parsedTarget.degree!.accidentalToken.contains('b') ||
      targetRoot.contains('b');
  final keyName = _keyOptionForSemitone(semitone, preferFlat: preferFlat);
  return _RomanKeyContext(
    tonicPitch: targetRoot,
    keyCenter: KeyCenter(tonicName: keyName, mode: mode),
    preferFlat: preferFlat,
  );
}

String _degreeNote({
  required int degreeNumber,
  required int accidentalOffset,
  required _RomanKeyContext keyContext,
  required bool preferFlatHint,
}) {
  final tonicSemitone = MusicTheory.noteToSemitone[keyContext.tonicPitch] ?? 0;
  final baseOffset = (keyContext.keyCenter.mode == KeyMode.major
      ? const [0, 2, 4, 5, 7, 9, 11]
      : const [0, 2, 3, 5, 7, 8, 10])[degreeNumber - 1];
  final semitone = (tonicSemitone + baseOffset + accidentalOffset) % 12;
  return MusicTheory.spellPitch(
    semitone,
    preferFlat: preferFlatHint || keyContext.preferFlat,
  );
}

ChordQuality _qualityForRomanHead(_ParsedRomanHead parsedHead) {
  if (parsedHead.special == _SpecialRomanType.cadential64) {
    return ChordQuality.majorTriad;
  }
  if (parsedHead.special == _SpecialRomanType.neapolitan) {
    return ChordQuality.majorTriad;
  }

  final figure = parsedHead.figure ?? '';
  final hasSeventh =
      figure == '7' ||
      figure == '65' ||
      figure == '43' ||
      figure == '42' ||
      figure == '2';
  final degree = parsedHead.degree!;
  final marker = parsedHead.qualityMarker;
  if (marker == 'o') {
    return hasSeventh ? ChordQuality.diminished7 : ChordQuality.diminishedTriad;
  }
  if (marker == 'h') {
    return ChordQuality.halfDiminished7;
  }
  if (marker == '+') {
    return ChordQuality.augmentedTriad;
  }
  if (degree.isMinorLike) {
    return hasSeventh ? ChordQuality.minor7 : ChordQuality.minorTriad;
  }
  if (hasSeventh) {
    return degree.romanLetters.toUpperCase() == 'V'
        ? ChordQuality.dominant7
        : ChordQuality.major7;
  }
  return ChordQuality.majorTriad;
}

int _inversionForRomanHead(_ParsedRomanHead parsedHead) {
  if (parsedHead.special == _SpecialRomanType.cadential64) {
    return 2;
  }
  if (parsedHead.special == _SpecialRomanType.neapolitan) {
    return (parsedHead.figure == '64') ? 2 : 1;
  }
  final figure = parsedHead.figure ?? '';
  switch (figure) {
    case '6':
      return 1;
    case '64':
      return 2;
    case '7':
      return 0;
    case '65':
      return 1;
    case '43':
      return 2;
    case '42':
    case '2':
      return 3;
    default:
      return 0;
  }
}

String? _bassForInversion({
  required String rootNote,
  required ChordQuality quality,
  required int inversion,
  required bool preferFlat,
}) {
  final formula = ChordToneFormulaLibrary.formulaFor(quality);
  if (inversion >= formula.length) {
    return null;
  }
  return MusicTheory.transposePitch(
    rootNote,
    formula[inversion],
    preferFlat: preferFlat,
  );
}

String _canonicalSuffixForQuality(ChordQuality quality) {
  return switch (quality) {
    ChordQuality.majorTriad => '',
    ChordQuality.minorTriad => 'm',
    ChordQuality.dominant7 => '7',
    ChordQuality.major7 => 'maj7',
    ChordQuality.minor7 => 'm7',
    ChordQuality.halfDiminished7 => 'm7b5',
    ChordQuality.diminishedTriad => 'dim',
    ChordQuality.diminished7 => 'dim7',
    ChordQuality.augmentedTriad => 'aug',
    ChordQuality.six => '6',
    ChordQuality.minor6 => 'm6',
    ChordQuality.major69 => '6/9',
    ChordQuality.minorMajor7 => 'mMaj7',
    ChordQuality.dominant7Alt => '7alt',
    ChordQuality.dominant7Sharp11 => '7(#11)',
    ChordQuality.dominant13sus4 => '13sus4',
    ChordQuality.dominant7sus4 => '7sus4',
  };
}

String _canonicalAppliedTarget(String token) {
  final parsed = _parseRomanHead(token);
  if (parsed == null || parsed.degree == null) {
    return token;
  }
  return parsed.degree!.canonicalToken;
}

String _renderChordSymbol({
  required String root,
  required ChordQuality quality,
  String? bass,
}) {
  final suffix = switch (quality) {
    ChordQuality.majorTriad => '',
    ChordQuality.minorTriad => 'm',
    ChordQuality.dominant7 => '7',
    ChordQuality.major7 => 'maj7',
    ChordQuality.minor7 => 'm7',
    ChordQuality.minorMajor7 => 'mMaj7',
    ChordQuality.halfDiminished7 => 'm7b5',
    ChordQuality.diminishedTriad => 'dim',
    ChordQuality.diminished7 => 'dim7',
    ChordQuality.augmentedTriad => 'aug',
    ChordQuality.six => '6',
    ChordQuality.minor6 => 'm6',
    ChordQuality.major69 => '6/9',
    ChordQuality.dominant7Alt => '7alt',
    ChordQuality.dominant7Sharp11 => '7(#11)',
    ChordQuality.dominant13sus4 => '13sus4',
    ChordQuality.dominant7sus4 => '7sus4',
  };
  return '$root$suffix${bass == null ? '' : '/$bass'}';
}

bool _isAnalyzerCompatibleNote(String note) {
  return MusicTheory.noteToSemitone.containsKey(note);
}

String _expectedFunction(String canonicalRoman) {
  final normalized = _normalizeRomanForFunction(canonicalRoman);
  if (normalized.startsWith('V') || normalized.startsWith('VII')) {
    return 'dominant';
  }
  if (normalized.startsWith('II') ||
      normalized.startsWith('IV') ||
      normalized.startsWith('bII')) {
    return 'predominant';
  }
  if (normalized.startsWith('I') ||
      normalized.startsWith('III') ||
      normalized.startsWith('VI') ||
      normalized.startsWith('bIII') ||
      normalized.startsWith('bVI')) {
    return 'tonic';
  }
  return 'other';
}

String _normalizeRomanForFunction(String roman) {
  final slashIndex = roman.indexOf('/');
  final head = slashIndex >= 0 ? roman.substring(0, slashIndex) : roman;
  return head.replaceAll(
    RegExp(r'(maj|min|dim|aug|sus|alt|m|M|[0-9]|[#b(),/+])+'),
    '',
  );
}

String _buildProgressionInput(List<_PreparedWhenInRomeSegment> segments) {
  final buffer = StringBuffer();
  var currentMeasure = -1;
  for (final segment in segments) {
    if (currentMeasure != -1 && segment.measureNumber != currentMeasure) {
      buffer.write(' | ');
    } else if (buffer.isNotEmpty) {
      buffer.write(' ');
    }
    buffer.write(segment.segment.expectedResolvedSymbol);
    currentMeasure = segment.measureNumber;
  }
  return buffer.toString().trim();
}
