import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool loading = true;

  Future<void> loadUserData() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    setState(() {
      userData = doc.data();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.purpleAccent),
        ),
      );
    }

    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("User not found",
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      );
    }

    final pastStreams = [
      {"title": "Epic Valorant Match", "views": "25K", "thumbnail": "https://picsum.photos/400/200?11"},
      {"title": "Cooking Live 🔥", "views": "12K", "thumbnail": "https://picsum.photos/400/200?12"},
      {"title": "IRL Tokyo Walk 🌸", "views": "18K", "thumbnail": "https://picsum.photos/400/200?13"},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile pic
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blueAccent],
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: (userData!["profilePic"] != null &&
                          userData!["profilePic"].isNotEmpty)
                      ? NetworkImage(userData!["profilePic"])
                      : const NetworkImage("https://picsum.photos/200"),
                ),
              ),
              const SizedBox(height: 12),

              // Username
              Text(
                userData!["username"] ?? "StreamerX",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),

              // Email or handle
              Text(
                "@${userData!["username"] ?? "streamerx"}",
                style: const TextStyle(color: Colors.white54, fontSize: 15),
              ),
              const SizedBox(height: 20),

              // Followers / Following + Edit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/followers'),
                    child: _StatCard(
                        label: "Followers",
                        value: userData!["followers"]?.toString() ?? "0"),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/following'),
                    child: _StatCard(
                        label: "Following",
                        value: userData!["following"]?.toString() ?? "0"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    icon: Icons.edit,
                    label: "Edit",
                    onTap: () => Navigator.pushNamed(context, '/editProfile'),
                  ),
                  _ActionButton(
                    icon: Icons.videocam,
                    label: "Go Live",
                    onTap: () => Navigator.pushNamed(context, '/goLive'),
                  ),
                  _ActionButton(
                    icon: Icons.settings,
                    label: "Settings",
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Past Streams
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.play_circle_fill,
                        color: Colors.purpleAccent, size: 22),
                    SizedBox(width: 6),
                    Text(
                      "Past Streams",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pastStreams.length,
                itemBuilder: (context, index) {
                  final stream = pastStreams[index];
                  return _buildStreamTile(
                    stream["title"]!,
                    stream["views"]!,
                    stream["thumbnail"]!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreamTile(String title, String views, String thumbnail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[850]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  thumbnail,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.visibility,
                            size: 16, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Text(
                          "$views views",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.purpleAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onTap,
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.purpleAccent.withOpacity(0.2),
              child: Icon(icon, color: Colors.purpleAccent),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
