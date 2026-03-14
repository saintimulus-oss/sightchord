import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/smart_generator.dart';

SmartStartRequest _buildStartRequest({
  required List<String> activeKeys,
  List<KeyCenter>? selectedKeyCenters,
  bool secondaryDominantEnabled = false,
  bool substituteDominantEnabled = false,
  bool modalInterchangeEnabled = false,
  ModulationIntensity modulationIntensity = ModulationIntensity.off,
  JazzPreset jazzPreset = JazzPreset.standardsCore,
  SourceProfile sourceProfile = SourceProfile.fakebookStandard,
}) {
  return SmartStartRequest(
    activeKeys: activeKeys,
    selectedKeyCenters:
        selectedKeyCenters ??
        activeKeys.map((key) => MusicTheory.keyCenterFor(key)).toList(),
    secondaryDominantEnabled: secondaryDominantEnabled,
    substituteDominantEnabled: substituteDominantEnabled,
    modalInterchangeEnabled: modalInterchangeEnabled,
    modulationIntensity: modulationIntensity,
    jazzPreset: jazzPreset,
    sourceProfile: sourceProfile,
    smartDiagnosticsEnabled: true,
  );
}

void main() {
  test('single major key does not demand minor center support from QA', () {
    final summary = SmartGeneratorHelper.simulateSteps(
      random: Random(7),
      steps: 400,
      request: _buildStartRequest(
        activeKeys: const ['C'],
        secondaryDominantEnabled: true,
        substituteDominantEnabled: true,
        modalInterchangeEnabled: true,
        modulationIntensity: ModulationIntensity.high,
      ),
    );

    final qa = summary.qaChecks.firstWhere(
      (check) => check.id == 'minor_center_support',
    );

    expect(qa.status, SmartQaStatus.pass);
    expect(qa.detail, 'minor centers unavailable for current configuration');
  });

  test(
    'major-only multi-key banks with modulation off do not demand minor support',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(11),
        steps: 400,
        request: _buildStartRequest(
          activeKeys: const ['C', 'G'],
          selectedKeyCenters: const [
            KeyCenter(tonicName: 'C', mode: KeyMode.major),
            KeyCenter(tonicName: 'G', mode: KeyMode.major),
          ],
          secondaryDominantEnabled: true,
          substituteDominantEnabled: true,
          modalInterchangeEnabled: true,
          modulationIntensity: ModulationIntensity.off,
        ),
      );

      final qa = summary.qaChecks.firstWhere(
        (check) => check.id == 'minor_center_support',
      );

      expect(qa.status, SmartQaStatus.pass);
      expect(qa.detail, 'minor centers unavailable for current configuration');
    },
  );

  test(
    'major-only multi-key banks with live modulation still track minor support',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(13),
        steps: 400,
        request: _buildStartRequest(
          activeKeys: const ['C', 'G'],
          selectedKeyCenters: const [
            KeyCenter(tonicName: 'C', mode: KeyMode.major),
            KeyCenter(tonicName: 'G', mode: KeyMode.major),
          ],
          secondaryDominantEnabled: true,
          substituteDominantEnabled: true,
          modulationIntensity: ModulationIntensity.high,
          jazzPreset: JazzPreset.modulationStudy,
        ),
      );

      final qa = summary.qaChecks.firstWhere(
        (check) => check.id == 'minor_center_support',
      );

      expect(
        qa.detail,
        isNot('minor centers unavailable for current configuration'),
      );
    },
  );
}

