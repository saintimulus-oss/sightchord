import 'package:flutter/material.dart';

import 'billing/billing_scope.dart';
import 'chord_analyzer_page.dart';
import 'l10n/app_localizations.dart';
import 'main_menu/main_menu_settings_sheet.dart';
import 'main_menu/main_menu_view.dart';
import 'practice_home_page.dart';
import 'settings/settings_controller.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key, required this.controller});

  final AppSettingsController controller;

  Future<void> _openMainSettings(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => MainMenuSettingsSheet(controller: controller),
    );
  }

  void _openCodeGenerator(BuildContext context) {
    final initialPremiumUnlocked =
        BillingScope.maybeOf(context)?.isPremiumUnlocked ?? false;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MyHomePage(
          title: 'Chordest',
          controller: controller,
          initialPremiumUnlocked: initialPremiumUnlocked,
        ),
      ),
    );
  }

  void _openChordAnalyzer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChordAnalyzerPage(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MainMenuView(
      title: 'Chordest',
      intro: l10n.mainMenuIntro,
      settingsLabel: l10n.settings,
      generatorTitle: l10n.mainMenuGeneratorTitle,
      generatorSubtitle: l10n.mainMenuGeneratorDescription,
      analyzerTitle: l10n.mainMenuAnalyzerTitle,
      analyzerSubtitle: l10n.mainMenuAnalyzerDescription,
      onOpenSettings: () => _openMainSettings(context),
      onOpenGenerator: () => _openCodeGenerator(context),
      onOpenAnalyzer: () => _openChordAnalyzer(context),
    );
  }
}
