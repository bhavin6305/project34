import 'package:flutter/material.dart';

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final liveStreams = [
      {
        "streamer": "GamerX",
        "title": "Ranked Grind 🔥",
        "viewers": "12.5K",
        "category": "Valorant",
        "thumbnail": "https://picsum.photos/400/200?1"
      },
      {
        "streamer": "DJMix",
        "title": "Live Music Beats 🎶",
        "viewers": "8.9K",
        "category": "Music",
        "thumbnail": "https://picsum.photos/400/200?2"
      },
      {
        "streamer": "ChefPro",
        "title": "Street Food Special 🍜",
        "viewers": "4.3K",
        "category": "Cooking",
        "thumbnail": "https://picsum.photos/400/200?3"
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF9146FF), Colors.blueAccent],
          ).createShader(bounds),
          child: const Text(
            "Live Streams",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: liveStreams.length,
        itemBuilder: (context, index) {
          final stream = liveStreams[index];
          return _buildLiveCard(
            streamer: stream["streamer"]!,
            title: stream["title"]!,
            viewers: stream["viewers"]!,
            category: stream["category"]!,
            thumbnail: stream["thumbnail"]!,
          );
        },
      ),
    );
  }

  Widget _buildLiveCard({
    required String streamer,
    required String title,
    required String viewers,
    required String category,
    required String thumbnail,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  thumbnail,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // LIVE badge
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "LIVE",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
              // Viewers badge
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: [
                    const Icon(Icons.visibility,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      viewers,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Category chip
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),

          // Stream Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    streamer[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        streamer,
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
