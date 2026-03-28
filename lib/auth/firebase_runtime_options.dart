import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseRuntimeOptions {
  const FirebaseRuntimeOptions._();

  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) {
      return _buildOptions(
        apiKey: _read('FIREBASE_WEB_API_KEY'),
        appId: _read('FIREBASE_WEB_APP_ID'),
        messagingSenderId: _shared('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _shared('FIREBASE_PROJECT_ID'),
        authDomain: _shared('FIREBASE_AUTH_DOMAIN'),
        storageBucket: _shared('FIREBASE_STORAGE_BUCKET'),
        measurementId: _read('FIREBASE_WEB_MEASUREMENT_ID'),
      );
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => _buildOptions(
        apiKey: _read('FIREBASE_ANDROID_API_KEY'),
        appId: _read('FIREBASE_ANDROID_APP_ID'),
        messagingSenderId: _shared('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _shared('FIREBASE_PROJECT_ID'),
        storageBucket: _shared('FIREBASE_STORAGE_BUCKET'),
      ),
      TargetPlatform.iOS => _buildOptions(
        apiKey: _read('FIREBASE_IOS_API_KEY'),
        appId: _read('FIREBASE_IOS_APP_ID'),
        messagingSenderId: _shared('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _shared('FIREBASE_PROJECT_ID'),
        storageBucket: _shared('FIREBASE_STORAGE_BUCKET'),
        iosBundleId: _read('FIREBASE_IOS_BUNDLE_ID'),
      ),
      TargetPlatform.macOS => _buildOptions(
        apiKey: _read('FIREBASE_MACOS_API_KEY'),
        appId: _read('FIREBASE_MACOS_APP_ID'),
        messagingSenderId: _shared('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _shared('FIREBASE_PROJECT_ID'),
        storageBucket: _shared('FIREBASE_STORAGE_BUCKET'),
        iosBundleId: _read('FIREBASE_MACOS_BUNDLE_ID'),
      ),
      _ => null,
    };
  }

  static FirebaseOptions? _buildOptions({
    required String? apiKey,
    required String? appId,
    required String? messagingSenderId,
    required String? projectId,
    String? authDomain,
    String? storageBucket,
    String? iosBundleId,
    String? measurementId,
  }) {
    if (apiKey == null ||
        appId == null ||
        messagingSenderId == null ||
        projectId == null) {
      return null;
    }
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
      iosBundleId: iosBundleId,
      measurementId: measurementId,
    );
  }

  static String? _shared(String key) => _read(key);

  static String? _read(String key) {
    final value = String.fromEnvironment(key).trim();
    return value.isEmpty ? null : value;
  }
}
