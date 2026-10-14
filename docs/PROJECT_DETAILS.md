# Project details

**Project title:** <FILL>

**Temporary app name:** IndoorNav

**Team members and USNs:** <FILL>

**Guide:** <FILL>

**College:** Mangalore Institute of Technology & Engineering

**Department:** CSE (AI & ML)

**Academic year:** 2026–27

## Abstract (draft)

Indoor navigation is difficult where satellite positioning is unreliable and network access is unavailable. This project develops an Android application that records a walking route using phone motion sensors and guides users back to marked places. Accelerometer samples support step counting, while gyroscope rotation measured around gravity identifies turns. Confirmed turns and step distances form a graph of places and corridors. Users name locations, save maps locally, and select destinations through text, speech, or sign reading. A shortest path planner and position tracker provide arrow guidance, spoken instructions, and vibration. Confidence checks, position confirmations, and off route recovery reduce the impact of accumulated error. The system operates without GPS, internet, beacons, or building infrastructure, supporting navigation along previously recorded routes.

## 1 Introduction

People often lose their way inside unfamiliar buildings. Satellite positioning does not reliably distinguish indoor corridors or rooms. IndoorNav lets a person record a route once and return to named places using only their Android phone. It is a final year project intended for practical college evaluation.

## 2 Problem statement

Provide offline guidance to previously marked indoor places without GPS, internet, installed beacons or a venue mapping service. Phone movement is noisy and distance estimates drift, so the system must communicate uncertainty and let the user confirm position.

## 3 Objectives

- Record walking routes using step and turn events.
- Build and store a graph of named places and corridors.
- Plan a shortest route between reachable places.
- Guide the walker using an arrow, speech and vibration.
- Reduce misleading guidance through turn confirmation, confidence checks and recovery.
- Support saved maps, manual floor changes and optional sign reading.

## 4 Scope

The application navigates along routes that a person has already walked and recorded. It supports loops, multiple floors and several locally saved maps. This release uses exact, fuzzy and alias matching for destination search. It does not infer unrecorded corridors or absolute geographic coordinates. The phone is held in the hand, and floor changes require a manual confirmation.

## 5 Existing systems and their limits

GPS signals weaken indoors and do not reliably locate a user in a particular room. Wi-Fi fingerprinting needs reference measurements and maintenance when the wireless environment changes. BLE beacons need installation, power and upkeep. Venue indoor maps depend on available floor plans and do not by themselves track a walker's position. These approaches can be useful, but have requirements outside this project's infrastructure-free scope.

## 6 Proposed system

The user walks a route, marks places and saves the resulting map. Sensors produce steps and turn candidates; confirmation filters handling movements. Later a selected destination is matched against known places. A route planner chooses connected corridors, and a tracker estimates progress. The guide provides directions and asks for confirmation when needed. All map data remains on the phone.

## 7 System architecture

```text
Record:   sensors → sense → confirm turn → map builder
                                              ↓
Storage:                            saved maps on the phone
                                              ↓
Navigate: chosen place → route planner → tracker → guide
                                                    ↓
                                          arrow / voice / vibration
```

## 8 Modules

### Sensing

A native Kotlin channel streams Android sensor information to Dart.
Accelerometer input supports step detection; hardware step events are also supported.
Gyroscope rotation is projected around gravity to measure walking turns.

### Turn confirmation

A turn candidate needs two following steps within eight seconds.
Candidates caused by handling or looking around can be rejected.
Confirmed recording turns are snapped to cardinal directions at 90° intervals.

### Map builder with loops and floors

Named places and unnamed junctions become graph nodes.
Corridors store step distance and heading, with optional floor transitions.
Joining an existing place closes a loop; display correction improves the drawing without changing measured route distances.

### Route planner

The planner searches the saved graph for a shortest path.
Corridor steps form its distance cost, with an extra cost for floor transitions.
It returns ordered route legs for the tracker and guide.

### Tracker and confidence

Steps and confirmed turns update progress along the planned route.
Confidence decreases with walking and improves at confirmed positions or corners.
The guide can ask “Are you at X?” when confidence falls.

### Guide and off-route recovery

The guide converts route progress into straight, turn and floor instructions.
An unexpected turn triggers recovery instructions towards the path.
Uncertain arrival asks the user to confirm rather than claiming a known position.

### Voice input and spoken output

On-device speech recognition converts a spoken destination to text.
The same PlaceMatcher checks text against place names and saved aliases.
Text-to-speech speaks guidance; offline recognition needs a language pack on the phone.

### Sign reading

The optional camera screen uses ML Kit text recognition to read a sign.
Recognised text is checked against places in the active map.
A match can identify the starting place or anchor navigation to a known place.

### Storage and saved maps

Maps are stored as JSON files in the phone's application storage.
The library keeps multiple recordings and remembers the active map.
Users can choose, rename or delete maps, with confirmation before deletion.

## 9 Hardware and software requirements

An ARM64 Android phone with an accelerometer and gyroscope is required. The actual configured minimum SDK is API 30, which means Android 11 or newer. Offline speech input also requires a supported recognition service and installed language pack. Camera permission is optional for sign reading.

Development requires Flutter, Dart, Kotlin and the Android SDK. The CI workflow uses Java 17 and Flutter 3.47.7 on the stable channel. A computer is needed for source editing; GitHub Actions builds the installable release APK.

## 10 Implementation summary

Flutter handles screens, map drawing and interaction. Pure Dart implements sensing logic, turn confirmation, graph building, matching, route planning, tracking and guidance. Kotlin connects Android sensors to Flutter through the existing channels. Speech, text-to-speech, vibration and ML Kit connect optional phone capabilities to the navigation flow.

The application ID is `com.fyp.indoornav`, allowing installation beside the original app. Release signing uses the existing debug key without secrets. GitHub Actions analyzes and tests the code before building. On a push to main it publishes the APK, README and this report as release assets; Word conversion is optional if pandoc installation or conversion fails.

## 11 Testing and results

Measured walking results supplied for this report are:

- 9 out of 9 hand-held turns detected, with 0 false turns.
- 30 out of 30 steps counted on a straight walk.
- 19–21 steps counted on 20-step walks.
- False turns from looking around reduced from 8 to 0 by turn confirmation on test traces.

These observations describe the measured walks and traces, not a guarantee for every phone or building. The repository includes unit and widget tests and replay tests using recorded walking traces. The automated test declaration count is recorded below; parameterised declarations can generate additional cases at runtime. Flutter is unavailable in the editing environment, so these declarations were counted from source and this revision has not yet been executed locally. CI runs `flutter analyze` and `flutter test -j 1` before producing the APK.

The current repository contains **600 automated test declarations** across 75 Dart test and support files. This is a source count, not an executed pass count.

## 12 Limitations

The phone must be held in hand. Fast walking can undercount steps by 10–15%. Distance and heading error accumulate on long walks; recognised-place confirmations reduce this drift. Floor changes are manual taps. Only recorded connected routes are available. Offline speech depends on installed language packs. Sign reading depends on readable text that matches a known place. Arrival confirmation is required when progress does not satisfy the arrival guard.

## 13 Future enhancements

An on-device AI assistant could interpret natural-language requests. Other future work includes pocket mode, automatic floor detection using a barometer, venue maps shared through QR codes, and a voice-first mode for visually impaired users. These are proposed enhancements rather than claims about the current release.

## 14 Conclusion

IndoorNav demonstrates navigation along user-recorded indoor routes without positioning infrastructure. A local graph, step and turn tracking, and multimodal guidance provide a practical route-following workflow. Confirmation and recovery make uncertainty visible, while saved maps let users reuse their recordings. Further phone and walking evaluations are needed to establish performance across different conditions.

## References

- Flutter documentation
- Android Developers: Sensors overview
- Android Developers: Motion sensors
