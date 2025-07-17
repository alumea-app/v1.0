import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text("Start a conversation with Lumi"),
          onPressed: () {
            Routemaster.of(context).push('/chat');
          },
        ),
      ),
    );
  }
}