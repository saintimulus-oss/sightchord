import 'dart:convert';
import 'dart:io';

import 'package:chordest/music/melody_analysis.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('melody analysis report', () {
    final report = MelodyAnalysisRunner.analyzeDefaultModes();
    final quickPresetReport = MelodyAnalysisRunner.analyzeQuickPresets();

    test('measures all required metrics for guided standard and advanced', () {
      // ignore: avoid_print
      print(report.toSummaryText());

      final comparable = report.toComparableJson();
      expect(
        comparable['intervalDistributionByMode'],
        isA<Map<String, dynamic>>(),
      );
      expect(comparable['syncopationByMode'], isA<Map<String, dynamic>>());
      expect(
        comparable['motifTransformDistributionByMode'],
        isA<Map<String, dynamic>>(),
      );

      for (final mode in SettingsComplexityMode.values) {
        final metrics = report.metricsByMode[mode]!;
        expect(metrics.eventCount, greaterThan(0));
        expect(metrics.noteCount, greaterThan(0));
        expect(metrics.adjacentSamePitchRatio, inInclusiveRange(0.0, 1.0));
        expect(metrics.singleEventMonotoneRatio, inInclusiveRange(0.0, 1.0));
        expect(
          metrics.exactPreviousEventRepeatRatio,
          inInclusiveRange(0.0, 1.0),
        );
        expect(
          metrics.sameIntervalVectorRepeatInWindow4Ratio,
          inInclusiveRange(0.0, 1.0),
        );
        expect(
          metrics.colorToneUptakeOnColorChords,
          inInclusiveRange(0.0, 1.0),
        );
        expect(metrics.offbeatOnsetRatio, inInclusiveRange(0.0, 1.0));
        expect(
          metrics.resolutionWithin2SemitonesRatio,
          inInclusiveRange(0.0, 1.0),
        );
        expect(
          metrics.intervalsAbove7SemitonesRatio,
          inInclusiveRange(0.0, 1.0),
        );
        expect(metrics.phraseFinalLongNoteRatio, inInclusiveRange(0.0, 1.0));
        expect(metrics.phraseMetadataCoverage, 1.0);
        expect(metrics.syncopationByPosition.containsKey('&2'), isTrue);
        expect(metrics.syncopationByPosition.containsKey('&4'), isTrue);
        expect(metrics.intervalDistribution, isNotEmpty);
        expect(metrics.motifTransformDistribution, isNotEmpty);
        expect(metrics.exactSameEventStreakLength, greaterThanOrEqualTo(1));
      }
    });

    test('keeps mode statistics inside regression guard bands', () {
      final guided = report.metricsByMode[SettingsComplexityMode.guided]!;
      final standard = report.metricsByMode[SettingsComplexityMode.standard]!;
      final advanced = report.metricsByMode[SettingsComplexityMode.advanced]!;

      expect(guided.exactPreviousEventRepeatRatio, lessThanOrEqualTo(0.10));
      expect(
        guided.sameIntervalVectorRepeatInWindow4Ratio,
        lessThanOrEqualTo(0.28),
      );
      expect(guided.offbeatOnsetRatio, inInclusiveRange(0.18, 0.30));
      expect(guided.resolutionWithin2SemitonesRatio, greaterThan(0.85));

      expect(standard.exactPreviousEventRepeatRatio, lessThanOrEqualTo(0.10));
      expect(
        standard.sameIntervalVectorRepeatInWindow4Ratio,
        lessThanOrEqualTo(0.22),
      );
      expect(standard.offbeatOnsetRatio, inInclusiveRange(0.25, 0.36));
      expect(standard.resolutionWithin2SemitonesRatio, greaterThan(0.85));

      expect(advanced.exactPreviousEventRepeatRatio, lessThanOrEqualTo(0.10));
      expect(
        advanced.sameIntervalVectorRepeatInWindow4Ratio,
        lessThanOrEqualTo(0.18),
      );
      expect(advanced.offbeatOnsetRatio, inInclusiveRange(0.35, 0.46));
      expect(advanced.resolutionWithin2SemitonesRatio, greaterThan(0.85));
      expect(advanced.intervalsAbove7SemitonesRatio, lessThanOrEqualTo(0.08));

      expect(guided.cadenceLongFinalRatio, greaterThan(0.65));
      expect(standard.cadenceLongFinalRatio, greaterThan(0.65));
      expect(advanced.cadenceLongFinalRatio, greaterThan(0.65));

      expect(guided.cadenceResolutionQuality, greaterThan(0.80));
      expect(standard.cadenceResolutionQuality, greaterThan(0.65));
      expect(advanced.cadenceResolutionQuality, greaterThan(0.65));

      expect(guided.apexAlignmentRatio, greaterThan(0.20));
      expect(standard.apexAlignmentRatio, greaterThan(0.55));
      expect(advanced.apexAlignmentRatio, greaterThan(0.55));

      expect(guided.apexPosBucketCount, greaterThanOrEqualTo(2));
      expect(standard.apexPosBucketCount, greaterThanOrEqualTo(2));
      expect(advanced.apexPosBucketCount, greaterThanOrEqualTo(2));

      final advancedSyncCore =
          (advanced.syncopationByPosition['&2'] ?? 0.0) +
          (advanced.syncopationByPosition['&4'] ?? 0.0);
      final advancedSyncEdge =
          (advanced.syncopationByPosition['&1'] ?? 0.0) +
          (advanced.syncopationByPosition['&3'] ?? 0.0);
      expect(advancedSyncCore, greaterThan(advancedSyncEdge));
    });

    test('matches the stored JSON baseline snapshot', () {
      final baselineFile = File(
        'C:/Users/User/sightchord/test/fixtures/melody_analysis_baseline.json',
      );
      expect(baselineFile.existsSync(), isTrue);

      final expected =
          jsonDecode(baselineFile.readAsStringSync()) as Map<String, dynamic>;
      expect(report.toComparableJson(), expected);
    });

    test('quick preset analysis separates guide song and color lines', () {
      // ignore: avoid_print
      print(quickPresetReport.toSummaryText());

      final guide = quickPresetReport.metricsByPreset[MelodyQuickPreset.guideLine]!;
      final song = quickPresetReport.metricsByPreset[MelodyQuickPreset.songLine]!;
      final color = quickPresetReport.metricsByPreset[MelodyQuickPreset.colorLine]!;

      expect(guide.offbeatOnsetRatio, lessThan(song.offbeatOnsetRatio));
      expect(song.offbeatOnsetRatio, lessThan(color.offbeatOnsetRatio));

      expect(
        guide.colorToneUptakeOnColorChords,
        lessThan(song.colorToneUptakeOnColorChords),
      );
      expect(
        song.colorToneUptakeOnColorChords,
        lessThan(color.colorToneUptakeOnColorChords),
      );

      expect(
        (guide.weakSlotCategoryUsage['chromatic'] ?? 0.0),
        lessThan((song.weakSlotCategoryUsage['chromatic'] ?? 0.0)),
      );
      expect(
        (song.weakSlotCategoryUsage['chromatic'] ?? 0.0),
        lessThanOrEqualTo((color.weakSlotCategoryUsage['chromatic'] ?? 0.0)),
      );
    });
  });
}
