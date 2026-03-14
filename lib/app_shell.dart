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
      animation: widget.controller,
      builder: (context, _) {
        return SightChordAudioScope(
          harmonyAudio: widget.harmonyAudioService,
          child: MaterialApp(
            title: 'SightChord',
            debugShowCheckedModeBanner: false,
            locale: widget.controller.settings.locale,
            supportedLocales: MyApp.supportedLocales,
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
