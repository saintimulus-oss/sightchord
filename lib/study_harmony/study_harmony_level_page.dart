import 'package:flutter/material.dart';

import 'application/study_harmony_progress_controller.dart';
import 'content/legacy_adapter.dart';
import 'study_harmony_catalog.dart';
import 'study_harmony_models.dart';
import 'study_harmony_session_page.dart';

class StudyHarmonyLevelPage extends StatelessWidget {
  const StudyHarmonyLevelPage({
    super.key,
    required this.level,
    required this.progressController,
  });

  final StudyHarmonyLevelDefinition level;
  final StudyHarmonyProgressController progressController;

  static const StudyHarmonyLegacyLessonAdapter _legacyAdapter =
      StudyHarmonyLegacyLessonAdapter();

  @override
  Widget build(BuildContext context) {
    return StudyHarmonySessionPage(
      lesson: _legacyAdapter.adaptLevel(level),
      trackId: StudyHarmonyLegacyLessonAdapter.prototypeTrackId,
      courseToSync: _legacyAdapter.buildPrototypeCourse(studyHarmonyLevels),
      progressController: progressController,
    );
  }
}
