import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'music/progression_analysis_models.dart';
import 'music/progression_analyzer.dart';
import 'music/progression_explainer.dart';

class ChordAnalyzerPage extends StatefulWidget {
  const ChordAnalyzerPage({super.key});

  @override
  State<ChordAnalyzerPage> createState() => _ChordAnalyzerPageState();
}

class _ChordAnalyzerPageState extends State<ChordAnalyzerPage> {
  final TextEditingController _controller = TextEditingController();
  final ProgressionAnalyzer _analyzer = const ProgressionAnalyzer();
  final ProgressionExplainer _explainer = const ProgressionExplainer();

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
                            TextField(
                              key: const ValueKey('analyzer-input-field'),
                              controller: _controller,
                              minLines: 3,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: l10n.chordAnalyzerInputLabel,
                                hintText: l10n.chordAnalyzerInputHint,
                                helperText: l10n.chordAnalyzerInputHelper,
                                border: const OutlineInputBorder(),
                              ),
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
                            _KeyCandidateRow(
                              label: l10n.chordAnalyzerPrimaryReading,
                              value: _explainer.keyLabel(
                                l10n,
                                _analysis!.primaryKey.keyCenter,
                              ),
                            ),
                            if (_analysis!.alternativeKey != null) ...[
                              const SizedBox(height: 8),
                              _KeyCandidateRow(
                                label: l10n.chordAnalyzerAlternativeReading,
                                value: _explainer.keyLabel(
                                  l10n,
                                  _analysis!.alternativeKey!.keyCenter,
                                ),
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
                            for (var index = 0;
                                index < _analysis!.chordAnalyses.length;
                                index += 1) ...[
                              _ChordAnalysisRow(
                                analysis: _analysis!.chordAnalyses[index],
                                functionLabel: _explainer.functionLabel(
                                  l10n,
                                  _analysis!.chordAnalyses[index].harmonicFunction,
                                ),
                                remarkText: _remarkText(
                                  l10n,
                                  _analysis!.chordAnalyses[index],
                                ),
                              ),
                              if (index != _analysis!.chordAnalyses.length - 1)
                                const Divider(height: 20),
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
                                      label: Text(_explainer.tagLabel(l10n, tag)),
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
                              for (var index = 0; index < warnings.length; index += 1) ...[
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
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    super.key,
    required this.title,
    required this.child,
  });

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

class _KeyCandidateRow extends StatelessWidget {
  const _KeyCandidateRow({required this.label, required this.value});

  final String label;
  final String value;

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
      ],
    );
  }
}

class _ChordAnalysisRow extends StatelessWidget {
  const _ChordAnalysisRow({
    required this.analysis,
    required this.functionLabel,
    this.remarkText,
  });

  final AnalyzedChord analysis;
  final String functionLabel;
  final String? remarkText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              Text(
                analysis.romanNumeral,
                style: theme.textTheme.bodyLarge,
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
            ],
          ),
        ),
        const SizedBox(width: 12),
        Chip(label: Text(functionLabel)),
      ],
    );
  }
}
