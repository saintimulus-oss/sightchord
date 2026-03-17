import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/adapters/abc_external_gold_adapter.dart';

void main() {
  const adapter = AbcExternalGoldAdapter();
  final fixtureDir =
      '${Directory.current.path}\\tool\\benchmark_fixtures\\external_gold\\abc';

  test('imports ABC external-gold excerpts into canonical manifest', () {
    final result = adapter.importExcerptDirectory(fixtureDir);
    final manifest = result.manifest;

    expect(manifest.corpusId, 'dcml_abc_excerpt');
    expect(manifest.records, hasLength(3));
    expect(result.skippedRecordCount, 0);
    expect(result.skippedSegmentCount, 0);

    expect(manifest.records[0].sourceId, 'n01op18-1_01');
    expect(manifest.records[0].primaryKey, 'F');
    expect(manifest.records[0].primaryMode.name, 'major');
    expect(
      manifest.records[0].progressionInput,
      'F | Bb/D | C7/E | F Dm Gm/Bb | C C | F | C | F',
    );

    expect(manifest.records[1].sourceId, 'n04op18-4_02');
    expect(manifest.records[1].primaryKey, 'G');
    expect(manifest.records[1].progressionInput, 'D D7 | G | C/E C Am | D7/F# D');

    expect(manifest.records[2].sourceId, 'n13op130_04');
    expect(manifest.records[2].primaryKey, 'C');
    expect(manifest.records[2].progressionInput, 'G7/D | G7 | C | G7/D | G7 | C/E | C C');
    expect(manifest.records[2].segments.first.expectedFunction, 'dominant');
  });
}
