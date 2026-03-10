import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/l10n/app_localizations.dart';
import 'package:sightchord/l10n/app_localizations_en.dart';
import 'package:sightchord/l10n/app_localizations_es.dart';
import 'package:sightchord/l10n/app_localizations_ja.dart';
import 'package:sightchord/l10n/app_localizations_ko.dart';
import 'package:sightchord/l10n/app_localizations_zh.dart';
import 'package:sightchord/settings/practice_settings.dart';

Map<String, dynamic> _readArb(String name) {
  final file = File('lib/l10n/$name');
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

void main() {
  test('allowed range renders both bounds across locales', () {
    expect(
      AppLocalizationsEn().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      'Allowed range: 20-300',
    );
    expect(
      AppLocalizationsEs().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      'Rango permitido: 20-300',
    );
    expect(
      AppLocalizationsJa().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      '\u8a31\u5bb9\u7bc4\u56f2: 20-300',
    );
    expect(
      AppLocalizationsKo().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      '\ud5c8\uc6a9 \ubc94\uc704: 20-300',
    );
    expect(
      AppLocalizationsZh().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      '\u5141\u8a31\u7bc4\u570d\uff1a20-300',
    );
    expect(
      AppLocalizationsZhHans().allowedRange(
        PracticeSettings.minBpm,
        PracticeSettings.maxBpm,
      ),
      '\u5141\u8bb8\u8303\u56f4\uff1a20-300',
    );
  });

  test('locale arb files stay aligned with the English template', () {
    final en = _readArb('app_en.arb');
    final expectedKeys = en.keys.where((key) => key != '@@locale').toSet();
    const localeFiles = [
      'app_es.arb',
      'app_ja.arb',
      'app_ko.arb',
      'app_zh.arb',
      'app_zh_Hans.arb',
    ];

    for (final fileName in localeFiles) {
      final actualKeys = _readArb(fileName)
          .keys
          .where((key) => key != '@@locale')
          .toSet();
      expect(actualKeys, expectedKeys, reason: '$fileName is out of sync');
    }
  });

  test('app language locales stay aligned with generated localizations', () {
    final settingLocales = AppLanguage.values
        .where((language) => language.locale != null)
        .map((language) => language.locale!)
        .toSet();
    expect(settingLocales, AppLocalizations.supportedLocales.toSet());
  });
}
