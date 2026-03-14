import 'package:flutter/material.dart';

import 'study_harmony_models.dart';

class StudyHarmonyPianoKeyboard extends StatelessWidget {
  const StudyHarmonyPianoKeyboard({
    super.key,
    required this.keys,
    required this.selectedAnswerIds,
    this.onToggleKey,
    this.onPreviewKeyDown,
    this.onPreviewKeyUp,
    this.readOnly = false,
  });

  final List<StudyHarmonyPianoKeyDefinition> keys;
  final Set<String> selectedAnswerIds;
  final ValueChanged<String>? onToggleKey;
  final ValueChanged<String>? onPreviewKeyDown;
  final ValueChanged<String>? onPreviewKeyUp;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final whiteKeys = keys.where((key) => !key.isBlack).toList(growable: false);
    final blackKeys = keys.where((key) => key.isBlack).toList(growable: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 720.0;
        final whiteKeyWidth = width / whiteKeys.length;
        final keyboardHeight = (whiteKeyWidth * 3.2)
            .clamp(180.0, 300.0)
            .toDouble();
        final blackKeyWidth = whiteKeyWidth * 0.62;
        final blackKeyHeight = keyboardHeight * 0.62;

        return SizedBox(
          key: const ValueKey('study-harmony-piano-keyboard'),
          height: keyboardHeight,
          child: Stack(
            children: [
              Row(
                children: [
                  for (final key in whiteKeys)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: _PianoKeyTile(
                          key: ValueKey('study-harmony-key-${key.id}'),
                          definition: key,
                          selected: selectedAnswerIds.contains(key.id),
                          readOnly: readOnly,
                          onTap: onToggleKey == null
                              ? null
                              : () => onToggleKey!(key.id),
                          onPreviewStart: onPreviewKeyDown == null
                              ? null
                              : () => onPreviewKeyDown!(key.id),
                          onPreviewEnd: onPreviewKeyUp == null
                              ? null
                              : () => onPreviewKeyUp!(key.id),
                        ),
                      ),
                    ),
                ],
              ),
              for (final key in blackKeys)
                Positioned(
                  left:
                      whiteKeyWidth * (key.blackGapAfterWhiteIndex! + 1) -
                      (blackKeyWidth / 2),
                  width: blackKeyWidth,
                  height: blackKeyHeight,
                  child: _PianoKeyTile(
                    key: ValueKey('study-harmony-key-${key.id}'),
                    definition: key,
                    selected: selectedAnswerIds.contains(key.id),
                    readOnly: readOnly,
                    onTap: onToggleKey == null
                        ? null
                        : () => onToggleKey!(key.id),
                    onPreviewStart: onPreviewKeyDown == null
                        ? null
                        : () => onPreviewKeyDown!(key.id),
                    onPreviewEnd: onPreviewKeyUp == null
                        ? null
                        : () => onPreviewKeyUp!(key.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PianoKeyTile extends StatelessWidget {
  const _PianoKeyTile({
    super.key,
    required this.definition,
    required this.selected,
    required this.readOnly,
    this.onTap,
    this.onPreviewStart,
    this.onPreviewEnd,
  });

  final StudyHarmonyPianoKeyDefinition definition;
  final bool selected;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onPreviewStart;
  final VoidCallback? onPreviewEnd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBlack = definition.isBlack;
    final backgroundColor = isBlack
        ? selected
              ? colorScheme.tertiary
              : colorScheme.onSurface.withValues(alpha: 0.88)
        : selected
        ? colorScheme.primaryContainer
        : colorScheme.surface;
    final foregroundColor = isBlack
        ? colorScheme.onTertiary
        : selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Semantics(
      button: !readOnly,
      enabled: !readOnly,
      selected: selected,
      label: definition.combinedLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: readOnly ? null : onTap,
          onTapDown: readOnly
              ? null
              : (_) {
                  onPreviewStart?.call();
                },
          onTapUp: readOnly
              ? null
              : (_) {
                  onPreviewEnd?.call();
                },
          onTapCancel: readOnly
              ? null
              : () {
                  onPreviewEnd?.call();
                },
          canRequestFocus: !readOnly,
          borderRadius: BorderRadius.circular(isBlack ? 12 : 16),
          child: ExcludeSemantics(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(isBlack ? 12 : 16),
                border: Border.all(
                  color: isBlack
                      ? colorScheme.outline.withValues(alpha: 0.2)
                      : colorScheme.outlineVariant,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isBlack ? 0.22 : 0.08,
                    ),
                    blurRadius: isBlack ? 14 : 10,
                    offset: Offset(0, isBlack ? 6 : 4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(6, isBlack ? 10 : 12, 6, 12),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isBlack)
                      Text(
                        definition.solfegeLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: foregroundColor,
                        ),
                      ),
                    Text(
                      definition.westernLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: foregroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
