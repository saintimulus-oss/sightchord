part of '../../study_harmony_page.dart';

class _HubHeroCard extends StatelessWidget {
  const _HubHeroCard({
    required this.title,
    required this.eyebrow,
    required this.subtitle,
    required this.body,
    required this.metrics,
    required this.recommendationCopy,
    required this.recommendationOnPressed,
  });

  final String title;
  final String eyebrow;
  final String subtitle;
  final String body;
  final List<_HubMetricChipData> metrics;
  final _HubRecommendationCopy? recommendationCopy;
  final VoidCallback? recommendationOnPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      child: Card(
        key: const ValueKey('study-harmony-hero-card'),
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 880;
              final copy = recommendationCopy;
              final heroCopy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: _hubPanelDecoration(colorScheme, accent: true),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        body,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final metric in metrics)
                        Chip(
                          avatar: Icon(metric.icon, size: 18),
                          label: Text(metric.label),
                        ),
                    ],
                  ),
                ],
              );
              final featuredCard = copy == null
                  ? const SizedBox.shrink()
                  : _HubActionCard(
                      icon: copy.icon,
                      title: copy.title,
                      headline: copy.headline,
                      supportingLabel: copy.supportingLabel,
                      body: copy.body,
                      actionLabel: copy.actionLabel,
                      onPressed: recommendationOnPressed,
                      footerLabels: copy.footerLabels,
                      dense: false,
                    );

              if (copy == null) {
                return heroCopy;
              }

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: heroCopy),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: featuredCard,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heroCopy, const SizedBox(height: 16), featuredCard],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HubActionCard extends StatelessWidget {
  const _HubActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.headline,
    required this.supportingLabel,
    required this.body,
    this.actionLabel,
    required this.onPressed,
    this.footerLabels = const <String>[],
    this.dense = true,
    this.showAction = true,
  });

  final IconData icon;
  final String title;
  final String headline;
  final String supportingLabel;
  final String body;
  final String? actionLabel;
  final VoidCallback? onPressed;
  final List<String> footerLabels;
  final bool dense;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MergeSemantics(
      child: Card(
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(dense ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HubIconBadge(icon: icon),
              SizedBox(height: dense ? 12 : 14),
              Text(
                title,
                style:
                    (dense
                            ? theme.textTheme.titleSmall
                            : theme.textTheme.titleMedium)
                        ?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
              ),
              const SizedBox(height: 8),
              Text(
                headline,
                maxLines: dense ? 2 : null,
                overflow: dense ? TextOverflow.ellipsis : TextOverflow.visible,
                style:
                    (dense
                            ? theme.textTheme.titleLarge
                            : theme.textTheme.headlineSmall)
                        ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                supportingLabel,
                maxLines: dense ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                maxLines: dense ? 3 : null,
                overflow: dense ? TextOverflow.ellipsis : TextOverflow.visible,
                style:
                    (dense
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
              ),
              if (footerLabels.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final footer in footerLabels)
                      Chip(
                        label: Text(footer),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
              if (showAction)
                if (actionLabel case final label?) ...[
                  SizedBox(height: dense ? 14 : 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: dense
                          ? FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(44),
                            )
                          : null,
                      onPressed: onPressed,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(label),
                    ),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
