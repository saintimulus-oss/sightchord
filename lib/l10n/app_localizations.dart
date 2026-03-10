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
  /// **'Space: next chord  Enter: start or stop autoplay  Up/Down: adjust BPM'**
  String get keyboardShortcutHelp;

  /// No description provided for @nextChord.
  ///
  /// In en, this message translates to:
  /// **'Next Chord'**
  String get nextChord;

  /// No description provided for @startAutoplay.
  ///
  /// In en, this message translates to:
  /// **'Start Autoplay'**
  String get startAutoplay;

  /// No description provided for @stopAutoplay.
  ///
  /// In en, this message translates to:
  /// **'Stop Autoplay'**
  String get stopAutoplay;

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
