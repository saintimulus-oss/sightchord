# 프리미엄 기능 매트릭스

기준일: 2026-03-25

| 기능 묶음 | 실제 구현 상태 | 이번 릴리즈 분류 | 근거 | 관련 파일 경로 |
| --- | --- | --- | --- | --- |
| 기본 Generator 루프 | 구현 완료 | 무료 | 앱 정체성의 핵심 가치이며 과도한 무료 제한 금지 원칙에 맞음 | `lib/practice_home_page.dart`, `lib/practice_home_page_ui.dart` |
| 기본 코드 표기 / inversion / slash bass | 구현 완료 | 무료 | 기본 학습 가치에 해당하고 안정성 높음 | `lib/practice_home_page_ui.dart`, `lib/settings/practice_advanced_settings_page.dart` |
| 메트로놈 / 커스텀 메트로놈 사운드 | 구현 완료 | 무료 | 출시 핵심 사용성, 무료 유지가 적절 | `lib/settings/practice_advanced_settings_page.dart`, `test/practice_settings_drawer_custom_metronome_test.dart` |
| setup assistant / 언어 / 테마 | 구현 완료 | 무료 | 첫 실행 이해도와 접근성에 직접 연결됨 | `lib/settings/practice_setup_assistant.dart`, `lib/main_menu/main_menu_settings_sheet.dart` |
| Analyzer 기본 분석 / warning / confidence | 구현 완료 | 무료 | 보조 도구로 안정 공개 가능, 과금 대상화 시 신뢰 리스크 큼 | `lib/chord_analyzer_page_view.dart` |
| Smart Generator mode | 구현 완료 | 프리미엄 | 실제 기능 완성도 높고 무료 코어와 경계가 분명함 | `lib/billing/premium_feature_access.dart`, `lib/practice_home_page_ui.dart` |
| `secondary dominant` / `substitute dominant` / `modal interchange` | 구현 완료 | 프리미엄 | 고급 화성 색채 옵션으로 사용자 가치가 분명함 | `lib/billing/premium_feature_access.dart`, `lib/settings/practice_advanced_settings_page.dart` |
| 고급 tension 허용 | 구현 완료 | 프리미엄 | 고급 화성 옵션과 자연스럽게 묶이며 sanitize 경계가 명확함 | `lib/billing/premium_feature_access.dart`, `lib/settings/practice_advanced_settings_page.dart` |
| Smart Generator 고급 제어 | 구현 완료 | 프리미엄 | `modulationIntensity`, `jazzPreset`, `sourceProfile` 는 고급 생성 제어에 해당 | `lib/billing/premium_feature_access.dart`, `lib/settings/practice_advanced_settings_page.dart` |
| 내부 `smartDiagnosticsEnabled` | 내부 구현 존재 | 프리미엄 내부 경계만 유지 | sanitize 대상이지만 릴리즈 UI 에 적극 노출하지 않음 | `lib/billing/premium_feature_access.dart`, `lib/practice/practice_session_controller.dart` |
| 프리미엄 paywall / restore | 구현 완료 | 사용자 노출 유지 | 구매 경계와 복원 경계를 명확히 보여줌 | `lib/billing/paywall_sheet.dart`, `lib/main_menu/main_menu_settings_sheet.dart` |
| 저장 제한 / 히스토리 제한 / 프리셋 제한 | 구조 일부만 존재 | 이번 릴리즈 유료 제외 | 안전한 3~5개 제한 경계가 아직 크고 회귀 위험이 있음 | `docs/monetization_plan.md` |
| export 계열 기능 | 사용자 기능으로 미완성 | 이번 릴리즈 유료 제외 | 실제 없는 기능을 유료로 홍보하면 안 됨 | `docs/monetization_plan.md` |
| Analyzer variation / 대안 분석 액션 | 구현은 있으나 비노출 | 이번 릴리즈 유료 제외 | 안정성 보수 원칙상 숨김 유지, 유료화 금지 | `lib/chord_analyzer_page_view.dart`, `lib/release_feature_flags.dart` |
| Study Harmony 전체 | 코드/데이터 유지 | 이번 릴리즈 유료 제외 | 사용자 UI 완전 봉인 정책 유지 | `lib/study_harmony/**`, `lib/release_feature_flags.dart` |
| Study Harmony 추가 트랙 / cosmetic | 코드와 데이터 존재 | 향후 프리미엄 후보 | 지금은 문서화만 하고 사용자에게 노출하지 않음 | `lib/study_harmony/content/**`, `lib/study_harmony/meta/**` |

## 저장 제한 보류 사유

- 현재 저장/히스토리/프리셋은 사용자 약속과 데이터 경계를 안전하게 나누는 구조가 충분히 좁지 않다.
- 이번 주 안에 수량 제한을 붙이면 상태 복원과 기존 데이터 보존 리스크가 커진다.
- 따라서 이번 릴리즈에서는 저장 제한을 무료 유지 또는 무과금 상태로 두고, 별도 과금 경계는 만들지 않는다.

## 사용자에게 실제로 보이는 무료 vs 프리미엄 차이

- 무료:
  - 기본 Generator
  - Analyzer
  - 메트로놈
  - 언어/테마
  - setup assistant
- 프리미엄:
  - Smart Generator
  - 비다이아토닉 컬러
  - 고급 tension
  - Smart Generator 고급 제어

## 작업 가정

- 유료 기능은 모두 현재 저장소에서 실제로 동작하고, sanitize 및 복원 경계가 확인된 항목만 선택했다.
- 기능 수를 늘리기보다 경계가 명확한 묶음을 우선했다.
