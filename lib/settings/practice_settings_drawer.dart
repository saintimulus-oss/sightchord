import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import 'practice_settings.dart';

typedef ApplyPracticeSettings =
    void Function(PracticeSettings nextSettings, {bool reseed});

class PracticeSettingsDrawer extends StatelessWidget {
  const PracticeSettingsDrawer({
    super.key,
    required this.settings,
    required this.onClose,
    required this.onApplySettings,
  });

  final PracticeSettings settings;
  final VoidCallback onClose;
  final ApplyPracticeSettings onApplySettings;

  bool get _usesKeyMode => settings.usesKeyMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      width: math.min(MediaQuery.of(context).size.width * 0.9, 430),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.settings,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                      tooltip: l10n.closeSettings,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SettingsSectionTitle(text: l10n.language),
                      DropdownButtonFormField<AppLanguage>(
                        key: const ValueKey('language-selector'),
                        initialValue: settings.language,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.language,
                          isDense: true,
                        ),
                        items: AppLanguage.values
                            .map(
                              (language) => DropdownMenuItem<AppLanguage>(
                                value: language,
                                child: Text(_languageLabel(l10n, language)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          onApplySettings(settings.copyWith(language: value));
                        },
                      ),
                      const SizedBox(height: 24),
                      _SettingsSectionTitle(text: l10n.metronome),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.metronome),
                        subtitle: Text(
                          settings.metronomeEnabled
                              ? l10n.enabled
                              : l10n.disabled,
                        ),
                        value: settings.metronomeEnabled,
                        onChanged: (value) {
                          onApplySettings(
                            settings.copyWith(metronomeEnabled: value),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.metronomeHelp,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MetronomeSound>(
                        key: const ValueKey('metronome-sound-selector'),
                        initialValue: settings.metronomeSound,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.metronomeSound,
                        ),
                        items: MetronomeSound.values
                            .map(
                              (sound) => DropdownMenuItem<MetronomeSound>(
                                value: sound,
                                child: Text(sound.localizedLabel(l10n)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          onApplySettings(
                            settings.copyWith(metronomeSound: value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.metronomeVolume,
                        style: theme.textTheme.titleMedium,
                      ),
                      Slider(
                        value: settings.metronomeVolume,
                        onChanged: settings.metronomeEnabled
                            ? (value) {
                                onApplySettings(
                                  settings.copyWith(metronomeVolume: value),
                                );
                              }
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${(settings.metronomeVolume * 100).round()}%',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SettingsSectionTitle(text: l10n.keys),
                      Text(
                        _usesKeyMode
                            ? l10n.keysSelectedHelp
                            : l10n.noKeysSelected,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MusicTheory.keyOptions
                            .map((key) {
                              return FilterChip(
                                label: Text(key),
                                selected: settings.activeKeys.contains(key),
                                showCheckmark: false,
                                onSelected: (selected) {
                                  final nextKeys = <String>{
                                    ...settings.activeKeys,
                                  };
                                  if (selected) {
                                    nextKeys.add(key);
                                  } else {
                                    nextKeys.remove(key);
                                  }
                                  onApplySettings(
                                    settings.copyWith(activeKeys: nextKeys),
                                    reseed: true,
                                  );
                                },
                              );
                            })
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.smartGeneratorMode),
                        subtitle: Text(
                          _usesKeyMode
                              ? l10n.smartGeneratorHelp
                              : l10n.keyModeRequiredForSmartGenerator,
                        ),
                        value: settings.smartGeneratorMode,
                        onChanged: _usesKeyMode
                            ? (value) {
                                onApplySettings(
                                  settings.copyWith(smartGeneratorMode: value),
                                  reseed: true,
                                );
                              }
                            : null,
                      ),
                      if (_usesKeyMode && settings.smartGeneratorMode) ...[
                        const SizedBox(height: 24),
                        _SettingsSectionTitle(
                          text: l10n.advancedSmartGenerator,
                        ),
                        DropdownButtonFormField<ModulationIntensity>(
                          key: const ValueKey('modulation-intensity-dropdown'),
                          initialValue: settings.modulationIntensity,
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
                                        _modulationIntensityLabel(l10n, value),
                                      ),
                                    ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            onApplySettings(
                              settings.copyWith(modulationIntensity: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<JazzPreset>(
                          key: const ValueKey('jazz-preset-dropdown'),
                          initialValue: settings.jazzPreset,
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
                            onApplySettings(
                              settings.copyWith(jazzPreset: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<SourceProfile>(
                          key: const ValueKey('source-profile-dropdown'),
                          initialValue: settings.sourceProfile,
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
                            onApplySettings(
                              settings.copyWith(sourceProfile: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('smart-diagnostics-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.smartDiagnostics),
                          subtitle: Text(l10n.smartDiagnosticsHelp),
                          value: settings.smartDiagnosticsEnabled,
                          onChanged: (value) {
                            onApplySettings(
                              settings.copyWith(smartDiagnosticsEnabled: value),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 12),
                      _SettingsSectionTitle(text: l10n.nonDiatonic),
                      if (!_usesKeyMode)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.nonDiatonicRequiresKeyMode,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            label: Text(l10n.secondaryDominant),
                            selected: settings.secondaryDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    onApplySettings(
                                      settings.copyWith(
                                        secondaryDominantEnabled: selected,
                                      ),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                          FilterChip(
                            label: Text(l10n.substituteDominant),
                            selected: settings.substituteDominantEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    onApplySettings(
                                      settings.copyWith(
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
                            selected: settings.modalInterchangeEnabled,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    onApplySettings(
                                      settings.copyWith(
                                        modalInterchangeEnabled: selected,
                                      ),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                      if (!_usesKeyMode)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            l10n.modalInterchangeDisabledHelp,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _SettingsSectionTitle(text: l10n.rendering),
                      DropdownButtonFormField<ChordSymbolStyle>(
                        key: const ValueKey('chord-symbol-style-dropdown'),
                        initialValue: settings.chordSymbolStyle,
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.chordSymbolStyle,
                          helperText: l10n.chordSymbolStyleHelp,
                        ),
                        items: ChordSymbolStyle.values
                            .map((style) {
                              final label = switch (style) {
                                ChordSymbolStyle.compact => l10n.styleCompact,
                                ChordSymbolStyle.majText => l10n.styleMajText,
                                ChordSymbolStyle.deltaJazz =>
                                  l10n.styleDeltaJazz,
                              };
                              return DropdownMenuItem<ChordSymbolStyle>(
                                value: style,
                                child: Text(
                                  '$label  ${ChordSymbolFormatter.example(style)}',
                                ),
                              );
                            })
                            .toList(growable: false),
                        selectedItemBuilder: (context) {
                          return ChordSymbolStyle.values
                              .map((style) {
                                final label = switch (style) {
                                  ChordSymbolStyle.compact => l10n.styleCompact,
                                  ChordSymbolStyle.majText => l10n.styleMajText,
                                  ChordSymbolStyle.deltaJazz =>
                                    l10n.styleDeltaJazz,
                                };
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    label,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              })
                              .toList(growable: false);
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          onApplySettings(
                            settings.copyWith(chordSymbolStyle: value),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilterChip(
                            key: const ValueKey('allow-v7sus4-chip'),
                            label: Text(l10n.allowV7sus4),
                            selected: settings.allowV7sus4,
                            showCheckmark: false,
                            onSelected: _usesKeyMode
                                ? (selected) {
                                    onApplySettings(
                                      settings.copyWith(allowV7sus4: selected),
                                      reseed: true,
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_usesKeyMode) ...[
                        SwitchListTile.adaptive(
                          key: const ValueKey('allow-tensions-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.allowTensions),
                          subtitle: Text(l10n.tensionHelp),
                          value: settings.allowTensions,
                          onChanged: (value) {
                            onApplySettings(
                              settings.copyWith(allowTensions: value),
                              reseed: true,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ChordRenderingHelper.supportedTensionOptions
                              .map((tension) {
                                return FilterChip(
                                  key: ValueKey('tension-chip-$tension'),
                                  label: Text(tension),
                                  selected: settings.selectedTensionOptions
                                      .contains(tension),
                                  showCheckmark: false,
                                  onSelected: settings.allowTensions
                                      ? (selected) {
                                          final nextTensions = <String>{
                                            ...settings.selectedTensionOptions,
                                          };
                                          if (selected) {
                                            nextTensions.add(tension);
                                          } else {
                                            nextTensions.remove(tension);
                                          }
                                          onApplySettings(
                                            settings.copyWith(
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
                        const SizedBox(height: 20),
                      ],
                      _SettingsSectionTitle(text: l10n.voicingSuggestionsTitle),
                      SwitchListTile.adaptive(
                        key: const ValueKey('voicing-suggestions-toggle'),
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.voicingSuggestionsEnabled),
                        subtitle: Text(l10n.voicingSuggestionsHelp),
                        value: settings.voicingSuggestionsEnabled,
                        onChanged: (value) {
                          onApplySettings(
                            settings.copyWith(voicingSuggestionsEnabled: value),
                          );
                        },
                      ),
                      if (settings.voicingSuggestionsEnabled) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<VoicingComplexity>(
                          key: const ValueKey('voicing-complexity-dropdown'),
                          initialValue: settings.voicingComplexity,
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
                            onApplySettings(
                              settings.copyWith(voicingComplexity: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<VoicingTopNotePreference>(
                          key: const ValueKey('voicing-top-note-dropdown'),
                          initialValue: settings.voicingTopNotePreference,
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
                            onApplySettings(
                              settings.copyWith(
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
                          value: settings.allowRootlessVoicings,
                          onChanged: (value) {
                            onApplySettings(
                              settings.copyWith(allowRootlessVoicings: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: const ValueKey('max-voicing-notes-dropdown'),
                          initialValue: settings.maxVoicingNotes,
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
                            onApplySettings(
                              settings.copyWith(maxVoicingNotes: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          key: const ValueKey('look-ahead-depth-dropdown'),
                          initialValue: settings.lookAheadDepth,
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
                            onApplySettings(
                              settings.copyWith(lookAheadDepth: value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile.adaptive(
                          key: const ValueKey('show-voicing-reasons-toggle'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.showVoicingReasons),
                          subtitle: Text(l10n.showVoicingReasonsHelp),
                          value: settings.showVoicingReasons,
                          onChanged: (value) {
                            onApplySettings(
                              settings.copyWith(showVoicingReasons: value),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(l10n.inversions, style: theme.textTheme.titleMedium),
                      SwitchListTile.adaptive(
                        key: const ValueKey('enable-inversions-toggle'),
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.enableInversions),
                        subtitle: Text(l10n.inversionHelp),
                        value: settings.inversionSettings.enabled,
                        onChanged: (value) {
                          onApplySettings(
                            settings.copyWith(
                              inversionSettings: settings.inversionSettings
                                  .copyWith(enabled: value),
                            ),
                            reseed: true,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilterChip(
                              key: const ValueKey('first-inversion-chip'),
                              label: Text(l10n.firstInversion),
                              selected: settings
                                  .inversionSettings
                                  .firstInversionEnabled,
                              showCheckmark: false,
                              onSelected: settings.inversionSettings.enabled
                                  ? (selected) {
                                      onApplySettings(
                                        settings.copyWith(
                                          inversionSettings: settings
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
                              selected: settings
                                  .inversionSettings
                                  .secondInversionEnabled,
                              showCheckmark: false,
                              onSelected: settings.inversionSettings.enabled
                                  ? (selected) {
                                      onApplySettings(
                                        settings.copyWith(
                                          inversionSettings: settings
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
                              selected: settings
                                  .inversionSettings
                                  .thirdInversionEnabled,
                              showCheckmark: false,
                              onSelected: settings.inversionSettings.enabled
                                  ? (selected) {
                                      onApplySettings(
                                        settings.copyWith(
                                          inversionSettings: settings
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return switch (language) {
      AppLanguage.system => l10n.systemDefaultLanguage,
      _ => language.nativeLabel,
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

  String _voicingComplexityLabel(
    AppLocalizations l10n,
    VoicingComplexity value,
  ) {
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
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
