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
  static const double _keyboardHeight = 42;
  static const double _blackKeyHeightFactor = 0.62;
  static const double _blackKeyWidthFactor = 0.64;

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
    final displayKeys = [
      for (
        var midi = resolvedRange.minMidi;
        midi <= resolvedRange.maxMidi;
        midi += 1
      )
        midi,
    ];
    final whiteKeys = displayKeys
        .where((midi) => !_isBlackKey(midi))
        .toList(growable: false);

    return SizedBox(
      height: _keyboardHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final whiteKeyWidth = whiteKeys.isEmpty
              ? constraints.maxWidth
              : constraints.maxWidth / whiteKeys.length;
          final blackKeyWidth = whiteKeyWidth * _blackKeyWidthFactor;
          final renderedKeys = _resolveRenderedKeys(
            displayKeys,
            whiteKeyWidth: whiteKeyWidth,
            blackKeyWidth: blackKeyWidth,
            maxWidth: constraints.maxWidth,
          );

          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surfaceContainerLowest,
                  ),
                ),
                for (final key in renderedKeys.where((key) => !key.isBlack))
                  Positioned(
                    left: key.left,
                    top: 0,
                    bottom: 0,
                    width: key.width,
                    child: _WhiteKey(
                      active: noteSet.contains(key.midi),
                      label: _octaveMarker(key.midi),
                    ),
                  ),
                for (final key in renderedKeys.where((key) => key.isBlack))
                  Positioned(
                    left: key.left,
                    top: 0,
                    width: key.width,
                    height: constraints.maxHeight * _blackKeyHeightFactor,
                    child: _BlackKey(active: noteSet.contains(key.midi)),
                  ),
                for (final midi in noteSet)
                  if (midi >= resolvedRange.minMidi &&
                      midi <= resolvedRange.maxMidi &&
                      !_isBlackKey(midi))
                    Positioned(
                      left: renderedKeys
                          .firstWhere((key) => key.midi == midi)
                          .left,
                      right: null,
                      bottom: 5,
                      width: renderedKeys
                          .firstWhere((key) => key.midi == midi)
                          .width,
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                for (final midi in noteSet)
                  if (midi >= resolvedRange.minMidi &&
                      midi <= resolvedRange.maxMidi &&
                      _isBlackKey(midi))
                    Positioned(
                      left: renderedKeys
                          .firstWhere((key) => key.midi == midi)
                          .left,
                      top: 4,
                      width: renderedKeys
                          .firstWhere((key) => key.midi == midi)
                          .width,
                      child: Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary,
                            shape: BoxShape.circle,
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

  List<_RenderedKey> _resolveRenderedKeys(
    List<int> displayKeys, {
    required double whiteKeyWidth,
    required double blackKeyWidth,
    required double maxWidth,
  }) {
    final renderedKeys = <_RenderedKey>[];
    var whiteIndex = 0;
    for (final midi in displayKeys) {
      if (_isBlackKey(midi)) {
        final unclampedLeft =
            (whiteIndex * whiteKeyWidth) - (blackKeyWidth / 2);
        renderedKeys.add(
          _RenderedKey(
            midi: midi,
            left: unclampedLeft.clamp(0, math.max(0, maxWidth - blackKeyWidth)),
            width: blackKeyWidth,
            isBlack: true,
          ),
        );
        continue;
      }

      renderedKeys.add(
        _RenderedKey(
          midi: midi,
          left: whiteIndex * whiteKeyWidth,
          width: whiteKeyWidth,
          isBlack: false,
        ),
      );
      whiteIndex += 1;
    }
    return renderedKeys;
  }

  String? _octaveMarker(int midi) {
    if (midi % 12 != 0) {
      return null;
    }
    final octave = (midi ~/ 12) - 1;
    return 'C$octave';
  }
}

class _WhiteKey extends StatelessWidget {
  const _WhiteKey({required this.active, required this.label});

  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: active
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.2),
                  theme.colorScheme.primary.withValues(alpha: 0.06),
                ]
              : [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerLowest,
                ],
        ),
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 0.7,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label ?? '',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
          ),
        ),
      ),
    );
  }
}

class _BlackKey extends StatelessWidget {
  const _BlackKey({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: active
                ? [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.82),
                  ]
                : [
                    theme.colorScheme.inverseSurface,
                    theme.colorScheme.surfaceTint.withValues(alpha: 0.45),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.16),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _RenderedKey {
  const _RenderedKey({
    required this.midi,
    required this.left,
    required this.width,
    required this.isBlack,
  });

  final int midi;
  final double left;
  final double width;
  final bool isBlack;
}
