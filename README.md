# ASL-to-Text Flutter Prototype

This project is a Flutter prototype for real-time ASL-to-text translation.

## Current Features
- Live camera feed using Flutter Camera
- Real-time frame streaming
- On-screen text overlay
- Sentence buffer for ASL output
- Clean architecture ready for ML integration

## Planned ML Pipeline (Future Work)
1. Hand landmark detection (MediaPipe / ML Kit)
2. Landmark normalization and feature extraction
3. ASL classification using a trained ML model
4. Temporal smoothing to form words and sentences

## Notes
- Full ASL sentence recognition requires facial expressions, body posture,
  and temporal context, which are outside the scope of this prototype.
- This repository focuses on building the camera + processing pipeline first.

## Tech Stack
- Flutter (Dart)
- Android Emulator
- CameraX
