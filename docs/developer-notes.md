# Developer Notes

## Local Validation

Run the full preferred validation flow from the repository root:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build web --release --base-href /sightchord/
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

The repository still contains templated platform identifiers. There is no unambiguous canonical production identifier elsewhere in the repo, so these values were intentionally left unchanged.

- [android/app/build.gradle.kts](/Users/User/sightchord/android/app/build.gradle.kts):9 currently sets `namespace = "com.example.sightchord"`.
- [android/app/build.gradle.kts](/Users/User/sightchord/android/app/build.gradle.kts):24 currently sets `applicationId = "com.example.sightchord"`.
- [android/app/src/main/kotlin/com/example/sightchord/MainActivity.kt](/Users/User/sightchord/android/app/src/main/kotlin/com/example/sightchord/MainActivity.kt):1 currently declares `package com.example.sightchord`.
- [ios/Runner.xcodeproj/project.pbxproj](/Users/User/sightchord/ios/Runner.xcodeproj/project.pbxproj):375 currently sets `PRODUCT_BUNDLE_IDENTIFIER = com.example.sightchord;`.
- [ios/Runner.xcodeproj/project.pbxproj](/Users/User/sightchord/ios/Runner.xcodeproj/project.pbxproj):391 currently sets Runner test bundle identifiers under `com.example.sightchord.RunnerTests`.
- [linux/CMakeLists.txt](/Users/User/sightchord/linux/CMakeLists.txt):10 currently sets `APPLICATION_ID "com.example.sightchord"`.
- [macos/Runner/Configs/AppInfo.xcconfig](/Users/User/sightchord/macos/Runner/Configs/AppInfo.xcconfig):11 currently sets `PRODUCT_BUNDLE_IDENTIFIER = com.example.sightchord`.
- [macos/Runner.xcodeproj/project.pbxproj](/Users/User/sightchord/macos/Runner.xcodeproj/project.pbxproj):388 currently sets Runner test bundle identifiers under `com.example.sightchord.RunnerTests`.

Recommended owner action:

1. Decide the canonical production package or bundle identifier.
2. Update Android namespace/application ID plus the Kotlin package path together.
3. Update iOS, macOS, and Linux bundle identifiers to the same canonical namespace where applicable.
4. Re-run the full validation flow and platform-specific release checks after those identifier changes.
