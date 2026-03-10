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
        previous.secondaryDominantEnabled != next.secondaryDominantEnabled ||
        previous.substituteDominantEnabled != next.substituteDominantEnabled ||
        previous.modalInterchangeEnabled != next.modalInterchangeEnabled ||
        previous.modulationIntensity != next.modulationIntensity ||
        previous.jazzPreset != next.jazzPreset ||
        previous.sourceProfile != next.sourceProfile ||
        previous.allowV7sus4 != next.allowV7sus4 ||
        previous.allowTensions != next.allowTensions ||
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
