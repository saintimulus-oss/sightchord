import '../l10n/app_localizations.dart';
import 'chord_theory.dart';

enum MusicNotationLocale { uiDefault, english }

enum NoteNamingStyle { english, latin }

class NotationPreferences {
  const NotationPreferences({
    this.locale = MusicNotationLocale.uiDefault,
    this.noteNamingStyle = NoteNamingStyle.english,
    this.showRomanNumeralAssist = false,
    this.showChordTextAssist = false,
  });

  final MusicNotationLocale locale;
  final NoteNamingStyle noteNamingStyle;
  final bool showRomanNumeralAssist;
  final bool showChordTextAssist;

  NotationPreferences copyWith({
    MusicNotationLocale? locale,
    NoteNamingStyle? noteNamingStyle,
    bool? showRomanNumeralAssist,
    bool? showChordTextAssist,
  }) {
    return NotationPreferences(
      locale: locale ?? this.locale,
      noteNamingStyle: noteNamingStyle ?? this.noteNamingStyle,
      showRomanNumeralAssist:
          showRomanNumeralAssist ?? this.showRomanNumeralAssist,
      showChordTextAssist: showChordTextAssist ?? this.showChordTextAssist,
    );
  }
}

extension MusicNotationLocaleX on MusicNotationLocale {
  String get storageKey => name;

  static MusicNotationLocale fromStorageKey(String? value) {
    return MusicNotationLocale.values.firstWhere(
      (locale) => locale.storageKey == value,
      orElse: () => MusicNotationLocale.uiDefault,
    );
  }

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MusicNotationLocale.uiDefault => l10n.musicNotationLocaleUiDefault,
      MusicNotationLocale.english => l10n.musicNotationLocaleEnglish,
    };
  }
}

extension NoteNamingStyleX on NoteNamingStyle {
  String get storageKey => name;

  static NoteNamingStyle fromStorageKey(String? value) {
    return NoteNamingStyle.values.firstWhere(
      (style) => style.storageKey == value,
      orElse: () => NoteNamingStyle.english,
    );
  }

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      NoteNamingStyle.english => l10n.noteNamingStyleEnglish,
      NoteNamingStyle.latin => l10n.noteNamingStyleLatin,
    };
  }
}

enum _NotationPhraseLanguage { english, korean }

class _NotationPhraseBook {
  const _NotationPhraseBook._(this.language);

  final _NotationPhraseLanguage language;

  static _NotationPhraseBook resolve(
    AppLocalizations l10n,
    NotationPreferences preferences,
  ) {
    if (preferences.locale == MusicNotationLocale.english) {
      return const _NotationPhraseBook._(_NotationPhraseLanguage.english);
    }
    if (l10n.localeName.startsWith('ko')) {
      return const _NotationPhraseBook._(_NotationPhraseLanguage.korean);
    }
    return const _NotationPhraseBook._(_NotationPhraseLanguage.english);
  }

  String get majorMode => switch (language) {
    _NotationPhraseLanguage.english => 'major',
    _NotationPhraseLanguage.korean => '장조',
  };

  String get minorMode => switch (language) {
    _NotationPhraseLanguage.english => 'minor',
    _NotationPhraseLanguage.korean => '단조',
  };

  String tritoneSubOf(String target) => switch (language) {
    _NotationPhraseLanguage.english => 'tritone sub of $target',
    _NotationPhraseLanguage.korean => '$target의 트라이톤 대리',
  };

  String ofPhrase(String source, String target) => switch (language) {
    _NotationPhraseLanguage.english => '$source of $target',
    _NotationPhraseLanguage.korean => '$target의 $source',
  };

  String chordWithTensions(String base, String tensions) => switch (language) {
    _NotationPhraseLanguage.english => '$base with $tensions',
    _NotationPhraseLanguage.korean => '$base ($tensions)',
  };

  String chordOverBass(String base, String bass) => switch (language) {
    _NotationPhraseLanguage.english => '$base over $bass',
    _NotationPhraseLanguage.korean => '$base / $bass 베이스',
  };

  String degreePhrase(String token) {
    if (token == 'bVII') {
      return switch (language) {
        _NotationPhraseLanguage.english => 'subtonic',
        _NotationPhraseLanguage.korean => '내림7도',
      };
    }
    if (token.startsWith('b')) {
      return switch (language) {
        _NotationPhraseLanguage.english =>
          'flat ${_baseRomanDegree(token.substring(1))}',
        _NotationPhraseLanguage.korean =>
          '내림${_baseRomanDegree(token.substring(1))}',
      };
    }
    if (token.startsWith('#')) {
      return switch (language) {
        _NotationPhraseLanguage.english =>
          'sharp ${_baseRomanDegree(token.substring(1))}',
        _NotationPhraseLanguage.korean =>
          '올림${_baseRomanDegree(token.substring(1))}',
      };
    }
    return _baseRomanDegree(token);
  }

  String _baseRomanDegree(String token) {
    final upperToken = token.toUpperCase();
    return switch (language) {
      _NotationPhraseLanguage.english => switch (upperToken) {
        'I' => 'tonic',
        'II' => 'supertonic',
        'III' => 'mediant',
        'IV' => 'subdominant',
        'V' => 'dominant',
        'VI' => 'submediant',
        'VII' => 'leading tone',
        _ => token,
      },
      _NotationPhraseLanguage.korean => switch (upperToken) {
        'I' => '1도',
        'II' => '2도',
        'III' => '3도',
        'IV' => '4도',
        'V' => '5도',
        'VI' => '6도',
        'VII' => '7도',
        _ => token,
      },
    };
  }

  String qualityAssist(ChordQuality quality) {
    return switch (language) {
      _NotationPhraseLanguage.english => switch (quality) {
        ChordQuality.majorTriad => 'major triad',
        ChordQuality.minorTriad => 'minor triad',
        ChordQuality.dominant7 => 'dominant seventh',
        ChordQuality.major7 => 'major seventh',
        ChordQuality.minor7 => 'minor seventh',
        ChordQuality.minorMajor7 => 'minor major seventh',
        ChordQuality.halfDiminished7 => 'half-diminished seventh',
        ChordQuality.diminishedTriad => 'diminished triad',
        ChordQuality.diminished7 => 'diminished seventh',
        ChordQuality.augmentedTriad => 'augmented triad',
        ChordQuality.six => 'six chord',
        ChordQuality.minor6 => 'minor six chord',
        ChordQuality.major69 => 'six nine chord',
        ChordQuality.dominant7Alt => 'altered dominant seventh',
        ChordQuality.dominant7Sharp11 => 'dominant seventh sharp eleven',
        ChordQuality.dominant13sus4 => 'dominant thirteen sus four',
        ChordQuality.dominant7sus4 => 'dominant seventh sus four',
      },
      _NotationPhraseLanguage.korean => switch (quality) {
        ChordQuality.majorTriad => '메이저 트라이어드',
        ChordQuality.minorTriad => '마이너 트라이어드',
        ChordQuality.dominant7 => '도미넌트 7',
        ChordQuality.major7 => '메이저 7',
        ChordQuality.minor7 => '마이너 7',
        ChordQuality.minorMajor7 => '마이너 메이저 7',
        ChordQuality.halfDiminished7 => '하프 디미니시드 7',
        ChordQuality.diminishedTriad => '디미니시드 트라이어드',
        ChordQuality.diminished7 => '디미니시드 7',
        ChordQuality.augmentedTriad => '어그먼티드 트라이어드',
        ChordQuality.six => '식스 코드',
        ChordQuality.minor6 => '마이너 식스 코드',
        ChordQuality.major69 => '식스 나인 코드',
        ChordQuality.dominant7Alt => '얼터드 도미넌트 7',
        ChordQuality.dominant7Sharp11 => '도미넌트 7 샤프 11',
        ChordQuality.dominant13sus4 => '도미넌트 13 sus4',
        ChordQuality.dominant7sus4 => '도미넌트 7 sus4',
      },
    };
  }

  String tensionAssist(String tension) {
    return switch (language) {
      _NotationPhraseLanguage.english => switch (tension) {
        '9' => 'nine',
        '11' => 'eleven',
        '13' => 'thirteen',
        '#11' => 'sharp eleven',
        'b9' => 'flat nine',
        '#9' => 'sharp nine',
        'b13' => 'flat thirteen',
        _ => tension,
      },
      _NotationPhraseLanguage.korean => switch (tension) {
        '9' => '9텐션',
        '11' => '11텐션',
        '13' => '13텐션',
        '#11' => '샤프 11',
        'b9' => '플랫 9',
        '#9' => '샤프 9',
        'b13' => '플랫 13',
        _ => tension,
      },
    };
  }
}

class MusicNotationFormatter {
  const MusicNotationFormatter._();

  static const Map<String, String> _latinNames = {
    'C': 'Do',
    'C#': 'Do#',
    'Db': 'Reb',
    'D': 'Re',
    'D#': 'Re#',
    'Eb': 'Mib',
    'E': 'Mi',
    'F': 'Fa',
    'F#': 'Fa#',
    'Gb': 'Solb',
    'G': 'Sol',
    'G#': 'Sol#',
    'Ab': 'Lab',
    'A': 'La',
    'A#': 'La#',
    'Bb': 'Sib',
    'B': 'Si',
    'Cb': 'Dob',
    'B#': 'Si#',
    'E#': 'Mi#',
    'Fb': 'Mib',
  };

  static String formatPitch(
    String pitch, {
    NotationPreferences preferences = const NotationPreferences(),
    bool lowercase = false,
  }) {
    final normalized = pitch.trim();
    final slashParts = normalized.split('/');
    final formatted = slashParts.length > 1
        ? slashParts
              .map(
                (part) => _formatSinglePitch(
                  pitch: part.trim(),
                  noteNamingStyle: preferences.noteNamingStyle,
                ),
              )
              .join('/')
        : _formatSinglePitch(
            pitch: normalized,
            noteNamingStyle: preferences.noteNamingStyle,
          );
    return lowercase ? formatted.toLowerCase() : formatted;
  }

  static String formatPitchWithOctave(
    String pitchWithOctave, {
    NotationPreferences preferences = const NotationPreferences(),
  }) {
    final match = RegExp(
      r'^([A-G](?:#|b)?)(-?\d+)$',
    ).firstMatch(pitchWithOctave.trim());
    if (match == null) {
      return formatPitch(pitchWithOctave, preferences: preferences);
    }
    final pitch = match.group(1)!;
    final octave = match.group(2)!;
    return '${formatPitch(pitch, preferences: preferences)}$octave';
  }

  static String formatKeyCenterLabel({
    required KeyCenter center,
    required KeyCenterLabelStyle labelStyle,
    required NotationPreferences preferences,
    required AppLocalizations l10n,
    bool trailingColon = false,
  }) {
    final phraseBook = _NotationPhraseBook.resolve(l10n, preferences);
    final root = switch (labelStyle) {
      KeyCenterLabelStyle.modeText => formatPitch(
        MusicTheory.displayRootForKey(center.tonicName),
        preferences: preferences,
      ),
      KeyCenterLabelStyle.classicalCase => formatPitch(
        center.mode == KeyMode.major
            ? MusicTheory.displayRootForKey(center.tonicName)
            : MusicTheory.classicalDisplayRootForKey(center.tonicName),
        preferences: preferences,
        lowercase: center.mode == KeyMode.minor,
      ),
    };
    final label = switch (labelStyle) {
      KeyCenterLabelStyle.modeText =>
        '$root ${center.mode == KeyMode.major ? phraseBook.majorMode : phraseBook.minorMode}',
      KeyCenterLabelStyle.classicalCase => root,
    };
    return trailingColon ? '$label:' : label;
  }

  static String? romanAssistForRomanNumeralId(
    RomanNumeralId? romanNumeralId, {
    required AppLocalizations l10n,
    NotationPreferences preferences = const NotationPreferences(),
  }) {
    if (!preferences.showRomanNumeralAssist || romanNumeralId == null) {
      return null;
    }
    final phraseBook = _NotationPhraseBook.resolve(l10n, preferences);
    final token = MusicTheory.romanDegreeTokenOf(romanNumeralId);
    if (token.startsWith('subV/')) {
      final target = token.substring('subV/'.length);
      return phraseBook.tritoneSubOf(phraseBook.degreePhrase(target));
    }
    final slashIndex = token.indexOf('/');
    if (slashIndex >= 0) {
      final source = token.substring(0, slashIndex);
      final target = token.substring(slashIndex + 1);
      return phraseBook.ofPhrase(
        phraseBook.degreePhrase(source),
        phraseBook.degreePhrase(target),
      );
    }
    return phraseBook.degreePhrase(token);
  }

  static String? chordAssistForSymbolData(
    ChordSymbolData symbolData, {
    required AppLocalizations l10n,
    NotationPreferences preferences = const NotationPreferences(),
  }) {
    if (!preferences.showChordTextAssist) {
      return null;
    }
    final phraseBook = _NotationPhraseBook.resolve(l10n, preferences);
    var label = phraseBook.qualityAssist(symbolData.renderQuality);
    if (symbolData.tensions.isNotEmpty) {
      final tensions = symbolData.tensions
          .map(phraseBook.tensionAssist)
          .join(', ');
      label = phraseBook.chordWithTensions(label, tensions);
    }
    if (symbolData.bass != null) {
      label = phraseBook.chordOverBass(
        label,
        formatPitch(symbolData.bass!, preferences: preferences),
      );
    }
    return label;
  }

  static String _formatSinglePitch({
    required String pitch,
    required NoteNamingStyle noteNamingStyle,
  }) {
    if (noteNamingStyle == NoteNamingStyle.english) {
      return pitch;
    }
    return _latinNames[pitch] ?? pitch;
  }
}
