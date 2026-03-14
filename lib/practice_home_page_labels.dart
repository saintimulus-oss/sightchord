part of 'practice_home_page.dart';

extension _PracticeHomePageLabels on _MyHomePageState {
  String _currentStatusLabel(AppLocalizations l10n) {
    if (_currentChord == null) {
      return l10n.pressNextChordToBegin;
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
}
