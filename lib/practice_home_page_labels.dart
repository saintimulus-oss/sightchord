part of 'practice_home_page.dart';

extension _PracticeHomePageLabels on _MyHomePageState {
  PracticeChordInsight _buildChordInsight(
    AppLocalizations l10n,
    GeneratedChordEvent? event, {
    required String sectionLabel,
  }) {
    final chord = event?.chord;
    if (chord == null) {
      return PracticeChordInsight(
        sectionLabel: sectionLabel,
        keyLabel: _selectedKeySummary(l10n),
        functionLabel: '',
        description: l10n.pressNextChordToBegin,
      );
    }
    final keyLabel = chord.keyCenter != null
        ? _keyCenterLabel(l10n, chord.keyCenter!, trailingColon: false)
        : (chord.keyName?.trim().isNotEmpty ?? false)
        ? chord.keyName!.trim()
        : _selectedKeySummary(l10n);
    final functionLabel = ChordRenderingHelper.displayedRomanLabel(
      chord,
      l10n: l10n,
      preferences: _settings.notationPreferences,
    );
    final description =
        ChordRenderingHelper.chordAssistLabel(
          chord,
          l10n: l10n,
          preferences: _settings.notationPreferences,
        ) ??
        '';
    return PracticeChordInsight(
      sectionLabel: sectionLabel,
      keyLabel: keyLabel,
      functionLabel: functionLabel,
      description: description,
    );
  }

  String _currentStatusLabel(AppLocalizations l10n) {
    if (_currentChord == null) {
      return '';
    }
    final analysisLabel = _localizedAnalysisLabel(l10n, _currentChord!);
    if (analysisLabel.isNotEmpty) {
      return analysisLabel;
    }
    final chordAssist = ChordRenderingHelper.chordAssistLabel(
      _currentChord!,
      l10n: l10n,
      preferences: _settings.notationPreferences,
    );
    return chordAssist ?? l10n.freeModeActive;
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
    final roman = ChordRenderingHelper.displayedRomanLabel(
      chord,
      l10n: l10n,
      preferences: _settings.notationPreferences,
    );
    final analysis = centerLabel == null || centerLabel.isEmpty
        ? roman
        : l10n.analysisLabelWithCenter(centerLabel, roman);
    final chordAssist = ChordRenderingHelper.chordAssistLabel(
      chord,
      l10n: l10n,
      preferences: _settings.notationPreferences,
    );
    if (chordAssist == null || chordAssist.isEmpty) {
      return analysis;
    }
    return '$analysis | $chordAssist';
  }

  String _keyCenterLabel(
    AppLocalizations l10n,
    KeyCenter center, {
    required bool trailingColon,
  }) {
    return MusicNotationFormatter.formatKeyCenterLabel(
      center: center,
      labelStyle: _settings.keyCenterLabelStyle,
      preferences: _settings.notationPreferences,
      l10n: l10n,
      trailingColon: trailingColon,
    );
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
      return labels.join('  |  ');
    }
    return '${labels.take(2).join('  |  ')} +${labels.length - 2}';
  }
}
