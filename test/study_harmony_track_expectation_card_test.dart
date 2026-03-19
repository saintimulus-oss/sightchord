import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/study_harmony/content/track_generation_profiles.dart';
import 'package:chordest/study_harmony/content/track_pedagogy_profiles.dart';
import 'package:chordest/study_harmony/domain/study_harmony_track_profiles.dart';
import 'package:chordest/study_harmony/ui/study_harmony_track_expectation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpTrackExpectationCard(
    WidgetTester tester,
    String trackId,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(
              body: SingleChildScrollView(
                child: StudyHarmonyTrackExpectationCard(
                  pedagogyProfile: trackPedagogyProfileForTrack(l10n, trackId),
                  recommendationProfile: trackRecommendationProfileForTrack(
                    l10n,
                    trackId,
                  ),
                  soundProfile: trackSoundProfileForTrack(l10n, trackId),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'track expectation card shows sound instrument and expansion path',
    (tester) async {
      await pumpTrackExpectationCard(tester, studyHarmonyJazzTrackId);

      expect(find.text('Sound profile'), findsOneWidget);
      expect(find.text('Playback character'), findsOneWidget);
      expect(find.text('Expansion path'), findsOneWidget);
      expect(
        find.textContaining(
          'Current instrument: Salamander Grand Piano Essential',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Recommended preview pattern: Arpeggio'),
        findsOneWidget,
      );
    },
  );
}
