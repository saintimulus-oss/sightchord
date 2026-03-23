import 'dart:convert';
import 'dart:io';

const String _defaultRoot = 'build/smart_stats';
const String _defaultOutputName =
    'smart_generator_rounds_01_08_analysis_bundle.jsonl';

Future<void> main(List<String> args) async {
  final parsed = _Args.parse(args);
  final root = Directory(parsed.root);
  if (!root.existsSync()) {
    throw StateError('Stats root not found: ${root.path}');
  }

  final roundDirs =
      root
          .listSync()
          .whereType<Directory>()
          .where((dir) => _roundDirPattern.hasMatch(_basename(dir.path)))
          .toList(growable: false)
        ..sort((left, right) => left.path.compareTo(right.path));

  if (roundDirs.isEmpty) {
    throw StateError('No round directories found under ${root.path}');
  }

  final roundRecords = <_RoundRecord>[];
  var totalCells = 0;
  var totalSteps = 0;

  for (final dir in roundDirs) {
    final manifestFile = File(
      '${dir.path}${Platform.pathSeparator}manifest.json',
    );
    final summaryFile = File(
      '${dir.path}${Platform.pathSeparator}summary.json',
    );
    final cellsFile = File('${dir.path}${Platform.pathSeparator}cells.jsonl');

    if (!manifestFile.existsSync() ||
        !summaryFile.existsSync() ||
        !cellsFile.existsSync()) {
      throw StateError('Incomplete round directory: ${dir.path}');
    }

    final manifest =
        jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
    final summary =
        jsonDecode(await summaryFile.readAsString()) as Map<String, dynamic>;
    final cellLineCount = await _countLines(cellsFile);
    final round = (summary['round'] as num).toInt();

    totalCells += (summary['cellCount'] as num).toInt();
    totalSteps += (summary['totalSteps'] as num).toInt();

    roundRecords.add(
      _RoundRecord(
        round: round,
        roundDirName: _basename(dir.path),
        manifest: manifest,
        summary: summary,
        cellLineCount: cellLineCount,
        cellsFile: cellsFile,
      ),
    );
  }

  final outputPath =
      parsed.outputPath ??
      '${root.path}${Platform.pathSeparator}$_defaultOutputName';
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  if (outputFile.existsSync()) {
    outputFile.deleteSync();
  }

  final manifestRecord = <String, Object?>{
    'recordType': 'dataset_manifest',
    'datasetName': 'chordest_smart_generator_rounds_01_08_analysis_bundle',
    'generatedAtUtc': DateTime.now().toUtc().toIso8601String(),
    'format': 'jsonl',
    'description':
        'Self-describing Smart Generator analysis bundle with one dataset manifest record, one round_summary record per round, and one cell record per collected setting cell.',
    'roundsIncluded': [for (final record in roundRecords) record.round],
    'roundCount': roundRecords.length,
    'totalCellRecords': totalCells,
    'totalSteps': totalSteps,
    'effectiveCellsPerRound':
        (roundRecords.first.summary['totalEffectiveCells'] as num).toInt(),
    'stepsPerCellPerRound': (roundRecords.first.manifest['stepsPerCell'] as num)
        .toInt(),
    'cumulativeStepsPerSetting':
        (roundRecords.first.manifest['stepsPerCell'] as num).toInt() *
        roundRecords.length,
    'recordCounts': <String, Object?>{
      'dataset_manifest': 1,
      'round_summary': roundRecords.length,
      'cell': totalCells,
    },
    'topLevelCellFields': const [
      'recordType',
      'sourceRound',
      'cellId',
      'round',
      'seed',
      'steps',
      'settingKey',
      'setting',
      'metrics',
      'histograms',
      'qaChecks',
      'sequence',
    ],
    'notes': const [
      'Each cell record is the original cells.jsonl row with recordType and sourceRound added.',
      'Round summaries embed the full per-round manifest.json and summary.json payloads.',
      'This bundle covers rounds 01 through 08, Smart Generator on, voicing suggestions excluded.',
    ],
  };

  var writtenLines = 0;
  final sink = outputFile.openWrite(encoding: utf8);
  try {
    sink.writeln(jsonEncode(manifestRecord));
    writtenLines += 1;

    for (final record in roundRecords) {
      final roundSummaryRecord = <String, Object?>{
        'recordType': 'round_summary',
        'sourceRound': record.round,
        'roundDir': record.roundDirName,
        'manifest': record.manifest,
        'summary': record.summary,
        'cellLineCount': record.cellLineCount,
      };
      sink.writeln(jsonEncode(roundSummaryRecord));
      writtenLines += 1;

      final lines = record.cellsFile
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter());
      await for (final line in lines) {
        if (line.trim().isEmpty) {
          continue;
        }
        final cell = jsonDecode(line) as Map<String, dynamic>;
        final cellRecord = <String, Object?>{
          'recordType': 'cell',
          'sourceRound': record.round,
          'cellId': cell['cellId'],
          'round': cell['round'],
          'seed': cell['seed'],
          'steps': cell['steps'],
          'settingKey': cell['settingKey'],
          'setting': cell['setting'],
          'metrics': cell['metrics'],
          'histograms': cell['histograms'],
          'qaChecks': cell['qaChecks'],
          'sequence': cell['sequence'],
        };
        sink.writeln(jsonEncode(cellRecord));
        writtenLines += 1;
      }
    }
  } finally {
    await sink.close();
  }

  final fileSize = outputFile.lengthSync();
  stdout.writeln(
    jsonEncode(<String, Object?>{
      'output': outputFile.path,
      'sizeBytes': fileSize,
      'lineCount': writtenLines,
      'roundCount': roundRecords.length,
      'totalCellRecords': totalCells,
      'totalSteps': totalSteps,
    }),
  );
}

class _Args {
  const _Args({required this.root, this.outputPath});

  final String root;
  final String? outputPath;

  static _Args parse(List<String> args) {
    var root = _defaultRoot;
    String? outputPath;

    for (var index = 0; index < args.length; index += 1) {
      switch (args[index]) {
        case '--root':
          root = args[++index];
        case '--output':
          outputPath = args[++index];
        default:
          throw ArgumentError('Unknown argument: ${args[index]}');
      }
    }

    return _Args(root: root, outputPath: outputPath);
  }
}

class _RoundRecord {
  const _RoundRecord({
    required this.round,
    required this.roundDirName,
    required this.manifest,
    required this.summary,
    required this.cellLineCount,
    required this.cellsFile,
  });

  final int round;
  final String roundDirName;
  final Map<String, dynamic> manifest;
  final Map<String, dynamic> summary;
  final int cellLineCount;
  final File cellsFile;
}

final RegExp _roundDirPattern = RegExp(r'^round_\d{2}$');

Future<int> _countLines(File file) async {
  var count = 0;
  final lines = file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  await for (final _ in lines) {
    count += 1;
  }
  return count;
}

String _basename(String path) => path.split(Platform.pathSeparator).last;
