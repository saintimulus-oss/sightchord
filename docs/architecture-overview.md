# SightChord Architecture Overview

## 1. 개요

SightChord는 단일 Flutter app이다. 현재 핵심 앱 로직은 대부분 `lib/main.dart`에 모여 있고, smart progression planning만 `lib/smart_generator.dart`로 분리되어 있다.

앱은 하나의 practice screen을 중심으로 동작한다. 이 screen은 다음 세 가지 책임을 함께 가진다.

- chord generation
- metronome / autoplay control
- settings UI 및 state 관리

## 2. Project Directory Structure

```text
lib/
  main.dart                 # 앱 UI, 상태, chord rendering/generation, metronome 제어
  smart_generator.dart      # Roman numeral transition planning, applied dominant/modulation logic

test/
  widget_test.dart          # 실제 practice UI 위젯 흐름 테스트
  chord_rendering_test.dart # tension / rendering / repeat guard 테스트
  smart_generator_test.dart # smart transition / applied dominant / modulation 테스트

assets/
  tick.mp3                  # metronome click asset

android/ ios/ linux/ macos/ windows/
  # Flutter platform runner / shell

web/
  # Flutter web shell 파일

.github/workflows/
  deploy-pages.yml          # GitHub Pages 배포 workflow
```

참고:

- 저장소 루트의 `main.dart.js`, `flutter.js`, `canvaskit/`, `build/` 등은 source logic가 아니라 web build/deploy 산출물에 가깝다.
- 앱의 실제 도메인 로직은 `lib/` 두 파일이 거의 전부 담당한다.

## 3. 주요 Class 및 역할

### `lib/main.dart`

- `GeneratedChord`
  - UI에 표시되는 최종 chord snapshot.
  - 실제 chord symbol, base chord, key, Roman numeral, harmonicFunction, applied dominant metadata, rendering metadata를 함께 보관한다.

- `ChordExclusionContext`
  - 직전 chord와 같은 symbol 또는 같은 harmonic identity를 피하기 위한 exclusion set 묶음이다.

- `ChordSymbolParts`
  - chord symbol을 root와 quality로 분해한 결과 모델이다.

- `ChordRenderingSelection`
  - surface variant, tensions, non-diatonic rendering 여부를 포함한 rendering 결정 결과다.

- `ChordRenderingHelper`
  - chord symbol parsing
  - tension profile 선택
  - V7sus4 surface variant 선택
  - rendered chord string 생성
  - repeat guard / harmonic comparison key 생성
  를 담당한다.

- `MyApp`
  - `MaterialApp` 진입점이다.

- `MyHomePage` / `_MyHomePageState`
  - 실제 practice screen.
  - chord queue, BPM, metronome, settings, Smart Generator state를 모두 보유한다.
  - chord generation entry point와 UI event handler가 여기에 모여 있다.

### `lib/smart_generator.dart`

- `WeightedNextRoman`
  - 다음 Roman numeral 후보와 weight를 묶는 모델이다.

- `QueuedSmartChord`
  - line cliche 같은 multi-step planned flow를 위한 queue item이다.

- `QueuedSmartChordDecision`
  - queue에서 현재 step 하나를 꺼낸 결과와 남은 queue를 함께 담는다.

- `SmartTransitionDebug`
  - weighted transition selection의 후보, roll, fallback reason을 기록한다.

- `SmartTransitionSelection`
  - transition 선택 결과와 debug 정보를 함께 담는다.

- `SmartApproachDecision`
  - diatonic destination으로 바로 갈지, secondary dominant / tritone substitute를 끼울지 결정한 결과다.

- `AppliedResolutionDecision`
  - applied dominant 이후 target으로 해결할지, 같은 key에서 계속 진행할지, modulation할지를 표현한다.

- `SmartGenerationDebug`
  - smart generation 전체 decision trace를 남기는 debug model이다.

- `SmartRenderingPlan`
  - planned chord kind, pattern tag, tension suppression 같은 rendering 관련 힌트를 담는다.

- `SmartStepRequest`
  - 현재 chord context, enabled options, modulation 후보, 이전 harmonic context를 묶은 planner 입력 모델이다.

- `SmartStepPlan`
  - planner가 반환하는 최종 next-step 계획이다.

- `SmartGeneratorHelper`
  - Smart Generator의 핵심 planner.
  - weighted diatonic transition, applied approach insertion, applied resolution, modulation candidate matching, line cliche queueing을 담당한다.

## 4. Chord Generation Logic 흐름

### 초기화

`_MyHomePageState.initState()`에서 두 가지를 수행한다.

- `_audioInitFuture = _initAudio()`
- `_ensureChordQueueInitialized()`

초기 queue는 `current`와 `next` chord를 미리 생성해 둔다.

### 공통 진입점

실제 chord 생성 진입점은 `_generateChord()`다.

이 함수는 현재 설정에 따라 세 갈래로 나뉜다.

1. Free mode
2. Key-aware random mode
3. Smart Generator mode

### Free mode

`_usesKeyMode == false`일 때 동작한다.

- `_allRoots`에서 root 선택
- `_randomSuffixes`에서 quality 선택
- `_buildFreeGeneratedChord()`로 metadata 구성
- `ChordExclusionContext`에 걸리면 다시 생성

즉, 12개 root와 suffix pool을 조합하는 단순 random mode다.

### Key-aware random mode

`_usesKeyMode == true`이고 `_smartGeneratorMode == false`일 때 동작한다.

- `_enabledRomanNumerals()`로 허용된 Roman numeral pool 구성
- `_buildKeyModeCandidates()`에서 `selected key x enabled Roman numeral` 후보를 전부 생성
- exclusion filter 적용
- `_pickUniformChord()`로 균등 random 선택

secondary dominant / substitute dominant가 켜져 있으면 pool에 해당 Roman numeral이 추가된다.

### Smart Generator mode

`_usesKeyMode == true`이고 `_smartGeneratorMode == true`일 때 동작한다.

흐름은 다음과 같다.

1. 현재 chord가 key-aware chord인지 검증
2. 현재 chord의 key / Roman numeral / harmonicFunction 추출
3. allowed diatonic Roman numeral 목록 계산
4. 현재 chord가 applied dominant면 modulation candidate key 계산
5. `SmartGeneratorHelper.planNextStep()` 호출
6. 반환된 `SmartStepPlan`으로 `_buildGeneratedChord()` 실행
7. exclusion에 걸리면 `_generateRandomDiatonicChord()`로 fallback

이 planner는 다음 규칙을 조합한다.

- `majorDiatonicTransitions` 기반 weighted next Roman selection
- destination 앞에 applied dominant 삽입 여부 결정
- applied dominant 이후 target resolution 또는 modulation 결정
- tonic resting / cadence arrival에서 line cliche queue 삽입

### Previous / Current / Next 흐름

practice UI는 `_previousChord`, `_currentChord`, `_nextChord` 3개 state를 유지한다.

- `Next Chord` 버튼 또는 space key
  - `_advanceChord()` 실행
  - `previous <- current`
  - `current <- next`
  - `next <- 새로 생성`

- autoplay
  - `_handleAutoTick()`가 beat를 갱신
  - bar 시작 beat에서 chord advance

## 5. Roman numeral -> chord 변환 구조

핵심 기준 테이블은 두 개다.

- `_baseRomanNumerals`
- `_diatonicChordMap`

`_baseRomanNumerals`의 index와 `_diatonicChordMap[key]`의 index가 서로 대응한다.

예:

- `IM7` -> index 0
- `V7` -> index 4
- `C` key에서는 index 4 -> `G7`

### diatonic chord 변환

`_resolveBaseChord(key, romanNumeral)`가 diatonic Roman numeral이면:

- `_baseRomanNumerals.indexOf(romanNumeral)` 계산
- `_diatonicChordMap[key]![index]` 반환

### applied dominant 변환

Roman numeral이 `V7/...` 또는 `subV7/...`면:

1. `_appliedResolutionMap`으로 target Roman numeral 계산
2. target chord root 추출
3. semitone 계산
4. secondary dominant면 `+7 semitone`
5. tritone substitute면 `+1 semitone`
6. `_spellPitchForKey()`로 key-aware spelling 결정
7. 최종적으로 `X7` 형태 반환

### planned chord kind 변환

`_resolvePlannedBaseChord()`는 일반 Roman resolution 외에 두 가지 tonic cliche surface를 만든다.

- `PlannedChordKind.tonicDominant7` -> tonic root + `7`
- `PlannedChordKind.tonicSix` -> tonic root + `6`

### 최종 렌더링

base chord가 정해지면 `ChordRenderingHelper`가 다음을 붙인다.

- `V7sus4` surface variant
- tension suffix

예:

- `G7` + `dominantSus4` + `['b9']`
- 최종 표시: `G7sus4(b9)`

## 6. UI Rendering 구조

화면 루트는 다음 구조다.

- `MaterialApp`
- `MyHomePage`
- `CallbackShortcuts`
- `Focus`
- `Scaffold`

### AppBar

- title: `SightChord`
- settings `IconButton`
- `endDrawer` 열기

### Body

main body는 single-screen practice layout이다.

- beat indicator row
- previous / current / next chord text
- 현재 상태 라벨
- practice summary card
- `Next Chord` button
- `Start Autoplay` / `Stop Autoplay` button
- BPM control row
- allowed range 안내 text

### Settings Drawer

drawer에는 기능별 설정이 모여 있다.

- metronome on/off
- metronome volume slider
- active keys FilterChip 목록
- Smart Generator Mode toggle
- Secondary Dominant / Substitute Dominant chip
- Allow V7sus4 chip
- Allow Tensions toggle
- tension option chips

대부분의 설정 변경은 `setState()` 후 `_reseedChordQueue()`를 호출해 즉시 다음 chord pool에 반영한다.

## 7. Settings 시스템 구조

설정은 별도 persistence layer 없이 `_MyHomePageState`의 field로만 관리된다.

주요 설정 state:

- `_metronomeEnabled`
- `_metronomeVolume`
- `_smartGeneratorMode`
- `_secondaryDominantEnabled`
- `_substituteDominantEnabled`
- `_allowV7sus4`
- `_allowTensions`
- `_selectedTensionOptions`
- `_activeKeys`
- `_bpmController`

파생 상태:

- `_usesKeyMode`
- `_orderedKeys`
- `_practiceModeTags`
- `_practiceModeDescription`

즉, 현재 architecture는 local in-memory UI state 기반이며, 앱 재시작 후 설정 복원 기능은 없다.

## 8. Metronome / Audio 시스템 구조

audio는 `audioplayers`의 `AudioPlayer` 한 인스턴스를 사용한다.

### 초기화

`_initAudio()`에서:

- `setReleaseMode(ReleaseMode.stop)`
- `setSource(AssetSource('tick.mp3'))`
- `setVolume(_metronomeVolume)`

을 호출해 metronome click asset을 준비한다.

### 재생

`_playMetronomeIfNeeded()`가 실제 click을 재생한다.

- metronome enabled 확인
- `_audioInitFuture` 완료 대기
- `_audioReady` 확인
- `stop()`
- `setVolume(_metronomeVolume)`
- `resume()`

### autoplay

autoplay는 `Timer.periodic` 기반이다.

- `_scheduleAutoTimer()`가 BPM으로 interval 계산
- 매 tick마다 `_handleAutoTickUnawaited()` 실행
- `_handleAutoTick()`가 beat를 한 칸 진행
- beat가 bar 시작이면 chord도 advance

### 정리

`dispose()`에서:

- `_autoTimer?.cancel()`
- `_bpmController.dispose()`
- `_audioPlayer.dispose()`

를 호출한다.

## 9. 상태 흐름(State Flow)

앱 state는 외부 state management package 없이 `_MyHomePageState` 내부에서 직접 흐른다.

### 1) 사용자 입력 -> local state 변경

- button tap
- keyboard shortcut
- settings toggle
- BPM 입력

모두 `setState()` 또는 direct field mutation 후 필요한 helper를 호출하는 구조다.

### 2) 설정 변경 -> chord queue 재시드

harmonic 결과에 영향을 주는 설정 변경 시:

- `_reseedChordQueue()`
- `previous/current/next` 초기화
- smart queue 초기화
- 새 `current`, `next` 생성

### 3) current chord context -> next chord planning

Smart Generator가 켜져 있으면 현재 chord metadata가 다음 planning 입력으로 사용된다.

- current key
- current Roman numeral
- current harmonicFunction
- previous chord function
- applied dominant 여부
- current pattern tag
- queued planned chords

### 4) planned queue -> rendered chord

line cliche가 시작되면 `_plannedSmartChordQueue`가 생기고, 이후 몇 step 동안 일반 transition 대신 queue가 우선된다.

### 5) rendered chord -> UI 표시

최종 `GeneratedChord`는 다음 표시 상태로 흘러간다.

- `_previousChord`
- `_currentChord`
- `_nextChord`

UI는 이 세 state를 그대로 읽어 text와 summary를 렌더링한다.

## 10. 테스트 구조

현재 테스트는 다음 세 층을 커버한다.

- rendering 규칙 테스트
  - tension filtering
  - V7sus4 / tension formatting
  - repeat guard / harmonic comparison key

- Smart Generator planner 테스트
  - weighted transition
  - applied dominant insertion
  - substitute dominant insertion
  - modulation
  - line cliche queue

- widget 테스트
  - main practice UI 렌더링
  - settings drawer 노출
  - tension chip 상태 유지
  - manual advance 동작

## 11. 요약

현재 구조는 "단일 screen + local state + helper-driven generation" 아키텍처다.

- UI와 application state는 `main.dart`에 집중되어 있다.
- harmonic planning은 `smart_generator.dart`로 분리되어 있다.
- Roman numeral 기반 diatonic/applied mapping은 table-driven 방식이다.
- settings persistence나 별도 repository/service layer는 아직 없다.

즉, 현재 프로젝트는 작은 규모의 Flutter practice app 구조로 유지되고 있고, 핵심 복잡도는 Smart Generator의 harmonic planning과 rendering metadata 조합에 집중되어 있다.
