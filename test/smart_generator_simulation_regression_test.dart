import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/inversion_settings.dart';
import 'package:chordest/smart_generator.dart';

SmartStartRequest _buildStartRequest({
  bool allowV7sus4 = true,
  InversionSettings inversionSettings = const InversionSettings(),
}) {
  return SmartStartRequest(
    activeKeys: const ['C'],
    selectedKeyCenters: const [KeyCenter(tonicName: 'C', mode: KeyMode.major)],
    secondaryDominantEnabled: false,
    substituteDominantEnabled: false,
    modalInterchangeEnabled: false,
    modulationIntensity: ModulationIntensity.off,
    jazzPreset: JazzPreset.standardsCore,
    sourceProfile: SourceProfile.fakebookStandard,
    allowV7sus4: allowV7sus4,
    allowTensions: false,
    inversionSettings: inversionSettings,
    smartDiagnosticsEnabled: true,
  );
}

bool _hasSusSurface(SmartSimulationSummary summary) {
  return summary.traces.any(
    (trace) =>
        trace.finalRenderQuality == ChordQuality.dominant13sus4 ||
        trace.finalRenderQuality == ChordQuality.dominant7sus4,
  );
}

bool _hasSlashBassChord(SmartSimulationSummary summary) {
  final slashBassPattern = RegExp(r'\/[A-G](?:b|#)?$');
  return summary.traces.any(
    (trace) =>
        trace.finalChord != null &&
        slashBassPattern.hasMatch(trace.finalChord!),
  );
}

SmartQaCheck _qaCheck(SmartSimulationSummary summary, String id) {
  return summary.qaChecks.firstWhere((check) => check.id == id);
}

void main() {
  test('simulateSteps suppresses sus surfaces when V7sus4 is disabled', () {
    final disabled = SmartGeneratorHelper.simulateSteps(
      random: Random(1000020),
      steps: 64,
      request: _buildStartRequest(allowV7sus4: false),
    );
    final enabled = SmartGeneratorHelper.simulateSteps(
      random: Random(1000020),
      steps: 64,
      request: _buildStartRequest(allowV7sus4: true),
    );

    expect(_hasSusSurface(disabled), isFalse);
    expect(_hasSusSurface(enabled), isTrue);
  });

  test('simulateSteps applies inversion settings to rendered chords', () {
    final disabled = SmartGeneratorHelper.simulateSteps(
      random: Random(1007939),
      steps: 128,
      request: _buildStartRequest(),
    );
    final firstInversionOnly = SmartGeneratorHelper.simulateSteps(
      random: Random(1007939),
      steps: 128,
      request: _buildStartRequest(
        inversionSettings: const InversionSettings(
          enabled: true,
          firstInversionEnabled: true,
          secondInversionEnabled: false,
          thirdInversionEnabled: false,
        ),
      ),
    );

    expect(_hasSlashBassChord(disabled), isFalse);
    expect(_hasSlashBassChord(firstInversionOnly), isTrue);
  });

  test(
    'simulation QA passes unavailable modulation and minor-center checks',
    () {
      final summary = SmartGeneratorHelper.simulateSteps(
        random: Random(1000020),
        steps: 64,
        request: _buildStartRequest(allowV7sus4: false),
      );

      final modulationCheck = _qaCheck(summary, 'modulation_density');
      final minorCenterCheck = _qaCheck(summary, 'minor_center_support');
      final susCheck = _qaCheck(summary, 'sus_release_followthrough');

      expect(modulationCheck.status, SmartQaStatus.pass);
      expect(modulationCheck.detail, contains('unavailable'));
      expect(minorCenterCheck.status, SmartQaStatus.pass);
      expect(minorCenterCheck.detail, contains('unavailable'));
      expect(susCheck.status, SmartQaStatus.pass);
      expect(susCheck.detail, contains('no sus opportunities'));
    },
  );
}

