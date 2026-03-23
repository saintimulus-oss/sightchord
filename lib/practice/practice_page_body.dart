import 'package:flutter/material.dart';

import '../ui/chordest_ui_tokens.dart';

class PracticePageBody extends StatelessWidget {
  const PracticePageBody({
    super.key,
    required this.compactLayout,
    required this.practiceSessionInitialized,
    required this.showFirstRunWelcomeCard,
    required this.transportStrip,
    required this.firstRunWelcomeCard,
    required this.chordDisplaySection,
    required this.quickSettingsPanel,
    required this.setupPlaceholder,
    this.voicingSuggestionsSection,
  });

  final bool compactLayout;
  final bool practiceSessionInitialized;
  final bool showFirstRunWelcomeCard;
  final Widget transportStrip;
  final Widget firstRunWelcomeCard;
  final Widget chordDisplaySection;
  final Widget? voicingSuggestionsSection;
  final Widget quickSettingsPanel;
  final Widget setupPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: ChordestUiTokens.pageGradient(theme)),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortViewport = constraints.maxHeight < 720;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: compactLayout ? 760 : 920,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      compactLayout ? 14 : 18,
                      compactLayout ? 10 : (shortViewport ? 8 : 10),
                      compactLayout ? 14 : 18,
                      compactLayout ? 16 : (shortViewport ? 14 : 18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (practiceSessionInitialized) ...[
                          transportStrip,
                          if (showFirstRunWelcomeCard && !compactLayout) ...[
                            SizedBox(
                              height: compactLayout
                                  ? 12
                                  : (shortViewport ? 12 : 16),
                            ),
                            firstRunWelcomeCard,
                          ],
                          SizedBox(
                            height: compactLayout
                                ? 12
                                : (shortViewport ? 8 : 12),
                          ),
                          chordDisplaySection,
                          if (voicingSuggestionsSection != null) ...[
                            SizedBox(
                              height: compactLayout
                                  ? 10
                                  : (shortViewport ? 10 : 14),
                            ),
                            voicingSuggestionsSection!,
                          ],
                          SizedBox(
                            height: compactLayout
                                ? 10
                                : (shortViewport ? 10 : 14),
                          ),
                          quickSettingsPanel,
                        ] else
                          setupPlaceholder,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
