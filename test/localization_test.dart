import 'package:flutter_test/flutter_test.dart';
import 'package:sightchord/l10n/app_localizations.dart';
import 'package:sightchord/l10n/app_localizations_en.dart';
import 'package:sightchord/l10n/app_localizations_es.dart';
import 'package:sightchord/l10n/app_localizations_ja.dart';
import 'package:sightchord/l10n/app_localizations_ko.dart';
import 'package:sightchord/l10n/app_localizations_zh.dart';
import 'package:sightchord/settings/practice_settings.dart';
void main() {
  test('allowed range renders both bounds across locales', () {
    expect(AppLocalizationsEn().allowedRange(20, 300), 'Allowed range: 20-300');
    expect(
      AppLocalizationsEs().allowedRange(20, 300),
      'Rango permitido: 20-300',
    );
    expect(AppLocalizationsJa().allowedRange(20, 300), '\u8a31\u5bb9\u7bc4\u56f2: 20-300');
    expect(AppLocalizationsKo().allowedRange(20, 300), '\ud5c8\uc6a9 \ubc94\uc704: 20-300');
    expect(AppLocalizationsZh().allowedRange(20, 300), '\u5141\u8a31\u7bc4\u570d\uff1a20-300');
    expect(AppLocalizationsZhHans().allowedRange(20, 300), '\u5141\u8bb8\u8303\u56f4\uff1a20-300');
  });
  test('app language locales stay aligned with generated localizations', () {
    final settingLocales = AppLanguage.values
        .where((language) => language.locale != null)
        .map((language) => language.locale!)
        .toSet();
    expect(settingLocales, AppLocalizations.supportedLocales.toSet());
  });
}
