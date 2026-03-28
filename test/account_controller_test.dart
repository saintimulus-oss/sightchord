import 'dart:async';

import 'package:chordest/auth/account_auth_service.dart';
import 'package:chordest/auth/account_controller.dart';
import 'package:chordest/auth/account_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('unconfigured auth service stays available without crashing', () async {
    final controller = AccountController(
      service: _FakeAccountAuthService(configured: false),
    );

    await controller.initialize();

    expect(controller.state.availability, AccountAvailability.unconfigured);
    expect(controller.state.isSignedIn, isFalse);
  });

  test('sign in and sign out update account state', () async {
    final service = _FakeAccountAuthService();
    addTearDown(service.dispose);
    final controller = AccountController(service: service);

    await controller.initialize();
    await controller.signIn(email: 'demo@example.com', password: 'secret-123');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(controller.state.isSignedIn, isTrue);
    expect(controller.state.currentUser?.email, 'demo@example.com');
    expect(controller.state.messageCode, AccountMessageCode.signedIn);

    await controller.signOut();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(controller.state.isSignedIn, isFalse);
    expect(controller.state.messageCode, AccountMessageCode.signedOut);
  });

  test('delete account clears the signed-in state', () async {
    final service = _FakeAccountAuthService();
    addTearDown(service.dispose);
    final controller = AccountController(service: service);

    await controller.initialize();
    await controller.signIn(email: 'demo@example.com', password: 'secret-123');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final deletedAccountId = await controller.deleteAccount(
      currentPassword: 'secret-123',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(deletedAccountId, 'user-1');
    expect(controller.state.isSignedIn, isFalse);
    expect(controller.state.messageCode, AccountMessageCode.deleted);
  });

  test('sign in waits for an in-flight initialization', () async {
    final service = _DelayedAccountAuthService();
    addTearDown(service.dispose);
    final controller = AccountController(service: service);

    final initializeFuture = controller.initialize();
    final signInFuture = controller.signIn(
      email: 'demo@example.com',
      password: 'secret-123',
    );

    expect(service.initializeCalls, 1);
    expect(service.signInCalls, 0);

    service.completeInitialization();
    await Future.wait<void>([initializeFuture, signInFuture]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(service.initializeCalls, 1);
    expect(service.signInCalls, 1);
    expect(controller.state.isSignedIn, isTrue);
    expect(controller.state.currentUser?.email, 'demo@example.com');
    expect(controller.state.messageCode, AccountMessageCode.signedIn);
  });
}

class _FakeAccountAuthService implements AccountAuthService {
  _FakeAccountAuthService({this.configured = true});

  final bool configured;
  final StreamController<AppAccountUser?> _controller =
      StreamController<AppAccountUser?>.broadcast();

  AppAccountUser? _currentUser;

  @override
  AppAccountUser? get currentUser => _currentUser;

  @override
  Stream<AppAccountUser?> get authStateChanges => _controller.stream;

  @override
  Future<bool> initialize() async => configured;

  @override
  Future<AppAccountUser> signIn({
    required String email,
    required String password,
  }) async {
    final user = AppAccountUser(id: 'user-1', email: email);
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppAccountUser> register({
    required String email,
    required String password,
  }) {
    return signIn(email: email, password: password);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {}

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  @override
  Future<void> deleteAccount({String? currentPassword}) async {
    await signOut();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

class _DelayedAccountAuthService extends _FakeAccountAuthService {
  final Completer<bool> _initializeCompleter = Completer<bool>();
  int initializeCalls = 0;
  int signInCalls = 0;

  @override
  Future<bool> initialize() {
    initializeCalls += 1;
    return _initializeCompleter.future;
  }

  @override
  Future<AppAccountUser> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls += 1;
    return super.signIn(email: email, password: password);
  }

  void completeInitialization() {
    if (_initializeCompleter.isCompleted) {
      return;
    }
    _initializeCompleter.complete(true);
  }
}
