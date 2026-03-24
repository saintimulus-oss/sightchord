import 'package:flutter_test/flutter_test.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:chordest/music/progression_variation_generator.dart';

void main() {
  const analyzer = ProgressionAnalyzer();
  const generator = ProgressionVariationGenerator();

  test('major ii-V-I produces natural cadential variations', () {
    final analysis = analyzer.analyze('Dm7 G7 Cmaj7');
    final variations = generator.generate(analysis);

    expect(
      variations.map((variation) => variation.progression),
      containsAll(<String>['Dm7b5 Db7 Cmaj9', 'Fm7 Bb7 C6/9', 'Dm9 G13 Cmaj9']),
    );
  });

  test('minor cadence leans into ii half-diminished and altered dominant', () {
    final analysis = analyzer.analyze('Bm7b5 E7 Am7');
    final variations = generator.generate(analysis);

    expect(
      variations.any(
        (variation) =>
            variation.kind == ProgressionVariationKind.minorCadenceColor &&
            variation.progression == 'Bm7b5 E7alt Am6',
      ),
      isTrue,
    );
  });

  test('dominant-led approach to a non-tonic target can be reharmonized', () {
    final analysis = analyzer.analyze('Cmaj7 A7 Dm7 G7');
    final variations = generator.generate(analysis);

    expect(
      variations.any(
        (variation) =>
            variation.kind == ProgressionVariationKind.appliedApproach &&
            variation.progression == 'Em7 A7alt Dm9 G7',
      ),
      isTrue,
    );
  });

  test('placeholder diagnostics gate generated variations', () {
    final analysis = analyzer.analyze('Dm7 G7 | ? Am');
    final variations = generator.generate(analysis);

    expect(variations, isEmpty);
  });
}
