import 'package:flutter/material.dart';

import 'chord_analyzer_page.dart';
import 'l10n/app_localizations.dart';
import 'main_menu/main_menu_settings_sheet.dart';
import 'main_menu/main_menu_view.dart';
import 'practice_home_page.dart';
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
      builder: (context) => MainMenuSettingsSheet(controller: controller),
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
          settingsController: controller,
          progressController: studyHarmonyProgressController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: studyHarmonyProgressController,
      builder: (context, _) {
        final course = buildStudyHarmonyCourseForTrackId(
          l10n: l10n,
          trackId: studyHarmonyProgressController.lastPlayedTrackId,
        );
        final summary = _buildStudyHarmonyMenuSummary(
          l10n: l10n,
          course: course,
          progressController: studyHarmonyProgressController,
        );
        return MainMenuView(
          title: 'Chordest',
          intro: l10n.mainMenuIntro,
          settingsLabel: l10n.settings,
          generatorTitle: l10n.mainMenuGeneratorTitle,
          generatorSubtitle: l10n.mainMenuGeneratorDescription,
          analyzerTitle: l10n.mainMenuAnalyzerTitle,
          analyzerSubtitle: l10n.mainMenuAnalyzerDescription,
          studyHarmonyTitle: l10n.mainMenuStudyHarmonyTitle,
          studyHarmonySubtitle:
              '${summary.resumeLabel} | ${summary.progressLabel}',
          onOpenSettings: () => _openMainSettings(context),
          onOpenGenerator: () => _openCodeGenerator(context),
          onOpenAnalyzer: () => _openChordAnalyzer(context),
          onOpenStudyHarmony: () => _openStudyHarmony(context),
        );
      },
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
