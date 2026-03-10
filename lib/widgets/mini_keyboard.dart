import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniKeyboard extends StatelessWidget {
  const MiniKeyboard({
    super.key,
    required this.notes,
    this.minMidi,
    this.maxMidi,
  });

  static const int _displayMinMidi = 36;
  static const int _displayMaxMidi = 84;
  static const int _fallbackMinMidi = 48;
  static const int _fallbackMaxMidi = 64;
  static const int _defaultPadding = 3;
  static const int _minimumSpan = 18;

  final List<int> notes;
  final int? minMidi;
  final int? maxMidi;

  static ({int minMidi, int maxMidi}) resolveDisplayRange(
    Iterable<int> midiNotes, {
    int padding = _defaultPadding,
    int minimumSpan = _minimumSpan,
  }) {
    final sortedNotes = midiNotes.toList()..sort();
    if (sortedNotes.isEmpty) {
      return (minMidi: _fallbackMinMidi, maxMidi: _fallbackMaxMidi);
    }

    final clampedMinimumSpan = minimumSpan
        .clamp(0, _displayMaxMidi - _displayMinMidi)
        .toInt();
    var lower = _clampMidi(sortedNotes.first - padding);
    var upper = _clampMidi(sortedNotes.last + padding);

    if ((upper - lower) < clampedMinimumSpan) {
      final shortfall = clampedMinimumSpan - (upper - lower);
      lower = math.max(_displayMinMidi, lower - (shortfall ~/ 2));
      upper = math.min(_displayMaxMidi, upper + (shortfall - (shortfall ~/ 2)));
    }

    if ((upper - lower) < clampedMinimumSpan) {
      if (lower == _displayMinMidi) {
        upper = math.min(_displayMaxMidi, lower + clampedMinimumSpan);
      } else {
        lower = math.max(_displayMinMidi, upper - clampedMinimumSpan);
      }
    }

    return (minMidi: lower, maxMidi: upper);
  }

  static ({int minMidi, int maxMidi}) resolveSharedDisplayRange(
    Iterable<Iterable<int>> noteGroups, {
    int padding = _defaultPadding,
    int minimumSpan = _minimumSpan,
  }) {
    return resolveDisplayRange(
      noteGroups.expand((group) => group),
      padding: padding,
      minimumSpan: minimumSpan,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteSet = {for (final note in notes) note};
    final resolvedRange = _resolvedRange();
    final totalKeys = resolvedRange.maxMidi - resolvedRange.minMidi + 1;

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
                      var midi = resolvedRange.minMidi;
                      midi <= resolvedRange.maxMidi;
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
                  if (midi >= resolvedRange.minMidi &&
                      midi <= resolvedRange.maxMidi)
                    Positioned(
                      left: (midi - resolvedRange.minMidi) * cellWidth,
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

  ({int minMidi, int maxMidi}) _resolvedRange() {
    if (minMidi != null && maxMidi != null) {
      final lower = _clampMidi(math.min(minMidi!, maxMidi!));
      final upper = _clampMidi(math.max(minMidi!, maxMidi!));
      return (minMidi: lower, maxMidi: upper);
    }
    return resolveDisplayRange(notes);
  }

  static int _clampMidi(int midi) {
    return midi.clamp(_displayMinMidi, _displayMaxMidi).toInt();
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
