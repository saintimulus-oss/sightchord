import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/chord_analyzer_external_gold_schema.dart';

void main() {
  const loader = ExternalGoldLoader();
  final fixturePath =
      '${Directory.current.path}\\tool\\benchmark_fixtures\\curated_gold_schema_example.json';

  test('loads curated gold schema example manifest', () {
    final manifest = loader.loadManifest(fixturePath);

    expect(manifest.corpusId, 'curated_gold_schema_example');
    expect(manifest.records, hasLength(2));
    expect(manifest.records.first.primaryKey, 'C');
    expect(manifest.records.first.primaryMode.name, 'major');
    expect(manifest.records.first.segments.first.expectedFunction, 'tonic');
    expect(manifest.records.last.segments.last.expectedResolvedSymbol, 'G7/B');
  });
}
