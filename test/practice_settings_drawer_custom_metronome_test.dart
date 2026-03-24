import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/settings/metronome_custom_sound_service.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/settings/practice_settings_drawer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uploading a custom metronome sound updates settings', (
    WidgetTester tester,
  ) async {
    final fakeService = _FakeMetronomeCustomSoundService(
      nextSelection: const MetronomeCustomSoundSelection(
        source: MetronomeSourceSpec.localFile(
          localFilePath: 'C:/managed/custom-primary.wav',
          fallbackSound: MetronomeSound.tickD,
        ),
        fileName: 'custom-primary.wav',
      ),
    );

    PracticeSettings? appliedSettings;
    await tester.pumpWidget(
      _TestSettingsDrawerHost(
        metronomeCustomSoundService: fakeService,
        onApplied: (settings) => appliedSettings = settings,
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('metronome-custom-sound-upload-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('metronome-custom-sound-upload-button')),
    );
    await tester.pumpAndSettle();

    expect(fakeService.pickCalls, 1);
    expect(appliedSettings, isNotNull);
    expect(
      appliedSettings!.metronomeSource.kind,
      MetronomeSourceKind.localFile,
    );
    expect(
      appliedSettings!.metronomeSource.trimmedLocalFilePath,
      'C:/managed/custom-primary.wav',
    );
    expect(find.textContaining('custom-primary.wav'), findsOneWidget);
  });

  testWidgets('resetting a custom metronome sound restores built-in mode', (
    WidgetTester tester,
  ) async {
    final fakeService = _FakeMetronomeCustomSoundService();
    PracticeSettings? appliedSettings;

    await tester.pumpWidget(
      _TestSettingsDrawerHost(
        initialSettings: PracticeSettings(
          metronomeSound: MetronomeSound.tickC,
          metronomeSource: MetronomeSourceSpec.localFile(
            localFilePath: 'C:/managed/custom-primary.wav',
            fallbackSound: MetronomeSound.tickC,
          ),
        ),
        metronomeCustomSoundService: fakeService,
        onApplied: (settings) => appliedSettings = settings,
      ),
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('metronome-custom-sound-reset-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('metronome-custom-sound-reset-button')),
    );
    await tester.pumpAndSettle();

    expect(fakeService.clearCalls, 1);
    expect(appliedSettings, isNotNull);
    expect(
      appliedSettings!.metronomeSource.kind,
      MetronomeSourceKind.builtInAsset,
    );
    expect(appliedSettings!.metronomeSound, MetronomeSound.tickC);
  });
}

class _TestSettingsDrawerHost extends StatefulWidget {
  const _TestSettingsDrawerHost({
    this.initialSettings,
    required this.metronomeCustomSoundService,
    required this.onApplied,
  });

  final PracticeSettings? initialSettings;
  final MetronomeCustomSoundService metronomeCustomSoundService;
  final ValueChanged<PracticeSettings> onApplied;

  @override
  State<_TestSettingsDrawerHost> createState() =>
      _TestSettingsDrawerHostState();
}

class _TestSettingsDrawerHostState extends State<_TestSettingsDrawerHost> {
  late PracticeSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings ?? PracticeSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PracticeSettingsDrawer(
          settings: _settings,
          onClose: () {},
          onRunSetupAssistant: () {},
          onOpenAdvancedSettings: () {},
          onApplySettings: (nextSettings, {reseed = false}) {
            setState(() {
              _settings = nextSettings;
            });
            widget.onApplied(nextSettings);
          },
          metronomeCustomSoundService: widget.metronomeCustomSoundService,
        ),
      ),
    );
  }
}

class _FakeMetronomeCustomSoundService implements MetronomeCustomSoundService {
  _FakeMetronomeCustomSoundService({this.nextSelection});

  final MetronomeCustomSoundSelection? nextSelection;
  int pickCalls = 0;
  int clearCalls = 0;

  @override
  bool get isSupported => true;

  @override
  Future<void> clearSlot({required MetronomeCustomSoundSlot slot}) async {
    clearCalls += 1;
  }

  @override
  Future<MetronomeCustomSoundSelection?> pickAndStore({
    required MetronomeCustomSoundSlot slot,
    required MetronomeSound fallbackSound,
  }) async {
    pickCalls += 1;
    return nextSelection;
  }
}
