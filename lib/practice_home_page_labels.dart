part of 'practice_home_page.dart';

extension _PracticeHomePageLabels on _MyHomePageState {
  List<String> _practiceModeTags(AppLocalizations l10n) {
    final tags = <String>[_usesKeyMode ? l10n.keyModeTag : l10n.freeModeTag];
    if (_usesKeyMode) {
      tags.addAll(
        _orderedKeyCenters.map(
          (center) => _keyCenterLabel(l10n, center, trailingColon: false),
        ),
      );
      if (_settings.smartGeneratorMode) {
        tags.add(l10n.smartGeneratorMode);
      }
      if (_settings.secondaryDominantEnabled) {
        tags.add(l10n.secondaryDominant);
      }
      if (_settings.substituteDominantEnabled) {
        tags.add(l10n.substituteDominant);
      }
      if (_settings.modalInterchangeEnabled) {
        tags.add(l10n.modalInterchange);
      }
    } else {
      tags.add(l10n.allKeysTag);
    }
    tags.add(l10n.bpmTag(_effectiveBpm()));
    tags.add(
      _settings.metronomeEnabled ? l10n.metronomeOnTag : l10n.metronomeOffTag,
    );
    return tags;
  }

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

  String _practiceModeDescription(AppLocalizations l10n) {
    if (!_usesKeyMode) {
      return l10n.freePracticeDescription;
    }
    if (_settings.smartGeneratorMode) {
      return l10n.smartPracticeDescription;
    }
    return l10n.keyPracticeDescription;
  }
}
