import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static const String appId = "8c07ef08bc194dddb75f0ab1c48e3ba1";

  static Future<RtcEngine> createEngine() async {
    final engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));
    return engine;
  }
}
