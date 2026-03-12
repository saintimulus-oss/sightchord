import 'package:flutter/widgets.dart';

import 'app_shell.dart';
import 'settings/settings_controller.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppSettingsController();
  await controller.load();
  runApp(MyApp(controller: controller));
}
