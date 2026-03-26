import 'package:flutter/material.dart';

const _mainMenuContentMaxWidth = 560.0;

class MainMenuView extends StatelessWidget {
  const MainMenuView({
    super.key,
    required this.title,
    required this.intro,
    required this.settingsLabel,
    required this.generatorTitle,
    required this.generatorSubtitle,
    required this.analyzerTitle,
    required this.analyzerSubtitle,
    required this.onOpenSettings,
    required this.onOpenGenerator,
    required this.onOpenAnalyzer,
  });

  final String title;
  final String intro;
  final String settingsLabel;
  final String generatorTitle;
  final String generatorSubtitle;
  final String analyzerTitle;
  final String analyzerSubtitle;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenGenerator;
  final VoidCallback onOpenAnalyzer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -120,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.18),
                      colorScheme.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: const SizedBox(width: 380, height: 380),
              ),
            ),
          ),
          Positioned(
            right: -140,
            bottom: -180,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.6),
                      colorScheme.primaryContainer.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: const SizedBox(width: 420, height: 420),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MainMenuHeroCard(
                        title: title,
                        body: intro,
                        settingsLabel: settingsLabel,
                        onSettingsPressed: onOpenSettings,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _mainMenuContentMaxWidth,
                          ),
                          child: _MainActionButton(
                            icon: Icons.auto_awesome_rounded,
                            title: generatorTitle,
                            subtitle: generatorSubtitle,
                            isPrimary: true,
                            buttonKey: const ValueKey(
                              'main-open-generator-button',
                            ),
                            onPressed: onOpenGenerator,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _mainMenuContentMaxWidth,
                          ),
                          child: _MainActionButton(
                            icon: Icons.insights_rounded,
                            title: analyzerTitle,
                            subtitle: analyzerSubtitle,
                            buttonKey: const ValueKey(
                              'main-open-analyzer-button',
                            ),
                            onPressed: onOpenAnalyzer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainMenuHeroCard extends StatelessWidget {
  const _MainMenuHeroCard({
    required this.title,
    required this.body,
    required this.settingsLabel,
    required this.onSettingsPressed,
  });

  final String title;
  final String body;
  final String settingsLabel;
  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _mainMenuContentMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  key: const ValueKey('main-open-settings-button'),
                  onPressed: onSettingsPressed,
                  tooltip: settingsLabel,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerLow,
                    foregroundColor: colorScheme.onSurface,
                  ),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              body,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainActionButton extends StatelessWidget {
  const _MainActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonKey,
    this.isPrimary = false,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ValueKey<String> buttonKey;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isPrimary
        ? colorScheme.primary
        : colorScheme.surfaceContainerLow.withValues(alpha: 0.9);
    final foregroundColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final subtitleColor = isPrimary
        ? colorScheme.onPrimary.withValues(alpha: 0.78)
        : colorScheme.onSurfaceVariant;
    final arrowColor = isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: buttonKey,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: isPrimary
                ? null
                : Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              if (isPrimary)
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.14)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: foregroundColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_forward_rounded, color: arrowColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
