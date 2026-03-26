import 'package:flutter/material.dart';

import '../../ui/chordest_ui_tokens.dart';

class PracticeChordInsight {
  const PracticeChordInsight({
    required this.sectionLabel,
    required this.keyLabel,
    required this.functionLabel,
    this.description = '',
  });

  final String sectionLabel;
  final String keyLabel;
  final String functionLabel;
  final String description;
}

class PracticeChordSwipeSurface extends StatefulWidget {
  const PracticeChordSwipeSurface({
    super.key,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.lookAheadLabel,
    this.compact = false,
    this.performanceMode = false,
    required this.statusLabel,
    required this.currentInsight,
    required this.nextInsight,
    required this.playing,
    required this.beatsPerBar,
    required this.currentBeat,
    this.prioritizeControls = false,
    required this.availableBackSteps,
    required this.onTapAdvance,
    required this.onTapGoBack,
    required this.onSwipeAdvance,
    required this.onSwipeGoBack,
    required this.controls,
  });

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final String lookAheadLabel;
  final bool compact;
  final bool performanceMode;
  final String statusLabel;
  final PracticeChordInsight currentInsight;
  final PracticeChordInsight nextInsight;
  final bool playing;
  final int beatsPerBar;
  final int? currentBeat;
  final bool prioritizeControls;
  final int availableBackSteps;
  final VoidCallback onTapAdvance;
  final VoidCallback onTapGoBack;
  final VoidCallback onSwipeAdvance;
  final VoidCallback onSwipeGoBack;
  final Widget controls;

  @override
  State<PracticeChordSwipeSurface> createState() =>
      PracticeChordSwipeSurfaceState();
}

class PracticeChordSwipeSurfaceState extends State<PracticeChordSwipeSurface>
    with TickerProviderStateMixin {
  static const Duration _swipeDuration = Duration(milliseconds: 260);
  static const Duration _momentumSwipeDuration = Duration(milliseconds: 220);
  static const Duration _snapBackDuration = Duration(milliseconds: 190);
  static const Duration _edgeRevealDuration = Duration(milliseconds: 170);
  static const Duration _pulseDuration = Duration(milliseconds: 1800);

  late final AnimationController _swipeController;
  late final AnimationController _edgeRevealController;
  late final AnimationController _pulseController;
  Animation<double>? _swipeOffsetAnimation;
  VoidCallback? _sequenceCallback;
  _ChordSwipeTransition? _activeTransition;
  _ChordSwipeTransition? _edgeRevealTransition;
  _ChordSwipeTransition? _sequenceDirection;
  var _remainingSequenceSteps = 0;
  var _sequenceUsesMomentum = false;
  var _momentumSequenceCommittedSteps = 0;
  var _momentumSequenceTotalSteps = 0;
  var _momentumSequenceActive = false;
  double _dragOffset = 0;
  double _surfaceWidth = 0;
  late String _displayPreviousLabel;
  late String _displayCurrentLabel;
  late String _displayNextLabel;
  late String _displayLookAheadLabel;

  bool get _canGoBack => widget.availableBackSteps > 0;

  double get _effectiveOffset {
    final rawOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
    if (!_momentumSequenceActive || _sequenceDirection == null) {
      return rawOffset;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final committedTravel = width * _momentumSequenceCommittedSteps;
    return rawOffset +
        (_sequenceDirection == _ChordSwipeTransition.advance
            ? committedTravel
            : -committedTravel);
  }

  double get _edgeRevealProgress =>
      _edgeRevealController.isAnimating ? _edgeRevealController.value : 1;

  bool get isTransitioning =>
      _swipeController.isAnimating ||
      _edgeRevealController.isAnimating ||
      _activeTransition != null ||
      _remainingSequenceSteps > 0;

  @override
  void initState() {
    super.initState();
    _displayPreviousLabel = widget.previousLabel;
    _displayCurrentLabel = widget.currentLabel;
    _displayNextLabel = widget.nextLabel;
    _displayLookAheadLabel = widget.lookAheadLabel;
    _swipeController =
        AnimationController(vsync: this, duration: _swipeDuration)
          ..addListener(_handleSwipeAnimationTick)
          ..addStatusListener((status) {
            if (status != AnimationStatus.completed) {
              return;
            }
            if (_momentumSequenceActive) {
              _finishMomentumSequence();
              return;
            }
            final callback = _sequenceCallback;
            final settledOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
            _swipeOffsetAnimation = null;
            _dragOffset = settledOffset;
            if (callback == null) {
              _dragOffset = 0;
              _activeTransition = null;
              setState(() {});
              return;
            }
            setState(() {});
            callback();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _syncLabelsAfterCommittedTransition();
            });
          });
    _edgeRevealController =
        AnimationController(vsync: this, duration: _edgeRevealDuration)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status != AnimationStatus.completed) {
              return;
            }
            if (!mounted) {
              return;
            }
            setState(() {
              _edgeRevealTransition = null;
            });
            _startNextQueuedStepIfNeeded();
          });
    _pulseController =
        AnimationController(vsync: this, duration: _pulseDuration)
          ..addListener(() {
            if (mounted && widget.playing) {
              setState(() {});
            }
          });
    _syncPulseState();
  }

  @override
  void didUpdateWidget(covariant PracticeChordSwipeSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playing != widget.playing) {
      _syncPulseState();
    }
    final labelsChanged =
        oldWidget.previousLabel != widget.previousLabel ||
        oldWidget.currentLabel != widget.currentLabel ||
        oldWidget.nextLabel != widget.nextLabel ||
        oldWidget.lookAheadLabel != widget.lookAheadLabel;
    if (!labelsChanged || _activeTransition != null) {
      return;
    }
    cancelTransition();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _edgeRevealController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _syncPulseState() {
    if (widget.playing) {
      _pulseController.repeat(reverse: true);
      return;
    }
    _pulseController.stop();
    _pulseController.value = 0;
  }

  void cancelTransition() {
    _swipeController.stop();
    _edgeRevealController.stop();
    _swipeOffsetAnimation = null;
    if (!mounted) {
      return;
    }
    setState(() {
      _activeTransition = null;
      _edgeRevealTransition = null;
      _sequenceDirection = null;
      _sequenceCallback = null;
      _remainingSequenceSteps = 0;
      _sequenceUsesMomentum = false;
      _momentumSequenceCommittedSteps = 0;
      _momentumSequenceTotalSteps = 0;
      _momentumSequenceActive = false;
      _dragOffset = 0;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
      _displayLookAheadLabel = widget.lookAheadLabel;
    });
  }

  void animateAdvance({
    VoidCallback? onCompleted,
    int steps = 1,
    bool useMomentum = false,
  }) {
    final completion = onCompleted ?? widget.onTapAdvance;
    if (_surfaceWidth <= 0) {
      for (var index = 0; index < steps; index += 1) {
        completion();
      }
      return;
    }
    _queueSequence(
      _ChordSwipeTransition.advance,
      steps: steps,
      callback: completion,
      usesMomentum: useMomentum || steps > 1,
    );
  }

  void animateGoBack({
    VoidCallback? onCompleted,
    int steps = 1,
    bool useMomentum = false,
  }) {
    if (!_canGoBack) {
      return;
    }
    final completion = onCompleted ?? widget.onTapGoBack;
    if (_surfaceWidth <= 0) {
      final safeSteps = steps.clamp(0, widget.availableBackSteps);
      for (var index = 0; index < safeSteps; index += 1) {
        completion();
      }
      return;
    }
    _queueSequence(
      _ChordSwipeTransition.goBack,
      steps: steps.clamp(0, widget.availableBackSteps),
      callback: completion,
      usesMomentum: useMomentum || steps > 1,
    );
  }

  void _animateSwipeTo(
    double target, {
    VoidCallback? onCommitted,
    Duration duration = _swipeDuration,
    Curve curve = Curves.easeOutCubic,
  }) {
    _swipeController.stop();
    _swipeController.duration = duration;
    _sequenceCallback = onCommitted;
    _swipeOffsetAnimation = Tween<double>(
      begin: _effectiveOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _swipeController, curve: curve));
    _swipeController.forward(from: 0);
  }

  void _queueSequence(
    _ChordSwipeTransition direction, {
    required int steps,
    required VoidCallback callback,
    bool usesMomentum = false,
  }) {
    if (steps <= 0 || isTransitioning) {
      return;
    }
    if (usesMomentum) {
      _startMomentumSequence(direction, steps: steps, callback: callback);
      return;
    }
    _sequenceDirection = direction;
    _sequenceCallback = callback;
    _remainingSequenceSteps = steps;
    _sequenceUsesMomentum = usesMomentum;
    _startNextQueuedStepIfNeeded();
  }

  void _handleSwipeAnimationTick() {
    if (_momentumSequenceActive) {
      _consumeMomentumCommits();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Duration _momentumDurationForSteps(int steps) {
    final additionalMilliseconds = (steps - 1).clamp(0, 6) * 110;
    return Duration(
      milliseconds:
          _momentumSwipeDuration.inMilliseconds + additionalMilliseconds,
    );
  }

  void _startMomentumSequence(
    _ChordSwipeTransition direction, {
    required int steps,
    required VoidCallback callback,
  }) {
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final directionSign = direction == _ChordSwipeTransition.advance
        ? -1.0
        : 1.0;
    _sequenceDirection = direction;
    _sequenceCallback = callback;
    _sequenceUsesMomentum = true;
    _momentumSequenceActive = true;
    _momentumSequenceCommittedSteps = 0;
    _momentumSequenceTotalSteps = steps;
    _remainingSequenceSteps = 0;
    _activeTransition = direction;
    _animateSwipeTo(
      directionSign * width * steps,
      duration: _momentumDurationForSteps(steps),
      curve: Curves.easeOutCubic,
    );
    _sequenceCallback = callback;
  }

  void _consumeMomentumCommits() {
    if (!_momentumSequenceActive ||
        _sequenceDirection == null ||
        _sequenceCallback == null) {
      return;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final rawOffset = _swipeOffsetAnimation?.value ?? _dragOffset;
    final direction = _sequenceDirection!;
    final advances = direction == _ChordSwipeTransition.advance;
    while (_momentumSequenceCommittedSteps < _momentumSequenceTotalSteps) {
      final nextBoundary = width * (_momentumSequenceCommittedSteps + 1);
      final crossed = advances
          ? rawOffset <= -nextBoundary
          : rawOffset >= nextBoundary;
      if (!crossed) {
        break;
      }
      _momentumSequenceCommittedSteps += 1;
      _applyMomentumDisplayShift(direction);
      _sequenceCallback!.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_momentumSequenceActive) {
          return;
        }
        setState(() {
          _displayPreviousLabel = widget.previousLabel;
          _displayCurrentLabel = widget.currentLabel;
          _displayNextLabel = widget.nextLabel;
          _displayLookAheadLabel = widget.lookAheadLabel;
        });
      });
    }
  }

  void _applyMomentumDisplayShift(_ChordSwipeTransition direction) {
    final previousLabel = _displayPreviousLabel;
    final currentLabel = _displayCurrentLabel;
    final nextLabel = _displayNextLabel;
    if (direction == _ChordSwipeTransition.advance) {
      _displayPreviousLabel = currentLabel;
      _displayCurrentLabel = nextLabel;
      _displayNextLabel = _displayLookAheadLabel;
      _displayLookAheadLabel = '';
      return;
    }
    _displayPreviousLabel = '';
    _displayCurrentLabel = previousLabel;
    _displayNextLabel = currentLabel;
  }

  void _finishMomentumSequence() {
    _swipeOffsetAnimation = null;
    setState(() {
      _activeTransition = null;
      _sequenceCallback = null;
      _sequenceDirection = null;
      _sequenceUsesMomentum = false;
      _momentumSequenceActive = false;
      _momentumSequenceCommittedSteps = 0;
      _momentumSequenceTotalSteps = 0;
      _remainingSequenceSteps = 0;
      _dragOffset = 0;
      _edgeRevealTransition = null;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
      _displayLookAheadLabel = widget.lookAheadLabel;
    });
  }

  void _startNextQueuedStepIfNeeded() {
    if (!mounted ||
        _remainingSequenceSteps <= 0 ||
        _sequenceDirection == null ||
        _activeTransition != null ||
        _swipeController.isAnimating ||
        _edgeRevealController.isAnimating) {
      return;
    }
    final width = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    final direction = _sequenceDirection!;
    _remainingSequenceSteps -= 1;
    _activeTransition = direction;
    _animateSwipeTo(
      direction == _ChordSwipeTransition.advance ? -width : width,
      onCommitted: _sequenceCallback,
      duration: _sequenceUsesMomentum ? _momentumSwipeDuration : _swipeDuration,
      curve: _sequenceUsesMomentum
          ? Curves.linearToEaseOut
          : Curves.easeOutCubic,
    );
  }

  void _syncLabelsAfterCommittedTransition() {
    final revealTransition = _activeTransition;
    setState(() {
      _activeTransition = null;
      _dragOffset = 0;
      _displayPreviousLabel = widget.previousLabel;
      _displayCurrentLabel = widget.currentLabel;
      _displayNextLabel = widget.nextLabel;
      _displayLookAheadLabel = widget.lookAheadLabel;
      _edgeRevealTransition = _shouldRevealEdgeAfterCommit(revealTransition)
          ? revealTransition
          : null;
    });
    if (!_shouldRevealEdgeAfterCommit(revealTransition)) {
      _startNextQueuedStepIfNeeded();
      return;
    }
    _edgeRevealController.forward(from: 0);
  }

  bool _shouldRevealEdgeAfterCommit(_ChordSwipeTransition? transition) {
    if (transition == null) {
      return false;
    }
    return switch (transition) {
      _ChordSwipeTransition.advance => _displayNextLabel.isEmpty,
      _ChordSwipeTransition.goBack => true,
    };
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isTransitioning) {
      return;
    }
    final maxOffset = _surfaceWidth > 0 ? _surfaceWidth : 260.0;
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(
        -maxOffset,
        maxOffset,
      );
    });
  }

  int _stepCountForFling(double velocity) {
    final magnitude = velocity.abs();
    var steps = 1;
    if (magnitude >= 2400) {
      steps += 1;
    }
    if (magnitude >= 4200) {
      steps += 1;
    }
    if (magnitude >= 6000) {
      steps += 1;
    }
    return steps;
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    if (isTransitioning) {
      return;
    }
    final velocity = details.primaryVelocity ?? 0;
    final threshold = width * 0.16;
    final targetOffset = _effectiveOffset;
    final projectedOffset =
        targetOffset + (velocity * (_surfaceWidth > 0 ? 0.08 : 0.06));
    final prefersMomentum =
        velocity.abs() >= 900 || projectedOffset.abs() >= width * 0.28;

    if (projectedOffset <= -threshold || velocity <= -720) {
      animateAdvance(
        onCompleted: widget.onSwipeAdvance,
        steps: _stepCountForFling(velocity),
        useMomentum: prefersMomentum,
      );
      return;
    }
    if ((projectedOffset >= threshold || velocity >= 720) && _canGoBack) {
      animateGoBack(
        onCompleted: widget.onSwipeGoBack,
        steps: _stepCountForFling(velocity).clamp(1, widget.availableBackSteps),
        useMomentum: prefersMomentum,
      );
      return;
    }
    _animateSwipeTo(0, duration: _snapBackDuration, curve: Curves.easeOutCubic);
  }

  void _handleDragCancel() {
    if (_swipeController.isAnimating || _effectiveOffset.abs() < 0.001) {
      return;
    }
    _animateSwipeTo(0, duration: _snapBackDuration, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pulse = Curves.easeInOut.transform(_pulseController.value);
    final accentGlow = colorScheme.primary.withValues(
      alpha: widget.playing
          ? 0.14 + (pulse * 0.08)
          : (theme.brightness == Brightness.dark ? 0.14 : 0.08),
    );
    final rhythmProgress = widget.currentBeat == null || widget.beatsPerBar <= 0
        ? 0.0
        : ((widget.currentBeat! + 1) / widget.beatsPerBar).clamp(0.0, 1.0);
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          _surfaceWidth = width;
          final shortViewport = MediaQuery.sizeOf(context).height < 720;
          final effectiveCompact = widget.compact || shortViewport;
          final stageHeight = shortViewport
              ? (widget.performanceMode ? 128.0 : 148.0)
              : (effectiveCompact
                    ? (widget.performanceMode ? 164.0 : 194.0)
                    : (widget.performanceMode ? 184.0 : 228.0));
          final outerGap = shortViewport
              ? 10.0
              : (effectiveCompact ? 12.0 : 14.0);
          final lowerGap = shortViewport
              ? 10.0
              : (effectiveCompact ? 14.0 : 18.0);
          final progress = width <= 0
              ? 0.0
              : (_effectiveOffset / width).clamp(-1.0, 1.0);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: (details) => _handleDragEnd(details, width),
            onHorizontalDragCancel: _handleDragCancel,
            child: DecoratedBox(
              decoration:
                  ChordestUiTokens.panelDecoration(
                    theme,
                    accent: widget.playing,
                    elevated: true,
                    borderRadius: ChordestUiTokens.radius(34),
                  ).copyWith(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.surface.withValues(alpha: 0.98),
                        colorScheme.surfaceContainerLow.withValues(alpha: 0.94),
                      ],
                    ),
                    boxShadow: [
                      ...ChordestUiTokens.panelShadows(
                        theme,
                        accent: widget.playing,
                        elevated: true,
                      ),
                      BoxShadow(
                        color: accentGlow,
                        blurRadius: 56,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: Stack(
                  children: [
                    Positioned(
                      top: -54,
                      right: -28,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentGlow,
                          ),
                          child: const SizedBox(width: 150, height: 150),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        effectiveCompact ? 16 : 22,
                        effectiveCompact ? 14 : 18,
                        effectiveCompact ? 16 : 22,
                        effectiveCompact ? 16 : 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ChordHeroHeader(
                            compact: effectiveCompact,
                            statusLabel: widget.statusLabel,
                            playing: widget.playing,
                            beatsPerBar: widget.beatsPerBar,
                            currentBeat: widget.currentBeat,
                          ),
                          SizedBox(height: outerGap),
                          _ProgressLine(
                            progress: rhythmProgress,
                            active:
                                widget.playing || widget.currentBeat != null,
                          ),
                          SizedBox(height: lowerGap),
                          SizedBox(
                            key: const ValueKey('chord-swipe-surface'),
                            height: stageHeight,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: ChordestUiTokens.radius(28),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          colorScheme.surface.withValues(
                                            alpha: 0.12,
                                          ),
                                          colorScheme.surface.withValues(
                                            alpha: 0.02,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                _ChordMotionStage(
                                  previousLabel: _displayPreviousLabel,
                                  currentLabel: _displayCurrentLabel,
                                  nextLabel: _displayNextLabel,
                                  lookAheadLabel: _displayLookAheadLabel,
                                  performanceMode: widget.performanceMode,
                                  progress: progress,
                                  edgeRevealTransition: _edgeRevealTransition,
                                  edgeRevealProgress: _edgeRevealProgress,
                                  onPreviousTap: _canGoBack && !isTransitioning
                                      ? animateGoBack
                                      : null,
                                  onNextTap:
                                      !isTransitioning &&
                                          _displayNextLabel.isNotEmpty
                                      ? animateAdvance
                                      : null,
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.34,
                                      heightFactor: 1,
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        key: const ValueKey(
                                          'previous-chord-hit-zone',
                                        ),
                                        behavior: HitTestBehavior.translucent,
                                        onTap: _canGoBack && !isTransitioning
                                            ? animateGoBack
                                            : null,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FractionallySizedBox(
                                      widthFactor: 0.34,
                                      heightFactor: 1,
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        key: const ValueKey(
                                          'next-chord-hit-zone',
                                        ),
                                        behavior: HitTestBehavior.translucent,
                                        onTap:
                                            !isTransitioning &&
                                                _displayNextLabel.isNotEmpty
                                            ? animateAdvance
                                            : null,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: lowerGap),
                          _ChordRelationLine(
                            compact: effectiveCompact,
                            currentInsight: widget.currentInsight,
                            nextInsight: widget.nextInsight,
                          ),
                          SizedBox(height: outerGap),
                          Container(
                            height: 1,
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.22,
                            ),
                          ),
                          SizedBox(height: outerGap),
                          widget.controls,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChordHeroHeader extends StatelessWidget {
  const _ChordHeroHeader({
    required this.compact,
    required this.statusLabel,
    required this.playing,
    required this.beatsPerBar,
    required this.currentBeat,
  });

  final bool compact;
  final String statusLabel;
  final bool playing;
  final int beatsPerBar;
  final int? currentBeat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            key: const ValueKey('current-status-label'),
            statusLabel,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style:
                (compact
                        ? theme.textTheme.bodySmall
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
          ),
        ),
        if (beatsPerBar > 0 && currentBeat != null) ...[
          const SizedBox(width: 12),
          _BeatProgressBadge(
            compact: compact,
            playing: playing,
            label: '${currentBeat! + 1}/$beatsPerBar',
          ),
        ],
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.progress, required this.active});

  final double progress;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: active ? progress : 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.72),
                      colorScheme.primary,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChordRelationLine extends StatelessWidget {
  const _ChordRelationLine({
    required this.compact,
    required this.currentInsight,
    required this.nextInsight,
  });

  final bool compact;
  final PracticeChordInsight currentInsight;
  final PracticeChordInsight nextInsight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSummary = _summaryFor(currentInsight);
    final nextSummary = _summaryFor(nextInsight);
    final fallbackText = currentInsight.description.trim().isNotEmpty
        ? currentInsight.description.trim()
        : nextInsight.description.trim();

    if (currentSummary.isEmpty && nextSummary.isEmpty) {
      return Text(
        fallbackText,
        maxLines: compact ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.35,
        ),
      );
    }

    if (nextSummary.isEmpty) {
      return Text(
        fallbackText.isNotEmpty ? fallbackText : currentSummary,
        maxLines: compact ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        style:
            (compact ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
                ?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _RelationPill(label: currentSummary, accent: true, compact: compact),
        Icon(
          Icons.arrow_forward_rounded,
          size: compact ? 16 : 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        _RelationPill(label: nextSummary, compact: compact),
      ],
    );
  }

  String _summaryFor(PracticeChordInsight insight) {
    final parts = <String>[];
    if (insight.keyLabel.trim().isNotEmpty) {
      parts.add(insight.keyLabel.trim());
    }
    if (insight.functionLabel.trim().isNotEmpty) {
      parts.add(insight.functionLabel.trim());
    }
    return parts.join(' · ');
  }
}

class _BeatProgressBadge extends StatelessWidget {
  const _BeatProgressBadge({
    required this.compact,
    required this.playing,
    required this.label,
  });

  final bool compact;
  final bool playing;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: playing
            ? colorScheme.primaryContainer.withValues(alpha: 0.58)
            : colorScheme.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 6 : 7,
        ),
        child: Text(
          label,
          style:
              (compact
                      ? theme.textTheme.labelMedium
                      : theme.textTheme.labelLarge)
                  ?.copyWith(
                    color: playing
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
        ),
      ),
    );
  }
}

class _RelationPill extends StatelessWidget {
  const _RelationPill({
    required this.label,
    required this.compact,
    this.accent = false,
  });

  final String label;
  final bool compact;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent
            ? colorScheme.primaryContainer.withValues(alpha: 0.42)
            : colorScheme.surface.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 7 : 8,
        ),
        child: Text(
          label,
          style:
              (compact
                      ? theme.textTheme.labelMedium
                      : theme.textTheme.labelLarge)
                  ?.copyWith(
                    color: accent ? colorScheme.primary : colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
        ),
      ),
    );
  }
}

enum _ChordSwipeTransition { advance, goBack }

enum _ChordTokenRole { previous, current, next, lookAhead }

class _ChordTokenLayout {
  const _ChordTokenLayout({
    required this.alignmentX,
    required this.prominence,
    required this.opacity,
  });

  final double alignmentX;
  final double prominence;
  final double opacity;
}

class _ChordTokenSpec {
  const _ChordTokenSpec({
    required this.label,
    required this.role,
    required this.layout,
  });

  final String label;
  final _ChordTokenRole role;
  final _ChordTokenLayout layout;
}

class _ChordMotionStage extends StatelessWidget {
  const _ChordMotionStage({
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.lookAheadLabel,
    required this.performanceMode,
    required this.progress,
    required this.edgeRevealTransition,
    required this.edgeRevealProgress,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  static const double _leftAnchor = -0.76;
  static const double _rightAnchor = 0.76;
  static const double _offLeftAnchor = -1.22;
  static const double _offRightAnchor = 1.22;
  static const double _sideProminence = 0.18;
  static const double _restSideOpacity = 0.46;
  static const double _highlightHandoffWindow = 0.18;

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final String lookAheadLabel;
  final bool performanceMode;
  final double progress;
  final _ChordSwipeTransition? edgeRevealTransition;
  final double edgeRevealProgress;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final specs =
            <_ChordTokenSpec>[
              _ChordTokenSpec(
                label: previousLabel,
                role: _ChordTokenRole.previous,
                layout: _layoutForRole(_ChordTokenRole.previous),
              ),
              _ChordTokenSpec(
                label: currentLabel,
                role: _ChordTokenRole.current,
                layout: _layoutForRole(_ChordTokenRole.current),
              ),
              _ChordTokenSpec(
                label: nextLabel,
                role: _ChordTokenRole.next,
                layout: _layoutForRole(_ChordTokenRole.next),
              ),
              _ChordTokenSpec(
                label: lookAheadLabel,
                role: _ChordTokenRole.lookAhead,
                layout: _layoutForRole(_ChordTokenRole.lookAhead),
              ),
            ]..sort(
              (left, right) =>
                  left.layout.prominence.compareTo(right.layout.prominence),
            );
        return Stack(
          fit: StackFit.expand,
          children: [
            for (final spec in specs)
              _buildToken(
                context,
                label: spec.label,
                role: spec.role,
                layout: spec.layout,
                width: width,
              ),
          ],
        );
      },
    );
  }

  _ChordTokenLayout _restLayoutForRole(_ChordTokenRole role) {
    return switch (role) {
      _ChordTokenRole.previous => const _ChordTokenLayout(
        alignmentX: _leftAnchor,
        prominence: _sideProminence,
        opacity: _restSideOpacity,
      ),
      _ChordTokenRole.current => const _ChordTokenLayout(
        alignmentX: 0,
        prominence: 1,
        opacity: 1,
      ),
      _ChordTokenRole.next => const _ChordTokenLayout(
        alignmentX: _rightAnchor,
        prominence: _sideProminence,
        opacity: _restSideOpacity,
      ),
      _ChordTokenRole.lookAhead => const _ChordTokenLayout(
        alignmentX: _offRightAnchor,
        prominence: 0.08,
        opacity: 0,
      ),
    };
  }

  _ChordTokenLayout _lerpLayout(
    _ChordTokenLayout start,
    _ChordTokenLayout end,
    double t,
  ) {
    return _ChordTokenLayout(
      alignmentX: _lerpDouble(start.alignmentX, end.alignmentX, t),
      prominence: _lerpDouble(start.prominence, end.prominence, t),
      opacity: _lerpDouble(start.opacity, end.opacity, t),
    );
  }

  _ChordTokenLayout _applyEdgeReveal(
    _ChordTokenRole role,
    _ChordTokenLayout layout,
  ) {
    if (edgeRevealTransition == null || edgeRevealProgress >= 1) {
      return layout;
    }
    final t = Curves.easeOutCubic.transform(edgeRevealProgress.clamp(0.0, 1.0));
    switch (edgeRevealTransition!) {
      case _ChordSwipeTransition.advance:
        if (role != _ChordTokenRole.next) {
          return layout;
        }
        return _lerpLayout(
          const _ChordTokenLayout(
            alignmentX: _offRightAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          _restLayoutForRole(_ChordTokenRole.next),
          t,
        );
      case _ChordSwipeTransition.goBack:
        if (role != _ChordTokenRole.previous) {
          return layout;
        }
        return _lerpLayout(
          const _ChordTokenLayout(
            alignmentX: _offLeftAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          _restLayoutForRole(_ChordTokenRole.previous),
          t,
        );
    }
  }

  _ChordTokenLayout _layoutForRole(_ChordTokenRole role) {
    final settled = _restLayoutForRole(role);
    if (progress.abs() < 0.0001) {
      return _applyEdgeReveal(role, settled);
    }
    final t = Curves.easeOutCubic.transform(progress.abs().clamp(0.0, 1.0));
    switch (role) {
      case _ChordTokenRole.previous:
        if (progress >= 0) {
          return _lerpLayout(
            settled,
            const _ChordTokenLayout(alignmentX: 0, prominence: 1, opacity: 1),
            t,
          );
        }
        return _lerpLayout(
          settled,
          const _ChordTokenLayout(
            alignmentX: _offLeftAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          t,
        );
      case _ChordTokenRole.current:
        if (progress >= 0) {
          return _lerpLayout(
            _restLayoutForRole(_ChordTokenRole.current),
            const _ChordTokenLayout(
              alignmentX: _rightAnchor,
              prominence: _sideProminence,
              opacity: 0.78,
            ),
            t,
          );
        }
        return _lerpLayout(
          _restLayoutForRole(_ChordTokenRole.current),
          const _ChordTokenLayout(
            alignmentX: _leftAnchor,
            prominence: _sideProminence,
            opacity: 0.78,
          ),
          t,
        );
      case _ChordTokenRole.next:
        if (progress <= 0) {
          return _lerpLayout(
            settled,
            const _ChordTokenLayout(alignmentX: 0, prominence: 1, opacity: 1),
            t,
          );
        }
        return _lerpLayout(
          settled,
          const _ChordTokenLayout(
            alignmentX: _offRightAnchor,
            prominence: 0.08,
            opacity: 0,
          ),
          t,
        );
      case _ChordTokenRole.lookAhead:
        if (progress < 0) {
          return _lerpLayout(
            settled,
            _restLayoutForRole(_ChordTokenRole.next),
            t,
          );
        }
        return settled;
    }
  }

  double _highlightAmountForRole(_ChordTokenRole role) {
    if (progress.abs() < 0.0001) {
      return role == _ChordTokenRole.current ? 1 : 0;
    }
    final handoffProgress = Curves.easeOutCubic.transform(
      (progress.abs() / _highlightHandoffWindow).clamp(0.0, 1.0),
    );
    if (progress < 0) {
      return switch (role) {
        _ChordTokenRole.current => 1 - handoffProgress,
        _ChordTokenRole.next => handoffProgress,
        _ChordTokenRole.previous => 0,
        _ChordTokenRole.lookAhead => 0,
      };
    }
    return switch (role) {
      _ChordTokenRole.current => 1 - handoffProgress,
      _ChordTokenRole.previous => handoffProgress,
      _ChordTokenRole.next => 0,
      _ChordTokenRole.lookAhead => 0,
    };
  }

  BoxDecoration _highlightDecoration(
    ColorScheme colorScheme,
    double highlightAmount,
  ) {
    return BoxDecoration(
      color: colorScheme.surface.withValues(alpha: 0.18 * highlightAmount),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.14 * highlightAmount),
          blurRadius: 28 * highlightAmount,
          offset: Offset(0, 14 * highlightAmount),
        ),
      ],
    );
  }

  Widget _buildToken(
    BuildContext context, {
    required String label,
    required _ChordTokenRole role,
    required _ChordTokenLayout layout,
    required double width,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sideColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.72);
    final currentColor = colorScheme.onSurface;
    final emphasis = layout.prominence.clamp(0.0, 1.0);
    final boxWidth = width * _lerpDouble(0.18, 0.78, emphasis);
    final verticalOffset = _lerpDouble(18, 0, emphasis);
    final onTap = switch (role) {
      _ChordTokenRole.previous => onPreviousTap,
      _ChordTokenRole.next => onNextTap,
      _ChordTokenRole.current => null,
      _ChordTokenRole.lookAhead => null,
    };
    final tokenKey = switch (role) {
      _ChordTokenRole.previous => const ValueKey('previous-chord-text'),
      _ChordTokenRole.next => const ValueKey('next-chord-text'),
      _ChordTokenRole.lookAhead => const ValueKey('lookahead-chord-text'),
      _ChordTokenRole.current => null,
    };
    final positionKey = switch (role) {
      _ChordTokenRole.previous => const ValueKey('previous-chord-position'),
      _ChordTokenRole.current => const ValueKey('current-chord-position'),
      _ChordTokenRole.next => const ValueKey('next-chord-position'),
      _ChordTokenRole.lookAhead => const ValueKey('lookahead-chord-position'),
    };
    final textKey = switch (role) {
      _ChordTokenRole.previous => null,
      _ChordTokenRole.next => null,
      _ChordTokenRole.current => const ValueKey('current-chord-text'),
      _ChordTokenRole.lookAhead => null,
    };
    final highlightKey = switch (role) {
      _ChordTokenRole.previous => const ValueKey('previous-chord-highlight'),
      _ChordTokenRole.current => const ValueKey('current-chord-highlight'),
      _ChordTokenRole.next => const ValueKey('next-chord-highlight'),
      _ChordTokenRole.lookAhead => const ValueKey('lookahead-chord-highlight'),
    };
    final highlightAmount = _highlightAmountForRole(role);
    final textStyle =
        TextStyle.lerp(
          performanceMode
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  height: 1,
                )
              : theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  height: 1,
                ),
          performanceMode
              ? theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1,
                )
              : theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.9,
                  height: 1,
                ),
          emphasis,
        )?.copyWith(
          color: Color.lerp(sideColor, currentColor, emphasis),
          height: 0.94,
        );

    return Align(
      alignment: Alignment(layout.alignmentX, 0),
      child: Opacity(
        opacity: label.isEmpty ? 0 : layout.opacity,
        child: Transform.translate(
          key: positionKey,
          offset: Offset(0, verticalOffset),
          child: SizedBox(
            width: boxWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: MouseRegion(
                cursor: onTap == null || label.isEmpty
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: GestureDetector(
                  key: tokenKey,
                  behavior: HitTestBehavior.opaque,
                  onTap: label.isEmpty || onTap == null ? null : onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _lerpDouble(4, 12, highlightAmount),
                      vertical: _lerpDouble(6, 10, highlightAmount),
                    ),
                    child: DecoratedBox(
                      key: highlightKey,
                      decoration: _highlightDecoration(
                        colorScheme,
                        highlightAmount,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: _lerpDouble(0, 20, highlightAmount),
                          vertical: _lerpDouble(0, 16, highlightAmount),
                        ),
                        child: Text(
                          key: textKey,
                          label,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double _lerpDouble(double start, double end, double t) {
  return start + ((end - start) * t);
}
