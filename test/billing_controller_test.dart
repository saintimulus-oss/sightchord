import 'dart:async';

import 'package:chordest/billing/account_entitlement_store.dart';
import 'package:chordest/billing/billing_controller.dart';
import 'package:chordest/billing/billing_gateway.dart';
import 'package:chordest/billing/billing_models.dart';
import 'package:chordest/billing/billing_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late _FakeBillingGateway gateway;
  late _MemoryBillingStore store;
  late _MemoryAccountEntitlementStore accountStore;
  late BillingProduct product;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    now = DateTime(2026, 3, 25, 9);
    gateway = _FakeBillingGateway();
    store = _MemoryBillingStore();
    accountStore = _MemoryAccountEntitlementStore();
    product = BillingProduct(
      productId: kPremiumUnlockProductId,
      title: 'Chordest Premium',
      description: 'Unlock Smart Generator',
      priceLabel: '\$6.99',
      rawProductDetails: const Object(),
    );
  });

  BillingController createController() {
    return BillingController(
      gateway: gateway,
      store: store,
      accountEntitlementStore: accountStore,
      now: () => now,
    );
  }

  test('오프라인이면 캐시된 entitlement를 유지한다', () async {
    store.snapshot = BillingStoreSnapshot(
      entitlements: <AppEntitlement, BillingEntitlementRecord>{
        AppEntitlement.premiumUnlock: BillingEntitlementRecord(
          entitlement: AppEntitlement.premiumUnlock,
          productId: kPremiumUnlockProductId,
          isActive: true,
          source: BillingEntitlementSource.purchase,
          updatedAt: now.subtract(const Duration(days: 2)),
          lastVerifiedAt: now.subtract(const Duration(days: 2)),
          purchaseId: 'cached',
        ),
      },
      lastSyncAt: now.subtract(const Duration(days: 2)),
    );
    gateway.available = false;

    final controller = createController();
    await controller.initialize();
    await controller.synchronize(reason: BillingRefreshReason.startup);

    expect(controller.state.isPremiumUnlocked, isTrue);
    expect(controller.state.storeStatus, BillingStoreStatus.unavailable);
    expect(controller.state.usesCachedEntitlement, isTrue);
  });

  test('Android owned purchase 재조회로 premium을 복원한다', () async {
    gateway.available = true;
    gateway.queryResult = BillingProductQueryResult(products: [product]);
    gateway.ownedPurchases = <BillingPurchase>[
      BillingPurchase(
        productId: kPremiumUnlockProductId,
        status: BillingGatewayPurchaseStatus.purchased,
        pendingCompletePurchase: false,
        purchaseId: 'owned-1',
        transactionDate: '1700000000',
      ),
    ];

    final controller = createController();
    await controller.restorePurchases();

    final entitlement =
        controller.state.entitlements[AppEntitlement.premiumUnlock];
    expect(controller.state.isPremiumUnlocked, isTrue);
    expect(controller.state.operation.status, BillingOperationStatus.restored);
    expect(
      controller.state.operation.messageCode,
      BillingMessageCode.restoreSuccess,
    );
    expect(entitlement?.source, BillingEntitlementSource.restore);
    expect(gateway.restoreCalls, 0);
  });

  test('온라인 동기화에서 owned purchase가 없으면 entitlement를 회수한다', () async {
    store.snapshot = BillingStoreSnapshot(
      entitlements: <AppEntitlement, BillingEntitlementRecord>{
        AppEntitlement.premiumUnlock: BillingEntitlementRecord(
          entitlement: AppEntitlement.premiumUnlock,
          productId: kPremiumUnlockProductId,
          isActive: true,
          source: BillingEntitlementSource.purchase,
          updatedAt: now.subtract(const Duration(days: 1)),
          lastVerifiedAt: now.subtract(const Duration(days: 1)),
          purchaseId: 'owned-1',
        ),
      },
      lastSyncAt: now.subtract(const Duration(days: 1)),
    );
    gateway.available = true;
    gateway.queryResult = BillingProductQueryResult(products: [product]);
    gateway.ownedPurchases = const <BillingPurchase>[];

    final controller = createController();
    await controller.synchronize(reason: BillingRefreshReason.resume);

    final entitlement =
        controller.state.entitlements[AppEntitlement.premiumUnlock];
    expect(controller.state.isPremiumUnlocked, isFalse);
    expect(entitlement, isNotNull);
    expect(entitlement?.isActive, isFalse);
    expect(entitlement?.source, BillingEntitlementSource.sync);
  });

  test('중복 구매 업데이트는 idempotent 하게 처리한다', () async {
    final controller = createController();
    await controller.initialize();

    const purchase = BillingPurchase(
      productId: kPremiumUnlockProductId,
      status: BillingGatewayPurchaseStatus.purchased,
      pendingCompletePurchase: false,
      purchaseId: 'purchase-1',
      transactionDate: '1700000001',
    );

    gateway.emit(<BillingPurchase>[purchase]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    gateway.emit(<BillingPurchase>[purchase]);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(controller.state.isPremiumUnlocked, isTrue);
    expect(store.saveCalls, 1);
    expect(
      controller.state.operation.messageCode,
      BillingMessageCode.purchaseSuccess,
    );
  });

  test('구매 대기와 취소 상태를 구분해서 표시한다', () async {
    final controller = createController();
    await controller.initialize();

    gateway.emit(const <BillingPurchase>[
      BillingPurchase(
        productId: kPremiumUnlockProductId,
        status: BillingGatewayPurchaseStatus.pending,
        pendingCompletePurchase: false,
      ),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      controller.state.operation.messageCode,
      BillingMessageCode.purchasePending,
    );

    gateway.emit(const <BillingPurchase>[
      BillingPurchase(
        productId: kPremiumUnlockProductId,
        status: BillingGatewayPurchaseStatus.canceled,
        pendingCompletePurchase: false,
      ),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      controller.state.operation.messageCode,
      BillingMessageCode.purchaseCancelled,
    );
  });

  test('entitlement cache load failure가 나도 initialize가 앱을 막지 않는다', () async {
    final controller = BillingController(
      gateway: gateway,
      store: _FailingBillingStore(),
      accountEntitlementStore: accountStore,
      now: () => now,
    );

    await controller.initialize();

    expect(controller.state.entitlements, isEmpty);
    expect(controller.state.storeStatus, BillingStoreStatus.unknown);
  });

  test('계정 전환 시 원격 entitlement snapshot을 병합한다', () async {
    accountStore.snapshots['user-1'] = BillingStoreSnapshot(
      entitlements: <AppEntitlement, BillingEntitlementRecord>{
        AppEntitlement.premiumUnlock: BillingEntitlementRecord(
          entitlement: AppEntitlement.premiumUnlock,
          productId: kPremiumUnlockProductId,
          isActive: true,
          source: BillingEntitlementSource.restore,
          updatedAt: now,
          lastVerifiedAt: now,
          purchaseId: 'remote-premium',
        ),
      },
      lastSyncAt: now,
    );

    final controller = createController();
    await controller.setAccount('user-1');

    expect(controller.accountId, 'user-1');
    expect(controller.state.isPremiumUnlocked, isTrue);
  });
  test('stale account switch does not overwrite the latest snapshot', () async {
    final delayedStore = _DelayedBillingStore();
    final controller = BillingController(
      gateway: gateway,
      store: delayedStore,
      accountEntitlementStore: const NoopAccountEntitlementStore(),
      now: () => now,
    );

    await controller.initialize();

    final firstSwitch = controller.setAccount('user-1');
    final secondSwitch = controller.setAccount('user-2');

    delayedStore.complete(
      'user-2',
      BillingStoreSnapshot(
        entitlements: <AppEntitlement, BillingEntitlementRecord>{
          AppEntitlement.premiumUnlock: BillingEntitlementRecord(
            entitlement: AppEntitlement.premiumUnlock,
            productId: kPremiumUnlockProductId,
            isActive: true,
            source: BillingEntitlementSource.purchase,
            updatedAt: now,
            lastVerifiedAt: now,
            purchaseId: 'user-2',
          ),
        },
        lastSyncAt: now,
      ),
    );
    await secondSwitch;

    expect(controller.accountId, 'user-2');
    expect(
      controller.state.entitlements[AppEntitlement.premiumUnlock]?.purchaseId,
      'user-2',
    );

    delayedStore.complete(
      'user-1',
      BillingStoreSnapshot(
        entitlements: <AppEntitlement, BillingEntitlementRecord>{
          AppEntitlement.premiumUnlock: BillingEntitlementRecord(
            entitlement: AppEntitlement.premiumUnlock,
            productId: kPremiumUnlockProductId,
            isActive: true,
            source: BillingEntitlementSource.purchase,
            updatedAt: now.subtract(const Duration(days: 1)),
            lastVerifiedAt: now.subtract(const Duration(days: 1)),
            purchaseId: 'user-1',
          ),
        },
        lastSyncAt: now.subtract(const Duration(days: 1)),
      ),
    );
    await firstSwitch;

    expect(controller.accountId, 'user-2');
    expect(
      controller.state.entitlements[AppEntitlement.premiumUnlock]?.purchaseId,
      'user-2',
    );
  });
}

class _FakeBillingGateway implements BillingGateway {
  final StreamController<List<BillingPurchase>> _controller =
      StreamController<List<BillingPurchase>>.broadcast();

  bool available = false;
  BillingProductQueryResult queryResult = const BillingProductQueryResult();
  List<BillingPurchase>? ownedPurchases;
  bool buyResult = true;
  bool restoreResult = true;
  int restoreCalls = 0;
  final List<BillingPurchase> completedPurchases = <BillingPurchase>[];

  @override
  Stream<List<BillingPurchase>> get purchaseStream => _controller.stream;

  void emit(List<BillingPurchase> purchases) {
    _controller.add(purchases);
  }

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<BillingProductQueryResult> queryProducts(
    Set<String> productIds,
  ) async {
    return queryResult;
  }

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async => ownedPurchases;

  @override
  Future<bool> buyNonConsumable(BillingProduct product) async => buyResult;

  @override
  Future<bool> restorePurchases() async {
    restoreCalls += 1;
    return restoreResult;
  }

  @override
  Future<void> completePurchase(BillingPurchase purchase) async {
    completedPurchases.add(purchase);
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

class _MemoryBillingStore extends BillingStore {
  _MemoryBillingStore()
    : super(preferencesLoader: _unsupportedPreferencesLoader);

  BillingStoreSnapshot snapshot = const BillingStoreSnapshot();
  int saveCalls = 0;

  static Future<SharedPreferences> _unsupportedPreferencesLoader() {
    throw UnsupportedError('preferencesLoader is not used in memory tests');
  }

  @override
  Future<BillingStoreSnapshot> loadSnapshot({String? accountId}) async =>
      snapshot;

  @override
  Future<void> saveSnapshot(
    BillingStoreSnapshot nextSnapshot, {
    String? accountId,
  }) async {
    snapshot = nextSnapshot;
    saveCalls += 1;
  }
}

class _FailingBillingStore extends BillingStore {
  _FailingBillingStore()
    : super(
        preferencesLoader: _MemoryBillingStore._unsupportedPreferencesLoader,
      );

  @override
  Future<BillingStoreSnapshot> loadSnapshot({String? accountId}) async {
    throw StateError('simulated billing cache load failure');
  }
}

class _DelayedBillingStore extends BillingStore {
  _DelayedBillingStore()
    : super(
        preferencesLoader: _MemoryBillingStore._unsupportedPreferencesLoader,
      );

  final Map<String, Completer<BillingStoreSnapshot>> _completers =
      <String, Completer<BillingStoreSnapshot>>{};

  @override
  Future<BillingStoreSnapshot> loadSnapshot({String? accountId}) async {
    if (accountId == null) {
      return const BillingStoreSnapshot();
    }
    return (_completers[accountId] ??= Completer<BillingStoreSnapshot>())
        .future;
  }

  @override
  Future<void> saveSnapshot(
    BillingStoreSnapshot nextSnapshot, {
    String? accountId,
  }) async {}

  void complete(String accountId, BillingStoreSnapshot snapshot) {
    final completer = _completers[accountId] ??=
        Completer<BillingStoreSnapshot>();
    if (completer.isCompleted) {
      return;
    }
    completer.complete(snapshot);
  }
}

class _MemoryAccountEntitlementStore implements AccountEntitlementStore {
  final Map<String, BillingStoreSnapshot> snapshots =
      <String, BillingStoreSnapshot>{};

  @override
  Future<BillingStoreSnapshot?> fetchSnapshot(String accountId) async {
    return snapshots[accountId];
  }

  @override
  Future<void> saveSnapshot(
    String accountId,
    BillingStoreSnapshot snapshot,
  ) async {
    snapshots[accountId] = snapshot;
  }
}
