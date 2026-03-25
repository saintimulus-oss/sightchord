# 릴리즈 범위 매트릭스

기준일: 2026-03-25

## 분류 기준

- `이번 출시 포함`: Android 1차 출시에서 사용자에게 직접 노출한다.
- `이번 출시 포함(프리미엄 해금)`: 실제 구현과 결제 경계가 붙어 있으며, 1회 구매 후 노출된다.
- `이번 출시 제외`: 코드가 있더라도 이번 주 출시 약속에 넣지 않는다.
- `코드/데이터 유지, UI 비노출`: 저장소에는 남기되 사용자 경로에서는 숨긴다.
- `향후 프리미엄 후보`: 이번 릴리즈에서는 과금하지 않지만, 향후 가치 팩 후보로 남긴다.

| 항목 | 현재 구현 상태 | 현재 사용자 진입 | 분류 | 비고 / 현재 조치 |
| --- | --- | --- | --- | --- |
| Main Menu | 구현 완료 | 있음 | 이번 출시 포함 | `Chordest` + `Analyzer` 2개 진입 유지 |
| 메인 설정 sheet(언어/테마) | 구현 완료 | 있음 | 이번 출시 포함 | 프리미엄 카드와 복원 CTA 포함 |
| 프리미엄 paywall / restore sheet | 구현 완료 | 있음 | 이번 출시 포함 | `premium_unlock` 1회 구매형, 상품 미조회 시 구매 비활성 |
| Chordest 기본 Generator | 구현 완료 | 있음 | 이번 출시 포함 | 이번 릴리즈의 주인공, 무료 핵심 가치 유지 |
| 기본 코드 정보 표기 / inversion / slash bass | 구현 완료 | 있음 | 이번 출시 포함 | 무료 유지 |
| 기본 metronome / custom sound | 구현 완료 | 있음 | 이번 출시 포함 | 무료 유지 |
| setup assistant | 구현 완료 | 있음 | 이번 출시 포함 | 첫 실행 기본 preset은 무료 안전값으로 조정 |
| settings drawer / 일반 advanced settings | 구현 완료 | 있음 | 이번 출시 포함 | 유료와 무관한 기본 설정 유지 |
| Smart Generator mode | 구현 완료 | 잠금 진입 있음 | 이번 출시 포함(프리미엄 해금) | 잠금 chip/설정 진입에서 paywall 연결 |
| 비다이아토닉 화성 옵션 | 구현 완료 | 잠금 진입 있음 | 이번 출시 포함(프리미엄 해금) | `secondary dominant`, `substitute dominant`, `modal interchange` |
| 고급 tension 허용 | 구현 완료 | 잠금 진입 있음 | 이번 출시 포함(프리미엄 해금) | `allowTensions`, tension 선택값은 entitlement 상실 시 정리 |
| Smart Generator 고급 제어 | 구현 완료 | 프리미엄 해금 후 노출 | 이번 출시 포함(프리미엄 해금) | `modulationIntensity`, `jazzPreset`, `sourceProfile` |
| Analyzer 기본 분석 | 구현 완료 | 있음 | 이번 출시 포함 | 보조 진입 유지, confidence/ambiguity/warning 유지 |
| Analyzer display settings | 구현 완료 | 있음 | 이번 출시 포함 | 결과 표시 조정만 제공 |
| Analyzer variation 생성 | 구현 완료 | 없음 | 코드/데이터 유지, UI 비노출 | `kEnableAdvancedAnalyzerActions=false` 유지 |
| 저장 제한 / 히스토리 제한 / 프리셋 제한 | 부분 흔적만 존재 | 사용자 약속 없음 | 이번 출시 제외 | 경계가 커서 이번 릴리즈에서는 과금 보류 |
| export 계열 기능 | 사용자 기능으로 미완성 | 없음 | 이번 출시 제외 | 유료 홍보 금지 |
| Study Harmony 허브 / 세션 | 구현 완료 | 없음 | 코드/데이터 유지, UI 비노출 | 사용자 라우팅 없음 |
| Study Harmony core/pop/jazz/classical track | 구현 완료 | 없음 | 코드/데이터 유지, UI 비노출 | 이번 릴리즈 사용자 약속에서 제외 |
| Study Harmony reward/shop/league/quest chest | 구현 완료 | 없음 | 코드/데이터 유지, UI 비노출 | 로컬 메타 데이터만 유지 |
| Study Harmony progress repository | 구현 완료 | 내부만 사용 | 코드/데이터 유지, UI 비노출 | 기존 사용자 데이터 보존 목적 |
| Study Harmony 추가 트랙 | 코드와 콘텐츠 존재 | 없음 | 향후 프리미엄 후보 | 향후 재노출 시 가치 팩 후보 |
| Study Harmony 상점 자산 / cosmetic | 코드와 데이터 존재 | 없음 | 향후 프리미엄 후보 | 실제 결제 연결 전까지 사용자 비노출 |

## 무료 기능 요약

- `Chordest` 기본 생성/연습 루프
- 기본 코드 표기, inversion, slash bass
- 메트로놈과 커스텀 메트로놈 사운드
- setup assistant, 언어, 테마, 일반 설정
- `Analyzer` 기본 분석과 warning/confidence 표시

## 프리미엄 해금 기능 요약

- Smart Generator mode
- 비다이아토닉 화성 색채 옵션
- 고급 tension 허용
- Smart Generator 고급 제어

## 보류 및 비노출 원칙

- 저장 제한은 구조 리스크가 커서 이번 릴리즈에서는 적용하지 않는다.
- `Analyzer` 고급 variation 액션은 유료화하지 않고 계속 비노출한다.
- `Study Harmony`는 데이터와 코드만 유지하고, 이번 릴리즈 사용자 경로에서는 계속 숨긴다.

## 빌드 타입 차이

- `debug / profile / release` 의 기능 경계는 동일하다.
- 실제 앱 부트스트랩은 `BillingController.live()` 를 사용한다.
- 테스트/프리뷰에서 `MyApp` 을 직접 만들면 기본값은 `BillingController.noop()` 이므로 스토어 없이도 안전하게 동작한다.
- 숨김 기능은 아래 `dart-define` 를 명시적으로 켜지 않는 한 다시 노출되지 않는다.
  - `ENABLE_STUDY_HARMONY_ENTRY_POINTS=true`
  - `ENABLE_ADVANCED_ANALYZER_ACTIONS=true`

## 작업 가정

- 이번 Android 출시에서 사용자가 돈을 내는 대상은 `premium_unlock` 1종뿐이라고 가정했다.
- 프리미엄 해금은 앱 정체성을 해치지 않는 범위에서만 적용하고, 무료 핵심 루프는 유지한다.
- `Study Harmony`는 향후 프리미엄 후보로만 문서화하고 현재 사용자에게는 전혀 노출하지 않는다.
