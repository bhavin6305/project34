// lib/pages/golive_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// TODO: move these into secure storage / environment
const String APP_ID = 'YOUR_AGORA_APP_ID';
const String TOKEN_SERVER_URL = 'https://your-token-server.example.com/rtcToken'; // ?channel=&uid=
const String? tempToken = null; // for quick dev - paste a console temp token here

class GoLivePage extends StatefulWidget {
  const GoLivePage({super.key});
  @override
  State<GoLivePage> createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  late final RtcEngine _engine;
  bool _localJoined = false;
  bool _isBroadcasting = false;
  bool _muted = false;
  bool _videoMuted = false;
  final TextEditingController _channelCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _channelCtl.text = 'stream-${Random().nextInt(9999)}';
  }

  Future<String?> _getToken(String channel, int uid) async {
    if (tempToken != null) return tempToken;
    try {
      final uri = Uri.parse('$TOKEN_SERVER_URL?channel=$channel&uid=$uid');
      final r = await http.get(uri);
      if (r.statusCode == 200) {
        final json = jsonDecode(r.body);
        return json['token'] as String?;
      }
    } catch (e) {
      debugPrint('token fetch error: $e');
    }
    return null;
  }

  Future<void> _startBroadcast() async {
    final channel = _channelCtl.text.trim();
    if (channel.isEmpty) return;

    // request permissions
    await [Permission.camera, Permission.microphone].request();

    // create engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: '1fb058cd86424f7796586523245bfbe0',
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _localJoined = true);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint('remote user $remoteUid joined (viewer side)');
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint('remote user $remoteUid left');
        },
        onTokenPrivilegeWillExpire: (connection, token) async {
          // fetch new token
          final newToken = await _getToken(channel, 0);
          if (newToken != null) {
            await _engine.renewToken(newToken);
          }
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    final token = await _getToken(channel, 0); // 0 => let Agora assign uid
    await _engine.joinChannel(
      token: '007eJxTYJDcGGNgI+QqaVnKuFBxtr5R38vMvOeWPR/vLjPy6k0rCldgMExLMjC1SE6xMDMxMkkzN7c0M7UwMzUyNjIxTUpLSjUI3bM1oyGQkWGJVAEzIwMEgvhsDCXlmSXJGQwMAILwHTU=',
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    setState(() => _isBroadcasting = true);
  }

  Future<void> _stopBroadcast() async {
    await _engine.stopPreview();
    await _engine.leaveChannel();
    await _engine.release();
    setState(() {
      _isBroadcasting = false;
      _localJoined = false;
    });
  }

  @override
  void dispose() {
    if (_isBroadcasting) {
      _stopBroadcast();
    }
    _channelCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Live')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _channelCtl,
              decoration: const InputDecoration(labelText: 'Channel name'),
            ),
            const SizedBox(height: 12),
            if (!_isBroadcasting)
              ElevatedButton(
                onPressed: _startBroadcast,
                child: const Text('Start Broadcast'),
              )
            else
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: _localJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(_muted ? Icons.mic_off : Icons.mic),
                        onPressed: () async {
                          _muted = !_muted;
                          await _engine.muteLocalAudioStream(_muted);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(_videoMuted ? Icons.videocam_off : Icons.videocam),
                        onPressed: () async {
                          _videoMuted = !_videoMuted;
                          await _engine.muteLocalVideoStream(_videoMuted);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cameraswitch),
                        onPressed: () => _engine.switchCamera(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop_circle_outlined),
                        onPressed: _stopBroadcast,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
