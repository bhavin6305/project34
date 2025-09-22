import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StreamPlayerPage extends StatefulWidget {
  final String streamId;
  final String hlsUrl; // Example: http://<your-ip>:8080/hls/<uid>.m3u8
  final String title;
  final String streamerName;

  const StreamPlayerPage({
    super.key,
    required this.streamId,
    required this.hlsUrl,
    required this.title,
    required this.streamerName,
  });

  @override
  State<StreamPlayerPage> createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.hlsUrl))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
          Expanded(
            child: Center(
              child: Text(
                "Chat coming soon...",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        ],
      ),
    );
  }
}
