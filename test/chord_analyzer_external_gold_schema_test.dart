import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/chord_analyzer_external_gold_schema.dart';

String _joinPath(Iterable<String> segments) =>
    segments.join(Platform.pathSeparator);

void main() {
  const loader = ExternalGoldLoader();
  final fixturePath = _joinPath(<String>[
    Directory.current.path,
    'tool',
    'benchmark_fixtures',
    'curated_gold_schema_example.json',
  ]);

  test('loads curated gold schema example manifest', () {
    final manifest = loader.loadManifest(fixturePath);

    expect(manifest.corpusId, 'curated_gold_schema_example');
    expect(manifest.records, hasLength(2));
    expect(manifest.records.first.primaryKey, 'C');
    expect(manifest.records.first.primaryMode.name, 'major');
    expect(manifest.records.first.keyScope.jsonValue, 'local_excerpt');
    expect(
      manifest.records.first.segments.first.segmentRole,
      ExternalGoldSegmentRole.harmonic,
    );
    expect(
      manifest.records.first.segmentationScope.jsonValue,
      'measure_window',
    );
    expect(manifest.records.first.segments.first.expectedFunction, 'tonic');
    expect(manifest.records.first.segments.first.surfaceRomanLabel, 'Imaj7');
    expect(manifest.records.last.segments.first.canonicalRomanLabel, 'I');
    expect(manifest.records.last.segments[1].isNoChord, isTrue);
    expect(manifest.records.last.segments.last.expectedResolvedSymbol, 'G7/B');
  });
}
