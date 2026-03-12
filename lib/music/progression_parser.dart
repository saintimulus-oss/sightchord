import 'dart:math' as math;

import 'chord_theory.dart';
import 'progression_analysis_models.dart';

class ProgressionParser {
  const ProgressionParser();

  static final RegExp _rootPattern = RegExp(r'^([A-Ga-g](?:#|b)?)(.*)$');
  static final RegExp _bassPattern = RegExp(r'^[A-Ga-g](?:#|b)?$');
  static final RegExp _whitespacePattern = RegExp(r'\s+');

  ProgressionParseResult parse(String input) {
    final normalizedInput = _normalizeInput(input);
    final tokens = <ParsedChordToken>[];
    final measures = <ParsedMeasure>[];
    var tokenIndex = 0;
    var measureIndex = 0;

    for (final rawMeasure in normalizedInput.split('|')) {
      final rawTokens = _splitMeasureTokens(rawMeasure);
      if (rawTokens.isEmpty) {
        continue;
      }

      final measureTokens = <ParsedChordToken>[];
      for (
        var positionInMeasure = 0;
        positionInMeasure < rawTokens.length;
        positionInMeasure += 1
      ) {
        final parsedToken = _parseToken(
          rawTokens[positionInMeasure],
          tokenIndex,
          measureIndex,
          positionInMeasure,
        );
        tokens.add(parsedToken);
        measureTokens.add(parsedToken);
        tokenIndex += 1;
      }

      measures.add(
        ParsedMeasure(measureIndex: measureIndex, tokens: measureTokens),
      );
      measureIndex += 1;
    }

    return ProgressionParseResult(tokens: tokens, measures: measures);
  }

  List<String> _splitMeasureTokens(String measure) {
    final tokens = <String>[];
    var buffer = StringBuffer();
    var parenthesisDepth = 0;

    void flush() {
      final token = buffer.toString().trim();
      if (token.isNotEmpty) {
        tokens.add(token);
      }
      buffer = StringBuffer();
    }

    for (final rune in measure.runes) {
      final character = String.fromCharCode(rune);
      if (character == '(') {
        parenthesisDepth += 1;
        buffer.write(character);
        continue;
      }
      if (character == ')') {
        parenthesisDepth = math.max(0, parenthesisDepth - 1);
        buffer.write(character);
        continue;
      }
      final isSeparator =
          parenthesisDepth == 0 &&
          (character == ',' || _whitespacePattern.hasMatch(character));
      if (isSeparator) {
        flush();
        continue;
      }
      buffer.write(character);
    }
    flush();
    return tokens;
  }

  ParsedChordToken _parseToken(
    String token,
    int index,
    int measureIndex,
    int positionInMeasure,
  ) {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'empty',
      );
    }

    final parts = _splitBass(normalizedToken);
    final rootMatch = _rootPattern.firstMatch(parts.prefix);
    if (rootMatch == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'invalid-root',
      );
    }

    final root = _normalizeNoteToken(rootMatch.group(1)!);
    final rootSemitone = MusicTheory.noteToSemitone[root];
    if (rootSemitone == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'unknown-root',
      );
    }

    final suffix = rootMatch.group(2)?.trim() ?? '';
    final bass = parts.bass == null ? null : _normalizeNoteToken(parts.bass!);
    final bassSemitone = bass == null ? null : MusicTheory.noteToSemitone[bass];
    if (bass != null && bassSemitone == null) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'invalid-bass',
      );
    }

    final suffixParse = _parseSuffix(suffix);

    return ParsedChordToken(
      index: index,
      rawText: token,
      measureIndex: measureIndex,
      positionInMeasure: positionInMeasure,
      chord: ParsedChord(
        sourceSymbol: normalizedToken,
        root: root,
        rootSemitone: rootSemitone,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        suffix: suffix,
        normalizedSuffix: suffixParse.normalizedSuffix,
        displayQuality: suffixParse.displayQuality,
        analysisQuality: suffixParse.analysisQuality,
        extension: suffixParse.extension,
        tensions: suffixParse.tensions,
        addedTones: suffixParse.addedTones,
        alterations: suffixParse.alterations,
        suspensions: suffixParse.suspensions,
        ignoredTokens: suffixParse.ignoredTokens,
        diagnostics: suffixParse.diagnostics,
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

    final possibleBass = token.substring(lastSlash + 1).trim();
    if (!_bassPattern.hasMatch(possibleBass)) {
      return _ChordWithBass(prefix: token);
    }

    return _ChordWithBass(prefix: token.substring(0, lastSlash), bass: possibleBass);
  }

  _ParsedSuffix _parseSuffix(String suffix) {
    final normalizedSuffix = _normalizeSuffix(suffix);
    final extracted = _extractParentheticalSections(normalizedSuffix);
    final compact = extracted.compact.replaceAll(_whitespacePattern, '');
    final core = _parseCore(compact);
    final modifierScan = _scanInlineModifiers(core.remaining);

    final tensions = <String>[...core.tensions];
    final addedTones = <String>[...core.addedTones];
    final alterations = <String>[...core.alterations];
    final suspensions = <String>[...core.suspensions];
    final ignoredTokens = <String>[
      ...modifierScan.ignoredTokens,
      ...extracted.ignoredTokens,
    ];
    final diagnostics = <String>[...extracted.diagnostics];
    var displayQuality = core.displayQuality;
    var analysisQuality = core.analysisQuality;
    var extension = core.extension;

    final modifierTokens = <String>[
      ...modifierScan.tokens,
      ...extracted.tokens,
    ];
    for (final token in modifierTokens) {
      switch (token) {
        case 'maj7':
          extension = _maxExtension(extension, 7);
          if (analysisQuality == ChordQuality.minorTriad ||
              analysisQuality == ChordQuality.minor7 ||
              analysisQuality == ChordQuality.minor6) {
            displayQuality = ChordQuality.minorMajor7;
            analysisQuality = ChordQuality.minorMajor7;
          } else {
            displayQuality = ChordQuality.major7;
            analysisQuality = ChordQuality.major7;
          }
        case '9' || '11' || '13':
          _appendUnique(tensions, token);
          extension = _maxExtension(extension, int.parse(token));
        case 'add9':
          _appendUnique(addedTones, '9');
        case 'add11':
          _appendUnique(addedTones, '11');
        case 'add13':
          _appendUnique(addedTones, '13');
        case 'sus2':
          _appendUnique(suspensions, '2');
        case 'sus4':
          _appendUnique(suspensions, '4');
          if (analysisQuality == ChordQuality.dominant7 &&
              displayQuality != ChordQuality.dominant13sus4) {
            displayQuality = ChordQuality.dominant7sus4;
          }
        case 'alt':
          _appendUnique(alterations, 'alt');
          if (analysisQuality == ChordQuality.dominant7) {
            displayQuality = ChordQuality.dominant7Alt;
          }
        case 'b9' || '#9' || 'b5' || '#5' || '#11' || 'b13':
          _appendUnique(tensions, token);
          _appendUnique(alterations, token);
          if (token == '#11' && analysisQuality == ChordQuality.dominant7) {
            displayQuality = ChordQuality.dominant7Sharp11;
          } else if (analysisQuality == ChordQuality.dominant7 &&
              token != '#11' &&
              displayQuality == ChordQuality.dominant7) {
            displayQuality = ChordQuality.dominant7Alt;
          }
        case '6/9':
          extension = _maxExtension(extension, 6);
          _appendUnique(tensions, '9');
          if (analysisQuality == ChordQuality.majorTriad ||
              analysisQuality == ChordQuality.six ||
              analysisQuality == ChordQuality.major69) {
            displayQuality = ChordQuality.major69;
            analysisQuality = ChordQuality.major69;
          }
      }
    }

    return _ParsedSuffix(
      displayQuality: displayQuality,
      analysisQuality: analysisQuality,
      extension: extension,
      tensions: tensions,
      addedTones: addedTones,
      alterations: alterations,
      suspensions: suspensions,
      ignoredTokens: ignoredTokens,
      diagnostics: diagnostics,
      normalizedSuffix: normalizedSuffix,
    );
  }

  _CoreParse _parseCore(String compact) {
    final lower = compact.toLowerCase();

    _CoreParse build({
      required String consumed,
      required ChordQuality displayQuality,
      required ChordQuality analysisQuality,
      int? extension,
      List<String> tensions = const [],
      List<String> addedTones = const [],
      List<String> alterations = const [],
      List<String> suspensions = const [],
    }) {
      return _CoreParse(
        displayQuality: displayQuality,
        analysisQuality: analysisQuality,
        extension: extension,
        tensions: tensions,
        addedTones: addedTones,
        alterations: alterations,
        suspensions: suspensions,
        remaining: compact.substring(consumed.length),
      );
    }

    if (lower.startsWith('mmaj13') || lower.startsWith('-maj13')) {
      return build(
        consumed: compact.substring(0, lower.startsWith('mmaj13') ? 6 : 6),
        displayQuality: ChordQuality.minorMajor7,
        analysisQuality: ChordQuality.minorMajor7,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('mmaj9') || lower.startsWith('-maj9')) {
      return build(
        consumed: compact.substring(0, lower.startsWith('mmaj9') ? 5 : 5),
        displayQuality: ChordQuality.minorMajor7,
        analysisQuality: ChordQuality.minorMajor7,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('mmaj7') || lower.startsWith('-maj7')) {
      return build(
        consumed: compact.substring(0, lower.startsWith('mmaj7') ? 5 : 5),
        displayQuality: ChordQuality.minorMajor7,
        analysisQuality: ChordQuality.minorMajor7,
        extension: 7,
      );
    }
    if (lower.startsWith('maj13')) {
      return build(
        consumed: compact.substring(0, 5),
        displayQuality: ChordQuality.major7,
        analysisQuality: ChordQuality.major7,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('maj11')) {
      return build(
        consumed: compact.substring(0, 5),
        displayQuality: ChordQuality.major7,
        analysisQuality: ChordQuality.major7,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('maj9')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.major7,
        analysisQuality: ChordQuality.major7,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('maj7')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.major7,
        analysisQuality: ChordQuality.major7,
        extension: 7,
      );
    }
    if (lower.startsWith('13sus4')) {
      return build(
        consumed: compact.substring(0, 6),
        displayQuality: ChordQuality.dominant13sus4,
        analysisQuality: ChordQuality.dominant7,
        extension: 13,
        tensions: const ['13'],
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('7sus4')) {
      return build(
        consumed: compact.substring(0, 5),
        displayQuality: ChordQuality.dominant7sus4,
        analysisQuality: ChordQuality.dominant7,
        extension: 7,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('sus4') || lower == 'sus') {
      return build(
        consumed: compact.substring(0, lower == 'sus' ? 3 : 4),
        displayQuality: ChordQuality.majorTriad,
        analysisQuality: ChordQuality.majorTriad,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('sus2')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.majorTriad,
        analysisQuality: ChordQuality.majorTriad,
        suspensions: const ['2'],
      );
    }
    if (lower.startsWith('6/9') || lower.startsWith('69')) {
      return build(
        consumed: compact.substring(0, lower.startsWith('6/9') ? 3 : 2),
        displayQuality: ChordQuality.major69,
        analysisQuality: ChordQuality.major69,
        extension: 6,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('m7b5') || lower.startsWith('-7b5')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.halfDiminished7,
        analysisQuality: ChordQuality.halfDiminished7,
        extension: 7,
      );
    }
    if (lower.startsWith('dim7')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.diminished7,
        analysisQuality: ChordQuality.diminished7,
        extension: 7,
      );
    }
    if (lower.startsWith('dim')) {
      return build(
        consumed: compact.substring(0, 3),
        displayQuality: ChordQuality.diminishedTriad,
        analysisQuality: ChordQuality.diminishedTriad,
      );
    }
    if (lower.startsWith('aug') || lower.startsWith('+')) {
      return build(
        consumed: compact.substring(0, lower.startsWith('aug') ? 3 : 1),
        displayQuality: ChordQuality.augmentedTriad,
        analysisQuality: ChordQuality.augmentedTriad,
      );
    }
    if (lower.startsWith('m11') || lower.startsWith('-11')) {
      return build(
        consumed: compact.substring(0, 3),
        displayQuality: ChordQuality.minor7,
        analysisQuality: ChordQuality.minor7,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('m9') || lower.startsWith('-9')) {
      return build(
        consumed: compact.substring(0, 2),
        displayQuality: ChordQuality.minor7,
        analysisQuality: ChordQuality.minor7,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('m7') || lower.startsWith('-7')) {
      return build(
        consumed: compact.substring(0, 2),
        displayQuality: ChordQuality.minor7,
        analysisQuality: ChordQuality.minor7,
        extension: 7,
      );
    }
    if (lower.startsWith('m6') || lower.startsWith('-6')) {
      return build(
        consumed: compact.substring(0, 2),
        displayQuality: ChordQuality.minor6,
        analysisQuality: ChordQuality.minor6,
        extension: 6,
      );
    }
    if (lower.startsWith('m') || lower.startsWith('-')) {
      return build(
        consumed: compact.substring(0, 1),
        displayQuality: ChordQuality.minorTriad,
        analysisQuality: ChordQuality.minorTriad,
      );
    }
    if (lower.startsWith('13')) {
      return build(
        consumed: compact.substring(0, 2),
        displayQuality: ChordQuality.dominant7,
        analysisQuality: ChordQuality.dominant7,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('11')) {
      return build(
        consumed: compact.substring(0, 2),
        displayQuality: ChordQuality.dominant7,
        analysisQuality: ChordQuality.dominant7,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('9')) {
      return build(
        consumed: compact.substring(0, 1),
        displayQuality: ChordQuality.dominant7,
        analysisQuality: ChordQuality.dominant7,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('7')) {
      return build(
        consumed: compact.substring(0, 1),
        displayQuality: ChordQuality.dominant7,
        analysisQuality: ChordQuality.dominant7,
        extension: 7,
      );
    }
    if (lower.startsWith('6')) {
      return build(
        consumed: compact.substring(0, 1),
        displayQuality: ChordQuality.six,
        analysisQuality: ChordQuality.six,
        extension: 6,
      );
    }
    if (lower.startsWith('add13')) {
      return build(
        consumed: compact.substring(0, 5),
        displayQuality: ChordQuality.majorTriad,
        analysisQuality: ChordQuality.majorTriad,
        addedTones: const ['13'],
      );
    }
    if (lower.startsWith('add11')) {
      return build(
        consumed: compact.substring(0, 5),
        displayQuality: ChordQuality.majorTriad,
        analysisQuality: ChordQuality.majorTriad,
        addedTones: const ['11'],
      );
    }
    if (lower.startsWith('add9')) {
      return build(
        consumed: compact.substring(0, 4),
        displayQuality: ChordQuality.majorTriad,
        analysisQuality: ChordQuality.majorTriad,
        addedTones: const ['9'],
      );
    }
    if (lower.startsWith('alt')) {
      return build(
        consumed: compact.substring(0, 3),
        displayQuality: ChordQuality.dominant7Alt,
        analysisQuality: ChordQuality.dominant7,
        extension: 7,
        alterations: const ['alt'],
      );
    }

    return const _CoreParse(
      displayQuality: ChordQuality.majorTriad,
      analysisQuality: ChordQuality.majorTriad,
      remaining: '',
    );
  }

  _ModifierScan _scanInlineModifiers(String input) {
    final tokens = <String>[];
    final ignoredTokens = <String>[];
    var remaining = input;
    while (remaining.isNotEmpty) {
      final token = _recognizedModifierFor(remaining);
      if (token != null) {
        tokens.add(token);
        remaining = remaining.substring(_modifierTokenLength(token, remaining));
        continue;
      }
      final ignoredLength = _ignoredRunLength(remaining);
      ignoredTokens.add(remaining.substring(0, ignoredLength));
      remaining = remaining.substring(ignoredLength);
    }
    return _ModifierScan(tokens: tokens, ignoredTokens: ignoredTokens);
  }

  String? _recognizedModifierFor(String input) {
    final lower = input.toLowerCase();
    for (final token in _orderedModifierTokens) {
      if (lower.startsWith(token.$1)) {
        return token.$2;
      }
    }
    return null;
  }

  int _modifierTokenLength(String token, String source) {
    for (final candidate in _orderedModifierTokens) {
      if (candidate.$2 == token && source.toLowerCase().startsWith(candidate.$1)) {
        return candidate.$1.length;
      }
    }
    return token.length;
  }

  int _ignoredRunLength(String input) {
    for (var length = 1; length <= input.length; length += 1) {
      final remainder = input.substring(length);
      if (remainder.isEmpty || _recognizedModifierFor(remainder) != null) {
        return length;
      }
    }
    return input.length;
  }

  _ExtractedParentheticalSections _extractParentheticalSections(String suffix) {
    final compact = StringBuffer();
    final tokens = <String>[];
    final ignoredTokens = <String>[];
    final diagnostics = <String>[];
    var depth = 0;
    var buffer = StringBuffer();

    for (final rune in suffix.runes) {
      final character = String.fromCharCode(rune);
      if (character == '(') {
        if (depth == 0) {
          buffer = StringBuffer();
        } else {
          buffer.write(character);
        }
        depth += 1;
        continue;
      }
      if (character == ')') {
        if (depth == 0) {
          diagnostics.add('unexpected-close-parenthesis');
          continue;
        }
        depth -= 1;
        if (depth == 0) {
          for (final rawToken in _splitModifierList(buffer.toString())) {
            final normalizedToken = _normalizeModifierToken(rawToken);
            if (normalizedToken == null) {
              ignoredTokens.add(rawToken);
            } else {
              tokens.add(normalizedToken);
            }
          }
        } else {
          buffer.write(character);
        }
        continue;
      }

      if (depth > 0) {
        buffer.write(character);
      } else {
        compact.write(character);
      }
    }

    if (depth > 0) {
      diagnostics.add('unbalanced-parentheses');
      ignoredTokens.add(buffer.toString());
    }

    return _ExtractedParentheticalSections(
      compact: compact.toString(),
      tokens: tokens,
      ignoredTokens: ignoredTokens,
      diagnostics: diagnostics,
    );
  }

  List<String> _splitModifierList(String input) {
    final tokens = <String>[];
    var buffer = StringBuffer();

    void flush() {
      final token = buffer.toString().trim();
      if (token.isNotEmpty) {
        tokens.add(token);
      }
      buffer = StringBuffer();
    }

    for (final rune in input.runes) {
      final character = String.fromCharCode(rune);
      if (character == ',' || _whitespacePattern.hasMatch(character)) {
        flush();
        continue;
      }
      buffer.write(character);
    }
    flush();
    return tokens;
  }

  String? _normalizeModifierToken(String token) {
    final lower = token.trim().toLowerCase();
    if (lower.isEmpty) {
      return null;
    }
    for (final candidate in _orderedModifierTokens) {
      if (candidate.$1 == lower) {
        return candidate.$2;
      }
    }
    if (lower == 'maj') {
      return 'maj7';
    }
    return null;
  }

  String _normalizeInput(String input) {
    return input
        .replaceAll('♭', 'b')
        .replaceAll('♯', '#')
        .replaceAll('Δ', 'maj')
        .replaceAll('△', 'maj')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('ø', 'm7b5')
        .replaceAll('°', 'dim')
        .trim();
  }

  String _normalizeSuffix(String suffix) {
    return suffix
        .replaceAll('♭', 'b')
        .replaceAll('♯', '#')
        .replaceAll('Δ', 'maj')
        .replaceAll('△', 'maj')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('ø', 'm7b5')
        .replaceAll('°', 'dim')
        .trim();
  }

  String _normalizeNoteToken(String token) {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }
    final letter = trimmed[0].toUpperCase();
    final accidental = trimmed.length > 1 ? trimmed.substring(1) : '';
    return '$letter$accidental';
  }

  int _maxExtension(int? current, int next) {
    if (current == null) {
      return next;
    }
    return math.max(current, next);
  }

  void _appendUnique(List<String> values, String next) {
    if (!values.contains(next)) {
      values.add(next);
    }
  }
}

class _ChordWithBass {
  const _ChordWithBass({required this.prefix, this.bass});

  final String prefix;
  final String? bass;
}

class _ParsedSuffix {
  const _ParsedSuffix({
    required this.displayQuality,
    required this.analysisQuality,
    required this.extension,
    required this.tensions,
    required this.addedTones,
    required this.alterations,
    required this.suspensions,
    required this.ignoredTokens,
    required this.diagnostics,
    required this.normalizedSuffix,
  });

  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> alterations;
  final List<String> suspensions;
  final List<String> ignoredTokens;
  final List<String> diagnostics;
  final String normalizedSuffix;
}

class _CoreParse {
  const _CoreParse({
    required this.displayQuality,
    required this.analysisQuality,
    required this.remaining,
    this.extension,
    this.tensions = const [],
    this.addedTones = const [],
    this.alterations = const [],
    this.suspensions = const [],
  });

  final ChordQuality displayQuality;
  final ChordQuality analysisQuality;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> alterations;
  final List<String> suspensions;
  final String remaining;
}

class _ModifierScan {
  const _ModifierScan({required this.tokens, required this.ignoredTokens});

  final List<String> tokens;
  final List<String> ignoredTokens;
}

class _ExtractedParentheticalSections {
  const _ExtractedParentheticalSections({
    required this.compact,
    required this.tokens,
    required this.ignoredTokens,
    required this.diagnostics,
  });

  final String compact;
  final List<String> tokens;
  final List<String> ignoredTokens;
  final List<String> diagnostics;
}

const List<(String, String)> _orderedModifierTokens = [
  ('6/9', '6/9'),
  ('add13', 'add13'),
  ('add11', 'add11'),
  ('add9', 'add9'),
  ('sus4', 'sus4'),
  ('sus2', 'sus2'),
  ('maj7', 'maj7'),
  ('alt', 'alt'),
  ('#11', '#11'),
  ('#9', '#9'),
  ('b13', 'b13'),
  ('b9', 'b9'),
  ('#5', '#5'),
  ('b5', 'b5'),
  ('13', '13'),
  ('11', '11'),
  ('9', '9'),
];
