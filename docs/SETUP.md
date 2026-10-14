# Development setup

Use Flutter 3.47.7 stable and Java 17, matching .github/workflows/apk.yml.
Install the Android SDK and run flutter doctor to check the toolchain.

```sh
flutter pub get
flutter analyze
flutter test -j 1
flutter build apk --release
```

This build uses applicationId com.fyp.indoornav, minimum Android API 30 and ARM64.
The existing debug key signs release builds for college evaluation without secrets.
The optional language-model code is retained behind enableOnDeviceAi=false; no model file is required or searched for.
Offline speech requires a supported on-device recognition service and an installed language pack.

GitHub Actions validates pull requests and builds release APKs. Pushes to main publish v1.0-testathon with the APK and documents.
