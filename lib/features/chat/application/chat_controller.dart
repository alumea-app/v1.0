import 'dart:async';
import 'package:alumea/features/chat/data/chat_repository.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

// 1. NEW: Create a dedicated StreamProvider for the chat history.
// This provider will watch the stream from the repository and expose it to the UI.
@riverpod
Stream<List<ChatMessage>> chatHistory(ChatHistoryRef ref) {
  return ref.watch(chatRepositoryProvider).getChatHistoryStream();
}


// 2. REFACTORED: The controller is now much simpler.
// It is only responsible for performing actions, not for holding state.
@riverpod
class ChatController extends _$ChatController {
  StreamSubscription? _responseSubscription;
  
  // The build method is now empty as this is an action-only controller.
  @override
  void build() {
    ref.onDispose(() {
      _responseSubscription?.cancel();
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final chatRepository = ref.read(chatRepositoryProvider);
    final userMessage = ChatMessage(text: text, sender: Sender.user);

    // Save the user's message to history. The UI will update automatically
    // because it's listening to the chatHistoryProvider stream.
    await chatRepository.saveMessageToHistory(userMessage);

    // Trigger the Gemini extension and listen for the response.
    final promptDocRef = await chatRepository.createPrompt(text);
    _responseSubscription?.cancel();
    _responseSubscription =
        chatRepository.getResponseStream(promptDocRef).listen((response) {
      if (response != null && response.isNotEmpty) {
        final lumiMessage = ChatMessage(text: response, sender: Sender.lumi);
        // Save Lumi's message. The UI will update automatically.
        chatRepository.saveMessageToHistory(lumiMessage);
        _responseSubscription?.cancel();
      }
    });
  }
}