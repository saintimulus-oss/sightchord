import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'audio/harmony_audio_service.dart';
import 'audio/sightchord_audio_scope.dart';
import 'l10n/app_localizations.dart';
import 'main_menu_page.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';

class MyApp extends StatefulWidget {
  MyApp({
    super.key,
    AppSettingsController? controller,
    StudyHarmonyProgressController? studyHarmonyProgressController,
    HarmonyAudioService? harmonyAudioService,
  }) : controller = controller ?? AppSettingsController(),
       _ownsController = controller == null,
       studyHarmonyProgressController =
           studyHarmonyProgressController ?? StudyHarmonyProgressController(),
       _ownsStudyHarmonyProgressController =
           studyHarmonyProgressController == null,
       harmonyAudioService = harmonyAudioService ?? HarmonyAudioService(),
       _ownsHarmonyAudioService = harmonyAudioService == null;

  final AppSettingsController controller;
  final bool _ownsController;
  final StudyHarmonyProgressController studyHarmonyProgressController;
  final bool _ownsStudyHarmonyProgressController;
  final HarmonyAudioService harmonyAudioService;
  final bool _ownsHarmonyAudioService;

  static const List<Locale> supportedLocales =
      AppLocalizations.supportedLocales;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color _accentPurple = Color(0xFF6E56CF);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _darkBackground = Color(0xFF1A1B20);

  @override
  void dispose() {
    if (widget._ownsHarmonyAudioService) {
      unawaited(widget.harmonyAudioService.dispose());
    }
    if (widget._ownsStudyHarmonyProgressController) {
      widget.studyHarmonyProgressController.dispose();
    }
    if (widget._ownsController) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _accentPurple,
          brightness: brightness,
        ).copyWith(
          primary: _accentPurple,
          onPrimary: Colors.white,
          primaryContainer: isDark
              ? const Color(0xFF2D2554)
              : const Color(0xFFEDE9FF),
          onPrimaryContainer: isDark
              ? const Color(0xFFF2EEFF)
              : const Color(0xFF241C51),
          secondary: _accentPurple,
          onSecondary: Colors.white,
          surface: isDark ? const Color(0xFF202229) : Colors.white,
          onSurface: isDark ? const Color(0xFFF5F6FA) : const Color(0xFF17181D),
          onSurfaceVariant: isDark
              ? const Color(0xFFB9BDCA)
              : const Color(0xFF616775),
          surfaceContainerLowest: isDark
              ? const Color(0xFF131419)
              : const Color(0xFFFFFFFF),
          surfaceContainerLow: isDark
              ? const Color(0xFF1C1E25)
              : const Color(0xFFF8F9FD),
          surfaceContainer: isDark
              ? const Color(0xFF23262E)
              : const Color(0xFFF2F4F9),
          surfaceContainerHigh: isDark
              ? const Color(0xFF2A2D35)
              : const Color(0xFFECEEF5),
          surfaceContainerHighest: isDark
              ? const Color(0xFF31343D)
              : const Color(0xFFE4E7EF),
          outline: isDark ? const Color(0xFF5C6170) : const Color(0xFFD1D6E1),
          outlineVariant: isDark
              ? const Color(0xFF3A3E49)
              : const Color(0xFFE6E9F0),
        );
    final textTheme = ThemeData(brightness: brightness, useMaterial3: true)
        .textTheme
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? _darkBackground : _lightBackground,
      canvasColor: isDark ? _darkBackground : _lightBackground,
      textTheme: textTheme.copyWith(
        displayMedium: textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.6,
          height: 0.96,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.1,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surfaceContainerLow,
          minimumSize: const Size.square(52),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        disabledColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: colorScheme.outlineVariant),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return SightChordAudioScope(
          harmonyAudio: widget.harmonyAudioService,
          child: MaterialApp(
            title: 'Chordest',
            debugShowCheckedModeBanner: false,
            locale: widget.controller.settings.locale,
            supportedLocales: MyApp.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            themeMode: widget.controller.settings.themeMode,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            home: MainMenuPage(
              controller: widget.controller,
              studyHarmonyProgressController:
                  widget.studyHarmonyProgressController,
            ),
          ),
        );
      },
    );
  }
}
