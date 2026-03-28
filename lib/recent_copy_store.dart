import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

typedef RecentCopyPreferencesLoader = Future<SharedPreferences> Function();

enum RecentCopyKind { currentChord, visibleLoop, melodyPreview }

class RecentCopyEntry {
  const RecentCopyEntry({
    required this.kind,
    required this.text,
    required this.savedAt,
  });

  factory RecentCopyEntry.fromJson(Map<String, Object?> json) {
    return RecentCopyEntry(
      kind: RecentCopyKind.values.firstWhere(
        (value) => value.name == json['kind'],
        orElse: () => RecentCopyKind.visibleLoop,
      ),
      text: (json['text'] as String? ?? '').trim(),
      savedAt:
          DateTime.tryParse(json['savedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  final RecentCopyKind kind;
  final String text;
  final DateTime savedAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'kind': kind.name,
    'text': text,
    'savedAt': savedAt.toUtc().toIso8601String(),
  };

  String preview({int maxLength = 56}) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= maxLength) {
      return normalized;
    }
    return '${normalized.substring(0, maxLength - 1)}...';
  }
}

class RecentCopyEntries {
  const RecentCopyEntries({this.items = const <RecentCopyEntry>[]});

  final List<RecentCopyEntry> items;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  RecentCopyEntry? get latest => isEmpty ? null : items.first;
}

class RecentCopyHistoryStore {
  const RecentCopyHistoryStore({
    RecentCopyPreferencesLoader preferencesLoader =
        SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String historyKey = 'recent_copy_history_v1';
  static const int maxEntries = 6;

  final RecentCopyPreferencesLoader _preferencesLoader;

  Future<RecentCopyEntries> load() async {
    final preferences = await _preferencesLoader();
    final raw = preferences.getString(historyKey);
    if (raw == null || raw.isEmpty) {
      return const RecentCopyEntries();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const RecentCopyEntries();
      }
      final entries = <RecentCopyEntry>[
        for (final item in decoded)
          if (item is Map)
            RecentCopyEntry.fromJson(Map<String, Object?>.from(item)),
      ];
      return RecentCopyEntries(items: _sanitizeEntries(entries));
    } catch (_) {
      return const RecentCopyEntries();
    }
  }

  Future<RecentCopyEntries> remember(RecentCopyKind kind, String text) async {
    final normalizedText = text.trim();
    final preferences = await _preferencesLoader();
    final currentEntries = (await load()).items;
    if (normalizedText.isEmpty) {
      return RecentCopyEntries(items: currentEntries);
    }
    final nextEntries = _sanitizeEntries(<RecentCopyEntry>[
      RecentCopyEntry(
        kind: kind,
        text: normalizedText,
        savedAt: DateTime.now().toUtc(),
      ),
      ...currentEntries,
    ]);
    await _persistEntries(preferences, nextEntries);
    return RecentCopyEntries(items: nextEntries);
  }

  Future<void> clear() async {
    final preferences = await _preferencesLoader();
    await preferences.remove(historyKey);
  }

  Future<void> _persistEntries(
    SharedPreferences preferences,
    List<RecentCopyEntry> entries,
  ) async {
    if (entries.isEmpty) {
      await preferences.remove(historyKey);
      return;
    }
    await preferences.setString(
      historyKey,
      jsonEncode(<Map<String, Object?>>[
        for (final entry in entries) entry.toJson(),
      ]),
    );
  }

  List<RecentCopyEntry> _sanitizeEntries(Iterable<RecentCopyEntry> entries) {
    final seen = <String>{};
    final sanitized = <RecentCopyEntry>[];
    for (final entry in entries) {
      final normalizedText = entry.text.trim();
      if (normalizedText.isEmpty) {
        continue;
      }
      final dedupeKey = '${entry.kind.name}::$normalizedText';
      if (!seen.add(dedupeKey)) {
        continue;
      }
      sanitized.add(
        RecentCopyEntry(
          kind: entry.kind,
          text: normalizedText,
          savedAt: entry.savedAt,
        ),
      );
      if (sanitized.length == maxEntries) {
        break;
      }
    }
    return sanitized;
  }
}
