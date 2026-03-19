import 'package:chordest/l10n/app_localizations.dart';
import 'package:chordest/music/explanation_models.dart';
import 'package:chordest/widgets/explanation_bundle_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'explanation panel renders confidence, ambiguity, reasons, hints, and alternatives',
    (tester) async {
      const bundle = ExplanationBundle(
        summary: 'This cadence keeps a strong pull toward C.',
        trackContext:
            'In a jazz context this is one plausible reading that highlights guide tones.',
        confidenceBadge: ConfidenceBadgeModel(
          label: 'Confidence',
          value: 0.74,
          tone: ConfidenceTone.moderate,
          caption: 'Plausible reading',
        ),
        ambiguityValue: 0.42,
        ambiguityCaption:
            'More than one plausible reading is still in play, so context matters here.',
        caution: 'There is more than one reasonable reading here.',
        reasonTags: [
          ReasonTag(
            code: ReasonCode.guideToneSmoothness,
            label: 'Guide-tone motion',
            detail: 'The inner voices move efficiently.',
          ),
          ReasonTag(
            code: ReasonCode.ambiguityWindow,
            label: 'Competing readings',
            detail: 'Some of the same notes support more than one role.',
          ),
        ],
        listeningHints: [
          ListeningHint(
            title: 'Follow the 3rds and 7ths',
            detail: 'Listen for the smallest inner-line motion.',
          ),
        ],
        performanceHints: [
          PerformanceHint(
            title: 'Target guide tones first',
            detail: 'Outline the 3rd and 7th before adding tensions.',
          ),
        ],
        alternativeInterpretations: [
          AlternativeInterpretation(
            label: 'Alternate reading: subV7/I',
            detail: 'This is another possible interpretation.',
            confidence: 0.44,
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 480,
                  child: ExplanationBundlePanel(bundle: bundle),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('This cadence keeps a strong pull toward C.'),
        findsOneWidget,
      );
      expect(find.text('Plausible reading'), findsOneWidget);
      expect(
        find.text(
          'More than one plausible reading is still in play, so context matters here.',
        ),
        findsOneWidget,
      );
      expect(find.text('Why this result'), findsOneWidget);
      expect(find.text('Guide-tone motion'), findsOneWidget);
      expect(find.text('Listening focus'), findsOneWidget);
      expect(find.text('Performance focus'), findsOneWidget);
      expect(find.text('Other readings'), findsOneWidget);
      expect(find.text('44%'), findsOneWidget);
    },
  );
}
