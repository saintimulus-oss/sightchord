import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

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
  bool _notifyScheduled = false;
  bool _isDisposed = false;

  PracticeSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _store.load(fallbackSettings: _settings);
    _notifySafely();
  }

  Future<void> update(PracticeSettings nextSettings) async {
    _settings = nextSettings;
    _notifySafely();
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

  void _notifySafely() {
    if (_isDisposed) {
      return;
    }
    SchedulerBinding binding;
    try {
      binding = SchedulerBinding.instance;
    } catch (_) {
      _notifyScheduled = false;
      if (!_isDisposed) {
        notifyListeners();
      }
      return;
    }
    final phase = binding.schedulerPhase;
    final canNotifyImmediately =
        phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks;
    if (canNotifyImmediately) {
      _notifyScheduled = false;
      if (!_isDisposed) {
        notifyListeners();
      }
      return;
    }
    if (_notifyScheduled) {
      return;
    }
    _notifyScheduled = true;
    binding.addPostFrameCallback((_) {
      _notifyScheduled = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

