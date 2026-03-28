import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'billing_models.dart';

typedef BillingPreferencesLoader = Future<SharedPreferences> Function();

class BillingStoreSnapshot {
  const BillingStoreSnapshot({
    this.entitlements = const <AppEntitlement, BillingEntitlementRecord>{},
    this.lastSyncAt,
  });

  final Map<AppEntitlement, BillingEntitlementRecord> entitlements;
  final DateTime? lastSyncAt;

  bool get isEmpty => entitlements.isEmpty && lastSyncAt == null;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'version': 2,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
      'records': entitlements.values
          .map((record) => record.toJson())
          .toList(growable: false),
    };
  }

  static BillingStoreSnapshot fromJson(Map<Object?, Object?> json) {
    final records = json['records'];
    if (records is! List) {
      return const BillingStoreSnapshot();
    }
    final next = <AppEntitlement, BillingEntitlementRecord>{};
    for (final item in records) {
      if (item is! Map) {
        continue;
      }
      final normalized = <String, Object?>{
        for (final entry in item.entries) '${entry.key}': entry.value,
      };
      final record = BillingEntitlementRecord.fromJson(normalized);
      if (record == null) {
        continue;
      }
      next[record.entitlement] = record;
    }
    return BillingStoreSnapshot(
      entitlements: Map<AppEntitlement, BillingEntitlementRecord>.unmodifiable(
        next,
      ),
      lastSyncAt: DateTime.tryParse(json['lastSyncAt'] as String? ?? ''),
    );
  }
}

class BillingStore {
  const BillingStore({
    BillingPreferencesLoader preferencesLoader = SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String billingStateKey = 'billing_state_v2';
  static const String legacyBillingStateKey = 'billing_state_v1';

  final BillingPreferencesLoader _preferencesLoader;

  Future<BillingStoreSnapshot> loadSnapshot({String? accountId}) async {
    final preferences = await _preferencesLoader();
    final raw = preferences.getString(_storageKey(accountId));
    if (raw == null || raw.isEmpty) {
      return accountId == null
          ? _loadLegacySnapshot(preferences)
          : const BillingStoreSnapshot();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return accountId == null
            ? _loadLegacySnapshot(preferences)
            : const BillingStoreSnapshot();
      }
      return BillingStoreSnapshot.fromJson(decoded);
    } catch (_) {
      return accountId == null
          ? _loadLegacySnapshot(preferences)
          : const BillingStoreSnapshot();
    }
  }

  Future<Map<AppEntitlement, BillingEntitlementRecord>> load({
    String? accountId,
  }) async {
    return (await loadSnapshot(accountId: accountId)).entitlements;
  }

  Future<BillingStoreSnapshot> _loadLegacySnapshot(
    SharedPreferences preferences,
  ) async {
    final raw = preferences.getString(legacyBillingStateKey);
    if (raw == null || raw.isEmpty) {
      return const BillingStoreSnapshot();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return const BillingStoreSnapshot();
      }
      final records = decoded['records'];
      if (records is! List) {
        return const BillingStoreSnapshot();
      }
      final next = <AppEntitlement, BillingEntitlementRecord>{};
      for (final item in records) {
        if (item is! Map) {
          continue;
        }
        final normalized = <String, Object?>{
          for (final entry in item.entries) '${entry.key}': entry.value,
        };
        final record = BillingEntitlementRecord.fromJson(normalized);
        if (record == null) {
          continue;
        }
        next[record.entitlement] = record;
      }
      return BillingStoreSnapshot(
        entitlements: Map<AppEntitlement, BillingEntitlementRecord>.unmodifiable(
          next,
        ),
      );
    } catch (_) {
      return const BillingStoreSnapshot();
    }
  }

  Future<void> save(
    Map<AppEntitlement, BillingEntitlementRecord> entitlements,
    {DateTime? lastSyncAt, String? accountId}
  ) async {
    await saveSnapshot(
      BillingStoreSnapshot(entitlements: entitlements, lastSyncAt: lastSyncAt),
      accountId: accountId,
    );
  }

  Future<void> saveSnapshot(
    BillingStoreSnapshot snapshot, {
    String? accountId,
  }) async {
    final preferences = await _preferencesLoader();
    final payload = jsonEncode(snapshot.toJson());
    await preferences.setString(_storageKey(accountId), payload);
  }

  Future<void> deleteSnapshot({String? accountId}) async {
    final preferences = await _preferencesLoader();
    await preferences.remove(_storageKey(accountId));
  }

  String _storageKey(String? accountId) {
    final trimmed = accountId?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return billingStateKey;
    }
    return '${billingStateKey}_${Uri.encodeComponent(trimmed)}';
  }
}
