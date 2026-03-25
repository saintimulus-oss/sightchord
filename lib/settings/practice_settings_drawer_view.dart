import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import '../music/notation_presentation.dart';
import '../release_feature_flags.dart';
import 'metronome_custom_sound_service.dart';
import 'practice_setup_models.dart';
import 'practice_settings_dispatcher.dart';
import 'practice_settings.dart';
import 'practice_settings_factory.dart';

class PracticeSettingsDrawer extends StatefulWidget {
  const PracticeSettingsDrawer({
    super.key,
    required this.settings,
    required this.onClose,
    required this.onRunSetupAssistant,
    this.onOpenStudyHarmony,
    required this.onOpenAdvancedSettings,
    required this.onApplySettings,
    this.metronomeCustomSoundService,
  });

  final PracticeSettings settings;
  final VoidCallback onClose;
  final VoidCallback onRunSetupAssistant;
  final VoidCallback? onOpenStudyHarmony;
  final VoidCallback onOpenAdvancedSettings;
  final ApplyPracticeSettings onApplySettings;
  final MetronomeCustomSoundService? metronomeCustomSoundService;

  @override
  State<PracticeSettingsDrawer> createState() => _PracticeSettingsDrawerState();
}

class _PracticeSettingsDrawerState extends State<PracticeSettingsDrawer> {
  bool _isSetupCardExpanded = true;
  bool _primaryMetronomeUploadInProgress = false;
  late final MetronomeCustomSoundService _metronomeCustomSoundService =
      widget.metronomeCustomSoundService ?? createMetronomeCustomSoundService();

  PracticeSettings get settings => widget.settings;
  VoidCallback get onClose => widget.onClose;
  VoidCallback get onRunSetupAssistant => widget.onRunSetupAssistant;
  VoidCallback? get onOpenStudyHarmony =>
      kEnableStudyHarmonyEntryPoints ? widget.onOpenStudyHarmony : null;
  VoidCallback get onOpenAdvancedSettings => widget.onOpenAdvancedSettings;
  ApplyPracticeSettings get onApplySettings => widget.onApplySettings;

  bool get _isGuidedMode =>
      settings.settingsComplexityMode == SettingsComplexityMode.guided;

  Future<void> _uploadPrimaryCustomMetronome() async {
    if (_primaryMetronomeUploadInProgress) {
      return;
    }
    setState(() {
      _primaryMetronomeUploadInProgress = true;
    });
    try {
      final selection = await _metronomeCustomSoundService.pickAndStore(
        slot: MetronomeCustomSoundSlot.primary,
        fallbackSound: settings.metronomeSound,
      );
      if (!mounted || selection == null) {
        return;
      }
      onApplySettings(settings.copyWith(metronomeSource: selection.source));
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
      if (mounted) {
        setState(() {
          _primaryMetronomeUploadInProgress = false;
        });
      }
    }
  }

  Future<void> _resetPrimaryCustomMetronome() async {
    if (_primaryMetronomeUploadInProgress) {
      return;
    }
    setState(() {
      _primaryMetronomeUploadInProgress = true;
    });
    try {
      await _metronomeCustomSoundService.clearSlot(
        slot: MetronomeCustomSoundSlot.primary,
      );
      if (!mounted) {
        return;
      }
      onApplySettings(
        settings.copyWith(
          metronomeSource: MetronomeSourceSpec.builtIn(
            sound: settings.metronomeSound,
          ),
        ),
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
      if (mounted) {
        setState(() {
          _primaryMetronomeUploadInProgress = false;
        });
      }
    }
  }

  void _showMetronomeMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dispatcher = PracticeSettingsDispatcher(
      settings: settings,
      onApplySettings: onApplySettings,
    );

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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: _isGuidedMode
                      ? _buildGuidedContent(context, dispatcher)
                      : _buildStandardContent(context, dispatcher),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: _buildAdvancedSettingsButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidedContent(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSetupCard(context, dispatcher, guidedMode: true),
        if (_shouldShowStudyHarmonyCta) ...[
          const SizedBox(height: 16),
          _buildStudyHarmonyCard(context),
        ],
        const SizedBox(height: 24),
        _buildLanguageSection(context, dispatcher),
        const SizedBox(height: 24),
        _buildRenderingSection(
          context,
          dispatcher,
          includeKeyCenterLabelStyle: false,
        ),
        const SizedBox(height: 24),
        _buildMetronomeSection(context, dispatcher),
      ],
    );
  }

  Widget _buildStandardContent(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSetupCard(context, dispatcher, guidedMode: false),
        const SizedBox(height: 24),
        _buildLanguageSection(context, dispatcher),
        const SizedBox(height: 24),
        _buildMetronomeSection(context, dispatcher),
        const SizedBox(height: 24),
        _buildRenderingSection(
          context,
          dispatcher,
          includeKeyCenterLabelStyle: true,
        ),
      ],
    );
  }

  Widget _buildSetupCard(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher, {
    required bool guidedMode,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profile = PracticeSettingsFactory.profileFromSettings(settings);
    final title = guidedMode
        ? l10n.setupAssistantGuidedSettingsTitle
        : l10n.setupAssistantTitle;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              key: const ValueKey('settings-setup-card-toggle'),
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _isSetupCardExpanded = !_isSetupCardExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(
                              '${l10n.setupAssistantCurrentMode}: '
                              '${_settingsComplexityModeLabel(l10n)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        _isSetupCardExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isSetupCardExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!guidedMode) ...[
                      Text(
                        l10n.setupAssistantCardBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    _buildComplexityModeSelector(context, dispatcher),
                    const SizedBox(height: 16),
                    Text(
                      _profileSummaryTitle(l10n, profile),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SummaryRow(
                      label: l10n.setupAssistantPreviewDifficultyLabel,
                      value: _difficultySummaryLabel(l10n, settings),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: l10n.setupAssistantPreviewKeyLabel,
                      value: _keyCenterLabel(l10n, _primaryKeyCenter),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: l10n.setupAssistantPreviewNotationLabel,
                      value: _notationSummaryLabel(
                        l10n,
                        settings.chordSymbolStyle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: l10n.setupAssistantPreviewProgressionLabel,
                      value: _profileSummaryBody(l10n, settings),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        key: const ValueKey('rerun-setup-assistant-button'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Future<void>.delayed(
                            const Duration(milliseconds: 220),
                            onRunSetupAssistant,
                          );
                        },
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: Text(l10n.setupAssistantRunAgain),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplexityModeSelector(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.setupAssistantCurrentMode,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mode in SettingsComplexityMode.values)
              ChoiceChip(
                key: ValueKey('settings-complexity-mode-${mode.name}'),
                label: Text(_settingsComplexityModeOptionLabel(l10n, mode)),
                selected: settings.settingsComplexityMode == mode,
                onSelected: (selected) {
                  if (!selected || settings.settingsComplexityMode == mode) {
                    return;
                  }
                  dispatcher.apply(
                    (current) => current.copyWith(
                      guidedSetupCompleted: true,
                      settingsComplexityMode: mode,
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStudyHarmonyCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.setupAssistantStudyHarmonyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.setupAssistantStudyHarmonyBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            if (onOpenStudyHarmony != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Future<void>.delayed(
                    const Duration(milliseconds: 220),
                    onOpenStudyHarmony!,
                  );
                },
                icon: const Icon(Icons.school_rounded),
                label: Text(l10n.setupAssistantStudyHarmonyCta),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
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
            dispatcher.apply((current) => current.copyWith(language: value));
          },
        ),
      ],
    );
  }

  Widget _buildMetronomeSection(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsSectionTitle(text: l10n.metronome),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.metronome),
          subtitle: Text(
            settings.metronomeEnabled ? l10n.enabled : l10n.disabled,
          ),
          value: settings.metronomeEnabled,
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(metronomeEnabled: value),
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
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.metronomeSource.kind == MetronomeSourceKind.localFile
                      ? l10n.metronomeCustomSoundStatusFile(
                          settings.metronomeSource.localFileName,
                        )
                      : l10n.metronomeCustomSoundStatusBuiltIn,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.metronomeCustomSoundHelp,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                if (_metronomeCustomSoundService.isSupported) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        key: const ValueKey(
                          'metronome-custom-sound-upload-button',
                        ),
                        onPressed: _primaryMetronomeUploadInProgress
                            ? null
                            : _uploadPrimaryCustomMetronome,
                        icon: Icon(
                          settings.metronomeSource.kind ==
                                  MetronomeSourceKind.localFile
                              ? Icons.upload_file_rounded
                              : Icons.audio_file_rounded,
                        ),
                        label: Text(
                          settings.metronomeSource.kind ==
                                  MetronomeSourceKind.localFile
                              ? l10n.metronomeCustomSoundReplace
                              : l10n.metronomeCustomSoundUpload,
                        ),
                      ),
                      if (settings.metronomeSource.kind ==
                          MetronomeSourceKind.localFile)
                        TextButton(
                          key: const ValueKey(
                            'metronome-custom-sound-reset-button',
                          ),
                          onPressed: _primaryMetronomeUploadInProgress
                              ? null
                              : _resetPrimaryCustomMetronome,
                          child: Text(l10n.metronomeCustomSoundReset),
                        ),
                    ],
                  ),
                ],
              ],
            ),
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
            dispatcher.apply(
              (current) => current.copyWith(metronomeSound: value),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(l10n.metronomeVolume, style: theme.textTheme.titleMedium),
        Slider(
          value: settings.metronomeVolume,
          onChanged: settings.metronomeEnabled
              ? (value) {
                  dispatcher.apply(
                    (current) => current.copyWith(metronomeVolume: value),
                  );
                }
              : null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${(settings.metronomeVolume * 100).round()}%'),
        ),
      ],
    );
  }

  Widget _buildRenderingSection(
    BuildContext context,
    PracticeSettingsDispatcher dispatcher, {
    required bool includeKeyCenterLabelStyle,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  ChordSymbolStyle.deltaJazz => l10n.styleDeltaJazz,
                };
                return DropdownMenuItem<ChordSymbolStyle>(
                  value: style,
                  child: Text(
                    '$label  ${ChordSymbolFormatter.example(style, preferences: settings.notationPreferences)}',
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
                    ChordSymbolStyle.deltaJazz => l10n.styleDeltaJazz,
                  };
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(label, overflow: TextOverflow.ellipsis),
                  );
                })
                .toList(growable: false);
          },
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(chordSymbolStyle: value),
            );
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<NoteNamingStyle>(
          key: const ValueKey('note-naming-style-dropdown'),
          initialValue: settings.noteNamingStyle,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.noteNamingStyle,
            helperText: l10n.noteNamingStyleHelp,
          ),
          items: NoteNamingStyle.values
              .map(
                (style) => DropdownMenuItem<NoteNamingStyle>(
                  value: style,
                  child: Text(style.localizedLabel(l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(noteNamingStyle: value),
            );
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<MusicNotationLocale>(
          key: const ValueKey('music-notation-locale-dropdown'),
          initialValue: settings.musicNotationLocale,
          isExpanded: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: l10n.musicNotationLocale,
            helperText: l10n.musicNotationLocaleHelp,
          ),
          items: MusicNotationLocale.values
              .map(
                (locale) => DropdownMenuItem<MusicNotationLocale>(
                  value: locale,
                  child: Text(locale.localizedLabel(l10n)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value == null) {
              return;
            }
            dispatcher.apply(
              (current) => current.copyWith(musicNotationLocale: value),
            );
          },
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          key: const ValueKey('show-roman-numeral-assist-toggle'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.showRomanNumeralAssist),
          subtitle: Text(l10n.showRomanNumeralAssistHelp),
          value: settings.showRomanNumeralAssist,
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(showRomanNumeralAssist: value),
            );
          },
        ),
        SwitchListTile.adaptive(
          key: const ValueKey('show-chord-text-assist-toggle'),
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.showChordTextAssist),
          subtitle: Text(l10n.showChordTextAssistHelp),
          value: settings.showChordTextAssist,
          onChanged: (value) {
            dispatcher.apply(
              (current) => current.copyWith(showChordTextAssist: value),
            );
          },
        ),
        if (includeKeyCenterLabelStyle) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<KeyCenterLabelStyle>(
            key: const ValueKey('key-center-label-style-dropdown'),
            initialValue: settings.keyCenterLabelStyle,
            isExpanded: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.keyCenterLabelStyle,
              helperText: l10n.keyCenterLabelStyleHelp,
            ),
            items: KeyCenterLabelStyle.values
                .map(
                  (style) => DropdownMenuItem<KeyCenterLabelStyle>(
                    value: style,
                    child: Text(_keyCenterLabelStyleLabel(l10n, style)),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              dispatcher.apply(
                (current) => current.copyWith(keyCenterLabelStyle: value),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAdvancedSettingsButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FilledButton.icon(
      key: const ValueKey('open-advanced-settings-button'),
      onPressed: () {
        Navigator.of(context).pop();
        Future<void>.delayed(
          const Duration(milliseconds: 220),
          onOpenAdvancedSettings,
        );
      },
      icon: const Icon(Icons.tune_rounded),
      label: Text('${l10n.jazzPresetAdvanced} ${l10n.settings}'),
    );
  }

  bool get _shouldShowStudyHarmonyCta {
    if (onOpenStudyHarmony == null) {
      return false;
    }
    final profile = PracticeSettingsFactory.profileFromSettings(settings);
    return profile.harmonyLiteracy == HarmonyLiteracy.absoluteBeginner;
  }

  KeyCenter get _primaryKeyCenter {
    final centers = settings.activeKeyCenters.toList(growable: false);
    if (centers.isEmpty) {
      return GeneratorProfile.defaultStartingKeyCenter;
    }
    centers.sort((a, b) {
      final modeCompare = a.mode.index.compareTo(b.mode.index);
      if (modeCompare != 0) {
        return modeCompare;
      }
      return a.tonicName.compareTo(b.tonicName);
    });
    return centers.first;
  }

  String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return switch (language) {
      AppLanguage.system => l10n.systemDefaultLanguage,
      _ => language.nativeLabel,
    };
  }

  String _keyCenterLabelStyleLabel(
    AppLocalizations l10n,
    KeyCenterLabelStyle style,
  ) {
    return switch (style) {
      KeyCenterLabelStyle.modeText => l10n.keyCenterLabelStyleModeText,
      KeyCenterLabelStyle.classicalCase =>
        l10n.keyCenterLabelStyleClassicalCase,
    };
  }

  String _settingsComplexityModeLabel(AppLocalizations l10n) {
    return _settingsComplexityModeOptionLabel(
      l10n,
      settings.settingsComplexityMode,
    );
  }

  String _settingsComplexityModeOptionLabel(
    AppLocalizations l10n,
    SettingsComplexityMode mode,
  ) {
    return switch (mode) {
      SettingsComplexityMode.guided => l10n.setupAssistantModeGuided,
      SettingsComplexityMode.standard => l10n.setupAssistantModeStandard,
      SettingsComplexityMode.advanced => l10n.setupAssistantModeAdvanced,
    };
  }

  String _keyCenterLabel(AppLocalizations l10n, KeyCenter center) {
    return MusicNotationFormatter.formatKeyCenterLabel(
      center: center,
      labelStyle: KeyCenterLabelStyle.modeText,
      preferences: settings.notationPreferences,
      l10n: l10n,
    );
  }

  String _notationSummaryLabel(AppLocalizations l10n, ChordSymbolStyle style) {
    return switch (style) {
      ChordSymbolStyle.majText => l10n.setupAssistantNotationMajText,
      ChordSymbolStyle.compact => l10n.setupAssistantNotationCompact,
      ChordSymbolStyle.deltaJazz => l10n.setupAssistantNotationDelta,
    };
  }

  String _profileSummaryTitle(AppLocalizations l10n, GeneratorProfile profile) {
    return switch (profile.harmonyLiteracy) {
      HarmonyLiteracy.absoluteBeginner =>
        l10n.setupAssistantPreviewSummaryAbsolute,
      HarmonyLiteracy.basicChordReader =>
        l10n.setupAssistantPreviewSummaryBasic,
      HarmonyLiteracy.functionalHarmony =>
        l10n.setupAssistantPreviewSummaryFunctional,
      HarmonyLiteracy.reharmReady => l10n.setupAssistantPreviewSummaryAdvanced,
    };
  }

  String _difficultySummaryLabel(
    AppLocalizations l10n,
    PracticeSettings settings,
  ) {
    return switch (settings.chordLanguageLevel) {
      ChordLanguageLevel.triadsOnly => l10n.setupAssistantDifficultyTriads,
      ChordLanguageLevel.seventhChords => l10n.setupAssistantDifficultySevenths,
      ChordLanguageLevel.safeExtensions =>
        l10n.setupAssistantDifficultySafeExtensions,
      ChordLanguageLevel.fullExtensions =>
        l10n.setupAssistantDifficultyFullExtensions,
    };
  }

  String _profileSummaryBody(AppLocalizations l10n, PracticeSettings settings) {
    return switch (settings.chordLanguageLevel) {
      ChordLanguageLevel.triadsOnly => l10n.setupAssistantPreviewBodyTriads,
      ChordLanguageLevel.seventhChords =>
        l10n.setupAssistantPreviewBodySevenths,
      ChordLanguageLevel.safeExtensions =>
        l10n.setupAssistantPreviewBodySafeExtensions,
      ChordLanguageLevel.fullExtensions =>
        l10n.setupAssistantPreviewBodyFullExtensions,
    };
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
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
