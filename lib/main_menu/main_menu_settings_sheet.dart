import 'dart:async';

import 'package:flutter/material.dart';

import '../billing/billing_models.dart';
import '../billing/billing_scope.dart';
import '../billing/paywall_sheet.dart';
import '../l10n/app_localizations.dart';
import '../settings/practice_settings.dart';
import '../settings/settings_controller.dart';

class MainMenuSettingsSheet extends StatelessWidget {
  const MainMenuSettingsSheet({super.key, required this.controller});

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final billing = BillingScope.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[controller, billing]),
      builder: (context, _) {
        final settings = controller.settings;
        final billingState = billing.state;
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settings,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                      tooltip: l10n.closeSettings,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AppLanguage>(
                  key: const ValueKey('main-language-selector'),
                  initialValue: settings.language,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.language,
                  ),
                  items: AppLanguage.values
                      .map(
                        (language) => DropdownMenuItem<AppLanguage>(
                          value: language,
                          child: Text(_languageLabel(l10n, language)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    unawaited(
                      controller.mutate(
                        (current) => current.copyWith(language: value),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<AppThemeMode>(
                  key: const ValueKey('main-theme-mode-selector'),
                  initialValue: settings.appThemeMode,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.themeMode,
                  ),
                  items: AppThemeMode.values
                      .map(
                        (mode) => DropdownMenuItem<AppThemeMode>(
                          value: mode,
                          child: Text(_themeModeLabel(l10n, mode)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    unawaited(
                      controller.mutate(
                        (current) => current.copyWith(appThemeMode: value),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.premiumUnlockCardTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          billingState.isPremiumUnlocked
                              ? l10n.premiumUnlockCardBodyUnlocked
                              : l10n.premiumUnlockCardBodyLocked,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                        if (billingState.usesCachedEntitlement) ...[
                          const SizedBox(height: 8),
                          Text(
                            l10n.premiumUnlockOfflineCacheBody,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton(
                              key: const ValueKey('main-premium-open-button'),
                              onPressed: () => showPremiumPaywallSheet(context),
                              child: Text(
                                billingState.isPremiumUnlocked
                                    ? l10n.premiumUnlockAlreadyOwned
                                    : l10n.premiumUnlockCardButton,
                              ),
                            ),
                            OutlinedButton(
                              key: const ValueKey('main-premium-restore-button'),
                              onPressed: billingState.operation.isBusy
                                  ? null
                                  : billing.restorePurchases,
                              child: Text(l10n.premiumUnlockRestoreButton),
                            ),
                          ],
                        ),
                        if (billingState.operation.messageCode case final BillingMessageCode code) ...[
                          const SizedBox(height: 10),
                          Text(
                            _billingMessageLine(l10n, code),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _languageLabel(AppLocalizations l10n, AppLanguage language) {
  return switch (language) {
    AppLanguage.system => l10n.systemDefaultLanguage,
    _ => language.nativeLabel,
  };
}

String _themeModeLabel(AppLocalizations l10n, AppThemeMode mode) {
  return switch (mode) {
    AppThemeMode.system => l10n.themeModeSystem,
    AppThemeMode.light => l10n.themeModeLight,
    AppThemeMode.dark => l10n.themeModeDark,
  };
}

String _billingMessageLine(AppLocalizations l10n, BillingMessageCode code) {
  return switch (code) {
    BillingMessageCode.storeUnavailable => l10n.premiumUnlockStoreUnavailableBody,
    BillingMessageCode.productUnavailable => l10n.premiumUnlockProductUnavailableBody,
    BillingMessageCode.purchaseSuccess => l10n.premiumUnlockPurchaseSuccessBody,
    BillingMessageCode.restoreSuccess => l10n.premiumUnlockRestoreSuccessBody,
    BillingMessageCode.restoreNotFound => l10n.premiumUnlockRestoreNotFoundBody,
    BillingMessageCode.purchaseCancelled => l10n.premiumUnlockPurchaseCancelledBody,
    BillingMessageCode.purchasePending => l10n.premiumUnlockPurchasePendingBody,
    BillingMessageCode.purchaseFailed => l10n.premiumUnlockPurchaseFailedBody,
    BillingMessageCode.alreadyUnlocked => l10n.premiumUnlockAlreadyOwnedBody,
  };
}
