# Developer Notes

## Local Validation

Run the full preferred validation flow from the repository root:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build web --release --base-href /chordest/
```

## Source-Controlled vs Generated

Treat these paths as source-controlled:

- `lib/`
- `web/`
- authored files in `assets/`
- `test/`
- `docs/`
- `.github/workflows/`

Treat these paths as generated or machine-local:

- `build/`
- `.dart_tool/`
- `.appdata/`
- `android/.gradle/`
- `android/local.properties`
- logs, scratch files, editor temp files, and local browser-profile data
- root-level Flutter web build outputs such as `main.dart.js`, `flutter*.js`, `canvaskit/`, `icons/`, generated `assets/` manifests, and related bootstrap/service-worker files

GitHub Pages deploys from CI-generated `build/web` artifacts. Generated web output should not be maintained by hand at the repository root.

## Owner-Only Follow-Ups

The repository now uses the shared production identifier `io.github.saintimulusoss.chordest` across Android, iOS, macOS, and Linux. The remaining owner-only work is release provisioning rather than namespace cleanup.

- [android/app/build.gradle.kts](../android/app/build.gradle.kts):28 still signs release builds with the debug keystore until owner-provided release signing is configured.
- Platform-specific release verification still needs to run on owner hardware and toolchains after signing/notarization setup.

Recommended owner action:

1. Provision Android release signing and remove the debug-key fallback.
2. Re-run Android, iOS, macOS, Linux, and Windows release checks on fully provisioned machines.
3. Finish store-facing metadata such as versioning, privacy policy, and support links before distribution.
