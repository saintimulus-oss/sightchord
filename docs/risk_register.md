# 릴리즈 리스크 레지스터

기준일: 2026-03-25

## TOP 10

| 우선순위 | 리스크 | 영향 | 빠른 수정 가능 | 이번 주 권장 조치 |
| --- | --- | --- | --- | --- |
| blocker | 영구 Android upload keystore와 Play App Signing 운영이 아직 외부에서 확정되지 않음 | 실제 제출 불가 | 아니오 | 콘솔/비밀관리 즉시 확정 |
| high | 메인 메뉴/소개/스토어 카피에 `Study Harmony` 흔적이 남아 있어 현재 비노출 전략과 충돌 | 사용자 혼란, 범위 과장 | 예 | 메인 메뉴와 스토어 문구 정리 |
| high | 실기기 Android QA 증거가 저장소에 없음 | 출시 후 실사용 회귀 가능성 | 예 | 휴대폰/태블릿 smoke QA 수행 |
| high | 프로덕션 crash telemetry 부재 | 출시 후 장애 탐지 지연 | 부분적 | 이번 주엔 최소 QA 강화, telemetry 도입은 후속 |
| high | 스토어/브랜드 메시지가 `Chordest` 단일 주인공 구조로 아직 잠기지 않음 | 제품 포지셔닝 흔들림 | 예 | 출시 범위 문구 잠금 |
| medium | `Chordest` 현재 세션은 앱 재시작/프로세스 종료 후 복원되지 않음 | 사용 흐름 중단 | 부분적 | 이번 주엔 알려진 한계로 관리, 구조 개편은 보류 |
| medium | 다국어 번역에 영어 잔존과 하드코딩 문자열이 남아 있음 | 사용자 노출 품질 저하 | 예 | 핵심 화면 우선 정리 |
| medium | Analyzer 결과는 ambiguity/unresolved 상황이 있어 과장 마케팅 시 신뢰 리스크 | 잘못된 기대 형성 | 예 | secondary tool 포지셔닝 유지 |
| medium | AAB 크기 154.9MB, 피아노 샘플 자산 비중 큼 | 다운로드/설치 체감 저하 | 아니오 | 이번 주는 유지, 향후 자산 전략 검토 |
| low | `tool/validate_mobile_release.ps1` 임시 서명키 재생성 실패가 있었음 | 로컬 검증 반복성 저하 | 예, 완료 | 임시 keystore 삭제 로직 추가 완료 |

## 상세 분류

### Blocker

- 영구 Android 서명/콘솔 작업
  - 저장소에서는 임시 키로 릴리즈 빌드가 가능했지만, 실제 업로드용 영구 keystore는 아직 없다.
  - 코드 이슈가 아니라 운영 이슈다.

### High

- `Study Harmony` 비노출 전략과 사용자 문구 불일치
- 실기기 QA 미실시
- 크래시 가시성 부족
- 출시 서사 미정렬

### Medium

- 세션 복원 공백
- 국제화 완성도 불균일
- Analyzer 신뢰도 표현 관리 필요
- 번들 크기

### Low

- 로컬 검증 스크립트 반복 실행성

## 빠른 수정 가능 항목

- `lib/main_menu_page.dart` 소개 문구 수정
- `lib/l10n/app_*.arb` 핵심 번역 정리
- `store/google-play/**`, `store/app-store/**` 출시 카피 정렬
- 실기기 QA 체크리스트 실행
- 메인 메뉴 / 스토어에서 `Analyzer` 포지셔닝 보수화

## 이번 주 안에 손대지 말아야 할 구조 문제

- 라우팅 프레임워크 교체
- 상태관리 전면 교체
- `Study Harmony` 전체 공개를 위한 구조 재배선
- 결제/계정/동기화 신규 도입
- 오디오 엔진 대수술

## 리스크 오너 후보

- 제품 범위/카피: `lib/main_menu_page.dart`, `store/**`
- Android 운영: `android/**`, Play Console
- 국제화: `lib/l10n/**`, `lib/practice_home_page_ui.dart`
- QA: `docs/device-qa-matrix.md`, 실기기 검증
