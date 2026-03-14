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
  /// **'The analyzer reads this progression most clearly in {keyLabel}.'**
  String studyHarmonyProgressionExplanationKeyCenter(Object keyLabel);

  /// No description provided for @studyHarmonyProgressionExplanationFunction.
  ///
  /// In en, this message translates to:
  /// **'{chord} behaves most like a {functionLabel} chord in this context.'**
  String studyHarmonyProgressionExplanationFunction(
    Object chord,
    Object functionLabel,
  );

  /// No description provided for @studyHarmonyProgressionExplanationNonDiatonic.
  ///
  /// In en, this message translates to:
  /// **'{chord} stands out against the main {keyLabel} reading, so it is the best non-diatonic pick.'**
  String studyHarmonyProgressionExplanationNonDiatonic(
    Object chord,
    Object keyLabel,
  );

  /// No description provided for @studyHarmonyProgressionExplanationMissingChord.
  ///
  /// In en, this message translates to:
  /// **'{chord} restores the expected {functionLabel} pull in this progression.'**
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
