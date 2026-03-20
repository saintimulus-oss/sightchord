import 'package:flutter/material.dart';

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
                    padding: EdgeInsets.fromLTRB(
                      compactLayout ? 14 : 20,
                      compactLayout ? 12 : 18,
                      compactLayout ? 14 : 20,
                      compactLayout ? 18 : 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (practiceSessionInitialized) ...[
                          transportStrip,
                          if (showFirstRunWelcomeCard && !compactLayout) ...[
                            SizedBox(height: compactLayout ? 12 : 16),
                            firstRunWelcomeCard,
                          ],
                          SizedBox(height: compactLayout ? 14 : 20),
                          chordDisplaySection,
                          if (voicingSuggestionsSection != null) ...[
                            SizedBox(height: compactLayout ? 10 : 14),
                            voicingSuggestionsSection!,
                          ],
                          SizedBox(height: compactLayout ? 10 : 14),
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
