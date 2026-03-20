import 'package:flutter/material.dart';

class PracticeSetupPlaceholder extends StatelessWidget {
  const PracticeSetupPlaceholder({
    super.key,
    required this.complexityLabel,
    required this.title,
    required this.body,
  });

  final String complexityLabel;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      key: const ValueKey('practice-setup-placeholder'),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(complexityLabel)),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PracticeFirstRunWelcomeCard extends StatelessWidget {
  const PracticeFirstRunWelcomeCard({
    super.key,
    required this.title,
    required this.body,
    required this.closeTooltip,
    required this.playButtonLabel,
    required this.setupButtonLabel,
    required this.canPlayCurrentChord,
    required this.onDismiss,
    required this.onPlayCurrentChord,
    required this.onOpenSetupAssistant,
  });

  final String title;
  final String body;
  final String closeTooltip;
  final String playButtonLabel;
  final String setupButtonLabel;
  final bool canPlayCurrentChord;
  final VoidCallback onDismiss;
  final VoidCallback onPlayCurrentChord;
  final VoidCallback onOpenSetupAssistant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      key: const ValueKey('practice-first-run-welcome-card'),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.waving_hand_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  key: const ValueKey('dismiss-first-run-welcome-card'),
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: closeTooltip,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  key: const ValueKey('practice-first-run-play-button'),
                  onPressed: canPlayCurrentChord ? onPlayCurrentChord : null,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: Text(playButtonLabel),
                ),
                OutlinedButton.icon(
                  key: const ValueKey('practice-first-run-setup-button'),
                  onPressed: onOpenSetupAssistant,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(setupButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
