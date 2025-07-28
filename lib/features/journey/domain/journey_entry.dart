// lib/features/journey/domain/journey_entry.dart
import 'package:flutter/material.dart';

enum EntryType { checkIn, chat, tool, achievement, dateSeparator }

class JourneyEntry {
  final String title;
  final String? subtitle;
  final EntryType type;
  final IconData icon;

  JourneyEntry({
    required this.title,
    this.subtitle,
    required this.type,
    required this.icon,
  });
}

// --- DUMMY DATA for the example ---
final List<JourneyEntry> dummyEntries = [
  JourneyEntry(type: EntryType.dateSeparator, title: 'JULY 25, 2024', icon: Icons.calendar_today),
  JourneyEntry(
      type: EntryType.checkIn,
      title: 'Daily Check-in',
      subtitle: 'Feeling: Happy',
      icon: Icons.sentiment_satisfied_alt_outlined),
  JourneyEntry(
      type: EntryType.tool,
      title: 'Tool Completed',
      subtitle: '3-min Breathing Exercise',
      icon: Icons.check_circle_outline),
  JourneyEntry(
      type: EntryType.chat,
      title: 'Conversation with Lumi',
      subtitle: 'You: "I\'m so anxious..."\nLumi: "That sounds heavy..."',
      icon: Icons.chat_bubble_outline),
  JourneyEntry(
      type: EntryType.achievement,
      title: '🎉 5-Day Check-in Streak!',
      subtitle: 'You\'re building a powerful habit.',
      icon: Icons.star_border),
  JourneyEntry(type: EntryType.dateSeparator, title: 'JULY 24, 2024', icon: Icons.calendar_today),
  JourneyEntry(
      type: EntryType.checkIn,
      title: 'Daily Check-in',
      subtitle: 'Feeling: Anxious',
      icon: Icons.sentiment_dissatisfied_outlined),
];