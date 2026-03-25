import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'billing_gateway.dart';
import 'billing_models.dart';

BillingGateway createPlatformBillingGateway() {
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    return InAppPurchaseBillingGateway();
  }
  return const NoopBillingGateway();
}

class InAppPurchaseBillingGateway implements BillingGateway {
  InAppPurchaseBillingGateway({InAppPurchase? inAppPurchase})
    : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseBatch,
      onError: _handlePurchaseError,
    );
  }

  final InAppPurchase _inAppPurchase;
  final StreamController<List<BillingPurchase>> _purchaseController =
      StreamController<List<BillingPurchase>>.broadcast();
  final Map<String, ProductDetails> _productsById = <String, ProductDetails>{};
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  @override
  Stream<List<BillingPurchase>> get purchaseStream => _purchaseController.stream;

  void _handlePurchaseBatch(List<PurchaseDetails> purchases) {
    _purchaseController.add(
      purchases.map(_mapPurchase).toList(growable: false),
    );
  }

  void _handlePurchaseError(Object error, StackTrace stackTrace) {
    _purchaseController.add(
      <BillingPurchase>[
        BillingPurchase(
          productId: kPremiumUnlockProductId,
          status: BillingGatewayPurchaseStatus.error,
          pendingCompletePurchase: false,
          errorMessage: error.toString(),
        ),
      ],
    );
  }

  BillingPurchase _mapPurchase(PurchaseDetails purchase) {
    return BillingPurchase(
      productId: purchase.productID,
      status: switch (purchase.status) {
        PurchaseStatus.pending => BillingGatewayPurchaseStatus.pending,
        PurchaseStatus.purchased => BillingGatewayPurchaseStatus.purchased,
        PurchaseStatus.restored => BillingGatewayPurchaseStatus.restored,
        PurchaseStatus.canceled => BillingGatewayPurchaseStatus.canceled,
        PurchaseStatus.error => BillingGatewayPurchaseStatus.error,
      },
      pendingCompletePurchase: purchase.pendingCompletePurchase,
      purchaseId: purchase.purchaseID,
      transactionDate: purchase.transactionDate,
      errorMessage: purchase.error?.message,
      errorCode: purchase.error?.code,
      rawPurchase: purchase,
    );
  }

  @override
  Future<bool> isAvailable() {
    return _inAppPurchase.isAvailable();
  }

  @override
  Future<BillingProductQueryResult> queryProducts(Set<String> productIds) async {
    final response = await _inAppPurchase.queryProductDetails(productIds);
    final products = <BillingProduct>[
      for (final product in response.productDetails)
        BillingProduct(
          productId: product.id,
          title: product.title,
          description: product.description,
          priceLabel: product.price,
          rawProductDetails: product,
        ),
    ];
    for (final product in response.productDetails) {
      _productsById[product.id] = product;
    }
    return BillingProductQueryResult(
      products: products,
      notFoundProductIds: response.notFoundIDs.toSet(),
      errorMessage: response.error?.message,
    );
  }

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async {
    if (!Platform.isAndroid) {
      return null;
    }
    try {
      final platformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await platformAddition.queryPastPurchases();
      if (response.error != null) {
        return const <BillingPurchase>[];
      }
      return response.pastPurchases
          .map(_mapPurchase)
          .toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> buyNonConsumable(BillingProduct product) async {
    final rawProduct =
        product.rawProductDetails is ProductDetails
            ? product.rawProductDetails as ProductDetails
            : _productsById[product.productId];
    if (rawProduct == null) {
      return false;
    }
    return _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: rawProduct),
    );
  }

  @override
  Future<bool> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> completePurchase(BillingPurchase purchase) async {
    final rawPurchase =
        purchase.rawPurchase is PurchaseDetails
            ? purchase.rawPurchase! as PurchaseDetails
            : null;
    if (rawPurchase == null) {
      return;
    }
    await _inAppPurchase.completePurchase(rawPurchase);
  }

  @override
  Future<void> dispose() async {
    await _purchaseSubscription.cancel();
    await _purchaseController.close();
  }
}
