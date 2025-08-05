// lib/features/check_in/presentation/reflection_screen.dart
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ReflectionScreen extends StatefulWidget {
  final int moodRating; // We pass in the mood rating to display the right content
  const ReflectionScreen({super.key, required this.moodRating});

  @override
  _ReflectionScreenState createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {

  // A map to hold the content for each mood state
  static const Map<int, Map<String, String>> moodContent = {
    1: {'emoji': '😭', 'message': 'It\'s okay to feel this way.'},
    2: {'emoji': '😟', 'message': 'Acknowledging your feelings is a brave step.'},
    3: {'emoji': '😐', 'message': 'Just being is enough for today.'},
    4: {'emoji': '🙂', 'message': 'Good to see you\'re feeling positive.'},
    5: {'emoji': '😁', 'message': 'Hold onto this wonderful feeling.'},
  };

  @override
  void initState() {
    super.initState();
    // The core of the "Smart Transition"
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      if (widget.moodRating <= 3) {
        // If the mood is neutral or negative, guide to chat
        // Pass a query parameter to tell the chat screen to show the proactive message
        Routemaster.of(context).replace('/chat?source=checkin'); 
      } else {
        // If the mood is positive, go back home. `pop()` is fine here.
        Routemaster.of(context).pop(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the specific emoji and message for the user's mood rating.
    final content = moodContent[widget.moodRating] ?? moodContent[3]!;
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content['emoji']!,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 32),
              Text(
                content['message']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Text(
                'Your check-in has been saved to your Journey.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}