import 'package:flutter/material.dart';

import '../billing/billing_controller.dart';
import '../billing/billing_scope.dart';
import '../l10n/app_localizations.dart';
import 'account_controller.dart';
import 'account_models.dart';
import 'account_scope.dart';

Future<void> showAccountSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const AccountSheet(),
  );
}

class AccountSheet extends StatefulWidget {
  const AccountSheet({super.key});

  @override
  State<AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends State<AccountSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _createAccount = false;
  AccountController? _accountController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _accountController = AccountScope.of(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _accountController?.dismissMessage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final account = AccountScope.of(context);
    final billing = BillingScope.maybeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: account,
      builder: (context, _) {
        final state = account.state;
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
                  l10n.accountTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _bodyText(l10n, state),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                if (state.messageCode case final AccountMessageCode code) ...[
                  const SizedBox(height: 12),
                  _AccountInfoCard(
                    title: _messageTitle(l10n, code),
                    body: _messageBody(l10n, code),
                  ),
                ],
                const SizedBox(height: 16),
                if (!state.isConfigured) ...[
                  FilledButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n.closeSettings),
                  ),
                ] else if (state.isSignedIn) ...[
                  Text(
                    '${l10n.accountEmailLabel}: ${state.currentUser!.displayLabel}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton(
                        key: const ValueKey('account-sign-out-button'),
                        onPressed: state.isBusy ? null : account.signOut,
                        child: Text(l10n.accountSignOutButton),
                      ),
                      OutlinedButton(
                        key: const ValueKey('account-delete-button'),
                        onPressed: state.isBusy
                            ? null
                            : () => _showDeleteAccountDialog(
                                context,
                                account: account,
                                billing: billing,
                              ),
                        child: Text(l10n.accountDeleteButton),
                      ),
                    ],
                  ),
                ] else ...[
                  TextField(
                    key: const ValueKey('account-email-field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.accountEmailLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const ValueKey('account-password-field'),
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.accountPasswordLabel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const ValueKey('account-submit-button'),
                    onPressed: state.isBusy ? null : () => _submit(account),
                    child: Text(
                      _createAccount
                          ? l10n.accountCreateButton
                          : l10n.accountSignInButton,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      TextButton(
                        key: const ValueKey('account-toggle-mode-button'),
                        onPressed: state.isBusy
                            ? null
                            : () {
                                setState(() {
                                  _createAccount = !_createAccount;
                                });
                              },
                        child: Text(
                          _createAccount
                              ? l10n.accountSwitchToSignInButton
                              : l10n.accountSwitchToCreateButton,
                        ),
                      ),
                      TextButton(
                        key: const ValueKey('account-reset-password-button'),
                        onPressed: state.isBusy
                            ? null
                            : () => _resetPassword(account),
                        child: Text(l10n.accountForgotPasswordButton),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _bodyText(AppLocalizations l10n, AccountState state) {
    if (!state.isConfigured) {
      return l10n.accountCardUnavailableBody;
    }
    final user = state.currentUser;
    if (user != null) {
      return l10n.accountCardSignedInBody(user.displayLabel);
    }
    return l10n.accountCardSignedOutBody;
  }

  String _messageTitle(AppLocalizations l10n, AccountMessageCode code) {
    return switch (code) {
      AccountMessageCode.signedIn => l10n.accountTitle,
      AccountMessageCode.signedUp => l10n.accountTitle,
      AccountMessageCode.signedOut => l10n.accountTitle,
      AccountMessageCode.deleted => l10n.accountTitle,
      AccountMessageCode.passwordResetSent => l10n.accountTitle,
      AccountMessageCode.invalidCredentials => l10n.accountTitle,
      AccountMessageCode.emailInUse => l10n.accountTitle,
      AccountMessageCode.weakPassword => l10n.accountTitle,
      AccountMessageCode.userNotFound => l10n.accountTitle,
      AccountMessageCode.tooManyRequests => l10n.accountTitle,
      AccountMessageCode.networkError => l10n.accountTitle,
      AccountMessageCode.authUnavailable => l10n.accountTitle,
      AccountMessageCode.deleteRequiresRecentLogin => l10n.accountTitle,
      AccountMessageCode.dataDeletionFailed => l10n.accountTitle,
      AccountMessageCode.unknownError => l10n.accountTitle,
    };
  }

  String _messageBody(AppLocalizations l10n, AccountMessageCode code) {
    return switch (code) {
      AccountMessageCode.signedIn => l10n.accountMessageSignedIn,
      AccountMessageCode.signedUp => l10n.accountMessageSignedUp,
      AccountMessageCode.signedOut => l10n.accountMessageSignedOut,
      AccountMessageCode.deleted => l10n.accountMessageDeleted,
      AccountMessageCode.passwordResetSent =>
        l10n.accountMessagePasswordResetSent,
      AccountMessageCode.invalidCredentials =>
        l10n.accountMessageInvalidCredentials,
      AccountMessageCode.emailInUse => l10n.accountMessageEmailInUse,
      AccountMessageCode.weakPassword => l10n.accountMessageWeakPassword,
      AccountMessageCode.userNotFound => l10n.accountMessageUserNotFound,
      AccountMessageCode.tooManyRequests => l10n.accountMessageTooManyRequests,
      AccountMessageCode.networkError => l10n.accountMessageNetworkError,
      AccountMessageCode.authUnavailable => l10n.accountMessageAuthUnavailable,
      AccountMessageCode.deleteRequiresRecentLogin =>
        l10n.accountMessageDeleteRequiresRecentLogin,
      AccountMessageCode.dataDeletionFailed =>
        l10n.accountMessageDataDeletionFailed,
      AccountMessageCode.unknownError => l10n.accountMessageUnknownError,
    };
  }

  Future<void> _submit(AccountController account) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      return;
    }
    if (_createAccount) {
      await account.register(email: email, password: password);
      return;
    }
    await account.signIn(email: email, password: password);
  }

  Future<void> _resetPassword(AccountController account) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      return;
    }
    await account.sendPasswordResetEmail(email: email);
  }

  Future<void> _showDeleteAccountDialog(
    BuildContext context, {
    required AccountController account,
    required BillingController? billing,
  }) async {
    final user = account.state.currentUser;
    if (user == null) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    var errorText = '';
    var isSubmitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> submitDelete() async {
              final password = passwordController.text;
              if (password.isEmpty) {
                setState(() {
                  errorText = l10n.accountDeletePasswordRequired;
                });
                return;
              }
              setState(() {
                errorText = '';
                isSubmitting = true;
              });
              final deletedAccountId = await account.deleteAccount(
                currentPassword: password,
              );
              if (deletedAccountId != null) {
                await billing?.deleteAccountData(deletedAccountId);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                return;
              }
              if (!dialogContext.mounted) {
                return;
              }
              setState(() {
                errorText = _messageBody(
                  l10n,
                  account.state.messageCode ?? AccountMessageCode.unknownError,
                );
                isSubmitting = false;
              });
            }

            return AlertDialog(
              title: Text(l10n.accountDeleteDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.accountDeleteDialogBody(user.displayLabel)),
                  const SizedBox(height: 12),
                  Text(
                    l10n.accountDeletePasswordHelper,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.accountPasswordLabel,
                    ),
                    onSubmitted: (_) {
                      if (!isSubmitting) {
                        submitDelete();
                      }
                    },
                  ),
                  if (errorText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.accountDeleteCancelButton),
                ),
                FilledButton(
                  onPressed: isSubmitting ? null : submitDelete,
                  child: Text(l10n.accountDeleteConfirmButton),
                ),
              ],
            );
          },
        );
      },
    );
    passwordController.dispose();
  }
}

class _AccountInfoCard extends StatelessWidget {
  const _AccountInfoCard({required this.title, required this.body});

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
    );
  }
}
