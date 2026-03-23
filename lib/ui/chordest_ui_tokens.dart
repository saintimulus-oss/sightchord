import 'package:flutter/material.dart';

class ChordestUiTokens {
  const ChordestUiTokens._();

  static const double radiusSm = 16;
  static const double radiusMd = 22;
  static const double radiusLg = 30;
  static const double radiusXl = 36;

  static BorderRadius radius(double value) => BorderRadius.circular(value);

  static List<BoxShadow> panelShadows(
    ThemeData theme, {
    bool accent = false,
    bool elevated = false,
  }) {
    final colorScheme = theme.colorScheme;
    final baseShadow = colorScheme.shadow.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.24 : 0.08,
    );
    final accentShadow = colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08,
    );
    return [
      BoxShadow(
        color: baseShadow,
        blurRadius: elevated ? 36 : 26,
        offset: Offset(0, elevated ? 20 : 14),
      ),
      if (accent)
        BoxShadow(
          color: accentShadow,
          blurRadius: elevated ? 44 : 30,
          offset: const Offset(0, 12),
        ),
    ];
  }

  static BoxDecoration panelDecoration(
    ThemeData theme, {
    bool accent = false,
    bool elevated = false,
    double opacity = 0.96,
    BorderRadius? borderRadius,
  }) {
    final colorScheme = theme.colorScheme;
    return BoxDecoration(
      color: colorScheme.surface.withValues(alpha: opacity),
      borderRadius: borderRadius ?? radius(radiusLg),
      border: Border.all(
        color: accent
            ? colorScheme.primary.withValues(alpha: 0.2)
            : colorScheme.outlineVariant.withValues(alpha: 0.9),
      ),
      boxShadow: panelShadows(theme, accent: accent, elevated: elevated),
    );
  }

  static BoxDecoration innerPanelDecoration(
    ThemeData theme, {
    bool accent = false,
    BorderRadius? borderRadius,
    double opacity = 1,
  }) {
    final colorScheme = theme.colorScheme;
    return BoxDecoration(
      color: accent
          ? colorScheme.primaryContainer.withValues(alpha: 0.26 * opacity)
          : colorScheme.surfaceContainerLow.withValues(alpha: 0.92 * opacity),
      borderRadius: borderRadius ?? radius(radiusMd),
      border: Border.all(
        color: accent
            ? colorScheme.primary.withValues(alpha: 0.24)
            : colorScheme.outlineVariant.withValues(alpha: 0.8),
      ),
    );
  }

  static LinearGradient pageGradient(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final topTint = colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.12 : 0.05,
    );
    final sideTint = colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.06 : 0.02,
    );
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.alphaBlend(topTint, theme.scaffoldBackgroundColor),
        Color.alphaBlend(sideTint, theme.scaffoldBackgroundColor),
        theme.scaffoldBackgroundColor,
      ],
      stops: const [0, 0.35, 1],
    );
  }

  static TextStyle overlineStyle(ThemeData theme) {
    return (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.28,
    );
  }

  static ButtonStyle secondaryIconButtonStyle(
    ThemeData theme, {
    required bool selected,
    Size? minimumSize,
  }) {
    final colorScheme = theme.colorScheme;
    return IconButton.styleFrom(
      minimumSize: minimumSize ?? const Size.square(46),
      padding: const EdgeInsets.all(12),
      backgroundColor: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.72)
          : colorScheme.surfaceContainerLow.withValues(alpha: 0.96),
      foregroundColor: selected ? colorScheme.primary : colorScheme.onSurface,
      side: BorderSide(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.28)
            : colorScheme.outlineVariant.withValues(alpha: 0.84),
      ),
      shape: RoundedRectangleBorder(borderRadius: radius(radiusSm)),
    );
  }
}
