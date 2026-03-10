import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../music/voicing_models.dart';
import 'mini_keyboard.dart';

typedef VoicingSuggestionCallback = void Function(VoicingSuggestion suggestion);

class VoicingSuggestionsSection extends StatelessWidget {
  const VoicingSuggestionsSection({
    super.key,
    required this.recommendations,
    required this.selectedSignature,
    required this.showReasons,
    required this.onSelectSuggestion,
    required this.onToggleLock,
  });

  final VoicingRecommendationSet recommendations;
  final String? selectedSignature;
  final bool showReasons;
  final VoicingSuggestionCallback onSelectSuggestion;
  final VoicingSuggestionCallback onToggleLock;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (recommendations.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    final sharedKeyboardRange = MiniKeyboard.resolveSharedDisplayRange(
      recommendations.suggestions.map((item) => item.voicing.midiNotes),
    );
    final sharedNoteSlotCount = recommendations.suggestions
        .fold<int>(
          3,
          (currentMax, item) => math.max(currentMax, item.voicing.noteCount),
        )
        .clamp(3, 5)
        .toInt();

    return Card(
      key: const ValueKey('voicing-suggestions-section'),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.voicingSuggestionsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _sectionSubtitle(l10n),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                for (final suggestion in recommendations.suggestions) ...[
                  _SuggestionCard(
                    suggestion: suggestion,
                    selected: selectedSignature == suggestion.voicing.signature,
                    showReasons: showReasons,
                    suggestionLabel: _suggestionLabel(l10n, suggestion.kind),
                    suggestionSubtitle: _suggestionSubtitle(l10n, suggestion),
                    familyLabel: _familyLabel(l10n, suggestion.voicing.family),
                    topNoteLabel:
                        '${l10n.voicingTopNoteLabel} ${suggestion.voicing.topNoteName}',
                    sharedMinMidi: sharedKeyboardRange.minMidi,
                    sharedMaxMidi: sharedKeyboardRange.maxMidi,
                    noteSlotCount: sharedNoteSlotCount,
                    highlightsTopTarget:
                        recommendations.effectiveTopNotePitchClass ==
                        suggestion.voicing.topNotePitchClass,
                    reasonLabels: [
                      for (final tag in suggestion.reasonTags)
                        _reasonLabel(l10n, suggestion, tag),
                    ],
                    onSelect: () => onSelectSuggestion(suggestion),
                    onToggleLock: () => onToggleLock(suggestion),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _suggestionLabel(AppLocalizations l10n, VoicingSuggestionKind kind) {
    return switch (kind) {
      VoicingSuggestionKind.natural => l10n.voicingSuggestionNatural,
      VoicingSuggestionKind.colorful => l10n.voicingSuggestionColorful,
      VoicingSuggestionKind.easy => l10n.voicingSuggestionEasy,
    };
  }

  String _sectionSubtitle(AppLocalizations l10n) {
    final topNotePitchClass = recommendations.effectiveTopNotePitchClass;
    if (topNotePitchClass == null) {
      return l10n.voicingSuggestionsSubtitle;
    }
    final note =
        _pitchClassLabels[topNotePitchClass % _pitchClassLabels.length];
    final topNoteMatch = recommendations.topNoteMatch;
    if (topNoteMatch == VoicingTopNoteMatch.unavailable) {
      return l10n.voicingTopNoteContextFallback(note);
    }
    if (topNoteMatch == VoicingTopNoteMatch.nearby) {
      return l10n.voicingTopNoteContextNearby(note);
    }
    return switch (recommendations.topNoteSource) {
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
    required this.onToggleLock,
  });

  final VoicingSuggestion suggestion;
  final bool selected;
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
  final VoidCallback onToggleLock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final compactChipWidth = MediaQuery.sizeOf(context).width < 360
        ? 126.0
        : 164.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('voicing-suggestion-card-${suggestion.kind.name}'),
        borderRadius: BorderRadius.circular(14),
        onTap: onSelect,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surfaceContainerLowest,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestionLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            suggestionSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      key: ValueKey('voicing-lock-${suggestion.kind.name}'),
                      visualDensity: VisualDensity.compact,
                      tooltip: suggestion.locked
                          ? l10n.voicingUnlockSuggestion
                          : l10n.voicingLockSuggestion,
                      onPressed: onToggleLock,
                      style: IconButton.styleFrom(
                        backgroundColor: suggestion.locked
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHigh,
                        foregroundColor: suggestion.locked
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                        minimumSize: const Size(34, 34),
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(
                        suggestion.locked ? Icons.lock : Icons.lock_open,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _TopNotePill(
                      key: ValueKey('voicing-top-note-${suggestion.kind.name}'),
                      label: topNoteLabel,
                      highlighted: highlightsTopTarget,
                    ),
                    if (selected)
                      _StatePill(
                        key: ValueKey(
                          'voicing-selected-badge-${suggestion.kind.name}',
                        ),
                        icon: Icons.check_circle,
                        label: l10n.voicingSelected,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                    if (suggestion.locked)
                      _StatePill(
                        key: ValueKey(
                          'voicing-locked-badge-${suggestion.kind.name}',
                        ),
                        icon: Icons.lock,
                        label: l10n.voicingLocked,
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        foregroundColor: theme.colorScheme.onSecondaryContainer,
                      ),
                    Chip(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: compactChipWidth),
                        child: Text(
                          familyLabel,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _NoteNameStrip(
                  key: ValueKey('voicing-notes-${suggestion.kind.name}'),
                  kind: suggestion.kind,
                  noteNames: suggestion.voicing.noteNames,
                  slotCount: noteSlotCount,
                ),
                const SizedBox(height: 8),
                MiniKeyboard(
                  notes: suggestion.voicing.midiNotes,
                  minMidi: sharedMinMidi,
                  maxMidi: sharedMaxMidi,
                ),
                if (showReasons && reasonLabels.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final reason in reasonLabels.take(3))
                        FilterChip(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: compactChipWidth + 40,
                            ),
                            child: Text(
                              reason,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
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

class _NoteNameStrip extends StatelessWidget {
  const _NoteNameStrip({
    super.key,
    required this.kind,
    required this.noteNames,
    required this.slotCount,
  });

  final VoicingSuggestionKind kind;
  final List<String> noteNames;
  final int slotCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          for (var index = 0; index < slotCount; index += 1) ...[
            Expanded(
              child: _NoteNameSlot(
                key: ValueKey('voicing-note-slot-${kind.name}-$index'),
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
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFilled
              ? theme.colorScheme.outlineVariant
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Text(
            label ?? '',
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isFilled
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
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
    final maxLabelWidth = MediaQuery.sizeOf(context).width < 360
        ? 108.0
        : 138.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted
            ? theme.colorScheme.tertiaryContainer
            : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted
              ? theme.colorScheme.tertiary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_note,
              size: 14,
              color: highlighted
                  ? theme.colorScheme.onTertiaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxLabelWidth),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: highlighted
                      ? theme.colorScheme.onTertiaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
