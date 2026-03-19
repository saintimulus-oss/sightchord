import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/explanation_models.dart';

class ExplanationBundlePanel extends StatelessWidget {
  const ExplanationBundlePanel({
    super.key,
    required this.bundle,
    this.compact = false,
  });

  final ExplanationBundle bundle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor(ConfidenceTone tone) {
      return switch (tone) {
        ConfidenceTone.strong => colorScheme.primaryContainer,
        ConfidenceTone.moderate => colorScheme.secondaryContainer,
        ConfidenceTone.cautious => colorScheme.errorContainer,
      };
    }

    Color badgeForeground(ConfidenceTone tone) {
      return switch (tone) {
        ConfidenceTone.strong => colorScheme.onPrimaryContainer,
        ConfidenceTone.moderate => colorScheme.onSecondaryContainer,
        ConfidenceTone.cautious => colorScheme.onErrorContainer,
      };
    }

    Widget sectionTitle(String title) {
      return Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(compact ? 18 : 22),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bundle.summary,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
            if (bundle.trackContext case final trackContext?) ...[
              const SizedBox(height: 10),
              Text(
                trackContext,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
            if (bundle.confidenceBadge != null ||
                bundle.ambiguityValue != null ||
                bundle.caution != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (bundle.confidenceBadge case final badge?)
                    Chip(
                      backgroundColor: badgeColor(badge.tone),
                      label: Text(
                        '${badge.label} ${(badge.value * 100).round()}%',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: badgeForeground(badge.tone),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  if (bundle.ambiguityValue case final ambiguity?)
                    Chip(
                      label: Text(
                        '${l10n.chordAnalyzerAmbiguityLabel} ${(ambiguity * 100).round()}%',
                      ),
                    ),
                  if (bundle.caution case final caution?)
                    Chip(
                      avatar: const Icon(Icons.info_outline_rounded, size: 18),
                      label: Text(caution),
                    ),
                ],
              ),
              if (bundle.confidenceBadge?.caption != null ||
                  bundle.ambiguityCaption != null) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bundle.confidenceBadge?.caption case final caption?)
                      Text(
                        caption,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    if (bundle.ambiguityCaption
                        case final ambiguityCaption?) ...[
                      if (bundle.confidenceBadge?.caption != null)
                        const SizedBox(height: 4),
                      Text(
                        ambiguityCaption,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
            if (bundle.reasonTags.isNotEmpty) ...[
              const SizedBox(height: 14),
              sectionTitle(l10n.explanationReasonSection),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final reason in bundle.reasonTags)
                    Tooltip(
                      message: reason.detail,
                      child: Chip(
                        label: Text(reason.label),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ],
            if (bundle.alternativeInterpretations.isNotEmpty) ...[
              const SizedBox(height: 14),
              sectionTitle(l10n.explanationAlternativeSection),
              const SizedBox(height: 8),
              for (final alternative in bundle.alternativeInterpretations) ...[
                _HintRow(
                  icon: Icons.alt_route_rounded,
                  title: alternative.label,
                  detail: alternative.detail,
                  trailing: alternative.confidence == null
                      ? null
                      : Text(
                          '${(alternative.confidence!.clamp(0.0, 1.0) * 100).round()}%',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                if (alternative != bundle.alternativeInterpretations.last)
                  const SizedBox(height: 8),
              ],
            ],
            if (bundle.listeningHints.isNotEmpty) ...[
              const SizedBox(height: 14),
              sectionTitle(l10n.explanationListeningSection),
              const SizedBox(height: 8),
              for (final hint in bundle.listeningHints) ...[
                _HintRow(
                  icon: Icons.hearing_rounded,
                  title: hint.title,
                  detail: hint.detail,
                ),
                if (hint != bundle.listeningHints.last)
                  const SizedBox(height: 8),
              ],
            ],
            if (bundle.performanceHints.isNotEmpty) ...[
              const SizedBox(height: 14),
              sectionTitle(l10n.explanationPerformanceSection),
              const SizedBox(height: 8),
              for (final hint in bundle.performanceHints) ...[
                _HintRow(
                  icon: Icons.piano_rounded,
                  title: hint.title,
                  detail: hint.detail,
                ),
                if (hint != bundle.performanceHints.last)
                  const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({
    required this.icon,
    required this.title,
    required this.detail,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String detail;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
