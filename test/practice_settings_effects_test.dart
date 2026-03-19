import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/chord_anchor_loop.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_effects.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('queue-affecting smart settings changes trigger look-ahead refresh', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      allowV7sus4: false,
    );
    final next = previous.copyWith(allowV7sus4: true);

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isTrue,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isTrue,
    );
  });

  test('display-only changes do not refresh the smart chord look-ahead', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      showVoicingReasons: true,
    );
    final next = previous.copyWith(showVoicingReasons: false);

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isFalse,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isFalse,
    );
  });

  test(
    'changing chord quality filters refreshes the smart chord look-ahead',
    () {
      final previous = PracticeSettings(
        voicingSuggestionsEnabled: true,
        lookAheadDepth: 2,
      );
      final next = previous.copyWith(
        enabledChordQualities: {...previous.enabledChordQualities}
          ..remove(ChordQuality.major7),
      );

      expect(
        PracticeSettingsEffects.queueAffectingChanged(previous, next),
        isTrue,
      );
      expect(
        PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
        isTrue,
      );
    },
  );

  test('changing language guardrails refreshes the smart chord look-ahead', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      chordLanguageLevel: ChordLanguageLevel.fullExtensions,
      romanPoolPreset: RomanPoolPreset.expandedColor,
    );
    final next = previous.copyWith(
      chordLanguageLevel: ChordLanguageLevel.seventhChords,
      romanPoolPreset: RomanPoolPreset.coreDiatonic,
    );

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isTrue,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isTrue,
    );
  });

  test('look-ahead refresh is disabled when suggestions cannot use it', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
    );
    final next = previous.copyWith(
      voicingSuggestionsEnabled: false,
      allowTensions: !previous.allowTensions,
    );

    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isFalse,
    );
  });

  test(
    'meter and harmonic rhythm changes refresh the smart chord look-ahead',
    () {
      final previous = PracticeSettings(
        voicingSuggestionsEnabled: true,
        lookAheadDepth: 2,
      );
      final next = previous.copyWith(
        timeSignature: PracticeTimeSignature.threeFour,
        harmonicRhythmPreset: HarmonicRhythmPreset.phraseAwareJazz,
      );

      expect(
        PracticeSettingsEffects.queueAffectingChanged(previous, next),
        isTrue,
      );
      expect(
        PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
        isTrue,
      );
    },
  );

  test(
    'changing anchor loop settings refreshes the smart chord look-ahead',
    () {
      final previous = PracticeSettings(
        voicingSuggestionsEnabled: true,
        lookAheadDepth: 2,
      );
      final next = previous.copyWith(
        anchorLoop: const ChordAnchorLoop(
          cycleLengthBars: 4,
          slots: [
            ChordAnchorSlot(
              barOffset: 0,
              slotIndexWithinBar: 0,
              chordSymbol: 'Fm7',
              enabled: true,
            ),
          ],
        ),
      );

      expect(
        PracticeSettingsEffects.queueAffectingChanged(previous, next),
        isTrue,
      );
      expect(
        PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
        isTrue,
      );
    },
  );

  test('audio-only changes do not refresh the smart chord look-ahead', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
    );
    final next = previous.copyWith(
      autoPlayChordChanges: true,
      harmonyMasterVolume: 0.6,
      metronomePattern: const MetronomePatternSettings(
        preset: MetronomePatternPreset.meterAccent,
      ),
    );

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isFalse,
    );
    expect(
      PracticeSettingsEffects.shouldForceLookAheadRefresh(previous, next),
      isFalse,
    );
    expect(
      PracticeSettingsEffects.metronomeAudioChanged(previous, next),
      isTrue,
    );
    expect(PracticeSettingsEffects.harmonyAudioChanged(previous, next), isTrue);
  });

  test('sound profile selection only refreshes harmony audio effects', () {
    final previous = PracticeSettings(
      voicingSuggestionsEnabled: true,
      lookAheadDepth: 2,
      harmonySoundProfileSelection: HarmonySoundProfileSelection.trackAware,
    );
    final next = previous.copyWith(
      harmonySoundProfileSelection: HarmonySoundProfileSelection.pop,
    );

    expect(
      PracticeSettingsEffects.queueAffectingChanged(previous, next),
      isFalse,
    );
    expect(PracticeSettingsEffects.harmonyAudioChanged(previous, next), isTrue);
  });
}
