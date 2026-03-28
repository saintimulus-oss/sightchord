import 'dart:convert';
import 'dart:io';

import 'package:chordest/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Iterable<File> _arbFiles() sync* {
  final files =
      Directory('lib/l10n')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  yield* files;
}

Map<String, dynamic> _readArb(File file) {
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

Iterable<String> _allStrings(dynamic value) sync* {
  if (value is String) {
    yield value;
    return;
  }
  if (value is Map<Object?, Object?>) {
    for (final nested in value.values) {
      yield* _allStrings(nested);
    }
    return;
  }
  if (value is List<Object?>) {
    for (final nested in value) {
      yield* _allStrings(nested);
    }
  }
}

String _localeTag(Locale locale) {
  if ((locale.scriptCode ?? '').isNotEmpty) {
    return '${locale.languageCode}_${locale.scriptCode}';
  }
  if ((locale.countryCode ?? '').isNotEmpty) {
    return '${locale.languageCode}_${locale.countryCode}';
  }
  return locale.languageCode;
}

bool _containsReplacementCharacter(String value) {
  return value.contains('\uFFFD');
}

void main() {
  test(
    'all localization arb files decode cleanly and contain usable strings',
    () {
      for (final file in _arbFiles()) {
        final arb = _readArb(file);
        expect(
          arb['@@locale'],
          isA<String>().having(
            (value) => value.trim(),
            'trimmed locale',
            isNotEmpty,
          ),
          reason: '${file.path} is missing @@locale',
        );

        for (final entry in arb.entries) {
          if (entry.key.startsWith('@')) {
            continue;
          }
          expect(
            entry.value,
            isA<String>(),
            reason: '${file.path} -> ${entry.key} should be a string resource',
          );
          final value = entry.value as String;
          expect(
            value.trim(),
            isNotEmpty,
            reason: '${file.path} -> ${entry.key} is blank',
          );
          expect(
            _containsReplacementCharacter(value),
            isFalse,
            reason:
                '${file.path} -> ${entry.key} contains a replacement character',
          );
        }

        for (final value in _allStrings(arb)) {
          expect(
            _containsReplacementCharacter(value),
            isFalse,
            reason: '${file.path} contains a replacement character in metadata',
          );
        }
      }
    },
  );

  test('every generated supported locale loads with non-empty core labels', () {
    final arbByLocaleTag = <String, File>{
      for (final file in _arbFiles())
        _readArb(file)['@@locale'] as String: file,
    };

    for (final locale in AppLocalizations.supportedLocales) {
      final localizations = lookupAppLocalizations(locale);
      final tag = _localeTag(locale);

      expect(
        arbByLocaleTag.containsKey(tag),
        isTrue,
        reason: 'No ARB file found for supported locale $tag',
      );
      expect(
        localizations.settings.trim(),
        isNotEmpty,
        reason: '$tag settings is blank',
      );
      expect(
        localizations.language.trim(),
        isNotEmpty,
        reason: '$tag language is blank',
      );
      expect(
        localizations.systemDefaultLanguage.trim(),
        isNotEmpty,
        reason: '$tag systemDefaultLanguage is blank',
      );
      expect(
        localizations.currentChord.trim(),
        isNotEmpty,
        reason: '$tag currentChord is blank',
      );
      expect(
        _containsReplacementCharacter(localizations.settings),
        isFalse,
        reason: '$tag settings contains a replacement character',
      );
      expect(
        _containsReplacementCharacter(localizations.language),
        isFalse,
        reason: '$tag language contains a replacement character',
      );
      expect(
        _containsReplacementCharacter(localizations.systemDefaultLanguage),
        isFalse,
        reason: '$tag systemDefaultLanguage contains a replacement character',
      );
      expect(
        _containsReplacementCharacter(localizations.currentChord),
        isFalse,
        reason: '$tag currentChord contains a replacement character',
      );
    }
  });
}
