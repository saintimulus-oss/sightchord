import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'main_menu_page.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    AppSettingsController? controller,
    StudyHarmonyProgressController? studyHarmonyProgressController,
  }) : controller = controller ?? AppSettingsController(),
       studyHarmonyProgressController =
           studyHarmonyProgressController ?? StudyHarmonyProgressController();

  final AppSettingsController controller;
  final StudyHarmonyProgressController studyHarmonyProgressController;

  static const List<Locale> supportedLocales =
      AppLocalizations.supportedLocales;

  ThemeData _buildTheme(Brightness brightness) {
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E6258),
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? const Color(0xFF111716)
          : const Color(0xFFF6F2E8),
      cardTheme: CardThemeData(
        color: brightness == Brightness.dark
            ? baseColorScheme.surfaceContainerLow
            : baseColorScheme.surface,
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'SightChord',
          debugShowCheckedModeBanner: false,
          locale: controller.settings.locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: ThemeMode.system,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          home: MainMenuPage(
            controller: controller,
            studyHarmonyProgressController: studyHarmonyProgressController,
          ),
        );
      },
    );
  }
}
