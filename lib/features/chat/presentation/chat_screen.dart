import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final messageInputController = TextEditingController();

  @override
  void dispose() {
    messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsyncValue = ref.watch(chatHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: sessionsAsyncValue.when(
              data: (sessionMap) {
                if (sessionMap.isEmpty) {
                  return const Center(child: Text("Say hello to Lumi!"));
                }
                // Display sessions grouped by day
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: sessionMap.entries.expand((entry) {
                    final session = entry.key;
                    final messages = entry.value;
                    return [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            _formatSessionDate(session.startedAt),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      ...messages.map((msg) => MessageBubble(message: msg)),
                    ];
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Something went wrong: $err')),
            ),
          ),
          MessageInputBar(
            controller: messageInputController,
            onSend: () {
              if (messageInputController.text.trim().isNotEmpty) {
                ref
                    .read(chatControllerProvider.notifier)
                    .sendMessage(messageInputController.text.trim());
                messageInputController.clear();
              }
            },
          ),
        ],
      ),
    );

  }

  String _formatSessionDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
  }

