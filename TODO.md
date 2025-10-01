# TODO: Integrate Recording into GoLivePage Broadcast Start

## Steps to Complete
- [x] Add `path_provider` dependency to `pubspec.yaml` for file path handling.
- [x] Run `flutter pub get` to install new dependency.
- [x] Enhance `lib/services/agora_service.dart`:
  - Add methods for starting/stopping local video recording.
  - Add event handlers for recording events.
  - Configure engine for broadcaster role.
- [x] Update `lib/pages/golive_page.dart`:
  - Import necessary Agora classes and AgoraService.
  - Add state variables for RtcEngine, recording status, and file path.
  - Modify `_startBroadcast()` to initialize Agora, start RTMP, then start recording.
  - Modify `_stopBroadcast()` to stop recording and RTMP.
  - Update UI to show camera preview and recording indicator.
  - Handle permissions for camera, mic, and storage.
- [x] Test the implementation:
  - Run `flutter run` on Android device/emulator.
  - Start broadcast and verify recording starts (check device storage for MP4).
  - Stop broadcast and verify recording stops and file is saved.
  - Check UI for preview and indicators.
- [x] Handle edge cases: App dispose, errors, low storage, multi-platform support.
