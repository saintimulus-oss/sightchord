# 릴리즈 감사 보고서

기준일: 2026-03-25

## 문서 역할

- 이 문서는 현재 저장소를 기준으로 한 기술/제품 감사 근거 문서다.
- 최종 출시 판단은 `docs/release_readiness.md` 와 `docs/final_release_summary.md` 를 우선한다.

## 1. 기술 스택과 주요 엔트리포인트

- 앱 유형: Flutter 단일 앱
- 런처 체인: `lib/main.dart` -> `lib/app_bootstrap.dart` -> `lib/app_shell.dart`
- 앱 시작 시 로드:
  - `AppSettingsController`
  - `StudyHarmonyProgressController`
- 실제 앱 홈: `MainMenuPage`
- 상태관리:
  - 전역 설정: `ChangeNotifier` 기반 `AppSettingsController`
  - `Study Harmony` 진행도: `ChangeNotifier` 기반 `StudyHarmonyProgressController`
  - Chordest / Analyzer 대부분: `StatefulWidget` 로컬 상태
- 라우팅:
  - `Navigator.of(context).push(MaterialPageRoute(...))`
  - `routes`, `onGenerateRoute`, `GoRouter`, 딥링크 없음
- 로컬 저장/캐시:
  - 설정: `shared_preferences`
  - `Study Harmony` 진행도: `shared_preferences` + primary/backup/lastKnownGood/shadow/legacy 복구
  - 메트로놈 커스텀 파일: `file_selector` + `path_provider`
  - 네트워크/백엔드/계정 없음
- 결제 스택:
  - `in_app_purchase`
  - `in_app_purchase_android`
  - `BillingController` + `BillingScope` + `SharedPreferences` 캐시 기반 entitlement 구조
  - `Study Harmony` 내부 로컬 가상경제/상점/보상 개념은 계속 별도 유지
- 분석/테스트 명령:
  - `flutter analyze`
  - `flutter test`
  - `python tool/mobile_launch_audit.py`
  - `python tool/validate_store_metadata.py`
  - `python tool/validate_store_locale_coverage.py`
  - `powershell -ExecutionPolicy Bypass -File tool/validate_mobile_release.ps1 -UseTemporarySigningKey`

## 2. 실제 사용자 노출 기능 목록

### 현재 실제 화면 기준

- 메인 메뉴
  - `Chordest` 진입 버튼
  - `Analyzer` 진입 버튼
  - 메인 설정 sheet: 언어 / 테마
  - 프리미엄 카드 / paywall / 구매 복원
- Chordest
  - 코드 생성/연습 플로우
  - 메트로놈, BPM, autoplay
  - 키 중심/표기/보이싱/멜로디 관련 설정
  - 설정 drawer
  - setup assistant
  - advanced settings
  - 커스텀 메트로놈 사운드 파일 선택
  - Smart Generator 및 고급 화성 옵션의 프리미엄 잠금 경계
- Analyzer
  - 진행 입력 편집기
  - 예제 progression
  - key candidates / confidence / ambiguity
  - warnings / unresolved 안내
  - measure-by-measure 분석
  - progression audio playback
  - variations 생성
  - display settings

### 숨겨진 실험/비노출 기능

- `StudyHarmonyPage`
- `StudyHarmonySessionPage`
- core/pop/jazz/classical track 허브
- daily/review/focus/relay/legend/boss rush
- reward/shop/league/quest chest/monthly tour/duet pact

### 미완성 또는 출시 비권장 기능

- 실제 인앱결제/restore/entitlement
- 계정 연동/진행 동기화
- 실사용 deep link
- 사용자 검색/공유/최근 항목 진입
- `Study Harmony`를 메인 사용자 여정에 배선하는 작업

## 3. 출시 범위 판단

- 이번 출시 포함:
  - `Chordest` 전체 핵심 플로우
  - `premium_unlock` 1회 구매형 paywall / restore / entitlement
  - Smart Generator 및 고급 화성 옵션의 프리미엄 해금
  - 설정 / setup assistant / advanced settings
  - `Analyzer` 보조 진입
  - 로컬 저장, 오디오, 다국어 기본 지원
- 이번 출시 제외:
  - `Study Harmony` 허브/세션 전체
  - 구독
  - 서버 검증/계정 동기화형 entitlement
  - 저장 제한 / export 기반 과금
  - deep link / search / share / recent 같은 미구현 진입
- 코드/데이터 유지하되 UI 비노출:
  - `lib/study_harmony/**`
  - `StudyHarmonyProgressController` 로드와 저장소
  - reward/shop/league 관련 데이터
- 향후 프리미엄 후보:
  - `Study Harmony` 추가 트랙
  - `Study Harmony` 내 title/cosmetic/shop 자산

## 4. Study Harmony 경로 식별

### 홈/탭/카드/드로어/더보기

- 메인 메뉴 직접 진입: 없음
- 탭/바텀 네비게이션: 없음
- Chordest 설정 drawer:
  - `onOpenStudyHarmony` 가 있을 때만 CTA 가능
  - 현재 `MainMenuPage` 에서 callback 미주입
- setup assistant:
  - `preview.recommendsStudyHarmony && onOpenStudyHarmony != null` 일 때만 카드 표시

### 설정/온보딩/툴팁/배너

- beginner 성향일 때 settings drawer / setup assistant 내부 카드로만 노출 가능하도록 설계됨
- 현재 배선상 실사용에서는 사실상 비노출

### route / deeplink

- 클래스:
  - `StudyHarmonyPage`
  - `StudyHarmonySessionPage`
- 앱 라우트/딥링크/intent-filter: 없음

### 검색/최근 항목/실험 플래그

- 검색 UI 없음
- 최근 항목 사용자 진입 없음
- 내부 최근 상태:
  - `lastPlayedTrackId` 저장
- 숨김 제어성 조건:
  - `onOpenStudyHarmony` optional callback
  - `recommendsStudyHarmony`

### 데이터 모델/저장소/마이그레이션/파서/캐시

- 데이터/도메인: `lib/study_harmony/domain/**`
- 앱 컨트롤러: `lib/study_harmony/application/**`
- 저장소/마이그레이션/키/스토어:
  - `lib/study_harmony/data/study_harmony_progress_repository.dart`
  - `lib/study_harmony/data/study_harmony_progress_migrator.dart`
  - `lib/study_harmony/data/study_harmony_progress_storage_keys.dart`
  - `lib/study_harmony/data/study_harmony_progress_store.dart`
- 콘텐츠/트랙/커리큘럼:
  - `lib/study_harmony/content/**`
- 메타/보상/경제:
  - `lib/study_harmony/meta/**`
- UI 컴포넌트:
  - `lib/study_harmony/ui/**`

## 5. Analyzer 평가

- 안정성 평가는 “보조 공개 가능” 수준이다.
- 근거:
  - widget / parser / semantics 테스트가 넓다.
  - low confidence banner가 있다.
  - ambiguity, alternative key, unresolved warning 노출이 있다.
  - 문서상 semantics가 “conservative heuristics” 중심이다.
- 신뢰 가능한 범위:
  - 코드 진행의 보조 해설
  - key/function 후보 비교
  - ambiguity 경고를 포함한 학습 보조
- 주의점:
  - 절대 정답 엔진처럼 마케팅하면 안 된다.
  - low confidence / ambiguity / unresolved 상태를 숨기면 안 된다.
  - 메인 히어로 기능이 아니라 secondary tool 로 유지하는 편이 안전하다.
- 최소 공개 범위 권장:
  - 현재 메인 메뉴 2차 CTA 유지
  - display settings / warnings / key candidates 유지
  - 스토어/메인 소개 카피에서 과장 표현 제거

## 6. Android 릴리즈 상태

- 확인된 값:
  - `minSdkVersion=24`
  - `targetSdkVersion=36`
  - `versionCode=1`
  - `versionName=1.0.0`
- 릴리즈 AAB 생성 성공:
  - `build/app/outputs/bundle/release/app-release.aab`
  - 크기: 154,896,818 bytes
- AndroidManifest:
  - 런처 activity 1개
  - dangerous permission 없음
  - deeplink 없음
- 외부 운영 이슈:
  - 영구 upload keystore 미구성
  - Play Console / Play App Signing / 실기기 QA는 저장소 밖 작업

## 7. 빠른 수정 가능 항목 vs 보류 항목

### 빠른 수정 가능

- 메인 메뉴 소개 문구에서 `Study Harmony` 언급 제거
- 스토어 메타데이터를 `Chordest` 중심으로 정렬
- 다국어 핵심 화면 번역 누락 정리
- `Analyzer`의 보조 도구 포지셔닝 강화
- Play Console 의 `premium_unlock` 상품 생성과 내부 테스트 트랙 검증

### 보류 항목

- `Study Harmony` 재노출
- 구독 / 서버 검증 / 계정 동기화형 결제 구조
- 저장 제한 / export 기반 과금
- 계정/클라우드 동기화
- 라우팅 개편
- 상태관리 교체

## 8. 다음 단계 수정 후보 경로

- `lib/main_menu_page.dart`
- `lib/main_menu/main_menu_view.dart`
- `lib/l10n/app_*.arb`
- `lib/practice_home_page_ui.dart`
- `store/google-play/**`
- `store/app-store/**`
- `test/widget_test.dart`
- `test/localization_test.dart`

## 9. 작업 가정

- 이번 Android 출시의 주인공은 `Chordest` 라는 제품 전략을 그대로 적용했다.
- `Study Harmony`는 코드 품질과 테스트 양과 별개로, 현재 배선 기준에서는 비노출 기능으로 분류했다.
- `Analyzer`는 숨겨야 할 수준의 불안정보다 “보조 도구로는 충분히 공개 가능” 쪽에 가깝다고 판단했다.
