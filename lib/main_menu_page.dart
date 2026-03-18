import 'dart:async';

import 'package:flutter/material.dart';

import 'chord_analyzer_page.dart';
import 'l10n/app_localizations.dart';
import 'practice_home_page.dart';
import 'settings/practice_settings.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';
import 'study_harmony/content/study_harmony_track_catalog.dart';
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 760;
                      final studyHarmonyAction = AnimatedBuilder(
                        animation: studyHarmonyProgressController,
                        builder: (context, _) {
                          final course = buildStudyHarmonyCourseForTrackId(
                            l10n: l10n,
                            trackId: studyHarmonyProgressController
                                .lastPlayedTrackId,
                          );
                          final summary = _buildStudyHarmonyMenuSummary(
                            l10n: l10n,
                            course: course,
                            progressController: studyHarmonyProgressController,
                          );

                          return _MainActionButton(
                            icon: Icons.school_rounded,
                            title: l10n.mainMenuStudyHarmonyTitle,
                            subtitle:
                                '${summary.resumeLabel} | ${summary.progressLabel}',
                            buttonKey: const ValueKey(
                              'main-open-study-harmony-button',
                            ),
                            onPressed: () => _openStudyHarmony(context),
                          );
                        },
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _MainMenuHeroCard(
                            badgeLabel: 'CHORDEST',
                            title: 'Chordest',
                            body: l10n.mainMenuIntro,
                            settingsLabel: l10n.settings,
                            onSettingsPressed: () => _openMainSettings(context),
                          ),
                          const SizedBox(height: 20),
                          _MainActionButton(
                            icon: Icons.auto_awesome_rounded,
                            title: l10n.mainMenuGeneratorTitle,
                            subtitle: l10n.mainMenuGeneratorDescription,
                            isPrimary: true,
                            buttonKey: const ValueKey(
                              'main-open-generator-button',
                            ),
                            onPressed: () => _openCodeGenerator(context),
                          ),
                          const SizedBox(height: 14),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _MainActionButton(
                                    icon: Icons.insights_rounded,
                                    title: l10n.mainMenuAnalyzerTitle,
                                    subtitle: l10n.mainMenuAnalyzerDescription,
                                    buttonKey: const ValueKey(
                                      'main-open-analyzer-button',
                                    ),
                                    onPressed: () =>
                                        _openChordAnalyzer(context),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(child: studyHarmonyAction),
                              ],
                            )
                          else ...[
                            _MainActionButton(
                              icon: Icons.insights_rounded,
                              title: l10n.mainMenuAnalyzerTitle,
                              subtitle: l10n.mainMenuAnalyzerDescription,
                              buttonKey: const ValueKey(
                                'main-open-analyzer-button',
                              ),
                              onPressed: () => _openChordAnalyzer(context),
                            ),
                            const SizedBox(height: 14),
                            studyHarmonyAction,
                          ],
                        ],
                      );
                    },
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

class _MainMenuHeroCard extends StatelessWidget {
  const _MainMenuHeroCard({
    required this.badgeLabel,
    required this.title,
    required this.body,
    required this.settingsLabel,
    required this.onSettingsPressed,
  });

  final String badgeLabel;
  final String title;
  final String body;
  final String settingsLabel;
  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    badgeLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton.filledTonal(
                  key: const ValueKey('main-open-settings-button'),
                  onPressed: onSettingsPressed,
                  icon: const Icon(Icons.settings_rounded),
                  tooltip: settingsLabel,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.displayMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                body,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
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
