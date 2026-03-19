import 'dart:math' as math;

import '../l10n/app_localizations.dart';

enum HarmonyPlaybackPattern { block, arpeggio }

extension HarmonyPlaybackPatternX on HarmonyPlaybackPattern {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      HarmonyPlaybackPattern.block => l10n.harmonyPlaybackPatternBlock,
      HarmonyPlaybackPattern.arpeggio => l10n.harmonyPlaybackPatternArpeggio,
    };
  }

  static HarmonyPlaybackPattern fromStorageKey(String? value) {
    return HarmonyPlaybackPattern.values.firstWhere(
      (pattern) => pattern.storageKey == value,
      orElse: () => HarmonyPlaybackPattern.block,
    );
  }
}

class HarmonyAudioCapabilities {
  const HarmonyAudioCapabilities({
    this.supportsVelocityHumanization = true,
    this.supportsGainRandomness = true,
    this.supportsTimingHumanization = true,
    this.supportsReverb = false,
    this.supportsEqTilt = false,
  });

  final bool supportsVelocityHumanization;
  final bool supportsGainRandomness;
  final bool supportsTimingHumanization;
  final bool supportsReverb;
  final bool supportsEqTilt;
}

class HarmonyAudioConfig {
  const HarmonyAudioConfig({
    this.masterVolume = 1.0,
    this.previewHoldFactor = 1.0,
    this.arpeggioStepSpeed = 1.0,
    this.velocityHumanization = 0.0,
    this.gainRandomness = 0.0,
    this.timingHumanization = 0.0,
  });

  final double masterVolume;
  final double previewHoldFactor;
  final double arpeggioStepSpeed;
  final double velocityHumanization;
  final double gainRandomness;
  final double timingHumanization;

  HarmonyAudioConfig clamped() {
    return HarmonyAudioConfig(
      masterVolume: masterVolume.clamp(0.0, 1.0).toDouble(),
      previewHoldFactor: previewHoldFactor.clamp(0.35, 1.75).toDouble(),
      arpeggioStepSpeed: arpeggioStepSpeed.clamp(0.5, 2.0).toDouble(),
      velocityHumanization: velocityHumanization.clamp(0.0, 1.0).toDouble(),
      gainRandomness: gainRandomness.clamp(0.0, 1.0).toDouble(),
      timingHumanization: timingHumanization.clamp(0.0, 1.0).toDouble(),
    );
  }

  HarmonyAudioConfig copyWith({
    double? masterVolume,
    double? previewHoldFactor,
    double? arpeggioStepSpeed,
    double? velocityHumanization,
    double? gainRandomness,
    double? timingHumanization,
  }) {
    return HarmonyAudioConfig(
      masterVolume: masterVolume ?? this.masterVolume,
      previewHoldFactor: previewHoldFactor ?? this.previewHoldFactor,
      arpeggioStepSpeed: arpeggioStepSpeed ?? this.arpeggioStepSpeed,
      velocityHumanization: velocityHumanization ?? this.velocityHumanization,
      gainRandomness: gainRandomness ?? this.gainRandomness,
      timingHumanization: timingHumanization ?? this.timingHumanization,
    );
  }
}

class HarmonyAudioProfileTuning {
  const HarmonyAudioProfileTuning({
    this.masterVolumeScale = 1.0,
    this.previewHoldFactorScale = 1.0,
    this.arpeggioStepSpeedScale = 1.0,
    this.velocityHumanizationFloor = 0.0,
    this.gainRandomnessFloor = 0.0,
    this.timingHumanizationFloor = 0.0,
  });

  final double masterVolumeScale;
  final double previewHoldFactorScale;
  final double arpeggioStepSpeedScale;
  final double velocityHumanizationFloor;
  final double gainRandomnessFloor;
  final double timingHumanizationFloor;

  HarmonyAudioConfig resolveAgainst(HarmonyAudioConfig base) {
    return HarmonyAudioConfig(
      masterVolume: base.masterVolume * masterVolumeScale,
      previewHoldFactor: base.previewHoldFactor * previewHoldFactorScale,
      arpeggioStepSpeed: base.arpeggioStepSpeed * arpeggioStepSpeedScale,
      velocityHumanization: math.max(
        base.velocityHumanization,
        velocityHumanizationFloor,
      ),
      gainRandomness: math.max(base.gainRandomness, gainRandomnessFloor),
      timingHumanization: math.max(
        base.timingHumanization,
        timingHumanizationFloor,
      ),
    ).clamped();
  }
}

class HarmonyAudioRuntimeProfile {
  const HarmonyAudioRuntimeProfile({
    required this.profileId,
    required this.instrumentId,
    required this.preferredPattern,
    this.tuning = const HarmonyAudioProfileTuning(),
    this.futureAssetHint,
  });

  final String profileId;
  final String instrumentId;
  final HarmonyPlaybackPattern preferredPattern;
  final HarmonyAudioProfileTuning tuning;
  final String? futureAssetHint;

  HarmonyAudioConfig resolveConfig(HarmonyAudioConfig base) {
    return tuning.resolveAgainst(base);
  }
}

class HarmonyPlaybackOverrides {
  const HarmonyPlaybackOverrides({
    this.blockHold,
    this.arpeggioNoteHold,
    this.arpeggioGap,
  });

  final Duration? blockHold;
  final Duration? arpeggioNoteHold;
  final Duration? arpeggioGap;
}

class HarmonyPreviewNote {
  const HarmonyPreviewNote({
    required this.midiNote,
    this.velocity = 88,
    this.gain = 1.0,
    this.toneLabel,
  });

  final int midiNote;
  final int velocity;
  final double gain;
  final String? toneLabel;
}

class HarmonyChordClip {
  const HarmonyChordClip({required this.notes, this.label});

  final List<HarmonyPreviewNote> notes;
  final String? label;

  bool get isEmpty => notes.isEmpty;
}

class HarmonyMelodyNote {
  const HarmonyMelodyNote({
    required this.midiNote,
    required this.startOffset,
    required this.duration,
    this.velocity = 88,
    this.gain = 1.0,
    this.toneLabel,
  });

  final int midiNote;
  final Duration startOffset;
  final Duration duration;
  final int velocity;
  final double gain;
  final String? toneLabel;
}

class HarmonyMelodyClip {
  const HarmonyMelodyClip({required this.notes, this.label});

  final List<HarmonyMelodyNote> notes;
  final String? label;

  bool get isEmpty => notes.isEmpty;
}

class HarmonyCompositeClip {
  const HarmonyCompositeClip({this.chordClip, this.melodyClip, this.label});

  final HarmonyChordClip? chordClip;
  final HarmonyMelodyClip? melodyClip;
  final String? label;

  bool get isEmpty =>
      (chordClip == null || chordClip!.isEmpty) &&
      (melodyClip == null || melodyClip!.isEmpty);
}
