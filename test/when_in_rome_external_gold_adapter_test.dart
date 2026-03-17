import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/adapters/when_in_rome_external_gold_adapter.dart';
import '../tool/benchmark/chord_analyzer_external_gold_schema.dart';

void main() {
  const adapter = WhenInRomeExternalGoldAdapter();
  final selectionManifest =
      '${Directory.current.path}\\tool\\benchmark_fixtures\\external_gold\\when_in_rome\\selection_manifest.tsv';
  final sourceRoot = '${Directory.current.path}\\.codex_tmp\\When-in-Rome';
  final canImport =
      File(selectionManifest).existsSync() &&
      Directory(sourceRoot).existsSync();

  test(
    'imports When in Rome selection manifest into canonical manifest',
    () {
      final result = adapter.importSelectionManifest(
        sourceCorpusRoot: sourceRoot,
        selectionManifestPath: selectionManifest,
      );

      expect(result.manifest.corpusId, 'when_in_rome_rntxt_excerpt');
      expect(result.manifest.records, isNotEmpty);
      expect(result.rawRecordCount, greaterThanOrEqualTo(1));
      expect(result.loadedRecordCount, greaterThanOrEqualTo(1));
      expect(result.rawSegmentCount, greaterThanOrEqualTo(1));
      expect(result.keptSegmentCount, greaterThanOrEqualTo(1));
      expect(
        result.manifest.records.every(
          (record) => record.annotationLevel.name == 'roman',
        ),
        isTrue,
      );
      expect(
        result.manifest.records.every(
          (record) => record.keyScope == ExternalGoldKeyScope.localExcerpt,
        ),
        isTrue,
      );
      expect(
        result
            .manifest
            .records
            .first
            .metadata['progressionInputDerivedFromRoman'],
        isTrue,
      );
    },
    skip: canImport ? false : 'When in Rome checkout not available locally',
  );
}
