import 'meta/study_harmony_arcade_catalog.dart';
import 'meta/study_harmony_rewards_catalog.dart';

bool studyHarmonyUsesKoreanDisplayCopy(String localeTag) {
  return _languageCode(localeTag) == 'ko';
}

String studyHarmonyCurrencyTitleForLocale(
  String localeTag,
  StudyHarmonyCurrencyId currencyId,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanCurrencyTitles[currencyId] ??
        studyHarmonyCurrenciesById[currencyId]?.title ??
        currencyId;
  }
  return studyHarmonyCurrenciesById[currencyId]?.title ?? currencyId;
}

String studyHarmonyRewardTitleForLocale(
  String localeTag, {
  required String rewardId,
  required String fallbackTitle,
}) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanRewardTitles[rewardId] ?? fallbackTitle;
  }
  return fallbackTitle;
}

String studyHarmonyRewardDescriptionForLocale(
  String localeTag, {
  required String rewardId,
  required String fallbackDescription,
}) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanRewardDescriptions[rewardId] ?? fallbackDescription;
  }
  return fallbackDescription;
}

String studyHarmonyBundleTitleForLocale(
  String localeTag, {
  required String bundleId,
  required String fallbackTitle,
}) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanBundleTitles[bundleId] ?? fallbackTitle;
  }
  return fallbackTitle;
}

String studyHarmonyShopItemTitleForLocale(
  String localeTag,
  StudyHarmonyShopItemDefinition item,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanShopItemTitles[item.id] ?? item.title;
  }
  return item.title;
}

String studyHarmonyShopItemDescriptionForLocale(
  String localeTag,
  StudyHarmonyShopItemDefinition item,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanShopItemDescriptions[item.id] ?? item.description;
  }
  return item.description;
}

String studyHarmonyArcadeModeTitleForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadeModeTitles[mode.id] ?? mode.title;
  }
  return mode.title;
}

String studyHarmonyArcadeModeHeadlineForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadeModeHeadlines[mode.id] ?? mode.subtitle;
  }
  return mode.subtitle;
}

String studyHarmonyArcadeModeLoopForLocale(
  String localeTag,
  StudyHarmonyArcadeModeDefinition mode,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadeModeLoops[mode.id] ?? mode.shortLoop;
  }
  return mode.shortLoop;
}

String studyHarmonyArcadePlaylistTitleForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadePlaylistTitles[playlist.id] ?? playlist.title;
  }
  return playlist.title;
}

String studyHarmonyArcadePlaylistSubtitleForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadePlaylistSubtitles[playlist.id] ?? playlist.subtitle;
  }
  return playlist.subtitle;
}

String studyHarmonyArcadePlaylistBodyForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadePlaylistBodies[playlist.id] ?? playlist.fantasy;
  }
  return playlist.fantasy;
}

String studyHarmonyArcadePlaylistCueForLocale(
  String localeTag,
  StudyHarmonyArcadePlaylistDefinition playlist,
) {
  if (studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return _koreanArcadePlaylistCues[playlist.id] ?? playlist.recommendationCue;
  }
  return playlist.recommendationCue;
}

String studyHarmonyArcadeUnlockLabelForLocale(
  String localeTag,
  StudyHarmonyArcadeUnlockRule rule,
) {
  if (!studyHarmonyUsesKoreanDisplayCopy(localeTag)) {
    return rule.label;
  }
  return switch (rule.kind) {
    StudyHarmonyArcadeUnlockKind.always => '항상 이용 가능',
    StudyHarmonyArcadeUnlockKind.completedLessonsAtLeast =>
      '레슨 ${rule.threshold}개 이상 클리어',
    StudyHarmonyArcadeUnlockKind.averageAccuracyAtLeast =>
      '평균 정확도 ${rule.threshold}% 이상 유지',
    StudyHarmonyArcadeUnlockKind.bestAccuracyAtLeast =>
      '최고 정확도 ${rule.threshold}% 이상 달성',
    StudyHarmonyArcadeUnlockKind.currentStreakAtLeast =>
      '${rule.threshold}일 연속 기록 유지',
    StudyHarmonyArcadeUnlockKind.sRanksAtLeast =>
      'S랭크 ${rule.threshold}회 이상 획득',
    StudyHarmonyArcadeUnlockKind.perfectRunsAtLeast =>
      '퍼펙트 런 ${rule.threshold}회 이상 기록',
    StudyHarmonyArcadeUnlockKind.reviewQueueAtLeast =>
      '복습 대기 ${rule.threshold}개 이상 유지',
    StudyHarmonyArcadeUnlockKind.bossClearsAtLeast =>
      '보스 ${rule.threshold}회 이상 클리어',
    StudyHarmonyArcadeUnlockKind.chapterClearsAtLeast =>
      '챕터 ${rule.threshold}개 이상 클리어',
    StudyHarmonyArcadeUnlockKind.playCountAtLeast =>
      '${rule.threshold}회 이상 플레이',
  };
}

String _languageCode(String localeTag) {
  final normalized = localeTag.replaceAll('_', '-').trim().toLowerCase();
  if (normalized.isEmpty) {
    return '';
  }
  return normalized.split('-').first;
}

const Map<String, String> _koreanCurrencyTitles = <String, String>{
  'currency.studyCoin': '스터디 코인',
  'currency.starShard': '스타 샤드',
  'currency.focusToken': '집중 토큰',
  'currency.rerollToken': '리롤 토큰',
  'currency.streakShield': '스트릭 실드',
};

const Map<String, String> _koreanRewardTitles = <String, String>{
  'achievement.first_step': '첫 다운비트',
  'achievement.lesson_runner': '레슨 러너',
  'achievement.lesson_marathon': '레슨 마라톤',
  'achievement.review_scholar': '복습 학자',
  'achievement.daily_anchor': '데일리 앵커',
  'achievement.daily_lantern': '데일리 랜턴',
  'achievement.streak_legend': '스트릭 레전드',
  'achievement.combo_starter': '콤보 스타터',
  'achievement.combo_master': '콤보 마스터',
  'achievement.accuracy_owl': '정확도 올빼미',
  'achievement.relay_runner': '릴레이 러너',
  'achievement.boss_breaker': '보스 브레이커',
  'achievement.legend_writer': '레전드 라이터',
  'achievement.quest_collector': '퀘스트 컬렉터',
  'achievement.tour_headliner': '투어 헤드라이너',
  'achievement.economy_supporter': '이코노미 서포터',
  'title.spark': '스파크',
  'title.riff_runner': '리프 러너',
  'title.cadence_keeper': '케이던스 키퍼',
  'title.accuracy_owl': '정확도 올빼미',
  'title.streak_sage': '스트릭 세이지',
  'title.combo_captain': '콤보 캡틴',
  'title.relay_maestro': '릴레이 마에스트로',
  'title.savvy_buyer': '현명한 구매자',
  'title.legend_writer': '레전드 라이터',
  'cosmetic.frame.neon': '네온 프레임',
  'cosmetic.frame.aurora': '오로라 프레임',
  'cosmetic.theme.midnight': '미드나이트 테마',
  'cosmetic.theme.sunset': '선셋 테마',
  'cosmetic.trail.confetti': '컨페티 트레일',
  'cosmetic.trail.stardust': '스타더스트 트레일',
  'cosmetic.badge.gold': '골드 배지',
  'cosmetic.badge.holo': '홀로 배지',
  'shop.focus_token_pack': '집중 토큰 팩',
  'shop.lesson_reroll_pack': '레슨 리롤 팩',
  'shop.streak_shield': '스트릭 실드',
  'shop.spark_chest': '스파크 상자',
  'shop.aurora_frame_unlock': '오로라 프레임 해금',
  'shop.midnight_theme_unlock': '미드나이트 테마 해금',
  'shop.stardust_trail_unlock': '스타더스트 트레일 해금',
  'shop.holo_badge_unlock': '홀로 배지 해금',
};

const Map<String, String> _koreanRewardDescriptions = <String, String>{
  'title.spark': '새로운 학습자를 위한 빠르고 자신감 있는 출발입니다.',
  'title.riff_runner': '흐름을 잃지 않고 탄력을 이어 가는 학습자를 위한 칭호입니다.',
  'title.cadence_keeper': '꾸준한 복습과 습관 형성을 기념하는 칭호입니다.',
  'title.accuracy_owl': '조용하고 정교한 고정확도 세션을 위한 칭호입니다.',
  'title.streak_sage': '믿을 수 있는 데일리 연습을 기념하는 칭호입니다.',
  'title.combo_captain': '박자를 잃지 않는 긴 런을 위한 칭호입니다.',
  'title.relay_maestro': '릴레이 전문 플레이어를 위한 지휘자 같은 칭호입니다.',
  'title.savvy_buyer': '똑똑하게 구매하고 로드아웃을 다듬는 플레이어를 위한 칭호입니다.',
  'title.legend_writer': '가장 굵직한 클리어를 남긴 플레이어를 위한 신화급 칭호입니다.',
  'cosmetic.frame.neon': '레슨 클리어의 손맛을 더 선명하게 보여 주는 밝은 프레임입니다.',
  'cosmetic.frame.aurora': '안정적인 연속 기록을 가진 플레이어를 위한 부드럽게 흐르는 프레임입니다.',
  'cosmetic.theme.midnight': '깔끔한 플레이와 높은 정확도를 더 돋보이게 하는 어두운 테마입니다.',
  'cosmetic.theme.sunset': '월간 진척 끝에 얻는 보람이 느껴지는 따뜻한 테마입니다.',
  'cosmetic.trail.confetti': '복습 세션과 짧은 승리를 축하하는 트레일입니다.',
  'cosmetic.trail.stardust': '긴 콤보 연속을 따라가는 프리미엄 트레일입니다.',
  'cosmetic.badge.gold': '릴레이 강자와 도전형 플레이어를 위한 정갈한 배지입니다.',
  'cosmetic.badge.holo': '상점 루프를 통해 얻을 수 있는 프리미엄 배지입니다.',
};

const Map<String, String> _koreanBundleTitles = <String, String>{
  'bundle.achievement.first_step': '첫걸음 번들',
  'bundle.achievement.daily_anchor': '데일리 앵커 번들',
  'bundle.achievement.legend_writer': '레전드 라이터 번들',
  'bundle.shop.welcome': '웰컴 진열대',
  'bundle.shop.premium': '프리미엄 진열대',
};

const Map<String, String> _koreanShopItemTitles = <String, String>{
  'shop.focus_token_pack': '집중 토큰 팩',
  'shop.lesson_reroll_pack': '레슨 리롤 팩',
  'shop.streak_shield': '스트릭 실드',
  'shop.spark_chest': '스파크 상자',
  'shop.aurora_frame_unlock': '오로라 프레임 해금',
  'shop.midnight_theme_unlock': '미드나이트 테마 해금',
  'shop.stardust_trail_unlock': '스타더스트 트레일 해금',
  'shop.holo_badge_unlock': '홀로 배지 해금',
};

const Map<String, String> _koreanShopItemDescriptions = <String, String>{
  'shop.focus_token_pack': '전술적인 세션을 위해 집중 토큰을 소량 구매합니다.',
  'shop.lesson_reroll_pack': '다음 도전 줄을 리롤 토큰으로 새로 고칩니다.',
  'shop.streak_shield': '일회성 보호막으로 연속 기록을 지키세요.',
  'shop.spark_chest': '코인과 샤드를 함께 노릴 수 있는 가성비 상자입니다.',
  'shop.aurora_frame_unlock': '상점에서 오로라 프레임 코스메틱을 해금합니다.',
  'shop.midnight_theme_unlock': '정확도가 올라오기 시작하면 미드나이트 테마를 해금합니다.',
  'shop.stardust_trail_unlock': '긴 콤보 특화 플레이어를 위한 스타더스트 트레일을 해금합니다.',
  'shop.holo_badge_unlock': '상점 진열대에서 프리미엄 홀로 배지를 해금합니다.',
};

const Map<String, String> _koreanArcadeModeTitles = <String, String>{
  'neon-sprint': '네온 스프린트',
  'ghost-relay': '고스트 릴레이',
  'vault-break': '볼트 브레이크',
  'remix-fever': '리믹스 피버',
  'boss-rush': '보스 러시',
  'crown-loop': '크라운 루프',
  'duel-stage': '듀얼 스테이지',
  'night-market': '나이트 마켓',
};

const Map<String, String> _koreanArcadeModeHeadlines = <String, String>{
  'neon-sprint': '모든 정답이 반응로를 밝히는 90초 콤보 레인.',
  'ghost-relay': '최근 가장 깔끔했던 런을 메아리 체크포인트로 다시 추격하세요.',
  'vault-break': '압박 구간을 깔끔하게 풀어 숨겨진 코드 볼트를 여세요.',
  'remix-fever': '매 라운드 규칙이 뒤바뀌는 모디파이어 폭풍.',
  'boss-rush': '하트는 적고, 긴장감은 높고, 끝엔 보상 상자가 기다립니다.',
  'crown-loop': '숙련의 왕관이 계속 쌓이는 마라톤 레인.',
  'duel-stage': '자신의 고스트 로스터와 겨루는 솔로 래더 매치.',
  'night-market': '클리어할수록 더 희귀한 재고가 열리는 회전형 상점 런.',
};

const Map<String, String> _koreanArcadeModeLoops = <String, String>{
  'neon-sprint': '짧은 구간을 클리어하고, 콤보를 늘리고, 빠르게 보상을 챙기세요.',
  'ghost-relay': '구간을 잇고, 고스트를 찍고, 이전 템포를 넘어보세요.',
  'vault-break': '방 하나를 풀고, 자물쇠를 깨고, 다음 금고 층을 드러내세요.',
  'remix-fever': '이번 리믹스를 버티고, 다음에는 더 낯선 규칙으로 넘어가세요.',
  'boss-rush': '보스를 연달아 상대하고, 목숨을 아끼며, 위신을 챙기세요.',
  'crown-loop': '트랙을 순환하고, 왕관을 지키고, 연쇄를 이어가세요.',
  'duel-stage': '고스트 하나를 꺾고, 더 어려운 다음 미러 매치로 올라가세요.',
  'night-market': '런을 이기고, 코인을 벌고, 살지 아낄지 결정하세요.',
};

const Map<String, String> _koreanArcadePlaylistTitles = <String, String>{
  'after-dark': '애프터 다크 세트',
  'vault-run': '볼트 런',
  'boss-ladder': '보스 래더',
  'street-league': '스트리트 리그',
};

const Map<String, String> _koreanArcadePlaylistSubtitles = <String, String>{
  'after-dark': '먼저 탄력을 붙이고 싶은 플레이어를 위한 짧고 화려한 런.',
  'vault-run': '숨은 보상과 모디파이어 압박으로 가득한 전리품 중심 루트.',
  'boss-ladder': '위신을 위해 목숨을 걸 준비가 된 플레이어용 정밀 등반 코스.',
  'street-league': '고스트 레이스와 래더 등반이 있는 친근한 경쟁 레인.',
};

const Map<String, String> _koreanArcadePlaylistBodies = <String, String>{
  'after-dark': '빠른 클리어와 거친 리믹스가 이어지는 심야 네온 블록 파티.',
  'vault-run': '봉인된 방을 열고 스타일 아이템을 챙겨 나오세요.',
  'boss-ladder': '보스 탑을 오르며 왕관을 끝까지 지켜내세요.',
  'street-league': '최고 기록이 곧 상대가 되는 솔로 e스포츠 서킷.',
};

const Map<String, String> _koreanArcadePlaylistCues = <String, String>{
  'after-dark': '워밍업, 연속 기록 쌓기, 빠른 재도전에 잘 어울립니다.',
  'vault-run': '보상이 노력의 결과처럼 느껴지길 원할 때 좋습니다.',
  'boss-ladder': '정확도가 안정됐고 긴장감이 재미로 느껴질 때 선택하세요.',
  'street-league': '성장이 눈에 보이는 경쟁처럼 느껴지길 원할 때 좋습니다.',
};
