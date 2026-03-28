import 'dart:io';

import 'package:path/path.dart' as path;

Future<void> main(List<String> args) async {
  final webBuildPath = args.isNotEmpty ? args.first : path.join('build', 'web');
  final buildDirectory = Directory(webBuildPath);
  if (!buildDirectory.existsSync()) {
    stderr.writeln('Web build directory not found: ${buildDirectory.path}');
    exitCode = 64;
    return;
  }

  final sampleDirectory = Directory(
    path.join(
      buildDirectory.path,
      'assets',
      'assets',
      'piano',
      'salamander_essential',
      'samples',
    ),
  );
  final extraFiles = <File>[
    File(
      path.join(
        buildDirectory.path,
        'assets',
        'assets',
        'piano',
        'salamander_essential',
        'SOURCE_README.txt',
      ),
    ),
    File(
      path.join(
        buildDirectory.path,
        'assets',
        'assets',
        'piano',
        'salamander_essential',
        'SalamanderGrandPiano-Essential.sfz',
      ),
    ),
    File(
      path.join(
        buildDirectory.path,
        'assets',
        'assets',
        'piano',
        'salamander_essential',
        'stats.json',
      ),
    ),
  ];

  var reclaimedBytes = 0;
  if (sampleDirectory.existsSync()) {
    reclaimedBytes += await _measureDirectory(sampleDirectory);
    await sampleDirectory.delete(recursive: true);
  }

  for (final file in extraFiles) {
    if (!file.existsSync()) {
      continue;
    }
    reclaimedBytes += file.lengthSync();
    await file.delete();
  }

  stdout.writeln(
    'Pruned ${_formatMegabytes(reclaimedBytes)} MB of sampled-instrument '
    'assets from ${buildDirectory.path}.',
  );
}

Future<int> _measureDirectory(Directory directory) async {
  var totalBytes = 0;
  await for (final entity in directory.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entity is File) {
      totalBytes += await entity.length();
    }
  }
  return totalBytes;
}

String _formatMegabytes(int bytes) {
  return (bytes / (1024 * 1024)).toStringAsFixed(2);
}
