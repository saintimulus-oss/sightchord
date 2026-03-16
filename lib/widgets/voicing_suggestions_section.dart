import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/voicing_models.dart';
import '../settings/practice_settings.dart';
import 'mini_keyboard.dart';

typedef VoicingSuggestionCallback = void Function(VoicingSuggestion suggestion);

class VoicingSuggestionsSection extends StatefulWidget {
  const VoicingSuggestionsSection({
    super.key,
    required this.recommendations,
    required this.displayMode,
    required this.selectedSignature,
    required this.showReasons,
    required this.onSelectSuggestion,
    required this.onToggleLock,
    this.onPlaySuggestion,
  });

  final VoicingRecommendationSet recommendations;
  final VoicingDisplayMode displayMode;
  final String? selectedSignature;
  final bool showReasons;
  final VoicingSuggestionCallback onSelectSuggestion;
  final VoicingSuggestionCallback onToggleLock;
  final VoicingSuggestionCallback? onPlaySuggestion;

  @override
  State<VoicingSuggestionsSection> createState() =>
      _VoicingSuggestionsSectionState();
}

class _VoicingSuggestionsSectionState extends State<VoicingSuggestionsSection> {
  static const List<String> _pitchClassLabels = [
    'C',
    'Db',
    'D',
    'Eb',
    'E',
    'F',
    'Gb',
    'G',
    'Ab',
    'A',
    'Bb',
    'B',
  ];

  String? _expandedKey;

  void _toggleExpanded(String key) {
    setState(() {
      _expandedKey = _expandedKey == key ? null : key;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (widget.recommendations.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.displayMode == VoicingDisplayMode.performance &&
        widget.recommendations.performancePreview != null) {
      return _buildPerformanceSection(context, l10n, theme);
    }

    final sharedKeyboardRange = MiniKeyboard.resolveSharedDisplayRange(
      widget.recommendations.suggestions.map((item) => item.voicing.midiNotes),
    );
    final sharedNoteSlotCount = widget.recommendations.suggestions
        .fold<int>(
          3,
          (currentMax, item) => math.max(currentMax, item.voicing.noteCount),
        )
        .clamp(3, 5)
        .toInt();

    return Card(
      key: const ValueKey('voicing-suggestions-section'),
      color: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.voicingSuggestionsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _sectionSubtitle(l10n),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Column(
              children: [
                for (final suggestion
                    in widget.recommendations.suggestions) ...[
                  () {
                    final expansionKey = suggestion.cardKey;
                    return _SuggestionCard(
                      suggestion: suggestion,
                      selected:
                          widget.selectedSignature ==
                          suggestion.voicing.signature,
                      expanded: _expandedKey == expansionKey,
                      showReasons: widget.showReasons,
                      suggestionLabel: _suggestionLabel(l10n, suggestion),
                      suggestionSubtitle: _suggestionSubtitle(l10n, suggestion),
                      familyLabel: _familyLabel(
                        l10n,
                        suggestion.voicing.family,
                      ),
                      topNoteLabel:
                          '${l10n.voicingTopNoteLabel} ${suggestion.voicing.topNoteName}',
                      sharedMinMidi: sharedKeyboardRange.minMidi,
                      sharedMaxMidi: sharedKeyboardRange.maxMidi,
                      noteSlotCount: sharedNoteSlotCount,
                      highlightsTopTarget:
                          widget.recommendations.effectiveTopNotePitchClass ==
                          suggestion.voicing.topNotePitchClass,
                      reasonLabels: [
                        for (final tag in suggestion.reasonTags)
                          _reasonLabel(l10n, suggestion, tag),
                      ],
                      onSelect: () {
                        widget.onSelectSuggestion(suggestion);
                        _toggleExpanded(expansionKey);
                      },
                      onPlay: widget.onPlaySuggestion == null
                          ? null
                          : () => widget.onPlaySuggestion!(suggestion),
                      onToggleLock: () => widget.onToggleLock(suggestion),
                    );
                  }(),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final preview = widget.recommendations.performancePreview!;
    final currentSuggestion = preview.representativeSuggestion;
    final nextSuggestion = preview.nextSuggestion;
    final keyboardRange = MiniKeyboard.resolveSharedDisplayRange([
      currentSuggestion.voicing.midiNotes,
      if (nextSuggestion != null) nextSuggestion.voicing.midiNotes,
    ]);
    final currentSlotCount = math
        .max(3, currentSuggestion.voicing.noteCount)
        .toInt();
    final nextSlotCount = nextSuggestion == null
        ? currentSlotCount
        : math.max(currentSlotCount, nextSuggestion.voicing.noteCount).toInt();
    final topLinePathLabel = nextSuggestion == null
        ? null
        : l10n.voicingPerformanceTopLinePath(
            currentSuggestion.voicing.topNoteName,
            nextSuggestion.voicing.topNoteName,
          );

    return Card(
      key: const ValueKey('voicing-suggestions-section'),
      color: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _PerformanceVoicingPanel(
          currentSuggestion: currentSuggestion,
          nextSuggestion: nextSuggestion,
          selected:
              widget.selectedSignature == currentSuggestion.voicing.signature,
          showReasons: widget.showReasons,
          sectionSubtitle: _performanceSectionSubtitle(l10n),
          currentTitle: l10n.voicingPerformanceCurrentTitle,
          nextTitle: l10n.voicingPerformanceNextTitle,
          currentFamilyLabel: _familyLabel(
            l10n,
            currentSuggestion.voicing.family,
          ),
          nextFamilyLabel: nextSuggestion == null
              ? null
              : _familyLabel(l10n, nextSuggestion.voicing.family),
          currentTopNoteLabel:
              '${l10n.voicingTopNoteLabel} ${currentSuggestion.voicing.topNoteName}',
          nextTopNoteLabel: nextSuggestion == null
              ? null
              : '${l10n.voicingTopNoteLabel} ${nextSuggestion.voicing.topNoteName}',
          topLinePathLabel: topLinePathLabel,
          currentSlotCount: currentSlotCount,
          nextSlotCount: nextSlotCount,
          sharedMinMidi: keyboardRange.minMidi,
          sharedMaxMidi: keyboardRange.maxMidi,
          currentOnlyNotes: preview.currentOnlyMidiNotes,
          sharedNotes: preview.sharedMidiNotes,
          nextOnlyNotes: preview.nextOnlyMidiNotes,
          reasonLabels: [
            for (final tag in currentSuggestion.reasonTags)
              _reasonLabel(l10n, currentSuggestion, tag),
          ],
          currentLegendLabel: l10n.voicingPerformanceCurrentOnly,
          sharedLegendLabel: l10n.voicingPerformanceShared,
          nextLegendLabel: l10n.voicingPerformanceNextOnly,
          onSelect: () => widget.onSelectSuggestion(currentSuggestion),
          onPlay: widget.onPlaySuggestion == null
              ? null
              : () => widget.onPlaySuggestion!(currentSuggestion),
          onToggleLock: () => widget.onToggleLock(currentSuggestion),
        ),
      ),
    );
  }

  String _suggestionLabel(AppLocalizations l10n, VoicingSuggestion suggestion) {
    String localizedLabel(VoicingSuggestionKind kind) {
      return switch (kind) {
        VoicingSuggestionKind.natural => l10n.voicingSuggestionNatural,
        VoicingSuggestionKind.colorful => l10n.voicingSuggestionColorful,
        VoicingSuggestionKind.easy => l10n.voicingSuggestionEasy,
      };
    }

    return suggestion.matchedKinds.map(localizedLabel).join(' & ');
  }

  String _sectionSubtitle(AppLocalizations l10n) {
    final topNotePitchClass = widget.recommendations.effectiveTopNotePitchClass;
    if (topNotePitchClass == null) {
      return l10n.voicingSuggestionsSubtitle;
    }
    final note =
        _pitchClassLabels[topNotePitchClass % _pitchClassLabels.length];
    final topNoteMatch = widget.recommendations.topNoteMatch;
    if (topNoteMatch == VoicingTopNoteMatch.unavailable) {
      return l10n.voicingTopNoteContextFallback(note);
    }
    if (topNoteMatch == VoicingTopNoteMatch.nearby) {
      return l10n.voicingTopNoteContextNearby(note);
    }
    return switch (widget.recommendations.topNoteSource) {
      VoicingTopNoteSource.explicitPreference =>
        l10n.voicingTopNoteContextExplicit(note),
      VoicingTopNoteSource.lockedContinuity => l10n.voicingTopNoteContextLocked(
        note,
      ),
      VoicingTopNoteSource.sameHarmonyCarry => l10n.voicingTopNoteContextCarry(
        note,
      ),
      null => l10n.voicingSuggestionsSubtitle,
    };
  }

  String _performanceSectionSubtitle(AppLocalizations l10n) {
    return l10n.voicingPerformanceSubtitle;
  }

  String _suggestionSubtitle(
    AppLocalizations l10n,
    VoicingSuggestion suggestion,
  ) {
    final reasonTags = suggestion.reasonTags.toSet();
    return switch (suggestion.kind) {
      VoicingSuggestionKind.natural =>
        reasonTags.contains(VoicingReasonTag.stableRepeat)
            ? l10n.voicingSuggestionNaturalStableSubtitle
            : reasonTags.contains(VoicingReasonTag.topLineTarget)
            ? l10n.voicingSuggestionTopLineSubtitle
            : reasonTags.contains(VoicingReasonTag.guideToneResolution) ||
                  reasonTags.contains(VoicingReasonTag.commonToneRetention)
            ? l10n.voicingSuggestionNaturalConnectedSubtitle
            : l10n.voicingSuggestionNaturalSubtitle,
      VoicingSuggestionKind.colorful =>
        reasonTags.contains(VoicingReasonTag.tritoneSubFlavor)
            ? l10n.voicingSuggestionColorfulTritoneSubtitle
            : suggestion.voicing.family == VoicingFamily.quartal
            ? l10n.voicingSuggestionColorfulQuartalSubtitle
            : suggestion.voicing.family == VoicingFamily.upperStructure
            ? l10n.voicingSuggestionColorfulUpperStructureSubtitle
            : reasonTags.contains(VoicingReasonTag.alteredColor)
            ? l10n.voicingSuggestionColorfulAlteredSubtitle
            : reasonTags.contains(VoicingReasonTag.topLineTarget)
            ? l10n.voicingSuggestionTopLineSubtitle
            : l10n.voicingSuggestionColorfulSubtitle,
      VoicingSuggestionKind.easy =>
        reasonTags.contains(VoicingReasonTag.stableRepeat)
            ? l10n.voicingSuggestionEasyStableSubtitle
            : reasonTags.contains(VoicingReasonTag.topLineTarget)
            ? l10n.voicingSuggestionTopLineSubtitle
            : reasonTags.contains(VoicingReasonTag.guideToneAnchor)
            ? l10n.voicingSuggestionEasyAnchoredSubtitle
            : l10n.voicingSuggestionEasySubtitle,
    };
  }

  String _familyLabel(AppLocalizations l10n, VoicingFamily family) {
    return switch (family) {
      VoicingFamily.shell => l10n.voicingFamilyShell,
      VoicingFamily.rootlessA => l10n.voicingFamilyRootlessA,
      VoicingFamily.rootlessB => l10n.voicingFamilyRootlessB,
      VoicingFamily.spread => l10n.voicingFamilySpread,
      VoicingFamily.sus => l10n.voicingFamilySus,
      VoicingFamily.quartal => l10n.voicingFamilyQuartal,
      VoicingFamily.altered => l10n.voicingFamilyAltered,
      VoicingFamily.upperStructure => l10n.voicingFamilyUpperStructure,
    };
  }

  String _reasonLabel(
    AppLocalizations l10n,
    VoicingSuggestion suggestion,
    VoicingReasonTag tag,
  ) {
    return switch (tag) {
      VoicingReasonTag.essentialCore => l10n.voicingReasonEssentialCore,
      VoicingReasonTag.guideToneAnchor => l10n.voicingReasonGuideToneAnchor,
      VoicingReasonTag.guideToneResolution => l10n.voicingReasonGuideResolution(
        suggestion.breakdown.guideResolutionCount,
      ),
      VoicingReasonTag.commonToneRetention =>
        l10n.voicingReasonCommonToneRetention(
          suggestion.breakdown.commonToneCount,
        ),
      VoicingReasonTag.stableRepeat => l10n.voicingReasonStableRepeat,
      VoicingReasonTag.topLineTarget => l10n.voicingReasonTopLineTarget,
      VoicingReasonTag.lowMudAvoided => l10n.voicingReasonLowMudAvoided,
      VoicingReasonTag.compactReach => l10n.voicingReasonCompactReach,
      VoicingReasonTag.bassAnchor => l10n.voicingReasonBassAnchor,
      VoicingReasonTag.nextChordReady => l10n.voicingReasonNextChordReady,
      VoicingReasonTag.alteredColor => l10n.voicingReasonAlteredColor,
      VoicingReasonTag.rootlessClarity => l10n.voicingReasonRootlessClarity,
      VoicingReasonTag.susRelease => l10n.voicingReasonSusRelease,
      VoicingReasonTag.quartalColor => l10n.voicingReasonQuartalColor,
      VoicingReasonTag.upperStructureColor =>
        l10n.voicingReasonUpperStructureColor,
      VoicingReasonTag.tritoneSubFlavor => l10n.voicingReasonTritoneSubFlavor,
      VoicingReasonTag.lockedContinuity => l10n.voicingReasonLockedContinuity,
      VoicingReasonTag.gentleMotion => l10n.voicingReasonGentleMotion,
    };
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.selected,
    required this.expanded,
    required this.showReasons,
    required this.suggestionLabel,
    required this.suggestionSubtitle,
    required this.familyLabel,
    required this.topNoteLabel,
    required this.sharedMinMidi,
    required this.sharedMaxMidi,
    required this.noteSlotCount,
    required this.highlightsTopTarget,
    required this.reasonLabels,
    required this.onSelect,
    required this.onPlay,
    required this.onToggleLock,
  });

  final VoicingSuggestion suggestion;
  final bool selected;
  final bool expanded;
  final bool showReasons;
  final String suggestionLabel;
  final String suggestionSubtitle;
  final String familyLabel;
  final String topNoteLabel;
  final int sharedMinMidi;
  final int sharedMaxMidi;
  final int noteSlotCount;
  final bool highlightsTopTarget;
  final List<String> reasonLabels;
  final VoidCallback onSelect;
  final VoidCallback? onPlay;
  final VoidCallback onToggleLock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final activeAccent = theme.colorScheme.primary;
    final activeFill = theme.colorScheme.primaryContainer;
    final cardBackground = selected || expanded
        ? Color.alphaBlend(
            activeAccent.withValues(alpha: 0.08),
            theme.colorScheme.surfaceContainerLow,
          )
        : theme.colorScheme.surfaceContainerLow;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('voicing-suggestion-card-${suggestion.cardKey}'),
        borderRadius: BorderRadius.circular(24),
        onTap: onSelect,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected || expanded
                  ? activeAccent
                  : theme.colorScheme.outlineVariant,
              width: selected || expanded ? 1.2 : 1,
            ),
            color: cardBackground,
            boxShadow: selected || expanded
                ? [
                    BoxShadow(
                      color: activeAccent.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stackHeader = constraints.maxWidth < 336;
                    final indicator = selected
                        ? Container(
                            key: ValueKey(
                              'voicing-selected-badge-${suggestion.cardKey}',
                            ),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: activeAccent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: activeFill,
                            ),
                          );
                    final titleRow = Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        indicator,
                        SizedBox(width: selected ? 8 : 10),
                        Expanded(
                          child: Text(
                            suggestionLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ],
                    );
                    final actionRow = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: ValueKey('voicing-play-${suggestion.cardKey}'),
                          visualDensity: VisualDensity.compact,
                          tooltip: l10n.audioPlayChord,
                          onPressed: onPlay,
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurfaceVariant,
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            side: BorderSide(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          icon: const Icon(Icons.volume_up_rounded, size: 18),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          key: ValueKey('voicing-lock-${suggestion.cardKey}'),
                          visualDensity: VisualDensity.compact,
                          tooltip: suggestion.locked
                              ? l10n.voicingUnlockSuggestion
                              : l10n.voicingLockSuggestion,
                          onPressed: onToggleLock,
                          style: IconButton.styleFrom(
                            backgroundColor: suggestion.locked
                                ? activeFill
                                : theme.colorScheme.surface,
                            foregroundColor: suggestion.locked
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            side: BorderSide(
                              color: suggestion.locked
                                  ? activeAccent
                                  : theme.colorScheme.outlineVariant,
                            ),
                          ),
                          icon: Icon(
                            suggestion.locked ? Icons.lock : Icons.lock_open,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    );

                    if (stackHeader) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleRow,
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: actionRow,
                          ),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: titleRow),
                        const SizedBox(width: 8),
                        actionRow,
                      ],
                    );
                  },
                ),
                if (suggestion.locked) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _StatePill(
                        key: ValueKey(
                          'voicing-locked-badge-${suggestion.cardKey}',
                        ),
                        icon: Icons.lock,
                        label: l10n.voicingLocked,
                        backgroundColor: activeFill,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                _NoteNameStrip(
                  key: ValueKey('voicing-notes-${suggestion.cardKey}'),
                  slotId: suggestion.cardKey,
                  noteNames: suggestion.voicing.noteNames,
                  slotCount: noteSlotCount,
                ),
                const SizedBox(height: 10),
                MiniKeyboard(
                  notes: suggestion.voicing.midiNotes,
                  minMidi: sharedMinMidi,
                  maxMidi: sharedMaxMidi,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestionSubtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: [
                                  _TopNotePill(
                                    key: ValueKey(
                                      'voicing-top-note-${suggestion.cardKey}',
                                    ),
                                    label: topNoteLabel,
                                    highlighted: highlightsTopTarget,
                                  ),
                                  Chip(
                                    label: Text(familyLabel),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _ToneLabelStrip(
                                key: ValueKey(
                                  'voicing-tones-${suggestion.cardKey}',
                                ),
                                slotId: suggestion.cardKey,
                                toneLabels: suggestion.voicing.toneLabels,
                                tensions: suggestion.voicing.tensions,
                                slotCount: noteSlotCount,
                              ),
                              if (showReasons && reasonLabels.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final reason in reasonLabels.take(4))
                                      FilterChip(
                                        label: Text(reason),
                                        selected: false,
                                        showCheckmark: false,
                                        visualDensity: VisualDensity.compact,
                                        onSelected: null,
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PerformanceVoicingPanel extends StatelessWidget {
  const _PerformanceVoicingPanel({
    required this.currentSuggestion,
    required this.nextSuggestion,
    required this.selected,
    required this.showReasons,
    required this.sectionSubtitle,
    required this.currentTitle,
    required this.nextTitle,
    required this.currentFamilyLabel,
    required this.nextFamilyLabel,
    required this.currentTopNoteLabel,
    required this.nextTopNoteLabel,
    required this.topLinePathLabel,
    required this.currentSlotCount,
    required this.nextSlotCount,
    required this.sharedMinMidi,
    required this.sharedMaxMidi,
    required this.currentOnlyNotes,
    required this.sharedNotes,
    required this.nextOnlyNotes,
    required this.reasonLabels,
    required this.currentLegendLabel,
    required this.sharedLegendLabel,
    required this.nextLegendLabel,
    required this.onSelect,
    required this.onPlay,
    required this.onToggleLock,
  });

  final VoicingSuggestion currentSuggestion;
  final VoicingSuggestion? nextSuggestion;
  final bool selected;
  final bool showReasons;
  final String sectionSubtitle;
  final String currentTitle;
  final String nextTitle;
  final String currentFamilyLabel;
  final String? nextFamilyLabel;
  final String currentTopNoteLabel;
  final String? nextTopNoteLabel;
  final String? topLinePathLabel;
  final int currentSlotCount;
  final int nextSlotCount;
  final int sharedMinMidi;
  final int sharedMaxMidi;
  final Set<int> currentOnlyNotes;
  final Set<int> sharedNotes;
  final Set<int> nextOnlyNotes;
  final List<String> reasonLabels;
  final String currentLegendLabel;
  final String sharedLegendLabel;
  final String nextLegendLabel;
  final VoidCallback onSelect;
  final VoidCallback? onPlay;
  final VoidCallback onToggleLock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentVoicing = currentSuggestion.voicing;
    final nextVoicing = nextSuggestion?.voicing;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('voicing-performance-panel'),
        borderRadius: BorderRadius.circular(26),
        onTap: onSelect,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: selected || currentSuggestion.locked
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected || currentSuggestion.locked ? 1.2 : 1,
            ),
            color: Color.alphaBlend(
              colorScheme.primary.withValues(
                alpha: selected || currentSuggestion.locked ? 0.08 : 0.04,
              ),
              colorScheme.surfaceContainerLow,
            ),
            boxShadow: selected || currentSuggestion.locked
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sectionSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('voicing-performance-play'),
                      visualDensity: VisualDensity.compact,
                      onPressed: onPlay,
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                        foregroundColor: colorScheme.onSurfaceVariant,
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      icon: const Icon(Icons.volume_up_rounded, size: 18),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      key: const ValueKey('voicing-performance-lock'),
                      visualDensity: VisualDensity.compact,
                      onPressed: onToggleLock,
                      style: IconButton.styleFrom(
                        backgroundColor: currentSuggestion.locked
                            ? colorScheme.primaryContainer
                            : colorScheme.surface,
                        foregroundColor: currentSuggestion.locked
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                          color: currentSuggestion.locked
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                      icon: Icon(
                        currentSuggestion.locked ? Icons.lock : Icons.lock_open,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                if (selected || currentSuggestion.locked) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (selected)
                        _StatePill(
                          key: const ValueKey(
                            'voicing-performance-selected-badge',
                          ),
                          icon: Icons.check_circle,
                          label: AppLocalizations.of(context)!.voicingSelected,
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      if (currentSuggestion.locked)
                        _StatePill(
                          key: const ValueKey(
                            'voicing-performance-locked-badge',
                          ),
                          icon: Icons.lock,
                          label: AppLocalizations.of(context)!.voicingLocked,
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  currentTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _NoteNameStrip(
                  key: const ValueKey('voicing-performance-current-notes'),
                  slotId: 'performance-current',
                  noteNames: currentVoicing.noteNames,
                  slotCount: currentSlotCount,
                ),
                const SizedBox(height: 10),
                MiniKeyboard(
                  key: const ValueKey('voicing-performance-keyboard'),
                  notes: currentVoicing.midiNotes,
                  minMidi: sharedMinMidi,
                  maxMidi: sharedMaxMidi,
                  currentNotes: {...currentOnlyNotes, ...sharedNotes},
                  nextNotes: {...nextOnlyNotes, ...sharedNotes},
                  sharedNotes: sharedNotes,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _KeyboardLegendPill(
                      key: const ValueKey('voicing-performance-legend-current'),
                      label: currentLegendLabel,
                      color: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    _KeyboardLegendPill(
                      key: const ValueKey('voicing-performance-legend-shared'),
                      label: sharedLegendLabel,
                      color: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                    ),
                    _KeyboardLegendPill(
                      key: const ValueKey('voicing-performance-legend-next'),
                      label: nextLegendLabel,
                      color: colorScheme.tertiary,
                      foregroundColor: colorScheme.onTertiary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _TopNotePill(
                      key: const ValueKey('voicing-performance-current-top'),
                      label: currentTopNoteLabel,
                      highlighted: true,
                    ),
                    Chip(
                      label: Text(currentFamilyLabel),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _ToneLabelStrip(
                  key: const ValueKey('voicing-performance-current-tones'),
                  slotId: 'performance-current',
                  toneLabels: currentVoicing.toneLabels,
                  tensions: currentVoicing.tensions,
                  slotCount: currentSlotCount,
                ),
                if (nextSuggestion != null) ...[
                  const SizedBox(height: 16),
                  Divider(color: colorScheme.outlineVariant, height: 1),
                  const SizedBox(height: 16),
                  Text(
                    nextTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _NoteNameStrip(
                    key: const ValueKey('voicing-performance-next-notes'),
                    slotId: 'performance-next',
                    noteNames: nextVoicing!.noteNames,
                    slotCount: nextSlotCount,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (nextTopNoteLabel != null)
                        _TopNotePill(
                          key: const ValueKey('voicing-performance-next-top'),
                          label: nextTopNoteLabel!,
                          highlighted: false,
                        ),
                      if (nextFamilyLabel != null)
                        Chip(
                          label: Text(nextFamilyLabel!),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ToneLabelStrip(
                    key: const ValueKey('voicing-performance-next-tones'),
                    slotId: 'performance-next',
                    toneLabels: nextVoicing.toneLabels,
                    tensions: nextVoicing.tensions,
                    slotCount: nextSlotCount,
                  ),
                ],
                if (topLinePathLabel != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    topLinePathLabel!,
                    key: const ValueKey('voicing-performance-topline-path'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (showReasons && reasonLabels.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final reason in reasonLabels.take(4))
                        FilterChip(
                          label: Text(reason),
                          selected: false,
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                          onSelected: null,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyboardLegendPill extends StatelessWidget {
  const _KeyboardLegendPill({
    super.key,
    required this.label,
    required this.color,
    required this.foregroundColor,
  });

  final String label;
  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.24),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const SizedBox(width: 8, height: 8),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: foregroundColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteNameStrip extends StatelessWidget {
  const _NoteNameStrip({
    super.key,
    required this.slotId,
    required this.noteNames,
    required this.slotCount,
  });

  final String slotId;
  final List<String> noteNames;
  final int slotCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          for (var index = 0; index < slotCount; index += 1) ...[
            Expanded(
              child: _NoteNameSlot(
                key: ValueKey('voicing-note-slot-$slotId-$index'),
                label: index < noteNames.length ? noteNames[index] : null,
              ),
            ),
            if (index < slotCount - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _NoteNameSlot extends StatelessWidget {
  const _NoteNameSlot({super.key, required this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFilled = label != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isFilled
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFilled
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            label ?? '',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: isFilled
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToneLabelStrip extends StatelessWidget {
  const _ToneLabelStrip({
    super.key,
    required this.slotId,
    required this.toneLabels,
    required this.tensions,
    required this.slotCount,
  });

  final String slotId;
  final List<String> toneLabels;
  final Set<String> tensions;
  final int slotCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          for (var index = 0; index < slotCount; index += 1) ...[
            Expanded(
              child: _ToneLabelSlot(
                key: ValueKey('voicing-tone-slot-$slotId-$index'),
                label: index < toneLabels.length ? toneLabels[index] : null,
                highlighted:
                    index < toneLabels.length &&
                    tensions.contains(toneLabels[index]),
              ),
            ),
            if (index < slotCount - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _ToneLabelSlot extends StatelessWidget {
  const _ToneLabelSlot({
    super.key,
    required this.label,
    required this.highlighted,
  });

  final String? label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFilled = label != null;
    final backgroundColor = highlighted
        ? theme.colorScheme.primaryContainer
        : isFilled
        ? theme.colorScheme.surfaceContainerHigh
        : theme.colorScheme.surface;
    final foregroundColor = highlighted
        ? theme.colorScheme.onPrimaryContainer
        : isFilled
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55);
    final borderColor = highlighted
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            label ?? '',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _TopNotePill extends StatelessWidget {
  const _TopNotePill({
    super.key,
    required this.label,
    required this.highlighted,
  });

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_note_rounded,
              size: 14,
              color: highlighted
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: highlighted
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: foregroundColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
