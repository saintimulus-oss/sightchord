import 'dart:async';

import 'package:flutter/material.dart';

import '../audio/harmony_audio_models.dart';
import '../audio/harmony_preview_resolver.dart';
import '../audio/sightchord_audio_scope.dart';
import '../l10n/app_localizations.dart';
import '../music/chord_theory.dart';
import 'practice_setup_models.dart';
import 'practice_setup_preview.dart';
import 'practice_settings.dart';
import 'practice_settings_factory.dart';

Future<PracticeSettings?> showPracticeSetupAssistant({
  required BuildContext context,
  required PracticeSettings currentSettings,
  bool mandatory = false,
  VoidCallback? onOpenStudyHarmony,
}) {
  return showModalBottomSheet<PracticeSettings>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: !mandatory,
    enableDrag: !mandatory,
    showDragHandle: !mandatory,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.96,
        child: PracticeSetupAssistantSheet(
          currentSettings: currentSettings,
          mandatory: mandatory,
          onOpenStudyHarmony: onOpenStudyHarmony,
        ),
      );
    },
  );
}

class PracticeSetupAssistantSheet extends StatefulWidget {
  const PracticeSetupAssistantSheet({
    super.key,
    required this.currentSettings,
    required this.mandatory,
    this.onOpenStudyHarmony,
  });

  final PracticeSettings currentSettings;
  final bool mandatory;
  final VoidCallback? onOpenStudyHarmony;

  @override
  State<PracticeSetupAssistantSheet> createState() =>
      _PracticeSetupAssistantSheetState();
}

class _PracticeSetupAssistantSheetState
    extends State<PracticeSetupAssistantSheet> {
  late GeneratorProfile _profile;
  PracticeSettings? _previewSettingsOverride;
  int _stepIndex = 0;
  bool _playingPreview = false;

  PracticeSettings get _resolvedPreviewSettings =>
      _previewSettingsOverride ??
      PracticeSettingsFactory.fromGeneratorProfile(
        _profile,
        baseSettings: widget.currentSettings,
      );

  PracticeSetupPreview get _preview =>
      PracticeSetupPreviewBuilder.fromSettings(
        settings: _resolvedPreviewSettings,
      );

  @override
  void initState() {
    super.initState();
    _profile = PracticeSettingsFactory.profileFromSettings(
      widget.currentSettings,
    );
  }

  List<_AssistantStep> get _visibleSteps {
    return [
      _AssistantStep.goal,
      _AssistantStep.literacy,
      if (_profile.asksHandComfort) _AssistantStep.handComfort,
      if (_profile.asksExplorationPreference) _AssistantStep.exploration,
      _AssistantStep.symbolStyle,
      _AssistantStep.startingKey,
      _AssistantStep.preview,
    ];
  }

  void _normalizeStepIndex() {
    final maxIndex = _visibleSteps.length - 1;
    if (_stepIndex > maxIndex) {
      _stepIndex = maxIndex;
    }
  }

  void _updateProfile(GeneratorProfile nextProfile) {
    setState(() {
      _profile = nextProfile;
      _previewSettingsOverride = null;
      _normalizeStepIndex();
    });
  }

  void _goBack() {
    if (_stepIndex == 0) {
      if (!widget.mandatory) {
        Navigator.of(context).maybePop();
      }
      return;
    }
    setState(() {
      _stepIndex -= 1;
    });
  }

  void _goNext() {
    final steps = _visibleSteps;
    if (_stepIndex >= steps.length - 1) {
      _applyProfile();
      return;
    }
    setState(() {
      _stepIndex += 1;
    });
  }

  void _skipAssistant() {
    _finishWithSettings(
      PracticeSettingsFactory.beginnerSafePreset(
        baseSettings: widget.currentSettings,
      ),
    );
  }

  void _applyProfile() {
    _finishWithSettings(_resolvedPreviewSettings);
  }

  void _finishWithSettings(PracticeSettings settings) {
    Navigator.of(context).pop(settings);
  }

  void _adjustPreview(
    PracticeSettings Function(PracticeSettings current) transform,
  ) {
    setState(() {
      final adjustedSettings = transform(_resolvedPreviewSettings);
      _previewSettingsOverride = adjustedSettings;
      _profile = PracticeSettingsFactory.profileFromSettings(adjustedSettings);
      _normalizeStepIndex();
    });
  }

  bool _adjustmentChanges(
    PracticeSettings Function(PracticeSettings current) transform,
  ) {
    final current = _resolvedPreviewSettings;
    final adjusted = transform(current);
    return adjusted.settingsComplexityMode != current.settingsComplexityMode ||
        adjusted.preferredSuggestionKind != current.preferredSuggestionKind ||
        adjusted.chordLanguageLevel != current.chordLanguageLevel ||
        adjusted.romanPoolPreset != current.romanPoolPreset ||
        adjusted.allowTensions != current.allowTensions ||
        adjusted.maxVoicingNotes != current.maxVoicingNotes ||
        adjusted.voicingComplexity != current.voicingComplexity ||
        adjusted.allowRootlessVoicings != current.allowRootlessVoicings ||
        adjusted.secondaryDominantEnabled !=
            current.secondaryDominantEnabled ||
        adjusted.modulationIntensity != current.modulationIntensity;
  }

  Future<void> _playPreview() async {
    if (_playingPreview) {
      return;
    }
    final harmonyAudio = SightChordAudioScope.maybeOf(context);
    if (harmonyAudio == null) {
      return;
    }
    final preview = _preview;
    final chordLabels = preview.chordSymbols();
    final clips = [
      for (var index = 0; index < preview.chords.length; index += 1)
        HarmonyPreviewResolver.fromGeneratedChord(
          preview.chords[index],
          label: chordLabels[index],
        ),
    ];
    if (clips.isEmpty) {
      return;
    }

    setState(() {
      _playingPreview = true;
    });
    try {
      await harmonyAudio.stopAll();
      await harmonyAudio.warmUp();
      await harmonyAudio.playSequence(
        clips,
        pattern: HarmonyPlaybackPattern.block,
        gap: const Duration(milliseconds: 180),
        hold: const Duration(milliseconds: 720),
      );
    } finally {
      if (mounted) {
        setState(() {
          _playingPreview = false;
        });
      }
    }
  }

  Future<void> _openStudyHarmony() async {
    final callback = widget.onOpenStudyHarmony;
    if (callback == null) {
      return;
    }
    _finishWithSettings(_resolvedPreviewSettings);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    callback();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final steps = _visibleSteps;
    final currentStep = steps[_stepIndex];
    final progress = steps.length <= 1 ? 1.0 : (_stepIndex + 1) / steps.length;
    final isPreviewStep = currentStep == _AssistantStep.preview;

    return PopScope(
      canPop: !widget.mandatory,
      child: DecoratedBox(
        key: const ValueKey('setup-assistant-sheet'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.setupAssistantTitle,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!widget.mandatory)
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close),
                          tooltip: l10n.closeSettings,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.setupAssistantSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.setupAssistantProgress(_stepIndex + 1, steps.length),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: _buildStepContent(context, currentStep: currentStep),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: isPreviewStep
                    ? _buildPreviewActions(context)
                    : Row(
                        children: [
                          if (_stepIndex > 0)
                            OutlinedButton(
                              onPressed: _goBack,
                              child: Text(l10n.setupAssistantBack),
                            )
                          else
                            const SizedBox(width: 90),
                          const Spacer(),
                          TextButton(
                            onPressed: _skipAssistant,
                            child: Text(l10n.setupAssistantSkip),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _goNext,
                            child: Text(l10n.setupAssistantNext),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context, {
    required _AssistantStep currentStep,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final preview = _preview;
    return switch (currentStep) {
      _AssistantStep.goal => _AssistantQuestion(
        title: l10n.setupAssistantGoalQuestionTitle,
        subtitle: l10n.setupAssistantGoalQuestionBody,
        children: [
          _ChoiceCard(
            title: l10n.setupAssistantGoalEarTitle,
            description: l10n.setupAssistantGoalEarBody,
            selected: _profile.goal == OnboardingGoal.earTraining,
            onTap: () => _updateProfile(
              _profile.copyWith(goal: OnboardingGoal.earTraining),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantGoalKeyboardTitle,
            description: l10n.setupAssistantGoalKeyboardBody,
            selected: _profile.goal == OnboardingGoal.keyboardPractice,
            onTap: () => _updateProfile(
              _profile.copyWith(goal: OnboardingGoal.keyboardPractice),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantGoalSongTitle,
            description: l10n.setupAssistantGoalSongBody,
            selected: _profile.goal == OnboardingGoal.songIdeas,
            onTap: () => _updateProfile(
              _profile.copyWith(goal: OnboardingGoal.songIdeas),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantGoalHarmonyTitle,
            description: l10n.setupAssistantGoalHarmonyBody,
            selected: _profile.goal == OnboardingGoal.harmonyStudy,
            onTap: () => _updateProfile(
              _profile.copyWith(goal: OnboardingGoal.harmonyStudy),
            ),
          ),
        ],
      ),
      _AssistantStep.literacy => _AssistantQuestion(
        title: l10n.setupAssistantLiteracyQuestionTitle,
        subtitle: l10n.setupAssistantLiteracyQuestionBody,
        children: [
          _ChoiceCard(
            title: l10n.setupAssistantLiteracyAbsoluteTitle,
            description: l10n.setupAssistantLiteracyAbsoluteBody,
            selected:
                _profile.harmonyLiteracy == HarmonyLiteracy.absoluteBeginner,
            onTap: () => _updateProfile(
              _profile.copyWith(
                harmonyLiteracy: HarmonyLiteracy.absoluteBeginner,
              ),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantLiteracyBasicTitle,
            description: l10n.setupAssistantLiteracyBasicBody,
            selected:
                _profile.harmonyLiteracy == HarmonyLiteracy.basicChordReader,
            onTap: () => _updateProfile(
              _profile.copyWith(
                harmonyLiteracy: HarmonyLiteracy.basicChordReader,
              ),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantLiteracyFunctionalTitle,
            description: l10n.setupAssistantLiteracyFunctionalBody,
            selected:
                _profile.harmonyLiteracy == HarmonyLiteracy.functionalHarmony,
            onTap: () => _updateProfile(
              _profile.copyWith(
                harmonyLiteracy: HarmonyLiteracy.functionalHarmony,
              ),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantLiteracyAdvancedTitle,
            description: l10n.setupAssistantLiteracyAdvancedBody,
            selected: _profile.harmonyLiteracy == HarmonyLiteracy.reharmReady,
            onTap: () => _updateProfile(
              _profile.copyWith(harmonyLiteracy: HarmonyLiteracy.reharmReady),
            ),
          ),
        ],
      ),
      _AssistantStep.handComfort => _AssistantQuestion(
        title: l10n.setupAssistantHandQuestionTitle,
        subtitle: l10n.setupAssistantHandQuestionBody,
        children: [
          _ChoiceCard(
            title: l10n.setupAssistantHandThreeTitle,
            description: l10n.setupAssistantHandThreeBody,
            selected: _profile.handComfort == HandComfort.threeNotes,
            onTap: () => _updateProfile(
              _profile.copyWith(handComfort: HandComfort.threeNotes),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantHandFourTitle,
            description: l10n.setupAssistantHandFourBody,
            selected: _profile.handComfort == HandComfort.fourNotes,
            onTap: () => _updateProfile(
              _profile.copyWith(handComfort: HandComfort.fourNotes),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantHandJazzTitle,
            description: l10n.setupAssistantHandJazzBody,
            selected: _profile.handComfort == HandComfort.jazzShapes,
            onTap: () => _updateProfile(
              _profile.copyWith(handComfort: HandComfort.jazzShapes),
            ),
          ),
        ],
      ),
      _AssistantStep.exploration => _AssistantQuestion(
        title: l10n.setupAssistantColorQuestionTitle,
        subtitle: l10n.setupAssistantColorQuestionBody,
        children: [
          _ChoiceCard(
            title: l10n.setupAssistantColorSafeTitle,
            description: l10n.setupAssistantColorSafeBody,
            selected:
                _profile.explorationPreference == ExplorationPreference.safe,
            onTap: () => _updateProfile(
              _profile.copyWith(
                explorationPreference: ExplorationPreference.safe,
              ),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantColorJazzyTitle,
            description: l10n.setupAssistantColorJazzyBody,
            selected:
                _profile.explorationPreference == ExplorationPreference.jazzy,
            onTap: () => _updateProfile(
              _profile.copyWith(
                explorationPreference: ExplorationPreference.jazzy,
              ),
            ),
          ),
          _ChoiceCard(
            title: l10n.setupAssistantColorColorfulTitle,
            description: l10n.setupAssistantColorColorfulBody,
            selected:
                _profile.explorationPreference ==
                ExplorationPreference.colorful,
            onTap: () => _updateProfile(
              _profile.copyWith(
                explorationPreference: ExplorationPreference.colorful,
              ),
            ),
          ),
        ],
      ),
      _AssistantStep.symbolStyle => _AssistantQuestion(
        title: l10n.setupAssistantSymbolQuestionTitle,
        subtitle: l10n.setupAssistantSymbolQuestionBody,
        children: [
          _ChoiceCard(
            title: 'Cmaj7',
            description: l10n.setupAssistantSymbolMajTextBody,
            selected: _profile.chordSymbolStyle == ChordSymbolStyle.majText,
            onTap: () => _updateProfile(
              _profile.copyWith(chordSymbolStyle: ChordSymbolStyle.majText),
            ),
          ),
          _ChoiceCard(
            title: 'CM7',
            description: l10n.setupAssistantSymbolCompactBody,
            selected: _profile.chordSymbolStyle == ChordSymbolStyle.compact,
            onTap: () => _updateProfile(
              _profile.copyWith(chordSymbolStyle: ChordSymbolStyle.compact),
            ),
          ),
          _ChoiceCard(
            title: 'C?7',
            description: l10n.setupAssistantSymbolDeltaBody,
            selected: _profile.chordSymbolStyle == ChordSymbolStyle.deltaJazz,
            onTap: () => _updateProfile(
              _profile.copyWith(chordSymbolStyle: ChordSymbolStyle.deltaJazz),
            ),
          ),
        ],
      ),
      _AssistantStep.startingKey => _AssistantQuestion(
        title: l10n.setupAssistantKeyQuestionTitle,
        subtitle: l10n.setupAssistantKeyQuestionBody,
        children: [
          for (final center in GeneratorProfile.supportedStartingKeyCenters)
            _ChoiceCard(
              title: _keyCenterLabel(l10n, center),
              description: _keyCenterDescription(l10n, center),
              selected: _profile.startingKeyCenter == center,
              onTap: () =>
                _updateProfile(_profile.copyWith(startingKeyCenter: center)),
            ),
        ],
      ),
      _AssistantStep.preview => _AssistantQuestion(
        title: l10n.setupAssistantPreviewTitle,
        subtitle: l10n.setupAssistantPreviewBody,
        children: [
          _buildPreviewSummaryCard(context, preview),
          const SizedBox(height: 12),
          _buildPreviewProgressionCard(context, preview),
          if (SightChordAudioScope.maybeOf(context) != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _playingPreview ? null : _playPreview,
                icon: Icon(
                  _playingPreview
                      ? Icons.graphic_eq_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  _playingPreview
                      ? l10n.setupAssistantPreviewPlaying
                      : l10n.setupAssistantPreviewListen,
                ),
              ),
            ),
          ],
          if (preview.recommendsStudyHarmony) ...[
            const SizedBox(height: 12),
            _buildStudyHarmonyCard(context),
          ],
        ],
      ),
    };
  }

  Widget _buildPreviewActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            OutlinedButton(
              onPressed: _goBack,
              child: Text(l10n.setupAssistantBack),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _applyProfile,
          child: Text(l10n.setupAssistantStartNow),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _adjustmentChanges(
                  PracticeSettingsFactory.nudgeTowardEasier,
                )
                    ? () => _adjustPreview(
                        PracticeSettingsFactory.nudgeTowardEasier,
                      )
                    : null,
                child: Text(l10n.setupAssistantAdjustEasier),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonal(
                onPressed: _adjustmentChanges(
                  PracticeSettingsFactory.nudgeTowardJazzier,
                )
                    ? () => _adjustPreview(
                        PracticeSettingsFactory.nudgeTowardJazzier,
                      )
                    : null,
                child: Text(l10n.setupAssistantAdjustJazzier),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreviewSummaryCard(
    BuildContext context,
    PracticeSetupPreview preview,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _profileSummaryTitle(l10n, preview.profile),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _profileSummaryBody(l10n, preview.settings),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _PreviewStatCard(
                    icon: Icons.place_rounded,
                    label: l10n.setupAssistantPreviewKeyLabel,
                    value: _keyCenterLabel(l10n, preview.startingKeyCenter),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PreviewStatCard(
                    icon: Icons.text_fields_rounded,
                    label: l10n.setupAssistantPreviewNotationLabel,
                    value: _notationSummaryLabel(
                      l10n,
                      preview.settings.chordSymbolStyle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _PreviewStatCard(
              icon: Icons.auto_awesome_rounded,
              label: l10n.setupAssistantPreviewDifficultyLabel,
              value: _difficultySummaryLabel(l10n, preview.settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewProgressionCard(
    BuildContext context,
    PracticeSetupPreview preview,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final symbols = preview.chordSymbols();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.setupAssistantPreviewProgressionLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.setupAssistantPreviewProgressionBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final symbol in symbols)
                  Chip(
                    label: Text(symbol),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyHarmonyCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.setupAssistantStudyHarmonyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.setupAssistantStudyHarmonyBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            if (widget.onOpenStudyHarmony != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _openStudyHarmony,
                icon: const Icon(Icons.school_rounded),
                label: Text(l10n.setupAssistantStudyHarmonyCta),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _keyCenterLabel(AppLocalizations l10n, KeyCenter center) {
    return '${MusicTheory.displayRootForKey(center.tonicName)} ${l10n.modeMajor}';
  }

  String _keyCenterDescription(AppLocalizations l10n, KeyCenter center) {
    return switch (center.tonicName) {
      'C' => l10n.setupAssistantKeyCMajorBody,
      'G' => l10n.setupAssistantKeyGMajorBody,
      'F' => l10n.setupAssistantKeyFMajorBody,
      _ => l10n.setupAssistantKeyCMajorBody,
    };
  }

  String _profileSummaryTitle(
    AppLocalizations l10n,
    GeneratorProfile profile,
  ) {
    return switch (profile.harmonyLiteracy) {
      HarmonyLiteracy.absoluteBeginner =>
        l10n.setupAssistantPreviewSummaryAbsolute,
      HarmonyLiteracy.basicChordReader =>
        l10n.setupAssistantPreviewSummaryBasic,
      HarmonyLiteracy.functionalHarmony =>
        l10n.setupAssistantPreviewSummaryFunctional,
      HarmonyLiteracy.reharmReady =>
        l10n.setupAssistantPreviewSummaryAdvanced,
    };
  }

  String _profileSummaryBody(
    AppLocalizations l10n,
    PracticeSettings settings,
  ) {
    return switch (settings.chordLanguageLevel) {
      ChordLanguageLevel.triadsOnly =>
        l10n.setupAssistantPreviewBodyTriads,
      ChordLanguageLevel.seventhChords =>
        l10n.setupAssistantPreviewBodySevenths,
      ChordLanguageLevel.safeExtensions =>
        l10n.setupAssistantPreviewBodySafeExtensions,
      ChordLanguageLevel.fullExtensions =>
        l10n.setupAssistantPreviewBodyFullExtensions,
    };
  }

  String _notationSummaryLabel(
    AppLocalizations l10n,
    ChordSymbolStyle style,
  ) {
    return switch (style) {
      ChordSymbolStyle.majText => l10n.setupAssistantNotationMajText,
      ChordSymbolStyle.compact => l10n.setupAssistantNotationCompact,
      ChordSymbolStyle.deltaJazz => l10n.setupAssistantNotationDelta,
    };
  }

  String _difficultySummaryLabel(
    AppLocalizations l10n,
    PracticeSettings settings,
  ) {
    return switch (settings.chordLanguageLevel) {
      ChordLanguageLevel.triadsOnly => l10n.setupAssistantDifficultyTriads,
      ChordLanguageLevel.seventhChords =>
        l10n.setupAssistantDifficultySevenths,
      ChordLanguageLevel.safeExtensions =>
        l10n.setupAssistantDifficultySafeExtensions,
      ChordLanguageLevel.fullExtensions =>
        l10n.setupAssistantDifficultyFullExtensions,
    };
  }
}

enum _AssistantStep {
  goal,
  literacy,
  handComfort,
  exploration,
  symbolStyle,
  startingKey,
  preview,
}

class _AssistantQuestion extends StatelessWidget {
  const _AssistantQuestion({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }
}

class _PreviewStatCard extends StatelessWidget {
  const _PreviewStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      selected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

