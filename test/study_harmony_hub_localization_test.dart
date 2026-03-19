import 'dart:ui';

import 'package:chordest/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('study harmony hub meta copy stays localized in english and korean', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final ko = lookupAppLocalizations(const Locale('ko'));

    expect(en.studyHarmonyPlayStyleLabel('competitor'), 'Competitor');
    expect(ko.studyHarmonyPlayStyleLabel('competitor'), '경쟁형');

    expect(en.studyHarmonyDifficultyLaneLabel('recovery'), 'Recovery Lane');
    expect(ko.studyHarmonyDifficultyLaneLabel('recovery'), '회복 레인');

    expect(en.studyHarmonyRuntimeTuningSummary(3, 7), 'Lives 3 | Goal 7');
    expect(ko.studyHarmonyRuntimeTuningSummary(3, 7), '라이프 3 | 목표 7');

    expect(
      en.studyHarmonyCoachLine('analytical'),
      'Read the weak point and refine it with precision.',
    );
    expect(ko.studyHarmonyCoachLine('analytical'), '약한 지점을 읽고 정확하게 다듬어 보세요.');

    expect(en.studyHarmonyArcadeRuntimeGhostPressure, 'Ghost pressure');
    expect(ko.studyHarmonyArcadeRuntimeGhostPressure, '고스트 압박');

    expect(en.studyHarmonyShopStateLabel('readyToBuy'), 'Ready to buy');
    expect(ko.studyHarmonyShopStateLabel('readyToBuy'), '구매 가능');
    expect(en.studyHarmonyShopActionLabel('equip'), 'Equip');
    expect(ko.studyHarmonyShopActionLabel('equip'), '장착');

    expect(en.studyHarmonyArcadeRulesTitle, 'Arcade Rules');
    expect(ko.studyHarmonyArcadeRulesTitle, '아케이드 규칙');
    expect(en.studyHarmonySessionLengthLabel(8), '8 min run');
    expect(ko.studyHarmonySessionLengthLabel(8), '8분 세션');
    expect(en.studyHarmonyRewardKindLabel('shopItem'), 'Shop Unlock');
    expect(ko.studyHarmonyRewardKindLabel('shopItem'), '상점 해금');
    expect(
      en.studyHarmonyArcadeRuntimeComboProgressLabel(6, 2),
      'Every 6 combo adds +2 progress',
    );
    expect(
      ko.studyHarmonyArcadeRuntimeComboProgressLabel(6, 2),
      '콤보 6마다 진행 +2',
    );
  });
}
