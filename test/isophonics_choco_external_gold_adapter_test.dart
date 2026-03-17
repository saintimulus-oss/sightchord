import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/benchmark/adapters/isophonics_choco_external_gold_adapter.dart';
import '../tool/benchmark/chord_analyzer_external_gold_schema.dart';

String _joinPath(Iterable<String> segments) =>
    segments.join(Platform.pathSeparator);

void main() {
  const adapter = IsophonicsChocoExternalGoldAdapter();
  final fixtureDirectory = _joinPath(<String>[
    Directory.current.path,
    'tool',
    'benchmark_fixtures',
    'external_gold',
    'isophonics_choco',
  ]);

  test('imports ChoCo Isophonics fixture slice into canonical manifest', () {
    final result = adapter.importExcerptDirectory(fixtureDirectory);

    expect(result.manifest.corpusId, 'isophonics_choco_slice');
    expect(result.rawRecordCount, 6);
    expect(result.loadedRecordCount, 6);
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
        'beatles_taxman',
        'beatles_eleanor_rigby',
        'beatles_for_no_one',
        'beatles_all_my_loving',
        'beatles_it_wont_be_long',
        'beatles_devil_in_her_heart',
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
