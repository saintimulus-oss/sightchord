import 'package:chordest/main_menu/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('main menu copy stays on a single line with ellipsis', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: const MainMenuView(
          title: 'A very long title that should stay on one line',
          intro:
              'A long intro that should not wrap even when the display is narrow.',
          settingsLabel: 'Settings',
          generatorTitle: 'Generator title that should stay on one line',
          generatorSubtitle:
              'Generator subtitle that should stay on one line without wrapping.',
          analyzerTitle: 'Analyzer title that should stay on one line',
          analyzerSubtitle:
              'Analyzer subtitle that should stay on one line without wrapping.',
          onOpenSettings: _noop,
          onOpenGenerator: _noop,
          onOpenAnalyzer: _noop,
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    final introText = tester.widget<Text>(
      find.text(
        'A long intro that should not wrap even when the display is narrow.',
      ),
    );
    expect(introText.maxLines, 1);
    expect(introText.overflow, TextOverflow.ellipsis);
    expect(introText.softWrap, isFalse);

    final generatorSubtitleText = tester.widget<Text>(
      find.text(
        'Generator subtitle that should stay on one line without wrapping.',
      ),
    );
    expect(generatorSubtitleText.maxLines, 1);
    expect(generatorSubtitleText.overflow, TextOverflow.ellipsis);
    expect(generatorSubtitleText.softWrap, isFalse);

    final analyzerTitleText = tester.widget<Text>(
      find.text('Analyzer title that should stay on one line'),
    );
    expect(analyzerTitleText.maxLines, 1);
    expect(analyzerTitleText.overflow, TextOverflow.ellipsis);
    expect(analyzerTitleText.softWrap, isFalse);
  });
}

void _noop() {}
