import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio/harmony_audio_models.dart';
import 'audio/harmony_audio_service.dart';
import 'audio/chordest_audio_scope.dart';
import 'billing/billing_scope.dart';
import 'chord_analyzer_history_store.dart';
import 'l10n/app_localizations.dart';
import 'music/chord_theory.dart';
import 'music/explanation_models.dart';
import 'music/progression_analysis_models.dart';
import 'music/progression_analyzer.dart';
import 'music/progression_explanation_bundle_builder.dart';
import 'music/progression_explainer.dart';
import 'music/progression_variation_generator.dart';
import 'practice_home_page.dart';
import 'release_feature_flags.dart';
import 'settings/practice_settings.dart';
import 'settings/settings_controller.dart';
import 'widgets/chord_input_editor.dart';
import 'widgets/explanation_bundle_panel.dart';

part 'chord_analyzer_page_sections.dart';

class ChordAnalyzerPage extends StatefulWidget {
  const ChordAnalyzerPage({
    super.key,
    this.inputPlatformOverride,
    this.controller,
    this.initialInput,
    this.autoAnalyzeOnStart = false,
  });

  final TargetPlatform? inputPlatformOverride;
  final AppSettingsController? controller;
  final String? initialInput;
  final bool autoAnalyzeOnStart;

  @override
  State<ChordAnalyzerPage> createState() => _ChordAnalyzerPageState();
}

class _ChordAnalyzerPageState extends State<ChordAnalyzerPage> {
  static const String _draftPreferenceKey = 'chord_analyzer_input_draft';
  static const Duration _draftSaveDebounceDuration = Duration(
    milliseconds: 320,
  );
  final TextEditingController _controller = TextEditingController();
  final ProgressionAnalyzer _analyzer = const ProgressionAnalyzer();
  final ProgressionExplanationBundleBuilder _bundleBuilder =
      const ProgressionExplanationBundleBuilder();
  final ProgressionExplainer _explainer = const ProgressionExplainer();
  final ProgressionVariationGenerator _variationGenerator =
      const ProgressionVariationGenerator();
  static const List<String> _exampleProgressions = [
    'Dm7, G7 | ? Am',
    'Cmaj7/E | A7(b9) Dm7 | G7',
    'Db7(#11), Cmaj7',
    'Bm7b5 E7alt | Am6, Dm9 G13',
  ];

  ProgressionAnalysis? _analysis;
  String? _errorKey;
  bool _isAnalyzing = false;
  bool _requestedHarmonyAudioWarmUp = false;
  HarmonyAudioService? _harmonyAudio;
  List<ProgressionVariation> _variations = const [];
  late ProgressionExplanationDetailLevel _localExplanationDetailLevel;
  late ProgressionHighlightTheme _localHighlightTheme;
  Timer? _draftSaveDebounce;
  Timer? _copyFeedbackTimer;
  String _lastSavedDraft = '';
  String _lastSubmittedInput = '';
  int _analysisRevision = 0;
  bool _copyFeedbackVisible = false;
  bool _inputHelpDialogOpen = false;
  bool _displaySettingsSheetOpen = false;
  final AnalyzerInputHistoryStore _historyStore =
      const AnalyzerInputHistoryStore();
  List<String> _recentInputs = const <String>[];
  List<String> _pinnedInputs = const <String>[];
  final FocusNode _shortcutFocusNode = FocusNode(
    debugLabel: 'analyzerShortcutFocus',
  );
  final FocusNode _inputFocusNode = FocusNode(debugLabel: 'analyzerInputFocus');

  ProgressionExplanationDetailLevel get _detailLevel =>
      widget.controller?.settings.progressionExplanationDetailLevel ??
      _localExplanationDetailLevel;
  ProgressionHighlightTheme get _highlightTheme =>
      widget.controller?.settings.progressionHighlightTheme ??
      _localHighlightTheme;
  bool get _advancedActionsEnabled => kEnableAdvancedAnalyzerActions;

  @override
  void initState() {
    super.initState();
    final settings = widget.controller?.settings ?? PracticeSettings();
    _localExplanationDetailLevel = settings.progressionExplanationDetailLevel;
    _localHighlightTheme = settings.progressionHighlightTheme;
    final initialInput = _normalizedDraft(widget.initialInput ?? '');
    if (initialInput.isNotEmpty) {
      _lastSavedDraft = initialInput;
      _controller.value = TextEditingValue(
        text: initialInput,
        selection: TextSelection.collapsed(offset: initialInput.length),
      );
      if (widget.autoAnalyzeOnStart) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          unawaited(_analyze());
        });
      }
    }
    _controller.addListener(_handleDraftChanged);
    if (initialInput.isEmpty) {
      unawaited(_restoreDraft());
    } else {
      unawaited(_persistDraft(initialInput));
    }
    unawaited(_restoreQuickEntries());
  }

  Future<void> _analyze() async {
    _resetCopyFeedback();
    final input = _normalizedDraft(_controller.text);
    if (input.isEmpty) {
      _lastSubmittedInput = '';
      setState(() {
        _analysis = null;
        _errorKey = 'empty';
      });
      return;
    }

    final analysisRevision = ++_analysisRevision;
    _lastSubmittedInput = input;
    FocusScope.of(context).unfocus();
    _shortcutFocusNode.requestFocus();
    setState(() {
      _isAnalyzing = true;
      _errorKey = null;
      _variations = const [];
    });

    await Future<void>.delayed(Duration.zero);

    ProgressionAnalysis? nextAnalysis;
    String? nextErrorKey;
    try {
      nextAnalysis = _analyzer.analyze(input);
    } on ProgressionAnalysisException catch (error) {
      nextErrorKey = error.message;
    }

    if (!mounted ||
        analysisRevision != _analysisRevision ||
        _normalizedDraft(_controller.text) != input) {
      return;
    }
    setState(() {
      _analysis = nextAnalysis;
      _errorKey = nextErrorKey;
      _isAnalyzing = false;
    });
    if (nextAnalysis != null) {
      unawaited(_rememberQuickEntry(input));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final harmonyAudio = ChordestAudioScope.maybeOf(context);
    if (!identical(_harmonyAudio, harmonyAudio)) {
      _harmonyAudio = harmonyAudio;
      _requestedHarmonyAudioWarmUp = false;
    }
    if (_requestedHarmonyAudioWarmUp) {
      return;
    }
    if (harmonyAudio == null) {
      return;
    }
    _requestedHarmonyAudioWarmUp = true;
    unawaited(harmonyAudio.warmUp());
  }

  @override
  void dispose() {
    _draftSaveDebounce?.cancel();
    _copyFeedbackTimer?.cancel();
    _controller.removeListener(_handleDraftChanged);
    unawaited(_persistDraft(_controller.text));
    _inputFocusNode.dispose();
    _shortcutFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleDraftChanged() {
    _analysisRevision += 1;
    final hadCopyFeedback = _resetCopyFeedback();
    final nextDraft = _normalizedDraft(_controller.text);
    final shouldInvalidateCurrentOutput =
        nextDraft != _lastSubmittedInput &&
        (_analysis != null ||
            _errorKey != null ||
            _isAnalyzing ||
            _variations.isNotEmpty);
    if ((shouldInvalidateCurrentOutput || hadCopyFeedback) && mounted) {
      setState(() {
        if (shouldInvalidateCurrentOutput) {
          _analysis = null;
          _errorKey = null;
          _isAnalyzing = false;
          _variations = const [];
        }
      });
    }
    _draftSaveDebounce?.cancel();
    _draftSaveDebounce = Timer(_draftSaveDebounceDuration, () {
      final currentDraft = _normalizedDraft(_controller.text);
      if (currentDraft == _lastSavedDraft) {
        return;
      }
      _lastSavedDraft = currentDraft;
      unawaited(_persistDraft(currentDraft));
    });
  }

  String _normalizedDraft(String text) => text.trim();

  Future<void> _restoreDraft() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }
    final savedDraft = _normalizedDraft(
      preferences.getString(_draftPreferenceKey) ?? '',
    );
    _lastSavedDraft = savedDraft;
    if (savedDraft.isEmpty || _normalizedDraft(_controller.text).isNotEmpty) {
      return;
    }
    _controller.value = TextEditingValue(
      text: savedDraft,
      selection: TextSelection.collapsed(offset: savedDraft.length),
    );
  }

  Future<void> _persistDraft(String text) async {
    final draft = _normalizedDraft(text);
    final preferences = await SharedPreferences.getInstance();
    if (draft.isEmpty) {
      await preferences.remove(_draftPreferenceKey);
      return;
    }
    await preferences.setString(_draftPreferenceKey, draft);
  }

  Future<void> _restoreQuickEntries() async {
    final entries = await _historyStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _recentInputs = entries.recent;
      _pinnedInputs = entries.pinned;
    });
  }

  Future<void> _rememberQuickEntry(String input) async {
    final entries = await _historyStore.remember(input);
    if (!mounted) {
      return;
    }
    setState(() {
      _recentInputs = entries.recent;
      _pinnedInputs = entries.pinned;
    });
  }

  Future<void> _togglePinnedProgression() async {
    final progression = _normalizedDraft(_analysis?.input ?? _controller.text);
    if (progression.isEmpty) {
      return;
    }
    final entries = await _historyStore.togglePinned(progression);
    if (!mounted) {
      return;
    }
    setState(() {
      _recentInputs = entries.recent;
      _pinnedInputs = entries.pinned;
    });
  }

  bool _resetCopyFeedback() {
    _copyFeedbackTimer?.cancel();
    _copyFeedbackTimer = null;
    final hadCopyFeedback = _copyFeedbackVisible;
    _copyFeedbackVisible = false;
    return hadCopyFeedback;
  }

  void _clearAnalyzerState() {
    if (_isAnalyzing) {
      return;
    }
    _resetCopyFeedback();
    _draftSaveDebounce?.cancel();
    _lastSavedDraft = '';
    _lastSubmittedInput = '';
    _analysisRevision += 1;
    _controller.clear();
    _focusAnalyzerInput(selectAll: false);
    unawaited(_persistDraft(''));
    setState(() {
      _analysis = null;
      _errorKey = null;
      _variations = const [];
    });
  }

  void _applyExample(String progression) {
    _controller.value = TextEditingValue(
      text: progression,
      selection: TextSelection.collapsed(offset: progression.length),
    );
    setState(() {
      _errorKey = null;
      _variations = const [];
    });
  }

  Future<void> _applyExampleAndAnalyze(String progression) async {
    _applyExample(progression);
    await _analyze();
  }

  String _pinnedSectionTitle(BuildContext context) {
    return AppLocalizations.of(context)!.chordAnalyzerPinnedSectionTitle;
  }

  String _recentSectionTitle(BuildContext context) {
    return AppLocalizations.of(context)!.chordAnalyzerRecentSectionTitle;
  }

  String _pinButtonLabel(BuildContext context, {required bool pinned}) {
    final l10n = AppLocalizations.of(context)!;
    return pinned ? l10n.chordAnalyzerUnpinLabel : l10n.chordAnalyzerPinLabel;
  }

  String _pinButtonTooltip(BuildContext context, {required bool pinned}) {
    final l10n = AppLocalizations.of(context)!;
    return pinned
        ? l10n.chordAnalyzerUnpinTooltip
        : l10n.chordAnalyzerPinTooltip;
  }

  String _resumeProgressionTooltip(
    BuildContext context,
    String progression, {
    required bool pinned,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return pinned
        ? l10n.chordAnalyzerPinnedProgressionTooltip(progression)
        : l10n.chordAnalyzerRecentProgressionTooltip(progression);
  }

  String _practiceThisKeyLabel(BuildContext context) {
    return AppLocalizations.of(context)!.chordAnalyzerPracticeThisKeyLabel;
  }

  String _practiceThisKeyTooltip(
    BuildContext context,
    AppLocalizations l10n,
    ProgressionAnalysis analysis,
  ) {
    final keyLabel = _explainer.keyLabel(l10n, analysis.primaryKey.keyCenter);
    return l10n.chordAnalyzerPracticeThisKeyTooltip(keyLabel);
  }

  Future<void> _openGeneratorFromAnalysis() async {
    final analysis = _analysis;
    final controller = widget.controller;
    if (analysis == null || controller == null) {
      return;
    }
    final nextSettings = controller.settings.copyWith(
      guidedSetupCompleted: true,
      activeKeyCenters: <KeyCenter>{analysis.primaryKey.keyCenter},
    );
    await controller.update(nextSettings);
    if (!mounted) {
      return;
    }
    final initialPremiumUnlocked =
        BillingScope.maybeOf(context)?.isPremiumUnlocked ?? false;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MyHomePage(
          title: 'Chordest',
          controller: controller,
          initialPremiumUnlocked: initialPremiumUnlocked,
        ),
      ),
    );
  }

  String _analyzerQuickStartHint(BuildContext context) =>
      AppLocalizations.of(context)!.chordAnalyzerQuickStartHint;

  void _generateVariations() {
    final analysis = _analysis;
    if (!_advancedActionsEnabled || analysis == null) {
      return;
    }
    setState(() {
      _variations = _variationGenerator.generate(analysis);
    });
  }

  Future<void> _updateAnalyzerSettings({
    ProgressionExplanationDetailLevel? detailLevel,
    ProgressionHighlightTheme? highlightTheme,
  }) async {
    final controller = widget.controller;
    if (controller != null) {
      await controller.mutate(
        (current) => current.copyWith(
          progressionExplanationDetailLevel:
              detailLevel ?? current.progressionExplanationDetailLevel,
          progressionHighlightTheme:
              highlightTheme ?? current.progressionHighlightTheme,
        ),
      );
      if (mounted) {
        setState(() {});
      }
      return;
    }
    setState(() {
      _localExplanationDetailLevel =
          detailLevel ?? _localExplanationDetailLevel;
      _localHighlightTheme = highlightTheme ?? _localHighlightTheme;
    });
  }

  Future<void> _openDisplaySettings() async {
    if (_displaySettingsSheetOpen) {
      return;
    }
    _displaySettingsSheetOpen = true;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    var draftDetailLevel = _detailLevel;
    var draftTheme = _highlightTheme;

    try {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              Future<void> applyTheme(
                ProgressionHighlightTheme nextTheme,
              ) async {
                setModalState(() {
                  draftTheme = nextTheme;
                });
                await _updateAnalyzerSettings(highlightTheme: nextTheme);
              }

              return SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    24 + MediaQuery.of(sheetContext).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.chordAnalyzerDisplaySettings,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.chordAnalyzerDisplaySettingsHelp,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<
                        ProgressionExplanationDetailLevel
                      >(
                        key: const ValueKey('analyzer-detail-level-selector'),
                        initialValue: draftDetailLevel,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.chordAnalyzerDetailLevel,
                        ),
                        items: ProgressionExplanationDetailLevel.values
                            .map(
                              (level) =>
                                  DropdownMenuItem<
                                    ProgressionExplanationDetailLevel
                                  >(
                                    value: level,
                                    child: Text(level.localizedLabel(l10n)),
                                  ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setModalState(() {
                            draftDetailLevel = value;
                          });
                          unawaited(
                            _updateAnalyzerSettings(detailLevel: value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ProgressionHighlightThemePreset>(
                        key: const ValueKey('analyzer-theme-preset-selector'),
                        initialValue: draftTheme.preset,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.chordAnalyzerHighlightTheme,
                        ),
                        items: ProgressionHighlightThemePreset.values
                            .map(
                              (preset) =>
                                  DropdownMenuItem<
                                    ProgressionHighlightThemePreset
                                  >(
                                    value: preset,
                                    child: Text(preset.localizedLabel(l10n)),
                                  ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          final nextTheme = draftTheme.withPreset(value);
                          unawaited(applyTheme(nextTheme));
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.chordAnalyzerThemeLegend,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _AnalyzerLegendWrap(
                        categories: ProgressionHighlightCategory.values,
                        highlightTheme: draftTheme,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.chordAnalyzerCustomColors,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final category
                          in ProgressionHighlightCategory.values) ...[
                        _ThemeCategoryEditorRow(
                          category: category,
                          highlightTheme: draftTheme,
                          onPickColor: (colorValue) {
                            final nextTheme = draftTheme.withColor(
                              category,
                              Color(colorValue),
                            );
                            unawaited(applyTheme(nextTheme));
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } finally {
      _displaySettingsSheetOpen = false;
    }
  }

  Future<void> _applyVariation(ProgressionVariation variation) async {
    _applyExample(variation.progression);
    await _analyze();
  }

  Future<void> _showInputHelp() async {
    if (_inputHelpDialogOpen) {
      return;
    }
    _inputHelpDialogOpen = true;
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = MaterialLocalizations.of(context);
    try {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          key: const ValueKey('analyzer-help-dialog'),
          title: Text(l10n.chordAnalyzerInputHelpTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              child: Text(l10n.chordAnalyzerInputHelper),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(materialL10n.closeButtonLabel),
            ),
          ],
        ),
      );
    } finally {
      _inputHelpDialogOpen = false;
    }
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

  Future<void> _copyAnalyzedProgression() async {
    final analysis = _analysis;
    if (analysis == null) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: analysis.input));
    if (!mounted) {
      return;
    }
    _copyFeedbackTimer?.cancel();
    setState(() {
      _copyFeedbackVisible = true;
    });
    _copyFeedbackTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _copyFeedbackVisible = false;
      });
    });
  }

  Future<void> _pasteIntoAnalyzerInput() async {
    if (_isAnalyzing) {
      return;
    }
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboard?.text;
    if (text == null) {
      return;
    }
    final normalizedText = _normalizedDraft(text);
    if (normalizedText.isEmpty) {
      return;
    }
    _resetCopyFeedback();
    _controller.value = TextEditingValue(
      text: normalizedText,
      selection: TextSelection.collapsed(offset: normalizedText.length),
    );
    _inputFocusNode.requestFocus();
  }

  void _focusAnalyzerInput({required bool selectAll}) {
    final text = _controller.text;
    _inputFocusNode.requestFocus();
    _controller.selection = selectAll && text.isNotEmpty
        ? TextSelection(baseOffset: 0, extentOffset: text.length)
        : TextSelection.collapsed(offset: text.length);
  }

  List<Widget> _buildAnalysisSections(
    AppLocalizations l10n,
    ThemeData theme, {
    required ProgressionAnalysis analysis,
    required List<ProgressionVariation> variations,
    required List<String> summary,
    required List<String> warnings,
    required ExplanationBundle explanationBundle,
    bool includeResultsCardKey = false,
  }) {
    final keyCandidates = analysis.keyCandidates.take(5).toList();
    final groupedMeasures = analysis.groupedMeasures;
    final sections = <Widget>[];

    void addSection(Widget section) {
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 12));
      }
      sections.add(section);
    }

    addSection(
      _SectionCard(
        title: l10n.chordAnalyzerProgressionSummary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (analysis.highlightCategories.isNotEmpty) ...[
              _AnalyzerLegendWrap(
                categories: ProgressionHighlightCategory.values
                    .where(analysis.highlightCategories.contains)
                    .toList(growable: false),
                highlightTheme: _highlightTheme,
              ),
              const SizedBox(height: 12),
            ],
            if (analysis.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in analysis.tags)
                    (() {
                      final category = _highlightCategoryForTag(tag);
                      final color = category == null
                          ? null
                          : _highlightTheme.colorFor(category);
                      return Chip(
                        backgroundColor: color == null
                            ? theme.colorScheme.surfaceContainerHighest
                            : _softHighlightBackground(color),
                        side: BorderSide(
                          color: color == null
                              ? theme.colorScheme.outlineVariant
                              : color.withValues(alpha: 0.45),
                        ),
                        label: Text(_explainer.tagLabel(l10n, tag)),
                        visualDensity: VisualDensity.compact,
                      );
                    })(),
                ],
              ),
              const SizedBox(height: 12),
            ],
            for (final line in summary) ...[
              Text(line),
              const SizedBox(height: 8),
            ],
            if (analysis.alternativeKey != null) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.chordAnalyzerCompetingReadings}: '
                '${_explainer.keyLabel(l10n, analysis.alternativeKey!.keyCenter)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    addSection(
      _SectionCard(
        key: const ValueKey('analyzer-explanation-card'),
        title: l10n.explanationSectionTitle,
        child: ExplanationBundlePanel(
          key: const ValueKey('analyzer-explanation-panel'),
          bundle: explanationBundle,
          compact: true,
        ),
      ),
    );

    addSection(
      _SectionCard(
        key: const ValueKey('analyzer-result-input-card'),
        title: l10n.chordAnalyzerInputLabel,
        child: SelectableText(
          analysis.input,
          key: const ValueKey('analyzer-result-input'),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.45,
          ),
        ),
      ),
    );

    if (analysis.confidence < 0.55) {
      addSection(
        _LowConfidenceBanner(
          title: l10n.chordAnalyzerLowConfidenceTitle,
          body: l10n.chordAnalyzerLowConfidenceBody,
        ),
      );
    }

    addSection(
      _SectionCard(
        key: includeResultsCardKey
            ? const ValueKey('analyzer-results-card')
            : null,
        title: l10n.chordAnalyzerDetectedKeys,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetricMeter(
              label: l10n.chordAnalyzerConfidenceLabel,
              value: analysis.confidence,
            ),
            const SizedBox(height: 10),
            _MetricMeter(
              label: l10n.chordAnalyzerAmbiguityLabel,
              value: analysis.ambiguity,
              invertColor: true,
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < keyCandidates.length; index += 1) ...[
              _KeyCandidateRow(
                label: _candidateLabel(l10n, index),
                value: _explainer.keyLabel(
                  l10n,
                  keyCandidates[index].keyCenter,
                ),
                confidence: keyCandidates[index].confidence,
              ),
              if (index != keyCandidates.length - 1) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );

    if (warnings.isNotEmpty) {
      addSection(
        _SectionCard(
          title: l10n.chordAnalyzerWarnings,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < warnings.length; index += 1) ...[
                Text(warnings[index]),
                if (index != warnings.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      );
    }

    addSection(
      _SectionCard(
        title: l10n.chordAnalyzerChordAnalysis,
        child: Column(
          children: [
            for (
              var measureIndex = 0;
              measureIndex < groupedMeasures.length;
              measureIndex += 1
            ) ...[
              _buildMeasureSection(l10n, theme, groupedMeasures[measureIndex]),
              if (measureIndex != groupedMeasures.length - 1)
                const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );

    if (variations.isNotEmpty) {
      addSection(
        _SectionCard(
          title: l10n.chordAnalyzerVariationsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.chordAnalyzerVariationsBody,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              for (var index = 0; index < variations.length; index += 1) ...[
                _VariationSuggestionCard(
                  variation: variations[index],
                  title: _variationTitle(l10n, variations[index].kind),
                  body: _variationBody(l10n, variations[index].kind),
                  onApply: () => _applyVariation(variations[index]),
                ),
                if (index != variations.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final analysis = _analysis;
    final variations = _advancedActionsEnabled
        ? _variations
        : const <ProgressionVariation>[];
    final size = MediaQuery.sizeOf(context);
    final compactLayout = size.width < 720 && size.height < 980;
    final summary = analysis == null
        ? const <String>[]
        : _explainer.buildSummary(l10n, analysis, detailLevel: _detailLevel);
    final warnings = analysis == null
        ? const <String>[]
        : _warningTexts(l10n, analysis);
    final explanationBundle = analysis == null
        ? null
        : _bundleBuilder.build(l10n: l10n, analysis: analysis);

    final heroCard = _buildAnalyzerHeroCard(
      context,
      l10n,
      theme,
      colorScheme,
      compactLayout,
      summary,
    );

    final resultsBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heroCard,
        if (analysis != null) ...[
          const SizedBox(height: 12),
          ..._buildAnalysisSections(
            l10n,
            theme,
            analysis: analysis,
            variations: variations,
            summary: summary,
            warnings: warnings,
            explanationBundle: explanationBundle!,
            includeResultsCardKey: true,
          ),
        ],
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chordAnalyzerTitle),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          Tooltip(
            message: '${l10n.chordAnalyzerDisplaySettings} (Ctrl/Cmd+,)',
            child: IconButton(
              key: const ValueKey('analyzer-display-settings-button'),
              onPressed: _openDisplaySettings,
              icon: const Icon(Icons.palette_outlined),
            ),
          ),
        ],
      ),
      body: Focus(
        focusNode: _shortcutFocusNode,
        autofocus: true,
        onKeyEvent: (_, event) {
          if (event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }
          final keyboard = HardwareKeyboard.instance;
          if (event.logicalKey == LogicalKeyboardKey.f1) {
            unawaited(_showInputHelp());
            return KeyEventResult.handled;
          }
          final isDisplaySettingsShortcut =
              event.logicalKey == LogicalKeyboardKey.comma &&
              (keyboard.isControlPressed || keyboard.isMetaPressed);
          if (isDisplaySettingsShortcut) {
            unawaited(_openDisplaySettings());
            return KeyEventResult.handled;
          }
          final isAnalyzeShortcut =
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.numpadEnter) &&
              (keyboard.isControlPressed || keyboard.isMetaPressed);
          final isFocusInputShortcut =
              (event.logicalKey == LogicalKeyboardKey.keyL ||
                  event.logicalKey == LogicalKeyboardKey.keyA) &&
              (keyboard.isControlPressed || keyboard.isMetaPressed);
          if (isFocusInputShortcut) {
            _focusAnalyzerInput(selectAll: true);
            return KeyEventResult.handled;
          }
          if (isAnalyzeShortcut &&
              !_isAnalyzing &&
              _normalizedDraft(_controller.text).isNotEmpty) {
            unawaited(_analyze());
            return KeyEventResult.handled;
          }
          final isPasteShortcut =
              event.logicalKey == LogicalKeyboardKey.keyV &&
              (keyboard.isControlPressed || keyboard.isMetaPressed);
          if (isPasteShortcut && !_isAnalyzing) {
            unawaited(_pasteIntoAnalyzerInput());
            return KeyEventResult.handled;
          }
          final isCopyShortcut =
              event.logicalKey == LogicalKeyboardKey.keyC &&
              (keyboard.isControlPressed || keyboard.isMetaPressed);
          if (isCopyShortcut && _analysis != null) {
            unawaited(_copyAnalyzedProgression());
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.keyG &&
              _analysis != null &&
              widget.controller != null) {
            unawaited(_openGeneratorFromAnalysis());
            return KeyEventResult.handled;
          }
          if (event.logicalKey != LogicalKeyboardKey.escape) {
            return KeyEventResult.ignored;
          }
          _clearAnalyzerState();
          return KeyEventResult.handled;
        },
        child: Stack(
          children: [
            Positioned(
              top: -170,
              right: -120,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(
                          alpha: isDark ? 0.2 : 0.11,
                        ),
                        colorScheme.primary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                  child: const SizedBox(width: 340, height: 340),
                ),
              ),
            ),
            Positioned(
              left: -150,
              bottom: -210,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primaryContainer.withValues(
                          alpha: isDark ? 0.28 : 0.5,
                        ),
                        colorScheme.primaryContainer.withValues(alpha: 0),
                      ],
                    ),
                  ),
                  child: const SizedBox(width: 380, height: 380),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: resultsBody,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _analysisBannerTitle(
    AppLocalizations l10n,
    ProgressionAnalysis? analysis,
    List<String> summary,
    String? errorKey,
  ) {
    if (_isAnalyzing) {
      return l10n.chordAnalyzerAnalyzing;
    }
    if (errorKey != null) {
      return l10n.chordAnalyzerInputLabel;
    }
    if (analysis != null && summary.isNotEmpty) {
      return summary.first;
    }
    return l10n.chordAnalyzerInitialTitle;
  }

  String _analysisBannerBody(
    AppLocalizations l10n,
    ProgressionAnalysis? analysis,
    List<String> summary,
    String? errorKey,
  ) {
    if (_isAnalyzing) {
      return l10n.chordAnalyzerInputHint;
    }
    if (errorKey != null) {
      return _errorTextForKey(l10n, errorKey);
    }
    if (analysis != null) {
      if (summary.length > 1) {
        return summary.skip(1).take(2).join(' ');
      }
      if (analysis.alternativeKey != null) {
        return '${l10n.chordAnalyzerCompetingReadings}: '
            '${_explainer.keyLabel(l10n, analysis.alternativeKey!.keyCenter)}';
      }
      return l10n.chordAnalyzerProgressionSummary;
    }
    return l10n.chordAnalyzerInitialBody;
  }

  List<Widget> _analysisBannerChips(
    AppLocalizations l10n,
    ProgressionAnalysis? analysis,
    String? errorKey,
  ) {
    if (_isAnalyzing || errorKey != null) {
      return const <Widget>[];
    }
    if (analysis == null) {
      return <Widget>[
        Chip(
          label: Text(l10n.chordAnalyzerAnalyze),
          visualDensity: VisualDensity.compact,
        ),
      ];
    }
    final chips = <Widget>[
      Chip(
        label: Text(
          '${l10n.chordAnalyzerConfidenceLabel} '
          '${(analysis.confidence * 100).round()}%',
        ),
        visualDensity: VisualDensity.compact,
      ),
      Chip(
        label: Text(
          '${l10n.chordAnalyzerAmbiguityLabel} '
          '${(analysis.ambiguity * 100).round()}%',
        ),
        visualDensity: VisualDensity.compact,
      ),
      Chip(
        label: Text(_explainer.keyLabel(l10n, analysis.primaryKey.keyCenter)),
        visualDensity: VisualDensity.compact,
      ),
    ];
    if (analysis.alternativeKey != null) {
      chips.add(
        Chip(
          label: Text(
            _explainer.keyLabel(l10n, analysis.alternativeKey!.keyCenter),
          ),
          visualDensity: VisualDensity.compact,
        ),
      );
    }
    return chips;
  }

  Widget _buildAnalyzerActionRow(
    AppLocalizations l10n,
    MaterialLocalizations materialL10n, {
    required bool hasInput,
  }) {
    final hasAnalysis = _analysis != null;
    final currentProgression = _normalizedDraft(
      _analysis?.input ?? _controller.text,
    );
    final isPinned =
        currentProgression.isNotEmpty &&
        _pinnedInputs.contains(currentProgression);
    final canAnalyze = hasInput && !_isAnalyzing;
    final canClear =
        hasInput || hasAnalysis || _errorKey != null || _variations.isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.end,
        children: [
          Tooltip(
            message: '${l10n.chordAnalyzerAnalyze} (Ctrl/Cmd+Enter)',
            child: FilledButton.icon(
              key: const ValueKey('analyzer-analyze-button'),
              onPressed: canAnalyze ? _analyze : null,
              icon: const Icon(Icons.insights_rounded),
              label: Text(l10n.chordAnalyzerAnalyze),
            ),
          ),
          Tooltip(
            message: '${materialL10n.pasteButtonLabel} (Ctrl/Cmd+V)',
            child: OutlinedButton.icon(
              key: const ValueKey('analyzer-paste-button'),
              onPressed: _isAnalyzing ? null : _pasteIntoAnalyzerInput,
              icon: const Icon(Icons.content_paste_rounded),
              label: Text(materialL10n.pasteButtonLabel),
            ),
          ),
          Tooltip(
            message: '${materialL10n.clearButtonTooltip} (Esc)',
            child: OutlinedButton.icon(
              key: const ValueKey('analyzer-clear-button'),
              onPressed: _isAnalyzing || !canClear ? null : _clearAnalyzerState,
              icon: const Icon(Icons.clear_rounded),
              label: Text(materialL10n.clearButtonTooltip),
            ),
          ),
          if (currentProgression.isNotEmpty)
            Tooltip(
              message: _pinButtonTooltip(context, pinned: isPinned),
              child: OutlinedButton.icon(
                key: const ValueKey('analyzer-pin-progression-button'),
                onPressed: _isAnalyzing ? null : _togglePinnedProgression,
                icon: Icon(
                  isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                ),
                label: Text(_pinButtonLabel(context, pinned: isPinned)),
              ),
            ),
          if (hasAnalysis && widget.controller != null)
            Tooltip(
              message: _practiceThisKeyTooltip(context, l10n, _analysis!),
              child: OutlinedButton.icon(
                key: const ValueKey(
                  'analyzer-open-generator-from-analysis-button',
                ),
                onPressed: _openGeneratorFromAnalysis,
                icon: const Icon(Icons.play_lesson_rounded),
                label: Text(_practiceThisKeyLabel(context)),
              ),
            ),
          if (hasAnalysis)
            Tooltip(
              message: '${materialL10n.copyButtonLabel} (Ctrl/Cmd+C)',
              child: OutlinedButton.icon(
                key: const ValueKey('analyzer-copy-progression-button'),
                onPressed: _copyAnalyzedProgression,
                icon: Icon(
                  _copyFeedbackVisible
                      ? Icons.check_rounded
                      : Icons.content_copy_rounded,
                  key: ValueKey(
                    _copyFeedbackVisible
                        ? 'analyzer-copy-success-icon'
                        : 'analyzer-copy-default-icon',
                  ),
                ),
                label: Text(materialL10n.copyButtonLabel),
              ),
            ),
          if (hasAnalysis)
            Tooltip(
              message: l10n.audioPlayProgression,
              child: OutlinedButton.icon(
                key: const ValueKey('analyzer-play-progression-button'),
                onPressed: () =>
                    _playAnalysis(pattern: HarmonyPlaybackPattern.block),
                icon: const Icon(Icons.music_note_rounded),
                label: Text(l10n.audioPlayProgression),
              ),
            ),
          if (hasAnalysis)
            Tooltip(
              message: l10n.audioPlayArpeggio,
              child: OutlinedButton.icon(
                key: const ValueKey(
                  'analyzer-play-progression-arpeggio-button',
                ),
                onPressed: () =>
                    _playAnalysis(pattern: HarmonyPlaybackPattern.arpeggio),
                icon: const Icon(Icons.multitrack_audio_rounded),
                label: Text(l10n.audioPlayArpeggio),
              ),
            ),
          if (hasAnalysis && _advancedActionsEnabled)
            Tooltip(
              message: l10n.chordAnalyzerGenerateVariations,
              child: OutlinedButton.icon(
                key: const ValueKey('analyzer-generate-variations-button'),
                onPressed: _generateVariations,
                icon: const Icon(Icons.auto_fix_high_rounded),
                label: Text(l10n.chordAnalyzerGenerateVariations),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnalyzerHeroCard(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    ColorScheme colorScheme,
    bool compactLayout,
    List<String> summary,
  ) {
    final analysis = _analysis;
    final materialL10n = MaterialLocalizations.of(context);
    final recentOnlyInputs = _recentInputs
        .where((input) => !_pinnedInputs.contains(input))
        .toList(growable: false);

    return DecoratedBox(
      decoration: _analyzerPanelDecoration(colorScheme, accent: true),
      child: Padding(
        padding: EdgeInsets.all(compactLayout ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.chordAnalyzerSubtitle,
                    style:
                        (compactLayout
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.headlineSmall)
                            ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: '${l10n.chordAnalyzerInputHelpTitle} (F1)',
                  child: IconButton.filledTonal(
                    key: const ValueKey('analyzer-help-button'),
                    onPressed: _showInputHelp,
                    icon: Text(
                      '?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AnalysisStatusBanner(
              icon: _isAnalyzing
                  ? Icons.sync_rounded
                  : analysis != null
                  ? Icons.insights_rounded
                  : _errorKey != null
                  ? Icons.warning_amber_rounded
                  : Icons.input_rounded,
              title: _analysisBannerTitle(l10n, analysis, summary, _errorKey),
              body: _analysisBannerBody(l10n, analysis, summary, _errorKey),
              chips: _analysisBannerChips(l10n, analysis, _errorKey),
              accent: analysis != null || _isAnalyzing,
              busy: _isAnalyzing,
            ),
            SizedBox(height: compactLayout ? 12 : 14),
            ChordInputEditor(
              fieldKey: const ValueKey('analyzer-input-field'),
              controller: _controller,
              focusNode: _inputFocusNode,
              labelText: l10n.chordAnalyzerInputLabel,
              hintText: l10n.chordAnalyzerInputHint,
              helperText: _analyzerQuickStartHint(context),
              tooltipMessage:
                  '${l10n.chordAnalyzerInputLabel} (Ctrl/Cmd+L, Ctrl/Cmd+A)',
              platformOverride: widget.inputPlatformOverride,
              minLines: compactLayout ? 2 : 3,
              maxLines: compactLayout ? 3 : 5,
              showDesktopKeyboardOnFocus: false,
              allowTouchRawInput: false,
              onAnalyze: _isAnalyzing ? () {} : _analyze,
            ),
            SizedBox(height: compactLayout ? 10 : 12),
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
                  Tooltip(
                    message: '${l10n.chordAnalyzerAnalyze}: $example',
                    child: ActionChip(
                      key: ValueKey('analyzer-example-$example'),
                      avatar: const Icon(Icons.insights_rounded, size: 18),
                      label: Text(example),
                      onPressed: _isAnalyzing
                          ? null
                          : () => unawaited(_applyExampleAndAnalyze(example)),
                    ),
                  ),
              ],
            ),
            if (_pinnedInputs.isNotEmpty) ...[
              SizedBox(height: compactLayout ? 12 : 14),
              Text(
                _pinnedSectionTitle(context),
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
                  for (final progression in _pinnedInputs)
                    Tooltip(
                      message: _resumeProgressionTooltip(
                        context,
                        progression,
                        pinned: true,
                      ),
                      child: ActionChip(
                        key: ValueKey('analyzer-pinned-$progression'),
                        avatar: const Icon(Icons.push_pin_rounded, size: 18),
                        label: Text(progression),
                        onPressed: _isAnalyzing
                            ? null
                            : () => unawaited(
                                _applyExampleAndAnalyze(progression),
                              ),
                      ),
                    ),
                ],
              ),
            ],
            if (recentOnlyInputs.isNotEmpty) ...[
              SizedBox(height: compactLayout ? 12 : 14),
              Text(
                _recentSectionTitle(context),
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
                  for (final progression in recentOnlyInputs)
                    Tooltip(
                      message: _resumeProgressionTooltip(
                        context,
                        progression,
                        pinned: false,
                      ),
                      child: ActionChip(
                        key: ValueKey('analyzer-recent-$progression'),
                        avatar: const Icon(Icons.history_rounded, size: 18),
                        label: Text(progression),
                        onPressed: _isAnalyzing
                            ? null
                            : () => unawaited(
                                _applyExampleAndAnalyze(progression),
                              ),
                      ),
                    ),
                ],
              ),
            ],
            SizedBox(height: compactLayout ? 12 : 16),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                return _buildAnalyzerActionRow(
                  l10n,
                  materialL10n,
                  hasInput: value.text.trim().isNotEmpty,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _errorTextForKey(AppLocalizations l10n, String? errorKey) {
    return switch (errorKey) {
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

  ProgressionHighlightCategory? _highlightCategoryForTag(ProgressionTagId tag) {
    return switch (tag) {
      ProgressionTagId.iiVI ||
      ProgressionTagId.turnaround ||
      ProgressionTagId.dominantResolution => null,
      ProgressionTagId.plagalColor ||
      ProgressionTagId.backdoorChain => ProgressionHighlightCategory.backdoor,
      ProgressionTagId.tonicization =>
        ProgressionHighlightCategory.tonicization,
      ProgressionTagId.realModulation =>
        ProgressionHighlightCategory.modulation,
      ProgressionTagId.deceptiveCadence =>
        ProgressionHighlightCategory.deceptiveCadence,
      ProgressionTagId.chromaticLine =>
        ProgressionHighlightCategory.chromaticLine,
      ProgressionTagId.commonToneMotion =>
        ProgressionHighlightCategory.commonTone,
    };
  }

  List<AnalyzedChord> _orderedMeasureAnalyses(AnalyzedMeasure measure) {
    final analysesByPosition = <int, AnalyzedChord>{
      for (final analysis in measure.chordAnalyses)
        analysis.chord.positionInMeasure: analysis,
    };
    return [
      for (final token in measure.tokens)
        ?analysesByPosition[token.positionInMeasure],
    ];
  }

  Widget _buildMeasureSection(
    AppLocalizations l10n,
    ThemeData theme,
    AnalyzedMeasure measure,
  ) {
    final orderedAnalyses = _orderedMeasureAnalyses(measure);

    return _MeasureSection(
      title: l10n.chordAnalyzerMeasureLabel(measure.measureIndex + 1),
      children: [
        if (measure.isEmpty)
          Text(
            l10n.chordAnalyzerEmptyMeasure,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (measure.parseIssues.isNotEmpty) ...[
          Text(
            l10n.chordAnalyzerParseIssuesTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          for (final issue in measure.parseIssues) ...[
            Text(_parseIssueText(l10n, issue)),
            const SizedBox(height: 4),
          ],
          if (orderedAnalyses.isNotEmpty) const SizedBox(height: 10),
        ],
        for (
          var chordIndex = 0;
          chordIndex < orderedAnalyses.length;
          chordIndex += 1
        ) ...[
          (() {
            final analysis = orderedAnalyses[chordIndex];
            final detailText = _explainer.buildChordExplanation(
              l10n,
              analysis,
              detailLevel: _detailLevel,
            );
            if (analysis.isInferred) {
              return _InferredChordAnalysisRow(
                analysis: analysis,
                explainer: _explainer,
                functionLabel: _explainer.functionLabel(
                  l10n,
                  analysis.harmonicFunction,
                ),
                detailText: detailText,
                highlightTheme: _highlightTheme,
                onPlayChord: () => _playChord(
                  analysis.chord,
                  pattern: HarmonyPlaybackPattern.block,
                ),
                onPlayArpeggio: () => _playChord(
                  analysis.chord,
                  pattern: HarmonyPlaybackPattern.arpeggio,
                ),
              );
            }
            return _ChordAnalysisRow(
              analysis: analysis,
              explainer: _explainer,
              functionLabel: _explainer.functionLabel(
                l10n,
                analysis.harmonicFunction,
              ),
              detailText: detailText,
              highlightTheme: _highlightTheme,
              onPlayChord: () => _playChord(
                analysis.chord,
                pattern: HarmonyPlaybackPattern.block,
              ),
              onPlayArpeggio: () => _playChord(
                analysis.chord,
                pattern: HarmonyPlaybackPattern.arpeggio,
              ),
            );
          })(),
          if (chordIndex != orderedAnalyses.length - 1)
            const Divider(height: 20),
        ],
        if (orderedAnalyses.isEmpty && measure.parseIssues.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.chordAnalyzerNoAnalyzableChordsInMeasure,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  String _variationTitle(AppLocalizations l10n, ProgressionVariationKind kind) {
    return switch (kind) {
      ProgressionVariationKind.cadentialColor =>
        l10n.chordAnalyzerVariationCadentialColorTitle,
      ProgressionVariationKind.backdoorColor =>
        l10n.chordAnalyzerVariationBackdoorTitle,
      ProgressionVariationKind.appliedApproach =>
        l10n.chordAnalyzerVariationAppliedApproachTitle,
      ProgressionVariationKind.minorCadenceColor =>
        l10n.chordAnalyzerVariationMinorCadenceTitle,
      ProgressionVariationKind.colorLift =>
        l10n.chordAnalyzerVariationColorLiftTitle,
    };
  }

  String _variationBody(AppLocalizations l10n, ProgressionVariationKind kind) {
    return switch (kind) {
      ProgressionVariationKind.cadentialColor =>
        l10n.chordAnalyzerVariationCadentialColorBody,
      ProgressionVariationKind.backdoorColor =>
        l10n.chordAnalyzerVariationBackdoorBody,
      ProgressionVariationKind.appliedApproach =>
        l10n.chordAnalyzerVariationAppliedApproachBody,
      ProgressionVariationKind.minorCadenceColor =>
        l10n.chordAnalyzerVariationMinorCadenceBody,
      ProgressionVariationKind.colorLift =>
        l10n.chordAnalyzerVariationColorLiftBody,
    };
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
