import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            "FluxLive",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white, // masked by shader
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
             onPressed: () {
  Navigator.pushNamed(context, '/search');
},

          ),
          IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Colors.white, size: 26),
             onPressed: () {
      Navigator.pushNamed(context, '/notifications'); // 🔔 opens NotificationsPage
    },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          // Categories Row
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategory("Gaming", Icons.videogame_asset),
                  _buildCategory("Music", Icons.music_note),
                  _buildCategory("IRL", Icons.people),
                  _buildCategory("Coding", Icons.code),
                  _buildCategory("Sports", Icons.sports_esports),
                ],
              ),
            ),
          ),

          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Live Now",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ),
          ),

          // Live Streams Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildStreamCard(
                    thumbnail: "https://picsum.photos/400/200?random=$index",
                    title: "Epic Gameplay #$index",
                    streamer: "Streamer$index",
                    viewers: "${(1000 + index * 231)} watching",
                  );
                },
                childCount: 6, // dummy streams
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category Chip
  Widget _buildCategory(String name, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9146FF).withOpacity(0.6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF9146FF), size: 28),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Stream Card
  Widget _buildStreamCard({
    required String thumbnail,
    required String title,
    required String streamer,
    required String viewers,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Image.network(thumbnail, fit: BoxFit.cover, height: 120, width: double.infinity),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Stream info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(streamer,
                            style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.visibility, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(viewers,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
