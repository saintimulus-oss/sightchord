import 'billing_models.dart';

abstract interface class BillingGateway {
  Stream<List<BillingPurchase>> get purchaseStream;

  Future<bool> isAvailable();

  Future<BillingProductQueryResult> queryProducts(Set<String> productIds);

  Future<List<BillingPurchase>?> queryOwnedPurchases();

  Future<bool> buyNonConsumable(BillingProduct product);

  Future<bool> restorePurchases();

  Future<void> completePurchase(BillingPurchase purchase);

  Future<void> dispose();
}

class NoopBillingGateway implements BillingGateway {
  const NoopBillingGateway();

  @override
  Stream<List<BillingPurchase>> get purchaseStream =>
      const Stream<List<BillingPurchase>>.empty();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<BillingProductQueryResult> queryProducts(Set<String> productIds) async {
    return BillingProductQueryResult(notFoundProductIds: productIds);
  }

  @override
  Future<List<BillingPurchase>?> queryOwnedPurchases() async => null;

  @override
  Future<bool> buyNonConsumable(BillingProduct product) async => false;

  @override
  Future<bool> restorePurchases() async => false;

  @override
  Future<void> completePurchase(BillingPurchase purchase) async {}

  @override
  Future<void> dispose() async {}
}
