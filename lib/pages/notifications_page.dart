import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.live_tv, color: Colors.red),
            title: Text("Streamer $index is live!"),
            subtitle: const Text("Just now"),
          );
        },
      ),
    );
  }
}
