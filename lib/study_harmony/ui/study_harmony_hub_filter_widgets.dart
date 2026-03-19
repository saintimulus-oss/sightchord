part of '../../study_harmony_page.dart';

class _HubIconBadge extends StatelessWidget {
  const _HubIconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox.square(
        dimension: 44,
        child: Icon(icon, color: colorScheme.primary),
      ),
    );
  }
}

class _TrackFilterBar extends StatelessWidget {
  const _TrackFilterBar({
    required this.selectedTrack,
    required this.options,
    required this.onChanged,
  });

  final _StudyHarmonyHubTrack selectedTrack;
  final List<_TrackFilterChipData> options;
  final ValueChanged<_StudyHarmonyHubTrack> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: _hubPanelDecoration(colorScheme),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final option in options)
              Builder(
                builder: (context) {
                  final isSelected = option.track == selectedTrack;
                  return ChoiceChip(
                    key: ValueKey(
                      'study-harmony-track-filter-${option.track.name}',
                    ),
                    selected: isSelected,
                    backgroundColor: colorScheme.surfaceContainerLow,
                    selectedColor: colorScheme.primaryContainer,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.18)
                          : colorScheme.outlineVariant,
                    ),
                    avatar: Icon(
                      option.icon,
                      size: 18,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    label: Text(option.label),
                    onSelected: (_) => onChanged(option.track),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
