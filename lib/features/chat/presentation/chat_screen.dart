import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:alumea/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The screen MUST be a ConsumerStatefulWidget to manage controllers.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  // Controllers are defined here, outside the build method.
  late final TextEditingController _messageInputController;
  late final ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Controllers are initialized ONCE when the widget is first created.
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Controllers are disposed of when the widget is destroyed to prevent memory leaks.
    _messageInputController.dispose();
    _scrollController.dispose();
     _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

   void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // If the text field gains focus, scroll to the bottom
      _scrollToBottom();
    }
  }

   void _scrollToBottom() {
    // A short delay ensures the keyboard is up before we scroll
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(chatHistoryProvider, (previous, next) {
      if (next.hasValue && (previous?.value?.length ?? 0) < next.value!.length) {
        _scrollToBottom(); // Use our new helper method
      }
    });

    // We watch our single source of truth for the message list.
    final messagesAsyncValue = ref.watch(chatHistoryProvider);
     final isLumiTyping = ref.watch(isLumiTypingProvider);

    // Listen to the provider to auto-scroll when new messages arrive.
    // ref.listen(chatHistoryProvider, (_, next) {
    //   Future.delayed(const Duration(milliseconds: 50), () {
    //     if (_scrollController.hasClients) {
    //       _scrollController.animateTo(
    //         _scrollController.position.maxScrollExtent,
    //         duration: const Duration(milliseconds: 300),
    //         curve: Curves.easeOut,
    //       );
    //     }
    //   });
    // });

    return Scaffold(
      appBar: AppBar(title: const Text('Lumi')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsyncValue.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text("Say hello to Lumi!"));
                }
                return ListView.builder(
                  controller: _scrollController, // Use the persistent controller
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return MessageBubble(message: messages[messages.length - 1 -index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
           if (isLumiTyping) const TypingIndicator(),
          MessageInputBar(
            controller: _messageInputController,
            focusNode: _focusNode,
            onSend: () {
              final text = _messageInputController.text.trim();
              if (text.isNotEmpty) {
                ref.read(chatControllerProvider.notifier).sendMessage(text);
                _messageInputController.clear();
                _focusNode.unfocus();
              }
            },
          ),
        ],
      ),
    );
  }
}