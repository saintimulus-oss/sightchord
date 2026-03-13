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

  Future<void> _openLanguageSettings(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _MainLanguageSettingsSheet(controller: controller),
    );
  }

  void _openCodeGenerator(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            MyHomePage(title: 'SightChord', controller: controller),
      ),
    );
  }

  void _openChordAnalyzer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const ChordAnalyzerPage()),
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
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.55),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: 0,
                  color: colorScheme.surface.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 34,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'SightChord',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.mainMenuIntro,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _MainEntryCard(
                          icon: Icons.auto_awesome,
                          title: l10n.mainMenuGeneratorTitle,
                          description: l10n.mainMenuGeneratorDescription,
                          buttonLabel: l10n.openGenerator,
                          buttonKey: const ValueKey(
                            'main-open-generator-button',
                          ),
                          onPressed: () => _openCodeGenerator(context),
                        ),
                        const SizedBox(height: 12),
                        _MainEntryCard(
                          icon: Icons.insights_rounded,
                          title: l10n.mainMenuAnalyzerTitle,
                          description: l10n.mainMenuAnalyzerDescription,
                          buttonLabel: l10n.openAnalyzer,
                          buttonKey: const ValueKey(
                            'main-open-analyzer-button',
                          ),
                          onPressed: () => _openChordAnalyzer(context),
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: studyHarmonyProgressController,
                          builder: (context, _) {
                            final course = buildStudyHarmonyCoreCourse(l10n);
                            final summary = _buildStudyHarmonyMenuSummary(
                              l10n: l10n,
                              course: course,
                              progressController:
                                  studyHarmonyProgressController,
                            );

                            return _MainEntryCard(
                              icon: Icons.school_rounded,
                              title: l10n.mainMenuStudyHarmonyTitle,
                              description: l10n.mainMenuStudyHarmonyDescription,
                              supportingText: summary.resumeLabel,
                              badges: summary.badges,
                              buttonLabel: l10n.openStudyHarmony,
                              buttonKey: const ValueKey(
                                'main-open-study-harmony-button',
                              ),
                              onPressed: () => _openStudyHarmony(context),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          key: const ValueKey('main-open-settings-button'),
                          onPressed: () => _openLanguageSettings(context),
                          icon: const Icon(Icons.language_rounded),
                          label: Text(l10n.settings),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainEntryCard extends StatelessWidget {
  const _MainEntryCard({
    required this.icon,
    required this.title,
    required this.description,
    this.supportingText,
    this.badges = const <String>[],
    required this.buttonLabel,
    required this.buttonKey,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? supportingText;
  final List<String> badges;
  final String buttonLabel;
  final ValueKey<String> buttonKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.44),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (supportingText case final text?) ...[
                const SizedBox(height: 12),
                Text(
                  text,
                  key: ValueKey('${buttonKey.value}-supporting'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
              if (badges.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final badge in badges) Chip(label: Text(badge)),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              FilledButton.icon(
                key: buttonKey,
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(buttonLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyHarmonyMenuSummary {
  const _StudyHarmonyMenuSummary({
    required this.resumeLabel,
    required this.badges,
  });

  final String resumeLabel;
  final List<String> badges;
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
  final chapterTitle =
      continueRecommendation?.chapter.title ?? course.chapters.first.title;

  return _StudyHarmonyMenuSummary(
    resumeLabel: continueRecommendation == null
        ? l10n.studyHarmonyContinueFrontierHint
        : l10n.studyHarmonyContinueLessonLabel(
            continueRecommendation.lesson.title,
          ),
    badges: [
      chapterTitle,
      l10n.studyHarmonyHubLessonsProgress(clearedLessons, totalLessons),
    ],
  );
}

String _languageLabel(AppLocalizations l10n, AppLanguage language) {
  return switch (language) {
    AppLanguage.system => l10n.systemDefaultLanguage,
    _ => language.nativeLabel,
  };
}

class _MainLanguageSettingsSheet extends StatelessWidget {
  const _MainLanguageSettingsSheet({required this.controller});

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
                        l10n.language,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
