import '../music/chord_theory.dart';

enum OnboardingGoal { earTraining, keyboardPractice, songIdeas, harmonyStudy }

enum HarmonyLiteracy {
  absoluteBeginner,
  basicChordReader,
  functionalHarmony,
  reharmReady,
}

enum HandComfort { threeNotes, fourNotes, jazzShapes }

enum ExplorationPreference { safe, jazzy, colorful }

class GeneratorProfile {
  const GeneratorProfile({
    this.goal = OnboardingGoal.earTraining,
    this.harmonyLiteracy = HarmonyLiteracy.absoluteBeginner,
    this.handComfort = HandComfort.threeNotes,
    this.explorationPreference = ExplorationPreference.safe,
    this.chordSymbolStyle = ChordSymbolStyle.majText,
    this.startingKeyCenter = const KeyCenter(
      tonicName: 'C',
      mode: KeyMode.major,
    ),
  });

  static const KeyCenter defaultStartingKeyCenter = KeyCenter(
    tonicName: 'C',
    mode: KeyMode.major,
  );

  static const List<KeyCenter> supportedStartingKeyCenters = [
    KeyCenter(tonicName: 'C', mode: KeyMode.major),
    KeyCenter(tonicName: 'G', mode: KeyMode.major),
    KeyCenter(tonicName: 'F', mode: KeyMode.major),
  ];

  final OnboardingGoal goal;
  final HarmonyLiteracy harmonyLiteracy;
  final HandComfort handComfort;
  final ExplorationPreference explorationPreference;
  final ChordSymbolStyle chordSymbolStyle;
  final KeyCenter startingKeyCenter;

  bool get asksHandComfort =>
      goal == OnboardingGoal.earTraining ||
      goal == OnboardingGoal.keyboardPractice;

  bool get asksExplorationPreference =>
      harmonyLiteracy != HarmonyLiteracy.absoluteBeginner;

  GeneratorProfile copyWith({
    OnboardingGoal? goal,
    HarmonyLiteracy? harmonyLiteracy,
    HandComfort? handComfort,
    ExplorationPreference? explorationPreference,
    ChordSymbolStyle? chordSymbolStyle,
    KeyCenter? startingKeyCenter,
  }) {
    return GeneratorProfile(
      goal: goal ?? this.goal,
      harmonyLiteracy: harmonyLiteracy ?? this.harmonyLiteracy,
      handComfort: handComfort ?? this.handComfort,
      explorationPreference:
          explorationPreference ?? this.explorationPreference,
      chordSymbolStyle: chordSymbolStyle ?? this.chordSymbolStyle,
      startingKeyCenter: startingKeyCenter ?? this.startingKeyCenter,
    );
  }
}
