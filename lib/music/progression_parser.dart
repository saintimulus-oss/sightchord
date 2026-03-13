import 'dart:math' as math;

import 'chord_theory.dart';
import 'progression_analysis_models.dart';

class ProgressionParser {
  const ProgressionParser();

  static final RegExp _rootPattern = RegExp(r'^([A-Ga-g](?:[#b])?)(.*)$');
  static final RegExp _potentialBassPattern = RegExp(r'^[A-Za-z](?:[#b])?$');
  static final RegExp _whitespacePattern = RegExp(r'\s');
  static final RegExp _compactWhitespacePattern = RegExp(r'\s+');
  static final RegExp _uppercaseMajorPrefixPattern = RegExp(r'^[0-9(]');

  ProgressionParseResult parse(String input) {
    final tokens = <ParsedChordToken>[];
    final measures = <ParsedMeasure>[];
    final rawMeasures = _splitMeasures(input);
    var tokenIndex = 0;

    for (
      var measureIndex = 0;
      measureIndex < rawMeasures.length;
      measureIndex += 1
    ) {
      final rawTokens = _splitMeasureTokens(rawMeasures[measureIndex]);
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
    }

    return ProgressionParseResult(tokens: tokens, measures: measures);
  }

  List<String> _splitMeasures(String input) {
    final measures = <String>[];
    var buffer = StringBuffer();
    var parenthesisDepth = 0;

    for (final rune in input.runes) {
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
      if (character == '|' && parenthesisDepth == 0) {
        measures.add(buffer.toString());
        buffer = StringBuffer();
        continue;
      }
      buffer.write(character);
    }

    measures.add(buffer.toString());
    return measures;
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
    final rawToken = token.trim();
    if (rawToken.isEmpty) {
      return ParsedChordToken(
        index: index,
        rawText: token,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'empty',
      );
    }

    final normalizedToken = _normalizeInput(rawToken);
    final parts = _splitBass(normalizedToken);
    final rootMatch = _rootPattern.firstMatch(parts.prefix);
    if (rootMatch == null) {
      return ParsedChordToken(
        index: index,
        rawText: rawToken,
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
        rawText: rawToken,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'unknown-root',
        errorDetail: root,
      );
    }

    final bass = parts.bass == null ? null : _normalizeNoteToken(parts.bass!);
    final bassSemitone = bass == null ? null : MusicTheory.noteToSemitone[bass];
    if (bass != null && bassSemitone == null) {
      return ParsedChordToken(
        index: index,
        rawText: rawToken,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: 'invalid-bass',
        errorDetail: parts.bass,
      );
    }

    final suffix = rootMatch.group(2)?.trim() ?? '';
    final suffixResult = _parseSuffix(suffix);
    if (!suffixResult.isValid) {
      return ParsedChordToken(
        index: index,
        rawText: rawToken,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        error: suffixResult.errorCode,
        errorDetail: suffixResult.errorDetail,
      );
    }

    final parsedSuffix = suffixResult.suffix!;
    return ParsedChordToken(
      index: index,
      rawText: rawToken,
      measureIndex: measureIndex,
      positionInMeasure: positionInMeasure,
      chord: ParsedChord(
        sourceSymbol: rawToken,
        root: root,
        rootSemitone: rootSemitone,
        displayQuality: parsedSuffix.displayQuality,
        analysisFamily: parsedSuffix.analysisFamily,
        measureIndex: measureIndex,
        positionInMeasure: positionInMeasure,
        suffix: suffix,
        normalizedSuffix: parsedSuffix.normalizedSuffix,
        extension: parsedSuffix.extension,
        tensions: parsedSuffix.tensions,
        addedTones: parsedSuffix.addedTones,
        omittedTones: parsedSuffix.omittedTones,
        alterations: parsedSuffix.alterations,
        suspensions: parsedSuffix.suspensions,
        ignoredTokens: parsedSuffix.ignoredTokens,
        diagnostics: parsedSuffix.diagnostics,
        bass: bass,
        bassSemitone: bassSemitone,
      ),
    );
  }

  _ChordWithBass _splitBass(String token) {
    var lastSlash = -1;
    var parenthesisDepth = 0;

    for (var index = 0; index < token.length; index += 1) {
      final character = token[index];
      if (character == '(') {
        parenthesisDepth += 1;
        continue;
      }
      if (character == ')') {
        parenthesisDepth = math.max(0, parenthesisDepth - 1);
        continue;
      }
      if (character == '/' && parenthesisDepth == 0) {
        lastSlash = index;
      }
    }

    if (lastSlash <= 0 || lastSlash >= token.length - 1) {
      return _ChordWithBass(prefix: token);
    }

    final possibleBass = token.substring(lastSlash + 1).trim();
    if (!_potentialBassPattern.hasMatch(possibleBass)) {
      return _ChordWithBass(prefix: token);
    }

    return _ChordWithBass(
      prefix: token.substring(0, lastSlash),
      bass: possibleBass,
    );
  }

  _SuffixParseResult _parseSuffix(String suffix) {
    final normalizedSuffix = _normalizeInput(suffix);
    final extracted = _extractParentheticalSections(normalizedSuffix);
    final compact = _normalizeCompactSuffix(extracted.compact);
    final core = _parseCore(compact);
    if (core == null) {
      return _SuffixParseResult.invalid(
        errorCode: 'unsupported-suffix',
        errorDetail: compact.isEmpty ? normalizedSuffix : compact,
      );
    }

    final modifierScan = _scanInlineModifiers(core.remaining);
    final tensions = <String>[...core.tensions];
    final addedTones = <String>[...core.addedTones];
    final omittedTones = <String>[...core.omittedTones];
    final alterations = <String>[...core.alterations];
    final suspensions = <String>[...core.suspensions];
    final ignoredTokens = <String>[
      ...modifierScan.ignoredTokens,
      ...extracted.ignoredTokens,
    ];
    final diagnostics = <String>[...extracted.diagnostics];
    var displayQuality = core.displayQuality;
    var analysisFamily = core.analysisFamily;
    var extension = core.extension;

    for (final token in [...modifierScan.tokens, ...extracted.tokens]) {
      if (token == 'maj7') {
        extension = _maxExtension(extension, 7);
        if (analysisFamily == ChordFamily.minor) {
          displayQuality = ChordQuality.minorMajor7;
        } else {
          displayQuality = ChordQuality.major7;
          analysisFamily = ChordFamily.major;
        }
        continue;
      }

      if (token == '9' || token == '11' || token == '13') {
        _appendUnique(tensions, token);
        extension = _maxExtension(extension, int.parse(token));
        continue;
      }

      if (token.startsWith('add')) {
        _appendUnique(addedTones, token.substring(3));
        continue;
      }

      if (token.startsWith('omit')) {
        _appendUnique(omittedTones, token.substring(4));
        continue;
      }

      if (token == 'sus2') {
        _appendUnique(suspensions, '2');
        if (analysisFamily == ChordFamily.major) {
          displayQuality = ChordQuality.majorTriad;
        }
        continue;
      }

      if (token == 'sus4') {
        _appendUnique(suspensions, '4');
        if (analysisFamily == ChordFamily.dominant) {
          if (extension == 13) {
            displayQuality = ChordQuality.dominant13sus4;
          } else if (extension == 7) {
            displayQuality = ChordQuality.dominant7sus4;
          } else if (extension == null) {
            displayQuality = ChordQuality.majorTriad;
          }
        }
        continue;
      }

      if (token == 'alt') {
        analysisFamily = ChordFamily.dominant;
        extension = _maxExtension(extension, 7);
        _appendUnique(alterations, 'alt');
        displayQuality = ChordQuality.dominant7Alt;
        continue;
      }

      if (token == 'b9' ||
          token == '#9' ||
          token == 'b5' ||
          token == '#5' ||
          token == '#11' ||
          token == 'b13') {
        _appendUnique(tensions, token);
        _appendUnique(alterations, token);
        if (analysisFamily == ChordFamily.dominant) {
          extension = _maxExtension(extension, 7);
          if (token == '#11' || alterations.contains('#11')) {
            displayQuality = ChordQuality.dominant7Sharp11;
          } else if (displayQuality != ChordQuality.dominant13sus4) {
            displayQuality = ChordQuality.dominant7Alt;
          }
        }
        continue;
      }

      if (token == '6/9') {
        extension = _maxExtension(extension, 6);
        _appendUnique(tensions, '9');
        if (analysisFamily == ChordFamily.major) {
          displayQuality = ChordQuality.major69;
        } else if (analysisFamily == ChordFamily.minor) {
          displayQuality = ChordQuality.minor6;
        }
      }
    }

    return _SuffixParseResult.valid(
      _ParsedSuffix(
        displayQuality: displayQuality,
        analysisFamily: analysisFamily,
        extension: extension,
        tensions: tensions,
        addedTones: addedTones,
        omittedTones: omittedTones,
        alterations: alterations,
        suspensions: suspensions,
        ignoredTokens: ignoredTokens,
        diagnostics: diagnostics,
        normalizedSuffix: _buildNormalizedSuffix(
          displayQuality: displayQuality,
          analysisFamily: analysisFamily,
          extension: extension,
          tensions: tensions,
          addedTones: addedTones,
          omittedTones: omittedTones,
          alterations: alterations,
          suspensions: suspensions,
        ),
      ),
    );
  }

  _CoreParse? _parseCore(String compact) {
    if (compact.isEmpty) {
      return const _CoreParse(
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        remaining: '',
      );
    }

    final lower = compact.toLowerCase();

    _CoreParse build({
      required int consumedLength,
      required ChordQuality displayQuality,
      required ChordFamily analysisFamily,
      int? extension,
      List<String> tensions = const [],
      List<String> addedTones = const [],
      List<String> omittedTones = const [],
      List<String> alterations = const [],
      List<String> suspensions = const [],
    }) {
      return _CoreParse(
        displayQuality: displayQuality,
        analysisFamily: analysisFamily,
        extension: extension,
        tensions: tensions,
        addedTones: addedTones,
        omittedTones: omittedTones,
        alterations: alterations,
        suspensions: suspensions,
        remaining: compact.substring(consumedLength),
      );
    }

    if (lower.startsWith('mmaj13')) {
      return build(
        consumedLength: 6,
        displayQuality: ChordQuality.minorMajor7,
        analysisFamily: ChordFamily.minor,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('mmaj9')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.minorMajor7,
        analysisFamily: ChordFamily.minor,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('mmaj7')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.minorMajor7,
        analysisFamily: ChordFamily.minor,
        extension: 7,
      );
    }
    if (lower.startsWith('maj13')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('maj11')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('maj9')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('maj7')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.major7,
        analysisFamily: ChordFamily.major,
        extension: 7,
      );
    }
    if (lower.startsWith('13sus4')) {
      return build(
        consumedLength: 6,
        displayQuality: ChordQuality.dominant13sus4,
        analysisFamily: ChordFamily.dominant,
        extension: 13,
        tensions: const ['13'],
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('7sus4')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.dominant7sus4,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('7sus')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.dominant7sus4,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('sus4')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.dominant,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('sus2')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        suspensions: const ['2'],
      );
    }
    if (lower.startsWith('sus')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.dominant,
        suspensions: const ['4'],
      );
    }
    if (lower.startsWith('6/9')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.major69,
        analysisFamily: ChordFamily.major,
        extension: 6,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('69')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.major69,
        analysisFamily: ChordFamily.major,
        extension: 6,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('5')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        omittedTones: const ['3'],
      );
    }
    if (lower.startsWith('m7b5')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.halfDiminished7,
        analysisFamily: ChordFamily.halfDiminished,
        extension: 7,
      );
    }
    if (lower.startsWith('dim7')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.diminished7,
        analysisFamily: ChordFamily.diminished,
        extension: 7,
      );
    }
    if (lower.startsWith('dim')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.diminishedTriad,
        analysisFamily: ChordFamily.diminished,
      );
    }
    if (lower.startsWith('aug7')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.augmentedTriad,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        alterations: const ['#5'],
      );
    }
    if (lower.startsWith('+7')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.augmentedTriad,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        alterations: const ['#5'],
      );
    }
    if (lower.startsWith('aug')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.augmentedTriad,
        analysisFamily: ChordFamily.augmented,
      );
    }
    if (lower.startsWith('+')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.augmentedTriad,
        analysisFamily: ChordFamily.augmented,
      );
    }
    if (lower.startsWith('m11')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.minor7,
        analysisFamily: ChordFamily.minor,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('m9')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.minor7,
        analysisFamily: ChordFamily.minor,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('m7')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.minor7,
        analysisFamily: ChordFamily.minor,
        extension: 7,
      );
    }
    if (lower.startsWith('m6')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.minor6,
        analysisFamily: ChordFamily.minor,
        extension: 6,
      );
    }
    if (lower.startsWith('m')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.minorTriad,
        analysisFamily: ChordFamily.minor,
      );
    }
    if (lower.startsWith('7alt')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.dominant7Alt,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        alterations: const ['alt'],
      );
    }
    if (lower.startsWith('alt')) {
      return build(
        consumedLength: 3,
        displayQuality: ChordQuality.dominant7Alt,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
        alterations: const ['alt'],
      );
    }
    if (lower.startsWith('13')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.dominant7,
        analysisFamily: ChordFamily.dominant,
        extension: 13,
        tensions: const ['13'],
      );
    }
    if (lower.startsWith('11')) {
      return build(
        consumedLength: 2,
        displayQuality: ChordQuality.dominant7,
        analysisFamily: ChordFamily.dominant,
        extension: 11,
        tensions: const ['11'],
      );
    }
    if (lower.startsWith('9')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.dominant7,
        analysisFamily: ChordFamily.dominant,
        extension: 9,
        tensions: const ['9'],
      );
    }
    if (lower.startsWith('7')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.dominant7,
        analysisFamily: ChordFamily.dominant,
        extension: 7,
      );
    }
    if (lower.startsWith('6')) {
      return build(
        consumedLength: 1,
        displayQuality: ChordQuality.six,
        analysisFamily: ChordFamily.major,
        extension: 6,
      );
    }
    if (lower.startsWith('add13')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        addedTones: const ['13'],
      );
    }
    if (lower.startsWith('add11')) {
      return build(
        consumedLength: 5,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        addedTones: const ['11'],
      );
    }
    if (lower.startsWith('add9')) {
      return build(
        consumedLength: 4,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
        addedTones: const ['9'],
      );
    }

    if (_recognizedModifierFor(compact) != null) {
      return build(
        consumedLength: 0,
        displayQuality: ChordQuality.majorTriad,
        analysisFamily: ChordFamily.major,
      );
    }

    return null;
  }

  _ModifierScan _scanInlineModifiers(String input) {
    final tokens = <String>[];
    final ignoredTokens = <String>[];
    var remaining = input;

    while (remaining.isNotEmpty) {
      final token = _recognizedModifierFor(remaining);
      if (token != null) {
        tokens.add(token);
        remaining = remaining.substring(_modifierTokenLength(token));
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
    for (final candidate in _orderedModifierTokens) {
      if (lower.startsWith(candidate.$1)) {
        return candidate.$2;
      }
    }
    return _dynamicModifierTokenFor(lower);
  }

  int _modifierTokenLength(String token) {
    for (final candidate in _orderedModifierTokens) {
      if (candidate.$2 == token) {
        return candidate.$1.length;
      }
    }
    return token.length;
  }

  String? _dynamicModifierTokenFor(String input) {
    final addMatch = RegExp(r'^add(\d+)').firstMatch(input);
    if (addMatch != null) {
      return 'add${addMatch.group(1)!}';
    }

    final omitMatch = RegExp(r'^omit(\d+)').firstMatch(input);
    if (omitMatch != null) {
      return 'omit${omitMatch.group(1)!}';
    }

    return null;
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
      final trailing = buffer.toString().trim();
      if (trailing.isNotEmpty) {
        ignoredTokens.add(trailing);
      }
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
    var normalized = _normalizeCompactSuffix(_normalizeInput(token));
    if (normalized.isEmpty) {
      return null;
    }
    normalized = normalized.toLowerCase();
    if (normalized == 'sus') {
      return 'sus4';
    }
    for (final candidate in _orderedModifierTokens) {
      if (candidate.$1 == normalized) {
        return candidate.$2;
      }
    }
    return _dynamicModifierTokenFor(normalized);
  }

  String _normalizeInput(String input) {
    return input
        .replaceAll('♭', 'b')
        .replaceAll('♯', '#')
        .replaceAll('＃', '#')
        .replaceAll('ｂ', 'b')
        .replaceAll('⁄', '/')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('△7', 'maj7')
        .replaceAll('Δ7', 'maj7')
        .replaceAll('△', 'maj7')
        .replaceAll('Δ', 'maj7')
        .replaceAll('Ø7', 'm7b5')
        .replaceAll('ø7', 'm7b5')
        .replaceAll('Ø', 'm7b5')
        .replaceAll('ø', 'm7b5')
        .replaceAll('°7', 'dim7')
        .replaceAll('°', 'dim')
        .trim();
  }

  String _normalizeCompactSuffix(String suffix) {
    var text = suffix.replaceAll(_compactWhitespacePattern, '').trim();
    if (text.isEmpty) {
      return '';
    }

    if (text.startsWith('M')) {
      final tail = text.substring(1);
      if (tail.isEmpty || _uppercaseMajorPrefixPattern.hasMatch(tail)) {
        text = 'maj$tail';
      }
    }

    final lower = text.toLowerCase();
    if (lower.startsWith('minmaj')) {
      text = 'mmaj${text.substring(6)}';
    } else if (lower.startsWith('min')) {
      text = 'm${text.substring(3)}';
    } else if (text.startsWith('-')) {
      text = 'm${text.substring(1)}';
    }

    if (text.toLowerCase() == 'sus') {
      return 'sus4';
    }
    if (text.toLowerCase() == '7sus') {
      return '7sus4';
    }
    return text;
  }

  String _normalizeNoteToken(String token) {
    final trimmed = _normalizeInput(token);
    if (trimmed.isEmpty) {
      return trimmed;
    }
    final letter = trimmed[0].toUpperCase();
    final accidental = trimmed.length > 1 ? trimmed.substring(1) : '';
    return '$letter$accidental';
  }

  String _buildNormalizedSuffix({
    required ChordQuality displayQuality,
    required ChordFamily analysisFamily,
    required int? extension,
    required List<String> tensions,
    required List<String> addedTones,
    required List<String> omittedTones,
    required List<String> alterations,
    required List<String> suspensions,
  }) {
    final consumedTensions = <String>[];
    final consumedAddedTones = <String>[];
    final consumedOmittedTones = <String>[];
    final consumedAlterations = <String>[];
    final consumedSuspensions = <String>[];

    String base = '';

    switch (displayQuality) {
      case ChordQuality.majorTriad:
        if (_matchesExact(omittedTones, const ['3']) &&
            addedTones.isEmpty &&
            suspensions.isEmpty &&
            alterations.isEmpty &&
            tensions.isEmpty) {
          base = '5';
          consumedOmittedTones.add('3');
        } else if (suspensions.contains('2')) {
          base = 'sus2';
          consumedSuspensions.add('2');
        } else if (suspensions.contains('4')) {
          base = 'sus4';
          consumedSuspensions.add('4');
        } else if (addedTones.isNotEmpty) {
          base = 'add${addedTones.first}';
          consumedAddedTones.add(addedTones.first);
        }
      case ChordQuality.major7:
        if (_matchesExact(tensions, const ['13']) && extension == 13) {
          base = 'maj13';
          consumedTensions.add('13');
        } else if (_matchesExact(tensions, const ['11']) && extension == 11) {
          base = 'maj11';
          consumedTensions.add('11');
        } else if (_matchesExact(tensions, const ['9']) && extension == 9) {
          base = 'maj9';
          consumedTensions.add('9');
        } else {
          base = 'maj7';
        }
      case ChordQuality.minorTriad:
        base = 'm';
      case ChordQuality.minor7:
        if (_matchesExact(tensions, const ['11']) && extension == 11) {
          base = 'm11';
          consumedTensions.add('11');
        } else if (_matchesExact(tensions, const ['9']) && extension == 9) {
          base = 'm9';
          consumedTensions.add('9');
        } else {
          base = 'm7';
        }
      case ChordQuality.minorMajor7:
        if (_matchesExact(tensions, const ['13']) && extension == 13) {
          base = 'mMaj13';
          consumedTensions.add('13');
        } else if (_matchesExact(tensions, const ['9']) && extension == 9) {
          base = 'mMaj9';
          consumedTensions.add('9');
        } else {
          base = 'mMaj7';
        }
      case ChordQuality.halfDiminished7:
        base = 'm7b5';
      case ChordQuality.diminishedTriad:
        base = 'dim';
      case ChordQuality.diminished7:
        base = 'dim7';
      case ChordQuality.augmentedTriad:
        if (extension == 7) {
          base = 'aug7';
          consumedAlterations.add('#5');
        } else {
          base = 'aug';
        }
      case ChordQuality.six:
        base = '6';
      case ChordQuality.minor6:
        base = 'm6';
      case ChordQuality.major69:
        base = '6/9';
        consumedTensions.add('9');
      case ChordQuality.dominant7:
        if (_matchesExact(tensions, const ['13']) && extension == 13) {
          base = '13';
          consumedTensions.add('13');
        } else if (_matchesExact(tensions, const ['11']) && extension == 11) {
          base = '11';
          consumedTensions.add('11');
        } else if (_matchesExact(tensions, const ['9']) && extension == 9) {
          base = '9';
          consumedTensions.add('9');
        } else if (extension == 13) {
          base = '13';
        } else if (extension == 11) {
          base = '11';
        } else if (extension == 9) {
          base = '9';
        } else {
          base = '7';
        }
      case ChordQuality.dominant7Alt:
        if (alterations.length == 1 &&
            alterations.single == 'alt' &&
            tensions.isEmpty) {
          base = '7alt';
          consumedAlterations.add('alt');
        } else {
          base = '7';
        }
      case ChordQuality.dominant7Sharp11:
        if (_matchesExact(tensions, const ['#11']) && extension == 7) {
          base = '7(#11)';
          consumedTensions.add('#11');
          consumedAlterations.add('#11');
        } else {
          base = '7';
        }
      case ChordQuality.dominant13sus4:
        base = '13sus4';
        consumedTensions.add('13');
        consumedSuspensions.add('4');
      case ChordQuality.dominant7sus4:
        base = '7sus4';
        consumedSuspensions.add('4');
    }

    final extraTokens = <String>[
      for (final tension in tensions)
        if (!consumedTensions.contains(tension)) tension,
      for (final tone in addedTones)
        if (!consumedAddedTones.contains(tone)) 'add$tone',
      for (final tone in omittedTones)
        if (!consumedOmittedTones.contains(tone)) 'omit$tone',
      for (final suspension in suspensions)
        if (!consumedSuspensions.contains(suspension)) 'sus$suspension',
      for (final alteration in alterations)
        if (!consumedAlterations.contains(alteration) &&
            !tensions.contains(alteration))
          alteration,
    ];

    if (base.isEmpty && extraTokens.isEmpty) {
      return analysisFamily == ChordFamily.minor ? 'm' : '';
    }
    if (base.isEmpty &&
        extraTokens.isNotEmpty &&
        extraTokens.every((token) => token.startsWith('omit'))) {
      return extraTokens.join();
    }
    if (extraTokens.isEmpty) {
      return base;
    }
    if (base.isEmpty) {
      return '(${extraTokens.join(',')})';
    }
    return '$base(${extraTokens.join(',')})';
  }

  bool _matchesExact(List<String> values, List<String> expected) {
    if (values.length != expected.length) {
      return false;
    }
    for (var index = 0; index < values.length; index += 1) {
      if (values[index] != expected[index]) {
        return false;
      }
    }
    return true;
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

class _SuffixParseResult {
  const _SuffixParseResult.valid(this.suffix)
    : isValid = true,
      errorCode = null,
      errorDetail = null;

  const _SuffixParseResult.invalid({required this.errorCode, this.errorDetail})
    : isValid = false,
      suffix = null;

  final bool isValid;
  final _ParsedSuffix? suffix;
  final String? errorCode;
  final String? errorDetail;
}

class _ParsedSuffix {
  const _ParsedSuffix({
    required this.displayQuality,
    required this.analysisFamily,
    required this.extension,
    required this.tensions,
    required this.addedTones,
    required this.omittedTones,
    required this.alterations,
    required this.suspensions,
    required this.ignoredTokens,
    required this.diagnostics,
    required this.normalizedSuffix,
  });

  final ChordQuality displayQuality;
  final ChordFamily analysisFamily;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> omittedTones;
  final List<String> alterations;
  final List<String> suspensions;
  final List<String> ignoredTokens;
  final List<String> diagnostics;
  final String normalizedSuffix;
}

class _CoreParse {
  const _CoreParse({
    required this.displayQuality,
    required this.analysisFamily,
    required this.remaining,
    this.extension,
    this.tensions = const [],
    this.addedTones = const [],
    this.omittedTones = const [],
    this.alterations = const [],
    this.suspensions = const [],
  });

  final ChordQuality displayQuality;
  final ChordFamily analysisFamily;
  final int? extension;
  final List<String> tensions;
  final List<String> addedTones;
  final List<String> omittedTones;
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
  ('sus', 'sus4'),
  ('maj7', 'maj7'),
  ('maj', 'maj'),
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
