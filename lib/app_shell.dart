import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/account_controller.dart';
import 'auth/account_scope.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/chordest_audio_scope.dart';
import 'billing/billing_controller.dart';
import 'billing/billing_scope.dart';
import 'l10n/app_localizations.dart';
import 'main_menu_page.dart';
import 'settings/practice_settings.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'ui/chordest_ui_tokens.dart';

class MyApp extends StatefulWidget {
  MyApp({
    super.key,
    AppSettingsController? controller,
    AccountController? accountController,
    BillingController? billingController,
    StudyHarmonyProgressController? studyHarmonyProgressController,
    HarmonyAudioService? harmonyAudioService,
  }) : controller = controller ?? AppSettingsController(),
       _ownsController = controller == null,
       accountController = accountController ?? AccountController.live(),
       _ownsAccountController = accountController == null,
       billingController = billingController ?? BillingController.noop(),
       _ownsBillingController = billingController == null,
       studyHarmonyProgressController =
           studyHarmonyProgressController ?? StudyHarmonyProgressController(),
       _ownsStudyHarmonyProgressController =
           studyHarmonyProgressController == null,
       harmonyAudioService = harmonyAudioService ?? HarmonyAudioService(),
       _ownsHarmonyAudioService = harmonyAudioService == null;

  final AppSettingsController controller;
  final bool _ownsController;
  final AccountController accountController;
  final bool _ownsAccountController;
  final BillingController billingController;
  final bool _ownsBillingController;
  final StudyHarmonyProgressController studyHarmonyProgressController;
  final bool _ownsStudyHarmonyProgressController;
  final HarmonyAudioService harmonyAudioService;
  final bool _ownsHarmonyAudioService;

  static final List<Locale> supportedLocales = supportedAppLocales;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const Color _accentPurple = Color(0xFF6E56CF);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _darkBackground = Color(0xFF15171C);
  String? _lastAttachedAccountId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.accountController.addListener(_handleAccountStateChanged);
    unawaited(_primeBillingState());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    unawaited(widget.billingController.refreshForAppResume());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.accountController.removeListener(_handleAccountStateChanged);
    if (widget._ownsHarmonyAudioService) {
      unawaited(widget.harmonyAudioService.dispose());
    }
    if (widget._ownsStudyHarmonyProgressController) {
      widget.studyHarmonyProgressController.dispose();
    }
    if (widget._ownsBillingController) {
      widget.billingController.dispose();
    }
    if (widget._ownsAccountController) {
      widget.accountController.dispose();
    }
    if (widget._ownsController) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _primeBillingState() async {
    await Future.wait<void>([
      widget.accountController.initialize(),
      widget.billingController.initialize(),
    ]);
    await _syncBillingAccount(force: true);
    await widget.billingController.synchronize(
      reason: BillingRefreshReason.startup,
    );
  }

  void _handleAccountStateChanged() {
    unawaited(_syncBillingAccount());
  }

  Future<void> _syncBillingAccount({bool force = false}) async {
    final accountId = widget.accountController.state.currentUser?.id;
    if (!force && accountId == _lastAttachedAccountId) {
      return;
    }
    _lastAttachedAccountId = accountId;
    await widget.billingController.setAccount(accountId);
    if (!force) {
      await widget.billingController.synchronize(
        reason: BillingRefreshReason.manual,
      );
    }
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
              ? const Color(0xFF101216)
              : const Color(0xFFFFFFFF),
          surfaceContainerLow: isDark
              ? const Color(0xFF1B1D24)
              : const Color(0xFFF8F9FD),
          surfaceContainer: isDark
              ? const Color(0xFF23262E)
              : const Color(0xFFF2F4F9),
          surfaceContainerHigh: isDark
              ? const Color(0xFF292D36)
              : const Color(0xFFECEEF5),
          surfaceContainerHighest: isDark
              ? const Color(0xFF30343E)
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
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
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
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 350),
        showDuration: const Duration(seconds: 2),
        textStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          borderRadius: BorderRadius.circular(10),
        ),
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
            borderRadius: ChordestUiTokens.radius(18),
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
            borderRadius: ChordestUiTokens.radius(18),
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
          shape: RoundedRectangleBorder(
            borderRadius: ChordestUiTokens.radius(18),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        helperMaxLines: 3,
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
        helperStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
        border: OutlineInputBorder(
          borderRadius: ChordestUiTokens.radius(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ChordestUiTokens.radius(20),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ChordestUiTokens.radius(20),
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
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.16),
        valueIndicatorColor: colorScheme.primaryContainer,
        valueIndicatorTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return ChordestAudioScope(
          harmonyAudio: widget.harmonyAudioService,
          child: AccountScope(
            controller: widget.accountController,
            child: BillingScope(
              controller: widget.billingController,
              child: MaterialApp(
                title: 'Chordest',
                debugShowCheckedModeBanner: false,
                locale: widget.controller.settings.appLocale,
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
                home: MainMenuPage(controller: widget.controller),
              ),
            ),
          ),
        );
      },
    );
  }
}
