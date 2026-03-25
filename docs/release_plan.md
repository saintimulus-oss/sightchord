# Android 출시 수렴 계획

기준일: 2026-03-25  
대상: Android 1차 출시  
릴리즈 원칙: `Chordest` 중심, `Study Harmony` 기본 비노출, `Analyzer`는 보수적 2차 진입 유지

## 문서 역할

- 이 문서는 출시까지 남은 실행 계획과 우선순위를 다룬다.
- 최신 구현 상태와 범위 판단은 `docs/final_release_summary.md`, `docs/release_scope_matrix.md`, `docs/release_status.md` 를 우선한다.

## 현재 판단

- 저장소는 Flutter 단일 앱이며, 현재 실제 사용자 구조는 `Main Menu -> Chordest / Analyzer` 2축이다.
- `flutter analyze`, `flutter test`, `flutter build appbundle --release`, `flutter build web --release`가 모두 통과했다.
- Android 릴리즈 자체는 가능하지만, 이번 주 출시를 위해서는 코드 품질보다 범위 정리와 사용자 노출 일관성 정리가 더 중요하다.
- `Study Harmony`는 코드와 데이터가 매우 크지만 현재 메인 경로에 연결되지 않았으므로, 이번 출시에서는 숨김 상태를 공식 정책으로 고정하는 편이 맞다.
- 1회 구매형 `premium_unlock` 구조는 이번 단계에서 반영되었고, 남은 일은 Play Console 상품 생성과 실기기 구매 검증이다.

## 이번 주 목표

1. 출시 범위를 `Chordest` 중심으로 잠근다.
2. 사용자에게 보이는 문구와 스토어 설명에서 `Study Harmony` 노출 흔적을 걷어낸다.
3. `Analyzer`는 유지하되 보조 도구로 위치를 명확히 한다.
4. Android 서명/콘솔/실기기 QA를 마무리한다.

## 1주 실행안

### Day 1: 범위 잠금

- 메인 메뉴/앱 소개/스토어 카피에서 `Study Harmony`를 핵심 제품처럼 보이게 하는 문구를 제거한다.
- `Analyzer`는 “보조 분석 도구”로 유지하고, 메인 히어로는 `Chordest` 하나로 정리한다.
- 수정 후보:
  - `lib/main_menu_page.dart`
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_ko.arb`
  - `store/google-play/*`
  - `store/app-store/*`

### Day 2: 사용자 노출 일관성 정리

- 메인 메뉴 소개, 설정 보조 문구, 온보딩 카피를 `Chordest` 중심으로 맞춘다.
- `Study Harmony`로 오해될 수 있는 CTA, 도움말, 스토어 문구를 점검한다.
- Analyzer 과장 표현이 있으면 완화한다.

### Day 3: Android 실기기 QA

- 최소 1대의 휴대폰과 1대의 태블릿에서 다음을 확인한다.
  - 첫 실행
  - 설정 저장
  - 메트로놈/오디오 재생
  - Chordest 기본 탐색
  - Analyzer 입력/결과/오디오 재생
  - 백그라운드 복귀
- 이 단계에서 크래시 재현과 ANR 징후를 수집한다.

### Day 4: 국제화/문구 보강

- 비영어권 번역에 남아 있는 영어 문구와 하드코딩 문자열을 정리한다.
- 최소 기준:
  - 메인 메뉴
  - Chordest 핵심 플로우
  - Analyzer 핵심 플로우
  - 설정/온보딩
- 수정 후보:
  - `lib/practice_home_page_ui.dart`
  - `lib/l10n/app_es.arb`
  - `lib/l10n/app_ja.arb`
  - `lib/l10n/app_zh.arb`
  - `lib/l10n/app_zh_Hans.arb`

### Day 5: 출시 후보 빌드 고정

- 영구 Android upload keystore 적용
- `versionName`/`versionCode` 최종 확정
- Play Console 초안 입력
- `premium_unlock` 상품 생성, 가격 입력, 내부 테스트 계정 연결
- 실제 업로드 후보 AAB 생성
- 확인 후보:
  - `android/key.properties`
  - `android/local.properties` 또는 CI build args
  - `pubspec.yaml`

### Day 6-7: Go/No-Go

- 실기기 QA 이슈 triage
- 스토어 카피 최종 검수
- 제출 자료와 지원 URL 검수
- staged rollout 여부 결정

## 빠른 수정 우선순위

- 메인 메뉴/스토어 카피에서 `Study Harmony` 흔적 제거
- `Chordest` 주인공 전략에 맞게 소개 문구 정리
- 비영어권 핵심 화면 번역 누락 정리
- `premium_unlock` Play Console 상품 생성 및 내부 테스트 구매 확인
- 실기기 QA 수행
- 영구 서명/Play App Signing 설정

## 이번 주에 하지 말아야 할 일

- 상태관리 교체
- 라우팅 프레임워크 도입
- `Study Harmony` 전면 재배선
- 구독 도입
- 서버 검증/계정 동기화형 결제 확장
- 저장 제한 / export 과금 확장
- 대규모 폴더 재구성
- 오디오 엔진 구조 개편

## 다음 단계 수정 후보 파일

- `lib/main_menu_page.dart`
- `lib/main_menu/main_menu_view.dart`
- `lib/l10n/app_*.arb`
- `lib/practice_home_page_ui.dart`
- `store/google-play/*`
- `store/app-store/*`
- `test/widget_test.dart`
- `test/localization_test.dart`

## 작업 가정

- 현재 `versionCode=1`, `versionName=1.0.0`은 첫 Android 출시 후보라고 가정했다.
- `Study Harmony`는 데이터와 코드는 유지하되 이번 Android 출시의 핵심 사용자 여정에서는 제외한다고 가정했다.
- `Analyzer`는 테스트와 경고 UI가 충분해 완전 비노출 대상은 아니라고 판단했다. 다만 메인 제품 포지션은 부여하지 않는다.
