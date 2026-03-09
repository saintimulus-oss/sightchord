import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightchord/settings/practice_settings.dart';
import 'package:sightchord/settings/settings_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('serializes rapid saves using the update snapshot', () async {
    final controller = AppSettingsController(
      initialSettings: PracticeSettings(activeKeys: const {'C'}),
    );

    final firstUpdate = controller.update(
      controller.settings.copyWith(
        activeKeys: const {'C', 'G'},
        allowTensions: true,
      ),
    );
    final secondUpdate = controller.update(
      controller.settings.copyWith(
        activeKeys: const {'D'},
        allowTensions: false,
      ),
    );

    await Future.wait([firstUpdate, secondUpdate]);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getStringList('activeKeys'), ['D']);
    expect(preferences.getBool('allowTensions'), isFalse);
  });
}
