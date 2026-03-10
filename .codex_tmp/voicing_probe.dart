import 'package:sightchord/music/chord_theory.dart';
import 'package:sightchord/music/voicing_engine.dart';
import 'package:sightchord/settings/practice_settings.dart';

GeneratedChord chord({required String root, required ChordQuality quality, required String key, required KeyMode mode, RomanNumeralId? roman, List<String> tensions = const [], HarmonicFunction function = HarmonicFunction.free, DominantContext? dominantContext, DominantIntent? dominantIntent}) {
  return GeneratedChord(
    symbolData: ChordSymbolData(root: root, harmonicQuality: quality, renderQuality: quality, tensions: tensions),
    repeatGuardKey: '$root-${quality.name}',
    harmonicComparisonKey: '$root-${quality.name}',
    keyName: key,
    keyCenter: KeyCenter(tonicName: key, mode: mode),
    romanNumeralId: roman,
    harmonicFunction: function,
    dominantContext: dominantContext,
    dominantIntent: dominantIntent,
  );
}

void dump(String label, GeneratedChord c) {
  final settings = PracticeSettings(activeKeys: const {'C','A'}, allowTensions: true, voicingSuggestionsEnabled: true, allowRootlessVoicings: true, voicingComplexity: VoicingComplexity.modern, maxVoicingNotes: 4);
  final result = VoicingEngine.recommend(context: VoicingContext(currentChord: c, settings: settings));
  print('--- $label');
  for (final s in result.suggestions) {
    print('${s.kind.name}: ${s.voicing.family.name} ${s.voicing.noteNames.join('-')} ${s.reasonTags.map((e)=>e.name).toList()}');
  }
  print('families=${result.rankedCandidates.map((e)=>e.voicing.family.name).toSet().toList()}');
}

void main() {
  dump('Dm7', chord(root:'D', quality:ChordQuality.minor7, key:'C', mode:KeyMode.major, roman:RomanNumeralId.iiMin7, function:HarmonicFunction.predominant));
  dump('G7sus', chord(root:'G', quality:ChordQuality.dominant7sus4, key:'C', mode:KeyMode.major, roman:RomanNumeralId.vDom7, function:HarmonicFunction.dominant, dominantContext:DominantContext.susDominant, dominantIntent:DominantIntent.susDelay));
  dump('G7#11', chord(root:'G', quality:ChordQuality.dominant7Sharp11, key:'D', mode:KeyMode.major, roman:RomanNumeralId.vDom7, function:HarmonicFunction.dominant, dominantContext:DominantContext.dominantIILydian, dominantIntent:DominantIntent.lydianDominant));
  dump('E7alt', chord(root:'E', quality:ChordQuality.dominant7Alt, key:'A', mode:KeyMode.minor, roman:RomanNumeralId.vDom7, function:HarmonicFunction.dominant, dominantContext:DominantContext.primaryMinor, dominantIntent:DominantIntent.primaryAuthenticMinor));
}
