import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class RecordingService {
  static CameraController? controller;
  static bool _isRecording = false;

  static Future<String> getRecordingFilePath(String uid) async {
    final directory = await getExternalStorageDirectory();
    return '${directory?.path}/stream_$uid.mp4';
  }

  static Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    controller = CameraController(camera, ResolutionPreset.high);
    await controller!.initialize();
  }

  static Future<void> startRecording(String filePath) async {
    if (controller == null) {
      await initializeCamera();
    }
    await controller!.startVideoRecording();
    _isRecording = true;
  }

  static Future<XFile?> stopRecording() async {
    if (controller != null && _isRecording) {
      final file = await controller!.stopVideoRecording();
      _isRecording = false;
      return file;
    }
    return null;
  }

  static Future<void> dispose() async {
    if (controller != null) {
      await controller!.dispose();
      controller = null;
    }
  }
}
