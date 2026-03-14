part of 'practice_home_page.dart';

extension _PracticeHomePageUi on _MyHomePageState {
  Widget _buildSettingsDrawer() {
    return PracticeSettingsDrawer(
      settings: _settings,
      onClose: () => Navigator.of(context).maybePop(),
      onApplySettings: (nextSettings, {bool reseed = false}) {
        _applySettings(nextSettings, reseed: reseed);
      },
    );
  }

  Widget _buildPracticeHomePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final previousDisplay = _previousChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _previousChord!,
            _settings.chordSymbolStyle,
          );
    final currentDisplay = _currentChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _currentChord!,
            _settings.chordSymbolStyle,
          );
    final nextDisplay = _nextChord == null
        ? ''
        : ChordRenderingHelper.renderedSymbol(
            _nextChord!,
            _settings.chordSymbolStyle,
          );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): _guardGlobalShortcut(
          _advanceChordUnawaited,
        ),
        const SingleActivator(LogicalKeyboardKey.enter): _guardGlobalShortcut(
          _toggleAutoPlay,
        ),
        const SingleActivator(LogicalKeyboardKey.arrowUp): _guardGlobalShortcut(
          () => _adjustBpm(5),
        ),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            _guardGlobalShortcut(() => _adjustBpm(-5)),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawerEnableOpenDragGesture: false,
          endDrawer: _buildSettingsDrawer(),
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: const Icon(Icons.settings),
                tooltip: l10n.settings,
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    theme.colorScheme.primary.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06,
                    ),
                    theme.scaffoldBackgroundColor,
                  ),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 760,
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withValues(
                                      alpha: 0.82,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BeatIndicatorRow(
                                          beatCount:
                                              _MyHomePageState._beatsPerBar,
                                          activeBeat: _currentBeat,
                                          animationDuration:
                                              _beatIndicatorAnimationDuration(),
                                        ),
                                        const SizedBox(width: 14),
                                        _TransportToggleButton(
                                          running: _autoRunning,
                                          startTooltip: l10n.startAutoplay,
                                          stopTooltip: l10n.stopAutoplay,
                                          onPressed: _toggleAutoPlay,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _ChordSwipeSurface(
                                previousLabel: previousDisplay,
                                currentLabel: currentDisplay,
                                nextLabel: nextDisplay,
                                statusLabel: _currentStatusLabel(l10n),
                                canGoBack: _canRestorePreviousChord,
                                onAdvance: _advanceChordUnawaited,
                                onGoBack: _restorePreviousChord,
                                controls: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _PreviewControlButton(
                                      buttonKey: const ValueKey(
                                        'practice-play-chord-button',
                                      ),
                                      icon: Icons.play_arrow_rounded,
                                      tooltip: l10n.audioPlayChord,
                                      onPressed: _currentChord == null
                                          ? null
                                          : () => _playCurrentChordPreview(
                                              pattern:
                                                  HarmonyPlaybackPattern.block,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    _PreviewControlButton(
                                      buttonKey: const ValueKey(
                                        'practice-play-arpeggio-button',
                                      ),
                                      icon: Icons.multitrack_audio_rounded,
                                      tooltip: l10n.audioPlayArpeggio,
                                      onPressed: _currentChord == null
                                          ? null
                                          : () => _playCurrentChordPreview(
                                              pattern: HarmonyPlaybackPattern
                                                  .arpeggio,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_settings.voicingSuggestionsEnabled &&
                                  _voicingRecommendations != null &&
                                  _voicingRecommendations!
                                      .suggestions
                                      .isNotEmpty) ...[
                                const SizedBox(height: 18),
                                VoicingSuggestionsSection(
                                  recommendations: _voicingRecommendations!,
                                  selectedSignature:
                                      _authoritativeSelectedVoicing()
                                          ?.signature,
                                  showReasons: _settings.showVoicingReasons,
                                  onSelectSuggestion: _handleVoicingSelected,
                                  onToggleLock: _handleVoicingLockToggle,
                                ),
                              ],
                              const SizedBox(height: 18),
                              Center(
                                child: _BpmControlCluster(
                                  bpmController: _bpmController,
                                  bpmLabel: l10n.bpmLabel,
                                  rangeLabel: l10n.allowedRange(
                                    _MyHomePageState._minBpm,
                                    _MyHomePageState._maxBpm,
                                  ),
                                  decreaseTooltip: l10n.decreaseBpm,
                                  increaseTooltip: l10n.increaseBpm,
                                  onDecrease: () => _adjustBpm(-5),
                                  onIncrease: () => _adjustBpm(5),
                                  onChanged: _handleBpmChanged,
                                  onSubmitted: (_) => _normalizeBpm(),
                                  onTapOutside: (_) => _normalizeBpm(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransportToggleButton extends StatelessWidget {
  const _TransportToggleButton({
    required this.running,
    required this.startTooltip,
    required this.stopTooltip,
    required this.onPressed,
  });

  final bool running;
  final String startTooltip;
  final String stopTooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: const ValueKey('practice-autoplay-button'),
      tooltip: running ? stopTooltip : startTooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: running
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerLow,
        foregroundColor: running
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        minimumSize: const Size.square(46),
        side: BorderSide(
          color: running
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      icon: Icon(running ? Icons.stop_rounded : Icons.play_arrow_rounded),
    );
  }
}

class _PreviewControlButton extends StatelessWidget {
  const _PreviewControlButton({
    required this.buttonKey,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Key buttonKey;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      key: buttonKey,
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        disabledBackgroundColor: theme.colorScheme.surfaceContainerLow,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
        minimumSize: const Size.square(54),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      icon: Icon(icon, size: 28),
    );
  }
}

class _BpmControlCluster extends StatelessWidget {
  const _BpmControlCluster({
    required this.bpmController,
    required this.bpmLabel,
    required this.rangeLabel,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    required this.onDecrease,
    required this.onIncrease,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final TextEditingController bpmController;
  final String bpmLabel;
  final String rangeLabel;
  final String decreaseTooltip;
  final String increaseTooltip;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TapRegionCallback onTapOutside;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onDecrease,
                  icon: const Icon(Icons.remove_rounded),
                  tooltip: decreaseTooltip,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerLow,
                    minimumSize: const Size.square(44),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 104,
                  child: TextField(
                    key: const ValueKey('bpm-input'),
                    controller: bpmController,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    onTapOutside: onTapOutside,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10),
                        child: Icon(
                          Icons.speed_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      suffixText: bpmLabel,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onIncrease,
                  icon: const Icon(Icons.add_rounded),
                  tooltip: increaseTooltip,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerLow,
                    minimumSize: const Size.square(44),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              rangeLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChordSwipeSurface extends StatefulWidget {
  const _ChordSwipeSurface({
    required this.previousLabel,
    required this.currentLabel,
    required this.nextLabel,
    required this.statusLabel,
    required this.canGoBack,
    required this.onAdvance,
    required this.onGoBack,
    required this.controls,
  });

  final String previousLabel;
  final String currentLabel;
  final String nextLabel;
  final String statusLabel;
  final bool canGoBack;
  final VoidCallback onAdvance;
  final VoidCallback onGoBack;
  final Widget controls;

  @override
  State<_ChordSwipeSurface> createState() => _ChordSwipeSurfaceState();
}

class _ChordSwipeSurfaceState extends State<_ChordSwipeSurface>
    with SingleTickerProviderStateMixin {
  static const Duration _settleDuration = Duration(milliseconds: 220);

  late final AnimationController _controller;
  Animation<double>? _offsetAnimation;
  VoidCallback? _completionCallback;
  double _dragOffset = 0;

  double get _effectiveOffset => _offsetAnimation?.value ?? _dragOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _settleDuration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        final callback = _completionCallback;
        _completionCallback = null;
        _offsetAnimation = null;
        _dragOffset = 0;
        setState(() {});
        callback?.call();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(
    double target, {
    VoidCallback? onCompleted,
    Duration duration = _settleDuration,
  }) {
    _controller.stop();
    _controller.duration = duration;
    _completionCallback = onCompleted;
    _offsetAnimation = Tween<double>(
      begin: _effectiveOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward(from: 0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating) {
      return;
    }
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-260.0, 260.0);
    });
  }

  void _handleDragEnd(DragEndDetails details, double width) {
    final velocity = details.primaryVelocity ?? 0;
    final threshold = width * 0.16;
    final targetOffset = _effectiveOffset;

    if (targetOffset <= -threshold || velocity <= -720) {
      _animateTo(-width, onCompleted: widget.onAdvance);
      return;
    }
    if ((targetOffset >= threshold || velocity >= 720) && widget.canGoBack) {
      _animateTo(width, onCompleted: widget.onGoBack);
      return;
    }
    _animateTo(0, duration: const Duration(milliseconds: 180));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentGlow = theme.colorScheme.primary.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.1,
    );

    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return GestureDetector(
            key: const ValueKey('chord-swipe-surface'),
            behavior: HitTestBehavior.opaque,
            onTap: widget.onAdvance,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: (details) => _handleDragEnd(details, width),
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
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Column(
                        children: [
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
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 154,
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
                                Transform.translate(
                                  offset: Offset(-width + _effectiveOffset, 0),
                                  child: OverflowBox(
                                    alignment: Alignment.centerLeft,
                                    minWidth: width * 3,
                                    maxWidth: width * 3,
                                    minHeight: 154,
                                    maxHeight: 154,
                                    child: SizedBox(
                                      width: width * 3,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width,
                                            child: _ChordLane(
                                              label: widget.previousLabel,
                                              alignment: Alignment.centerLeft,
                                              emphasis: _ChordLaneEmphasis.side,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width,
                                            child: _ChordLane(
                                              label: widget.currentLabel,
                                              alignment: Alignment.center,
                                              emphasis:
                                                  _ChordLaneEmphasis.current,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width,
                                            child: _ChordLane(
                                              label: widget.nextLabel,
                                              alignment: Alignment.centerRight,
                                              emphasis: _ChordLaneEmphasis.side,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
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

enum _ChordLaneEmphasis { current, side }

class _ChordLane extends StatelessWidget {
  const _ChordLane({
    required this.label,
    required this.alignment,
    required this.emphasis,
  });

  final String label;
  final Alignment alignment;
  final _ChordLaneEmphasis emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrent = emphasis == _ChordLaneEmphasis.current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Align(
        alignment: alignment,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: label.isEmpty ? 0.18 : (isCurrent ? 1 : 0.46),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              key: isCurrent ? const ValueKey('current-chord-text') : null,
              label,
              maxLines: 1,
              style:
                  (isCurrent
                          ? theme.textTheme.displayMedium
                          : theme.textTheme.headlineSmall)
                      ?.copyWith(
                        fontWeight: isCurrent
                            ? FontWeight.w800
                            : FontWeight.w700,
                        color: isCurrent
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                        letterSpacing: isCurrent ? -1.6 : -0.4,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
