import 'isophonics_choco_external_gold_adapter.dart';

const ChocoSurfaceExternalGoldConfig _defaultJaahChocoConfig =
    ChocoSurfaceExternalGoldConfig(
      corpusId: 'jaah_choco_slice',
      corpusName: 'ChoCo JAAH Jazz Slice',
      sourceUrl: 'https://github.com/smashub/choco',
      licenseNote:
          'Source JAMS files from ChoCo JAAH (CC BY-NC-SA 4.0). '
          'Fixture provenance is documented in '
          'tool/benchmark_fixtures/external_gold/jaah_choco/README.md.',
      genreFamily: 'jazz',
      recordIdPrefix: 'jaah',
    );

typedef JaahChocoExternalGoldImportResult =
    IsophonicsChocoExternalGoldImportResult;

class JaahChocoExternalGoldAdapter {
  const JaahChocoExternalGoldAdapter();

  JaahChocoExternalGoldImportResult importExcerptDirectory(
    String inputDir, {
    String? manifestOutputPath,
  }) {
    return const IsophonicsChocoExternalGoldAdapter(
      config: _defaultJaahChocoConfig,
    ).importExcerptDirectory(inputDir, manifestOutputPath: manifestOutputPath);
  }
}
