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
    expect(AppLocalizationsJa().allowedRange(20, 300), '許容範囲: 20-300');
    expect(AppLocalizationsKo().allowedRange(20, 300), '허용 범위: 20-300');
    expect(AppLocalizationsZh().allowedRange(20, 300), '允許範圍: 20-300');
    expect(AppLocalizationsZhHans().allowedRange(20, 300), '允许范围: 20-300');
  });

  test('app language locales stay aligned with generated localizations', () {
    final settingLocales = AppLanguage.values
        .where((language) => language.locale != null)
        .map((language) => language.locale!)
        .toSet();

    expect(settingLocales, AppLocalizations.supportedLocales.toSet());
  });
}
