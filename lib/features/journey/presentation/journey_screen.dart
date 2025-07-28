// lib/features/journey/presentation/journey_screen.dart
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:alumea/features/journey/presentation/widgets/achievement_banner.dart';
import 'package:alumea/features/journey/presentation/widgets/timeline_entry_card.dart';
import 'package:flutter/material.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: dummyEntries.length,
        itemBuilder: (context, index) {
          final entry = dummyEntries[index];

          // We use a custom widget to handle the timeline layout logic
          return TimelineEntry(
            entry: entry,
            isFirst: index == 0,
            isLast: index == dummyEntries.length - 1,
            // Simple logic for alternating sides. You could make this more complex.
            isLeftAligned: index.isEven,
          );
        },
      ),
    );
  }
}