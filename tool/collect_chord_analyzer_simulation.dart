import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chordest/music/chord_theory.dart';
import 'package:chordest/music/progression_analysis_models.dart';
import 'package:chordest/music/progression_analyzer.dart';
import 'package:chordest/music/progression_parser.dart';
import 'package:chordest/music/progression_variation_generator.dart';
import 'package:chordest/settings/practice_settings.dart';
import 'package:chordest/smart_generator.dart';

const String _defaultOutputDir = 'output/chord_analyzer_simulation';
const int _targetTotalRecords = 600;
const int _targetGeneratorRecords = 420;

void main() {
  final configuredOutputDir =
      Platform.environment['CHORD_ANALYZER_SIM_OUTPUT_DIR'];
  final outputDir = Directory(
    configuredOutputDir != null && configuredOutputDir.trim().isNotEmpty
        ? configuredOutputDir.trim()
        : _defaultOutputDir,
  )..createSync(recursive: true);

  final collector = _SimulationCollector(outputDir: outputDir);
  collector.collect();
  collector.writeOutputs();

  stdout.writeln(
    'Chord analyzer simulation dataset written to ${outputDir.path}',
  );
  stdout.writeln(
    'Records: ${collector.records.length} '
    '(generator: ${collector.generatorRecordCount}, '
    'pad: ${collector.padRecipeCount})',
  );
}

class _SimulationCollector {
  _SimulationCollector({required this.outputDir});

  final Directory outputDir;
  final ProgressionParser _parser = const ProgressionParser();
  final ProgressionAnalyzer _analyzer = const ProgressionAnalyzer();
  final ProgressionVariationGenerator _variationGenerator =
      const ProgressionVariationGenerator();
  final List<Map<String, Object?>> records = <Map<String, Object?>>[];
  final Set<String> _recordKeys = <String>{};
  final Set<String> _generatorContentSignatures = <String>{};

  int _nextId = 1;
  int generatorRecordCount = 0;
  int padRecipeCount = 0;

  void collect() {
    _collectManualCases();
    _collectPadRecipeCases();
    _collectCoverageMatrixCases();
    _collectSmartGeneratorCases();
    _collectFormattingVariants();
  }

  void writeOutputs() {
    final recordsJsonPath = File(_join(outputDir.path, 'records.json'));
    final recordsJsonlPath = File(_join(outputDir.path, 'records.jsonl'));
    final recordsCsvPath = File(_join(outputDir.path, 'records.csv'));
    final summaryJsonPath = File(_join(outputDir.path, 'summary.json'));
    final summaryMdPath = File(_join(outputDir.path, 'summary.md'));

    final summary = _buildSummary();
    recordsJsonPath.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(records)}\n',
    );
    recordsJsonlPath.writeAsStringSync(
      '${records.map(jsonEncode).join('\n')}\n',
    );
    recordsCsvPath.writeAsStringSync(_toCsv(records));
    summaryJsonPath.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(summary)}\n',
    );
    summaryMdPath.writeAsStringSync('${_summaryMarkdown(summary)}\n');
  }

  void _collectManualCases() {
    const manualCases = <_ManualCase>[
      _ManualCase(
        input: 'Dm7 G7 Cmaj7',
        source: 'manual_core',
        entryMode: 'raw_text',
        notes: 'Straight major ii-V-I baseline.',
      ),
      _ManualCase(
        input: 'Am7 D7 Gmaj7',
        source: 'manual_core',
        entryMode: 'raw_text',
        notes: 'Straight major ii-V-I in G.',
      ),
      _ManualCase(
        input: 'Cmaj7 A7 Dm7 G7',
        source: 'manual_functional',
        entryMode: 'raw_text',
        notes: 'Secondary dominant inside a turnaround.',
      ),
      _ManualCase(
        input: 'Cmaj7 | A7 | Dm7 G7 | Cmaj7',
        source: 'manual_functional',
        entryMode: 'raw_text',
        notes: 'Conservative tonicization across measures.',
      ),
      _ManualCase(
        input:
            'Cmaj7 Dm7 G7 Cmaj7 | Em7 A7 | Dmaj7 Gmaj7 | A7 Dmaj7 | G7 Cmaj7',
        source: 'manual_modulation',
        entryMode: 'raw_text',
        notes: 'Longer real-modulation example.',
      ),
      _ManualCase(
        input: 'Db7 Cmaj7',
        source: 'manual_color',
        entryMode: 'raw_text',
        notes: 'Possible tritone substitute cadence.',
      ),
      _ManualCase(
        input: 'Fm7 Bb7 Cmaj7',
        source: 'manual_color',
        entryMode: 'raw_text',
        notes: 'Backdoor dominant with subdominant minor.',
      ),
      _ManualCase(
        input: 'C#dim7 Cmaj7',
        source: 'manual_color',
        entryMode: 'raw_text',
        notes: 'Common-tone diminished motion.',
      ),
      _ManualCase(
        input: 'Cmaj7 G7 Am7 | Dm7 G7 Cmaj7',
        source: 'manual_color',
        entryMode: 'raw_text',
        notes: 'Deceptive cadence followed by recovery.',
      ),
      _ManualCase(
        input: 'Cmaj7/E A7(b9) Dm7 G7',
        source: 'manual_functional',
        entryMode: 'raw_text',
        notes: 'Slash bass plus applied dominant evidence.',
      ),
      _ManualCase(
        input: 'Dm9 G13 Cmaj9',
        source: 'manual_extensions',
        entryMode: 'raw_text',
        notes: 'Extension-preserving Roman output.',
      ),
      _ManualCase(
        input: 'C F G C',
        source: 'manual_triads',
        entryMode: 'raw_text',
        notes: 'Plain major triads.',
      ),
      _ManualCase(
        input: 'Am Dm E Am',
        source: 'manual_triads',
        entryMode: 'raw_text',
        notes: 'Plain minor triads.',
      ),
      _ManualCase(
        input: 'B7 Em7b5 A7 Dm',
        source: 'manual_minor',
        entryMode: 'raw_text',
        notes: 'Mode-aware applied dominant in minor.',
      ),
      _ManualCase(
        input: 'cmaj7 am7 d7 gmaj7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Lowercase roots.',
      ),
      _ManualCase(
        input: 'C7(b9, #11) Fmaj7',
        source: 'manual_extensions',
        entryMode: 'raw_text',
        notes: 'Comma-separated tensions inside one token.',
      ),
      _ManualCase(
        input: 'Dm7b5 G7 CmMaj7',
        source: 'manual_minor',
        entryMode: 'raw_text',
        notes: 'Minor ii-V-i with tonic minor-major seventh.',
      ),
      _ManualCase(
        input: 'C/H | G7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Invalid slash bass retained as parse issue.',
      ),
      _ManualCase(
        input: 'Dm7 - G7 - ? - Am7',
        source: 'manual_placeholder',
        entryMode: 'raw_text',
        notes: 'Placeholder inference with dash connectors.',
      ),
      _ManualCase(
        input: 'Bb-7 Eb7 Abmaj7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Minus notation for minor seventh.',
      ),
      _ManualCase(
        input: 'N.C. Dm7 G7 Cmaj7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Noise token with retained harmonic context.',
      ),
      _ManualCase(
        input: '[A] Cmaj7 |: Dm7 G7 :| Cmaj7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Section and repeat markers mixed with chords.',
      ),
      _ManualCase(
        input: 'C/E A7(b9) Dm7 G7/B',
        source: 'manual_functional',
        entryMode: 'raw_text',
        notes: 'Slash-heavy real-book style input.',
      ),
      _ManualCase(
        input: 'Db7(#11), Cmaj7',
        source: 'manual_extensions',
        entryMode: 'raw_text',
        notes: 'Tritone substitute spelling with comma separator.',
      ),
      _ManualCase(
        input: 'Bm7b5 E7alt | Am6 Dm9 G13',
        source: 'manual_minor',
        entryMode: 'raw_text',
        notes: 'Minor cadence colors plus extended turnaround.',
      ),
      _ManualCase(
        input: 'C | | F | G',
        source: 'manual_structure',
        entryMode: 'raw_text',
        notes: 'Explicit empty measure preservation.',
      ),
      _ManualCase(
        input: 'C7(foo) Dm7 G7 Cmaj7',
        source: 'manual_dirty_input',
        entryMode: 'raw_text',
        notes: 'Ignored modifier warning path.',
      ),
      _ManualCase(
        input: 'Dm7 G7 | ? Am',
        source: 'manual_placeholder',
        entryMode: 'raw_text',
        notes: 'Placeholder example shown in the analyzer page.',
      ),
      _ManualCase(
        input: 'Cmaj7/E | A7(b9) Dm7 | G7',
        source: 'manual_examples',
        entryMode: 'raw_text',
        notes: 'Example progression from analyzer page.',
      ),
      _ManualCase(
        input: 'Bm7b5 E7alt | Am6, Dm9 G13',
        source: 'manual_examples',
        entryMode: 'raw_text',
        notes: 'Example progression from analyzer page.',
      ),
      _ManualCase(
        input: 'Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5',
        source: 'manual_pad_syntax',
        entryMode: 'raw_text',
        notes: 'Chord-pad composable modifier showcase.',
      ),
      _ManualCase(
        input: 'C7(b9, #11)',
        source: 'manual_pad_syntax',
        entryMode: 'raw_text',
        notes: 'Chord-pad tension editing showcase.',
      ),
    ];

    for (final manualCase in manualCases) {
      _addAnalyzedRecord(
        input: manualCase.input,
        source: manualCase.source,
        entryMode: manualCase.entryMode,
        notes: manualCase.notes,
        extraMetadata: const <String, Object?>{},
      );
    }
  }

  void _collectPadRecipeCases() {
    const recipes = <_PadRecipe>[
      _PadRecipe(
        label: 'basic_major_ii_v_i',
        actions: [
          'd',
          'minor',
          'dom7',
          'space',
          'g',
          'dom7',
          'space',
          'c',
          'major',
          'dom7',
        ],
        expectedInput: 'Dm7 G7 Cmaj7',
        notes: 'Basic pad-built cadence.',
      ),
      _PadRecipe(
        label: 'placeholder_bar_example',
        actions: [
          'd',
          'minor',
          'dom7',
          'space',
          'g',
          'dom7',
          'space',
          'bar',
          'unknown',
          'space',
          'a',
          'minor',
        ],
        expectedInput: 'Dm7 G7  | ? Am',
        notes: 'Pad placeholder and bar separator.',
      ),
      _PadRecipe(
        label: 'slash_and_applied',
        actions: [
          'c',
          'major',
          'dom7',
          'slash',
          'e',
          'space',
          'a',
          'dom7',
          'openParen',
          'modifier-flat',
          'dom9',
          'closeParen',
          'space',
          'd',
          'minor',
          'dom7',
          'space',
          'g',
          'dom7',
        ],
        expectedInput: 'Cmaj7/E A7(b9) Dm7 G7',
        notes: 'Slash chord and parenthetical dominant color.',
      ),
      _PadRecipe(
        label: 'tritone_substitute',
        actions: [
          'd',
          'flat',
          'dom7',
          'openParen',
          'modifier-sharp',
          'dom11',
          'closeParen',
          'comma',
          'c',
          'major',
          'dom7',
        ],
        expectedInput: 'Db7(#11), Cmaj7',
        notes: 'Pad recipe for tritone-substitute spelling.',
      ),
      _PadRecipe(
        label: 'minor_cadence_extended',
        actions: [
          'b',
          'minor',
          'dom7',
          'modifier-flat',
          'five',
          'space',
          'e',
          'dom7',
          'alt',
          'space',
          'bar',
          'a',
          'minor',
          'six',
          'comma',
          'd',
          'minor',
          'dom9',
          'space',
          'g',
          'dom13',
        ],
        expectedInput: 'Bm7b5 E7alt  | Am6, Dm9 G13',
        notes: 'Minor cadence with bar and comma separators.',
      ),
      _PadRecipe(
        label: 'pad_syntax_showcase',
        actions: [
          'c',
          'major',
          'dom7',
          'space',
          'f',
          'add',
          'dom11',
          'space',
          'b',
          'suspension',
          'four',
          'space',
          'd',
          'minor',
          'dom7',
          'modifier-flat',
          'five',
          'space',
          'e',
          'five',
          'space',
          'g',
          'omit',
          'five',
        ],
        expectedInput: 'Cmaj7 Fadd11 Bsus4 Dm7b5 E5 Gomit5',
        notes: 'Composable quality tokens from the chord pad.',
      ),
      _PadRecipe(
        label: 'tension_editing',
        actions: [
          'c',
          'dom7',
          'openParen',
          'modifier-flat',
          'dom9',
          'comma',
          'modifier-sharp',
          'dom11',
        ],
        expectedInput: 'C7(b9, #11)',
        notes: 'Comma insertion inside the same chord token.',
      ),
      _PadRecipe(
        label: 'slash_bar_example',
        actions: [
          'c',
          'major',
          'dom7',
          'slash',
          'e',
          'space',
          'bar',
          'a',
          'dom7',
          'openParen',
          'modifier-flat',
          'dom9',
          'closeParen',
          'space',
          'd',
          'minor',
          'dom7',
          'space',
          'bar',
          'g',
          'dom7',
        ],
        expectedInput: 'Cmaj7/E  | A7(b9) Dm7  | G7',
        notes: 'Chord pad recipe matching the analyzer example.',
      ),
      _PadRecipe(
        label: 'flat_key_variant',
        actions: [
          'b',
          'flat',
          'minor',
          'dom7',
          'space',
          'e',
          'flat',
          'dom7',
          'space',
          'a',
          'flat',
          'major',
          'dom7',
        ],
        expectedInput: 'Bbm7 Eb7 Abmaj7',
        notes: 'Pad-friendly flat-key cadence variant.',
      ),
      _PadRecipe(
        label: 'common_tone_dim',
        actions: ['c', 'sharp', 'dim', 'dom7', 'space', 'c', 'major', 'dom7'],
        expectedInput: 'C#dim7 Cmaj7',
        notes: 'Common-tone diminished from the pad.',
      ),
      _PadRecipe(
        label: 'backdoor_color',
        actions: [
          'f',
          'minor',
          'dom7',
          'space',
          'b',
          'flat',
          'dom7',
          'space',
          'c',
          'major',
          'dom7',
        ],
        expectedInput: 'Fm7 Bb7 Cmaj7',
        notes: 'Backdoor cadence as a pad recipe.',
      ),
      _PadRecipe(
        label: 'deceptive_setup',
        actions: [
          'c',
          'major',
          'dom7',
          'space',
          'g',
          'dom7',
          'space',
          'a',
          'minor',
          'dom7',
          'space',
          'bar',
          'd',
          'minor',
          'dom7',
          'space',
          'g',
          'dom7',
          'space',
          'c',
          'major',
          'dom7',
        ],
        expectedInput: 'Cmaj7 G7 Am7  | Dm7 G7 Cmaj7',
        notes: 'Pad recipe with deceptive move plus barline.',
      ),
    ];

    for (final recipe in recipes) {
      final composed = _composePadActions(recipe.actions);
      if (composed != recipe.expectedInput) {
        throw StateError(
          'Pad recipe ${recipe.label} composed "$composed" '
          'but expected "${recipe.expectedInput}".',
        );
      }
      padRecipeCount += 1;
      _addAnalyzedRecord(
        input: recipe.expectedInput,
        source: 'pad_recipe',
        entryMode: 'chord_pad_recipe',
        notes: recipe.notes,
        extraMetadata: <String, Object?>{
          'padRecipeLabel': recipe.label,
          'padActions': recipe.actions,
          'padActionCount': recipe.actions.length,
        },
      );
    }
  }

  void _collectSmartGeneratorCases() {
    final scenarios = <_GeneratorScenario>[
      _GeneratorScenario(
        name: 'standards_core_baseline',
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        modulationIntensity: ModulationIntensity.medium,
        steps: 120,
        seeds: const [11, 12, 13, 14],
        harmonicRhythmPreset: HarmonicRhythmPreset.onePerBar,
      ),
      _GeneratorScenario(
        name: 'modulation_study_phrase_aware',
        activeKeys: const ['C', 'G', 'A'],
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.fakebookStandard,
        modulationIntensity: ModulationIntensity.high,
        steps: 140,
        seeds: const [21, 22, 23, 24],
        harmonicRhythmPreset: HarmonicRhythmPreset.phraseAwareJazz,
      ),
      _GeneratorScenario(
        name: 'advanced_recording',
        activeKeys: const ['C', 'D#/Eb', 'G'],
        jazzPreset: JazzPreset.advanced,
        sourceProfile: SourceProfile.recordingInspired,
        modulationIntensity: ModulationIntensity.high,
        steps: 160,
        seeds: const [31, 32, 33, 34],
        harmonicRhythmPreset: HarmonicRhythmPreset.cadenceCompression,
      ),
      _GeneratorScenario(
        name: 'single_key_safe_extensions',
        activeKeys: const ['C'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        modulationIntensity: ModulationIntensity.off,
        steps: 120,
        seeds: const [41, 42, 43, 44],
        allowTensions: true,
        chordLanguageLevel: ChordLanguageLevel.safeExtensions,
      ),
      _GeneratorScenario(
        name: 'triads_only_core',
        activeKeys: const ['C'],
        jazzPreset: JazzPreset.standardsCore,
        sourceProfile: SourceProfile.fakebookStandard,
        modulationIntensity: ModulationIntensity.off,
        steps: 120,
        seeds: const [51, 52, 53, 54],
        allowTensions: false,
        chordLanguageLevel: ChordLanguageLevel.triadsOnly,
        romanPoolPreset: RomanPoolPreset.corePrimary,
      ),
      _GeneratorScenario(
        name: 'flat_side_colors',
        activeKeys: const ['F', 'Bb', 'D#/Eb'],
        jazzPreset: JazzPreset.modulationStudy,
        sourceProfile: SourceProfile.fakebookStandard,
        modulationIntensity: ModulationIntensity.medium,
        steps: 140,
        seeds: const [61, 62, 63, 64],
      ),
    ];

    for (final scenario in scenarios) {
      for (final seed in scenario.seeds) {
        final summary = SmartGeneratorHelper.simulateSteps(
          random: Random(seed),
          steps: scenario.steps,
          request: _buildStartRequest(scenario),
        );
        _harvestGeneratorWindows(scenario, seed, summary);
        if (generatorRecordCount >= _targetGeneratorRecords &&
            records.length >= _targetTotalRecords) {
          return;
        }
      }
    }
  }

  void _collectCoverageMatrixCases() {
    const coverageCases = <_ManualCase>[
      _ManualCase(
        input: 'Em7 - A7 - ? - Bm7',
        source: 'coverage_placeholder',
        entryMode: 'feature_matrix',
        notes: 'Placeholder inference in B minor context.',
      ),
      _ManualCase(
        input: 'Gm7 - C7 - ? - Dm7',
        source: 'coverage_placeholder',
        entryMode: 'feature_matrix',
        notes: 'Placeholder inference in D minor context.',
      ),
      _ManualCase(
        input: 'Am7 D7 | ? Em7',
        source: 'coverage_placeholder',
        entryMode: 'feature_matrix',
        notes: 'Placeholder resolution across a barline.',
      ),
      _ManualCase(
        input: 'Cm7 F7 | ? Gm7',
        source: 'coverage_placeholder',
        entryMode: 'feature_matrix',
        notes: 'Placeholder resolution in minor-oriented turnaround.',
      ),
      _ManualCase(
        input: 'N.C. Bb-7 Eb7 Abmaj7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Noise token plus minus notation in flat-key cadence.',
      ),
      _ManualCase(
        input: '[B] Gmaj7 |: Am7 D7 :| Gmaj7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Section and repeat markup around a cadence.',
      ),
      _ManualCase(
        input: '[Bridge] Fmaj7 |: Gm7 C7 :| Fmaj7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Long-form section marker with repeat punctuation.',
      ),
      _ManualCase(
        input: 'Verse Cmaj7 Dm7 G7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Lead-sheet text label mixed with chords.',
      ),
      _ManualCase(
        input: 'F/X | C7',
        source: 'coverage_parse_issue',
        entryMode: 'feature_matrix',
        notes: 'Invalid slash bass retained as a grouped parse issue.',
      ),
      _ManualCase(
        input: 'Bb/Q | F7',
        source: 'coverage_parse_issue',
        entryMode: 'feature_matrix',
        notes: 'Invalid slash bass in a flat-key barline example.',
      ),
      _ManualCase(
        input: 'Cmaj7 H7 G7 Cmaj7',
        source: 'coverage_parse_issue',
        entryMode: 'feature_matrix',
        notes: 'Unknown root token between otherwise valid chords.',
      ),
      _ManualCase(
        input: 'F#dim7 Fmaj7',
        source: 'coverage_common_tone',
        entryMode: 'feature_matrix',
        notes: 'Common-tone diminished motion in F.',
      ),
      _ManualCase(
        input: 'G#dim7 Gmaj7',
        source: 'coverage_common_tone',
        entryMode: 'feature_matrix',
        notes: 'Common-tone diminished motion in G.',
      ),
      _ManualCase(
        input: 'D#dim7 Dmaj7',
        source: 'coverage_common_tone',
        entryMode: 'feature_matrix',
        notes: 'Common-tone diminished motion in D.',
      ),
      _ManualCase(
        input:
            'Gmaj7 Am7 D7 Gmaj7 | Bm7 E7 | Amaj7 Dmaj7 | E7 Amaj7 | D7 Gmaj7',
        source: 'coverage_real_modulation',
        entryMode: 'feature_matrix',
        notes: 'Two-key modulation arc from G major to A major and back.',
      ),
      _ManualCase(
        input:
            'Fmaj7 Gm7 C7 Fmaj7 | Am7 D7 | Gmaj7 Cmaj7 | D7 Gmaj7 | C7 Fmaj7',
        source: 'coverage_real_modulation',
        entryMode: 'feature_matrix',
        notes: 'Two-key modulation arc from F major to G major and back.',
      ),
      _ManualCase(
        input: 'Bbm7 Eb7 Fmaj7',
        source: 'coverage_backdoor',
        entryMode: 'feature_matrix',
        notes: 'Backdoor cadence into F major.',
      ),
      _ManualCase(
        input: 'Ebm7 Ab7 Bbmaj7',
        source: 'coverage_backdoor',
        entryMode: 'feature_matrix',
        notes: 'Backdoor cadence into Bb major.',
      ),
      _ManualCase(
        input: 'Dbm7 Gb7 Abmaj7',
        source: 'coverage_backdoor',
        entryMode: 'feature_matrix',
        notes: 'Backdoor cadence into Ab major.',
      ),
      _ManualCase(
        input: 'Fmaj7 Bbadd11 Esus4 Gm7b5 A5 Comit5',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Pad-style add, sus, power, and omit syntax in F.',
      ),
      _ManualCase(
        input: 'Gmaj7 Cadd11 F#sus4 Am7b5 B5 Domit5',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Pad-style add, sus, power, and omit syntax in G.',
      ),
      _ManualCase(
        input: 'Ebmaj7 Abadd11 Dsus4 Fm7b5 G5 Bbomit5',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Pad-style add, sus, power, and omit syntax in Eb.',
      ),
      _ManualCase(
        input: 'D13sus4 G7 Cmaj7',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Dominant 13sus4 color leading into a cadence.',
      ),
      _ManualCase(
        input: 'Bb13sus4/F Eb7 Abmaj7',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Slash-bass 13sus4 dominant in a flat-key cadence.',
      ),
      _ManualCase(
        input: 'D-7 | G7 | Cmaj7',
        source: 'coverage_minus_notation',
        entryMode: 'feature_matrix',
        notes: 'Minus notation cadence into C major with explicit bars.',
      ),
      _ManualCase(
        input: 'G-7 | C7 | Fmaj7',
        source: 'coverage_minus_notation',
        entryMode: 'feature_matrix',
        notes: 'Minus notation cadence into F major with explicit bars.',
      ),
      _ManualCase(
        input: 'C-7 | F7 | Bbmaj7',
        source: 'coverage_minus_notation',
        entryMode: 'feature_matrix',
        notes: 'Minus notation cadence into Bb major with explicit bars.',
      ),
      _ManualCase(
        input: 'G/B E7(b9) Am7 D7/F#',
        source: 'coverage_slash_turnaround',
        entryMode: 'feature_matrix',
        notes: 'Slash-bass turnaround in G major.',
      ),
      _ManualCase(
        input: 'F/A D7(b9) Gm7 C7/E',
        source: 'coverage_slash_turnaround',
        entryMode: 'feature_matrix',
        notes: 'Slash-bass turnaround in F major.',
      ),
      _ManualCase(
        input: 'Bb/D G7(b9) Cm7 F7/A',
        source: 'coverage_slash_turnaround',
        entryMode: 'feature_matrix',
        notes: 'Slash-bass turnaround in Bb major.',
      ),
      _ManualCase(
        input: 'G | | C | D',
        source: 'coverage_structure',
        entryMode: 'feature_matrix',
        notes: 'Explicit empty bar preservation in G.',
      ),
      _ManualCase(
        input: 'F | | Bb | C',
        source: 'coverage_structure',
        entryMode: 'feature_matrix',
        notes: 'Explicit empty bar preservation in F.',
      ),
      _ManualCase(
        input: '[Tag] Cmaj7 | Dm7 G7 | Cmaj7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Short markup tag with bar-separated cadence.',
      ),
      _ManualCase(
        input: '[A] Fmaj7 |: Gm7 C7 :| Fmaj7',
        source: 'coverage_dirty_input',
        entryMode: 'feature_matrix',
        notes: 'Canonical repeat-marker markup that should count as dirty input.',
      ),
      _ManualCase(
        input: 'Amaj7 | Dadd11 G#sus4 | Bm7b5 C#5 Eomit5',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Bar-separated pad syntax bundle covering add and omit tokens.',
      ),
      _ManualCase(
        input: 'Cmaj Dm7 G7 Cmaj',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Bare maj token parsing without explicit seventh.',
      ),
      _ManualCase(
        input: 'Fmaj Gm7 C7 Fmaj',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Bare maj token parsing in another key center.',
      ),
      _ManualCase(
        input: 'E5 B5 Cmaj7 Am7',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Power-chord style omit-third tokens before tonal context.',
      ),
      _ManualCase(
        input: 'A5 E5 F#m7 Dmaj7',
        source: 'coverage_pad_syntax',
        entryMode: 'feature_matrix',
        notes: 'Power-chord tokens followed by diatonic major resolution.',
      ),
    ];

    for (final coverageCase in coverageCases) {
      _addAnalyzedRecord(
        input: coverageCase.input,
        source: coverageCase.source,
        entryMode: coverageCase.entryMode,
        notes: coverageCase.notes,
        extraMetadata: const <String, Object?>{},
      );
    }
  }

  void _collectFormattingVariants() {
    const variants = <_ManualCase>[
      _ManualCase(
        input: 'Dm7, G7 | Cmaj7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Same cadence with comma and bar separators.',
      ),
      _ManualCase(
        input: 'Dm7 | G7 | Cmaj7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Same cadence split across three measures.',
      ),
      _ManualCase(
        input: 'Cmaj7 | A7 | Dm7, G7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Mixed bar and comma formatting for a turnaround.',
      ),
      _ManualCase(
        input: 'C7(#11) Fmaj7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Lydian dominant color without extra comma spacing.',
      ),
      _ManualCase(
        input: 'Db7(#11) Cmaj7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Tritone substitute without comma separator.',
      ),
      _ManualCase(
        input: 'Dm7 G7 ? Am7',
        source: 'manual_format_variant',
        entryMode: 'raw_text',
        notes: 'Placeholder variant without dash connectors.',
      ),
    ];

    for (final variant in variants) {
      _addAnalyzedRecord(
        input: variant.input,
        source: variant.source,
        entryMode: variant.entryMode,
        notes: variant.notes,
        extraMetadata: const <String, Object?>{},
      );
    }
  }

  void _harvestGeneratorWindows(
    _GeneratorScenario scenario,
    int seed,
    SmartSimulationSummary summary,
  ) {
    final traces = [
      for (final trace in summary.traces)
        if ((trace.finalChord ?? '').trim().isNotEmpty) trace,
    ];
    if (traces.length < 3) {
      return;
    }

    const windowLengths = <int>[3, 4, 5, 6, 8];
    const formatStyles = <String>['spaces', 'bars2', 'mixed', 'bars4'];

    for (final windowLength in windowLengths) {
      final stride = windowLength <= 4 ? 2 : 3;
      for (
        var start = 0;
        start + windowLength <= traces.length;
        start += stride
      ) {
        final slice = traces.sublist(start, start + windowLength);
        if (_isLowInformationWindow(slice)) {
          continue;
        }

        for (final style in formatStyles) {
          if (style == 'bars4' && windowLength < 6) {
            continue;
          }
          final input = _formatTraceWindow(slice, style);
          final candidateSignature = _signatureFromInput(input);
          if (!_generatorContentSignatures.add(candidateSignature)) {
            continue;
          }

          final traceFlags = _traceFlags(slice);
          _addAnalyzedRecord(
            input: input,
            source: 'smart_generator',
            entryMode: 'generator_trace_window',
            notes:
                'Generated from ${scenario.name} '
                '(seed $seed, length $windowLength, style $style).',
            extraMetadata: <String, Object?>{
              'generatorScenario': scenario.name,
              'generatorSeed': seed,
              'generatorWindowLength': windowLength,
              'generatorWindowStyle': style,
              'generatorTraceRange': <int>[
                slice.first.stepIndex,
                slice.last.stepIndex,
              ],
              'generatorPreset': scenario.jazzPreset.name,
              'generatorSourceProfile': scenario.sourceProfile.name,
              'generatorModulationIntensity': scenario.modulationIntensity.name,
              'generatorActiveKeys': scenario.activeKeys,
              'generatorTraceFlags': traceFlags,
              'generatorSummarySnapshot': <String, Object?>{
                'tonicizationCount': summary.tonicizationCount,
                'realModulationCount': summary.realModulationCount,
                'fallbackCount': summary.fallbackCount,
                'susReleaseCount': summary.susReleaseCount,
                'modulationSuccessCount': summary.modulationSuccessCount,
              },
            },
          );
          generatorRecordCount += 1;

          if (generatorRecordCount >= _targetGeneratorRecords &&
              records.length >= _targetTotalRecords) {
            return;
          }
        }
      }
    }
  }

  bool _isLowInformationWindow(List<SmartDecisionTrace> slice) {
    final uniqueChords = {
      for (final trace in slice)
        if (trace.finalChord != null) trace.finalChord!,
    };
    if (uniqueChords.length <= 1) {
      return true;
    }
    final uniqueRomans = {
      for (final trace in slice)
        if (trace.finalRomanNumeralId != null) trace.finalRomanNumeralId!.name,
    };
    return uniqueRomans.length <= 1;
  }

  void _addAnalyzedRecord({
    required String input,
    required String source,
    required String entryMode,
    required String notes,
    required Map<String, Object?> extraMetadata,
  }) {
    final normalizedInput = _normalizeWhitespace(input);
    final recordKey = '$entryMode|$source|$normalizedInput';
    if (!_recordKeys.add(recordKey)) {
      return;
    }

    final parseResult = _parser.parse(input);
    final baseRecord = <String, Object?>{
      'id': 'case_${_nextId.toString().padLeft(4, '0')}',
      'input': input,
      'inputNormalized': normalizedInput,
      'inputSignature': _inputSignature(input),
      'source': source,
      'entryMode': entryMode,
      'notes': notes,
      'features': _inputFeatureFlags(input, parseResult),
      'parsePreview': _serializeParseResult(parseResult),
      ...extraMetadata,
    };
    _nextId += 1;

    try {
      final analysis = _analyzer.analyze(input);
      final variations = _variationGenerator.generate(analysis);
      records.add({
        ...baseRecord,
        'resultStatus': 'analysis',
        'harmonicSignature': _harmonicSignature(analysis),
        'userFacingOutput': _serializeAnalysis(analysis, variations),
      });
    } on ProgressionAnalysisException catch (error) {
      records.add({
        ...baseRecord,
        'resultStatus': 'error',
        'harmonicSignature': _parseSignature(parseResult),
        'userFacingOutput': <String, Object?>{
          'errorKey': error.message,
          'hasWarnings': parseResult.issues.isNotEmpty,
          'parseIssueCount': parseResult.issues.length,
        },
      });
    }
  }

  SmartStartRequest _buildStartRequest(_GeneratorScenario scenario) {
    return SmartStartRequest(
      activeKeys: scenario.activeKeys,
      selectedKeyCenters: [
        for (final key in scenario.activeKeys) MusicTheory.keyCenterFor(key),
      ],
      secondaryDominantEnabled: true,
      substituteDominantEnabled: true,
      modalInterchangeEnabled: true,
      modulationIntensity: scenario.modulationIntensity,
      jazzPreset: scenario.jazzPreset,
      sourceProfile: scenario.sourceProfile,
      allowV7sus4: true,
      allowTensions: scenario.allowTensions,
      chordLanguageLevel: scenario.chordLanguageLevel,
      romanPoolPreset: scenario.romanPoolPreset,
      harmonicRhythmPreset: scenario.harmonicRhythmPreset,
      timeSignature: PracticeTimeSignature.fourFour,
      smartDiagnosticsEnabled: true,
    );
  }

  String _formatTraceWindow(List<SmartDecisionTrace> slice, String style) {
    final chords = [for (final trace in slice) trace.finalChord!];
    return switch (style) {
      'spaces' => chords.join(' '),
      'bars2' => _grouped(chords, 2, separator: ' | ', intraGroup: ' '),
      'mixed' => _grouped(chords, 2, separator: ' | ', intraGroup: ', '),
      'bars4' => _grouped(chords, 4, separator: ' | ', intraGroup: ' '),
      _ => chords.join(' '),
    };
  }

  Map<String, Object?> _serializeParseResult(ProgressionParseResult result) {
    return <String, Object?>{
      'validChordCount': result.validChords.length,
      'placeholderCount': result.placeholders.length,
      'noChordCount': result.noChords.length,
      'ignoredTokenCount': result.ignoredTokens.length,
      'issueCount': result.issues.length,
      'hasPartialFailure': result.hasPartialFailure,
      'hasPlaceholders': result.hasPlaceholders,
      'tokenTexts': [for (final token in result.tokens) token.rawText],
      'issues': [
        for (final issue in result.issues)
          <String, Object?>{
            'rawText': issue.rawText,
            'measureIndex': issue.measureIndex,
            'positionInMeasure': issue.positionInMeasure,
            'error': issue.error,
            'errorDetail': issue.errorDetail,
          },
      ],
    };
  }

  Map<String, Object?> _serializeAnalysis(
    ProgressionAnalysis analysis,
    List<ProgressionVariation> variations,
  ) {
    return <String, Object?>{
      'primaryKey': analysis.primaryKey.keyCenter.tonicName,
      'primaryKeyDisplay': analysis.primaryKeyDisplay,
      'homeKeyDisplay': analysis.homeKeyDisplay,
      'primaryMode': analysis.primaryKey.keyCenter.mode.name,
      'primaryKeyScore': analysis.primaryKey.score,
      'primaryKeyConfidence': analysis.primaryKeyConfidence,
      'globalAggregateKey': analysis.globalAggregateKey.keyCenter.tonicName,
      'globalAggregateKeyDisplay': analysis.globalAggregateKeyDisplay,
      'globalAggregateKeyConfidence': analysis.globalAggregateKeyConfidence,
      'alternativeKey': analysis.alternativeKey?.keyCenter.tonicName,
      'alternativeKeyDisplay': analysis.alternativeKey?.keyCenter.displayName,
      'alternativeKeyScore': analysis.alternativeKey?.score,
      'alternativeKeyConfidence': analysis.alternativeKey?.confidence,
      'finalSelectionConfidence': analysis.finalSelectionConfidence,
      'keyConfidence': analysis.keyConfidence,
      'analysisReliability': analysis.analysisReliability,
      'confidence': analysis.confidence,
      'ambiguity': analysis.ambiguity,
      'diagnosticStatus': analysis.diagnosticStatus.wireName,
      'warningCodes': [for (final code in analysis.warningCodes) code.wireName],
      'selectionReason': analysis.selectionReason.wireName,
      'hasWarnings': analysis.hasWarnings,
      'hasRealModulation': analysis.hasRealModulation,
      'hasTonicization': analysis.hasTonicization,
      'inferredChordCount': analysis.inferredChordCount,
      'ambiguousChordCount': analysis.ambiguousChordCount,
      'unresolvedChordCount': analysis.unresolvedChordCount,
      'tagNames': [for (final tag in analysis.tags) tag.name],
      'highlightCategories': [
        for (final category in analysis.highlightCategories) category.name,
      ],
      'keyCandidates': [
        for (final candidate in analysis.keyCandidates)
          <String, Object?>{
            'keyDisplay': candidate.keyCenter.displayName,
            'tonic': candidate.keyCenter.tonicName,
            'mode': candidate.keyCenter.mode.name,
            'score': candidate.score,
            'confidence': candidate.confidence,
          },
      ],
      'analysisSegments': [
        for (final segment in analysis.analysisSegments)
          <String, Object?>{
            'segmentIndex': segment.segmentIndex,
            'startMeasureIndex': segment.startMeasureIndex,
            'endMeasureIndex': segment.endMeasureIndex,
            'keyDisplay': segment.keyDisplay,
            'tonic': segment.tonic,
            'mode': segment.mode,
            'reason': segment.reason,
          },
      ],
      'groupedMeasures': [
        for (final measure in analysis.groupedMeasures)
          <String, Object?>{
            'measureIndex': measure.measureIndex,
            'isEmpty': measure.isEmpty,
            'tokenTexts': [for (final token in measure.tokens) token.rawText],
            'parseIssues': [
              for (final issue in measure.parseIssues)
                <String, Object?>{
                  'rawText': issue.rawText,
                  'error': issue.error,
                  'errorDetail': issue.errorDetail,
                },
            ],
            'chords': [
              for (final chord in measure.chordAnalyses)
                <String, Object?>{
                  'sourceSymbol': chord.chord.sourceSymbol,
                  'resolvedSymbol': chord.resolvedSymbol,
                  'romanNumeral': chord.romanNumeral,
                  'function': chord.harmonicFunction.name,
                  'segmentIndex': chord.segmentIndex,
                  'segmentKeyDisplay': chord.segmentKeyDisplay,
                },
            ],
          },
      ],
      'chordAnalyses': [
        for (final chord in analysis.chordAnalyses)
          _serializeChordAnalysis(chord),
      ],
      'suggestedFills': [
        for (final chord in analysis.chordAnalyses)
          if (chord.isInferred)
            <String, Object?>{
              'placeholderSymbol': chord.chord.sourceSymbol,
              'resolvedSymbol': chord.resolvedSymbol,
              'romanNumeral': chord.romanNumeral,
              'rankedSuggestions': [
                for (final suggestion in chord.suggestedFills)
                  <String, Object?>{
                    'resolvedSymbol': suggestion.resolvedSymbol,
                    'romanNumeral': suggestion.romanNumeral,
                    'function': suggestion.harmonicFunction.name,
                    'score': suggestion.score,
                    'confidence': suggestion.confidence,
                    'rationale': suggestion.rationale,
                    'sourceReason': suggestion.sourceReason,
                    'sourceKind': suggestion.sourceKind?.name,
                  },
              ],
            },
      ],
      'variationSuggestions': [
        for (final variation in variations)
          <String, Object?>{
            'kind': variation.kind.name,
            'progression': variation.progression,
            'changeCount': variation.changeCount,
          },
      ],
    };
  }

  Map<String, Object?> _serializeChordAnalysis(AnalyzedChord chord) {
    return <String, Object?>{
      'sourceSymbol': chord.chord.sourceSymbol,
      'canonicalSymbol': chord.chord.canonicalSymbol,
      'resolvedSymbol': chord.resolvedSymbol,
      'root': chord.chord.root,
      'quality': chord.chord.displayQuality.name,
      'analysisFamily': chord.chord.analysisFamily.name,
      'romanNumeral': chord.romanNumeral,
      'primaryDisplayLabel': chord.primaryDisplayLabel,
      'displayAlias': chord.displayAlias,
      'function': chord.harmonicFunction.name,
      'sourceKind': chord.sourceKind?.name,
      'segmentIndex': chord.segmentIndex,
      'segmentKeyDisplay': chord.segmentKeyDisplay,
      'score': chord.score,
      'confidence': chord.confidence,
      'isAmbiguous': chord.isAmbiguous,
      'isInferred': chord.isInferred,
      'hasSlashBass': chord.chord.hasSlashBass,
      'slashBass': chord.chord.bass,
      'tensions': chord.chord.tensions,
      'addedTones': chord.chord.addedTones,
      'omittedTones': chord.chord.omittedTones,
      'alterations': chord.chord.alterations,
      'suspensions': chord.chord.suspensions,
      'ignoredTokens': chord.chord.ignoredTokens,
      'diagnostics': chord.chord.diagnostics,
      'remarks': [
        for (final remark in chord.remarks)
          <String, Object?>{
            'kind': remark.kind.name,
            'targetRomanNumeral': remark.targetRomanNumeral,
            'targetKeyCenter': remark.targetKeyCenter?.displayName,
            'detail': remark.detail,
          },
      ],
      'evidence': [
        for (final evidence in chord.evidence)
          <String, Object?>{
            'kind': evidence.kind.name,
            'detail': evidence.detail,
          },
      ],
      'highlightCategories': [
        for (final category in chord.highlightCategories) category.name,
      ],
      'competingInterpretations': [
        for (final candidate in chord.competingInterpretations.take(3))
          <String, Object?>{
            'romanNumeral': candidate.romanNumeral,
            'primaryDisplayLabel': candidate.primaryDisplayLabel,
            'displayAlias': candidate.displayAlias,
            'function': candidate.harmonicFunction.name,
            'score': candidate.score,
            'chordSymbol': candidate.chordSymbol,
            'sourceKind': candidate.sourceKind?.name,
            'sourceReason': candidate.sourceReason,
          },
      ],
      'suggestedFills': [
        for (final suggestion in chord.suggestedFills)
          <String, Object?>{
            'resolvedSymbol': suggestion.resolvedSymbol,
            'romanNumeral': suggestion.romanNumeral,
            'function': suggestion.harmonicFunction.name,
            'score': suggestion.score,
            'confidence': suggestion.confidence,
            'rationale': suggestion.rationale,
            'sourceReason': suggestion.sourceReason,
            'sourceKind': suggestion.sourceKind?.name,
          },
      ],
    };
  }

  List<String> _inputFeatureFlags(
    String input,
    ProgressionParseResult parseResult,
  ) {
    final features = <String>{};
    if (input.contains('|')) features.add('measure_bars');
    if (input.contains(',')) features.add('comma_separator');
    if (input.contains('?')) features.add('placeholder_token');
    if (input.contains('/')) features.add('slash_chord');
    if (input.contains('(') || input.contains(')')) {
      features.add('parenthetical_modifiers');
    }
    if (RegExp(r'\b[A-Ga-g][#b]?-').hasMatch(input)) {
      features.add('minus_notation');
    }
    if (RegExp(r'\b[a-g]').hasMatch(input)) features.add('lowercase_roots');
    if (input.contains('add')) features.add('add_tone');
    if (input.contains('omit')) features.add('omit_tone');
    if (input.contains('sus')) features.add('suspension');
    if (input.contains('alt')) features.add('altered_dominant_token');
    if (input.contains('dim')) features.add('diminished_quality');
    if (input.contains('aug')) features.add('augmented_quality');
    if (RegExp(r'\s-\s').hasMatch(input)) features.add('dash_connectors');
    if (input.contains('N.C.') ||
        input.contains('[A]') ||
        input.contains(':|') ||
        input.contains('|:')) {
      features.add('dirty_markup');
    }
    if (parseResult.issues.isNotEmpty) features.add('parse_issue_present');
    if (parseResult.hasPlaceholders) features.add('placeholder_supported');
    return features.toList()..sort();
  }

  String _harmonicSignature(ProgressionAnalysis analysis) => [
    for (final chord in analysis.chordAnalyses) chord.resolvedSymbol,
  ].join(' | ');

  String _parseSignature(ProgressionParseResult result) => [
    for (final chord in result.validChords) chord.canonicalSymbol,
    for (final _ in result.placeholders) '?',
  ].join(' | ');

  String _signatureFromInput(String input) {
    final result = _parser.parse(input);
    final signature = _parseSignature(result);
    return signature.trim().isNotEmpty ? signature : _inputSignature(input);
  }

  String _inputSignature(String input) =>
      _normalizeWhitespace(input).toLowerCase();

  Map<String, Object?> _buildSummary() {
    final countsByStatus = <String, int>{};
    final countsByEntryMode = <String, int>{};
    final countsBySource = <String, int>{};
    final featureCounts = <String, int>{};
    final tagCounts = <String, int>{};
    final highlightCounts = <String, int>{};
    final primaryKeyCounts = <String, int>{};

    var warningCount = 0;
    var placeholderCount = 0;
    var variationCount = 0;
    var alternativeKeyCount = 0;
    var realModulationCount = 0;

    for (final record in records) {
      final status = (record['resultStatus'] as String?) ?? 'unknown';
      countsByStatus.update(status, (value) => value + 1, ifAbsent: () => 1);

      final entryMode = (record['entryMode'] as String?) ?? 'unknown';
      countsByEntryMode.update(
        entryMode,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      final source = (record['source'] as String?) ?? 'unknown';
      countsBySource.update(source, (value) => value + 1, ifAbsent: () => 1);

      final features = (record['features'] as List?) ?? const [];
      for (final feature in features.whereType<String>()) {
        featureCounts.update(feature, (value) => value + 1, ifAbsent: () => 1);
      }

      final output = record['userFacingOutput'] as Map<String, Object?>?;
      if (output == null) continue;
      if ((output['hasWarnings'] as bool?) ?? false) warningCount += 1;
      if (((output['suggestedFills'] as List?)?.isNotEmpty ?? false)) {
        placeholderCount += 1;
      }
      if (((output['variationSuggestions'] as List?)?.isNotEmpty ?? false)) {
        variationCount += 1;
      }
      if ((output['alternativeKeyDisplay'] as String?) != null) {
        alternativeKeyCount += 1;
      }
      if ((output['hasRealModulation'] as bool?) ?? false) {
        realModulationCount += 1;
      }

      final keyDisplay = output['primaryKeyDisplay'] as String?;
      if (keyDisplay != null && keyDisplay.isNotEmpty) {
        primaryKeyCounts.update(
          keyDisplay,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      for (final tag
          in (output['tagNames'] as List?)?.whereType<String>() ??
              const <String>[]) {
        tagCounts.update(tag, (value) => value + 1, ifAbsent: () => 1);
      }
      for (final category
          in (output['highlightCategories'] as List?)?.whereType<String>() ??
              const <String>[]) {
        highlightCounts.update(
          category,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    final focusCoverageCounts = <String, int>{
      'placeholderCases': featureCounts['placeholder_supported'] ?? 0,
      'parseIssueCases': featureCounts['parse_issue_present'] ?? 0,
      'dirtyMarkupCases': featureCounts['dirty_markup'] ?? 0,
      'addToneCases': featureCounts['add_tone'] ?? 0,
      'omitToneCases': featureCounts['omit_tone'] ?? 0,
      'measureBarCases': featureCounts['measure_bars'] ?? 0,
      'minusNotationCases': featureCounts['minus_notation'] ?? 0,
      'backdoorTagCases': tagCounts['backdoorChain'] ?? 0,
      'realModulationTagCases': tagCounts['realModulation'] ?? 0,
      'commonToneTagCases': tagCounts['commonToneMotion'] ?? 0,
    };
    final coverageChecks = <String, Object?>{
      'placeholderCasesAtLeast8':
          focusCoverageCounts['placeholderCases']! >= 8,
      'parseIssueCasesAtLeast8': focusCoverageCounts['parseIssueCases']! >= 8,
      'dirtyMarkupCasesAtLeast6': focusCoverageCounts['dirtyMarkupCases']! >= 6,
      'addToneCasesAtLeast6': focusCoverageCounts['addToneCases']! >= 6,
      'omitToneCasesAtLeast6': focusCoverageCounts['omitToneCases']! >= 6,
      'measureBarCasesAtLeast30': focusCoverageCounts['measureBarCases']! >= 30,
      'minusNotationCasesAtLeast4':
          focusCoverageCounts['minusNotationCases']! >= 4,
      'backdoorTagCasesAtLeast12':
          focusCoverageCounts['backdoorTagCases']! >= 12,
      'realModulationTagCasesAtLeast6':
          focusCoverageCounts['realModulationTagCases']! >= 6,
      'commonToneTagCasesAtLeast4':
          focusCoverageCounts['commonToneTagCases']! >= 4,
    };

    return <String, Object?>{
      'generatedAtUtc': DateTime.now().toUtc().toIso8601String(),
      'outputDirectory': outputDir.path,
      'recordCount': records.length,
      'generatorRecordCount': generatorRecordCount,
      'padRecipeCount': padRecipeCount,
      'targets': <String, Object?>{
        'targetTotalRecords': _targetTotalRecords,
        'targetGeneratorRecords': _targetGeneratorRecords,
      },
      'volumeChecks': <String, Object?>{
        'targetTotalReached': records.length >= _targetTotalRecords,
        'targetGeneratorReached':
            generatorRecordCount >= _targetGeneratorRecords,
      },
      'countsByStatus': _sortedMap(countsByStatus),
      'countsByEntryMode': _sortedMap(countsByEntryMode),
      'countsBySource': _sortedMap(countsBySource),
      'topInputFeatures': _sortedMap(featureCounts),
      'topTags': _sortedMap(tagCounts),
      'topHighlightCategories': _sortedMap(highlightCounts),
      'topPrimaryKeys': _sortedMap(primaryKeyCounts),
      'focusCoverageCounts': focusCoverageCounts,
      'coverageChecks': coverageChecks,
      'recordsWithWarnings': warningCount,
      'recordsWithSuggestedFills': placeholderCount,
      'recordsWithVariations': variationCount,
      'recordsWithAlternativeKey': alternativeKeyCount,
      'recordsWithRealModulation': realModulationCount,
      'sampleRecordIds': [for (final record in records.take(12)) record['id']],
    };
  }

  String _summaryMarkdown(Map<String, Object?> summary) {
    final buffer = StringBuffer()
      ..writeln('# Chord Analyzer Simulation Summary')
      ..writeln()
      ..writeln('- Record count: ${summary['recordCount']}')
      ..writeln('- Generator record count: ${summary['generatorRecordCount']}')
      ..writeln('- Pad recipe count: ${summary['padRecipeCount']}')
      ..writeln(
        '- Total target reached: '
        '${(summary['volumeChecks'] as Map<String, Object?>)['targetTotalReached']}',
      )
      ..writeln(
        '- Generator target reached: '
        '${(summary['volumeChecks'] as Map<String, Object?>)['targetGeneratorReached']}',
      )
      ..writeln()
      ..writeln('## Coverage Checks')
      ..writeln();

    for (final entry
        in (summary['coverageChecks'] as Map<String, Object?>).entries) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }

    buffer
      ..writeln()
      ..writeln('## Focus Coverage Counts')
      ..writeln();
    for (final entry
        in (summary['focusCoverageCounts'] as Map<String, Object?>).entries) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }

    buffer
      ..writeln()
      ..writeln('## Counts By Entry Mode')
      ..writeln();

    for (final entry
        in (summary['countsByEntryMode'] as Map<String, Object?>).entries) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }

    buffer
      ..writeln()
      ..writeln('## Top Input Features')
      ..writeln();
    for (final entry
        in (summary['topInputFeatures'] as Map<String, Object?>).entries.take(
          12,
        )) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }

    buffer
      ..writeln()
      ..writeln('## Top Tags')
      ..writeln();
    for (final entry
        in (summary['topTags'] as Map<String, Object?>).entries.take(12)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }

    buffer
      ..writeln()
      ..writeln('## Files')
      ..writeln()
      ..writeln('- records.json')
      ..writeln('- records.jsonl')
      ..writeln('- records.csv')
      ..writeln('- summary.json');

    return buffer.toString();
  }

  String _toCsv(List<Map<String, Object?>> rows) {
    const headers = <String>[
      'id',
      'source',
      'entryMode',
      'resultStatus',
      'input',
      'harmonicSignature',
      'primaryKeyDisplay',
      'primaryMode',
      'alternativeKeyDisplay',
      'confidence',
      'ambiguity',
      'hasWarnings',
      'inferredChordCount',
      'ambiguousChordCount',
      'unresolvedChordCount',
      'tags',
      'highlightCategories',
      'features',
      'variationCount',
      'errorKey',
    ];

    final buffer = StringBuffer()..writeln(headers.join(','));
    for (final row in rows) {
      final output = row['userFacingOutput'] as Map<String, Object?>?;
      final fields = <String>[
        row['id']?.toString() ?? '',
        row['source']?.toString() ?? '',
        row['entryMode']?.toString() ?? '',
        row['resultStatus']?.toString() ?? '',
        row['input']?.toString() ?? '',
        row['harmonicSignature']?.toString() ?? '',
        output?['primaryKeyDisplay']?.toString() ?? '',
        output?['primaryMode']?.toString() ?? '',
        output?['alternativeKeyDisplay']?.toString() ?? '',
        output?['confidence']?.toString() ?? '',
        output?['ambiguity']?.toString() ?? '',
        output?['hasWarnings']?.toString() ?? '',
        output?['inferredChordCount']?.toString() ?? '',
        output?['ambiguousChordCount']?.toString() ?? '',
        output?['unresolvedChordCount']?.toString() ?? '',
        jsonEncode(output?['tagNames'] ?? const []),
        jsonEncode(output?['highlightCategories'] ?? const []),
        jsonEncode(row['features'] ?? const []),
        ((output?['variationSuggestions'] as List?)?.length ?? 0).toString(),
        output?['errorKey']?.toString() ?? '',
      ];
      buffer.writeln(fields.map(_csvCell).join(','));
    }
    return buffer.toString();
  }
}

class _ManualCase {
  const _ManualCase({
    required this.input,
    required this.source,
    required this.entryMode,
    required this.notes,
  });

  final String input;
  final String source;
  final String entryMode;
  final String notes;
}

class _PadRecipe {
  const _PadRecipe({
    required this.label,
    required this.actions,
    required this.expectedInput,
    required this.notes,
  });

  final String label;
  final List<String> actions;
  final String expectedInput;
  final String notes;
}

class _GeneratorScenario {
  const _GeneratorScenario({
    required this.name,
    required this.activeKeys,
    required this.jazzPreset,
    required this.sourceProfile,
    required this.modulationIntensity,
    required this.steps,
    required this.seeds,
    this.allowTensions = true,
    this.chordLanguageLevel = ChordLanguageLevel.fullExtensions,
    this.romanPoolPreset = RomanPoolPreset.expandedColor,
    this.harmonicRhythmPreset = HarmonicRhythmPreset.onePerBar,
  });

  final String name;
  final List<String> activeKeys;
  final JazzPreset jazzPreset;
  final SourceProfile sourceProfile;
  final ModulationIntensity modulationIntensity;
  final int steps;
  final List<int> seeds;
  final bool allowTensions;
  final ChordLanguageLevel chordLanguageLevel;
  final RomanPoolPreset romanPoolPreset;
  final HarmonicRhythmPreset harmonicRhythmPreset;
}

String _composePadActions(List<String> actions) {
  const mapping = <String, String>{
    'a': 'A',
    'b': 'B',
    'c': 'C',
    'd': 'D',
    'e': 'E',
    'f': 'F',
    'g': 'G',
    'sharp': '#',
    'flat': 'b',
    'slash': '/',
    'minor': 'm',
    'major': 'maj',
    'suspension': 'sus',
    'add': 'add',
    'omit': 'omit',
    'dim': 'dim',
    'aug': 'aug',
    'alt': 'alt',
    'modifier-flat': 'b',
    'modifier-sharp': '#',
    'two': '2',
    'four': '4',
    'five': '5',
    'six': '6',
    'dom7': '7',
    'dom9': '9',
    'dom11': '11',
    'dom13': '13',
    'unknown': '?',
    'comma': ', ',
    'space': ' ',
    'bar': ' | ',
  };

  var text = '';
  var cursor = 0;

  void insert(String value, {int? nextCursor}) {
    text = text.replaceRange(cursor, cursor, value);
    cursor = nextCursor ?? (cursor + value.length);
  }

  for (final action in actions) {
    switch (action) {
      case 'openParen':
        insert('()', nextCursor: cursor + 1);
      case 'closeParen':
        if (cursor < text.length && text[cursor] == ')') {
          cursor += 1;
        } else {
          insert(')');
        }
      default:
        final value = mapping[action];
        if (value == null) {
          throw StateError('Unsupported pad action: $action');
        }
        insert(value);
    }
  }
  return text;
}

String _grouped(
  List<String> items,
  int groupSize, {
  required String separator,
  required String intraGroup,
}) {
  final groups = <String>[];
  for (var index = 0; index < items.length; index += groupSize) {
    final end = min(items.length, index + groupSize);
    groups.add(items.sublist(index, end).join(intraGroup));
  }
  return groups.join(separator);
}

List<String> _traceFlags(List<SmartDecisionTrace> slice) {
  final flags = <String>{};
  if (slice.any((trace) => trace.modulationKind == ModulationKind.real)) {
    flags.add('real_modulation_trace');
  }
  if (slice.any((trace) => trace.fallbackOccurred)) flags.add('fallback_used');
  if (slice.any((trace) => trace.finalRenderedNonDiatonic)) {
    flags.add('rendered_non_diatonic');
  }
  if (slice.any((trace) => trace.surfaceTags.isNotEmpty)) {
    flags.add('surface_tags_present');
  }
  if (slice.any((trace) => trace.finalTensions.isNotEmpty)) {
    flags.add('tension_present');
  }
  return flags.toList()..sort();
}

String _normalizeWhitespace(String value) =>
    value.replaceAll(RegExp(r'\s+'), ' ').trim();

Map<String, Object?> _sortedMap(Map<String, int> source) {
  final entries = source.entries.toList()
    ..sort((left, right) {
      final countCompare = right.value.compareTo(left.value);
      return countCompare != 0 ? countCompare : left.key.compareTo(right.key);
    });
  return <String, Object?>{for (final entry in entries) entry.key: entry.value};
}

String _csvCell(String value) => '"${value.replaceAll('"', '""')}"';

String _join(String left, String right) =>
    '$left${Platform.pathSeparator}$right';
