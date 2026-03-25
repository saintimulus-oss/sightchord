# 릴리즈 노트 (한국어)

기준일: 2026-03-25
대상 버전: Android 1차 출시 후보

## 요약

`Chordest` 를 중심으로 첫 Android 출시 범위를 정리했습니다. 기본 코드 생성과 연습 루프는 무료로 유지하고, Smart Generator 와 고급 화성 제어는 1회 구매형 `premium_unlock` 으로 분리했습니다.

## 주요 변경

- 메인 제품 구성을 `Chordest` + 보조 `Analyzer` 로 정리
- `Study Harmony` 사용자 경로 비노출 유지
- premium paywall / restore / entitlement 흐름 정리
- 첫 실행 안정성, startup preload, billing cache load 예외 완화
- locale 핵심 카피와 paywall 사용자용 문구 정리
- Android release readiness / QA / Play Console 문서 정리

## 무료로 계속 제공되는 기능

- 기본 `Chordest` Generator
- 기본 코드 표기, inversion, slash bass
- metronome 및 custom sound
- setup assistant, 언어, 테마, 일반 설정
- 기본 `Analyzer`

## 프리미엄으로 해금되는 기능

- Smart Generator
- 비다이아토닉 화성 옵션
- 고급 tension
- Smart Generator 고급 제어

## 이번 릴리즈에서 제외한 항목

- `Study Harmony` 허브 및 세션
- `Analyzer` variation 생성
- 구독
- 서버 기반 동기화 / entitlement 검증

## 알려진 운영 전제

- 실제 구매/복원 검증은 Play Console internal testing 에서 마무리해야 합니다.
- 영구 upload keystore 와 Play App Signing 설정이 끝나야 프로덕션 전환이 가능합니다.
