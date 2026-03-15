part of 'practice_home_page.dart';

extension _PracticeHomePageLabels on _MyHomePageState {
  String _currentStatusLabel(AppLocalizations l10n) {
    if (_currentChord == null) {
      return '';
    }
    final analysisLabel = _localizedAnalysisLabel(l10n, _currentChord!);
    return analysisLabel.isEmpty ? l10n.freeModeActive : analysisLabel;
  }

  String _localizedAnalysisLabel(AppLocalizations l10n, GeneratedChord chord) {
    final romanNumeralId = chord.romanNumeralId;
    if (romanNumeralId == null) {
      return '';
    }

    final keyCenter = chord.keyCenter;
    final centerLabel = keyCenter == null
        ? chord.keyName
        : _keyCenterLabel(l10n, keyCenter, trailingColon: false);
    final roman = MusicTheory.romanTokenOf(romanNumeralId);

    if (centerLabel == null || centerLabel.isEmpty) {
      return roman;
    }
    return l10n.analysisLabelWithCenter(centerLabel, roman);
  }

  String _keyCenterLabel(
    AppLocalizations l10n,
    KeyCenter center, {
    required bool trailingColon,
  }) {
    final root = switch (_settings.keyCenterLabelStyle) {
      KeyCenterLabelStyle.modeText => MusicTheory.displayRootForKey(
        center.tonicName,
      ),
      KeyCenterLabelStyle.classicalCase =>
        center.mode == KeyMode.major
            ? MusicTheory.displayRootForKey(center.tonicName)
            : MusicTheory.classicalDisplayRootForKey(center.tonicName),
    };
    final label = switch (_settings.keyCenterLabelStyle) {
      KeyCenterLabelStyle.modeText =>
        '$root ${center.mode == KeyMode.major ? l10n.modeMajor : l10n.modeMinor}',
      KeyCenterLabelStyle.classicalCase => root,
    };
    return trailingColon ? '$label:' : label;
  }

  String _selectedKeySummary(AppLocalizations l10n) {
    final labels = [
      for (final center in _orderedKeyCenters)
        _keyCenterLabel(l10n, center, trailingColon: false),
    ];
    if (labels.isEmpty) {
      return l10n.allKeysTag;
    }
    if (labels.length <= 2) {
      return labels.join('  ·  ');
    }
    return '${labels.take(2).join('  ·  ')} +${labels.length - 2}';
  }

  List<String> _selectedKeyPreviewLabels(
    AppLocalizations l10n, {
    int limit = 6,
  }) {
    return [
      for (final center in _orderedKeyCenters.take(limit))
        _keyCenterLabel(l10n, center, trailingColon: false),
    ];
  }
}
