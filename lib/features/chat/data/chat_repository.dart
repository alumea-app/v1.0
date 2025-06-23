// lib/features/chat/data/chat_repository.dart
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRepository {
  final FirebaseFunctions _functions;
  ChatRepository(this._functions);

  /// Gets an intelligent response from Lumi by calling our secure Cloud Function.
  Future<ChatMessage> getLumiResponse(String message, String sessionId) async {
    try {
      // 1. Reference the callable function
      final callable = _functions.httpsCallable('getLumiResponse');
      
      // 2. Call the function with the required parameters
      final result = await callable.call<Map<String, dynamic>>({
        'text': message,
        'sessionId': sessionId,
      });

      // 3. Extract the text from the response
      final lumiText = result.data['text'] as String? ?? "Sorry, I had a moment of confusion.";
      return ChatMessage(text: lumiText, sender: Sender.lumi);

    } on FirebaseFunctionsException catch (e) {
      // Handle specific cloud function errors
      print("Cloud Functions Error: ${e.code} - ${e.message}");
      return const ChatMessage(text: "Sorry, I'm having trouble connecting right now.", sender: Sender.lumi);
    } catch (e) {
      // Handle other generic errors
      print("Generic Error: $e");
      return const ChatMessage(text: "Sorry, I had a moment of confusion.", sender: Sender.lumi);
    }
  }
}

// --- Provider ---
// Provider for the FirebaseFunctions instance
final firebaseFunctionsProvider =
    Provider<FirebaseFunctions>((ref) => FirebaseFunctions.instance);

// Updated ChatRepository provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(firebaseFunctionsProvider));
});