part of 'chord_analyzer_page_view.dart';

BoxDecoration _analyzerPanelDecoration(
  ColorScheme colorScheme, {
  bool accent = false,
}) {
  return BoxDecoration(
    color: accent
        ? colorScheme.primaryContainer.withValues(alpha: 0.34)
        : colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(
      color: accent
          ? colorScheme.primary.withValues(alpha: 0.18)
          : colorScheme.outlineVariant,
    ),
  );
}

RoundedRectangleBorder _analyzerCardShape(ColorScheme colorScheme) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(28),
    side: BorderSide(color: colorScheme.outlineVariant),
  );
}

class _MeasureSection extends StatelessWidget {
  const _MeasureSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: _analyzerPanelDecoration(theme.colorScheme),
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
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: _analyzerCardShape(theme.colorScheme),
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

class _AnalysisStatusBanner extends StatelessWidget {
  const _AnalysisStatusBanner({
    required this.icon,
    required this.title,
    this.body,
    this.chips = const [],
    this.accent = false,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String? body;
  final List<Widget> chips;
  final bool accent;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconBackground = accent
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.surfaceContainerHighest;
    final iconColor = accent
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: accent
            ? colorScheme.primaryContainer.withValues(alpha: 0.26)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accent
              ? colorScheme.primary.withValues(alpha: 0.18)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (body != null && body!.trim().isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      body!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: chips),
                  ],
                ],
              ),
            ),
            if (busy) ...[
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: accent ? colorScheme.primary : colorScheme.primary,
                  ),
                ),
              ),
            ],
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
      decoration: _analyzerPanelDecoration(theme.colorScheme, accent: true),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
        ? theme.colorScheme.onSurfaceVariant
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

Color _highlightForeground(Color background) {
  return background.computeLuminance() > 0.45 ? Colors.black : Colors.white;
}

Color _softHighlightBackground(Color color) {
  return color.withValues(alpha: 0.14);
}

class _HighlightCategoryChip extends StatelessWidget {
  const _HighlightCategoryChip({
    required this.category,
    required this.highlightTheme,
    this.compact = false,
  });

  final ProgressionHighlightCategory category;
  final ProgressionHighlightTheme highlightTheme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final color = highlightTheme.colorFor(category);
    final foreground = _highlightForeground(color);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: _softHighlightBackground(color),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            category.localizedLabel(l10n),
            style:
                (compact
                        ? theme.textTheme.labelSmall
                        : theme.textTheme.labelMedium)
                    ?.copyWith(
                      color: foreground.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w700,
                    ),
          ),
        ],
      ),
    );
  }
}

class _AnalyzerLegendWrap extends StatelessWidget {
  const _AnalyzerLegendWrap({
    required this.categories,
    required this.highlightTheme,
  });

  final Iterable<ProgressionHighlightCategory> categories;
  final ProgressionHighlightTheme highlightTheme;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      for (final category in ProgressionHighlightCategory.values)
        if (categories.contains(category)) category,
    ];
    if (ordered.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in ordered)
          _HighlightCategoryChip(
            category: category,
            highlightTheme: highlightTheme,
          ),
      ],
    );
  }
}

class _ThemeCategoryEditorRow extends StatelessWidget {
  const _ThemeCategoryEditorRow({
    required this.category,
    required this.highlightTheme,
    required this.onPickColor,
  });

  final ProgressionHighlightCategory category;
  final ProgressionHighlightTheme highlightTheme;
  final ValueChanged<int> onPickColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selected = highlightTheme.colorValueFor(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(selected),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category.localizedLabel(l10n),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final colorValue in ProgressionHighlightTheme.customPalette)
              InkWell(
                key: ValueKey(
                  'analyzer-theme-${category.storageKey}-$colorValue',
                ),
                borderRadius: BorderRadius.circular(999),
                onTap: () => onPickColor(colorValue),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(colorValue),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected == colorValue
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.outlineVariant,
                      width: selected == colorValue ? 2.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _AnalysisRowFrame extends StatelessWidget {
  const _AnalysisRowFrame({
    required this.category,
    required this.highlightTheme,
    required this.child,
  });

  final ProgressionHighlightCategory? category;
  final ProgressionHighlightTheme highlightTheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = category == null
        ? theme.colorScheme.outlineVariant
        : highlightTheme.colorFor(category!);
    final surface = category == null
        ? theme.colorScheme.surface
        : Color.alphaBlend(
            _softHighlightBackground(accent),
            theme.colorScheme.surface,
          );
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChordAnalysisRow extends StatelessWidget {
  const _ChordAnalysisRow({
    required this.analysis,
    required this.explainer,
    required this.functionLabel,
    required this.detailText,
    required this.highlightTheme,
    this.onPlayChord,
    this.onPlayArpeggio,
  });

  final AnalyzedChord analysis;
  final ProgressionExplainer explainer;
  final String functionLabel;
  final String detailText;
  final ProgressionHighlightTheme highlightTheme;
  final VoidCallback? onPlayChord;
  final VoidCallback? onPlayArpeggio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final categories = analysis.highlightCategories;
    final evidenceLabels = [
      for (final evidence in analysis.evidence)
        if (evidence.kind != ProgressionEvidenceKind.qualityMatch)
          explainer.evidenceLabel(l10n, evidence),
    ];
    final details = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            analysis.chord.sourceSymbol,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                analysis.romanNumeral,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Chip(
                backgroundColor: theme.colorScheme.primaryContainer,
                side: BorderSide.none,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
                label: Text(
                  '${l10n.chordAnalyzerConfidenceLabel} '
                  '${(analysis.confidence * 100).round()}%',
                ),
                visualDensity: VisualDensity.compact,
              ),
              if (analysis.isNonDiatonic)
                Chip(
                  backgroundColor: theme.colorScheme.tertiaryContainer,
                  side: BorderSide.none,
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                  label: Text(l10n.nonDiatonic),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in categories)
                  _HighlightCategoryChip(
                    category: category,
                    highlightTheme: highlightTheme,
                    compact: true,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(
            detailText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
    );
    final controls = Column(
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
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 540) {
          return _AnalysisRowFrame(
            category: analysis.primaryHighlightCategory,
            highlightTheme: highlightTheme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [details],
                ),
                const SizedBox(height: 10),
                controls,
              ],
            ),
          );
        }

        return _AnalysisRowFrame(
          category: analysis.primaryHighlightCategory,
          highlightTheme: highlightTheme,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [details, const SizedBox(width: 12), controls],
          ),
        );
      },
    );
  }
}

class _InferredChordAnalysisRow extends StatelessWidget {
  const _InferredChordAnalysisRow({
    required this.analysis,
    required this.explainer,
    required this.functionLabel,
    required this.detailText,
    required this.highlightTheme,
    this.onPlayChord,
    this.onPlayArpeggio,
  });

  final AnalyzedChord analysis;
  final ProgressionExplainer explainer;
  final String functionLabel;
  final String detailText;
  final ProgressionHighlightTheme highlightTheme;
  final VoidCallback? onPlayChord;
  final VoidCallback? onPlayArpeggio;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final categories = analysis.highlightCategories;
    final evidenceLabels = [
      for (final evidence in analysis.evidence)
        if (evidence.kind != ProgressionEvidenceKind.qualityMatch)
          explainer.evidenceLabel(l10n, evidence),
    ];
    final competingLabels = [
      for (final candidate in analysis.competingInterpretations)
        if (candidate.chordSymbol case final symbol?)
          '$symbol (${candidate.romanNumeral})',
    ];

    final details = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            analysis.chord.sourceSymbol,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.chordAnalyzerSuggestedFill(analysis.resolvedSymbol),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.chordAnalyzerPlaceholderExplanation,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                analysis.romanNumeral,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Chip(
                backgroundColor: theme.colorScheme.primaryContainer,
                side: BorderSide.none,
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
                label: Text(
                  '${l10n.chordAnalyzerConfidenceLabel} '
                  '${(analysis.confidence * 100).round()}%',
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in categories)
                  _HighlightCategoryChip(
                    category: category,
                    highlightTheme: highlightTheme,
                    compact: true,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Text(
            detailText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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
          if (competingLabels.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '${l10n.chordAnalyzerCompetingReadings}: '
              '${competingLabels.join(', ')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );

    final controls = Column(
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
                    'analyzer-play-inferred-${analysis.chord.measureIndex}-${analysis.chord.positionInMeasure}',
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: onPlayChord,
                  tooltip: l10n.audioPlayChord,
                  icon: const Icon(Icons.music_note_rounded),
                ),
              if (onPlayArpeggio != null)
                IconButton.outlined(
                  key: ValueKey(
                    'analyzer-play-inferred-arpeggio-${analysis.chord.measureIndex}-${analysis.chord.positionInMeasure}',
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
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 540) {
          return _AnalysisRowFrame(
            category: analysis.primaryHighlightCategory,
            highlightTheme: highlightTheme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [details],
                ),
                const SizedBox(height: 10),
                controls,
              ],
            ),
          );
        }

        return _AnalysisRowFrame(
          category: analysis.primaryHighlightCategory,
          highlightTheme: highlightTheme,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [details, const SizedBox(width: 12), controls],
          ),
        );
      },
    );
  }
}

class _VariationSuggestionCard extends StatelessWidget {
  const _VariationSuggestionCard({
    required this.variation,
    required this.title,
    required this.body,
    required this.onApply,
  });

  final ProgressionVariation variation;
  final String title;
  final String body;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: _analyzerPanelDecoration(theme.colorScheme),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            SelectableText(
              variation.progression,
              key: ValueKey('analyzer-variation-${variation.kind.name}'),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                key: ValueKey(
                  'analyzer-apply-variation-${variation.kind.name}',
                ),
                onPressed: onApply,
                icon: const Icon(Icons.call_made_rounded),
                label: Text(l10n.chordAnalyzerApplyVariation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
