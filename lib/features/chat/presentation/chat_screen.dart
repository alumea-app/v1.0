import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. We now watch our new, dedicated `chatHistoryProvider`.
    final messagesAsyncValue = ref.watch(chatHistoryProvider);
    final messageInputController = TextEditingController();

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
            // 2. Use .when to handle the stream's loading/data/error states.
            child: messagesAsyncValue.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text("Say hello to Lumi!"));
                }
                return ListView.builder(
                  // We no longer need to reverse the list here
                  // as it's ordered correctly by timestamp in the repository.
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: messages[index]);
                  },
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
                // 3. Call the sendMessage method on our action controller.
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
}