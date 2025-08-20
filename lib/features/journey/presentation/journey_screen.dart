import 'package:alumea/features/chat/presentation/widgets/date_separator.dart';
import 'package:alumea/features/journey/application/journey_provider.dart';
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:alumea/features/journey/presentation/widgets/check_in_card.dart';
import 'package:alumea/features/journey/presentation/widgets/conversation_card.dart';
import 'package:alumea/features/journey/presentation/widgets/timeline_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyEntriesAsync = ref.watch(journeyEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Journey')),
      body: journeyEntriesAsync.when(
        data: (groupedEntries) {
          if (groupedEntries.isEmpty) {
            return const Center(child: Text('Your journey will appear here.'));
          }

          // Convert the map to a flat list for the ListView
          final items = <Widget>[];
          groupedEntries.forEach((date, entries) {
            items.add(DateSeparator(date: date));
            items.addAll(entries.map((entry) => _TimelineEntry(entry: entry)));
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

// --- UI Helper Widgets ---

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.entry});
  final JourneyEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The content card on the left
        Expanded(flex: 5, child: _buildEntryCard(context, entry)),
        // The timeline indicator on the right
        SizedBox(height: 120, child: TimeLineNode(entry: entry)),
      ],
    );
  }

  Widget _buildEntryCard(BuildContext context, JourneyEntry entry) {
    return switch (entry) {
      CheckInJourneyEntry() => CheckInCard(entry: entry),
      ConversationJourneyEntry() => ConversationCard(entry: entry),
      _ => const SizedBox(),
    };
  }
}
