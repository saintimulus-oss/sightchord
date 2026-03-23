# Chordest Device QA Matrix

Use this matrix for the final real-device pass before store submission.

## Android Phone

- Install the signed release `.aab`-derived build
- Verify first launch succeeds
- Verify main menu navigation
- Verify Practice Generator audio playback
- Verify metronome sound selection
- Verify Chord Analyzer input and result rendering
- Verify settings persist after app restart
- Verify Korean and English locale switching
- Verify no clipped controls on a narrow display

## Android Tablet

- Verify main menu spacing and tap targets
- Verify generator layout does not overflow in portrait
- Verify generator layout does not overflow in landscape
- Verify analyzer results remain readable
- Verify Study Harmony surfaces fit without hidden controls

## iPhone

- Verify first launch succeeds from TestFlight build
- Verify audio playback and mute-switch expectations
- Verify Practice Generator and Smart Generator flows
- Verify Chord Analyzer sample progression flow
- Verify settings persistence after restart
- Verify privacy policy and support URLs in store metadata are reachable

## iPad

- Verify launch and orientation behavior
- Verify split-screen or large-width layout does not break core screens
- Verify analyzer and settings surfaces fit on tablet dimensions
- If the iPad experience is not polished enough, revisit whether iPad distribution should stay enabled for launch

## Go / No-Go Signals

- No crash on launch
- No silent audio regressions
- No broken navigation paths
- No untranslated high-visibility text in target launch locales
- No missing store URLs or review notes
