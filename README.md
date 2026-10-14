# RAIN: Risk-Aware Indoor Navigation 

RAIN is a final-year project that addresses indoor wayfinding in buildings with limited navigation infrastructure. Its implemented core is an offline Android application that records walking routes, saves named places and guides users along those recorded routes.

The submitted application uses shortest-path planning with confidence checks, position confirmation and off-route recovery. Learned risk-based route selection and other research extensions are planned modules.

## The problem. 

GPS is unreliable inside buildings. Students, visitors and other users may need to find rooms and return to familiar places without internet access, installed beacons or an existing digital map.

Phone-based movement estimates also accumulate error. Looking around can resemble a walking turn, and an estimated position may differ from the user's actual position. RAIN addresses these problems through confirmed turns, named-place checks, sign reading and explicit arrival confirmation.

## Implemented features

- Record a route while walking with the phone held in hand.
- Count steps from accelerometer input, with hardware step events supported on compatible phones.
- Detect turns using gyroscope rotation measured around gravity, avoiding an assumption that the phone must remain flat.
- Confirm a turn only after 2 steps in the new direction within 8 seconds, helping reject movements caused by looking around.
- Snap confirmed recording turns to 90° intervals.
- Mark named places and add aliases while recording.
- Draw a schematic floor map and close loops using **Finish at start**.
- Record multiple floors with stairs, lift or escalator connections and a manual **Change floor** action.
- Save several maps locally and choose, rename or delete them.
- Find marked destinations using exact names, fuzzy matching or saved aliases.
- Enter destinations by typing or using on-device speech recognition.
- Follow a large direction arrow, spoken instructions, turn vibration and a moving dot on the schematic map.
- Receive position checks such as “Are you at X?” as confidence decreases with walking.
- Detect departure from the planned route and provide recovery guidance.
- Confirm arrival through the application's arrival flow, including explicit confirmation when arrival is uncertain.
- Use **Scan a sign** to read a printed place name with on-device text recognition and set or correct position.
- Navigate offline without GPS, internet, beacons or an account. Recorded maps and navigation data remain on the phone.

The separate AI assistant module is switched off in the submitted build.

## How it works

**Record → Mark places → Navigate.**

Walk a route once while holding the phone. Mark the places you want to revisit and add aliases where useful. The application builds a graph of named places, junctions and corridors, using steps to represent corridor distance.

Confirmed turns establish corridor directions. A turn candidate is accepted only after 2 steps in the new direction within 8 seconds. Recorded turns are snapped to 90° intervals. Loops connect the recording to an existing place, and floor transitions are entered manually.

Later, choose a starting place and destination. The application matches the destination against the active map and selects a shortest route through the saved corridors.

Steps and confirmed turns update progress. The application displays an arrow and a moving map marker, speaks instructions and vibrates on turns.

Confidence falls as the user walks. The application can ask “Are you at X?” to check its estimate. A recognised sign or confirmed place provides a position reference. Off-route recovery helps the user return towards the path. When arrival is uncertain, the application asks for confirmation with “I'm here”; reaching the estimated distance alone does not establish a confirmed arrival.

## Tech stack

- **Flutter and Dart:** application screens, schematic map drawing, navigation logic and user interaction.
- **Kotlin:** native Android sensor channel supplying motion samples.
- **Accelerometer:** walking step detection.
- **Gyroscope and gravity information:** turn measurement around gravity.
- **Graph-based map and shortest-path planner:** places, corridors, loops and floor transitions.
- **On-device speech recognition:** spoken destination input.
- **Text-to-speech and vibration:** navigation instructions and turn feedback.
- **ML Kit text recognition:** optional camera-based sign reading.
- **Local JSON files:** saved maps and active-map selection.

Offline voice input requires a supported recognition service and an installed language pack.

## Install the APK

1. Open the repository's [Releases page](../../releases).
2. Download `IndoorNav-v1.0.apk` from “Testathon build v1.0” once it is published after merging to main.
3. Allow your browser or file manager to install unknown apps in Android Settings.
4. Open the downloaded file and install it. This build needs Android 11+ and an ARM64 phone.

## How to use it

1. Open RAIN: Risk-Aware Indoor Navigation and grant the requested permissions. Hold the phone in your hand.
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

The APK is at `build/app/outputs/flutter-apk/app-release.apk`.

Release builds use the repository's debug signing key for college testing. GitHub Actions runs analysis and tests before building; only pushes to main publish release files.

## Testing

The supplied measured results are:

- **9/9 hand-held turns detected with 0 false turns.**
- **30/30 steps counted on a straight walk.**
- **19–21 steps counted on 20-step walks.**
- **False turns from looking around reduced from 8 to 0 by turn confirmation.**

These results describe the measured walks and recorded traces. They do not establish performance for every phone, walking speed or building.

The repository contains automated unit and widget tests, including replay tests using real recorded walking traces. The supplied source inventory contains **600 automated test declarations across 75 Dart test and support files**. This is a source count, not an executed pass count.

Run:

```sh
flutter analyze
flutter test -j 1
```

Flutter was unavailable in the editing environment described in the supplied documents. CI must establish the passing result for this revision.

## Known limitations

- The phone must be held in hand.
- Fast walking undercounts steps by 10–15%.
- Floor change is a manual tap.
- Error builds up on long walks and is reduced by position confirmations.
- Offline voice input needs an installed speech language pack; typed input remains available.
- Navigation covers only routes already recorded. The temporary sample map is not a map of your building.
- Sign reading requires readable text that matches a place in the active map.
- An estimated position or distance does not independently verify physical arrival.

## Future scope

The following final-year project modules are planned and are not implemented features of the submitted APK:

- **Learned risk-based routing:** use measured navigation difficulty to compare routes beyond shortest-path distance.
- **Learned scan prompting:** decide when a sign check is useful using estimated uncertainty and route risk.
- **Visual place recognition and text-image fusion:** combine sign text with doorway appearance.
- **AR guidance:** display route guidance in the camera view.
- **Wi-Fi research and adaptive radio-map learning:** study optional wireless observations and map maintenance.
- **AI assistance:** enable an on-device assistant for natural-language requests after implementation and evaluation.
- **Research evaluation:** compare route-planning and confirmation strategies using collected data.

Additional proposed enhancements include pocket mode, automatic floor detection with a barometer, venue maps shared by QR code and a voice-first mode for visually impaired users.

## Team and guide

| Team member | USN |
|---|---|
| Mohammed Ifzal | 4MT23CI026 |
| Mohammed Saheel | 4MT23CI031 |
| Syed Musid | 4MT23CI055 |
| Talha Khan | 4MT23CI056 |

**Guide:** Dr. Farha Haneef

**College:** Mangalore Institute of Technology & Engineering

**Department:** CSE (AI & ML)

**Academic year:** 2026–27
