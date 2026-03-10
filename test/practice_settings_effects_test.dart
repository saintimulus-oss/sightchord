import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/practice_settings_effects.dart';

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
