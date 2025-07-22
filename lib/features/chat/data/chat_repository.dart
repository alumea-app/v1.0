import 'dart:async';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository(this.firestore, this.auth);

  String? get userId => auth.currentUser?.uid;

  // --- THIS IS THE ONLY STREAM WE NEED ---
  /// Gets the user's entire chat history as a real-time stream.
  /// Firestore handles all updates automatically.
  Stream<List<ChatMessage>> getChatHistoryStream() {
    if (userId == null) return Stream.value([]);
    return firestore
        .collection('users')
        .doc(userId)
        .collection('chat_history')
        .orderBy('timestamp', descending: false) // Always order oldest-to-newest
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          text: data['text'],
          sender: data['sender'] == 'lumi' ? Sender.lumi : Sender.user,
          timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
        );
      }).toList();
    });
  }

  // --- Action methods remain the same ---
  Future<void> saveMessageToHistory(ChatMessage message) async {
    if (userId == null) return;
    await firestore
        .collection('users')
        .doc(userId)
        .collection('chat_history')
        .add({
      'text': message.text,
      'sender': message.sender.name,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentReference> createPrompt(String text) {
    return firestore.collection('conversations').add({'prompt': text});
  }

  Stream<String?> getResponseStream(DocumentReference docRef) {
    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['response'] as String?;
    });
  }
}

// --- Providers (No changes needed) ---
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});