import 'package:shared_preferences/shared_preferences.dart';

typedef AnalyzerSharedPreferencesLoader = Future<SharedPreferences> Function();

class AnalyzerQuickEntries {
  const AnalyzerQuickEntries({
    this.recent = const <String>[],
    this.pinned = const <String>[],
  });

  final List<String> recent;
  final List<String> pinned;

  String? get latestRecent => recent.isEmpty ? null : recent.first;
  String? get latestPinned => pinned.isEmpty ? null : pinned.first;
}

class AnalyzerInputHistoryStore {
  const AnalyzerInputHistoryStore({
    AnalyzerSharedPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String recentInputsKey = 'chord_analyzer_recent_inputs';
  static const String pinnedInputsKey = 'chord_analyzer_pinned_inputs';
  static const int maxRecentInputs = 4;
  static const int maxPinnedInputs = 4;

  final AnalyzerSharedPreferencesLoader _preferencesLoader;

  Future<AnalyzerQuickEntries> load() async {
    final preferences = await _preferencesLoader();
    final recent = _sanitizeInputs(
      preferences.getStringList(recentInputsKey) ?? const <String>[],
      maxItems: maxRecentInputs,
    );
    final pinned = _sanitizeInputs(
      preferences.getStringList(pinnedInputsKey) ?? const <String>[],
      maxItems: maxPinnedInputs,
    );
    return AnalyzerQuickEntries(recent: recent, pinned: pinned);
  }

  Future<AnalyzerQuickEntries> remember(String input) async {
    final normalizedInput = normalize(input);
    final preferences = await _preferencesLoader();
    final pinned = _sanitizeInputs(
      preferences.getStringList(pinnedInputsKey) ?? const <String>[],
      maxItems: maxPinnedInputs,
    );
    if (normalizedInput.isEmpty) {
      return AnalyzerQuickEntries(
        recent: _sanitizeInputs(
          preferences.getStringList(recentInputsKey) ?? const <String>[],
          maxItems: maxRecentInputs,
        ),
        pinned: pinned,
      );
    }

    final recent = _sanitizeInputs(<String>[
      normalizedInput,
      ...(preferences.getStringList(recentInputsKey) ?? const <String>[]),
    ], maxItems: maxRecentInputs);
    await _persistInputs(preferences, recentInputsKey, recent);
    return AnalyzerQuickEntries(recent: recent, pinned: pinned);
  }

  Future<AnalyzerQuickEntries> togglePinned(String input) async {
    final normalizedInput = normalize(input);
    final preferences = await _preferencesLoader();
    final recent = _sanitizeInputs(
      preferences.getStringList(recentInputsKey) ?? const <String>[],
      maxItems: maxRecentInputs,
    );
    if (normalizedInput.isEmpty) {
      return AnalyzerQuickEntries(
        recent: recent,
        pinned: _sanitizeInputs(
          preferences.getStringList(pinnedInputsKey) ?? const <String>[],
          maxItems: maxPinnedInputs,
        ),
      );
    }

    final currentPinned = _sanitizeInputs(
      preferences.getStringList(pinnedInputsKey) ?? const <String>[],
      maxItems: maxPinnedInputs,
    );
    final nextPinned = currentPinned.contains(normalizedInput)
        ? currentPinned.where((value) => value != normalizedInput).toList()
        : _sanitizeInputs(<String>[
            normalizedInput,
            ...currentPinned,
          ], maxItems: maxPinnedInputs);
    await _persistInputs(preferences, pinnedInputsKey, nextPinned);
    return AnalyzerQuickEntries(recent: recent, pinned: nextPinned);
  }

  String normalize(String input) => input.trim();

  Future<void> _persistInputs(
    SharedPreferences preferences,
    String key,
    List<String> values,
  ) async {
    if (values.isEmpty) {
      await preferences.remove(key);
      return;
    }
    await preferences.setStringList(key, values);
  }

  List<String> _sanitizeInputs(
    Iterable<String> values, {
    required int maxItems,
  }) {
    final seen = <String>{};
    final sanitized = <String>[];
    for (final value in values) {
      final normalized = normalize(value);
      if (normalized.isEmpty || seen.contains(normalized)) {
        continue;
      }
      sanitized.add(normalized);
      seen.add(normalized);
      if (sanitized.length == maxItems) {
        break;
      }
    }
    return sanitized;
  }
}
