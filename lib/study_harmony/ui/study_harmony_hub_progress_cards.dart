part of '../../study_harmony_page.dart';

class _HubQuestCard extends StatelessWidget {
  const _HubQuestCard({required this.data});

  final _HubQuestCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-quest-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: data.progressFraction,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HubMilestoneCard extends StatelessWidget {
  const _HubMilestoneCard({required this.data});

  final _HubMilestoneCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-milestone-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 7,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HubWeeklyGoalCard extends StatelessWidget {
  const _HubWeeklyGoalCard({required this.data});

  final _HubWeeklyGoalCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      key: ValueKey('study-harmony-weekly-goal-card-${data.id}'),
      elevation: 0,
      color: _hubCardColor(colorScheme),
      shape: _hubCardShape(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HubIconBadge(icon: data.icon),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.progressFraction,
              minHeight: 7,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 10),
            Text(
              data.progressLabel,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (data.badgeLabels.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final badge in data.badgeLabels)
                    Chip(
                      label: Text(badge),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
