// lib/features/chat/presentation/chat_screen.dart
import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is the "main" chat feature provider.
    final messages = ref.watch(chatControllerProvider);
    final messageInputController = TextEditingController();

    return Scaffold(
      // --- The AppBar ---
      // This makes it feel like a real home screen.
      appBar: AppBar(
        title: const Text('Lumi'),
        elevation: 0, // A flatter, more modern look
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              // Simply call the sign-out method.
              // Our new AuthGuard in the router will now handle the redirect automatically.
              ref.read(authRepositoryProvider).signOut();
            },
          )
        ],
      ),

      // --- The Body ---
      body: Column(
        children: [
          // The list of chat messages.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              reverse: true, // New messages appear from the bottom, like a real chat app.
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // We show messages in reverse order to match the reversed list.
                final reversedIndex = messages.length - 1 - index;
                return MessageBubble(message: messages[reversedIndex]);
              },
            ),
          ),
          
          // The message input bar.
          MessageInputBar(
            controller: messageInputController,
            onSend: () {
              if (messageInputController.text.trim().isNotEmpty) {
                ref.read(chatControllerProvider.notifier)
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