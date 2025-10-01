// lib/pages/golive_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:twitch/services/agora_service.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({super.key});

  @override
  State<GoLivePage> createState() => _GoLivePageState();
}

class _GoLivePageState extends State<GoLivePage> {
  static const platform = MethodChannel('com.yourapp.rtmp/control');
  final TextEditingController _titleController = TextEditingController();
  bool _isStreaming = false;
  bool _isRecording = false;

  // Change this to your local server IP (from ipconfig)
  static const String serverIp = "172.16.0.148";

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startBroadcast() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required')),
      );
      return;
    }

    final uid = user.uid;
    final title = _titleController.text.trim();

    // RTMP for publishing
    final rtmpUrl = "rtmp://$serverIp:1935/live/$uid";
    // HLS for playback
    final hlsUrl = "http://$serverIp:8080/hls/$uid.m3u8";

    // Save metadata to Firestore (store both RTMP + HLS)
    await FirebaseFirestore.instance.collection('streams').doc(uid).set({
      'channelId': uid,
      'title': title.isEmpty ? 'Untitled Stream' : title,
      'rtmpUrl': rtmpUrl,
      'hlsUrl': hlsUrl,
      'streamerId': uid,
      'streamerName': user.displayName ?? 'Anonymous',
      'createdAt': FieldValue.serverTimestamp(),
      'isLive': true,
    });

    try {
      final res = await platform.invokeMethod('startStream', {
        'rtmpUrl': rtmpUrl,
        'streamTitle': title,
      });
      if (res == 'ok') {
        setState(() => _isStreaming = true);
        // Request permissions and start recording
        await _requestPermissions();
        final filePath = await RecordingService.getRecordingFilePath(uid);
        await RecordingService.startRecording(filePath);
        setState(() => _isRecording = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Native startStream result: $res')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Start failed: ${e.message}')),
      );
    }
  }

  Future<void> _stopBroadcast() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    try {
      final res = await platform.invokeMethod('stopStream');
      if (res == 'ok') {
        // Stop recording
        await RecordingService.stopRecording();
        setState(() => _isRecording = false);
        // update Firestore
        await FirebaseFirestore.instance.collection('streams').doc(uid).update({
          'isLive': false,
        });
        setState(() => _isStreaming = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Native stopStream result: $res')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stop failed: ${e.message}')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    RecordingService.dispose();
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Stream title'),
            ),
            const SizedBox(height: 12),
            _isStreaming
                ? Column(
                    children: [
                      const Text('You are live!'),
                      if (_isRecording) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            SizedBox(width: 4),
                            Text('Recording...'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _stopBroadcast,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop Broadcast'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  )
                : ElevatedButton.icon(
                    onPressed: _startBroadcast,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Start Broadcast'),
                  ),
          ],
        ),
      ),
    );
  }
}
