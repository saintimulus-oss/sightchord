import 'dart:async';

import 'package:flutter/material.dart';

import 'chord_analyzer_page.dart';
import 'l10n/app_localizations.dart';
import 'practice_home_page.dart';
import 'settings/practice_settings.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'study_harmony/content/core_curriculum_catalog.dart';
import 'study_harmony/domain/study_harmony_session_models.dart';
import 'study_harmony_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({
    super.key,
    required this.controller,
    required this.studyHarmonyProgressController,
  });

  final AppSettingsController controller;
  final StudyHarmonyProgressController studyHarmonyProgressController;

  Future<void> _openMainSettings(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _MainSettingsSheet(controller: controller),
    );
  }

  void _openCodeGenerator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MyHomePage(
          title: 'Chordest',
          controller: controller,
          onOpenStudyHarmony: () => _openStudyHarmony(context),
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

  void _openStudyHarmony(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StudyHarmonyPage(
          progressController: studyHarmonyProgressController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.18),
                      colorScheme.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: const SizedBox(width: 380, height: 380),
              ),
            ),
          ),
          Positioned(
            right: -140,
            bottom: -180,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.6),
                      colorScheme.primaryContainer.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: const SizedBox(width: 420, height: 420),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, isWide ? 28 : 20, 24, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton.filledTonal(
                          key: const ValueKey('main-open-settings-button'),
                          onPressed: () => _openMainSettings(context),
                          icon: const Icon(Icons.settings_rounded),
                          tooltip: l10n.settings,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'CHORDEST',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Chordest',
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(
                          l10n.mainMenuIntro,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _MainActionButton(
                        icon: Icons.auto_awesome_rounded,
                        title: l10n.mainMenuGeneratorTitle,
                        subtitle: l10n.mainMenuGeneratorDescription,
                        isPrimary: true,
                        buttonKey: const ValueKey('main-open-generator-button'),
                        onPressed: () => _openCodeGenerator(context),
                      ),
                      const SizedBox(height: 14),
                      _MainActionButton(
                        icon: Icons.insights_rounded,
                        title: l10n.mainMenuAnalyzerTitle,
                        subtitle: l10n.mainMenuAnalyzerDescription,
                        buttonKey: const ValueKey('main-open-analyzer-button'),
                        onPressed: () => _openChordAnalyzer(context),
                      ),
                      const SizedBox(height: 14),
                      AnimatedBuilder(
                        animation: studyHarmonyProgressController,
                        builder: (context, _) {
                          final course = buildStudyHarmonyCoreCourse(l10n);
                          final summary = _buildStudyHarmonyMenuSummary(
                            l10n: l10n,
                            course: course,
                            progressController: studyHarmonyProgressController,
                          );

                          return _MainActionButton(
                            icon: Icons.school_rounded,
                            title: l10n.mainMenuStudyHarmonyTitle,
                            subtitle:
                                '${summary.resumeLabel} · ${summary.progressLabel}',
                            buttonKey: const ValueKey(
                              'main-open-study-harmony-button',
                            ),
                            onPressed: () => _openStudyHarmony(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainActionButton extends StatelessWidget {
  const _MainActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonKey,
    this.isPrimary = false,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ValueKey<String> buttonKey;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isPrimary
        ? colorScheme.primary
        : colorScheme.surfaceContainerLow.withValues(alpha: 0.9);
    final foregroundColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final subtitleColor = isPrimary
        ? colorScheme.onPrimary.withValues(alpha: 0.78)
        : colorScheme.onSurfaceVariant;
    final arrowColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: isPrimary
                ? null
                : Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              if (isPrimary)
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.14)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: foregroundColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_forward_rounded, color: arrowColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudyHarmonyMenuSummary {
  const _StudyHarmonyMenuSummary({
    required this.resumeLabel,
    required this.progressLabel,
  });

  final String resumeLabel;
  final String progressLabel;
}

_StudyHarmonyMenuSummary _buildStudyHarmonyMenuSummary({
  required AppLocalizations l10n,
  required StudyHarmonyCourseDefinition course,
  required StudyHarmonyProgressController progressController,
}) {
  final continueRecommendation = progressController
      .continueRecommendationForCourse(course);
  final clearedLessons = course.chapters.fold<int>(
    0,
    (sum, chapter) =>
        sum + progressController.chapterProgressFor(chapter).clearedLessonCount,
  );
  final totalLessons = course.chapters.fold<int>(
    0,
    (sum, chapter) => sum + chapter.lessons.length,
  );

  return _StudyHarmonyMenuSummary(
    resumeLabel: continueRecommendation == null
        ? l10n.studyHarmonyContinueFrontierHint
        : l10n.studyHarmonyContinueLessonLabel(
            continueRecommendation.lesson.title,
          ),
    progressLabel: l10n.studyHarmonyHubLessonsProgress(
      clearedLessons,
      totalLessons,
    ),
  );
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

class _MainSettingsSheet extends StatelessWidget {
  const _MainSettingsSheet({required this.controller});

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final settings = controller.settings;
        return SafeArea(
          child: Padding(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
