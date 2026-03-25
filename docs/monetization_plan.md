# 수익화 구현 계획

기준일: 2026-03-25

## 문서 역할

- 이 문서는 결제 모델, entitlement 구조, 가격 전략, 수익화 원칙의 source of truth 다.
- 실제 기능 경계는 `docs/premium_feature_matrix.md` 와 `docs/release_scope_matrix.md` 를 함께 본다.

## 결론

- 이번 릴리즈의 결제 모델은 `premium_unlock` 1종의 1회 구매형 영구 해금이다.
- 구독은 도입하지 않는다.
- 서버는 새로 만들지 않는다.
- 무료 핵심 루프는 유지하고, 실제 구현 품질이 높은 고급 생성 제어만 프리미엄으로 묶는다.

## 이번 릴리즈 실제 유료 상품

- 상품 유형: 1회 구매형 non-consumable / managed product
- 상품 ID: `premium_unlock`
- 사용자 메시지 축: `한 번 구매로 영구 해금`

## 권한 구조

- entitlement 모델:
  - `AppEntitlement.premiumUnlock`
- 상태 모델:
  - `BillingEntitlementRecord`
  - `BillingState`
  - `BillingOperation`
- 컨트롤러:
  - `BillingController`
- 주입 방식:
  - 앱 런타임: `BillingController.live()`
  - 테스트/프리뷰: `BillingController.noop()`
- 캐시:
  - `SharedPreferences`
  - 키: `billing_state_v2`
  - legacy fallback: `billing_state_v1`

## 동기화 정책

- 앱 시작:
  - 캐시 snapshot 을 먼저 로드한다.
  - 이후 스토어 카탈로그와 entitlement 를 비동기 동기화한다.
- 앱 resume:
  - 30초 cooldown 이후 재동기화한다.
- 복원:
  - Android 에서는 owned purchase 재조회를 우선 사용한다.
  - owned purchase 조회를 못 쓰는 플랫폼에서는 restore fallback 을 사용한다.
- 오프라인:
  - 최근 확정 entitlement 캐시를 유지한다.
- 환불/권한 상실:
  - 다음 성공적인 owned purchase 재검증 때 entitlement 를 비활성화한다.

## 구매 상태 처리

- 성공: entitlement 활성화, acknowledge/complete 처리
- 취소: 무료 기능 유지, 상태 메시지만 표시
- 실패: 무료 기능 유지, 재시도 가능
- 보류: 유료 기능은 계속 잠금, 스토어 확정까지 대기
- 복원 성공: entitlement 활성화
- 복원 실패: 기존 무료 흐름 유지
- 중복 구매 / 중복 복원 / 지연 응답:
  - purchase key 기반으로 idempotent 하게 처리한다.

## 무료 / 유료 분류 원칙

- 무료 유지:
  - 기본 Generator 기능
  - 기본 코드 정보 표기
  - 기본 inversion / slash bass
  - 기본 metronome
  - 최소 안정 Analyzer
  - 기본 언어 지원
- 프리미엄 해금:
  - Smart Generator mode
  - 고급 화성 색채 옵션
  - 고급 tension
  - Smart Generator 고급 제어
- 이번 릴리즈 유료 제외:
  - 저장 제한 / 히스토리 제한 / 프리셋 제한
  - export 계열
  - `Analyzer` 고급 variation
  - `Study Harmony`

## 가격 전략

- 권장 정가: 8,900원
- 출시 초기 프로모션: 6,500원
- 앱 내부 가격 표시는 하드코딩하지 않는다.
- 구매 CTA 는 항상 스토어 상품의 `priceLabel` 을 사용한다.

## 향후 가격 상향 조건

1. 내부 테스트와 초기 배포에서 구매, 복원, 환불, 보류 이슈가 blocker 없이 안정화될 것
2. 실제 사용자 피드백에서 Smart Generator 가치가 명확히 인식될 것
3. 프리미엄 기능 사용량이 높고 환불/지원 부담이 낮을 것
4. 무료 핵심 루프를 해치지 않는 추가 가치가 더해질 것
5. 스토어 평점과 초기 전환 데이터가 가격 상향을 견딜 수준일 것

## 스토어 상품 정보가 없을 때의 앱 동작

- 앱 전체는 멈추지 않는다.
- 무료 기능은 그대로 사용 가능하다.
- paywall 은 열리지만 구매 버튼은 비활성 또는 상품 미조회 상태가 된다.
- 사용자는 `구매 복원` 또는 나중 재시도를 선택할 수 있다.

## 복원 / 실패 / 보류 / 환불 반영 정책

- 복원:
  - 수동 `구매 복원` CTA 제공
  - 앱 시작 및 resume 동기화에서도 entitlement 확인
- 실패:
  - 짧고 명확한 오류 문구만 표시
  - 무료 기능 차단 금지
- 보류:
  - premium 미활성 상태 유지
  - 사용자에게 확정 전 대기 상태만 안내
- 환불:
  - 다음 성공적인 entitlement 재검증 때 premium 해제
  - 오프라인 캐시가 남아 있을 수 있으므로 온라인 resume/manual sync 가 필요

## Play Console 에서 수동 생성해야 할 항목

- 앱 내 상품 1종 생성
  - ID: `premium_unlock`
  - 유형: 1회 구매형
- 로컬라이즈된 상품명과 설명
- 대한민국 포함 판매 국가 가격 설정
- 테스트 계정 / 내부 테스트 트랙 설정
- 구매 승인, 복원, 환불 검증용 테스트 시나리오 준비

## 이번 단계에서 의도적으로 하지 않은 일

- 구독
- 서버/영수증 서버 검증
- 광고 제거형 과금
- 저장 개수 제한
- `Study Harmony` 유료 재노출

## 작업 가정

- 이번 Android 출시의 핵심 가치는 무료 `Chordest` 루프이며, 프리미엄은 고급 생성 제어를 여는 보조 레이어라고 가정했다.
- 현재 타깃은 Android 이므로 owned purchase 재조회 중심 설계를 우선했다.
- 결제 운영 문구는 한국어를 우선 검수하고, 다른 locale 은 기존 현지화 체계에 맞춰 추가 반영했다.
