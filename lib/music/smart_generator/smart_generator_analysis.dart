part of '../../smart_generator_core.dart';

SmartSimulationComparison _compareSimulationSummaries({
  required SmartSimulationSummary baseline,
  required SmartSimulationSummary candidate,
}) {
  final baselineModulationDensity =
      baseline.modulationSuccessCount / max(1, baseline.steps);
  final candidateModulationDensity =
      candidate.modulationSuccessCount / max(1, candidate.steps);
  final baselineCoreRatio = SmartGeneratorHelper._coreFamilyRatio(
    baseline.familyHistogram,
  );
  final candidateCoreRatio = SmartGeneratorHelper._coreFamilyRatio(
    candidate.familyHistogram,
  );
  final modulationStatus =
      candidateModulationDensity > baselineModulationDensity + 0.004
      ? SmartQaStatus.pass
      : candidateModulationDensity > baselineModulationDensity
      ? SmartQaStatus.warn
      : SmartQaStatus.fail;
  final coreRetentionStatus = candidateCoreRatio >= 0.3
      ? SmartQaStatus.pass
      : candidateCoreRatio >= 0.2
      ? SmartQaStatus.warn
      : SmartQaStatus.fail;
  final minorLiftStatus =
      candidate.minorCenterOccupancy >= baseline.minorCenterOccupancy + 0.03
      ? SmartQaStatus.pass
      : candidate.minorCenterOccupancy >= baseline.minorCenterOccupancy
      ? SmartQaStatus.warn
      : SmartQaStatus.fail;
  return SmartSimulationComparison(
    baselinePreset: baseline.jazzPreset,
    candidatePreset: candidate.jazzPreset,
    qaChecks: [
      SmartQaCheck(
        id: 'modulation_density_lift',
        status: modulationStatus,
        detail:
            '${baseline.jazzPreset.name}=${baselineModulationDensity.toStringAsFixed(3)}, '
            '${candidate.jazzPreset.name}=${candidateModulationDensity.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'core_family_retention',
        status: coreRetentionStatus,
        detail:
            '${baseline.jazzPreset.name}=${baselineCoreRatio.toStringAsFixed(3)}, '
            '${candidate.jazzPreset.name}=${candidateCoreRatio.toStringAsFixed(3)}',
      ),
      SmartQaCheck(
        id: 'minor_center_lift',
        status: minorLiftStatus,
        detail:
            '${baseline.jazzPreset.name}=${baseline.minorCenterOccupancy.toStringAsFixed(3)}, '
            '${candidate.jazzPreset.name}=${candidate.minorCenterOccupancy.toStringAsFixed(3)}',
      ),
    ],
  );
}
