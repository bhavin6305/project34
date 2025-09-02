// lib/pages/stream_player_page.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// same constants as before
const String APP_ID = 'YOUR_AGORA_APP_ID';
const String TOKEN_SERVER_URL = 'https://your-token-server.example.com/rtcToken';
const String? tempToken = null;

class StreamPlayerPage extends StatefulWidget {
  final String channelId;
  final String? streamerName;
  const StreamPlayerPage({super.key, required this.channelId, this.streamerName});

  @override
  State<StreamPlayerPage> createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  late final RtcEngine _engine;
  int? _remoteUid;

  Future<String?> _getToken(String channel) async {
    if (tempToken != null) return tempToken;
    try {
      final uri = Uri.parse('$TOKEN_SERVER_URL?channel=$channel&uid=0');
      final r = await http.get(uri);
      if (r.statusCode == 200) return jsonDecode(r.body)['token'];
    } catch (e) {
      debugPrint('token fetch error: $e');
    }
    return null;
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) {
        setState(() => _remoteUid = remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        setState(() => _remoteUid = null);
      },
      onTokenPrivilegeWillExpire: (connection, token) {
        // Optionally refresh token for audience as well
      },
    ));

    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();

    final token = await _getToken(widget.channelId);
    await _engine.joinChannel(
      token: '007eJxTYJDcGGNgI+QqaVnKuFBxtr5R38vMvOeWPR/vLjPy6k0rCldgMExLMjC1SE6xMDMxMkkzN7c0M7UwMzUyNjIxTUpLSjUI3bM1oyGQkWGJVAEzIwMEgvhsDCXlmSXJGQwMAILwHTU=',
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.streamerName ?? 'Live')),
      body: Center(
        child: _remoteUid != null
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: widget.channelId),
                ),
              )
            : const Text('Waiting for streamer to go live...'),
      ),
    );
  }
}
