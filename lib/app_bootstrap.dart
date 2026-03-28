import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';

import 'auth/account_controller.dart';
import 'app_shell.dart';
import 'billing/billing_controller.dart';
import 'settings/settings_controller.dart';
import 'study_harmony/application/study_harmony_progress_controller.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppSettingsController();
  final accountController = AccountController.live();
  final billingController = BillingController.live();
  final studyHarmonyProgressController = StudyHarmonyProgressController();
  await Future.wait<void>([
    _runStartupTask('settings.load', controller.load),
    _runStartupTask('account.initialize', accountController.initialize),
    _runStartupTask('billing.initialize', billingController.initialize),
  ]);
  await _runStartupTask(
    'billing.setAccount',
    () => billingController.setAccount(accountController.state.currentUser?.id),
  );
  unawaited(
    _runStartupTask(
      'studyHarmonyProgress.load',
      studyHarmonyProgressController.load,
    ),
  );
  runApp(
    MyApp(
      controller: controller,
      accountController: accountController,
      billingController: billingController,
      studyHarmonyProgressController: studyHarmonyProgressController,
    ),
  );
}

Future<void> _runStartupTask(
  String label,
  Future<void> Function() task,
) async {
  try {
    await task();
  } catch (error, stackTrace) {
    developer.log(
      'Startup task failed: $label',
      name: 'chordest.bootstrap',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
