import 'dart:math';

import '../../l10n/app_localizations.dart';
import '../../music/chord_formatting.dart';
import '../../music/chord_theory.dart';
import '../../music/explanation_models.dart';
import '../../music/progression_analysis_models.dart';
import '../../music/progression_explanation_bundle_builder.dart';
import '../../music/progression_explainer.dart';
import '../domain/study_harmony_session_models.dart';
import '../domain/study_harmony_task_evaluators.dart';
import '../domain/study_harmony_track_profiles.dart';
import '../content/track_pedagogy_profiles.dart';
import 'study_harmony_generator_adapter.dart';

class StudyHarmonyProgressionAdapter {
  StudyHarmonyProgressionAdapter({
    StudyHarmonyGeneratorAdapter? generatorAdapter,
    ProgressionExplainer? explainer,
    ProgressionExplanationBundleBuilder? bundleBuilder,
  }) : _generatorAdapter = generatorAdapter ?? StudyHarmonyGeneratorAdapter(),
       _explainer = explainer ?? const ProgressionExplainer(),
       _bundleBuilder =
           bundleBuilder ?? const ProgressionExplanationBundleBuilder();

  final StudyHarmonyGeneratorAdapter _generatorAdapter;
  final ProgressionExplainer _explainer;
  final ProgressionExplanationBundleBuilder _bundleBuilder;

  static final List<KeyCenter> _commonCoreCenters = <KeyCenter>[
    for (final tonic in const ['C', 'G', 'D', 'F', 'A'])
      MusicTheory.keyCenterFor(tonic),
  ];

  static const Set<StudyHarmonySkillTag> _keyCenterSkills =
      <StudyHarmonySkillTag>{'progression.keyCenter'};
  static const Set<StudyHarmonySkillTag> _functionSkills =
      <StudyHarmonySkillTag>{'progression.function', 'harmony.function'};
  static const Set<StudyHarmonySkillTag> _nonDiatonicSkills =
      <StudyHarmonySkillTag>{'progression.nonDiatonic', 'harmony.diatonicity'};
  static const Set<StudyHarmonySkillTag> _fillBlankSkills =
      <StudyHarmonySkillTag>{'progression.fillBlank', 'progression.function'};

  StudyHarmonyTaskBlueprint buildKeyCenterBlueprint({
    required StudyHarmonyLessonId lessonId,
    required StudyHarmonyTaskBlueprintId blueprintId,
    required AppLocalizations l10n,
    Set<StudyHarmonySkillTag> skillTags = _keyCenterSkills,
    TrackGenerationProfile? generationProfile,
    bool? allowNonDiatonicOverride,
  }) {
    return _generatedBlueprint(
      blueprintId: blueprintId,
      lessonId: lessonId,
      l10n: l10n,
      taskKind: StudyHarmonyTaskKind.progressionKeyCenterChoice,
      skillTags: skillTags,
      generationProfile: generationProfile,
      instanceFactory:
          ({required blueprint, required sequenceNumber, required random}) {
            final progression = _generateProgression(
              random: random,
              generationProfile: generationProfile,
              minLength: 3,
              maxLength: 4,
              allowNonDiatonic:
                  allowNonDiatonicOverride ??
                  generationProfile?.allowNonDiatonic ??
                  false,
              requireSingleNonDiatonic:
                  generationProfile?.requireSingleNonDiatonic ?? false,
            );
            final keyLabel = _explainer.keyLabel(
              l10n,
              progression.analysis.primaryKey.keyCenter,
            );
            final choices = _keyCenterChoices(l10n, progression);
            final explanationBundle = _bundleBuilder.build(
              l10n: l10n,
              analysis: progression.analysis,
              trackId: generationProfile?.trackId,
              exerciseFlavor: generationProfile?.exerciseFlavor,
            );
            return _singleChoiceInstance(
              blueprint: blueprint,
              sequenceNumber: sequenceNumber,
              promptLabel: l10n.studyHarmonyPromptProgressionKeyCenter,
              choices: choices,
              correctLabel: keyLabel,
              answerSummaryLabel: keyLabel,
              progressionDisplay: _progressionDisplay(
                l10n,
                progression: progression,
              ),
              explanationTitle: l10n.studyHarmonyPromptProgressionKeyCenter,
              explanationBody: _keyCenterExplanation(
                l10n,
                progression: progression,
                generationProfile: generationProfile,
              ),
              explanationBundle: explanationBundle,
            );
          },
    );
  }

  StudyHarmonyTaskBlueprint buildFunctionBlueprint({
    required StudyHarmonyLessonId lessonId,
    required StudyHarmonyTaskBlueprintId blueprintId,
    required AppLocalizations l10n,
    Set<StudyHarmonySkillTag> skillTags = _functionSkills,
    TrackGenerationProfile? generationProfile,
    bool? allowNonDiatonicOverride,
  }) {
    return _generatedBlueprint(
      blueprintId: blueprintId,
      lessonId: lessonId,
      l10n: l10n,
      taskKind: StudyHarmonyTaskKind.progressionFunctionChoice,
      skillTags: skillTags,
      generationProfile: generationProfile,
      instanceFactory:
          ({required blueprint, required sequenceNumber, required random}) {
            final progression = _generateProgression(
              random: random,
              generationProfile: generationProfile,
              minLength: 3,
              maxLength: 4,
              allowNonDiatonic:
                  allowNonDiatonicOverride ??
                  generationProfile?.allowNonDiatonic ??
                  false,
              requireSingleNonDiatonic:
                  generationProfile?.requireSingleNonDiatonic ?? false,
              extraAcceptance: (progression) =>
                  progression.analysis.chordAnalyses.any(
                    (analysis) =>
                        analysis.harmonicFunction !=
                        ProgressionHarmonicFunction.other,
                  ),
            );
            final targetAnalysis = _pickFunctionTarget(
              progression.analysis.chordAnalyses,
              random,
            );
            final functionLabel = _functionChoiceLabel(
              l10n,
              targetAnalysis.harmonicFunction,
            );
            final explanationBundle = _bundleBuilder.build(
              l10n: l10n,
              analysis: progression.analysis,
              trackId: generationProfile?.trackId,
              exerciseFlavor: generationProfile?.exerciseFlavor,
              focusChord: targetAnalysis,
            );
            return _singleChoiceInstance(
              blueprint: blueprint,
              sequenceNumber: sequenceNumber,
              promptLabel: l10n.studyHarmonyPromptProgressionFunction(
                targetAnalysis.chord.sourceSymbol,
              ),
              choices: [
                l10n.studyHarmonyChoiceTonic,
                l10n.studyHarmonyChoicePredominant,
                l10n.studyHarmonyChoiceDominant,
                l10n.studyHarmonyChoiceOther,
              ],
              correctLabel: functionLabel,
              answerSummaryLabel: functionLabel,
              progressionDisplay: _progressionDisplay(
                l10n,
                progression: progression,
                highlightedIndex: progression.analysis.chordAnalyses.indexOf(
                  targetAnalysis,
                ),
              ),
              explanationTitle: l10n.studyHarmonyPromptProgressionFunction(
                targetAnalysis.chord.sourceSymbol,
              ),
              explanationBody: _functionExplanation(
                l10n,
                progression: progression,
                targetAnalysis: targetAnalysis,
                generationProfile: generationProfile,
              ),
              explanationBundle: explanationBundle,
            );
          },
    );
  }

  StudyHarmonyTaskBlueprint buildNonDiatonicBlueprint({
    required StudyHarmonyLessonId lessonId,
    required StudyHarmonyTaskBlueprintId blueprintId,
    required AppLocalizations l10n,
    Set<StudyHarmonySkillTag> skillTags = _nonDiatonicSkills,
    TrackGenerationProfile? generationProfile,
    bool? requireSingleNonDiatonicOverride,
  }) {
    return _generatedBlueprint(
      blueprintId: blueprintId,
      lessonId: lessonId,
      l10n: l10n,
      taskKind: StudyHarmonyTaskKind.progressionNonDiatonicChoice,
      skillTags: skillTags,
      generationProfile: generationProfile,
      instanceFactory:
          ({required blueprint, required sequenceNumber, required random}) {
            final progression = _generateProgression(
              random: random,
              generationProfile: generationProfile,
              minLength: 4,
              maxLength: 4,
              allowNonDiatonic: true,
              requireSingleNonDiatonic:
                  requireSingleNonDiatonicOverride ?? true,
            );
            final targetIndex = progression.analysis.chordAnalyses.indexWhere(
              (analysis) => analysis.isNonDiatonic,
            );
            final targetAnalysis =
                progression.analysis.chordAnalyses[targetIndex];
            final choices = [
              for (
                var index = 0;
                index < progression.chordSymbols.length;
                index += 1
              )
                l10n.studyHarmonyProgressionChoiceSlot(
                  index + 1,
                  progression.chordSymbols[index],
                ),
            ];
            final correctLabel = choices[targetIndex];
            final explanationBundle = _bundleBuilder.build(
              l10n: l10n,
              analysis: progression.analysis,
              trackId: generationProfile?.trackId,
              exerciseFlavor: generationProfile?.exerciseFlavor,
              focusChord: targetAnalysis,
            );
            return _singleChoiceInstance(
              blueprint: blueprint,
              sequenceNumber: sequenceNumber,
              promptLabel: l10n.studyHarmonyPromptProgressionNonDiatonic,
              choices: choices,
              correctLabel: correctLabel,
              answerSummaryLabel: targetAnalysis.chord.sourceSymbol,
              progressionDisplay: _progressionDisplay(
                l10n,
                progression: progression,
              ),
              explanationTitle: l10n.studyHarmonyPromptProgressionNonDiatonic,
              explanationBody: _nonDiatonicExplanation(
                l10n,
                progression: progression,
                targetAnalysis: targetAnalysis,
                generationProfile: generationProfile,
              ),
              explanationBundle: explanationBundle,
            );
          },
    );
  }

  StudyHarmonyTaskBlueprint buildMissingChordBlueprint({
    required StudyHarmonyLessonId lessonId,
    required StudyHarmonyTaskBlueprintId blueprintId,
    required AppLocalizations l10n,
    required bool cadenceFocus,
    bool? allowNonDiatonicOverride,
    bool? requireSingleNonDiatonicOverride,
    Set<StudyHarmonySkillTag> skillTags = _fillBlankSkills,
    TrackGenerationProfile? generationProfile,
  }) {
    return _generatedBlueprint(
      blueprintId: blueprintId,
      lessonId: lessonId,
      l10n: l10n,
      taskKind: StudyHarmonyTaskKind.progressionMissingChordChoice,
      skillTags: skillTags,
      generationProfile: generationProfile,
      instanceFactory:
          ({required blueprint, required sequenceNumber, required random}) {
            final progression = _generateProgression(
              random: random,
              generationProfile: generationProfile,
              minLength: 4,
              maxLength: 4,
              allowNonDiatonic:
                  allowNonDiatonicOverride ??
                  generationProfile?.allowNonDiatonic ??
                  false,
              requireSingleNonDiatonic:
                  requireSingleNonDiatonicOverride ??
                  generationProfile?.requireSingleNonDiatonic ??
                  false,
              extraAcceptance: (progression) => cadenceFocus
                  ? _hasCadentialWindow(progression.analysis)
                  : progression.analysis.chordAnalyses.length == 4,
            );
            final hiddenIndex = cadenceFocus
                ? _cadentialHiddenIndex(progression.analysis)
                : _generalHiddenIndex(progression.analysis, random);
            final hiddenAnalysis =
                progression.analysis.chordAnalyses[hiddenIndex];
            final choices = _missingChordChoices(
              progression: progression,
              hiddenIndex: hiddenIndex,
            );
            final explanationBundle = _bundleBuilder.build(
              l10n: l10n,
              analysis: progression.analysis,
              trackId: generationProfile?.trackId,
              exerciseFlavor: generationProfile?.exerciseFlavor,
              focusChord: hiddenAnalysis,
            );
            return _singleChoiceInstance(
              blueprint: blueprint,
              sequenceNumber: sequenceNumber,
              promptLabel: l10n.studyHarmonyPromptProgressionMissingChord,
              choices: choices,
              correctLabel: hiddenAnalysis.chord.sourceSymbol,
              answerSummaryLabel: hiddenAnalysis.chord.sourceSymbol,
              progressionDisplay: _progressionDisplay(
                l10n,
                progression: progression,
                hiddenIndex: hiddenIndex,
              ),
              explanationTitle: l10n.studyHarmonyPromptProgressionMissingChord,
              explanationBody: _missingChordExplanation(
                l10n,
                progression: progression,
                targetAnalysis: hiddenAnalysis,
                generationProfile: generationProfile,
              ),
              explanationBundle: explanationBundle,
            );
          },
    );
  }

  StudyHarmonyTaskBlueprint _generatedBlueprint({
    required StudyHarmonyTaskBlueprintId blueprintId,
    required StudyHarmonyLessonId lessonId,
    required AppLocalizations l10n,
    required StudyHarmonyTaskKind taskKind,
    required Set<StudyHarmonySkillTag> skillTags,
    required TrackGenerationProfile? generationProfile,
    required StudyHarmonyTaskInstanceFactory instanceFactory,
  }) {
    return StudyHarmonyTaskBlueprint(
      id: blueprintId,
      lessonId: lessonId,
      taskKind: taskKind,
      promptSpec: StudyHarmonyPromptSpec(
        id: '$blueprintId-template',
        surface: StudyHarmonyPromptSurfaceKind.text,
        primaryLabel: blueprintId,
      ),
      answerOptions: [
        StudyHarmonyAnswerChoice(
          id: 'template-choice',
          label: l10n.studyHarmonyTemplateChoiceLabel,
        ),
      ],
      answerSummaryLabel: 'template-choice',
      answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
      evaluator: SingleChoiceEvaluator(
        acceptedChoiceIds: const ['template-choice'],
        supportedTaskKinds: {taskKind},
      ),
      instanceFactory: instanceFactory,
      skillTags: skillTags,
      trackExerciseFlavor: generationProfile?.exerciseFlavor,
    );
  }

  StudyHarmonyTaskInstance _singleChoiceInstance({
    required StudyHarmonyTaskBlueprint blueprint,
    required int sequenceNumber,
    required String promptLabel,
    required List<String> choices,
    required String correctLabel,
    required String answerSummaryLabel,
    required StudyHarmonyProgressionDisplaySpec progressionDisplay,
    required String explanationTitle,
    required String explanationBody,
    ExplanationBundle? explanationBundle,
  }) {
    final labels = choices.toSet().toList(growable: false);
    final options = [
      for (var index = 0; index < labels.length; index += 1)
        StudyHarmonyAnswerChoice(id: 'choice-$index', label: labels[index]),
    ];
    final correctIndex = labels.indexOf(correctLabel);
    return StudyHarmonyTaskInstance(
      blueprintId: blueprint.id,
      lessonId: blueprint.lessonId,
      taskKind: blueprint.taskKind,
      prompt: StudyHarmonyPromptSpec(
        id: '${blueprint.id}:$sequenceNumber',
        surface: StudyHarmonyPromptSurfaceKind.text,
        primaryLabel: promptLabel,
        progressionDisplay: progressionDisplay,
      ),
      answerOptions: options,
      answerSummaryLabel: answerSummaryLabel,
      answerSurface: StudyHarmonyAnswerSurfaceKind.choiceChips,
      evaluator: SingleChoiceEvaluator(
        acceptedChoiceIds: [options[correctIndex].id],
        supportedTaskKinds: {blueprint.taskKind},
      ),
      skillTags: blueprint.skillTags,
      sequenceNumber: sequenceNumber,
      explanationTitle: explanationTitle,
      explanationBody: explanationBody,
      trackExerciseFlavor: blueprint.trackExerciseFlavor,
      explanationBundle: explanationBundle,
    );
  }

  StudyHarmonyGeneratedProgression _generateProgression({
    required Random random,
    required TrackGenerationProfile? generationProfile,
    required int minLength,
    required int maxLength,
    bool allowNonDiatonic = false,
    bool requireSingleNonDiatonic = false,
    StudyHarmonyProgressionAcceptance? extraAcceptance,
  }) {
    if (generationProfile == null) {
      return _generatorAdapter.generateCommonProgression(
        random: random,
        minLength: minLength,
        maxLength: maxLength,
        allowNonDiatonic: allowNonDiatonic,
        requireSingleNonDiatonic: requireSingleNonDiatonic,
        extraAcceptance: extraAcceptance,
      );
    }
    return _generatorAdapter.generateProgressionForProfile(
      random: random,
      profile: generationProfile,
      extraAcceptance: extraAcceptance,
      minLengthOverride: minLength,
      maxLengthOverride: maxLength,
      allowNonDiatonicOverride: allowNonDiatonic,
      requireSingleNonDiatonicOverride: requireSingleNonDiatonic,
    );
  }

  StudyHarmonyProgressionDisplaySpec _progressionDisplay(
    AppLocalizations l10n, {
    required StudyHarmonyGeneratedProgression progression,
    int? highlightedIndex,
    int? hiddenIndex,
  }) {
    return StudyHarmonyProgressionDisplaySpec(
      summaryLabel: l10n.studyHarmonyProgressionStripLabel,
      slots: [
        for (var index = 0; index < progression.chordSymbols.length; index += 1)
          StudyHarmonyProgressionSlotSpec(
            id: '${progression.analysis.input}:$index',
            label: progression.chordSymbols[index],
            measureLabel: '${index + 1}',
            isHidden: hiddenIndex == index,
            isHighlighted: highlightedIndex == index,
          ),
      ],
    );
  }

  List<String> _keyCenterChoices(
    AppLocalizations l10n,
    StudyHarmonyGeneratedProgression progression,
  ) {
    final labels = <String>[
      _explainer.keyLabel(l10n, progression.analysis.primaryKey.keyCenter),
      for (final candidate
          in progression.analysis.keyCandidates.skip(1).take(3))
        _explainer.keyLabel(l10n, candidate.keyCenter),
      for (final center in [
        ..._commonCoreCenters,
        MusicTheory.keyCenterFor(
          progression.analysis.primaryKey.keyCenter.tonicName,
          mode: KeyMode.minor,
        ),
      ])
        _explainer.keyLabel(l10n, center),
      for (final tonic in const ['E', 'Bb'])
        _explainer.keyLabel(l10n, MusicTheory.keyCenterFor(tonic)),
    ];
    final uniqueLabels = <String>[];
    for (final label in labels) {
      if (!uniqueLabels.contains(label)) {
        uniqueLabels.add(label);
      }
      if (uniqueLabels.length >= 4) {
        break;
      }
    }
    return uniqueLabels;
  }

  AnalyzedChord _pickFunctionTarget(
    List<AnalyzedChord> analyses,
    Random random,
  ) {
    final candidates = analyses
        .where(
          (analysis) =>
              analysis.harmonicFunction != ProgressionHarmonicFunction.other,
        )
        .toList(growable: false);
    final source = candidates.isEmpty ? analyses : candidates;
    return source[random.nextInt(source.length)];
  }

  String _functionChoiceLabel(
    AppLocalizations l10n,
    ProgressionHarmonicFunction function,
  ) {
    return switch (function) {
      ProgressionHarmonicFunction.tonic => l10n.studyHarmonyChoiceTonic,
      ProgressionHarmonicFunction.predominant =>
        l10n.studyHarmonyChoicePredominant,
      ProgressionHarmonicFunction.dominant => l10n.studyHarmonyChoiceDominant,
      ProgressionHarmonicFunction.other => l10n.studyHarmonyChoiceOther,
    };
  }

  String _keyCenterExplanation(
    AppLocalizations l10n, {
    required StudyHarmonyGeneratedProgression progression,
    required TrackGenerationProfile? generationProfile,
  }) {
    final keyLabel = _explainer.keyLabel(
      l10n,
      progression.analysis.primaryKey.keyCenter,
    );
    final summary = _explainer
        .buildSummary(l10n, progression.analysis)
        .join(' ');
    return '${_trackExplanationTone(l10n, generationProfile: generationProfile)} '
        '${l10n.studyHarmonyProgressionExplanationKeyCenter(keyLabel)} $summary';
  }

  String _functionExplanation(
    AppLocalizations l10n, {
    required StudyHarmonyGeneratedProgression progression,
    required AnalyzedChord targetAnalysis,
    required TrackGenerationProfile? generationProfile,
  }) {
    final functionLabel = _explainer.functionLabel(
      l10n,
      targetAnalysis.harmonicFunction,
    );
    final summary = _explainer
        .buildSummary(l10n, progression.analysis)
        .join(' ');
    return '${_trackExplanationTone(l10n, generationProfile: generationProfile)} '
        '${l10n.studyHarmonyProgressionExplanationFunction(targetAnalysis.chord.sourceSymbol, functionLabel)} $summary';
  }

  String _nonDiatonicExplanation(
    AppLocalizations l10n, {
    required StudyHarmonyGeneratedProgression progression,
    required AnalyzedChord targetAnalysis,
    required TrackGenerationProfile? generationProfile,
  }) {
    final keyLabel = _explainer.keyLabel(
      l10n,
      progression.analysis.primaryKey.keyCenter,
    );
    final remark = targetAnalysis.remarks.cast<ProgressionRemark?>().firstWhere(
      (candidate) =>
          candidate?.kind == ProgressionRemarkKind.possibleSecondaryDominant ||
          candidate?.kind == ProgressionRemarkKind.possibleTritoneSubstitute ||
          candidate?.kind == ProgressionRemarkKind.possibleModalInterchange,
      orElse: () => null,
    );
    final detail = remark == null
        ? ''
        : ' ${_explainer.remarkLabel(l10n, remark)}';
    return '${_trackExplanationTone(l10n, generationProfile: generationProfile)} '
        '${l10n.studyHarmonyProgressionExplanationNonDiatonic(targetAnalysis.chord.sourceSymbol, keyLabel)}$detail';
  }

  String _missingChordExplanation(
    AppLocalizations l10n, {
    required StudyHarmonyGeneratedProgression progression,
    required AnalyzedChord targetAnalysis,
    required TrackGenerationProfile? generationProfile,
  }) {
    final functionLabel = _explainer.functionLabel(
      l10n,
      targetAnalysis.harmonicFunction,
    );
    final summary = _explainer
        .buildSummary(l10n, progression.analysis)
        .join(' ');
    return '${_trackExplanationTone(l10n, generationProfile: generationProfile)} '
        '${l10n.studyHarmonyProgressionExplanationMissingChord(targetAnalysis.chord.sourceSymbol, functionLabel)} $summary';
  }

  String _trackExplanationTone(
    AppLocalizations l10n, {
    required TrackGenerationProfile? generationProfile,
  }) {
    if (generationProfile == null) {
      return '';
    }

    final pedagogy = trackPedagogyProfileForTrack(
      l10n,
      generationProfile.trackId,
    );
    final context = switch (generationProfile.trackId) {
      'pop' => l10n.explanationTrackContextPop,
      'jazz' => l10n.explanationTrackContextJazz,
      'classical' => l10n.explanationTrackContextClassical,
      _ => '',
    };

    final exerciseLead = _exerciseToneFocus(
      pedagogy: pedagogy,
      exerciseFlavor: generationProfile.exerciseFlavor,
    );

    final parts = <String>[
      if (context.isNotEmpty) context,
      pedagogy.theoryTone,
      if (exerciseLead.isNotEmpty) exerciseLead,
    ];
    return parts.join(' ');
  }

  String _exerciseToneFocus({
    required TrackPedagogyProfile pedagogy,
    required TrackExerciseFlavor exerciseFlavor,
  }) {
    String focusAt(int index) {
      if (index < pedagogy.focusPoints.length) {
        return pedagogy.focusPoints[index];
      }
      return '';
    }

    switch (exerciseFlavor) {
      case TrackExerciseFlavor.popHookLoop:
      case TrackExerciseFlavor.jazzGuideTone:
      case TrackExerciseFlavor.jazzShellVoicing:
      case TrackExerciseFlavor.classicalCadence:
        return focusAt(0);
      case TrackExerciseFlavor.popBorrowedLift:
      case TrackExerciseFlavor.jazzMinorCadence:
      case TrackExerciseFlavor.jazzRootlessVoicing:
      case TrackExerciseFlavor.classicalInversion:
        return focusAt(1);
      case TrackExerciseFlavor.popBassMotion:
      case TrackExerciseFlavor.jazzDominantColor:
      case TrackExerciseFlavor.jazzBackdoorCadence:
      case TrackExerciseFlavor.classicalSecondaryDominant:
        return focusAt(2);
      case TrackExerciseFlavor.coreFunctional:
        return '';
    }
  }

  bool _hasCadentialWindow(ProgressionAnalysis analysis) {
    if (analysis.chordAnalyses.length < 3) {
      return false;
    }
    final last = analysis.chordAnalyses.last;
    if (last.harmonicFunction != ProgressionHarmonicFunction.tonic) {
      return false;
    }
    return analysis.chordAnalyses.take(analysis.chordAnalyses.length - 1).any((
      analysis,
    ) {
      return analysis.harmonicFunction ==
              ProgressionHarmonicFunction.dominant ||
          analysis.harmonicFunction == ProgressionHarmonicFunction.predominant;
    });
  }

  int _cadentialHiddenIndex(ProgressionAnalysis analysis) {
    final analyses = analysis.chordAnalyses;
    for (var index = analyses.length - 2; index >= 1; index -= 1) {
      if (analyses[index].harmonicFunction ==
          ProgressionHarmonicFunction.dominant) {
        return index;
      }
    }
    return analyses.length - 2;
  }

  int _generalHiddenIndex(ProgressionAnalysis analysis, Random random) {
    final analyses = analysis.chordAnalyses;
    if (analyses.length <= 2) {
      return 0;
    }
    return 1 + random.nextInt(analyses.length - 2);
  }

  List<String> _missingChordChoices({
    required StudyHarmonyGeneratedProgression progression,
    required int hiddenIndex,
  }) {
    final analysis = progression.analysis;
    final target = analysis.chordAnalyses[hiddenIndex];
    final keyCenter = analysis.primaryKey.keyCenter;
    final correctLabel = target.chord.sourceSymbol;
    final labels = <String>[correctLabel];

    final sameFunctionDistractor = _sameFunctionDistractor(
      keyCenter: keyCenter,
      target: target,
    );
    final lessFittingDistractor = _lessFittingDiatonicDistractor(
      keyCenter: keyCenter,
      target: target,
    );
    final awkwardDistractor = _awkwardDistractor(
      keyCenter: keyCenter,
      target: target,
    );

    for (final candidate in [
      sameFunctionDistractor,
      lessFittingDistractor,
      awkwardDistractor,
    ]) {
      if (candidate != null && !labels.contains(candidate)) {
        labels.add(candidate);
      }
    }

    for (final chord in progression.chordSymbols) {
      if (!labels.contains(chord)) {
        labels.add(chord);
      }
      if (labels.length >= 4) {
        break;
      }
    }

    return labels.take(4).toList(growable: false);
  }

  String? _sameFunctionDistractor({
    required KeyCenter keyCenter,
    required AnalyzedChord target,
  }) {
    if (target.isNonDiatonic) {
      return _romanChordLabel(keyCenter, RomanNumeralId.vDom7);
    }

    final pool = switch (target.harmonicFunction) {
      ProgressionHarmonicFunction.tonic => const [
        RomanNumeralId.viMin7,
        RomanNumeralId.iiiMin7,
      ],
      ProgressionHarmonicFunction.predominant => const [
        RomanNumeralId.iiMin7,
        RomanNumeralId.ivMaj7,
      ],
      ProgressionHarmonicFunction.dominant => const [
        RomanNumeralId.viiHalfDiminished7,
        RomanNumeralId.vDom7,
      ],
      ProgressionHarmonicFunction.other => const [
        RomanNumeralId.iiiMin7,
        RomanNumeralId.viMin7,
      ],
    };
    for (final romanId in pool) {
      final label = _romanChordLabel(keyCenter, romanId);
      if (label != target.chord.sourceSymbol) {
        return label;
      }
    }
    return null;
  }

  String? _lessFittingDiatonicDistractor({
    required KeyCenter keyCenter,
    required AnalyzedChord target,
  }) {
    final romanId = switch (target.harmonicFunction) {
      ProgressionHarmonicFunction.tonic => RomanNumeralId.iiMin7,
      ProgressionHarmonicFunction.predominant => RomanNumeralId.iMaj7,
      ProgressionHarmonicFunction.dominant => RomanNumeralId.viMin7,
      ProgressionHarmonicFunction.other => RomanNumeralId.iMaj7,
    };
    final label = _romanChordLabel(keyCenter, romanId);
    return label == target.chord.sourceSymbol ? null : label;
  }

  String _awkwardDistractor({
    required KeyCenter keyCenter,
    required AnalyzedChord target,
  }) {
    final awkwardRoot = MusicTheory.transposePitch(
      keyCenter.tonicName,
      1,
      preferFlat: keyCenter.prefersFlatSpelling,
    );
    final awkward = ChordSymbolFormatter.format(
      ChordSymbolData(
        root: awkwardRoot,
        harmonicQuality: ChordQuality.major7,
        renderQuality: ChordQuality.major7,
      ),
      ChordSymbolStyle.majText,
    );
    if (awkward != target.chord.sourceSymbol) {
      return awkward;
    }
    return ChordSymbolFormatter.format(
      ChordSymbolData(
        root: MusicTheory.transposePitch(
          keyCenter.tonicName,
          6,
          preferFlat: keyCenter.prefersFlatSpelling,
        ),
        harmonicQuality: ChordQuality.dominant7,
        renderQuality: ChordQuality.dominant7,
      ),
      ChordSymbolStyle.majText,
    );
  }

  String _romanChordLabel(KeyCenter keyCenter, RomanNumeralId romanId) {
    final spec = MusicTheory.specFor(romanId);
    return ChordSymbolFormatter.format(
      ChordSymbolData(
        root: MusicTheory.resolveChordRootForCenter(keyCenter, romanId),
        harmonicQuality: spec.quality,
        renderQuality: spec.quality,
      ),
      ChordSymbolStyle.majText,
    );
  }
}
