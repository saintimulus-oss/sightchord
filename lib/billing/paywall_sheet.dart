import 'dart:async';

import 'package:flutter/material.dart';

import '../auth/account_scope.dart';
import '../auth/account_sheet.dart';
import '../l10n/app_localizations.dart';
import 'billing_controller.dart';
import 'billing_models.dart';
import 'billing_scope.dart';
import 'premium_feature_access.dart';

Future<void> showPremiumPaywallSheet(
  BuildContext context, {
  PremiumFeature? highlightedFeature,
}) {
  final billing = BillingScope.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => PremiumPaywallSheet(
      billing: billing,
      highlightedFeature: highlightedFeature,
    ),
  );
}

class PremiumPaywallSheet extends StatefulWidget {
  const PremiumPaywallSheet({
    super.key,
    required this.billing,
    this.highlightedFeature,
  });

  final BillingController billing;
  final PremiumFeature? highlightedFeature;

  @override
  State<PremiumPaywallSheet> createState() => _PremiumPaywallSheetState();
}

class _PremiumPaywallSheetState extends State<PremiumPaywallSheet> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.billing.synchronize(reason: BillingRefreshReason.manual));
  }

  @override
  void dispose() {
    widget.billing.dismissMessage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final account = AccountScope.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[widget.billing, account]),
      builder: (context, _) {
        final state = widget.billing.state;
        final product = widget.billing.premiumProduct;
        final accountState = account.state;
        final buyLabel = product != null
            ? l10n.premiumUnlockBuyButton(product.priceLabel)
            : l10n.premiumUnlockBuyButtonUnavailable;
        final operationMessage = _operationMessage(l10n, state.operation);
        final highlightLabel = _highlightLabel(l10n, widget.highlightedFeature);

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.premiumUnlockTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.premiumUnlockBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                if (highlightLabel != null) ...[
                  const SizedBox(height: 12),
                  _InlineInfoCard(
                    icon: Icons.lock_outline_rounded,
                    title: l10n.premiumUnlockRequestedFeatureTitle,
                    body: highlightLabel,
                  ),
                ],
                const SizedBox(height: 12),
                _InlineInfoCard(
                  icon: Icons.person_outline_rounded,
                  title: l10n.premiumUnlockAccountSyncTitle,
                  body: !accountState.isConfigured
                      ? l10n.premiumUnlockAccountSyncUnavailableBody
                      : accountState.isSignedIn
                      ? l10n.premiumUnlockAccountSyncSignedInBody(
                          accountState.currentUser!.displayLabel,
                        )
                      : l10n.premiumUnlockAccountSyncSignedOutBody,
                ),
                const SizedBox(height: 16),
                if (state.usesCachedEntitlement)
                  _InlineInfoCard(
                    icon: Icons.cloud_off_rounded,
                    title: l10n.premiumUnlockOfflineCacheTitle,
                    body: l10n.premiumUnlockOfflineCacheBody,
                  ),
                if (operationMessage != null) ...[
                  const SizedBox(height: 12),
                  _InlineInfoCard(
                    icon: _operationIcon(state.operation),
                    title: operationMessage.$1,
                    body: operationMessage.$2,
                  ),
                ],
                const SizedBox(height: 16),
                _TierCard(
                  title: l10n.premiumUnlockFreeTierTitle,
                  items: [
                    l10n.premiumUnlockFreeTierLineGenerator,
                    l10n.premiumUnlockFreeTierLineAnalyzer,
                    l10n.premiumUnlockFreeTierLineMetronome,
                  ],
                ),
                const SizedBox(height: 12),
                _TierCard(
                  title: l10n.premiumUnlockPremiumTierTitle,
                  highlight: true,
                  items: [
                    l10n.premiumUnlockPremiumLineSmartGenerator,
                    l10n.premiumUnlockPremiumLineHarmonyColors,
                    l10n.premiumUnlockPremiumLineAdvancedSmartControls,
                  ],
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  key: const ValueKey('premium-buy-button'),
                  onPressed: state.isPremiumUnlocked ||
                          state.operation.isBusy ||
                          state.isCatalogLoading ||
                          product == null
                      ? null
                      : widget.billing.purchasePremiumUnlock,
                  icon: Icon(
                    state.isPremiumUnlocked
                        ? Icons.check_circle_rounded
                        : Icons.workspace_premium_rounded,
                  ),
                  label: Text(
                    state.isPremiumUnlocked
                        ? l10n.premiumUnlockAlreadyOwned
                        : buyLabel,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    OutlinedButton(
                      key: const ValueKey('premium-restore-button'),
                      onPressed: state.operation.isBusy
                          ? null
                          : widget.billing.restorePurchases,
                      child: Text(l10n.premiumUnlockRestoreButton),
                    ),
                    OutlinedButton(
                      key: const ValueKey('premium-account-button'),
                      onPressed: () => showAccountSheet(context),
                      child: Text(l10n.premiumUnlockAccountOpenButton),
                    ),
                    OutlinedButton(
                      key: const ValueKey('premium-close-button'),
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: Text(l10n.premiumUnlockKeepFreeButton),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  product == null
                      ? l10n.premiumUnlockStoreFallbackBody
                      : l10n.premiumUnlockStorePriceHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  (String, String)? _operationMessage(
    AppLocalizations l10n,
    BillingOperation operation,
  ) {
    final messageCode = operation.messageCode;
    if (messageCode == null) {
      return null;
    }
    return switch (messageCode) {
      BillingMessageCode.storeUnavailable => (
        l10n.premiumUnlockStoreUnavailableTitle,
        l10n.premiumUnlockStoreUnavailableBody,
      ),
      BillingMessageCode.productUnavailable => (
        l10n.premiumUnlockProductUnavailableTitle,
        l10n.premiumUnlockProductUnavailableBody,
      ),
      BillingMessageCode.purchaseSuccess => (
        l10n.premiumUnlockPurchaseSuccessTitle,
        l10n.premiumUnlockPurchaseSuccessBody,
      ),
      BillingMessageCode.restoreSuccess => (
        l10n.premiumUnlockRestoreSuccessTitle,
        l10n.premiumUnlockRestoreSuccessBody,
      ),
      BillingMessageCode.restoreNotFound => (
        l10n.premiumUnlockRestoreNotFoundTitle,
        l10n.premiumUnlockRestoreNotFoundBody,
      ),
      BillingMessageCode.purchaseCancelled => (
        l10n.premiumUnlockPurchaseCancelledTitle,
        l10n.premiumUnlockPurchaseCancelledBody,
      ),
      BillingMessageCode.purchasePending => (
        l10n.premiumUnlockPurchasePendingTitle,
        l10n.premiumUnlockPurchasePendingBody,
      ),
      BillingMessageCode.purchaseFailed => (
        l10n.premiumUnlockPurchaseFailedTitle,
        l10n.premiumUnlockPurchaseFailedBody,
      ),
      BillingMessageCode.alreadyUnlocked => (
        l10n.premiumUnlockAlreadyOwnedTitle,
        l10n.premiumUnlockAlreadyOwnedBody,
      ),
    };
  }

  String? _highlightLabel(
    AppLocalizations l10n,
    PremiumFeature? feature,
  ) {
    return switch (feature) {
      PremiumFeature.smartGenerator => l10n.premiumUnlockHighlightSmartGenerator,
      PremiumFeature.advancedHarmony => l10n.premiumUnlockHighlightAdvancedHarmony,
      null => null,
    };
  }

  IconData _operationIcon(BillingOperation operation) {
    return switch (operation.status) {
      BillingOperationStatus.success ||
      BillingOperationStatus.restored => Icons.check_circle_rounded,
      BillingOperationStatus.cancelled => Icons.info_outline_rounded,
      BillingOperationStatus.pending ||
      BillingOperationStatus.inProgress => Icons.hourglass_top_rounded,
      BillingOperationStatus.failed => Icons.error_outline_rounded,
      BillingOperationStatus.idle => Icons.info_outline_rounded,
    };
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.title,
    required this.items,
    this.highlight = false,
  });

  final String title;
  final List<String> items;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlight
            ? colorScheme.primaryContainer.withValues(alpha: 0.48)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlight
              ? colorScheme.primary.withValues(alpha: 0.22)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            for (final item in items) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      highlight
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
              if (item != items.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _InlineInfoCard extends StatelessWidget {
  const _InlineInfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
