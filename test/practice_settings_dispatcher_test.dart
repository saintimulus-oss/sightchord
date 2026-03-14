import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_dispatcher.dart';

void main() {
  test('dispatcher applies transformed settings without reseed by default', () {
    PracticeSettings? receivedSettings;
    bool didReseed = false;
    final dispatcher = PracticeSettingsDispatcher(
      settings: PracticeSettings(),
      onApplySettings: (nextSettings, {bool reseed = false}) {
        receivedSettings = nextSettings;
        didReseed = reseed;
      },
    );

    dispatcher.apply((current) => current.copyWith(metronomeEnabled: false));

    expect(receivedSettings?.metronomeEnabled, isFalse);
    expect(didReseed, isFalse);
  });

  test('dispatcher can mark queue-affecting changes as reseed updates', () {
    PracticeSettings? receivedSettings;
    bool didReseed = false;
    final dispatcher = PracticeSettingsDispatcher(
      settings: PracticeSettings(),
      onApplySettings: (nextSettings, {bool reseed = false}) {
        receivedSettings = nextSettings;
        didReseed = reseed;
      },
    );

    dispatcher.apply(
      (current) => current.copyWith(allowV7sus4: true),
      reseed: true,
    );

    expect(receivedSettings?.allowV7sus4, isTrue);
    expect(didReseed, isTrue);
  });
}

