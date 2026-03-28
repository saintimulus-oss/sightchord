import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum AppLanguage {
  system,
  en,
  es,
  zh,
  zhHans,
  ja,
  ko,
  af,
  sq,
  am,
  ar,
  hyAm,
  azAz,
  bnBd,
  euEs,
  be,
  bg,
  myMm,
  ca,
  zhHk,
  zhCn,
  zhTw,
  hr,
  csCz,
  daDk,
  nlNl,
  enAu,
  enCa,
  enUs,
  enGb,
  enIn,
  enSg,
  enZa,
  et,
  fil,
  fiFi,
  frCa,
  frFr,
  glEs,
  kaGe,
  deDe,
  elGr,
  gu,
  iwIl,
  hiIn,
  huHu,
  isIs,
  id,
  itIt,
  jaJp,
  knIn,
  kk,
  kmKh,
  koKr,
  kyKg,
  loLa,
  lv,
  lt,
  mkMk,
  msMy,
  ms,
  mlIn,
  mrIn,
  mnMn,
  neNp,
  noNo,
  fa,
  faAe,
  faAf,
  faIr,
  plPl,
  ptBr,
  ptPt,
  pa,
  ro,
  rm,
  ruRu,
  sr,
  siLk,
  sk,
  sl,
  es419,
  esEs,
  esUs,
  sw,
  svSe,
  taIn,
  teIn,
  th,
  trTr,
  uk,
  ur,
  vi,
}

final List<AppLanguage> supportedAppLanguages = List<AppLanguage>.unmodifiable(
  _appLanguageMetadata.entries
      .where((entry) => entry.value.locale != null)
      .map((entry) => entry.key),
);

final List<AppLanguage> selectableAppLanguages =
    List<AppLanguage>.unmodifiable(<AppLanguage>[
      AppLanguage.system,
      AppLanguage.af,
      AppLanguage.sq,
      AppLanguage.am,
      AppLanguage.ar,
      AppLanguage.hyAm,
      AppLanguage.azAz,
      AppLanguage.bnBd,
      AppLanguage.euEs,
      AppLanguage.be,
      AppLanguage.bg,
      AppLanguage.myMm,
      AppLanguage.ca,
      AppLanguage.zhHk,
      AppLanguage.zhCn,
      AppLanguage.zhTw,
      AppLanguage.hr,
      AppLanguage.csCz,
      AppLanguage.daDk,
      AppLanguage.nlNl,
      AppLanguage.enAu,
      AppLanguage.enCa,
      AppLanguage.enUs,
      AppLanguage.enGb,
      AppLanguage.enIn,
      AppLanguage.enSg,
      AppLanguage.enZa,
      AppLanguage.et,
      AppLanguage.fil,
      AppLanguage.fiFi,
      AppLanguage.frCa,
      AppLanguage.frFr,
      AppLanguage.glEs,
      AppLanguage.kaGe,
      AppLanguage.deDe,
      AppLanguage.elGr,
      AppLanguage.gu,
      AppLanguage.iwIl,
      AppLanguage.hiIn,
      AppLanguage.huHu,
      AppLanguage.isIs,
      AppLanguage.id,
      AppLanguage.itIt,
      AppLanguage.jaJp,
      AppLanguage.knIn,
      AppLanguage.kk,
      AppLanguage.kmKh,
      AppLanguage.koKr,
      AppLanguage.kyKg,
      AppLanguage.loLa,
      AppLanguage.lv,
      AppLanguage.lt,
      AppLanguage.mkMk,
      AppLanguage.msMy,
      AppLanguage.ms,
      AppLanguage.mlIn,
      AppLanguage.mrIn,
      AppLanguage.mnMn,
      AppLanguage.neNp,
      AppLanguage.noNo,
      AppLanguage.fa,
      AppLanguage.faAe,
      AppLanguage.faAf,
      AppLanguage.faIr,
      AppLanguage.plPl,
      AppLanguage.ptBr,
      AppLanguage.ptPt,
      AppLanguage.pa,
      AppLanguage.ro,
      AppLanguage.rm,
      AppLanguage.ruRu,
      AppLanguage.sr,
      AppLanguage.siLk,
      AppLanguage.sk,
      AppLanguage.sl,
      AppLanguage.es419,
      AppLanguage.esEs,
      AppLanguage.esUs,
      AppLanguage.sw,
      AppLanguage.svSe,
      AppLanguage.taIn,
      AppLanguage.teIn,
      AppLanguage.th,
      AppLanguage.trTr,
      AppLanguage.uk,
      AppLanguage.ur,
      AppLanguage.vi,
    ]);

final List<Locale> supportedAppLocales = List<Locale>.unmodifiable(
  AppLocalizations.supportedLocales,
);

class _AppLanguageMetadata {
  const _AppLanguageMetadata({
    required this.storageKey,
    required this.nativeLabel,
    this.locale,
    this.selectableFallback,
    this.aliases = const <String>[],
  });

  final String storageKey;
  final String nativeLabel;
  final Locale? locale;
  final AppLanguage? selectableFallback;
  final List<String> aliases;
}

const Map<AppLanguage, _AppLanguageMetadata> _appLanguageMetadata =
    <AppLanguage, _AppLanguageMetadata>{
      AppLanguage.system: _AppLanguageMetadata(
        storageKey: 'system',
        nativeLabel: 'System',
      ),
      AppLanguage.en: _AppLanguageMetadata(
        storageKey: 'en',
        nativeLabel: 'English',
        locale: Locale('en'),
        selectableFallback: AppLanguage.enUs,
      ),
      AppLanguage.es: _AppLanguageMetadata(
        storageKey: 'es',
        nativeLabel: 'Español',
        locale: Locale('es'),
        selectableFallback: AppLanguage.es419,
      ),
      AppLanguage.zh: _AppLanguageMetadata(
        storageKey: 'zh',
        nativeLabel: '繁體中文',
        locale: Locale('zh'),
        selectableFallback: AppLanguage.zhTw,
      ),
      AppLanguage.zhHans: _AppLanguageMetadata(
        storageKey: 'zh_Hans',
        nativeLabel: '简体中文',
        locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        selectableFallback: AppLanguage.zhCn,
        aliases: <String>['zh-Hans'],
      ),
      AppLanguage.ja: _AppLanguageMetadata(
        storageKey: 'ja',
        nativeLabel: '日本語',
        locale: Locale('ja'),
        selectableFallback: AppLanguage.jaJp,
      ),
      AppLanguage.ko: _AppLanguageMetadata(
        storageKey: 'ko',
        nativeLabel: '한국어',
        locale: Locale('ko'),
        selectableFallback: AppLanguage.koKr,
      ),
      AppLanguage.af: _AppLanguageMetadata(
        storageKey: 'af',
        nativeLabel: 'Afrikaans',
        locale: Locale('af'),
      ),
      AppLanguage.sq: _AppLanguageMetadata(
        storageKey: 'sq',
        nativeLabel: 'Shqip',
        locale: Locale('sq'),
      ),
      AppLanguage.am: _AppLanguageMetadata(
        storageKey: 'am',
        nativeLabel: 'አማርኛ',
        locale: Locale('am'),
      ),
      AppLanguage.ar: _AppLanguageMetadata(
        storageKey: 'ar',
        nativeLabel: 'العربية',
        locale: Locale('ar'),
      ),
      AppLanguage.hyAm: _AppLanguageMetadata(
        storageKey: 'hy-AM',
        nativeLabel: 'Հայերեն (Հայաստան)',
        locale: Locale('hy', 'AM'),
        aliases: <String>['hy_AM'],
      ),
      AppLanguage.azAz: _AppLanguageMetadata(
        storageKey: 'az-AZ',
        nativeLabel: 'Azərbaycan dili (Azərbaycan)',
        locale: Locale('az', 'AZ'),
        aliases: <String>['az_AZ'],
      ),
      AppLanguage.bnBd: _AppLanguageMetadata(
        storageKey: 'bn-BD',
        nativeLabel: 'বাংলা (বাংলাদেশ)',
        locale: Locale('bn', 'BD'),
        aliases: <String>['bn_BD'],
      ),
      AppLanguage.euEs: _AppLanguageMetadata(
        storageKey: 'eu-ES',
        nativeLabel: 'Euskara (Espainia)',
        locale: Locale('eu', 'ES'),
        aliases: <String>['eu_ES'],
      ),
      AppLanguage.be: _AppLanguageMetadata(
        storageKey: 'be',
        nativeLabel: 'Беларуская',
        locale: Locale('be'),
      ),
      AppLanguage.bg: _AppLanguageMetadata(
        storageKey: 'bg',
        nativeLabel: 'Български',
        locale: Locale('bg'),
      ),
      AppLanguage.myMm: _AppLanguageMetadata(
        storageKey: 'my-MM',
        nativeLabel: 'မြန်မာ (မြန်မာ)',
        locale: Locale('my', 'MM'),
        aliases: <String>['my_MM'],
      ),
      AppLanguage.ca: _AppLanguageMetadata(
        storageKey: 'ca',
        nativeLabel: 'Català',
        locale: Locale('ca'),
      ),
      AppLanguage.zhHk: _AppLanguageMetadata(
        storageKey: 'zh-HK',
        nativeLabel: '繁體中文（香港）',
        locale: Locale('zh', 'HK'),
        aliases: <String>['zh_HK'],
      ),
      AppLanguage.zhCn: _AppLanguageMetadata(
        storageKey: 'zh-CN',
        nativeLabel: '简体中文（中国）',
        locale: Locale('zh', 'CN'),
        aliases: <String>['zh_CN'],
      ),
      AppLanguage.zhTw: _AppLanguageMetadata(
        storageKey: 'zh-TW',
        nativeLabel: '繁體中文（台灣）',
        locale: Locale('zh', 'TW'),
        aliases: <String>['zh_TW'],
      ),
      AppLanguage.hr: _AppLanguageMetadata(
        storageKey: 'hr',
        nativeLabel: 'Hrvatski',
        locale: Locale('hr'),
      ),
      AppLanguage.csCz: _AppLanguageMetadata(
        storageKey: 'cs-CZ',
        nativeLabel: 'Čeština (Česko)',
        locale: Locale('cs', 'CZ'),
        aliases: <String>['cs_CZ'],
      ),
      AppLanguage.daDk: _AppLanguageMetadata(
        storageKey: 'da-DK',
        nativeLabel: 'Dansk (Danmark)',
        locale: Locale('da', 'DK'),
        aliases: <String>['da_DK'],
      ),
      AppLanguage.nlNl: _AppLanguageMetadata(
        storageKey: 'nl-NL',
        nativeLabel: 'Nederlands (Nederland)',
        locale: Locale('nl', 'NL'),
        aliases: <String>['nl_NL'],
      ),
      AppLanguage.enAu: _AppLanguageMetadata(
        storageKey: 'en-AU',
        nativeLabel: 'English (Australia)',
        locale: Locale('en', 'AU'),
        aliases: <String>['en_AU'],
      ),
      AppLanguage.enCa: _AppLanguageMetadata(
        storageKey: 'en-CA',
        nativeLabel: 'English (Canada)',
        locale: Locale('en', 'CA'),
        aliases: <String>['en_CA'],
      ),
      AppLanguage.enUs: _AppLanguageMetadata(
        storageKey: 'en-US',
        nativeLabel: 'English (United States)',
        locale: Locale('en', 'US'),
        aliases: <String>['en_US'],
      ),
      AppLanguage.enGb: _AppLanguageMetadata(
        storageKey: 'en-GB',
        nativeLabel: 'English (United Kingdom)',
        locale: Locale('en', 'GB'),
        aliases: <String>['en_GB'],
      ),
      AppLanguage.enIn: _AppLanguageMetadata(
        storageKey: 'en-IN',
        nativeLabel: 'English (India)',
        locale: Locale('en', 'IN'),
        aliases: <String>['en_IN'],
      ),
      AppLanguage.enSg: _AppLanguageMetadata(
        storageKey: 'en-SG',
        nativeLabel: 'English (Singapore)',
        locale: Locale('en', 'SG'),
        aliases: <String>['en_SG'],
      ),
      AppLanguage.enZa: _AppLanguageMetadata(
        storageKey: 'en-ZA',
        nativeLabel: 'English (South Africa)',
        locale: Locale('en', 'ZA'),
        aliases: <String>['en_ZA'],
      ),
      AppLanguage.et: _AppLanguageMetadata(
        storageKey: 'et',
        nativeLabel: 'Eesti',
        locale: Locale('et'),
      ),
      AppLanguage.fil: _AppLanguageMetadata(
        storageKey: 'fil',
        nativeLabel: 'Filipino',
        locale: Locale('fil'),
      ),
      AppLanguage.fiFi: _AppLanguageMetadata(
        storageKey: 'fi-FI',
        nativeLabel: 'Suomi (Suomi)',
        locale: Locale('fi', 'FI'),
        aliases: <String>['fi_FI'],
      ),
      AppLanguage.frCa: _AppLanguageMetadata(
        storageKey: 'fr-CA',
        nativeLabel: 'Français (Canada)',
        locale: Locale('fr', 'CA'),
        aliases: <String>['fr_CA'],
      ),
      AppLanguage.frFr: _AppLanguageMetadata(
        storageKey: 'fr-FR',
        nativeLabel: 'Français (France)',
        locale: Locale('fr', 'FR'),
        aliases: <String>['fr_FR'],
      ),
      AppLanguage.glEs: _AppLanguageMetadata(
        storageKey: 'gl-ES',
        nativeLabel: 'Galego (España)',
        locale: Locale('gl', 'ES'),
        aliases: <String>['gl_ES'],
      ),
      AppLanguage.kaGe: _AppLanguageMetadata(
        storageKey: 'ka-GE',
        nativeLabel: 'ქართული (საქართველო)',
        locale: Locale('ka', 'GE'),
        aliases: <String>['ka_GE'],
      ),
      AppLanguage.deDe: _AppLanguageMetadata(
        storageKey: 'de-DE',
        nativeLabel: 'Deutsch (Deutschland)',
        locale: Locale('de', 'DE'),
        aliases: <String>['de_DE'],
      ),
      AppLanguage.elGr: _AppLanguageMetadata(
        storageKey: 'el-GR',
        nativeLabel: 'Ελληνικά (Ελλάδα)',
        locale: Locale('el', 'GR'),
        aliases: <String>['el_GR'],
      ),
      AppLanguage.gu: _AppLanguageMetadata(
        storageKey: 'gu',
        nativeLabel: 'ગુજરાતી',
        locale: Locale('gu'),
      ),
      AppLanguage.iwIl: _AppLanguageMetadata(
        storageKey: 'iw-IL',
        nativeLabel: 'עברית (ישראל)',
        locale: Locale('he', 'IL'),
        aliases: <String>['iw_IL', 'he-IL', 'he_IL'],
      ),
      AppLanguage.hiIn: _AppLanguageMetadata(
        storageKey: 'hi-IN',
        nativeLabel: 'हिन्दी (भारत)',
        locale: Locale('hi', 'IN'),
        aliases: <String>['hi_IN'],
      ),
      AppLanguage.huHu: _AppLanguageMetadata(
        storageKey: 'hu-HU',
        nativeLabel: 'Magyar (Magyarország)',
        locale: Locale('hu', 'HU'),
        aliases: <String>['hu_HU'],
      ),
      AppLanguage.isIs: _AppLanguageMetadata(
        storageKey: 'is-IS',
        nativeLabel: 'Íslenska (Ísland)',
        locale: Locale('is', 'IS'),
        aliases: <String>['is_IS'],
      ),
      AppLanguage.id: _AppLanguageMetadata(
        storageKey: 'id',
        nativeLabel: 'Indonesia',
        locale: Locale('id'),
      ),
      AppLanguage.itIt: _AppLanguageMetadata(
        storageKey: 'it-IT',
        nativeLabel: 'Italiano (Italia)',
        locale: Locale('it', 'IT'),
        aliases: <String>['it_IT'],
      ),
      AppLanguage.jaJp: _AppLanguageMetadata(
        storageKey: 'ja-JP',
        nativeLabel: '日本語（日本）',
        locale: Locale('ja', 'JP'),
        aliases: <String>['ja_JP'],
      ),
      AppLanguage.knIn: _AppLanguageMetadata(
        storageKey: 'kn-IN',
        nativeLabel: 'ಕನ್ನಡ (ಭಾರತ)',
        locale: Locale('kn', 'IN'),
        aliases: <String>['kn_IN'],
      ),
      AppLanguage.kk: _AppLanguageMetadata(
        storageKey: 'kk',
        nativeLabel: 'Қазақ тілі',
        locale: Locale('kk'),
      ),
      AppLanguage.kmKh: _AppLanguageMetadata(
        storageKey: 'km-KH',
        nativeLabel: 'ខ្មែរ (កម្ពុជា)',
        locale: Locale('km', 'KH'),
        aliases: <String>['km_KH'],
      ),
      AppLanguage.koKr: _AppLanguageMetadata(
        storageKey: 'ko-KR',
        nativeLabel: '한국어 (대한민국)',
        locale: Locale('ko', 'KR'),
        aliases: <String>['ko_KR'],
      ),
      AppLanguage.kyKg: _AppLanguageMetadata(
        storageKey: 'ky-KG',
        nativeLabel: 'Кыргызча (Кыргызстан)',
        locale: Locale('ky', 'KG'),
        aliases: <String>['ky_KG'],
      ),
      AppLanguage.loLa: _AppLanguageMetadata(
        storageKey: 'lo-LA',
        nativeLabel: 'ລາວ (ລາວ)',
        locale: Locale('lo', 'LA'),
        aliases: <String>['lo_LA'],
      ),
      AppLanguage.lv: _AppLanguageMetadata(
        storageKey: 'lv',
        nativeLabel: 'Latviešu',
        locale: Locale('lv'),
      ),
      AppLanguage.lt: _AppLanguageMetadata(
        storageKey: 'lt',
        nativeLabel: 'Lietuvių',
        locale: Locale('lt'),
      ),
      AppLanguage.mkMk: _AppLanguageMetadata(
        storageKey: 'mk-MK',
        nativeLabel: 'Македонски (Северна Македонија)',
        locale: Locale('mk', 'MK'),
        aliases: <String>['mk_MK'],
      ),
      AppLanguage.msMy: _AppLanguageMetadata(
        storageKey: 'ms-MY',
        nativeLabel: 'Bahasa Melayu (Malaysia)',
        locale: Locale('ms', 'MY'),
        aliases: <String>['ms_MY'],
      ),
      AppLanguage.ms: _AppLanguageMetadata(
        storageKey: 'ms',
        nativeLabel: 'Bahasa Melayu',
        locale: Locale('ms'),
      ),
      AppLanguage.mlIn: _AppLanguageMetadata(
        storageKey: 'ml-IN',
        nativeLabel: 'മലയാളം (ഇന്ത്യ)',
        locale: Locale('ml', 'IN'),
        aliases: <String>['ml_IN'],
      ),
      AppLanguage.mrIn: _AppLanguageMetadata(
        storageKey: 'mr-IN',
        nativeLabel: 'मराठी (भारत)',
        locale: Locale('mr', 'IN'),
        aliases: <String>['mr_IN'],
      ),
      AppLanguage.mnMn: _AppLanguageMetadata(
        storageKey: 'mn-MN',
        nativeLabel: 'Монгол (Монгол)',
        locale: Locale('mn', 'MN'),
        aliases: <String>['mn_MN'],
      ),
      AppLanguage.neNp: _AppLanguageMetadata(
        storageKey: 'ne-NP',
        nativeLabel: 'नेपाली (नेपाल)',
        locale: Locale('ne', 'NP'),
        aliases: <String>['ne_NP'],
      ),
      AppLanguage.noNo: _AppLanguageMetadata(
        storageKey: 'no-NO',
        nativeLabel: 'Norsk (Norge)',
        locale: Locale('no', 'NO'),
        aliases: <String>['no_NO'],
      ),
      AppLanguage.fa: _AppLanguageMetadata(
        storageKey: 'fa',
        nativeLabel: 'فارسی',
        locale: Locale('fa'),
      ),
      AppLanguage.faAe: _AppLanguageMetadata(
        storageKey: 'fa-AE',
        nativeLabel: 'فارسی (امارات)',
        locale: Locale('fa', 'AE'),
        aliases: <String>['fa_AE'],
      ),
      AppLanguage.faAf: _AppLanguageMetadata(
        storageKey: 'fa-AF',
        nativeLabel: 'فارسی (افغانستان)',
        locale: Locale('fa', 'AF'),
        aliases: <String>['fa_AF'],
      ),
      AppLanguage.faIr: _AppLanguageMetadata(
        storageKey: 'fa-IR',
        nativeLabel: 'فارسی (ایران)',
        locale: Locale('fa', 'IR'),
        aliases: <String>['fa_IR'],
      ),
      AppLanguage.plPl: _AppLanguageMetadata(
        storageKey: 'pl-PL',
        nativeLabel: 'Polski (Polska)',
        locale: Locale('pl', 'PL'),
        aliases: <String>['pl_PL'],
      ),
      AppLanguage.ptBr: _AppLanguageMetadata(
        storageKey: 'pt-BR',
        nativeLabel: 'Português (Brasil)',
        locale: Locale('pt', 'BR'),
        aliases: <String>['pt_BR'],
      ),
      AppLanguage.ptPt: _AppLanguageMetadata(
        storageKey: 'pt-PT',
        nativeLabel: 'Português (Portugal)',
        locale: Locale('pt', 'PT'),
        aliases: <String>['pt_PT'],
      ),
      AppLanguage.pa: _AppLanguageMetadata(
        storageKey: 'pa',
        nativeLabel: 'ਪੰਜਾਬੀ',
        locale: Locale('pa'),
      ),
      AppLanguage.ro: _AppLanguageMetadata(
        storageKey: 'ro',
        nativeLabel: 'Română',
        locale: Locale('ro'),
      ),
      AppLanguage.rm: _AppLanguageMetadata(
        storageKey: 'rm',
        nativeLabel: 'Rumantsch',
        locale: Locale('rm'),
      ),
      AppLanguage.ruRu: _AppLanguageMetadata(
        storageKey: 'ru-RU',
        nativeLabel: 'Русский (Россия)',
        locale: Locale('ru', 'RU'),
        aliases: <String>['ru_RU'],
      ),
      AppLanguage.sr: _AppLanguageMetadata(
        storageKey: 'sr',
        nativeLabel: 'Српски',
        locale: Locale('sr'),
      ),
      AppLanguage.siLk: _AppLanguageMetadata(
        storageKey: 'si-LK',
        nativeLabel: 'සිංහල (ශ්‍රී ලංකා)',
        locale: Locale('si', 'LK'),
        aliases: <String>['si_LK'],
      ),
      AppLanguage.sk: _AppLanguageMetadata(
        storageKey: 'sk',
        nativeLabel: 'Slovenčina',
        locale: Locale('sk'),
      ),
      AppLanguage.sl: _AppLanguageMetadata(
        storageKey: 'sl',
        nativeLabel: 'Slovenščina',
        locale: Locale('sl'),
      ),
      AppLanguage.es419: _AppLanguageMetadata(
        storageKey: 'es-419',
        nativeLabel: 'Español (Latinoamérica)',
        locale: Locale.fromSubtags(languageCode: 'es', countryCode: '419'),
        aliases: <String>['es_419'],
      ),
      AppLanguage.esEs: _AppLanguageMetadata(
        storageKey: 'es-ES',
        nativeLabel: 'Español (España)',
        locale: Locale('es', 'ES'),
        aliases: <String>['es_ES'],
      ),
      AppLanguage.esUs: _AppLanguageMetadata(
        storageKey: 'es-US',
        nativeLabel: 'Español (Estados Unidos)',
        locale: Locale('es', 'US'),
        aliases: <String>['es_US'],
      ),
      AppLanguage.sw: _AppLanguageMetadata(
        storageKey: 'sw',
        nativeLabel: 'Kiswahili',
        locale: Locale('sw'),
      ),
      AppLanguage.svSe: _AppLanguageMetadata(
        storageKey: 'sv-SE',
        nativeLabel: 'Svenska (Sverige)',
        locale: Locale('sv', 'SE'),
        aliases: <String>['sv_SE'],
      ),
      AppLanguage.taIn: _AppLanguageMetadata(
        storageKey: 'ta-IN',
        nativeLabel: 'தமிழ் (இந்தியா)',
        locale: Locale('ta', 'IN'),
        aliases: <String>['ta_IN'],
      ),
      AppLanguage.teIn: _AppLanguageMetadata(
        storageKey: 'te-IN',
        nativeLabel: 'తెలుగు (భారతదేశం)',
        locale: Locale('te', 'IN'),
        aliases: <String>['te_IN'],
      ),
      AppLanguage.th: _AppLanguageMetadata(
        storageKey: 'th',
        nativeLabel: 'ไทย',
        locale: Locale('th'),
      ),
      AppLanguage.trTr: _AppLanguageMetadata(
        storageKey: 'tr-TR',
        nativeLabel: 'Türkçe (Türkiye)',
        locale: Locale('tr', 'TR'),
        aliases: <String>['tr_TR'],
      ),
      AppLanguage.uk: _AppLanguageMetadata(
        storageKey: 'uk',
        nativeLabel: 'Українська',
        locale: Locale('uk'),
      ),
      AppLanguage.ur: _AppLanguageMetadata(
        storageKey: 'ur',
        nativeLabel: 'اردو',
        locale: Locale('ur'),
      ),
      AppLanguage.vi: _AppLanguageMetadata(
        storageKey: 'vi',
        nativeLabel: 'Tiếng Việt',
        locale: Locale('vi'),
      ),
    };

final Map<String, AppLanguage> _languageByStorageKey = <String, AppLanguage>{
  for (final entry in _appLanguageMetadata.entries)
    _normalizeStorageKey(entry.value.storageKey): entry.key,
  for (final entry in _appLanguageMetadata.entries)
    for (final alias in entry.value.aliases)
      _normalizeStorageKey(alias): entry.key,
};

const Map<String, AppLanguage> _preferredSelectableLanguageByBaseKey =
    <String, AppLanguage>{'fr': AppLanguage.frFr, 'pt': AppLanguage.ptPt};

final Map<String, AppLanguage> _languageByLegacyBaseKey =
    _buildLanguageByLegacyBaseKey();

extension AppLanguageX on AppLanguage {
  _AppLanguageMetadata get _metadata => _appLanguageMetadata[this]!;

  Locale? get locale => _metadata.locale;

  String get storageKey => _metadata.storageKey;

  String get nativeLabel => _metadata.nativeLabel;

  bool get isSelectableInApp => selectableAppLanguages.contains(this);

  AppLanguage get selectableValue {
    if (isSelectableInApp) {
      return this;
    }
    return _metadata.selectableFallback ?? AppLanguage.system;
  }

  Locale? get appLocale {
    if (!supportedAppLanguages.contains(this)) {
      return null;
    }
    return locale;
  }

  static AppLanguage fromStorageKey(String? value) {
    if (value == null) {
      return AppLanguage.system;
    }
    final normalizedValue = _normalizeStorageKey(value);
    return _languageByStorageKey[normalizedValue] ??
        _languageByLegacyBaseKey[normalizedValue] ??
        AppLanguage.system;
  }
}

Map<String, AppLanguage> _buildLanguageByLegacyBaseKey() {
  final candidatesByBaseKey = <String, List<AppLanguage>>{};
  for (final entry in _appLanguageMetadata.entries) {
    final locale = entry.value.locale;
    if (locale == null || !selectableAppLanguages.contains(entry.key)) {
      continue;
    }
    final baseKey = _normalizeStorageKey(locale.languageCode);
    if (_languageByStorageKey.containsKey(baseKey)) {
      continue;
    }
    candidatesByBaseKey
        .putIfAbsent(baseKey, () => <AppLanguage>[])
        .add(entry.key);
  }

  final resolved = <String, AppLanguage>{};
  for (final entry in candidatesByBaseKey.entries) {
    final preferredLanguage = _preferredSelectableLanguageByBaseKey[entry.key];
    if (preferredLanguage != null) {
      resolved[entry.key] = preferredLanguage;
      continue;
    }
    if (entry.value.length == 1) {
      resolved[entry.key] = entry.value.single;
    }
  }
  return resolved;
}

String _normalizeStorageKey(String value) {
  return value.trim().replaceAll('_', '-').toLowerCase();
}
