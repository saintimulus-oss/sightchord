import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../audio/metronome_audio_models.dart';
import 'metronome_custom_sound_service_types.dart';

typedef MetronomeCustomSoundPicker =
    Future<XFile?> Function(List<XTypeGroup> acceptedTypeGroups);
typedef MetronomeSupportDirectoryResolver = Future<String> Function();

MetronomeCustomSoundService createMetronomeCustomSoundService() {
  return IOMetronomeCustomSoundService();
}

class IOMetronomeCustomSoundService implements MetronomeCustomSoundService {
  IOMetronomeCustomSoundService({
    MetronomeCustomSoundPicker? pickFile,
    MetronomeSupportDirectoryResolver? supportDirectoryPath,
  }) : _pickFile = pickFile ?? _defaultPickFile,
       _supportDirectoryPath =
           supportDirectoryPath ?? _defaultSupportDirectoryPath;

  static const List<String> _audioExtensions = <String>[
    'aac',
    'aiff',
    'flac',
    'm4a',
    'mp3',
    'ogg',
    'wav',
  ];

  static final XTypeGroup _audioTypeGroup = XTypeGroup(
    label: 'audio',
    extensions: _audioExtensions,
  );

  final MetronomeCustomSoundPicker _pickFile;
  final MetronomeSupportDirectoryResolver _supportDirectoryPath;

  @override
  bool get isSupported => true;

  @override
  Future<MetronomeCustomSoundSelection?> pickAndStore({
    required MetronomeCustomSoundSlot slot,
    required MetronomeSound fallbackSound,
  }) async {
    final pickedFile = await _pickFile(<XTypeGroup>[_audioTypeGroup]);
    if (pickedFile == null) {
      return null;
    }

    final managedDirectory = await _ensureManagedDirectory();
    await _deleteManagedSlotFiles(slot, managedDirectory);

    final extension = _resolveExtension(pickedFile);
    final storedPath = p.join(managedDirectory.path, '${slot.name}$extension');
    await pickedFile.saveTo(storedPath);

    return MetronomeCustomSoundSelection(
      source: MetronomeSourceSpec.localFile(
        localFilePath: storedPath,
        fallbackSound: fallbackSound,
      ),
      fileName: p.basename(storedPath),
    );
  }

  @override
  Future<void> clearSlot({required MetronomeCustomSoundSlot slot}) async {
    final managedDirectory = await _ensureManagedDirectory();
    await _deleteManagedSlotFiles(slot, managedDirectory);
  }

  Future<Directory> _ensureManagedDirectory() async {
    final supportDirectoryPath = await _supportDirectoryPath();
    final managedDirectory = Directory(
      p.join(supportDirectoryPath, 'metronome_custom_sounds'),
    );
    await managedDirectory.create(recursive: true);
    return managedDirectory;
  }

  Future<void> _deleteManagedSlotFiles(
    MetronomeCustomSoundSlot slot,
    Directory managedDirectory,
  ) async {
    if (!await managedDirectory.exists()) {
      return;
    }
    await for (final entity in managedDirectory.list()) {
      if (entity is! File) {
        continue;
      }
      final fileName = p.basenameWithoutExtension(entity.path);
      if (fileName != slot.name) {
        continue;
      }
      if (await entity.exists()) {
        await entity.delete();
      }
    }
  }

  String _resolveExtension(XFile file) {
    final fromName = p.extension(file.name).toLowerCase();
    if (fromName.isNotEmpty) {
      return fromName;
    }
    final fromPath = p.extension(file.path).toLowerCase();
    if (fromPath.isNotEmpty) {
      return fromPath;
    }
    return '.wav';
  }

  static Future<String> _defaultSupportDirectoryPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  static Future<XFile?> _defaultPickFile(List<XTypeGroup> acceptedTypeGroups) {
    return openFile(acceptedTypeGroups: acceptedTypeGroups);
  }
}
