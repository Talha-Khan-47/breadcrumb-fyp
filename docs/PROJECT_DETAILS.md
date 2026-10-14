# RAIN: Risk-Aware Indoor Navigation

**Final-Year Project — Implemented Navigation Core**

| Field | Details |
|---|---|
| Project title | RAIN: Risk-Aware Indoor Navigation |
| College | Mangalore Institute of Technology & Engineering |
| Department | CSE (AI & ML) |
| Academic year | 2026–27 |
| Guide | Dr. Farha Haneef |

| Team member | USN |
|---|---|
| Mohammed Ifzal | 4MT23CI026 |
| Mohammed Saheel | 4MT23CI031 |
| Syed Musid | 4MT23CI055 |
| Talha Khan | 4MT23CI056 |

## Abstract

RAIN: Risk-Aware Indoor Navigation addresses indoor wayfinding in buildings where satellite positioning is unreliable and navigation infrastructure is unavailable. The implemented core is an offline Android application that records routes while a user walks with the phone in hand. Accelerometer input detects steps, and gyroscope rotation measured around gravity identifies turn candidates. A turn is confirmed after 2 steps in the new direction within 8 seconds, and recorded turns are snapped to 90°. Named places and corridors form a locally stored graph that supports loops, multiple maps and manually confirmed floor changes. Users select destinations by typing or speaking a name, with exact, fuzzy and alias matching. A shortest-path planner provides guidance through an arrow, spoken instructions, vibration and a moving position marker. Confidence checks, sign reading, off-route recovery and arrival confirmation help manage accumulated tracking error. Flutter and Dart implement the application and navigation logic, while Kotlin supplies Android sensor information. Learned risk-based routing, visual recognition fusion and advanced AI assistance remain planned extensions beyond the submitted navigation core.

## 1. Introduction

Finding rooms and other indoor destinations can be difficult for students, visitors and people unfamiliar with a building. GPS does not reliably identify indoor rooms and corridors. Buildings may also lack installed navigation equipment or a usable digital floor map.

RAIN investigates navigation using a person's Android phone and locally available information. The implemented application lets a user record a walking route, mark useful places and later follow guidance to those places.

The broader project aims to improve the reliability of indoor guidance. The submitted core addresses uncertainty through turn confirmation, confidence checks, sign-based position correction and recovery instructions. Its implemented route planner selects a shortest path. Learned risk-based route selection remains planned work.

## 2. Problem statement

Develop an Android application that guides users to previously marked indoor places without relying on GPS, internet connectivity, installed beacons, an account or a venue mapping service.

The application must account for noisy phone movement and accumulated tracking error. It must distinguish walking turns from movements caused by looking around, communicate uncertainty, support position correction and request arrival confirmation when necessary.

## 3. Objectives

The objectives addressed by the implemented core are to:

- Record walking routes from step and turn events while the phone is held in hand.
- Confirm turn candidates using subsequent walking steps.
- Build and store a graph of named places, junctions and corridors.
- Support recorded loops, multiple saved maps and manual floor transitions.
- Find places using exact names, fuzzy matching and aliases.
- Select a shortest path between reachable places.
- Provide arrow guidance, spoken instructions, vibration and a moving map marker.
- Support typed and spoken destination input.
- Read printed signs to identify or correct the user's position.
- Manage uncertainty through confidence checks, off-route recovery and arrival confirmation.
- Store map and navigation data locally and operate offline.

The longer-term research objective is to extend this core with learned route-risk estimation and selective position checks. Those extensions are outside the implemented scope of the submitted APK.

## 4. Scope

### 4.1 Implemented scope

The application navigates along routes that a person has already walked and recorded. It supports named places, aliases, loops and several maps stored on the phone.

Recorded routes can span multiple floors using stairs, lift or escalator connections. The user records or confirms a floor change manually.

Destination selection supports typing, on-device speech recognition and selection from known places. Camera-based sign reading can identify a starting place or correct position against the active map.

The phone is held in the hand during recording and navigation. Guidance is based on the saved route graph and estimated movement along it.

### 4.2 Planned scope

Learned risk-based planning, learned scan prompting, visual doorway recognition, text-image fusion, AR guidance, Wi-Fi research and adaptive radio-map learning are planned project extensions.

The separate AI assistant module is switched off in the submitted build. These planned modules are not part of the APK's demonstrated feature set.

## 5. Existing systems and their limits

GPS is useful for outdoor positioning but does not reliably identify a user's room or corridor inside a building.

Wi-Fi fingerprinting requires reference measurements and maintenance when the wireless environment changes. BLE beacon systems require installed devices, power and upkeep. Venue map systems depend on available map information, and a floor plan alone does not track the user's movement.

These approaches can support indoor navigation where their required infrastructure and data are available. RAIN's implemented core instead uses routes recorded on the phone, motion sensing and user-confirmed place information.

## 6. Proposed system

The user records a route while walking with the phone in hand. Motion input produces step events and turn candidates. A turn is accepted only after subsequent steps confirm movement in the new direction.

The user marks places with names and optional aliases. These places, junctions and corridors form a graph stored locally. Loop closure joins a recording to an existing place. Floor transitions are recorded manually.

During navigation, the user selects a starting place and destination. The destination is matched against places in the active map, and the planner selects a shortest path.

The tracker estimates progress using steps and confirmed turns. The guide presents an arrow, spoken instructions, vibration and a moving marker. Confidence checks, sign reading and explicit confirmations provide opportunities to correct the estimated position. Off-route recovery helps the user return towards the saved path.

## 7. System architecture

```text
RECORDING
Android motion sensors
          |
          v
Native Kotlin sensor channel
          |
          v
Dart step detection and gravity-referenced turn detection
          |
          v
Turn confirmation: 2 steps within 8 seconds
          |
          v
Map builder <--- Named places, aliases, loops and manual floor changes
          |
          v
Local saved-map library: JSON graph files
          |
          v
NAVIGATION
Selected start + destination
          ^
          |
Typed name / on-device speech / recognised sign text
          |
          v
Exact, fuzzy and alias matching
          |
          v
Shortest-path route planner
          |
          v
Progress tracker <--- Steps, confirmed turns and manual floor confirmation
          |
          +<--- Position confirmation and sign-based position correction
          |
          v
Confidence checks and off-route recovery
          |
          v
Guide: arrow / speech / vibration / moving map marker
          |
          v
Arrival confirmation
```

The implemented architecture operates on the phone. Planned AI, AR and wireless research modules are outside this submission architecture.

## 8. Modules

### 8.1 Motion sensing

A native Kotlin channel supplies Android sensor information to Dart.

Accelerometer input supports walking step detection. Compatible phones can also provide hardware step events.

Gyroscope rotation is measured around gravity to identify turns without requiring the phone to remain flat. This supports the hand-held recording and navigation workflow.

### 8.2 Turn confirmation

A turn candidate requires 2 steps in the new direction within 8 seconds.

This confirmation helps reject turns caused by looking around or handling the phone without continuing to walk in that direction. Confirmed recording turns are snapped to 90° intervals.

### 8.3 Map builder, loops and floors

Named places and unnamed junctions become graph nodes. Corridors store step distance and direction.

Users mark places while walking and can add aliases. **Finish at start** supports closing a recorded loop. Joining an existing place connects the route graph. Display correction improves the schematic drawing without changing measured route distances.

The map supports stairs, lift and escalator connections between floors. Floor changes use the manual **Change floor** action or a requested confirmation.

### 8.4 Place matching and route planning

The application matches a destination using exact names, fuzzy matching or saved aliases.

The planner searches the active graph for a shortest path between reachable places. Corridor steps form the distance cost, with an additional cost for floor transitions. The result is an ordered sequence of route legs for tracking and guidance.

Learned risk-based route selection is a planned extension.

### 8.5 Position tracking and confidence

Steps and confirmed turns update progress along the planned route. A moving dot shows the estimated position on the schematic map.

Confidence decreases with walking and improves at confirmed positions or corners. The application can ask “Are you at X?” when a position check is needed.

A confidence value represents the application's estimate. It is not an independently measured position.

### 8.6 Guidance, recovery and arrival

The guide converts route progress into straight-ahead, turn and floor-change instructions.

Guidance is presented through a large arrow, spoken instructions and vibration on turns. An unexpected turn can trigger off-route recovery instructions towards the planned path.

Arrival uses the application's confirmation flow. When arrival is uncertain, the user is asked to confirm rather than relying only on estimated travel distance.

### 8.7 Voice input and spoken output

On-device speech recognition converts a spoken destination to text. The place matcher checks that text against names and aliases in the active map.

Text-to-speech provides spoken directions. Offline voice input requires a supported recognition service and an installed language pack. Typed destination input remains available.

### 8.8 Sign reading

The optional camera screen uses ML Kit text recognition to read a printed sign.

Recognised text is matched against known places in the active map. A match can identify the starting place or provide a position reference during navigation.

Sign reading requires readable text associated with a known place.

### 8.9 Local storage and saved maps

Maps are stored as JSON files in the phone's application storage.

The saved-map library supports multiple recordings and remembers the active map. Users can choose, rename or delete maps, with confirmation before deletion.

Recorded map and navigation data remain on the phone.

### 8.10 Planned modules

The following modules belong to the broader final-year project and are not implemented features of the submitted APK:

- Learned route-risk estimation and risk-based route selection.
- Learned or cost-sensitive scan prompting.
- Doorway appearance recognition and fusion with sign text.
- AR route guidance.
- Optional Wi-Fi studies and adaptive radio-map learning.
- AI assistance for natural-language requests.
- Comparative research evaluation of planning and confirmation strategies.

## 9. Hardware and software requirements

### 9.1 Hardware

- An ARM64 Android phone.
- An accelerometer and gyroscope.
- A camera for optional sign reading.
- Audio output for spoken instructions and vibration support for haptic guidance.
- A computer for source editing and development.

The phone must be held in hand during the supported walking workflow.

### 9.2 Software

- Android 11 or newer, corresponding to minimum SDK API 30.
- Flutter and Dart for application development.
- Kotlin and the Android SDK for native sensor integration.
- ML Kit text recognition for sign reading.
- A supported on-device speech recognition service and installed language pack for offline voice input.
- Text-to-speech support for spoken guidance.

The supplied CI configuration uses Java 17 and Flutter 3.47.7 on the stable channel. GitHub Actions performs analysis, testing and APK building.

Camera permission is optional for sign reading. The navigation workflow requires no GPS, internet connection, beacons or account.

## 10. Implementation summary

Flutter provides the screens, schematic map and user interaction. Dart implements step and turn processing, turn confirmation, graph building, place matching, route planning, tracking and guidance.

Kotlin connects Android sensor information to Flutter through native channels. Speech recognition, text-to-speech, vibration and ML Kit connect the relevant phone capabilities to the navigation workflow.

Maps are stored as local JSON files. Corridor distances are represented in steps, and floor changes are entered or confirmed manually.

The application ID is `com.fyp.indoornav`. The submitted APK filename is `IndoorNav-v1.0.apk`.

Release builds use the repository's debug signing key for college testing. GitHub Actions runs analysis and tests before building. Pushes to main publish the APK, README and project report as release assets. Word conversion is optional when its installation or conversion step is unavailable.

The separate AI assistant module is switched off in this submission. Learned planning, visual recognition fusion and AR guidance remain planned extensions.

## 11. Testing and results

### 11.1 Measured walking results

The measured results supplied for this report are:

| Test | Reported result |
|---|---|
| Hand-held turn detection | 9/9 hand-held turns detected with 0 false turns |
| Straight walking step count | 30/30 steps counted on a straight walk |
| Repeated 20-step walks | 19–21 steps counted on 20-step walks |
| Looking-around movements | False turns reduced from 8 to 0 by turn confirmation |

These observations describe the measured walks and recorded traces. They do not establish a general accuracy percentage or guarantee performance across all phones, users, buildings or walking conditions.

### 11.2 Automated testing

The repository contains unit tests, widget tests and replay tests using real recorded walking traces.

The supplied source inventory contains **600 automated test declarations across 75 Dart test and support files**. This is a source count, not an executed pass count. Parameterised declarations can generate additional cases at runtime.

The analysis and test commands are:

```sh
flutter analyze
flutter test -j 1
```

Flutter was unavailable in the editing environment described in the supplied documents. An executed passing result for this revision must therefore be established by CI.

The measured walking observations and the automated source inventory are reported separately. No additional pass count or user-study result is claimed.

## 12. Limitations

- The supported workflow requires the phone to be held in hand.
- Fast walking undercounts steps by 10–15%.
- Floor changes require a manual tap or confirmation.
- Distance and direction error accumulate on long walks. Position confirmations help reduce this drift.
- Navigation is limited to previously recorded, connected routes.
- The temporary sample map does not represent the user's building.
- Offline speech input depends on a supported recognition service and installed language packs.
- Sign reading depends on readable text that matches a known place.
- Estimated progress does not independently verify the user's physical location or arrival.
- Planned research modules are not available in the submitted APK.

## 13. Future enhancements

### 13.1 Planned final-year project extensions

**Learned risk-based routing:** collect navigation observations and use them to estimate difficult route segments or junctions. Compare route choices against the implemented shortest-path planner.

**Selective scan prompting:** investigate when a sign check is useful, considering accumulated uncertainty and the availability of a recognisable place.

**Visual recognition fusion:** combine sign text with doorway appearance to support cases where one source is insufficient.

**AR guidance:** add camera-view route instructions and evaluate their alignment and walking behaviour.

**Wi-Fi research and adaptive radio-map learning:** investigate optional wireless observations, environmental change and map maintenance as separate research extensions.

**AI assistance:** enable an on-device assistant for natural-language requests after implementation and evaluation.

**Research evaluation:** compare route planning, confirmation and recovery strategies using collected navigation data.

### 13.2 Additional usability enhancements

- Pocket-mode operation.
- Automatic floor detection using a barometer.
- Venue-map sharing through QR codes.
- A voice-first mode for visually impaired users.

These enhancements require implementation and testing before they can be reported as working features.

## 14. Conclusion

RAIN's implemented core provides offline navigation along user-recorded indoor routes. Step and turn processing builds a local graph, while place matching and shortest-path planning support navigation to marked destinations.

Arrow guidance, speech, vibration and a moving map marker communicate progress. Turn confirmation rejects handling-related turn candidates, while confidence checks, sign reading, recovery and arrival confirmation help users manage uncertain position estimates.

The supplied walking results describe the tested observations, and the automated test suite supports further verification. Learned risk routing and other research extensions remain planned work. Further evaluations are needed to establish performance across different phones, buildings and walking conditions.

## References

- Flutter documentation.
- Android Developers: Sensors overview.
- Android Developers: Motion sensors.
