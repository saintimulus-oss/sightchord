import 'package:chordest/auth/account_auth_service.dart';
import 'package:chordest/auth/account_controller.dart';
import 'package:chordest/auth/account_models.dart';
import 'package:chordest/auth/account_scope.dart';
import 'package:chordest/auth/account_sheet.dart';
import 'package:chordest/billing/billing_controller.dart';
import 'package:chordest/billing/billing_scope.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'closing the account sheet clears messages without dispose errors',
    (WidgetTester tester) async {
      final accountController = AccountController(
        service: _UnconfiguredAccountAuthService(),
      );
      final billingController = BillingController.noop();
      addTearDown(accountController.dispose);
      addTearDown(billingController.dispose);

      await accountController.signIn(
        email: 'demo@example.com',
        password: 'secret-123',
      );
      expect(
        accountController.state.messageCode,
        AccountMessageCode.authUnavailable,
      );

      await tester.pumpWidget(
        AccountScope(
          controller: accountController,
          child: BillingScope(
            controller: billingController,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: FilledButton(
                      onPressed: () => showAccountSheet(context),
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(AccountSheet), findsOneWidget);

      await tester.tap(find.byType(FilledButton).last);
      await tester.pumpAndSettle();

      expect(find.byType(AccountSheet), findsNothing);
      expect(accountController.state.messageCode, isNull);
      expect(tester.takeException(), isNull);
    },
  );
}

class _UnconfiguredAccountAuthService implements AccountAuthService {
  @override
  AppAccountUser? get currentUser => null;

  @override
  Stream<AppAccountUser?> get authStateChanges =>
      const Stream<AppAccountUser?>.empty();

  @override
  Future<bool> initialize() async => false;

  @override
  Future<AppAccountUser> register({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount({String? currentPassword}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<AppAccountUser> signIn({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
