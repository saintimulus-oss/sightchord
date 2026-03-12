part of '../../smart_generator_core.dart';

class SmartPriorBlendProfile {
  const SmartPriorBlendProfile({
    required this.id,
    required this.useStructuralLeadSheetPriors,
    required this.useRecordingSurfaceOverlay,
  });

  final String id;
  final bool useStructuralLeadSheetPriors;
  final bool useRecordingSurfaceOverlay;
}
