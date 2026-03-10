import 'practice_settings.dart';

typedef ApplyPracticeSettings =
    void Function(PracticeSettings nextSettings, {bool reseed});
typedef PracticeSettingsUpdate =
    PracticeSettings Function(PracticeSettings current);

class PracticeSettingsDispatcher {
  const PracticeSettingsDispatcher({
    required this.settings,
    required this.onApplySettings,
  });

  final PracticeSettings settings;
  final ApplyPracticeSettings onApplySettings;

  void apply(PracticeSettingsUpdate update, {bool reseed = false}) {
    onApplySettings(update(settings), reseed: reseed);
  }
}
