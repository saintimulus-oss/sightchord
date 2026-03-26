import 'package:chordest/study_harmony/meta/study_harmony_arcade_catalog.dart';
import 'package:chordest/study_harmony/meta/study_harmony_rewards_catalog.dart';
import 'package:chordest/study_harmony/study_harmony_display_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('korean display copy localizes reward catalog text', () {
    final title = studyHarmonyTitlesById['title.spark']!;
    final item = studyHarmonyShopItems.firstWhere(
      (candidate) => candidate.id == 'shop.holo_badge_unlock',
    );

    expect(studyHarmonyUsesKoreanDisplayCopy('ko'), isTrue);
    expect(studyHarmonyUsesKoreanDisplayCopy('ko-KR'), isTrue);
    expect(
      studyHarmonyCurrencyTitleForLocale('ko', 'currency.studyCoin'),
      '스터디 코인',
    );
    expect(
      studyHarmonyRewardTitleForLocale(
        'ko',
        rewardId: title.id,
        fallbackTitle: title.title,
      ),
      '스파크',
    );
    expect(
      studyHarmonyRewardDescriptionForLocale(
        'ko',
        rewardId: title.id,
        fallbackDescription: title.description,
      ),
      '새로운 학습자를 위한 빠르고 자신감 있는 출발입니다.',
    );
    expect(studyHarmonyShopItemTitleForLocale('ko', item), '홀로 배지 해금');
    expect(
      studyHarmonyShopItemDescriptionForLocale('ko', item),
      '상점 진열대에서 프리미엄 홀로 배지를 해금합니다.',
    );
  });

  test('korean display copy localizes arcade catalog text', () {
    final mode = studyHarmonyArcadeModeCatalog.first;
    final playlist = studyHarmonyArcadePlaylistCatalog.first;

    expect(studyHarmonyArcadeModeTitleForLocale('ko', mode), '네온 스프린트');
    expect(
      studyHarmonyArcadeModeHeadlineForLocale('ko', mode),
      '모든 정답이 반응로를 밝히는 90초 콤보 레인.',
    );
    expect(
      studyHarmonyArcadeModeLoopForLocale('ko', mode),
      '짧은 구간을 클리어하고, 콤보를 늘리고, 빠르게 보상을 챙기세요.',
    );
    expect(
      studyHarmonyArcadePlaylistTitleForLocale('ko', playlist),
      '애프터 다크 세트',
    );
    expect(
      studyHarmonyArcadePlaylistSubtitleForLocale('ko', playlist),
      '먼저 탄력을 붙이고 싶은 플레이어를 위한 짧고 화려한 런.',
    );
    expect(
      studyHarmonyArcadePlaylistBodyForLocale('ko', playlist),
      '빠른 클리어와 거친 리믹스가 이어지는 심야 네온 블록 파티.',
    );
    expect(
      studyHarmonyArcadePlaylistCueForLocale('ko', playlist),
      '워밍업, 연속 기록 쌓기, 빠른 재도전에 잘 어울립니다.',
    );
    expect(
      studyHarmonyArcadeUnlockLabelForLocale('ko', mode.unlockRules.first),
      '항상 이용 가능',
    );
  });
}
