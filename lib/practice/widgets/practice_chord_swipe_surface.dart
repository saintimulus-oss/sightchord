import 'package:flutter/material.dart';

class PracticeChordSwipeSurface extends StatefulWidget {
  const PracticeChordSwipeSurface({
    super.key,
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    this.compact = false,
    this.performanceMode = false,
    required this.statusLabel,
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
  final bool compact;
  final bool performanceMode;
  final String statusLabel;
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

  late final AnimationController _swipeController;
  late final AnimationController _edgeRevealController;
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
  }

  @override
  void didUpdateWidget(covariant PracticeChordSwipeSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    final labelsChanged =
        oldWidget.previousLabel != widget.previousLabel ||
        oldWidget.currentLabel != widget.currentLabel ||
        oldWidget.nextLabel != widget.nextLabel;
    if (!labelsChanged || _activeTransition != null) {
      return;
    }
    cancelTransition();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _edgeRevealController.dispose();
    super.dispose();
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
      _displayNextLabel = '';
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
      _edgeRevealTransition = revealTransition;
    });
    if (revealTransition == null) {
      _startNextQueuedStepIfNeeded();
      return;
    }
    _edgeRevealController.forward(from: 0);
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
    final accentGlow = theme.colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.1,
    );
    final hasStatusLabel = widget.statusLabel.trim().isNotEmpty;
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          _surfaceWidth = width;
          final progress = width <= 0
              ? 0.0
              : (_effectiveOffset / width).clamp(-1.0, 1.0);
          return GestureDetector(
            key: const ValueKey('chord-swipe-surface'),
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: (details) => _handleDragEnd(details, width),
            onHorizontalDragCancel: _handleDragCancel,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: theme.colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: accentGlow,
                    blurRadius: 36,
                    offset: const Offset(0, 16),
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
                      padding: EdgeInsets.all(widget.compact ? 14 : 18),
                      child: Column(
                        children: [
                          if (hasStatusLabel) ...[
                            Center(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    key: const ValueKey('current-status-label'),
                                    widget.statusLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        (widget.compact
                                                ? theme.textTheme.labelMedium
                                                : theme.textTheme.labelLarge)
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.w700,
                                            ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: widget.compact ? 12 : 18),
                          ],
                          SizedBox(
                            height: widget.compact
                                ? (widget.performanceMode ? 118 : 132)
                                : (widget.performanceMode ? 136 : 154),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerLow
                                          .withValues(alpha: 0.82),
                                      borderRadius: BorderRadius.circular(28),
                                      border: Border.all(
                                        color: theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                _ChordMotionStage(
                                  previousLabel: _displayPreviousLabel,
                                  currentLabel: _displayCurrentLabel,
                                  nextLabel: _displayNextLabel,
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
                          SizedBox(height: widget.compact ? 12 : 18),
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

enum _ChordSwipeTransition { advance, goBack }

enum _ChordTokenRole { previous, current, next }

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
  static const double _sideProminence = 0.26;
  static const double _restSideOpacity = 0.68;

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
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
    }
  }

  Widget _buildToken(
    BuildContext context, {
    required String label,
    required _ChordTokenRole role,
    required _ChordTokenLayout layout,
    required double width,
  }) {
    final theme = Theme.of(context);
    final sideColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.72,
    );
    final currentColor = theme.colorScheme.onSurface;
    final emphasis = layout.prominence.clamp(0.0, 1.0);
    final boxWidth = width * _lerpDouble(0.18, 0.62, emphasis);
    final verticalOffset = _lerpDouble(10, 0, emphasis);
    final onTap = switch (role) {
      _ChordTokenRole.previous => onPreviousTap,
      _ChordTokenRole.next => onNextTap,
      _ChordTokenRole.current => null,
    };
    final tokenKey = switch (role) {
      _ChordTokenRole.previous => const ValueKey('previous-chord-text'),
      _ChordTokenRole.next => const ValueKey('next-chord-text'),
      _ChordTokenRole.current => null,
    };
    final textKey = switch (role) {
      _ChordTokenRole.previous => null,
      _ChordTokenRole.next => null,
      _ChordTokenRole.current => const ValueKey('current-chord-text'),
    };
    final textStyle = TextStyle.lerp(
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
          ? theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.9,
              height: 1,
            )
          : theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.6,
              height: 1,
            ),
      emphasis,
    )?.copyWith(color: Color.lerp(sideColor, currentColor, emphasis));

    return Align(
      alignment: Alignment(layout.alignmentX, 0),
      child: Opacity(
        opacity: label.isEmpty ? 0 : layout.opacity,
        child: Transform.translate(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
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
    );
  }
}

double _lerpDouble(double start, double end, double t) {
  return start + ((end - start) * t);
}
