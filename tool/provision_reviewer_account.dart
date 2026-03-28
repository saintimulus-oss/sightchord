import 'dart:convert';
import 'dart:io';

import 'package:chordest/billing/billing_models.dart';

const String _defaultOutputPath =
    'store/google-play/reviewer-access.generated.txt';

Future<void> main(List<String> args) async {
  final config = _ProvisionConfig.fromArgs(args, Platform.environment);
  if (config.showHelp) {
    stdout.writeln(_usage());
    return;
  }

  final validationErrors = config.validationErrors;
  if (validationErrors.isNotEmpty) {
    stderr.writeln('Missing required reviewer provisioning values:');
    for (final error in validationErrors) {
      stderr.writeln('- $error');
    }
    stderr.writeln('');
    stderr.writeln(_usage());
    exitCode = 64;
    return;
  }

  final client = _FirebaseProvisioningClient(
    webApiKey: config.webApiKey!,
    projectId: config.projectId!,
  );

  try {
    final session = await client.createOrSignIn(
      email: config.email!,
      password: config.password!,
    );
    final snapshot = _buildReviewerSnapshot(
      reviewerTag: config.reviewerTag,
      now: DateTime.now().toUtc(),
      productId: config.productId,
    );
    await client.seedBillingState(
      idToken: session.idToken,
      userId: session.userId,
      snapshot: snapshot,
    );

    final note = _buildReviewerAccessNote(config);
    final outputFile = File(config.outputPath);
    await outputFile.create(recursive: true);
    await outputFile.writeAsString('$note\n');

    stdout.writeln(
      'Reviewer premium account is ready for Google Play review.',
    );
    stdout.writeln('Account email: ${config.email}');
    stdout.writeln(
      'Auth action: ${session.wasCreated ? 'created new reviewer account' : 'reused existing reviewer account'}',
    );
    stdout.writeln('Firestore path: users/${session.userId}/private/billing_state');
    stdout.writeln('Paste-ready App access note: ${outputFile.path}');
  } on _ProvisioningException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } finally {
    client.close();
  }
}

BillingStoreSnapshot _buildReviewerSnapshot({
  required String reviewerTag,
  required DateTime now,
  required String productId,
}) {
  final purchaseId = 'reviewer-$reviewerTag';
  final transactionDate = now.millisecondsSinceEpoch.toString();
  return BillingStoreSnapshot(
    entitlements: <AppEntitlement, BillingEntitlementRecord>{
      AppEntitlement.premiumUnlock: BillingEntitlementRecord(
        entitlement: AppEntitlement.premiumUnlock,
        productId: productId,
        isActive: true,
        source: BillingEntitlementSource.restore,
        updatedAt: now,
        lastVerifiedAt: now,
        purchaseId: purchaseId,
        transactionDate: transactionDate,
      ),
    },
    lastSyncAt: now,
  );
}

String _buildReviewerAccessNote(
  _ProvisionConfig config,
) {
  return '''
No external login credentials are required for the main app flow.

Reviewers can install and launch the app, then immediately access the Main Menu, Chordest practice generator, Chord Analyzer, and Settings without creating an account.

Premium features are available through the dedicated reviewer premium account below.

Reviewer premium account
- Email: ${config.email}
- Password: ${config.password}

To test premium access
1. Launch the app.
2. Open Main Menu > Settings > Account.
3. Sign in with the reviewer premium account above.
4. Return to Main Menu > Settings > Chordest Premium.
5. Premium should already be unlocked for this account, including Smart Generator and advanced harmony controls.
6. You can also open the practice generator and enable a previously locked premium option to verify premium is active.

To test account creation and deletion separately
1. Sign out of the reviewer premium account after premium verification.
2. Create a new throwaway email/password account inside the app from Main Menu > Settings > Account.
3. Use Delete account from the same Account screen to test self-service deletion.
4. Do not delete the reviewer premium account above, because it is reserved for store review.
''';
}

String _usage() {
  return '''
Usage:
  dart run tool/provision_reviewer_account.dart ^
    --web-api-key=YOUR_FIREBASE_WEB_API_KEY ^
    --project-id=YOUR_FIREBASE_PROJECT_ID ^
    --email=play-review@example.com ^
    --password=STRONG_REVIEW_PASSWORD

Optional:
  --product-id=premium_unlock
  --reviewer-tag=google-play-review
  --output=store/google-play/reviewer-access.generated.txt

You can also provide the same values through environment variables:
  FIREBASE_WEB_API_KEY
  FIREBASE_PROJECT_ID
  REVIEWER_ACCOUNT_EMAIL
  REVIEWER_ACCOUNT_PASSWORD
''';
}

class _ProvisionConfig {
  const _ProvisionConfig({
    required this.showHelp,
    required this.webApiKey,
    required this.projectId,
    required this.email,
    required this.password,
    required this.productId,
    required this.reviewerTag,
    required this.outputPath,
  });

  factory _ProvisionConfig.fromArgs(
    List<String> args,
    Map<String, String> environment,
  ) {
    final parsed = <String, String>{};
    var showHelp = false;
    for (final arg in args) {
      if (arg == '--help' || arg == '-h') {
        showHelp = true;
        continue;
      }
      if (!arg.startsWith('--') || !arg.contains('=')) {
        continue;
      }
      final separatorIndex = arg.indexOf('=');
      parsed[arg.substring(2, separatorIndex)] = arg.substring(
        separatorIndex + 1,
      );
    }

    String? read(String argKey, String envKey) {
      final argValue = parsed[argKey]?.trim();
      if (argValue != null && argValue.isNotEmpty) {
        return argValue;
      }
      final envValue = environment[envKey]?.trim();
      if (envValue != null && envValue.isNotEmpty) {
        return envValue;
      }
      return null;
    }

    return _ProvisionConfig(
      showHelp: showHelp,
      webApiKey: read('web-api-key', 'FIREBASE_WEB_API_KEY'),
      projectId: read('project-id', 'FIREBASE_PROJECT_ID'),
      email: read('email', 'REVIEWER_ACCOUNT_EMAIL'),
      password: read('password', 'REVIEWER_ACCOUNT_PASSWORD'),
      productId: read('product-id', 'REVIEWER_PRODUCT_ID') ??
          kPremiumUnlockProductId,
      reviewerTag: read('reviewer-tag', 'REVIEWER_ACCOUNT_TAG') ??
          'google-play-review',
      outputPath: read('output', 'REVIEWER_ACCESS_OUTPUT') ?? _defaultOutputPath,
    );
  }

  final bool showHelp;
  final String? webApiKey;
  final String? projectId;
  final String? email;
  final String? password;
  final String productId;
  final String reviewerTag;
  final String outputPath;

  List<String> get validationErrors {
    return <String>[
      if (webApiKey == null) 'FIREBASE_WEB_API_KEY / --web-api-key',
      if (projectId == null) 'FIREBASE_PROJECT_ID / --project-id',
      if (email == null) 'REVIEWER_ACCOUNT_EMAIL / --email',
      if (password == null) 'REVIEWER_ACCOUNT_PASSWORD / --password',
    ];
  }
}

class _FirebaseProvisioningClient {
  _FirebaseProvisioningClient({
    required this.webApiKey,
    required this.projectId,
  }) : _httpClient = HttpClient();

  final String webApiKey;
  final String projectId;
  final HttpClient _httpClient;

  Future<_AuthSession> createOrSignIn({
    required String email,
    required String password,
  }) async {
    final signUpUri = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$webApiKey',
    );
    try {
      final created = await _postJson(signUpUri, <String, Object?>{
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });
      return _AuthSession.fromJson(created, wasCreated: true);
    } on _ProvisioningException catch (error) {
      if (error.code != 'EMAIL_EXISTS') {
        rethrow;
      }
    }

    final signInUri = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$webApiKey',
    );
    final signedIn = await _postJson(signInUri, <String, Object?>{
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    return _AuthSession.fromJson(signedIn, wasCreated: false);
  }

  Future<void> seedBillingState({
    required String idToken,
    required String userId,
    required BillingStoreSnapshot snapshot,
  }) async {
    final documentUri = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$userId/private/billing_state',
    );
    final documentBody = <String, Object?>{
      'fields': _mapFields(snapshot.toJson()),
    };
    await _patchJson(documentUri, documentBody, bearerToken: idToken);
  }

  Future<Map<String, dynamic>> _postJson(
    Uri uri,
    Map<String, Object?> payload,
  ) async {
    final request = await _httpClient.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(payload));
    final response = await request.close();
    return _decodeResponse(response, uri);
  }

  Future<Map<String, dynamic>> _patchJson(
    Uri uri,
    Map<String, Object?> payload, {
    required String bearerToken,
  }) async {
    final request = await _httpClient.openUrl('PATCH', uri);
    request.headers.contentType = ContentType.json;
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $bearerToken');
    request.write(jsonEncode(payload));
    final response = await request.close();
    return _decodeResponse(response, uri);
  }

  Future<Map<String, dynamic>> _decodeResponse(
    HttpClientResponse response,
    Uri uri,
  ) async {
    final body = await response.transform(utf8.decoder).join();
    final decoded = body.isEmpty
        ? const <String, Object?>{}
        : jsonDecode(body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    final errorPayload = decoded['error'];
    if (errorPayload is Map<String, dynamic>) {
      final message = errorPayload['message']?.toString();
      throw _ProvisioningException(
        message ??
            'Provisioning request failed (${response.statusCode}) at $uri',
        code: message,
      );
    }
    throw _ProvisioningException(
      'Provisioning request failed (${response.statusCode}) at $uri',
    );
  }

  void close() {
    _httpClient.close(force: true);
  }
}

class _AuthSession {
  const _AuthSession({
    required this.userId,
    required this.idToken,
    required this.wasCreated,
  });

  factory _AuthSession.fromJson(
    Map<String, dynamic> json, {
    required bool wasCreated,
  }) {
    final userId = json['localId']?.toString();
    final idToken = json['idToken']?.toString();
    if (userId == null || userId.isEmpty || idToken == null || idToken.isEmpty) {
      throw const _ProvisioningException(
        'Firebase Auth response did not include a usable localId/idToken.',
      );
    }
    return _AuthSession(
      userId: userId,
      idToken: idToken,
      wasCreated: wasCreated,
    );
  }

  final String userId;
  final String idToken;
  final bool wasCreated;
}

class _ProvisioningException implements Exception {
  const _ProvisioningException(this.message, {this.code});

  final String message;
  final String? code;
}

class BillingStoreSnapshot {
  const BillingStoreSnapshot({
    this.entitlements = const <AppEntitlement, BillingEntitlementRecord>{},
    this.lastSyncAt,
  });

  final Map<AppEntitlement, BillingEntitlementRecord> entitlements;
  final DateTime? lastSyncAt;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'version': 2,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
      'records': entitlements.values
          .map((record) => record.toJson())
          .toList(growable: false),
    };
  }
}

Map<String, Object?> _mapFields(Map<String, Object?> values) {
  return <String, Object?>{
    for (final entry in values.entries) entry.key: _toFirestoreValue(entry.value),
  };
}

Map<String, Object?> _toFirestoreValue(Object? value) {
  if (value == null) {
    return <String, Object?>{'nullValue': null};
  }
  if (value is String) {
    return <String, Object?>{'stringValue': value};
  }
  if (value is bool) {
    return <String, Object?>{'booleanValue': value};
  }
  if (value is int) {
    return <String, Object?>{'integerValue': '$value'};
  }
  if (value is double) {
    return <String, Object?>{'doubleValue': value};
  }
  if (value is List) {
    return <String, Object?>{
      'arrayValue': <String, Object?>{
        'values': value.map(_toFirestoreValue).toList(growable: false),
      },
    };
  }
  if (value is Map) {
    return <String, Object?>{
      'mapValue': <String, Object?>{
        'fields': <String, Object?>{
          for (final entry in value.entries)
            '${entry.key}': _toFirestoreValue(entry.value),
        },
      },
    };
  }
  throw UnsupportedError('Unsupported Firestore value type: ${value.runtimeType}');
}
