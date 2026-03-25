# Smoke Test Checklist

기준일: 2026-03-25

## 1. 기본 진입

- [ ] 앱 설치 후 첫 실행 시 빈 화면 없이 `MainMenuPage` 가 열린다.
- [ ] 메인 메뉴에서 `Start Practice` 진입이 된다.
- [ ] 메인 메뉴에서 `Analyze Progression` 진입이 된다.
- [ ] 메인 메뉴 설정 sheet 가 열린다.
- [ ] 메인 메뉴 어디에도 `Study Harmony` 진입 버튼이 없다.

## 2. Generator 기본 루프

- [ ] 첫 진입 welcome card 가 보인다.
- [ ] 첫 코드가 비어 있지 않다.
- [ ] 현재/다음 코드 레이블이 선택한 locale 기준으로 보인다.
- [ ] 다음 코드로 이동해도 빈 카드 / 깨진 상태가 없다.
- [ ] 기본 metronome on/off 와 BPM 조절이 동작한다.

## 3. 설정 / locale / 재실행

- [ ] 언어를 `ko`, `en` 에서 바꿔도 앱 전체가 다시 그려진다.
- [ ] `zh` 선택이 가능하고 설정값이 재실행 후 유지된다.
- [ ] 앱을 종료 후 다시 실행해도 마지막 언어 / 테마 / 일반 설정이 유지된다.
- [ ] 백그라운드 후 복귀 시 화면이 초기화되거나 blank 되지 않는다.

## 4. Premium / 복원

- [ ] 메인 메뉴 설정에서 premium card 와 `구매 복원` 버튼이 보인다.
- [ ] store unavailable 상황에서도 무료 기능 사용은 계속 가능하다.
- [ ] product unavailable 상황에서 사용자용 오류 문구가 보인다.
- [ ] restore CTA 는 항상 노출된다.
- [ ] 구매 완료 후 premium entitlement 가 활성화된다.
- [ ] 앱 재실행 후 entitlement 가 유지된다.
- [ ] 오프라인 재진입 시 최근 확정 entitlement cache 로 premium 상태가 유지된다.
- [ ] refund / revoke 이후에는 다음 owned purchase 조회에서 premium 이 회수된다.

## 5. Analyzer

- [ ] 기본 분석 버튼이 동작한다.
- [ ] 빈 입력 / 파싱 실패 시 과장된 성공 문구가 보이지 않는다.
- [ ] confidence / ambiguity / warning UI 가 보인다.
- [ ] 고급 variation 액션은 기본 release 경로에서 보이지 않는다.

## 6. Study Harmony 봉인 확인

- [ ] 메인 메뉴, 설정, setup assistant, generator drawer 에 `Study Harmony` CTA 가 없다.
- [ ] 앱 검색 / 최근 화면 / 딥링크 복원으로 `Study Harmony` 가 다시 나오지 않는다.
- [ ] release 빌드에서 `ENABLE_STUDY_HARMONY_ENTRY_POINTS` 를 주입하지 않는다.

## 7. 기기 QA 권장 범위

- [ ] Android phone 1대 이상
- [ ] Android tablet 또는 large screen 1대 이상
- [ ] 온라인 / 오프라인 각각 1회 이상
- [ ] 내부 테스트 계정으로 billing restore 1회 이상
