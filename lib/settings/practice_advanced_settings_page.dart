import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import 'practice_settings.dart';
import 'practice_settings_dispatcher.dart';

class PracticeAdvancedSettingsPage extends StatefulWidget {
  const PracticeAdvancedSettingsPage({
    super.key,
    required this.settings,
    required this.onApplySettings,
  });

  final PracticeSettings settings;
  final ApplyPracticeSettings onApplySettings;

  @override
  State<PracticeAdvancedSettingsPage> createState() =>
      _PracticeAdvancedSettingsPageState();
}

class _PracticeAdvancedSettingsPageState
    extends State<PracticeAdvancedSettingsPage> {
  late PracticeSettings _settings;

  bool get _usesKeyMode => _settings.usesKeyMode;

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
    setState(() {
      _settings = nextSettings;
    });
    widget.onApplySettings(nextSettings, reseed: reseed);
  }

  @override
  Widget build(BuildContext context) {
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
                                  label: Text(tension),
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
  }
}

class _AdvancedSectionTitle extends StatelessWidget {
  const _AdvancedSectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
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

String _voicingTopNotePreferenceLabel(
  AppLocalizations l10n,
  VoicingTopNotePreference value,
) {
  return value == VoicingTopNotePreference.auto
      ? l10n.voicingTopNotePreferenceAuto
      : value.noteLabel;
}
