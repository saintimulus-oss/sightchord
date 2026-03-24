import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/collect_chord_analyzer_simulation.dart' as collector;

void main() {
  test('collects a reproducible chord analyzer simulation dataset', () {
    collector.main();

    final outputDir = Directory('output/chord_analyzer_simulation');
    expect(outputDir.existsSync(), isTrue);
    expect(
      File('output/chord_analyzer_simulation/records.json').existsSync(),
      isTrue,
    );
    expect(
      File('output/chord_analyzer_simulation/summary.json').existsSync(),
      isTrue,
    );
  });
}
