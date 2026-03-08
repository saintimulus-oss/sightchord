import 'package:flutter_test/flutter_test.dart';

import 'package:sightchord/main.dart';

void main() {
  testWidgets('renders practice controls and initial chord state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('SightChord'), findsOneWidget);
    expect(find.text('다음 코드'), findsOneWidget);
    expect(find.text('자동 진행 시작'), findsOneWidget);
    expect(find.text('랜덤 모드'), findsWidgets);
    expect(find.text('All Keys'), findsOneWidget);
    expect(find.text('60'), findsOneWidget);
  });

  testWidgets('manual advance keeps the practice UI responsive', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.tap(find.text('다음 코드'));
    await tester.pump();

    expect(find.text('자동 진행 시작'), findsOneWidget);
    expect(find.text('입력 범위: 20-300'), findsOneWidget);
  });
}
