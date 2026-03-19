part of '../../study_harmony_page.dart';

class _HubMetricChipData {
  const _HubMetricChipData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _HubQuestCardData {
  const _HubQuestCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _HubMilestoneCardData {
  const _HubMilestoneCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _HubWeeklyGoalCardData {
  const _HubWeeklyGoalCardData({
    required this.id,
    required this.icon,
    required this.title,
    required this.body,
    required this.progressLabel,
    required this.progressFraction,
    this.badgeLabels = const <String>[],
  });

  final String id;
  final IconData icon;
  final String title;
  final String body;
  final String progressLabel;
  final double progressFraction;
  final List<String> badgeLabels;
}

class _TrackFilterChipData {
  const _TrackFilterChipData({
    required this.track,
    required this.label,
    required this.icon,
  });

  final _StudyHarmonyHubTrack track;
  final String label;
  final IconData icon;
}
