import 'dart:async';

import 'package:flutter/material.dart';

import '../audio/instrument_library_registry.dart';
import '../audio/harmony_audio_models.dart';
import '../billing/billing_scope.dart';
import '../billing/paywall_sheet.dart';
import '../billing/premium_feature_access.dart';
import '../l10n/app_localizations.dart';
import '../music/anchor_loop_layout.dart';
import '../music/anchor_loop_planner.dart';
import '../music/chord_anchor_loop.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import '../music/notation_presentation.dart';
import '../release_feature_flags.dart';
import '../ui/chordest_ui_tokens.dart';
import '../widgets/chord_input_editor.dart';
import 'metronome_custom_sound_service.dart';
import 'practice_settings_factory.dart';
import 'practice_settings.dart';
import 'practice_settings_dispatcher.dart';
import '../study_harmony/content/track_generation_profiles.dart';

class PracticeAdvancedSettingsPage extends StatefulWidget {
  const PracticeAdvancedSettingsPage({
    super.key,
    required this.settings,
    required this.onApplySettings,
    this.metronomeCustomSoundService,
  });

  final PracticeSettings settings;
  final ApplyPracticeSettings onApplySettings;
  final MetronomeCustomSoundService? metronomeCustomSoundService;

  @override
  State<PracticeAdvancedSettingsPage> createState() =>
      _PracticeAdvancedSettingsPageState();
}

enum _AdvancedSettingsCategory {
  rhythm,
  melody,
  metronome,
  sound,
  anchors,
  harmony,
  voicing,
}

class _PracticeAdvancedSettingsPageState
    extends State<PracticeAdvancedSettingsPage> {
  static const AnchorLoopPlanner _anchorLoopPlanner = AnchorLoopPlanner();

  late PracticeSettings _settings;
  var _selectedCategory = _AdvancedSettingsCategory.rhythm;
  final GlobalKey _autoPlayPatternFieldKey = GlobalKey();
  bool _primaryMetronomeUploadInProgress = false;
  bool _accentMetronomeUploadInProgress = false;
  late final MetronomeCustomSoundService _metronomeCustomSoundService =
      widget.metronomeCustomSoundService ?? createMetronomeCustomSoundService();

  bool get _usesKeyMode => _settings.usesKeyMode;
  List<HarmonySoundProfileSelection> get _visibleHarmonySoundProfiles =>
      kEnableStudyHarmonyEntryPoints
      ? HarmonySoundProfileSelection.values
      : HarmonySoundProfileSelection.values
            .where((value) => value != HarmonySoundProfileSelection.trackAware)
            .toList(growable: false);
  HarmonySoundProfileSelection get _selectedVisibleHarmonySoundProfile =>
      !kEnableStudyHarmonyEntryPoints &&
          _settings.harmonySoundProfileSelection ==
              HarmonySoundProfileSelection.trackAware
      ? HarmonySoundProfileSelection.neutral
      : _settings.harmonySoundProfileSelection;
  ChordAnchorLoop get _anchorLoop => AnchorLoopLayout.sanitizeLoop(
    loop: _settings.anchorLoop,
    timeSignature: _settings.timeSignature,
    harmonicRhythmPreset: _settings.harmonicRhythmPreset,
  );

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  void didUpdateWidget(covariant PracticeAdvancedSettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
  }

  void _applySettings(PracticeSettings nextSettings, {bool reseed = false}) {
    final requestedPremium = requestedPremiumFeatures(nextSettings);
    final resolvedSettings = sanitizePracticeSettingsForEntitlement(
      nextSettings,
      premiumUnlocked: _isPremiumUnlocked,
    );
    if (!_isPremiumUnlocked && requestedPremium.isNotEmpty) {
      unawaited(
        showPremiumPaywallSheet(
          context,
          highlightedFeature: requestedPremium.first,
        ),
      );
    }
    setState(() {
      _settings = resolvedSettings;
    });
    widget.onApplySettings(resolvedSettings, reseed: reseed);
  }

  void _applyAnchorLoop(ChordAnchorLoop nextLoop) {
    final sanitizedLoop = AnchorLoopLayout.sanitizeLoop(
      loop: nextLoop,
      timeSignature: _settings.timeSignature,
      harmonicRhythmPreset: _settings.harmonicRhythmPreset,
    );
    _applySettings(_settings.copyWith(anchorLoop: sanitizedLoop), reseed: true);
  }

  void _ensureVisibleAfterFrame(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (!mounted || context == null) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        alignment: 0.2,
      );
    });
  }

  List<_AnchorEditorSlotTiming> _anchorSlotTimingsForBar(int barOffset) {
    final changeBeats = AnchorLoopLayout.validChangeBeats(
      timeSignature: _settings.timeSignature,
      harmonicRhythmPreset: _settings.harmonicRhythmPreset,
    );
    return [
      for (var slotIndex = 0; slotIndex < changeBeats.length; slotIndex += 1)
        _AnchorEditorSlotTiming(
          barOffset: barOffset,
          slotIndexWithinBar: slotIndex,
          changeBeat: changeBeats[slotIndex],
        ),
    ];
  }

  List<MetronomeBeatState> get _customMetronomeBeatStates => _settings
      .metronomePattern
      .normalized(beatsPerBar: _settings.beatsPerBar)
      .customBeatStates;

  void _applyMetronomeSource(
    MetronomeSourceSpec source, {
    required bool accent,
  }) {
    _applySettings(
      accent
          ? _settings.copyWith(metronomeAccentSource: source)
          : _settings.copyWith(metronomeSource: source),
    );
  }

  Future<void> _uploadMetronomeSource({required bool accent}) async {
    if (_metronomeUploadInProgress(accent: accent)) {
      return;
    }
    _setMetronomeUploadInProgress(accent: accent, value: true);
    try {
      final selection = await _metronomeCustomSoundService.pickAndStore(
        slot: accent
            ? MetronomeCustomSoundSlot.accent
            : MetronomeCustomSoundSlot.primary,
        fallbackSound: accent
            ? _settings.metronomeAccentSound
            : _settings.metronomeSound,
      );
      if (!mounted || selection == null) {
        return;
      }
      _applyMetronomeSource(selection.source, accent: accent);
      _showMetronomeMessage(
        AppLocalizations.of(context)!.metronomeCustomSoundUploadSuccess,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMetronomeMessage(
        AppLocalizations.of(context)!.metronomeCustomSoundUploadError,
      );
    } finally {
      _setMetronomeUploadInProgress(accent: accent, value: false);
    }
  }

  Future<void> _resetMetronomeSource({required bool accent}) async {
    if (_metronomeUploadInProgress(accent: accent)) {
      return;
    }
    _setMetronomeUploadInProgress(accent: accent, value: true);
    try {
      await _metronomeCustomSoundService.clearSlot(
        slot: accent
            ? MetronomeCustomSoundSlot.accent
            : MetronomeCustomSoundSlot.primary,
      );
      if (!mounted) {
        return;
      }
      _applyMetronomeSource(
        MetronomeSourceSpec.builtIn(
          sound: accent
              ? _settings.metronomeAccentSound
              : _settings.metronomeSound,
        ),
        accent: accent,
      );
      _showMetronomeMessage(
        AppLocalizations.of(context)!.metronomeCustomSoundResetSuccess,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMetronomeMessage(
        AppLocalizations.of(context)!.metronomeCustomSoundUploadError,
      );
    } finally {
      _setMetronomeUploadInProgress(accent: accent, value: false);
    }
  }

  bool _metronomeUploadInProgress({required bool accent}) {
    return accent
        ? _accentMetronomeUploadInProgress
        : _primaryMetronomeUploadInProgress;
  }

  bool get _isPremiumUnlocked =>
      BillingScope.maybeOf(context)?.isPremiumUnlocked ?? false;

  void _setMetronomeUploadInProgress({
    required bool accent,
    required bool value,
  }) {
    if (!mounted) {
      return;
    }
    setState(() {
      if (accent) {
        _accentMetronomeUploadInProgress = value;
      } else {
        _primaryMetronomeUploadInProgress = value;
      }
    });
  }

  void _showMetronomeMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _applyCustomMetronomeBeatState(int beatIndex, MetronomeBeatState state) {
    final nextStates = <MetronomeBeatState>[..._customMetronomeBeatStates];
    nextStates[beatIndex] = state;
    _applySettings(
      _settings.copyWith(
        metronomePattern: _settings.metronomePattern.copyWith(
          preset: MetronomePatternPreset.custom,
          customBeatStates: nextStates,
        ),
      ),
    );
  }

  Future<void> _openAnchorSlotEditor(
    BuildContext context, {
    required _AnchorEditorSlotTiming timing,
  }) async {
    final existing = _anchorLoop.slotForPosition(
      barOffset: timing.barOffset,
      slotIndexWithinBar: timing.slotIndexWithinBar,
    );
    final result = await showModalBottomSheet<_AnchorSlotEditorResult>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _AnchorSlotEditorSheet(
          timing: timing,
          existingSlot: existing,
          planner: _anchorLoopPlanner,
        );
      },
    );

    if (!mounted) {
      return;
    }
    if (result == null) {
      return;
    }
    if (result.clear) {
      _applyAnchorLoop(
        _anchorLoop.withoutSlot(
          barOffset: timing.barOffset,
          slotIndexWithinBar: timing.slotIndexWithinBar,
        ),
      );
      return;
    }
    _applyAnchorLoop(
      _anchorLoop.withSlot(
        ChordAnchorSlot(
          barOffset: timing.barOffset,
          slotIndexWithinBar: timing.slotIndexWithinBar,
          chordSymbol: result.chordSymbol,
          enabled: result.enabled,
        ),
      ),
    );
  }

  void _toggleAnchorSlot(
    BuildContext context, {
    required _AnchorEditorSlotTiming timing,
    required bool selected,
  }) {
    final existing = _anchorLoop.slotForPosition(
      barOffset: timing.barOffset,
      slotIndexWithinBar: timing.slotIndexWithinBar,
    );
    if (existing == null || !existing.hasChordSymbol) {
      if (selected) {
        unawaited(_openAnchorSlotEditor(context, timing: timing));
      }
      return;
    }
    _applyAnchorLoop(
      _anchorLoop.withSlot(existing.copyWith(enabled: selected)),
    );
  }

  List<int> _melodyRangeOptions({required bool forHigh}) {
    final min = forHigh
        ? _settings.melodyRangeLow + PracticeSettings.minMelodyRangeSpan
        : PracticeSettings.minMelodyRangeMidi;
    final max = forHigh
        ? PracticeSettings.maxMelodyRangeMidi
        : _settings.melodyRangeHigh - PracticeSettings.minMelodyRangeSpan;
    return [for (var midi = min; midi <= max; midi += 1) midi];
  }

  String _melodyMidiLabel(int midi) {
    final note = MusicTheory.spellPitch(midi % 12, preferFlat: false);
    final octave = (midi ~/ 12) - 1;
    return '$note$octave';
  }

  String _keySelectionOptionLabel(KeySelectionOption option) {
    return option.displayTonicNames
        .map(
          (tonicName) => MusicNotationFormatter.formatPitch(
            MusicTheory.displayRootForKey(tonicName),
            preferences: _settings.notationPreferences,
          ),
        )
        .join('/');
  }

  String? _selectedTonicNameForKeyOption(KeySelectionOption option) {
    return MusicTheory.selectedTonicNameForOption(
      _settings.activeKeyCenters,
      option,
    );
  }

  void _toggleAdvancedKeySelection(KeySelectionOption option) {
    final selectedTonicName = _selectedTonicNameForKeyOption(option);
    final currentIndex = option.cycleTonicNames.indexOf(
      selectedTonicName ?? '',
    );
    final nextTonicName = currentIndex == -1
        ? option.cycleTonicNames.first
        : null;
    final nextCenters = MusicTheory.replaceKeyCenterSelection(
      _settings.activeKeyCenters,
      mode: option.mode,
      semitone: option.semitone,
      tonicName: nextTonicName,
    );
    _applySettings(
      _settings.copyWith(activeKeyCenters: nextCenters),
      reseed: true,
    );
  }

  String _categoryLabel(
    AppLocalizations l10n,
    _AdvancedSettingsCategory category,
  ) {
    return switch (category) {
      _AdvancedSettingsCategory.rhythm => l10n.practiceMeter,
      _AdvancedSettingsCategory.melody => l10n.melodyGenerationTitle,
      _AdvancedSettingsCategory.metronome => l10n.metronomePatternTitle,
      _AdvancedSettingsCategory.sound => l10n.harmonySoundTitle,
      _AdvancedSettingsCategory.anchors => l10n.anchorLoopTitle,
      _AdvancedSettingsCategory.harmony => l10n.smartGeneratorMode,
      _AdvancedSettingsCategory.voicing => l10n.voicingSuggestionsTitle,
    };
  }

  String _categoryDescription(
    AppLocalizations l10n,
    _AdvancedSettingsCategory category,
  ) {
    return switch (category) {
      _AdvancedSettingsCategory.rhythm => l10n.practiceMeterHelp,
      _AdvancedSettingsCategory.melody => l10n.melodyGenerationHelp,
      _AdvancedSettingsCategory.metronome => l10n.metronomePatternHelp,
      _AdvancedSettingsCategory.sound => l10n.harmonySoundProfileSelectionHelp,
      _AdvancedSettingsCategory.anchors => l10n.anchorLoopHelp,
      _AdvancedSettingsCategory.harmony => l10n.smartPracticeDescription,
      _AdvancedSettingsCategory.voicing => l10n.voicingSuggestionsHelp,
    };
  }

  IconData _categoryIcon(_AdvancedSettingsCategory category) {
    return switch (category) {
      _AdvancedSettingsCategory.rhythm => Icons.schedule_rounded,
      _AdvancedSettingsCategory.melody => Icons.music_note_rounded,
      _AdvancedSettingsCategory.metronome => Icons.timer_rounded,
      _AdvancedSettingsCategory.sound => Icons.graphic_eq_rounded,
      _AdvancedSettingsCategory.anchors => Icons.anchor_rounded,
      _AdvancedSettingsCategory.harmony => Icons.auto_awesome_rounded,
      _AdvancedSettingsCategory.voicing => Icons.piano_rounded,
    };
  }

  List<Widget> _buildCategoryPanelChildren({
    required _AdvancedSettingsCategory category,
    required AppLocalizations l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    return switch (category) {
      _AdvancedSettingsCategory.rhythm => _buildRhythmPanel(
        l10n: l10n,
        dispatcher: dispatcher,
      ),
      _AdvancedSettingsCategory.melody => _buildMelodyPanel(
        l10n: l10n,
        theme: theme,
        colorScheme: colorScheme,
        dispatcher: dispatcher,
      ),
      _AdvancedSettingsCategory.metronome => _buildMetronomePanel(
        l10n: l10n,
        dispatcher: dispatcher,
      ),
      _AdvancedSettingsCategory.sound => _buildSoundPanel(
        l10n: l10n,
        dispatcher: dispatcher,
      ),
      _AdvancedSettingsCategory.anchors => _buildAnchorPanel(
        l10n: l10n,
        theme: theme,
        colorScheme: colorScheme,
      ),
      _AdvancedSettingsCategory.harmony => _buildHarmonyPanel(
        l10n: l10n,
        theme: theme,
        colorScheme: colorScheme,
        dispatcher: dispatcher,
      ),
      _AdvancedSettingsCategory.voicing => _buildVoicingPanel(
        l10n: l10n,
        theme: theme,
        colorScheme: colorScheme,
        dispatcher: dispatcher,
      ),
    };
  }

  List<Widget> _buildRhythmPanel({
    required AppLocalizations l10n,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    return [
      _AdvancedSectionTitle(text: l10n.practiceMeter),
      DropdownButtonFormField<PracticeTimeSignature>(
        key: const ValueKey('practice-time-signature-dropdown'),
        initialValue: _settings.timeSignature,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.practiceMeter,
          helperText: l10n.practiceMeterHelp,
        ),
        items: PracticeTimeSignature.values
            .map(
              (value) => DropdownMenuItem<PracticeTimeSignature>(
                value: value,
                child: Text(value.localizedLabel(l10n)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(timeSignature: value),
            reseed: true,
          );
        },
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<HarmonicRhythmPreset>(
        key: const ValueKey('practice-harmonic-rhythm-dropdown'),
        initialValue: _settings.harmonicRhythmPreset,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.harmonicRhythm,
          helperText: l10n.harmonicRhythmHelp,
        ),
        items: HarmonicRhythmPreset.values
            .map(
              (value) => DropdownMenuItem<HarmonicRhythmPreset>(
                value: value,
                child: Text(value.localizedLabel(l10n)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(harmonicRhythmPreset: value),
            reseed: true,
          );
        },
      ),
      const SizedBox(height: 24),
      _AdvancedSectionTitle(text: l10n.transportAudioTitle),
      SwitchListTile.adaptive(
        key: const ValueKey('auto-play-chord-changes-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.autoPlayChordChanges),
        subtitle: Text(l10n.autoPlayChordChangesHelp),
        value: _settings.autoPlayChordChanges,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(autoPlayChordChanges: value),
          );
          if (value) {
            _ensureVisibleAfterFrame(_autoPlayPatternFieldKey);
          }
        },
      ),
      const SizedBox(height: 12),
      _AdvancedNestedGroup(
        enabled: _settings.autoPlayChordChanges,
        disabledMessage: l10n.autoPlayChordChangesHelp,
        children: [
          KeyedSubtree(
            key: _autoPlayPatternFieldKey,
            child: DropdownButtonFormField<HarmonyPlaybackPattern>(
              key: const ValueKey('auto-play-pattern-dropdown'),
              initialValue: _settings.autoPlayPattern,
              isExpanded: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.autoPlayPattern,
                helperText: l10n.autoPlayPatternHelp,
              ),
              items: HarmonyPlaybackPattern.values
                  .map(
                    (value) => DropdownMenuItem<HarmonyPlaybackPattern>(
                      value: value,
                      child: Text(value.localizedLabel(l10n)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                dispatcher.apply(
                  (current) => current.copyWith(autoPlayPattern: value),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _AdvancedSliderTile(
            title: l10n.autoPlayHoldFactor,
            subtitle: l10n.autoPlayHoldFactorHelp,
            value: _settings.autoPlayHoldFactor,
            min: PracticeSettings.minAutoPlayHoldFactor,
            max: PracticeSettings.maxAutoPlayHoldFactor,
            divisions: 12,
            valueLabel: _percentLabel(_settings.autoPlayHoldFactor),
            onChanged: (value) {
              dispatcher.apply(
                (current) => current.copyWith(autoPlayHoldFactor: value),
              );
            },
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            key: const ValueKey('auto-play-melody-toggle'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.autoPlayMelodyWithChords),
            subtitle: Text(l10n.autoPlayMelodyWithChordsPlaceholder),
            value: _settings.autoPlayMelodyWithChords,
            onChanged: (value) {
              dispatcher.apply(
                (current) => current.copyWith(autoPlayMelodyWithChords: value),
              );
            },
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildMelodyPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    final activeDescriptor =
        PracticeSettingsFactory.describeActiveMelodySettings(_settings);
    return [
      _AdvancedSectionTitle(text: l10n.melodyGenerationTitle),
      SwitchListTile.adaptive(
        key: const ValueKey('melody-generation-enabled-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.melodyGenerationTitle),
        subtitle: Text(l10n.melodyGenerationHelp),
        value: _settings.melodyGenerationEnabled,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(
              melodyGenerationEnabled: value,
              autoPlayMelodyWithChords: value
                  ? true
                  : current.autoPlayMelodyWithChords,
            ),
          );
        },
      ),
      if (_settings.melodyGenerationEnabled) ...[
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: ChordestUiTokens.innerPanelDecoration(theme),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.melodyCurrentLineFeelTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${activeDescriptor.label}: ${activeDescriptor.summary}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  activeDescriptor.differenceReason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<MelodyDensity>(
          key: const ValueKey('melody-density-dropdown'),
          initialValue: _settings.melodyDensity,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.melodyDensity,
            helperText: l10n.melodyDensityHelp,
          ),
          items: MelodyDensity.values
              .map(
                (value) => DropdownMenuItem<MelodyDensity>(
                  value: value,
                  child: Text(value.localizedLabel(l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(melodyDensity: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('motif-repetition-strength-slider'),
          title: l10n.motifRepetitionStrength,
          subtitle: l10n.motifRepetitionStrengthHelp,
          value: _settings.motifRepetitionStrength,
          min: PracticeSettings.minMelodyMotifStrength,
          max: PracticeSettings.maxMelodyMotifStrength,
          divisions: 10,
          valueLabel: _percentLabel(_settings.motifRepetitionStrength),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(motifRepetitionStrength: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('approach-tone-density-slider'),
          title: l10n.approachToneDensity,
          subtitle: l10n.approachToneDensityHelp,
          value: _settings.approachToneDensity,
          min: PracticeSettings.minMelodyApproachToneDensity,
          max: PracticeSettings.maxMelodyApproachToneDensity,
          divisions: 10,
          valueLabel: _percentLabel(_settings.approachToneDensity),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(approachToneDensity: value),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          l10n.melodyLinePersonalityTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.melodyLinePersonalityBody,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('syncopation-bias-slider'),
          title: l10n.melodySyncopationBiasTitle,
          subtitle: l10n.melodySyncopationBiasBody,
          value: _settings.syncopationBias,
          min: PracticeSettings.minMelodyBias,
          max: PracticeSettings.maxMelodyBias,
          divisions: 10,
          valueLabel: _percentLabel(_settings.syncopationBias),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(syncopationBias: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('color-realization-bias-slider'),
          title: l10n.melodyColorRealizationBiasTitle,
          subtitle: l10n.melodyColorRealizationBiasBody,
          value: _settings.colorRealizationBias,
          min: PracticeSettings.minMelodyBias,
          max: PracticeSettings.maxMelodyBias,
          divisions: 10,
          valueLabel: _percentLabel(_settings.colorRealizationBias),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(colorRealizationBias: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('novelty-target-slider'),
          title: l10n.melodyNoveltyTargetTitle,
          subtitle: l10n.melodyNoveltyTargetBody,
          value: _settings.noveltyTarget,
          min: PracticeSettings.minMelodyBias,
          max: PracticeSettings.maxMelodyBias,
          divisions: 10,
          valueLabel: _percentLabel(_settings.noveltyTarget),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(noveltyTarget: value),
            );
          },
        ),
        const SizedBox(height: 12),
        _AdvancedSliderTile(
          key: const ValueKey('motif-variation-bias-slider'),
          title: l10n.melodyMotifVariationBiasTitle,
          subtitle: l10n.melodyMotifVariationBiasBody,
          value: _settings.motifVariationBias,
          min: PracticeSettings.minMelodyBias,
          max: PracticeSettings.maxMelodyBias,
          divisions: 10,
          valueLabel: _percentLabel(_settings.motifVariationBias),
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(motifVariationBias: value),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          l10n.melodyRangeHelp,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                key: const ValueKey('melody-range-low-dropdown'),
                initialValue: _settings.melodyRangeLow,
                isExpanded: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.melodyRangeLow,
                ),
                items: _melodyRangeOptions(forHigh: false)
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(_melodyMidiLabel(value)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  dispatcher.apply(
                    (current) => current.copyWith(melodyRangeLow: value),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                key: const ValueKey('melody-range-high-dropdown'),
                initialValue: _settings.melodyRangeHigh,
                isExpanded: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.melodyRangeHigh,
                ),
                items: _melodyRangeOptions(forHigh: true)
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(_melodyMidiLabel(value)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  dispatcher.apply(
                    (current) => current.copyWith(melodyRangeHigh: value),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<MelodyStyle>(
          key: const ValueKey('melody-style-dropdown'),
          initialValue: _settings.melodyStyle,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.melodyStyle,
            helperText: l10n.melodyStyleHelp,
          ),
          items: MelodyStyle.values
              .map(
                (value) => DropdownMenuItem<MelodyStyle>(
                  value: value,
                  child: Text(value.localizedLabel(l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply((current) => current.copyWith(melodyStyle: value));
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          key: const ValueKey('allow-chromatic-approaches-toggle'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.allowChromaticApproaches),
          subtitle: Text(l10n.allowChromaticApproachesHelp),
          value: _settings.allowChromaticApproaches,
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(allowChromaticApproaches: value),
            );
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<MelodyPlaybackMode>(
          key: const ValueKey('melody-playback-mode-dropdown'),
          initialValue: _settings.melodyPlaybackMode,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.melodyPlaybackMode,
            helperText: l10n.melodyPlaybackModeHelp,
          ),
          items: MelodyPlaybackMode.values
              .map(
                (value) => DropdownMenuItem<MelodyPlaybackMode>(
                  value: value,
                  child: Text(value.localizedLabel(l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(melodyPlaybackMode: value),
            );
          },
        ),
      ],
    ];
  }

  List<Widget> _buildMetronomePanel({
    required AppLocalizations l10n,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    return [
      _AdvancedSectionTitle(text: l10n.metronomePatternTitle),
      DropdownButtonFormField<MetronomePatternPreset>(
        key: const ValueKey('metronome-pattern-dropdown'),
        initialValue: _settings.metronomePattern.preset,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.metronomePatternTitle,
          helperText: l10n.metronomePatternHelp,
        ),
        items: MetronomePatternPreset.values
            .map(
              (value) => DropdownMenuItem<MetronomePatternPreset>(
                value: value,
                child: Text(value.localizedLabel(l10n)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(
              metronomePattern: current.metronomePattern.copyWith(
                preset: value,
              ),
            ),
          );
        },
      ),
      if (_settings.metronomePattern.preset ==
          MetronomePatternPreset.custom) ...[
        const SizedBox(height: 12),
        for (
          var beatIndex = 0;
          beatIndex < _settings.beatsPerBar;
          beatIndex += 1
        ) ...[
          DropdownButtonFormField<MetronomeBeatState>(
            key: ValueKey('metronome-custom-beat-$beatIndex-dropdown'),
            initialValue: _customMetronomeBeatStates[beatIndex],
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.anchorLoopBeatLabel(beatIndex + 1),
            ),
            items: MetronomeBeatState.values
                .map(
                  (value) => DropdownMenuItem<MetronomeBeatState>(
                    value: value,
                    child: Text(value.localizedLabel(l10n)),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              _applyCustomMetronomeBeatState(beatIndex, value);
            },
          ),
          if (beatIndex + 1 < _settings.beatsPerBar) const SizedBox(height: 12),
        ],
      ],
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
        key: const ValueKey('metronome-accent-sound-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.metronomeUseAccentSound),
        subtitle: Text(l10n.metronomeUseAccentSoundHelp),
        value: _settings.metronomeUseAccentSound,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(metronomeUseAccentSound: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _MetronomeSourceEditor(
        title: l10n.metronomePrimarySource,
        kind: _settings.metronomeSource.kind,
        builtInSound: _settings.metronomeSound,
        localFilePath: _settings.metronomeSource.trimmedLocalFilePath,
        localFileLabel: l10n.metronomeLocalFilePath,
        localFileHelp: l10n.metronomeLocalFilePathHelp,
        uploadsSupported: _metronomeCustomSoundService.isSupported,
        uploadInProgress: _primaryMetronomeUploadInProgress,
        onKindChanged: (value) {
          _applyMetronomeSource(
            _settings.metronomeSource.copyWith(kind: value),
            accent: false,
          );
        },
        onBuiltInSoundChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(metronomeSound: value),
          );
        },
        onPickLocalFile: () => _uploadMetronomeSource(accent: false),
        onResetToBuiltIn: () => _resetMetronomeSource(accent: false),
        onLocalFileSubmitted: (value) {
          _applyMetronomeSource(
            _settings.metronomeSource.copyWith(localFilePath: value.trim()),
            accent: false,
          );
        },
      ),
      if (_settings.metronomeUseAccentSound) ...[
        const SizedBox(height: 12),
        _MetronomeSourceEditor(
          title: l10n.metronomeAccentSource,
          kind: _settings.metronomeAccentSource.kind,
          builtInSound: _settings.metronomeAccentSound,
          localFilePath: _settings.metronomeAccentSource.trimmedLocalFilePath,
          localFileLabel: l10n.metronomeAccentLocalFilePath,
          localFileHelp: l10n.metronomeAccentLocalFilePathHelp,
          uploadsSupported: _metronomeCustomSoundService.isSupported,
          uploadInProgress: _accentMetronomeUploadInProgress,
          onKindChanged: (value) {
            _applyMetronomeSource(
              _settings.metronomeAccentSource.copyWith(kind: value),
              accent: true,
            );
          },
          onBuiltInSoundChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(metronomeAccentSound: value),
            );
          },
          onPickLocalFile: () => _uploadMetronomeSource(accent: true),
          onResetToBuiltIn: () => _resetMetronomeSource(accent: true),
          onLocalFileSubmitted: (value) {
            _applyMetronomeSource(
              _settings.metronomeAccentSource.copyWith(
                localFilePath: value.trim(),
              ),
              accent: true,
            );
          },
        ),
      ],
    ];
  }

  List<Widget> _buildSoundPanel({
    required AppLocalizations l10n,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    final selectedProfile = _selectedVisibleHarmonySoundProfile;
    final soundProfile = trackSoundProfileForSelection(
      l10n,
      selection: selectedProfile,
    );
    final instrumentName = InstrumentLibraryRegistry.byId(
      soundProfile.suggestedInstrumentId,
    ).displayName;
    return [
      _AdvancedSectionTitle(text: l10n.harmonySoundTitle),
      DropdownButtonFormField<HarmonySoundProfileSelection>(
        key: const ValueKey('harmony-sound-profile-selection-dropdown'),
        initialValue: selectedProfile,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.harmonySoundProfileSelectionTitle,
          helperText: l10n.harmonySoundProfileSelectionHelp,
        ),
        items: _visibleHarmonySoundProfiles
            .map(
              (value) => DropdownMenuItem<HarmonySoundProfileSelection>(
                value: value,
                child: Text(value.localizedLabel(l10n)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(harmonySoundProfileSelection: value),
          );
        },
      ),
      const SizedBox(height: 12),
      DecoratedBox(
        decoration: ChordestUiTokens.innerPanelDecoration(Theme.of(context)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                soundProfile.label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                soundProfile.summary,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.harmonySoundProfileSummaryLine(
                  instrumentName,
                  soundProfile.runtimeProfile.preferredPattern.localizedLabel(
                    l10n,
                  ),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (soundProfile.playbackTraits.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final trait in soundProfile.playbackTraits)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(trait),
                      ),
                  ],
                ),
              ],
              if (selectedProfile ==
                  HarmonySoundProfileSelection.trackAware) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.harmonySoundProfileTrackAwareFallback,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (soundProfile.assetStatusNote case final assetNote?) ...[
                const SizedBox(height: 8),
                Text(
                  assetNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      _AdvancedSliderTile(
        title: l10n.harmonyMasterVolume,
        subtitle: l10n.harmonyMasterVolumeHelp,
        value: _settings.harmonyMasterVolume,
        min: PracticeSettings.minHarmonyMasterVolume,
        max: PracticeSettings.maxHarmonyMasterVolume,
        divisions: 10,
        valueLabel: _percentLabel(_settings.harmonyMasterVolume),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyMasterVolume: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedSliderTile(
        title: l10n.harmonyPreviewHoldFactor,
        subtitle: l10n.harmonyPreviewHoldFactorHelp,
        value: _settings.harmonyPreviewHoldFactor,
        min: PracticeSettings.minHarmonyHoldFactor,
        max: PracticeSettings.maxHarmonyHoldFactor,
        divisions: 14,
        valueLabel: _percentLabel(_settings.harmonyPreviewHoldFactor),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyPreviewHoldFactor: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedSliderTile(
        title: l10n.harmonyArpeggioStepSpeed,
        subtitle: l10n.harmonyArpeggioStepSpeedHelp,
        value: _settings.harmonyArpeggioStepSpeed,
        min: PracticeSettings.minHarmonyArpeggioStepSpeed,
        max: PracticeSettings.maxHarmonyArpeggioStepSpeed,
        divisions: 15,
        valueLabel: _speedLabel(_settings.harmonyArpeggioStepSpeed),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyArpeggioStepSpeed: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedSliderTile(
        title: l10n.harmonyVelocityHumanization,
        subtitle: l10n.harmonyVelocityHumanizationHelp,
        value: _settings.harmonyVelocityHumanization,
        min: PracticeSettings.minHumanizationAmount,
        max: PracticeSettings.maxHumanizationAmount,
        divisions: 10,
        valueLabel: _percentLabel(_settings.harmonyVelocityHumanization),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyVelocityHumanization: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedSliderTile(
        title: l10n.harmonyGainRandomness,
        subtitle: l10n.harmonyGainRandomnessHelp,
        value: _settings.harmonyGainRandomness,
        min: PracticeSettings.minHumanizationAmount,
        max: PracticeSettings.maxHumanizationAmount,
        divisions: 10,
        valueLabel: _percentLabel(_settings.harmonyGainRandomness),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyGainRandomness: value),
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedSliderTile(
        title: l10n.harmonyTimingHumanization,
        subtitle: l10n.harmonyTimingHumanizationHelp,
        value: _settings.harmonyTimingHumanization,
        min: PracticeSettings.minHumanizationAmount,
        max: PracticeSettings.maxHumanizationAmount,
        divisions: 10,
        valueLabel: _percentLabel(_settings.harmonyTimingHumanization),
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(harmonyTimingHumanization: value),
          );
        },
      ),
    ];
  }

  List<Widget> _buildAnchorPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return [
      _AdvancedSectionTitle(text: l10n.anchorLoopTitle),
      Text(
        l10n.anchorLoopHelp,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        key: const ValueKey('anchor-loop-cycle-length-dropdown'),
        initialValue: _anchorLoop.clampedCycleLengthBars,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.anchorLoopCycleLength,
          helperText: l10n.anchorLoopCycleLengthHelp,
        ),
        items: const [1, 2, 3, 4, 5, 6, 7, 8]
            .map(
              (value) =>
                  DropdownMenuItem<int>(value: value, child: Text('$value')),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          _applyAnchorLoop(_anchorLoop.copyWith(cycleLengthBars: value));
        },
      ),
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
        key: const ValueKey('anchor-loop-vary-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.anchorLoopVaryNonAnchorSlots),
        subtitle: Text(l10n.anchorLoopVaryNonAnchorSlotsHelp),
        value: _anchorLoop.varyNonAnchorSlots,
        onChanged: (value) {
          _applyAnchorLoop(_anchorLoop.copyWith(varyNonAnchorSlots: value));
        },
      ),
      const SizedBox(height: 12),
      for (
        var barOffset = 0;
        barOffset < _anchorLoop.clampedCycleLengthBars;
        barOffset += 1
      ) ...[
        DecoratedBox(
          decoration: ChordestUiTokens.innerPanelDecoration(theme),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.anchorLoopBarLabel(barOffset + 1),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final timing in _anchorSlotTimingsForBar(barOffset))
                  Builder(
                    builder: (context) {
                      final slot = _anchorLoop.slotForPosition(
                        barOffset: timing.barOffset,
                        slotIndexWithinBar: timing.slotIndexWithinBar,
                      );
                      return ListTile(
                        key: ValueKey(
                          'anchor-slot-${timing.barOffset}-${timing.slotIndexWithinBar}',
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.anchorLoopBeatLabel(timing.changeBeat + 1),
                        ),
                        subtitle: Text(
                          slot?.trimmedChordSymbol.isNotEmpty == true
                              ? slot!.trimmedChordSymbol
                              : l10n.anchorLoopSlotEmpty,
                        ),
                        onTap: () =>
                            _openAnchorSlotEditor(context, timing: timing),
                        trailing: Switch.adaptive(
                          value: slot?.enabled ?? false,
                          onChanged: (selected) => _toggleAnchorSlot(
                            context,
                            timing: timing,
                            selected: selected,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        if (barOffset + 1 < _anchorLoop.clampedCycleLengthBars)
          const SizedBox(height: 12),
      ],
    ];
  }

  List<Widget> _buildHarmonyPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    return [
      if (!_isPremiumUnlocked) ...[
        DecoratedBox(
          decoration: ChordestUiTokens.innerPanelDecoration(theme),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.premiumUnlockSettingsHintTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.premiumUnlockSettingsHintBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => showPremiumPaywallSheet(
                    context,
                    highlightedFeature: PremiumFeature.smartGenerator,
                  ),
                  icon: const Icon(Icons.workspace_premium_rounded),
                  label: Text(l10n.premiumUnlockCardButton),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
      _AdvancedSectionTitle(text: l10n.keys),
      for (final mode in KeyMode.values) ...[
        Text(
          mode == KeyMode.major ? l10n.modeMajor : l10n.modeMinor,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in MusicTheory.advancedKeySelectionOptionsForMode(
              mode,
            ))
              FilterChip(
                key: ValueKey(
                  'advanced-key-center-'
                  '${option.displayTonicNames.join('-')}-${option.mode.name}',
                ),
                label: Text(_keySelectionOptionLabel(option)),
                selected: option.cycleTonicNames.contains(
                  _selectedTonicNameForKeyOption(option),
                ),
                showCheckmark: false,
                onSelected: (_) => _toggleAdvancedKeySelection(option),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
      if (_usesKeyMode && _settings.smartGeneratorMode) ...[
        _AdvancedSectionTitle(text: l10n.advancedSmartGenerator),
        DropdownButtonFormField<ModulationIntensity>(
          key: const ValueKey('modulation-intensity-dropdown'),
          initialValue: _settings.modulationIntensity,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.modulationIntensity,
          ),
          items: ModulationIntensity.values
              .map(
                (value) => DropdownMenuItem<ModulationIntensity>(
                  value: value,
                  child: Text(_modulationIntensityLabel(l10n, value)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(modulationIntensity: value),
              reseed: true,
            );
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<JazzPreset>(
          key: const ValueKey('jazz-preset-dropdown'),
          initialValue: _settings.jazzPreset,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.jazzPreset,
          ),
          items: JazzPreset.values
              .map(
                (value) => DropdownMenuItem<JazzPreset>(
                  value: value,
                  child: Text(_jazzPresetLabel(l10n, value)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(jazzPreset: value),
              reseed: true,
            );
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<SourceProfile>(
          key: const ValueKey('source-profile-dropdown'),
          initialValue: _settings.sourceProfile,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.sourceProfile,
          ),
          items: SourceProfile.values
              .map(
                (value) => DropdownMenuItem<SourceProfile>(
                  value: value,
                  child: Text(_sourceProfileLabel(l10n, value)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(sourceProfile: value),
              reseed: true,
            );
          },
        ),
        const SizedBox(height: 24),
      ],
      _AdvancedSectionTitle(text: l10n.nonDiatonic),
      if (!_usesKeyMode)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            l10n.nonDiatonicRequiresKeyMode,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilterChip(
            label: Text(l10n.secondaryDominant),
            selected: _settings.secondaryDominantEnabled,
            showCheckmark: false,
            onSelected: _usesKeyMode
                ? (selected) {
                    dispatcher.apply(
                      (current) =>
                          current.copyWith(secondaryDominantEnabled: selected),
                      reseed: true,
                    );
                  }
                : null,
          ),
          FilterChip(
            label: Text(l10n.substituteDominant),
            selected: _settings.substituteDominantEnabled,
            showCheckmark: false,
            onSelected: _usesKeyMode
                ? (selected) {
                    dispatcher.apply(
                      (current) =>
                          current.copyWith(substituteDominantEnabled: selected),
                      reseed: true,
                    );
                  }
                : null,
          ),
          FilterChip(
            key: const ValueKey('modal-interchange-chip'),
            label: Text(l10n.modalInterchange),
            selected: _settings.modalInterchangeEnabled,
            showCheckmark: false,
            onSelected: _usesKeyMode
                ? (selected) {
                    dispatcher.apply(
                      (current) =>
                          current.copyWith(modalInterchangeEnabled: selected),
                      reseed: true,
                    );
                  }
                : null,
          ),
        ],
      ),
      const SizedBox(height: 24),
      _AdvancedSectionTitle(text: l10n.allowTensions),
      SwitchListTile.adaptive(
        key: const ValueKey('allow-tensions-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.allowTensions),
        subtitle: Text(l10n.tensionHelp),
        value: _settings.allowTensions,
        onChanged: _usesKeyMode
            ? (value) {
                dispatcher.apply(
                  (current) => current.copyWith(allowTensions: value),
                  reseed: true,
                );
              }
            : null,
      ),
      const SizedBox(height: 12),
      _AdvancedNestedGroup(
        enabled: _settings.allowTensions,
        disabledMessage: l10n.tensionHelp,
        showWhenDisabled: true,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ChordRenderingHelper.supportedTensionOptions
                .map((tension) {
                  return FilterChip(
                    key: ValueKey('tension-chip-$tension'),
                    label: Text(
                      MusicNotationFormatter.formatChordSuffixAccidentals(
                        tension,
                      ),
                    ),
                    selected: _settings.selectedTensionOptions.contains(
                      tension,
                    ),
                    showCheckmark: false,
                    onSelected: _usesKeyMode && _settings.allowTensions
                        ? (selected) {
                            final nextTensions = <String>{
                              ..._settings.selectedTensionOptions,
                            };
                            if (selected) {
                              nextTensions.add(tension);
                            } else {
                              nextTensions.remove(tension);
                            }
                            dispatcher.apply(
                              (current) => current.copyWith(
                                selectedTensionOptions: nextTensions,
                              ),
                              reseed: true,
                            );
                          }
                        : null,
                  );
                })
                .toList(growable: false),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildVoicingPanel({
    required AppLocalizations l10n,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required PracticeSettingsDispatcher dispatcher,
  }) {
    return [
      _AdvancedSectionTitle(text: l10n.voicingSuggestionsTitle),
      DropdownButtonFormField<VoicingDisplayMode>(
        key: const ValueKey('voicing-display-mode-dropdown'),
        initialValue: _settings.voicingDisplayMode,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.voicingDisplayMode,
          helperText: l10n.voicingDisplayModeHelp,
        ),
        items: VoicingDisplayMode.values
            .map(
              (value) => DropdownMenuItem<VoicingDisplayMode>(
                value: value,
                child: Text(_voicingDisplayModeLabel(l10n, value)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(voicingDisplayMode: value),
          );
        },
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<VoicingComplexity>(
        key: const ValueKey('voicing-complexity-dropdown'),
        initialValue: _settings.voicingComplexity,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.voicingComplexity,
          helperText: l10n.voicingComplexityHelp,
        ),
        items: VoicingComplexity.values
            .map(
              (value) => DropdownMenuItem<VoicingComplexity>(
                value: value,
                child: Text(_voicingComplexityLabel(l10n, value)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(voicingComplexity: value),
          );
        },
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<VoicingTopNotePreference>(
        key: const ValueKey('voicing-top-note-dropdown'),
        initialValue: _settings.voicingTopNotePreference,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.voicingTopNotePreference,
          helperText: l10n.voicingTopNotePreferenceHelp,
        ),
        items: VoicingTopNotePreference.values
            .map(
              (value) => DropdownMenuItem<VoicingTopNotePreference>(
                value: value,
                child: Text(_voicingTopNotePreferenceLabel(l10n, value)),
              ),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(voicingTopNotePreference: value),
          );
        },
      ),
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
        key: const ValueKey('allow-rootless-voicings-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.allowRootlessVoicings),
        subtitle: Text(l10n.allowRootlessVoicingsHelp),
        value: _settings.allowRootlessVoicings,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(allowRootlessVoicings: value),
          );
        },
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        key: const ValueKey('max-voicing-notes-dropdown'),
        initialValue: _settings.maxVoicingNotes,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.maxVoicingNotes,
        ),
        items: const [3, 4, 5]
            .map(
              (value) =>
                  DropdownMenuItem<int>(value: value, child: Text('$value')),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(maxVoicingNotes: value),
          );
        },
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<int>(
        key: const ValueKey('look-ahead-depth-dropdown'),
        initialValue: _settings.lookAheadDepth,
        isExpanded: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: l10n.lookAheadDepth,
          helperText: l10n.lookAheadDepthHelp,
        ),
        items: const [0, 1, 2]
            .map(
              (value) =>
                  DropdownMenuItem<int>(value: value, child: Text('$value')),
            )
            .toList(growable: false),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          dispatcher.apply(
            (current) => current.copyWith(lookAheadDepth: value),
          );
        },
      ),
      const SizedBox(height: 12),
      SwitchListTile.adaptive(
        key: const ValueKey('show-voicing-reasons-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.showVoicingReasons),
        subtitle: Text(l10n.showVoicingReasonsHelp),
        value: _settings.showVoicingReasons,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(showVoicingReasons: value),
          );
        },
      ),
      const SizedBox(height: 24),
      _AdvancedSectionTitle(text: l10n.inversions),
      SwitchListTile.adaptive(
        key: const ValueKey('enable-inversions-toggle'),
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.enableInversions),
        subtitle: Text(l10n.inversionHelp),
        value: _settings.inversionSettings.enabled,
        onChanged: (value) {
          dispatcher.apply(
            (current) => current.copyWith(
              inversionSettings: current.inversionSettings.copyWith(
                enabled: value,
              ),
            ),
            reseed: true,
          );
        },
      ),
      const SizedBox(height: 12),
      _AdvancedNestedGroup(
        enabled: _settings.inversionSettings.enabled,
        disabledMessage: l10n.inversionHelp,
        showWhenDisabled: true,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                key: const ValueKey('first-inversion-chip'),
                label: Text(l10n.firstInversion),
                selected: _settings.inversionSettings.firstInversionEnabled,
                showCheckmark: false,
                onSelected: _settings.inversionSettings.enabled
                    ? (selected) {
                        dispatcher.apply(
                          (current) => current.copyWith(
                            inversionSettings: current.inversionSettings
                                .copyWith(firstInversionEnabled: selected),
                          ),
                          reseed: true,
                        );
                      }
                    : null,
              ),
              FilterChip(
                key: const ValueKey('second-inversion-chip'),
                label: Text(l10n.secondInversion),
                selected: _settings.inversionSettings.secondInversionEnabled,
                showCheckmark: false,
                onSelected: _settings.inversionSettings.enabled
                    ? (selected) {
                        dispatcher.apply(
                          (current) => current.copyWith(
                            inversionSettings: current.inversionSettings
                                .copyWith(secondInversionEnabled: selected),
                          ),
                          reseed: true,
                        );
                      }
                    : null,
              ),
              FilterChip(
                key: const ValueKey('third-inversion-chip'),
                label: Text(l10n.thirdInversion),
                selected: _settings.inversionSettings.thirdInversionEnabled,
                showCheckmark: false,
                onSelected: _settings.inversionSettings.enabled
                    ? (selected) {
                        dispatcher.apply(
                          (current) => current.copyWith(
                            inversionSettings: current.inversionSettings
                                .copyWith(thirdInversionEnabled: selected),
                          ),
                          reseed: true,
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  Widget _buildAdvancedSettingsScaffold(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final compactLayout = size.width < 980;
    final categories = _AdvancedSettingsCategory.values;
    final dispatcher = PracticeSettingsDispatcher(
      settings: _settings,
      onApplySettings: _applySettings,
    );
    final panelChildren = _buildCategoryPanelChildren(
      category: _selectedCategory,
      l10n: l10n,
      theme: theme,
      colorScheme: colorScheme,
      dispatcher: dispatcher,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.jazzPresetAdvanced} ${l10n.settings}'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: ChordestUiTokens.pageGradient(theme),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sidebarWidth = compactLayout ? 178.0 : 224.0;
              return Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    compactLayout ? 12 : 20,
                    compactLayout ? 14 : 24,
                    compactLayout ? 12 : 20,
                    compactLayout ? 18 : 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DecoratedBox(
                            decoration: ChordestUiTokens.panelDecoration(
                              theme,
                              borderRadius: ChordestUiTokens.radius(30),
                            ),
                            child: SizedBox(
                              width: sidebarWidth,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  compactLayout ? 10 : 14,
                                  14,
                                  compactLayout ? 10 : 14,
                                  14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        6,
                                        4,
                                        6,
                                        14,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.settings,
                                            style:
                                                ChordestUiTokens.overlineStyle(
                                                  theme,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.setupAssistantAdvancedSectionBody,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                  height: 1.35,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            for (final category in categories)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: _AdvancedCategoryTab(
                                                  tabKey: ValueKey(
                                                    'advanced-settings-tab-${category.name}',
                                                  ),
                                                  label: _categoryLabel(
                                                    l10n,
                                                    category,
                                                  ),
                                                  icon: _categoryIcon(category),
                                                  selected:
                                                      category ==
                                                      _selectedCategory,
                                                  compact: compactLayout,
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedCategory =
                                                          category;
                                                    });
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DecoratedBox(
                              decoration: ChordestUiTokens.panelDecoration(
                                theme,
                                accent: true,
                                elevated: true,
                                borderRadius: ChordestUiTokens.radius(32),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DecoratedBox(
                                    decoration:
                                        ChordestUiTokens.innerPanelDecoration(
                                          theme,
                                          accent: true,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(32),
                                              ),
                                        ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        compactLayout ? 18 : 24,
                                        compactLayout ? 18 : 22,
                                        compactLayout ? 18 : 24,
                                        compactLayout ? 16 : 18,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: colorScheme
                                                  .primaryContainer
                                                  .withValues(alpha: 0.78),
                                              borderRadius:
                                                  ChordestUiTokens.radius(18),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Icon(
                                                _categoryIcon(
                                                  _selectedCategory,
                                                ),
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _categoryLabel(
                                                    l10n,
                                                    _selectedCategory,
                                                  ),
                                                  style: theme
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  _categoryDescription(
                                                    l10n,
                                                    _selectedCategory,
                                                  ),
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                        height: 1.4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Scrollbar(
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.fromLTRB(
                                          compactLayout ? 18 : 24,
                                          compactLayout ? 18 : 20,
                                          compactLayout ? 18 : 24,
                                          compactLayout ? 22 : 26,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: panelChildren,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAdvancedSettingsScaffold(context);
    /*
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dispatcher = PracticeSettingsDispatcher(
      settings: _settings,
      onApplySettings: _applySettings,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.jazzPresetAdvanced} ${l10n.settings}'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AdvancedSectionTitle(text: l10n.practiceMeter),
                        DropdownButtonFormField<PracticeTimeSignature>(
                          key: const ValueKey(
                            'practice-time-signature-dropdown',
                          ),
                          initialValue: _settings.timeSignature,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.practiceMeter,
                            helperText: l10n.practiceMeterHelp,
                          ),
                          items: PracticeTimeSignature.values
                              .map(
                                (value) =>
                                    DropdownMenuItem<PracticeTimeSignature>(
                                      value: value,
                                      child: Text(value.localizedLabel(l10n)),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(timeSignature: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<HarmonicRhythmPreset>(
                          key: const ValueKey(
                            'practice-harmonic-rhythm-dropdown',
                          ),
                          initialValue: _settings.harmonicRhythmPreset,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.harmonicRhythm,
                            helperText: l10n.harmonicRhythmHelp,
                          ),
                          items: HarmonicRhythmPreset.values
                              .map(
                                (value) =>
                                    DropdownMenuItem<HarmonicRhythmPreset>(
                                      value: value,
                                      child: Text(value.localizedLabel(l10n)),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(harmonicRhythmPreset: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.transportAudioTitle),
                        SwitchListTile.adaptive(
                          key: const ValueKey('auto-play-chord-changes-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.autoPlayChordChanges),
                          subtitle: Text(l10n.autoPlayChordChangesHelp),
                          value: _settings.autoPlayChordChanges,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(autoPlayChordChanges: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<HarmonyPlaybackPattern>(
                          key: const ValueKey('auto-play-pattern-dropdown'),
                          initialValue: _settings.autoPlayPattern,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.autoPlayPattern,
                            helperText: l10n.autoPlayPatternHelp,
                          ),
                          items: HarmonyPlaybackPattern.values
                              .map(
                                (value) =>
                                    DropdownMenuItem<HarmonyPlaybackPattern>(
                                      value: value,
                                      child: Text(value.localizedLabel(l10n)),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(autoPlayPattern: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.autoPlayHoldFactor,
                          subtitle: l10n.autoPlayHoldFactorHelp,
                          value: _settings.autoPlayHoldFactor,
                          min: PracticeSettings.minAutoPlayHoldFactor,
                          max: PracticeSettings.maxAutoPlayHoldFactor,
                          divisions: 12,
                          valueLabel: _percentLabel(
                            _settings.autoPlayHoldFactor,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(autoPlayHoldFactor: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('auto-play-melody-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.autoPlayMelodyWithChords),
                          subtitle: Text(
                            l10n.autoPlayMelodyWithChordsPlaceholder,
                          ),
                          value: _settings.autoPlayMelodyWithChords,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                autoPlayMelodyWithChords: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(
                          text: l10n.melodyGenerationTitle,
                        ),
                        SwitchListTile.adaptive(
                          key: const ValueKey(
                            'melody-generation-enabled-toggle',
                          ),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.melodyGenerationTitle),
                          subtitle: Text(l10n.melodyGenerationHelp),
                          value: _settings.melodyGenerationEnabled,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                melodyGenerationEnabled: value,
                                autoPlayMelodyWithChords: value
                                    ? true
                                    : current.autoPlayMelodyWithChords,
                              ),
                            );
                          },
                        ),
                        if (_settings.melodyGenerationEnabled) ...[
                          const SizedBox(height: 12),
                          DropdownButtonFormField<MelodyDensity>(
                            key: const ValueKey('melody-density-dropdown'),
                            initialValue: _settings.melodyDensity,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.melodyDensity,
                              helperText: l10n.melodyDensityHelp,
                            ),
                            items: MelodyDensity.values
                                .map(
                                  (value) => DropdownMenuItem<MelodyDensity>(
                                    value: value,
                                    child: Text(value.localizedLabel(l10n)),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) =>
                                    current.copyWith(melodyDensity: value),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _AdvancedSliderTile(
                            title: l10n.motifRepetitionStrength,
                            subtitle: l10n.motifRepetitionStrengthHelp,
                            value: _settings.motifRepetitionStrength,
                            min: PracticeSettings.minMelodyMotifStrength,
                            max: PracticeSettings.maxMelodyMotifStrength,
                            divisions: 10,
                            valueLabel: _percentLabel(
                              _settings.motifRepetitionStrength,
                            ),
                            onChanged: (value) {
                              dispatcher.apply(
                                (current) => current.copyWith(
                                  motifRepetitionStrength: value,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _AdvancedSliderTile(
                            title: l10n.approachToneDensity,
                            subtitle: l10n.approachToneDensityHelp,
                            value: _settings.approachToneDensity,
                            min:
                                PracticeSettings.minMelodyApproachToneDensity,
                            max:
                                PracticeSettings.maxMelodyApproachToneDensity,
                            divisions: 10,
                            valueLabel: _percentLabel(
                              _settings.approachToneDensity,
                            ),
                            onChanged: (value) {
                              dispatcher.apply(
                                (current) =>
                                    current.copyWith(approachToneDensity: value),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.melodyRangeHelp,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  key: const ValueKey(
                                    'melody-range-low-dropdown',
                                  ),
                                  initialValue: _settings.melodyRangeLow,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: l10n.melodyRangeLow,
                                  ),
                                  items: _melodyRangeOptions(forHigh: false)
                                      .map(
                                        (value) => DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(_melodyMidiLabel(value)),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    dispatcher.apply(
                                      (current) =>
                                          current.copyWith(melodyRangeLow: value),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  key: const ValueKey(
                                    'melody-range-high-dropdown',
                                  ),
                                  initialValue: _settings.melodyRangeHigh,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: l10n.melodyRangeHigh,
                                  ),
                                  items: _melodyRangeOptions(forHigh: true)
                                      .map(
                                        (value) => DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(_melodyMidiLabel(value)),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }
                                    dispatcher.apply(
                                      (current) => current.copyWith(
                                        melodyRangeHigh: value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<MelodyStyle>(
                            key: const ValueKey('melody-style-dropdown'),
                            initialValue: _settings.melodyStyle,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.melodyStyle,
                              helperText: l10n.melodyStyleHelp,
                            ),
                            items: MelodyStyle.values
                                .map(
                                  (value) => DropdownMenuItem<MelodyStyle>(
                                    value: value,
                                    child: Text(value.localizedLabel(l10n)),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) =>
                                    current.copyWith(melodyStyle: value),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile.adaptive(
                            key: const ValueKey(
                              'allow-chromatic-approaches-toggle',
                            ),
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.allowChromaticApproaches),
                            subtitle: Text(
                              l10n.allowChromaticApproachesHelp,
                            ),
                            value: _settings.allowChromaticApproaches,
                            onChanged: (value) {
                              dispatcher.apply(
                                (current) => current.copyWith(
                                  allowChromaticApproaches: value,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<MelodyPlaybackMode>(
                            key: const ValueKey(
                              'melody-playback-mode-dropdown',
                            ),
                            initialValue: _settings.melodyPlaybackMode,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.melodyPlaybackMode,
                              helperText: l10n.melodyPlaybackModeHelp,
                            ),
                            items: MelodyPlaybackMode.values
                                .map(
                                  (value) =>
                                      DropdownMenuItem<MelodyPlaybackMode>(
                                        value: value,
                                        child: Text(value.localizedLabel(l10n)),
                                      ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) => current.copyWith(
                                  melodyPlaybackMode: value,
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.metronomePatternTitle),
                        DropdownButtonFormField<MetronomePatternPreset>(
                          key: const ValueKey('metronome-pattern-dropdown'),
                          initialValue: _settings.metronomePattern.preset,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.metronomePatternTitle,
                            helperText: l10n.metronomePatternHelp,
                          ),
                          items: MetronomePatternPreset.values
                              .map(
                                (value) =>
                                    DropdownMenuItem<MetronomePatternPreset>(
                                      value: value,
                                      child: Text(value.localizedLabel(l10n)),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) => current.copyWith(
                                metronomePattern: current.metronomePattern
                                    .copyWith(preset: value),
                              ),
                            );
                          },
                        ),
                        if (_settings.metronomePattern.preset ==
                            MetronomePatternPreset.custom) ...[
                          const SizedBox(height: 12),
                          for (
                            var beatIndex = 0;
                            beatIndex < _settings.beatsPerBar;
                            beatIndex += 1
                          ) ...[
                            DropdownButtonFormField<MetronomeBeatState>(
                              key: ValueKey(
                                'metronome-custom-beat-$beatIndex-dropdown',
                              ),
                              initialValue:
                                  _customMetronomeBeatStates[beatIndex],
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: l10n.anchorLoopBeatLabel(
                                  beatIndex + 1,
                                ),
                              ),
                              items: MetronomeBeatState.values
                                  .map(
                                    (value) =>
                                        DropdownMenuItem<MetronomeBeatState>(
                                          value: value,
                                          child: Text(
                                            value.localizedLabel(l10n),
                                          ),
                                        ),
                                  )
                                  .toList(growable: false),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                _applyCustomMetronomeBeatState(
                                  beatIndex,
                                  value,
                                );
                              },
                            ),
                            if (beatIndex + 1 < _settings.beatsPerBar)
                              const SizedBox(height: 12),
                          ],
                        ],
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('metronome-accent-sound-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.metronomeUseAccentSound),
                          subtitle: Text(l10n.metronomeUseAccentSoundHelp),
                          value: _settings.metronomeUseAccentSound,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                metronomeUseAccentSound: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _MetronomeSourceEditor(
                          title: l10n.metronomePrimarySource,
                          kind: _settings.metronomeSource.kind,
                          builtInSound: _settings.metronomeSound,
                          localFilePath:
                              _settings.metronomeSource.trimmedLocalFilePath,
                          localFileLabel: l10n.metronomeLocalFilePath,
                          localFileHelp: l10n.metronomeLocalFilePathHelp,
                          uploadsSupported:
                              _metronomeCustomSoundService.isSupported,
                          uploadInProgress: _primaryMetronomeUploadInProgress,
                          onKindChanged: (value) {
                            _applyMetronomeSource(
                              _settings.metronomeSource.copyWith(kind: value),
                              accent: false,
                            );
                          },
                          onBuiltInSoundChanged: (value) {
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(metronomeSound: value),
                            );
                          },
                          onPickLocalFile: () =>
                              _uploadMetronomeSource(accent: false),
                          onResetToBuiltIn: () =>
                              _resetMetronomeSource(accent: false),
                          onLocalFileSubmitted: (value) {
                            _applyMetronomeSource(
                              _settings.metronomeSource.copyWith(
                                localFilePath: value.trim(),
                              ),
                              accent: false,
                            );
                          },
                        ),
                        if (_settings.metronomeUseAccentSound) ...[
                          const SizedBox(height: 12),
                          _MetronomeSourceEditor(
                            title: l10n.metronomeAccentSource,
                            kind: _settings.metronomeAccentSource.kind,
                            builtInSound: _settings.metronomeAccentSound,
                            localFilePath: _settings
                                .metronomeAccentSource
                                .trimmedLocalFilePath,
                            localFileLabel: l10n.metronomeAccentLocalFilePath,
                            localFileHelp:
                                l10n.metronomeAccentLocalFilePathHelp,
                            uploadsSupported: widget
                                .metronomeCustomSoundService
                                .isSupported,
                            uploadInProgress:
                                _accentMetronomeUploadInProgress,
                            onKindChanged: (value) {
                              _applyMetronomeSource(
                                _settings.metronomeAccentSource.copyWith(
                                  kind: value,
                                ),
                                accent: true,
                              );
                            },
                            onBuiltInSoundChanged: (value) {
                              dispatcher.apply(
                                (current) => current.copyWith(
                                  metronomeAccentSound: value,
                                ),
                              );
                            },
                            onPickLocalFile: () =>
                                _uploadMetronomeSource(accent: true),
                            onResetToBuiltIn: () =>
                                _resetMetronomeSource(accent: true),
                            onLocalFileSubmitted: (value) {
                              _applyMetronomeSource(
                                _settings.metronomeAccentSource.copyWith(
                                  localFilePath: value.trim(),
                                ),
                                accent: true,
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.harmonySoundTitle),
                        _AdvancedSliderTile(
                          title: l10n.harmonyMasterVolume,
                          subtitle: l10n.harmonyMasterVolumeHelp,
                          value: _settings.harmonyMasterVolume,
                          min: PracticeSettings.minHarmonyMasterVolume,
                          max: PracticeSettings.maxHarmonyMasterVolume,
                          divisions: 10,
                          valueLabel: _percentLabel(
                            _settings.harmonyMasterVolume,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(harmonyMasterVolume: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.harmonyPreviewHoldFactor,
                          subtitle: l10n.harmonyPreviewHoldFactorHelp,
                          value: _settings.harmonyPreviewHoldFactor,
                          min: PracticeSettings.minHarmonyHoldFactor,
                          max: PracticeSettings.maxHarmonyHoldFactor,
                          divisions: 14,
                          valueLabel: _percentLabel(
                            _settings.harmonyPreviewHoldFactor,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                harmonyPreviewHoldFactor: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.harmonyArpeggioStepSpeed,
                          subtitle: l10n.harmonyArpeggioStepSpeedHelp,
                          value: _settings.harmonyArpeggioStepSpeed,
                          min: PracticeSettings.minHarmonyArpeggioStepSpeed,
                          max: PracticeSettings.maxHarmonyArpeggioStepSpeed,
                          divisions: 15,
                          valueLabel: _speedLabel(
                            _settings.harmonyArpeggioStepSpeed,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                harmonyArpeggioStepSpeed: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.harmonyVelocityHumanization,
                          subtitle: l10n.harmonyVelocityHumanizationHelp,
                          value: _settings.harmonyVelocityHumanization,
                          min: PracticeSettings.minHumanizationAmount,
                          max: PracticeSettings.maxHumanizationAmount,
                          divisions: 10,
                          valueLabel: _percentLabel(
                            _settings.harmonyVelocityHumanization,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                harmonyVelocityHumanization: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.harmonyGainRandomness,
                          subtitle: l10n.harmonyGainRandomnessHelp,
                          value: _settings.harmonyGainRandomness,
                          min: PracticeSettings.minHumanizationAmount,
                          max: PracticeSettings.maxHumanizationAmount,
                          divisions: 10,
                          valueLabel: _percentLabel(
                            _settings.harmonyGainRandomness,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                harmonyGainRandomness: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _AdvancedSliderTile(
                          title: l10n.harmonyTimingHumanization,
                          subtitle: l10n.harmonyTimingHumanizationHelp,
                          value: _settings.harmonyTimingHumanization,
                          min: PracticeSettings.minHumanizationAmount,
                          max: PracticeSettings.maxHumanizationAmount,
                          divisions: 10,
                          valueLabel: _percentLabel(
                            _settings.harmonyTimingHumanization,
                          ),
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                harmonyTimingHumanization: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.anchorLoopTitle),
                        Text(
                          l10n.anchorLoopHelp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: const ValueKey(
                            'anchor-loop-cycle-length-dropdown',
                          ),
                          initialValue: _anchorLoop.clampedCycleLengthBars,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.anchorLoopCycleLength,
                            helperText: l10n.anchorLoopCycleLengthHelp,
                          ),
                          items: const [1, 2, 3, 4, 5, 6, 7, 8]
                              .map(
                                (value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            _applyAnchorLoop(
                              _anchorLoop.copyWith(cycleLengthBars: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('anchor-loop-vary-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.anchorLoopVaryNonAnchorSlots),
                          subtitle: Text(l10n.anchorLoopVaryNonAnchorSlotsHelp),
                          value: _anchorLoop.varyNonAnchorSlots,
                          onChanged: (value) {
                            _applyAnchorLoop(
                              _anchorLoop.copyWith(varyNonAnchorSlots: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        for (
                          var barOffset = 0;
                          barOffset < _anchorLoop.clampedCycleLengthBars;
                          barOffset += 1
                        ) ...[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.anchorLoopBarLabel(barOffset + 1),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  for (final timing in _anchorSlotTimingsForBar(
                                    barOffset,
                                  )) ...[
                                    Builder(
                                      builder: (context) {
                                        final slot = _anchorLoop
                                            .slotForPosition(
                                              barOffset: timing.barOffset,
                                              slotIndexWithinBar:
                                                  timing.slotIndexWithinBar,
                                            );
                                        return ListTile(
                                          key: ValueKey(
                                            'anchor-slot-${timing.barOffset}-${timing.slotIndexWithinBar}',
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            l10n.anchorLoopBeatLabel(
                                              timing.changeBeat + 1,
                                            ),
                                          ),
                                          subtitle: Text(
                                            slot
                                                        ?.trimmedChordSymbol
                                                        .isNotEmpty ==
                                                    true
                                                ? slot!.trimmedChordSymbol
                                                : l10n.anchorLoopSlotEmpty,
                                          ),
                                          onTap: () => _openAnchorSlotEditor(
                                            context,
                                            timing: timing,
                                          ),
                                          trailing: Switch.adaptive(
                                            value: slot?.enabled ?? false,
                                            onChanged: (selected) =>
                                                _toggleAnchorSlot(
                                                  context,
                                                  timing: timing,
                                                  selected: selected,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (barOffset + 1 <
                              _anchorLoop.clampedCycleLengthBars)
                            const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 24),
                        if (_usesKeyMode && _settings.smartGeneratorMode) ...[
                          _AdvancedSectionTitle(
                            text: l10n.advancedSmartGenerator,
                          ),
                          DropdownButtonFormField<ModulationIntensity>(
                            key: const ValueKey(
                              'modulation-intensity-dropdown',
                            ),
                            initialValue: _settings.modulationIntensity,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.modulationIntensity,
                            ),
                            items: ModulationIntensity.values
                                .map(
                                  (value) =>
                                      DropdownMenuItem<ModulationIntensity>(
                                        value: value,
                                        child: Text(
                                          _modulationIntensityLabel(
                                            l10n,
                                            value,
                                          ),
                                        ),
                                      ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) => current.copyWith(
                                  modulationIntensity: value,
                                ),
                                reseed: true,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<JazzPreset>(
                            key: const ValueKey('jazz-preset-dropdown'),
                            initialValue: _settings.jazzPreset,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.jazzPreset,
                            ),
                            items: JazzPreset.values
                                .map(
                                  (value) => DropdownMenuItem<JazzPreset>(
                                    value: value,
                                    child: Text(_jazzPresetLabel(l10n, value)),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) =>
                                    current.copyWith(jazzPreset: value),
                                reseed: true,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<SourceProfile>(
                            key: const ValueKey('source-profile-dropdown'),
                            initialValue: _settings.sourceProfile,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: l10n.sourceProfile,
                            ),
                            items: SourceProfile.values
                                .map(
                                  (value) => DropdownMenuItem<SourceProfile>(
                                    value: value,
                                    child: Text(
                                      _sourceProfileLabel(l10n, value),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              dispatcher.apply(
                                (current) =>
                                    current.copyWith(sourceProfile: value),
                                reseed: true,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                        _AdvancedSectionTitle(text: l10n.nonDiatonic),
                        if (!_usesKeyMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              l10n.nonDiatonicRequiresKeyMode,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              label: Text(l10n.secondaryDominant),
                              selected: _settings.secondaryDominantEnabled,
                              showCheckmark: false,
                              onSelected: _usesKeyMode
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          secondaryDominantEnabled: selected,
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              label: Text(l10n.substituteDominant),
                              selected: _settings.substituteDominantEnabled,
                              showCheckmark: false,
                              onSelected: _usesKeyMode
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          substituteDominantEnabled: selected,
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              key: const ValueKey('modal-interchange-chip'),
                              label: Text(l10n.modalInterchange),
                              selected: _settings.modalInterchangeEnabled,
                              showCheckmark: false,
                              onSelected: _usesKeyMode
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          modalInterchangeEnabled: selected,
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.allowTensions),
                        Text(
                          l10n.tensionHelp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ChordRenderingHelper.supportedTensionOptions
                              .map((tension) {
                                return FilterChip(
                                  key: ValueKey('tension-chip-$tension'),
                                  label: Text(
                                    MusicNotationFormatter
                                        .formatChordSuffixAccidentals(tension),
                                  ),
                                  selected: _settings.selectedTensionOptions
                                      .contains(tension),
                                  showCheckmark: false,
                                  onSelected:
                                      _usesKeyMode && _settings.allowTensions
                                      ? (selected) {
                                          final nextTensions = <String>{
                                            ..._settings.selectedTensionOptions,
                                          };
                                          if (selected) {
                                            nextTensions.add(tension);
                                          } else {
                                            nextTensions.remove(tension);
                                          }
                                          dispatcher.apply(
                                            (current) => current.copyWith(
                                              selectedTensionOptions:
                                                  nextTensions,
                                            ),
                                            reseed: true,
                                          );
                                        }
                                      : null,
                                );
                              })
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(
                          text: l10n.voicingSuggestionsTitle,
                        ),
                        DropdownButtonFormField<VoicingDisplayMode>(
                          key: const ValueKey('voicing-display-mode-dropdown'),
                          initialValue: _settings.voicingDisplayMode,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.voicingDisplayMode,
                            helperText: l10n.voicingDisplayModeHelp,
                          ),
                          items: VoicingDisplayMode.values
                              .map(
                                (value) => DropdownMenuItem<VoicingDisplayMode>(
                                  value: value,
                                  child: Text(
                                    _voicingDisplayModeLabel(l10n, value),
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(voicingDisplayMode: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<VoicingComplexity>(
                          key: const ValueKey('voicing-complexity-dropdown'),
                          initialValue: _settings.voicingComplexity,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.voicingComplexity,
                            helperText: l10n.voicingComplexityHelp,
                          ),
                          items: VoicingComplexity.values
                              .map(
                                (value) => DropdownMenuItem<VoicingComplexity>(
                                  value: value,
                                  child: Text(
                                    _voicingComplexityLabel(l10n, value),
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(voicingComplexity: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<VoicingTopNotePreference>(
                          key: const ValueKey('voicing-top-note-dropdown'),
                          initialValue: _settings.voicingTopNotePreference,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.voicingTopNotePreference,
                            helperText: l10n.voicingTopNotePreferenceHelp,
                          ),
                          items: VoicingTopNotePreference.values
                              .map(
                                (value) =>
                                    DropdownMenuItem<VoicingTopNotePreference>(
                                      value: value,
                                      child: Text(
                                        _voicingTopNotePreferenceLabel(
                                          l10n,
                                          value,
                                        ),
                                      ),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) => current.copyWith(
                                voicingTopNotePreference: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('allow-rootless-voicings-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.allowRootlessVoicings),
                          subtitle: Text(l10n.allowRootlessVoicingsHelp),
                          value: _settings.allowRootlessVoicings,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) => current.copyWith(
                                allowRootlessVoicings: value,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: const ValueKey('max-voicing-notes-dropdown'),
                          initialValue: _settings.maxVoicingNotes,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.maxVoicingNotes,
                          ),
                          items: const [3, 4, 5]
                              .map(
                                (value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(maxVoicingNotes: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: const ValueKey('look-ahead-depth-dropdown'),
                          initialValue: _settings.lookAheadDepth,
                          isExpanded: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.lookAheadDepth,
                            helperText: l10n.lookAheadDepthHelp,
                          ),
                          items: const [0, 1, 2]
                              .map(
                                (value) => DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(lookAheadDepth: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('show-voicing-reasons-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.showVoicingReasons),
                          subtitle: Text(l10n.showVoicingReasonsHelp),
                          value: _settings.showVoicingReasons,
                          onChanged: (value) {
                            dispatcher.apply(
                              (current) =>
                                  current.copyWith(showVoicingReasons: value),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _AdvancedSectionTitle(text: l10n.inversions),
                        Text(
                          l10n.inversionHelp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              key: const ValueKey('first-inversion-chip'),
                              label: Text(l10n.firstInversion),
                              selected: _settings
                                  .inversionSettings
                                  .firstInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          inversionSettings: current
                                              .inversionSettings
                                              .copyWith(
                                                firstInversionEnabled: selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              key: const ValueKey('second-inversion-chip'),
                              label: Text(l10n.secondInversion),
                              selected: _settings
                                  .inversionSettings
                                  .secondInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          inversionSettings: current
                                              .inversionSettings
                                              .copyWith(
                                                secondInversionEnabled:
                                                    selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                            FilterChip(
                              key: const ValueKey('third-inversion-chip'),
                              label: Text(l10n.thirdInversion),
                              selected: _settings
                                  .inversionSettings
                                  .thirdInversionEnabled,
                              showCheckmark: false,
                              onSelected: _settings.inversionSettings.enabled
                                  ? (selected) {
                                      dispatcher.apply(
                                        (current) => current.copyWith(
                                          inversionSettings: current
                                              .inversionSettings
                                              .copyWith(
                                                thirdInversionEnabled: selected,
                                              ),
                                        ),
                                        reseed: true,
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    */
  }
}

class _AdvancedCategoryTab extends StatelessWidget {
  const _AdvancedCategoryTab({
    required this.tabKey,
    required this.label,
    required this.icon,
    required this.selected,
    required this.compact,
    required this.onPressed,
  });

  final Key tabKey;
  final String label;
  final IconData icon;
  final bool selected;
  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Tooltip(
      message: compact ? label : '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: tabKey,
          onTap: onPressed,
          borderRadius: ChordestUiTokens.radius(20),
          child: Ink(
            padding: EdgeInsets.fromLTRB(
              compact ? 12 : 14,
              compact ? 12 : 13,
              compact ? 12 : 14,
              compact ? 12 : 13,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colorScheme.primaryContainer.withValues(alpha: 0.78)
                  : colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: ChordestUiTokens.radius(20),
              border: Border.all(
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.24)
                    : colorScheme.outlineVariant.withValues(alpha: 0.84),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: compact ? 18 : 20,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selected
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdvancedSectionTitle extends StatelessWidget {
  const _AdvancedSectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _AdvancedSliderTile extends StatelessWidget {
  const _AdvancedSliderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueLabel,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme, accent: true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  valueLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Slider.adaptive(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: valueLabel,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedNestedGroup extends StatelessWidget {
  const _AdvancedNestedGroup({
    required this.enabled,
    required this.children,
    required this.disabledMessage,
    this.showWhenDisabled = false,
  });

  final bool enabled;
  final List<Widget> children;
  final String disabledMessage;
  final bool showWhenDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (enabled) {
      return DecoratedBox(
        decoration: ChordestUiTokens.innerPanelDecoration(theme),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
    }
    if (showWhenDisabled) {
      return DecoratedBox(
        decoration: ChordestUiTokens.innerPanelDecoration(theme),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                disabledMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              IgnorePointer(
                child: Opacity(
                  opacity: 0.46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(theme),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          disabledMessage,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _MetronomeSourceEditor extends StatelessWidget {
  const _MetronomeSourceEditor({
    required this.title,
    required this.kind,
    required this.builtInSound,
    required this.localFilePath,
    required this.localFileLabel,
    required this.localFileHelp,
    required this.uploadsSupported,
    required this.uploadInProgress,
    required this.onKindChanged,
    required this.onBuiltInSoundChanged,
    this.onPickLocalFile,
    this.onResetToBuiltIn,
    required this.onLocalFileSubmitted,
  });

  final String title;
  final MetronomeSourceKind kind;
  final MetronomeSound builtInSound;
  final String localFilePath;
  final String localFileLabel;
  final String localFileHelp;
  final bool uploadsSupported;
  final bool uploadInProgress;
  final ValueChanged<MetronomeSourceKind> onKindChanged;
  final ValueChanged<MetronomeSound> onBuiltInSoundChanged;
  final Future<void> Function()? onPickLocalFile;
  final Future<void> Function()? onResetToBuiltIn;
  final ValueChanged<String> onLocalFileSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: ChordestUiTokens.innerPanelDecoration(Theme.of(context)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MetronomeSourceKind>(
              initialValue: kind,
              isExpanded: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.metronomeSourceKind,
              ),
              items: MetronomeSourceKind.values
                  .map(
                    (value) => DropdownMenuItem<MetronomeSourceKind>(
                      value: value,
                      child: Text(value.localizedLabel(l10n)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                onKindChanged(value);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MetronomeSound>(
              initialValue: builtInSound,
              isExpanded: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.metronomeSound,
              ),
              items: MetronomeSound.values
                  .map(
                    (value) => DropdownMenuItem<MetronomeSound>(
                      value: value,
                      child: Text(value.localizedLabel(l10n)),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                onBuiltInSoundChanged(value);
              },
            ),
            if (kind == MetronomeSourceKind.localFile) ...[
              const SizedBox(height: 12),
              Text(
                localFilePath.isEmpty
                    ? l10n.metronomeCustomSoundStatusBuiltIn
                    : l10n.metronomeCustomSoundStatusFile(
                        MetronomeSourceSpec.localFile(
                          localFilePath: localFilePath,
                          fallbackSound: builtInSound,
                        ).localFileName,
                      ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (uploadsSupported) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: uploadInProgress
                          ? null
                          : () {
                              final callback = onPickLocalFile;
                              if (callback != null) {
                                unawaited(callback());
                              }
                            },
                      icon: Icon(
                        localFilePath.isEmpty
                            ? Icons.audio_file_rounded
                            : Icons.upload_file_rounded,
                      ),
                      label: Text(
                        localFilePath.isEmpty
                            ? l10n.metronomeCustomSoundUpload
                            : l10n.metronomeCustomSoundReplace,
                      ),
                    ),
                    if (localFilePath.isNotEmpty)
                      TextButton(
                        onPressed: uploadInProgress
                            ? null
                            : () {
                                final callback = onResetToBuiltIn;
                                if (callback != null) {
                                  unawaited(callback());
                                }
                              },
                        child: Text(l10n.metronomeCustomSoundReset),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                key: ValueKey('$title-local-file'),
                initialValue: localFilePath,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: localFileLabel,
                  helperText: localFileHelp,
                ),
                onFieldSubmitted: onLocalFileSubmitted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnchorEditorSlotTiming {
  const _AnchorEditorSlotTiming({
    required this.barOffset,
    required this.slotIndexWithinBar,
    required this.changeBeat,
  });

  final int barOffset;
  final int slotIndexWithinBar;
  final int changeBeat;
}

class _AnchorSlotEditorResult {
  const _AnchorSlotEditorResult({
    required this.chordSymbol,
    required this.enabled,
  }) : clear = false;

  const _AnchorSlotEditorResult.clear()
    : chordSymbol = '',
      enabled = false,
      clear = true;

  final String chordSymbol;
  final bool enabled;
  final bool clear;
}

class _AnchorSlotEditorSheet extends StatefulWidget {
  const _AnchorSlotEditorSheet({
    required this.timing,
    required this.existingSlot,
    required this.planner,
  });

  final _AnchorEditorSlotTiming timing;
  final ChordAnchorSlot? existingSlot;
  final AnchorLoopPlanner planner;

  @override
  State<_AnchorSlotEditorSheet> createState() => _AnchorSlotEditorSheetState();
}

class _AnchorSlotEditorSheetState extends State<_AnchorSlotEditorSheet> {
  late final TextEditingController _controller;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.existingSlot?.trimmedChordSymbol ?? '',
    );
    _controller.addListener(_handleControllerChanged);
    _enabled = widget.existingSlot?.enabled ?? true;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    final trimmed = _controller.text.trim();
    final parsedChord = trimmed.isEmpty
        ? null
        : widget.planner.tryParseChordSymbol(trimmed);
    final hasValidSymbol = trimmed.isEmpty || parsedChord != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.anchorLoopEditTitle(
                widget.timing.barOffset + 1,
                widget.timing.changeBeat + 1,
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.enabled),
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ChordInputEditor(
              controller: _controller,
              labelText: l10n.anchorLoopChordSymbol,
              hintText: l10n.anchorLoopChordHint,
              helperText: trimmed.isEmpty
                  ? l10n.anchorLoopChordHint
                  : hasValidSymbol
                  ? l10n.anchorLoopChordHint
                  : l10n.anchorLoopInvalidChord,
              onAnalyze: () {
                setState(() {});
              },
              minLines: 1,
              maxLines: 1,
              showAnalyzeAction: false,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: Text(materialL10n.cancelButtonLabel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: hasValidSymbol
                      ? () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop(
                            trimmed.isEmpty
                                ? const _AnchorSlotEditorResult.clear()
                                : _AnchorSlotEditorResult(
                                    chordSymbol: trimmed,
                                    enabled: _enabled,
                                  ),
                          );
                        }
                      : null,
                  child: Text(materialL10n.saveButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _modulationIntensityLabel(
  AppLocalizations l10n,
  ModulationIntensity value,
) {
  return switch (value) {
    ModulationIntensity.off => l10n.modulationIntensityOff,
    ModulationIntensity.low => l10n.modulationIntensityLow,
    ModulationIntensity.medium => l10n.modulationIntensityMedium,
    ModulationIntensity.high => l10n.modulationIntensityHigh,
  };
}

String _jazzPresetLabel(AppLocalizations l10n, JazzPreset value) {
  return switch (value) {
    JazzPreset.standardsCore => l10n.jazzPresetStandardsCore,
    JazzPreset.modulationStudy => l10n.jazzPresetModulationStudy,
    JazzPreset.advanced => l10n.jazzPresetAdvanced,
  };
}

String _sourceProfileLabel(AppLocalizations l10n, SourceProfile value) {
  return switch (value) {
    SourceProfile.fakebookStandard => l10n.sourceProfileFakebookStandard,
    SourceProfile.recordingInspired => l10n.sourceProfileRecordingInspired,
  };
}

String _voicingComplexityLabel(AppLocalizations l10n, VoicingComplexity value) {
  return switch (value) {
    VoicingComplexity.basic => l10n.voicingComplexityBasic,
    VoicingComplexity.standard => l10n.voicingComplexityStandard,
    VoicingComplexity.modern => l10n.voicingComplexityModern,
  };
}

String _voicingDisplayModeLabel(
  AppLocalizations l10n,
  VoicingDisplayMode value,
) {
  return value.localizedLabel(l10n);
}

String _voicingTopNotePreferenceLabel(
  AppLocalizations l10n,
  VoicingTopNotePreference value,
) {
  return value == VoicingTopNotePreference.auto
      ? l10n.voicingTopNotePreferenceAuto
      : value.noteLabel;
}

String _percentLabel(double value) {
  return '${(value * 100).round()}%';
}

String _speedLabel(double value) {
  return '${value.toStringAsFixed(2)}x';
}
