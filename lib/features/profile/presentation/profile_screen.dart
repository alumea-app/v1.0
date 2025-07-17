import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Routemaster.of(context).push('/settings');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Profile Screen - Coming Soon!'),
      ),
    );
  }
}