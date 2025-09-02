import 'package:flutter/material.dart';

class FollowersPage extends StatelessWidget {
  const FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Followers")),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text("User $index"),
            subtitle: const Text("Follower"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Follow Back"),
            ),
          );
        },
      ),
    );
  }
}
