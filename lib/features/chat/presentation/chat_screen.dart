import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:alumea/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:alumea/features/chat/presentation/widgets/date_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController _messageInputController;
  late final ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _handleProactiveMessage();
      }
    });
    _messageInputController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _scrollController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleProactiveMessage() {
    final source = Routemaster.of(
      context,
    ).currentRoute.queryParameters['source'];
    if (source == 'checkin') {
      ref.read(chatControllerProvider.notifier).addProactiveLumiMessage();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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
      if (next.hasValue &&
          (previous?.value?.length ?? 0) < next.value!.length) {
        _scrollToBottom();
      }
    });

    final messagesAsyncValue = ref.watch(chatHistoryProvider);
    final isLumiTyping = ref.watch(isLumiTypingProvider);

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

                // Build a list with date separators
                final List<Widget> chatItems = [];
                DateTime? lastDate;

                // Messages are reversed for ListView (newest at bottom)
                for (int i = 0; i < messages.length; i++) {
                  final msg = messages[i];
                  final msgDate = msg.timestamp ?? DateTime.now();

                  final isNewDay =
                      lastDate == null ||
                      msgDate.year != lastDate.year ||
                      msgDate.month != lastDate.month ||
                      msgDate.day != lastDate.day;

                  if (isNewDay) {
                    chatItems.add(DateSeparator(date: msgDate));
                  }

                  chatItems.add(MessageBubble(message: msg));
                  lastDate = msgDate;
                }

                // Reverse for ListView.builder with reverse: true
                final reversedItems = chatItems.reversed.toList();

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: reversedItems.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return reversedItems[index];
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
