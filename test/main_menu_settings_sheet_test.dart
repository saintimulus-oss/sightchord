import 'package:chordest/billing/billing_controller.dart';
import 'package:chordest/billing/billing_scope.dart';
import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/main_menu/main_menu_settings_sheet.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('premium card matches the settings field width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final settingsController = AppSettingsController(
      initialSettings: PracticeSettings(language: AppLanguage.en),
    );
    final billingController = BillingController.noop();
    addTearDown(settingsController.dispose);
    addTearDown(billingController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BillingScope(
          controller: billingController,
          child: Scaffold(
            body: MainMenuSettingsSheet(controller: settingsController),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final languageWidth = tester
        .getSize(find.byKey(const ValueKey('main-language-selector')))
        .width;
    final premiumCardWidth = tester
        .getSize(find.byKey(const ValueKey('main-premium-card')))
        .width;

    expect(premiumCardWidth, moreOrLessEquals(languageWidth, epsilon: 0.01));
  });
}
