part of 'chord_analyzer_page_view.dart';

class _MeasureSection extends StatelessWidget {
  const _MeasureSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _LowConfidenceBanner extends StatelessWidget {
  const _LowConfidenceBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricMeter extends StatelessWidget {
  const _MetricMeter({
    required this.label,
    required this.value,
    this.invertColor = false,
  });

  final String label;
  final double value;
  final bool invertColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = value.clamp(0.0, 1.0);
    final barColor = invertColor
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text('${(normalized * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: normalized,
            color: barColor,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _KeyCandidateRow extends StatelessWidget {
  const _KeyCandidateRow({
    required this.label,
    required this.value,
    required this.confidence,
  });

  final String label;
  final String value;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(confidence.clamp(0.0, 1.0) * 100).round()}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ChordAnalysisRow extends StatelessWidget {
  const _ChordAnalysisRow({
    required this.analysis,
    required this.explainer,
    required this.functionLabel,
    this.remarkText,
    this.onPlayChord,
    this.onPlayArpeggio,
  });

  final AnalyzedChord analysis;
  final ProgressionExplainer explainer;
  final String functionLabel;
  final String? remarkText;
  final VoidCallback? onPlayChord;
  final VoidCallback? onPlayArpeggio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final evidenceLabels = [
      for (final evidence in analysis.evidence)
        if (evidence.kind != ProgressionEvidenceKind.qualityMatch)
          explainer.evidenceLabel(l10n, evidence),
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                analysis.chord.sourceSymbol,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Text(analysis.romanNumeral, style: theme.textTheme.bodyLarge),
                  Chip(
                    label: Text(
                      '${l10n.chordAnalyzerConfidenceLabel} '
                      '${(analysis.confidence * 100).round()}%',
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              if (remarkText != null) ...[
                const SizedBox(height: 6),
                Text(
                  remarkText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (evidenceLabels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.chordAnalyzerWhyThisReading,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final label in evidenceLabels.take(3))
                      FilterChip(
                        label: Text(label),
                        selected: false,
                        showCheckmark: false,
                        visualDensity: VisualDensity.compact,
                        onSelected: null,
                      ),
                  ],
                ),
              ],
              if (analysis.competingInterpretations.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${l10n.chordAnalyzerCompetingReadings}: '
                  '${analysis.competingInterpretations.map((item) => item.romanNumeral).join(', ')}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Chip(label: Text(functionLabel)),
            if (onPlayChord != null || onPlayArpeggio != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  if (onPlayChord != null)
                    IconButton.outlined(
                      key: ValueKey(
                        'analyzer-play-chord-${analysis.chord.sourceSymbol}',
                      ),
                      visualDensity: VisualDensity.compact,
                      onPressed: onPlayChord,
                      tooltip: l10n.audioPlayChord,
                      icon: const Icon(Icons.music_note_rounded),
                    ),
                  if (onPlayArpeggio != null)
                    IconButton.outlined(
                      key: ValueKey(
                        'analyzer-play-arpeggio-${analysis.chord.sourceSymbol}',
                      ),
                      visualDensity: VisualDensity.compact,
                      onPressed: onPlayArpeggio,
                      tooltip: l10n.audioPlayArpeggio,
                      icon: const Icon(Icons.multitrack_audio_rounded),
                    ),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}
