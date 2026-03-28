import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'account_data_cleaner.dart';
import 'account_models.dart';
import 'firebase_runtime_options.dart';

enum AccountAuthErrorCode {
  invalidCredentials,
  emailInUse,
  weakPassword,
  userNotFound,
  tooManyRequests,
  networkError,
  unavailable,
  requiresRecentLogin,
  dataDeletionFailed,
  unknown,
}

class AccountAuthException implements Exception {
  const AccountAuthException(this.code);

  final AccountAuthErrorCode code;
}

abstract class AccountAuthService {
  const AccountAuthService();

  AppAccountUser? get currentUser;
  Stream<AppAccountUser?> get authStateChanges;

  Future<bool> initialize();

  Future<AppAccountUser> signIn({
    required String email,
    required String password,
  });

  Future<AppAccountUser> register({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  Future<void> deleteAccount({String? currentPassword});
}

class FirebaseAccountAuthService implements AccountAuthService {
  FirebaseAccountAuthService({AccountDataCleaner? dataCleaner})
    : _dataCleaner = dataCleaner ?? const FirestoreAccountDataCleaner();

  FirebaseAuth? _auth;
  final AccountDataCleaner _dataCleaner;
  bool _initialized = false;
  Future<bool>? _initializeFuture;

  @override
  AppAccountUser? get currentUser => _mapUser(_auth?.currentUser);

  @override
  Stream<AppAccountUser?> get authStateChanges {
    final auth = _auth;
    if (auth == null) {
      return const Stream<AppAccountUser?>.empty();
    }
    return auth.authStateChanges().map(_mapUser);
  }

  @override
  Future<bool> initialize() async {
    if (_initialized) {
      return _auth != null;
    }
    final inFlight = _initializeFuture;
    if (inFlight != null) {
      return inFlight;
    }
    final initializeFuture = _performInitialize();
    _initializeFuture = initializeFuture;
    try {
      return await initializeFuture;
    } finally {
      if (identical(_initializeFuture, initializeFuture)) {
        _initializeFuture = null;
      }
    }
  }

  Future<bool> _performInitialize() async {
    final options = FirebaseRuntimeOptions.currentPlatform;
    if (options == null) {
      _initialized = true;
      return false;
    }
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }
    _auth = FirebaseAuth.instance;
    _initialized = true;
    return true;
  }

  @override
  Future<AppAccountUser> signIn({
    required String email,
    required String password,
  }) async {
    final auth = _requireAuth();
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _mapUser(credential.user)!;
    } on FirebaseAuthException catch (error) {
      throw AccountAuthException(_mapErrorCode(error));
    }
  }

  @override
  Future<AppAccountUser> register({
    required String email,
    required String password,
  }) async {
    final auth = _requireAuth();
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _mapUser(credential.user)!;
    } on FirebaseAuthException catch (error) {
      throw AccountAuthException(_mapErrorCode(error));
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    final auth = _requireAuth();
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AccountAuthException(_mapErrorCode(error));
    }
  }

  @override
  Future<void> signOut() async {
    final auth = _requireAuth();
    await auth.signOut();
  }

  @override
  Future<void> deleteAccount({String? currentPassword}) async {
    final auth = _requireAuth();
    final user = auth.currentUser;
    if (user == null) {
      throw const AccountAuthException(AccountAuthErrorCode.unavailable);
    }

    final email = user.email?.trim();
    final password = currentPassword ?? '';
    if (email != null && email.isNotEmpty && password.isNotEmpty) {
      try {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password),
        );
      } on FirebaseAuthException catch (error) {
        throw AccountAuthException(_mapErrorCode(error));
      }
    }

    try {
      await _dataCleaner.deleteUserData(user.uid);
    } catch (_) {
      throw const AccountAuthException(AccountAuthErrorCode.dataDeletionFailed);
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (error) {
      throw AccountAuthException(_mapErrorCode(error));
    }
  }

  FirebaseAuth _requireAuth() {
    final auth = _auth;
    if (auth == null) {
      throw const AccountAuthException(AccountAuthErrorCode.unavailable);
    }
    return auth;
  }

  AppAccountUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AppAccountUser(
      id: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
    );
  }

  AccountAuthErrorCode _mapErrorCode(FirebaseAuthException error) {
    return switch (error.code) {
      'wrong-password' ||
      'invalid-credential' ||
      'invalid-email' => AccountAuthErrorCode.invalidCredentials,
      'email-already-in-use' => AccountAuthErrorCode.emailInUse,
      'weak-password' => AccountAuthErrorCode.weakPassword,
      'user-not-found' => AccountAuthErrorCode.userNotFound,
      'too-many-requests' => AccountAuthErrorCode.tooManyRequests,
      'network-request-failed' => AccountAuthErrorCode.networkError,
      'requires-recent-login' || 'credential-too-old-login-again' =>
        AccountAuthErrorCode.requiresRecentLogin,
      'operation-not-allowed' ||
      'app-not-authorized' => AccountAuthErrorCode.unavailable,
      _ => AccountAuthErrorCode.unknown,
    };
  }
}
