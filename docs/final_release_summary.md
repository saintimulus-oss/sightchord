# 최종 릴리즈 요약

기준일: 2026-03-25
현재 제품 상태: 1주 내 Android 출시 준비 중인 `Chordest`

## Source Of Truth

- 전체 handoff 시작점: `docs/release_status.md`
- 최종 범위 판단: `docs/release_scope_matrix.md`
- 기술/제품 근거: `docs/release_audit.md`
- 수익화 정책: `docs/monetization_plan.md`, `docs/premium_feature_matrix.md`
- Android readiness / 검증: `docs/release_readiness.md`
- Play Console 수동 작업: `docs/manual_play_console_tasks.md`
- 남은 리스크: `docs/known_issues.md`

## 이번 작업 전체에서 실제로 바뀐 내용

- 제품 포지셔닝을 `Chordest` 중심으로 재정렬했다.
- `Study Harmony` 는 코드와 데이터는 유지하되 release 사용자 경로에서 봉인했다.
- `Analyzer` 는 기본 분석만 남기고 고급 variation 액션은 기본 비노출로 유지했다.
- `premium_unlock` 1회 구매형 구조와 entitlement/restore/cache 흐름을 도입했다.
- startup blank screen 위험, billing cache load 실패 위험, locale 핵심 카피 혼합 문제를 줄였다.
- Android release hardening, QA 체크리스트, Play Console 수동 작업 문서를 정리했다.

## 출시 범위에 포함된 기능

- 메인 메뉴
- `Chordest` 기본 Generator 루프
- 기본 코드 정보 표기, inversion, slash bass
- 기본 metronome 및 custom sound
- setup assistant
- settings drawer / advanced settings
- `Analyzer` 기본 분석, confidence/ambiguity/warning
- premium paywall / restore / entitlement
- Smart Generator 및 고급 화성 제어의 프리미엄 해금

## 의도적으로 제외하거나 숨긴 기능

- `Study Harmony` 허브 / 세션 / 트랙 / 보상 / 상점 / 리그
- `Analyzer` variation 생성
- 구독
- 서버 기반 entitlement 검증
- 저장 제한 / export 기반 과금
- deep link / search / share / recent 같은 미구현 진입

## 무료 / 프리미엄 구분

### 무료

- 기본 `Chordest` 루프
- 기본 코드 표기 / inversion / slash bass
- metronome
- setup assistant
- 언어 / 테마 / 일반 설정
- 보수적 `Analyzer`

### 프리미엄

- Smart Generator mode
- `secondary dominant`, `substitute dominant`, `modal interchange`
- 고급 tension 허용
- `modulationIntensity`, `jazzPreset`, `sourceProfile`

## 권장 가격 전략

- 정가: 8,900원
- 출시 초기 프로모션: 6,500원
- 앱 내부 가격 문자열은 하드코딩하지 않고 Play 스토어 상품 가격을 사용한다.

## 테스트 결과 요약

- `flutter analyze`: 성공
- `flutter test`: 성공, 전체 637개 통과
- `powershell -ExecutionPolicy Bypass -File tool\validate_mobile_release.ps1 -UseTemporarySigningKey`: 성공
- mobile launch audit: `35/35`
- release AAB 빌드: 성공
- release web 빌드: 성공
- GitHub Pages 배포 대상 URL: `https://saintimulus-oss.github.io/`

## 남은 리스크와 우회 전략

| 리스크 | 수준 | 우회 전략 |
| --- | --- | --- |
| 영구 keystore / Play App Signing 미확정 | blocker | 운영 담당이 먼저 확정하고 release signing 으로 재빌드 |
| `premium_unlock` 미생성 | blocker | Play Console 상품 생성 후 internal track 에서 구매/복원 검증 |
| 실기기 billing QA 미완료 | high | internal testing 계정으로 구매/취소/보류/환불 순서대로 검증 |
| 실기기 smoke 증거 부족 | high | phone + tablet 각각 체크리스트 수행 후 캡처/기록 보관 |
| 비영어 locale 카피 완성도 미흡 | medium | 이번 주에는 핵심 경로만 유지하고, 나머지는 다음 릴리즈 과제로 분리 |
| process-death full restoration 부재 | medium | 이번 릴리즈에서는 cold start 재진입 기준으로 QA, 세션 복원 약속은 하지 않음 |
| 환불 반영 지연 가능성 | medium | 온라인 재실행 / resume / 수동 restore 로 entitlement 재동기화 안내 |

## 사람이 지금 당장 해야 할 다음 10개 액션

1. 영구 Android upload keystore 를 생성하고 보관한다.
2. Play App Signing 을 확정한다.
3. Play Console 에 `premium_unlock` 1회 구매형 상품을 만든다.
4. 상품 가격을 8,900원 / 초기 6,500원으로 입력한다.
5. 라이선스 테스터와 internal testing 트랙을 설정한다.
6. 현재 AAB 를 internal testing 에 업로드한다.
7. 실제 테스트 계정으로 구매 / 취소 / 보류 / 복원 / 환불을 검증한다.
8. phone / tablet 에서 `docs/smoke_test_checklist.md` 를 따라 실기기 QA 를 수행한다.
9. Data safety / App content / 개인정보 / 스토어 설명 / 스크린샷을 최종 입력한다.
10. `closed testing` 결과를 보고 production 전환 여부를 최종 결정한다.

## 한계

- 이번 릴리즈는 “안드로이드 출시 준비” 상태지, 바로 프로덕션 전환 가능한 운영 완료 상태는 아니다.
- 이번 단계에서는 scope creep 을 막기 위해 구조 개편, 서버 도입, 대규모 리팩터링을 하지 않았다.
