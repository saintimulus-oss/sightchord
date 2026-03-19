import 'meta/study_harmony_arcade_catalog.dart';
import 'meta/study_harmony_rewards_catalog.dart';

bool studyHarmonyUsesKoreanDisplayCopy(String localeTag) {
  // The previous curated Korean override table was mojibake-corrupted.
  // Fall back to the canonical catalog copy until real translated data lands.
  return false;
}

String studyHarmonyCurrencyTitleForLocale(
  String localeTag,
  StudyHarmonyCurrencyId currencyId,
) {
  return studyHarmonyCurrenciesById[currencyId]?.title ?? currencyId;
}

String studyHarmonyRewardTitleForLocale(
  String localeTag, {
  required String rewardId,
  required String fallbackTitle,
}) {
  return fallbackTitle;
}

String studyHarmonyRewardDescriptionForLocale(
  String localeTag, {
  required String rewardId,
  required String fallbackDescription,
}) {
  return fallbackDescription;
}

String studyHarmonyBundleTitleForLocale(
  String localeTag, {
  required String bundleId,
  required String fallbackTitle,
}) {
  return fallbackTitle;
}

String studyHarmonyShopItemTitleForLocale(
  String localeTag,
  StudyHarmonyShopItemDefinition item,
) {
  return item.title;
}

String studyHarmonyShopItemDescriptionForLocale(
  String localeTag,
  StudyHarmonyShopItemDefinition item,
) {
  return item.description;
}

String studyHarmonyArcadeModeTitleForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  return mode.title;
}

String studyHarmonyArcadeModeHeadlineForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  return mode.subtitle;
}

String studyHarmonyArcadeModeLoopForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  return mode.shortLoop;
}

String studyHarmonyArcadePlaylistTitleForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  return playlist.title;
}

String studyHarmonyArcadePlaylistSubtitleForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  return playlist.subtitle;
}

String studyHarmonyArcadePlaylistBodyForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  return playlist.fantasy;
}

String studyHarmonyArcadePlaylistCueForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  return playlist.recommendationCue;
}
