import 'package:flutter/foundation.dart';

import 'practice_settings.dart';
import 'practice_settings_store.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({
    PracticeSettings? initialSettings,
    PracticeSettingsStore? store,
  }) : _settings = initialSettings ?? PracticeSettings(),
       _store = store ?? const PracticeSettingsStore();

  final PracticeSettingsStore _store;
  PracticeSettings _settings;
  Future<void> _saveQueue = Future<void>.value();
  PracticeSettings? _pendingSaveSnapshot;

  PracticeSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _store.load(fallbackSettings: _settings);
    notifyListeners();
  }

  Future<void> update(PracticeSettings nextSettings) async {
    _settings = nextSettings;
    notifyListeners();
    _pendingSaveSnapshot = nextSettings;
    _saveQueue = _saveQueue.catchError((_) {}).then((_) async {
      final snapshot = _pendingSaveSnapshot;
      if (snapshot == null) {
        return;
      }
      _pendingSaveSnapshot = null;
      await _store.save(snapshot);
    });
    await _saveQueue;
  }

  Future<void> mutate(
    PracticeSettings Function(PracticeSettings current) updater,
  ) async {
    await update(updater(_settings));
  }
}
