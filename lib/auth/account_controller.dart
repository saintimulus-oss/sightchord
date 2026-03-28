import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'account_auth_service.dart';
import 'account_models.dart';

class AccountController extends ChangeNotifier {
  AccountController({AccountAuthService? service})
    : _service = service ?? FirebaseAccountAuthService();

  factory AccountController.live({AccountAuthService? service}) {
    return AccountController(service: service);
  }

  final AccountAuthService _service;

  AccountState _state = const AccountState();
  StreamSubscription<AppAccountUser?>? _authStateSubscription;
  bool _initialized = false;
  bool _isDisposed = false;
  bool _notifyScheduled = false;
  Future<void>? _initializeFuture;

  AccountState get state => _state;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    final inFlight = _initializeFuture;
    if (inFlight != null) {
      await inFlight;
      return;
    }
    final initializeFuture = _performInitialize();
    _initializeFuture = initializeFuture;
    try {
      await initializeFuture;
    } finally {
      if (identical(_initializeFuture, initializeFuture)) {
        _initializeFuture = null;
      }
    }
  }

  Future<void> _performInitialize() async {
    bool configured;
    try {
      configured = await _service.initialize();
    } catch (_) {
      configured = false;
      _state = _state.copyWith(
        availability: AccountAvailability.error,
        currentUser: null,
        isBusy: false,
        messageCode: AccountMessageCode.authUnavailable,
      );
      _notifySafely();
      return;
    }
    if (_isDisposed) {
      return;
    }
    if (!configured) {
      _initialized = true;
      _state = _state.copyWith(
        availability: AccountAvailability.unconfigured,
        currentUser: null,
      );
      _notifySafely();
      return;
    }
    _authStateSubscription ??= _service.authStateChanges.listen(
      _handleAuthStateChanged,
      onError: (Object error, StackTrace stackTrace) {
        if (_isDisposed) {
          return;
        }
        _state = _state.copyWith(
          availability: AccountAvailability.error,
          messageCode: AccountMessageCode.authUnavailable,
        );
        _notifySafely();
      },
    );
    _initialized = true;
    _state = _state.copyWith(
      availability: AccountAvailability.available,
      currentUser: _service.currentUser,
    );
    _notifySafely();
  }

  Future<void> signIn({required String email, required String password}) async {
    await initialize();
    if (!_state.isConfigured) {
      _setMessage(AccountMessageCode.authUnavailable);
      return;
    }
    await _runBusyAction(() async {
      try {
        await _service.signIn(email: email, password: password);
        _setMessage(AccountMessageCode.signedIn);
      } on AccountAuthException catch (error) {
        _setMessage(_mapError(error.code));
      }
    });
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await initialize();
    if (!_state.isConfigured) {
      _setMessage(AccountMessageCode.authUnavailable);
      return;
    }
    await _runBusyAction(() async {
      try {
        await _service.register(email: email, password: password);
        _setMessage(AccountMessageCode.signedUp);
      } on AccountAuthException catch (error) {
        _setMessage(_mapError(error.code));
      }
    });
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await initialize();
    if (!_state.isConfigured) {
      _setMessage(AccountMessageCode.authUnavailable);
      return;
    }
    await _runBusyAction(() async {
      try {
        await _service.sendPasswordResetEmail(email: email);
        _setMessage(AccountMessageCode.passwordResetSent);
      } on AccountAuthException catch (error) {
        _setMessage(_mapError(error.code));
      }
    });
  }

  Future<void> signOut() async {
    await initialize();
    if (!_state.isConfigured) {
      _setMessage(AccountMessageCode.authUnavailable);
      return;
    }
    await _runBusyAction(() async {
      await _service.signOut();
      _setMessage(AccountMessageCode.signedOut);
    });
  }

  Future<String?> deleteAccount({String? currentPassword}) async {
    await initialize();
    if (!_state.isConfigured) {
      _setMessage(AccountMessageCode.authUnavailable);
      return null;
    }
    final currentUser = _state.currentUser;
    if (currentUser == null) {
      return null;
    }
    final deletedAccountId = currentUser.id;
    var deleted = false;
    await _runBusyAction(() async {
      try {
        await _service.deleteAccount(currentPassword: currentPassword);
        deleted = true;
        _setMessage(AccountMessageCode.deleted);
      } on AccountAuthException catch (error) {
        _setMessage(_mapError(error.code));
      }
    });
    return deleted ? deletedAccountId : null;
  }

  void dismissMessage() {
    if (_state.isBusy || _state.messageCode == null) {
      return;
    }
    _state = _state.copyWith(messageCode: null);
    _notifySafely();
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    _state = _state.copyWith(isBusy: true);
    _notifySafely();
    try {
      await action();
    } finally {
      if (!_isDisposed) {
        _state = _state.copyWith(isBusy: false);
        _notifySafely();
      }
    }
  }

  void _handleAuthStateChanged(AppAccountUser? user) {
    if (_isDisposed) {
      return;
    }
    _state = _state.copyWith(
      availability: AccountAvailability.available,
      currentUser: user,
    );
    _notifySafely();
  }

  AccountMessageCode _mapError(AccountAuthErrorCode code) {
    return switch (code) {
      AccountAuthErrorCode.invalidCredentials =>
        AccountMessageCode.invalidCredentials,
      AccountAuthErrorCode.emailInUse => AccountMessageCode.emailInUse,
      AccountAuthErrorCode.weakPassword => AccountMessageCode.weakPassword,
      AccountAuthErrorCode.userNotFound => AccountMessageCode.userNotFound,
      AccountAuthErrorCode.tooManyRequests =>
        AccountMessageCode.tooManyRequests,
      AccountAuthErrorCode.networkError => AccountMessageCode.networkError,
      AccountAuthErrorCode.unavailable => AccountMessageCode.authUnavailable,
      AccountAuthErrorCode.requiresRecentLogin =>
        AccountMessageCode.deleteRequiresRecentLogin,
      AccountAuthErrorCode.dataDeletionFailed =>
        AccountMessageCode.dataDeletionFailed,
      AccountAuthErrorCode.unknown => AccountMessageCode.unknownError,
    };
  }

  void _setMessage(AccountMessageCode messageCode) {
    _state = _state.copyWith(messageCode: messageCode);
    _notifySafely();
  }

  void _notifySafely() {
    if (_isDisposed) {
      return;
    }
    final binding = SchedulerBinding.instance;
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
    unawaited(_authStateSubscription?.cancel());
    super.dispose();
  }
}
