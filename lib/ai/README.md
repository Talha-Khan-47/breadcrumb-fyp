# Destination matching and speech

The FYP build disables the retained language-model implementation through enableOnDeviceAi in lib/core/tuning.dart.
PlaceMatcher resolves exact names, fuzzy names and saved aliases. On-device speech input remains available independently.
