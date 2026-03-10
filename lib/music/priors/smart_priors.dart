part of '../../smart_generator.dart';

class SmartPriors {
  const SmartPriors._();

  static const Map<JazzPreset, Map<SmartProgressionFamily, int>>
  familyBaseWeights = _generatedSmartFamilyBaseWeights;

  static const Map<PhraseRole, Map<SmartProgressionFamily, double>>
  phraseRoleOverlays = _generatedSmartPhraseRoleOverlays;

  static const Map<SectionRole, Map<SmartProgressionFamily, double>>
  sectionRoleOverlays = _generatedSmartSectionRoleOverlays;

  static const Map<SourceProfile, Map<SmartProgressionFamily, double>>
  sourceProfileOverlays = _generatedSmartSourceProfileOverlays;

  static const Map<KeyMode, Map<RomanNumeralId, List<WeightedNextRoman>>>
  transitionPriors = _generatedSmartTransitionPriors;

  static const Map<SourceProfile, SmartPriorBlendProfile> blendProfiles =
      _generatedSmartPriorBlendProfiles;

  static const SmartPriorBlendProfile _defaultFakebookProfile =
      SmartPriorBlendProfile(
        id: 'lead_sheet_structural',
        useStructuralLeadSheetPriors: true,
        useRecordingSurfaceOverlay: false,
      );

  static const SmartPriorBlendProfile _defaultRecordingProfile =
      SmartPriorBlendProfile(
        id: 'lead_sheet_plus_recording_overlay',
        useStructuralLeadSheetPriors: true,
        useRecordingSurfaceOverlay: true,
      );

  static SmartPriorBlendProfile profileForSourceProfile(
    SourceProfile sourceProfile,
  ) {
    return blendProfiles[sourceProfile] ??
        switch (sourceProfile) {
          SourceProfile.fakebookStandard => _defaultFakebookProfile,
          SourceProfile.recordingInspired => _defaultRecordingProfile,
        };
  }
}
