import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniKeyboard extends StatelessWidget {
  const MiniKeyboard({
    super.key,
    required this.notes,
    this.minMidi,
    this.maxMidi,
  });

  final List<int> notes;
  final int? minMidi;
  final int? maxMidi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteSet = {for (final note in notes) note};
    final resolvedRange = _resolvedRange();
    final totalKeys = resolvedRange.$2 - resolvedRange.$1 + 1;

    return SizedBox(
      height: 24,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / totalKeys;
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  children: [
                    for (
                      var midi = resolvedRange.$1;
                      midi <= resolvedRange.$2;
                      midi += 1
                    )
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isBlackKey(midi)
                                ? theme.colorScheme.surfaceContainerHighest
                                : theme.colorScheme.surface,
                            border: Border(
                              right: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                for (final midi in noteSet)
                  if (midi >= resolvedRange.$1 && midi <= resolvedRange.$2)
                    Positioned(
                      left: (midi - resolvedRange.$1) * cellWidth,
                      width: cellWidth,
                      top: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                          vertical: 3,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: _isBlackKey(midi) ? 0.8 : 0.28,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  (int, int) _resolvedRange() {
    if (minMidi != null && maxMidi != null) {
      return (minMidi!, maxMidi!);
    }
    if (notes.isEmpty) {
      return (48, 64);
    }

    var lower = math.max(36, notes.first - 4);
    var upper = math.min(84, notes.last + 4);
    const minimumSpan = 16;
    if ((upper - lower) < minimumSpan) {
      final extra = minimumSpan - (upper - lower);
      lower = math.max(36, lower - (extra ~/ 2));
      upper = math.min(84, upper + (extra - (extra ~/ 2)));
    }
    if ((upper - lower) < minimumSpan) {
      if (lower == 36) {
        upper = math.min(84, lower + minimumSpan);
      } else {
        lower = math.max(36, upper - minimumSpan);
      }
    }
    return (lower, upper);
  }

  bool _isBlackKey(int midi) {
    final pitchClass = midi % 12;
    return pitchClass == 1 ||
        pitchClass == 3 ||
        pitchClass == 6 ||
        pitchClass == 8 ||
        pitchClass == 10;
  }
}
