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
    expect(AppLocalizationsEn().bpmTag(120), '120 BPM');
    expect(AppLocalizationsEs().bpmTag(120), '120 BPM');
    expect(AppLocalizationsJa().bpmTag(120), '120 BPM');
    expect(AppLocalizationsKo().bpmTag(120), '120 BPM');
    expect(AppLocalizationsZh().bpmTag(120), '120 BPM');
    expect(AppLocalizationsZhHans().bpmTag(120), '120 BPM');
  });

  test('critical Korean strings are translated for the main flows', () {
    final ko = AppLocalizationsKo();

    expect(
      ko.keysSelectedHelp,
      '\uC120\uD0DD\uD55C \uD0A4\uB294 \uD0A4 \uC778\uC2DD \uB79C\uB364 \uBAA8\uB4DC\uC640 Smart Generator \uBAA8\uB4DC\uC5D0\uC11C \uC0AC\uC6A9\uB429\uB2C8\uB2E4.',
    );
    expect(ko.mainMenuGeneratorTitle, '\uCF54\uB4DC \uC0DD\uC131\uAE30');
    expect(ko.openAnalyzer, '\uBD84\uC11D\uAE30 \uC5F4\uAE30');
    expect(ko.chordAnalyzerTitle, '\uCF54\uB4DC \uBD84\uC11D\uAE30');
    expect(ko.chordAnalyzerAnalyze, '\uBD84\uC11D\uD558\uAE30');
    expect(
      ko.chordAnalyzerSummaryCenter('\uC7A5\uC870 C'),
      '\uC774 \uC9C4\uD589\uC758 \uC911\uC2EC \uC870\uC131\uC740 \uC7A5\uC870 C\uC77C \uAC00\uB2A5\uC131\uC774 \uAC00\uC7A5 \uB192\uC2B5\uB2C8\uB2E4.',
    );
    expect(
      ko.pressNextChordToBegin,
      '\uC2DC\uC791\uD558\uB824\uBA74 \uB2E4\uC74C \uCF54\uB4DC\uB97C \uB204\uB974\uC138\uC694',
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
      final actualKeys = _readArb(
        fileName,
      ).keys.where((key) => key != '@@locale').toSet();
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
