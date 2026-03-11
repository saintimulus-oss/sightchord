import 'chord_theory.dart';
import 'progression_analysis_models.dart';

class ProgressionParser {
  const ProgressionParser();

  static final RegExp _splitPattern = RegExp(r'[\s,|]+');
  static final RegExp _rootPattern = RegExp(r'^([A-G](?:#|b)?)(.*)$');
  static final RegExp _bassPattern = RegExp(r'^[A-G](?:#|b)?$');
  static final RegExp _parentheticalPattern = RegExp(r'\(([^)]*)\)');

  ProgressionParseResult parse(String input) {
    final normalizedInput = _normalizeInput(input);
    final rawTokens = normalizedInput
        .split(_splitPattern)
        .where((token) => token.trim().isNotEmpty)
        .toList();

    return ProgressionParseResult(
      tokens: [
        for (var index = 0; index < rawTokens.length; index += 1)
          _parseToken(rawTokens[index], index),
      ],
    );
  }

  ParsedChordToken _parseToken(String token, int index) {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        error: 'empty',
      );
    }

    final parts = _splitBass(normalizedToken);
    final rootMatch = _rootPattern.firstMatch(parts.prefix);
    if (rootMatch == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        error: 'invalid-root',
      );
    }

    final root = rootMatch.group(1)!;
    final rootSemitone = MusicTheory.noteToSemitone[root];
    if (rootSemitone == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        error: 'unknown-root',
      );
    }

    final suffix = rootMatch.group(2)?.trim() ?? '';
    final tensions = _extractTensions(suffix);
    final displayQuality = _detectDisplayQuality(
      suffix: suffix,
      tensions: tensions,
    );
    final bass = parts.bass;
    final bassSemitone = bass == null ? null : MusicTheory.noteToSemitone[bass];

    if (bass != null && bassSemitone == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        error: 'invalid-bass',
      );
    }

    return ParsedChordToken(
      index: index,
      rawText: token,
      chord: ParsedChord(
        sourceSymbol: normalizedToken,
        root: root,
        rootSemitone: rootSemitone,
        suffix: suffix,
        displayQuality: displayQuality,
        analysisQuality: _analysisQualityFor(displayQuality),
        tensions: tensions,
        bass: bass,
        bassSemitone: bassSemitone,
      ),
    );
  }

  _ChordWithBass _splitBass(String token) {
    final lastSlash = token.lastIndexOf('/');
    if (lastSlash <= 0 || lastSlash >= token.length - 1) {
      return _ChordWithBass(prefix: token);
    }

    final possibleBass = token.substring(lastSlash + 1);
    if (!_bassPattern.hasMatch(possibleBass)) {
      return _ChordWithBass(prefix: token);
    }

    return _ChordWithBass(
      prefix: token.substring(0, lastSlash),
      bass: possibleBass,
    );
  }

  List<String> _extractTensions(String suffix) {
    final tensions = <String>[];
    for (final match in _parentheticalPattern.allMatches(suffix)) {
      final body = match.group(1);
      if (body == null || body.trim().isEmpty) {
        continue;
      }
      tensions.addAll(
        body
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    }
    return tensions;
  }

  ChordQuality _detectDisplayQuality({
    required String suffix,
    required List<String> tensions,
  }) {
    final compact = suffix
        .replaceAll(_parentheticalPattern, '')
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('Δ', 'maj')
        .replaceAll('°', 'dim')
        .replaceAll('ø', 'm7b5');
    final lower = compact.toLowerCase();

    if (lower.contains('13sus4')) {
      return ChordQuality.dominant13sus4;
    }
    if (lower.contains('7sus4') || lower == 'sus4' || lower == 'sus') {
      return ChordQuality.dominant7sus4;
    }
    if (lower.contains('7alt') || lower == 'alt') {
      return ChordQuality.dominant7Alt;
    }
    if (tensions.contains('#11') && lower.startsWith('7')) {
      return ChordQuality.dominant7Sharp11;
    }
    if (lower.contains('6/9')) {
      return ChordQuality.major69;
    }
    if (lower.contains('mmaj7') || lower.contains('-maj7')) {
      return ChordQuality.minorMajor7;
    }
    if (lower.contains('m7b5')) {
      return ChordQuality.halfDiminished7;
    }
    if (lower.contains('dim7')) {
      return ChordQuality.diminished7;
    }
    if (lower.contains('maj7')) {
      return ChordQuality.major7;
    }
    if (lower == '7') {
      return ChordQuality.dominant7;
    }
    if (lower.contains('dim')) {
      return ChordQuality.diminishedTriad;
    }
    if (lower.contains('aug') || lower == '+') {
      return ChordQuality.augmentedTriad;
    }
    if (lower.startsWith('m6') || lower.startsWith('-6')) {
      return ChordQuality.minor6;
    }
    if (lower.startsWith('m7') || lower.startsWith('-7')) {
      return ChordQuality.minor7;
    }
    if (lower.startsWith('m') || lower.startsWith('-')) {
      return ChordQuality.minorTriad;
    }
    if (lower == '6') {
      return ChordQuality.six;
    }
    return ChordQuality.majorTriad;
  }

  ChordQuality _analysisQualityFor(ChordQuality displayQuality) {
    return switch (displayQuality) {
      ChordQuality.dominant7Alt => ChordQuality.dominant7,
      ChordQuality.dominant7Sharp11 => ChordQuality.dominant7,
      ChordQuality.dominant13sus4 => ChordQuality.dominant7,
      ChordQuality.dominant7sus4 => ChordQuality.dominant7,
      _ => displayQuality,
    };
  }

  String _normalizeInput(String input) {
    return input
        .replaceAll('♭', 'b')
        .replaceAll('♯', '#')
        .replaceAll('Δ', 'maj')
        .replaceAll('ø', 'm7b5')
        .replaceAll('–', '-')
        .trim();
  }
}

class _ChordWithBass {
  const _ChordWithBass({required this.prefix, this.bass});

  final String prefix;
  final String? bass;
}
