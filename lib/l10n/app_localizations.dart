import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @closeSettings.
  ///
  /// In en, this message translates to:
  /// **'Close settings'**
  String get closeSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefaultLanguage;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @setupAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Assistant'**
  String get setupAssistantTitle;

  /// No description provided for @setupAssistantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few quick choices will make your first practice session feel calmer. You can rerun this anytime.'**
  String get setupAssistantSubtitle;

  /// No description provided for @setupAssistantCurrentMode.
  ///
  /// In en, this message translates to:
  /// **'Current setup'**
  String get setupAssistantCurrentMode;

  /// No description provided for @setupAssistantModeGuided.
  ///
  /// In en, this message translates to:
  /// **'Guided mode'**
  String get setupAssistantModeGuided;

  /// No description provided for @setupAssistantModeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard mode'**
  String get setupAssistantModeStandard;

  /// No description provided for @setupAssistantModeAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced mode'**
  String get setupAssistantModeAdvanced;

  /// No description provided for @setupAssistantRunAgain.
  ///
  /// In en, this message translates to:
  /// **'Run setup assistant again'**
  String get setupAssistantRunAgain;

  /// No description provided for @setupAssistantCardBody.
  ///
  /// In en, this message translates to:
  /// **'Use a gentler profile now, then open advanced controls whenever you want more room.'**
  String get setupAssistantCardBody;

  /// No description provided for @setupAssistantPreparingTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll start gently'**
  String get setupAssistantPreparingTitle;

  /// No description provided for @setupAssistantPreparingBody.
  ///
  /// In en, this message translates to:
  /// **'Before the generator shows any chords, we\'ll set up a comfortable starting point in a few taps.'**
  String get setupAssistantPreparingBody;

  /// No description provided for @setupAssistantProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String setupAssistantProgress(int current, int total);

  /// No description provided for @setupAssistantSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get setupAssistantSkip;

  /// No description provided for @setupAssistantBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get setupAssistantBack;

  /// No description provided for @setupAssistantNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get setupAssistantNext;

  /// No description provided for @setupAssistantApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get setupAssistantApply;

  /// No description provided for @setupAssistantGoalQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like this generator to help with first?'**
  String get setupAssistantGoalQuestionTitle;

  /// No description provided for @setupAssistantGoalQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'Pick the one that sounds closest. Nothing here is permanent.'**
  String get setupAssistantGoalQuestionBody;

  /// No description provided for @setupAssistantGoalEarTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear and recognize chords'**
  String get setupAssistantGoalEarTitle;

  /// No description provided for @setupAssistantGoalEarBody.
  ///
  /// In en, this message translates to:
  /// **'Short, friendly prompts for listening and recognition.'**
  String get setupAssistantGoalEarBody;

  /// No description provided for @setupAssistantGoalKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard hand practice'**
  String get setupAssistantGoalKeyboardTitle;

  /// No description provided for @setupAssistantGoalKeyboardBody.
  ///
  /// In en, this message translates to:
  /// **'Simple shapes and readable symbols for your hands first.'**
  String get setupAssistantGoalKeyboardBody;

  /// No description provided for @setupAssistantGoalSongTitle.
  ///
  /// In en, this message translates to:
  /// **'Song ideas'**
  String get setupAssistantGoalSongTitle;

  /// No description provided for @setupAssistantGoalSongBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the generator musical without dumping you into chaos.'**
  String get setupAssistantGoalSongBody;

  /// No description provided for @setupAssistantGoalHarmonyTitle.
  ///
  /// In en, this message translates to:
  /// **'Harmony study'**
  String get setupAssistantGoalHarmonyTitle;

  /// No description provided for @setupAssistantGoalHarmonyBody.
  ///
  /// In en, this message translates to:
  /// **'Start clear, then leave room to grow into deeper harmony.'**
  String get setupAssistantGoalHarmonyBody;

  /// No description provided for @setupAssistantLiteracyQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Which sentence feels closest right now?'**
  String get setupAssistantLiteracyQuestionTitle;

  /// No description provided for @setupAssistantLiteracyQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the most comfortable answer, not the most ambitious one.'**
  String get setupAssistantLiteracyQuestionBody;

  /// No description provided for @setupAssistantLiteracyAbsoluteTitle.
  ///
  /// In en, this message translates to:
  /// **'C, Cm, C7, and Cmaj7 still blur together'**
  String get setupAssistantLiteracyAbsoluteTitle;

  /// No description provided for @setupAssistantLiteracyAbsoluteBody.
  ///
  /// In en, this message translates to:
  /// **'Keep things extra readable and familiar.'**
  String get setupAssistantLiteracyAbsoluteBody;

  /// No description provided for @setupAssistantLiteracyBasicTitle.
  ///
  /// In en, this message translates to:
  /// **'I can read maj7 / m7 / 7'**
  String get setupAssistantLiteracyBasicTitle;

  /// No description provided for @setupAssistantLiteracyBasicBody.
  ///
  /// In en, this message translates to:
  /// **'Stay safe, but allow a little more range.'**
  String get setupAssistantLiteracyBasicBody;

  /// No description provided for @setupAssistantLiteracyFunctionalTitle.
  ///
  /// In en, this message translates to:
  /// **'I mostly follow ii-V-I and diatonic function'**
  String get setupAssistantLiteracyFunctionalTitle;

  /// No description provided for @setupAssistantLiteracyFunctionalBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the harmony clear with a bit more motion.'**
  String get setupAssistantLiteracyFunctionalBody;

  /// No description provided for @setupAssistantLiteracyAdvancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Colorful reharmonization and extensions already feel familiar'**
  String get setupAssistantLiteracyAdvancedTitle;

  /// No description provided for @setupAssistantLiteracyAdvancedBody.
  ///
  /// In en, this message translates to:
  /// **'Leave more of the power-user range available.'**
  String get setupAssistantLiteracyAdvancedBody;

  /// No description provided for @setupAssistantHandQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'How comfortable do your hands feel on keys?'**
  String get setupAssistantHandQuestionTitle;

  /// No description provided for @setupAssistantHandQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to keep voicings playable.'**
  String get setupAssistantHandQuestionBody;

  /// No description provided for @setupAssistantHandThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Three-note shapes feel best'**
  String get setupAssistantHandThreeTitle;

  /// No description provided for @setupAssistantHandThreeBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the hand shape compact.'**
  String get setupAssistantHandThreeBody;

  /// No description provided for @setupAssistantHandFourTitle.
  ///
  /// In en, this message translates to:
  /// **'Four notes are okay'**
  String get setupAssistantHandFourTitle;

  /// No description provided for @setupAssistantHandFourBody.
  ///
  /// In en, this message translates to:
  /// **'Allow a little more spread.'**
  String get setupAssistantHandFourBody;

  /// No description provided for @setupAssistantHandJazzTitle.
  ///
  /// In en, this message translates to:
  /// **'Jazzier shapes feel comfortable'**
  String get setupAssistantHandJazzTitle;

  /// No description provided for @setupAssistantHandJazzBody.
  ///
  /// In en, this message translates to:
  /// **'Open the door to larger voicings later.'**
  String get setupAssistantHandJazzBody;

  /// No description provided for @setupAssistantColorQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'How colorful should the sound feel at first?'**
  String get setupAssistantColorQuestionTitle;

  /// No description provided for @setupAssistantColorQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'When in doubt, start simpler.'**
  String get setupAssistantColorQuestionBody;

  /// No description provided for @setupAssistantColorSafeTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe and familiar'**
  String get setupAssistantColorSafeTitle;

  /// No description provided for @setupAssistantColorSafeBody.
  ///
  /// In en, this message translates to:
  /// **'Stay close to classic, readable harmony.'**
  String get setupAssistantColorSafeBody;

  /// No description provided for @setupAssistantColorJazzyTitle.
  ///
  /// In en, this message translates to:
  /// **'A little jazzy'**
  String get setupAssistantColorJazzyTitle;

  /// No description provided for @setupAssistantColorJazzyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a touch of color without getting wild.'**
  String get setupAssistantColorJazzyBody;

  /// No description provided for @setupAssistantColorColorfulTitle.
  ///
  /// In en, this message translates to:
  /// **'Quite colorful'**
  String get setupAssistantColorColorfulTitle;

  /// No description provided for @setupAssistantColorColorfulBody.
  ///
  /// In en, this message translates to:
  /// **'Leave more room for modern color.'**
  String get setupAssistantColorColorfulBody;

  /// No description provided for @setupAssistantSymbolQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Which chord spelling feels easiest to read?'**
  String get setupAssistantSymbolQuestionTitle;

  /// No description provided for @setupAssistantSymbolQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'This only changes how the chord is shown.'**
  String get setupAssistantSymbolQuestionBody;

  /// No description provided for @setupAssistantSymbolMajTextBody.
  ///
  /// In en, this message translates to:
  /// **'Clear and beginner-friendly.'**
  String get setupAssistantSymbolMajTextBody;

  /// No description provided for @setupAssistantSymbolCompactBody.
  ///
  /// In en, this message translates to:
  /// **'Shorter if you already like compact symbols.'**
  String get setupAssistantSymbolCompactBody;

  /// No description provided for @setupAssistantSymbolDeltaBody.
  ///
  /// In en, this message translates to:
  /// **'Jazz-style if that is what your eyes expect.'**
  String get setupAssistantSymbolDeltaBody;

  /// No description provided for @setupAssistantKeyQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Which key should we start in?'**
  String get setupAssistantKeyQuestionTitle;

  /// No description provided for @setupAssistantKeyQuestionBody.
  ///
  /// In en, this message translates to:
  /// **'C major is the easiest default, but you can change it later.'**
  String get setupAssistantKeyQuestionBody;

  /// No description provided for @setupAssistantKeyCMajorBody.
  ///
  /// In en, this message translates to:
  /// **'Best beginner starting point.'**
  String get setupAssistantKeyCMajorBody;

  /// No description provided for @setupAssistantKeyGMajorBody.
  ///
  /// In en, this message translates to:
  /// **'A bright major key with one sharp.'**
  String get setupAssistantKeyGMajorBody;

  /// No description provided for @setupAssistantKeyFMajorBody.
  ///
  /// In en, this message translates to:
  /// **'A warm major key with one flat.'**
  String get setupAssistantKeyFMajorBody;

  /// No description provided for @setupAssistantPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Try your first result'**
  String get setupAssistantPreviewTitle;

  /// No description provided for @setupAssistantPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'This is about what the generator will feel like. You can make it simpler or a little jazzier before you start.'**
  String get setupAssistantPreviewBody;

  /// No description provided for @setupAssistantPreviewListen.
  ///
  /// In en, this message translates to:
  /// **'Hear this sample'**
  String get setupAssistantPreviewListen;

  /// No description provided for @setupAssistantPreviewPlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing sample...'**
  String get setupAssistantPreviewPlaying;

  /// No description provided for @setupAssistantStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start with this'**
  String get setupAssistantStartNow;

  /// No description provided for @setupAssistantAdjustEasier.
  ///
  /// In en, this message translates to:
  /// **'Make it easier'**
  String get setupAssistantAdjustEasier;

  /// No description provided for @setupAssistantAdjustJazzier.
  ///
  /// In en, this message translates to:
  /// **'A little more jazzy'**
  String get setupAssistantAdjustJazzier;

  /// No description provided for @setupAssistantPreviewKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get setupAssistantPreviewKeyLabel;

  /// No description provided for @setupAssistantPreviewNotationLabel.
  ///
  /// In en, this message translates to:
  /// **'Notation'**
  String get setupAssistantPreviewNotationLabel;

  /// No description provided for @setupAssistantPreviewDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Feel'**
  String get setupAssistantPreviewDifficultyLabel;

  /// No description provided for @setupAssistantPreviewProgressionLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample progression'**
  String get setupAssistantPreviewProgressionLabel;

  /// No description provided for @setupAssistantPreviewProgressionBody.
  ///
  /// In en, this message translates to:
  /// **'A short four-chord sample built from your setup.'**
  String get setupAssistantPreviewProgressionBody;

  /// No description provided for @setupAssistantPreviewSummaryAbsolute.
  ///
  /// In en, this message translates to:
  /// **'Beginner-friendly start'**
  String get setupAssistantPreviewSummaryAbsolute;

  /// No description provided for @setupAssistantPreviewSummaryBasic.
  ///
  /// In en, this message translates to:
  /// **'Readable seventh-chord start'**
  String get setupAssistantPreviewSummaryBasic;

  /// No description provided for @setupAssistantPreviewSummaryFunctional.
  ///
  /// In en, this message translates to:
  /// **'Functional harmony start'**
  String get setupAssistantPreviewSummaryFunctional;

  /// No description provided for @setupAssistantPreviewSummaryAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Colorful jazz start'**
  String get setupAssistantPreviewSummaryAdvanced;

  /// No description provided for @setupAssistantPreviewBodyTriads.
  ///
  /// In en, this message translates to:
  /// **'Mostly familiar triads in a safe key, with compact voicings and no spicy surprises.'**
  String get setupAssistantPreviewBodyTriads;

  /// No description provided for @setupAssistantPreviewBodySevenths.
  ///
  /// In en, this message translates to:
  /// **'maj7, m7, and 7 show up clearly, while the progression still stays calm and readable.'**
  String get setupAssistantPreviewBodySevenths;

  /// No description provided for @setupAssistantPreviewBodySafeExtensions.
  ///
  /// In en, this message translates to:
  /// **'A little extra color can appear, but it stays within safe, familiar extensions.'**
  String get setupAssistantPreviewBodySafeExtensions;

  /// No description provided for @setupAssistantPreviewBodyFullExtensions.
  ///
  /// In en, this message translates to:
  /// **'The preview leaves more room for modern color, richer movement, and denser harmony.'**
  String get setupAssistantPreviewBodyFullExtensions;

  /// No description provided for @setupAssistantNotationMajText.
  ///
  /// In en, this message translates to:
  /// **'Cmaj7 style'**
  String get setupAssistantNotationMajText;

  /// No description provided for @setupAssistantNotationCompact.
  ///
  /// In en, this message translates to:
  /// **'CM7 style'**
  String get setupAssistantNotationCompact;

  /// No description provided for @setupAssistantNotationDelta.
  ///
  /// In en, this message translates to:
  /// **'CΔ7 style'**
  String get setupAssistantNotationDelta;

  /// No description provided for @setupAssistantDifficultyTriads.
  ///
  /// In en, this message translates to:
  /// **'Simple triads and core movement'**
  String get setupAssistantDifficultyTriads;

  /// No description provided for @setupAssistantDifficultySevenths.
  ///
  /// In en, this message translates to:
  /// **'maj7 / m7 / 7 centered'**
  String get setupAssistantDifficultySevenths;

  /// No description provided for @setupAssistantDifficultySafeExtensions.
  ///
  /// In en, this message translates to:
  /// **'Safe color with 9 / 11 / 13'**
  String get setupAssistantDifficultySafeExtensions;

  /// No description provided for @setupAssistantDifficultyFullExtensions.
  ///
  /// In en, this message translates to:
  /// **'Full color and wider motion'**
  String get setupAssistantDifficultyFullExtensions;

  /// No description provided for @setupAssistantStudyHarmonyTitle.
  ///
  /// In en, this message translates to:
  /// **'Want a gentler theory path too?'**
  String get setupAssistantStudyHarmonyTitle;

  /// No description provided for @setupAssistantStudyHarmonyBody.
  ///
  /// In en, this message translates to:
  /// **'Study Harmony can walk you through the basics while this generator stays in a safe lane.'**
  String get setupAssistantStudyHarmonyBody;

  /// No description provided for @setupAssistantStudyHarmonyCta.
  ///
  /// In en, this message translates to:
  /// **'Start Study Harmony'**
  String get setupAssistantStudyHarmonyCta;

  /// No description provided for @setupAssistantGuidedSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Beginner-friendly setup is on'**
  String get setupAssistantGuidedSettingsTitle;

  /// No description provided for @setupAssistantGuidedSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Core controls stay close by here. Everything else is still available when you want it.'**
  String get setupAssistantGuidedSettingsBody;

  /// No description provided for @setupAssistantAdvancedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'More controls'**
  String get setupAssistantAdvancedSectionTitle;

  /// No description provided for @setupAssistantAdvancedSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Open the full settings page if you want every generator option.'**
  String get setupAssistantAdvancedSectionBody;

  /// No description provided for @metronome.
  ///
  /// In en, this message translates to:
  /// **'Metronome'**
  String get metronome;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @metronomeHelp.
  ///
  /// In en, this message translates to:
  /// **'Turn the metronome on to hear a click on every beat while you practice.'**
  String get metronomeHelp;

  /// No description provided for @metronomeSound.
  ///
  /// In en, this message translates to:
  /// **'Metronome Sound'**
  String get metronomeSound;

  /// No description provided for @metronomeSoundClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get metronomeSoundClassic;

  /// No description provided for @metronomeSoundClickB.
  ///
  /// In en, this message translates to:
  /// **'Click B'**
  String get metronomeSoundClickB;

  /// No description provided for @metronomeSoundClickC.
  ///
  /// In en, this message translates to:
  /// **'Click C'**
  String get metronomeSoundClickC;

  /// No description provided for @metronomeSoundClickD.
  ///
  /// In en, this message translates to:
  /// **'Click D'**
  String get metronomeSoundClickD;

  /// No description provided for @metronomeSoundClickE.
  ///
  /// In en, this message translates to:
  /// **'Click E'**
  String get metronomeSoundClickE;

  /// No description provided for @metronomeSoundClickF.
  ///
  /// In en, this message translates to:
  /// **'Click F'**
  String get metronomeSoundClickF;

  /// No description provided for @metronomeVolume.
  ///
  /// In en, this message translates to:
  /// **'Metronome Volume'**
  String get metronomeVolume;

  /// No description provided for @practiceMeter.
  ///
  /// In en, this message translates to:
  /// **'Time Signature'**
  String get practiceMeter;

  /// No description provided for @practiceMeterHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how many beats are in each bar for transport and metronome timing.'**
  String get practiceMeterHelp;

  /// No description provided for @practiceTimeSignatureTwoFour.
  ///
  /// In en, this message translates to:
  /// **'2/4'**
  String get practiceTimeSignatureTwoFour;

  /// No description provided for @practiceTimeSignatureThreeFour.
  ///
  /// In en, this message translates to:
  /// **'3/4'**
  String get practiceTimeSignatureThreeFour;

  /// No description provided for @practiceTimeSignatureFourFour.
  ///
  /// In en, this message translates to:
  /// **'4/4'**
  String get practiceTimeSignatureFourFour;

  /// No description provided for @practiceTimeSignatureFiveFour.
  ///
  /// In en, this message translates to:
  /// **'5/4'**
  String get practiceTimeSignatureFiveFour;

  /// No description provided for @practiceTimeSignatureSixEight.
  ///
  /// In en, this message translates to:
  /// **'6/8'**
  String get practiceTimeSignatureSixEight;

  /// No description provided for @practiceTimeSignatureSevenEight.
  ///
  /// In en, this message translates to:
  /// **'7/8'**
  String get practiceTimeSignatureSevenEight;

  /// No description provided for @practiceTimeSignatureTwelveEight.
  ///
  /// In en, this message translates to:
  /// **'12/8'**
  String get practiceTimeSignatureTwelveEight;

  /// No description provided for @harmonicRhythm.
  ///
  /// In en, this message translates to:
  /// **'Harmonic Rhythm'**
  String get harmonicRhythm;

  /// No description provided for @harmonicRhythmHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how often chord changes can happen inside the bar.'**
  String get harmonicRhythmHelp;

  /// No description provided for @harmonicRhythmOnePerBar.
  ///
  /// In en, this message translates to:
  /// **'One per bar'**
  String get harmonicRhythmOnePerBar;

  /// No description provided for @harmonicRhythmTwoPerBar.
  ///
  /// In en, this message translates to:
  /// **'Two per bar'**
  String get harmonicRhythmTwoPerBar;

  /// No description provided for @harmonicRhythmPhraseAwareJazz.
  ///
  /// In en, this message translates to:
  /// **'Phrase-aware jazz'**
  String get harmonicRhythmPhraseAwareJazz;

  /// No description provided for @harmonicRhythmCadenceCompression.
  ///
  /// In en, this message translates to:
  /// **'Cadence compression'**
  String get harmonicRhythmCadenceCompression;

  /// No description provided for @keys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get keys;

  /// No description provided for @noKeysSelected.
  ///
  /// In en, this message translates to:
  /// **'No keys selected. Leave all keys off to practice in free mode across every root.'**
  String get noKeysSelected;

  /// No description provided for @keysSelectedHelp.
  ///
  /// In en, this message translates to:
  /// **'Selected keys are used for key-aware random mode and Smart Generator mode.'**
  String get keysSelectedHelp;

  /// No description provided for @smartGeneratorMode.
  ///
  /// In en, this message translates to:
  /// **'Smart Generator Mode'**
  String get smartGeneratorMode;

  /// No description provided for @smartGeneratorHelp.
  ///
  /// In en, this message translates to:
  /// **'Prioritizes functional harmonic motion while preserving the enabled non-diatonic options.'**
  String get smartGeneratorHelp;

  /// No description provided for @advancedSmartGenerator.
  ///
  /// In en, this message translates to:
  /// **'Advanced Smart Generator'**
  String get advancedSmartGenerator;

  /// No description provided for @modulationIntensity.
  ///
  /// In en, this message translates to:
  /// **'Modulation Intensity'**
  String get modulationIntensity;

  /// No description provided for @modulationIntensityOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get modulationIntensityOff;

  /// No description provided for @modulationIntensityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get modulationIntensityLow;

  /// No description provided for @modulationIntensityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get modulationIntensityMedium;

  /// No description provided for @modulationIntensityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get modulationIntensityHigh;

  /// No description provided for @jazzPreset.
  ///
  /// In en, this message translates to:
  /// **'Jazz Preset'**
  String get jazzPreset;

  /// No description provided for @jazzPresetStandardsCore.
  ///
  /// In en, this message translates to:
  /// **'Standards Core'**
  String get jazzPresetStandardsCore;

  /// No description provided for @jazzPresetModulationStudy.
  ///
  /// In en, this message translates to:
  /// **'Modulation Study'**
  String get jazzPresetModulationStudy;

  /// No description provided for @jazzPresetAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get jazzPresetAdvanced;

  /// No description provided for @sourceProfile.
  ///
  /// In en, this message translates to:
  /// **'Source Profile'**
  String get sourceProfile;

  /// No description provided for @sourceProfileFakebookStandard.
  ///
  /// In en, this message translates to:
  /// **'Fakebook Standard'**
  String get sourceProfileFakebookStandard;

  /// No description provided for @sourceProfileRecordingInspired.
  ///
  /// In en, this message translates to:
  /// **'Recording Inspired'**
  String get sourceProfileRecordingInspired;

  /// No description provided for @smartDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Smart Diagnostics'**
  String get smartDiagnostics;

  /// No description provided for @smartDiagnosticsHelp.
  ///
  /// In en, this message translates to:
  /// **'Logs Smart Generator decision traces for debugging.'**
  String get smartDiagnosticsHelp;

  /// No description provided for @keyModeRequiredForSmartGenerator.
  ///
  /// In en, this message translates to:
  /// **'Select at least one key to use Smart Generator mode.'**
  String get keyModeRequiredForSmartGenerator;

  /// No description provided for @nonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'Non-Diatonic'**
  String get nonDiatonic;

  /// No description provided for @nonDiatonicRequiresKeyMode.
  ///
  /// In en, this message translates to:
  /// **'Non-diatonic options are available in key mode only.'**
  String get nonDiatonicRequiresKeyMode;

  /// No description provided for @secondaryDominant.
  ///
  /// In en, this message translates to:
  /// **'Secondary Dominant'**
  String get secondaryDominant;

  /// No description provided for @substituteDominant.
  ///
  /// In en, this message translates to:
  /// **'Substitute Dominant'**
  String get substituteDominant;

  /// No description provided for @modalInterchange.
  ///
  /// In en, this message translates to:
  /// **'Modal Interchange'**
  String get modalInterchange;

  /// No description provided for @modalInterchangeDisabledHelp.
  ///
  /// In en, this message translates to:
  /// **'Modal interchange only appears in key mode, so this option is disabled in free mode.'**
  String get modalInterchangeDisabledHelp;

  /// No description provided for @rendering.
  ///
  /// In en, this message translates to:
  /// **'Rendering'**
  String get rendering;

  /// No description provided for @keyCenterLabelStyle.
  ///
  /// In en, this message translates to:
  /// **'Key Label Style'**
  String get keyCenterLabelStyle;

  /// No description provided for @keyCenterLabelStyleHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose between explicit mode names and classical uppercase/lowercase tonic labels.'**
  String get keyCenterLabelStyleHelp;

  /// No description provided for @chordSymbolStyle.
  ///
  /// In en, this message translates to:
  /// **'Chord Symbol Style'**
  String get chordSymbolStyle;

  /// No description provided for @chordSymbolStyleHelp.
  ///
  /// In en, this message translates to:
  /// **'Changes the display layer only. Harmonic logic stays canonical.'**
  String get chordSymbolStyleHelp;

  /// No description provided for @styleCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get styleCompact;

  /// No description provided for @styleMajText.
  ///
  /// In en, this message translates to:
  /// **'MajText'**
  String get styleMajText;

  /// No description provided for @styleDeltaJazz.
  ///
  /// In en, this message translates to:
  /// **'DeltaJazz'**
  String get styleDeltaJazz;

  /// No description provided for @keyCenterLabelStyleModeText.
  ///
  /// In en, this message translates to:
  /// **'C major: / C minor:'**
  String get keyCenterLabelStyleModeText;

  /// No description provided for @keyCenterLabelStyleClassicalCase.
  ///
  /// In en, this message translates to:
  /// **'C: / c:'**
  String get keyCenterLabelStyleClassicalCase;

  /// No description provided for @allowV7sus4.
  ///
  /// In en, this message translates to:
  /// **'Allow V7sus4 (V7, V7/x)'**
  String get allowV7sus4;

  /// No description provided for @allowTensions.
  ///
  /// In en, this message translates to:
  /// **'Allow Tensions'**
  String get allowTensions;

  /// No description provided for @chordTypeFilters.
  ///
  /// In en, this message translates to:
  /// **'Chord Types'**
  String get chordTypeFilters;

  /// No description provided for @chordTypeFiltersHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose which chord types can appear in the generator.'**
  String get chordTypeFiltersHelp;

  /// No description provided for @chordTypeFiltersSelection.
  ///
  /// In en, this message translates to:
  /// **'{selected} / {total} enabled'**
  String chordTypeFiltersSelection(int selected, int total);

  /// No description provided for @chordTypeGroupTriads.
  ///
  /// In en, this message translates to:
  /// **'Triads'**
  String get chordTypeGroupTriads;

  /// No description provided for @chordTypeGroupSevenths.
  ///
  /// In en, this message translates to:
  /// **'Sevenths'**
  String get chordTypeGroupSevenths;

  /// No description provided for @chordTypeGroupSixthsAndAddedTone.
  ///
  /// In en, this message translates to:
  /// **'Sixths & Added Tone'**
  String get chordTypeGroupSixthsAndAddedTone;

  /// No description provided for @chordTypeGroupDominantVariants.
  ///
  /// In en, this message translates to:
  /// **'Dominant Variants'**
  String get chordTypeGroupDominantVariants;

  /// No description provided for @chordTypeRequiresKeyMode.
  ///
  /// In en, this message translates to:
  /// **'V7sus4 is available only when at least one key is selected.'**
  String get chordTypeRequiresKeyMode;

  /// No description provided for @chordTypeKeepOneEnabled.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one chord type enabled.'**
  String get chordTypeKeepOneEnabled;

  /// No description provided for @tensionHelp.
  ///
  /// In en, this message translates to:
  /// **'Roman numeral profile and selected chips only'**
  String get tensionHelp;

  /// No description provided for @inversions.
  ///
  /// In en, this message translates to:
  /// **'Inversions'**
  String get inversions;

  /// No description provided for @enableInversions.
  ///
  /// In en, this message translates to:
  /// **'Enable Inversions'**
  String get enableInversions;

  /// No description provided for @inversionHelp.
  ///
  /// In en, this message translates to:
  /// **'Random slash-bass rendering after chord selection; it does not track the previous bass.'**
  String get inversionHelp;

  /// No description provided for @firstInversion.
  ///
  /// In en, this message translates to:
  /// **'1st Inversion'**
  String get firstInversion;

  /// No description provided for @secondInversion.
  ///
  /// In en, this message translates to:
  /// **'2nd Inversion'**
  String get secondInversion;

  /// No description provided for @thirdInversion.
  ///
  /// In en, this message translates to:
  /// **'3rd Inversion'**
  String get thirdInversion;

  /// No description provided for @keyPracticeOverview.
  ///
  /// In en, this message translates to:
  /// **'Key Practice Overview'**
  String get keyPracticeOverview;

  /// No description provided for @freePracticeOverview.
  ///
  /// In en, this message translates to:
  /// **'Free Practice Overview'**
  String get freePracticeOverview;

  /// No description provided for @keyModeTag.
  ///
  /// In en, this message translates to:
  /// **'Key Mode'**
  String get keyModeTag;

  /// No description provided for @freeModeTag.
  ///
  /// In en, this message translates to:
  /// **'Free Mode'**
  String get freeModeTag;

  /// No description provided for @allKeysTag.
  ///
  /// In en, this message translates to:
  /// **'All Keys'**
  String get allKeysTag;

  /// No description provided for @metronomeOnTag.
  ///
  /// In en, this message translates to:
  /// **'Metronome On'**
  String get metronomeOnTag;

  /// No description provided for @metronomeOffTag.
  ///
  /// In en, this message translates to:
  /// **'Metronome Off'**
  String get metronomeOffTag;

  /// No description provided for @pressNextChordToBegin.
  ///
  /// In en, this message translates to:
  /// **'Press Next Chord to begin'**
  String get pressNextChordToBegin;

  /// No description provided for @freeModeActive.
  ///
  /// In en, this message translates to:
  /// **'Free mode active'**
  String get freeModeActive;

  /// No description provided for @freePracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'Uses all 12 chromatic roots with random chord qualities for broad reading practice.'**
  String get freePracticeDescription;

  /// No description provided for @smartPracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'Follows harmonic function flow in the selected keys while allowing tasteful smart-generator movement.'**
  String get smartPracticeDescription;

  /// No description provided for @keyPracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'Uses the selected keys and enabled Roman numerals to generate diatonic practice material.'**
  String get keyPracticeDescription;

  /// No description provided for @keyboardShortcutHelp.
  ///
  /// In en, this message translates to:
  /// **'Space: next chord  Enter: start or pause autoplay  Up/Down: adjust BPM'**
  String get keyboardShortcutHelp;

  /// No description provided for @nextChord.
  ///
  /// In en, this message translates to:
  /// **'Next Chord'**
  String get nextChord;

  /// No description provided for @audioPlayChord.
  ///
  /// In en, this message translates to:
  /// **'Play Chord'**
  String get audioPlayChord;

  /// No description provided for @audioPlayArpeggio.
  ///
  /// In en, this message translates to:
  /// **'Play Arpeggio'**
  String get audioPlayArpeggio;

  /// No description provided for @audioPlayProgression.
  ///
  /// In en, this message translates to:
  /// **'Play Progression'**
  String get audioPlayProgression;

  /// No description provided for @audioPlayPrompt.
  ///
  /// In en, this message translates to:
  /// **'Play Prompt'**
  String get audioPlayPrompt;

  /// No description provided for @startAutoplay.
  ///
  /// In en, this message translates to:
  /// **'Start Autoplay'**
  String get startAutoplay;

  /// No description provided for @pauseAutoplay.
  ///
  /// In en, this message translates to:
  /// **'Pause Autoplay'**
  String get pauseAutoplay;

  /// No description provided for @stopAutoplay.
  ///
  /// In en, this message translates to:
  /// **'Stop Autoplay'**
  String get stopAutoplay;

  /// No description provided for @resetGeneratedChords.
  ///
  /// In en, this message translates to:
  /// **'Reset Generated Chords'**
  String get resetGeneratedChords;

  /// No description provided for @decreaseBpm.
  ///
  /// In en, this message translates to:
  /// **'Decrease BPM'**
  String get decreaseBpm;

  /// No description provided for @increaseBpm.
  ///
  /// In en, this message translates to:
  /// **'Increase BPM'**
  String get increaseBpm;

  /// No description provided for @bpmLabel.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpmLabel;

  /// No description provided for @bpmTag.
  ///
  /// In en, this message translates to:
  /// **'{value} BPM'**
  String bpmTag(int value);

  /// No description provided for @allowedRange.
  ///
  /// In en, this message translates to:
  /// **'Allowed range: {min}-{max}'**
  String allowedRange(int min, int max);

  /// No description provided for @modeMajor.
  ///
  /// In en, this message translates to:
  /// **'major'**
  String get modeMajor;

  /// No description provided for @modeMinor.
  ///
  /// In en, this message translates to:
  /// **'minor'**
  String get modeMinor;

  /// No description provided for @analysisLabelWithCenter.
  ///
  /// In en, this message translates to:
  /// **'{center}: {roman}'**
  String analysisLabelWithCenter(Object center, Object roman);

  /// No description provided for @voicingSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Voicing Suggestions'**
  String get voicingSuggestionsTitle;

  /// No description provided for @voicingSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See concrete note choices for this chord.'**
  String get voicingSuggestionsSubtitle;

  /// No description provided for @voicingSuggestionsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable Voicing Suggestions'**
  String get voicingSuggestionsEnabled;

  /// No description provided for @voicingSuggestionsHelp.
  ///
  /// In en, this message translates to:
  /// **'Shows three playable note-level voicing ideas for the current chord.'**
  String get voicingSuggestionsHelp;

  /// No description provided for @voicingDisplayMode.
  ///
  /// In en, this message translates to:
  /// **'Voicing Display Mode'**
  String get voicingDisplayMode;

  /// No description provided for @voicingDisplayModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Switch between the standard three-card view and a performance-focused current/next preview.'**
  String get voicingDisplayModeHelp;

  /// No description provided for @voicingDisplayModeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get voicingDisplayModeStandard;

  /// No description provided for @voicingDisplayModePerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get voicingDisplayModePerformance;

  /// No description provided for @voicingComplexity.
  ///
  /// In en, this message translates to:
  /// **'Voicing Complexity'**
  String get voicingComplexity;

  /// No description provided for @voicingComplexityHelp.
  ///
  /// In en, this message translates to:
  /// **'Controls how colorful the suggestions may become.'**
  String get voicingComplexityHelp;

  /// No description provided for @voicingComplexityBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get voicingComplexityBasic;

  /// No description provided for @voicingComplexityStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get voicingComplexityStandard;

  /// No description provided for @voicingComplexityModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get voicingComplexityModern;

  /// No description provided for @voicingTopNotePreference.
  ///
  /// In en, this message translates to:
  /// **'Top Note Preference'**
  String get voicingTopNotePreference;

  /// No description provided for @voicingTopNotePreferenceHelp.
  ///
  /// In en, this message translates to:
  /// **'Leans suggestions toward a chosen top line. Locked voicings win first, then repeated chords keep it steady.'**
  String get voicingTopNotePreferenceHelp;

  /// No description provided for @voicingTopNotePreferenceAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get voicingTopNotePreferenceAuto;

  /// No description provided for @allowRootlessVoicings.
  ///
  /// In en, this message translates to:
  /// **'Allow Rootless Voicings'**
  String get allowRootlessVoicings;

  /// No description provided for @allowRootlessVoicingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Lets suggestions omit the root when the guide tones stay clear.'**
  String get allowRootlessVoicingsHelp;

  /// No description provided for @maxVoicingNotes.
  ///
  /// In en, this message translates to:
  /// **'Max Voicing Notes'**
  String get maxVoicingNotes;

  /// No description provided for @lookAheadDepth.
  ///
  /// In en, this message translates to:
  /// **'Look-Ahead Depth'**
  String get lookAheadDepth;

  /// No description provided for @lookAheadDepthHelp.
  ///
  /// In en, this message translates to:
  /// **'How many future chords the ranking may consider.'**
  String get lookAheadDepthHelp;

  /// No description provided for @showVoicingReasons.
  ///
  /// In en, this message translates to:
  /// **'Show Voicing Reasons'**
  String get showVoicingReasons;

  /// No description provided for @showVoicingReasonsHelp.
  ///
  /// In en, this message translates to:
  /// **'Displays short explanation chips on each suggestion card.'**
  String get showVoicingReasonsHelp;

  /// No description provided for @voicingSuggestionNatural.
  ///
  /// In en, this message translates to:
  /// **'Most Natural'**
  String get voicingSuggestionNatural;

  /// No description provided for @voicingSuggestionColorful.
  ///
  /// In en, this message translates to:
  /// **'Most Colorful'**
  String get voicingSuggestionColorful;

  /// No description provided for @voicingSuggestionEasy.
  ///
  /// In en, this message translates to:
  /// **'Easiest'**
  String get voicingSuggestionEasy;

  /// No description provided for @voicingSuggestionNaturalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Voice-leading first'**
  String get voicingSuggestionNaturalSubtitle;

  /// No description provided for @voicingSuggestionColorfulSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leans into color tones'**
  String get voicingSuggestionColorfulSubtitle;

  /// No description provided for @voicingSuggestionEasySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compact hand shape'**
  String get voicingSuggestionEasySubtitle;

  /// No description provided for @voicingSuggestionNaturalConnectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connection and resolution first'**
  String get voicingSuggestionNaturalConnectedSubtitle;

  /// No description provided for @voicingSuggestionNaturalStableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Same shape, steady comping'**
  String get voicingSuggestionNaturalStableSubtitle;

  /// No description provided for @voicingSuggestionTopLineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top line leads'**
  String get voicingSuggestionTopLineSubtitle;

  /// No description provided for @voicingSuggestionColorfulAlteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Altered tension up front'**
  String get voicingSuggestionColorfulAlteredSubtitle;

  /// No description provided for @voicingSuggestionColorfulQuartalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Modern quartal color'**
  String get voicingSuggestionColorfulQuartalSubtitle;

  /// No description provided for @voicingSuggestionColorfulTritoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tritone-sub edge with bright guide tones'**
  String get voicingSuggestionColorfulTritoneSubtitle;

  /// No description provided for @voicingSuggestionColorfulUpperStructureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guide tones with bright extensions'**
  String get voicingSuggestionColorfulUpperStructureSubtitle;

  /// No description provided for @voicingSuggestionEasyAnchoredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Core tones, smaller reach'**
  String get voicingSuggestionEasyAnchoredSubtitle;

  /// No description provided for @voicingSuggestionEasyStableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat-friendly hand shape'**
  String get voicingSuggestionEasyStableSubtitle;

  /// No description provided for @voicingPerformanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feature one representative comping shape and keep the next move in view.'**
  String get voicingPerformanceSubtitle;

  /// No description provided for @voicingPerformanceCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current voicing'**
  String get voicingPerformanceCurrentTitle;

  /// No description provided for @voicingPerformanceNextTitle.
  ///
  /// In en, this message translates to:
  /// **'Next preview'**
  String get voicingPerformanceNextTitle;

  /// No description provided for @voicingPerformanceCurrentOnly.
  ///
  /// In en, this message translates to:
  /// **'Current only'**
  String get voicingPerformanceCurrentOnly;

  /// No description provided for @voicingPerformanceShared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get voicingPerformanceShared;

  /// No description provided for @voicingPerformanceNextOnly.
  ///
  /// In en, this message translates to:
  /// **'Next move'**
  String get voicingPerformanceNextOnly;

  /// No description provided for @voicingPerformanceTopLinePath.
  ///
  /// In en, this message translates to:
  /// **'Top line: {current} -> {next}'**
  String voicingPerformanceTopLinePath(Object current, Object next);

  /// No description provided for @voicingTopNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get voicingTopNoteLabel;

  /// No description provided for @voicingTopNoteContextExplicit.
  ///
  /// In en, this message translates to:
  /// **'Top line target: {note}'**
  String voicingTopNoteContextExplicit(Object note);

  /// No description provided for @voicingTopNoteContextLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked top line: {note}'**
  String voicingTopNoteContextLocked(Object note);

  /// No description provided for @voicingTopNoteContextCarry.
  ///
  /// In en, this message translates to:
  /// **'Repeated top line: {note}'**
  String voicingTopNoteContextCarry(Object note);

  /// No description provided for @voicingTopNoteContextNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearest top line to {note}'**
  String voicingTopNoteContextNearby(Object note);

  /// No description provided for @voicingTopNoteContextFallback.
  ///
  /// In en, this message translates to:
  /// **'No exact top line for {note}'**
  String voicingTopNoteContextFallback(Object note);

  /// No description provided for @voicingFamilyShell.
  ///
  /// In en, this message translates to:
  /// **'Shell'**
  String get voicingFamilyShell;

  /// No description provided for @voicingFamilyRootlessA.
  ///
  /// In en, this message translates to:
  /// **'Rootless A'**
  String get voicingFamilyRootlessA;

  /// No description provided for @voicingFamilyRootlessB.
  ///
  /// In en, this message translates to:
  /// **'Rootless B'**
  String get voicingFamilyRootlessB;

  /// No description provided for @voicingFamilySpread.
  ///
  /// In en, this message translates to:
  /// **'Spread'**
  String get voicingFamilySpread;

  /// No description provided for @voicingFamilySus.
  ///
  /// In en, this message translates to:
  /// **'Sus'**
  String get voicingFamilySus;

  /// No description provided for @voicingFamilyQuartal.
  ///
  /// In en, this message translates to:
  /// **'Quartal'**
  String get voicingFamilyQuartal;

  /// No description provided for @voicingFamilyAltered.
  ///
  /// In en, this message translates to:
  /// **'Altered'**
  String get voicingFamilyAltered;

  /// No description provided for @voicingFamilyUpperStructure.
  ///
  /// In en, this message translates to:
  /// **'Upper Structure'**
  String get voicingFamilyUpperStructure;

  /// No description provided for @voicingLockSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Lock suggestion'**
  String get voicingLockSuggestion;

  /// No description provided for @voicingUnlockSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Unlock suggestion'**
  String get voicingUnlockSuggestion;

  /// No description provided for @voicingSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get voicingSelected;

  /// No description provided for @voicingLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get voicingLocked;

  /// No description provided for @voicingReasonEssentialCore.
  ///
  /// In en, this message translates to:
  /// **'Essential tones covered'**
  String get voicingReasonEssentialCore;

  /// No description provided for @voicingReasonGuideToneAnchor.
  ///
  /// In en, this message translates to:
  /// **'3rd/7th anchor'**
  String get voicingReasonGuideToneAnchor;

  /// No description provided for @voicingReasonGuideResolution.
  ///
  /// In en, this message translates to:
  /// **'{count} guide-tone resolves'**
  String voicingReasonGuideResolution(int count);

  /// No description provided for @voicingReasonCommonToneRetention.
  ///
  /// In en, this message translates to:
  /// **'{count} common tones kept'**
  String voicingReasonCommonToneRetention(int count);

  /// No description provided for @voicingReasonStableRepeat.
  ///
  /// In en, this message translates to:
  /// **'Stable repeat'**
  String get voicingReasonStableRepeat;

  /// No description provided for @voicingReasonTopLineTarget.
  ///
  /// In en, this message translates to:
  /// **'Top line target'**
  String get voicingReasonTopLineTarget;

  /// No description provided for @voicingReasonLowMudAvoided.
  ///
  /// In en, this message translates to:
  /// **'Low-register clarity'**
  String get voicingReasonLowMudAvoided;

  /// No description provided for @voicingReasonCompactReach.
  ///
  /// In en, this message translates to:
  /// **'Comfortable reach'**
  String get voicingReasonCompactReach;

  /// No description provided for @voicingReasonBassAnchor.
  ///
  /// In en, this message translates to:
  /// **'Bass anchor respected'**
  String get voicingReasonBassAnchor;

  /// No description provided for @voicingReasonNextChordReady.
  ///
  /// In en, this message translates to:
  /// **'Next chord ready'**
  String get voicingReasonNextChordReady;

  /// No description provided for @voicingReasonAlteredColor.
  ///
  /// In en, this message translates to:
  /// **'Altered tensions'**
  String get voicingReasonAlteredColor;

  /// No description provided for @voicingReasonRootlessClarity.
  ///
  /// In en, this message translates to:
  /// **'Light rootless shape'**
  String get voicingReasonRootlessClarity;

  /// No description provided for @voicingReasonSusRelease.
  ///
  /// In en, this message translates to:
  /// **'Sus release set up'**
  String get voicingReasonSusRelease;

  /// No description provided for @voicingReasonQuartalColor.
  ///
  /// In en, this message translates to:
  /// **'Quartal color'**
  String get voicingReasonQuartalColor;

  /// No description provided for @voicingReasonUpperStructureColor.
  ///
  /// In en, this message translates to:
  /// **'Upper-structure color'**
  String get voicingReasonUpperStructureColor;

  /// No description provided for @voicingReasonTritoneSubFlavor.
  ///
  /// In en, this message translates to:
  /// **'Tritone-sub flavor'**
  String get voicingReasonTritoneSubFlavor;

  /// No description provided for @voicingReasonLockedContinuity.
  ///
  /// In en, this message translates to:
  /// **'Locked continuity'**
  String get voicingReasonLockedContinuity;

  /// No description provided for @voicingReasonGentleMotion.
  ///
  /// In en, this message translates to:
  /// **'Smooth hand move'**
  String get voicingReasonGentleMotion;

  /// No description provided for @mainMenuIntro.
  ///
  /// In en, this message translates to:
  /// **'Practice chords, analyze progressions, and study harmony in one place.'**
  String get mainMenuIntro;

  /// No description provided for @mainMenuGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Generator'**
  String get mainMenuGeneratorTitle;

  /// No description provided for @mainMenuGeneratorDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate focused chord prompts with smart motion and voicing support.'**
  String get mainMenuGeneratorDescription;

  /// No description provided for @openGenerator.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get openGenerator;

  /// No description provided for @openAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Analyze Progression'**
  String get openAnalyzer;

  /// No description provided for @mainMenuAnalyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Analyzer'**
  String get mainMenuAnalyzerTitle;

  /// No description provided for @mainMenuAnalyzerDescription.
  ///
  /// In en, this message translates to:
  /// **'Read a progression for likely keys, Roman numerals, and harmonic function.'**
  String get mainMenuAnalyzerDescription;

  /// No description provided for @mainMenuStudyHarmonyTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Harmony'**
  String get mainMenuStudyHarmonyTitle;

  /// No description provided for @mainMenuStudyHarmonyDescription.
  ///
  /// In en, this message translates to:
  /// **'Continue lessons, review chapters, and build practical harmony fluency.'**
  String get mainMenuStudyHarmonyDescription;

  /// No description provided for @openStudyHarmony.
  ///
  /// In en, this message translates to:
  /// **'Start Study Harmony'**
  String get openStudyHarmony;

  /// No description provided for @studyHarmonyTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Harmony'**
  String get studyHarmonyTitle;

  /// No description provided for @studyHarmonySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Work through a structured harmony hub with quick lesson entries and chapter progress.'**
  String get studyHarmonySubtitle;

  /// No description provided for @studyHarmonyPlaceholderTag.
  ///
  /// In en, this message translates to:
  /// **'Study deck'**
  String get studyHarmonyPlaceholderTag;

  /// No description provided for @studyHarmonyPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Lesson data, prompts, and answer surfaces already share one reusable study flow for notes, chords, scales, and progression drills.'**
  String get studyHarmonyPlaceholderBody;

  /// No description provided for @studyHarmonyTestLevelTag.
  ///
  /// In en, this message translates to:
  /// **'Practice drill'**
  String get studyHarmonyTestLevelTag;

  /// No description provided for @studyHarmonyTestLevelAction.
  ///
  /// In en, this message translates to:
  /// **'Open drill'**
  String get studyHarmonyTestLevelAction;

  /// No description provided for @studyHarmonySubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get studyHarmonySubmit;

  /// No description provided for @studyHarmonyNextPrompt.
  ///
  /// In en, this message translates to:
  /// **'Next prompt'**
  String get studyHarmonyNextPrompt;

  /// No description provided for @studyHarmonySelectedAnswers.
  ///
  /// In en, this message translates to:
  /// **'Selected answers'**
  String get studyHarmonySelectedAnswers;

  /// No description provided for @studyHarmonySelectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No answers selected yet.'**
  String get studyHarmonySelectionEmpty;

  /// No description provided for @studyHarmonyClearProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total} correct'**
  String studyHarmonyClearProgress(int current, int total);

  /// No description provided for @studyHarmonyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get studyHarmonyAttempts;

  /// No description provided for @studyHarmonyAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get studyHarmonyAccuracy;

  /// No description provided for @studyHarmonyElapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get studyHarmonyElapsedTime;

  /// No description provided for @studyHarmonyObjective.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get studyHarmonyObjective;

  /// No description provided for @studyHarmonyPromptInstruction.
  ///
  /// In en, this message translates to:
  /// **'Pick the matching answer'**
  String get studyHarmonyPromptInstruction;

  /// No description provided for @studyHarmonyNeedSelection.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one answer before submitting.'**
  String get studyHarmonyNeedSelection;

  /// No description provided for @studyHarmonyCorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get studyHarmonyCorrectLabel;

  /// No description provided for @studyHarmonyIncorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get studyHarmonyIncorrectLabel;

  /// No description provided for @studyHarmonyCorrectFeedback.
  ///
  /// In en, this message translates to:
  /// **'Correct. {answer} was the right answer.'**
  String studyHarmonyCorrectFeedback(Object answer);

  /// No description provided for @studyHarmonyIncorrectFeedback.
  ///
  /// In en, this message translates to:
  /// **'Incorrect. {answer} was the right answer and you lost one life.'**
  String studyHarmonyIncorrectFeedback(Object answer);

  /// No description provided for @studyHarmonyGameOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get studyHarmonyGameOverTitle;

  /// No description provided for @studyHarmonyGameOverBody.
  ///
  /// In en, this message translates to:
  /// **'All three lives are gone. Retry this level or go back to the Study Harmony hub.'**
  String get studyHarmonyGameOverBody;

  /// No description provided for @studyHarmonyLevelCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Level Cleared'**
  String get studyHarmonyLevelCompleteTitle;

  /// No description provided for @studyHarmonyLevelCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'You reached the lesson goal. Check your accuracy and clear time below.'**
  String get studyHarmonyLevelCompleteBody;

  /// No description provided for @studyHarmonyBackToHub.
  ///
  /// In en, this message translates to:
  /// **'Back to Study Harmony'**
  String get studyHarmonyBackToHub;

  /// No description provided for @studyHarmonyRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get studyHarmonyRetry;

  /// No description provided for @studyHarmonyHubHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Study Hub'**
  String get studyHarmonyHubHeroEyebrow;

  /// No description provided for @studyHarmonyHubHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Use Continue to resume momentum, Review to revisit weak spots, and Daily to get one deterministic lesson from your unlocked path.'**
  String get studyHarmonyHubHeroBody;

  /// No description provided for @studyHarmonyTrackFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get studyHarmonyTrackFilterLabel;

  /// No description provided for @studyHarmonyTrackCoreFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get studyHarmonyTrackCoreFilterLabel;

  /// No description provided for @studyHarmonyTrackPopFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Pop'**
  String get studyHarmonyTrackPopFilterLabel;

  /// No description provided for @studyHarmonyTrackJazzFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Jazz'**
  String get studyHarmonyTrackJazzFilterLabel;

  /// No description provided for @studyHarmonyTrackClassicalFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get studyHarmonyTrackClassicalFilterLabel;

  /// No description provided for @studyHarmonyHubLessonsProgress.
  ///
  /// In en, this message translates to:
  /// **'{cleared}/{total} lessons cleared'**
  String studyHarmonyHubLessonsProgress(int cleared, int total);

  /// No description provided for @studyHarmonyHubChaptersProgress.
  ///
  /// In en, this message translates to:
  /// **'{cleared}/{total} chapters completed'**
  String studyHarmonyHubChaptersProgress(int cleared, int total);

  /// No description provided for @studyHarmonyProgressStars.
  ///
  /// In en, this message translates to:
  /// **'{stars} stars'**
  String studyHarmonyProgressStars(int stars);

  /// No description provided for @studyHarmonyProgressSkillsMastered.
  ///
  /// In en, this message translates to:
  /// **'{mastered}/{total} skills mastered'**
  String studyHarmonyProgressSkillsMastered(int mastered, int total);

  /// No description provided for @studyHarmonyProgressReviewsReady.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews ready'**
  String studyHarmonyProgressReviewsReady(int count);

  /// No description provided for @studyHarmonyProgressStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak x{count}'**
  String studyHarmonyProgressStreak(int count);

  /// No description provided for @studyHarmonyProgressRuns.
  ///
  /// In en, this message translates to:
  /// **'{count} runs'**
  String studyHarmonyProgressRuns(int count);

  /// No description provided for @studyHarmonyProgressBestRank.
  ///
  /// In en, this message translates to:
  /// **'Best {rank}'**
  String studyHarmonyProgressBestRank(Object rank);

  /// No description provided for @studyHarmonyBossTag.
  ///
  /// In en, this message translates to:
  /// **'Boss'**
  String get studyHarmonyBossTag;

  /// No description provided for @studyHarmonyContinueCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get studyHarmonyContinueCardTitle;

  /// No description provided for @studyHarmonyContinueResumeHint.
  ///
  /// In en, this message translates to:
  /// **'Resume the lesson you touched most recently.'**
  String get studyHarmonyContinueResumeHint;

  /// No description provided for @studyHarmonyContinueFrontierHint.
  ///
  /// In en, this message translates to:
  /// **'Jump to the next lesson at your current frontier.'**
  String get studyHarmonyContinueFrontierHint;

  /// No description provided for @studyHarmonyContinueLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue: {lessonTitle}'**
  String studyHarmonyContinueLessonLabel(Object lessonTitle);

  /// No description provided for @studyHarmonyContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get studyHarmonyContinueAction;

  /// No description provided for @studyHarmonyReviewCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get studyHarmonyReviewCardTitle;

  /// No description provided for @studyHarmonyReviewQueueHint.
  ///
  /// In en, this message translates to:
  /// **'Pulled from your current review queue.'**
  String get studyHarmonyReviewQueueHint;

  /// No description provided for @studyHarmonyReviewWeakHint.
  ///
  /// In en, this message translates to:
  /// **'Picked from the weakest result in your played lessons.'**
  String get studyHarmonyReviewWeakHint;

  /// No description provided for @studyHarmonyReviewFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'No review debt yet, so this falls back to your current frontier.'**
  String get studyHarmonyReviewFallbackHint;

  /// No description provided for @studyHarmonyReviewRetryNeededHint.
  ///
  /// In en, this message translates to:
  /// **'This lesson needs another pass after a miss or unfinished run.'**
  String get studyHarmonyReviewRetryNeededHint;

  /// No description provided for @studyHarmonyReviewAccuracyRefreshHint.
  ///
  /// In en, this message translates to:
  /// **'This lesson is queued for a quick accuracy refresh.'**
  String get studyHarmonyReviewAccuracyRefreshHint;

  /// No description provided for @studyHarmonyReviewAction.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get studyHarmonyReviewAction;

  /// No description provided for @studyHarmonyDailyCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get studyHarmonyDailyCardTitle;

  /// No description provided for @studyHarmonyDailyCardHint.
  ///
  /// In en, this message translates to:
  /// **'Open today\'s deterministic pick from your unlocked lessons.'**
  String get studyHarmonyDailyCardHint;

  /// No description provided for @studyHarmonyDailyCardHintCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today\'s daily is cleared. Replay it if you want, or come back tomorrow to keep the streak going.'**
  String get studyHarmonyDailyCardHintCompleted;

  /// No description provided for @studyHarmonyDailyAction.
  ///
  /// In en, this message translates to:
  /// **'Play daily'**
  String get studyHarmonyDailyAction;

  /// No description provided for @studyHarmonyDailyDateBadge.
  ///
  /// In en, this message translates to:
  /// **'Seed {dateKey}'**
  String studyHarmonyDailyDateBadge(Object dateKey);

  /// No description provided for @studyHarmonyDailyClearedTodayTag.
  ///
  /// In en, this message translates to:
  /// **'Daily cleared today'**
  String get studyHarmonyDailyClearedTodayTag;

  /// No description provided for @studyHarmonyReviewSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak Spot Review'**
  String get studyHarmonyReviewSessionTitle;

  /// No description provided for @studyHarmonyReviewSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix a short review set around {chapterTitle} and your weakest recent skills.'**
  String studyHarmonyReviewSessionDescription(Object chapterTitle);

  /// No description provided for @studyHarmonyDailySessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get studyHarmonyDailySessionTitle;

  /// No description provided for @studyHarmonyDailySessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Play today\'s seeded mix built from {chapterTitle} and your current frontier.'**
  String studyHarmonyDailySessionDescription(Object chapterTitle);

  /// No description provided for @studyHarmonyModeLesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson Mode'**
  String get studyHarmonyModeLesson;

  /// No description provided for @studyHarmonyModeReview.
  ///
  /// In en, this message translates to:
  /// **'Review Mode'**
  String get studyHarmonyModeReview;

  /// No description provided for @studyHarmonyModeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Mode'**
  String get studyHarmonyModeDaily;

  /// No description provided for @studyHarmonyModeLegacy.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get studyHarmonyModeLegacy;

  /// No description provided for @studyHarmonyShortcutHint.
  ///
  /// In en, this message translates to:
  /// **'Enter submits or moves on. R restarts. 1-9 chooses an answer. Tab and Shift+Tab move focus.'**
  String get studyHarmonyShortcutHint;

  /// No description provided for @studyHarmonyLivesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} of {total} lives remaining'**
  String studyHarmonyLivesRemaining(int remaining, int total);

  /// No description provided for @studyHarmonyResultSkillGainTitle.
  ///
  /// In en, this message translates to:
  /// **'Skill gains'**
  String get studyHarmonyResultSkillGainTitle;

  /// No description provided for @studyHarmonyResultReviewFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Review focus'**
  String get studyHarmonyResultReviewFocusTitle;

  /// No description provided for @studyHarmonyResultRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Session reward'**
  String get studyHarmonyResultRewardTitle;

  /// No description provided for @studyHarmonyBonusGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bonus goals'**
  String get studyHarmonyBonusGoalsTitle;

  /// No description provided for @studyHarmonyResultRankLine.
  ///
  /// In en, this message translates to:
  /// **'Rank {rank}'**
  String studyHarmonyResultRankLine(Object rank);

  /// No description provided for @studyHarmonyResultStarsLine.
  ///
  /// In en, this message translates to:
  /// **'{stars} stars'**
  String studyHarmonyResultStarsLine(int stars);

  /// No description provided for @studyHarmonyResultBestLine.
  ///
  /// In en, this message translates to:
  /// **'Best {rank} · {stars} stars'**
  String studyHarmonyResultBestLine(Object rank, int stars);

  /// No description provided for @studyHarmonyResultDailyStreakLine.
  ///
  /// In en, this message translates to:
  /// **'Daily streak x{count}'**
  String studyHarmonyResultDailyStreakLine(int count);

  /// No description provided for @studyHarmonyResultNewBestTag.
  ///
  /// In en, this message translates to:
  /// **'New personal best'**
  String get studyHarmonyResultNewBestTag;

  /// No description provided for @studyHarmonyResultSkillGainLine.
  ///
  /// In en, this message translates to:
  /// **'{skill} {delta}'**
  String studyHarmonyResultSkillGainLine(Object skill, Object delta);

  /// No description provided for @studyHarmonyReviewReasonRetryNeeded.
  ///
  /// In en, this message translates to:
  /// **'Review reason: retry needed'**
  String get studyHarmonyReviewReasonRetryNeeded;

  /// No description provided for @studyHarmonyReviewReasonAccuracyRefresh.
  ///
  /// In en, this message translates to:
  /// **'Review reason: accuracy refresh'**
  String get studyHarmonyReviewReasonAccuracyRefresh;

  /// No description provided for @studyHarmonyReviewReasonLowMastery.
  ///
  /// In en, this message translates to:
  /// **'Review reason: low mastery'**
  String get studyHarmonyReviewReasonLowMastery;

  /// No description provided for @studyHarmonyReviewReasonStaleSkill.
  ///
  /// In en, this message translates to:
  /// **'Review reason: stale skill'**
  String get studyHarmonyReviewReasonStaleSkill;

  /// No description provided for @studyHarmonyReviewReasonWeakSpot.
  ///
  /// In en, this message translates to:
  /// **'Review reason: weak spot'**
  String get studyHarmonyReviewReasonWeakSpot;

  /// No description provided for @studyHarmonyReviewReasonFrontierRefresh.
  ///
  /// In en, this message translates to:
  /// **'Review reason: frontier refresh'**
  String get studyHarmonyReviewReasonFrontierRefresh;

  /// No description provided for @studyHarmonyQuestBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'Quest Board'**
  String get studyHarmonyQuestBoardTitle;

  /// No description provided for @studyHarmonyQuestCompletedTag.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studyHarmonyQuestCompletedTag;

  /// No description provided for @studyHarmonyQuestTodayTag.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get studyHarmonyQuestTodayTag;

  /// No description provided for @studyHarmonyQuestProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{current}/{target} complete'**
  String studyHarmonyQuestProgressLabel(int current, int target);

  /// No description provided for @studyHarmonyQuestDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get studyHarmonyQuestDailyTitle;

  /// No description provided for @studyHarmonyQuestDailyBody.
  ///
  /// In en, this message translates to:
  /// **'Clear today\'s seeded mix to extend your streak.'**
  String get studyHarmonyQuestDailyBody;

  /// No description provided for @studyHarmonyQuestDailyBodyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Today\'s daily is already cleared. The streak is safe for now.'**
  String get studyHarmonyQuestDailyBodyCompleted;

  /// No description provided for @studyHarmonyQuestFrontierTitle.
  ///
  /// In en, this message translates to:
  /// **'Frontier push'**
  String get studyHarmonyQuestFrontierTitle;

  /// No description provided for @studyHarmonyQuestFrontierBody.
  ///
  /// In en, this message translates to:
  /// **'Clear {lessonTitle} to move the path forward.'**
  String studyHarmonyQuestFrontierBody(Object lessonTitle);

  /// No description provided for @studyHarmonyQuestFrontierBodyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Every currently unlocked lesson is cleared. Replay a boss or chase more stars.'**
  String get studyHarmonyQuestFrontierBodyCompleted;

  /// No description provided for @studyHarmonyQuestStarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Star hunt'**
  String get studyHarmonyQuestStarsTitle;

  /// No description provided for @studyHarmonyQuestStarsBody.
  ///
  /// In en, this message translates to:
  /// **'Push extra stars inside {chapterTitle}.'**
  String studyHarmonyQuestStarsBody(Object chapterTitle);

  /// No description provided for @studyHarmonyQuestStarsBodyFallback.
  ///
  /// In en, this message translates to:
  /// **'Push extra stars in your current chapter.'**
  String get studyHarmonyQuestStarsBodyFallback;

  /// No description provided for @studyHarmonyComboLabel.
  ///
  /// In en, this message translates to:
  /// **'Combo x{count}'**
  String studyHarmonyComboLabel(int count);

  /// No description provided for @studyHarmonyBestComboLabel.
  ///
  /// In en, this message translates to:
  /// **'Best combo x{count}'**
  String studyHarmonyBestComboLabel(int count);

  /// No description provided for @studyHarmonyBonusFullHearts.
  ///
  /// In en, this message translates to:
  /// **'Keep all hearts'**
  String get studyHarmonyBonusFullHearts;

  /// No description provided for @studyHarmonyBonusAccuracyTarget.
  ///
  /// In en, this message translates to:
  /// **'Reach {percent}% accuracy'**
  String studyHarmonyBonusAccuracyTarget(int percent);

  /// No description provided for @studyHarmonyBonusComboTarget.
  ///
  /// In en, this message translates to:
  /// **'Reach combo x{count}'**
  String studyHarmonyBonusComboTarget(int count);

  /// No description provided for @studyHarmonyBonusSweepTag.
  ///
  /// In en, this message translates to:
  /// **'Bonus sweep'**
  String get studyHarmonyBonusSweepTag;

  /// No description provided for @studyHarmonySkillNoteRead.
  ///
  /// In en, this message translates to:
  /// **'Note reading'**
  String get studyHarmonySkillNoteRead;

  /// No description provided for @studyHarmonySkillNoteFindKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Keyboard note finding'**
  String get studyHarmonySkillNoteFindKeyboard;

  /// No description provided for @studyHarmonySkillNoteAccidentals.
  ///
  /// In en, this message translates to:
  /// **'Sharps and flats'**
  String get studyHarmonySkillNoteAccidentals;

  /// No description provided for @studyHarmonySkillChordSymbolToKeys.
  ///
  /// In en, this message translates to:
  /// **'Chord symbol to keys'**
  String get studyHarmonySkillChordSymbolToKeys;

  /// No description provided for @studyHarmonySkillChordNameFromTones.
  ///
  /// In en, this message translates to:
  /// **'Chord naming'**
  String get studyHarmonySkillChordNameFromTones;

  /// No description provided for @studyHarmonySkillScaleBuild.
  ///
  /// In en, this message translates to:
  /// **'Scale building'**
  String get studyHarmonySkillScaleBuild;

  /// No description provided for @studyHarmonySkillRomanRealize.
  ///
  /// In en, this message translates to:
  /// **'Roman numeral realization'**
  String get studyHarmonySkillRomanRealize;

  /// No description provided for @studyHarmonySkillRomanIdentify.
  ///
  /// In en, this message translates to:
  /// **'Roman numeral identification'**
  String get studyHarmonySkillRomanIdentify;

  /// No description provided for @studyHarmonySkillHarmonyDiatonicity.
  ///
  /// In en, this message translates to:
  /// **'Diatonicity'**
  String get studyHarmonySkillHarmonyDiatonicity;

  /// No description provided for @studyHarmonySkillHarmonyFunction.
  ///
  /// In en, this message translates to:
  /// **'Function basics'**
  String get studyHarmonySkillHarmonyFunction;

  /// No description provided for @studyHarmonySkillProgressionKeyCenter.
  ///
  /// In en, this message translates to:
  /// **'Progression key center'**
  String get studyHarmonySkillProgressionKeyCenter;

  /// No description provided for @studyHarmonySkillProgressionFunction.
  ///
  /// In en, this message translates to:
  /// **'Progression function reading'**
  String get studyHarmonySkillProgressionFunction;

  /// No description provided for @studyHarmonySkillProgressionNonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'Progression non-diatonic detection'**
  String get studyHarmonySkillProgressionNonDiatonic;

  /// No description provided for @studyHarmonySkillProgressionFillBlank.
  ///
  /// In en, this message translates to:
  /// **'Progression fill-in'**
  String get studyHarmonySkillProgressionFillBlank;

  /// No description provided for @studyHarmonyHubChapterSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get studyHarmonyHubChapterSectionTitle;

  /// No description provided for @studyHarmonyChapterProgressText.
  ///
  /// In en, this message translates to:
  /// **'{cleared}/{total} lessons cleared'**
  String studyHarmonyChapterProgressText(int cleared, int total);

  /// No description provided for @studyHarmonyLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String studyHarmonyLessonsCount(int count);

  /// No description provided for @studyHarmonyCompletedLessonsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cleared'**
  String studyHarmonyCompletedLessonsCount(int count);

  /// No description provided for @studyHarmonyOpenChapterAction.
  ///
  /// In en, this message translates to:
  /// **'Open chapter'**
  String get studyHarmonyOpenChapterAction;

  /// No description provided for @studyHarmonyLockedChapterTag.
  ///
  /// In en, this message translates to:
  /// **'Locked chapter'**
  String get studyHarmonyLockedChapterTag;

  /// No description provided for @studyHarmonyChapterNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up: {lessonTitle}'**
  String studyHarmonyChapterNextUp(Object lessonTitle);

  /// No description provided for @studyHarmonyChapterViewTitle.
  ///
  /// In en, this message translates to:
  /// **'{chapterTitle}'**
  String studyHarmonyChapterViewTitle(Object chapterTitle);

  /// No description provided for @studyHarmonyTrackPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'This track is still locked. Switch back to {coreTrack} to keep studying today.'**
  String studyHarmonyTrackPlaceholderBody(Object coreTrack);

  /// No description provided for @studyHarmonyCoreTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Core Track'**
  String get studyHarmonyCoreTrackTitle;

  /// No description provided for @studyHarmonyCoreTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Start with notes and the keyboard, then build up through chords, scales, Roman numerals, diatonic basics, and short progression analysis.'**
  String get studyHarmonyCoreTrackDescription;

  /// No description provided for @studyHarmonyChapterNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 1: Notes & Keyboard'**
  String get studyHarmonyChapterNotesTitle;

  /// No description provided for @studyHarmonyChapterNotesDescription.
  ///
  /// In en, this message translates to:
  /// **'Map note names to the keyboard and get comfortable with white keys and simple accidentals.'**
  String get studyHarmonyChapterNotesDescription;

  /// No description provided for @studyHarmonyChapterChordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 2: Chord Basics'**
  String get studyHarmonyChapterChordsTitle;

  /// No description provided for @studyHarmonyChapterChordsDescription.
  ///
  /// In en, this message translates to:
  /// **'Spell basic triads and sevenths, then name common chord shapes from their tones.'**
  String get studyHarmonyChapterChordsDescription;

  /// No description provided for @studyHarmonyChapterScalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 3: Scales & Keys'**
  String get studyHarmonyChapterScalesTitle;

  /// No description provided for @studyHarmonyChapterScalesDescription.
  ///
  /// In en, this message translates to:
  /// **'Build major and minor scales, then spot which tones belong inside a key.'**
  String get studyHarmonyChapterScalesDescription;

  /// No description provided for @studyHarmonyChapterRomanTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 4: Roman Numerals & Diatonicity'**
  String get studyHarmonyChapterRomanTitle;

  /// No description provided for @studyHarmonyChapterRomanDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn simple Roman numerals into chords, identify them from chords, and sort diatonic basics by function.'**
  String get studyHarmonyChapterRomanDescription;

  /// No description provided for @studyHarmonyChapterProgressionDetectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 5: Progression Detective I'**
  String get studyHarmonyChapterProgressionDetectiveTitle;

  /// No description provided for @studyHarmonyChapterProgressionDetectiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Read short core progressions, find the likely key center, and spot the chord function or odd one out.'**
  String get studyHarmonyChapterProgressionDetectiveDescription;

  /// No description provided for @studyHarmonyChapterMissingChordTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapter 6: Missing Chord I'**
  String get studyHarmonyChapterMissingChordTitle;

  /// No description provided for @studyHarmonyChapterMissingChordDescription.
  ///
  /// In en, this message translates to:
  /// **'Fill one blank inside a short progression and learn where cadence and function want to go next.'**
  String get studyHarmonyChapterMissingChordDescription;

  /// No description provided for @studyHarmonyOpenLessonAction.
  ///
  /// In en, this message translates to:
  /// **'Open lesson'**
  String get studyHarmonyOpenLessonAction;

  /// No description provided for @studyHarmonyLockedLessonAction.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get studyHarmonyLockedLessonAction;

  /// No description provided for @studyHarmonyClearedTag.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get studyHarmonyClearedTag;

  /// No description provided for @studyHarmonyComingSoonTag.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get studyHarmonyComingSoonTag;

  /// No description provided for @studyHarmonyPopTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Pop Track'**
  String get studyHarmonyPopTrackTitle;

  /// No description provided for @studyHarmonyPopTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Run the full harmony path in a pop lane with its own progress, daily picks, and review queue.'**
  String get studyHarmonyPopTrackDescription;

  /// No description provided for @studyHarmonyJazzTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Jazz Track'**
  String get studyHarmonyJazzTrackTitle;

  /// No description provided for @studyHarmonyJazzTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice the full curriculum in a jazz lane with separate progress, daily picks, and review queue.'**
  String get studyHarmonyJazzTrackDescription;

  /// No description provided for @studyHarmonyClassicalTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Classical Track'**
  String get studyHarmonyClassicalTrackTitle;

  /// No description provided for @studyHarmonyClassicalTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Study the full curriculum in a classical lane with independent progress, daily picks, and review queue.'**
  String get studyHarmonyClassicalTrackDescription;

  /// No description provided for @studyHarmonyObjectiveQuickDrill.
  ///
  /// In en, this message translates to:
  /// **'Quick Drill'**
  String get studyHarmonyObjectiveQuickDrill;

  /// No description provided for @studyHarmonyObjectiveBossReview.
  ///
  /// In en, this message translates to:
  /// **'Boss Review'**
  String get studyHarmonyObjectiveBossReview;

  /// No description provided for @studyHarmonyLessonNotesKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'White-Key Note Hunt'**
  String get studyHarmonyLessonNotesKeyboardTitle;

  /// No description provided for @studyHarmonyLessonNotesKeyboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Read note names and tap the matching white key.'**
  String get studyHarmonyLessonNotesKeyboardDescription;

  /// No description provided for @studyHarmonyLessonNotesPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Name the Highlighted Note'**
  String get studyHarmonyLessonNotesPreviewTitle;

  /// No description provided for @studyHarmonyLessonNotesPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Look at a highlighted key and choose the correct note name.'**
  String get studyHarmonyLessonNotesPreviewDescription;

  /// No description provided for @studyHarmonyLessonNotesAccidentalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Black Keys and Twins'**
  String get studyHarmonyLessonNotesAccidentalsTitle;

  /// No description provided for @studyHarmonyLessonNotesAccidentalsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get a first look at sharp and flat spellings for the black keys.'**
  String get studyHarmonyLessonNotesAccidentalsDescription;

  /// No description provided for @studyHarmonyLessonNotesBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Fast Note Hunt'**
  String get studyHarmonyLessonNotesBossTitle;

  /// No description provided for @studyHarmonyLessonNotesBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix note reading and keyboard finding into one short speed round.'**
  String get studyHarmonyLessonNotesBossDescription;

  /// No description provided for @studyHarmonyLessonTriadKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Triads on the Keyboard'**
  String get studyHarmonyLessonTriadKeyboardTitle;

  /// No description provided for @studyHarmonyLessonTriadKeyboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Build common major, minor, and diminished triads directly on the keyboard.'**
  String get studyHarmonyLessonTriadKeyboardDescription;

  /// No description provided for @studyHarmonyLessonSeventhKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sevenths on the Keyboard'**
  String get studyHarmonyLessonSeventhKeyboardTitle;

  /// No description provided for @studyHarmonyLessonSeventhKeyboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Add the seventh and spell a few common 7th chords on the keyboard.'**
  String get studyHarmonyLessonSeventhKeyboardDescription;

  /// No description provided for @studyHarmonyLessonChordNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Name the Highlighted Chord'**
  String get studyHarmonyLessonChordNameTitle;

  /// No description provided for @studyHarmonyLessonChordNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Read a highlighted chord shape and choose the correct chord name.'**
  String get studyHarmonyLessonChordNameDescription;

  /// No description provided for @studyHarmonyLessonChordsBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Triads and Sevenths Review'**
  String get studyHarmonyLessonChordsBossTitle;

  /// No description provided for @studyHarmonyLessonChordsBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch between chord spelling and chord naming in one mixed review.'**
  String get studyHarmonyLessonChordsBossDescription;

  /// No description provided for @studyHarmonyLessonMajorScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Major Scales'**
  String get studyHarmonyLessonMajorScaleTitle;

  /// No description provided for @studyHarmonyLessonMajorScaleDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose every tone that belongs to a simple major scale.'**
  String get studyHarmonyLessonMajorScaleDescription;

  /// No description provided for @studyHarmonyLessonMinorScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Minor Scales'**
  String get studyHarmonyLessonMinorScaleTitle;

  /// No description provided for @studyHarmonyLessonMinorScaleDescription.
  ///
  /// In en, this message translates to:
  /// **'Build natural minor and harmonic minor scales from a few common keys.'**
  String get studyHarmonyLessonMinorScaleDescription;

  /// No description provided for @studyHarmonyLessonKeyMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Membership'**
  String get studyHarmonyLessonKeyMembershipTitle;

  /// No description provided for @studyHarmonyLessonKeyMembershipDescription.
  ///
  /// In en, this message translates to:
  /// **'Find which tones belong inside a named key.'**
  String get studyHarmonyLessonKeyMembershipDescription;

  /// No description provided for @studyHarmonyLessonScalesBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Scale Repair'**
  String get studyHarmonyLessonScalesBossTitle;

  /// No description provided for @studyHarmonyLessonScalesBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix scale building and key membership in a short repair round.'**
  String get studyHarmonyLessonScalesBossDescription;

  /// No description provided for @studyHarmonyLessonRomanToChordTitle.
  ///
  /// In en, this message translates to:
  /// **'Roman to Chord'**
  String get studyHarmonyLessonRomanToChordTitle;

  /// No description provided for @studyHarmonyLessonRomanToChordDescription.
  ///
  /// In en, this message translates to:
  /// **'Read a key and Roman numeral, then choose the matching chord.'**
  String get studyHarmonyLessonRomanToChordDescription;

  /// No description provided for @studyHarmonyLessonChordToRomanTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord to Roman'**
  String get studyHarmonyLessonChordToRomanTitle;

  /// No description provided for @studyHarmonyLessonChordToRomanDescription.
  ///
  /// In en, this message translates to:
  /// **'Read a chord inside a key and choose the matching Roman numeral.'**
  String get studyHarmonyLessonChordToRomanDescription;

  /// No description provided for @studyHarmonyLessonDiatonicityTitle.
  ///
  /// In en, this message translates to:
  /// **'Diatonic or Not'**
  String get studyHarmonyLessonDiatonicityTitle;

  /// No description provided for @studyHarmonyLessonDiatonicityDescription.
  ///
  /// In en, this message translates to:
  /// **'Sort chords into diatonic and non-diatonic answers in simple keys.'**
  String get studyHarmonyLessonDiatonicityDescription;

  /// No description provided for @studyHarmonyLessonFunctionTitle.
  ///
  /// In en, this message translates to:
  /// **'Function Basics'**
  String get studyHarmonyLessonFunctionTitle;

  /// No description provided for @studyHarmonyLessonFunctionDescription.
  ///
  /// In en, this message translates to:
  /// **'Classify easy chords as tonic, predominant, or dominant.'**
  String get studyHarmonyLessonFunctionDescription;

  /// No description provided for @studyHarmonyLessonRomanBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Functional Basics Mix'**
  String get studyHarmonyLessonRomanBossTitle;

  /// No description provided for @studyHarmonyLessonRomanBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Review Roman-to-chord, chord-to-Roman, diatonicity, and function together.'**
  String get studyHarmonyLessonRomanBossDescription;

  /// No description provided for @studyHarmonyLessonProgressionKeyCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Key Center'**
  String get studyHarmonyLessonProgressionKeyCenterTitle;

  /// No description provided for @studyHarmonyLessonProgressionKeyCenterDescription.
  ///
  /// In en, this message translates to:
  /// **'Read a short progression and choose the key center that makes the clearest sense.'**
  String get studyHarmonyLessonProgressionKeyCenterDescription;

  /// No description provided for @studyHarmonyLessonProgressionFunctionTitle.
  ///
  /// In en, this message translates to:
  /// **'Function in Context'**
  String get studyHarmonyLessonProgressionFunctionTitle;

  /// No description provided for @studyHarmonyLessonProgressionFunctionDescription.
  ///
  /// In en, this message translates to:
  /// **'Focus on one highlighted chord and name its role inside a short progression.'**
  String get studyHarmonyLessonProgressionFunctionDescription;

  /// No description provided for @studyHarmonyLessonProgressionNonDiatonicTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Outsider'**
  String get studyHarmonyLessonProgressionNonDiatonicTitle;

  /// No description provided for @studyHarmonyLessonProgressionNonDiatonicDescription.
  ///
  /// In en, this message translates to:
  /// **'Spot the one chord that falls outside the main diatonic reading.'**
  String get studyHarmonyLessonProgressionNonDiatonicDescription;

  /// No description provided for @studyHarmonyLessonProgressionBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Mixed Analysis'**
  String get studyHarmonyLessonProgressionBossTitle;

  /// No description provided for @studyHarmonyLessonProgressionBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix key-center reading, function spotting, and non-diatonic detection in one short detective round.'**
  String get studyHarmonyLessonProgressionBossDescription;

  /// No description provided for @studyHarmonyLessonMissingChordPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill the Missing Chord'**
  String get studyHarmonyLessonMissingChordPatternTitle;

  /// No description provided for @studyHarmonyLessonMissingChordPatternDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete a short four-chord progression by choosing the chord that fits the local function best.'**
  String get studyHarmonyLessonMissingChordPatternDescription;

  /// No description provided for @studyHarmonyLessonMissingChordCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadence Fill-In'**
  String get studyHarmonyLessonMissingChordCadenceTitle;

  /// No description provided for @studyHarmonyLessonMissingChordCadenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the pull toward a cadence to choose the missing chord near the end of a phrase.'**
  String get studyHarmonyLessonMissingChordCadenceDescription;

  /// No description provided for @studyHarmonyLessonMissingChordBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Mixed Fill-In'**
  String get studyHarmonyLessonMissingChordBossTitle;

  /// No description provided for @studyHarmonyLessonMissingChordBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Solve a short set of fill-in progression questions with a little more harmonic pressure.'**
  String get studyHarmonyLessonMissingChordBossDescription;

  /// No description provided for @studyHarmonyChapterCheckpointTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkpoint Gauntlet'**
  String get studyHarmonyChapterCheckpointTitle;

  /// No description provided for @studyHarmonyChapterCheckpointDescription.
  ///
  /// In en, this message translates to:
  /// **'Combine key-center, function, color, and fill-in drills in faster mixed review sets.'**
  String get studyHarmonyChapterCheckpointDescription;

  /// No description provided for @studyHarmonyLessonCheckpointCadenceRushTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadence Rush'**
  String get studyHarmonyLessonCheckpointCadenceRushTitle;

  /// No description provided for @studyHarmonyLessonCheckpointCadenceRushDescription.
  ///
  /// In en, this message translates to:
  /// **'Read the harmonic role quickly, then plug the missing cadential chord under light pressure.'**
  String get studyHarmonyLessonCheckpointCadenceRushDescription;

  /// No description provided for @studyHarmonyLessonCheckpointColorKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Color and Key Shift'**
  String get studyHarmonyLessonCheckpointColorKeyTitle;

  /// No description provided for @studyHarmonyLessonCheckpointColorKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch between center detection and non-diatonic color calls without losing the thread.'**
  String get studyHarmonyLessonCheckpointColorKeyDescription;

  /// No description provided for @studyHarmonyLessonCheckpointBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Checkpoint Gauntlet'**
  String get studyHarmonyLessonCheckpointBossTitle;

  /// No description provided for @studyHarmonyLessonCheckpointBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Clear one integrated checkpoint that mixes key-center, function, color, and cadence repair prompts.'**
  String get studyHarmonyLessonCheckpointBossDescription;

  /// No description provided for @studyHarmonyChapterCapstoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Capstone Trials'**
  String get studyHarmonyChapterCapstoneTitle;

  /// No description provided for @studyHarmonyChapterCapstoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Finish the core path with tougher mixed progression rounds that ask for speed, color hearing, and clean resolution choices.'**
  String get studyHarmonyChapterCapstoneDescription;

  /// No description provided for @studyHarmonyLessonCapstoneTurnaroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Turnaround Relay'**
  String get studyHarmonyLessonCapstoneTurnaroundTitle;

  /// No description provided for @studyHarmonyLessonCapstoneTurnaroundDescription.
  ///
  /// In en, this message translates to:
  /// **'Swap between function reading and missing-chord repair across compact turnarounds.'**
  String get studyHarmonyLessonCapstoneTurnaroundDescription;

  /// No description provided for @studyHarmonyLessonCapstoneBorrowedColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Color Calls'**
  String get studyHarmonyLessonCapstoneBorrowedColorTitle;

  /// No description provided for @studyHarmonyLessonCapstoneBorrowedColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Catch modal color quickly, then confirm the key center before it slips away.'**
  String get studyHarmonyLessonCapstoneBorrowedColorDescription;

  /// No description provided for @studyHarmonyLessonCapstoneResolutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolution Lab'**
  String get studyHarmonyLessonCapstoneResolutionTitle;

  /// No description provided for @studyHarmonyLessonCapstoneResolutionDescription.
  ///
  /// In en, this message translates to:
  /// **'Track where each phrase wants to land and choose the chord that best resolves the motion.'**
  String get studyHarmonyLessonCapstoneResolutionDescription;

  /// No description provided for @studyHarmonyLessonCapstoneBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss: Final Progression Exam'**
  String get studyHarmonyLessonCapstoneBossTitle;

  /// No description provided for @studyHarmonyLessonCapstoneBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Pass one final mixed exam with center, function, color, and resolution all under pressure.'**
  String get studyHarmonyLessonCapstoneBossDescription;

  /// No description provided for @studyHarmonyPromptFindNoteOnKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Find {note} on the keyboard'**
  String studyHarmonyPromptFindNoteOnKeyboard(Object note);

  /// No description provided for @studyHarmonyPromptNameHighlightedNote.
  ///
  /// In en, this message translates to:
  /// **'Which note is highlighted?'**
  String get studyHarmonyPromptNameHighlightedNote;

  /// No description provided for @studyHarmonyPromptFindChordOnKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Build {chord} on the keyboard'**
  String studyHarmonyPromptFindChordOnKeyboard(Object chord);

  /// No description provided for @studyHarmonyPromptNameHighlightedChord.
  ///
  /// In en, this message translates to:
  /// **'Which chord is highlighted?'**
  String get studyHarmonyPromptNameHighlightedChord;

  /// No description provided for @studyHarmonyPromptBuildScale.
  ///
  /// In en, this message translates to:
  /// **'Pick every note in {scaleName}'**
  String studyHarmonyPromptBuildScale(Object scaleName);

  /// No description provided for @studyHarmonyPromptKeyMembership.
  ///
  /// In en, this message translates to:
  /// **'Pick the notes that belong to {keyName}'**
  String studyHarmonyPromptKeyMembership(Object keyName);

  /// No description provided for @studyHarmonyPromptRomanToChord.
  ///
  /// In en, this message translates to:
  /// **'In {keyName}, which chord matches {roman}?'**
  String studyHarmonyPromptRomanToChord(Object keyName, Object roman);

  /// No description provided for @studyHarmonyPromptChordToRoman.
  ///
  /// In en, this message translates to:
  /// **'In {keyName}, what Roman numeral matches {chord}?'**
  String studyHarmonyPromptChordToRoman(Object keyName, Object chord);

  /// No description provided for @studyHarmonyPromptDiatonicity.
  ///
  /// In en, this message translates to:
  /// **'In {keyName}, is {chord} diatonic?'**
  String studyHarmonyPromptDiatonicity(Object keyName, Object chord);

  /// No description provided for @studyHarmonyPromptFunction.
  ///
  /// In en, this message translates to:
  /// **'In {keyName}, what function does {chord} have?'**
  String studyHarmonyPromptFunction(Object keyName, Object chord);

  /// No description provided for @studyHarmonyProgressionStripLabel.
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get studyHarmonyProgressionStripLabel;

  /// No description provided for @studyHarmonyPromptProgressionKeyCenter.
  ///
  /// In en, this message translates to:
  /// **'Which key center best fits this progression?'**
  String get studyHarmonyPromptProgressionKeyCenter;

  /// No description provided for @studyHarmonyPromptProgressionFunction.
  ///
  /// In en, this message translates to:
  /// **'What function does {chord} play here?'**
  String studyHarmonyPromptProgressionFunction(Object chord);

  /// No description provided for @studyHarmonyPromptProgressionNonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'Which chord feels least diatonic in this progression?'**
  String get studyHarmonyPromptProgressionNonDiatonic;

  /// No description provided for @studyHarmonyPromptProgressionMissingChord.
  ///
  /// In en, this message translates to:
  /// **'Which chord best fills the blank?'**
  String get studyHarmonyPromptProgressionMissingChord;

  /// No description provided for @studyHarmonyProgressionExplanationKeyCenter.
  ///
  /// In en, this message translates to:
  /// **'One likely reading keeps this progression centered on {keyLabel}.'**
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel);

  /// No description provided for @studyHarmonyProgressionExplanationFunction.
  ///
  /// In en, this message translates to:
  /// **'{chord} can be heard as a {functionLabel} chord in this context.'**
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  );

  /// No description provided for @studyHarmonyProgressionExplanationNonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'{chord} sits outside the main {keyLabel} reading, so it stands out as a plausible non-diatonic color.'**
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  );

  /// No description provided for @studyHarmonyProgressionExplanationMissingChord.
  ///
  /// In en, this message translates to:
  /// **'{chord} can restore some of the expected {functionLabel} pull in this progression.'**
  String studyHarmonyProgressionExplanationMissingChord(
    Object chord,
    Object functionLabel,
  );

  /// No description provided for @studyHarmonyProgressionChoiceSlot.
  ///
  /// In en, this message translates to:
  /// **'{index}. {chord}'**
  String studyHarmonyProgressionChoiceSlot(int index, Object chord);

  /// No description provided for @studyHarmonyScaleNameMajor.
  ///
  /// In en, this message translates to:
  /// **'{tonic} major'**
  String studyHarmonyScaleNameMajor(Object tonic);

  /// No description provided for @studyHarmonyScaleNameNaturalMinor.
  ///
  /// In en, this message translates to:
  /// **'{tonic} natural minor'**
  String studyHarmonyScaleNameNaturalMinor(Object tonic);

  /// No description provided for @studyHarmonyScaleNameHarmonicMinor.
  ///
  /// In en, this message translates to:
  /// **'{tonic} harmonic minor'**
  String studyHarmonyScaleNameHarmonicMinor(Object tonic);

  /// No description provided for @studyHarmonyKeyNameMajor.
  ///
  /// In en, this message translates to:
  /// **'{tonic} major'**
  String studyHarmonyKeyNameMajor(Object tonic);

  /// No description provided for @studyHarmonyKeyNameMinor.
  ///
  /// In en, this message translates to:
  /// **'{tonic} minor'**
  String studyHarmonyKeyNameMinor(Object tonic);

  /// No description provided for @studyHarmonyChoiceDiatonic.
  ///
  /// In en, this message translates to:
  /// **'Diatonic'**
  String get studyHarmonyChoiceDiatonic;

  /// No description provided for @studyHarmonyChoiceNonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'Non-diatonic'**
  String get studyHarmonyChoiceNonDiatonic;

  /// No description provided for @studyHarmonyChoiceTonic.
  ///
  /// In en, this message translates to:
  /// **'Tonic'**
  String get studyHarmonyChoiceTonic;

  /// No description provided for @studyHarmonyChoicePredominant.
  ///
  /// In en, this message translates to:
  /// **'Predominant'**
  String get studyHarmonyChoicePredominant;

  /// No description provided for @studyHarmonyChoiceDominant.
  ///
  /// In en, this message translates to:
  /// **'Dominant'**
  String get studyHarmonyChoiceDominant;

  /// No description provided for @studyHarmonyChoiceOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get studyHarmonyChoiceOther;

  /// No description provided for @chordAnalyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Analyzer'**
  String get chordAnalyzerTitle;

  /// No description provided for @chordAnalyzerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a progression to see likely keys, Roman numerals, and harmonic function.'**
  String get chordAnalyzerSubtitle;

  /// No description provided for @chordAnalyzerInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Chord progression'**
  String get chordAnalyzerInputLabel;

  /// No description provided for @chordAnalyzerInputHint.
  ///
  /// In en, this message translates to:
  /// **'Dm7, G7 | ? Am'**
  String get chordAnalyzerInputHint;

  /// No description provided for @chordAnalyzerInputHelper.
  ///
  /// In en, this message translates to:
  /// **'Use spaces, |, or commas between chords. Commas inside parentheses stay in the same chord.\n\nUse ? for an unknown chord slot. The analyzer will infer the most natural fill from context and suggest alternatives when the reading is ambiguous. Variation generation can also reharmonize that slot more freely.\n\nLowercase roots, slash bass, sus/alt/add forms, and tensions like C7(b9, #11) are supported.\n\nOn touch devices, use the chord pad or switch to ABC input when you want free typing.'**
  String get chordAnalyzerInputHelper;

  /// No description provided for @chordAnalyzerInputHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Input tips'**
  String get chordAnalyzerInputHelpTitle;

  /// No description provided for @chordAnalyzerAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get chordAnalyzerAnalyze;

  /// No description provided for @chordAnalyzerKeyboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Pad'**
  String get chordAnalyzerKeyboardTitle;

  /// No description provided for @chordAnalyzerKeyboardTouchHint.
  ///
  /// In en, this message translates to:
  /// **'Tap tokens to build a progression. ABC input keeps the system keyboard available when you need free typing.'**
  String get chordAnalyzerKeyboardTouchHint;

  /// No description provided for @chordAnalyzerKeyboardDesktopHint.
  ///
  /// In en, this message translates to:
  /// **'Type, paste, or tap tokens to insert them at the cursor.'**
  String get chordAnalyzerKeyboardDesktopHint;

  /// No description provided for @chordAnalyzerChordPad.
  ///
  /// In en, this message translates to:
  /// **'Pad'**
  String get chordAnalyzerChordPad;

  /// No description provided for @chordAnalyzerRawInput.
  ///
  /// In en, this message translates to:
  /// **'ABC'**
  String get chordAnalyzerRawInput;

  /// No description provided for @chordAnalyzerPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get chordAnalyzerPaste;

  /// No description provided for @chordAnalyzerClear.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get chordAnalyzerClear;

  /// No description provided for @chordAnalyzerBackspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get chordAnalyzerBackspace;

  /// No description provided for @chordAnalyzerSpace.
  ///
  /// In en, this message translates to:
  /// **'Spacebar'**
  String get chordAnalyzerSpace;

  /// No description provided for @chordAnalyzerAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing progression...'**
  String get chordAnalyzerAnalyzing;

  /// No description provided for @chordAnalyzerInitialTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a progression'**
  String get chordAnalyzerInitialTitle;

  /// No description provided for @chordAnalyzerInitialBody.
  ///
  /// In en, this message translates to:
  /// **'Enter a progression such as Dm7, G7 | ? Am or Cmaj7 | Am7 D7 | Gmaj7 to see likely keys, Roman numerals, inferred fills, and a short summary.'**
  String get chordAnalyzerInitialBody;

  /// No description provided for @chordAnalyzerPlaceholderExplanation.
  ///
  /// In en, this message translates to:
  /// **'This ? was inferred from the surrounding harmonic context, so treat it as a suggested fill rather than a certainty.'**
  String get chordAnalyzerPlaceholderExplanation;

  /// No description provided for @chordAnalyzerSuggestedFill.
  ///
  /// In en, this message translates to:
  /// **'Suggested fill: {chord}'**
  String chordAnalyzerSuggestedFill(Object chord);

  /// No description provided for @chordAnalyzerDetectedKeys.
  ///
  /// In en, this message translates to:
  /// **'Detected Keys'**
  String get chordAnalyzerDetectedKeys;

  /// No description provided for @chordAnalyzerPrimaryReading.
  ///
  /// In en, this message translates to:
  /// **'Primary reading'**
  String get chordAnalyzerPrimaryReading;

  /// No description provided for @chordAnalyzerAlternativeReading.
  ///
  /// In en, this message translates to:
  /// **'Alternative reading'**
  String get chordAnalyzerAlternativeReading;

  /// No description provided for @chordAnalyzerChordAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Chord-by-chord analysis'**
  String get chordAnalyzerChordAnalysis;

  /// No description provided for @chordAnalyzerMeasureLabel.
  ///
  /// In en, this message translates to:
  /// **'Measure {index}'**
  String chordAnalyzerMeasureLabel(Object index);

  /// No description provided for @chordAnalyzerProgressionSummary.
  ///
  /// In en, this message translates to:
  /// **'Progression summary'**
  String get chordAnalyzerProgressionSummary;

  /// No description provided for @chordAnalyzerWarnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings and ambiguities'**
  String get chordAnalyzerWarnings;

  /// No description provided for @chordAnalyzerNoInputError.
  ///
  /// In en, this message translates to:
  /// **'Enter a chord progression to analyze.'**
  String get chordAnalyzerNoInputError;

  /// No description provided for @chordAnalyzerNoRecognizedChordsError.
  ///
  /// In en, this message translates to:
  /// **'No recognizable chords were found in the progression.'**
  String get chordAnalyzerNoRecognizedChordsError;

  /// No description provided for @chordAnalyzerPartialParseWarning.
  ///
  /// In en, this message translates to:
  /// **'Some symbols were skipped: {tokens}'**
  String chordAnalyzerPartialParseWarning(Object tokens);

  /// No description provided for @chordAnalyzerKeyAmbiguityWarning.
  ///
  /// In en, this message translates to:
  /// **'The key center is still somewhat ambiguous between {primary} and {alternative}.'**
  String chordAnalyzerKeyAmbiguityWarning(Object primary, Object alternative);

  /// No description provided for @chordAnalyzerUnresolvedWarning.
  ///
  /// In en, this message translates to:
  /// **'Some chords stay ambiguous, so this reading remains intentionally conservative.'**
  String get chordAnalyzerUnresolvedWarning;

  /// No description provided for @chordAnalyzerFunctionTonic.
  ///
  /// In en, this message translates to:
  /// **'Tonic'**
  String get chordAnalyzerFunctionTonic;

  /// No description provided for @chordAnalyzerFunctionPredominant.
  ///
  /// In en, this message translates to:
  /// **'Predominant'**
  String get chordAnalyzerFunctionPredominant;

  /// No description provided for @chordAnalyzerFunctionDominant.
  ///
  /// In en, this message translates to:
  /// **'Dominant'**
  String get chordAnalyzerFunctionDominant;

  /// No description provided for @chordAnalyzerFunctionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get chordAnalyzerFunctionOther;

  /// No description provided for @chordAnalyzerRemarkSecondaryDominant.
  ///
  /// In en, this message translates to:
  /// **'Possible secondary dominant targeting {target}.'**
  String chordAnalyzerRemarkSecondaryDominant(Object target);

  /// No description provided for @chordAnalyzerRemarkTritoneSub.
  ///
  /// In en, this message translates to:
  /// **'Possible tritone substitute targeting {target}.'**
  String chordAnalyzerRemarkTritoneSub(Object target);

  /// No description provided for @chordAnalyzerRemarkModalInterchange.
  ///
  /// In en, this message translates to:
  /// **'Possible modal interchange from the parallel minor.'**
  String get chordAnalyzerRemarkModalInterchange;

  /// No description provided for @chordAnalyzerRemarkAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'This chord stays ambiguous in the current reading.'**
  String get chordAnalyzerRemarkAmbiguous;

  /// No description provided for @chordAnalyzerRemarkUnresolved.
  ///
  /// In en, this message translates to:
  /// **'This chord stays unresolved under the current conservative heuristics.'**
  String get chordAnalyzerRemarkUnresolved;

  /// No description provided for @chordAnalyzerTagIiVI.
  ///
  /// In en, this message translates to:
  /// **'ii-V-I cadence'**
  String get chordAnalyzerTagIiVI;

  /// No description provided for @chordAnalyzerTagTurnaround.
  ///
  /// In en, this message translates to:
  /// **'Turnaround'**
  String get chordAnalyzerTagTurnaround;

  /// No description provided for @chordAnalyzerTagDominantResolution.
  ///
  /// In en, this message translates to:
  /// **'Dominant resolution'**
  String get chordAnalyzerTagDominantResolution;

  /// No description provided for @chordAnalyzerTagPlagalColor.
  ///
  /// In en, this message translates to:
  /// **'Plagal/modal color'**
  String get chordAnalyzerTagPlagalColor;

  /// No description provided for @chordAnalyzerSummaryCenter.
  ///
  /// In en, this message translates to:
  /// **'This progression most likely centers on {key}.'**
  String chordAnalyzerSummaryCenter(Object key);

  /// No description provided for @chordAnalyzerSummaryAlternative.
  ///
  /// In en, this message translates to:
  /// **'An alternative reading is {key}.'**
  String chordAnalyzerSummaryAlternative(Object key);

  /// No description provided for @chordAnalyzerSummaryTag.
  ///
  /// In en, this message translates to:
  /// **'It suggests a {tag}.'**
  String chordAnalyzerSummaryTag(Object tag);

  /// No description provided for @chordAnalyzerSummaryFlow.
  ///
  /// In en, this message translates to:
  /// **'{from} and {through} behave like {fromFunction} and {throughFunction} chords leading into {target}.'**
  String chordAnalyzerSummaryFlow(
    Object from,
    Object through,
    Object fromFunction,
    Object throughFunction,
    Object target,
  );

  /// No description provided for @chordAnalyzerSummarySecondaryDominant.
  ///
  /// In en, this message translates to:
  /// **'{chord} can be heard as a possible secondary dominant pointing toward {target}.'**
  String chordAnalyzerSummarySecondaryDominant(Object chord, Object target);

  /// No description provided for @chordAnalyzerSummaryTritoneSub.
  ///
  /// In en, this message translates to:
  /// **'{chord} can be heard as a possible tritone substitute pointing toward {target}.'**
  String chordAnalyzerSummaryTritoneSub(Object chord, Object target);

  /// No description provided for @chordAnalyzerSummaryModalInterchange.
  ///
  /// In en, this message translates to:
  /// **'{chord} adds a possible modal interchange color.'**
  String chordAnalyzerSummaryModalInterchange(Object chord);

  /// No description provided for @chordAnalyzerSummaryAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'Some details remain ambiguous, so this reading stays intentionally conservative.'**
  String get chordAnalyzerSummaryAmbiguous;

  /// No description provided for @chordAnalyzerExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Examples'**
  String get chordAnalyzerExamplesTitle;

  /// No description provided for @chordAnalyzerConfidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get chordAnalyzerConfidenceLabel;

  /// No description provided for @chordAnalyzerAmbiguityLabel.
  ///
  /// In en, this message translates to:
  /// **'Ambiguity'**
  String get chordAnalyzerAmbiguityLabel;

  /// No description provided for @chordAnalyzerWhyThisReading.
  ///
  /// In en, this message translates to:
  /// **'Why this reading'**
  String get chordAnalyzerWhyThisReading;

  /// No description provided for @chordAnalyzerCompetingReadings.
  ///
  /// In en, this message translates to:
  /// **'Also plausible'**
  String get chordAnalyzerCompetingReadings;

  /// No description provided for @chordAnalyzerIgnoredModifiersWarning.
  ///
  /// In en, this message translates to:
  /// **'Ignored modifiers: {details}'**
  String chordAnalyzerIgnoredModifiersWarning(Object details);

  /// No description provided for @chordAnalyzerGenerateVariations.
  ///
  /// In en, this message translates to:
  /// **'Create Variations'**
  String get chordAnalyzerGenerateVariations;

  /// No description provided for @chordAnalyzerVariationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Natural variations'**
  String get chordAnalyzerVariationsTitle;

  /// No description provided for @chordAnalyzerVariationsBody.
  ///
  /// In en, this message translates to:
  /// **'These reharmonize the same flow with nearby functional substitutes. Apply one to send it back through the analyzer.'**
  String get chordAnalyzerVariationsBody;

  /// No description provided for @chordAnalyzerApplyVariation.
  ///
  /// In en, this message translates to:
  /// **'Use Variation'**
  String get chordAnalyzerApplyVariation;

  /// No description provided for @chordAnalyzerVariationCadentialColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadential color'**
  String get chordAnalyzerVariationCadentialColorTitle;

  /// No description provided for @chordAnalyzerVariationCadentialColorBody.
  ///
  /// In en, this message translates to:
  /// **'Darkens the predominant and swaps in a tritone dominant while keeping the same arrival.'**
  String get chordAnalyzerVariationCadentialColorBody;

  /// No description provided for @chordAnalyzerVariationBackdoorTitle.
  ///
  /// In en, this message translates to:
  /// **'Backdoor color'**
  String get chordAnalyzerVariationBackdoorTitle;

  /// No description provided for @chordAnalyzerVariationBackdoorBody.
  ///
  /// In en, this message translates to:
  /// **'Uses ivm7-bVII7 color from the parallel minor before landing on the same tonic.'**
  String get chordAnalyzerVariationBackdoorBody;

  /// No description provided for @chordAnalyzerVariationAppliedApproachTitle.
  ///
  /// In en, this message translates to:
  /// **'Targeted ii-V'**
  String get chordAnalyzerVariationAppliedApproachTitle;

  /// No description provided for @chordAnalyzerVariationAppliedApproachBody.
  ///
  /// In en, this message translates to:
  /// **'Builds a related ii-V that still points to the same destination chord.'**
  String get chordAnalyzerVariationAppliedApproachBody;

  /// No description provided for @chordAnalyzerVariationMinorCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Minor cadence color'**
  String get chordAnalyzerVariationMinorCadenceTitle;

  /// No description provided for @chordAnalyzerVariationMinorCadenceBody.
  ///
  /// In en, this message translates to:
  /// **'Keeps the minor cadence intact but leans into ii첩-Valt-i color.'**
  String get chordAnalyzerVariationMinorCadenceBody;

  /// No description provided for @chordAnalyzerVariationColorLiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Color lift'**
  String get chordAnalyzerVariationColorLiftTitle;

  /// No description provided for @chordAnalyzerVariationColorLiftBody.
  ///
  /// In en, this message translates to:
  /// **'Keeps the roots and functions close, but upgrades the chords with natural extensions.'**
  String get chordAnalyzerVariationColorLiftBody;

  /// No description provided for @chordAnalyzerParserDiagnosticWarning.
  ///
  /// In en, this message translates to:
  /// **'Input warning: {details}'**
  String chordAnalyzerParserDiagnosticWarning(Object details);

  /// No description provided for @chordAnalyzerDiagnosticUnbalancedParentheses.
  ///
  /// In en, this message translates to:
  /// **'Unbalanced parentheses left part of the symbol uncertain.'**
  String get chordAnalyzerDiagnosticUnbalancedParentheses;

  /// No description provided for @chordAnalyzerDiagnosticUnexpectedCloseParenthesis.
  ///
  /// In en, this message translates to:
  /// **'An unexpected closing parenthesis was ignored.'**
  String get chordAnalyzerDiagnosticUnexpectedCloseParenthesis;

  /// No description provided for @chordAnalyzerEvidenceExtensionColor.
  ///
  /// In en, this message translates to:
  /// **'Explicit {extension} color strengthens this reading.'**
  String chordAnalyzerEvidenceExtensionColor(Object extension);

  /// No description provided for @chordAnalyzerEvidenceAlteredDominantColor.
  ///
  /// In en, this message translates to:
  /// **'Altered dominant color supports a dominant function.'**
  String get chordAnalyzerEvidenceAlteredDominantColor;

  /// No description provided for @chordAnalyzerEvidenceSlashBass.
  ///
  /// In en, this message translates to:
  /// **'Slash bass {bass} keeps the bass line or inversion meaningful.'**
  String chordAnalyzerEvidenceSlashBass(Object bass);

  /// No description provided for @chordAnalyzerEvidenceResolution.
  ///
  /// In en, this message translates to:
  /// **'The next chord supports a resolution toward {target}.'**
  String chordAnalyzerEvidenceResolution(Object target);

  /// No description provided for @chordAnalyzerEvidenceBorrowedColor.
  ///
  /// In en, this message translates to:
  /// **'This color can be heard as borrowed from the parallel mode.'**
  String get chordAnalyzerEvidenceBorrowedColor;

  /// No description provided for @chordAnalyzerEvidenceSuspensionColor.
  ///
  /// In en, this message translates to:
  /// **'Suspension color softens the dominant pull without erasing it.'**
  String get chordAnalyzerEvidenceSuspensionColor;

  /// No description provided for @chordAnalyzerLowConfidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Low-confidence reading'**
  String get chordAnalyzerLowConfidenceTitle;

  /// No description provided for @chordAnalyzerLowConfidenceBody.
  ///
  /// In en, this message translates to:
  /// **'The key candidates are close together or some symbols were only partially recovered, so treat this as a cautious first pass.'**
  String get chordAnalyzerLowConfidenceBody;

  /// No description provided for @chordAnalyzerEmptyMeasure.
  ///
  /// In en, this message translates to:
  /// **'This measure is empty and was preserved in the count.'**
  String get chordAnalyzerEmptyMeasure;

  /// No description provided for @chordAnalyzerNoAnalyzableChordsInMeasure.
  ///
  /// In en, this message translates to:
  /// **'No analyzable chord symbols were recovered in this measure.'**
  String get chordAnalyzerNoAnalyzableChordsInMeasure;

  /// No description provided for @chordAnalyzerParseIssuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Parse issues'**
  String get chordAnalyzerParseIssuesTitle;

  /// No description provided for @chordAnalyzerParseIssueLine.
  ///
  /// In en, this message translates to:
  /// **'{token}: {reason}'**
  String chordAnalyzerParseIssueLine(Object token, Object reason);

  /// No description provided for @chordAnalyzerParseIssueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty token.'**
  String get chordAnalyzerParseIssueEmpty;

  /// No description provided for @chordAnalyzerParseIssueInvalidRoot.
  ///
  /// In en, this message translates to:
  /// **'The root could not be recognized.'**
  String get chordAnalyzerParseIssueInvalidRoot;

  /// No description provided for @chordAnalyzerParseIssueUnknownRoot.
  ///
  /// In en, this message translates to:
  /// **'{root} is not a supported root spelling.'**
  String chordAnalyzerParseIssueUnknownRoot(Object root);

  /// No description provided for @chordAnalyzerParseIssueInvalidBass.
  ///
  /// In en, this message translates to:
  /// **'Slash bass {bass} is not a supported bass spelling.'**
  String chordAnalyzerParseIssueInvalidBass(Object bass);

  /// No description provided for @chordAnalyzerParseIssueUnsupportedSuffix.
  ///
  /// In en, this message translates to:
  /// **'Unsupported suffix or modifier: {suffix}'**
  String chordAnalyzerParseIssueUnsupportedSuffix(Object suffix);

  /// No description provided for @chordAnalyzerDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Analysis display'**
  String get chordAnalyzerDisplaySettings;

  /// No description provided for @chordAnalyzerDisplaySettingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how much theory detail appears and how non-diatonic categories are highlighted.'**
  String get chordAnalyzerDisplaySettingsHelp;

  /// No description provided for @chordAnalyzerQuickStartHint.
  ///
  /// In en, this message translates to:
  /// **'Tap an example to see instant results, or press Ctrl+Enter on desktop to analyze.'**
  String get chordAnalyzerQuickStartHint;

  /// No description provided for @chordAnalyzerDetailLevel.
  ///
  /// In en, this message translates to:
  /// **'Explanation detail'**
  String get chordAnalyzerDetailLevel;

  /// No description provided for @chordAnalyzerDetailLevelConcise.
  ///
  /// In en, this message translates to:
  /// **'Concise'**
  String get chordAnalyzerDetailLevelConcise;

  /// No description provided for @chordAnalyzerDetailLevelDetailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get chordAnalyzerDetailLevelDetailed;

  /// No description provided for @chordAnalyzerDetailLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get chordAnalyzerDetailLevelAdvanced;

  /// No description provided for @chordAnalyzerHighlightTheme.
  ///
  /// In en, this message translates to:
  /// **'Highlight theme'**
  String get chordAnalyzerHighlightTheme;

  /// No description provided for @chordAnalyzerThemePresetDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get chordAnalyzerThemePresetDefault;

  /// No description provided for @chordAnalyzerThemePresetHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get chordAnalyzerThemePresetHighContrast;

  /// No description provided for @chordAnalyzerThemePresetColorBlindSafe.
  ///
  /// In en, this message translates to:
  /// **'Color-blind safe'**
  String get chordAnalyzerThemePresetColorBlindSafe;

  /// No description provided for @chordAnalyzerThemePresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get chordAnalyzerThemePresetCustom;

  /// No description provided for @chordAnalyzerThemeLegend.
  ///
  /// In en, this message translates to:
  /// **'Category legend'**
  String get chordAnalyzerThemeLegend;

  /// No description provided for @chordAnalyzerCustomColors.
  ///
  /// In en, this message translates to:
  /// **'Custom category colors'**
  String get chordAnalyzerCustomColors;

  /// No description provided for @chordAnalyzerHighlightAppliedDominant.
  ///
  /// In en, this message translates to:
  /// **'Applied dominant'**
  String get chordAnalyzerHighlightAppliedDominant;

  /// No description provided for @chordAnalyzerHighlightTritoneSubstitute.
  ///
  /// In en, this message translates to:
  /// **'Tritone substitute'**
  String get chordAnalyzerHighlightTritoneSubstitute;

  /// No description provided for @chordAnalyzerHighlightTonicization.
  ///
  /// In en, this message translates to:
  /// **'Tonicization'**
  String get chordAnalyzerHighlightTonicization;

  /// No description provided for @chordAnalyzerHighlightModulation.
  ///
  /// In en, this message translates to:
  /// **'Modulation'**
  String get chordAnalyzerHighlightModulation;

  /// No description provided for @chordAnalyzerHighlightBackdoor.
  ///
  /// In en, this message translates to:
  /// **'Backdoor / subdominant minor'**
  String get chordAnalyzerHighlightBackdoor;

  /// No description provided for @chordAnalyzerHighlightBorrowedColor.
  ///
  /// In en, this message translates to:
  /// **'Borrowed color'**
  String get chordAnalyzerHighlightBorrowedColor;

  /// No description provided for @chordAnalyzerHighlightCommonTone.
  ///
  /// In en, this message translates to:
  /// **'Common-tone motion'**
  String get chordAnalyzerHighlightCommonTone;

  /// No description provided for @chordAnalyzerHighlightDeceptiveCadence.
  ///
  /// In en, this message translates to:
  /// **'Deceptive cadence'**
  String get chordAnalyzerHighlightDeceptiveCadence;

  /// No description provided for @chordAnalyzerHighlightChromaticLine.
  ///
  /// In en, this message translates to:
  /// **'Chromatic line color'**
  String get chordAnalyzerHighlightChromaticLine;

  /// No description provided for @chordAnalyzerHighlightAmbiguity.
  ///
  /// In en, this message translates to:
  /// **'Ambiguity'**
  String get chordAnalyzerHighlightAmbiguity;

  /// No description provided for @chordAnalyzerSummaryRealModulation.
  ///
  /// In en, this message translates to:
  /// **'It makes a stronger case for a real modulation toward {key}.'**
  String chordAnalyzerSummaryRealModulation(Object key);

  /// No description provided for @chordAnalyzerSummaryTonicization.
  ///
  /// In en, this message translates to:
  /// **'It briefly tonicizes {target} without fully settling there.'**
  String chordAnalyzerSummaryTonicization(Object target);

  /// No description provided for @chordAnalyzerSummaryBackdoor.
  ///
  /// In en, this message translates to:
  /// **'The progression leans into backdoor or subdominant-minor color before resolving.'**
  String get chordAnalyzerSummaryBackdoor;

  /// No description provided for @chordAnalyzerSummaryDeceptiveCadence.
  ///
  /// In en, this message translates to:
  /// **'One cadence sidesteps the expected tonic for a deceptive effect.'**
  String get chordAnalyzerSummaryDeceptiveCadence;

  /// No description provided for @chordAnalyzerSummaryChromaticLine.
  ///
  /// In en, this message translates to:
  /// **'A chromatic inner-line or line-cliche color helps connect part of the phrase.'**
  String get chordAnalyzerSummaryChromaticLine;

  /// No description provided for @chordAnalyzerSummaryBackdoorDominant.
  ///
  /// In en, this message translates to:
  /// **'{chord} works like a backdoor dominant rather than a plain borrowed dominant.'**
  String chordAnalyzerSummaryBackdoorDominant(Object chord);

  /// No description provided for @chordAnalyzerSummarySubdominantMinor.
  ///
  /// In en, this message translates to:
  /// **'{chord} reads more naturally as subdominant-minor color than as a random non-diatonic chord.'**
  String chordAnalyzerSummarySubdominantMinor(Object chord);

  /// No description provided for @chordAnalyzerSummaryCommonToneDiminished.
  ///
  /// In en, this message translates to:
  /// **'{chord} can be heard as a common-tone diminished color that resolves by shared pitch content.'**
  String chordAnalyzerSummaryCommonToneDiminished(Object chord);

  /// No description provided for @chordAnalyzerSummaryDeceptiveTarget.
  ///
  /// In en, this message translates to:
  /// **'{chord} participates in a deceptive landing instead of a plain authentic cadence.'**
  String chordAnalyzerSummaryDeceptiveTarget(Object chord);

  /// No description provided for @chordAnalyzerSummaryCompeting.
  ///
  /// In en, this message translates to:
  /// **'An advanced reading keeps competing interpretations in play, such as {readings}.'**
  String chordAnalyzerSummaryCompeting(Object readings);

  /// No description provided for @chordAnalyzerFunctionLine.
  ///
  /// In en, this message translates to:
  /// **'Function: {function}'**
  String chordAnalyzerFunctionLine(Object function);

  /// No description provided for @chordAnalyzerEvidenceLead.
  ///
  /// In en, this message translates to:
  /// **'Evidence: {evidence}'**
  String chordAnalyzerEvidenceLead(Object evidence);

  /// No description provided for @chordAnalyzerAdvancedCompetingReadings.
  ///
  /// In en, this message translates to:
  /// **'Competing readings remain possible here: {readings}.'**
  String chordAnalyzerAdvancedCompetingReadings(Object readings);

  /// No description provided for @chordAnalyzerRemarkTonicization.
  ///
  /// In en, this message translates to:
  /// **'This sounds more like a local tonicization of {target} than a full modulation.'**
  String chordAnalyzerRemarkTonicization(Object target);

  /// No description provided for @chordAnalyzerRemarkRealModulation.
  ///
  /// In en, this message translates to:
  /// **'This supports a real modulation toward {key}.'**
  String chordAnalyzerRemarkRealModulation(Object key);

  /// No description provided for @chordAnalyzerRemarkBackdoorDominant.
  ///
  /// In en, this message translates to:
  /// **'This can be heard as a backdoor dominant with subdominant-minor color.'**
  String get chordAnalyzerRemarkBackdoorDominant;

  /// No description provided for @chordAnalyzerRemarkBackdoorChain.
  ///
  /// In en, this message translates to:
  /// **'This belongs to a backdoor chain rather than a plain borrowed detour.'**
  String get chordAnalyzerRemarkBackdoorChain;

  /// No description provided for @chordAnalyzerRemarkSubdominantMinor.
  ///
  /// In en, this message translates to:
  /// **'This borrowed iv or subdominant-minor color behaves like a predominant area.'**
  String get chordAnalyzerRemarkSubdominantMinor;

  /// No description provided for @chordAnalyzerRemarkCommonToneDiminished.
  ///
  /// In en, this message translates to:
  /// **'This diminished chord works through common-tone reinterpretation.'**
  String get chordAnalyzerRemarkCommonToneDiminished;

  /// No description provided for @chordAnalyzerRemarkPivotChord.
  ///
  /// In en, this message translates to:
  /// **'This chord can act as a pivot into the next local key area.'**
  String get chordAnalyzerRemarkPivotChord;

  /// No description provided for @chordAnalyzerRemarkCommonToneModulation.
  ///
  /// In en, this message translates to:
  /// **'Common-tone continuity helps the modulation feel plausible.'**
  String get chordAnalyzerRemarkCommonToneModulation;

  /// No description provided for @chordAnalyzerRemarkDeceptiveCadence.
  ///
  /// In en, this message translates to:
  /// **'This points toward a deceptive cadence rather than a direct tonic arrival.'**
  String get chordAnalyzerRemarkDeceptiveCadence;

  /// No description provided for @chordAnalyzerRemarkLineCliche.
  ///
  /// In en, this message translates to:
  /// **'Chromatic inner-line motion colors this chord choice.'**
  String get chordAnalyzerRemarkLineCliche;

  /// No description provided for @chordAnalyzerRemarkDualFunction.
  ///
  /// In en, this message translates to:
  /// **'More than one functional reading stays credible here.'**
  String get chordAnalyzerRemarkDualFunction;

  /// No description provided for @chordAnalyzerTagTonicization.
  ///
  /// In en, this message translates to:
  /// **'Tonicization'**
  String get chordAnalyzerTagTonicization;

  /// No description provided for @chordAnalyzerTagRealModulation.
  ///
  /// In en, this message translates to:
  /// **'Real modulation'**
  String get chordAnalyzerTagRealModulation;

  /// No description provided for @chordAnalyzerTagBackdoorChain.
  ///
  /// In en, this message translates to:
  /// **'Backdoor chain'**
  String get chordAnalyzerTagBackdoorChain;

  /// No description provided for @chordAnalyzerTagDeceptiveCadence.
  ///
  /// In en, this message translates to:
  /// **'Deceptive cadence'**
  String get chordAnalyzerTagDeceptiveCadence;

  /// No description provided for @chordAnalyzerTagChromaticLine.
  ///
  /// In en, this message translates to:
  /// **'Chromatic line color'**
  String get chordAnalyzerTagChromaticLine;

  /// No description provided for @chordAnalyzerTagCommonToneMotion.
  ///
  /// In en, this message translates to:
  /// **'Common-tone motion'**
  String get chordAnalyzerTagCommonToneMotion;

  /// No description provided for @chordAnalyzerEvidenceCadentialArrival.
  ///
  /// In en, this message translates to:
  /// **'A local cadential arrival supports hearing a temporary target.'**
  String get chordAnalyzerEvidenceCadentialArrival;

  /// No description provided for @chordAnalyzerEvidenceFollowThrough.
  ///
  /// In en, this message translates to:
  /// **'Follow-through chords continue to support the new local center.'**
  String get chordAnalyzerEvidenceFollowThrough;

  /// No description provided for @chordAnalyzerEvidencePhraseBoundary.
  ///
  /// In en, this message translates to:
  /// **'The change lands near a phrase boundary or structural accent.'**
  String get chordAnalyzerEvidencePhraseBoundary;

  /// No description provided for @chordAnalyzerEvidencePivotSupport.
  ///
  /// In en, this message translates to:
  /// **'A pivot-like shared reading supports the local shift.'**
  String get chordAnalyzerEvidencePivotSupport;

  /// No description provided for @chordAnalyzerEvidenceCommonToneSupport.
  ///
  /// In en, this message translates to:
  /// **'Shared common tones help connect the reinterpretation.'**
  String get chordAnalyzerEvidenceCommonToneSupport;

  /// No description provided for @chordAnalyzerEvidenceHomeGravityWeakening.
  ///
  /// In en, this message translates to:
  /// **'The original tonic loses some of its pull in this window.'**
  String get chordAnalyzerEvidenceHomeGravityWeakening;

  /// No description provided for @chordAnalyzerEvidenceBackdoorMotion.
  ///
  /// In en, this message translates to:
  /// **'The motion matches a backdoor or subdominant-minor resolution pattern.'**
  String get chordAnalyzerEvidenceBackdoorMotion;

  /// No description provided for @chordAnalyzerEvidenceDeceptiveResolution.
  ///
  /// In en, this message translates to:
  /// **'The dominant resolves away from the expected tonic target.'**
  String get chordAnalyzerEvidenceDeceptiveResolution;

  /// No description provided for @chordAnalyzerEvidenceChromaticLine.
  ///
  /// In en, this message translates to:
  /// **'Chromatic line support: {detail}.'**
  String chordAnalyzerEvidenceChromaticLine(Object detail);

  /// No description provided for @chordAnalyzerEvidenceCompetingReading.
  ///
  /// In en, this message translates to:
  /// **'Competing reading: {detail}.'**
  String chordAnalyzerEvidenceCompetingReading(Object detail);

  /// No description provided for @studyHarmonyDailyReplayAction.
  ///
  /// In en, this message translates to:
  /// **'Replay daily'**
  String get studyHarmonyDailyReplayAction;

  /// No description provided for @studyHarmonyMilestoneCabinetTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone Medals'**
  String get studyHarmonyMilestoneCabinetTitle;

  /// No description provided for @studyHarmonyMilestoneLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pathfinder Medal'**
  String get studyHarmonyMilestoneLessonsTitle;

  /// No description provided for @studyHarmonyMilestoneLessonsBody.
  ///
  /// In en, this message translates to:
  /// **'Clear {target} lessons in Core Foundations.'**
  String studyHarmonyMilestoneLessonsBody(Object target);

  /// No description provided for @studyHarmonyMilestoneStarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Star Collector'**
  String get studyHarmonyMilestoneStarsTitle;

  /// No description provided for @studyHarmonyMilestoneStarsBody.
  ///
  /// In en, this message translates to:
  /// **'Collect {target} stars across Study Harmony.'**
  String studyHarmonyMilestoneStarsBody(Object target);

  /// No description provided for @studyHarmonyMilestoneStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak Legend'**
  String get studyHarmonyMilestoneStreakTitle;

  /// No description provided for @studyHarmonyMilestoneStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Reach a best daily streak of {target}.'**
  String studyHarmonyMilestoneStreakBody(Object target);

  /// No description provided for @studyHarmonyMilestoneMasteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Mastery Scholar'**
  String get studyHarmonyMilestoneMasteryTitle;

  /// No description provided for @studyHarmonyMilestoneMasteryBody.
  ///
  /// In en, this message translates to:
  /// **'Master {target} skills.'**
  String studyHarmonyMilestoneMasteryBody(Object target);

  /// No description provided for @studyHarmonyMilestoneEarnedLabel.
  ///
  /// In en, this message translates to:
  /// **'{earned}/{total} medals earned'**
  String studyHarmonyMilestoneEarnedLabel(Object earned, Object total);

  /// No description provided for @studyHarmonyMilestoneCompletedTag.
  ///
  /// In en, this message translates to:
  /// **'Cabinet complete'**
  String get studyHarmonyMilestoneCompletedTag;

  /// No description provided for @studyHarmonyMilestoneTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze Medal'**
  String get studyHarmonyMilestoneTierBronze;

  /// No description provided for @studyHarmonyMilestoneTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Medal'**
  String get studyHarmonyMilestoneTierSilver;

  /// No description provided for @studyHarmonyMilestoneTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Medal'**
  String get studyHarmonyMilestoneTierGold;

  /// No description provided for @studyHarmonyMilestoneTierPlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum Medal'**
  String get studyHarmonyMilestoneTierPlatinum;

  /// No description provided for @studyHarmonyMilestoneUnlockedLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier} {title}'**
  String studyHarmonyMilestoneUnlockedLabel(Object title, Object tier);

  /// No description provided for @studyHarmonyResultMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'New medals'**
  String get studyHarmonyResultMilestonesTitle;

  /// No description provided for @studyHarmonyChapterRemixTitle.
  ///
  /// In en, this message translates to:
  /// **'Remix Arena'**
  String get studyHarmonyChapterRemixTitle;

  /// No description provided for @studyHarmonyChapterRemixDescription.
  ///
  /// In en, this message translates to:
  /// **'Longer mixed sets that shuffle key center, function, and borrowed color without warning.'**
  String get studyHarmonyChapterRemixDescription;

  /// No description provided for @studyHarmonyLessonRemixBridgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Bridge Builder'**
  String get studyHarmonyLessonRemixBridgeTitle;

  /// No description provided for @studyHarmonyLessonRemixBridgeDescription.
  ///
  /// In en, this message translates to:
  /// **'Stitch function reads and missing-chord fills into one flowing chain.'**
  String get studyHarmonyLessonRemixBridgeDescription;

  /// No description provided for @studyHarmonyLessonRemixPivotTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Pivot'**
  String get studyHarmonyLessonRemixPivotTitle;

  /// No description provided for @studyHarmonyLessonRemixPivotDescription.
  ///
  /// In en, this message translates to:
  /// **'Track borrowed color and key-center pivots as the progression shifts underneath you.'**
  String get studyHarmonyLessonRemixPivotDescription;

  /// No description provided for @studyHarmonyLessonRemixSprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolution Sprint'**
  String get studyHarmonyLessonRemixSprintTitle;

  /// No description provided for @studyHarmonyLessonRemixSprintDescription.
  ///
  /// In en, this message translates to:
  /// **'Read function, cadence fill, and tonal gravity back-to-back at a quicker pace.'**
  String get studyHarmonyLessonRemixSprintDescription;

  /// No description provided for @studyHarmonyLessonRemixBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Remix Marathon'**
  String get studyHarmonyLessonRemixBossTitle;

  /// No description provided for @studyHarmonyLessonRemixBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A final mixed marathon that throws every progression-reading lens back into the set.'**
  String get studyHarmonyLessonRemixBossDescription;

  /// No description provided for @studyHarmonyProgressStreakSaver.
  ///
  /// In en, this message translates to:
  /// **'Savers x{count}'**
  String studyHarmonyProgressStreakSaver(Object count);

  /// No description provided for @studyHarmonyProgressLegendCrowns.
  ///
  /// In en, this message translates to:
  /// **'Legend crowns {count}'**
  String studyHarmonyProgressLegendCrowns(Object count);

  /// No description provided for @studyHarmonyModeFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get studyHarmonyModeFocus;

  /// No description provided for @studyHarmonyModeLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend Trial'**
  String get studyHarmonyModeLegend;

  /// No description provided for @studyHarmonyFocusCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Sprint'**
  String get studyHarmonyFocusCardTitle;

  /// No description provided for @studyHarmonyFocusCardHint.
  ///
  /// In en, this message translates to:
  /// **'Target the weakest overlap in your current path with fewer lives and tighter goals.'**
  String get studyHarmonyFocusCardHint;

  /// No description provided for @studyHarmonyFocusFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'Run a harder mixed drill to pressure-test your current weak spots.'**
  String get studyHarmonyFocusFallbackHint;

  /// No description provided for @studyHarmonyFocusAction.
  ///
  /// In en, this message translates to:
  /// **'Start sprint'**
  String get studyHarmonyFocusAction;

  /// No description provided for @studyHarmonyFocusSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Sprint'**
  String get studyHarmonyFocusSessionTitle;

  /// No description provided for @studyHarmonyFocusSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'A tighter mixed sprint built from the weakest spots around {chapter}.'**
  String studyHarmonyFocusSessionDescription(Object chapter);

  /// No description provided for @studyHarmonyFocusMixLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons mixed'**
  String studyHarmonyFocusMixLabel(Object count);

  /// No description provided for @studyHarmonyFocusRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly saver reward'**
  String get studyHarmonyFocusRewardLabel;

  /// No description provided for @studyHarmonyLegendCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Legend Trial'**
  String get studyHarmonyLegendCardTitle;

  /// No description provided for @studyHarmonyLegendCardHint.
  ///
  /// In en, this message translates to:
  /// **'Replay a silver-or-better chapter as a two-life mastery run to secure a legend crown.'**
  String get studyHarmonyLegendCardHint;

  /// No description provided for @studyHarmonyLegendFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'Finish a chapter and push it to about 2 stars per lesson to unlock a Legend Trial.'**
  String get studyHarmonyLegendFallbackHint;

  /// No description provided for @studyHarmonyLegendAction.
  ///
  /// In en, this message translates to:
  /// **'Chase legend'**
  String get studyHarmonyLegendAction;

  /// No description provided for @studyHarmonyLegendSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Legend Trial'**
  String get studyHarmonyLegendSessionTitle;

  /// No description provided for @studyHarmonyLegendSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'A no-slack mastery replay of {chapter} built to secure its legend crown.'**
  String studyHarmonyLegendSessionDescription(Object chapter);

  /// No description provided for @studyHarmonyLegendMixLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons chained'**
  String studyHarmonyLegendMixLabel(Object count);

  /// No description provided for @studyHarmonyLegendRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Legend crown at stake'**
  String get studyHarmonyLegendRiskLabel;

  /// No description provided for @studyHarmonyWeeklyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Training Plan'**
  String get studyHarmonyWeeklyPlanTitle;

  /// No description provided for @studyHarmonyWeeklyRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward: Streak Saver'**
  String get studyHarmonyWeeklyRewardLabel;

  /// No description provided for @studyHarmonyWeeklyRewardReadyTag.
  ///
  /// In en, this message translates to:
  /// **'Reward ready'**
  String get studyHarmonyWeeklyRewardReadyTag;

  /// No description provided for @studyHarmonyWeeklyRewardClaimedTag.
  ///
  /// In en, this message translates to:
  /// **'Reward claimed'**
  String get studyHarmonyWeeklyRewardClaimedTag;

  /// No description provided for @studyHarmonyWeeklyGoalActiveDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Show up on multiple days'**
  String get studyHarmonyWeeklyGoalActiveDaysTitle;

  /// No description provided for @studyHarmonyWeeklyGoalActiveDaysBody.
  ///
  /// In en, this message translates to:
  /// **'Be active on {target} different days this week.'**
  String studyHarmonyWeeklyGoalActiveDaysBody(Object target);

  /// No description provided for @studyHarmonyWeeklyGoalDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the daily loop alive'**
  String get studyHarmonyWeeklyGoalDailyTitle;

  /// No description provided for @studyHarmonyWeeklyGoalDailyBody.
  ///
  /// In en, this message translates to:
  /// **'Log {target} daily clears this week.'**
  String studyHarmonyWeeklyGoalDailyBody(Object target);

  /// No description provided for @studyHarmonyWeeklyGoalFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish a Focus Sprint'**
  String get studyHarmonyWeeklyGoalFocusTitle;

  /// No description provided for @studyHarmonyWeeklyGoalFocusBody.
  ///
  /// In en, this message translates to:
  /// **'Complete {target} Focus Sprints this week.'**
  String studyHarmonyWeeklyGoalFocusBody(Object target);

  /// No description provided for @studyHarmonyResultStreakSaverUsedLine.
  ///
  /// In en, this message translates to:
  /// **'Streak Saver used to protect yesterday.'**
  String get studyHarmonyResultStreakSaverUsedLine;

  /// No description provided for @studyHarmonyResultStreakSaverEarnedLine.
  ///
  /// In en, this message translates to:
  /// **'New Streak Saver earned. Inventory: {count}'**
  String studyHarmonyResultStreakSaverEarnedLine(Object count);

  /// No description provided for @studyHarmonyResultFocusSprintLine.
  ///
  /// In en, this message translates to:
  /// **'Focus Sprint cleared.'**
  String get studyHarmonyResultFocusSprintLine;

  /// No description provided for @studyHarmonyResultLegendLine.
  ///
  /// In en, this message translates to:
  /// **'Legend crown secured for {chapter}.'**
  String studyHarmonyResultLegendLine(Object chapter);

  /// No description provided for @studyHarmonyChapterEncoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Encore Ladder'**
  String get studyHarmonyChapterEncoreTitle;

  /// No description provided for @studyHarmonyChapterEncoreDescription.
  ///
  /// In en, this message translates to:
  /// **'A short finishing ladder that compresses the whole progression toolkit into a final encore set.'**
  String get studyHarmonyChapterEncoreDescription;

  /// No description provided for @studyHarmonyLessonEncorePulseTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonal Pulse'**
  String get studyHarmonyLessonEncorePulseTitle;

  /// No description provided for @studyHarmonyLessonEncorePulseDescription.
  ///
  /// In en, this message translates to:
  /// **'Lock in tonal center and function without any warm-up prompts.'**
  String get studyHarmonyLessonEncorePulseDescription;

  /// No description provided for @studyHarmonyLessonEncoreSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Swap'**
  String get studyHarmonyLessonEncoreSwapTitle;

  /// No description provided for @studyHarmonyLessonEncoreSwapDescription.
  ///
  /// In en, this message translates to:
  /// **'Alternate borrowed color calls with missing-chord restoration to keep the ear honest.'**
  String get studyHarmonyLessonEncoreSwapDescription;

  /// No description provided for @studyHarmonyLessonEncoreBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Encore Finale'**
  String get studyHarmonyLessonEncoreBossTitle;

  /// No description provided for @studyHarmonyLessonEncoreBossDescription.
  ///
  /// In en, this message translates to:
  /// **'One last compact boss round that checks every progression lens in quick succession.'**
  String get studyHarmonyLessonEncoreBossDescription;

  /// No description provided for @studyHarmonyChapterMasteryBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze Clear'**
  String get studyHarmonyChapterMasteryBronze;

  /// No description provided for @studyHarmonyChapterMasterySilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Crown'**
  String get studyHarmonyChapterMasterySilver;

  /// No description provided for @studyHarmonyChapterMasteryGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Crown'**
  String get studyHarmonyChapterMasteryGold;

  /// No description provided for @studyHarmonyChapterMasteryLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legend Crown'**
  String get studyHarmonyChapterMasteryLegendary;

  /// No description provided for @studyHarmonyModeBossRush.
  ///
  /// In en, this message translates to:
  /// **'Boss Rush Mode'**
  String get studyHarmonyModeBossRush;

  /// No description provided for @studyHarmonyBossRushCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss Rush'**
  String get studyHarmonyBossRushCardTitle;

  /// No description provided for @studyHarmonyBossRushCardHint.
  ///
  /// In en, this message translates to:
  /// **'Chain together the unlocked boss lessons with fewer lives and a bigger score ceiling.'**
  String get studyHarmonyBossRushCardHint;

  /// No description provided for @studyHarmonyBossRushFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'Unlock at least two boss lessons to open a real mixed boss run.'**
  String get studyHarmonyBossRushFallbackHint;

  /// No description provided for @studyHarmonyBossRushAction.
  ///
  /// In en, this message translates to:
  /// **'Start rush'**
  String get studyHarmonyBossRushAction;

  /// No description provided for @studyHarmonyBossRushSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Boss Rush'**
  String get studyHarmonyBossRushSessionTitle;

  /// No description provided for @studyHarmonyBossRushSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'A high-pressure boss gauntlet built from the unlocked boss lessons around {chapter}.'**
  String studyHarmonyBossRushSessionDescription(Object chapter);

  /// No description provided for @studyHarmonyBossRushMixLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} boss lessons mixed'**
  String studyHarmonyBossRushMixLabel(Object count);

  /// No description provided for @studyHarmonyBossRushHighRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'2 lives only'**
  String get studyHarmonyBossRushHighRiskLabel;

  /// No description provided for @studyHarmonyResultBossRushLine.
  ///
  /// In en, this message translates to:
  /// **'Boss Rush cleared.'**
  String get studyHarmonyResultBossRushLine;

  /// No description provided for @studyHarmonyChapterSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Spotlight Showdown'**
  String get studyHarmonyChapterSpotlightTitle;

  /// No description provided for @studyHarmonyChapterSpotlightDescription.
  ///
  /// In en, this message translates to:
  /// **'A final spotlight set that isolates borrowed color, cadence pressure, and boss-level integration.'**
  String get studyHarmonyChapterSpotlightDescription;

  /// No description provided for @studyHarmonyLessonSpotlightLensTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Lens'**
  String get studyHarmonyLessonSpotlightLensTitle;

  /// No description provided for @studyHarmonyLessonSpotlightLensDescription.
  ///
  /// In en, this message translates to:
  /// **'Track key center while borrowed color keeps trying to pull your read sideways.'**
  String get studyHarmonyLessonSpotlightLensDescription;

  /// No description provided for @studyHarmonyLessonSpotlightCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadence Swap'**
  String get studyHarmonyLessonSpotlightCadenceTitle;

  /// No description provided for @studyHarmonyLessonSpotlightCadenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch between function reading and cadence restoration without losing the landing point.'**
  String get studyHarmonyLessonSpotlightCadenceDescription;

  /// No description provided for @studyHarmonyLessonSpotlightBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Spotlight Showdown'**
  String get studyHarmonyLessonSpotlightBossTitle;

  /// No description provided for @studyHarmonyLessonSpotlightBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A closing boss set that forces every progression lens to stay sharp under pressure.'**
  String get studyHarmonyLessonSpotlightBossDescription;

  /// No description provided for @studyHarmonyChapterAfterHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'After Hours Lab'**
  String get studyHarmonyChapterAfterHoursTitle;

  /// No description provided for @studyHarmonyChapterAfterHoursDescription.
  ///
  /// In en, this message translates to:
  /// **'A late-game lab that strips away warm-up clues and mixes borrowed color, cadence pressure, and center tracking.'**
  String get studyHarmonyChapterAfterHoursDescription;

  /// No description provided for @studyHarmonyLessonAfterHoursShadowTitle.
  ///
  /// In en, this message translates to:
  /// **'Modal Shadow'**
  String get studyHarmonyLessonAfterHoursShadowTitle;

  /// No description provided for @studyHarmonyLessonAfterHoursShadowDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep hold of the key center while borrowed color keeps dragging the read into the dark.'**
  String get studyHarmonyLessonAfterHoursShadowDescription;

  /// No description provided for @studyHarmonyLessonAfterHoursFeintTitle.
  ///
  /// In en, this message translates to:
  /// **'Resolution Feint'**
  String get studyHarmonyLessonAfterHoursFeintTitle;

  /// No description provided for @studyHarmonyLessonAfterHoursFeintDescription.
  ///
  /// In en, this message translates to:
  /// **'Catch function and cadence fakeouts before the phrase slips past its true landing spot.'**
  String get studyHarmonyLessonAfterHoursFeintDescription;

  /// No description provided for @studyHarmonyLessonAfterHoursCrossfadeTitle.
  ///
  /// In en, this message translates to:
  /// **'Center Crossfade'**
  String get studyHarmonyLessonAfterHoursCrossfadeTitle;

  /// No description provided for @studyHarmonyLessonAfterHoursCrossfadeDescription.
  ///
  /// In en, this message translates to:
  /// **'Blend center detection, function reading, and missing-chord repair without any extra scaffolding.'**
  String get studyHarmonyLessonAfterHoursCrossfadeDescription;

  /// No description provided for @studyHarmonyLessonAfterHoursBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Call Boss'**
  String get studyHarmonyLessonAfterHoursBossTitle;

  /// No description provided for @studyHarmonyLessonAfterHoursBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A final late-night boss set that asks every progression lens to stay clear under pressure.'**
  String get studyHarmonyLessonAfterHoursBossDescription;

  /// No description provided for @studyHarmonyProgressRelayWins.
  ///
  /// In en, this message translates to:
  /// **'Relay wins {count}'**
  String studyHarmonyProgressRelayWins(Object count);

  /// No description provided for @studyHarmonyModeRelay.
  ///
  /// In en, this message translates to:
  /// **'Arena Relay'**
  String get studyHarmonyModeRelay;

  /// No description provided for @studyHarmonyRelayCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Arena Relay'**
  String get studyHarmonyRelayCardTitle;

  /// No description provided for @studyHarmonyRelayCardHint.
  ///
  /// In en, this message translates to:
  /// **'Interleave unlocked lessons from different chapters into one mixed run that tests fast switching as much as raw recall.'**
  String get studyHarmonyRelayCardHint;

  /// No description provided for @studyHarmonyRelayFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'Unlock at least two chapters to open Arena Relay.'**
  String get studyHarmonyRelayFallbackHint;

  /// No description provided for @studyHarmonyRelayAction.
  ///
  /// In en, this message translates to:
  /// **'Start relay'**
  String get studyHarmonyRelayAction;

  /// No description provided for @studyHarmonyRelaySessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Arena Relay'**
  String get studyHarmonyRelaySessionTitle;

  /// No description provided for @studyHarmonyRelaySessionDescription.
  ///
  /// In en, this message translates to:
  /// **'An interleaved relay run mixing unlocked chapters around {chapter}.'**
  String studyHarmonyRelaySessionDescription(Object chapter);

  /// No description provided for @studyHarmonyRelayMixLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons relayed'**
  String studyHarmonyRelayMixLabel(Object count);

  /// No description provided for @studyHarmonyRelayChapterSpreadLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} chapters mixed'**
  String studyHarmonyRelayChapterSpreadLabel(Object count);

  /// No description provided for @studyHarmonyRelayChainLabel.
  ///
  /// In en, this message translates to:
  /// **'Interleaving under pressure'**
  String get studyHarmonyRelayChainLabel;

  /// No description provided for @studyHarmonyResultRelayLine.
  ///
  /// In en, this message translates to:
  /// **'Relay wins {count}'**
  String studyHarmonyResultRelayLine(Object count);

  /// No description provided for @studyHarmonyMilestoneRelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Relay Runner'**
  String get studyHarmonyMilestoneRelayTitle;

  /// No description provided for @studyHarmonyMilestoneRelayBody.
  ///
  /// In en, this message translates to:
  /// **'Clear {target} Arena Relay runs.'**
  String studyHarmonyMilestoneRelayBody(Object target);

  /// No description provided for @studyHarmonyChapterNeonTitle.
  ///
  /// In en, this message translates to:
  /// **'Neon Detours'**
  String get studyHarmonyChapterNeonTitle;

  /// No description provided for @studyHarmonyChapterNeonDescription.
  ///
  /// In en, this message translates to:
  /// **'A late-game chapter that keeps bending the path with borrowed color, pivot pressure, and recovery reads.'**
  String get studyHarmonyChapterNeonDescription;

  /// No description provided for @studyHarmonyLessonNeonDetourTitle.
  ///
  /// In en, this message translates to:
  /// **'Modal Detour'**
  String get studyHarmonyLessonNeonDetourTitle;

  /// No description provided for @studyHarmonyLessonNeonDetourDescription.
  ///
  /// In en, this message translates to:
  /// **'Track the true center even while borrowed color keeps shoving the phrase into a side street.'**
  String get studyHarmonyLessonNeonDetourDescription;

  /// No description provided for @studyHarmonyLessonNeonPivotTitle.
  ///
  /// In en, this message translates to:
  /// **'Pivot Pressure'**
  String get studyHarmonyLessonNeonPivotTitle;

  /// No description provided for @studyHarmonyLessonNeonPivotDescription.
  ///
  /// In en, this message translates to:
  /// **'Read center shifts and function pressure back to back before the harmonic lane changes again.'**
  String get studyHarmonyLessonNeonPivotDescription;

  /// No description provided for @studyHarmonyLessonNeonLandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Landing'**
  String get studyHarmonyLessonNeonLandingTitle;

  /// No description provided for @studyHarmonyLessonNeonLandingDescription.
  ///
  /// In en, this message translates to:
  /// **'Repair the missing landing chord after a borrowed-color fakeout changes the expected resolution.'**
  String get studyHarmonyLessonNeonLandingDescription;

  /// No description provided for @studyHarmonyLessonNeonBossTitle.
  ///
  /// In en, this message translates to:
  /// **'City Lights Boss'**
  String get studyHarmonyLessonNeonBossTitle;

  /// No description provided for @studyHarmonyLessonNeonBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A closing neon boss that mixes pivot reads, borrowed color, and cadence recovery without a soft landing.'**
  String get studyHarmonyLessonNeonBossDescription;

  /// No description provided for @studyHarmonyProgressLeague.
  ///
  /// In en, this message translates to:
  /// **'{tier} league'**
  String studyHarmonyProgressLeague(Object tier);

  /// No description provided for @studyHarmonyLeagueCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Harmony League'**
  String get studyHarmonyLeagueCardTitle;

  /// No description provided for @studyHarmonyLeagueCardHint.
  ///
  /// In en, this message translates to:
  /// **'Push toward {tier} league this week. The cleanest boost right now is {mode}.'**
  String studyHarmonyLeagueCardHint(Object tier, Object mode);

  /// No description provided for @studyHarmonyLeagueCardHintMax.
  ///
  /// In en, this message translates to:
  /// **'Diamond is secured for this week. Keep chaining high-pressure clears to hold the pace.'**
  String get studyHarmonyLeagueCardHintMax;

  /// No description provided for @studyHarmonyLeagueFallbackHint.
  ///
  /// In en, this message translates to:
  /// **'Your league climb will light up once there is a recommended run to push this week.'**
  String get studyHarmonyLeagueFallbackHint;

  /// No description provided for @studyHarmonyLeagueAction.
  ///
  /// In en, this message translates to:
  /// **'Climb league'**
  String get studyHarmonyLeagueAction;

  /// No description provided for @studyHarmonyHubStartHereTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Here'**
  String get studyHarmonyHubStartHereTitle;

  /// No description provided for @studyHarmonyHubNextLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get studyHarmonyHubNextLessonTitle;

  /// No description provided for @studyHarmonyHubWhyItMattersTitle.
  ///
  /// In en, this message translates to:
  /// **'Why It Matters'**
  String get studyHarmonyHubWhyItMattersTitle;

  /// No description provided for @studyHarmonyHubQuickPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Practice'**
  String get studyHarmonyHubQuickPracticeTitle;

  /// No description provided for @studyHarmonyHubMetaPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'More Opens Soon'**
  String get studyHarmonyHubMetaPreviewTitle;

  /// No description provided for @studyHarmonyHubMetaPreviewHeadline.
  ///
  /// In en, this message translates to:
  /// **'Build a little momentum first'**
  String get studyHarmonyHubMetaPreviewHeadline;

  /// No description provided for @studyHarmonyHubMetaPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'League, shop, and reward systems open up more fully after a few clears. For now, finish your next lesson and one quick practice run.'**
  String get studyHarmonyHubMetaPreviewBody;

  /// No description provided for @studyHarmonyHubPlayNowAction.
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get studyHarmonyHubPlayNowAction;

  /// No description provided for @studyHarmonyHubKeepMomentumAction.
  ///
  /// In en, this message translates to:
  /// **'Keep Momentum'**
  String get studyHarmonyHubKeepMomentumAction;

  /// No description provided for @studyHarmonyClearTitleAction.
  ///
  /// In en, this message translates to:
  /// **'Clear title'**
  String get studyHarmonyClearTitleAction;

  /// No description provided for @studyHarmonyPlayerDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Player Deck'**
  String get studyHarmonyPlayerDeckTitle;

  /// No description provided for @studyHarmonyPlayerDeckCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Playstyle'**
  String get studyHarmonyPlayerDeckCardTitle;

  /// No description provided for @studyHarmonyPlayerDeckOverviewAction.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get studyHarmonyPlayerDeckOverviewAction;

  /// No description provided for @studyHarmonyRunDirectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Run Director'**
  String get studyHarmonyRunDirectorTitle;

  /// No description provided for @studyHarmonyRunDirectorAction.
  ///
  /// In en, this message translates to:
  /// **'Play Recommended'**
  String get studyHarmonyRunDirectorAction;

  /// No description provided for @studyHarmonyGameEconomyTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Economy'**
  String get studyHarmonyGameEconomyTitle;

  /// No description provided for @studyHarmonyGameEconomyBody.
  ///
  /// In en, this message translates to:
  /// **'Shop stock, utility tokens, and meta items all react to your recent run history.'**
  String get studyHarmonyGameEconomyBody;

  /// No description provided for @studyHarmonyGameEconomyTitlesOwned.
  ///
  /// In en, this message translates to:
  /// **'{count} titles owned'**
  String studyHarmonyGameEconomyTitlesOwned(int count);

  /// No description provided for @studyHarmonyGameEconomyCosmeticsOwned.
  ///
  /// In en, this message translates to:
  /// **'{count} cosmetics owned'**
  String studyHarmonyGameEconomyCosmeticsOwned(int count);

  /// No description provided for @studyHarmonyGameEconomyShopPurchases.
  ///
  /// In en, this message translates to:
  /// **'{count} shop purchases'**
  String studyHarmonyGameEconomyShopPurchases(int count);

  /// No description provided for @studyHarmonyGameEconomyWalletAction.
  ///
  /// In en, this message translates to:
  /// **'View Wallet'**
  String get studyHarmonyGameEconomyWalletAction;

  /// No description provided for @studyHarmonyArcadeSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Arcade Spotlight'**
  String get studyHarmonyArcadeSpotlightTitle;

  /// No description provided for @studyHarmonyArcadePlayAction.
  ///
  /// In en, this message translates to:
  /// **'Play Arcade'**
  String get studyHarmonyArcadePlayAction;

  /// No description provided for @studyHarmonyArcadeModeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} modes'**
  String studyHarmonyArcadeModeCount(int count);

  /// No description provided for @studyHarmonyArcadePlaylistAction.
  ///
  /// In en, this message translates to:
  /// **'Play Set'**
  String get studyHarmonyArcadePlaylistAction;

  /// No description provided for @studyHarmonyNightMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Night Market'**
  String get studyHarmonyNightMarketTitle;

  /// No description provided for @studyHarmonyPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchased {itemTitle}'**
  String studyHarmonyPurchaseSuccess(Object itemTitle);

  /// No description provided for @studyHarmonyPurchaseAndEquipSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchased and equipped {itemTitle}'**
  String studyHarmonyPurchaseAndEquipSuccess(Object itemTitle);

  /// No description provided for @studyHarmonyPurchaseFailure.
  ///
  /// In en, this message translates to:
  /// **'Cannot purchase {itemTitle} yet'**
  String studyHarmonyPurchaseFailure(Object itemTitle);

  /// No description provided for @studyHarmonyRewardEquipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped {itemTitle}'**
  String studyHarmonyRewardEquipped(Object itemTitle);

  /// No description provided for @studyHarmonyLeagueScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'{score} XP this week'**
  String studyHarmonyLeagueScoreLabel(Object score);

  /// No description provided for @studyHarmonyLeagueProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{score}/{target} XP this week'**
  String studyHarmonyLeagueProgressLabel(Object score, Object target);

  /// No description provided for @studyHarmonyLeagueNextTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Next: {tier}'**
  String studyHarmonyLeagueNextTierLabel(Object tier);

  /// No description provided for @studyHarmonyLeagueBoostLabel.
  ///
  /// In en, this message translates to:
  /// **'Best boost: {mode}'**
  String studyHarmonyLeagueBoostLabel(Object mode);

  /// No description provided for @studyHarmonyResultLeagueXpLine.
  ///
  /// In en, this message translates to:
  /// **'League XP +{count}'**
  String studyHarmonyResultLeagueXpLine(Object count);

  /// No description provided for @studyHarmonyResultLeaguePromotionLine.
  ///
  /// In en, this message translates to:
  /// **'Promoted to {tier} league'**
  String studyHarmonyResultLeaguePromotionLine(Object tier);

  /// No description provided for @studyHarmonyLeagueTierRookie.
  ///
  /// In en, this message translates to:
  /// **'Rookie'**
  String get studyHarmonyLeagueTierRookie;

  /// No description provided for @studyHarmonyLeagueTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get studyHarmonyLeagueTierBronze;

  /// No description provided for @studyHarmonyLeagueTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get studyHarmonyLeagueTierSilver;

  /// No description provided for @studyHarmonyLeagueTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get studyHarmonyLeagueTierGold;

  /// No description provided for @studyHarmonyLeagueTierDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get studyHarmonyLeagueTierDiamond;

  /// No description provided for @studyHarmonyChapterMidnightTitle.
  ///
  /// In en, this message translates to:
  /// **'Midnight Switchboard'**
  String get studyHarmonyChapterMidnightTitle;

  /// No description provided for @studyHarmonyChapterMidnightDescription.
  ///
  /// In en, this message translates to:
  /// **'A final control-room chapter that forces fast reads across drifting centers, false cadences, and borrowed reroutes.'**
  String get studyHarmonyChapterMidnightDescription;

  /// No description provided for @studyHarmonyLessonMidnightDriftTitle.
  ///
  /// In en, this message translates to:
  /// **'Signal Drift'**
  String get studyHarmonyLessonMidnightDriftTitle;

  /// No description provided for @studyHarmonyLessonMidnightDriftDescription.
  ///
  /// In en, this message translates to:
  /// **'Track the true tonal signal even while the surface keeps drifting into borrowed color.'**
  String get studyHarmonyLessonMidnightDriftDescription;

  /// No description provided for @studyHarmonyLessonMidnightLineTitle.
  ///
  /// In en, this message translates to:
  /// **'False Line'**
  String get studyHarmonyLessonMidnightLineTitle;

  /// No description provided for @studyHarmonyLessonMidnightLineDescription.
  ///
  /// In en, this message translates to:
  /// **'Read function pressure through fake resolutions before the line folds back into place.'**
  String get studyHarmonyLessonMidnightLineDescription;

  /// No description provided for @studyHarmonyLessonMidnightRerouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Reroute'**
  String get studyHarmonyLessonMidnightRerouteTitle;

  /// No description provided for @studyHarmonyLessonMidnightRerouteDescription.
  ///
  /// In en, this message translates to:
  /// **'Recover the expected landing after borrowed color reroutes the phrase midstream.'**
  String get studyHarmonyLessonMidnightRerouteDescription;

  /// No description provided for @studyHarmonyLessonMidnightBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Blackout Boss'**
  String get studyHarmonyLessonMidnightBossTitle;

  /// No description provided for @studyHarmonyLessonMidnightBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A closing blackout set that mixes every late-game lens without giving you a safe reset.'**
  String get studyHarmonyLessonMidnightBossDescription;

  /// No description provided for @studyHarmonyProgressQuestChests.
  ///
  /// In en, this message translates to:
  /// **'Quest chests {count}'**
  String studyHarmonyProgressQuestChests(Object count);

  /// No description provided for @studyHarmonyProgressLeagueBoost.
  ///
  /// In en, this message translates to:
  /// **'2x league XP x{count}'**
  String studyHarmonyProgressLeagueBoost(Object count);

  /// No description provided for @studyHarmonyQuestChestTitle.
  ///
  /// In en, this message translates to:
  /// **'Quest Chest'**
  String get studyHarmonyQuestChestTitle;

  /// No description provided for @studyHarmonyQuestChestLockedHeadline.
  ///
  /// In en, this message translates to:
  /// **'{count} quests left'**
  String studyHarmonyQuestChestLockedHeadline(Object count);

  /// No description provided for @studyHarmonyQuestChestReadyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Quest Chest ready'**
  String get studyHarmonyQuestChestReadyHeadline;

  /// No description provided for @studyHarmonyQuestChestOpenedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Quest Chest opened'**
  String get studyHarmonyQuestChestOpenedHeadline;

  /// No description provided for @studyHarmonyQuestChestBoostHeadline.
  ///
  /// In en, this message translates to:
  /// **'2x League XP live'**
  String get studyHarmonyQuestChestBoostHeadline;

  /// No description provided for @studyHarmonyQuestChestRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward: +{xp} league XP'**
  String studyHarmonyQuestChestRewardLabel(Object xp);

  /// No description provided for @studyHarmonyQuestChestLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Finish today\'s quest trio to cash out a bonus chest and keep the weekly climb moving.'**
  String get studyHarmonyQuestChestLockedBody;

  /// No description provided for @studyHarmonyQuestChestReadyBody.
  ///
  /// In en, this message translates to:
  /// **'All three quests are done. Clear one more run to cash out today\'s chest bonus.'**
  String get studyHarmonyQuestChestReadyBody;

  /// No description provided for @studyHarmonyQuestChestOpenedBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s trio is complete and the chest bonus has already been converted into league XP.'**
  String get studyHarmonyQuestChestOpenedBody;

  /// No description provided for @studyHarmonyQuestChestOpenedBoostBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s chest is open and 2x League XP is active for your next {count} clears.'**
  String studyHarmonyQuestChestOpenedBoostBody(Object count);

  /// No description provided for @studyHarmonyQuestChestAction.
  ///
  /// In en, this message translates to:
  /// **'Finish trio'**
  String get studyHarmonyQuestChestAction;

  /// No description provided for @studyHarmonyQuestChestBoostLabel.
  ///
  /// In en, this message translates to:
  /// **'Best finish: {mode}'**
  String studyHarmonyQuestChestBoostLabel(Object mode);

  /// No description provided for @studyHarmonyQuestChestBoostReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'2x XP x{count}'**
  String studyHarmonyQuestChestBoostReadyLabel(Object count);

  /// No description provided for @studyHarmonyQuestChestProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily quests {count}/{target}'**
  String studyHarmonyQuestChestProgressLabel(Object count, Object target);

  /// No description provided for @studyHarmonyResultQuestChestLine.
  ///
  /// In en, this message translates to:
  /// **'Quest Chest opened.'**
  String get studyHarmonyResultQuestChestLine;

  /// No description provided for @studyHarmonyResultQuestChestXpLine.
  ///
  /// In en, this message translates to:
  /// **'Quest Chest bonus +{count} League XP'**
  String studyHarmonyResultQuestChestXpLine(Object count);

  /// No description provided for @studyHarmonyResultLeagueBoostReadyLine.
  ///
  /// In en, this message translates to:
  /// **'2x League XP boost ready for the next {count} clears'**
  String studyHarmonyResultLeagueBoostReadyLine(Object count);

  /// No description provided for @studyHarmonyResultLeagueBoostAppliedLine.
  ///
  /// In en, this message translates to:
  /// **'Boost bonus +{count} League XP'**
  String studyHarmonyResultLeagueBoostAppliedLine(Object count);

  /// No description provided for @studyHarmonyResultLeagueBoostRemainingLine.
  ///
  /// In en, this message translates to:
  /// **'2x boost clears left {count}'**
  String studyHarmonyResultLeagueBoostRemainingLine(Object count);

  /// No description provided for @studyHarmonyLeagueBoostReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'2x XP x{count}'**
  String studyHarmonyLeagueBoostReadyLabel(Object count);

  /// No description provided for @studyHarmonyLeagueCardHintBoosted.
  ///
  /// In en, this message translates to:
  /// **'2x League XP is live for {count} clears. Spend it on {mode} while the boost lasts.'**
  String studyHarmonyLeagueCardHintBoosted(Object count, Object mode);

  /// No description provided for @studyHarmonyChapterSkylineTitle.
  ///
  /// In en, this message translates to:
  /// **'Skyline Circuit'**
  String get studyHarmonyChapterSkylineTitle;

  /// No description provided for @studyHarmonyChapterSkylineDescription.
  ///
  /// In en, this message translates to:
  /// **'A final skyline circuit that forces fast mixed reads across ghosted centers, borrowed gravity, and false homes.'**
  String get studyHarmonyChapterSkylineDescription;

  /// No description provided for @studyHarmonyLessonSkylinePulseTitle.
  ///
  /// In en, this message translates to:
  /// **'Afterimage Pulse'**
  String get studyHarmonyLessonSkylinePulseTitle;

  /// No description provided for @studyHarmonyLessonSkylinePulseDescription.
  ///
  /// In en, this message translates to:
  /// **'Catch center and function in the afterimage before the phrase locks into a new lane.'**
  String get studyHarmonyLessonSkylinePulseDescription;

  /// No description provided for @studyHarmonyLessonSkylineSwapTitle.
  ///
  /// In en, this message translates to:
  /// **'Gravity Swap'**
  String get studyHarmonyLessonSkylineSwapTitle;

  /// No description provided for @studyHarmonyLessonSkylineSwapDescription.
  ///
  /// In en, this message translates to:
  /// **'Handle borrowed gravity and missing-chord repair while the progression keeps swapping its weight.'**
  String get studyHarmonyLessonSkylineSwapDescription;

  /// No description provided for @studyHarmonyLessonSkylineHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'False Home'**
  String get studyHarmonyLessonSkylineHomeTitle;

  /// No description provided for @studyHarmonyLessonSkylineHomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Read through the false arrival and rebuild the true landing before the progression snaps shut.'**
  String get studyHarmonyLessonSkylineHomeDescription;

  /// No description provided for @studyHarmonyLessonSkylineBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Signal Boss'**
  String get studyHarmonyLessonSkylineBossTitle;

  /// No description provided for @studyHarmonyLessonSkylineBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A last skyline boss that chains every late-game progression lens into one closing signal test.'**
  String get studyHarmonyLessonSkylineBossDescription;

  /// No description provided for @studyHarmonyChapterAfterglowTitle.
  ///
  /// In en, this message translates to:
  /// **'Afterglow Runway'**
  String get studyHarmonyChapterAfterglowTitle;

  /// No description provided for @studyHarmonyChapterAfterglowDescription.
  ///
  /// In en, this message translates to:
  /// **'A closing runway of split decisions, borrowed bait, and flickering centers that rewards clean late-game reads under pressure.'**
  String get studyHarmonyChapterAfterglowDescription;

  /// No description provided for @studyHarmonyLessonAfterglowSplitTitle.
  ///
  /// In en, this message translates to:
  /// **'Split Decision'**
  String get studyHarmonyLessonAfterglowSplitTitle;

  /// No description provided for @studyHarmonyLessonAfterglowSplitDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the repair chord that keeps the function moving without letting the phrase drift off course.'**
  String get studyHarmonyLessonAfterglowSplitDescription;

  /// No description provided for @studyHarmonyLessonAfterglowLureTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Lure'**
  String get studyHarmonyLessonAfterglowLureTitle;

  /// No description provided for @studyHarmonyLessonAfterglowLureDescription.
  ///
  /// In en, this message translates to:
  /// **'Spot the borrowed color chord that looks like a pivot before the progression snaps back home.'**
  String get studyHarmonyLessonAfterglowLureDescription;

  /// No description provided for @studyHarmonyLessonAfterglowFlickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Center Flicker'**
  String get studyHarmonyLessonAfterglowFlickerTitle;

  /// No description provided for @studyHarmonyLessonAfterglowFlickerDescription.
  ///
  /// In en, this message translates to:
  /// **'Hold the tonal center while cadence cues blink and reroute in quick succession.'**
  String get studyHarmonyLessonAfterglowFlickerDescription;

  /// No description provided for @studyHarmonyLessonAfterglowBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Redline Return Boss'**
  String get studyHarmonyLessonAfterglowBossTitle;

  /// No description provided for @studyHarmonyLessonAfterglowBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A final mixed test of key center, function, borrowed color, and missing-chord repair at full speed.'**
  String get studyHarmonyLessonAfterglowBossDescription;

  /// No description provided for @studyHarmonyProgressTour.
  ///
  /// In en, this message translates to:
  /// **'Tour stamps {count}/{target}'**
  String studyHarmonyProgressTour(Object count, Object target);

  /// No description provided for @studyHarmonyProgressTourClaimed.
  ///
  /// In en, this message translates to:
  /// **'Monthly tour cleared'**
  String get studyHarmonyProgressTourClaimed;

  /// No description provided for @studyHarmonyTourTitle.
  ///
  /// In en, this message translates to:
  /// **'Harmony Tour'**
  String get studyHarmonyTourTitle;

  /// No description provided for @studyHarmonyTourProgressHeadline.
  ///
  /// In en, this message translates to:
  /// **'{count}/{target} tour stamps'**
  String studyHarmonyTourProgressHeadline(Object count, Object target);

  /// No description provided for @studyHarmonyTourReadyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Tour finale ready'**
  String get studyHarmonyTourReadyHeadline;

  /// No description provided for @studyHarmonyTourClaimedHeadline.
  ///
  /// In en, this message translates to:
  /// **'Monthly tour cleared'**
  String get studyHarmonyTourClaimedHeadline;

  /// No description provided for @studyHarmonyTourRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward: +{xp} league XP and {count} Streak Saver'**
  String studyHarmonyTourRewardLabel(Object xp, Object count);

  /// No description provided for @studyHarmonyTourActiveDaysBody.
  ///
  /// In en, this message translates to:
  /// **'Show up on {target} different days this month to lock in the tour bonus.'**
  String studyHarmonyTourActiveDaysBody(Object target);

  /// No description provided for @studyHarmonyTourQuestChestBody.
  ///
  /// In en, this message translates to:
  /// **'Open {target} Quest Chests this month to keep the tour stamp book moving.'**
  String studyHarmonyTourQuestChestBody(Object target);

  /// No description provided for @studyHarmonyTourSpotlightBody.
  ///
  /// In en, this message translates to:
  /// **'Clear {target} spotlight runs this month. Boss Rush, Relay, Focus, Legend, and boss lessons all count.'**
  String studyHarmonyTourSpotlightBody(Object target);

  /// No description provided for @studyHarmonyTourEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Monthly tour goals will appear here as you log activity this month.'**
  String get studyHarmonyTourEmptyBody;

  /// No description provided for @studyHarmonyTourReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Every monthly stamp is in. One more clear locks in the tour bonus.'**
  String get studyHarmonyTourReadyBody;

  /// No description provided for @studyHarmonyTourClaimedBody.
  ///
  /// In en, this message translates to:
  /// **'This month\'s tour is complete. Keep the rhythm sharp so next month\'s route starts hot.'**
  String get studyHarmonyTourClaimedBody;

  /// No description provided for @studyHarmonyTourAction.
  ///
  /// In en, this message translates to:
  /// **'Advance tour'**
  String get studyHarmonyTourAction;

  /// No description provided for @studyHarmonyTourActiveDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Active days {count}/{target}'**
  String studyHarmonyTourActiveDaysLabel(Object count, Object target);

  /// No description provided for @studyHarmonyTourQuestChestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Quest Chests {count}/{target}'**
  String studyHarmonyTourQuestChestsLabel(Object count, Object target);

  /// No description provided for @studyHarmonyTourSpotlightLabel.
  ///
  /// In en, this message translates to:
  /// **'Spotlights {count}/{target}'**
  String studyHarmonyTourSpotlightLabel(Object count, Object target);

  /// No description provided for @studyHarmonyResultTourCompleteLine.
  ///
  /// In en, this message translates to:
  /// **'Harmony Tour complete'**
  String get studyHarmonyResultTourCompleteLine;

  /// No description provided for @studyHarmonyResultTourXpLine.
  ///
  /// In en, this message translates to:
  /// **'Tour bonus +{count} League XP'**
  String studyHarmonyResultTourXpLine(Object count);

  /// No description provided for @studyHarmonyResultTourStreakSaverLine.
  ///
  /// In en, this message translates to:
  /// **'Streak Saver stock {count}'**
  String studyHarmonyResultTourStreakSaverLine(Object count);

  /// No description provided for @studyHarmonyChapterDaybreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Daybreak Frequency'**
  String get studyHarmonyChapterDaybreakTitle;

  /// No description provided for @studyHarmonyChapterDaybreakDescription.
  ///
  /// In en, this message translates to:
  /// **'A sunrise encore of ghost cadences, false dawn pivots, and borrowed blooms that forces clean late-game reads after a long run.'**
  String get studyHarmonyChapterDaybreakDescription;

  /// No description provided for @studyHarmonyLessonDaybreakGhostTitle.
  ///
  /// In en, this message translates to:
  /// **'Ghost Cadence'**
  String get studyHarmonyLessonDaybreakGhostTitle;

  /// No description provided for @studyHarmonyLessonDaybreakGhostDescription.
  ///
  /// In en, this message translates to:
  /// **'Repair the cadence and function at the same time when the phrase pretends to close without actually landing.'**
  String get studyHarmonyLessonDaybreakGhostDescription;

  /// No description provided for @studyHarmonyLessonDaybreakDawnTitle.
  ///
  /// In en, this message translates to:
  /// **'False Dawn'**
  String get studyHarmonyLessonDaybreakDawnTitle;

  /// No description provided for @studyHarmonyLessonDaybreakDawnDescription.
  ///
  /// In en, this message translates to:
  /// **'Catch the center shift hiding inside a too-early sunrise before the progression pulls away again.'**
  String get studyHarmonyLessonDaybreakDawnDescription;

  /// No description provided for @studyHarmonyLessonDaybreakBloomTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Bloom'**
  String get studyHarmonyLessonDaybreakBloomTitle;

  /// No description provided for @studyHarmonyLessonDaybreakBloomDescription.
  ///
  /// In en, this message translates to:
  /// **'Track borrowed color and function together while the harmony opens into a brighter but unstable lane.'**
  String get studyHarmonyLessonDaybreakBloomDescription;

  /// No description provided for @studyHarmonyLessonDaybreakBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunrise Overdrive Boss'**
  String get studyHarmonyLessonDaybreakBossTitle;

  /// No description provided for @studyHarmonyLessonDaybreakBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A final dawn-speed boss that chains key center, function, non-diatonic color, and missing-chord repair into one last overdrive set.'**
  String get studyHarmonyLessonDaybreakBossDescription;

  /// No description provided for @studyHarmonyProgressDuetPact.
  ///
  /// In en, this message translates to:
  /// **'Duet streak {count}'**
  String studyHarmonyProgressDuetPact(Object count);

  /// No description provided for @studyHarmonyDuetTitle.
  ///
  /// In en, this message translates to:
  /// **'Duet Pact'**
  String get studyHarmonyDuetTitle;

  /// No description provided for @studyHarmonyDuetStartHeadline.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s duet'**
  String get studyHarmonyDuetStartHeadline;

  /// No description provided for @studyHarmonyDuetInProgressHeadline.
  ///
  /// In en, this message translates to:
  /// **'Duet streak {count}'**
  String studyHarmonyDuetInProgressHeadline(Object count);

  /// No description provided for @studyHarmonyDuetReadyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Duet locked for day {count}'**
  String studyHarmonyDuetReadyHeadline(Object count);

  /// No description provided for @studyHarmonyDuetRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward: +{xp} league XP at key streaks'**
  String studyHarmonyDuetRewardLabel(Object xp);

  /// No description provided for @studyHarmonyDuetNeedDailyBody.
  ///
  /// In en, this message translates to:
  /// **'Clear today\'s Daily first, then land one spotlight run to keep the duet alive.'**
  String get studyHarmonyDuetNeedDailyBody;

  /// No description provided for @studyHarmonyDuetNeedSpotlightBody.
  ///
  /// In en, this message translates to:
  /// **'Daily is in. Finish one spotlight run like Focus, Relay, Boss Rush, Legend, or a boss lesson to seal the duet.'**
  String get studyHarmonyDuetNeedSpotlightBody;

  /// No description provided for @studyHarmonyDuetActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Today\'s duet is sealed and the shared streak is now {count} days long.'**
  String studyHarmonyDuetActiveBody(Object count);

  /// No description provided for @studyHarmonyDuetDailyDone.
  ///
  /// In en, this message translates to:
  /// **'Daily in'**
  String get studyHarmonyDuetDailyDone;

  /// No description provided for @studyHarmonyDuetDailyMissing.
  ///
  /// In en, this message translates to:
  /// **'Daily missing'**
  String get studyHarmonyDuetDailyMissing;

  /// No description provided for @studyHarmonyDuetSpotlightDone.
  ///
  /// In en, this message translates to:
  /// **'Spotlight in'**
  String get studyHarmonyDuetSpotlightDone;

  /// No description provided for @studyHarmonyDuetSpotlightMissing.
  ///
  /// In en, this message translates to:
  /// **'Spotlight missing'**
  String get studyHarmonyDuetSpotlightMissing;

  /// No description provided for @studyHarmonyDuetDailyLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily {done}'**
  String studyHarmonyDuetDailyLabel(bool done);

  /// No description provided for @studyHarmonyDuetSpotlightLabel.
  ///
  /// In en, this message translates to:
  /// **'Spotlight {done}'**
  String studyHarmonyDuetSpotlightLabel(bool done);

  /// No description provided for @studyHarmonyDuetTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak {count}/{target}'**
  String studyHarmonyDuetTargetLabel(Object count, Object target);

  /// No description provided for @studyHarmonyDuetAction.
  ///
  /// In en, this message translates to:
  /// **'Keep duet going'**
  String get studyHarmonyDuetAction;

  /// No description provided for @studyHarmonyResultDuetLine.
  ///
  /// In en, this message translates to:
  /// **'Duet streak {count}'**
  String studyHarmonyResultDuetLine(Object count);

  /// No description provided for @studyHarmonyResultDuetRewardLine.
  ///
  /// In en, this message translates to:
  /// **'Duet reward +{count} League XP'**
  String studyHarmonyResultDuetRewardLine(Object count);

  /// Localized solfege syllable for Do in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Do'**
  String get studyHarmonySolfegeDo;

  /// Localized solfege syllable for Re in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Re'**
  String get studyHarmonySolfegeRe;

  /// Localized solfege syllable for Mi in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Mi'**
  String get studyHarmonySolfegeMi;

  /// Localized solfege syllable for Fa in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Fa'**
  String get studyHarmonySolfegeFa;

  /// Localized solfege syllable for Sol in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Sol'**
  String get studyHarmonySolfegeSol;

  /// Localized solfege syllable for La in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'La'**
  String get studyHarmonySolfegeLa;

  /// Localized solfege syllable for Ti or Si in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'Ti'**
  String get studyHarmonySolfegeTi;

  /// Title for the legacy prototype course carried into Study Harmony.
  ///
  /// In en, this message translates to:
  /// **'Study Harmony Prototype'**
  String get studyHarmonyPrototypeCourseTitle;

  /// Description for the legacy prototype course.
  ///
  /// In en, this message translates to:
  /// **'Legacy prototype levels carried into the lesson system.'**
  String get studyHarmonyPrototypeCourseDescription;

  /// Title for the legacy prototype chapter.
  ///
  /// In en, this message translates to:
  /// **'Prototype Lessons'**
  String get studyHarmonyPrototypeChapterTitle;

  /// Description for the legacy prototype chapter.
  ///
  /// In en, this message translates to:
  /// **'Temporary lessons preserved while the expandable study system is introduced.'**
  String get studyHarmonyPrototypeChapterDescription;

  /// Objective label for the legacy prototype levels.
  ///
  /// In en, this message translates to:
  /// **'Clear by answering 10 prompts before you lose all 3 lives.'**
  String get studyHarmonyPrototypeLevelObjective;

  /// Title for the first legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'Prototype Level 1 · Do / Mi / Sol'**
  String get studyHarmonyPrototypeLevel1Title;

  /// Description for the first legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'A basic warm-up that asks you to distinguish only Do, Mi, and Sol.'**
  String get studyHarmonyPrototypeLevel1Description;

  /// Title for the second legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'Prototype Level 2 · Do / Re / Mi / Sol / La'**
  String get studyHarmonyPrototypeLevel2Title;

  /// Description for the second legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'A mid-stage note hunt that speeds up recognition for Do, Re, Mi, Sol, and La.'**
  String get studyHarmonyPrototypeLevel2Description;

  /// Title for the third legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'Prototype Level 3 · Do / Re / Mi / Fa / Sol / La / Ti / Do'**
  String get studyHarmonyPrototypeLevel3Title;

  /// Description for the third legacy prototype level.
  ///
  /// In en, this message translates to:
  /// **'An octave-complete test that runs across the full Do-Re-Mi-Fa-Sol-La-Ti-Do span.'**
  String get studyHarmonyPrototypeLevel3Description;

  /// Label for the low C prompt in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'{noteName} (low C)'**
  String studyHarmonyPrototypeLowCLabel(String noteName);

  /// Label for the high C prompt in legacy prototype lessons.
  ///
  /// In en, this message translates to:
  /// **'{noteName} (high C)'**
  String studyHarmonyPrototypeHighCLabel(String noteName);

  /// Placeholder answer label for generated Study Harmony templates.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get studyHarmonyTemplateChoiceLabel;

  /// No description provided for @studyHarmonyChapterBlueHourTitle.
  ///
  /// In en, this message translates to:
  /// **'Blue Hour Exchange'**
  String get studyHarmonyChapterBlueHourTitle;

  /// No description provided for @studyHarmonyChapterBlueHourDescription.
  ///
  /// In en, this message translates to:
  /// **'A twilight encore of crossing currents, haloed borrows, and dual horizons that keeps late-game reads unstable in the best way.'**
  String get studyHarmonyChapterBlueHourDescription;

  /// No description provided for @studyHarmonyLessonBlueHourCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cross Current'**
  String get studyHarmonyLessonBlueHourCurrentTitle;

  /// No description provided for @studyHarmonyLessonBlueHourCurrentDescription.
  ///
  /// In en, this message translates to:
  /// **'Track key center and function while the progression starts pulling in two directions at once.'**
  String get studyHarmonyLessonBlueHourCurrentDescription;

  /// No description provided for @studyHarmonyLessonBlueHourHaloTitle.
  ///
  /// In en, this message translates to:
  /// **'Halo Borrow'**
  String get studyHarmonyLessonBlueHourHaloTitle;

  /// No description provided for @studyHarmonyLessonBlueHourHaloDescription.
  ///
  /// In en, this message translates to:
  /// **'Read the borrowed color and restore the missing chord before the phrase turns hazy.'**
  String get studyHarmonyLessonBlueHourHaloDescription;

  /// No description provided for @studyHarmonyLessonBlueHourHorizonTitle.
  ///
  /// In en, this message translates to:
  /// **'Dual Horizon'**
  String get studyHarmonyLessonBlueHourHorizonTitle;

  /// No description provided for @studyHarmonyLessonBlueHourHorizonDescription.
  ///
  /// In en, this message translates to:
  /// **'Hold the real arrival point while two possible horizons keep flashing in and out.'**
  String get studyHarmonyLessonBlueHourHorizonDescription;

  /// No description provided for @studyHarmonyLessonBlueHourBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Twin Lanterns Boss'**
  String get studyHarmonyLessonBlueHourBossTitle;

  /// No description provided for @studyHarmonyLessonBlueHourBossDescription.
  ///
  /// In en, this message translates to:
  /// **'A final blue-hour boss that forces fast swaps across center, function, borrowed color, and missing-chord repair.'**
  String get studyHarmonyLessonBlueHourBossDescription;

  /// No description provided for @anchorLoopTitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor Loop'**
  String get anchorLoopTitle;

  /// No description provided for @anchorLoopHelp.
  ///
  /// In en, this message translates to:
  /// **'Fix specific cycle slots so the same chord returns every cycle while the other slots can still be generated around it.'**
  String get anchorLoopHelp;

  /// No description provided for @anchorLoopCycleLength.
  ///
  /// In en, this message translates to:
  /// **'Cycle Length (bars)'**
  String get anchorLoopCycleLength;

  /// No description provided for @anchorLoopCycleLengthHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how many bars the repeating anchor cycle lasts.'**
  String get anchorLoopCycleLengthHelp;

  /// No description provided for @anchorLoopVaryNonAnchorSlots.
  ///
  /// In en, this message translates to:
  /// **'Vary non-anchor slots'**
  String get anchorLoopVaryNonAnchorSlots;

  /// No description provided for @anchorLoopVaryNonAnchorSlotsHelp.
  ///
  /// In en, this message translates to:
  /// **'Keep anchor slots exact while letting the generated filler vary inside the same local function.'**
  String get anchorLoopVaryNonAnchorSlotsHelp;

  /// No description provided for @anchorLoopBarLabel.
  ///
  /// In en, this message translates to:
  /// **'Bar {bar}'**
  String anchorLoopBarLabel(int bar);

  /// No description provided for @anchorLoopBeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Beat {beat}'**
  String anchorLoopBeatLabel(int beat);

  /// No description provided for @anchorLoopSlotEmpty.
  ///
  /// In en, this message translates to:
  /// **'No anchor chord set'**
  String get anchorLoopSlotEmpty;

  /// No description provided for @anchorLoopEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit anchor for bar {bar}, beat {beat}'**
  String anchorLoopEditTitle(int bar, int beat);

  /// No description provided for @anchorLoopChordSymbol.
  ///
  /// In en, this message translates to:
  /// **'Anchor chord symbol'**
  String get anchorLoopChordSymbol;

  /// No description provided for @anchorLoopChordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter one chord symbol for this slot. Leave it empty to clear the anchor.'**
  String get anchorLoopChordHint;

  /// No description provided for @anchorLoopInvalidChord.
  ///
  /// In en, this message translates to:
  /// **'Enter a supported chord symbol before saving this anchor slot.'**
  String get anchorLoopInvalidChord;

  /// No description provided for @harmonyPlaybackPatternBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get harmonyPlaybackPatternBlock;

  /// No description provided for @harmonyPlaybackPatternArpeggio.
  ///
  /// In en, this message translates to:
  /// **'Arpeggio'**
  String get harmonyPlaybackPatternArpeggio;

  /// No description provided for @metronomeBeatStateNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get metronomeBeatStateNormal;

  /// No description provided for @metronomeBeatStateAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get metronomeBeatStateAccent;

  /// No description provided for @metronomeBeatStateMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get metronomeBeatStateMute;

  /// No description provided for @metronomePatternPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get metronomePatternPresetCustom;

  /// No description provided for @metronomePatternPresetMeterAccent.
  ///
  /// In en, this message translates to:
  /// **'Meter accent'**
  String get metronomePatternPresetMeterAccent;

  /// No description provided for @metronomePatternPresetJazzTwoAndFour.
  ///
  /// In en, this message translates to:
  /// **'Jazz 2 & 4'**
  String get metronomePatternPresetJazzTwoAndFour;

  /// No description provided for @metronomeSourceKindBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Built-in asset'**
  String get metronomeSourceKindBuiltIn;

  /// No description provided for @metronomeSourceKindLocalFile.
  ///
  /// In en, this message translates to:
  /// **'Local file'**
  String get metronomeSourceKindLocalFile;

  /// No description provided for @transportAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Transport Audio'**
  String get transportAudioTitle;

  /// No description provided for @autoPlayChordChanges.
  ///
  /// In en, this message translates to:
  /// **'Auto-play chord changes'**
  String get autoPlayChordChanges;

  /// No description provided for @autoPlayChordChangesHelp.
  ///
  /// In en, this message translates to:
  /// **'Play the next chord automatically when the transport reaches a chord-change event.'**
  String get autoPlayChordChangesHelp;

  /// No description provided for @autoPlayPattern.
  ///
  /// In en, this message translates to:
  /// **'Auto-play pattern'**
  String get autoPlayPattern;

  /// No description provided for @autoPlayPatternHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose whether auto-play uses a block chord or a short arpeggio.'**
  String get autoPlayPatternHelp;

  /// No description provided for @autoPlayHoldFactor.
  ///
  /// In en, this message translates to:
  /// **'Auto-play hold length'**
  String get autoPlayHoldFactor;

  /// No description provided for @autoPlayHoldFactorHelp.
  ///
  /// In en, this message translates to:
  /// **'Scale how long auto-played chord changes ring relative to the event duration.'**
  String get autoPlayHoldFactorHelp;

  /// No description provided for @autoPlayMelodyWithChords.
  ///
  /// In en, this message translates to:
  /// **'Play melody with chords'**
  String get autoPlayMelodyWithChords;

  /// No description provided for @autoPlayMelodyWithChordsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'When melody generation is enabled, include the current melody line in auto-play chord-change previews.'**
  String get autoPlayMelodyWithChordsPlaceholder;

  /// No description provided for @melodyGenerationTitle.
  ///
  /// In en, this message translates to:
  /// **'Melody line'**
  String get melodyGenerationTitle;

  /// No description provided for @melodyGenerationHelp.
  ///
  /// In en, this message translates to:
  /// **'Generate a simple performance-ready melody that follows the current chord timeline.'**
  String get melodyGenerationHelp;

  /// No description provided for @melodyDensity.
  ///
  /// In en, this message translates to:
  /// **'Melody density'**
  String get melodyDensity;

  /// No description provided for @melodyDensityHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose how many melody notes tend to appear inside each chord event.'**
  String get melodyDensityHelp;

  /// No description provided for @melodyDensitySparse.
  ///
  /// In en, this message translates to:
  /// **'Sparse'**
  String get melodyDensitySparse;

  /// No description provided for @melodyDensityBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get melodyDensityBalanced;

  /// No description provided for @melodyDensityActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get melodyDensityActive;

  /// No description provided for @motifRepetitionStrength.
  ///
  /// In en, this message translates to:
  /// **'Motif repetition'**
  String get motifRepetitionStrength;

  /// No description provided for @motifRepetitionStrengthHelp.
  ///
  /// In en, this message translates to:
  /// **'Higher values keep the contour identity of recent melody fragments more often.'**
  String get motifRepetitionStrengthHelp;

  /// No description provided for @approachToneDensity.
  ///
  /// In en, this message translates to:
  /// **'Approach tone density'**
  String get approachToneDensity;

  /// No description provided for @approachToneDensityHelp.
  ///
  /// In en, this message translates to:
  /// **'Control how often passing, neighbor, and approach gestures appear before arrivals.'**
  String get approachToneDensityHelp;

  /// No description provided for @melodyRangeLow.
  ///
  /// In en, this message translates to:
  /// **'Melody range low'**
  String get melodyRangeLow;

  /// No description provided for @melodyRangeHigh.
  ///
  /// In en, this message translates to:
  /// **'Melody range high'**
  String get melodyRangeHigh;

  /// No description provided for @melodyRangeHelp.
  ///
  /// In en, this message translates to:
  /// **'Keep generated melody notes inside this playable register window.'**
  String get melodyRangeHelp;

  /// No description provided for @melodyStyle.
  ///
  /// In en, this message translates to:
  /// **'Melody style'**
  String get melodyStyle;

  /// No description provided for @melodyStyleHelp.
  ///
  /// In en, this message translates to:
  /// **'Bias the line toward safer guide tones, bebop motion, lyrical space, or colorful tensions.'**
  String get melodyStyleHelp;

  /// No description provided for @melodyStyleSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get melodyStyleSafe;

  /// No description provided for @melodyStyleBebop.
  ///
  /// In en, this message translates to:
  /// **'Bebop'**
  String get melodyStyleBebop;

  /// No description provided for @melodyStyleLyrical.
  ///
  /// In en, this message translates to:
  /// **'Lyrical'**
  String get melodyStyleLyrical;

  /// No description provided for @melodyStyleColorful.
  ///
  /// In en, this message translates to:
  /// **'Colorful'**
  String get melodyStyleColorful;

  /// No description provided for @allowChromaticApproaches.
  ///
  /// In en, this message translates to:
  /// **'Allow chromatic approaches'**
  String get allowChromaticApproaches;

  /// No description provided for @allowChromaticApproachesHelp.
  ///
  /// In en, this message translates to:
  /// **'Permit enclosures and chromatic approach notes on weak beats when the style allows it.'**
  String get allowChromaticApproachesHelp;

  /// No description provided for @melodyPlaybackMode.
  ///
  /// In en, this message translates to:
  /// **'Melody playback'**
  String get melodyPlaybackMode;

  /// No description provided for @melodyPlaybackModeHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose whether manual preview buttons play chords, melody, or both together.'**
  String get melodyPlaybackModeHelp;

  /// No description provided for @melodyPlaybackModeChordsOnly.
  ///
  /// In en, this message translates to:
  /// **'Chords only'**
  String get melodyPlaybackModeChordsOnly;

  /// No description provided for @melodyPlaybackModeMelodyOnly.
  ///
  /// In en, this message translates to:
  /// **'Melody only'**
  String get melodyPlaybackModeMelodyOnly;

  /// No description provided for @melodyPlaybackModeBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get melodyPlaybackModeBoth;

  /// No description provided for @regenerateMelody.
  ///
  /// In en, this message translates to:
  /// **'Regenerate melody'**
  String get regenerateMelody;

  /// No description provided for @melodyPreviewCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current line'**
  String get melodyPreviewCurrent;

  /// No description provided for @melodyPreviewNext.
  ///
  /// In en, this message translates to:
  /// **'Next arrival'**
  String get melodyPreviewNext;

  /// No description provided for @metronomePatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Metronome Pattern'**
  String get metronomePatternTitle;

  /// No description provided for @metronomePatternHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose a meter-aware click pattern or define each beat manually.'**
  String get metronomePatternHelp;

  /// No description provided for @metronomeUseAccentSound.
  ///
  /// In en, this message translates to:
  /// **'Use separate accent sound'**
  String get metronomeUseAccentSound;

  /// No description provided for @metronomeUseAccentSoundHelp.
  ///
  /// In en, this message translates to:
  /// **'Use a different click source for accented beats instead of only raising the gain.'**
  String get metronomeUseAccentSoundHelp;

  /// No description provided for @metronomePrimarySource.
  ///
  /// In en, this message translates to:
  /// **'Primary click source'**
  String get metronomePrimarySource;

  /// No description provided for @metronomeAccentSource.
  ///
  /// In en, this message translates to:
  /// **'Accent click source'**
  String get metronomeAccentSource;

  /// No description provided for @metronomeSourceKind.
  ///
  /// In en, this message translates to:
  /// **'Source type'**
  String get metronomeSourceKind;

  /// No description provided for @metronomeLocalFilePath.
  ///
  /// In en, this message translates to:
  /// **'Local file path'**
  String get metronomeLocalFilePath;

  /// No description provided for @metronomeLocalFilePathHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste a local audio file path and press enter to apply it. Built-in sound remains the fallback.'**
  String get metronomeLocalFilePathHelp;

  /// No description provided for @metronomeAccentLocalFilePath.
  ///
  /// In en, this message translates to:
  /// **'Accent local file path'**
  String get metronomeAccentLocalFilePath;

  /// No description provided for @metronomeAccentLocalFilePathHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste a local accent file path and press enter to apply it. Built-in sound remains the fallback.'**
  String get metronomeAccentLocalFilePathHelp;

  /// No description provided for @harmonySoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Harmony Sound'**
  String get harmonySoundTitle;

  /// No description provided for @harmonyMasterVolume.
  ///
  /// In en, this message translates to:
  /// **'Master volume'**
  String get harmonyMasterVolume;

  /// No description provided for @harmonyMasterVolumeHelp.
  ///
  /// In en, this message translates to:
  /// **'Overall harmony preview loudness for manual and automatic chord playback.'**
  String get harmonyMasterVolumeHelp;

  /// No description provided for @harmonyPreviewHoldFactor.
  ///
  /// In en, this message translates to:
  /// **'Chord hold length'**
  String get harmonyPreviewHoldFactor;

  /// No description provided for @harmonyPreviewHoldFactorHelp.
  ///
  /// In en, this message translates to:
  /// **'Scale how long previewed chords and notes sustain.'**
  String get harmonyPreviewHoldFactorHelp;

  /// No description provided for @harmonyArpeggioStepSpeed.
  ///
  /// In en, this message translates to:
  /// **'Arpeggio step speed'**
  String get harmonyArpeggioStepSpeed;

  /// No description provided for @harmonyArpeggioStepSpeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Control how quickly arpeggiated notes step forward.'**
  String get harmonyArpeggioStepSpeedHelp;

  /// No description provided for @harmonyVelocityHumanization.
  ///
  /// In en, this message translates to:
  /// **'Velocity humanization'**
  String get harmonyVelocityHumanization;

  /// No description provided for @harmonyVelocityHumanizationHelp.
  ///
  /// In en, this message translates to:
  /// **'Add small velocity variation so repeated previews feel less mechanical.'**
  String get harmonyVelocityHumanizationHelp;

  /// No description provided for @harmonyGainRandomness.
  ///
  /// In en, this message translates to:
  /// **'Gain randomness'**
  String get harmonyGainRandomness;

  /// No description provided for @harmonyGainRandomnessHelp.
  ///
  /// In en, this message translates to:
  /// **'Add slight per-note loudness variation on supported playback paths.'**
  String get harmonyGainRandomnessHelp;

  /// No description provided for @harmonyTimingHumanization.
  ///
  /// In en, this message translates to:
  /// **'Timing humanization'**
  String get harmonyTimingHumanization;

  /// No description provided for @harmonyTimingHumanizationHelp.
  ///
  /// In en, this message translates to:
  /// **'Slightly loosen simultaneous note attacks for a less rigid block chord.'**
  String get harmonyTimingHumanizationHelp;

  /// No description provided for @harmonySoundProfileSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound profile mode'**
  String get harmonySoundProfileSelectionTitle;

  /// No description provided for @harmonySoundProfileSelectionHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose a neutral preview, follow the active Study Harmony track, or pin one track\'s playback feel.'**
  String get harmonySoundProfileSelectionHelp;

  /// No description provided for @harmonySoundProfileSelectionNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral shared piano'**
  String get harmonySoundProfileSelectionNeutral;

  /// No description provided for @harmonySoundProfileSelectionTrackAware.
  ///
  /// In en, this message translates to:
  /// **'Track-aware'**
  String get harmonySoundProfileSelectionTrackAware;

  /// No description provided for @harmonySoundProfileSelectionPop.
  ///
  /// In en, this message translates to:
  /// **'Pop profile'**
  String get harmonySoundProfileSelectionPop;

  /// No description provided for @harmonySoundProfileSelectionJazz.
  ///
  /// In en, this message translates to:
  /// **'Jazz profile'**
  String get harmonySoundProfileSelectionJazz;

  /// No description provided for @harmonySoundProfileSelectionClassical.
  ///
  /// In en, this message translates to:
  /// **'Classical profile'**
  String get harmonySoundProfileSelectionClassical;

  /// No description provided for @harmonySoundProfileSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'Instrument: {instrument}. Recommended preview: {pattern}.'**
  String harmonySoundProfileSummaryLine(Object instrument, Object pattern);

  /// No description provided for @harmonySoundProfileTrackAwareFallback.
  ///
  /// In en, this message translates to:
  /// **'In free practice this stays on the shared piano profile. Study Harmony sessions switch to the active track\'s sound shaping.'**
  String get harmonySoundProfileTrackAwareFallback;

  /// No description provided for @harmonySoundProfileNeutralLabel.
  ///
  /// In en, this message translates to:
  /// **'Balanced / shared piano'**
  String get harmonySoundProfileNeutralLabel;

  /// No description provided for @harmonySoundProfileNeutralSummary.
  ///
  /// In en, this message translates to:
  /// **'Use the shared piano asset with a steady, all-purpose preview shape.'**
  String get harmonySoundProfileNeutralSummary;

  /// No description provided for @harmonySoundTagBalanced.
  ///
  /// In en, this message translates to:
  /// **'balanced'**
  String get harmonySoundTagBalanced;

  /// No description provided for @harmonySoundTagPiano.
  ///
  /// In en, this message translates to:
  /// **'piano'**
  String get harmonySoundTagPiano;

  /// No description provided for @harmonySoundTagSoft.
  ///
  /// In en, this message translates to:
  /// **'soft'**
  String get harmonySoundTagSoft;

  /// No description provided for @harmonySoundTagOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get harmonySoundTagOpen;

  /// No description provided for @harmonySoundTagModern.
  ///
  /// In en, this message translates to:
  /// **'modern'**
  String get harmonySoundTagModern;

  /// No description provided for @harmonySoundTagDry.
  ///
  /// In en, this message translates to:
  /// **'dry'**
  String get harmonySoundTagDry;

  /// No description provided for @harmonySoundTagWarm.
  ///
  /// In en, this message translates to:
  /// **'warm'**
  String get harmonySoundTagWarm;

  /// No description provided for @harmonySoundTagEpReady.
  ///
  /// In en, this message translates to:
  /// **'EP-ready'**
  String get harmonySoundTagEpReady;

  /// No description provided for @harmonySoundTagClear.
  ///
  /// In en, this message translates to:
  /// **'clear'**
  String get harmonySoundTagClear;

  /// No description provided for @harmonySoundTagAcoustic.
  ///
  /// In en, this message translates to:
  /// **'acoustic'**
  String get harmonySoundTagAcoustic;

  /// No description provided for @harmonySoundTagFocused.
  ///
  /// In en, this message translates to:
  /// **'focused'**
  String get harmonySoundTagFocused;

  /// No description provided for @harmonySoundNeutralTrait1.
  ///
  /// In en, this message translates to:
  /// **'Steady hold for general harmonic checking'**
  String get harmonySoundNeutralTrait1;

  /// No description provided for @harmonySoundNeutralTrait2.
  ///
  /// In en, this message translates to:
  /// **'Balanced attack with low coloration'**
  String get harmonySoundNeutralTrait2;

  /// No description provided for @harmonySoundNeutralTrait3.
  ///
  /// In en, this message translates to:
  /// **'Safe fallback for any lesson or free-play context'**
  String get harmonySoundNeutralTrait3;

  /// No description provided for @harmonySoundNeutralExpansion1.
  ///
  /// In en, this message translates to:
  /// **'Future split by piano register or room size'**
  String get harmonySoundNeutralExpansion1;

  /// No description provided for @harmonySoundNeutralExpansion2.
  ///
  /// In en, this message translates to:
  /// **'Possible alternate shared instrument set for headphones'**
  String get harmonySoundNeutralExpansion2;

  /// No description provided for @harmonySoundPopTrait1.
  ///
  /// In en, this message translates to:
  /// **'Longer sustain for open hooks and add9 color'**
  String get harmonySoundPopTrait1;

  /// No description provided for @harmonySoundPopTrait2.
  ///
  /// In en, this message translates to:
  /// **'Softer attack with a little width in repeated previews'**
  String get harmonySoundPopTrait2;

  /// No description provided for @harmonySoundPopTrait3.
  ///
  /// In en, this message translates to:
  /// **'Gentle humanization so loops feel less grid-locked'**
  String get harmonySoundPopTrait3;

  /// No description provided for @harmonySoundPopExpansion1.
  ///
  /// In en, this message translates to:
  /// **'Bright pop keys or layered piano-synth asset'**
  String get harmonySoundPopExpansion1;

  /// No description provided for @harmonySoundPopExpansion2.
  ///
  /// In en, this message translates to:
  /// **'Wider stereo voicing playback for chorus lift'**
  String get harmonySoundPopExpansion2;

  /// No description provided for @harmonySoundJazzTrait1.
  ///
  /// In en, this message translates to:
  /// **'Shorter hold to keep cadence motion readable'**
  String get harmonySoundJazzTrait1;

  /// No description provided for @harmonySoundJazzTrait2.
  ///
  /// In en, this message translates to:
  /// **'Faster broken-preview feel for guide-tone hearing'**
  String get harmonySoundJazzTrait2;

  /// No description provided for @harmonySoundJazzTrait3.
  ///
  /// In en, this message translates to:
  /// **'More touch variation to suggest shell and rootless comping'**
  String get harmonySoundJazzTrait3;

  /// No description provided for @harmonySoundJazzExpansion1.
  ///
  /// In en, this message translates to:
  /// **'Dry upright or mellow electric-piano instrument family'**
  String get harmonySoundJazzExpansion1;

  /// No description provided for @harmonySoundJazzExpansion2.
  ///
  /// In en, this message translates to:
  /// **'Track-aware comping presets for shell and rootless drills'**
  String get harmonySoundJazzExpansion2;

  /// No description provided for @harmonySoundClassicalTrait1.
  ///
  /// In en, this message translates to:
  /// **'Centered sustain for function and cadence clarity'**
  String get harmonySoundClassicalTrait1;

  /// No description provided for @harmonySoundClassicalTrait2.
  ///
  /// In en, this message translates to:
  /// **'Low randomness to keep voice-leading stable'**
  String get harmonySoundClassicalTrait2;

  /// No description provided for @harmonySoundClassicalTrait3.
  ///
  /// In en, this message translates to:
  /// **'More direct block playback for harmonic arrival'**
  String get harmonySoundClassicalTrait3;

  /// No description provided for @harmonySoundClassicalExpansion1.
  ///
  /// In en, this message translates to:
  /// **'Direct acoustic piano profile with less ambient spread'**
  String get harmonySoundClassicalExpansion1;

  /// No description provided for @harmonySoundClassicalExpansion2.
  ///
  /// In en, this message translates to:
  /// **'Dedicated cadence and sequence preview voicings'**
  String get harmonySoundClassicalExpansion2;

  /// No description provided for @explanationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this works'**
  String get explanationSectionTitle;

  /// No description provided for @explanationReasonSection.
  ///
  /// In en, this message translates to:
  /// **'Why this result'**
  String get explanationReasonSection;

  /// No description provided for @explanationConfidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get explanationConfidenceHigh;

  /// No description provided for @explanationConfidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Plausible reading'**
  String get explanationConfidenceMedium;

  /// No description provided for @explanationConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Treat as a tentative reading'**
  String get explanationConfidenceLow;

  /// No description provided for @explanationAmbiguityLow.
  ///
  /// In en, this message translates to:
  /// **'Most of the progression points in one direction, but a light alternate reading is still possible.'**
  String get explanationAmbiguityLow;

  /// No description provided for @explanationAmbiguityMedium.
  ///
  /// In en, this message translates to:
  /// **'More than one plausible reading is still in play, so context matters here.'**
  String get explanationAmbiguityMedium;

  /// No description provided for @explanationAmbiguityHigh.
  ///
  /// In en, this message translates to:
  /// **'Several readings are competing, so treat this as a cautious, context-dependent explanation.'**
  String get explanationAmbiguityHigh;

  /// No description provided for @explanationCautionParser.
  ///
  /// In en, this message translates to:
  /// **'Some chord symbols were normalized before analysis.'**
  String get explanationCautionParser;

  /// No description provided for @explanationCautionAmbiguous.
  ///
  /// In en, this message translates to:
  /// **'There is more than one reasonable reading here.'**
  String get explanationCautionAmbiguous;

  /// No description provided for @explanationCautionAlternateKey.
  ///
  /// In en, this message translates to:
  /// **'A nearby key center also fits part of this progression.'**
  String get explanationCautionAlternateKey;

  /// No description provided for @explanationAlternativeSection.
  ///
  /// In en, this message translates to:
  /// **'Other readings'**
  String get explanationAlternativeSection;

  /// No description provided for @explanationAlternativeKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Alternate key: {keyLabel}'**
  String explanationAlternativeKeyLabel(Object keyLabel);

  /// No description provided for @explanationAlternativeKeyBody.
  ///
  /// In en, this message translates to:
  /// **'The harmonic pull is still valid, but another key center also explains some of the same chords.'**
  String get explanationAlternativeKeyBody;

  /// No description provided for @explanationAlternativeReadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Alternate reading: {romanNumeral}'**
  String explanationAlternativeReadingLabel(Object romanNumeral);

  /// No description provided for @explanationAlternativeReadingBody.
  ///
  /// In en, this message translates to:
  /// **'This is another possible interpretation rather than a single definitive label.'**
  String get explanationAlternativeReadingBody;

  /// No description provided for @explanationListeningSection.
  ///
  /// In en, this message translates to:
  /// **'Listening focus'**
  String get explanationListeningSection;

  /// No description provided for @explanationListeningGuideToneTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the 3rds and 7ths'**
  String get explanationListeningGuideToneTitle;

  /// No description provided for @explanationListeningGuideToneBody.
  ///
  /// In en, this message translates to:
  /// **'Listen for the smallest inner-line motion as the cadence resolves.'**
  String get explanationListeningGuideToneBody;

  /// No description provided for @explanationListeningDominantColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Listen for the dominant color'**
  String get explanationListeningDominantColorTitle;

  /// No description provided for @explanationListeningDominantColorBody.
  ///
  /// In en, this message translates to:
  /// **'Notice how the tension on the dominant wants to release, even before the final arrival lands.'**
  String get explanationListeningDominantColorBody;

  /// No description provided for @explanationListeningBackdoorTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear the softer backdoor pull'**
  String get explanationListeningBackdoorTitle;

  /// No description provided for @explanationListeningBackdoorBody.
  ///
  /// In en, this message translates to:
  /// **'Listen for the subdominant-minor color leading home by color and voice leading rather than a plain V-I push.'**
  String get explanationListeningBackdoorBody;

  /// No description provided for @explanationListeningBorrowedColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear the color shift'**
  String get explanationListeningBorrowedColorTitle;

  /// No description provided for @explanationListeningBorrowedColorBody.
  ///
  /// In en, this message translates to:
  /// **'Notice how the borrowed chord darkens or brightens the loop before it returns home.'**
  String get explanationListeningBorrowedColorBody;

  /// No description provided for @explanationListeningBassMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the bass motion'**
  String get explanationListeningBassMotionTitle;

  /// No description provided for @explanationListeningBassMotionBody.
  ///
  /// In en, this message translates to:
  /// **'Track how the bass note reshapes momentum, even when the upper harmony stays closely related.'**
  String get explanationListeningBassMotionBody;

  /// No description provided for @explanationListeningCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Hear the arrival'**
  String get explanationListeningCadenceTitle;

  /// No description provided for @explanationListeningCadenceBody.
  ///
  /// In en, this message translates to:
  /// **'Pay attention to which chord feels like the point of rest and how the approach prepares it.'**
  String get explanationListeningCadenceBody;

  /// No description provided for @explanationListeningAmbiguityTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare the competing readings'**
  String get explanationListeningAmbiguityTitle;

  /// No description provided for @explanationListeningAmbiguityBody.
  ///
  /// In en, this message translates to:
  /// **'Try hearing the same chord once for its local pull and once for its larger key-center role.'**
  String get explanationListeningAmbiguityBody;

  /// No description provided for @explanationPerformanceSection.
  ///
  /// In en, this message translates to:
  /// **'Performance focus'**
  String get explanationPerformanceSection;

  /// No description provided for @explanationPerformancePopTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the hook singable'**
  String get explanationPerformancePopTitle;

  /// No description provided for @explanationPerformancePopBody.
  ///
  /// In en, this message translates to:
  /// **'Favor clear top notes, repeated contour, and open voicings that support the vocal line.'**
  String get explanationPerformancePopBody;

  /// No description provided for @explanationPerformanceJazzTitle.
  ///
  /// In en, this message translates to:
  /// **'Target guide tones first'**
  String get explanationPerformanceJazzTitle;

  /// No description provided for @explanationPerformanceJazzBody.
  ///
  /// In en, this message translates to:
  /// **'Outline the 3rd and 7th before adding extra tensions or reharm color.'**
  String get explanationPerformanceJazzBody;

  /// No description provided for @explanationPerformanceJazzShellTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with shell tones'**
  String get explanationPerformanceJazzShellTitle;

  /// No description provided for @explanationPerformanceJazzShellBody.
  ///
  /// In en, this message translates to:
  /// **'Place the root, 3rd, and 7th cleanly first so the cadence stays easy to hear.'**
  String get explanationPerformanceJazzShellBody;

  /// No description provided for @explanationPerformanceJazzRootlessTitle.
  ///
  /// In en, this message translates to:
  /// **'Let the 3rd and 7th carry the shape'**
  String get explanationPerformanceJazzRootlessTitle;

  /// No description provided for @explanationPerformanceJazzRootlessBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the guide tones stable, then add 9 or 13 only if the line still resolves clearly.'**
  String get explanationPerformanceJazzRootlessBody;

  /// No description provided for @explanationPerformanceClassicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the voices disciplined'**
  String get explanationPerformanceClassicalTitle;

  /// No description provided for @explanationPerformanceClassicalBody.
  ///
  /// In en, this message translates to:
  /// **'Prioritize stable spacing, functional arrivals, and stepwise motion where possible.'**
  String get explanationPerformanceClassicalBody;

  /// No description provided for @explanationPerformanceDominantColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Add tension after the target is clear'**
  String get explanationPerformanceDominantColorTitle;

  /// No description provided for @explanationPerformanceDominantColorBody.
  ///
  /// In en, this message translates to:
  /// **'Land the guide tones first, then treat 9, 13, or altered color as decoration rather than the main signal.'**
  String get explanationPerformanceDominantColorBody;

  /// No description provided for @explanationPerformanceAmbiguityTitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor the most stable tones'**
  String get explanationPerformanceAmbiguityTitle;

  /// No description provided for @explanationPerformanceAmbiguityBody.
  ///
  /// In en, this message translates to:
  /// **'If the reading is ambiguous, emphasize the likely resolution tones before leaning into the more colorful option.'**
  String get explanationPerformanceAmbiguityBody;

  /// No description provided for @explanationPerformanceVoicingTitle.
  ///
  /// In en, this message translates to:
  /// **'Voicing cue'**
  String get explanationPerformanceVoicingTitle;

  /// No description provided for @explanationPerformanceMelodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Melody cue'**
  String get explanationPerformanceMelodyTitle;

  /// No description provided for @explanationPerformanceMelodyBody.
  ///
  /// In en, this message translates to:
  /// **'Lean on the structural target notes, then let passing tones fill the space around them.'**
  String get explanationPerformanceMelodyBody;

  /// No description provided for @explanationReasonFunctionalResolutionLabel.
  ///
  /// In en, this message translates to:
  /// **'Functional pull'**
  String get explanationReasonFunctionalResolutionLabel;

  /// No description provided for @explanationReasonFunctionalResolutionBody.
  ///
  /// In en, this message translates to:
  /// **'The chords line up as tonic, predominant, and dominant functions rather than isolated sonorities.'**
  String get explanationReasonFunctionalResolutionBody;

  /// No description provided for @explanationReasonGuideToneSmoothnessLabel.
  ///
  /// In en, this message translates to:
  /// **'Guide-tone motion'**
  String get explanationReasonGuideToneSmoothnessLabel;

  /// No description provided for @explanationReasonGuideToneSmoothnessBody.
  ///
  /// In en, this message translates to:
  /// **'The inner voices move efficiently, which strengthens the sense of direction.'**
  String get explanationReasonGuideToneSmoothnessBody;

  /// No description provided for @explanationReasonBorrowedColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Borrowed color'**
  String get explanationReasonBorrowedColorLabel;

  /// No description provided for @explanationReasonBorrowedColorBody.
  ///
  /// In en, this message translates to:
  /// **'A parallel-mode borrowing adds contrast without fully leaving the home key.'**
  String get explanationReasonBorrowedColorBody;

  /// No description provided for @explanationReasonSecondaryDominantLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary dominant pull'**
  String get explanationReasonSecondaryDominantLabel;

  /// No description provided for @explanationReasonSecondaryDominantBody.
  ///
  /// In en, this message translates to:
  /// **'This dominant points strongly toward a local target chord instead of only the tonic.'**
  String get explanationReasonSecondaryDominantBody;

  /// No description provided for @explanationReasonTritoneSubLabel.
  ///
  /// In en, this message translates to:
  /// **'Tritone-sub color'**
  String get explanationReasonTritoneSubLabel;

  /// No description provided for @explanationReasonTritoneSubBody.
  ///
  /// In en, this message translates to:
  /// **'The dominant color is preserved while the bass motion shifts to a substitute route.'**
  String get explanationReasonTritoneSubBody;

  /// No description provided for @explanationReasonDominantColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Dominant tension'**
  String get explanationReasonDominantColorLabel;

  /// No description provided for @explanationReasonDominantColorBody.
  ///
  /// In en, this message translates to:
  /// **'Altered or extended dominant color strengthens the pull toward the next chord without changing the whole key reading.'**
  String get explanationReasonDominantColorBody;

  /// No description provided for @explanationReasonBackdoorMotionLabel.
  ///
  /// In en, this message translates to:
  /// **'Backdoor motion'**
  String get explanationReasonBackdoorMotionLabel;

  /// No description provided for @explanationReasonBackdoorMotionBody.
  ///
  /// In en, this message translates to:
  /// **'This reading leans on subdominant-minor or backdoor motion, so the resolution feels softer but still directed.'**
  String get explanationReasonBackdoorMotionBody;

  /// No description provided for @explanationReasonCadentialStrengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Cadential shape'**
  String get explanationReasonCadentialStrengthLabel;

  /// No description provided for @explanationReasonCadentialStrengthBody.
  ///
  /// In en, this message translates to:
  /// **'The phrase ends with a stronger arrival than a neutral loop continuation.'**
  String get explanationReasonCadentialStrengthBody;

  /// No description provided for @explanationReasonVoiceLeadingStabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Stable voice leading'**
  String get explanationReasonVoiceLeadingStabilityLabel;

  /// No description provided for @explanationReasonVoiceLeadingStabilityBody.
  ///
  /// In en, this message translates to:
  /// **'The selected voicing keeps common tones or resolves tendency tones cleanly.'**
  String get explanationReasonVoiceLeadingStabilityBody;

  /// No description provided for @explanationReasonSingableContourLabel.
  ///
  /// In en, this message translates to:
  /// **'Singable contour'**
  String get explanationReasonSingableContourLabel;

  /// No description provided for @explanationReasonSingableContourBody.
  ///
  /// In en, this message translates to:
  /// **'The line favors memorable motion over angular, highly technical shapes.'**
  String get explanationReasonSingableContourBody;

  /// No description provided for @explanationReasonSlashBassLiftLabel.
  ///
  /// In en, this message translates to:
  /// **'Bass-motion lift'**
  String get explanationReasonSlashBassLiftLabel;

  /// No description provided for @explanationReasonSlashBassLiftBody.
  ///
  /// In en, this message translates to:
  /// **'The bass note changes the momentum even when the harmony stays closely related.'**
  String get explanationReasonSlashBassLiftBody;

  /// No description provided for @explanationReasonTurnaroundGravityLabel.
  ///
  /// In en, this message translates to:
  /// **'Turnaround gravity'**
  String get explanationReasonTurnaroundGravityLabel;

  /// No description provided for @explanationReasonTurnaroundGravityBody.
  ///
  /// In en, this message translates to:
  /// **'This pattern creates forward pull by cycling through familiar jazz resolution points.'**
  String get explanationReasonTurnaroundGravityBody;

  /// No description provided for @explanationReasonInversionDisciplineLabel.
  ///
  /// In en, this message translates to:
  /// **'Inversion control'**
  String get explanationReasonInversionDisciplineLabel;

  /// No description provided for @explanationReasonInversionDisciplineBody.
  ///
  /// In en, this message translates to:
  /// **'The inversion choice supports smoother outer-voice motion and clearer cadence behavior.'**
  String get explanationReasonInversionDisciplineBody;

  /// No description provided for @explanationReasonAmbiguityWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'Competing readings'**
  String get explanationReasonAmbiguityWindowLabel;

  /// No description provided for @explanationReasonAmbiguityWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Some of the same notes support more than one harmonic role, so context decides which reading feels stronger.'**
  String get explanationReasonAmbiguityWindowBody;

  /// No description provided for @explanationReasonChromaticLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Chromatic line'**
  String get explanationReasonChromaticLineLabel;

  /// No description provided for @explanationReasonChromaticLineBody.
  ///
  /// In en, this message translates to:
  /// **'A chromatic bass or inner-line connection helps explain why this chord fits despite the extra color.'**
  String get explanationReasonChromaticLineBody;

  /// No description provided for @explanationTrackContextPop.
  ///
  /// In en, this message translates to:
  /// **'In a pop context, this reading leans toward loop gravity, color contrast, and a singable top line.'**
  String get explanationTrackContextPop;

  /// No description provided for @explanationTrackContextJazz.
  ///
  /// In en, this message translates to:
  /// **'In a jazz context, this is one plausible reading that highlights guide tones, cadence pull, and usable dominant color.'**
  String get explanationTrackContextJazz;

  /// No description provided for @explanationTrackContextClassical.
  ///
  /// In en, this message translates to:
  /// **'In a classical context, this reading leans toward function, inversion awareness, and cadence strength.'**
  String get explanationTrackContextClassical;

  /// No description provided for @studyHarmonyTrackFocusSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'This track emphasizes'**
  String get studyHarmonyTrackFocusSectionTitle;

  /// No description provided for @studyHarmonyTrackLessFocusSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'This track treats more lightly'**
  String get studyHarmonyTrackLessFocusSectionTitle;

  /// No description provided for @studyHarmonyTrackRecommendedForSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for'**
  String get studyHarmonyTrackRecommendedForSectionTitle;

  /// No description provided for @studyHarmonyTrackSoundSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound profile'**
  String get studyHarmonyTrackSoundSectionTitle;

  /// No description provided for @studyHarmonyTrackSoundAssetPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Current release uses the shared piano asset. This profile prepares future track-specific sound choices.'**
  String get studyHarmonyTrackSoundAssetPlaceholder;

  /// No description provided for @studyHarmonyTrackSoundInstrumentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current instrument: {instrument}'**
  String studyHarmonyTrackSoundInstrumentLabel(Object instrument);

  /// No description provided for @studyHarmonyTrackSoundPlaybackLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended preview pattern: {pattern}'**
  String studyHarmonyTrackSoundPlaybackLabel(Object pattern);

  /// No description provided for @studyHarmonyTrackSoundPlaybackTraitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback character'**
  String get studyHarmonyTrackSoundPlaybackTraitsTitle;

  /// No description provided for @studyHarmonyTrackSoundExpansionTitle.
  ///
  /// In en, this message translates to:
  /// **'Expansion path'**
  String get studyHarmonyTrackSoundExpansionTitle;

  /// No description provided for @studyHarmonyTrackPopFocus1.
  ///
  /// In en, this message translates to:
  /// **'Diatonic loop gravity and hook-friendly repetition'**
  String get studyHarmonyTrackPopFocus1;

  /// No description provided for @studyHarmonyTrackPopFocus2.
  ///
  /// In en, this message translates to:
  /// **'Borrowed-color lifts such as iv, bVII, or IVMaj7'**
  String get studyHarmonyTrackPopFocus2;

  /// No description provided for @studyHarmonyTrackPopFocus3.
  ///
  /// In en, this message translates to:
  /// **'Slash-bass and pedal-bass motion that supports pre-chorus lift'**
  String get studyHarmonyTrackPopFocus3;

  /// No description provided for @studyHarmonyTrackPopLess1.
  ///
  /// In en, this message translates to:
  /// **'Dense jazz reharmonization and advanced substitute dominants'**
  String get studyHarmonyTrackPopLess1;

  /// No description provided for @studyHarmonyTrackPopLess2.
  ///
  /// In en, this message translates to:
  /// **'Rootless voicing systems and heavy altered-dominant language'**
  String get studyHarmonyTrackPopLess2;

  /// No description provided for @studyHarmonyTrackPopRecommendedFor.
  ///
  /// In en, this message translates to:
  /// **'Writers, producers, and players who want modern pop or ballad harmony that sounds usable quickly.'**
  String get studyHarmonyTrackPopRecommendedFor;

  /// No description provided for @studyHarmonyTrackPopTheoryTone.
  ///
  /// In en, this message translates to:
  /// **'Practical, song-first, and color-aware without overloading the learner with jargon.'**
  String get studyHarmonyTrackPopTheoryTone;

  /// No description provided for @studyHarmonyTrackPopHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Build hook-friendly loops'**
  String get studyHarmonyTrackPopHeroHeadline;

  /// No description provided for @studyHarmonyTrackPopHeroBody.
  ///
  /// In en, this message translates to:
  /// **'This track teaches loop gravity, restrained borrowed color, and bass movement that lifts a section without losing clarity.'**
  String get studyHarmonyTrackPopHeroBody;

  /// No description provided for @studyHarmonyTrackPopQuickPracticeCue.
  ///
  /// In en, this message translates to:
  /// **'Start with the signature loop chapter, then listen for how the bass and borrowed color reshape the same hook.'**
  String get studyHarmonyTrackPopQuickPracticeCue;

  /// No description provided for @studyHarmonyTrackPopSoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Soft / open / modern'**
  String get studyHarmonyTrackPopSoundLabel;

  /// No description provided for @studyHarmonyTrackPopSoundSummary.
  ///
  /// In en, this message translates to:
  /// **'Balanced piano now, with future room for brighter pop keys and wider stereo voicings.'**
  String get studyHarmonyTrackPopSoundSummary;

  /// No description provided for @studyHarmonyTrackJazzFocus1.
  ///
  /// In en, this message translates to:
  /// **'Guide-tone hearing and shell-to-rootless voicing growth'**
  String get studyHarmonyTrackJazzFocus1;

  /// No description provided for @studyHarmonyTrackJazzFocus2.
  ///
  /// In en, this message translates to:
  /// **'Major ii-V-I, minor iiø-V-i, and turnaround behavior'**
  String get studyHarmonyTrackJazzFocus2;

  /// No description provided for @studyHarmonyTrackJazzFocus3.
  ///
  /// In en, this message translates to:
  /// **'Dominant color, tensions, tritone sub, and backdoor entry points'**
  String get studyHarmonyTrackJazzFocus3;

  /// No description provided for @studyHarmonyTrackJazzLess1.
  ///
  /// In en, this message translates to:
  /// **'Purely song-loop repetition without cadence awareness'**
  String get studyHarmonyTrackJazzLess1;

  /// No description provided for @studyHarmonyTrackJazzLess2.
  ///
  /// In en, this message translates to:
  /// **'Classical inversion literacy as a primary objective'**
  String get studyHarmonyTrackJazzLess2;

  /// No description provided for @studyHarmonyTrackJazzRecommendedFor.
  ///
  /// In en, this message translates to:
  /// **'Players who want to hear and use functional jazz harmony without jumping straight into maximal reharm complexity.'**
  String get studyHarmonyTrackJazzRecommendedFor;

  /// No description provided for @studyHarmonyTrackJazzTheoryTone.
  ///
  /// In en, this message translates to:
  /// **'Contextual, confidence-aware, and careful about calling one reading the only correct jazz answer.'**
  String get studyHarmonyTrackJazzTheoryTone;

  /// No description provided for @studyHarmonyTrackJazzHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Hear the line inside the chords'**
  String get studyHarmonyTrackJazzHeroHeadline;

  /// No description provided for @studyHarmonyTrackJazzHeroBody.
  ///
  /// In en, this message translates to:
  /// **'This track turns jazz harmony into manageable steps: guide tones first, then cadence families, then tasteful dominant color.'**
  String get studyHarmonyTrackJazzHeroBody;

  /// No description provided for @studyHarmonyTrackJazzQuickPracticeCue.
  ///
  /// In en, this message translates to:
  /// **'Start with guide tones and shell voicings, then revisit the same cadence with rootless color.'**
  String get studyHarmonyTrackJazzQuickPracticeCue;

  /// No description provided for @studyHarmonyTrackJazzSoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Dry / warm / EP-ready'**
  String get studyHarmonyTrackJazzSoundLabel;

  /// No description provided for @studyHarmonyTrackJazzSoundSummary.
  ///
  /// In en, this message translates to:
  /// **'Shared piano for now, with placeholders for drier attacks and future electric-piano friendly playback.'**
  String get studyHarmonyTrackJazzSoundSummary;

  /// No description provided for @studyHarmonyTrackClassicalFocus1.
  ///
  /// In en, this message translates to:
  /// **'Tonic / predominant / dominant function and cadence types'**
  String get studyHarmonyTrackClassicalFocus1;

  /// No description provided for @studyHarmonyTrackClassicalFocus2.
  ///
  /// In en, this message translates to:
  /// **'Inversion literacy, including first inversion and cadential 6/4 behavior'**
  String get studyHarmonyTrackClassicalFocus2;

  /// No description provided for @studyHarmonyTrackClassicalFocus3.
  ///
  /// In en, this message translates to:
  /// **'Voice-leading stability, sequence, and functional modulation basics'**
  String get studyHarmonyTrackClassicalFocus3;

  /// No description provided for @studyHarmonyTrackClassicalLess1.
  ///
  /// In en, this message translates to:
  /// **'Heavy tension stacking, quartal color, and upper-structure thinking'**
  String get studyHarmonyTrackClassicalLess1;

  /// No description provided for @studyHarmonyTrackClassicalLess2.
  ///
  /// In en, this message translates to:
  /// **'Loop-driven pop repetition as the main learning frame'**
  String get studyHarmonyTrackClassicalLess2;

  /// No description provided for @studyHarmonyTrackClassicalRecommendedFor.
  ///
  /// In en, this message translates to:
  /// **'Learners who want clear functional hearing, inversion awareness, and disciplined voice leading.'**
  String get studyHarmonyTrackClassicalRecommendedFor;

  /// No description provided for @studyHarmonyTrackClassicalTheoryTone.
  ///
  /// In en, this message translates to:
  /// **'Structured, function-first, and phrased in a way that supports listening as well as label recognition.'**
  String get studyHarmonyTrackClassicalTheoryTone;

  /// No description provided for @studyHarmonyTrackClassicalHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Hear function and cadence clearly'**
  String get studyHarmonyTrackClassicalHeroHeadline;

  /// No description provided for @studyHarmonyTrackClassicalHeroBody.
  ///
  /// In en, this message translates to:
  /// **'This track emphasizes functional arrival, inversion control, and phrase endings that feel architecturally clear.'**
  String get studyHarmonyTrackClassicalHeroBody;

  /// No description provided for @studyHarmonyTrackClassicalQuickPracticeCue.
  ///
  /// In en, this message translates to:
  /// **'Start with cadence lab drills, then compare how inversions change the same function.'**
  String get studyHarmonyTrackClassicalQuickPracticeCue;

  /// No description provided for @studyHarmonyTrackClassicalSoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear / acoustic / focused'**
  String get studyHarmonyTrackClassicalSoundLabel;

  /// No description provided for @studyHarmonyTrackClassicalSoundSummary.
  ///
  /// In en, this message translates to:
  /// **'Shared piano for now, with room for a more direct acoustic profile in later releases.'**
  String get studyHarmonyTrackClassicalSoundSummary;

  /// No description provided for @studyHarmonyPopChapterSignatureLoopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Signature Pop Loops'**
  String get studyHarmonyPopChapterSignatureLoopsTitle;

  /// No description provided for @studyHarmonyPopChapterSignatureLoopsDescription.
  ///
  /// In en, this message translates to:
  /// **'Build practical pop instincts with hook gravity, borrowed lift, and bass motion that feels arrangement-ready.'**
  String get studyHarmonyPopChapterSignatureLoopsDescription;

  /// No description provided for @studyHarmonyPopLessonHookGravityTitle.
  ///
  /// In en, this message translates to:
  /// **'Hook Gravity'**
  String get studyHarmonyPopLessonHookGravityTitle;

  /// No description provided for @studyHarmonyPopLessonHookGravityDescription.
  ///
  /// In en, this message translates to:
  /// **'Hear why modern four-chord loops stay catchy even when the harmony is simple.'**
  String get studyHarmonyPopLessonHookGravityDescription;

  /// No description provided for @studyHarmonyPopLessonBorrowedLiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowed Lift'**
  String get studyHarmonyPopLessonBorrowedLiftTitle;

  /// No description provided for @studyHarmonyPopLessonBorrowedLiftDescription.
  ///
  /// In en, this message translates to:
  /// **'Experience restrained borrowed-color chords that brighten or darken a section without derailing the hook.'**
  String get studyHarmonyPopLessonBorrowedLiftDescription;

  /// No description provided for @studyHarmonyPopLessonBassMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bass Motion'**
  String get studyHarmonyPopLessonBassMotionTitle;

  /// No description provided for @studyHarmonyPopLessonBassMotionDescription.
  ///
  /// In en, this message translates to:
  /// **'Use slash-bass and line motion to create lift while the upper harmony stays familiar.'**
  String get studyHarmonyPopLessonBassMotionDescription;

  /// No description provided for @studyHarmonyPopLessonBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-Chorus Lift Checkpoint'**
  String get studyHarmonyPopLessonBossTitle;

  /// No description provided for @studyHarmonyPopLessonBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Combine loop gravity, borrowed color, and bass motion in one song-ready pop slice.'**
  String get studyHarmonyPopLessonBossDescription;

  /// No description provided for @studyHarmonyJazzChapterGuideToneLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Guide-Tone Lab'**
  String get studyHarmonyJazzChapterGuideToneLabTitle;

  /// No description provided for @studyHarmonyJazzChapterGuideToneLabDescription.
  ///
  /// In en, this message translates to:
  /// **'Move from clear major ii-V-I hearing into shell voicings, minor cadences, rootless color, and careful reharm entry points.'**
  String get studyHarmonyJazzChapterGuideToneLabDescription;

  /// No description provided for @studyHarmonyJazzLessonGuideTonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Guide-Tone Hearing'**
  String get studyHarmonyJazzLessonGuideTonesTitle;

  /// No description provided for @studyHarmonyJazzLessonGuideTonesDescription.
  ///
  /// In en, this message translates to:
  /// **'Track the 3rds and 7ths that define a clear major ii-V-I before adding extra color.'**
  String get studyHarmonyJazzLessonGuideTonesDescription;

  /// No description provided for @studyHarmonyJazzLessonShellVoicingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shell Voicings'**
  String get studyHarmonyJazzLessonShellVoicingsTitle;

  /// No description provided for @studyHarmonyJazzLessonShellVoicingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep the cadence clear with lean shell shapes and simple turnaround motion.'**
  String get studyHarmonyJazzLessonShellVoicingsDescription;

  /// No description provided for @studyHarmonyJazzLessonMinorCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Minor Cadence'**
  String get studyHarmonyJazzLessonMinorCadenceTitle;

  /// No description provided for @studyHarmonyJazzLessonMinorCadenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Recognize how minor iiø-V-i motion feels and why the dominant sounds more urgent there.'**
  String get studyHarmonyJazzLessonMinorCadenceDescription;

  /// No description provided for @studyHarmonyJazzLessonRootlessVoicingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rootless Voicings'**
  String get studyHarmonyJazzLessonRootlessVoicingsTitle;

  /// No description provided for @studyHarmonyJazzLessonRootlessVoicingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Hear the same turnaround after the bass drops out of the voicing and the color tones carry more weight.'**
  String get studyHarmonyJazzLessonRootlessVoicingsDescription;

  /// No description provided for @studyHarmonyJazzLessonDominantColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Dominant Tension'**
  String get studyHarmonyJazzLessonDominantColorTitle;

  /// No description provided for @studyHarmonyJazzLessonDominantColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Add 9ths, 13ths, sus, or altered pull without losing the cadence target.'**
  String get studyHarmonyJazzLessonDominantColorDescription;

  /// No description provided for @studyHarmonyJazzLessonBackdoorCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Tritone and Backdoor'**
  String get studyHarmonyJazzLessonBackdoorCadenceTitle;

  /// No description provided for @studyHarmonyJazzLessonBackdoorCadenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Compare substitute-dominant and backdoor arrivals as plausible jazz routes into the same tonic.'**
  String get studyHarmonyJazzLessonBackdoorCadenceDescription;

  /// No description provided for @studyHarmonyJazzLessonBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Turnaround Checkpoint'**
  String get studyHarmonyJazzLessonBossTitle;

  /// No description provided for @studyHarmonyJazzLessonBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Mix major ii-V-I, minor iiø-V-i, rootless color, and careful reharm so the cadence target still stays readable.'**
  String get studyHarmonyJazzLessonBossDescription;

  /// No description provided for @studyHarmonyClassicalChapterCadenceLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadence Lab'**
  String get studyHarmonyClassicalChapterCadenceLabTitle;

  /// No description provided for @studyHarmonyClassicalChapterCadenceLabDescription.
  ///
  /// In en, this message translates to:
  /// **'Strengthen functional hearing with cadences, inversions, and carefully controlled secondary dominants.'**
  String get studyHarmonyClassicalChapterCadenceLabDescription;

  /// No description provided for @studyHarmonyClassicalLessonCadenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Cadence Function'**
  String get studyHarmonyClassicalLessonCadenceTitle;

  /// No description provided for @studyHarmonyClassicalLessonCadenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Sort tonic, predominant, and dominant behavior by how each chord prepares or completes the phrase.'**
  String get studyHarmonyClassicalLessonCadenceDescription;

  /// No description provided for @studyHarmonyClassicalLessonInversionTitle.
  ///
  /// In en, this message translates to:
  /// **'Inversion Control'**
  String get studyHarmonyClassicalLessonInversionTitle;

  /// No description provided for @studyHarmonyClassicalLessonInversionDescription.
  ///
  /// In en, this message translates to:
  /// **'Hear how inversions change the bass line and the stability of an arrival.'**
  String get studyHarmonyClassicalLessonInversionDescription;

  /// No description provided for @studyHarmonyClassicalLessonSecondaryDominantTitle.
  ///
  /// In en, this message translates to:
  /// **'Functional Secondary Dominants'**
  String get studyHarmonyClassicalLessonSecondaryDominantTitle;

  /// No description provided for @studyHarmonyClassicalLessonSecondaryDominantDescription.
  ///
  /// In en, this message translates to:
  /// **'Treat secondary dominants as directed functional events instead of generic color chords.'**
  String get studyHarmonyClassicalLessonSecondaryDominantDescription;

  /// No description provided for @studyHarmonyClassicalLessonBossTitle.
  ///
  /// In en, this message translates to:
  /// **'Arrival Checkpoint'**
  String get studyHarmonyClassicalLessonBossTitle;

  /// No description provided for @studyHarmonyClassicalLessonBossDescription.
  ///
  /// In en, this message translates to:
  /// **'Combine cadence shape, inversion awareness, and secondary-dominant pull in one controlled phrase.'**
  String get studyHarmonyClassicalLessonBossDescription;

  /// No description provided for @studyHarmonyPlayStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'{playStyle, select, competitor{Competitor} collector{Collector} explorer{Explorer} stabilizer{Stabilizer} balanced{Balanced} other{Balanced}}'**
  String studyHarmonyPlayStyleLabel(String playStyle);

  /// No description provided for @studyHarmonyRewardFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'{focus, select, mastery{Focus: Mastery} achievements{Focus: Achievements} cosmetics{Focus: Cosmetics} currency{Focus: Currency} collection{Focus: Collection} other{Focus}}'**
  String studyHarmonyRewardFocusLabel(String focus);

  /// No description provided for @studyHarmonyNextUnlockProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Next {rewardTitle} {progress}%'**
  String studyHarmonyNextUnlockProgressLabel(String rewardTitle, int progress);

  /// No description provided for @studyHarmonyCurrencyBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'{currencyTitle} {amount}'**
  String studyHarmonyCurrencyBalanceLabel(String currencyTitle, int amount);

  /// No description provided for @studyHarmonyCurrencyGrantLabel.
  ///
  /// In en, this message translates to:
  /// **'{currencyTitle} +{amount}'**
  String studyHarmonyCurrencyGrantLabel(String currencyTitle, int amount);

  /// No description provided for @studyHarmonyDifficultyLaneLabel.
  ///
  /// In en, this message translates to:
  /// **'{lane, select, recovery{Recovery Lane} groove{Groove Lane} push{Push Lane} clutch{Clutch Lane} legend{Legend Lane} other{Practice Lane}}'**
  String studyHarmonyDifficultyLaneLabel(String lane);

  /// No description provided for @studyHarmonyPressureTierLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier, select, calm{Calm Pressure} steady{Steady Pressure} hot{Hot Pressure} charged{Charged Pressure} overdrive{Overdrive} other{Pressure}}'**
  String studyHarmonyPressureTierLabel(String tier);

  /// No description provided for @studyHarmonyForgivenessTierLabel.
  ///
  /// In en, this message translates to:
  /// **'{tier, select, strict{Strict Windows} tight{Tight Windows} balanced{Balanced Windows} kind{Kind Windows} generous{Generous Windows} other{Timing Windows}}'**
  String studyHarmonyForgivenessTierLabel(String tier);

  /// No description provided for @studyHarmonyComboGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Combo Goal {comboTarget}'**
  String studyHarmonyComboGoalLabel(int comboTarget);

  /// No description provided for @studyHarmonyRuntimeTuningSummary.
  ///
  /// In en, this message translates to:
  /// **'Lives {lives} | Goal {goal}'**
  String studyHarmonyRuntimeTuningSummary(int lives, int goal);

  /// No description provided for @studyHarmonyCoachLabel.
  ///
  /// In en, this message translates to:
  /// **'{style, select, supportive{Supportive Coach} structured{Structured Coach} challengeForward{Challenge Coach} analytical{Analytical Coach} restorative{Restorative Coach} other{Coach}}'**
  String studyHarmonyCoachLabel(String style);

  /// No description provided for @studyHarmonyCoachLine.
  ///
  /// In en, this message translates to:
  /// **'{style, select, supportive{Protect flow first and let confidence compound.} structured{Follow the structure and the gains will stick.} challengeForward{Lean into the pressure and push for a sharper run.} analytical{Read the weak point and refine it with precision.} restorative{This run is about rebuilding rhythm without tilt.} other{Keep the next run focused and intentional.}}'**
  String studyHarmonyCoachLine(String style);

  /// No description provided for @studyHarmonyPacingSegmentLabel.
  ///
  /// In en, this message translates to:
  /// **'{segment, select, warmup{Warmup} tension{Tension} release{Release} reward{Reward} other{Segment}} {minutes}m'**
  String studyHarmonyPacingSegmentLabel(String segment, int minutes);

  /// No description provided for @studyHarmonyPacingSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Pacing {segments}'**
  String studyHarmonyPacingSummaryLabel(String segments);

  /// No description provided for @studyHarmonyArcadeRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'{risk, select, forgiving{Low Risk} balanced{Balanced Risk} tense{High Tension} punishing{Punishing Risk} other{Arcade Risk}}'**
  String studyHarmonyArcadeRiskLabel(String risk);

  /// No description provided for @studyHarmonyArcadeRewardStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'{style, select, currency{Currency Loop} cosmetic{Cosmetic Hunt} title{Title Hunt} trophy{Trophy Run} bundle{Bundle Rewards} prestige{Prestige Rewards} other{Reward Loop}}'**
  String studyHarmonyArcadeRewardStyleLabel(String style);

  /// No description provided for @studyHarmonyArcadeRuntimeComboBonusLabel.
  ///
  /// In en, this message translates to:
  /// **'Combo bonus every {count}'**
  String studyHarmonyArcadeRuntimeComboBonusLabel(int count);

  /// No description provided for @studyHarmonyArcadeRuntimeMissCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Miss costs {lives}'**
  String studyHarmonyArcadeRuntimeMissCostLabel(int lives);

  /// No description provided for @studyHarmonyArcadeRuntimeModifierPulses.
  ///
  /// In en, this message translates to:
  /// **'Modifier pulses'**
  String get studyHarmonyArcadeRuntimeModifierPulses;

  /// No description provided for @studyHarmonyArcadeRuntimeGhostPressure.
  ///
  /// In en, this message translates to:
  /// **'Ghost pressure'**
  String get studyHarmonyArcadeRuntimeGhostPressure;

  /// No description provided for @studyHarmonyArcadeRuntimeShopBiasedLoot.
  ///
  /// In en, this message translates to:
  /// **'Shop-biased loot'**
  String get studyHarmonyArcadeRuntimeShopBiasedLoot;

  /// No description provided for @studyHarmonyArcadeRuntimeSteadyRuleset.
  ///
  /// In en, this message translates to:
  /// **'Steady ruleset'**
  String get studyHarmonyArcadeRuntimeSteadyRuleset;

  /// No description provided for @studyHarmonyShopStateLabel.
  ///
  /// In en, this message translates to:
  /// **'{state, select, alreadyPurchased{Already purchased} readyToBuy{Ready to buy} progressLocked{Progress locked} other{Shop state}}'**
  String studyHarmonyShopStateLabel(String state);

  /// No description provided for @studyHarmonyShopActionLabel.
  ///
  /// In en, this message translates to:
  /// **'{action, select, buy{Buy} equipped{Equipped} equip{Equip} other{Shop action}}'**
  String studyHarmonyShopActionLabel(String action);

  /// No description provided for @melodyCurrentLineFeelTitle.
  ///
  /// In en, this message translates to:
  /// **'Current line feel'**
  String get melodyCurrentLineFeelTitle;

  /// No description provided for @melodyLinePersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Line personality'**
  String get melodyLinePersonalityTitle;

  /// No description provided for @melodyLinePersonalityBody.
  ///
  /// In en, this message translates to:
  /// **'These four sliders shape why guided, standard, and advanced can feel different even before you change the harmony.'**
  String get melodyLinePersonalityBody;

  /// No description provided for @melodySyncopationBiasTitle.
  ///
  /// In en, this message translates to:
  /// **'Syncopation Bias'**
  String get melodySyncopationBiasTitle;

  /// No description provided for @melodySyncopationBiasBody.
  ///
  /// In en, this message translates to:
  /// **'Leans toward offbeat starts, anticipations, and rhythmic lift.'**
  String get melodySyncopationBiasBody;

  /// No description provided for @melodyColorRealizationBiasTitle.
  ///
  /// In en, this message translates to:
  /// **'Color Realization Bias'**
  String get melodyColorRealizationBiasTitle;

  /// No description provided for @melodyColorRealizationBiasBody.
  ///
  /// In en, this message translates to:
  /// **'Lets the melody pick up featured tensions and color tones more often.'**
  String get melodyColorRealizationBiasBody;

  /// No description provided for @melodyNoveltyTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'Novelty Target'**
  String get melodyNoveltyTargetTitle;

  /// No description provided for @melodyNoveltyTargetBody.
  ///
  /// In en, this message translates to:
  /// **'Reduces exact repeats and nudges the line toward fresher interval shapes.'**
  String get melodyNoveltyTargetBody;

  /// No description provided for @melodyMotifVariationBiasTitle.
  ///
  /// In en, this message translates to:
  /// **'Motif Variation Bias'**
  String get melodyMotifVariationBiasTitle;

  /// No description provided for @melodyMotifVariationBiasBody.
  ///
  /// In en, this message translates to:
  /// **'Turns motif reuse into sequence, tail changes, and rhythmic variation.'**
  String get melodyMotifVariationBiasBody;

  /// No description provided for @studyHarmonyArcadeRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Arcade Rules'**
  String get studyHarmonyArcadeRulesTitle;

  /// No description provided for @studyHarmonySessionLengthLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min run'**
  String studyHarmonySessionLengthLabel(int minutes);

  /// No description provided for @studyHarmonyRewardKindLabel.
  ///
  /// In en, this message translates to:
  /// **'{kind, select, achievement{Achievement} title{Title} cosmetic{Cosmetic} shopItem{Shop Unlock} other{Reward}}'**
  String studyHarmonyRewardKindLabel(String kind);

  /// No description provided for @studyHarmonyArcadeRuntimeMissLifeLabel.
  ///
  /// In en, this message translates to:
  /// **'Misses cost {lives} hearts'**
  String studyHarmonyArcadeRuntimeMissLifeLabel(int lives);

  /// No description provided for @studyHarmonyArcadeRuntimeMissProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Misses push progress back by {amount}'**
  String studyHarmonyArcadeRuntimeMissProgressLabel(int amount);

  /// No description provided for @studyHarmonyArcadeRuntimeComboProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Every {threshold} combo adds +{amount} progress'**
  String studyHarmonyArcadeRuntimeComboProgressLabel(int threshold, int amount);

  /// No description provided for @studyHarmonyArcadeRuntimeComboLifeLabel.
  ///
  /// In en, this message translates to:
  /// **'Every {threshold} combo adds +{amount} heart'**
  String studyHarmonyArcadeRuntimeComboLifeLabel(int threshold, int amount);

  /// No description provided for @studyHarmonyArcadeRuntimeComboResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Misses reset combo'**
  String get studyHarmonyArcadeRuntimeComboResetLabel;

  /// No description provided for @studyHarmonyArcadeRuntimeComboDropLabel.
  ///
  /// In en, this message translates to:
  /// **'Misses cut combo by {amount}'**
  String studyHarmonyArcadeRuntimeComboDropLabel(int amount);

  /// No description provided for @studyHarmonyArcadeRuntimeChoicesReshuffleLabel.
  ///
  /// In en, this message translates to:
  /// **'Choices reshuffle'**
  String get studyHarmonyArcadeRuntimeChoicesReshuffleLabel;

  /// No description provided for @studyHarmonyArcadeRuntimeMissedReplayLabel.
  ///
  /// In en, this message translates to:
  /// **'Missed prompts replay'**
  String get studyHarmonyArcadeRuntimeMissedReplayLabel;

  /// No description provided for @studyHarmonyArcadeRuntimeUniqueCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'No prompt repeats'**
  String get studyHarmonyArcadeRuntimeUniqueCycleLabel;

  /// No description provided for @studyHarmonyRuntimeBundleClearBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Bonus'**
  String get studyHarmonyRuntimeBundleClearBonusTitle;

  /// No description provided for @studyHarmonyRuntimeBundlePrecisionBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Precision Bonus'**
  String get studyHarmonyRuntimeBundlePrecisionBonusTitle;

  /// No description provided for @studyHarmonyRuntimeBundleComboBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Combo Bonus'**
  String get studyHarmonyRuntimeBundleComboBonusTitle;

  /// No description provided for @studyHarmonyRuntimeBundleModeBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode Bonus'**
  String get studyHarmonyRuntimeBundleModeBonusTitle;

  /// No description provided for @studyHarmonyRuntimeBundleMasteryBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Mastery Bonus'**
  String get studyHarmonyRuntimeBundleMasteryBonusTitle;

  /// No description provided for @melodyQuickPresetGuideLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Guide Line'**
  String get melodyQuickPresetGuideLineLabel;

  /// No description provided for @melodyQuickPresetSongLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Song Line'**
  String get melodyQuickPresetSongLineLabel;

  /// No description provided for @melodyQuickPresetColorLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Line'**
  String get melodyQuickPresetColorLineLabel;

  /// No description provided for @melodyQuickPresetGuideCompactLabel.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get melodyQuickPresetGuideCompactLabel;

  /// No description provided for @melodyQuickPresetSongCompactLabel.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get melodyQuickPresetSongCompactLabel;

  /// No description provided for @melodyQuickPresetColorCompactLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get melodyQuickPresetColorCompactLabel;

  /// No description provided for @melodyQuickPresetGuideShort.
  ///
  /// In en, this message translates to:
  /// **'steady guide notes'**
  String get melodyQuickPresetGuideShort;

  /// No description provided for @melodyQuickPresetSongShort.
  ///
  /// In en, this message translates to:
  /// **'singable contour'**
  String get melodyQuickPresetSongShort;

  /// No description provided for @melodyQuickPresetColorShort.
  ///
  /// In en, this message translates to:
  /// **'color-forward line'**
  String get melodyQuickPresetColorShort;

  /// No description provided for @melodyQuickPresetPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Melody Presets'**
  String get melodyQuickPresetPanelTitle;

  /// No description provided for @melodyQuickPresetPanelCompactTitle.
  ///
  /// In en, this message translates to:
  /// **'Line Presets'**
  String get melodyQuickPresetPanelCompactTitle;

  /// No description provided for @melodyQuickPresetOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get melodyQuickPresetOffLabel;

  /// No description provided for @melodyQuickPresetCompactOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Line Off'**
  String get melodyQuickPresetCompactOffLabel;

  /// No description provided for @melodyMetricDensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get melodyMetricDensityLabel;

  /// No description provided for @melodyMetricStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get melodyMetricStyleLabel;

  /// No description provided for @melodyMetricSyncLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get melodyMetricSyncLabel;

  /// No description provided for @melodyMetricColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get melodyMetricColorLabel;

  /// No description provided for @melodyMetricNoveltyLabel.
  ///
  /// In en, this message translates to:
  /// **'Novelty'**
  String get melodyMetricNoveltyLabel;

  /// No description provided for @melodyMetricMotifLabel.
  ///
  /// In en, this message translates to:
  /// **'Motif'**
  String get melodyMetricMotifLabel;

  /// No description provided for @melodyMetricChromaticLabel.
  ///
  /// In en, this message translates to:
  /// **'Chromatic'**
  String get melodyMetricChromaticLabel;

  /// No description provided for @practiceFirstRunWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first chord is ready'**
  String get practiceFirstRunWelcomeTitle;

  /// No description provided for @practiceFirstRunWelcomeBodyEmpty.
  ///
  /// In en, this message translates to:
  /// **'A beginner-friendly starting profile is already applied. Listen first, then swipe the card to explore the next chord.'**
  String get practiceFirstRunWelcomeBodyEmpty;

  /// No description provided for @practiceFirstRunWelcomeBodyReady.
  ///
  /// In en, this message translates to:
  /// **'{chordLabel} is ready to go. Listen first, then swipe the card to explore what comes next. You can still open the setup assistant to personalize the start.'**
  String practiceFirstRunWelcomeBodyReady(Object chordLabel);

  /// No description provided for @practiceFirstRunSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Personalize'**
  String get practiceFirstRunSetupButton;

  /// No description provided for @musicNotationLocale.
  ///
  /// In en, this message translates to:
  /// **'Music notation language'**
  String get musicNotationLocale;

  /// No description provided for @musicNotationLocaleHelp.
  ///
  /// In en, this message translates to:
  /// **'Controls the language used for optional Roman numeral and chord-text assists.'**
  String get musicNotationLocaleHelp;

  /// No description provided for @musicNotationLocaleUiDefault.
  ///
  /// In en, this message translates to:
  /// **'Match app language'**
  String get musicNotationLocaleUiDefault;

  /// No description provided for @musicNotationLocaleEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get musicNotationLocaleEnglish;

  /// No description provided for @noteNamingStyle.
  ///
  /// In en, this message translates to:
  /// **'Note naming'**
  String get noteNamingStyle;

  /// No description provided for @noteNamingStyleHelp.
  ///
  /// In en, this message translates to:
  /// **'Switches displayed note and key names without changing harmonic logic.'**
  String get noteNamingStyleHelp;

  /// No description provided for @noteNamingStyleEnglish.
  ///
  /// In en, this message translates to:
  /// **'English letters'**
  String get noteNamingStyleEnglish;

  /// No description provided for @noteNamingStyleLatin.
  ///
  /// In en, this message translates to:
  /// **'Do Re Mi'**
  String get noteNamingStyleLatin;

  /// No description provided for @showRomanNumeralAssist.
  ///
  /// In en, this message translates to:
  /// **'Show Roman numeral assist'**
  String get showRomanNumeralAssist;

  /// No description provided for @showRomanNumeralAssistHelp.
  ///
  /// In en, this message translates to:
  /// **'Adds a short explanation next to Roman numeral labels.'**
  String get showRomanNumeralAssistHelp;

  /// No description provided for @showChordTextAssist.
  ///
  /// In en, this message translates to:
  /// **'Show chord text assist'**
  String get showChordTextAssist;

  /// No description provided for @showChordTextAssistHelp.
  ///
  /// In en, this message translates to:
  /// **'Adds a short text explanation for chord quality and tensions.'**
  String get showChordTextAssistHelp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
