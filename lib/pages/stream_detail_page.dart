import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamDetailPage extends StatefulWidget {
  final String streamerName;
  final String streamTitle;
  final String category;
  final String viewers;
  final String thumbnail;

  const StreamDetailPage({
    super.key,
    required this.streamerName,
    required this.streamTitle,
    required this.category,
    required this.viewers,
     required this.thumbnail,

  });

  @override
  State<StreamDetailPage> createState() => _StreamDetailPageState();
}

class _StreamDetailPageState extends State<StreamDetailPage> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"user": "CoolGamer123", "msg": "This stream is fire 🔥"},
    {"user": "NoobMaster", "msg": "lol gg"},
    {"user": "Viewer88", "msg": "Sub goal reached!"},
    {"user": "ProPlayer", "msg": "Clutch incoming 💪"},
  ];

  // Mock viewer list
  final List<String> _viewers = [
    "CoolGamer123",
    "NoobMaster",
    "Viewer88",
    "ProPlayer",
    "StreamFan01",
    "Lurker99",
    "TryHard",
  ];

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "user": "You",
        "msg": _chatController.text.trim(),
      });
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Stream Details",
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              // Open right-side drawer for viewers
              Scaffold.of(context).openEndDrawer();
            },
          )
        ],
      ),

      endDrawer: Drawer(
        backgroundColor: const Color(0xFF18181B),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              "Viewers",
              style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: _viewers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      _viewers[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // 🎥 Video Player Placeholder
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: const [
                      Icon(Icons.play_arrow, color: Colors.white),
                      SizedBox(width: 12),
                      Icon(Icons.volume_up, color: Colors.white),
                      SizedBox(width: 12),
                      Icon(Icons.fullscreen, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 📌 Stream Info Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 12),

                // Stream details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.streamTitle,
                        style: GoogleFonts.rajdhani(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${widget.streamerName} • ${widget.category}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.viewers} viewers",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text("Follow"),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // 💬 Chat Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF18181B),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _chatBubble(msg["user"]!, msg["msg"]!),
                  );
                },
              ),
            ),
          ),

          // Chat input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF0E0E10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message",
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🎤 Custom Chat Bubble
  Widget _chatBubble(String user, String message) {
    return Padding(
      key: ValueKey(user + message),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: [
            TextSpan(
              text: "$user: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF9146FF),
              ),
            ),
            TextSpan(text: message),
          ],
        ),
      ),
    );
  }
}
