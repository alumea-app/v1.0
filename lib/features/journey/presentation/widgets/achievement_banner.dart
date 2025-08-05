// lib/features/journey/presentation/widgets/achievement_banner.dart
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:flutter/material.dart';

class AchievementBanner extends StatelessWidget {
  final JourneyEntry entry;
  const AchievementBanner({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(entry.icon, color: Theme.of(context).colorScheme.secondary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (entry.subtitle != null) Text(entry.subtitle!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}