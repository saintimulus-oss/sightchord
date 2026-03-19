import 'package:chordest/study_harmony/meta/study_harmony_arcade_catalog.dart';
import 'package:chordest/study_harmony/meta/study_harmony_rewards_catalog.dart';
import 'package:chordest/study_harmony/study_harmony_display_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('korean display copy falls back to canonical reward catalog text', () {
    final title = studyHarmonyTitlesById['title.spark']!;
    final item = studyHarmonyShopItems.firstWhere(
      (candidate) => candidate.id == 'shop.holo_badge_unlock',
    );

    expect(studyHarmonyUsesKoreanDisplayCopy('ko'), isFalse);
    expect(
      studyHarmonyCurrencyTitleForLocale('ko', 'currency.studyCoin'),
      studyHarmonyCurrenciesById['currency.studyCoin']!.title,
    );
    expect(
      studyHarmonyRewardTitleForLocale(
        'ko',
        rewardId: title.id,
        fallbackTitle: title.title,
      ),
      title.title,
    );
    expect(
      studyHarmonyRewardDescriptionForLocale(
        'ko',
        rewardId: title.id,
        fallbackDescription: title.description,
      ),
      title.description,
    );
    expect(studyHarmonyShopItemTitleForLocale('ko', item), item.title);
    expect(
      studyHarmonyShopItemDescriptionForLocale('ko', item),
      item.description,
    );
  });

  test('korean display copy falls back to canonical arcade catalog text', () {
    final mode = studyHarmonyArcadeModeCatalog.first;
    final playlist = studyHarmonyArcadePlaylistCatalog.first;

    expect(studyHarmonyArcadeModeTitleForLocale('ko', mode), mode.title);
    expect(studyHarmonyArcadeModeHeadlineForLocale('ko', mode), mode.subtitle);
    expect(studyHarmonyArcadeModeLoopForLocale('ko', mode), mode.shortLoop);
    expect(
      studyHarmonyArcadePlaylistTitleForLocale('ko', playlist),
      playlist.title,
    );
    expect(
      studyHarmonyArcadePlaylistSubtitleForLocale('ko', playlist),
      playlist.subtitle,
    );
    expect(
      studyHarmonyArcadePlaylistBodyForLocale('ko', playlist),
      playlist.fantasy,
    );
    expect(
      studyHarmonyArcadePlaylistCueForLocale('ko', playlist),
      playlist.recommendationCue,
    );
  });
}
