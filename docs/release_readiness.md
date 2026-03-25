# Android 릴리즈 준비 상태

기준일: 2026-03-25
판정: 조건부 출시 가능

## 문서 역할

- 이 문서는 Android release readiness 와 최종 검증 결과의 source of truth 다.
- 실제 운영 순서는 `docs/manual_play_console_tasks.md` 와 `docs/handoff_guide.md` 를 따른다.

## 현재 판정

- `flutter analyze`, `flutter test`, 임시 서명 기반 `release appbundle` 빌드는 모두 통과했다.
- 코드 기준으로는 Android 릴리즈 후보 상태다.
- 다만 프로덕션 전환 전에는 Play Console 수동 작업과 실기기 QA 증거가 반드시 필요하다.

## 이번 단계에서 확인한 핵심 항목

### Android 빌드 / 설정

- `android/app/build.gradle.kts`
  - `namespace`, `applicationId`: `io.github.saintimulusoss.chordest`
  - Java / Kotlin target: 17
  - release signing 미설정 시 release task가 실패하도록 guard가 들어가 있다.
- `android/app/src/main/AndroidManifest.xml`
  - 앱 라벨은 `Chordest`
  - `MAIN` / `LAUNCHER` 진입점 1개
  - deep link / app link intent filter 없음
- billing
  - 1회 구매형 `premium_unlock`
  - startup initialize, resume sync, manual restore CTA 경로 확인

### 안정성 하드닝

- `lib/app_bootstrap.dart`
  - startup preload 예외가 `runApp()` 자체를 막지 않도록 보호되어 있다.
  - `StudyHarmonyProgressController.load()`는 유지하되 비차단 preload로 내려가 있다.
- `lib/billing/billing_controller.dart`
  - entitlement cache load 실패가 앱 시작을 깨지 않도록 완화 처리되어 있다.
- `lib/chord_analyzer_page_view.dart`
  - 입력 오류 시 배너 제목을 `Warnings` 대신 입력 맥락으로 표시하도록 조정했다.
- `lib/practice_home_page_ui.dart`
  - `Current Chord` / `Next Chord` 하드코딩을 locale 기반 문자열로 치환했다.

### 릴리즈 경로 노출 점검

- `Study Harmony`
  - 기본 feature flag 는 `false`
  - main menu, generator, setup assistant, settings release 경로에서 재노출되지 않음
  - named route, deep link, Android manifest 진입점 없음
- `Analyzer`
  - 기본 분석, confidence, ambiguity, warning UI 유지
  - 고급 variation 액션은 기본 비노출 상태 유지

## 아직 남은 blocker

- 영구 upload keystore 및 Play App Signing 운영 확정
- Play Console 에서 `premium_unlock` 상품 생성 및 활성화
- 내부 테스트 계정으로 실제 구매 / 취소 / 보류 / 복원 / 환불 검증
- Android phone / tablet 실기기 smoke 증거 확보
- Data safety / App content / 개인정보 / 앱 접근 정보 / 스토어 정보 최종 입력
- 최종 스토어 스크린샷 교체

## 높은 우선순위이지만 코드 수정으로 끝나지 않는 항목

- `es` / `ja` / `zh` / `zh_Hans` 에서 paywall 과 일부 고급 설정 카피가 아직 완전한 릴리즈 수준은 아니다.
- full process-death navigation restoration 은 아직 없다.
- 환불 / 권한 회수 반영은 서버 없이 다음 성공적인 owned purchase 조회 시점에 반영된다.

## 이번 단계 검증 결과

| 명령 | 결과 | 비고 |
| --- | --- | --- |
| `flutter gen-l10n` | 성공 | 다국어 생성 코드 재생성 |
| `flutter analyze` | 성공 | 이슈 0 |
| `flutter test test/localization_test.dart test/app_bootstrap_smoke_test.dart test/billing_controller_test.dart` | 성공 | 핵심 smoke / billing / localization 통과 |
| `flutter test` | 성공 | 전체 637개 통과 |
| `powershell -ExecutionPolicy Bypass -File tool\validate_mobile_release.ps1 -UseTemporarySigningKey` | 성공 | analyze, 전체 test, store checks, mobile audit 35/35, release AAB, release web 통과 |

## 결론

- 현재 저장소는 Android release candidate 로 볼 수 있다.
- 출시는 코드보다 운영 준비가 더 큰 리스크다.
- 이번 주 배포를 목표로 한다면 다음 순서는 `internal testing -> closed testing -> production` 이다.
