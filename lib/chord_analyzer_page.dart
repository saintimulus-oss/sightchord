import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'music/progression_analysis_models.dart';
import 'music/progression_analyzer.dart';
import 'music/progression_explainer.dart';
import 'widgets/chord_input_editor.dart';

class ChordAnalyzerPage extends StatefulWidget {
  const ChordAnalyzerPage({super.key, this.inputPlatformOverride});

  final TargetPlatform? inputPlatformOverride;

  @override
  State<ChordAnalyzerPage> createState() => _ChordAnalyzerPageState();
}

class _ChordAnalyzerPageState extends State<ChordAnalyzerPage> {
  final TextEditingController _controller = TextEditingController();
  final ProgressionAnalyzer _analyzer = const ProgressionAnalyzer();
  final ProgressionExplainer _explainer = const ProgressionExplainer();
  static const List<String> _exampleProgressions = [
    'Dm7 G13 Cmaj9',
    'Cmaj7/E A7(b9) Dm7 G7',
    'Db7(#11) Cmaj7',
    'Bm7b5 E7alt Am6',
  ];

  ProgressionAnalysis? _analysis;
  String? _errorKey;
  bool _isAnalyzing = false;

  Future<void> _analyze() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        _analysis = null;
        _errorKey = 'empty';
      });
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isAnalyzing = true;
      _errorKey = null;
    });

    await Future<void>.delayed(Duration.zero);

    try {
      final analysis = _analyzer.analyze(input);
      if (!mounted) {
        return;
      }
      setState(() {
        _analysis = analysis;
      });
    } on ProgressionAnalysisException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _analysis = null;
        _errorKey = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyExample(String progression) {
    _controller.value = TextEditingValue(
      text: progression,
      selection: TextSelection.collapsed(offset: progression.length),
    );
    setState(() {
      _errorKey = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final summary = _analysis == null
        ? const <String>[]
        : _explainer.buildSummary(l10n, _analysis!);
    final warnings = _analysis == null
        ? const <String>[]
        : _warningTexts(l10n, _analysis!);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chordAnalyzerTitle)),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.48),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 0,
                      color: colorScheme.surface.withValues(alpha: 0.92),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.chordAnalyzerSubtitle,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ChordInputEditor(
                              fieldKey: const ValueKey('analyzer-input-field'),
                              controller: _controller,
                              labelText: l10n.chordAnalyzerInputLabel,
                              hintText: l10n.chordAnalyzerInputHint,
                              helperText: l10n.chordAnalyzerInputHelper,
                              platformOverride: widget.inputPlatformOverride,
                              onAnalyze: _isAnalyzing ? () {} : _analyze,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.chordAnalyzerExamplesTitle,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final example in _exampleProgressions)
                                  ActionChip(
                                    key: ValueKey('analyzer-example-$example'),
                                    label: Text(example),
                                    onPressed: () => _applyExample(example),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                key: const ValueKey('analyzer-analyze-button'),
                                onPressed: _isAnalyzing ? null : _analyze,
                                icon: const Icon(Icons.insights_rounded),
                                label: Text(l10n.chordAnalyzerAnalyze),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isAnalyzing)
                      _SectionCard(
                        title: l10n.chordAnalyzerAnalyzing,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                    else if (_errorKey != null)
                      _SectionCard(
                        title: l10n.chordAnalyzerWarnings,
                        child: Text(_errorText(l10n)),
                      )
                    else if (_analysis == null)
                      _SectionCard(
                        title: l10n.chordAnalyzerInitialTitle,
                        child: Text(l10n.chordAnalyzerInitialBody),
                      )
                    else ...[
                      _SectionCard(
                        key: const ValueKey('analyzer-results-card'),
                        title: l10n.chordAnalyzerDetectedKeys,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _MetricMeter(
                              label: l10n.chordAnalyzerConfidenceLabel,
                              value: _analysis!.confidence,
                            ),
                            const SizedBox(height: 10),
                            _MetricMeter(
                              label: l10n.chordAnalyzerAmbiguityLabel,
                              value: _analysis!.ambiguity,
                              invertColor: true,
                            ),
                            const SizedBox(height: 14),
                            _KeyCandidateRow(
                              label: l10n.chordAnalyzerPrimaryReading,
                              value: _explainer.keyLabel(
                                l10n,
                                _analysis!.primaryKey.keyCenter,
                              ),
                              confidence: _analysis!.primaryKey.confidence,
                            ),
                            if (_analysis!.alternativeKey != null) ...[
                              const SizedBox(height: 8),
                              _KeyCandidateRow(
                                label: l10n.chordAnalyzerAlternativeReading,
                                value: _explainer.keyLabel(
                                  l10n,
                                  _analysis!.alternativeKey!.keyCenter,
                                ),
                                confidence: _analysis!.alternativeKey!.confidence,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: l10n.chordAnalyzerChordAnalysis,
                        child: Column(
                          children: [
                            for (
                              var measureIndex = 0;
                              measureIndex < _analysis!.groupedMeasures.length;
                              measureIndex += 1
                            ) ...[
                              _MeasureSection(
                                title: l10n.chordAnalyzerMeasureLabel(
                                  _analysis!
                                          .groupedMeasures[measureIndex]
                                          .measureIndex +
                                      1,
                                ),
                                children: [
                                  for (
                                    var chordIndex = 0;
                                    chordIndex <
                                        _analysis!
                                            .groupedMeasures[measureIndex]
                                            .chordAnalyses
                                            .length;
                                    chordIndex += 1
                                  ) ...[
                                    _ChordAnalysisRow(
                                      analysis: _analysis!
                                          .groupedMeasures[measureIndex]
                                          .chordAnalyses[chordIndex],
                                      explainer: _explainer,
                                      functionLabel: _explainer.functionLabel(
                                        l10n,
                                        _analysis!
                                            .groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex]
                                            .harmonicFunction,
                                      ),
                                      remarkText: _remarkText(
                                        l10n,
                                        _analysis!
                                            .groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex],
                                      ),
                                    ),
                                    if (chordIndex !=
                                        _analysis!
                                                .groupedMeasures[measureIndex]
                                                .chordAnalyses
                                                .length -
                                            1)
                                      const Divider(height: 20),
                                  ],
                                ],
                              ),
                              if (measureIndex !=
                                  _analysis!.groupedMeasures.length - 1)
                                const SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SectionCard(
                        title: l10n.chordAnalyzerProgressionSummary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_analysis!.tags.isNotEmpty) ...[
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final tag in _analysis!.tags)
                                    Chip(
                                      label: Text(
                                        _explainer.tagLabel(l10n, tag),
                                      ),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                            for (final line in summary) ...[
                              Text(line),
                              const SizedBox(height: 8),
                            ],
                            if (_analysis!.alternativeKey != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.chordAnalyzerCompetingReadings}: '
                                '${_explainer.keyLabel(l10n, _analysis!.alternativeKey!.keyCenter)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (warnings.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _SectionCard(
                          title: l10n.chordAnalyzerWarnings,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (
                                var index = 0;
                                index < warnings.length;
                                index += 1
                              ) ...[
                                Text(warnings[index]),
                                if (index != warnings.length - 1)
                                  const SizedBox(height: 8),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _errorText(AppLocalizations l10n) {
    return switch (_errorKey) {
      'empty' => l10n.chordAnalyzerNoInputError,
      'no-valid-chords' => l10n.chordAnalyzerNoRecognizedChordsError,
      _ => l10n.chordAnalyzerNoRecognizedChordsError,
    };
  }

  List<String> _warningTexts(
    AppLocalizations l10n,
    ProgressionAnalysis analysis,
  ) {
    final warnings = <String>[];
    if (analysis.parseResult.issues.isNotEmpty) {
      final skipped = analysis.parseResult.issues
          .map((issue) => issue.rawText)
          .join(', ');
      warnings.add(l10n.chordAnalyzerPartialParseWarning(skipped));
    }
    for (final chord in analysis.parseResult.validChords) {
      if (chord.ignoredTokens.isNotEmpty) {
        warnings.add(
          l10n.chordAnalyzerIgnoredModifiersWarning(
            '${chord.sourceSymbol}: ${chord.ignoredTokens.join(', ')}',
          ),
        );
      }
      for (final diagnostic in chord.diagnostics) {
        warnings.add(
          l10n.chordAnalyzerParserDiagnosticWarning(
            _diagnosticLabel(l10n, diagnostic),
          ),
        );
      }
    }
    if (analysis.alternativeKey != null) {
      warnings.add(
        l10n.chordAnalyzerKeyAmbiguityWarning(
          _explainer.keyLabel(l10n, analysis.primaryKey.keyCenter),
          _explainer.keyLabel(l10n, analysis.alternativeKey!.keyCenter),
        ),
      );
    }
    if (analysis.ambiguousChordCount > 0 || analysis.unresolvedChordCount > 0) {
      warnings.add(l10n.chordAnalyzerUnresolvedWarning);
    }
    return warnings;
  }

  String? _remarkText(AppLocalizations l10n, AnalyzedChord analysis) {
    if (analysis.remarks.isEmpty) {
      return null;
    }
    return analysis.remarks
        .map((remark) => _explainer.remarkLabel(l10n, remark))
        .join(' ');
  }

  String _diagnosticLabel(AppLocalizations l10n, String diagnostic) {
    return switch (diagnostic) {
      'unbalanced-parentheses' => l10n.chordAnalyzerDiagnosticUnbalancedParentheses,
      'unexpected-close-parenthesis' =>
        l10n.chordAnalyzerDiagnosticUnexpectedCloseParenthesis,
      _ => diagnostic,
    };
  }
}

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
  });

  final AnalyzedChord analysis;
  final ProgressionExplainer explainer;
  final String functionLabel;
  final String? remarkText;

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
                  Text(
                    analysis.romanNumeral,
                    style: theme.textTheme.bodyLarge,
                  ),
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
        Chip(label: Text(functionLabel)),
      ],
    );
  }
}
