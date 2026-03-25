# Billing 테스트 계획

기준일: 2026-03-25

## 목표

- 1회 구매형 entitlement 구조가 무료 핵심 루프를 깨지 않는지 확인한다.
- 구매, 복원, 오프라인, 중복 응답, 첫 실행 회귀를 모두 최소 안전 범위에서 검증한다.

## 이번 단계에서 실제 실행한 명령

| 명령 | 결과 | 목적 |
| --- | --- | --- |
| `flutter analyze` | 성공 | 정적 검사 |
| `flutter test test/widget_test.dart --plain-name "new users land on a ready chord with beginner-safe defaults"` | 성공 | 첫 실행 무료 경로 회귀 확인 |
| `flutter test test/widget_test.dart --plain-name "welcome card can open the setup assistant on demand"` | 성공 | 첫 실행 이후 설정 이동 확인 |
| `flutter test test/widget_test.dart --plain-name "setup assistant symbol examples keep the delta glyph intact"` | 성공 | setup assistant 회귀 확인 |
| `flutter test test/widget_test.dart --plain-name "main menu settings can open the premium paywall safely"` | 성공 | paywall 스모크 확인 |
| `flutter test` | 성공 | 전체 회귀 635개 통과 |
| `powershell -ExecutionPolicy Bypass -File tool/validate_mobile_release.ps1 -UseTemporarySigningKey` | 성공 | analyze/test/store checks/AAB/web build 전체 확인 |

## 코드 기반 시뮬레이션 범위

| 시나리오 | 시뮬레이션 방식 | 구현 위치 | 결과 |
| --- | --- | --- | --- |
| 오프라인 재진입 시 캐시 entitlement 유지 | fake gateway + in-memory store | `test/billing_controller_test.dart` | 통과 |
| Android owned purchase 기반 복원 | fake gateway `ownedPurchases` | `test/billing_controller_test.dart` | 통과 |
| stale entitlement 회수 | 동기화 시 owned purchase 빈 목록 | `test/billing_controller_test.dart` | 통과 |
| 중복 구매 업데이트 idempotent 처리 | 동일 purchase 두 번 emit | `test/billing_controller_test.dart` | 통과 |
| 구매 보류 / 취소 구분 | `pending`, `canceled` 상태 emit | `test/billing_controller_test.dart` | 통과 |
| 메인 설정에서 paywall 진입 | widget smoke | `test/widget_test.dart` | 통과 |
| 첫 실행 무료 bootstrap 안정성 | widget smoke | `test/widget_test.dart` | 통과 |

## 수동 테스트 체크리스트

1. 내부 테스트 트랙 계정으로 `premium_unlock` 구매
2. 앱 재실행 후 premium 유지 확인
3. 네트워크 차단 후 재진입 시 최근 entitlement 캐시 유지 확인
4. 앱을 백그라운드로 보냈다가 복귀해 resume sync 동작 확인
5. 동일 계정 다른 설치 환경에서 `구매 복원` 확인
6. 구매 중 취소 시 무료 기능 계속 사용 가능한지 확인
7. 구매 보류 계정에서 paywall 상태 메시지와 잠금 유지 확인
8. 환불 후 온라인 resume/manual sync 에서 premium 해제 확인

## 한계와 미검증 항목

- 실제 Play Console 상품이 아직 생성되지 않아 실스토어 purchase stream 은 아직 검증하지 못했다.
- 실제 환불 반영은 Google Play 테스트 계정과 콘솔 설정이 있어야 검증 가능하다.
- iOS/macOS 실스토어 restore 는 이번 Android 출시 범위 밖이므로 로컬 코드 수준만 유지한다.

## debug / profile / release 차이

- 기능 경계 자체는 동일하다.
- 테스트/프리뷰에서 `MyApp` 을 직접 생성하면 `BillingController.noop()` 이 기본이라 스토어 없이 동작한다.
- 실제 `bootstrapApp()` 과 릴리즈 빌드는 `BillingController.live()` 로 스토어를 사용한다.

## 회귀 포인트

- 첫 실행 `beginnerSafePreset` 은 항상 무료 안전값이어야 한다.
- entitlement 상실 시 sanitize 로 premium 설정이 남지 않아야 한다.
- 상품 조회 실패가 앱 전체 loading/blocking 으로 번지지 않아야 한다.
- `Study Harmony` 비노출 정책과 충돌하는 결제 CTA 를 추가하면 안 된다.
