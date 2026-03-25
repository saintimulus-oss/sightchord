# Known Issues

기준일: 2026-03-25

## 문서 역할

- 이 문서는 이번 릴리즈에서 남겨 둔 blocker / high / medium / low 리스크의 source of truth 다.
- 실행 우선순위는 `docs/final_release_summary.md` 의 다음 10개 액션과 함께 본다.

## blocker

- 영구 Android upload keystore 와 Play App Signing 운영이 아직 확정되지 않았다.
- Play Console 에 `premium_unlock` 상품이 아직 생성 / 활성화되지 않았다.

## high

- 실제 Android phone / tablet 실기기 QA 증거가 부족하다.
- 내부 테스트 계정 기준 구매 / 복원 / 보류 / 환불 실검증이 남아 있다.
- Data safety / App content / 개인정보 / 앱 접근 정보 입력은 아직 사람 검토가 필요하다.

## medium

- `es` / `ja` / `zh` / `zh_Hans` locale 은 핵심 release 경로 일부를 보완했지만, paywall 과 고급 설정 전체가 아직 `ko/en` 수준으로 완성되지는 않았다.
- full process-death navigation restoration 은 아직 없다.
- 서버 없이 entitlement 를 관리하므로 환불 / 권한 회수는 다음 owned purchase 조회 시점에 반영된다.
- billing cache 는 오프라인 재진입용으로 유지되므로 새 기기 오프라인 진입에서는 최신 상태가 아닐 수 있다.

## low

- Study Harmony 관련 데이터 / 문자열 / 저장소 코드는 남아 있다. 현재 release 경로에서는 숨겨져 있지만, feature flag 를 잘못 주입하면 다시 노출될 수 있다.
- Analyzer 는 기본 분석은 안정적이지만, 사용자가 절대적인 정답 엔진으로 오해하지 않도록 스토어 카피를 계속 보수적으로 유지해야 한다.
