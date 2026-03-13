import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(Future<void> Function() testMain) async {
  final staleManifest = File('build/unit_test_assets/NativeAssetsManifest.json');
  if (await staleManifest.exists()) {
    try {
      await staleManifest.delete();
    } on FileSystemException {
      // Leave test behavior unchanged if cleanup is blocked by the OS.
    }
  }

  await testMain();
}
