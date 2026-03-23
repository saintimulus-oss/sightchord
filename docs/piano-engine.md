# Piano Engine

## Overview

Chordest now uses an optimized Salamander Grand Piano subset for harmony-study
playback. The shared audio layer lives under `lib/audio/` and is designed to
serve the generator, analyzer, and Study Harmony flows without coupling audio
logic to specific widgets.

## Optimized Library

Source library:

- `assets/piano/salamander/`

Generated app-ready library:

- `assets/piano/salamander_essential/`

Build command:

```bash
dart run tool/build_salamander_essential.dart
```

What the optimizer keeps:

- Note samples only
- Key range folded to `C2` through `C6`
- Four velocity layers: `1`, `5`, `10`, `16`
- Anchor samples at `C`, `D#`, `F#`, and `A` across the kept octaves, plus `C6`

What the optimizer removes:

- Samples below `C2` and above `C6`
- Unused velocity layers
- Release-trigger samples
- Pedal noise samples
- Sympathetic and harmonic resonance samples
- The retuned SFZ variant

Resulting footprint:

- Raw sample pool: `641` files, `712.2 MiB`
- Optimized pool: `68` files, `104.85 MiB`
- Reduction: `85.28%`

Reference files:

- `assets/piano/salamander_essential/manifest.json`
- `assets/piano/salamander_essential/stats.json`
- `assets/piano/salamander_essential/SalamanderGrandPiano-Essential.sfz`

## Harmony-Focused Tuning

The default playback profile is intentionally biased toward harmonic clarity:

- No release, pedal, or resonance layers, so complex chords stay clean
- Short release fade (`90 ms`) to avoid muddy overlaps
- Moderate velocity curve (`0.88`) to keep soft and medium dynamics usable
- Short arpeggio step (`120 ms`) and restrained chord hold defaults
- Preview voicings slightly emphasize `3rds`, `7ths`, and key color tones
- `5ths` are slightly de-emphasized so guide tones remain easy to hear

## Architecture

Main files:

- `lib/audio/instrument_library_registry.dart`
- `lib/audio/sampled_instrument_manifest.dart`
- `lib/audio/sampled_instrument_engine.dart`
- `lib/audio/harmony_preview_resolver.dart`
- `lib/audio/harmony_audio_service.dart`
- `lib/audio/chordest_audio_scope.dart`

Responsibilities:

- `instrument_library_registry.dart`: central registry for instrument bundles
- `sampled_instrument_manifest.dart`: parses the generated manifest and resolves
  samples by note and velocity
- `sampled_instrument_engine.dart`: low-level sampled instrument engine built on
  `audioplayers`
- `harmony_preview_resolver.dart`: converts chords, voicings, progressions, and
  study prompts into note clips
- `harmony_audio_service.dart`: app-facing reusable API for playback
- `chordest_audio_scope.dart`: exposes one shared service instance to the UI

## API Usage

Get the shared service from UI code:

```dart
final audio = ChordestAudioScope.maybeOf(context);
```

Play a generated chord:

```dart
await audio?.playGeneratedChord(
  generatedChord,
  voicing: selectedVoicing,
  pattern: HarmonyPlaybackPattern.block,
);
```

Play an analyzed progression:

```dart
await audio?.playProgressionAnalysis(
  analysis,
  pattern: HarmonyPlaybackPattern.arpeggio,
);
```

Play a Study Harmony prompt:

```dart
await audio?.playStudyPrompt(
  task,
  pattern: HarmonyPlaybackPattern.block,
);
```

Manual note preview for keyboard interactions:

```dart
final active = await audio?.noteOn(midiNote: 60, velocity: 88);
if (active != null) {
  await audio?.noteOff(active);
}
```

## Swapping Instruments

To replace the piano library or add another sampled instrument:

1. Generate a compatible manifest and sample folder.
2. Register a new `InstrumentLibraryDescriptor` in
   `lib/audio/instrument_library_registry.dart`.
3. Point `HarmonyAudioService` at that descriptor, or change the default
   registry selection.
4. Keep the manifest shape compatible with `SampledInstrumentManifest`.

No feature-level UI code should need to change as long as the shared service API
stays the same.

## Failure Handling

`HarmonyAudioService` degrades to a no-op if audio warm-up or playback fails.
This keeps the study UI functional in unsupported environments such as widget
tests or partial platform setups while still logging the failure once.
