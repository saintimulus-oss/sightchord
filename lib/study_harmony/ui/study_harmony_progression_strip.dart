import 'package:flutter/material.dart';

import '../domain/study_harmony_session_models.dart';

class StudyHarmonyProgressionStrip extends StatelessWidget {
  const StudyHarmonyProgressionStrip({super.key, required this.progression});

  final StudyHarmonyProgressionDisplaySpec progression;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      key: const ValueKey('study-harmony-progression-strip'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (progression.summaryLabel case final summary?) ...[
          Text(
            summary,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final slot in progression.slots)
              _ProgressionSlotCard(slot: slot),
          ],
        ),
      ],
    );
  }
}

class _ProgressionSlotCard extends StatelessWidget {
  const _ProgressionSlotCard({required this.slot});

  final StudyHarmonyProgressionSlotSpec slot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foregroundColor = slot.isHighlighted
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;
    final backgroundColor = slot.isHighlighted
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);

    return Container(
      key: ValueKey('study-harmony-progression-slot-${slot.id}'),
      constraints: const BoxConstraints(minWidth: 88),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: slot.isHighlighted
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (slot.measureLabel case final measureLabel?) ...[
            Text(
              measureLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: foregroundColor.withValues(alpha: 0.8),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            slot.isHidden ? '____' : slot.label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
