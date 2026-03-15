import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chordest/audio/harmony_audio_models.dart';
import 'package:chordest/music/chord_anchor_loop.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_store.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'store saves ordered key-center, chord-quality, and tension collections',
    () async {
      const store = PracticeSettingsStore();
      final settings = PracticeSettings(
        appThemeMode: AppThemeMode.dark,
        guidedSetupCompleted: true,
        settingsComplexityMode: SettingsComplexityMode.standard,
        preferredSuggestionKind: DefaultVoicingSuggestionKind.colorful,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
        romanPoolPreset: RomanPoolPreset.functionalJazz,
        timeSignature: PracticeTimeSignature.threeFour,
        harmonicRhythmPreset: HarmonicRhythmPreset.phraseAwareJazz,
        metronomePattern: const MetronomePatternSettings(
          preset: MetronomePatternPreset.meterAccent,
        ),
        metronomeUseAccentSound: true,
        metronomeAccentSource: const MetronomeSourceSpec.builtIn(
          sound: MetronomeSound.tickE,
        ),
        autoPlayChordChanges: true,
        autoPlayPattern: HarmonyPlaybackPattern.arpeggio,
        autoPlayHoldFactor: 0.64,
        autoPlayMelodyWithChords: true,
        melodyGenerationEnabled: true,
        melodyDensity: MelodyDensity.active,
        motifRepetitionStrength: 0.8,
        approachToneDensity: 0.65,
        melodyRangeLow: 57,
        melodyRangeHigh: 81,
        melodyStyle: MelodyStyle.bebop,
        allowChromaticApproaches: true,
        melodyPlaybackMode: MelodyPlaybackMode.melodyOnly,
        harmonyMasterVolume: 0.72,
        harmonyPreviewHoldFactor: 1.2,
        harmonyArpeggioStepSpeed: 1.4,
        harmonyVelocityHumanization: 0.35,
        harmonyGainRandomness: 0.2,
        harmonyTimingHumanization: 0.25,
        voicingDisplayMode: VoicingDisplayMode.performance,
        progressionExplanationDetailLevel:
            ProgressionExplanationDetailLevel.advanced,
        progressionHighlightTheme: ProgressionHighlightTheme()
            .withPreset(ProgressionHighlightThemePreset.highContrast)
            .withColor(
              ProgressionHighlightCategory.modulation,
              const Color(0xFF102938),
            ),
        activeKeyCenters: {
          const KeyCenter(tonicName: 'G', mode: KeyMode.minor),
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
          const KeyCenter(tonicName: 'A', mode: KeyMode.major),
          const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
        },
        enabledChordQualities: {
          ChordQuality.dominant7sus4,
          ChordQuality.major7,
          ChordQuality.minorTriad,
          ChordQuality.dominant13sus4,
        },
        selectedTensionOptions: {'b13', '9', '#11'},
      );

      await store.save(settings);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('appThemeMode'), 'dark');
      expect(preferences.getBool('guidedSetupCompleted'), isTrue);
      expect(preferences.getString('settingsComplexityMode'), 'standard');
      expect(preferences.getString('preferredSuggestionKind'), 'colorful');
      expect(preferences.getString('chordLanguageLevel'), 'safeExtensions');
      expect(preferences.getString('romanPoolPreset'), 'functionalJazz');
      expect(preferences.getString('timeSignature'), 'threeFour');
      expect(preferences.getString('harmonicRhythmPreset'), 'phraseAwareJazz');
      expect(preferences.getString('metronomePattern'), isNotNull);
      expect(preferences.getBool('metronomeUseAccentSound'), isTrue);
      expect(preferences.getString('metronomeAccentSource'), isNotNull);
      expect(preferences.getBool('autoPlayChordChanges'), isTrue);
      expect(preferences.getString('autoPlayPattern'), 'arpeggio');
      expect(preferences.getDouble('autoPlayHoldFactor'), 0.64);
      expect(preferences.getBool('autoPlayMelodyWithChords'), isTrue);
      expect(preferences.getBool('melodyGenerationEnabled'), isTrue);
      expect(preferences.getString('melodyDensity'), 'active');
      expect(preferences.getDouble('motifRepetitionStrength'), 0.8);
      expect(preferences.getDouble('approachToneDensity'), 0.65);
      expect(preferences.getInt('melodyRangeLow'), 57);
      expect(preferences.getInt('melodyRangeHigh'), 81);
      expect(preferences.getString('melodyStyle'), 'bebop');
      expect(preferences.getBool('allowChromaticApproaches'), isTrue);
      expect(preferences.getString('melodyPlaybackMode'), 'melodyOnly');
      expect(preferences.getDouble('harmonyMasterVolume'), 0.72);
      expect(preferences.getDouble('harmonyPreviewHoldFactor'), 1.2);
      expect(preferences.getDouble('harmonyArpeggioStepSpeed'), 1.4);
      expect(
        preferences.getString('progressionExplanationDetailLevel'),
        'advanced',
      );
      expect(preferences.getString('progressionHighlightTheme'), isNotNull);
      expect(preferences.getString('voicingDisplayMode'), 'performance');
      expect(preferences.getStringList('activeKeys'), ['C', 'D', 'G', 'A']);
      expect(preferences.getStringList('activeKeyCenters'), [
        'C|major',
        'A|major',
        'D|minor',
        'G|minor',
      ]);
      expect(preferences.getStringList('enabledChordQualities'), [
        'minorTriad',
        'major7',
        'dominant13sus4',
        'dominant7sus4',
      ]);
      expect(preferences.getStringList('selectedTensions'), [
        '9',
        '#11',
        'b13',
      ]);
    },
  );

  test(
    'store falls back to current supported tensions on invalid storage',
    () async {
      SharedPreferences.setMockInitialValues({
        'selectedTensions': ['bogus'],
      });
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(
        selectedTensionOptions: {'9', '13'},
      );

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.selectedTensionOptions, {'9', '13'});
    },
  );

  test('store saves and restores anchor loop settings', () async {
    const store = PracticeSettingsStore();
    final settings = PracticeSettings(
      timeSignature: PracticeTimeSignature.fourFour,
      harmonicRhythmPreset: HarmonicRhythmPreset.twoPerBar,
      anchorLoop: const ChordAnchorLoop(
        cycleLengthBars: 5,
        varyNonAnchorSlots: false,
        slots: [
          ChordAnchorSlot(
            barOffset: 0,
            slotIndexWithinBar: 0,
            chordSymbol: 'Fm7',
            enabled: true,
          ),
          ChordAnchorSlot(
            barOffset: 4,
            slotIndexWithinBar: 1,
            chordSymbol: 'G7',
            enabled: false,
          ),
        ],
      ),
    );

    await store.save(settings);

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(loaded.anchorLoop, settings.anchorLoop.normalized());
  });

  test('store keeps fallback settings when storage keys are missing', () async {
    SharedPreferences.setMockInitialValues({'metronomeEnabled': false});
    const store = PracticeSettingsStore();
    final fallbackSettings = PracticeSettings(
      language: AppLanguage.ko,
      appThemeMode: AppThemeMode.light,
      guidedSetupCompleted: true,
      settingsComplexityMode: SettingsComplexityMode.advanced,
      preferredSuggestionKind: DefaultVoicingSuggestionKind.easy,
      chordLanguageLevel: ChordLanguageLevel.triadsOnly,
      romanPoolPreset: RomanPoolPreset.corePrimary,
      metronomeSound: MetronomeSound.tickF,
      metronomePattern: const MetronomePatternSettings(
        preset: MetronomePatternPreset.custom,
        customBeatStates: <MetronomeBeatState>[
          MetronomeBeatState.accent,
          MetronomeBeatState.mute,
        ],
      ),
      metronomeUseAccentSound: true,
      metronomeAccentSource: const MetronomeSourceSpec.localFile(
        localFilePath: 'C:/clicks/accent.wav',
        fallbackSound: MetronomeSound.tickE,
      ),
      autoPlayChordChanges: true,
      autoPlayPattern: HarmonyPlaybackPattern.arpeggio,
      autoPlayHoldFactor: 0.55,
      autoPlayMelodyWithChords: true,
      melodyGenerationEnabled: true,
      melodyDensity: MelodyDensity.sparse,
      motifRepetitionStrength: 0.75,
      approachToneDensity: 0.4,
      melodyRangeLow: 55,
      melodyRangeHigh: 79,
      melodyStyle: MelodyStyle.lyrical,
      allowChromaticApproaches: true,
      melodyPlaybackMode: MelodyPlaybackMode.both,
      progressionExplanationDetailLevel:
          ProgressionExplanationDetailLevel.detailed,
      progressionHighlightTheme: ProgressionHighlightTheme().withPreset(
        ProgressionHighlightThemePreset.colorBlindSafe,
      ),
      harmonyMasterVolume: 0.6,
      harmonyPreviewHoldFactor: 1.3,
      harmonyArpeggioStepSpeed: 1.1,
      harmonyVelocityHumanization: 0.45,
      harmonyGainRandomness: 0.3,
      harmonyTimingHumanization: 0.25,
      timeSignature: PracticeTimeSignature.twoFour,
      harmonicRhythmPreset: HarmonicRhythmPreset.cadenceCompression,
      activeKeyCenters: {
        const KeyCenter(tonicName: 'F', mode: KeyMode.major),
        const KeyCenter(tonicName: 'D', mode: KeyMode.minor),
      },
      selectedTensionOptions: {'9', '#11'},
      voicingDisplayMode: VoicingDisplayMode.performance,
      voicingTopNotePreference: VoicingTopNotePreference.bb,
    );

    final loaded = await store.load(fallbackSettings: fallbackSettings);

    expect(loaded.language, AppLanguage.ko);
    expect(loaded.appThemeMode, AppThemeMode.light);
    expect(loaded.metronomeEnabled, isFalse);
    expect(loaded.metronomeSound, MetronomeSound.tickF);
    expect(loaded.metronomePattern.preset, MetronomePatternPreset.custom);
    expect(loaded.metronomeUseAccentSound, isTrue);
    expect(loaded.metronomeAccentSource.kind, MetronomeSourceKind.localFile);
    expect(loaded.autoPlayChordChanges, isTrue);
    expect(loaded.autoPlayPattern, HarmonyPlaybackPattern.arpeggio);
    expect(loaded.autoPlayHoldFactor, 0.55);
    expect(loaded.autoPlayMelodyWithChords, isTrue);
    expect(loaded.melodyGenerationEnabled, isTrue);
    expect(loaded.melodyDensity, MelodyDensity.sparse);
    expect(loaded.motifRepetitionStrength, 0.75);
    expect(loaded.approachToneDensity, 0.4);
    expect(loaded.melodyRangeLow, 55);
    expect(loaded.melodyRangeHigh, 79);
    expect(loaded.melodyStyle, MelodyStyle.lyrical);
    expect(loaded.allowChromaticApproaches, isTrue);
    expect(loaded.melodyPlaybackMode, MelodyPlaybackMode.both);
    expect(
      loaded.progressionExplanationDetailLevel,
      ProgressionExplanationDetailLevel.detailed,
    );
    expect(
      loaded.progressionHighlightTheme.preset,
      ProgressionHighlightThemePreset.colorBlindSafe,
    );
    expect(loaded.harmonyMasterVolume, 0.6);
    expect(loaded.harmonyPreviewHoldFactor, 1.3);
    expect(loaded.harmonyArpeggioStepSpeed, 1.1);
    expect(loaded.harmonyVelocityHumanization, 0.45);
    expect(loaded.harmonyGainRandomness, 0.3);
    expect(loaded.harmonyTimingHumanization, 0.25);
    expect(loaded.guidedSetupCompleted, isTrue);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.advanced);
    expect(loaded.preferredSuggestionKind, DefaultVoicingSuggestionKind.easy);
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.triadsOnly);
    expect(loaded.romanPoolPreset, RomanPoolPreset.corePrimary);
    expect(loaded.timeSignature, PracticeTimeSignature.twoFour);
    expect(
      loaded.harmonicRhythmPreset,
      HarmonicRhythmPreset.cadenceCompression,
    );
    expect(loaded.activeKeyCenters, fallbackSettings.activeKeyCenters);
    expect(loaded.selectedTensionOptions, {'9', '#11'});
    expect(loaded.voicingDisplayMode, VoicingDisplayMode.performance);
    expect(loaded.voicingTopNotePreference, VoicingTopNotePreference.bb);
  });

  test('store saves and restores analyzer display settings', () async {
    const store = PracticeSettingsStore();
    final settings = PracticeSettings(
      progressionExplanationDetailLevel:
          ProgressionExplanationDetailLevel.advanced,
      progressionHighlightTheme: ProgressionHighlightTheme().withColor(
        ProgressionHighlightCategory.backdoor,
        const Color(0xFF1D4ED8),
      ),
    );

    await store.save(settings);

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(
      loaded.progressionExplanationDetailLevel,
      ProgressionExplanationDetailLevel.advanced,
    );
    expect(
      loaded.progressionHighlightTheme.preset,
      ProgressionHighlightThemePreset.custom,
    );
    expect(
      loaded.progressionHighlightTheme.colorValueFor(
        ProgressionHighlightCategory.backdoor,
      ),
      const Color(0xFF1D4ED8).toARGB32(),
    );
  });

  test(
    'store maps legacy activeKeys when activeKeyCenters are absent',
    () async {
      SharedPreferences.setMockInitialValues({
        'activeKeys': ['G', 'A', 'invalid-key'],
      });
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(
        activeKeyCenters: {
          const KeyCenter(tonicName: 'C', mode: KeyMode.major),
        },
      );

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.activeKeyCenters, {
        const KeyCenter(tonicName: 'G', mode: KeyMode.major),
        const KeyCenter(tonicName: 'A', mode: KeyMode.major),
      });
    },
  );

  test(
    'store derives sus chord filters from legacy allowV7sus4 when chord types are missing',
    () async {
      SharedPreferences.setMockInitialValues({'allowV7sus4': false});
      const store = PracticeSettingsStore();
      final fallbackSettings = PracticeSettings(allowV7sus4: true);

      final loaded = await store.load(fallbackSettings: fallbackSettings);

      expect(loaded.allowV7sus4, isFalse);
      expect(
        loaded.enabledChordQualities.any(
          MusicTheory.susDominantQualities.contains,
        ),
        isFalse,
      );
    },
  );

  test('store treats legacy saved settings as existing users', () async {
    SharedPreferences.setMockInitialValues({'metronomeEnabled': false});
    const store = PracticeSettingsStore();

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(loaded.guidedSetupCompleted, isTrue);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.standard);
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.fullExtensions);
    expect(loaded.romanPoolPreset, RomanPoolPreset.expandedColor);
  });

  test('store keeps onboarding incomplete on a clean install', () async {
    const store = PracticeSettingsStore();

    final loaded = await store.load(fallbackSettings: PracticeSettings());

    expect(loaded.guidedSetupCompleted, isFalse);
    expect(loaded.settingsComplexityMode, SettingsComplexityMode.guided);
    expect(
      loaded.preferredSuggestionKind,
      DefaultVoicingSuggestionKind.natural,
    );
    expect(loaded.chordLanguageLevel, ChordLanguageLevel.fullExtensions);
    expect(loaded.romanPoolPreset, RomanPoolPreset.expandedColor);
  });
}
