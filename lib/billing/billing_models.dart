const String kPremiumUnlockProductId = 'premium_unlock';

enum AppEntitlement { premiumUnlock }

enum BillingEntitlementSource { cache, purchase, restore, sync }

class BillingEntitlementRecord {
  const BillingEntitlementRecord({
    required this.entitlement,
    required this.productId,
    required this.isActive,
    required this.source,
    required this.updatedAt,
    this.lastVerifiedAt,
    this.purchaseId,
    this.transactionDate,
  });

  final AppEntitlement entitlement;
  final String productId;
  final bool isActive;
  final BillingEntitlementSource source;
  final DateTime updatedAt;
  final DateTime? lastVerifiedAt;
  final String? purchaseId;
  final String? transactionDate;

  BillingEntitlementRecord copyWith({
    AppEntitlement? entitlement,
    String? productId,
    bool? isActive,
    BillingEntitlementSource? source,
    DateTime? updatedAt,
    DateTime? lastVerifiedAt,
    String? purchaseId,
    String? transactionDate,
  }) {
    return BillingEntitlementRecord(
      entitlement: entitlement ?? this.entitlement,
      productId: productId ?? this.productId,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      updatedAt: updatedAt ?? this.updatedAt,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      purchaseId: purchaseId ?? this.purchaseId,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'entitlement': entitlement.name,
      'productId': productId,
      'isActive': isActive,
      'source': source.name,
      'updatedAt': updatedAt.toIso8601String(),
      'lastVerifiedAt': lastVerifiedAt?.toIso8601String(),
      'purchaseId': purchaseId,
      'transactionDate': transactionDate,
    };
  }

  static BillingEntitlementRecord? fromJson(Map<String, Object?> json) {
    final entitlementName = json['entitlement'] as String?;
    final sourceName = json['source'] as String?;
    final updatedAt = DateTime.tryParse(json['updatedAt'] as String? ?? '');
    if (entitlementName == null || sourceName == null || updatedAt == null) {
      return null;
    }

    AppEntitlement? entitlement;
    for (final candidate in AppEntitlement.values) {
      if (candidate.name == entitlementName) {
        entitlement = candidate;
        break;
      }
    }
    BillingEntitlementSource? source;
    for (final candidate in BillingEntitlementSource.values) {
      if (candidate.name == sourceName) {
        source = candidate;
        break;
      }
    }
    if (entitlement == null || source == null) {
      return null;
    }

    return BillingEntitlementRecord(
      entitlement: entitlement,
      productId: json['productId'] as String? ?? kPremiumUnlockProductId,
      isActive: json['isActive'] as bool? ?? false,
      source: source,
      updatedAt: updatedAt,
      lastVerifiedAt: DateTime.tryParse(
        json['lastVerifiedAt'] as String? ?? '',
      ),
      purchaseId: json['purchaseId'] as String?,
      transactionDate: json['transactionDate'] as String?,
    );
  }
}

class BillingProduct {
  const BillingProduct({
    required this.productId,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.rawProductDetails,
  });

  final String productId;
  final String title;
  final String description;
  final String priceLabel;
  final Object rawProductDetails;
}

class BillingProductQueryResult {
  const BillingProductQueryResult({
    this.products = const <BillingProduct>[],
    this.notFoundProductIds = const <String>{},
    this.errorMessage,
  });

  final List<BillingProduct> products;
  final Set<String> notFoundProductIds;
  final String? errorMessage;
}

enum BillingGatewayPurchaseStatus { pending, purchased, restored, canceled, error }

class BillingPurchase {
  const BillingPurchase({
    required this.productId,
    required this.status,
    required this.pendingCompletePurchase,
    this.purchaseId,
    this.transactionDate,
    this.errorMessage,
    this.errorCode,
    this.rawPurchase,
  });

  final String productId;
  final BillingGatewayPurchaseStatus status;
  final bool pendingCompletePurchase;
  final String? purchaseId;
  final String? transactionDate;
  final String? errorMessage;
  final String? errorCode;
  final Object? rawPurchase;

  String get purchaseKey {
    final parts = <String>[
      productId,
      status.name,
      if (purchaseId != null && purchaseId!.isNotEmpty) purchaseId!,
      if (transactionDate != null && transactionDate!.isNotEmpty)
        transactionDate!,
    ];
    return parts.join('|');
  }
}

enum BillingStoreStatus { unknown, available, unavailable, error }

enum BillingOperationType { purchase, restore }

enum BillingOperationStatus {
  idle,
  inProgress,
  pending,
  success,
  restored,
  cancelled,
  failed,
}

enum BillingMessageCode {
  storeUnavailable,
  productUnavailable,
  purchaseSuccess,
  restoreSuccess,
  restoreNotFound,
  purchaseCancelled,
  purchasePending,
  purchaseFailed,
  alreadyUnlocked,
}

class BillingOperation {
  const BillingOperation({
    required this.type,
    required this.status,
    this.messageCode,
  });

  const BillingOperation.idle()
    : type = BillingOperationType.purchase,
      status = BillingOperationStatus.idle,
      messageCode = null;

  final BillingOperationType type;
  final BillingOperationStatus status;
  final BillingMessageCode? messageCode;

  bool get isBusy =>
      status == BillingOperationStatus.inProgress ||
      status == BillingOperationStatus.pending;
}

class BillingState {
  const BillingState({
    this.entitlements = const <AppEntitlement, BillingEntitlementRecord>{},
    this.products = const <String, BillingProduct>{},
    this.storeStatus = BillingStoreStatus.unknown,
    this.isCatalogLoading = false,
    this.operation = const BillingOperation.idle(),
    this.lastSyncAt,
  });

  final Map<AppEntitlement, BillingEntitlementRecord> entitlements;
  final Map<String, BillingProduct> products;
  final BillingStoreStatus storeStatus;
  final bool isCatalogLoading;
  final BillingOperation operation;
  final DateTime? lastSyncAt;

  bool get isPremiumUnlocked => hasEntitlement(AppEntitlement.premiumUnlock);

  bool get usesCachedEntitlement {
    final record = entitlements[AppEntitlement.premiumUnlock];
    if (record == null || !record.isActive) {
      return false;
    }
    return record.source == BillingEntitlementSource.cache ||
        storeStatus == BillingStoreStatus.unavailable ||
        storeStatus == BillingStoreStatus.error;
  }

  bool hasEntitlement(AppEntitlement entitlement) {
    return entitlements[entitlement]?.isActive ?? false;
  }

  BillingProduct? productForId(String productId) {
    return products[productId];
  }

  BillingState copyWith({
    Map<AppEntitlement, BillingEntitlementRecord>? entitlements,
    Map<String, BillingProduct>? products,
    BillingStoreStatus? storeStatus,
    bool? isCatalogLoading,
    BillingOperation? operation,
    DateTime? lastSyncAt,
  }) {
    return BillingState(
      entitlements: Map<AppEntitlement, BillingEntitlementRecord>.unmodifiable(
        entitlements ?? this.entitlements,
      ),
      products: Map<String, BillingProduct>.unmodifiable(
        products ?? this.products,
      ),
      storeStatus: storeStatus ?? this.storeStatus,
      isCatalogLoading: isCatalogLoading ?? this.isCatalogLoading,
      operation: operation ?? this.operation,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }
}
