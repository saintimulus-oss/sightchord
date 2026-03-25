# 릴리즈 상태

기준일: 2026-03-25
현재 상태: Android release candidate, 운영 blocker 해소 전 프로덕션 전환 보류

## Source Of Truth 문서 맵

- 전체 상태 / handoff 시작점: `docs/release_status.md`
- 최종 범위와 이번 작업 전체 요약: `docs/final_release_summary.md`
- 기술/제품 감사 근거: `docs/release_audit.md`
- 실제 출시 범위와 포함/제외 판단: `docs/release_scope_matrix.md`
- 수익화 정책과 무료/프리미엄 경계: `docs/monetization_plan.md`, `docs/premium_feature_matrix.md`
- Android readiness / 검증 결과: `docs/release_readiness.md`
- Play Console 수동 작업: `docs/manual_play_console_tasks.md`
- 남은 리스크 / known issue: `docs/known_issues.md`
- QA 실행 순서: `docs/smoke_test_checklist.md`, `docs/billing_test_plan.md`
- 최종 운영 인수인계: `docs/handoff_guide.md`

## 이번 단계 요약

- Android release hardening 과 QA 문서화를 진행했다.
- 4개 병렬 점검을 실행했고, 결과를 메인 에이전트가 통합 반영했다.
- startup / billing / locale / hidden feature 경로를 최종 점검했다.

## 이번 단계 실제 수정

- `lib/practice_home_page_ui.dart`
  - 현재/다음 코드 레이블을 locale 기반 문자열로 변경
- `lib/chord_analyzer_page_view.dart`
  - 입력 오류 시 분석 배너 제목을 중립적으로 조정
- `lib/l10n/app_en.arb`
  - `currentChord` 추가
  - premium product unavailable 문구 사용자용으로 정리
  - buy button 가격 표기 문구 정리
- `lib/l10n/app_ko.arb`
  - `currentChord` 추가
  - premium product unavailable 문구 사용자용으로 정리
  - buy button 가격 표기 문구 정리
- `lib/l10n/app_es.arb`
  - 첫 실행 welcome 카드 핵심 카피 번역
  - current chord 레이블 추가
  - paywall 오류 문구 일부 번역
- `lib/l10n/app_ja.arb`
  - 첫 실행 welcome 카드 핵심 카피 번역
  - current chord 레이블 추가
  - paywall 오류 문구 일부 번역
- `lib/l10n/app_zh.arb`
  - 첫 실행 welcome 카드 핵심 카피 번역
  - current chord 레이블 추가
  - paywall 오류 문구 일부 번역
- `lib/l10n/app_zh_Hans.arb`
  - 첫 실행 welcome 카드 핵심 카피 번역
  - current chord 레이블 추가
  - paywall 오류 문구 일부 번역
- `test/localization_test.dart`
  - current chord / billing error wording 회귀 테스트 추가

## 기존 하드닝 상태 재확인

- `lib/app_bootstrap.dart`
  - startup preload 예외가 `runApp()` 을 막지 않음
- `lib/billing/billing_controller.dart`
  - entitlement cache load 실패가 initialize 를 중단시키지 않음
- `lib/app_shell.dart`
  - app resume 시 billing refresh 경로 유지
- `lib/release_feature_flags.dart`
  - `Study Harmony`, advanced analyzer action 기본값은 모두 `false`

## 실행한 검증 명령

| 명령 | 결과 | 메모 |
| --- | --- | --- |
| `flutter gen-l10n` | 성공 | 로컬라이제이션 재생성 |
| `flutter analyze` | 성공 | 이슈 0 |
| `flutter test test/localization_test.dart test/app_bootstrap_smoke_test.dart test/billing_controller_test.dart` | 성공 | 핵심 smoke 통과 |
| `flutter test` | 성공 | 전체 637개 통과 |
| `powershell -ExecutionPolicy Bypass -File tool\validate_mobile_release.ps1 -UseTemporarySigningKey` | 성공 | analyze, 전체 test, store checks, mobile audit 35/35, release AAB, release web 통과 |

## 현재 blocker / high

- `blocker` 영구 upload keystore / Play App Signing
- `blocker` Play Console `premium_unlock` 상품 생성 및 활성화
- `high` 내부 테스트 계정 기반 실제 billing QA
- `high` Android phone / tablet 실기기 QA 증거
- `high` Data safety / App content / 개인정보 / 스토어 정보 최종 입력

## 작업 가정

- 이번 릴리즈는 `Chordest` 중심이며 `Study Harmony` 는 계속 비노출이다.
- premium 은 구독 없이 `premium_unlock` 1종 1회 구매형만 사용한다.
- 서버를 새로 두지 않고 Play Billing + 로컬 entitlement cache 로만 운영한다.

## GitHub Pages 배포 상태

- 배포 대상: `https://saintimulus-oss.github.io/`
- 배포 방식: `.github/workflows/deploy-pages.yml`
- 최종 확인 기준:
  - `flutter analyze`
  - `flutter test`
  - `flutter build web --release --base-href /`
- 운영 메모:
  - Pages 배포는 `main` push 또는 `workflow_dispatch` 로 수행한다.
  - 공개 웹 빌드도 `Chordest` 브랜딩과 `Study Harmony` 비노출 정책을 동일하게 유지한다.
