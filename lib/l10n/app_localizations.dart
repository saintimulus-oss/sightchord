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

  /// No description provided for @mainMenuIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose a practice generator or open the analyzer for a separate progression reading workflow.'**
  String get mainMenuIntro;

  /// No description provided for @mainMenuGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Generator'**
  String get mainMenuGeneratorTitle;

  /// No description provided for @mainMenuGeneratorDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate practice chords with key-aware random mode, smart motion, and voicing suggestions.'**
  String get mainMenuGeneratorDescription;

  /// No description provided for @openGenerator.
  ///
  /// In en, this message translates to:
  /// **'Open Generator'**
  String get openGenerator;

  /// No description provided for @openAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Open Analyzer'**
  String get openAnalyzer;

  /// No description provided for @mainMenuAnalyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Analyzer'**
  String get mainMenuAnalyzerTitle;

  /// No description provided for @mainMenuAnalyzerDescription.
  ///
  /// In en, this message translates to:
  /// **'Analyze a written progression for likely key centers, Roman numerals, and harmonic functions.'**
  String get mainMenuAnalyzerDescription;

  /// No description provided for @mainMenuStudyHarmonyTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Harmony'**
  String get mainMenuStudyHarmonyTitle;

  /// No description provided for @mainMenuStudyHarmonyDescription.
  ///
  /// In en, this message translates to:
  /// **'Move through a real harmony study hub with continue, review, daily, and chapter-based lessons.'**
  String get mainMenuStudyHarmonyDescription;

  /// No description provided for @openStudyHarmony.
  ///
  /// In en, this message translates to:
  /// **'Open Study Harmony'**
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
  /// **'Prototype system'**
  String get studyHarmonyPlaceholderTag;

  /// No description provided for @studyHarmonyPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'The prototype separates level data, prompt presentation, and answer input so future note, chord, scale, and reverse-identification drills can reuse the same flow.'**
  String get studyHarmonyPlaceholderBody;

  /// No description provided for @studyHarmonyTestLevelTag.
  ///
  /// In en, this message translates to:
  /// **'Test level'**
  String get studyHarmonyTestLevelTag;

  /// No description provided for @studyHarmonyTestLevelAction.
  ///
  /// In en, this message translates to:
  /// **'Open test level'**
  String get studyHarmonyTestLevelAction;

  /// No description provided for @studyHarmonySubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get studyHarmonySubmit;

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
  /// **'Pulled from your current review queue placeholder.'**
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
  /// **'Legacy Mode'**
  String get studyHarmonyModeLegacy;

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
  /// **'Start with notes and the keyboard, then build up through chords, scales, Roman numerals, and diatonic basics.'**
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
  /// **'A song-focused path is planned after the Core track is stable.'**
  String get studyHarmonyPopTrackDescription;

  /// No description provided for @studyHarmonyJazzTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Jazz Track'**
  String get studyHarmonyJazzTrackTitle;

  /// No description provided for @studyHarmonyJazzTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Jazz harmony content stays locked until the Core curriculum settles.'**
  String get studyHarmonyJazzTrackDescription;

  /// No description provided for @studyHarmonyClassicalTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Classical Track'**
  String get studyHarmonyClassicalTrackTitle;

  /// No description provided for @studyHarmonyClassicalTrackDescription.
  ///
  /// In en, this message translates to:
  /// **'Functional harmony in classical contexts will arrive in a later phase.'**
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

  /// No description provided for @chordAnalyzerTitle.
  ///
  /// In en, this message translates to:
  /// **'Chord Analyzer'**
  String get chordAnalyzerTitle;

  /// No description provided for @chordAnalyzerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paste a progression and get a conservative harmonic reading.'**
  String get chordAnalyzerSubtitle;

  /// No description provided for @chordAnalyzerInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Chord progression'**
  String get chordAnalyzerInputLabel;

  /// No description provided for @chordAnalyzerInputHint.
  ///
  /// In en, this message translates to:
  /// **'Dm7 G7 Cmaj7'**
  String get chordAnalyzerInputHint;

  /// No description provided for @chordAnalyzerInputHelper.
  ///
  /// In en, this message translates to:
  /// **'Separators outside parentheses can be spaces, |, or commas. Commas inside parentheses stay inside one chord. Lowercase roots, slash bass, sus/alt/add forms, and tensions such as C7(b9, #11) are supported. Touch devices can use the chord pad or switch to ABC input.'**
  String get chordAnalyzerInputHelper;

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
  /// **'Clear'**
  String get chordAnalyzerClear;

  /// No description provided for @chordAnalyzerBackspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get chordAnalyzerBackspace;

  /// No description provided for @chordAnalyzerSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
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
  /// **'Enter a progression such as Dm7 G7 Cmaj7 or Cmaj7 | Am7 D7 | Gmaj7 to see likely keys, Roman numerals, and a short summary.'**
  String get chordAnalyzerInitialBody;

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
