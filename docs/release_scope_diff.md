# 릴리즈 범위 반영 Diff

기준일: 2026-03-25

## 유지한 기능

| 기능 | 유지 이유 | 관련 파일 |
| --- | --- | --- |
| `Chordest` 메인 진입 | 이번 릴리즈의 주인공 | `lib/main_menu_page.dart`, `lib/main_menu/main_menu_view.dart` |
| `Chordest` 생성/연습 플로우 | 핵심 사용자 루프 | `lib/practice_home_page.dart`, `lib/practice_home_page_ui.dart` |
| setup assistant | 첫 실행 진입과 안전한 시작값 제공 | `lib/settings/practice_setup_assistant.dart` |
| settings drawer / advanced settings | 실제 사용 가능한 조정 수단 | `lib/settings/practice_settings_drawer_view.dart`, `lib/settings/practice_advanced_settings_page.dart` |
| `Analyzer` 기본 분석 | 보조 도구로는 안정 공개 가능 | `lib/chord_analyzer_page_view.dart` |

## 숨긴 기능

| 기능 | 처리 | 이유 | 관련 파일 |
| --- | --- | --- | --- |
| setup assistant의 `Study Harmony` 카드 | 기본 비노출 | 이번 출시 범위 밖 | `lib/settings/practice_setup_assistant.dart`, `lib/release_feature_flags.dart` |
| settings drawer의 `Study Harmony` CTA | 기본 비노출 | orphan navigation 방지 | `lib/settings/practice_settings_drawer_view.dart`, `lib/release_feature_flags.dart` |
| generator 내부 `onOpenStudyHarmony` 슬롯 | release-safe guard | 콜백 재배선 시 재노출 방지 | `lib/practice_home_page.dart`, `lib/practice_home_page_ui.dart`, `lib/release_feature_flags.dart` |
| `Analyzer` variation 생성 버튼/결과 | 기본 비노출 | 고급 액션 노출 축소 | `lib/chord_analyzer_page_view.dart`, `lib/release_feature_flags.dart` |
| advanced settings의 `trackAware` 사운드 옵션 | release UI 비노출 | 숨긴 `Study Harmony` 트랙 개념과 결합돼 있음 | `lib/settings/practice_advanced_settings_page.dart` |

## 삭제한 사용자 노출 경로

| 경로 | 현재 상태 | 이유 | 관련 파일 |
| --- | --- | --- | --- |
| 메인 메뉴의 `Study Harmony` 소개 서사 | 제거 유지 | `Chordest` 단일 주인공 정렬 | `lib/l10n/app_*.arb`, `lib/main_menu_page.dart` |
| 메인 메뉴의 다기능 소개 문구 | `Chordest` 중심으로 교체 | 브랜드 혼선 제거 | `lib/l10n/app_*.arb` |
| `Study Harmony` 중심 스토어 스크린샷 가이드 | 제거 | 출시 범위와 스토어 메시지 정렬 | `store/assets/captions/en-US.md`, `store/assets/captions/ko-KR.md`, `store/assets/google-play/phone-screenshots/README.md`, `store/assets/app-store/iphone-screenshots/README.md` |
| Play Console 초안의 `Study Harmony` 중심 설명 | `Chordest` 중심으로 수정 | 실제 출시 범위 반영 | `store/google-play/app-content-notes.md` |

## 이유 요약

- `Study Harmony`는 이번 주 Android 출시 범위에 포함하지 않는다.
- `Analyzer`는 공개하되, 결과 변주 같은 고급 액션은 기본값에서 숨긴다.
- `Chordest`를 첫 화면과 주요 카피의 중심으로 고정한다.
- 기존 데이터, 저장소, 마이그레이션, 파서, 캐시는 삭제하지 않는다.

## 관련 파일 경로 묶음

- 기능 가드:
  - `lib/release_feature_flags.dart`
- `Study Harmony` 봉인:
  - `lib/practice_home_page.dart`
  - `lib/practice_home_page_ui.dart`
  - `lib/settings/practice_setup_assistant.dart`
  - `lib/settings/practice_settings_drawer_view.dart`
- `Analyzer` 보수화:
  - `lib/chord_analyzer_page_view.dart`
- 브랜딩 / 카피:
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_es.arb`
  - `lib/l10n/app_ja.arb`
  - `lib/l10n/app_ko.arb`
  - `lib/l10n/app_zh.arb`
  - `lib/l10n/app_zh_Hans.arb`
- 스토어 참고 자료:
  - `store/assets/captions/en-US.md`
  - `store/assets/captions/ko-KR.md`
  - `store/assets/google-play/phone-screenshots/README.md`
  - `store/assets/app-store/iphone-screenshots/README.md`
  - `store/google-play/app-content-notes.md`

## 작업 가정

- 기본 배포에서는 feature flag를 켜지 않는다.
- `Study Harmony` 코드는 내부 자산/데이터 보존 대상으로 남긴다.
- 향후 재노출 시에도 지금 추가한 가드를 의식적으로 해제해야 한다.
