import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/practice/practice_session_controller.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PracticeSessionController', () {
    test('initialize seeds a free-mode queue and voicing recommendations', () {
      final controller = PracticeSessionController(random: Random(0));

      controller.initialize(settings: PracticeSettings());

      final state = controller.state;
      expect(state.initialized, isTrue);
      expect(state.currentEvent, isNotNull);
      expect(state.nextEvent, isNotNull);
      expect(state.currentChord?.sourceKind, ChordSourceKind.free);
      expect(state.currentChord?.romanNumeralId, isNull);
      expect(state.voicingRecommendations, isNotNull);
    });

    test('smart key mode seeds roman-aware look-ahead state', () {
      final controller = PracticeSessionController(random: Random(1));
      final settings = PracticeSettings(
        activeKeyCenters: {KeyCenter(tonicName: 'C', mode: KeyMode.major)},
        smartGeneratorMode: true,
        lookAheadDepth: 2,
      );

      controller.initialize(settings: settings);

      final state = controller.state;
      expect(state.currentChord?.keyCenter, isNotNull);
      expect(state.currentChord?.romanNumeralId, isNotNull);
      expect(state.currentChord?.sourceKind, isNot(ChordSourceKind.free));
      expect(state.lookAheadEvent, isNotNull);
      expect(state.voicingRecommendations, isNotNull);
    });

    test('promote shifts the queue and carries forward voicing continuity', () {
      final controller = PracticeSessionController(random: Random(2));
      final settings = PracticeSettings(
        activeKeyCenters: {KeyCenter(tonicName: 'C', mode: KeyMode.major)},
        smartGeneratorMode: true,
      );

      controller.initialize(settings: settings);
      final previousCurrentKey =
          controller.state.currentChord?.harmonicComparisonKey;
      final previousNextKey = controller.state.nextChord?.harmonicComparisonKey;
      final previousVoicingSignature =
          controller.state.authoritativeSelectedVoicing?.signature;

      controller.promote(settings: settings);

      final state = controller.state;
      expect(state.previousChord?.harmonicComparisonKey, previousCurrentKey);
      expect(state.currentChord?.harmonicComparisonKey, previousNextKey);
      expect(
        state.continuityReferenceVoicing?.signature,
        previousVoicingSignature,
      );
      expect(state.voicingRecommendations, isNotNull);
    });

    test('refresh clears logged diagnostics when diagnostics are disabled', () {
      final controller = PracticeSessionController(random: Random(3));
      final enabledSettings = PracticeSettings(
        activeKeyCenters: {KeyCenter(tonicName: 'C', mode: KeyMode.major)},
        smartGeneratorMode: true,
        smartDiagnosticsEnabled: true,
      );

      controller.initialize(settings: enabledSettings);
      expect(controller.state.lastLoggedDiagnosticKey, isNotNull);

      controller.refreshForSettings(
        settings: enabledSettings.copyWith(smartDiagnosticsEnabled: false),
      );

      expect(controller.state.lastLoggedDiagnosticKey, isNull);
    });
  });
}
