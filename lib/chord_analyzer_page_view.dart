import 'dart:async';

import 'package:flutter/material.dart';

import 'audio/harmony_audio_models.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/sightchord_audio_scope.dart';
import 'l10n/app_localizations.dart';
import 'music/progression_analysis_models.dart';
import 'music/progression_analyzer.dart';
import 'music/progression_explainer.dart';
import 'widgets/chord_input_editor.dart';

part 'chord_analyzer_page_sections.dart';

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
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_requestedHarmonyAudioWarmUp) {
      return;
    }
    final harmonyAudio = SightChordAudioScope.maybeOf(context);
    _harmonyAudio = harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    _requestedHarmonyAudioWarmUp = true;
    unawaited(harmonyAudio.warmUp());
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

  Future<void> _playAnalysis({required HarmonyPlaybackPattern pattern}) async {
    final analysis = _analysis;
    final harmonyAudio = _harmonyAudio;
    if (analysis == null || harmonyAudio == null) {
      return;
    }
    await harmonyAudio.playProgressionAnalysis(analysis, pattern: pattern);
  }

  Future<void> _playChord(
    ParsedChord chord, {
    required HarmonyPlaybackPattern pattern,
  }) async {
    final harmonyAudio = _harmonyAudio;
    if (harmonyAudio == null) {
      return;
    }
    await harmonyAudio.playParsedChord(chord, pattern: pattern);
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
    final keyCandidates = _analysis == null
        ? const <ProgressionKeyCandidate>[]
        : _analysis!.keyCandidates.take(5).toList();
    final groupedMeasures =
        _analysis?.groupedMeasures ?? const <AnalyzedMeasure>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chordAnalyzerTitle),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.06),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0, 0.24, 1],
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
                    DecoratedBox(
                      decoration: _analyzerPanelDecoration(
                        colorScheme,
                        accent: true,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.chordAnalyzerSubtitle,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
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
                                color: colorScheme.onSurfaceVariant,
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
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.end,
                                children: [
                                  if (_analysis != null) ...[
                                    OutlinedButton.icon(
                                      key: const ValueKey(
                                        'analyzer-play-progression-button',
                                      ),
                                      onPressed: () => _playAnalysis(
                                        pattern: HarmonyPlaybackPattern.block,
                                      ),
                                      icon: const Icon(
                                        Icons.music_note_rounded,
                                      ),
                                      label: Text(l10n.audioPlayProgression),
                                    ),
                                    OutlinedButton.icon(
                                      key: const ValueKey(
                                        'analyzer-play-progression-arpeggio-button',
                                      ),
                                      onPressed: () => _playAnalysis(
                                        pattern:
                                            HarmonyPlaybackPattern.arpeggio,
                                      ),
                                      icon: const Icon(
                                        Icons.multitrack_audio_rounded,
                                      ),
                                      label: Text(l10n.audioPlayArpeggio),
                                    ),
                                  ],
                                  FilledButton.icon(
                                    key: const ValueKey(
                                      'analyzer-analyze-button',
                                    ),
                                    onPressed: _isAnalyzing ? null : _analyze,
                                    icon: const Icon(Icons.insights_rounded),
                                    label: Text(l10n.chordAnalyzerAnalyze),
                                  ),
                                ],
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
                      if (_analysis!.confidence < 0.55) ...[
                        _LowConfidenceBanner(
                          title: l10n.chordAnalyzerLowConfidenceTitle,
                          body: l10n.chordAnalyzerLowConfidenceBody,
                        ),
                        const SizedBox(height: 12),
                      ],
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
                            for (
                              var index = 0;
                              index < keyCandidates.length;
                              index += 1
                            ) ...[
                              _KeyCandidateRow(
                                label: _candidateLabel(l10n, index),
                                value: _explainer.keyLabel(
                                  l10n,
                                  keyCandidates[index].keyCenter,
                                ),
                                confidence: keyCandidates[index].confidence,
                              ),
                              if (index != keyCandidates.length - 1)
                                const SizedBox(height: 8),
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
                              measureIndex < groupedMeasures.length;
                              measureIndex += 1
                            ) ...[
                              _MeasureSection(
                                title: l10n.chordAnalyzerMeasureLabel(
                                  groupedMeasures[measureIndex].measureIndex +
                                      1,
                                ),
                                children: [
                                  if (groupedMeasures[measureIndex].isEmpty)
                                    Text(
                                      l10n.chordAnalyzerEmptyMeasure,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  if (groupedMeasures[measureIndex]
                                      .parseIssues
                                      .isNotEmpty) ...[
                                    Text(
                                      l10n.chordAnalyzerParseIssuesTitle,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    for (final issue
                                        in groupedMeasures[measureIndex]
                                            .parseIssues) ...[
                                      Text(_parseIssueText(l10n, issue)),
                                      const SizedBox(height: 4),
                                    ],
                                    if (groupedMeasures[measureIndex]
                                        .chordAnalyses
                                        .isNotEmpty)
                                      const SizedBox(height: 10),
                                  ],
                                  for (
                                    var chordIndex = 0;
                                    chordIndex <
                                        groupedMeasures[measureIndex]
                                            .chordAnalyses
                                            .length;
                                    chordIndex += 1
                                  ) ...[
                                    _ChordAnalysisRow(
                                      analysis: groupedMeasures[measureIndex]
                                          .chordAnalyses[chordIndex],
                                      explainer: _explainer,
                                      functionLabel: _explainer.functionLabel(
                                        l10n,
                                        groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex]
                                            .harmonicFunction,
                                      ),
                                      remarkText: _remarkText(
                                        l10n,
                                        groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex],
                                      ),
                                      onPlayChord: () => _playChord(
                                        groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex]
                                            .chord,
                                        pattern: HarmonyPlaybackPattern.block,
                                      ),
                                      onPlayArpeggio: () => _playChord(
                                        groupedMeasures[measureIndex]
                                            .chordAnalyses[chordIndex]
                                            .chord,
                                        pattern:
                                            HarmonyPlaybackPattern.arpeggio,
                                      ),
                                    ),
                                    if (chordIndex !=
                                        groupedMeasures[measureIndex]
                                                .chordAnalyses
                                                .length -
                                            1)
                                      const Divider(height: 20),
                                  ],
                                  if (groupedMeasures[measureIndex]
                                          .chordAnalyses
                                          .isEmpty &&
                                      groupedMeasures[measureIndex]
                                          .parseIssues
                                          .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        l10n.chordAnalyzerNoAnalyzableChordsInMeasure,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              if (measureIndex != groupedMeasures.length - 1)
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
    warnings.addAll([
      for (final issue in analysis.parseResult.issues)
        _parseIssueText(l10n, issue),
    ]);
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
      'unbalanced-parentheses' =>
        l10n.chordAnalyzerDiagnosticUnbalancedParentheses,
      'unexpected-close-parenthesis' =>
        l10n.chordAnalyzerDiagnosticUnexpectedCloseParenthesis,
      _ => diagnostic,
    };
  }

  String _candidateLabel(AppLocalizations l10n, int index) {
    if (index == 0) {
      return l10n.chordAnalyzerPrimaryReading;
    }
    if (index == 1) {
      return l10n.chordAnalyzerAlternativeReading;
    }
    return '#${index + 1}';
  }

  String _parseIssueText(AppLocalizations l10n, ParsedChordToken issue) {
    final reason = switch (issue.error) {
      'empty' => l10n.chordAnalyzerParseIssueEmpty,
      'invalid-root' => l10n.chordAnalyzerParseIssueInvalidRoot,
      'unknown-root' => l10n.chordAnalyzerParseIssueUnknownRoot(
        issue.errorDetail ?? issue.rawText,
      ),
      'invalid-bass' => l10n.chordAnalyzerParseIssueInvalidBass(
        issue.errorDetail ?? issue.rawText,
      ),
      'unsupported-suffix' => l10n.chordAnalyzerParseIssueUnsupportedSuffix(
        issue.errorDetail ?? issue.rawText,
      ),
      _ => l10n.chordAnalyzerParseIssueUnsupportedSuffix(issue.rawText),
    };
    return l10n.chordAnalyzerParseIssueLine(issue.rawText, reason);
  }
}
