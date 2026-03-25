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
}

class BillingStore {
  const BillingStore({
    BillingPreferencesLoader preferencesLoader = SharedPreferences.getInstance,
  }) : _preferencesLoader = preferencesLoader;

  static const String billingStateKey = 'billing_state_v2';
  static const String legacyBillingStateKey = 'billing_state_v1';

  final BillingPreferencesLoader _preferencesLoader;

  Future<BillingStoreSnapshot> loadSnapshot() async {
    final preferences = await _preferencesLoader();
    final raw = preferences.getString(billingStateKey);
    if (raw == null || raw.isEmpty) {
      return _loadLegacySnapshot(preferences);
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return _loadLegacySnapshot(preferences);
      }
      final records = decoded['records'];
      if (records is! List) {
        return _loadLegacySnapshot(preferences);
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
        lastSyncAt: DateTime.tryParse(decoded['lastSyncAt'] as String? ?? ''),
      );
    } catch (_) {
      return _loadLegacySnapshot(preferences);
    }
  }

  Future<Map<AppEntitlement, BillingEntitlementRecord>> load() async {
    return (await loadSnapshot()).entitlements;
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
    {DateTime? lastSyncAt}
  ) async {
    await saveSnapshot(
      BillingStoreSnapshot(entitlements: entitlements, lastSyncAt: lastSyncAt),
    );
  }

  Future<void> saveSnapshot(BillingStoreSnapshot snapshot) async {
    final preferences = await _preferencesLoader();
    final payload = jsonEncode(<String, Object?>{
      'version': 2,
      'lastSyncAt': snapshot.lastSyncAt?.toIso8601String(),
      'records': snapshot.entitlements.values
          .map((record) => record.toJson())
          .toList(growable: false),
    });
    await preferences.setString(billingStateKey, payload);
  }
}
