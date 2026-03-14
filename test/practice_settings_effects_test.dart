import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('queue-affecting smart settings changes trigger look-ahead refresh', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      allowV7sus4: false,
    );
    final next = previous.copyWith(allowV7sus4: true);

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isTrue,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isTrue,
    );
  });

  test('display-only changes do not refresh the smart chord look-ahead', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      showVoicingReasons: true,
    );
    final next = previous.copyWith(showVoicingReasons: false);

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isFalse,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isFalse,
    );
  });

  test(
    'changing chord quality filters refreshes the smart chord look-ahead',
    () {
      final previous = PracticeSettings(
        voicingSuggestionsEnabled: true,
        lookAheadDepth: 2,
      );
      final next = previous.copyWith(
        enabledChordQualities: {...previous.enabledChordQualities}
          ..remove(ChordQuality.major7),
      );

      expect(
        PracticeSettingsEffects.queueAffectingChanged(previous, next),
        isTrue,
      );
      expect(
        PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
        isTrue,
      );
    },
  );

  test('changing language guardrails refreshes the smart chord look-ahead', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      chordLanguageLevel: ChordLanguageLevel.fullExtensions,
      romanPoolPreset: RomanPoolPreset.expandedColor,
    );
    final next = previous.copyWith(
      chordLanguageLevel: ChordLanguageLevel.seventhChords,
      romanPoolPreset: RomanPoolPreset.coreDiatonic,
    );

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isTrue,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isTrue,
    );
  });

  test('look-ahead refresh is disabled when suggestions cannot use it', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
    );
    final next = previous.copyWith(
      voicingSuggestionsEnabled: false,
      allowTensions: !previous.allowTensions,
    );

    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isFalse,
    );
  });
}
