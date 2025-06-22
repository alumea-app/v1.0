import 'package:alumea/features/chat/data/chat_repository.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  // A unique ID for this user's conversation session.
  final String _sessionId = 'unique-user-session-id-${DateTime.now().millisecondsSinceEpoch}';

  @override
  List<ChatMessage> build() => [];
  
  Future<void> sendMessage(String text) async {
    final chatRepository = ref.read(chatRepositoryProvider);
    state = [...state, ChatMessage(text: text, sender: Sender.user)];
    
    // Pass the message AND the session ID to the repository.
    final lumiResponse = await chatRepository.getLumiResponse(text, _sessionId);
    
    state = [...state, lumiResponse];
  }
}