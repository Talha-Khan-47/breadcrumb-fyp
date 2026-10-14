# IndoorNav

Offline indoor navigation using a route you walk and save on your phone.

Project title: <FILL> (IndoorNav is the temporary app name).

## The problem

GPS is unreliable inside buildings. People need a way to return to rooms and other places without internet access or installed navigation equipment.

## Features

- Record a walking trail and mark named places, including aliases.
- Draw a floor map, join loops and save multiple maps on the phone.
- Find places by exact name, fuzzy matching or saved aliases.
- Follow an arrow with spoken instructions and vibration.
- Use voice input or Scan a sign to read a place name.
- Confirm position, recover from leaving the route and manually change floors.

## How it works

Record → Mark places → Navigate. Walk a route once while holding the phone. Mark the places you want to revisit. Later choose your starting place and destination; the app plans a route along the saved corridors.

Confidence falls as you walk. The app can ask “Are you at X?” to check its estimate. If you leave the route, it guides you back towards the path. When arrival is uncertain, it asks you to confirm with “I'm here”; reaching the estimated distance alone is not always enough to confirm arrival.

## Tech stack

Flutter/Dart provides the app and navigation logic. A native Kotlin sensor channel supplies motion samples. Accelerometer step detection counts walking; supported phones also supply hardware step events. Gyroscope turn detection is measured around gravity and recorded turns are snapped to 90°. Turn confirmation needs 2 steps in the new direction within 8 seconds.

The map is a graph of places and corridors measured in steps. A shortest-path route planner selects the route. On-device speech recognition accepts destinations, text-to-speech speaks instructions, and ML Kit text recognition reads signs. Maps are JSON files in a saved-maps library on the phone.

## Install the APK

1. Open the repository's [Releases page](https://github.com/Talha-Khan-47/breadcrumb-fyp/releases).
2. Download `IndoorNav-v1.0.apk` from “Testathon build v1.0” once it is published after merging to main.
3. Allow your browser or file manager to install unknown apps in Android Settings.
4. Open the downloaded file and install it. This build needs Android 11+ and an ARM64 phone.

## How to use it

1. Open IndoorNav and grant the requested permissions. Hold the phone in your hand.
2. Tap **Record a trail** and start the recording.
3. Walk normally, turn at corners and mark places with clear names. Add aliases where useful.
4. Stop and confirm saving. Use **Saved maps** to choose, rename or delete a map.
5. Tap **Navigate** and select where you are. You can also scan a sign to identify the starting place.
6. Type or speak a destination, or select it from the list.
7. Follow the arrow, speech and vibration. Answer position checks only when you recognise the place.
8. Confirm uncertain arrival and tap to confirm a floor change when requested.

## Build from source

Install Flutter and the Android SDK, then run:

```sh
flutter pub get
flutter build apk --release
```

The APK is at `build/app/outputs/flutter-apk/app-release.apk`. Release builds use the repository's debug signing key for college testing. GitHub Actions runs analysis and tests before building; only pushes to main publish release files.

## Testing

The repository contains automated unit and widget tests, including real recorded walking traces replayed in tests. Run `flutter analyze` and `flutter test -j 1`. Flutter was unavailable in the editing environment; CI must establish the passing result for this revision.

## Known limitations

- The phone must be held in hand.
- Fast walking undercounts steps by 10–15%.
- Floor change is a manual tap.
- Error builds up on long walks and is reduced by position confirmations.
- Offline voice input needs an installed speech language pack; typed input remains available.
- Navigation covers only routes already recorded. The temporary sample map is not a map of your building.

## Future scope

On-device AI assistant for natural-language requests; pocket mode; automatic floor detection with a barometer; venue maps shared by QR code; voice-first mode for visually impaired users.

## Team and guide

Team members and USNs: <FILL>

Guide: <FILL>

College: Mangalore Institute of Technology & Engineering

Department: CSE (AI & ML)
