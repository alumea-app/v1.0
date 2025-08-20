import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:alumea/features/journey/presentation/widgets/conversation_detail_dialog.dart';
import 'package:flutter/material.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({super.key, required this.entry});
  final ConversationJourneyEntry entry;

  @override
  Widget build(BuildContext context) {
    // We now have the full list of messages, so we'll take the first 2 for our snippet.
    final snippet = entry.messages.take(2).toList();

    return InkWell(
      onTap: () {
        // --- THIS IS THE FIX ---
        // Show our new dialog and pass it the FULL list of messages for that day.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConversationDetailDialog(messages: entry.messages);
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 0.5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Conversation with Lumi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Display the snippet
              ...snippet.map(
                (msg) => Text(
                  '${msg.sender == Sender.user ? "You" : "Lumi"}: "${msg.text}"',
                  style: TextStyle(color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}