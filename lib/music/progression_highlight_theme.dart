import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'progression_analysis_models.dart';

enum ProgressionExplanationDetailLevel { concise, detailed, advanced }

enum ProgressionHighlightThemePreset {
  defaultTheme,
  highContrast,
  colorBlindSafe,
  custom,
}

extension ProgressionExplanationDetailLevelX
    on ProgressionExplanationDetailLevel {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ProgressionExplanationDetailLevel.concise =>
        l10n.chordAnalyzerDetailLevelConcise,
      ProgressionExplanationDetailLevel.detailed =>
        l10n.chordAnalyzerDetailLevelDetailed,
      ProgressionExplanationDetailLevel.advanced =>
        l10n.chordAnalyzerDetailLevelAdvanced,
    };
  }

  static ProgressionExplanationDetailLevel fromStorageKey(String? value) {
    return ProgressionExplanationDetailLevel.values.firstWhere(
      (level) => level.storageKey == value,
      orElse: () => ProgressionExplanationDetailLevel.concise,
    );
  }
}

extension ProgressionHighlightThemePresetX on ProgressionHighlightThemePreset {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ProgressionHighlightThemePreset.defaultTheme =>
        l10n.chordAnalyzerThemePresetDefault,
      ProgressionHighlightThemePreset.highContrast =>
        l10n.chordAnalyzerThemePresetHighContrast,
      ProgressionHighlightThemePreset.colorBlindSafe =>
        l10n.chordAnalyzerThemePresetColorBlindSafe,
      ProgressionHighlightThemePreset.custom =>
        l10n.chordAnalyzerThemePresetCustom,
    };
  }

  static ProgressionHighlightThemePreset fromStorageKey(String? value) {
    return ProgressionHighlightThemePreset.values.firstWhere(
      (preset) => preset.storageKey == value,
      orElse: () => ProgressionHighlightThemePreset.defaultTheme,
    );
  }
}

extension ProgressionHighlightCategoryX on ProgressionHighlightCategory {
  String get storageKey => name;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ProgressionHighlightCategory.appliedDominant =>
        l10n.chordAnalyzerHighlightAppliedDominant,
      ProgressionHighlightCategory.tritoneSubstitute =>
        l10n.chordAnalyzerHighlightTritoneSubstitute,
      ProgressionHighlightCategory.tonicization =>
        l10n.chordAnalyzerHighlightTonicization,
      ProgressionHighlightCategory.modulation =>
        l10n.chordAnalyzerHighlightModulation,
      ProgressionHighlightCategory.backdoor =>
        l10n.chordAnalyzerHighlightBackdoor,
      ProgressionHighlightCategory.borrowedColor =>
        l10n.chordAnalyzerHighlightBorrowedColor,
      ProgressionHighlightCategory.commonTone =>
        l10n.chordAnalyzerHighlightCommonTone,
      ProgressionHighlightCategory.deceptiveCadence =>
        l10n.chordAnalyzerHighlightDeceptiveCadence,
      ProgressionHighlightCategory.chromaticLine =>
        l10n.chordAnalyzerHighlightChromaticLine,
      ProgressionHighlightCategory.ambiguity =>
        l10n.chordAnalyzerHighlightAmbiguity,
    };
  }

  static ProgressionHighlightCategory? fromStorageKey(String? value) {
    for (final category in ProgressionHighlightCategory.values) {
      if (category.storageKey == value) {
        return category;
      }
    }
    return null;
  }
}

class ProgressionHighlightTheme {
  ProgressionHighlightTheme({
    this.preset = ProgressionHighlightThemePreset.defaultTheme,
    Map<ProgressionHighlightCategory, int>? colorValues,
  }) : colorValues = colorValues == null
           ? const <ProgressionHighlightCategory, int>{}
           : Map.unmodifiable(colorValues);

  static const int storageVersion = 1;

  static const List<int> customPalette = <int>[
    0xFFF59E0B,
    0xFFEF4444,
    0xFF3B82F6,
    0xFF10B981,
    0xFF8B5CF6,
    0xFF14B8A6,
    0xFFF97316,
    0xFF6366F1,
    0xFF334155,
    0xFFD97706,
  ];

  final ProgressionHighlightThemePreset preset;
  final Map<ProgressionHighlightCategory, int> colorValues;

  factory ProgressionHighlightTheme.fromStorageString(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map<String, dynamic>) {
        return ProgressionHighlightTheme();
      }
      final preset = ProgressionHighlightThemePresetX.fromStorageKey(
        decoded['preset'] as String?,
      );
      final colorMap = <ProgressionHighlightCategory, int>{};
      final colors = decoded['colors'];
      if (colors is Map<String, dynamic>) {
        colors.forEach((key, rawValue) {
          final category = ProgressionHighlightCategoryX.fromStorageKey(key);
          if (category == null) {
            return;
          }
          if (rawValue is int) {
            colorMap[category] = rawValue;
            return;
          }
          if (rawValue is String) {
            colorMap[category] =
                int.tryParse(rawValue) ?? colorMap[category] ?? 0;
          }
        });
      }
      return ProgressionHighlightTheme(
        preset: preset,
        colorValues: colorMap,
      ).normalized();
    } catch (_) {
      return ProgressionHighlightTheme();
    }
  }

  ProgressionHighlightTheme normalized() {
    final resolved = resolvedColorValues;
    return ProgressionHighlightTheme(preset: preset, colorValues: resolved);
  }

  ProgressionHighlightTheme withPreset(
    ProgressionHighlightThemePreset nextPreset,
  ) {
    if (nextPreset == ProgressionHighlightThemePreset.custom) {
      return ProgressionHighlightTheme(
        preset: nextPreset,
        colorValues: resolvedColorValues,
      );
    }
    return ProgressionHighlightTheme(
      preset: nextPreset,
      colorValues: _paletteForPreset(nextPreset),
    );
  }

  ProgressionHighlightTheme withColor(
    ProgressionHighlightCategory category,
    Color color,
  ) {
    final nextColors = {...resolvedColorValues, category: color.toARGB32()};
    return ProgressionHighlightTheme(
      preset: ProgressionHighlightThemePreset.custom,
      colorValues: nextColors,
    );
  }

  Map<ProgressionHighlightCategory, int> get resolvedColorValues => {
    for (final category in ProgressionHighlightCategory.values)
      category: colorValueFor(category),
  };

  int colorValueFor(ProgressionHighlightCategory category) {
    final stored = colorValues[category];
    if (stored != null) {
      return stored;
    }
    return _paletteForPreset(preset)[category] ?? _defaultPalette[category]!;
  }

  Color colorFor(ProgressionHighlightCategory category) {
    return Color(colorValueFor(category));
  }

  String toStorageString() {
    return jsonEncode({
      'version': storageVersion,
      'preset': preset.storageKey,
      'colors': {
        for (final entry in resolvedColorValues.entries)
          entry.key.storageKey: entry.value,
      },
    });
  }

  static Map<ProgressionHighlightCategory, int> _paletteForPreset(
    ProgressionHighlightThemePreset preset,
  ) {
    return switch (preset) {
      ProgressionHighlightThemePreset.defaultTheme => _defaultPalette,
      ProgressionHighlightThemePreset.highContrast => _highContrastPalette,
      ProgressionHighlightThemePreset.colorBlindSafe => _colorBlindSafePalette,
      ProgressionHighlightThemePreset.custom => _defaultPalette,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ProgressionHighlightTheme &&
        other.preset == preset &&
        _sameColorValues(other.resolvedColorValues, resolvedColorValues);
  }

  @override
  int get hashCode => Object.hash(
    preset,
    Object.hashAll(
      ProgressionHighlightCategory.values.map(
        (category) => Object.hash(category, colorValueFor(category)),
      ),
    ),
  );

  static const Map<ProgressionHighlightCategory, int> _defaultPalette = {
    ProgressionHighlightCategory.appliedDominant: 0xFFF59E0B,
    ProgressionHighlightCategory.tritoneSubstitute: 0xFFE76F51,
    ProgressionHighlightCategory.tonicization: 0xFFE9C46A,
    ProgressionHighlightCategory.modulation: 0xFF3B82F6,
    ProgressionHighlightCategory.backdoor: 0xFF2A9D8F,
    ProgressionHighlightCategory.borrowedColor: 0xFF8B5CF6,
    ProgressionHighlightCategory.commonTone: 0xFF14B8A6,
    ProgressionHighlightCategory.deceptiveCadence: 0xFFF97316,
    ProgressionHighlightCategory.chromaticLine: 0xFF6366F1,
    ProgressionHighlightCategory.ambiguity: 0xFF64748B,
  };

  static const Map<ProgressionHighlightCategory, int> _highContrastPalette = {
    ProgressionHighlightCategory.appliedDominant: 0xFF9A6700,
    ProgressionHighlightCategory.tritoneSubstitute: 0xFFB00020,
    ProgressionHighlightCategory.tonicization: 0xFF8A6A00,
    ProgressionHighlightCategory.modulation: 0xFF0047FF,
    ProgressionHighlightCategory.backdoor: 0xFF005C4B,
    ProgressionHighlightCategory.borrowedColor: 0xFF5B21B6,
    ProgressionHighlightCategory.commonTone: 0xFF115E59,
    ProgressionHighlightCategory.deceptiveCadence: 0xFF9A3412,
    ProgressionHighlightCategory.chromaticLine: 0xFF312E81,
    ProgressionHighlightCategory.ambiguity: 0xFF111827,
  };

  static const Map<ProgressionHighlightCategory, int> _colorBlindSafePalette = {
    ProgressionHighlightCategory.appliedDominant: 0xFFE69F00,
    ProgressionHighlightCategory.tritoneSubstitute: 0xFFD55E00,
    ProgressionHighlightCategory.tonicization: 0xFFF0E442,
    ProgressionHighlightCategory.modulation: 0xFF0072B2,
    ProgressionHighlightCategory.backdoor: 0xFF009E73,
    ProgressionHighlightCategory.borrowedColor: 0xFFCC79A7,
    ProgressionHighlightCategory.commonTone: 0xFF56B4E9,
    ProgressionHighlightCategory.deceptiveCadence: 0xFF000000,
    ProgressionHighlightCategory.chromaticLine: 0xFF7A7A00,
    ProgressionHighlightCategory.ambiguity: 0xFF666666,
  };

  static bool _sameColorValues(
    Map<ProgressionHighlightCategory, int> left,
    Map<ProgressionHighlightCategory, int> right,
  ) {
    if (left.length != right.length) {
      return false;
    }
    for (final category in ProgressionHighlightCategory.values) {
      if (left[category] != right[category]) {
        return false;
      }
    }
    return true;
  }
}
