import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/chord_formatting.dart';
import '../music/chord_theory.dart';
import 'practice_settings_dispatcher.dart';
import 'practice_settings.dart';

class PracticeSettingsDrawer extends StatelessWidget {
  const PracticeSettingsDrawer({
    super.key,
    required this.settings,
    required this.onClose,
    required this.onOpenAdvancedSettings,
    required this.onApplySettings,
  });

  final PracticeSettings settings;
  final VoidCallback onClose;
  final VoidCallback onOpenAdvancedSettings;
  final ApplyPracticeSettings onApplySettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
                          dispatcher.apply(
                            (current) => current.copyWith(language: value),
                          );
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
                          dispatcher.apply(
                            (current) =>
                                current.copyWith(metronomeEnabled: value),
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
                          dispatcher.apply(
                            (current) =>
                                current.copyWith(metronomeSound: value),
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
                                dispatcher.apply(
                                  (current) =>
                                      current.copyWith(metronomeVolume: value),
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
                          dispatcher.apply(
                            (current) =>
                                current.copyWith(chordSymbolStyle: value),
                          );
                        },
                      ),
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
                                child: Text(
                                  _keyCenterLabelStyleLabel(l10n, style),
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
                                current.copyWith(keyCenterLabelStyle: value),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
