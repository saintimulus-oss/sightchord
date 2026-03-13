import 'package:flutter/widgets.dart';

import 'app_shell.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppSettingsController();
  final studyHarmonyProgressController = StudyHarmonyProgressController();
  await controller.load();
  await studyHarmonyProgressController.load();
  runApp(
    MyApp(
      controller: controller,
      studyHarmonyProgressController: studyHarmonyProgressController,
    ),
  );
}
