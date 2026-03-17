import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/adapters/jaah_choco_external_gold_adapter.dart';
import '../tool/benchmark/chord_analyzer_external_gold_schema.dart';

String _joinPath(Iterable<String> segments) =>
    segments.join(Platform.pathSeparator);

void main() {
  const adapter = JaahChocoExternalGoldAdapter();
  final fixtureDirectory = _joinPath(<String>[
    Directory.current.path,
    'tool',
    'benchmark_fixtures',
    'external_gold',
    'jaah_choco',
  ]);

  test('imports ChoCo JAAH fixture slice into canonical manifest', () {
    final result = adapter.importExcerptDirectory(fixtureDirectory);

    expect(result.manifest.corpusId, 'jaah_choco_slice');
    expect(result.rawRecordCount, 10);
    expect(result.loadedRecordCount, 10);
    expect(result.skippedRecordCount, 0);
    expect(result.rawSegmentCount, result.keptSegmentCount);
    expect(result.skippedSegmentCount, 0);
    expect(result.skipReasonCounts, isEmpty);
    expect(result.rawNonHarmonicSegmentCount, greaterThan(0));
    expect(
      result.keptNonHarmonicSegmentCount,
      result.rawNonHarmonicSegmentCount,
    );
    expect(
      result.rawHarmonicSegmentCount + result.rawNonHarmonicSegmentCount,
      result.rawSegmentCount,
    );
    expect(
      result.manifest.records.every(
        (record) =>
            record.annotationLevel == ExternalGoldAnnotationLevel.surface,
      ),
      isTrue,
    );
    expect(
      result.manifest.records.every(
        (record) => record.keyScope == ExternalGoldKeyScope.globalMovement,
      ),
      isTrue,
    );
    expect(
      result.manifest.records.every(
        (record) =>
            record.segmentationScope ==
            ExternalGoldSegmentationScope.fullMovement,
      ),
      isTrue,
    );
    expect(
      result.manifest.records.every(
        (record) =>
            record.alignmentType == ExternalGoldAlignmentType.audioAligned,
      ),
      isTrue,
    );
    expect(
      result.manifest.records.map((record) => record.sourceId),
      containsAll(<String>[
        'jazz_grandpas_spells',
        'jazz_for_dancers_only',
        'jazz_doggin_around',
        'jazz_weather_bird',
        'jazz_the_preacher',
        'jazz_big_butter_and_egg_man',
        'jazz_blue_7',
        'jazz_cotton_tail',
        'jazz_blues_in_the_closet',
        'jazz_four_brothers',
      ]),
    );
    expect(
      result.manifest.records.first.metadata['annotationNamespaces'],
      containsAll(<String>['chord', 'key_mode']),
    );
    expect(
      result.manifest.records.any(
        (record) =>
            record.progressionInput.contains('N.C.') &&
            record.segments.any((segment) => segment.isNoChord),
      ),
      isTrue,
    );
  });
}
