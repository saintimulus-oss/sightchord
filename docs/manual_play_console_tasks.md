# Play Console 수동 작업

기준일: 2026-03-25

## 문서 역할

- 이 문서는 사람이 Play Console 에서 직접 해야 하는 작업의 source of truth 다.
- 가격/과금 정책은 `docs/monetization_plan.md`, 최종 readiness 상태는 `docs/release_readiness.md` 를 우선 참고한다.

## 1. 인앱 상품 생성

- 상품 유형: managed product, 1회 구매형
- 상품 ID: `premium_unlock`
- 앱 내 표기 권장명: `Chordest Premium`
- 권장 가격
  - 정가: 8,900원
  - 출시 초기 프로모션: 6,500원
- 상품 설명에는 실제 구현된 범위만 넣는다.
  - 포함: Smart Generator, 고급 화성 옵션, 고급 Smart Generator 제어
  - 제외: Study Harmony, 미구현 export, 서버 기반 동기화, 구독

## 2. 테스트 계정 / 라이선스 테스터 / 테스트 트랙

- Play Console 의 라이선스 테스터 계정을 등록한다.
- `internal testing` 트랙에 현재 release AAB 를 올린다.
- 실제 구매 / 취소 / 보류 / 복원 / 환불은 내부 테스트 계정으로 확인한다.
- 내부 테스트 통과 후 `closed testing` 으로 확대한다.

## 3. 서명 / 업로드 운영

- 영구 upload keystore 를 생성하고 안전한 위치에 보관한다.
- Play App Signing 설정을 완료한다.
- `android/key.properties` 또는 `ANDROID_KEYSTORE_*` 환경 변수로 release signing 을 연결한다.
- keystore 값은 저장소에 커밋하지 않는다.

## 4. Data safety / 개인정보 / 앱 접근 정보

사람이 Play Console 에서 최종 검토 후 입력해야 한다.

- Data safety form
  - 로컬 설정 저장
  - billing entitlement cache 저장
  - 네트워크 사용 여부
  - 제3자 SDK 데이터 수집 여부
- 개인정보 처리방침 URL
- 앱 접근 정보
  - 로그인 필요 없음
  - 기본 기능은 cold start 직후 접근 가능
- App content
  - 광고 여부
  - 타깃 연령
  - 민감 콘텐츠 / 건강 / 금융 관련 여부
- 연락처 / 지원 이메일 / 개발자 정보

## 5. 스토어 리스트 / 브랜딩 확인

- 앱 이름이 `Chordest` 로 일관적인지 확인한다.
- 스크린샷 / 설명 / feature graphic 에 `Study Harmony` 가 다시 등장하지 않는지 확인한다.
- `Analyzer` 는 보조 기능으로 설명하고, 분석 정확도를 과장하지 않는다.
- 무료 vs premium 경계가 앱 내부 paywall 과 같은지 확인한다.
- `beta`, `coming soon`, `준비 중` 같은 문구가 남아 있지 않은지 확인한다.

## 6. 내부 테스트 -> 클로즈드 테스트 -> 프로덕션 전환 전 확인

### internal testing

- 첫 실행 crash 없음
- main menu / generator / analyzer 진입 가능
- premium paywall 진입 가능
- restore CTA 동작 확인

### closed testing

- phone / tablet 실기기 smoke
- locale 변경
- 오프라인 재진입
- 백그라운드 후 복귀
- 실제 구매 / 복원 / 보류 / 환불 확인

### production 직전

- 최종 스토어 스크린샷 교체
- Data safety / App content / 개인정보 정책 제출 완료
- `premium_unlock` 가 active 상태인지 확인
- 내부 테스트와 동일한 billing account 로 restore 가 실제 동작하는지 마지막 점검

## 7. 상품 정보가 없을 때 앱 동작

- 앱 전체는 정상 실행된다.
- 무료 기능은 계속 사용 가능하다.
- paywall 은 열리지만 구매 버튼은 상품 정보 기준으로 비활성 또는 미준비 상태가 된다.
- restore CTA 는 계속 노출된다.

## 8. 복원 / 실패 / 보류 / 환불 처리 정책

- 복원: startup sync, resume sync, 수동 `구매 복원` 모두 entitlement 재평가
- 실패: 무료 기능 차단 없음, 짧은 오류 문구만 노출
- 보류: premium 즉시 활성화하지 않고 pending 메시지만 노출
- 환불 / 권한 회수: 서버가 없으므로 다음 성공적인 owned purchase 조회 시 반영

## 9. 참고 링크

- One-time product lifecycle: <https://developer.android.com/google/play/billing/lifecycle/one-time>
- Upload Android App Bundle: <https://developer.android.com/studio/publish/upload-bundle>
- Developer requirements overview: <https://support.google.com/googleplay/android-developer/answer/9858738>
- Review timelines overview: <https://support.google.com/googleplay/android-developer/answer/9859751>
