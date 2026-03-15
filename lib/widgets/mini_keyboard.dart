import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniKeyboard extends StatelessWidget {
  const MiniKeyboard({
    super.key,
    required this.notes,
    this.minMidi,
    this.maxMidi,
    this.currentNotes,
    this.nextNotes,
    this.sharedNotes,
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
  final Iterable<int>? currentNotes;
  final Iterable<int>? nextNotes;
  final Iterable<int>? sharedNotes;

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
    final hasComparisonData =
        currentNotes != null || nextNotes != null || sharedNotes != null;
    final resolvedCurrentNotes = hasComparisonData
        ? {for (final note in currentNotes ?? notes) note}
        : noteSet;
    final resolvedNextNotes = hasComparisonData
        ? {for (final note in nextNotes ?? const <int>[]) note}
        : const <int>{};
    final resolvedSharedNotes = hasComparisonData
        ? {
            for (final note
                in sharedNotes ??
                    resolvedCurrentNotes.intersection(resolvedNextNotes))
              note,
          }
        : const <int>{};
    final currentOnlyNotes = hasComparisonData
        ? resolvedCurrentNotes.difference(resolvedSharedNotes)
        : const <int>{};
    final nextOnlyNotes = hasComparisonData
        ? resolvedNextNotes.difference(resolvedSharedNotes)
        : const <int>{};
    final activeNoteSet = hasComparisonData
        ? {...currentOnlyNotes, ...resolvedSharedNotes, ...nextOnlyNotes}
        : noteSet;
    final resolvedRange = _resolvedRange(activeNoteSet);
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
                      color: theme.colorScheme.outline,
                      width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF111318)
                        : const Color(0xFFFFFFFF),
                  ),
                ),
                for (final key in renderedKeys.where((key) => !key.isBlack))
                  Positioned(
                    left: key.left,
                    top: 0,
                    bottom: 0,
                    width: key.width,
                    child: _WhiteKey(
                      key: ValueKey('mini-key-white-${key.midi}'),
                      active: activeNoteSet.contains(key.midi),
                      label: _octaveMarker(key.midi),
                    ),
                  ),
                for (final key in renderedKeys.where((key) => key.isBlack))
                  Positioned(
                    left: key.left,
                    top: 0,
                    width: key.width,
                    height: constraints.maxHeight * _blackKeyHeightFactor,
                    child: _BlackKey(
                      key: ValueKey('mini-key-black-${key.midi}'),
                      active: activeNoteSet.contains(key.midi),
                    ),
                  ),
                if (!hasComparisonData)
                  ..._buildStandardMarkers(
                    renderedKeys: renderedKeys,
                    noteSet: noteSet,
                    minMidi: resolvedRange.minMidi,
                    maxMidi: resolvedRange.maxMidi,
                    theme: theme,
                  ),
                if (hasComparisonData)
                  ..._buildComparisonMarkers(
                    renderedKeys: renderedKeys,
                    currentOnlyNotes: currentOnlyNotes,
                    sharedNotes: resolvedSharedNotes,
                    nextOnlyNotes: nextOnlyNotes,
                    minMidi: resolvedRange.minMidi,
                    maxMidi: resolvedRange.maxMidi,
                    theme: theme,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  ({int minMidi, int maxMidi}) _resolvedRange(Iterable<int> displayNotes) {
    if (minMidi != null && maxMidi != null) {
      final lower = _clampMidi(math.min(minMidi!, maxMidi!));
      final upper = _clampMidi(math.max(minMidi!, maxMidi!));
      return (minMidi: lower, maxMidi: upper);
    }
    return resolveDisplayRange(displayNotes);
  }

  List<Widget> _buildStandardMarkers({
    required List<_RenderedKey> renderedKeys,
    required Set<int> noteSet,
    required int minMidi,
    required int maxMidi,
    required ThemeData theme,
  }) {
    return [
      for (final midi in noteSet)
        if (midi >= minMidi && midi <= maxMidi)
          _buildSingleMarker(
            keySpec: _keyForMidi(renderedKeys, midi),
            markerColor: _isBlackKey(midi)
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
            borderColor: _isBlackKey(midi)
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.onPrimary,
            shadowColor: theme.colorScheme.primary,
            markerKey: ValueKey('mini-key-active-$midi'),
            role: _KeyboardMarkerRole.standard,
          ),
    ];
  }

  List<Widget> _buildComparisonMarkers({
    required List<_RenderedKey> renderedKeys,
    required Set<int> currentOnlyNotes,
    required Set<int> sharedNotes,
    required Set<int> nextOnlyNotes,
    required int minMidi,
    required int maxMidi,
    required ThemeData theme,
  }) {
    final widgets = <Widget>[];
    for (final midi in currentOnlyNotes) {
      if (midi < minMidi || midi > maxMidi) {
        continue;
      }
      widgets.add(
        _buildSingleMarker(
          keySpec: _keyForMidi(renderedKeys, midi),
          markerColor: theme.colorScheme.primary,
          borderColor: theme.colorScheme.onPrimary,
          shadowColor: theme.colorScheme.primary,
          markerKey: ValueKey('mini-key-current-$midi'),
          role: _KeyboardMarkerRole.current,
        ),
      );
    }
    for (final midi in sharedNotes) {
      if (midi < minMidi || midi > maxMidi) {
        continue;
      }
      widgets.add(
        _buildSingleMarker(
          keySpec: _keyForMidi(renderedKeys, midi),
          markerColor: theme.colorScheme.secondary,
          borderColor: theme.colorScheme.onSecondary,
          shadowColor: theme.colorScheme.secondary,
          markerKey: ValueKey('mini-key-shared-$midi'),
          role: _KeyboardMarkerRole.shared,
        ),
      );
    }
    for (final midi in nextOnlyNotes) {
      if (midi < minMidi || midi > maxMidi) {
        continue;
      }
      widgets.add(
        _buildSingleMarker(
          keySpec: _keyForMidi(renderedKeys, midi),
          markerColor: theme.colorScheme.tertiary,
          borderColor: theme.colorScheme.onTertiary,
          shadowColor: theme.colorScheme.tertiary,
          markerKey: ValueKey('mini-key-next-$midi'),
          role: _KeyboardMarkerRole.next,
        ),
      );
    }
    return widgets;
  }

  Widget _buildSingleMarker({
    required _RenderedKey keySpec,
    required Color markerColor,
    required Color borderColor,
    required Color shadowColor,
    required Key markerKey,
    required _KeyboardMarkerRole role,
  }) {
    final isBlack = keySpec.isBlack;
    final markerWidth = isBlack ? 10.0 : 14.0;
    final markerHeight = isBlack ? 4.0 : 5.0;
    final top = switch (role) {
      _KeyboardMarkerRole.standard => isBlack ? 4.0 : null,
      _KeyboardMarkerRole.current => isBlack ? null : null,
      _KeyboardMarkerRole.shared => isBlack ? 12.0 : null,
      _KeyboardMarkerRole.next => isBlack ? 4.0 : 5.0,
    };
    final bottom = switch (role) {
      _KeyboardMarkerRole.standard => isBlack ? null : 5.0,
      _KeyboardMarkerRole.current => isBlack ? 4.0 : 5.0,
      _KeyboardMarkerRole.shared => isBlack ? null : 17.0,
      _KeyboardMarkerRole.next => isBlack ? null : null,
    };

    return Positioned(
      left: keySpec.left,
      top: top,
      bottom: bottom,
      width: keySpec.width,
      child: Center(
        child: DecoratedBox(
          key: markerKey,
          decoration: BoxDecoration(
            color: markerColor,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.22),
                blurRadius: isBlack ? 6 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(width: markerWidth, height: markerHeight),
        ),
      ),
    );
  }

  _RenderedKey _keyForMidi(List<_RenderedKey> renderedKeys, int midi) {
    return renderedKeys.firstWhere((key) => key.midi == midi);
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
  const _WhiteKey({super.key, required this.active, required this.label});

  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeTopColor = Color.alphaBlend(
      theme.colorScheme.primary.withValues(alpha: 0.24),
      theme.colorScheme.primaryContainer,
    );
    final activeBottomColor = Color.alphaBlend(
      theme.colorScheme.primary.withValues(alpha: 0.18),
      theme.brightness == Brightness.dark
          ? const Color(0xFF2D3040)
          : const Color(0xFFF4F1FF),
    );
    final borderColor = active
        ? theme.colorScheme.primary.withValues(alpha: 0.82)
        : theme.colorScheme.outlineVariant;
    final labelColor = active
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: active
              ? [activeTopColor, activeBottomColor]
              : [
                  theme.brightness == Brightness.dark
                      ? const Color(0xFFF6F7FB)
                      : const Color(0xFFFFFFFF),
                  theme.brightness == Brightness.dark
                      ? const Color(0xFFDDE1EB)
                      : const Color(0xFFF1F3F8),
                ],
        ),
        border: active
            ? Border(
                top: BorderSide(color: borderColor, width: 1.1),
                right: BorderSide(color: borderColor, width: 0.9),
                bottom: BorderSide(color: borderColor, width: 1.2),
              )
            : Border(
                right: BorderSide(color: borderColor, width: 0.7),
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.72,
                  ),
                  width: 0.55,
                ),
              ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.18),
                  blurRadius: 9,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (active)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                height: 3,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                label ?? '',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlackKey extends StatelessWidget {
  const _BlackKey({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveTopColor = theme.brightness == Brightness.dark
        ? const Color(0xFF4B5160)
        : const Color(0xFF404552);
    final inactiveBottomColor = theme.brightness == Brightness.dark
        ? const Color(0xFF15181F)
        : const Color(0xFF1A1D25);
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
                    Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.2),
                      theme.colorScheme.primary,
                    ),
                  ]
                : [inactiveTopColor, inactiveBottomColor],
          ),
          border: Border.all(
            color: active
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: active ? 1 : 0.7,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (active
                          ? theme.colorScheme.primary
                          : theme.colorScheme.shadow)
                      .withValues(alpha: active ? 0.34 : 0.22),
              blurRadius: active ? 10 : 7,
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

enum _KeyboardMarkerRole { standard, current, shared, next }
