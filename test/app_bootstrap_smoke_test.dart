import 'package:chordest/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('bootstrapApp loads and shows the main menu shell', (
    tester,
  ) async {
    await tester.runAsync(bootstrapApp);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('main-open-generator-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-open-analyzer-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-open-study-harmony-button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('main-open-settings-button')),
      findsOneWidget,
    );
  });
}
