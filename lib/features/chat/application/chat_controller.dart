import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alumea/features/chat/data/chat_repository.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

final isLumiTypingProvider = StateProvider<bool>((ref) => false);

// THIS IS NOW THE SINGLE SOURCE OF TRUTH FOR THE UI's DATA
@riverpod
Stream<List<ChatMessage>> chatHistory(Ref ref) {
  return ref.watch(chatRepositoryProvider).getChatHistoryStream();
}

// This controller is ONLY for actions. It holds no state.
@riverpod
class ChatController extends _$ChatController {
  StreamSubscription? _responseSubscription;
    // A unique session ID for the AI conversation.
  final String _sessionId = 'session-${DateTime.now().millisecondsSinceEpoch}';

  @override
  FutureOr<void> build() {
    ref.onDispose(() => _responseSubscription?.cancel());
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final chatRepository = ref.read(chatRepositoryProvider);
    final userMessage = ChatMessage(text: text, sender: Sender.user, timestamp: DateTime.now());

    // 1. Save the user's message. The UI will update instantly via the stream.
    await chatRepository.saveMessageToHistory(userMessage);
    ref.read(isLumiTypingProvider.notifier).state = true;

    // 2. Trigger the Gemini extension.
    final promptDocRef = await chatRepository.createPrompt(text);

    // 3. Listen for the response and save it. The UI will update instantly.
    _responseSubscription?.cancel();
    _responseSubscription =
        chatRepository.getResponseStream(promptDocRef).listen((response) {
      if (response != null && response.isNotEmpty) {
        ref.read(isLumiTypingProvider.notifier).state = false;
        final lumiMessage = ChatMessage(text: response, sender: Sender.lumi, timestamp: DateTime.now());
        chatRepository.saveMessageToHistory(lumiMessage);
        _responseSubscription?.cancel();
      }
    });
  }

   Future<void> addProactiveLumiMessage() async {
    final chatRepository = ref.read(chatRepositoryProvider);
    final proactiveMessage = ChatMessage(
      text: "I see you're having a difficult day. If you'd like to talk about what's on your mind, I'm here to listen.",
      sender: Sender.lumi,
    );
    
    // Check if this exact message is already the last message to prevent duplicates.
    final history = ref.read(chatHistoryProvider).asData?.value ?? [];
    if (history.isEmpty || history.last.text != proactiveMessage.text) {
        // Save this special message to Firestore. The UI will update automatically
        // because it is watching the `chatHistoryProvider` stream.
        await chatRepository.saveMessageToHistory(proactiveMessage);
    }
  }
}