part of '../../study_harmony_page.dart';

class _HubChapterCard extends StatelessWidget {
  const _HubChapterCard({
    required this.summary,
    required this.progressLabel,
    required this.lessonCountLabel,
    required this.completedCountLabel,
    required this.masteryTier,
    required this.lockedLabel,
    required this.actionLabel,
    required this.onOpen,
    this.rewardLabel,
    this.nextLessonLabel,
  });

  final StudyHarmonyChapterProgressSummaryView summary;
  final String progressLabel;
  final String lessonCountLabel;
  final String completedCountLabel;
  final StudyHarmonyChapterMasteryTier masteryTier;
  final String lockedLabel;
  final String actionLabel;
  final String? rewardLabel;
  final String? nextLessonLabel;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return MergeSemantics(
      child: Card(
        key: ValueKey('study-harmony-chapter-card-${summary.chapter.id}'),
        elevation: 0,
        color: _hubCardColor(colorScheme),
        shape: _hubCardShape(colorScheme),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (!summary.unlocked)
                    Chip(
                      key: ValueKey(
                        'study-harmony-chapter-lock-${summary.chapter.id}',
                      ),
                      avatar: const Icon(Icons.lock_outline_rounded, size: 18),
                      label: Text(lockedLabel),
                    ),
                  if (summary.isCompleted)
                    Chip(
                      avatar: const Icon(Icons.check_circle_rounded, size: 18),
                      label: Text(l10n.studyHarmonyClearedTag),
                    ),
                  if (masteryTier != StudyHarmonyChapterMasteryTier.none)
                    Chip(
                      avatar: Icon(_chapterMasteryIcon(masteryTier), size: 18),
                      label: Text(_chapterMasteryLabel(l10n, masteryTier)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                summary.chapter.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary.chapter.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: progressLabel,
                child: ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      key: ValueKey(
                        'study-harmony-chapter-progress-${summary.chapter.id}',
                      ),
                      value: summary.progressFraction,
                      minHeight: 8,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                progressLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(lessonCountLabel),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    label: Text(completedCountLabel),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (rewardLabel case final reward?)
                    Chip(
                      label: Text(reward),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              if (nextLessonLabel case final nextLesson?) ...[
                const SizedBox(height: 12),
                Text(
                  nextLesson,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: ValueKey(
                    'study-harmony-open-chapter-${summary.chapter.id}',
                  ),
                  onPressed: onOpen,
                  icon: Icon(
                    summary.unlocked
                        ? Icons.auto_stories_rounded
                        : Icons.lock_outline_rounded,
                  ),
                  label: Text(actionLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterLessonTile extends StatelessWidget {
  const _ChapterLessonTile({
    required this.lesson,
    required this.lessonResult,
    required this.unlocked,
    required this.cleared,
    required this.onOpen,
  });

  final StudyHarmonyLessonDefinition lesson;
  final StudyHarmonyLessonProgressSummary? lessonResult;
  final bool unlocked;
  final bool cleared;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: _hubPanelDecoration(colorScheme, radius: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(lesson.objectiveLabel)),
                  if (_isBossLesson(lesson))
                    Chip(label: Text(l10n.studyHarmonyBossTag)),
                  if (cleared) Chip(label: Text(l10n.studyHarmonyClearedTag)),
                  if (!unlocked)
                    Chip(label: Text(l10n.studyHarmonyLockedLessonAction)),
                  if (lessonResult case final result?)
                    if (result.bestStars > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressStars(result.bestStars),
                        ),
                      ),
                  if (lessonResult case final result?)
                    if (result.playCount > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressRuns(result.playCount),
                        ),
                      ),
                  if (lessonResult case final result?)
                    if (result.playCount > 0)
                      Chip(
                        label: Text(
                          l10n.studyHarmonyProgressBestRank(result.bestRank),
                        ),
                      ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                lesson.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                lesson.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: ValueKey('study-harmony-open-lesson-${lesson.id}'),
                  onPressed: onOpen,
                  icon: Icon(
                    unlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                  ),
                  label: Text(
                    unlocked
                        ? l10n.studyHarmonyOpenLessonAction
                        : l10n.studyHarmonyLockedLessonAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
