import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth/account_scope.dart';
import 'auth/account_sheet.dart';
import 'billing/billing_scope.dart';
import 'billing/paywall_sheet.dart';
import 'billing/premium_feature_access.dart';
import 'chord_analyzer_history_store.dart';
import 'chord_analyzer_page.dart';
import 'favorite_start_store.dart';
import 'l10n/app_localizations.dart';
import 'main_menu/main_menu_settings_sheet.dart';
import 'main_menu/main_menu_view.dart';
import 'music/chord_formatting.dart';
import 'music/chord_theory.dart';
import 'music/chord_timing_models.dart';
import 'music/notation_presentation.dart';
import 'practice_home_page.dart';
import 'recent_copy_store.dart';
import 'recent_practice_session_store.dart';
import 'settings/practice_settings.dart';
import 'settings/practice_settings_factory.dart';
import 'settings/practice_setup_models.dart';
import 'settings/settings_controller.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key, required this.controller});

  final AppSettingsController controller;

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final AnalyzerInputHistoryStore _analyzerHistoryStore =
      const AnalyzerInputHistoryStore();
  final FavoriteStartStore _favoriteStartStore = const FavoriteStartStore();
  final RecentCopyHistoryStore _recentCopyHistoryStore =
      const RecentCopyHistoryStore();
  final RecentPracticeSessionStore _recentPracticeSessionStore =
      const RecentPracticeSessionStore();
  AnalyzerQuickEntries _analyzerEntries = const AnalyzerQuickEntries();
  FavoriteStartSlots _favoriteStartSlots = const FavoriteStartSlots();
  RecentCopyEntries _recentCopyEntries = const RecentCopyEntries();
  RecentPracticeSessionSnapshot? _recentPracticeSessionSnapshot;

  AppSettingsController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshAnalyzerEntries());
    unawaited(_refreshFavoriteStarts());
    unawaited(_refreshRecentCopyEntries());
    unawaited(_refreshRecentPracticeSession());
  }

  Future<void> _openMainSettings(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => MainMenuSettingsSheet(controller: controller),
    );
  }

  Future<void> _openCodeGenerator(
    BuildContext context, {
    bool openSetupAssistantOnStart = false,
    RecentPracticeSessionSnapshot? initialRecentSessionSnapshot,
  }) async {
    final initialPremiumUnlocked =
        BillingScope.maybeOf(context)?.isPremiumUnlocked ?? false;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MyHomePage(
          title: 'Chordest',
          controller: controller,
          initialPremiumUnlocked: initialPremiumUnlocked,
          openSetupAssistantOnStart: openSetupAssistantOnStart,
          initialRecentSessionSnapshot: initialRecentSessionSnapshot,
        ),
      ),
    );
    await _refreshFavoriteStarts();
    await _refreshRecentCopyEntries();
    await _refreshRecentPracticeSession();
  }

  Future<void> _openChordAnalyzer(
    BuildContext context, {
    String? initialInput,
    bool autoAnalyzeOnStart = false,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChordAnalyzerPage(
          controller: controller,
          initialInput: initialInput,
          autoAnalyzeOnStart: autoAnalyzeOnStart,
        ),
      ),
    );
    await _refreshAnalyzerEntries();
  }

  Future<void> _refreshAnalyzerEntries() async {
    final entries = await _analyzerHistoryStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _analyzerEntries = entries;
    });
  }

  Future<void> _refreshFavoriteStarts() async {
    final slots = await _favoriteStartStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _favoriteStartSlots = slots;
    });
  }

  Future<void> _refreshRecentCopyEntries() async {
    final entries = await _recentCopyHistoryStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _recentCopyEntries = entries;
    });
  }

  Future<void> _refreshRecentPracticeSession() async {
    final snapshot = await _recentPracticeSessionStore.load();
    if (!mounted) {
      return;
    }
    setState(() {
      _recentPracticeSessionSnapshot = snapshot;
    });
  }

  bool _usesKoreanUiCopy(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ko';
  }

  String _quickStartCalmLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '차분 시작' : 'Calm Start';
  }

  String _quickStartCalmTooltip(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '느린 템포와 쉬운 보이싱으로 부드럽게 시작해요.'
        : 'Start with a calmer tempo and easier voicings.';
  }

  String _quickStartSongLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '송 플로우' : 'Song Flow';
  }

  String _quickStartSongTooltip(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '노래처럼 따라가기 쉬운 멜로디 라인을 바로 켜요.'
        : 'Turn on a singable melody line right away.';
  }

  String _quickStartFullerLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '풍성 코드' : 'Fuller Chords';
  }

  String _quickStartFullerTooltip(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '7화음과 4음 보이싱으로 조금 더 풍성하게 열어요.'
        : 'Open with seventh chords and fuller four-note voicings.';
  }

  PracticeSettings _buildCalmStartSettings(PracticeSettings settings) {
    final next = PracticeSettingsFactory.beginnerSafePreset(
      baseSettings: settings,
    );
    return next.copyWith(
      guidedSetupCompleted: true,
      bpm: next.bpm > 72 ? 72 : next.bpm,
    );
  }

  PracticeSettings _buildSongFlowSettings(PracticeSettings settings) {
    final base = PracticeSettingsFactory.fromGeneratorProfile(
      const GeneratorProfile(
        goal: OnboardingGoal.songIdeas,
        harmonyLiteracy: HarmonyLiteracy.basicChordReader,
        handComfort: HandComfort.fourNotes,
        explorationPreference: ExplorationPreference.safe,
        chordSymbolStyle: ChordSymbolStyle.compact,
        startingKeyCenter: KeyCenter(tonicName: 'G', mode: KeyMode.major),
      ),
      baseSettings: settings,
    );
    return PracticeSettingsFactory.applyQuickMelodyPreset(
      base,
      MelodyQuickPreset.songLine,
    ).copyWith(
      guidedSetupCompleted: true,
      melodyPlaybackMode: MelodyPlaybackMode.both,
      autoPlayMelodyWithChords: true,
      bpm: base.bpm < 84 ? 84 : base.bpm,
    );
  }

  PracticeSettings _buildFullerChordSettings(PracticeSettings settings) {
    final next = PracticeSettingsFactory.fromGeneratorProfile(
      const GeneratorProfile(
        goal: OnboardingGoal.keyboardPractice,
        harmonyLiteracy: HarmonyLiteracy.basicChordReader,
        handComfort: HandComfort.fourNotes,
        explorationPreference: ExplorationPreference.safe,
        chordSymbolStyle: ChordSymbolStyle.compact,
        startingKeyCenter: KeyCenter(tonicName: 'F', mode: KeyMode.major),
      ),
      baseSettings: settings,
    );
    return next.copyWith(
      guidedSetupCompleted: true,
      melodyGenerationEnabled: false,
      bpm: next.bpm < 76 ? 76 : next.bpm,
    );
  }

  Future<void> _applyQuickStartAndOpen(
    BuildContext context,
    PracticeSettings nextSettings,
  ) async {
    await controller.update(nextSettings);
    if (!context.mounted) {
      return;
    }
    await _openCodeGenerator(context);
  }

  String _keyCenterLabel(
    AppLocalizations l10n,
    KeyCenter center,
    NotationPreferences preferences,
  ) {
    return MusicNotationFormatter.formatKeyCenterLabel(
      center: center,
      labelStyle: KeyCenterLabelStyle.modeText,
      preferences: preferences,
      l10n: l10n,
      trailingColon: false,
    );
  }

  String _keySummary(AppLocalizations l10n, PracticeSettings settings) {
    final orderedKeyCenters = <KeyCenter>[
      for (final mode in KeyMode.values)
        for (final center in MusicTheory.orderedKeyCentersForMode(mode))
          if (settings.activeKeyCenters.contains(center)) center,
    ];
    if (orderedKeyCenters.isEmpty) {
      return l10n.allKeysTag;
    }
    final labels = [
      for (final center in orderedKeyCenters)
        _keyCenterLabel(l10n, center, settings.notationPreferences),
    ];
    if (labels.length <= 2) {
      return labels.join(' | ');
    }
    return '${labels.take(2).join(' | ')} +${labels.length - 2}';
  }

  String _melodySummary(AppLocalizations l10n, PracticeSettings settings) {
    if (!settings.melodyGenerationEnabled) {
      return l10n.melodyQuickPresetCompactOffLabel;
    }
    return PracticeSettingsFactory.quickMelodyPresetForSettings(
      settings,
    ).compactLocalizedLabel(l10n);
  }

  String _truncateProgressionLabel(String progression, {int maxLength = 26}) {
    if (progression.length <= maxLength) {
      return progression;
    }
    return '${progression.substring(0, maxLength - 1)}...';
  }

  String _recentCopiesLabel(BuildContext context) {
    return _usesKoreanUiCopy(context) ? '최근 복사' : 'Recent copies';
  }

  String _recentCopyKindLabel(BuildContext context, RecentCopyKind kind) {
    return switch (kind) {
      RecentCopyKind.currentChord =>
        _usesKoreanUiCopy(context) ? '현재 코드' : 'Current chord',
      RecentCopyKind.visibleLoop =>
        _usesKoreanUiCopy(context) ? '보이는 루프' : 'Visible loop',
      RecentCopyKind.melodyPreview =>
        _usesKoreanUiCopy(context) ? '멜로디 미리보기' : 'Melody preview',
    };
  }

  IconData _recentCopyKindIcon(RecentCopyKind kind) {
    return switch (kind) {
      RecentCopyKind.currentChord => Icons.music_note_rounded,
      RecentCopyKind.visibleLoop => Icons.linear_scale_rounded,
      RecentCopyKind.melodyPreview => Icons.graphic_eq_rounded,
    };
  }

  String _recentCopiesTooltip(BuildContext context, RecentCopyEntry entry) {
    final label = _recentCopyKindLabel(context, entry.kind);
    final preview = entry.preview();
    return _usesKoreanUiCopy(context)
        ? '최근 복사한 내용을 다시 쓸 수 있어요.\n$label\n$preview'
        : 'Recopy something from recent history.\n$label\n$preview';
  }

  String _copiedRecentCopyMessage(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '최근 복사 내용을 다시 복사했어요.'
        : 'Copied from recent history.';
  }

  String _noRecentCopiesMessage(BuildContext context) {
    return _usesKoreanUiCopy(context)
        ? '최근에 복사한 내용이 아직 없어요.'
        : 'There is no recent copied text yet.';
  }

  String _recentAnalyzerLabel(BuildContext context, String progression) {
    final preview = _truncateProgressionLabel(progression);
    return _usesKoreanUiCopy(context) ? '최근 분석: $preview' : 'Recent: $preview';
  }

  String _recentAnalyzerTooltip(BuildContext context, String progression) {
    return _usesKoreanUiCopy(context)
        ? '최근에 분석한 진행을 다시 엽니다.\n$progression'
        : 'Reopen this recent analysis.\n$progression';
  }

  String _pinnedAnalyzerLabel(BuildContext context, String progression) {
    final preview = _truncateProgressionLabel(progression);
    return _usesKoreanUiCopy(context) ? '고정 진행: $preview' : 'Pinned: $preview';
  }

  String _pinnedAnalyzerTooltip(BuildContext context, String progression) {
    return _usesKoreanUiCopy(context)
        ? '고정한 진행을 바로 엽니다.\n$progression'
        : 'Open this pinned progression.\n$progression';
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _copyRecentHistoryEntry(
    BuildContext context,
    RecentCopyEntry entry,
  ) async {
    await Clipboard.setData(ClipboardData(text: entry.text));
    try {
      final entries = await _recentCopyHistoryStore.remember(
        entry.kind,
        entry.text,
      );
      if (mounted) {
        setState(() {
          _recentCopyEntries = entries;
        });
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'chordest',
          context: ErrorDescription('while refreshing recent copy history'),
        ),
      );
    }
    if (!context.mounted) {
      return;
    }
    _showInfoSnackBar(context, _copiedRecentCopyMessage(context));
  }

  Future<void> _openRecentCopiesSheet(BuildContext context) async {
    final entries = await _recentCopyHistoryStore.load();
    if (!mounted || !context.mounted) {
      return;
    }
    setState(() {
      _recentCopyEntries = entries;
    });
    if (entries.isEmpty) {
      _showInfoSnackBar(context, _noRecentCopiesMessage(context));
      return;
    }
    final theme = Theme.of(context);
    final materialLocalizations = MaterialLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.58,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _recentCopiesLabel(context),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        key: const ValueKey('main-recent-copies-close-button'),
                        onPressed: () => Navigator.of(sheetContext).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                        tooltip: materialLocalizations.closeButtonTooltip,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      key: const ValueKey('main-recent-copy-history-sheet'),
                      children: [
                        for (
                          var index = 0;
                          index < entries.items.length;
                          index += 1
                        )
                          ListTile(
                            key: ValueKey(
                              'main-recent-copy-entry-$index-button',
                            ),
                            leading: Icon(
                              _recentCopyKindIcon(entries.items[index].kind),
                            ),
                            title: Text(
                              _recentCopyKindLabel(
                                context,
                                entries.items[index].kind,
                              ),
                            ),
                            subtitle: Text(
                              entries.items[index].text,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              final entry = entries.items[index];
                              Navigator.of(sheetContext).pop();
                              await Future<void>.delayed(Duration.zero);
                              if (!context.mounted) {
                                return;
                              }
                              await _copyRecentHistoryEntry(context, entry);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  String _favoriteStartLabel(BuildContext context, int index) {
    return _usesKoreanUiCopy(context)
        ? '利먭꺼李얘린 ${index + 1}'
        : 'Fav ${index + 1}';
  }

  // ignore: unused_element
  String _favoriteStartTooltip(
    BuildContext context,
    AppLocalizations l10n,
    FavoriteStartPreset preset,
    int index,
    PracticeSettings baseSettings,
  ) {
    final resolved = preset.applyTo(baseSettings);
    final summary =
        '${resolved.settingsComplexityMode.localizedLabel(l10n)} | '
        '${_keySummary(l10n, resolved)} | '
        '${_melodySummary(l10n, resolved)} | '
        '${resolved.bpm} ${l10n.bpmLabel}';
    if (_usesKoreanUiCopy(context)) {
      return '${index + 1}踰?利먭꺼李얘린 ?쒖옉\n$summary';
    }
    return 'Favorite start ${index + 1}\n$summary';
  }

  String _favoriteStartActionLabel(FavoriteStartPreset preset) {
    return preset.displayLabel;
  }

  String _favoriteStartTooltipMessage(
    BuildContext context,
    AppLocalizations l10n,
    FavoriteStartPreset preset,
    int index,
    PracticeSettings baseSettings,
  ) {
    final resolved = preset.applyTo(baseSettings);
    final summary =
        '${resolved.settingsComplexityMode.localizedLabel(l10n)} | '
        '${_keySummary(l10n, resolved)} | '
        '${_melodySummary(l10n, resolved)} | '
        '${resolved.bpm} ${l10n.bpmLabel}';
    final slotLabel = _usesKoreanUiCopy(context)
        ? 'Favorite ${index + 1}'
        : 'Favorite ${index + 1}';
    final title = preset.hasCustomLabel
        ? '${preset.displayLabel}\n$slotLabel'
        : slotLabel;
    return '$title\n$summary';
  }

  Future<void> _applyFavoriteStartAndOpen(
    BuildContext context,
    FavoriteStartPreset preset, {
    required bool premiumUnlocked,
  }) async {
    final nextSettings = sanitizePracticeSettingsForEntitlement(
      preset.applyTo(controller.settings),
      premiumUnlocked: premiumUnlocked,
    );
    await controller.update(nextSettings);
    if (!context.mounted) {
      return;
    }
    await _openCodeGenerator(context);
  }

  String _practiceChordLabel(
    GeneratedChordEvent? event,
    PracticeSettings settings,
  ) {
    if (event == null) {
      return '';
    }
    return event.displaySymbolOverride ??
        ChordRenderingHelper.renderedSymbol(
          event.chord,
          settings.chordSymbolStyle,
          preferences: settings.notationPreferences,
        );
  }

  String _recentPracticeActionLabel(
    BuildContext context,
    RecentPracticeSessionSnapshot snapshot,
    PracticeSettings settings,
  ) {
    final currentLabel = _practiceChordLabel(
      snapshot.queueState.currentEvent,
      settings,
    );
    if (currentLabel.isEmpty) {
      return _usesKoreanUiCopy(context) ? '이어 하기' : 'Resume';
    }
    return _usesKoreanUiCopy(context)
        ? '이어 하기: $currentLabel'
        : 'Resume: $currentLabel';
  }

  String _recentPracticeTooltip(
    BuildContext context,
    AppLocalizations l10n,
    RecentPracticeSessionSnapshot snapshot,
    PracticeSettings settings,
  ) {
    final labels = <String>[
      _practiceChordLabel(snapshot.queueState.currentEvent, settings),
      _practiceChordLabel(snapshot.queueState.nextEvent, settings),
      _practiceChordLabel(snapshot.queueState.lookAheadEvent, settings),
    ].where((label) => label.isNotEmpty).toList(growable: false);
    final loopPreview = labels.isEmpty
        ? l10n.mainMenuGeneratorDescription
        : labels.join(' -> ');
    final melodyPreview = snapshot.melodyState.currentEvent?.previewText(
      preferFlat:
          snapshot
              .melodyState
              .currentEvent
              ?.chordEvent
              .chord
              .keyCenter
              ?.prefersFlatSpelling ??
          true,
    );
    final melodyLine = (melodyPreview == null || melodyPreview.isEmpty)
        ? _melodySummary(l10n, settings)
        : melodyPreview;
    return _usesKoreanUiCopy(context)
        ? '최근 세션 이어 하기\n$loopPreview\n$melodyLine'
        : 'Resume the last practice session.\n$loopPreview\n$melodyLine';
  }

  Future<void> _resumeRecentPracticeSession(
    BuildContext context,
    RecentPracticeSessionSnapshot snapshot,
  ) async {
    await _openCodeGenerator(context, initialRecentSessionSnapshot: snapshot);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final billing = BillingScope.of(context);
    final account = AccountScope.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[controller, billing, account]),
      builder: (context, _) {
        final accountState = account.state;
        final billingState = billing.state;
        final settings = controller.settings;
        final showSetupAssistantQuickAction =
            !settings.guidedSetupCompleted ||
            settings.settingsComplexityMode == SettingsComplexityMode.guided;
        final showQuickStartActions = settings.guidedSetupCompleted;
        final latestRecent = _analyzerEntries.latestRecent;
        final latestPinned = _analyzerEntries.latestPinned;
        final favorite1 = _favoriteStartSlots.slotAt(0);
        final favorite2 = _favoriteStartSlots.slotAt(1);
        final recentCopyLatest = _recentCopyEntries.latest;
        final recentPracticeSnapshot = _recentPracticeSessionSnapshot;

        return MainMenuView(
          title: 'Chordest',
          intro: l10n.mainMenuIntro,
          settingsLabel: l10n.settings,
          generatorTitle: l10n.mainMenuGeneratorTitle,
          generatorSubtitle: l10n.mainMenuGeneratorDescription,
          analyzerTitle: l10n.mainMenuAnalyzerTitle,
          analyzerSubtitle: l10n.mainMenuAnalyzerDescription,
          statusChips: <MainMenuStatusChip>[
            MainMenuStatusChip(
              chipKey: const ValueKey('main-status-mode-chip'),
              icon: Icons.tune_rounded,
              label: settings.settingsComplexityMode.localizedLabel(l10n),
            ),
            MainMenuStatusChip(
              chipKey: const ValueKey('main-status-keys-chip'),
              icon: Icons.library_music_rounded,
              label: _keySummary(l10n, settings),
            ),
            MainMenuStatusChip(
              chipKey: const ValueKey('main-status-melody-chip'),
              icon: Icons.graphic_eq_rounded,
              label: _melodySummary(l10n, settings),
            ),
            MainMenuStatusChip(
              chipKey: const ValueKey('main-status-bpm-chip'),
              icon: Icons.speed_rounded,
              label: '${settings.bpm} ${l10n.bpmLabel}',
            ),
          ],
          quickActions: <MainMenuQuickAction>[
            if (showSetupAssistantQuickAction)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-setup-assistant-button'),
                icon: Icons.auto_awesome_rounded,
                label: l10n.setupAssistantTitle,
                onPressed: () {
                  unawaited(
                    _openCodeGenerator(
                      context,
                      openSetupAssistantOnStart: true,
                    ),
                  );
                },
              ),
            if (showQuickStartActions)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-quick-start-calm-button'),
                icon: Icons.self_improvement_rounded,
                label: _quickStartCalmLabel(context),
                tooltip: _quickStartCalmTooltip(context),
                onPressed: () {
                  unawaited(
                    _applyQuickStartAndOpen(
                      context,
                      _buildCalmStartSettings(settings),
                    ),
                  );
                },
              ),
            if (showQuickStartActions)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-quick-start-song-button'),
                icon: Icons.music_note_rounded,
                label: _quickStartSongLabel(context),
                tooltip: _quickStartSongTooltip(context),
                onPressed: () {
                  unawaited(
                    _applyQuickStartAndOpen(
                      context,
                      _buildSongFlowSettings(settings),
                    ),
                  );
                },
              ),
            if (showQuickStartActions)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-quick-start-fuller-button'),
                icon: Icons.piano_rounded,
                label: _quickStartFullerLabel(context),
                tooltip: _quickStartFullerTooltip(context),
                onPressed: () {
                  unawaited(
                    _applyQuickStartAndOpen(
                      context,
                      _buildFullerChordSettings(settings),
                    ),
                  );
                },
              ),
            MainMenuQuickAction(
              buttonKey: const ValueKey('main-open-account-button'),
              icon: accountState.isSignedIn
                  ? Icons.person_rounded
                  : Icons.person_outline_rounded,
              label: accountState.isSignedIn
                  ? l10n.accountManageButton
                  : l10n.accountOpenButton,
              onPressed: () => showAccountSheet(context),
            ),
            MainMenuQuickAction(
              buttonKey: const ValueKey('main-open-premium-button'),
              icon: billingState.isPremiumUnlocked
                  ? Icons.workspace_premium_rounded
                  : Icons.lock_open_rounded,
              label: billingState.isPremiumUnlocked
                  ? l10n.premiumUnlockAlreadyOwned
                  : l10n.premiumUnlockCardButton,
              onPressed: () => showPremiumPaywallSheet(context),
            ),
            if (recentCopyLatest != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-recent-copies-button'),
                icon: Icons.content_copy_rounded,
                label: _recentCopiesLabel(context),
                tooltip: _recentCopiesTooltip(context, recentCopyLatest),
                onPressed: () {
                  unawaited(_openRecentCopiesSheet(context));
                },
              ),
            if (recentPracticeSnapshot != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-recent-practice-button'),
                icon: Icons.history_toggle_off_rounded,
                label: _recentPracticeActionLabel(
                  context,
                  recentPracticeSnapshot,
                  settings,
                ),
                tooltip: _recentPracticeTooltip(
                  context,
                  l10n,
                  recentPracticeSnapshot,
                  settings,
                ),
                onPressed: () {
                  unawaited(
                    _resumeRecentPracticeSession(
                      context,
                      recentPracticeSnapshot,
                    ),
                  );
                },
              ),
            if (favorite1 != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-favorite-start-1-button'),
                icon: Icons.bookmark_rounded,
                label: _favoriteStartActionLabel(favorite1),
                tooltip: _favoriteStartTooltipMessage(
                  context,
                  l10n,
                  favorite1,
                  0,
                  settings,
                ),
                onPressed: () {
                  unawaited(
                    _applyFavoriteStartAndOpen(
                      context,
                      favorite1,
                      premiumUnlocked: billingState.isPremiumUnlocked,
                    ),
                  );
                },
              ),
            if (favorite2 != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-favorite-start-2-button'),
                icon: Icons.bookmark_rounded,
                label: _favoriteStartActionLabel(favorite2),
                tooltip: _favoriteStartTooltipMessage(
                  context,
                  l10n,
                  favorite2,
                  1,
                  settings,
                ),
                onPressed: () {
                  unawaited(
                    _applyFavoriteStartAndOpen(
                      context,
                      favorite2,
                      premiumUnlocked: billingState.isPremiumUnlocked,
                    ),
                  );
                },
              ),
            if (latestRecent != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-recent-analyzer-button'),
                icon: Icons.history_rounded,
                label: _recentAnalyzerLabel(context, latestRecent),
                tooltip: _recentAnalyzerTooltip(context, latestRecent),
                onPressed: () {
                  unawaited(
                    _openChordAnalyzer(
                      context,
                      initialInput: latestRecent,
                      autoAnalyzeOnStart: true,
                    ),
                  );
                },
              ),
            if (latestPinned != null)
              MainMenuQuickAction(
                buttonKey: const ValueKey('main-open-pinned-analyzer-button'),
                icon: Icons.push_pin_rounded,
                label: _pinnedAnalyzerLabel(context, latestPinned),
                tooltip: _pinnedAnalyzerTooltip(context, latestPinned),
                onPressed: () {
                  unawaited(
                    _openChordAnalyzer(
                      context,
                      initialInput: latestPinned,
                      autoAnalyzeOnStart: true,
                    ),
                  );
                },
              ),
          ],
          shortcutBindings: <ShortcutActivator, VoidCallback>{
            if (showQuickStartActions)
              const SingleActivator(LogicalKeyboardKey.digit1): () {
                unawaited(
                  _applyQuickStartAndOpen(
                    context,
                    _buildCalmStartSettings(settings),
                  ),
                );
              },
            if (showQuickStartActions)
              const SingleActivator(LogicalKeyboardKey.digit2): () {
                unawaited(
                  _applyQuickStartAndOpen(
                    context,
                    _buildSongFlowSettings(settings),
                  ),
                );
              },
            if (showQuickStartActions)
              const SingleActivator(LogicalKeyboardKey.digit3): () {
                unawaited(
                  _applyQuickStartAndOpen(
                    context,
                    _buildFullerChordSettings(settings),
                  ),
                );
              },
            if (favorite1 != null)
              const SingleActivator(LogicalKeyboardKey.digit4): () {
                unawaited(
                  _applyFavoriteStartAndOpen(
                    context,
                    favorite1,
                    premiumUnlocked: billingState.isPremiumUnlocked,
                  ),
                );
              },
            if (favorite2 != null)
              const SingleActivator(LogicalKeyboardKey.digit5): () {
                unawaited(
                  _applyFavoriteStartAndOpen(
                    context,
                    favorite2,
                    premiumUnlocked: billingState.isPremiumUnlocked,
                  ),
                );
              },
            if (recentPracticeSnapshot != null)
              const SingleActivator(LogicalKeyboardKey.keyR): () {
                unawaited(
                  _resumeRecentPracticeSession(context, recentPracticeSnapshot),
                );
              },
            if (recentCopyLatest != null)
              const SingleActivator(LogicalKeyboardKey.keyC): () {
                unawaited(_openRecentCopiesSheet(context));
              },
            if (latestRecent != null)
              const SingleActivator(LogicalKeyboardKey.keyA, shift: true): () {
                unawaited(
                  _openChordAnalyzer(
                    context,
                    initialInput: latestRecent,
                    autoAnalyzeOnStart: true,
                  ),
                );
              },
          },
          onOpenSettings: () {
            unawaited(_openMainSettings(context));
          },
          onOpenGenerator: () {
            unawaited(_openCodeGenerator(context));
          },
          onOpenAnalyzer: () {
            unawaited(_openChordAnalyzer(context));
          },
        );
      },
    );
  }
}
