import 'inversion_settings.dart';
import 'practice_settings.dart';

class PracticeSettingsEffects {
  const PracticeSettingsEffects._();

  static bool queueAffectingChanged(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    return !_setEquals(previous.activeKeyCenters, next.activeKeyCenters) ||
        previous.smartGeneratorMode != next.smartGeneratorMode ||
        previous.timeSignature != next.timeSignature ||
        previous.harmonicRhythmPreset != next.harmonicRhythmPreset ||
        previous.anchorLoop != next.anchorLoop ||
        previous.chordLanguageLevel != next.chordLanguageLevel ||
        previous.romanPoolPreset != next.romanPoolPreset ||
        previous.secondaryDominantEnabled != next.secondaryDominantEnabled ||
        previous.substituteDominantEnabled != next.substituteDominantEnabled ||
        previous.modalInterchangeEnabled != next.modalInterchangeEnabled ||
        previous.modulationIntensity != next.modulationIntensity ||
        previous.jazzPreset != next.jazzPreset ||
        previous.sourceProfile != next.sourceProfile ||
        previous.allowV7sus4 != next.allowV7sus4 ||
        previous.allowTensions != next.allowTensions ||
        !_setEquals(
          previous.enabledChordQualities,
          next.enabledChordQualities,
        ) ||
        !_setEquals(
          previous.selectedTensionOptions,
          next.selectedTensionOptions,
        ) ||
        !_sameInversionSettings(
          previous.inversionSettings,
          next.inversionSettings,
        );
  }

  static bool shouldForceLookAheadRefresh(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    if (!next.voicingSuggestionsEnabled || next.lookAheadDepth < 2) {
      return false;
    }
    if (!previous.voicingSuggestionsEnabled || previous.lookAheadDepth < 2) {
      return true;
    }
    return queueAffectingChanged(previous, next);
  }

  static bool metronomeAudioChanged(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    return previous.metronomeEnabled != next.metronomeEnabled ||
        previous.metronomeVolume != next.metronomeVolume ||
        previous.metronomeSource != next.metronomeSource ||
        previous.metronomePattern != next.metronomePattern ||
        previous.metronomeUseAccentSound != next.metronomeUseAccentSound ||
        previous.metronomeAccentSource != next.metronomeAccentSource ||
        previous.timeSignature != next.timeSignature ||
        previous.bpm != next.bpm;
  }

  static bool harmonyAudioChanged(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    return previous.autoPlayChordChanges != next.autoPlayChordChanges ||
        previous.autoPlayPattern != next.autoPlayPattern ||
        previous.autoPlayHoldFactor != next.autoPlayHoldFactor ||
        previous.autoPlayMelodyWithChords != next.autoPlayMelodyWithChords ||
        previous.harmonyMasterVolume != next.harmonyMasterVolume ||
        previous.harmonyPreviewHoldFactor != next.harmonyPreviewHoldFactor ||
        previous.harmonyArpeggioStepSpeed != next.harmonyArpeggioStepSpeed ||
        previous.harmonyVelocityHumanization !=
            next.harmonyVelocityHumanization ||
        previous.harmonyGainRandomness != next.harmonyGainRandomness ||
        previous.harmonyTimingHumanization != next.harmonyTimingHumanization;
  }

  static bool melodyGenerationChanged(
    PracticeSettings previous,
    PracticeSettings next,
  ) {
    return queueAffectingChanged(previous, next) ||
        previous.melodyGenerationEnabled != next.melodyGenerationEnabled ||
        previous.melodyDensity != next.melodyDensity ||
        previous.motifRepetitionStrength != next.motifRepetitionStrength ||
        previous.approachToneDensity != next.approachToneDensity ||
        previous.melodyRangeLow != next.melodyRangeLow ||
        previous.melodyRangeHigh != next.melodyRangeHigh ||
        previous.melodyStyle != next.melodyStyle ||
        previous.allowChromaticApproaches != next.allowChromaticApproaches ||
        previous.syncopationBias != next.syncopationBias ||
        previous.colorRealizationBias != next.colorRealizationBias ||
        previous.noveltyTarget != next.noveltyTarget ||
        previous.motifVariationBias != next.motifVariationBias ||
        previous.anticipationProbability != next.anticipationProbability ||
        previous.colorToneTarget != next.colorToneTarget ||
        previous.exactRepeatTarget != next.exactRepeatTarget;
  }

  static bool _setEquals<T>(Set<T> left, Set<T> right) {
    if (identical(left, right)) {
      return true;
    }
    if (left.length != right.length) {
      return false;
    }
    for (final value in left) {
      if (!right.contains(value)) {
        return false;
      }
    }
    return true;
  }

  static bool _sameInversionSettings(
    InversionSettings left,
    InversionSettings right,
  ) {
    return left.enabled == right.enabled &&
        left.firstInversionEnabled == right.firstInversionEnabled &&
        left.secondInversionEnabled == right.secondInversionEnabled &&
        left.thirdInversionEnabled == right.thirdInversionEnabled;
  }
}
