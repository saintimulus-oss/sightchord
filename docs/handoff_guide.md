# Handoff Guide

기준일: 2026-03-25
대상: 다음 담당자가 Android 출시 준비를 이어받을 때 사용하는 운영 가이드

## 1. 먼저 읽을 문서 순서

1. `docs/release_status.md`
2. `docs/final_release_summary.md`
3. `docs/release_readiness.md`
4. `docs/manual_play_console_tasks.md`
5. `docs/known_issues.md`
6. `docs/smoke_test_checklist.md`

## 2. 앱 실행 / 빌드 방법

### 로컬 실행

- 의존성 설치: `flutter pub get`
- 앱 실행: `flutter run`

### 기본 검증

- 정적 분석: `flutter analyze`
- 전체 테스트: `flutter test`

### Android 릴리즈 검증

- 임시 서명 검증:
  - `powershell -ExecutionPolicy Bypass -File tool\validate_mobile_release.ps1 -UseTemporarySigningKey`
- 실제 release signing:
  - `android/key.properties` 또는 `ANDROID_KEYSTORE_*` 환경 변수 준비
  - 이후 `flutter build appbundle --release`

## 3. 결제 테스트 방법

### 로컬 코드 레벨

- `flutter test test/billing_controller_test.dart`
- `flutter test test/localization_test.dart test/app_bootstrap_smoke_test.dart`

### Play Console 내부 테스트

1. `premium_unlock` 상품 생성 및 활성화
2. 라이선스 테스터 등록
3. internal testing 트랙에 AAB 업로드
4. 테스트 계정으로 구매
5. 앱 재실행 후 premium 유지 확인
6. `구매 복원` 버튼 확인
7. 취소 / 보류 / 환불 시나리오 확인

## 4. 스모크 테스트 순서

- 체크리스트 원문: `docs/smoke_test_checklist.md`

### 최소 순서

1. 첫 실행
2. 메인 메뉴에서 `Start Practice`
3. 메인 메뉴에서 `Analyze Progression`
4. 메인 설정 sheet 열기
5. premium paywall 열기
6. offline 재진입
7. background -> resume
8. locale 변경
9. 앱 재실행
10. `Study Harmony` 비노출 재확인

## 5. Play Console 수동 설정 순서

1. 앱 정보와 브랜딩 확인
2. 영구 upload keystore / Play App Signing 확정
3. `premium_unlock` 상품 생성
4. 가격 입력
5. 라이선스 테스터 등록
6. internal testing 업로드
7. Data safety / App content / 개인정보 / 앱 접근 정보 입력
8. 스토어 설명 / 스크린샷 / feature graphic 교체
9. closed testing 전환
10. production 전환 여부 결정

자세한 항목은 `docs/manual_play_console_tasks.md` 를 따른다.

## 6. 출시 당일 체크 순서

1. `flutter analyze`
2. `flutter test`
3. release 검증 스크립트 실행
4. 최종 AAB 재빌드
5. `premium_unlock` active 상태 재확인
6. 내부 테스트 계정 restore 재확인
7. phone / tablet 실기기 smoke 마지막 수행
8. 스토어 문구와 스크린샷 마지막 검수
9. staged rollout 여부 결정
10. 업로드 및 배포

## 7. 롤백 시 주의점

- `Study Harmony` 봉인용 feature flag 기본값은 유지해야 한다.
- premium 정책을 되돌릴 때는 `premium_unlock` 상품 상태와 앱 내 gating 을 같이 확인해야 한다.
- 서버가 없으므로 entitlement 는 로컬 cache 와 owned purchase 조회에 의존한다.
- 롤백 후에도 기존 premium 사용자 cache 가 남아 있을 수 있으니 restore 흐름을 다시 확인해야 한다.

## 8. known issue 확인 방법

- 최신 우선순위: `docs/known_issues.md`
- 제품/기술 근거: `docs/release_audit.md`
- 운영 blocker: `docs/release_readiness.md`

## 9. 이번 릴리즈에서 하지 말아야 할 것

- 상태관리 전면 교체
- 대규모 폴더 재구성
- 구독 도입
- 서버 추가
- `Study Harmony` 재노출
- 출시와 무관한 구조 리팩터링
