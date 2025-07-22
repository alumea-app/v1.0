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
  final ScrollController _scrollController = ScrollController();

  int _previousMessageCount = 0;

  @override
  void dispose() {
    messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      // Use a small delay to ensure the UI has been updated with the new message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Helper method to dismiss the keyboard
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
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
                // Filter sessions to only show today's session
                final today = DateTime.now();
                final todayEntries = sessionMap.entries.where((entry) {
                  final sessionDate = entry.key.startedAt;
                  return sessionDate.year == today.year &&
                      sessionDate.month == today.month &&
                      sessionDate.day == today.day;
                }).toList();

                if (todayEntries.isEmpty) {
                  return const Center(child: Text("Say hello to Lumi!"));
                }
                // Count total messages to detect when new ones are added
                final totalMessages = todayEntries.fold<int>(
                    0, (sum, entry) => sum + entry.value.length);

                // Auto-scroll when new messages are detected
                if (totalMessages > _previousMessageCount) {
                  _previousMessageCount = totalMessages;
                  _scrollToBottom();
                }
                // Display sessions grouped by day
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: todayEntries.fold<int>(
                      0,
                      (sum, entry) =>
                          sum + entry.value.length + 1 // +1 for date header
                      ),
                  itemBuilder: (context, index) {
                    int currentIndex = 0;

                    for (final entry in todayEntries) {
                      final session = entry.key;
                      final messages = entry.value;

                      // Check if this is the date header
                      if (index == currentIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              _formatSessionDate(session.startedAt),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        );
                      }
                      currentIndex++;

                      // Check if this is one of the message bubbles
                      final messageIndex = index - currentIndex;
                      if (messageIndex >= 0 && messageIndex < messages.length) {
                        return MessageBubble(message: messages[messageIndex]);
                      }

                      currentIndex += messages.length;
                    }

                    return const SizedBox.shrink(); // Fallback
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Something went wrong: $err')),
            ),
          ),
          MessageInputBar(
            controller: messageInputController,
            onSend: () {
              if (messageInputController.text.trim().isNotEmpty) {
                // Dismiss keyboard immediately when sending
                _dismissKeyboard();
                
                // Send the message
                ref
                    .read(chatControllerProvider.notifier)
                    .sendMessage(messageInputController.text.trim());
                messageInputController.clear();
                
                // Scroll to bottom to show the new message
                _scrollToBottom();
              }
            },
          ),
        ],
      ),
    );
  }

  String _formatSessionDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}