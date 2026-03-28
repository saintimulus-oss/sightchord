import 'package:cloud_firestore/cloud_firestore.dart';

import 'billing_store.dart';

abstract class AccountEntitlementStore {
  const AccountEntitlementStore();

  Future<BillingStoreSnapshot?> fetchSnapshot(String accountId);

  Future<void> saveSnapshot(String accountId, BillingStoreSnapshot snapshot);
}

class NoopAccountEntitlementStore implements AccountEntitlementStore {
  const NoopAccountEntitlementStore();

  @override
  Future<BillingStoreSnapshot?> fetchSnapshot(String accountId) async => null;

  @override
  Future<void> saveSnapshot(
    String accountId,
    BillingStoreSnapshot snapshot,
  ) async {}
}

class FirestoreAccountEntitlementStore implements AccountEntitlementStore {
  const FirestoreAccountEntitlementStore({FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _resolvedFirestore =>
      _firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _documentForUser(String accountId) {
    return _resolvedFirestore
        .collection('users')
        .doc(accountId)
        .collection('private')
        .doc('billing_state');
  }

  @override
  Future<BillingStoreSnapshot?> fetchSnapshot(String accountId) async {
    final snapshot = await _documentForUser(accountId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }
    return BillingStoreSnapshot.fromJson(data);
  }

  @override
  Future<void> saveSnapshot(
    String accountId,
    BillingStoreSnapshot snapshot,
  ) async {
    await _documentForUser(accountId).set(
      Map<String, dynamic>.from(snapshot.toJson()),
      SetOptions(merge: true),
    );
  }
}
