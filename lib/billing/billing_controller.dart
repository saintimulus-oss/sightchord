import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'account_entitlement_store.dart';
import 'billing_gateway.dart';
import 'billing_gateway_factory.dart';
import 'billing_models.dart';
import 'billing_store.dart';

enum BillingRefreshReason { startup, resume, manual }

class BillingController extends ChangeNotifier {
  BillingController({
    BillingGateway? gateway,
    BillingStore? store,
    AccountEntitlementStore? accountEntitlementStore,
    DateTime Function()? now,
  }) : _gateway = gateway ?? createBillingGateway(),
       _store = store ?? const BillingStore(),
       _accountEntitlementStore =
           accountEntitlementStore ?? const NoopAccountEntitlementStore(),
       _now = now ?? DateTime.now;

  factory BillingController.live({BillingStore? store}) {
    return BillingController(
      store: store,
      accountEntitlementStore: const FirestoreAccountEntitlementStore(),
    );
  }

  factory BillingController.noop({BillingStore? store}) {
    return BillingController(
      gateway: const NoopBillingGateway(),
      store: store,
      accountEntitlementStore: const NoopAccountEntitlementStore(),
    );
  }

  static const Duration _resumeSyncCooldown = Duration(seconds: 30);

  final BillingGateway _gateway;
  final BillingStore _store;
  final AccountEntitlementStore _accountEntitlementStore;
  final DateTime Function() _now;

  BillingState _state = const BillingState();
  StreamSubscription<List<BillingPurchase>>? _purchaseSubscription;
  Future<void>? _ongoingSync;
  Future<void>? _initializeFuture;
  bool _initialized = false;
  bool _isDisposed = false;
  bool _notifyScheduled = false;
  _RestoreContext? _pendingRestoreContext;
  final Set<String> _handledPurchaseKeys = <String>{};
  String? _accountId;
  int _accountRequestRevision = 0;

  BillingState get state => _state;

  bool get isPremiumUnlocked => _state.isPremiumUnlocked;
  String? get accountId => _accountId;

  BillingProduct? get premiumProduct =>
      _state.productForId(kPremiumUnlockProductId);

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
    _purchaseSubscription ??= _gateway.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error, StackTrace stackTrace) {
        if (_isDisposed) {
          return;
        }
        _state = _state.copyWith(storeStatus: BillingStoreStatus.error);
        _failPendingRestore(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.failed,
            messageCode: BillingMessageCode.purchaseFailed,
          ),
        );
      },
    );
    BillingStoreSnapshot snapshot;
    try {
      snapshot = await _store.loadSnapshot(accountId: _accountId);
    } catch (_) {
      _initialized = true;
      _notifySafely();
      return;
    }
    if (_isDisposed) {
      return;
    }
    _initialized = true;
    _state = _state.copyWith(
      entitlements: snapshot.entitlements,
      lastSyncAt: snapshot.lastSyncAt,
    );
    _notifySafely();
  }

  Future<void> setAccount(String? accountId) async {
    await initialize();
    final normalizedAccountId = _normalizeAccountId(accountId);
    if (_accountId == normalizedAccountId) {
      return;
    }

    final requestRevision = ++_accountRequestRevision;
    _accountId = normalizedAccountId;
    _handledPurchaseKeys.clear();

    BillingStoreSnapshot localSnapshot;
    try {
      localSnapshot = await _store.loadSnapshot(accountId: _accountId);
    } catch (_) {
      localSnapshot = const BillingStoreSnapshot();
    }
    if (_isStaleAccountRequest(requestRevision, normalizedAccountId)) {
      return;
    }

    var resolvedSnapshot = localSnapshot;
    final activeAccountId = normalizedAccountId;
    if (activeAccountId != null) {
      resolvedSnapshot = await _hydrateAccountSnapshot(
        accountId: activeAccountId,
        localSnapshot: localSnapshot,
      );
    }

    if (_isStaleAccountRequest(requestRevision, normalizedAccountId)) {
      return;
    }

    _state = BillingState(
      entitlements: resolvedSnapshot.entitlements,
      products: _state.products,
      storeStatus: _state.storeStatus,
      isCatalogLoading: false,
      operation: const BillingOperation.idle(),
      lastSyncAt: resolvedSnapshot.lastSyncAt,
    );
    _notifySafely();
  }

  Future<void> synchronize({
    required BillingRefreshReason reason,
    bool attemptRestore = false,
  }) async {
    await initialize();
    if (_isDisposed) {
      return;
    }

    final activeSync = _ongoingSync;
    if (activeSync != null) {
      await activeSync;
      if (_isDisposed || reason != BillingRefreshReason.manual) {
        return;
      }
    }

    final sync = _runSynchronize(
      reason: reason,
      attemptRestore: attemptRestore,
    );
    _ongoingSync = sync;
    try {
      await sync;
    } finally {
      if (identical(_ongoingSync, sync)) {
        _ongoingSync = null;
      }
    }
  }

  Future<void> refreshForAppResume() async {
    if (_state.operation.isBusy) {
      return;
    }
    final lastSyncAt = _state.lastSyncAt;
    if (lastSyncAt != null &&
        _now().difference(lastSyncAt) < _resumeSyncCooldown) {
      return;
    }
    await synchronize(reason: BillingRefreshReason.resume);
  }

  Future<void> purchasePremiumUnlock() async {
    await initialize();
    if (_state.operation.isBusy) {
      return;
    }
    if (isPremiumUnlocked) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.purchase,
          status: BillingOperationStatus.success,
          messageCode: BillingMessageCode.alreadyUnlocked,
        ),
      );
      return;
    }
    if (_state.storeStatus != BillingStoreStatus.available ||
        premiumProduct == null) {
      await synchronize(reason: BillingRefreshReason.manual);
    }
    if (_isDisposed) {
      return;
    }
    final product = premiumProduct;
    if (_state.storeStatus != BillingStoreStatus.available) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.purchase,
          status: BillingOperationStatus.failed,
          messageCode: BillingMessageCode.storeUnavailable,
        ),
      );
      return;
    }
    if (product == null) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.purchase,
          status: BillingOperationStatus.failed,
          messageCode: BillingMessageCode.productUnavailable,
        ),
      );
      return;
    }
    _setOperation(
      const BillingOperation(
        type: BillingOperationType.purchase,
        status: BillingOperationStatus.inProgress,
      ),
    );
    bool launched;
    try {
      launched = await _gateway.buyNonConsumable(product);
    } catch (_) {
      launched = false;
    }
    if (!launched && !_isDisposed) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.purchase,
          status: BillingOperationStatus.failed,
          messageCode: BillingMessageCode.purchaseFailed,
        ),
      );
    }
  }

  Future<void> restorePurchases() async {
    if (_state.operation.isBusy) {
      return;
    }
    await synchronize(
      reason: BillingRefreshReason.manual,
      attemptRestore: true,
    );
  }

  Future<void> deleteAccountData(String accountId) async {
    final normalizedAccountId = _normalizeAccountId(accountId);
    if (normalizedAccountId == null) {
      return;
    }
    try {
      await _store.deleteSnapshot(accountId: normalizedAccountId);
    } catch (_) {}
    if (_accountId != normalizedAccountId || _isDisposed) {
      return;
    }
    _state = _state.copyWith(
      entitlements: const <AppEntitlement, BillingEntitlementRecord>{},
      lastSyncAt: null,
      operation: const BillingOperation.idle(),
    );
    _notifySafely();
  }

  void dismissMessage() {
    if (_state.operation.isBusy ||
        _state.operation.status == BillingOperationStatus.idle) {
      return;
    }
    _setOperation(const BillingOperation.idle());
  }

  Future<void> _runSynchronize({
    required BillingRefreshReason reason,
    required bool attemptRestore,
  }) async {
    _state = _state.copyWith(isCatalogLoading: true);
    if (reason == BillingRefreshReason.manual && attemptRestore) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.restore,
          status: BillingOperationStatus.inProgress,
        ),
      );
    } else {
      _notifySafely();
    }

    final available = await _safeIsAvailable();
    if (_isDisposed) {
      return;
    }
    if (!available) {
      _pendingRestoreContext = null;
      _state = _state.copyWith(
        storeStatus: BillingStoreStatus.unavailable,
        isCatalogLoading: false,
        lastSyncAt: _now(),
      );
      await _persistSnapshot();
      if (reason == BillingRefreshReason.manual && attemptRestore) {
        _setOperation(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.failed,
            messageCode: BillingMessageCode.storeUnavailable,
          ),
        );
      } else {
        _notifySafely();
      }
      return;
    }

    final queryResult = await _safeQueryProducts();
    if (_isDisposed) {
      return;
    }
    if (queryResult == null) {
      _pendingRestoreContext = null;
      _state = _state.copyWith(
        storeStatus: BillingStoreStatus.error,
        isCatalogLoading: false,
        lastSyncAt: _now(),
      );
      await _persistSnapshot();
      if (reason == BillingRefreshReason.manual && attemptRestore) {
        _setOperation(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.failed,
            messageCode: BillingMessageCode.purchaseFailed,
          ),
        );
      } else {
        _notifySafely();
      }
      return;
    }

    final products = <String, BillingProduct>{
      for (final product in queryResult.products) product.productId: product,
    };
    final hasPremiumProduct = products.containsKey(kPremiumUnlockProductId);
    _state = _state.copyWith(
      storeStatus: hasPremiumProduct
          ? BillingStoreStatus.available
          : (queryResult.errorMessage == null
                ? BillingStoreStatus.available
                : BillingStoreStatus.error),
      products: products,
      isCatalogLoading: false,
      lastSyncAt: _now(),
    );
    _notifySafely();

    final ownedPurchases = await _gateway.queryOwnedPurchases();
    if (_isDisposed) {
      return;
    }
    if (ownedPurchases != null) {
      final outcome = await _applyOwnedPurchases(
        ownedPurchases,
        source: attemptRestore
            ? BillingEntitlementSource.restore
            : BillingEntitlementSource.sync,
      );
      await _persistSnapshot();
      if (reason == BillingRefreshReason.manual && attemptRestore) {
        _setOperation(
          outcome == _OwnedPurchaseSyncResult.owned
              ? const BillingOperation(
                  type: BillingOperationType.restore,
                  status: BillingOperationStatus.restored,
                  messageCode: BillingMessageCode.restoreSuccess,
                )
              : const BillingOperation(
                  type: BillingOperationType.restore,
                  status: BillingOperationStatus.failed,
                  messageCode: BillingMessageCode.restoreNotFound,
                ),
        );
      } else {
        _notifySafely();
      }
      return;
    }

    await _persistSnapshot();
    if (!attemptRestore) {
      return;
    }

    final context = _RestoreContext(reason: reason);
    _pendingRestoreContext = context;
    try {
      final started = await _gateway.restorePurchases();
      if (!started && identical(_pendingRestoreContext, context)) {
        _pendingRestoreContext = null;
        _setOperation(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.failed,
            messageCode: BillingMessageCode.purchaseFailed,
          ),
        );
        return;
      }
    } catch (_) {
      if (identical(_pendingRestoreContext, context)) {
        _pendingRestoreContext = null;
        _setOperation(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.failed,
            messageCode: BillingMessageCode.purchaseFailed,
          ),
        );
      }
      return;
    }
    unawaited(_finishRestoreIfSilent(context));
  }

  Future<bool> _safeIsAvailable() async {
    try {
      return await _gateway.isAvailable();
    } catch (_) {
      return false;
    }
  }

  Future<BillingProductQueryResult?> _safeQueryProducts() async {
    try {
      return await _gateway.queryProducts(<String>{kPremiumUnlockProductId});
    } catch (_) {
      return null;
    }
  }

  Future<_OwnedPurchaseSyncResult> _applyOwnedPurchases(
    List<BillingPurchase> purchases, {
    required BillingEntitlementSource source,
  }) async {
    BillingPurchase? premiumPurchase;
    for (final purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        unawaited(_gateway.completePurchase(purchase));
      }
      if (purchase.productId != kPremiumUnlockProductId) {
        continue;
      }
      if (purchase.status == BillingGatewayPurchaseStatus.purchased ||
          purchase.status == BillingGatewayPurchaseStatus.restored) {
        premiumPurchase = purchase;
        break;
      }
    }

    if (premiumPurchase != null) {
      await _grantPremiumUnlock(
        source: source,
        purchaseKey: premiumPurchase.purchaseKey,
        purchaseId: premiumPurchase.purchaseId,
        transactionDate: premiumPurchase.transactionDate,
      );
      return _OwnedPurchaseSyncResult.owned;
    }

    await _revokePremiumUnlock();
    return _OwnedPurchaseSyncResult.notOwned;
  }

  Future<void> _handlePurchaseUpdates(List<BillingPurchase> purchases) async {
    if (_isDisposed) {
      return;
    }
    if (purchases.isEmpty) {
      await _handleEmptyPurchaseUpdate();
      return;
    }

    var restoredPremium = false;
    for (final purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        unawaited(_gateway.completePurchase(purchase));
      }
      if (purchase.productId != kPremiumUnlockProductId) {
        continue;
      }
      switch (purchase.status) {
        case BillingGatewayPurchaseStatus.pending:
          _setOperation(
            const BillingOperation(
              type: BillingOperationType.purchase,
              status: BillingOperationStatus.pending,
              messageCode: BillingMessageCode.purchasePending,
            ),
          );
          break;
        case BillingGatewayPurchaseStatus.purchased:
          final isNewPurchaseKey = _handledPurchaseKeys.add(
            purchase.purchaseKey,
          );
          if (isNewPurchaseKey || !isPremiumUnlocked) {
            await _grantPremiumUnlock(
              source: BillingEntitlementSource.purchase,
              purchaseKey: purchase.purchaseKey,
              purchaseId: purchase.purchaseId,
              transactionDate: purchase.transactionDate,
            );
          }
          if (_pendingRestoreContext != null) {
            restoredPremium = true;
            _pendingRestoreContext = null;
            _setOperation(
              const BillingOperation(
                type: BillingOperationType.restore,
                status: BillingOperationStatus.restored,
                messageCode: BillingMessageCode.restoreSuccess,
              ),
            );
          } else if (isNewPurchaseKey) {
            _setOperation(
              const BillingOperation(
                type: BillingOperationType.purchase,
                status: BillingOperationStatus.success,
                messageCode: BillingMessageCode.purchaseSuccess,
              ),
            );
          }
          break;
        case BillingGatewayPurchaseStatus.restored:
          final isNewPurchaseKey = _handledPurchaseKeys.add(
            purchase.purchaseKey,
          );
          if (isNewPurchaseKey || !isPremiumUnlocked) {
            await _grantPremiumUnlock(
              source: BillingEntitlementSource.restore,
              purchaseKey: purchase.purchaseKey,
              purchaseId: purchase.purchaseId,
              transactionDate: purchase.transactionDate,
            );
          }
          restoredPremium = true;
          if (_pendingRestoreContext?.reason == BillingRefreshReason.manual) {
            _setOperation(
              const BillingOperation(
                type: BillingOperationType.restore,
                status: BillingOperationStatus.restored,
                messageCode: BillingMessageCode.restoreSuccess,
              ),
            );
          }
          _pendingRestoreContext = null;
          break;
        case BillingGatewayPurchaseStatus.canceled:
          final restoring = _pendingRestoreContext != null;
          _pendingRestoreContext = null;
          _setOperation(
            BillingOperation(
              type: restoring
                  ? BillingOperationType.restore
                  : BillingOperationType.purchase,
              status: BillingOperationStatus.cancelled,
              messageCode: BillingMessageCode.purchaseCancelled,
            ),
          );
          break;
        case BillingGatewayPurchaseStatus.error:
          final restoring = _pendingRestoreContext != null;
          _pendingRestoreContext = null;
          _setOperation(
            BillingOperation(
              type: restoring
                  ? BillingOperationType.restore
                  : BillingOperationType.purchase,
              status: BillingOperationStatus.failed,
              messageCode: BillingMessageCode.purchaseFailed,
            ),
          );
          break;
      }
    }

    if (_pendingRestoreContext != null && restoredPremium) {
      final context = _pendingRestoreContext!;
      _pendingRestoreContext = null;
      if (context.reason == BillingRefreshReason.manual) {
        _setOperation(
          const BillingOperation(
            type: BillingOperationType.restore,
            status: BillingOperationStatus.restored,
            messageCode: BillingMessageCode.restoreSuccess,
          ),
        );
      }
    }
  }

  Future<void> _handleEmptyPurchaseUpdate() async {
    final context = _pendingRestoreContext;
    if (context == null) {
      return;
    }
    _pendingRestoreContext = null;
    if (context.reason == BillingRefreshReason.manual) {
      _setOperation(
        const BillingOperation(
          type: BillingOperationType.restore,
          status: BillingOperationStatus.failed,
          messageCode: BillingMessageCode.restoreNotFound,
        ),
      );
    } else {
      _notifySafely();
    }
  }

  Future<void> _finishRestoreIfSilent(_RestoreContext context) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (_isDisposed || !identical(_pendingRestoreContext, context)) {
      return;
    }
    final hadCachedEntitlement = isPremiumUnlocked;
    _pendingRestoreContext = null;
    if (context.reason == BillingRefreshReason.manual) {
      _setOperation(
        hadCachedEntitlement
            ? const BillingOperation(
                type: BillingOperationType.restore,
                status: BillingOperationStatus.restored,
                messageCode: BillingMessageCode.restoreSuccess,
              )
            : const BillingOperation(
                type: BillingOperationType.restore,
                status: BillingOperationStatus.failed,
                messageCode: BillingMessageCode.restoreNotFound,
              ),
      );
    }
  }

  Future<void> _grantPremiumUnlock({
    required BillingEntitlementSource source,
    required String purchaseKey,
    String? purchaseId,
    String? transactionDate,
  }) async {
    final now = _now();
    final current = _state.entitlements[AppEntitlement.premiumUnlock];
    final nextRecord = BillingEntitlementRecord(
      entitlement: AppEntitlement.premiumUnlock,
      productId: kPremiumUnlockProductId,
      isActive: true,
      source: source,
      updatedAt: now,
      lastVerifiedAt: now,
      purchaseId: purchaseId ?? purchaseKey,
      transactionDate: transactionDate,
    );
    if (current != null &&
        current.isActive == nextRecord.isActive &&
        current.productId == nextRecord.productId &&
        current.source == nextRecord.source &&
        current.purchaseId == nextRecord.purchaseId &&
        current.transactionDate == nextRecord.transactionDate) {
      return;
    }
    final nextEntitlements = <AppEntitlement, BillingEntitlementRecord>{
      ..._state.entitlements,
      AppEntitlement.premiumUnlock: nextRecord,
    };
    _state = _state.copyWith(entitlements: nextEntitlements, lastSyncAt: now);
    await _persistSnapshot();
    _notifySafely();
  }

  Future<void> _revokePremiumUnlock() async {
    final current = _state.entitlements[AppEntitlement.premiumUnlock];
    if (current == null || !current.isActive) {
      return;
    }
    final now = _now();
    final nextEntitlements = <AppEntitlement, BillingEntitlementRecord>{
      ..._state.entitlements,
      AppEntitlement.premiumUnlock: current.copyWith(
        isActive: false,
        source: BillingEntitlementSource.sync,
        updatedAt: now,
        lastVerifiedAt: now,
      ),
    };
    _state = _state.copyWith(entitlements: nextEntitlements, lastSyncAt: now);
    await _persistSnapshot();
    _notifySafely();
  }

  Future<void> _persistSnapshot() {
    return _saveSnapshot(
      BillingStoreSnapshot(
        entitlements: _state.entitlements,
        lastSyncAt: _state.lastSyncAt,
      ),
    );
  }

  void _setOperation(BillingOperation operation) {
    _state = _state.copyWith(operation: operation);
    _notifySafely();
  }

  void _failPendingRestore(BillingOperation failureOperation) {
    if (_pendingRestoreContext != null) {
      _pendingRestoreContext = null;
      _setOperation(failureOperation);
      return;
    }
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

  Future<BillingStoreSnapshot> _hydrateAccountSnapshot({
    required String accountId,
    required BillingStoreSnapshot localSnapshot,
  }) async {
    var snapshot = localSnapshot;
    if (snapshot.entitlements.isEmpty) {
      try {
        final guestSnapshot = await _store.loadSnapshot();
        if (guestSnapshot.entitlements.isNotEmpty) {
          snapshot = guestSnapshot;
        }
      } catch (_) {}
    }

    final remoteSnapshot = await _safeFetchRemoteSnapshot(accountId);
    if (remoteSnapshot != null) {
      snapshot = _mergeSnapshots(snapshot, remoteSnapshot);
    }

    if (_isDisposed) {
      return snapshot;
    }

    try {
      await _store.saveSnapshot(snapshot, accountId: accountId);
    } catch (_) {}
    return snapshot;
  }

  Future<BillingStoreSnapshot?> _safeFetchRemoteSnapshot(
    String accountId,
  ) async {
    try {
      return await _accountEntitlementStore.fetchSnapshot(accountId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveSnapshot(BillingStoreSnapshot snapshot) async {
    final activeAccountId = _accountId;
    try {
      await _store.saveSnapshot(snapshot, accountId: activeAccountId);
    } catch (_) {}
    if (activeAccountId == null) {
      return;
    }
    try {
      await _accountEntitlementStore.saveSnapshot(activeAccountId, snapshot);
    } catch (_) {}
  }

  BillingStoreSnapshot _mergeSnapshots(
    BillingStoreSnapshot first,
    BillingStoreSnapshot second,
  ) {
    final merged = <AppEntitlement, BillingEntitlementRecord>{};
    final keys = <AppEntitlement>{
      ...first.entitlements.keys,
      ...second.entitlements.keys,
    };
    for (final entitlement in keys) {
      final current = first.entitlements[entitlement];
      final candidate = second.entitlements[entitlement];
      if (current == null) {
        merged[entitlement] = candidate!;
        continue;
      }
      if (candidate == null) {
        merged[entitlement] = current;
        continue;
      }
      final currentStamp = current.lastVerifiedAt ?? current.updatedAt;
      final candidateStamp = candidate.lastVerifiedAt ?? candidate.updatedAt;
      merged[entitlement] = candidateStamp.isAfter(currentStamp)
          ? candidate
          : current;
    }
    final lastSyncAt = _latestDate(first.lastSyncAt, second.lastSyncAt);
    return BillingStoreSnapshot(
      entitlements: Map<AppEntitlement, BillingEntitlementRecord>.unmodifiable(
        merged,
      ),
      lastSyncAt: lastSyncAt,
    );
  }

  DateTime? _latestDate(DateTime? first, DateTime? second) {
    if (first == null) {
      return second;
    }
    if (second == null) {
      return first;
    }
    return second.isAfter(first) ? second : first;
  }

  String? _normalizeAccountId(String? accountId) {
    final trimmed = accountId?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  bool _isStaleAccountRequest(int requestRevision, String? accountId) {
    return _isDisposed ||
        requestRevision != _accountRequestRevision ||
        _accountId != accountId;
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_purchaseSubscription?.cancel());
    unawaited(_gateway.dispose());
    super.dispose();
  }
}

enum _OwnedPurchaseSyncResult { owned, notOwned }

class _RestoreContext {
  const _RestoreContext({required this.reason});

  final BillingRefreshReason reason;
}
