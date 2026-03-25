# 수익화 후보 감사

기준일: 2026-03-25

## 결론

- 현재 저장소에는 실제 Play Billing / App Store 결제 스택이 없다.
- 이번 1주 Android 출시 범위에서는 `유료화 없이 무료 출시`가 가장 현실적이다.
- 수익화 후보는 대부분 `Study Harmony` 쪽에 몰려 있으며, 현재는 코드와 데이터만 준비된 상태다.

## 현재 구현 상태

| 항목 | 실제 구현 상태 | 현재 사용자 노출 | 과금 적합도 | 판단 |
| --- | --- | --- | --- | --- |
| Chordest 핵심 기능 | 구현 완료 | 노출 중 | 낮음 | 무료 유지 권장 |
| Analyzer | 구현 완료 | 노출 중 | 낮음 | 무료 유지 권장 |
| Study Harmony core track | 코드/화면/데이터 존재 | 기본 비노출 | 중간 | 이번 출시 비노출 |
| Study Harmony pop/jazz/classical track | 코드/콘텐츠 존재 | 비노출 | 높음 | 향후 프리미엄 후보 |
| Study Harmony shop/title/cosmetic | 로컬 경제 구현 | 비노출 | 중간 | Billing 없이는 출시 불가 |
| reward bundle / league / quest chest | 로컬 메타 시스템 구현 | 비노출 | 낮음 | 직접 과금보다 retention 시스템에 가까움 |
| 결제 복원 / entitlement / 영수증 검증 | 미구현 | 없음 | 필수 | 선행 구현 없이는 과금 금지 |
| 계정/진행도 동기화 | 미구현 | 없음 | 중요 | 과금 후 지원 리스크 큼 |

## 무료 기능 권장안

- 이번 Android 출시에서는 다음을 무료 기능으로 고정한다.
  - `Chordest`
  - 메트로놈 / setup assistant / advanced settings
  - `Analyzer`

## 향후 프리미엄 후보

### 1순위

- `Study Harmony` 추가 트랙
  - `pop`
  - `jazz`
  - `classical`
- 이유:
  - 이미 트랙/코스/콘텐츠 구조가 있다.
  - `Chordest` 핵심 무료 가치와 분리하기 쉽다.

### 2순위

- `Study Harmony` 내 title / cosmetic / shop unlock
- 이유:
  - 데이터 구조와 보상 카탈로그가 이미 있다.
  - 다만 현재는 실제 돈이 아니라 로컬 재화 차감만 구현돼 있다.

## 이번 출시에서 금지할 수익화

- 구독
- 광고
- “coming soon” 만으로 결제 유도
- 로컬 상점을 실제 결제로 포장하는 행위
- restore/entitlement 없이 프리미엄 약속

## 수익화 선행조건

1. Billing SDK 통합
2. entitlement 모델
3. restore flow
4. 실패/취소/pending 처리
5. 스토어 카피와 실제 제공 기능 일치
6. 진행도 sync 미구현에 대한 명확한 커뮤니케이션

## 이번 단계의 판단 근거

- `pubspec.yaml` 기준 결제 의존성 없음
- 런타임 코드에 paywall / entitlement / restore 없음
- `Study Harmony` 상점은 로컬 재화 기반
- 메인 UI에는 업그레이드 진입 없음

## 작업 가정

- 이번 릴리즈의 최우선 목표는 Android 제출 가능 상태 수렴이며, 매출 실험보다 안정성이 더 중요하다고 가정했다.
- 추후 수익화는 `Study Harmony` 쪽에서 분리된 value pack 형태가 가장 자연스럽다고 판단했다.
