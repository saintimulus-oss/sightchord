import 'package:flutter/material.dart';

import '../../audio/harmony_audio_models.dart';
import '../../audio/instrument_library_registry.dart';
import '../../l10n/app_localizations.dart';
import '../domain/study_harmony_track_profiles.dart';

class StudyHarmonyTrackExpectationCard extends StatelessWidget {
  const StudyHarmonyTrackExpectationCard({
    super.key,
    required this.pedagogyProfile,
    required this.recommendationProfile,
    required this.soundProfile,
  });

  final TrackPedagogyProfile pedagogyProfile;
  final TrackRecommendationProfile recommendationProfile;
  final TrackSoundProfile soundProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget bulletList(Iterable<String> items, IconData icon) {
      final entries = items.toList(growable: false);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < entries.length; index += 1) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, size: 16, color: colorScheme.primary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entries[index],
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
            if (index < entries.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }

    Widget tagWrap(Iterable<String> items) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final item in items)
            Chip(visualDensity: VisualDensity.compact, label: Text(item)),
        ],
      );
    }

    final instrumentLabel = InstrumentLibraryRegistry.byId(
      soundProfile.suggestedInstrumentId,
    ).displayName;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recommendationProfile.heroHeadline,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendationProfile.heroBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.studyHarmonyTrackFocusSectionTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            bulletList(pedagogyProfile.focusPoints, Icons.check_circle_rounded),
            const SizedBox(height: 14),
            Text(
              l10n.studyHarmonyTrackLessFocusSectionTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            bulletList(
              pedagogyProfile.lighterFocusPoints,
              Icons.remove_circle_outline_rounded,
            ),
            const SizedBox(height: 14),
            Text(
              l10n.studyHarmonyTrackRecommendedForSectionTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              pedagogyProfile.recommendedFor,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.studyHarmonyTrackSoundSectionTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${soundProfile.label}: ${soundProfile.summary}',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.studyHarmonyTrackSoundInstrumentLabel(instrumentLabel),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.studyHarmonyTrackSoundPlaybackLabel(
                soundProfile.runtimeProfile.preferredPattern.localizedLabel(
                  l10n,
                ),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (soundProfile.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              tagWrap(soundProfile.tags),
            ],
            if (soundProfile.playbackTraits.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                l10n.studyHarmonyTrackSoundPlaybackTraitsTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              bulletList(soundProfile.playbackTraits, Icons.tune_rounded),
            ],
            if (soundProfile.expansionTargets.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                l10n.studyHarmonyTrackSoundExpansionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              bulletList(soundProfile.expansionTargets, Icons.outbound_rounded),
            ],
            if (soundProfile.assetStatusNote case final assetNote?) ...[
              const SizedBox(height: 8),
              Text(
                assetNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
