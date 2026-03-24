import 'dart:io';

import 'package:chordest/audio/metronome_audio_models.dart';
import 'package:chordest/settings/metronome_custom_sound_service.dart';
import 'package:chordest/settings/metronome_custom_sound_service_io.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IOMetronomeCustomSoundService', () {
    test('copies the picked file into the managed primary slot', () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'metronome-custom-service',
      );
      addTearDown(() async {
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      });

      final sourceFile = File('${tempDirectory.path}/source-click.wav');
      await sourceFile.writeAsBytes(<int>[1, 2, 3, 4]);
      final service = IOMetronomeCustomSoundService(
        pickFile: (_) async => XFile(sourceFile.path),
        supportDirectoryPath: () async => tempDirectory.path,
      );

      final selection = await service.pickAndStore(
        slot: MetronomeCustomSoundSlot.primary,
        fallbackSound: MetronomeSound.tickE,
      );

      expect(selection, isNotNull);
      expect(selection!.source.kind, MetronomeSourceKind.localFile);
      expect(selection.source.builtInSound, MetronomeSound.tickE);
      expect(selection.fileName, 'primary.wav');
      final storedFile = File(selection.source.trimmedLocalFilePath);
      expect(await storedFile.exists(), isTrue);
      expect(await storedFile.readAsBytes(), <int>[1, 2, 3, 4]);
    });

    test('replacing a slot removes the previous managed file', () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'metronome-custom-replace',
      );
      addTearDown(() async {
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      });

      final firstSource = File('${tempDirectory.path}/first-click.wav');
      final secondSource = File('${tempDirectory.path}/second-click.mp3');
      await firstSource.writeAsBytes(<int>[1, 1, 1]);
      await secondSource.writeAsBytes(<int>[2, 2, 2]);

      XFile? nextFile = XFile(firstSource.path);
      final service = IOMetronomeCustomSoundService(
        pickFile: (_) async => nextFile,
        supportDirectoryPath: () async => tempDirectory.path,
      );

      final firstSelection = await service.pickAndStore(
        slot: MetronomeCustomSoundSlot.primary,
        fallbackSound: MetronomeSound.tick,
      );
      final firstStoredPath = firstSelection!.source.trimmedLocalFilePath;
      expect(await File(firstStoredPath).exists(), isTrue);

      nextFile = XFile(secondSource.path);
      final secondSelection = await service.pickAndStore(
        slot: MetronomeCustomSoundSlot.primary,
        fallbackSound: MetronomeSound.tickF,
      );

      expect(await File(firstStoredPath).exists(), isFalse);
      expect(secondSelection!.fileName, 'primary.mp3');
      expect(
        await File(secondSelection.source.trimmedLocalFilePath).exists(),
        isTrue,
      );
      expect(
        await File(secondSelection.source.trimmedLocalFilePath).readAsBytes(),
        <int>[2, 2, 2],
      );
    });

    test('clearSlot only removes files for the requested slot', () async {
      final tempDirectory = await Directory.systemTemp.createTemp(
        'metronome-custom-clear',
      );
      addTearDown(() async {
        if (await tempDirectory.exists()) {
          await tempDirectory.delete(recursive: true);
        }
      });

      final primarySource = File('${tempDirectory.path}/primary-source.wav');
      final accentSource = File('${tempDirectory.path}/accent-source.wav');
      await primarySource.writeAsBytes(<int>[3]);
      await accentSource.writeAsBytes(<int>[4]);

      XFile? nextFile = XFile(primarySource.path);
      final service = IOMetronomeCustomSoundService(
        pickFile: (_) async => nextFile,
        supportDirectoryPath: () async => tempDirectory.path,
      );

      final primarySelection = await service.pickAndStore(
        slot: MetronomeCustomSoundSlot.primary,
        fallbackSound: MetronomeSound.tick,
      );
      nextFile = XFile(accentSource.path);
      final accentSelection = await service.pickAndStore(
        slot: MetronomeCustomSoundSlot.accent,
        fallbackSound: MetronomeSound.tickF,
      );

      await service.clearSlot(slot: MetronomeCustomSoundSlot.primary);

      expect(
        await File(primarySelection!.source.trimmedLocalFilePath).exists(),
        isFalse,
      );
      expect(
        await File(accentSelection!.source.trimmedLocalFilePath).exists(),
        isTrue,
      );
    });
  });
}
