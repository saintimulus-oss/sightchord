import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AccountDataCleaner {
  const AccountDataCleaner();

  Future<void> deleteUserData(String accountId);
}

class NoopAccountDataCleaner implements AccountDataCleaner {
  const NoopAccountDataCleaner();

  @override
  Future<void> deleteUserData(String accountId) async {}
}

class FirestoreAccountDataCleaner implements AccountDataCleaner {
  const FirestoreAccountDataCleaner({FirebaseFirestore? firestore})
    : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _resolvedFirestore =>
      _firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> deleteUserData(String accountId) async {
    await _resolvedFirestore
        .collection('users')
        .doc(accountId)
        .collection('private')
        .doc('billing_state')
        .delete();
  }
}
