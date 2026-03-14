import 'dart:convert';
import 'dart:io';

const int _minMidi = 36; // C2
const int _maxMidi = 84; // C6
const List<int> _selectedVelocityLayers = <int>[1, 5, 10, 16];

final Uri _workspaceRoot = Directory.current.uri;
final Uri _sourceLibraryUri = _workspaceRoot.resolve(
  'assets/piano/salamander/',
);
final Uri _sourceSfzUri = _sourceLibraryUri.resolve(
  'SalamanderGrandPiano-V3+20200602.sfz',
);
final Uri _sourceReadmeUri = _sourceLibraryUri.resolve('readme.txt');
final Uri _sourceSamplesUri = _sourceLibraryUri.resolve('samples/');
final Uri _outputLibraryUri = _workspaceRoot.resolve(
  'assets/piano/salamander_essential/',
);
final Uri _outputSamplesUri = _outputLibraryUri.resolve('samples/');

Future<void> main() async {
  final sourceDir = Directory.fromUri(_sourceLibraryUri);
  final outputDir = Directory.fromUri(_outputLibraryUri);
  final outputSamplesDir = Directory.fromUri(_outputSamplesUri);
  final sourceSfzFile = File.fromUri(_sourceSfzUri);
  final sourceReadmeFile = File.fromUri(_sourceReadmeUri);

  if (!await sourceDir.exists()) {
    stderr.writeln(
      'Source Salamander library was not found at ${sourceDir.path}.',
    );
    exitCode = 1;
    return;
  }
  if (!await sourceSfzFile.exists()) {
    stderr.writeln('Source SFZ file was not found at ${sourceSfzFile.path}.');
    exitCode = 1;
    return;
  }

  final sourceRegions = _parseSfz(await sourceSfzFile.readAsLines());
  final noteRegions = sourceRegions
      .where((region) => region.isNoteSample)
      .toList(growable: false);
  final selectedRegions =
      noteRegions
          .where(
            (region) =>
                _selectedVelocityLayers.contains(region.layer) &&
                region.intersectsRange(_minMidi, _maxMidi),
          )
          .toList(growable: false)
        ..sort((left, right) {
          final keyCompare = left.pitchKeycenter.compareTo(
            right.pitchKeycenter,
          );
          if (keyCompare != 0) {
            return keyCompare;
          }
          return left.layer.compareTo(right.layer);
        });

  final layerRanges = _buildSimplifiedVelocityRanges(noteRegions);
  final selectedSampleNames = {
    for (final region in selectedRegions) region.sampleRelativePath,
  };

  if (await outputDir.exists()) {
    await outputDir.delete(recursive: true);
  }
  await outputSamplesDir.create(recursive: true);

  for (final sampleRelativePath in selectedSampleNames) {
    final sourceFile = _fileFromLibraryPath(
      _sourceLibraryUri,
      sampleRelativePath,
    );
    final outputFile = _fileFromLibraryPath(
      _outputLibraryUri,
      sampleRelativePath,
    );
    await outputFile.parent.create(recursive: true);
    await sourceFile.copy(outputFile.path);
  }

  if (await sourceReadmeFile.exists()) {
    await sourceReadmeFile.copy(
      File.fromUri(_outputLibraryUri.resolve('SOURCE_README.txt')).path,
    );
  }

  final outputRegions = <Map<String, Object?>>[
    for (final region in selectedRegions)
      {
        'sample': region.sampleRelativePath,
        'lokey': region.lokey,
        'hikey': region.hikey,
        'pitchKeycenter': region.pitchKeycenter,
        'layer': region.layer,
        'lovel': layerRanges[region.layer]!.$1,
        'hivel': layerRanges[region.layer]!.$2,
      },
  ];

  final sourceSampleFiles = await Directory.fromUri(_sourceSamplesUri)
      .list(followLinks: false)
      .where((entity) => entity is File)
      .cast<File>()
      .toList();
  final sourceBytes = await _totalBytes(sourceSampleFiles);

  final selectedFiles = [
    for (final relativePath in selectedSampleNames)
      _fileFromLibraryPath(_outputLibraryUri, relativePath),
  ];
  final optimizedBytes = await _totalBytes(selectedFiles);

  final manifest = <String, Object?>{
    'id': 'salamander-grand-piano-essential',
    'displayName': 'Salamander Grand Piano Essential',
    'version': 1,
    'source': {
      'library': 'Salamander Grand Piano',
      'sfz': _relativePath(_sourceSfzUri),
      'license': 'CC-BY 3.0',
    },
    'range': {
      'minMidi': _minMidi,
      'maxMidi': _maxMidi,
      'minLabel': _midiLabel(_minMidi),
      'maxLabel': _midiLabel(_maxMidi),
    },
    'velocityLayers': [
      for (final layer in _selectedVelocityLayers)
        {
          'layer': layer,
          'minVelocity': layerRanges[layer]!.$1,
          'maxVelocity': layerRanges[layer]!.$2,
        },
    ],
    'defaults': {
      'polyphony': 24,
      'releaseFadeOutMs': 90,
      'defaultChordHoldMs': 950,
      'defaultArpeggioStepMs': 120,
      'defaultArpeggioHoldMs': 780,
      'velocityCurvePower': 0.88,
      'baseVolume': 0.94,
      'noteOnPrerollVoices': 6,
      'clampOutOfRangeNotes': true,
    },
    'regions': outputRegions,
  };

  final stats = <String, Object?>{
    'sourceFileCount': sourceSampleFiles.length,
    'sourceBytes': sourceBytes,
    'sourceMiB': _toMiB(sourceBytes),
    'optimizedFileCount': selectedFiles.length,
    'optimizedBytes': optimizedBytes,
    'optimizedMiB': _toMiB(optimizedBytes),
    'reductionPercent': sourceBytes == 0
        ? 0
        : double.parse(
            (((sourceBytes - optimizedBytes) / sourceBytes) * 100)
                .toStringAsFixed(2),
          ),
    'selectedVelocityLayers': _selectedVelocityLayers,
    'selectedSampleNames': selectedSampleNames.toList()..sort(),
    'removedCategories': <String>[
      'All samples below C2 and above C6',
      'All non-selected velocity layers',
      'All release trigger samples',
      'All pedal up/down noise samples',
      'All sympathetic resonance and harmonic resonance samples',
      'Retuned SFZ variant',
    ],
  };

  await File.fromUri(
    _outputLibraryUri.resolve('manifest.json'),
  ).writeAsString(const JsonEncoder.withIndent('  ').convert(manifest));
  await File.fromUri(
    _outputLibraryUri.resolve('stats.json'),
  ).writeAsString(const JsonEncoder.withIndent('  ').convert(stats));
  await File.fromUri(
    _outputLibraryUri.resolve('SalamanderGrandPiano-Essential.sfz'),
  ).writeAsString(_buildSimplifiedSfz(outputRegions));

  stdout.writeln(
    'Built optimized Salamander pack at ${outputDir.path} '
    '(${selectedFiles.length} samples, ${_toMiB(optimizedBytes)} MiB).',
  );
}

List<_SfzRegion> _parseSfz(List<String> lines) {
  final regions = <_SfzRegion>[];
  for (final line in lines) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('<region>')) {
      continue;
    }
    final values = <String, String>{};
    for (final token
        in trimmed.substring('<region>'.length).trim().split(' ')) {
      if (token.isEmpty || !token.contains('=')) {
        continue;
      }
      final parts = token.split('=');
      if (parts.length != 2) {
        continue;
      }
      values[parts.first] = parts.last;
    }
    final sample = values['sample'];
    final lokey = int.tryParse(values['lokey'] ?? '');
    final hikey = int.tryParse(values['hikey'] ?? '');
    final pitchKeycenter =
        int.tryParse(values['pitch_keycenter'] ?? '') ??
        _parsePitchKeycenterFromSample(sample);
    final lovel = int.tryParse(values['lovel'] ?? '');
    final hivel = int.tryParse(values['hivel'] ?? '') ?? 127;
    final layer = _parseVelocityLayer(sample);
    if (sample == null ||
        lokey == null ||
        hikey == null ||
        pitchKeycenter == null ||
        lovel == null ||
        layer == null) {
      continue;
    }
    regions.add(
      _SfzRegion(
        sampleRelativePath: sample,
        lokey: lokey,
        hikey: hikey,
        pitchKeycenter: pitchKeycenter,
        lovel: lovel,
        hivel: hivel,
        layer: layer,
      ),
    );
  }
  return regions;
}

Map<int, (int, int)> _buildSimplifiedVelocityRanges(List<_SfzRegion> regions) {
  final rangesByLayer = <int, (int, int)>{};
  for (final region in regions) {
    rangesByLayer.putIfAbsent(region.layer, () => (region.lovel, region.hivel));
  }

  final centers = <double>[
    for (final layer in _selectedVelocityLayers)
      ((rangesByLayer[layer]!.$1 + rangesByLayer[layer]!.$2) / 2),
  ];
  final simplified = <int, (int, int)>{};
  var currentStart = 1;
  for (var index = 0; index < _selectedVelocityLayers.length; index += 1) {
    final layer = _selectedVelocityLayers[index];
    final currentEnd = index == _selectedVelocityLayers.length - 1
        ? 127
        : ((centers[index] + centers[index + 1]) / 2).floor();
    simplified[layer] = (currentStart, currentEnd);
    currentStart = currentEnd + 1;
  }
  return simplified;
}

Future<int> _totalBytes(List<File> files) async {
  var total = 0;
  for (final file in files) {
    total += await file.length();
  }
  return total;
}

String _buildSimplifiedSfz(List<Map<String, Object?>> regions) {
  final buffer = StringBuffer()
    ..writeln('// Generated by tool/build_salamander_essential.dart')
    ..writeln('// Learning-focused Salamander subset for Chordest')
    ..writeln('<group> amp_veltrack=76 ampeg_release=0.75')
    ..writeln();
  for (final region in regions) {
    buffer.writeln(
      '<region> '
      'sample=${region['sample']} '
      'lokey=${region['lokey']} '
      'hikey=${region['hikey']} '
      'lovel=${region['lovel']} '
      'hivel=${region['hivel']} '
      'pitch_keycenter=${region['pitchKeycenter']}',
    );
  }
  return buffer.toString();
}

int? _parseVelocityLayer(String? samplePath) {
  if (samplePath == null) {
    return null;
  }
  final match = RegExp(r'v(\d+)\.flac$').firstMatch(samplePath);
  return match == null ? null : int.tryParse(match.group(1)!);
}

int? _parsePitchKeycenterFromSample(String? samplePath) {
  if (samplePath == null) {
    return null;
  }
  final match = RegExp(r'([A-G](?:#)?)(\d+)v\d+\.flac$').firstMatch(samplePath);
  if (match == null) {
    return null;
  }
  const semitonesByNote = <String, int>{
    'C': 0,
    'C#': 1,
    'D': 2,
    'D#': 3,
    'E': 4,
    'F': 5,
    'F#': 6,
    'G': 7,
    'G#': 8,
    'A': 9,
    'A#': 10,
    'B': 11,
  };
  final pitchClass = semitonesByNote[match.group(1)!];
  final octave = int.tryParse(match.group(2)!);
  if (pitchClass == null || octave == null) {
    return null;
  }
  return ((octave + 1) * 12) + pitchClass;
}

String _relativePath(Uri uri) {
  final workspacePath = Directory.current.path;
  final fullPath = File.fromUri(uri).path;
  if (fullPath.startsWith(workspacePath)) {
    final offset = workspacePath.length + 1;
    if (fullPath.length >= offset) {
      return fullPath.substring(offset).replaceAll('\\', '/');
    }
  }
  return fullPath.replaceAll('\\', '/');
}

File _fileFromLibraryPath(Uri baseUri, String relativePath) {
  final basePath = Directory.fromUri(baseUri).path;
  final normalizedRelative = relativePath.replaceAll(
    '/',
    Platform.pathSeparator,
  );
  return File('$basePath${Platform.pathSeparator}$normalizedRelative');
}

double _toMiB(int bytes) =>
    double.parse((bytes / (1024 * 1024)).toStringAsFixed(2));

String _midiLabel(int midi) {
  const names = <String>[
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B',
  ];
  final octave = (midi ~/ 12) - 1;
  return '${names[midi % 12]}$octave';
}

class _SfzRegion {
  const _SfzRegion({
    required this.sampleRelativePath,
    required this.lokey,
    required this.hikey,
    required this.pitchKeycenter,
    required this.lovel,
    required this.hivel,
    required this.layer,
  });

  final String sampleRelativePath;
  final int lokey;
  final int hikey;
  final int pitchKeycenter;
  final int lovel;
  final int hivel;
  final int layer;

  bool get isNoteSample =>
      sampleRelativePath.startsWith('samples/') && layer > 0;

  bool intersectsRange(int minMidi, int maxMidi) =>
      hikey >= minMidi && lokey <= maxMidi;
}
