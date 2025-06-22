import 'dart:convert'; 
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth_io.dart'; // Official Google package for auth
import 'package:http/http.dart' as http; // Standard HTTP package

class ChatRepository {
  // We need to keep track of the access token and the project ID.
  AutoRefreshingAuthClient? _authClient;
  String? _projectId;

  ChatRepository();

  /// Lazily initializes the authenticated client and project ID.
  Future<void> _ensureInitialized() async {
    // This `if` statement ensures we only do the expensive setup work once.
    if (_authClient == null) {
      // 1. Load the service account credentials from the JSON file.
      final jsonCredentials = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            await http.read(Uri.parse('assets/credentials/service-account-key.json'))),
        ['https://www.googleapis.com/auth/cloud-platform'],
      );
      
      // Store the authenticated client and the project ID from the file.
      _authClient = jsonCredentials;
      _projectId = ServiceAccountCredentials.fromJson(
        await http.read(Uri.parse('assets/credentials/service-account-key.json')),
      ).clientId.secret;
    }
  }

  /// Gets an intelligent response from Lumi by calling the Dialogflow API directly.
  Future<ChatMessage> getLumiResponse(String message, String sessionId) async {
    await _ensureInitialized();

    // 2. The official Dialogflow v2 `detectIntent` API endpoint.
    final url = Uri.parse(
        'https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/$sessionId:detectIntent');

    // 3. The headers for our request, including the all-important Authorization token.
    final headers = {
      'Authorization': 'Bearer ${_authClient!.credentials.accessToken.data}',
      'Content-Type': 'application/json',
    };

    // 4. The body of our request, structured as JSON.
    final body = jsonEncode({
      'queryInput': {
        'text': {
          'text': message,
          'languageCode': 'en-US',
        },
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lumiText = data['queryResult']['fulfillmentText'] as String;
        return ChatMessage(text: lumiText, sender: Sender.lumi);
      } else {
        // The API returned a non-200 status code.
        print('Dialogflow API Error: ${response.body}');
        return const ChatMessage(text: "Sorry, I had a moment of confusion.", sender: Sender.lumi);
      }
    } catch (e) {
      // A network error occurred.
      print("Network Error: $e");
      return const ChatMessage(text: "Sorry, I'm having trouble connecting right now.", sender: Sender.lumi);
    }
  }
}

// --- Provider ---

// The provider setup now becomes incredibly simple again!
// It's not async anymore because our repository handles its own lazy initialization.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});