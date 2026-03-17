import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/adapters/abc_external_gold_adapter.dart';

String _joinPath(Iterable<String> segments) =>
    segments.join(Platform.pathSeparator);

void main() {
  const adapter = AbcExternalGoldAdapter();
  final fixtureDir = _joinPath(<String>[
    Directory.current.path,
    'tool',
    'benchmark_fixtures',
    'external_gold',
    'abc',
  ]);

  test('imports ABC external-gold excerpts into canonical manifest', () {
    final result = adapter.importExcerptDirectory(fixtureDir);
    final manifest = result.manifest;

    expect(manifest.corpusId, 'dcml_abc_excerpt');
    expect(manifest.records, hasLength(3));
    expect(result.rawRecordCount, 3);
    expect(result.loadedRecordCount, 3);
    expect(result.rawSegmentCount, 27);
    expect(result.keptSegmentCount, 27);
    expect(result.skippedRecordCount, 0);
    expect(result.skippedSegmentCount, 0);

    expect(manifest.records[0].sourceId, 'n01op18-1_01');
    expect(manifest.records[0].primaryKey, 'F');
    expect(manifest.records[0].primaryMode.name, 'major');
    expect(manifest.records[0].toJson()['keyScope'], 'local_excerpt');
    expect(
      manifest.records[0].progressionInput,
      'F | Bb/D | C7/E | F Dm Gm/Bb | C C | F | C | F',
    );
    expect(manifest.records[0].segments.first.surfaceRomanLabel, 'I');
    expect(manifest.records[0].segments.first.canonicalRomanLabel, 'I');

    expect(manifest.records[1].sourceId, 'n04op18-4_02');
    expect(manifest.records[1].primaryKey, 'G');
    expect(
      manifest.records[1].progressionInput,
      'D D7 | G | C/E C Am | D7/F# D',
    );
    expect(manifest.records[1].segments[6].surfaceRomanLabel, 'V65');
    expect(manifest.records[1].segments[6].canonicalRomanLabel, 'V7');

    expect(manifest.records[2].sourceId, 'n13op130_04');
    expect(manifest.records[2].primaryKey, 'C');
    expect(
      manifest.records[2].progressionInput,
      'G7/D | G7 | C | G7/D | G7 | C/E | C C',
    );
    expect(manifest.records[2].segments.first.expectedFunction, 'dominant');
  });

  test(
    'imports ABC excerpts from selection manifest and source corpus root',
    () {
      final tempDir = Directory.systemTemp.createTempSync('abc_adapter_test_');
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final sourceRoot = Directory(_joinPath(<String>[tempDir.path, 'source']))
        ..createSync(recursive: true);
      final sourceHarmonyDir = Directory(
        _joinPath(<String>[sourceRoot.path, 'harmonies']),
      )..createSync(recursive: true);
      final metadataSource = File(
        _joinPath(<String>[fixtureDir, 'metadata.tsv']),
      ).readAsLinesSync();
      File(
        _joinPath(<String>[sourceRoot.path, 'metadata.tsv']),
      ).writeAsStringSync('${metadataSource.first}\n${metadataSource[1]}\n');
      final excerptSource = File(
        _joinPath(<String>[
          fixtureDir,
          'harmonies',
          'n01op18-1_01__mm03-11.harmonies.tsv',
        ]),
      ).readAsStringSync();
      File(
        _joinPath(<String>[
          sourceHarmonyDir.path,
          'n01op18-1_01.harmonies.tsv',
        ]),
      ).writeAsStringSync(excerptSource);
      final selectionPath = _joinPath(<String>[
        tempDir.path,
        'selection_manifest.tsv',
      ]);
      File(selectionPath).writeAsStringSync(
        'source_id\tmeasure_start\tmeasure_end\tselection_note\n'
        'n01op18-1_01\t3\t11\ttest selection\n',
      );

      final result = adapter.importSelectionManifest(
        sourceCorpusRoot: sourceRoot.path,
        selectionManifestPath: selectionPath,
      );

      expect(result.importMode, 'selection_manifest');
      expect(result.rawRecordCount, 1);
      expect(result.loadedRecordCount, 1);
      expect(result.coverageBySourceId['n01op18-1_01']?.rawSegmentCount, 11);
      expect(result.coverageBySourceId['n01op18-1_01']?.keptSegmentCount, 11);
      expect(
        result.manifest.records.single.metadata['selectionNote'],
        'test selection',
      );
    },
  );
}
