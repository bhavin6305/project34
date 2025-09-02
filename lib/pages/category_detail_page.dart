import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'stream_detail_page.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Fake data for now
    final List<Map<String, String>> streams = [
      {
        "title": "Insane Ranked Grind!",
        "streamer": "ProPlayer123",
        "viewers": "12.4K",
        "thumbnail":
            "https://placehold.co/600x400/9146FF/FFF?text=Valorant+Stream",
      },
      {
        "title": "Chill Vibes, Music + Chat",
        "streamer": "LoFiQueen",
        "viewers": "8.1K",
        "thumbnail":
            "https://placehold.co/600x400/FF0000/FFF?text=Just+Chatting",
      },
      {
        "title": "Speedrunning Dark Souls 🔥",
        "streamer": "SpeedRunGod",
        "viewers": "5.6K",
        "thumbnail":
            "https://placehold.co/600x400/00FF00/000?text=Dark+Souls",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryName,
          style: GoogleFonts.rajdhani(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // two cards per row
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => StreamDetailPage(
                    streamerName: stream["streamer"]!,
                    streamTitle: stream["title"]!,
                    category: categoryName,
                    viewers: stream["viewers"]!,
                    thumbnail: stream["thumbnail"]!,
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.grey[900],
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail with shimmer + hero animation
                  Expanded(
                    child: Stack(
                      children: [
                        Hero(
                          tag: "thumbnail_${stream["title"]}",
                          child: Image.network(
                            stream["thumbnail"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[800]!,
                                highlightColor: Colors.grey[600]!,
                                child: Container(
                                  color: Colors.grey[900],
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.visibility,
                                    size: 14, color: Colors.redAccent),
                                const SizedBox(width: 4),
                                Text(
                                  stream["viewers"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Stream Info
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stream["title"]!,
                          style: GoogleFonts.rajdhani(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stream["streamer"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
